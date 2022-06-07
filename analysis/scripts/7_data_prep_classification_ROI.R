####--------------------------------SHORTCUTS-------------------------------####
lsRGBIR <- list.files(paste0(path_analysis_data_RGB_IR), glob2rx(pattern="*.tif"))
lsROIind <- list.files(file.path(path_analysis_results_ind_ROI), glob2rx(pattern=".tif"))
lsfilt_093_1_ROI <- list.files(file.path(path_analysis_results_filt_093_1_ROI), glob2rx(pattern="*.tif"))
lsfilt_093_2_ROI <- list.files(file.path(path_analysis_results_filt_093_2_ROI), glob2rx(pattern="*.tif"))
################################################################################
####------------------------#1.LOAD SPECTRAL DATA#--------------------------####
lsRGBIR
#"IR_1.tif"    "IR_2.tif"    "IR_3.tif"    "IR_4.tif"    "IR_ROI.tif"
#"RGB_1.tif"   "RGB_2.tif"   "RGB_3.tif"   "RGB_4.tif"   "RGB_ROI.tif"
####-----------------------------#2.PREPARE ROI#----------------------------####
#----------------------------------RGB of ROI----------------------------------#
RGB_ROI <- raster::stack(paste0(path_analysis_data_RGB_IR, lsRGBIR[[10]]))
crs(RGB_ROI) #+proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel +units=m +no_defs
#check the names and the band order!
names(RGB_ROI)
#"Red"   "Green" "Blue"
names(RGB_ROI) <- c("RED_ROI", "GREEN_ROI", "BLUE_ROI")
names(RGB_ROI)
#"RED_ROI"   "GREEN_ROI" "BLUE_ROI"
#------------------------------------IR of ROI---------------------------------#
IR_ROI  <-  raster::raster(paste0(path_analysis_data_RGB_IR, lsRGBIR[[5]]))
crs(IR_ROI) # +proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel +units=m +no_defs
names(IR_ROI)
#"IR_ROI"
#--------------------------------stack RGB & IR ROI----------------------------#
RGBNIR_ROI <- raster::stack(RGB_ROI, IR_ROI)
names(RGBNIR_ROI)
#[1] "RED_ROI"   "GREEN_ROI" "BLUE_ROI"  "IR_ROI"

####---------------------------#3.COMPUTE INDICES#--------------------------####
#-----------------------Compute RGB indices - 11 layer-------------------------#
RGB_ROI_ind <- LEGION::vegInd_RGB(RGB_ROI, 1,2,3, indlist="all")
names(RGB_ROI_ind)
#"VVI"   "VARI"  "NDTI"  "RI"    "CI"    "BI"    "SI"    "HI"    "TGI"   "GLI"   "NGRDI"
#when inspecting the indices visually, it is visible that VARI, RI, and HI contain
#too homogeneous areas, which would distort the classification result
#-----------------------Compute RGBNIR indices - 4 layer-----------------------#
RGBNIR_ROI_ind <- LEGION::vegInd_mspec(RGBNIR_ROI, 1,2,3,4, indlist="all")
names(RGBNIR_ROI_ind)
#"NDVI" "TDVI" "SR"   "MSR"
####-------------------------#4.COMPUTE INDEX STACKS#-----------------------####
#RGB + MS indices - 15 layer
ALL_ind_stack_ROI <- raster::stack(RGB_ROI_ind, RGBNIR_ROI_ind)
names(ALL_ind_stack_ROI)
#"VVI"   "VARI"  "NDTI"  "RI"    "CI"    "BI"    "SI"    "HI"    "TGI"
#"GLI"   "NGRDI" "NDVI"  "TDVI"  "SR"    "MSR"
#------------------------------------------------------------------------------#
#RGB indices + MS indices + RGB + NIR - 19 layer
ALL_RGBMS_stack_ROI <- raster::stack(RGB_ROI_ind, RGBNIR_ROI_ind, RGBNIR_ROI)
names(ALL_RGBMS_stack_ROI)
#"VVI"       "VARI"      "NDTI"      "RI"        "CI"        "BI"        "SI"
#"HI"        "TGI"       "GLI"       "NGRDI"     "NDVI"      "TDVI"      "SR"
#"MSR"       "RED_ROI"   "GREEN_ROI" "BLUE_ROI"  "IR_ROI"
####------------------#5.TEST INDEX STACKS ON HOMOGENEITY#------------------####
#to understand which homogeneity size to choose all RGB indices were tested using
#different homogeneity settings to understand which index gets excluded and why
#we know, that we want to get rid of VARI, RI, and HI. Let's test the settings of train area 1!
ALL_ind_stack_ROI_homog09 <- LEGION::detct_RstHmgy(ALL_ind_stack_ROI, valueRange = 0.1, THvalue = 0.9)
#dropping from Stack: VVI, VARI, RI, HI
#ok, which setting does not drop VVI but only VARI, RI, HI?
ALL_ind_stack_ROI_homog08 <- LEGION::detct_RstHmgy(ALL_ind_stack_ROI, valueRange = 0.1, THvalue = 0.8)
#dropping from Stack: VVI, VARI, RI, SI, HI; dropping too much
ALL_ind_stack_ROI_homog095 <- LEGION::detct_RstHmgy(ALL_ind_stack_ROI, valueRange = 0.1, THvalue = 0.95)
#dropping from Stack: VARI, RI; dropping too few
ALL_ind_stack_ROI_homog092 <- LEGION::detct_RstHmgy(ALL_ind_stack_ROI, valueRange = 0.1, THvalue = 0.92)
#dropping from Stack: VVI, VARI, RI, HI; same as THvalue = 09
ALL_ind_stack_ROI_homog093 <- LEGION::detct_RstHmgy(ALL_ind_stack_ROI, valueRange = 0.1, THvalue = 0.93)
#dropping from Stack: VARI, RI, HI; this is it!
#----------------------Chosen LEGION::detct_RstHmgy settings-------------------#
names(ALL_ind_stack_ROI_homog093)# without VARI, RI, HI
#"VVI"   "NDTI"  "CI"    "BI"    "SI"    "TGI"   "GLI"   "NGRDI" "NDVI"  "TDVI"  "SR"    "MSR"

