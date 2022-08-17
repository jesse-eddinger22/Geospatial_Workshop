# Subsetting Data
# Jesse Eddinger

# Load data 
gapminder <- read.csv('data/gapminder_data.txt', header = TRUE)

# Create a Vector
x <- c(5.4, 6.2, 7.1, 4.8, 7.5)
names(x) <- c('A', 'B', 'C', 'D', 'E')
x

# access element using their indices
x[1]
x[4]

# Return multiple elements
x[c(1,3)]

# Return slice of the vector
x[1:4]

# Returning things that dont exist
x[6]

# Return all but one number
x[-2]

# Remove multiple elements
x[c(-1,-5)]
x[-c(1,5)]

# Trouble, no negative one position because of the colon
x[-1:3]

# Fix
x[-(1:3)]
 
x[4]
# Recreate x without 4
x <- x[-4]

# Challenge 
x <- c(5.4, 6.2, 7.1, 4.8, 7.5)
names(x) <- c('a','b','c','d','e')

x[2:4]
x[c(2,3,4)]
x[-c(1,5)]

# Extracting

# Subset by name

# Subset multiple elements
x[c('a','c')]
x['d']
x[-'d'] # can't drop by name i guess

# subset through logical operators
x[c(FALSE,FALSE,TRUE,FALSE,TRUE)]
x[x>7]

# subset where name is a
x[names(x) == 'a']

# Challenge 2
# use & or the or operator 
x_subset <- x[x<7 & x>4]

# Subsetting dataframes
head(gapminder)

head(gapminder[3])
head(gapminder[['lifeExp']])
head(gapminder$year)

# subset by rows and colomns
gapminder[1:3, ]

# Challenge 3
gapminder[gapminder$year=1957]
gapminder[gapminder$year==1957,]


gapminder[-1:4]
gapminder[-c(1:4)]

gapminder[gapminder$lifeExp > 80]
gapminder[gapminder$lifeExp > 80, ]

# First row and 4 and 5 columns
gapminder[1,4,5]
gapminder[1,c(4,5)]

gapminder[gapminder$year == 2002|2007,]
gapminder[gapminder$year == 2002 | gapminder$year == 2007, ]

# Challenge 4 
gapminder[1:20, ]
