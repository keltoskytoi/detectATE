####--------------------------------SHORTCUTS-------------------------------####
lsRGBIR <- list.files(paste0(path_analysis_data_RGB_IR), glob2rx(pattern="*.tif"))
################################################################################
####------------------------#1.LOAD SPECTRAL DATA#--------------------------####
lsRGBIR
#"IR_1.tif"    "IR_2.tif"    "IR_3.tif"    "IR_4.tif"    "IR_ROI.tif"  "RGB_1.tif"
#"RGB_2.tif"   "RGB_3.tif"   "RGB_4.tif"   "RGB_ROI.tif"

####-----------------------#2.PREPARE TRAINING AREA 1#----------------------####
#--------------------------------RGB of area 1---------------------------------#
RGB_1 <- raster::stack(paste0(path_analysis_data_RGB_IR, lsRGBIR[[6]]))
crs(RGB_1)
#+proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel +units=m +no_defs
#check the names and the band order!
names(RGB_1)
#"Red"   "Green" "Blue"
#---------------------------------IR of area 1---------------------------------#
IR_1  <-  raster(paste0(path_analysis_data_RGB_IR, lsRGBIR[[1]]))
crs(IR_1)
# +proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel +units=m +no_defs
names(IR_1)
#"IR_1"
#----------------------------stack RGB & IR of area 1--------------------------#
RGBNIR_1 <- raster::stack(RGB_1, IR_1)
names(RGBNIR_1)
#"Red"   "Green" "Blue"  "IR_1"
####---------------------------#3.COMPUTE INDICES#--------------------------####
#-----------------------Compute RGB indices - 11 layer-------------------------#
RGB_1_ind <- LEGION::vegInd_RGB(RGB_1, 1,2,3, indlist="all")
names(RGB_1_ind)
#"VVI"   "VARI"  "NDTI"  "RI"    "CI"    "BI"    "SI"    "HI"    "TGI"   "GLI"   "NGRDI"
#plot and inspect all RGB
plot(RGB_1_ind)
#when inspecting the indices visually, it is visible that VARI, RI, and HI contain
#too homogeneous areas, which would distort the classification result
#-----------------------Compute RGBNIR indices - 4 layer-----------------------#
RGBNIR_1_ind <- LEGION::vegInd_mspec(RGBNIR_1, 1,2,3,4, indlist="all")
names(RGBNIR_1_ind)
#"NDVI" "TDVI" "SR" "MSR"
####-------------------------#4.COMPUTE INDEX STACKS#-----------------------####
#RGB + MS indices - 15 layer
ALL_ind_stack_1 <- raster::stack(RGB_1_ind, RGBNIR_1_ind)
names(ALL_ind_stack_1)
#"VVI"   "VARI"  "NDTI"  "RI"    "CI"    "BI"    "SI"    "HI"    "TGI"
#"GLI"   "NGRDI" "NDVI" "TDVI"  "SR"    "MSR
#------------------------------------------------------------------------------#
#RGB indices + MS indices + RGB + NIR - 19 layer
ALL_RGBMS_stack_1 <- raster::stack(RGB_1_ind, RGBNIR_1_ind, RGBNIR_1)
names(ALL_RGBMS_stack_1)
#"VVI"   "VARI"  "NDTI"  "RI"    "CI"    "BI"    "SI"    "HI"
#"TGI"   "GLI"   "NGRDI" "NDVI"  "TDVI"  "SR"    "MSR"   "Red"
#"Green" "Blue"  "IR_1"
plot(ALL_RGBMS_stack_1)
####------------------#5.TEST INDEX STACKS ON HOMOGENEITY#------------------####
#to understand which homogeneity size to choose all RGB indices were tested using
#different homogeneity settings to understand which index gets excluded and why
ALL_ind_stack_1_homog04 <- LEGION::detct_RstHmgy(ALL_ind_stack_1, valueRange = 0.1, THvalue = 0.4)
#dropping from Stack: VVI, VARI, NDTI, RI, CI, BI, SI, HI, TGI, GLI, NGRDI, MSR
names(ALL_ind_stack_1_homog04)
#"NDVI" "TDVI" "SR"

ALL_ind_stack_1_homog05 <- LEGION::detct_RstHmgy(ALL_ind_stack_1, valueRange = 0.1, THvalue = 0.5)
#dropping from Stack: VVI, VARI, NDTI, RI, CI, SI, HI, GLI, NGRDI
names(ALL_ind_stack_1_homog05)
#"BI"   "TGI"  "NDVI" "TDVI" "SR"   "MSR"

ALL_ind_stack_1_homog06 <- LEGION::detct_RstHmgy(ALL_ind_stack_1, valueRange = 0.1, THvalue = 0.6)
#dropping from Stack: VVI, VARI, RI, SI, HI
names(ALL_ind_stack_1_homog06)
#"NDTI"  "CI"    "BI"    "TGI"   "GLI"   "NGRDI" "NDVI"  "TDVI"  "SR"    "MSR"

ALL_ind_stack_1_homog07 <- LEGION::detct_RstHmgy(ALL_ind_stack_1, valueRange = 0.1, THvalue = 0.7)
#dropping from Stack: VVI, VARI, RI, SI, HI
names(ALL_ind_stack_1_homog07)
#"NDTI"  "CI"    "BI"    "TGI"   "GLI"   "NGRDI" "NDVI"  "TDVI"  "SR"    "MSR"

ALL_ind_stack_1_homog08 <- LEGION::detct_RstHmgy(ALL_ind_stack_1, valueRange = 0.1, THvalue = 0.8)
#dropping from Stack: VVI, VARI, RI, HI
names(ALL_ind_stack_1_homog08)
#"NDTI"  "CI"    "BI"    "SI"    "TGI"   "GLI"   "NGRDI" "NDVI"  "TDVI"  "SR"    "MSR"

