#' helper add label in the micro - preprocessing stage in R do file
#'
#' not longer used 
#'
#'
#' @param add.total internal attribute to add total during the processing.
#' @param var variable from the microdataset to manipulate.
#' @param var.name character, variable name to manipulate in input.
#' @param to character, variable name to return.
#' @author ILO / bescond  
#' @keywords ILO, microdataset, preprocessing
#' @examples
#' ## Not run:
#'
#' ## End(**Not run**)
#' @export
#' @rdname Micro_process
Micro_cat_label <- function(var, var.name, add.total = FALSE){

	if(stringr::str_sub(var.name,-7,-1) %in% '2digits'){
		fwk <-  ilo_tpl$Variable %>% filter(var_name %in%  var.name)	%>% 
					select(code_level, code_label) %>% mutate(code_level = as.numeric(code_level)) %>% 
					right_join(data_frame(code_level = min(.$code_level):max(.$code_level)), by = 'code_level') %>% 
					mutate(code_label = ifelse(code_label %in% NA, paste0(code_level, 'NA'), code_label)) %>%
					mutate_if(is.character, funs(factor(., exclude = NULL)))
		code <- fwk$code_level %>% as.numeric
		label <- fwk$code_label 
		rm(fwk)			
	} else{
		code <- ilo_tpl$Variable %>% filter(var_name %in%  var.name) %>% 
						.$code_level %>% 
						as.numeric%>% {if (add.total) c(0,.) else . }

		label <- ilo_tpl$Variable %>% filter(var_name %in%  var.name) %>% 
						.$code_label %>% {if (add.total) c('Total',.) else . }

	}				
	unclass(var) %>% factor(levels = code, labels = label)   
}

#' @export
#' @rdname Micro_process
Micro_cat_recode <- function(var, var.name, to){
	
	var.name <- gsub('job1_','',var.name);	var.name <- gsub('job2_','',var.name);	var.name <- gsub('joball_','',var.name);	var.name <- gsub('ilo_prev','ilo_',var.name)
	to <- gsub('job1_','',to);	to <- gsub('job2_','',to);	to <- gsub('joball_','',to);	to <- gsub('ilo_prev','ilo_',to)

	fwk <- ilo_tpl$Help_classif %>% filter(var_name %in% var.name)


	if(nrow(fwk) ==0 ){return(print(paste0('mapping with ',var.name, ' not found !')))}

	fwk <- fwk %>% filter(var_name_level2 %in% to)
	if(nrow(fwk) ==0 ){return(print(paste0('mapping between ',var.name, ' and ', to, ' not found !')))}

	fwk2 <- fwk %>% distinct(code_level_level2, code_label_level2)

	eval(parse(text = paste0('unclass(var) %>% recode_factor(',
		data_frame_(list(a  = ~fwk$code_level, b = ~fwk$code_level_level2)) %>% mutate(ref = paste0('`', a, '` = ','"', b, '"')) %>% select(ref) %>% t %>% as.character %>% paste0(collapse = ',')
		,') %>% recode(',
		data_frame_(list(a  = ~fwk2$code_level_level2, b = ~fwk2$code_label_level2)) %>% mutate(ref = paste0('`', a, '` = ', '"', b, '"')) %>% select(ref) %>% t %>% as.character %>% paste0(collapse = ',')
		,')')))


}
