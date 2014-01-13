setwd("~/git/R-projects/UK-opinion-polls")
library(XML)
library(stringr)
library(ggplot2)
theme_set(theme_minimal())
url <-  "http://en.wikipedia.org/wiki/Opinion_polling_for_the_next_United_Kingdom_general_election"

# Need clean names function
clean.names <- function(x) {
  y <- str_trim(colnames(x))
  y <- gsub("\\s", ".", y)
  y <- str_replace_all(y, "[[:punct:]]", ".")
  y <- tolower(y)
  return(y)
}


# Extract date from range for sorting
# Such a mess to find the right "-" symbol 
# Opional \\s? for whitespace after dash not needed
end.date <- function(x, yr) {
  y  <- as.Date(paste(gsub(".+(–|-)", "", x), as.character(yr)), format = "%d %b %Y")
  return(y)
}

# Some lines are subheaders, remove
# Formats vary and sometimes include non-numeric
extract.tables <- function(url, num, year) {
  x <- readHTMLTable(readLines(url), which = num, header = TRUE, stringsAsFactors = FALSE)
  colnames(x) <- clean.names(x)
  x <- x[!is.na(x$sample.size), ]
  x[, "polling.organisation.client"] <- as.factor(str_trim(x[, "polling.organisation.client"]))
  x[, "sample.size"] <- as.numeric(gsub(",", "", x[, "sample.size"]))
    percent <- c("cons", "lab", "lib.dem", "ukip", "others")
  x[, percent] <- lapply(x[, percent], function(z) {as.numeric(sub("%", "", z))})
  x[x$lead == "Tied", "lead"]  <- 0
  x[is.na(x$ukip) == TRUE, "ukip"]  <- 0
  x[, "lead"] <- as.numeric(sub("%", "", x[, "lead"]))
  x[, "sortdate"] <- end.date(x[, "date.s..conducted"], year)
  x[, "year"] <- year
  return(x)
}

polls2014 <- extract.tables(url, 1, 2014)
polls2013 <- extract.tables(url, 2, 2013)
polls2012 <- extract.tables(url, 3, 2012)
polls2011 <- extract.tables(url, 4, 2011)
polls2010 <- extract.tables(url, 5, 2010)

# Exclude general election results
polls2010 <- polls2010[polls2010$sample.size < 20000000, ]

polls  <- rbind(polls2014, polls2013, polls2012, polls2011, polls2010)

# Sort by date
polls  <- polls[order(polls$sortdate), ]

# Remove missings
sapply(polls, function(x) table(is.na(x)))

# For debugging
x <- polls2013

# Can be improved by taking the average of the last few polls
today  <-  polls[polls$sortdate == max(polls$sortdate), c("cons", "lab", "lib.dem", "ukip", "others")]

p <- ggplot(polls, aes(x = sortdate)) + 
  geom_point(aes(y = cons), color = "blue", alpha = 1/4) + 
  geom_point(aes(y = lab), color = "red", alpha = 1/4) +
  geom_point(aes(y = lib.dem), color = "orange", alpha = 1/4) +
  geom_point(aes(y = ukip), color = "purple", alpha = 1/4) +
  geom_point(aes(y = others), color = "gray", alpha = 1/4) + 
  geom_smooth(aes(y = cons), color = "blue", se = FALSE, method = loess, span = 0.1, size = 1) + 
  geom_smooth(aes(y = lab), color = "red", se = FALSE, method = loess, span = 0.1, size = 1) + 
  geom_smooth(aes(y = lib.dem), color = "orange", se = FALSE, method = loess, span = 0.1, size = 1) + 
  geom_smooth(aes(y = ukip), color = "purple", se = FALSE, method = loess, span = 0.1, size = 1) + 
  geom_smooth(aes(y = others), color = "gray", se = FALSE, method = loess, span = 0.1, size = 1) +
  ylab("Percentage") + xlab("Date") + ggtitle("Opinion polls for the UK General Election (2010 - today)") +
  annotate("text", x = as.Date("2011-07-01"), y = 32, label = "Conservatives", size = 5, color = "blue") + 
  annotate("text", x = as.Date("2012-01-01"), y = 45, label = "Labour", size = 5, color = "red") + 
  annotate("text", x = as.Date("2011-02-01"), y = 15, label = "Liberal Democrats", size = 5, color = "darkorange") +
  annotate("text", x = as.Date("2013-02-01"), y = 15, label = "UKIP", size = 5, color = "purple") + 
  annotate("text", x = as.Date("2010-07-01"), y = 9, label = "Other", size = 5, color = "grey50") +
  geom_vline(xintercept = as.numeric(max(polls$sortdate)), color = "grey50", size = 0.5) +
  geom_text(data = today, aes(x = max(polls$sortdate), y = today[1, "cons"], label = today[1, "cons"]), hjust = -0.5) +
  geom_text(data = today, aes(x = max(polls$sortdate), y = today[1, "lab"], label = today[1, "lab"]), hjust = -0.5) + 
  geom_text(data = today, aes(x = max(polls$sortdate), y = today[1, "lib.dem"], label = today[1, "lib.dem"]), hjust = -0.5) +
  geom_text(data = today, aes(x = max(polls$sortdate), y = today[1, "ukip"], label = today[1, "ukip"]), hjust = -0.5) +
  geom_text(data = today, aes(x = max(polls$sortdate), y = today[1, "others"], label = today[1, "others"]), hjust = -2)

p

ggsave("trends.pdf")
ggsave("trends.png")

write.csv(polls, "UK-opinion-polls.csv", row.names = FALSE, fileEncoding = "macroman")

# Don't encode images
knit2html("tutorial.Rmd", options=c("use_xhtml","smartypants","mathjax","highlight_code"))

#   annotate("text", x = max(polls$sortdate), y = 0, label = max(polls$sortdate), size = 3, vjust = 2)

  

