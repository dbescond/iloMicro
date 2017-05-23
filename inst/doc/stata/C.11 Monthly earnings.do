capture label drop _all
capture log close
capture clear all
set more off
set mem 500m

/*This do-file calculates the indicators:
A) Mean nominal monthly earnings of employees by sex and economic activity:
	A.1. ECO_ISIC4
	A.2. ECO_ISIC3
	A.3. ECO_AGGREGATE

B) Mean nominal monthly earnings of employees by sex and occupation:
	B.1. OCU_ISCO08
	B.2. OCU_ISCO88
	B.3. OCU_AGGREGATE
*/

*Start: Open the dataset that is defined in the first do-file along with the the country name, year and source
use "$DATASET", clear

cd "$LIBMPOUT" //this changes the directory for this do-file to always be what it defines. The advantage is simply to avoid writing the directory when we save a dataset
*End


********************************************************************************************
*** A) Mean nominal monthly earnings of employees by sex and economic activity *************
capture confirm variable ilo_sex //Check if the variable ilo_sex exists
if !_rc {
	//All the sub-indicators have this indicator_code and use this working-hours' type in the final template.
	global indicator = "EAR_XEES_SEX_ECO_NB"
	
	*** A.1) Mean nominal monthly earnings of employees by sex and economic activity: ECO_ISIC4 ***
	global LEVEL1        = "ilo_job1_eco_isic4"
	global classif1TOTAL = "ECO_ISIC4_TOTAL"
	do "$LIBMPDO\C.11.1 DRY.do"
	
	*** A.2) Mean nominal monthly earnings of employees by sex and economic activity: ECO_ISIC3 ***
	global LEVEL1        = "ilo_job1_eco_isic3"
	global classif1TOTAL = "ECO_ISIC3_TOTAL"
	do "$LIBMPDO\C.11.1 DRY.do"

	*** A.3) Mean nominal monthly earnings of employees by sex and economic activity: ECO_AGGREGATE ***
	global LEVEL1        = "ilo_job1_eco_aggregate"
	global classif1TOTAL = "ECO_AGGREGATE_TOTAL"
	do "$LIBMPDO\C.11.1 DRY.do"
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "Variable ilo_sex doesn't exist."
	log close
}
********************************************************************************************


********************************************************************************************
*** B) Mean nominal monthly earnings of employees by sex and occupation ********************
capture confirm variable ilo_sex //Check if the variable ilo_sex exists
if !_rc {
	//All the sub-indicators have this indicator_code and use this working-hours' type in the final template.
	global indicator = "EAR_XEES_SEX_OCU_NB"
	
	*** B.1) Mean nominal monthly earnings of employees by sex and occupation: OCU_ISCO08 ***
	global LEVEL1        = "ilo_job1_ocu_isco08"
	global classif1TOTAL = "OCU_ISCO08_TOTAL"
	do "$LIBMPDO\C.11.1 DRY.do"
	
	*** B.2) Mean nominal monthly earnings of employees by sex and occupation: OCU_ISCO88 ***
	global LEVEL1        = "ilo_job1_ocu_isco88"
	global classif1TOTAL = "OCU_ISCO88_TOTAL"
	do "$LIBMPDO\C.11.1 DRY.do"

	*** B.3) Mean nominal monthly earnings of employees by sex and occupation: OCU_AGGREGATE ***
	global LEVEL1        = "ilo_job1_ocu_aggregate"
	global classif1TOTAL = "OCU_AGGREGATE_TOTAL"
	do "$LIBMPDO\C.11.1 DRY.do"
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "Variable ilo_sex doesn't exist."
	log close
}
********************************************************************************************
