library(SKTools)

test_that("num2letter works for numbers < 26 and > 26 ", {
  expect_equal(num2letter(1), "A")
  expect_equal(num2letter(26), "Z")
  expect_equal(num2letter(27), "AA")
})

expect_that(
  num2letter(703),
  prints_text("Input Value too high")
)
