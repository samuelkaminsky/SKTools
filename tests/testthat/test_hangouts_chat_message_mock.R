library(SKTools)
library(testthat)
library(mockery)

test_that("hangouts_chat_message sends POST request", {
  m <- mock(list(status_code = 200))
  stub(hangouts_chat_message, "httr::POST", m)
  stub(hangouts_chat_message, "httr::stop_for_status", function(...) TRUE)

  # Call function
  hangouts_chat_message("https://example.com", "Hello")

  # Check if POST was called
  expect_called(m, 1)

  # Check arguments
  args <- mock_args(m)[[1]]
  expect_equal(args[[1]], "https://example.com")

  # Check body
  body <- jsonlite::fromJSON(args$body)
  expect_equal(body$text, "Hello")
})

test_that("hangouts_chat_message validates inputs", {
  expect_error(hangouts_chat_message(123, "Hello"))
  expect_error(hangouts_chat_message("url", ""))
})
