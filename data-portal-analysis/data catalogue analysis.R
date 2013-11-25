setwd("~/git/R-projects/data-portal-analysis")
library(ggplot2)
library(plyr)
library(lubridate)
library(scales)
library(car)
library("directlabels")
source("functions.r")
theme_set(theme_minimal(base_family = "Helvetica Neue"))

# -------------------------------
# London Data Store
#--------------------------------
lon.full <- read.csv("data/datastore-catalogue.csv", stringsAsFactors = FALSE)
lon <- lon.full[, c("TITLE","DDATE", "UPDATE_FREQUENCY", "RELEASE_DATE", "METADATA_UPDATE")]
str(lon)

# Metadata update (from the field names csv file)
# Last Updated Date of the Dataset or metadata (in the London datastore)

# Recognise dates
lon$date.release <- as.Date(paste("01", lon$DDATE), "%d %B %Y")
lon$metadata <- as.Date(lon$METADATA_UPDATE, "%d/%m/%Y")
row.sample(lon, 30)[, "metadata"] # test
  
# Sort by time
lon <- lon[order(lon$date.release), ]

# Create plot of data release per month over the whole period.
p.lon <- ddply(lon, .(date.release), summarize, releases = length(date.release))

# Sum over time 
p.lon <- arrange(p.lon, date.release)
p.lon$releases.cumsum <- cumsum(p.lon$releases)
p.lon$date.release <- as.POSIXct(p.lon$date.release)

ggplot(data=p.lon, aes(x=date.release, y=releases)) + geom_line(color = "#D60303") + 
  xlab("Month of release") + ylab("New datasets")
ggsave(file="graphics/London-releases-per-month.png", height = 4, width = 8, dpi = 100)


# Hard coded last row - I am a bad person
ggplot(data=p.lon, aes(x=date.release, y=releases.cumsum)) + geom_line() + 
  xlab("Release month") + ylab("Total number of data sets") +
  geom_text(data=p.lon[44, ], label=p.lon[44, "releases.cumsum"], hjust=1.5, size=4)
ggsave(file="graphics/London-releases-cumulative-sum.png", height = 4, width = 8, dpi = 100)

# Calculate time distance between release and metadata update
# Must allow for min one month diff as DDATE is M-Y only.
lon$time.diff <-  difftime(lon$metadata, lon$date.release, units="weeks")
lon$diff.weeks <- as.numeric(round(lon$time.diff))

# Time difference analysis
ggplot(lon, aes(x=diff.weeks)) + geom_bar(binwidth = 1, fill = "#D60303", color = "white") + 
  geom_text(data = as.data.frame(c("32")), x = 50, y = 58, label = "Mode = 32 weeks", size = 3.5) +
  geom_hline(yintercept = seq(10, 60, 10), col = "white", lwd = 0.5) +
  xlab("Difference between release and metadata update in weeks")
ggsave(file="graphics/London-month-diff-histogram.png", height = 4, width = 8, dpi = 100)
mode.stat(lon$diff.weeks) # 32?
summary(lon$diff.weeks)

# How many data sets were updated (allowing for a month of leeway)?
nrow(lon[lon$diff.weeks >= 5, ])

# Create plot of data release per month and metadata update.
# Year month metadata for comparable granularity in the chart
lon$meta.month <- as.POSIXct(as.Date(paste(year(lon$metadata), month(lon$metadata), "01"), "%Y %m %d"))
p.lon2 <- ddply(lon, .(meta.month), summarize, releases = length(metadata))
ggplot() + 
  geom_line(data = p.lon, aes(x = date.release, y = releases), color = "#D60303") +
  geom_line(data = p.lon2, aes(x = meta.month, y = releases), color = "orange") +
  coord_cartesian(ylim = c(0,100)) +
  scale_x_datetime(breaks = date_breaks("1 year"), minor_breaks = date_breaks("3 months"), labels = date_format("%b %Y")) +
  annotate("text", x = as.POSIXct("2010-11-01"), y = 98, label = "^ 151", size = 3.5) +
  annotate("text", x = as.POSIXct("2013-04-01"), y = 45, label = "New releases", size = 4, color = "red") + 
  annotate("text", x = as.POSIXct("2013-04-01"), y = 60, label = "Metadata update", size = 4, color = "darkorange") +
  xlab("Month") + ylab("Releases per month") 
ggsave(file="graphics/London-metadata.png", height = 4, width = 8, dpi = 100)

#-------TAGS--------
head(sort(table(lon.full$CATEGORIES)), decreasing = TRUE)
head(sort(table(lon.full$TAGS)), decreasing = TRUE)

library(tau)
tags.c <-  textcnt(lon.full$CATEGORIES, split = "[[:space:][:punct:]]+", method = "string", n = 1L)
tags.t <-  textcnt(lon.full$TAGS, split = "[[:space:][:punct:]]+", method = "string", n = 1L)
sort(tags.c, decreasing = TRUE)
head(sort(tags.t, decreasing = TRUE), n = 20)

write.csv(tags.c[-1], "data/london-categories.csv")


