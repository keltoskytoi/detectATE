####--------------------------------SHORTCUTS-------------------------------####
lstrain <- list.files(paste0(path_analysis_data_train), pattern=".shp")
lspredictor1_ROI <- list.files(paste0(path_analysis_results_prdctrs1_ROI), glob2rx(pattern="*.tif"))
lspredictor2_ROI <- list.files(paste0(path_analysis_results_prdctrs2_ROI), glob2rx(pattern="*.tif"))
lstraindat_ROI <- list.files(paste0(path_analysis_results_traindat_ROI), pattern=".csv")
lstrainclass_ROI <- list.files(paste0(path_analysis_results_train_class_ROI), pattern=".csv")
lsFFS_ROI <- list.files(paste0(path_analysis_results_FFS_ROI), pattern = ".rds")
lsmod_ROI <- list.files(paste0(path_analysis_results_models_ROI), pattern = ".rds")
lspred_ROI <- list.files(paste0(path_analysis_results_predictions_ROI), glob2rx(pattern="*.tif"))
################################################################################
####------------------------#1.LOAD & PREPARE DATA#-------------------------####
#-------------------PREDICTORS 1: RGB + MS indices, all filter-----------------#
predictors_ROI_1 <- raster::stack(paste0(path_analysis_results_prdctrs1_ROI, lspredictor1_ROI))
names(predictors_ROI_1) #17
#"GLI_min3_ALL_ind_stack_ROI_homog093_filt_corr_09_pred_1"       "GLI_sobel3_ALL_ind_stack_ROI_homog093_filt_corr_09_pred_1"
#"MSR_min3_ALL_ind_stack_ROI_homog093_filt_corr_09_pred_1"       "MSR_sobel_v3_ALL_ind_stack_ROI_homog093_filt_corr_09_pred_1"
#"NGRDI_sobel_v3_ALL_ind_stack_ROI_homog093_filt_corr_09_pred_1" "SI_max3_ALL_ind_stack_ROI_homog093_filt_corr_09_pred_1"
#"SI_sobel_v3_ALL_ind_stack_ROI_homog093_filt_corr_09_pred_1"    "SI_sobel3_ALL_ind_stack_ROI_homog093_filt_corr_09_pred_1"
#"SR_sobel3_ALL_ind_stack_ROI_homog093_filt_corr_09_pred_1"      "TDVI_sobel3_ALL_ind_stack_ROI_homog093_filt_corr_09_pred_1"
#"TGI_max3_ALL_ind_stack_ROI_homog093_filt_corr_09_pred_1"       "TGI_sobel_v3_ALL_ind_stack_ROI_homog093_filt_corr_09_pred_1"
#"TGI_sobel3_ALL_ind_stack_ROI_homog093_filt_corr_09_pred_1"     "VVI_min3_ALL_ind_stack_ROI_homog093_filt_corr_09_pred_1"
#"VVI_modal3_ALL_ind_stack_ROI_homog093_filt_corr_09_pred_1"     "VVI_sobel_v3_ALL_ind_stack_ROI_homog093_filt_corr_09_pred_1"
#"VVI_sobel3_ALL_ind_stack_ROI_homog093_filt_corr_09_pred_1"
#------PREDICTORS 2: RGB indices + Spectral indices + RGB + NIR, all filter----#
predictors_ROI_2 <- raster::stack(paste0(path_analysis_results_prdctrs2_ROI, lspredictor2_ROI))
names(predictors_ROI_2) #17
#"Blue_min3_ALL_RGBMS_stack_ROI_homog093_filt_corr_09_pred_2"      "GLI_min3_ALL_RGBMS_stack_ROI_homog093_filt_corr_09_pred_2"
#"GLI_sobel3_ALL_RGBMS_stack_ROI_homog093_filt_corr_09_pred_2"     "IR_ROI_sobel3_ALL_RGBMS_stack_ROI_homog093_filt_corr_09_pred_2"
#"MSR_sobel_v3_ALL_RGBMS_stack_ROI_homog093_filt_corr_09_pred_2"   "NGRDI_sobel_v3_ALL_RGBMS_stack_ROI_homog093_filt_corr_09_pred_2"
#"SI_max3_ALL_RGBMS_stack_ROI_homog093_filt_corr_09_pred_2"        "SI_sobel_v3_ALL_RGBMS_stack_ROI_homog093_filt_corr_09_pred_2"
#"SI_sobel3_ALL_RGBMS_stack_ROI_homog093_filt_corr_09_pred_2"      "SR_sobel3_ALL_RGBMS_stack_ROI_homog093_filt_corr_09_pred_2"
#"TGI_max3_ALL_RGBMS_stack_ROI_homog093_filt_corr_09_pred_2"       "TGI_sobel_v3_ALL_RGBMS_stack_ROI_homog093_filt_corr_09_pred_2"
#"TGI_sobel3_ALL_RGBMS_stack_ROI_homog093_filt_corr_09_pred_2"     "VVI_min3_ALL_RGBMS_stack_ROI_homog093_filt_corr_09_pred_2"
#"VVI_modal3_ALL_RGBMS_stack_ROI_homog093_filt_corr_09_pred_2"     "VVI_sobel_v3_ALL_RGBMS_stack_ROI_homog093_filt_corr_09_pred_2"
#"VVI_sobel3_ALL_RGBMS_stack_ROI_homog093_filt_corr_09_pred_2"
#-----------------------------LOAD TRAINING POLYGONS---------------------------#
train_1 <-readOGR(paste0(path_analysis_data_train, lstrain[[1]]))
train_2 <-readOGR(paste0(path_analysis_data_train, lstrain[[2]]))
#------------------------------CHECK CRS OF THE DATA---------------------------#
crs(predictors_ROI_1) #+proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel +units=m +no_defs
crs(predictors_ROI_2) #+proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel +units=m +no_defs
crs(train_1) #+proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel +towgs84=577.326,90.129,463.919,5.137,1.474,5.297,2.4232 +units=m +no_defs
train_1 <- spTransform(train_1, crs(predictors_ROI_1))
train_2 <- spTransform(train_2, crs(predictors_ROI_2))
crs(train_1) #+proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel +units=m +no_defs
crs(train_2) #+proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel +units=m +no_defs
####-------------#2.PREPARE INDEX STACKS FOR PREDICTION OF ROI#-------------####
#---------------------------2.1 EXTRACT TRAINING DATA--------------------------#
#-------------------------TRAIN 1 PREDICTORS 1 - FFS1--------------------------#
train1_pred1_ROI <- IKARUS::exrct_Traindat(train_1, predictors_ROI_1, "class")
#NAs detected: deleting 3187484  NAs
write.csv(train1_pred1_ROI, paste0(path_analysis_results_traindat_ROI, "train1_pred1_ROI.csv"))
train1_pred1_ROI <- read.csv(paste0(path_analysis_results_traindat_ROI, "train1_pred1_ROI.csv"),
                             header = TRUE, sep=",")
