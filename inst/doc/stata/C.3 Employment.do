capture label drop _all
capture log close
capture clear all
set more off
set mem 500m

/*This do-file calculates the indicators:
A) Employment by sex and age:
	A.1. AGE_AGGREGATE
	A.2. AGE_10YRBANDS
	A.3. AGE_5YRBANDS

B) Employment by sex, age and education:
	B.1.1. AGE_10YRBANDS, EDU_ISCED11
	B.1.2. AGE_10YRBANDS, EDU_ISCED97
	B.1.3. AGE_10YRBANDS, EDU_AGGREGATE
	
	B.2.1. AGE_AGGREGATE, EDU_ISCED11
	B.2.2. AGE_AGGREGATE, EDU_ISCED97
	B.2.3. AGE_AGGREGATE, EDU_AGGREGATE
	
C) Employment by sex, age and rural / urban areas:
	C.1. AGE_10YRBANDS, GEO_COV
	C.2. AGE_AGGREGATE, GEO_COV

D) Employment by sex and status in employment:
	D.1. STE_ICSE93
	D.2. STE_AGGREGATE

E) Employment by sex and economic activity:
	E.1 ECO_ISIC4
	E.2 ECO_ISIC3
	E.3 ECO_AGGREGATE

F) Employment by sex and occupation:
	F.1 OCU_ISCO08
	F.2 OCU_ISCO88
	F.3 OCU_AGGREGATE
	
G) Employment by economic activity and occupation:
	G.1.1 ECO_ISIC4, OCU_ISCO08
	G.1.2 ECO_ISIC4, OCU_ISCO88
	G.1.3 ECO_ISIC4, OCU_AGGREGATE
	
	G.2.1 ECO_ISIC3, OCU_ISCO08
	G.2.2 ECO_ISIC3, OCU_ISCO88
	G.2.3 ECO_ISIC3, OCU_AGGREGATE
		
	G.3.1 ECO_AGGREGATE, OCU_ISCO08
	G.3.2 ECO_AGGREGATE, OCU_ISCO88
	G.3.3 ECO_AGGREGATE, OCU_AGGREGATE
	
H) Employment by sex, age and working time arrangement: AGE_AGGREGATE, JOB_TIME

Iž) Employment by sex and institutional sector: INS_SECTOR

K) Employment by sex and weekly hours actually worked: HOW_BANDS

L) Employment by sex and economic activity (2 digits):
	L.1. ECO_ISIC4_2DIGITS
	L.2. ECO_ISIC3_2DIGITS

M) Employment by sex and occupation (2 digits):
	M.1. OCU_ISCO08_2DIGITS
	M.2. OCU_ISCO88_2DIGITS

N) Employment by sex and education:
	N.1. EDU_ISCED11
	N.2. EDU_ISCED97
	N.3. EDU_AGGREGATE
//NOTE: Table N is only calculated in order to be used for the indicator "EMP_DWAP_SEX_EDU_RT".

O) Employment by sex and disability status: DSB_STATUS_AGGREGATE
*/

*Start: Open the dataset that is defined in the first do-file along with the the country name, year and source
use "$DATASET", clear

cd "$LIBMPOUT" //this changes the directory for this do-file to always be what it defines. The advantage is simply to avoid writing the directory when we save a dataset
*End


********************************************************************************************
*** A) Employment by sex and age ***********************************************************
capture confirm variable ilo_sex //Check if the variable ilo_sex exists
if !_rc {
	//For this indicator, all the sub-indicators have this indicator_code in the final template.
	global indicator = "EMP_TEMP_SEX_AGE_NB"

	*** A.1) Employment by sex and age: AGE_AGGREGATE ***
	global LEVEL1        = "ilo_age_aggregate"
	global classif1TOTAL = "AGE_AGGREGATE_TOTAL"
	do "$LIBMPDO\C.3.1 DRY.do"

	*** A.2) Employment by sex and age: AGE_10YRBANDS ***
	global LEVEL1        = "ilo_age_10yrbands"
	global classif1TOTAL = "AGE_10YRBANDS_TOTAL"
	do "$LIBMPDO\C.3.1 DRY.do"

	*** A.3) Employment by sex and age: AGE_5YRBANDS ***
	global LEVEL1        = "ilo_age_5yrbands"
	global classif1TOTAL = "AGE_5YRBANDS_TOTAL"
	do "$LIBMPDO\C.3.1 DRY.do"
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "Variable ilo_sex doesn't exist."
	log close
}
********************************************************************************************


