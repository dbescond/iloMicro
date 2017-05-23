

*** This do-file is created because these lines are repeated.
*** This code refers to the ONE extra level tabulation cases for Monthly earnings.
*DRY stands for "Don't Repeat Yourself!" :)

capture confirm variable ilo_joball_lri_ees //Check if the variable ilo_joball_lri_ees exists.
if !_rc {
	capture confirm variable $LEVEL1 //Check if the variable $LEVEL1 exists.
	if !_rc {
		capture confirm variable ilo_lfs //Check if the variable ilo_lfs exists. This is used for the condition.
		if !_rc {	
			capture confirm variable ilo_wap //Check if the variable ilo_wap exists. This is used for the condition.
			if !_rc {
				capture confirm variable ilo_job1_ste_aggregate //Check if the variable ilo_job1_ste_aggregate exists. This is used for the condition.
				if !_rc {
					di in green "Variables ilo_joball_lri_ees, $LEVEL1 & ilo_sex exist! Variables ilo_lfs, ilo_job1_ste_aggregate & ilo_wap also exist (used for the condition)!"
					//The next "test" checks if the main variable is empty.
					egen TEST_No_EmptyEARa=count(ilo_joball_lri_ees) if ilo_lfs==1 & ilo_wap==1 & ilo_job1_ste_aggregate==1
					egen TEST_No_EmptyEAR=mean(TEST_No_EmptyEARa)
					egen TEST_No_Empty1a=count($LEVEL1) if ilo_lfs==1 & ilo_wap==1 & ilo_job1_ste_aggregate==1
					egen TEST_No_Empty1=mean(TEST_No_Empty1a)
					if TEST_No_EmptyEAR!=0 & TEST_No_Empty1!=0 & TEST_No_EmptyEAR!=. & TEST_No_Empty1!=. {
						gen condition = 1 if ilo_lfs==1 & ilo_wap==1 & ilo_job1_ste_aggregate==1 //The tabulations are calculated based on this condition.
						do "$LIBMPDO\C.0 Master for ONE extra level tabulation - EARNINGS.do"
						drop condition
					}
					else {
						log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
						di in red "Variables ilo_joball_lri_ees and/or $LEVEL1 is EMPTY for the observations that meet the condition."
						log close
					}
					drop TEST_No_EmptyEAR TEST_No_EmptyEARa TEST_No_Empty1 TEST_No_Empty1a
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
		di in red "Variable $LEVEL1 doesn't exist."
		log close
	}
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "Variable ilo_joball_lri_ees doesn't exist."
	log close
}
