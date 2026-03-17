#' Title
#'#' Retrieve companies and their recent vacancies
#'
#' Fetches up to 100 companies with their most recent vacancies from the ADEM
#' database. Each company row includes associated vacancy details (if any).
#'
#' @return A data frame with columns:
#' \describe{
#'   \item{company_id}{Unique company identifier}
#'   \item{name}{Company name}
#'   \item{sector}{Company sector}
#'   \item{vacancy_id}{Vacancy identifier (NULL if no vacancies)}
#'   \item{canton}{Vacancy location canton (NULL if no vacancies)}
#'   \item{occupation}{Job title/occupation (NULL if no vacancies)}
#'   \item{year, month}{Vacancy posting date (NULL if no vacancies)}
#' }
#'
#' @details
#' Automatically manages database connection using \code{connect_db()}.
#' Uses \code{LEFT JOIN} to include companies without vacancies, but
#' \code{WHERE c.company_id = v.company_id} effectively filters to companies
#' **with at least one vacancy**. Results ordered by most recent vacancies first.
#' Limited to 100 rows for performance.
#'
#' @examples
#' \dontrun{
#' # Get companies with their vacancies
#' companies <- get_companie()
#'
#' # View structure
#' str(companies)
#'
#' # Summary by sector
#' table(companies$sector)
#' }
#'
#' @export
# @importFrom DBI dbGetQuery dbDisconnect
#' @returns
#' @export
#'
#' @examples
get_companie <- function() {
  con <- connect_db()
  on.exit(dbDisconnect(con))  # IMPROVED: auto-disconnect

  DBI::dbGetQuery(con, "SELECT
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
    LIMIT 100;")
  DBI::dbDisconnect(con)
}



