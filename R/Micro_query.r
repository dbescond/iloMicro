#' helper to prepare query
#'
#' faster method to recode, order, add label of categorical variables
#'
#'
#' @param path dta or zip file path for loading ilo microdataset pre precessed, default = NULL.
#'
#' @author ILO / bescond
#' @keywords ILO, microdataset, processing, query
#' @examples
#' ## Not run:
#'
#' # process the all time series validate in the workflowflow
#'  Micro_process(ref_area = 'ZAF', source = 'QLFS', saveCSV = TRUE, validate = TRUE, time = '2016Q1', print_ind = TRUE)
#'
#'
#' # run the entire process for one country only (go for publication on ilostat)
#' Micro_process(validate = TRUE, consolidate = '123', PUB = TRUE, skip = 'EULFS', ref_area ='ZAF', source = 'LFS')
#'
#'
#'	# you could now rebuild, process 1 for a single time, then process 23
#'	# use mainly for adding oe dataset to a series yet publish
#'
#'	Micro_query_create(query = "MICRO_TEST")
#'
#'
#'
#'

#' ## End(**Not run**)


#' @export

Micro_query_create <- function(	query = NULL){


try({Micro_prepare_template(query)
message("framework template ready ! ")
}, silent = TRUE)


setwd(MY_PATH$query)

##### check name on backup
check_name <- list.files("./_Backup") %>% as_tibble

if(nrow(check_name %>% filter(value %in% query))> 0) {warning("This query name yet exist on the _Backup folder !!!"); return(NULL)}

##### check name on main folder
check_name <- list.files() %>% as_tibble

if(nrow(check_name %>% filter(value %in% query))> 0) {warning("This query name yet exist on the main folder !!!"); return (NULL)}

##### after validataion of the name, creation of therelevant folder


dir.create(paste0("./", query))
dir.create(paste0("./", query, "/do"))
dir.create(paste0("./", query, "/help"))
dir.create(paste0("./", query, "/log"))
dir.create(paste0("./", query, "/Input"))
dir.create(paste0("./", query, "/Output"))


message(paste0(query, " folder ready on ",getwd()))
message(paste0(""))
message("If indicators are correctly set up with the proper name you could start the processing using the following cmd : ")

message("will come soon !!! LOL ")

}