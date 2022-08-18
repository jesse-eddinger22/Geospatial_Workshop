# Geo spatial Carpentry Workshop
# Jesse Eddinger
# jeddinger@wisc.edu
# 8/17/2022

# ------------- Load Packages -----------------
library(raster) # for working with raster data
library(rgdal) # for working with 
library(ggplot2) # making them good good plots
library(dplyr) # making data easy to work with
library(rasterVis) # visualization with raster data
library(sf)# honestly I don't know what this does
library(gridExtra)

# Inspect the data before we load it
GDALinfo('data/GeospatialWorkshopData/raster/HARV_dsmCrop.tif')

# Save the DSMcrop metadata to an object
HARV_dsmcrop_info <- capture.output(GDALinfo('data/GeospatialWorkshopData/raster/HARV_dsmCrop.tif'))
HARV_dsmcrop_info

# Load in Raster TIF 
DSM_HARV <- raster('data/GeospatialWorkshopData/raster/HARV_dsmCrop.tif')
DSM_HARV

# Summarize the raster object
summary(DSM_HARV)

# Summarize with total number of pixel
summary(DSM_HARV, maxsamp = ncell(DSM_HARV))

# make raster into a data frame 
DSM_HARV_df <- as.data.frame(DSM_HARV, xy=TRUE)

# Look at the new data frame
str(DSM_HARV_df)
head(DSM_HARV_df)

# Let's plot the raster
ggplot() +
  geom_raster(data=DSM_HARV_df, aes(x = x, y = y, fill = HARV_dsmCrop)) +
  scale_fill_viridis_c() +
  coord_quickmap()
# need other projections?
# try : 
# ?coord_map


# Updated way to describe a CRS                
crs(DSM_HARV)

# Min/Max values
minValue(DSM_HARV)
maxValue(DSM_HARV)

# Save them back to the metadata, but they were already set
# but lets do it for practice 
DSM_HARV <- setMinMax(DSM_HARV)

# Lets look at layers
nlayers(DSM_HARV)
# 1 layer for this data set

# Inspect geotif and see missing data
# type of missing data should match 
# (decimal data, missing should be in decimal form)
HARV_dsmcrop_info

# Plot histogram of DSM Values
ggplot() +
  geom_histogram(data = DSM_HARV_df, aes(x = HARV_dsmCrop))

# Challenge 1 
# Use GDALinfo() to determine the following from DSMhill:
# Same CRS as DSM_HARV? 
#   yes, '+proj=utm +zone=18 +datum=WGS84 +units=m +no_defs'
# What is the NoDataValue?
#   -3.4e+38
# What is the resolution?
#   1 m x 1 m 
# How large would a 5x5 area be on the Earth surface?
#   It would be 5 meters by 5 meters 
# Is the file a multi- or single band?
#   Single Band

GDALinfo('data/GeospatialWorkshopData/raster/HARV_DSMhill.tif')

# Split dsm in to 3 mostly equal bins
DSM_HARV_df <- DSM_HARV_df %>% mutate(fct_elevation = cut(
  HARV_dsmCrop, breaks = 3)
)
head(DSM_HARV_df) # added a variable 
unique(DSM_HARV_df$fct_elevation)

# Lets plot it, so we can see low, medium, and high 
ggplot() +
  geom_bar(data = DSM_HARV_df, aes(x=fct_elevation))

# Let's use dplyr in a different way
DSM_HARV_df %>% count(fct_elevation)

# Let's make custom bins
# We're giving 4 start/stop, but that equates to 3 bins
custom_bins <- c(300, 350, 400, 450)

# assign back to df using our custom bins, or you can assign the bins manually (say breaks = 6)
DSM_HARV_df <- DSM_HARV_df %>% 
  mutate(fct_elevation_2 = cut(HARV_dsmCrop, breaks = custom_bins))
head(DSM_HARV_df)

ggplot() + 
  geom_bar(data = DSM_HARV_df, aes(x = fct_elevation_2))

DSM_HARV_df %>% count(fct_elevation_2)

# Let's plot it as a raster instead of a barplot
ggplot() +
  geom_raster(data = DSM_HARV_df, aes(x = x, y = y, fill = fct_elevation_2)) +
  coord_quickmap()

# Cool, but let's customize this so that its useful and readable

my_col <- terrain.colors(3)
ggplot() +
  geom_raster(data = DSM_HARV_df, aes(x = x, y = y, fill = fct_elevation_2)) +
  coord_quickmap() + 
  scale_fill_manual(values = my_col, name = 'Elevation') +
  xlab('UTM Easting (m)') +
  ylab('UTM Northing (m)')

# Challenge 
# Create a plot of the Harvard Forest Digital Surface Model (DSM) that has:
# Six classified ranges of values (break points) that are evenly divided among the range of pixel values.
# Axis labels.
# A plot title.

# Create 6 breaks

DSM_HARV_df <- DSM_HARV_df  %>%
  mutate(fct_elevation_6 = cut(HARV_dsmCrop, breaks = 6)) 

