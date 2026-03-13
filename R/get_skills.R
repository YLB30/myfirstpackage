#' Title
#'#' Retrieve skills from ADEM database
#'
#' Fetches up to 100 skills from the `adem.skills` table. Automatically
#' establishes and closes the database connection.
#'
#' @return A data frame containing skills data (up to 100 rows).
#'
#' @details
#' This function handles the full database lifecycle: connection, query execution,
#' and disconnection. Uses the `connect_db()` function from this package for
#' database connectivity.
#'
#' @examples
#' \dontrun{
#' # Fetch first 100 skills
#' skills <- get_skill()
#'
#' # View structure
#' str(skills)
#'
#' # Show first few skills
#' head(skills)
#' }
#'
#' @export
get_skill <- function(){
  con <- connect_db()
  on.exit(dbDisconnect(con))  # Improved: auto-disconnect even on error

  DBI::dbGetQuery(con, "SELECT * FROM adem.skills LIMIT 100;")
}

#' @returns
#' @export
#'
#' @examples
# get_skill <- function(){
#   con <- connect_db()
#   DBI:: dbGetQuery(con, "SELECT * From adem.skills limit 100;")
#   DBI::dbDisconnect(con)
# }





