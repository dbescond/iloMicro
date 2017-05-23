#' helper to check dta columns and value present over times series
#'
#' Support for recoding variable, check \code{?car::Recode}, for labelling variable 
#'
#' @param country character for selection of country (iso3 code), mandatory if path is not set.
#' @param source character for selection of source (as ilo micro spelling, ie. LFS), mandatory if path is not set.
#' @param time , character, time, use for a specific dataset, default NULL, mandatory if path is not set.
#' @param validate , use only ready files, default TRUE
#' @keywords ILO, microdataset, processing
#' @examples
#' ## Not run:
#'
#'
#'	X <- Micro_check_dta_series(country = 'ECU', source = 'LFS')
#'
#' ## End(**Not run**)
#' @export

Micro_check_dta_series <- function(		# path = NULL, 
								country =  NULL,
								source = NULL, 
								time = NULL, 
								validate = TRUE 
									){

								
							
	init_wd <- getwd()
	setwd(ilo:::path$micro)
	workflow <- Micro_get_workflow() 
	if(validate) {workflow <- workflow %>% filter(processing_status %in% 'Yes', !str_detect(time, 'Sample'), CC_ilostat %in% 'Yes', !freq_code %in% NA) }
	if(!is.null(country)){refcountry <- country; workflow <- workflow %>% filter(country %in% refcountry); rm(refcountry) }
	if(!is.null(source)){refsource <- source; workflow <- workflow %>% filter(source %in% refsource); rm(refsource) }
	if(!is.null(time)){reftime <- time; workflow <- workflow %>% filter(time %in% reftime); rm(reftime) }
	
	my_res <- NULL


	for (i in 1:nrow(workflow)){
		########## process
		X <- Micro_load(path = workflow$file[i], asFactor = TRUE) %>% mutate_if(is.labelled, funs(as_factor(., "both")))
		ref <- colnames(X) %>% as_data_frame %>% 
					filter(	!value %in% c('ilo_key','ilo_wgt','ilo_time'), 
							!str_detect(value, '2digits'), 
							!str_detect(value, '_lri_'), 
							!str_sub(value, -6,-1) %in% c('_usual', 'actual') )
		
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

	my_res				
}


#' @export
#' @rdname Micro_check_dta_series
Micro_check_dta_series_view <- function(
								df){
								
								

require(ilo)
require(seasonal)
require(xts)
require(shiny)
require(dygraphs)


X <- df %>% 
			filter(!label %in% 'NaN') %>% 
			filter(!as.numeric(str_sub(label, 1,1)) %in% 0:9) %>% 
			mutate(	Stime = as.Date(as.yearqtr(ilo_time)), 
					label = ifelse(str_sub(label, 1,1) %in% '[', str_sub(label, 5, -1), label), 
					label = str_replace_all(label, ' ', '')) 







ts_model <- list()
ref <- unique(df$var)

 
 for (i in 1:length(ref)){
	
	check <- df %>% filter(var %in% ref[i])
	ref_label <- unique(check$label)
	ts_group <- list()
		j <- 1
		new_check <- check %>% filter(label %in% ref_label[j]) %>% select(Stime, check)
		ref_quarter <- seq.Date(min(check$Stime),max(check$Stime),"quarter") %>% as_data_frame %>% rename(Stime  = value)
		new_check <- new_check  %>% full_join(ref_quarter, by = 'Stime') %>% arrange(Stime)  
		pass <- xts(new_check$check, new_check$Stime) %>% ts(., start= min(as.numeric(str_sub(new_check$Stime,1,4))), freq = 4)
		ts_group <- data.frame(Stime=index(pass), coredata(pass))
		colnames(ts_group)[j + 1] <- ref_label[j]
	for (j in 2:length(ref_label)){
		new_check <- check %>% filter(label %in% ref_label[j]) %>% select(Stime, check)
		ref_quarter <- seq.Date(min(check$Stime),max(check$Stime),"quarter") %>% as_data_frame %>% rename(Stime  = value)
		new_check <- new_check  %>% full_join(ref_quarter, by = 'Stime') %>% arrange(Stime)  
		pass <- xts(new_check$check, new_check$Stime) %>% ts(., start= min(as.numeric(str_sub(new_check$Stime,1,4))), freq = 4)
		ts_group <- cbind(ts_group, coredata(pass))
		colnames(ts_group)[j + 1] <- ref_label[j]
	}

ts_model[[ref[i]]] <- ts_group

}





ui <- fluidPage(
		titlePanel(title=h4("var", align="center")),
		sidebarPanel( 
			sliderInput("num", "id:",min = 1, max = length(ref), value=1, step = 1)),
mainPanel(dygraphOutput("plot2"))
)

  
  
server <- function(input,output){
  
  output$plot2<-renderDygraph({

	dygraph(ts_model[[input$num]], main = names(ts_model[input$num]), xlab = NULL, ylab = NULL, periodicity = 'quarterly') %>%
	dyOptions(colors = RColorBrewer::brewer.pal( max(ncol(ts_model[[i]]) - 1, 3), "Set2"))%>%
  dyLegend(width = 800)

   })
}
	
	
	
shinyApp(ui, server)

			
								
								
								
								
								
								
								
								
								
								}