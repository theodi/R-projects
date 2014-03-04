setwd("~/git/R-projects/csv-stats")
library(RCurl)
library(stringr)
library(ggplot2)
library(scales)
library(data.table)
theme_set(theme_minimal(base_family = "Helvetica Neue"))
options(stringsAsFactors = FALSE)
options(RCurlOptions = list(timeout = 5, maxredirs = 1))
source("~/git/R-projects/data-portal-analysis/functions.r")
source('~/git/R-projects/ODI-colours.R')

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
table(str_detect(gov.csv$url, "^http"))
#FALSE  TRUE >>  4 16759
table(str_detect(gov.csv$url, "^https"))
#FALSE  TRUE >> 13594  3169

# Create csv only file
gov.csv <- gov[which(str_detect(gov$url, "csv$")), ]

# Size statistics and chart
summary(gov.csv$size)
ggplot(data = gov.csv, aes(x = size/1000)) + geom_histogram(fill = odi_turquoise, color = "white") + 
  scale_x_log10(labels = comma) + xlab("Size in kb") +
  theme(axis.title.x = element_text(hjust = 0.4), axis.text = element_text(size=14), axis.title = element_text(size=14))
ggsave(file="graphics/histogram-size-of-csvs.png", height = 2, width = 8, dpi = 100)

# Size ranking
head(na.omit(gov.csv$size[order(-rank(gov.csv$size))]), n = 20)

# Test whether URL exists
pb <- txtProgressBar(min = 1, max = nrow(gov.csv), style = 3)
for (i in 1:nrow(gov.csv)) {
  temp <- try(url.exists(gov.csv[i, url]))
  gov.csv[i, exists:=temp]
  setTxtProgressBar(pb, i)
}
close(pb)

# Percentages
table(gov$exists)
formatC( table(gov$exists) / nrow(gov) * 100, digits = 3)
table(gov.csv$exists)
formatC( table(gov.csv$exists) / nrow(gov.csv) * 100, digits = 3)

# Now option for data.table's fread
read.url <- function(url, func = "read.csv", ...){
  if (func %ni% c("read.csv", "fread")) stop("Function not recognised")
  temporaryFile <- tempfile()
  download.file(url, destfile = temporaryFile, method = "curl", quiet = TRUE)
  if (func == "read.csv") url.data <- read.csv(temporaryFile, ...)
  if (func == "fread") url.data <- fread(temporaryFile, ...)
  return(url.data)
}

# Error with wrong number of skip? (No, suspect only in exceptional circumstances such as encoding errors)
read.url(gov[1, url], nrow = 5, skip = 4)

# fread random test - produces better header names
read.url(gov[1819, url], func = "read.csv", nrows = 5)
names(read.url(gov[1819, url], func = "read.csv", nrows = 5))
names(read.url(gov[1819, url], func = "fread", nrows = 5))

# Collection of some errors
# curl: (60) SSL certificate problem: Invalid certificate chain
# curl: (6) Could not resolve host:  http
# curl: (56) Recv failure: Connection reset by peer
# Error in make.names(col.names, unique = TRUE) : invalid multibyte string at '<a3>25K<20>EXPENDITURE APRIL 2013'
# Redirects [1819] http://www.chre.org.uk/_img/pics/library/Copy_of_101018__CO_guidance_salary_disclosure_mgt_team.csv

# ------------------------------
# Must try set(), see ?":="

# Loop over csv URLs while trying to count the errors
# Filter out unresponsive URLs
setkey(gov.csv, exists)
gov.csv.exist <- gov.csv[J(TRUE)]
# Set silent = FALSE to show error messages.
# nrow(gov.csv.exist)
pb <- txtProgressBar(min = 5001, max = nrow(gov.csv.exist), style = 3)
for (i in 1:99) {
  temp <- try(read.url(gov.csv.exist[i, url], func = "fread", nrow = 2, skip = 0), silent = TRUE)
  if(inherits(temp, "try-error")) tempbool <- 1
  else tempbool <- 0
  gov.csv.exist[i, error:=tempbool]
  setTxtProgressBar(pb, i)
}
close(pb)

# curl: (7) Failed connect to www.cafcass.gov.uk - website was down?
# curl: (7) Failed connect to www.walsallhealthcare.nhs.uk- website was down?

table(gov.csv.exist$error)
#     0     1 
# 11696  1132 

