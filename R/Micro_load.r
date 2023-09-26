#' helper to load ilo.dta file for the processing process
#'
#' dataset could be manipulate during the load file base on the workflow arguments
#'
#'
#' @param path dta or zip file path for loading ilo microdataset pre precessed, default 'tpl' means that predifine example will be load, if NULL load only ilo framework.
#' @param query indicator definition subset
#' @param asFactor loading microdataset with code and label (as.factor) if TRUE only numeric code.
#' @param tpl default = TRUE return micro template Variable, Mapping_indicator, Mapping_classif.
#' @author ILO / bescond  
#' @keywords ILO, microdataset, processing

#' @export


Micro_load <- function(	path = NULL, 
						query = 'ILOSTAT', 
						asFactor = FALSE, 
						tpl = TRUE){


	# load df
	testNote <- FALSE
	
	if(!is.null(path)){
		options(warn = -1)			
		df <- NULL

			for (i in 1:length(path)){ 
				df <- bind_rows(	
							haven::read_dta(path[i]) %>% 
									mutate(ilo_time = ifelse(class(.$ilo_time)[1] %in% 'haven_labelled',haven::as_factor(.$ilo_time) %>% as.character,  as.character(ilo_time))), 
							df)
			}
			if(file.exists(file.path(dirname(path[1]),paste0(str_sub(basename(path[1]),1,-5), '_FWK.xlsx')))){
				testNote <- TRUE
				add_ilostat_Note <- read_excel(file.path(dirname(path[1]),paste0(str_sub(basename(path[1]),1,-5), '_FWK.xlsx')), sheet= 1)
			}  else {
			
			testNote <- FALSE
			}
		
	options(warn = 0)
		
 
	
	if(!asFactor){
		df <- df %>% haven:::zap_labels() # mutate_if(is.labelled, funs(unclass)) 
	}


}

# load template

	if(tpl){
	
	
	ilo_tpl <- readRDS(file = paste0(MY_PATH$micro,'_Admin/template/framework/','framework_',query,'.rds'))

	if(!testNote){  add_ilostat_Note <- ilo_tpl$Variable %>% filter( !is.na(ilostat_note_code), !is.na(ilostat_code))}
	
	assign('ilo_tpl', ilo_tpl, envir =globalenv())
	
	}	
	
	add_ilostat_Note <- add_ilostat_Note %>% 
						select(var_name, ilostat_code, ilostat_note_code) %>% 
						filter( !is.na(ilostat_note_code), !is.na(ilostat_code)) %>% 
						# replicate earning note for SDG 0851
						bind_rows( 	add_ilostat_Note %>% 
									filter( !is.na(ilostat_note_code), !is.na(ilostat_code)) %>% 
									filter(str_detect(ilostat_code, "EAR_XEES_NB")) %>% 
									mutate(ilostat_code = "SDG_0851_NB") 
							)


	assign('add_ilostat_Note', add_ilostat_Note, envir =globalenv())


	if(!is.null(path)){
		return(df)	
	}
}


#' @export


