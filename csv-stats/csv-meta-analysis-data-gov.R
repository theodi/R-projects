setwd("~/git/R-projects/csv-stats")
library(RCurl)
library(stringr)
library(ggplot2)
library(data.table)
theme_set(theme_minimal(base_family = "Helvetica Neue"))
options(stringsAsFactors = FALSE)
source("~/git/R-projects/data-portal-analysis/functions.r")

### Note to self: I AM USING DATA TABLE
# data.table is lower case, may not be convention
gov <- as.data.table(read.csv("/Users/Ulrich/git/csv_finder/csv_urls.csv", na.strings = ""))
# Count missing values, count empty fields, count unique entries
sapply(gov, no.missing)
sapply(gov, count.empty)
sapply(gov, count.unique)
sapply(gov, pct.unique)

# Count how many csv-files actually have a URL ending in .csv
table(str_detect(gov$url, "csv$"))
#FALSE  TRUE >> 3929 16763 
table(str_detect(gov$url, "^http"))
#FALSE  TRUE >> 8 20684
table(str_detect(gov$url, "^https"))
#FALSE  TRUE >> 17169  3523

# Now option for data.table's fread
read.url <- function(url, func = "read.csv", ...){
  if (func %ni% c("read.csv", "fread")) stop("Function not recognised")
  temporaryFile <- tempfile()
  download.file(url, destfile = temporaryFile, method = "curl", quiet = TRUE)
  if (func == "read.csv") url.data <- read.csv(temporaryFile, ...)
  if (func == "fread") url.data <- fread(temporaryFile, ...)
  return(url.data)
}

# Error with wrong number of skip
read.url(gov[1, url], func = "read.csv", nrow = 10, skip = 4)

# fread
read.url(gov[1819, url], nrows = 2)

nrow(gov)

# Loop over csv URLs while trying to count the errors
# Set silent = FALSE to show error messages.
pb <- txtProgressBar(min = 0, max = nrow(gov), style = 3)
for (i in 1819:1820) {
  temp <- try(read.url(gov[i, url], func = "read.csv", nrow = 2, skip = 0),  silent = TRUE)
  if(inherits(temp, "try-error")) tempbool <- 1
  else tempbool <- 0
  gov[i, error := tempbool]
  setTxtProgressBar(pb, i)
}
close(pb)

table(gov$error)

# curl: (60) SSL certificate problem: Invalid certificate chain
# curl: (6) Could not resolve host:  http
# curl: (56) Recv failure: Connection reset by peer
# Error in make.names(col.names, unique = TRUE) : invalid multibyte string at '<a3>25K<20>EXPENDITURE APRIL 2013'
# Redirects [1819] http://www.chre.org.uk/_img/pics/library/Copy_of_101018__CO_guidance_salary_disclosure_mgt_team.csv


