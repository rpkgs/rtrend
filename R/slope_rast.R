#' slope_arr
#'
#' @return t, A 3d array, with the dim of `[nx, ny, 2]`.
#' - `t[,,1]`: slope
#' - `t[,,2]`: pvalue
#' @keywords internal
#' @export
slope_arr <- function(arr, fun = rtrend::slope_mk, return.list = FALSE, .progress = "text", ...) {
    I_grid <- apply_3d(arr) %>% which.notna()
    mat <- array_3dTo2d(arr, I_grid)

    res <- apply_par(mat, 1, fun, .progress = .progress)
    ans <- array_2dTo3d(res, I_grid, dim(arr)[1:2]) # trend

    if (return.list) {
        list(slope = ans[, , 1], pvalue = ans[, , 2])
    } else {
        ans
    }
}

#' calculate slope of rast object
#'
#' @inheritParams plyr::llply
#' 
#' @param r A yearly rast object, which should have time attribute
#' @param period `c(year_begin, year_end)`
#' @param outfile The path of outputed tiff file. If specified, `slope` and
#' `pvalue` will be written into `outfile`.
#' @param overwrite logical. If `TRUE`, `outfile` is overwritten.
#' @param fun the function used to calculate slope, see [slope()] for details.
#' @param ... other parameters ignored
#'
#' @return A terra rast object, with bands of `slope` and `pvalue`.
#'
#' @example R/examples/ex-slope_rast.R
#'
#' @seealso [terra::rast()]
#' @importFrom terra as.array plot rast ext time writeRaster `values<-`
#' @export
slope_rast <- function(r, period = c(2001, 2020), outfile = NULL,
                       fun = rtrend::slope_mk,
                       ...,
                       overwrite = FALSE,
                       .progress = "text") {
    if (is.character(r)) r <- rast(r, ...)
    if (!is.null(period)) {
        r %<>% rast_filter_time(period)
        # `r` should have time information
    }
    arr <- as.array(r) # 3d array
    t <- slope_arr(arr, fun = fun, return.list = FALSE, .progress = .progress) # 3d array

    r_target <- rast(r, nlyrs = 2) %>%
        set_names(c("slope", "pvalue"))
    values(r_target) <- t # !note that `t` should be a 3d array
    # `vals`, and `values`, result is different
    if (!is.null(outfile)) {
        if (!file.exists(outfile) || overwrite) {
            # if (file.exists(outfile)) file.remove(outfile)
            writeRaster(r_target, outfile, overwrite = TRUE)
        }
    }
    r_target
}

#' @importFrom lubridate year
#' @rdname slope_rast
#' @export
rast_filter_time <- function(r, period = c(2001, 2020)) {
    year <- year(time(r))
    ind <- which(year >= period[1] & year <= period[2])
    r[[ind]]
}

# slope_nc <- function(file, varname = 0) {
#     period = c("2001-01-01", "2020-12-31")
#     arr <- ncread(file, varname, DatePeriod = period)$data[[1]]
#     info = ncdim_get(file)

#     t = slope_arr(arr)
#     r = get_grid.lonlat(info$lon, info$lat)
#     r@data = t %>% list2df()
#     r
# }

# list2df <- function(x) {
#     lapply(x, as.numeric) %>% as.data.frame()
# }
