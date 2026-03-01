library(SKTools)

test_that("anova_multi_all has predictable result for mtcars", {
  anova_multi_result <-
    SKTools::anova_multi_all(mtcars, c(carb, mpg), c(cyl, drat), perc = .2) |>
    dplyr::filter(
      .data$iv == "mpg",
      .data$dv == "cyl",
      .data$Cutoff.Bottom == "65%",
      .data$Cutoff.Top == "85%"
    ) |>
    dplyr::pull(`p.value.2-1`) |>
    round(6)

  expect_equal(
    anova_multi_result,
    0.829579
  )
})
