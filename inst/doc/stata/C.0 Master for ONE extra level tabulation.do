
/*This do-file calculates the indicators that have two levels of aggregation:
sex and ONE extra level, e.g. age

Structure:
- A. Calculations
- B. Drop estimates
- C. Transform values in thousands
- D. Save final template
*/


*** A. Calculations ***
*[Males and Females, BY $LEVEL1]
preserve
	gen sample_count=1 //This variable will helps us count the number of observations for each tabulation.
	collapse(sum) ilo_wgt sample_count if condition==1, by(ilo_time ilo_sex $LEVEL1)
	rename ilo_wgt value
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

	save ${country}_${source}_${time}_${indicator}_${LEVEL1}_MFgroups.dta, replace
restore

*[Both sexes, Males and Females, BY $LEVEL1]
preserve
	use ${country}_${source}_${time}_${indicator}_${LEVEL1}_MFgroups.dta, clear

	collapse(sum) value sample_count, by(country source indicator classif1 time)

	//Here, we assign a code for "both sexes".
	gen   ilo_sex = 3
	label define ilo_sex 3 "Both sexes", modify
	label values ilo_sex ilo_sex

	//We merge the same table for males and females which was calculated above.
	append using ${country}_${source}_${time}_${indicator}_${LEVEL1}_MFgroups.dta
	erase ${country}_${source}_${time}_${indicator}_${LEVEL1}_MFgroups.dta //we no longer need it

	save ${country}_${source}_${time}_${indicator}_${LEVEL1}_groups.dta, replace
restore

*[Both sexes, Males and Females, BY $classif1TOTAL]
preserve
	use ${country}_${source}_${time}_${indicator}_${LEVEL1}_groups.dta, clear

	collapse(sum) value sample_count, by(country source indicator time ilo_sex)

	//We assign a name for the classif1 to be consistent with the final template.
	gen classif1 = "$classif1TOTAL"
	order country source indicator ilo_sex classif1 time value sample_count

	*Merge previous calculations to have:
	*(a) [Both sexes, Males and Females, BY $classif1]
	*(b) [Both sexes, Males and Females, BY $classif1TOTAL]
	append using ${country}_${source}_${time}_${indicator}_${LEVEL1}_groups.dta

	//Erase the dataset used for this merge because we no longer need it anymore.
	erase ${country}_${source}_${time}_${indicator}_${LEVEL1}_groups.dta
	sort country source indicator ilo_sex time classif1

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
	keep  country source indicator sex classif1 time value sample_count
	order country source indicator sex classif1 time value sample_count

	save ${country}_${source}_${time}_${indicator}_${LEVEL1}.dta, replace
restore
