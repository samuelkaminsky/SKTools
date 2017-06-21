#' Dataframe Frequencies
#' @param df Dataframe with data
#' @return Data frame of frequencies for each variable and value
#' @description Calculate Frequencies of Every Column in a Dataframe
#' @export

df_freqs <-
  function(df) {
    purrr::map_df(purrr::set_names(names(df)), function(x) {
      df %>%
        dplyr::count_(x) %>% 
        purrr::set_names(c("value","n"))
    },.id="var")
  }