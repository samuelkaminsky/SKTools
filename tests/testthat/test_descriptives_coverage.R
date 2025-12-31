library(SKTools)
library(testthat)

test_that("descriptives handles character columns correctly", {
  df <- data.frame(a = c("a", "b", "c"))
  res <- descriptives(df)
  expect_equal(res$class, "character")
  expect_false("mean" %in% names(res))
})

test_that("descriptives handles mixed numeric and character", {
  df <- data.frame(a = c(1, 2, 3), b = c("a", "b", "c"))
  res <- descriptives(df)
  expect_equal(nrow(res), 2)
})

test_that("descriptives returns frequencies when requested", {
    df <- data.frame(a = c(1, 2, 2))
    res <- descriptives(df, frequencies = TRUE)
    expect_true("frequencies" %in% names(res))
    expect_equal(res$frequencies[[1]]$n, c(1, 2))
})

test_that("descriptives handles factor columns", {
    df <- data.frame(a = factor(c("a", "b", "c")))
    res <- descriptives(df)
    expect_equal(res$class, "character") # It converts factor to character
})

test_that("descriptives handles all NA numeric", {
    df <- data.frame(a = c(NA_real_, NA_real_))
    res <- descriptives(df)
    expect_true(is.na(res$mean))
    expect_equal(res$n_unique, 0)
})

test_that("descriptives handles no numeric columns", {
    df <- data.frame(a = c("a", "b"))
    res <- descriptives(df)
    expect_false("mean" %in% names(res))
})
