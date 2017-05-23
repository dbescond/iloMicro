* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Samoa, 2012
* DATASET USED: Samoa LFS 2012
* NOTES: 
* Files created: Standard variables on Samoa  2012
* Authors: Deen Lawani
* Who last updated the file: Mabelin Villarreal Fuentes
* Starting Date: 11 October 2016
* Last updated: 17 May 2017
***********************************************************************************************


***********************************************************************************************
***********************************************************************************************

* 			1. SET UP WORK DIRECTORY, FILE NAME, VARIABLES AND FUNCTIONS, MAP VARIABLES

***********************************************************************************************
***********************************************************************************************

clear all 

set more off
*set more off, permanently

global path "J:\COMMON\STATISTICS\DPAU\MICRO"
global country "WSM"
global source "LFS"
global time "2012"
global inputFile "WSM_LFS_2012"
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
*Comment: Even though the name of the variable hhweights seems to be refering to houshold's weight,
*         it refers to individual ones.

	gen ilo_wgt=hhweights
		lab var ilo_wgt "Sample weight"		
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time period ('ilo_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	* Year 
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

	gen ilo_geo=urb_rur
		lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural"
		lab val ilo_geo ilo_geo_lab
		lab var ilo_geo "Geographical coverage"	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_sex=a_5
		lab def ilo_sex_la 1 "Male" 2 "Female"
		lab val ilo_sex ilo_sex_la
		lab var ilo_sex "Sex"
		

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_age=a_6
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
*			Disability status (Details) [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
* Comment: Only asked to people aged 15 years and over

	/* To measure disability status, the questions asking whether the person has difficulty seeing,
	   hearing, walking, remembering and washing all over or dressing (self-caring) are used.*/			

	* Detailed disability status:
	
		gen ilo_dsb_details=.
			replace ilo_dsb_details=2 if a_9==2     	// Some difficulty
			replace ilo_dsb_details=2 if a_10==2		// Some difficulty
			replace ilo_dsb_details=2 if a_11==2		// Some difficulty
			replace ilo_dsb_details=2 if a_12==2		// Some difficulty
			replace ilo_dsb_details=2 if a_13==2		// Some difficulty
			replace ilo_dsb_details=3 if a_9==3	    	// A lot of difficulty
			replace ilo_dsb_details=3 if a_10==3		// A lot of difficulty
			replace ilo_dsb_details=3 if a_11==3		// A lot of difficulty
			replace ilo_dsb_details=3 if a_12==3		// A lot of difficulty
			replace ilo_dsb_details=3 if a_13==3		// A lot of difficulty
			replace ilo_dsb_details=4 if a_9==4  		// Cannot do it at all
			replace ilo_dsb_details=4 if a_10==4		// Cannot do it at all
			replace ilo_dsb_details=4 if a_11==4		// Cannot do it at all
			replace ilo_dsb_details=4 if a_12==4		// Cannot do it at all
			replace ilo_dsb_details=4 if a_13==4		// Cannot do it at all
			replace ilo_dsb_details=1 if (ilo_dsb_details==. & ilo_age>=15)     //No difficulty
				label def dsb_det_lab 1 "No, no difficulty" 2 "Yes, some difficulty" 3 "Yes, a lot of difficulty" 4 "Cannot do it at all"
				label val ilo_dsb_details dsb_det_lab
				label var ilo_dsb_details "Disability status (Details)"

	
		gen ilo_dsb_aggregate=.
			replace ilo_dsb_aggregate=2 if inlist(a_9,3,4)	 // With disability
			replace ilo_dsb_aggregate=2 if inlist(a_10,3,4)	 // With disability
			replace ilo_dsb_aggregate=2 if inlist(a_11,3,4)	 // With disability
			replace ilo_dsb_aggregate=2 if inlist(a_12,3,4)	 // With disability
			replace ilo_dsb_aggregate=2 if inlist(a_13,3,4)	 // With disability
			replace ilo_dsb_aggregate=1 if (ilo_dsb_aggregate==. & ilo_age>=15)
				label def dsb_lab 1 "Persons without disability" 2 "Persons with disability" 
				label val ilo_dsb_aggregate dsb_lab
				label var ilo_dsb_aggregate "Disability status (Aggregate)"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education attendance ('ilo_edu_attendance') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: Question only asked to persons aged 15 years or more. The rest of the observations 
*         (or who didn't reply to the questions used here) are classified under:
*          "Not elsewhere classified".

	gen ilo_edu_attendance=.
		replace ilo_edu_attendance=1 if (b_3==1 | c_1==1)		                // Attending
		replace ilo_edu_attendance=2 if (b_3!=2 & c_1!=2)	                    // Not attending
		replace ilo_edu_attendance=3 if ilo_edu_attendance==.                   // Not elsewhere classified
			label def edu_att_lbk 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified" 
			label val ilo_edu_attendance edu_att_lbk
			label var ilo_edu_attendance "Education (Attendance)"				

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education ('ilo_edu') [done] 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: only aggregated level 
	* Classification checked 

	gen ilo_edu_aggregate=.
		replace ilo_edu_aggregate=1 if inlist(b_7,0,88)
		replace ilo_edu_aggregate=2 if inrange(b_7,01,09)
		replace ilo_edu_aggregate=3 if inrange(b_7,10,14)
		replace ilo_edu_aggregate=4 if inlist(b_7,15,16)
		replace ilo_edu_aggregate=5 if inlist(b_7,98,99,.)
			lab def ilo_edu_aggregate_labc 1 "1 - Less than basic" 2 "2 - Basic" 3 "3 - Intermediate" 4 "4 - Advanced" 5 "5 - Level not stated"
			lab val ilo_edu_aggregate ilo_edu_aggregate_labc
			lab var ilo_edu_aggregate "Education (Aggregate levels)"
			
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
          
* Comment: WAP = 15+ 

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

	gen ilo_lfs=.
		replace ilo_lfs=1 if (d_1a==1 | d_1b==1 | d_1c==1) & ilo_wap==1 	                // Employed at least one hour during the last 7 days
		replace ilo_lfs=1 if (d_2==1 & !inlist(d_3,11,12)) & ilo_wap==1                     // Employed temporary absent (not including future starters or seasonal workers)  
		replace ilo_lfs=2 if (ilo_lfs!=1 & (h_1==1 | h_4==1) & h_7==1 & ilo_wap==1)			// Unemployed
		replace ilo_lfs=3 if (ilo_lfs!=1 & ilo_lfs!=2 & ilo_wap==1) 						// Outside the labour force
				label define lBAz_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside the Labour Force"
				label value ilo_lfs lBAz_ilo_lfs
				label var ilo_lfs "Labour Force Status"		
		

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: Question about other job is not asked directly. 
*          Hours worked in other jobs/activities is used as a proxy.

	gen ilo_mjh=.
		replace ilo_mjh=1 if inlist(f_1b,0,.) & (ilo_lfs==1 & ilo_wap==1)       // None or missing hours worked in other job/activity -> only one job
		replace ilo_mjh=2 if !inlist(f_1b,0,.) & (ilo_lfs==1 & ilo_wap==1)      
			lab def lC_ilo_mjh 1 "1 - One job only" 2 "2 - More than one job"
			lab val ilo_mjh lC_ilo_mjh
			lab var ilo_mjh "Multiple job holders"

			
***********************************************************************************************
*			PART 3.1. ECONOMIC CHARACTERISTICS FOR MAIN JOB 
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Status in employment ('ilo_job1_ste') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: Only available for main job

		gen ilo_job1_ste_icse93=.
			replace ilo_job1_ste_icse93=1 if (e_9==1 & ilo_lfs==1)			// Employees 
			replace ilo_job1_ste_icse93=2 if (e_9==2 & ilo_lfs==1)			// Employers
			replace ilo_job1_ste_icse93=3 if (e_9==3 & ilo_lfs==1)			// Own-account workers
			*replace ilo_job1_ste_icse93=4 if 				                // Producer cooperatives
		    replace ilo_job1_ste_icse93=5 if (e_9==4 & ilo_lfs==1)			// Contributing family workers
		 	replace ilo_job1_ste_icse93=6 if (inlist(e_9,5,.) & ilo_lfs==1)	// Not elsewhere classified
				
				label def lB_ilo_ste_icse93 1 "1 - Employees" 2 "2 - Employers" 3 "3 - Own-account workers"  4 "4 - Members of producers cooperatives" ///
				                            5 "5 - Contributing family workers" 6 "6 - Workers not classifiable by status"
				label val ilo_job1_ste_icse93 lB_ilo_ste_icse93
				label var ilo_job1_ste_icse93 "Status in employment (ICSE 93) - main job"
		
	
	* Aggregate categories 

			gen ilo_job1_ste_aggregate=.
				replace ilo_job1_ste_aggregate=1 if ilo_job1_ste_icse93==1				// Employees
				replace ilo_job1_ste_aggregate=2 if inrange(ilo_job1_ste_icse93,2,5)	// Self-employed
				replace ilo_job1_ste_aggregate=3 if ilo_job1_ste_icse93==6				// Not elsewhere classified
			        	lab def ste_aggr_lL 1 "1 - Employees" 2 "2 - Self-employed" 3 "3 - Not elsewhere classified"
			        	lab val ilo_job1_ste_aggregate ste_aggr_lL
				        label var ilo_job1_ste_aggregate "Status in employment (Aggregate) - main job"  


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: Information only available for main job
*          National classification corresponds to ISIC Rev.4 - 4 digits

			append using `labels', gen(lab)
			*use value label from this variable, afterwards drop everything related to this append
			
				* MAIN JOB:
					
					* ISIC Rev. 4 - 2 digit
						gen isic2dig = int(e_4/100)
						
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
								
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_job1_ocu_isco08') [done]
* -------------------------------------------------------------------------------------------
* ------------------------------------------------------------------------------------------
* Comment: Information only available for main job
*          National classification corresponds to ISCO08 - 2 digits

	* MAIN JOB:
	
			gen occup_2dig=int(e_2/100) if ilo_lfs==1 
	
		* ISCO 08 - 2 digits:
			gen ilo_job1_ocu_isco08_2digits=occup_2dig if ilo_lfs==1
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
		
		
		* Skill level
		    gen ilo_job1_ocu_skill=.
			    replace ilo_job1_ocu_skill=1 if ilo_job1_ocu_isco08==9                   // Low
				replace ilo_job1_ocu_skill=2 if inlist(ilo_job1_ocu_isco08,4,5,6,7,8)    // Medium
				replace ilo_job1_ocu_skill=3 if inlist(ilo_job1_ocu_isco08,1,2,3)        // High
				replace ilo_job1_ocu_skill=4 if inlist(ilo_job1_ocu_isco08,10,11)        // Not elsewhere classified
					lab def ocu_skill_lab 1 "1 - Skill level 1 (low)" 2 "2 - Skill level 2 (medium)" 3 "3 - Skill levels 3 and 4 (high)" 4 "4 - Not elsewhere classified"
				    lab val ilo_job1_ocu_skill ocu_skill_lab
				    lab var ilo_job1_ocu_skill "Occupation (Skill level)"
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_job1_ins_sector') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

		gen ilo_job1_ins_sector=.
			replace ilo_job1_ins_sector=1 if inlist(e_7,1,2) & ilo_lfs==1                                 //Public = government + public/state-owned enterprise
			replace ilo_job1_ins_sector=2 if inlist(e_7,3,4,5,6,7,8,.) & ilo_lfs==1
    				lab def ilo_job1_ins_sector_lTGL 1 "Public" 2 "Private" 
				    lab val ilo_job1_ins_sector ilo_job1_ins_sector_lTGL
				    label var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Hours of work ('ilo_job1_how_actual') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

   * MAIN JOB
     * 1) Weekly hours ACTUALLY worked:
	   
	   gen ilo_job1_how_actual = (f_2am + f_2bm + f_2cm + f_2dm + f_2em + f_2fm + f_2gm) if ilo_lfs==1
	       lab var ilo_job1_how_actual "Weekly hours actually worked in main job"
		   
	   gen ilo_job1_how_actual_bands=.
		   replace ilo_job1_how_actual_bands=1 if ilo_job1_how_actual==0
		   replace ilo_job1_how_actual_bands=2 if inrange(ilo_job1_how_actual,1,14)
		   replace ilo_job1_how_actual_bands=3 if inrange(ilo_job1_how_actual,15,29)
		   replace ilo_job1_how_actual_bands=4 if inrange(ilo_job1_how_actual,30,34)
		   replace ilo_job1_how_actual_bands=5 if inrange(ilo_job1_how_actual,35,39)
		   replace ilo_job1_how_actual_bands=6 if inrange(ilo_job1_how_actual,40,48)
		   replace ilo_job1_how_actual_bands=7 if ilo_job1_how_actual>=49 & ilo_job1_how_actual!=.
			       lab def how_bands_lab 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 
				   lab val ilo_job1_how_actual_bands how_bands_lab
				   lab var ilo_job1_how_actual_bands "Weekly hours actually worked bands in main job"
				   
   * 2) Weekly hours USUALLY worked:
     
	 gen ilo_job1_how_usual=f_1a if ilo_lfs==1
		 lab var ilo_job1_how_usual "Weekly hours usually worked in main job"
		 
	 gen ilo_job1_how_usual_bands=.
	     replace ilo_job1_how_usual_bands=1 if ilo_job1_how_usual==0
		 replace ilo_job1_how_usual_bands=2 if inrange(ilo_job1_how_usual,1,14)
		 replace ilo_job1_how_usual_bands=3 if inrange(ilo_job1_how_usual,15,29)
		 replace ilo_job1_how_usual_bands=4 if inrange(ilo_job1_how_usual,30,34)
		 replace ilo_job1_how_usual_bands=5 if inrange(ilo_job1_how_usual,35,39)
		 replace ilo_job1_how_usual_bands=6 if inrange(ilo_job1_how_usual,40,48)
		 replace ilo_job1_how_usual_bands=7 if ilo_job1_how_usual>=49 & ilo_job1_how_usual!=.
		         *label already defined for hours actually worked
			     lab val ilo_job1_how_usual_bands how_bands_lab
				 lab var ilo_job1_how_usual_bands "Weekly hours usually worked bands in main job"
				 
   * SECOND JOB
			
			/* The workers are asked how many hours they worked in "any other jobs/activities" so we cannot 
			   isolate the hours worked ONLY in the second job. 		*/
	 
   * ALL JOBS
     * 1) Weekly hours ACTUALLY worked:
	   
	   gen ilo_joball_how_actual = (f_2am + f_2ao + f_2bm + f_2bo + f_2cm + f_2co + f_2dm + f_2do + f_2em + f_2eo + f_2fm + f_2fo + f_2gm + f_2go) if ilo_lfs==1
	       lab var ilo_joball_how_actual "Weekly hours actually worked in all jobs"
	   
   	   gen ilo_joball_how_actual_bands=.
		   replace ilo_joball_how_actual_bands=1 if ilo_joball_how_actual==0
		   replace ilo_joball_how_actual_bands=2 if inrange(ilo_joball_how_actual,1,14)
		   replace ilo_joball_how_actual_bands=3 if inrange(ilo_joball_how_actual,15,29)
		   replace ilo_joball_how_actual_bands=4 if inrange(ilo_joball_how_actual,30,34)
		   replace ilo_joball_how_actual_bands=5 if inrange(ilo_joball_how_actual,35,39)
		   replace ilo_joball_how_actual_bands=6 if inrange(ilo_joball_how_actual,40,48)
		   replace ilo_joball_how_actual_bands=7 if ilo_joball_how_actual>=49 & ilo_joball_how_actual!=.
                   *label already defined for main job
				   lab val ilo_joball_how_actual_bands how_bands_lab
                   lab var ilo_joball_how_actual_bands "Weekly hours actually worked bands in all jobs"
				   
	 * 2) Weekly hours USUALLY worked:
	 
	   gen ilo_joball_how_usual=f_1c if ilo_lfs==1
		   lab var ilo_joball_how_usual "Weekly hours usually worked in all jobs"
		 
	   gen ilo_joball_how_usual_bands=.
	       replace ilo_joball_how_usual_bands=1 if ilo_joball_how_usual==0
		   replace ilo_joball_how_usual_bands=2 if inrange(ilo_joball_how_usual,1,14)
		   replace ilo_joball_how_usual_bands=3 if inrange(ilo_joball_how_usual,15,29)
		   replace ilo_joball_how_usual_bands=4 if inrange(ilo_joball_how_usual,30,34)
		   replace ilo_joball_how_usual_bands=5 if inrange(ilo_joball_how_usual,35,39)
		   replace ilo_joball_how_usual_bands=6 if inrange(ilo_joball_how_usual,40,48)
		   replace ilo_joball_how_usual_bands=7 if ilo_joball_how_usual>=49 & ilo_joball_how_usual!=.
		           *label already defined for hours actually worked
			       lab val ilo_joball_how_usual_bands how_bands_lab
				   lab var ilo_joball_how_usual_bands "Weekly hours usually worked bands in all jobs"


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job1_job_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: According to the LFS final report, the normal weekly working hours is 40	(
*          (median of the sample=48) -> threshold used: 40		

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
* Comment: 	 In addition to "unlimited duration" and "limited duration" there is another possible answer
*            "unspecified duration". This category is classified under "limited duration" as the respondants
*            are asked the same following questions as those answering "limited duration".
			

		gen ilo_job1_job_contract=.
			replace ilo_job1_job_contract=1 if e_16==2 & ilo_lfs==1                        // Unlimited duration
			replace ilo_job1_job_contract=2 if inlist(e_16,1,3) & ilo_lfs==1               // Limited duration + unspecified duration
			replace ilo_job1_job_contract=3 if inlist(e_16,4,.) & ilo_lfs==1               // Don't know + missing 
    				lab def contr_type 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"	
	    			lab val ilo_job1_job_contract contr_type	
		    		label var ilo_job1_job_contract "Job (Type of contract)"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*		Informal / Formal Economy ('ilo_job1_ife_prod' / 'ilo_job1_ife_nature') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

/* Useful questions:
                 Institutional sector: e_7
				 Destination of production: not asked
				 Bookkeeping: not asked
				 Registration: e_8
				 Status in employment: ilo_job1_ste_icse93
				 Social security contribution: pension funds (proxy): e_10
				 Paid annual leave: e_11 
				 Paid sick leave: e_12
				 Place of work: e_6
				 Size: e_5
*/	 
				 
	* Social security (to be dropped afterwards)
	
	        gen social_security=.
			    replace social_security=1 if e_10==1 & ilo_lfs==1               // Contribution to any pension or retirement fund
				replace social_security=2 if e_10==2 & ilo_lfs==1               // No contribution to any pension or retirement fund  
				replace social_security=3 if e_10==3 & ilo_lfs==1               // Don't know
				replace social_security=. if e_10==. & ilo_lfs==1               // Not answered
	 
	
	* 1) UNIT OF PRODUCTION: FORMAL/INFORMAL SECTOR	

			gen ilo_job1_ife_prod=.
			    replace ilo_job1_ife_prod=1 if ilo_lfs==1 & ///
				                               ((inlist(e_7,3,6,7,8,.) & inlist(e_8,2,3))| ///
											   (inlist(e_7,3,6,7,8,.) & inlist(e_8,4,9,.) & ilo_job1_ste_icse93==1 & social_security!=1 & e_6!=3)| ///
											   (inlist(e_7,3,6,7,8,.) & inlist(e_8,4,9,.) & ilo_job1_ste_icse93==1 & social_security!=1 & e_6==3 & inlist(e_5,1,2,.))| ///
											   (inlist(e_7,3,6,7,8,.) & inlist(e_8,4,9,.) & ilo_job1_ste_icse93!=1 & e_6!=3)| ///
											   (inlist(e_7,3,6,7,8,.) & inlist(e_8,4,9,.) & ilo_job1_ste_icse93!=1 & e_6==3 & inlist(e_5,1,2,.)))
				replace ilo_job1_ife_prod=2 if ilo_lfs==1 & ///
				                               ((inlist(e_7,1,2,4))| ///
											   (inlist(e_7,3,6,7,8,.) & e_8==1)| ///
											   (inlist(e_7,3,6,7,8,.) & inlist(e_8,4,9,.) & ilo_job1_ste_icse93==1 & social_security==1)| ///
											   (inlist(e_7,3,6,7,8,.) & inlist(e_8,4,9,.) & ilo_job1_ste_icse93==1 & social_security!=1 & e_6==3 & inlist(e_5,3,4,5,6,7))| ///
											   (inlist(e_7,3,6,7,8,.) & inlist(e_8,4,9,.) & ilo_job1_ste_icse93!=1 & e_6==3 & inlist(e_5,3,4,5,6,7)))
				replace ilo_job1_ife_prod=3 if ilo_lfs==1 & ///
				                               (e_7==5)
						lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 
						lab val ilo_job1_ife_prod ilo_ife_prod_lab
						lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"
			

	
	
	* 2) NATURE OF JOB: FORMAL/INFORMAL EMPLOYMENT
	
			gen ilo_job1_ife_nature=.
                replace ilo_job1_ife_nature=2 if ilo_lfs==1 & ///
				                                 ((inlist(ilo_job1_ste_icse93,1,6) & social_security==1)| ///
												 (inlist(ilo_job1_ste_icse93,1,6) & social_security==. & e_11==1 & e_12==1)| ///
												 (inlist(ilo_job1_ste_icse93,2,4) & ilo_job1_ife_prod==2)| ///
												 (ilo_job1_ste_icse93==3 & ilo_job1_ife_prod==2))
                replace ilo_job1_ife_nature=1 if ilo_lfs==1 & ///
				                                 ((inlist(ilo_job1_ste_icse93,1,6) & inlist(social_security,2,3))| /// 
												 (inlist(ilo_job1_ste_icse93,1,6) & social_security==. & (e_11!=1 | e_12!=1))| ///
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
/* Comment: Questions e_22 to e_25 refer to labour related income of the employees. They are asked how much
	        they earned in cash and in kind last time they were paid. In addition, they are asked what's
	        the periodicity of the payments (i.e 1 month, 1 fornight, 1 week, 1 day or other). 
        
		**  In the case of self-employment, questions e_25a and e_25b refer to total earnings in cash and 
           in kind (after deducting expenses) in a period of 2 weeks for all respondants to this question 
		   
	    **  To convert daily and weekly income into monthly income, the following factors were used:
			- monthly income = (365/12)*daily income
			- monthly income = (((365/7)/12)/2) *fortnight income
			- monthly income = ((365/7)/12)*weekly income*/
			
/* NOTES: For employees => 1. gross (T10:138)
	                           2. main job currently held (T11:142)
							   3. including payments in kind (T34:400)
		  For self-employed => 1. net: after deducting expenses (T10:139)
*/
			
	* Employees:
		gen cash_month=. /*to drop*/
			replace cash_month = e_23a if ilo_job1_ste_aggregate==1 & e_24a==1                             //cash per month
			replace cash_month = e_23a * (((365/7)/12)/2) if ilo_job1_ste_aggregate==1 & e_24a==2          //cash per fortnight
			replace cash_month = e_23a * ((365/7)/12) if ilo_job1_ste_aggregate==1 & e_24a==3              //cash per week
			replace cash_month = e_23a * (365/12) if ilo_job1_ste_aggregate==1 & e_24a==4                  //cash per day
			replace cash_month = . if cash_month==. & ilo_job1_ste_aggregate==1                            //cash other periodicity or NR                           
			
		gen kind_month=. /*to drop*/
			replace kind_month = e_23b if ilo_job1_ste_aggregate==1 & e_24b==1                             //kind per month
			replace kind_month = e_23b * (((365/7)/12)/2) if ilo_job1_ste_aggregate==1 & e_24b==2          //kind per fortnight
			replace kind_month = e_23b * ((365/7)/12) if ilo_job1_ste_aggregate==1 & e_24b==3              //kind per week
			replace kind_month = e_23b * (365/12) if ilo_job1_ste_aggregate==1 & e_24b==4                  //kind per day
			replace kind_month = . if kind_month==. & ilo_job1_ste_aggregate==1                            //kind other periodicity or NR
			
			
		egen ilo_job1_lri_ees = rowtotal(cash_month kind_month), m
		     replace ilo_job1_lri_ees=. if ilo_job1_ste_aggregate!=1
			         lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"
	
	* Self-employed:
	    gen cash_month_slf=. /*to drop*/
	        replace cash_month_slf = e_26a * (((365/7)/12)/2) if ilo_job1_ste_aggregate==2                 //cash per fortnight
		    replace cash_month_slf =. if cash_month_slf==. & ilo_job1_ste_aggregate==2
			
			
		gen kind_month_slf=. /*to drop*/
		    replace kind_month_slf = e_26b * (((365/7)/12)/2) if ilo_job1_ste_aggregate==2                 //kind per fortnight
		    replace kind_month_slf =. if kind_month_slf==. & ilo_job1_ste_aggregate==2
			
			
		egen ilo_job1_lri_slf = rowtotal(cash_month_slf kind_month_slf), m
		     replace ilo_job1_lri_slf=. if ilo_job1_ste_aggregate!=2
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
		hours.
	
	  * Threshold used: 40 hours/week */ 	
		 
		gen ilo_joball_tru=.
			replace ilo_joball_tru=1 if (ilo_lfs==1 & g_1==1 & g_2>0 & ilo_joball_how_usual<40)
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
			replace ilo_joball_oi_case = j_4 if (j_1==1 & ilo_lfs==1) 
				lab var ilo_joball_oi_case "Cases of non-fatal occupational injuries"
		
   /* Days lost due to occupatinal injuries:
	  * Code 98 is for "Don't know" and 99 for those who expect never returning to work. There 
	    are recoded as missing as they do not represent 98 or 99 days. 		*/

	
		gen ilo_joball_oi_day=.
			replace ilo_joball_oi_day =j_10 if (j_1==1 & ilo_lfs==1) 
			replace ilo_joball_oi_day =. if inlist(j_10,98,99)
				lab var ilo_joball_oi_day "Days lost due to cases of occupational injury"
	
***********************************************************************************************
*			PART 3.3. UNEMPLOYMENT: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Category of unemployment ('ilo_cat_une') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: No information available

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

		* Aggregate:
		
			gen ilo_dur_aggregate=.
				replace ilo_dur_aggregate=1 if inlist(h_6,1,2) & ilo_lfs==2 	    // Less than 6 months
				replace ilo_dur_aggregate=2 if h_6==3 & ilo_lfs==2				    // 6 months to less than 12 months
				replace ilo_dur_aggregate=3 if inlist(h_6,4,5,6) & ilo_lfs==2	    // 12 months or more
				replace ilo_dur_aggregate=4 if inlist(h_6,7,9,.) & ilo_lfs==2	    // Not elsewhere classified
					lab def ilo_unemp_agr 1 "Less than 6 months" 2 "6 months to less than 12 months" ///
										  3 "12 months or more" 4 "Not elsewhere classified"
					lab values ilo_dur_aggregate ilo_unemp_agr
					lab var ilo_dur_aggregate "Duration of unemployment (Aggregate)"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
* Comment: No information available
	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
* Comment: No information available
	

		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			General social protection ('ilo_gsp_unschemes') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
*Comment: No information available
	


***********************************************************************************************
*			PART 3.4. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
	
	gen ilo_olf_dlma=.
		replace ilo_olf_dlma = 1 if (h_1==1 & h_7==2 & ilo_lfs==3) 				//Seeking, not available
		replace ilo_olf_dlma = 2 if (h_1==2 & h_7==1 & ilo_lfs==3)				//Not seeking, available
		replace ilo_olf_dlma = 3 if (h_1==2 & h_7==2 & h_3==1 & ilo_lfs==3)		//Not seeking, not available, willing
		replace ilo_olf_dlma = 4 if (h_1==2 & h_7==2 & h_3==2 & ilo_lfs==3)		//Not seeking, not available, not willing
		replace ilo_olf_dlma = 5 if	(ilo_olf_dlma==. & ilo_lfs==3)				//Not elsewhere classified	
			    lab def dlma_lab 1 "1 - Seeking, not available (Unavailable jobseekers)" 2 "2 - Not seeking, available (Available potential jobseekers)" ///
				     			 3 "3 - Not seeking, not available, willing (Willing non-jobseekers)" 4 "4 - Not seeking, not available, not willing" 5 "X - Not elsewhere classified"
			    lab val ilo_olf_dlma dlma_lab 
			    lab var ilo_olf_dlma "Labour market attachment (Degree of)"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reason for not seeking job ('ilo_olf_reason') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
	
	gen ilo_olf_reason=.
		replace ilo_olf_reason=1 if	(inlist(h_4,2,3,7,8,9,10) & ilo_lfs==3)			//Labour market
		replace ilo_olf_reason=2 if	(inlist(h_4,4,5,6) & ilo_lfs==3)				//Personal/Family-related
		replace ilo_olf_reason=3 if (h_3==2 & ilo_lfs==3)							//Does not need/want to work
		replace ilo_olf_reason=4 if (h_4==11 & ilo_lfs==3)							//Not elsewhere classified
		replace ilo_olf_reason=4 if (ilo_olf_reason==. & ilo_lfs==3)				//Not elsewhere classified
			lab def reasons_lab 1 "1 - Labour market" 2 "2 - Personal / Family-related" ///
							    3 "3 - Does not need/want to work" 4 "4 - Not elsewhere classified"
			lab val ilo_olf_reason reasons_lab 
			lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seeker ('ilo_dis')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

	gen ilo_dis=1 if (ilo_lfs==3 & h_7==1 & ilo_olf_reason==1)
			lab def dis_lab 1 "Discouraged job-seekers"
			lab val ilo_dis dis_lab
			lab var ilo_dis "Discouraged job-seekers"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training ('ilo_neet')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

	gen ilo_neet=1 if (ilo_age_aggregate==2 & ilo_lfs!=1 & ilo_edu_attendance==2)
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
		drop lab isco08_2digits isco88_2digits isco08 isco88 isic4_2digits isic4 isic3_2digits isic3 isic2dig occup_2dig
		drop occup_1dig social_security cash_month kind_month cash_month_slf kind_month_slf
		
		compress 
		
	   /*Save dataset including original and ilo variables*/
	
		save ${country}_${source}_${time}_FULL,  replace		
	
	  /* Save file only containing ilo_* variables*/
	
		keep ilo*

		save ${country}_${source}_${time}_ILO, replace
