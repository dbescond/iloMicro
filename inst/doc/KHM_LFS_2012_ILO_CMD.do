* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Cambodia, 2012
* DATASET USED: Cambodia LFS 2012
* NOTES: 
* Files created: Standard variables on LFS Cambodia 2012
* Authors: Marylène Escher
* Who last updated the file: Mabelin Villarreal Fuentes
* Starting Date: 11th November 2016
* Last updated: 09th May 2017
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
global country "KHM"
global source "LFS"
global time "2012"
global inputFile "KHM_LFS_2012.dta"
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
	
    gen ilo_key=_n
		lab var ilo_key "Key unique identifier per individual"		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sample Weight ('ilo_wgt') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_wgt=weighted
		lab var ilo_wgt "Sample weight"		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time period ('ilo_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
	gen ilo_time=1
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

        gen ilo_geo=q00_ur
			lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural"
			lab val ilo_geo ilo_geo_lab
			lab var ilo_geo "Geographical coverage"	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_sex=q01_a5
		lab def ilo_sex_lab 1 "1 - Male" 2 "2 - Female"
		lab var ilo_sex "Sex"
		lab val ilo_sex ilo_sex_lab
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_age=q01_a6
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
		
/* ISCED 11 mapping: use UNESCO mapping
					http://www.uis.unesco.org/Education/ISCEDMappings/Pages/default.aspx
					http://www.uis.unesco.org/Education/Documents/isced-2011-en.pdf 			
					
					
	NOTE: * The question is only asked to people aged 5 and more. So those below the age of 5 
	        are under "Not elsewhere classified".   */
		 
	gen ilo_edu_isced11=.
		replace ilo_edu_isced11=1 if q02_b10==88  					// No schooling
		replace ilo_edu_isced11=2 if inrange(q02_b10,0,5)			// Early childhood education
		replace ilo_edu_isced11=3 if inrange(q02_b10,6,8)			// Primary education
		replace ilo_edu_isced11=4 if inlist(q02_b10,9,10,11,13,15)	// Lower secondary education
		replace ilo_edu_isced11=5 if inlist(q02_b10,12,14,16) 		// Upper secondary education
		*replace ilo_edu_isced11=6 if  								// Post-secondary non-tertiary education
		replace ilo_edu_isced11=7 if q02_b10==17					// Short-cycle tertiary education
		replace ilo_edu_isced11=8 if q02_b10==18 					// Bachelor or equivalent
		replace ilo_edu_isced11=9 if q02_b10==19					// Master's or equivalent level
		replace ilo_edu_isced11=10 if q02_b10==20 					// Doctoral or equivalent level
		replace ilo_edu_isced11=11 if inlist(q02_b10,98,.)			// Not elsewhere classified
			label def isced_11_lab 1 "X - No schooling" 2 "0 - Early childhood education" 3 "1 - Primary education" 4 "2 - Lower secondary education" ///
							5 "3 - Upper secondary education" 6 "4 - Post-secondary non-tertiary education" 7 "5 - Short-cycle tertiary education" ///
							8 "6 - Bachelor's or equivalent level" 9 "7 - Master's or equivalent level" 10 "8 - Doctoral or equivalent level" 11 "9 - Not elsewhere classified"
			label val ilo_edu_isced11 isced_11_lab
			lab var ilo_edu_isced11 "Level of education (ISCED 11)"
			
		
		
	gen ilo_edu_aggregate=.
		replace ilo_edu_aggregate=1 if inlist(ilo_edu_isced11,1,2)  	// Less than basic
		replace ilo_edu_aggregate=2 if inlist(ilo_edu_isced11,3,4)		// Basic
		replace ilo_edu_aggregate=3 if inlist(ilo_edu_isced11,5,6)		// Intermediate
		replace ilo_edu_aggregate=4 if inrange(ilo_edu_isced11,7,10)	// Advanced
		replace ilo_edu_aggregate=5 if ilo_edu_isced11==11				// Level not stated
			label def edu_aggr_lab 1 "Less than basic" 2 "Basic" 3 "Intermediate" 4 "Advanced" 5 "Level not stated"
			label val ilo_edu_aggregate edu_aggr_lab
			label var ilo_edu_aggregate "Level of education (Aggregate)"
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education attendance ('ilo_edu_attendance')  	[done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

			
/* NOTE: The question is only asked to people aged 5 and more. So those below the age of 5 
        are under "Not elsewhere classified".   */
	

	gen ilo_edu_attendance=.
		replace ilo_edu_attendance=1 if q02_b3==1	// Attending 
		replace ilo_edu_attendance=2 if q02_b3==2	// Not attending 
		replace ilo_edu_attendance=3 if q02_b3==.	// Not elsewhere classified 
			label def edu_att_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified" 
			label val ilo_edu_attendance edu_att_lab
			label var ilo_edu_attendance "Education (Attendance)"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Disability status ('ilo_dsb') 	[done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

	/* To measure disability status, the questions asking whether the person has difficulty seeing,
	   hearing, walking, remembering and washing all over or dressing (self-caring) are used.*/			

	* Detailed disability status:
	
		gen ilo_dsb_details=1
			replace ilo_dsb_details=2 if q01_a17==2 	// Some difficulty
			replace ilo_dsb_details=2 if q01_a18==2		// Some difficulty
			replace ilo_dsb_details=2 if q01_a19==2		// Some difficulty
			replace ilo_dsb_details=2 if q01_a20==2		// Some difficulty
			replace ilo_dsb_details=2 if q01_a21==2		// Some difficulty
			replace ilo_dsb_details=3 if q01_a17==3		// A lot of difficulty
			replace ilo_dsb_details=3 if q01_a18==3		// A lot of difficulty
			replace ilo_dsb_details=3 if q01_a19==3		// A lot of difficulty
			replace ilo_dsb_details=3 if q01_a20==3		// A lot of difficulty
			replace ilo_dsb_details=3 if q01_a21==3		// A lot of difficulty
			replace ilo_dsb_details=4 if q01_a17==4		// Cannot do it at all
			replace ilo_dsb_details=4 if q01_a18==4		// Cannot do it at all
			replace ilo_dsb_details=4 if q01_a19==4		// Cannot do it at all
			replace ilo_dsb_details=4 if q01_a20==4		// Cannot do it at all
			replace ilo_dsb_details=4 if q01_a21==4		// Cannot do it at all
				label def dsb__det_lab 1 "No, no difficulty" 2 "Yes, some difficulty" 3 "Yes, a lot of difficulty" 4 "Cannot do it at all"
				label val ilo_dsb_details dsb__det_lab
				label var ilo_dsb_details "Disability status (Details)"

	
		gen ilo_dsb_aggregate=1
			replace ilo_dsb_aggregate=2 if inlist(q01_a17,3,4)	 // With disability
			replace ilo_dsb_aggregate=2 if inlist(q01_a18,3,4)	 // With disability
			replace ilo_dsb_aggregate=2 if inlist(q01_a19,3,4)	 // With disability
			replace ilo_dsb_aggregate=2 if inlist(q01_a20,3,4)	 // With disability
			replace ilo_dsb_aggregate=2 if inlist(q01_a21,3,4)	 // With disability
				label def dsb_lab 1 "Persons without disability" 2 "Persons with disability" 
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
          
* Comment: wap = 15+ 

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
	 
	/* Unemployment is different from the one in the LFS report, because the  
	   country uses a relaxed definition, which includes in unemployment people  
	   who did not look for work but want to work and are available. 			*/
	   
		
	gen ilo_lfs=.
		replace ilo_lfs=1 if q04_d1a==1 & ilo_wap==1 				// Employed
		replace ilo_lfs=1 if q04_d1b==1 & ilo_wap==1 				// Employed
		replace ilo_lfs=1 if q04_d1c==1 & ilo_wap==1 				// Employed
		replace ilo_lfs=1 if q04_d1d==1 & ilo_wap==1 				// Employed
		replace ilo_lfs=1 if q04_d2==1 & q04_d3!=11 & q04_d3!=12 & ilo_wap==1 		// Employed
		replace ilo_lfs=2 if ilo_lfs!=1 & (q09_i1==1 & q09_i7==1) & ilo_wap==1  	// Unemployed
		replace ilo_lfs=2 if ilo_lfs!=1 & q04_d3==11 & ilo_wap==1  	// Unemployed (Future starters)
		replace ilo_lfs=2 if ilo_lfs!=1 & q09_i4==1 & ilo_wap==1  	// Unemployed (Future starters)
		replace ilo_lfs=3 if ilo_lfs!=1 & ilo_lfs!=2 & ilo_wap==1  	// Outside the labour force 
				label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside the Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_mjh=.
		replace ilo_mjh=2 if q06_f1==1 & ilo_lfs==1
		replace ilo_mjh=1 if inlist(q06_f1,2,.) & ilo_lfs==1
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

	* MAIN JOB:
	
		* Detailled categories:
			gen ilo_job1_ste_icse93=.
				replace ilo_job1_ste_icse93=1 if q05_e9 ==1		                // Employees
				replace ilo_job1_ste_icse93=2 if q05_e9 ==2		                // Employers
				replace ilo_job1_ste_icse93=3 if q05_e9 ==3		                // Own-account workers
				*replace ilo_job1_ste_icse93=4 if 				                // Producer cooperatives
				replace ilo_job1_ste_icse93=5 if q05_e9 ==4		                // Contributing family workers
				replace ilo_job1_ste_icse93=6 if inlist(q05_e9,5,.)         	// Not classifiable
				replace ilo_job1_ste_icse93=. if ilo_lfs!=1
					label def label_ilo_ste_icse93 1 "1 - Employees" 2 "2 - Employers" 3 "3 - Own-account workers"  ///
													4 "4 - Members of producers cooperatives" 5 "5 - Contributing family workers" ///
													6 "6 - Workers not classifiable by status"
					label val ilo_job1_ste_icse93 label_ilo_ste_icse93
					label var ilo_job1_ste_icse93 "Status in employment (ICSE 93) - main job"
			
			
	
		* Aggregate categories 
			gen ilo_job1_ste_aggregate=.
				replace ilo_job1_ste_aggregate=1 if ilo_job1_ste_icse93==1				// Employees
				replace ilo_job1_ste_aggregate=2 if inrange(ilo_job1_ste_icse93,2,5)	// Self-employed
				replace ilo_job1_ste_aggregate=3 if ilo_job1_ste_icse93==6				// Not elsewhere classified
					lab def ste_aggr_lab 1 "1 - Employees" 2 "2 - Self-employed" 3 "3 - Not elsewhere classified"
					lab val ilo_job1_ste_aggregate ste_aggr_lab
					label var ilo_job1_ste_aggregate "Status in employment (Aggregate) - main job" 
		
					
	* SECOND JOB:
	
		* Detailled categories:
			gen ilo_job2_ste_icse93=.
				replace ilo_job2_ste_icse93=1 if q06_f9==1			// Employees
				replace ilo_job2_ste_icse93=2 if q06_f9==2			// Employers
				replace ilo_job2_ste_icse93=3 if q06_f9==3			// Own-account workers
				*replace ilo_job2_ste_icse93=4 if 					// Producer cooperatives
				replace ilo_job2_ste_icse93=5 if q06_f9==4			// Contributing family workers
				replace ilo_job2_ste_icse93=6 if q06_f9==5 | q06_f9==.	// Not classifiable
				replace ilo_job2_ste_icse93=. if ilo_mjh!=2
					label val ilo_job2_ste_icse93 label_ilo_ste_icse93
					label var ilo_job2_ste_icse93 "Status in employment (ICSE 93) - second job"
			
			
	
		* Aggregate categories 
			gen ilo_job2_ste_aggregate=.
				replace ilo_job2_ste_aggregate=1 if ilo_job2_ste_icse93==1				// Employees
				replace ilo_job2_ste_aggregate=2 if inrange(ilo_job2_ste_icse93,2,5)	// Self-employed
				replace ilo_job2_ste_aggregate=3 if ilo_job2_ste_icse93==6				// Not elsewhere classified
					lab val ilo_job2_ste_aggregate ste_aggr_lab
					label var ilo_job2_ste_aggregate "Status in employment (Aggregate) - second job" 

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	/* The datasets provides the economic actiity as ISIC 4 - 4 digits  */
		
			append using `labels', gen(lab)
			*use value label from this variable, afterwards drop everything related to this append
			
				* MAIN JOB:
					
					* ISIC Rev. 4 - 2 digit
						gen isic2dig = int(q05_e4/100)
						
						gen ilo_job1_eco_isic4_2digits=isic2dig if ilo_lfs==1
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
							replace ilo_job1_eco_isic4=22 if ilo_job1_eco_isic4_2digits==.
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
		
			* ISIC Rev. 4 - 2 digit
						gen isic2dig_job2 = int(q06_f5/100)
						
						gen ilo_job2_eco_isic4_2digits=isic2dig_job2 if ilo_mjh==2
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
							replace ilo_job2_eco_isic4=22 if ilo_job2_eco_isic4_2digits==.
							replace ilo_job2_eco_isic4=. if ilo_mjh!=2
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
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_job1_ocu_isco88') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
	
	/* The datasets provides the occupation as ISCO 08 - 4 digits.  		*/
	   
	* MAIN JOB:
	
			gen occup_2dig=int(q05_e2/100) if ilo_lfs==1 
	
		* ISCO 08 - 2 digits:
			gen ilo_job1_ocu_isco08_2digits=occup_2dig if ilo_lfs==1
				replace ilo_job1_ocu_isco08_2digits=. if occup_2dig==10
						lab values ilo_job1_ocu_isco08_2digits isco08_2digits
						lab var ilo_job1_ocu_isco08_2digits "Occupation (ISCO-08), 2 digit level"
	
	
		* ISCO 08 - 1 digit:
			gen occup_1dig=int(ilo_job1_ocu_isco08_2digits/10) if ilo_lfs==1
		
			gen ilo_job1_ocu_isco08=occup_1dig if ilo_lfs==1
				replace ilo_job1_ocu_isco08=10 if occup_1dig==0 & ilo_lfs==1
				replace ilo_job1_ocu_isco08=11 if occup_1dig==. & ilo_lfs==1
							lab values ilo_job1_ocu_isco08 isco08
							lab var ilo_job1_ocu_isco08 "Occupation (ISCO-08) - main job"
	
	
		* Aggregate:
			gen ilo_job1_ocu_aggregate=.
				replace ilo_job1_ocu_aggregate=1 if inrange(ilo_job1_ocu_isco08,1,3)
				replace ilo_job1_ocu_aggregate=2 if inlist(ilo_job1_ocu_isco08,4,5)
				replace ilo_job1_ocu_aggregate=3 if inlist(ilo_job1_ocu_isco08,6,7)
				replace ilo_job1_ocu_aggregate=4 if ilo_job1_ocu_isco08==8
				replace ilo_job1_ocu_aggregate=5 if ilo_job1_ocu_isco08==9
				replace ilo_job1_ocu_aggregate=6 if ilo_job1_ocu_isco08==10
				replace ilo_job1_ocu_aggregate=7 if ilo_job1_ocu_isco08==11
				replace ilo_job1_ocu_aggregate=. if ilo_lfs!=1
					lab def ocu_aggr_lab 1 "Managers, professionals, and technicians" 2 "Clerical, service and sales workers" 3 "Skilled agricultural and trades workers" ///
										4 "Plant and machine operators, and assemblers" 5 "Elementary occupations" 6 "Armed forces" 7 "Not elsewhere classified"
					lab val ilo_job1_ocu_aggregate ocu_aggr_lab
					lab var ilo_job1_ocu_aggregate "Occupation (Aggregate) - Main job"	
	
	
	* SECOND JOB:
	
			gen occup_2dig_job2=int(q06_f3/100) if ilo_mjh==2 
	
	
		* ISCO 08 - 2 digits:
			gen ilo_job2_ocu_isco08_2digits=occup_2dig_job2 if ilo_mjh==2
							lab values ilo_job2_ocu_isco08_2digits isco08_2digits
							lab var ilo_job2_ocu_isco08_2digits "Occupation (ISCO-08), 2 digit level - second job"
	
	
	
		* ISCO 08 - 1 digit:
			gen occup_1dig_job2=int(ilo_job2_ocu_isco08_2digits/10) if ilo_mjh==2
		
			gen ilo_job2_ocu_isco08=occup_1dig_job2 if ilo_mjh==2
				replace ilo_job2_ocu_isco08=10 if occup_1dig_job2==0 & ilo_mjh==2
				replace ilo_job2_ocu_isco08=11 if occup_1dig_job2==. & ilo_mjh==2
							lab values ilo_job2_ocu_isco08 isco08
							lab var ilo_job2_ocu_isco08 "Occupation (ISCO-08) - second job"
	
	
		* Aggregate:
			gen ilo_job2_ocu_aggregate=.
				replace ilo_job2_ocu_aggregate=1 if inrange(ilo_job2_ocu_isco08,1,3)
				replace ilo_job2_ocu_aggregate=2 if inlist(ilo_job2_ocu_isco08,4,5)
				replace ilo_job2_ocu_aggregate=3 if inlist(ilo_job2_ocu_isco08,6,7)
				replace ilo_job2_ocu_aggregate=4 if ilo_job2_ocu_isco08==8
				replace ilo_job2_ocu_aggregate=5 if ilo_job2_ocu_isco08==9
				replace ilo_job2_ocu_aggregate=6 if ilo_job2_ocu_isco08==10
				replace ilo_job2_ocu_aggregate=7 if ilo_job2_ocu_isco08==11
				replace ilo_job2_ocu_aggregate=. if ilo_mjh!=2
					lab val ilo_job2_ocu_aggregate ocu_aggr_lab
					lab var ilo_job2_ocu_aggregate "Occupation (Aggregate) - second job"	
	
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector ('ilo_job1_ins_sector') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

* Comment: Public -> 1. Government + 2. Public/state-owned enterprise
*          Private -> 3. Non-profit organization, NGO + 4. Private household (paid domestic worker)
*          + 5. Non-farm private business + 6. Farm private enterprise (plantation, farm) + 6. Other	
	
	* MAIN JOB:
	
		gen ilo_job1_ins_sector=.
			replace ilo_job1_ins_sector=1 if inlist(q05_e7,1,2) & ilo_lfs==1		// Public
			replace ilo_job1_ins_sector=2 if ilo_job1_ins_sector!=1 & ilo_lfs==1	// Private
				lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private" 
				lab values ilo_job1_ins_sector ins_sector_lab
				lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities - main job"
	
	
	
	* SECOND JOB:
	
		gen ilo_job2_ins_sector=.
			replace ilo_job2_ins_sector=1 if inlist(q06_f7,1,2) & ilo_mjh==2			// Public
			replace ilo_job2_ins_sector=2 if ilo_job2_ins_sector!=1 & ilo_mjh==2		// Private
				lab values ilo_job2_ins_sector ins_sector_lab
				lab var ilo_job2_ins_sector "Institutional sector (private/public) of economic activities - second job"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Hours of work ('ilo_how') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
		
		* MAIN JOB:
			
			* 1) Weekly hours ACTUALLY worked:
			
				gen ilo_job1_how_actual = q07_g2am + q07_g2bm + q07_g2cm + q07_g2dm + q07_g2em + q07_g2fm + q07_g2gm if ilo_lfs==1
						lab var ilo_job1_how_actual "Weekly hours actually worked in main job"
				
				
				gen ilo_job1_how_actual_bands=.
					replace ilo_job1_how_actual_bands=1 if ilo_job1_how_actual==0
					replace ilo_job1_how_actual_bands=2 if ilo_job1_how_actual>=1 & ilo_job1_how_actual<=14
					replace ilo_job1_how_actual_bands=3 if ilo_job1_how_actual>=15 & ilo_job1_how_actual<=29
					replace ilo_job1_how_actual_bands=4 if ilo_job1_how_actual>=30 & ilo_job1_how_actual<=34
					replace ilo_job1_how_actual_bands=5 if ilo_job1_how_actual>=35 & ilo_job1_how_actual<=39
					replace ilo_job1_how_actual_bands=6 if ilo_job1_how_actual>=40 & ilo_job1_how_actual<=48
					replace ilo_job1_how_actual_bands=7 if ilo_job1_how_actual>=49 & ilo_job1_how_actual!=.
					replace ilo_job1_how_actual_bands=8 if ilo_job1_how_actual==. & ilo_lfs==1
						lab def how_bands_lab 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"
						lab val ilo_job1_how_actual_bands how_bands_lab
						lab var ilo_job1_how_actual_bands "Weekly hours actually worked bands in main job"
		
		
		
			* 2) Weekly hours USUALLY worked:
		
				gen ilo_job1_how_usual=q07_g1a if ilo_lfs==1
						lab var ilo_job1_how_usual "Weekly hours usually worked in main job"
						
				gen ilo_job1_how_usual_bands=.
				    replace ilo_job1_how_usual_bands=1 if ilo_job1_how_usual==0
				    replace ilo_job1_how_usual_bands=2 if inrange(ilo_job1_how_usual,1,14)
				    replace ilo_job1_how_usual_bands=3 if inrange(ilo_job1_how_usual,15,29)
				    replace ilo_job1_how_usual_bands=4 if inrange(ilo_job1_how_usual,30,34)
				    replace ilo_job1_how_usual_bands=5 if inrange(ilo_job1_how_usual,35,39)
				    replace ilo_job1_how_usual_bands=6 if inrange(ilo_job1_how_usual,40,48)
				    replace ilo_job1_how_usual_bands=7 if ilo_job1_how_usual>=49 & ilo_job1_how_usual!=.
					        lab def how_usu_bands_lab 1 "No hours usually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 
					        lab val ilo_job1_how_usual_bands how_usu_bands_lab
					        lab var ilo_job1_how_usual_bands "Weekly hours usually worked bands in main job"
		
		
		
		
		* SECOND JOB
			
			/* The workers are asked how many hours they worked in "any other jobs/activities" so we cannot 
			   isolate the hours worked ONLY in the second job. 		*/
			   
	
		* ALL JOBS:
		
			* 1) Weekly hours ACTUALLY worked:
				gen ilo_job_other_how_actual=q07_g2ao + q07_g2bo + q07_g2co + q07_g2do + q07_g2eo + q07_g2fo + q07_g2go if ilo_lfs==1
						
				gen ilo_joball_how_actual=.
				replace ilo_joball_how_actual= ilo_job1_how_actual if ilo_lfs==1
				replace ilo_joball_how_actual = ilo_job1_how_actual + ilo_job_other_how_actual if ilo_mjh==2
						lab var ilo_joball_how_actual "Weekly hours actually worked in all jobs"
						
		
				gen ilo_joball_how_actual_bands=.
					replace ilo_joball_how_actual_bands=1 if ilo_joball_how_actual==0
					replace ilo_joball_how_actual_bands=2 if ilo_joball_how_actual>=1 & ilo_joball_how_actual<=14
					replace ilo_joball_how_actual_bands=3 if ilo_joball_how_actual>=15 & ilo_joball_how_actual<=29
					replace ilo_joball_how_actual_bands=4 if ilo_joball_how_actual>=30 & ilo_joball_how_actual<=34
					replace ilo_joball_how_actual_bands=5 if ilo_joball_how_actual>=35 & ilo_joball_how_actual<=39
					replace ilo_joball_how_actual_bands=6 if ilo_joball_how_actual>=40 & ilo_joball_how_actual<=48
					replace ilo_joball_how_actual_bands=7 if ilo_joball_how_actual>=49 & ilo_joball_how_actual!=.
					replace ilo_joball_how_actual_bands=8 if ilo_joball_how_actual_bands==. & ilo_lfs==1
						lab val ilo_joball_how_actual_bands how_bands_lab
						lab var ilo_joball_how_actual_bands "Weekly hours actually worked bands in all jobs"
					
					drop ilo_job_other_how_actual
					
						
			* 2) Weekly hours USUALLY worked:
			
				gen ilo_joball_how_usual=g07_g1c if ilo_lfs==1
						lab var ilo_joball_how_usual "Weekly hours usually worked in all jobs"
				
				gen ilo_joball_how_usual_bands=.
				    replace ilo_joball_how_usual_bands=1 if ilo_joball_how_usual==0
				    replace ilo_joball_how_usual_bands=2 if inrange(ilo_joball_how_usual,1,14)
				    replace ilo_joball_how_usual_bands=3 if inrange(ilo_joball_how_usual,15,29)
				    replace ilo_joball_how_usual_bands=4 if inrange(ilo_joball_how_usual,30,34)
				    replace ilo_joball_how_usual_bands=5 if inrange(ilo_joball_how_usual,35,39)
				    replace ilo_joball_how_usual_bands=6 if inrange(ilo_joball_how_usual,40,48)
				    replace ilo_joball_how_usual_bands=7 if ilo_joball_how_usual>=49 & ilo_joball_how_usual!=.
				            * value label already defined for the main job
					        lab val ilo_joball_how_usual_bands how_usu_bands_lab
					        lab var ilo_joball_how_usual_bands "Weekly hours usually worked bands in all jobs"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job1_job_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
		
		
	/* According to the LFS report, the normal number of hours worked is 40 per week (although
 	   the legal maximum is 48 hours/week).			*/
	   
	   
	   * MAIN JOB
	   gen ilo_job1_job_time=.
				replace ilo_job1_job_time=1 if ilo_job1_how_usual<40 
				replace ilo_job1_job_time=2 if ilo_job1_how_usual>=40 & ilo_job1_how_usual!=.
				replace ilo_job1_job_time=3 if ilo_job1_job_time!=1 & ilo_job1_job_time!=2 & ilo_lfs==1
					lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
					lab val ilo_job1_job_time job_time_lab
					lab var ilo_job1_job_time "Job (Working time arrangement) - Main job"	
			
			
		* ALL JOBS
		 gen ilo_joball_job_time=.
				replace ilo_joball_job_time=1 if ilo_joball_how_usual<40 
				replace ilo_joball_job_time=2 if ilo_joball_how_usual>=40 & ilo_joball_how_usual!=.
				replace ilo_joball_job_time=3 if ilo_joball_job_time!=1 & ilo_joball_job_time!=2 & ilo_lfs==1
					lab val ilo_joball_job_time job_time_lab
					lab var ilo_joball_job_time "Job (Working time arrangement) - All jobs"	
			
			
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job1_job_contract') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
		
/*  * The question (E.15) is only asked to employees, so the other status are under "Unknown".
	
	* In addition to "unlimited duration" and "limited duration" there is another possible answer
	  "unspecified duration". This category is classified under "limited duration" as the respondants
	  are asked the same following questions as those answering "limited duration". */	
				
				
		gen ilo_job1_job_contract=.
			replace ilo_job1_job_contract=1 if q05_e15==2 & ilo_lfs==1
			replace ilo_job1_job_contract=2 if inlist(q05_e15,1,3) & ilo_lfs==1
			replace ilo_job1_job_contract=3 if inlist(q05_e15,4,.) & ilo_lfs==1
				lab def contr_type 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"
				lab val ilo_job1_job_contract contr_type
				lab var ilo_job1_job_contract "Job (Type of contract)"
				

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Formal / Informal Economy ('ilo_job1_ife_prod' 'ilo_job1_ife_nature') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			

/*Useful questions: Institutional sector: q05_e7
                    Destination of production: Not asked
					Bookkeeping: Not asked
					Registration: q05_e8
					Status in employment: ilo_job1_ste_icse93
					Social security contribution: 1. Pension contribution (q05_e10)
					Place of work: q05_e6
					Size: q05_e5
					Paid annual leave: q05_e11
					Paid sick leave: q05_e12
*/
	
	* Social security (to be dropped afterwards)
	
	        gen social_security=.
			    replace social_security=1 if q05_e10==1 & ilo_lfs==1            // Contribution to any pension or retirement fund
				replace social_security=2 if q05_e10==2 & ilo_lfs==1            // No contribution to any pension or retirement fund  
				replace social_security=3 if q05_e10==3 & ilo_lfs==1            // Don't know
				replace social_security=. if q05_e10==. & ilo_lfs==1            // Not answered
	 
	
	* 1) UNIT OF PRODUCTION: FORMAL/INFORMAL SECTOR	

			gen ilo_job1_ife_prod=.
			    replace ilo_job1_ife_prod=1 if ilo_lfs==1 & ///
				                               ((inlist(q05_e7,5,6,7,.) & inlist(q05_e8,2,3))| ///
											   (inlist(q05_e7,5,6,7,.) & inlist(q05_e8,4,.) & ilo_job1_ste_icse93==1 & social_security!=1 & q05_e6!=3)| ///
											   (inlist(q05_e7,5,6,7,.) & inlist(q05_e8,4,.) & ilo_job1_ste_icse93==1 & social_security!=1 & q05_e6==3 & inlist(q05_e5,1,2,.))| ///
											   (inlist(q05_e7,5,6,7,.) & inlist(q05_e8,4,.) & ilo_job1_ste_icse93!=1 & q05_e6!=3)| ///
											   (inlist(q05_e7,5,6,7,.) & inlist(q05_e8,4,.) & ilo_job1_ste_icse93!=1 & q05_e6==3 & inlist(q05_e5,1,2,.)))
				replace ilo_job1_ife_prod=2 if ilo_lfs==1 & ///
				                               ((inlist(q05_e7,1,2,3))| ///
											   (inlist(q05_e7,5,6,7,.) & q05_e8==1)| ///
											   (inlist(q05_e7,5,6,7,.) & inlist(q05_e8,4,.) & ilo_job1_ste_icse93==1 & social_security==1)| ///
											   (inlist(q05_e7,5,6,7,.) & inlist(q05_e8,4,.) & ilo_job1_ste_icse93==1 & social_security!=1 & q05_e6==3 & inlist(q05_e5,3,4,5,6))| ///
											   (inlist(q05_e7,5,6,7,.) & inlist(q05_e8,4,.) & ilo_job1_ste_icse93!=1 & q05_e6==3 & inlist(q05_e5,3,4,5,6)))
				replace ilo_job1_ife_prod=3 if ilo_lfs==1 & ///
				                               ((q05_e7==4) | ///
											   (inlist(q05_e7,5,6,7,.) & q11_k6==1))
						lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 
						lab val ilo_job1_ife_prod ilo_ife_prod_lab
						lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"
			

	
	
	* 2) NATURE OF JOB: FORMAL/INFORMAL EMPLOYMENT
	
			gen ilo_job1_ife_nature=.
                replace ilo_job1_ife_nature=2 if ilo_lfs==1 & ///
				                                 ((inlist(ilo_job1_ste_icse93,1,6) & social_security==1)| ///
												 (inlist(ilo_job1_ste_icse93,1,6) & social_security==. & q05_e11==1 & q05_e12==1)| ///
												 (inlist(ilo_job1_ste_icse93,2,4) & ilo_job1_ife_prod==2)| ///
												 (ilo_job1_ste_icse93==3 & ilo_job1_ife_prod==2))
                replace ilo_job1_ife_nature=1 if ilo_lfs==1 & ///
				                                 ((inlist(ilo_job1_ste_icse93,1,6) & inlist(social_security,2,3))| /// 
												 (inlist(ilo_job1_ste_icse93,1,6) & social_security==. & (q05_e11!=1 | q05_e12!=1))| ///
												 (inlist(ilo_job1_ste_icse93,2,4) & inlist(ilo_job1_ife_prod,1,3))| ///
												 (ilo_job1_ste_icse93==3 & inlist(ilo_job1_ife_prod,1,3))| ///
												 (ilo_job1_ste_icse93==5))
						lab def ife_nature_lab 1 "1 - Persons with informal main job" 2 "2 - Persons with formal main job"
						lab val ilo_job1_ife_nature ife_nature_lab
						lab var ilo_job1_ife_nature "Informal / Formal Economy (Nature of job) - Main job"
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Monthly labour related income ('ilo_job1_lri') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
	
	/* Questions E21-E24 deal with labour related income of the employees. They are asked how much
	   they earned in cash and in kind last time they were paid. In addition, they are asked what 
	   period the earnings cover (1 month, 1 week, 1 day or other). 
	   
	   To convert daily and weekly income into monthly income, the following factors were used:
			- monthly income = (365/12)*daily income
			- monthly income = ((365/7)/12)*weekly income														*/
	/* NOTES: For employees => 1. gross (T10:138)
	                           2. main job currently held (T11:142)
							   3. including payments in kind (T34:400)
							   4. currency: riel (T30:117)
			  For self-employed => 1. net: after deducting expenses (T10:139)
			                       2. currency: riel (T30:117)
	         
    */
			
	* Employees:
		gen cash_month=. /*to drop*/
			replace cash_month = q05_e22c if ilo_job1_ste_aggregate==1 & q05_e23c==1                       //cash per month
			replace cash_month = q05_e22c * ((365/7)/12) if ilo_job1_ste_aggregate==1 & q05_e23c==2        //cash per week
			replace cash_month = q05_e22c * (365/12) if ilo_job1_ste_aggregate==1 & q05_e23c==3            //cash per day
			replace cash_month = . if cash_month==. & ilo_job1_ste_aggregate==1                            
			
		gen kind_month=. /*to drop*/
			replace kind_month = q05_e22k if ilo_job1_ste_aggregate==1 & q05_e23k==1                       //kind per month
			replace kind_month = q05_e22k * ((365/7)/12) if ilo_job1_ste_aggregate==1 & q05_e23k==2        //kind per week
			replace kind_month = q05_e22k * (365/12) if ilo_job1_ste_aggregate==1 & q05_e23k==3            //kind per day
			replace kind_month = . if kind_month==. & ilo_job1_ste_aggregate==1                            
			
			
		egen ilo_job1_lri_ees = rowtotal(cash_month kind_month), m
		     replace ilo_job1_lri_ees=. if ilo_job1_ste_aggregate!=1
			         lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"
	
	* Self-employed:
	
		gen ilo_job1_lri_slf= q05_e25c + q05_e25k if ilo_job1_ste_aggregate==2
			replace ilo_job1_lri_slf=0 if ilo_job1_lri_slf<0
			lab var ilo_job1_lri_slf "Monthly labour related income of self-employed in main job"
	
		
***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_joball_tru') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
		
/* 	  * There is no questions asking directly the workers if they are AVAILABLE to work additional
		hours, but the way question H1 is asked, it seems that people answering yes are both
		wiling and available to work more hours. 
	
	   * Threshold used: 40 hours/week 
	     In the LFS report, it is said on one page that they use the threshold 40 hours/week and 
		 on another page it is written 48 hours/week. We use 40 hours/week as a threshold as it 
		 is the normal hours worked per week in Cambodia.			*/ 	
		 
/*Notes: Time-related underemployment concept (two criteria: worked less than a threshold and 
         willing to work more hours) T35:2416*/		 
		 
		
				gen ilo_joball_tru=.
					replace ilo_joball_tru=1 if ilo_lfs==1 & q08_h1==1 & q08_h2>0 & ilo_joball_how_usual<40
						lab def ilo_tru 1 "Time-related underemployed"
						lab val ilo_joball_tru ilo_tru
						lab var ilo_joball_tru "Time-related underemployed"			
					
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupational injury ('ilo_joball_inj') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
		
	* Case of non-fatal occupational injuries:
		
		gen ilo_joball_oi_case=.
			replace ilo_joball_oi_case=q10_j4 if ilo_lfs==1
				lab var ilo_joball_oi_case "Cases of non-fatal occupational injuries"
		
   /* Days lost due to occupatinal injuries:
	  * Code 98 is for "Don't know" and 99 for those who expect never returning to work. There 
	    are recoded as missing as they do not represent 98 or 99 days. 		*/

	
		gen ilo_joball_oi_day=.
			replace ilo_joball_oi_day=q10_j10 if ilo_lfs==1
			replace ilo_joball_oi_day=. if inlist(q10_j10,98,99,999)
				lab var ilo_joball_oi_day "Days lost due to cases of occupational injury"
		
***********************************************************************************************
*			PART 3.3. UNEMPLOYMENT: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Category of unemployment ('ilo_cat_une') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	
	* Not available

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

/** Due to the possibles answers, only the aggregated variable can be done.*/
		
	
		* Aggregate:
		
			gen ilo_dur_aggregate=.
				replace ilo_dur_aggregate=1 if inrange(q09_i6,1,2) & ilo_lfs==2 	// Less than 6 months
				replace ilo_dur_aggregate=2 if q09_i6==3 & ilo_lfs==2				// 6 months to less than 12 months
				replace ilo_dur_aggregate=3 if inlist(q09_i6,4,5,6) & ilo_lfs==2	// 12 months or more
				replace ilo_dur_aggregate=4 if inlist(q09_i6,7,.) & ilo_lfs==2		// Not elsewhere classified
					lab def ilo_unemp_agr 1 "Less than 6 months" 2 "6 months to less than 12 months" ///
										  3 "12 months or more" 4 "Not elsewhere classified"
					lab values ilo_dur_aggregate ilo_unemp_agr
					lab var ilo_dur_aggregate "Duration of unemployment (Aggregate)"
		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
			
		* Not available

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
		* Not available
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			General social protection ('ilo_gsp_unschemes') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
		* Not available
	
***********************************************************************************************
*			PART 3.3. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
	
		gen ilo_olf_dlma=.
			replace ilo_olf_dlma=1 if q09_i1==1 & q09_i7==2 & ilo_lfs==3				// Seeking, not available
			replace ilo_olf_dlma=2 if q09_i1==2 & q09_i7==1 & ilo_lfs==3				// Not seeking, available
			replace ilo_olf_dlma=3 if q09_i1==2 & q09_i7==2 & q09_i3==1 & ilo_lfs==3	// Not seeking, not available, willing
			replace ilo_olf_dlma=4 if q09_i1==2 & q09_i7==2 & q09_i3==2 & ilo_lfs==3	// Not seeking, not available, not willing
			replace ilo_olf_dlma=5 if ilo_olf_dlma==. & ilo_lfs==3						// Not elsewhere classified
				lab def dlma 1 "1 - Seeking, not available (Unavailable jobseekers)" 2 "2 - Not seeking, available (Available potential jobseekers)" ///
							 3 "3 - Not seeking, not available, willing (Willing non-jobseekers)" 4 "4 - Not seeking, not available, not willing" ///
							 5 "5 - Not elsewhere classified"
				lab val ilo_olf_dlma dlma
				lab var ilo_olf_dlma "Labour market attachment (Degree of)"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reason for not seeking job ('ilo_olf_reason') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

		gen ilo_olf_reason=.
			replace ilo_olf_reason=1 if	inlist(q09_i4,2,3,7,8,9,10) & ilo_lfs==3	//Labour market
			replace ilo_olf_reason=2 if	inlist(q09_i4,4,5,6) & ilo_lfs==3			//Personal/Family-related
			replace ilo_olf_reason=3 if q09_i3==2 & ilo_lfs==3						//Does not need/want to work
			replace ilo_olf_reason=4 if q09_i4==11 & ilo_lfs==3						//Not elsewhere classified
			replace ilo_olf_reason=4 if ilo_olf_reason==. & ilo_lfs==3				//Not elsewhere classified
				lab def reasons_lab 1 "1 - Labour market" 2 "2 - Personal / Family-related" ///
									3 "3 - Does not need/want to work" 4 "4 - Not elsewhere classified"
				lab val ilo_olf_reason reasons_lab 
				lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seeker ('ilo_dis')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

		
	gen ilo_dis=1 if ilo_lfs==3 & q09_i7==1 & ilo_olf_reason==1
			lab def dis_lab 1 "Discouraged job-seekers"
			lab val ilo_dis dis_lab
			lab var ilo_dis "Discouraged job-seekers"
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training ('ilo_neet')  
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



cd "$outpath"
        
		/*Categories from temporal file deleted */
		drop if lab==1 
		
		/*Only age bands used*/
		drop ilo_age 
		
    	/*Variables computed in-between*/
		drop lab isco08_2digits isco88_2digits isco08 isco88 isic4_2digits isic4 isic3_2digits isic3 isic2dig
	    drop isic2dig_job2 occup_2dig occup_1dig occup_2dig_job2 occup_1dig_job2 social_security cash_month kind_month
		
		compress 
		
	   /*Save dataset including original and ilo variables*/
	
		save ${country}_${source}_${time}_FULL,  replace		
	
	  /* Save file only containing ilo_* variables*/
	
		keep ilo*

		save ${country}_${source}_${time}_ILO, replace


	
	
	