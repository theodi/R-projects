row.sample <- function(dta, rep = 20) {
  dta <- as.data.frame(dta) # for single variables
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

'%ni%' <- Negate('%in%')

no.missing <- function(x) sum(is.na(x))

count.empty  <- function(x){sum(x == "", na.rm = TRUE)}

count.unique <- function(x) length(unique(x))
pct.unique <- function(x) as.numeric(formatC(length(unique(x)) * 100 / length(x), format = "fg", digits = 3))