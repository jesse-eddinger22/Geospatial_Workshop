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

str(aoi_boundary_HARV)
ncol(aoi_boundary_HARV) # 2 attributes
names(aoi_boundary_HARV)
head(aoi_boundary_HARV)

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
ncol(lines_HARV)
names(lines_HARV)
head(lines_HARV)

# type for point data
st_geometry_type(point_HARV) 
str(point_HARV)
ncol(point_HARV) # 15 attributes
names(point_HARV)# Owned by Harvard, Country is not part of this data set

# check ownership in a different way
point_HARV$Ownership

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

# Filter by type
lines_HARV$TYPE

# Let's plot only footpaths
lines_HARV %>% 
  filter(TYPE == 'footpath') %>% 
  nrow

# Plot
lines_HARV %>% 
  filter(TYPE == 'footpath') %>% 
  ggplot() +
  geom_sf(aes(color = factor(OBJECTID)), size = 1.5) +
  ggtitle('NEON Harvard Forest Field Site', subtitle = 'Footpaths') +
  coord_sf()
