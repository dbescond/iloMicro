#' @title Tools kit for ilo microdata processing of household sample survey
#'
#' @description description of the project here
#'
#' @details brief description of the package
#' Targets:
#'
#' \itemize{
#' \item process lfs microdatafile
#' \item prepare summary table for current file available
#' \item helper to convert sav to dta and viseversa
#' }
#'
#' @examples
#' ## Not run:
#'
#' # Main functions : 
#'
#' # rebuild entire time series, or add time = "2020" for specific time:
#'
#' Micro_rebuild_series(ref_area = 'PHL', source = 'LFS', add_master = FALSE) 
#'
#' # test scope and mapping for entire time series (that does no process, just test):
#'
#' Micro_process(validate = TRUE, consolidate = '1'  , PUB = TRUE, ref_area ='AFG', source = 'LCS', TEST_SCOPE = TRUE)
#'
#' # process entire time series, or add time = '2020' AND consolidate = '1', for specific time 
#' Micro_process(validate = TRUE, consolidate = '1'  , PUB = TRUE, ref_area ='AFG', source = 'LCS', time = '2017')
#' Micro_process(validate = TRUE, consolidate = '23', PUB = TRUE, ref_area ='AFG', source = 'LCS')
#'
#'
#'	
#' # rebuild, process consolidate by adding only one dataset:
#'	Publish_micro("CAN", "LFS", "1980M11")
#'
#'  # run all in parallel
#'
#'	# get command:
#'	cmd <- Micro_check_dta_series(CMD = TRUE) 	# or :
#'	cmd <- Micro_rebuild_series(CMD = TRUE) 	# or :
#'	cmd <- Micro_process(CMD = TRUE)
#'  run_parallel_ilo(cmd)

#' ## End(**Not run**)

#'
#' @name iloMicro
#' @author David Bescond \email{bescond@ilo.org}
#' @references
#' See citation("iloMicro")
#'
#' @keywords package
#' @importFrom readr read_csv
#' @importFrom readr col_character
#' @importFrom readr col_double
#' @importFrom readr cols
#' @importFrom plyr llply
#' @importFrom plyr mapvalues
#' @importFrom dplyr %>%
#' @importFrom dplyr select
#' @importFrom dplyr rename
#' @importFrom dplyr count
#' @importFrom dplyr n
#' @importFrom dplyr filter
#' @importFrom dplyr as_tibble
#' @importFrom dplyr tibble
#' @importFrom dplyr slice
#' @importFrom dplyr contains
#' @importFrom textreadr read_document
#' @importFrom dplyr lag
#' @importFrom dplyr distinct
#' @importFrom dplyr bind_rows
#' @importFrom dplyr left_join
#' @importFrom dplyr right_join
#' @importFrom dplyr mutate
#' @importFrom dplyr mutate_if
#' @importFrom dplyr mutate_all
#' @importFrom dplyr mutate_at
#' @importFrom dplyr vars
#' @importFrom dplyr summarise
#' @importFrom dplyr summarize
#' @importFrom dplyr desc
#' @importFrom dplyr id
#' @importFrom dplyr failwith
#' @importFrom dplyr summarise
#' @importFrom dplyr group_by
#' @importFrom dplyr group_by_at
#' @importFrom dplyr arrange
#' @importFrom dplyr funs
#' @importFrom dplyr ungroup
#' @importFrom dplyr intersect
#' @importFrom dplyr setdiff
#' @importFrom dplyr union
#' @importFrom dplyr setequal
#' @importFrom tidyr separate
#' @importFrom tidyr unite
#' @importFrom haven read_dta
#' @importFrom haven read_sav
#' @importFrom haven read_sas
#' @importFrom haven write_dta
#' @importFrom haven write_sav
#' @importFrom haven write_sas
#' @importFrom haven zap_labels
#' @importFrom stringr str_replace_all
#' @importFrom stringr str_replace
#' @importFrom stringr str_c
#' @importFrom stringr str_sub
#' @importFrom stringr str_detect
#' @importFrom stringr str_split
#' @importFrom stringr str_trim
#' @importFrom stringr fixed
#' @importFrom tibble is_tibble
#' @importFrom tibble as_tibble
#' @importFrom tibble enframe
#' @importFrom readxl read_excel
#' @importFrom utils download.file
#' @importFrom utils install.packages
#' @importFrom utils installed.packages
#' @importFrom utils menu
#' @importFrom xml2 read_xml
#' @importFrom xml2 xml_find_all
#' @importFrom xml2 xml_attrs
#' @importFrom xml2 xml_attr
#' @importFrom xml2 xml_text
#' @importFrom xml2 xml_ns
#' @importFrom RCurl ftpUpload
#' @importFrom data.table fwrite
#' @importFrom DT datatable

NULL

MY_PATH <- NULL
MY_PATH$micro <-  "J:/DPAU/MICRO/"
MY_PATH$query <-  "J:/DPAU/QUERY/"


