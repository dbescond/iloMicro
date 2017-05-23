capture label drop _all
capture log close
capture clear all
set more off
set mem 500m

/*** This do-file...:
	 1)  merges all the indicators found in the sheet "Mapping_template" of the file "3_Framework" that are available (i.e. have been created in the other do-files)
	 2a) creates metadata and columns' headers format/edit
	 2b) creates metadata for notes
	 3) saves the final template that excludes the indicators/tables with insufficient reliable data
	 4)  drops the extra files in the "Output datasets" folder. ***/
cd "$LIBMPOUT" //this changes the directory for this do-file to always be what it defines. The advantage is simply to avoid writing the directory when we save a dataset


************************************************************************************************
*** 1) MERGE ***********************************************************************************
//The following dataset is used in order to start the procedure for merging all the tables.
//It only has one empty raw which is dropped later.
use "$LIBMPIN\EMPTY DATASET TO INITIATE MERGE.dta", clear

foreach indicator in POP_XWAP_SEX_AGE_NB POP_XWAP_SEX_AGE_EDU_NB POP_XWAP_SEX_AGE_GEO_NB POP_XWAP_SEX_DSB_NB EAP_TEAP_SEX_AGE_NB EAP_TEAP_SEX_AGE_EDU_NB EAP_TEAP_SEX_AGE_GEO_NB EAP_TEAP_SEX_DSB_NB EMP_TEMP_SEX_AGE_NB EMP_TEMP_SEX_AGE_EDU_NB EMP_TEMP_SEX_AGE_GEO_NB EMP_TEMP_SEX_DSB_NB EMP_TEMP_SEX_AGE_JOB_NB EMP_TEMP_SEX_STE_NB EMP_TEMP_SEX_INS_NB EMP_TEMP_SEX_ECO_NB EMP_TEMP_SEX_ECO2_NB EMP_TEMP_SEX_OCU_NB EMP_TEMP_SEX_OCU2_NB EMP_TEMP_SEX_HOW_NB EMP_TEMP_ECO_OCU_NB TRU_TTRU_SEX_AGE_NB EES_TEES_SEX_INS_NB EES_TEES_SEX_ECO_NB EES_TEES_SEX_ECO2_NB EES_TEES_SEX_OCU_NB EES_TEES_SEX_OCU2_NB EES_TEES_SEX_HOW_NB EES_TEES_ECO_OCU_NB UNE_TUNE_SEX_AGE_NB UNE_TUNE_SEX_DSB_NB UNE_TUNE_SEX_AGE_EDU_NB UNE_TUNE_SEX_AGE_GEO_NB UNE_TUNE_SEX_AGE_DUR_NB UNE_TUNE_SEX_ECO_NB UNE_TUNE_SEX_OCU_NB UNE_TUNE_SEX_CAT_NB EIP_TEIP_SEX_AGE_GEO_NB EIP_WDIS_SEX_AGE_NB EIP_NEET_SEX_NB HOW_TEMP_SEX_ECO_NB HOW_TEMP_SEX_OCU_NB HOW_UEMP_SEX_NB HOW_XEES_SEX_ECO_NB HOW_XEES_SEX_OCU_NB HOW_UEES_SEX_NB EAR_XEES_SEX_ECO_NB EAR_XEES_SEX_OCU_NB IFL_IECN_SEX_ECO_NB EAP_DWAP_SEX_AGE_RT EMP_DWAP_SEX_AGE_RT TRU_DEMP_SEX_AGE_RT UNE_DEAP_SEX_AGE_RT UNE_DEAP_SEX_DSB_RT IFL_IECN_SEX_ECO_RT UNE_DEAP_SEX_AGE_EDU_RT UNE_DEAP_SEX_AGE_GEO_RT {
	*********************************************************
	*** A. This part checks/merges the indicators by SEX. ***
	capture confirm file ${country}_${source}_${time}_`indicator'.dta
	if !_rc {
		append using ${country}_${source}_${time}_`indicator'.dta
		erase ${country}_${source}_${time}_`indicator'.dta //to save space
	}
	*********************************************************
	
	foreach level1 in ilo_age_10yrbands ilo_age_5yrbands ilo_age_aggregate ilo_cat_une ilo_dsb_aggregate ilo_dur_aggregate ilo_dur_details ilo_edu_aggregate ilo_edu_isced11 ilo_edu_isced97 ilo_geo ilo_job1_eco_aggregate ilo_job1_eco_isic3 ilo_job1_eco_isic3_2digits ilo_job1_eco_isic4 ilo_job1_eco_isic4_2digits ilo_job1_how_actual ilo_job1_how_actual_bands ilo_job1_how_usual ilo_job1_ins_sector ilo_job1_job_time ilo_job1_ocu_aggregate ilo_job1_ocu_isco08 ilo_job1_ocu_isco08_2digits ilo_job1_ocu_isco88 ilo_job1_ocu_isco88_2digits ilo_job1_ste_aggregate ilo_job1_ste_icse93 ilo_joball_how_actual ilo_joball_how_actual_bands ilo_joball_how_usual ilo_neet ilo_olf_dlma ilo_preveco_aggregate ilo_preveco_isic3 ilo_preveco_isic4 ilo_prevocu_aggregate ilo_prevocu_isco08 ilo_prevocu_isco88 {
		********************************************************************
		*** B. This part checks/merges the indicators by SEX and LEVEL1. ***
		capture confirm file ${country}_${source}_${time}_`indicator'_`level1'.dta
		if !_rc {
			append using ${country}_${source}_${time}_`indicator'_`level1'.dta
			erase ${country}_${source}_${time}_`indicator'_`level1'.dta //to save space
		}
		********************************************************************
		
		foreach level2 in ilo_age_10yrbands ilo_age_5yrbands ilo_age_aggregate ilo_cat_une ilo_dsb_aggregate ilo_dur_aggregate ilo_dur_details ilo_edu_aggregate ilo_edu_isced11 ilo_edu_isced97 ilo_geo ilo_job1_eco_aggregate ilo_job1_eco_isic3 ilo_job1_eco_isic3_2digits ilo_job1_eco_isic4 ilo_job1_eco_isic4_2digits ilo_job1_how_actual ilo_job1_how_actual_bands ilo_job1_how_usual ilo_job1_ins_sector ilo_job1_job_time ilo_job1_ocu_aggregate ilo_job1_ocu_isco08 ilo_job1_ocu_isco08_2digits ilo_job1_ocu_isco88 ilo_job1_ocu_isco88_2digits ilo_job1_ste_aggregate ilo_job1_ste_icse93 ilo_joball_how_actual ilo_joball_how_actual_bands ilo_joball_how_usual ilo_neet ilo_olf_dlma ilo_preveco_aggregate ilo_preveco_isic3 ilo_preveco_isic4 ilo_prevocu_aggregate ilo_prevocu_isco08 ilo_prevocu_isco88 {
			****************************************************************************
			*** C. This part checks/merges the indicators by SEX, LEVEL1 and LEVEL2. ***
			capture confirm file ${country}_${source}_${time}_`indicator'_`level1'_`level2'.dta
			if !_rc {
				append using ${country}_${source}_${time}_`indicator'_`level1'_`level2'.dta
				erase ${country}_${source}_${time}_`indicator'_`level1'_`level2'.dta //to save space
			}
			****************************************************************************
		}
		
	}
	
}

