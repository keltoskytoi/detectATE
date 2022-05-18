####################################SHORTCUTS###################################
lsRGBIR <- list.files(file.path(path_RGB_IR), pattern=".tif")
lspredictor1 <- list.files(file.path(path_prdctr1), pattern=".tif")
lspredictor2 <- list.files(file.path(path_prdctr2), pattern=".tif")
lspredictor3 <- list.files(file.path(path_prdctr3), pattern=".tif")
lspredictor4 <- list.files(file.path(path_prdctr4), pattern=".tif")
lspredictor5 <- list.files(file.path(path_prdctr5), pattern=".tif")
lspredictor6 <- list.files(file.path(path_prdctr6), pattern=".tif")
lspredictor7 <- list.files(file.path(path_prdctr7), pattern=".tif")
lspredictor8 <- list.files(file.path(path_prdctr8), pattern=".tif")
lspredictor10 <- list.files(file.path(path_prdctr10), pattern=".tif")

lsRGBIR
#[1] "IR_1.tif"          "IR_1.tif.aux.xml"  "IR_2.tif"
#[4] "IR_2.tif.aux.xml"  "IR_3.tif"          "IR_3.tif.aux.xml"
#[7] "IR_4.tif"          "IR_4.tif.aux.xml"  "IR_ROI.tif"
#[10] "RGB_1.tif"         "RGB_1.tif.aux.xml" "RGB_2.tif"
#[13] "RGB_2.tif.aux.xml" "RGB_3.tif"         "RGB_3.tif.aux.xml"
#[16] "RGB_4.tif"         "RGB_4.tif.aux.xml" "RGB_ROI.tif"
                  ####PREPARATION OF TRAINING AREA 1####
####################################LOAD DATA###################################
#RGB of area 1####
RGB_1 <- raster::stack(paste0(path_RGB_IR, lsRGBIR[[10]]))
crs(RGB_1)
#+proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel +units=m
#+no_defs
#check the names and the band order!
names(RGB_1)
#"Red"   "Green" "Blue"

#IR of area 1####
IR_1  <-  raster(paste0(path_RGB_IR, lsRGBIR[[1]]))
crs(IR_1)
# +proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel +units=m
#+no_defs
names(IR_1)
#"IR_1"

#stack RGB & IR of area 1####
RGBNIR_1 <- raster::stack(RGB_1, IR_1)
names(RGBNIR_1)
#"Red"   "Green" "Blue"  "IR_1"

####################################COMPUTE INDICES#############################
##Compute RGB indices -11 layer ####
RGB_1_ind <- LEGION::vegInd_RGB(RGB_1, 1,2,3, indlist="all")
names(RGB_1_ind)
#[1] "VVI"   "VARI"  "NDTI"  "RI"    "CI"    "BI"    "SI"    "HI"    "TGI"   "GLI"   "NGRDI"

#it was understood from testing, that VARI, HI, RI contain too homogeneous areas,
#which distort the prediction - 8 layer
vi <-c("VVI","NDTI", "CI", "BI", "SI","TGI", "GLI", "NGRDI")
RGB_1_ind2 <- LEGION::vegInd_RGB(RGB_1, 1,2,3, indlist=vi)
names(RGB_1_ind2)
#[1] "VVI"   "NDTI"  "CI"    "BI"    "SI"    "TGI"   "GLI"   "NGRDI"

#plot and inspect the RGB indices!
plot(RGB_1_ind)

#Compute RGBNIR indices - 4 layer####
RGBNIR_1_ind <- LEGION::vegInd_mspec(RGBNIR_1, 1,2,3,4, indlist="all")
names(RGBNIR_1_ind)
#[1] "NDVI" "TDVI" "SR"   "MSR"

                          ####MERGE RASTER STACKS#####
ALL_1_stack <- raster::stack(RGB_1_ind, RGBNIR_1_ind) # 15 layer
names(ALL_1_stack)
#[1] "VVI"   "VARI"  "NDTI"  "RI"    "CI"    "BI"    "SI"    "HI"    "TGI"
#"GLI"   "NGRDI" "NDVI" "TDVI"  "SR"    "MSR

#without VARI, HI, RI - 12 layer
ALL_1_stack2 <- raster::stack(RGB_1_ind2, RGBNIR_1_ind)
names(ALL_1_stack2)
#[1] "VVI"   "NDTI"  "CI"    "BI"    "SI"    "TGI"   "GLI"   "NGRDI" "NDVI"
#"TDVI"  "SR"    "MSR"

