#' helper to calculate ilo indicator (volume and ratio) for one time period only
#'
#' faster method to recode, order, add label of categorical variables
#'
#'
#' @param path dta or zip file path for loading ilo microdataset pre precessed, default = NULL.
#' @param ref_area character for selection of country (iso3 code), mandatory if path is not set.
#' @param source character for selection of source (as ilo micro spelling, ie. LFS), mandatory if path is not set.
#' @param time , character, time, use for a specific dataset, default NULL, mandatory if path is not set.
#' @param indicator allow to select a specific indicatr see example, default NULL means that all indicator available will be generate from the microdataset.
#' @param ktest numeric vector, thresholds define to determine whether an indicator is unrealable or not, see section, default c(max = 30, min = 5, threshold = 0.334).
#' @param saveCSV save result in ilostat csv format on the directory of the path, default FALSE, if TRUE tes on scope, indicator, version is done.
#' @param ilo_time force microdataset ilo_time variable to a new define value, ideal to move quarterly data to yearly, default NULL.
#' @param delete thresholds define to determine whether an indicator is unrealable or not, see section.
#' @param collection map in another collection.
#' @param print_ind print indicator processed, default = TRUE.
#' @param keep_count expert only.
#' @param query expert only.
#' @param test expert only.
#' @param skip for excuding a source as character.
#' @param validate only ready file on workflow.
#' @param timefrom query to reduce time as from starting year timefrom.
#' @param timeto query to reduce time as from ending year timeto.
#' @param output if one year one specific indicator, return in ilo template format. Default 'ilostat'.
#'
#' @author ILO / bescond
#' @keywords ILO, microdataset, processing
#' @examples
#' ## Not run:
#'
#' # test that
#'  Micro_process(ref_area = 'ZAF', source = 'QLFS', time = '2016Q1')
#'
#' # process the all time series validate in the workflowflow
#'  Micro_process(ref_area = 'ZAF', source = 'QLFS', print_ind = FALSE, saveCSV = TRUE, validate = TRUE)
#'
#'
#' # run the entire process for one country only
#' Micro_process(collection = 'STI', print_ind = FALSE, validate = TRUE, consolidate = '123',ref_area ='ZAF', source = 'LFS')
#' # run the entire process
#' Micro_process(collection = 'STI', print_ind = FALSE, validate = TRUE, saveCSV = FALSE, consolidate = '123', skip = 'EULFS')
#'
#' ## End(**Not run**)
#' @export


