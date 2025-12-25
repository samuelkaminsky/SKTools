context("New Functions Tests")

test_that("calculate_ai works correctly", {
  df_ai <- tibble::tibble(
    Group = c(rep("A", 100), rep("B", 100)),
    Applied = c(rep(TRUE, 100), rep(TRUE, 100)),
    Passed = c(rep(TRUE, 80), rep(FALSE, 20), rep(TRUE, 40), rep(FALSE, 60))
  )

  res <- calculate_ai(
    df_ai,
    groupings = "Group",
    stage1 = Applied,
    stage2 = Passed
  )

  expect_type(res, "list")
  expect_equal(names(res), c("Selection.Ratio", "Adverse.Impact"))

  sr <- res$Selection.Ratio
  expect_equal(nrow(sr), 2)
  expect_equal(sr |> dplyr::filter(Group == "A") |> dplyr::pull(SR), 0.8)
  expect_equal(sr |> dplyr::filter(Group == "B") |> dplyr::pull(SR), 0.4)

  ai <- res$Adverse.Impact
  # Should compare A and B
  # A (0.8) vs B (0.4). AI Ratio = 0.4 / 0.8 = 0.5 (if B is Num, A is Denom)
  # The function creates all crossings.

  # Check if A vs B exists
  pair <- ai |> dplyr::filter(Numerator == "B", Denominator == "A")
  expect_equal(nrow(pair), 1)
  expect_equal(pair$ai.ratio, 0.5)
})

test_that("distinct_2col removes duplicates regardless of order", {
  df <- tibble::tibble(
    c1 = c("A", "B", "C", "A"),
    c2 = c("B", "A", "D", "B")
  )
  # Rows:
  # 1: A, B
  # 2: B, A -> Same as 1
  # 3: C, D
  # 4: A, B -> Same as 1

  res <- distinct_2col(df, c1, c2)
  expect_equal(nrow(res), 2)
  # Should keep "A"-"B" (or "B"-"A") and "C"-"D"
})

test_that("frequencies works", {
  res <- frequencies(mtcars)
  expect_true(nrow(res) > 0)
  expect_true("var" %in% names(res))
  expect_true("value" %in% names(res))
  expect_true("n" %in% names(res))

  # Check specific value
  cyl_freq <- res |> dplyr::filter(var == "cyl", value == "4")
  expect_equal(cyl_freq$n, 11)

  # Test with perc=TRUE
  res_p <- frequencies(mtcars, perc = TRUE)
  expect_true("perc" %in% names(res_p))
  expect_true("valid.perc" %in% names(res_p))
})

test_that("list_names works", {
  res <- list_names(mtcars, mpg, cyl)
  expect_equal(res, c(mpg = "mpg", cyl = "cyl"))

  res_all <- list_names(mtcars, dplyr::everything())
  expect_equal(length(res_all), ncol(mtcars))
})

test_that("quality_check prints messages", {
  df <- tibble::tibble(
    const = rep(1, 10),
    skewed = c(rep(1, 9), 100), # Very skewed
    normal = rnorm(10)
  )

  # quality_check prints to message()
  expect_message(quality_check(df), "NO VARIANCE")
  expect_message(quality_check(df), "SKEWNESS")
})
