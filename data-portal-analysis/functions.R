row.sample <- function(dta, rep) {
  dta[sample(1:nrow(dta), rep, replace=FALSE), ] 
} 

mode.stat <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}