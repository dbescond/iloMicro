

*** This do-file is created because these lines are repeated.
*** This code refers to the ONE extra level tabulation cases for Workers in the informal economy.
*DRY stands for "Don't Repeat Yourself!" :)

capture confirm variable $LEVEL1 //Check if the variable exists
if !_rc {
	capture confirm variable ilo_lfs //Check if the variable ilo_lfs exists. This is used for the condition.
	if !_rc {
		capture confirm variable ilo_wap //Check if the variable ilo_wap exists. This is used for the condition.
		if !_rc {
			capture confirm variable ilo_job1_ife_prod //Check if the variable ilo_job1_ife_prod exists. This is used for the condition.
			if !_rc {
				capture confirm variable ilo_job1_ife_nature //Check if the variable ilo_job1_ife_prod exists. This is used for the condition.
				if !_rc {
					di in green "Variables $LEVEL1 & ilo_sex exist! Variables ilo_lfs, ilo_wap, ilo_job1_ife_nature & ilo_job1_ife_prod also exist (used for the condition)!"
					//The next "test" checks if the main variable is empty.
					egen TEST_No_Emptya=count($LEVEL1) if ilo_lfs==1 & ilo_wap==1 & ilo_job1_ife_prod==1 & ilo_job1_ife_nature==1
					egen TEST_No_Empty=mean(TEST_No_Emptya)
					if TEST_No_Empty!=0 {
						gen condition = 1 if ilo_lfs==1 & ilo_wap==1 & ilo_job1_ife_prod==1 & ilo_job1_ife_nature==1 & $LEVEL1!=. //The tabulations are calculated based on this condition.
						do "$LIBMPDO\C.0 Master for ONE extra level tabulation.do"
						drop condition
					}
					else {
						log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
						di in red "Variable $LEVEL1 is EMPTY for the observations that meet the condition."
						log close
					}
					drop TEST_No_Empty TEST_No_Emptya
				}
				else {
					log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
					di in red "Variable ilo_job1_ife_nature doesn't exist."
					log close
				}	
			}
			else {
				log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
				di in red "Variable ilo_job1_ife_prod doesn't exist."
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
	di in red "Variable $LEVEL1 doesn't exist."
	log close
}
