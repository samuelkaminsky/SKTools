test_that("descriptives works with grouped data", {
  grouped_df <- mtcars |> dplyr::group_by(cyl)
  result <- descriptives(grouped_df)

  expect_true(tibble::is_tibble(result))
  expect_true("cyl" %in% names(result))

  # Check that we have results for each group
  expect_equal(nrow(result |> dplyr::distinct(cyl)), 3)

  # Check stats for a specific group
  cyl4 <- result |> dplyr::filter(cyl == 4, var == "mpg")
  expect_equal(cyl4$mean, mean(mtcars$mpg[mtcars$cyl == 4]))
})

test_that("frequencies works with grouped data", {
  grouped_df <- mtcars |> dplyr::group_by(cyl)
  result <- frequencies(grouped_df)

  expect_true(tibble::is_tibble(result))
  expect_true("cyl" %in% names(result))

  # Check that we have results for each group
  expect_equal(nrow(result |> dplyr::distinct(cyl)), 3)

  # Check counts for a specific group
  # In group cyl=4, am should have 0 (auto) and 1 (manual)
  cyl4_am <- result |>
    dplyr::filter(cyl == 4, var == "am")

  expect_true(all(c("0", "1") %in% cyl4_am$value))
})
