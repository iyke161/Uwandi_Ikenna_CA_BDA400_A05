# Download Assignment 1 daily stock data for the five portfolio symbols.
# Run this script from the Assignment 2 project root in RStudio.

symbols <- c("AAPL", "MSFT", "NVDA", "AMZN", "TSLA")

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
  message("Downloading ", symbol, " ...")

  x <- tryCatch(
    quantmod::getSymbols(
      symbol,
      src = "yahoo",
      from = Sys.Date() - 365,
      to = Sys.Date(),
      auto.assign = FALSE
    ),
    error = function(e) {
      message("Could not download ", symbol, ": ", conditionMessage(e))
      NULL
    }
  )

  if (is.null(x) || NROW(x) == 0L) {
    failed <- c(failed, symbol)
    next
  }

  df <- data.frame(
    Date = as.Date(zoo::index(x)),
    Open = as.numeric(quantmod::Op(x)),
    High = as.numeric(quantmod::Hi(x)),
    Low = as.numeric(quantmod::Lo(x)),
    Close = as.numeric(quantmod::Cl(x)),
    Adjusted = as.numeric(quantmod::Ad(x)),
    Volume = as.numeric(quantmod::Vo(x))
  )

  df <- df[order(df$Date), ]
  rownames(df) <- NULL

  utils::write.csv(df, file.path("data", paste0(symbol, ".csv")),
                   row.names = FALSE, na = "")
  downloaded <- c(downloaded, symbol)
  message("Saved data/", symbol, ".csv (", nrow(df), " rows)")
}

cat("\nDownloaded:", if (length(downloaded)) paste(downloaded, collapse = ", ") else "none", "\n")
cat("Failed:", if (length(failed)) paste(failed, collapse = ", ") else "none", "\n")

if (length(failed) == 0L) {
  cat("SUCCESS: all five stock CSV files are in the data folder.\n")
}
