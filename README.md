
# rtrend

<!-- badges: start -->
<!-- badges: end -->

The goal of rtrend is to ...

## Installation

You can install the released version of rtrend from [CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("rtrend")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(rtrend)
## basic example code
```

``` r
x <- c(4.81,4.17,4.41,3.59,5.87,3.83, 6.03,4.89,4.32,10,4.69)
# r <- mkTrend(x)
par(mar = c(3, 3, 1, 1), mgp = c(2, 0.6, 0))
r_cpp <- mkTrend_rcpp(x, IsPlot = TRUE)
```

<img src="man/figures/README-mkTrend-1.svg" width="100%" />
