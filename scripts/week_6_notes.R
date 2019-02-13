#Week 6 Notes - GGPlot

library("tidyverse")
library(ggplot2)
surveys <- read_csv("data/portal_data_joined.csv")

#how to create a plot of how species abundances have changed through time

#### setting up the data ===========================================

#first remove NAs
surveys_complete <- surveys %>% 
  filter(!is.na(weight)) %>% 
  filter(!is.na(hindfoot_length)) %>% 
  filter(!is.na(sex)) 

#then filter out species with more than 50 counts
species_counts <- surveys_complete %>%
  group_by(species_id) %>% 
  tally() %>% 
  filter(n>=50)

#%in% links two different things
#looking at surveys_complete data for only the species in species_counts

surveys_complete <- surveys_complete %>% 
  filter(species_id %in% species_counts$species_id)

#write a dataframe to a csv
write_csv(surveys_complete, path="data_output/surveys_complete.csv")

#### getting into the gg ===========================================

#ggplot(data = DATA, mapping = aes(MAPPINGS) +
#geom_function)
#mapping - how are you taking things in your data and mapping them onto a canvas
#geom_function - takes basic canvas that you mapped out and puts some sort of data onto it

ggplot(data = surveys_complete) #just running this will give you a blank canvas

ggplot(data = surveys_complete, mapping = aes(x=weight,y=hindfoot_length)) 
#whoo now we have axes... but still no data

ggplot(data = surveys_complete, mapping = aes(x=weight,y=hindfoot_length)) +
  geom_point() 
#plots every row as a weight and hindfoot length value

#saving a plot object
surveys_plot <- ggplot(data = surveys_complete, mapping = aes(x=weight,y=hindfoot_length))
#ooh now we can work faster

surveys_plot +
  geom_point()
#and now we get same thing as in line 44
#good to just save core canvas and then modify geoms on their own

install.packages("hexbin")
library(hexbin)
surveys_plot +
  geom_hex()
#hexbin plots show densities of point distributions rather than having points hidden on top of each other

#can also use pipes with ggplot
surveys_complete %>% 
  ggplot(aes(x=weight,y=hindfoot_length)) +
  geom_point(alpha=0.1, color="plum") #alpha influences translucency - good for overplotting

surveys_complete %>% 
  ggplot(aes(x=weight,y=hindfoot_length)) +
  geom_point(alpha=0.1, aes(color=species_id)) #aes(color=species_id) gives each species a different color
#can see that our hindfoot length and weight ratio is relatively consistent for each species

#moving color to be a global aesthetic rather than just local... now any geoms we add on to this will also use color
surveys_complete %>% 
  ggplot(aes(x=weight,y=hindfoot_length, color=species_id)) +
  geom_point(alpha=0.1)

#jitter point vs normal point - adds a little noise to avoid having same values plotted on top of each other
surveys_complete %>% 
  ggplot(aes(x=weight,y=hindfoot_length, color=species_id)) +
  geom_jitter(alpha=0.1)

#### BOXPLOT TIME ============================================

#good for looking at some continuous variable across categories
surveys_complete %>% 
  ggplot(aes(x=species_id,y=weight, color=species_id)) +
  geom_boxplot()

#adding points to the boxplot
#reminder if you use geom_point it's all gonna lay in a line, whereas geom_jitter spreads them out
surveys_complete %>% 
  ggplot(aes(x=species_id,y=weight)) +
  geom_boxplot() +
  geom_jitter(alpha=0.3, aes(color=species_id))
#this graph makes the box plots hard to see, so we need to move it to end of code

surveys_complete %>% 
  ggplot(aes(x=species_id,y=weight)) +
  geom_jitter(alpha=0.1, aes(color=species_id)) +
  geom_boxplot(alpha=0) #alpha 0 kills the fill of boxplots

#### Time for time for time series ==========================

year_counts <- surveys_complete %>% 
  count(year, species_id) #count essentially does same thing as if you combined group.by and tally

year_counts %>% 
  ggplot(aes(x=year, y=n)) +
  geom_line()
#gives ratchet line graph becuase we didnt code in anything aboutn species id

#to make each species its own line
year_counts %>% 
  ggplot(aes(x=year, y=n, group=species_id)) +
  geom_line()
#ah so much nicer, but can't really tell which species is which

year_counts %>% 
  ggplot(aes(x=year, y=n, group=species_id)) +
  geom_line(aes(color=species_id))

#gives a mini graph for each individual species
year_counts %>% 
  ggplot(aes(x=year, y=n, group=species_id)) +
  geom_line(aes(color=species_id)) +
  facet_wrap(~ species_id)
#faceting gives more digestible plot for each category

#hmmm but how do the sex ratios vary by year?
yearly_sex_counts <- surveys_complete %>%
  count(year, species_id, sex)
yearly_sex_counts %>% 
  ggplot(aes(x = year, y = n, color = sex)) +
  geom_line() +
  facet_wrap(~ species_id)

#but hey, I don't really like the grid background, let's make it blank
#also people will think you're not classy if you have the grey grid... it's like the old grey underwear of ggplot

yearly_sex_counts %>% 
  ggplot(aes(x = year, y = n, color = sex)) +
  geom_line() +
  facet_wrap(~ species_id) +
  theme_bw() + 
  theme(panel.grid = element_blank())

#theme_bw() - makes the theme black and white
#theme(panel.grid = element_blank()) - makes the gridlines go away

install.packages("ggthemes")
library(ggthemes)
?ggthemes
#check out themes here: https://yutannihilation.github.io/allYourFigureAreBelongToUs/ggthemes/


