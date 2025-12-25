#' Insert \%in\% Operator in RStudio
#' @export
#' @description Inserts \%in\% into text editor
#' @examples
#' \dontrun{
#' # This function is intended to be used as an RStudio Addin
#' insert_in_addin()
#' }
insert_in_addin <- function() {
  rstudioapi::insertText(" %in% ")
}
