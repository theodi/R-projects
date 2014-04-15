setwd("/Users/Ulrich/git/R-projects/marriage-rCharts")

age <- read.csv("mean-age.csv", stringsAsFactors = FALSE)
str(age)

library(reshape2)
agemelt <- melt(age, "Year")

library(plyr)
agemelt$variable <- revalue(agemelt$variable, c("Husband"="Men", "Wife"="Women"))

library(rCharts)
r1 <- rPlot(value ~ Year, data = agemelt, type = 'line')
m1 <- mPlot(x = 'Year', y = c('Husband', 'Wife'), type = 'Line', data = age)
n1 <- nPlot(value ~ Year, group = "variable", data = agemelt, type = 'lineChart')
n1$print()