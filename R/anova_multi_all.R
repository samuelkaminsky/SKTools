#' Conducts One-Way ANOVAs on Multiple DVs at Multiple Cut Points
#' @param df Dataframe with test data
#' @param ivs Names of independent variables to be inserted into dplyr::select()
#' @param dvs Names of dependent variables to be inserted into dplyr::select()
#' @param perc Nth percentile to conduct ANOVA at
#' @param print TRUE to print progress as it goes
#' @return Data frame of tidy ANOVA F test and post-hoc results,
#' also includes descriptives about each level of the IV
#' @description Conduct one-way ANOVAs on multiple DVs at various cutpoints
#' of the iv
#' @export
#' @examples
#' anova_multi_all(mtcars, ivs = c(disp, hp), dvs = mpg)
anova_multi_all <-
  function(df, ivs, dvs, perc = .05, print = FALSE) {
    dvs_quo <- dplyr::enquo(dvs)
    ivs_quo <- dplyr::enquo(ivs)

    ivs_list <-
      df |>
      dplyr::select(!!ivs_quo) |>
      names() |>
      purrr::set_names()
    dvs_list <-
      df |>
      dplyr::select(!!dvs_quo) |>
      names() |>
      purrr::set_names()

    # Calculate quantiles for each IV to determine cutpoints
    cuts <-
      ivs_list |>
      purrr::map(\(x) {
        stats::quantile(
          df[[x]],
          seq(
            from = 0.05,
            to = 0.95,
            by = perc
          ),
          na.rm = TRUE
        )
      }) |>
      purrr::map(tibble::enframe, name = "percentage", value = "cut") |>
      purrr::list_rbind(names_to = "iv") |>
      dplyr::distinct(.data$iv, .data$cut, .keep_all = TRUE)

    # Create an index of all combinations of IVs, DVs, and cutpoints
    index <-
      cuts |>
      dplyr::rename(percentage_bottom = "percentage", cut_bottom = "cut") |>
      dplyr::inner_join(
        cuts |> dplyr::rename(percentage_top = "percentage", cut_top = "cut"),
        by = "iv",
        relationship = "many-to-many"
      ) |>
      dplyr::filter(.data$cut_top >= .data$cut_bottom) |>
      tidyr::crossing(dv = dvs_list) |>
      tibble::rowid_to_column()

    # Execute ANOVA for each combination
    results_all <-
      purrr::pmap(
        as.list(index),
        purrr::possibly(
          \(
            rowid,
            iv,
            percentage_bottom,
            cut_bottom,
            percentage_top,
            cut_top,
            dv
          ) {
            # Use internal helper to create groups
            df$Grouped <- .create_percentile_groups(df, iv, cut_bottom, cut_top)

            # Run ANOVA
            formula <- rlang::new_formula(as.name(dv), quote(Grouped))
            temp_anova <- stats::aov(formula, data = df)

            # Tidy ANOVA results
            results_anova <-
              temp_anova |>
              broom::tidy() |>
              dplyr::filter(.data$term == "Grouped") |>
              dplyr::select(-"term")

            # Run Post-Hoc Tests (Tukey HSD)
            # We must collapse multiple rows from TukeyHSD into one row
            results_posthocs <-
              temp_anova |>
              stats::TukeyHSD() |>
              (\(x) x[["Grouped"]])() |>
              as.data.frame() |>
              tibble::rownames_to_column() |>
              dplyr::select("rowname", "p adj") |>
              tidyr::pivot_wider(
                names_from = "rowname",
                values_from = "p adj"
              )

            # Calculate group statistics efficiently
            group_stats <-
              df |>
              dplyr::group_by(.data$Grouped) |>
              dplyr::summarise(
                mean = mean(!!as.name(dv), na.rm = TRUE),
                n = dplyr::n(),
                .groups = "drop"
              )

            means_wide <-
              group_stats |>
              dplyr::select("Grouped", "mean") |>
              dplyr::mutate(Grouped = paste0("mean_", .data$Grouped)) |>
              tidyr::pivot_wider(names_from = "Grouped", values_from = "mean")

            n_wide <-
              group_stats |>
              dplyr::select("Grouped", "n") |>
              tidyr::pivot_wider(names_from = "Grouped", values_from = "n")

            # Combine everything into a single row
            results <-
              results_anova |>
              dplyr::bind_cols(results_posthocs, means_wide, n_wide) |>
              dplyr::mutate(
                iv = iv,
                dv = dv,
                Cutoff.Bottom = percentage_bottom,
                Cutoff.Top = percentage_top,
                Cutoff.Bottom.Num = cut_bottom,
                Cutoff.Bottom.Top = cut_top
              ) |>
              dplyr::mutate(dplyr::across(where(is.factor), as.character))

            if (isTRUE(print)) {
              print(paste0(
                rowid,
                " / ",
                nrow(index),
                " - ",
                round(100 * rowid / nrow(index), 2),
                "%"
              ))
            }
            results
          },
          otherwise = tibble::tibble(Error = "Y")
        )
      ) |>
      purrr::list_rbind()

    final_results <-
      results_all |>
      dplyr::distinct() |>
      dplyr::select(
        "iv",
        "dv",
        "Cutoff.Bottom",
        "Cutoff.Top",
        "Cutoff.Bottom.Num",
        "Cutoff.Bottom.Top",
        dplyr::any_of(c(
          "df",
          "sumsq",
          "meansq",
          "statistic",
          "p.value",
          "mean_0",
          "mean_1",
          "mean_2",
          n_0 = "0",
          n_1 = "1",
          n_2 = "2",
          `p.value.1-0` = "1-0",
          `p.value.2-0` = "2-0",
          `p.value.2-1` = "2-1"
        ))
      ) |>
      tidyr::drop_na(dplyr::any_of("sumsq")) |>
      dplyr::mutate(dplyr::across(
        dplyr::contains("p.value"),
        \(x) round(x, 6)
      )) |>
      dplyr::mutate(dplyr::across(
        dplyr::contains("mean_"),
        \(x) dplyr::if_else(is.nan(x), NA_real_, x)
      ))

    final_results
  }
