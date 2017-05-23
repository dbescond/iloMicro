#' helper to work with micro data preprocessing workflow

#' @param country character vector for selection of country (iso3 code), default NULL, all.
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
#' ## get only one country one source:
#'
#'
#'
#' Micro_get_workflow(country = 'CRI', source = 'LFS')
#'
#' ## End(**Not run**)
#' @export
#' @rdname Micro_process
Micro_get_workflow <- function(country = NULL, source = NULL, time = NULL){

init <- getwd()
setwd(ilo:::path$micro)

ref_cou <- country 
ref_sou <- source
ref_tim <- time
options(warn = -1)
readxl:::read_excel('./_Admin/0_WorkFlow.xlsx', sheet = 'file',
									col_types = c('text', 'text', 'text', 'text', 'text', 'text', 'date', 'text', 'text', 'date', 'text', 'text', 'text', 'text', 'text', 'date', 'text', 'text', 'date', 'text', 'text', 'text'))	%>% 	# glimpse(workflow)
			filter(!country %in% NA) %>%
			mutate(	path = paste0(getwd(), '/', country,'/', source, '/', time), 
					file = paste0(getwd(), '/', country,'/', source, '/', time, '/', country, '_', source, '_', time, '_ILO.dta'), 
					file = gsub('.dta_ILO.','_ILO.',file, fixed = TRUE),
					pass = 'No', 
					pass = ifelse(processing_status %in% c('Published'), 'Published', pass),
					pass = ifelse(processing_status %in% c('Ready', 'Ready_Sample') & !validation_by %in% NA, 'Yes', pass), 
					processing_status = pass, 
					pass = NULL,
					path = paste0( country,'/', source, '/', time), 
					country = paste0(country), 
					Sent_MKMU = as.character(Sent_MKMU)) %>% arrange(country) %>% 
					{if(!is.null(ref_cou)) filter(., country %in% ref_cou) else .} %>% 
					{if(!is.null(ref_sou)) filter(., source %in% ref_sou) else .} %>% 
					{if(!is.null(ref_tim)) filter(., time %in% ref_tim) else .} %>% 
					{invisible(gc(reset = TRUE)); setwd(init);options(warn = 0); .} 
					
					
					
}