ALL_RGBMS_stack_ROI_homog093 <- LEGION::detct_RstHmgy(ALL_RGBMS_stack_ROI, valueRange = 0.1, THvalue = 0.93)
#dropping from Stack: VARI, RI, HI
names(ALL_RGBMS_stack_ROI_homog093)
#"VVI"   "NDTI"  "CI"    "BI"    "SI"    "TGI"   "GLI"   "NGRDI" "NDVI"  "TDVI"
#"SR"    "MSR"   "Red"   "Green" "Blue"  "IR_1"
####-----------------------------#6.FILTER INDICES#-------------------------####
#Because the area is small, a MovingWindow of size 3 is enough
ALL_ind_stack_ROI_homog093_filt <-LEGION::filter_Stk(ALL_ind_stack_ROI_homog093, sizes=3)
#108 filtered raster
names(ALL_ind_stack_ROI_homog093_filt)
raster::writeRaster(ALL_ind_stack_ROI_homog093_filt, paste0(path_analysis_results_filt_093_1_ROI,
                    filename = names(ALL_ind_stack_ROI_homog093_filt),
                    "_ALL_ind_stack_ROI_homog093_filt.tif"), format="GTiff",
                    bylayer = TRUE, overwrite=TRUE)
#read the rasterstack for future work
ALL_ind_stack_ROI_homog093_filt <- raster::stack(paste0(path_analysis_results_filt_093_1_ROI, lsfilt_093_1_ROI))
#------------------------------------------------------------------------------#
ALL_RGBMS_stack_ROI_homog093_filt <-LEGION::filter_Stk(ALL_RGBMS_stack_ROI_homog093, sizes=3)
#144 filtered raster
names(ALL_RGBMS_stack_ROI_homog093_filt)
raster::writeRaster(ALL_RGBMS_stack_ROI_homog093_filt, paste0(path_analysis_results_filt_093_2_ROI,
                    filename = names(ALL_RGBMS_stack_ROI_homog093_filt),
                    "_ALL_RGBMS_stack_ROI_homog093_filt.tif"), format="GTiff",
                    bylayer = TRUE, overwrite=TRUE)
