# Jesse Eddinger 
# 2022-08-09
# Learning about Data Structures

# Read in data - use tab in the quotes to make sure it's routing correctly 
nordic <- read.csv('data/nordic-data.txt')

# look at column of data
nordic$country
nordic$lifeExp

# add 2 years to lifeExp, this doesn't actually change dataframe, you'd need to
# assign them
nordic$lifeExp + 2

# add to columns 
nordic$lifeExp + nordic$country

# can't do that since they are different data types

# lets look at types of data
class(nordic$lifeExp)

class(3.14) # numeric
class(1L) # integer
class(1+1i) # complex
class(TRUE) # logical
class('banana') # character 
class(factor('banana')) # converted character to factor data type

nordic_2 <- read.csv('data/nordic-data-2.txt')
class(nordic_2$lifeExp)
nordic_2$lifeExp # last column has text in it, 'or' so it classifies it as character

# coercing one data type into another
# work with a vector
my_vector <- vector(length = 3)
my_vector

another_vector <- vector(mode = 'character', length = 3)

#vectors with mixed types
combine_vector <- c(2,6,3)
combine_vector

# thinks that its all character values
quiz_vector <- c(2,6, '3')
quiz_vector

(coercion_vector <- c('a', TRUE))

# is numeric because R will read TRUE as binomial, t/f
(another_coercion_vector <- c(0,TRUE))

character_vector_example <- c('0', '2', '4')
character_coerced_to_numeric <- as.numeric(character_vector_example)
character_coerced_to_numeric
class(character_coerced_to_numeric)
str(character_coerced_to_numeric)

(numeric_coerced_to_logical <- as.logical(character_coerced_to_numeric))

# add items to existing vector
ab_vector <- c('a', 'b')
combine_example <- c(ab_vector, 'DC')

my_series <- seq(10)
my_series

head(my_series)
head(my_series, n = 4)
tail(my_series, n=4)
length(my_series)

# Factors
nordic_countries <- c('Norway', 'Finland', 'Denmark', 'Iceland', 'Sweden')
nordic_countries

categories<- factor(nordic_countries)
categories
str(categories)

# coerce the factor into numeric vector
as.numeric(categories)

# reorder a factor
mydata <- c('case', 'control', 'control', 'case')
factor_ordering_example <- factor(mydata, levels = c('control', 'case'))
str(factor_ordering_example)

# lists
list_example <- list(1, 'a', TRUE, c(2,6,7))
list_example
