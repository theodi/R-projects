setwd("~/git/R-projects/playground/weather-centuries")
library(data.table)
library(ggplot2)
library(lubridate)
library(gridExtra)
theme_set(theme_minimal(base_family = "Helvetica Neue"))
options(stringsAsFactors = FALSE)

source("calendarHeat.R")

# Load data as data table, drop first column and recognise dates
cen <- fread("daily_min_mean_max.csv")
cen <- cen[, -1, with=FALSE]
cen$iso8601 <- as.POSIXct(cen$iso8601)
str(cen)

summary(cen)

ggplot(data = cen) + xlab("Temperature in °C") +
  geom_histogram(aes(y = ..density.., x = cetmindly1878on_urbadj4.dat), color = "white", fill = "steelblue", alpha=1/3) + 
  geom_histogram(aes(y = ..density.., x = cetdl1772on.dat), color = "white", fill = "green", alpha=1/3) + 
  geom_histogram(aes(y = ..density.., x = cetmaxdly1878on_urbadj4.dat), color = "white", fill = "red", alpha=1/3)
ggsave("temp-histogram.png")

# Calendar plot
pdf('heatmap-temp-2012.pdf')
calendarHeat(cen[iso8601 > as.POSIXct("2012-01-01"), iso8601], cen[iso8601 > as.POSIXct("2012-01-01"), cetdl1772on.dat], color="r2b")
dev.off()

# Heatmap
cen <- transform(cen, week = week(iso8601),
                      wday = wday(iso8601, label = TRUE, abbr = FALSE),
                      year = year(iso8601) )
table(cen$wday)
correct.week <- c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")

heatmap <- ggplot(cen[iso8601 > as.POSIXct("2000-01-01"), ], aes(week, wday, fill = cetdl1772on.dat)) +
  geom_tile(colour = "white") + 
  scale_fill_gradientn(colours = c("#99CCFF","#FFFFBD","#FFAE63","#FF6600")) + 
  facet_wrap(~ year, ncol = 1) +
  theme(strip.background = element_blank(), panel.margin = unit(0, "lines"), 
          axis.ticks = element_blank(), axis.text.x = element_blank(), axis.text.y=element_text(size=6) ) +
  ylab("Weekdays") + xlab("Weeks") +
  scale_y_discrete(limits= rev(correct.week)) +
  ggtitle("Temperature in °C")

ggsave(heatmap, file="heatmap.pdf", width=6, height=10)


