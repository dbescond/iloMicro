#' helper to prepare summary file on root repo
#'
#'
#' @author ILO / bescond  
#' @keywords ILO, microdataset, processing
#' @examples
#' ## Not run:
#' Micro_file_ready()
#'
#' ## End(**Not run**)

#' @export
Micro_create_ddi <- function(x, ref_ddi){
############### x <- iloMicro:::Micro_get_workflow() %>% filter(processing_status %in% c('Published', 'Ready')) ; ref_ddi <- 4 ; require(ilo) ; init_ilo() 

	init <- getwd()
	
	setwd(ilo:::path$micro)
	iloMicro:::Micro_load()

	init_path_ilo <- getwd()
						
	x <- x  %>% 
			mutate(	source_type_code = stringr::str_sub(source_title, 2,4), 
					source_type_code = ifelse(stringr::str_sub(source_type_code,-1,-1) %in% ':', stringr::str_sub(source_type_code,1,2), NA) ) %>% 
			left_join(select(ilo$code$cl_source, source_type_code = code, source_type = label_en), by = 'source_type_code') %>%
			select(ref_area, source, source_title, source_type, time, path, processing_status, processing_update = processing_date, origine_repo, origine_website, origine_date, comments, type, freq_code, level, on_ilostat) %>% 
			mutate(type = ifelse(processing_status %in% c('Published', 'Ready'), type, NA)) %>%
			switch_ilo(ref_area, keep) %>% 
			mutate(	origine_date = as.character(origine_date) %>% str_replace_all('-', fixed('/')), 
					processing_update = as.character(processing_update) %>% str_replace_all('-', fixed('/')), 
					comments = ifelse(processing_status %in% c('Published', 'Yes'), comments, NA)) %>% 
			{
			if(ref_ddi %in% c(1,3,5,7,9,11,13,15,17,19)) arrange(., desc(ref_area), source, desc(time)) 
			else arrange(., ref_area, source, time) 
			}%>% 
			rename(repo = source) %>% 
			separate(source_title, c('source', 'source.acronym', 'source.label'), sep = ' - ')	%>% 
			mutate(source = str_trim(source) %>% str_sub(2,-2)) %>%  
			left_join(filter(Ariane:::CODE_ORA$T_AGY_AGENCY, AGY_TYPE_CODE %in% 'NSO' ) %>% select(ref_area = AGY_COUNTRY_CODE, AGY_NAME1), by = 'ref_area') %>% 
			left_join(select(Ariane:::CODE_ORA$T_FRQ_FREQUENCY, freq_code = FRQ_CODE, label_freq = TEXT_EN), by = 'freq_code') %>% 
			mutate(
					test_time_label  = str_sub(time, 5,-1) %>% 
												plyr:::mapvalues(	from = c('' ,   'M01', 'M02', 'M03', 'M04', 'M05', 'M06', 'M07', 'M08', 'M09', 'M10', 'M11', 'M12', 'Q1',  'Q2',  'Q3',  'Q4'), 
																	to   = c(NA ,   'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December', 'First quarter',  'Second quarter',  'Third quarter',  'Fourth quarter'), warn_missing = TRUE)	,
					test_time = ifelse(str_sub(comments,1,2) %in%c('19', '20'), comments, str_sub(time,1,4)),
			 
					`Metadata Producter` = 'Department of Statistics - ILO - International Labour Organisation - Producer of DDI', 
					`Title` = paste0(source.label, ' ', test_time), 
					`Subtitle` = ifelse(str_sub(time,5,5) %in% c('Q', 'M'), test_time_label, NA),
					`Abbreviation` = paste0(source.acronym, ' ', test_time),
					`Study Type` = source_type, 
					`Kind of Data` =  ifelse(str_sub(source, 1,1) %in% 'A', 'Census', NA), 
					`Kind of Data` =  ifelse(str_sub(source, 1,1) %in% 'B', 'survey',`Kind of Data`), 
					`Unit of Analysis` =  ifelse(str_sub(source, 1,1) %in% c('A', 'B'), 'households/individuals', NA), 
					Country = ref_area.label,
					`Geographic Coverage` = ifelse(str_detect(tolower(source.label), 'urban'), 'Urban area', 'National coverage'),
					`Primary Investigator` = AGY_NAME1, 
					`Sampling Procedure` = as.character(NA),
					`Data reference period` = label_freq, 
					`ilo notes` =   as.character(NA), 
					combi = 0
			)				
						
	test <- x %>% filter(processing_status %in% c('Ready', 'Published')) %>% 
				select(path) %>% 
				mutate(file = paste0(path, '/', path %>% str_replace_all(fixed('/'), '_'), '_ILO.dta'), 
					   DOCfile = paste0(path, '/', path %>% str_replace_all(fixed('/'), '_'), '_ILO_README.docx')) %>% 
				mutate(n_records = 0, 
						new_n_records = 0,
						important_ILO_notes = as.character(NA), 
						var_available = as.character(NA), 
						last_change_data_ilo_dta = as.POSIXct(NA), 
						last_change_data_ilo_do = as.POSIXct(NA) 
						
						) %>% 
				separate(file, c('ref_area','source','time','dta'), sep = '/', remove = FALSE) %>% 
				mutate(dta = str_sub(dta, 1, -9))
	
	Disclamer_stata <- readLines(paste0(ilo:::path$micro, '_Admin/template/Disclamer_stata.txt'), warn = FALSE)
	
	origine_database <- read_csv(paste0(ilo:::path$micro, '_Admin/CMD/_check/activated.csv'), 
														col_type = cols(
																				path = col_character(),
																				status = col_character())
																		)  %>% 
						filter(tolower(status) %in% 'test') %>% slice(1) %>% .$path


	if(!dir.exists(origine_database)){
		dir.create(origine_database, showWarnings = FALSE, recursive = FALSE, mode = '0777')	
	}
	
	origine_database <- paste0(origine_database, '/')
	
	
	
	
	
	
	
	if(!dir.exists(paste0(origine_database, 'tmp'))){
		 dir.create(paste0(origine_database, 'tmp'), showWarnings = FALSE, recursive = FALSE, mode = '0777')
	}
	
	if(!dir.exists(paste0(origine_database, 'do'))){
		 dir.create(paste0(origine_database, 'do'), showWarnings = FALSE, recursive = FALSE, mode = '0777')
		 dir.create(paste0(origine_database, 'do/A'), showWarnings = FALSE, recursive = FALSE, mode = '0777')
		 dir.create(paste0(origine_database, 'do/Q'), showWarnings = FALSE, recursive = FALSE, mode = '0777')
		 dir.create(paste0(origine_database, 'do/M'), showWarnings = FALSE, recursive = FALSE, mode = '0777')
		 
	}
	
	if(!dir.exists(paste0(origine_database, 'dta'))){
		 dir.create(paste0(origine_database, 'dta'), showWarnings = FALSE, recursive = FALSE, mode = '0777')
		 dir.create(paste0(origine_database, 'dta/A'), showWarnings = FALSE, recursive = FALSE, mode = '0777')
		 dir.create(paste0(origine_database, 'dta/Q'), showWarnings = FALSE, recursive = FALSE, mode = '0777')
		 dir.create(paste0(origine_database, 'dta/M'), showWarnings = FALSE, recursive = FALSE, mode = '0777')
	}
	
	if(!dir.exists(paste0(origine_database, 'rds'))){
		 dir.create(paste0(origine_database, 'rds'), showWarnings = FALSE, recursive = FALSE, mode = '0777')
		 dir.create(paste0(origine_database, 'rds/A'), showWarnings = FALSE, recursive = FALSE, mode = '0777')
		 dir.create(paste0(origine_database, 'rds/Q'), showWarnings = FALSE, recursive = FALSE, mode = '0777')
		 dir.create(paste0(origine_database, 'rds/M'), showWarnings = FALSE, recursive = FALSE, mode = '0777')
	}	

	tocheck_ReadMe <- NULL		
	tocheck_Dta_Available <- NULL		
	tocheck_CMD_do <- NULL		
	
	test_cols <- colnames(test)
	
	
	test_newcheck <- ilo_tpl$Variable %>% filter(test %in% 'Yes')  %>% mutate(check = paste0(var_name, '_', code_level)) %>% .$check
	
	# keep in memory test to do for the dataset
	
	test_toDO <- ilo_tpl$Variable %>% filter(test %in% 'Yes') %>% select(var_name, code_level, scope)
	
	
	test <- 	bind_rows(test, test_newcheck %>% enframe(name = NULL) %>% count(value) %>% spread(value, n) %>% slice(-1)) %>% 
				select(!!c(test_cols, test_newcheck))	
	

	
	for (i in 1:nrow(test)){
	
		test_dta <- NULL
		
		ref_time <- str_sub(test$time[i], 5,5)
		if(ref_time %in% '') ref_time <- 'A'
		
		invisible(gc(reset = TRUE))
		invisible(gc(reset = TRUE))
		
		## copy dta as is
		
		if(file.exists(paste0(init_path_ilo, '/', test$file[i]))){		
			
			file.copy(	
				from = 	paste0(init_path_ilo, '/', test$file[i]) , 
				to = 	paste0(origine_database, 'dta/', ref_time, '/', test$dta[i], '.dta'), 
				recursive = FALSE, overwrite = TRUE, 
				copy.mode = TRUE, copy.date = TRUE)
				
			test$last_change_data_ilo_dta[i] <- file.info(paste0(init_path_ilo, '/', test$file[i]))$mtime  %>% as.character
		
		} else {	
		
			tocheck_Dta_Available <- c(tocheck_Dta_Available,paste0(i , ' --- ', test$file[i], ' ---   ERROR dta_not available') )

		} 
		
		## copy cmd do as is change last modification
		
		if(file.exists(paste0(init_path_ilo, '/', test$file[i] %>% str_replace('.dta', '_CMD.do')))){			
			
			doFile <- readLines(paste0(init_path_ilo, '/', test$file[i] %>% str_replace('.dta', '_CMD.do')),warn = FALSE ) 
			
			test$last_change_data_ilo_do[i] <- file.info(paste0(init_path_ilo, '/', test$file[i] %>% str_replace('.dta', '_CMD.do')))$mtime %>% as.character
			
			doFile[doFile %>% str_detect('Last updated:')] <- paste0('* Last updated: ' ,test$last_change_data_ilo_do[i] )
			doFile[doFile %>% str_detect('Author')] <- paste0('* Authors: ILO / Department of Statistics / DPAU' )
			doFile <- doFile[!doFile %>% str_detect('Starting Date:')] 
			

			doFile <- c(doFile[c(1:length(doFile))[doFile %>% str_detect('Author')]:length(doFile)], Disclamer_stata)
						
				
			writeLines(doFile , con = paste0(origine_database, 'do/', ref_time, '/', test$dta[i] , '.do'), sep = '\n', useBytes = TRUE)			
		
		} else {	
		
			tocheck_CMD_do <- c(tocheck_CMD_do,paste0(i , ' --- ', test$file[i] %>% str_replace('.dta', '_CMD.do'), ' ---   ERROR CMD_do_not available') )
		
		} 			
		
		test_dta <- NULL
		
		invisible(gc(reset = TRUE))
			
		try(test_dta <- haven::read_dta(test$file[i]) %>% 
						select(-contains('ilo_key'), -contains('ilo_time'), -contains('_job3'))   %>% 
						haven:::zap_labels()  , silent = TRUE) 
			
		if(!is.null(test_dta)){					
		
			ref <- paste0(colnames(test_dta), collapse = ' ')

			test$n_records[i] <-  nrow(test_dta)
						
			
			################################# add test and new variables here

		
			if(!str_detect(ref, 'ilo_age_ythadult')) {
	
				try(test_dta <- test_dta %>% mutate(	ilo_age_ythadult  		= ilo_age_aggregate 		%>% plyr:::mapvalues(from = c(2,3,4,5), 		to = c(1,2,2,2)			)), silent = TRUE) # age_ythadult 	
	
			}
			if(!str_detect(ref, 'ilo_job1_eco_sector')) {
	
				try(test_dta <- test_dta %>% mutate(	ilo_job1_eco_sector  	= ilo_job1_eco_aggregate 	%>% plyr:::mapvalues(from = c(1,2,3,4,5,6,7), 	to = c(1,2,2,2,3,3,4) 	)), silent = TRUE) # eco_sector 	
	
			}
			if(!str_detect(ref, 'ilo_preveco_sector')) {
	
				try(test_dta <- test_dta %>% mutate(	ilo_preveco_sector  	= ilo_preveco_aggregate		%>% plyr:::mapvalues(from = c(1,2,3,4,5,6,7), 	to = c(1,2,2,2,3,3,4) 	)), silent = TRUE) # eco_sector 	
	
			}
			if(!str_detect(ref, 'ilo_job1_eco_agnag')) {
	
				try(test_dta <- test_dta %>% mutate(	ilo_job1_eco_agnag  	= ilo_job1_eco_aggregate 	%>% plyr:::mapvalues(from = c(1,2,3,4,5,6,7), 	to = c(1,2,2,2,2,2,2) 	)), silent = TRUE) # eco_agnag 	 to add  warn_missing = FALSE
	
			}
			if(!str_detect(ref, 'ilo_age_ythbands')) {
	
				try(test_dta <- test_dta %>% mutate(	ilo_age_ythbands  		= ilo_age_5yrbands 			%>% plyr:::mapvalues(from = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14), to = c(NA,NA,NA,1,2,3,NA,NA,NA,NA,NA,NA,NA,NA)			)), silent = TRUE) # age_ythadult 	
	
			}
		
				
		invisible(gc(reset = TRUE))
		invisible(gc(reset = TRUE))
		
		
			# YTHSTAT for CLS or SWTS if !=

			if (str_detect(paste0(colnames(df), collapse = '') , 'ilo_age_ythbands')) {
	
				if(nrow(test_dta %>% filter(!ilo_age_5yrbands %in% 1:6)) %in% 0 ){
						
						test_dta <- test_dta %>%  select(-contains('ilo_age_5yrbands'), -contains('ilo_age_10yrbands'), contains('ilo_age_aggregate'), -contains('ilo_age_ythadult'))
					
					}
			}
		
		
		
		

					
		invisible(gc(reset = TRUE))
		invisible(gc(reset = TRUE))
		
			# compress datasets
			
			if(!str_detect(ref, 'ilo_sample_count')) {
	
				test_dta <- test_dta  %>% 
								group_by(.dots = colnames(test_dta)[!colnames(test_dta) %in% 'ilo_wgt']) %>% 
								summarise(ilo_sample_count = n(), ilo_wgt = sum(ilo_wgt)) %>% 
								ungroup
			}
			
			test_dta <- test_dta %>% filter(!ilo_wgt %in% NA)
			
			test$new_n_records[i] <-  sum(test_dta$ilo_sample_count)
			
			
			invisible(gc(reset = TRUE))
			invisible(gc(reset = TRUE))
		
			test_dta %>% saveRDS(., file = paste0(origine_database, 'rds/', ref_time, '/', test$dta[i], '.rds'))
	
			# reset colnames
			ref <- paste0(colnames(test_dta)[!colnames(test_dta) %in% c('ilo_sample_count','ilo_wgt')], collapse = ' ')
			
			
			
			################################# add tests
			
			ref_col <- ilo_tpl$Variable %>% distinct(var_name) %>% filter(var_name %in% colnames(test_dta)[!colnames(test_dta) %in% c('ilo_sample_count','ilo_wgt')]) %>% .$var_name
			
			ref <- paste0(ref_col , collapse = ' ')
			
			
			test$var_available[i] <- ref

			

			
			
			
			
			
			
			rm(test_dta)
		
			invisible(gc(reset = TRUE))
			invisible(gc(reset = TRUE))
			
			####################### add cmd
			
			cmd <- c(	'clear all', '#delimit ;' ,
						'set more off;',
						
						paste0('use "', paste0(origine_database, 'dta/', ref_time, '/', test$dta[i], '.dta'), '";'), 
						'capture compress;',
						'capture drop if ilo_wgt == .;',
						
						'capture gen ilo_age_ythadult=. ; capture replace ilo_age_ythadult=1 if inlist(ilo_age_aggregate,2); capture replace ilo_age_ythadult=2 if inlist(ilo_age_aggregate,3,4,5);',
						'capture lab def age_ythadult_lab 1 "15-24" 2 "25+"; capture lab val ilo_age_ythadult age_ythadult_lab ;',
						
						'capture gen ilo_job1_eco_sector=. ; capture replace ilo_job1_eco_sector=1 if inlist(ilo_job1_eco_aggregate,1); capture replace ilo_job1_eco_sector=2 if inlist(ilo_job1_eco_aggregate,2,3,4); capture replace ilo_job1_eco_sector=3 if inlist(ilo_job1_eco_aggregate,5,6); capture replace ilo_job1_eco_sector=4 if inlist(ilo_job1_eco_aggregate,7);',
						'capture lab def job1_eco_sector_lab 1 "1 - Agriculture" 2 "2 - Industry" 3 "3 - Services" 4 "4 - Not classifiable by economic activity"; capture lab val ilo_job1_eco_sector job1_eco_sector_lab ;',
						
						'capture gen ilo_preveco_sector=. ; capture replace ilo_preveco_sector=1 if inlist(ilo_preveco_aggregate,1); capture replace ilo_preveco_sector=2 if inlist(ilo_preveco_aggregate,2,3,4); capture replace ilo_preveco_sector=3 if inlist(ilo_preveco_aggregate,5,6); capture replace ilo_preveco_sector=4 if inlist(ilo_preveco_aggregate,7);',
						'capture lab def preveco_sector_lab 1 "1 - Agriculture" 2 "2 - Industry" 3 "3 - Services" 4 "4 - Not classifiable by economic activity"; capture lab val ilo_preveco_sector preveco_sector_lab ;',
						
		
						'capture gen ilo_age_ythbands=. ; capture replace ilo_age_ythbands=1 if inlist(ilo_age_5yrbands,4); capture replace ilo_age_ythbands=2 if inlist(ilo_age_5yrbands,5); capture replace ilo_age_ythbands=3 if inlist(ilo_age_5yrbands,6); ',
						'capture lab def age_ythbands_lab 1 "15-19" 2 "20-24" 3 "25-29"; capture lab val ilo_age_ythbands age_ythbands_lab ;',
										
						'capture gen ilo_job1_eco_agnag=. ; capture replace ilo_job1_eco_agnag=1 if inlist(ilo_job1_eco_sector,1); capture replace ilo_job1_eco_agnag=2 if inlist(ilo_job1_eco_sector,2,3,4,5,6,7); ',
						'capture lab def job1_eco_agnag_lab 1 "1 - Agriculture" 2 "2 - Non-agriculture"; capture lab val ilo_job1_eco_agnag job1_eco_agnag_lab ;',
						
						
						
						'capture drop ilo_key* ilo_time, ilo_job3*;', 
						'capture gen ilo_sample_count = 1 ;', 
						paste0('capture collapse (sum) ilo_wgt (count) ilo_sample_count, by(',ref,');'), 
						'compress;',
						paste0('capture gen ilo_ref_area = "', test$ref_area[i],'";'), 
						paste0('capture gen ilo_source = "', test$source[i],'";'),
						paste0('capture gen ilo_time = "', test$time[i],'";'),
						
						paste0('capture order ', paste('ilo_ref_area', 'ilo_source', 'ilo_time', 'ilo_wgt', 'ilo_sample_count', ref), ';'),
						paste0('capture order ilo_ref_area ;'),
						
						
						'capture lab var ilo_age_ythadult "Age (Youth and adults)" ;',
						'capture lab var ilo_ref_area "Country iso3 Alpha code" ;',
						'capture lab var ilo_source "Survey acronym" ;',
						'capture lab var ilo_time "Time period" ;',
						'capture lab var ilo_preveco_sector "Previous economic activity (Broad sector)" ;',
						'capture lab var ilo_job1_eco_sector "Economic activity (Broad sector)" ;',
						'capture lab var ilo_age_ythbands "Age (Youth age bands)" ;',
						'capture lab var ilo_job1_eco_agnag "Economic activity (Agriculture, Non-agriculture)" ;',
						'capture lab var ilo_wgt "Sample weight";',
						'capture lab var ilo_sample_count "Number of individual records";',
						
						
						
						'capture label data ""  ; ', 
						paste0('capture label data "ILO / Department of Statistics / Data Production Analysis Unit / ',Sys.time(),' / ilostat@ilo.org"  ; '), 
						'capture  notes _dta : add notes to the dataset ; ', 
						
						
						
						
						'capture notes ilo_sample_count : "Use to compress dataset" ; ',
						
						
						
						
						paste0('save "', paste0(origine_database, 'dta/', ref_time, '/', test$dta[i], '.dta'), '", replace;'),
						'#delimit cr', 
						'clear all')
			
		
						writeLines(cmd , con = paste0(origine_database, 'tmp/',  test$dta[i], '.do'), sep = '\n', useBytes = TRUE)

						setwd(paste0(origine_database, 'tmp/'))

						system(paste0('"C:\\Program Files (x86)\\Stata14\\Stata-64.exe" -e do "',paste0(origine_database, 'tmp/',  test$dta[i], '.do'),'"'))
										
						# file.remove( paste0(origine_database, 'tmp/',  test$dta[i], '.log') )
															
						setwd(init_path_ilo)
			



			
			
		
		}
		
		invisible(gc(reset = TRUE))
		
		
		if(file.exists(paste0(init_path_ilo, '/', test$DOCfile[i]))){			
		
			check <- textreadr::read_document( paste0(init_path_ilo, '/', test$DOCfile[i])) 
		
		
			check <- str_trim(check)
			check <- check[!check %in% NA]
			
		
			for(j in 2:length(check)){
			
			  if(str_detect(tolower(check[j]), 'ilo_')){
			  
				if(j == 2)  	check[j] <- paste0('<H1>', check[j], '</H1><BR><P>')
				
				if(j != 2)	check[j] <- paste0('</P><H1>', check[j], '</H1><BR><P>')
			  
			  } else {
				  check[j] <- paste0(check[j], '<BR>')
			  }	
			}
		  
			test$important_ILO_notes[i] <-  paste0(check[-1], collapse = '')
		

		} else {
			
			tocheck_ReadMe <- c(tocheck_ReadMe,paste0(i , ' --- ', test$DOCfile[i], ' ---   ERROR README.docx') )
			
		}



		print(paste0(i, ' / ', test$file[i]))
		
		
	}
	
			
		invisible(gc(reset = TRUE))
		invisible(gc(reset = TRUE))
		
	if(file.exists(paste0(ilo:::path$micro, '_Admin/CMD/_check/file_error/log_readMe_error_',ref_ddi,'.csv'))){
	
		file.remove(paste0(ilo:::path$micro, '_Admin/CMD/_check/file_error/log_readMe_error_',ref_ddi,'.csv'))
	}
	
	if(length(tocheck_ReadMe) > 0 ) {tocheck_ReadMe %>% enframe(name = NULL) %>% separate(value, c('id','path','error'), sep = fixed(' --- ')) %>% write_csv(paste0(ilo:::path$micro, '_Admin/CMD/_check/file_error/log_readMe_error_',ref_ddi,'.csv'), na = '')}
	
	rm(tocheck_ReadMe)
	
	if(file.exists(paste0(ilo:::path$micro, '/_Admin/CMD/_check/file_error/log_dta_available_error_',ref_ddi,'.csv'))){
	
		file.remove(paste0(ilo:::path$micro, '/_Admin/CMD/_check/file_error/log_dta_available_error_',ref_ddi,'.csv'))
	}
	
	if(length(tocheck_Dta_Available) > 0 ) {tocheck_Dta_Available %>% enframe(name = NULL) %>% separate(value, c('id','path','error'), sep = fixed(' --- ')) %>% write_csv(paste0(ilo:::path$micro, '_Admin/CMD/_check/file_error/dta_available',ref_ddi,'.csv'), na = '')}
	
	rm(tocheck_Dta_Available)
	
	
	if(file.exists(paste0(ilo:::path$micro, '/_Admin/CMD/_check/file_error/log_cmdDo_available_error_',ref_ddi,'.csv'))){
	
		file.remove(paste0(ilo:::path$micro, '/_Admin/CMD/_check/file_error/log_cmdDo_available_error_',ref_ddi,'.csv'))
	}
	
	if(length(tocheck_CMD_do) > 0 ) {tocheck_CMD_do %>% enframe(name = NULL) %>% separate(value, c('id','path','error'), sep = fixed(' --- ')) %>% write_csv(paste0(ilo:::path$micro, '_Admin/CMD/_check/file_error/log_cmdDo_available_error_',ref_ddi,'.csv'), na = '')}
	
	rm(tocheck_CMD_do)
		
	
	
	### test <- test %>% select( path, n_records,important_ILO_notes, var_available)
 
	x  <- x %>% select(-`ilo notes`,-ref_area, -source, -time) %>% left_join(test, by = 'path') 
	



		
		invisible(gc(reset = TRUE))
		invisible(gc(reset = TRUE))
		



	
	x %>% 	select(-`Sampling Procedure`) %>% 
				rename(	`Sampling Procedure` = n_records) %>% 
				#select(-n_records) %>% 
				mutate(important_ILO_notes = ifelse(important_ILO_notes %in% NA, '', important_ILO_notes)) %>%
				rename(`ilo notes` = important_ILO_notes) %>%
				# arrange(ref_area, source.acronym, desc(time)) %>%
				# select(combi, path, ref_area, source.ilo = source, source =  source.acronym, time, processing_status, processing_update,origine_date, Master = type, origine_date,origine_repo,  origine_website, `Metadata Producter`:`ilo notes`, var_available, on_ilostat)  %>% 
				mutate( origine_website = ifelse(origine_repo %in% 'Contact NSO', NA, origine_website)) %>% 
				mutate(Publish_DDI = on_ilostat %>% plyr:::mapvalues(c('Yes','DDI_only', 'No'), c('Yes','Yes', 'No'), warn_missing = FALSE)) %>% 
				mutate(freq_code = ifelse(str_sub(time,5,5) %in% '', 'A', str_sub(time,5,5))) %>%
				mutate(path_file = paste0(origine_database,'dta/', freq_code, '/', str_replace_all(path, '/', '_'), '.dta')) %>% 
				saveRDS(., file = paste0(origine_database, '/tmp_DDI_',ref_ddi , '.rds'))
	
	rm(x)
	
		invisible(gc(reset = TRUE))
		invisible(gc(reset = TRUE))
		setwd(init)
		


}


