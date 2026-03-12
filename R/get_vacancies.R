get_vacancies <- function(con, skill_name) {
  sql <- glue_sql("
        SELECT DISTINCT
      v.vacancy_id, v.company_id, v.year, v.month, v.occupation,
      c.name, c.sector,
      s.skill_label
    FROM adem.vacancies v
    JOIN adem.companies c ON v.company_id = c.company_id
    LEFT JOIN adem.vacancy_skills vs ON v.vacancy_id = vs.vacancy_id
    LEFT JOIN adem.skills s ON vs.skill_id = s.skill_id
    WHERE 1=1
      AND (year IS NULL OR v.year = year)
      AND (month IS NULL OR v.month = month)
      AND (v.company_id IS NULL OR v.company_id = c.company_id)
      AND (skill_label IS NULL OR s.skill_label ILIKE '%' || skill_label|| '%')
      AND (sector IS NULL OR c.sector ILIKE '%' || sector || '%')
    ORDER BY v.year DESC, v.month DESC;
  ", .con = con)

  DBI::dbGetQuery(con, sql)
}