#------------------------TRAIN 1 PREDICTORS 2 - FFS2---------------------------#
train1_pred2_ROI <- IKARUS::exrct_Traindat(train_1, predictors_ROI_2, "class")
#NAs detected: deleting 3187484  NAs
write.csv(train1_pred2_ROI, paste0(path_analysis_results_traindat_ROI, "train1_pred2_ROI.csv"))
train1_pred2_ROI <- read.csv(paste0(path_analysis_results_traindat_ROI, "train1_pred2_ROI.csv"),
                             header = TRUE, sep=",")
#---------------------------TRAIN 2 PREDICTORS 1 - FFS3------------------------#
train2_pred1_ROI <- IKARUS::exrct_Traindat(train_2, predictors_ROI_1, "class")
#NAs detected: deleting 3186401  NAs
write.csv(train2_pred1_ROI, paste0(path_analysis_results_traindat_ROI, "train2_pred1_ROI.csv"))
train2_pred1_ROI <- read.csv(paste0(path_analysis_results_traindat_ROI, "train2_pred1_ROI.csv"),
                             header = TRUE, sep=",")
#----------------------------TRAIN 2 PREDICTORS 2 - FFS4-----------------------#
train2_pred2_ROI <- IKARUS::exrct_Traindat(train_2, predictors_ROI_2, "class")
#NAs detected: deleting 3186401  NAs
write.csv(train2_pred2_ROI, paste0(path_analysis_results_traindat_ROI, "train2_pred2_ROI.csv"))
train2_pred2_ROI <- read.csv(paste0(path_analysis_results_traindat_ROI, "train2_pred2_ROI.csv"),
                             header = TRUE, sep=",")
