* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Papua New Guinea, 2010
* DATASET USED: Papua New Guinea HIES 2010
* NOTES: 
* Files created: Standard variables on LFS Uruguay 2015
* Authors: Mabelin Villarreal Fuentes
* Who last updated the file: Mabelin Villarreal Fuentes
* Starting Date: 05 September 2017
* Last updated: 19 September 2017
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
global country "PNG"
global source "HIES"
global time "2010"
global inputFile "PNG_HIES_2010_Merged"
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
*********************************************************************************************

* Load original dataset

*********************************************************************************************
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
*			Sample Weight ('ilo_wgt') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - The original-merged dataset contains two different variables related to sampling 
*            factors (weight/weight_ps). Following the available "readme.pdf" file, the variable 
*            used here is 'wight_ps', which takes into account non response and post stratification 
*            adjustments.

	gen ilo_wgt = weight_ps
		lab var ilo_wgt "Sample weight"		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time period ('ilo_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: 

	gen ilo_time = 1
		lab def lab_time 1 "$time"
		lab val ilo_time lab_time
		lab var ilo_time "Time (Gregorian Calendar)"		

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
	    replace ilo_geo = a0_zone
		        lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural"
		        lab val ilo_geo ilo_geo_lab
		        lab var ilo_geo "Geographical coverage"	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*Comment: 

	gen ilo_sex=.
	    replace ilo_sex = a1_03
		        lab def ilo_sex_lab 1 "1 - Male" 2 "2 - Female"
		        lab var ilo_sex "Sex"
		        lab val ilo_sex ilo_sex_lab

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment:

	gen ilo_age = a1_04
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
		replace ilo_age_5yrbands=14 if ilo_age>=65 & ilo_age!=.
			lab def age_by5_lab 1 "0-4" 2 "5-9" 3 "10-14" 4 "15-19" 5 "20-24" 6 "25-29" 7 "30-34" 8 "35-39" ///
								9 "40-44" 10 "45-49" 11 "50-54" 12 "55-59" 13 "60-64" 14 "65+"
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
* Comment: - Question is asked to those aged 5 years old or more and thus those below 5 are 
*            classified under "not elsewhere classifed".
*          - The highest grade completed is asked in two different questions: for those who are 
*            currently attending and those currently not attending). It is previously asked (b1_05)
*            whether the person has ever attended any formal school (if she/he has not -> classified
*            under less than basic).
*          - The mapping is based on the following document: 
*            http://www.ibe.unesco.org/sites/default/files/Papua_New_Guinea.pdf
*          - Only possible to assign it at the aggregate level.

	*Aggregate level	
	gen ilo_edu_aggregate=.
		replace ilo_edu_aggregate=1 if b1_09==0 | b1_13==0 | b1_05==2                                       // Less than basic
		replace ilo_edu_aggregate=2 if inlist(b1_09,1,2,3,4,5,6,7,8) | inlist(b1_13,1,2,3,4,5,6,7,8)        // Basic
		replace ilo_edu_aggregate=3 if inlist(b1_09,9,10,11,12) | inlist(b1_13,9,10,11,12)                  // Intermediate
		replace ilo_edu_aggregate=4 if inlist(b1_09,13,14,15,16,17) | inlist(b1_13,13,14,15,16,17)          // Advance
		replace ilo_edu_aggregate=5 if ilo_edu_aggregate==.                                                 // Level not stated
			label def edu_aggr_lab 1 "1 - Less than basic" 2 "2 - Basic" 3 "3 - Intermediate" 4 "4 - Advanced" 5 "5 - Level not stated"
			label val ilo_edu_aggregate edu_aggr_lab
			label var ilo_edu_aggregate "Education (Aggregate level)"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education attendance ('ilo_edu_attendance') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Question is asked for those aged 5 years old or more and thus those below 5 are 
