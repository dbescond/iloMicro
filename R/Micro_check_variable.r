#' helper to check dta columns and value present over times series
#'
#' Support for recoding variable, check \code{?car::Recode}, for labelling variable 
#'
#' @param my_pattern character for selection of dataset with pattern choose.
#' @param STORE TRUE or FALSE, if TRUE will combine all variables by dataset in a single file.
#' @keywords ILO, microdataset, processing
#' @examples
#' ## Not run:
#'
#'  # first consolidate all existing variables
#'	Micro_check_variable(STORE = TRUE)
#'
#'	# then look at variable pattern needed:
#'	Micro_check_variable(my_pattern = "job1_isci3")
#'
#'
#'
#'
#' ## End(**Not run**)

#' @export

Micro_check_variable <- function(my_pattern = NULL, STORE = FALSE){

if(is.null(my_pattern) & !STORE) return(readRDS(file = paste0(MY_PATH$micro, "/_Admin/CMD/Input/variables/_VARIABLE.rds")))



if(STORE){			
			
path <- paste0(MY_PATH$micro, "/_Admin/CMD/Input/variables/")

ref <- list.files(path)
ref <- ref[!ref %in% "_VARIABLE.rds"]


X <- as.list(ref) %>% 
			purrr::map_df(~ {
					load(paste0(path,.x)) 
					return(MY_workflow_freq)}) %>% 
			as_tibble
			
saveRDS(X, file = paste0(MY_PATH$micro, "/_Admin/CMD/Input/variables/_VARIABLE.rds"))

message("consolidation done !")

} else {


variable <- readRDS(file = paste0(MY_PATH$micro, "/_Admin/CMD/Input/variables/_VARIABLE.rds"))

if(is.null(my_pattern)){

return(variable)

} else {

return(variable %>% filter(str_detect(variables, my_pattern)))
	}

}
			
		
}



