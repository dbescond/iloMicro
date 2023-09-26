
#' helper to work with micro data preprocessing workflow
#' 
#' From Master_x rebuild time series by copy readMe, do and fwk files, then run do file and get ILO.dta and FULL.dtaand 
#'
#' @param master_id character ie. '1' for working with master_1 and copy_1. Default = 'all', could be also '12' for master 1 and 2.
#' @param ref_area character for selection of country (iso3 code), mandatory.
#' @param source character for selection of source (as ilo micro spelling, ie. LFS), mandatory.
#' @param time , character, time use to rebuilt a specific dataset, default NULL, means all time will be takeinto account, option. 
#' @param clean, if TRUE delete files contained in the rebuild folder (not ORI repo), default TRUE.
#' @param timefrom  query to reduce time as from starting year timefrom.
#' @param timeto  query to reduce time as from ending year timeto.
#' @param add_master  if true rebuild also the master dta files, else only copy.
#' @param freq if "A" apply only to annual dataset , default "all".
#' @param CMD , default FALSE, if true return str with cmd line for all Published and Ready Country/Source
#' @param EUROSTAT , default NULL, coudl be "EULFS" or "EUSILC" 
#' @author ILO / bescond  
#' @keywords ILO, microdataset, processing
#' @examples
#' ## Not run:
#'
#' ## some example
#' 
#' 	Micro_rebuild_series(master_id = '1', ref_area = 'USA', source = 'CPS', time = '2020',freq = "A")
#'
#'  Micro_rebuild_series(master_id = '1', ref_area = 'PHL', source = 'LFS') # Master 1
#'
#'  Micro_rebuild_series(master_id = '12', ref_area = 'PHL', source = 'LFS') # Master 1 and Master2
#'
#'
#'
#'
#'  Micro_rebuild_series(ref_area = 'PHL', source = 'LFS', add_master = FALSE) # from all Masters
#'
#'
#'
#'  # run all in parallel
#'
#'	cmd <- Micro_rebuild_series(CMD = TRUE)
#'  run_parallel_ilo(cmd)
#'
#'
#'
#' ## End(**Not run**)
#' @export

