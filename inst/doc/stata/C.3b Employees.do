capture label drop _all
capture log close
capture clear all
set more off
set mem 500m

/*This do-file calculates the indicators:
A) Employees by sex and institutional sector: INS_SECTOR

B) Employees by sex and economic activity:
	B.1 ECO_ISIC4
	B.2 ECO_ISIC3
	B.3 ECO_AGGREGATE

C) Employees by sex and occupation:
	C.1 OCU_ISCO08
	C.2 OCU_ISCO88
	C.3 OCU_AGGREGATE

D) Employees by sex and weekly hours actually worked: HOW_BANDS

E) Employees by economic activity and occupation
	E.1.1 ECO_ISIC4, OCU_ISCO08
	E.1.2 ECO_ISIC4, OCU_ISCO88
	E.1.3 ECO_ISIC4, OCU_AGGREGATE
	
	E.2.1 ECO_ISIC3, OCU_ISCO08
	E.2.2 ECO_ISIC3, OCU_ISCO88
	E.2.3 ECO_ISIC3, OCU_AGGREGATE
		
	E.3.1 ECO_AGGREGATE, OCU_ISCO08
	E.3.2 ECO_AGGREGATE, OCU_ISCO88
	E.3.3 ECO_AGGREGATE, OCU_AGGREGATE
	
F) Employees by sex and economic activity (2 digits):
	F.1 ECO_ISIC4_2DIGITS
	F.2 ECO_ISIC3_2DIGITS

G) Employees by sex and occupation (2 digits):
	G.1 OCU_ISCO08
	G.2 OCU_ISCO88
*/

*Start: Open the dataset that is defined in the first do-file along with the the country name, year and source
use "$DATASET", clear

cd "$LIBMPOUT" //this changes the directory for this do-file to always be what it defines. The advantage is simply to avoid writing the directory when we save a dataset
*End


********************************************************************************************
*** A) Employees by sex and institutional sector: INS_SECTOR *******************************
capture confirm variable ilo_sex //Check if the variable ilo_sex exists
if !_rc {
	global indicator = "EES_TEES_SEX_INS_NB"
	global LEVEL1        = "ilo_job1_ins_sector"
	global classif1TOTAL = "INS_SECTOR_TOTAL"
	do "$LIBMPDO\C.3b.1 DRY.do"
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "Variable ilo_sex doesn't exist."
	log close
}
********************************************************************************************


********************************************************************************************
*** B) Employees by sex and economic activity **********************************************
capture confirm variable ilo_sex //Check if the variable ilo_sex exists
if !_rc {
	//For this indicator, all the sub-indicators have this indicator_code in the final template.
	global indicator = "EES_TEES_SEX_ECO_NB"

	*** B.1. Employees by sex and economic activity: ECO_ISIC4 ***
	global LEVEL1        = "ilo_job1_eco_isic4"
	global classif1TOTAL = "ECO_ISIC4_TOTAL"
	do "$LIBMPDO\C.3b.1 DRY.do"

	*** B.2. Employees by sex and economic activity: ECO_ISIC3 ***
	global LEVEL1        = "ilo_job1_eco_isic3"
	global classif1TOTAL = "ECO_ISIC3_TOTAL"
	do "$LIBMPDO\C.3b.1 DRY.do"

	*** B.3. Employees by sex and economic activity: ECO_AGGREGATE ***
	global LEVEL1        = "ilo_job1_eco_aggregate"
	global classif1TOTAL = "ECO_AGGREGATE_TOTAL"
	do "$LIBMPDO\C.3b.1 DRY.do"
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "Variable ilo_sex doesn't exist."
	log close
}
********************************************************************************************


