setwd("~/Desktop")
spend <- read.csv("Spend with SME.csv")
spend$DATE <- as.POSIXct(strptime(spend$DATE, "%d/%m/%Y"))

# In Million
spend$total <- spend$TOTAL / 1000000
spend$sme <- spend$SME.Spend / 1000000


### AAARGH - now solved
lm <- lm(total ~ DATE, data = spend)
summary(lm)

spend$index <- seq(1:length(spend$DATE))
lm <- lm(total ~ index, data = spend)
summary(lm)

plot(spend$index, spend$total, type = "l")
abline(lm, col="blue")

library(quantreg)
qr <- rq(total ~ DATE, data = spend, tau = 0.5)
qr


