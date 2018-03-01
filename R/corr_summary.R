#' Clean corr.test output
#' @param corr_test_results corr.test object
#' @param alpha Alpha level to test significance
#' @return Dataframe with clean output
#' @export
#' @description Converts corr.test output to tidy dataframe with most important information (IV, DV, r, n, t, p)

corr_summary <-
  function(corr_test_results, alpha = .05) {
    if (length(corr_test_results[[2]]) == 1) {
      # corr_test_results[2] <-
      #   list(
      #     n = rep(
      #       x = corr_test_results[[2]],
      #       corr_test_results[[1]] %>%
      #         as.data.frame() %>%
      #         tidyr::gather() %>%
      #         nrow()
      #     )
      #   )
      corr_test_results[[2]] <- matrix(data= corr_test_results[[2]], corr_test_results[[1]] %>% nrow(), corr_test_results[[1]] %>% nrow(), 
                                       dimnames = list(rownames(corr_test_results[[1]]), colnames(corr_test_results[[1]])))
    }
    cor.df <-
      corr_test_results[1:4] %>%
      purrr::map(~ as.data.frame(.)) %>%
      purrr::map(~ tibble::rownames_to_column(., var = "iv")) %>%
      purrr::map(~ tidyr::gather(., dv, value, -iv)) %>%
      purrr::reduce(dplyr::left_join, by = c("iv", "dv")) %>%
      dplyr::select(
        .data$iv,
        .data$dv,
        r = .data$value.x,
        n = .data$value.y,
        t = .data$value.x.x,
        p = .data$value.y.y
      ) %>%
      dplyr::mutate(Sig = dplyr::if_else(.data$p < alpha, TRUE, FALSE)) %>%
      dplyr::filter(!(.data$iv == .data$dv & .data$r == 1))
    return(cor.df)
  }