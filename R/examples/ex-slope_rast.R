library(rtrend)
library(terra)

f <- system.file("rast/MOD15A2_LAI_China_G050_2001-2020.tif", package = "rtrend")
r <- rast(f)
r
time(r)

slp <- slope_rast(r,
  period = c(2001, 2020), 
  outfile = "LAI_trend.tif", overwrite = TRUE,
  fun = rtrend::slope_mk, .progress = "none"
)
# if you want to show progress, set `.progress = "text"`
slp
plot(slp)

file.remove("LAI_trend.tif")
