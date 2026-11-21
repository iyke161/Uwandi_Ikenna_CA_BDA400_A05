# Exponential Moving Average (EMA)
# Uses the assignment pseudocode: first EMA equals the first observation.
ema <- function(data, period) {
  if (!is.numeric(data) || length(data) == 0L || any(!is.finite(data))) {
    stop("data must be a non-empty numeric vector containing only finite values.")
  }
  if (length(period) != 1L || is.na(period) || period < 1 || period != as.integer(period)) {
    stop("period must be a positive integer.")
  }
  period <- as.integer(period)

  multiplier <- 2 / (period + 1)
  ema_values <- numeric(length(data))
  for (i in seq_along(data)) {
    if (i == 1L) {
      ema_values[i] <- data[i]
    } else {
      ema_values[i] <- (data[i] - ema_values[i - 1L]) * multiplier + ema_values[i - 1L]
    }
  }
  return(ema_values)
}
