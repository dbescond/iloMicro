capture label drop _all
capture log close
capture clear all
set more off
set mem 500m

/*This do-file calculates the indicators:
A) Mean weekly hours usually worked per employed person by sex

B) Mean weekly hours usually worked per employee by sex

C) Mean weekly hours actually worked per employed person by sex and economic activity:
	C.1. ECO_ISIC4
	C.2. ECO_ISIC3
	C.3. ECO_AGGREGATE
	
D) Mean weekly hours actually worked per employed person by sex and occupation:
	D.1. OCU_ISCO08
	D.2. OCU_ISCO88
	D.3. OCU_AGGREGATE

E) Mean weekly hours actually worked per employee by sex and economic activity:
	E.1. ECO_ISIC4
	E.2. ECO_ISIC3
	E.3. ECO_AGGREGATE

F) Mean weekly hours actually worked per employee by sex and occupation:
	D.1. OCU_ISCO08
	D.2. OCU_ISCO88
	D.3. OCU_AGGREGATE
*/

*Start: Open the dataset that is defined in the first do-file along with the the country name, year and source
use "$DATASET", clear

cd "$LIBMPOUT" //this changes the directory for this do-file to always be what it defines. The advantage is simply to avoid writing the directory when we save a dataset
*End


********************************************************************************************
*** A) Mean weekly hours usually worked per employed person by sex *************************
capture confirm variable ilo_sex //Check if the variable ilo_sex exists
if !_rc {
	global indicator = "HOW_UEMP_SEX_NB"
	global hours = "ilo_job1_how_usual"
	do "$LIBMPDO\C.10.1 DRY.do"
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "Variable ilo_sex doesn't exist."
	log close
}
********************************************************************************************


********************************************************************************************
*** B) Mean weekly hours usually worked per employee by sex ********************************
capture confirm variable ilo_sex //Check if the variable ilo_sex exists
if !_rc {
	global indicator = "HOW_UEES_SEX_NB"
	global hours = "ilo_job1_how_usual"
	do "$LIBMPDO\C.10.2 DRY.do"
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "Variable ilo_sex doesn't exist."
	log close
}
********************************************************************************************


********************************************************************************************
*** C) Mean weekly hours actually worked per employed person by sex and economic activity **
capture confirm variable ilo_sex //Check if the variable ilo_sex exists
if !_rc {
	//All the sub-indicators have this indicator_code and use this working-hours' type in the final template.
	global indicator = "HOW_TEMP_SEX_ECO_NB"
	global hours = "ilo_job1_how_actual"
	
	*** C.1) Mean weekly hours actually worked per employed person by sex and economic activity: ECO_ISIC4 ***
	global LEVEL1        = "ilo_job1_eco_isic4"
	global classif1TOTAL = "ECO_ISIC4_TOTAL"
	do "$LIBMPDO\C.10.3 DRY.do"
	
	*** C.2) Mean weekly hours actually worked per employed person by sex and economic activity: ECO_ISIC3 ***
	global LEVEL1        = "ilo_job1_eco_isic3"
	global classif1TOTAL = "ECO_ISIC3_TOTAL"
	do "$LIBMPDO\C.10.3 DRY.do"

	*** C.3) Mean weekly hours actually worked per employed person by sex and economic activity: ECO_AGGREGATE ***
	global LEVEL1        = "ilo_job1_eco_aggregate"
	global classif1TOTAL = "ECO_AGGREGATE_TOTAL"
	do "$LIBMPDO\C.10.3 DRY.do"
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "Variable ilo_sex doesn't exist."
	log close
}
********************************************************************************************


