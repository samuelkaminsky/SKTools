#' \code{SKTools} package
#'
#' Samuel Kaminsky's Tools
#'
#' @importFrom rlang .data
#' @importFrom rlang :=
#' @importFrom dplyr everything where across
"_PACKAGE"

if (getRversion() >= "2.15.1") {
  utils::globalVariables(c(
    "percentage",
    "IV",
    "DV",
    "estimate",
    "estimate1"
  ))
}
