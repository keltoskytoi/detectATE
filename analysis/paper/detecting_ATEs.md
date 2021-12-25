---
title: "Alpine Treeline Ecotone Detection – an Automated Remote Sensing Approach"
author: "Agnes Schneider"
date: "06/12/2020"
output:
  html_document: default
  pdf_document: default
---



# **I. Introduction**
Alpine Treeline Ecotones (ATEs) are transitional zones between subalpine Forest and Alpine (tundra) ecotones (Holtmeier – Broll 2005, Winings 20013) also referred to as upper-treeline (Elliott 2017) and occur globally (Singh – Dharaiya – Mohapatra 2015, Bader – Llambí – Chase – Buckley – Toivonen – Camaerero – Cairn – Brown – Wiegand – Resler 2020). They span between the actual Timberline/Economic Forest Line though the Upper/Physiognomic-Biologic Forest Line and the tree species line which is adjoining the actual Alpine zone (Chhetri – Thai 2019, 1543). The position of the treeline is influenced by multiple factors at local and regional level, but  temperature has been identified as the global driving  factor (Körner 1998, Körner – Paulsen 2004, Holtmeier – Broll 2005, Bader 2007, Barredo – Mauri – Caudullo 2020). The global pattern can be described by spatial patterns in the x-y plane (discrete or diffuse, Figure 1) and by changes in tree stature (abrupt or gradual, Figure 2) in a multi-dimensional space (Harsch – Bader 2011, Bader – Llambí – Chase – Buckley – Toivonen – Camarero – Cairn – Brown – Wiegand – Resler 2020). 

![Figure 1. Scheme of the spatial pattern of alpine treelines on the 2D x-y plane. a) Depicts the treeline as seen from above, while b) depicts the change of the treeline in the y direction (clustering of islands). c) Represents an abstraction of the pattern of treelines based on tree density change and the clustering of individual trees. Source: Bader – Llambí – Chase – Buckley – Toivonen – Camarero – Cairn – Brown – Wiegand – Resler 2020, Figure 1.](/home/keltoskytoi/ATE_detection/images_Rmd/Figure_1.png)

![Figure 2. Scheme of (discrete) tree stature/height change responding to change in elevation. a) Vertical cross section. b) Abstraction of tree stature change based on height change and deformation of tree shape. Source: Bader – Llambí – Chase – Buckley – Toivonen – Camarero – Cairn – Brown – Wiegand – Resler 2020, Figure 2.](/home/keltoskytoi/ATE_detection/images_Rmd/Figure_2.png)

Although recognized, the distribution of ATE patterns have neither been mapped, nor been described yet, let alone explained. Earlier studies have identified abrupt, diffuse, island and krummholz spatial patterns of ATEs (Harsch – Hulme – McGlone – Duncan 2009, Harsch – Bader 2011, Figure 2). As seen, treelines dispaly a high variability and differ in multiple dimensions. A comparison of multiple studies suggest, that the different spatial patterns of ATEs reflect fundamental ecological controlling processes and that different ATEs react differently to climate change (Harsch – Bader 2011, Figure 1) Figure 3.

![Figure 3. Matrix of 2D spatial pattern, stature change and ecological processes which can contribute to the different types of ATEs. Source: Bader – Llambí – Chase – Buckley – Toivonen – Camarero – Cairn – Brown – Wiegand – Resler 2020, Table 1.](/home/keltoskytoi/ATE_detection/images_Rmd/Figure_3.png)
To better understand and categorize ATEs a standardized description and terminology of spatial patterns has been proposed on hillslope and landscape scale by Bader – Llambí – Chase – Buckley – Toivonen – Camarero – Cairn – Brown – Wiegand – Resler 2020, including hypotheses for the general mechanisms behind the patterns. The terminology and the multidimensional state-space can be most clearly understood from Figure 4. 

![Figure 4. Matrix of the multidimensional state space of treeline forms depicting extreme cases of the different dimensions. Columns represent the  spatial patterns in the x-y plane and rows the change in tree stature (size and shape). The lines represents the hypothesized first-level ecological processes behind the patterns along an elevational gradient. The dotted line displays the growth limitation, the dashed line the dieback and the continuous line the mortality. Growth limitation always occurs while dieback only affects if krummholz is involved. Source: Bader – Llambí – Chase – Buckley – Toivonen – Camarero – Cairn – Brown – Wiegand – Resler 2020, Figure 3.](/home/keltoskytoi/ATE_detection/images_Rmd/Figure_4.png)
After the definition and the characterization of the spatial patterns of ATEs, the following overview of ATE research shall serve as a basis for the workflow proposed in this methodological paper to globally detect ATEs.

# **II. Overview of Alpine Treeline Ecotone Research with focus on methodology**

As already implied, Alpine Treeline Ecotone analysis has been carried out so far at local, regional and global scales with different focus. Chhetri – Thai 2019 investigate the use of GIS and remote sensing methods in ATE research between 1980 and 2017 and demonstrate that with the advances in sensor technology the access to higher resolution data and different data types the analysis methods diversify. Often it is hard to distinguish between the different methodological approaches because they all rely and depend on one-another and studies have usually applied multiple methods and methods have been applied for diverse scopes. The following overview of methods is crude and by no means comprehensive.  

## **II.1 Statistical – analytical approach** 

