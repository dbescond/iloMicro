capture label drop _all
capture log close
capture clear all
set more off
set mem 500m

/*This do-file calculates the indicators:
A) Unemployed plus discouraged job-seekers,
as a percent of the labour force plus discouraged job-seekers by sex and age:
	A.1. AGE_AGGREGATE
	A.2. AGE_10YRBANDS
	A.3. AGE_5YRBANDS
*/

*Start: Open the dataset that is defined in the first do-file along with the the country name, year and source
use "$DATASET", clear

cd "$LIBMPOUT" //this changes the directory for this do-file to always be what it defines. The advantage is simply to avoid writing the directory when we save a dataset
*End


********************************************************************************************
*** A) Unemployed plus discouraged job-seekers, ********************************************
*** as a percent of the labour force plus discouraged job-seekers by sex and age ***********
*** This indicator is calculated as: (UNE_TUNE_NB + EIP_WDIS_NB) / (EAP_TEAP_NB + EIP_WDIS_NB) * 100
global indicator    = "EIP_WDIS_SEX_AGE_RT"
global numerator1   = "UNE_TUNE_SEX_AGE_NB"
global denominator1 = "EAP_TEAP_SEX_AGE_NB"
global additional   = "EIP_WDIS_SEX_AGE_NB"
global list = "ilo_age_aggregate ilo_age_10yrbands ilo_age_5yrbands" //for LEVEL1
do "$LIBMPDO\D.0 Rates 4 DRY.do"
********************************************************************************************
