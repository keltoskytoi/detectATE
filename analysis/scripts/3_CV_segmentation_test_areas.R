####--------------------------------SHORTCUTS-------------------------------####
#create shortcuts to the folders where de data is stored
lschm <-list.files(file.path(path_analysis_results_chm), pattern=".tif")
lstreepos <- list.files(file.path(path_analysis_data_treepos), pattern=".shp")
################################################################################
####---------------------------#1.LOAD TEST AREAS#--------------------------####
#if you haven't imported the chms yet(= didn't start with script 1_data_prep_general.R,),
#then please import the chms;

#always check the order of files in the folder!
lschm
#[1] "chm_1.tif"         "chm_1.tif.aux.xml" "chm_2.tif"         "chm_2.tif.aux.xml"
#[5] "chm_3.tif"         "chm_3.tif.aux.xml" "chm_4.tif"         "chm_4.tif.aux.xml"
#[9] "chm_ROI.tif"

chm_1 <- raster(paste0(path_analysis_results_chm, lschm[[1]]))
crs(chm_1) #+proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel +units=m +no_defs
chm_2 <- raster(paste0(path_analysis_results_chm, lschm[[3]]))
crs(chm_2) #+proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel +units=m +no_defs
chm_3 <- raster(paste0(path_analysis_results_chm, lschm[[5]]))
crs(chm_3) #+proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel +units=m +no_defs
chm_4 <- raster(paste0(path_analysis_results_chm, lschm[[7]]))
crs(chm_4) #+proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel +units=m +no_defs
chm_ROI <- raster(paste0(path_analysis_results_chm, lschm[[9]]))
crs(chm_ROI) #+proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel +units=m +no_defs
#make sure they have the same crs!
####-----------------------#2.LOAD VERIFICATION POINTS#---------------------####
#-----------------------------------vp_1---------------------------------------#
vp_1 <- rgdal::readOGR(paste0(path_analysis_data_treepos, "treepos_1.shp"))
crs(vp_1) #+proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000
          #+ellps=bessel +towgs84=577.326,90.129,463.919,5.137,1.474,5.297,2.4232
#transform the projection of vp_1 to that of chm_1
vp_1 <- spTransform(vp_1, crs(chm_1))
crs(vp_1) #+proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel +units=m +no_defs
#-----------------------------------vp_2---------------------------------------#
vp_2 <- rgdal::readOGR(paste0(path_analysis_data_treepos, "treepos_2.shp"))
crs(vp_2) #+proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel
          #+towgs84=577.326,90.129,463.919,5.137,1.474,5.297,2.4232 +units=m +no_defs
#transform the projection of vp_2 to that of chm_1
vp_2 <- spTransform(vp_2, crs(chm_1))
crs(vp_2) #+proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel +units=m +no_defs
#-----------------------------------vp_3---------------------------------------#
vp_3 <- rgdal::readOGR(paste0(path_analysis_data_treepos, "treepos_3.shp"))
crs(vp_3) #+proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel
          #+towgs84=577.326,90.129,463.919,5.137,1.474,5.297,2.4232 +units=m +no_defs
#transform the projection of vp_3 to that of chm_1
vp_3 <- spTransform(vp_3, crs(chm_1))
crs(vp_3) #+proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel +units=m +no_defs
#-----------------------------------vp_4---------------------------------------#
vp_4 <- rgdal::readOGR(paste0(path_analysis_data_treepos, "treepos_4.shp"))
crs(vp_4) #+proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel
          #+towgs84=577.326,90.129,463.919,5.137,1.474,5.297,2.4232 +units=m +no_defs
crs(chm_4)
#transform the projection of vp_4 to that of chm_1
vp_4 <- spTransform(vp_4, crs(chm_1))
crs(vp_4) #+proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel +units=m +no_defs

####---------------------#3.PREPARE CV #--------------------####
chmlist <- list(chm_1, chm_2, chm_3, chm_4)
vplist <- list(vp_1, vp_2, vp_3, vp_4)

                         ####CV ON THE TEST AREAS####
