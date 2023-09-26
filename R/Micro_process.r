#' helper to calculate micro indicator (volume and ratio) for ilo data and query
#'
#' faster method to recode, order, add label of categorical variables. revision: 04/01/2022
#'
#'
#' @param ref_area character for selection of country (iso3 code), mandatory if path is not set.
#' @param source character for selection of source (as ilo micro spelling, ie. LFS), mandatory if path is not set.
#' @param time , character, time, use for a specific dataset, default NULL, mandatory if path is not set.
#' @param timefrom query to reduce time as from starting year timefrom.
#' @param timeto query to reduce time as from ending year timeto.
#' @param consolidate default "1", or "123".
#' @param validate only ready file on workflow.
#' @param PUB if TRUE will process only dataset ready for ilostat publication (ie. workflow on_ilostat = 'Yes') else all ready/published. Default FALSE.
#' @param ktest numeric vector, thresholds define to determine whether an indicator is unrealable or not, see section, default c(max = 30, min = 5, threshold = 0.334).
#' @param saveCSV save result in ilostat csv format on the directory of the path, default FALSE, if TRUE tes on scope, indicator, version is done.
#' @param QUERY process only indicator dedicate to a special query, not the entire set of indicators (ie. indicator template columns query_folder set to not null). Default "ILOSTAT".
#' @param ICLS "13" as default, if "19" take ILO19.dta when available, use only for QUERY.
#' @param CMD , default FALSE, if true return str with cmd line for all Published and Ready Country/Source
#'
#' @author ILO / bescond
#' @keywords ILO, microdataset, processing
#' @examples
#' ## Not run:
#'
#'  Micro_process(saveCSV = TRUE, validate = TRUE, ref_area = 'ZAF', source = 'LFS', time = '2016Q1')
#'
#'
#' Micro_process(validate = TRUE, consolidate = '123', PUB = TRUE, ref_area ='ZAF', source = 'LFS')
#'
#'
#'	# you could now rebuild, process 1 for a single time, then process 23
#'	# use mainly for adding oe dataset to a series yet publish
#'
#'	Publish_micro("CAN", "LFS", "1980M11")
#'
#'  # run all in parallel
#'
#'	cmd <- Micro_process(CMD = TRUE)
#'  run_parallel_ilo(cmd)

#' ## End(**Not run**)


#' @export


Micro_process <- function(			ref_area =  NULL,
									source = NULL, 
									time = NULL, 
									timefrom = NULL, 
									timeto = NULL, 
									consolidate = '1', 
									validate = FALSE, 
									PUB = FALSE, 
									ktest = c(max = 15, min = 5, threshold = 0.334), 
									saveCSV = FALSE, 
									QUERY = "ILOSTAT", 
									ICLS = "13", 
									CMD = FALSE, 
									TEST_SCOPE = FALSE){


								
								# MY_PATH <- NULL
								# MY_PATH$micro <-  "J:/DPAU/MICRO/"
								# MY_PATH$query <-  "J:/DPAU/QUERY/"
								# require(haven)
								# require(readxl)
								# require(tidyverse)
								# ref_area =  "ZAF"
								# source = "QLFS"
								# time = "2000Q3"
								# ktest = c(max = 15, min = 5, threshold = 0.334)
								# saveCSV = FALSE
								# validate = TRUE
								# consolidate = '1'
								# timefrom = NULL
								# timeto = NULL
								# PUB = FALSE
								# QUERY = "MICRO_TESTBREAKDOWN"
								# freq = "all"
								# ICLS = "13"
								# TEST_SCOPE = FALSE
								# CMD = FALSE




if(!is.null(ref_area)) 	ref_ref_area <- ref_area else ref_ref_area = NULL
if(!is.null(source) & ! class(source) %in% "function") 	ref_source <- source else ref_source = NULL
if(!is.null(time) & ! class(source) %in% "function") 		ref_time <- time  else ref_time = NULL
if(!is.null(timefrom)) 	ref_timefrom <- timefrom else ref_timefrom = NULL
if(!is.null(timeto)) 	ref_timeto <- timeto else ref_timeto = NULL
									
						
	
if(CMD){

	workflow <- Micro_get_workflow(ref_area = ref_ref_area, source = ref_source, timefrom = ref_timefrom, timeto = ref_timeto) 
	
	
	if(validate) {
			workflow <- workflow %>% 
						filter(processing_status %in% c('Ready', 'Published')) 
			
			if(PUB) {
				workflow <- workflow %>% 
						filter(processing_status %in% c('Published'), CC_ilostat %in% "Yes", on_ilostat %in% "Yes") 
			
			}
	}
	
	if(str_detect(consolidate, '1')){
			workflow <- workflow %>% distinct(ref_area, source, time) 
			workflow <- workflow %>%  mutate(cmd = paste0("Micro_process(validate = ",validate,", consolidate = '",consolidate,"', PUB = ",PUB,", ref_area = '",ref_area,"' , source = '",source,"', time = '",time,"')")) %>% .$cmd
	}
	if(str_detect(consolidate, '2|3')){
			workflow <- workflow %>% distinct(ref_area, source) 
			workflow <- workflow %>%  mutate(cmd = paste0("Micro_process(validate = ",validate,", consolidate = '",consolidate,"', PUB = ",PUB,", ref_area = '",ref_area,"' , source = '",source,"')")) %>% .$cmd
	}	
	
	
	return(workflow)
	
	
}

										
Micro_load(tpl = TRUE, query = QUERY)
									



		
if(str_detect(consolidate, '1')){	
							
	# init_wd <- getwd()

 	workflow <- Micro_get_workflow(ref_ref_area,
								ref_source, 
								ref_time) %>% filter(str_detect(type, 'Copy|Master')) %>% 
				filter(!processing_status %in% c("Not Usable", "Not started"))

	if(validate) {
			workflow <- workflow %>% 
						filter(processing_status %in% c('Ready', 'Published')) 
			if(PUB) {
				workflow <- workflow %>% 
						filter(processing_status %in% c('Published')) 
			
			}
	}
	
	
	if(!is.null(timefrom)){
			reftime <- as.numeric(str_sub(timefrom,1,4)) 
			workflow <- workflow %>% filter(as.numeric(str_sub(time,1,4)) > reftime - 1)
			rm(reftime) 
	}

	if(!is.null(timeto)){
			reftime <- as.numeric(str_sub(timeto,1,4)) 
			workflow <- workflow %>% filter(as.numeric(str_sub(time,1,4)) < reftime + 1)
			rm(reftime) 
	}
	
	pathOutput <- paste0(MY_PATH$micro, '_Admin/CMD/Output/')

	if ( !QUERY %in% "ILOSTAT"){
			
			pathOutput <- paste0(MY_PATH$query, QUERY, '/Input/')
			
	}
	
	workflow = workflow %>% select(ref_area, source, time, source_flag, source_title, freq_code, file, type, processing_by, drop)  %>% 
					separate(source_title, "source_title" , sep = ']', extr = "drop") %>% 
					mutate(source_title = str_sub(source_title,2,-1))
		
	
	for (i in 1:nrow(workflow)){
	
		Micro_process_time(						workflow = workflow %>% slice(i),
												path = workflow$file[i],  
												ref_area =  NULL,
												source = NULL, 
												time = NULL,
												ktest = ktest, 
												saveCSV = saveCSV, 
												QUERY = QUERY, 
												ICLS = ICLS, 
												pathOutput, 
												TEST_SCOPE)	


	
	}
	
	
	rm(workflow)

}

if(str_detect(consolidate, '2')){

	pathOutput <- paste0(MY_PATH$micro, '_Admin/CMD/Output/')
	if (!QUERY %in% "ILOSTAT"){
			pathOutput <- paste0(MY_PATH$query, QUERY, '/Input/')
	}
	workflow <- Micro_get_workflow(ref_ref_area, ref_source)  %>% filter(str_detect(type, 'Copy|Master')) %>% select(ref_area, source, time, source_flag, freq_code, level, processing_status, CC_ilostat)
	if(validate) {workflow <- workflow %>% filter(processing_status %in% c('Ready', 'Published'), CC_ilostat %in% 'Yes') }
	if(validate & PUB) {workflow <- workflow %>% filter(processing_status %in% c('Published'), CC_ilostat %in% 'Yes') }
	if(!is.null(timefrom)){
			reftime <- as.numeric(str_sub(timefrom,1,4)) 
			workflow <- workflow %>% filter(as.numeric(str_sub(time,1,4)) > reftime - 1)
			rm(reftime)}
	if(!is.null(timeto)){
			reftime <- as.numeric(str_sub(timeto,1,4)) 
			workflow <- workflow %>% filter(as.numeric(str_sub(time,1,4)) < reftime + 1)
			rm(reftime)}
	workflow <- workflow %>% select(-processing_status, -CC_ilostat)
	
		invisible(gc(reset = TRUE))


	Micro_process_quarterly_from_monthly(workflow, ktest = ktest,  PUB = PUB, QUERY = QUERY, pathOutput)


	Micro_process_annual_from_quarterly(workflow, ktest = ktest,  PUB = PUB, QUERY = QUERY, pathOutput)

	Micro_process_annual_from_quarterlyCalculated(workflow, ktest = ktest, PUB = PUB, QUERY = QUERY, pathOutput)

	
		
}

if(str_detect(consolidate, '3')){
	

	Micro_process_all(ref_area = ref_ref_area, source = ref_source,  validate = validate, PUB = PUB, QUERY = QUERY)
	
	invisible(gc(reset = TRUE))
	
	
}

rm(ilo_tpl, envir =globalenv())


	
							
}

