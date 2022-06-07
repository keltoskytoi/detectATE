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
####-------------------------------#3.PREPARE CV #--------------------------####
chmlist <- list(chm_1, chm_2, chm_3, chm_4)
vplist <- list(vp_1, vp_2, vp_3, vp_4)

####-------------------------4.CV ON THE TEST AREAS-------------------------####
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

