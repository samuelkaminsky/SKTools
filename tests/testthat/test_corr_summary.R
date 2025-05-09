library(SKTools)

test_that("corr_summary works for mtcars", {
  expect_equal(
    psych::corr.test(mtcars) %>%
      corr_summary() %>%
      nrow(),
    110
  )
  expect_equal(
    psych::corr.test(mtcars) %>%
      corr_summary() %>%
      dplyr::slice(99) %>%
      dplyr::pull(.data$t) %>%
      round(6),
    7.155225
  )
})
