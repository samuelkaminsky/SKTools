#' Get prior distributions for a survey
#' @param surveyId Qualtrics Survey ID
#' @param header.all Header
#' @return Data frame of distribution data
#' @description Retrieves distributions for a survey on Qualtrics
#' @export

qualtrics.prior.distros <-
  function(surveyId, header.all) {
    distributions.response <-
      httr::GET(
        url = paste0(
          "https://az1.qualtrics.com/API/v3/distributions?surveyId=",
          surveyId
        ),
        add_headers(header.all)
      ) %>%
      content()
    
    distributions.list <-
      distributions.response$result$elements %>%
      purrr::map( ~ .$recipients$mailingListId) %>%
      unlist() %>%
      purrr::map( ~ GET(
        url = paste0(
          "https://az1.qualtrics.com/API/v3/mailinglists/",
          .,
          "/contacts"
        ),
        add_headers(header.all)
      )) %>%
      purrr::map( ~ content(.)) %>%
      purrr::map( ~ .$result$elements)
    
    distributions.df <-
      purrr::map_df(1:length(distributions.list), function(x) {
        purrr::map_df(1:length(distributions.list[[x]]), function(y) {
          distributions.list[[x]][[y]] %>%
            unlist %>%
            t() %>%
            as.data.frame() %>%
            tibble::repair_names() %>% 
            dplyr::mutate_all(as.character)
        })
      })
    return(distributions.df)
  }
