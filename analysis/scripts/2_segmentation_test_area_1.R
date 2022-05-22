####--------------------------------SHORTCUTS-------------------------------####
#create shortcuts to the folders where de data and results are stored
lschm <-list.files(paste0(path_analysis_results_chm), pattern=".tif")
lstreepos <- list.files(paste0(path_analysis_data_treepos), pattern=".shp")
################################################################################
####-----#The aim is to find an accurate segmentation for test area 1#------####
####--------------------------#1.LOAD TEST AREA 1#-------------------------####
#if you haven't imported chm_1 yet(= didn't start with script 1_data_prep_general.R,),
#then please import chm_1
chm_1 <- raster(paste0(path_analysis_results_chm, lschm[[1]]))
####-----------------------#2.LOAD VERIFICATION POINTS#---------------------####
#------------------------------------vp 1--------------------------------------#
vp_1 <- rgdal::readOGR(paste0(path_analysis_data_treepos, lstreepos[[1]]))
#---------------------------plot chm_1 & vp_1----------------------------------#
mapview::mapview(chm_1) + vp_1

#still let's check the crs
crs(chm_1) #+proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel +units=m +no_defs
crs(vp_1) #+proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel +towgs84=577.326,90.129,463.919,5.137,1.474,5.297,2.4232

#thus vp_1 has to be reprojected to the crs of chm_1
vp_1 <- spTransform(vp_1, crs(chm_1))
writeOGR(obj=vp_1, dsn="C:/Users/kelto/Documents/detectATE/analysis/data/treepos",
         layer="vp_1", driver="ESRI Shapefile", verbose = TRUE, overwrite_layer = TRUE)
crs(chm_1) #+proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel +units=m +no_defs
crs(vp_1) #+proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel +units=m +no_defs
####---------------------#3.SEGMENTATION OF TEST AREA 1#--------------------####
#it was determined,, that h = 4-5 is a good height to get the top of the young trees
#but not the shrubs and Krummholz
#The aim is to find the best fitting values for a, b (horizontal & vertical values
#in meters) and h (height) based on chm_1 (and vp_1). MIN filters out the small
#segments and chmFilter filters out the small artifacts and errors in the chm.
#As explained in the tutorial, some combinations of a, b and h result in a
#MovingWindow which does not work: a and b must be odd.

test_0 <- TreeSeg(chm_1, a=0.1, b=0.2, h=4.5, MIN=1)
#detected 12 trees ###
### Cenith starts cropping to MIN and MAX ###
#clipped: 1 polygons. 11 trees remaining
#save shape file to the respective folder to be able to inspect it in QGIS
writeOGR(obj=test_0, dsn="C:/Users/kelto/Documents/detectATE/analysis/results/segm/segm_ta1",
         layer="chm1_test_0", driver="ESRI Shapefile", verbose = TRUE, overwrite_layer = TRUE)

test_1 <- TreeSeg(chm_1, a=0.1, b=0.2, h=4.5, MIN=1, CHMfilter = 3)
#detected 12 trees ###
### Cenith starts cropping to MIN and MAX ###
#clipped: 1 polygons. 11 trees remaining
#save shape file to the respective folder to be able to inspect it in QGIS
writeOGR(obj=test_1, dsn="C:/Users/kelto/Documents/detectATE/analysis/results/segm/segm_ta1",
         layer="chm1_test_1", driver="ESRI Shapefile", verbose = TRUE, overwrite_layer = TRUE)

test_2 <- TreeSeg(chm_1, a=0.1, b=0.1, h=4.5, MIN=1, CHMfilter = 3)
#detected 14 trees ###
### Cenith starts cropping to MIN and MAX ###
#clipped: 1 polygons. 13 trees remaining
#save shape file to the respective folder to be able to inspect it in QGIS
writeOGR(obj=test_2, dsn="C:/Users/kelto/Documents/detectATE/analysis/results/segm/segm_ta1",
         layer="chm1_test_2", driver="ESRI Shapefile", verbose = TRUE, overwrite_layer = TRUE)

test_3 <- TreeSeg(chm_1, a=0.05, b=0.05, h=4.5, MIN=1, CHMfilter = 3)
#detected 45 trees ###
### Cenith starts cropping to MIN and MAX ###
#clipped: 6 polygons. 39 trees remaining
#save shape file to the respective folder to be able to inspect it in QGIS
writeOGR(obj=test_3, dsn="C:/Users/kelto/Documents/detectATE/analysis/results/segm/segm_ta1",
         layer="chm1_test_3", driver="ESRI Shapefile", verbose = TRUE, overwrite_layer = TRUE)

