capture label drop _all
capture log close
capture clear all
set more off
set mem 500m

/*This do-file calculates the indicators:
A) Unemployment of previously employed persons by sex and former economic activity:
	G.1 ECO_ISIC4
	G.2 ECO_ISIC3
	G.3 ECO_AGGREGATE

B) Unemployment of previously employed persons by sex and former occupation:
	H.1 OCU_ISCO08
	H.2 OCU_ISCO88
	H.3 OCU_AGGREGATE
*/

*Start: Open the dataset that is defined in the first do-file along with the the country name, year and source
use "$DATASET", clear

cd "$LIBMPOUT" //this changes the directory for this do-file to always be what it defines. The advantage is simply to avoid writing the directory when we save a dataset
*End


********************************************************************************************
*** A) Unemployment of previously employed persons by sex and former economic activity *****
capture confirm variable ilo_sex //Check if the variable ilo_sex exists
if !_rc {
	//For this indicator, all the sub-indicators have this indicator_code in the final template.
	global indicator = "UNE_TUNE_SEX_ECO_NB"
	
	*** A.1. Unemployment of previously employed persons by sex and former economic activity: ECO_ISIC4 ***
	global LEVEL1        = "ilo_preveco_isic4"
	global classif1TOTAL = "ECO_ISIC4_TOTAL"
	do "$LIBMPDO\C.4b.1 DRY.do"

	*** A.2. Unemployment of previously employed persons by sex and former economic activity: ECO_ISIC3 ***
	global LEVEL1        = "ilo_preveco_isic3"
	global classif1TOTAL = "ECO_ISIC3_TOTAL"
	do "$LIBMPDO\C.4b.1 DRY.do"		

	*** A.3. Unemployment of previously employed persons by sex and former economic activity: ECO_AGGREGATE ***
	global LEVEL1        = "ilo_preveco_aggregate"
	global classif1TOTAL = "ECO_AGGREGATE_TOTAL"
	do "$LIBMPDO\C.4b.1 DRY.do"	
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "Variable ilo_sex doesn't exist."
	log close
}
********************************************************************************************


********************************************************************************************
*** B) Unemployment of previously employed persons by sex and former occupation ************
capture confirm variable ilo_sex //Check if the variable ilo_sex exists
if !_rc {
	//For this indicator, all the sub-indicators have this indicator_code in the final template.
	global indicator = "UNE_TUNE_SEX_OCU_NB" 
	
	*** B.1 Unemployment of previously employed persons by sex and former occupation: OCU_ISCO08 ***
	global LEVEL1        = "ilo_prevocu_isco08"
	global classif1TOTAL = "OCU_ISCO08_TOTAL"
	do "$LIBMPDO\C.4b.1 DRY.do"

	*** B.2 Unemployment of previously employed persons by sex and former occupation: OCU_ISCO88 ***
	global LEVEL1        = "ilo_prevocu_isco88"
	global classif1TOTAL = "OCU_ISCO88_TOTAL"
	do "$LIBMPDO\C.4b.1 DRY.do"

	*** B.3 Unemployment of previously employed persons by sex and former occupation: OCU_AGGREGATE ***
	global LEVEL1        = "ilo_prevocu_aggregate"
	global classif1TOTAL = "OCU_AGGREGATE_TOTAL"
	do "$LIBMPDO\C.4b.1 DRY.do"	
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "Variable ilo_sex doesn't exist."
	log close
}
********************************************************************************************
