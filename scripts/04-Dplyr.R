# Data Frame Manipulation with Dplyr
# Jesse Eddinger

# Load library
library(dplyr)

# load data set
gapminder <- read.csv('data/gapminder_data.txt')

#find the colomn names so you can work with the next question
colnames(gapminder)

# calculate mean gdp per capita for Africa
mean(gapminder[gapminder$continent == 'Africa', 'gdpPercap'])
mean(gapminder[gapminder$continent == 'Americas', 'gdpPercap'])

# lets do this with dplyr because that sucks 

# use select() function to select colomns
year_country_gdp <- select(gapminder,year,country,gdpPercap)

# use filter to grab rows that meet a condition
# grab only European countries

year_country_gdp_euro <- gapminder %>% 
  filter(continent == 'Europe') %>% 
  select(year, country, gdpPercap)

# Challenge 1
year_country_africa <- gapminder %>%
  filter(continent == 'Africa') %>%
  select(year, country, lifeExp)
year_country_africa

# use group_by() and summarize()

# calculate mean gdp for all countries in each continent
gdp_bycontinents <- gapminder %>%
  group_by(continent) %>%
  summarize(mean_gpdPercap = mean(gdpPercap))

gdp_bycontinents

# Challenge 2 baby
lifeExp_bycountry <- gapminder %>%
  group_by(country) %>%
  summarize(mean_lifeExp = mean(lifeExp))

lifeExp_bycountry

# wow thats a lot of rows
min(lifeExp_bycountry$mean_lifeExp)

lifeExp_bycountry %>%
  filter(mean_lifeExp == min(mean_lifeExp) | mean_lifeExp == max(mean_lifeExp))
lifeExp_bycountry

# Another way to do that
lifeExp_bycountry %>%
  arrange(mean_lifeExp) %>%
  head(1)

# Use count and n
# to get the number of observation in each group

gapminder %>%
  filter(year == 2002) %>%
  count(continent,sort=T)

# calculate standard error for life exp for each continent 
gapminder %>%
  group_by(continent) %>%
  summarize(se_le = sd(lifeExp)/sqrt(n()))

# calculate summary stats for lifeExp for each continent
gapminder %>%
  group_by(continent) %>%
  summarize(
    mean_le = mean(lifeExp),
    min_le = min(lifeExp),
    max_le = max(lifeExp),
    se_le = sd(lifeExp)/sqrt(n()))

# mutate()
# create a new variable in our df, then summarize that info
# calculate gdp per billion
# report summary stats for each continent for each year

gpd_pop_bycontinents_by_year <- gapminder %>%
  mutate(gpd_billion = gdpPercap*pop/10^9) %>%
  group_by(continent,year) %>%
  summarize(
    mean_gdpPercap = mean(gdpPercap),
    sd_gdpPercap = sd(gdpPercap),
    mean_pop = mean(pop),
    sd_pop = sd(pop),
    mean_gdp_billion = mean(gdp_billion),
    sd_gdp_billion = sd(gdp_billion))











