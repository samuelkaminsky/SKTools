#' Insert in in RStudio
#' @export
#' @description Inserts %in% into text editor

insertInAddin <- function() {
  rstudioapi::insertText(" %in% ")
}
