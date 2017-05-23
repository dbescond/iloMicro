capture label drop _all
capture log close
capture clear all
set more off
set mem 500m

/*This do-file calculates the indicators:
A) Persons outside the labour force by sex and degree of labour market attachment: EIP_LMATT

B) Persons outside the labour force by sex, age and degree of labour market attachment: AGE_AGGREGATE, EIP_LMATT

C) Persons outside the labour force by sex, age and rural / urban areas
	C.1. AGE_AGGREGATE, GEO_COV
	C.2. AGE_10YRBANDS, GEO_COV

D) Persons outside the labour force by sex and age:
	D.1. AGE_AGGREGATE
	D.2. AGE_10YRBANDS
	D.3. AGE_5YRBANDS
//NOTE: Table D is only calculated in order to be used for the indicator "EIP_DWAP_SEX_AGE_RT".
*/

*Start: Open the dataset that is defined in the first do-file along with the the country name, year and source
use "$DATASET", clear

cd "$LIBMPOUT" //this changes the directory for this do-file to always be what it defines. The advantage is simply to avoid writing the directory when we save a dataset
*End


*************************************************************************************************
*** Persons outside the labour force by sex and degree of labour market attachment: EIP_LMATT ***
capture confirm variable ilo_sex //Check if the variable ilo_sex exists
if !_rc {
	global indicator = "EIP_TEIP_SEX_EIP_NB"
	global LEVEL1        = "ilo_olf_dlma"
	global classif1TOTAL = "OLF_DLMA_TOTAL"
	do "$LIBMPDO\C.5.1 DRY.do"
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "Variable ilo_sex doesn't exist."
	log close
}
*************************************************************************************************


************************************************************************************************************************
*** B) Persons outside the labour force by sex, age and degree of labour market attachment: AGE_AGGREGATE, EIP_LMATT ***
capture confirm variable ilo_sex //Check if the variable ilo_sex exists
if !_rc {
	global indicator = "EIP_TEIP_SEX_AGE_EIP_NB"
	global LEVEL1        = "ilo_age_aggregate"
	global classif1TOTAL = "AGE_AGGREGATE_TOTAL"
	global LEVEL2        = "ilo_olf_dlma"
	global classif2TOTAL = "OLF_DLMA_TOTAL"
	do "$LIBMPDO\C.5.2 DRY.do"
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "Variable ilo_sex doesn't exist."
	log close
}
************************************************************************************************************************


************************************************************************************************************************
*** C) Persons outside the labour force by sex, age and rural / urban areas: AGE_AGGREGATE, GEO_COV ********************
capture confirm variable ilo_sex //Check if the variable ilo_sex exists
if !_rc {
	//For this indicator, all the sub-indicators have this indicator_code in the final template.
	global indicator = "EIP_TEIP_SEX_AGE_GEO_NB"

	*** C.1) Persons outside the labour force by sex, age and rural / urban areas: AGE_10YRBANDS ***
	global LEVEL1        = "ilo_age_10yrbands"
	global classif1TOTAL = "AGE_10YRBANDS_TOTAL"
	global LEVEL2        = "ilo_geo"
	global classif2TOTAL = "GEO_COV_NAT"
	do "$LIBMPDO\C.5.2 DRY.do"
	
	*** C.2) Persons outside the labour force by sex, age and rural / urban areas: AGE_AGGREGATE ***
	global LEVEL1        = "ilo_age_aggregate"
	global classif1TOTAL = "AGE_AGGREGATE_TOTAL"
	global LEVEL2        = "ilo_geo"
	global classif2TOTAL = "GEO_COV_NAT"
	do "$LIBMPDO\C.5.2 DRY.do"
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "Variable ilo_sex doesn't exist."
	log close
}
************************************************************************************************************************


********************************************************************************************
*** D) Persons outside the labour force by sex and age *************************************
//NOTE: Table D is only calculated in order to be used for the indicator "EIP_DWAP_SEX_AGE_RT".
capture confirm variable ilo_sex //Check if the variable ilo_sex exists
if !_rc {
	//For this indicator, all the sub-indicators have this indicator_code in the final template.
	global indicator = "EIP_TEIP_SEX_AGE_NB"
	
	*** D.1) Persons outside the labour force by sex and age: AGE_AGGREGATE ***
	global LEVEL1        = "ilo_age_aggregate"
	global classif1TOTAL = "AGE_AGGREGATE_TOTAL"
	do "$LIBMPDO\C.5.1 DRY.do"

	*** D.2) Persons outside the labour force by sex and age: AGE_10YRBANDS ***
	global LEVEL1        = "ilo_age_10yrbands"
	global classif1TOTAL = "AGE_10YRBANDS_TOTAL"
	do "$LIBMPDO\C.5.1 DRY.do"

	*** D.3) Persons outside the labour force by sex and age: AGE_5YRBANDS ***
	global LEVEL1        = "ilo_age_5yrbands"
	global classif1TOTAL = "AGE_5YRBANDS_TOTAL"
	do "$LIBMPDO\C.5.1 DRY.do"
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "Variable ilo_sex doesn't exist."
	log close
}
********************************************************************************************
