#' Dataframe Descriptives and Frequencies
#' @param df Dataframe with data
#' @param frequencies Logical to indicate whether or not to calculate
#'   frequencies for each variable as a list column
#' @return Dataframe of descriptives and frequencies for each variable and value
#' @description Calculates descriptives and frequencies of every Column in a
#'   dataframe. Heavily inspired by Ujjwal Karn's XDA package.
#' @importFrom rlang .data
#' @importFrom dplyr group_by where
#' @export
#' @examples
#' descriptives(mtcars)
descriptives <-
  function(df, frequencies = FALSE) {
    if (dplyr::is_grouped_df(df)) {
      return(
        df |>
          dplyr::group_modify(
            \(x, ...) descriptives(x, frequencies = frequencies)
          ) |>
          dplyr::ungroup()
      )
    }

    # Prepare dataframe
    df_func <-
      df |>
      tibble::set_tidy_names(syntactic = TRUE, quiet = TRUE) |>
      dplyr::mutate(dplyr::across(where(is.factor), as.character)) |>
      sjlabelled::remove_all_labels()

    # 1. Basic Stats (Class, Missing, N)
    basic_stats <-
      df_func |>
      purrr::map(
        \(x) {
          n_miss <- sum(is.na(x))
          n_total <- length(x)
          tibble::tibble(
            class = paste(class(x), collapse = ", "),
            n = n_total - n_miss,
            n_missing = n_miss,
            perc_missing = n_miss / n_total
          )
        }
      ) |>
      purrr::list_rbind(names_to = "var")

    # 2. Numeric Stats
    df_num <- df_func |> dplyr::select(where(is.numeric))

    if (ncol(df_num) > 0) {
      stats_df <-
        df_num |>
        purrr::map(
          \(x) {
            x_clean <- x[!is.na(x)]
            if (length(x_clean) == 0) {
              return(tibble::tibble(
                mean = NA_real_,
                median = NA_real_,
                max = NA_real_,
                min = NA_real_,
                sd = NA_real_,
                range = NA_real_,
                iqr = NA_real_,
                skewness = NA_real_,
                kurtosis = NA_real_,
                n_unique = 0L,
                `1%` = NA_real_,
                `25%` = NA_real_,
                `50%` = NA_real_,
                `75%` = NA_real_,
                `99%` = NA_real_
              ))
            }

            qs <- stats::quantile(
              x_clean,
              probs = c(0.01, 0.25, 0.5, 0.75, 0.99)
            )

            tibble::tibble(
              mean = mean(x_clean),
              median = stats::median(x_clean),
              max = max(x_clean),
              min = min(x_clean),
              sd = stats::sd(x_clean),
              range = max(x_clean) - min(x_clean),
              iqr = stats::IQR(x_clean),
              skewness = moments::skewness(x_clean),
              kurtosis = moments::kurtosis(x_clean),
              n_unique = length(unique(x_clean)),
              `1%` = qs[1],
              `25%` = qs[2],
              `50%` = qs[3],
              `75%` = qs[4],
              `99%` = qs[5]
            )
          }
        ) |>
        purrr::list_rbind(names_to = "var")
    } else {
      stats_df <- tibble::tibble(var = character())
    }

    # Join basic stats
    df_final <-
      basic_stats |>
      dplyr::left_join(stats_df, by = "var")

    # 3. Frequencies (Optional)
    if (isTRUE(frequencies)) {
      # Use the optimized frequencies function
      freqs <-
        frequencies(df_func, perc = FALSE) |>
        dplyr::group_by(.data$var) |>
        tidyr::nest(frequencies = c("value", "n")) |>
        dplyr::mutate(
          frequencies = .data$frequencies |> purrr::set_names(.data$var)
        )

      df_final <-
        df_final |>
        dplyr::left_join(freqs, by = "var")
    }

    # Final Selection
    cols_to_select <- c(
      "var",
      "class",
      "mean",
      "median",
      "max",
      "min",
      "sd",
      "range",
      "iqr",
      "skewness",
      "kurtosis",
      "n_unique",
      "n",
      "n_missing",
      "perc_missing",
      "1%",
      "25%",
      "50%",
      "75%",
      "99%"
    )

    if (isTRUE(frequencies)) {
      cols_to_select <- c(cols_to_select, "frequencies")
    }

    # Ensure all columns exist (in case no numeric vars)
    existing_cols <- intersect(cols_to_select, names(df_final))

    df_final |>
      dplyr::select(dplyr::all_of(existing_cols))
  }