Until the dispersal of openly available remote sensing products the approach was mainly concentrated on physiological/response based investigations with statistical analysis of local indicators based on in situ measurements. The main question was mainly: which environmental drivers control the location of ATE’s and how complex are these (Körner 1998)? Drivers were differentiated on global, regional and local levels (Holtmeier – Broll 2005). As the main global driver temperature was defined (Körner 1998,  Körner 2012, Holtmeier – Broll 2007, 2, Bonanomi – Rita – Allevato – Cesarano – Saulino – Di Pasquale – Allegrezza – Pesaresi – Borghetti – Rossi – Saracino 2018), but at regional and local levels it looks more diverse: topography (Brown 1994, Virtanen – Mikkola – Nikula – Christensen –  Mazhitova –  Oberman – Kuhry 2004, Bader – Ruijten 2008), geomorphologic processes, herbivory or anthropogenic disturbance (Chhetri – Thai 2019). Analysis of topographic actors with logistic regression was used frequently (e.g Brown 1994, Virtanen – Mikkola – Nikula – Christensen –  Mazhitova –  Oberman – Kuhry 2004, Bader – Ruijten 2008).

## **II.2 Remote sensing approach**

The detection or localization of ATEs is facilitated by the availability of remote sensing data (satellite, airborne lately hyperspectral and UAV derived ortho/imagery). Specialized sensors operating in the R, G, B, IR, short-wave, hyperspectral and thermal regions of the electromagnetic spectrum give the possibility to approach and work with the specific spectral signatures (due to different absorption and reflection of radiation) of different vegetation entities. LiDAR data enables to include the factor height thus moving the analysis of treelines in a 3D space. The main focus of this methodological paper is on the remote sensing approach (automated detection) and exemplary papers are accentuated in a short summary. 
The use of GIS and remote sensing has been constantly increasing in treeline studies since 2000, with a few preceding pioneers. Earlier studies concentrated on mapping treeline positions and lately the interest shifted towards factors that control treeline variation (Chhetri – Thai 2019, 1543). It can also be seen that with the development of the respective sensors the interest and use moved to data with higher spatial resolution (LiDAR data, Hyperspectral data), which on the other hand attracts more cost and thus often thins out the studies due to the lack of monetary resources and also the use of proprietary software, which shows that there is a lot to do in means of open-source and reproducible best-practice applications and code. Usually there is little information on the software used.
The use of remotely sensed data is usually combined with classical approaches like statistical analysis in complex research questions, from which the following main directions emerge: 

### *II.2a Mapping of ATEs*

To map ATEs, studies use aerial photographs and Landsat imagery to identify and quantify treelines (Brown 1994, Baker – Honaker – Weisberg 1995, Allen – Walsh 1996, Kimball – Weihrauch 2000, Virtanen – Mikkola – Nikula – Christensen –  Mazhitova –  Oberman – Kuhry 2004, Resler – Fonstad – Butler 2004) but often also vegetation indices are used Myneni – Keeling – Tucker 1997, Singh – Dharaiya – Mohapatra 2015, Mohapatra – Singh – Tripathi – Pandya 2019) to analyse treeline elevation (Allen – Walsh 1996, Kimball-Weihrauch 2000) and topographic variables/geomorphological parameters (slope, angle, curvature, relief) to explain treeline structure (patch-metrics) (Bryant et al 1991, Kimball-Weihrauch 2000). Tree population parameters are derived via PCA (e.g Baker – Weisberg 1997) and also species distribution modelling is a usual application (Chhetri – Shrestha – Cairns 2017).

### *II.2b Montitoring ATEs/Change detection*

ATEs are space and time related phenomenons and they respond to changing environmental conditions, that is they can be sensitive to climate change (Singh – Dharaiya – Mohapatra 2015, Holtmeier – Broll 2005, Holtmeier – Broll 2007, Harsch – Bader 2011, Bader – Llambí – Chase – Buckley – Toivonen – Camarero – Cairn – Brown – Wiegand – Resler 2020). The rise in global average temperatures seems to lead to the geographically varying shifting of ecotones: on regional level to upward shift (Mohapatra – Singh – Tripathi – Pandya 2019) but also stable or retracting ATEs can be determined (Winnings 2013). It still has to be understood if the results are due data quality. The identification and quantification of change in the ATEs can be carried out with regional and global monitoring of ATEs (Chhetri – Thai 2019). 

### *II.2c Automated detection and mapping of ATEs*

Recently several research projects, Master theses and PhDs have investigated (semi-)automated detection and mapping methods of ATEs (see a list until 2013 in Winnings 2013 and the also the recent literature).  The availability of high resolution data facilitate the use of more and more sophisticated methods. In this methodological paper we are concentrating specifically on automated analysis.  
Automated methods imply the use of specific algorithms to extract information from remote sensing data,  either pixel- or object based or recently also via Deep Learning  (mainly CNNs).  Some studies compare object- and pixel-based or different object-based segmentation methods (Immitzer – Atzberger – Koukal 2012, Winings 2013, Kupková – Červená – Suchá – Jakešová – Zagajewski – Březina –  Albrechtová 2017). Also it has to be emphasized, that the automated detection of ATEs relies heavily on tree detection. Parallel to elaborated workflows for the automated detection of ATEs improvements are made continuously on tree detection methods and tree cover estimation (Whiteside – Esparon – Bartolo 2020) closely connected to the development of sensors and the new data processing methods (Qiu – Jing – Hu  – Li  – Tang 2020, Weinstein – Marconi – Bohlman – Zare – White 2019, Weinstein – Marconi – Bohlman – Zare – White 2020) and form an important basis for automated analysis. In the following the most prominent automated methods are presented shortly including a few case studies.

