#' helper to convert fil in dta or sav
#'
#' faster method to reencode file in correct format
#'
#' Support 
#'
#' @param in_file dta or sav file path for loading. 
#' @param ref_area character for selection of country (iso3 code), default NULL.
#' @param source character for selection of source (as ilo micro spelling, ie. LFS), default NULL.
#' @param time , character, time, use to rebuilt a specific dataset, default NULL means all time will be takeinto account.
#' @param ori , boolean default  = TRUE, look inside ORI folder to detect sav file to convert in dta
#' @author ILO / bescond  
#' @keywords ILO, microdataset, processing
#' @examples
#' ## Not run:
#'
#' ## convert all sav
#'
#' Micro_convert_sav(in_file = 'J:\\DPAU\\MICRO\\GEO\\IHS\\2012\\ORI\\Data\\') 
#'
#' Micro_convert_sav(in_file = 'J:/DPAU/MICRO/ARG/EPH/2003Q3/ORI/Data/Individual_t303.sav', encoding = 'latin1')
#'
#' ## End(**Not run**)
#' @export



Micro_convert_sav <- function(	in_file  = NULL, 
							ref_area = NULL,
							source = NULL,
							time = NULL, 
							ori = TRUE, 
							encoding = NULL
							){

		
	
	
	
	if(!is.null(in_file)){	
		
		in_file <- gsub("\\\\", "/", in_file)
	
		if(str_sub(in_file,-1,-1) %in% '/' | str_sub(in_file, -2,-1) %in% '\\'){
			
			ref <- list.files(in_file) %>% as_tibble %>% filter(str_detect(tolower(value), '.sav'))
		
			for (i in 1:nrow(ref)){  Micro_convert_sav(in_file = paste0(in_file, ref$value[i]))}
		
		}

	
		file <- basename(in_file)
		path <- dirname(in_file)
			
		file.remove( tempdir() %>% dirname %>% list.files %>% as_tibble %>% filter(str_sub( value,-4,-1) %in% '.tmp') %>% mutate(path = paste0(tempdir() %>% dirname , '/', value)) %>%  .$path)
						
		
			path_ori <- path
						init_path <- getwd()
						setwd(path_ori)

					
				ref_encoding <- NULL
				ref_translate <- NULL
				if(!is.null(encoding)){
						ref_encoding <- paste0("unicode encoding set ", encoding)
						ref_translate <- paste0("unicode translate ", '"',str_replace(tolower(file), '.sav', '.dta'), '"')
					}
						cmd <- c(	'clear all', 
						'set more off',
						paste0('cd "', path_ori, '"'), 
						paste0('usespss "', file, '"'), 
						# "compress", 
						paste0('save ', paste0('"',str_replace(tolower(file), '.sav', '.dta'), '"', ', replace')), 
						'clear all', 
						ref_encoding, 
						ref_translate)
			
		
						writeLines(cmd , con = paste0(path_ori,'/', str_replace(tolower(file), '.sav', ''), ".do"), sep = '\n', useBytes = TRUE)

					
						try(system(paste0('"C:\\Program Files (x86)\\Stata14\\Stata-64.exe" do "',paste0(path_ori,'/', str_replace(tolower(file), '.sav', ''), ".do"),'"'), wait = FALSE))
						
						Sys.sleep(10)

				
						file.remove( tempdir() %>% dirname %>% list.files %>% as_tibble %>% filter(str_sub( value,-4,-1) %in% '.tmp') %>% mutate(path = paste0(tempdir() %>% dirname , '/', value)) %>%  .$path)
						
						system(paste0('TASKKILL /F /IM Stata-64.exe /T'))
						
						unlink('bak.stunicode', recursive = TRUE, force = TRUE)

		
						file.remove(	paste0(str_replace(file, '.sav', ''), ".do"))
						
						setwd(init_path)
			
			
			
		}

	if(!is.null(ref_area) & !is.null(source) & is.null(in_file)){
	
	
		path <- paste0(ilo:::path$micro, ref_area, '/', source, '/')		
		
		ref_time <- list.files(path)%>% as_tibble()	 %>% filter(substr(value,1,2) %in% '20')	

		if(!is.null(time)) {check <- time; ref_time <- ref_time %>% filter(value %in% check)}
	
			for (i in 1:nrow(ref_time)) {
				check <-  list.files(paste0(path, ref_time$value[i], ifelse(ori, "/ORI/", '')))%>% as_tibble() %>% filter(stringr::str_sub(tolower(value),-4,-1)%in% '.sav')
				
				if(nrow(check)>0) {
					for (j in 1:nrow(check)){
						path_ori <- paste0(path, ref_time$value[i], ifelse(ori, "/ORI/", ''))
						file <- check$value[j]
						init_path <- getwd()
						setwd(path_ori)

	
				ref_encoding <- NULL
				ref_translate <- NULL
				if(!is.null(encoding)){
						ref_encoding <- paste0("unicode encoding set ", encoding)
						ref_translate <- paste0("unicode translate ", '"',str_replace(tolower(file), '.sav', '.dta'), '"')
					}
						cmd <- c(	'clear all', 
						'set more off',
						paste0('cd "', path_ori, '"'), 
						paste0('usespss "', file, '"'), 
						# "compress", 
						paste0('save ', paste0('"',str_replace(tolower(file), '.sav', '.dta'), '"', ', replace')), 
						'clear', 
						ref_encoding, 
						ref_translate,
						'exit, clear', 
						'exit')
			
		
						writeLines(cmd , con = paste0(path_ori, str_replace(tolower(file), '.sav', ''), ".do"), sep = '\n', useBytes = TRUE)

						system(paste0('"C:\\Program Files (x86)\\Stata14\\Stata-64.exe" -e do "',paste0(path_ori, str_replace(tolower(file), '.sav', ''), ".do"),'"'))
						# system(paste0('TASKKILL /F /IM Stata-64.exe /T'))
						
						try(unlink('bak.stunicode', recursive = TRUE, force = TRUE), silent  = TRUE)


						
						
						unlink(paste0(str_replace(file, '.sav', ''), ".do"))
						unlink(paste0(str_replace(file, '.sav', ''), ".log"))
						print(paste0('on ', ref_time$value[i], '/ ', nrow(ref_time), 'built : ', check$value[j]))
						setwd(init_path)
					}
			}
	}

return('ok')
}
		
			
}