#read the rasterstack for future work
ALL_RGBMS_stack_ROI_homog093_filt <- raster::stack(paste0(path_analysis_results_filt_093_2_ROI, lsfilt_093_2_ROI))
####----------------------#7.TEST INDICES ON CORRELATION#-------------------####
#remove correlating RasterLayers - change correlation levels!
#it was tested that with 0.9 more layers are left -for the FFS
#----------------------------PREDICTORS 1 - 17 layer---------------------------#
#RGB + MS indices, all filter
clean_ALL_ind_stack_ROI_homog093_filt <- LEGION::detct_RstCor(ALL_ind_stack_ROI_homog093_filt, 0.9)
#NAs detected: deleting 764715  NAs
names(clean_ALL_ind_stack_ROI_homog093_filt)
#"GLI_min3_ALL_ind_stack_ROI_homog093_filt"       "GLI_sobel3_ALL_ind_stack_ROI_homog093_filt"
#"MSR_min3_ALL_ind_stack_ROI_homog093_filt"       "MSR_sobel_v3_ALL_ind_stack_ROI_homog093_filt"
#"NGRDI_sobel_v3_ALL_ind_stack_ROI_homog093_filt" "SI_max3_ALL_ind_stack_ROI_homog093_filt"
#"SI_sobel_v3_ALL_ind_stack_ROI_homog093_filt"    "SI_sobel3_ALL_ind_stack_ROI_homog093_filt"
#SR_sobel3_ALL_ind_stack_ROI_homog093_filt"       "TDVI_sobel3_ALL_ind_stack_ROI_homog093_filt"
#"TGI_max3_ALL_ind_stack_ROI_homog093_filt"       "TGI_sobel_v3_ALL_ind_stack_ROI_homog093_filt"
#"TGI_sobel3_ALL_ind_stack_ROI_homog093_filt"     "VVI_min3_ALL_ind_stack_ROI_homog093_filt"
#"VVI_modal3_ALL_ind_stack_ROI_homog093_filt"     "VVI_sobel_v3_ALL_ind_stack_ROI_homog093_filt"
#"VVI_sobel3_ALL_ind_stack_ROI_homog093_filt"
raster::writeRaster(clean_ALL_ind_stack_ROI_homog093_filt, paste0(path_analysis_results_prdctrs1_ROI,
                    filename = names(clean_ALL_ind_stack_ROI_homog093_filt), "_corr_09_pred_1.tif"),
                    format="GTiff", bylayer=TRUE, overwrite=TRUE)
#----------------------------PREDICTORS 2 - 17 layer---------------------------#
##RGB indices + Spectral indices + RGB + NIR, all filter
clean_ALL_RGBMS_stack_ROI_homog093_filt <- LEGION::detct_RstCor(ALL_RGBMS_stack_ROI_homog093_filt, 0.9)
#NAs detected: deleting 1019235  NAs
names(clean_ALL_RGBMS_stack_ROI_homog093_filt)
#"Blue_min3_ALL_RGBMS_stack_ROI_homog093_filt"      "GLI_min3_ALL_RGBMS_stack_ROI_homog093_filt"
#"GLI_sobel3_ALL_RGBMS_stack_ROI_homog093_filt"     "IR_ROI_sobel3_ALL_RGBMS_stack_ROI_homog093_filt"
#"MSR_sobel_v3_ALL_RGBMS_stack_ROI_homog093_filt"   "NGRDI_sobel_v3_ALL_RGBMS_stack_ROI_homog093_filt"
#"SI_max3_ALL_RGBMS_stack_ROI_homog093_filt"        "SI_sobel_v3_ALL_RGBMS_stack_ROI_homog093_filt"
#"SI_sobel3_ALL_RGBMS_stack_ROI_homog093_filt"      "SR_sobel3_ALL_RGBMS_stack_ROI_homog093_filt"
#"TGI_max3_ALL_RGBMS_stack_ROI_homog093_filt"       "TGI_sobel_v3_ALL_RGBMS_stack_ROI_homog093_filt"
#"TGI_sobel3_ALL_RGBMS_stack_ROI_homog093_filt"     "VVI_min3_ALL_RGBMS_stack_ROI_homog093_filt"
#"VVI_modal3_ALL_RGBMS_stack_ROI_homog093_filt"     "VVI_sobel_v3_ALL_RGBMS_stack_ROI_homog093_filt"
#"VVI_sobel3_ALL_RGBMS_stack_ROI_homog093_filt"
raster::writeRaster(clean_ALL_RGBMS_stack_ROI_homog093_filt, paste0(path_analysis_results_prdctrs2_ROI,
                    filename = names(clean_ALL_RGBMS_stack_ROI_homog093_filt), "_corr_09_pred_2.tif"),
                    format="GTiff", bylayer=TRUE, overwrite=TRUE)
