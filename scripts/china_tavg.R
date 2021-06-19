library(nctools)
library(matrixStats)

infile = "I:/Research/cmip6/heatwave/data-raw/CN05.1_Tm_1961_2018_daily_025x025.nc"
data = ncread(infile)
dates <- nc_date(infile)

arr_year = apply_3d(data$data$tm, by = year(dates))

year = 1961:2018
tavg = arr_year %>% array_3dTo2d() %>% colMeans2(na.rm = TRUE)

ind <- which(year(dates) %in% 1961:1990)
system.time({
    x = plyr::aaply(data$data$tm, c(1, 2), movmean, halfwin = 7, .progress = "text")
})
plot(year, tavg);
grid()
{
    arr = data$data$tm[,,1:5000]
    mat = array_3dTo2d(arr)
    # x = matrix(1:16, 4)

    half_win = 7
    all.equal(movmean2_mat(mat, half_win, half_win), movmean_R(arr, half_win))
    rbenchmark::benchmark(
        movmean2_mat(mat, half_win, half_win),
        movmean_R(arr, half_win),
        replications = 1
    )
}
