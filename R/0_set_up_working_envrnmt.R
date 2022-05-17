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
                                         "analysis/results/chm/",
                                         "analysis/results/train/",
                                         "analysis/results/segm/",
                                         "analysis/results/prdctr1/",
                                         "analysis/results/prdctr2/",
                                         "analysis/results/prdctr3/",
                                         "analysis/results/prdctr4/",
                                         "analysis/results/prdctr5/",
                                         "analysis/results/prdctr6/",
                                         "analysis/results/prdctr7/",
                                         "analysis/results/prdctr8/",
                                         "analysis/results/prdctr10/",
                                         "analysis/results/traindat/",
                                         "analysis/results/FFS/",
                                         "analysis/results/models/",
                                         "analysis/results/predictions/",
                                         "analysis/results/ROI_ind/",
                                         "analysis/results/filt_09_ROI/",
                                         "analysis/results/models_ROI/",
                                         "analysis/results/pred_ROI/",
                                         "analysis/results/prediction_ROI/",
                                         "analysis/results/validation/",
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

