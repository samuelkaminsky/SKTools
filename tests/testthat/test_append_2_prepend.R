library(SKTools)

test_that("append_2_prepend works for mtcars", {
  expect_equal(
    {
      mtcars %>%
        dplyr::mutate(dplyr::across(everything(), list(mean = ~ mean(., na.rm = TRUE)))) %>%
        SKTools::append_2_prepend("mean") %>%
        names() %>%
        .[21]
    },
    "mean_gear"
  )
})
