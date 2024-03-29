% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/slope_rast.R
\name{slope_rast}
\alias{slope_rast}
\alias{rast_filter_time}
\title{calculate slope of rast object}
\usage{
slope_rast(
  r,
  period = c(2001, 2020),
  outfile = NULL,
  fun = rtrend::slope_mk,
  ...,
  overwrite = FALSE,
  .progress = "text"
)

rast_filter_time(r, period = c(2001, 2020))
}
\arguments{
\item{r}{A yearly rast object, which should have time attribute}

\item{period}{\code{c(year_begin, year_end)}}

\item{outfile}{The path of outputed tiff file. If specified, \code{slope} and
\code{pvalue} will be written into \code{outfile}.}

\item{fun}{the function used to calculate slope, see \code{\link[=slope]{slope()}} for details.}

\item{...}{other parameters ignored}

\item{overwrite}{logical. If \code{TRUE}, \code{outfile} is overwritten.}

\item{.progress}{name of the progress bar to use, see
\code{\link[plyr]{create_progress_bar}}}
}
\value{
A terra rast object, with bands of \code{slope} and \code{pvalue}.
}
\description{
calculate slope of rast object
}
\examples{
library(rtrend)
library(terra)

f <- system.file("rast/MOD15A2_LAI_China_G050_2001-2020.tif", package = "rtrend")
r <- rast(f)
r
time(r)

slp <- slope_rast(r,
  period = c(2001, 2020), 
  outfile = "LAI_trend.tif", overwrite = TRUE,
  fun = rtrend::slope_mk, .progress = "none"
)
# if you want to show progress, set `.progress = "text"`
slp
plot(slp)

file.remove("LAI_trend.tif")
}
\seealso{
\code{\link[terra:rast]{terra::rast()}}
}
