# Technical Analysis Indicators — Assignment 5

**Student:** Ikenna Uwandi  
**Course:** CA_BDA400  
**Assignment brief:** Assignment 5 (as identified in the supplied assignment instructions)  
**Requested project folder:** `Uwandi_Ikenna_CA_BDA400_A05`

> Naming note: the requested folder suffix is A05, The project folder is named Uwandi_Ikenna_CA_BDA400_A05.. The folder has been named exactly as requested.

## Contents
- `R/sma.R` — Simple Moving Average
- `R/ema.R` — Exponential Moving Average
- `R/macd.R` — MACD line, signal line, and histogram
- `R/stdev.R` — Population standard deviation
- `R/linreg.R` — Simple linear regression
- `R/rsi.R` — Relative Strength Index using Wilder smoothing
- `R/stoch_rsi.R` — Stochastic RSI (%K and %D)
- `R/crossover.R` — Up/down crossover events
- `R/crossunder.R` — Crossunder events
- `R/run_tests.R` — Base-R verification tests
- `R/download_stock_data.R` — optional Yahoo Finance data retrieval helper
- `run_analysis.R` — CSV ingestion, indicator calculations, date filtering, and illustrative trading rules
- `Assignment_Explanation.docx` — implementation notes and annotated screenshot evidence
- `evidence/screenshots/` — 19 RStudio screenshots and screenshot log

## Run instructions
1. Open RStudio and set the working directory to this project folder.
2. Put the Assignment 1 OHLCV CSV files in `data/`. Each source file must include Date, Open, High, Low, Close, and Volume columns.
3. If the original CSVs are unavailable, the optional downloader can retrieve AAPL, MSFT, NVDA, AMZN, and TSLA from Yahoo Finance. It requires an internet connection and the `quantmod` and `zoo` packages:
   `source("R/download_stock_data.R")`
4. Run the base-R function checks:
   `source("R/run_tests.R")`
5. Run the analysis workflow:
   `source("run_analysis.R")`

## Implementation notes
All indicator functions in `R/` use base R and do not call external technical-analysis packages. The optional market-data retrieval helper uses `quantmod` and `zoo` only to obtain Yahoo Finance data; those packages are not used to calculate the indicators.

- SMA returns one value per complete rolling window.
- EMA initializes its first value with the first input observation, following the supplied pseudocode.
- MACD returns aligned MACD, signal, and histogram vectors.
- `stdev()` calculates population standard deviation (division by n), following the supplied formula.
- `linreg()` applies the supplied regression subset and offset indexing and returns slope, intercept, and fitted values for that subset.
- RSI uses Wilder smoothing and leading `NA` values until a complete initial period is available.
- StochRSI uses a rolling RSI normalization window and a moving-average signal line.
- Crossover returns `Up`, `Down`, or `None`; crossunder returns `True` or `False`.
- The analysis workflow applies a configurable date range and creates illustrative EMA-crossover/RSI buy and sell flags.

## Current package limitations that must be resolved before submission
- The `data/` folder currently contains only a placeholder file. The source stock CSVs and generated technical-analysis CSV outputs are not present in this packaged folder, even though RStudio screenshots document that they existed in the working session. Re-add the actual CSVs or run the downloader before final submission.
- The cover page still needs the real repository URL. Do not submit with the repository placeholder.
- The supplied assignment brief identifies the work as Assignment 2, but the requested folder name ends in A05. Confirm the correct college naming identifier.
- R/RStudio was not available in the packaging environment, so the corrected test script could not be executed here. Run it locally and confirm the success message before LMS submission.

## Trading-rule note
The example buy rule is an upward EMA crossover with RSI below 70; the example sell rule is a downward EMA crossunder with RSI above 30. These are coding demonstrations, not investment recommendations or evidence of profitable performance.
