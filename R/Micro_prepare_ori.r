#' helper to load and prepare original file
#'
#' dataset could be manipulate during the load file base on the workflow arguments
#'
#'
#' @param ref_area country.
#' @param source .
#' @param time reference original dataset time
#' @param wd work directory, path folder of the original dataset, 'default'
#' @author ILO / bescond  
#' @keywords ILO, microdataset, processing
#' @examples
#' ## Not run:
#'
#' # test that
#' Micro_prepare_ori(ref_area = 'CAN', source = 'LFS', time = '2017M01')
#'
#' ## End(**Not run**)
#' @export

Micro_prepare_ori <- function(ref_area, source, time, wd = 'default'){

init <- getwd()
type <- paste0(ref_area, '_', source)

run <- function(time, type) {

  switch(type,
         CAN_LFS = Micro_prepare_CAN_LFS(ref_area, source, time, wd),
         MEX_ENOE = Micro_prepare_MEX_ENOE(ref_area, source, time, wd),
		 BRA_PNADC = Micro_prepare_BRA_PNADC(ref_area, source, time, wd), 
		 ESP_EPA = Micro_prepare_ESP_EPA(ref_area, source, time, wd),
		 USA_CPS = Micro_prepare_USA_CPS(ref_area, source, time, wd)
		 
		 )
}

run(time, type)

setwd(init)		 
		 
		 
}

Micro_prepare_MEX_ENOE <- function(ref_area, source, time, wd){

	if(wd %in% 'default') {
		setwd(paste0(ilo:::path$micro,ref_area,'/',source,'/', time, '/ORI/Data'))	
	} else {
	setwd(wd)
	}
 
 
	meta <- list()

	meta$coe1 <- read_csv(paste0(ilo:::path$micro, "/MEX/ENOE/Documentation/diccionario_datos_coe1.csv"), col_type = 'cccccc') 
		meta$coe1 <- meta$coe1[, c(1,4)]
		colnames(meta$coe1) <- c('label', 'code')

	meta$coe2 <- read_csv(paste0(ilo:::path$micro, "/MEX/ENOE/Documentation/diccionario_datos_coe2.csv"), col_type = 'cccccc') 
		meta$coe2 <- meta$coe2[, c(1,4)]
		colnames(meta$coe2) <- c('label', 'code')

	meta$hog <- read_csv(paste0(ilo:::path$micro, "/MEX/ENOE/Documentation/diccionario_datos_hog.csv"), col_type = 'cccccc') 
		meta$hog <- meta$hog[, c(1,4)]
		colnames(meta$hog) <- c('label', 'code')

	meta$sdem <- read_csv(paste0(ilo:::path$micro, "/MEX/ENOE/Documentation/diccionario_datos_sdem.csv"), col_type = 'cccccc') 
		meta$sdem <- meta$sdem[, c(1,4)]
		colnames(meta$sdem) <- c('label', 'code')

	meta$viv <- read_csv(paste0(ilo:::path$micro, "/MEX/ENOE/Documentation/diccionario_datos_viv.csv"), col_type = 'cccccc') 
		meta$viv <- meta$viv[, c(1,4)]
		colnames(meta$viv) <- c('label', 'code')

	metadata <- bind_rows(meta$coe1, meta$coe2, meta$hog, meta$sdem, meta$viv) %>% distinct(code, .keep_all = TRUE) %>% mutate(code = toupper(code))
	
	rm(meta)	
	
	ref_files <- list.files() %>% 
					as_data_frame %>% 
					filter(str_detect(tolower(value), 'dbf'), !str_detect(tolower(value), '.zip')) 

				
									
	stata_code <- NULL
	spss_code <- NULL
	
	for (i in 1:nrow(ref_files)){

		X <- foreign:::read.dbf(ref_files$value[i]) %>% as.tbl
		colnames(X) <- gsub('\\$', '', colnames(X))			
		X <- X %>% mutate_if(is.factor, funs(as.character), user_na = TRUE)
	
		for (j in 1:ncol(X)){

			if(length(metadata %>% filter(code %in% colnames(X)[j]) %>% select(label) %>% t %>% as.character)> 0){
	
				attributes(X[[j]])$label <- metadata %>% filter(code %in% colnames(X)[j]) %>% select(label) %>% t %>% as.character
				
				if(max(nchar(as.character(X[[j]])), na.rm = TRUE) > 30 ){
				X[[j]] <- as.factor(X[[j]])
				
				}
				# print(paste0(colnames(X)[j], "   :" , max(nchar(as.character(X[[j]])), na.rm = TRUE)))
		
			}
		}	

		path_file <-  ref_files$value[i]%>% str_replace('.dbf', '.dta')
	
		X %>% haven:::write_dta(path = path_file)				
	
	
	
		rm(X)
		invisible(gc(reset = TRUE))
		invisible(gc(reset = TRUE))
		invisible(gc(reset = TRUE))
		inputPath <- paste0(getwd(), '/')
		stata_code <- c(stata_code, 	
			paste0('cd ', '"',inputPath,'"\n'), 
			paste0('use ', '"', tolower(ref_files$value[i]) %>% str_replace('.dbf', '.dta'),'"\n'), 
			paste0('compress \n'), 
			paste0('save ', '"',inputPath, tolower(ref_files$value[i]) %>% str_replace('.dbf', '.dta'),'", replace \n'), 
			paste0('clear all \n')
			)
	
	} 
 
 return(stata_code)		
}	

