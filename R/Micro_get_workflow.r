#' helper to work with micro data preprocessing workflow

#' @param ref_area character vector for selection of country (iso3 code), default NULL, all.
#' @param source character vector for selection of source (as ilo micro spelling, ie. LFS), default NULL, all.
#' @param time character vector for selection of time, default NULL, all.
#' @author ILO / bescond  
#' @keywords ILO, microdataset, processing
#' @examples
#' ## Not run:
#' ## get all :
#'
#' Micro_get_workflow()
#'
#' ## get only one ref_area one source:
#'
#'
#'
#' Micro_get_workflow(ref_area = 'CRI', source = 'LFS')
#'
#' ## End(**Not run**)
#' @export

Micro_get_workflow <- function(ref_area = NULL, source = NULL, time = NULL){

init <- getwd()
setwd(ilo:::path$micro)

ref_cou <- ref_area 
ref_sou <- source
ref_tim <- time
options(warn = -1)
COLNAME <- readxl:::read_excel('./_Admin/0_WorkFlow.xlsx', sheet = 'file', n_max = 0) %>% colnames
COLTYPE <- rep('text', length(COLNAME)) 

COLTYPE[str_detect(COLNAME, '_date')] <- 'date'

readxl:::read_excel('./_Admin/0_WorkFlow.xlsx', sheet = 'file',	col_types = COLTYPE)	%>% 	# glimpse(workflow)
			filter(!ref_area %in% NA) %>%
			mutate(	path = paste0(getwd(), '/', ref_area,'/', source, '/', time), 
					file = paste0(getwd(), '/', ref_area,'/', source, '/', time, '/', ref_area, '_', source, '_', time, '_ILO.dta'), 
					file = gsub('.dta_ILO.','_ILO.',file, fixed = TRUE),
					file = ifelse(str_detect(type, 'Copy|Master'), file, NA),
					path = paste0( ref_area,'/', source, '/', time)) %>% 
			arrange(ref_area) %>% 
			{if(!is.null(ref_cou)) filter(., ref_area %in% ref_cou) else .} %>% 
			{if(!is.null(ref_sou)) filter(., source %in% ref_sou) else .} %>% 
			{if(!is.null(ref_tim)) filter(., time %in% ref_tim) else .} %>% 
			{invisible(gc(reset = TRUE)); setwd(init);options(warn = 0); .} 
					
					
					
}

