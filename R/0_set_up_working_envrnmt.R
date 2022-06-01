################################################################################
####-----------------------------#PREPARATIONS#-----------------------------####
#------------#clean R history, to get a clear working environment#-------------#
rm(list=ls())
#------------------#prepare system independent environment#--------------------#
#please change the path to the projects library according to where you want to
#place the R project library on you computer!

if(Sys.info()["sysname"] == "Windows"){
  projRootDir <- "C:/Users/kelto/Documents/detectATE/"
} else {
  projRootDir <- "/home/keltoskytoi/detectATE/"
}
#---------------------------#creating a folder structure#----------------------#
paths<-link2GI::initProj(projRootDir = projRootDir,
                         projFolders = c("analysis/data/dsm/",
                                         "analysis/data/dem/",
                                         "analysis/data/RGB_IR/",
                                         "analysis/data/treepos/",
                                         "analysis/data/train/",
                                         "analysis/results/chm/",
                                         "analysis/results/segm/",
                                         "analysis/results/segm/segm_ta1/",
                                         "analysis/results/segm/segm_ROI/",
                                         "analysis/results/segm/segm_table/",
                                         "analysis/results/prdctr1/",
                                         "analysis/results/prdctr2/",
                                         "analysis/results/traindat/",
                                         "analysis/results/traindat_ROI/",
                                         "analysis/results/train_class/",
                                         "analysis/results/train_class_ROI/",
                                         "analysis/results/FFS/",
                                         "analysis/results/FFS_ROI/",
                                         "analysis/results/models/",
                                         "analysis/results/predictions/",
                                         "analysis/results/ind_ROI/",
                                         "analysis/results/filt_093_1_ROI/",
                                         "analysis/results/filt_093_2_ROI/",
                                         "analysis/results/filt_09_ta1/",
                                         "analysis/results/filt_09_ta1_2/",
                                         "analysis/results/models_ROI/",
                                         "analysis/results/prdctrs1_ROI/",
                                         "analysis/results/prdctrs2_ROI/",
                                         "analysis/results/predictions_ROI/",
                                         "analysis/results/validation/",
                                         "analysis/results/validation_ROI/",
                                         "analysis/results/tmp/"
                                         ),
                         global = TRUE,
                         path_prefix = "path_")
#------------------------------#load library#----------------------------------#
#The source file enables you to install and activate packages in one run
source("C:/Users/kelto/Documents/detectATE/R/00_library_n_prep.R")

#create shortcuts to the folders where de data is stored
#to be able to check all results, we have to tell R, to extend the minimum of the printed rows rows
options(max.print=10000)

#if not installed, please install:
remotes::install_github("SchoenbergA/IKARUS")
remotes::install_github("SchoenbergA/LEGION@develop", build_vignettes = TRUE)
remotes::install_github("SchoenbergA/CENITH@develop")
remotes::install_github("nevrome/rrtools.addin")

