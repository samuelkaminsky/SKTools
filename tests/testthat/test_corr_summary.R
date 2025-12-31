library(SKTools)

test_that("corr_summary works for mtcars", {
  skip_if_not_installed("psych")
  mtcars_ct <- psych::corr.test(mtcars)
  expect_equal(
    mtcars_ct |>
      corr_summary() |>
      nrow(),
    110
  )
  expect_equal(
    mtcars_ct |>
      corr_summary() |>
      dplyr::slice(99) |>
      dplyr::pull(.data$t) |>
      round(6),
    7.155225
  )
})