Micro_process <- function(		# path = NULL, 
								ref_area =  NULL,
								source = NULL, 
								time = NULL, 
								indicator = NULL, 
								ktest = c(max = 15, min = 5, threshold = 0.334), 
								saveCSV = TRUE, 
								ilo_time = NULL, 
								delete = FALSE, 
								collection = 'YI', 
								keep_count = TRUE, 
								query = NULL, 
								print_ind = TRUE, 
								validate = FALSE, 
								consolidate = '1', 
								skip = NULL, 
								timefrom = NULL, 
								timeto = NULL, 
								output = 'ilostat', 
								PUB = FALSE){


								# ref_area =  'VNM'
								# source = 'LFS'
								# time = '2017'
								# indicator = 'POP_1524_SEX_MTS_EDU_NB'
								# ktest = c(max = 15, min = 5, threshold = 0.334)
								# saveCSV = FALSE
								# ilo_time = NULL
								# delete = FALSE
								# collection = 'YI'
								# keep_count = TRUE
								# query = NULL
								# print_ind = FALSE
								# validate = TRUE
								# consolidate = '1'
								# skip = NULL
								# timefrom = NULL
								# timeto = NULL
								# output = 'ilostat'
								# test = NULL, 
								# PUB = TRUE




	ilo:::init_ilo(-cl)	
require(stringr)
								
if(str_detect(consolidate, '1')){	
							
	init_wd <- getwd()

	setwd(ilo:::path$micro)

 	workflow <- iloMicro:::Micro_get_workflow(ref_area,
								source, 
								time) %>% filter(str_detect(type, 'Copy|Master')) %>% 
				filter(!processing_status %in% c("Not Usable", "Not started"))

	if(validate) {
			workflow <- workflow %>% 
						filter(processing_status %in% c('Ready', 'Published')) 
			if(PUB) {
				workflow <- workflow %>% 
						filter(processing_status %in% c('Published')) 
			
			}
	}
	
	if(!is.null(ref_area)){
			refref_area <- ref_area
			workflow <- workflow %>% filter(ref_area %in% refref_area) 
			rm(refref_area) 
	}
	if(!is.null(skip)){
			refskip <- skip
			workflow <- workflow %>% filter(!source %in% refskip) 
			rm(refskip) 
	}	
	if(!is.null(source)){
			refsource <- source
			workflow <- workflow %>% filter(source %in% refsource)
			rm(refsource) 
	}
	
	if(!is.null(time)){
			reftime <- time 
			workflow <- workflow %>% filter(time %in% reftime)
			rm(reftime) 
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
	
	pathOutput <- paste0(ilo:::path$data, 'REP_ILO/MICRO/output/')


	for (i in 1:nrow(workflow)){
	
		########## process
	
		if(!is.null(ilo_time)){
				ilo_time <- ilo_time + i-1
		}

		a <- NULL

		if(!workflow$pending[i] %in% NA){ 
				a <- workflow$pending[i]
		}
		
		X <- 	iloMicro:::Micro_process_time(	path = workflow$file[i],  
												indicator  = indicator, 
												ktest = ktest, 
												ilo_time  = ilo_time,  
												delete = delete,
												collection = collection, 
												keep_count = keep_count, 
												query = query, 
												test = a, 
												saveCSV = saveCSV, 
												print_ind = print_ind, 
												output = output)	

		if(!saveCSV){#str_detect(consolidate, '2') | str_detect(consolidate, '3')){
		
			# add break and frequency
			if(!workflow$note_value[i] %in% NA){ 
					X <- X %>% mutate(obs_status = workflow$note_value[i])
			}
			
			if(!workflow$freq_code[i] %in% NA){ 
					X <- X %>% mutate(freq_code = workflow$freq_code[i])
			}
	
			########## prepare folder
			
			if(!dir.exists(paste0(pathOutput, workflow$ref_area[i]))){
					dir.create(paste0(pathOutput, workflow$ref_area[i]), showWarnings = FALSE, recursive = FALSE, mode = "0777")
			}
			
			if(!dir.exists(paste0(pathOutput, workflow$ref_area[i], '/', workflow$source[i]))){
					dir.create(paste0(pathOutput, workflow$ref_area[i], '/', workflow$source[i]), showWarnings = FALSE, recursive = FALSE, mode = "0777")
			}
			
			########## save	
			
			fwrite(X, file  = paste0(pathOutput, workflow$ref_area[i], '/', workflow$source[i], '/', workflow$ref_area[i], '_', workflow$source[i], '_', workflow$time[i], '.csv'), na = '')
		}
		
		if(nrow(workflow) > 1) rm(X)
		
		rm(a)


		invisible(gc(reset = TRUE))
		invisible(gc(reset = TRUE))
		# print(paste0(workflow$ref_area[i], '_', workflow$source[i], '_', workflow$time[i]))
	}
	rm(workflow)
	setwd(init_wd)
							
	invisible(gc(reset = TRUE))
}
	
if(str_detect(consolidate, '2')){

	print('Process quarterly average for monthly dataset !!!!')

	Micro_process_quarterly_from_monthly(ref_area, source, validate, ktest, skip, PUB)


	print('Process annual average for quarterly dataset !!!!')

	Micro_process_annual_from_quarterly(ref_area, source, validate, ktest, skip, PUB)

	Micro_process_annual_from_quarterlyCalculated(ref_area, source, validate, ktest, skip, PUB)

	
	print(paste0('Step 2 OK !!!!  ', Sys.time() ))
}

if(str_detect(consolidate, '3')){
	
	print('Consolidate result  !!!!')
	
	Micro_process_all(ref_area, source, validate, ktest, skip, PUB)
	
	invisible(gc(reset = TRUE))
	
	print(paste0('Step 3 OK !!!!  ', Sys.time() ))
}


try(ilo:::close_ilo(), silent = TRUE)	


	
							
}

Micro_process_volume <- function(	df, 
									indicator, 
									ktest, 
									output = 'asis'){ 


	ref_indicator <- indicator
	rm(indicator)

	# get SELECT store as character vector 
	SELECT <- c(ref_indicator$SELECT   %>% as.character %>% stringr::str_split(', ') %>% unlist %>% .[!. %in% ''], 'sample_count')

	# get FILTER store as a string read as is
	FILTER 		<- ref_indicator$FILTER 	  %>% as.character %>% stringr::str_replace_all(', ', ' & ') %>% gsub('==', '%in%', .)
	
	# get GROUP_BY from ref_indicator store as character vector
	GROUP_BY 	<- ref_indicator$GROUP_BY  %>% as.character %>% stringr::str_split(', ') %>% unlist %>% .[!. %in% '']
	
	# get SUMMARISE from ref_indicator store as a string read as is
	SUMMARISE 	<- ref_indicator$SUMMARISE %>% as.character 

	# reduce and filter df base on ref_indicator instruction
 df %>% 	
		select_(.dots = SELECT)
	df <- df %>% 	
		select_(.dots = SELECT) %>% 
		mutate(ilo_time = ilo_time  %>% as.character) %>%
		mutate_if(is.factor, funs(unclass)) %>% 
		filter_(FILTER)

	if(nrow(df) == 0) {
		print(paste0('ERROR to build indicator ', ref_indicator$ID, '!!! One component of the filter is probably missing !!!!'))
		return(NULL)
	}

		
	## Exception set up X for EMP_TEMP_SEX_EC2_NB & EMP_TEMP_SEX_EC2_NB
		
			
		if(stringr::str_sub(ref_indicator$indicator, -6, -4)%in% c('EC2')){
			if(length(SELECT[SELECT %in% "ilo_job1_eco_isic4_2digits"]) == 1){
				test_code <- ilo_tpl$Variable %>% filter(var_name %in% 'ilo_job1_eco_isic4_2digits')%>% .$code_level %>% as.numeric
				df <- df %>% mutate(ilo_job1_eco_isic4_2digits = ifelse(!ilo_job1_eco_isic4_2digits %in% test_code, 999, ilo_job1_eco_isic4_2digits))
			}
			if(length(SELECT[SELECT %in% "ilo_job1_eco_isic3_2digits"]) == 1){
				test_code <- ilo_tpl$Variable %>% filter(var_name %in% 'ilo_job1_eco_isic3_2digits')%>% .$code_level %>% as.numeric
				df <- df %>% mutate(ilo_job1_eco_isic3_2digits = ifelse(!ilo_job1_eco_isic3_2digits %in% test_code, 999, ilo_job1_eco_isic3_2digits))
			} 
		}
		
		if(stringr::str_sub(ref_indicator$indicator, -6, -4)%in% c('OC2')){
			if(length(SELECT[SELECT %in% "ilo_job1_ocu_isco08_2digits"]) == 1){
				test_code <- ilo_tpl$Variable %>% filter(var_name %in% 'ilo_job1_ocu_isco08_2digits')%>% .$code_level %>% as.numeric
				df <- df %>% mutate(ilo_job1_ocu_isco08_2digits = ifelse(!ilo_job1_ocu_isco08_2digits%in% test_code, 999, ilo_job1_ocu_isco08_2digits))
			}
			if(length(SELECT[SELECT %in% "ilo_job1_ocu_isco88_2digits"]) == 1){
				test_code <- ilo_tpl$Variable %>% filter(var_name %in% 'ilo_job1_ocu_isco88_2digits')%>% .$code_level %>% as.numeric
				df <- df %>% mutate(ilo_job1_ocu_isco88_2digits = ifelse(!ilo_job1_ocu_isco88_2digits %in% test_code, 999, ilo_job1_ocu_isco88_2digits))
			}
		}
		
		
	# STEP 1
	# 	GROUP_BY ilo_time and all possibilities of classifs (sex, classif1, classif2) (1,2,3 or 1,2 or 2,3, or 1 or na) 
	#	ie. ilo_sex, ilo_age, ilo_edu OR ilo_sex, ilo_age OR ilo_eco, ilo_ocu OR ilo_sex OR na 
	res <- df %>% 
			group_by_(.dots = GROUP_BY) %>% 
			summarise_(	obs_value = SUMMARISE, 
						sample_count = 'sum(sample_count)', 
						ilo_wgt = 'sum(ilo_wgt)') %>% 
			ungroup 

			
	# STEP 2					
	# GROUP_BY ilo_time only, delete all key variables from GROUP_BY				
	res <- res %>% 
		bind_rows(
		df %>% 
			group_by_(.dots = GROUP_BY[1]) %>% 
			summarise_(	obs_value = SUMMARISE, 
						sample_count = 'sum(sample_count)', 
						ilo_wgt = 'sum(ilo_wgt)') %>% 
			ungroup  %>% 
			# set to 0 the key variables delete (0 label = 'Total')
			{if(length(GROUP_BY) > 1) mutate_(., .dots = setNames(list(~0), GROUP_BY[2]))  else  .} %>% 
			{if(length(GROUP_BY) > 2) mutate_(., .dots = setNames(list(~0), GROUP_BY[3]))  else  .} %>% 
			{if(length(GROUP_BY) > 3) mutate_(., .dots = setNames(list(~0), GROUP_BY[4]))  else  .}
		) 					
					

	# STEP 3					
	# GROUP_BY ilo_time and possibilities -1 of classifs (sex, classif1, classif2 or sex, classif1 or classif1, classif2)
	# ie. 123 is tested as 12, 13, 23; 12 as 1, 2 
	if(length(GROUP_BY) > 2){
		for (j in seq_along(GROUP_BY)[-1]){ # Permutation, delete one of the key variables group
			res <- res %>% 
				bind_rows(
					df %>% 
						group_by_(.dots = GROUP_BY[-j]) %>% 
						summarise_(	obs_value = SUMMARISE, 
									sample_count = 'sum(sample_count)', 
							ilo_wgt = 'sum(ilo_wgt)') %>% 
						ungroup %>%
						# set to 0 the key variable delete (0 label = 'Total')
						mutate_( .dots = setNames(list(~0), c(GROUP_BY[j])))
				) 
		}		
	}


	# STEP 4
	# GROUP_BY ilo_time and possibilities -2 of classifs (sex, classif1, classif2)
	# ie. 123 is tested as 1, 2, 3 
	if(length(GROUP_BY) > 3){  
		for (j in seq_along(GROUP_BY)[-1]){ # Permutation, delete two of the key variables group
			res <- res %>% 
				bind_rows( 
					df %>% 
						group_by_(.dots = GROUP_BY[c(1,j)]) %>% 
						summarise_(	obs_value = SUMMARISE, 
									sample_count = 'sum(sample_count)', 
							ilo_wgt = 'sum(ilo_wgt)') %>% 
						ungroup  %>%
						# set to 0 the key variables delete (0 label = 'Total')
						mutate_( .dots = setNames(list(~0), c(GROUP_BY[-c(1, j)])[1])) %>% 
						mutate_( .dots = setNames(list(~0), c(GROUP_BY[-c(1, j)])[2]))
				) %>% as.tbl
		}
	}


	# STEP 5
	# re factor GROUP_BY key variables, ie. add labels

	for (j in seq_along(GROUP_BY)[-1]){
		
		eval(parse(text = paste0("res <- res %>% mutate(",GROUP_BY[j]," = ",GROUP_BY[j]," %>% Micro_cat_label('",GROUP_BY[j],"', add.total = TRUE, indicator = ref_indicator$indicator[1]) %>% as.character)")))
	}




	# sort by GROUP_BY key variables, rearrange columns order and names
	res <- res %>% 	
				arrange_(.dots = GROUP_BY) %>% 
				mutate(indicator = ref_indicator$indicator_label) %>% 
				rename(time = ilo_time) %>% 
				select(indicator, contains('ilo_'),time,obs_value, sample_count) %>% 
				mutate_if(is.factor, funs(as.character))


	# STEP 6 ############################
	# output in ilostat format  
	if (output %in% 'ilostat'){

		res <- res %>% mutate(indicator = ref_indicator$indicator %>% as.character)

		if(length(GROUP_BY) == 1) {
			
			res <- res %>% mutate(sex= as.character(NA), classif1 = as.character(NA), classif2 = as.character(NA))
		} else {
		
			for (j in seq_along(GROUP_BY)[-1]){
			
				refvar <- gsub('job1_','',GROUP_BY)
				refvar <- gsub('job2_','',refvar)
				refvar <- gsub('joball_','',refvar)
				refvar <- gsub('ilo_prev','ilo_',refvar)
			
				ref <- ilo_tpl$Mapping_classif %>% filter_(paste0("SELECT %in% '",refvar[j],"'")) 
				eval(parse(text = paste0("res <- res %>% mutate(",GROUP_BY[j]," = ",GROUP_BY[j]," %>% factor(levels = as.character(ref$ilostat_classif_label), labels = as.character(ref$ilostat_classif_code)) %>% as.character)")))
			}

			if(length(GROUP_BY[GROUP_BY %in% 'ilo_sex']) == 0){	
				res <- res %>% mutate(sex= as.factor(NA))
			} else {res <- res %>% rename(sex = ilo_sex)}
		}

		GROUP_BY <- GROUP_BY[!GROUP_BY %in% c('ilo_time','ilo_sex')]

		if(length(GROUP_BY) == 0 ) { 
			
				res <- res %>% mutate(classif1 = as.character(NA), classif2 = as.character(NA))
			
		}
		if(length(GROUP_BY) == 1 ) {
			
			eval(parse(text = paste0("res <- res %>% rename(classif1 = ",GROUP_BY[1],")")))
			
			res <- res %>% mutate(classif2 = as.character(NA))
			
		}
		if(length(GROUP_BY) == 2 ) {
		
			eval(parse(text = paste0("res <- res %>% rename(classif1 = ",GROUP_BY[1],")")))
			
			eval(parse(text = paste0("res <- res %>% rename(classif2 = ",GROUP_BY[2],")")))
			
		}

	res <- res %>% select(indicator, sex, classif1, classif2, time, obs_value, sample_count, ilo_wgt) 

	
}



	########### Exception remapping fro calculation of EMP_TEMP_SEX_ECO2_NB and EMP_TEMP_SEX_OCU2_NB

		if(stringr::str_sub(ref_indicator$indicator, -7, -4)%in% c('ECO2', 'OCU2')){
		

			res <- res %>% filter(!str_detect(classif1 , '_TOTAL')) %>% 
						mutate(classif1 = classif1 %>% mapvalues(from = c("EC2_ISIC4_A01", "EC2_ISIC4_A03", "EC2_ISIC4_C10", "EC2_ISIC4_C11", "EC2_ISIC4_C13", "EC2_ISIC4_C14", "EC2_ISIC4_C21", "EC2_ISIC4_C31", "EC2_ISIC4_E36", "EC2_ISIC4_F41", "EC2_ISIC4_G46", "EC2_ISIC4_G47", "EC2_ISIC4_H49", "EC2_ISIC4_I55", "EC2_ISIC4_I56", "EC2_ISIC4_J61", "EC2_ISIC4_K64", "EC2_ISIC4_K65", "EC2_ISIC4_N78", "EC2_ISIC4_Q86"), 
																	to = c("ECO_ISIC4_A_01", "ECO_ISIC4_A_03", "ECO_ISIC4_C_10", "ECO_ISIC4_C_11", "ECO_ISIC4_C_13", "ECO_ISIC4_C_14", "ECO_ISIC4_C_21", "ECO_ISIC4_C_31", "ECO_ISIC4_E_36", "ECO_ISIC4_F_41", "ECO_ISIC4_G_46", "ECO_ISIC4_G_47", "ECO_ISIC4_H_49", "ECO_ISIC4_I_55", "ECO_ISIC4_I_56", "ECO_ISIC4_J_61", "ECO_ISIC4_K_64", "ECO_ISIC4_K_65", "ECO_ISIC4_N_78", "ECO_ISIC4_Q_86"), warn_missing =  FALSE)) %>% 
						mutate(classif1 = classif1 %>% mapvalues(from = c("OC2_ISCO08_11", "OC2_ISCO08_12", "OC2_ISCO08_14", "OC2_ISCO08_22", "OC2_ISCO08_23", "OC2_ISCO08_25", "OC2_ISCO08_32", "OC2_ISCO08_33", "OC2_ISCO08_41", "OC2_ISCO08_42", "OC2_ISCO08_51", "OC2_ISCO08_52", "OC2_ISCO08_61", "OC2_ISCO08_63", "OC2_ISCO08_71", "OC2_ISCO08_74", "OC2_ISCO08_81", "OC2_ISCO08_83", "OC2_ISCO08_91", "OC2_ISCO08_92", "OC2_ISCO08_93"), 
																	to = c("OCU_ISCO08_1_11", "OCU_ISCO08_1_12", "OCU_ISCO08_1_14", "OCU_ISCO08_2_22", "OCU_ISCO08_2_23", "OCU_ISCO08_2_25", "OCU_ISCO08_3_32", "OCU_ISCO08_3_33", "OCU_ISCO08_4_41", "OCU_ISCO08_4_42", "OCU_ISCO08_5_51", "OCU_ISCO08_5_52", "OCU_ISCO08_6_61", "OCU_ISCO08_6_63", "OCU_ISCO08_7_71", "OCU_ISCO08_7_74", "OCU_ISCO08_8_81", "OCU_ISCO08_8_83", "OCU_ISCO08_9_91", "OCU_ISCO08_9_92", "OCU_ISCO08_9_93"), warn_missing =  FALSE)) %>% 
						filter(!classif1 %in% NA)
		}

		if(stringr::str_sub(ref_indicator$indicator, -6, -4)%in% c('EC2')){
			test_vs <- unique(str_sub(res$classif1,1,9)) 
			test_vs <- test_vs[!test_vs %in% NA]
			 if(test_vs %in% 'EC2_ISIC4'){
			
				res <- res %>% mutate(classif1 = ifelse(classif1 %in% NA, 'EC2_ISIC4_X', classif1))
				
				
			}
			 if(test_vs %in% 'EC2_ISIC3'){
			
				res <- res %>% mutate(classif1 = ifelse(classif1 %in% NA, 'EC2_ISIC3_X', classif1))
			}		
			
			
			rm(test_vs)	
			
			test_unknow <- res %>% distinct(classif1) %>% filter(stringr:::str_sub(classif1,-2,-1) %in% '_X')
			if(nrow(test_unknow) == 1){
			
				res <- res %>% group_by(indicator, sex, classif1, classif2, time) %>% 
						summarise(	obs_value = sum(obs_value, na.rm = TRUE), 
									sample_count = sum(sample_count, na.rm = TRUE), 
									ilo_wgt = sum(ilo_wgt, na.rm = TRUE)) %>% 
						ungroup
			
			}
			rm(test_unknow)
			
			
			
		}
		if(stringr::str_sub(ref_indicator$indicator, -6, -4)%in% c('OC2')){
			test_vs <- unique(str_sub(res$classif1,1,10))
			test_vs <- test_vs[!test_vs %in% NA]
			 if(test_vs %in% 'OC2_ISCO88'){
			
				res <- res %>% mutate(classif1 = ifelse(classif1 %in% NA, 'OC2_ISCO88_X', classif1))
			}
			 if(test_vs %in% 'OC2_ISCO08'){
			
				res <- res %>% mutate(classif1 = ifelse(classif1 %in% NA, 'OC2_ISCO08_X', classif1))
			}	
			rm(test_vs)
			test_unknow <- res %>% distinct(classif1) %>% filter(stringr:::str_sub(classif1,-2,-1) %in% '_X')
			if(nrow(test_unknow) == 1){
			
				res <- res %>% group_by(indicator, sex, classif1, classif2, time) %>% 
						summarise(	obs_value = sum(obs_value, na.rm = TRUE), 
									sample_count = sum(sample_count, na.rm = TRUE), 
									ilo_wgt = sum(ilo_wgt, na.rm = TRUE)) %>% 
						ungroup
			
			}
			rm(test_unknow)
			
		}			
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	# add note at indicator level
	note_ind <- ilo_tpl$Note %>% filter(ilostat_code %in% ref_indicator$rep_var) %>% select(ilostat_note_code)
	note_ind <- ifelse(nrow(note_ind)==0 | note_ind %in% '', as.character(NA), note_ind %>% t %>% as.character %>% unique)	

	# test releability
	res <- res %>% 	mutate(note_classif =  as.character(NA) , 
						note_indicator = note_ind) %>% 
				mutate( obs_status = as.character(NA), 
						sample_count = as.numeric(sample_count),
						obs_status = ifelse(sample_count < ktest[1],'U',  obs_status), 
						obs_status = ifelse(sample_count < ktest[2],'S',  obs_status), 
						table_test = as.character(NA)) 
			del <- res %>% count(obs_status) %>% filter(obs_status %in% 'S') %>% .$n / nrow(res)
			res <- res %>% mutate(table_test = round(ifelse(length(del)>0,del, 0), 2)) %>%
					mutate_if(Negate(is.numeric) , funs(as.character))
			rm(del)
	
	# add currency
	if(stringr::str_sub(ref_indicator$indicator, 1, 3)%in% 'EAR'){
		cou_ref <- ilo_tpl$Note %>% filter(var_name %in% 'ilo_country') %>% select(ilostat_code) %>% t %>% as.character
		cur_ref <- ilo$code$cl_note_currency %>% filter(code_Geo %in% cou_ref) %>% slice(1) %>% select(code) %>% t %>% as.character
		res <- res %>% mutate( note_indicator = paste0(note_indicator, '_', cur_ref))
		rm(cur_ref, cou_ref)
	}		
	
	# check missing note
	res <- res %>% mutate(note_indicator = ifelse(stringr:::str_sub(note_indicator,-1,-1) %in% '_', stringr:::str_sub(note_indicator,1,-2), note_indicator))
	
	# add note at classif level
	# from sex

	note_sex <- ilo_tpl$Note %>% 
					filter(ilostat_code %in% unique(res$sex), !ilostat_code %in% NA, !ilostat_note_code %in% NA) %>% 
					select(sex = ilostat_code, note_sex = ilostat_note_code)
					
	if(nrow(note_sex) >0){
		res <- res %>% 
				left_join(note_sex, by = 'sex') %>% 
				mutate(note_classif = ifelse(!note_sex %in% NA, as.character(note_sex), as.character(note_classif))) %>% 
				select(-note_sex) %>% as.tbl
	}	
	rm(note_sex)

	# from classif1

	note_clas1 <- ilo_tpl$Note %>% 
					filter(ilostat_code %in% unique(res$classif1), !ilostat_code %in% NA, var_name %in% GROUP_BY, !ilostat_note_code %in% NA) %>%
					select(classif1 = ilostat_code, note_clas1 = ilostat_note_code)  %>% distinct(classif1, note_clas1)
	if(nrow(note_clas1) >0){
		res <- res %>% 
				left_join(note_clas1, by = 'classif1') %>% 
				mutate( note_classif = ifelse(note_classif %in% NA, note_clas1, paste0(note_clas1, '_', note_classif)), 
						note_classif = ifelse(stringr::str_sub(note_classif,1,3) %in% 'NA_',stringr::str_sub(note_classif,4,-1), note_classif)) %>% 
				select(-note_clas1)  %>% as.tbl
		}
	rm(note_clas1)		
	
	# from classif2
	note_clas2 <- ilo_tpl$Note %>% 
					filter(ilostat_code %in% unique(res$classif2), !ilostat_code %in% NA, !ilostat_note_code %in% NA) %>% 
					mutate_all(funs(as.character)) %>% 
					select(classif2 = ilostat_code, note_clas2 = ilostat_note_code) %>% distinct(classif2, note_clas2)
	if(nrow(note_clas2) >0){
		res <- res %>% 
				left_join(note_clas2, by = 'classif2') %>% 
				mutate( note_classif = ifelse(note_classif %in% NA, note_clas2, paste0(note_clas2, '_', note_classif)), 
						note_classif = ifelse(stringr::str_sub(note_classif,1,3) %in% 'NA_',stringr::str_sub(note_classif,4,-1), note_classif)) %>% 
				select(-note_clas2)  %>% as.tbl
	}
	rm(note_clas2)	

	# order variable and return res			
	res %>% select(indicator:obs_value, obs_status, contains('note_'), sample_count, table_test, ilo_wgt) %>%
				mutate_all(funs(as.character)) %>% mutate_at(vars(obs_value,sample_count, table_test, ilo_wgt), funs(as.numeric)) %>% as.tbl


}


Micro_process_ratio <- function( 	df, 
									indicator,  
									ktest){

	ref_indicator <- indicator # ref_available_ratio%>% slice(i)
	rm(indicator)
	GROUP_BY 		<- ref_indicator$GROUP_BY 	  %>% as.character %>% stringr::str_split(', ') %>% unlist %>% .[!. %in% '']
	# FILTER 			<- ref_indicator$FILTER 	  %>% as.character %>% gsub('==', '%in%', .)
	# MUTATE 			<- ref_indicator$MUTATE 	  %>% as.character 
	SUMMARISE 		<- ref_indicator$SUMMARISE %>% as.character 

	# reduce and filter df base on ref_indicator instruction
	ref_component <- df %>% as.tbl %>% iloMicro:::Micro_process_test(view = F) %>% 
						select(indicator:indicator_label) %>% 
						filter(	stringr::str_sub(indicator,-2,-1) %in% 'NB') %>% 
						filter_(paste0("indicator %in% c('",paste0(GROUP_BY, collapse = "', '"),"')")) %>% 
						# rename(sex = sex_var, classif1 = classif1_var, classif2 = classif2_var) %>% 
						# filter_(FILTER)
	# ref_component <- eval(parse(text = paste0('ref_component %>% mutate(',MUTATE,')')))
	
	# ref_component <- ref_component %>% rename(sex_var = sex, classif1_var = classif1, classif2_var = classif2)  %>%
						filter(	sex_var %in% ref_indicator$sex_var, 
								classif1_var %in% ref_indicator$classif1_var, 
								classif2_var %in% ref_indicator$classif2_var )


	# ref_component <- eval(parse(text = paste0('ref_component %>% mutate(',MUTATE,')'))) 				
	
	ref <- NULL
	for (i in 1:nrow(ref_component)){

		note_sou <- ilo_tpl$Note %>% 
				filter(var_name %in% c('ilo_country', 'ilo_source') & !ilostat_note_code %in% NA) %>% 
				summarise(test = paste0(ilostat_note_code, collapse = '_')) %>% 
				t %>% as.character 

		test <- df %>% iloMicro:::Micro_process_volume(ref_component %>% slice(i), output = 'ilostat', ktest) 

		ref <- bind_rows( test, ref) 
				
	}
	# ref <- ref %>% filter_(FILTER)
	# ref <- eval(parse(text = paste0('ref %>% mutate(',MUTATE,')'))) 
	

	res <- eval(parse(text = paste0('ref %>% rename(',GROUP_BY[1],' = obs_value)'))) %>% filter(indicator %in% GROUP_BY[1])

	for (i in 2:length(GROUP_BY)){

		test <- ref %>% filter(indicator %in% GROUP_BY[i]) %>% select(sex, classif1, classif2, time, obs_value)
		test <- eval(parse(text = paste0('test %>% rename(',GROUP_BY[i],' = obs_value)'))) 
		res <- res %>% left_join( test,by = c("sex", "classif1", "classif2", "time"))
		rm(test)

	}

	rm(ref)

	res %>% mutate(indicator = as.character(ref_indicator$indicator)) %>% 
			mutate_(obs_value = SUMMARISE) %>% 
			select(indicator, sex, classif1, classif2, time, obs_value, obs_status, dplyr::contains('note_'), sample_count, table_test, ilo_wgt)

}


Micro_process_test <- function(df , view = TRUE){

	df <- df %>% mutate_if(is.labelled, funs(zap_labels)) 

	.col = df %>% select(contains('ilo_')) %>% colnames

		 
	ilo_tpl$Mapping_indicator$Available <- NA 
	
	for ( i in 1:nrow(ilo_tpl$Mapping_indicator)) {
		ref <- strsplit(as.character(ilo_tpl$Mapping_indicator$SELECT)[i], ', ') %>% unlist
		ref <- ref[!ref %in% '']
		if (length(unique(ref %in% .col)) %in% 1 ){
			if(unique(ref %in% .col)){
				ilo_tpl$Mapping_indicator$Available[i] <- 1 
			}
		}
		rm(ref)
	}
	
	if(view){	
		out <- ilo_tpl$Mapping_indicator %>% select(indicator, Available) %>% 
				group_by(indicator) %>% 
				summarise(Available = sum(Available, na.rm = TRUE), Max = n()) %>% ungroup %>%
				mutate(label = as.character(indicator) %>% factor( 	levels = unique(ilo_tpl$Mapping_indicator$indicator), 
																	labels = unique(ilo_tpl$Mapping_indicator$indicator_label), exclude = NULL)) %>% 
				select(indicator, label, Available, Max) %>% as.data.frame
	}	

	if(!view){
		out <- ilo_tpl$Mapping_indicator %>% filter(Available %in% 1) 
	}	
	out	
	
}



Micro_process_time <- function(		path = NULL, 
							ref_area =  NULL,
							source = NULL, 
							time = NULL, 
							indicator = NULL, 
							ktest = c(max = 15, min = 5, threshold = 0.334), 
							saveCSV = TRUE, 
							ilo_time = NULL, 
							delete = FALSE, 
							collection = 'YI', 
							keep_count = TRUE, 
							query = NULL, 
							test = NULL, 
							print_ind = TRUE, 
							output = 'ilostat'){
# path = path = workflow$file[i]; indicator = NULL; ktest = c(max = 30, min = 5, threshold = 0.2); saveCSV = FALSE; ilo_time = '1950'; delete = FALSE


	if (is.null(path)){
	if(is.null(ref_area) | is.null(source) | is.null(time) ){return('error plse specify path or ref_area AND source AND time')}
	if(!(is.null(ref_area) | is.null(source) | is.null(time)) ){ path <- paste0(ilo:::path$micro, ref_area, '/', source, '/', time, '/', ref_area, '_', source, '_', time, '_ILO.dta')}
	}


	df <- iloMicro:::Micro_load(path, ilo_time, query, Pending = test) %>% as.tbl %>% filter(!ilo_wgt %in% c(NA, 0)) %>% select(-contains('ilo_key'), -contains('job2_'))

	df <- df %>% group_by_(.dots = colnames(df)[!colnames(df) %in% 'ilo_wgt']) %>% summarise(sample_count = n(), ilo_wgt = sum(ilo_wgt)) %>% ungroup
	invisible(gc(reset = TRUE))
	invisible(gc(reset = TRUE))
	
##################### try to rebuilt aggregate variable	
	

	try(df <- df %>% mutate(	ilo_age_ythadult  		= ilo_age_aggregate 		%>% plyr:::mapvalues(from = c(2,3,4,5), 		to = c(1,2,2,2)			)), silent = TRUE) # age_ythadult 	
	try(df <- df %>% mutate(	ilo_job1_eco_sector  	= ilo_job1_eco_aggregate 	%>% plyr:::mapvalues(from = c(1,2,3,4,5,6,7), 	to = c(1,2,2,2,3,3,4) 	)), silent = TRUE) # eco_sector 	
	try(df <- df %>% mutate(	ilo_preveco_sector  	= ilo_preveco_aggregate		%>% plyr:::mapvalues(from = c(1,2,3,4,5,6,7), 	to = c(1,2,2,2,3,3,4) 	)), silent = TRUE) # eco_sector 	
	try(df <- df %>% mutate(	ilo_job1_eco_agnag  	= ilo_job1_eco_aggregate 	%>% plyr:::mapvalues(from = c(1,2,3,4,5,6,7), 	to = c(1,2,2,2,2,2,2) 	)), silent = TRUE) # eco_agnag 	 to add  warn_missing = FALSE
	
	invisible(gc(reset = TRUE))
	invisible(gc(reset = TRUE))
	
	
	note_sou <- ilo_tpl$Note %>% filter(var_name %in% c('ilo_country', 'ilo_source') & !ilostat_note_code %in% NA) %>% summarise(test = paste0(ilostat_note_code, collapse = '_')) %>% t %>% as.character 
	note_sou <- ifelse(note_sou %in% '', 'R1:3513', paste0('R1:3513_',note_sou))
	
	# allowed specific indicator	
	ref_available_volume <- df %>% iloMicro:::Micro_process_test(view = F) %>% filter(stringr::str_sub(indicator,-2,-1) %in% 'NB') %>% mutate(ref_ind = paste(rep_var, sex_var, classif1_var, classif2_var, sep = '/') %>% stringr::str_replace_all(stringr::fixed('/NA'), ''))
	if (!is.null(indicator)){
		ref <- indicator
		test <- stringr::str_split(ref,pattern = '/') %>% unlist
		if(nchar(test[1]) %in% 11) {ref_available_volume <- ref_available_volume %>% mutate(refvar  = rep_var)
		} else {ref_available_volume <- ref_available_volume %>% mutate(refvar  = indicator)}
		
		if(length(test) > 1) {
			ref_available_volume <- ref_available_volume %>% mutate(refvar = paste(refvar, sex_var, classif1_var, classif2_var, sep = '/') %>% stringr::str_replace(stringr::fixed('/NA'), ''))
		}
		ref_available_volume <- ref_available_volume %>% filter(refvar %in% ref) %>% select(-refvar)
		rm(ref)
	}
	ref_available_ratio <- df %>% iloMicro:::Micro_process_test(view = F)  %>% filter(stringr::str_sub(indicator,-2,-1) %in% 'RT') %>% mutate(ref_ind = paste(rep_var, sex_var, classif1_var, classif2_var, sep = '/') %>% stringr::str_replace_all(stringr::fixed('/NA'), ''))
	if (!is.null(indicator)){
		ref <- indicator
		test <- stringr::str_split(ref,pattern = '/') %>% unlist
		if(nchar(test[1]) %in% 11) {ref_available_ratio <- ref_available_ratio %>% mutate(refvar  = rep_var)
		} else {ref_available_ratio <- ref_available_ratio %>% mutate(refvar  = indicator)}
		
		if(length(test) > 1) {
			ref_available_ratio <- ref_available_ratio %>% mutate(refvar = paste(refvar, sex_var, classif1_var, classif2_var, sep = '/') %>% stringr::str_replace(stringr::fixed('/NA'), ''))
		}
		ref_available_ratio <- ref_available_ratio %>% filter(refvar %in% ref) %>% select(-refvar)
		rm(ref)
	}
	if(nrow(ref_available_volume) == 0 & nrow(ref_available_ratio) == 0){print('indicator not available') ; return(NULL)}
	
	volume <- NULL	

	if(nrow(ref_available_volume)> 0){
		for (i in 1:nrow(ref_available_volume)){
			test <- df %>% iloMicro:::Micro_process_volume(indicator = ref_available_volume %>% slice(i), ktest, output = output) 
			if(!is.null(test)) {
				volume <- bind_rows( test %>% mutate(ref = i), volume) %>% mutate(note_source = note_sou) %>% arrange(ref)
			}
			if (print_ind) print(paste0(i , " / ", nrow(ref_available_volume), ' : ',  ref_available_volume$ref_ind[i]))
		}
		rm(test, i, ref_available_volume)
		invisible(gc(reset = TRUE))
		volume <- volume %>% select(-ref)
	}

	ratio <- NULL

	if(nrow(ref_available_ratio)> 0){
		for (i in 1:nrow( ref_available_ratio)){
			test <- df %>% iloMicro:::Micro_process_ratio(indicator = ref_available_ratio%>% slice(i), ktest)
			ratio <- bind_rows( ratio, test) %>% mutate(note_source = note_sou)
			if (print_ind) print(paste0(i , " / ", nrow(ref_available_ratio), ' : ',  ref_available_ratio$ref_ind[i]))	
		}
		rm(test, ref_available_ratio, i)
		invisible(gc(reset = TRUE))
	}

	
	final <- bind_rows(volume, ratio) %>% 
				mutate(	ref_area = 	ilo_tpl$Note %>% 
											filter(var_name %in% 'ilo_country') %>% .$ilostat_code, 
						source = 	ilo_tpl$Note %>% filter(var_name %in% 'ilo_source') %>% .$ilostat_code) %>% 
				select(ref_area, source, indicator, sex, classif1, classif2, time, obs_value, obs_status, contains('note_'), sample_count, table_test, ilo_wgt)

	if (delete){
		final <- final %>% 
				filter(table_test < ktest[3]) %>%	
				select(-contains('sample_count'), -contains('table_test'), -contains('ilo_wgt')) %>% 
				mutate(obs_value = ifelse(obs_status %in% 'S',as.numeric(NA),  obs_value))
	
	} 
	
	rm(volume, ratio) ; invisible(gc(reset = TRUE))

		
	
	
	if(nrow(final) == 0){
		print(paste0(file.path(dirname(path[1]))))
		print('no indicator calculated !!! '); return(NULL)
	} else{		
		print(paste0(file.path(dirname(path[1]))))

		collection_ <- collection
		test <- colnames(final)
		final <- final %>% mutate(	collection = collection_) %>% 
							select_(.dots = c('collection',test) ) 
		

									
									
		if(!keep_count) {final <- final %>% select(-sample_count, -table_test, -ilo_wgt)}
		
	
		if(saveCSV){			
			
			############ make test on scope
			final <- ilo:::check_ilo(final, scope)
			check_scope <- final %>% filter(!check)
			if(nrow(check_scope)>0) {	
										print(paste0('Check on scope failed for ',nrow(check_scope),' record(s) contain on:'))
										check_scope <- check_scope %>% ilo:::switch_ilo(version) %>% distinct(indicator, sex_version, classif1_version, classif2_version)
										print(check_scope, quote = TRUE, row.names = FALSE)
							}	
			rm(check_scope)
		
			############ make test on indicators
			iloMicro:::Micro_load(path = NULL)
			ilo_test_indicator <-ilo_tpl$Mapping_indicator %>% filter(Is_Validate %in% c(TRUE, 'TRUE', 1)) %>% select(ID) %>% t %>% c
			final <- final %>% 	ilo:::switch_ilo(version) %>% 
						tidyr:::unite(ID, sex_version, classif1_version, classif2_version, sep = '/', remove = TRUE) %>% 
						mutate(	ID = paste0(stringr:::str_sub(indicator, 1,8),  stringr:::str_sub(indicator, -3,-1), '/', ID),
								ID = ID %>% stringr:::str_replace_all('/NA', ''), 
								ID = ID %>% stringr:::str_replace_all('/', ''))
			final <- final %>% filter(ID %in% ilo_test_indicator) %>% select(-ID)
			rm(ilo_test_indicator)
			
			
			############ make test on indicators ilostat
			final <- ilo:::check_ilo(final %>% select(-check), indicator)
			check_indicator <- final %>% filter(!check)
			if(nrow(check_indicator)>0) {	print(paste0('Check on indicator failed for ',length(unique(check_indicator$indicator)),' indicator(s) below:'))
										check_indicator <- check_indicator %>% distinct(indicator)
										print(check_indicator, quote = TRUE, row.names = FALSE)
										print('defacto check on indicator/version is not done')
										
							}		
		
			final <- ilo:::check_ilo(final %>% select(-check), version)
			check_version <- final %>% filter(!check)

			if(nrow(check_version)>0 & nrow(check_indicator)==0) {	check_version <- check_version %>% ilo:::switch_ilo(version) %>% distinct(indicator, sex_version, classif1_version, classif2_version)
										print(paste0('Check indicator/version failed for ',nrow(check_version), ' record(s), plse check following indicator/version:'))
										print(check_version, quote = TRUE, row.names = FALSE)
							}		
			
			final %>% select(-check) 	%>% fwrite(file = file.path(dirname(path[1]), paste0(stringr::str_sub(basename(path[1]),1,-5), '_ilostat.csv')))
			final <- final %>% select(-check)

		} else {

		final
		
		}
}

}

Micro_process_annual_from_quarterlyCalculated <- function(	ref_area =  NULL,
													source = NULL, 
													validate = TRUE, 
													ktest = c(max = 15, min = 5, threshold = 0.334), 
													skip = NULL, 
													PUB = FALSE){
	init_wd <- getwd()
	
	setwd(ilo:::path$micro)
	
	pathOutput <- paste0(ilo:::path$data, 'REP_ILO/MICRO/output/')
	
	workflow <- iloMicro:::Micro_get_workflow(ref_area, source) %>% filter(str_detect(type, 'Copy|Master'))

	if(validate) {workflow <- workflow %>% filter(processing_status %in% c('Ready', 'Published'), CC_ilostat %in% 'Yes', !freq_code %in% NA) }
	if(validate & PUB) {workflow <- workflow %>% filter(processing_status %in% c('Published'), CC_ilostat %in% 'Yes', !freq_code %in% NA) }
	
	if(!is.null(ref_area)){refref_area <- ref_area; workflow <- workflow %>% filter(ref_area %in% refref_area); rm(refref_area) }
	
	if(!is.null(source)){refsource <- source; workflow <- workflow %>% filter(source %in% refsource); rm(refsource) }
	
	if(!is.null(skip)){
			refskip <- skip
			workflow <- workflow %>% filter(!source %in% refskip) 
			rm(refskip) 
	}
	reference_wf <-  workflow %>% filter(stringr::str_sub(time,5,5) %in% c('')) %>% mutate(year = stringr::str_sub(time,1,4) ) %>% distinct(ref_area, source, year)
	workflow <- workflow %>% filter(level %in% c('M')) 
	
	
	iloMicro:::Micro_load(path = NULL)

if(nrow(workflow)> 0){	
  for (cou in 1:length(unique(workflow$ref_area))){
	wfQ_cou <- workflow %>% filter(ref_area %in% unique(workflow$ref_area)[cou])
	
	for (sou in 1:length(unique(wfQ_cou$source))){
		wfQ_sou <- wfQ_cou %>% filter(source %in% unique(wfQ_cou$source)[sou])
		
		test_break <- wfQ_sou %>% filter(note_value %in% 'B')  
		
		wfQ_sou <- wfQ_sou %>% mutate(	year = stringr::str_sub(time, 1,4), 
										quarter = stringr::str_sub(time,5,7) %>% 
												plyr::mapvalues(	from = c('M01','M02','M03','M04','M05','M06','M07','M08','M09','M10','M11','M12'), 
																	to =   c('Q1','Q1','Q1','Q2','Q2','Q2','Q3','Q3','Q3','Q4','Q4','Q4'))) %>% 
								mutate(time = paste0(year, quarter)) %>% 
								count(ref_area, source, time, level, freq_code, year) %>% 
								filter(n %in% 3)
		if(nrow(test_break)> 0 ){
				test_break <- test_break %>% mutate(	year = stringr::str_sub(time, 1,4)) %>% distinct(year,note_value )
		wfQ_sou <- wfQ_sou %>% left_join(test_break, by = "year")
		
		} else {
		wfQ_sou <- wfQ_sou %>% mutate(note_value = NA)
		}
		rm(test_break)
		
								
		test_year <- wfQ_sou %>% count(year) %>% filter(nn %in% 4)
		wfQ_sou <- wfQ_sou %>% filter(year %in% unique(test_year$year))
		
		reference_wf_annual <- reference_wf %>% filter(ref_area %in% unique(wfQ_cou$ref_area), source %in% unique(wfQ_sou$source))
		wfQ_sou <- wfQ_sou %>% filter(!year %in% unique(reference_wf_annual$year))
		if(nrow(wfQ_sou)> 0){				
		for (tim in 1:length(unique(stringr:::str_sub(wfQ_sou$time,1,4)))){	
		
			
			wfQ_ref  <- wfQ_sou %>% filter(stringr:::str_sub(time,1,4) %in% unique(stringr:::str_sub(wfQ_sou$time,1,4))[tim])
			setwd(paste0(pathOutput,unique(wfQ_ref$ref_area) ,'/', unique(wfQ_ref$source)))
			test_freq <- 0
			if(unique(wfQ_ref$freq_code) %in% c('M')) {test_freq = 4}
			if(test_freq == 0) {print('error freq not correct')}
			
			
			
		
			####################################################################################################################
			####################################################################################################################
			####################################################################################################################
			
			
			
			
			if(nrow(wfQ_ref)>0) {
			
				X <- as.list(paste0(wfQ_ref$ref_area, '_', wfQ_ref$source, '_', wfQ_ref$time)) %>% 
						plyr:::ldply(function(x) {X <- read_csv(paste0(x,".csv"), col_types = cols_only(
																							collection = col_character(),
																							ref_area = col_character(),
																							source = col_character(),
																							indicator = col_character(),
																							sex = col_character(),
																							#ID = col_character(),
																							classif1 = col_character(),
																							classif2 = col_character(),
																							time = col_character(),
																							obs_value = col_double(),
																							obs_status = col_character(),
																							note_classif = col_character(),
																							note_indicator = col_character(),
																							note_source = col_character(),
																							sample_count = col_double(),
																							table_test = col_double(),
																							ilo_wgt = col_double(),
																							freq_code = col_character())); return(X)}) %>% as.tbl %>% 
						ilo:::switch_ilo(version)
			
				test_vs = X %>% group_by(collection, ref_area, source, time, indicator, sex_version, classif1_version, classif2_version) %>%
					summarise(available_vs = 1) %>% ungroup %>% 
					group_by(collection, ref_area, source, indicator, sex_version, classif1_version, classif2_version) %>% 
					summarise(available_vs = sum(available_vs)) %>% ungroup
		
		######## average of number
	
				NB1 <- X %>% filter(stringr:::str_sub(indicator,-2,-1) %in% 'NB', !stringr:::str_sub(indicator,1,3) %in% c('HOW','EAR')) %>% 
						left_join(test_vs, by = c("collection", "ref_area", "source", "indicator", "sex_version", "classif1_version", "classif2_version")) %>% 			
						group_by(collection, ref_area, source, indicator, sex, classif1, classif2) %>% 
						summarise(	time = unique(stringr:::str_sub(time,1,4)), 
									available_vs = min(available_vs),
									obs_value = sum(obs_value) / available_vs, 
									obs_status = paste0(ifelse(obs_status %in% NA, '', obs_status), collapse= ''), 
									note_classif = first(note_classif), 
									note_indicator = first(note_indicator), 
									note_source = first(note_source), 
									freq_code = first(freq_code),
									sample_count = sum(sample_count), 
									table_test = min(table_test), 
									ilo_wgt = sum(ilo_wgt),
									n = n()) %>% ungroup %>%
						filter(available_vs %in% test_freq) %>% 
						select(-available_vs, -n)
						
				NB2 <- X %>% filter(stringr:::str_sub(indicator,-2,-1) %in% 'NB', stringr:::str_sub(indicator,1,3) %in% c('HOW','EAR')) %>% 
						left_join(test_vs, by = c("collection", "ref_area", "source", "indicator", "sex_version", "classif1_version", "classif2_version")) %>% 			
						group_by(collection, ref_area, source, indicator, sex, classif1, classif2) %>% 
						summarise(	time = unique(stringr:::str_sub(time,1,4)), 
									available_vs = min(available_vs),
									obs_value = sum(obs_value * ilo_wgt) / sum(ilo_wgt), 
									obs_status = paste0(unique(ifelse(obs_status %in% NA, '', obs_status)), collapse = ''), 
									note_classif = first(note_classif), 
									note_indicator = first(note_indicator), 
									note_source = first(note_source), 
									freq_code = first(freq_code),
									sample_count = sum(sample_count), 
									table_test = min(table_test), 
									ilo_wgt = sum(ilo_wgt),
									n = n()) %>% ungroup %>%
						filter(available_vs %in% test_freq) %>% 
						select(-available_vs, -n)		

				compute_rt <- X %>% filter(!stringr:::str_sub(indicator,-2,-1) %in% 'NB') %>% distinct(indicator) %>% 
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
																		mutate_(obs_value = compute_rt$SUMMARISE[rt]) %>% 
																		select(sex, classif1, classif2, obs_value),
																by = c("sex", "classif1", "classif2"))
											)
						}
										
					}
				}
				X <- bind_rows(NB1, NB2, RT1) ; rm(NB1, NB2, RT1)
				 
				if(nrow(X) > 0){
				
					X <- X %>% mutate(	obs_status = as.character(NA), 
										obs_status = ifelse(sample_count < ktest[1],'U',  obs_status), 
										obs_status = ifelse(sample_count < ktest[2],'S',  obs_status), 
										table_test = as.character(NA))
										
					del <- X %>% count(obs_status) %>% filter(obs_status %in% 'S') %>% .$n / nrow(X)
					X <- X %>% mutate(table_test = round(ifelse(length(del)>0,del, 0), 2)) %>%
									mutate_if(Negate(is.numeric) , funs(as.character))
					

					rm(del)
	
					if(nrow(wfQ_ref %>% filter(note_value %in% 'B'))> 0){ 
						X <- X %>% mutate(obs_status = ifelse(!stringr:::str_sub(obs_status, 1, 1) %in% c('S', 'U'), 'B', stringr:::str_sub(obs_status, 1, 1)))
					}
					fwrite(X, file = paste0(pathOutput, unique(wfQ_ref$ref_area), '/', unique(wfQ_ref$source), '/', unique(wfQ_ref$ref_area), '_', unique(wfQ_ref$source), '_', unique(substr(wfQ_ref$time,1,4)), '.csv'), na = '')
					rm(X)
					invisible(gc(reset = TRUE))
					invisible(gc(reset = TRUE))
					print(paste0(unique(wfQ_ref$ref_area), '_', unique(wfQ_ref$source), '_', unique(substr(wfQ_ref$time,1,4))))
				}
			}
		
		}
		
		}
	}
	
  }
}
	setwd(init_wd)
		invisible(gc(reset = TRUE))
		invisible(gc(reset = TRUE))
	
}

