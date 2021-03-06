% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/install_sk.R
\name{install_sk}
\alias{install_sk}
\title{Install commonly used packages}
\usage{
install_sk(extra = FALSE, dependencies = FALSE)
}
\arguments{
\item{extra}{TRUE or FALSE to indicate whether you want to install supplemental packages}

\item{dependencies}{TRUE or FALSE to indicate whether you want to pass TRUE to the install.packages() dependencies argument}
}
\description{
Installs packages that I like
}
\details{
Packages installed with the default arguments include:
\itemize{
\item clipr
\item data.table
\item knitr
\item lavaan
\item openxlsx
\item pander
\item psych
\item rmarkdown
\item roxygen2
\item shiny
\item sjmisc
\item sjlabelled
\item tidyverse
\item writexl
}

Packages installed with the extra=TRUE argument include:
\itemize{
\item anytime
\item car
\item caret
\item doParallel
\item DT
\item ez
\item dtplyr
\item effsize
\item foreach
\item formatR
\item GGally
\item ggthemes
\item googlesheets
\item gtools
\item iopsych
\item janitor
\item lmerTest
\item lsr
\item multilevel
\item nycflights13
\item parallel
\item parsedate
\item pdftools
\item plotly
\item qualtRics
\item relaimpo
\item reprex
\item reshape2
\item semTools
\item shinythemes
}
}
