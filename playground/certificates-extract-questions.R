setwd("~/git/R-projects/playground")
require(RCurl)
require(jsonlite)

url <- 'https://certificates.theodi.org/datasets/schema?jurisdiction=gb'

certificates <- fromJSON(getURL(url))

#Extract list of question names from JSON dataframe
questions <- lapply(names(certificates), function(x) certificates[[x]][[1]])
questions <- unlist(questions)

#Test write to text file
writeLines(questions, 'cert-questions.txt')
