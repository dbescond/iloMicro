
/*This do-file calculates the indicators that have two levels of aggregation, NOT by sex.

Structure:
- A. Calculations
- B. Drop estimates
- C. Transform values in thousands
- D. Save final template
*/

*** A. Calculations ***
*[BY $LEVEL1 and $LEVEL2]
preserve
	gen sample_count=1 //This variable will helps us count the number of observations for each tabulation.
	collapse(sum) ilo_wgt sample_count if condition==1, by(ilo_time $LEVEL1 $LEVEL2)
	rename ilo_wgt value
	rename ilo_time time
	
	//The next lines create the headers for the final template.
	gen indicator = "$indicator"
	do "$LIBMPDO\X Classif1 for $LEVEL1.do"
	do "$LIBMPDO\X Classif2 for $LEVEL2.do"
	gen country = "$country"
	gen source = "$source"

	//Here, we only keep the comulns needed for the final template.
	keep  country source indicator classif1 classif2 time value sample_count
	order country source indicator classif1 classif2 time value sample_count

	save ${country}_${source}_${time}_${indicator}_${LEVEL1}_${LEVEL2}_groups.dta, replace
restore

*[BY $classif1TOTAL and $LEVEL2]
preserve
	use ${country}_${source}_${time}_${indicator}_${LEVEL1}_${LEVEL2}_groups.dta, clear

	collapse(sum) value sample_count, by(country source indicator classif2 time)

	//We assign a name for the classif1 to be consistent with the final template.
	gen classif1 = "$classif1TOTAL"
	order country source indicator classif1 classif2 time value sample_count
	sort  country source indicator classif1 classif2 time

	save ${country}_${source}_${time}_${indicator}_${LEVEL1}_${LEVEL2}_groupsTOTAL1.dta, replace
restore

*[BY $LEVEL1 and $classif2TOTAL]
preserve
	use ${country}_${source}_${time}_${indicator}_${LEVEL1}_${LEVEL2}_groups.dta, clear

	collapse(sum) value sample_count, by(country source indicator classif1 time)

	//We assign a name for the classif2 to be consistent with the final template.
	gen classif2 = "$classif2TOTAL"
	order country source indicator classif1 classif2 time value sample_count
	sort  country source indicator classif1 classif2 time

	save ${country}_${source}_${time}_${indicator}_${LEVEL1}_${LEVEL2}_groupsTOTAL2.dta, replace
restore

*[BY $classif1TOTAL and $classif2TOTAL]
preserve
	use ${country}_${source}_${time}_${indicator}_${LEVEL1}_${LEVEL2}_groups.dta, clear

	collapse(sum) value sample_count, by(country source indicator time)

	//We assign a name for the classif1 and classif2 to be consistent with the final template.
	gen classif1 = "$classif1TOTAL"
	gen classif2 = "$classif2TOTAL"
	order country source indicator classif1 classif2 time value sample_count
	sort  country source indicator classif1 classif2 time

	save ${country}_${source}_${time}_${indicator}_${LEVEL1}_${LEVEL2}_groupsTOTAL1TOTAL2.dta, replace
restore

*Merge the calculations for:
*(a) [BY $LEVEL1 and $LEVEL2]
*(b) [BY $classif1TOTAL and $LEVEL2]
*(c) [BY $LEVEL1 and $classif2TOTAL]
*(d) [BY $classif1TOTAL and $classif2TOTAL]
preserve
	use ${country}_${source}_${time}_${indicator}_${LEVEL1}_${LEVEL2}_groups.dta, clear
	append using ${country}_${source}_${time}_${indicator}_${LEVEL1}_${LEVEL2}_groupsTOTAL1.dta
	append using ${country}_${source}_${time}_${indicator}_${LEVEL1}_${LEVEL2}_groupsTOTAL2.dta
	append using ${country}_${source}_${time}_${indicator}_${LEVEL1}_${LEVEL2}_groupsTOTAL1TOTAL2.dta

	//Erase the datasets used for this merge because we do not need them anymore.
	erase ${country}_${source}_${time}_${indicator}_${LEVEL1}_${LEVEL2}_groups.dta
	erase ${country}_${source}_${time}_${indicator}_${LEVEL1}_${LEVEL2}_groupsTOTAL1.dta
	erase ${country}_${source}_${time}_${indicator}_${LEVEL1}_${LEVEL2}_groupsTOTAL2.dta
	erase ${country}_${source}_${time}_${indicator}_${LEVEL1}_${LEVEL2}_groupsTOTAL1TOTAL2.dta

	sort country source indicator time classif1 classif2

	*** B. Drop estimates ***
	//The estimates dropped are the ones based on sample observasions less than a threshold.
	//The threshold is defined in the first do-file "00 - Run Microdata Processing".
	replace value = . if sample_count<$MINCOUNTOBS	

	*** C. Transform values in thousands ***
	rename value value_orig
	gen value = value_orig/1000
	drop value_orig
				
	*** D. Save final template ***
	keep  country source indicator classif1 classif2 time value sample_count
	order country source indicator classif1 classif2 time value sample_count

	save ${country}_${source}_${time}_${indicator}_${LEVEL1}_${LEVEL2}.dta, replace
restore
