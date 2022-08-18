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

plot_locations_HARV$utmZone

# same utm as the harvard data
st_crs(point_HARV)$proj4string

# Save projection
utm18n <- st_crs(point_HARV)
class(utm18n)

# Convert data frame to spatial object
plot_locations_sp_HARV <- st_as_sf(plot_locations_HARV,
                                   coords = c('easting','northing'),
                                   crs = utm18n)
class(plot_locations_sp_HARV)
class(point_HARV)
# They match up

# plot our plot locations, add aoi boundary
ggplot() +
  geom_sf(data=aoi_boundary_HARV) +
  geom_sf(data=plot_locations_sp_HARV) +
  ggtitle('Map of Plot Locations')

# add some context though 
ggplot() +
  geom_sf(data=aoi_boundary_HARV) +
  geom_sf(data = lines_HARV) +
  geom_sf(data = point_HARV, shape = 15) +
  geom_sf(data=plot_locations_sp_HARV) +
  ggtitle('Map of Plot Locations')



