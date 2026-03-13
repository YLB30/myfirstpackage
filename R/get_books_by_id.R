#'
#'#' Get book recommendation by ID
#'
#' Retrieves a specific book recommendation from the `adem.book_recommendations`
#' table using its `book_id`. Automatically manages database connection and
#' cleanup.
#'
#' @param book_id Integer identifier for the book recommendation.
#'
#' @return A data frame with columns: `book_id`, `title`, `author`, `skill_id`.
#'   Returns empty data frame if book not found.
#'
#' @examples
#' \dontrun{
#' # Get book recommendation #123
#' book <- get_book_by_id(123)
#' print(book)
#' }
#'
#' @export
#'
#' @importFrom DBI dbGetQuery dbDisconnect
#' @importFrom glue glue_sql
#' get_book_by_id <- function(book_id) {
#'   con <- connect_db()
#'   on.exit(dbDisconnect(con))  # Auto-cleanup même si erreur
#'
#'   sql <- glue_sql("
#'     SELECT book_id, title, author, skill_id
#'     FROM adem.book_recommendations
#'     WHERE book_id = {book_id};
#'   ", .con = con)
#'
#'   result <- DBI::dbGetQuery(con, sql)
#'   return(result)
#' }
#'
#' #' @param book_id
#' #'
#' #' @returns
#' #' @export
#' #'
#' #' @examples
get_book_by_id <- function(book_id) {
  con <- connect_db()
  DBI:: dbGetQuery(con, "SELECT book_id,title,author,skill_id FROM adem.book_recommendations WHERE book_id={book_id} limit 100;")
  DBI::dbDisconnect(con)
}