#' @export
Micro_process_time <- function(		workflow = NULL,
									path = NULL, 
									ref_area =  NULL,
									source = NULL, 
									time = NULL, 
									ktest = c(max = 15, min = 5, threshold = 0.334), 
									saveCSV = TRUE, 
									QUERY = "ILOSTAT", 
									ICLS = "13", 
									pathOutput, 
									TEST_SCOPE){
							
# path = workflow$file[1]
# path = "J:/DPAU/MICRO/USA/CPS/2023M01/USA_CPS_2023M01_ILO.dta"; ICLS = "last"

	if (is.null(path)){
		if(is.null(ref_area) | is.null(source) | is.null(time) ){return('error plse specify path or ref_area AND source AND time')}
		if(!(is.null(ref_area) | is.null(source) | is.null(time)) ){ path <- paste0(MY_PATH$micro, ref_area, '/', source, '/', time, '/', ref_area, '_', source, '_', time, '_ILO.dta')}
	}
	
	REG <- basename(path) %>% str_split("_") %>% unlist
	ref_area <- REG[1]
	source <- REG[2]
	rm(REG)

	if(ICLS %in% '19') {
			testICLS <- file.exists(str_replace(path, "_ILO.dta", "_ILO19.dta"))
			if(testICLS) path <- str_replace(path, "_ILO.dta", "_ILO19.dta") else return(NULL)
			
			
	} 
	

	df <- Micro_load(path, query = QUERY, tpl = FALSE)   %>% 
					select(-contains('ilo_key')) %>% 
					filter(!ilo_wgt %in% c(NA, 0))  
					#mutate(ilo_time = ilo_time  %>% as.character) %>% 
					#haven:::zap_labels() 
					
	
					
	if(source %in% 'SWTS'){
	
			try(df <- df %>% filter(ilo_age_5yrbands <= 6), silent = TRUE) 
			
	}				
					
					
	if (!QUERY %in% "ILOSTAT"){
			
			
		if(file.exists(paste0(MY_PATH$query, QUERY, "/do/add_cmd_init.r"))){
		
			try(	
					eval(parse(text =  readLines(paste0(MY_PATH$query, QUERY, "/do/add_cmd_init.r"))))
				, silent = TRUE) 
		}


				
		ref <- paste0(colnames(df), collapse = '/')
		
		if(str_detect(QUERY , 'CHILD_LABOUR')) {
	
			if( str_detect(ref, fixed('ilo_age/') )){
			
				 try(df <- df %>% mutate(	ilo_age_cls = 
					 case_when(
			
				 ilo_age %in% 0:4 	  ~ 1,
				 ilo_age %in% 5:11   ~ 2,
				 ilo_age %in% 12:14  ~ 3,
				 ilo_age %in% 15:17  ~ 4,
				 ilo_age %in% 18:24  ~ 5,
				 TRUE ~ 6

			

			)), silent = TRUE) }
			if(str_detect(ref, 'ilo_wgt_chld')) {
									try(df <- df %>% mutate(	ilo_wgt  	= ifelse(ilo_age_cls %in% 2:5, ilo_wgt_chld, ilo_wgt)), silent = TRUE) # patch weight ilo_wgt
											
												}
			
	
			if( str_detect(ref, 'ilo_age_cls') & str_detect(ref, 'ilo_job1_how_usual'))
			
				try(df <- df %>% mutate(	ilo_how_usual_bands_chl  		= 
					case_when(
			
				ilo_age_cls %in% 2:5 & ilo_job1_how_usual == 0							   ~ 1,
				ilo_age_cls %in% 2:5 & ilo_job1_how_usual >= 1 & ilo_job1_how_usual <=14 ~ 2,
				ilo_age_cls %in% 2:5 & ilo_job1_how_usual > 14 & ilo_job1_how_usual <=21 ~ 3,
				ilo_age_cls %in% 2:5 & ilo_job1_how_usual > 21 & ilo_job1_how_usual <=27 ~ 4,
				ilo_age_cls %in% 2:5 & ilo_job1_how_usual > 27 & ilo_job1_how_usual <=42 ~ 5,
				ilo_age_cls %in% 2:5 & ilo_job1_how_usual > 42 						     ~ 6,
				ilo_job1_how_usual %in% c(NaN,NA)										 ~ 7,
				ilo_job1_how_usual < 140												 ~ 7,
				TRUE ~ 7

			)), silent = TRUE) # ilo_how_usual_bands_chl 	
			
			
			
		}	
				
	} 


	

	
	
	# ref <- paste0(colnames(df), collapse = '/')
	
	# if(!str_detect(ref, 'ilo_sample_count')) {
	
	# df <- df %>% 
			# group_by_at(.vars = colnames(df)[!colnames(df) %in% 'ilo_wgt']) %>% 
			# summarise(ilo_sample_count = dplyr:::n(), ilo_wgt = sum(ilo_wgt), .groups = 'drop') %>% ungroup
	# }

	
	
	
	
	
	

	# TEST scope
	if(TEST_SCOPE){

		ref_columns <- colnames(df)[	colnames(df) %in% {c(paste0(ilo_tpl$Mapping_indicator$SELECT, collapse = ', ') %>% str_split(', ') %>% unlist) %>% unique()}]

	
		VARIABLES <- ref_columns[	ref_columns %in% {ilo_tpl$Variable  %>% 
														filter(	!code_level %in% c("", "character", "double"), 
																!str_detect(var_name, "ilo_age"),
																!var_name %in% c('ilo_sub_farm', 'ilo_sub_fish', 'ilo_sub_hunt', 'ilo_sub_proc', 'ilo_sub_fetch', 'ilo_sub_coll', 'ilo_sub_manuf', 'ilo_sub_cons', 'ilo_sub_opf', 'ilo_joball_tru', 'ilo_dis', 'ilo_neet', 'ilo_vw', 'ilo_vw_org', 'ilo_vw_direct') ) %>% 
																distinct(var_name) %>% 
																.$var_name}	]
		
		
		mapping <- ilo_tpl$Variable  %>% 
									filter(	!code_level %in% c("", "character", "double"), 
											!str_detect(var_name, "ilo_age"),
											!var_name %in% c('ilo_sub_farm', 'ilo_sub_fish', 'ilo_sub_hunt', 'ilo_sub_proc', 'ilo_sub_fetch', 'ilo_sub_coll', 'ilo_sub_manuf', 'ilo_sub_cons', 'ilo_sub_opf', 'ilo_joball_tru', 'ilo_dis', 'ilo_neet', 'ilo_vw', 'ilo_vw_org', 'ilo_vw_direct') ) %>% 
											distinct(var_name,  code_level, code_label) %>% 
									filter(var_name %in% VARIABLES)
		
		
		
		
		for(i in 1:length(VARIABLES)){
	
		SCOPE <- ilo_tpl$Variable %>% filter(var_name %in% VARIABLES[i] ) %>% distinct(scope) %>% .$scope
		MYVARIABLE <- VARIABLES[i]
		
		test_scope <- df %>% filter(eval(parse(text = SCOPE)))   %>% 
							select(!!MYVARIABLE) %>% 
							filter(eval(parse(text = paste0( MYVARIABLE, "%in%" , NA))) )
		
		if(nrow(test_scope) > 0){
				DEFINITION <- ilo_tpl$Variable %>% 
									filter(var_name %in% VARIABLES[i]) %>% 
									distinct(code_level,  code_label) 
				
				eval(parse(text = paste0("df <- df %>% mutate(", MYVARIABLE, " = ifelse(", 	SCOPE, " & ", MYVARIABLE, " %in% NA, ", 
																							last(DEFINITION$code_level),", " ,
																							MYVARIABLE, "))")    ))
				
				#if(!str_detect(MYVARIABLE, "_2digits")) {
				message("WARNING_SCOPE: ", 
								workflow$ref_area, " / ", workflow$source, " / ", workflow$time, " / ", workflow$type, ' - ', 
								workflow$processing_by, ": Check variable : ", 
								MYVARIABLE, " with scope : '" ,
								SCOPE, "', '.' should replaced by code '", 
								last(DEFINITION$code_level), "' label : '", last(DEFINITION$code_label), "'")
				#}
				# message("WARNING_SCOPE: ", workflow$ref_area, " / ", workflow$source, " / ", workflow$time, " / ", workflow$type, ' - ', workflow$processing_by, ": Check variable : ", MYVARIABLE, " with scope : '" ,SCOPE, "', '.' have been replaced by code '", last(DEFINITION$code_level), "' label : '", last(DEFINITION$code_label), "'")
				rm(DEFINITION)
				
		}
		
		mappingREF <- mapping %>% filter(var_name %in% MYVARIABLE) %>% .$code_level %>% as.numeric
		
		test_code <- df %>% filter(eval(parse(text = SCOPE)))   %>% 
							select(!!MYVARIABLE) %>% 
							filter(eval(parse(text = paste0( "!" , MYVARIABLE, "%in%" , paste0("c(", paste0(c(mappingREF, NA), collapse = ","), ")")))) )
		
		if(nrow(test_code) > 0){
				
				message("WARNING_BAD_ENCODING: ", 
								workflow$ref_area, " / ", workflow$source, " / ", workflow$time, " / ", workflow$type, ' - ', 
								workflow$processing_by, ": Check variable : ", 
								MYVARIABLE, " error code : '" ,
								unique(test_code[[1]]), "', '.' should be correctly map '")
		}
		
		
			
		rm(test_scope, test_code,mappingREF,  MYVARIABLE, SCOPE)
		invisible(gc(reset = TRUE))
	
		
		}
		rm(VARIABLES)
		message("PROCESSING 1 : ", workflow$ref_area, ' / ', workflow$source, ' / ', workflow$time, " --> " , Sys.time())
		return(NULL)
	}
	
	
	
	
	
	
	
	if(!str_detect(paste0(colnames(df), collapse = '/'), 'ilo_age_ythbands')) {
	
	try(df <- df %>% mutate(	ilo_age_ythbands  		= ilo_age_5yrbands 			%>% plyr:::mapvalues(from = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14), to = c(NA,NA,NA,1,2,3,NA,NA,NA,NA,NA,NA,NA,NA)		, warn_missing = FALSE	)), silent = TRUE) # age_ythadult 	
	
	}


	

	# allowed specific indicator	
	ref_available_volume <- colnames(df) %>% 
								Micro_process_test(view = F) %>% 
								filter(str_sub(indicator,-2,-1) %in% c('NB','DT')) %>% 
								mutate(ref_ind = paste(rep_var, sex_var, classif1_var, classif2_var, sep = '/') %>% 
								str_replace_all(fixed('/NA'), ''))
	
	
	ref_available_ratio <- colnames(df) %>% 
								Micro_process_test(view = F)  %>% 
								filter(str_sub(indicator,-2,-1) %in% 'RT') %>% 
								mutate(ref_ind = paste(rep_var, sex_var, classif1_var, classif2_var, sep = '/') %>% str_replace_all(fixed('/NA'), '')) %>% 
								mutate(classif1_var = ifelse(str_detect(indicator, "_NOC_"), "NOC", classif1_var))
								
	if (QUERY %in% "ILOSTAT"){
		
		# filter indicators based on rep_source of the template (ie reduce EUSILC, EULFS scope)
		if(workflow$source %in% unique(ilo_tpl$Mapping_indicator %>% filter(!is.na(rep_source)) %>% .$rep_source) ) {
		
			ref_available_ratio <- ref_available_ratio %>% filter(str_detect(rep_source, workflow$source))
		 
			test_ind <- ref_available_ratio %>% distinct(GROUP_BY) %>% .$GROUP_BY
			test_ind <-  paste0(test_ind, collapse = ', ') %>% str_split(., pattern = ", ") %>% unlist %>% unique

			ref_available_volume <- ref_available_volume %>% filter(
											str_detect(rep_source, workflow$source) | 
											indicator %in% test_ind 
											)
				rm(test_ind)
			
			
		}
	
	}	

	
	
	
	if (str_detect(paste0(colnames(df), collapse = '') , 'ilo_age_ythbands')) {
	
		if(nrow(df %>% filter(!ilo_age_5yrbands %in% 1:6)) %in% 0 ){
				ref_available_volume <- ref_available_volume %>% filter(str_sub(indicator,5,5) %in% "3" | str_sub(indicator,1,3) %in% 'CLD') # reduce indicator to YTH stat or Child labor survey
				ref_available_ratio <- ref_available_ratio   %>% filter(str_sub(indicator,5,5) %in% "3" | str_sub(indicator,1,3) %in% 'CLD') # reduce indicator to YTH stat or Child labor survey
				}
	
	
	}
	
	
	ref_columns <- colnames(df)[colnames(df) %in% {c(paste0(ilo_tpl$Mapping_indicator$SELECT, collapse = ', ') %>% str_split(', ') %>% unlist) %>% unique()}]
	
	df <- df %>% select(!!ref_columns)  %>% 
			group_by_at(.vars = ref_columns[!ref_columns %in% c('ilo_wgt')]) %>% 
			summarise(	ilo_sample_count = n(), 
						ilo_wgt = sum(ilo_wgt), .groups = 'drop') %>% ungroup

	
		


	if(nrow(ref_available_volume) == 0 & nrow(ref_available_ratio) == 0){message('WARNING: ',workflow$ref_area, ' / ', workflow$source, ' / ', workflow$time,' / No indicator available') ; return(NULL)}
	
	
	
	volume <- NULL	

	if(nrow(ref_available_volume)> 0){
		
		
		for (i in 1:nrow(ref_available_volume)){
			
			ref_indicator = ref_available_volume %>% slice(i)
			SELECT <- c(ref_indicator$SELECT  %>% as.character %>% str_split(', ') %>% unlist %>% .[!. %in% ''], 'ilo_sample_count')
			FILTER 	<- ref_indicator$FILTER 	
	
			
			volume <- bind_rows(volume,
						df %>% select(!!SELECT) %>% 
					filter(eval(parse(text = FILTER))) %>% 
					Micro_process_volume(	workflow, 
											ref_indicator, 
											SELECT, 
											FILTER,
											ktest, 
											ref_area = ref_area, 
											QUERY) 
											
											
						)
			  #message(paste0(ref_available_volume$indicator[i], " //" , i, "//", nrow(ref_available_volume)))

		}

	}
	
	
	
	
	ref_colnames_df <- colnames(df) 
	
	rm(ref_available_volume, df)
	
	invisible(gc(reset = TRUE))
	

	ratio <- NULL

	if(nrow(ref_available_ratio)> 0){
		volume <- volume %>% switch_ilostat_version() %>% mutate(rep_var = paste0(str_sub(indicator, 1,9),str_sub(indicator, -2,-1)))
		
		TEST_rep_var <- ref_available_ratio %>% distinct(rep_var, .keep_all = TRUE) %>% 
							distinct(rep_var, GROUP_BY, SUMMARISE) %>% 
							rowwise() %>% 
							mutate(	test_var = str_split(GROUP_BY, ", ") %>% unlist %>% .[1] %>% str_sub(., 9, -4), 
									GROUP_BY = GROUP_BY %>% str_replace_all(test_var, ""),
									SUMMARISE = SUMMARISE %>% str_replace_all(test_var, "")
									) %>% 
									ungroup %>% 
									select(-test_var)

		
				
		for (i in 1:nrow( TEST_rep_var)){
			
			ref_indicator = ref_available_ratio %>% filter(rep_var %in% TEST_rep_var$rep_var[i])
			GROUP_BY 		<- TEST_rep_var$GROUP_BY[i] %>% str_split(', ') %>% unlist %>% .[!. %in% ''] %>% str_trim()
			SUMMARISE 		<- TEST_rep_var$SUMMARISE[i] %>% as.character %>% str_trim()

			# reduce and filter df base on ref_indicator instruction
			ref_component <- ref_colnames_df %>% 
								Micro_process_test(view = F)  %>% 
								mutate(classif1_var = ifelse(str_detect(indicator, "_NOC_"), "NOC", classif1_var)) %>% 
								select(indicator, rep_var:indicator_label) %>% 
								filter(	str_sub(indicator,-2,-1) %in% c('NB','DT')) %>% 
								filter(		sex_var %in% ref_indicator$sex_var, 
											classif1_var %in% ref_indicator$classif1_var, 
											classif2_var %in% ref_indicator$classif2_var ) %>% 
								{eval(parse(text = paste0("filter(., rep_var %in% c('",paste0(GROUP_BY, collapse = "', '"),"'))")))}
			
			if(nrow(ref_component %>% distinct(rep_var)) %in% length(GROUP_BY)){
				
				ref <- volume %>% left_join(
										select(ref_component, rep_var,  sex_version = sex_var, classif1_version = classif1_var, classif2_version = classif2_var) %>% mutate(keep = 1) 
										, by = c("rep_var", "sex_version", "classif1_version", "classif2_version"))  %>% 
										filter(keep == 1) %>% select(-keep) 
								
				if(nrow(ref) > 0){
					res <- eval(parse(text = paste0('ref %>% rename(',GROUP_BY[1],' = obs_value)'))) %>% filter(rep_var %in% GROUP_BY[1]) %>% select(-indicator)

					for (j in 2:length(GROUP_BY)){

							test <- ref %>% filter(rep_var %in% GROUP_BY[j]) %>% 
										select(sex, classif1, classif2, time, obs_value)
							test <- eval(parse(text = paste0('test %>% rename(',GROUP_BY[j],' = obs_value)'))) 
							res <- res %>% left_join( test,by = c("sex", "classif1", "classif2", "time"))
							rm(test)

					}

				

					res <- res %>% mutate(rep_var = TEST_rep_var$rep_var[i]) %>% 
								left_join( 
									select(ref_indicator, rep_var,  sex_version = sex_var, classif1_version = classif1_var, classif2_version = classif2_var, indicator), 
									, by = c("rep_var", "sex_version", "classif1_version", "classif2_version")) %>% 
							{eval(parse(text = paste0("mutate(., obs_value = ", SUMMARISE, ")")))} %>% 
							select(indicator, sex, classif1, classif2, time, obs_value, obs_status, dplyr::contains('note_'), ilo_sample_count, table_test, ilo_wgt)  %>% 
							distinct
				
					ratio <- bind_rows(ratio, res)
					
					rm(res)
				
				} 
				
				rm(ref)
			
			
			
			
			}
			
			# message(paste0(TEST_rep_var$rep_var[i], " //" , i, "//", nrow(TEST_rep_var)))
	

			
		}
		rm(i)
		volume <- volume %>% select(-contains("_version"), -rep_var)

	}
	
	
	rm(ref_available_ratio)
	
	
	# add notes at source level
	note_sou <- add_ilostat_Note %>% filter(var_name %in% c('ilo_country', 'ilo_ref_area', 'ilo_source') & !ilostat_note_code %in% NA) %>% 
					summarise(test = paste0(ilostat_note_code, collapse = '_'), .groups = 'drop') %>% t %>% as.character 
	

	X <- bind_rows(volume, ratio) %>% 
				mutate(	ref_area = 	workflow$ref_area, 
						source = 	workflow$source_title, 
						note_source = ifelse(note_sou %in% '', 'R1:3513', paste0('R1:3513_',note_sou)),
						freq_code = workflow$freq_code
						) %>% 
				select(ref_area, source, indicator, sex, classif1, classif2, time, obs_value, obs_status, contains('note_'), ilo_sample_count, ilo_wgt,freq_code) %>% 
				distinct() 


	if (QUERY %in% "ILOSTAT"){
		
		# filter indicators based on drop of the workflow (ie reduce EUSILC, EULFS scope)
		if(!is.na(workflow$drop)){
		
			eval(parse(text = paste0("X <- X %>% ", workflow$drop)))
		
		}
	
	}
							
				

	rm(volume, ratio, note_sou)  
	rm(add_ilostat_Note, envir =globalenv())  
	
		

	
	if(nrow(X) == 0){
		message('WARNING: ', workflow$ref_area, ' / ', workflow$source, ' / ', workflow$time, ' No indicator calculated for this dataset'); return(NULL)
	} else{		
	

		X <- X %>% mutate(	obs_status = ifelse(ilo_sample_count < ktest[1],'U',  as.character(NA)), 
							obs_status = ifelse(ilo_sample_count < ktest[2],'S',  obs_status)
						)		
		if(!workflow$source_flag %in% NA){ 
			X <- X %>% mutate(obs_status = ifelse(!str_sub(obs_status, 1, 1) %in% c('S', 'U'), 'B', str_sub(obs_status, 1, 1)))
		}
	
	
	
		message("PROCESSING 1 : ", workflow$ref_area, ' / ', workflow$source, ' / ', workflow$time, " --> " , Sys.time())

							
	
	
		if(saveCSV){			
			
			
			############ make test on scope
			X <- ilo:::check_ilo(X, scope)
			check_scope <- X %>% filter(!check)
			
			if(nrow(check_scope)>0) {	
										check_scope <- check_scope %>% switch_ilostat_version() %>% distinct(indicator, sex_version, classif1_version, classif2_version)
										message('WARNING: ', workflow$ref_area, ' / ', workflow$source, ' / ', workflow$time, 'Check on scope failed for ',nrow(check_scope),' record(s) contain on:')
										message(check_scope, quote = TRUE, row.names = FALSE)
							}	
			rm(check_scope)
		
			############ make test on indicators
			ilo_test_indicator <-ilo_tpl$Mapping_indicator %>% distinct(ID) %>% pull(ID)
			X <- X %>% 	switch_ilostat_version() %>% 
						unite(ID, sex_version, classif1_version, classif2_version, sep = '/', remove = TRUE) %>% 
						mutate(	ID = paste0(str_sub(indicator, 1,8),  str_sub(indicator, -3,-1), '/', ID),
								ID = ID %>% str_replace_all('/NA', ''), 
								ID = ID %>% str_replace_all('/', ''))
			X <- X %>% filter(ID %in% ilo_test_indicator) %>% select(-ID)
			rm(ilo_test_indicator)
			
			
			############ make test on indicators ilostat
			X <- ilo:::check_ilo(X %>% select(-check), indicator)
			check_indicator <- X %>% filter(!check)
			if(nrow(check_indicator)>0) {	message(paste0('ERROR: ', workflow$ref_area, ' / ', workflow$source, ' / ', workflow$time, ': Check on indicator failed for ',length(unique(check_indicator$indicator)),' indicator(s) below:'))
										check_indicator <- check_indicator %>% distinct(indicator)
										message(check_indicator, quote = TRUE, row.names = FALSE)
										message('defacto check on indicator/version is not done')
										
							}		
		
			X <- ilo:::check_ilo(X %>% select(-check), version)
			check_version <- X %>% filter(!check)

			if(nrow(check_version)>0 & nrow(check_indicator)==0) {	
						check_version <- check_version %>% switch_ilostat_version() %>% distinct(indicator, sex_version, classif1_version, classif2_version)
										message(paste0('ERROR: ', workflow$ref_area, ' / ', workflow$source, ' / ', workflow$time, ': Check indicator/version failed for ',nrow(check_version), ' record(s), plse check following indicator/version:'))
										message(check_version, quote = TRUE, row.names = FALSE)
							}		
			
			X %>% select(-check) 	%>% fwrite(file = file.path(dirname(path[1]), paste0(str_sub(basename(path[1]),1,-5), '_ilostat.csv'))) ###ok
			rm(X)
			
			
			
		} else {


	
			########## prepare folder
			
			if(!dir.exists(paste0(pathOutput, workflow$ref_area))){
					dir.create(paste0(pathOutput, workflow$ref_area), showWarnings = FALSE, recursive = FALSE, mode = "0777")
			}
			
			if(!dir.exists(paste0(pathOutput, workflow$ref_area, '/', workflow$source))){
					dir.create(paste0(pathOutput, workflow$ref_area, '/', workflow$source), showWarnings = FALSE, recursive = FALSE, mode = "0777")
			}
			
			########## save	
			
						
			save(X, file  = paste0(pathOutput, workflow$ref_area, '/', workflow$source, '/', workflow$ref_area, '_', workflow$source, '_', workflow$time, '.Rdata'), compress = "xz")
				
			rm(X)
		
		}
		
		
				
		
}

}

