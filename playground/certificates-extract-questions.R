setwd("~/git/R-projects/playground")
require(RCurl)
require(jsonlite)

url <- 'https://certificates.theodi.org/datasets/schema?jurisdiction=gb'

certificates <- fromJSON(getURL(url))

#Extract list of question names from JSON dataframe
questions <- lapply(names(certificates), function(x) certificates[[x]][[1]])
questions <- as.vector(unlist(questions))

#Extract responses as last item in list (reverse function)
responses <- lapply(names(certificates), function(x) rev(certificates[[x]])[[1]])
responses <- as.vector((responses))


#Test write to text file
writeLines(questions, 'cert-questions.txt')
