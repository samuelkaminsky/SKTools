#' Checks quality of data in a data frame
#'
#' @param df A data frame.
#' @author Eric Knudsen <eknudsen88@gmail.com>
#' @return Prints messages identifying columns with no variance and those
#'   with strong or moderate skewness.
#' @export
#' @examples
#' df <- tibble::tibble(
#'   no_var = c(1, 1, 1, 1),
#'   skewed = c(1, 1, 1, 100)
#' )
#' quality_check(df)
quality_check <- function(df) {
  # Columns with no variance
  no_variance <-
    df |>
    purrr::map_lgl(\(x) length(unique(x)) <= 1) |>
    which() |>
    names()

  message(".........NO VARIANCE.........")
  if (length(no_variance) > 0) {
    message(paste(no_variance, collapse = ", "))
  } else {
    message("None")
  }

  # Skewness for numeric columns
  num_cols <- df |> dplyr::select(where(is.numeric))

  if (ncol(num_cols) > 0) {
    skews <- num_cols |> purrr::map_dbl(moments::skewness, na.rm = TRUE)

    high_neg <- names(skews)[skews < -1]
    high_pos <- names(skews)[skews > 1]
    mod_neg <- names(skews)[skews < -0.5 & skews >= -1]
    mod_pos <- names(skews)[skews > 0.5 & skews <= 1]

    message("\n.........SKEWNESS.........")
    message(paste("Strong (-): ", paste(high_neg, collapse = ", "), sep = ""))
    message(paste("Strong (+): ", paste(high_pos, collapse = ", "), sep = ""))
    message(paste("Moderate (-): ", paste(mod_neg, collapse = ", "), sep = ""))
    message(paste("Moderate (+): ", paste(mod_pos, collapse = ", "), sep = ""))
  }
}