*Pixel-based* image analysis is working with the information encoded in pixels – it assigns each pixel to a specific class on the basis of the respective values of the spectral bands or index or morphometric information (slope, aspect, etc.). One drawback is, that the context of the pixels and it’s neighbourhood gets neglected and the pixel values can be affected by circumstantial effects, like reflectance differences (Stueve – Isaacs –  Tyrrell – Densmore 2011), shadow or clouds (Allen – Walsh 1996). Also it doesn't deal, with textures per se, and for this a textural analysis has to be done by using different filters (mean, sobel, focal, etc.). 

**Resler – Fonstad – Butler 2004** use panchromatic aerial imagery where they incorporate spectral (brightness values) and spatial (textural) information to classify 4 classes (tundra/bare, alpine meadow, open forest/krummholz and closed canopy) representing the ATE using the maximum likelihood algorithm. A classification with and without textural information was done to assess the meaningfulness of textural information. The ERDAS modeler was used to extract textures.  

**Král 2009** uses CIR orthophotos to do a “classical” landcover classification using the maximum likelihood classifier, which then is reclassified into 2 classes (spruce canopies and other). Subsequently a focal filter is applied to the spruce canopy closure class for texture analysis, which is then reclassified into 5 classes (no trees, emergent trees, groups of trees, open-canopy forest, closed canopy forest).  Class 3, that is groups of trees (26-50% spruce),  neighbouring to alpine grassland and open-canopy forest was defined as ATE.

**Immitzer – Atzberger – Koukal 2012** used WW-2 satellite data (8 + 4 bands) for the identification of 10 tree species by means of Random forest classification (object-based vs. pixel-based) using spectra of a) manually delineated tree crowns b) derived tree crown polygons and reference samples for tree species.

**Winings 2013** used high resolution aerial imagery and LiDAR data in her Master’s thesis to map the alpine treeline. She compared pixel- and object based classification. She used four different data input for both classification methods: NDVI, NDVI + multispectral aerial imagery, NDVI + tree height or NDVI +  multispectral aerial imagery + tree height. In the case of the pixel-based classification the maximum likelihood and the unsupervised ISODATA (Iterative Self-Organizing Data Analysis Technique) clustering algorithms were compared. For the object-based image analysis multi-resolution segmentation was conducted,  using colour and shape homogeneity. After the segmentation, the classes (tree vs. non-tree) were assigned based on object feature threshold. The accuracy for the pixel-based classifications was between 85.3 and 88.4 and for the object-based classification between 81.5 and 92.9 %, resulting in the best classification on the dataset with  NDVI +  multispectral aerial imagery + tree height. For the pixel-based image analysis ENVI and ERDAS and for the object-based analysis eCognition was used. 
**Kupková – Červená – Suchá – Jakešová – Zagajewski – Březina –  Albrechtová 2017** used  airborne hypersepctral (APEX and AISA DUAL) and Sentinel-A data for the classification of tundra vegetation by comparing pixel-based and object-based image analysis. Reference data was collected corresponding to 8 vegetation classes (anthropogenic areas, picea abies, pinus mugo dense, pinus mugo sparse, closed alpine grassland, grasses, alpine heathlands, wetlands and peat bogs; with a detailed and a simplified legend). Based on the difference in resolution the hyperspectral data and the Sattelite imagery was classified separately. Latter was only classified pixel-based and with SVM (Support Vector Machines with radial basis function), NN (Neural Net) and MLC (Maximum Likelihood Classification) algorithms. The hyperspectral data, having a higher spatial resolution was classified pixel- and object-based. For the pixel-based classification the SVM, NN and MLC algoriths were used. For the objcet-based classification Edge-based segmentation was used on the hyperspectral datasets. The hyperspectral data yielded better classification result thean the Satellite data, with SVM pixel-based classification. ENVI was used for the study.

*Object-based Image Analysis (GeOBIA)* on the other hand is dealing with the grouping of pixels in homogeneous groups, that is segments which bear similar spectral, spatial and textural information. From each segment additional information can be extracted (statistical information,  size, shape and context).  Different segmentation algorithms exist, which treat the image and the segments different. 

**Middleton – Närhi  – Sutinen  – Sutinen 2008** used the Feature Extraction Module (Fx) implemented in ENVI to extract tree crowns from two aerial photographs (one from 1947 and one from 2003) via segmentation and feature classification with SVMwith textural, spatial and spectral information. The results were compared to forest inventory information and an upward shift was recorded on Lommoltunturi fell. 

**Ranson – Montesano – Nelson 2011** used MODIS VCF (Vegetation Continuous Fields) tree cover data and segmentation to delineate the circumpolar taiga-tundra ecotone (TTE). The multi-annual VCF was adjusted usingf linear regressions and a vector layer was applied with previously delineated taiga and tundra biomes. Also the water bodies were masked out. Subsequently multi-resolution segmentation was carried out with eCongnition based on the homogeneity criterion. The resulting polygons were then classified on a specific range of adjusted VCF values which represent the TTE.  

