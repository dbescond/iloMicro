#' helper to work with micro data preprocessing workflow
#' 
#' From Master_x rebuild time series by copy readMe, do and fwk files, then run do file and get ILO.dta and FULL.dtaand 
#'
#' @param master_id ie. 1 for working with master_1 and copy_1. Default = 1.
#' @param country character for selection of country (iso3 code), mandatory.
#' @param source character for selection of source (as ilo micro spelling, ie. LFS), mandatory.
#' @param ori_pattern character pattern always found in the names of the original dta files, ie '_EnemduBDD', that will be detect in order to replace global input file on the do file. mandatory
#' @param time , character, time use to rebuilt a specific dataset, default NULL, means all time will be takeinto account, option. 
#' @param clean, if TRUE delete files contained in the rebuild folder (not ORI repo), default TRUE.
#' @author ILO / bescond  
#' @keywords ILO, microdataset, processing
#' @examples
#' ## Not run:
#'
#' ## some example
#' 	Micro_rebuild_series(master_id = 2, country = 'ARG', source = 'QLFS', ori_pattern = 'individual_')
#'
#'  Micro_rebuild_series(master_id = 1, country = 'BRA', source = 'QLFS', ori_pattern = 'pnadc_', time = '2015Q3')
#'
#'  Micro_rebuild_series(master_id = 2, country = 'ECU', source = 'LFS', ori_pattern = '_EnemduBDD', time = '2013Q4')
#'  Micro_rebuild_series(master_id = 1, country = 'GTM', source = 'LFS', ori_pattern = 'Personas', time = '2015Q4')
#'
#'  Micro_rebuild_series(master_id = 1, country = 'IDN', source = 'LFS', ori_pattern = 'IDN_', time = '2014Q3')
#'
#'  Micro_rebuild_series(master_id = 1, country = 'MEX', source = 'QLFS', ori_pattern = 'sdemt')
#'
#'  Micro_rebuild_series(master_id = 1, country = 'ZAF', source = 'LFS', ori_pattern = 'lfs')
#'
#' ## End(**Not run**)
#' @export

Micro_rebuild_series <- function(
						master_id = 1,
						country,
						source,
						ori_pattern , 
						time = NULL, 
						clean = TRUE
							){

	workflow <- iloMicro:::Micro_get_workflow( country, source)							

					
	path <- paste0(ilo:::path$micro, country, '/', source, '/')


	test_master <-  workflow %>% filter(str_detect(type, paste0('_', master_id))) # %>% select(value = time) 
	master <-  test_master %>% filter(str_detect(tolower(type), paste0('master_', master_id))) %>% select(time) %>% t %>% as.character
	ref_folder <- test_master %>% select(value = time)  %>% mutate(myPath = paste0(path, value, '/'))%>% arrange(desc(value)) 

	master_file <- 	list.files(paste0(path, master)) %>% as_data_frame %>% filter(str_sub(value,-6,-1) %in% c('CMD.do','K.xlsx','E.docx'))
		
	test <- master_file %>% filter(str_detect(value, '_CMD.do')) %>% nrow
	if(test == 0) return(paste('...CMD.do file not available on ', paste0(path, master), 'folder'))		
	test <- master_file %>% filter(str_detect(value, '_FWK.xlsx')) %>% nrow
	if(test == 0) return(paste('..._FWK.xlsx file not available on ', paste0(path, master), 'folder'))		
		test <- master_file %>% filter(str_detect(value, 'README.docx')) %>% nrow
	if(test == 0) return(paste('...README.docx file not available on ', paste0(path, master), 'folder'))		
				
			
	ref_folder <- ref_folder %>% filter(!value %in% master)
	
	if(!is.null(time)) {ref_time <- time; ref_folder <- ref_folder %>% filter(value %in% ref_time)}
	

	
	for (fol in 1:nrow(ref_folder)){

		
		try(list.files(paste0(ref_folder$myPath[fol])) %>% as_data_frame %>% filter(!value %in% 'ORI') %>% t %>% as.character %>% as.list %>% plyr:::l_ply(function(x){unlink(paste0(ref_folder$myPath[fol], x))}), silent = TRUE)

		
		file.copy(	paste0(path, master, '/', master_file$value[2]), 
					paste0(ref_folder$myPath[fol], gsub(master, ref_folder$value[fol], master_file$value[2])), overwrite = TRUE)
		file.copy(	paste0(path, master,'/', master_file$value[3]), 
					paste0(ref_folder$myPath[fol], gsub(master, ref_folder$value[fol], master_file$value[3])), overwrite = TRUE)

			
		doFile <- readLines(paste0(path, master,  '/', master_file$value[1])) 

		doFile[doFile %>% str_detect('global time')] <- gsub(master, ref_folder$value[fol], doFile[doFile %>% str_detect('global time')])



		check_imput_name <- list.files(paste0(path, ref_folder$value[fol],'/ORI' )) %>% as_data_frame %>% filter(str_detect(tolower(value), tolower(ori_pattern))) %>% filter(str_sub(tolower(value),-4,-1) %in% '.dta') %>% t %>% as.character 
		
		

#		doFile[doFile %>% str_detect('global inputFile')] <- gsub(ori_master_name, check_imput_name, doFile[doFile %>% str_detect('global inputFile')] )

		doFile[doFile %>% str_detect('global inputFile')] <- paste0(str_sub(doFile[doFile %>% str_detect('global inputFile')], 1, 17), shQuote(check_imput_name)) 
		writeLines(doFile , con = paste0(ref_folder$myPath[fol], gsub(master, ref_folder$value[fol], master_file$value[1])), sep = '\n', useBytes = TRUE)


		setwd(ref_folder$myPath[fol])

		system(paste0('"C:\\Program Files (x86)\\Stata14\\Stata-64.exe" -e do "',paste0(ref_folder$myPath[fol], gsub(master, ref_folder$value[fol], master_file$value[1])),'"'))

		unlink(paste0(ref_folder$myPath[fol], gsub(master, ref_folder$value[fol], master_file$value[1])) %>% str_replace('.do', '.log'))
	
		test_files <- list.files(getwd()) %>% as_data_frame %>% filter(str_sub(value,-8,  -1) %in% c('FULL.dta','_ILO.dta'))
		print(ref_folder$value[fol])
		if(nrow(test_files)< 2) {print('error dta files not produced, plse check .do file'); return(NULL)}

		
		
		
	}

}


