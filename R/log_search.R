#'
#'#' Log a user search query
#'
#' Records a search query in `adem.search_logs` table. Returns `TRUE` on success,
#' `FALSE` otherwise. Uses `ON CONFLICT DO NOTHING` to handle duplicate searches
#' gracefully.
#'
#' @param con Database connection (DBI)
#' @param user_id Integer user ID from `adem_users`
#' @param query Character search query string
#'
#' @return Logical `TRUE` on successful insert, `FALSE` otherwise
#'
#' @examples
#' \dontrun{
#' con <- connect_db()
#' log_search(con, user_id = 1, query = "machine learning jobs")
#' dbDisconnect(con)
#' }
#'
#' @export
log_search <- function(con, user_id, query) {
  stopifnot(
    inherits(con, "DBIConnection"),
    is.numeric(user_id), length(user_id) == 1,
    is.character(query), length(query) == 1
  )

  sql <- glue_sql("
    INSERT INTO adem.search_logs (user_id, query, search_timestamp)
    VALUES ({user_id}, {query}, NOW())
    ON CONFLICT DO NOTHING
    RETURNING TRUE;
  ", .con = con)

  tryCatch({
    result <- DBI::dbGetQuery(con, sql)
    return(nrow(result) > 0)  # TRUE si INSERT a réussi
  }, error = function(e) {
    message("Log error: ", e$message)
    return(FALSE)
  })
}

#' @param con
#' @param user_id
#' @param query
#'
#' @returns
#' @export
#'
#' @examples
# log_search <- function(con, user_id, query) {
#   stopifnot(
#     inherits(con, "DBIConnection"),
#     is.numeric(user_id), length(user_id) == 1,
#     is.character(query), length(query) == 1
#   )
#
#   sql <- glue_sql("
#     INSERT INTO student_yves.search_logs (user_id, query, query_time)
#     VALUES ({user_id}, {query}, NOW())
#     ON CONFLICT DO NOTHING
#     RETURNING TRUE;
#   ", .con = con)
#
#   tryCatch({
#     result <- DBI::dbGetQuery(con, sql)
#     return(nrow(result) > 0)  # TRUE si INSERT a réussi
#   }, error = function(e) {
#     message("Log error: ", e$message)
#     return(FALSE)
#   })
# }
