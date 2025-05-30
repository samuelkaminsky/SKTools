#' Conducts One-Way ANOVAs on Multiple DVs
#' @param df Dataframe with test data
#' @param iv Name of independent variable
#' @param dvs Names of dependent variables to be inserted into dplyr::select()
#' @param print Logical indicating whether or not ns and proportions of iv are printed
#' @return Data frame of tidy ANOVA post-hoc results, also prints Ns and percentages in each level of the IV
#' @description Conduct one-way ANOVAs on multiple DVs
#' @export

anova_multi <-
  function(df, iv, dvs, print = FALSE) {
    iv <- dplyr::enquo(iv)
    dvs <- dplyr::enquo(dvs)
    df <-
      df %>%
      dplyr::mutate(iv = as.factor(!!iv)) %>%
      tidyr::drop_na(iv)
    dvs.list <-
      df %>%
      dplyr::select(!!dvs) %>%
      names() %>%
      as.list() %>%
      purrr::set_names()
    results.anova <-
      dvs.list %>%
      purrr::map(
        ~ aov(lm(as.formula(
          paste0("df$`", ., "` ~ df$iv")
        )))
      ) %>%
      purrr::map_df(broom::tidy, .id = "DV") %>%
      dplyr::filter(.data$term != "Residuals") %>%
      dplyr::select(-.data$term)
    results.posthocs <-
      dvs.list %>%
      purrr::map(
        ~ aov(lm(as.formula(
          paste0("df$`", ., "` ~ df$iv")
        )))
      ) %>%
      purrr::map(stats::TukeyHSD) %>%
      purrr::map(~ .[1]) %>%
      purrr::map(as.data.frame) %>%
      purrr::map_df(tibble::rownames_to_column, .id = "DV") %>%
      tidyr::spread(.data$rowname, .data$df.iv.p.adj) %>%
      dplyr::select(-(dplyr::starts_with("df.iv"))) %>%
      dplyr::group_by(.data$DV) %>%
      dplyr::summarise_all(list(~ mean(., na.rm = TRUE)))
    results <-
      results.anova %>%
      dplyr::left_join(results.posthocs, by = "DV", na_matches = "never")
    means <-
      df %>%
      dplyr::group_by(iv) %>%
      dplyr::summarise_at(
        dplyr::vars(!!dvs),
        list(~ mean(., na.rm = TRUE))
      )
    means.t <-
      means[, -1] %>%
      t() %>%
      as.data.frame() %>%
      purrr::set_names(
        means[, 1] %>%
          unlist()
      ) %>%
      tibble::rownames_to_column(var = "DV")
    df.summary <-
      cbind(means.t, p.value = results[, 7:ncol(results)]) %>%
      as.data.frame() %>%
      dplyr::mutate_if(is.numeric, list(~ round(., 4)))
    if (isTRUE(print)) {
      details <- list(
        # IV = iv,
        # SJT.Items = df %>% select(contains("AOSJT")) %>% names,
        Ns = table(df$iv),
        Props = prop.table(table(df$iv)) %>% round(3)
      )
      print(details)
    }
    return(df.summary)
  }
