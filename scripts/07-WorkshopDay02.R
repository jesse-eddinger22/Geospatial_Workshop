# Geo spatial Carpentry Workshop Day 2
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

# Read in the polygon of our field site
aoi_boundary_HARV <- st_read('data/GeospatialWorkshopData/vector/HarClip_UTMZ18.shp')

# what type is this object
st_geometry_type(aoi_boundary_HARV)

# Let's look at what the crs is 
st_crs(aoi_boundary_HARV)$proj4string

# What is the extent
st_bbox(aoi_boundary_HARV)

# Plot the shape of the field site
ggplot() +
  geom_sf(data = aoi_boundary_HARV, size=3, color='black', 
          fill='cyan1') +
  ggtitle('AOI Boundary Plot') + 
  coord_sf()






