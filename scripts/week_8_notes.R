#Week 8 Notes

library(lubridate)
library(tidyverse)

load("data/mauna_loa_meta-2001_minute.rda")

# Lubridate is so great -----------------------------
#lubridate helps you manipulate dates and date times

as.Date("02-01-1998",format="%m-%d-%Y")
mdy("02-01-1998")

#date-times
tm1 <- as.POSIXct("2016-07-24 23:55:26 PDT") #looking for year month day hours minutes seconds
tm1

tm2 <- as.POSIXct("25072016 08:32:07",format="%d%m%Y %H:%M:%S")
tm2


tm4 <- as.POSIXct(strptime("2016/04/04 14:47", format = "%Y/%m/%d %H:%M"),tz="America/Los_Angeles")

tz(tm4) #checks the time zone of whatever thing you input


# Moving on to.....

nfy <- read_csv("data/2015_NFY_solinst.csv",skip=13) #skip=n tells you to skip the first n rows when the data set is read into R

nfy1 <- read_csv("https://gge-ucd.github.io/R-DAVIS/data/2015_NFY_solinst.csv", skip = 12)

nfy2 <- read_csv("https://gge-ucd.github.io/R-DAVIS/data/2015_NFY_solinst.csv", skip = 12,col_types = "ccidd") #col_type allows us to tell R what we want each column to be read in as c=characterter, i = integer, d=double

#if you want to change just one column type
nfy3<- read_csv("https://gge-ucd.github.io/R-DAVIS/data/2015_NFY_solinst.csv", skip =12, col_types = cols(Date=col_date()))

#mashing date and time columns together into a column called date-time
nfy2$datetime <- paste(nfy2$Date, " ", nfy2$Time, sep="") # " " puts a space in between the two values that you are putting each thing into the new column <- essentially acts as a glue

nfy2$datetime_test <- ymd_hms(nfy2$datetime,tz="America/Los_Angeles") #tests to make sure appropriate values in appropriate places
tz(nfy2$datetime_test)

summary(mloa_2001)
#if we wanted a date time column, we'd have to paste together several columns
mloa_2001$datetime <- paste0(mloa_2001$year,"-",mloa_2001$month, "-", mloa_2001$day, " ", mloa_2001$hour24, ":", mloa_2001$min)

glimpse(mloa_2001)
mloa_2001$datetime <- ymd_hm(mloa_2001$datetime) #ymd_hm turns a column from character or integer or sth else to date time

mloa1 <- mloa_2001 %>% 
  filter(rel_humid!=-99, rel_humid!=-999) %>% 
  filter(temp_C_2m!=-99,temp_C_2m!=-999) %>% 
  filter(windSpeed_m_s!=-99,windSpeed_m_s!=-999)

mloa2 <- mloa1 %>% 
  mutate(which_month = month(datetime, label=T)) %>% #label=T gives you Jan or Feb rather than numeric form of month
  group_by(which_month) %>% 
  summarize(avgtemp=mean(temp_C_2m))

mloa2 %>% ggplot()+
  geom_point(aes(x=which_month,y=avgtemp),size=3,color="blue")+
  geom_line(aes(x=which_month, y=avgtemp))

### Putting the FUN in FUNCTIONS ----------------------

my_sum <- function(a,b) {
  thesum <- a+b
  return(thesum)
} #tell R, hey this is a function, and then put in the arguments, then tell it what to do with the arguments

my_sum(3,2)

my_sum2 <- function(a=1,b=2) {
  thesum <- a+b
  return(thesum)
} #sets default values for a and b

#log function has default of exponent 1

#Create a function that converts the temp in K to the temp in C
KtoC <- function(a) {
  convertKC <- a-273.15
  return(convertKC)
}
KtoC(473)

#Iteration and For Loops-----------------------------------

#allows you to rerun  a bunch of things through same set of code
#if you need to run something three or more times, you should iterate instead of copy pasting

#simple iteration - better to do this than do log(1), log(2), etc...
x <- 1:10
log(x)

#for loops

for(i in 1:10) {
  print(i)
}






