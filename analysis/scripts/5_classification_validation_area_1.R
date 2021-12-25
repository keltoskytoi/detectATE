####################################SHORTCUTS###################################
lstrain <- list.files(file.path(path_train), pattern=".shp")
lspredictor1 <- list.files(file.path(path_prdctr1), pattern=".tif")
lspredictor2 <- list.files(file.path(path_prdctr2), pattern=".tif")
lspredictor3 <- list.files(file.path(path_prdctr3), pattern=".tif")
lspredictor4 <- list.files(file.path(path_prdctr4), pattern=".tif")
lspredictor5 <- list.files(file.path(path_prdctr5), pattern=".tif")
lspredictor6 <- list.files(file.path(path_prdctr6), pattern=".tif")
lspredictor7 <- list.files(file.path(path_prdctr7), pattern=".tif")
lspredictor8 <- list.files(file.path(path_prdctr8), pattern=".tif")
lspredictor10 <- list.files(file.path(path_prdctr10), pattern=".tif")
lstraindat <- list.files(file.path(path_traindat), pattern=".csv")
lsFFS <- list.files(file.path(path_FFS), pattern = ".rds")
lsmod <- list.files(file.path(path_models), pattern = ".rds")
lspred <- list.files(file.path(path_predictions), pattern=".tif")
lssegm <- list.files(file.path(path_segm), pattern=".shp")

####################################LOAD DATA###################################

#PREDICTORS 1: all indices, all filter ####
predictors_1 <- raster::stack(paste0(path_prdctr1, lspredictor1))
names(predictors_1) #28
#PREDICTORS 2: without min, max filter & VARI, HI, RI ####
predictors_2 <- raster::stack(paste0(path_prdctr2, lspredictor2))
names(predictors_2) #18
#PREDICTORS 3: with all filter & without VARI, HI, RI ####
predictors_3 <- raster::stack(paste0(path_prdctr3, lspredictor3))
names(predictors_3) #18
#PREDICTORS 4: all stack + homogeneity 0.7 + all filters ####
predictors_4 <- raster::stack(paste0(path_prdctr4, lspredictor4))
names(predictors_4) #16
#PREDICTORS 5: all stack + homogeneity 0.7 + without min & max filters ####
predictors_5 <- raster::stack(paste0(path_prdctr5, lspredictor5))
names(predictors_5) #17 
#PREDICTORS 6: all stack + homogeneity 0.4 + all filters ####
predictors_6 <- raster::stack(paste0(path_prdctr6, lspredictor6))
names(predictors_6) #11
#PREDICTORS 7: all stack + homogeneity 0.4 + without min & max filters ####
predictors_7 <- raster::stack(paste0(path_prdctr7, lspredictor7))
names(predictors_7) #11
#PREDICTORS 8: all stack + homogeneity 0.7 - HI + without min & max filters ####
predictors_8 <- raster::stack(paste0(path_prdctr8, lspredictor8))
names(predictors_8) #15
#another idea: 
#PREDICTORS 9: all stack + homogeneity 0.7 + without min & max filters #### 
#Predictors 5 - HI = 14
predictors_9_ <- raster::stack(paste0(path_prdctr5, lspredictor5))
names(predictors_9_)
predictors_9 <-predictors_9_[[- c(4:6)]]
names(predictors_9) #14
#PREDICTORS 10: all stack + RGB + NIR -HI homogeneity 0.7 - min/max filter ####
predictors_10 <- raster::stack(paste0(path_prdctr10, lspredictor10))
names(predictors_10) #14

#load training polygons####
train_1 <-readOGR(file.path(path_train, lstrain[[1]])) 
train_2 <-readOGR(file.path(path_train, lstrain[[2]])) 

#load segmentation of area 1####
lssegm #"chm1_test_vp1.shp"
seg_1 <- readOGR(file.path(path_segm, lssegm[[5]]))

#check the crs of the data
crs(predictors_1)
crs(predictors_2)
crs(predictors_3)
crs(predictors_4)
crs(predictors_5)
crs(train_1)
train_1 <- spTransform(train_1, crs(predictors_1))
train_2 <- spTransform(train_2, crs(predictors_2))
crs(train_1)
crs(train_2)
crs(seg_1)

##############################1ST PART: PREDICTION AREA 1#######################
#######################EXTRACT TRAINING DATA FROM POLYGONS######################
#####TRAIN 1 PREDICTORS 1 - FFS1####
train1_pred1 <- IKARUS::exrct_Traindat(train_1, predictors_1, "class")
#NAs detected: deleting 124501  NAs
write.csv(train1_pred1, file.path(path_traindat, "train1_pred1.csv"))

#####TRAIN 2 PREDICTORS 1 - FFS2####
train2_pred1 <- IKARUS::exrct_Traindat(train_2, predictors_1, "class")
#NAs detected: deleting 123418  NAs
write.csv(train2_pred1, file.path(path_traindat, "train2_pred1.csv"))

#####TRAIN 2 PREDICTORS 2 - FFS3####
train2_pred2 <- IKARUS::exrct_Traindat(train_2, predictors_2, "class")
#NAs detected: deleting 101213  NAs
write.csv(train2_pred2, file.path(path_traindat, "train2_pred2.csv"))

#####TRAIN 1 PREDICTORS 2 - FFS4####
train1_pred2 <- IKARUS::exrct_Traindat(train_1, predictors_2, "class")
write.csv(train1_pred2, file.path(path_traindat, "train1_pred2.csv"))

