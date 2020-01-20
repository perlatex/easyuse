
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

1) For several test scores, the random effects of the test results are assessed using `lme4::lmer(score_after ~ 1 + score_pre + (1 | effect))` function

``` r
library(tidyverse)

library(easyuse)
data(chengdu)

chengdu %>%
	get_ran_vals(.var_school= school, 
				 .var_class = class, 
				 .var_score_pre = score_pre, 
				 .var_score_after = score_after, 
				 "class")
```


2) Given a cutoff-value for each variables of data.frame, in order to obtain deprivation data.frame, 
``` r
df <- tribble(
   ~id, ~x, ~y, ~z, ~g,
   #--|--|--|--|--
   "a", 13.1, 14, 4, 1,
   "b", 11.2, 7, 5, 0,
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

3) Calculate the rowwise weighted mean for columns selected in data.frame
``` r
weights <- c(
   x = 0.25,
   y = 0.25,
   z = 0.25,
   g = 0.25
 )

df %>% 
  add_weighted_mean(x:g, .name = "wt_mean", .weights = weights)

# A tibble: 4 x 6
  id        x     y     z     g wt_mean
  <chr> <dbl> <dbl> <dbl> <dbl>   <dbl>
1 a      13.1    14     4     1    8.02
2 b      11.2     7     5     0    5.8 
3 c      12.5    10     1     0    5.88
4 d      20      11     3     1    8.75
```