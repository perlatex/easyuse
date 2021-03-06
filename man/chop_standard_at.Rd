% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/standard.R
\name{chop_standard_at}
\alias{chop_standard_at}
\title{standardized a variable of dataframe according chopped condition}
\usage{
chop_standard_at(.data, .var, .group, .pitch)
}
\arguments{
\item{.data}{data.frame, must contain `.var`, `.group` and `.pitch` variables}

\item{.var}{specify the variables which to be standardized}

\item{.group}{group variable contained in .data}

\item{.pitch}{pitch variable contained in .data, each group have same pitch serial, for example, "p0, p10, p20, ... p100"}
}
\value{
standardized data.frame
}
\description{
standardized a variable of dataframe after chop first pitch, and discard last pitch when last pitch was less than second-to-last within each group
}
\examples{
library(tidyverse)
library(easyuse)
data(ChineseTones)

d <- ChineseTones

m <- d \%>\%
  group_by(type) \%>\%
  summarise_if(is.numeric, mean) \%>\%
  modify_at(vars(starts_with("p")), log10)

ld <- m \%>\%
  pivot_longer(
    cols = starts_with("p"),
    names_to = "id",
    values_to = "value"
  ) \%>\%
  mutate(time = 1000 * time * seq(0, 1, by = 0.1))

ld \%>\%
  chop_standard_at(.var = value, .group = type, .pitch = id)
}