# -------------------------------
# World Bank
#--------------------------------
wb.full <- read.csv("data/world_bank_data_catalog.csv", stringsAsFactors = FALSE, na.strings = "")
wb <- wb.full[, c("Name", "Acronym", "Periodicity", "Update.Frequency", "Last.Revision.Date")]
# Remove empty rows
# wb <- wb[rowSums(is.na(wb)) != ncol(wb), ]
str(wb)
table(is.na(wb.full$Update.Frequency))
table(is.na(wb.full$Last.Revision.Date))

# Set "current" to current date
wb$Last.Revision.Date[wb$Last.Revision.Date %in% "Current"] <- "01/11/2013"

# Remove rows with missing dates and frequency because some dates are missingly legitimately
wb <- wb[!is.na(wb$Update.Frequency) | !is.na(wb$Last.Revision.Date), ]
ddply(wb, .(Update.Frequency), colwise(nmissing))

# As Dates
wb$last.revision  <- dmy(wb$Last.Revision.Date)
# A few more with the format "November, 2010"
wb$last.revision[is.na(wb$last.revision) == TRUE]  <- as.Date(paste("01", wb$Last.Revision.Date[is.na(wb$last.revision)==TRUE]), "%d %B, %Y")

# WHY does it start with 1905? Assume 2005!
# ACTION: Feed back to Worlp Bank []
wb <- wb[order(wb$last.revision), ]
wb$last.revision[which(wb$last.revision < as.POSIXct("1913-01-01"))] <- wb$last.revision[which(wb$last.revision < as.POSIXct("1913-01-01"))] + years(100)

# To lower for merging categories
wb$Update.Frequency <- as.factor(tolower(wb$Update.Frequency))
wb$Update.Frequency <- factor(wb$Update.Frequency, levels(wb$Update.Frequency)[rev(c(1, 2, 3, 8, 5, 9, 4, 6, 7))])

# Dates raw
# Binwidth in seconds, here 4 weeks
ggplot(data = wb[!is.na(wb$last.revision), ], aes(x = last.revision)) + 
  geom_histogram(fill = "#B42236", color = "white", binwidth = 7*24*60*60*4) + 
  geom_hline(yintercept = seq(5, 20, 5), col = "white", lwd = 0.7) +
 scale_x_datetime(breaks = date_breaks("1 year"), labels = date_format("%Y")) +
  xlab("Date of last revision")
ggsave("graphics/last-revision.png", height = 2.5, width = 8, dpi = 100)

table(year(wb$last.revision))

ggplot(data = wb[!is.na(wb$Update.Frequency), ], aes(x = Update.Frequency)) + 
  geom_histogram(fill = "#B42236") + xlab("Update frequency") +
  geom_text(aes(label=..count.., y = 0.55), stat = "bin", color = "white", size = 4) + 
  coord_flip() + theme(axis.ticks.y = element_blank())
ggsave("graphics/update-frequency.png", height = 2.5, width = 8, dpi = 100)

# Remove datasets with "No further updates planned" and missings
wb.noup <- wb[which(wb$Update.Frequency != "no further updates planned"), ]
# Remove factor level
wb.noup$Update.Frequency <- factor(wb.noup$Update.Frequency, exclude = NULL)

# Inspect update frequency for catalogues not updated in 2013
ggplot(data = wb.noup[which(wb.noup$last.revision < as.POSIXct("2013-01-01")), ], aes(x = Update.Frequency)) + 
  geom_histogram(fill = "#B42236") + xlab("Update frequency") +
  geom_text(aes(label=..count.., y = 0.5), stat = "bin", color = "white", size = 4) + 
  coord_flip() + theme(axis.ticks.y = element_blank()) + ylim(0, 30)
ggsave("graphics/update-frequency-not2013.png", height = 1.7, width = 8, dpi = 100)

summary(wb.noup$Update.Frequency[which(wb.noup$last.revision > as.POSIXct("2013-01-01"))])

#--------------
# Calculate the Bank's tau
# First we need to recode the frequency variable with some assumptions
            
