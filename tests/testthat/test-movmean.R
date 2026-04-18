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

test_that("movmean2 include_self works", {
    x <- c(4, 8, 6, -1, -2, -3, -1)

    # include_self = TRUE (default): window [i-1, i, i+1]
    m_with <- movmean2(x, win_left = 1, win_right = 1, include_self = TRUE)
    # include_self = FALSE: window [i-1, i+1], excludes x[i]
    m_without <- movmean2(x, win_left = 1, win_right = 1, include_self = FALSE)

    # For interior points they must differ (x is not constant)
    expect_false(isTRUE(all.equal(m_with[2:6], m_without[2:6])))

    # Manual check for index 2 (1-based): neighbours are x[1]=4 and x[3]=6
    # include_self=FALSE => mean(4, 6) = 5
    expect_equal(m_without[2], mean(c(x[1], x[3])))

    # include_self=TRUE  => mean(4, 8, 6) = 6
    expect_equal(m_with[2], mean(c(x[1], x[2], x[3])))

    # With NA: include_self=FALSE should still skip self even when self is NA
    x_na <- c(4, NA, 6, -1)
    m_na <- movmean2(x_na, win_left = 1, win_right = 1, include_self = FALSE)
    # index 2: neighbours are x[1]=4 and x[3]=6, self (NA) excluded -> mean=5
    expect_equal(m_na[2], mean(c(x_na[1], x_na[3]), na.rm = TRUE))
})


# test_that("movmean_R works", {
#     arr = rnorm(5 * 5 * 10) %>% array(dim = c(5, 5, 10))
#     r = movmean_R(arr, 1) %>% array_3dTo2d()

#     # only suit for 2d array
#     mat = array_3dTo2d(arr)
#     r2 = movmean2_mat(mat, 1, 1)

#     expect_true(max(rowMeans2(abs(r - r2))) < 1e-5)
# }
