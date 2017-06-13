#' append_2_prepend
#' @param df Dataframe
#' @param string String at end to move to beginning
#' @return Data frame with corrected column names
#' @description Move string at end of column name to beginning
#' @export

append_2_prepend <-
  function(df, string) {
    df %>%
      purrr::set_names(dplyr::if_else(
        endsWith(names(.), string),
        stringr::str_c(
          string,
          stringr::str_sub(
            names(.),
            start = 1,
            end = as.data.frame(stringr::str_locate(names(.), string))$start - 2
          ),
          sep = "_"
        ),
        names(.)
      ))}
    