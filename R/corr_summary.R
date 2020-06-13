#' Clean corr.test output
#' @param corr_test_results corr.test object
#' @param alpha Alpha level to test significance
#' @return tibble with clean output
#' @export
#' @description Converts corr.test output to tidy tibble with most important information (IV, DV, r, n, t, p)

corr_summary <-
  function(corr_test_results, alpha = .05) {
    if (length(corr_test_results$n) == 1) {
      corr_test_results$n <- matrix(
        data = corr_test_results$n,
        nrow(corr_test_results$r),
        nrow(corr_test_results$r),
        dimnames = list(
          rownames(corr_test_results$r),
          colnames(corr_test_results$r)
        )
      )
    }
    cor.df <-
      corr_test_results[1:4] %>%
      purrr::map( ~ as.data.frame(.)) %>%
      purrr::map( ~ tibble::rownames_to_column(., var = "iv")) %>%
      purrr::map( ~ tidyr::gather(., dv, value,-iv)) %>%
      purrr::reduce(dplyr::left_join, by = c("iv", "dv")) %>%
      dplyr::select(
        .data$iv,
        .data$dv,
        r = .data$value.x,
        n = .data$value.y,
        t = .data$value.x.x,
        p = .data$value.y.y
      ) %>%
      dplyr::mutate(Sig = .data$p < alpha) %>%
      dplyr::filter(!(.data$iv == .data$dv & .data$r == 1))
    return(cor.df)
  }
