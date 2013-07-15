setwd("/Users/Ulrich/Google Drive/Projects/p2p/Data/")
source("/Users/Ulrich/Google Drive/Projects/p2p/Data/Peer-to-peer/functions.r")
# load("/Users/Ulrich/Google Drive/Projects/p2p/Data//Peer-to-peer/p2p-combined.RData")

# Comments
# library(XLConnect)
# Java heap space error
# Better read function? xlsx import packages failed

# Load packages
library(plyr)
library(data.table)
library(stringr)
library(lubridate)
library(fasttime)

# Options
options(lubridate.verbose = TRUE)
# Set nrowr to -1 for all rows
nrowr <- -1
# Useful
'%ni%' <- Negate('%in%')


##################
### Zopa ###
# Import as data table, much faster than read.csv
system.time( zopa <- fread("Peer-to-peer/Original/zopa-clean.csv", header = TRUE, stringsAsFactors=FALSE, nrows=nrowr) )
# Clean up names
zopa.names <- clean.names(zopa)
zopa.names
setnames(zopa, zopa.names)
setnames(zopa, "maturity.dae", "maturity.date")
setnames(zopa, 1, "loan.id")


# Convert time formats - FAST
datevars <- c("loan.admitted.date","origination.date","maturity.date")
system.time( zopa[, (datevars):=lapply(.SD, fastPOSIXct), .SDcols=datevars] ) # 7.3s / 3.1s
rm(datevars, zopa.names)

# Normalise loan rate to percentage points
zopa[, loan.rate := loan.rate * 100]
zopa[, mcl.interestrate := mcl.interestrate * 100]

# Add source
zopa[,platform:=1]

# Make postcodes uppercase and remove spaces
zopa[,postcode := clean.postcode(postcode)]
zopa[,borrower.s.postcode := clean.postcode(borrower.s.postcode)]

# Remove missing and foreign postcodes
dim(zopa)
table(zopa[,nchar(postcode)])
table(zopa[,nchar(borrower.s.postcode)])

zopa <- zopa[nchar(postcode) > 4]
zopa <- zopa[nchar(postcode) < 8]
dim(zopa)


##################
### RateSetter ###
# Import
rs <- fread("Peer-to-peer/Original/RateSetter2010-clean.csv", header = TRUE, stringsAsFactors=FALSE, nrows=nrowr)
# Clean up names
rs.names <- clean.names(rs)
rs.names
setnames(rs, rs.names)

# Time formats
datevars <- c("admitted","originated","maturity")
system.time( rs[, (datevars):=lapply(.SD, dmy), .SDcols=datevars] )
rm(datevars, rs.names)

# Add source
rs[,platform:=2]

# Make postcodes uppercase and remove spaces
rs[,lender.postcode := clean.postcode(lender.postcode)]
rs[,borrower.postcode := clean.postcode(borrower.postcode)]

# Remove missing and foreign postcodes
dim(rs)
table(rs[,nchar(borrower.postcode)])
table(rs[,nchar(lender.postcode)])

rs <- rs[nchar(borrower.postcode) > 4]
rs <- rs[nchar(lender.postcode) > 4]
rs <- rs[nchar(borrower.postcode) < 8]
rs <- rs[nchar(lender.postcode) < 8]
dim(rs)

##################
### Funding Circle ###
# Import Funding Circle
fc.len <- fread("Peer-to-peer/Original/funding circle/all loan parts_2013-05-23.txt", header=TRUE, stringsAsFactors=FALSE, nrows=nrowr)
fc.bor <- fread("Peer-to-peer/Original/funding circle/Funding-Circle-clean.csv", header=TRUE, stringsAsFactors=FALSE, nrows=nrowr)
#Clean up names
fc.len.names <- clean.names(fc.len)
fc.len.names
setnames(fc.len, fc.len.names)

fc.bor.names <- clean.names(fc.bor)
fc.bor.names
setnames(fc.bor, fc.bor.names)

# Merge funding circle files
setkey(fc.len, borrower.id)
setkey(fc.bor, borrower.id)

# No matches for loan.id: 4 6 8 9 10 11 12 13  14  15  16  17  18  19  20  21  22  23  24 
fc.bor[which(fc.bor[,borrower.id] %ni% fc.len[,borrower.id])]
fc <- fc.bor[fc.len]
# Testing time formats
# system.time( fc[["loan.accepted.date"]] <- strptime(fc[["loan.accepted.date"]], format="%d/%m/%Y") ) #54
# system.time( fc[["loan.accepted.date"]] <- dmy(fc[["loan.accepted.date"]]) ) # 45s
# system.time( fc[["loan.accepted.date"]] <- fastPOSIXct(fc[["loan.accepted.date"]]) ) # 0.26s but WRONG

# Time formats - 65s
datevars <- c("loan.accepted.date","date.repaid")
system.time( fc[, (datevars):=lapply(.SD, dmy), .SDcols=datevars] )
rm(fc.bor, fc.len, fc.bor.names, fc.len.names, datevars)

# Add source
fc[,platform:=3]