Micro_process_annual_from_quarterly <- function(	ref_area =  NULL,
													source = NULL, 
													validate = TRUE, 
													ktest = c(max = 15, min = 5, threshold = 0.334), 
													skip = NULL, 
													PUB = FALSE){
	init_wd <- getwd()
	
	setwd(ilo:::path$micro)
	
	pathOutput <- paste0(ilo:::path$data, 'REP_ILO/MICRO/output/')
	
	workflow <- iloMicro:::Micro_get_workflow(ref_area, source) %>% filter(level %in% c('Q')) %>% filter(str_detect(type, 'Copy|Master'))
	
	if(validate) {workflow <- workflow %>% filter(processing_status %in% c('Ready', 'Published'), CC_ilostat %in% 'Yes', !freq_code %in% NA) }
	if(validate & PUB) {workflow <- workflow %>% filter(processing_status %in% c('Published'), CC_ilostat %in% 'Yes', !freq_code %in% NA) }
	
	if(!is.null(ref_area)){refref_area <- ref_area; workflow <- workflow %>% filter(ref_area %in% refref_area); rm(refref_area) }
	
	if(!is.null(source)){refsource <- source; workflow <- workflow %>% filter(source %in% refsource); rm(refsource) }
	
	if(!is.null(skip)){
			refskip <- skip
			workflow <- workflow %>% filter(!source %in% refskip) 
			rm(refskip) 
	}
	
	iloMicro:::Micro_load(path = NULL)

if(nrow(workflow)> 0){	
  for (cou in 1:length(unique(workflow$ref_area))){
	wfQ_cou <- workflow %>% filter(ref_area %in% unique(workflow$ref_area)[cou])
	
	for (sou in 1:length(unique(wfQ_cou$source))){
		wfQ_sou <- wfQ_cou %>% filter(source %in% unique(wfQ_cou$source)[sou])
		
		for (tim in 1:length(unique(stringr:::str_sub(wfQ_sou$time,1,4)))){	
		
			
			wfQ_ref  <- wfQ_sou %>% filter(stringr:::str_sub(time,1,4) %in% unique(stringr:::str_sub(wfQ_sou$time,1,4))[tim])
			setwd(paste0(pathOutput,unique(wfQ_ref$ref_area) ,'/', unique(wfQ_ref$source)))
			test_freq <- 0
			if(unique(wfQ_ref$freq_code) %in% c('P', 'T', 'R', 'S', 'Q', 'X')) {test_freq = 4}
			if(unique(wfQ_ref$freq_code) %in% c('Y', 'L', 'H', 'I', 'J', 'K', 'O', 'q')) {test_freq = 3}
			if(unique(wfQ_ref$freq_code) %in% c('Z','G','A','B','V','C','W','D','N','o','n','h','E','l','F')) {test_freq = 2}
			if(unique(wfQ_ref$freq_code) %in% c('a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'k', 'k', 'U')) {test_freq = 1}
			
			if(test_freq == 0) {print('error freq not correct')}
			
			
			
			####################################################################################################################
			####################################################################################################################
			####################################################################################################################
			if(unique(wfQ_ref$freq_code) %in% 'X'){
			
				wfQ_Xref <- wfQ_ref %>% filter(str_detect(time, 'M02|M05|M08|M11'))
				
				if(nrow(wfQ_Xref) > 0){	
					for (Xref in 1:nrow(wfQ_Xref)){
				
				
						ref_time <- wfQ_Xref$time[Xref] %>% str_replace('M02','Q1') %>% str_replace('M05','Q2') %>% str_replace('M08','Q3') %>% str_replace('M11','Q4') 
						X <- read_csv(paste0(wfQ_Xref$ref_area[Xref], '_', wfQ_Xref$source[Xref], '_', wfQ_Xref$time[Xref],".csv"), col_types = cols_only(
																							collection = col_character(),
																							ref_area = col_character(),
																							source = col_character(),
																							indicator = col_character(),
																							sex = col_character(),
																							#ID = col_character(),
																							classif1 = col_character(),
																							classif2 = col_character(),
																							time = col_character(),
																							obs_value = col_double(),
																							obs_status = col_character(),
																							note_classif = col_character(),
																							note_indicator = col_character(),
																							note_source = col_character(),
																							sample_count = col_double(),
																							table_test = col_double(),
																							ilo_wgt = col_double(),
																							freq_code = col_character())) %>% 
												mutate( time = ref_time) %>%
						fwrite(file = paste0(pathOutput, unique(wfQ_Xref$ref_area[Xref]), '/', unique(wfQ_Xref$source[Xref]), '/', unique(wfQ_Xref$ref_area), '_', unique(wfQ_Xref$source[Xref]), '_', ref_time, '.csv'), na = '')
				
					}
				}
				wfQ_ref <- wfQ_ref %>% filter(str_detect(time, 'M02|M05|M08|M11')) %>% mutate(	
												time = time %>% str_replace('M02','Q1'),
												time = time %>% str_replace('M05','Q2'),
												time = time %>% str_replace('M08','Q3'),
												time = time %>% str_replace('M11','Q4'))
			}
			
			####################################################################################################################
			####################################################################################################################
			####################################################################################################################
			
			
			
			
			if(nrow(wfQ_ref)>0) {
			
				X <- as.list(paste0(wfQ_ref$ref_area, '_', wfQ_ref$source, '_', wfQ_ref$time)) %>% 
						plyr:::ldply(function(x) {X <- read_csv(paste0(x,".csv"), col_types = cols_only(
																							collection = col_character(),
																							ref_area = col_character(),
																							source = col_character(),
																							indicator = col_character(),
																							sex = col_character(),
																							#ID = col_character(),
																							classif1 = col_character(),
																							classif2 = col_character(),
																							time = col_character(),
																							obs_value = col_double(),
																							obs_status = col_character(),
																							note_classif = col_character(),
																							note_indicator = col_character(),
																							note_source = col_character(),
																							sample_count = col_double(),
																							table_test = col_double(),
																							ilo_wgt = col_double(),
																							freq_code = col_character())); return(X)}) %>% as.tbl %>% 
						ilo:::switch_ilo(version)
			
				test_vs = X %>% group_by(collection, ref_area, source, time, indicator, sex_version, classif1_version, classif2_version) %>%
					summarise(available_vs = 1) %>% ungroup %>% 
					group_by(collection, ref_area, source, indicator, sex_version, classif1_version, classif2_version) %>% 
					summarise(available_vs = sum(available_vs)) %>% ungroup
				############## exception quarterly once a year take additionnal note reference periode
				if(test_freq %in% 1 & unique(X$freq_code) %in% 'k') {X <- X %>% mutate(note_source = paste0('S3:23_', note_source))}
		######## average of number
	
				NB1 <- X %>% filter(stringr:::str_sub(indicator,-2,-1) %in% 'NB', !stringr:::str_sub(indicator,1,3) %in% c('HOW','EAR')) %>% 
						left_join(test_vs, by = c("collection", "ref_area", "source", "indicator", "sex_version", "classif1_version", "classif2_version")) %>% 			
						group_by(collection, ref_area, source, indicator, sex, classif1, classif2) %>% 
						summarise(	time = unique(stringr:::str_sub(time,1,4)), 
									available_vs = min(available_vs),
									obs_value = sum(obs_value) / available_vs, 
									obs_status = paste0(ifelse(obs_status %in% NA, '', obs_status), collapse= ''), 
									note_classif = first(note_classif), 
									note_indicator = first(note_indicator), 
									note_source = first(note_source), 
									freq_code = first(freq_code),
									sample_count = sum(sample_count), 
									table_test = min(table_test), 
									ilo_wgt = sum(ilo_wgt),
									n = n()) %>% ungroup %>%
						filter(available_vs %in% test_freq) %>% 
						select(-available_vs, -n)
						
				NB2 <- X %>% filter(stringr:::str_sub(indicator,-2,-1) %in% 'NB', stringr:::str_sub(indicator,1,3) %in% c('HOW','EAR')) %>% 
						left_join(test_vs, by = c("collection", "ref_area", "source", "indicator", "sex_version", "classif1_version", "classif2_version")) %>% 			
						group_by(collection, ref_area, source, indicator, sex, classif1, classif2) %>% 
						summarise(	time = unique(stringr:::str_sub(time,1,4)), 
									available_vs = min(available_vs),
									obs_value = sum(obs_value * ilo_wgt) / sum(ilo_wgt), 
									obs_status = paste0(unique(ifelse(obs_status %in% NA, '', obs_status)), collapse = ''), 
									note_classif = first(note_classif), 
									note_indicator = first(note_indicator), 
									note_source = first(note_source), 
									freq_code = first(freq_code),
									sample_count = sum(sample_count), 
									table_test = min(table_test), 
									ilo_wgt = sum(ilo_wgt),
									n = n()) %>% ungroup %>%
						filter(available_vs %in% test_freq) %>% 
						select(-available_vs, -n)		

				compute_rt <- X %>% filter(!stringr:::str_sub(indicator,-2,-1) %in% 'NB') %>% distinct(indicator) %>% 
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
																		mutate_(obs_value = compute_rt$SUMMARISE[rt]) %>% 
																		select(sex, classif1, classif2, obs_value),
																by = c("sex", "classif1", "classif2"))
											)
						}
										
					}
				}
				X <- bind_rows(NB1, NB2, RT1) ; rm(NB1, NB2, RT1)
			
				if(nrow(X) > 0){
					X <- X %>% mutate(	obs_status = as.character(NA), 
										obs_status = ifelse(sample_count < ktest[1],'U',  obs_status), 
										obs_status = ifelse(sample_count < ktest[2],'S',  obs_status), 
										table_test = as.character(NA))
										
					del <- X %>% count(obs_status) %>% filter(obs_status %in% 'S') %>% .$n / nrow(X)
					X <- X %>% mutate(table_test = round(ifelse(length(del)>0,del, 0), 2)) %>%
									mutate_if(Negate(is.numeric) , funs(as.character))
					
					if(nrow(wfQ_ref %>% filter(note_value %in% 'B'))>0){ 
							X <- X %>% mutate(obs_status = ifelse(!stringr:::str_sub(obs_status, 1, 1) %in% c('S', 'U'), 'B', stringr:::str_sub(obs_status, 1, 1)))
					}
					rm(del)
					fwrite(X, file = paste0(pathOutput, unique(wfQ_ref$ref_area), '/', unique(wfQ_ref$source), '/', unique(wfQ_ref$ref_area), '_', unique(wfQ_ref$source), '_', unique(substr(wfQ_ref$time,1,4)), '.csv'), na = '')
					rm(X)
					invisible(gc(reset = TRUE))
					invisible(gc(reset = TRUE))
					print(paste0(unique(wfQ_ref$ref_area), '_', unique(wfQ_ref$source), '_', unique(substr(wfQ_ref$time,1,4))))
				}
			}
		
		}
	}
	
  }
}
	setwd(init_wd)
		invisible(gc(reset = TRUE))
		invisible(gc(reset = TRUE))
	
}

