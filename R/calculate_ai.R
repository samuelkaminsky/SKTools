#' Calculate Adverse Impact Metrics
#' @param df Dataframe with passrate information. Must include columns for each grouping of interest and columns with logicals indicating success at each stage
#' @param groupings Character vector with names of each column containing grouping variables (e.g, race, gender, etc.)
#' @param stage1 Unquoted column name of column indicating whether or not a row should be counted in the calculations (i.e., the denominator). Column must be logical.
#' @param stage2 Unquoted column name of column indicating whether or not a row should be counted as a 'Pass' in the calculations (i.e., the numerator). Column must be logical.
#' @param n_min Minimum n count for a group to be included in the calculation
#' @param prop_min Minimum percentage for a group to be included in the calculation
#' @param only_max Only calculate adverse impact using the group with the highest selection ratio as the denominator
#' @param correct a logical indicating whether Yates' continuity correction should be applied where possible.
#' @return List with two data frames. The first includes all selection ratios, the second includes all adverse impact calculation
#' \item{Selection.Ratio}{Dataframe with selection ratios}
#' \item{Adverse.Impact}{Dataframe with adverse impact metrics, including adverse impact ratio, Cohen's H, Z score test of two proportions, Pearson's chi-squared test of proportions, and Fisher's exact}
#' @export
#' @description Calculates adverse impact metrics

calculate_ai <-
  function(df,
           groupings,
           stage1,
           stage2,
           n_min = 0,
           prop_min = 0,
           only_max = FALSE,
           correct = TRUE) {
    grouping.warn <- groupings[!(groupings %in% names(df))]
    groupings <- groupings[groupings %in% names(df)]

    if (length(grouping.warn > 0)) {
      warning(paste(
        "Groupings not found in file:",
        stringr::str_c(grouping.warn, collapse = ", ")
      ))
    }

    stage1_quo <- dplyr::enquo(stage1)
    stage2_quo <- dplyr::enquo(stage2)

    df <-
      df %>%
      dplyr::rename(
        stage1 = !!stage1_quo,
        stage2 = !!stage2_quo
      )

    df.sr <- groupings %>%
      purrr::map_dfr(function(x) {
        x <- as.name(x)

        df.filter <-
          df %>%
          dplyr::count(!!x) %>%
          dplyr::mutate(perc = .data$n / sum(.data$n, na.rm = TRUE)) %>%
          dplyr::filter(.data$perc >= prop_min) %>%
          dplyr::select(-.data$n, -.data$perc)


        df %>%
          dplyr::semi_join(df.filter, by = as.character(x)) %>%
          dplyr::group_by(!!x) %>%
          tidyr::drop_na(!!x) %>%
          dplyr::summarize_at(dplyr::vars(.data$stage1, .data$stage2), sum, na.rm = TRUE)
      }) %>%
      tidyr::gather("Grouping", "Group", -c(.data$stage1, .data$stage2)) %>%
      tidyr::drop_na(.data$Group) %>%
      dplyr::mutate(SR = .data$stage2 / .data$stage1) %>%
      dplyr::select(
        .data$Grouping,
        .data$Group,
        .data$stage1,
        .data$stage2,
        .data$SR
      ) %>%
      dplyr::filter(.data$stage1 >= n_min)

    check <-
      df.sr %>%
      dplyr::mutate(check = dplyr::if_else(.data$SR > 1, TRUE, FALSE)) %>%
      dplyr::filter(check == TRUE)

    if (nrow(check) > 0) {
      df.ai <-
        list(Error = "More people in stage 2 than in stage 1, check the selection ratio table for more information.")
    } else {
      l.groups <-
        df.sr %>%
        dplyr::select(.data$Group, .data$SR) %>%
        tibble::deframe()

      df.ai <-
        df.sr %>%
        tidyr::crossing(., .) %>%
        dplyr::rename(
          Numerator = .data$Group,
          Denominator = .data$Group1
        )

      if (only_max == TRUE) {
        max.sr <-
          df.sr %>%
          dplyr::group_by(.data$Grouping) %>%
          dplyr::filter(.data$SR == max(.data$SR)) %>%
          dplyr::pull(.data$Group)

        df.ai <-
          df.ai %>%
          dplyr::filter(.data$Denominator %in% max.sr)
      }
      if (nrow(df.ai) == 0) {
        df.ai <-
          list(Error = "No adverse impact comparisons possible")
      } else {
        df.ai <-
          df.ai %>%
          dplyr::filter(
            .data$Grouping == .data$Grouping1,
            .data$Numerator != .data$Denominator
          ) %>%
          dplyr::arrange(.data$Numerator, .data$Denominator) %>%
          dplyr::mutate(
            ai.ratio = .data$SR / .data$SR1,
            H = 2 * asin(sqrt(.data$SR1)) - 2 * asin(sqrt(.data$SR)),
            Z = (.data$SR1 - .data$SR) / sqrt((.data$stage2 + .data$stage21) / ((.data$stage1 +
              .data$stage11)) * (
              1 - (.data$stage2 + .data$stage21) / (.data$stage1 + .data$stage11)
            ) * (1 / .data$stage1 + 1 / .data$stage11))
          ) %>%
          dplyr::ungroup() %>%
          dplyr::rowwise() %>%
          dplyr::mutate(conting = list(list(
            pass = c(.data$stage2, .data$stage21),
            fail = c(
              .data$stage1 - .data$stage2,
              .data$stage11 - .data$stage21
            )
          ) %>%
            tibble::as_tibble())) %>%
          dplyr::mutate(
            chi = list(
              stats::prop.test(as.matrix(.data$conting), correct = correct) %>% broom::tidy()
            ),
            f.exact = list(stats::fisher.test(.data$conting) %>% broom::tidy())
          ) %>%
          tidyr::unnest(.data$chi) %>%
          dplyr::select(
            -.data$conting,
            -.data$parameter,
            -.data$alternative,
            -.data$estimate1,
            -.data$estimate2,
            -.data$conf.low,
            -.data$conf.high
          ) %>%
          dplyr::rename(
            chi = .data$statistic,
            p.value.chi = .data$p.value
          ) %>%
          tidyr::unnest(.data$f.exact) %>%
          dplyr::rename(
            p.value.fisher = .data$p.value,
            odds.ratio = .data$estimate
          ) %>%
          dplyr::select(
            -.data$conf.low,
            -.data$conf.high,
            -.data$Grouping1,
            -.data$SR,
            -.data$SR1,
            -.data$stage1,
            -.data$stage2,
            -.data$stage11,
            -.data$stage21,
            -.data$method,
            -.data$method1,
            -.data$alternative
          ) %>%
          dplyr::mutate_if(is.double, round, 6)
      }
    }

    df.sr <-
      df.sr %>%
      dplyr::rename(
        !!paste0(dplyr::quo_name(stage1_quo), "_n") := .data$stage1, !!paste0(dplyr::quo_name(stage2_quo), "_n") := .data$stage2
      )

    list(
      Selection.Ratio = df.sr,
      Adverse.Impact = df.ai
    )
  }
