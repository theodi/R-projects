setwd("~/git/R-projects/csv-stats")
library(stringr)
library(ggplot2)
library(data.table)
theme_set(theme_minimal(base_family = "Helvetica Neue"))
options(stringsAsFactors = FALSE)
source("~/git/R-projects/data-portal-analysis/functions.r")


# Probably move elsewhere and 'source'
# replace.empty <- function(dta, col) {
#   dta[dta[, col] == "", col] <- NA # set empty cells to missing
# } 

# data.table is lower case, may not be convention
gov <- as.data.table(read.csv("/Users/Ulrich/git/csv_finder/csv_urls.csv"))
# Count missing values, count empty fields
sapply(gov, no.missing)
sapply(gov, count.empty)

# WHY is this not working?!
# replace.empty(gov, "last_modified")
# gov[gov[, last_modified] == "", last_modified] <- NA
# Workaround
gov$last_modified[nchar(gov$last_modified) == 0]  <-  NA
gov$description[nchar(gov$description) == 0]  <-  NA

# Count unique entries
sapply(gov, function(x) length(unique(x)))

# Count missing values, count empty fields - after cleaning
sapply(gov, no.missing)
sapply(gov, count.empty)


# Count how many csv-files actually have a URL ending in .csv
table(str_detect(gov$url, "csv$"))
#FALSE  TRUE >> 3929 16763 
table(str_detect(gov$url, "^http"))
#FALSE  TRUE >> 8 20684
table(str_detect(gov$url, "^https"))
#FALSE  TRUE >> 17169  3523


read.url <- function(url, ...){
  temporaryFile <- tempfile()
  download.file(url, destfile = temporaryFile, method = "curl")
  url.data <- read.csv(temporaryFile, ...)
  return(url.data)
}

read.url(gov[1, url], nrow = 10, skip = 4)
