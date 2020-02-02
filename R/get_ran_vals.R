#' @title Assess Random-Effect of Student Several Test Scores
#' @description From this tidy data frame, the random effects of the test results are assessed using lme4::lmer(score_post ~ 1 + (1 | score_pre)) funciton.
#' @param .data data.frame including school name, class name, score-pre and score-post of each student
#' @param .var_school school name.
#' @param .var_class class name.
#' @param .var_score_pre score-pre.
#' @param .var_score_post score-post, which is used as the response variable in mixed models
#' @param effects  specification for effects, which is either class or school
#' @export
#' @examples
#' get_ran_vals(df, school, class, score1, score2, "class")
#'
get_ran_vals <- function(.data,
                         .var_school,
                         .var_class,
                         .var_score_pre,
                         .var_score_post,
                         effects = "class") {

  stopifnot(
    effects %in% c("class", "school")
  )


  df_nest <- .data %>%
    dplyr::select(
     school      = {{.var_school}},
     class       = {{.var_class}},
     score_pre   = {{.var_score_pre}},
     score_post  = {{.var_score_post}}
    ) %>%
    tidyr::unite(school, class, col = "school_plus_class", sep = "_", remove = FALSE) %>%
    dplyr::mutate_at(vars(score_pre, score_post), as.numeric)


  if (effects == "class") {
    df_stat <- df_nest %>%
      dplyr::group_by(school_plus_class) %>%
      dplyr::summarise(
        num_of_students = n(),
        mean_score_pre = mean(score_pre),
        mean_score_post = mean(score_post)
      )

    result_class <-
      lme4::lmer(
        score_post ~ 1 + score_pre + (1 | school_plus_class),
        data = df_nest
      ) %>%
      broom.mixed::tidy(., effects = "ran_vals") %>%
      dplyr::select(level, estimate)


    result <- result_class %>%
      dplyr::left_join(df_stat, by = c("level" = "school_plus_class")) %>%
      dplyr::mutate_at(vars(estimate, mean_score_pre, mean_score_post),
        .funs = ~ round(., 2)
      )
  }

  if (effects == "school") {
    df_stat <- df_nest %>%
      dplyr::group_by(school) %>%
      dplyr::summarise(
        num_of_students = n(),
        mean_score_pre = mean(score_pre, na.rm = T),
        mean_score_post = mean(score_post, na.rm = T)
      )


    result_school <-
      lme4::lmer(
        score_post ~ 1 + score_pre + (1 | school),
        data = df_nest
      ) %>%
      broom.mixed::tidy(., effects = "ran_vals") %>%
      dplyr::select(level, estimate)

    result <- result_school %>%
      dplyr::left_join(df_stat, by = c("level" = "school")) %>%
      dplyr::mutate_at(vars(estimate, mean_score_pre, mean_score_post),
        .funs = ~ round(., 2)
      )
  }

  result
}
