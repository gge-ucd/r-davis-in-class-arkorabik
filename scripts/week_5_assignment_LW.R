library(tidyverse)
surveys <- read_csv("data/portal_data_joined.csv")

# 3. subsetting surveys weights to be those only in range 30-60
surveys_weights <- surveys %>%
  filter(weight == 30:60)
head(surveys_weights)

# 4. creating new data frame to see the maximum weight of the gender of each species, excluded NAs in weight to better analyze biggest and smallest critters

biggest_critters <- surveys %>%
  group_by(sex, species) %>% 
  filter(weight == max(weight, na.rm = TRUE)) %>%
  
# using arrange to explore biggest and smallest critters
  arrange(biggest_critters, desc(weight))
tail(arrange(biggest_critters, desc(weight)))

# 5. exploring NAs in the dataset...
# by plot
surveys %>% 
  group_by(plot_id) %>% 
  filter(is.na(weight)) %>% 
  tally () %>% 
  arrange() %>% 
  View ()
# by species
surveys %>% 
  group_by(species) %>% 
  filter(is.na(weight)) %>% 
  tally () %>% 
  arrange() %>% 
  View ()
# by taxa
surveys %>% 
  group_by(taxa) %>% 
  filter(is.na(weight)) %>% 
  tally () %>% 
  arrange() %>% 
  View ()

# 6. removing NAs from weight, creating an average weight column for each spp + sex combination

surveys_avg_weight <- surveys %>% 
  group_by(sex, species_id) %>% 
  arrange(.by_group = TRUE) %>% 
  filter(!is.na(weight)) %>%
  mutate(avg_weight = mean(weight)) %>% 
  select(species_id,sex,weight,avg_weight)

# 7. challenge, creating new column to verify whether or not row weight is above avgerage weight for the species

surveys_avg_weight %>% 
  mutate(above_average = weight > avg_weight)

# 8. scaling weight (I don't think I scaled this by species and am generally confused but don't really have time to sort through it right now)

scaled_surveys <- surveys %>% 
  mutate(scale = scale(weight))

summary(scaled_surveys$scale)
head(sort(scaled_surveys$scale))
tail(sort(scaled_surveys$scale))
