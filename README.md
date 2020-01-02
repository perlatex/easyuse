
# easyuse

<!-- badges: start -->
<!-- badges: end -->

The goal of easyuse is to assess random-effect of several student test scores

## Installation

You can install the released version of easyuse with:

``` r
devtools::install_github("perlatex/easyuse")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(easyuse)

df <- readr::read_rds("chengdu.rds")

get_ran_vals(df, school, bj, score1, score2, "class")
```

