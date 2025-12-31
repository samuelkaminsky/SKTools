library(SKTools)
library(testthat)

test_that("calculate_ai handles missing grouping columns", {
  df <- tibble::tibble(
    gender = c(rep("Male", 10), rep("Female", 10)),
    applied = c(rep(TRUE, 10), rep(TRUE, 10)),
    hired = c(rep(TRUE, 5), rep(FALSE, 5), rep(TRUE, 8), rep(FALSE, 2))
  )
  expect_warning(
    calculate_ai(df, groupings = c("gender", "missing_col"), stage1 = applied, stage2 = hired),
    "Groupings not found in file: missing_col"
  )
})

test_that("calculate_ai handles selection ratio > 1", {
  df <- tibble::tibble(
    gender = c("Male"),
    applied = c(1), # Just one person applied
    hired = c(2)    # Two people hired?
  )
  # So if columns are numeric, it sums.
  res <- calculate_ai(df, groupings = "gender", stage1 = applied, stage2 = hired)
  expect_true("Error" %in% names(res$adverse_impact))
  expect_match(res$adverse_impact$Error, "More people in stage 2 than in stage 1")
})

test_that("calculate_ai handles only_max = TRUE", {
  df <- tibble::tibble(
    gender = c(rep("Male", 100), rep("Female", 100), rep("Other", 100)),
    applied = rep(TRUE, 300),
    # Males: 50% pass (50/100)
    # Females: 80% pass (80/100) -> Highest
    # Other: 20% pass (20/100)
    hired = c(
      rep(TRUE, 50), rep(FALSE, 50),
      rep(TRUE, 80), rep(FALSE, 20),
      rep(TRUE, 20), rep(FALSE, 80)
    )
  )

  res <- calculate_ai(df, groupings = "gender", stage1 = applied, stage2 = hired, only_max = TRUE)

  # Comparisons should only be against Female (Denominator = Female)
  expect_true(all(res$adverse_impact$Denominator == "Female"))
})

test_that("calculate_ai returns error if no adverse impact comparisons possible", {
    df <- tibble::tibble(
        gender = c(rep("Male", 10)),
        applied = rep(TRUE, 10),
        hired = rep(TRUE, 10)
    )
    # Only one group, so no comparisons possible
    res <- calculate_ai(df, groupings = "gender", stage1 = applied, stage2 = hired)
    expect_match(res$adverse_impact$Error, "No adverse impact comparisons possible")
})
