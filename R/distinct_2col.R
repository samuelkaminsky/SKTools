#' Remove duplicates based on two columns, ignoring their order
#' @param df Dataframe
#' @param col1 Quoted name of first column
#' @param col2 Quoted name of second column
#' @return Dataframe with duplicates removed
#' @export

distinct_2col <- function(df, col1, col2) {
  df %>%
    dplyr::mutate(
      dupevec = purrr::map(1:nrow(.), function(x) {
        c(.[x, col1] %>% unlist(), .[x, col2] %>% unlist()) %>%
          purrr::set_names(c("", "")) %>%
          sort()
      }),
      dupevec = as.character(.data$dupevec)
    ) %>%
    dplyr::distinct(.data$dupevec, .keep_all = TRUE) %>%
    dplyr::select(-.data$dupevec)
}
