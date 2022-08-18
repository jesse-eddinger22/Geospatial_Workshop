# Geo spatial Carpentry Workshop Day 2 - Vector and Raster Integration 
# Jesse Eddinger
# jeddinger@wisc.edu
# 8/18/2022

# ------------- Load Packages -----------------
library(raster) # for working with raster data
library(rgdal) # for working with 
library(ggplot2) # making them good good plots
library(dplyr) # making data easy to work with
library(rasterVis) # visualization with raster data
library(sf) # loads rgdal (geospatial data abstraction library)
library(gridExtra) # This was just for comparing plots

# load in a new data 
aoi_boundary_HARV <- st_read('data/GeospatialWorkshopData/vector/HarClip_UTMZ18.shp')
lines_HARV <- st_read('data/GeospatialWorkshopData/vector/HARV_roads.shp')
point_HARV <- st_read('data/GeospatialWorkshopData/vector/HARVtower_UTM18N.shp')

# read in CSV
plot_locations_HARV <- read.csv("data/GeospatialWorkshopData/HARV_PlotLocations.csv")
str(plot_locations_HARV)












