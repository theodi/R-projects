source('~/git/Quartile-frame-Scatterplot/qfplot.R')
source('~/git/R-projects/playground/fancyaxis.R')


with(cars, plot(speed, dist, axes=FALSE))
with(cars, fancyaxis(2, summary(dist), digits=0))
with(cars, fancyaxis(1, summary(speed), digits=0))

qplot(speed, dist, data=cars) + theme_minimal()
with(cars, qfplot(speed, dist))