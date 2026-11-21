# Retrieve the five Assignment 1 portfolio stocks from Yahoo Finance.
# Run from the Assignment 2 project root:
# source("R/download_stock_data.R")

symbols <- c("AAPL", "MSFT", "NVDA", "AMZN", "TSLA")
start_date <- Sys.Date() - 365
end_date <- Sys.Date()

if (!requireNamespace("quantmod", quietly = TRUE)) {
  install.packages("quantmod", repos = "https://cloud.r-project.org")
}
if (!requireNamespace("zoo", quietly = TRUE)) {
  install.packages("zoo", repos = "https://cloud.r-project.org")
}

dir.create("data", showWarnings = FALSE)

downloaded <- character()
failed <- character()

for (symbol in symbols) {
  message("Downloading ", symbol, " from Yahoo Finance ...")
  stock_xts <- tryCatch(
    quantmod::getSymbols(
      Symbols = symbol,
      src = "yahoo",
      from = start_date,
      to = end_date,
      auto.assign = FALSE
    ),
    error = function(e) {
      message("Download failed for ", symbol, ": ", conditionMessage(e))
      NULL
    }
  )

  if (is.null(stock_xts) || NROW(stock_xts) == 0L) {
    failed <- c(failed, symbol)
    next
  }

  stock_df <- data.frame(
    Date = as.Date(zoo::index(stock_xts)),
    Open = as.numeric(quantmod::Op(stock_xts)),
    High = as.numeric(quantmod::Hi(stock_xts)),
    Low = as.numeric(quantmod::Lo(stock_xts)),
    Close = as.numeric(quantmod::Cl(stock_xts)),
    Adjusted = as.numeric(quantmod::Ad(stock_xts)),
    Volume = as.numeric(quantmod::Vo(stock_xts))
  )

  stock_df <- stock_df[stats::complete.cases(stock_df[, c(
    "Date", "Open", "High", "Low", "Close", "Volume"
  )]), ]
  stock_df <- stock_df[order(stock_df$Date), ]
  rownames(stock_df) <- NULL

  if (nrow(stock_df) == 0L) {
    failed <- c(failed, symbol)
    next
  }

  output_file <- file.path("data", paste0(symbol, ".csv"))
  utils::write.csv(stock_df, output_file, row.names = FALSE, na = "")
  downloaded <- c(downloaded, symbol)
  message("Saved ", output_file, " (", nrow(stock_df), " daily rows).")
}

cat("\nDownload summary\n")
cat("Successfully saved:", if (length(downloaded)) paste(downloaded, collapse = ", ") else "none", "\n")
cat("Failed:", if (length(failed)) paste(failed, collapse = ", ") else "none", "\n")

if (length(downloaded) != length(symbols)) {
  warning("Not all five symbols were downloaded. Check the messages and retry failed symbols.")
} else {
  cat("All five stock CSV files are ready in the data/ folder.\n")
}
