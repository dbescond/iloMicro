* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Egypt
* DATASET USED: Egypt LFSS
* NOTES: 
* Files created: Standard variables on LFS Egypt
* Authors: DPAU
* Who last updated the file: 
* Starting Date: 14 August 2017
* Last updated: 14 August 2017
***********************************************************************************************


*******************************************************************
 /* 1.	Set up work directory, file name, variables and function */
*******************************************************************

clear all 

set more off

global path "J:\COMMON\STATISTICS\DPAU\MICRO"
global country "EGY"
global source "LFS"
global time "2016"
global inputFile "LFS 2016.dta"

global inpath "${path}\\${country}\\${source}\\${time}\ORI"
global temppath "${path}\_Admin"
global outpath "${path}\\${country}\\${source}\\${time}"

************************************************************************************

* Important : if package « labutil » not already installed, install it in order to execute correctly the do-file

	* ssc install labutil

************************************************************************************
* Make a tempfile containing the labels for the classifications ISIC and ISCO 

		* NOTE: if you want this do-file to run correctly, run it without breaks!
		
cd "$temppath"
		
	tempfile labels
		
			* Import Framework
			import excel 3_Framework.xlsx, sheet("Variable") firstrow

			* Keep only the variable names, the codes and the labels associated to the codes
			keep var_name code_level code_label

			* Select only variables associated to isic and isco
			keep if (substr(var_name,1,12)=="ilo_job1_ocu" | substr(var_name,1,12)=="ilo_job1_eco") & substr(var_name,14,.)!="aggregate"

			* Destring codes
			destring code_level, replace

			* Reshape
				
				foreach classif in var_name {
				
					replace var_name=substr(var_name,14,.) if var_name==`classif'
					
					}
				
				reshape wide code_label, i(code_level) j(var_name) string
				
				foreach var of newlist isco08_2digits isco88_2digits isco08 isco88 isic4_2digits isic4 ///
							isic3_2digits isic3 {
							
							gen `var'=code_level
							
							replace `var'=. if code_label`var'==""
							
							labmask `var' , val(code_label`var')
							
							}				
				
				drop code_label* code_level
							
			* Save file (as tempfile)
			
			save "`labels'"
			
*********************************************************************************************

* Load original dataset

*********************************************************************************************

cd "$inpath"

	use "${inputFile}", clear	
	
	rename *, lower
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

*			2. MAP VARIABLES

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------


* ---------------------------------------------------------------------------------------------
***********************************************************************************************
*			PART 1. DATASET SETTINGS VARIABLES
***********************************************************************************************
* ---------------------------------------------------------------------------------------------

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Identifier ('ilo_key')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_key=_n 
		lab var ilo_key "Key unique identifier per individual"	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sample Weight ('ilo_wgt')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	
	gen ilo_wgt=original
		lab var ilo_wgt "Sample weight"	
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time period ('ilo_time')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_time=1
		lab def time_lab 1 "${time}"
		lab val ilo_time time_lab
		lab var ilo_time "Time (Gregorian Calendar)"