//Drop the first raw because this is the empty raw that the "$LIBMPIN\EMPTY DATASET TO INITIATE MERGE.dta" has to facilitate the merge.
drop in 1

label variable sample_count `"# of obs in the sample"' //Add label for clarity
************************************************************************************************


************************************************************************************************
*** 2a) METADATA and columns' headers format/edit **********************************************
//Based on the decisions from the meeting on 18th of July.

*** ref_area ***
rename country ref_area

*** source ***
drop source
gen source = "$source_code" //Defined in do-file "A.1 Run Microdata Processing Model".

*** collection ***
gen collection = "$collection_code" //Defined in do-file "A.1 Run Microdata Processing Model".

*** obs_value ***
rename value obs_value

*** obs_status ***
gen     obs_status = ""
replace obs_status = "U" if sample_count<$MINCOUNTOBSFLAG
//"u" = unreliable
//Reminder: the above global parameter are defined in "A.1 Run Microdata Processing Model".

order collection ref_area source indicator sex classif1 classif2 time obs_value obs_status

*** table_test and ind_drop ***
//This part creates a variable to flag the indicators/tables: table_test
//for when we miss more than (1-$INDCOMPLETENESS) of the possible values.
//One reason for missing part of an indicator/table is due to droppings due to low sample_count.
//Reminder: the above global parameter is defined in "A.1 Run Microdata Processing Model".

/*The next two lines simply split the classification columns
to help calculate the ratio of reliability for table_test correctly.*/
split classif1, parse(_)
split classif2, parse(_)

/*We do not need to check for existence the variables (classif11, classif12, classif21, classif22),
because it is less likely that any dataset will not have at least two variables that are part of classif1 and classif2.*/
egen ind_reliable = count(obs_value), by(time indicator classif11 classif12 classif21 classif22)
egen ind_total    = count(time)     , by(time indicator classif11 classif12 classif21 classif22)

gen table_test = ind_reliable / ind_total //This gives us the share of the table/indicator that is available because it exists and has a reliable value.
label variable table_test `"Share of reliable records available per indicator/table"'

