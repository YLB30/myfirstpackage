get_vacancies_by_skill <- function(con, skill_name) {
  sql <- glue_sql("
    SELECT DISTINCT v.vacancy_id,
           v.year,
           v.month,
           s.skill_label
    FROM adem.vacancies AS v
    JOIN adem.vacancy_skills AS vs
      ON v.vacancy_id = vs.vacancy_id
    JOIN adem.skills AS s
      ON vs.skill_id = s.skill_id
    WHERE s.skill_label = {skill_name}
    ORDER BY v.year DESC, v.month DESC;
  ", .con = con)

  DBI::dbGetQuery(con, sql)
}
