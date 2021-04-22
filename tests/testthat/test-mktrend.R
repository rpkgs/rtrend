test_that("multiplication works", {
    x <- c(4.81, 4.17, 4.41, 3.59, 5.87, 3.83, 6.03, 4.89, 4.32, 4.69)
    r <- mkTrend_r(x, IsPlot = FALSE)
    r_cpp <- mkTrend(x, IsPlot = FALSE)

    expect_equal(r, r_cpp)
})
