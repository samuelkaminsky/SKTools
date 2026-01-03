library(SKTools)

test_that("append_2_prepend handles suffixes that appear earlier in the string", {
  df <- tibble::tibble(
    suff_x_suff = 1,
    x_suff = 1
  )
  
  result <- append_2_prepend(df, "suff")
  
  expect_equal(names(result)[1], "suff_suff_x")
  expect_equal(names(result)[2], "suff_x")
})

test_that("append_2_prepend handles special characters in suffix", {
  df <- tibble::tibble(
    `x.y` = 1
  )
  # string="y", sep default "_" -> matches "x.y". "." is separator.
  # prefix "x". new: "y_x"
  result <- append_2_prepend(df, "y")
  expect_equal(names(result)[1], "y_x")
})
