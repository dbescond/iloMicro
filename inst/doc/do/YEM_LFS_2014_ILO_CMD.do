* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Yemen 2014
* DATASET USED: Yemen LFS 2014
* NOTES: 
* Authors: Mabelin Villarreal-Fuentes
* Who last updated the file: Mabelin Villarreal-Fuentes
* Starting Date: 16 June 2017
* Last updated: 19 June 2017
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
global country "YEM"
global source "LFS"
global time "2014"
global inputFile "DerivedData_Yemen"
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
* Comment: Not possible to rename all variables in lower case because there are different
*          variables with the same name in lower and upper case.

cd "$inpath"
	use "$inputFile", clear
	*renaming everything in lower case
	*rename *, lower  
	
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
*			Time period ('ilo_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
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
*-- generates variable "to_drop" that will be split in two parts: annual part (to_drop_1) and quarterly part (to_drop_2)
   decode ilo_time, gen(to_drop)
   split to_drop, generate(to_drop_) parse(Q)
   destring to_drop_1, replace force

*-- generation of to_drop_2 that contains information on the quarter (if it is quarterly) or -9999 if its annual
   capture destring to_drop_2, replace force
   capture gen to_drop_2=-9999
   local Q = to_drop_2 in 1

*-- annual
gen ilo_wgt=.
    lab var ilo_wgt "Sample weight"	

if `Q' == -9999{
    replace ilo_wgt=annual_w
}

*-- quarters        

else{
    replace ilo_wgt = weight_Q`Q'
	keep if quarter==`Q'
}	

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
		replace ilo_geo=1 if urbrural==1
		replace ilo_geo=2 if urbrural==2
			lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural"
			lab val ilo_geo ilo_geo_lab
			lab var ilo_geo "Geographical coverage"	
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: 928 observations without information on sex/age -> not kept

	gen ilo_sex=.
	    replace ilo_sex=1 if sex==1
		replace ilo_sex=2 if sex==2 
		        lab def ilo_sex_lab 1 "1 - Male" 2 "2 - Female"
		        lab var ilo_sex "Sex"
		        lab val ilo_sex ilo_sex_lab

    keep if ilo_sex!=.
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
*			Education ('ilo_edu') [in progress]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Question only asked to those aged 10 years old or more, the rest are classified 
*            under "not elsewhere classified"
*          - Only aggregate? or ISCED97
/*
	gen ilo_edu_isced11=.
		*replace ilo_edu_isced11=1 if  					                        // No schooling
		replace ilo_edu_isced11=2 if b_5==1 					                // Early childhood education
		replace ilo_edu_isced11=3 if inlist(b_5,2,3,4,5,6,7)                    // Primary education
		replace ilo_edu_isced11=4 if inlist(b_5,8,9,10)                         // Lower secondary education
		replace ilo_edu_isced11=5 if inlist(b_5,11,12)      		            // Upper secondary education
		replace ilo_edu_isced11=6 if inlist(b_5,13,14,15)                	    // Post-secondary non-tertiary education
		replace ilo_edu_isced11=7 if inlist(b_5,16,17,18,19,20) 			    // Short-cycle tertiary eucation
		replace ilo_edu_isced11=8 if b_5==21     				                // Bachelor's or equivalent level
		replace ilo_edu_isced11=9 if b_5==22	                                // Master's or equivalent level
		*replace ilo_edu_isced11=10 if		                                    // Doctoral or equivalent level
		replace ilo_edu_isced11=11 if ilo_edu_isced11==.		                // Not elsewhere classified
		label def isced_11_lab 1 "X - No schooling" 2 "0 - Early childhood education" 3 "1 - Primary education" 4 "2 - Lower secondary education" ///
							   5 "3 - Upper secondary education" 6 "4 - Post-secondary non-tertiary education" 7 "5 - Short-cycle tertiary eucation" ///
							   8 "6 - Bachelor's or equivalent level" 9 "7 - Master's or equivalent level" 10 "8 - Doctoral or equivalent level" 11 "9 - Not elsewhere classified"
			label val ilo_edu_isced11 isced_11_lab
			lab var ilo_edu_isced11 "Education (ISCED 11)"

		
	gen ilo_edu_aggregate=.
		replace ilo_edu_aggregate=1 if inlist(ilo_edu_isced11,1,2)
		replace ilo_edu_aggregate=2 if inlist(ilo_edu_isced11,3,4)
		replace ilo_edu_aggregate=3 if inlist(ilo_edu_isced11,5,6)
		replace ilo_edu_aggregate=4 if inlist(ilo_edu_isced11,7,8,9,10)
		replace ilo_edu_aggregate=5 if ilo_edu_isced11==11
			label def edu_aggr_lab 1 "1 - Less than basic" 2 "2 - Basic" 3 "3 - Intermediate" 4 "4 - Advanced" 5 "5 - Level not stated"
			label val ilo_edu_aggregate edu_aggr_lab
			label var ilo_edu_aggregate "Education (Aggregate level)"
*/			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education attendance ('ilo_edu_attendance') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Question only asked to those aged 5 years old or more; therefore, those below 5
*            are classified under "not elsewhere classified"

gen ilo_edu_attendance=.
			replace ilo_edu_attendance=1 if q_108==1                            // Yes
			replace ilo_edu_attendance=2 if inlist(q_108,2,3)                   // No
			replace ilo_edu_attendance=3 if ilo_edu_attendance==.               // Not elsewhere classified
				    lab def edu_attendance_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
				    lab val ilo_edu_attendance edu_attendance_lab
				    lab var ilo_edu_attendance "Education (Attendance)"
					
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Disability status ('ilo_dsb') [in progress]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment: Not available (double check)
					
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
* Comment: 15+ population

	gen ilo_wap=.
		replace ilo_wap=1 if ilo_age>=15 & ilo_age!=.
			label def ilo_wap_lab 1 "Working age population"
			label val ilo_wap ilo_wap_lab
			label var ilo_wap "Working age population"
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Labour Force Status ('ilo_lfs')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: 

   gen ilo_lfs=.
	   replace ilo_lfs=1 if (q_112==1 | q_113==1) & ilo_wap==1                  // Employed or temporary absent
	   foreach i of num 1/12 {
	     replace ilo_lfs=1 if q_114_`i'==1 & ilo_wap==1                         // Employed for at least 1 hour
	   } 
	   replace ilo_lfs=2 if (q_118==1 & q_119==1) & ilo_wap==1                  // Future starters
	   foreach i of num 1/12 {
	     replace ilo_lfs=2 if (q_116==1 & q_117_`i'==1 & q_119==1) & ilo_wap==1 // Unemployed (seeking (took steps) and available)
	   } 
       replace ilo_lfs=3 if !inlist(ilo_lfs,1,2) & ilo_wap==1                   // Outside the labour market
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
	    replace ilo_mjh=2 if q201==1 & ilo_lfs==1                          
		replace ilo_mjh=2 if q201==2 & ilo_lfs==1                 
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
*Comment: 

  * MAIN JOB:
	
	* Detailed categories:
	gen ilo_job1_ste_icse93=.
		replace ilo_job1_ste_icse93=1 if q_205==1 & ilo_lfs==1 	                // Employees
		replace ilo_job1_ste_icse93=2 if q_205==2 & ilo_lfs==1	                // Employers
		replace ilo_job1_ste_icse93=3 if q_205==3 & ilo_lfs==1                  // Own-account workers
		*replace ilo_job1_ste_icse93=4                                          // Members of producers’ cooperatives
		replace ilo_job1_ste_icse93=5 if q_205==4 & ilo_lfs==1     	            // Contributing family workers
		replace ilo_job1_ste_icse93=6 if inlist(q_205,5,9,.) & ilo_lfs==1       // Not classifiable
			    label def label_ilo_ste_icse93 1 "1 - Employees" 2 "2 - Employers" 3 "3 - Own-account workers"                ///
				    						   4 "4 - Members of producers cooperatives" 5 "5 - Contributing family workers"  ///
					    					   6 "6 - Workers not classifiable by status"
			    label val ilo_job1_ste_icse93 label_ilo_ste_icse93
			    label var ilo_job1_ste_icse93 "Status in employment (ICSE 93) in main job"

	* Aggregate categories 
	gen ilo_job1_ste_aggregate=.
		replace ilo_job1_ste_aggregate=1 if ilo_job1_ste_icse93==1				// Employees
		replace ilo_job1_ste_aggregate=2 if inrange(ilo_job1_ste_icse93,2,5)	// Self-employed
		replace ilo_job1_ste_aggregate=3 if ilo_job1_ste_icse93==6				// Not elsewhere classified
	    		lab def ste_aggr_lab 1 "1 - Employees" 2 "2 - Self-employed" 3 "3 - Not elsewhere classified"
				lab val ilo_job1_ste_aggregate ste_aggr_lab
				label var ilo_job1_ste_aggregate "Status in employment (Aggregate) in main job"  

				
  * SECOND JOB:
  * Not available
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_job1_eco_') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - ISIC Rev.3 at two digit-level

    * Import value labels
    append using `labels', gen (lab)
    * Use value label from this variable, afterwards drop everything related to this append


    * MAIN JOB
    * Two digit-level

    gen ilo_job1_eco_isic3_2digits=isic if ilo_lfs==1
	    lab values ilo_job1_eco_isic3_2digits isic3_2digits
	    lab var ilo_job1_eco_isic3_2digits "Economic activity (ISIC Rev. 3), 2 digit level"

    * One digit-level
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
			
    * Aggregate level
	
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
				
    * SECOND JOB
    * Not available		
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_job1_ocu_') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment: - ISCO88 at two digit-level

   * MAIN JOB
   * Two digit-level
   gen occ_code_prim=int(occup4/100) if ilo_lfs==1 
   
   gen ilo_job1_ocu_isco88_2digits=occ_code_prim
	   lab values ilo_job1_ocu_isco88_2digits isco88_2digits
	   lab var ilo_job1_ocu_isco88_2digits "Occupation (ISCO-88), 2 digit level"
			
    * One digit-level
	gen ilo_job1_ocu_isco88=.
	    replace ilo_job1_ocu_isco88=11 if inlist(ilo_job1_ocu_isco88_2digits,8,99,.) & ilo_lfs==1                    //Not elsewhere classified
		replace ilo_job1_ocu_isco88=int(ilo_job1_ocu_isco88_2digits/10) if (ilo_job1_ocu_isco88==. & ilo_lfs==1)     //The rest of the occupations
		replace ilo_job1_ocu_isco88=10 if (ilo_job1_ocu_isco88==0 & ilo_lfs==1)                                      //Armed forces
				lab val ilo_job1_ocu_isco88 isco88
				lab var ilo_job1_ocu_isco88 "Occupation (ISCO-88)"
				
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
				
	* SECOND JOB:
    * Not available
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*	Institutional sector of economic activities ('ilo_job1_ins_sector') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment: - Public includes: government, public administration and public sector enterprise

    * MAIN JOB
	gen ilo_job1_ins_sector=.
		replace ilo_job1_ins_sector=1 if inlist(q_212,1,2) & ilo_lfs==1         // Public
		replace ilo_job1_ins_sector=2 if ilo_job1_ins_sector==. & ilo_lfs==1	// Private
    			lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
			    lab values ilo_job1_ins_sector ins_sector_lab
			    lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities in main job"				

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job1_job_contract') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment:

   * MAIN JOB
   gen ilo_job1_job_contract=.
	   replace ilo_job1_job_contract=1 if q_215==1 & ilo_lfs==1                 // Permanent (unlimited duration)
	   replace ilo_job1_job_contract=2 if inlist(q_215,2,3,4) & ilo_lfs==1      // Temporary (limited duration)
	   replace ilo_job1_job_contract=3 if inlist(q_215,9,.) & ilo_lfs==1        // Unknown
			   lab def job_contract_lab 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"
			   lab val ilo_job1_job_contract job_contract_lab
			   lab var ilo_job1_job_contract "Job (Type of contract) in main job"			
	   
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Formal / Informal Economy ('ilo_job1_ife_prod' 'ilo_job1_ife_nature') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
* Comment: 	
/* Useful questions:
			- Institutional sector: q_212
			- Destination of production: not asked 
			- Bookkeeping: q_208
			- Registration: q_209
			- Household identification: ilo_job1_eco_isic3_2digits==95 or ilo_job1_ocu_isco88_2digits==62
			- Social security contribution: q_216
			- Place of work: q_219
			- Size: q_207 (cutoff at 5)
			- Status in employment: ilo_job1_ste_aggregate / ilo_job1_ste_icse93
			- Paid annual leave: q_218
			- Paid sick leave: q_217
*/
	
	* 1) UNIT OF PRODUCTION: FORMAL/INFORMAL SECTOR		
    			
			gen ilo_job1_ife_prod=.
			    replace ilo_job1_ife_prod=3 if ilo_lfs==1 & ((ilo_job1_eco_isic3_2digits==95) | ///
				                               (ilo_job1_ocu_isco88_2digits==62))
				replace ilo_job1_ife_prod=2 if ilo_lfs==1 & ((inlist(q_212,1,2,8,9,10)) | ///
				                               (inlist(q_212,3,4,5,6,7,99,.) & q_208==1) | ///
											   (inlist(q_212,3,4,5,6,7,99,.) & q_208!=1 & q_209==1) | ///
											   (inlist(q_212,3,4,5,6,7,99,.) & q_208!=1 & q_209==. & ilo_job1_ste_aggregate==1 & q_216==1) | ///
											   (inlist(q_212,3,4,5,6,7,99,.) & q_208!=1 & q_209==. & ilo_job1_ste_aggregate==1 & q_216!=1 & inlist(q_219,1,2,3,4) & inlist(q_207,2,3,4,5,6)) | ///
											   (inlist(q_212,3,4,5,6,7,99,.) & q_208!=1 & q_209==. & ilo_job1_ste_aggregate!=1 & inlist(q_219,1,2,3,4) & inlist(q_207,2,3,4,5,6)))
			    replace ilo_job1_ife_prod=1 if ilo_lfs==1 & (!inlist(ilo_job1_ife_prod,3,2)) & ///
				                               ((inlist(q_212,3,4,5,6,7,99,.) & q_208!=1 & inlist(q_209,2,3)) | ///
				                               (inlist(q_212,3,4,5,6,7,99,.) & q_208!=1 & q_209==. & ilo_job1_ste_aggregate==1 & q_216!=1 & !inlist(q_219,1,2,3,4)) | ///
											   (inlist(q_212,3,4,5,6,7,99,.) & q_208!=1 & q_209==. & ilo_job1_ste_aggregate==1 & q_216!=1 & inlist(q_219,1,2,3,4) & !inlist(q_207,2,3,4,5,6)) | ///
											   (inlist(q_212,3,4,5,6,7,99,.) & q_208!=1 & q_209==. & ilo_job1_ste_aggregate!=1 & !inlist(q_219,1,2,3,4)) | ///
											   (inlist(q_212,3,4,5,6,7,99,.) & q_208!=1 & q_209==. & ilo_job1_ste_aggregate!=1 & inlist(q_219,1,2,3,4) & !inlist(q_207,2,3,4,5,6)))
				        lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 
						lab val ilo_job1_ife_prod ilo_ife_prod_lab
						lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"
						
						
	* 2) NATURE OF JOB: FORMAL/INFORMAL EMPLOYMENT
	
	      gen ilo_job1_ife_nature=.
		      replace ilo_job1_ife_nature=2 if ilo_lfs==1 & ((inlist(ilo_job1_ste_icse93,1,6) & q_216==1) | ///
			                                   (inlist(ilo_job1_ste_icse93,1,6) & inlist(q_216,3,9,.) & q_218==1 & q_217==1) | ///
											   (inlist(ilo_job1_ste_icse93,2,4) & ilo_job1_ife_prod==2) | ///
											   (ilo_job1_ste_icse93==3 & ilo_job1_ife_prod==2))
			  replace ilo_job1_ife_nature=1 if ilo_lfs==1 & (ilo_job1_ife_nature!=2)
			          lab def ife_nature_lab 1 "1 - Persons with informal main job" 2 "2 - Persons with formal main job"
			          lab val ilo_job1_ife_nature ife_nature_lab
			          lab var ilo_job1_ife_nature "Informal / Formal Economy (Nature of job)"			   
				


				
