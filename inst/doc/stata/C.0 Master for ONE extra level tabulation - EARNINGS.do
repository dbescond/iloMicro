
/*This do-file calculates the indicators that have one level of aggregation, sex.

Structure:
- A. Calculations
- B. Drop estimates
- C. Save final template
*/

/*
Note: some of the calculations need to be repeated, because we now calculate an average.*/

*** A. Calculations ***
*[Males and Females, BY $LEVEL1]
preserve
	gen sample_count=1 //This variable will helps us count the number of observations for each tabulation.
	gen total_earnings = ilo_wgt * ilo_joball_lri_ees
	collapse(sum) ilo_wgt sample_count total_earnings if condition==1, by(ilo_time ilo_sex $LEVEL1)
	gen value = total_earnings / ilo_wgt
	rename ilo_time time

	//The next lines create the headers for the final template.
	gen indicator = "$indicator"
	do "$LIBMPDO\X Classif1 for $LEVEL1.do"
	gen country = "$country"
	gen source = "$source"

	//Here, we only keep the comulns needed for the final template.
	//NOTE: the variable "ilo_sex" will change at the end of the calculations to be consistent with the format of the final template.
	keep  country source indicator ilo_sex classif1 time value sample_count
	order country source indicator ilo_sex classif1 time value sample_count

	save ${country}_${source}_${time}_${indicator}_${LEVEL1}_M_F_groups.dta, replace
restore

*[Males and Females, BY $classif1TOTAL]
preserve
	gen sample_count=1 //This variable will helps us count the number of observations for each tabulation.
	gen total_earnings = ilo_wgt * ilo_joball_lri_ees
	collapse(sum) ilo_wgt sample_count total_earnings if condition==1, by(ilo_time ilo_sex)
	gen value = total_earnings / ilo_wgt
	rename ilo_time time

	//The next lines create the headers for the final template.
	gen indicator = "$indicator"
	gen classif1 = "$classif1TOTAL" //We assign a name for the classif1 to be consistent with the final template.
	gen country = "$country"
	gen source = "$source"

	//Here, we only keep the comulns needed for the final template.
	//NOTE: the variable "ilo_sex" will change at the end of the calculations to be consistent with the format of the final template.
	keep  country source indicator ilo_sex classif1 time value sample_count
	order country source indicator ilo_sex classif1 time value sample_count

	save ${country}_${source}_${time}_${indicator}_${LEVEL1}_M_F_TOTAL.dta, replace
restore

*[Both sexes, BY $LEVEL1]
preserve
	gen sample_count=1 //This variable will helps us count the number of observations for each tabulation.
	gen total_earnings = ilo_wgt * ilo_joball_lri_ees
	collapse(sum) ilo_wgt sample_count total_earnings if condition==1, by(ilo_time $LEVEL1)
	gen value = total_earnings / ilo_wgt
	rename ilo_time time

	//Here, we assign a code for "both sexes".
	gen   ilo_sex = 3
	label define ilo_sex 3 "Both sexes", modify
	label values ilo_sex ilo_sex
	
	//The next lines create the headers for the final template.
	gen indicator = "$indicator"
	do "$LIBMPDO\X Classif1 for $LEVEL1.do"
	gen country = "$country"
	gen source = "$source"

	//Here, we only keep the comulns needed for the final template.
	//NOTE: the variable "ilo_sex" will change at the end of the calculations to be consistent with the format of the final template.
	keep  country source indicator ilo_sex classif1 time value sample_count
	order country source indicator ilo_sex classif1 time value sample_count

	save ${country}_${source}_${time}_${indicator}_${LEVEL1}_T_groups.dta, replace
restore

*[Both sexes, BY $classif1TOTAL]
preserve
	gen sample_count=1 //This variable will helps us count the number of observations for each tabulation.
	gen total_earnings = ilo_wgt * ilo_joball_lri_ees
	collapse(sum) ilo_wgt sample_count total_earnings if condition==1, by(ilo_time)
	gen value = total_earnings / ilo_wgt
	rename ilo_time time

	//Here, we assign a code for "both sexes".
	gen   ilo_sex = 3
	label define ilo_sex 3 "Both sexes", modify
	label values ilo_sex ilo_sex
	
	//The next lines create the headers for the final template.
	gen indicator = "$indicator"
	gen classif1 = "$classif1TOTAL" //We assign a name for the classif1 to be consistent with the final template.
	gen country = "$country"
	gen source = "$source"

	//Here, we only keep the comulns needed for the final template.
	//NOTE: the variable "ilo_sex" will change at the end of the calculations to be consistent with the format of the final template.
	keep  country source indicator ilo_sex classif1 time value sample_count
	order country source indicator ilo_sex classif1 time value sample_count

	save ${country}_${source}_${time}_${indicator}_${LEVEL1}_T_TOTAL.dta, replace
restore

*Merge previous calculations:
*[Males and Females, BY $LEVEL1]
*[Males and Females, BY $classif1TOTAL]
*[Both sexes, BY $LEVEL1]
*[Both sexes, BY $classif1TOTAL]
preserve
	use ${country}_${source}_${time}_${indicator}_${LEVEL1}_M_F_groups.dta, clear
	append using ${country}_${source}_${time}_${indicator}_${LEVEL1}_M_F_TOTAL.dta
	append using ${country}_${source}_${time}_${indicator}_${LEVEL1}_T_groups.dta
	append using ${country}_${source}_${time}_${indicator}_${LEVEL1}_T_TOTAL.dta
	sort country source indicator ilo_sex time
	
	//Erase the datasets used for this merge because we no longer need them anymore.
	erase ${country}_${source}_${time}_${indicator}_${LEVEL1}_M_F_groups.dta
	erase ${country}_${source}_${time}_${indicator}_${LEVEL1}_M_F_TOTAL.dta
	erase ${country}_${source}_${time}_${indicator}_${LEVEL1}_T_groups.dta
	erase ${country}_${source}_${time}_${indicator}_${LEVEL1}_T_TOTAL.dta
	
	//The next do-file changes the variable "ilo_sex" to be consistent with the column for "sex" of the final template.
	do "$LIBMPDO\X Labels for sex.do"


	*** B. Drop estimates ***
	//The estimates dropped are the ones based on sample observasions less than a threshold.
	//The threshold is defined in the first do-file "00 - Run Microdata Processing".
	replace value = . if sample_count<$MINCOUNTOBS	


	*** C. Save final template ***
	keep  country source indicator sex classif1 time value sample_count
	order country source indicator sex classif1 time value sample_count

	save ${country}_${source}_${time}_${indicator}_${LEVEL1}.dta, replace
restore
