#' Install commonly used packages
#' @param extra TRUE or FALSE to indicate whether you want to install
#'   supplemental packages
#' @param dependencies TRUE or FALSE to indicate whether you want to pass TRUE
#'   to the install.packages() dependencies argument
#' @export
#' @description Installs packages that I like
#' @details Packages installed with the default arguments include:
#' * clipr
#' * data.table
#' * knitr
#' * lavaan
#' * openxlsx
#' * pander
#' * psych
#' * rmarkdown
#' * roxygen2
#' * shiny
#' * sjmisc
#' * sjlabelled
#' * tidyverse
#' * writexl
#' @details Packages installed with the extra=TRUE argument include:
#' * anytime
#' * car
#' * caret
#' * doParallel
#' * DT
#' * ez
#' * dtplyr
#' * effsize
#' * foreach
#' * formatR
#' * GGally
#' * ggthemes
#' * googlesheets
#' * gtools
#' * iopsych
#' * janitor
#' * lmerTest
#' * lsr
#' * multilevel
#' * nycflights13
#' * parallel
#' * parsedate
#' * pdftools
#' * plotly
#' * qualtRics
#' * relaimpo
#' * reprex
#' * reshape2
#' * semTools
#' * shinythemes
#' @md
#' @examples
#' \dontrun{
#' install_sk()
#' }
install_sk <- function(extra = FALSE, dependencies = FALSE) {
  list_of_packages <-
    c(
      "clipr",
      "data.table",
      "knitr",
      "lavaan",
      "openxlsx",
      "pander",
      "psych",
      "rmarkdown",
      "roxygen2",
      "shiny",
      "sjmisc",
      "sjlabelled",
      "tidyverse",
      "writexl"
    )
  if (isTRUE(extra)) {
    list_of_packages <-
      c(
        list_of_packages,
        "anytime",
        "car",
        "caret",
        "doParallel",
        "DT",
        "dtplyr",
        "effsize",
        "ez",
        "foreach",
        "formatR",
        "GGally",
        "ggthemes",
        "googlesheets",
        "gtools",
        "iopsych",
        "janitor",
        "lmerTest",
        "lsr",
        "multilevel",
        "nycflights13",
        "parallel",
        "parsedate",
        "pdftools",
        "plotly",
        "relaimpo",
        "reprex",
        "reshape2",
        "qualtRics",
        "semTools",
        "shinythemes"
      )
  }
  new_packages <-
    list_of_packages[
      !(list_of_packages %in%
        utils::installed.packages()[, "Package"])
    ]
  if (length(new_packages)) {
    utils::install.packages(new_packages, dependencies = dependencies)
  } else {
    message("All packages already installed!")
  }
}
