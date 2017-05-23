


*** This do-file is created because these lines are repeated.
*** This code refers to calculations for Rates, e.g. (LF/POP)*100,
*** with only LEVEL1.
*DRY stands for "Don't Repeat Yourself!" :)

foreach level in $list {
	capture confirm file ${country}_${source}_${time}_${numerator}_`level'.dta
	if !_rc {
		capture confirm file ${country}_${source}_${time}_${denominator}_`level'.dta
		if !_rc {
			*** 1. Merge all numbers ***
			use          ${country}_${source}_${time}_${numerator}_`level'.dta, clear
			append using ${country}_${source}_${time}_${denominator}_`level'.dta
			
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
			drop groupid
			
			order country source indicator sex classif1 time value
			
			*** 4. Save table ***
			save ${country}_${source}_${time}_${indicator}_`level'.dta, replace
		}
		else {
			di in red "The dataset: ${country}_${source}_${time}_${denominator}_`level' hasn't been calculated in Part A."
		}
	}
	else {
		di in red "The dataset: ${country}_${source}_${time}_${numerator}_`level' hasn't been calculated in Part A."
	}
}
