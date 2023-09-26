#' helper to check dta columns and value present over times series
#'
#' Support for recoding variable, check \code{?car::Recode}, for labelling variable 
#'
#' @param ref_area character for selection of country (iso3 code), mandatory if path is not set.
#' @param source character for selection of source (as ilo micro spelling, ie. LFS), mandatory if path is not set.
#' @param timefrom , character, time, use for specific datasets period, default NULL.
#' @param timeto ,   character, time, use for specific datasets period, default NULL.
#' @param freq , default 'all', else Annual, 'A', else or quarterly 'Q' or Monthly 'M'
#' @param CMD , default FALSE, if true return str with cmd line for all Published and Ready Country/Source
#' @keywords ILO, microdataset, processing
#' @examples
#' ## Not run:
#'
#'
#'	Micro_check_dta_series(ref_area = 'IND', source = 'PLFS')
#'
#'
#'
#'  # run all in parallel
#'
#'	cmd <- Micro_check_dta_series(CMD = TRUE)
#'  run_parallel_ilo(cmd)
#'
#'  # then add this command to clear up entry file
#'   Micro_check_variable(STORE = TRUE)
#'
#'
#' ## End(**Not run**)
#' @export

Micro_check_dta_series <- function(		ref_area =  NULL,
										source = NULL, 
										timefrom = NULL, 
										timeto = NULL, 
										freq = 'all', 
										CMD = FALSE
										
									){


# ref_area =  'BEL';  source = 'EUSILC' ; freq = 'A'; timefrom = NULL; timeto = NULL


if(CMD){

	ref <- Micro_get_workflow() %>% filter(str_detect(type, 'Copy|Master')) %>% 
	filter(processing_status %in% c('Ready', 'Published')) %>%
    distinct(ref_area, source, freq = str_sub(time,5,5)) %>% mutate(freq = ifelse(freq %in% '', "A", freq)) %>% 
	mutate(cmd = paste0("Micro_check_dta_series(ref_area = '",ref_area,"', source = '",source,"', freq = '",freq,"')")) %>% .$cmd
	
	return(ref)
	
	
}


		require(lubridate)
		
		require(seasonal)
		
		require(xts)
		
		require(textreadr)


							
	MY_workflow <- Micro_get_workflow()  %>% filter(processing_status %in% c('Ready', 'Published'), !freq_code %in% NA) 
	

	
	if(!is.null(ref_area))	{
		
			refref_area <- ref_area; MY_workflow <- MY_workflow %>% filter(ref_area %in% refref_area); rm(refref_area) 
			
			if(nrow(MY_workflow) == 0 ) {message("Error no dataset on the workflow for this ref_area"); return(NULL)}
	
			}
	

	if(!is.null(source)){
		
			refsource <- source; MY_workflow <- MY_workflow %>% filter(source %in% refsource); rm(refsource) 
			
			if(nrow(MY_workflow) == 0 ) {message("Error no dataset on the workflow for this source"); return(NULL)}
	
			}
	


	if(!is.null(timefrom)){
			reftime <- as.numeric(str_sub(timefrom,1,4)) 
			MY_workflow <- MY_workflow %>% filter(as.numeric(str_sub(time,1,4)) > reftime - 1)
			rm(reftime) 
			if(nrow(MY_workflow) == 0 ) {message("Error no dataset on the workflow for this timefrom"); return(NULL)}
	
	}

	if(!is.null(timeto)){
			reftime <- as.numeric(str_sub(timeto,1,4)) 
			MY_workflow <- MY_workflow %>% filter(as.numeric(str_sub(time,1,4)) < reftime + 1)
			rm(reftime) 
			if(nrow(MY_workflow) == 0 ) {message("Error no dataset on the workflow for this timeto"); return(NULL)}
	
	}
	
	if(freq %in% "A"){
	
			MY_workflow <- MY_workflow %>% filter((str_sub(time,5,5) %in% ""))
			
			if(nrow(MY_workflow) == 0 ) {message("Error no dataset on the workflow for this freq"); return(NULL)}
	
		
	}
	
	if(freq %in% "Q"){
	
			MY_workflow <- MY_workflow %>% filter((str_sub(time,5,5) %in% "Q"))
			if(nrow(MY_workflow) == 0 ) {message("Error no dataset on the workflow for this freq"); return(NULL)}
	
		
	}	
	
	if(freq %in% "M"){
	
			MY_workflow <- MY_workflow %>% filter(str_sub(time,5,5) %in% "M" )
			if(nrow(MY_workflow) == 0 ) {message("Error no dataset on the workflow for this freq"); return(NULL)}
	
		
	}	
	
	
		
	MY_workflow <- MY_workflow %>% 
						filter(!(ref_area %in% "GEO" & source %in% "LFS" & as.numeric(str_sub(time,1,4)) > 2020)) %>% 
						mutate(
						variables = as.character(NA), 
						ilo_notes = as.character(NA), 
						ilo_sample_count = 0, 
						ilo_processing_date = as.character(NA), 
						ID = 1:n()) 
	
	iloMicro:::Micro_load(path = NULL, query = "all")
	

	if(freq %in% "all"){freq <- unique(str_sub(MY_workflow$time,5,5))} 
	
	for (FRE in 1:length(freq)){
	
		Nwork <- nrow(MY_workflow %>% filter(str_sub(time,5,5) %in% ifelse(freq[FRE] %in% "A", "",freq[FRE]  )))
		
		message(paste0("Frequency: ", ifelse(freq[FRE] %in% "", "A",freq[FRE]  )))
	
	my_res <- NULL

	
	for (i in 1:Nwork){
	
		########## process
		
		refID <- MY_workflow %>% filter((str_sub(time,5,5) %in% ifelse(freq[FRE] %in% "A", "",freq[FRE]  ))) %>% slice(i) %>% .$ID
		
		myPath <- MY_workflow %>% filter(ID%in% refID) %>% .$file
		
		X <- iloMicro:::Micro_load(path = myPath, asFactor = TRUE, tpl = FALSE) 
		
		
		MY_workflow <- MY_workflow %>% mutate(variables = ifelse(ID %in% refID, paste0(colnames(X), collapse = ', ') , variables)) 
		MY_workflow <- MY_workflow %>% mutate(ilo_sample_count = ifelse(ID %in% refID,nrow(X) , ilo_sample_count)) 
		MY_workflow <- MY_workflow %>% mutate(ilo_processing_date = ifelse(ID %in% refID,str_sub(file.info(myPath)$mtime , 1,10) , ilo_processing_date)) 
		
		{ ##### ad info from doc file
		
		if(file.exists(paste0(myPath %>% str_replace('.dta', '_README.docx')))){			
	
			check <- textreadr::read_document( paste0(myPath %>% str_replace('.dta', '_README.docx'))) 
				
			check <- str_trim(check)
			check <- check[!check %in% NA]
		

			if(length(check) > 1){
			for(j in 2:length(check)){
			
			  if(str_detect(tolower(check[j]), 'ilo_')){
			  
				if(j == 2)  	check[j] <- paste0('<H1>', check[j], '</H1><BR><P>')
				
				if(j != 2)	check[j] <- paste0('</P><H1>', check[j], '</H1><BR><P>')
			  
			  } else {
				  check[j] <- paste0(check[j], '<BR>')
			  }	
			}
		  
			MY_workflow <- MY_workflow %>% mutate(ilo_notes = ifelse(ID %in% refID, paste0(check[-1], collapse = '') , ilo_notes))
			rm(check)
			} 
			
			
			}

		
		}
		
		
		# store variable names available
		
	
		
		

		
		ref <- colnames(X) %>% enframe(name = NULL) %>% 
					filter(	!value %in% c('ilo_key','ilo_wgt','ilo_time', "ilo_hh", "ilo_hhsize", "ilo_age"), 
							#!str_detect(value, '2digits'), 
							#!str_detect(value, '3digits'), 
							#!str_detect(value, '4digits'), 
							!str_detect(value, 'ilo_expenditure'), 
							!str_detect(value, '_lri_')  ,
							!str_sub(value, -6,-1) %in% c('_usual', 'actual', "length") )%>% 
			left_join(ilo_tpl$Variable %>% distinct(value = var_name, scope) , by = "value") %>% 
			mutate(scope = gsub("!ilo_wgt %in% NA", "ilo_wap %in% 1", scope, fixed = TRUE))
		
		ref <- ref %>% mutate(query = paste0("pass <- X %>% filter(",scope,") %>% count(label = ",value,", wt = ilo_wgt/1000) %>% ", 
											"haven:::zap_labels() %>% ", 
											"mutate(code_level = as.character(label)) %>% ", 
											"select(code_level, n) %>% ", 
											"left_join(ilo_tpl$Variable %>% filter(var_name %in% '",value,"') %>% select(code_level, label = code_label), by = 'code_level') %>% ",
											"select(-code_level) %>% ", 
											"mutate(var = '",value,"', n = round(n,1)) %>% rename(check = n) %>% select(var, label, check)"), 
							  label = paste0("pass_label <- attributes(X[['",value,"']])$label")) 
							  
							  
		
		test <- NULL
		

		for (j in 1:nrow(ref)){
			
			eval(parse(text = ref$query[j]))
			eval(parse(text = ref$label[j]))
			#pass <- pass %>% mutate(label_var = pass_label)
			test <- bind_rows(test, pass)
			rm(pass, pass_label)
		}
		
		
		test <- test %>% left_join(ilo_tpl$Variable %>% count(var = var_name, label_var = var_label), by = "var")
		
		
		my_res <- bind_rows(my_res, test %>% mutate(ilo_time = unique(X$ilo_time)) %>% select(ilo_time, var, label_var, label, check))
		
		rm(X, ref, test)
		
		invisible(gc(reset = TRUE))
  
		invisible(gc(reset = TRUE))
		
		message(paste0(i, " - ", myPath))
		
	}
	

		
			
		invisible(gc(reset = TRUE))
	

			my_res <- my_res  %>% mutate( 	Stime = zoo:::as.Date('1900-01-01'),
									Stime = ifelse(str_sub(ilo_time, 5,5) %in% '', zoo:::as.Date(paste0(str_sub(ilo_time,1,4), '-01-01')),Stime) , 
									Stime = ifelse(str_sub(ilo_time, 5,5) %in% 'Q', zoo:::as.Date(dygraphs::as.yearqtr(ilo_time, "%YQ%q")), Stime)  , 
									Stime = ifelse(str_sub(ilo_time, 5,5) %in% 'M', zoo:::as.Date(dygraphs::as.yearmon(ilo_time, "%YM%m")), Stime) )	%>%
						mutate(Stime = zoo:::as.Date(Stime) ) %>% 
						mutate(label = ifelse(label %in% c('NaN', NA), "999 - SCOPE ERROR", label)) %>% 
						#filter(str_sub(label,1,1) %in% 0:9) %>% 
						#mutate(	label = ifelse(str_sub(label, 1,1) %in% '[', str_sub(label, 5, -1), label), 
						# label = str_replace_all(label, ' ', '')) %>% 
						mutate(ts_ref =  paste0(var, '_', ifelse(str_sub(ilo_time, 5,5) %in% '', 'A', str_sub(ilo_time, 5,5))))
			



			ts_model <- list()


 
			for (ref_var in unique(my_res$ts_ref)){
	
				# message(ref_var)
				check <- my_res %>% filter(ts_ref %in% ref_var)
			
				ref_label <- unique(check$label)
				
				ts_group <- list()
				
					j <- 1
					new_check <- check %>% filter(label %in% ref_label[j]) %>% select(Stime, check)
					
					if(str_sub(ref_var, -1,-1) %in% 'A') {
										ref_time_abnd <- seq.Date(min(check$Stime),max(check$Stime),"year") %>% enframe(name = NULL) %>% rename(Stime  = value)
										freq_ref <- 1
										STARTonYEAR <- as.numeric(str_sub(new_check$Stime,1,4))
										}
					if(str_sub(ref_var, -1,-1) %in% 'Q') {
										ref_time_abnd <- seq.Date(min(check$Stime),max(check$Stime),"quarter") %>% enframe(name = NULL) %>% rename(Stime  = value)
										freq_ref <- 4
										 YEAR <- min(as.numeric(str_sub(new_check$Stime,1,4)))
										 STARTonYEAR <- 5 - length(new_check$Stime[str_sub(new_check$Stime,1,4) %in% YEAR] )
										}
					if(str_sub(ref_var, -1,-1) %in% 'M') {
										ref_time_abnd <- seq.Date(min(check$Stime),max(check$Stime),"month") %>% enframe(name = NULL) %>% rename(Stime  = value)
										freq_ref <- 12
										 YEAR <- min(as.numeric(str_sub(new_check$Stime,1,4)))
										 STARTonYEAR <- 13 - length(new_check$Stime[str_sub(new_check$Stime,1,4) %in% YEAR] )
										}
					
					
		
		
					new_check <- new_check  %>% full_join(ref_time_abnd, by = 'Stime') %>% arrange(Stime)  
		
					ts_group <- xts(new_check$check, new_check$Stime) %>% 
								ts(., start= c(min(as.numeric(str_sub(as.character(new_check$Stime),1,4))), STARTonYEAR), freq = freq_ref)
					if(str_sub(ref_var, -1,-1) %in% 'A') {
						ts_group <- 		 new_check %>% as.xts %>% 
								ts(., start= c(min(as.numeric(str_sub(as.character(new_check$Stime),1,4)))), freq = freq_ref)
								}
			if(length(ref_label) > 1){
					for (j in 2:length(ref_label)){
						new_check <- check %>% filter(label %in% ref_label[j]) %>% select(Stime, check)
					if(str_sub(ref_var, -1,-1) %in% 'A') {
										ref_time_abnd <- seq.Date(min(check$Stime),max(check$Stime),"year") %>% enframe(name = NULL) %>% rename(Stime  = value)
										freq_ref <- 1
										STARTonYEAR <- as.numeric(str_sub(new_check$Stime,1,4))
										}
					if(str_sub(ref_var, -1,-1) %in% 'Q') {
										ref_time_abnd <- seq.Date(min(check$Stime),max(check$Stime),"quarter") %>% enframe(name = NULL) %>% rename(Stime  = value)
										freq_ref <- 4
										 YEAR <- min(as.numeric(str_sub(new_check$Stime,1,4)))
										 STARTonYEAR <- 5 - length(new_check$Stime[str_sub(new_check$Stime,1,4) %in% YEAR] )
										}
					if(str_sub(ref_var, -1,-1) %in% 'M') {
										ref_time_abnd <- seq.Date(min(check$Stime),max(check$Stime),"month") %>% enframe(name = NULL) %>% rename(Stime  = value)
										freq_ref <- 12
										 YEAR <- min(as.numeric(str_sub(new_check$Stime,1,4)))
										 STARTonYEAR <- 13 - length(new_check$Stime[str_sub(new_check$Stime,1,4) %in% YEAR] )
										}
				
						new_check <- new_check  %>% full_join(ref_time_abnd, by = 'Stime') %>% arrange(Stime)  
						
						if(str_sub(ref_var, -1,-1) %in% 'A') {
								ts_group <- cbind(
										ts_group,		 
										new_check %>% as.xts %>% 
								ts(., start= c(min(as.numeric(str_sub(as.character(new_check$Stime),1,4)))), freq = freq_ref)
								)
								} else {
						
						
						ts_group <- cbind(
										ts_group,
										xts(new_check$check, new_check$Stime) %>% ts(., start= c(min(as.numeric(str_sub(new_check$Stime,1,4))), STARTonYEAR), freq = freq_ref)
									)
							}
		
					}
			}
			colnames(ts_group) <- ref_label
			ts_model[[ref_var]] <- ts_group
			
		}
	
		save(ts_model, file = paste0(MY_PATH$micro, '_Admin/CMD/input/', ref_area, '_', source, "_", ifelse(freq[FRE] %in% '', "A", freq[FRE]), '.Rdata'))
		
		if(str_sub(ref_var, -1,-1) %in% 'A') ts_model %>% saveRDS(file = paste0('K:/ILOSTAT/Documents/rds/dic/scope_', ref_area, '_', source, "_", ifelse(freq[FRE] %in% '', "A", freq[FRE]), '.rds'))
		
		rm(my_res, ts_model, ts_group, new_check)

		invisible(gc(reset = TRUE))

		invisible(gc(reset = TRUE))
		
		MY_workflow_freq = MY_workflow %>% filter((str_sub(time,5,5) %in% ifelse(freq[FRE] %in% "A", "",freq[FRE]  ))) %>% select(ref_area, source, time, variables, ilo_notes, ilo_sample_count, ilo_processing_date)
		save(MY_workflow_freq, file = paste0(MY_PATH$micro, '_Admin/CMD/input/variables/', ref_area, '_', source, "_", ifelse(freq[FRE] %in% '', "A", freq[FRE]), '.Rdata')) 
	}

	#MY_workflow <- MY_workflow %>% select(ref_area, source, time, variables, ilo_notes, ilo_sample_count, ilo_processing_date)
	
	#		save(MY_workflow, file = paste0(MY_PATH$micro, '_Admin/CMD/input/variables/', ref_area, '_', source, '.Rdata')) 
	
message("OK")
		

}


