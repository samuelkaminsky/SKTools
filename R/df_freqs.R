#' Dataframe Frequencies
#' @param df Dataframe with data
#' @return Dataframe of frequencies for each variable and value
#' @description Calculates frequencies of every Column in a dataframe
#' @export

df_freqs <-
  function(df) {
    purrr::map_df(purrr::set_names(names(df)), function(x) {
      df %>%
        dplyr::count_(x) %>% 
        purrr::set_names(c("value","n")) %>% 
        dplyr::mutate(value = as.character(.data$value))
    },.id="var")
  }