**Mishra – Mainali – Shrestha – Radenz – Karki 2018** used a UAV equipped with a Parrot Sequoia multispectral (Red, Green, Blue, Red Edge, Near Infra-Red) camera to acquire high resolution Imagery. Subsequently an SfM Orthoimage was calculated and then multi-resolution (based on the homogeneity criterium of scale, shape/colour and compactness/smoothness) and spectral difference segmentation (merging neighbouring objects based on a spectral threshold) was combined in eCognition to generate optimal feature space variables for the classes. Then the Random Forest Classifier was used for classification with 3 sets of features (spectral features; spectral features + geometric/shape features; spectral features + geometric/shape features + textural features) for species-level mapping of vegetation in the Himalayas.

**Whiteside – Esparon – Bartolo 2020** used derivatives of aerial imagery and WW2 satellite data (TGI, NDVI) resampled to 1 m filtered by a low-pass filter. Then a threshold-based multi-resolution segmentation was conducted with eCognition to assess the tree cover (in percentage) for each date (1964, 1976, 1981, 2010). The results were compared by date to assess the tree cover reduction (4%) during the 36 years.

**Luo – Dai 2020** used aerial imagery from 1962 and 1981, QuickBird Satellite image from 2006 was used as data input to map vegetation distribution after orthorectification, and generating a DEM. The land-cover types were delineated: Schrenkiana, Sabina and other. Multi-resolution (?) segmentation was conducted in eCognition subsequently combined with a k-nearest neighbour classification. The result was compared with fieldwork data collection (2010, 2011) of the two species. With the post-classification approach the land-cover change was examined between 1962, 1981 and 2006.

**Qiu – Jing – Hu  – Li  – Tang 2020** proposed a new spectral multi-scale (SMS) individual tree crown (ITC) delineation  method using both brightness and spectra of high-resolution multrispectral imagery to be able to better delineate tree crowns in deciduous or mixed forests, where adjacent tree crowns are very close to each other. As the first step a morphological gradient map is calculated of multispectral images, then as a second step an inverse gradient image. Then initial treetops were extracted by multi-scale filtering and morphological operations with regard to tree crown shape which then were refined with the spectral reference of the neighbouring treecrowns (tree trops map). Subsequently the morphological gradient map is segmented by marker-controlled watershed segmentation which is then refined by the tree tops map, to receive an individual tree crown delineation map. 

*Deep Learning* – contrary to pixel-based and GeOBIA – works on scene level and enables thus to deal better with the complex semantic structure of the increasing resolution of remote sensing images. A multitude of different Deep Learning models exist with different structures to fulfill different aims (e. g. segmentation, classification). The most common Deep Learning model structure are CNNs – Convolutzional Neural Networks, which are multi-layer networks with learning ability that consists of convolutional layers, pooling layers, and fully connected layers.  

**Fricker – Ventura – Wolf – North – Davis – Franklin 2019** used airborne hyper-spectral imagery, LiDAR data and a CNN (Convolutional Neural Network) to automate tree species classification. 7 dominant tree species and a dead tree class were identified to serve as reference data for the CNN. A LiDAR derived CHM was used to digitize the individual tree canopies to prepare their pixels for the species labelling for the CNN. The classification was executed separately on the RGB and the hyper-spectral data. The classification with the hyper-spectral data (0.73 – 0.90) yielded better classification results than the RGB classification (0.41 – 0.88). All code and data to ensure reproducibility can be found online. 

**Weinstein – Marconi – Bohlman – Zare – White 2019** proposed a semi-supervised CNN workflow based on the comparision of 3 unsupervised tree-crown segmentation algorithms. The result of the chosen tree crown segmentation (clustering of a CHM by tree height and crown width) of the LiDAR data was extracted as a bounding box from the RGB image, which dataset is then labeled self-supervised pretrained by a retinanet CNN. Then the CNN was retrained with a small hand-annotated dataset (supervised classificiation), to correct errors from the intitial un-supervised segmentation, which indeed improved the results of the prediction. 

**Weinstein – Marconi – Bohlman – Zare – White 2020**+ build on the results from Weinstein – Marconi – Bohlman – Zare – White 2019 and tested if training datasets can be generalized and be used on completely different forested areas. Generally the performance of the model performance decreased, but when they were applied to spatially and spectrally similar forested areas the performance increased. Best was again, when the CNN was retrained by a handful of hand-annotated data from the same area.

# **III. A reproducible workflow for the semi-automatic detection of ATEs** 

As accentuated before, many studies have used proprietary software (or did not specify the software) and thus the results are not reproducible, expect for Fricker – Ventura – Wolf – North – Davis – Franklin 2019 who share data and code. If reproducibility is not given, then the respective workflows are only locally applicable. The use of open source software, open access test data sets and transparent workflows enable researchers to achieve accessible workflows which can be applied globally (with regionally and locally relevant drivers/factors/predictors) to achieve comparable results.