#####TRAIN 1 PREDICTORS 3 - FFS5####
train1_pred3 <- IKARUS::exrct_Traindat(train_1, predictors_3, "class")
write.csv(train1_pred3, file.path(path_traindat, "train1_pred3.csv"))
#####TRAIN 1 PREDICTORS 4 - FFS6####
train1_pred4 <- IKARUS::exrct_Traindat(train_1, predictors_4, "class")
write.csv(train1_pred4, file.path(path_traindat, "train1_pred4.csv"))
#####TRAIN 1 PREDICTORS 5 - FFS7####
train1_pred5 <- IKARUS::exrct_Traindat(train_1, predictors_5, "class")
write.csv(train1_pred5, file.path(path_traindat, "train1_pred5.csv"))
#####TRAIN 1 PREDICTORS 6 - FFS8####
train1_pred6 <- IKARUS::exrct_Traindat(train_1, predictors_6, "class")
write.csv(train1_pred6, file.path(path_traindat, "train1_pred6.csv"))
#####TRAIN 1 PREDICTORS 7 - FFS9####
train1_pred7 <- IKARUS::exrct_Traindat(train_1, predictors_7, "class")
write.csv(train1_pred7, file.path(path_traindat, "train1_pred7.csv"))
#####TRAIN 1 PREDICTORS 8 - FFS10####
train1_pred8 <- IKARUS::exrct_Traindat(train_1, predictors_8, "class")
write.csv(train1_pred8, file.path(path_traindat, "train1_pred8.csv"))
#####TRAIN 1 PREDICTORS 9 - FFS11####
train1_pred9 <- IKARUS::exrct_Traindat(train_1, predictors_9, "class")
write.csv(train1_pred9, file.path(path_traindat, "train1_pred9.csv"))
#####TRAIN 1 PREDICTORS 9 - FFS12####
train1_pred10 <- IKARUS::exrct_Traindat(train_1, predictors_10, "class")
write.csv(train1_pred10, file.path(path_traindat, "train1_pred10.csv"))
##############################FORWARD FEATURE SELECTION##########################
####FFS1 - TRAIN 1 - PREDICTORS 1####
FFS_1 <- IKARUS::BestPredFFS(train1_pred1, predCol = "default", 
                             classCol = "class", Cores = 1)
#728 max ... 276
#needed 0.139 hours  
#Note: No increase in performance found using more than 4 variables
#selected variables
#MSR_min3_corr_09_pred_1, RI_min3_corr_09_pred_1, HI_max3_corr_09_pred_1, TGI_max3_corr_09_pred_1 
saveRDS(FFS_1, file=file.path(path_FFS,"FFS_1.rds"))
FFS_1$selectedvars # show seleted variables
#MSR_min3corr_09_pred_1, RI_min3corr_09_pred_1, TGI_max3corr_09_pred_1, HI_max3corr_09_pred_1 
FFS_1$perf_all # show performance of all combinations
FFS_1$finalModel 

####FFS2 - TRAIN 2 - PREDICTORS 1####
FFS_2 <- IKARUS::BestPredFFS(train2_pred1 , predCol = "default", 
                             classCol = "class", Cores = 1)
#728 max ... 
#needed 0.2421 hours  
#Note: No increase in performance found using more than 3 variables
#selected variables
#HI_max3_corr_09_pred_1, TGI_max3_corr_09_pred_1, HI_sd3_corr_09_pred_1  
saveRDS(FFS_2, file=file.path(path_FFS,"FFS_2.rds"))

FFS_2$selectedvars 
FFS_2$perf_all 
FFS_2$finalModel

####FFS3 - TRAIN 2 - PREDICTORS 2####
FFS_3 <- IKARUS::BestPredFFS(train2_pred2, predCol = "default", 
                             classCol = "class", Cores = 1)
#288 max ... 78
#needed 0.1996 hours 
#Note: No increase in performance found using more than 5 variables
#SI_sum3_corr_09_pred_2, VVI_sum3_corr_09_pred_2, GLI_modal3_corr_09_pred_2, 
#TGI_sum3_corr_09_pred_2, GLI_sobel_v3_corr_09_pred_2 
saveRDS(FFS_3, file=file.path(path_FFS,"FFS_3.rds"))

####FFS4 - TRAIN 1 - PREDICTORS 2####
FFS_4 <- IKARUS::BestPredFFS(train1_pred2, predCol = "default", classCol = "class", Cores = 1)
#288 max ... 45
#needed 0.1452 hours
#Note: No increase in performance found using more than 8 variables
#MSR_modal3_corr_09_pred_2, TGI_sum3_corr_09_pred_2, VVI_modal3_corr_09_pred_2, 
#TGI_sobel_h3_corr_09_pred_2, GLI_modal3_corr_09_pred_2, VVI_sd3_corr_09_pred_2, 
#TDVI_sd3_corr_09_pred_2, TGI_sd3_corr_09_pred_2
saveRDS(FFS_4, file=file.path(path_FFS,"FFS_4.rds"))

####FFS5 - TRAIN 1 - PREDICTORS 3####
FFS_5 <- IKARUS::BestPredFFS(train1_pred3, predCol = "default", classCol = "class", Cores = 1)
#288 max ... 105
#needed 0.0602 hours 
#Note: No increase in performance found using more than 3 variables
#MSR_min3_corr_09_pred_3, VVI_min3_corr_09_pred_3, TGI_max3_corr_09_pred_3 
saveRDS(FFS_5, file=file.path(path_FFS,"FFS_5.rds"))

####FFS6 - TRAIN 1 - PREDICTORS 4####
FFS_6 <- IKARUS::BestPredFFS(train1_pred4, predCol = "default", classCol = "class", Cores = 1)
#224 max ...45
#needed 0.0601 hours 
#Note: No increase in performance found using more than 6 variables
#GLI_max3_corr_09_pred_4, MSR_min3_corr_09_pred_4, HI_max3_corr_09_pred_4, 
#TGI_max3_corr_09_pred_4, TDVI_sobel3_corr_09_pred_4, HI_sobel_v3_corr_09_pred_4  

saveRDS(FFS_6, file=file.path(path_FFS,"FFS_6.rds"))

####FFS7 - TRAIN 1 - PREDICTORS 5####
FFS_7 <- IKARUS::BestPredFFS(train1_pred5, predCol = "default", classCol = "class", Cores = 1)
#255 max ... 55
#needed 0.103 hours
#Note: No increase in performance found using more than 6 variables
#MSR_modal3_corr_09_pred_5, SI_mean3_corr_09_pred_5, TDVI_sd3_corr_09_pred_5, 
#HI_sobel3_corr_09_pred_5, TGI_sum3_corr_09_pred_5, SR_sd3_corr_09_pred_5
saveRDS(FFS_7, file=file.path(path_FFS,"FFS_7.rds"))

