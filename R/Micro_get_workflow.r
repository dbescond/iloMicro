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

Micro_get_workflow <- function(ref_area = NULL, source = NULL, time = NULL, timefrom = NULL, timeto = NULL){


if(!is.null(ref_area)) 	ref_ref_area <- ref_area else ref_ref_area = NULL
if(!is.null(source) & ! class(source) %in% "function") 	ref_source <- source else ref_source = NULL
if(!is.null(time) & ! class(source) %in% "function") 		ref_time <- time  else ref_time = NULL
if(!is.null(timefrom)) 	ref_timefrom <- as.numeric(str_sub(timefrom,1,4)) else ref_timefrom = NULL
if(!is.null(timeto)) 	ref_timeto <- as.numeric(str_sub(timeto,1,4)) else ref_timeto = NULL
					


 readxl:::read_excel(paste0(MY_PATH$micro, '/_Admin/0_WorkFlow.xlsx'), sheet = 'file',	col_types = rep('text', 22))	%>% 	
 #readxl:::read_excel(paste0(MY_PATH$micro, '/_Admin/0_WorkFlow.xlsx'), sheet = 'file',	col_types = c(rep('text', 10), "date", rep('text', 4), "date", rep('text', 6)))	%>% 	
				mutate( processing_date_clean = ifelse(nchar(processing_date) < 10, processing_date, NA), 
						processing_date_clean = as.Date(as.integer(processing_date_clean), origin="1899-12-30") %>% as.character, 
						processing_date = ifelse(nchar(processing_date) < 10, processing_date_clean, processing_date), 
						processing_date_clean = NULL)  %>% 
				mutate( processing_date_clean = ifelse(nchar(origine_date) < 10, origine_date, NA), 
						processing_date_clean = as.Date(as.integer(processing_date_clean), origin="1899-12-30") %>% as.character, 
						origine_date = ifelse(nchar(origine_date) < 10, processing_date_clean, origine_date), 
						processing_date_clean = NULL)  %>% 
				mutate(origine_date = ifelse(str_sub(origine_date,1,3) %in% '202', paste0(str_sub(origine_date,9,10), ".", str_sub(origine_date,6,7), ".", str_sub(origine_date,1,4)), origine_date))  %>% 		
				filter(!ref_area %in% NA) %>%
				mutate(	file = paste0(ifelse(drive %in% "J", "J:/DPAU/MICRO/", "H:/DPAU/MICRO/"),  ref_area,'/', source, '/', time, '/', ref_area, '_', source, '_', time, '_ILO.dta'), 
						file = gsub('.dta_ILO.','_ILO.',file, fixed = TRUE),
						file = ifelse(str_detect(type, 'Copy|Master'), file, NA),
						path = paste0( ref_area,'/', source, '/', time)) %>% 
				arrange(ref_area) %>% 
				select(-contains('check_')) %>%
				{if(!is.null(ref_ref_area)) filter(., ref_area %in% ref_ref_area) else .} %>% 
				{if(!is.null(ref_source)) filter(., source %in% ref_source) else .} %>% 
				{if(!is.null(ref_timefrom)) filter(., as.numeric(str_sub(time,1,4)) > ref_timefrom - 1) else .} %>% 
				{if(!is.null(ref_timeto))   filter(., as.numeric(str_sub(time,1,4)) < ref_timeto   + 1) else .} %>% 
				{if(!is.null(ref_time)) filter(., time %in% ref_time) else .}
				
				
				
					
}











