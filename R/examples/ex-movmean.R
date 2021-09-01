arr = rnorm(5*5*10) %>% array(dim = c(5, 5, 10))
r = movmean_R(arr, 1) %>% array_3dTo2d()

# only suit for 2d array
mat = array_3dTo2d(arr)
r2 = movmean2_mat(mat, 1, 1)

max(rowMeans2(abs(r - r2))) < 1e-5