********************************************************************************************
*** B) Employment by sex, age and education ************************************************
capture confirm variable ilo_sex //Check if the variable ilo_sex exists
if !_rc {
	//For this indicator, all the sub-indicators have this indicator_code in the final template.
	global indicator = "EMP_TEMP_SEX_AGE_EDU_NB"

	*** B.1.1) Employment by sex, age and education: AGE_10YRBANDS, EDU_ISCED11 ***
	global LEVEL1        = "ilo_age_10yrbands"
	global classif1TOTAL = "AGE_10YRBANDS_TOTAL"
	global LEVEL2        = "ilo_edu_isced11"
	global classif2TOTAL = "EDU_ISCED11_TOTAL"
	do "$LIBMPDO\C.3.2 DRY.do"

	*** B.1.2) Employment by sex, age and education: AGE_10YRBANDS, EDU_ISCED97 ***
	global LEVEL1        = "ilo_age_10yrbands"
	global classif1TOTAL = "AGE_10YRBANDS_TOTAL"
	global LEVEL2        = "ilo_edu_isced97"
	global classif2TOTAL = "EDU_ISCED97_TOTAL"
	do "$LIBMPDO\C.3.2 DRY.do"

	*** B.1.3) Employment by sex, age and education: AGE_10YRBANDS, EDU_AGGREGATE ***
	global LEVEL1        = "ilo_age_10yrbands"
	global classif1TOTAL = "AGE_10YRBANDS_TOTAL"
	global LEVEL2        = "ilo_edu_aggregate"
	global classif2TOTAL = "EDU_AGGREGATE_TOTAL"
	do "$LIBMPDO\C.3.2 DRY.do"

	*** B.2.1) Employment by sex, age and education: AGE_AGGREGATE, EDU_ISCED11 ***
	global LEVEL1        = "ilo_age_aggregate"
	global classif1TOTAL = "AGE_AGGREGATE_TOTAL"
	global LEVEL2        = "ilo_edu_isced11"
	global classif2TOTAL = "EDU_ISCED11_TOTAL"
	do "$LIBMPDO\C.3.2 DRY.do"

	*** B.2.2) Employment by sex, age and education: AGE_AGGREGATE, EDU_ISCED97 ***
	global LEVEL1        = "ilo_age_aggregate"
	global classif1TOTAL = "AGE_AGGREGATE_TOTAL"
	global LEVEL2        = "ilo_edu_isced97"
	global classif2TOTAL = "EDU_ISCED97_TOTAL"
	do "$LIBMPDO\C.3.2 DRY.do"

	*** B.2.3) Employment by sex, age and education: AGE_AGGREGATE, EDU_AGGREGATE ***
	global LEVEL1        = "ilo_age_aggregate"
	global classif1TOTAL = "AGE_AGGREGATE_TOTAL"
	global LEVEL2        = "ilo_edu_aggregate"
	global classif2TOTAL = "EDU_AGGREGATE_TOTAL"
	do "$LIBMPDO\C.3.2 DRY.do"
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "Variable ilo_sex doesn't exist."
	log close
}
********************************************************************************************


********************************************************************************************
*** C) Employment by sex, age and rural / urban areas **************************************
capture confirm variable ilo_sex //Check if the variable ilo_sex exists
if !_rc {
	//For this indicator, all the sub-indicators have this indicator_code in the final template.
	global indicator = "EMP_TEMP_SEX_AGE_GEO_NB"

	*** C.1) Employment by sex, age and rural / urban areas: AGE_10YRBANDS, GEO_COV ***
	global LEVEL1        = "ilo_age_10yrbands"
	global classif1TOTAL = "AGE_10YRBANDS_TOTAL"
	global LEVEL2        = "ilo_geo"
	global classif2TOTAL = "GEO_COV_NAT"
	do "$LIBMPDO\C.3.2 DRY.do"

	*** C.2) Employment by sex, age and rural / urban areas: AGE_AGGREGATE, GEO_COV ***
	global LEVEL1        = "ilo_age_aggregate"
	global classif1TOTAL = "AGE_AGGREGATE_TOTAL"
	global LEVEL2        = "ilo_geo"
	global classif2TOTAL = "GEO_COV_NAT"
	do "$LIBMPDO\C.3.2 DRY.do"
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "Variable ilo_sex doesn't exist."
	log close
}
********************************************************************************************