* ---------------------------------------------------------------------------------------------
***********************************************************************************************
*			PART 2. SOCIAL CHARACTERISTICS
***********************************************************************************************
* ---------------------------------------------------------------------------------------------

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Geographical coverage ('ilo_geo')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: 

		gen ilo_geo=urb
				lab def geo_lab 1 "1 - Urban" 2 "2 - Rural" 3 "3 - Not elsewhere classified"
				lab val ilo_geo geo_lab
				lab var ilo_geo "Geographical coverage"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

		gen ilo_sex=gender
			label define label_Sex 1 "1 - Male" 2 "2 - Female"
			label values ilo_sex label_Sex 
			lab var ilo_sex "Sex"
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment:

		gen ilo_age=age
			lab var ilo_age "Age"

		* Age groups

		gen ilo_age_5yrbands=.
			replace ilo_age_5yrbands=1 if inrange(ilo_age,0,4)
			replace ilo_age_5yrbands=2 if inrange(ilo_age,5,9)
			replace ilo_age_5yrbands=3 if inrange(ilo_age,10,14)
			replace ilo_age_5yrbands=4 if inrange(ilo_age,15,19)
			replace ilo_age_5yrbands=5 if inrange(ilo_age,20,24)
			replace ilo_age_5yrbands=6 if inrange(ilo_age,25,29)
			replace ilo_age_5yrbands=7 if inrange(ilo_age,30,34)
			replace ilo_age_5yrbands=8 if inrange(ilo_age,35,39)
			replace ilo_age_5yrbands=9 if inrange(ilo_age,40,44)
			replace ilo_age_5yrbands=10 if inrange(ilo_age,45,49)
			replace ilo_age_5yrbands=11 if inrange(ilo_age,50,54)
			replace ilo_age_5yrbands=12 if inrange(ilo_age,55,59)
			replace ilo_age_5yrbands=13 if inrange(ilo_age,60,64)
			replace ilo_age_5yrbands=14 if ilo_age>=65 
				lab def age_by5_lab 1 "0-4" 2 "5-9" 3 "10-14" 4 "15-19" 5 "20-24" 6 "25-29" 7 "30-34" 8 "35-39" 9 "40-44" 10 "45-49" 11 "50-54" 12 "55-59" 13 "60-64" 14 "65+"
				lab val ilo_age_5yrbands age_by5_lab
				lab var ilo_age_5yrbands "Age (5-year age bands)"
				
		gen ilo_age_10yrbands=.
			replace ilo_age_10yrbands=1 if inrange(ilo_age,0,15)
			replace ilo_age_10yrbands=2 if inrange(ilo_age,15,24)
			replace ilo_age_10yrbands=3 if inrange(ilo_age,25,34)
			replace ilo_age_10yrbands=4 if inrange(ilo_age,35,44)
			replace ilo_age_10yrbands=5 if inrange(ilo_age,45,54)
			replace ilo_age_10yrbands=6 if inrange(ilo_age,55,64)
			replace ilo_age_10yrbands=7 if ilo_age>=65
				lab def age_by10_lab 1 "<15" 2 "15-24" 3 "25-34" 4 "35-44" 5 "45-54" 6 "55-64" 7 "65+"
				lab val ilo_age_10yrbands age_by10_lab
				lab var ilo_age_10yrbands "Age (10-year age bands)"
				
		gen ilo_age_aggregate=.
			replace ilo_age_aggregate=1 if inrange(ilo_age,0,15)
			replace ilo_age_aggregate=2 if inrange(ilo_age,15,24)
			replace ilo_age_aggregate=3 if inrange(ilo_age,25,54)
			replace ilo_age_aggregate=4 if inrange(ilo_age,55,64)
			replace ilo_age_aggregate=5 if ilo_age>=65 
				lab def age_aggr_lab 1 "<15" 2 "15-24" 3 "25-54" 4 "55-64" 5 "65+"
				lab val ilo_age_aggregate age_aggr_lab
				lab var ilo_age_aggregate "Age (Aggregate)"

			* As only age bands being kept drop "ilo_age" at the very end -> Use it in between as help variable.

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Level of education ('ilo_edu')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: 

	gen ilo_edu_isced97=.
		replace ilo_edu_isced97=1 if education_state==1 | education_situation==1 
		/* replace ilo_edu_isced97=2 if */
		replace ilo_edu_isced97=3 if education_state==2
		replace ilo_edu_isced97=4 if education_state==3
		replace ilo_edu_isced97=5 if inlist(education_state,4,5,6,7)
		replace ilo_edu_isced97=6 if education_state==8
		replace ilo_edu_isced97=7 if education_state==9
		replace ilo_edu_isced97=8 if education_state==10
		replace ilo_edu_isced97=9 if ilo_edu_isced97==.
			label def isced_97_lab 1 "X - No schooling" 2 "0 - Pre-primary education" 3 "1 - Primary education or first stage of basic education" 4 "2 - Lower secondary education or second stage of basic education" ///
							5 "3 - Upper secondary education" 6 "4 - Post-secondary non-tertiary education" 7 "5 - First stage of tertiary education (not leading directly to an advanced research qualification)" ///
							8 "6 - Second stage of tertiary education (leading to an advanced research qualification)" 9 "UNK - Level not stated"
			label val ilo_edu_isced97 isced_97_lab
			lab var ilo_edu_isced97 "Level of education (ISCED 97)"


		* for the definition, cf. the document "Guide to reporting labour statistics to the ILO using the Excel questionnaire"
		
	gen ilo_edu_aggregate=.
		replace ilo_edu_aggregate=1 if inlist(ilo_edu_isced97,1,2)
		replace ilo_edu_aggregate=2 if inlist(ilo_edu_isced97,3,4)
		replace ilo_edu_aggregate=3 if inlist(ilo_edu_isced97,5,6)
		replace ilo_edu_aggregate=4 if inlist(ilo_edu_isced97,7,8)
		replace ilo_edu_aggregate=5 if ilo_edu_isced97==9
			label def edu_aggr_lab 1 "1 - Less than basic" 2 "2 - Basic" 3 "3 - Intermediate" 4 "4 - Advanced" 5 "5 - Level not stated"
			label val ilo_edu_aggregate edu_aggr_lab
			label var ilo_edu_aggregate "Level of education (Aggregate levels)"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education attendance ('ilo_edu_attendance')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

		gen ilo_edu_attendance=.
			replace ilo_edu_attendance=1 if education_situation==4
			replace ilo_edu_attendance=2 if inlist(education_situation,1,2,3,5)
			replace ilo_edu_attendance=3 if ilo_edu_attendance==.
				lab def edu_attendance_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
				lab val ilo_edu_attendance edu_attendance_lab
				lab var ilo_edu_attendance "Education (Attendance)"	
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Disability status ('ilo_dsb_details') [no info]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment:				
	
	gen ilo_dsb_details=.
		replace ilo_dsb_details=1 if disability==2
		replace ilo_dsb_details=2 if disability_degree==1
		replace ilo_dsb_details=3 if disability_degree==2
		replace ilo_dsb_details=4 if disability_degree==3
			* force missing values into first category
				replace ilo_dsb_details=1 if ilo_dsb_details==. 
			label define ilo_dsb_details_label 1 "No, no difficulty" 2 "Yes, some difficulty" 3 "Yes, a lot of difficulty" 4 "Cannot do it at all"
			label values ilo_dsb_details ilo_dsb_details_label
			label var ilo_dsb_details "Disability status (Details)"
				
	gen ilo_dsb_aggregate=.
		replace ilo_dsb_aggregate=1 if inlist(ilo_dsb_details,1,2)
		replace ilo_dsb_aggregate=2 if inlist(ilo_dsb_details,3,4)
			label def dsb_aggregate_lab 1 "Persons without disability" 2 "Persons with disability"
			label val ilo_dsb_aggregate dsb_aggregate_lab
			label var ilo_dsb_aggregate "Disability status (Aggregate)"
	

