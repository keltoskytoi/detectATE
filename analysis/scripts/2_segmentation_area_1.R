#PREAMBLE: QUITE LATE IN THE PROJECT IT WAS DISCOVERED; THAT THE RASTER PKG
#ONLY SUPPORTS A SIZE UP TO 12.3 MB FOR ROI (17.1 MB was too big) SO ALL THE
#CROPPING OF THE TEST AREAS WAS DONE IN QGIS

####################################SHORTCUTS###################################
lschm <-list.files(file.path(path_analysis_results_chm), pattern=".tif")
lssegm <- list.files(file.path(path_analysis_results_segm))
#make the plot show more than the minimum of rows
options(max.print=10000)

#AIM: to find an accurate segmentation for one of the test areas, which can
#be applied to the ROI

                         ####LOAD THE CHMS####
chm_1 <- raster(paste0(path_analysis_results_chm, lschm[[1]]))
crs(chm_1)
#+proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel +units=m +no_defs


                  ####LOAD VERIFICATION POINTS####
#setting vp - verification points: first thing: you have to decide about the
#minimum height of a tree and stick to it. The question is, if you also want to
#consider the young trees, then you have to check what the highest point of the
#shrubs is and then set a height above the highest shrubs. If you only care about
#the grown trees, then still you have to check the CHM in QGIS and decide on the
#basis of that!

#it was decided, that h = 4 is a good height to get the top of the young trees
#but not to get involved with the shrubs and Krummholz

#vp_1####
vp_1 <- rgdal::readOGR(paste0(path_analysis_data_treepos, "treepos_1.shp"))
crs(vp_1)
#+proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel +towgs84=577.326,90.129,463.919,5.137,1.474,5.297,2.4232
#+units=m +no_defs
crs(chm_1)
#transform the projection of vp_1
vp_1 <- spTransform(vp_1, crs(chm_1))
crs(vp_1)
#+proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel +units=m +no_defs

                 ####SUPERVISED SEGMENTATION####
#find the best fitting values for a, b and h based on the CHM (and vp)

#h is best defined on the basis of the chm and the RGB/IR raster in QGIS
#in case chm_1 this height is above 4 m, to clearly avoid shrubs (4-5 is in red
#to make it stick out) and to test all possibilities we set the height in the
#segmentation between 3,5 and 6 m.

test_0 <- TreeSeg(chm_1, a=0.1, b=0.2, h=4.5, MIN=1)
#detected 12 trees ###
### Cenith starts cropping to MIN and MAX ###
#clipped: 1 polygons. 11 trees remaining
writeOGR(obj=test_0, dsn="C:/Users/kelto/Documents/detectATE/analysis/results/segm",
         layer="chm1_test_0", driver="ESRI Shapefile", verbose = TRUE, overwrite_layer = TRUE)

test_1 <- TreeSeg(chm_1, a=0.1, b=0.2, h=4.5, MIN=1, CHMfilter = 3)
#detected 12 trees ###
### Cenith starts cropping to MIN and MAX ###
#clipped: 1 polygons. 11 trees remaining
writeOGR(obj=test_1, dsn="C:/Users/kelto/Documents/detectATE/analysis/results/segm",
         layer="chm1_test_1", driver="ESRI Shapefile", verbose = TRUE, overwrite_layer = TRUE)

test_2 <- TreeSeg(chm_1, a=0.1, b=0.1, h=4.5, MIN=1, CHMfilter = 3)
#detected 14 trees ###
### Cenith starts cropping to MIN and MAX ###
#clipped: 1 polygons. 13 trees remaining
writeOGR(obj=test_2, dsn="C:/Users/kelto/Documents/detectATE/analysis/results/segm",
         layer="chm1_test_2", driver="ESRI Shapefile", verbose = TRUE, overwrite_layer = TRUE)

test_3 <- TreeSeg(chm_1, a=0.05, b=0.05, h=4.5, MIN=1, CHMfilter = 3)
#detected 45 trees ###
### Cenith starts cropping to MIN and MAX ###
#clipped: 6 polygons. 39 trees remaining
writeOGR(obj=test_3, dsn="C:/Users/kelto/Documents/detectATE/analysis/results/segm",
         layer="chm1_test_3", driver="ESRI Shapefile", verbose = TRUE, overwrite_layer = TRUE)

##################################BEST SEG VAL##################################
                                ####FIRST RUN####
#Let test a whole sequence of variables to get the most out of the function!
best_seg_vp_1 <-BestSegVal(chm=chm_1, a=seq(0.05, 0.1, 0.01), b=seq(0.05, 0.1, 0.01),
                           h=seq(3.5, 6, 0.5), MIN=seq(0.1, 0.5, 0.1), filter=3,
                           vp=vp_1, skipCheck = TRUE)

write.csv(best_seg_vp_1, file.path(path_analysis_results_segm, "best_seg_vp_1.csv"))
best_seg_vp_1 <- read.csv(file.path(path_analysis_results_segm, "best_seg_vp_1.csv"), header = TRUE, sep=",")
#there are 1080 observations; and the maximum segments are 44

#let's transform the data table as a tibble####
best_seg_vp_1 <- as_tibble(best_seg_vp_1)
head(best_seg_vp_1)

#we have 15 trees/treepoints/vps, so let's filter the dataset to those results #
#which have 20 segments
best_seg_vp_1 <- best_seg_vp_1 %>%
  select(2:15)%>%
  arrange(total_seg)%>%
  filter(total_seg<=20)%>%
  arrange(desc(hitrate))

