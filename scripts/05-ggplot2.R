# Using GGPlot2
# Jesse Eddinger

# Load that shit
library(dplyr)
library(tidyverse)
library(ggplot2)

gapminder <- read.csv('data/gapminder_data.txt')

# plot life expectancy with ggplot
ggplot(data=gapminder, aes(x=lifeExp)) +
  geom_histogram()

# break it down
ggplot(data=gapminder, aes(x=lifeExp))

# add hist geometry
ggplot(data=gapminder, aes(x=lifeExp)) +
  geom_histogram()

# challenge 1 - plot gpd per capita
ggplot(data=gapminder, aes(x=gdpPercap)) +
  geom_histogram()

# create subset for 2007 Americas
gapminder_small <- filter(gapminder, year == 2007, continent == 'Americas')

# create a bar plot for the 2007 data
ggplot(gapminder_small, aes(x=country, y=gdpPercap)) +
  geom_col()

# Lets make that look better, since ggplot works in layers
# add a line that flips the x and y
ggplot(gapminder_small, aes(x=country, y=gdpPercap)) +
  geom_col() +
  coord_flip()

# Challenge 2 - shows gdp per capita for all countries from '52 to 2007
gapminder_small2 <- gapminder %>% filter(continent=='Americas',
                                         year %in% c(1952,2007))
# create ggplot
ggplot(gapminder_small2, aes(x=country, y=gdpPercap,fill=as.factor(year)))+
  geom_col()+
  coord_flip()
  
# show the bars side by side
ggplot(gapminder_small2, aes(x=country, y=gdpPercap,fill=as.factor(year)))+
  geom_col(pos='dodge')+
  coord_flip()

# --------------- Lesson 6 - Saving and Sharing Data -------------------------

# save plot and save data
write.csv(gapminder_small2, file='data/gapminder_data_Americas1952_2007.csv',
          row.names=F)

# save the barplot of Americas data for 1952 and 2007 using ggplot2
ggsave(filename = 'figures/barplot_Americas_gdp.png')
ggsave(filename = 'figures/barplot_Americas_gdp.pdf')
