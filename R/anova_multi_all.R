#' Conducts One-Way ANOVAs on Multiple DVs at Multiple Cut Points
#' @param df Dataframe with test data
#' @param ivs Names of independent variables to be inserted into dplyr::select()
#' @param dvs Names of dependent variables to be inserted into dplyr::select()
#' @param perc Nth percentile to conduct ANOVA at
#' @param print TRUE to print progress as it goes
#' @return Data frame of tidy ANOVA F test and post-hoc results, also includes descriptives about each level of the IV
#' @description Conduct one-way ANOVAs on multiple DVs at various cutpoints of the iv
#' @export

anova_multi_all <-
  function(df,
           ivs,
           dvs,
           perc = .05,
           print = FALSE) {
    dvs <- dplyr::enquo(dvs)
    ivs <- dplyr::enquo(ivs)
    IVs <-
      df %>%
      dplyr::select(!!ivs) %>%
      names() %>%
      purrr::set_names()
    DVs <-
      df %>%
      dplyr::select(!!dvs) %>%
      names() %>%
      purrr::set_names()
    cuts <-
      IVs %>%
      purrr::map(~ dplyr::pull(df, .)) %>%
      purrr::map(~ stats::quantile(., seq(
        from = 0.05,
        to = .95,
        by = perc
      ), na.rm = TRUE)) %>%
      as.data.frame() %>%
      tibble::rownames_to_column("percentage") %>%
      tidyr::gather("iv", "cut", -.data$percentage) %>%
      dplyr::distinct(.data$iv, .data$cut, .keep_all = TRUE)
    iv.dv <-
      tidyr::crossing(dv = DVs, iv = IVs) %>%
      dplyr::mutate_all(as.character)
    index <-
      cuts %>%
      dplyr::left_join(cuts, by = "iv", suffix = c(".bottom", ".top")) %>%
      dplyr::distinct() %>%
      dplyr::filter(.data$cut.top >= .data$cut.bottom) %>%
      dplyr::left_join(iv.dv, by = "iv") %>%
      dplyr::distinct() %>%
      tibble::rowid_to_column()
    index <-
      as.list(index)
    results.all <-
      purrr::pmap_df(index,
        purrr::possibly(function(iv,
                                 cut.bottom,
                                 cut.top,
                                 percentage.bottom,
                                 percentage.top,
                                 dv,
                                 rowid) {
          df$Grouped <-
            dplyr::case_when(
              df[, iv] < cut.bottom ~ 0,
              df[, iv] >= cut.bottom &
                df[, iv] < cut.top ~ 1,
              df[, iv] >= cut.top ~ 2
            ) %>%
            as.factor()
          temp.anova <-
            stats::aov(stats::lm(stats::as.formula(paste0(
              "df$`", dv, "` ~ df$Grouped"
            ))))
          results.anova <-
            temp.anova %>%
            broom::tidy() %>%
            dplyr::filter(.data$term != "Residuals") %>%
            dplyr::select(-.data$term) %>%
            cbind(DV = as.character(dv))
          results.posthocs <-
            temp.anova %>%
            stats::TukeyHSD() %>%
            .[1] %>%
            as.data.frame() %>%
            tibble::rownames_to_column() %>%
            tidyr::spread("rowname", "df.Grouped.p.adj") %>%
            dplyr::select(-(dplyr::starts_with("df.Grouped"))) %>%
            cbind(DV = as.character(dv)) %>%
            dplyr::group_by(.data$DV) %>%
            dplyr::summarise_all(
              list(~ mean(., na.rm = TRUE))
            )
          mean0 <-
            df %>%
            dplyr::filter(.data$Grouped == 0) %>%
            dplyr::select(paste0(dv)) %>%
            unlist() %>%
            mean(na.rm = TRUE)
          mean1 <-
            df %>%
            dplyr::filter(.data$Grouped == 1) %>%
            dplyr::select(paste0(dv)) %>%
            unlist() %>%
            mean(na.rm = TRUE)
          mean2 <-
            df %>%
            dplyr::filter(.data$Grouped == 2) %>%
            dplyr::select(paste0(dv)) %>%
            unlist() %>%
            mean(na.rm = TRUE)
          n <-
            df %>%
            dplyr::group_by(.data$Grouped) %>%
            dplyr::summarize(Count = dplyr::n()) %>%
            tidyr::spread("Grouped", "Count")
          results <-
            results.anova %>%
            dplyr::left_join(results.posthocs,
              by = "DV",
              na_matches = "never"
            ) %>%
            cbind(
              mean_0 = mean0,
              mean_1 = mean1,
              mean_2 = mean2,
              n
            ) %>%
            dplyr::mutate_if(is.factor, as.character)
          if (isTRUE(print)) {
            print(paste0(
              rowid,
              " / ",
              length(index[[1]]),
              " - ",
              round(100 * rowid / length(index[[1]]), 2),
              "%"
            ))
          }
          results
        },
        otherwise = tibble::tibble(Error = "Y")
        ),
        .id = "Source"
      )
    index <-
      dplyr::bind_cols(index) %>%
      dplyr::select(-.data$rowid)
    final <-
      cbind(index, results.all) %>%
      # dplyr::filter(.data$Error!="Y") %>%
      dplyr::distinct() %>%
      dplyr::select(
        .data$iv,
        .data$dv,
        Cutoff.Bottom = .data$percentage.bottom,
        Cutoff.Top = .data$percentage.top,
        Cutoff.Bottom.Num = .data$cut.bottom,
        Cutoff.Bottom.Top = .data$cut.top,
        .data$df,
        .data$sumsq,
        .data$meansq,
        .data$statistic,
        .data$p.value,
        .data$mean_0,
        .data$mean_1,
        .data$mean_2,
        n_0 = .data$`0`,
        n_1 = .data$`1`,
        n_2 = .data$`2`,
        `p.value.1-0` = .data$`1-0`,
        `p.value.2-0` = .data$`2-0`,
        `p.value.2-1` = .data$`2-1`
      ) %>%
      tidyr::drop_na(.data$sumsq) %>%
      dplyr::mutate_at(dplyr::vars(
        dplyr::contains("p.value")
      ), round, 6) %>%
      dplyr::mutate_at(
        dplyr::vars(dplyr::contains("mean_")),
        list(~ dplyr::if_else(is.nan(.), NA_real_, .))
      )
    return(final)
  }
