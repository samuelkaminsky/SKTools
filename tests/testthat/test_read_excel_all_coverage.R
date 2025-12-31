library(SKTools)
library(testthat)

test_that("read_excel_all works with check_names=TRUE and single sheet", {
  # Create a dummy excel file with bad names
  df <- data.frame(`Bad Name` = 1)
  tmp <- tempfile(fileext = ".xlsx")
  writexl::write_xlsx(df, tmp)

  res <- read_excel_all(tmp, check_names = TRUE)
  expect_equal(names(res), "Bad.Name")
})

test_that("read_excel_all works with check_names=TRUE and multiple sheets", {
  # Create a dummy excel file with bad names
  df1 <- data.frame(`Bad Name` = 1)
  df2 <- data.frame(`Bad Name 2` = 2)
  tmp <- tempfile(fileext = ".xlsx")
  writexl::write_xlsx(list(Sheet1 = df1, Sheet2 = df2), tmp)

  res <- read_excel_all(tmp, check_names = TRUE)
  expect_equal(names(res$Sheet1), "Bad.Name")
  expect_equal(names(res$Sheet2), "Bad.Name.2")
})

test_that("read_excel_all works with custom names", {
  df1 <- data.frame(a = 1)
  df2 <- data.frame(b = 2)
  tmp <- tempfile(fileext = ".xlsx")
  writexl::write_xlsx(list(Sheet1 = df1, Sheet2 = df2), tmp)

  res <- read_excel_all(tmp, names = c("Custom1", "Custom2"))
  expect_named(res, c("Custom1", "Custom2"))
})

test_that("read_excel_all saves to env", {
  df1 <- data.frame(a = 1)
  df2 <- data.frame(b = 2)
  tmp <- tempfile(fileext = ".xlsx")
  writexl::write_xlsx(list(Sheet1 = df1, Sheet2 = df2), tmp)

  env <- new.env()
  # Mock list2env or verify side effects if possible
  # For now we just call it with save2env=TRUE to ensure code coverage
  # Note: list2env uses .GlobalEnv by default in the function code, which we can't easily capture
  # without mocking.
  # Just running it to cover the lines.
  res <- read_excel_all(tmp, save2env = TRUE)
  # It returns the list even if save2env is TRUE (actually list2env returns env invisibly)
  # The function returns whatever list2env returns if save2env=TRUE.
  expect_true(is.environment(res))
})