********************************************************************************************
*** C) Employees by sex and occupation *****************************************************
capture confirm variable ilo_sex //Check if the variable ilo_sex exists
if !_rc {
	//For this indicator, all the sub-indicators have this indicator_code in the final template.
	global indicator = "EES_TEES_SEX_OCU_NB" 
	
	*** C.1 Employees by sex and occupation: OCU_ISCO08 ***
	global LEVEL1        = "ilo_job1_ocu_isco08"
	global classif1TOTAL = "OCU_ISCO08_TOTAL"
	do "$LIBMPDO\C.3b.1 DRY.do"

	*** C.2 Employees by sex and occupation: OCU_ISCO88 ***
	global LEVEL1        = "ilo_job1_ocu_isco88"
	global classif1TOTAL = "OCU_ISCO88_TOTAL"
	do "$LIBMPDO\C.3b.1 DRY.do"

	*** C.3 Employees by sex and occupation: OCU_AGGREGATE ***
	global LEVEL1        = "ilo_job1_ocu_aggregate"
	global classif1TOTAL = "OCU_AGGREGATE_TOTAL"
	do "$LIBMPDO\C.3b.1 DRY.do"	
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "Variable ilo_sex doesn't exist."
	log close
}
********************************************************************************************


********************************************************************************************
*** D) Employees by sex and weekly hours actually worked: HOW_BANDS ***********************
capture confirm variable ilo_sex //Check if the variable ilo_sex exists
if !_rc {
	global indicator = "EES_TEES_SEX_HOW_NB"
	global LEVEL1        = "ilo_job1_how_actual_bands"
	global classif1TOTAL = "HOW_BANDS_TOTAL"
	do "$LIBMPDO\C.3b.1 DRY.do"
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "Variable ilo_sex doesn't exist."
	log close
}
********************************************************************************************


********************************************************************************************
*** E) Employees by economic activity and occupation **************************************
//For this indicator, all the sub-indicators have this indicator_code in the final template.
global indicator = "EES_TEES_ECO_OCU_NB"

*** E.1.1) Employees by economic activity and occupation: ECO_ISIC4, OCU_ISCO08***
global LEVEL1        = "ilo_job1_eco_isic4"
global classif1TOTAL = "ECO_ISIC4_TOTAL"
global LEVEL2        = "ilo_job1_ocu_isco08"
global classif2TOTAL = "OCU_ISCO08_TOTAL"
do "$LIBMPDO\C.3b.2 DRY.do"

*** E.1.2) Employees by economic activity and occupation: ECO_ISIC4, OCU_ISCO88***
global LEVEL1        = "ilo_job1_eco_isic4"
global classif1TOTAL = "ECO_ISIC4_TOTAL"
global LEVEL2        = "ilo_job1_ocu_isco88"
global classif2TOTAL = "OCU_ISCO88_TOTAL"
do "$LIBMPDO\C.3b.2 DRY.do"

*** E.1.3) Employment by economic activity and occupation: ECO_ISIC4, OCU_AGGREGATE***
global LEVEL1        = "ilo_job1_eco_isic4"
global classif1TOTAL = "ECO_ISIC4_TOTAL"
global LEVEL2        = "ilo_job1_ocu_aggregate"
global classif2TOTAL = "OCU_AGGREGATE_TOTAL"
do "$LIBMPDO\C.3b.2 DRY.do"

*** E.2.1) Employment by economic activity and occupation: ECO_ISIC3, OCU_ISCO08***
global LEVEL1        = "ilo_job1_eco_isic3"
global classif1TOTAL = "ECO_ISIC3_TOTAL"
global LEVEL2        = "ilo_job1_ocu_isco08"
global classif2TOTAL = "OCU_ISCO08_TOTAL"
do "$LIBMPDO\C.3b.2 DRY.do"

*** E.2.2) Employment by economic activity and occupation: ECO_ISIC3, OCU_ISCO88***
global LEVEL1        = "ilo_job1_eco_isic3"
global classif1TOTAL = "ECO_ISIC3_TOTAL"
global LEVEL2        = "ilo_job1_ocu_isco88"
global classif2TOTAL = "OCU_ISCO88_TOTAL"
do "$LIBMPDO\C.3b.2 DRY.do"