####---------------------2.2 FORWARD FEATURE SELECTION----------------------####
#-----------------------FFS1_ROI - TRAIN 1 - PREDICTORS 1----------------------#
FFS_1_ROI <- IKARUS::BestPredFFS(train1_pred1_ROI, predCol = "default",
                                 classCol = "class", Cores = 1)
#256 max...
#needed 0.0339 hours
#Note: No increase in performance found using more than 3 variables
#selected variables
#MSR_min3_ALL_ind_stack_ROI_homog093_filt_corr_09_pred_1, VVI_min3_ALL_ind_stack_ROI_homog093_filt_corr_09_pred_1, TGI_max3_ALL_ind_stack_ROI_homog093_filt_corr_09_pred_1
saveRDS(FFS_1_ROI, paste0(path_analysis_results_FFS_ROI,"FFS_1_ROI.rds"))
FFS_1_ROI<- readRDS(paste0(path_analysis_results_FFS_ROI,"FFS_1_ROI.rds"))
FFS_1_ROI$selectedvars # show seleted variables
#"MSR_min3_ALL_ind_stack_ROI_homog093_filt_corr_09_pred_1" "VVI_min3_ALL_ind_stack_ROI_homog093_filt_corr_09_pred_1" "TGI_max3_ALL_ind_stack_ROI_homog093_filt_corr_09_pred_1"
FFS_1_ROI$perf_all # show performance of all combinations
FFS_1_ROI$finalModel
#-----------------------FFS2_ROI - TRAIN 1 - PREDICTORS 2----------------------#
FFS_2_ROI <- IKARUS::BestPredFFS(train1_pred2_ROI , predCol = "default",
                                 classCol = "class", Cores = 1)
#256 max ...
#needed 0.0476 hours
#Note: No increase in performance found using more than 5 variables
#selected variables
#GLI_min3_ALL_RGBMS_stack_ROI_homog093_filt_corr_09_pred_2, TGI_max3_ALL_RGBMS_stack_ROI_homog093_filt_corr_09_pred_2,
#SI_max3_ALL_RGBMS_stack_ROI_homog093_filt_corr_09_pred_2, VVI_sobel3_ALL_RGBMS_stack_ROI_homog093_filt_corr_09_pred_2,
#VVI_modal3_ALL_RGBMS_stack_ROI_homog093_filt_corr_09_pred_2
saveRDS(FFS_2_ROI, paste0(path_analysis_results_FFS_ROI,"FFS_2_ROI.rds"))
FFS_2_ROI<- readRDS(paste0(path_analysis_results_FFS_ROI,"FFS_2_ROI.rds"))
FFS_2_ROI$selectedvars
FFS_2_ROI$perf_all
FFS_2_ROI$finalModel
#-------------------------FFS3_ROI - TRAIN 2 - PREDICTORS 1--------------------#
FFS_3_ROI <- IKARUS::BestPredFFS(train2_pred1_ROI, predCol = "default",
                             classCol = "class", Cores = 1)
