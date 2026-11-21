# Stock-data workflow for Assignment 2.
# Place Assignment 1 daily CSV files in the data/ folder, then run from this folder:
# source("run_analysis.R")

source("R/sma.R")
source("R/ema.R")
source("R/macd.R")
source("R/stdev.R")
source("R/linreg.R")
source("R/rsi.R")
source("R/stoch_rsi.R")
source("R/crossover.R")
source("R/crossunder.R")

data_dir <- "data"
csv_files <- list.files(data_dir, pattern = "\\.csv$", full.names = TRUE, ignore.case = TRUE)
if (length(csv_files) == 0L) {
  stop("No CSV files found. Add your Assignment 1 stock-history CSV files to the data/ folder.")
}

# Match common column-name variations while retaining the provider's source data.
standardize_stock_data <- function(file_path) {
  raw <- read.csv(file_path, stringsAsFactors = FALSE, check.names = FALSE)
  names_lower <- gsub("[^a-z0-9]", "", tolower(names(raw)))
  required <- c("date", "open", "high", "low", "close", "volume")
  positions <- match(required, names_lower)
  if (any(is.na(positions))) {
    stop(paste("CSV is missing one or more required columns:", paste(required, collapse = ", "),
               "in file", basename(file_path)))
  }
  out <- raw[, positions, drop = FALSE]
  names(out) <- c("Date", "Open", "High", "Low", "Close", "Volume")
  out$Date <- as.Date(out$Date)
  if (any(is.na(out$Date))) stop(paste("Could not parse Date column in", basename(file_path)))
  for (column in c("Open", "High", "Low", "Close", "Volume")) {
    out[[column]] <- as.numeric(gsub(",", "", as.character(out[[column]])))
  }
  if (any(!is.finite(as.matrix(out[, c("Open", "High", "Low", "Close", "Volume")]))) ||
      any(out$Close <= 0)) {
    stop(paste("Invalid or missing numeric market values in", basename(file_path)))
  }
  out <- out[order(out$Date), ]
  rownames(out) <- NULL
  out
}

stock_data <- list()
for (file in csv_files) {
  symbol <- sub("\\.[^.]*$", "", basename(file))
  stock_data[[symbol]] <- standardize_stock_data(file)
}

# Indicator settings can be adjusted here.
short_ema_period <- 12L
long_ema_period <- 26L
signal_period <- 9L
rsi_period <- 14L
sma_period <- 20L

analysis_results <- list()
for (symbol in names(stock_data)) {
  df <- stock_data[[symbol]]
  close <- df$Close

  # SMA returns n-period+1 values, so align it to the right edge of each window.
  sma_values <- c(rep(NA_real_, sma_period - 1L), sma(close, sma_period))
  ema_short <- ema(close, short_ema_period)
  ema_long <- ema(close, long_ema_period)
  macd_values <- macd(close, short_ema_period, long_ema_period, signal_period)
  rsi_values <- rsi(close, rsi_period)
  stoch_values <- stoch_rsi(close, rsi_period, 14L, 3L)

  # Trading rules: bullish EMA crossover with RSI confirmation; bearish crossunder
  # with RSI confirmation. These are illustrative research signals, not advice.
  cross_up <- crossover(ema_short, ema_long) == "Up"
  cross_down <- crossunder(ema_short, ema_long) == "True"
  buy_signal <- cross_up & !is.na(rsi_values) & rsi_values < 70
  sell_signal <- cross_down & !is.na(rsi_values) & rsi_values > 30

  result <- data.frame(
    Date = df$Date, Open = df$Open, High = df$High, Low = df$Low,
    Close = close, Volume = df$Volume,
    SMA_20 = sma_values, EMA_12 = ema_short, EMA_26 = ema_long,
    MACD = macd_values$macd_line, MACD_Signal = macd_values$signal_line,
    MACD_Histogram = macd_values$histogram, RSI_14 = rsi_values,
    StochRSI_K = stoch_values$k_line, StochRSI_D = stoch_values$d_line,
    Buy_Signal = buy_signal, Sell_Signal = sell_signal
  )

  # Optional time-period filter: edit these dates to restrict the analysis.
  start_date <- as.Date("1900-01-01")
  end_date <- Sys.Date()
  filtered_result <- result[result$Date >= start_date & result$Date <= end_date, ]
  analysis_results[[symbol]] <- filtered_result
  write.csv(filtered_result, file.path(data_dir, paste0(symbol, "_technical_analysis.csv")),
            row.names = FALSE, na = "")
}

cat("Processed symbols:", paste(names(analysis_results), collapse = ", "), "\\n")
cat("Created indicator and trading-signal CSV files in the data/ folder.\\n")
