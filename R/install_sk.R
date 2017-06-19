#' Install commonly used packages
#' @param extra TRUE or FALSE to indicate whether you want to install supplemental packages
#' @param dependencies TRUE or FALSE to indicate whether you want to pass TRUE to the install.packages() dependencies argument
#' @export
#' @description Installs packages that I like
#' @details Packages installed with the default arguments include: 
#' * anytime
#' * data.table
#' * feather
#' * knitr
#' * lavaan
#' * openxlsx
#' * pander
#' * psych
#' * rmarkdown
#' * roxygen2
#' * shiny
#' * sjmisc
#' * tidyverse
#' @details Packages installed with the extra=TRUE argument include: 
#' * car
#' * caret
#' * doParallel
#' * DT
#' * dtplyr
#' * effsize
#' * foreach
#' * formatR
#' * GGally
#' * ggthemes
#' * googlesheets
#' * gtools
#' * iopsych
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

install_sk <- function(extra = FALSE, dependencies = FALSE) {
  list_of_packages <-
    c(
      "anytime",
      "data.table",
      "feather",
      "knitr",
      "lavaan",
      "openxlsx",
      "pander",
      "psych",
      "rmarkdown",
      "roxygen2",
      "shiny",
      "sjmisc",
      "tidyverse"
    )
  if (isTRUE(extra)) {
    list_of_packages <-
      c(
        list_of_packages,
        "car",
        "caret",
        "doParallel",
        "DT",
        "dtplyr",
        "effsize",
        "foreach",
        "formatR",
        "GGally",
        "ggthemes",
        "googlesheets",
        "gtools",
        "iopsych",
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
  new.packages <-
    list_of_packages[!(list_of_packages %in% 
                         utils::installed.packages()[, "Package"])]
  if (length(new.packages)) {
    utils::install.packages(new.packages, dependencies = dependencies)
  } else {
    message("All packages already installed!")
  }
}
