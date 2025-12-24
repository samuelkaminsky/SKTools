context("Side Effects and API Tests")

test_that("hangouts_chat_message exists", {
  skip("Requires Webhook URL and internet")
  expect_true(is.function(hangouts_chat_message))
})

test_that("insertInAddin exists", {
  skip("Requires RStudio API")
  expect_true(is.function(insertInAddin))
})

test_that("install_sk exists", {
  skip("Requires GitHub access and installation side effects")
  expect_true(is.function(install_sk))
})

test_that("qualtrics_prior_distros exists", {
  skip("Requires Qualtrics API token")
  expect_true(is.function(qualtrics_prior_distros))
})

test_that("setwd_script exists", {
  skip("Requires RStudio API and side effects")
  expect_true(is.function(setwd_script))
})

test_that("update_github_pkgs exists", {
  skip("Requires GitHub access and side effects")
  expect_true(is.function(update_github_pkgs))
})