# Make postcodes uppercase and remove spaces
fc[,postcode := clean.postcode(postcode)]
fc[,business.postcode := clean.postcode(business.postcode)]

# Remove missing and foreign postcodes
dim(fc)
table(fc[,nchar(postcode)])
table(fc[,nchar(business.postcode)])

fc <- fc[nchar(postcode) > 4]
fc <- fc[nchar(postcode) < 8]
dim(fc)

###########
### ALl ###
# Combine p2p companies with standardised names
rs.bind <- rename(rs, replace=c("loanid" = "loan.id",
                                "borrower.postcode" = "postcode.bor",
                                "originated" = "originated",
                                "maturity" = "maturity",
                                "term..in.months." = "term",
                                "lender.amount" = "loan.part.value",
                                "loan.rate" = "loan.rate",
                                "lender.postcode" = "postcode.len"))

fc.bind <- rename(fc, replace=c("borrower.id" = "loan.id",
                                "business.postcode" = "postcode.bor",
                                "loan.accepted.date" = "originated",
                                "date.repaid" = "maturity",
                                "term" = "term",
                                "total.principal" = "loan.part.value",
                                "annualised.loan.part.rate" = "loan.rate",
                                "postcode" = "postcode.len"))

zopa.bind <- rename(zopa, replace=c("loan.id" = "loan.id",
                                    "borrower.s.postcode" = "postcode.bor",
                                    "origination.date" = "originated",
                                    "maturity.date" = "maturity",
                                    "loan.term.in.months" = "term",
                                    "mcl.original.amount" = "loan.part.value",
                                    "loan.rate" = "loan.rate",
                                    "postcode" = "postcode.len"))

# If memory is limited.
rm(rs, fc, zopa)

system.time( p2p <- rbind.match.columns(rs.bind, fc.bind) ) # 0.39s

system.time( p2p <- rbind.match.columns(p2p, zopa.bind) ) # 7s
# If memory is limited.
rm(rs.bind, fc.bind, zopa.bind)

setkey(p2p, platform)
p2p[, platform := factor(platform, labels=c("Zopa", "RateSetter", "FundingCircle"))]
table(p2p$platform)

# Capitalise sector "individual" for 
setkey(p2p, sector)
p2p["individual", sector := "Individual"]
p2p[, sector := factor(sector)]

# Extract area - 10s
p2p[,area.len := str_extract(postcode.len, "[A-Z]{1,2}")]
p2p[,area.bor := str_extract(postcode.bor, "[A-Z]{1,2}")]

# Extract outcode and incode - positional much faster than regex
system.time( p2p[, outcode.len := str_sub(postcode.len, start = 1, end = -4)] )
system.time( p2p[, incode.len := str_sub(postcode.len, start = -3, end = -1)] )
p2p[, outcode.bor := str_sub(postcode.bor, start = 1, end = -4)]
p2p[, incode.bor := str_sub(postcode.bor, start = -3, end = -1)]

# p2p[, incode.bor := str_sub(postcode.bor, "?[0-9][A-Z]{2}$")]

# Remove 13 more non-UK postcodes, e.g. (FC) 72170
table(p2p[,is.na(area.len)])
table(p2p[,is.na(area.bor)])

p2p <- p2p[is.na(area.len)==FALSE]

# Remove Isle of Man, Guernsey, Jersey, British Forces
setkey(p2p, area.bor)
p2p <- p2p[!"IM"]
p2p <- p2p[!"BF"]
p2p <- p2p[!"GY"]
p2p <- p2p[!"JE"]
setkey(p2p, area.len)
p2p <- p2p[!"IM"]
p2p <- p2p[!"BF"]
p2p <- p2p[!"GY"]
p2p <- p2p[!"JE"]

#######################
### Merge in regions ###
uk <- fread("Peer-to-peer/Original/Postcode-areas-updated-11jun.csv", header=TRUE, stringsAsFactors=FALSE)
uk[, Region := factor(Region)]

# Merge borrower outcode region
uk.bor <- uk[, list(Outcode, Region)]
setnames(uk.bor, "Region", "region.bor")

setkey(uk.bor, Outcode)
setkey(p2p, outcode.bor)

p2p[which(p2p[,outcode.len] %ni% uk.bor[,Outcode])]
p2p <- uk.bor[p2p]
setnames(p2p, "Outcode", "outcode.bor")

# Merge lender outcode region
uk.len <- uk[, list(Outcode, Region)]
setnames(uk.len, "Region", "region.len")

setkey(uk.len, Outcode)
setkey(p2p, outcode.len)

p2p[which(p2p[,outcode.bor] %ni% uk.bor[,Outcode])]
p2p <- uk.len[p2p]
setnames(p2p, "Outcode", "outcode.len")

# This drops all non-UK postcodes and invalid
# In the area file "W1" is also recognised as London
p2p <- p2p[is.na(region.len)==FALSE]
p2p <- p2p[is.na(region.bor)==FALSE]
dim(p2p)

p2p[, lapply(.SD, function(x) {length(na.omit(x))}) ]

# Export
# system.time( write.csv(p2p, "p2p-combined.csv") )
save(p2p, file="Peer-to-peer/p2p-combined.Rdata")