####FFS8 - TRAIN 1 - PREDICTORS 6####
FFS_8 <- IKARUS::BestPredFFS(train1_pred6, predCol = "default", classCol = "class", Cores = 1)
#99 max ... 28
#needed 0.0247 hours
#Note: No increase in performance found using more than 3 variables
#MSR_min3_corr_09_pred_6, TGI_min3_corr_09_pred_6, NGRDI_min3_corr_09_pred_6 
saveRDS(FFS_8, file=file.path(path_FFS,"FFS_8.rds"))

####FFS9 - TRAIN 1 - PREDICTORS 7####
FFS_9 <- IKARUS::BestPredFFS(train1_pred7, predCol = "default", classCol = "class", Cores = 1)
#99 max ... 28
#needed 0.0287 hours
#Note: No increase in performance found using more than 3 variables
#NDVI_modal3_corr_09_pred_7, TGI_sum3_corr_09_pred_7, MSR_sobel_h3_corr_09_pred_7 
saveRDS(FFS_9, file=file.path(path_FFS,"FFS_9.rds"))

####FFS10 - TRAIN 1 - PREDICTORS 8####
FFS_10 <- IKARUS::BestPredFFS(train1_pred8, predCol = "default", classCol = "class", Cores = 1)
# 195 max ... 45
#needed 0.0916 hours
#Note: No increase in performance found using more than 5 variables
#MSR_modal3_corr_09_pred_8, TGI_mean3_corr_09_pred_8, GLI_sd3_corr_09_pred_8, 
#TDVI_sd3_corr_09_pred_8, TGI_sobel_h3_corr_09_pred_8 
 
saveRDS(FFS_10, file=file.path(path_FFS,"FFS_10.rds"))

####FFS11 - TRAIN 1 - PREDICTORS 9####
FFS_11 <- IKARUS::BestPredFFS(train1_pred9, predCol = "default", classCol = "class", Cores = 1)
# 168 max ... 
#needed 0.043 hours 
#Note:No increase in performance found using more than 5 variables
#MSR_modal3_corr_09_pred_5, TGI_sum3_corr_09_pred_5, GLI_modal3_corr_09_pred_5, 
#TGI_sd3_corr_09_pred_5, TDVI_sd3_corr_09_pred_5 
saveRDS(FFS_11, file=file.path(path_FFS,"FFS_11.rds"))

####FFS12 - TRAIN 1 - PREDICTORS 10####
FFS_12 <- IKARUS::BestPredFFS(train1_pred10, predCol = "default", classCol = "class", Cores = 1)
#168 max
#needed 0.0474 hours
#Note: No increase in performance found using more than 5 variables
#TGI_modal3_corr_09_pred_10, TGI_sobel_v3_corr_09_pred_10, GLI_modal3_corr_09_pred_10, 
#TDVI_sobel3_corr_09_pred_10, SI_modal3_corr_09_pred_10
saveRDS(FFS_12, file=file.path(path_FFS,"FFS_12.rds"))

############################EXTRACT FINAL PREDICTORS############################
####BEST predictors_FFS_1 + train_FFS_1####
#best predictors are: MSR_min3_corr_09_pred_1, RI_min3_corr_09_pred_1, 
#                     TGI_max3corr_09_pred_1, HI_max3_corr_09_pred_1 
#filter the train1_pred1 traindat to the selected variables: 
train_FFS_1 <- train1_pred1[, c(5, 8, 18, 2, 29)] 
names(train_FFS_1)
#[1] "MSR_min3_corr_09_pred_1" "RI_min3_corr_09_pred_1"  "TGI_max3_corr_09_pred_1" 
#"HI_max3_corr_09_pred_1" "class"

#to much homogeneity is not reductive for FFS because then it chooses
#the wrong predictors

#filter the predictorstack to the selected variables
predictors_FFS_1 <- raster::stack(predictors_1$MSR_min3_corr_09_pred_1,
                                  predictors_1$RI_min3_corr_09_pred_1,
                                  predictors_1$TGI_max3_corr_09_pred_1,
                                  predictors_1$HI_max3_corr_09_pred_1)

####BEST predictors_FFS_2 + train_FFS_2####
##HI_max3_corr_09_pred_1, TGI_max3_corr_09_pred_1, HI_sd3_corr_09_pred_1   
#filter the train2_pred1 traindat to the selected variables:
train_FFS_2 <- train2_pred1[, c(2, 18, 3, 29)] 
names(train_FFS_2)
#[1] "HI_max3_corr_09_pred_1"  "TGI_max3_corr_09_pred_1" "HI_sd3_corr_09_pred_1"   "class" 

predictors_FFS_2 <- raster::stack(predictors_1$HI_max3_corr_09_pred_1,
                                  predictors_1$TGI_max3_corr_09_pred_1,
                                  predictors_1$HI_sd3_corr_09_pred_1)

####BEST predictors_FFS_3 + train_FFS_3####
##SI_sum3_corr_09_pred_2, VVI_sum3_corr_09_pred_2, GLI_modal3_corr_09_pred_2, 
#TGI_sum3_corr_09_pred_2, GLI_sobel_v3_corr_09_pred_2 
#filter the train2_pred2 traindat to the selected variables:
train_FFS_3 <- train2_pred2[, c(9, 18, 1, 14, 2, 19)] 
names(train_FFS_3)
#[1] "SI_sum3_corr_09_pred_2"      "VVI_sum3_corr_09_pred_2"     "GLI_modal3_corr_09_pred_2"   "TGI_sum3_corr_09_pred_2"    
#[5] "GLI_sobel_v3_corr_09_pred_2" "class"
predictors_FFS_3 <- raster::stack(predictors_2$SI_sum3_corr_09_pred_2 ,
                                  predictors_2$VVI_sum3_corr_09_pred_2,
                                  predictors_2$GLI_modal3_corr_09_pred_2,
                                  predictors_2$TGI_sum3_corr_09_pred_2,
                                  predictors_2$GLI_sobel_v3_corr_09_pred_2)

