virtualRatings <- function(iDF) {
  ex <- list(inputDF = iDF)
  class(ex) <- "virtualRatings"
  return(ex)
}

`[.virtualRatings` <- function(obj, i, j) {
    idx <- which(obj$inputDF[, 1] == i & obj$inputDF[, 2] == j)
    len <- length(idx)
    if (len == 0) { return(NA) }
    if (len > 1) {
      warning("muliple instances found")
      return(idx[1])
    }
    return(obj$inputDF[idx, 3])
}
