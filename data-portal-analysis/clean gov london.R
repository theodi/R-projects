setwd("~/git/R-projects/data-portal-analysis")
library(ggplot2)

gov <- read.csv("data/data.gov.uk-ckan-meta-data-2013-09-30.csv")
lon <- read.csv("data/datastore-catalogue.csv")
lon.c <- lon[, c("TITLE","DDATE", "UPDATE_FREQUENCY", "RELEASE_DATE", "METADATA_UPDATE")]

ggplot(data=lon.c, aes(x=DDATE, group=1)) + geom_line(stat="bin") + theme_minimal()
