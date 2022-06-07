####--------------------------------SHORTCUTS-------------------------------####
lssegm <- list.files(paste0(path_analysis_results_segm_segm_ROI), pattern=".shp")
lssegmta1 <- list.files(paste0(path_analysis_results_segm_segm_ta1), pattern=".shp")
#-----------------------------LOAD SEGMENTATION OF ROI-------------------------#
lssegm
#[1] "chm1_test_0.shp"   "chm1_test_1.shp"   "chm1_test_2.shp"   "chm1_test_3.shp"
#[5] "chm1_test_vp1.shp" "chm1_test_vp2.shp" "chm1_test_vp3.shp"
segm_ROI <- readOGR(file.path(path_analysis_results_segm_segm_ROI, lssegm[[1]]))
#--------------------------LOAD SEGMENTATION OF AREA 1-------------------------#
lssegmta1
#[1] "chm1_test_0.shp"   "chm1_test_1.shp"   "chm1_test_2.shp"   "chm1_test_3.shp"
#[5] "chm1_test_vp1.shp" "chm1_test_vp2.shp" "chm1_test_vp3.shp"
seg_1 <- readOGR(paste0(path_analysis_results_segm_segm_ta1, lssegm[[5]]))
################################################################################
#NOTE: 9.1 HAS TO BE PROCESSED RIGHT AFTER THE PREDICTION ON TEST AREA !
#      9.2 HAS TO BE PROCESSED RIGHT AFTER THE PREDICTION ON ROI!
#Because IKARUS::classSegVal only takes the prediction as pred=pred_1$prediction,
#not as simply prediction.

####--1.VALIDATION CLASSIFICATION TEST AREA 1 WITH SEGMENTATION TEST AREA 1-####

#the best classification is 1, chosen visually in QGIS

#from the prediction order of classes:
#"grass"          "shadow"         "shrubs"         "stone"          "tree"           "tree_in_shadow"

#IKARUS::classSegVal only takes data format pred_1$prediction!
#----------------------------validate class 5, trees---------------------------#
validation_trees <- IKARUS::classSegVal(pred=pred_1$prediction, seg=seg_1,
                                        classTree = 5, reclass = NULL)

#IKARUS starting validation
#valdiation score:  0.8093 @ 0.6656
#    nclass  nseg overclass underclass   hit hitrate rate underclass rate overclass
#1  22012 33930      4197      16115 17815  0.8093          0.4749         0.1907

writeRaster(validation_trees, paste0(path_analysis_results_validation,
                                     "valid_area_1_trees"), format="GTiff",
            overwrite = TRUE)

#--------------------validate class 5+6, trees+tree_in_shadow------------------#
validation_trees_treesnshadow <- IKARUS::classSegVal(pred=pred_1$prediction,
                                                     seg=seg_1,classTree=5,
                                                     reclass=6)
#IKARUS starting validation
#valdiation score:  0.7593 @ 0.5776
#  nclass  nseg overclass underclass  hit   hitrate rate underclass rate overclass
#1  29633 33930   7133      11430     22500     0.7593      0.3369        0.2407

writeRaster(validation_trees_treesnshadow, paste0(path_analysis_results_validation,
                                                  "valid_area_1_treesnshadows"),
            format="GTiff", overwrite = TRUE)

####----------2.VALIDATION CLASSIFICATION ROI WITH SEGMENTATION ROI---------####
#the best classification is also in the case of the ROI  pred_1_ROI, chosen visually in QGIS

#from the prediction order of classes:
#"grass"          "shadow"         "shrubs"         "stone"          "tree"           "tree_in_shadow"

#IKARUS::classSegVal only takes data format pred_1$prediction!
#----------------------------validate class 5, trees---------------------------#
validation_trees_ROI <- IKARUS::classSegVal(pred=pred_1_ROI$prediction, seg=segm_ROI,
                                            classTree = 5, reclass = NULL)
#IKARUS starting validation
#valdiation score:  0.4411 @ 1.0089
#   nclass   nseg overclass underclass  hit   hitrate rate underclass rate overclass
#1 886769 711102    495632     319965  391137  0.4411        0.45           0.5589

writeRaster(validation_trees_ROI, paste0(path_analysis_results_validation_ROI,
                                         "valid_trees_ROI"), format="GTiff",
            overwrite = TRUE)
#--------------------validate class 5+6, trees+tree_in_shadow------------------#
validation_trees_treesnshadow_ROI <- IKARUS::classSegVal(pred=pred_1_ROI$prediction,
                                                         seg=segm_ROI, classTree=5,
                                                         reclass=6)
#IKARUS starting validation
#valdiation score:  0.4222 @ 0.9187
#  nclass   nseg  overclass underclass   hit   hitrate  rate underclass rate overclass
#1 1110145 711102    641439   242396    468706  0.4222      0.3409         0.5778

writeRaster(validation_trees_treesnshadow_ROI, paste0(path_analysis_results_validation_ROI,
                                                      "valid_treesnshadows_ROI"),
                                                      format="GTiff", overwrite = TRUE)
