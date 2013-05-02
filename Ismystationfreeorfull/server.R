# Cycle Hire - Hazard rates
# 
# Author: Ulrich Atz
# Twitter: panoramadata
# Email: ulrich.atz@theodi.org


# Load packages 
# Add: conditionally install them
library(shiny)
library(plyr)
library(lubridate)
library(ggplot2)
library(scales)
library(RColorBrewer)

library(XML)

# Direct XML feed, registered for 62.254.247.131 
# Some magic with xmlToDataFrame() or library(XML) but easier below
# tflfeed <- "http://www.tfl.gov.uk/tfl/syndication/feeds/cycle-hire/livecyclehireupdates.xml"
# not working
# system.time( bikes <- ldply(xmlToList(tflfeed), data.frame) )


live1 <- read.csv("http://api.bike-stats.co.uk/service/rest/bikestats?format=csv", as.is = TRUE, header = TRUE)
# More stations here
live2 <- read.csv("http://borisapi.heroku.com/stations.csv", as.is = TRUE, header = TRUE)

# Local station
live1[live1$Name=="Clifton Street, Shoreditch",]
live2[live2$name=="Clifton Street, Shoreditch",]


# Omit Lat/Long etc.
bikesonly <- subset(live2, select=c("id","name", "nb_bikes", "nb_empty_docks"))
# Sort by ID
bikesonly <- arrange(bikesonly, id)
head(bikesonly)

# Compute total number of docks and add column in data.frame
bikesonly <- mutate(bikesonly, docks = nb_bikes + nb_empty_docks)
head(bikesonly)


# Parse time from live1 feed
time1 <- strptime(live1$UpdateTime, "%H:%M")
head(minute(time1))

# Parse time from live2 feed
# Remove last colon for hour offset
timetmp <- gsub("(.*).(..)$","\\1\\2", live2$updated_at)
time2 <- strptime(timetmp, "%Y-%m-%dT%H:%M:%S%z")
head(minute(time2))
head(time2)