*** E.2.3) Employment by economic activity and occupation: ECO_ISIC3, OCU_AGGREGATE***
global LEVEL1        = "ilo_job1_eco_isic3"
global classif1TOTAL = "ECO_ISIC3_TOTAL"
global LEVEL2        = "ilo_job1_ocu_aggregate"
global classif2TOTAL = "OCU_AGGREGATE_TOTAL"
do "$LIBMPDO\C.3b.2 DRY.do"

*** E.3.1) Employment by economic activity and occupation: ECO_AGGREGATE, OCU_ISCO08***
global LEVEL1        = "ilo_job1_eco_aggregate"
global classif1TOTAL = "ECO_AGGREGATE_TOTAL"
global LEVEL2        = "ilo_job1_ocu_isco08"
global classif2TOTAL = "OCU_ISCO08_TOTAL"
do "$LIBMPDO\C.3b.2 DRY.do"

*** E.3.2) Employment by economic activity and occupation: ECO_AGGREGATE, OCU_ISCO88***
global LEVEL1        = "ilo_job1_eco_aggregate"
global classif1TOTAL = "ECO_AGGREGATE_TOTAL"
global LEVEL2        = "ilo_job1_ocu_isco88"
global classif2TOTAL = "OCU_ISCO88_TOTAL"
do "$LIBMPDO\C.3b.2 DRY.do"

*** E.3.3) Employment by economic activity and occupation: ECO_AGGREGATE, OCU_AGGREGATE***
global LEVEL1        = "ilo_job1_eco_aggregate"
global classif1TOTAL = "ECO_AGGREGATE_TOTAL"
global LEVEL2        = "ilo_job1_ocu_aggregate"
global classif2TOTAL = "OCU_AGGREGATE_TOTAL"
do "$LIBMPDO\C.3b.2 DRY.do"
********************************************************************************************


********************************************************************************************
*** F) Employees by sex and economic activity (2 digits) ***********************************
capture confirm variable ilo_sex //Check if the variable ilo_sex exists
if !_rc {
	//For this indicator, all the sub-indicators have this indicator_code in the final template.
	global indicator = "EES_TEES_SEX_ECO2_NB"

	*** F.1) Employees by sex and economic activity (2 digits): ECO_ISIC4 ***
	global LEVEL1        = "ilo_job1_eco_isic4_2digits"
	global classif1TOTAL = "ECO_ISIC4_TOTAL"
	do "$LIBMPDO\C.3b.1 DRY.do"

	*** F.2) Employees by sex and economic activity (2 digits): ECO_ISIC3 ***
	global LEVEL1        = "ilo_job1_eco_isic3_2digits"
	global classif1TOTAL = "ECO_ISIC3_TOTAL"
	do "$LIBMPDO\C.3b.1 DRY.do"
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "Variable ilo_sex doesn't exist."
	log close
}
********************************************************************************************


********************************************************************************************
*** G) Employees by sex and occupation (2 digits) ******************************************
capture confirm variable ilo_sex //Check if the variable ilo_sex exists
if !_rc {
	//For this indicator, all the sub-indicators have this indicator_code in the final template.
	global indicator = "EES_TEES_SEX_OCU2_NB"

	*** G.1) Employees by sex and occupation (2 digits): OCU_ISCO08 ***
	global LEVEL1        = "ilo_job1_ocu_isco08_2digits"
	global classif1TOTAL = "OCU_ISCO08_TOTAL"
	do "$LIBMPDO\C.3b.1 DRY.do"

	*** G.2) Employees by sex and occupation (2 digits): OCU_ISCO88 ***
	global LEVEL1        = "ilo_job1_ocu_isco88_2digits"
	global classif1TOTAL = "OCU_ISCO88_TOTAL"
	do "$LIBMPDO\C.3b.1 DRY.do"
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "Variable ilo_sex doesn't exist."
	log close
}
********************************************************************************************
