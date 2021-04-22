#' summary_lm
#' 
#' summary method for class ".lm.fit".. It's 200 times faster than traditional \code{lm}.
#' 
#' @param obj Object returned by \code{\link{.lm.fit}}.
#' @param ... ignored
#' 
#' @return a p x 4 matrix with columns for the estimated coefficient, its standard error, 
#' t-statistic and corresponding (two-sided) p-value. Aliased coefficients are omitted.
#' 
#' @example R/examples/ex-summary_lm.R
#' @export
summary_lm <- function(obj, ...){
    z <- obj
    p <- z$rank

    Qr <- z$qr
    n <- nrow(Qr)
    rdf <- n - p#df.residual

    r <- z$residuals
    # f <- z$fitted.values
    # mss <- sum((f - mean(f))^2)
    rss <- sum(r^2)
    resvar <- rss/rdf

    p1 <- 1L:p
    R <- chol2inv(Qr[p1, p1, drop = FALSE])
    se <- sqrt(diag(R) * resvar)
    est <- z$coefficients[z$pivot[p1]]
    tval <- est/se
    # ans <- z[c("call", "terms", if (!is.null(z$weights)) "weights")]
    # ans$residuals <- r
    coefficients <- cbind(est, se, tval, 2 * pt(abs(tval),
                                                rdf, lower.tail = FALSE))
    dimnames(coefficients) <- list(names(z$coefficients)[z$pivot[p1]],
                                   c("Estimate", "Std. Error", "t value", "Pr(>|t|)"))
    return(coefficients)
    # df.int <- ifelse(attr(z$terms, "intercept"), 1L, 0L)
    # ans$r.squared <- mss/(mss + rss)
    # ans$adj.r.squared <- 1 - (1 - ans$r.squared) * ((n - df.int)/rdf)
    # ans$fstatistic <- c(value = (mss/(p - df.int))/resvar, numdf = p - df.int, dendf = rdf)
    # ans
}