#' @export
Micro_process_volume <- function(	df, 
									workflow, 
									ref_indicator, 
									SELECT,
									FILTER,
									ktest, 
									ref_area, 
									QUERY){ 


	
	
	
	# get SELECT store as character vector 
	#SELECT <- c(ref_indicator$SELECT   		%>% as.character %>% str_split(',') %>% unlist %>% .[!. %in% ''], 'ilo_sample_count') %>% str_trim() 

	# get FILTER store as a string read as is
	#FILTER 		<- ref_indicator$FILTER 	%>% as.character %>%  str_replace_all('  ', ' ') %>% str_trim()
	
	# get GROUP_BY from ref_indicator store as character vector
	GROUP_BY 	<- ref_indicator$GROUP_BY  	%>% as.character %>% str_split(', ')  %>% unlist %>% .[!. %in% ''] %>% str_trim()
	
	# get SUMMARISE from ref_indicator store as a string read as is
	SUMMARISE 	<- ref_indicator$SUMMARISE %>% as.character %>% str_trim()

	# reduce and filter df base on ref_indicator instruction

	if (!QUERY %in% "ILOSTAT"){
			
			
		if(file.exists(paste0(MY_PATH$query, QUERY, "/do/add_cmd_indicator.r"))){
		
			try(	
					eval(parse(text =  readLines(paste0(MY_PATH$query, QUERY, "/do/add_cmd_indicator.r"))))
				, silent = TRUE) 
		}
	}


	if(nrow(df) == 0) {
		message('WARNING_FILTER:', workflow$ref_area, ' / ', workflow$source, ' / ', workflow$time, ' / To build indicator ', ref_indicator$ID, '!!! one major component of the ',FILTER,' is probably missing, plse check the dta mapping')
		return(NULL)
	}

	res <- NULL	
	# STEP 1					
	# GROUP_BY ilo_time only, delete all key variables from GROUP_BY				
	res <- res %>% 
		bind_rows(
		df %>% 
			group_by_at(.vars = GROUP_BY[1]) %>% 
			summarise(	obs_value = eval(parse(text=SUMMARISE)), 
						ilo_sample_count = sum(ilo_sample_count), 
						ilo_wgt = sum(ilo_wgt), .groups = "drop") %>% 
			ungroup %>%
			mutate(across(all_of(colnames(.)), ~replace(., is.na(.), -1))) 		## missing classif as -1
		) %>%  	 mutate(across(all_of(colnames(.)), ~replace(., is.na(.), 0))) 	## total classif as 0
				
					

	# STEP 2
	# GROUP_BY Permutation, all total calculation
	
	if(length(GROUP_BY) > 1){  
		permut <- NULL

		for (ff in 1:length(GROUP_BY[-1])){
			permut <- permut %>% bind_rows(
						combn(seq_along(GROUP_BY[-1]) + 1 ,ff) %>% t %>% as.data.frame %>% as_tibble
						)
			}
			
		for (j in 1:nrow(permut)){ # Permutation, all total calculation
			res <- res %>% 
				bind_rows( 
					df %>% 
						group_by_at(.vars = GROUP_BY[c(1,permut %>% slice(j) %>% t %>% as.vector %>% .[!is.na(.)])]) %>% 
						summarise(	obs_value = eval(parse(text=SUMMARISE)), 
									ilo_sample_count = sum(ilo_sample_count), 
							ilo_wgt = sum(ilo_wgt), .groups = "drop") %>% 
						ungroup %>% 
						mutate(across(all_of(colnames(.)), ~replace(., is.na(.), -1))) 		## missing classif as -1
				) %>%  	 mutate(across(all_of(colnames(.)), ~replace(., is.na(.), 0))) 	## total classif as 0
		}
	}	
	
	
	# STEP 3
	# sort by GROUP_BY key variables, rearrange columns order and names
	res <- res %>% 	
				{ eval(parse(text = paste0("arrange(., ",paste0(GROUP_BY, collapse= ", "),")")))} %>%
				mutate(indicator = ref_indicator$indicator %>% as.character) %>% 
				rename(time = ilo_time) %>% 
				select(indicator, contains('ilo_'),time ,obs_value, ilo_sample_count)
	
	
	
	# STEP 4
	# re factor GROUP_BY key variables, ie. add labels



	for (j in seq_along(GROUP_BY)[-1]){
		
		eval(parse(text = paste0("res <- res %>% mutate(",GROUP_BY[j]," = ",GROUP_BY[j]," %>% Micro_cat_label('",GROUP_BY[j],"', add.total = TRUE, indicator = ref_indicator$indicator[1]) %>% as.character)")))
	}



	# STEP 5 ############################
	# output in ilostat format  
	
		GROUP_BY <- GROUP_BY[!GROUP_BY %in% c('ilo_time')]
	
		if(length(GROUP_BY) !=0 ) {
			
			for (j in seq_along(GROUP_BY)){
			
				refvar <- gsub('job1_','',GROUP_BY)
				refvar <- gsub('job2_','',refvar)
				refvar <- gsub('joball_','',refvar)
				refvar <- gsub('ilo_prev','ilo_',refvar)
				eval(parse(text = paste0("ref <- ilo_tpl$Mapping_classif %>% filter(SELECT %in% '",refvar[j],"')") )) 
				eval(parse(text = paste0("res <- res %>% mutate(",GROUP_BY[j]," = ",GROUP_BY[j]," %>% factor(levels = as.character(ref$ilostat_classif_label), labels = as.character(ref$ilostat_classif_code)) %>% as.character)")))
				
			}
		} 
		
		if(str_detect(paste0(GROUP_BY, collapse = '/'), "ilo_sex")){
				res <- res %>% rename(sex = ilo_sex)
		} else {
				res <- res %>% mutate(sex = as.character(NA))
		}
		
		GROUP_BY <- GROUP_BY[!GROUP_BY %in% c('ilo_sex')]
	
		if(length(GROUP_BY) !=0 ) {
			
			for (j in 1:length(GROUP_BY)){
			
				eval(parse(text = paste0("res <- res %>% rename(classif",j," = ",GROUP_BY[j],")")))
			
			}

		
		}		

		 check_col <- paste0(colnames(res), collapse = '/')
		 if(!str_detect(check_col, "classif2") %in% TRUE) res <- res %>% mutate(classif2 = as.character(NA))
		 if(!str_detect(check_col, "classif1") %in% TRUE) res <- res %>% mutate(classif1 = as.character(NA))
		 rm(check_col)


		res <- res %>% select(indicator, starts_with("sex"), starts_with("classif"), time, obs_value, ilo_sample_count, ilo_wgt)


	



		
		
		
	# add note at indicator level
	note_ind <- add_ilostat_Note %>% filter(ilostat_code %in% ref_indicator$rep_var) %>% 
							select(ilostat_note_code)
	note_ind <- ifelse(nrow(note_ind)==0 | note_ind %in% '', as.character(NA), note_ind %>% t %>% as.character %>% unique)	

	# test releability
		res <- res %>% 	mutate(note_classif =  as.character(NA) , 
						note_indicator = note_ind) %>% 
				mutate( obs_status = as.character(NA), 
						ilo_sample_count = as.numeric(ilo_sample_count),
						obs_status = ifelse(ilo_sample_count < ktest[1],'U',  obs_status), 
						obs_status = ifelse(ilo_sample_count < ktest[2],'S',  obs_status), 
						table_test = as.character(NA)) 
		
		del <- res %>% count(obs_status) %>% filter(obs_status %in% 'S') %>% .$n / nrow(res)
		
		res <- res %>% mutate(table_test = round(ifelse(length(del)>0,del, 0), 2)) %>%
					mutate_if(Negate(is.numeric) , .funs = as.character)
		rm(del)
	
	# add currency
	# if(str_sub(ref_indicator$indicator, 1, 3)%in% 'EAR' | str_sub(ref_indicator$indicator, 1, 8) %in% "SDG_0851"){
	if(str_detect(paste0(SELECT, collapse = ""), 'lri_slf|lri_ees')){
		
		check_currency <- unique(res$note_indicator)
		
		if(!str_detect(check_currency, "T30:") %in% c(TRUE)){
		
		cur_ref <- Ariane:::CODE_ORA$T_CUR_CURRENCY %>% select(code = CUR_ID, code_Geo = CUR_COUNTRY_CODE, CUR_END_DATE) %>% mutate(code = paste0("T30:", code)) %>% 
						filter(code_Geo %in% ref_area) %>% 
						mutate(	CUR_END_DATE = str_sub(as.character(CUR_END_DATE),1,4)) %>% 
						mutate(	CUR_END_DATE = ifelse(CUR_END_DATE %in% NA, str_sub(Sys.time(),1,4), CUR_END_DATE)) %>% 
						mutate(	test = as.numeric(str_sub(unique(res$time),1,4)) < (as.numeric(str_sub(CUR_END_DATE,1,4)) + 1) ) %>%
					filter(test %in% TRUE) %>% slice(n()) %>% select(code) %>% t %>% as.character
						
		res <- res %>% mutate( note_indicator = ifelse(!is.na(note_indicator),paste0(note_indicator, '_', cur_ref),cur_ref))
		
		if(str_detect(paste0(SELECT, collapse = ""), 'how_usual|how_actual')){
				res <- res %>% mutate( note_indicator = gsub("T7:121", "", note_indicator)) %>% 
						mutate(note_indicator = note_indicator %>% str_replace("__", "_")) %>% 
						mutate(note_indicator = ifelse(str_sub(note_indicator,1,1) %in% '_', str_sub(note_indicator,2,-1), note_indicator))
						
		
		}
		
		rm(cur_ref)
		}
		rm(check_currency)
		
		
		
	}		
	
	# check / clean missing note
	res <- res %>% mutate(note_indicator = ifelse(str_sub(note_indicator,-1,-1) %in% '_', str_sub(note_indicator,1,-2), note_indicator))
	
	# add note at classif level
	# from sex

	note_sex <- add_ilostat_Note %>% 
					filter(ilostat_code %in% unique(res$sex)) %>% 
					select(sex = ilostat_code, note_sex = ilostat_note_code)
					
	if(nrow(note_sex) >0){
		res <- res %>% 
				left_join(note_sex, by = 'sex') %>% 
				mutate(note_classif = ifelse(!note_sex %in% NA, as.character(note_sex), as.character(note_classif))) %>% 
				select(-note_sex) %>% as_tibble
	}	
	rm(note_sex)

	# add notes from all classif
	if(length(GROUP_BY) !=0 ) {
		for (nn in 1:length(GROUP_BY)){
			
			eval(parse(text = paste0("note_add <- add_ilostat_Note %>% ",  
					"filter(ilostat_code %in% unique(res$classif",nn,"), var_name %in% GROUP_BY, !ilostat_note_code %in% NA) %>% ",
					"select(classif",nn," = ilostat_code, add_notes = ilostat_note_code)  %>% distinct(classif",nn,", add_notes)")))
				
			if(nrow(note_add) >0){
			
			eval(parse(text = paste0("res <- res %>% ", 
				"left_join(note_add, by = 'classif",nn,"') %>% ",
				"mutate( note_classif = ifelse(note_classif %in% NA, add_notes, paste0(add_notes, '_', note_classif)), ", 
						"note_classif = ifelse(str_sub(note_classif,1,3) %in% 'NA_',str_sub(note_classif,4,-1), note_classif)) %>% ",
				"select(-add_notes)  %>% as_tibble")))
			}
			
			rm(note_add)
			
		
	}}
	

	# order variable and return res	
	
	res %>% select(indicator:obs_value, obs_status, contains('note_'), ilo_sample_count, table_test, ilo_wgt) %>%
				mutate_all(.funs = as.character) %>% 
				mutate_at(vars(obs_value,ilo_sample_count, table_test, ilo_wgt), .funs = as.numeric) %>% 
				as_tibble %>% 
				distinct


}

