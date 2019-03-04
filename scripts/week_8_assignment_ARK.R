# Week 8 Assignment

library(tidyverse)
library(tidyr)
library(dplyr)
library(ggplot) 
library(lubridate)

### Part 1 ----------------------------------------------
#Download a new American River data set using this piece of code (should have a data frame with 35,038 obs of 5 variables):
  
am_riv <- read_csv("https://gge-ucd.github.io/R-DAVIS/data/2015_NFA_solinst_08_05.csv", skip = 13)

# 1. Make a datetime column by using paste to combine the date and time columns; remember to convert it to a datetime!
  
am_riv$datetime <- paste0(am_riv$Date," ",am_riv$Time)
am_riv$datetime <- ymd_hms(am_riv$datetime)

# 2. Calculate the weekly mean, max, and min water temperatures and plot as a point plot (all on the same graph)

am_riv1 <- am_riv %>% 
  mutate(riv_week = week(datetime))

am_riv1$riv_week = as.factor(am_riv1$riv_week)
  
am_riv2 <- am_riv1 %>% 
  group_by(riv_week) %>% 
  summarize(meantemp=mean(Temperature), maxtemp=max(Temperature),mintemp=min(Temperature))

am_riv2 %>% ggplot()+
  geom_point(aes(x=riv_week,y=meantemp),size=3,color="blue")+
  geom_line(aes(x=riv_week,y=meantemp))+
  geom_point(aes(x=riv_week,y=maxtemp),size=3,color="green")+
  geom_line(aes(x=riv_week,y=maxtemp))+
  geom_point(aes(x=riv_week,y=mintemp),size=3,color="orange")+
  geom_line(aes(x=riv_week,y=mintemp))

# 3. Calculate the hourly mean Level for April through June and make a line plot (y axis should be the hourly mean level, x axis should be datetime)

am_riv3 <- am_riv %>% 
  mutate(riv_month = month(datetime)) %>% 
  filter(riv_month == 4 | riv_month == 5 | riv_month == 6) %>% 
  mutate(riv_hour = hour(datetime))

am_riv4 <- am_riv3 %>% 
  group_by(riv_hour) %>% 
  summarize(meanhrtemp = mean(Temperature))

am_riv4 %>% ggplot()+
  geom_point(aes(x=riv_hour,y=meanhrtemp),size=3,color="blue")+
  geom_line(aes(x=riv_hour,y=meanhrtemp))
#but this just gives the average day for April to June


### Part 2 ----------------------------------------------

#Use the mloa_2001 data set (if you don’t have it, download the .rda file from the resources tab on the website). Remeber to remove the NAs (-99 and -999) and to create a datetime column (we did this in class).

load("~/Desktop/R_projects/inclass/data/mauna_loa_met_2001_minute.rda")
mloa_2001$datetime <- paste0(mloa_2001$year,"-",mloa_2001$month, "-", mloa_2001$day, " ", mloa_2001$hour24, ":", mloa_2001$min)
mloa_2001$datetime <- ymd_hm(mloa_2001$datetime)

mloa1 <- mloa_2001 %>% 
  filter(rel_humid!=-99, rel_humid!=-999) %>% 
  filter(temp_C_2m!=-99,temp_C_2m!=-999) %>% 
  filter(windSpeed_m_s!=-99,windSpeed_m_s!=-999)

#Then, write a function called plot_temp that returns a graph of the temp_C_2m for a single month. The x-axis of the graph should be pulled from a datetime column (so if your data set does not already have a datetime column, you’ll need to create one!) Hint! Take a look at the Challenge problem at the bottom of the functions lesson (https://gge-ucd.github.io/R-DAVIS/lesson_functions.html) to figure out how to feed a function a dataframe

plot_temp <- function(inmonth,data=mloa1){
  mloa2 <- mloa1 %>% 
    filter(month == inmonth) %>% 
    group_by(day) %>% 
    summarize(avgtemp=mean(temp_C_2m))
  mloaplot <- mloa2 %>% ggplot()+
    geom_point(aes(x=day, y = avgtemp),size=3,color="blue")+
    geom_line(aes(x=day, y = avgtemp, group=1))
  return(mloaplot)
}

plot_temp(4)


