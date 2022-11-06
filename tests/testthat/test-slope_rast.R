library(rtrend)
library(terra)

test_that("slope_rast works", {
  f = system.file("rast/MOD15A2_LAI_China_G050_2001~2020.tif", package = "rtrend")
  r = rast(f)

  slp <- slope_rast(r, period = c(2001, 2020),
    outfile = "LAI_trend.tif", overwrite = TRUE,
    fun = rtrend::slope_mk)
  
  expect_true(nlyr(slp) == 2)
  expect_equal(names(slp), c("slope", "pvalue"))
})