********************************************************************************************
*** D) Employment by sex and status in employment ******************************************
capture confirm variable ilo_sex //Check if the variable ilo_sex exists
if !_rc {
	//For this indicator, all the sub-indicators have this indicator_code in the final template.
	global indicator = "EMP_TEMP_SEX_STE_NB"
	
	*** D.1) Employment by sex and status in employment: STE_ICSE93 ***
	global LEVEL1        = "ilo_job1_ste_icse93"
	global classif1TOTAL = "STE_ICSE93_TOTAL"
	do "$LIBMPDO\C.3.1 DRY.do"

	*** D.2) Employment by sex and status in employment: STE_AGGREGATE ***
	global LEVEL1        = "ilo_job1_ste_aggregate"
	global classif1TOTAL = "STE_AGGREGATE_TOTAL"
	do "$LIBMPDO\C.3.1 DRY.do"		
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "Variable ilo_sex doesn't exist."
	log close
}
********************************************************************************************


********************************************************************************************
*** E) Employment by sex and economic activity *********************************************
capture confirm variable ilo_sex //Check if the variable ilo_sex exists
if !_rc {
	//For this indicator, all the sub-indicators have this indicator_code in the final template.
	global indicator = "EMP_TEMP_SEX_ECO_NB"
	
	*** E.1) Employment by sex and economic activity: ECO_ISIC4 ***
	global LEVEL1        = "ilo_job1_eco_isic4"
	global classif1TOTAL = "ECO_ISIC4_TOTAL"
	do "$LIBMPDO\C.3.1 DRY.do"

	*** E.2) Employment by sex and economic activity: ECO_ISIC3 ***
	global LEVEL1        = "ilo_job1_eco_isic3"
	global classif1TOTAL = "ECO_ISIC3_TOTAL"
	do "$LIBMPDO\C.3.1 DRY.do"		

	*** E.3) Employment by sex and economic activity: ECO_AGGREGATE ***
	global LEVEL1        = "ilo_job1_eco_aggregate"
	global classif1TOTAL = "ECO_AGGREGATE_TOTAL"
	do "$LIBMPDO\C.3.1 DRY.do"	
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "Variable ilo_sex doesn't exist."
	log close
}
********************************************************************************************


********************************************************************************************
*** F) Employment by sex and occupation ****************************************************
capture confirm variable ilo_sex //Check if the variable ilo_sex exists
if !_rc {
	//For this indicator, all the sub-indicators have this indicator_code in the final template.
	global indicator = "EMP_TEMP_SEX_OCU_NB" 
	
	*** F.1) Employment by sex and occupation: OCU_ISCO08 ***
	global LEVEL1        = "ilo_job1_ocu_isco08"
	global classif1TOTAL = "OCU_ISCO08_TOTAL"
	do "$LIBMPDO\C.3.1 DRY.do"

	*** F.2) Employment by sex and occupation: OCU_ISCO88 ***
	global LEVEL1        = "ilo_job1_ocu_isco88"
	global classif1TOTAL = "OCU_ISCO88_TOTAL"
	do "$LIBMPDO\C.3.1 DRY.do"

	*** F.3) Employment by sex and occupation: OCU_AGGREGATE ***
	global LEVEL1        = "ilo_job1_ocu_aggregate"
	global classif1TOTAL = "OCU_AGGREGATE_TOTAL"
	do "$LIBMPDO\C.3.1 DRY.do"	
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "Variable ilo_sex doesn't exist."
	log close
}
********************************************************************************************


********************************************************************************************
*** G) Employment by economic activity and occupation **************************************
//For this indicator, all the sub-indicators have this indicator_code in the final template.
global indicator = "EMP_TEMP_ECO_OCU_NB"

*** G.1.1) Employment by economic activity and occupation: ECO_ISIC4, OCU_ISCO08 ***
global LEVEL1        = "ilo_job1_eco_isic4"
global classif1TOTAL = "ECO_ISIC4_TOTAL"
global LEVEL2        = "ilo_job1_ocu_isco08"
global classif2TOTAL = "OCU_ISCO08_TOTAL"
do "$LIBMPDO\C.3.2 DRY.do"

*** G.1.2) Employment by economic activity and occupation: ECO_ISIC4, OCU_ISCO88 ***
global LEVEL1        = "ilo_job1_eco_isic4"
global classif1TOTAL = "ECO_ISIC4_TOTAL"
global LEVEL2        = "ilo_job1_ocu_isco88"
global classif2TOTAL = "OCU_ISCO88_TOTAL"
do "$LIBMPDO\C.3.2 DRY.do"

