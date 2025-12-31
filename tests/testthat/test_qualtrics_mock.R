library(SKTools)
library(testthat)
library(mockery)

test_that("qualtrics_prior_distros fetches and paginates", {
  m <- mock()
  stub(qualtrics_prior_distros, "httr::GET", m)

  # Prepare mock responses
  # Response 1: Distributions list
  resp1 <- list(
    result = list(
      elements = list(
        list(recipients = list(mailingListId = "ML_123"))
      )
    )
  )

  # Response 2: Contacts for ML_123 (First page)
  resp2 <- list(
    result = list(
      elements = list(
        list(id = "1", firstName = "John", lastName = "Doe", email = "john@example.com")
      ),
      nextPage = "https://example.com/nextpage"
    )
  )

  # Response 3: Contacts for ML_123 (Second page)
  resp3 <- list(
    result = list(
      elements = list(
        list(id = "2", firstName = "Jane", lastName = "Doe", email = "jane@example.com")
      ),
      nextPage = NULL
    )
  )

  # Mock httr::content to return these responses in order
  # But httr::GET is called first, then httr::content on the result.
  # So mock GET to return "response_object" and mock content to return the list based on input.

  m_content <- mock()
  stub(qualtrics_prior_distros, "httr::content", m_content)

  mockery::expect_called(m_content, 0)

  # We need to control what httr::content returns based on what it receives.
  # Or simply mock it to return values sequentially.
  # The function calls:
  # 1. GET distributions -> content() -> resp1
  # 2. GET contacts (ML_123) -> content() -> resp2
  # 3. GET nextPage -> content() -> resp3

  mockery::stub(qualtrics_prior_distros, "httr::content", m_content)
  mockery::expect_called(m_content, 0) # Just to be safe? No.

  # Set up return values for content
  mockery::stub(qualtrics_prior_distros, "httr::content", function(x) {
    if (x == "r1") {
      return(resp1)
    }
    if (x == "r2") {
      return(resp2)
    }
    if (x == "r3") {
      resp3
    }
  })

  # Set up return values for GET
  mockery::stub(qualtrics_prior_distros, "httr::GET", function(url, query = NULL, ...) {
    if (grepl("/distributions", url)) {
      return("r1")
    }
    if (grepl("/contacts", url)) {
      return("r2")
    }
    if (url == "https://example.com/nextpage") {
      return("r3")
    }
    "unknown"
  })

  # Call function
  res <- qualtrics_prior_distros("SV_123", "TOKEN")

  expect_equal(nrow(res), 2)
  expect_equal(res$firstName, c("John", "Jane"))
})

test_that("qualtrics_prior_distros validates inputs", {
  expect_error(qualtrics_prior_distros("ID", "TOKEN", datacenter = "bad_dc!"), "Invalid datacenter format")
})
