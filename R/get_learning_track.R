#' Title
#'#' Get learning tracks (optionally filtered by skill)
#'
#' Returns learning tracks from `adem_learning_tracks`. If `skill_id` is provided,
#' filters to only tracks associated with that specific skill.
#'
#' @param con Database connection (DBI)
#' @param skill_id Character skill identifier (optional). Use exact `skill_id`
#'   from `adem_skills` table.
#'
#' @return Data frame with columns: `track_id`, `title`, `description`, `url`
#'
#' @examples
#' \dontrun{
#' con <- connect_db()
#'
#' # All learning tracks
#' get_learning_tracks(con)
#'
#' # Tracks for specific skill
#' get_learning_tracks(con, skill_id = "skill_r")
#'
#' dbDisconnect(con)
#' }
#'
#' @export
get_learning_tracks <- function(con, skill_id = NULL) {
  stopifnot(inherits(con, "DBIConnection"))

  sql <- glue_sql("
    SELECT DISTINCT
      lt.track_id,
      lt.title,
      lt.description,
      lt.url
    FROM adem_learning_tracks lt
    LEFT JOIN adem_skills s ON lt.skill_id = s.skill_id
    WHERE ({skill_id}* IS NULL OR s.skill_id = {skill_id}*)
    ORDER BY lt.title;
  ", skill_id = skill_id, .con = con)

  DBI::dbGetQuery(con, sql)
}

#' @param con
#' @param skill_id
#'
#' @returns
#' @export
#'
#' @examples
# get_learning_tracks <- function(con, skill_id = NULL) {
#   stopifnot(inherits(con, "DBIConnection"))
#
#   sql <- glue_sql("
#     SELECT DISTINCT
#   lt.track_id,
#   lt.title,
#   lt.description,
#   lt.url
# FROM adem_learning_tracks lt
# LEFT JOIN adem_skills s ON lt.track_id = s.skill_id  -- ou table de liaison si existe
# WHERE ({skill_id} IS NULL OR s.skill_id = {skill_id})
# ORDER BY lt.title;
#   ", skill_id = skill_id, .con = con)
#
#   DBI::dbGetQuery(con, sql)
# }
