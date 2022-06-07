####--------------------------------SHORTCUTS-------------------------------####
lstrain <- list.files(paste0(path_analysis_data_train), pattern=".shp")
lspredictor1 <- list.files(paste0(path_analysis_results_prdctr1), glob2rx(pattern="*.tif"))
lspredictor2 <- list.files(paste0(path_analysis_results_prdctr2), glob2rx(pattern="*.tif"))
lstraindat <- list.files(paste0(path_analysis_results_traindat), pattern=".csv")
lstrainclass <- list.files(paste0(path_analysis_results_train_class), pattern=".csv")
lsFFS <- list.files(paste0(path_analysis_results_FFS), pattern = ".rds")
lsmod <- list.files(paste0(path_analysis_results_models), pattern = ".rds")
lspred <- list.files(paste0(path_analysis_results_predictions), glob2rx(pattern="*.tif"))
################################################################################
####------------------------#1.LOAD & PREPARE DATA#-------------------------####
#-------------------PREDICTORS 1: RGB + MS indices, all filter-----------------#
predictors_1 <- raster::stack(paste0(path_analysis_results_prdctr1, lspredictor1))
names(predictors_1) #18
#[1] "GLI_modal3_corr_09_pred_1"   "GLI_sobel_v3_corr_09_pred_1" "GLI_sobel3_corr_09_pred_1"
#[4] "MSR_min3_corr_09_pred_1"     "MSR_sobel_v3_corr_09_pred_1" "NDVI_min3_corr_09_pred_1"
#[7] "SI_max3_corr_09_pred_1"      "SI_sobel_v3_corr_09_pred_1"  "SI_sobel3_corr_09_pred_1"
#[10] "SR_sobel3_corr_09_pred_1"    "TDVI_sobel3_corr_09_pred_1"  "TGI_max3_corr_09_pred_1"
#[13] "TGI_sobel_v3_corr_09_pred_1" "TGI_sobel3_corr_09_pred_1"   "VVI_min3_corr_09_pred_1"
#[16] "VVI_modal3_corr_09_pred_1"   "VVI_sobel_v3_corr_09_pred_1" "VVI_sobel3_corr_09_pred_1"
#--------PREDICTORS 2: RGB indices + MS indices + RGB + NIR, all filter--------#
predictors_2 <- raster::stack(paste0(path_analysis_results_prdctr2, lspredictor2))
names(predictors_2) #19
#[1] "Blue_min3_corr_09_pred_2"      "Blue_sobel_v3_corr_09_pred_2"  "GLI_max3_corr_09_pred_2"
#[4] "GLI_sobel3_corr_09_pred_2"     "NDVI_min3_corr_09_pred_2"      "NGRDI_sobel_v3_corr_09_pred_2"
#[7] "NGRDI_sobel3_corr_09_pred_2"   "SI_max3_corr_09_pred_2"        "SI_sobel_v3_corr_09_pred_2"
#[10] "SI_sobel3_corr_09_pred_2"      "SR_sobel3_corr_09_pred_2"      "TDVI_sobel3_corr_09_pred_2"
#[13] "TGI_max3_corr_09_pred_2"       "TGI_sobel_v3_corr_09_pred_2"   "TGI_sobel3_corr_09_pred_2"
#[16] "VVI_min3_corr_09_pred_2"       "VVI_modal3_corr_09_pred_2"     "VVI_sobel_v3_corr_09_pred_2"
#[19] "VVI_sobel3_corr_09_pred_2"
#-----------------------------LOAD TRAINING POLYGONS---------------------------#
train_1 <-readOGR(paste0(path_analysis_data_train, lstrain[[1]]))
train_2 <-readOGR(paste0(path_analysis_data_train, lstrain[[2]]))
#------------------------------CHECK CRS OF THE DATA---------------------------#
crs(predictors_1) #+proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel +units=m +no_defs
crs(predictors_2) #+proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel +units=m +no_defs
crs(train_1) #+proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel +towgs84=577.326,90.129,463.919,5.137,1.474,5.297,2.4232 +units=m +no_defs
train_1 <- spTransform(train_1, crs(predictors_1))
train_2 <- spTransform(train_2, crs(predictors_2))
crs(train_1) #+proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel +units=m +no_defs
crs(train_2) #+proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel +units=m +no_defs
####------------#2.PREPARE INDEX STACKS FOR PREDICTION OF AREA 1#-----------####
####------------------------2.1 EXTRACT TRAINING DATA-----------------------####
#-------------------------TRAIN 1 PREDICTORS 1 - FFS1--------------------------#
train1_pred1 <- IKARUS::exrct_Traindat(train_1, predictors_1, "class")
#NAs detected: deleting 82674  NAs
write.csv(train1_pred1, paste0(path_analysis_results_traindat, "train1_pred1.csv"))
train1_pred1 <- read.csv(paste0(path_analysis_results_traindat, "train1_pred1.csv"),
                         header = TRUE, sep=",")
