#' Title
#'#' Retrieve job vacancies with flexible filtering from ADEM database
#'
#' Queries the ADEM (Luxembourg employment agency) database to retrieve job
#' vacancies with optional filters for year, month, company, skill label, and
#' sector. Uses dynamic SQL conditions that only apply when parameters are
#' provided.
#'
#' @param con A \code{\link[DBI]{DBIConnection-class}} object, typically created
#'   by \code{\link[RPostgres]{dbConnect}(RPostgres::Postgres())}.
#' @param year \emph{Optional} 4-digit year (integer) to filter vacancies.
#'   Pass \code{NULL} (default) for all years.
#' @param month \emph{Optional} month number (1-12) to filter vacancies.
#'   Pass \code{NULL} (default) for all months.
#' @param company_id \emph{Optional} company ID (integer) to filter vacancies.
#'   Pass \code{NULL} (default) for all companies.
#' @param skill_label \emph{Optional} partial skill label for case-insensitive
#'   matching. Pass \code{NULL} (default) for all skills.
#' @param sector \emph{Optional} partial sector name for case-insensitive
#'   matching. Pass \code{NULL} (default) for all sectors.
#'
#' @return A data frame with columns:
#' \describe{
#'   \item{vacancy_id}{Unique vacancy identifier}
#'   \item{company_id}{Company identifier}
#'   \item{year,month}{Posting date components}
#'   \item{occupation}{Job title/occupation name}
#'   \item{name}{Company name (from \code{adem.companies})}
#'   \item{sector}{Company sector}
#'   \item{skill_label}{Associated skill label}
#' }
#'
#' @details
#' Uses \code{\link[glue]{glue_sql()}} for safe parameter interpolation with
#' optional filtering via the \code{WHERE 1=1} pattern. The query joins
#' \code{adem.vacancies}, \code{adem.companies}, \code{adem.vacancy_skills},
#' and \code{adem.skills} tables. \code{LEFT JOIN}s ensure vacancies appear
#' even without associated skills.
#'
#' @examples
#' \dontrun{
#' con <- connect_db()  # Your ADEM database connection
#'
#' # All recent vacancies
#' all_vacancies <- get_vacancies(con)
#'
#' # 2023 vacancies requiring communication skills
#' comm_jobs <- get_vacancies(
#'   con,
#'   year = 2023,
#'   skill_label = "communication"
#' )
#'
#' # IT sector jobs from specific company
#' it_company_jobs <- get_vacancies(
#'   con,
#'   company_id = 123,
#'   sector = "IT"
#' )
#'
#' # Multiple filters combined
#' developer_jobs <- get_vacancies(
#'   con,
#'   year = 2024,
#'   skill_label = "python",
#'   sector = "Technology"
#' )
#'
#' dbDisconnect(con)
#' }
#'
#' @md
#' @export
get_vacancies <- function(con, year = NULL, month = NULL,
                          company_id = NULL, skill_label = NULL, sector = NULL) {
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
      AND ({year}* IS NULL OR v.year = {year}*)
      AND ({month}* IS NULL OR v.month = {month}*)
      AND ({company_id}* IS NULL OR v.company_id = {company_id}*)
      AND ({skill_label}* IS NULL OR s.skill_label ILIKE '%' || {skill_label}* || '%')
      AND ({sector}* IS NULL OR c.sector ILIKE '%' || {sector}* || '%')
    ORDER BY v.year DESC, v.month DESC;
  ", year = year, month = month, company_id = company_id,
                  skill_label = skill_label, sector = sector, .con = con)

  DBI::dbGetQuery(con, sql)
}

#' @param con
#' @param skill_name
#'
#' @returns
#' @export
#'
#' @examples
# get_vacancies <- function(con, skill_name) {
#   sql <- glue_sql("
#         SELECT DISTINCT
#       v.vacancy_id, v.company_id, v.year, v.month, v.occupation,
#       c.name, c.sector,
#       s.skill_label
#     FROM adem.vacancies v
#     JOIN adem.companies c ON v.company_id = c.company_id
#     LEFT JOIN adem.vacancy_skills vs ON v.vacancy_id = vs.vacancy_id
#     LEFT JOIN adem.skills s ON vs.skill_id = s.skill_id
#     WHERE 1=1
#       AND (year IS NULL OR v.year = year)
#       AND (month IS NULL OR v.month = month)
#       AND (v.company_id IS NULL OR v.company_id = c.company_id)
#       AND (skill_label IS NULL OR s.skill_label ILIKE '%' || skill_label|| '%')
#       AND (sector IS NULL OR c.sector ILIKE '%' || sector || '%')
#     ORDER BY v.year DESC, v.month DESC;
#   ", .con = con)
#
#   DBI::dbGetQuery(con, sql)
# }
