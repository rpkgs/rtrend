set.seed(129)
n <- 100
p <- 2
X <- matrix(rnorm(n * p), n, p) # no intercept!
y <- rnorm(n)

obj <- .lm.fit (x = cbind(1, X), y = y) 
info <- summary_lm(obj)
