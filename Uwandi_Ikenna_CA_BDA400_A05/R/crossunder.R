# Crossunder detection: returns character values "True" or "False".
crossunder <- function(arr1, arr2) {
  if (!is.numeric(arr1) || !is.numeric(arr2) || length(arr1) != length(arr2)) {
    stop("Both arrays should be numeric and have the same length.")
  }
  if (length(arr1) == 0L || any(!is.finite(arr1)) || any(!is.finite(arr2))) {
    stop("Both arrays must be non-empty and contain only finite values.")
  }

  crossunder_signals <- rep("False", length(arr1))
  if (length(arr1) >= 2L) {
    for (i in 2:length(arr1)) {
      if (arr1[i] < arr2[i] && arr1[i - 1L] >= arr2[i - 1L]) {
        crossunder_signals[i] <- "True"
      }
    }
  }
  return(crossunder_signals)
}
