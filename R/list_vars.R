#' List Variable Names
#' @param df Dataframe with test data
#' @param ... Names of variables to be inserted into dplyr::select()
#' @return Named vector of variables
#' @description Creates a vector of variable names from a dataframe or tibble
#' @export

list_vars <-
  function(df, ...) {
    vars <- rlang::quos(...)
    df %>%
      dplyr::select(!!!vars) %>%
      names() %>%
      purrr::set_names()
  }