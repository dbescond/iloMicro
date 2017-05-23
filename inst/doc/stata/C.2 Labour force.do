capture label drop _all
capture log close
capture clear all
set more off
set mem 500m

/*This do-file calculates the indicators:
A) Labour force by sex and age:
	A.1. AGE_AGGREGATE
	A.2. AGE_10YRBANDS
	A.3. AGE_5YRBANDS

B) Labour force by sex, age and education:
	B.1.1. AGE_10YRBANDS, EDU_ISCED11
	B.1.2. AGE_10YRBANDS, EDU_ISCED97
	B.1.3. AGE_10YRBANDS, EDU_AGGREGATE
	
	B.2.1. AGE_AGGREGATE, EDU_ISCED11
	B.2.2. AGE_AGGREGATE, EDU_ISCED97
	B.2.3. AGE_AGGREGATE, EDU_AGGREGATE
	
C) Labour force by sex, age and rural / urban areas:
	C.1. AGE_10YRBANDS, GEO_COV
	C.2. AGE_AGGREGATE, GEO_COV

D) Labour force by sex and education:
	D.1. EDU_ISCED11
	D.2. EDU_ISCED97
	D.3. EDU_AGGREGATE
//NOTE: Table D is only calculated in order to be used for the indicators "EAP_DWAP_SEX_EDU_RT" and "UNE_DEAP_SEX_EDU_RT".

E) Labour force by sex and disability status: DSB_STATUS_AGGREGATE
*/

*Start: Open the dataset that is defined in the first do-file along with the the country name, year and source
use "$DATASET", clear

cd "$LIBMPOUT" //this changes the directory for this do-file to always be what it defines. The advantage is simply to avoid writing the directory when we save a dataset
*End


********************************************************************************************
*** A) Labour force by sex and age *********************************************************
capture confirm variable ilo_sex //Check if the variable ilo_sex exists
if !_rc {
	//For this indicator, all the sub-indicators have this indicator_code in the final template.
	global indicator = "EAP_TEAP_SEX_AGE_NB" 
	
	*** A.1) Labour force by sex and age: AGE_AGGREGATE ***
	global LEVEL1        = "ilo_age_aggregate"
	global classif1TOTAL = "AGE_AGGREGATE_TOTAL"
	do "$LIBMPDO\C.2.1 DRY.do"

	*** A.2) Labour force by sex and age: AGE_10YRBANDS ***
	global LEVEL1        = "ilo_age_10yrbands"
	global classif1TOTAL = "AGE_10YRBANDS_TOTAL"
	do "$LIBMPDO\C.2.1 DRY.do"

	*** A.3) Labour force by sex and age: AGE_5YRBANDS ***
	global LEVEL1        = "ilo_age_5yrbands"
	global classif1TOTAL = "AGE_5YRBANDS_TOTAL"
	do "$LIBMPDO\C.2.1 DRY.do"
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "Variable ilo_sex doesn't exist."
	log close
}
********************************************************************************************


********************************************************************************************
*** B) Labour force by sex, age and education **********************************************
capture confirm variable ilo_sex //Check if the variable ilo_sex exists
if !_rc {
	//For this indicator, all the sub-indicators have this indicator_code in the final template.
	global indicator = "EAP_TEAP_SEX_AGE_EDU_NB" 

	*** B.1.1) Labour force by sex, age and education: AGE_10YRBANDS, EDU_ISCED11 ***
	global LEVEL1        = "ilo_age_10yrbands"
	global classif1TOTAL = "AGE_10YRBANDS_TOTAL"
	global LEVEL2        = "ilo_edu_isced11"
	global classif2TOTAL = "EDU_ISCED11_TOTAL"
	do "$LIBMPDO\C.2.2 DRY.do"

	*** B.1.2) Labour force by sex, age and education: AGE_10YRBANDS, EDU_ISCED97 ***
	global LEVEL1        = "ilo_age_10yrbands"
	global classif1TOTAL = "AGE_10YRBANDS_TOTAL"
	global LEVEL2        = "ilo_edu_isced97"
	global classif2TOTAL = "EDU_ISCED97_TOTAL"
	do "$LIBMPDO\C.2.2 DRY.do"

	*** B.1.3) Labour force by sex, age and education: AGE_10YRBANDS, EDU_AGGREGATE ***
	global LEVEL1        = "ilo_age_10yrbands"
	global classif1TOTAL = "AGE_10YRBANDS_TOTAL"
	global LEVEL2        = "ilo_edu_aggregate"
	global classif2TOTAL = "EDU_AGGREGATE_TOTAL"
	do "$LIBMPDO\C.2.2 DRY.do"

	*** B.2.1) Labour force by sex, age and education: AGE_AGGREGATE, EDU_ISCED11 ***
	global LEVEL1        = "ilo_age_aggregate"
	global classif1TOTAL = "AGE_AGGREGATE_TOTAL"
	global LEVEL2        = "ilo_edu_isced11"
	global classif2TOTAL = "EDU_ISCED11_TOTAL"
	do "$LIBMPDO\C.2.2 DRY.do"

	*** B.2.2) Labour force by sex, age and education: AGE_AGGREGATE, EDU_ISCED97 ***
	global LEVEL1        = "ilo_age_aggregate"
	global classif1TOTAL = "AGE_AGGREGATE_TOTAL"
	global LEVEL2        = "ilo_edu_isced97"
	global classif2TOTAL = "EDU_ISCED97_TOTAL"
	do "$LIBMPDO\C.2.2 DRY.do"

	*** B.2.3) Labour force by sex, age and education: AGE_AGGREGATE, EDU_AGGREGATE ***
	global LEVEL1        = "ilo_age_aggregate"
	global classif1TOTAL = "AGE_AGGREGATE_TOTAL"
	global LEVEL2        = "ilo_edu_aggregate"
	global classif2TOTAL = "EDU_AGGREGATE_TOTAL"
	do "$LIBMPDO\C.2.2 DRY.do"
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "Variable ilo_sex doesn't exist."
	log close
}
********************************************************************************************


