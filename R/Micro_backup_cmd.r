#' backup do for Master files
#'
#' not longer used 
#'
#'
#' @author ILO / bescond  
#' @keywords ILO, microdataset, preprocessing
#' @examples
#' ## Not run:
#'
#' ## End(**Not run**)
#' @export
#' @rdname Micro_process
Micro_backup_cmd <- function(){


master <- Micro_get_workflow() %>% 
				filter(str_detect(type, 'Master')) %>% 
				select(country, source, time) %>% 
				mutate(init = paste0(ilo:::path$micro, country, '/', source, '/', time, '/', country, '_', source, '_', time, '_ILO_CMD.do'), 
					   backup = paste0(ilo:::path$micro, '_Admin/CMD/iloMicro/inst/doc/', country, '_', source, '_', time, '_ILO_CMD.do'))
				
				

	for (i in 1:nrow(master)){
		try(file.copy(from = master$init[i], to = master$backup[i],copy.mode = TRUE, copy.date = TRUE), silent = TRUE)
	}



}