Micro_prepare_CAN_LFS <- function(ref_area, source, time, wd){
	
	if(wd %in% 'default') {
		setwd(paste0(ilo:::path$micro,ref_area,'/',source,'/', time, '/ORI'))	
	} else {
	setwd(wd)
	}

	ref_files <- list.files() %>% as_data_frame 

	ref_layout <- ref_files %>% filter(str_sub(value, -10, -1) %in% 'layout.txt') %>% t %>% as.character
	Layout <- read_fwf(ref_layout, 
					fwf_empty(ref_layout, col_names = c("Start", "Name", "Size")), 
					col_types = cols(
									Start = col_character(),
									Name = col_character(),
									Size = col_character())
				) %>% mutate(Type = ifelse(str_detect(Size, fixed('$')), 'char', 'num'), 
							Size = Size %>% readr::parse_number(), 
							Start = Start %>% readr::parse_number(),
							Stop = Start - 1 + Size, 
							Name = toupper(Name)) %>%
	left_join(read_csv('CAN_var_label.csv', col_types = cols(
												Name = col_character(),
												Label = col_character())
						), by = "Name"
		)						

	ref_dataset <- ref_files %>% filter(str_sub(value, -4, -1) %in% '.prn') %>% t %>% as.character	
	if(length(ref_dataset) == 0){ 
			message(paste(ref_area, source, time, 'No datafile found'))	
			return(NULL)}
	DATA <- readLines(ref_dataset)%>% as_data_frame

	for (j in 1:nrow(Layout)){
	
		eval(parse(text = paste0( 'DATA <- DATA %>% mutate(',Layout$Name[j],' = str_sub(value,',Layout$Start[j],',',Layout$Stop[j],'), ',Layout$Name[j],' = str_trim(',Layout$Name[j],'))'     )))

	}

	DATA <- DATA %>% select(-value)	%>%	
			mutate_all(funs(ifelse(. %in% '', NA, .)))

	for (j in 1:nrow(Layout)){
	
		if(Layout$Type[j] %in% 'num') {
			eval(parse(text = paste0( 'DATA <- DATA %>% mutate(',Layout$Name[j],' = as.numeric(',Layout$Name[j],'))'     )))
		}
		attributes(DATA[[j]])$label <- Layout$Label[j]

	}
	
	
		
	
	ref_dta_file <- ref_dataset %>% str_replace('.prn', '.dta')	
	rm(ref_dataset)	
	DATA %>% haven:::write_dta(path = ref_dta_file)				
	rm(DATA)

	myPath <- paste0(getwd(), '/')
	
		invisible(gc(reset = TRUE))
		invisible(gc(reset = TRUE))
		cmd <- c(	'clear all', 
			'set more off',
			paste0('cd "', myPath, '"'), 
			paste0('use "', ref_dta_file, '"'), 
			"compress", 
			paste0('save ', paste0('"',ref_dta_file, '"', ', replace')), 'exit')
			
		
		writeLines(cmd , con = paste0( ref_dta_file, ".do"), sep = '\n', useBytes = TRUE)
		system(paste0('"C:\\Program Files (x86)\\Stata14\\Stata-64.exe" -e do "',paste0(myPath, ref_dta_file, ".do"),'"'))
		unlink(paste0( ref_dta_file, ".do"))
		unlink(paste0( ref_dta_file %>% str_replace('.dta', '.log')))
		
		invisible(gc(reset = TRUE))


							
}

