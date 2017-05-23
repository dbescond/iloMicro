capture label drop _all
capture log close
capture clear all
set more off
set mem 500m

/*This do-file calculates the indicators:
A) Unemployment by sex and age:
	A.1. AGE_AGGREGATE
	A.2. AGE_10YRBANDS
	A.3. AGE_5YRBANDS

B) Unemployment by sex and disability status: DSB_STATUS_AGGREGATE

C) Unemployment by sex, age and education:
	C.1.1. AGE_10YRBANDS, EDU_ISCED11
	C.1.2. AGE_10YRBANDS, EDU_ISCED97
	C.1.3. AGE_10YRBANDS, EDU_AGGREGATE
	
	C.2.1. AGE_AGGREGATE, EDU_ISCED11
	C.2.2. AGE_AGGREGATE, EDU_ISCED97
	C.2.3. AGE_AGGREGATE, EDU_AGGREGATE

D) Unemployment by sex, age and rural / urban areas:
	D.1. AGE_10YRBANDS, GEO_COV
	D.2. AGE_AGGREGATE, GEO_COV
	
E) Unemployment by sex, age and duration:
	E.1.1. AGE_10YRBANDS, DUR_DETAILS
	E.1.2. AGE_10YRBANDS, DUR_AGGREGATE

	E.2.1. AGE_AGGREGATE, DUR_DETAILS
	E.2.2. AGE_AGGREGATE, DUR_AGGREGATE

F) Unemployment by sex and categories of unemployed persons: CAT_UNE

G) Unemployment by sex and education:
	E.1. EDU_ISCED11
	E.2. EDU_ISCED97
	E.3. EDU_AGGREGATE
//NOTE: Table E is only calculated in order to be used for the indicator "UNE_DEAP_SEX_EDU_RT".
*/

*Start: Open the dataset that is defined in the first do-file along with the the country name, year and source
use "$DATASET", clear

cd "$LIBMPOUT" //this changes the directory for this do-file to always be what it defines. The advantage is simply to avoid writing the directory when we save a dataset
*End


********************************************************************************************
*** A) Unemployment by sex and age *********************************************************
capture confirm variable ilo_sex //Check if the variable ilo_sex exists
if !_rc {
	//For this indicator, all the sub-indicators have this indicator_code in the final template.
	global indicator = "UNE_TUNE_SEX_AGE_NB"

	*** A.1) Unemployment by sex and age: AGE_AGGREGATE ***
	global LEVEL1        = "ilo_age_aggregate"
	global classif1TOTAL = "AGE_AGGREGATE_TOTAL"
	do "$LIBMPDO\C.4.1 DRY.do"

	*** A.2) Unemployment by sex and age: AGE_10YRBANDS ***
	global LEVEL1        = "ilo_age_10yrbands"
	global classif1TOTAL = "AGE_10YRBANDS_TOTAL"
	do "$LIBMPDO\C.4.1 DRY.do"

	*** A.3) Unemployment by sex and age: AGE_5YRBANDS ***
	global LEVEL1        = "ilo_age_5yrbands"
	global classif1TOTAL = "AGE_5YRBANDS_TOTAL"
	do "$LIBMPDO\C.4.1 DRY.do"
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "Variable ilo_sex doesn't exist."
	log close
}
********************************************************************************************


********************************************************************************************
*** B) Unemployment by sex and disability status: DSB_STATUS_AGGREGATE *********************
capture confirm variable ilo_sex //Check if the variable ilo_sex exists
if !_rc {
	//For this indicator, all the sub-indicators have this indicator_code in the final template.
	global indicator = "UNE_TUNE_SEX_DSB_NB"
	global LEVEL1        = "ilo_dsb_aggregate"
	global classif1TOTAL = "DSB_STATUS_TOTAL"
	do "$LIBMPDO\C.4.1 DRY.do"
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "Variable ilo_sex doesn't exist."
	log close
}
********************************************************************************************


