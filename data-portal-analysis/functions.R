row.sample <- function(dta, rep) {
  dta[sample(1:nrow(dta), rep, replace=FALSE), ] 
} 

mode.stat <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}

capwords <- function(s, strict = FALSE) {
  cap <- function(s) paste(toupper(substring(s, 1, 1)),
{s <- substring(s, 2); if(strict) tolower(s) else s},
                           sep = "", collapse = " " )
  sapply(strsplit(s, split = " "), cap, USE.NAMES = !is.null(names(s)))
}

nmissing <- function(x) sum(is.na(x))