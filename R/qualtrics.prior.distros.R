#' Get prior distributions for a survey
#' @param surveyId Qualtrics Survey ID
#' @param header.all Header
#' @return Data frame of distribution data
#' @import httr
#' @importFrom dplyr %>% select mutate distinct left_join
#' @importFrom purrr map map_df
#' @description Retrieves distributions for a survey on Qualtrics
#' @export

qualtrics.prior.distros <-
  function(surveyId, header.all) {
    distributions.response <-
      GET(
        url = paste0(
          "https://az1.qualtrics.com/API/v3/distributions?surveyId=",
          surveyId
        ),
        add_headers(header.all)
      ) %>%
      content()
    
    distributions.list <-
      distributions.response$result$elements %>%
      map(~ .$recipients$mailingListId) %>%
      unlist() %>%
      map(~ GET(
        url = paste0(
          "https://az1.qualtrics.com/API/v3/mailinglists/",
          .,
          "/contacts"
        ),
        add_headers(header.all)
      )) %>%
      map(~ content(.)) %>%
      map(~ .$result$elements)
    
    distributions.df <-
      map_df(1:length(distributions.list), function(x) {
        map_df(1:length(distributions.list[[x]]), function(y) {
          distributions.list[[x]][[y]] %>%
            unlist %>%
            t %>%
            as.data.frame() %>%
            dplyr::mutate_all(as.character)
        })
      })
    return(distributions.df)
  }
