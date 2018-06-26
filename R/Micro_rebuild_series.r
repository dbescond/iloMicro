#' helper to work with micro data preprocessing workflow
#' 
#' From Master_x rebuild time series by copy readMe, do and fwk files, then run do file and get ILO.dta and FULL.dtaand 
#'
#' @param master_id character ie. '1' for working with master_1 and copy_1. Default = 'all', could be also '12' for master 1 and 2.
#' @param ref_area character for selection of country (iso3 code), mandatory.
#' @param source character for selection of source (as ilo micro spelling, ie. LFS), mandatory.
#' @param time , character, time use to rebuilt a specific dataset, default NULL, means all time will be takeinto account, option. 
#' @param clean, if TRUE delete files contained in the rebuild folder (not ORI repo), default TRUE.
#' @param timefrom  query to reduce time as from starting year timefrom.
#' @param timeto  query to reduce time as from ending year timeto.
#' @author ILO / bescond  
#' @keywords ILO, microdataset, processing
#' @examples
#' ## Not run:
#'
#' ## some example
#'
#' 	Micro_rebuild_series(master_id = '1', ref_area = 'PHL', source = 'LFS', time = '2015Q3')
#'
#'  Micro_rebuild_series(master_id = '1', ref_area = 'PHL', source = 'LFS') # Master 1
#'
#'  Micro_rebuild_series(master_id = '12', ref_area = 'PHL', source = 'LFS') # Master 1 and Master2
#'
#'  Micro_rebuild_series(ref_area = 'PHL', source = 'LFS') # all Masters
#'
#' ## End(**Not run**)
#' @export

