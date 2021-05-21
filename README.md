
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rtrend

<!-- badges: start -->

[![R-CMD-check](https://github.com/rpkgs/rtrend/workflows/R-CMD-check/badge.svg)](https://github.com/rpkgs/rtrend/actions)
[![codecov](https://codecov.io/gh/rpkgs/rtrend/branch/master/graph/badge.svg)](https://codecov.io/gh/rpkgs/rtrend)
[![CRAN](http://www.r-pkg.org/badges/version/rtrend)](https://cran.r-project.org/package=rtrend)
<!-- badges: end -->

## Installation

You can install the released version of rtrend from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("rtrend")
```

## Example

### Fast Linear regression

``` r
library(rtrend)
set.seed(1)
y = rnorm(100)
# y <- c(4.81, 4.17, 4.41, 3.59, 5.87, 3.83, 6.03, 4.89, 4.32, 4.69)
(r <- slope(y))
#>         slope 
#> -0.0004510567
microbenchmark::microbenchmark(
  summary(lm(y~seq_along(y)))$coefficients[2, c(1, 4)],  # traditional slope and pvalue  
  r_p <- slope_p(y)  # fast linear regression
)
#> Unit: microseconds
#>                                                    expr   min    lq    mean
#>  summary(lm(y ~ seq_along(y)))$coefficients[2, c(1, 4)] 598.7 662.6 697.347
#>                                       r_p <- slope_p(y)  33.8  42.9  68.037
#>  median     uq    max neval
#>   674.4 680.45 3081.1   100
#>    56.6  62.10 1509.0   100
```

### Fast modified MK

``` r
set.seed(1)
x <- rnorm(2e2)
microbenchmark::microbenchmark(
    mkTrend_r(x), # traditional in MK fume
    mkTrend(x)    # in Rcpp version
)
#> Unit: milliseconds
#>          expr    min      lq     mean median      uq     max neval
#>  mkTrend_r(x) 7.7401 8.14095 9.077782 8.4444 8.91665 19.4647   100
#>    mkTrend(x) 1.5051 1.54190 1.618043 1.5869 1.63405  3.6716   100
```

``` r
x <- c(4.81,4.17,4.41,3.59,5.87,3.83, 6.03,4.89,4.32,10,4.69)
par(mar = c(3, 3, 1, 1), mgp = c(2, 0.6, 0))
r_cpp <- mkTrend(x, IsPlot = TRUE)
```

<img src="man/figures/README-mkTrend-1.svg" width="100%" />

### Bootstrap slope

``` r
(r_boot <- slope_boot(y))
#>             lower          mean       upper          sd
#> slope -0.00579208 -0.0001731638 0.005349173 0.003381423
```

## References

> Kong, D., Gu, X., Li, J., Ren, G., & Liu, J. (2020). Contributions of
> Global Warming and Urbanization to the Intensification of
> Human‐Perceived Heatwaves Over China. Journal of Geophysical Research:
> Atmospheres, 125(18), 1–16. <https://doi.org/10.1029/2019JD032175>.
