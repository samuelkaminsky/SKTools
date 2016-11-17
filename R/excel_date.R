#' Convert date from Excel (Windows) to R
#'
#' @param x Vector of dates
#' @return POSIXct date value
#' @export

excel_date <- function(x) {
  as.Date(as.numeric(x),origin="1899-12-30")
}

