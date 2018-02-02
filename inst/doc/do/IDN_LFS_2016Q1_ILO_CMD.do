* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Indonesia
* DATASET USED: Indonesia LFS
* NOTES: 
* Files created: Standard variables on LFS Indonesia
* Authors: Marylène Escher
* Who last updated the file: Podjanin
* Starting Date: 29 July 2016
* Last updated: 17 May 2017
***********************************************************************************************

***********************************************************************************************
***********************************************************************************************

* 			1. SET UP WORK DIRECTORY, FILE NAME, VARIABLES AND FUNCTIONS

***********************************************************************************************
***********************************************************************************************

clear all 

set more off
global path "J:\COMMON\STATISTICS\DPAU\MICRO"
global country "IDN"
global source "LFS"
global time "2016Q1"
global inputFile "SAK0216.dta"
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
		

* Load original dataset:
		
cd "$inpath"

	use "$inputFile", clear	

	rename *, lower
	
***********************************************************************************************

* Create help variables for the time period considered
	
	gen time = "${time}"
	split time, gen(time_) parse(Q)
	
	capture confirm variable time_2 
	
		if !_rc {
	
	rename (time_1 time_2) (year quarter)
		destring year quarter, replace
		}
		
	else {
	
	rename time_1 year
	destring year, replace
		}
		