Micro_rebuild_series <- function(
						master_id = 'all',
						ref_area ,
						source , 
						time = NULL, 
						clean = TRUE, 
						timefrom = NULL, 
						timeto = NULL
							){

	workflow <- iloMicro:::Micro_get_workflow( ref_area, source) %>% filter(str_detect(type, 'Copy|Master')) %>% 
				filter(!processing_status %in% c("Not Usable", "Not started"))							

	checkMaster <- workflow %>% filter(stringr::str_detect(type, 'Master_'))
					
	path <- paste0(ilo:::path$micro, ref_area, '/', source, '/')
	
	if(master_id %in% 'all') master_id <- paste0(stringr::str_sub(checkMaster$type, -1,-1), collapse = '')

	master_id <- stringr::str_split(master_id, pattern = '') %>% unlist
	

	
	for (M in 1:length(master_id))	{
	
	
		test_master <-  workflow %>% filter(stringr::str_sub(type, -1,-1) %in% master_id[M]) # %>% select(value = time) 
	
		master <-  test_master %>% filter(type %in% paste0('Master_', master_id[M])) 
		
		ori_pattern <- master$rebuild_pattern
		
		if(ori_pattern %in% NA) print(paste0('Error, Master_', master_id[M], ' has no pattern, check var "rebuild_pattern" in the workflow'))
		
		master <- master %>% select(time) %>% distinct(time) %>% t %>% as.character
	
		ref_folder <- test_master %>% select(value = time)  %>% mutate(myPath = paste0(path, value, '/'))%>% arrange(desc(value)) 

		master_file <- 	list.files(paste0(path, master)) %>% as_data_frame %>% filter(stringr::str_sub(value,-6,-1) %in% c('CMD.do','K.xlsx','E.docx')) %>% distinct(value)
		
		test <- master_file %>% filter(stringr:::str_detect(value, '_CMD.do')) %>% nrow
		
		if(test == 0) return(paste('...CMD.do file not available on ', paste0(path, master), 'folder'))		
		
		test <- master_file %>% filter(stringr:::str_detect(value, '_FWK.xlsx')) %>% nrow
		
		if(test == 0) return(paste('..._FWK.xlsx file not available on ', paste0(path, master), 'folder'))		
		
		test <- master_file %>% filter(stringr:::str_detect(value, 'README.docx')) %>% nrow
		
		if(test == 0) return(paste('...README.docx file not available on ', paste0(path, master), 'folder'))		
				
			
		ref_folder <- ref_folder %>% filter(!value %in% master)
	
		if(!is.null(time)) {ref_time <- time; ref_folder <- ref_folder %>% filter(value %in% ref_time)}
	
		if(!is.null(timefrom)){
			ref_time <- as.numeric(str_sub(timefrom,1,4)) 
			ref_folder <- ref_folder %>% filter(as.numeric(str_sub(value,1,4)) > ref_time - 1)
			rm(ref_time) 
		}
		if(!is.null(timeto)){
			ref_time <- as.numeric(str_sub(timeto,1,4)) 
			ref_folder <- ref_folder %>% filter(as.numeric(str_sub(value,1,4)) < ref_time + 1)
			rm(ref_time) 
		}
	
	
		if(nrow(ref_folder) == 0) {
					print(paste0('Master_', master_id[M], ' has no copy : OK'))} 
		else{
	
		for (fol in 1:nrow(ref_folder)){

		
			a <- try(	list.files(paste0(ref_folder$myPath[fol])) %>% 
							as_data_frame %>% 
							filter(!value %in% 'ORI') %>% 
							t %>% 
							as.character %>% 
							as.list %>% 
							plyr:::l_ply(	function(x){
												file.remove(paste0(ref_folder$myPath[fol], x))
												}
											)
					, silent = TRUE)

		
			file.copy(	paste0(path, master, '/', master_file$value[2]), 
						paste0(ref_folder$myPath[fol], gsub(master, ref_folder$value[fol], master_file$value[2])), overwrite = TRUE)
			file.copy(	paste0(path, master,'/', master_file$value[3]), 
						paste0(ref_folder$myPath[fol], gsub(master, ref_folder$value[fol], master_file$value[3])), overwrite = TRUE)

			
			doFile <- readLines(paste0(path, master,  '/', master_file$value[1])) 

			doFile[doFile %>% str_detect('global time')] <- gsub(master, ref_folder$value[fol], doFile[doFile %>% str_detect('global time')])


			check_imput_name <- list.files(paste0(path, ref_folder$value[fol],'/ORI' )) %>% as_data_frame %>% filter(str_detect(tolower(value), tolower(ori_pattern))) %>% filter(stringr::str_sub(tolower(value),-4,-1) %in% '.dta') %>% t %>% as.character 
		
			if(length(check_imput_name) == 1){
			
			test <- doFile[doFile %>% str_detect('global inputFile')] %>% length
			if(test ==0 ) print(paste0('global inputFile not found plse check spelling' ))
			doFile[doFile %>% str_detect('global inputFile')] <- paste0(stringr::str_sub(doFile[doFile %>% str_detect('global inputFile')], 1, 17), shQuote(check_imput_name)) }
			writeLines(doFile , con = paste0(ref_folder$myPath[fol], gsub(master, ref_folder$value[fol], master_file$value[1])), sep = '\n', useBytes = TRUE)


			setwd(ref_folder$myPath[fol])

			system(paste0('"C:\\Program Files (x86)\\Stata14\\Stata-64.exe" -e do "',paste0(ref_folder$myPath[fol], gsub(master, ref_folder$value[fol], master_file$value[1])),'"'))

			file.remove(paste0(ref_folder$myPath[fol], gsub(master, ref_folder$value[fol], master_file$value[1])) %>% str_replace('.do', '.log'))
	
			test_files <- list.files(getwd()) %>% as_data_frame %>% filter(stringr::str_sub(value,-8,  -1) %in% c('FULL.dta','_ILO.dta'))
			print(ref_folder$value[fol])
			if(nrow(test_files)< 2) {print(paste0(ref_area, ' / ', source, ' / ', ref_folder$value[fol], ' : Error dta files not produced, plse check .do file')); return(NULL)}

		}
	
		}
		print(paste0('Rebuilding Master_', master_id[M], ' done'))
	}

}


