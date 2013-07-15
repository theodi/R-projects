mode.stats <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}

clean.names <- function(x) {
y <- str_trim(colnames(x))
y <- gsub("\\s", ".", y)
y <- str_replace_all(y, "[[:punct:]]", ".")
y <- tolower(y)
return(y)
}

clean.postcode <- function(x) {
  x <- str_replace_all(x, "\\s", "")
  x <- toupper(x)
  return(x)
}

# For clean graphs
mysep <- function(x, ...) { 
  format(x, big.mark = ' ', trim = TRUE, scientific = FALSE, ...) 
}

rbind.match.columns <- function(input1, input2) {
  n.input1 <- ncol(input1)
  n.input2 <- ncol(input2)
  
  if (n.input2 < n.input1) {
    TF.names <- which(names(input2) %in% names(input1))
    column.names <- c(names(input2[, TF.names, with=FALSE]))
  } else {
    TF.names <- which(names(input1) %in% names(input2))
    column.names <- c(names(input1[, TF.names, with=FALSE]))
  }
  # Change from plyr::rbind.fill to rbindlist, took 1808s 
  li <- list(input1[, column.names, with=FALSE], input2[, column.names, with=FALSE])
  return(rbindlist(li))
}

row.sample <- function(data, rep){
  data[sample(1:nrow(data), rep, replace=FALSE),]
}