####BEST predictors_FFS_4 + train_FFS_4####
##MSR_modal3_corr_09_pred_2, TGI_sum3_corr_09_pred_2, VVI_modal3_corr_09_pred_2, 
#TGI_sobel_h3_corr_09_pred_2, GLI_modal3_corr_09_pred_2, VVI_sd3_corr_09_pred_2, 
#TDVI_sd3_corr_09_pred_2, TGI_sd3_corr_09_pred_2

#filter the train1_pred2 traindat to the selected variables: 
train_FFS_4 <- train1_pred2[, c(4, 14, 15, 13, 1, 16, 11, 12, 19)] 
names(train_FFS_4)
#[1] "MSR_modal3_corr_09_pred_2"   "TGI_sum3_corr_09_pred_2"     "VVI_modal3_corr_09_pred_2"   "TGI_sobel_h3_corr_09_pred_2"
#[5] "GLI_modal3_corr_09_pred_2"   "VVI_sd3_corr_09_pred_2"      "TDVI_sd3_corr_09_pred_2"     "TGI_sd3_corr_09_pred_2"     
#[9] "class"

predictors_FFS_4 <- raster::stack(predictors_2$MSR_modal3_corr_09_pred_2,
                                  predictors_2$TGI_sum3_corr_09_pred_2,
                                  predictors_2$VVI_modal3_corr_09_pred_2,
                                  predictors_2$TGI_sobel_h3_corr_09_pred_2,
                                  predictors_2$GLI_modal3_corr_09_pred_2,
                                  predictors_2$VVI_sd3_corr_09_pred_2,
                                  predictors_2$TDVI_sd3_corr_09_pred_2,
                                  predictors_2$TGI_sd3_corr_09_pred_2)

####BEST predictors_FFS_5 + train_FFS_5####
##MSR_min3_corr_09_pred_3, VVI_min3_corr_09_pred_3, TGI_max3_corr_09_pred_3
#filter the  train1_pred3 traindat to the selected variables: 
train_FFS_5 <- train1_pred3[, c(4, 15, 12, 19)] 
names(train_FFS_5)
#[1] "MSR_min3_corr_09_pred_3" "VVI_min3_corr_09_pred_3" "TGI_max3_corr_09_pred_3" "class"

predictors_FFS_5 <- raster::stack(predictors_3$MSR_min3_corr_09_pred_3,
                                  predictors_3$VVI_min3_corr_09_pred_3,
                                  predictors_3$TGI_max3_corr_09_pred_3)

####BEST predictors_FFS_6 + train_FFS_6####
##GLI_max3_corr_09_pred_4, MSR_min3_corr_09_pred_4, HI_max3_corr_09_pred_4, 
#TGI_max3_corr_09_pred_4, TDVI_sobel3_corr_09_pred_4, HI_sobel_v3_corr_09_pred_4  

#filter the  train1_pred4 traindat to the selected variables:
train_FFS_6 <- train1_pred4[, c(1, 7, 4, 14, 13, 6, 17)] 
names(train_FFS_6)
#[1] "GLI_max3_corr_09_pred_4"    "MSR_min3_corr_09_pred_4"    "HI_max3_corr_09_pred_4"     "TGI_max3_corr_09_pred_4"   
#[5] "TDVI_sobel3_corr_09_pred_4" "HI_sobel_v3_corr_09_pred_4" "class"

predictors_FFS_6 <- raster::stack(predictors_4$GLI_max3_corr_09_pred_4,
                                  predictors_4$MSR_min3_corr_09_pred_4,
                                  predictors_4$HI_max3_corr_09_pred_4,
                                  predictors_4$TGI_max3_corr_09_pred_4, 
                                  predictors_4$TDVI_sobel3_corr_09_pred_4,
                                  predictors_4$HI_sobel_v3_corr_09_pred_4)

####BEST predictors_FFS_7 + train_FFS_7####
#MSR_modal3_corr_09_pred_5, SI_mean3_corr_09_pred_5, TDVI_sd3_corr_09_pred_5, 
#HI_sobel3_corr_09_pred_5, TGI_sum3_corr_09_pred_5, SR_sd3_corr_09_pred_5

#filter the  train1_pred5 traindat to the selected variables:
train_FFS_7 <- train1_pred5[, c( 7, 10, 14, 5, 17, 13, 18)] 
names(train_FFS_7)
#1] "MSR_modal3_corr_09_pred_5" "SI_mean3_corr_09_pred_5"   "TDVI_sd3_corr_09_pred_5"   "HI_sobel3_corr_09_pred_5" 
#[5] "TGI_sum3_corr_09_pred_5"   "SR_sd3_corr_09_pred_5"     "class"

predictors_FFS_7 <- raster::stack(predictors_5$MSR_modal3_corr_09_pred_5,
                                  predictors_5$SI_mean3_corr_09_pred_5,
                                  predictors_5$TDVI_sd3_corr_09_pred_5,
                                  predictors_5$HI_sobel3_corr_09_pred_5, 
                                  predictors_5$TGI_sum3_corr_09_pred_5,
                                  predictors_5$SR_sd3_corr_09_pred_5)

ffs_7 <- read_rds(file.path(path_FFS,"FFS_7.rds"))
ffs_7$finalModel

####BEST predictors_FFS_8 + train_FFS_8####
#MSR_min3_corr_09_pred_6, TGI_min3_corr_09_pred_6, NGRDI_min3_corr_09_pred_6 

#filter the  train1_pred6 traindat to the selected variables:
train_FFS_8 <- traixn1_pred6[, c(1, 9, 5, 12)] 
names(train_FFS_8)
#[1] "MSR_min3_corr_09_pred_6"   "TGI_min3_corr_09_pred_6"   "NGRDI_min3_corr_09_pred_6" "class" 

