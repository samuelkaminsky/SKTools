#' Convert number to equivalent letter
#' @param x Number to be converted to letter (only works for numbers less than or equal to 702)
#' @param number Optional suffix to append to letter
#' @return Character string a letter and optional appended number
#' @export
#' @description Converts a number to an equivalent letter, with an option to concatenate a row value. Useful for adding data to existing Google Sheets
#' @examples
#' num2letter(1)
#' num2letter(26)
#' num2letter(1, 1)
num2letter <- function(x, number = "") {
  if (any(x <= 0)) {
    stop("Input must be positive integer")
  }
  paste0(openxlsx::int2col(x), number)
}
