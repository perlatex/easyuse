
# easyuse

<!-- badges: start -->
<!-- badges: end -->

The goal of easyuse is to assess random-effect and statistical-description for several test scores.

## Installation

You can install the development version of `easyuse` with:

``` r
devtools::install_github("perlatex/easyuse")
```

## Example

This is a basic example:

``` r
library(easyuse)

## you should download the test data "chengdu.rds" from repo
df <- readr::read_rds("chengdu.rds")

get_ran_vals(df, school, class, score1, score2, "class")
```