* ---------------------------------------------------------------------------------------------
***********************************************************************************************
*			PART 3. ECONOMIC SITUATION
***********************************************************************************************
* ---------------------------------------------------------------------------------------------		
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working age population ('ilo_wap')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
        
* Comment: 	

	gen ilo_wap=.
		replace ilo_wap=1 if (ilo_age>=15 & ilo_age!=.)
		replace ilo_wap=0 if ilo_age<15
			label def ilo_wap_lab 1 "Working age population"
			label val ilo_wap ilo_wap_lab
			label var ilo_wap "Working age population"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Labour Force Status ('ilo_lfs')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
     	 
* Comment: 	Note that the section for identifying people in unemployment has a first filter question, asking about the willingness the work. Whoever answers "no" to 
			* this question is not asked about the availability or about any job seeking activity

		gen job_ref_week=.

	foreach var of varlist work_for_sale_* {
	
		replace job_ref_week=1 if `var'==1 
		
			}
			
		gen seek_job=. 
		
	foreach var of varlist search_work_* {
	
		destring `var', replace
	
		replace seek_job=1 if `var'==1
		
		}


	gen ilo_lfs=.
		replace ilo_lfs=1 if work_last_week==1 | work_releated==1 | job_ref_week==1
		replace ilo_lfs=2 if ilo_lfs!=1 & want_work==1 & ready_work==1 & seek_job==1
		replace ilo_lfs=3 if !inlist(ilo_lfs,1,2) 
			replace ilo_lfs=. if ilo_wap!=1	
				label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status" 

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: 
/*

	no info
			
*/
***********************************************************************************************
*			PART 3.1. ECONOMIC CHARACTERISTICS FOR MAIN JOB 
***********************************************************************************************		

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Status in employment ('ilo_ste')
* -------------------------------------------------------------------------------------------
* ------------------------------------------------------------------------------------------- 

* Comment: Include option "Contributors in work/business" among contributing family workers

	* Primary activity
	
		gen ilo_job1_ste_icse93=.
			replace ilo_job1_ste_icse93=1 if work_relationship_state==1
			replace ilo_job1_ste_icse93=2 if work_relationship_state==2
			replace ilo_job1_ste_icse93=3 if work_relationship_state==3
			/* replace ilo_job1_ste_icse93=4 if */
			replace ilo_job1_ste_icse93=5 if inlist(work_relationship_state,4,5)
			replace ilo_job1_ste_icse93=6 if ilo_job1_ste_icse93==. & ilo_lfs==1
			replace ilo_job1_ste_icse93=. if ilo_lfs!=1			
				label define label_ilo_ste_icse93 1 "1 - Employees" 2 "2 - Employers" 3 "3 - Own-account workers" 4 "4 - Members of producers' cooperatives" 5 "5 - Contributing family workers" ///
												6 "6 - Workers not classifiable by status"
				label val ilo_job1_ste_icse93 label_ilo_ste_icse93
				label var ilo_job1_ste_icse93 "Status in employment (ICSE 93)"

	* Aggregate categories
	
		gen ilo_job1_ste_aggregate=.
			replace ilo_job1_ste_aggregate=1 if ilo_job1_ste_icse93==1
			replace ilo_job1_ste_aggregate=2 if inlist(ilo_job1_ste_icse93,2,3,4)
			replace ilo_job1_ste_aggregate=3 if inlist(ilo_job1_ste_icse93,5,6)
				lab def ste_aggr_lab 1 "1 - Employees" 2 "2 - Self-employed" 3 "3 - Not elsewhere classified"
				lab val ilo_job1_ste_aggregate ste_aggr_lab
				label var ilo_job1_ste_aggregate "Status in employment (Aggregate)" 

	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: 

	destring activity, replace
	
	gen indu_code_prim=int(activity/10000) if ilo_lfs==1 & activity!=0

		* Import value labels

		append using `labels', gen (lab)
					
		* Two-digit level
		
		gen ilo_job1_eco_isic4_2digits=indu_code_prim
		
				lab values ilo_job1_eco_isic4 isic4_2digits
				lab var ilo_job1_eco_isic4_2digits "Economic activity (ISIC Rev. 4), 2 digit level"
		
		* One digit level
	
		* Technical documentation on ISIC Rev. 4:  http://unstats.un.org/unsd/publication/seriesM/seriesm_4rev4e.pdf 
		
		* Primary activity
		
		gen ilo_job1_eco_isic4=.
			replace ilo_job1_eco_isic4=1 if inrange(ilo_job1_eco_isic4_2digits,1,3)
			replace ilo_job1_eco_isic4=2 if inrange(ilo_job1_eco_isic4_2digits,5,9)
			replace ilo_job1_eco_isic4=3 if inrange(ilo_job1_eco_isic4_2digits,10,33)
			replace ilo_job1_eco_isic4=4 if ilo_job1_eco_isic4_2digits==35
			replace ilo_job1_eco_isic4=5 if inrange(ilo_job1_eco_isic4_2digits,36,39)
			replace ilo_job1_eco_isic4=6 if inrange(ilo_job1_eco_isic4_2digits,41,43)
			replace ilo_job1_eco_isic4=7 if inrange(ilo_job1_eco_isic4_2digits,45,47)
			replace ilo_job1_eco_isic4=8 if inrange(ilo_job1_eco_isic4_2digits,49,53)
			replace ilo_job1_eco_isic4=9 if inrange(ilo_job1_eco_isic4_2digits,55,56)
			replace ilo_job1_eco_isic4=10 if inrange(ilo_job1_eco_isic4_2digits,58,63)
			replace ilo_job1_eco_isic4=11 if inrange(ilo_job1_eco_isic4_2digits,64,66)
			replace ilo_job1_eco_isic4=12 if ilo_job1_eco_isic4_2digits==68
			replace ilo_job1_eco_isic4=13 if inrange(ilo_job1_eco_isic4_2digits,69,75)
			replace ilo_job1_eco_isic4=14 if inrange(ilo_job1_eco_isic4_2digits,77,82)
			replace ilo_job1_eco_isic4=15 if ilo_job1_eco_isic4_2digits==84
			replace ilo_job1_eco_isic4=16 if ilo_job1_eco_isic4_2digits==85
			replace ilo_job1_eco_isic4=17 if inrange(ilo_job1_eco_isic4_2digits,86,88)
			replace ilo_job1_eco_isic4=18 if inrange(ilo_job1_eco_isic4_2digits,90,93)
			replace ilo_job1_eco_isic4=19 if inrange(ilo_job1_eco_isic4_2digits,94,96)
			replace ilo_job1_eco_isic4=20 if inrange(ilo_job1_eco_isic4_2digits,97,98)
			replace ilo_job1_eco_isic4=21 if ilo_job1_eco_isic4_2digits==99
			replace ilo_job1_eco_isic4=22 if ilo_job1_eco_isic4_2digits==. & ilo_lfs==1 
			replace ilo_job1_eco_isic4=. if ilo_lfs!=1
				lab val ilo_job1_eco_isic4 isic4
				lab var ilo_job1_eco_isic4 "Economic activity (ISIC Rev. 4)"

		* Classification at an aggregated level
	
		* Primary activity
		
		gen ilo_job1_eco_aggregate=.
			replace ilo_job1_eco_aggregate=1 if ilo_job1_eco_isic4==1
			replace ilo_job1_eco_aggregate=2 if ilo_job1_eco_isic4==3
			replace ilo_job1_eco_aggregate=3 if ilo_job1_eco_isic4==6
			replace ilo_job1_eco_aggregate=4 if inlist(ilo_job1_eco_isic4,2,4,5)
			replace ilo_job1_eco_aggregate=5 if inrange(ilo_job1_eco_isic4,7,14)
			replace ilo_job1_eco_aggregate=6 if inrange(ilo_job1_eco_isic4,15,21)
			replace ilo_job1_eco_aggregate=7 if ilo_job1_eco_isic4==22
				lab def eco_aggr_lab 1 "1 - Agriculture" 2 "2 - Manufacturing" 3 "3 - Construction" 4 "4 - Mining and quarrying; Electricity, gas and water supply" ///
									5 "5 - Market Services (Trade; Transportation; Accommodation and food; and Business and administrative services)"  ///
									6 "6 - Non-market services (Public administration; Community, social and other services and activities)" 7 "7 - Not classifiable by economic activity"					
				lab val ilo_job1_eco_aggregate eco_aggr_lab
				lab var ilo_job1_eco_aggregate "Economic activity (Aggregate)"

				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_ocu')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment:  ISCO-08 classification used

	* Two-digits level
	
		destring job,replace
		gen occ_code_prim=int(job/10000) if ilo_lfs==1 & job!=0
	
		* Primary occupation
	
		gen ilo_job1_ocu_isco08_2digits=occ_code_prim
			lab values ilo_job1_ocu_isco08_2digits isco08_2digits
			lab var ilo_job1_ocu_isco08_2digits "Occupation (ISCO-08), 2 digit level"

		* One digit level
	
		gen occ_code_prim_1dig=int(occ_code_prim/10) 
	
		* Primary activity
		
		gen ilo_job1_ocu_isco08=occ_code_prim_1dig
			replace ilo_job1_ocu_isco08=10 if ilo_job1_ocu_isco08==0
			replace ilo_job1_ocu_isco08=11 if ilo_job1_ocu_isco08==. & ilo_lfs==1
			replace ilo_job1_ocu_isco08=. if ilo_lfs!=1
				lab def isco08_1dig_lab 1 "1 - Managers" 2 "2 - Professionals" 3 "3 - Technicians and associate professionals" 4 "4 - Clerical support workers" 5 "5 - Service and sales workers" ///
									6 "6 - Skilled agricultural, forestry and fishery workers" 7 "7 - Craft and related trades workers" 8 "8 - Plant and machine operators, and assemblers" ///
									9 "9 - Elementary occupations" 10 "0 - Armed forces occupations" 11 "X - Not elsewhere classified"
				lab val ilo_job1_ocu_isco08 isco08_1dig_lab
				lab var ilo_job1_ocu_isco08 "Occupation (ISCO-08)"
			
		* Aggregate level
	
		* Primary occupation
	
		gen ilo_job1_ocu_aggregate=.
			replace ilo_job1_ocu_aggregate=1 if inrange(ilo_job1_ocu_isco08,1,3)
			replace ilo_job1_ocu_aggregate=2 if inlist(ilo_job1_ocu_isco08,4,5)
			replace ilo_job1_ocu_aggregate=3 if inlist(ilo_job1_ocu_isco08,6,7)
			replace ilo_job1_ocu_aggregate=4 if ilo_job1_ocu_isco08==8
			replace ilo_job1_ocu_aggregate=5 if ilo_job1_ocu_isco08==9
			replace ilo_job1_ocu_aggregate=6 if ilo_job1_ocu_isco08==10
			replace ilo_job1_ocu_aggregate=7 if ilo_job1_ocu_isco08==11
				lab def ocu_aggr_lab 1 "1 - Managers, professionals, and technicians" 2 "2 - Clerical, service and sales workers" 3 "3 - Skilled agricultural and trades workers" ///
									4 "4 - Plant and machine operators, and assemblers" 5 "5 - Elementary occupations" 6 "6 - Armed forces" 7 "7 - Not elsewhere classified"
				lab val ilo_job1_ocu_aggregate ocu_aggr_lab
				lab var ilo_job1_ocu_aggregate "Occupation (Aggregate)"
				
		* Skill level
	
		* Primary occupation
	
		gen ilo_job1_ocu_skill=.
			replace ilo_job1_ocu_skill=1 if ilo_job1_ocu_isco08==9
			replace ilo_job1_ocu_skill=2 if inlist(ilo_job1_ocu_isco08,4,5,6,7,8)
			replace ilo_job1_ocu_skill=3 if inlist(ilo_job1_ocu_isco08,1,2,3)
			replace ilo_job1_ocu_skill=4 if inlist(ilo_job1_ocu_isco08,10,11)
				lab def ocu_skill_lab 1 "1 - Skill level 1 (low)" 2 "2 - Skill level 2 (medium)" 3 "3 - Skill levels 3 and 4 (high)" 4 "4 - Not elsewhere classified"
				lab val ilo_job1_ocu_skill ocu_skill_lab
				lab var ilo_job1_ocu_skill "Occupation (Skill level)"

	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_ins_sector')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
		
* Comment: 

	* Primary occupation
	
		gen ilo_job1_ins_sector=.
			replace ilo_job1_ins_sector=1 if inlist(sector,1,2)
			replace ilo_job1_ins_sector=2 if ilo_job1_ins_sector!=1 & ilo_lfs==1
			replace ilo_job1_ins_sector=. if ilo_lfs!=1
				lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
				lab values ilo_job1_ins_sector ins_sector_lab
				lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities"	

* --------------------------------------------------------------------------------------------------
* --------------------------------------------------------------------------------------------------
*		Weekly hours actually worked ('ilo_how_actual') and usually worked ('ilo_how_usual')
* --------------------------------------------------------------------------------------------------
* --------------------------------------------------------------------------------------------------

* Comment: 

	* Actual hours worked
		
		* Primary job
		
		gen ilo_job1_how_actual=last_week_hours
			replace ilo_job1_how_actual=. if ilo_lfs!=1
				lab var ilo_job1_how_actual "Weekly hours actually worked in main job"
			
	
	* Weekly hours actually worked --> Bands 
			
		* Main job
		
		gen ilo_job1_how_actual_bands=.
			replace ilo_job1_how_actual_bands=1 if ilo_job1_how_actual==0
			replace ilo_job1_how_actual_bands=2 if ilo_job1_how_actual>=1 & ilo_job1_how_actual<=14
			replace ilo_job1_how_actual_bands=3 if ilo_job1_how_actual>=15 & ilo_job1_how_actual<=29
			replace ilo_job1_how_actual_bands=4 if ilo_job1_how_actual>=30 & ilo_job1_how_actual<=34
			replace ilo_job1_how_actual_bands=5 if ilo_job1_how_actual>=35 & ilo_job1_how_actual<=39
			replace ilo_job1_how_actual_bands=6 if ilo_job1_how_actual>=40 & ilo_job1_how_actual<=48
			replace ilo_job1_how_actual_bands=7 if ilo_job1_how_actual>=49 & ilo_job1_how_actual!=.
			replace ilo_job1_how_actual_bands=8 if ilo_lfs==1 & ilo_job1_how_actual_bands==.
				lab def how_bands_lab 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"
				lab values ilo_job1_how_actual_bands how_bands_lab
				lab var ilo_job1_how_actual_bands "Weekly hours actually worked bands in main job"
		
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job_time')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment: 40 hours per week is the legal working-time
			* use actual hours as usual hours are not available
			* use working hours for main job, as total hours unavailable
	
		gen ilo_job1_job_time=.
			replace ilo_job1_job_time=1 if inlist(ilo_job1_how_actual_bands,1,2,3,4,5)
			replace ilo_job1_job_time=2 if inlist(ilo_job1_how_actual_bands,6,7)
			replace ilo_job1_job_time=3 if ilo_job1_job_time==. & ilo_lfs==1
			replace ilo_job1_job_time=. if ilo_lfs!=1
				lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
				lab val ilo_job1_job_time job_time_lab
				lab var ilo_job1_job_time "Job (Working time arrangement)"
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job_contract')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment: 

	gen ilo_job1_job_contract=.
		replace ilo_job1_job_contract=1 if contract_type==1
		replace ilo_job1_job_contract=2 if inlist(contract_type,2,3)
		replace ilo_job1_job_contract=3 if ilo_lfs==1 & ilo_job1_job_contract==.
		replace ilo_job1_job_contract=. if ilo_lfs!=1
			lab def job_contract_lab 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"
			lab val ilo_job1_job_contract job_contract_lab
			lab var ilo_job1_job_contract "Job (Type of contract)" 

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Informal/Formal economy: Unit of production ('ilo_job1_ife_prod')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment:  Given that the question for social insurance covers all persons in employment (i.e. employees and self-employed) and that the questions about bookkeeping and 
					* registration are unavailable in the dataset, use social insurance as a proxy for registration in order to identify the informal sector
			* Useful questions:	* work_relationship_state: Status in employment
								* sector: Institutional sector 
								* [no info]: Destination of production 
								* [no info]: Bookkeeping
								* [no info]: Registration						
								* work_place_describe: Location of workplace 
								* employee_count: Size of the establishment					
								* Social security 
									* insurance_shared: Social insurance
									
	
	gen ilo_job1_ife_prod=.
		replace ilo_job1_ife_prod=1 if !inlist(sector,1,2) & insurance_shared!=1
		replace ilo_job1_ife_prod=2 if inlist(sector,1,2) | (!inlist(sector,1,2) & insurance_shared==1)
		replace ilo_job1_ife_prod=3 if (ilo_job1_eco_isic4_2digits==97 | ilo_job1_ocu_isco08_2digits==63)
		replace ilo_job1_ife_prod=. if ilo_lfs!=1
			lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 4 "4 - Not elsewhere classified"
			lab val ilo_job1_ife_prod ilo_ife_prod_lab
			lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"			
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Informal/formal economy: Nature of job ('ilo_job1_ife_nature')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_job1_ife_nature=.
		replace ilo_job1_ife_nature=1 if ilo_job1_ste_icse93==5 | (inlist(ilo_job1_ste_icse93,2,3,4) & inlist(ilo_job1_ife_prod,1,3)) | (inlist(ilo_job1_ste_icse93,1,6) & insurance_shared!=1) 
		replace ilo_job1_ife_nature=2 if (inlist(ilo_job1_ste_icse93,1,6) & insurance_shared==1) | (inlist(ilo_job1_ste_icse93,2,3,4) & ilo_job1_ife_prod==2)
		replace ilo_job1_ife_nature=. if ilo_lfs!=1
			lab def ife_nature_lab 1 "1 - Persons with informal main job" 2 "2 - Persons with formal main job"
			lab val ilo_job1_ife_nature ife_nature_lab
			lab var ilo_job1_ife_nature "Informal / Formal Economy (Nature of job)"		

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Earnings ('ilo_job1_lri_ees' and 'ilo_ear_slf')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	* Employees:
	
		gen monthly_wage=.
			replace monthly_wage=salary*(365/12) if cashing_period==1
			replace monthly_wage=salary*(52/12) if cashing_period==2
			replace monthly_wage=salary if cashing_period==3
			replace monthly_wage=salary/12 if cashing_period==4
	
		gen ilo_job1_lri_ees=monthly_wage if ilo_job1_ste_aggregate==1
				lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"
	
		drop monthly_wage


***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_tru')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
           
* Comment: 

	gen ilo_joball_tru=1 if ilo_job1_job_time==1 & desire_work_extra==1 & (search_work_extra==1 | search_work_insted_current==1)
		replace ilo_joball_tru=. if ilo_lfs!=1
			lab def tru_lab 1 "Time-related underemployment"
			lab val ilo_joball_tru tru_lab
			lab var ilo_joball_tru "Time-related underemployment"

*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Cases of non-fatal occupational injury ('ilo_joball_oi_case') [no info]
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------

* Comment: No information
		
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Days lost due to cases of occupational injury ('ilo_joball_oi_day') [no info]
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------

* Comment: No information
			

***********************************************************************************************
*			PART 3.3. UNEMPLOYMENT: ECONOMIC CHARACTERISTICS
***********************************************************************************************	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: 

	 gen ilo_dur_details=.
		replace ilo_dur_details=1 if unemployed_period==0
		replace ilo_dur_details=2 if inrange(unemployed_period,1,2)
		replace ilo_dur_details=3 if inrange(unemployed_period,3,5)
		replace ilo_dur_details=4 if inrange(unemployed_period,6,11)
		replace ilo_dur_details=5 if inrange(unemployed_period,12,23)
		replace ilo_dur_details=6 if unemployed_period>=24 & unemployed_period!=.
		replace ilo_dur_details=7 if ilo_dur_details==. & ilo_lfs==2
		replace ilo_dur_details=. if ilo_lfs!=2
			lab def ilo_unemp_det 1 "Less than 1 month" 2 "1 month to less than 3 months" 3 "3 months to less than 6 months" 4 "6 months to less than 12 months" 5 "12 months to less than 24 months" ///
									6 "24 months or more" 7 "Not elsewhere classified"
			lab values ilo_dur_details ilo_unemp_det
			lab var ilo_dur_details "Duration of unemployment (Details)"		
			
	gen ilo_dur_aggregate=.
		replace ilo_dur_aggregate=1 if inlist(ilo_dur_details,1,2,3)
		replace ilo_dur_aggregate=2 if ilo_dur_details==4
		replace ilo_dur_aggregate=3 if inlist(ilo_dur_details,5,6)
		replace ilo_dur_aggregate=4 if ilo_dur_details==7
		replace ilo_dur_aggregate=. if ilo_lfs!=2
			lab def ilo_unemp_aggr 1 "Less than 6 months" 2 "6 months to less than 12 months" 3 "12 months or more" 4 "Not elsewhere classified"
			lab val ilo_dur_aggregate ilo_unemp_aggr
			lab var ilo_dur_aggregate "Duration of unemployment (Aggregate)"
   
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Category of unemployment ('ilo_cat_une')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: 

	gen ilo_cat_une=.
		replace ilo_cat_une=1 if work_before==1
		replace ilo_cat_une=2 if work_before==2
		replace ilo_cat_une=3 if ilo_lfs==2 & ilo_cat_une==.
		replace ilo_cat_une=. if ilo_lfs!=2
			lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
			lab val ilo_cat_une cat_une_lab
			lab var ilo_cat_une "Category of unemployment"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: 

	* Comment: ISIC Rev. 4 classification being used 
	
		destring activity_last, replace

		gen preveco_cod=int(activity_last/10000) if ilo_lfs==2 & activity_last!=0
		
			* keep this variable on the two digit level, in order to be able to correctly execute the code below
		
	* aggregation done according to information on page 43 of the following document: https://www.bundesbank.de/Redaktion/EN/Downloads/Service/Meldewesen/Bankenstatistik/Kundensystematik/isic_rev_4.pdf?__blob=publicationFile
	
	* Previous economic activity
	
	gen ilo_preveco_isic4=.
		replace ilo_preveco_isic4=1 if inrange(preveco_cod,1,3)
		replace ilo_preveco_isic4=2 if inrange(preveco_cod,5,9)
		replace ilo_preveco_isic4=3 if inrange(preveco_cod,10,33)
		replace ilo_preveco_isic4=4 if preveco_cod==35
		replace ilo_preveco_isic4=5 if inrange(preveco_cod,36,39)
		replace ilo_preveco_isic4=6 if inrange(preveco_cod,41,43)
		replace ilo_preveco_isic4=7 if inrange(preveco_cod,45,47)
		replace ilo_preveco_isic4=8 if inrange(preveco_cod,49,53)
		replace ilo_preveco_isic4=9 if inrange(preveco_cod,55,56)
		replace ilo_preveco_isic4=10 if inrange(preveco_cod,58,63)
		replace ilo_preveco_isic4=11 if inrange(preveco_cod,64,66)
		replace ilo_preveco_isic4=12 if preveco_cod==68
		replace ilo_preveco_isic4=13 if inrange(preveco_cod,69,75)
		replace ilo_preveco_isic4=14 if inrange(preveco_cod,77,82)
		replace ilo_preveco_isic4=15 if preveco_cod==84
		replace ilo_preveco_isic4=16 if preveco_cod==85
		replace ilo_preveco_isic4=17 if inrange(preveco_cod,86,88)
		replace ilo_preveco_isic4=18 if inrange(preveco_cod,90,93)
		replace ilo_preveco_isic4=19 if inrange(preveco_cod,94,96)
		replace ilo_preveco_isic4=20 if inrange(preveco_cod,97,98)
		replace ilo_preveco_isic4=21 if preveco_cod==99
		replace ilo_preveco_isic4=22 if preveco_cod==. & ilo_cat_une==1 & ilo_lfs==2
			lab val ilo_preveco_isic4 isic4
			lab var ilo_preveco_isic4 "Previous economic activity (ISIC Rev. 4)"
		
		* Aggregate level
		
		gen ilo_preveco_aggregate=.
		replace ilo_preveco_aggregate=1 if ilo_preveco_isic4==1
		replace ilo_preveco_aggregate=2 if ilo_preveco_isic4==3
		replace ilo_preveco_aggregate=3 if ilo_preveco_isic4==6
		replace ilo_preveco_aggregate=4 if inlist(ilo_preveco_isic4,2,4,5)
		replace ilo_preveco_aggregate=5 if inrange(ilo_preveco_isic4,7,14)
		replace ilo_preveco_aggregate=6 if inrange(ilo_preveco_isic4,15,21)
		replace ilo_preveco_aggregate=7 if ilo_preveco_isic4==22
			* value label already defined above			
			lab val ilo_preveco_aggregate eco_aggr_lab
			lab var ilo_preveco_aggregate "Previous economic activity (Aggregate)" 
	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu_isco08')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
		
* Comment: ISCO-08 classification being used

	* reduce it to the one digit level 
	
	* zero values correspond to missing/ not responded --> no info on armed forces
	
		replace job_last="" if substr(job_last,1,1)=="x"
	
	destring job_last, replace
	
	gen prevocu_cod=int(job_last/100000) if ilo_lfs==2 & job_last!=0
		* as zero corresponds to missing/not replied
	
	gen ilo_prevocu_isco08=prevocu_cod
		replace ilo_prevocu_isco08=10 if ilo_prevocu_isco08==0
		replace ilo_prevocu_isco08=11 if ilo_prevocu_isco08==. & ilo_cat_une==1 & ilo_lfs==2
		* value label already defined
		lab val ilo_prevocu_isco08 isco08_1dig_lab
		lab var ilo_prevocu_isco08 "Previous occupation (ISCO-08)"
			
	* Aggregate level 
	
	gen ilo_prevocu_aggregate=.
		replace ilo_prevocu_aggregate=1 if inrange(ilo_prevocu_isco08,1,3)
		replace ilo_prevocu_aggregate=2 if inlist(ilo_prevocu_isco08,4,5)
		replace ilo_prevocu_aggregate=3 if inlist(ilo_prevocu_isco08,6,7)
		replace ilo_prevocu_aggregate=4 if ilo_prevocu_isco08==8
		replace ilo_prevocu_aggregate=5 if ilo_prevocu_isco08==9
		replace ilo_prevocu_aggregate=6 if ilo_prevocu_isco08==10
		replace ilo_prevocu_aggregate=7 if ilo_prevocu_isco08==11
			* value label already defined
			lab val ilo_prevocu_aggregate ocu_aggr_lab
			lab var ilo_prevocu_aggregate "Previous occupation (Aggregate)"	
			
	* Skill level
	
		gen ilo_prevocu_skill=.
			replace ilo_prevocu_skill=1 if ilo_prevocu_isco08==9
			replace ilo_prevocu_skill=2 if inlist(ilo_prevocu_isco08,4,5,6,7,8)
			replace ilo_prevocu_skill=3 if inlist(ilo_prevocu_isco08,1,2,3)
			replace ilo_prevocu_skill=4 if inlist(ilo_prevocu_isco08,10,11)
				* value label already defined
				lab val ilo_prevocu_skill ocu_skill_lab
				lab var ilo_prevocu_skill "Occupation (Skill level)"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Unemployment benefits schemes ('ilo_soc_aggregate')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: Not enough information 


***********************************************************************************************
*			PART 3.4. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: Not feasible due to the skip patterns - Only persons ready to work are answering questions on seeking work.


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reasons for not seeking a job ('ilo_olf_reason')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: 2 variables are used here: cause_not_want_search_work (reason for not willing to work) and not_search_work_cause (reason for not searching)

	gen ilo_olf_reason=.
		replace ilo_olf_reason=1 if inlist(not_search_work_cause,6,7,8,9,10,11)
		replace ilo_olf_reason=2 if inlist(not_search_work_cause,1,2)
		replace ilo_olf_reason=3 if inlist(cause_not_want_search_work,2,3,4,7,8) | inlist(not_search_work_cause,3,4,5)
		replace ilo_olf_reason=4 if inlist(cause_not_want_search_work,1,5,6)
		replace ilo_olf_reason=5 if ilo_olf_reason==. & ilo_lfs==3
				replace ilo_olf_reason=. if ilo_lfs!=3
			lab def lab_olf_reason 1 "1 - Labour market (Discouraged)" 2 "2 - Other labour market reasons" 3 "3 - Personal/Family-related"  4 "4 - Does not need/want to work" 5 "5 - Not elsewhere classified"
			lab val ilo_olf_reason lab_olf_reason
			lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job or being outside the labour force)"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seekers ('ilo_dis')
