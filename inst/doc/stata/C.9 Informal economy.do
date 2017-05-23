capture label drop _all
capture log close
capture clear all
set more off
set mem 500m

/*This do-file calculates the indicators:
A) Workers in the informal economy by economic activity: ECO_AGGREGATE

?) Workers in the informal economy by sex and status in employment
*/

*Start: Open the dataset that is defined in the first do-file along with the the country name, year and source
use "$DATASET", clear

cd "$LIBMPOUT" //this changes the directory for this do-file to always be what it defines. The advantage is simply to avoid writing the directory when we save a dataset
*End


********************************************************************************************
*** A) Workers in the informal economy by economic activity: ECO_AGGREGATE_TOTAL ***********
capture confirm variable ilo_sex //Check if the variable ilo_sex exists
if !_rc {
	global indicator = "IFL_IECN_SEX_ECO_NB"
	global LEVEL1        = "ilo_job1_eco_aggregate"
	global classif1TOTAL = "ECO_AGGREGATE_TOTAL"
	do "$LIBMPDO\C.9.1 DRY.do"
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "Variable ilo_sex doesn't exist."
	log close
}
********************************************************************************************

/*
********************************************************************************************
*** ?) Workers in the informal economy by sex and status in employment *********************
capture confirm variable ilo_sex //Check if the variable ilo_sex exists
if !_rc {
	global indicator = "IFL_IECN_SEX_STE_NB"
	global LEVEL1        = "ilo_job1_ste_aggregate"
	global classif1TOTAL = "STE_AGGREGATE_TOTAL"
	do "$LIBMPDO\C.9.1 DRY.do"
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "Variable ilo_sex doesn't exist."
	log close
}
********************************************************************************************
*/
