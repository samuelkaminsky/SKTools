#' Convert number to equivalent letter
#' @param x Vector of numbers to be converted to letters
#' @param number Optional suffix to append to each letter
#' @return Character vector of letters with optional appended numbers
#' @export
#' @description Converts a number to an equivalent letter, with an option to
#'   concatenate a row value. Useful for adding data to existing Google Sheets
#' @examples
#' num2letter(1)
#' num2letter(26)
#' num2letter(1, 1)
#' num2letter(1:3, 10:12)
num2letter <- function(x, number = "") {
  if (any(x <= 0, na.rm = TRUE)) {
    rlang::abort("Input `x` must contain only positive integers.")
  }
  paste0(cellranger::num_to_letter(x), number)
}
