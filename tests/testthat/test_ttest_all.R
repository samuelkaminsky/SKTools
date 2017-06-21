library(SKTools)

context("ttest_all")

test_that("ttest_all has predictable result for mtcars", {
  expect_equal({
    ttest_all(mtcars,c(carb,mpg),c(cyl,drat),perc = .2) %>%
      .[[6,"cd.est"]] %>% 
      round(6)
  }, -3.003091)
})
