setwd("~/git/R-projects/csv-stats")
load("workinprogress-2014-02-17.RData")
library(data.table)
library(plyr)
library(reshape2)
library(igraph)

# Headers have an enconding problem where £ --> (\xa3)
# Initialise dataframe
coocc <- as.data.frame(matrix(ncol = 2, nrow = length(unlist(header.names))))
names(coocc) = c("dataset", "header")
coocc$header <- unlist(header.names)
# Add the dataset indeces
coocc$dataset <- unlist(lapply(seq_along(header.length), function(x) rep(x, header.length[[x]])))
head(coocc, n = 50)
tail(coocc, n = 50)

# Export and open refine
write.csv(coocc, "co-occurrence/csv-coocc-out.csv")
# Clean LOADS of headers
# Re-import
coocc.clean <- read.csv("co-occurrence/csv-coocc-clean.csv", stringsAsFactors = FALSE)

# Remove duplicates
coocc.clean <- unique(coocc.clean)

# Only keep the top header names
top.headers <- names(header.table[1:50])
coocc.clean.top <- coocc.clean[which(coocc.clean$header %in% top.headers), ]



# Create matrix of header co-occurrence
# http://stackoverflow.com/questions/13281303/creating-co-occurrence-matrix
coocc.molt <- melt(coocc.clean.top)
w <- dcast(coocc.molt, header ~ value) # row.sample for testing
x <- as.matrix(w[, -1])
x[is.na(x)] <- 0
x <- apply(x, 2,  function(x) as.numeric(x > 0))  #recode as 0/1
v <- x %*% t(x)                                   #the magic matrix 
diag(v) <- 0                                      #replace diagonal
dimnames(v) <- list(w[, 1], w[,1])                #name the dimensions

# Get rid of all empty rows or columns
gephi <- v[rowSums(v) != 0, ]
gephi <- gephi[, apply(gephi, 2, sum) != 0]

write.csv(gephi, "co-occurrence/header-coocc.csv")


# Transform dataframe into a graph
g <- graph.adjacency(v, weighted = TRUE, mode = 'undirected')
g <- simplify(g)
gephi.gr <- graph.data.frame(g, directed = FALSE);

# Write to a GraphML file
write.graph(g, file = "co-occurrence/header-coocc.graphml", format = "graphml")
