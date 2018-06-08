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
Micro_file_ready <- function(DDI = FALSE){

	workflow <- Micro_get_workflow()
	init <- getwd()
	setwd(ilo:::path$micro)
	require(openxlsx)
	require(ilo)
	init_ilo(-cl)
	
	
	read <- workflow  %>% mutate(	source_type_code = stringr::str_sub(source_title, 2,4), 
									source_type_code = ifelse(stringr::str_sub(source_type_code,-1,-1) %in% ':', stringr::str_sub(source_type_code,1,2), NA) ) %>% 
									left_join(select(ilo$code$cl_source, source_type_code = code, source_type = label_en), by = "source_type_code") %>%
						select(ref_area, source, source_title, source_type, time, path, processing_status, processing_update = processing_date, origine_repo, origine_website, origine_date, comments, type, freq_code, on_ilostat) %>% 
						mutate(type = ifelse(processing_status %in% c("Published", "Ready"), type, NA))
	
	rm(workflow)
						
	res <- read %>% 
			group_by(ref_area, source, source_title, source_type) %>% 
			mutate(last_year = max(unique(stringr::str_sub(time,1,4)))) %>% 
			ungroup %>%
			mutate(processing_status = ifelse(processing_status %in% c("Published", "Ready"), processing_status, 'No')) %>% 
			count(ref_area, source, source_title, source_type, processing_status, origine_repo, last_year) %>% 
			ungroup %>% 
			spread(processing_status, n) 
			
			
			res$Total <- rowSums(res[, 7:9], na.rm = TRUE)  
			res$Ready <- rowSums(res[, 8:9], na.rm = TRUE)  
			
	res <- res %>% 
			mutate(	Ready = ifelse(Ready %in% 0, NA, Ready) ) %>% 
			select(	ref_area, 	
					source,	
					source_title,	
					source_type,
					origine_repo,	
					last_year,	
					Total,  
					Ready, 					
					Published)
	




	
					
	read <- read %>% 
			switch_ilo(ref_area, keep) %>% 
			mutate(	origine_date = as.character(origine_date) %>% str_replace_all('-', fixed('/')), 
					processing_update = as.character(processing_update) %>% str_replace_all('-', fixed('/')), 
					comments = ifelse(processing_status %in% c('Published', 'Yes'), comments, NA)) %>% 
			arrange(ref_area, source, desc(time)) %>% 
			as.data.frame 

	readworkflow <- read %>% select(-on_ilostat)


	
	
	class(read$ref_area) <- "hyperlink"
	class(read$path) <- "hyperlink"
	
			
	res <- res %>% 	switch_ilo(ref_area, keep) %>% 
				mutate(last_year = as.numeric(last_year),
						Ready = as.numeric(Ready), 
						Published = as.numeric(Published), 
						Total = as.numeric(Total) )


	new <- data_frame(	ref_area = nrow(res %>% count(ref_area)) %>% as.character, 
					source = nrow(res) %>% as.character, 
					Ready = sum(res$Ready, na.rm = TRUE),  
					Published = sum(res$Published, na.rm = TRUE),  
					Total = sum(res$Total, na.rm = TRUE)) 
					
	res <- bind_rows(res, new) %>% mutate(last_year = as.numeric(last_year))
	class(res$ref_area) <- "hyperlink"

	wb <- createWorkbook()
	options("openxlsx.borderStyle" = "thin")
	options("openxlsx.borderColour" = "#4F81BD")
	## Add worksheets
	addWorksheet(wb, "workflow")
	addWorksheet(wb, "summary")
	addFilter(wb, 1, row = 1, cols = 1:ncol(readworkflow))
	writeData(wb, "workflow", readworkflow)
	addFilter(wb, 2, row = 1, cols = 1:ncol(res))
	writeData(wb, "summary", res)
	saveWorkbook(wb, file = "MICRO_Workflow.xlsx", overwrite = TRUE)
	rm( wb, res)	
	
if(DDI){
	
	x <- create_ddi(as.tbl(read) %>% filter(processing_status %in% c("Published", "Ready"), on_ilostat %in% c('Yes','DDI_only')) %>% select(-on_ilostat))
	wb <- createWorkbook()
	
	addWorksheet(wb, "DDI")
	

	y <- 1 %>% as_data_frame %>% 
			mutate(
			ILO_meta = 'ILO_meta',
			YY02 = '',
			YY03 = '',
			YY04 = '',
			YY05 = '',
			YY06 = '',
			YY07 = '',
			YY08 = '',
			YY09 = '',
			YY10 = '',
			`Metadata Preparation` = 'Metadata Preparation', 
			`Identification` = 'Identification', 
			`XXX4` = '', 
			`XXX5` = '', 
			`XXX6` ='', 
			`Overview` =  'Overview', 
			`XXX9` =  '', 
			Coverage = 'Coverage', 
			`XXX10` = '', 
			`Producers and Sponsors` = 'Producers and Sponsors', 
			`Sampling` = 'Sampling',
			`Data Collection` = 'Data Collection', 
			`ilo notes` = 'ilo notes',
			`XXX11` ='variable available', 
			) %>% select(-value)
	
	writeData(wb,startRow = 1, colNames = FALSE,  "DDI", y)
	writeData(wb, startRow = 2, "DDI", x)

	saveWorkbook(wb, file = "MICRO_WWDDI.xlsx", overwrite = TRUE)
	rm(DDI, wb)	
	
	
	}
	## Save workbook to working directory
rm(read)

	invisible(gc(reset = TRUE))
	setwd(init)

	
}

