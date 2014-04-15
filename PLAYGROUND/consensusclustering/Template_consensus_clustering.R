setwd("...")
wd <- getwd()
# Install packages first before you can load them
require(Hmisc)
require(descr)
require(foreign)

# Only variables you need are respid and the factors or bases for segmentation.
rmdata <- read.spss('orig data 05feb13.sav', to.data.frame=T)
names(rmdata) # variables
ls(rmdata) # sorted variables

# Variable sets!
factors <- grep("^Factor[1-8]", names(rmdata), value=TRUE)

# Consensus Clustering
require(clusterCons)
source(".../cluscomp_pb_mach.r")
source(".../cc_robustness.r")
set.seed(4994)

# Optional: Filter out flatliners
# rmclusnoflat <- rmdata[which(rmdata$notflatsum==1) , c("respid", factors)]

# Make respid the rowlabels for CC, input data for allocation algorithm
rmclus <- rmdata[, c("respid", factors)]
rownames(rmclus) <- rmclus$respid
rmclus[,1] <- NULL

# Recommended are 1000 replications; time-consuming.
system.time(  
  dataseg <- cluscomp_mach(rmclus, diss=FALSE, algorithms=list("kmeans"), alparams=list(iter.max=50),
                           clmin=4, clmax=9, prop=0.8, reps=1000) 
)
# Saves results in the project folder, slow.
save.image("conscluster 1000rep.RData")

# Calculate robustness of each segment solution via the clusterCons package.
# Result is called 'clustrobexp'
cc_robust_package(4,9,dataseg)
write.csv(clustrobexp, "RM cluster robustness 06mar13.csv")

# Alternative way with highest and number of re-allocated segment membership
# Takes some time to calculate individual membership robustness 'memrob'
# Not the ideal way because 'clusterallocation' gets overwritten
# To save the result specify: segmentX <- clusterallocation
#
# 'cc_robust_cust' gives you the alternative robustness statistic AND 
# the number of respondents which are allocated into different segments.

cc_robust_cust(4, dataseg$e1_kmeans_k4)
segment4 <- clusterallocation
cc_robust_cust(5, dataseg$e1_kmeans_k5)
segment5 <- clusterallocation
cc_robust_cust(6, dataseg$e1_kmeans_k6)
segment6 <- clusterallocation
cc_robust_cust(7, dataseg$e1_kmeans_k7)
cc_robust_cust(8, dataseg$e1_kmeans_k8)
cc_robust_cust(9, dataseg$e1_kmeans_k9)
rm(clusterallocation)

# Export back to SPSS via respid
# Merging: MUST BE SURE THAT THE ORDER IS CORRECT
# Before opening in SPSS delete column 1 and rename variables.
all_clusters_SPSS <- data.frame(rmclus$respid, segment4, segment5, segment6)
write.csv(all_clusters_SPSS, "Seg 4-6 allocation respid 06mar13.csv")

# Optional: Compare segmentation solution.
colours <-  c("#D7191C", "#FDAE61", "#ABDDA4", "#2B83BA")
crosstab(all_clusters_SPSS[,3], all_clusters_SPSS[,2], xlab="6 segments", ylab="4 segments",color=colours)


# heatmaps - takes very long to run
jpeg("heatmap 4 seg.jpg", width = 800, height = 800)
system.time(heatmap(dataseg$e1_kmeans_k4@cm, labRow="", labCol=""))
dev.off()
jpeg("heatmap 5 seg.jpg", width = 800, height = 800)
system.time(heatmap(dataseg$e1_kmeans_k5@cm, labRow="", labCol=""))
dev.off()
jpeg("heatmap 6 seg.jpg", width = 800, height = 800)
system.time(heatmap(dataseg$e1_kmeans_k6@cm, labRow="", labCol=""))
dev.off()