#256 max ...
#needed 0.0711 hours
#Note: No increase in performance found using more than 4 variables
#GLI_min3_ALL_ind_stack_ROI_homog093_filt_corr_09_pred_1, TGI_max3_ALL_ind_stack_ROI_homog093_filt_corr_09_pred_1,
#VVI_modal3_ALL_ind_stack_ROI_homog093_filt_corr_09_pred_1, VVI_sobel3_ALL_ind_stack_ROI_homog093_filt_corr_09_pred_1
saveRDS(FFS_3_ROI, paste0(path_analysis_results_FFS_ROI,"FFS_3_ROI.rds"))
FFS_3_ROI<- readRDS(paste0(path_analysis_results_FFS_ROI,"FFS_3_ROI.rds"))
FFS_3_ROI$selectedvars
FFS_3_ROI$perf_all
FFS_3_ROI$finalModel
#-------------------------FFS4_ROI- TRAIN 2 - PREDICTORS 2------------------------#
FFS_4_ROI <- IKARUS::BestPredFFS(train2_pred2_ROI, predCol = "default", classCol = "class", Cores = 1)
#256 max ...
#needed 0.0711 hours
#Note: No increase in performance found using more than 4 variables
#GLI_min3_ALL_RGBMS_stack_ROI_homog093_filt_corr_09_pred_2, TGI_max3_ALL_RGBMS_stack_ROI_homog093_filt_corr_09_pred_2,
#VVI_min3_ALL_RGBMS_stack_ROI_homog093_filt_corr_09_pred_2, Blue_min3_ALL_RGBMS_stack_ROI_homog093_filt_corr_09_pred_2
saveRDS(FFS_4_ROI, paste0(path_analysis_results_FFS_ROI,"FFS_4_ROI.rds"))
FFS_4_ROI<- readRDS(paste0(path_analysis_results_FFS_ROI,"FFS_4_ROI.rds"))
FFS_4_ROI$selectedvars
FFS_4_ROI$perf_all
FFS_4_ROI$finalModel
####-------------------2.3 EXTRACT TRAINING DATA + CLASS--------------------####
#--------------------------FFS1ROI:train_1 + predictors_1----------------------#
FFS_1_ROI$selectedvars
#"MSR_min3_ALL_ind_stack_ROI_homog093_filt_corr_09_pred_1"
#"VVI_min3_ALL_ind_stack_ROI_homog093_filt_corr_09_pred_1"
#"TGI_max3_ALL_ind_stack_ROI_homog093_filt_corr_09_pred_1"
#filter the train1_pred1_ROI traindat to the selected variables + class:
names(train1_pred1_ROI)
train_FFS_1_ROI <- train1_pred1_ROI[, c(3, 14, 11, 18)]
write.csv(train_FFS_1_ROI, paste0(path_analysis_results_train_class_ROI, "train_FFS_1_ROI.csv"))
#--------------------------FFS2ROI:train_1 + predictors_2----------------------#
FFS_2_ROI$selectedvars
#"GLI_min3_ALL_RGBMS_stack_ROI_homog093_filt_corr_09_pred_2"
#"TGI_max3_ALL_RGBMS_stack_ROI_homog093_filt_corr_09_pred_2"
#"SI_max3_ALL_RGBMS_stack_ROI_homog093_filt_corr_09_pred_2"
#"VVI_sobel3_ALL_RGBMS_stack_ROI_homog093_filt_corr_09_pred_2"
#"VVI_modal3_ALL_RGBMS_stack_ROI_homog093_filt_corr_09_pred_2"
#filter the train1_pred2 traindat to the selected variables:
names(train1_pred2_ROI)
train_FFS_2_ROI <- train1_pred2_ROI[, c(2, 11, 7, 17, 15, 18)]
write.csv(train_FFS_2_ROI, paste0(path_analysis_results_train_class_ROI, "train_FFS_2_ROI.csv"))
#---------------------------FFS3ROI:train_2 + predictors_1------------------------#
FFS_3_ROI$selectedvars
#"GLI_min3_ALL_ind_stack_ROI_homog093_filt_corr_09_pred_1"
#"TGI_max3_ALL_ind_stack_ROI_homog093_filt_corr_09_pred_1"
#"VVI_modal3_ALL_ind_stack_ROI_homog093_filt_corr_09_pred_1"
#"VVI_sobel3_ALL_ind_stack_ROI_homog093_filt_corr_09_pred_1"
#filter the train2_pred1 traindat to the selected variables:
names(train2_pred1_ROI)
train_FFS_3_ROI <- train2_pred1_ROI[, c(1, 11, 15, 17, 18)]
write.csv(train_FFS_3_ROI, paste0(path_analysis_results_train_class_ROI, "train_FFS_3_ROI.csv"))
#---------------------------FFS4:train_2 + predictors_2------------------------#
FFS_4_ROI$selectedvars
#"GLI_min3_ALL_RGBMS_stack_ROI_homog093_filt_corr_09_pred_2"
#"TGI_max3_ALL_RGBMS_stack_ROI_homog093_filt_corr_09_pred_2"
#"VVI_min3_ALL_RGBMS_stack_ROI_homog093_filt_corr_09_pred_2"
#"Blue_min3_ALL_RGBMS_stack_ROI_homog093_filt_corr_09_pred_2"
#filter the train2_pred2 traindat to the selected variables:
names(train2_pred2_ROI)
train_FFS_4_ROI <- train2_pred2_ROI[, c(2, 11, 14, 1, 18)]
write.csv(train_FFS_4_ROI, paste0(path_analysis_results_train_class_ROI, "train_FFS_4_ROI.csv"))
####-----------------------2.4 STACK FINAL PREDICTORS-----------------------####
#--------------------------FFS1ROI:train_1 + predictors_1----------------------#
names(train_FFS_1_ROI)
#"MSR_min3_ALL_ind_stack_ROI_homog093_filt_corr_09_pred_1"
#"VVI_min3_ALL_ind_stack_ROI_homog093_filt_corr_09_pred_1"
#"TGI_max3_ALL_ind_stack_ROI_homog093_filt_corr_09_pred_1" "class"
#filter the predictorstack to the selected variables
predictors_FFS_1_ROI <- raster::stack(predictors_ROI_1$MSR_min3_ALL_ind_stack_ROI_homog093_filt_corr_09_pred_1,
                                      predictors_ROI_1$VVI_min3_ALL_ind_stack_ROI_homog093_filt_corr_09_pred_1,
                                      predictors_ROI_1$TGI_max3_ALL_ind_stack_ROI_homog093_filt_corr_09_pred_1)