#------------------------TRAIN 1 PREDICTORS 2 - FFS2---------------------------#
train1_pred2 <- IKARUS::exrct_Traindat(train_1, predictors_2, "class")
#NAs detected: deleting 83688  NAs
write.csv(train1_pred2, paste0(path_analysis_results_traindat, "train1_pred2.csv"))
train1_pred2 <- read.csv(paste0(path_analysis_results_traindat, "train1_pred2.csv"),
                         header = TRUE, sep=",")
#---------------------------TRAIN 2 PREDICTORS 1 - FFS3------------------------#
train2_pred1 <- IKARUS::exrct_Traindat(train_2, predictors_1, "class")
#NAs detected: deleting 81591  NAs
write.csv(train2_pred1, paste0(path_analysis_results_traindat, "train2_pred1.csv"))
train2_pred1 <- read.csv(paste0(path_analysis_results_traindat, "train2_pred1.csv"),
                         header = TRUE, sep=",")
#----------------------------TRAIN 2 PREDICTORS 2 - FFS4-----------------------#
train2_pred2 <- IKARUS::exrct_Traindat(train_2, predictors_2, "class")
#NAs detected: deleting 82605  NAs
write.csv(train2_pred2, paste0(path_analysis_results_traindat, "train2_pred2.csv"))
train2_pred2 <- read.csv(paste0(path_analysis_results_traindat, "train2_pred2.csv"),
                         header = TRUE, sep=",")
####---------------------2.2 FORWARD FEATURE SELECTION----------------------####
#-----------------------FFS1 - TRAIN 1 - PREDICTORS 1--------------------------#
FFS_1 <- IKARUS::BestPredFFS(train1_pred1, predCol = "default",
                             classCol = "class", Cores = 1)
#289 max...
#needed 0.0382 hours
#Note: No increase in performance found using more than 3 variables
#selected variables
#MSR_min3_corr_09_pred_1, VVI_min3_corr_09_pred_1, TGI_max3_corr_09_pred_1
saveRDS(FFS_1, paste0(path_analysis_results_FFS,"FFS_1.rds"))
FFS_1<- readRDS(paste0(path_analysis_results_FFS,"FFS_1.rds"))
FFS_1$selectedvars # show selected variables
#"MSR_min3_corr_09_pred_1" "VVI_min3_corr_09_pred_1" "TGI_max3_corr_09_pred_1"
FFS_1$perf_all # show performance of all combinations
FFS_1$finalModel
#-------------------------FFS2 - TRAIN 1 - PREDICTORS 2------------------------#
FFS_2 <- IKARUS::BestPredFFS(train1_pred2 , predCol = "default",
                             classCol = "class", Cores = 1)
#324 max ...
#needed 0.0451 hours
#Note: No increase in performance found using more than 4 variables
#selected variables
#GLI_max3_corr_09_pred_2, VVI_min3_corr_09_pred_2, TGI_max3_corr_09_pred_2, Blue_min3_corr_09_pred_2
saveRDS(FFS_2, paste0(path_analysis_results_FFS,"FFS_2.rds"))
FFS_2<- readRDS(paste0(path_analysis_results_FFS,"FFS_2.rds"))
FFS_2$selectedvars
FFS_2$perf_all
FFS_2$finalModel
#---------------------------FFS3 - TRAIN 2 - PREDICTORS 1----------------------#
FFS_3 <- IKARUS::BestPredFFS(train2_pred1, predCol = "default",
                             classCol = "class", Cores = 1)