####----------------------------#BEST SEG VAL#------------------------------####
#To find the best fitting values, a broader range of values are used for h, to test all possibilities.Thus we will set the height
#between 3,5 and 6 m - to show how it works
#------------------------------3.1 FIRST RUN-----------------------------------#
#Let test a whole sequence of variables to get the most out of the function!
best_seg_vp_1 <-BestSegVal(chm=chm_1, a=seq(0.05, 0.1, 0.01), b=seq(0.05, 0.1, 0.01),
                           h=seq(3.5, 6, 0.5), MIN=seq(0.1, 0.5, 0.1), filter=3,
                           vp=vp_1, skipCheck = FALSE)
### CENITH starts Best Parameter Validation ###
#checking input ...
#calculating estimate time to finish ...

#requires 1080 iterations @ 0.2254 mins per iteration
#estimated 292.1695 mins to finish
#----------------------------------------#
#save csv file to the respective folder to preserve the original result
write.csv(best_seg_vp_1, paste0(path_analysis_results_segm_segm_table, "best_seg_vp_1.csv"))

#----------------------------3.1a INVESTIGATE DATA-----------------------------#
#read the just exported .csv (will be handy in the future to work with it)
best_seg_vp_1 <- read.csv(paste0(path_analysis_results_segm_table, "best_seg_vp_1.csv"), header = TRUE, sep=",")

#let's transform the data table as a tibble####
best_seg_vp_1 <- as_tibble(best_seg_vp_1)
best_seg_vp_1
#there are 1080 observations, 15 variables and maximum 45 segments

#we have 15 trees/tree points/vps, so let's filter the data set to those results
#which have 20 segments, to give some space to eventual undersegmentation
best_seg_vp_1 <- best_seg_vp_1 %>%
  select(2:15)%>%
  arrange(total_seg)%>%
  filter(total_seg<=20)%>%
  arrange(desc(hitrate))

#check the results
best_seg_vp_1

#we got still 664 and we can see that the best hit rate is 0.7333333, but it is
#still to much to successfully decide which settings to choose. Thus it was decided
#to look for the highest hit rates, order them according to the most total
#segments and filter for up to 4 m height

best_seg_vp_1_filt <- best_seg_vp_1 %>%
  filter(hitrate >= 0.7)%>%
  arrange(desc(total_seg))%>%
  filter(height <= 4.0)

#check the results
best_seg_vp_1_filt
#this filtering resulted in 40 segmentations of which the first 4 correspond to
#the already tested values by TreeSeg and already investigated in QGIS.
#let's check the best result for 3.5 and the first three results for 4 m

#   a   b   height total_seg hit.vp  under over area  hitrate underrate overrate

#1  0.07  0.07    3.5          20     11 / 15     2     7  538.   0.733       0.1     0.35
test_vp0 <- TreeSeg(chm_1, a=0.07, b=0.07, h=3.5, MIN=0.1, CHMfilter = 3)
writeOGR(obj=test_vp0, dsn="C:/Users/kelto/Documents/detectATE/analysis/results/segm/segm_ta1",
         layer="chm1_test_vp0", driver="ESRI Shapefile", verbose = TRUE, overwrite_layer = TRUE)

#4   0.07  0.07      4        20      11 / 15     2     7  530.   0.733     0.1      0.35  0.73 @ 0.28   0.1 CHM_1_3
test_vp1 <- TreeSeg(chm_1, a=0.07, b=0.07, h=4, MIN=0.1, CHMfilter = 3)
writeOGR(obj=test_vp1, dsn="C:/Users/kelto/Documents/detectATE/analysis/results/segm/segm_ta1",
         layer="chm1_test_vp1", driver="ESRI Shapefile", verbose = TRUE, overwrite_layer = TRUE)

#5  0.07  0.08    4          20 11 / 15     2     7  530.   0.733       0.1     0.35 0.73 @ 0.28   0.1 CHM_1_3
test_vp2 <- TreeSeg(chm_1, a=0.07, b=0.08, h=4, MIN=0.1, CHMfilter = 3)
writeOGR(obj=test_vp2, dsn="C:/Users/kelto/Documents/detectATE/analysis/results/segm/segm_ta1",
         layer="chm1_test_vp2", driver="ESRI Shapefile", verbose = TRUE, overwrite_layer = TRUE)

