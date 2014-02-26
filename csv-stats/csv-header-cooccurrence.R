setwd("~/git/R-projects/csv-stats")
load("workinprogress-2014-02-17.RData")
library(data.table)
library(igraph)
library(plyr)


test.list <- list(unique.headers[[1]], unique.headers[[2]], unique.headers[[3]])
test.length <- llply(test.list, length)
unlist(lapply(seq_along(test.length), function(x) rep(x, test.length[[x]])))


# Initialise dataframe
coocc <- as.data.frame(matrix(ncol = 2, nrow = length(unlist(header.names))))
names(coocc) = c("dataset", "header")

coocc$header <- unlist(header.names)
# Add the dataset indeces
coocc$dataset <- unlist(lapply(seq_along(header.length), function(x) rep(x, header.length[[x]])))
head(coocc, n = 50)

# Enconding problem with £ --> (\xa3)