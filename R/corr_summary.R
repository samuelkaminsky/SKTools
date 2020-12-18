#' Clean corr.test output
#' @param corr_test_results corr.test object
#' @param alpha Alpha level to test significance
#' @return tibble with clean output
#' @export
#' @description Converts corr.test output to tidy tibble with most important information (IV, DV, r, n, t, p)

CorrSummary <-
  function(corr.test.results, alpha = .05) {
    if (length(corr.test.results$n) == 1L) {
      corr.test.results$n <-
        matrix(
          data = corr.test.results$n,
          nrow(corr.test.results$r),
          nrow(corr.test.results$r),
          dimnames = list(
            rownames(corr.test.results$r),
            colnames(corr.test.results$r)
          )
        )
    }
    corr.test.results.sub <- corr.test.results[c("r", "n", "t", "p", "p")]
    corr.test.results.sub.named <-
      purrr::set_names(corr.test.results.sub,
                       c("r", "n", "t", "p", "p.adjust"))
    cor.df <-
      corr.test.results.sub.named %>%
      # Replace bottom (unadjusted p values with NA)
      purrr::map_at("p.adjust", function(x) {
        x[lower.tri(x)] <- NA_real_
        x
      }) %>%
      # Replace top (adjusted p values with NA)
      purrr::map_at("p", function(x) {
        x[upper.tri(x)] <- NA_real_
        x
      }) %>%
      # Convert to tibble and create column with rownames
      purrr::map( ~ tibble::as_tibble(., rownames = "iv")) %>%
      # Convert to long format
      purrr::imap(
        ~ tidyr::pivot_longer(
          .x,
          cols = -.data$iv,
          names_to = "dv",
          values_to = .y,
          # Removes rows with no p values
          values_drop_na = TRUE
        )
      ) %>%
      # For p value table, stack to create rows with dv/iv pairs
      purrr::map_at(c("p", "p.adjust"), function(x) {
        x.rev <-
          dplyr::rename(x, dv = iv, iv = dv)
        dplyr::bind_rows(x, x.rev)
      }) %>%
      purrr::reduce(dplyr::left_join, by = c("iv", "dv")) %>%
      # Calculate significance
      dplyr::mutate_at(dplyr::vars(p, p.adjust), list(sig = ~ . < alpha)) %>%
      # Remove rows where dv is matched with iv
      dplyr::filter(!(.data$iv == .data$dv & .data$r == 1))
    return(cor.df)
  }