#from bestsegval:
#the are altogether 8 results - we could try out all 8 if they fit for the other
#training areas
#      a     b       height total_seg hit.vp  under  over  area hitrate  underrate  overrate Seg_qualy   MIN   chm
#4   0.07  0.07      4        20      11 / 15     2     7  530.   0.733     0.1      0.35  0.73 @ 0.28   0.1 CHM_1_3

#start CV with model (a, b, h, MIN, MAX values - does not work without MAX)
cv1 <- CENITH::TreeSegCV(sites=chmlist, a=0.07, b=0.07, h=4, MIN=0.1, MAX=1000, CHMfilter=3, vps=vplist)
cv1
### Cenith finsihed 4fold cross validation ###
#Overall perfomance of model: 0.78 @ 0.33

#2  0.07  0.08    3.5        20 11 / 15     2     7  538.   0.733     0.1      0.35  0.73 @ 0.28   0.1 CHM_1_3
cv2 <- CENITH::TreeSegCV(sites=chmlist, a=0.07, b=0.08, h=3.5, MIN=0.1, MAX=1000, CHMfilter=3, vps=vplist)
#Overall perfomance of model: 0.78 @ 0.33

#3  0.07  0.09    3.5        20 11 / 15     2     7  538.   0.733     0.1      0.35  0.73 @ 0.28   0.1 CHM_1_3
cv3 <- CENITH::TreeSegCV(sites=chmlist, a=0.07, b=0.09, h=3.5, MIN=0.1, MAX=1000, CHMfilter=3, vps=vplist)
#Overall perfomance of model: 0.78 @ 0.32

#1  0.07  0.07    3.5          20 11 / 15     2     7  530.   0.733     0.1      0.35  0.73 @ 0.28   0.1 CHM_1_3
cv4 <- CENITH::TreeSegCV(sites=chmlist, a=0.07, b=0.07, h=3.5, MIN=0.1, MAX=1000, CHMfilter=3, vps=vplist)
#Overall perfomance of model: 0.78 @ 0.33

#5  0.07  0.08    4          20 11 / 15     2     7  530.   0.733     0.1      0.35  0.73 @ 0.28   0.1 CHM_1_3
cv5 <- CENITH::TreeSegCV(sites=chmlist, a=0.07, b=0.08, h=4, MIN=0.1, MAX=1000, CHMfilter=3, vps=vplist)
#Overall perfomance of model: 0.78 @ 0.32

#6  0.07  0.09    4          20 11 / 15     2     7  530.   0.733     0.1      0.35  0.73 @ 0.28   0.1 CHM_1_3
cv6 <- CENITH::TreeSegCV(sites=chmlist, a=0.07, b=0.09, h=4, MIN=0.1, MAX=1000, CHMfilter=3, vps=vplist)
#Overall perfomance of model: 0.78 @ 0.32

#7  0.07  0.1     3.5        19 11 / 15     2     6  538.   0.733     0.105    0.316 0.73 @ 0.26   0.1 CHM_1_3
cv7 <- CENITH::TreeSegCV(sites=chmlist, a=0.07, b=0.1, h=3.5, MIN=0.1, MAX=1000, CHMfilter=3, vps=vplist)
#Overall perfomance of model: 0.78 @ 0.31

#8  0.07  0.1     4          19 11 / 15     2     6  530.   0.733     0.105    0.316 0.73 @ 0.26   0.1 CHM_1_3
cv8 <- CENITH::TreeSegCV(sites=chmlist, a=0.07, b=0.1, h=4, MIN=0.1, MAX=1000, CHMfilter=3, vps=vplist)
#Overall perfomance of model: 0.78 @ 0.31

                        ####SEGMENT THER WHOLE ROI####
#cv1
segm_ROI <- CENITH::TreeSeg(CHM, a=0.07, b=0.07, h=4, MIN = 0.1, CHM=3)
#detected 901 trees ###
#clipped: 62 polygons. 839 trees remaining
writeOGR(obj=segm_ROI, dsn="segm", layer="segm_ROI", driver="ESRI Shapefile")

#cv2
segm_ROI_2 <- CENITH::TreeSeg(CHM, a=0.07, b=0.08, h=3.5, MIN = 0.1, CHM=3)
#detected 1078 trees ###
#clipped: 90 polygons. 988 trees remaining
writeOGR(obj=segm_ROI_2, dsn="segm", layer="segm_ROI_2", driver="ESRI Shapefile")