#' @export
Micro_backup_cmd <- function(wd){


master <- Micro_get_workflow() %>% 
				filter(str_detect(type, 'Master')) %>% 
				select(ref_area, source, time) %>% 
				mutate(init = paste0(ilo:::path$micro, ref_area, '/', source, '/', time, '/', ref_area, '_', source, '_', time, '_ILO_CMD.do'), 
					   backup = paste0(wd, 'iloMicro/inst/doc/do/', ref_area, '_', source, '_', time, '_ILO_CMD.do'))
				
	for (i in 1:nrow(master)){
		try(file.copy(from = master$init[i], to = master$backup[i],copy.mode = TRUE, copy.date = TRUE), silent = TRUE)
	}
	
	file.copy(from = paste0(ilo:::path$micro, '_Admin/0_WorkFlow.xlsx'), to = paste0(wd, 'iloMicro/inst/doc/0_WorkFlow.xlsx'),copy.mode = TRUE, copy.date = TRUE, overwrite  = TRUE)
	
}


create_ddi <- function(x){
############### sample count


	x <- x %>% rename(repo = source) %>% separate(source_title, c('source', 'source.acronym', 'source.label'), sep = ' - ')	%>% 
			mutate(source = str_trim(source) %>% str_sub(2,-2)) %>%  
			left_join(filter(Ariane:::CODE_ORA$T_AGY_AGENCY, AGY_TYPE_CODE %in% 'NSO' ) %>% select(ref_area = AGY_COUNTRY_CODE, AGY_NAME1), by = "ref_area") %>% 
			left_join(select(Ariane:::CODE_ORA$T_FRQ_FREQUENCY, freq_code = FRQ_CODE, label_freq = TEXT_EN), by = "freq_code") %>% 
			mutate(
			test_time_label  = str_sub(time, 5,-1) %>% 
						plyr:::mapvalues(	from = c("" ,   "M01", "M02", "M03", "M04", "M05", "M06", "M07", "M08", "M09", "M10", "M11", "M12", "Q1",  "Q2",  "Q3",  "Q4"), 
											to   = c(NA ,   "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December", "First quarter",  "Second quarter",  "Third quarter",  "Fourth quarter")),
			test_time = ifelse(str_sub(comments,1,2) %in%c('19', '20'), comments, str_sub(time,1,4)),
			 
			`Metadata Producter` = 'Department of Statistics - ILO - International Labour Organisation - Producer of DDI', 
			#`Date of Production` = str_sub(Sys.time(), 1,10), 
			#`DDI Document ID Number` = as.character(NA),
			`Title` = paste0(source.label, ' ', test_time), 
			`Subtitle` = ifelse(str_sub(time,5,5) %in% c('Q', 'M'), test_time_label, NA),
			`Abbreviation` = paste0(source.acronym, ' ', test_time),
			`Study Type` = source_type, 
			#`ID Number` = as.character(NA),
			#`Abstract` =  as.character(NA), 
			`Kind of Data` =  ifelse(str_sub(source, 1,1) %in% 'A', 'Census', NA), 
			`Kind of Data` =  ifelse(str_sub(source, 1,1) %in% 'B', 'survey',`Kind of Data`), 
			`Unit of Analysis` =  ifelse(str_sub(source, 1,1) %in% c('A', 'B'), 'households/individuals', NA), 
			Country = ref_area.label,
			`Geographic Coverage` = ifelse(str_detect(tolower(source.label), 'urban'), 'Urban area', 'National coverage'),
			`Primary Investigator` = AGY_NAME1, 
			`Sampling Procedure` = as.character(NA),
			`Data reference period` = label_freq, 
			`ilo notes` =   as.character(NA)
			
			)				
						

						

test <- x %>% filter(processing_status %in% c('Ready', 'Published')) %>% 
				select(path) %>% 
				mutate(file = paste0(path, '/', path %>% str_replace_all(fixed('/'), '_'), '_ILO.dta'), 
					   DOCfile = paste0(path, '/', path %>% str_replace_all(fixed('/'), '_'), '_ILO_README.docx')) %>% 
				mutate(n_records = 0, 
						important_ILO_notes = NA, 
						var_available = NA)
tocheck <- NULL				
	for (i in 1:nrow(test)){
		test_dta <- NULL
		try(test_dta <- haven::read_dta(test$file[i]))
		if(!is.null(test_dta)){
			test$var_available[i] <- paste0(colnames(test_dta), collapse = '/') 
			test$n_records[i] <-  nrow(test_dta)
			rm(test_dta)
		
		}
		
		invisible(gc(reset = TRUE))
		invisible(gc(reset = TRUE))
		
		
		check <- textreadr::read_document(test$DOCfile[i]) 
		
		if(class(check) %in% "character" & length(check) > 1){
		  check[1] <- paste0("<TITLE>", check[1], "<BR>")
		
		  for(j in 2:length(check)){
			
			  if(str_detect(tolower(check[j]), 'ilo_')){
				  check[j] <- paste0("<SUBTITLE>", check[j], "<BR>")
			  } else {
				  check[j] <- paste0(check[j], "<BR>")
			  }	
		  }
		  
		  test$important_ILO_notes[i] <-  check %>% as_data_frame %>% slice(-1) %>% nest
		
		  print(paste0(i, ' / ', test$file[i]))
		
		} else {
		tocheck <- c(tocheck,paste0(i , ' --- ', test$file[i], ' ---   ERROR README.docx') )
		print(paste0(i , ' / ', test$file[i], ' ---   ERROR README.docx'))
		
		}
		
	}
	
	if(length(tocheck) > 0 ) {tocheck %>% as_data_frame %>% separate(value, c('id','path','error'), sep = fixed(' --- ')) %>% write_csv(paste0(ilo:::path$micro, '/_Admin/CMD/log_readMe_error.csv'), na = '')}
	
	
	
	x <- x %>% select(-`ilo notes`) %>% left_join(select(test, path, n_records,important_ILO_notes, var_available), by = "path") %>% 
				mutate(
					`Sampling Procedure` = paste0('n records = ', n_records )) %>% 
				select(-n_records) %>% 
				mutate(important_ILO_notes = ifelse(important_ILO_notes %in% NA, '', important_ILO_notes)) %>%
				rename(`ilo notes` = important_ILO_notes) %>%
				select(path, ref_area, source, time, processing_status, processing_update,origine_date, Master = type, origine_date,origine_repo,  origine_website, `Metadata Producter`:`ilo notes`, var_available)	

	invisible(gc(reset = TRUE))
	x
	
	
	
	
	
	
	# data_frame(text = readtext(path)$text %>% str_split('\n')  %>% unlist ) %>% 
			# mutate(
					# test = ifelse(str_detect(tolower(text), 'important notes '), 'TITLE', as.character(NA)), 
					# test = ifelse(str_detect(tolower(text), 'ilo_country|ilo_source|ilo_wgt|ilo_geo|ilo_sex|ilo_age_5yrbands|ilo_age_10yrbands|ilo_age_aggregate|ilo_age_ythadult|ilo_edu_isced11|ilo_edu_isced97|ilo_edu_aggregate|ilo_edu_attendance|ilo_dsb_details|ilo_dsb_aggregate|ilo_wap|ilo_lfs|ilo_mjh|ilo_job1_ste_icse93|ilo_job1_ste_aggregate|ilo_job1_eco_isic4_2digits|ilo_job1_eco_isic4|ilo_job1_eco_isic3_2digits|ilo_job1_eco_isic3|ilo_job1_eco_aggregate|ilo_job1_eco_sector|ilo_job1_eco_agnag|ilo_job1_ocu_isco08_2digits|ilo_job1_ocu_isco08|ilo_job1_ocu_isco88_2digits|ilo_job1_ocu_isco88|ilo_job1_ocu_aggregate|ilo_job1_ocu_skill|ilo_job1_ins_sector|ilo_job1_job_time|ilo_job1_job_contract|ilo_job1_ife_prod|ilo_job1_ife_nature|ilo_job1_how_actual|ilo_job1_how_usual|ilo_job1_how_actual_bands|ilo_job1_lri_ees|ilo_job1_lri_slf|ilo_joball_tru|ilo_joball_oi_case|ilo_joball_oi_day|ilo_joball_how_actual|ilo_joball_how_usual|ilo_joball_how_actual_bands|ilo_cat_une|ilo_dur_details|ilo_dur_aggregate|ilo_preveco_isic4|ilo_preveco_isic3|ilo_preveco_aggregate|ilo_prevocu_isco08|ilo_prevocu_isco88|ilo_prevocu_aggregate|ilo_prevocu_skill|ilo_gsp_uneschemes|ilo_olf_dlma|ilo_olf_reason|ilo_dis|ilo_neet|ilo_age|ilo_edu|ilo_dsb|ilo_wap|ilo_lfs|ilo_mjh|ilo_ste_icse93|ilo_ste_aggregate|ilo_eco_isic4|ilo_eco_isic3|ilo_eco_aggregate|ilo_eco_sector|ilo_eco_agnag|ilo_ocu_isco08|ilo_ocu_isco88|ilo_ocu_aggregate|ilo_ocu_skill|ilo_ins_sector|ilo_job_time|ilo_job_contract|ilo_ife_prod|ilo_ife_nature|ilo_how_actual|ilo_how_usual|ilo_lri_ees|ilo_lri_slf|ilo_tru|ilo_oi_case|ilo_oi_day|ilo_cat_une|ilo_dur_details|ilo_dur_aggregate|ilo_preveco|ilo_prevocu|ilo_gsp|ilo_olf|ilo_dis|ilo_neet'), 'SUBTITLE', test),
					# test = ifelse(test %in% NA, 'TEXT', test)
				# )

	
	
	
	
	
	
	
	
	
}


