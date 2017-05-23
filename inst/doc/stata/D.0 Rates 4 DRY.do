


*** This do-file is created because these lines are repeated.
*** This code refers to calculations for the indicator:
*** Unemployed plus discouraged job-seekers,
*** as a percent of the labour force plus discouraged job-seekers by sex and age (LEVEL1)
*DRY stands for "Don't Repeat Yourself!" :)

foreach level in $list {
	capture confirm file ${country}_${source}_${time}_${numerator}_`level'.dta
	if !_rc {
		capture confirm file ${country}_${source}_${time}_${denominator}_`level'.dta
		if !_rc {
			capture confirm file ${country}_${source}_${time}_${additional}_`level'.dta
			if !_rc {
				*** 1. Merge all numbers ***
				use          ${country}_${source}_${time}_${numerator}_`level'.dta, clear
				append using ${country}_${source}_${time}_${denominator}_`level'.dta
				append using ${country}_${source}_${time}_${additional}_`level'.dta
				
				*** 2. Create a variables (id) to facilitate with data manipulation during the calculations ***
				gen     groupid=1 if indicator=="$numerator"
				replace groupid=2 if indicator=="$denominator"
				replace groupid=3 if indicator=="$additional"
				
				//drop the variables that we do not need (sample_count) and the variable that we grouped above
				drop sample_count indicator
			
				*** 3. Calculations ***
				reshape wide value, i(country source sex classif1 time) j(groupid)
				gen value4 = ((value1+value3)/(value2+value3))*100
				drop value1 value2 value3
				reshape long value, i(country source sex classif1 time) j(groupid)
				gen indicator = "$indicator" if groupid==4
				drop groupid
			
				order country source indicator sex classif1 time value
			
				*** 4. Save table ***
				save ${country}_${source}_${time}_${indicator}_`level'.dta, replace
			}
			else {
				di in red "The dataset: ${country}_${source}_${time}_${additional}_`level' hasn't been calculated in Part A."
			}
		}
		else {
			di in red "The dataset: ${country}_${source}_${time}_${denominator}_`level' hasn't been calculated in Part A."
		}
	}
	else {
		di in red "The dataset: ${country}_${source}_${time}_${numerator}_`level' hasn't been calculated in Part A."
	}
}
