library(SKTools)

context("anova_multi")

test_that("anova_multi has predictable result for mtcars", {
  expect_equal({
    anova_multi(mtcars,carb,mpg:cyl) %>% 
      .[[1,2]] %>% 
      round(6)
      
  }, 25.3429)
})

test_that("anova_multi has predictable result for mtcars", {
  expect_that({
    anova_multi(mtcars,carb,mpg:cyl,print = TRUE) %>% 
      .[[1,2]] %>% 
      round(6)
  }, prints_text("10"))
})