#' helper to check dta columns and value present over times series
#'
#' Support for recoding variable, check \code{?car::Recode}, for labelling variable 
#'
#' @param ref_area character for selection of country (iso3 code), mandatory if path is not set.
#' @param source character for selection of source (as ilo micro spelling, ie. LFS), mandatory if path is not set.
#' @param time , character, time, use for a specific dataset, default NULL, mandatory if path is not set.
#' @param validate , use only ready files, default TRUE
#' @keywords ILO, microdataset, processing
#' @examples
#' ## Not run:
#'
#'
#'	X <- Micro_check_dta_series(ref_area = 'ALB', source = 'LFS')
#'
#' ## End(**Not run**)
#' @export

Micro_check_dta_series <- function(		# path = NULL, 
								ref_area =  NULL,
								source = NULL, 
								time = NULL, 
								validate = TRUE, 
								saveCSV = FALSE								
									){


# ref_area =  'PHL'
# source = 'LFS' 
# time = NULL
# validate = TRUE
# saveCSV = TRUE								







									
							
	init_wd <- getwd()
	setwd(ilo:::path$micro)
	workflow <- Micro_get_workflow() 
	if(validate) {workflow <- workflow %>% filter(processing_status %in% c('Yes', 'Ready', 'Published'), !freq_code %in% NA) }
	if(!is.null(ref_area)){refref_area <- ref_area; workflow <- workflow %>% filter(ref_area %in% refref_area); rm(refref_area) }
	if(!is.null(source)){refsource <- source; workflow <- workflow %>% filter(source %in% refsource); rm(refsource) }
	if(!is.null(time)){reftime <- time; workflow <- workflow %>% filter(time %in% reftime); rm(reftime) }
	
	my_res <- NULL


	for (i in 1:nrow(workflow)){
		########## process
		X <- Micro_load(path = workflow$file[i], asFactor = TRUE) %>% mutate_if(is.labelled, funs(as_factor(., "both"))) %>% filter(ilo_wap %in% c(1, '1'))
		ref <- colnames(X) %>% enframe(name = NULL) %>% 
					filter(	!value %in% c('ilo_key','ilo_wgt','ilo_time'), 
							!str_detect(value, '2digits'), 
							!str_detect(value, '_lri_'),
							!stringr::str_sub(value, -6,-1) %in% c('_usual', 'actual') )
		
		ref <- ref %>% mutate(query = paste0("pass <- X %>% count(label = ",ref$value,", wt = ilo_wgt/1000) %>% mutate(label = as.character(label), var = '",ref$value,"', n = round(n,1)) %>% rename(check = n) %>% select(var, label, check)"), 
							  label = paste0("pass_label <- attributes(X[['",ref$value,"']])$label")) 
		
		test <- NULL
		for (j in 1:nrow(ref)){
			eval(parse(text = ref$query[j]))
			eval(parse(text = ref$label[j]))
			pass <- pass %>% mutate(label_var = pass_label)
			test <- bind_rows(test, pass)
			rm(pass, pass_label)
		}
		
		my_res <- bind_rows(my_res, test %>% mutate(ilo_time = unique(X$ilo_time)) %>% select(ilo_time, var, label_var, label, check))
		rm(X, ref, test)
		invisible(gc(reset = TRUE))
		invisible(gc(reset = TRUE))
	print(workflow$file[i])
		
	}
	
	rm(workflow)
	setwd(init_wd)
			
			
	invisible(gc(reset = TRUE))
	
	if(saveCSV){
		 print(paste0('Step2: ', ref_area, '_', source))
		df <- my_res
			rm(my_res)
			require(ilo)
			require(seasonal)
			require(xts)

			require(lubridate)

			df <- df %>% mutate( 	Stime = as.Date('1900-01-01'),
									Stime = ifelse(stringr::str_sub(ilo_time, 5,5) %in% '', as.Date(paste0(stringr::str_sub(ilo_time,1,4), '-01-01')),Stime) %>% as.Date, 
									Stime = ifelse(stringr::str_sub(ilo_time, 5,5) %in% 'Q', as.Date(dygraphs::as.yearqtr(ilo_time, "%YQ%q")), Stime) %>% as.Date  , 
									Stime = ifelse(stringr::str_sub(ilo_time, 5,5) %in% 'M', as.Date(dygraphs::as.yearmon(ilo_time, "%YM%m")), Stime) %>% as.Date ) %>%  
						filter(!label %in% c('NaN', NA)) %>% 
						filter(!stringr::str_sub(label, 1,1) %in% as.character(0:9)) %>% 
						mutate(	label = ifelse(stringr::str_sub(label, 1,1) %in% '[', stringr::str_sub(label, 5, -1), label), 
								label = str_replace_all(label, ' ', '')) %>% 
						mutate(ts_ref =  paste0(var, '_', ifelse(stringr::str_sub(ilo_time, 5,5) %in% '', 'A', stringr::str_sub(ilo_time, 5,5))))
			



			ts_model <- list()


 
			for (ref_var in unique(df$ts_ref)){
	
			# print(unique(df$ts_ref))
				check <- df %>% filter(ts_ref %in% ref_var)
				ref_label <- unique(check$label)
				ts_group <- list()
					j <- 1
					new_check <- check %>% filter(label %in% ref_label[j]) %>% select(Stime, check)
					if(stringr::str_sub(ref_var, -1,-1) %in% 'A') {ref_time_abnd <- seq.Date(min(check$Stime),max(check$Stime),"year") %>% enframe(name = NULL) %>% rename(Stime  = value); freq_ref <- 1}
					if(stringr::str_sub(ref_var, -1,-1) %in% 'Q') {ref_time_abnd <- seq.Date(min(check$Stime),max(check$Stime),"quarter") %>% enframe(name = NULL) %>% rename(Stime  = value); freq_ref <- 4}
					if(stringr::str_sub(ref_var, -1,-1) %in% 'M') {ref_time_abnd <- seq.Date(min(check$Stime),max(check$Stime),"month") %>% enframe(name = NULL) %>% rename(Stime  = value); freq_ref <- 12}
		
		
					new_check <- new_check  %>% full_join(ref_time_abnd, by = 'Stime') %>% arrange(Stime)  
		
					ts_group <- xts(new_check$check, new_check$Stime) %>% ts(., start= min(as.numeric(stringr::str_sub(new_check$Stime,1,4))), freq = freq_ref)

			if(length(ref_label) > 1){
					for (j in 2:length(ref_label)){
						new_check <- check %>% filter(label %in% ref_label[j]) %>% select(Stime, check)
						if(stringr::str_sub(ref_var, -1,-1) %in% 'A') {ref_time_abnd <- seq.Date(min(check$Stime),max(check$Stime),"year") %>% enframe(name = NULL) %>% rename(Stime  = value); freq_ref <- 1}
						if(stringr::str_sub(ref_var, -1,-1) %in% 'Q') {ref_time_abnd <- seq.Date(min(check$Stime),max(check$Stime),"quarter") %>% enframe(name = NULL) %>% rename(Stime  = value); freq_ref <- 4}
						if(stringr::str_sub(ref_var, -1,-1) %in% 'M') {ref_time_abnd <- seq.Date(min(check$Stime),max(check$Stime),"month") %>% enframe(name = NULL) %>% rename(Stime  = value); freq_ref <- 12}
				
						new_check <- new_check  %>% full_join(ref_time_abnd, by = 'Stime') %>% arrange(Stime)  
						ts_group <- cbind(ts_group,xts(new_check$check, new_check$Stime) %>% ts(., start= min(as.numeric(stringr::str_sub(new_check$Stime,1,4))), freq = freq_ref))

		
					}
			}
			colnames(ts_group) <- ref_label
			ts_model[[ref_var]] <- ts_group
			}

	
	
		save(ts_model, file = paste0(ilo:::path$data, 'REP_ILO/MICRO/input/TEST_DTA/', ref_area, '_', source, '.Rdata'))
		
		
		rm(df, ts_model, ts_group, new_check)
		invisible(gc(reset = TRUE))
		invisible(gc(reset = TRUE))

	} else	{

	invisible(gc(reset = TRUE))
	invisible(gc(reset = TRUE))
		return(my_res)}				

}
