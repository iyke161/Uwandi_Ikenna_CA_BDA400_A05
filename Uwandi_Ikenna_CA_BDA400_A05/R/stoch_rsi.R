# Stochastic RSI (StochRSI)
# Requires rsi.R and sma.R to be sourced first.
# k_period is the rolling RSI normalization window; %D is the SMA of %K.
stoch_rsi <- function(data, period, k_period, d_period) {
  if (!exists("rsi", mode = "function") || !exists("sma", mode = "function")) {
    stop("Source R/rsi.R and R/sma.R before calling stoch_rsi().")
  }
  periods <- c(period, k_period, d_period)
  if (any(!is.finite(periods)) || any(periods < 1) || any(periods != as.integer(periods))) {
    stop("period, k_period, and d_period must be positive integers.")
  }

  rsi_values <- rsi(data, as.integer(period))
  k_period <- as.integer(k_period)
  d_period <- as.integer(d_period)
  k_raw <- rep(NA_real_, length(rsi_values))

  for (i in seq_along(rsi_values)) {
    first <- i - k_period + 1L
    if (first >= 1L && all(is.finite(rsi_values[first:i]))) {
      window <- rsi_values[first:i]
      lowest <- min(window)
      highest <- max(window)
      if (highest == lowest) {
        k_raw[i] <- 0
      } else {
        k_raw[i] <- (rsi_values[i] - lowest) / (highest - lowest)
      }
    }
  }

  # %K is the normalized StochRSI series; %D is its moving average.
  k_line <- k_raw
  d_line <- rep(NA_real_, length(k_line))
  valid <- which(is.finite(k_line))
  if (length(valid) >= d_period) {
    first_valid <- valid[1L]
    last_valid <- length(k_line)
    for (i in seq.int(first_valid + d_period - 1L, last_valid)) {
      window <- k_line[(i - d_period + 1L):i]
      if (all(is.finite(window))) d_line[i] <- sum(window) / d_period
    }
  }

  result <- list(k_line = k_line, d_line = d_line)
  return(result)
}
