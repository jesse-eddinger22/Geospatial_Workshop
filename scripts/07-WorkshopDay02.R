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

# Challenge 
# Load in the roads and tower shp files
lines_HARV <- st_read('data/GeospatialWorkshopData/vector/HARV_roads.shp')
point_HARV <- st_read('data/GeospatialWorkshopData/vector/HARVtower_UTM18N.shp')

# what type is this object
st_geometry_type(lines_HARV)
str(lines_HARV)

st_geometry_type(point_HARV)
str(point_HARV)

# Let's look at what the crs is 
st_crs(lines_HARV)$proj4string
st_crs(point_HARV)$proj4string

# What is the extent
st_bbox(lines_HARV)
st_bbox(point_HARV)

# Plot the shape of the field site for lines
ggplot() +
  geom_sf(data = lines_HARV, size=3, color='black', 
          fill='cyan1') +
  ggtitle('Lines Boundary Plot') + 
  coord_sf()

# Plot for Point
ggplot() +
  geom_sf(data = point_HARV, size=3, color='black', 
          fill='cyan1') +
  ggtitle('Point Boundary Plot') + 
  coord_sf()

