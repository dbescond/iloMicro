capture label drop _all
capture log close
capture clear all
set more off
set mem 500m

/*This do-file calculates the indicators:
A) Time-related underemployment rate by sex and age:
	A.1. AGE_AGGREGATE
	A.2. AGE_10YRBANDS
	A.3. AGE_5YRBANDS
*/

*Start: Open the dataset that is defined in the first do-file along with the the country name, year and source
use "$DATASET", clear

cd "$LIBMPOUT" //this changes the directory for this do-file to always be what it defines. The advantage is simply to avoid writing the directory when we save a dataset
*End


********************************************************************************************
*** A) Employment-to-population ratio by sex and age ***************************************
*** This indicator is calculated as: TRU_TTRU_NB / EMP_TEMP_NB * 100
global indicator   = "TRU_DEMP_SEX_AGE_RT"
global numerator   = "TRU_TTRU_SEX_AGE_NB"
global denominator = "EMP_TEMP_SEX_AGE_NB"
global list = "ilo_age_aggregate ilo_age_10yrbands" //for LEVEL1
do "$LIBMPDO\D.0 Rates 1 DRY.do"
********************************************************************************************