Micro_rebuild_series <- function(
						master_id = 'all',
						ref_area =NULL ,
						source = NULL, 
						time = NULL, 
						clean = TRUE, 
						timefrom = NULL, 
						timeto = NULL, 
						add_master = FALSE,
						freq = "all", 
						CMD = FALSE, 
						EUROSTAT = NULL
							){

							
						# master_id = 'all'
						# ref_area = "CAN"
						# source ="LFS"
						# time = "2021M12"
						# clean = TRUE
						# timefrom = NULL
						# timeto = NULL
						# add_master = TRUE
						# freq = "all"					
							
							
		

if(!is.null(EUROSTAT)){

	if(EUROSTAT %in% 'EUSILC'){

		Micro_rebuild_series_EUSILC()
		return(NULL)

	}

	if(EUROSTAT %in% 'EULFS'){

		Micro_rebuild_series_EULFS()
		return(NULL)

	}

}




		
							

if(!is.null(ref_area)) 	ref_ref_area <- ref_area else ref_ref_area = NULL
if(!is.null(source) & ! class(source) %in% "function") 	ref_source <- source else ref_source = NULL
if(!is.null(time) & ! class(source) %in% "function") 		ref_time <- time  else ref_time = NULL
if(!is.null(timefrom)) 	ref_timefrom <- timefrom else ref_timefrom = NULL
if(!is.null(timeto)) 	ref_timeto <- timeto else ref_timeto = NULL
									
						
								
							
	
if(CMD){
	workflow <- Micro_get_workflow(ref_area = ref_ref_area, source = ref_source, timefrom = ref_timefrom, timeto = ref_timeto) %>% filter(str_detect(type, 'Copy|Master')) %>% 
	filter(processing_status %in% c('Ready', 'Published')) %>%
    distinct(ref_area, source, time) %>% 
	mutate(cmd = paste0("Micro_rebuild_series(ref_area = '",ref_area,"', source = '",source,"', time = '",time,"', add_master = TRUE)")) %>% .$cmd
	
	
	
	return(workflow)
	
	
}

						
							
	workflow <- iloMicro:::Micro_get_workflow( ref_area = ref_ref_area, source = ref_source, timefrom = ref_timefrom, timeto = ref_timeto) %>% filter(str_detect(tolower(type), 'copy|master')) %>% 
				filter(!processing_status %in% c("Not Usable", "Not started", "Not usable"))							

		
				
	checkMaster <- workflow %>% filter(str_detect(tolower(type), 'master_'))
		
	path <- paste0(workflow$file[1] %>% str_split("DPAU") %>% unlist %>% .[1], "DPAU/MICRO/", ref_area, '/', source, '/')
	
	if(master_id %in% 'all') master_id <- paste0(checkMaster$type %>% str_split('_', simplify = TRUE)%>% as.data.frame %>% .$V2, collapse = '/')

	master_id <- str_split(master_id, pattern = '/') %>% unlist
	

	if(freq %in% "A"){
	
			workflow <- workflow %>% filter((str_sub(time,5,5) %in% "" & level %in% "A") | (str_sub(time,5,5) %in% c("Q", "M") & level %in% c("Q", "M")) | str_detect(type, "Master_"))
		
	}
	
	if(freq %in% "Q"){
	
			workflow <- workflow %>% filter((str_sub(time,5,5) %in% "Q" & level %in% "A") | (str_sub(time,5,5) %in% c("Q", "M") & level %in% c("Q", "M")) | str_detect(type, "Master_"))
		
	}	
	
	if(freq %in% "M"){
	
			workflow <- workflow %>% filter(str_sub(time,5,5) %in% "M" | str_detect(type, "Master_") )
		
	}				
		
	
	
	
	for (M in 1:length(master_id))	{
	
	
		test_master <-  workflow %>% separate(type, c('test', 'keep'),remove = FALSE , sep  = '_') %>% filter(keep %in% master_id[M])  %>% select(-test, -keep)
	
		master <-  test_master %>% filter(type %in% paste0('Master_', master_id[M])) 
		
		ori_pattern <- master$rebuild_pattern
		
		if(ori_pattern %in% NA) message(paste0('Error, Master_', master_id[M], ' has no pattern, check var "rebuild_pattern" in the workflow'))
		
		master <- master %>% select(time) %>% distinct(time) %>% t %>% as.character
	
		ref_folder <- test_master %>% select(value = time)  %>% mutate(myPath = paste0(path, value, '/'))%>% arrange(desc(value)) 

		master_file <- 	list.files(paste0(path, master)) %>% enframe(name = NULL) %>% filter(str_sub(value,-6,-1) %in% c('CMD.do','K.xlsx','E.docx')) %>% distinct(value) %>% filter(!str_detect(value, fixed('~$')))

		
		test <- master_file %>% filter(str_detect(value, '_CMD.do')) %>% nrow
		
		if(test == 0) return(paste('...CMD.do file not available on ', paste0(path, master), 'folder'))		
		
		test <- master_file %>% filter(str_detect(value, '_FWK.xlsx')) %>% nrow
		
		if(test == 0) return(paste('..._FWK.xlsx file not available on ', paste0(path, master), 'folder'))		
		
		test <- master_file %>% filter(str_detect(value, 'README.docx')) %>% nrow
		
		if(test == 0) return(paste('...README.docx file not available on ', paste0(path, master), 'folder'))		
				
			
		if(!add_master) {ref_folder <- ref_folder %>% filter(!value %in% master)}
	  
	  
	  
		if(!is.null(time)) {ref_time <- time; ref_folder <- ref_folder %>% filter(value %in% ref_time)}
	
		if(!is.null(timefrom)){
			ref_time <- as.numeric(str_sub(timefrom,1,4)) 
			ref_folder <- ref_folder %>% filter(as.numeric(str_sub(value,1,4)) > ref_time - 1)
			rm(ref_time) 
		}
		if(!is.null(timeto)){
			ref_time <- as.numeric(str_sub(timeto,1,4)) 
			ref_folder <- ref_folder %>% filter(as.numeric(str_sub(value,1,4)) < ref_time + 1)
			rm(ref_time) 
		}
	
	
		if(nrow(ref_folder) == 0) {
					message(paste0('Master_', master_id[M], ' has no copy : OK'))} 
		else{
	
		for (fol in 1:nrow(ref_folder)){

		
			if(!ref_folder$value[fol] %in% master){
				a <- try(	list.files(paste0(ref_folder$myPath[fol])) %>% 
							enframe(name = NULL) %>% 
							filter(!value %in% 'ORI') %>% 
							t %>% 
							as.character %>% 
							as.list %>% 
							plyr:::l_ply(	function(x){
												file.remove(paste0(ref_folder$myPath[fol], x))
												#unlink(paste0(ref_folder$myPath[fol], x), force = TRUE)
												}
											)
					, silent = TRUE)

					
				
				# copy readMe and framework
		
				to_copy <- master_file %>% filter(!str_detect(value, "_CMD.do"))
				
				for (i in 1:nrow(to_copy)) {
					file.copy(	paste0(path, master, '/', to_copy$value[i]), paste0(ref_folder$myPath[fol], gsub(master, ref_folder$value[fol], to_copy$value[i])), overwrite = TRUE)
				}
						
				# copy the do files 		
				
				to_modify <- master_file %>% filter(str_detect(value, "_CMD.do"))
				
				for (i in 1:nrow(to_modify)) {
				
					doFile <- readLines(paste0(path, master,  '/', to_modify$value[i])) 

					doFile[doFile %>% str_detect('global time')] <- gsub(master, ref_folder$value[fol], doFile[doFile %>% str_detect('global time')])


					check_imput_name <- list.files(paste0(path, ref_folder$value[fol],'/ORI' )) %>% enframe(name = NULL) %>% filter(str_detect(tolower(value), tolower(ori_pattern))) %>% filter(str_sub(tolower(value),-4,-1) %in% '.dta') %>% t %>% as.character 
		
					if(length(check_imput_name) == 1){
			
					test <- doFile[doFile %>% str_detect('global inputFile')] %>% length
					if(test ==0 ) message(paste0('global inputFile not found plse check spelling' ))
					doFile[doFile %>% str_detect('global inputFile')] <- paste0(str_sub(doFile[doFile %>% str_detect('global inputFile')], 1, 17), shQuote(check_imput_name)) 
				
				}
				
				
				writeLines(doFile , con = paste0(ref_folder$myPath[fol], gsub(master, ref_folder$value[fol], to_modify$value[i])), sep = '\n', useBytes = TRUE)

				}	
				
				
			}
			
			
			if(add_master | (!add_master & !ref_folder$value[fol] %in% master)){
			
				setwd(ref_folder$myPath[fol])

				to_modify <- master_file %>% filter(str_detect(value, "_CMD.do"))
				
				
				for (i in 1:nrow(to_modify)) {
					
					
					if (dir.exists('C:\\ILO\\STATA')){
					
						system(paste0('"C:\\ILO\\STATA\\StataMP-64.exe" -e do "',paste0(ref_folder$myPath[fol], gsub(master, ref_folder$value[fol], to_modify$value[i])),'"'), 
						intern =TRUE, 
						ignore.stdout = TRUE, ignore.stderr = TRUE,
						wait = TRUE)
					
				
					} else {
						
						system(paste0('"J:\\DPAU\\MICRO-ANALYSIS\\_Admin\\_STATA17MP4\\StataMP-64.exe" -e do "',paste0(ref_folder$myPath[fol], gsub(master, ref_folder$value[fol], to_modify$value[i])),'"'), 
						intern =TRUE, 
						ignore.stdout = TRUE, ignore.stderr = TRUE,
						wait = TRUE)
						
				
					}
				}
				
				# closeAllConnections()
				
				
				test_files <- list.files(getwd()) %>% enframe(name = NULL) %>% filter(str_sub(value,-8,  -1) %in% c('FULL.dta', "LL19.dta",'_ILO.dta', "LO19.dta"))
				
				
				
				message(ref_folder$value[fol])
				if(nrow(test_files)< 2) {
						message(paste0(ref_area, ' / ', source, ' / ', ref_folder$value[fol], ' : Error all dta files not produced, plse check .do file'))
						message(test_files)
						return(NULL)
						if(!(ref_area %in% 'BWA' & source %in% 'MTHS'))	return(NULL)
				} else {
				
					clean_log <-  list.files(getwd()) %>% enframe(name = NULL) %>% filter(str_detect(value, ".log"))
					for (i in 1:nrow(clean_log)) unlink(paste0(ref_folder$myPath[fol], clean_log$value[i]))
				
				
					}
			
			}

		}
	
		}
		invisible(gc(reset = TRUE))
		invisible(gc(reset = TRUE))
		invisible(gc(reset = TRUE))
		invisible(gc(reset = TRUE))
		message(paste0('Rebuilding Master_', master_id[M], ' done'))
	}

	
	
	
}


