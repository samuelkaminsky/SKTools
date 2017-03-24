#' Install commonly used packages
#' @param extra TRUE or FALSE to indicate whether you want to install supplemental packages
#' @export
#' @description Installs packages that I like

install.sk <- function(extra = FALSE) {
  list.of.packages <-
    c(
      "tidyverse",
      "openxlsx",
      "car",
      "sjmisc",
      "data.table",
      "rmarkdown",
      "psych",
      "shiny"
    )
  
  if (isTRUE(extra)) {
    c(
      list.of.packages,
      "googlesheets",
      "lsr",
      "parallel",
      "doParallel",
      "foreach",
      "dtplyr",
      "feather",
      "GGally",
      "knitr",
      "lavaan"
    )
  }
  
  new.packages <-
    list.of.packages[!(list.of.packages %in% installed.packages()[, "Package"])]
  if (length(new.packages)) {
    install.packages(new.packages)
  }
}
