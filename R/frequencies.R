#' Dataframe Frequencies
#' @param df Dataframe with data
#' @param perc Logical indicating whether or not to calculate percentages for each value by variable
#' @return Dataframe of frequencies for each variable and value
#' @description Calculates frequencies of every Column in a dataframe
#' @export

frequencies <-
  function(df, perc = FALSE) {
    result <- 
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
    
    if (perc == TRUE) {
      result <- 
        result %>% 
        dplyr::group_by(.data$var) %>%
        dplyr::mutate(perc = .data$n/sum(.data$n, na.rm = TRUE)) %>% 
        dplyr::ungroup()
    }
    result
  }