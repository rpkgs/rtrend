#' @rdname mkTrend
#' @export
mkTrend_r <- function(y, ci = 0.95, IsPlot = FALSE) {
    z0    = z = NA_real_
    pval0 = pval = NA_real_
    slp <- NA_real_
    intercept <- NA_real_

    if (IsPlot) {
        plot(y, type = "b")
        grid()
        rlm <- lm(y~seq_along(y))
        abline(rlm$coefficients, col = "blue")
        legend("topright", c('MK', 'lm'), col = c("red", "blue"), lty = 1)
    }
    names(y) <- NULL

    # if (is.vector(y) == FALSE) stop("Input data must be a vector")
    I_bad <- !is.finite(y) # NA or Inf
    if (any(I_bad)) {
        y <- y[-which(I_bad)]
        # NA value also removed
        # warning("The input vector contains non-finite or NA values removed!")
    }

    n <- length(y)
    #20161211 modified, avoid y length less then 5, return rep(NA,5) c(z0, pval0, z, pval, slp)
    if (n < 5) return(rep(NA, 5))

    S = Sf_r(y)
    ro <- acf(rank(lm(y ~ I(1:n))$resid), lag.max = (n - 1), plot = FALSE)$acf[-1]
    sig <- qnorm((1 + ci)/2)/sqrt(n)
    rof <- ifelse(abs(ro) > sig, ro, 0)#modified by dongdong Kong, 2017-04-03
    
    cte <- 2/(n * (n - 1) * (n - 2))
    ess = 0
    for (i in 1:(n - 1)) {
        ess = ess + (n - i) * (n - i - 1) * (n - i - 2) * rof[i]
    }
    essf = 1 + ess * cte
    var.S = n * (n - 1) * (2 * n + 5) * (1/18)
    if (length(unique(y)) < n) {
        aux <- unique(y)
        for (i in 1:length(aux)) {
            tie <- length(which(y == aux[i]))
            if (tie > 1) {
                var.S = var.S - tie * (tie - 1) * (2 * tie + 5) * (1/18)
            }
        }
    }
    VS = var.S * essf
    if (S == 0) {
        z = 0
        z0 = 0
    }
    if (S > 0) {
        z = (S - 1)/sqrt(VS)
        z0 = (S - 1)/sqrt(var.S)
    } else {
        z = (S + 1)/sqrt(VS)
        z0 = (S + 1)/sqrt(var.S)
    }
    pval = 2 * pnorm(-abs(z))
    pval0 = 2 * pnorm(-abs(z0))
    Tau = S/(0.5 * n * (n - 1))

    slp <- slope_sen_r(y)
    intercept <- mean(y - slp*seq_along(y), na.rm = T)
    c(z0 = z0, pval0 = pval0, z = z, pval = pval, slp = slp, intercept = intercept)
}

Sf_r <- function(y) {
    n = length(y)
    S = 0
    for (i in 1:(n - 1)) {
        for (j in (i + 1):n) {
            S = S + sign(y[j] - y[i])
        }
    }
    S
}
