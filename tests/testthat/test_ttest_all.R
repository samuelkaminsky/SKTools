library(SKTools)

context("ttest_all")

test_that("ttest_all has predictable result for mtcars", {
  expect_equal(
    {
      ttest_all(mtcars, c(carb, mpg), c(cyl, drat), perc = .2) %>%
        dplyr::filter(.data$IV == "mpg", .data$DV == "cyl", .data$Cutoff.Perc == "45%") %>%
        dplyr::pull(.data$conf.high) %>%
        round(6)
    },
    3.506439
  )
})
