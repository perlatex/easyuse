
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

1) For several test scores, the random effects of the test results are assessed using `lme4::lmer(score2 ~ 1 + (1 | score1))` funciton

``` r
library(tidyverse)
library(easyuse)

## you should download the test data "chengdu.rds" from repo
df <- readr::read_rds("chengdu.rds")

get_ran_vals(df, school, class, score1, score2, "class")
```


2) Given a cutoff-value for each variables of data.frame, in order to obtain deprivation data.frame, 
``` r
df <- tribble(
   ~id, ~x, ~y, ~z, ~g,
   #--|--|--|--|--
   "a", 13.1, 14, 4, 1,
   "b", 15.2, 7, 5, 0,
   "c", 12.5, 10, 1, 0,
   "d", 20, 11, 3, 1
   )
   
cutoffs <- c(x = 13, y = 12, z = 3)
```



Generally, we can using `mutate() + if_else()`
``` r
df %>%
  mutate(x = if_else(x < cutoffs$x, 1, 0)) %>%
  mutate(y = if_else(y < cutoffs$y, 1, 0)) %>%
  mutate(z = if_else(z < cutoffs$z, 1, 0))
```

or using `pivot_longer()` and then `pivot_wider()`
``` r
df %>%
  pivot_longer(cols = x:z, 
               names_to = "var", 
               values_to = "val") %>%
  mutate(below_cutoff = as.integer(val < cutoffs[var])) %>% 
  select(id, g, var, below_cutoff) %>%
  pivot_wider(names_from = var, values_from = below_cutoff)
```


Of course, we can write more intuitively
  
``` r
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
