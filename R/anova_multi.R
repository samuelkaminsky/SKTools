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
    iv <- dplyr::enquo(iv)
    dvs <- dplyr::enquo(dvs)
    df <-
      df |>
      dplyr::mutate(iv = as.factor(!!iv)) |>
      tidyr::drop_na(iv)
    dvs_list <-
      df |>
      dplyr::select(!!dvs) |>
      names() |>
      as.list() |>
      purrr::set_names()
    models <-
      dvs_list |>
      purrr::map(
        \(x) {
          stats::aov(stats::reformulate("iv", response = x), data = df)
        }
      )

    results_anova <-
      models |>
      purrr::map_df(broom::tidy, .id = "DV") |>
      dplyr::filter(.data$term != "Residuals") |>
      dplyr::select(-"term")

    results_posthocs <-
      models |>
      purrr::map(stats::TukeyHSD) |>
      purrr::map_df(broom::tidy, .id = "DV") |>
      dplyr::select("DV", "contrast", "adj.p.value") |>
      tidyr::pivot_wider(names_from = "contrast", values_from = "adj.p.value")
    results <-
      results_anova |>
      dplyr::left_join(results_posthocs, by = "DV", na_matches = "never")
    means <-
      df |>
      dplyr::group_by(iv) |>
      dplyr::summarise(dplyr::across(
        !!dvs,
        \(x) mean(x, na.rm = TRUE)
      ))
    means_t <-
      means |>
      dplyr::select(-"iv") |>
      t() |>
      as.data.frame() |>
      purrr::set_names(
        means |>
          dplyr::pull("iv") |>
          unlist()
      ) |>
      tibble::rownames_to_column(var = "DV")
    df_summary <-
      means_t |>
      dplyr::bind_cols(
        results |>
          dplyr::select(7:dplyr::last_col())
      ) |>
      as.data.frame() |>
      dplyr::mutate(dplyr::across(where(is.numeric), \(x) round(x, 4)))
    if (isTRUE(print)) {
      details <- list(
        Ns = table(df$iv),
        Props = prop.table(table(df$iv)) |> round(3)
      )
      print(details)
    }
    df_summary
  }