Micro_rebuild_series_EUSILC <- function(){


require(openxlsx)
require(haven)

REF <- Micro_get_workflow(source = 'EUSILC', time = '2015') %>% filter(!ref_area %in% 'BEL') %>% select(ref_area, source, time, source_title) %>% 
			separate(source_title, 'source_code', sep = ' - ', extra = 'drop') %>% 
			mutate(source_code = str_sub(source_code,2,-2)) 

message("1. this function will copy BEL 2015 Master do file docx and xlsx files over each 2015 master")

for (i in 1:nrow(REF)){

# replicate do file			
		doFile <- readLines(paste0('H:/DPAU/MICRO/BEL/EUSILC/2015/BEL_EUSILC_2015_ILO_CMD.do')) 

		doFile[doFile %>% str_detect('global country')] <- paste0('global country "',REF$ref_area[i],'"')

		unlink(paste0('H:/DPAU/MICRO/', REF$ref_area[i], '/', REF$source[i], '/', REF$time[i], '/', REF$ref_area[i], '_', REF$source[i], '_', REF$time[i], '_ILO_CMD.do'))
		
		writeLines(doFile , con = paste0('H:/DPAU/MICRO/', REF$ref_area[i], '/', REF$source[i], '/', REF$time[i], '/', REF$ref_area[i], '_', REF$source[i], '_', REF$time[i], '_ILO_CMD.do'), sep = '\n', useBytes = TRUE)

		setwd(paste0('H:/DPAU/MICRO/', REF$ref_area[i], '/', REF$source[i], '/', REF$time[i], '/'))




		
		if (dir.exists('C:/ILO/STATA')){
					
					system(paste0('"C:\\ILO\\STATA\\StataMP-64.exe" -e do "',paste0(REF$ref_area[i], '_', REF$source[i], '_', REF$time[i], '_ILO_CMD.do'),'"'))
					
				
				} else {
						
					system(paste0('"J:\\DPAU\\MICRO-ANALYSIS\\_Admin\\_STATA\\StataMP-64.exe" -e do "',paste0(REF$ref_area[i], '_', REF$source[i], '_', REF$time[i], '_ILO_CMD.do'),'"'))
					
		}



		unlink(paste0(REF$ref_area[i], '_', REF$source[i], '_', REF$time[i], '_ILO_CMD.do') %>% str_replace('.do', '.log'))
	
		rm(doFile)
# replicate framework		
		unlink(paste0('H:/DPAU/MICRO/', REF$ref_area[i], '/', REF$source[i], '/', REF$time[i], '/', REF$ref_area[i], '_', REF$source[i], '_', REF$time[i], '_ILO_ilostat.csv'), force = TRUE)
		
		xlsFile <- readxl:::read_excel(paste0('H:/DPAU/MICRO/BEL/EUSILC/2015/BEL_EUSILC_2015_ILO_FWK.xlsx') )
	
		xlsFile$ilostat_code[1] <- REF$ref_area[i]
		xlsFile$ilostat_code[2] <- REF$source_code[i]

	wb <- createWorkbook()
	options("openxlsx.borderStyle" = "thin")
	options("openxlsx.borderColour" = "#4F81BD")
	## Add worksheets
	addWorksheet(wb, "framework")
	addFilter(wb, 1, row = 1, cols = 1:ncol(xlsFile))
	writeData(wb, "framework", xlsFile)



	## Save workbook to working directory
	saveWorkbook(wb, file = paste0( REF$ref_area[i], '_', REF$source[i], '_', REF$time[i], '_ILO_FWK.xlsx'), overwrite = TRUE)
	rm(wb, xlsFile)	
	
			file.copy(	from = paste0('H:/DPAU/MICRO/BEL/EUSILC/2015/BEL_EUSILC_2015_ILO_README.docx'), 
						to = paste0(paste0( REF$ref_area[i], '_', REF$source[i], '_', REF$time[i], '_ILO_README.docx') ), overwrite = TRUE )
		




message(paste0("copy / prepare master : ", REF$ref_area[i]))

}




message("2. rebuild series : ")



 Micro_rebuild_series(ref_area = 'AUT', source = 'EUSILC' )
 Micro_rebuild_series(ref_area = 'BEL', source = 'EUSILC' )
 Micro_rebuild_series(ref_area = 'BGR', source = 'EUSILC' )
 Micro_rebuild_series(ref_area = 'CHE', source = 'EUSILC' )
 Micro_rebuild_series(ref_area = 'CYP', source = 'EUSILC' )
 Micro_rebuild_series(ref_area = 'CZE', source = 'EUSILC' )
 Micro_rebuild_series(ref_area = 'DNK', source = 'EUSILC' )
 Micro_rebuild_series(ref_area = 'DEU', source = 'EUSILC' )
 Micro_rebuild_series(ref_area = 'ESP', source = 'EUSILC' )
 Micro_rebuild_series(ref_area = 'EST', source = 'EUSILC' )
 Micro_rebuild_series(ref_area = 'FIN', source = 'EUSILC' )
 Micro_rebuild_series(ref_area = 'FRA', source = 'EUSILC' )
 Micro_rebuild_series(ref_area = 'GBR', source = 'EUSILC' )
 Micro_rebuild_series(ref_area = 'GRC', source = 'EUSILC' )
 Micro_rebuild_series(ref_area = 'HRV', source = 'EUSILC' )
 Micro_rebuild_series(ref_area = 'HUN', source = 'EUSILC' )
 Micro_rebuild_series(ref_area = 'IRL', source = 'EUSILC' )
 Micro_rebuild_series(ref_area = 'ISL', source = 'EUSILC' )
 Micro_rebuild_series(ref_area = 'ITA', source = 'EUSILC' )
 Micro_rebuild_series(ref_area = 'LTU', source = 'EUSILC' )
 Micro_rebuild_series(ref_area = 'LUX', source = 'EUSILC' )
 Micro_rebuild_series(ref_area = 'LVA', source = 'EUSILC' )
 Micro_rebuild_series(ref_area = 'MLT', source = 'EUSILC' )
 Micro_rebuild_series(ref_area = 'NLD', source = 'EUSILC' )
 Micro_rebuild_series(ref_area = 'NOR', source = 'EUSILC' )
 Micro_rebuild_series(ref_area = 'POL', source = 'EUSILC' )
 Micro_rebuild_series(ref_area = 'PRT', source = 'EUSILC' )
 Micro_rebuild_series(ref_area = 'ROU', source = 'EUSILC' )
 Micro_rebuild_series(ref_area = 'SRB', source = 'EUSILC' )
 Micro_rebuild_series(ref_area = 'SVK', source = 'EUSILC' )
 Micro_rebuild_series(ref_area = 'SVN', source = 'EUSILC' )
 Micro_rebuild_series(ref_area = 'SWE', source = 'EUSILC' )




}


