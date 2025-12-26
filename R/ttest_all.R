#' Conduct T-Tests at every nth percentile for list of IVs and DVs
#' @param df Dataframe with test data
#' @param ivs Names of independent variables to be inserted into dplyr::select()
#' @param dvs Names of dependent variables to be inserted into dplyr::select()
#' @param perc Nth percentile to conduct T-Test at
#' @return Data frame of tidy t.test results
#' @description Conduct T-Tests at specified percentile intervals for list of
#'   IVs and DVs
#' @export
#' @examples
#' ttest_all(mtcars, ivs = c("disp", "hp"), dvs = "mpg")
ttest_all <-
  function(df, ivs, dvs, perc = .05) {
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

    ivs_list |>
      purrr::map_dfr(
        \(x) {
          dvs_list |>
            purrr::map_dfr(
              \(y) {
                y_quo <- rlang::enquo(y)

                stats::quantile(
                  df[[x]] |> unlist(),
                  seq(
                    from = 0.05,
                    to = .95,
                    by = perc
                  ),
                  na.rm = TRUE
                ) |>
                  as.list() |>
                  purrr::map_dfr(
                    purrr::possibly(
                      \(z) {
                        df$Grouped <-
                          dplyr::if_else(df[[x]] >= z, 1, 0) |>
                          as.factor()
                        cd <-
                          effsize::cohen.d(
                            stats::as.formula(paste0(y, " ~ Grouped")),
                            data = df
                          )
                        cd_df <-
                          tibble::tibble(
                            cd.est = cd$estimate |> as.numeric(),
                            cd.mag = cd$magnitude |> as.character()
                          )
                        stats::t.test(
                          stats::as.formula(paste0(y, " ~ Grouped")),
                          data = df
                        ) |>
                          broom::tidy() |>
                          cbind(
                            df |>
                              dplyr::group_by(.data$Grouped, !!y_quo) |>
                              dplyr::summarize(Count = dplyr::n()) |>
                              dplyr::group_by(.data$Grouped) |>
                              dplyr::summarize(Count = sum(.data$Count)) |>
                              tidyr::pivot_wider(
                                names_from = "Grouped",
                                values_from = "Count"
                              ),
                            Cutoff.Num = z,
                            cd_df
                          ) |>
                          dplyr::mutate(dplyr::across(
                            where(is.factor),
                            as.character
                          ))
                      },
                      otherwise = tibble::tibble(
                        estimate = NA_real_,
                        estimate1 = NA_real_,
                        estimate2 = NA_real_,
                        statistic = NA_real_,
                        p.value = NA_real_,
                        parameter = NA_real_,
                        conf.low = NA_real_,
                        conf.high = NA_real_,
                        method = NA_character_,
                        alternative = NA_character_,
                        `0` = NA_real_,
                        `1` = NA_real_,
                        Cutoff.Num = NA_real_,
                        Cutoff.Perc = NA_real_,
                        cd.est = NA_real_,
                        cd.mag = NA_character_
                      )
                    ),
                    .id = "Cutoff.Perc"
                  )
              },
              .id = "DV"
            )
        },
        .id = "IV"
      ) |>
      dplyr::distinct() |>
      tidyr::drop_na("estimate") |>
      dplyr::mutate(sig = dplyr::if_else(.data$p.value < .05, TRUE, FALSE)) |>
      dplyr::mutate(dplyr::across(
        c("estimate":"conf.high", "Cutoff.Num"),
        \(x) round(x, 6)
      )) |>
      dplyr::distinct(
        .data$IV,
        .data$DV,
        .data$estimate,
        .data$estimate1,
        .keep_all = TRUE
      ) |>
      dplyr::select(
        "IV",
        "DV",
        "Cutoff.Perc",
        "Cutoff.Num",
        dplyr::everything()
      )
  }