#289 max ...
#needed 0.0.0659 hours
#Note: No increase in performance found using more than 2 variables
#NDVI_min3_corr_09_pred_1, TGI_max3_corr_09_pred_1
saveRDS(FFS_3, paste0(path_analysis_results_FFS,"FFS_3.rds"))
FFS_3<- readRDS(paste0(path_analysis_results_FFS,"FFS_3.rds"))
FFS_3$selectedvars
FFS_3$perf_all
FFS_3$finalModel
#-------------------------FFS4 - TRAIN 2 - PREDICTORS 2------------------------#
FFS_4 <- IKARUS::BestPredFFS(train2_pred2, predCol = "default", classCol = "class", Cores = 1)
#324 max ...
#needed 0.073 hours
#Note: No increase in performance found using more than 2 variables
#NDVI_min3_corr_09_pred_2, TGI_max3_corr_09_pred_2
saveRDS(FFS_4, paste0(path_analysis_results_FFS,"FFS_4.rds"))
FFS_4<- readRDS(paste0(path_analysis_results_FFS,"FFS_4.rds"))
FFS_4$selectedvars
FFS_4$perf_all
FFS_4$finalModel
####---------------------2.3 EXTRACT TRAINING DATA + CLASS------------------####
#--------------------------FFS1:train_1 + predictors_1-------------------------#
FFS_1$selectedvars
#"MSR_min3_corr_09_pred_1" "VVI_min3_corr_09_pred_1"
#"TGI_max3_corr_09_pred_1"
#filter the train1_pred1 traindat to the selected variables + class:
names(train1_pred1)
train_FFS_1 <- train1_pred1[, c(4, 15, 12, 19)]
write.csv(train_FFS_1, paste0(path_analysis_results_train_class, "train_FFS_1.csv"))
#---------------------------FFS2:train_1 + predictors_2------------------------#
FFS_2$selectedvars
#"GLI_max3_corr_09_pred_2"  "VVI_min3_corr_09_pred_2"
#"TGI_max3_corr_09_pred_2"  "Blue_min3_corr_09_pred_2"
#filter the train1_pred2 traindat to the selected variables:
train_FFS_2 <- train1_pred2[, c(3, 16, 13, 1, 20)]
write.csv(train_FFS_2, paste0(path_analysis_results_train_class, "train_FFS_2.csv"))
#---------------------------FFS3:train_2 + predictors_1------------------------#
FFS_3$selectedvars #"NDVI_min3_corr_09_pred_1" "TGI_max3_corr_09_pred_1"
#filter the train2_pred1 traindat to the selected variables:
train_FFS_3 <- train2_pred1[, c(6, 12, 19)]
write.csv(train_FFS_3, paste0(path_analysis_results_train_class, "train_FFS_3.csv"))
#---------------------------FFS4:train_2 + predictors_2------------------------#
FFS_4$selectedvars #"NDVI_min3_corr_09_pred_2" "TGI_max3_corr_09_pred_2"
#filter the train2_pred2 traindat to the selected variables:
train_FFS_4 <- train2_pred2[, c(5, 13, 20)]
write.csv(train_FFS_4, paste0(path_analysis_results_train_class, "train_FFS_4.csv"))
####-------------------------2.4 STACK FINAL PREDICTORS---------------------####
#--------------------------FFS1:train_1 + predictors_1-------------------------#
names(train_FFS_1)
#"MSR_min3_corr_09_pred_1" "VVI_min3_corr_09_pred_1" "TGI_max3_corr_09_pred_1" "class"
#filter the predictorstack to the selected variables
predictors_FFS_1 <- raster::stack(predictors_1$MSR_min3_corr_09_pred_1,
                                  predictors_1$VVI_min3_corr_09_pred_1,
                                  predictors_1$TGI_max3_corr_09_pred_1)
#---------------------------FFS2:train_1 + predictors_2------------------------#
names(train_FFS_2)
#"GLI_max3_corr_09_pred_2"  "VVI_min3_corr_09_pred_2"  "TGI_max3_corr_09_pred_2"  "Blue_min3_corr_09_pred_2" "class"
#filter the predictorstack to the selected variables
predictors_FFS_2 <- raster::stack(predictors_2$GLI_max3_corr_09_pred_2,
                                  predictors_2$VVI_min3_corr_09_pred_2,
                                  predictors_2$TGI_max3_corr_09_pred_2,
                                  predictors_2$Blue_min3_corr_09_pred_2)
