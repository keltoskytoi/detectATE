####--------------------------------SHORTCUTS-------------------------------####
#create shortcuts to the folders where de data and results are stored
lsdsm <-list.files(paste0(path_analysis_data_dsm), glob2rx(pattern="*.tif"))
lsdem <-list.files(paste0(path_analysis_data_dem), glob2rx(pattern="*.tif"))
lschm <-list.files(paste0(path_analysis_results_chm), glob2rx(pattern="*.tif"))
lsRGBIR <- list.files(paste0(path_analysis_data_RGB_IR), glob2rx(pattern="*.tif"))
################################################################################
####-----------------------------#1.CREATE CHM#-----------------------------####
#----------------------------read dem & dsm of the ROI-------------------------#
dem <- raster::raster(paste0(path_analysis_data_dem, lsdem[1]))
dsm <- raster::raster(paste0(path_analysis_data_dsm, lsdsm[1]))
#---------------create chm of the ROI: substract the dem from the dsm----------#
chm <- dsm-dem
#---------check the position & properties of the chm you just created----------#
mapview(chm)
crs(chm)
#Deprecated Proj.4 representation:
#+proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel +units=m +no_defs
#---------------------------rename layer of the chm as desired-----------------#
names(chm) <-"chm_ROI"
#-----------------------------export the chm of the ROI------------------------#
raster::writeRaster(chm, paste0(path_analysis_results_chm, "chm_ROI.tif"),
                    format="GTiff", overwrite=TRUE)
#------------------------------check crs of the exported chm-------------------#
#read chm
chm <- raster::raster(paste0(path_analysis_results_chm, "chm_ROI.tif"))
#check crs
crs(chm)
#Deprecated Proj.4 representation:
#+proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel +units=m +no_defs
mapview(chm)

####-----------------#2.LOAD TEST AREAS (CHM&SPECTRAL)#---------------------####
#Originally masks for each 4 test areas were created in QGIS and based on them,
#the CHM and the RGB and IR imagery was cropped to the size of the test area masks.
#When it became clear, that the minimal computable raster size (on grounds of the
#restrictions of the 'raster' package in R) was a lot smaller than the maximum
#size of the actual ROI originally decided, it was reduced. The sizes of the CHM
#test areas were defined using the **'Clip raster by Extent'** tool, with the
#***'use map canvas'*** setting in QGIS, to define 4, approximately 32 x 32 m
#*#test areas. Then the respective CHM test areas were used as masks/extents to
#*#clip the respective RGB and IR test areas in QGIS.

#--------------------check the chms in the respective folder-------------------#
#When you open files in QGIS, it creates and saves an aux.xml for every raster
#file in the same folder, where the raster file itself is. Thus the order of the
#files in the folder will change.
# == ALWAYS check the file order in the folders!

lschm
#"chm_1.tif"   "chm_2.tif"   "chm_3.tif"   "chm_4.tif"   "chm_ROI.tif"

chm_1 <- raster(paste0(path_analysis_results_chm, lschm[[1]]))
chm_2 <- raster(paste0(path_analysis_results_chm, lschm[[2]]))
chm_3 <- raster(paste0(path_analysis_results_chm, lschm[[3]]))
chm_4 <- raster(paste0(path_analysis_results_chm, lschm[[4]]))
chm_ROI <- raster(paste0(path_analysis_results_chm, lschm[[5]]))

#-------------check the RGB + IR spectral data in the respective folder--------#
lsRGBIR
#"IR_1.tif"    "IR_2.tif"    "IR_3.tif"    "IR_4.tif"    "IR_ROI.tif"
#"RGB_1.tif"   "RGB_2.tif"   "RGB_3.tif"   "RGB_4.tif"   "RGB_ROI.tif"

RGB_1 <- raster(paste0(path_analysis_data_RGB_IR, lsRGBIR[[6]]))
RGB_2 <- raster(paste0(path_analysis_data_RGB_IR, lsRGBIR[[7]]))
RGB_3 <- raster(paste0(path_analysis_data_RGB_IR, lsRGBIR[[8]]))
RGB_4 <- raster(paste0(path_analysis_data_RGB_IR, lsRGBIR[[9]]))
RGB_ROI <- raster(paste0(path_analysis_data_RGB_IR, lsRGBIR[[10]]))

IR_1 <- raster(paste0(path_analysis_data_RGB_IR, lsRGBIR[[1]]))
IR_2 <- raster(paste0(path_analysis_data_RGB_IR, lsRGBIR[[2]]))
IR_3 <- raster(paste0(path_analysis_data_RGB_IR, lsRGBIR[[3]]))
IR_4 <- raster(paste0(path_analysis_data_RGB_IR, lsRGBIR[[4]]))
IR_ROI <- raster(paste0(path_analysis_data_RGB_IR, lsRGBIR[[5]]))

#let's plot our ROIs and test areas to check if the are in the right place!
mapview::mapview(chm_ROI) + RGB_ROI + IR_ROI
mapview::mapview(chm_1) + RGB_1 + IR_1
mapview::mapview(chm_2) + RGB_2 + IR_2
mapview::mapview(chm_3) + RGB_3 + IR_3
mapview::mapview(chm_4) + RGB_4 + IR_4

#If chm_1-4 are out of place, we have to reproject the chms
#chm_1 <- projectRaster(chm_1, crs=crs(RGB_1))
#raster::writeRaster(chm_1, paste0(path_analysis_results_chm, "chm_1.tif"),
#                    format="GTiff", overwrite=TRUE)
#chm_2 <- projectRaster(chm_2, crs=crs(RGB_2))
#raster::writeRaster(chm_2, paste0(path_analysis_results_chm, "chm_2.tif"),
#                    format="GTiff", overwrite=TRUE)
#chm_3 <- projectRaster(chm_3, crs=crs(RGB_3))
#raster::writeRaster(chm_3, paste0(path_analysis_results_chm, "chm_3.tif"),
#                    format="GTiff", overwrite=TRUE)
#chm_4 <- projectRaster(chm_4, crs=crs(RGB_4))
#raster::writeRaster(chm_4, paste0(path_analysis_results_chm, "chm_4.tif"),
#                    format="GTiff", overwrite=TRUE)

#let's plot all test areas together!
mapview::mapview(chm_1) + chm_2 + chm_3 + chm_4
mapview::mapview(RGB_1) + RGB_2 + RGB_3 + RGB_4
mapview::mapview(IR_1) + IR_2 + IR_3 + IR_4
################################################################################
