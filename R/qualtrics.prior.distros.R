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
        httr::add_headers(header.all)
      ) %>%
      httr::content()
    
    distributions.list <-
      distributions.response$result$elements %>%
      purrr::map( ~ .$recipients$mailingListId) %>%
      unlist() 
    
    if(is.null(distributions.list)){
      return()
    }
    distributions.list <-
      distributions.list %>%
      purrr::map( ~ httr::GET(
        url = paste0(
          "https://az1.qualtrics.com/API/v3/mailinglists/",
          .,
          "/contacts"
        ),
        httr::add_headers(header.all)
      ))  %>%
      purrr::map( ~ httr::content(.)) %>%
      purrr::map( ~ .$result$elements)
    
    distributions.df <-
      purrr::map_df(1:length(distributions.list), function(x) {
        purrr::map_df(
          1:length(distributions.list[[x]]),
          purrr::possibly(
            function(y) {
              distributions.list[[x]][[y]] %>%
                unlist %>%
                t() %>%
                as.data.frame() %>%
                tibble::repair_names() %>%
                dplyr::mutate_all(as.character)
            },
            otherwise = dplyr::tibble(
              id = NA_character_,
              firstName = NA_character_,
              lastName = NA_character_,
              email = NA_character_,
              embeddedData.Position = NA_character_,
              embeddedData.Candidate.ID = NA_character_,
              embeddedData.City = NA_character_,
              embeddedData.Cand.Profile.ID = NA_character_,
              embeddedData.System.Req.ID = NA_character_,
              unsubscribed = NA_character_,
              emailHistory.emailDistributionId = NA_character_,
              emailHistory.date = NA_character_,
              emailHistory.type = NA_character_,
              emailHistory.result = NA_character_,
              emailHistory.read = NA_character_,
              emailHistory.surveyId = NA_character_,
              `embeddedData.Candidate ID` = NA_character_,
              `embeddedData.Cand Profile ID` = NA_character_
            )
          )
        )
      }
      )
    distributions.df
  }
