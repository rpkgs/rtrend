% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/RcppExports.R
\name{smooth_wSG}
\alias{smooth_wSG}
\alias{smooth_SG}
\title{Weighted Savitzky-Golay}
\usage{
smooth_wSG(y, halfwin = 1L, d = 1L, w = NULL)

smooth_SG(y, halfwin = 1L, d = 1L)
}
\arguments{
\item{y}{colvec}

\item{halfwin}{halfwin of Savitzky-Golay}

\item{d}{polynomial of degree. When d = 1, it becomes moving average.}

\item{w}{colvec of weight}
}
\description{
NA and Inf values in the y has been ignored automatically.
}
\examples{
y <- c(1, 3, 2, 5, 6, 8, 10, 1)
w <- seq_along(y)/length(y)

halfwin = 2
d = 2
s1 <- smooth_wSG(y, halfwin, d, w)
s2 <- smooth_SG(y, halfwin, d)
}
