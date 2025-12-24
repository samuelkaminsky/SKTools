#' Convert number to equivalent letter
#' @param x Number to be converted to letter (only works for numbers less than or equal to 702)
#' @param number Number to be appended to letter
#' @return Character string a letter and optional appended number
#' @export
#' @description Converts a number to an equivalent letter, with an option to concatenate a row value. Useful for adding data to existing Google Sheets

num2letter <- function(x, number = "") {
  if (any(x <= 0)) stop("Input must be positive integer")
  paste0(openxlsx::int2col(x), number)
}
