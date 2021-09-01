test_that("slope works", {
    y <- c(4.81,4.17,4.41,3.59,5.87,NA,6.03,4.89,4.32,4.69)
    r = slope(y)
    r_p = slope_p(y)
    r_mk = slope_mk(y)
    r_boot = slope_boot(y, times = 10)

    expect_equal(names(r_p), names(r_mk))
    expect_equal(r, r_p[1])
    expect_equal(colnames(r_boot), c("lower", "mean", "upper", "sd"))

    expect_equal(names(slope(cbind(y, y2 = y))), c("y", "y2"))

})


## test for too much mising values
test_that("slope works at NA values", {
    expect_silent({
        y <- c(4.81, 4.17, rep(NA, 10))
        r = slope(y[-1])
        r = slope(y)
        r_p = slope_p(y[-1])
        r_mk = slope_mk(y[-1])
    })
    ## if too much mising values, boot might error
    # r_boot = slope_boot(y, times = 10)
})
