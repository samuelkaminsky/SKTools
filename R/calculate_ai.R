#' Calculate Adverse Impact Metrics
#' @param df Dataframe with passrate information. Must include columns for each
#'   grouping of interest and columns with logicals indicating success at each
#'   stage
#' @param groupings Character vector with names of each column containing
#'   grouping variables (e.g, race, gender, etc.)
#' @param stage1 Unquoted column name of column indicating whether or not a row
#'   should be counted in the calculations (i.e., the denominator). Column must
#'   be logical.
#' @param stage2 Unquoted column name of column indicating whether or not a row
#'   should be counted as a 'Pass' in the calculations (i.e., the numerator).
#'   Column must be logical.
#' @param n_min Minimum n count for a group to be included in the calculation
#' @param prop_min Minimum percentage for a group to be included in the
#'   calculation
#' @param only_max Only calculate adverse impact using the group with the
#'   highest selection ratio as the denominator
#' @param correct a logical indicating whether Yates' continuity correction
#'   should be applied where possible.
#' @return List with two data frames. The first includes all selection ratios,
#'   the second includes all adverse impact calculation
#' \item{selection_ratio}{Dataframe with selection ratios}
#' \item{adverse_impact}{Dataframe with adverse impact metrics, including
#' adverse impact ratio, Cohen's H, Z score test of two proportions, Pearson's
#' chi-squared test of proportions, and Fisher's exact}
#' @details Calculates selection ratios and adverse impact using Fisher's Exact
#'   Test, Z-test for two proportions, and Chi-Squared test.
#' @export
#' @description Calculates adverse impact metrics
#' @examples
#' df <- tibble::tibble(
#'   gender = c(rep("Male", 10), rep("Female", 10)),
#'   applied = c(rep(TRUE, 10), rep(TRUE, 10)),
#'   hired = c(rep(TRUE, 5), rep(FALSE, 5), rep(TRUE, 8), rep(FALSE, 2))
#' )
#' calculate_ai(df, groupings = "gender", stage1 = applied, stage2 = hired)
calculate_ai <-
  function(
    df,
    groupings,
    stage1,
    stage2,
    n_min = 0,
    prop_min = 0,
    only_max = FALSE,
    correct = TRUE
  ) {
    grouping_warn <- groupings[!(groupings %in% names(df))]
    groupings <- groupings[groupings %in% names(df)]

    if (length(grouping_warn > 0)) {
      warning(paste(
        "Groupings not found in file:",
        stringr::str_c(grouping_warn, collapse = ", ")
      ))
    }

    stage1_quo <- dplyr::enquo(stage1)
    stage2_quo <- dplyr::enquo(stage2)

    df <-
      df |>
      dplyr::rename(
        stage1 = !!stage1_quo,
        stage2 = !!stage2_quo
      )

    # Calculate Selection Ratios
    df_sr <- groupings |>
      purrr::map_dfr(\(x) {
        x <- as.name(x)

        # Filter out groups with insufficient N or proportion
        df_filter <-
          df |>
          dplyr::count(!!x) |>
          dplyr::mutate(perc = .data$n / sum(.data$n, na.rm = TRUE)) |>
          dplyr::filter(.data$perc >= prop_min) |>
          dplyr::select(-"n", -"perc")

        df |>
          dplyr::semi_join(df_filter, by = as.character(x)) |>
          dplyr::group_by(!!x) |>
          tidyr::drop_na(!!x) |>
          dplyr::summarize(dplyr::across(
            c("stage1", "stage2"),
            \(x) sum(x, na.rm = TRUE)
          ))
      }) |>
      tidyr::pivot_longer(
        !c("stage1", "stage2"),
        cols_vary = "slowest",
        names_to = "Grouping",
        values_to = "Group",
        values_drop_na = TRUE
      ) |>
      dplyr::mutate(SR = .data$stage2 / .data$stage1) |>
      dplyr::select(
        "Grouping",
        "Group",
        "stage1",
        "stage2",
        "SR"
      ) |>
      dplyr::filter(.data$stage1 >= n_min)

    # Sanity Check
    check <-
      df_sr |>
      dplyr::mutate(check = dplyr::if_else(.data$SR > 1, TRUE, FALSE)) |>
      dplyr::filter(check == TRUE)

    if (nrow(check) > 0) {
      df_ai <-
        list(
          Error = paste(
            "More people in stage 2 than in stage 1,",
            "check the selection ratio table for more information."
          )
        )
    } else {
      df_sr1 <- df_sr |>
        dplyr::rename_with(\(x) paste0(x, "1"))

      # Cross join to create all pairwise comparisons
      df_ai <-
        tidyr::crossing(df_sr, df_sr1) |>
        dplyr::rename(
          Numerator = "Group",
          Denominator = "Group1"
        )

      if (only_max == TRUE) {
        # Keep only comparisons against the group with the highest selection
        # ratio
        max_sr <-
          df_sr |>
          dplyr::group_by(.data$Grouping) |>
          dplyr::filter(.data$SR == max(.data$SR)) |>
          dplyr::pull(.data$Group)

        df_ai <-
          df_ai |>
          dplyr::filter(.data$Denominator %in% max_sr)
      }
      if (nrow(df_ai) == 0) {
        df_ai <-
          list(Error = "No adverse impact comparisons possible")
      } else {
        # Calculate Adverse Impact Stats
        df_ai <-
          df_ai |>
          dplyr::filter(
            .data$Grouping == .data$Grouping1,
            .data$Numerator != .data$Denominator
          ) |>
          dplyr::arrange(.data$Numerator, .data$Denominator) |>
          dplyr::mutate(
            ai_ratio = .data$SR / .data$SR1,
            H = 2 * asin(sqrt(.data$SR1)) - 2 * asin(sqrt(.data$SR)),
            # Z-test for two proportions
            Z = {
              n1 <- .data$stage1
              n2 <- .data$stage11
              p_pooled <-
                (.data$stage2 + .data$stage21) / (.data$stage1 + .data$stage11)
              se <- sqrt(p_pooled * (1 - p_pooled) * (1 / n1 + 1 / n2))
              (.data$SR1 - .data$SR) / se
            }
          ) |>
          dplyr::ungroup() |>
          dplyr::rowwise() |>
          dplyr::mutate(
            conting = list(
              list(
                pass = c(.data$stage2, .data$stage21),
                fail = c(
                  .data$stage1 - .data$stage2,
                  .data$stage11 - .data$stage21
                )
              ) |>
                tibble::as_tibble()
            )
          ) |>
          # Run Chi-Square and Fisher's Exact tests on contingency tables
          dplyr::mutate(
            chi = list(
              stats::prop.test(as.matrix(.data$conting), correct = correct) |>
                broom::tidy()
            ),
            f_exact = list(stats::fisher.test(.data$conting) |> broom::tidy())
          ) |>
          tidyr::unnest("chi") |>
          dplyr::select(
            -"conting",
            -"parameter",
            -"alternative",
            -"estimate1",
            -"estimate2",
            -"conf.low",
            -"conf.high",
            -"method"
          ) |>
          dplyr::rename(
            chi = "statistic",
            p_value_chi = "p.value"
          ) |>
          tidyr::unnest("f_exact") |>
          dplyr::rename(
            p_value_fisher = "p.value",
            odds_ratio = "estimate"
          ) |>
          dplyr::select(
            -"conf.low",
            -"conf.high",
            -"Grouping1",
            -"SR",
            -"SR1",
            -"stage1",
            -"stage2",
            -"stage11",
            -"stage21",
            -"method",
            -"alternative"
          ) |>
          dplyr::mutate(dplyr::across(where(is.double), \(x) round(x, 6)))
      }
    }

    df_sr <-
      df_sr |>
      dplyr::rename(
        !!paste0(dplyr::quo_name(stage1_quo), "_n") := "stage1",
        !!paste0(dplyr::quo_name(stage2_quo), "_n") := "stage2"
      )

    list(
      selection_ratio = df_sr,
      adverse_impact = df_ai
    )
  }
