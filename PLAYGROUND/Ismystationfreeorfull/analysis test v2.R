# Install packages first
library(plyr)
library(ggplot2)
library(ggthemes)
library(lubridate)

getwd()

# Also file cannot have scientific number formats
bikes.all <- read.csv("data_30apr13.csv", header=TRUE, sep = ",")

# Check data set
head(bikes.all)
names(bikes.all)
sapply(bikes.all, class)

# Smaller sample for faster testing
# bikes <- bikes.all[sample(1:dim(bikes.all)[1], size=1000),]
bikes <- bikes.all

# Calculate total bikes per station
bikes <- mutate(bikes, docks = BikesAvailable + EmptySlots)
bikes <- mutate(bikes, percent = round(EmptySlots / docks*100))

table(bikes$docks)
plot(table(bikes$docks))
# qplot(docks, data=bikes, binwidth = 1) + theme_tufte()

# Remove stations with less than 8 bikes
bikes <- bikes[bikes$docks >= 8, ]

# Create hour variable
bikes <- mutate (bikes, date=ymd_hms(date))
bikes <- mutate(bikes, hour = hour(date))
table(bikes$hour)

# ID 323 is Clifton Street
bikes.station <- bikes[bikes$id==323, ]

# Quick plot including LOESS
qplot(hour, EmptySlots, data=bikes.station, geom="jitter") + theme_bw() + stat_smooth(size = 2)

# Station name
station <- bikes.station$location[1]
# Hazard zone
hazard <- 75
rect1 <- data.frame (xmin=0, xmax=24, ymin=0, ymax=eval(100-hazard))
rect2 <- data.frame (xmin=0, xmax=24, ymin=hazard, ymax=100)

# Full ggplot chart
#      scale_y_continuous(limits=c(0, 100)) + coord_cartesian(xlim=c(0, 24)) +
p <- ggplot(bikes.station, aes(x=hour, y=percent)) +
     geom_point(shape=1, position=position_jitter(width=1,height=0)) +   # Use hollow circles and horizontal jitter
     geom_smooth(size=2) + 
     ylab("Percent free") + xlab("Hour") + 
     scale_y_continuous(breaks=seq(0, 100, 20)) + scale_x_continuous(breaks=seq(0, 24, 2)) +
     theme_minimal() +
     ggtitle(paste("Availability for", station)) 
plot(p) 

p + geom_rect(data=rect1, aes(xmin=0, xmax=24, ymin=0, ymax=eval(100-hazard)), fill='red', alpha = 0.2, inherit.aes = FALSE) + 
    geom_rect(data=rect2, aes(xmin=0, xmax=24, ymin=hazard, ymax=100), fill='blue', alpha = 0.2, inherit.aes = FALSE)
plot(p)

clifton.loess <- loess(percent ~ hour, bikes.station, model=T, span=0.25)
clifton.predict <- predict(clifton.loess)
summary(clifton.loess)

qplot(bikes.station$hour, clifton.predict) + ylim(0,100)

# Some stats per hour
ddply(bikes.station,~hour,summarise,mean=mean(percent),sd=sd(percent), n=length(percent))


##################
size.station <- max(bikes.station$docks)

p.no <- ggplot(bikes.station, aes(x=hour, y=empty)) +
  geom_point(shape=1, position=position_jitter(width=1,height=0)) +   # Use hollow circles and horizontal jitter
  geom_smooth(size=2) + 
  ylab("Free bike slots") + xlab("Hour") + 
  scale_y_continuous(breaks=seq(0, size.station, 2)) + scale_x_continuous(breaks=seq(0, 24, 2)) +
  geom_text(size=4, aes(label = c("0%","100%"), x = -1, y = c(0, size.station))) +
  theme_minimal() +
  theme(axis.ticks = element_blank()) +
  ggtitle(paste("Availability for", station)) 
plot(p.no) 


# For stackoverflow question
sl <- bikes.station[sample(1:dim(bikes.station)[1], size=100),c(6,14)]
dput(slots, control=NULL)
qplot(hour, EmptySlots, data=as.data.frame(sl), geom="jitter") + theme_bw() + stat_smooth(size = 2)