**********************************************************************************************
		
	
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
	

	gen ilo_key=_n
		lab var ilo_key "Key unique identifier per individual"		
		

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sample Weight ('ilo_wgt') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	

	gen ilo_wgt=weight
		lab var ilo_wgt "Sample weight"		
		
		
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time period ('ilo_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*

	gen ilo_time=1
		lab def lab_time 1 "${time}" 
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


	gen ilo_geo=klasifik
		lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural"
		lab val ilo_geo ilo_geo_lab
		lab var ilo_geo "Geographical coverage"	
	
	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------


	gen ilo_sex=b4_k4
		lab def ilo_sex_lab 1 "1 - Male" 2 "2 - Female"
		lab var ilo_sex "Sex"
		lab val ilo_sex ilo_sex_lab

		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*	
	if time=="2016Q1" {
	gen ilo_age=b4_k5
		}
		
	if time=="2016Q3" {	
	gen ilo_age=b4_k6
		}
				
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
		
/* ISCED 11 mapping: based on the mapping developped by UNESCO
					http://www.uis.unesco.org/Education/ISCEDMappings/Pages/default.aspx
					http://www.uis.unesco.org/Education/Documents/isced-2011-en.pdf 	*/

* Note that according to the definition, the highest level being CONCLUDED is being considered

	* note that no option "no schooling" included in questionnaire --> answer "not yet completed primary school" considered as early childhood education

	gen ilo_edu_isced11=.
		replace ilo_edu_isced11=1 if b4_k8==1		  				// No schooling
		replace ilo_edu_isced11=2 if b5_r1a==1 & b4_k8!=1			// Early childhood education
		replace ilo_edu_isced11=3 if inlist(b5_r1a,2,3,4) 			// Primary education
		replace ilo_edu_isced11=4 if inlist(b5_r1a,5,6,7)		   	// Lower secondary education
		replace ilo_edu_isced11=5 if inlist(b5_r1a,8,9,10,11)   	// Upper secondary education
		*replace ilo_edu_isced11=6 if 					  			// Post-secondary non-tertiary
		replace ilo_edu_isced11=7 if inlist(b5_r1a,12,13) 			// Short-cycle tertiary education
		replace ilo_edu_isced11=8 if b5_r1a==14  					// Bachelor or equivalent
		replace ilo_edu_isced11=9 if b5_r1a==15  					// Master's or equivalent level
		replace ilo_edu_isced11=10 if b5_r1a==16					// Doctoral or equivalent level
		replace ilo_edu_isced11=11 if ilo_edu_isced11==.			// Not elsewhere classified
			label def isced_11_lab 1 "X - No schooling" 2 "0 - Early childhood education" 3 "1 - Primary education" 4 "2 - Lower secondary education" 5 "3 - Upper secondary education" ///
								6 "4 - Post-secondary non-tertiary education" 7 "5 - Short-cycle tertiary education" 8 "6 - Bachelor's or equivalent level" 9 "7 - Master's or equivalent level" ///
								10 "8 - Doctoral or equivalent level" 11 "9 - Not elsewhere classified"
			label val ilo_edu_isced11 isced_11_lab
			lab var ilo_edu_isced11 "Education (ISCED 11)"	
	
	/* NOTE: the category Master's or equivalent also includes the Doctral or equivalent level as there is no distinction between 
			these two categories in the questionnaire. */
			
		
	gen ilo_edu_aggregate=.
		replace ilo_edu_aggregate=1 if inlist(ilo_edu_isced11,1,2)  	// Less than basic
		replace ilo_edu_aggregate=2 if inlist(ilo_edu_isced11,3,4)		// Basic
		replace ilo_edu_aggregate=3 if inlist(ilo_edu_isced11,5,6)		// Intermediate
		replace ilo_edu_aggregate=4 if inrange(ilo_edu_isced11,7,10)	// Advanced
		replace ilo_edu_aggregate=5 if ilo_edu_isced11==11				// Level not stated
		
			label def edu_aggr_lab 1 "1 - Less than basic" 2 "2 - Basic" 3 "3 - Intermediate" 4 "4 - Advanced" 5 "5 - Level not stated"
			label val ilo_edu_aggregate edu_aggr_lab
			label var ilo_edu_aggregate "Education (Aggregate levels)"
		
		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education attendance ('ilo_edu_attendance') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_edu_attendance=.
		replace ilo_edu_attendance=1 if b4_k8==2				// Attending
		replace ilo_edu_attendance=2 if inlist(b4_k8,1,3)		// Not attending
			label def edu_att_lab 1 "1 - Attending" 2 "2 - Not attending"
			label val ilo_edu_attendance edu_att_lab
			label var ilo_edu_attendance "Education (Attendance)

			* The category "Attending" includes as well people going to non formal schools.

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Disability status ('ilo_dsb') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

* Comment: If "some" disability, considered as without disability


		* b5_r4a: Seeing
		* b5_r4b: Hearing
		* b5_r4c: Walking/climbing stairs
		* b5_r4d: Using/moving fingers/hands
		* b5_r4e: Talking and understanding/communicating with others
		* b5_r4f: Others (ex: remembering/concentrating, behaviour/emotional, self-caring, etc)
	
				
	gen ilo_dsb_aggregate=.
		replace ilo_dsb_aggregate=1 if inlist(b5_r4a,1,2) & inlist(b5_r4b,4,5) &  inlist(b5_r4c,1,2) &  inlist(b5_r4d,4,5) & inlist(b5_r4e,1,2) & inlist(b5_r4f,4,5)
		replace ilo_dsb_aggregate=2 if b5_r4a==3 | b5_r4b==6 | b5_r4c==3 | b5_r4d==6 | b5_r4e==3 | b5_r4f==6
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
*			Working age population ('ilo_wap') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*           
* Comment: wap = 15+ 

	gen ilo_wap=.
		replace ilo_wap=1 if ilo_age>=15 & ilo_age!=.
		replace ilo_wap=0 if ilo_age<15
			label var ilo_wap "Working age population"

	drop ilo_age
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Labour Force Status ('ilo_lfs') [done - but check again]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Unemployment - check with Yves whether question 17b should also be considered as availability criterion or not 
	* see whether to include question 16 b for future starters (given that only asked to people answering options 1 or 2 in quest. 16a)

	gen ilo_lfs=.
		replace ilo_lfs=1 if b5_r5a1==1 | b5_r6==1 																					// Employed
		replace ilo_lfs=2 if ilo_lfs!=1 & (b5_r11==1 | b5_r12==1 | inlist(b5_r16a,1,2) | b5_r16b==1) & (b5_r17a==1 | b5_r17b==1)  	// Unemployed
		replace ilo_lfs=3 if !inlist(ilo_lfs,1,2) & ilo_wap==1  																	// Outside the labour force
				replace ilo_lfs=. if ilo_wap!=1
				label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside the Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status"

				
/* NOTE: national definition of unemployment (in the LFS report) is different from the ILO one: the
		 Indonesian definition includes as well the discouraged job-seekers and does not consider the availability to work.  */

			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_mjh=.
		replace ilo_mjh=1 if b5_r34==2
		replace ilo_mjh=2 if b5_r34==1
				replace ilo_mjh=. if ilo_lfs!=1
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


		gen ilo_job1_ste_icse93=.
			replace ilo_job1_ste_icse93=1 if inlist(b5_r23,4,5,6)					// Employees
			replace ilo_job1_ste_icse93=2 if b5_r23==3								// Employers
			replace ilo_job1_ste_icse93=3 if inlist(b5_r23,1,2)						// Own-account workers
			*replace ilo_job1_ste_icse93=4 if										// Producer cooperatives
			replace ilo_job1_ste_icse93=5 if b5_r23==7								// Contributing family workers
			replace ilo_job1_ste_icse93=6 if ilo_job1_ste_icse93==. & ilo_lfs==1	// Not classifiable
			replace ilo_job1_ste_icse93=. if ilo_lfs!=1				
				label def label_ilo_ste_icse93 1 "1 - Employees" 2 "2 - Employers" 3 "3 - Own-account workers"  ///
											   4 "4 - Members of producers cooperatives" 5 "5 - Contributing family workers" ///
											   6 "6 - Workers not classifiable by status"
				label val ilo_job1_ste_icse93 label_ilo_ste_icse93
				label var ilo_job1_ste_icse93 "Status in employment (ICSE 93)"
			
			/*NOTES: The category employees includes as well the CASUAL employees
					 employers assisted by TEMPORARY workers/unpaid workers are classified under own-account workers	*/

	
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


/* National classification is based on ISIC 4 (at a 2 digit-level the national classification 
			is identic to ISIC Rev. 4) */

	
	* Import value labels
	
		append using `labels'
		
		* 2016Q1 dataset includes classification at the three digit level --> aligned with ISIC Rev. 4 
			* 2016Q3 does not include any info at the three digit level and mapping for other variable missing --> don't define variable for the moment
		
		if time=="2016Q1" {
		
			gen indu_code_prim=int(b5_r19_kbli2015_3/10) if ilo_lfs==1	
		
		
		* MAIN JOB:
			
			* ISIC Rev. 4 - 2 digit
			/* For people without work, the economic sector is coded as 0 in the dataset */
				gen ilo_job1_eco_isic4_2digits=.
					replace ilo_job1_eco_isic4_2digits=indu_code_prim 
					replace ilo_job1_eco_isic4_2digits=. if ilo_lfs!=1
					lab values ilo_job1_eco_isic4_2digits isic4_2digits
					lab var ilo_job1_eco_isic4_2digits "Economic activity (ISIC Rev. 4), 2 digit level - main job"
					
			* ISIC Rev. 4 - 1 digit
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
					replace ilo_job1_eco_isic4=22 if ilo_job1_eco_isic4==. & ilo_lfs==1 
					replace ilo_job1_eco_isic4=. if ilo_lfs!=1
						lab val ilo_job1_eco_isic4 isic4
						lab var ilo_job1_eco_isic4 "Economic activity (ISIC Rev. 4) - main job"

					
					
			* Aggregated level 
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
						lab var ilo_job1_eco_aggregate "Economic activity (Aggregate) - main job" 



		* SECOND JOB:
			
			/* Economic activity of the second job is only available at a 5 digit level. */
					
			* ISIC Rev. 4 - 2 digit
			gen indu_code_2dig=int(b5_r35_kbli2015_3/10) if ilo_mjh==2 
			
				gen ilo_job2_eco_isic4_2digits=.
					replace ilo_job2_eco_isic4_2digits=indu_code_2dig if indu_code_2dig>0
					lab values ilo_job2_eco_isic4_2digits isic4_2digits
					lab var ilo_job2_eco_isic4_2digits "Economic activity (ISIC Rev. 4), 2 digit level - second job"
					
			* ISIC Rev. 4 - 1 digit
				gen ilo_job2_eco_isic4=.
					replace ilo_job2_eco_isic4=1 if inrange(ilo_job2_eco_isic4_2digits,1,3)
					replace ilo_job2_eco_isic4=2 if inrange(ilo_job2_eco_isic4_2digits,5,9)
					replace ilo_job2_eco_isic4=3 if inrange(ilo_job2_eco_isic4_2digits,10,33)
					replace ilo_job2_eco_isic4=4 if ilo_job2_eco_isic4_2digits==35
					replace ilo_job2_eco_isic4=5 if inrange(ilo_job2_eco_isic4_2digits,36,39)
					replace ilo_job2_eco_isic4=6 if inrange(ilo_job2_eco_isic4_2digits,41,43)
					replace ilo_job2_eco_isic4=7 if inrange(ilo_job2_eco_isic4_2digits,45,47)
					replace ilo_job2_eco_isic4=8 if inrange(ilo_job2_eco_isic4_2digits,49,53)
					replace ilo_job2_eco_isic4=9 if inrange(ilo_job2_eco_isic4_2digits,55,56)
					replace ilo_job2_eco_isic4=10 if inrange(ilo_job2_eco_isic4_2digits,58,63)
					replace ilo_job2_eco_isic4=11 if inrange(ilo_job2_eco_isic4_2digits,64,66)
					replace ilo_job2_eco_isic4=12 if ilo_job2_eco_isic4_2digits==68
					replace ilo_job2_eco_isic4=13 if inrange(ilo_job2_eco_isic4_2digits,69,75)
					replace ilo_job2_eco_isic4=14 if inrange(ilo_job2_eco_isic4_2digits,77,82)
					replace ilo_job2_eco_isic4=15 if ilo_job2_eco_isic4_2digits==84
					replace ilo_job2_eco_isic4=16 if ilo_job2_eco_isic4_2digits==85
					replace ilo_job2_eco_isic4=17 if inrange(ilo_job2_eco_isic4_2digits,86,88)
					replace ilo_job2_eco_isic4=18 if inrange(ilo_job2_eco_isic4_2digits,90,93)
					replace ilo_job2_eco_isic4=19 if inrange(ilo_job2_eco_isic4_2digits,94,96)
					replace ilo_job2_eco_isic4=20 if inrange(ilo_job2_eco_isic4_2digits,97,98)
					replace ilo_job2_eco_isic4=21 if ilo_job2_eco_isic4_2digits==99
					replace ilo_job2_eco_isic4=22 if ilo_job2_eco_isic4==. & ilo_mjh==2
						lab val ilo_job2_eco_isic4 isic4
						lab var ilo_job2_eco_isic4 "Economic activity (ISIC Rev. 4) - second job"

					
			* Aggregated level 
				gen ilo_job2_eco_aggregate=.
					replace ilo_job2_eco_aggregate=1 if ilo_job2_eco_isic4==1
					replace ilo_job2_eco_aggregate=2 if ilo_job2_eco_isic4==3
					replace ilo_job2_eco_aggregate=3 if ilo_job2_eco_isic4==6
					replace ilo_job2_eco_aggregate=4 if inlist(ilo_job2_eco_isic4,2,4,5)
					replace ilo_job2_eco_aggregate=5 if inrange(ilo_job2_eco_isic4,7,14)
					replace ilo_job2_eco_aggregate=6 if inrange(ilo_job2_eco_isic4,15,21)
					replace ilo_job2_eco_aggregate=7 if ilo_job2_eco_isic4==22
						lab val ilo_job2_eco_aggregate eco_aggr_lab
						lab var ilo_job2_eco_aggregate "Economic activity (Aggregate) - second job" 

		drop indu_code_2dig
					
					}
					
					

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_job1_ocu_isco88') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
	
	/* National classification of occupations (KBJI 2002) is based on ISCO 88.
	   Occupation only available for the main job.
	   Most recent classification only at a 1-digit level. 
	   
	   NOTE: the missing values are coded as 0, which is the same code as the occupation
			 in the armed forces. As we cannot guarantee that the 0 are actually working 
			 in the armed forces, we decided to code them as missing. */
	   
	   if time=="2016Q1" {

		* ISCO 88 - 1 digit
			gen ilo_job1_ocu_isco88=.
				replace ilo_job1_ocu_isco88=b5_r20_kbji2002 
				replace ilo_job1_ocu_isco88=10 if b5_r20_kbji2002==0
				replace ilo_job1_ocu_isco88=11 if ilo_job1_ocu_isco88==. & ilo_lfs==1
				replace ilo_job1_ocu_isco88=. if ilo_lfs!=1 
					lab def isco88_1dig_lab 1 "1 - Legislators, senior officials and managers" 2 "2 - Professionals" 3 "3 - Technicians and associate professionals" 4 "4 - Clerks" ///
											5 "5 - Service workers and shop and market sales workers" 6 "6 - Skilled agricultural and fishery workers" 7 "7 - Craft and related trades workers" ///
											8 "8 - Plant and machine operators, and assemblers" 9 "9 - Elementary occupations" 10 "0 - Armed forces" 11 "X - Not elsewhere classified"
					lab val ilo_job1_ocu_isco88 isco88
					lab var ilo_job1_ocu_isco88 "Occupation (ISCO-88) - Main job"	

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
					lab var ilo_job1_ocu_aggregate "Occupation (Aggregate) - Main job"	
	
					}
				
		* Drop the variables used for labelling occupation:	
			drop isco88_2digits isco88 isco08_2digits isco08 
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_job1_ins_sector') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
	
* Comment: 
	
	* Primary occupation
	
	gen ilo_job1_ins_sector=.
		replace ilo_job1_ins_sector=1 if inlist(b5_r31,1,2)
		replace ilo_job1_ins_sector=2 if ilo_job1_ins_sector==. & ilo_lfs==1
				replace ilo_job1_ins_sector=. if ilo_lfs!=1
			lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
			lab values ilo_job1_ins_sector ins_sector_lab
			lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities"
				

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Hours of work ('ilo_job1_how_actual') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
		
		
		* Main job -> consider variable setting a limit at 98 hours per week (in order to be coherent with the other datasets in the time series):
			
			gen ilo_job1_how_actual=b5_r22a 
				replace ilo_job1_how_actual=. if ilo_lfs!=1
					lab var ilo_job1_how_actual "Weekly hours actually worked in main job"
					
					
		* Hours usually worked 
	
		* Primary job
		
		gen ilo_job1_how_usual=b5_r22b
			replace ilo_job1_how_usual=. if ilo_lfs!=1
			lab var ilo_job1_how_usual "Weekly hours usually worked in main job"			
				
				
		* All jobs
		
		gen ilo_joball_how_actual=b5_r37a
			replace ilo_joball_how_actual=. if ilo_lfs!=1
			lab var ilo_joball_how_actual "Weekly hours actually worked in all jobs"
					
		* Usual hours worked: 
			
		gen ilo_joball_how_usual=b5_r37b
			replace ilo_joball_how_usual=. if ilo_lfs!=1
				lab var ilo_joball_how_usual "Weekly hours usually worked in all jobs"		
		
		
		* Weekly hours - bands
		
			* Primary occupation
			
			gen ilo_job1_how_actual_bands=.
				replace ilo_job1_how_actual_bands=1 if ilo_job1_how_actual==0
				replace ilo_job1_how_actual_bands=2 if inrange(ilo_job1_how_actual,1,14)
				replace ilo_job1_how_actual_bands=3 if inrange(ilo_job1_how_actual,15,29)
				replace ilo_job1_how_actual_bands=4 if inrange(ilo_job1_how_actual,30,34)
				replace ilo_job1_how_actual_bands=5 if inrange(ilo_job1_how_actual,35,39)
				replace ilo_job1_how_actual_bands=6 if inrange(ilo_job1_how_actual,40,48)
				replace ilo_job1_how_actual_bands=7 if ilo_job1_how_actual>=49 & ilo_job1_how_actual!=.
				replace ilo_job1_how_actual_bands=. if ilo_lfs!=1
					lab def how_bands_lab 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 
					lab val ilo_job1_how_actual_bands how_bands_lab
					lab var ilo_job1_how_actual_bands "Weekly hours actually worked bands in main job"
					
				
			* All occupations 	
					
		
			gen ilo_joball_how_actual_bands=.
				replace ilo_joball_how_actual_bands=1 if ilo_joball_how_actual==0
				replace ilo_joball_how_actual_bands=2 if inrange(ilo_joball_how_actual,1,14)
				replace ilo_joball_how_actual_bands=3 if inrange(ilo_joball_how_actual,15,29)
				replace ilo_joball_how_actual_bands=4 if inrange(ilo_joball_how_actual,30,34)
				replace ilo_joball_how_actual_bands=5 if inrange(ilo_joball_how_actual,35,39)
				replace ilo_joball_how_actual_bands=6 if inrange(ilo_joball_how_actual,40,48)
				replace ilo_joball_how_actual_bands=7 if ilo_joball_how_actual>=49 & ilo_joball_how_actual!=.
				replace ilo_joball_how_actual_bands=. if ilo_lfs!=1
					lab val ilo_joball_how_actual_bands how_bands_lab
					lab var ilo_joball_how_actual_bands "Weekly hours actually worked bands in all jobs"
		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job1_job_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
		
		
	/* The normal working time in the country is 35 hours (used as a threshold) 
	   As we only have the actual hours, the working time arrangement is assesed on 
	   the ACTUAL working hours of the reference week.  		*/
	
	
		* Main job:
			gen ilo_job1_job_time=.
				replace ilo_job1_job_time=1 if ilo_job1_how_actual<35 & ilo_job1_how_actual>0
				replace ilo_job1_job_time=2 if ilo_job1_how_actual>=35 & ilo_job1_how_actual!=.
				replace ilo_job1_job_time=3 if ilo_job1_how_actual==0 & ilo_lfs==1
				replace ilo_job1_job_time=. if ilo_lfs!=1
					lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
					lab val ilo_job1_job_time job_time_lab
					lab var ilo_job1_job_time "Job (Working time arrangement) - Main job"	
			
		
		* all jobs:
			gen ilo_joball_job_time=.
				replace ilo_joball_job_time=1 if ilo_joball_how_actual<35 & ilo_joball_how_actual>0
				replace ilo_joball_job_time=2 if ilo_joball_how_actual>=35 & ilo_joball_how_actual!=.
				replace ilo_joball_job_time=3 if ilo_joball_how_actual==0 & ilo_lfs==1
				replace ilo_joball_job_time=. if ilo_lfs!=1
					lab def joball_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
					lab val ilo_joball_job_time joball_time_lab
					lab var ilo_joball_job_time "Job (Working time arrangement) - All jobs"	
			
	
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job1_job_contract') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			

* Comment: oral agreements considered as temporary contracts // also if no contract available, considered as temporary agreement

	gen ilo_job1_job_contract=.
			replace ilo_job1_job_contract=1 if b5_r29==1
			replace ilo_job1_job_contract=2 if inlist(b5_r29,2,3,4)
			replace ilo_job1_job_contract=3 if ilo_job1_job_contract==. & ilo_job1_ste_aggregate==1
					replace ilo_job1_job_contract=. if ilo_job1_ste_aggregate!=1
				lab def job_contract_lab 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"
				lab val ilo_job1_job_contract job_contract_lab
				lab var ilo_job1_job_contract "Job (Type of contract)"
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Informal/Formal economy: Unit of production (ilo_job1_ife_prod) [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* 
* Comment: 
	
	  * Useful questions: b5_r31: Institutional sector
						* [b5_r25]: Destination of production (too vague - don't use)
						* b5_r24: Bookkeeping
						* [no info]: Registration
						* b5_r28d: Social security (Pension insurance)
						* (b5_r32): Location of workplace (not suited for our purposes)
						* [no info]: Size of enterprise
											
					
	gen ilo_job1_ife_prod=.
		replace ilo_job1_ife_prod=1 if (!inlist(b5_r31,1,2,3,7) & b5_r24==1) | (!inlist(b5_r31,1,2,3,7) & !inlist(b5_r24,1,2,3) & (ilo_job1_ste_aggregate==1 & b5_r28d!=4) | ilo_job1_ste_aggregate!=1)
		replace ilo_job1_ife_prod=2 if inlist(b5_r31,1,2,3) | (!inlist(b5_r31,1,2,3,7) & inlist(b5_r24,2,3)) | (!inlist(b5_r31,1,2,3,7) & !inlist(b5_r24,1,2,3) & ilo_job1_ste_aggregate==1 & b5_r28d==4) 
		replace ilo_job1_ife_prod=3 if b5_r31==7             							// ilo_job1_ocu_isco08_2digits==63 | ilo_job1_eco_isic3_2digits==95
		replace ilo_job1_ife_prod=4 if ilo_job1_ife_prod==. & ilo_lfs==1
				replace ilo_job1_ife_prod=. if ilo_lfs!=1
			lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 4 "4 - Not elsewhere classified"
			lab val ilo_job1_ife_prod ilo_ife_prod_lab
			lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"
			
					
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Informal/formal economy: nature of job (ilo_job1_ife_nature) [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: 

	gen ilo_job1_ife_nature=.
		replace ilo_job1_ife_nature=1 if ilo_job1_ste_icse93==5 | (inlist(ilo_job1_ste_icse93,1,6) & b5_r28d!=4) | (inlist(ilo_job1_ste_icse93,2,3,4) & inlist(ilo_job1_ife_prod,1,3))
		replace ilo_job1_ife_nature=2 if (inlist(ilo_job1_ste_icse93,1,6) & b5_r28d==4) | (inlist(ilo_job1_ste_icse93,2,3,4) & ilo_job1_ife_prod==2)
		replace ilo_job1_ife_nature=. if ilo_lfs!=1
			lab def ife_nature_lab 1 "1 - Persons with informal main job" 2 "2 - Persons with formal main job"
			lab val ilo_job1_ife_nature ife_nature_lab
			lab var ilo_job1_ife_nature "Informal / Formal Economy (Nature of job)"
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Monthly labour related income ('ilo_job1_lri') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
				
	
	/* NOTES:
	   In the questionnaire it is asked how much the person usually gets per month in cash or in goods.
	   The question is only asked for the main job.
	   Unit: local currency - Indonesian rupiah */

	   
			* Main job
				
				* Employees
					gen ilo_job1_lri_ees =.
						replace ilo_job1_lri_ees = b5_r26a + b5_r26b if ilo_job1_ste_aggregate==1
							lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"	
				
				* Self-employed: (employers not included)
					gen ilo_job1_lri_slf =.
						replace ilo_job1_lri_slf = b5_r26a + b5_r26b if ilo_job1_ste_aggregate==2 
							lab var ilo_job1_lri_slf "Monthly labour related income of self-employed in main job"	

		
***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_joball_tru') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
		
* Comment: take question 38b as availability criterion (check with Yves)

	gen ilo_joball_tru=1 if ilo_job1_job_time==1 & b5_r38a==1 & b5_r38b==1
		replace ilo_joball_tru=. if ilo_lfs!=1
			lab def tru_lab 1 "Time-related underemployment"
			lab val ilo_joball_tru tru_lab
			lab var ilo_joball_tru "Time-related underemployment"	

	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupational injury ('ilo_joball_inj') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
		
		* No question related to this topic in the questionnaire.
		


		
***********************************************************************************************
*			PART 3.3. UNEMPLOYMENT: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Category of unemployment ('ilo_cat_une') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	

		gen ilo_cat_une=.
			replace ilo_cat_une=1 if ilo_lfs==2 & b5_r40==1		// Previously employed
			replace ilo_cat_une=2 if ilo_lfs==2 & b5_r40==2		// Seeking first job
			replace ilo_cat_une=3 if ilo_lfs==2 & ilo_cat_une!=1 & ilo_cat_une!=2	//Unkown
				lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
				lab val ilo_cat_une cat_une_lab
				lab var ilo_cat_une "Category of unemployment"
	
	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

			
			gen tot_month_une=b5_r13
			
			gen ilo_dur_details=.
				replace ilo_dur_details=1 if tot_month_une<1
				replace ilo_dur_details=2 if tot_month_une>=1 & tot_month_une<3
				replace ilo_dur_details=3 if tot_month_une>=3 & tot_month_une<6
				replace ilo_dur_details=4 if tot_month_une>=6 & tot_month_une<12
				replace ilo_dur_details=5 if tot_month_une>=12 & tot_month_une<24
				replace ilo_dur_details=6 if tot_month_une>=24 & tot_month_une!=.
				replace ilo_dur_details=7 if tot_month_une==. & ilo_lfs==2
				replace ilo_dur_details=. if ilo_lfs!=2
					lab def ilo_unemp_det 1 "Less than 1 month" 2 "1 month to less than 3 months" 3 "3 months to less than 6 months" 4 "6 months to less than 12 months" 5 "12 months to less than 24 months" ///
										  6 "24 months or more" 7 "Not elsewhere classified"
					lab values ilo_dur_details ilo_unemp_det
					lab var ilo_dur_details "Duration of unemployment (Details)"
		

			gen ilo_dur_aggregate=.
				replace ilo_dur_aggregate=1 if inrange(ilo_dur_details,1,3)
				replace ilo_dur_aggregate=2 if ilo_dur_details==4
				replace ilo_dur_aggregate=3 if inrange(ilo_dur_details,5,6)
				replace ilo_dur_aggregate=4 if ilo_dur_details==7
					lab def ilo_unemp_aggr 1 "Less than 6 months" 2 "6 months to less than 12 months" 3 "12 months or more" 4 "Not elsewhere classified"
					lab val ilo_dur_aggregate ilo_unemp_aggr
					lab var ilo_dur_aggregate "Duration of unemployment (Aggregate)"

			drop tot_month_une		
	

	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4')  [don't define]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
	* Given that variable capturing the economic activity related to previous job only considers jobs that were left max. 1 year
		* ago and not any previous job, variable is not being defined
	
				
		* Drop the variables used for labelling economic activity:	
			
				drop  isic4_2digits isic4 isic3_2digits isic3 
				drop if missing(ilo_key) /// To drop empty lines added for the labels 
	
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
	* No information on the previous occupation in the dataset
	

	
***********************************************************************************************
*			PART 3.4. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma') [don't keep]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
	
* filter questions! 	
	
	/*
	gen ilo_olf_dlma=.
		replace ilo_olf_dlma = 1 if (b5_r11==1 | b5_r12==1) & b5_r17a==2 & ilo_lfs==3 				//Seeking, not available
		replace ilo_olf_dlma = 2 if b5_r11==2 & b5_r12==2  & b5_r17a==1 & ilo_lfs==3				//Not seeking, available
		replace ilo_olf_dlma = 3 if b5_r11==2 & b5_r12==2 & b5_r17a==2 	& b5_r17b==1 & ilo_lfs==3	//Not seeking, not available, willing
		replace ilo_olf_dlma = 4 if b5_r11==2 & b5_r12==2 & b5_r17a==2	& b5_r17a==2 & ilo_lfs==3	//Not seeking, not available, not willing
		replace ilo_olf_dlma = 5 if ilo_olf_dlma==. & ilo_lfs==3									// Not classified 
			lab def dlma_lab 1 "1 - Seeking, not available (Unavailable jobseekers)" 2 "2 - Not seeking, available (Available potential jobseekers)" ///
							 3 "3 - Not seeking, not available, willing (Willing non-jobseekers)" 4 "4 - Not seeking, not available, not willing" 5 "X - Not elsewhere classified"
			lab val ilo_olf_dlma dlma_lab 
			lab var ilo_olf_dlma "Labour market attachment (Degree of)"
			
			*/
	
	/* We cannot asses the wilingness to work. Consequently the people not seeking and not available are under "5 - Not classified". */
	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reason for not seeking job ('ilo_olf_reason') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

	
	gen ilo_olf_reason=.		
		replace ilo_olf_reason=1 if	b5_r16a==3								//Labour market
		replace ilo_olf_reason=2 if	inlist(b5_r16a,6,7,8,10,11)				//Personal / Family-related
		replace ilo_olf_reason=3 if	b5_r16a==5								//Does not need/want to work
		replace ilo_olf_reason=4 if ilo_olf_reason==. & ilo_lfs==3			//Not elsewhere classified
			replace ilo_olf_reason=. if ilo_lfs!=3			
			lab def reason_lab 1 "1 - Labour market" 2 "2 - Personal / Family-related" 3 "3 - Does not need/want to work" 4 "4 - Not elsewhere classified" 
			lab val ilo_olf_reason reason_lab 
			lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"
			
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seeker ('ilo_dis')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

	gen ilo_dis=1 if ilo_lfs==3 & b5_r17a==1 & ilo_olf_reason==1			
			lab def dis_lab 1 "Discouraged job-seekers"
			lab val ilo_dis dis_lab
			lab var ilo_dis "Discouraged job-seekers"
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training ('ilo_neet')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

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

	* Drop help variables for time 
	
	drop time year quarter

	* Full dataset with original variables and ILO ones
	
	cd "$outpath"

    * Save dataset including original and ilo variables
	
		save ${country}_${source}_${time}_FULL,  replace		
	
	* Save file only containing ilo_* variables
	
		keep ilo*

		save ${country}_${source}_${time}_ILO, replace