my_col2 <- terrain.colors(6)

ggplot() +
  geom_raster(data = DSM_HARV_df , aes(x = x, y = y,
                                       fill = fct_elevation_6)) + 
  scale_fill_manual(values = my_col2, name = "Elevation") + 
  ggtitle("Classified Elevation Map - NEON Harvard Forest Field Site") +
  xlab("UTM Easting Coordinate (m)") +
  ylab("UTM Northing Coordinate (m)") + 
  coord_quickmap()

# Layer 2 rasters

# Import and layer hillshade on the DSM because we love hillshade

# Import
DSM_HILL_HARV <- raster('data/GeospatialWorkshopData/raster/HARV_DSMhill.tif')

# Look at meta
DSM_HILL_HARV

# Convert this to a data frame
DSM_HILL_HARV_df <- as.data.frame(DSM_HILL_HARV, xy = TRUE)
head(DSM_HILL_HARV_df)

# Let's look at hill shade by itself
ggplot() + 
  geom_raster(data = DSM_HILL_HARV_df, aes(x=x, y=y, alpha = HARV_DSMhill)) + 
  scale_alpha(range = c(0.15, 0.65), guide = 'none') + 
  coord_quickmap()

# Plot DSM with Hill shade, just add another geom_raster
ggplot() +
  geom_raster(data = DSM_HARV_df , 
              aes(x = x, y = y, 
                  fill = HARV_dsmCrop)) + 
  geom_raster(data = DSM_HILL_HARV_df, 
              aes(x = x, y = y, 
                  alpha = HARV_DSMhill)) +  
  scale_fill_viridis_c() +  
  scale_alpha(range = c(0.15, 0.65), guide = "none") +  
  ggtitle("Elevation with hillshade") +
  coord_quickmap()

# Challenge for SJER
# CREATE DTM MAP
# import DTM
# CREATE DTM MAP
# import DTM
DTM_SJER <- raster("data/GeospatialWorkshopData/raster/SJER_dtmCrop.tif")
DTM_SJER_df <- as.data.frame(DTM_SJER, xy = TRUE)

# DTM Hillshade
DTM_hill_SJER <- raster("data/GeospatialWorkshopData/raster/SJER_dtmHill.tif")
DTM_hill_SJER_df <- as.data.frame(DTM_hill_SJER, xy = TRUE)

ggplot() +
  geom_raster(data = DTM_SJER_df ,
              aes(x = x, y = y,
                  fill = SJER_dtmCrop,
                  alpha = 2.0)
  ) +
  geom_raster(data = DTM_hill_SJER_df,
              aes(x = x, y = y,
                  alpha = SJER_dtmHill)
  ) +
  scale_fill_viridis_c() +
  guides(fill = guide_colorbar()) +
  scale_alpha(range = c(0.4, 0.7), guide = "none") +
  theme_bw() +
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank()) +
  theme(axis.title.x = element_blank(),
        axis.title.y = element_blank()) +
  ggtitle("DTM with Hillshade") +
  coord_quickmap()

# ------- PROJECTIONS ---------
# read in dsm data set
DSM_HARV <- raster('data/GeospatialWorkshopData/raster/HARV_dsmCrop.tif')
DSM_HILL_HARV <- raster('data/GeospatialWorkshopData/raster/HARV_DSMhill.tif')

# load dtm for harvard
DTM_HARV <- raster('data/GeospatialWorkshopData/raster/HARV_dtmCrop.tif')
DTM_hill_HARV <- raster('data/GeospatialWorkshopData/raster/HARV_DTMhill_WGS84.tif')

# look at CRS information, use @projargs to look at important info
crs(DTM_HARV)@projargs
crs(DTM_hill_HARV)@projargs

# We don't have projection for hill data

# Project hill shade raster to DTM raster
DTM_hill_HARV_UTM <- projectRaster(DTM_hill_HARV, crs=crs(DTM_HARV))

# lets look at the new df
crs(DTM_hill_HARV_UTM)@projargs

# Sweet, now we have matching projections
# Let's look at the resolution
res(DTM_HARV)
res(DTM_hill_HARV)
res(DTM_hill_HARV_UTM)

# Fixed projection UTM is close to DTM_HARV, did its best but it isn't perfectly in line
# Let's reproject and set the resolution so they match

DTM_hill_HARV_UTM <- projectRaster(DTM_hill_HARV, crs=crs(DTM_HARV), res=res(DTM_HARV))

# Challenge 
# do that for SJER data

# Load data
DSM_SJER <- raster('data/GeospatialWorkshopData/raster/SJER_dsmCrop.tif')
DSM_hill_SJER <- raster('data/GeospatialWorkshopData/raster/SJER_DSMhill_WGS84.tif')

crs(DSM_SJER)@projargs
crs(DSM_hill_SJER)@projargs

# correct projections
DSM_hill_SJER_UTM <- projectRaster(DSM_hill_SJER, crs=crs(DSM_SJER),res=1)