********************************************************************************************
*** C) Unemployment by sex, age and education ************************************************
capture confirm variable ilo_sex //Check if the variable ilo_sex exists
if !_rc {
	//For this indicator, all the sub-indicators have this indicator_code in the final template.
	global indicator = "UNE_TUNE_SEX_AGE_EDU_NB"

	*** C.1.1) Unemployment by sex, age and education: AGE_10YRBANDS, EDU_ISCED11 ***
	global LEVEL1        = "ilo_age_10yrbands"
	global classif1TOTAL = "AGE_10YRBANDS_TOTAL"
	global LEVEL2        = "ilo_edu_isced11"
	global classif2TOTAL = "EDU_ISCED11_TOTAL"
	do "$LIBMPDO\C.4.2 DRY.do"

	*** C.1.2) Unemployment by sex, age and education: AGE_10YRBANDS, EDU_ISCED97 ***
	global LEVEL1        = "ilo_age_10yrbands"
	global classif1TOTAL = "AGE_10YRBANDS_TOTAL"
	global LEVEL2        = "ilo_edu_isced97"
	global classif2TOTAL = "EDU_ISCED97_TOTAL"
	do "$LIBMPDO\C.4.2 DRY.do"

	*** C.1.3) Unemployment by sex, age and education: AGE_10YRBANDS, EDU_AGGREGATE ***
	global LEVEL1        = "ilo_age_10yrbands"
	global classif1TOTAL = "AGE_10YRBANDS_TOTAL"
	global LEVEL2        = "ilo_edu_aggregate"
	global classif2TOTAL = "EDU_AGGREGATE_TOTAL"
	do "$LIBMPDO\C.4.2 DRY.do"

	*** C.2.1) Unemployment by sex, age and education: AGE_AGGREGATE, EDU_ISCED11 ***
	global LEVEL1        = "ilo_age_aggregate"
	global classif1TOTAL = "AGE_AGGREGATE_TOTAL"
	global LEVEL2        = "ilo_edu_isced11"
	global classif2TOTAL = "EDU_ISCED11_TOTAL"
	do "$LIBMPDO\C.4.2 DRY.do"

	*** C.2.2) Unemployment by sex, age and education: AGE_AGGREGATE, EDU_ISCED97 ***
	global LEVEL1        = "ilo_age_aggregate"
	global classif1TOTAL = "AGE_AGGREGATE_TOTAL"
	global LEVEL2        = "ilo_edu_isced97"
	global classif2TOTAL = "EDU_ISCED97_TOTAL"
	do "$LIBMPDO\C.4.2 DRY.do"

	*** C.2.3) Unemployment by sex, age and education: AGE_AGGREGATE, EDU_AGGREGATE ***
	global LEVEL1        = "ilo_age_aggregate"
	global classif1TOTAL = "AGE_AGGREGATE_TOTAL"
	global LEVEL2        = "ilo_edu_aggregate"
	global classif2TOTAL = "EDU_AGGREGATE_TOTAL"
	do "$LIBMPDO\C.4.2 DRY.do"
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "Variable ilo_sex doesn't exist."
	log close
}
********************************************************************************************


********************************************************************************************
*** D) Unemployment by sex, age and rural / urban areas ************************************
capture confirm variable ilo_sex //Check if the variable ilo_sex exists
if !_rc {
	//For this indicator, all the sub-indicators have this indicator_code in the final template.
	global indicator = "UNE_TUNE_SEX_AGE_GEO_NB"

	*** D.1) Unemployment by sex, age and rural / urban areas: AGE_10YRBANDS, GEO_COV ***
	global LEVEL1        = "ilo_age_10yrbands"
	global classif1TOTAL = "AGE_10YRBANDS_TOTAL"
	global LEVEL2        = "ilo_geo"
	global classif2TOTAL = "GEO_COV_NAT"
	do "$LIBMPDO\C.4.2 DRY.do"

	*** D.2) Unemployment by sex, age and rural / urban areas: AGE_AGGREGATE, GEO_COV ***
	global LEVEL1        = "ilo_age_aggregate"
	global classif1TOTAL = "AGE_AGGREGATE_TOTAL"
	global LEVEL2        = "ilo_geo"
	global classif2TOTAL = "GEO_COV_NAT"
	do "$LIBMPDO\C.4.2 DRY.do"
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "Variable ilo_sex doesn't exist."
	log close
}
********************************************************************************************


