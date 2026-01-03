library(SKTools)
library(testthat)
library(mockery)

test_that("insert_in_addin inserts text", {
  m <- mock()
  stub(insert_in_addin, "rstudioapi::insertText", m)

  insert_in_addin()

  expect_called(m, 1)
  args <- mock_args(m)[[1]]
  expect_equal(args[[1]], " %in% ")
})

test_that("setwd_script sets working directory", {
  m_context <- mock(list(path = "/path/to/script.R"))
  m_setwd <- mock()

  stub(setwd_script, "rstudioapi::getSourceEditorContext", m_context)
  stub(setwd_script, "setwd", m_setwd)
  stub(setwd_script, "dirname", function(x) "/path/to")

  setwd_script()

  expect_called(m_context, 1)
  expect_called(m_setwd, 1)
  expect_equal(mock_args(m_setwd)[[1]][[1]], "/path/to")
})
