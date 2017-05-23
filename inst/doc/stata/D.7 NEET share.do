capture label drop _all
capture log close
capture clear all
set more off
set mem 500m

/*This do-file calculates the indicators:
A) Share of youth not in employment and not in education by sex:
*/

*Start: Open the dataset that is defined in the first do-file along with the the country name, year and source
use "$DATASET", clear

cd "$LIBMPOUT" //this changes the directory for this do-file to always be what it defines. The advantage is simply to avoid writing the directory when we save a dataset
*End


********************************************************************************************
*** A) Share of youth not in employment and not in education by sex ************************
*** This indicator is calculated as: EIP_NEET_NB / (POP_XWAP_NB AND AGE_AGGREGATE_Y15-24) * 100
global indicator   = "EIP_NEET_SEX_RT"
global numerator   = "EIP_NEET_SEX_NB"
global denominator = "POP_XWAP_SEX_AGE_NB"
global denominatorlevel = "ilo_age_aggregate"

capture confirm file ${country}_${source}_${time}_${numerator}.dta
if !_rc {
	capture confirm file ${country}_${source}_${time}_${denominator}_${denominatorlevel}.dta
	if !_rc {
		*** 1. Merge all numbers ***
		use          ${country}_${source}_${time}_${numerator}.dta, clear

		//this indicator only refers to ages 15-24
		gen classif1="AGE_AGGREGATE_Y15-24" //this will make the calculations below easier

		append using ${country}_${source}_${time}_${denominator}_${denominatorlevel}.dta
		
		drop if classif1!="AGE_AGGREGATE_Y15-24"
		
		*** 2. Create a variables (id) to facilitate with data manipulation during the calculations ***
		gen     groupid=1 if indicator=="$numerator"
		replace groupid=2 if indicator=="$denominator"
			
		//drop the variables that we do not need (sample_count) and the variable that we grouped above
		drop sample_count indicator
			
		*** 3. Calculations ***
		reshape wide value, i(country source sex classif1 time) j(groupid)
		gen value3 = (value1/value2)*100
		drop value1 value2
		reshape long value, i(country source sex classif1 time) j(groupid)
		gen indicator = "$indicator" if groupid==3
		drop groupid classif1

		order country source indicator sex time value
		
		*** 4. Save table ***
		save ${country}_${source}_${time}_${indicator}.dta, replace
	}
	else {
		di in red "The dataset: ${country}_${source}_${time}_${denominator} hasn't been calculated in Part A."
	}
}
else {
	di in red "The dataset: ${country}_${source}_${time}_${numerator} hasn't been calculated in Part A."
}
********************************************************************************************
