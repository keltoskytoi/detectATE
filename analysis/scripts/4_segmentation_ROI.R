####--------------------------------SHORTCUTS-------------------------------####
#create shortcuts to the folders where de data is stored
lschm <-list.files(paste0(path_analysis_results_chm), pattern=".tif")
################################################################################
####---------------------------#1.LOAD CHM ROI#-----------------------------####
#if you haven't imported the chm_ROI yet(= didn't start with script 1_data_prep_general.R,),
#then please import it:

#always check the order of files in the folder!
lschm
#[1] "chm_1.tif"         "chm_1.tif.aux.xml" "chm_2.tif"         "chm_2.tif.aux.xml"
#[5] "chm_3.tif"         "chm_3.tif.aux.xml" "chm_4.tif"         "chm_4.tif.aux.xml"
#[9] "chm_ROI.tif"

chm_ROI <- raster(paste0(path_analysis_results_chm, lschm[[9]]))

####--------------------------#2.SEGMENT CHM ROI#---------------------------####
#cv1 #ech calculation takes approximately 20 minutes
segm_ROI <- CENITH::TreeSeg(chm_ROI, a=0.07, b=0.07, h=4, MIN = 0.1, CHM=3)
#detected 901 trees ###
#clipped: 62 polygons. 839 trees remaining
writeOGR(obj=segm_ROI, dsn="C:/Users/kelto/Documents/detectATE/analysis/results/segm/segm_ROI",
         layer="segm_ROI", driver="ESRI Shapefile", verbose = TRUE, overwrite_layer = TRUE)

#cv2
segm_ROI_2 <- CENITH::TreeSeg(chm_ROI, a=0.07, b=0.08, h=3.5, MIN = 0.1, CHM=3)
#detected 1078 trees ###
#clipped: 90 polygons. 988 trees remaining
writeOGR(obj=segm_ROI_2, dsn="C:/Users/kelto/Documents/detectATE/analysis/results/segm/segm_ROI",
         layer="segm_ROI_2", driver="ESRI Shapefile", verbose = TRUE, overwrite_layer = TRUE)

#cv3
segm_ROI_3 <- CENITH::TreeSeg(chm_ROI, a=0.07, b=0.09, h=3.5, MIN = 0.1, CHM=3)
#detected 1060 trees ###
#clipped: 90 polygons. 970 trees remaining
writeOGR(obj=segm_ROI_3, dsn="C:/Users/kelto/Documents/detectATE/analysis/results/segm/segm_ROI",
         layer="segm_ROI_3", driver="ESRI Shapefile", verbose = TRUE, overwrite_layer = TRUE)

#cv4
segm_ROI_4 <- CENITH::TreeSeg(chm_ROI, a=0.07, b=0.07, h=3.5, MIN = 0.1, CHM=3)
#detected 1096 trees ###
#clipped: 90 polygons. 1006 trees remaining
writeOGR(obj=segm_ROI_4, dsn="C:/Users/kelto/Documents/detectATE/analysis/results/segm/segm_ROI",
         layer="segm_ROI_4", driver="ESRI Shapefile", verbose = TRUE, overwrite_layer = TRUE)

#cv5
segm_ROI_5 <- CENITH::TreeSeg(chm_ROI, a=0.07, b=0.08, h=4, MIN = 0.1, CHM=3)
#detected 883 trees ###
#clipped: 62 polygons. 821 trees remaining
writeOGR(obj=segm_ROI_5, dsn="C:/Users/kelto/Documents/detectATE/analysis/results/segm/segm_ROI",
         layer="segm_ROI_5", driver="ESRI Shapefile", verbose = TRUE, overwrite_layer = TRUE)

