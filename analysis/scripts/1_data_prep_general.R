####################################SHORTCUTS###################################
lsdsm <-list.files(file.path(path_analysis_data_dsm), pattern=".tif")
lsdem <-list.files(file.path(path_analysis_data_dem), pattern=".tif")
lschm <-list.files(file.path(path_analysis_results_chm), pattern=".tif")
lsRGBIR <- list.files(file.path(path_analysis_data_RGB_IR), pattern=".tif")
################################################################################
                             ######CREATE CHM######
#read dem & dsm of the ROI####
dem <- raster::raster(paste0(path_analysis_data_dem, lsdem[1]))
dsm <- raster::raster(paste0(path_analysis_data_dsm, lsdsm[1]))

#create chm of the ROI: substract the dem drom the dsm####
chm <- dsm-dem

#check the position & properties of the chm you just created####
mapview(chm)
crs(chm)
#CRS arguments:
# +proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000
#+ellps=bessel +units=m +no_defs

#rename layer of the chm as desired####
names(chm) <-"chm_ROI"

#write out the chm of the ROI####
raster::writeRaster(chm, paste0(path_analysis_results_chm, "chm_ROI.tif"), format="GTiff", overwrite=TRUE)

#make sure the file you just wrote out has the same crs as the one you just created####
#read chm
chm <- raster::raster(paste0(path_analysis_results_chm, "chm_ROI.tif"))
#check crs
crs(chm)
#CRS arguments:
# +proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000
#+ellps=bessel +units=m +no_defs
mapview(chm)

                        ######READ TEST AREAS######
#Originally masks for each test area were  created in QGIS. Then the chm and
#the RGB + IR imagery was cropped to the size of the test area masks. But
#because of the limitations of the file size limit in the 'raster package' the
#size of the whole ROI and thus also the size of the test areas had to be
#scaled down.
#Thus when the maximum size of the ROI was found, the sizes of the test areas
#were defined by using the 'Clip raster by Extent/Use map canvas extent' tool in
#QGIS, to 4 approximately 32 x 32 m tes areas. Then the respective chm test areas
#were used as masks or extents to clip the respective RGB and IR test areas in QGIS.

####Check the chms in the respective folder####
#pay attention because when you open files in QGIS, it saves aux.xml for every
#raster which are also saved in the respective folder and so the order of the
#files in the folder will change.
#Thus ALWAYS check the file order in the folders!

lschm
#[1] "CHM_1.tif"   "CHM_2.tif"   "CHM_3.tif"   "CHM_4.tif"   "chm_ROI.tif"

chm_1 <- raster(paste0(path_analysis_results_chm, lschm[[1]]))
chm_2 <- raster(paste0(path_analysis_results_chm, lschm[[2]]))
chm_3 <- raster(paste0(path_analysis_results_chm, lschm[[3]]))
chm_4 <- raster(paste0(path_analysis_results_chm, lschm[[4]]))
chm_ROI <- raster(paste0(path_analysis_results_chm, lschm[[5]]))

#check the RGB + IR spectral data in the respective folder####
lsRGBIR
#[1]   "IR_1.tif"           "IR_1.tif.aux.xml"     "IR_2.tif"          "IR_2.tif.aux.xml"
#[5]   "IR_3.tif"           "IR_3.tif.aux.xml"     "IR_4.tif"          "IR_4.tif.aux.xml"
#[9]   "IR_ROI.tif"         "Red.tif"              "RGB_1.tif"         "RGB_1.tif.aux.xml"
#[13]  "RGB_2.tif"          "RGB_2.tif.aux.xml"    "RGB_3.tif"         "RGB_3.tif.aux.xml"
#[17]  "RGB_4.tif"          "RGB_4.tif.aux.xml"    "RGB_ROI.tif"

RGB_1 <- raster(paste0(path_analysis_data_RGB_IR, lsRGBIR[[11]]))
RGB_2 <- raster(paste0(path_analysis_data_RGB_IR, lsRGBIR[[13]]))
RGB_3 <- raster(paste0(path_analysis_data_RGB_IR, lsRGBIR[[15]]))
RGB_4 <- raster(paste0(path_analysis_data_RGB_IR, lsRGBIR[[17]]))
RGB_ROI <- raster(paste0(path_analysis_data_RGB_IR, lsRGBIR[[19]]))

IR_1 <- raster(paste0(path_analysis_data_RGB_IR, lsRGBIR[[1]]))
IR_2 <- raster(paste0(path_analysis_data_RGB_IR, lsRGBIR[[3]]))
IR_3 <- raster(paste0(path_analysis_data_RGB_IR, lsRGBIR[[5]]))
IR_4 <- raster(paste0(path_analysis_data_RGB_IR, lsRGBIR[[7]]))
IR_ROI <- raster(paste0(path_analysis_data_RGB_IR, lsRGBIR[[9]]))
