#' Create Percentile-Based Groups
#'
#' This is an internal helper to create groups based on percentiles of an IV.
#'
#' @param df A data frame.
#' @param iv Character name of the independent variable.
#' @param cut_bottom Numeric value for the bottom cutoff.
#' @param cut_top Numeric value for the top cutoff (optional).
#' @return A factor vector of group assignments.
#' @keywords internal
.create_percentile_groups <- function(df, iv, cut_bottom, cut_top = NULL) {
  if (is.null(cut_top)) {
    # Two-group case (e.g., t-test)
    # Using 1 for >= cut_bottom, 0 for < cut_bottom
    groups <- dplyr::if_else(df[[iv]] >= cut_bottom, 1, 0)
  } else {
    # Three-group case (e.g., ANOVA)
    # 0: < cut_bottom
    # 1: [cut_bottom, cut_top)
    # 2: >= cut_top
    groups <- dplyr::case_when(
      df[[iv]] < cut_bottom ~ 0,
      df[[iv]] >= cut_bottom & df[[iv]] < cut_top ~ 1,
      df[[iv]] >= cut_top ~ 2,
      .default = NA_real_
    )
  }
  as.factor(groups)
}
