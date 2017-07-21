#' Get prior distributions for a survey
#' @param surveyId Qualtrics Survey ID
#' @param header.all Header
#' @return Data frame of distribution data
#' @description Retrieves distributions for a survey on Qualtrics
#' @export

qualtrics_prior_distros <-
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
      unlist() %>%
      purrr::set_names() %>%
      purrr::map( ~ httr::GET(
        url = paste0(
          "https://az1.qualtrics.com/API/v3/mailinglists/",
          .,
          "/contacts"
        ),
        httr::add_headers(header.all)
      )) %>%
      purrr::map( ~ httr::content(.))

    results.1 <-
      distributions.list %>%
      purrr::map(~ .$result$elements)
    
    
    distributions.list.level2 <-
      distributions.list %>%
      purrr::map(~ .$result$nextPage) %>%
      purrr::compact() %>%
      purrr::map( ~ httr::GET(.,
                              httr::add_headers(header.all))) %>%
      purrr::map( ~ httr::content(.))
    
    results.2 <-
      distributions.list.level2 %>%
      purrr::map(~ .$result$elements)
    
    distributions.list.level3 <-
      distributions.list.level2 %>%
      purrr::map( ~ .$result$nextPage) %>%
      purrr::compact() %>%
      purrr::map(~ httr::GET(.,
                             httr::add_headers(header.all))) %>%
      purrr::map(~ httr::content(.))
    
    results.3 <-
      distributions.list.level3 %>%
      purrr::map(~ .$result$elements)
    
    distributions.list.level4 <-
      distributions.list.level3 %>%
      purrr::map( ~ .$result$nextPage) %>%
      purrr::compact() %>%
      purrr::map(~ httr::GET(.,
                             httr::add_headers(header.all))) %>%
      purrr::map(~ httr::content(.))
    
    results.4 <-
      distributions.list.level4 %>%
      purrr::map(~ .$result$elements)
    
    distributions.list.level5 <-
      distributions.list.level4 %>%
      purrr::map( ~ .$result$nextPage) %>%
      purrr::compact() %>%
      purrr::map(~ httr::GET(.,
                             httr::add_headers(header.all))) %>%
      purrr::map(~ httr::content(.))
    
    results.5 <-
      distributions.list.level5 %>%
      purrr::map(~ .$result$elements)
    
    distributions.list.level6 <-
      distributions.list.level5 %>%
      purrr::map( ~ .$result$nextPage) %>%
      purrr::compact() %>%
      purrr::map(~ httr::GET(.,
                             httr::add_headers(header.all))) %>%
      purrr::map(~ httr::content(.))
    
    results.6 <-
      distributions.list.level6 %>%
      purrr::map(~ .$result$elements)
    
    all.distributions <-
      c(results.1,
        results.2,
        results.3,
        results.4,
        results.5,
        results.6)
    
    distributions.df <-
      purrr::map_df(1:length(all.distributions), function(x) {
        purrr::map_df(
          1:length(all.distributions[[x]]),
          purrr::possibly(
            function(y) {
              all.distributions[[x]][[y]] %>%
                unlist %>%
                t() %>%
                as.data.frame() %>%
                tibble::repair_names() %>%
                lapply(as.character)
            },
            otherwise = dplyr::tibble(
              id = NA_character_,
              firstName = NA_character_,
              lastName = NA_character_,
              email = NA_character_,
              embeddedData.Req.Position.Title = NA_character_,
              embeddedData.Candidate.ID = NA_character_,
              embeddedData.Location.Code = NA_character_,
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
      })
    distributions.df
  }
