y <- c(1, 3, 2, 5, 6, 8, 10, 1)
w <- seq_along(y)/length(y)

test_that("smooth_wSG works", {
    halfwin = 2
    d = 2
    s1 <- smooth_wSG(y, halfwin, d, w)
    s2 <- smooth_SG(y, halfwin, d)

    MAE = 1.5
    expect_true(mean(abs(y - s1)) < MAE)
    expect_true(mean(abs(y - s2)) < MAE)
})

test_that("movmean works", {
    s <- smooth_wSG(y, 1, 1)
    m <- movmean(y, 1)
    m2 <- movmean2(y, 1, 1)
    expect_true(all.equal(s[2:7], m[2:7]))
    expect_true(all.equal(m, m2))
})


# test_that("movmean_R works", {
#     arr = rnorm(5 * 5 * 10) %>% array(dim = c(5, 5, 10))
#     r = movmean_R(arr, 1) %>% array_3dTo2d()

#     # only suit for 2d array
#     mat = array_3dTo2d(arr)
#     r2 = movmean2_mat(mat, 1, 1)

#     expect_true(max(rowMeans2(abs(r - r2))) < 1e-5)
# }