Thus in this methodological paper we propose a reproducible workflow to semi-automatically classify any ATE, executed and created with the open-source scripting software R, relying on concepts and methodologies addressed earlier and based on three R packages (LEGION, CENITH, IKARUS), developed (by Andreas Schönberg) during the seminar course “Baumgrenzen der Welt” at the University of Marburg in the Summer Semester 2020. Similarly to several discussed studies the pixel-based approach is applied along with the GeOBIA approach to arrive to a validated classification of an ATE in a chosen remote sensing scene, meaning the classification of trees and other entities (etc. shrubs, grass, stones). The two different methods feature two different workflows which use two different data sets (Multispectral Images vs. LiDAR data) of the same remote sensing scene. If both data set types are present, the result of the GeOBIA approach is used to verify the classification approach, which can be then processed further using patch-metrics either in FRAGSTATS or R (the lanscapemetrics package). Otherwise the two approaches/workflows can be used separately.

### **III.1 Description of the research area and the data sets used in the case study**
The workflow is presented on a case study area in Vorarlberg, Alps...

![Figure 5. The case study area Vorarlberg (further ROI) with the four training areas](/home/keltoskytoi/ATE_detection/images_Rmd/Figure_5.png)

### **III.2 The reproducible workflow**

The reproducible workflow is contained in the files: 00_library_n_prep.R, 
0_set_up_working_envrnmnt.R, 1_data_prep_general.R, 2_segmentation_area_1.R, 
3_segmentation_validation_ROI.R, 4_data_prep_classification_area_1.R, 
5_classification_validation_area_1.R and 6_data_prep_classification_ROI.R.

These R files contain the whole selection process of the best suitable variables.
This .Rmd only present the best suitable variables, with references to the respective .R files. 

To reproduce the results of the whole project you can do that by running the code in the .R files, numbered sequentially. 
00_ is the library file, you do not have to run it. 0_ is going to set up the project folder structure on your computer/laptop by adapting the path of the project directory to your computer/laptop. 

Then you have to download the data from Google Drive in the respective folders 
dsm/, dem/, RGB_IR/, RGB_IR/, treepos/, train/ and you have to put the data to the respective folders of the folder structure you just created on your computer. 

The workflow consist of to main workflows: the pixel-based image classification 
and the Object Based Image Analysis which will be combined at the end. 
First the values of the variables to be used were elaborated/tested on test area 
1 and then applied to the ROI. Thus you will first work with test area 1 and then 
apply the result on the ROI. Also only the successful result wil be used in this 
.Rmd. You can learn about the testing sequence by checking it in the respective .R files.

Flowchart of the workflow

## **III.2.1 Data preparation (.R file: 1_data_prep_general.R)**

Originally masks for each 4 test area were created in QGIS and based on them the 
chm and the RGB and IR imagery was cropped to the size of the test area masks. When it was found that the minimal computable raster size (restrictions of the 
'raster' package) was a lot smaller and the maximum size of the actual ROI. When the maximal size of the ROI was determined (_ROI files), the sizes of the test areas were defined by using the 'Clip raster by Extent' tool, with 'use map canvas setting' in QGIS, to 4 approximately 32 x 32 m test areas. 
Then the respective chm test areas were used as masks or extents to clip the 
respective RGB and IR test areas in QGIS. 

First set up the folder structure on you computer/laptop. 



Then read the dem and the dsm of the case study area (ROI) and create the 
chm (canopy height model) for the ROI by subtracting the dem from the dsm! Following that check the position and the properties of the chm you just created and rename the layer. Then save the chm and read it in again to check it's crs.


```r
library(sp)
library(raster)
library(mapview)

dem <- raster(paste0(path_dem, lsdem))
dsm <- raster(paste0(path_dsm, lsdsm))
#create chm
chm <- dsm-dem 
#rename layer
names(chm) <-"chm_ROI"
#check crs 
crs(chm)
```

```
## CRS arguments:
##  +proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel
## +units=m +no_defs
```

```r
#plot raster
mapview(chm)
```

```
## TypeError: Attempting to change the setter of an unconfigurable property.
## TypeError: Attempting to change the setter of an unconfigurable property.
```

![plot of chunk create chm](figure/create chm-1.png)

```r
#write out the chm of the ROI####
writeRaster(chm, paste0(path_chm, "chm_ROI.tif"), 
            format="GTiff", overwrite=TRUE)
#read chm you just wrote out
chm <- raster("/home/keltoskytoi/ATE_detection/detect_ATE/chm/chm_ROI.tif")
#check crs
crs(chm)
```

```
## CRS arguments:
##  +proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel
## +units=m +no_defs
```

## **III.2.2 Segmentation of test area 1 (.R file: 2_segmentation_area_1.R)**

The aim is to find an accurate segmentation for test area 1 which can be tested 
on the other areas and then applied to the ROI.

The first task is to set verification points - tree positions for chm_1. The 
minimum height of a tree has to be decided (which of course differs from region 
to region). Here, in the Alpine region we also have shrubs, Krummholz, which has 
to be distinguished from trees. If you also want to consider the young trees, 
then you have to check what the highest point of the shrubs is and then set a 
height for the trees above the highest shrubs. If you only care about the grown 
trees, then still you have to check the chm in QGIS and decide on the basis of 
that about the minimum height of a tree and stick to it. The best is if you 
classify the chm in QGIS based on the tree heights and check with the RGB/IR 
imagery where the shrubs 'finish' and the trees 'start'. 

Fist load the data


```r
library(sp)
library(raster)
library(mapview)
#make the plot show more than the minimum of rows
options(max.print=10000)

#load the chms of test area 1
chm_1 <- raster(paste0(path_chm, lschm[[1]]))
crs(chm_1)
```

