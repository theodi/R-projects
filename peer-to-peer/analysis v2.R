setwd("/Users/Ulrich/Google Drive/Projects/p2p/Data/")
load("~/Google Drive/Projects/p2p/Data/Peer-to-peer/p2p-combined.Rdata")
source('~/Google Drive/Projects/p2p/Data/Peer-to-peer/functions.R')
library(data.table)
library(Hmisc)
library(ggplot2)
library(stringr)
theme_set(theme_minimal())

# Create weights
describe(p2p[,length(loan.part.value), by = list(loan.id)])

weights  <- p2p[, list(1/length(loan.part.value)), by = list(loan.id)]
weights[, weights := V1/mean(V1) ]
weights[, V1 := NULL]
setkey(weights, loan.id)

# Check if weights are sensible
describe(weights$weights)
ggplot(weights, aes(y=weights, x="all")) + geom_boxplot() + coord_trans(y = "log10") + theme(axis.title.x=element_blank()) +
  scale_y_continuous(breaks=c(0.01, 0.1, 1, 2.5, 5, 7.5, 10))

###########
# Overall statistics
describe(p2p[,list(loan.part.value)])


# Overall
# Aggregate files on individual loan level
p2p.lenders <- p2p[, list(region.len=region.len[1], area.len=area.len[1], total.loans = sum(loan.part.value), no.loan.parts=length(loan.part.value)), by=postcode.len]
p2p.borrowers <- p2p[, list(region.bor=region.bor[1], area.bor=area.bor[1], total.loans = sum(loan.part.value), no.loan.parts=length(loan.part.value)), by=loan.id]

setkey(p2p.lenders, total.loans)
setkey(p2p.borrowers, total.loans)

p2p.lenders[, list(
  no.loan.parts = sum(no.loan.parts),
  no.lenders = length(postcode.len),
  avg.loan = mean(total.loans),
  median.loan = as.double(median(total.loans)),
  sd.loan = sd(total.loans),
  min.loan = min(total.loans),
  max.loan = max(total.loans),
  total.loans = sum(total.loans)
)]

p2p.borrowers[, list(
  no.loan.parts = sum(no.loan.parts),
  no.borrowers = length(loan.id),
  avg.loan = mean(total.loans),
  median.loan = as.double(median(total.loans)),
  sd.loan = sd(total.loans),
  min.loan = min(total.loans),
  max.loan = max(total.loans),
  total.loans = sum(total.loans)
)]

# Condition only for better charts
ggplot(p2p.lenders[total.loans>100], aes(y=total.loans, x="All investors")) + 
  geom_boxplot(colour = "cornflowerblue", outlier.colour=NULL, outlier.shape = 1) + 
  coord_trans(y = "log10") + theme(axis.title.x=element_blank()) +
  scale_y_continuous(breaks=c(500, 1000, 5000, 10000, 50000, 100000, 500000, 1000000), labels = mysep) + ylab("Loan amount in £")
ggsave(file="plots/boxplot-lenders.pdf", width=3, height=8)

ggplot(p2p.borrowers[total.loans>100], aes(y=total.loans, x="All recipients")) + 
  geom_boxplot(colour = "cornflowerblue", outlier.colour=NULL, outlier.shape = 1) + coord_trans(y = "log10") + 
  theme(axis.title.x=element_blank()) +
  scale_y_continuous(breaks=c(500, 1000, 5000, 10000, 50000, 100000, 250000, 1000000), labels = mysep) + ylab("Loan amount in £")
ggsave(file="plots/boxplot-borrowers.pdf", width=3, height=8)

###########
# Region

setkey(p2p, loan.id)
p2p.means.region  <- p2p[weights][, list(
  total.loans = sum(loan.part.value),
  loan.rate = weighted.mean(loan.rate, weights),
  term = weighted.mean(term, weights),
  originated = weighted.mean(originated, weights),
  maturity = weighted.mean(maturity,weights),
  no.loan.parts = length(loan.part.value),
  no.borrowers = length(unique(loan.id)),
  no.lenders= length(unique(postcode.len))
  ),
  by = list(region.len, region.bor)]

