####--------------------------------SHORTCUTS-------------------------------####
#create shortcuts to the folders where de data is stored
lschm <-list.files(paste0(path_analysis_results_chm), pattern=".tif")
lstreepos <- list.files(paste0(path_analysis_data_treepos), pattern=".shp")
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
#make sure they have the same crs!
####-----------------------#2.LOAD VERIFICATION POINTS#---------------------####
#-----------------------------------vp_1---------------------------------------#
vp_1 <- rgdal::readOGR(paste0(path_analysis_data_treepos, lstreepos[[1]]))
crs(vp_1) #+proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000
#we already transformed the projection of vp_1
#-----------------------------------vp_2---------------------------------------#
#the following vps are transformed, but not exported with the new crs, for training purposes
vp_2 <- rgdal::readOGR(paste0(path_analysis_data_treepos, lstreepos[[2]]))
crs(vp_2) #+proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel
          #+towgs84=577.326,90.129,463.919,5.137,1.474,5.297,2.4232 +units=m +no_defs
#transform the projection of vp_2 to that of chm_1
vp_2 <- spTransform(vp_2, crs(chm_1))
crs(vp_2) #+proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel +units=m +no_defs
#-----------------------------------vp_3---------------------------------------#
vp_3 <- rgdal::readOGR(paste0(path_analysis_data_treepos, lstreepos[[3]]))
crs(vp_3) #+proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel
          #+towgs84=577.326,90.129,463.919,5.137,1.474,5.297,2.4232 +units=m +no_defs
#transform the projection of vp_3 to that of chm_1
vp_3 <- spTransform(vp_3, crs(chm_1))
crs(vp_3) #+proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel +units=m +no_defs
#-----------------------------------vp_4---------------------------------------#
vp_4 <- rgdal::readOGR(paste0(path_analysis_data_treepos, lstreepos[[4]]))
crs(vp_4) #+proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel
          #+towgs84=577.326,90.129,463.919,5.137,1.474,5.297,2.4232 +units=m +no_defs
crs(chm_4)
#transform the projection of vp_4 to that of chm_1
vp_4 <- spTransform(vp_4, crs(chm_1))
crs(vp_4) #+proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel +units=m +no_defs

####------------------------------#3.PREPARE FOR CV #-----------------------####
chmlist <- list(chm_1, chm_2, chm_3, chm_4)
vplist <- list(vp_1, vp_2, vp_3, vp_4)

####----------#4.CROSS VALIDATED SEGMENTATION PON THE TEST AREAS#-----------####
#The 8 results from best_seg_vp_1_filt_v2 are tested, how they fit on the other
#training areas
#NB: TreeSegCV does not work without setting values for MAX. Thus it was set to
#1000 to avoid any influence

#-------------------------cv_1 / best_seg_vp_1_v2_filt#4-----------------------#
#Out of curiosity first the best result with h04 was processed
#      a     b    height  total_seg   hit.vp   under over area hitrate  underrate overrate Seg_qualy   MIN   chm
#4   0.07  0.07     4        20      11 / 15     2     7  530.  0.733     0.1      0.35   0.73 @ 0.28 0.1 CHM_1_3
cv1 <- CENITH::TreeSegCV(sites=chmlist, a=0.07, b=0.07, h=4, MIN=0.1, MAX=1000, CHMfilter=3, vps=vplist)
#Overall perfomance of model: 0.78 @ 0.32
names(cv1)
write.csv(cv1, paste0(path_analysis_results_segm_segm_table, "cv1.csv"))

#-------------------------cv_2 / best_seg_vp_1_v2_filt#2-----------------------#
#     a     b    height  total_seg   hit.vp   under over area hitrate  underrate overrate Seg_qualy   MIN   chm
#2  0.07  0.08    3.5        20 11 / 15     2     7  538.   0.733     0.1      0.35  0.73 @ 0.28   0.1 CHM_1_3
cv2 <- CENITH::TreeSegCV(sites=chmlist, a=0.07, b=0.08, h=3.5, MIN=0.1, MAX=1000, CHMfilter=3, vps=vplist)
#Overall perfomance of model: 0.78 @ 0.33
write.csv(cv2, paste0(path_analysis_results_segm_segm_table, "cv2.csv"))