```
## CRS arguments:
##  +proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel
## +units=m +no_defs
```

```r
#load the verification points of test chm_1!
vp_1 <- rgdal::readOGR(paste0(path_treepos, "treepos_1.shp"))
```

```
## OGR data source with driver: ESRI Shapefile 
## Source: "/home/keltoskytoi/ATE_detection/detect_ATE/treepos/treepos_1.shp", layer: "treepos_1"
## with 15 features
## It has 1 fields
## Integer64 fields read as strings:  id
```

```r
#check the projection of vp_1 respective to chm_1:
crs(vp_1)
```

```
## CRS arguments:
##  +proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel
## +towgs84=577.326,90.129,463.919,5.137,1.474,5.297,2.4232 +units=m +no_defs
```

```r
crs(chm_1)
```

```
## CRS arguments:
##  +proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel
## +units=m +no_defs
```

```r
#transform the projection of vp_1 to that of chm_1
vp_1 <- spTransform(vp_1, crs(chm_1))
crs(vp_1)
```

```
## CRS arguments:
##  +proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel
## +units=m +no_defs
```

```r
#plot chm_1 and vp_1
mapview(chm_1) + vp_1
```

```
## TypeError: Attempting to change the setter of an unconfigurable property.
## TypeError: Attempting to change the setter of an unconfigurable property.
```

![plot of chunk segment chm_1](figure/segment chm_1-1.png)

Based on the classification of the chm in QGIS it was decided for chm_1, that 
h = 4 is a good height to get the lowest young trees but not to get involved 
with the shrubs and Krummholz. 

With the function *TreeSeg* it is possible to find the minimal and maximal values 
for a, b (horizontal and vertical values x, y in meters) and h (height in meters) based on the chm (and vp - verification points/tree positions). This means it is possible test various settings beforehand (having many sequences in *BestSegVal* can make the calculation time long and if one wants to compare what the different variables do, it is easier to test it without sequences) and then inspect the results in QGIS. 
It can be tested if there is a need to use a (sum) filtered chm (see the difference between test_0 and test_1) or how big or small the variable a, b and MIN have to be set. Based on the fact that there are 15 trees in test area 1 we can estimate how accurate the segments might be. Taking a look at test 1, 2 & 3 we can see how the reduction of a and b elevated the number of trees. 

Thus we can move on to function of *BestSegVal*, which works with value sequences for all variables and takes also the tree positions (vp) in account. 
In the first run we test the following values: 
**a=seq(0.05, 0.1, 0.01), b=seq(0.05, 0.1, 0.01), h=seq(3.5, 6, 0.5), MIN=seq(0.1, 0.5, 0.1)**, to go a bit lover and above the actual height of the trees and to determine the best a, b and MIN values. CHMfilter is lets at 3, because we want to do only minimal filtering to close the gaps. 
In the first run we got 1080 results and 44 maxmial segments. Because there are 15 trees in test area 1, the tibble was filtered to 20 segments and arranged according to the best hitrate (which was 0.733333) and still gave 668 results.
Then the results were filter for a hitrate >= 0.7 and height <= 4.0. This resulted in 40 observations, from which the first 4 were calculated with *TreeSeg* and comapred in QGIS. There was only minimal difference between test_vp0 and test_vp1, based on the difference of 0.5 m. It became clear that MIN has to be set to 0.1.  
Thus in the second run the following variables were set to a fix value or resp. to the same sequence: **MIN=0.1, filter=3, h=seq(3.5, 6, 0.5) ** and a and b were tested for a sequence between 0.01 and 0.1 with 0.01 steps, to find better segment sizes. The filtering of the second run resulted in the same six results, so only the second run will be diplayed here. You can trace all steps in the respective .R files.


```r
library(sp)
library(raster)
library(mapview)
library(CENITH)
library(rgdal)
#make the plot show more than the minimum of rows
options(max.print=10000)

#load the chms of test area 1
chm_1 <- raster(paste0(path_chm, lschm[[1]]))
crs(chm_1)
```

```
## CRS arguments:
##  +proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel
## +units=m +no_defs
```

```r
#load the verification points of test chm_1!
vp_1 <- rgdal::readOGR(paste0(path_treepos, "treepos_1.shp"))
```

```
## OGR data source with driver: ESRI Shapefile 
## Source: "/home/keltoskytoi/ATE_detection/detect_ATE/treepos/treepos_1.shp", layer: "treepos_1"
## with 15 features
## It has 1 fields
## Integer64 fields read as strings:  id
```

```r
#check the projection of vp_1 respective to chm_1:
crs(vp_1)
```

```
## CRS arguments:
##  +proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel
## +towgs84=577.326,90.129,463.919,5.137,1.474,5.297,2.4232 +units=m +no_defs
```

```r
crs(chm_1)
```

```
## CRS arguments:
##  +proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel
## +units=m +no_defs
```

```r
#transform the projection of vp_1 to that of chm_1
vp_1 <- spTransform(vp_1, crs(chm_1))
crs(vp_1)
```

```
## CRS arguments:
##  +proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel
## +units=m +no_defs
```

