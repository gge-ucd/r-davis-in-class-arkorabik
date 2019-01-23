#Week 3 code

tidycode <- read.csv("data/week3test.csv")

#basic stuffs

### Vector Types ###

str() #calls the structure of an object - will give the type of info a vector contains, how many things are contained, and a list of the values contained

weight_g <- c(1,5,1500,12)
weight_g <- c(weight_g,105) #adds another value to the vector
#but if you run it multiple times, you'll keep adding the same value over and over

weight_g <- c(25,weight_g)

#6 types of atomic vectors: numeric (double), character, logical, integer, complex, and raw
#first 4 are most common

#R recognizes integers by putting an L behind each value
weight_int <- c(21L, 24L, 27L)

typeof(weight_g)
typeof(weight_int)

#what happens if you mix different types in a single vector

num_char <- c(1, 2, 3, "a")
num_logical <- c(1, 2, 3, TRUE)
char_logical <- c("a", "b", "c", TRUE)
tricky <- c(1, 2, 3, "4")
#defaults to character, or in the case of num_logical, numbers (where T=1 and F=0)


#subsetting vectors
animals <- c("mouse", "cat", "dog", "rat")
animals[3] #gives you "dog"
animals[2,3]
# gives you Error in animals[2, 3] : incorrect number of dimensions
animals[c(2,3)]
#gives you "cat" "dog"

#conditional subsetting
weight_g[c(1,3,5)]
weight_g>50

weight_g[weight_g>50] #gives you back all of the values in the vector that are >50

#multiple conditions
weight_g[weight_g<30 | weight_g>50] #to use OR function use |  
weight_g[weight_g>=30 & weight_g==90]
#get back numeric(0) b/c there is nothing in the vector that meets these conditions

animals <- c("mouse", "rat", "dog", "cat")
animals[animals == "cat" | animals == "rat"] # returns both rat and cat

animals %in% c("rat", "cat", "dog", "duck", "goat")
animals[animals %in% c("rat", "cat", "dog", "duck", "goat")]

###Missing Values###
heights <- c(2,4,4,NA,6)
str(heights)
mean(heights, na.rm = TRUE) #this code strips out the NA so you can still get a mean
is.na(heights) #tells you which values are NA
na.omit(heights)