Micro_prepare_BRA_PNADC <- function(ref_area, source, time, wd){

	if(wd %in% 'default') {
		setwd( paste0(ilo:::path$micro,ref_area,'/',source,'/', time, '/ORI/Data'))	
	} else {
	setwd(wd)
	}
	
	ref_files <- list.files() %>% as_data_frame 

	ref_layout <- ref_files %>% filter(str_sub(value, -4, -1) %in% '.txt', str_detect(tolower(value), 'input')) %>% t %>% as.character
	test <- readLines(ref_layout) %>% as_data_frame %>% mutate(ref = 1:n()) 
	first_line <- test %>% filter(tolower(value) %in% 'input') %>% .$ref + 1
	last_line <- test %>% filter(tolower(value) %in% 'run;') %>% .$ref -2
	
	Layout <- test %>% slice(first_line:last_line) %>% select(value)  %>% t %>% as.character %>% 
				str_replace_all('      ', ' ') %>% 
				str_replace_all('     ', ' ') %>% 
				str_replace_all('    ', ' ') %>% 
				str_replace_all('   ', ' ') %>% 
				str_replace_all('  ', ' ') %>%
				as_data_frame %>%
				separate(value, c("Start", "Name", "Size", 'Label'), sep = ' ', extra = 'merge') %>% 
				mutate(Label = str_sub(Label, 4, -4))%>% 
				mutate(Type = ifelse(str_detect(Size, fixed('$')), 'char', 'num'), 
							Size = Size %>% readr::parse_number(), 
							Start = Start %>% readr::parse_number(),
							Stop = Start - 1 + Size) 
	
	rm(test,first_line, last_line)
							
	ref_dataset_zip <- ref_files %>% filter(str_sub(value, -4, -1) %in% '.zip', str_sub(value,1,5) %in% 'PNADC') %>% t %>% as.character			
	ref_dataset <- unzip(ref_dataset_zip, list = TRUE) %>% filter(str_sub(Name, -4, -1) %in% '.txt', str_sub(Name,1,5) %in% 'PNADC') %>% .$Name %>% t %>% as.character
	
	DATA <- readLines(unz(ref_dataset_zip,ref_dataset ))%>% as_data_frame
	
	for (j in 1:nrow(Layout)){
	
		eval(parse(text = paste0( 'DATA <- DATA %>% mutate(',Layout$Name[j],' = str_sub(value,',Layout$Start[j],',',Layout$Stop[j],'), ',Layout$Name[j],' = str_trim(',Layout$Name[j],'))'     )))

	}

	DATA <- DATA %>% select(-value)	%>%	
			mutate_all(funs(ifelse(. %in% c('', '.'), NA, .)))
	todel_var <- NULL
	for (j in 1:nrow(Layout)){
	
		if(Layout$Type[j] %in% 'num') {
			# print(Layout$Name[j])
			eval(parse(text = paste0( 'DATA <- DATA %>% mutate(',Layout$Name[j],' = as.numeric(',Layout$Name[j],'))'     )))
		}
		attributes(DATA[[j]])$label <- Layout$Label[j]
		if(is.logical(DATA[[j]])){
			if(unique(DATA[[j]]) %in% NA){ todel_var <- c(todel_var, names(DATA)[j])}
		}
	}
	
	
	if(length(todel_var)>0){
		for(i in 1:length(todel_var)){
			eval(parse(text = paste0( 'DATA <- DATA %>% select(-',todel_var[i],')'     )))
		}	
	}
	
	
		
	
	ref_dta_file <- ref_dataset %>% str_replace('.txt', '.dta')	
	rm(ref_dataset)
	DATA %>% haven:::write_dta(path = ref_dta_file)				
	rm(DATA)

	myPath <- paste0(getwd(), '/')
	
		invisible(gc(reset = TRUE))
		invisible(gc(reset = TRUE))
		cmd <- c(	'clear all', 
			'set more off',
			paste0('cd "', myPath, '"'), 
			paste0('use "', ref_dta_file, '"'), 
			"compress", 
			paste0('save ', paste0('"',ref_dta_file, '"', ', replace')), 'exit')
			
		
		writeLines(cmd , con = paste0( ref_dta_file, ".do"), sep = '\n', useBytes = TRUE)
		system(paste0('"C:\\Program Files (x86)\\Stata14\\Stata-64.exe" -e do "',paste0(myPath, ref_dta_file, ".do"),'"'))
		unlink(paste0( ref_dta_file, ".do"))
		unlink(paste0( ref_dta_file %>% str_replace('.dta', '.log')))
		
		invisible(gc(reset = TRUE))


}

