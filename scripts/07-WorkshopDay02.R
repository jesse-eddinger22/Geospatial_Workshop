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

# Subest out all the boardwalk and stone wall and plot

# Boardwalk 
lines_HARV %>% 
  filter(TYPE == 'boardwalk') %>% 
  ggplot() +
  geom_sf(aes(color = factor(OBJECTID)), size = 1.5) +
  ggtitle('NEON Harvard Forest Field Site', subtitle = 'Boardwalk') +
  coord_sf()

# Stone Wall
lines_HARV %>% 
  filter(TYPE == 'stone wall') %>% 
  ggplot() +
  geom_sf(aes(color = factor(OBJECTID)), size = 1.5) +
  ggtitle('NEON Harvard Forest Field Site', subtitle = 'Stone Wall') +
  coord_sf()

# how many road types are there 
unique(lines_HARV$TYPE)

# make a plot using custom colors
road_colors <- c('brown', 'green', 'navy', 'purple')
line_widths <- c(0.5,1,1.5,2)

# Plot with the new colors
ggplot() +
  geom_sf(data = lines_HARV, aes(color = TYPE, size = TYPE)) +
  scale_color_manual(values = road_colors) +
  scale_size_manual(values = line_widths) +
  labs(color='Road Type', title = "NEON Harvard Forest Field Site",
       subtitle = "Roads and Trails", 
       size = 'Road Type') +
  coord_sf()

# Challenge 
# Create a plot that emphasizes only roads where bikes and horses are allowed

# plot
lines_show_HARV <- lines_HARV %>% filter(!is.na(BicyclesHo))

ggplot() +
  geom_sf(data=lines_HARV, size=1) +
  geom_sf(data = lines_show_HARV, color='magenta', size = 2) +
  labs(title = 'NEON Harvard Forest Field Site',
       subtitle = 'Roads Where Bikes and Horses are Allowed') +
  coord_sf()

# Challenge

# Load in data
state_boundaries <- st_read('data/GeospatialWorkshopData/vector/US-State-Boundaries-Census-2014.shp')

# check names
colnames(state_boundaries)

# plot
  ggplot() +
  geom_sf(data = state_boundaries, aes(fill=region), size = .05) +
  ggtitle('US State Boundaries') +
  coord_sf()

# plot with color
  ggplot() +
    geom_sf(data = state_boundaries, aes(color=region), size = 1) +
    ggtitle('US State Boundaries') +
    coord_sf()
# Let's plot all of the HARV Vector data together
  ?pch # add a certain shape, let's do shape 15 for the Tower 
  
  ggplot()+
    geom_sf(data = aoi_boundary_HARV, fill = 'gray', color = 'gray') +
    geom_sf(data = lines_HARV, aes(color = TYPE)) +
    geom_sf(data = point_HARV, aes(fill = Sub_Type), shape = 15) +
    labs(title = 'NEON Harvard Forest Field Site',
         fill = "Tower Location",
         color = 'Path Type') +
    coord_sf()

# add in raster data 
  CHM_HARV <- raster('data/GeospatialWorkshopData/raster/HARV_chmCrop.tif')
  CHM_HARV_df <- as.data.frame(CHM_HARV, xy=TRUE)
  
# Plot  
  ggplot()+
    geom_raster(data=CHM_HARV_df, aes(x = x, y = y, fill = HARV_chmCrop)) +
    geom_sf(data = aoi_boundary_HARV) +
    geom_sf(data = lines_HARV) +
    geom_sf(data = point_HARV, shape = 15) +
    labs(title = 'NEON Harvard Forest Field Site with Canopy Height',
         fill = "Tower Location",
         color = 'Path Type') +
    coord_sf()

# Mess around with plot colors and whatnot
  road_colors <- c('brown', 'green', 'navy', 'purple')
  line_widths <- c(1,2,3,4)
  
  
  ggplot() +
    geom_raster(data=CHM_HARV_df, aes(x = x, y = y, fill = HARV_chmCrop)) +
    scale_fill_gradientn(name="Canopy Height", colors=terrain.colors(10)) +
    geom_sf(data = aoi_boundary_HARV, fill = 'gray', color = 'gray') +
    geom_sf(data = lines_HARV, aes(color = TYPE)) +
    scale_color_manual(values = road_colors) +
    scale_size_manual(values = line_widths) +
    geom_sf(data = point_HARV, shape = 15) +
    labs(title = 'NEON Harvard Forest Field Site with Canopy Height',
         fill = "Tower Location",
         color = 'Path Type') +
    coord_sf(xlim=st_bbox(CHM_HARV)[c(1,3)],ylim = st_bbox(CHM_HARV)[c(2,4)], crs=st_crs(CHM_HARV))

  
