library(nctools)
library(matrixStats)

infile = "N:/Research/cmip5/heatwave/data-raw/CN05.1_Tm_1961_2018_daily_025x025.nc"
data = ncread(infile)
dates <- nc_date(infile)

arr_year = apply_3d(data$data$tm, by = year(dates))

year = 1961:2018
tavg = arr_year %>% array_3dTo2d() %>% colMeans2(na.rm = TRUE)

plot(year, tavg);
grid()
