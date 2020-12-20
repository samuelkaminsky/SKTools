library(SKTools)

context("descriptives")

test_that("descriptives works for mtcars", {
  expect_equal(descriptives(mtcars) %>% nrow(), 11)
  expect_equal(descriptives(mtcars) %>% .[[1, 7]] %>% unlist() %>% round(3), 0.499)
})