#--------------------------FFS2ROI:train_1 + predictors_2----------------------#
names(train_FFS_2_ROI)
#"GLI_min3_ALL_RGBMS_stack_ROI_homog093_filt_corr_09_pred_2"
#"TGI_max3_ALL_RGBMS_stack_ROI_homog093_filt_corr_09_pred_2"
#"SI_max3_ALL_RGBMS_stack_ROI_homog093_filt_corr_09_pred_2"
#"VVI_sobel3_ALL_RGBMS_stack_ROI_homog093_filt_corr_09_pred_2"
#"VVI_modal3_ALL_RGBMS_stack_ROI_homog093_filt_corr_09_pred_2", "class"
#filter the predictorstack to the selected variables
predictors_FFS_2_ROI <- raster::stack(predictors_ROI_2$GLI_min3_ALL_RGBMS_stack_ROI_homog093_filt_corr_09_pred_2,
                                      predictors_ROI_2$TGI_max3_ALL_RGBMS_stack_ROI_homog093_filt_corr_09_pred_2,
                                      predictors_ROI_2$SI_max3_ALL_RGBMS_stack_ROI_homog093_filt_corr_09_pred_2,
                                      predictors_ROI_2$VVI_sobel3_ALL_RGBMS_stack_ROI_homog093_filt_corr_09_pred_2,
                                      predictors_ROI_2$VVI_modal3_ALL_RGBMS_stack_ROI_homog093_filt_corr_09_pred_2)
#---------------------------FFS3ROI:train_2 + predictors_1------------------------#
names(train_FFS_3_ROI)
#"GLI_min3_ALL_ind_stack_ROI_homog093_filt_corr_09_pred_1"
#"TGI_max3_ALL_ind_stack_ROI_homog093_filt_corr_09_pred_1"
#"VVI_modal3_ALL_ind_stack_ROI_homog093_filt_corr_09_pred_1"
#"VVI_sobel3_ALL_ind_stack_ROI_homog093_filt_corr_09_pred_1", "class"
#filter the predictorstack to the selected variables
predictors_FFS_3_ROI <- raster::stack(predictors_ROI_1$GLI_min3_ALL_ind_stack_ROI_homog093_filt_corr_09_pred_1,
                                      predictors_ROI_1$TGI_max3_ALL_ind_stack_ROI_homog093_filt_corr_09_pred_1,
                                      predictors_ROI_1$VVI_modal3_ALL_ind_stack_ROI_homog093_filt_corr_09_pred_1,
                                      predictors_ROI_1$VVI_sobel3_ALL_ind_stack_ROI_homog093_filt_corr_09_pred_1)
#---------------------------FFS4:train_2 + predictors_2------------------------#
names(train_FFS_4_ROI)
#"GLI_min3_ALL_RGBMS_stack_ROI_homog093_filt_corr_09_pred_2"
#"TGI_max3_ALL_RGBMS_stack_ROI_homog093_filt_corr_09_pred_2"
#"VVI_min3_ALL_RGBMS_stack_ROI_homog093_filt_corr_09_pred_2"
#"Blue_min3_ALL_RGBMS_stack_ROI_homog093_filt_corr_09_pred_2" "class"
#filter the predictorstack to the selected variables
predictors_FFS_4_ROI <- raster::stack(predictors_ROI_2$GLI_min3_ALL_RGBMS_stack_ROI_homog093_filt_corr_09_pred_2,
                                      predictors_ROI_2$TGI_max3_ALL_RGBMS_stack_ROI_homog093_filt_corr_09_pred_2,
                                      predictors_ROI_2$VVI_min3_ALL_RGBMS_stack_ROI_homog093_filt_corr_09_pred_2,
                                      predictors_ROI_2$Blue_min3_ALL_RGBMS_stack_ROI_homog093_filt_corr_09_pred_2)
