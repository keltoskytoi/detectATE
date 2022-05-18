lstrain <- list.files(file.path(path_train), pattern=".shp")
lstraindat <- list.files(file.path(path_traindat), pattern=".csv")
lspredROI <- list.files(file.path(path_pred_ROI), pattern=".tif")
lsFFS <- list.files(file.path(path_FFS), pattern = ".rds")
lsmod <- list.files(file.path(path_models), pattern = ".rds")
lssegm <- list.files(file.path(path_segm), pattern=".shp")
lspredictROI <- list.files(file.path(path_prediction_ROI), pattern=".shp")

####################################LOAD DATA###################################
#load predictors
predictors_ROI <- raster::stack(paste0(path_pred_ROI, lspredROI))
names(predictors_ROI) 
#[1] "GLI_modal3" "MSR_modal3" "TDVI_sd3"   "TGI_sd3"    "TGI_sum3"  

#load training polygons
train_1 <-readOGR(file.path(path_train, lstrain[[1]])) 

#load segmentation of area 1
lssegm
seg_1 <- readOGR(file.path(path_segm, lssegm[[5]]))

#check the crs of the data
crs(predictors_ROI)
crs(train_1)
train_1 <- spTransform(train_1, crs(predictors_ROI))
crs(train_1)
crs(seg_1)

#######################EXTRACT TRAINING DATA FROM POLYGONS######################
#####TRAIN 1 PREDICTORS_ROI ####
train1_pred_ROI <- IKARUS::exrct_Traindat(train_1, predictors_ROI, "class")
#NAs detected: deleting 3102287  NAs
write.csv(train1_pred_ROI, file.path(path_traindat, "train1_pred_ROI.csv"))

###############################MODEL + PREDICTION###############################
pred_ROI <- IKARUS::RFclass(tDat= train1_pred_ROI, predStk=predictors_ROI, 
                          predCol = "default", classCol = "class", Cores =1)
#needed 0.0016 hours
pred_ROI$model_cv
#385 samples
#5 predictor
#6 classes: 'grass', 'shadow', 'shrubs', 'stone', 'tree', 'tree_in_shadow' 

#No pre-processing
#Resampling: Cross-Validated (5 fold) 
#Summary of sample sizes: 307, 308, 308, 309, 308 
#Resampling results across tuning parameters:
  
#  mtry  Accuracy   Kappa    
#2     0.9196435  0.9002304
#3     0.9197110  0.9002409
#5     0.9170470  0.8969437

#Kappa was used to select the optimal model using the largest value.
#The final value used for the model was mtry = 3.

#save the model
saveRDS(pred_ROI$model_cv, file=file.path(path_models,"model_ROI.rds"))
plot(varImp(pred_ROI$model_cv))

#write prediction in a file
writeRaster(pred_ROI$prediction, file=file.path(path_prediction_ROI,"pred_ROI"), 
            format="GTiff", overwrite = TRUE)

pred_1 <- raster::stack(file.path(path_prediction_ROI, lspredictROI[[1]]))
#plot prediction ROI
cols <- c("orangered4", "black",  "seagreen", "navajowhite4",  "darkgreen", "deepskyblue4")
plot(pred_ROI$prediction, col=cols, legend=FALSE, main="Prediction ROI: train 1 + predictors 11")
legend("bottomright", legend=c("grass", "shadow", "shrubs", "stone", "tree", "tree_in_shadow"), 
       fill=cols, bg="white")
plot(pred_ROI$prediction)