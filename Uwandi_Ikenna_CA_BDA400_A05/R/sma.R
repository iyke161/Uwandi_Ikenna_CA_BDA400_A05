# Simple Moving Average (SMA)
# Base R only. Returns one value for each complete rolling window.
sma <- function(data, period) {
  if (!is.numeric(data) || length(data) == 0L || any(!is.finite(data))) {
    stop("data must be a non-empty numeric vector containing only finite values.")
  }
  if (length(period) != 1L || is.na(period) || period < 1 || period != as.integer(period)) {
    stop("period must be a positive integer.")
  }
  period <- as.integer(period)
  n <- length(data)
  if (n < period) {
    stop("Data length should be greater than or equal to the period.")
  }

  sma_values <- numeric(n - period + 1L)
  for (i in seq_len(n - period + 1L)) {
    current_window <- data[i:(i + period - 1L)]
    sma_values[i] <- sum(current_window) / period
  }
  return(sma_values)
}
