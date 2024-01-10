test_that("multiplication works", {
  set.seed(1)
  y <- rnorm(100)
  y <- c(4.81, 4.17, 4.41, 3.59, 5.87, 3.83, 6.03, 4.89, 4.32, 4.69)

  lag.max <- 20
  r1 <- acf(y, lag.max, plot = FALSE)$acf[-1]
  r2 <- acf.fft(y, lag.max)[-1]

  expect_lt(max(r1 - r2), 1e-6)
})
