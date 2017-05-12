#' Install commonly used packages
#' @param extra TRUE or FALSE to indicate whether you want to install supplemental packages
#' @export
#' @description Installs packages that I like
#' @details Packages installed with the default arguments include: 
#' * anytime
#' * data.table
#' * feather
#' * knitr
#' * lavaan
#' * openxlsx
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
#' * plotly
#' * qualtRics
#' * relaimpo
#' * reshape2
#' * semTools
#' * shinythemes
#' @md

install_sk <- function(extra = FALSE) {
  list.of.packages <-
    c(
      "anytime",
      "data.table",
      "feather",
      "knitr",
      "lavaan",
      "openxlsx",
      "psych",
      "rmarkdown",
      "roxygen2",
      "shiny",
      "sjmisc",
      "tidyverse"
    )
  if (isTRUE(extra)) {
    list.of.packages <-
      c(
        list.of.packages,
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
        "plotly",
        "relaimpo",
        "reshape2",
        "qualtRics",
        "semTools",
        "shinythemes"
      )
  }
  
  new.packages <-
    list.of.packages[!(list.of.packages %in% utils::installed.packages()[, "Package"])]
  if (length(new.packages)) {
    utils::install.packages(new.packages)
  } else {
    message("All packages already installed!")
  }
}
