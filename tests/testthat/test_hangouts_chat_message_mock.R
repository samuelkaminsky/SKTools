library(SKTools)
library(testthat)
library(mockery)

test_that("hangouts_chat_message sends POST request", {
  m <- mock(structure(list(status_code = 200), class = "response"))
  stub(hangouts_chat_message, "httr::POST", m)

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

test_that("hangouts_chat_message throws error on API failure", {
  # Mock a 500 Internal Server Error response
  # We need to give it a 'response' class so stop_for_status recognizes it
  m <- mock(structure(list(status_code = 500, url = "https://example.com"),
                      class = "response"))
  stub(hangouts_chat_message, "httr::POST", m)

  expect_error(
    hangouts_chat_message("https://example.com", "Hello"),
    "Internal Server Error"
  )
})