#---------------------------FFS3:train_2 + predictors_1------------------------#
names(train_FFS_3)
#"NDVI_min3_corr_09_pred_1" "TGI_max3_corr_09_pred_1"  "class"
#filter the predictorstack to the selected variables
predictors_FFS_3 <- raster::stack(predictors_1$NDVI_min3_corr_09_pred_1,
                                  predictors_1$TGI_max3_corr_09_pred_1)
#---------------------------FFS4:train_2 + predictors_2------------------------#
names(train_FFS_4)
#"NDVI_min3_corr_09_pred_2" "TGI_max3_corr_09_pred_2"  "class"
#filter the predictorstack to the selected variables
predictors_FFS_4 <- raster::stack(predictors_2$NDVI_min3_corr_09_pred_2,
                                  predictors_2$TGI_max3_corr_09_pred_2)
####------------------------3.MODEL + PREDICTION----------------------------####
#---------------------------------PREDICTION 1---------------------------------#
pred_1 <- IKARUS::RFclass(tDat= train_FFS_1, predStk=predictors_FFS_1,
                          predCol = "default", classCol = "class", Cores =1)
#finished model needed 0.0013 hours

#read model
pred_1$model_cv
#Random Forest
#384 samples
#3 predictor
#6 classes: 'grass', 'shadow', 'shrubs', 'stone', 'tree', 'tree_in_shadow'
#No pre-processing
#Resampling: Cross-Validated (5 fold)
#Summary of sample sizes: 306, 307, 307, 309, 307
#Resampling results across tuning parameters:
#        mtry  Accuracy   Kappa
#2     0.9480773  0.9356629
#3     0.9635618  0.9548359
#Kappa was used to select the optimal model using the largest value.
#The final value used for the model was mtry = 3.

#save the model
saveRDS(pred_1$model_cv, paste0(path_analysis_results_models, "model_1.rds"))

#load the model for the case if it needs to be inspected/worked with later
model_1<- readRDS(paste0(path_analysis_results_models,"model_1.rds"))

#plot the importance of the predictors used for building the model
plot(varImp(pred_1$model_cv))

#write prediction in a file
writeRaster(pred_1$prediction, paste0(path_analysis_results_predictions,"pred_1"),
            format="GTiff", overwrite = TRUE)

#read prediction in case it shall be used later
pred_1 <- raster::stack(paste0(path_analysis_results_predictions, lspred[[1]]))

#plot prediction 1
#if plotted right after prediction, the use pred_1$prediction instead of pred_1
cols <- c("orangered4", "black",  "seagreen", "navajowhite4",  "darkgreen", "deepskyblue4")
plot(pred_1, col=cols, legend=FALSE, main="Prediction 1: train 1 + predictors 1")
legend("bottomright", legend=c("grass", "shadow", "shrubs", "stone", "tree", "tree_in_shadow"),
       fill=cols, bg="white")
#---------------------------------PREDICTION 2---------------------------------#
pred_2 <- IKARUS::RFclass(tDat= train_FFS_2, predStk=predictors_FFS_2,
                          predCol = "default", classCol = "class", Cores =1)
#finished model needed 0.0012 hours
pred_2$model_cv
#Random Forest
#384 samples
#4 predictor
#6 classes: 'grass', 'shadow', 'shrubs', 'stone', 'tree', 'tree_in_shadow'
#No pre-processing
#Resampling: Cross-Validated (5 fold)
#Summary of sample sizes: 306, 307, 307, 309, 307
#Resampling results across tuning parameters:
#        mtry  Accuracy   Kappa
#2     0.9766513  0.9710426
#3     0.9714565  0.9645913
#4     0.9611695  0.9517979
#Kappa was used to select the optimal model using the largest value.
#The final value used for the model was mtry = 2.

#save the model
saveRDS(pred_2$model_cv, paste0(path_analysis_results_models,"model_2.rds"))

#load the model for the case if it needs to be inspected/worked with later
model_2<- readRDS(paste0(path_analysis_results_models,"model_2.rds"))

#plot the importance of the predictors used for building the model
plot(varImp(pred_2$model_cv))

#write prediction in a file
writeRaster(pred_2$prediction, paste0(path_analysis_results_predictions,"pred_2"),
            format="GTiff", overwrite = TRUE)