gen ind_drop = 1 if table_test<$INDCOMPLETENESS //This is simply a flag. The actual droping of the table happens at a later stage.
replace ind_drop = 0 if ind_drop!=1
la def ind_drop 1 "TRUE -> Drop table" 0 "FALSE -> Keep table"
la val ind_drop ind_drop
label variable ind_drop `"Delete indicator/table [1=Yes]"'

//Drop the variables that we do not need anymore.
drop ind_reliable ind_total
drop classif11 classif12 classif21 classif22
/*We need the checks below, because for example the variable classif14 would not exist
in cases the tables with classif1 such as "ECO_ISIC4_R_93" have not been created
due to lack of data or lack of the necessary variables.*/
capture confirm variable classif14
if !_rc {
	drop classif14
}
capture confirm variable classif13
if !_rc {
	drop classif13
}
capture confirm variable classif23
if !_rc {
	drop classif23
}

sort collection ref_area source time indicator classif1 classif2 sex
************************************************************************************************


************************************************************************************************
*** 2b) Metadata for NOTES *********************************************************************

*** note_source ***
capture confirm file "$METADATA"
if !_rc {
	preserve
		//This do-file prepares the note for the column "note_source".
		//Attention: This do-file imports data from Excel. It will NOT work if the excel is OPEN.
		//This feaure of STATA only works for versions of Stata v12.0 onwards.
		do "$LIBMPDO\E. Notes - Source.do"
	restore
	mmerge ref_area using "$LIBMPOUT\\${country}_note_source.dta", ukeep(note_source)
	erase "$LIBMPOUT\\${country}_note_source.dta"
	drop _merge
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "The file $METADATA does not exist."
	log close
}

*** note_indicator ***
capture confirm file "$METADATA"
if !_rc {
	preserve
		//This do-file prepares the note for the column "note_indicator".
		//Attention: This do-file imports data from Excel. It will NOT work if the excel is OPEN.
		//This feaure of STATA only works for versions of Stata v12.0 onwards.
		do "$LIBMPDO\E. Notes - Indicator.do"
	restore
	mmerge ref_area indicator using "$LIBMPOUT\\${country}_note_indicator.dta", ukeep(note_indicator)
	erase "$LIBMPOUT\\${country}_note_indicator.dta"
	drop if _merge==2
	drop _merge
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "The file $METADATA does not exist."
	log close
}

*** note_classif ***
capture confirm file "$METADATA"
if !_rc {
	preserve
		//This do-file prepares the note for the column "note_classif".
		//Attention: This do-file imports data from Excel. It will NOT work if the excel is OPEN.
		//This feaure of STATA only works for versions of Stata v12.0 onwards.
		do "$LIBMPDO\E. Notes - Classif.do"
	restore
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "The file $METADATA does not exist."
	log close
}

*Case 1: SEX
capture confirm file "$LIBMPOUT\\${country}_note_classif.dta"
if !_rc {
	gen note_classif_sex=""
	gen ilostat_code = sex
	mmerge ilostat_code using "$LIBMPOUT\\${country}_note_classif.dta"
	drop if _merge==2
	replace note_classif_sex = ilostat_note_code
	drop ilostat_note_code ilostat_code _merge
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "The file $LIBMPOUT\\${country}_note_classif.dta was not created."
	log close
}

*Case 2: classif1
capture confirm file "$LIBMPOUT\\${country}_note_classif.dta"
if !_rc {
	gen note_classif_classif1=""
	gen ilostat_code = classif1
	mmerge ilostat_code using "$LIBMPOUT\\${country}_note_classif.dta"
	drop if _merge==2
	replace note_classif_classif1 = ilostat_note_code
	drop ilostat_note_code ilostat_code _merge
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "The file $LIBMPOUT\\${country}_note_classif.dta was not created."
	log close
}

*Case 3: classif2
capture confirm file "$LIBMPOUT\\${country}_note_classif.dta"
if !_rc {
	gen note_classif_classif2=""
	gen ilostat_code = classif2
	mmerge ilostat_code using "$LIBMPOUT\\${country}_note_classif.dta"
	drop if _merge==2
	replace note_classif_classif2 = ilostat_note_code
	drop ilostat_note_code ilostat_code _merge
}
else {
	log using "$LIBMPLOGS\LOG_for_${country}_${source}_${time}.smcl", append
	di in red "The file $LIBMPOUT\\${country}_note_classif.dta was not created."
	log close
}

gen note_classif = ""
capture confirm variable note_classif_sex
if !_rc {
	replace note_classif = note_classif_sex
	drop note_classif_sex
}
capture confirm variable note_classif_classif1
if !_rc {
	replace note_classif = note_classif + "_" + note_classif_classif1 if note_classif!="" & note_classif_classif1!=""
	replace note_classif = note_classif_classif1 if note_classif=="" & note_classif_classif1!=""
	drop note_classif_classif1
}
capture confirm variable note_classif_classif2
if !_rc {
	replace note_classif = note_classif + "_" + note_classif_classif2 if note_classif!="" & note_classif_classif2!=""
	replace note_classif = note_classif_classif2 if note_classif=="" & note_classif_classif2!=""
	drop note_classif_classif2
}

capture confirm file "$LIBMPOUT\\${country}_note_classif.dta"
if !_rc {
	erase "$LIBMPOUT\\${country}_note_classif.dta"
}

sort collection ref_area source time indicator classif1 classif2 sex

save "$LIBMPFINNODROP\Final_template_${country}_${source}_${time}_before_IND_drop.dta", replace
************************************************************************************************


************************************************************************************************
*** 3) FINAL template **************************************************************************
use "$LIBMPFINNODROP\Final_template_${country}_${source}_${time}_before_IND_drop.dta", clear

*** Drop tables/indicators ***
drop if ind_drop==1

*** Drop columns that are not part of the final template ***
capture confirm variable ind_drop
if !_rc {
	drop ind_drop
}
capture confirm variable sample_count
if !_rc {
	drop sample_count
}
capture confirm variable table_test
if !_rc {
	drop table_test
}

order collection ref_area source indicator sex classif1 classif2 time obs_value obs_status note_classif note_indicator note_source

save "$LIBMPFIN\Final_template_${country}_${source}_${time}.dta", replace
************************************************************************************************


************************************************************************************************
*** 4) Drop extras *****************************************************************************
*** The remainder datasets in the "Output datasets" folders are extras. Hence we drop them here.
*** Such as the datasets produced in order to calculate some rates.
foreach indicator in POP_XWAP_SEX_EDU_NB EAP_TEAP_SEX_EDU_NB EAP_DWAP_SEX_EDU_RT EAP_DWAP_SEX_AGE_GEO_RT EMP_TEMP_SEX_EDU_NB EMP_DWAP_SEX_EDU_RT EMP_DWAP_SEX_AGE_GEO_RT UNE_TUNE_SEX_EDU_NB EIP_TEIP_SEX_EIP_NB EIP_TEIP_SEX_AGE_EIP_NB EIP_TEIP_SEX_AGE_NB EIP_WDIS_SEX_AGE_RT TRU_TTRU_SEX_ECO_NB EIP_NEET_SEX_RT UNE_DEAP_SEX_EDU_RT EIP_DWAP_SEX_AGE_RT {
	*********************************************************
	*** A. This part checks/merges the indicators by SEX. ***
	capture confirm file ${country}_${source}_${time}_`indicator'.dta
	if !_rc {
		erase ${country}_${source}_${time}_`indicator'.dta
	}
	*********************************************************
	
	foreach level1 in ilo_age_10yrbands ilo_age_5yrbands ilo_age_aggregate ilo_cat_une ilo_dsb_aggregate ilo_dur_aggregate ilo_dur_details ilo_edu_aggregate ilo_edu_isced11 ilo_edu_isced97 ilo_geo ilo_job1_eco_aggregate ilo_job1_eco_isic3 ilo_job1_eco_isic3_2digits ilo_job1_eco_isic4 ilo_job1_eco_isic4_2digits ilo_job1_how_actual ilo_job1_how_actual_bands ilo_job1_how_usual ilo_job1_ins_sector ilo_job1_job_time ilo_job1_ocu_aggregate ilo_job1_ocu_isco08 ilo_job1_ocu_isco08_2digits ilo_job1_ocu_isco88 ilo_job1_ocu_isco88_2digits ilo_job1_ste_aggregate ilo_job1_ste_icse93 ilo_joball_how_actual ilo_joball_how_actual_bands ilo_joball_how_usual ilo_neet ilo_olf_dlma ilo_preveco_aggregate ilo_preveco_isic3 ilo_preveco_isic4 ilo_prevocu_aggregate ilo_prevocu_isco08 ilo_prevocu_isco88 {
		********************************************************************
		*** B. This part checks/merges the indicators by SEX and LEVEL1. ***
		capture confirm file ${country}_${source}_${time}_`indicator'_`level1'.dta
		if !_rc {
			erase ${country}_${source}_${time}_`indicator'_`level1'.dta
		}
		********************************************************************
		
		foreach level2 in ilo_age_10yrbands ilo_age_5yrbands ilo_age_aggregate ilo_cat_une ilo_dsb_aggregate ilo_dur_aggregate ilo_dur_details ilo_edu_aggregate ilo_edu_isced11 ilo_edu_isced97 ilo_geo ilo_job1_eco_aggregate ilo_job1_eco_isic3 ilo_job1_eco_isic3_2digits ilo_job1_eco_isic4 ilo_job1_eco_isic4_2digits ilo_job1_how_actual ilo_job1_how_actual_bands ilo_job1_how_usual ilo_job1_ins_sector ilo_job1_job_time ilo_job1_ocu_aggregate ilo_job1_ocu_isco08 ilo_job1_ocu_isco08_2digits ilo_job1_ocu_isco88 ilo_job1_ocu_isco88_2digits ilo_job1_ste_aggregate ilo_job1_ste_icse93 ilo_joball_how_actual ilo_joball_how_actual_bands ilo_joball_how_usual ilo_neet ilo_olf_dlma ilo_preveco_aggregate ilo_preveco_isic3 ilo_preveco_isic4 ilo_prevocu_aggregate ilo_prevocu_isco08 ilo_prevocu_isco88 {
			****************************************************************************
			*** C. This part checks/merges the indicators by SEX, LEVEL1 and LEVEL2. ***
			capture confirm file ${country}_${source}_${time}_`indicator'_`level1'_`level2'.dta
			if !_rc {
				erase ${country}_${source}_${time}_`indicator'_`level1'_`level2'.dta
			}
			****************************************************************************
		}
		
	}
	
}
************************************************************************************************
