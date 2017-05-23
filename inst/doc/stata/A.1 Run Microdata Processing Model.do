capture label drop _all
capture log close
capture clear all
set more off
set mem 500m


/*
This do-file runs ALL the do-files in the folder "...\_ILOSTAT Microdata Processing\Do Files".
For the moment, it runs for the dataset defined in section 4,
and for the cut-off thresholds defined in section 3.

Contents:
- 1. Define root "TEM" directory
- 2. Definition of LIBRARIES (directories of do files, datasets, etc.)
- 3. Definition of THRESHOLDS
- 4. Definition of DATASET and METADATA file
- 5. Run Microdata Processing
	- 5.0 Check
	- 5.1 Tabulations
		- Part A: Numbers
		- Part B: Rates
	- 5.2 Final template
*/


****************************************************************************************************************
***** 1. Define root "TEM" directory ***************************************************************************
/* It defines ONCE FOR ALL, the ROOT directory where the main folder and all the subfolders are located. */
global MYMPFOLDER = "C:\TEM\_ILOSTAT Microdata Processing"
****************************************************************************************************************


****************************************************************************************************************
***** 2. Definition of LIBRARIES (directories of do files, datasets, etc.) *************************************
global LIBMPDO 	= "$MYMPFOLDER\\Do Files" /* Defines the library of DO-files. */
do "$LIBMPDO\A.2 Definition of LIBRARIES.do"
****************************************************************************************************************


****************************************************************************************************************
***** 3. Definition of THRESHOLDS *******************************************************************************
global MINCOUNTOBS = 5
/* The code will NOT produce any indicator if the number of the sample obs is below (<) $MINCOUNTOBS. */

global MINCOUNTOBSFLAG = 15
/* The code will produce a flag to indicate unreliability if the number of the sample obs is below (<) $MINCOUNTOBSFLAG. */

global INDCOMPLETENESS = 0.8
/* The code will flag the indicators/tables for which we miss more than [1-$INDCOMPLETENESS]
(e.g. 20%, when $INDCOMPLETENESS=0.8) of the possible values, due to droppings based on the sample count. */
****************************************************************************************************************


****************************************************************************************************************
***** 4. Definition of DATASET and METADATA file ***************************************************************
global DATASET = "$LIBMPIN\India\IND_NSS_2011_2012_ILO.dta"

/* For the variables "country", "time" and "source", please, avoid having spaces and/or symbols such as :, ;, etc. */
global country = "IND" /* This derives from "$METADATA" -> sheet 1 -> column "ilostat_code" -> row when column "var_name" = "ilo_country". */
global source  = "NSS" /* This derives from "$METADATA" -> sheet 1 -> column "code_label" -> row when column "var_name" = "ilo_source". */
global time    = "2011-12"

**The following datasets and variables are used in the do-file "E. Merge ALL.do"
global METADATA = "$LIBMPIN\India\IND_NSS_2011_2012_ILO_FWK.xlsx"
global source_code = "BX:2228" /* This derives from "$METADATA" -> sheet 1 -> column "ilostat_code" -> row when column "var_name" = "ilo_source". */
global collection_code = "YI" /* This is usually the default option, but please, check if this is true in your case. */

global FRAMEWORK = "$LIBMPIN\3_Framework.xlsx"
/* This file is provided by ILOSTAT. It needs to be updated if ILOSTAT updates it.
It is used in the do-file "$LIBMPDO\E. Notes - Indicator.do"*/
****************************************************************************************************************


****************************************************************************************************************
***** 5. Run Microdata Processing ******************************************************************************

*** 5.0 Check ***
/* Check if the variables "ilo_wgt" and "ilo_time" exist.
If they do not, then the code breaks! Because these variables are crucial for any tabulation. */
use "$DATASET", clear

capture confirm variable ilo_wgt
if !_rc {
	capture confirm variable ilo_time
	if !_rc {
		di "Hooray! Both variables: ilo_wgt and ilo_time exist!"
	}
	else {
		log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
		di in red "There is no ilo_time variable. No tabulation can be performed for the dataset $country, $source $time. The program will stop."
		log close
		break
	}
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "There is no ilo_wgt variable. No tabulation can be performed for the dataset: $country, $source $time. The program will stop."
	log close
	break
}

*** 5.1 Tabulations ***
*Part A: Numbers
do "$LIBMPDO\C.1 Working-age population.do"
do "$LIBMPDO\C.2 Labour force.do"
do "$LIBMPDO\C.3 Employment.do"
do "$LIBMPDO\C.3b Employees.do"
do "$LIBMPDO\C.4 Unemployment.do"
do "$LIBMPDO\C.4b Unemployed previously employed.do"
do "$LIBMPDO\C.5 Outside the labour force.do"
do "$LIBMPDO\C.6 Discouraged.do"
do "$LIBMPDO\C.7 NEET.do"
do "$LIBMPDO\C.8 Time-related underemployment.do"
do "$LIBMPDO\C.9 Informal economy.do"
do "$LIBMPDO\C.10 Working-hours.do"
do "$LIBMPDO\C.11 Monthly earnings.do"

*Part B: Rates
do "$LIBMPDO\D.1 Labour force participation rate.do"
do "$LIBMPDO\D.2 Inactivity rate.do"
do "$LIBMPDO\D.3 Employment-to-population ratio.do"
do "$LIBMPDO\D.4 Unemployment rate.do"
do "$LIBMPDO\D.5 Time-related underemployment rate.do"
do "$LIBMPDO\D.6 Unemployed plus discouraged job-seekers.do"
do "$LIBMPDO\D.7 NEET share.do"

*** 5.2 Final template ***
do "$LIBMPDO\E. Merge ALL.do"
/*Note#1: This do-file will get stuck in the case
when there is no table/indicator created with at least one classif1 and one classif2 case.*/

/*Note#2: This do-file, in part 2, imports data from Excel.
This feaure of STATA only works for versions of Stata v12.0 onwards.
The do-file will NOT work if the excel files are OPEN.
The excel files used are:
a) ...\_ILOSTAT Microdata Processing\Input Datasets\3_Framework.xlsx, and
b) e.g. ...\_ILOSTAT Microdata Processing\Input Datasets\Pakistan\PAK_LFS_2014-2015_ILO_FWK.xlsx
*Reminder: Those files are defined above in section 3 of the current do-file.
*/

* Add time variable (as it disappears while running the do-files)

use "$LIBMPFIN\Final_template_${country}_${source}_${time}.dta", clear

	tostring time, replace force
	
	replace time="${time}"
	
	save "$LIBMPFIN\Final_template_${country}_${source}_${time}.dta", replace