Micro_prepare_ESP_EPA <- function(ref_area, source, time, wd){
	
	if(wd %in% 'default') {
		setwd(paste0(ilo:::path$micro,ref_area,'/',source,'/', time, '/ORI/Data'))	
	} else {
	setwd(wd)
	}

	
	zipFile <- list.files() %>% 
					as_data_frame %>% 
					filter(str_sub(tolower(value),-3,-1) %in% 'zip') %>% filter(substr(value,1,6) %in% 'datos_') %>% t %>% as.character
	 unzip(zipFile )
	xlsFile <- list.files() %>% 
					as_data_frame %>% 
					filter(str_sub(tolower(value),-3,-1) %in% 'zip') %>% filter(substr(value,1,7) %in% 'disereg') %>% t %>% as.character
	 unzip(xlsFile )


	

	FileOri <- list.files() %>% 
					as_data_frame %>% 
					filter(!str_sub(tolower(value),-3,-1) %in% 'zip', !str_detect(value, 'Data|Technical|Original|Questionnaire|Techinical|Report|Internal|.pdf'))
	test <- 'EPA'
	file <- FileOri %>% filter(substr(value,1,3) %in% test) %>% t %>% as.character
	X <- readLines(paste0( file)) %>% as_data_frame
	filexl <- FileOri %>% filter(str_detect(value,'.xls')) %>% t %>% as.character
	REF <- readxl:::read_excel(paste0( filexl), sheet = 3, skip = 5) %>% 
				filter( !CAMPO %in% NA) %>% 
				distinct(CAMPO, .keep_all = TRUE) %>% 
				mutate(	
						COMIENZO = as.numeric(COMIENZO), 
						FIN = as.numeric(FIN), 
						LONGITUD = as.numeric(LONGITUD)
						) %>% 
				filter(LONGITUD > 0) %>% 
				mutate(id = 1:n())
	check <- REF %>% filter(CAMPO %in% 'FACTOREL' ) %>% select(id) %>% slice(1)%>% t %>% as.character			
		
	REF <- REF %>% slice(1:check) %>% 
	mutate(
			CAMPO = ifelse(str_sub(CAMPO,-1,-1) %in% '*', str_sub(CAMPO,1,-2), CAMPO), 
			CAMPO = ifelse(str_sub(CAMPO,-2,-2) %in% '*', paste0(str_sub(CAMPO,1,-3), str_sub(CAMPO,-1,-1)), CAMPO), 
			CAMPO = ifelse(str_sub(CAMPO,-3,-3) %in% '*', paste0(str_sub(CAMPO,1,-4), str_sub(CAMPO,-2,-1)), CAMPO), 
			CAMPO = gsub(' ', '_', CAMPO), 
			CAMPO = gsub('-', '_', CAMPO) 
			)
		
	for (i in 1:nrow(REF)){
	
	eval(parse(text = paste0( 'X <- X %>% mutate(',REF$CAMPO[i],' = str_sub(value,',REF$COMIENZO[i],',',REF$FIN[i],'))'     )))
	
	}
	
	X <- X %>% select(-value) %>% 
			mutate_all(funs(gsub('  ', ' ', .))) %>% 
			mutate_all(funs(gsub(' ', '', .))) %>% 
			mutate_all(funs(ifelse(. %in% '', NA, .))) 
			
	for (i in 1:ncol(X)){attributes(X[[i]])$label <- REF$`DESCRIPCIÓN DEL CAMPO`[i]}
		
			X %>% haven:::write_dta(path = paste0( file, ".dta"))
			
		
			

	rm(X)
	ref_dta_file <- paste0( file, ".dta") 
				
	myPath <- paste0(getwd(), '/')

	
		invisible(gc(reset = TRUE))
		invisible(gc(reset = TRUE))
		cmd <- c(	'clear all', 
			'set more off',
			paste0('cd "', myPath, '"'), 
			paste0('use "', ref_dta_file, '"'), 
			"compress", 
			paste0('save ', paste0('"',ref_dta_file, '"', ', replace')), 'exit')
			
		
		writeLines(cmd , con = paste0( ref_dta_file, ".do"), sep = '\n', useBytes = TRUE)
		system(paste0('"C:\\Program Files (x86)\\Stata14\\Stata-64.exe" -e do "',paste0(myPath, ref_dta_file, ".do"),'"'))
		unlink(paste0( ref_dta_file, ".do"))
		unlink(paste0( ref_dta_file %>% str_replace('.dta', '.log')))
		
		invisible(gc(reset = TRUE))
		
}

