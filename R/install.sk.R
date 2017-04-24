#' Install commonly used packages
#' @param extra TRUE or FALSE to indicate whether you want to install supplemental packages
#' @export
#' @description Installs packages that I like

install.sk <- function(extra = FALSE) {
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
        "dtplyr",
        "effsize",
        "foreach",
        "GGally",
        "googlesheets",
        "gtools",
        "lsr",
        "parallel",
        "semTools",
        "reshape2"
      )
  }
  
  new.packages <-
    list.of.packages[!(list.of.packages %in% utils::installed.packages()[, "Package"])]
  if (length(new.packages)) {
    utils::install.packages(new.packages)
  }
}