*** G.1.3) Employment by economic activity and occupation: ECO_ISIC4, OCU_AGGREGATE ***
global LEVEL1        = "ilo_job1_eco_isic4"
global classif1TOTAL = "ECO_ISIC4_TOTAL"
global LEVEL2        = "ilo_job1_ocu_aggregate"
global classif2TOTAL = "OCU_AGGREGATE_TOTAL"
do "$LIBMPDO\C.3.2 DRY.do"

*** G.2.1) Employment by economic activity and occupation: ECO_ISIC3, OCU_ISCO08 ***
global LEVEL1        = "ilo_job1_eco_isic3"
global classif1TOTAL = "ECO_ISIC3_TOTAL"
global LEVEL2        = "ilo_job1_ocu_isco08"
global classif2TOTAL = "OCU_ISCO08_TOTAL"
do "$LIBMPDO\C.3.2 DRY.do"

*** G.2.2) Employment by economic activity and occupation: ECO_ISIC3, OCU_ISCO88 ***
global LEVEL1        = "ilo_job1_eco_isic3"
global classif1TOTAL = "ECO_ISIC3_TOTAL"
global LEVEL2        = "ilo_job1_ocu_isco88"
global classif2TOTAL = "OCU_ISCO88_TOTAL"
do "$LIBMPDO\C.3.2 DRY.do"

*** G.2.3) Employment by economic activity and occupation: ECO_ISIC3, OCU_AGGREGATE ***
global LEVEL1        = "ilo_job1_eco_isic3"
global classif1TOTAL = "ECO_ISIC3_TOTAL"
global LEVEL2        = "ilo_job1_ocu_aggregate"
global classif2TOTAL = "OCU_AGGREGATE_TOTAL"
do "$LIBMPDO\C.3.2 DRY.do"

*** G.3.1) Employment by economic activity and occupation: ECO_AGGREGATE, OCU_ISCO08 ***
global LEVEL1        = "ilo_job1_eco_aggregate"
global classif1TOTAL = "ECO_AGGREGATE_TOTAL"
global LEVEL2        = "ilo_job1_ocu_isco08"
global classif2TOTAL = "OCU_ISCO08_TOTAL"
do "$LIBMPDO\C.3.2 DRY.do"

*** G.3.2) Employment by economic activity and occupation: ECO_AGGREGATE, OCU_ISCO88 ***
global LEVEL1        = "ilo_job1_eco_aggregate"
global classif1TOTAL = "ECO_AGGREGATE_TOTAL"
global LEVEL2        = "ilo_job1_ocu_isco88"
global classif2TOTAL = "OCU_ISCO88_TOTAL"
do "$LIBMPDO\C.3.2 DRY.do"

*** G.3.3) Employment by economic activity and occupation: ECO_AGGREGATE, OCU_AGGREGATE ***
global LEVEL1        = "ilo_job1_eco_aggregate"
global classif1TOTAL = "ECO_AGGREGATE_TOTAL"
global LEVEL2        = "ilo_job1_ocu_aggregate"
global classif2TOTAL = "OCU_AGGREGATE_TOTAL"
do "$LIBMPDO\C.3.2 DRY.do"
********************************************************************************************


********************************************************************************************
*** H) Employment by sex, age and working time arrangement: AGE_AGGREGATE, JOB_TIME ********
capture confirm variable ilo_sex //Check if the variable ilo_sex exists
if !_rc {
	global indicator = "EMP_TEMP_SEX_AGE_JOB_NB"
	global LEVEL1        = "ilo_age_aggregate"
	global classif1TOTAL = "AGE_AGGREGATE_TOTAL"
	global LEVEL2        = "ilo_job1_job_time"
	global classif2TOTAL = "JOB_TIME_TOTAL"
	do "$LIBMPDO\C.3.2 DRY.do"
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "Variable ilo_sex doesn't exist."
	log close
}
********************************************************************************************


********************************************************************************************
*** Iž) Employment by sex and institutional sector: INS_SECTOR ******************************
capture confirm variable ilo_sex //Check if the variable ilo_sex exists
if !_rc {
	global indicator = "EMP_TEMP_SEX_INS_NB"
	global LEVEL1        = "ilo_job1_ins_sector"
	global classif1TOTAL = "INS_SECTOR_TOTAL"
	do "$LIBMPDO\C.3.1 DRY.do"
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "Variable ilo_sex doesn't exist."
	log close
}
********************************************************************************************


