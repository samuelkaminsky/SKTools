library(SKTools)

test_that("num2letter works", {
  expect_equal(num2letter(1), "A")
  expect_equal(num2letter(26), "Z")
  expect_equal(num2letter(27), "AA")
  expect_equal(num2letter(702), "ZZ")
  expect_equal(num2letter(703), "AAA")
})
