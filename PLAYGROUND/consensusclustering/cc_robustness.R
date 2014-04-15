cc_robust_cust <- function (segments, clussol) 
{
  mr <- memrob(clussol)
  mrm <- mr$resultmatrix@mrm
  cmr <- clussol@rm
  # Combine CC allocation with simple k-means 'reference matrix'
  cluster <- data.frame(mrm, max.col(mrm), cmr)
  
  # This is an alternative way of calculating membership robustness
  # It takes seg allocation by the highest probability derived from CC
  # Extract the probabilites for each segment, only keep the appropriate column
  seg <- NULL
  rob <- NULL
  for (i in 1:segments) {
    seg[[i]] <- cluster[cluster$max.col.mrm.== i, i]
    rob[[i]] <- sum(seg[[i]]) / length(seg[[i]])
  }
  # Return statistics
  print(rob)
  # List of rows which are misclassified
  missclas <- nrow(cluster[cluster$max.col.mrm. != cluster$cm, ])
  print(missclas)
  # For export later, not ideal
  clusterallocation <<- as.data.frame(max.col(mrm))
}


###################################
# This uses the default function in the package, which employs the reference matrix
cc_robust_package <- function (seg_low, seg_high, cc_out) {
  clustrob <- seg_low:seg_high
  for (i in 1:length(clustrob)) {
  clustrob[[i]] <- clrob(dataseg[[i]])
  }
  xxclustrob <- lapply(clustrob, unlist)
  max <- max(sapply(xxclustrob, length))
  clustrobexp <<- do.call(rbind, lapply(xxclustrob, function(z)c(z, rep(NA, max-length(z)))))
}
