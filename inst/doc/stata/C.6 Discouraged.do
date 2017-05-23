capture label drop _all
capture log close
capture clear all
set more off
set mem 500m

/*This do-file calculates the indicators:
A) Discouraged job-seekers by sex and age:
	A.1. AGE_10YRBANDS
	A.2. AGE_AGGREGATE
	A.3. AGE_5YRBANDS
*/

*Start: Open the dataset that is defined in the first do-file along with the the country name, year and source
use "$DATASET", clear

cd "$LIBMPOUT" //this changes the directory for this do-file to always be what it defines. The advantage is simply to avoid writing the directory when we save a dataset
*End


********************************************************************************************
*** A) Discouraged job-seekers by sex and age **********************************************
capture confirm variable ilo_sex //Check if the variable ilo_sex exists
if !_rc {
	//For this indicator, all the sub-indicators have this indicator_code in the final template.
	global indicator = "EIP_WDIS_SEX_AGE_NB"
	
	*** A.1) Discouraged job-seekers by sex and age: AGE_10YRBANDS ***
	global LEVEL1        = "ilo_age_10yrbands"
	global classif1TOTAL = "AGE_10YRBANDS_TOTAL"
	do "$LIBMPDO\C.6.1 DRY.do"

	*** A.2) Discouraged job-seekers by sex and age: AGE_AGGREGATE ***
	global LEVEL1        = "ilo_age_aggregate"
	global classif1TOTAL = "AGE_AGGREGATE_TOTAL"
	do "$LIBMPDO\C.6.1 DRY.do"

	*** A.3) Discouraged job-seekers by sex and age: AGE_5YRBANDS ***
	global LEVEL1        = "ilo_age_5yrbands"
	global classif1TOTAL = "AGE_5YRBANDS_TOTAL"
	do "$LIBMPDO\C.6.1 DRY.do"
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "Variable ilo_sex doesn't exist."
	log close
}
********************************************************************************************
