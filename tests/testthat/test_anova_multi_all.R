library(SKTools)

context("anova_multi_all")

test_that("anova_multi_all has predictable result for mtcars", {
  expect_equal(
    {
      SKTools::anova_multi_all(mtcars, c(carb, mpg), c(cyl, drat), perc = .2) %>%
        unlist() %>%
        .[[length(.) - 3]] %>%
        as.character()
    },
    "0.829579"
  )
})