# Being generous here
wb.noup$freq.days <- recode(wb.noup$Update.Frequency, as.factor.result = FALSE, 
                          " 'no fixed schedule' = 730;
                            'daily' = 1;
                            'weekly' = 7;
                            'monthly' = 31; 
                            'quarterly' = 92;
                            'biannually' = 183;
                            'annually' = 365;
                            'annual +' = 1000; ")

# Calculate tau
# Allow for a number of days to refresh
leeway <- 40
wb.noup$today <- as.POSIXct("2013-11-05")
wb.noup$days.diff <- as.numeric(wb.noup$today - wb.noup$last.revision)
wb.noup$ratio <- (wb.noup$freq.days + leeway) / wb.noup$days.diff
wb.noup$indicator <- 0 
wb.noup$indicator[which(wb.noup$ratio >= 1)] <- 1

round(mean(wb.noup$indicator), 2)
ddply(wb.noup, .(Update.Frequency), summarise, tau = round(mean(indicator), 2), count = length(indicator))

# -------------------------------
# UK Data Store
#--------------------------------
# Fuck this data dump, so many rogue rows. 
# Deleted lots of columns, only caused problems
# Piped through google refine for update frequency
# --------
# library(data.table)
# library(colbycol)
#gov.full <- read.csv("data/data.gov.uk-ckan-meta-data-2013-11-11.csv", stringsAsFactors = FALSE, na.strings = "")
#gov.full <- fread("data/data.gov.uk-ckan-meta-data-2013-11-11.csv", stringsAsFactors = FALSE, na.strings = "", nrows = 1)

# gov <- gov.full[, c("title", "metadata_modified", "update_frequency", "date_released", "date_updated", "metadata.date", "frequency.of.update")]
gov <- read.csv("data/data.gov.uk-ckan-meta-data-2013-11-11-short-refined.csv", stringsAsFactors = FALSE, na.strings = "")
str(gov)

# Parse times
dates <- c("last_major_modification", "metadata_created", "metadata_modified")
gov$last_major_modification <- ymd_hms(gov$last_major_modification)
gov$metadata_created <- ymd_hms(gov$metadata_created)
gov$metadata_modified <- ymd_hms(gov$metadata_modified)

# Missing
sapply(gov, function(x) table(is.na(x)))
summary(gov[dates])

# What is spelled consistently? (Hint: nothing. -- Fine, some things.)
head(sort(table(gov$update_frequency), decreasing = TRUE), n = 30)
head(sort(table(gov$license), decreasing = TRUE), n = 10)

# Remove unpublished and misc!
gov.clean <- gov[gov[, "license"] != "unpublished", ]
gov.clean <- gov.clean[gov.clean[, "update_frequency"] != "No plans to update at present", ]
gov.clean <- gov.clean[gov.clean[, "update_frequency"] != "Not applicable", ]
gov.clean <- gov.clean[gov.clean[, "update_frequency"] != "never", ]
gov.clean <- gov.clean[gov.clean[, "update_frequency"] != "n/a", ]
gov.clean <- gov.clean[gov.clean[, "update_frequency"] != "discontinued", ]
gov.clean <- gov.clean[gov.clean[, "update_frequency"] != "once", ]


gov.clean$update_frequency <- tolower(gov.clean$update_frequency)                       
head(sort(table(gov.clean$update_frequency), decreasing = TRUE), n = 30)


# Being generous here
gov.clean$freq.days  <- NA
gov.clean$freq.days <- as.numeric(recode(gov.clean$update_frequency, as.factor.result = FALSE, 
                            " 'half-hourly' = 1;
                            'hourly' = 1;
                            'daily' = 1;
                            'weekly' = 7;
                            'monthly' = 31; 
                            'quarterly' = 92;
                            'biannually' = 183;
                            'every 6 months' = 183;
                            '6 months' = 183;
                            'every six months' = 183;
                            'six monthly' = 183;
                            '6 monthly' = 183;
                            'twice yearly' = 183;
                            'twice a year' = 183;
                            'annually' = 365;
                            'annual' = 365;
                            'varied' = 365;
                            'various' = 365;
                            'other' = 365;
                            'as required' = 365;
                            'as needed' = 365;
                            'as needed depending on legislative changes' = 365;
                            'yearly' = 365;
                            '2 years' = 730;
                            'every two years' = 730;
                            'every 10 years' = 3652; "))

# Count missing
table(is.na(gov.clean$freq.days))
table(is.na(gov.clean$update_frequency))


# Plots
ggplot(data = gov.clean, aes(x = last_major_modification)) + geom_histogram(color = "white", binwidth = 30*24*60*60)
ggsave("graphics/gov-last-major-modification.png", height = 1.7, width = 8, dpi = 100)

ggplot(data = gov.clean, aes(x = metadata_created)) + geom_histogram(color = "white", binwidth = 30*24*60*60)
ggsave("graphics/gov-metadata-created.png", height = 1.7, width = 8, dpi = 100)

ggplot(data = gov.clean, aes(x = metadata_modified)) + geom_histogram(color = "black", binwidth = 24*60*60)
ggsave("graphics/gov-metadata-modified.png", height = 1.7, width = 8, dpi = 100)

# Drop datasets with no update frequency
gov.nomi <- gov.clean[which(is.na(gov.clean$freq.days) == FALSE), ]

# Calculate tau
# Allow for a number of days to refresh
# Leeway also defind above, this is bad practice
leeway  <- 40
gov.nomi$today <- as.POSIXct("2013-11-15")
gov.nomi$days.diff <- as.numeric(gov.nomi$today - gov.nomi$last_major_modification)
gov.nomi$ratio <- (gov.nomi$freq.days + leeway) / gov.nomi$days.diff
gov.nomi$indicator <- 0 
gov.nomi$indicator[which(gov.nomi$ratio >= 1)] <- 1

round(mean(gov.nomi$indicator), 2)
leeway
ddply(gov.nomi, .(freq.days), summarise, tau = round(mean(indicator), 2), count = length(indicator))