ALL_ind_stack_1_homog09 <- LEGION::detct_RstHmgy(ALL_ind_stack_1, valueRange = 0.1, THvalue = 0.9)
#dropping from Stack: VARI, RI, HI
names(ALL_ind_stack_1_homog09)
#"VVI"   "NDTI"  "CI"    "BI"    "SI"    "TGI"   "GLI"   "NGRDI" "NDVI"  "TDVI"  "SR"    "MSR"
#Homogeneity 0.9 drops exactly the 3 indices (VARI, RI, HI) we wanted to get rid of!

#----------------------Chosen LEGION::detct_RstHmgy settings-------------------#
names(ALL_ind_stack_1_homog09)# without VARI, RI, HI
#"VVI"   "NDTI"  "CI"    "BI"    "SI"    "TGI"   "GLI"   "NGRDI" "NDVI"  "TDVI"  "SR"    "MSR"

ALL_RGBMS_stack_1_homog09 <- LEGION::detct_RstHmgy(ALL_RGBMS_stack_1, valueRange = 0.1, THvalue = 0.9)
#dropping from Stack: VARI, RI, HI
names(ALL_RGBMS_stack_1_homog09)
#"VVI"   "NDTI"  "CI"    "BI"    "SI"    "TGI"   "GLI"   "NGRDI" "NDVI"  "TDVI"
#"SR"    "MSR"   "Red"   "Green" "Blue"  "IR_1"
####-----------------------------#6.FILTER INDICES#-------------------------####
#Because the area is small, a MovingWindow of size 3 is enough
ALL_ind_stack_1_homog09_filt <-LEGION::filter_Stk(ALL_ind_stack_1_homog09, sizes=3)
#108 filtered raster
names(ALL_ind_stack_1_homog09_filt)
raster::writeRaster(ALL_ind_stack_1_homog09_filt, paste0(path_analysis_results_filt_09_ta1,
                    filename = names(ALL_ind_stack_1_homog09_filt),
                    "_ALL_ind_stack_1_homog09_filt.tif"), format="GTiff",
                    bylayer = TRUE, overwrite=TRUE)
#------------------------------------------------------------------------------#
ALL_RGBMS_stack_1_homog09_filt <-LEGION::filter_Stk(ALL_RGBMS_stack_1_homog09, sizes=3)
#144 filtered raster
names(ALL_RGBMS_stack_1_homog09_filt)
raster::writeRaster(ALL_RGBMS_stack_1_homog09_filt, paste0(path_analysis_results_filt_09_ta1_2,
                    filename = names(ALL_RGBMS_stack_1_homog09_filt),
                    "_ALL_RGBMS_stack_1_homog09_filt.tif"), format="GTiff",
                    bylayer = TRUE, overwrite=TRUE)
####----------------------#7.TEST INDICES ON CORRELATION#-------------------####
#remove correlating RasterLayers - change correlation levels!
#it was tested that with 0.9 more layers are left -for the FFS
#----------------------------PREDICTORS 1 - 18 layer---------------------------#
#RGB + MS indices, all filter
clean_ALL_ind_stack_1_homog09_filt <- LEGION::detct_RstCor(ALL_ind_stack_1_homog09_filt, 0.9)
#INF values detected: setting  26 INF to NA
#NAs detected: deleting 109634  NAs
names(clean_ALL_ind_stack_1_homog09_filt)
#"VVI_min3"     "VVI_modal3"   "VVI_sobel3"   "VVI_sobel_v3"
#"SI_max3"       "SI_sobel3"    "SI_sobel_v3"  "TGI_max3"
#"TGI_sobel3"   "TGI_sobel_v3" "GLI_modal3"   "GLI_sobel3"
#"GLI_sobel_v3" "NDVI_min3"    "TDVI_sobel3" "SR_sobel3"
#"MSR_min3"     "MSR_sobel_v3"
raster::writeRaster(clean_ALL_ind_stack_1_homog09_filt, paste0(path_analysis_results_prdctr1,
                    filename = names(clean_ALL_ind_stack_1_homog09_filt), "_corr_09_pred_1.tif"),
                    format="GTiff", bylayer=TRUE, overwrite=TRUE)
#--------------------------PREDICTORS 2 - 19 layer-----------------------------#
#RGB indices + Spectral indices + RGB + NIR, all filter
clean_ALL_RGBMS_stack_1_homog09_filt <- LEGION::detct_RstCor(ALL_RGBMS_stack_1_homog09_filt, 0.9)
#INF values detected: setting  26 INF to NA
#NAs detected: deleting 146138  NAs
names(clean_ALL_RGBMS_stack_1_homog09_filt)
#[1] "VVI_min3"       "VVI_modal3"     "VVI_sobel3"     "VVI_sobel_v3"
#[5] "SI_max3"        "SI_sobel3"      "SI_sobel_v3"    "TGI_max3"
#[9] "TGI_sobel3"     "TGI_sobel_v3"   "GLI_max3"       "GLI_sobel3"
#[13] "NGRDI_sobel3"   "NGRDI_sobel_v3" "NDVI_min3"      "TDVI_sobel3"
#[17] "SR_sobel3"      "Blue_min3"      "Blue_sobel_v3"
raster::writeRaster(clean_ALL_RGBMS_stack_1_homog09_filt, paste0(path_analysis_results_prdctr2,
                    filename = names(clean_ALL_RGBMS_stack_1_homog09_filt), "_corr_09_pred_2.tif"),
                    format="GTiff", bylayer=TRUE, overwrite=TRUE)