#' @export
Micro_combine_ddi <- function(nb = 6, combi = TRUE){


# nb = 6; combi = TRUE

	init_path_ilo <- getwd()
	require(ilo)
	init_ilo(-cl)
	iloMicro:::Micro_load()

	origine_database <- read_csv(paste0(ilo:::path$micro, '_Admin/CMD/_check/activated.csv'), 
														col_type = cols(
																				path = col_character(),
																				status = col_character())
																		)  %>% 
						filter(tolower(status) %in% 'test') %>% slice(1) %>% .$path



	X <- NULL
	for (i in 1:nb){

		if(file.exists(paste0(origine_database, '/tmp_DDI_',i , '.rds'))){
			X <- bind_rows(X, readRDS(paste0(origine_database, "/tmp_DDI_",i , '.rds')))
		}
		# file.remove(paste0(origine_database, '/tmp_DDI_',i , '.rds'))
	}

	#######################################################################################################################################
	#######################################################################################################################################
	######################################################## Module combine quarterly and monthly #########################################
	#######################################################################################################################################
	#######################################################################################################################################
	
	
	

	########### module create annual from Quarterly
	

	Bind_Annual <- X %>% 
				filter(!level %in% 'A') %>% 
				left_join(
						readxl::read_excel(file.path(paste0(ilo:::path$micro,'_Admin'),'0_WorkFlow.xlsx'), sheet= 'tools') %>% 
									filter(type %in% 'freq_code') %>% 
									select(freq_code = value, annual), 
								by = 'freq_code') %>% 
				mutate(year = str_sub(time, 1,4)) %>%
				group_by(ref_area, source, year) %>% 
				mutate(	annual_ref = n()) %>% 
				ungroup %>% 
				filter(annual == annual_ref) %>% 
				mutate( test = str_split(var_available, ' ') ) %>% 
				select(-annual_ref)
	

	
	ref <-  Bind_Annual %>% count(ref_area, source = source.acronym, year) %>% arrange(desc(ref_area))
	
	
	invisible(gc(reset = TRUE))
	invisible(gc(reset = TRUE))
	
	for (i in 1:nrow(ref)){
	
		
	
	
			## check files to bind
			ref_files <- Bind_Annual %>% filter(ref_area %in% ref$ref_area[i], source.acronym %in% ref$source[i], year %in% ref$year[i]) %>% mutate(stata_code = NA)
		
			ref_time <- str_sub(ref_files$time[1], 5,5)

			## they should have the same colnames (drop the rest)
			ref_colnames = NULL
		
			for (j in 1:unique(ref_files$annual)){
			

				if(j %in% 1) {  
					ref_files$stata_code[j] <- paste0(' clear all; use "', paste0(origine_database,  '/dta/', ref_time, '/',ref_files$ref_area[j], '_', ref_files$source.acronym[j], '_', ref_files$time[j],'.dta" ; \n'))
					}
				if(j != 1 & j %in% unique(ref_files$annual)) {  
					ref_files$stata_code[j] <- paste0('append using "', origine_database,  '/dta/', ref_time, '/',ref_files$ref_area[j], '_', ref_files$source.acronym[j], '_', ref_files$time[j],'.dta" ; replace ilo_wgt = ilo_wgt / ',unique(ref_files$annual), ' ; XXX_REPLACE ;compress ; save "' ,origine_database,  '/dta/', 'A', '/',ref_files$ref_area[j], '_', ref_files$source.acronym[j], '_', str_sub(ref_files$time[j],1,4),'.dta", replace ; clear all  ; #delimit cr \n' )
					
					} 
				if(j != 1 & j != unique(ref_files$annual)) {
					
						ref_files$stata_code[j] <- paste0('append using "', origine_database,  '/dta/', ref_time, '/',ref_files$ref_area[j], '_', ref_files$source.acronym[j], '_', ref_files$time[j],'.dta" ; \n' )
					
					}
						
			
				ref_colnames <- bind_rows(ref_colnames, eval(parse(text = ref_files$test[j])) %>% enframe(name = NULL) )
			
			
			}
		
			ref_colnames <- ref_colnames %>% count(value) %>% filter(n %in% unique(ref_files$annual)) %>% .$value
		
			
			ref_colnames <- ilo_tpl$Variable %>% distinct(var_name) %>% filter(var_name %in%  c('ilo_sample_count', 'ilo_wgt', ref_colnames)) %>% .$var_name
				
	
			ref_files <- ref_files %>% 
							mutate(stata_code = stata_code %>% 
													str_replace('XXX_REPLACE', 
																	paste0( 
																	'capture drop ilo_time ; capture gen ilo_time = "',unique(str_sub(ref_files$time, 1,4)),'";',
																		paste0('capture collapse (sum) ilo_wgt (sum) ilo_sample_count, by(',paste0(c('ilo_ref_area', 'ilo_source', 'ilo_time', ref_colnames[!ref_colnames %in% c('ilo_sample_count', 'ilo_wgt')]), collapse = ' ') ,');'), 
																		' capture order ', 
																		paste0(c('ilo_ref_area', 'ilo_source', 'ilo_time',ref_colnames), collapse = ' '), ';',
																		paste0('capture order ilo_ref_area ;'),
																		'capture lab var ilo_wgt "Sample weight";',
																		'capture lab var ilo_sample_count "Number of individual records";',
																		'#delimit cr', 
																		'clear all'
																	)
													)
													
									)
	

		
		## rebuild meta records for annual bind
			x_new <- ref_files   %>% 
							mutate(	origine_date = lubridate:::ymd(origine_date), 
									combi_path = paste0(time, collapse = ';')) %>% 
							mutate_at(c('new_n_records', 'Sampling Procedure'), sum, na.rm = TRUE) %>% 
							mutate_at(c('origine_date', 'last_change_data_ilo_do', 'last_change_data_ilo_dta'), max, na.rm = TRUE) %>% 
							mutate_at( colnames(ref_files)[!str_sub(colnames(ref_files),1,4) %in% 'ilo_'], first) %>% 
							mutate_at( colnames(ref_files)[str_sub(colnames(ref_files),1,4) %in% 'ilo_'], mean, na.rm = TRUE) %>% 
							mutate(		
								time = str_sub(time, 1,4), 
								level = 'A', 
								path = paste0(ref_area, '/', source.acronym, '/', time), 
								type = gsub('Master', 'Copy', type), 
								combi = 1, 
								Subtitle = as.character(NA)) %>% 
							slice(1)
		
		
		# rm(nrecords, ref_meta)
		
		## load rds files	
		
		
		
		test_dta <- as.list(paste0(ref_files$ref_area, '_', ref_files$source.acronym, '_', ref_files$time)) %>% 
						plyr:::ldply(function(x) {X <- readRDS(paste0(origine_database,  '/rds/', ref_time, '/', x,'.rds'));  return(X)})  %>% 
				 as.tbl
		
		 
		
		test_dta <- test_dta[,colnames(test_dta) %in% ref_colnames] 
		
		
		test_dta <- test_dta	%>% 
						group_by(.dots = colnames(test_dta)[!colnames(test_dta) %in% c('ilo_wgt', 'ilo_sample_count')]) %>% 
						summarise(ilo_sample_count = sum(ilo_sample_count), ilo_wgt = sum(ilo_wgt)) %>% 
						ungroup

		invisible(gc(reset = TRUE))
		invisible(gc(reset = TRUE))

		
		x_new$var_available <- paste0(ref_colnames, collapse = ' ') 
			
		
		test_dta %>% saveRDS(., file = paste0(origine_database, '/rds/', 'A', '/', x_new$ref_area, '_', x_new$source.acronym, '_', x_new$time, '.rds'))
	

		X <- bind_rows(X, x_new %>% mutate(origine_date = paste0(str_sub(origine_date,1,4),'/', str_sub(origine_date,6,7), '/', str_sub(origine_date,9,10))))
		

		if(combi) {

			writeLines(c('#delimit ;', ref_files$stata_code ) , con = paste0(origine_database, '/tmp/',  x_new$ref_area, '_', x_new$source.acronym, '_', x_new$time , '.do'), sep = '\n', useBytes = TRUE)

			setwd(paste0(origine_database, '/tmp/'))

			system(paste0('"C:\\Program Files (x86)\\Stata14\\Stata-64.exe" -e do "',paste0(origine_database, '/tmp/',  x_new$ref_area, '_', x_new$source.acronym, '_', x_new$time , '.do'),'"'))
																	
			setwd(init_path_ilo)
				
		}
		
		rm(ref_colnames, x_new, test_dta)
		
		invisible(gc(reset = TRUE))
		invisible(gc(reset = TRUE))
		
		
		
		
		
		
	}
	
	
					
	



	
	
	
	
	#######################################################################################################################################
	#######################################################################################################################################
	######################################################## Module combine quarterly and monthly #########################################
	#######################################################################################################################################
	#######################################################################################################################################
		
	
	
	
	
	
	
	
	
	
	X <- X  %>% arrange(ref_area, source, desc(time))

	X %>% select(-test) %>% distinct()%>% readr:::write_excel_csv(paste0(origine_database, '/MICRO_WWDDI.csv'), na = '')
	 
	X %>% 
			#mutate(Publish_DDI = ifelse(origine_repo %in% 'Contact NSO', 'No', Publish_DDI)) %>% 
			select(	path, ref_area, source, time, Publish_DDI, combi, combi_path, processing_status, processing_update = last_change_data_ilo_dta, origine_date, Master = type, origine_repo, origine_website, `Metadata Producter`,
					Title, Subtitle, Abbreviation, `Study Type`, `Kind of Data`, `Unit of Analysis`,  Country, `Geographic Coverage`,
					`Primary Investigator`, `Sampling Procedure`,  `Data reference period`,  `ilo notes`, var_available, on_ilostat) %>% 
			mutate(
					processing_update = paste0(str_sub(processing_update,1,4),'/', str_sub(processing_update,6,7), '/', str_sub(processing_update,9,10)), 
					origine_date = paste0( str_sub(origine_date,1,4),'/', str_sub(origine_date,6,7), '/', str_sub(origine_date,9,10))) %>% 
				
			bind_rows(
				iloMicro:::Micro_get_workflow() %>% filter(!processing_status %in% c('Published', 'Ready')) %>%
				mutate(	source_type_code = stringr::str_sub(source_title, 2,4), 
						source_type_code = ifelse(stringr::str_sub(source_type_code,-1,-1) %in% ':', stringr::str_sub(source_type_code,1,2), NA) ) %>% 
				left_join(select(ilo$code$cl_source, source_type_code = code, source_type = label_en), by = 'source_type_code') %>%
				select(ref_area, source, source_title, source_type, time, path, processing_status, processing_update = processing_date, origine_repo, origine_website, origine_date, comments, type, freq_code, level, on_ilostat) %>% 
				mutate(type = ifelse(processing_status %in% c('Published', 'Ready'), type, NA)) %>%
				switch_ilo(ref_area, keep) %>% 
				select(ref_area, source, time, processing_status, Master = type , origine_repo, origine_website, origine_date) %>% 
				mutate(origine_website = ifelse(origine_repo %in% 'Contact NSO', NA, origine_website)) %>% 
				mutate(origine_website = ifelse(!str_detect(origine_repo, 'WEB'), NA, origine_website)) %>% 
				mutate(	origine_date = paste0(str_sub(origine_date,1,4),'/', str_sub(origine_date,6,7), '/', str_sub(origine_date,9,10))) %>% 
				mutate(Publish_DDI = 'No') %>% 
				mutate(path = paste(ref_area, source, time, sep = '/'))
			) %>% 
			arrange(ref_area, source, desc(time)) %>% 
			filter(str_sub(time,5,5) %in% '') %>% #  select(-`ilo notes`) %>% 
			readr:::write_excel_csv("K:/MICRO_API/MICRO_WWDDI_NEW.csv", na = '')
	
	
	# require(openxlsx)
	
	# class(DDI_MU$path) <- 'hyperlink'
	

	# wb <- createWorkbook()
	# options('openxlsx.borderStyle' = 'thin')
	# options('openxlsx.borderColour' = '#4F81BD')
	# Add worksheets
	# addWorksheet(wb, 'DDI_A')
	# addWorksheet(wb, 'DDI_Q')
	# addWorksheet(wb, 'DDI_M')
	# addFilter(wb, 1, row = 1, cols = 1:ncol(DDI_MU))
	# writeData(wb, 'DDI_A', as.data.frame(DDI_MU %>% filter(str_sub(time,5,5) %in% '')))
	
	# addFilter(wb, 2, row = 1, cols = 1:ncol(DDI_MU))
	# writeData(wb, 'DDI_Q', as.data.frame(DDI_MU %>% filter(str_sub(time,5,5) %in% 'Q')))
	
	# addFilter(wb, 3, row = 1, cols = 1:ncol(DDI_MU))
	# writeData(wb, 'DDI_M', as.data.frame(DDI_MU %>% filter(str_sub(time,5,5) %in% 'M')))
	
	# saveWorkbook(wb, file = paste0(ilo:::path$micro, 'MICRO_WWDDI_new.xlsx'), overwrite = TRUE)
	
	
	
	# rm( wb, X, nb, DDI_MU)	
		invisible(gc(reset = TRUE))
		invisible(gc(reset = TRUE))
		


}



			
			