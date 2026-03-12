con <- connect_db()
DBI:: dbGetQuery(con, "SELECT * From adem.companies limit 100;")
DBI::dbDisconnect(con)
