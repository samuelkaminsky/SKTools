#' Clean corr.test output
#' @param corr_test_results corr.test object
#' @param alpha Alpha level to test significance
#' @return tibble with clean output
#' @importFrom rlang .data
#' @importFrom dplyr across
#' @description Converts corr.test output to tidy tibble with most important
#'   information (IV, DV, r, n, t, p)
#' @export
#' @examples
#' if (requireNamespace("psych", quietly = TRUE)) {
#'   ct <- psych::corr.test(mtcars[1:5])
#'   corr_summary(ct)
#' }
corr_summary <-
  function(corr_test_results, alpha = .05) {
    if (length(corr_test_results$n) == 1L) {
      corr_test_results$n <-
        matrix(
          data = corr_test_results$n,
          nrow(corr_test_results$r),
          nrow(corr_test_results$r),
          dimnames = list(
            rownames(corr_test_results$r),
            colnames(corr_test_results$r)
          )
        )
    }
    corr_test_results_sub <- corr_test_results[c("r", "n", "t", "p", "p")]
    corr_test_results_sub_named <-
      purrr::set_names(
        corr_test_results_sub,
        c("r", "n", "t", "p", "p.adjust")
      )
    cor_df <-
      corr_test_results_sub_named |>
      # Replace bottom (unadjusted p values with NA)
      purrr::map_at("p.adjust", \(x) {
        x[lower.tri(x)] <- NA_real_
        x
      }) |>
      # Replace top (adjusted p values with NA)
      purrr::map_at("p", \(x) {
        x[upper.tri(x)] <- NA_real_
        x
      }) |>
      # Convert to tibble and create column with rownames
      purrr::map(\(x) tibble::as_tibble(x, rownames = "iv")) |>
      # Convert to long format
      purrr::imap(
        \(x, y) {
          tidyr::pivot_longer(
            x,
            cols = -"iv",
            names_to = "dv",
            values_to = y,
            # Removes rows with no p values
            values_drop_na = TRUE
          )
        }
      ) |>
      purrr::map(\(x) dplyr::filter(x, !(.data$iv == .data$dv))) |>
      # For p value table, stack to create rows with dv/iv pairs
      purrr::map_at(c("p", "p.adjust"), \(x) {
        x_rev <-
          dplyr::rename(x, dv = "iv", iv = "dv")
        dplyr::bind_rows(x, x_rev)
      }) |>
      purrr::reduce(dplyr::left_join, by = c("iv", "dv")) |>
      # Calculate significance
      dplyr::mutate(across(c("p", "p.adjust"), list(sig = \(x) x < alpha)))
    cor_df
  }
