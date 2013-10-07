setwd("/Users/Ulrich/git/R-projects/fire-stations/data")

stations13 <- read.csv("LFB data 1 Jan 2009 to 31 Mar 2013.csv")
stations09 <- read.csv("LFB data 1 Apr 2007 to 31 Dec 2008.csv")

sort(table(stations13$IncidentStationGround), decreasing=TRUE)
sort(table(stations09$IncidentStationGround), decreasing=TRUE)

summary(stations09$IncidentNumber)