```r
#test settings for TreeSeg
#test_0 <- TreeSeg(chm_1, a=0.1, b=0.2, h=4.5, MIN=1)
#11 trees remaining
#writeOGR(obj=test_0, dsn="segm", layer="chm1_test_0", driver="ESRI Shapefile",
#         overwrite = TRUE)

#test_1 <- TreeSeg(chm_1, a=0.1, b=0.2, h=4.5, MIN=1, CHMfilter = 3)
#11 trees remaining
#writeOGR(obj=test_1, dsn="segm", layer="chm1_test_1", driver="ESRI Shapefile",
#         overwrite = TRUE)

#test_2 <- TreeSeg(chm_1, a=0.1, b=0.1, h=4.5, MIN=1, CHMfilter = 3)
#13 trees remaining
#writeOGR(obj=test_2, dsn="segm", layer="chm1_test_2", driver="ESRI Shapefile",
#         overwrite = TRUE)

#test_3 <- TreeSeg(chm_1, a=0.05, b=0.05, h=4.5, MIN=1, CHMfilter = 3)
#39 trees remaining
#writeOGR(obj=test_3, dsn="segm", layer="chm1_test_3", driver="ESRI Shapefile",
#         overwrite = TRUE)

#lines 289 to 317 are commented out if not the knitting takes ages
#best_seg_vp_1_v2 <-BestSegVal(chm=chm_1, a=seq(0.01, 0.1, 0.01), b=seq(0.01, 0.1, 0.01), 
#                              h=seq(3.5, 6, 0.5), MIN=0.1, filter=3, 
#                              vp=vp_1, skipCheck = TRUE)
#write.csv(best_seg_vp_1_v2, file.path(path_segm, "best_seg_vp_1_v2.csv"))
#best_seg_vp_1_v2 <- read.csv(file.path(path_segm, "best_seg_vp_1_v2.csv"), header = TRUE, sep=",")
#head(best_seg_vp_1_v2)

#let's transform the data table as a tibble####
#best_seg_vp_1_v2 <- as_tibble(best_seg_vp_1_v2)

#we have 15 trees/treepoints/vps, so let's filter the dataset to those results #
#which have 20 segments
#best_seg_vp_1_v2 <- best_seg_vp_1_v2 %>%
#  select(2:15)%>%
#  arrange(total_seg)%>%
#  filter(total_seg<=20)%>%
#  arrange(desc(hitrate))

#head(best_seg_vp_1_v2)

#we get only 668 and we can see that the best hitrate is 0.7333333, so let's 
#look for the highest hitrates, order it according to the most total segments 
#and filter for up to 4 m height
#best_seg_vp_1_v2_filt <- best_seg_vp_1_v2 %>% 
#  filter(hitrate >= 0.7)%>%
#  arrange(desc(total_seg))%>%
#  filter(height <= 4.0)

#best_seg_vp_1_v2_filt
# A tibble: 8 x 14
#      a     b height total_seg hit.vp  under  over  area hitrate underrate overrate Seg_qualy     MIN chm    
#  <dbl> <dbl>  <dbl>     <int> <chr>   <int> <int> <dbl>   <dbl>     <dbl>    <dbl> <chr>       <dbl> <chr>  
#1  0.07  0.07    3.5        20 11 / 15     2     7  538.   0.733     0.1      0.35  0.73 @ 0.28   0.1 CHM_1_3
#2  0.07  0.08    3.5        20 11 / 15     2     7  538.   0.733     0.1      0.35  0.73 @ 0.28   0.1 CHM_1_3
#3  0.07  0.09    3.5        20 11 / 15     2     7  538.   0.733     0.1      0.35  0.73 @ 0.28   0.1 CHM_1_3
#4  0.07  0.07    4          20 11 / 15     2     7  530.   0.733     0.1      0.35  0.73 @ 0.28   0.1 CHM_1_3
#5  0.07  0.08    4          20 11 / 15     2     7  530.   0.733     0.1      0.35  0.73 @ 0.28   0.1 CHM_1_3
#6  0.07  0.09    4          20 11 / 15     2     7  530.   0.733     0.1      0.35  0.73 @ 0.28   0.1 CHM_1_3
#7  0.07  0.1     3.5        19 11 / 15     2     6  538.   0.733     0.105    0.316 0.73 @ 0.26   0.1 CHM_1_3
#8  0.07  0.1     4          19 11 / 15     2     6  530.   0.733     0.105    0.316 0.73 @ 0.26   0.1 CHM_1_3
```
##  **III.2.3 Crossvalidation of test areas and Segmentation of ROI (.R file:                           3_segmentation_validation_area_1_ROI.R)**


```r
library(sp)
library(raster)
library(mapview)
library(CENITH)
library(rgdal)
#make the plot show more than the minimum of rows
options(max.print=10000)

#check lschm
lschm
```

```
## [1] "chm_1.tif"         "chm_1.tif.aux.xml" "chm_2.tif"         "chm_2.tif.aux.xml"
## [5] "chm_3.tif"         "chm_3.tif.aux.xml" "chm_4.tif"         "chm_4.tif.aux.xml"
## [9] "chm_ROI.tif"
```

```r
#[1] "chm_1.tif"         "chm_1.tif.aux.xml" "chm_2.tif"         "chm_2.tif.aux.xml" "chm_3.tif"        
#[6] "chm_3.tif.aux.xml" "chm_4.tif"         "chm_4.tif.aux.xml" "chm_ROI.tif"  

                                  ####LOAD THE CHMS#### 
chm_1 <- raster(paste0(path_chm, lschm[[1]]))
crs(chm_1)
```