check_files_box <- function(check_all = FALSE, who = 'Mabelin'){




require(iloMicro)


	init_wd <- getwd()
	setwd(ilo:::path$micro)


	REF_DIR <- list.files() %>% as_data_frame() %>% rename(ref_area = value)%>% filter(nchar(ref_area) %in% 3)
	
	############### loop on ref_area
	workflow <- Micro_get_workflow() %>% filter(!source %in% c('GALLUP'))
	
	if(!check_all){
	
		workflow <- workflow %>% filter(processing_status %in% c('Published','Ready'))
	
	}
	if(!who %in% 'all'){
	
		workflow <- workflow %>% filter(processing_by %in% who)
	}
	
	
	MASTER <- workflow %>% filter(processing_status %in% c('Published','Ready'), str_detect(type, 'Master_')) %>% 
							select(ref_area, source, time, type, rebuild_pattern) %>% 
							mutate(type_id = str_sub(type, -1,-1)) %>% 
							select(-type, -time)
	
	FINAL <- NULL
	
	for (i in 1:nrow(workflow)){
			
			print(paste0(i,' / ', workflow$path[i]))
			
			setwd(paste0(ilo:::path$micro, '/',workflow$path[i] ))
			
			# clean up files on the roots
			
			ROOTS <- list.files() %>% as_data_frame() %>% filter(!value %in% c('ORI'))
			
			delete <- NULL
			delete <- ROOTS %>% filter(str_detect(value, '_ILO_ilostat.csv')) %>% .$value
			
			if(length(delete)>0) file.remove(paste0(ilo:::path$micro,workflow$path[i] ,'/', delete))
	
			#identify ORI files and folder
			
			ORI <- list.files('./ORI') %>% as_data_frame() %>% filter(!value %in% c('Questionnaires','Reports', 'Technical', 'Internal')) %>% 
					mutate(size = as.character(NA), isdir = as.character(NA))
			if(nrow(ORI) > 0){			
			for (j in 1:nrow(ORI)){
				
				test <- file.info(paste0('./ORI/', ORI$value[j]))
				ORI$size[j] <- test$size
				ORI$isdir[j] <- test$isdir
			}
			ORI <- ORI %>% mutate(folder  = 'ORI')
				
				test_dir <- ORI %>% filter(isdir %in% TRUE) %>% select(value) %>% t %>% as.character # 
			if(length(test_dir)>0){
			
				for (j in 1:length(test_dir)){
				
						SUB_DIR <- list.files(paste0('./ORI/',test_dir[j]) ) %>% as_data_frame() %>% # filter(!value %in% c('Original','Questionnaires','Reports', 'Technical', 'Internal')) %>% 
								mutate(size = as.character(NA), isdir = as.character(NA))
						if(nrow(SUB_DIR)>0){
						for (k in 1:nrow(SUB_DIR)){
				
								test_sub_dir <- file.info(paste0('./ORI/',test_dir[j], '/', SUB_DIR$value[k]))
								SUB_DIR$size[k] <- test_sub_dir$size
								SUB_DIR$isdir[k] <- test_sub_dir$isdir
						}
						SUB_DIR <- SUB_DIR %>% mutate(folder = paste0('ORI/',test_dir[j], '/'))
						ORI <- ORI %>% filter(!value %in% test_dir[j]) %>% bind_rows(SUB_DIR)
						}
						
				}
				
			
			}
			

				ORI <- ORI %>% 
						mutate(
								ref_area = workflow$ref_area[i], 
								source = workflow$source[i], 
								time = workflow$time[i], 
								path = workflow$path[i],
								type = workflow$type[i],									
								type_id = str_sub(workflow$type[i],-1,-1),
								processing_status = workflow$processing_status[i],							
								processing_by = workflow$processing_by[i],							
								move = as.character(NA), 
								copy = as.character(NA)
								) %>% left_join(MASTER, by = c('ref_area', 'source', "type_id")) %>% 
						mutate(TEST = str_detect(tolower(value), tolower(rebuild_pattern)), 
								move = ifelse(TEST & str_sub(tolower(value), -4,-1) %in% c('.sav','.dta') & isdir %in% FALSE, 'keep', move)) %>% select(-TEST)
			}
		FINAL <- bind_rows(FINAL, ORI)
	
	}
	
	FINAL <- FINAL %>% mutate(add_to_name = NA) %>% select(ref_area, source, time, folder, type, processing_status, processing_by, move, copy, add_to_name, rebuild_pattern, files = value, size, isdir)
	

	setwd(init_wd)

	getwd()
	
	setwd(paste0(ilo:::path$micro,"_Admin/TEST_FILE/NEW/"))
	
	for(i in 1:length(unique(FINAL$processing_by) )){
	
		if(unique(FINAL$processing_by)[i] %in% NA) test <- 'OTHER' else test <- unique(FINAL$processing_by)[i]
	
		FINAL %>% filter(processing_by %in% test) %>% data.table:::fwrite(file = paste0(test, '.csv'), na = '')
	
	
	}
	

	
	
	
	FINAL
	
	



}