Micro_process_quarterly_from_monthly <- function(	ref_area =  NULL,
													source = NULL, 
													validate = TRUE, 
													ktest = c(max = 15, min = 5, threshold = 0.334), 
													skip = NULL, 
													PUB = FALSE){
	init_wd <- getwd()
	
	setwd(ilo:::path$micro)
	
	pathOutput <- paste0(ilo:::path$data, 'REP_ILO/MICRO/output/')
	
	workflow <- iloMicro:::Micro_get_workflow(ref_area, source) %>% filter(level %in% c('M')) %>% filter(str_detect(type, 'Copy|Master'))
	
	if(validate) {workflow <- workflow %>% filter(processing_status %in% c('Ready','Published'), CC_ilostat %in% 'Yes', !freq_code %in% NA) }
	if(validate & PUB) {workflow <- workflow %>% filter(processing_status %in% c('Published'), CC_ilostat %in% 'Yes', !freq_code %in% NA) }
		
	if(!is.null(ref_area)){refref_area <- ref_area; workflow <- workflow %>% filter(ref_area %in% refref_area); rm(refref_area) }
	
	if(!is.null(source)){refsource <- source; workflow <- workflow %>% filter(source %in% refsource); rm(refsource) }
	
	if(!is.null(skip)){
			refskip <- skip
			workflow <- workflow %>% filter(!source %in% refskip) 
			rm(refskip) 
	}
	
	iloMicro:::Micro_load(path = NULL)

if(nrow(workflow)> 0){	
  for (cou in 1:length(unique(workflow$ref_area))){
	wfQ_cou <- workflow %>% filter(ref_area %in% unique(workflow$ref_area)[cou])
	
	for (sou in 1:length(unique(wfQ_cou$source))){
		wfQ_sou <- wfQ_cou %>% filter(source %in% unique(wfQ_cou$source)[sou]) %>% mutate(quarter  = stringr:::str_sub(time,5,7) %>% plyr:::mapvalues(from  = c("M09", "M08", "M07", "M06", "M05", "M04", "M03", "M02", "M01", "M12", "M11", "M10"), 
																																			to = 	c("Q3", "Q3", "Q3", "Q2", "Q2", "Q2", "Q1", "Q1", "Q1", "Q4", "Q4", "Q4")), 
																							quarter = paste0(stringr:::str_sub(time, 1,4), quarter))
		
		for (month in 1:length(unique(wfQ_sou$quarter))){	
		
			
			wfQ_ref  <- wfQ_sou %>% filter(quarter %in% unique(quarter)[month])
			setwd(paste0(pathOutput,unique(wfQ_ref$ref_area) ,'/', unique(wfQ_ref$source)))
			test_freq <- 0
			if(unique(wfQ_ref$freq_code) %in% c('M')) {test_freq = 3}
			
			if(test_freq == 0) {print('error freq not correct')}
			
			
			
			####################################################################################################################
			####################################################################################################################
			####################################################################################################################
			
			
			
			
			if(nrow(wfQ_ref)>0) {
			
				X <- as.list(paste0(wfQ_ref$ref_area, '_', wfQ_ref$source, '_', wfQ_ref$time)) %>% 
						plyr:::ldply(function(x) {X <- read_csv(paste0(x,".csv"), col_types = cols_only(
																							collection = col_character(),
																							ref_area = col_character(),
																							source = col_character(),
																							indicator = col_character(),
																							sex = col_character(),
																							#ID = col_character(),
																							classif1 = col_character(),
																							classif2 = col_character(),
																							time = col_character(),
																							obs_value = col_double(),
																							obs_status = col_character(),
																							note_classif = col_character(),
																							note_indicator = col_character(),
																							note_source = col_character(),
																							sample_count = col_double(),
																							table_test = col_double(),
																							ilo_wgt = col_double(),
																							freq_code = col_character())); return(X)}) %>% as.tbl %>% 
						ilo:::switch_ilo(version)
			
				test_vs = X %>% group_by(collection, ref_area, source, time, indicator, sex_version, classif1_version, classif2_version) %>%
					summarise(available_vs = 1) %>% ungroup %>% 
					group_by(collection, ref_area, source, indicator, sex_version, classif1_version, classif2_version) %>% 
					summarise(available_vs = sum(available_vs)) %>% ungroup
		
		######## average of number
	
				NB1 <- X %>% filter(stringr:::str_sub(indicator,-2,-1) %in% 'NB', !stringr:::str_sub(indicator,1,3) %in% c('HOW','EAR')) %>% 
						left_join(test_vs, by = c("collection", "ref_area", "source", "indicator", "sex_version", "classif1_version", "classif2_version")) %>% 			
						group_by(collection, ref_area, source, indicator, sex, classif1, classif2) %>% 
						summarise(	time = unique(wfQ_ref$quarter), 
									available_vs = min(available_vs),
									obs_value = sum(obs_value) / available_vs, 
									obs_status = paste0(ifelse(obs_status %in% NA, '', obs_status), collapse= ''), 
									note_classif = first(note_classif), 
									note_indicator = first(note_indicator), 
									note_source = first(note_source), 
									freq_code = first(freq_code),
									sample_count = sum(sample_count), 
									table_test = min(table_test), 
									ilo_wgt = sum(ilo_wgt),
									n = n()) %>% ungroup %>%
						filter(available_vs %in% test_freq) %>% 
						select(-available_vs, -n)
						
				NB2 <- X %>% filter(stringr:::str_sub(indicator,-2,-1) %in% 'NB', stringr:::str_sub(indicator,1,3) %in% c('HOW','EAR')) %>% 
						left_join(test_vs, by = c("collection", "ref_area", "source", "indicator", "sex_version", "classif1_version", "classif2_version")) %>% 			
						group_by(collection, ref_area, source, indicator, sex, classif1, classif2) %>% 
						summarise(	time = unique(wfQ_ref$quarter), 
									available_vs = min(available_vs),
									obs_value = sum(obs_value * ilo_wgt) / sum(ilo_wgt), 
									obs_status = paste0(unique(ifelse(obs_status %in% NA, '', obs_status)), collapse = ''), 
									note_classif = first(note_classif), 
									note_indicator = first(note_indicator), 
									note_source = first(note_source), 
									freq_code = first(freq_code),
									sample_count = sum(sample_count), 
									table_test = min(table_test), 
									ilo_wgt = sum(ilo_wgt),
									n = n()) %>% ungroup %>%
						filter(available_vs %in% test_freq) %>% 
						select(-available_vs, -n)		

				compute_rt <- X %>% filter(!stringr:::str_sub(indicator,-2,-1) %in% 'NB') %>% distinct(indicator) %>% 
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
																		mutate_(obs_value = compute_rt$SUMMARISE[rt]) %>% 
																		select(sex, classif1, classif2, obs_value),
																by = c("sex", "classif1", "classif2"))
											)
						}
										
					}
				}
				X <- bind_rows(NB1, NB2, RT1) ; rm(NB1, NB2, RT1)
			
				if(nrow(X) > 0){
					X <- X %>% mutate(	obs_status = as.character(NA), 
										obs_status = ifelse(sample_count < ktest[1],'U',  obs_status), 
										obs_status = ifelse(sample_count < ktest[2],'S',  obs_status), 
										table_test = as.character(NA))
										
					del <- X %>% count(obs_status) %>% filter(obs_status %in% 'S') %>% .$n / nrow(X)
					X <- X %>% mutate(table_test = round(ifelse(length(del)>0,del, 0), 2)) %>%
									mutate_if(Negate(is.numeric) , funs(as.character))
					rm(del)
					if(nrow(wfQ_ref %>% filter(note_value %in% 'B'))>0){ 
							X <- X %>% mutate(obs_status = ifelse(!stringr:::str_sub(obs_status, 1, 1) %in% c('S', 'U'), 'B', stringr:::str_sub(obs_status, 1, 1)))
					}
					fwrite(X, file = paste0(pathOutput, unique(wfQ_ref$ref_area), '/', unique(wfQ_ref$source), '/', unique(wfQ_ref$ref_area), '_', unique(wfQ_ref$source), '_', unique(wfQ_ref$quarter), '.csv'), na = '')
					rm(X)
					invisible(gc(reset = TRUE))
					invisible(gc(reset = TRUE))
					print(paste0(unique(wfQ_ref$ref_area), '_', unique(wfQ_ref$source), '_', unique(wfQ_ref$quarter)))
				}
			}
		
		}
	}
	
  }
}
	setwd(init_wd)
		invisible(gc(reset = TRUE))
		invisible(gc(reset = TRUE))
	
}




