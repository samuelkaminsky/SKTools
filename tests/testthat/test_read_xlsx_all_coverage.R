library(SKTools)
library(testthat)

test_that("read_xlsx_all works with custom names", {
  df1 <- data.frame(a = 1)
  df2 <- data.frame(b = 2)
  tmp <- tempfile(fileext = ".xlsx")
  writexl::write_xlsx(list(Sheet1 = df1, Sheet2 = df2), tmp)

  res <- read_xlsx_all(tmp, names = c("Custom1", "Custom2"))
  expect_named(res, c("Custom1", "Custom2"))
})

test_that("read_xlsx_all detects dates", {
  # It is hard to construct a xlsx with dates using writexl that openxlsx sees
  # as dates cleanly sometimes? But writexl should do it.
  df <- data.frame(Date = as.Date("2021-01-01"))
  tmp <- tempfile(fileext = ".xlsx")
  writexl::write_xlsx(df, tmp)

  res <- read_xlsx_all(tmp, detect_dates = TRUE)
  expect_s3_class(res$Date, "Date")
})
