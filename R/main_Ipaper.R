`%||%` <- function (x, y) {
  if (is.null(x)) 
    y
  else x
}

last <- function(x) x[length(x)]

which.notna <- function(x) which(!is.na(x))