####------------------------3.MODEL + PREDICTION----------------------------####
#---------------------------------PREDICTION 1 ROI-----------------------------#
pred_1_ROI <- IKARUS::RFclass(tDat= train_FFS_1_ROI, predStk=predictors_FFS_1_ROI,
                          predCol = "default", classCol = "class", Cores =1)
#finished model needed 0.0012 hours

#read model
pred_1_ROI$model_cv
#Random Forest
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
saveRDS(pred_1_ROI$model_cv, paste0(path_analysis_results_models_ROI,"model_1_ROI.rds"))

#load the model for the case if it needs to be inspected/worked with later
model_1<- readRDS(paste0(path_analysis_results_models,"model_1.rds"))

#plot the importance of the predictors used for building the model
plot(varImp(pred_1_ROI$model_cv))

#write prediction in a file
writeRaster(pred_1_ROI$prediction, paste0(path_analysis_results_predictions_ROI,"pred_1_ROI"),
            format="GTiff", overwrite = TRUE)

#read prediction in case it shall be used later
pred_1_ROI <- raster::stack(paste0(path_analysis_results_predictions_ROI, lspred_ROI[[1]]))

#plot prediction 1
#if plotted right after prediction, the use pred_1_ROI$prediction instead of pred_1_ROI
cols <- c("orangered4", "black",  "seagreen", "navajowhite4",  "darkgreen", "deepskyblue4")
plot(pred_1_ROI$prediction, col=cols, legend=FALSE, main="Prediction 1: train 1 + predictors 1")
legend("bottomright", legend=c("grass", "shadow", "shrubs", "stone", "tree", "tree_in_shadow"),
       fill=cols, bg="white")

#---------------------------------PREDICTION 2---------------------------------#
pred_2_ROI <- IKARUS::RFclass(tDat= train_FFS_2_ROI, predStk=predictors_FFS_2_ROI,
                          predCol = "default", classCol = "class", Cores =1)
#finished model needed 0.0013 hours
pred_2_ROI$model_cv
#Random Forest
#384 samples
#5 predictor
#6 classes: 'grass', 'shadow', 'shrubs', 'stone', 'tree', 'tree_in_shadow'
#No pre-processing
#Resampling: Cross-Validated (5 fold)
#Summary of sample sizes: 306, 307, 307, 309, 307
#Resampling results across tuning parameters:
#  mtry  Accuracy   Kappa
#2     0.9507439  0.9388705
#3     0.9482491  0.9357529
#5     0.9351235  0.9195339
#Kappa was used to select the optimal model using the largest value.
#The final value used for the model was mtry = 2.

#save the model
saveRDS(pred_2_ROI$model_cv, paste0(path_analysis_results_models_ROI,"model_2_ROI.rds"))

#load the model for the case if it needs to be inspected/worked with later
model_2_ROI<- readRDS(paste0(path_analysis_results_models_ROI,"model_2_ROI.rds"))

#plot the importance of the predictors used for building the model
plot(varImp(pred_2_ROI$model_cv))

#write prediction in a file
writeRaster(pred_2_ROI$prediction, paste0(path_analysis_results_predictions_ROI,"pred_2_ROI"),
            format="GTiff", overwrite = TRUE)

#read prediction in case it shall be used later
pred_2_ROI <- raster::stack(paste0(path_analysis_results_predictions_ROI, lspred_ROI[[3]]))

#plot prediction 2
#if plotted right after prediction, the use pred_2$prediction instead of pred_2
cols <- c("orangered4", "black",  "seagreen", "navajowhite4",  "darkgreen", "deepskyblue4")
plot(pred_2_ROI$prediction, col=cols, legend=FALSE, main="Prediction 2: train 1 + predictors 2")
legend("bottomright", legend=c("grass", "shadow", "shrubs", "stone", "tree", "tree_in_shadow"),
       fill=cols, bg="white")