********************************************************************************************
*** E) Unemployment by sex, age and duration ***********************************************
capture confirm variable ilo_sex //Check if the variable ilo_sex exists
if !_rc {
	//For this indicator, all the sub-indicators have this indicator_code in the final template.
	global indicator = "UNE_TUNE_SEX_AGE_DUR_NB"

	*** E.1.1) Unemployment by sex, age and duration: AGE_10YRBANDS, DUR_DETAILS ***
	global LEVEL1        = "ilo_age_10yrbands"
	global classif1TOTAL = "AGE_10YRBANDS_TOTAL"
	global LEVEL2        = "ilo_dur_details"
	global classif2TOTAL = "DUR_DETAILS_TOTAL"
	do "$LIBMPDO\C.4.2 DRY.do"

	*** E.1.2) Unemployment by sex, age and duration: AGE_10YRBANDS, DUR_AGGREGATE ***
	global LEVEL1        = "ilo_age_10yrbands"
	global classif1TOTAL = "AGE_10YRBANDS_TOTAL"
	global LEVEL2        = "ilo_dur_aggregate"
	global classif2TOTAL = "DUR_AGGREGATE_TOTAL"
	do "$LIBMPDO\C.4.2 DRY.do"

	*** E.2.1) Unemployment by sex, age and duration: AGE_AGGREGATE, DUR_DETAILS ***
	global LEVEL1        = "ilo_age_aggregate"
	global classif1TOTAL = "AGE_AGGREGATE_TOTAL"
	global LEVEL2        = "ilo_dur_details"
	global classif2TOTAL = "DUR_DETAILS_TOTAL"
	do "$LIBMPDO\C.4.2 DRY.do"

	*** E.2.2) Unemployment by sex, age and duration: AGE_AGGREGATE, DUR_AGGREGATE ***
	global LEVEL1        = "ilo_age_aggregate"
	global classif1TOTAL = "AGE_AGGREGATE_TOTAL"
	global LEVEL2        = "ilo_dur_aggregate"
	global classif2TOTAL = "DUR_AGGREGATE_TOTAL"
	do "$LIBMPDO\C.4.2 DRY.do"
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "Variable ilo_sex doesn't exist."
	log close
}
********************************************************************************************


********************************************************************************************
*** F) Unemployment by sex and categories of unemployed persons: CAT_UNE *******************
capture confirm variable ilo_sex //Check if the variable ilo_sex exists
if !_rc {
	global indicator = "UNE_TUNE_SEX_CAT_NB"
	global LEVEL1        = "ilo_cat_une"
	global classif1TOTAL = "CAT_UNE_TOTAL"
	do "$LIBMPDO\C.4.1 DRY.do"
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "Variable ilo_sex doesn't exist."
	log close
}
********************************************************************************************



********************************************************************************************
*** G) Unemployment by sex and education *****************************************************
//NOTE: Table E is only calculated in order to be used for the indicator "UNE_DEAP_SEX_EDU_RT".
capture confirm variable ilo_sex //Check if the variable ilo_sex exists
if !_rc {
	//For this indicator, all the sub-indicators have this indicator_code in the final template.
	global indicator = "UNE_TUNE_SEX_EDU_NB" 

	*** G.1) Unemployment by sex and education: EDU_ISCED11 ***
	global LEVEL1        = "ilo_edu_isced11"
	global classif1TOTAL = "EDU_ISCED11_TOTAL"
	do "$LIBMPDO\C.4.1 DRY.do"

	*** G.2) Unemployment by sex and education: EDU_ISCED97 ***
	global LEVEL1        = "ilo_edu_isced97"
	global classif1TOTAL = "EDU_ISCED97_TOTAL"
	do "$LIBMPDO\C.4.1 DRY.do"

	*** G.3) Unemployment by sex and education: EDU_AGGREGATE ***
	global LEVEL1        = "ilo_edu_aggregate"
	global classif1TOTAL = "EDU_AGGREGATE_TOTAL"
	do "$LIBMPDO\C.4.1 DRY.do"
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "Variable ilo_sex doesn't exist."
	log close
}
********************************************************************************************
