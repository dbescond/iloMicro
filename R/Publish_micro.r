#' helper to calculate ilo indicator (volume and ratio) for one time period only
#'
#' faster method to recode, order, add label of categorical variables
#'
#'
#' @param path dta or zip file path for loading ilo microdataset pre precessed, default = NULL.
#' @param myref_area character for selection of country (iso3 code), mandatory if path is not set.
#' @param mysource character for selection of source (as ilo micro spelling, ie. LFS), mandatory if path is not set.
#' @param mytime , character, time, use for a specific dataset, default NULL, mandatory if path is not set.
#' @author ILO / bescond
#' @keywords ILO, microdataset, processing
#' @examples
#' ## Not run:

#'	# you could now rebuild, process 1 for a single time, then process 23
#'	# use mainly for adding oe dataset to a series yet publish
#'
#'	Publish_micro("CAN", "LFS", "2020M11")
#'
#'
#'
#'

#' ## End(**Not run**)

#' @export


Publish_micro <- function(
					myref_area, 
					mysource, 
					mytime
){

 Micro_rebuild_series(ref_area = myref_area, source = mysource, time = mytime, add_master = TRUE)

 Micro_process(validate = TRUE, consolidate = '1', time = mytime, PUB = TRUE, ref_area =myref_area, source = mysource)
 Micro_process(validate = TRUE, consolidate = '2',  PUB = TRUE, ref_area =myref_area, source = mysource)
 Micro_process(validate = TRUE, consolidate = '3',  PUB = TRUE, ref_area =myref_area, source = mysource)

}
