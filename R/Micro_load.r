#' helper to load ilo.dta file for the processing process
#'
#' dataset could be manipulate during the load file base on the workflow arguments
#'
#'
#' @param path dta or zip file path for loading ilo microdataset pre precessed, default 'tpl' means that predifine example will be load, if NULL load only ilo framework.
#' @param ilo_time force microdataset ilo_time variable to a new define value, ideal to move quarterly data to yearly
#' @param asFactor loading microdataset with code and label (as.factor) if TRUE only numeric code.
#' @param Pending pass argument to delete pending columns.
#' @author ILO / bescond  
#' @keywords ILO, microdataset, processing


Micro_load <- function(	path = NULL, 
						ilo_time = NULL, 
						query = NULL, 
						asFactor = FALSE, 
						#OpenFramework = FALSE, 
						Pending = NULL){
	ilo_tpl <- list()
	ref_time <- ilo_time
	

	# load df
	testNote <- FALSE
	if(!is.null(path)){
		options(warn = -1)			
		df <- NULL
		if(asFactor){	
				df <- haven::read_dta(path) %>% mutate(ilo_time = ifelse(class(.$ilo_time) %in% 'numeric', as.character(ilo_time), haven::as_factor(ilo_time) %>% as.character)) %>% select(-contains('ilo_key'))
		} else {
			for (i in 1:length(path)){ 
				df <- bind_rows(haven::read_dta(path[i]) %>% mutate(ilo_time = ifelse(class(.$ilo_time) %in% 'numeric', as.character(ilo_time), haven::as_factor(ilo_time) %>% as.character)), df)
			}
			if(file.exists(file.path(dirname(path[1]),paste0(stringr::str_sub(basename(path[1]),1,-5), '_FWK.xlsx')))){
				testNote <- FALSE
				ilo_tpl$Note <- readxl::read_excel(file.path(dirname(path[1]),paste0(stringr::str_sub(basename(path[1]),1,-5), '_FWK.xlsx')), sheet= 1)
			}  else {
			
			testNote <- TRUE
			}
		}
	options(warn = 0)
		

	invisible(gc(reset = TRUE))
	invisible(gc(reset = TRUE))

	
	
	if(!asFactor){
		df <- df %>% mutate_if(is.labelled, funs(unclass)) 
	}
	if(!is.null(ilo_time)) {
		df <- df %>%  mutate(ilo_wgt = ilo_wgt / length(unique(ilo_time)), ilo_time = ref_time)
	}
	if(!is.null(Pending)){
		try(	df 	<- 	eval(parse(text= paste0("  df %>% ", Pending))), silent = TRUE)
		}

}

# load template


	ilo_tpl$Variable 			<- readxl::read_excel(file.path(paste0(ilo:::path$micro,'_Admin/template'),'3_Framework.xlsx'), sheet= 'Variable') 
	ilo_tpl$Mapping_indicator 	<- readxl::read_excel(file.path(paste0(ilo:::path$micro,'_Admin/template'),'3_Framework.xlsx'), sheet= 'Mapping_indicator', col_types  =rep('text', 20)) %>% filter(Is_Validate %in% c('TRUE', 'FALSE', 'QUERY'))
	ilo_tpl$Mapping_classif 	<- readxl::read_excel(file.path(paste0(ilo:::path$micro,'_Admin/template'),'3_Framework.xlsx'), sheet= 'Mapping_classif') 
	
	if(testNote){ilo_tpl$Note <- ilo_tpl$Variable}
	
	assign('ilo_tpl', ilo_tpl, envir =globalenv())
	
	invisible(gc(reset = TRUE))
	invisible(gc(reset = TRUE))
	
	if(!is.null(path)){
		return(df)	
	}
}


is.labelled <- function(x) inherits(x, "labelled")

