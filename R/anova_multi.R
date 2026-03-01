#' Conduct One-Way ANOVAs on Multiple DVs
#' @param df Dataframe with test data
#' @param iv Name of independent variable
#' @param dvs Names of dependent variables to be inserted into dplyr::select()
#' @param print Logical indicating whether or not ns and proportions of iv are
#'   printed
#' @return Data frame of tidy ANOVA post-hoc results, also prints Ns and
#'   percentages in each level of the IV
#' @description Conduct one-way ANOVAs on multiple DVs
#' @export
#' @examples
#' anova_multi(mtcars, iv = cyl, dvs = c(mpg, disp))
anova_multi <-
  function(df, iv, dvs, print = FALSE) {
    iv_quo <- dplyr::enquo(iv)
    dvs_quo <- dplyr::enquo(dvs)

    df_clean <-
      df |>
      dplyr::mutate(iv = as.factor(!!iv_quo)) |>
      tidyr::drop_na("iv")

    dvs_names <-
      df_clean |>
      dplyr::select(!!dvs_quo) |>
      names() |>
      purrr::set_names()

    models <-
      dvs_names |>
      purrr::map(
        \(x) {
          stats::aov(stats::reformulate("iv", response = x), data = df_clean)
        }
      )

    results_anova <-
      models |>
      purrr::map(broom::tidy) |>
      purrr::list_rbind(names_to = "DV") |>
      dplyr::filter(.data$term != "Residuals") |>
      dplyr::select(-"term")

    results_posthocs <-
      models |>
      purrr::map(stats::TukeyHSD) |>
      purrr::map(broom::tidy) |>
      purrr::list_rbind(names_to = "DV") |>
      dplyr::select("DV", "contrast", "adj.p.value") |>
      tidyr::pivot_wider(names_from = "contrast", values_from = "adj.p.value")

    # Efficient group means calculation
    means_wide <-
      df_clean |>
      dplyr::group_by(.data$iv) |>
      dplyr::summarise(dplyr::across(
        dplyr::all_of(dvs_names),
        \(x) mean(x, na.rm = TRUE)
      )) |>
      tidyr::pivot_longer(
        cols = -"iv",
        names_to = "DV",
        values_to = "mean"
      ) |>
      tidyr::pivot_wider(
        names_from = "iv",
        values_from = "mean"
      )

    df_summary <-
      means_wide |>
      dplyr::left_join(results_anova, by = "DV") |>
      dplyr::left_join(results_posthocs, by = "DV") |>
      dplyr::mutate(dplyr::across(where(is.numeric), \(x) round(x, 4)))

    if (isTRUE(print)) {
      details <- list(
        Ns = table(df_clean$iv),
        Props = prop.table(table(df_clean$iv)) |> round(3)
      )
      print(details)
    }

    df_summary
  }
