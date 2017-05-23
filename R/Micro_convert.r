#' helper to convert fil in dta or sav
#'
#' faster method to reencode file in correct format
#'
#' Support 
#'
#' @param in_file dta or sav file path for loading. 
#' @param country character for selection of country (iso3 code), default NULL.
#' @param source character for selection of source (as ilo micro spelling, ie. LFS), default NULL.
#' @param time , character, time, use to rebuilt a specific dataset, default NULL means all time will be takeinto account.
#' @param ori , boolean fefault  = TRUE, look inside ORI folder to detect sav file to convert in dta
#' @author ILO / bescond  
#' @keywords ILO, microdataset, processing
#' @examples
#' ## Not run:
#'
#' Micro_convert(in_file = 'J:/COMMON/STATISTICS/DPAU/MICRO/ARG/QLFS/2003Q3/ORI/Individual_t303.sav')
#'
#' Micro_convert(country = 'ARG', source = 'LFS', time = '2010', encoding  = 'latin1')
#'
#' ## End(**Not run**)
#' @export



Micro_convert <- function(	in_file  = NULL, 
							country = NULL,
							source = NULL,
							time = NULL, 
							ori = TRUE, 
							encoding = NULL
							){

							
	if(!is.null(in_file)){							
		name <- basename(in_file)
		path <- dirname(in_file)
			if(str_sub(tolower(name),-4,-1) %in% c('.dta', '.DTA')){Micro_convert_dta(in_file); return('dta to sav ok')}
			if(str_sub(tolower(name),-4,-1) %in% c('.sav', '.SAV')){Micro_convert_sav(in_file, encoding); return('sav to dta ok')}
		}

	if(!is.null(country) & !is.null(source)){
	
	
		path <- paste0(ilo:::path$micro, country, '/', source, '/')		
		
		ref_time <- list.files(path)%>% as_data_frame()	 %>% filter(substr(value,1,2) %in% '20')	

		if(!is.null(time)) {check <- time; ref_time <- ref_time %>% filter(value %in% check)}
	
			for (i in 1:nrow(ref_time)) {
				check <-  list.files(paste0(path, ref_time$value[i], ifelse(ori, "/ORI/", '')))%>% as_data_frame() %>% filter(str_sub(value,-4,-1)%in% '.sav')
				
				if(nrow(check)>0) {
					for (j in 1:nrow(check)){
						path_ori <- paste0(path, ref_time$value[i], ifelse(ori, "/ORI/", ''))
						file <- check$value[j]
						init_path <- getwd()
						setwd(path_ori)

						# X <- read_sav( file)			
						# protection 
						# colnames(X) <- colnames(X) %>% str_replace('\\$', '')
						# X %>% write_dta(path =  str_replace(file, '.sav', '.dta'))				
						# file <- str_replace(file, '.sav', '.dta')
				
	
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
			
		
						writeLines(cmd , con = paste0(path_ori, str_replace(file, '.sav', ''), ".do"), sep = '\n', useBytes = TRUE)

						system(paste0('"C:\\Program Files (x86)\\Stata14\\Stata-64.exe" do "',paste0(path_ori, str_replace(file, '.sav', ''), ".do"),'"'))
						unlink('bak.stunicode', recursive = TRUE, force = TRUE)


						
						
						unlink(paste0(str_replace(file, '.sav', ''), ".do"))
						unlink(paste0(str_replace(file, '.sav', ''), ".log"))
						print(paste0('on ', ref_time$value[i], '/ ', nrow(ref_time), 'built : ', check$value[j]))
						setwd(init_path)
					}
			}
	}

return('ok')
}
	if(!(!is.null(country) & !is.null(source))) return('country AND source should be provide, or at least in_file')
		
			
}



Micro_convert_dta <- function(file){
			file <- str_replace(file, '.DTA', '.dta')
			X <- read_dta( file)			
			
			# protection 
			colnames(X) <- colnames(X) %>% str_replace('\\$', '')
			
			
			X %>% write_sav(path =  str_replace(file, '.dta', '.sav'))				




}

Micro_convert_sav <- function(file, encoding){

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
						print(paste0('on ', ref_time$value[i], '/ ', nrow(ref_time), 'built : ', check$value[j]))
						setwd(init_path)
			
			
			}, silent = TRUE)
			
			
}


