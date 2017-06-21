library(SKTools)

context("corr_summary")

test_that("corr_summary works for mtcars", {
  expect_equal(psych::corr.test(mtcars) %>%
                 corr_summary() %>%
                 nrow, 110)
  expect_equal(psych::corr.test(mtcars) %>% 
                 corr_summary() %>% 
                 .[99, 5] %>% 
                 round(6)
               , 7.155225)
})
