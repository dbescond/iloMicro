capture label drop _all
capture log close
capture clear all
set more off
set mem 500m

/*This do-file calculates the indicators:
A) Employment-to-population ratio by sex and age:
	A.1. AGE_AGGREGATE
	A.2. AGE_10YRBANDS
	A.3. AGE_5YRBANDS

B) Employment-to-population ratio by sex and education:
	B.1. EDU_ISCED11
	B.1. EDU_ISCED97
	B.1. EDU_AGGREGATE
		
C) Employment-to-population ratio by sex, age and rural / urban areas:
	C.1. AGE_10YRBANDS, GEO_COV
	C.2. AGE_AGGREGATE, GEO_COV
*/

*Start: Open the dataset that is defined in the first do-file along with the the country name, year and source
use "$DATASET", clear

cd "$LIBMPOUT" //this changes the directory for this do-file to always be what it defines. The advantage is simply to avoid writing the directory when we save a dataset
*End


********************************************************************************************
*** A) Employment-to-population ratio by sex and age ***************************************
*** This indicator is calculated as: EMP_TEMP_NB / POP_XWAP_NB * 100
global indicator   = "EMP_DWAP_SEX_AGE_RT"
global numerator   = "EMP_TEMP_SEX_AGE_NB"
global denominator = "POP_XWAP_SEX_AGE_NB"
global list = "ilo_age_aggregate ilo_age_10yrbands ilo_age_5yrbands" //for LEVEL1
do "$LIBMPDO\D.0 Rates 1 DRY.do"
********************************************************************************************


********************************************************************************************
*** B) Employment-to-population ratio by sex and education *********************************
*** This indicator is calculated as: EMP_TEMP_NB / POP_XWAP_NB * 100
global indicator   = "EMP_DWAP_SEX_EDU_RT"
global numerator   = "EMP_TEMP_SEX_EDU_NB"
global denominator = "POP_XWAP_SEX_EDU_NB"
global list = "ilo_edu_isced11 ilo_edu_isced97 ilo_edu_aggregate" //for LEVEL1
do "$LIBMPDO\D.0 Rates 1 DRY.do"
********************************************************************************************


********************************************************************************************
*** C) Employment-to-population ratio by sex, age and rural / urban areas ******************
*** This indicator is calculated as: EMP_TEMP_NB / POP_XWAP_NB * 100
global indicator   = "EMP_DWAP_SEX_AGE_GEO_RT"
global numerator   = "EMP_TEMP_SEX_AGE_GEO_NB"
global denominator = "POP_XWAP_SEX_AGE_GEO_NB"
global list = "ilo_age_aggregate ilo_age_10yrbands" //for LEVEL1
global LEVEL2 = "ilo_geo"
do "$LIBMPDO\D.0 Rates 2 DRY.do"
********************************************************************************************