#-------------------------cv_3 / best_seg_vp_1_v2_filt#3-----------------------#
#     a     b    height  total_seg   hit.vp   under over area hitrate  underrate overrate Seg_qualy   MIN   chm
#3  0.07  0.09    3.5        20 11 / 15     2     7  538.   0.733     0.1      0.35  0.73 @ 0.28   0.1 CHM_1_3
cv3 <- CENITH::TreeSegCV(sites=chmlist, a=0.07, b=0.09, h=3.5, MIN=0.1, MAX=1000, CHMfilter=3, vps=vplist)
#Overall perfomance of model: 0.78 @ 0.32
write.csv(cv3, paste0(path_analysis_results_segm_segm_table, "cv3.csv"))

#-------------------------cv_4 / best_seg_vp_1_v2_filt#1-----------------------#
#     a     b    height  total_seg   hit.vp   under over area hitrate  underrate overrate Seg_qualy   MIN   chm
#1  0.07  0.07    3.5          20 11 / 15     2     7  530.   0.733     0.1      0.35  0.73 @ 0.28   0.1 CHM_1_3
cv4 <- CENITH::TreeSegCV(sites=chmlist, a=0.07, b=0.07, h=3.5, MIN=0.1, MAX=1000, CHMfilter=3, vps=vplist)
#Overall perfomance of model: 0.78 @ 0.33
write.csv(cv4, paste0(path_analysis_results_segm_segm_table, "cv4.csv"))

#-------------------------cv_5 / best_seg_vp_1_v2_filt#5-----------------------#
#     a     b    height  total_seg   hit.vp   under over area hitrate  underrate overrate Seg_qualy   MIN   chm
#5  0.07  0.08    4          20     11 / 15    2     7   530.  0.733     0.1      0.35   0.73 @ 0.28  0.1 CHM_1_3
cv5 <- CENITH::TreeSegCV(sites=chmlist, a=0.07, b=0.08, h=4, MIN=0.1, MAX=1000, CHMfilter=3, vps=vplist)
#Overall perfomance of model: 0.78 @ 0.32
write.csv(cv5, paste0(path_analysis_results_segm_segm_table, "cv5.csv"))

#-------------------------cv_6 / best_seg_vp_1_v2_filt#6-----------------------#
#     a     b   height  total_seg   hit.vp   under over area hitrate  underrate overrate Seg_qualy  MIN   chm
#6  0.07  0.09    4         20     11 / 15     2     7  530.   0.733    0.1      0.35   0.73 @ 0.28 0.1 CHM_1_3
cv6 <- CENITH::TreeSegCV(sites=chmlist, a=0.07, b=0.09, h=4, MIN=0.1, MAX=1000, CHMfilter=3, vps=vplist)
#Overall perfomance of model: 0.78 @ 0.32
write.csv(cv6, paste0(path_analysis_results_segm_segm_table, "cv6.csv"))

#-------------------------cv_7 / best_seg_vp_1_v2_filt#7-----------------------#
#     a     b    height  total_seg  hit.vp   under over area hitrate  underrate overrate Seg_qualy   MIN   chm
#7  0.07  0.1     3.5        19     11 / 15   2     6  538.   0.733     0.105    0.316   0.73 @ 0.26 0.1 CHM_1_3
cv7 <- CENITH::TreeSegCV(sites=chmlist, a=0.07, b=0.1, h=3.5, MIN=0.1, MAX=1000, CHMfilter=3, vps=vplist)
#Overall perfomance of model: 0.78 @ 0.31
write.csv(cv7, paste0(path_analysis_results_segm_segm_table, "cv7.csv"))

#-------------------------cv_8 / best_seg_vp_1_v2_filt#8-----------------------#
#     a     b   height  total_seg   hit.vp   under over area hitrate  underrate overrate Seg_qualy   MIN   chm
#8  0.07  0.1     4        19       11 / 15   2     6  530.   0.733     0.105    0.316 0.73 @ 0.26  0.1 CHM_1_3
cv8 <- CENITH::TreeSegCV(sites=chmlist, a=0.07, b=0.1, h=4, MIN=0.1, MAX=1000, CHMfilter=3, vps=vplist)
#Overall perfomance of model: 0.78 @ 0.31
write.csv(cv8, paste0(path_analysis_results_segm_segm_table, "cv8.csv"))