#' @export
Micro_process_all <- function(		ref_area =  NULL,
											source = NULL, 
											validate = TRUE, 
											ktest = c(max = 15, min = 5, threshold = 0.334), 
											skip = NULL, 
											output = 'ilostat', 
											PUB = FALSE){

	init_wd <- getwd()
	setwd(ilo:::path$micro)
	pathOutput <- paste0(ilo:::path$data, 'REP_ILO/MICRO/output/')
	workflow <- Micro_get_workflow(ref_area, source) %>% filter(str_detect(type, 'Copy|Master'))
	
	if(!is.null(skip)){
			refskip <- skip
			workflow <- workflow %>% filter(!source %in% refskip) 
			rm(refskip) 
	}
	
	discard_files <- workflow %>% 
						filter(!(processing_status %in% c('Published') & CC_ilostat %in% 'Yes')) %>% 
						distinct(ref_area, source, time) %>% 
						unite(value, ref_area, source, time, sep = '_') %>% 
						mutate(value = paste0(value, '.csv')) %>% t %>% as.character
	if(validate) {workflow <- workflow %>% filter(processing_status %in% c('Ready','Published'), CC_ilostat %in% 'Yes', !freq_code %in% NA) }
	if(validate & PUB) {workflow <- workflow %>% filter(processing_status %in% c('Published'), CC_ilostat %in% 'Yes', !freq_code %in% NA) }
	
	if(!is.null(ref_area)){refref_area <- ref_area; workflow <- workflow %>% filter(ref_area %in% refref_area); rm(refref_area) }
	if(!is.null(source)){refsource <- source; workflow <- workflow %>% filter(source %in% refsource); rm(refsource) }
	iloMicro:::Micro_load(path = NULL)
	wf <- workflow %>% distinct(ref_area, source)	

	FileToLoad <- data_frame(PATH= '', ID= '', Types= '', REF= '', year = '', freq = '', count_time = 0) %>% slice(-1)

	ref_PUBLISHED <- read_csv(paste0(ilo:::path$micro, '_Admin/CMD/FileToLoad.csv'), col_types = cols(
																				PATH = col_character(),
																				ID = col_character(),
																				Types = col_character(),
																		REF = col_character()
																)) %>% mutate(published = 'Yes')
	
	for (i in 1:nrow(wf)){	
		setwd(paste0(pathOutput, '/',unique(wf$ref_area[i]) ,'/', unique(wf$source[i])))
		ref <- list.files() %>% as_data_frame %>% filter(!str_detect(value, 'ilostat')) %>% t %>% as.character
		ref <- ref[!ref %in% discard_files] # detect non validate file 
		
		
		X <- as.list(ref) %>% 
						plyr:::ldply(function(x) {X <- read_csv(x, col_types = cols(
																collection = col_character(),
																ref_area = col_character(),
																source = col_character(),
																indicator = col_character(),
																sex = col_character(),
																classif1 = col_character(),
																classif2 = col_character(),
 																time = col_character(),
																obs_value = col_double(),
																obs_status = col_character(),
																note_classif = col_character(),
																note_indicator = col_character(),
																note_source = col_character(),
																sample_count = col_double(), 
																table_test = col_double(),
																ilo_wgt = col_double(),
																freq_code = col_character()), progress = FALSE); return(X)}) %>% as.tbl %>% ilo:::switch_ilo(version, keep)
		invisible(gc(reset = TRUE))
		invisible(gc(reset = TRUE))
			
		X <- X %>% left_join(select(ilo_tpl$Mapping_indicator, indicator, sex_version = sex_var, classif1_version = classif1_var, classif2_version = classif2_var, frequency), by = c("indicator", "sex_version", "classif1_version", "classif2_version")) %>% 
					filter(
							ifelse(stringr:::str_sub(time,5,5) %in% 'M' & frequency %in% c("A", "A;Q"), FALSE, TRUE), # delete Monthly not config
							ifelse(stringr:::str_sub(time,5,5) %in% 'Q' & frequency %in% c("A"), FALSE, TRUE) # delete quarterly not config
					) %>% select(-frequency, -sex_version, -classif1_version, -classif2_version) # %>% 
					# left_join(ilo_tpl$Mapping_indicator %>% distinct(Is_Validate, indicator), by = 'indicator') 
					
					
		############# manage informality special indicator from EMP_IFLE_SEX_IFL_ECO_NB & EMP_ILFS_SEX_IFL_ECO_NB:
		 
		 X <- bind_rows(X, iloMicro:::create_informality(X %>% filter(indicator %in% c('EMP_IFLE_SEX_IFL_ECO_NB', 'EMP_IFLS_SEX_IFL_ECO_NB')), 'ECO'))
		 X <- bind_rows(X, iloMicro:::create_informality(X %>% filter(indicator %in% c('EMP_IFLE_SEX_MTS_IFL_NB', 'EMP_IFLS_SEX_MTS_IFL_NB')), 'MTS'))
					
		

					
					
		#X <- X %>% filter(table_test < ktest[3]) #%>%	#clean up the reliability test
				# select(-contains('sample_count'), -contains('table_test'), -contains('ilo_wgt'))
		X <- X %>% select( -contains('ilo_wgt'))
		
		save(X,  file = paste0(pathOutput, wf$ref_area[i], '/', wf$source[i], '/', wf$ref_area[i], '_', wf$source[i], '_ilostat.Rdata'))

		
		ref_year = paste0(min(as.numeric(stringr::str_sub(X$time,1,4))), ' - ', max(as.numeric(stringr::str_sub(X$time,1,4))))
		ref_freq = unique(stringr::str_sub(X$time,5,5)) %>% ifelse(. %in% '', 'A', .) %>% sort(.) %>% paste0(., collapse = '; ') %>% gsub('M; Q', 'Q, M', ., fixed = TRUE)
		ref_count_time = length(unique(X$time))
		
	
		rm(X)		

	
		FileToLoad <- bind_rows(FileToLoad, 
						data_frame(PATH= paste0(pathOutput, wf$ref_area[i], '/', wf$source[i], '/', wf$ref_area[i], '_', wf$source[i], '_ilostat.Rdata'), 
						ID= '', 
						Types= 'ilostat', 
						REF= wf$ref_area[i], 
						year = ref_year, 
						freq = ref_freq, 
						count_time = ref_count_time)
						
						)
		rm(ref_year,ref_freq,  ref_count_time)
	

		invisible(gc(reset = TRUE))
		invisible(gc(reset = TRUE))
		print(paste0(wf$ref_area[i], '_', wf$source[i] ))	
	}	
	
	
if(is.null(ref_area)) {
					FileToLoad <- FileToLoad %>% left_join(select(ref_PUBLISHED, PATH, published), by = c("PATH"))
					FileToLoad %>% data.table:::fwrite(file = paste0(gsub('output/','',pathOutput),'FileToLoad_toCheck.csv' ))
					FileToLoad %>% data.table:::fwrite(file = paste0(ilo:::path$micro, '_Admin/CMD/FileToLoad_toCheck.csv'))				
				}


												
	setwd(init_wd)												
	invisible(gc(reset = TRUE))		
	invisible(gc(reset = TRUE))	

}