#RGB indices + Spectral indices + RGB + NIR - 19 layer
ALL_1_stack3 <- raster::stack(RGB_1_ind, RGBNIR_1_ind, RGBNIR_1)
names(ALL_1_stack3)
#[1] "VVI"   "VARI"  "NDTI"  "RI"    "CI"    "BI"    "SI"    "HI"
#[9] "TGI"   "GLI"   "NGRDI" "NDVI"  "TDVI"  "SR"    "MSR"   "Red"
#[17] "Green" "Blue"  "IR_1"

               ####TEST RASTER STACKS ON HOMOGENEITY#####
#to check which homogeneity size to choose plot all the RGB indices to understand
#which index gets kicked out and why
plot(ALL_1_stack3)
#leave out HI based on experience: homogeneity 0.7 clears VVI, VARI and RI so we
#have to subtract HI extra not to pure too many indices which could be meaningful
ALL_1_stack3 <- ALL_1_stack3[[-8]]
names(ALL_1_stack3)
#[1] "VVI"   "VARI"  "NDTI"  "RI"    "CI"    "BI"    "SI"    "TGI"   "GLI"
#[10] "NGRDI" "NDVI"  "TDVI"  "SR"    "MSR"   "Red"   "Green" "Blue"  "IR_1"

#Detect homogeneity in the ALL_1_stack = all indices ####
#let's test when which indices get left out!

ALL_1_stack_homog04 <- LEGION::detct_RstHmgy(ALL_1_stack, 0.4)
#dropping from Stack: VVI, VARI, RI, SI, HI, GLI # 9 layer
names(ALL_1_stack_homog04)
#[1] "NDTI"  "CI"    "BI"    "TGI"   "NGRDI" "NDVI"  "TDVI"  "SR"    "MSR"

ALL_1_stack_homog05 <- LEGION::detct_RstHmgy(ALL_1_stack, 0.5)
#dropping from Stack: VVI, VARI, RI, SI #11 layer
ALL_1_stack_homog06 <- LEGION::detct_RstHmgy(ALL_1_stack, 0.6)
#dropping from Stack: VVI, VARI, RI #12 layer

ALL_1_stack_homog07 <- LEGION::detct_RstHmgy(ALL_1_stack, 0.7)
#dropping from Stack: VVI, VARI, RI # 12 layer
names(ALL_1_stack_homog07)
#[1] "NDTI"  "CI"    "BI"    "SI"    "HI"    "TGI"   "GLI"   "NGRDI" "NDVI"  "TDVI"
#[11] "SR"    "MSR"

ALL_1_stack_homog08 <- LEGION::detct_RstHmgy(ALL_1_stack, 0.8)
#dropping from Stack: VARI, RI
ALL_1_stack_homog09 <- LEGION::detct_RstHmgy(ALL_1_stack, 0.9)
#dropping from Stack: RI

#let's go with homogeneity 0.7!

#decided: ALL_1_stack_homog07 -HI
names(ALL_1_stack_homog07)
#[1] "NDTI"  "CI"    "BI"    "SI"    "HI"    "TGI"   "GLI"   "NGRDI" "NDVI"  "TDVI"
#[11] "SR"    "MSR"
ALL_1_stack_homog07_2 <- ALL_1_stack_homog07[[-5]]
names(ALL_1_stack_homog07_2) # 11 layer
#[1] "NDTI"  "CI"    "BI"    "SI"    "TGI"   "GLI"   "NGRDI" "NDVI"  "TDVI"  "SR"    "MSR"

ALL_1_stack3_homog07 <- LEGION::detct_RstHmgy(ALL_1_stack3, 0.7)
#dropping from Stack: VVI, VARI, RI

#####################################FILTER INDICES#############################
#Because the area is small, a MovingWindow of size 3 is enough

#to leave out the max/min filter####
flist <- c("sum","sd","mean","modal","sobel","sobel_hrzt","sobel_vert")

#all stack filtered #135 layer####
ALL_1_stack_filtered <-LEGION::filter_Stk(ALL_1_stack, sizes=3)

#without min & max filter & without VARI, HI, RI = 84 layer####
ALL_1_stack_filtered2 <-LEGION::filter_Stk(ALL_1_stack2, flist, sizes=3)

