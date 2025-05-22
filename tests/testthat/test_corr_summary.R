library(SKTools)

mtcars_ct <- psych::corr.test(mtcars)

test_that("corr_summary works for mtcars", {
  expect_equal(
    mtcars_ct |> 
      corr_summary() |> 
      nrow(),
    110
  )
  expect_equal(
    mtcars_ct |> 
      corr_summary() |> 
      dplyr::slice(99) |> 
      dplyr::pull(.data$t) |> 
      round(6),
    7.155225
  )
})