write.csv(p2p.means.region, "Visualisation raw/region-flow-p2p.csv")

ggplot(p2p.means.region, aes(x=loan.rate)) + geom_histogram(binwidth = 0.05, colour = "white", fill = "lightskyblue") + 
  xlab("Histogram of loan rates (in %) for each regional flow") + ylab("Relative frequency")
ggsave(file="plots/hist-loanrates.pdf", width=9, height=5)

ggplot(p2p.means.region, aes(x=term)) + geom_histogram(binwidth = 0.5, colour = "white", fill = "orange") + 
  xlab("Histogram of term (in months) for each regional flow") + ylab("Relative frequency")
ggsave(file="plots/hist-term.pdf", width=9, height=5)


########
# Area
setkey(p2p, loan.id)
p2p.means.area  <- p2p[weights][, list(
  region.len = region.len[1],
  region.bor = region.bor[1],
  total.loans = sum(loan.part.value),
  loan.rate = weighted.mean(loan.rate, weights),
  term = weighted.mean(term, weights),
  originated = weighted.mean(originated, weights),
  maturity = weighted.mean(maturity, weights),
  no.loan.parts = length(loan.part.value),
  no.borrowers = length(unique(loan.id)),
  no.lenders = length(unique(postcode.len))
),
by = list(area.len, area.bor)]

write.csv(p2p.means.area, "Visualisation raw/area-flow-p2p.csv")

###
save.image("Peer-to-peer/p2p-flow-statistics-11jun13.RData")

############
# Area statistics

p2p.area.bor <- p2p[, list(
  no.loan.parts = length(loan.part.value),
  no.borrowers = length(unique(loan.id)),
  avg.loan.part.value = mean(loan.part.value),
  total.loans = sum(loan.part.value),
  avg.loan.bor = sum(loan.part.value)/length(unique(loan.id))
  ),
  by=area.bor]
describe(p2p.area.bor)
write.csv(p2p.area.bor, "Visualisation raw/p2p-area-borrowers-average.csv")

p2p.area.len <- p2p[, list(
  no.loan.parts = length(loan.part.value),
  no.lenders = length(unique(postcode.len)),
  avg.loan.part.value = mean(loan.part.value),
  total.loans = sum(loan.part.value),
  avg.loan.len = sum(loan.part.value)/length(unique(postcode.len))
  ),
  by=area.len]
describe(p2p.area.len)
write.csv(p2p.area.len, "Visualisation raw/p2p-area-lenders-average.csv")

#########
# Details

setkey(p2p, area.len)
describe(p2p["EC", list(loan.part.value)])
describe(p2p["ZE", list(loan.part.value)])

write.csv(p2p["EC", list(total.loan=sum(loan.part.value), no.loan.parts=length(loan.part.value)), by=postcode.len], "Visualisation raw/EC-area-lenders.csv")
write.csv(p2p["ZE", list(total.loan=sum(loan.part.value), no.loan.parts=length(loan.part.value)), by=postcode.len], "Visualisation raw/ZE-area-lenders.csv")

boxplot(loan.part.value ~ platform, row.sample(p2p,10000))
ggplot(p2p, aes(platform, loan.part.value)) + geom_boxplot() + coord_trans(y = "log10")

# Aggregate files on individual loan level
p2p.lenders <- p2p[, list(region.len=region.len[1], area.len=area.len[1], total.loans = sum(loan.part.value), no.loan.parts=length(loan.part.value)), by=postcode.len]
p2p.borrowers <- p2p[, list(region.bor=region.bor[1], area.bor=area.bor[1], total.loans = sum(loan.part.value), no.loan.parts=length(loan.part.value)), by=loan.id]

# Visualise distribution
boxplot(total.loans ~ area.len, data=p2p.lenders)
boxplot(total.loans ~ area.len, data=p2p.lenders, log="y")