#6  0.07  0.09    4          20 11 / 15     2     7  530.   0.733       0.1     0.35 0.73 @ 0.28   0.1 CHM_1_3
test_vp3 <- TreeSeg(chm_1, a=0.07, b=0.09, h=4, MIN=0.1, CHMfilter = 3)
writeOGR(obj=test_vp3, dsn="C:/Users/kelto/Documents/detectATE/analysis/results/segm/segm_ta1",
         layer="chm1_test_vp3", driver="ESRI Shapefile", verbose = TRUE, overwrite_layer = TRUE)

#We can see, that MIN=0.1 in each cases, and a & b are < 0.1. Thus a second run
#will be done with MIN=0.1, a=seq(0.01, 0.1, 0.01), b=seq(0.01, 0.1, 0.01) and
#CHMfilter = 3, but leaving all the other values in the broad range to enable a
#systematic analysis.

#------------------------------3.2 SECOND RUN----------------------------------#
best_seg_vp_1_v2 <-BestSegVal(chm=chm_1, a=seq(0.01, 0.1, 0.01), b=seq(0.01, 0.1, 0.01),
                              h=seq(3.5, 6, 0.5), MIN=0.1, filter=3,
                              vp=vp_1, skipCheck = FALSE)
### CENITH starts Best Parameter Validation ###
#checking input ...
#calculating estimate time to finish ...
#requires 600 iterations @ 0.1983 mins per iteration
#estimated 142.7668 mins to finish
#----------------------------------------#
#save csv file to the respective folder
write.csv(best_seg_vp_1_v2, paste0(path_analysis_results_segm_segm_table, "best_seg_vp_1_v2.csv"))

#----------------------------3.1a INVESTIGATE DATA-----------------------------#
#read the just exported .csv (will be handy in the future to work with it)
best_seg_vp_1_v2 <- read.csv(paste0(path_analysis_results_segm_segm_table, "best_seg_vp_1_v2.csv"), header = TRUE, sep=",")

#let's transform the data table as a tibble####
best_seg_vp_1_v2 <- as_tibble(best_seg_vp_1_v2)
best_seg_vp_1_v2
##there are 600 observations, 15 variables and maximum 712 segments

#we have 15 trees/tree points/vps, so let's filter the data set to those results #
#which have 20 segments
best_seg_vp_1_v2 <- best_seg_vp_1_v2 %>%
  select(2:15)%>%
  arrange(total_seg)%>%
  filter(total_seg<=20)%>%
  arrange(desc(hitrate))

#check the results
best_seg_vp_1_v2

#we got still 204 and we can see that the best hit rate is 0.7333333, but it is
#still to much to successfully decide which settings to choose. Thus it was decided
#to look for the highest hit rates, order them according to the most total
#segments and filter for up to 4 m height

best_seg_vp_1_v2_filt <- best_seg_vp_1_v2 %>%
  filter(hitrate >= 0.7)%>%
  arrange(desc(total_seg))%>%
  filter(height <= 4.0)

#check the results
best_seg_vp_1_v2_filt
#8 segmentations of which six are the same results of the first round.
#These results are not too many to be able to test them on the other test areas

#     a     b    height total_seg hit.vp  under  over  area hitrate underrate overrate Seg_qualy     MIN chm
#1  0.07  0.07    3.5        20 11 / 15     2     7  538.   0.733     0.1      0.35  0.73 @ 0.28   0.1 CHM_1_3
#2  0.07  0.08    3.5        20 11 / 15     2     7  538.   0.733     0.1      0.35  0.73 @ 0.28   0.1 CHM_1_3
#3  0.07  0.09    3.5        20 11 / 15     2     7  538.   0.733     0.1      0.35  0.73 @ 0.28   0.1 CHM_1_3
#4  0.07  0.07    4          20 11 / 15     2     7  530.   0.733     0.1      0.35  0.73 @ 0.28   0.1 CHM_1_3
#5  0.07  0.08    4          20 11 / 15     2     7  530.   0.733     0.1      0.35  0.73 @ 0.28   0.1 CHM_1_3
#6  0.07  0.09    4          20 11 / 15     2     7  530.   0.733     0.1      0.35  0.73 @ 0.28   0.1 CHM_1_3
#7  0.07  0.1     3.5        19 11 / 15     2     6  538.   0.733     0.105    0.316 0.73 @ 0.26   0.1 CHM_1_3
#8  0.07  0.1     4          19 11 / 15     2     6  530.   0.733     0.105    0.316 0.73 @ 0.26   0.1 CHM_1_3

write.csv(best_seg_vp_1_v2_filt, paste0(path_analysis_results_segm_segm_table, "best_seg_vp_1_v2_filt.csv"))
