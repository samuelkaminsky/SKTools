library(SKTools)

anova.multi.result <-
  SKTools::anova_multi_all(mtcars, c(carb, mpg), c(cyl, drat), perc = .2) %>%
  dplyr::slice(37) %>% 
  dplyr::pull(`p.value.2-1`) %>%
  round(6)

test_that("anova_multi_all has predictable result for mtcars", {
  expect_equal(
    anova.multi.result,
    0.829579
  )
})