head(best_seg_vp_1)
#we get only 668 and we can see that the best hitrate is 0.7333333, so let's
#look for the highest hitrates, order it according to the most total segments
#and filter for up to 4 m height
best_seg_vp_1_filt <- best_seg_vp_1 %>%
  filter(hitrate >= 0.7)%>%
  arrange(desc(total_seg))%>%
  filter(height <= 4.0)

head(best_seg_vp_1_filt)
# let's check the best result for 3.5 and the first three results for 4 m and
#see if somethings changes!

#1  0.07  0.07    3.5        20 11 / 15     2     7  538.   0.733       0.1     0.35
test_vp0 <- TreeSeg(chm_1, a=0.07, b=0.07, h=3.5, MIN=0.1, CHMfilter = 3)
writeOGR(obj=test_vp0, dsn="segm", layer="chm1_test_vp0", driver="ESRI Shapefile")

#4   0.07  0.07      4        20      11 / 15     2     7  530.   0.733     0.1      0.35  0.73 @ 0.28   0.1 CHM_1_3
test_vp1 <- TreeSeg(chm_1, a=0.07, b=0.07, h=4, MIN=0.1, CHMfilter = 3)
writeOGR(obj=test_vp1, dsn="segm", layer="chm1_test_vp1", driver="ESRI Shapefile")

#5  0.07  0.08    4          20 11 / 15     2     7  530.   0.733       0.1     0.35 0.73 @ 0.28   0.1 CHM_1_3
test_vp2 <- TreeSeg(chm_1, a=0.07, b=0.08, h=4, MIN=0.1, CHMfilter = 3)
writeOGR(obj=test_vp2, dsn="segm", layer="chm1_test_vp2", driver="ESRI Shapefile")

#6  0.07  0.09    4          20 11 / 15     2     7  530.   0.733       0.1     0.35 0.73 @ 0.28   0.1 CHM_1_3
test_vp3 <- TreeSeg(chm_1, a=0.07, b=0.09, h=4, MIN=0.1, CHMfilter = 3)
writeOGR(obj=test_vp3, dsn="segm", layer="chm1_test_vp3", driver="ESRI Shapefile")

#nothing changes= chm1_test_vp1
#      a     b       height total_seg hit.vp  under  over  area hitrate  underrate  overrate Seg_qualy   MIN   chm
#1   0.07  0.07      4        20      11 / 15     2     7  530.   0.733     0.1      0.35  0.73 @ 0.28   0.1 CHM_1_3

                                ####SECOND RUN####
best_seg_vp_1_v2 <-BestSegVal(chm=chm_1, a=seq(0.01, 0.1, 0.01), b=seq(0.01, 0.1, 0.01),
                              h=seq(3.5, 6, 0.5), MIN=0.1, filter=3,
                              vp=vp_1, skipCheck = TRUE)
write.csv(best_seg_vp_1_v2, file.path(path_analysis_results_segm, "best_seg_vp_1_v2.csv"))
best_seg_vp_1_v2 <- read.csv(file.path(path_analysis_results_segm, "best_seg_vp_1_v2.csv"), header = TRUE, sep=",")

head(best_seg_vp_1_v2)
#let's transform the data table as a tibble####
best_seg_vp_1_v2 <- as_tibble(best_seg_vp_1_v2)

#we have 15 trees/treepoints/vps, so let's filter the dataset to those results #
#which have 20 segments
best_seg_vp_1_v2 <- best_seg_vp_1_v2 %>%
  select(2:15)%>%
  arrange(total_seg)%>%
  filter(total_seg<=20)%>%
  arrange(desc(hitrate))

head(best_seg_vp_1_v2)

#we get only 668 and we can see that the best hitrate is 0.7333333, so let's
#look for the highest hitrates, order it according to the most total segments
#and filter for up to 4 m height
best_seg_vp_1_v2_filt <- best_seg_vp_1_v2 %>%
  filter(hitrate >= 0.7)%>%
  arrange(desc(total_seg))%>%
  filter(height <= 4.0)

best_seg_vp_1_v2_filt
#     a     b    height total_seg hit.vp  under  over  area hitrate underrate overrate Seg_qualy     MIN chm
#1  0.07  0.07    3.5        20 11 / 15     2     7  538.   0.733     0.1      0.35  0.73 @ 0.28   0.1 CHM_1_3
#2  0.07  0.08    3.5        20 11 / 15     2     7  538.   0.733     0.1      0.35  0.73 @ 0.28   0.1 CHM_1_3
#3  0.07  0.09    3.5        20 11 / 15     2     7  538.   0.733     0.1      0.35  0.73 @ 0.28   0.1 CHM_1_3
#4  0.07  0.07    4          20 11 / 15     2     7  530.   0.733     0.1      0.35  0.73 @ 0.28   0.1 CHM_1_3
#5  0.07  0.08    4          20 11 / 15     2     7  530.   0.733     0.1      0.35  0.73 @ 0.28   0.1 CHM_1_3
#6  0.07  0.09    4          20 11 / 15     2     7  530.   0.733     0.1      0.35  0.73 @ 0.28   0.1 CHM_1_3
#7  0.07  0.1     3.5        19 11 / 15     2     6  538.   0.733     0.105    0.316 0.73 @ 0.26   0.1 CHM_1_3
#8  0.07  0.1     4          19 11 / 15     2     6  530.   0.733     0.105    0.316 0.73 @ 0.26   0.1 CHM_1_3
