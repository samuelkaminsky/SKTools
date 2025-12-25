library(SKTools)

test_example <-
  ttest_all(mtcars, c(carb, mpg), c(cyl, drat), perc = .2) |>
  dplyr::filter(
    .data$IV == "mpg",
    .data$DV == "cyl",
    .data$Cutoff.Perc == "45%"
  ) |>
  dplyr::pull(.data$conf.high) |>
  round(6)

test_that("ttest_all has predictable result for mtcars", {
  expect_equal(
    test_example,
    3.506439
  )
})
