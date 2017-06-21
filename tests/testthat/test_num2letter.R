library(SKTools)

context("num2letter")

test_that("num2letter works for numbers < 26 and > 26 ", {
  expect_equal(num2letter(1), "A")
  expect_equal(num2letter(26), "Z")
  expect_equal(num2letter(27), "AA")
})

test_that("num2letter prints warning when number is too high ", {
  prints_text(num2letter(703), "Input Value too high")
})

