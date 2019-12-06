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
Micro_file_ready <- function(){

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


	readworkflow <- read %>% select(-on_ilostat) %>% mutate( origine_website = ifelse(origine_repo %in% 'Contact NSO', NA, origine_website))


	
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
		res <- res %>% select(-Published)
	
	cou <- Rilostat:::get_ilostat_toc(segment = 'ref_area') %>% filter(freq %in% 'A')  %>% select(ref_area, wb_income_group.label, ilo_region.label, ilo_subregion_broad.label,ilo_subregion_detailed.label )

	overView <-  readworkflow %>% select(ref_area, time, source, processing_status, source_title) %>% 
		filter(!processing_status %in% c('Not usable', 'Not needed')) %>%
 		mutate(processing_status = ifelse(processing_status %in% c('Published','Ready'), 'R', 'X'), source_type = str_sub(source_title,2,3), time = str_sub(time, 1,4)) %>% 
		mutate(source_title = ifelse(source_type %in% 'DA' & str_sub(source,1,2) %in% 'WB', "[DA:XXX] - WBENTSUR - World Bank Entreprise Surves", source_title)) %>% 
		mutate(source = ifelse(source_type %in% 'DA' & str_sub(source,1,2) %in% 'WB', "WBENTSUR", source)) %>% 
		filter(as.numeric(time) > 1989) %>%
		distinct() %>% 
		group_by(ref_area, time,source_type) %>% 
		summarise(source = first(source), processing_status = first(processing_status), source_title = first(source_title)) %>% 
		ungroup 	%>% 
		filter(!source_type %in% 'XX') %>% 
		left_join(cou, by = 'ref_area') %>%
		spread(time, processing_status)  %>%
		ilo:::switch_ilo(ref_area, keep)
	
	overView <- overView %>% left_join(Ariane:::CODE_ORA$T_SRC_SOURCE %>% select(source_type = SRC_CODE, SRC_TEXT_EN), by = "source_type") %>% mutate(source_type = SRC_TEXT_EN) %>% select(-SRC_TEXT_EN)
	
	
	wb <- createWorkbook()
	options("openxlsx.borderStyle" = "thin")
	options("openxlsx.borderColour" = "#4F81BD")
	## Add worksheets
	addWorksheet(wb, "workflow")
	addWorksheet(wb, "summary")
	addWorksheet(wb, "Annual_Overview")
	addFilter(wb, 1, row = 1, cols = 1:ncol(readworkflow))
	writeData(wb, "workflow", readworkflow)
	
	addFilter(wb, 2, row = 1, cols = 1:ncol(res))
	writeData(wb, "summary", res)
	
	addFilter(wb, 3, row = 1, cols = 1:ncol(overView))
	writeData(wb, "Annual_Overview", overView)
	
	saveWorkbook(wb, file = "MICRO_Workflow.xlsx", overwrite = TRUE)
	rm( wb, res, overView)	
	
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


check_files_box <- function(check_all = FALSE, who = 'David'){




require(iloMicro)


	init_wd <- getwd()
	setwd(ilo:::path$micro)


	REF_DIR <- list.files() %>% enframe(name = NULL) %>% rename(ref_area = value)%>% filter(nchar(ref_area) %in% 3)
	
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
			
			ROOTS <- list.files() %>% enframe(name = NULL) %>% filter(!value %in% c('ORI'))
			
			delete <- NULL
			delete <- ROOTS %>% filter(str_detect(value, '_ILO_ilostat.csv')) %>% .$value
			
			if(length(delete)>0) file.remove(paste0(ilo:::path$micro,workflow$path[i] ,'/', delete))
	
			#identify ORI files and folder
			
			ORI <- list.files('./ORI') %>% enframe(name = NULL) %>% filter(!value %in% c('Questionnaires','Reports', 'Technical', 'Internal')) %>% 
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
				
						SUB_DIR <- list.files(paste0('./ORI/',test_dir[j]) ) %>% enframe(name = NULL) %>% # filter(!value %in% c('Original','Questionnaires','Reports', 'Technical', 'Internal')) %>% 
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

clean_files_box <- function(who = 'David'){


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

