# Relative Strength Index (RSI)
# Wilder smoothing; output is aligned to the input with leading NA values.
rsi <- function(data, period) {
  if (!is.numeric(data) || length(data) < 2L || any(!is.finite(data))) {
    stop("data must be a numeric vector with at least two finite values.")
  }
  if (length(period) != 1L || is.na(period) || period < 1 || period != as.integer(period)) {
    stop("period must be a positive integer.")
  }
  period <- as.integer(period)
  differences <- diff(data)
  gains <- ifelse(differences > 0, differences, 0)
  losses <- ifelse(differences < 0, -differences, 0)

  rsi_values <- rep(NA_real_, length(data))
  if (length(differences) < period) {
    return(rsi_values)
  }

  avg_gain <- sum(gains[seq_len(period)]) / period
  avg_loss <- sum(losses[seq_len(period)]) / period

  calculate_rsi <- function(gain, loss) {
    if (loss == 0 && gain == 0) return(50)
    if (loss == 0) return(100)
    if (gain == 0) return(0)
    rs <- gain / loss
    100 - (100 / (1 + rs))
  }

  rsi_values[period + 1L] <- calculate_rsi(avg_gain, avg_loss)
  if (period + 1L < length(data)) {
    for (i in (period + 2L):length(data)) {
      change_index <- i - 1L
      avg_gain <- (avg_gain * (period - 1) + gains[change_index]) / period
      avg_loss <- (avg_loss * (period - 1) + losses[change_index]) / period
      rsi_values[i] <- calculate_rsi(avg_gain, avg_loss)
    }
  }
  return(rsi_values)
}
