#' @title German Breast Cancer Study (GBCS) Dataset
#' @description Gbcs dataset from Hosmer et al.
#'
#' @docType data
#'
#' @keywords datasets
#'
#' @references
#' Hosmer, D.W. and Lemeshow, S. and May, S. (2008)
#' Applied Survival Analysis: Regression Modeling of Time to Event Data: Second
#' Edition, John Wiley and Sons Inc., New York, NY
#'
#' @source \url{ftp://ftp.wiley.com/public/sci_tech_med/survival}
#' @format
#' \describe{
#' \item{id}{Identification Code}
#' \item{diagdate}{Date of diagnosis.}
#' \item{recdate}{Date of recurrence free survival.}
#' \item{deathdate}{Date of death.}
#' \item{age}{Age at diagnosis (years).}
#' \item{menopause}{Menopausal status. 1 = Yes, 0 = No.}
#' \item{hormone}{Hormone therapy. 1 = Yes. 0 = No.}
#' \item{size}{Tumor size (mm).}
#' \item{grade}{Tumor grade (1-3).}
#' \item{nodes}{Number of nodes.}
#' \item{prog_recp}{Number of progesterone receptors.}
#' \item{estrg_recp}{Number of estrogen receptors.}
#' \item{rectime}{Time to recurrence (days).}
#' \item{censrec}{Recurrence status. 1 = Recurrence. 0 = Censored.}
#' \item{survtime}{Time to death (days).}
#' \item{censdead}{Censoring status. 1 = Death. 0 = Censored.}
#' }
"gbcs"

#' @title German Breast Cancer Study Survival Task
#' @name mlr_tasks_gbcs
#' @description
#' A survival task for the gbcs data set.
#'
#' @format [R6::R6Class] inheriting from "TaskSurv".
#'
#' @section Construction:
#' ```
#' mlr3::mlr_tasks$get("gbcs")
#' mlr3::tsk("gbcs")
#' ```
#' @seealso
#' [Dictionary][mlr3misc::Dictionary] of [Tasks][mlr3::Task]: [mlr3::mlr_tasks]
#' @details
#' Column "id" and all date columns removed, as well as "rectime" and "censrec".
#' Target is time to death.
NULL
load_gbcs = function() {
  data = load_dataset("gbcs", "mlr3proba")
  data[, c("id", "diagdate", "recdate", "deathdate", "rectime", "censrec")] = NULL
  colnames(data)[9:10] = c("time", "status")
  b = as_data_backend(data)
  b$hash = "_mlr3_survival_gbcs_"
  TaskSurv$new("gbcs", b, time = "time", event = "status")
}
