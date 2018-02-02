* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Bangladesh, 2006
* DATASET USED:  Bangladesh LFS 2006
* NOTES: 
* Authors: Mabelin Villarreal Fuentes
* Who last updated the file: Mabelin Villarreal Fuentes
* Starting Date: 17 August 2017
* Last updated: 01 September 2017
***********************************************************************************************

***********************************************************************************************
***********************************************************************************************

* 			1. SET UP WORK DIRECTORY, FILE NAME, VARIABLES AND FUNCTIONS

***********************************************************************************************
***********************************************************************************************

clear all 

set more off
*set more off, permanently

global path "J:\COMMON\STATISTICS\DPAU\MICRO"
global country "BGD"
global source "LFS"
global time "2006"
global inputFile "LFS05_06_Final"
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
	use "$inputFile", clear
	*renaming everything in lower case
	rename *, lower  		
		
***********************************************************************************************
***********************************************************************************************

*			2. MAP VARIABLES

***********************************************************************************************
***********************************************************************************************
		
* ---------------------------------------------------------------------------------------------
***********************************************************************************************
*			PART 1. DATASET SETTINGS VARIABLES
***********************************************************************************************
* ---------------------------------------------------------------------------------------------

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Key identifier ('ilo_key') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment:

	gen ilo_key=_n
		lab var ilo_key "Key unique identifier per individual"		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time period ('ilo_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment:

	* Year 
	gen ilo_time=1
		lab def lab_time 1 "$time"
		lab val ilo_time lab_time
		lab var ilo_time "Time (Gregorian Calendar)"
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sample Weight ('ilo_wgt') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment:	

	gen ilo_wgt=wgt
		lab var ilo_wgt "Sample weight"		
	
* ---------------------------------------------------------------------------------------------
***********************************************************************************************
*			PART 2. SOCIAL CHARACTERISTICS
***********************************************************************************************
* ---------------------------------------------------------------------------------------------
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Geographical coverage ('ilo_geo') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment:

	gen ilo_geo=.
		replace ilo_geo=1 if rural==0
		replace ilo_geo=2 if rural==1
			lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural"
			lab val ilo_geo ilo_geo_lab
			lab var ilo_geo "Geographical coverage"	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment:

	gen ilo_sex=sex
		lab def ilo_sex_lab 1 "1 - Male" 2 "2 - Female"
		lab var ilo_sex "Sex"
		lab val ilo_sex ilo_sex_lab
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment:

	gen ilo_age=age
		lab var ilo_age "Age"
		
    *Age groups
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
		replace ilo_age_5yrbands=14 if ilo_age>=65 & ilo_age!=.
			    lab def age_by5_lab 1 "0-4" 2 "5-9" 3 "10-14" 4 "15-19" 5 "20-24" 6 "25-29" ///
								    7 "30-34" 8 "35-39" 9 "40-44" 10 "45-49" 11 "50-54" 12 "55-59" ///
								    13 "60-64" 14 "65+"
			    lab val ilo_age_5yrbands age_by5_lab
			    lab var ilo_age_5yrbands "Age (5-year age bands)"
			
	gen ilo_age_10yrbands=.
		replace ilo_age_10yrbands=1 if inrange(ilo_age,0,14)
		replace ilo_age_10yrbands=2 if inrange(ilo_age,15,24)
		replace ilo_age_10yrbands=3 if inrange(ilo_age,25,34)
		replace ilo_age_10yrbands=4 if inrange(ilo_age,35,44)
		replace ilo_age_10yrbands=5 if inrange(ilo_age,45,54)
		replace ilo_age_10yrbands=6 if inrange(ilo_age,55,64)
		replace ilo_age_10yrbands=7 if ilo_age>=65 & ilo_age!=.
			lab def age_by10_lab 1 "<15" 2 "15-24" 3 "25-34" 4 "35-44" 5 "45-54" 6 "55-64" 7 "65+"
			lab val ilo_age_10yrbands age_by10_lab
			lab var ilo_age_10yrbands "Age (10-year age bands)"
			
	gen ilo_age_aggregate=.
		replace ilo_age_aggregate=1 if inrange(ilo_age,0,14)
		replace ilo_age_aggregate=2 if inrange(ilo_age,15,24)
		replace ilo_age_aggregate=3 if inrange(ilo_age,25,54)
		replace ilo_age_aggregate=4 if inrange(ilo_age,55,64)
		replace ilo_age_aggregate=5 if ilo_age>=65 & ilo_age!=.
			lab def age_aggr_lab 1 "<15" 2 "15-24" 3 "25-54" 4 "55-64" 5 "65+"
			lab val ilo_age_aggregate age_aggr_lab
			lab var ilo_age_aggregate "Age (Aggregate)"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education ('ilo_edu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Primary education includes pre-primary education (class i-v) (note to value)
*          - Technical/vocational education are classified under post-secondary non-tertiary education
*          - Original question is only asked to 5+, therefore below 5 years old are classified
*            under "Level not stated" along with those who actually answered "other".	

    * ISCED97
    gen ilo_edu_isced97=.
		replace ilo_edu_isced97=1 if edu==1                                     // No schooling
		*replace ilo_edu_isced97=2 if                                           // Pre-primary education
		replace ilo_edu_isced97=3 if edu==2                                     // Primary education
		replace ilo_edu_isced97=4 if edu==3                                     // Lower secondary education
		replace ilo_edu_isced97=5 if inlist(edu,4,5,6)                          // Upper secondary education
		replace ilo_edu_isced97=6 if edu==10                                    // Post-secondary non-tertiary education
		replace ilo_edu_isced97=7 if inlist(edu,7,9)                            // First stage of tertiary education
		replace ilo_edu_isced97=8 if edu==8                                     // Second stage of tertiary education
		replace ilo_edu_isced97=9 if inlist(edu,11,0)                           // Level not stated 
			    label def isced_97_lab 1 "X - No schooling" 2 "0 - Pre-primary education" 3 "1 - Primary education or first stage of basic education" 4 "2 - Lower secondary education or second stage of basic education" ///
				  			           5 "3 - Upper secondary education" 6 "4 - Post-secondary non-tertiary education" 7 "5 - First stage of tertiary education (not leading directly to an advanced research qualification)" ///
							           8 "6 - Second stage of tertiary education (leading to an advanced research qualification)" 9 "UNK - Level not stated"
			    label val ilo_edu_isced97 isced_97_lab
			    lab var ilo_edu_isced97 "Level of education (ISCED 97)"

	* Aggregate
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
*			Education attendance ('ilo_edu_attendance') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Only asked to 5 years old, therefore below 5 are classified under "not elsewhere
*            classified".

	gen ilo_edu_attendance=.
		replace ilo_edu_attendance=1 if stud==1				                    // Attending
		replace ilo_edu_attendance=2 if stud==2				                    // Not attending
		replace ilo_edu_attendance=3 if ilo_edu_attendance==.                   // Not elsewhere classified
			label def edu_att_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
			label val ilo_edu_attendance edu_att_lab
			label var ilo_edu_attendance "Education (Attendance)"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Disability status ('ilo_dsb') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment: No information.
		
* ---------------------------------------------------------------------------------------------
***********************************************************************************************
*			PART 3. ECONOMIC SITUATION
***********************************************************************************************
* ---------------------------------------------------------------------------------------------		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working age population ('ilo_wap') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: 

	gen ilo_wap=.
		replace ilo_wap=1 if ilo_age>=15 & ilo_age!=.
			lab def wap_lab 1 "Working age population"
			lab val ilo_wap wap_lab
			label var ilo_wap "Working age population"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Labour Force Status ('ilo_lfs') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Employment is based on questions 4.1 and 4.2 (even though 4.1 includes people who
*            produce goods or services ONLY for household's own use or consumption into employment).		
*          - Unemployment includes future starters (question 8.5 options 1 -waiting for re-appointment- 
*            and 2 -waiting to join company after appointment-).
		  
	gen ilo_lfs=.
		replace ilo_lfs=1 if (s4q41==1 | s4q42==1) & ilo_wap==1		                               // Employed 
		replace ilo_lfs=2 if ilo_lfs!=1 & (s8q81==1 &  s8q82==1) & ilo_wap==1                      // Unemployed
		replace ilo_lfs=2 if ilo_lfs!=1 & s8q81==1 & s8q82==2 & inlist(s8q85,1,2) & ilo_wap==1     // Unemployed: future starters
		replace ilo_lfs=3 if !inlist(ilo_lfs,1,2) & ilo_wap==1 		                               // Outside the labour force
				label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside the Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment:

	gen ilo_mjh=.
		replace ilo_mjh=2 if s4q48==1 & ilo_lfs==1
		replace ilo_mjh=1 if s4q48!=1 & ilo_lfs==1
			    lab def lab_ilo_mjh 1 "1 - One job only" 2 "2 - More than one job"
			    lab val ilo_mjh lab_ilo_mjh
			    lab var ilo_mjh "Multiple job holders"

***********************************************************************************************
*			PART 3.1. ECONOMIC CHARACTERISTICS FOR MAIN JOB 
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Status in employment ('ilo_job1_ste') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - No information available on secondary job.

  * MAIN JOB:
	gen ilo_job1_ste_icse93=.
		replace ilo_job1_ste_icse93=1 if inlist(s4q412,1,5,6,7,8,9) & ilo_lfs==1	 // Employees
		replace ilo_job1_ste_icse93=2 if s4q412==2 & ilo_lfs==1					     // Employers
		replace ilo_job1_ste_icse93=3 if s4q412==3 & ilo_lfs==1			             // Own-account workers
		*replace ilo_job1_ste_icse93=4 if										     // Producer cooperatives
		replace ilo_job1_ste_icse93=5 if s4q412==4 & ilo_lfs==1					     // Contributing family workers
		replace ilo_job1_ste_icse93=6 if inlist(s4q412,10,0) & ilo_lfs==1			 // Not classifiable
				label def label_ilo_ste_icse93 1 "1 - Employees" 2 "2 - Employers" 3 "3 - Own-account workers"  ///
											   4 "4 - Members of producers cooperatives" 5 "5 - Contributing family workers" ///
											   6 "6 - Workers not classifiable by status"
				label val ilo_job1_ste_icse93 label_ilo_ste_icse93
				label var ilo_job1_ste_icse93 "Status in employment (ICSE 93)"

			
	
	* Aggregate categories 
		
		gen ilo_job1_ste_aggregate=.
			replace ilo_job1_ste_aggregate=1 if ilo_job1_ste_icse93==1				// Employees
			replace ilo_job1_ste_aggregate=2 if inrange(ilo_job1_ste_icse93,2,5)	// Self-employed
			replace ilo_job1_ste_aggregate=3 if ilo_job1_ste_icse93==6				// Not elsewhere classified
				lab def ste_aggr_lab 1 "1 - Employees" 2 "2 - Self-employed" 3 "3 - Not elsewhere classified"
				lab val ilo_job1_ste_aggregate ste_aggr_lab
				label var ilo_job1_ste_aggregate "Status in employment (Aggregate)"  
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment:	- Classification used: BSIC, based on ISIC Rev. 3	
*           - No information available on secondary job. 		
			
	* Import value labels		
	append using `labels', gen (lab)
				
	* MAIN JOB:
	* ISIC Rev. 3 - 2 digit
    gen ilo_job1_eco_isic3_2digits = int(s4q44/100) if ilo_lfs==1
	    lab values ilo_job1_eco_isic3_2digits isic3_2digits
	    lab var ilo_job1_eco_isic3_2digits "Economic activity (ISIC Rev. 3.1), 2 digit level - main job"
	
    * ISIC Rev. 3.1 - 1 digit
	gen ilo_job1_eco_isic3=.
		replace ilo_job1_eco_isic3=1 if inrange(ilo_job1_eco_isic3_2digits,1,2)
		replace ilo_job1_eco_isic3=2 if ilo_job1_eco_isic3_2digits==5
		replace ilo_job1_eco_isic3=3 if inrange(ilo_job1_eco_isic3_2digits,10,14)
		replace ilo_job1_eco_isic3=4 if inrange(ilo_job1_eco_isic3_2digits,15,37)
		replace ilo_job1_eco_isic3=5 if inrange(ilo_job1_eco_isic3_2digits,40,41)
		replace ilo_job1_eco_isic3=6 if ilo_job1_eco_isic3_2digits==45
		replace ilo_job1_eco_isic3=7 if inrange(ilo_job1_eco_isic3_2digits,50,52)
		replace ilo_job1_eco_isic3=8 if ilo_job1_eco_isic3_2digits==55
		replace ilo_job1_eco_isic3=9 if inrange(ilo_job1_eco_isic3_2digits,60,64)
		replace ilo_job1_eco_isic3=10 if inrange(ilo_job1_eco_isic3_2digits,65,67)
		replace ilo_job1_eco_isic3=11 if inrange(ilo_job1_eco_isic3_2digits,70,74)
		replace ilo_job1_eco_isic3=12 if ilo_job1_eco_isic3_2digits==75
		replace ilo_job1_eco_isic3=13 if ilo_job1_eco_isic3_2digits==80
		replace ilo_job1_eco_isic3=14 if ilo_job1_eco_isic3_2digits==85
		replace ilo_job1_eco_isic3=15 if inrange(ilo_job1_eco_isic3_2digits,90,93)
		replace ilo_job1_eco_isic3=16 if ilo_job1_eco_isic3_2digits==95
		replace ilo_job1_eco_isic3=17 if ilo_job1_eco_isic3_2digits==99
		replace ilo_job1_eco_isic3=18 if ilo_job1_eco_isic3_2digits==. & ilo_lfs==1
			    lab val ilo_job1_eco_isic3 isic3
			    lab var ilo_job1_eco_isic3 "Economic activity (ISIC Rev. 3.1) - main job"
			
	* Aggregate
	gen ilo_job1_eco_aggregate=.
		replace ilo_job1_eco_aggregate=1 if inlist(ilo_job1_eco_isic3,1,2)
		replace ilo_job1_eco_aggregate=2 if ilo_job1_eco_isic3==4
		replace ilo_job1_eco_aggregate=3 if ilo_job1_eco_isic3==6
		replace ilo_job1_eco_aggregate=4 if inlist(ilo_job1_eco_isic3,3,5)
		replace ilo_job1_eco_aggregate=5 if inrange(ilo_job1_eco_isic3,7,11)
		replace ilo_job1_eco_aggregate=6 if inrange(ilo_job1_eco_isic3,12,17)
		replace ilo_job1_eco_aggregate=7 if ilo_job1_eco_isic3==18
			    lab def eco_aggr_lab 1 "1 - Agriculture" 2 "2 - Manufacturing" 3 "3 - Construction" 4 "4 - Mining and quarrying; Electricity, gas and water supply" ///
								     5 "5 - Market Services (Trade; Transportation; Accommodation and food; and Business and administrative services)"  ///
								     6 "6 - Non-market services (Public administration; Community, social and other services and activities)" 7 "7 - Not classifiable by economic activity"					
			    lab val ilo_job1_eco_aggregate eco_aggr_lab
			    lab var ilo_job1_eco_aggregate "Economic activity (Aggregate) - main job"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_job1_ocu_isco08') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment: - Classification used: BSCO, based on ISCO 88.
*          - No information available on secondary job.
	
	* MAIN JOB:	
	* ISCO 88 - 2 digit
	gen ilo_job1_ocu_isco88_2digits = int(s4q46/100) if ilo_lfs==1
		lab values ilo_job1_ocu_isco88_2digits isco88_2digits
		lab var ilo_job1_ocu_isco88_2digits "Occupation (ISCO-88), 2 digit level - main job"

	
    * ISCO 88 - 1 digit
	gen ilo_job1_ocu_isco88=.
		replace ilo_job1_ocu_isco88=int(ilo_job1_ocu_isco88_2digits/10) if (ilo_job1_ocu_isco88==. & ilo_lfs==1)     
		replace ilo_job1_ocu_isco88=10 if (ilo_job1_ocu_isco88==0 & ilo_lfs==1)                                      //Armed forces
				lab val ilo_job1_ocu_isco88 isco88
				lab var ilo_job1_ocu_isco88 "Occupation (ISCO-88) - main job"
				
	* Aggregate:			
	gen ilo_job1_ocu_aggregate=.
		replace ilo_job1_ocu_aggregate=1 if inrange(ilo_job1_ocu_isco88,1,3)
		replace ilo_job1_ocu_aggregate=2 if inlist(ilo_job1_ocu_isco88,4,5)
		replace ilo_job1_ocu_aggregate=3 if inlist(ilo_job1_ocu_isco88,6,7)
		replace ilo_job1_ocu_aggregate=4 if ilo_job1_ocu_isco88==8
		replace ilo_job1_ocu_aggregate=5 if ilo_job1_ocu_isco88==9
		replace ilo_job1_ocu_aggregate=6 if ilo_job1_ocu_isco88==10
		replace ilo_job1_ocu_aggregate=7 if ilo_job1_ocu_isco88==11
				lab def ocu_aggr_lab 1 "1 - Managers, professionals, and technicians" 2 "2 - Clerical, service and sales workers" 3 "3 - Skilled agricultural and trades workers" ///
									 4 "4 - Plant and machine operators, and assemblers" 5 "5 - Elementary occupations" 6 "6 - Armed forces" 7 "7 - Not elsewhere classified"
				lab val ilo_job1_ocu_aggregate ocu_aggr_lab
				lab var ilo_job1_ocu_aggregate "Occupation (Aggregate)"				
				
    * Skill level				
    gen ilo_job1_ocu_skill=.
	    replace ilo_job1_ocu_skill=1 if ilo_job1_ocu_isco88==9                   // Low
		replace ilo_job1_ocu_skill=2 if inlist(ilo_job1_ocu_isco88,4,5,6,7,8)    // Medium
		replace ilo_job1_ocu_skill=3 if inlist(ilo_job1_ocu_isco88,1,2,3)        // High
		replace ilo_job1_ocu_skill=4 if inlist(ilo_job1_ocu_isco88,10,11)        // Not elsewhere classified
				lab def ocu_skill_lab 1 "1 - Skill level 1 (low)" 2 "2 - Skill level 2 (medium)" 3 "3 - Skill levels 3 and 4 (high)" 4 "4 - Not elsewhere classified"
			    lab val ilo_job1_ocu_skill ocu_skill_lab
			    lab var ilo_job1_ocu_skill "Occupation (Skill level)"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_job1_ins_sector') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment: - Public: Government.
*          - Private: Private formal sector, personal household, personal establishment, other.

	gen ilo_job1_ins_sector=.
		replace ilo_job1_ins_sector=1 if s4q413==1 & ilo_lfs==1		            // Public
		replace ilo_job1_ins_sector=2 if s4q413!=1 & ilo_lfs==1		            // Private
				lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private" 
				lab values ilo_job1_ins_sector ins_sector_lab
				lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job1_job_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
* Comment: - Only asked to employees and therefore the rest of workers are classified under "unknown".
*          - Defined based on a self-assessment question.
	
	gen ilo_job1_job_time=.
		replace ilo_job1_job_time=1 if s4q415==2 & ilo_lfs==1 	                // Part-time
		replace ilo_job1_job_time=2 if s4q415==1 & ilo_lfs==1 	                // Full-time
		replace ilo_job1_job_time=3 if s4q415==0 & ilo_lfs==1	                // Unknown
				lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
			    lab val ilo_job1_job_time job_time_lab
				lab var ilo_job1_job_time "Job (Working time arrangement) - Main job"	
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job1_job_contract') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
* Comment: - No information available.

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Formal / Informal Economy ('ilo_job1_ife_prod' 'ilo_job1_ife_nature') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
* Comment: 
/* Useful questions:
			
		  * Institutional sector: s4q413
		  * Destination of production: not asked.
		  * Bookkeeping: s4q422 (only asked to self employees/employers)
		  * Registration: s4q421 (only asked to self employees/employers)
		  * Status in employment: ilo_job1_ste_icse93 
		  * Pension funds: not asked.
		  * Place of work: s4q414
		  * Size: not asked.
		  * Paid sick leave: s4q420v1 to s4q420v6, option 2. 
		  * Paid annual leave: not asked.
		  
		  Not enough information to compute this variable.
		  
*/
		   
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Hours of work ('ilo_job1_how') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment: - Only available total hours actually worked in main, secondary and all jobs.
*          - Those observations reporting more than 168 hours per week are forced to 168 hours per week.
	
	* MAIN JOB
	gen ilo_job1_how_actual=s4q47  if ilo_lfs==1
	    replace ilo_job1_how_actual=168 if ilo_job1_how_actual>=168 & ilo_lfs==1
		lab var ilo_job1_how_actual "Weekly hours actually worked in main job"
					
	gen ilo_job1_how_actual_bands=.
		replace ilo_job1_how_actual_bands=1 if ilo_job1_how_actual==0
		replace ilo_job1_how_actual_bands=2 if inrange(ilo_job1_how_actual,1,14)
		replace ilo_job1_how_actual_bands=3 if inrange(ilo_job1_how_actual,15,29)
		replace ilo_job1_how_actual_bands=4 if inrange(ilo_job1_how_actual,30,34)
		replace ilo_job1_how_actual_bands=5 if inrange(ilo_job1_how_actual,35,39)
		replace ilo_job1_how_actual_bands=6 if inrange(ilo_job1_how_actual,40,48)
		replace ilo_job1_how_actual_bands=7 if ilo_job1_how_actual>=49 & ilo_job1_how_actual!=.
		replace ilo_job1_how_actual_bands=8 if ilo_job1_how_actual==. & ilo_lfs==1
		replace ilo_job1_how_actual_bands=. if ilo_lfs!=1
				lab def how_bands_lab 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"
				lab val ilo_job1_how_actual_bands how_bands_lab
				lab var ilo_job1_how_actual_bands "Weekly hours actually worked bands in main job"
				
	* SECOND JOB
	gen ilo_job2_how_actual=s4q410 if ilo_mjh==2
		lab var ilo_job2_how_actual "Weekly hours actually worked in second job"
					
	gen ilo_job2_how_actual_bands=.
		replace ilo_job2_how_actual_bands=1 if ilo_job2_how_actual==0
		replace ilo_job2_how_actual_bands=2 if inrange(ilo_job2_how_actual,1,14)
		replace ilo_job2_how_actual_bands=3 if inrange(ilo_job2_how_actual,15,29)
		replace ilo_job2_how_actual_bands=4 if inrange(ilo_job2_how_actual,30,34)
		replace ilo_job2_how_actual_bands=5 if inrange(ilo_job2_how_actual,35,39)
		replace ilo_job2_how_actual_bands=6 if inrange(ilo_job2_how_actual,40,48)
		replace ilo_job2_how_actual_bands=7 if ilo_job2_how_actual>=49 & ilo_job2_how_actual!=.
		replace ilo_job2_how_actual_bands=8 if ilo_job2_how_actual==. & ilo_lfs==1
		replace ilo_job2_how_actual_bands=. if ilo_lfs!=1
				lab val ilo_job2_how_actual_bands how_bands_lab
				lab var ilo_job2_how_actual_bands "Weekly hours actually worked bands in second job"				
				
	* ALL JOBS
	gen ilo_joball_how_actual=s4q411  if ilo_lfs==1
	    replace ilo_joball_how_actual=168 if ilo_joball_how_actual>=168 & ilo_lfs==1
		lab var ilo_joball_how_actual "Weekly hours actually worked in all jobs"
	
	gen ilo_joball_how_actual_bands=.
		replace ilo_joball_how_actual_bands=1 if ilo_joball_how_actual==0
		replace ilo_joball_how_actual_bands=2 if inrange(ilo_joball_how_actual,1,14)
		replace ilo_joball_how_actual_bands=3 if inrange(ilo_joball_how_actual,15,29)
		replace ilo_joball_how_actual_bands=4 if inrange(ilo_joball_how_actual,30,34)
		replace ilo_joball_how_actual_bands=5 if inrange(ilo_joball_how_actual,35,39)
		replace ilo_joball_how_actual_bands=6 if inrange(ilo_joball_how_actual,40,48)
		replace ilo_joball_how_actual_bands=7 if ilo_joball_how_actual>=49 & ilo_joball_how_actual!=.
		replace ilo_joball_how_actual_bands=8 if ilo_joball_how_actual==. & ilo_lfs==1
		replace ilo_joball_how_actual_bands=. if ilo_lfs!=1
				lab val ilo_joball_how_actual_bands how_bands_lab
				lab var ilo_joball_how_actual_bands "Weekly hours actually worked bands in all jobs"				
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Monthly labour related income ('ilo_lri') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
* Comment:   - Original questions 4.18 and 4.19 are asked to employees/ day labourers on their 
*            payment in the last 7 days; it does not correctly assess monthly income and thus 
*            it's not computed.

		
**********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
**********************************************************************************************		
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_joball_tru') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
* Comment: - No information available.
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupational injury ('ilo_joball_inj') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
* Comment: - No information available.		
		
		
***********************************************************************************************
*			PART 3.3. UNEMPLOYMENT: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Category of unemployment ('ilo_cat_une') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - No information available.			
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: 

    gen ilo_dur_details=.
	    replace ilo_dur_details=1 if (inrange(s8q84,0,3) & ilo_lfs==2)          // Less than 1 month (between 1 and 3 weeks)
		replace ilo_dur_details=2 if (inrange(s8q84,4,11) & ilo_lfs==2)         // 1 to 3 months (between 4 and 11 weeks)
		replace ilo_dur_details=3 if (inrange(s8q84,12,23) & ilo_lfs==2)        // 3 to 6 months (between 12 and 23 weeks)
		replace ilo_dur_details=4 if (inrange(s8q84,24,47) & ilo_lfs==2)        // 6 to 12 months (between 24 and 47 weeks)
		replace ilo_dur_details=5 if (inrange(s8q84,48,95) & ilo_lfs==2)        // 12 to 24 months (between 48 and 95 weeks)
		replace ilo_dur_details=6 if (s8q84>=96 & ilo_lfs==2)                   // 24 months or more (96 weeks or more)
		replace ilo_dur_details=7 if (ilo_dur_details==. & ilo_lfs==2)          // Not elsewhere classified
		        lab def ilo_unemp_det 1 "Less than 1 month" 2 "1 month to less than 3 months" 3 "3 months to less than 6 months" ///
									  4 "6 months to less than 12 months" 5 "12 months to less than 24 months" 6 "24 months or more" ///
									  7 "Not elsewhere classified"
			    lab val ilo_dur_details ilo_unemp_det
			    lab var ilo_dur_details "Duration of unemployment (Details)"
				
	gen ilo_dur_aggregate=.
		replace ilo_dur_aggregate=1 if (inlist(ilo_dur_details,1,2,3) & ilo_lfs==2)   // Less than 6 months
		replace ilo_dur_aggregate=2 if (ilo_dur_details==4 & ilo_lfs==2)              // 6 to 12 months
		replace ilo_dur_aggregate=3 if (inlist(ilo_dur_details,5,6) & ilo_lfs==2)     // 12 months or more
		replace ilo_dur_aggregate=4 if (ilo_dur_details==7 & ilo_lfs==2)              // Not elsewhere classified
		replace ilo_dur_aggregate=. if ilo_lfs!=2
			lab def ilo_unemp_aggr 1 "Less than 6 months" 2 "6 months to less than 12 months" 3 "12 months or more" 4 "Not elsewhere classified"
			lab val ilo_dur_aggregate ilo_unemp_aggr
			lab var ilo_dur_aggregate "Duration of unemployment (Aggregate)"				

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
* Comment: - No information available.		
		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
* Comment: - No information available.		
		
		
***********************************************************************************************
*			PART 3.3. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment: - Willingness is not available and therefore categories 3 and 4 are not computed.
*          - Category 2 is empty but still defined.

	gen ilo_olf_dlma=.
		replace ilo_olf_dlma = 1 if (s8q82==1) & (s8q81==2) & ilo_lfs==3 		// Seeking, not available
		replace ilo_olf_dlma = 2 if (s8q82==2) & (s8q81==1) & ilo_lfs==3		// Not seeking, available
		*replace ilo_olf_dlma = 3 	                                            // Not seeking, not available, willing
		*replace ilo_olf_dlma = 4 	                                            // Not seeking, not available, not willing
		replace ilo_olf_dlma = 5 if	ilo_olf_dlma==. & ilo_lfs==3				// Not classified 
				lab def dlma_lab 1 "1 - Seeking, not available (Unavailable jobseekers)" 2 "2 - Not seeking, available (Available potential jobseekers)" ///
	    						 3 "3 - Not seeking, not available, willing (Willing non-jobseekers)" 4 "4 - Not seeking, not available, not willing" 5 "X - Not elsewhere classified"
		    	lab val ilo_olf_dlma dlma_lab 
			    lab var ilo_olf_dlma "Labour market attachment (Degree of)"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reason for not seeking job ('ilo_olf_reason') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment: 
	
	gen ilo_olf_reason=.
		replace ilo_olf_reason=1 if	s8q85==3 & ilo_lfs==3	                    // Labour market
		replace ilo_olf_reason=2 if inlist(s8q85,1,2) & ilo_lfs==3              // Other labour market reasons
		replace ilo_olf_reason=3 if	inlist(s8q85,4,5,8) & ilo_lfs==3  	        // Personal/Family-related
		replace ilo_olf_reason=4 if inlist(s8q85,6,7) & ilo_lfs==3		        // Does not need/want to work
		replace ilo_olf_reason=5 if inlist(s8q85,9,0) & ilo_lfs==3	            // Not elsewhere classified
			    lab def reasons_lab 1 "1 - Labour market" 2 "2 - Other labour market reasons" 3 "3 - Personal / Family-related" ///
								    4 "4 - Does not need/want to work" 5 "5 - Not elsewhere classified"
			    lab val ilo_olf_reason reasons_lab 
			    lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seeker ('ilo_dis')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment: - No observations but still defined.
		
	gen ilo_dis=1 if ilo_lfs==3 & s8q81==1 & ilo_olf_reason==1
			lab def dis_lab 1 "Discouraged job-seekers"
			lab val ilo_dis dis_lab
			lab var ilo_dis "Discouraged job-seekers"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training ('ilo_neet')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment: 

	 gen ilo_neet=1 if ilo_age_aggregate==2 & ilo_lfs!=1 & ilo_edu_attendance==2
			lab def neet_lab 1 "Youth not in education, employment or training"
			lab val ilo_neet neet_lab
			lab var ilo_neet "Youth not in education, employment or training"
		
***********************************************************************************************
***********************************************************************************************

*			3. SAVE ILO-VARIABLES IN A NEW DATASET

***********************************************************************************************
***********************************************************************************************


* -------------------------------------------------------------
* 	Prepare final datasets
* -------------------------------------------------------------
cd "$outpath"
        
		/*Categories from temporal file deleted */
		drop if lab==1 
		
		/*Only age bands used*/
		drop ilo_age 
		
		/*Variables computed in-between*/
		drop lab isco08_2digits isco88_2digits isco08 isco88 isic4_2digits isic4 isic3_2digits isic3
		
		compress 
		
	   /*Save dataset including original and ilo variables*/
	
		save ${country}_${source}_${time}_FULL,  replace		
	
	   /*Save file only containing ilo_* variables*/
	
		keep ilo*

		save ${country}_${source}_${time}_ILO, replace

		
