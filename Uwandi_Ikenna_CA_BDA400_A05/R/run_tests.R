# Base-R verification tests for all assignment functions.
# Run from the project root with: source("R/run_tests.R")

source("R/sma.R")
source("R/ema.R")
source("R/macd.R")
source("R/stdev.R")
source("R/linreg.R")
source("R/rsi.R")
source("R/stoch_rsi.R")
source("R/crossover.R")
source("R/crossunder.R")

# SMA
stopifnot(isTRUE(all.equal(sma(c(10, 12, 15, 20), 3), c(12.3333333333, 15.6666666667))))
# EMA
stopifnot(isTRUE(all.equal(ema(c(10, 12, 15), 3), c(10, 11, 13))))
# MACD structure and alignment
m <- macd(c(100, 105, 110, 115, 120, 125, 130), 3, 5, 2)
stopifnot(identical(names(m), c("macd_line", "signal_line", "histogram")))
stopifnot(length(m$macd_line) == 7L, length(m$signal_line) == 7L, length(m$histogram) == 7L)
stopifnot(isTRUE(all.equal(m$histogram, m$macd_line - m$signal_line)))
# Population standard deviation
stopifnot(isTRUE(all.equal(stdev(c(1, 2, 3)), sqrt(2 / 3))))
# Linear regression
lr <- linreg(c(1, 2, 3, 4, 5), 5, 0)
stopifnot(isTRUE(all.equal(lr$slope, 1)))
stopifnot(isTRUE(all.equal(lr$intercept, 0)))
stopifnot(isTRUE(all.equal(lr$predicted_values, c(1, 2, 3, 4, 5))))
lr_offset <- linreg(c(1, 2, 3, 4, 5), 5, 1)
stopifnot(isTRUE(all.equal(lr_offset$slope, 1)))
stopifnot(isTRUE(all.equal(lr_offset$intercept, 1)))
stopifnot(isTRUE(all.equal(lr_offset$predicted_values, c(2, 3, 4))))
# RSI edge cases
stopifnot(tail(rsi(c(1, 2, 3, 4, 5), 2), 1) == 100)
stopifnot(tail(rsi(c(5, 4, 3, 2, 1), 2), 1) == 0)
# StochRSI output structure
sr <- stoch_rsi(c(45, 50, 48, 55, 52, 49, 58, 60, 65, 62, 64, 61, 66, 63, 68, 65, 70), 3, 3, 2)
stopifnot(identical(names(sr), c("k_line", "d_line")))
stopifnot(length(sr$k_line) == 17L, length(sr$d_line) == 17L)
# Crossovers and crossunders
up <- crossover(c(1, 2, 3), c(2, 2, 2))
stopifnot(identical(up, c("None", "None", "Up")))
down <- crossunder(c(3, 2, 1), c(2, 2, 2))
stopifnot(identical(down, c("False", "False", "True")))

cat("All assignment function tests passed.\n")