********************************************************************************************
*** D) Mean weekly hours actually worked per employed person by sex and occupation *********
capture confirm variable ilo_sex //Check if the variable ilo_sex exists
if !_rc {
	//All the sub-indicators have this indicator_code and use this working-hours' type in the final template.
	global indicator = "HOW_TEMP_SEX_OCU_NB"
	global hours = "ilo_job1_how_actual"
	
	*** D.1) Mean weekly hours actually worked per employed person by sex and occupation: OCU_ISCO08 ***
	global LEVEL1        = "ilo_job1_ocu_isco08"
	global classif1TOTAL = "OCU_ISCO08_TOTAL"
	do "$LIBMPDO\C.10.3 DRY.do"
	
	*** D.2) Mean weekly hours actually worked per employed person by sex and occupation: OCU_ISCO88 ***
	global LEVEL1        = "ilo_job1_ocu_isco88"
	global classif1TOTAL = "OCU_ISCO88_TOTAL"
	do "$LIBMPDO\C.10.3 DRY.do"

	*** D.3) Mean weekly hours actually worked per employed person by sex and occupation: OCU_AGGREGATE ***
	global LEVEL1        = "ilo_job1_ocu_aggregate"
	global classif1TOTAL = "OCU_AGGREGATE_TOTAL"
	do "$LIBMPDO\C.10.3 DRY.do"
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "Variable ilo_sex doesn't exist."
	log close
}
********************************************************************************************


********************************************************************************************
*** E) Mean weekly hours actually worked per employee by sex and economic activity *********
capture confirm variable ilo_sex //Check if the variable ilo_sex exists
if !_rc {
	//All the sub-indicators have this indicator_code and use this working-hours' type in the final template.
	global indicator = "HOW_XEES_SEX_ECO_NB"
	global hours = "ilo_job1_how_actual"
	
	*** E.1) Mean weekly hours actually worked per employee by sex and economic activity: ECO_ISIC4 ***
	global LEVEL1        = "ilo_job1_eco_isic4"
	global classif1TOTAL = "ECO_ISIC4_TOTAL"
	do "$LIBMPDO\C.10.4 DRY.do"
	
	*** E.2) Mean weekly hours actually worked per employee by sex and economic activity: ECO_ISIC3 ***
	global LEVEL1        = "ilo_job1_eco_isic3"
	global classif1TOTAL = "ECO_ISIC3_TOTAL"
	do "$LIBMPDO\C.10.4 DRY.do"

	*** E.3) Mean weekly hours actually worked per employee by sex and economic activity: ECO_AGGREGATE ***
	global LEVEL1        = "ilo_job1_eco_aggregate"
	global classif1TOTAL = "ECO_AGGREGATE_TOTAL"
	do "$LIBMPDO\C.10.4 DRY.do"
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "Variable ilo_sex doesn't exist."
	log close
}
********************************************************************************************


********************************************************************************************
*** F) Mean weekly hours actually worked per employee by sex and occupation ****************
capture confirm variable ilo_sex //Check if the variable ilo_sex exists
if !_rc {
	//All the sub-indicators have this indicator_code and use this working-hours' type in the final template.
	global indicator = "HOW_XEES_SEX_OCU_NB"
	global hours = "ilo_job1_how_actual"
	
	*** F.1) Mean weekly hours actually worked per employee by sex and occupation: OCU_ISCO08 ***
	global LEVEL1        = "ilo_job1_ocu_isco08"
	global classif1TOTAL = "OCU_ISCO08_TOTAL"
	do "$LIBMPDO\C.10.4 DRY.do"
	
	*** F.2) Mean weekly hours actually worked per employee by sex and occupation: OCU_ISCO88 ***
	global LEVEL1        = "ilo_job1_ocu_isco88"
	global classif1TOTAL = "OCU_ISCO88_TOTAL"
	do "$LIBMPDO\C.10.4 DRY.do"

	*** F.3) Mean weekly hours actually worked per employee by sex and occupation: OCU_AGGREGATE ***
	global LEVEL1        = "ilo_job1_ocu_aggregate"
	global classif1TOTAL = "OCU_AGGREGATE_TOTAL"
	do "$LIBMPDO\C.10.4 DRY.do"
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "Variable ilo_sex doesn't exist."
	log close
}
********************************************************************************************
