#' Remove duplicates based on two columns, ignoring their order
#' @param df Dataframe
#' @param col1 Quoted name of first column
#' @param col2 Quoted name of second column
#' @return Dataframe with duplicates removed
#' @export
#' @examples
#' df <- tibble::tibble(
#'   a = c("A", "B", "C"),
#'   b = c("B", "A", "D")
#' )
#' distinct_2col(df, "a", "b")
distinct_2col <- function(df, col1, col2) {
  col1q <- rlang::enquo(col1)
  col2q <- rlang::enquo(col2)
  df |>
    dplyr::mutate(
      dupevec = purrr::map2(
        !!col1q,
        !!col2q,
        \(x, y) {
          sort(as.character(c(
            x,
            y
          )))
        }
      )
    ) |>
    dplyr::distinct(.data$dupevec, .keep_all = TRUE) |>
    dplyr::select(-"dupevec")
}
