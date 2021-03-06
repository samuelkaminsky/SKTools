% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read.xlsx.all.R
\name{read.xlsx.all}
\alias{read.xlsx.all}
\title{Read an entire Excel file workbook (using openxlsx functions)}
\usage{
read.xlsx.all(
  xlsxFile,
  save2env = FALSE,
  names = "",
  startRow = 1,
  detectDates = TRUE
)
}
\arguments{
\item{xlsxFile}{Path to the xls/xlsx file}

\item{save2env}{Either TRUE to save each worksheet to the environment or
FALSE to return a list of worksheets, which can be saved to the environment}

\item{names}{A vector of character data representing preferred sheet names}

\item{startRow}{first row to begin looking for data. Empty rows at the top
of a file are always skipped, regardless of the value of startRow.}

\item{detectDates}{If TRUE, attempt to recognise dates and perform conversion.}
}
\value{
If there is more than one worksheet, then a list of data frames that
represent each worksheet. If there is only one worksheet, then a data frame.
}
\description{
Read an entire Excel file workbook (using openxlsx functions)
}
