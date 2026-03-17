#' Title
#'#' Connect to ADEM PostgreSQL database
#'
#' Establishes a secure database connection to the ADEM (Luxembourg employment agency)
#' PostgreSQL database using environment variables for credentials.
#'
#' This function creates a DBI connection using `RPostgres` by reading connection
#' parameters from environment variables. Set these in your `.Renviron` file:
#'
#' \itemize{
#'   \item `DB_NAME`: Database name
#'   \item `DB_HOST`: Database host
#'   \item `DB_USER`: Database username
#'   \item `DB_PASSWORD`: Database password
#'   \item `DB_PORT`: Database port (defaults to 5432 if unset)
#' }
#'
#' Always disconnect connections when finished using `DBI::dbDisconnect()`.
#'
#' @return A `DBIConnection` object representing an active database connection.
#'
#' @examples
#' \dontrun{
#'   # Ensure environment variables are set in .Renviron first
#'   con <- connect_db()
#'   DBI::dbListTables(con)
#'   DBI::dbDisconnect(con)
#' }
#'
#' @export
#'
#' @importFrom DBI dbConnect
#' @importFrom RPostgres Postgres
#' @md
connect_db <- function() {
  con <- DBI::dbConnect(
    RPostgres::Postgres(),
    dbname = Sys.getenv("DB_NAME"),
    host = Sys.getenv("DB_HOST"),
    user = Sys.getenv("DB_USER"),
    password = Sys.getenv("DB_PASSWORD"),
    port = 5432
  )
  return(con)
  DBI::dbDisconnect(con)
}

