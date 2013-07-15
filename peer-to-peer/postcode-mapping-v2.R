setwd("/Users/Ulrich/Google Drive/Projects/p2p/Data/")
load("~/Google Drive/Projects/p2p/Data/Peer-to-peer/p2p-combined.Rdata")
source('~/Google Drive/Projects/p2p/Data/Peer-to-peer/functions.R')
library(data.table)
library(ggplot2)
library(ggthemes)
library(stringr)
theme_set(theme_bw())

# Aggregate files on individual loan level
p2p.len <- p2p[, list(total.loans = sum(loan.part.value), 
                          no.loan.parts = length(loan.part.value), 
                          originated = originated[1]
                          ), 
                   by=postcode.len]

p2p.bor <- p2p[, list(total.loans = sum(loan.part.value), 
                            no.loan.parts = length(loan.part.value), 
                            originated = originated[1]
                            ), 
                    by=postcode.bor]

# Read file with postcodes and Lat/Lon data
pcuk <- fread("/Users/Ulrich/Downloads/postcodes.csv")

# Sort files for merging
pcuk[, Postcode := clean.postcode(Postcode)]
setkey(pcuk, Postcode)
setkey(p2p.len, postcode.len)
setkey(p2p.bor, postcode.bor)

maps.len <- pcuk[p2p.len]
maps.bor <- pcuk[p2p.bor]
rm(p2p, pcuk)

             
# Discrete loan rates
summary(maps.len[, list(total.loans)])
maps.len[, loan.range := cut(total.loans, c(0, 1000, 5000, 10000, 50000, 1000000))]
table(maps.len[,list(loan.range)])

# As discrete variable
ggplot(aes(x=Longitude, y=Latitude), data=maps.len) + geom_point(aes(colour=loan.range), size=1) + 
  coord_cartesian(c(-8, 2.5), c(49, 61)) +
  theme_tufte() +
  theme(axis.text=element_blank(), axis.ticks=element_blank(), axis.title=element_blank(), legend.position="bottom") +
  scale_color_manual(values=c("#990099", "#B2ABD2", "#FDB863", "#E66101", "#E66771"), 
                     name=("Loan value in £"),
                     labels=c("< 1,000", "1,000-5,000", "5,000.01-10,000", "10,000.01-50,000", "> 50,000"))

# ggplot(aes(x=Longitude, y=Latitude), data=maps.len) + geom_point(colour = "darkblue", size=0.6) +
#   coord_cartesian(c(-8, 2.5), c(49, 61))
#   theme_tufte() + theme(axis.text=element_blank(), axis.ticks=element_blank(), axis.title=element_blank())

##############
# Lenders maps
looptime.len <- function(x){
  ggplot(aes(x=Longitude, y=Latitude), data=maps.len[originated < as.POSIXct(x)]) + 
    geom_point(colour="#558800", size=0.6) +
    ggtitle(paste0("Lenders from 2010-10-01 until ", x)) +
    coord_cartesian(c(-8, 2.5), c(49, 61)) + # consistent map size
    theme_tufte() + 
    theme(axis.text=element_blank(), axis.ticks=element_blank(), axis.title=element_blank())
  ggsave(filename = paste0("plots/maps/p2p-map-lenders-", x, ".png"), width=8.27, height=11.69) # A4
}

lapply(c("2010-12-31", "2011-06-30", "2011-12-31", "2012-06-30", "2012-12-31", "2013-05-31"), looptime.len)

#################
# Recipients maps
looptime.bor <- function(x){
  ggplot(aes(x=Longitude, y=Latitude), data=maps.bor[originated < as.POSIXct(x)]) + 
    geom_point(colour="#990099", size=0.6) +
    ggtitle(paste0("Recipients from 2010-10-01 until ", x)) + 
    coord_cartesian(c(-8, 2.5), c(49, 61)) + # consistent map size
    theme_tufte() + 
    theme(axis.text=element_blank(), axis.ticks=element_blank(), axis.title=element_blank())
  ggsave(filename = paste0("plots/maps/p2p-map-recipients-", x, ".png"), width=8.27, height=11.69)
}

lapply(c("2010-12-31", "2011-06-30", "2011-12-31", "2012-06-30", "2012-12-31", "2013-05-31"), looptime.bor)