********************************************************************************************
*** C) Labour force by sex, age and rural / urban areas ************************************
capture confirm variable ilo_sex //Check if the variable ilo_sex exists
if !_rc {
	//For this indicator, all the sub-indicators have this indicator_code in the final template.
	global indicator = "EAP_TEAP_SEX_AGE_GEO_NB" 

	*** C.1. Labour force by sex, age and rural / urban areas: AGE_10YRBANDS, GEO_COV ***
	global LEVEL1        = "ilo_age_10yrbands"
	global classif1TOTAL = "AGE_10YRBANDS_TOTAL"
	global LEVEL2        = "ilo_geo"
	global classif2TOTAL = "GEO_COV_NAT"
	do "$LIBMPDO\C.2.2 DRY.do"

	*** C.2. Labour force by sex, age and rural / urban areas: AGE_AGGREGATE, GEO_COV ***
	global LEVEL1        = "ilo_age_aggregate"
	global classif1TOTAL = "AGE_AGGREGATE_TOTAL"
	global LEVEL2        = "ilo_geo"
	global classif2TOTAL = "GEO_COV_NAT"
	do "$LIBMPDO\C.2.2 DRY.do"
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "Variable ilo_sex doesn't exist."
	log close
}
********************************************************************************************


********************************************************************************************
*** D) Labour force by sex and education ***************************************************
//NOTE: Table D is only calculated in order to be used for the indicators "EAP_DWAP_SEX_EDU_RT" and "UNE_DEAP_SEX_EDU_RT".
capture confirm variable ilo_sex //Check if the variable ilo_sex exists
if !_rc {
	//For this indicator, all the sub-indicators have this indicator_code in the final template.
	global indicator = "EAP_TEAP_SEX_EDU_NB" 

	*** D.1) Labour force by sex and education: EDU_ISCED11 ***
	global LEVEL1        = "ilo_edu_isced11"
	global classif1TOTAL = "EDU_ISCED11_TOTAL"
	do "$LIBMPDO\C.2.1 DRY.do"

	*** D.2) Labour force by sex and education: EDU_ISCED97 ***
	global LEVEL1        = "ilo_edu_isced97"
	global classif1TOTAL = "EDU_ISCED97_TOTAL"
	do "$LIBMPDO\C.2.1 DRY.do"

	*** D.3) Labour force by sex and education: EDU_AGGREGATE ***
	global LEVEL1        = "ilo_edu_aggregate"
	global classif1TOTAL = "EDU_AGGREGATE_TOTAL"
	do "$LIBMPDO\C.2.1 DRY.do"
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "Variable ilo_sex doesn't exist."
	log close
}
********************************************************************************************


********************************************************************************************
*** E) Labour force by sex and disability status: DSB_STATUS_AGGREGATE *********************
capture confirm variable ilo_sex //Check if the variable ilo_sex exists
if !_rc {
	//For this indicator, all the sub-indicators have this indicator_code in the final template.
	global indicator = "EAP_TEAP_SEX_DSB_NB"
	global LEVEL1        = "ilo_dsb_aggregate"
	global classif1TOTAL = "DSB_STATUS_TOTAL"
	do "$LIBMPDO\C.2.1 DRY.do"
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "Variable ilo_sex doesn't exist."
	log close
}
********************************************************************************************
