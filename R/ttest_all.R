#' Conduct T-Tests at every nth percentile for list of IVs and DVs
#' @param df Dataframe with test data
#' @param ivs Names of independent variables to be inserted into dplyr::select()
#' @param dvs Names of dependent variables to be inserted into dplyr::select()
#' @param perc Nth percentile to conduct T-Test at
#' @return Data frame of tidy t.test results
#' @description Conduct T-Tests at specified percentile intervals for list of
#'   IVs and DVs
#' @importFrom rlang .data
#' @importFrom dplyr where
#' @export
#' @examples
#' ttest_all(mtcars, ivs = c("disp", "hp"), dvs = "mpg")
ttest_all <-
  function(df, ivs, dvs, perc = .05) {
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

    ivs_list |>
      purrr::map(
        \(x) {
          dvs_list |>
            purrr::map(
              \(y) {
                stats::quantile(
                  df[[x]],
                  seq(
                    from = 0.05,
                    to = .95,
                    by = perc
                  ),
                  na.rm = TRUE
                ) |>
                  as.list() |>
                  purrr::map(
                    purrr::possibly(
                      \(z) {
                        # Use internal helper to create groups
                        df$Grouped <- .create_percentile_groups(df, x, z)

                        # Create formula safely using rlang::new_formula
                        formula <- rlang::new_formula(
                          as.name(y), quote(Grouped)
                        )

                        # Calculate Cohen's D
                        cd <- effsize::cohen.d(formula, data = df)
                        cd_df <-
                          tibble::tibble(
                            cd.est = as.numeric(cd$estimate),
                            cd.mag = as.character(cd$magnitude)
                          )

                        # Run T-test
                        t_test_results <-
                          stats::t.test(formula, data = df) |>
                          broom::tidy()

                        # Efficient group count calculation
                        counts <-
                          df |>
                          dplyr::count(.data$Grouped) |>
                          tidyr::pivot_wider(
                            names_from = "Grouped",
                            values_from = "n"
                          )

                        # Combine all results
                        t_test_results |>
                          dplyr::bind_cols(counts, cd_df) |>
                          dplyr::mutate(Cutoff.Num = z) |>
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
                        cd.est = NA_real_,
                        cd.mag = NA_character_
                      )
                    )
                  ) |>
                  purrr::list_rbind(names_to = "Cutoff.Perc")
              }
            ) |>
            purrr::list_rbind(names_to = "DV")
        }
      ) |>
      purrr::list_rbind(names_to = "IV") |>
      dplyr::distinct() |>
      tidyr::drop_na("estimate") |>
      dplyr::mutate(sig = .data$p.value < .05) |>
      dplyr::mutate(dplyr::across(
        dplyr::any_of(c(
          "estimate",
          "estimate1",
          "estimate2",
          "statistic",
          "p.value",
          "parameter",
          "conf.low",
          "conf.high",
          "Cutoff.Num"
        )),
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