* -------------------------------------------------------------------------------------------
* ------------------------------------------------------------------------------------------- 

* Comment:

	gen ilo_dis=1 if ilo_lfs==3 & ready_work==1 & ilo_olf_reason==1
		lab def ilo_dis_lab 1 "Discouraged job-seekers" 
		lab val ilo_dis ilo_dis_lab
		lab var ilo_dis "Discouraged job-seekers"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training (NEETs) ('ilo_neet')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_neet=.
		replace ilo_neet=1 if inrange(ilo_age,15,24) & ilo_lfs!=1 & inlist(ilo_edu_attendance,2,3)
			lab def ilo_neet_lab 1 "Youth not in education, employment or training"
			lab val ilo_neet ilo_neet_lab
			lab var ilo_neet "Youth not in education, employment or training"  			

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

*			SAVE RESULTS

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* -------------------------------------------------------------
* Prepare final datasets
* -------------------------------------------------------------

cd "$outpath"

		drop if lab==1 /* In order to get rid of observations from tempfile */
		
		drop indu_code_* occ_code_* preveco_* prevocu_* lab isco08_2digits isco88_2digits isco08 isco88 isic4_2digits isic4 isic3_2digits isic3 job_ref_week seek_job
	
		compress 
		
		order ilo*, last
		
		drop if ilo_wgt==.
		   		   
	* Save dataset including original and ilo variables
	
		save ${country}_${source}_${time}_FULL, replace		
	
	*Save file only containing ilo_* variables
	
		keep ilo*
		
		save ${country}_${source}_${time}_ILO, replace
