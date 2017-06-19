#' Clean corr.test output
#' @param corr_test_results corr.test object
#' @param alpha Alpha level to test significance
#' @return Dataframe with clean output
#' @export
#' @description Converts corr.test output to tidy dataframe with most important information (IV, DV, r, n, t, p)

corr_summary <-
  function(corr_test_results, alpha = .05) {
    if (length(corr_test_results[[2]]) == 1) {
      corr_test_results[2] <-
        list(
          n = rep(
            x = corr_test_results[[2]],
            corr_test_results[[1]] %>%
              as.data.frame() %>%
              tidyr::gather() %>%
              nrow()
          )
        )
    }
    cor.df <-
      corr_test_results[1:4] %>%
      purrr::map(~ as.data.frame(.)) %>%
      purrr::map(~ tibble::rownames_to_column(.)) %>%
      purrr::map(~ tidyr::gather(., rowname)) %>%
      dplyr::bind_cols() %>%
      dplyr::select(
        IV = .data$rowname,
        DV = .data$rowname1,
        r = .data$value,
        n = .data$value1,
        t = .data$value2,
        p = .data$value3
      ) %>%
      dplyr::mutate(Sig = dplyr::if_else(.data$p < alpha, TRUE, FALSE)) %>%
      dplyr::filter(!(.data$IV == .data$DV & .data$r == 1))
    return(cor.df)
  }