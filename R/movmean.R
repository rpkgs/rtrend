# movmean in the R style
#' @export
movmean_R <- function(arr, half_win = 1) {
    dim = dim(arr)
    n = last(dim)

    mat = array_3dTo2d(arr)
    # split into multiple groups, and
    win = half_win*2 + 1
    temp = lapply(-half_win:half_win, function(i) {
        if (i < 0) {
            c(list(mat[, i:-1]), rep(list(NA), abs(i))) %>% do.call(cbind, .)
        } else if (i == 0) {
            mat
        } else if (i > 0) {
            c(rep(list(NA), i), list(mat[, 1:(n-i)])) %>% do.call(cbind, .)
        }
    })
    abind::abind(temp, along = 3) %>% apply_3d()
}
