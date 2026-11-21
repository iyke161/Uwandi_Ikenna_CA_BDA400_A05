# Moving Average Convergence Divergence (MACD)
# Requires ema.R to be sourced first.
macd <- function(data, short_period, long_period, signal_period) {
  if (!is.numeric(data) || length(data) == 0L || any(!is.finite(data))) {
    stop("data must be a non-empty numeric vector containing only finite values.")
  }
  periods <- c(short_period, long_period, signal_period)
  if (any(!is.finite(periods)) || any(periods < 1) || any(periods != as.integer(periods))) {
    stop("All MACD periods must be positive integers.")
  }
  if (short_period >= long_period) {
    stop("short_period must be smaller than long_period.")
  }
  if (!exists("ema", mode = "function")) {
    stop("Source R/ema.R before calling macd().")
  }

  short_ema <- ema(data, as.integer(short_period))
  long_ema <- ema(data, as.integer(long_period))
  macd_line <- short_ema - long_ema
  signal_line <- ema(macd_line, as.integer(signal_period))
  histogram <- macd_line - signal_line

  result <- list(
    macd_line = macd_line,
    signal_line = signal_line,
    histogram = histogram
  )
  return(result)
}
