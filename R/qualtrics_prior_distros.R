#' Get prior distributions for a survey
#' @param surveyId Qualtrics Survey ID
#' @param api_token Qualtrics api token
#' @return Data frame of distribution data
#' @description Retrieves distributions for a survey on Qualtrics
#' @export

qualtrics_prior_distros <-
  function(surveyId, api_token) {
    header.all <-
      c(
        "X-API-TOKEN" = api_token,
        "Content-Type" = "application/json",
        "Accept" = "*/*",
        "accept-encoding" = "gzip, deflate"
      )

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
      purrr::map(~ .$recipients$mailingListId) %>%
      unlist() %>%
      purrr::set_names() %>%
      purrr::map(
        ~ httr::GET(
          url = paste0(
            "https://az1.qualtrics.com/API/v3/mailinglists/",
            .,
            "/contacts"
          ),
          httr::add_headers(header.all)
        )
      ) %>%
      purrr::map(~ httr::content(.))

    results <-
      distributions.list %>%
      purrr::map(~ .$result$elements)

    while (
      {
        length(
          distributions.list %>%
            purrr::map(~ .$result$nextPage) %>%
            purrr::compact()
        ) >
          0
      }
    ) {
      distributions.list <-
        distributions.list %>%
        purrr::map(~ .$result$nextPage) %>%
        purrr::compact() %>%
        purrr::map(
          ~ httr::GET(
            .,
            httr::add_headers(header.all)
          )
        ) %>%
        purrr::map(~ httr::content(.))
      results <-
        distributions.list %>%
        purrr::map(~ .$result$elements) %>%
        c(results, .)
    }

    distributions.df <-
      purrr::map_df(seq_along(results), function(x) {
        purrr::map_df(
          seq_along(results[[x]]),
          purrr::possibly(
            function(y) {
              results[[x]][[y]] %>%
                unlist() %>%
                t() %>%
                as.data.frame() %>%
                tibble::repair_names() %>%
                lapply(as.character)
            },
            otherwise = dplyr::tibble(
              id = NA_character_,
              firstName = NA_character_,
              lastName = NA_character_,
              email = NA_character_
            )
          )
        )
      })
    distributions.df
  }
