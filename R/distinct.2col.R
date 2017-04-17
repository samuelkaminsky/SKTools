#' Remove duplicates based on two columns, ignoring their order
#' @param df Dataframe
#' @param col1 Quoted name of first column
#' @param col2 Quoted name of second column
#' @return Dataframe with duplicates removed
#' @export

distinct.2col <- function(df, col1, col2)
  
  df %>%
  dplyr::mutate(dupevec = purrr::map(1:nrow(.), function(x) {
    c(.[x, col1] %>% unlist, .[x, col2] %>% unlist) %>% purrr::set_names(c("", "")) %>% sort
  }),
  dupevec = as.character(.$dupevec)) %>%
  dplyr::distinct(.$dupevec, .keep_all = TRUE) %>%
  dplyr::select(-.$dupevec)