clean_files_box <- function(who = 'Ana'){


	require(iloMicro)
	init_wd <- getwd()
	setwd(ilo:::path$micro)

	workflow <- read_csv(paste0(getwd(),'/_Admin/TEST_FILE/', who, '.csv')) 
	
	# Step 1 no need to deal with status move = 'keep' or NA
	
	workflow <- workflow %>% filter( !move %in% c('keep', NA))


	# Step 2 move to 'Original' status move = 'o'
	workflow$files <- workflow$files %>% iconv()
	Step1 <- workflow 
	
	
	if(nrow(Step1) > 0){
	
	for (i in 1:nrow(Step1)){
		ON_FROM <- paste0(getwd(), '/',Step1$ref_area[i], '/', Step1$source[i], '/', Step1$time[i], '/',Step1$folder[i] )
		ON_ORI <- paste0(getwd(), '/',Step1$ref_area[i], '/', Step1$source[i], '/', Step1$time[i], '/ORI/' )
		my_type <- tolower(Step1$move[i]) 
		todo <- NULL
		if(my_type %in% c('o','d')) todo <- 'Data'
		if(my_type %in% c('i')) todo <- 'Internal'
		if(my_type %in% c('q')) todo <- 'Questionnaire'
		if(my_type %in% c('r')) todo <- 'Report'
		if(my_type %in% c('t')) todo <- 'Technical'
		if(!dir.exists(paste0(ON_ORI,todo)) & !is.null(todo)){
			dir.create(paste0(ON_ORI, todo), showWarnings = FALSE)
		}
		if(dir.exists(paste0(ON_ORI,todo)) & !is.null(todo) & !Step1$isdir[i] ){
			test <- file.rename(from = paste0(ON_FROM, '/', Step1$files[i]), to = paste0(ON_ORI, '/',todo,'/', Step1$files[i]))
		}
		if(dir.exists(paste0(ON_ORI,todo)) & !is.null(todo) & Step1$isdir[i] ){
			ref <- list.files(paste0(ON_FROM, '/', Step1$files[i])) 
			if(length(ref)>0){
				for (j in 1:length(ref)){
					test <- file.rename(from = paste0(ON_FROM,Step1$files[i], '/',ref[j]), to = paste0(ON_ORI,todo, '/', ref[j]))
				}
			}
		}
		rm(my_type,todo , ON_FROM, ON_ORI)
		
		
	
	}
	
	
	Stepdel <- Step1 %>% filter(move %in% 'del') 
	for (i in 1:nrow(Stepdel)){
		ON_FROM <- paste0(getwd(), '/',Stepdel$ref_area[i], '/', Stepdel$source[i], '/', Stepdel$time[i], '/',Stepdel$folder[i] )
		
			try(unlink(paste0(ON_FROM, '/',Stepdel$files[i]), recursive = TRUE, force = TRUE), silent = TRUE)
			try(unlink(paste0(ON_FROM, '/', Stepdel$files[i]), recursive = FALSE, force = TRUE), silent = TRUE)
			try(file.remove(from = paste0(ON_FROM, '/', Stepdel$files[i]), showWarnings = FALSE), silent = TRUE)
		rm( ON_FROM)
	}
	
	
	
	
	}
	
	
	
	# Step 3 move to 'Questionnaire' status move = 'q'
	
	
	
	

}


