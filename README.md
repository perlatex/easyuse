
# easyuse

<!-- badges: start -->
<!-- badges: end -->

The goal of easyuse is to make social statistics more easy and more tidyverse.

## Installation

You can install the development version of `easyuse` with:

``` r
devtools::install_github("perlatex/easyuse")
```

## Example

This is a basic example:

``` r
library(tidyverse)
library(easyuse)

## you should download the test data "chengdu.rds" from repo
df <- readr::read_rds("chengdu.rds")

get_ran_vals(df, school, class, score1, score2, "class")
```



``` r
 df <- tribble(
   ~id, ~x, ~y, ~z, ~g,
   #--|--|--|--|--
   "a", 13.1, 14, 4, 1,
   "b", 15.2, 7, 5, 0,
   "c", 12.5, 10, 1, 0,
   "d", 20, 11, 3, 1
   )
   
 df %>%
   cutoffs_modify_at(.vars = c(x, y), cutoffs = c(x = 13, y = 12))

# A tibble: 4 x 5
  id        x     y     z     g
  <chr> <dbl> <dbl> <dbl> <dbl>
1 a         0     0     4     1
2 b         0     1     5     0
3 c         1     1     1     0
4 d         0     1     3     1
```
