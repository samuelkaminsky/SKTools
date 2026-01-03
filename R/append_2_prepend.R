#' append_2_prepend
#' @param df Dataframe
#' @param string String at end to move to beginning
#' @param sep String to insert between prepended string and rest of variable
#'   name
#' @return Data frame with corrected column names
#' @description Move string at end of column name to beginning
#' @export
#' @examples
#' df <- tibble::tibble(
#'   x_suff = 1:5,
#'   y_suff = 1:5,
#'   z = 1:5
#' )
#' append_2_prepend(df, "suff", "_")
append_2_prepend <-
  function(df, string, sep = "_") {
    new_names <- names(df)
    matches <- endsWith(new_names, string)

    new_names[matches] <-
      stringr::str_replace(
        new_names[matches],
        paste0("^(.*?)(?:[._])?", stringr::str_escape(string), "$"),
        paste0(string, sep, "\\1")
      )

    purrr::set_names(df, new_names)
  }
