% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rowwise.R
\name{add_weighted_sum}
\alias{add_weighted_sum}
\title{Calculate the rowwise weighted sum for columns selected in data.frame}
\usage{
add_weighted_sum(.data, ..., .weights, .name = "weighted_sum", na.rm = TRUE)
}
\arguments{
\item{.data}{data.frame}

\item{...}{columns selected for rowwise `sum` or `mean` using `tidyselect` grammar}

\item{.weights}{weights corresponding columns selected in dataframe}

\item{.name}{the name of new column}

\item{na.rm}{whether to delete the missing value, `TRUE` or `FALSE`}
}
\value{

}
\description{
Calculate the rowwise weighted sum for columns selected in data.frame
}
\examples{
df <- tribble(
  ~id, ~x, ~y, ~z, ~g,
  #--|--|--|--|--
  "a", 13.1, 14, 4, 1,
  "b", 11.2, 7, 5, 0,
  "c", 12.5, 10, 1, 0,
  "d", 20, 11, 3, 1
)


weights <- c(
  x = 0.25,
  y = 0.25,
  z = 0.25,
  g = 0.25
)

df \%>\% add_weighted_sum(x:g, .name = "wt_sum", .weights = weights)
}