Micro_rebuild_series_EULFS <- function(){
#################### replicate master BEL 2015
require(tidyverse)
require(stringr)
require(openxlsx)
require(haven)
require(iloMicro)
REF <- Micro_get_workflow(source = 'EULFS', time = '2015') %>% filter(!ref_area %in% 'BEL') %>% select(ref_area, source, time, source_title) %>% 
			separate(source_title, 'source_code', sep = ' - ', extra = 'drop') 

message("1. this function will copy BEL 2015 Master do file docx and xlsx files over each 2015 master")

for (i in 1:nrow(REF)){

# replicate do file			

		mypath <- "J:/DPAU/MICRO/"
		if(REF$ref_area[i] %in% "DEU") mypath <- "H:/DPAU/MICRO/"
		
		doFile <- readLines(paste0('J:/DPAU/MICRO/BEL/EULFS/2015/BEL_EULFS_2015_ILO_CMD.do')) 

		doFile[doFile %>% str_detect('global country')] <- paste0('global country "',REF$ref_area[i],'"')

		unlink(paste0(mypath, REF$ref_area[i], '/', REF$source[i], '/', REF$time[i], '/', REF$ref_area[i], '_', REF$source[i], '_', REF$time[i], '_ILO_CMD.do'))
		
		writeLines(doFile , con = paste0(mypath, REF$ref_area[i], '/', REF$source[i], '/', REF$time[i], '/', REF$ref_area[i], '_', REF$source[i], '_', REF$time[i], '_ILO_CMD.do'), sep = '\n', useBytes = TRUE)

		setwd(paste0(mypath, REF$ref_area[i], '/', REF$source[i], '/', REF$time[i], '/'))

		system(paste0('"C:\\Program Files (x86)\\Stata14\\Stata-64.exe" -e do "',paste0(REF$ref_area[i], '_', REF$source[i], '_', REF$time[i], '_ILO_CMD.do'),'"'))

		unlink(paste0(REF$ref_area[i], '_', REF$source[i], '_', REF$time[i], '_ILO_CMD.do') %>% str_replace('.do', '.log'))
	
		rm(doFile)
# replicate framework		
		unlink(paste0(mypath, REF$ref_area[i], '/', REF$source[i], '/', REF$time[i], '/', REF$ref_area[i], '_', REF$source[i], '_', REF$time[i], '_ILO_ilostat.csv'), force = TRUE)
		
		xlsFile <- readxl:::read_excel(paste0('J:/DPAU/MICRO/BEL/EULFS/2015/BEL_EULFS_2015_ILO_FWK.xlsx') )
	
		xlsFile$ilostat_code[1] <- REF$ref_area[i]
		xlsFile$ilostat_code[2] <- REF$source_code[i]

	wb <- createWorkbook()
	options("openxlsx.borderStyle" = "thin")
	options("openxlsx.borderColour" = "#4F81BD")
	## Add worksheets
	addWorksheet(wb, "framework")
	addFilter(wb, 1, row = 1, cols = 1:ncol(xlsFile))
	writeData(wb, "framework", xlsFile)



	## Save workbook to working directory
	saveWorkbook(wb, file = paste0( REF$ref_area[i], '_', REF$source[i], '_', REF$time[i], '_ILO_FWK.xlsx'), overwrite = TRUE)
	rm(wb, xlsFile)	
	
			file.copy(	from = paste0('J:/DPAU/MICRO/BEL/EULFS/2015/BEL_EULFS_2015_ILO_README.docx'), 
						to = paste0(paste0( REF$ref_area[i], '_', REF$source[i], '_', REF$time[i], '_ILO_README.docx') ), overwrite = TRUE )
		




message(paste0("copy / prepare master : ", REF$ref_area[i]))



}



message("2. rebuild series : ")



 Micro_rebuild_series(ref_area = 'AUT', source = 'EULFS' )
 Micro_rebuild_series(ref_area = 'BEL', source = 'EULFS' )
 Micro_rebuild_series(ref_area = 'BGR', source = 'EULFS' )
 Micro_rebuild_series(ref_area = 'CHE', source = 'EULFS' )
 Micro_rebuild_series(ref_area = 'CYP', source = 'EULFS' )
 Micro_rebuild_series(ref_area = 'CZE', source = 'EULFS' )
 Micro_rebuild_series(ref_area = 'DNK', source = 'EULFS' )
 Micro_rebuild_series(ref_area = 'DEU', source = 'EULFS' )
 Micro_rebuild_series(ref_area = 'ESP', source = 'EULFS' )
 Micro_rebuild_series(ref_area = 'EST', source = 'EULFS' )
 Micro_rebuild_series(ref_area = 'FIN', source = 'EULFS' )
 Micro_rebuild_series(ref_area = 'FRA', source = 'EULFS' )
 Micro_rebuild_series(ref_area = 'GBR', source = 'EULFS' )
 Micro_rebuild_series(ref_area = 'GRC', source = 'EULFS' )
 Micro_rebuild_series(ref_area = 'HRV', source = 'EULFS' )
 Micro_rebuild_series(ref_area = 'HUN', source = 'EULFS' )
 Micro_rebuild_series(ref_area = 'IRL', source = 'EULFS' )
 Micro_rebuild_series(ref_area = 'ISL', source = 'EULFS' )
 Micro_rebuild_series(ref_area = 'ITA', source = 'EULFS' )
 Micro_rebuild_series(ref_area = 'LTU', source = 'EULFS' )
 Micro_rebuild_series(ref_area = 'LUX', source = 'EULFS' )
 Micro_rebuild_series(ref_area = 'LVA', source = 'EULFS' )
 Micro_rebuild_series(ref_area = 'MLT', source = 'EULFS' )
 Micro_rebuild_series(ref_area = 'NLD', source = 'EULFS' )
 Micro_rebuild_series(ref_area = 'NOR', source = 'EULFS' )
 Micro_rebuild_series(ref_area = 'POL', source = 'EULFS' )
 Micro_rebuild_series(ref_area = 'PRT', source = 'EULFS' )
 Micro_rebuild_series(ref_area = 'ROU', source = 'EULFS' )
 Micro_rebuild_series(ref_area = 'SRB', source = 'EULFS' )
 Micro_rebuild_series(ref_area = 'SVK', source = 'EULFS' )
 Micro_rebuild_series(ref_area = 'SVN', source = 'EULFS' )
 Micro_rebuild_series(ref_area = 'SWE', source = 'EULFS' )


}