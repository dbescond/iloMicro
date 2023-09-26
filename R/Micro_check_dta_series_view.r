#' helper to check dta columns and value present over times series
#'
#' Support for recoding variable, check \code{?car::Recode}, for labelling variable 
#'
#' @param ref_area character for selection of country (iso3 code), mandatory if path is not set.
#' @param source character for selection of source (as ilo micro spelling, ie. LFS), mandatory if path is not set.
#' @keywords ILO, microdataset, processing
#' @examples
#' ## Not run:
#'
#'  be sure having yet run:
#'
#'  Micro_check_dta_series(ref_area = 'IND', source = 'PLFS')
#'
#'  then run : 
#'
#'	Micro_check_dta_series_view(ref_area = 'IND', source = 'PLFS', freq = 'M')
#'
#' ## End(**Not run**)
#' @export

Micro_check_dta_series_view <- function(ref_area, source, freq = 'A'){
								
								
# ref_area =  'IND';  source = 'PLFS' ;freq = 'A'
								


require(shiny)
require(dygraphs)
init_ilo()


ui <- fluidPage(
		fluidRow(
		column(1,
				HTML("")
		
				),
			column(8,
			uiOutput(outputId = 'My_title')),
			column(1,
						HTML("")
		
				)
		),
		
		fluidRow(
			column(1,
				HTML("")
		
				),
			column(8,
				dygraphOutput("plot2")
			), 
			column(2,
					
					
					actionButton("Buttonlast", "last"), 
					actionButton("Buttonnext", "next")
			),
			column(1,
						HTML("")
		
				)
		)
		
		

)

  

server <- function(input,output){
  
  load(paste0(MY_PATH$micro, '_Admin/CMD/input/', ref_area, '_', source, "_", freq, '.Rdata'))	

  count <- reactiveValues(value = 1)
  count_min <- 1
  count_max <- length(ts_model)
  period <- ifelse(freq %in% 'A', 
							'Yearly', 
							ifelse(freq %in% 'Q', 
							'Quarterly', 
							'Monthly'))  
  output$My_title <- 	renderUI({
  
			h1(	paste0(	ref_area %>% as_tibble_col(column_name = "ref_area") %>% switch_ilo(ref_area) %>% .$ref_area.label, ' - ', 
						source, " - ", 
						ifelse(freq %in% 'A', 
							'Yearly', 
							ifelse(freq %in% 'Q', 
							'Quarterly', 
							'Monthly')) ))
  })
  
  
  
  
  observeEvent(input$Buttonnext, {

	count$value <- count$value + 1
	if(count$value > count_max) count$value <- 1
  })
  
   observeEvent(input$Buttonlast, {

	count$value <- count$value - 1
	if(count$value < count_min) count$value <- count_max
  }) 
  
  output$plot2<-renderDygraph({
		
							
	dygraph(ts_model[[count$value]], main = paste0(str_sub(names(ts_model[count$value]),1, -3)) ) %>%
	dyOptions(	colors = RColorBrewer::brewer.pal( max(ncol(ts_model[count$value]) - 1, 3), "Set2"), 
				drawGrid = FALSE, 
				drawXAxis = TRUE)%>%
		dyAxis('x', pixelsPerLabel = 100) %>%
	
	dyLegend(width = 800)  %>% dyRangeSelector() 

   })
}
	
	
	
shinyApp(ui, server)

			
								
								
}













