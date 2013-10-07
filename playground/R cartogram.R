library(maptools)
cartogram<-readShapePoly("/Users/Ulrich/Google Drive/ODI Drive/Commercial/Training/Clients and partners/Scottish ONS/part 2/r_cartogram/world_r_carto.shp")

r.cartogram <- readShapePoly("world_r_carto.shp")
plot(r.cartogram)
title(main="R Activity Around the World", sub="Based on cran.rstudio.com Activity Logs October 2012-June 2013")