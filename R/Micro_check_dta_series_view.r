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
#'
#'	Micro_check_dta_series_view(ref_area = 'ALB', source = 'LFS')
#'
#' ## End(**Not run**)
#' @export

Micro_check_dta_series_view <- function(ref_area, source){
								
load(paste0(ilo:::path$data, 'REP_ILO/MICRO/input/TEST_DTA/', ref_area, '_', source, '.Rdata'))							

require(shiny)
require(dygraphs)

ui <- fluidPage(
		titlePanel(title=h4("var", align="center")),
		actionButton("Buttonlast", "last"), 
		actionButton("Buttonnext", "next"),
		mainPanel(dygraphOutput("plot2"))

)

  

server <- function(input,output){
  
  count <- reactiveValues(value = 1)
  count_min <- 1
  count_max <- length(ts_model)
  
  
  observeEvent(input$Buttonnext, {

	count$value <- count$value + 1
	if(count$value > count_max) count$value <- 1
  })
  
   observeEvent(input$Buttonlast, {

	count$value <- count$value - 1
	if(count$value < count_min) count$value <- count_max
  }) 
  
  output$plot2<-renderDygraph({

	period <- ifelse(stringr::str_sub(names(ts_model[count$value]), -1,-1) %in% 'A', 
							'yearly', 
							ifelse(stringr::str_sub(names(ts_model[count$value]), -1,-1) %in% 'Q', 
							'quarterly', 
							'monthly'))
	dygraph(ts_model[[count$value]], main = names(ts_model[count$value])) %>%
	dyOptions(	colors = RColorBrewer::brewer.pal( max(ncol(ts_model[count$value]) - 1, 3), "Set2"), 
				drawGrid = FALSE)%>%
		dyAxis('x', pixelsPerLabel = 100) %>%
  dyLegend(width = 800)  %>% dyRangeSelector() 

   })
}
	
	
	
shinyApp(ui, server)

			
								
								
}













