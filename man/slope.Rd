% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/RcppExports.R, R/slope.R
\name{slope_sen}
\alias{slope_sen}
\alias{slope}
\alias{slope_p}
\alias{slope_sen_r}
\alias{slope_mk}
\alias{slope_boot}
\title{slope}
\usage{
slope_sen(y, x = NULL)

slope(y, x, ...)

slope_p(y, x, fast = TRUE)

slope_sen_r(y, x = seq_along(y), ...)

slope_mk(y, x = NULL, ...)

slope_boot(y, x = NULL, slope_FUN = slope, times = 100, alpha = 0.1, seed, ...)
}
\arguments{
\item{y}{vector of observations of length n, or a matrix with n rows.}

\item{x}{vector of predictor of length n, or a matrix with n rows.}

\item{...}{ignored.}

\item{fast}{Boolean. If true, \code{\link[stats:lmfit]{stats::.lm.fit()}} will be used, which is 10x
faster than \code{\link[stats:lm]{stats::lm()}}.}

\item{slope_FUN}{one of \code{\link[=slope]{slope()}}, \code{\link[=slope_p]{slope_p()}}, \code{\link[=slope_mk]{slope_mk()}}}

\item{times}{The number of bootstrap replicates.}

\item{alpha}{significant level, defalt 0.1}

\item{seed}{a single value, interpreted as an integer, or \code{NULL}
    (see \sQuote{Details}).}
}
\value{
\itemize{
\item \code{slope}  : linear regression coefficient
\item \code{pvalue} : \verb{p-value <= 0.05`` means that corresponding }slope` is significant.
\item \code{sd}     : \verb{Std. Error}
}

For \code{slope_boot}, slope is estimated in many times. The lower, mean, upper
and standard deviation (sd) are returned.
}
\description{
\itemize{
\item \code{slope}     : linear regression slope
\item \code{slope_p}   : linear regression slope and p-value
\item \code{slope_mk}  : mann kendall Sen's slope and p-value
\item \code{slope_sen} : same as \code{slope_mk}, but with no p-value
\item \code{slope_boot}: bootstrap slope and p-value
}
}
\examples{
y <- c(4.81, 4.17, 4.41, 3.59, 5.87, 3.83, 6.03, 4.89, 4.32, 4.69)
r <- slope(y)
r_p <- slope_p(y)
r_mk <- slope_mk(y)
r_boot <- slope_boot(y)
}