predictors_FFS_8 <- raster::stack(predictors_6$MSR_min3_corr_09_pred_6,
                                  predictors_6$TGI_min3_corr_09_pred_6,
                                  predictors_6$NGRDI_min3_corr_09_pred_6)

####BEST predictors_FFS_9 + train_FFS_9####
##NDVI_modal3_corr_09_pred_7, TGI_sum3_corr_09_pred_7, MSR_sobel_h3_corr_09_pred_7  

#filter the  train1_pred7 traindat to the selected variables:
train_FFS_9 <- train1_pred7[, c(4, 11, 3, 12)] 
names(train_FFS_9)
#[1] "NDVI_modal3_corr_09_pred_7"  "TGI_sum3_corr_09_pred_7"     "MSR_sobel_h3_corr_09_pred_7" "class" 
predictors_FFS_9 <- raster::stack(predictors_7$NDVI_modal3_corr_09_pred_7,
                                  predictors_7$TGI_sum3_corr_09_pred_7,
                                  predictors_7$MSR_sobel_h3_corr_09_pred_7)

####BEST predictors_FFS_10 + train_FFS_10####
#MSR_modal3_corr_09_pred_8, TGI_mean3_corr_09_pred_8, GLI_sd3_corr_09_pred_8, 
#TDVI_sd3_corr_09_pred_8, TGI_sobel_h3_corr_09_pred_8 

#filter the  train1_pred8 traindat to the selected variables:
train_FFS_10 <- train1_pred8[, c(6, 13, 4, 12, 15, 16)] 
names(train_FFS_10)
#[1] "MSR_modal3_corr_09_pred_8"   "TGI_mean3_corr_09_pred_8"    "GLI_sd3_corr_09_pred_8"      "TDVI_sd3_corr_09_pred_8"    
#[5] "TGI_sobel_h3_corr_09_pred_8" "class"

predictors_FFS_10 <- raster::stack(predictors_8$MSR_modal3_corr_09_pred_8,
                                   predictors_8$TGI_mean3_corr_09_pred_8,
                                   predictors_8$GLI_sd3_corr_09_pred_8,
                                   predictors_8$TDVI_sd3_corr_09_pred_8, 
                                   predictors_8$TGI_sobel_h3_corr_09_pred_8)

####BEST predictors_FFS_11 + train_FFS_11####
#MSR_modal3_corr_09_pred_5, TGI_sum3_corr_09_pred_5, GLI_modal3_corr_09_pred_5, 
#TGI_sd3_corr_09_pred_5, TDVI_sd3_corr_09_pred_5 
train_FFS_11 <- train1_pred9[, c(4, 14, 1, 12, 11, 15)] 
names(train_FFS_11)
#[1] "MSR_modal3_corr_09_pred_5" "TGI_sum3_corr_09_pred_5" "GLI_modal3_corr_09_pred_5" 
#"TGI_sd3_corr_09_pred_5" "TDVI_sd3_corr_09_pred_5"   "class"

predictors_FFS_11 <- raster::stack(predictors_9$MSR_modal3_corr_09_pred_5,
                                   predictors_9$TGI_sum3_corr_09_pred_5,
                                   predictors_9$GLI_modal3_corr_09_pred_5,
                                   predictors_9$TGI_sd3_corr_09_pred_5, 
                                   predictors_9$TDVI_sd3_corr_09_pred_5)

####BEST predictors_FFS_12 + train_FFS_12####
#TGI_modal3_corr_09_pred_10, TGI_sobel_v3_corr_09_pred_10, GLI_modal3_corr_09_pred_10, 
#TDVI_sobel3_corr_09_pred_10, SI_modal3_corr_09_pred_10
train_FFS_12 <- train1_pred10[, c(12, 13, 2, 11, 7, 15)] 
names(train_FFS_12)
#[1] "TGI_modal3_corr_09_pred_10"   "TGI_sobel_v3_corr_09_pred_10" "GLI_modal3_corr_09_pred_10"  
#[4] "TDVI_sobel3_corr_09_pred_10"  "SI_modal3_corr_09_pred_10"    "class"
predictors_FFS_12 <- raster::stack(predictors_10$TGI_modal3_corr_09_pred_10,
                                   predictors_10$TGI_sobel_v3_corr_09_pred_10,
                                   predictors_10$GLI_modal3_corr_09_pred_10,
                                   predictors_10$TDVI_sobel3_corr_09_pred_10, 
                                   predictors_10$SI_modal3_corr_09_pred_10)

###############################MODEL + PREDICTION###############################
####PREDICTION 1####
pred_1 <- IKARUS::RFclass(tDat= train_FFS_1, predStk=predictors_FFS_1, 
                          predCol = "default", classCol = "class", Cores =1)
#needed 0.0017 hours
pred_1$model_cv
#Random Forest 

#351 samples
#4 predictor
#6 classes: 'grass', 'shadow', 'shrubs', 'stone', 'tree', 'tree_in_shadow' 

#No pre-processing
#Resampling: Cross-Validated (5 fold) 
#Summary of sample sizes: 279, 280, 281, 282, 282 
#Resampling results across tuning parameters:
  
#  mtry  Accuracy   Kappa    
#2     0.9859903  0.9827478
#3     0.9831734  0.9792835
#4     0.9859903  0.9827478

#Kappa was used to select the optimal model using the largest value.
#The final value used for the model was mtry = 2.

#save the model
saveRDS(pred_1$model_cv, file=file.path(path_models,"model_1.rds"))
plot(varImp(pred_1$model_cv))

#write prediction in a file
writeRaster(pred_1$prediction, file=file.path(path_predictions,"pred_1"), 
            format="GTiff", overwrite = TRUE)

