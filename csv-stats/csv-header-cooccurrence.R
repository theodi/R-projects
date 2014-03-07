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
head(coocc, n = 20)
tail(coocc, n = 20)

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
x <- apply(x, 2,  function(x) as.numeric(x > 0))  # recode as 0/1
v <- x %*% t(x)                                   # the magic matrix 
diag(v) <- 0                                      # replace diagonal
dimnames(v) <- list(w[, 1], w[, 1])               # name the dimensions

# Get rid of all empty rows or columns
gephi <- v[rowSums(v) != 0, ]
gephi <- gephi[, apply(gephi, 2, sum) != 0]

write.csv(gephi, "co-occurrence/header-coocc.csv")

# Transform dataframe into a graph
g <- graph.adjacency(v, weighted = TRUE, mode = 'undirected')
g <- simplify(g)
plot(g)

# Write to a GraphML file
write.graph(g, file = "co-occurrence/header-coocc.graphml", format = "graphml")

#-----------------------
# Headers without three types of dataset approx. by main variable
exclude <- c("Expense Type", "Expenses Type", "Convictions Percentage", "Reports to Senior Post", "Post Unique Reference")

coocc.clean <- as.data.table(coocc.clean)
setkey(coocc.clean, dataset)

# This creates a flag if the header matches and then assigns T/F to all rows per dataset.
coocc.clean.prune <- coocc.clean[, drop.flag := sum(as.numeric(header %in% exclude)) > 0, by = dataset]

setkey(coocc.clean.prune, drop.flag)
coocc.clean.ex  <- coocc.clean.prune[J(FALSE)]
coocc.clean.ex <- coocc.clean.ex[, drop.flag := NULL]

header.table.ex <- sort(table(coocc.clean.ex$header), decreasing = TRUE)

# There are headers which were empty fields b/c of inaccuracies, rm via grep (e.g., V4, V27)
header.table.ex <- header.table.ex[-(grep("V[0-9]{1,2}", names(header.table.ex)))]
header.table.ex <- header.table.ex[-grep("<html>", names(header.table.ex))] # Drop <html> artefact

# Some other artefacts that shoud've been removed earlier
header.table.ex <- header.table.ex[-grep("The resource you are looking for has been removed", names(header.table.ex))]
header.table.ex <- header.table.ex[-grep(" had its name changed", names(header.table.ex))]
header.table.ex <- header.table.ex[-grep(" or is temporarily unavailable.", names(header.table.ex))]

top.headers.ex <- names(header.table.ex[1:200])
top.headers.ex
coocc.clean.top.ex <- coocc.clean.ex[which(coocc.clean.ex$header %in% top.headers.ex), ]

coocc.molt.ex <- melt(coocc.clean.top.ex)
w <- dcast(coocc.molt.ex, header ~ value) # row.sample for testing
x <- as.matrix(w[, -1])
x[is.na(x)] <- 0
x <- apply(x, 2,  function(x) as.numeric(x > 0))  # recode as 0/1
v <- x %*% t(x)                                   # the magic matrix 
diag(v) <- 0                                      # replace diagonal
dimnames(v) <- list(w[, 1], w[, 1])               # name the dimensions

# Get rid of all empty rows or columns
gephi <- v[rowSums(v) != 0, ]
gephi <- gephi[, apply(gephi, 2, sum) != 0]

write.csv(gephi, "co-occurrence/header-coocc-excl-popular.csv")

# Transform dataframe into a graph
g <- graph.adjacency(v, weighted = TRUE, mode = 'undirected')
g <- simplify(g)
plot(g)
# Experimental 3D
# rglplot(g, vertex.color= odi_turquoise, vertex.size = 3)

# Write to a GraphML file
write.graph(g, file = "co-occurrence/header-coocc-excl-popular.graphml", format = "graphml")


# Having a look at some particular datasets
gov.csv.machine[6780]
gov.csv.machine$description[coocc.clean.ex$dataset[grep("Notarial Acts", coocc.clean.ex$header)]]
# Foreign Office Consular
# http://data.gov.uk/dataset/foreign-office-consular-data 
# 38 months

# Metoffice Latest 24 hours observational data - Marine
# http://data.gov.uk/dataset/latest-marine-observational-data
# 46 regions
gov.csv.machine[367]
coocc.clean.ex$dataset[grep("humidity", coocc.clean.ex$header)]

# Workforce Management Information - BIS
coocc.clean.ex$dataset[grep("payroll", coocc.clean.ex$header)]


