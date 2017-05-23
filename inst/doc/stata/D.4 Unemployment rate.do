capture label drop _all
capture log close
capture clear all
set more off
set mem 500m

/*This do-file calculates the indicators:
A) ˜Unemployment rate by sex and age:
	A.1. AGE_AGGREGATE
	A.2. AGE_10YRBANDS
	A.3. AGE_5YRBANDS

B) ˜Unemployment rate by sex and education:
	B.1. EDU_ISCED11
	B.1. EDU_ISCED97
	B.1. EDU_AGGREGATE
		
C) ˜Unemployment rate by sex, age and rural / urban areas:
	C.1. AGE_10YRBANDS, GEO_COV
	C.2. AGE_AGGREGATE, GEO_COV

D) Unemployment RATE by sex, age and education:
	D.1.1. AGE_10YRBANDS, EDU_ISCED11
	D.1.2. AGE_10YRBANDS, EDU_ISCED97
	D.1.3. AGE_10YRBANDS, EDU_AGGREGATE
	
	D.2.1. AGE_AGGREGATE, EDU_ISCED11
	D.2.2. AGE_AGGREGATE, EDU_ISCED97
	D.2.3. AGE_AGGREGATE, EDU_AGGREGATE

E) Unemployment rate by sex and disability status
*/

*Start: Open the dataset that is defined in the first do-file along with the the country name, year and source
use "$DATASET", clear

cd "$LIBMPOUT" //this changes the directory for this do-file to always be what it defines. The advantage is simply to avoid writing the directory when we save a dataset
*End


********************************************************************************************
*** A) ˜Unemployment rate by sex and age ****************************************************
*** This indicator is calculated as: UNE_TUNE_NB / EAP_TEAP_NB * 100
global indicator   = "UNE_DEAP_SEX_AGE_RT"
global numerator   = "UNE_TUNE_SEX_AGE_NB"
global denominator = "EAP_TEAP_SEX_AGE_NB"
global list = "ilo_age_aggregate ilo_age_10yrbands ilo_age_5yrbands" //for LEVEL1
do "$LIBMPDO\D.0 Rates 1 DRY.do"
********************************************************************************************


********************************************************************************************
*** B) ˜Unemployment rate by sex and education **********************************************
*** This indicator is calculated as: UNE_TUNE_NB / EAP_TEAP_NB * 100
global indicator   = "UNE_DEAP_SEX_EDU_RT"
global numerator   = "UNE_TUNE_SEX_EDU_NB"
global denominator = "EAP_TEAP_SEX_EDU_NB"
global list = "ilo_edu_isced11 ilo_edu_isced97 ilo_edu_aggregate" //for LEVEL1
do "$LIBMPDO\D.0 Rates 1 DRY.do"
********************************************************************************************


********************************************************************************************
*** C) ˜Unemployment rate by sex, age and rural / urban areas *******************************
*** This indicator is calculated as: UNE_TUNE_NB / EAP_TEAP_NB * 100
global indicator   = "UNE_DEAP_SEX_AGE_GEO_RT"
global numerator   = "UNE_TUNE_SEX_AGE_GEO_NB"
global denominator = "EAP_TEAP_SEX_AGE_GEO_NB"
global list = "ilo_age_aggregate ilo_age_10yrbands" //for LEVEL1
global LEVEL2 = "ilo_geo"
do "$LIBMPDO\D.0 Rates 2 DRY.do"
********************************************************************************************


********************************************************************************************
*** D) ˜Unemployment rate by sex, age and education *****************************************
*** This indicator is calculated as: UNE_TUNE_NB / EAP_TEAP_NB * 100
global indicator   = "UNE_DEAP_SEX_AGE_EDU_RT"
global numerator   = "UNE_TUNE_SEX_AGE_EDU_NB"
global denominator = "EAP_TEAP_SEX_AGE_EDU_NB"
global list1 = "ilo_age_aggregate ilo_age_10yrbands" //for LEVEL1
global list2 = "ilo_edu_isced11 ilo_edu_isced97 ilo_edu_aggregate" //for LEVEL2
do "$LIBMPDO\D.0 Rates 3 DRY.do"
********************************************************************************************


********************************************************************************************
*** E) Unemployment rate by sex and disability status **************************************
*** This indicator is calculated as: UNE_TUNE_NB / EAP_TEAP_NB * 100
global indicator   = "UNE_DEAP_SEX_DSB_RT"
global numerator   = "UNE_TUNE_SEX_DSB_NB"
global denominator = "EAP_TEAP_SEX_DSB_NB"
global list = "ilo_dsb_aggregate" //for LEVEL1
do "$LIBMPDO\D.0 Rates 1 DRY.do"
********************************************************************************************