pred_1 <- raster::stack(file.path(path_predictions, lspred[[1]]))
#plot prediction 1
cols <- c("orangered4", "black",  "seagreen", "navajowhite4",  "darkgreen", "deepskyblue4")
plot(pred_1$prediction, col=cols, legend=FALSE, main="Prediction 1: train 1 + predictors 1")
legend("bottomright", legend=c("grass", "shadow", "shrubs", "stone", "tree", "tree_in_shadow"), 
       fill=cols, bg="white")
plot(pred_1$prediction)
CAST::plot_ffs(FFS_1)

####PREDICTION 2####
pred_2 <- IKARUS::RFclass(tDat= train_FFS_2, predStk=predictors_FFS_2, 
                          predCol = "default", classCol = "class", Cores =1)
#needed 0.0021 hours
pred_2$model_cv
#1294 samples
#3 predictor
#6 classes: 'grass', 'shadow', 'shrubs', 'stone', 'tree', 'tree_in_shadow' 

#No pre-processing
#Resampling: Cross-Validated (5 fold) 
#Summary of sample sizes: 1035, 1035, 1036, 1035, 1035 
#Resampling results across tuning parameters:
  
#  mtry  Accuracy   Kappa    
#2     0.9992278  0.9990527
#3     0.9984556  0.9981060

#Kappa was used to select the optimal model using the largest value.
#The final value used for the model was mtry = 2.

#save the model 
saveRDS(pred_2$model_cv, file=file.path(path_models,"model_2.rds"))

#write prediction in a file
writeRaster(pred_2$prediction, file=file.path(path_predictions,"pred_2"), format="GTiff", overwrite = TRUE)
pred_2 <- raster::stack(file.path(path_predictions, lspred[[3]]))

cols <- c("orangered4", "black",  "seagreen", "navajowhite4",  "darkgreen", "deepskyblue4")
plot(pred_2$prediction, col=cols, legend=FALSE, main="Prediction 2: train 1 + predictors 2")
legend("bottomright", legend=c("grass", "shadow", "shrubs", "stone", "tree", "tree_in_shadow"), 
       fill=cols, bg="white")

####PREDICTION 3####
pred_3 <- IKARUS::RFclass(tDat= train_FFS_3, predStk=predictors_FFS_3, 
                          predCol = "default", classCol = "class", Cores =1)
#needed 0.0027 hours
pred_3$model_cv
#1468 samples
#5 predictor
#6 classes: 'grass', 'shadow', 'shrubs', 'stone', 'tree', 'tree_in_shadow' 

#No pre-processing
#Resampling: Cross-Validated (5 fold) 
#Summary of sample sizes: 1174, 1174, 1175, 1175, 1174 
#Resampling results across tuning parameters:
  
#  mtry  Accuracy   Kappa    
#2     0.9979592  0.9975278
#3     0.9979592  0.9975270
#5     0.9979592  0.9975270

#Kappa was used to select the optimal model using the largest value.
#The final value used for the model was mtry = 2.

#save the model
saveRDS(pred_3$model_cv, file=file.path(path_models,"model_3.rds"))

#write prediction in a file
writeRaster(pred_3$prediction, file=file.path(path_predictions,"pred_3"), format="GTiff", overwrite = TRUE)
pred_3 <- raster::stack(file.path(path_predictions, lspred[[5]]))

cols <- c("orangered4", "black",  "seagreen", "navajowhite4",  "darkgreen", "deepskyblue4")
plot(pred_3$prediction, col=cols, legend=FALSE, main="Prediction 3: train 2 + predictors 2")
legend("bottomright", legend=c("grass", "shadow", "shrubs", "stone", "tree", "tree_in_shadow"), 
       fill=cols, bg="white")

####PREDICTION 4####
pred_4 <- IKARUS::RFclass(tDat= train_FFS_4, predStk=predictors_FFS_4, 
                          predCol = "default", classCol = "class", Cores =1)
#needed 0.0019 hours
pred_4$model_cv
#383 samples
#8 predictor
#6 classes: 'grass', 'shadow', 'shrubs', 'stone', 'tree', 'tree_in_shadow' 

#No pre-processing
#Resampling: Cross-Validated (5 fold) 
#Summary of sample sizes: 306, 306, 306, 308, 306 
#Resampling results across tuning parameters:
  
#  mtry  Accuracy   Kappa    
#2     0.9504416  0.9385174
#5     0.9427879  0.9289821
#8     0.9402597  0.9258587

#Kappa was used to select the optimal model using the largest value.
#The final value used for the model was mtry = 2.

#save the model
saveRDS(pred_4$model_cv, file=file.path(path_models,"model_4.rds"))

#write prediction in a file
writeRaster(pred_4$prediction, file=file.path(path_predictions,"pred_4"), format="GTiff", overwrite = TRUE)

cols <- c("orangered4", "black",  "seagreen", "navajowhite4",  "darkgreen", "deepskyblue4")
plot(pred_4$prediction, col=cols, legend=FALSE, main="Prediction 4: train 1 + predictors 2")
legend("bottomright", legend=c("grass", "shadow", "shrubs", "stone", "tree", "tree_in_shadow"), 
       fill=cols, bg="white")

####PREDICTION 5####
pred_5 <- IKARUS::RFclass(tDat= train_FFS_5, predStk=predictors_FFS_5, 
                          predCol = "default", classCol = "class", Cores =1)
#needed 0.0016 hours
pred_5$model_cv
#384 samples
#3 predictor
#6 classes: 'grass', 'shadow', 'shrubs', 'stone', 'tree', 'tree_in_shadow' 

#No pre-processing
#Resampling: Cross-Validated (5 fold) 
#Summary of sample sizes: 306, 307, 307, 309, 307 
#Resampling results across tuning parameters:
  
#  mtry  Accuracy   Kappa    
#2     0.9480773  0.9356629
#3     0.9635618  0.9548359

#Kappa was used to select the optimal model using the largest value.
#The final value used for the model was mtry = 3.

#save the model
saveRDS(pred_5$model_cv, file=file.path(path_models,"model_5.rds"))

#write prediction in a file
writeRaster(pred_5$prediction, file=file.path(path_predictions,"pred_5"), format="GTiff", overwrite = TRUE)

