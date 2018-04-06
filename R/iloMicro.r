#' @title Tools kit for ilo microdata processing of household / labour force survey
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
#' @importFrom plyr ldply
#' @importFrom plyr mapvalues
#' @importFrom dplyr %>%
#' @importFrom dplyr select_
#' @importFrom dplyr select
#' @importFrom dplyr rename
#' @importFrom dplyr rename_
#' @importFrom dplyr count
#' @importFrom dplyr filter_
#' @importFrom dplyr filter
#' @importFrom dplyr as.tbl
#' @importFrom dplyr slice
#' @importFrom dplyr contains
#' @importFrom textreadr read_document
#' @importFrom dplyr lag
#' @importFrom dplyr distinct
#' @importFrom dplyr distinct_
#' @importFrom dplyr bind_rows
#' @importFrom dplyr left_join
#' @importFrom dplyr right_join
#' @importFrom dplyr mutate
#' @importFrom dplyr mutate_
#' @importFrom dplyr mutate_if
#' @importFrom dplyr mutate_all
#' @importFrom dplyr mutate_at
#' @importFrom dplyr vars
#' @importFrom dplyr summarise
#' @importFrom dplyr summarize
#' @importFrom dplyr summarize_
#' @importFrom dplyr desc
#' @importFrom dplyr id
#' @importFrom dplyr failwith
#' @importFrom dplyr summarise_
#' @importFrom dplyr group_by_
#' @importFrom dplyr group_by
#' @importFrom dplyr arrange
#' @importFrom dplyr arrange_
#' @importFrom dplyr funs
#' @importFrom dplyr ungroup
#' @importFrom dplyr intersect
#' @importFrom dplyr setdiff
#' @importFrom dplyr union
#' @importFrom dplyr setequal
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
#' @importFrom stringr fixed
#' @importFrom tibble data_frame
#' @importFrom tibble is_tibble
#' @importFrom tibble as_data_frame
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
#' @name iloMicro

NULL