#' Converts qualtRics JSON output to dataframe with formatted column names
#'
#' @param x object output from qualtRics::getSurvey() with json format
#' @return dataframe
#' @export

qualtRics.json.df <-
  function(x) {
    x %>%
      jsonlite::toJSON() %>%
      jsonlite::fromJSON() %>%
      unlist(recursive = FALSE) %>%
      dplyr::as_tibble() %>%
      purrr::set_names(stringr::str_replace(names(.), "responses.", ""))
  }
