#' Dataframe Descriptives and Frequencies
#' @param df Dataframe with data
#' @return Dataframe of descriptives and frequencies for each variable and value
#' @description Calculates descriptives and frequencies of every Column in a dataframe. Heavily inspired by Ujjwal Karn's XDA package.
#' @export

df_check <-
  function(df) {
    freqs <-
      purrr::map_df(purrr::set_names(names(df)), function(x) {
        df %>%
          dplyr::count_(x) %>%
          purrr::set_names(c("value", "n")) %>%
          dplyr::mutate(value = as.character(.data$value))
      }, .id = "var") %>%
      dplyr::group_by(.data$var) %>%
      tidyr::nest(.key = "frequencies") %>%
      dplyr::mutate(frequencies = .data$frequencies %>% purrr::set_names(.data$var)) %>%
      dplyr::arrange(.data$var)
    
    missing <-
      df %>%
      dplyr::mutate_all(dplyr::funs(as.character)) %>%
      tidyr::gather() %>%
      dplyr::group_by(.data$key) %>%
      dplyr::summarize(n_missing = sum(is.na(.data$value)),
                       perc_missing = .data$n_missing / n())
    
    class <-
      df %>%
      purrr::map(class) %>% 
      purrr::map_df(stringr::str_c,collapse = ", ") %>% 
      tidyr::gather() %>%
      dplyr::rename(class = .data$value)
    
    df %>%
      dplyr::select_if(is.numeric) %>%
      tidyr::gather() %>%
      dplyr::group_by(.data$key) %>%
      dplyr::summarize(
        mean = mean(.data$value, na.rm = TRUE),
        median = stats::median(.data$value, na.rm = TRUE),
        max = max(.data$value, na.rm = TRUE),
        min = min(.data$value, na.rm = TRUE),
        sd = stats::sd(.data$value, na.rm = TRUE),
        range = .data$max - .data$min,
        iqr = stats::IQR(.data$value, na.rm = TRUE),
        skewness = moments::skewness(.data$value, na.rm = TRUE),
        kurtosis = moments::kurtosis(.data$value, na.rm = TRUE),
        `1%` = stats::quantile(.data$value, .01, na.rm = TRUE),
        `25%` = stats::quantile(.data$value, .25, na.rm = TRUE),
        `50%` = stats::quantile(.data$value, .5, na.rm = TRUE),
        `75%` = stats::quantile(.data$value, .75, na.rm = TRUE),
        `99%` = stats::quantile(.data$value, .99, na.rm = TRUE)
      ) %>%
      dplyr::full_join(missing, by = "key", na_matches = "never") %>%
      dplyr::full_join(class, by = "key", na_matches = "never") %>%
      dplyr::full_join(freqs, by = c("key" = "var"), na_matches = "never") %>%
      dplyr::mutate(frequencies = .data$frequencies %>% purrr::set_names(.data$key)) %>%
      dplyr::select(var = .data$key, .data$class, dplyr::everything())
  }