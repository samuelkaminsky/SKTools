library(SKTools)

test_that("descriptives works for mtcars", {
  expect_equal(descriptives(mtcars) |> nrow(), 11)
  # Check sd of 'mpg'
  sd_val <- descriptives(mtcars) |>
    dplyr::filter(var == "mpg") |>
    dplyr::pull(sd)
  expect_equal(round(sd_val, 2), 6.03)

  # Check sd of 'am' (which was 0.499)
  sd_val_am <- descriptives(mtcars) |>
    dplyr::filter(var == "am") |>
    dplyr::pull(sd)
  expect_equal(round(sd_val_am, 3), 0.499)
})
