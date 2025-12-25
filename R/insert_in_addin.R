#' Insert in in RStudio
#' @export
#' @description Inserts %in% into text editor

insert_in_addin <- function() {
  rstudioapi::insertText(" %in% ")
}
