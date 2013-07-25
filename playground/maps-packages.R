library(maps)
world <- map("world", plot = FALSE, namesonly = T)
italy <- world[grep("[Ii]taly.*", world)]
map("world", regions = c(italy), fill = T, col = "white", lty = 0, bg = "lightblue")