ggplot(p2p.lenders, aes(area.len, total.loans)) + geom_boxplot() + coord_trans(y = "log10") +
 stat_summary(fun.y=mean, colour="red", geom="point") +
 geom_hline(aes(yintercept=p2p.lenders[, median(total.loans)]))

ggplot(p2p.borrowers, aes(area.bor, total.loans)) + geom_boxplot() + coord_trans(y = "log10") +
  stat_summary(fun.y=mean, colour="red", geom="point") +
  geom_hline(aes(yintercept=p2p.borrowers[, median(total.loans)]))

# Calculate statistics for each area
p2p.area.len.stats <- p2p.lenders[, list(
  no.loan.parts = sum(no.loan.parts),
  no.lenders = length(postcode.len),
  avg.loan = mean(total.loans),
  median.loan = as.double(median(total.loans)),
  sd.loan = sd(total.loans),
  min.loan = min(total.loans),
  max.loan = max(total.loans),
  total.loans = sum(total.loans)
  ),
  by=area.len]
write.csv(p2p.area.len.stats, "Visualisation raw/p2p-len-area-loan-stats.csv")

p2p.area.bor.stats <- p2p.borrowers[, list(
  no.loan.parts = sum(no.loan.parts),
  no.borrowers = length(loan.id),
  avg.loan = mean(total.loans),
  median.loan = as.double(median(total.loans)),
  sd.loan = sd(total.loans),
  min.loan = min(total.loans),
  max.loan = max(total.loans),
  total.loans = sum(total.loans)
  ),
  by=area.bor]
write.csv(p2p.area.bor.stats, "Visualisation raw/p2p-bor-area-loan-stats.csv")

#######
# Calculate statistics for each region
p2p.reg.len.stats <- p2p.lenders[, list(
  no.loan.parts = sum(no.loan.parts),
  no.lenders = length(postcode.len),
  avg.loan = mean(total.loans),
  median.loan = as.double(median(total.loans)),
  sd.loan = sd(total.loans),
  min.loan = min(total.loans),
  max.loan = max(total.loans),
  total.loans = sum(total.loans)
  ),
  by=region.len]
write.csv(p2p.reg.len.stats, "Visualisation raw/p2p-len-region-loan-stats.csv")

p2p.reg.bor.stats <- p2p.borrowers[, list(
  no.loan.parts = sum(no.loan.parts),
  no.borrowers = length(loan.id),
  avg.loan = mean(total.loans),
  median.loan = as.double(median(total.loans)),
  sd.loan = sd(total.loans),
  min.loan = min(total.loans),
  max.loan = max(total.loans),
  total.loans = sum(total.loans)
  ),
  by=region.bor]
write.csv(p2p.reg.bor.stats, "Visualisation raw/p2p-bor-region-loan-stats.csv")

##################
# County Statistics
# Read file with postcodes and counties data
pcuk <- fread("/Users/Ulrich/Downloads/postcodes.csv")
pcuk <- pcuk[, list(Postcode, County)]

# Sort files for merging
pcuk[, Postcode := clean.postcode(Postcode)]
setkey(pcuk, Postcode)
setkey(p2p, postcode.len)

county <- pcuk[p2p]
setnames(county,"County","county.len")
setnames(county,"Postcode","postcode.len")

setkey(county, postcode.bor)
county <- pcuk[county]
setnames(county,"County","county.bor")
setnames(county,"Postcode","postcode.bor")
rm(pcuk)
rm(p2p)

#######
# Calculate statistics for each County
setkey(county, loan.id)

county.flows <- county[weights][, list(
  total.loans = sum(loan.part.value),
  loan.rate = weighted.mean(loan.rate, weights),
  term = weighted.mean(term, weights),
  originated = weighted.mean(originated, weights),
  maturity = weighted.mean(maturity, weights),
  no.loan.parts = length(loan.part.value),
  no.borrowers = length(unique(loan.id)),
  no.lenders= length(unique(postcode.len))
),
by = list(county.len, county.bor)]
write.csv(county.flows, "Visualisation raw/p2p-county-flows.csv")



