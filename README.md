
<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- badges: start -->

[![R-CMD-check](https://github.com/rpkgs/rtrend/workflows/R-CMD-check/badge.svg)](https://github.com/rpkgs/rtrend/actions)
<!-- badges: end -->

# rtrend

<!-- badges: start -->

[![R-CMD-check](https://github.com/rpkgs/rtrend/workflows/R-CMD-check/badge.svg)](https://github.com/rpkgs/rtrend/actions)
<!-- badges: end -->

## Installation

You can install the released version of rtrend from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("rtrend")
```

## Example

``` r
library(rtrend)
## basic example code
```

``` r
library(rtrend)
y <- c(4.81, 4.17, 4.41, 3.59, 5.87, 3.83, 6.03, 4.89, 4.32, 4.69)
(r <- slope(y))
#>      slope 
#> 0.04636364
(r_p <- slope_p(y))
#>      slope     pvalue 
#> 0.04636364 0.62498625
(r_mk <- slope_mk(y))
#>     slope    pvalue 
#> 0.0400000 0.7205148
(r_boot <- slope_boot(y))
#>             lower       mean     upper         sd
#> slope -0.03898333 0.04074329 0.1706008 0.07850702
```

``` r
set.seed(1)
x <- rnorm(2e2)
microbenchmark::microbenchmark(
    mkTrend_r(x),
    mkTrend(x)
)
#> Unit: milliseconds
#>          expr    min     lq      mean   median       uq     max neval
#>  mkTrend_r(x) 8.2248 9.0141 11.073161 10.04990 12.83455 21.0988   100
#>    mkTrend(x) 1.5293 1.6686  1.877096  1.73625  2.10290  2.7243   100
```

``` r
x <- c(4.81,4.17,4.41,3.59,5.87,3.83, 6.03,4.89,4.32,10,4.69)
par(mar = c(3, 3, 1, 1), mgp = c(2, 0.6, 0))
r_cpp <- mkTrend(x, IsPlot = TRUE)
```

<img src="man/figures/README-mkTrend-1.svg" width="100%" />
