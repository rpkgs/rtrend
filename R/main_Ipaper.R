`%||%` <- function (x, y) {
  if (is.null(x)) 
    y
  else x
}

last <- function(x) x[[length(x)]]

which.notna <- function(x) which(!is.na(x))


#' Set dimensions of an Object
#'
#' @inheritParams base::dim
#' @param dim integer vector, see also [base::dim()]
#'
#' @seealso [base::dim]
#'
#' @examples
#' x <- 1:12
#' set_dim(x, c(3, 4))
#' @export
set_dim <- function(x, dim) {
  dim(x) <- dim
  x
}

#' @inheritParams base::dimnames
#'
#' @export
#' @rdname set_dim
set_dimnames <- function(x, value) {
  dimnames(x) <- value
  x
}