```
## CRS arguments:
##  +proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel
## +units=m +no_defs
```

```r
#+proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel +units=m +no_defs
chm_2 <- raster(paste0(path_chm, lschm[[3]]))
crs(chm_2)
```

```
## CRS arguments:
##  +proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel
## +units=m +no_defs
```

```r
chm_3 <- raster(paste0(path_chm, lschm[[5]]))
crs(chm_3)
```

```
## CRS arguments:
##  +proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel
## +units=m +no_defs
```

```r
chm_4 <- raster(paste0(path_chm, lschm[[7]]))
crs(chm_4)
```

```
## CRS arguments:
##  +proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel
## +units=m +no_defs
```

```r
CHM <- raster(paste0(path_chm, lschm[[9]]))
crs(CHM)
```

```
## CRS arguments:
##  +proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel
## +units=m +no_defs
```

```r
                        ####LOAD VERIFICATION POINTS####
#vp_1####
vp_1 <- rgdal::readOGR(paste0(path_treepos, "treepos_1.shp"))
```

```
## OGR data source with driver: ESRI Shapefile 
## Source: "/home/keltoskytoi/ATE_detection/detect_ATE/treepos/treepos_1.shp", layer: "treepos_1"
## with 15 features
## It has 1 fields
## Integer64 fields read as strings:  id
```

```r
crs(vp_1)
```

```
## CRS arguments:
##  +proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel
## +towgs84=577.326,90.129,463.919,5.137,1.474,5.297,2.4232 +units=m +no_defs
```

```r
#+proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel +towgs84=577.326,90.129,463.919,5.137,1.474,5.297,2.4232
#+units=m +no_defs
crs(chm_1)
```

```
## CRS arguments:
##  +proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel
## +units=m +no_defs
```

```r
#transform the projection of vp_1
vp_1 <- spTransform(vp_1, crs(chm_1))
crs(vp_1)
```

```
## CRS arguments:
##  +proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel
## +units=m +no_defs
```

```r
#+proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel +units=m +no_defs

#vp_2####
vp_2 <- rgdal::readOGR(paste0(path_treepos, "treepos_2.shp"))
```

```
## OGR data source with driver: ESRI Shapefile 
## Source: "/home/keltoskytoi/ATE_detection/detect_ATE/treepos/treepos_2.shp", layer: "treepos_2"
## with 12 features
## It has 1 fields
## Integer64 fields read as strings:  id
```

```r
crs(vp_2)
```

```
## CRS arguments:
##  +proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel
## +towgs84=577.326,90.129,463.919,5.137,1.474,5.297,2.4232 +units=m +no_defs
```

```r
crs(chm_2)
```

```
## CRS arguments:
##  +proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel
## +units=m +no_defs
```

```r
#transform the projection of vp_1
vp_2 <- spTransform(vp_2, crs(chm_1))
crs(vp_2)
```

```
## CRS arguments:
##  +proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel
## +units=m +no_defs
```

```r
#vp_3####
vp_3 <- rgdal::readOGR(paste0(path_treepos, "treepos_3.shp"))
```

```
## OGR data source with driver: ESRI Shapefile 
## Source: "/home/keltoskytoi/ATE_detection/detect_ATE/treepos/treepos_3.shp", layer: "treepos_3"
## with 18 features
## It has 1 fields
## Integer64 fields read as strings:  id
```

```r
crs(vp_3)
```

```
## CRS arguments:
##  +proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel
## +towgs84=577.326,90.129,463.919,5.137,1.474,5.297,2.4232 +units=m +no_defs
```

```r
crs(chm_3)
```

```
## CRS arguments:
##  +proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel
## +units=m +no_defs
```

```r
#transform the projection of vp_1
vp_3 <- spTransform(vp_3, crs(chm_1))
crs(vp_3)
```

```
## CRS arguments:
##  +proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel
## +units=m +no_defs
```

```r
#vp_4####
vp_4 <- rgdal::readOGR(paste0(path_treepos, "treepos_4.shp"))
```

```
## OGR data source with driver: ESRI Shapefile 
## Source: "/home/keltoskytoi/ATE_detection/detect_ATE/treepos/treepos_4.shp", layer: "treepos_4"
## with 12 features
## It has 1 fields
## Integer64 fields read as strings:  id
```

```r
crs(vp_4)
```

```
## CRS arguments:
##  +proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel
## +towgs84=577.326,90.129,463.919,5.137,1.474,5.297,2.4232 +units=m +no_defs
```

```r
crs(chm_4)
```

```
## CRS arguments:
##  +proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel
## +units=m +no_defs
```

```r
#transform the projection of vp_1
vp_4 <- spTransform(vp_4, crs(chm_1))
crs(vp_4)
```

```
## CRS arguments:
##  +proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel
## +units=m +no_defs
```

```r
              ####PREPARATION FOR THE CROSSVALIDATION####

hmlist <- list(chm_1, chm_2, chm_3, chm_4)
vplist <- list(vp_1, vp_2, vp_3, vp_4)

#test all 8 result from bestsegval
```
