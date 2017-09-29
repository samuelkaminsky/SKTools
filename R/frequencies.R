#' Dataframe Frequencies
#' @param df Dataframe with data
#' @return Dataframe of frequencies for each variable and value
#' @description Calculates frequencies of every Column in a dataframe
#' @export

frequencies <-
  function(df) {
    df %>%
      names() %>%
      purrr::set_names() %>%
      purrr::map_df(function(x) {
        x <- as.name(x)
        df %>%
          dplyr::count(!!x) %>%
          purrr::set_names("value", "n") %>%
          dplyr::mutate(value = as.character(.data$value))
      }, .id = "var")
  }