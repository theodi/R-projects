temporaryFile <- tempfile()
download.file("https://www.gov.uk/government/uploads/system/uploads/attachment_data/file/270310/UnclaimedEstatesList.csv",
              destfile = temporaryFile, method = "curl")
data <- read.csv(temporaryFile)