#---------------------------------PREDICTION 3---------------------------------#
pred_3_ROI <- IKARUS::RFclass(tDat= train_FFS_3_ROI, predStk=predictors_FFS_3_ROI,
                          predCol = "default", classCol = "class", Cores =1)
#finished model needed 0.0017 hours
pred_3_ROI$model_cv
#Random Forest
#1468 samples
#4 predictor
#6 classes: 'grass', 'shadow', 'shrubs', 'stone', 'tree', 'tree_in_shadow'
#No pre-processing
#Resampling: Cross-Validated (5 fold)
#Summary of sample sizes: 1174, 1174, 1175, 1175, 1174
#Resampling results across tuning parameters:
#  mtry  Accuracy   Kappa
#2     0.9972766  0.9966983
#3     0.9993197  0.9991756
#4     0.9972789  0.9967010

#Kappa was used to select the optimal model using the largest value.
#The final value used for the model was mtry = 3.
#save the model
saveRDS(pred_3_ROI$model_cv, paste0(path_analysis_results_models_ROI ,"model_3_ROI.rds"))

#load the model for the case if it needs to be inspected/worked with later
model_3_ROI<- readRDS(paste0(path_analysis_results_models_ROI,"model_3_ROI.rds"))

#plot the importance of the predictors used for building the model
plot(varImp(pred_3_ROI$model_cv))

#write prediction in a file
writeRaster(pred_3_ROI$prediction, paste0(path_analysis_results_predictions_ROI,"pred_3_ROI"),
            format="GTiff", overwrite = TRUE)

#read prediction in case it shall be used later
pred_3_ROI <- raster::stack(paste0(path_analysis_results_predictions_ROI, lspred_ROI[[5]]))

#if plotted right after prediction, the use pred_3$prediction instead of pred_3
cols <- c("orangered4", "black",  "seagreen", "navajowhite4",  "darkgreen", "deepskyblue4")
plot(pred_3_ROI$prediction, col=cols, legend=FALSE, main="Prediction 3: train 2 + predictors 1")
legend("bottomright", legend=c("grass", "shadow", "shrubs", "stone", "tree", "tree_in_shadow"),
       fill=cols, bg="white")
#---------------------------------PREDICTION 4---------------------------------#
pred_4_ROI <- IKARUS::RFclass(tDat= train_FFS_4_ROI, predStk=predictors_FFS_4_ROI,
                          predCol = "default", classCol = "class", Cores =1)
#finished model needed 0.0018 hours
pred_4_ROI$model_cv
#Random Forest
#1468 samples
#4 predictor
#6 classes: 'grass', 'shadow', 'shrubs', 'stone', 'tree', 'tree_in_shadow'
#No pre-processing
#Resampling: Cross-Validated (5 fold)
#Summary of sample sizes: 1174, 1174, 1175, 1175, 1174
#Resampling results across tuning parameters:
#  mtry  Accuracy   Kappa
#2     1.0000000  1.0000000
#3     0.9993197  0.9991756
#4     0.9979569  0.9975236
#Kappa was used to select the optimal model using the largest value.
#The final value used for the model was mtry = 2.

#save the model
saveRDS(pred_4_ROI$model_cv, paste0(path_analysis_results_models_ROI,"model_4_ROI.rds"))

#load the model for the case if it needs to be inspected/worked with later
model_4_ROI<- readRDS(paste0(path_analysis_results_models_ROI,"model_4_ROI.rds"))

#plot the importance of the predictors used for building the model
plot(varImp(pred_4_ROI$model_cv))

#write prediction in a file
writeRaster(pred_4_ROI$prediction, paste0(path_analysis_results_predictions_ROI, "pred_4_ROI"),
            format="GTiff", overwrite = TRUE)

#read prediction in case it shall be used later
pred_4_ROI <- raster::stack(paste0(path_analysis_results_predictions_ROI, lspred_ROI[[7]]))

#if plotted right after prediction, the use pred_4$prediction instead of pred_4
cols <- c("orangered4", "black",  "seagreen", "navajowhite4",  "darkgreen", "deepskyblue4")
plot(pred_4_ROI$prediction, col=cols, legend=FALSE, main="Prediction 4: train 2 + predictors 2")
legend("bottomright", legend=c("grass", "shadow", "shrubs", "stone", "tree", "tree_in_shadow"),
       fill=cols, bg="white")
