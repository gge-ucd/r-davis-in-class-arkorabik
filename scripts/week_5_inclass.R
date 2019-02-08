#week 5 notes

#manipulating and managing data with dplyr

#tidyverse - if you're using a really huge database online that is bigger than the memory on your computer, this allows you to pull down the data that you need
install.packages("tidyverse")
library(tidyverse)

#loading data
# read.csv is the base r package, read_csv is the tidyverse package
surveys <- read_csv("data/portal_data_joined.csv")
View(surveys)
str(surveys) #produces tbl_df 

#tibble = fancy dataframe, essentially just a df that prints nicer and looks fancier

#-----------------------------
#playing with dplyr functions

##select - used for columns in a data frame
select(surveys,plot_id, species_id, weight) #select(dataframe,desired column 1, desired column 2, ...)

##filter - used for rows in a data frame
filter(surveys, year==1995) #filter(dataframe, desired rows) #so in this case only the rows from the year 1995

surveys2 <- filter(surveys, weight<5) #gives us all the individs that have weight<5
surveys_sml <- select(surveys2, species_id, sex, weight)

##Pipes %>% <- shortcut for this is command+shift+m
#pipes take something from the left of the pipe and shift it to the right of the pipe
#can think of a pipe as a 'THEN' function
#pipes take what's on the left and put it into the first slot of what's on the right

surveys %>% 
  filter(weight<5) %>% 
  select(species_id,sex,weight)

challenge1 <- surveys %>% 
  filter(year<1995) %>% 
  select(year, sex, weight)

##mutate - creates new columns
surveys <- surveys %>% 
  mutate(weight_kg = weight/1000) %>% 
  mutate(weight_kg2 = weight_kg*2)
#first needs to know what the new column is going to be called, and how this new column will be calculated

surveys %>% 
  mutate(weight_kg = weight_kg*2) # this would just replace the already existing weight_kg column

#if we want to get rid of all the NAs...
surveys %>% 
  filter(!is.na(weight)) %>% #  ! is NOT
  mutate(weight_kg = weight/1000) %>% 
  head()

#Create a new data frame from the surveys data that meets the following criteria: contains only the  species_id column and a new column called hindfoot_half containing values that are half the  hindfoot_length values. In this hindfoot_half column, there are no NAs and all values are less than 30.

challenge2 <- surveys %>% 
  mutate(hindfoot_half = hindfoot_length/2) %>% 
  filter(!is.na(hindfoot_half)) %>%
  filter(hindfoot_half<30)
  select(species_id,hindfoot_half)
  
#"complete cases" to filter out all of the NAs

##group_by - good for split-apply-combine
  ##summarize
  
surveys %>% 
  group_by(sex) %>% 
  summarize(mean_weight = mean(weight, na.rm = T))
#na.rm means "remove NAs"

surveys %>% 
  filter(!is.na(weight)) %>% 
  group_by(sex, species_id) %>% 
  summarize(mean_weight = mean(weight), min_weight = min(weight)) %>% 
  View()
  
surveys %>% 
  group_by(sex) %>% 
  tally() %>% #tally generates a count of whatever you're assigning it to
  View()