#with all filter & without VARI, HI, RI = 108 layer####
ALL_1_stack_filtered3 <-LEGION::filter_Stk(ALL_1_stack2, sizes=3)

#all stack + homogeneity 0.7 + all filter = 108 layer####
ALL_1_stack_homog07_filt <-LEGION::filter_Stk(ALL_1_stack_homog07, sizes=3)

#all stack + homogeneity 0.7 + without min & max filter = 84 layer####
ALL_1_stack_homog07_filt2 <-LEGION::filter_Stk(ALL_1_stack_homog07, flist, sizes=3)

#all stack + homogeneity 0.4 + all filter = 81 layer####
ALL_1_stack_homog04_filt <-LEGION::filter_Stk(ALL_1_stack_homog04, sizes=3)

#all stack + homogeneity 0.4 + without min & max filter = 63 layer####
ALL_1_stack_homog04_filt2 <-LEGION::filter_Stk(ALL_1_stack_homog04, flist, sizes=3)

#all stack + homogeneity 0.7 - HI + without min & max filter = 77 layer####
ALL_1_stack_homog07_2_filt3 <-LEGION::filter_Stk(ALL_1_stack_homog07_2, flist, sizes=3)

#from expereince: all stack + RGB + NIR -HI homogeneity 0.7 - min/max filter = 105 layer####
ALL_1_stack3_homog07_filt <-LEGION::filter_Stk(ALL_1_stack3_homog07, flist, sizes=3)

###############################TEST INDICES ON CORRELATION######################
#remove correlating RasterLayers - change correlation levels!
#it was tested  that with 0.9 more layers are left -for the FFS

#PREDICTORS 1 - 28 layer ####
#all indices, all filter
clean_ALL_1_stack_filtered_09 <- LEGION::detct_RstCor(ALL_1_stack_filtered, 0.9)
#INF values detected: setting  26354 INF to NA
#NAs detected: deleting 184076  NAs
names(clean_ALL_1_stack_filtered_09)
#[1] "VVI_min3"       "VVI_modal3"     "VVI_sobel3"     "VVI_sobel_v3"
#[5] "VARI_min3"      "VARI_sd3"       "VARI_modal3"    "VARI_sobel_v3"
#[9] "RI_sum3"        "RI_min3"        "RI_sd3"         "RI_modal3"
#[13] "RI_sobel_v3"    "SI_max3"        "SI_sobel3"      "SI_sobel_v3"
#[17] "HI_max3"        "HI_sd3"         "HI_sobel_v3"    "TGI_max3"
#[21] "TGI_sobel3"     "TGI_sobel_v3"   "GLI_sobel3"     "NGRDI_sobel_v3"
#[25] "TDVI_sobel3"    "SR_sobel3"      "MSR_min3"       "MSR_sobel_v3"

writeRaster(clean_ALL_1_stack_filtered_09, paste0(path_prdctr1,
            filename = names(clean_ALL_1_stack_filtered_09), "_corr_09_pred_1.tif"),
            format="GTiff", bylayer=TRUE, overwrite=TRUE)

#PREDICTORS 2 - 18 layer####
#without min & max filter & without VARI, HI, RI
clean_ALL_1_stack_filtered2_09 <- LEGION::detct_RstCor(ALL_1_stack_filtered2, 0.9)
#NAs detected: deleting 85272  NAs
names(clean_ALL_1_stack_filtered2_09)
#[1] "VVI_sum3"     "VVI_sd3"      "VVI_modal3"   "VVI_sobel_h3" "SI_sum3"      "SI_sd3"
#[7] "SI_sobel_h3"  "GLI_modal3"   "GLI_sobel3"   "GLI_sobel_v3" "TGI_sum3"     "TGI_sd3"
#[13] "TGI_sobel_h3" "TDVI_sd3"     "SR_sd3"       "MSR_sd3"      "MSR_modal3"   "MSR_sobel_h3"

writeRaster(clean_ALL_1_stack_filtered2_09, paste0(path_prdctr2,
            filename = names(clean_ALL_1_stack_filtered2_09), "_corr_09_pred_2.tif"),
            format="GTiff", bylayer=TRUE, overwrite=TRUE)

