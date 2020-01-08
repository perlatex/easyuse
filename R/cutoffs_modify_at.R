#' @title  To obtain deprivation data.frame 
#' @description To be specific, given a cutoff value for each variables of data.frame, 
#' if the value of variable is greater than the corresponding cutoff, the value of variable will be changed to 0, otherwise changed to 1.
#' 
#' Thanks (Misha Balyasin)[https://github.com/romatik] for great help.
#'
#' @param df data.frame
#' @param .vars specify the variables which to be cutoffs, for example, .vars = c("x", "y", "z")
#' @param cutoffs a list or vector containts cutoffs value for variables, 
#' this vector has the same length as .vars
#'
#' @return deprivation data.frame
#' @export 
#'
#' @examples
#' df <- tribble(
#'   ~id, ~x, ~y, ~z, ~g,
#'   #--|--|--|--|--
#'   "a", 13.1, 14, 4, 1,
#'   "b", 15.2, 7, 5, 0,
#'   "c", 12.5, 10, 1, 0,
#'   "d", 20, 11, 3, 1
#'   )
#' 
#' cutoffs <- c(
#'   x = 13,
#'   y = 12,
#'   z = 3
#' )
#' 
#' df %>%
#'   cutoffs_modify_at(.vars = c("x", "y", "z"), cutoffs = cutoffs)

cutoffs_modify_at <- function(df, .vars, cutoffs) {
  vars <- rlang::syms(.vars)
  quos <- purrr::map(vars, function(var) {
    rlang::quo(dplyr::if_else(!!var < cutoffs[[rlang::as_name(var)]], 1, 0))
  }) %>%
    purrr::set_names(nm = purrr::map_chr(vars, rlang::as_name))

  df %>%
    dplyr::mutate(!!!quos)
}