********************************************************************************************
*** K) Employment by sex and weekly hours actually worked: HOW_BANDS ***********************
capture confirm variable ilo_sex //Check if the variable ilo_sex exists
if !_rc {
	global indicator = "EMP_TEMP_SEX_HOW_NB"
	global LEVEL1        = "ilo_joball_how_actual_bands"
	global classif1TOTAL = "HOW_BANDS_TOTAL"
	do "$LIBMPDO\C.3.1 DRY.do"
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "Variable ilo_sex doesn't exist."
	log close
}
********************************************************************************************


********************************************************************************************
*** L) Employment by sex and economic activity (2 digits) **********************************
capture confirm variable ilo_sex //Check if the variable ilo_sex exists
if !_rc {
	//For this indicator, all the sub-indicators have this indicator_code in the final template.
	global indicator = "EMP_TEMP_SEX_ECO2_NB" 
	
	*** L.1) Employment by sex and economic activity (2 digits): ECO_ISIC4_2DIGITS ***
	global LEVEL1        = "ilo_job1_eco_isic4_2digits"
	global classif1TOTAL = "ECO_ISIC4_TOTAL"
	do "$LIBMPDO\C.3.1 DRY.do"
	
	*** L.2) Employment by sex and economic activity (2 digits): ECO_ISIC3_2DIGITS ***
	global LEVEL1        = "ilo_job1_eco_isic3_2digits"
	global classif1TOTAL = "ECO_ISIC3_TOTAL"
	do "$LIBMPDO\C.3.1 DRY.do"		
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "Variable ilo_sex doesn't exist."
	log close
}
********************************************************************************************


********************************************************************************************
*** M) Employment by sex and occupation (2 digits) *****************************************
capture confirm variable ilo_sex //Check if the variable ilo_sex exists
if !_rc {
	//For this indicator, all the sub-indicators have this indicator_code in the final template.
	global indicator = "EMP_TEMP_SEX_OCU2_NB" 
	
	*** M.1) Employment by sex and occupation (2 digits): OCU_ISCO08 ***
	global LEVEL1        = "ilo_job1_ocu_isco08_2digits"
	global classif1TOTAL = "OCU_ISCO08_TOTAL"
	do "$LIBMPDO\C.3.1 DRY.do"
	
	*** M.2) Employment by sex and occupation (2 digits): OCU_ISCO88 ***
	global LEVEL1        = "ilo_job1_ocu_isco88_2digits"
	global classif1TOTAL = "OCU_ISCO88_TOTAL"
	do "$LIBMPDO\C.3.1 DRY.do"		
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "Variable ilo_sex doesn't exist."
	log close
}
********************************************************************************************


********************************************************************************************
*** N) Employment by sex and education *****************************************************
//NOTE: Table O is only calculated in order to be used for the indicator "EMP_DWAP_SEX_EDU_RT".
capture confirm variable ilo_sex //Check if the variable ilo_sex exists
if !_rc {
	//For this indicator, all the sub-indicators have this indicator_code in the final template.
	global indicator = "EMP_TEMP_SEX_EDU_NB" 

	*** N.1) Employment by sex and education: EDU_ISCED11 ***
	global LEVEL1        = "ilo_edu_isced11"
	global classif1TOTAL = "EDU_ISCED11_TOTAL"
	do "$LIBMPDO\C.3.1 DRY.do"

	*** N.2) Employment by sex and education: EDU_ISCED97 ***
	global LEVEL1        = "ilo_edu_isced97"
	global classif1TOTAL = "EDU_ISCED97_TOTAL"
	do "$LIBMPDO\C.3.1 DRY.do"

	*** N.3) Employment by sex and education: EDU_AGGREGATE ***
	global LEVEL1        = "ilo_edu_aggregate"
	global classif1TOTAL = "EDU_AGGREGATE_TOTAL"
	do "$LIBMPDO\C.3.1 DRY.do"
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "Variable ilo_sex doesn't exist."
	log close
}
********************************************************************************************


********************************************************************************************
*** O) Employment by sex and disability status: DSB_STATUS_AGGREGATE ***********************
capture confirm variable ilo_sex //Check if the variable ilo_sex exists
if !_rc {
	//For this indicator, all the sub-indicators have this indicator_code in the final template.
	global indicator = "EMP_TEMP_SEX_DSB_NB"
	global LEVEL1        = "ilo_dsb_aggregate"
	global classif1TOTAL = "DSB_STATUS_TOTAL"
	do "$LIBMPDO\C.3.1 DRY.do"
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "Variable ilo_sex doesn't exist."
	log close
}
********************************************************************************************
