


*** This do-file is created because these lines are repeated.
*** This code refers to calculations for Rates, e.g. (LF/POP)*100,
*** with LEVEL1 & LEVEL2, but only LEVEL1 has more than one category.
*DRY stands for "Don't Repeat Yourself!" :)

foreach level1 in $list {
	capture confirm file ${country}_${source}_${time}_${numerator}_`level1'_$LEVEL2.dta
	if !_rc {
		capture confirm file ${country}_${source}_${time}_${denominator}_`level1'_$LEVEL2.dta
		if !_rc {
			*** 1. Merge all numbers ***
			use          ${country}_${source}_${time}_${numerator}_`level1'_$LEVEL2.dta, clear
			append using ${country}_${source}_${time}_${denominator}_`level1'_$LEVEL2.dta
			
			*** 2. Create a variables (id) to facilitate with data manipulation during the calculations ***
			gen     groupid=1 if indicator=="$numerator"
			replace groupid=2 if indicator=="$denominator"
			
			//drop the variables that we do not need (sample_count) and the variable that we grouped above
			drop sample_count indicator
			
			*** 3. Calculations ***
			reshape wide value, i(country source sex classif1 classif2 time) j(groupid)
			gen value3 = (value1/value2)*100
			drop value1 value2
			reshape long value, i(country source sex classif1 classif2 time) j(groupid)
			gen indicator = "$indicator" if groupid==3
			drop groupid
			
			order country source indicator sex classif1 classif2 time value
			
			*** 4. Save table ***
			save ${country}_${source}_${time}_${indicator}_`level1'_$LEVEL2.dta, replace
		}
		else {
			di in red "The dataset: ${country}_${source}_${time}_${denominator}_`level1'_$LEVEL2 hasn't been calculated in Part A."
		}
	}
	else {
		di in red "The dataset: ${country}_${source}_${time}_${numerator}_`level1'_$LEVEL2 hasn't been calculated in Part A."
	}
}
