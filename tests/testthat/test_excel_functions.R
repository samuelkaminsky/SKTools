library(SKTools)

context("Excel Tests")

test_that("read_excel_all has predictable result", {
  expect_equal(
    {
      read_excel_all("excel_test.xlsx")
    },
    readr::read_rds("excel_test_tidy.rds")
  )
})

test_that("read.xlsx.all has predictable result", {
  expect_equal(
    {
      read.xlsx.all("excel_test.xlsx")
    },
    readr::read_rds("excel_test_open.rds")
  )
})
