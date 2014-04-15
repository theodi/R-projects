source('~/git/R-projects/Quartile-frame-Scatterplot/qfplot.R')
source('~/git/R-projects/playground/fancyaxis.R')
require(ggplot2)
require(ggthemes)
theme_set(theme_minimal())
row.sample <- function(dta, rep) { dta[sample(1:nrow(dta), rep, replace=FALSE), ] }

ggplot(mtcars, aes(wt, mpg)) + geom_point() + theme_grey() 
ggplot(mtcars, aes(wt, mpg)) + geom_point() + geom_rangeframe() 


with(cars, plot(speed, dist, axes=FALSE))
with(cars, fancyaxis(1, summary(speed), digits=0))
with(cars, fancyaxis(2, summary(dist), digits=0))
axisstripchart(cars$speed, 1)
axisstripchart(cars$dist, 2)

asr <- row.sample(diamonds, 1000)
with(asr, plot(price, carat, axes=FALSE))
minimalrug(asr$price, side=1)
minimalrug(asr$carat, side=2)
axisstripchart(asr$price, 1)
axisstripchart(asr$carat, 2)
fancyaxis(1, summary(asr$price), digits=0)
fancyaxis(2, summary(asr$carat), digits=0)

qplot(speed, dist, data=cars) + theme_minimal()
with(cars, qfplot(speed, dist))


with(asr, qfplot(price, carat))
