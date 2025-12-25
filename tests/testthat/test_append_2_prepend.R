library(SKTools)

test_that("append_2_prepend works for mtcars", {
  expect_equal(
    {
      mtcars |>
        dplyr::mutate(dplyr::across(
          everything(),
          list(mean = \(x) mean(x, na.rm = TRUE))
        )) |>
        SKTools::append_2_prepend("mean") |>
        names() |>
        (\(x) x[21])()
    },
    "mean_gear"
  )
})