#PREDICTORS 3 - 18 layer####
#with all filter & without VARI, HI, RI
clean_ALL_1_stack_filtered3_09 <- LEGION::detct_RstCor(ALL_1_stack_filtered3, 0.9)
#INF values detected: setting  26 INF to NA
#NAs detected: deleting 109634  NAs
names(clean_ALL_1_stack_filtered3_09)
# [1] "VVI_min3"     "VVI_modal3"   "VVI_sobel3"   "VVI_sobel_v3" "SI_max3"      "SI_sobel3"
#[7] "SI_sobel_v3"  "GLI_modal3"   "GLI_sobel3"   "GLI_sobel_v3" "TGI_max3"     "TGI_sobel3"
#[13] "TGI_sobel_v3" "NDVI_min3"    "TDVI_sobel3"  "SR_sobel3"    "MSR_min3"     "MSR_sobel_v3"

writeRaster(clean_ALL_1_stack_filtered3_09, paste0(path_prdctr3,
            filename = names(clean_ALL_1_stack_filtered3_09), "_corr_09_pred_3.tif"),
            format="GTiff", bylayer=TRUE, overwrite=TRUE)

#PREDICTORS 4 - 16 layer ####
#all stack + homogeneity 0.7 + all filter
clean_ALL_1_stack_homog07_filt_09 <- LEGION::detct_RstCor(ALL_1_stack_homog07_filt, 0.9)
#INF values detected: setting  18948 INF to NA
#NAs detected: deleting 144138  NAs
names(clean_ALL_1_stack_homog07_filt_09)
# [1] "SI_max3"      "SI_sobel3"    "SI_sobel_v3"  "HI_max3"      "HI_sd3"       "HI_sobel_v3"
#[7] "TGI_max3"     "TGI_sobel3"   "TGI_sobel_v3" "GLI_max3"     "GLI_sobel3"   "GLI_sobel_v3"
#[13] "TDVI_sobel3"  "SR_sobel3"    "MSR_min3"     "MSR_sobel_v3"

writeRaster(clean_ALL_1_stack_homog07_filt_09, paste0(path_prdctr4,
            filename = names(clean_ALL_1_stack_homog07_filt_09), "_corr_09_pred_4.tif"),
            format="GTiff", bylayer=TRUE, overwrite=TRUE)

#PREDICTORS 5 - 17 layer####
#all stack + homogeneity 0.7 + without min & max filter
clean_ALL_1_stack_homog07_filt2_09 <- LEGION::detct_RstCor(ALL_1_stack_homog07_filt2, 0.9)
#IINF values detected: setting  12710 INF to NA
#NAs detected: deleting 113564  NAs
names(clean_ALL_1_stack_homog07_filt2_09)
#[1] "SI_sd3"       "SI_mean3"     "SI_sobel_h3"  "HI_sum3"      "HI_sobel3"    "HI_sobel_h3"
#[7] "TGI_sum3"     "TGI_sd3"      "TGI_sobel_h3" "GLI_sd3"      "GLI_modal3"   "GLI_sobel_v3"
#[13] "TDVI_sd3"     "SR_sd3"       "MSR_sd3"      "MSR_modal3"   "MSR_sobel_h3"
writeRaster(clean_ALL_1_stack_homog07_filt2_09, paste0(path_prdctr5,
            filename = names(clean_ALL_1_stack_homog07_filt2_09), "_corr_09_pred_5.tif"),
            format="GTiff", bylayer=TRUE, overwrite=TRUE)

#in another round the result was:
#[1] "SI_sd3"       "SI_mean3"     "SI_sobel_h3"  "HI_mean3"     "HI_sobel3"    "HI_sobel_h3"
#[7] "TGI_sum3"     "TGI_sd3"      "TGI_sobel_h3" "GLI_sd3"      "GLI_modal3"   "GLI_sobel_v3"
#[13] "TDVI_sd3"     "SR_sd3"       "MSR_sd3"      "MSR_modal3"   "MSR_sobel_h3"

#PREDICTORS 6 - 11 layer####
#all stack + homogeneity 0.4 + all filter
clean_ALL_1_stack_homog04_filt_09 <- LEGION::detct_RstCor(ALL_1_stack_homog04_filt, 0.9)
#NAs detected: deleting 82134  NAs
names(clean_ALL_1_stack_homog04_filt_09)
#[1] "TGI_min3"       "TGI_sd3"        "TGI_sobel_h3"   "NGRDI_min3"     "NGRDI_sd3"      "NGRDI_sobel_h3"
#[7] "NDVI_sobel3"    "TDVI_sd3"       "MSR_min3"       "MSR_sd3"        "MSR_sobel_h3"
writeRaster(clean_ALL_1_stack_homog04_filt_09, paste0(path_prdctr6,
            filename = names(clean_ALL_1_stack_homog04_filt_09), "_corr_09_pred_6.tif"),
            format="GTiff", bylayer=TRUE, overwrite=TRUE)

