

*** This do-file is created because these lines are repeated.
*** This code refers to the TWO extra levels tabulation cases for Employees.
*DRY stands for "Don't Repeat Yourself!" :)

capture confirm variable $LEVEL1 //Check if the variable exists
if !_rc {
	capture confirm variable $LEVEL2 //Check if the variable exists
	if !_rc {
		capture confirm variable ilo_lfs //Check if the variable ilo_lfs exists. This is used for the condition.
		if !_rc {
			capture confirm variable ilo_wap //Check if the variable ilo_wap exists. This is used for the condition.
			if !_rc {
				capture confirm variable ilo_job1_ste_aggregate //Check if the variable ilo_job1_ste_aggregate exists. This is used for the condition.
				if !_rc {
					di in green "Variables $LEVEL1 & $LEVEL2 exist! Variables ilo_lfs, ilo_wap & ilo_job1_ste_aggregate also exist (used for the condition)!"
					//The next "test" checks if the main variables are empty.
					egen TEST_No_Empty1a=count($LEVEL1) if ilo_lfs==1 & ilo_wap==1 & ilo_job1_ste_aggregate==1
					egen TEST_No_Empty1=mean(TEST_No_Empty1a)
					egen TEST_No_Empty2a=count($LEVEL2) if ilo_lfs==1 & ilo_wap==1 & ilo_job1_ste_aggregate==1
					egen TEST_No_Empty2=mean(TEST_No_Empty2a)
					if TEST_No_Empty1!=0 & TEST_No_Empty2!=0 {
						gen condition = 1 if ilo_lfs==1 & ilo_wap==1 & ilo_job1_ste_aggregate==1 & $LEVEL2!=.
						do "$LIBMPDO\C.0 Master for TWO levels tabulation.do"
						drop condition
					}
					else {
						log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
						di in red "Variables $LEVEL1 and/or $LEVEL2 are EMPTY for the observations that meet the condition."
						log close
					}
					drop TEST_No_Empty1 TEST_No_Empty2 TEST_No_Empty1a TEST_No_Empty2a
				}
				else {
					log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
					di in red "Variable ilo_job1_ste_aggregate doesn't exist."
					log close
				}
			}
			else {
				log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
				di in red "Variable ilo_wap doesn't exist."
				log close
			}
		}
		else {
			log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
			di in red "Variable ilo_lfs doesn't exist."
			log close
		}	
	}
	else {
		log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
		di in red "Variable $LEVEL2 doesn't exist."
		log close
	}
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "Variable $LEVEL1 doesn't exist."
	log close
}
