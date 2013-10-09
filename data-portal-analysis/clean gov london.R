setwd("~/git/R-projects/data-portal-analysis")
library(ggplot2)
library(plyr)
library(lubridate)
source("functions.r")

# -------------------------------
# London Data Store
#--------------------------------
lon <- read.csv("data/datastore-catalogue.csv", stringsAsFactors = FALSE)
lon.c <- lon[, c("TITLE","DDATE", "UPDATE_FREQUENCY", "RELEASE_DATE", "METADATA_UPDATE")]
str(lon.c)

# Metadata update (from the field names csv file)
# Last Updated Date of the Dataset or metadata (in the London Datastore)

# Recognise dates
lon.c$date.release <- as.Date(paste("01", lon.c$DDATE), "%d %B %Y")
lon.c$metadata <- as.Date(lon.c$METADATA_UPDATE, "%d/%m/%Y")
row.sample(lon.c, 30)[, "metadata"] # test
  
# Sort by time
lon.c <- lon.c[order(lon.c$date.release), ]

# Create plot of data release per month over the whole period.
p.lon.c <- ddply(lon.c, .(date.release), summarize, releases = length(date.release))
ggplot(data=p.lon.c, aes(x=date.release, y=releases)) + geom_line(color = "#D60303") + 
  theme_minimal(base_family = "Helvetica Neue") +
  ggtitle("London Data Store") + xlab("Release month") + ylab("New data sets")
ggsave(file="graphics/London - releases per month.png", width=8, height=4)

# Sum over time
p.lon.c <- arrange(p.lon.c, date.release)
p.lon.c$releases.cumsum <- cumsum(p.lon.c$releases)

ggplot(data=p.lon.c, aes(x=date.release, y=releases.cumsum)) + geom_line() + 
  theme_minimal(base_family = "Helvetica Neue") +
  ggtitle("London Data Store") + xlab("Release month") + ylab("Total number of data sets") +
  geom_text(data=p.lon.c[44, ], label=p.lon.c[44, "releases.cumsum"], hjust=1.5, size=4)
ggsave(file="graphics/London - releases cumulative sum.png", width=8, height=4)

# Calculate time distance between release and metadata update
# Must allow for min one month diff as DDATE is M-Y only.
lon.c$time.diff <-  difftime(lon.c$metadata, lon.c$date.release, units="weeks")
lon.c$diff.weeks <- as.numeric(round(lon.c$time.diff))

# Time difference analysis
ggplot(lon.c, aes(x=diff.weeks)) + geom_bar(binwidth=1)
ggsave(file="graphics/London - month diff histogram.png")
mode.stat(lon.c$diff.weeks) # 32?
summary(lon.c$diff.weeks)

# How many data sets were updated (allowing for a month of leeway)?
nrow(lon.c[lon.c$diff.weeks >= 5, ])



# -------------------------------
# UK Data Store
#--------------------------------
gov <- read.csv("data/data.gov.uk-ckan-meta-data-2013-09-30.csv")