cols <- c("orangered4", "black",  "seagreen", "navajowhite4",  "darkgreen", "deepskyblue4")
plot(pred_5$prediction, col=cols, legend=FALSE, main="Prediction 5: train 1 + predictors 3")
legend("bottomright", legend=c("grass", "shadow", "shrubs", "stone", "tree", "tree_in_shadow"), 
       fill=cols, bg="white")



####PREDICTION 6####
pred_6 <- IKARUS::RFclass(tDat= train_FFS_6, predStk=predictors_FFS_6, 
                          predCol = "default", classCol = "class", Cores =1)
#needed 0.0017 hours
pred_6$model_cv
#356 samples
#6 predictor
#6 classes: 'grass', 'shadow', 'shrubs', 'stone', 'tree', 'tree_in_shadow' 

#No pre-processing
#Resampling: Cross-Validated (5 fold) 
#Summary of sample sizes: 284, 284, 285, 286, 285 
#Resampling results across tuning parameters:
  
#  mtry  Accuracy   Kappa    
#2     0.9803979  0.9758349
#4     0.9635334  0.9550318
#6     0.9606763  0.9515036

#Kappa was used to select the optimal model using the largest value.
#The final value used for the model was mtry = 2.

#save the model
saveRDS(pred_6$model_cv, file=file.path(path_models,"model_6.rds"))

#write prediction in a file
writeRaster(pred_6$prediction, file=file.path(path_predictions,"pred_6"), format="GTiff", overwrite = TRUE)

cols <- c("orangered4", "black",  "seagreen", "navajowhite4",  "darkgreen", "deepskyblue4")
plot(pred_6$prediction, col=cols, legend=FALSE, main="Prediction 6: train 1 + predictors 4")
legend("bottomright", legend=c("grass", "shadow", "shrubs", "stone", "tree", "tree_in_shadow"), 
       fill=cols, bg="white")

####PREDICTION 7####
pred_7 <- IKARUS::RFclass(tDat= train_FFS_7, predStk=predictors_FFS_7, 
                          predCol = "default", classCol = "class", Cores =1)
#needed 0.0017 hours
pred_7$model_cv
#355 samples
#6 predictor
#6 classes: 'grass', 'shadow', 'shrubs', 'stone', 'tree', 'tree_in_shadow' 

#No pre-processing
#Resampling: Cross-Validated (5 fold) 
#Summary of sample sizes: 283, 283, 284, 285, 285 
#Resampling results across tuning parameters:
  
#  mtry  Accuracy   Kappa    
#2     0.9551218  0.9446709
#4     0.9466700  0.9342280
#6     0.9355198  0.9204154

#Kappa was used to select the optimal model using the largest value.
#The final value used for the model was mtry = 2.

#save the model
saveRDS(pred_7$model_cv, file=file.path(path_models,"model_7.rds"))
model_7 <- read_rds(file.path(path_models,"model_7.rds"))
model_7$finalModel

#write prediction in a file
writeRaster(pred_7$prediction, file=file.path(path_predictions,"pred_7"), format="GTiff", overwrite = TRUE)

cols <- c("orangered4", "black",  "seagreen", "navajowhite4",  "darkgreen", "deepskyblue4")
plot(pred_7$prediction, col=cols, legend=FALSE, main="Prediction 7: train 1 + predictors 5")
legend("bottomright", legend=c("grass", "shadow", "shrubs", "stone", "tree", "tree_in_shadow"), 
       fill=cols, bg="white")

#if we compare prediction 5, 6 & 7 we can see, that the difference is the 
#inclusion of HI index which is not really useful and has to be taken out 
#to set the homogeneity lower to get it out
# we can take it out with the homogeneity measure, but we have to set homogeneity 
#to 0.4 and more indices will fall out
#or we can just take it out by hand

####PREDICTION 8####
pred_8 <- IKARUS::RFclass(tDat= train_FFS_8, predStk=predictors_FFS_8, 
                          predCol = "default", classCol = "class", Cores =1)
#needed 0.0016 hours
pred_8$model_cv
#385 samples
#3 predictor
#6 classes: 'grass', 'shadow', 'shrubs', 'stone', 'tree', 'tree_in_shadow' 

#No pre-processing
#Resampling: Cross-Validated (5 fold) 
#Summary of sample sizes: 307, 308, 308, 309, 308 
#Resampling results across tuning parameters:
  
#  mtry  Accuracy   Kappa    
#2     0.9661978  0.9580090
#3     0.9662320  0.9580486

#Kappa was used to select the optimal model using the largest value.
#The final value used for the model was mtry = 3.

#save the model
saveRDS(pred_8$model_cv, file=file.path(path_models,"model_8.rds"))

#write prediction in a file
writeRaster(pred_8$prediction, file=file.path(path_predictions,"pred_8"), format="GTiff", overwrite = TRUE)

cols <- c("orangered4", "black",  "seagreen", "navajowhite4",  "darkgreen", "deepskyblue4")
plot(pred_8$prediction, col=cols, legend=FALSE, main="Prediction 8: train 1 + predictors 6")
legend("bottomright", legend=c("grass", "shadow", "shrubs", "stone", "tree", "tree_in_shadow"), 
       fill=cols, bg="white")

####PREDICTION 9####
pred_9 <- IKARUS::RFclass(tDat= train_FFS_9, predStk=predictors_FFS_9, 
                          predCol = "default", classCol = "class", Cores =1)
#needed 0.0017 hours
pred_9$model_cv
#385 samples
#3 predictor
#6 classes: 'grass', 'shadow', 'shrubs', 'stone', 'tree', 'tree_in_shadow' 

#No pre-processing
#Resampling: Cross-Validated (5 fold) 
#Summary of sample sizes: 307, 308, 308, 309, 308 
#Resampling results across tuning parameters:
  
#  mtry  Accuracy   Kappa    
#2     0.9169813  0.8969692
#3     0.9143839  0.8937642

#Kappa was used to select the optimal model using the largest value.
#The final value used for the model was mtry = 2.