#cv3
segm_ROI_3 <- CENITH::TreeSeg(CHM, a=0.07, b=0.09, h=3.5, MIN = 0.1, CHM=3)
#detected 1060 trees ###
#clipped: 90 polygons. 970 trees remaining
writeOGR(obj=segm_ROI_3, dsn="segm", layer="segm_ROI_3", driver="ESRI Shapefile")

#cv4
segm_ROI_4 <- CENITH::TreeSeg(CHM, a=0.07, b=0.07, h=3.5, MIN = 0.1, CHM=3)
#detected 1096 trees ###
#clipped: 90 polygons. 1006 trees remaining
writeOGR(obj=segm_ROI_4, dsn="segm", layer="segm_ROI_4", driver="ESRI Shapefile")

#cv5
segm_ROI_5 <- CENITH::TreeSeg(CHM, a=0.07, b=0.08, h=4, MIN = 0.1, CHM=3)
#detected 883 trees ###
#clipped: 62 polygons. 821 trees remaining
writeOGR(obj=segm_ROI_5, dsn="segm", layer="segm_ROI_5", driver="ESRI Shapefile")

#cv6
segm_ROI_6 <- CENITH::TreeSeg(CHM, a=0.07, b=0.09, h=4, MIN = 0.1, CHM=3)
#detected 865 trees ###
#clipped: 62 polygons. 803 trees remaining
writeOGR(obj=segm_ROI_6, dsn="segm", layer="segm_ROI_6", driver="ESRI Shapefile")

#cv7
segm_ROI_7 <- CENITH::TreeSeg(CHM, a=0.07, b=0.1, h=3.5, MIN = 0.1, CHM=3)
#detected 1042 trees ###
#clipped: 90 polygons. 952 trees remaining###
writeOGR(obj=segm_ROI_7, dsn="segm", layer="segm_ROI_7", driver="ESRI Shapefile")

#cv8
segm_ROI_8 <- CENITH::TreeSeg(CHM, a=0.07, b=0.1, h=4, MIN = 0.1, CHM=3)
#detected 847 trees
#clipped: 61 polygons. 786 trees remaining
writeOGR(obj=segm_ROI_8, dsn="segm", layer="segm_ROI_8", driver="ESRI Shapefile")

                         ####FURTHER MANIPULATION####
#checking all of them in QGGIS is clear, that 3.5 m is too low and cv8 is the best,
#because it eliminates some small segments which could be shrubs (of course
#depending on the initial decision about tree and seedling height), so this is
#in the end the better segmentation. 4 m is great, but what happens at a height
#of 4.5 and 5 = the red area and at 5.1m (over the red) in QGIS?
#Can we make the segmentation better?

segm_ROI_9 <- CENITH::TreeSeg(CHM, a=0.07, b=0.1, h=4.5, MIN = 0.1, CHM=3)
#detected 731 trees ###
#clipped: 46 polygons. 685 trees remaining
writeOGR(obj=segm_ROI_9, dsn="segm", layer="segm_ROI_9", driver="ESRI Shapefile")
#the result stays almost the same

segm_ROI_10 <- CENITH::TreeSeg(CHM, a=0.07, b=0.1, h=5, MIN = 0.1, CHM=3)
#detected 656 trees ###
#clipped: 41 polygons. 615 trees remaining
writeOGR(obj=segm_ROI_10, dsn="segm", layer="segm_ROI_10", driver="ESRI Shapefile")
#with height 5m the area of the trees get smaller and younger trees are left out

segm_ROI_11 <- CENITH::TreeSeg(CHM, a=0.07, b=0.1, h=5.1, MIN = 0.1, CHM=3)
#detected 647 trees ###
#clipped: 44 polygons. 603 trees remaining
writeOGR(obj=segm_ROI_11, dsn="segm", layer="segm_ROI_11", driver="ESRI Shapefile")
#this is the case even more

segm_ROI_12 <- CENITH::TreeSeg(CHM, a=0.07, b=0.1, h=5.1, CHM=3)
#detected 647 trees ###
#clipped: 0 polygons. 647 trees remaining
writeOGR(obj=segm_ROI_12, dsn="segm", layer="segm_ROI_12", driver="ESRI Shapefile")
#test without MIN= 0.1 and even more
