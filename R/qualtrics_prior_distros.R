#' Get prior distributions for a survey
#' @param surveyId Qualtrics Survey ID
#' @param api_token Qualtrics api token
#' @param datacenter Qualtrics data center (default "az1")
#' @return Data frame of distribution data
#' @description Retrieves distributions for a survey on Qualtrics
#' @export

qualtrics_prior_distros <-
  function(surveyId, api_token, datacenter = "az1") {
    header.all <-
      c(
        "X-API-TOKEN" = api_token,
        "Content-Type" = "application/json",
        "Accept" = "*/*",
        "accept-encoding" = "gzip, deflate"
      )

    base_url <- paste0("https://", datacenter, ".qualtrics.com/API/v3")

    distributions.response <-
      httr::GET(
        url = paste0(
          base_url,
          "/distributions?surveyId=",
          surveyId
        ),
        httr::add_headers(header.all)
      ) |>
      httr::content()

    distributions.list <-
      distributions.response$result$elements |>
      purrr::map(\(x) x$recipients$mailingListId) |>
      unlist() |>
      purrr::set_names() |>
      purrr::map(
        \(x) httr::GET(
          url = paste0(
            base_url,
            "/mailinglists/",
            x,
            "/contacts"
          ),
          httr::add_headers(header.all)
        )
      ) |>
      purrr::map(\(x) httr::content(x))

    results <-
      distributions.list |>
      purrr::map(\(x) x$result$elements)

    while (
      {
        length(
          distributions.list |>
            purrr::map(\(x) x$result$nextPage) |>
            purrr::compact()
        ) >
          0
      }
    ) {
      distributions.list <-
        distributions.list |>
        purrr::map(\(x) x$result$nextPage) |>
        purrr::compact() |>
        purrr::map(
          \(x) httr::GET(
            x,
            httr::add_headers(header.all)
          )
        ) |>
        purrr::map(\(x) httr::content(x))
      
      new_results <-
        distributions.list |>
        purrr::map(\(x) x$result$elements)
      
      results <- c(results, new_results)
    }

    distributions.df <-
      purrr::map_df(seq_along(results), \(x) {
        purrr::map_df(
          seq_along(results[[x]]),
          purrr::possibly(
            \(y) {
              results[[x]][[y]] |>
                unlist() |>
                t() |>
                as.data.frame() |>
                tibble::repair_names() |>
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