#save the model
saveRDS(pred_9$model_cv, file=file.path(path_models,"model_9.rds"))

#write prediction in a file
writeRaster(pred_9$prediction, file=file.path(path_predictions,"pred_9"), format="GTiff", overwrite = TRUE)

cols <- c("orangered4", "black",  "seagreen", "navajowhite4",  "darkgreen", "deepskyblue4")
plot(pred_9$prediction, col=cols, legend=FALSE, main="Prediction 9: train 1 + predictors 7")
legend("bottomright", legend=c("grass", "shadow", "shrubs", "stone", "tree", "tree_in_shadow"), 
       fill=cols, bg="white")

####PREDICTION 10####
pred_10 <- IKARUS::RFclass(tDat= train_FFS_10, predStk=predictors_FFS_10, 
                          predCol = "default", classCol = "class", Cores =1)
#needed 0.0018 hours
pred_10$model_cv
#383 samples
#5 predictor
#6 classes: 'grass', 'shadow', 'shrubs', 'stone', 'tree', 'tree_in_shadow' 

#No pre-processing
#Resampling: Cross-Validated (5 fold) 
#Summary of sample sizes: 306, 306, 306, 308, 306 
#Resampling results across tuning parameters:
  
#  mtry  Accuracy   Kappa    
#2     0.9427879  0.9290406
#3     0.9349957  0.9193146
#5     0.9246061  0.9063478

#Kappa was used to select the optimal model using the largest value.
#The final value used for the model was mtry = 2.

#save the model
saveRDS(pred_10$model_cv, file=file.path(path_models,"model_10.rds"))

#write prediction in a file
writeRaster(pred_10$prediction, file=file.path(path_predictions,"pred_10"), format="GTiff", overwrite = TRUE)

cols <- c("orangered4", "black",  "seagreen", "navajowhite4",  "darkgreen", "deepskyblue4")
plot(pred_10$prediction, col=cols, legend=FALSE, main="Prediction 10: train 1 + predictors 8")
legend("bottomright", legend=c("grass", "shadow", "shrubs", "stone", "tree", "tree_in_shadow"), 
       fill=cols, bg="white")

####PREDICTION 11####
pred_11 <- IKARUS::RFclass(tDat= train_FFS_11, predStk=predictors_FFS_11, 
                           predCol = "default", classCol = "class", Cores =1)
#needed  0.0017 hours
pred_11$model_cv
#383 samples
#5 predictor
#6 classes: 'grass', 'shadow', 'shrubs', 'stone', 'tree', 'tree_in_shadow' 

#No pre-processing
#Resampling: Cross-Validated (5 fold) 
#Summary of sample sizes: 306, 306, 306, 308, 306 
#Resampling results across tuning parameters:
  
#  mtry  Accuracy   Kappa    
#2     0.9323290  0.9159235
#3     0.9401212  0.9256125
#5     0.9271342  0.9094292

#Kappa was used to select the optimal model using the largest value.
#The final value used for the model was mtry = 3.

#save the model
saveRDS(pred_11$model_cv, file=file.path(path_models,"model_11.rds"))

#write prediction in a file
writeRaster(pred_11$prediction, file=file.path(path_predictions,"pred_11"), format="GTiff", overwrite = TRUE)
pred_11 <- raster(paste0(path_predictions, lspred[[5]]))

cols <- c("orangered4", "black",  "seagreen", "navajowhite4",  "darkgreen", "deepskyblue4")
plot(pred_11$prediction, col=cols, legend=FALSE, main="Prediction 11: train 1 + predictors 9")
legend("bottomright", legend=c("grass", "shadow", "shrubs", "stone", "tree", "tree_in_shadow"), 
       fill=cols, bg="white")

####PREDICTION 12####
pred_12 <- IKARUS::RFclass(tDat= train_FFS_12, predStk=predictors_FFS_12, 
                           predCol = "default", classCol = "class", Cores =1)
#needed 0.0018 hours
pred_12$model_cv
saveRDS(pred_12$model_cv, file=file.path(path_models,"model_12.rds"))
#write prediction in a file
writeRaster(pred_12$prediction, file=file.path(path_predictions,"pred_12"), format="GTiff", overwrite = TRUE)
############################VALIDATION WITH SEGEMENTATION#######################
#from the prediction order of classes:
#[1] "grass"          "shadow"         "shrubs"         "stone"          "tree"           "tree_in_shadow"

validation_trees <- valSeg(pred=pred_11$prediction,  seg=seg_1,  classTree=5,  reclass=NULL)
#starting validation
#[1] 1 2 3 4 6
#valdiation score: class in seg @ empty seg
#   nclass  nseg    overclass underclass   hit  hitrate   rate underclass rate overclass
#1  22562 33930      4150      15518      18412  0.8161      0.4574         0.1839

validation_trees_treesnshadow <- valSeg(pred=pred_11$prediction,  seg=seg_1,  
                                        classTree=5,  reclass=6)

writeRaster(validation_trees_treesnshadow, 
            file=file.path(path_validation,
            "valid_area1_trees_treesnshadow"), 
            format="GTiff", overwrite = TRUE)

#starting validation
#[1] 1 2 3 4
#valdiation score: class in seg @ empty seg
#nclass  nseg overclass underclass   hit hitrate rate underclass rate overclass
#1  37683 33930      9870       6117 27813  0.7381          0.1803         0.2619

validation_trees_treesnshadow_shadow <- valSeg(pred=pred_11$prediction,  seg=seg_1,
                                               classTree=5,  reclass=c(2,6))
#starting validation
#starting validation
#[1] 1 3 5
#valdiation score: class in seg @ empty seg
#nclass  nseg overclass underclass   hit hitrate rate underclass rate overclass
#1  26654 33930     13315      20591 13339  0.5005          0.6069         0.4995

writeRaster(validation_trees_treesnshadow_shadow, 
            file=file.path(path_validation,
            "valid_area1_trees_treesnshadow_shadow"), 
            format="GTiff", overwrite = TRUE)


