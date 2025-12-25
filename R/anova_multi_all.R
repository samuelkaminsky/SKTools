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
    dvs <- dplyr::enquo(dvs)
    ivs <- dplyr::enquo(ivs)
    ivs_list <-
      df |>
      dplyr::select(!!ivs) |>
      names() |>
      purrr::set_names()
    dvs_list <-
      df |>
      dplyr::select(!!dvs) |>
      names() |>
      purrr::set_names()
    cuts <-
      ivs_list |>
      purrr::map(\(x) dplyr::pull(df, x)) |>
      purrr::map(
        \(x) {
          stats::quantile(
            x,
            seq(
              from = 0.05,
              to = .95,
              by = perc
            ),
            na.rm = TRUE
          )
        }
      ) |>
      as.data.frame() |>
      tibble::rownames_to_column("percentage") |>
      tidyr::pivot_longer(
        !"percentage",
        cols_vary = "slowest",
        names_to = "iv",
        values_to = "cut"
      ) |>
      dplyr::distinct(.data$iv, .data$cut, .keep_all = TRUE)
    iv_dv <-
      tidyr::crossing(dv = dvs_list, iv = ivs_list) |>
      dplyr::mutate(dplyr::across(everything(), as.character))
    index <-
      cuts |>
      dplyr::left_join(
        cuts,
        by = "iv",
        suffix = c(".bottom", ".top"),
        relationship = "many-to-many"
      ) |>
      dplyr::distinct() |>
      dplyr::filter(.data$cut.top >= .data$cut.bottom) |>
      dplyr::left_join(iv_dv, by = "iv", relationship = "many-to-many") |>
      dplyr::distinct() |>
      tibble::rowid_to_column()
    index <-
      as.list(index)
    results_all <-
      purrr::pmap_df(
        index,
        purrr::possibly(
          \(
            iv,
            cut.bottom,
            cut.top,
            percentage.bottom,
            percentage.top,
            dv,
            rowid
          ) {
            df$Grouped <-
              dplyr::case_when(
                df[, iv] < cut.bottom ~ 0,
                df[, iv] >= cut.bottom &
                  df[, iv] < cut.top ~
                  1,
                df[, iv] >= cut.top ~ 2
              ) |>
              as.factor()
            temp_anova <-
              stats::aov(stats::lm(
                stats::as.formula(paste0("`", dv, "` ~ Grouped")),
                data = df
              ))
            results_anova <-
              temp_anova |>
              broom::tidy() |>
              dplyr::filter(.data$term != "Residuals") |>
              dplyr::select(-"term") |>
              cbind(DV = as.character(dv))
            results_posthocs <-
              temp_anova |>
              stats::TukeyHSD() |>
              (\(x) x[1])() |>
              as.data.frame() |>
              tibble::rownames_to_column() |>
              tidyr::pivot_wider(
                names_from = "rowname",
                values_from = "Grouped.p.adj"
              ) |>
              dplyr::select(-(dplyr::starts_with("Grouped"))) |>
              cbind(DV = as.character(dv)) |>
              dplyr::group_by(.data$DV) |>
              dplyr::summarise(dplyr::across(everything(), \(x) {
                mean(x, na.rm = TRUE)
              }))
            mean0 <-
              df |>
              dplyr::filter(.data$Grouped == 0) |>
              dplyr::select(paste0(dv)) |>
              unlist() |>
              mean(na.rm = TRUE)
            mean1 <-
              df |>
              dplyr::filter(.data$Grouped == 1) |>
              dplyr::select(paste0(dv)) |>
              unlist() |>
              mean(na.rm = TRUE)
            mean2 <-
              df |>
              dplyr::filter(.data$Grouped == 2) |>
              dplyr::select(paste0(dv)) |>
              unlist() |>
              mean(na.rm = TRUE)
            n <-
              df |>
              dplyr::group_by(.data$Grouped) |>
              dplyr::summarize(Count = dplyr::n()) |>
              tidyr::pivot_wider(
                names_from = "Grouped",
                values_from = "Count"
              )
            results <-
              results_anova |>
              dplyr::left_join(
                results_posthocs,
                by = "DV",
                na_matches = "never"
              ) |>
              cbind(
                mean_0 = mean0,
                mean_1 = mean1,
                mean_2 = mean2,
                n
              ) |>
              dplyr::mutate(dplyr::across(where(is.factor), as.character))
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
            if (nrow(results) == 0) {
              return(tibble::tibble(Error = "Empty Results"))
            }
            results
          },
          otherwise = tibble::tibble(Error = "Y")
        ),
        .id = "Source"
      )
    index <-
      dplyr::bind_cols(index) |>
      dplyr::select(-"rowid")
    final_results <-
      cbind(index, results_all) |>
      dplyr::distinct() |>
      dplyr::select(
        "iv",
        "dv",
        Cutoff.Bottom = "percentage.bottom",
        Cutoff.Top = "percentage.top",
        Cutoff.Bottom.Num = "cut.bottom",
        Cutoff.Bottom.Top = "cut.top",
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
    return(final_results)
  }
