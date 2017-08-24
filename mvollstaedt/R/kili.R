## load packages and functions
if (!require(Rsenal))
  devtools::install_github("environmentalinformatics-marburg/Rsenal")

library(Rsenal)
library(latticeExtra)

source("R/visDEM.R")
source("R/panel.smoothconts.R")

## load satellite image
kili = kiliAerial(type = "satellite", scale = 2, rgb = TRUE)

## import plot locations
locations <- read.csv2("~/plot locations.csv")

lbl = c("sav", "mai", "cof", "gra", "hom", "flm", "foc", "fod", "fpo", "fpd")
locations$type = factor(locations$type, levels = lbl)

coordinates(locations) = ~ lon + lat
proj4string(locations) = "+init=epsg:4326"

## import digital elevation model (dem)
dem = raster("inst/extdata/srtm_44_13.tif")

## create figure and write to disk
p = spplot(locations, "type", scales = list(draw = TRUE), key.space = "right"
       , xlim = c(36.95, 37.75), ylim = c(-3.425, -2.8)
       , sp.layout = rgb2spLayout(kili, quantiles = c(.01, .99))) + 
  as.layer(visDEM(dem, col = "black", labcex = .8))

tiff("out/kili.tiff", width = 20, height = 14, units = "cm", res = 300
     , compression = "lzw")
plot.new()
print(p, newpage = FALSE)
dev.off()
