#' @title standardized a variable of dataframe according chopped condition
#' @description standardized a variable of dataframe after chop first pitch, and discard last pitch when last pitch was less than second-to-last within each group
#' @param .data data.frame, must contain `.var`, `.group` and `.pitch` variables
#' @param .var  specify the variables which to be standardized
#' @param .group group variable contained in .data
#' @param .pitch pitch variable contained in .data, each group have same pitch serial, for example, "p0, p10, p20, ... p100"
#'
#' @return standardized data.frame
#' @export
#'
#' @examples
#' library(tidyverse)
#' library(easyuse)
#' data(ChineseTones)
#'
#' d <- ChineseTones
#'
#' m <- d %>%
#'   group_by(type) %>%
#'   summarise_if(is.numeric, mean) %>%
#'   modify_at(vars(starts_with("p")), log10)
#'
#' ld <- m %>%
#'   pivot_longer(
#'     cols = starts_with("p"),
#'     names_to = "id",
#'     values_to = "value"
#'   ) %>%
#'   mutate(time = 1000 * time * seq(0, 1, by = 0.1))
#'
#' ld %>%
#'   chop_standard_at(.var = value, .group = type, .pitch = id)
chop_standard_at <- function(.data, .var, .group, .pitch) {

	df_longer <- .data %>%
		dplyr::select(
			value = {{.var}},
			group = {{.group}},
			   id = {{.pitch}}
		) %>%
		dplyr::ungroup()

	id_range <- df_longer %>%
		dplyr::distinct(id) %>%
		dplyr::pull(id)

	p_min <- id_range[1]
	p_mas <- id_range[length(id_range) - 1]
	p_max <- id_range[length(id_range)]

	std <- df_longer %>%
		dplyr::group_by(group) %>%
		dplyr::mutate(
			value = case_when(
				id == !!p_min ~ NA_real_,
				id != !!p_max ~ value,
				id == !!p_max & (value[length(value)] - value[length(value) - 1]) > 0 ~ value,
				TRUE ~ NA_real_
			)
		) %>%
		dplyr::ungroup() %>%
		dplyr::summarise(
			logmean = mean(value, na.rm = TRUE),
			logsd = sd(value, na.rm = TRUE)
		)

	# define standard subfunction
	standard <- function(x) {
		(x - std$logmean) / std$logsd
	}

	# return .data after standarded
	pitch <- .data %>%
		dplyr::mutate(value = standard(value))
	pitch
}




#' standardized a numeric vector using five step way
#' @description standardized formula is `(x - min(x)) * 5 / (max(x) - min(x))`
#' @param .x  a numeric vector
#' @return a standardized vector
#' @export
#'
#' @examples
#' mtcars %>%
#'   mutate(fstep = five_step_standard(mpg))
#
five_step_standard <- function(x) {
	(x - min(x)) * 5 / (max(x) - min(x))
}