Micro_prepare_template <- function(query = 'ILOSTAT'){


	
	ilo_tpl <- list()


			############################ Variable
	ilo_tpl$Variable 	<- 
			readxl::read_excel(
				path = file.path(paste0(MY_PATH$micro,'_Admin/template'),'3_Framework_Template.xlsx'), 
				sheet= 'Variable', 
				col_types= rep('text', 8)
				) %>% 
			select(var_name, var_label, code_level, code_label, ilostat_code, ilostat_note_code, scope) %>% 
			rowwise() %>% 
			mutate(	ilostat_version = ifelse(var_name %in% 'ilo_sex', 
					"SEX", 
					ilostat_code %>% str_extract( "([A-Z][A-Z][A-Z0-9])[-_.]([A-Z0-9]*)") )
					) %>% 
			ungroup  %>% slice(-c(1:6))



	ilo_tpl$Variable <- 
		ilo_tpl$Variable %>% 
			bind_rows(
			ilo_tpl$Variable %>% filter(str_detect(var_name, "_job1_")) %>% mutate(var_name = var_name %>% str_replace("_job1_", "_job2_")) %>% mutate(scope = gsub("ilo_lfs %in% 1", "ilo_lfs %in% 1 & ilo_mjh %in% 2	", scope, fixed = TRUE)),
			ilo_tpl$Variable %>% filter(str_detect(var_name, "_job1_")) %>% mutate(var_name = var_name %>% str_replace("_job1_", "_joball_")),
			ilo_tpl$Variable %>% filter(str_detect(var_name, "_job1_eco_")) %>% mutate(var_name = var_name %>% str_replace("_job1_eco_", "_preveco_")) %>% mutate(scope = gsub("ilo_lfs %in% 1", "ilo_lfs %in% 2 & ilo_cat_une %in% 1	", scope, fixed = TRUE)),
			ilo_tpl$Variable %>% filter(str_detect(var_name, "_job1_ocu_")) %>% mutate(var_name = var_name %>% str_replace("_job1_ocu_", "_prevocu_"))  %>% mutate(scope = gsub("ilo_lfs %in% 1", "ilo_lfs %in% 2 & ilo_cat_une %in% 1	", scope, fixed = TRUE))
			) 
	
	mapping_group_by <- 
		ilo_tpl$Variable  %>% 
			distinct(var_name, ilostat_version) %>% 
			filter(!is.na(ilostat_version ))
				

	
	############################ Mapping_indicator	
	ilo_tpl$Mapping_indicator 	<- 
			readxl::read_excel(
				path = file.path(paste0(MY_PATH$micro,'_Admin/template'),'3_Framework_Template.xlsx'), 
				sheet= 'Mapping_indicator', 
				col_types  = rep('text',9)) 
				
				
	ref_rep_var 	<- 
			readxl::read_excel(
				path = file.path(paste0(MY_PATH$micro,'_Admin/template'),'3_Framework_Template.xlsx'), 
				sheet= 'scope_rep_var', 
				col_types  = rep('text',8)) 			
				
				
	group1_frame 	<- 
			readxl::read_excel(
				path = file.path(paste0(MY_PATH$micro,'_Admin/template'),'3_Framework_Template.xlsx'), 
				sheet= 'group1_socio1', 
				col_types  = rep('text',8)) 			
							
				
	NEW1 <- cross_join(filter(ref_rep_var, str_detect(group, "1")), group1_frame) %>% 
			rename(rep_source = rep_source.x) %>% mutate(rep_source = paste0(rep_source, "; ", rep_source.y)) %>% select(-rep_source.y) %>% 
			rowwise() %>% mutate(rep_source = rep_source %>% str_split(pattern = "; ") %>% unlist %>% unique %>% .[!. %in% "NA" ] %>% paste0(collapse = "; ")) %>% ungroup %>% 
			mutate(rep_source = ifelse(rep_source %in% "", NA, rep_source)) %>% 
	mutate(indicator_label = paste0(rep_var_label, " ", add_label, " ", unit) %>% gsub(" NA ", " ", .)) %>% select(!!colnames(ilo_tpl$Mapping_indicator))			
				

	group2_frame 	<- 
			readxl::read_excel(
				path = file.path(paste0(MY_PATH$micro,'_Admin/template'),'3_Framework_Template.xlsx'), 
				sheet= 'group2_socio2', 
				col_types  = rep('text',8)) 			
							
				
	NEW2 <- cross_join(filter(ref_rep_var, str_detect(group, "2")), group2_frame) %>% 
		rename(rep_source = rep_source.x) %>% mutate(rep_source = paste0(rep_source, "; ", rep_source.y)) %>% select(-rep_source.y) %>% 
			rowwise() %>% mutate(rep_source = rep_source %>% str_split(pattern = "; ") %>% unlist %>% unique %>% .[!. %in% "NA" ] %>% paste0(collapse = "; ")) %>% ungroup %>% 
			mutate(rep_source = ifelse(rep_source %in% "", NA, rep_source)) %>% 
			mutate(indicator_label = paste0(rep_var_label, " ", add_label, " ", unit) %>% gsub(" NA ", " ", .)) %>% select(!!colnames(ilo_tpl$Mapping_indicator))			
				

	group3_frame 	<- 
			readxl::read_excel(
				path = file.path(paste0(MY_PATH$micro,'_Admin/template'),'3_Framework_Template.xlsx'), 
				sheet= 'group3_eco1', 
				col_types  = rep('text',8)) 			
							
				
	NEW3 <- cross_join(filter(ref_rep_var, str_detect(group, "3")), group3_frame) %>% 
			rename(rep_source = rep_source.x) %>% mutate(rep_source = paste0(rep_source, "; ", rep_source.y)) %>% select(-rep_source.y) %>% 
			rowwise() %>% mutate(rep_source = rep_source %>% str_split(pattern = "; ") %>% unlist %>% unique %>% .[!. %in% "NA" ] %>% paste0(collapse = "; ")) %>% ungroup %>% 
			mutate(rep_source = ifelse(rep_source %in% "", NA, rep_source)) %>% 
			mutate(indicator_label = paste0(rep_var_label, " ", add_label, " ", ifelse(is.na(unit), "", unit)) %>% gsub(" NA ", " ", .) %>% str_trim) %>% select(!!colnames(ilo_tpl$Mapping_indicator))			
								


				
	ilo_tpl$Mapping_indicator <-   bind_rows(
			NEW1, NEW2, NEW3, ilo_tpl$Mapping_indicator 
	)			
		rm(group2_frame, group1_frame, ref_rep_var, NEW1, NEW2 )			
				
				
	if(query %in% 'all') { 
			ilo_tpl$Mapping_indicator <- ilo_tpl$Mapping_indicator %>% distinct(GROUP_BY, FILTER, SUMMARISE, .keep_all = TRUE)
	}	else {
		ilo_tpl$Mapping_indicator <- ilo_tpl$Mapping_indicator %>% filter(query_folder %in% query)
	}


	ref_variable <- "([i][l][o])[-_.]([a-z0-9]+)[-_.]*([a-z0-9]*)[-_.]*([a-z0-9]*)[-_.]*([a-z0-9]*)"
	
	
					
		
		NB <- 	ilo_tpl$Mapping_indicator %>% 
					mutate(GROUP_BY = gsub(' , ', ', ', GROUP_BY)) %>% 
					filter(str_sub(rep_var, -2,-1)  %in% c('NB','DT'))	%>% 
					
					rowwise %>% 
					mutate(	SELECT = paste0(c('ilo_wgt', 'ilo_time',
										FILTER %>% str_extract_all(ref_variable) %>% unlist %>% unique %>% .[!. %in% c(NA, 'NA')], 
										GROUP_BY %>% str_extract_all(ref_variable) %>% unlist %>% unique %>% .[!. %in% c(NA, 'NA')], 
										SUMMARISE %>% str_extract_all(ref_variable) %>% unlist %>% unique %>% .[!. %in% c(NA, 'NA')]) %>% 
									unique , 
							collapse = ", ")) %>% 
					ungroup() 
					
					
		need_variable <- 
			NB %>% 
				distinct(SELECT) %>% 
				pull(SELECT) %>% 
				str_split(pattern = ", ") %>% 
				unlist %>% 
				unique 					
		mapping_group_by <- mapping_group_by %>% filter(var_name %in% need_variable)
								
		if(!query %in% 'all') { ilo_tpl$Variable <- 	ilo_tpl$Variable %>% filter(var_name %in% need_variable)}

			
		NB <- NB	%>% 
			mutate(sex_var = ifelse(str_detect( GROUP_BY, 'ilo_sex'), 'SEX', NA)) %>% 
			mutate(varTEST = ifelse(GROUP_BY %in% c(NA, "", "ilo_sex"), NA, gsub("ilo_sex, ", "",GROUP_BY ))) %>% 
			mutate(GROUP_BY = ifelse(GROUP_BY %in% NA, "ilo_time", paste0("ilo_time, ", GROUP_BY))) 	 %>% 
			rowwise %>% 
					mutate(	ref = str_split(varTEST, ", ") %>% unlist() %>% .[!is.na(.)]%>% length) %>% 
				ungroup 
		
		
		ref_cut <- max(NB$ref)		
		
		if(ref_cut == 0 ) {
			NB <- NB %>% mutate(varTEST = ifelse(is.na(sex_var), "NOC", sex_var),
								classif1_var = as.character(NA), 
								classif2_var = as.character(NA), 
								indicator = paste0(	str_sub(rep_var,1,9), 
											ifelse(is.na(varTEST), "", paste0(varTEST, "_")), 
											str_sub(rep_var,-2,-1))
											) %>% mutate_all(as.character)  %>% select( -ref)
		
		} else {
		
			ref_group <- paste0("classif", 1:ref_cut, "_varTEST")
			
			NB <- NB %>% separate(varTEST, ref_group, sep = ', ', remove = TRUE, extra="drop", fill = 'right') %>% 
					mutate(varTEST = ifelse(is.na(sex_var), "", sex_var)) 
		
			for( j in 1:length(ref_group)){
		
				eval(parse(text = paste0(
						"NB <- left_join(NB, select(mapping_group_by, classif",j,"_varTEST = var_name, classif",j,"_var = ilostat_version), by = 'classif",j,"_varTEST') %>% ", 
						"mutate(classif",j,"_var = ifelse(is.na(classif",j,"_var), NA, classif",j,"_var)) %>% ", 
						"select(-classif",j,"_varTEST) %>% ", 
						"mutate( varTEST = ifelse(is.na(classif",j,"_var), varTEST, paste0(varTEST, '_', str_sub(classif",j,"_var,1,3))) , ", 
								"varTEST = ifelse(str_sub(varTEST,-1,-1) %in% '_', str_sub(varTEST,1,-2), varTEST )) ")))
			
			}
			
			if(length(ref_group) == 1) NB <- NB %>% mutate(classif2_var = as.character(NA))
			
			NB <- NB %>% mutate( 
							varTEST = ifelse(str_sub(varTEST,1,1) %in% '_', str_sub(varTEST,2,-1), varTEST),
							varTEST = ifelse(varTEST %in% '', 'NOC', varTEST),
							indicator = paste0(	str_sub(rep_var,1,9), 
											ifelse(is.na(varTEST), "", paste0(varTEST, "_")), 
											str_sub(rep_var,-2,-1))) %>% 
			select(-ref) %>% mutate_all(as.character)
				
		
		
		}
		
		
			
			
						
	ref_indicator <- "([A-Z0-9]+)[-_.]([A-Z0-9]+)[-_.]([A-Z]+)[-_.]+([A-Z]+)([-_.]*)([A-Z]*)([-_.]*)([A-Z]*)([-_.]*)([A-Z]*)"
		RT <- NULL	
	
	if(nrow(ilo_tpl$Mapping_indicator %>% 
		filter(str_sub(rep_var, -2,-1) %in% "RT")) > 0) {
	mapping_rep_var <- ilo_tpl$Mapping_indicator %>% 
		filter(str_sub(rep_var, -2,-1) %in% "RT") %>% 
					pull(SUMMARISE) %>% unique() %>% 
					str_trim %>% str_extract_all(ref_indicator) %>% unlist %>% as_tibble %>% 
		mutate(rep_var = paste0(str_sub(value,1,8), str_sub(value,-3,-1))) %>% 
	rename(indicator = value)
	

	ref_indicator <- "([A-Z0-9]+)[-_.]([A-Z0-9]+)[-_.]([A-Z]+)"
			
	check <- ilo_tpl$Mapping_indicator %>% 
		filter(str_sub(rep_var, -2,-1) %in% "RT") %>% 
		rowwise() %>% 
		mutate(		REF = SUMMARISE %>% str_extract_all(ref_indicator), 
					GROUP_BY = paste0(unique(unlist(REF)), collapse = ", ") ) %>% 
		mutate(REF = REF %>% unlist %>% .[1]) %>% 
		ungroup %>% 
		distinct(REF, query_folder, rep_var, FILTER, GROUP_BY, SUMMARISE, indicator_label) 
		
	rm( mapping_rep_var)	
		
		
	
	
	if(nrow(check) > 0){
	
	for(i in 1:nrow(check)){		
		
	RT <- 
		bind_rows(
			RT,  
			NB %>% 
				filter(rep_var %in% unlist(check$REF[i])) %>% 
				mutate(add_lab = indicator_label %>% str_extract("(?=by).*") %>% gsub(" (thousands)", "", .)) %>% 
				select(frequency, ends_with('_var'), benchmark, varTEST, SELECT, rep_source, query_folder, add_lab) %>% 
				distinct() %>% 
				mutate( rep_var = check$rep_var[i], 
						indicator_label = paste0(check$indicator_label[i]," ",  add_lab), 
						GROUP_BY = check$GROUP_BY[i] %>% str_replace_all("_NB", paste0("_", varTEST, "_NB")), 
						GROUP_BY = 			GROUP_BY %>% str_replace_all("_DT", paste0("_", varTEST, "_DT")), 
						FILTER = check$FILTER[i], 
						SUMMARISE = check$SUMMARISE[i] %>% str_replace_all("_NB", paste0("_", varTEST, "_NB")),
						SUMMARISE = 		 SUMMARISE %>% str_replace_all("_DT", paste0("_", varTEST, "_DT"))
						
						) %>% 
				mutate_all(as.character)
		) 
				
	}
		
	
	ref_indicator_available <-  NB %>% pull(indicator)
	
	
	RT <-	RT %>% 					
			mutate(	indicator = paste0(	str_sub(rep_var,1,9), 
											ifelse(is.na(varTEST), "", paste0(varTEST, "_")), 
											str_sub(rep_var,-2,-1))
				) %>% 
			rowwise %>% 
			mutate(test = str_split(GROUP_BY, pattern = ', ') %>% unlist %>% length) %>% 
			mutate(test222 = str_split(GROUP_BY, pattern = ', ') %>% unlist %>% .[. %in% ref_indicator_available]%>% length) %>% 
			ungroup %>% 
			filter(test == test222) %>% 
			select(-test, -test222) %>% 
			filter(!(rep_var %in% 'SDG_0861_RT' & !indicator %in% c("SDG_0861_SEX_RT"))) %>% 
			filter(!(rep_var %in% 'SDG_0831_RT' & !indicator %in% c("SDG_0831_SEX_RT", "SDG_0831_SEX_ECO_RT"))) %>% 
			filter(!(rep_var %in% 'SDG_0852_RT' & !indicator %in% c("SDG_0852_SEX_DSB_RT", "SDG_0852_SEX_AGE_RT"))) 
											
											
		
	}

			
		rm(ref_indicator_available)
	
	}
	
	
		ilo_tpl$Mapping_indicator <- bind_rows(NB, RT) %>%	
		select(query_folder, frequency, benchmark, indicator, ends_with("_var"), SELECT, FILTER, GROUP_BY, SUMMARISE, indicator_label,	rep_source)
		
	
		
		rm(NB, RT, mapping_group_by)							
	
		
		
	############################ Mapping_classif
	
	ilo_tpl$Mapping_classif <- 
		ilo_tpl$Variable 	%>% 
			filter(!code_level %in% c("double", "character"), 
					!ilostat_code %in% NA) %>% 
			mutate(var_name = gsub("_job1", "", var_name) ) %>% 
			mutate(var_name = gsub("_job2", "", var_name) ) %>% 
			mutate(var_name = gsub("_joball", "", var_name) ) %>% 
			mutate(var_name = gsub("_joball", "", var_name) ) %>% 
			mutate(var_name = gsub("_prevocu", "_ocu", var_name) ) %>% 
			mutate(var_name = gsub("_preveco", "_eco", var_name) ) %>% 
			distinct(var_name, code_label, ilostat_code, .keep_all = TRUE) %>% 
			select(	ilostat_classif_code = ilostat_code, 
					ilo_classif_version_label =  var_label, 
					ilostat_classif_label = code_label, 
					SELECT = var_name, 
					FILTER = code_level, 
					ilostat_version) %>%
			group_by(SELECT) %>% 
			mutate(	order = 1:n(), 
					test = paste0(min(as.numeric(FILTER)),":",max(as.numeric(FILTER)))) %>% 
			ungroup %>% 
			mutate(	FILTER = paste0(SELECT, " == ", FILTER)) %>% 
			filter(!test %in% '1:1')

	ilo_tpl$Mapping_classif <- 
		bind_rows(ilo_tpl$Mapping_classif,
		ilo_tpl$Mapping_classif %>% 
			filter(order == 1) %>% 
			mutate(
				ilostat_classif_code = paste0(ilostat_version, "_TOTAL"), 
				ilostat_classif_label = "Total", 
				FILTER = paste0(SELECT, " == ", test), 
				order = 0, 
				ilostat_classif_code = ifelse(ilostat_version %in% 'GEO_COV', 'GEO_COV_NAT', ilostat_classif_code),
				ilostat_classif_code = ifelse(ilostat_version %in% 'SEX', 'SEX_T', ilostat_classif_code),
				ilostat_classif_code = ifelse(ilostat_version %in% 'AGE_YTHADULT', 'AGE_YTHADULT_YGE15', ilostat_classif_code),
				ilostat_classif_code = ifelse(ilostat_version %in% 'AGE_YTHBANDS', 'AGE_YTHBANDS_Y15-29', ilostat_classif_code),
				ilostat_classif_code = ifelse(ilostat_version %in% 'AGE_CLDVERSION', 'AGE_CLDVERSION_Y5-17', ilostat_classif_code)
				)) %>% arrange(SELECT , order) %>% 
				select(-order, -test)


saveRDS(ilo_tpl, file = paste0(MY_PATH$micro,'_Admin/template/framework/','framework_',query,'.rds'))


}			