#' @export
Micro_process_test <- function(df_col , view = TRUE){

	

	
	ilo_tpl$Mapping_indicator$Available <- NA 
	
	
	for ( i in 1:nrow(ilo_tpl$Mapping_indicator)) {
		ref <- strsplit(as.character(ilo_tpl$Mapping_indicator$SELECT)[i], ', ') %>% unlist
		ref <- ref[!ref %in% '']
		if (length(unique(ref %in% df_col)) %in% 1 ){
			if(unique(ref %in% df_col)){
				ilo_tpl$Mapping_indicator$Available[i] <- 1 
			}
		}
		rm(ref)
	}
	
	if(view){	
		out <- ilo_tpl$Mapping_indicator %>% select(indicator, Available) %>% 
				group_by(indicator) %>% 
				summarise(Available = sum(Available, na.rm = TRUE), Max = n(), .groups = 'drop') %>% ungroup %>%
				mutate(label = as.character(indicator) %>% factor( 	levels = unique(ilo_tpl$Mapping_indicator$indicator), 
																	labels = unique(ilo_tpl$Mapping_indicator$indicator_label), exclude = NULL)) %>% 
				select(indicator, label, Available, Max) %>% as.data.frame
	}	

	if(!view){
		out <- ilo_tpl$Mapping_indicator %>% filter(Available %in% 1) %>% distinct
	}	
	out	
	
}