#PREDICTORS 7 - 11 layer####
#all stack + homogeneity 0.4 & - min/max filter
clean_ALL_1_stack_homog04_filt2_09 <- LEGION::detct_RstCor(ALL_1_stack_homog04_filt2, 0.9)
#NAs detected: deleting 63882  NAs
names(clean_ALL_1_stack_homog04_filt2_09)
#[1] "TGI_sum3"       "TGI_sd3"        "TGI_sobel_h3"   "NGRDI_sd3"      "NGRDI_sobel_h3" "NDVI_modal3"
#[7] "NDVI_sobel3"    "TDVI_sd3"       "MSR_sd3"        "MSR_modal3"     "MSR_sobel_h3"

writeRaster(clean_ALL_1_stack_homog04_filt2_09, paste0(path_prdctr7,
            filename = names(clean_ALL_1_stack_homog04_filt2_09), "_corr_09_pred_7.tif"),
            format="GTiff", bylayer=TRUE, overwrite=TRUE)

#in another round the result was:
#[1] "TGI_sd3"        "TGI_mean3"      "TGI_sobel_h3"   "NGRDI_sd3"      "NGRDI_sobel_h3"
#[6] "NDVI_modal3"    "NDVI_sobel3"    "TDVI_sd3"       "MSR_sd3"        "MSR_modal3"
#[11] "MSR_sobel_h3"

#PREDICTORS 8 - 15 layer####
#all stack + homogeneity 0.7 - HI + without min & max filter
clean_ALL_1_stack_homog07_2_filt3_09 <- LEGION::detct_RstCor(ALL_1_stack_homog07_2_filt3, 0.9)
#NAs detected: deleting 78174  NAs
names(clean_ALL_1_stack_homog07_2_filt3_09)
#[1] "CI_sobel3"    "BI_sobel_v3"  "SI_sum3"      "SI_sd3"       "SI_sobel_h3"  "TGI_sd3"
#[7] "TGI_mean3"    "TGI_sobel_h3" "GLI_sd3"      "GLI_modal3"   "GLI_sobel_v3" "TDVI_sd3"
#[13] "SR_sd3"       "MSR_sd3"      "MSR_modal3"
writeRaster(clean_ALL_1_stack_homog07_2_filt3_09, paste0(path_prdctr8,
            filename = names(clean_ALL_1_stack_homog07_2_filt3_09), "_corr_09_pred_8.tif"),
            format="GTiff", bylayer=TRUE, overwrite=TRUE)

#PREDICTOR 9 see next .R file! ####
#PREDICTOR 10 - 14 layer####
##from experience: all stack + RGB + NIR -HI homogeneity 0.7 - min/max filter
clean_ALL_1_stack3_homog07_filt_09 <- LEGION::detct_RstCor(ALL_1_stack3_homog07_filt, 0.9)
#NAs detected: deleting 106566  NAs
names(clean_ALL_1_stack3_homog07_filt_09)
# [1] "SI_modal3"      "SI_sobel3"      "SI_sobel_v3"    "TGI_modal3"     "TGI_sobel3"     "TGI_sobel_v3"
#[7] "GLI_modal3"     "GLI_sobel3"     "NGRDI_sobel3"   "NGRDI_sobel_v3" "TDVI_sobel3"    "SR_sobel3"
#[13] "MSR_sobel_v3"   "Blue_modal3"
writeRaster(clean_ALL_1_stack3_homog07_filt_09, paste0(path_prdctr10,
            filename = names(clean_ALL_1_stack3_homog07_filt_09), "_corr_09_pred_10.tif"),
            format="GTiff", bylayer=TRUE, overwrite=TRUE)
#why there is only Blue left from RGB?
#correlation test on RGBNIR_1
RGBNIR_1_corr <- LEGION::detct_RstCor(RGBNIR_1, 0.9)
### LEGION testing Raster Correlation
#correlating layers detected
#dropping from Stack: Green, Red, IR_1
