# Jesse Eddinger
# Manipulating Dataframes


# Reading in gapminder data
gapminder <- read.csv('data/gapminder_data.txt')


# Inspecting structure
str(gapminder)

# Looking at class
class(gapminder$year)

# Examining Length
length(gapminder)

nrow(gapminder) 
ncol(gapminder)
dim(gapminder)

colnames(gapminder)

head(gapminder)

# Challenge 1
tail(gapminder)
tail(gapminder, n = 15)

# my_dataframe[rows,cols]
gapminder[sample(nrow(gapminder), 5), ]

# Add a column to our dataframe

below_average <- gapminder$lifeExp < 70.5
head(gapminder)

cbind(gapminder, below_average)
head(cbind(gapminder, below_average))


# Error for differing number of rows
below_average <- c(TRUE, TRUE, TRUE, TRUE, TRUE)
head(cbind(gapminder, below_average))

# Multiples fix
below_average <- c(TRUE, TRUE, FALSE)
head(cbind(gapminder, below_average))

# Actual
below_average <- as.logical(gapminder$lifeExp < 70.5)
gapminder <- cbind(gapminder, below_average)
head(gapminder)

# add a row on our data
new_row <- list('Norway', 2016, 5000000, 'Nordic', 80.3, 49400.0, FALSE)
gapminder_norway <- rbind(gapminder, new_row)
tail(gapminder_norway)

gapminder2 <- rbind(gapminder, gapminder)
tail(gapminder2, n=3)

# Challenge

df <- data.frame(id= c('a','b','c'), 
                 x=1:3, 
                 y=c(TRUE, TRUE, FALSE))
# add row
row_d <- list('d', 4, TRUE)
rbind(df, row_d)
df <- rbind(df, row_d)

df_ef <- data.frame(id = c('e', 'f'),
                    x = 5:6,
                    y= c(FALSE, FALSE))
rbind(df, df_ef)
