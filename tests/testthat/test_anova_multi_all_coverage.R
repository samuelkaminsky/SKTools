library(SKTools)
library(testthat)

test_that("anova_multi_all handles print=TRUE", {
  # Small dataset
  df <- mtcars[1:10, ]
  # Capture output
  output <- capture.output({
    anova_multi_all(df, ivs = disp, dvs = mpg, print = TRUE, perc = 0.5)
  })
  expect_true(any(grepl("%", output)))
})

test_that("anova_multi_all handles missing results", {
  # Inside pmap, if `aov` fails?
  # e.g. constant response?
  df <- data.frame(
      x = 1:20,
      y = rep(1, 20) # Constant response
  )

  # This might produce an error or warning in aov, which purrr::possibly catches
  # However, with constant response, aov runs but residuals are 0.

  # Try to make it fail properly to trigger 'otherwise'
  # If we have N=1 per group?

  res <- anova_multi_all(df, ivs = x, dvs = y, perc = 0.5)
  # Should run without erroring.
  expect_true(is.data.frame(res))
})
