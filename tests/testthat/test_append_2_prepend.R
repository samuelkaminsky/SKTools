library(SKTools)
# library(dplyr)

context("append_2_prepend")

test_that("append_2_prepend works for mtcars", {
  expect_equal({
    mtcars %>% 
      dplyr::mutate_all(dplyr::funs(mean=mean(.,na.rm=TRUE))) %>% 
      SKTools::append_2_prepend("mean") %>% names() %>% .[21]
    }, "mean_gear")
})