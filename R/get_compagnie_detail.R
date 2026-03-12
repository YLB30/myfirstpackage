con <- connect_db()
DBI:: dbGetQuery(con, "SELECT
      c.company_id,
      c.name,
      c.sector,
      v.vacancy_id,
      v.company_id,
	  v.canton,
	  v.occupation,
      v.year,
      v.month
    FROM adem.companies c
    LEFT JOIN adem.vacancies v
      ON c.company_id = v.company_id
    WHERE c.company_id = v.company_id
    ORDER BY v.year DESC, v.month DESC NULLS LAST
    LIMIT 100;
")
DBI::dbDisconnect(con)
