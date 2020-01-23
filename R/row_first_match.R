#' Find the value of the first match in rowwise
#'
#' Find the value of the first match in rowwise. The code from https://community.rstudio.com/t/interesting-tidy-eval-use-cases/21121/39
#' @param .f A function, formula, or vector, like in `purrr::detect()`
#' 
#'   If a function, it is used as is.
#'   
#'   If a formula, e.g. ~ .x + 2, it is converted to a function. There
#'   are three ways to refer to the arguments:
#'
#'
#'   * For a single argument function, use `.`
#'      
#'   * For a two argument function, use `.x` and `.y`
#'      
#'   * For more arguments, use `..1`, `..2`, `..3` etc
#'   
#'   This syntax allows you to create very compact anonymous functions.
#' @param ... column names selected in data.frame, e.g. `x, y, z`.
#'   
#' @return
#' @export
#'
#' @examples
#' df <- tibble(
#'   a = c("b", "d", "l", "m"), 
#'   x = c(1, 1, 1, 2), 
#'   y = c(5, 1, 2, 3), 
#'   z = c(1, 1, 0, 1)
#' )
#' 
#' 
#' df %>% dplyr::mutate(new_col = first_match(~ . > 1, x, y, z))

row_first_match <- function(.f, ...) {
  tibble(...) %>% 
    purrr::transpose() %>% 
    purrr::map_dbl(~ purrr::detect(.x, .f) %||% NA)
}




