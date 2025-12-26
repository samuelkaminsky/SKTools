# Project Overview

**SKTools** is an R package developed by Samuel Kaminsky designed to
facilitate data import, cleaning, and analysis. It provides a collection
of utility functions that streamline common tasks when working with data
frames in R.

## Key Features

- **Data Import/Export:** Functions like `read_excel_all` and
  `read.xlsx.all` for handling multiple sheets/files.
- **Descriptive Statistics:** Tools like `descriptives` and
  `frequencies` for quick data summarization.
- **Data Manipulation:** Helpers like `append_2_prepend` and
  `distinct_2col`.
- **Integration:** Designed to work well with the `tidyverse` ecosystem.

## Technical Architecture

- **Language:** R
- **Package Structure:** Standard R package structure (`R/` for source,
  `man/` for docs, `tests/` for unit tests).
- **Dependencies:** Heavy reliance on the tidyverse (`dplyr`, `purrr`,
  `tidyr`, `readr`), plus `openxlsx`, `psych`, and others listed in
  `DESCRIPTION`.

# Building and Running

## Prerequisites

- **R:** Version \>= 3.1.0
- **devtools/remotes:** For package development and installation.

## Installation

To install the package from the source or GitHub:

``` r
# From GitHub
remotes::install_github("samuelkaminsky/SKTools")

# Locally (from project root)
devtools::install()
```

## Testing

The project uses the `testthat` framework for unit testing.

To run tests:

``` r
devtools::test()
```

Or specifically:

``` r
testthat::test_dir("tests/testthat")
```

## Documentation

Documentation is generated using `roxygen2`. To update documentation
(man pages):

``` r
devtools::document()
```

# Development Conventions

## Coding Style

- **Tidyverse Style:** The code heavily utilizes the pipe operator
  (`%>%`) and `dplyr` verbs.
- **Explicit Namespacing:** Functions from other packages are generally
  called with their namespace (e.g.,
  [`dplyr::mutate`](https://dplyr.tidyverse.org/reference/mutate.html),
  [`stats::sd`](https://rdrr.io/r/stats/sd.html)) rather than relying on
  [`library()`](https://rdrr.io/r/base/library.html) calls within
  functions. This is a best practice for package development.
- **Pronouns:** Usage of `.data` pronoun inside `dplyr` verbs to avoid
  ambiguity (e.g., `.data$value`).

## Documentation

- **Roxygen2:** All exported functions are documented using Roxygen2
  comments (`#'`) immediately preceding the function definition.
- **Parameters:** `@param`, `@return`, `@export`, and `@description`
  tags are standard.

## Version Control

- **Git:** The project is version-controlled with Git.
- **CI/CD:** Configuration exists for GitHub Actions (in
  `.github/workflows`).
