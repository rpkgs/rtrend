test_that("multiplication works", {
    library(ggplot2)
    p <- ggplot(mpg, aes(displ, hwy, colour = drv)) + 
        geom_point() + 
        stat_mk(size = 1) + 
        geom_smooth(method = "lm", se = FALSE, linetype = 2)
    expect_true({
        print(p)
        TRUE
    })
})
