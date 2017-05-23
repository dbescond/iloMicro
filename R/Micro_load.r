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
#' @examples
#' ## Not run:
#'
#' ## End(**Not run**)
#' @export

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
	# if (unique(path %in% 'tpl')){
		# tmp <- tempfile()
		### download.file(url = "http://kilm.ilo.org/config/PAK_LFS_2014_2015_ILO.zip", file.path(tempdir(),'PAK_LFS_2014_2015_ILO.zip'), quiet = TRUE)
		# download.file(url = "http://laborsta.ilo.org/sti/config/PAK_LFS_2014_2015_ILO.zip", file.path(tempdir(),'PAK_LFS_2014_2015_ILO.zip'), quiet = TRUE)
		
		# con <- unzip(file.path(tempdir(),'PAK_LFS_2014_2015_ILO.zip'), files = 'PAK_LFS_2014_2015_ILO.dta', exdir = tempdir())
		# df <- haven::read_dta(con)			
		# df <- df %>% mutate(ilo_time = haven::as_factor(ilo_time) %>% as.character)
		
		# try(unzip(file.path(tempdir(),'PAK_LFS_2014_2015_ILO.zip'), exdir = tempdir(), files = 'PAK_LFS_2014_2015_ILO_FWK.xlsx'), silent = TRUE) -> testNote
		# if(length(testNote) != 0){
			# testNote <- FALSE
			# ilo_tpl$Note <- readxl::read_excel(file.path(tempdir(),'PAK_LFS_2014_2015_ILO_FWK.xlsx'), sheet= 1)
		# }  else {
			# testNote <- TRUE
		# }
		# unlink(file.path(tempdir(),'PAK_LFS_2014_2015_ILO.zip'))
		# rm(tmp)
	
	# } else{

		# if(tolower(stringr::str_sub(path, -3,-1)) %in% 'zip'){
			# df <- haven::read_dta(unzip(path, files = paste0(stringr::str_sub(basename(path),1,-4), 'dta'), exdir = tempdir()))
			
			# try(unzip(path, exdir = tempdir(), files = paste0(stringr::str_sub(basename(path),1,-5), '_FWK.xlsx')), silent = TRUE) -> testNote
			# if(length(testNote) != 0){
				# testNote <- FALSE
				# ilo_tpl$Note <- readxl::read_excel(file.path(tempdir(),paste0(stringr::str_sub(basename(path),1,-5), '_FWK.xlsx')), sheet= 1)
			# }  else {
				# testNote <- TRUE
			# }
		# }
		
			
		df <- NULL
		if(asFactor){df <- haven::read_dta(path) %>% mutate(ilo_time = ifelse(class(.$ilo_time) %in% 'numeric', as.character(ilo_time), haven::as_factor(ilo_time) %>% as.character))} else {
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
	# }
		



	
	
	# df <- haven:::zap_formats(df)
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

	# tmp <- tempfile()
	## download.file(url = "http://kilm.ilo.org/config/ILO_Micro_Guideline.zip", tmp, quiet = TRUE)
	# download.file(url = "http://laborsta.ilo.org/sti/config/ILO_Micro_Guideline.zip", tmp, quiet = TRUE)
	# unzip(tmp, exdir = tempdir(), files = '3_Framework.xlsx')
	# unlink(tmp)


	ilo_tpl$Variable 			<- readxl::read_excel(file.path('J:\\COMMON\\STATISTICS\\DPAU\\MICRO\\_Admin','3_Framework.xlsx'), sheet= 'Variable') 
	ilo_tpl$Help_classif 		<- readxl::read_excel(file.path('J:\\COMMON\\STATISTICS\\DPAU\\MICRO\\_Admin','3_Framework.xlsx'), sheet= 'Help_classif') 
	ilo_tpl$Mapping_indicator 	<- readxl::read_excel(file.path('J:\\COMMON\\STATISTICS\\DPAU\\MICRO\\_Admin','3_Framework.xlsx'), sheet= 'Mapping_indicator', col_types  =rep('text', 19)) 
	ilo_tpl$Mapping_classif 	<- readxl::read_excel(file.path('J:\\COMMON\\STATISTICS\\DPAU\\MICRO\\_Admin','3_Framework.xlsx'), sheet= 'Mapping_classif') 
	ilo_tpl$Mapping_rep_var 	<- readxl::read_excel(file.path('J:\\COMMON\\STATISTICS\\DPAU\\MICRO\\_Admin','3_Framework.xlsx'), sheet= 'Mapping_rep_var') 

	if(testNote){ilo_tpl$Note <- ilo_tpl$Variable}
	
	assign('ilo_tpl', ilo_tpl, envir =globalenv())
	# if(OpenFramework){
		# shell.exec(file = file.path(tempdir(),'3_Framework.xlsx'))
	# } else {
		# unlink(file.path(tempdir(),'3_Framework.xlsx'))
	# }
	if(!is.null(path)){
		return(df)	
	}
}


is.labelled <- function(x) inherits(x, "labelled")


zap_labels<- function(x) {
  attr(x, "labels") <- NULL
  class(x) <- NULL

  x
}


