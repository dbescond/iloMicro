
/*This do-file calculates the indicators that have one level of aggregation, sex.

Structure:
- A. Calculations
- B. Drop estimates
- C. Transform values in thousands
- D. Save final template
*/


*** A. Calculations ***
*[Males and Females]
preserve
	gen sample_count=1 //This variable will helps us count the number of observations for each tabulation.
	collapse(sum) ilo_wgt sample_count if condition==1, by(ilo_time ilo_sex)
	rename ilo_wgt value
	rename ilo_time time

	//The next lines create the headers for the final template.
	gen indicator = "$indicator"
	gen country = "$country"
	gen source = "$source"

	//Here, we only keep the comulns needed for the final template.
	//NOTE: the variable "ilo_sex" will change at the end of the calculations to be consistent with the format of the final template.
	keep  country source indicator ilo_sex time value sample_count
	order country source indicator ilo_sex time value sample_count

	save ${country}_${source}_${time}_${indicator}_${LEVEL1}_MFgroups.dta, replace
restore

*[Both sexes, and merge with M/F]
preserve
	use ${country}_${source}_${time}_${indicator}_${LEVEL1}_MFgroups.dta, clear

	collapse(sum) value sample_count, by(country source indicator time)

	//Here, we assign a code for "both sexes".
	gen   ilo_sex = 3
	label define ilo_sex 3 "Both sexes", modify
	label values ilo_sex ilo_sex

	//We merge the same table for males and females which was calculated above.
	append using ${country}_${source}_${time}_${indicator}_${LEVEL1}_MFgroups.dta
	erase ${country}_${source}_${time}_${indicator}_${LEVEL1}_MFgroups.dta //we no longer need it
	sort country source indicator ilo_sex time

	//The next do-file changes the variable "ilo_sex" to be consistent with the column for "sex" of the final template.
	do "$LIBMPDO\X Labels for sex.do"


	*** B. Drop estimates ***
	//The estimates dropped are the ones based on sample observasions less than a threshold.
	//The threshold is defined in the first do-file "00 - Run Microdata Processing".
	replace value = . if sample_count<$MINCOUNTOBS	

	*** C. Transform values in thousands ***
	rename value value_orig
	gen value = value_orig/1000
	drop value_orig
	
	*** D. Save final template ***
	keep  country source indicator sex time value sample_count
	order country source indicator sex time value sample_count

	save ${country}_${source}_${time}_${indicator}.dta, replace
restore