create_informality <- function(df, test){

if(test %in% 'ECO' & nrow(df) > 0){



	df <- df %>% 	filter(!classif2 %in% 'ECO_AGNAG_AGR') %>% 
			mutate(	
					classif1 = ifelse(classif1 %in% c('IFL_NATURE_TOTAL', 'IFL_PROD_TOTAL'), 'IFL_COMP_EMP', classif1), 
					indicator = 'IFL_4IEM_SEX_ECO_IFL_NB') %>% 
			
			group_by(collection, ref_area, source, indicator, sex, classif1, classif2, time) %>% 
			summarise(	obs_value = first(obs_value),
						obs_status = first(obs_status),
						note_classif = first(note_classif),
						note_indicator = first(note_indicator),
						note_source = first(note_source),
						sample_count = first(sample_count),
						table_test = min(table_test),
						ilo_wgt = first(ilo_wgt),
						freq_code = first(freq_code)				
						) %>% 
			ungroup %>% 
			mutate(
					classif1 = ifelse(classif1 %in% c('IFL_NATURE_INFORMAL'), 						'IFL_COMP_INFEMP', classif1), 
					classif1 = ifelse(classif1 %in% c('IFL_NATURE_FORMAL'), 						'IFL_COMP_FRMEMP', classif1), 
					classif1 = ifelse(classif1 %in% c('IFL_PROD_FORMAL'), 							'IFL_COMP_FRMSECTOR', classif1), 
					classif1 = ifelse(classif1 %in% c('IFL_PROD_INFORMAL', 'IFL_PROD_HOUSEHOLD'), 	'IFL_COMP_OFS', classif1), 
					classif2 = classif2 %>% stringr::str_replace('ECO_AGNAG_', 	'ECO_TOTNAG_')
			
			) %>% group_by(collection, ref_area, source, indicator, sex, classif1, classif2, time) %>% 
			summarise (obs_value = sum(obs_value),
						obs_status = first(obs_status),
						note_classif = first(note_classif),
						note_indicator = first(note_indicator),
						note_source = first(note_source),
						sample_count = sum(sample_count),
						table_test = min(table_test),
						ilo_wgt = sum(ilo_wgt),
						freq_code = first(freq_code)) %>% 
			ungroup %>% 
			mutate(PASS = classif2, 
					classif2 = classif1, 
					classif1 = PASS) %>% select(-PASS)
return(df)	
} 

if(test %in% 'MTS' & nrow(df) > 0){



	df <- df %>% 	
			mutate(	
					classif2 = ifelse(classif2 %in% c('IFL_NATURE_TOTAL', 'IFL_PROD_TOTAL'), 'IFL_COMP_EMP', classif2), 
					indicator = 'IFL_4IEM_SEX_MTS_IFL_NB') %>% 
			
			group_by(collection, ref_area, source, indicator, sex, classif1, classif2, time) %>% 
			summarise(	obs_value = first(obs_value),
						obs_status = first(obs_status),
						note_classif = first(note_classif),
						note_indicator = first(note_indicator),
						note_source = first(note_source),
						sample_count = first(sample_count),
						table_test = min(table_test),
						ilo_wgt = first(ilo_wgt),
						freq_code = first(freq_code)				
						) %>% 
			ungroup %>% 
			mutate(
					classif2 = ifelse(classif2 %in% c('IFL_NATURE_INFORMAL'), 'IFL_COMP_INFEMP', classif2), 
					classif2 = ifelse(classif2 %in% c('IFL_NATURE_FORMAL'), 'IFL_COMP_FRMEMP', classif2), 
					classif2 = ifelse(classif2 %in% c('IFL_PROD_FORMAL'), 'IFL_COMP_FRMSECTOR', classif2), 
					classif2 = ifelse(classif2 %in% c('IFL_PROD_INFORMAL', 'IFL_PROD_HOUSEHOLD'), 'IFL_COMP_OFS', classif2)
			
			) %>% group_by(collection, ref_area, source, indicator, sex, classif1, classif2, time) %>% 
			summarise (obs_value = sum(obs_value),
						obs_status = first(obs_status),
						note_classif = first(note_classif),
						note_indicator = first(note_indicator),
						note_source = first(note_source),
						sample_count = sum(sample_count),
						table_test = min(table_test),
						ilo_wgt = sum(ilo_wgt),
						freq_code = first(freq_code)) %>% 
			ungroup 
return(df)	
}

NULL

}
