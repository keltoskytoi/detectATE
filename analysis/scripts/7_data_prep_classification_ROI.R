####################################SHORTCUTS###################################
lsRGBIR <- list.files(file.path(path_RGB_IR), pattern=".tif")
lsROIind <- list.files(file.path(path_ROI_ind), pattern=".tif")
lsfiltROI <- list.files(file.path(path_filt_09_ROI), pattern=".tif")


lsRGBIR
#[1] "IR_1.tif"          "IR_1.tif.aux.xml"  "IR_2.tif"          "IR_2.tif.aux.xml" 
#[5] "IR_3.tif"          "IR_3.tif.aux.xml"  "IR_4.tif"          "IR_4.tif.aux.xml" 
#[9] "IR_ROI.tif"        "Red.tif"           "RGB_1.tif"         "RGB_1.tif.aux.xml"
#[13] "RGB_2.tif"         "RGB_2.tif.aux.xml" "RGB_3.tif"         "RGB_3.tif.aux.xml"
#[17] "RGB_4.tif"         "RGB_4.tif.aux.xml" "RGB_ROI.tif" 

                           ####PREPARATION OF ROI####
####################################LOAD DATA###################################
#RGB of ROI####
RGB_ROI <- raster::stack(paste0(path_RGB_IR, lsRGBIR[[19]]))
crs(RGB_ROI)
#+proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000
#+ellps=bessel +units=m +no_defs 
#check the names and the band order!
names(RGB_ROI)
#1] "Red"   "Green" "Blue" 
names(RGB_ROI) <- c("RED_ROI", "GREEN_ROI", "BLUE_ROI")
names(RGB_ROI)
#[1] "RED_ROI"   "GREEN_ROI" "BLUE_ROI" 

#IR of ROI####
IR_ROI  <-  raster(paste0(path_RGB_IR, lsRGBIR[[9]])) 
crs(IR_ROI)
# +proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel +units=m
#+no_defs 
names(IR_ROI)
#"IR_ROI"

#stack RGB & IR of ROI####
RGBNIR_ROI <- raster::stack(RGB_ROI, IR_ROI)
names(RGBNIR_ROI)
#[1] "RED_ROI"   "GREEN_ROI" "BLUE_ROI"  "IR_ROI"

##################################COMPUTE INDICES###############################
#we learned from area 1, that 11 gave the best result, so we are going to use 
#FFS predictor stack 11:  
#"MSR_modal3_corr_09_pred_5" "TGI_sum3_corr_09_pred_5" "GLI_modal3_corr_09_pred_5" 
#"TGI_sd3_corr_09_pred_5" "TDVI_sd3_corr_09_pred_5"

#the basic for predictors stack 11 was: all stack + homogeneity 0.7 & - min/max 
#filter - HI 14 layer plus the FFS. We will calculate the respective indices 
#(filtered by the homogeneity) and all filter (because it just takes time 
#and it is easier than write 5 lines of code) and choose the right filter sizes 
#to put in the predictor stack

#compute selected RGB indices####
vi <-c("VVI", "TGI", "GLI")
RGB_ROI_ind <- LEGION::vegInd_RGB(RGB_ROI, 1,2,3, indlist=vi)

#compute selected Spectral indices####
vi2 <- c("TDVI", "MSR")
RGBNIR_ROI_ind <- LEGION::vegInd_mspec(RGBNIR_ROI, 1,2,3,4, indlist=vi2)

ROI_IND <- raster::stack(RGB_ROI_ind, RGBNIR_ROI_ind)

#write all indices out####
writeRaster(ROI_IND, paste0(path_ROI_ind, filename = names(ROI_IND), ".tif"), 
            format="GTiff", bylayer=TRUE, overwrite=TRUE)
names(ROI_IND)
#"VVI"  "TGI"  "GLI"  "TDVI" "MSR"
###################################FILTER INDICES###############################
#all filter
ROI_IND_FILT <- LEGION::filter_Stk(ROI_IND, sizes=3)

writeRaster(ROI_IND_FILT, paste0(path_filt_09_ROI, filename = names(ROI_IND_FILT), ".tif"), 
            format="GTiff", bylayer=TRUE, overwrite=TRUE)

#select: MSR_modal3, TGI_sum3, GLI_modal3, TGI_sd3, TDVI_sd3
PREDICTORS_ROI <- raster::stack(ROI_IND_FILT$MSR_modal3,
                                ROI_IND_FILT$TGI_sum3,
                                ROI_IND_FILT$GLI_modal3,
                                ROI_IND_FILT$TGI_sd3,
                                ROI_IND_FILT$TDVI_sd3)

writeRaster(PREDICTORS_ROI, paste0(path_pred_ROI, 
            filename = names(PREDICTORS_ROI), ".tif"), 
            format="GTiff", bylayer=TRUE, overwrite=TRUE)

