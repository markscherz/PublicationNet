#' Function to make a lower triangle matrix a symmetric matrix
#' 
#' This functions converts a lower triangle matrix into a symmetric matrix by transposing the lower triangle into the upper triangle. 
#' It is taken from https://stackoverflow.com/questions/33026183/r-make-symmetric-matrix-from-lower-diagonal
#' 
#' @param m lower triangle matrix
#' @return a new matrix that is symmetric
#' @export

makeSymm <- function(m) { #
  #stopifnot("input is already symmetric" = m == t(m))
  m[upper.tri(m)] <- t(m)[upper.tri(m)]
  return(m)
}