#' Remove duplicates based on two columns, ignoring their order
#' @param df Dataframe
#' @param col1 Column name (quoted or unquoted)
#' @param col2 Column name (quoted or unquoted)
#' @return Data frame with duplicates removed
#' @importFrom rlang .data
#' @export
#' @examples
#' df <- tibble::tibble(
#'   a = c("A", "B", "C"),
#'   b = c("B", "A", "D")
#' )
#' distinct_2col(df, a, b)
distinct_2col <- function(df, col1, col2) {
  col1_quo <- rlang::enquo(col1)
  col2_quo <- rlang::enquo(col2)

  # Extract column names if they were passed as strings
  if (rlang::quo_is_symbolic(col1_quo) || rlang::quo_is_symbol(col1_quo)) {
    c1_vals <- df |> dplyr::pull(!!col1_quo)
    c2_vals <- df |> dplyr::pull(!!col2_quo)
  } else {
    c1_vals <- df[[rlang::eval_tidy(col1_quo)]]
    c2_vals <- df[[rlang::eval_tidy(col2_quo)]]
  }

  # Vectorized approach to order-insensitive distinct
  df |>
    dplyr::mutate(
      .tmp_min = pmin(as.character(c1_vals), as.character(c2_vals)),
      .tmp_max = pmax(as.character(c1_vals), as.character(c2_vals))
    ) |>
    dplyr::distinct(.data$.tmp_min, .data$.tmp_max, .keep_all = TRUE) |>
    dplyr::select(-".tmp_min", -".tmp_max")
}