# lets look at the new df
crs(DSM_hill_SJER_UTM)@projargs

# Sweet, now we have matching projections
# Let's look at the resolution
res(DSM_SJER)
res(DSM_hill_SJER)
res(DSM_hill_SJER_UTM)


# Fixed projection UTM is close to DTM_HARV, did its best but it isn't perfectly in line
# Let's reproject and set the resolution so they match

DSM_hill_SJER_UTM <- projectRaster(DSM_hill_SJER, crs=crs(DSM_SJER), res=res(DSM_SJER))

crs(DSM_hill_SJER_UTM)@projargs

# Question from group about if it converts certain data 
DSM_hill_SJER_UTM_df <- as.data.frame(DSM_hill_SJER_UTM, xy = TRUE)
head(DSM_hill_SJER_UTM_df)

DSM_SJER_df <- as.data.frame(DSM_SJER, xy = T)
head(DSM_SJER_df)

# Lets do some raster math!
# First way: Subtraction with R
# Subtract DTM from DSM
# This makes new object called CHM
CHM_HARV <- DSM_HARV - DTM_HARV

# Let's plot
# convert to dataframe
CHM_HARV_df <- as.data.frame(CHM_HARV, xy = T)

# Plot
ggplot() +
  geom_raster(data = CHM_HARV_df, aes(x=x,y=y,fill=layer)) +
  scale_fill_gradientn(name="Canopy Height", colors=terrain.colors(10)) +
  coord_quickmap()

# Let's look at distribution of tree heights
# Since its a df, we can do all sorts of fun stats 
ggplot() +
  geom_histogram(data=CHM_HARV_df, aes(layer))
# distribution of canopy height data

# Let's do the second way 
# Use the overlay function to calculate CHM
CHM_ov_HARV <- overlay(DSM_HARV, DTM_HARV, fun=function(r1,r2){return(r1-r2)})

# convert to df 
CHM_ov_HARV_df <- as.data.frame(CHM_ov_HARV)

# We need to be able to write out all of this data
# let's export to a geotiff

writeRaster(CHM_ov_HARV, 'CHM_HARV.tiff',
            format='GTiff',overwrite=T,
            NAflag = -9999)

# writing other file formats (use f1 key when cursor is over function for quick ?)

# Challenge 

# Subtract
CHM_SJER <- DSM_SJER - DTM_SJER

# df
CHM_SJER_df <- as.data.frame(CHM_SJER, xy = T)

# Plot SJER
plot_SJER <- ggplot() +
  geom_raster(data = CHM_SJER_df, aes(x=x,y=y,fill=layer)) +
  scale_fill_gradientn(name="Canopy Height", colors=terrain.colors(10)) +
  coord_quickmap()

# Plot HARV
plot_HARV <- ggplot() +
  geom_raster(data = CHM_HARV_df, aes(x=x,y=y,fill=layer)) +
  scale_fill_gradientn(name="Canopy Height", colors=terrain.colors(10)) +
  coord_quickmap()

grid.arrange(plot_HARV, plot_SJER)

# compare histogram for SJER
ggplot() +
  geom_histogram(data=CHM_SJER_df, aes(layer))

# write
writeRaster(CHM_SJER, 'CHM_SJER.tiff',
            format='GTiff',overwrite=T,
            NAflag = -9999)

# --------- MULTIBAND RASTERS -----------

# let's import one band of a multiband raster
RGB_band1_HARV <- raster('data/GeospatialWorkshopData/raster/HARV_RGB_Ortho.tif')

RGB_band1_HARV
extent(RGB_band1_HARV)

# import second band
RGB_band2_HARV <- raster('data/GeospatialWorkshopData/raster/HARV_RGB_Ortho.tif',band=2)
extent(RGB_band2_HARV)

res(RGB_band1_HARV)
res(RGB_band2_HARV)

# Let's plot
# convert to data frame

RGB_band1_HARV_df <- as.data.frame(RGB_band1_HARV, xy=T)
RGB_band2_HARV_df <- as.data.frame(RGB_band2_HARV, xy=T)

# plot
ggplot() +
  geom_raster(data=RGB_band1_HARV_df, aes(x=x,y=y,fill=HARV_RGB_Ortho)) +
  coord_quickmap()

ggplot() +
  geom_raster(data=RGB_band2_HARV_df, aes(x=x,y=y,fill=HARV_RGB_Ortho)) +
  coord_quickmap()

# Import all bands
RGB_stack_HARV <- stack('data/GeospatialWorkshopData/raster/HARV_RGB_Ortho.tif')
RGB_stack_HARV

# Info on each layer
RGB_stack_HARV@layers

# Info for one layer, double the square brackets 
RGB_stack_HARV[[2]]

# Plot RGB Data 
plotRGB(RGB_stack_HARV,r=1,g=2,b=3)

# stretch image
plotRGB(RGB_stack_HARV,r=1,g=2,b=3, stretch='hist',scale=800)


