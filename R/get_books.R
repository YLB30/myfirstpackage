
#' Title
#'#' Fetch book recommendations from ADEM database
#'
#' Retrieves up to 100 book recommendations from the `adem.book_recommendations`
#' table. Automatically manages database connection and cleanup.
#'
#' @return A data frame containing book recommendations (up to 100 rows).
#'   Exact columns depend on `adem.book_recommendations` table structure.
#'
#' @details
#' Establishes a database connection using `connect_db()`, executes the query,
#' and automatically disconnects. No parameters needed - always returns first
#' 100 recommendations.
#'
#' @examples
#' \dontrun{
#' # Get book recommendations
#' books <- get_book()
#' head(books)
#'
#' # View structure
#' str(books)
#' }
#'
#' @export
get_book <- function(){
  con <- connect_db()
  on.exit(dbDisconnect(con))  # Auto-cleanup même si erreur

  DBI::dbGetQuery(con, "SELECT * FROM adem.book_recommendations LIMIT 100;")
}

#' @returns
#' @export
#'
#' @examples
# get_book <- function(){
#   con <- connect_db()
#   DBI:: dbGetQuery(con, "SELECT * FROM adem.book_recommendations limit 100;")
#   DBI::dbDisconnect(con)
# }
