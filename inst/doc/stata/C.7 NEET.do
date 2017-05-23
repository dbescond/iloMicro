capture label drop _all
capture log close
capture clear all
set more off
set mem 500m

/*This do-file calculates the indicators:
A) Youth not in education and not in employment by sex*/

*Start: Open the dataset that is defined in the first do-file along with the the country name, year and source
use "$DATASET", clear

cd "$LIBMPOUT" //this changes the directory for this do-file to always be what it defines. The advantage is simply to avoid writing the directory when we save a dataset
*End


********************************************************************************************
*** A) Youth not in education and not in employment by sex *********************************
capture confirm variable ilo_sex //Check if the variable ilo_sex exists
if !_rc {
	capture confirm variable ilo_lfs //Check if the variable ilo_lfs exists. This is used for the condition.
	if !_rc {
		capture confirm variable ilo_wap //Check if the variable ilo_wap exists. This is used for the condition.
		if !_rc {
			capture confirm variable ilo_neet //Check if the variable ilo_neet exists. This is used for the condition.
			if !_rc {
				di in green "Variable ilo_sex exist! Variables ilo_lfs, ilo_wap & ilo_neet also exist (used for the condition)!"
				//The next "test" checks if the condition excludes all observations (in which case, the next do-file will not be able to run).
				egen TEST_No_Emptya=count(ilo_sex) if ilo_lfs!=1 & ilo_wap==1 & ilo_neet==1
				egen TEST_No_Empty=mean(TEST_No_Emptya)
				if TEST_No_Empty!=0 & TEST_No_Empty!=. {
					global indicator = "EIP_NEET_SEX_NB"
					gen condition = 1 if ilo_lfs!=1 & ilo_wap==1 & ilo_neet==1 //The tabulations are calculated based on this condition.
					do "$LIBMPDO\C.0 Master for ZERO extra level tabulation.do"
					drop condition
				}
				else {
					log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
					di in red "The condition does not apply to any observation, hence if the condition is true, the dataset is EMPTY."
					log close
				}
				drop TEST_No_Empty TEST_No_Emptya
			}
			else {
				log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
				di in red "Variable ilo_neet doesn't exist."
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
	di in red "Variable ilo_sex doesn't exist."
	log close
}
********************************************************************************************
