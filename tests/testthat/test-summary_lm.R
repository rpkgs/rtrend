test_that("summary_lm works", {
    set.seed(129)
    n <- 100
    p <- 2
    X <- matrix(rnorm(n * p), n, p) # no intercept!
    y <- rnorm(n)

    obj <- .lm.fit (x = cbind(1, X), y = y)

    coef <- summary_lm(obj)
    coef_lm = summary(lm(y~X))$coefficients

    expect_true(max(as.numeric(coef - coef_lm)) < 1e-5)
})

