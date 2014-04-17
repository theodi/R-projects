# This is the file path where you store the data
setwd("~/git/R-projects/playground/titanic-R-intro")

# A function that installs the package for a novel user
installPackage <- function(p) if(!is.element(p, installed.packages()[, 1])) install.packages(p)
installPackage("Amelia")

# Load packages we use later on
require("Amelia")

# Some setup for reading the data files into R
# In many cases R can recognise column types automatically, though a special warning for factors applies.
train.column.types <- c('integer',   # PassengerId
                        'factor',    # Survived 
                        'factor',    # Pclass
                        'character', # Name
                        'factor',    # Sex
                        'numeric',   # Age
                        'integer',   # SibSp
                        'integer',   # Parch
                        'character', # Ticket
                        'numeric',   # Fare
                        'character', # Cabin
                        'factor'     # Embarked
                        )
test.column.types <- train.column.types[-2]     # no Survived column in test.csv

# Read the data into R
# More information if you type ?read.csv into the console
train.raw <- read.csv("train.csv", colClasses = train.column.types, na.strings = c("NA", ""))
df.train <- train.raw

test.raw <-  read.csv("test.csv", colClasses = test.column.types, na.strings = c("NA", ""))
df.infer <- test.raw

# Have a look at the datasets
str(df.train)
str(df.infer)

# Map the missing data by provided feature
missmap(df.train, main = "Titanic Training Data - Missings Map", col = c("grey", "black"), legend = FALSE)

# Same but with numbers
sapply(df.train, function(x) sum(is.na(x))) # No of missings
sapply(df.train,  function(x) sum(is.na(x)) * 100 / length(x)) # As percentage

# It would be nice to have the in a formatted form, we can write a function thusly
as.percent <- function(x, digits = 2, format = "fg", ...) {
  paste0(as.numeric(formatC(100 * x, format = format, digits = digits, ...)), "%")
}

# Here we apply the function with some styling for readability
noquote(
  sapply(df.train,  function(x) as.percent(sum(is.na(x)) / length(x))) 
  )
