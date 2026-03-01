#' Get prior distributions for a survey
#' @param survey_id Qualtrics Survey ID
#' @param api_token Qualtrics api token. Consider using `Sys.getenv()` to keep
#'   this secure.
#' @param datacenter Qualtrics data center (default "az1")
#' @param max_iterations Maximum number of pages to fetch per mailing list
#'   (default 100) to prevent infinite loops.
#' @return Data frame of distribution data
#' @description Retrieves distributions for a survey on Qualtrics
#' @export
#' @examples
#' \dontrun{
#' qualtrics_prior_distros("SV_12345", Sys.getenv("QUALTRICS_KEY"))
#' }
qualtrics_prior_distros <-
  function(survey_id, api_token, datacenter = "az1", max_iterations = 100) {
    if (!grepl("^[a-zA-Z0-9]+$", datacenter)) {
      rlang::abort("Invalid datacenter format. Alphanumeric characters only.")
    }

    header_all <-
      c(
        "X-API-TOKEN" = api_token,
        "Content-Type" = "application/json",
        "Accept" = "*/*",
        "accept-encoding" = "gzip, deflate"
      )

    base_url <- paste0("https://", datacenter, ".qualtrics.com/API/v3")

    # Initial Request to get distributions
    distributions_response <-
      httr::GET(
        url = paste0(base_url, "/distributions"),
        query = list(surveyId = survey_id),
        httr::add_headers(header_all)
      ) |>
      httr::content()

    # Get mailing list IDs and initial contacts
    distributions_list <-
      distributions_response$result$elements |>
      purrr::map(\(x) x$recipients$mailingListId) |>
      unlist() |>
      purrr::set_names() |>
      purrr::map(
        \(x) {
          httr::GET(
            url = paste0(
              base_url,
              "/mailinglists/",
              utils::URLencode(x, reserved = TRUE),
              "/contacts"
            ),
            httr::add_headers(header_all)
          )
        }
      ) |>
      purrr::map(httr::content)

    results <-
      distributions_list |>
      purrr::map(\(x) x$result$elements)

    # Pagination Loop: Keep fetching while 'nextPage' exists
    iteration <- 0
    while ({
      length(
        distributions_list |>
          purrr::map(\(x) x$result$nextPage) |>
          purrr::compact()
      ) >
        0
    }) {
      iteration <- iteration + 1
      if (iteration > max_iterations) {
        warning("Max iterations reached in pagination loop. Stopping fetch.")
        break
      }

      distributions_list <-
        distributions_list |>
        purrr::map(\(x) x$result$nextPage) |>
        purrr::compact() |>
        purrr::map(
          \(x) {
            httr::GET(
              x,
              httr::add_headers(header_all)
            )
          }
        ) |>
        purrr::map(httr::content)

      new_results <-
        distributions_list |>
        purrr::map(\(x) x$result$elements)

      results <- c(results, new_results)
    }

    # Parse results into a single dataframe
    distributions_df <-
      results |>
      purrr::flatten() |>
      purrr::map(
        purrr::possibly(
          \(x) {
            x |>
              unlist() |>
              t() |>
              tibble::as_tibble(.name_repair = "minimal") |>
              dplyr::mutate(dplyr::across(dplyr::everything(), as.character))
          },
          otherwise = tibble::tibble(
            id = NA_character_,
            firstName = NA_character_,
            lastName = NA_character_,
            email = NA_character_
          )
        )
      ) |>
      purrr::list_rbind()

    distributions_df
  }
