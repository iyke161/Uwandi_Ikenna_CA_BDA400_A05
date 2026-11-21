# Simple Linear Regression
# Uses the subset and offset indexing described in the assignment pseudocode.
linreg <- function(regressionSource, regressionLength, regressionOffset) {
  if (!is.numeric(regressionSource) || length(regressionSource) == 0L ||
      any(!is.finite(regressionSource))) {
    stop("regressionSource must be a non-empty numeric vector containing only finite values.")
  }
  if (length(regressionLength) != 1L || is.na(regressionLength) ||
      regressionLength < 2 || regressionLength != as.integer(regressionLength)) {
    stop("regressionLength must be an integer greater than or equal to 2.")
  }
  if (length(regressionOffset) != 1L || is.na(regressionOffset) ||
      regressionOffset < 0 || regressionOffset != as.integer(regressionOffset)) {
    stop("regressionOffset must be a non-negative integer.")
  }

  n <- length(regressionSource)
  regressionLength <- as.integer(regressionLength)
  regressionOffset <- as.integer(regressionOffset)

  if (regressionLength > n) {
    stop("regressionLength cannot be greater than the number of elements in regressionSource.")
  }
  if (regressionOffset >= regressionLength) {
    stop("regressionOffset must be less than regressionLength.")
  }

  start_index <- max(1L, n - regressionLength + regressionOffset)
  end_index <- min(n, n - regressionOffset)
  if (start_index > end_index) {
    stop("The selected regression subset is empty.")
  }
  source_subset <- regressionSource[start_index:end_index]
  index_values <- seq_along(source_subset)

  mean_index <- sum(index_values) / length(index_values)
  mean_source <- sum(source_subset) / length(source_subset)
  numerator <- sum((index_values - mean_index) * (source_subset - mean_source))
  denominator <- sum((index_values - mean_index)^2)
  if (denominator == 0) {
    stop("Regression requires at least two points with distinct index values.")
  }

  slope <- numerator / denominator
  intercept <- mean_source - slope * mean_index
  predicted_values <- slope * index_values + intercept

  result <- list(
    slope = slope,
    intercept = intercept,
    predicted_values = predicted_values
  )
  return(result)
}
