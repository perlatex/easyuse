#' Calculate the rowwise sum for columns selected in data.frame
#'
#' @param .data data.frame
#' @param ... columns selected for rowwise `sum` or `mean` using `tidyselect` grammar
#' @param .name  the name of new column
#' @param na.rm  whether to delete the missing value, `TRUE` or `FALSE`
#'
#' @return
#' @export
#'
#' @examples
#' iris %>%
#'   add_row_sums(starts_with("Sepal"), .name = "Sepal.sum")
add_row_sums <- function(.data, ..., .name = "row_sum", na.rm = FALSE) {

  dots <- rlang::exprs(...)
  name <- rlang::sym(.name)
  cols <- dplyr::select(.data, !!!dots)
  out <- dplyr::mutate(.data, !!name := rowSums(cols, na.rm = na.rm))
  #out <- dplyr::mutate(.data, !!name := pmap_dbl(cols, sum, na.rm = na.rm))
  return(out)
}





#' Calculate the rowwise mean for columns selected in data.frame
#'
#' @param .data data.frame
#' @param ... columns selected for rowwise `sum` or `mean` using `tidyselect` grammar
#' @param .name  the name of new column
#' @param na.rm  whether to delete the missing value, `TRUE` or `FALSE`
#'
#' @return
#' @export
#'
#' @examples
#' iris %>%
#'   add_row_means(starts_with("Sepal"), .name = "Sepal.Mean")
add_row_means <- function(.data, ..., .name = "row_mean", na.rm = TRUE) {

  dots <- rlang::exprs(...)
  name <- rlang::sym(.name)
  cols <- dplyr::select(.data, !!!dots)
  out <- dplyr::mutate(.data, !!name := rowMeans(cols, na.rm = na.rm))
  return(out)
}






#' Calculate the rowwise weighted mean for columns selected in data.frame
#'
#' @param .data data.frame
#' @param ...  columns selected for rowwise `sum` or `mean` using `tidyselect` grammar
#' @param .weights weights corresponding columns selected in dataframe
#' @param .name  the name of new column
#' @param na.rm whether to delete the missing value, `TRUE` or `FALSE`
#'
#' @return
#' @export
#'
#' @examples
#' df <- tribble(
#'   ~id, ~x, ~y, ~z, ~g,
#'   #--|--|--|--|--
#'   "a", 13.1, 14, 4, 1,
#'   "b", 11.2, 7, 5, 0,
#'   "c", 12.5, 10, 1, 0,
#'   "d", 20, 11, 3, 1
#' )
#'
#'
#' weights <- c(
#'   x = 0.25,
#'   y = 0.25,
#'   z = 0.25,
#'   g = 0.25
#' )
#'
#' df %>% add_weighted_mean(x:g, .name = "wt_mean", .weights = weights)
add_weighted_mean <- function(.data, ..., .weights, .name = "weighted_mean", na.rm = TRUE) {

  sel <- tidyselect::vars_select(tbl_vars(.data), ...)
  vars <- rlang::syms(sel)


  quos <- purrr::map(vars, function(var) {
    rlang::quo( !!var * .weights[[rlang::as_name(var)]] )
  }) %>%
    purrr::set_names(nm = purrr::map_chr(vars, rlang::as_name))


  col <- .data %>%
    dplyr::transmute(!!!quos)

  .data %>%
    dplyr::mutate(!!rlang::sym(.name) := purrr::pmap_dbl(col, sum, na.rm = na.rm))


}




#' Calculate the rowwise total number for values is higher than column-average value
#'
#' @param .data data.frame
#' @param ... columns selected for rowwise `sum` or `mean` using `tidyselect` grammar
#' @param .name the name of new column
#' @param na.rm whether to delete the missing value, `TRUE` or `FALSE`
#'
#' @return
#' @export
#'
#' @examples
#' df <- tribble(
#'   ~id, ~x, ~y, ~z, ~g,
#'   #--|--|--|--|--
#'   "a", 13.1, 14, 4, 1,
#'   "b", 11.2, 7, 5, 0,
#'   "c", 12.5, 10, 1, 0,
#'   "d", 20, 11, 3, 1
#' )
#' df %>% add_above_avg_num(x:g)
add_above_avg_num <- function(.data, ..., .name = "above_avg_num", na.rm = TRUE) {

  sel <- tidyselect::vars_select(tbl_vars(.data), ...)
  vars <- rlang::syms(sel)


  quos <- purrr::map(vars, function(var) {
    rlang::quo( !!var >= mean(!!var) )
  }) %>%
    purrr::set_names(nm = purrr::map_chr(vars, rlang::as_name))


  col <- .data %>%
    dplyr::transmute(!!!quos)

  .data %>%
    dplyr::mutate(!!rlang::sym(.name) := purrr::pmap_dbl(col, sum, na.rm = na.rm))

}

