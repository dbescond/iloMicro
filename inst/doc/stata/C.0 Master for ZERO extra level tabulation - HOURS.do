
/*This do-file calculates the indicators that have one level of aggregation, sex.

Structure:
- A. Calculations
- B. Drop estimates
- C. Save final template
*/

/*
Note: some of the calculations need to be repeated, because we now calculate an average.*/

*** A. Calculations ***
*[Males and Females]
preserve
	gen sample_count=1 //This variable will helps us count the number of observations for each tabulation.
	gen total_hours = ilo_wgt * $hours
	collapse(sum) ilo_wgt sample_count total_hours if condition==1, by(ilo_time ilo_sex)
	gen value = total_hours / ilo_wgt
	rename ilo_time time

	//The next lines create the headers for the final template.
	gen indicator = "$indicator"
	gen country = "$country"
	gen source = "$source"

	//Here, we only keep the comulns needed for the final template.
	//NOTE: the variable "ilo_sex" will change at the end of the calculations to be consistent with the format of the final template.
	keep  country source indicator ilo_sex time value sample_count
	order country source indicator ilo_sex time value sample_count

	save ${country}_${source}_${time}_${indicator}_${LEVEL1}_M_F.dta, replace
restore

*[Both sexes, and merge with M/F]
preserve
	gen sample_count=1 //This variable will helps us count the number of observations for each tabulation.
	gen total_hours = ilo_wgt * $hours
	collapse(sum) ilo_wgt sample_count total_hours if condition==1, by(ilo_time)
	gen value = total_hours / ilo_wgt
	rename ilo_time time
	
	//Here, we assign a code for "both sexes".
	gen   ilo_sex = 3
	label define ilo_sex 3 "Both sexes", modify
	label values ilo_sex ilo_sex
	
	//The next lines create the headers for the final template.
	gen indicator = "$indicator"
	gen country = "$country"
	gen source = "$source"

	//Here, we only keep the comulns needed for the final template.
	//NOTE: the variable "ilo_sex" will change at the end of the calculations to be consistent with the format of the final template.
	keep  country source indicator ilo_sex time value sample_count
	order country source indicator ilo_sex time value sample_count

	//We merge the same table for males and females which was calculated above.
	append using ${country}_${source}_${time}_${indicator}_${LEVEL1}_M_F.dta
	erase ${country}_${source}_${time}_${indicator}_${LEVEL1}_M_F.dta //we no longer need it
	sort country source indicator ilo_sex time

	//The next do-file changes the variable "ilo_sex" to be consistent with the column for "sex" of the final template.
	do "$LIBMPDO\X Labels for sex.do"


	*** B. Drop estimates ***
	//The estimates dropped are the ones based on sample observasions less than a threshold.
	//The threshold is defined in the first do-file "00 - Run Microdata Processing".
	replace value = . if sample_count<$MINCOUNTOBS	


	*** C. Save final template ***
	keep  country source indicator sex time value sample_count
	order country source indicator sex time value sample_count

	save ${country}_${source}_${time}_${indicator}.dta, replace
restore
