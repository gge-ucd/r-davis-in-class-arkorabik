#This exercise asks you to modify existing code to complete a new task.

library(tidyverse)
gapminder <- read_csv("https://gge-ucd.github.io/R-DAVIS/data/gapminder.csv")

#A. Modify the following code to make a figure that shows how life expectancy has changed over time:

#original code 
ggplot(gapminder, aes(x = gdpPercap, y = lifeExp)) + 
  geom_point()
#modified code
ggplot(gapminder, aes(x = year, y = lifeExp)) + 
  geom_jitter()

#B. Look at the following code. What do you think the scale_x_log10() line is doing? What do you think the geom_smooth() line is doing? Hint: There’s no cost to tinkering! Try some code out and see what happens with or without particular elements.

ggplot(gapminder, aes(x = gdpPercap, y = lifeExp)) +
  geom_point(aes(color = continent), size = .25) + 
  scale_x_log10() +
  geom_smooth(method = 'lm', color = 'black', linetype = 'dashed') +
  theme_bw()
#the scale_x_log10() line is transforming the data to give a clearer trend of how life expectancy is correlated with GDP. Without this transformation, all the small values will be clustered extremely tightly together, and large values will be incredibly scattered.

#C. (Challenge!) Modify the above code to size the points in proportion to the population of the county. Hint: Are you translating data to a visual feature of the plot?

ggplot(gapminder, aes(x = gdpPercap, y = lifeExp)) +
  geom_point(aes(color = continent, size=pop)) + 
  scale_x_log10() +
  geom_smooth(method = 'lm', color = 'black', linetype = 'dashed') +
  theme_bw()
  
  