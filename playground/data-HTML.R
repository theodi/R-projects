library(XML)
url <-  "http://en.wikipedia.org/wiki/Economy_of_Scotland"
scot <- readHTMLTable(readLines(url), which=2, header=TRUE, skip.rows=11)


