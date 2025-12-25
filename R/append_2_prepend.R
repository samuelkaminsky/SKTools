#' append_2_prepend
#' @param df Dataframe
#' @param string String at end to move to beginning
#' @param sep String to insert between prepended string and rest of variable name
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
    df |>
      purrr::set_names(dplyr::if_else(
        endsWith(names(df), string),
        stringr::str_c(
          string,
          stringr::str_sub(
            names(df),
            start = 1,
            end = as.data.frame(stringr::str_locate(names(df), string))$start -
              2
          ),
          sep = sep
        ),
        names(df)
      ))
  }
