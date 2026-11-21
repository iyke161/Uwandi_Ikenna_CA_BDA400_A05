# Crossover detection: returns "Up", "Down", or "None" at each position.
crossover <- function(arr1, arr2) {
  if (!is.numeric(arr1) || !is.numeric(arr2) || length(arr1) != length(arr2)) {
    stop("Both arrays should be numeric and have the same length.")
  }
  if (length(arr1) == 0L || any(!is.finite(arr1)) || any(!is.finite(arr2))) {
    stop("Both arrays must be non-empty and contain only finite values.")
  }

  crossover_signals <- rep("None", length(arr1))
  if (length(arr1) >= 2L) {
    for (i in 2:length(arr1)) {
      if (arr1[i] > arr2[i] && arr1[i - 1L] <= arr2[i - 1L]) {
        crossover_signals[i] <- "Up"
      } else if (arr1[i] < arr2[i] && arr1[i - 1L] >= arr2[i - 1L]) {
        crossover_signals[i] <- "Down"
      }
    }
  }
  return(crossover_signals)
}