Micro_prepare_USA_CPS <- function(ref_area, source, time, wd){
	
	if(wd %in% 'default') {
		setwd(paste0(ilo:::path$micro,ref_area,'/',source,'/', time, '/ORI/Data/'))	
	} else {
	setwd(wd)
	}
	
	
	
	ref_files <- list.files() %>% as_data_frame 

	ref_data <- ref_files %>% filter(str_detect(value, '.zip')) %>% .$value
	ref_dic <- ref_files %>% filter(str_detect(value, 'ILO_DIC_')) %>% .$value


	fileName <- unzip(ref_data, list = TRUE)$Name

	
	DATA <- readLines(unz(ref_data, fileName))%>% as_data_frame
	REF <-  read_csv( ref_dic  )
	
	
	for (j in 1:nrow(REF)){
	
		eval(parse(text = paste0( 'DATA <- DATA %>% mutate(',REF$NAME[j],' = str_sub(value,',REF$START[j],',',REF$END[j],'))'     )))

	}			
		
	
	DATA <- DATA %>% select(-value)	
	DATA <- DATA %>% mutate_all(funs(gsub('  ', ' ', .)))
	invisible(gc(reset = TRUE))
	invisible(gc(reset = TRUE))
	DATA <- DATA %>% 		mutate_all(funs(gsub(' ', '', .))) 
	invisible(gc(reset = TRUE))
	invisible(gc(reset = TRUE))
	DATA <- DATA %>% 		mutate_all(funs(ifelse(. %in% '', NA, .))) 
	invisible(gc(reset = TRUE))
	invisible(gc(reset = TRUE))	
	DATA <- DATA %>% 		mutate_all(funs(ifelse(. %in% '-1', NA, .)))     ########## transform -1 in NA in order to reduce to integer when i   
		
		################ revised
	REF <- REF %>% distinct(NAME, DESCRIPTION)
		for (j in 1:ncol(DATA)){
			info <- REF %>% filter(NAME %in% colnames(DATA)[j])
			test <- unique(DATA[[info$NAME[1]]]) %>% as.numeric %>% as.character %in% unique(DATA[[info$NAME[1]]])  %>% unique
			if(length(test) %in% 1 ) { if(test %in% TRUE) {	eval(parse(text = paste0( 'DATA <- DATA %>% mutate(',info$NAME[1],' = as.numeric(',info$NAME[1],'))'     )))
		}}
		rm(info, test)
	}
	
	

		
	for (k in 1:ncol(DATA)){attributes(DATA[[k]])$label <- REF$DESCRIPTION[k]}
	a <- getwd()	%>% str_replace(fixed('/ORI/Data'), '/ORI')	
	setwd(a)
	file <- paste0( 'USA_CPS_',time, '.dta') 
	DATA %>% haven:::write_dta(path = file)				
		
	myPath <- paste0(getwd(), '/')
rm(DATA, REF, file)
	
		
invisible(gc(reset = TRUE))
invisible(gc(reset = TRUE))
		cmd <- c(	'clear all', 
			'set more off',
			paste0('cd "',myPath , '"'), 
			paste0('use "', file, '"'), 
			"compress", 
			paste0('save ', paste0('"',file, '"', ', replace')), 'exit')
			
		
		writeLines(cmd , con = paste0( file, ".do"), sep = '\n', useBytes = TRUE)
		system(paste0('"C:\\Program Files (x86)\\Stata14\\Stata-64.exe" -e do "',paste0(myPath, file, ".do"),'"'))
		unlink(paste0(myPath, file, ".do"))
		unlink(paste0(myPath, file, ".log"))
		unlink(paste0(myPath, file, ".log"))
		unlink(paste0(myPath, file, ".log"))
		
	invisible(gc(reset = TRUE))


	

	
	
}