Micro_convert_dta_old <- function(file){
			file <- str_replace(file, '.DTA', '.dta')
			X <- read_dta( file)			
			
			# protection 
			colnames(X) <- colnames(X) %>% str_replace('\\$', '')
			
			
			X %>% write_sav(path =  str_replace(file, '.dta', '.sav'))				




}

Micro_convert_sav_old <- function(file, encoding){

			file <- str_replace(file, '.SAV', '.sav')
			#X <- read_sav( file)			
			
			# protection 
			#colnames(X) <- colnames(X) %>% str_replace('\\$', '')
			#for (i in 1:ncol(X)){
			#					try(attributes(X[[i]])$format.spss <- NULL, silent = TRUE)
			#					#try(attributes(X[[i]])$display_width <- NULL, silent = TRUE)
			#				}		
	
			#X %>% write_dta(path =  str_replace(file, '.sav', '.dta'))	
			
			try({
			
			path_ori <-  dirname(file)
			init_path <- getwd()
			setwd(path_ori)
			file <- basename(file)

				ref_encoding <- NULL
				ref_translate <- NULL
				if(!is.null(encoding)){
						ref_encoding <- paste0("unicode encoding set ", encoding)
						ref_translate <- paste0("unicode translate ", '"',str_replace(file, '.sav', '.dta'), '"')
					}
						cmd <- c(	'clear all', 
						'set more off',
						paste0('cd "', path_ori, '"'), 
						paste0('usespss "', file, '"'), 
						# "compress", 
						paste0('save ', paste0('"',str_replace(file, '.sav', '.dta'), '"', ', replace')), 
						'clear', 
						ref_encoding, 
						ref_translate,
						'exit')
			
		
						writeLines(cmd , con = paste0(str_replace(file, '.sav', ''), ".do"), sep = '\n', useBytes = TRUE)
					system(paste0('"C:\\Program Files (x86)\\Stata14\\Stata-64.exe" do "',paste0(path_ori, str_replace(file, '.sav', ''), ".do"),'"'))
						unlink('bak.stunicode', recursive = TRUE, force = TRUE)


						
						
						unlink(paste0(str_replace(file, '.sav', ''), ".do"))
						unlink(paste0(str_replace(file, '.sav', ''), ".log"))
						try(print(paste0('on ', ref_time$value[i], '/ ', nrow(ref_time), 'built : ', check$value[j])), silent = TRUE)
						setwd(init_path)
			
			
			}, silent = TRUE)
			
			
}