#cv6
segm_ROI_6 <- CENITH::TreeSeg(chm_ROI, a=0.07, b=0.09, h=4, MIN = 0.1, CHM=3)
#detected 865 trees ###
#clipped: 62 polygons. 803 trees remaining
writeOGR(obj=segm_ROI_6, dsn="C:/Users/kelto/Documents/detectATE/analysis/results/segm/segm_ROI",
         layer="segm_ROI_6", driver="ESRI Shapefile", verbose = TRUE, overwrite_layer = TRUE)

#cv7
segm_ROI_7 <- CENITH::TreeSeg(chm_ROI, a=0.07, b=0.1, h=3.5, MIN = 0.1, CHM=3)
#detected 1042 trees ###
#clipped: 90 polygons. 952 trees remaining###
writeOGR(obj=segm_ROI_7, dsn="C:/Users/kelto/Documents/detectATE/analysis/results/segm/segm_ROI",
         layer="segm_ROI_7", driver="ESRI Shapefile", verbose = TRUE, overwrite_layer = TRUE)

#cv8
segm_ROI_8 <- CENITH::TreeSeg(chm_ROI, a=0.07, b=0.1, h=4, MIN = 0.1, CHM=3)
#detected 847 trees
#clipped: 61 polygons. 786 trees remaining
writeOGR(obj=segm_ROI_8, dsn="C:/Users/kelto/Documents/detectATE/analysis/results/segm/segm_ROI",
         layer="segm_ROI_8", driver="ESRI Shapefile", verbose = TRUE, overwrite_layer = TRUE)

####-----------------------#3.FURTHER MANIPULATION#-------------------------####
#after checking all results in QGGIS is clear, that 3.5 m is too low and cv8 is the best,
#because it eliminates small segments which could be shrubs (of course depending
#on the initial decision about tree and seedling height)
#4 m is great, but what happens at a height of 4.5 and 5 = the red area and at
#5.1m (over the red) in QGIS?
#Can we make the segmentation better?

segm_ROI_9 <- CENITH::TreeSeg(chm_ROI, a=0.07, b=0.1, h=4.5, MIN = 0.1, CHM=3)
#detected 731 trees ###
#clipped: 46 polygons. 685 trees remaining
writeOGR(obj=segm_ROI_9, dsn="C:/Users/kelto/Documents/detectATE/analysis/results/segm/segm_ROI",
         layer="segm_ROI_9", driver="ESRI Shapefile", verbose = TRUE, overwrite_layer = TRUE)
#the result stays almost the same

segm_ROI_10 <- CENITH::TreeSeg(chm_ROI, a=0.07, b=0.1, h=5, MIN = 0.1, CHM=3)
#detected 656 trees ###
#clipped: 41 polygons. 615 trees remaining
writeOGR(obj=segm_ROI_10, dsn="C:/Users/kelto/Documents/detectATE/analysis/results/segm/segm_ROI",
         layer="segm_ROI_10", driver="ESRI Shapefile", verbose = TRUE, overwrite_layer = TRUE)
#with height 5m the area of the trees get smaller and younger trees are left out

segm_ROI_11 <- CENITH::TreeSeg(chm_ROI, a=0.07, b=0.1, h=5.1, MIN = 0.1, CHM=3)
#detected 647 trees ###
#clipped: 44 polygons. 603 trees remaining
writeOGR(obj=segm_ROI_11, dsn="C:/Users/kelto/Documents/detectATE/analysis/results/segm/segm_ROI",
         layer="segm_ROI_11", driver="ESRI Shapefile")
#this is the case even more

segm_ROI_12 <- CENITH::TreeSeg(chm_ROI, a=0.07, b=0.1, h=5.1, CHM=3)
#detected 647 trees ###
#clipped: 0 polygons. 647 trees remaining
writeOGR(obj=segm_ROI_12, dsn="C:/Users/kelto/Documents/detectATE/analysis/results/segm/segm_ROI",
         layer="segm_ROI_12", driver="ESRI Shapefile", verbose = TRUE, overwrite_layer = TRUE)
#test without MIN= 0.1 and even more
