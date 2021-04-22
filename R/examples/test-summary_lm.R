set.seed(129)
n <- 100; p <- 2
X <- matrix(rnorm(n * p), n, p) # no intercept!
y <- rnorm(n)

library(rbenchmark)
rbenchmark::benchmark(
    obj_1 <- .lm.fit (x = cbind(1, X), y = y) %>% summary_lm,
    obj_2 <- lm(y~X) %>% summary,
    replications = 1e4
)

summary_lm(obj_1)
obj_2

rbenchmark::benchmark(
    obj_1 <- slope_p(y, fast = FALSE),
    obj_2 <- slope_p(y),
    obj_3 <- slope_mk(y),
    replications = 1e3
)
