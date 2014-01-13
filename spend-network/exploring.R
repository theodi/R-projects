setwd("~/git/R-projects/spend-network")
source('~/git/R-projects/ODI-colours.R')
library(ggplot2)
theme_set(theme_minimal(base_family = "Helvetica Neue"))
options(stringsAsFactors = FALSE)
dta <- read.csv("tender_mean_time_frames_by_end_month_ANALYSIS_IM_v3.csv")

dta$sample.rates <- as.numeric(sub("%", "", dta$sample.rates))
ggplot(data = dta) + geom_histogram(aes(x = sample.rates), fill = lBlue, colour = "white")