*            classified under "not elsewhere classifed".

	gen ilo_edu_attendance=.
	    replace ilo_edu_attendance=1 if b1_07==1		                        // Attending
        replace ilo_edu_attendance=2 if b1_07==2                                // Not attending
		replace ilo_edu_attendance=3 if ilo_edu_attendance==.                   // Not elsewhere classified
			label def edu_att_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified" 
			label val ilo_edu_attendance edu_att_lab
			label var ilo_edu_attendance "Education (Attendance)"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Disability status ('ilo_dsb') 	[done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment: - To measure disability status, questions asking whether the person has difficulties 
*            seeing, hearing, walking, remembering and washing all over or dressing (self-caring)
*            are taken into account.

	* Detailed disability status:
	gen ilo_dsb_details=.
		replace ilo_dsb_details=2 if b4_01==3     	        // Some difficulty
		replace ilo_dsb_details=2 if b4_03==3		        // Some difficulty
		replace ilo_dsb_details=2 if b4_05==3		        // Some difficulty
		replace ilo_dsb_details=2 if b4_07==3		        // Some difficulty
		replace ilo_dsb_details=2 if b4_09==3		        // Some difficulty
		replace ilo_dsb_details=3 if b4_01==2    	        // A lot of difficulty
		replace ilo_dsb_details=3 if b4_03==2		        // A lot of difficulty
		replace ilo_dsb_details=3 if b4_05==2		        // A lot of difficulty
		replace ilo_dsb_details=3 if b4_07==2		        // A lot of difficulty
		replace ilo_dsb_details=3 if b4_09==2		        // A lot of difficulty
		replace ilo_dsb_details=4 if b4_01==1  		        // Cannot do it at all
		replace ilo_dsb_details=4 if b4_03==1		        // Cannot do it at all
		replace ilo_dsb_details=4 if b4_05==1		        // Cannot do it at all
		replace ilo_dsb_details=4 if b4_07==1		        // Cannot do it at all
		replace ilo_dsb_details=4 if b4_09==1		        // Cannot do it at all
		replace ilo_dsb_details=1 if ilo_dsb_details==.     // No difficulty
				label def dsb_det_lab 1 "1 - No, no difficulty" 2 "2 - Yes, some difficulty" 3 "3 - Yes, a lot of difficulty" 4 "4 - Cannot do it at all"
				label val ilo_dsb_details dsb_det_lab
				label var ilo_dsb_details "Disability status (Details)"

	 * Aggregate level:
	 gen ilo_dsb_aggregate=.
		 replace ilo_dsb_aggregate=2 if inlist(b4_01,1,2)	     // With disability
		 replace ilo_dsb_aggregate=2 if inlist(b4_03,1,2)	     // With disability
		 replace ilo_dsb_aggregate=2 if inlist(b4_05,1,2)	     // With disability
		 replace ilo_dsb_aggregate=2 if inlist(b4_07,1,2)	     // With disability
		 replace ilo_dsb_aggregate=2 if inlist(b4_09,1,2)	     // With disability
		 replace ilo_dsb_aggregate=1 if ilo_dsb_aggregate==.     // No difficulty
		  		 label def dsb_lab 1 "1 - Persons without disability" 2 "2 - Persons with disability" 
				 label val ilo_dsb_aggregate dsb_lab
				 label var ilo_dsb_aggregate "Disability status (Aggregate)"
				
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
* Comment: - wap = 15+ 

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
* Comment:  - Employment comprises those working for wage/salariey, those having any informal 
*             activity, casual work, business (agricultural or non-agricultural) and those 
*             working without pay. It does not include subsistence farmers (part f in section 
*             c1), because if they were included, the percentage of employed people without 
*             information for most of the variables from this point on would be around 50%.
*           - Unemployment includes people not in employment and who took any action to look for
*             work of any type in the last 7 days or between a week and four weeks ago (not 
*             including people looking for a job over four weeks ago). It does not take into account 
*             availability becuase it is not asked (note to value: T5:1429).
		
	gen ilo_lfs=.
		replace ilo_lfs=1 if c1a01==1 & ilo_wap==1                              // Employed: wage jobs (part a section c1)
		replace ilo_lfs=1 if c1b01==1 & ilo_wap==1                              // Employed: informal sector activities (part b section c1)
		replace ilo_lfs=1 if c1c01==1 & ilo_wap==1                              // Employed: casual labour (part c section c1)
		replace ilo_lfs=1 if c1d01==1 & ilo_wap==1                              // Employed: household business (part d section c1)
		replace ilo_lfs=1 if c1e01==1 & ilo_wap==1                              // Employed: household agricultural business (part e section c1)
		replace ilo_lfs=1 if c1g01==1 & c1g02!=0 & ilo_wap==1                   // Employed: work without pay (part g section c1)
		replace ilo_lfs=2 if ilo_lfs!=1 & inlist(c2_03,1,2) & ilo_wap==1        // Unemployed: looking for a job (last 7 days 1-4 weeks)
		replace ilo_lfs=3 if !inlist(ilo_lfs,1,2) & ilo_wap==1                  // Outside the labour force
				label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside the Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Employed people are classified as multiple job holders if:
*            1. One of the variables related to the number of jobs equals 2
*            2. The answer to the variables related to the number of jobs equals 1 in two
*            or more variables that ask for work.

	gen ilo_mjh=.
		replace ilo_mjh=2 if (c1a_jobs==2 | c1b_acts==2 | c1c_acts==2 | c1d_acts==2 | c1e_acts==2) & ilo_lfs==1
		replace ilo_mjh=2 if (c1a_jobs==1 & (c1b_acts==1 | c1c_acts==1 | c1d_acts==1 | c1e_acts==1 | c1g01==1)) & ilo_lfs==1
		replace ilo_mjh=2 if (c1b_acts==1 & (c1c_acts==1 | c1d_acts==1 | c1e_acts==1 | c1g01==1)) & ilo_lfs==1
		replace ilo_mjh=2 if (c1c_acts==1 & (c1d_acts==1 | c1e_acts==1 | c1g01==1)) & ilo_lfs==1
		replace ilo_mjh=2 if (c1d_acts==1 & (c1e_acts==1 | c1g01==1)) & ilo_lfs==1
		replace ilo_mjh=2 if (c1e_acts==1 & c1g01==1) & ilo_lfs==1
		replace ilo_mjh=1 if ilo_mjh!=2 & ilo_lfs==1
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
* Comment: - The direct question is not asked, but according to the division of the modules,
*            only employees could be identified (informal, casual, agricultural or 
*            non-agricultural business or without pay workers could be either their own or other
*            place/business and therefore not identifiable). Thus, only the aggregate categories 
*            can be difined (employees and not classifiable ba status).
	
	* MAIN JOB:
	* Aggregate categories 
			gen ilo_job1_ste_aggregate=.
				replace ilo_job1_ste_aggregate=1 if c1a01==1 & ilo_lfs==1				       // Employees
				*replace ilo_job1_ste_aggregate=2 if 				                           // Self-employed
				replace ilo_job1_ste_aggregate=3 if ilo_job1_ste_aggregate!=1 & ilo_lfs==1	   // Not elsewhere classified
						lab def ste_aggr_lab 1 "1 - Employees" 2 "2 - Self-employed" 3 "3 - Not elsewhere classified"
					    lab val ilo_job1_ste_aggregate ste_aggr_lab
					    label var ilo_job1_ste_aggregate "Status in employment (Aggregate) - main job" 

		
	* SECOND JOB:
	* Aggregate categories 
			gen ilo_job2_ste_aggregate=.
				replace ilo_job2_ste_aggregate=1 if c1a01==1 & ilo_mjh==2				       // Employees
				*replace ilo_job2_ste_aggregate=2 if 	                                       // Self-employed
				replace ilo_job2_ste_aggregate=3 if ilo_job2_ste_aggregate!=1 & ilo_mjh==2	   // Not elsewhere classified
					lab val ilo_job2_ste_aggregate ste_aggr_lab
					label var ilo_job2_ste_aggregate "Status in employment (Aggregate) - second job" 
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - National classification (PNGSIC) ensures comparability of information because its
*            structure is developed based on ISIC Rev. 3.
*          - Workers without pay do not have the economic activity at 2 digit-level and therefore
*            are classified under "not elsewhere classified" at 1 digit-level and aggregate level.
	
  append using `labels', gen(lab)
  * use value label from this variable, afterwards drop everything related to this append
			
  * MAIN JOB:
  * ISIC Rev. 3 - 2 digit-level
    gen ilo_job1_eco_isic3_2digits = .
        replace ilo_job1_eco_isic3_2digits = c1a03_1 if c1a01==1 & ilo_lfs==1                                   // Wage jobs
	    replace ilo_job1_eco_isic3_2digits = c1b03_1 if c1b01==1 & ilo_job1_eco_isic3_2digits==. & ilo_lfs==1   // Informal sector
		replace ilo_job1_eco_isic3_2digits = c1c03_1 if c1c01==1 & ilo_job1_eco_isic3_2digits==. & ilo_lfs==1   // Casual labour
		replace ilo_job1_eco_isic3_2digits = c1d03_1 if c1d01==1 & ilo_job1_eco_isic3_2digits==. & ilo_lfs==1   // Household business
		replace ilo_job1_eco_isic3_2digits = c1e03_1 if c1e01==1 & ilo_job1_eco_isic3_2digits==. & ilo_lfs==1   // Household agricultural business
 	            lab values ilo_job1_eco_isic3_2digits isic3_2digits
	            lab var ilo_job1_eco_isic3_2digits "Economic activity (ISIC Rev. 3), 2 digit level - main job"
  
  * ISIC Rev. 3.1 - 1 digit-level
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
		replace ilo_job1_eco_isic3=18 if ilo_job1_eco_isic3==. & ilo_lfs==1
			    lab val ilo_job1_eco_isic3 isic3
			    lab var ilo_job1_eco_isic3 "Economic activity (ISIC Rev. 3.1)"
			
  * Primary activity
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
			    lab var ilo_job1_eco_aggregate "Economic activity (Aggregate)"
		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_job1_ocu_isco88') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment: - National classification is based on ISCO-88.
*          - Work without pay do not have the occupation at 2 digit-level and therefore
*            are classified under "not elsewhere classified" at 1 digit-level and aggregate level.


   * MAIN JOB
   * Two digit-level
   gen ilo_job1_ocu_isco88_2digits = .
       replace ilo_job1_ocu_isco88_2digits = c1a02_1 if c1a01==1 & ilo_lfs==1                                   // Wage jobs
	   replace ilo_job1_ocu_isco88_2digits = c1b02_1 if c1b01==1 & ilo_job1_ocu_isco88_2digits==. & ilo_lfs==1  // Informal sector
	   replace ilo_job1_ocu_isco88_2digits = c1c02_1 if c1c01==1 & ilo_job1_ocu_isco88_2digits==. & ilo_lfs==1  // Casual labour
	   replace ilo_job1_ocu_isco88_2digits = c1d02_1 if c1d01==1 & ilo_job1_ocu_isco88_2digits==. & ilo_lfs==1  // Household business
	   replace ilo_job1_ocu_isco88_2digits = c1e02_1 if c1e01==1 & ilo_job1_ocu_isco88_2digits==. & ilo_lfs==1  // Household agricultural business
	           lab values ilo_job1_ocu_isco88_2digits isco88_2digits
	           lab var ilo_job1_ocu_isco88_2digits "Occupation (ISCO-88), 2 digit level - main job"
			
    * One digit-level
	gen ilo_job1_ocu_isco88=.
	    replace ilo_job1_ocu_isco88=11 if inlist(ilo_job1_ocu_isco88_2digits,98,.) & ilo_lfs==1                      // Not elsewhere classified
		replace ilo_job1_ocu_isco88=int(ilo_job1_ocu_isco88_2digits/10) if (ilo_job1_ocu_isco88==. & ilo_lfs==1)     // The rest of the occupations
		replace ilo_job1_ocu_isco88=10 if (ilo_job1_ocu_isco88==0 & ilo_lfs==1)                                      // Armed forces
		replace ilo_job1_ocu_isco88=11 if ilo_job1_ocu_isco88==. & ilo_lfs==1                                        // Not elsewhere classified
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
				lab var ilo_job1_ocu_aggregate "Occupation (Aggregate) - main job"				
				
    * Skill level				
    gen ilo_job1_ocu_skill=.
	    replace ilo_job1_ocu_skill=1 if ilo_job1_ocu_isco88==9                   // Low
		replace ilo_job1_ocu_skill=2 if inlist(ilo_job1_ocu_isco88,4,5,6,7,8)    // Medium
		replace ilo_job1_ocu_skill=3 if inlist(ilo_job1_ocu_isco88,1,2,3)        // High
		replace ilo_job1_ocu_skill=4 if inlist(ilo_job1_ocu_isco88,10,11)        // Not elsewhere classified
				lab def ocu_skill_lab 1 "1 - Skill level 1 (low)" 2 "2 - Skill level 2 (medium)" 3 "3 - Skill levels 3 and 4 (high)" 4 "4 - Not elsewhere classified"
			    lab val ilo_job1_ocu_skill ocu_skill_lab
			    lab var ilo_job1_ocu_skill "Occupation (Skill level) - main job"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_job1_ins_sector') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment: - The sector is only asked in part A (wage jobs) in section c1 and thus the rest 
*            of employed people are classified under private.
*          - Public: the government public sector, army and state owned eterprise.
*   	   - Private: The rest.

	* MAIN JOB:
	gen ilo_job1_ins_sector=.
	    replace ilo_job1_ins_sector=1 if inlist(c1a05_1,1,2,4) & ilo_lfs==1     // Wage jobs
		replace ilo_job1_ins_sector=2 if ilo_job1_ins_sector!=1 & ilo_lfs==1	// Private
				lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private" 
				lab values ilo_job1_ins_sector ins_sector_lab
				lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities - main job"
	
	* SECOND JOB:
	gen ilo_job2_ins_sector=.
	    replace ilo_job2_ins_sector=1 if inlist(c1a05_2,1,2,4) & ilo_mjh==2     // Wage jobs
		replace ilo_job2_ins_sector=2 if ilo_job2_ins_sector!=1 & ilo_mjh==2	// Private
				lab values ilo_job2_ins_sector ins_sector_lab
				lab var ilo_job2_ins_sector "Institutional sector (private/public) of economic activities - second job"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job1_job_contract') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
* Comment: - No information available

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Formal / Informal Economy ('ilo_job1_ife_prod' 'ilo_job1_ife_nature') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
* Comment: - Not computed due to the lack of minimum information required for non-employees.

/*	Useful questions:
			- Institutional sector: c1a05_1 (only asked to wage workers);
			- Destination of production: Given the structure of the questionnaire only part F in section C1 refers
			  to subsistence farming activities (own-consumption), and it is not taken into account in employment.
			  It is not asked for the rest of the parts.
			- Households identification: parts D and E in section C1 divide a priori people working in household
			  business (agricultural or non-agricultural). It could also be identify by using isic and isco:		  
			  ilo_job1_eco_isic3_2digits==95 (0.94%)/ ilo_job1_ocu_isco88_2digits==62 (9.32%) (to check: percentage, both using weights)
			- Bookkeeping: Not asked.
			- Registration: c1d08_1 (only asked in part D (non-agricultural household business) in section C1)
			- Status in employment: ilo_job1_ste_aggregate
			- Social security: Not asked.
			- Place of work: c1a04_1 (wage workers), c1b04_1 (informal), c1c04_1 (casual), c1g04 (work without pay)
			- Size: c1a06_1 (only asked to wage workers)
			- Paid annual leave: Not asked.
			- Paid sick leave: Not asked.
			
*/			
		  
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Hours of work ('ilo_how') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment: - Due to the structure of the questionnaire, it is not possible to correctly compute 
*            it.

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job1_job_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
* Comment: - Not possible to compute it due to the lack of information on the total hours worked.

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Monthly labour related income ('ilo_job1_lri') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
* Comments: - Not computed due to the amount of all possible combinations or cases that
*             would have to be taken into account to properly define it.
			
***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_joball_tru') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
* Comment: - Not possible to compute it due to the lack of information on the total hours usually
*            worked

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupational injury ('ilo_joball_inj') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
* Comment: - No information available.

*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Days lost due to cases of occupational injury ('ilo_joball_oi_day') [done]
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
* Comment: - No information available.

	
***********************************************************************************************
*			PART 3.3. UNEMPLOYMENT: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Category of unemployment ('ilo_cat_une') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: 

		gen ilo_cat_une=.
			replace ilo_cat_une=1 if c2_05==1 & ilo_lfs==2 			            // Previously employed
			replace ilo_cat_une=2 if c2_05==2 & ilo_lfs==2 			            // Seeking first job
			replace ilo_cat_une=3 if ilo_lfs==2 & !inlist(ilo_cat_une,1,2)	    // Unkown
				lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
				lab val ilo_cat_une cat_une_lab
				lab var ilo_cat_une "Category of unemployment"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comments: - Even though the question "when did you last take any action to look for work (or
*             more work) of any type" is asked, the categories do not allow the definition
*             of either detailed nor aggregated variable.

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic3')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
* Comment: - National classification is based on ISIC Rev.3 (2 digit-level are available).

  * ISIC Rev. 3 - 2 digit-level
  gen ilo_preveco_isic3_2digits = c2_07 if ilo_lfs==2 & ilo_cat_une==1
	  lab values ilo_preveco_isic3_2digits isic3_2digits
	  lab var ilo_preveco_isic3_2digits "Previous economic activity (ISIC Rev. 3), 2 digit level"
	  
  * ISIC Rev. 3.1 - 1 digit-level
  gen ilo_preveco_isic3=.
	  replace ilo_preveco_isic3=1 if inrange(ilo_preveco_isic3_2digits,1,2)
	  replace ilo_preveco_isic3=2 if ilo_preveco_isic3_2digits==5
	  replace ilo_preveco_isic3=3 if inrange(ilo_preveco_isic3_2digits,10,14)
	  replace ilo_preveco_isic3=4 if inrange(ilo_preveco_isic3_2digits,15,37)
	  replace ilo_preveco_isic3=5 if inrange(ilo_preveco_isic3_2digits,40,41)
	  replace ilo_preveco_isic3=6 if ilo_preveco_isic3_2digits==45
	  replace ilo_preveco_isic3=7 if inrange(ilo_preveco_isic3_2digits,50,52)
	  replace ilo_preveco_isic3=8 if ilo_preveco_isic3_2digits==55
	  replace ilo_preveco_isic3=9 if inrange(ilo_preveco_isic3_2digits,60,64)
	  replace ilo_preveco_isic3=10 if inrange(ilo_preveco_isic3_2digits,65,67)
	  replace ilo_preveco_isic3=11 if inrange(ilo_preveco_isic3_2digits,70,74)
	  replace ilo_preveco_isic3=12 if ilo_preveco_isic3_2digits==75
	  replace ilo_preveco_isic3=13 if ilo_preveco_isic3_2digits==80
	  replace ilo_preveco_isic3=14 if ilo_preveco_isic3_2digits==85
	  replace ilo_preveco_isic3=15 if inrange(ilo_preveco_isic3_2digits,90,93)
	  replace ilo_preveco_isic3=16 if ilo_preveco_isic3_2digits==95
	  replace ilo_preveco_isic3=17 if ilo_preveco_isic3_2digits==99
	  replace ilo_preveco_isic3=18 if ilo_preveco_isic3_2digits==. & ilo_lfs==2 & ilo_cat_une==1
			  lab val ilo_preveco_isic3 isic3
			  lab var ilo_preveco_isic3 "Previous economic activity (ISIC Rev. 3.1)"
			  
  * Primary activity
  gen ilo_preveco_aggregate=.
	  replace ilo_preveco_aggregate=1 if inlist(ilo_preveco_isic3,1,2)
	  replace ilo_preveco_aggregate=2 if ilo_preveco_isic3==4
	  replace ilo_preveco_aggregate=3 if ilo_preveco_isic3==6
	  replace ilo_preveco_aggregate=4 if inlist(ilo_preveco_isic3,3,5)
	  replace ilo_preveco_aggregate=5 if inrange(ilo_preveco_isic3,7,11)
	  replace ilo_preveco_aggregate=6 if inrange(ilo_preveco_isic3,12,17)
	  replace ilo_preveco_aggregate=7 if ilo_preveco_isic3==18
			  lab val ilo_preveco_aggregate eco_aggr_lab
			  lab var ilo_preveco_aggregate "Previous economic activity (Aggregate)"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
* Comment: - National classification is based on ISCO-88 (2 digit-level available).

    * ISCO-88 2 digits-level
    gen ilo_prevocu_isco88_2digits = c2_06 if ilo_lfs==2 & ilo_cat_une==1
	    lab val ilo_prevocu_isco88_2digits isco88_2digits
	    lab var ilo_prevocu_isco88_2digits "Previous occupation (ISCO-88), 2 digit level"
	   
    * One digit-level
	gen ilo_preveco_isco88=.
	    replace ilo_preveco_isco88=11 if inlist(ilo_prevocu_isco88_2digits,98,.) & ilo_lfs==2 & ilo_cat_une==1                      //Not elsewhere classified
		replace ilo_preveco_isco88=int(ilo_prevocu_isco88_2digits/10) if (ilo_preveco_isco88==. & ilo_lfs==2 & ilo_cat_une==1)      //The rest of the occupations
		replace ilo_preveco_isco88=10 if (ilo_preveco_isco88==0 & ilo_lfs==2 & ilo_cat_une==1)                                      //Armed forces
				lab val ilo_preveco_isco88 isco88
				lab var ilo_preveco_isco88 "Previous occupation (ISCO-88)"

	* Aggregate:			
    gen ilo_prevocu_aggregate=.
	    replace ilo_prevocu_aggregate=1 if inrange(ilo_preveco_isco88,1,3)   
	    replace ilo_prevocu_aggregate=2 if inlist(ilo_preveco_isco88,4,5)
	    replace ilo_prevocu_aggregate=3 if inlist(ilo_preveco_isco88,6,7)
	    replace ilo_prevocu_aggregate=4 if ilo_preveco_isco88==8
	    replace ilo_prevocu_aggregate=5 if ilo_preveco_isco88==9
	    replace ilo_prevocu_aggregate=6 if ilo_preveco_isco88==10
	    replace ilo_prevocu_aggregate=7 if ilo_preveco_isco88==11
			    lab val ilo_prevocu_aggregate ocu_aggr_lab
			    lab var ilo_prevocu_aggregate "Previous occupation (Aggregate)"	
		
	* Skill level
	gen ilo_prevocu_skill=.
	    replace ilo_prevocu_skill=1 if ilo_preveco_isco88==9                   // Low
		replace ilo_prevocu_skill=2 if inlist(ilo_preveco_isco88,4,5,6,7,8)    // Medium
		replace ilo_prevocu_skill=3 if inlist(ilo_preveco_isco88,1,2,3)        // High
		replace ilo_prevocu_skill=4 if inlist(ilo_preveco_isco88,10,11)        // Not elsewhere classified
			    lab val ilo_prevocu_skill ocu_skill_lab
			    lab var ilo_prevocu_skill "Previous occupation (Skill level)"
				

***********************************************************************************************
*			PART 3.3. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment:	- Not computed because availability is not asked.

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reason for not seeking job ('ilo_olf_reason') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment: - Information not available.
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seeker ('ilo_dis')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment: - Not possible to compute it due to the lack of information required.

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training ('ilo_neet') [done]
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
	
	  /* Save file only containing ilo_* variables*/
	
		keep ilo*

		save ${country}_${source}_${time}_ILO, replace

	
	
	
