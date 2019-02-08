#--------------------------
#1. Read portal_data_joined.csv into R using the tidyverse’s command called read_csv(), and assign it to an object named surveys.

library(tidyverse)
surveys <- read_csv("data/portal_data_joined.csv")

#--------------------------
# 2. Using tidyverse functions and pipes, subset to keep all the rows where weight is between 30 and 60, then print the first few (maybe… 6?) rows of the resulting tibble.

thirty_sixty <- surveys %>% 
  filter(weight>30) %>%
  filter(weight<60) %>% 
  head()

#--------------------------
# 3. Make a tibble that shows the max (hint hint) weight for each species+sex combination, and name it biggest_critters. Use the arrange function to look at the biggest and smallest critters in the tibble (use ?, tab-complete, or Google if you need help with arrange).

biggest_critters <- surveys %>% 
  filter(!is.na(sex)) %>%
  group_by(sex,species_id) %>% 
  summarize(max_weight = max(weight, na.rm = TRUE)) 
###Neotoma albigula is the biggest rodent clocking in at a whopping 274(F) and 280(M) grams!
###On the other hand, Reithrodontomys montanus females and Baiomys taylori males are teeny tiny at a mere 13 and 9 grams respectively.

#--------------------------
# 4. Try to figure out where the NA weights are concentrated in the data- is there a particular species, taxa, plot, or whatever, where there are lots of NA values? There isn’t necessarily a right or wrong answer here, but manipulate surveys a few different ways to explore this. Maybe use tally and arrange here.

#NAs by sex
sex_nas <- surveys %>% 
  filter(is.na(weight)) %>% 
  group_by(sex) %>% 
  tally() 

sex_ns <- surveys %>% 
  group_by(sex) %>% 
  tally() %>% 
  mutate(na_n = sex_nas$n) %>% 
  mutate(proportion = na_n/n)
###Both males and female have approximately a 2% rate of not having their weight recorded. 94% of non-sexed individuals, however, do not have weight records.

#NAs by genus
genus_nas <- surveys %>% 
  filter(is.na(weight)) %>% 
  group_by(genus) %>% 
  tally()
genus_ns <- surveys %>% 
  group_by(genus) %>% 
  tally() %>% 
  mutate(na_n = genus_nas$n) %>% 
  mutate(proportion = na_n/n)
### 15 out of 26 genuses have no weight records at all, with one other genus having weighed less than 1% of counted individuals. The other 10 genuses all have had over 90% of their individuals weighed.

#NAs by species
speciesid_nas <- surveys %>% 
  group_by(species_id) %>% 
  tally(is.na(weight))
speciesid_ns <- surveys %>% 
  group_by(species_id) %>% 
  tally() %>% 
  mutate(na_n = speciesid_nas$n) %>% 
  mutate(proportion = na_n/n)
### 23 species have no weight records on file, whereas 4 species have had every single individual weighed. If you plot a histogram of the proportions, however, you see that the number of species with no weight representation and the number of species with almost full weight representation are nearly the same.
hist(speciesid_ns$proportion, breaks = 20)

#NAs by plot
plot_nas <- surveys %>% 
  filter(is.na(weight)) %>% 
  group_by(plot_id) %>% 
  tally()
plot_ns <- surveys %>% 
  group_by(plot_id) %>% 
  tally() %>% 
  mutate(na_n = plot_nas$n) %>% 
  mutate(proportion = na_n/n)
hist(plot_ns$proportion, breaks = 10)
### Each plot was sampled relatively equally and weighed between 80-96% of the individuals collected on said plot.

#NAs by plot type
plottype_nas <- surveys %>% 
  filter(is.na(weight)) %>% 
  group_by(plot_type) %>% 
  tally()
plottype_ns <- surveys %>% 
  group_by(plot_type) %>% 
  tally() %>% 
  mutate(na_n = plottype_nas$n) %>% 
  mutate(proportion = na_n/n)
### Each plot type was also sampled relatively equally and weighed approximately 95% of individuals collected on said plot.
 
#--------------------------
# 5. Take surveys, remove the rows where weight is NA and add a column that contains the average weight of each species+sex combination. Then get rid of all the columns except for species, sex, weight, and your new average weight column. Save this tibble as surveys_avg_weight. The resulting tibble should have 32,283 rows.

surveys_avg_weight<-surveys %>% 
  group_by(sex,species_id) %>% 
  arrange(.by_group=TRUE) %>% 
  filter(!is.na(weight)) %>%
  mutate(avg_weight=mean(weight)) %>% 
  select(species_id,sex,weight,avg_weight)
  
#--------------------------
# 6. Challenge: Take surveys_avg_weight and add a new column called above_average that contains logical values stating whether or not a row’s weight is above average for its species+sex combination (recall the new column we made for this tibble).

surveys_avg_weight %>% 
  mutate(above_average = weight>avg_weight) %>% 
  View()

#--------------------------
# 7. Extra Challenge: Figure out what the scale function does, and add a column to surveys that has the scaled weight, by species. Then sort by this column and look at the relative biggest and smallest individuals. Do any of them stand out as particularly big or small?

surveys_scaled <- surveys %>% 
  group_by(species) %>% 
  mutate(scaled_weight = scale(weight)) %>% 
  filter(!is.na(weight)) 

### The relatively biggest critter is Chaetodipus penicillatus with a relative weight of 15.493832, and the relatively smallest critter was Dipodomys merriami with a relative weight of -4.856850. These results are interesting, because neither of these species were the biggest or smallest species overall.