#' @export
Micro_process_annual_from_quarterlyCalculated <- function(											### new RT calculation
									workflow = NULL,
									ktest = c(max = 15, min = 5, threshold = 0.334), 
									PUB = FALSE, 
									QUERY = "ILOSTAT", 
									pathOutput){
	

	reference_wf <-  workflow %>% filter(str_sub(time,5,5) %in% c('')) %>% mutate(year = str_sub(time,1,4) ) %>% distinct(ref_area, source, year)
	workflow <- workflow %>% filter(level %in% c('M')) 
	


if(nrow(workflow)> 0){	
  for (cou in 1:length(unique(workflow$ref_area))){
	wfQ_cou <- workflow %>% filter(ref_area %in% unique(workflow$ref_area)[cou])
	
	for (sou in 1:length(unique(wfQ_cou$source))){
		wfQ_sou <- wfQ_cou %>% filter(source %in% unique(wfQ_cou$source)[sou])
		
		test_break <- wfQ_sou %>% filter(source_flag %in% 'B')  
		
		wfQ_sou <- wfQ_sou %>% mutate(	year = str_sub(time, 1,4), 
										quarter = str_sub(time,5,7) %>% 
												plyr::mapvalues(	from = c('M01','M02','M03','M04','M05','M06','M07','M08','M09','M10','M11','M12'), 
																	to =   c('Q1','Q1','Q1','Q2','Q2','Q2','Q3','Q3','Q3','Q4','Q4','Q4'))) %>% 
								mutate(time = paste0(year, quarter)) %>% 
								count(ref_area, source, time, level, freq_code, year) %>% 
								filter(n %in% 3)
		if(nrow(test_break)> 0 ){
				test_break <- test_break %>% mutate(	year = str_sub(time, 1,4)) %>% distinct(year,source_flag )
			wfQ_sou <- wfQ_sou %>% left_join(test_break, by = "year")
		
		} else {
			wfQ_sou <- wfQ_sou %>% mutate(source_flag = NA)
		}
		rm(test_break)
		
								
		test_year <- wfQ_sou %>% count(year) %>% filter(n %in% 4)
		wfQ_sou <- wfQ_sou %>% filter(year %in% unique(test_year$year))
		
		reference_wf_annual <- reference_wf %>% filter(ref_area %in% unique(wfQ_cou$ref_area), source %in% unique(wfQ_sou$source))
		wfQ_sou <- wfQ_sou %>% filter(!str_sub(time, 1,4) %in% unique(reference_wf_annual$year))
		
		
		if(nrow(wfQ_sou)> 0){				
		for (tim in 1:length(unique(str_sub(wfQ_sou$time,1,4)))){	
			
			wfQ_ref  <- wfQ_sou %>% filter(str_sub(time,1,4) %in% unique(str_sub(wfQ_sou$time,1,4))[tim])
			
			test_dir_available <- dir.exists(paste0(pathOutput,unique(wfQ_ref$ref_area) ,'/', unique(wfQ_ref$source)))
			
			if(!test_dir_available){ 
			
				wfQ_ref <- wfQ_ref %>% slice(0) 
				
			} else {
			
				
				test_freq <- 0
				
				if(unique(wfQ_ref$freq_code) %in% c('M')) {test_freq = 4}
				
				if(test_freq == 0)  {message('ERROR: ', wfQ_ref$ref_area, ' / ', wfQ_ref$source, ' / ', ' freq not correct')}
					
				test_dir_available <- list.files(paste0(pathOutput,unique(wfQ_ref$ref_area) ,'/', unique(wfQ_ref$source))) %>% as_tibble %>% separate(value, c('ref_area', 'source', 'time'), sep = '_') %>% mutate(time = str_sub(time, 1,-7))
					
				if(nrow(test_dir_available) > 0 & !QUERY %in% "ILOSTAT"){
				
					wfQ_ref <- wfQ_ref %>% filter(time %in% test_dir_available$time) 
				
				}
			}
			
		
			####################################################################################################################
			####################################################################################################################
			####################################################################################################################
			
			
			
			
			if(nrow(wfQ_ref)>0) {
			
				X <- as.list(paste0(pathOutput,unique(wfQ_ref$ref_area) ,'/', unique(wfQ_ref$source), "/", wfQ_ref$ref_area, '_', wfQ_ref$source, '_', wfQ_ref$time)) %>% 
						purrr::map_df(~ {
													load(paste0(.x,".Rdata"))
													
																	X			
																				}) %>% as_tibble %>% 
						switch_ilostat_version()
			
				test_vs = X %>% group_by(ref_area, source, time, indicator, sex_version, classif1_version, classif2_version) %>%
					summarise(available_vs = 1, .groups = 'drop') %>% ungroup %>% 
					group_by(ref_area, source, indicator, sex_version, classif1_version, classif2_version) %>% 
					summarise(available_vs = sum(available_vs), .groups = 'drop') %>% ungroup
		
		######## average of number
	
				NB1 <- X %>% filter(str_sub(indicator,-2,-1) %in% c('NB','DT'), !str_sub(indicator,1,3) %in% c('HOW','EAR')) %>% 
						left_join(test_vs, by = c("ref_area", "source", "indicator", "sex_version", "classif1_version", "classif2_version")) %>% 			
						group_by(ref_area, source, indicator, sex, classif1, classif2) %>% 
						summarise(	time = unique(str_sub(time,1,4)), 
									available_vs = min(available_vs),
									obs_value = sum(obs_value) / available_vs, 
									obs_status = paste0(ifelse(obs_status %in% NA, '', obs_status), collapse= ''), 
									note_classif = first(note_classif), 
									note_indicator = first(note_indicator), 
									note_source = first(note_source), 
									freq_code = first(freq_code),
									ilo_sample_count = sum(ilo_sample_count), 
									ilo_wgt = sum(ilo_wgt),
									n = n(), .groups = 'drop') %>% ungroup %>%
						filter(available_vs %in% test_freq) %>% 
						select(-available_vs, -n)
						
				NB2 <- X %>% filter(str_sub(indicator,-2,-1) %in% c('NB','DT'), str_sub(indicator,1,3) %in% c('HOW','EAR')) %>% 
						left_join(test_vs, by = c("ref_area", "source", "indicator", "sex_version", "classif1_version", "classif2_version")) %>% 			
						group_by(ref_area, source, indicator, sex, classif1, classif2) %>% 
						summarise(	time = unique(str_sub(time,1,4)), 
									available_vs = min(available_vs),
									obs_value = sum(obs_value * ilo_wgt) / sum(ilo_wgt), 
									obs_status = paste0(unique(ifelse(obs_status %in% NA, '', obs_status)), collapse = ''), 
									note_classif = first(note_classif), 
									note_indicator = first(note_indicator), 
									note_source = first(note_source), 
									freq_code = first(freq_code),
									ilo_sample_count = sum(ilo_sample_count), 
									ilo_wgt = sum(ilo_wgt),
									n = n(), .groups = 'drop') %>% ungroup %>%
						filter(available_vs %in% test_freq) %>% 
						select(-available_vs, -n)		

				compute_rt <- X %>% filter(!str_sub(indicator,-2,-1) %in% c('NB','DT')) %>% distinct(indicator) %>% 
						left_join(ilo_tpl$Mapping_indicator %>% distinct(indicator, GROUP_BY, SUMMARISE), by = "indicator") 
				rm(X)
				
				
				RT1 <- NULL
				if(nrow(NB1)>0){
					for (rt in 1:nrow(compute_rt)){
						test_nb <- str_split(compute_rt$GROUP_BY[rt], ', ') %>% unlist
						if(nrow(NB1 %>%	filter(indicator %in% test_nb[1])) > 0){
							RT1 	<- 	bind_rows(	RT1, 
												NB1 %>%
													filter(indicator %in% test_nb[1]) %>%  
													mutate(indicator = compute_rt$indicator[rt]) %>% 
													select(-obs_value) %>% 
													left_join(	NB1 %>% filter(indicator %in% test_nb) %>% 
																		select(indicator, sex, classif1, classif2, obs_value) %>% 
																		spread(indicator, obs_value) %>% 
																		{eval(parse(text = paste0("mutate(., obs_value = ", compute_rt$SUMMARISE[rt], ")")))} %>% 
																		select(sex, classif1, classif2, obs_value),
																by = c("sex", "classif1", "classif2"))
											)
						}
										
					}
				}
				
				RT2 <- NULL
				if(nrow(NB2)>0){
					for (rt in 1:nrow(compute_rt)){
						test_nb <- str_split(compute_rt$GROUP_BY[rt], ', ') %>% unlist
						if(nrow(NB2 %>%	filter(indicator %in% test_nb[1])) > 0){
							RT2 	<- 	bind_rows(	RT2, 
												NB2 %>%
													filter(indicator %in% test_nb[1]) %>%  
													mutate(indicator = compute_rt$indicator[rt]) %>% 
													select(-obs_value) %>% 
													left_join(	NB2 %>% filter(indicator %in% test_nb) %>% 
																		select(indicator, sex, classif1, classif2, obs_value) %>% 
																		spread(indicator, obs_value) %>% 
																		{eval(parse(text = paste0("mutate(., obs_value = ", compute_rt$SUMMARISE[rt], ")")))} %>% 
																		select(sex, classif1, classif2, obs_value),
																by = c("sex", "classif1", "classif2"))
											)
						}
										
					}
				}
				
								
				X <- bind_rows(NB1, NB2, RT1, RT2) 
				rm(NB1, NB2, RT1, RT2)
				
				invisible(gc(reset = TRUE))
					
				if(nrow(X) > 0){
				
					X <- X %>% mutate(	obs_status = ifelse(ilo_sample_count < ktest[1],'U',  as.character(NA)), 
										obs_status = ifelse(ilo_sample_count < ktest[2],'S',  obs_status)
										)
										
				
					if(nrow(wfQ_ref %>% filter(source_flag %in% 'B'))> 0){ 
						X <- X %>% mutate(obs_status = ifelse(!str_sub(obs_status, 1, 1) %in% c('S', 'U'), 'B', str_sub(obs_status, 1, 1)))
					}
					
					save(X, file = paste0(pathOutput, unique(wfQ_ref$ref_area), '/', unique(wfQ_ref$source), '/', unique(wfQ_ref$ref_area), '_', unique(wfQ_ref$source), '_', unique(substr(wfQ_ref$time,1,4)), '.Rdata'), compress = "xz")
					
					
					rm(X)
					invisible(gc(reset = TRUE))
					message("PROCESSING 2 ANNUAL FROM QUARTERLY CALC : ", unique(wfQ_ref$ref_area), ' / ', unique(wfQ_ref$source), ' / ', unique(substr(wfQ_ref$time,1,4)),  " --> " , Sys.time())
				}
			}
		
		}
		
		}
	}
	
  }
}
		invisible(gc(reset = TRUE))
	
}
#' @export
Micro_process_annual_from_quarterly <- function(													### new RT calculation
									workflow = NULL,
									ktest = c(max = 15, min = 5, threshold = 0.334), 
									PUB = FALSE, 
									QUERY = "ILOSTAT", 
									pathOutput){
	
	workflow <- workflow %>% filter(level %in% c('Q')) 
	
	
	if (!QUERY %in% "ILOSTAT"){
			workflow <- workflow %>% filter(!(str_sub(time,5,5) %in% c('Q', 'M') & level %in% 'A'))	
	} 


if(nrow(workflow)> 0){	

  for (cou in 1:length(unique(workflow$ref_area))){
	wfQ_cou <- workflow %>% filter(ref_area %in% unique(workflow$ref_area)[cou])
	
	for (sou in 1:length(unique(wfQ_cou$source))){
		wfQ_sou <- wfQ_cou %>% filter(source %in% unique(wfQ_cou$source)[sou])
		
		for (tim in 1:length(unique(str_sub(wfQ_sou$time,1,4)))){	
		
			wfQ_ref  <- wfQ_sou %>% filter(str_sub(time,1,4) %in% unique(str_sub(wfQ_sou$time,1,4))[tim])
			
			
			
			test_dir_available <- dir.exists(paste0(pathOutput,unique(wfQ_ref$ref_area) ,'/', unique(wfQ_ref$source)))
			
			if(!test_dir_available){ 
			
				wfQ_ref <- wfQ_ref %>% slice(0) 
				
			} else {	
			
				test_freq <- 0
				
				if(unique(wfQ_ref$freq_code) %in% c('P', 'T', 'R', 'S', 'Q', 'X')) {test_freq = 4}
				
				if(unique(wfQ_ref$freq_code) %in% c('M') & unique(wfQ_ref$level) %in% "Q") {test_freq = 4}
				
				
				if(unique(wfQ_ref$freq_code) %in% c('Y', 'L', 'H', 'I', 'J', 'K', 'O', 'q', 'z')) {test_freq = 3}
				
				if(unique(wfQ_ref$freq_code) %in% c('Z','G','A','B','V','C','W','D','N','o','n','h','E','l','F')) {test_freq = 2}
				
				if(unique(wfQ_ref$freq_code) %in% c('a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'k', 'k', 'U')) {test_freq = 1}
			
				if(test_freq == 0)  {message('ERROR: ', wfQ_ref$ref_area, ' / ', wfQ_ref$source, ' / ', ' freq not correct')}
									
				test_dir_available <- list.files(paste0(pathOutput,unique(wfQ_ref$ref_area) ,'/', unique(wfQ_ref$source))) %>% enframe(name = NULL) %>% separate(value, c('ref_area', 'source', 'time'), sep = '_') %>% mutate(time = str_sub(time, 1,-7)) 
					
				if(nrow(test_dir_available) > 0 & !QUERY %in% "ILOSTAT"){
				
					wfQ_ref <- wfQ_ref %>% filter(time %in% test_dir_available$time) 
				
				} 


			}
			
			####################################################################################################################
			####################################################################################################################
			####################################################################################################################
			
			
			
			
			if(nrow(wfQ_ref)>0) {
			
				X <- as.list(paste0(pathOutput,unique(wfQ_ref$ref_area) ,'/', unique(wfQ_ref$source), "/", wfQ_ref$ref_area, '_', wfQ_ref$source, '_', wfQ_ref$time)) %>% 
						purrr::map_df(~ {
											load(paste0(.x,".Rdata"))
										
																						X }
																							
																							) %>% as_tibble %>% 
						switch_ilostat_version()
			
				test_vs = X %>% group_by(ref_area, source, time, indicator, sex_version, classif1_version, classif2_version) %>%
					summarise(available_vs = 1, .groups = 'drop') %>% ungroup %>% 
					group_by(ref_area, source, indicator, sex_version, classif1_version, classif2_version) %>% 
					summarise(available_vs = sum(available_vs), .groups = 'drop') %>% ungroup
				
				############## exception quarterly once a year take additionnal note reference period
				
				if(test_freq %in% 1 & unique(X$freq_code) %in% 'k') {X <- X %>% mutate(note_source = paste0('S3:23_', note_source))}
		
				######## average of number
	
				NB1 <- X %>% filter(str_sub(indicator,-2,-1) %in% c('NB','DT'), !str_sub(indicator,1,3) %in% c('HOW','EAR')) %>% 
						left_join(test_vs, by = c( "ref_area", "source", "indicator", "sex_version", "classif1_version", "classif2_version")) %>% 			
						group_by(ref_area, source, indicator, sex, classif1, classif2) %>% 
						summarise(	time = unique(str_sub(time,1,4)), 
									available_vs = min(available_vs),
									obs_value = sum(obs_value) / available_vs, 
									obs_status = paste0(ifelse(obs_status %in% NA, '', obs_status), collapse= ''), 
									note_classif = first(note_classif), 
									note_indicator = first(note_indicator), 
									note_source = first(note_source), 
									freq_code = first(freq_code),
									ilo_sample_count = sum(ilo_sample_count), 
									ilo_wgt = sum(ilo_wgt),
									n = n(), .groups = 'drop') %>% ungroup %>%
						filter(available_vs %in% test_freq) %>% 
						select(-available_vs, -n)
						
				NB2 <- X %>% filter(str_sub(indicator,-2,-1) %in% c('NB','DT'), str_sub(indicator,1,3) %in% c('HOW','EAR')) %>% 
						left_join(test_vs, by = c( "ref_area", "source", "indicator", "sex_version", "classif1_version", "classif2_version")) %>% 			
						group_by( ref_area, source, indicator, sex, classif1, classif2) %>% 
						summarise(	time = unique(str_sub(time,1,4)), 
									available_vs = min(available_vs),
									obs_value = sum(obs_value * ilo_wgt) / sum(ilo_wgt), 
									obs_status = paste0(unique(ifelse(obs_status %in% NA, '', obs_status)), collapse = ''), 
									note_classif = first(note_classif), 
									note_indicator = first(note_indicator), 
									note_source = first(note_source), 
									freq_code = first(freq_code),
									ilo_sample_count = sum(ilo_sample_count), 
									ilo_wgt = sum(ilo_wgt),
									n = n(), .groups = 'drop') %>% ungroup %>%
						filter(available_vs %in% test_freq) %>% 
						select(-available_vs, -n)		

				compute_rt <- X %>% filter(!str_sub(indicator,-2,-1) %in% c('NB','DT')) %>% 
								distinct(indicator) %>% 
								left_join(	ilo_tpl$Mapping_indicator %>% 
												distinct(indicator, GROUP_BY, SUMMARISE), 
										by = "indicator") 
				rm(X)
				RT1 <- NULL
				if(nrow(NB1)>0){
					for (rt in 1:nrow(compute_rt)){
						test_nb <- str_split(compute_rt$GROUP_BY[rt], ', ') %>% unlist
						if(nrow(NB1 %>%	filter(indicator %in% test_nb[1])) > 0){
							RT1 	<- 	bind_rows(	RT1, 
												NB1 %>%
													filter(indicator %in% test_nb[1]) %>%  
													mutate(indicator = compute_rt$indicator[rt]) %>% 
													select(-obs_value) %>% 
													left_join(	NB1 %>% filter(indicator %in% test_nb) %>% 
																		select(indicator, sex, classif1, classif2, obs_value) %>% 
																		spread(indicator, obs_value) %>% 
																		{eval(parse(text = paste0("mutate(., obs_value = ", compute_rt$SUMMARISE[rt], ")")))} %>% 
																		select(sex, classif1, classif2, obs_value),
																by = c("sex", "classif1", "classif2"))
											)
						}
										
					}
				}

				RT2 <- NULL
				if(nrow(NB2)>0){
					for (rt in 1:nrow(compute_rt)){
						test_nb <- str_split(compute_rt$GROUP_BY[rt], ', ') %>% unlist
						if(nrow(NB2 %>%	filter(indicator %in% test_nb[1])) > 0){
							RT2 	<- 	bind_rows(	RT2, 
												NB2 %>%
													filter(indicator %in% test_nb[1]) %>%  
													mutate(indicator = compute_rt$indicator[rt]) %>% 
													select(-obs_value) %>% 
													left_join(	NB2 %>% filter(indicator %in% test_nb) %>% 
																		select(indicator, sex, classif1, classif2, obs_value) %>% 
																		spread(indicator, obs_value) %>% 
																		{eval(parse(text = paste0("mutate(., obs_value = ", compute_rt$SUMMARISE[rt], ")")))} %>% 
																		select(sex, classif1, classif2, obs_value),
																by = c("sex", "classif1", "classif2"))
											)
						}
										
					}
				}
					
				
				
				X <- bind_rows(NB1, NB2, RT1, RT2) ; rm(NB1, NB2, RT1, RT2)
			
				if(nrow(X) > 0){
					X <- X %>% mutate(	obs_status = ifelse(ilo_sample_count < ktest[1],'U',  as.character(NA)), 
										obs_status = ifelse(ilo_sample_count < ktest[2],'S',  obs_status))
										
					
					if(nrow(wfQ_ref %>% filter(source_flag %in% 'B'))>0){ 
							X <- X %>% mutate(obs_status = ifelse(!str_sub(obs_status, 1, 1) %in% c('S', 'U'), 'B', str_sub(obs_status, 1, 1)))
					}
					
					save(X, file = paste0(pathOutput, unique(wfQ_ref$ref_area), '/', unique(wfQ_ref$source), '/', unique(wfQ_ref$ref_area), '_', unique(wfQ_ref$source), '_', unique(substr(wfQ_ref$time,1,4)), '.Rdata'), compress = "xz")
					
					rm(X)
					invisible(gc(reset = TRUE))
					message("PROCESSING 2 ANNUAL FROM QUARTERLY : ", unique(wfQ_ref$ref_area), ' / ', unique(wfQ_ref$source), ' / ', unique(substr(wfQ_ref$time,1,4)),  " --> " , Sys.time())
				}
			}
		
		}
	}
	
  }
}
		invisible(gc(reset = TRUE))
	
}
#' @export
Micro_process_quarterly_from_monthly <- function(													## new RT calculation
									workflow = NULL,
									ktest = c(max = 15, min = 5, threshold = 0.334), 
									PUB = FALSE, 
									QUERY = "ILOSTAT", 
									pathOutput){
	workflow <- workflow %>% filter(level %in% c('M'))
	

if(nrow(workflow)> 0){	
  for (cou in 1:length(unique(workflow$ref_area))){
	wfQ_cou <- workflow %>% filter(ref_area %in% unique(workflow$ref_area)[cou])
	
	for (sou in 1:length(unique(wfQ_cou$source))){
		wfQ_sou <- wfQ_cou %>% filter(source %in% unique(wfQ_cou$source)[sou]) %>% mutate(quarter  = str_sub(time,5,7) %>% plyr:::mapvalues(from  = c("M09", "M08", "M07", "M06", "M05", "M04", "M03", "M02", "M01", "M12", "M11", "M10"), 
																																			to = 	c("Q3", "Q3", "Q3", "Q2", "Q2", "Q2", "Q1", "Q1", "Q1", "Q4", "Q4", "Q4")), 
																							quarter = paste0(str_sub(time, 1,4), quarter))
		
		for (month in 1:length(unique(wfQ_sou$quarter))){	
		
			
			wfQ_ref  <- wfQ_sou %>% filter(quarter %in% unique(quarter)[month])
			
			test_dir_available <- dir.exists(paste0(pathOutput,unique(wfQ_ref$ref_area) ,'/', unique(wfQ_ref$source)))
			
			if(!test_dir_available){ 
				wfQ_ref <- wfQ_ref %>% slice(0) 
			} else {
					
				test_freq <- 0
				
				if(unique(wfQ_ref$freq_code) %in% c('M')) {test_freq = 3}
			
				if(test_freq == 0)   {message('ERROR: ', wfQ_ref$ref_area, ' / ', wfQ_ref$source, ' / ', ' freq not correct')}
									
				test_dir_available <- list.files(paste0(pathOutput,unique(wfQ_ref$ref_area) ,'/', unique(wfQ_ref$source))) %>% as_tibble %>% separate(value, c('ref_area', 'source', 'time'), sep = '_') %>% mutate(time = str_sub(time, 1,-7))
					
				if(nrow(test_dir_available) > 0 & !QUERY %in% 'ILOSTAT'){
				
					wfQ_ref <- wfQ_ref %>% filter(time %in% test_dir_available$time) 
				
				}
			}
			
			####################################################################################################################
			####################################################################################################################
			####################################################################################################################
			
			
			
			
			if(nrow(wfQ_ref)>0) {
			
				X <- as.list(paste0(pathOutput,unique(wfQ_ref$ref_area) ,'/', unique(wfQ_ref$source), "/", wfQ_ref$ref_area, '_', wfQ_ref$source, '_', wfQ_ref$time)) %>% 
						purrr::map_df(~ {
												
												load(paste0(.x,".Rdata"))
											
										
																				X
																				
																				}
																																											
																							) %>% as_tibble %>% 
						switch_ilostat_version()
			
				test_vs = X %>% group_by( ref_area, source, time, indicator, sex_version, classif1_version, classif2_version) %>%
					summarise(available_vs = 1, .groups = 'drop') %>% ungroup %>% 
					group_by( ref_area, source, indicator, sex_version, classif1_version, classif2_version) %>% 
					summarise(available_vs = sum(available_vs), .groups = 'drop') %>% ungroup
		
		######## average of number
	
				NB1 <- X %>% filter(str_sub(indicator,-2,-1) %in% c('NB','DT'), !str_sub(indicator,1,3) %in% c('HOW','EAR')) %>% 
						left_join(test_vs, by = c( "ref_area", "source", "indicator", "sex_version", "classif1_version", "classif2_version")) %>% 			
						group_by( ref_area, source, indicator, sex, classif1, classif2) %>% 
						summarise(	time = unique(wfQ_ref$quarter), 
									available_vs = min(available_vs),
									obs_value = sum(obs_value) / available_vs, 
									obs_status = paste0(ifelse(obs_status %in% NA, '', obs_status), collapse= ''), 
									note_classif = first(note_classif), 
									note_indicator = first(note_indicator), 
									note_source = first(note_source), 
									freq_code = first(freq_code),
									ilo_sample_count = sum(ilo_sample_count), 
									ilo_wgt = sum(ilo_wgt),
									n = n(), .groups = 'drop') %>% ungroup %>%
						filter(available_vs %in% test_freq) %>% 
						select(-available_vs, -n)
						
				NB2 <- X %>% filter(str_sub(indicator,-2,-1) %in% c('NB','DT'), str_sub(indicator,1,3) %in% c('HOW','EAR')) %>% 
						left_join(test_vs, by = c( "ref_area", "source", "indicator", "sex_version", "classif1_version", "classif2_version")) %>% 			
						group_by( ref_area, source, indicator, sex, classif1, classif2) %>% 
						summarise(	time = unique(wfQ_ref$quarter), 
									available_vs = min(available_vs),
									obs_value = sum(obs_value * ilo_wgt) / sum(ilo_wgt), 
									obs_status = paste0(unique(ifelse(obs_status %in% NA, '', obs_status)), collapse = ''), 
									note_classif = first(note_classif), 
									note_indicator = first(note_indicator), 
									note_source = first(note_source), 
									freq_code = first(freq_code),
									ilo_sample_count = sum(ilo_sample_count), 
									ilo_wgt = sum(ilo_wgt),
									n = n(), .groups = 'drop') %>% ungroup %>%
						filter(available_vs %in% test_freq) %>% 
						select(-available_vs, -n)		

				compute_rt <- X %>% filter(!str_sub(indicator,-2,-1) %in% c('NB','DT')) %>% distinct(indicator) %>% 
						left_join(ilo_tpl$Mapping_indicator %>% distinct(indicator, GROUP_BY, SUMMARISE), by = "indicator") 
				rm(X)
				
				
				RT1 <- NULL
				if(nrow(NB1)>0){
					for (rt in 1:nrow(compute_rt)){
						test_nb <- str_split(compute_rt$GROUP_BY[rt], ', ') %>% unlist
						if(nrow(NB1 %>%	filter(indicator %in% test_nb[1])) > 0){
							RT1 	<- 	bind_rows(	RT1, 
												NB1 %>%
													filter(indicator %in% test_nb[1]) %>%  
													mutate(indicator = compute_rt$indicator[rt]) %>% 
													select(-obs_value) %>% 
													left_join(	NB1 %>% filter(indicator %in% test_nb) %>% 
																		select(indicator, sex, classif1, classif2, obs_value) %>% 
																		spread(indicator, obs_value) %>% 
																		{eval(parse(text = paste0("mutate(., obs_value = ", compute_rt$SUMMARISE[rt], ")")))} %>% 
																		select(sex, classif1, classif2, obs_value),
																by = c("sex", "classif1", "classif2"))
											)
						}
										
					}
				}
				
			RT2 <- NULL
				if(nrow(NB2)>0){
					for (rt in 1:nrow(compute_rt)){
						test_nb <- str_split(compute_rt$GROUP_BY[rt], ', ') %>% unlist
						if(nrow(NB2 %>%	filter(indicator %in% test_nb[1])) > 0){
							RT2 	<- 	bind_rows(	RT2, 
												NB2 %>%
													filter(indicator %in% test_nb[1]) %>%  
													mutate(indicator = compute_rt$indicator[rt]) %>% 
													select(-obs_value) %>% 
													left_join(	NB2 %>% filter(indicator %in% test_nb) %>% 
																		select(indicator, sex, classif1, classif2, obs_value) %>% 
																		spread(indicator, obs_value) %>% 
																		{eval(parse(text = paste0("mutate(., obs_value = ", compute_rt$SUMMARISE[rt], ")")))} %>% 
																		select(sex, classif1, classif2, obs_value),
																by = c("sex", "classif1", "classif2"))
											)
						}
										
					}
				}
								
				X <- bind_rows(NB1, NB2, RT1, RT2) 
				
				rm(NB1, NB2, RT1, RT2)
			
				invisible(gc(reset = TRUE))
					
			
				if(nrow(X) > 0){
					X <- X %>% mutate(	obs_status = ifelse(ilo_sample_count < ktest[1],'U',  as.character(NA)), 
										obs_status = ifelse(ilo_sample_count < ktest[2],'S',  obs_status))
										
					if(nrow(wfQ_ref %>% filter(source_flag %in% 'B'))>0){ 
						X <- X %>% mutate(obs_status = ifelse(!str_sub(obs_status, 1, 1) %in% c('S', 'U'), 'B', str_sub(obs_status, 1, 1)))
					}
					
					save(X, file = paste0(pathOutput, unique(wfQ_ref$ref_area), '/', unique(wfQ_ref$source), '/', unique(wfQ_ref$ref_area), '_', unique(wfQ_ref$source), '_', unique(wfQ_ref$quarter), '.Rdata'), compress = "xz")
					
					rm(X)
					
					invisible(gc(reset = TRUE))
					
					message("PROCESSING 2 QUARTER FROM MONTHLY : ", unique(wfQ_ref$ref_area), ' / ', unique(wfQ_ref$source), ' / ', unique(wfQ_ref$quarter), " --> " , Sys.time())
				
				}
			}
		
		}
	}
	
  }
}
		invisible(gc(reset = TRUE))
	
}


#' @export
Micro_process_all <- function(		ref_area =  NULL,
									source = NULL, 
									validate = TRUE, 
									PUB = FALSE, 
									QUERY = "ILOSTAT"){

	
	if(!is.null(ref_area)) 	ref_ref_area <- ref_area else ref_area <- NULL
	if(!is.null(source) & ! class(source) %in% "function") 	ref_source <- source else ref_source <- NULL
	
	pathOutput <- paste0(MY_PATH$micro, '_Admin/CMD/Output/')
	
	workflow <- Micro_get_workflow(ref_area = ref_ref_area, source = ref_source) %>% filter(str_detect(type, 'Copy|Master'))
		
	if (!QUERY %in% 'ILOSTAT'){
			pathOutput <- paste0(MY_PATH$query, QUERY, '/Input/')
			
	} 



	
	discard_files <- NA
	if(validate) {
			workflow <- workflow %>% filter(processing_status %in% c('Ready','Published'), CC_ilostat %in% 'Yes') 
			discard_files <- workflow %>% 
						filter(!(processing_status %in% c('Ready', 'Published') & CC_ilostat %in% 'Yes')) %>% 
						distinct(ref_area, source, time) %>% 
						unite(value, ref_area, source, time, sep = '_', remove = FALSE) %>% 
						mutate(value = paste0(pathOutput, '/',ref_area ,'/', source, "/",value, '.Rdata')) %>% .$value %>% as.character
			}
	if(validate & PUB) {
			discard_files <- workflow %>% 
						filter(!(processing_status %in% c( 'Published') & CC_ilostat %in% 'Yes' & on_ilostat %in% 'Yes')) %>% 
						distinct(ref_area, source, time) %>% 
						unite(value, ref_area, source, time, sep = '_', remove = FALSE) %>% 
						mutate(value = paste0(pathOutput, '/',ref_area ,'/', source, "/",value, '.Rdata')) %>% .$value %>% as.character
			workflow <- workflow %>% filter(processing_status %in% c('Published'), CC_ilostat %in% 'Yes', on_ilostat %in% 'Yes') 
			
			}
	
	wf <- workflow %>% distinct(ref_area, source)	

	FileToLoad <- tibble(PATH= '', ID= '', Types= '', REF= '', year = '', freq = '', count_time = 0) %>% slice(-1)

	
	
	for (i in 1:nrow(wf)){	
		
		
		if(dir.exists(paste0(pathOutput, '/',unique(wf$ref_area[i]) ,'/', unique(wf$source[i])))){
		
			ref <- list.files(paste0(pathOutput, '/',unique(wf$ref_area[i]) ,'/', unique(wf$source[i]))) %>% as_tibble %>% 
						filter(!str_detect(value, 'ilostat')) %>%
						mutate(value = paste0(pathOutput, '/',unique(wf$ref_area[i]) ,'/', unique(wf$source[i]), "/", value)) %>% t %>% as.character
			ref <- ref[!ref %in% discard_files] # detect non validate file 
			
			X <- as.list(ref) %>% 
						purrr::map_df(~ {
									load(.x)
									X	
																}) %>% 
										as_tibble %>% switch_ilostat_version()
										

			
	if(QUERY %in% 'ILOSTAT'){		
	

				X <- X %>%
						mutate(frequency = str_sub(time, 5,5)) %>% 
						left_join(
								Ariane:::CODE_ORA$test_freq_ok 
								, by = c('indicator', 'frequency', 'sex_version', 'classif1_version', 'classif2_version')) %>%
						filter(freq_OK %in% 1)  %>% 
						filter(indicator %in% {Ariane:::CODE_ORA$T_CIC_COL_IND_CL %>% 
												distinct(CIC_INDICATOR_CODE) %>% 
												pull(CIC_INDICATOR_CODE)}) %>% 
						select(-frequency, -freq_OK, -sex_version, -classif1_version, -classif2_version)
			
	}
			
			X <- X %>% select( -contains('ilo_wgt'), -contains('table_test')) %>% distinct
			
			save(X,  file = paste0(pathOutput, wf$ref_area[i], '/', wf$source[i], '/', wf$ref_area[i], '_', wf$source[i], '_ilostat.Rdata'), compress = "xz")

		
			ref_year = paste0(min(as.numeric(str_sub(X$time,1,4))), ' - ', max(as.numeric(str_sub(X$time,1,4))))
			ref_freq = unique(str_sub(X$time,5,5)) %>% ifelse(. %in% '', 'A', .) %>% sort(.) %>% paste0(., collapse = '; ') %>% gsub('M; Q', 'Q, M', ., fixed = TRUE)
			ref_count_time = length(unique(X$time))
		
	
			rm(X)		

	
			FileToLoad <- bind_rows(FileToLoad, 
						tibble(PATH= paste0(pathOutput, wf$ref_area[i], '/', wf$source[i], '/', wf$ref_area[i], '_', wf$source[i], '_ilostat.Rdata'), 
						ID= '', 
						Types= 'ilostat', 
						REF= wf$ref_area[i], 
						year = ref_year, 
						freq = ref_freq, 
						count_time = ref_count_time)
						
						)
			rm(ref_year,ref_freq,  ref_count_time)
	

			invisible(gc(reset = TRUE))

			message("PROCESSING 3 : ", wf$ref_area[i], ' / ', wf$source[i], " --> " , Sys.time() )
		} else {message("WARNING_QUERY: ", unique(wf$ref_area[i]) ,'/', unique(wf$source[i]), '   //// no data for this query')}
	}	
	
	
if(is.null(ref_area) & QUERY %in% "ILOSTAT" ) {
					
					ref_PUBLISHED <- read_csv(paste0(MY_PATH$micro, '_Admin/CMD/FileToLoad.csv'), col_types = cols(
																				PATH = col_character(),
																				ID = col_character(),
																				Types = col_character(),
																		REF = col_character()
																)) %>% mutate(published = 'Yes')
					
					FileToLoad <- FileToLoad %>% left_join(select(ref_PUBLISHED, PATH, published), by = c("PATH"))
					FileToLoad %>% fwrite(file = paste0(MY_PATH$micro, '_Admin/CMD/FileToLoad_toCheck.csv'))				
				}


												
	invisible(gc(reset = TRUE))		

}

#' @export

weighted.quantile <- function (x, w, probs = seq(0, 1, 0.25), na.rm = TRUE){
    x <- as.numeric(as.vector(x))
    w <- as.numeric(as.vector(w))
    if (anyNA(x) || anyNA(w)) {
        ok <- !(is.na(x) | is.na(w))
        x <- x[ok]
        w <- w[ok]
    }
    stopifnot(all(w >= 0))
    if (all(w == 0)) 
        stop("All weights are zero", call. = FALSE)
    oo <- order(x)
    x <- x[oo]
    w <- w[oo]
    Fx <- cumsum(w)/sum(w)
    result <- numeric(length(probs))
    for (i in seq_along(result)) {
        p <- probs[i]
        lefties <- which(Fx <= p)
        if (length(lefties) == 0) {
            result[i] <- x[1]
        }
        else {
            left <- max(lefties)
            result[i] <- x[left]
            if (Fx[left] < p && left < length(x)) {
                right <- left + 1
                y <- x[left] + (x[right] - x[left]) * (p - Fx[left])/(Fx[right] - 
                  Fx[left])
                if (is.finite(y)) 
                  result[i] <- y
            }
        }
    }
    names(result) <- paste0(format(100 * probs, trim = TRUE), 
        "%")
    return(result)
}

#' @export

weighted.median <- function (x, w, na.rm = TRUE) {
    unname(weighted.quantile(x, probs = 0.5, w = w, na.rm = na.rm))
}

#' @export

switch_ilostat_version <- function(x){

separate (x, sex,c("sex_version"), sep="_", extra = "drop", remove = FALSE) %>%
		mutate(sex_version = gsub('NA', NA,sex_version,  fixed = TRUE) %>% as.factor) %>%
		separate(classif1,c('CODE_CLACL1','CODE_VSCL1'), sep="_", extra = "drop", remove = FALSE) %>%
		unite(	classif1_version,CODE_CLACL1,CODE_VSCL1, sep = "_", remove = TRUE) %>% 
		mutate(classif1_version = gsub('NA_NA', NA,classif1_version, fixed = TRUE)) %>%
		separate(classif2,c('CODE_CLACL1','CODE_VSCL1'), sep="_", extra = "drop", remove = FALSE) %>%
		unite(	classif2_version,CODE_CLACL1,CODE_VSCL1, sep = "_", remove = TRUE) %>%
		mutate(classif2_version = gsub('NA_NA',NA,classif2_version, fixed = TRUE)) %>% 
		mutate(classif1_version = ifelse(str_detect(indicator, "_NOC_"), "NOC", classif1_version)) 
		
}

#' @export

weighted.mean <- function(x, w = NULL, na.rm = TRUE){
    if(missing(w)) {
        ## avoid creating weights vector
        if (na.rm) x <- x[!is.na(x)]
        return(sum(x)/length(x))
    }
    if (length(w) != length(x))
        stop("'x' and 'w' must have the same length")
    w <- as.double(w) # avoid overflow in sum for integer weights.
    if (na.rm) { i <- !is.na(x); w <- w[i]; x <- x[i] }
    sum((x*w)[w != 0])/sum(w) # --> NaN in empty case
}

#' @export

weighted.gini <- function (x, w = NULL, unbiased = FALSE, na.rm = TRUE){
    if (is.null(w)) {
        w <- rep(1, length(x))
    }
	 x <- as.numeric(x)
    w <- as.numeric(w)
    if (na.rm) {
        na <- (is.na(x) | is.na(w))
        x <- x[!na]
        w <- w[!na]
    }
    if (any(is.na(x)) || any(x < 0)) 
        return(NA_real_)
    i.gini <- function(x, w, unbiased = FALSE) {
        w <- w/sum(w)
        x <- x[id <- order(x)]
        w <- w[id]
        f.hat <- w/2 + c(0, head(cumsum(w), -1))
        wm <- weighted.mean(x, w)
        res <- 2/wm * sum(w * (x - wm) * (f.hat - weighted.mean(f.hat, w)))
        if (unbiased) 
            res <- res * 1/(1 - sum(w^2))
        return(res)
    }

        res <- i.gini(x, w, unbiased = unbiased)
    

    return(res)
}

#' @export

weighted.atkinson <- function (x, w = NULL, e = 1, na.rm = TRUE) {


    if (e == 1) {
        A = 1 - prod(x^(w/sum(w)))/(sum(w * x)/sum(w))
    } else {
        A = 1 - ((1/sum(w) * sum(w * (x^(1 - e))))^(1/(1 - e)))/(sum(w * 
            x)/sum(w))
    }
	
	
    return(A)
}

#' @export

weighted.theil <- function (x, w = NULL, na.rm = TRUE) {
    if (is.null(w)) 
        w <- rep(1/length(x), length(x))
    x <- as.numeric(x)
    w <- as.numeric(w)
	if (na.rm) {
        na <- (is.na(x) | is.na(w))
        x <- x[!na]
        w <- w[!na]
    }
	ind = which(!is.na(w) & !is.na(x))
    if (length(ind) == 0) 
        return("Input with NAs only")
    w = w[ind]
    x = x[ind]
    if (!is.numeric(x) | !is.numeric(w)) 
        return("x and w must be numeric")
    return(1/sum(w) * sum(w * (x/(sum(w * x)/sum(w)) * log(x/(sum(w * 
        x)/sum(w))))))
}


#' @export

weighted.kolm <- function (x, w = NULL, parameter = 1, scale = "Standardization", na.rm = TRUE) {
   
    if (is.null(w)) 
        w <- rep(1/length(x), length(x))
    x <- as.numeric(x)
    w <- as.numeric(w)
	if (na.rm) {
        na <- (is.na(x) | is.na(w))
        x <- x[!na]
        w <- w[!na]
    }
   ind = which(!is.na(w) & !is.na(x))
    if (length(ind) == 0) 
        return("Input with NAs only")
    w = w[ind]
    x = x[ind]
    if (!is.numeric(x) | !is.numeric(w)) 
        return("x and w must be numeric")
    if (length(unique(x)) == 1) 
        return(0)
    if (scale == "Standardization") {
        x = (x - mean(x))/sd(x)
    }
    if (scale == "Unitarization") {
        x = (x - min(x))/(max(x) - min(x))
    }
    if (scale == "Normalization") {
        x = x/sqrt(sum(x^2))
    }
    w <- w/sum(w)
    KM <- parameter * (sum(w * x) - x)
    KM <- sum(w * (exp(KM)))
    KM <- (1/parameter) * log(KM)
    return(KM)
}


#' @export

weighted.var.coef <- function (x, w = NULL, square = FALSE, na.rm = TRUE) {

	if (is.null(w)) 
        w <- rep(1/length(x), length(x))
    x <- as.numeric(x)
    w <- as.numeric(w)
	if (na.rm) {
        na <- (is.na(x) | is.na(w))
        x <- x[!na]
        w <- w[!na]
    }

    if (length(unique(x)) == 1) 
        return(0)
    w.m <- sum(w * x)/sum(w)
    V <- sqrt(sum(w * (x - w.m)^2)/sum(w))/w.m
    if (square) {
        return(V^2)
    }
    else {
        return(V)
    }
}


#' @export

weighted.entropy <- function (x, w = NULL, parameter = 0.5, na.rm = TRUE) {
if (is.null(w)) 
        w <- rep(1/length(x), length(x))
    x <- as.numeric(x)
    w <- as.numeric(w)
	if (na.rm) {
        na <- (is.na(x) | is.na(w))
        x <- x[!na]
        w <- w[!na]
    }
    if (length(unique(x)) == 1) 
        return(0)
	if (parameter == 1) 
        e <- weighted.theil(x, w)
    else {
        k <- parameter
        e <- w * (x/(sum(w * x)/sum(w)))^k
        e <- sum(e - 1)/(k * (k - 1))/sum(w)
    }
    return(e)
}


#' @export

weighted.RicciSchutz <- function (x, w = NULL, na.rm = TRUE) {
  if (is.null(w)) 
        w <- rep(1/length(x), length(x))
    x <- as.numeric(x)
    w <- as.numeric(w)
	if (na.rm) {
        na <- (is.na(x) | is.na(w))
        x <- x[!na]
        w <- w[!na]
    }
    if (length(unique(x)) == 1) 
        return(0)
    d <- abs(x - (sum(w * x)/sum(w)))
    d <- (sum(w * d)/sum(w))/(2 * (sum(w * x)/sum(w)))
    return(d)
}

#' @export

Micro_cat_label <- function(var, var.name, add.total = FALSE, indicator){


		if (str_detect(var.name, '_job2_')){var.name <- gsub('_job2_', '_job1_', var.name)}
	
		code <- ilo_tpl$Variable %>% filter(var_name %in%  var.name) %>% 
						.$code_level %>% 
						as.numeric%>% {if (add.total) c(0,.) else . }

		label <- ilo_tpl$Variable %>% filter(var_name %in%  var.name) %>% 
						.$code_label %>% {if (add.total) c('Total',.) else . }

	# }				
	unclass(var) %>% factor(levels = code, labels = label)   
}


weighted.sd <- function(x, w = NULL){

sqrt(Hmisc:::wtd.var(x, w))

}









