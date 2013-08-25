getwd()
setwd("/Users/ulrich/downloads")

gmail <- read.csv("ODI Gmail - Sheet1.csv", stringsAsFactors = FALSE)
mails <- read.csv("gmail-odi2.csv", stringsAsFactors = FALSE)


head(gmail)
head(mails)
#Check whether variables are the right type
sapply(gmail, class)
sapply(mails, class)

#Help function "?"
?read.csv

names(gmail)
mean(gmail$Number.of.emails.received.by.them)
mean(gmail$Number.of.emails.sent.to.them)

#Perhaps a better average?
median(gmail$Number.of.emails.received.by.them)
median(gmail$Number.of.emails.sent.to.them)

#All in one go and more
summary(gmail$Number.of.emails.received.by.them)
summary(gmail$Number.of.emails.sent.to.them)

#Case sensitive names and functions
#Searching for specific people
gmail[gmail$People == "jeni@theodi.org", ]
gmail.sort <- gmail[order(-gmail$Number.of.emails.received.by.them), ]
gmail.sort[grep("theodi.org", gmail.sort$People), ]

#A skew to the right
plot(table(gmail$Number.of.emails.received.by.them))
plot(density(gmail$Number.of.emails.received.by.them))

#Better graphics --------------------------------------------
install.packages("ggplot2")
library(ggplot2)

#A quick plot
qplot(Number.of.emails.received.by.them, data = gmail)
#Automatic scatterplot
qplot(Number.of.emails.received.by.them, Number.of.emails.sent.to.them, data = gmail)

#A more complex graphic
p <- ggplot(aes(Number.of.emails.received.by.them, Number.of.emails.sent.to.them), data = gmail) 
p + geom_point()
p + geom_point() + scale_x_log10()
p + scale_x_log10() + geom_text(aes(label=People))
#More fun with it
p + scale_x_log10() + geom_text(aes(label=People), angle = 45)
p + scale_x_log10() + geom_text(aes(label=People), size = 1)
p + scale_x_log10() + geom_text(aes(label=People), size = 3)

#The magic line - first we zoom in
p + geom_point() + xlim(0, 100)
p + geom_point() + xlim(0, 80) + geom_abline(intercept = 0, slope = 1, linetype = 2) + geom_text(aes(label=People), size = 3, hjust = -0.05)

#Let's do some stats ---------------------------
#Equal amount woud be 1
gmail$ratio <- gmail$Number.of.emails.sent.to.them / gmail$Number.of.emails.received.by.them
head(gmail, 10)
plot(table(gmail$ratio))

# Hint of an exponential pattern
qplot(ratio, data = gmail, binwidth = 0.1, log = "x")

#Very wrong name - but useful idea
gmail$gini <- log10(gmail$ratio)

plot(density(gmail$gini))



