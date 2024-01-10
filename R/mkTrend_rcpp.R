# 20161211 modified, avoid x length less then 5
#' Modified Mann Kendall
#'
#' If valid observations <= 5, NA will be returned.
#'
#' mkTrend is 4-fold faster with `.lm.fit`.
#'
#' @param y numeric vector
#' @param x (optional) numeric vector
#' @param ci critical value of autocorrelation
#' @param IsPlot boolean
#'
#' @return
#' * `Z0`   : The original (non corrected) Mann-Kendall test Z statistic.
#' * `pval0`: The original (non corrected) Mann-Kendall test p-value
#' * `Z`    : The new Z statistic after applying the correction
#' * `pval` : Corrected p-value after accounting for serial autocorrelation
#' `N/n*s` Value of the correction factor, representing the quotient of the number
#' of samples N divided by the effective sample size `n*s`
#' * `slp`  : Sen slope, The slope of the (linear) trend according to Sen test
#'
#' @note
#' slp is significant, if pval < alpha.
#'
#' @references
#' Hipel, K.W. and McLeod, A.I. (1994),
#' \emph{Time Series Modelling of Water Resources and Environmental Systems}.
#' New York: Elsevier Science.
#'
#' Libiseller, C. and Grimvall, A., (2002), Performance of partial
#' Mann-Kendall tests for trend detection in the presence of covariates.
#' \emph{Environmetrics} 13, 71--84, \doi{10.1002/env.507}.
#'
#' @seealso `fume::mktrend` and `trend::mk.test`
#' @author Dongdong Kong
#'
#' @examples
#' x <- c(4.81, 4.17, 4.41, 3.59, 5.87, 3.83, 6.03, 4.89, 4.32, 4.69)
#' r <- mkTrend(x)
#' r_cpp <- mkTrend(x, IsPlot = TRUE)
#' @export
mkTrend <- function(y, x = seq_along(y), ci = 0.95, IsPlot = FALSE) {
  x <- x %||% seq_along(y)
  if (all(is.na(x))) x <- seq_along(y)

  z0 <- z <- NA_real_
  pval0 <- pval <- NA_real_
  slp <- NA_real_
  intercept <- NA_real_

  if (IsPlot) {
    plot(x, y, type = "b")
    grid()
    rlm <- lm(y ~ x)
    abline(rlm$coefficients, col = "blue")
    legend("topright", c("MK", "lm"), col = c("red", "blue"), lty = 1)
  }
  names(y) <- NULL

  # if (is.vector(x) == FALSE) stop("Input data must be a vector")
  I_bad <- !is.finite(y) # NA or Inf
  if (any(I_bad)) {
    x <- x[-which(I_bad)]
    y <- y[-which(I_bad)]
    # NA value also removed
    # warning("The input vector contains non-finite or NA values removed!")
  }
  n <- length(y)
  # 20161211 modified, avoid x length less then 5, return rep(NA,5) c(z0, pval0, z, pval, slp)
  if (n < 5) {
    return(c(z0 = z0, pval0 = pval0, z = z, pval = pval, slp = slp, intercept = intercept))
  }

  S <- Sf(y) # call cpp

  resid <- .lm.fit(cbind(x, 1), y)$residuals
  resid %<>% rank()
  # resid = lm(x ~ I(1:n))$resid
  # ro <- acf(resid, lag.max = (n - 1), plot = FALSE)$acf[-1]
  ro <- acf.fft(resid, lag.max = (n - 1))[-1]
  sig <- qnorm((1 + ci) / 2) / sqrt(n)
  rof <- ifelse(abs(ro) > sig, ro, 0) # modified by dongdong Kong, 2017-04-03

  temp <- varS(y, rof, S)
  z <- temp["z"][[1]]
  z0 <- temp["z0"][[1]]

  pval <- 2 * pnorm(-abs(z))
  pval0 <- 2 * pnorm(-abs(z0))
  Tau <- S / (0.5 * n * (n - 1))

  slp <- slope_sen(y, x)
  intercept <- mean(y - slp * x, na.rm = T)
  if (IsPlot) abline(b = slp, a = intercept, col = "red")

  c(z0 = z0, pval0 = pval0, z = z, pval = pval, slp = slp, intercept = intercept)
}
