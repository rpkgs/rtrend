#' slope
#'
#' * `slope`     : linear regression slope
#' * `slope_p`   : linear regression slope and p-value
#' * `slope_mk`  : mann kendall Sen's slope and p-value
#' * `slope_boot`: bootstrap slope and p-value
#'
#' @param y vector of observations of length n, or a matrix with n rows.
#' @param x vector of predictor of length n, or a matrix with n rows.
#' @param fast Boolean. If true, [stats::.lm.fit()] will be used, which is 10x
#' faster than [stats::lm()].
#'
#' @return
#' `slope` and `p-value` are returned.
#' For `slope_boot`, slope is estimated in many times. The lower, mean, upper
#' and standard deviation (sd) are returned.
#'
#' @examples
#' y <- c(4.81,4.17,4.41,3.59,5.87,3.83,6.03,4.89,4.32,4.69)
#' r    <- slope(y)
#' r_p  <- slope_p(y)
#' r_mk <- slope_mk(y)
#' r_boot <- slope_boot(y)
#' @importFrom stats .lm.fit pt
#' @export
slope <- function(y, x){
    # TODO: add tests for slopew
    if (!is.matrix(y)) y <- as.matrix(y)
    n <- nrow(y)

    if (missing(x)) x <- as.matrix(1:n)
    if (!is.matrix(x)) x <- as.matrix(x)

    I_bad <- which(!is.finite(y)) # NA or Inf

    if (length(I_bad) > 0) {
        y <- y[-I_bad, , drop = FALSE]
        x <- x[-I_bad, , drop = FALSE]
    }
    if (length(y) <= 1) return(c(slope = NA_real_))

    slope = qr.solve(cbind(x*0+1, x) , y)[2, ]
    if (length(slope) == 1) names(slope) = "slope"
    slope
}

#' @rdname slope
#' @export
slope_p <- function(y, x, fast = TRUE){
    if (!is.matrix(y)) y <- as.matrix(y)
    n <- nrow(y)

    if (missing(x)) x <- as.matrix(1:n)
    if (!is.matrix(x)) x <- as.matrix(x)

    I_bad <- which(!is.finite(y)) # NA or Inf

    if (length(I_bad) > 0) {
        y <- y[-I_bad, , drop = FALSE]
        x <- x[-I_bad, , drop = FALSE]
    }
    if (length(y) <= 1) return(c(slope = NA_real_, pvalue = NA_real_))

    # pvalue: the smaller, the better
    if (fast) {
        l <- .lm.fit(x = cbind(1, x), y = y)
        coefficients <- summary_lm(l)
    } else {
        l <- lm(y ~ x)
        coefficients <- summary(l)$coefficients
    }
    coefficients[2, c(1, 4)] %>% set_names(c("slope", "pvalue"))
}

#' @rdname slope
#' @export
slope_mk <- function(x){
    mkTrend(x)[c("slp", "pval")] %>% set_names(c("slope", "pvalue"))
}

#' @param slope_FUN one of [slope()], [slope_p()], [slope_mk()]
#' @param times The number of bootstrap replicates.
#' @param alpha significant level, defalt 0.1
#'
#' @inheritParams boot::boot
#' @inheritParams base::set.seed
#'
#' @rdname slope
#' @importFrom boot boot
#' @importFrom matrixStats colQuantiles colSds
#' @export
slope_boot <- function(y, slope_FUN = slope, times = 100, alpha = 0.1, seed) {
    if (!missing(seed)) set.seed(seed)

    x0  <- seq_along(y)
    FUN <- function(y0, indices) {
        y <- y0[indices]
        x <- x0[indices]
        slope_FUN(y, x)
    }
    b <- boot(y, FUN, R = times)

    probs  <- c(alpha/2, 0.5, 1 - alpha/2)
    b$coef <- colQuantiles(as.matrix(b$t), probs = probs, drop = FALSE) %>%
        set_rownames(names(b$t0)) %>%
        set_colnames(c("lower", "mean", "upper")) %>%
        cbind(sd = colSds(b$t))
    b$coef
}
