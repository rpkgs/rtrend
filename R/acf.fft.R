#' faster autocorrelation based on ffw
#'
#' This function is 4-times faster than [stats::acf()]
#'
#' @inheritParams stats::acf
#' @keywords internal
#'
#' @references
#' 1. https://github.com/santiagobarreda/phonTools/blob/main/R/fastacf.R
#' 2. https://gist.github.com/FHedin/05d4d6d74e67922dfad88038b04f621c
#' 3. https://gist.github.com/ajkluber/f293eefba2f946f47bfa
#' 4. http://www.tibonihoo.net/literate_musing/autocorrelations.html#wikispecd
#' 5. https://lingpipe-blog.com/2012/06/08/autocorrelation-fft-kiss-eigen
#'
#' @return
#' An array with the same dimensions as x containing the estimated autocorrelation.
#'
#' @examples
#' set.seed(1)
#' x <- rnorm(100)
#' r_fast <- acf.fft(x)
#' r <- acf(x, plot=FALSE, lag.max=100)$acf[,,1]
#' @importFrom fftwtools fftw
#' @export
acf.fft <- function(x, lag.max = NULL) {
  N <- length(x)
  if (is.null(lag.max)) {
    lag.max <- N - 1
  } else {
    lag.max <- pmin(lag.max, N - 1)
  }

  # get a centred version of the signal
  x <- x - mean(x)
  #  need to pad with zeroes first ; pad to a power of 2 will give faster FFT
  m <- ceiling(log2(N))
  len.opt <- 2^m - N

  # x0 <- c(x, rep.int(0, len.opt)) # error
  x0 <- c(x, zeros(x))

  # fft using fast fftw library as backend
  FF <- fftw(x0)
  FF2 <- (abs(FF))^2

  # take the inverse transform of the power spectral density
  acf <- fftw(FF2, inverse = 1)
  acf <- Re(acf[1:N])
  acf[1:(lag.max + 1)] / acf[1]
}
