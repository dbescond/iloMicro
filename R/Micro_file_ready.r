#' helper to prepare summary file on root repo
#'
#'
#' @author ILO / bescond  
#' @keywords ILO, microdataset, processing
#' @examples
#' ## Not run:
#' Micro_file_ready()
#'
#' ## End(**Not run**)
#' @export
Micro_file_ready <- function(){

workflow <- Micro_get_workflow()
init <- getwd()
setwd(ilo:::path$micro)
require(openxlsx)

read <- workflow %>% select(country, source, source_title, time, path, processing_status, origine_repo, origine_website, origine_date, comments)
class(read$country) <- "hyperlink"
class(read$path) <- "hyperlink"
 

res <- read %>% 
			group_by(country, source, source_title) %>% 
			mutate(last_year = max(unique(str_sub(time,1,4)))) %>% 
			ungroup %>%
			count(country, source, source_title, processing_status, origine_repo, last_year) %>% 
			ungroup %>% 
			spread(processing_status, n) 

			res$Total <- rowSums(res[, 6:8], na.rm = TRUE)  
			res$Processed <- rowSums(res[, 7:8], na.rm = TRUE)  
			
res <- res %>% 
			mutate(	Processed = ifelse(Processed %in% 0, NA, Processed), 
					Not_process = No ) %>% 
			select(	country, 	
					source,	
					source_title,	
					origine_repo,	
					last_year,	
					Total, 
					Not_process, 
					Processed, 					
					Published)
					
					
class(res$country) <- "hyperlink"

require(ilo)
init_ilo(-cl)

read <- read %>% 
			switch_ilo(country, keep) %>% 
			mutate(	origine_date = as.character(origine_date), 
					comments = ifelse(processing_status %in% c('Published', 'Yes'), comments, NA))%>% 
			as.data.frame
			
res <- res %>% 	switch_ilo(country, keep) %>% 
				mutate(last_year = as.numeric(last_year),
						Not_process = as.numeric(Not_process), 
						Processed = as.numeric(Processed), 
						Published = as.numeric(Published), 
						Total = as.numeric(Total) )


new <- data_frame(	country = nrow(res %>% count(country)) %>% as.character, 
					source = nrow(res) %>% as.character, 
					Not_process = sum(res$Not_process, na.rm = TRUE),  
					Processed = sum(res$Processed, na.rm = TRUE),  
					Published = sum(res$Published, na.rm = TRUE),  
					Total = sum(res$Total, na.rm = TRUE)) 
res <- bind_rows(res, new) %>% mutate(last_year = as.numeric(last_year))

wb <- createWorkbook()
options("openxlsx.borderStyle" = "thin")
options("openxlsx.borderColour" = "#4F81BD")
## Add worksheets
addWorksheet(wb, "workflow")
addWorksheet(wb, "summary")
addFilter(wb, 1, row = 1, cols = 1:ncol(read))
writeData(wb, "workflow", read)
addFilter(wb, 2, row = 1, cols = 1:ncol(res))
writeData(wb, "summary", res)


## Save workbook to working directory
saveWorkbook(wb, file = "_FileReady.xlsx", overwrite = TRUE)
rm(read, wb)

Micro_backup_cmd()


invisible(gc(reset = TRUE))
setwd(init)
}

