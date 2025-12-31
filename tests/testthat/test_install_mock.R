library(SKTools)
library(testthat)
library(mockery)

test_that("install_sk installs packages", {
  m_install <- mock()
  m_installed <- mock(matrix(
    c("SKTools"),
    ncol = 1,
    dimnames = list(NULL, "Package")
  ))

  stub(install_sk, "utils::install.packages", m_install)
  stub(install_sk, "utils::installed.packages", m_installed)

  install_sk()

  expect_called(m_install, 1)
  # Default list should be installed
})

test_that("install_sk handles extra packages", {
  m_install <- mock()
  m_installed <- mock(matrix(
    c("SKTools"),
    ncol = 1,
    dimnames = list(NULL, "Package")
  ))

  stub(install_sk, "utils::install.packages", m_install)
  stub(install_sk, "utils::installed.packages", m_installed)

  install_sk(extra = TRUE)

  expect_called(m_install, 1)
  args <- mock_args(m_install)[[1]]
  expect_true("shinythemes" %in% args[[1]])
})

test_that("update_github_pkgs updates packages", {
  m_detach <- mock()
  m_install_github <- mock()
  m_library <- mock()

  # Mock installed packages to return a package with Github info
  pkg_desc <- list(GithubUsername = "user", GithubRepo = "repo")
  m_installed <- mock(data.frame(Package = "MyPkg", stringsAsFactors = FALSE))

  stub(update_github_pkgs, "detach", m_detach)
  stub(update_github_pkgs, "utils::installed.packages", m_installed)
  stub(update_github_pkgs, "utils::packageDescription", pkg_desc)
  stub(update_github_pkgs, "devtools::install_github", m_install_github)
  stub(update_github_pkgs, "library", m_library)

  # Mock .packages() to return SKTools so detach logic runs
  # But .packages() is in base, might be hard to mock if called directly as .packages().
  # The code uses `.packages()`.
  # mockery::stub doesn't easily mock base functions in the package namespace if they are not imported?
  # But let's try.

  # Actually `update_github_pkgs` calls `.packages()`.
  # If we can't mock it, we can ensure SKTools is attached or not.
  # It is attached because we loaded it.

  # We need to be careful with detach/library as they affect the session.
  # Mocking them prevents side effects.

  update_github_pkgs()

  expect_called(m_install_github, 1)
  expect_equal(mock_args(m_install_github)[[1]][[1]], "user/repo")
})