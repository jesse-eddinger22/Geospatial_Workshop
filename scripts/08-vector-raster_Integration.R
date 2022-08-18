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

# load CHM
CHM_HARV <- raster('data/GeospatialWorkshopData/raster/HARV_chmCrop.tif')

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

# Export plot location as a shapefile
st_write(plot_locations_sp_HARV, 'data/PlotLocations_HARV.shp', driver = "ESRI Shapefile")

# Plot chm and aoi boundary
CHM_HARV_df <- as.data.frame(CHM_HARV, xy=T)

ggplot()+
  geom_raster(data=CHM_HARV_df, aes(x=x,y=y, fill=HARV_chmCrop)) +
  geom_sf(data=aoi_boundary_HARV, color='red', fill=NA)+
  coord_sf()

# crop CHM to aoi boundary
CHM_HARV_cropped <- crop(x=CHM_HARV,y=aoi_boundary_HARV)

# convert cropped chm to df
CHM_HARV_cropped_df <- as.data.frame(CHM_HARV_cropped, xy=T)

names(CHM_HARV_cropped_df)

ggplot()+
  geom_raster(data=CHM_HARV_cropped_df, aes(x=x,y=y,fill=HARV_chmCrop)) +
  scale_fill_gradientn(colors=terrain.colors(10)) +
  coord_quickmap()

# challenge - cropping
plot_locations_sp_HARV

# Crop
CHM_plotloc_HARVcrop <- crop(x = CHM_HARV, y = plot_locations_sp_HARV)

# plot cropped CHM and plot locations
CHM_plotloc_HARVcrop_df <- as.data.frame(CHM_plotloc_HARVcrop, xy = TRUE)

ggplot() + 
  geom_raster(data = CHM_plotloc_HARVcrop_df, aes(x = x, y = y, fill = HARV_chmCrop)) + 
  scale_fill_gradientn(name = "Canopy Height", colors = terrain.colors(10)) + 
  geom_sf(data = plot_locations_sp_HARV) + 
  coord_sf()

# ------- Extracting ---------

# Extract CHM values within the AOI boundary
tree_height <- extract(x=CHM_HARV, y=aoi_boundary_HARV, df=T)
class(tree_height)

# look at whats in the df
str(tree_height)
#18450 observation, ID's and CHM cropped data

# Plot histogram of tree heights within the AOI boundary
ggplot() +
  geom_histogram(data = tree_height, aes(HARV_chmCrop))

# mean tree height within the AOI
mean(tree_height$HARV_chmCrop)

# use extract to calculate mean within AOI boundary
mean_tree_height_aoi <- extract(x=CHM_HARV, y=aoi_boundary_HARV, 
                                fun=mean)

mean_tree_height_aoi

# Challenge 

# Extract chm values for each plot
mean_tree_height_plots <- extract(x=CHM_HARV, y=plot_locations_sp_HARV, buffer=20,fun=mean, df=TRUE)

mean_tree_height_plots

# plot
ggplot() +
  geom_col(data=mean_tree_height_plots, aes(ID,HARV_chmCrop))












