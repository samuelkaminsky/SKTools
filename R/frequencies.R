#' Dataframe Frequencies
#' @param df Dataframe with data
#' @param perc Logical indicating whether or not to calculate percentages
#' and valid percentages for each value by variable
#' @return Dataframe of frequencies for each variable and value
#' @importFrom rlang .data
#' @description Calculates frequencies of every Column in a dataframe
#' @export
#' @examples
#' frequencies(mtcars)
frequencies <-
  function(df, perc = FALSE) {
    if (dplyr::is_grouped_df(df)) {
      return(
        df |>
          dplyr::group_modify(
            \(x, ...) frequencies(x, perc = perc)
          ) |>
          dplyr::ungroup()
      )
    }

    if (nrow(df) == 0) {
      return(tibble::tibble(
        var = character(),
        value = character(),
        n = integer()
      ))
    }

    result <-
      df |>
      names() |>
      purrr::set_names() |>
      purrr::map(
        \(x) {
          x <- as.name(x)
          df |>
            dplyr::count(!!x) |>
            purrr::set_names(c("value", "n")) |>
            dplyr::mutate(value = as.character(.data$value))
        }
      ) |>
      purrr::list_rbind(names_to = "var")

    if (isTRUE(perc)) {
      result <-
        result |>
        dplyr::group_by(.data$var) |>
        dplyr::mutate(
          total_n = sum(.data$n),
          valid_n = sum(.data$n[!is.na(.data$value)]),
          perc = .data$n / .data$total_n,
          valid.perc = dplyr::if_else(
            is.na(.data$value),
            NA_real_,
            .data$n / .data$valid_n
          )
        ) |>
        dplyr::ungroup() |>
        dplyr::select(-"total_n", -"valid_n")
    }
    result
  }