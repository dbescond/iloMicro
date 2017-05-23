capture label drop _all
capture log close
capture clear all
set more off
set mem 500m

/*This do-file calculates the indicators:
A) Time-related underemployment by sex and age:
	A.1. AGE_10YRBANDS
	A.2. AGE_AGGREGATE

B) Time-related underemployment by sex and economic activity: ECO_AGGREGATE
*/

*Start: Open the dataset that is defined in the first do-file along with the the country name, year and source
use "$DATASET", clear

cd "$LIBMPOUT" //this changes the directory for this do-file to always be what it defines. The advantage is simply to avoid writing the directory when we save a dataset
*End


********************************************************************************************
*** A) Time-related underemployment by sex and age *****************************************
capture confirm variable ilo_sex //Check if the variable ilo_sex exists
if !_rc {
	//For this indicator, all the sub-indicators have this indicator_code in the final template.
	global indicator = "TRU_TTRU_SEX_AGE_NB"
	
	*** A.1) Time-related underemployment by sex and age: AGE_10YRBANDS ***
	global LEVEL1        = "ilo_age_10yrbands"
	global classif1TOTAL = "AGE_10YRBANDS_TOTAL"
	do "$LIBMPDO\C.8.1 DRY.do"

	*** A.2) Time-related underemployment by sex and age: AGE_AGGREGATE ***
	global LEVEL1        = "ilo_age_aggregate"
	global classif1TOTAL = "AGE_AGGREGATE_TOTAL"
	do "$LIBMPDO\C.8.1 DRY.do"
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "Variable ilo_sex doesn't exist."
	log close
}
********************************************************************************************


********************************************************************************************
*** B) Time-related underemployment by sex and economic activity: ECO_AGGREGATE ************
capture confirm variable ilo_sex //Check if the variable ilo_sex exists
if !_rc {
	global indicator = "TRU_TTRU_SEX_ECO_NB"
	global LEVEL1        = "ilo_job1_eco_aggregate"
	global classif1TOTAL = "ECO_AGGREGATE_TOTAL"
	do "$LIBMPDO\C.8.1 DRY.do"
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "Variable ilo_sex doesn't exist."
	log close
}
********************************************************************************************
