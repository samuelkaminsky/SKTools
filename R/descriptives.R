#' Dataframe Descriptives and Frequencies
#' @param df Dataframe with data
#' @param frequencies Logical to indicate whether or not to calculate frequencies for each variable as a list column
#' @return Dataframe of descriptives and frequencies for each variable and value
#' @description Calculates descriptives and frequencies of every Column in a dataframe. Heavily inspired by Ujjwal Karn's XDA package.
#' @export

descriptives <-
  function(df, frequencies = FALSE) {
    # Prepare dataframe
    df.func <-
      df |>
      tibble::set_tidy_names(syntactic = TRUE, quiet = TRUE) |>
      dplyr::mutate(dplyr::across(where(is.factor), as.character)) |>
      sjlabelled::remove_all_labels()

    # 1. Class
    class_df <-
      df.func |>
      purrr::map_chr(\(x) paste(class(x), collapse = ", ")) |>
      tibble::enframe(name = "var", value = "class")

    # 2. Missing / N
    missing_df <-
      df.func |>
      purrr::map_dfr(\(x) {
        n_miss <- sum(is.na(x))
        tibble::tibble(
          n = length(x) - n_miss,
          n_missing = n_miss,
          perc_missing = n_miss / length(x)
        )
      }, .id = "var")

    # 3. Numeric Stats
    df_num <- df.func |> dplyr::select(where(is.numeric))
    
    if (ncol(df_num) > 0) {
      stats_df <-
        df_num |>
        purrr::map_dfr(\(x) {
          x_clean <- stats::na.omit(x)
          if (length(x_clean) == 0) {
            return(tibble::tibble(
              mean = NA_real_, median = NA_real_, max = NA_real_, min = NA_real_,
              sd = NA_real_, range = NA_real_, iqr = NA_real_,
              skewness = NA_real_, kurtosis = NA_real_, n_unique = 0L,
              `1%` = NA_real_, `25%` = NA_real_, `50%` = NA_real_,
              `75%` = NA_real_, `99%` = NA_real_
            ))
          }
          
          q <- stats::quantile(x_clean, probs = c(0.01, 0.25, 0.5, 0.75, 0.99))
          
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
            `1%` = q[1],
            `25%` = q[2],
            `50%` = q[3],
            `75%` = q[4],
            `99%` = q[5]
          )
        }, .id = "var")
    } else {
      stats_df <- tibble::tibble(var = character())
    }

    # Join basic stats
    df.final <-
      class_df |>
      dplyr::left_join(stats_df, by = "var") |>
      dplyr::left_join(missing_df, by = "var")

    # 4. Frequencies (Optional)
    if (isTRUE(frequencies)) {
      freqs <-
        df.func |>
        names() |>
        purrr::set_names() |>
        purrr::map_dfr(
          \(x) {
            df.func |>
              dplyr::count(!!dplyr::sym(x)) |>
              purrr::set_names(c("value", "n")) |>
              dplyr::mutate(value = as.character(.data$value))
          },
          .id = "var"
        ) |>
        dplyr::group_by(.data$var) |>
        tidyr::nest(frequencies = c("value", "n")) |>
        dplyr::mutate(
          frequencies = .data$frequencies |> purrr::set_names(.data$var)
        )
      
      df.final <-
        df.final |>
        dplyr::left_join(freqs, by = "var")
    }

    # Final Selection
    cols_to_select <- c(
      "var", "class", "mean", "median", "max", "min", "sd", "range", 
      "iqr", "skewness", "kurtosis", "n_unique", "n", "n_missing", 
      "perc_missing", "1%", "25%", "50%", "75%", "99%"
    )
    
    if (isTRUE(frequencies)) {
      cols_to_select <- c(cols_to_select, "frequencies")
    }
    
    # Ensure all columns exist (in case no numeric vars)
    existing_cols <- intersect(cols_to_select, names(df.final))
    
    df.final |>
      dplyr::select(dplyr::all_of(existing_cols))
  }