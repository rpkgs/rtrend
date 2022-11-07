test_that("split_data works", {
  n = 100
  x = rnorm(n)
  mat <- matrix(x, n, 6)

  length(split_data(x, 6)) == 6
  r = split_data(mat, 20)
  expect_true(unique(sapply(r, nrow)) == 5)

  r2 = split_data(mat, 3, byrow = FALSE)
  expect_true(unique(sapply(r2, ncol)) == 2)

  expect_true(length(split_data(r, 5)) == 5)
})
