#' Convert number to equivalent letter
#' @param x Number to be converted to letter (only works for numbers less than or equal to 702)
#' @param number Number to be appended to letter
#' @return Character string a letter and optional appended number
#' @export
#' @description Converts a number to an equivalent letter, with an option to concatenate a row value. Useful for adding data to existing Google Sheets

num2letter <- function(x, number = "") {
  index <- data.frame(Numbers = (1:26), Letters = LETTERS)
  x.round <- trunc((x - 1) / 26)
  
  if (x.round == 0) {
    paste(index[x, 2], number, sep = "")
  } else{
    if (x.round > 0 & x.round < 27) {
      paste(index[x.round, 2], index[x - x.round * 26, 2], number, sep = "")
    } else {
      print("Input Value too high")
    }
  }
}