# ------------------------------
# Loop over csv URLs reading header names
# If a header name is empty it will start with X
setkey(gov.csv.exist, error)
gov.csv.noerror <- gov.csv.exist[J(0)]
# Set silent = FALSE to show error messages.
# Adds file encoding to escape "invalid multibyte string"
# nrow(gov.csv.noerror)
pb <- txtProgressBar(min = 5001, max = nrow(gov.csv.noerror), style = 3)
for (i in 5001:nrow(gov.csv.noerror)) {
  temp <- try(read.url(gov.csv.noerror[i, url], func = "read.csv", nrow = 12, skip = 0, fileEncoding="latin1"), silent = FALSE)
  dat.names <- names(temp)
  if (!is.null(dat.names)) {
    tempboolnull <- 0
    if (str_detect(tail(dat.names, 1), "^X")) tempbool <- 1
    else tempbool <- 0
    gov.csv.noerror[i, last.header:=tail(dat.names, 1)]
    gov.csv.noerror[i, header.reg:=tempbool]
  }
  else tempboolnull <- 1
  gov.csv.noerror[i, no.names:=tempboolnull]
  setTxtProgressBar(pb, i)
}
close(pb)

# 41-44 more columns than column names
# Warnings: incomplete final line found by readTableHeader

table(gov.csv.noerror$header)
table(gov.csv.noerror$no.names)

# Some broken CSVs are still sometimes included. Filter if last.header is too long
gov.csv.noerror[, flag.broken:=0]
gov.csv.noerror[nchar(last.header) > 100, flag.broken:=1]

table(gov.csv.noerror$flag.broken, gov.csv.noerror$header.reg)

gov.csv.noerror[, not.machine:=header.reg]
gov.csv.noerror[flag.broken == 1, not.machine:=1]
gov.csv.noerror[is.na(header.reg), not.machine:=1]

table(gov.csv.noerror$not.machine)

# ------------------------------
# Finally MACHINE-READABLE CSVs?
setkey(gov.csv.noerror, not.machine)
gov.csv.machine <- gov.csv.noerror[J(0)]

# Loop over CSVs that collects all header names in a single list
# nrow(gov.csv.machine)
header.names <- list()
pb <- txtProgressBar(min = 1, max = nrow(gov.csv.machine), style = 3)
for (i in 1:nrow(gov.csv.machine)) {
  temp <- try(read.url(gov.csv.machine[i, url], func = "fread", nrow = 1, skip = 0), silent = FALSE)
  temp.list <- as.list(names(temp))
  header.names[[length(header.names) + 1]] <- temp.list
  setTxtProgressBar(pb, i)
}
close(pb)
rm(list = c("temp", "i", "temp.list"))

# Count various header names
unique.headers <- lapply(header.names, unique)
flat.headers <- unlist(unique.headers, use.names = FALSE)

# Export for open refine
write.csv(flat.headers, "csv-headers.csv")
# Clean LOADS of headers
# Re-import
clean.headers <- read.csv("csv-headers-clean.csv")
clean.headers  <- unlist(clean.headers[, -1])

header.table <- sort(table(clean.headers), decreasing = TRUE)
head(header.table, n = 20)

write.csv(header.table, "header-counts-clean.csv")

# Some header stats
summary(sapply(header.names, length))
header.length <- sapply(header.names, length)

ggplot(as.data.frame(header.length), aes(x = header.length)) + 
  geom_histogram(binwidth = 1, color = "white", fill = odi_turquoise) + coord_cartesian(xlim = c(0, 100)) +
  geom_text(data = as.data.frame(mode.stat(header.length)), x = 20, y = 1350, label = "Mode = 8") +
  xlab("Number of columns") +
  theme(axis.text = element_text(size = 14), axis.title = element_text(size = 14))
ggsave("graphics/header-length-histogram.png", height = 3, width = 8, dpi = 100)


#----------------------------
# More graphics for publication
overall.stats <- fread("datawrapper-overall-stats.csv")
ggplot(data = overall.stats[-4, ], aes(x = reorder(description, number), y = number)) + 
  geom_bar(stat = 'identity', fill = odi_turquoise, color = "white") + coord_flip() + xlab("") + ylab("") + 
  geom_text(aes(label = number, y = 1400), stat = "identity", color = "white", size = 5) + 
  theme(axis.ticks.y = element_blank(), axis.text = element_text(size=14))
ggsave(file="graphics/overall-stats.png", height = 2, width = 8, dpi = 100)


read.url(gov.csv.noerror[42, url], func = "read.csv", nrow = 5, skip = 0, fileEncoding="latin1", comment.char="")