#read prediction in case it shall be used later
pred_2 <- raster::stack(paste0(path_analysis_results_predictions, lspred[[2]]))

#plot prediction 2
#if plotted right after prediction, the use pred_2$prediction instead of pred_2
cols <- c("orangered4", "black",  "seagreen", "navajowhite4",  "darkgreen", "deepskyblue4")
plot(pred_2, col=cols, legend=FALSE, main="Prediction 2: train 1 + predictors 2")
legend("bottomright", legend=c("grass", "shadow", "shrubs", "stone", "tree", "tree_in_shadow"),
       fill=cols, bg="white")
#---------------------------------PREDICTION 3---------------------------------#
pred_3 <- IKARUS::RFclass(tDat= train_FFS_3, predStk=predictors_FFS_3,
                          predCol = "default", classCol = "class", Cores =1)
#finished model needed 0.0014 hours
pred_3$model_cv
#Random Forest
#1468 samples
#2 predictor
#6 classes: 'grass', 'shadow', 'shrubs', 'stone', 'tree', 'tree_in_shadow'
#No pre-processing
#Resampling: Cross-Validated (5 fold)
#Summary of sample sizes: 1174, 1174, 1175, 1175, 1174
#Resampling results:
#Accuracy  Kappa
#1         1
#Tuning parameter 'mtry' was held constant at a value of 2

#save the model
saveRDS(pred_3$model_cv, paste0(path_analysis_results_models ,"model_3.rds"))

#load the model for the case if it needs to be inspected/worked with later
model_3<- readRDS(paste0(path_analysis_results_models,"model_3.rds"))

#plot the importance of the predictors used for building the model
plot(varImp(pred_3$model_cv))

#write prediction in a file
writeRaster(pred_3$prediction, paste0(path_analysis_results_predictions,"pred_3"),
            format="GTiff", overwrite = TRUE)

#read prediction in case it shall be used later
pred_3 <- raster::stack(paste0(path_analysis_results_predictions, lspred[[3]]))

#if plotted right after prediction, the use pred_3$prediction instead of pred_3
cols <- c("orangered4", "black",  "seagreen", "navajowhite4",  "darkgreen", "deepskyblue4")
plot(pred_3, col=cols, legend=FALSE, main="Prediction 3: train 2 + predictors 1")
legend("bottomright", legend=c("grass", "shadow", "shrubs", "stone", "tree", "tree_in_shadow"),
       fill=cols, bg="white")
#---------------------------------PREDICTION 4---------------------------------#
pred_4 <- IKARUS::RFclass(tDat= train_FFS_4, predStk=predictors_FFS_4,
                          predCol = "default", classCol = "class", Cores =1)
#finished model needed 0.0015 hours
pred_4$model_cv
#Random Forest
#1468 samples
#2 predictor
#6 classes: 'grass', 'shadow', 'shrubs', 'stone', 'tree', 'tree_in_shadow'
#No pre-processing
#Resampling: Cross-Validated (5 fold)
#Summary of sample sizes: 1174, 1174, 1175, 1175, 1174
#Resampling results:
#Accuracy  Kappa
#1         1
#Tuning parameter 'mtry' was held constant at a value of 2

#save the model
saveRDS(pred_4$model_cv, paste0(path_analysis_results_models,"model_4.rds"))

#load the model for the case if it needs to be inspected/worked with later
model_4<- readRDS(paste0(path_analysis_results_models,"model_4.rds"))

#plot the importance of the predictors used for building the model
plot(varImp(pred_4$model_cv))

#write prediction in a file
writeRaster(pred_4$prediction, paste0(path_analysis_results_predictions, "pred_4"),
            format="GTiff", overwrite = TRUE)

#read prediction in case it shall be used later
pred_4 <- raster::stack(paste0(path_analysis_results_predictions, lspred[[4]]))

#if plotted right after prediction, the use pred_4$prediction instead of pred_4
cols <- c("orangered4", "black",  "seagreen", "navajowhite4",  "darkgreen", "deepskyblue4")
plot(pred_4, col=cols, legend=FALSE, main="Prediction 4: train 2 + predictors 2")
legend("bottomright", legend=c("grass", "shadow", "shrubs", "stone", "tree", "tree_in_shadow"),
       fill=cols, bg="white")
