* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Liberia, 2010
* DATASET USED: Liberia LFS 2010
* NOTES:
* Authors: Yves Perardel
* Who last updated the file: Yves Perardel
* Starting Date: 30 November 2016
* Last updated: 2 December 2016
***********************************************************************************************


***********************************************************************************************
***********************************************************************************************

* 			1. SET UP WORK DIRECTORY, FILE NAME, VARIABLES AND FUNCTIONS

***********************************************************************************************
***********************************************************************************************

clear all 

set more off

global inpath "J:\COMMON\STATISTICS\DPAU\MICRO\LBR\LFS\2010\ORI"
global temppath "J:\COMMON\STATISTICS\DPAU\MICRO\_Admin"
global outpath "J:\COMMON\STATISTICS\DPAU\MICRO\LBR\LFS\2010"

************************************************************************************
* Make a tempfile containing the labels for the classifications ISIC and ISCO 
		
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
			
			save "`labels'"


*---------------------------------------------------------------------------------------------
*---------------------------------------------------------------------------------------------
* 			Load original dataset
*---------------------------------------------------------------------------------------------
*---------------------------------------------------------------------------------------------

cd "$inpath"

	use "LBR_LFS_2010", clear
		

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
*			Key identifier ('ilo_key')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_key=_n
		lab var ilo_key "Key unique identifier per individual"		


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sample Weight ('ilo_wgt')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_wgt=perwt
		lab var ilo_wgt "Sample weight"		


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time period ('ilo_time')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	* Year 2010
	gen ilo_time=1
		lab def lab_time 1 "2010" 
		lab val ilo_time lab_time
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

	gen ilo_geo=.
		replace ilo_geo=1 if u1r2==1
		replace ilo_geo=2 if u1r2==2
			lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural"
			lab val ilo_geo ilo_geo_lab
			lab var ilo_geo "Geographical coverage"	

			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_sex=b3
		lab def ilo_sex_lab 1 "1 - Male" 2 "2 - Female"
		lab var ilo_sex "Sex"
		lab val ilo_sex ilo_sex_lab


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_age=b4
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
*			Education ('ilo_edu')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
		
/* ISCED 11 mapping: based on the mapping developped by UNESCO
					http://www.uis.unesco.org/Education/ISCEDMappings/Pages/default.aspx
					http://www.uis.unesco.org/Education/Documents/isced-2011-en.pdf 	*/

* Note that according to the definition, the highest level CONCLUDED is considered.

	gen ilo_edu_isced11=.
		replace ilo_edu_isced11=1 if c2==2  					// No schooling
		replace ilo_edu_isced11=1 if c5==10 					// No schooling
		replace ilo_edu_isced11=2 if inrange(c5,11,15)  		// Early childhood education
		replace ilo_edu_isced11=3 if inrange(c5,16,22)  		// Primary education
		replace ilo_edu_isced11=4 if inrange(c5,23,25)  		// Lower secondary education
		replace ilo_edu_isced11=5 if c5==26        	        	// Upper secondary education
		replace ilo_edu_isced11=6 if inrange(c5,31,33) 			// Post-secondary non-tertiary
		replace ilo_edu_isced11=8 if c5==35     				// Bachelor or equivalent
		replace ilo_edu_isced11=9 if c5==36     				// Master's or equivalent level
		replace ilo_edu_isced11=11 if ilo_edu_isced11==.			// Not elsewhere classified
			label def isced_11_lab 1 "X - No schooling" 2 "0 - Early childhood education" 3 "1 - Primary education" 4 "2 - Lower secondary education" ///
							5 "3 - Upper secondary education" 6 "4 - Post-secondary non-tertiary education" 7 "5 - Short-cycle tertiary education" ///
							8 "6 - Bachelor's or equivalent level" 9 "7 - Master's or equivalent level" 10 "8 - Doctoral or equivalent level" 11 "9 - Not elsewhere classified"
			label val ilo_edu_isced11 isced_11_lab
			lab var ilo_edu_isced11 "Education (ISCED 11)"

		
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
*			Education attendance ('ilo_edu_attendance')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_edu_attendance=.
		replace ilo_edu_attendance=1 if c6==1				// Attending
		replace ilo_edu_attendance=2 if c6!=1				// Not attending
			label def edu_att_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
			label val ilo_edu_attendance edu_att_lab
			label var ilo_edu_attendance "Education (Attendance)"

			
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Disability status ('ilo_dsb')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
				
	gen ilo_dsb_aggregate=.
		replace ilo_dsb_aggregate=1 if (b11==2 | b11==0)
		replace ilo_dsb_aggregate=2 if (b11==1)
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

	gen ilo_wap=.
		replace ilo_wap=1 if (ilo_age>=15 & ilo_age!=.)
			lab def wap_lab 1 "Working age population"
			lab val ilo_wap wap_lab
			label var ilo_wap "Working age population"

	drop ilo_age

	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Labour Force Status ('ilo_lfs')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
		  
	gen ilo_lfs=.
		replace ilo_lfs=1 if ((d1a==1 | d1b==1 | d1c==1 | d1d==1 | d1e==1 | d1f==1 | d1g==1) & ilo_wap==1) 	// Employed
		replace ilo_lfs=1 if (d2==1 & (d3==1 | d4==1) & d5!=13 & ilo_wap==1) 								// Employed (temporary absent)
		replace ilo_lfs=2 if (ilo_wap==1 & ilo_lfs!=1 & h1==1 & h3==1) | (ilo_wap==1 & ilo_lfs!=1 & h5==6)	// Unemployed
		replace ilo_lfs=3 if ilo_lfs!=1 & ilo_lfs!=2 & ilo_wap==1  											// Outside the labour force
				label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside the Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status"


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_mjh=.
		replace ilo_mjh=1 if f1==2 & ilo_lfs==1
		replace ilo_mjh=2 if f1==1 & ilo_lfs==1
			lab def lab_ilo_mjh 1 "1 - One job only" 2 "2 - More than one job"
			lab val ilo_mjh lab_ilo_mjh
			lab var ilo_mjh "Multiple job holders"		
	
	

***********************************************************************************************
*			PART 3.1. ECONOMIC CHARACTERISTICS FOR MAIN JOB 
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Status in employment ('ilo_job1_ste')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

  * MAIN JOB:
	
	* Detailed categories:
	
		gen ilo_job1_ste_icse93=.
			replace ilo_job1_ste_icse93=1 if e6==1 & ilo_lfs==1		// Employees
			replace ilo_job1_ste_icse93=2 if e6==2 & ilo_lfs==1		// Employers
			replace ilo_job1_ste_icse93=3 if e6==3 & ilo_lfs==1		// Own-account workers
			replace ilo_job1_ste_icse93=4 if e6==4 & ilo_lfs==1		// Producer cooperatives
			replace ilo_job1_ste_icse93=5 if e6==5 & ilo_lfs==1		// Contributing family workers
			replace ilo_job1_ste_icse93=6 if e6==6 & ilo_lfs==1		// Not classifiable

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

				
  * SECOND JOB:
	
	* Detailed categories:
	
		gen ilo_job2_ste_icse93=.
			replace ilo_job2_ste_icse93=1 if f6==1 & ilo_mjh==2		// Employees
			replace ilo_job2_ste_icse93=2 if f6==2 & ilo_mjh==2		// Employers
			replace ilo_job2_ste_icse93=3 if f6==3 & ilo_mjh==2		// Own-account workers
			replace ilo_job2_ste_icse93=4 if f6==4 & ilo_mjh==2		// Producer cooperatives
			replace ilo_job2_ste_icse93=5 if f6==5 & ilo_mjh==2		// Contributing family workers
			replace ilo_job2_ste_icse93=6 if f6==6 & ilo_mjh==2  	// Not classifiable
				label val ilo_job2_ste_icse93 label_ilo_ste_icse93
				label var ilo_job2_ste_icse93 "Status in employment (ICSE 93)- second job"

	* Aggregate categories 
		
		gen ilo_job2_ste_aggregate=.
			replace ilo_job2_ste_aggregate=1 if ilo_job2_ste_icse93==1				// Employees
			replace ilo_job2_ste_aggregate=2 if inrange(ilo_job2_ste_icse93,2,5)	// Self-employed
			replace ilo_job2_ste_aggregate=3 if ilo_job2_ste_icse93==6				// Not elsewhere classified
				lab val ilo_job2_ste_aggregate ste_aggr_lab
				label var ilo_job2_ste_aggregate "Status in employment (Aggregate) - second job"  


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	/* Classification used: ISIC Rev. 4 */

	append using `labels'
		* Use value label from this variable, afterwards drop everything related to this append
					
		* Primary activity
		
		gen ilo_job1_eco_isic4_2digits=e4 if (e4!=0 & ilo_lfs==1)
			lab values ilo_job1_eco_isic4 isic4_2digits
			lab var ilo_job1_eco_isic4_2digits "Economic activity (ISIC Rev. 4), 2 digit level"
			
		* Secondary activity
		
		gen ilo_job2_eco_isic4_2digits=f5 if (f5!=0 & ilo_lfs==1)
			lab values ilo_job2_eco_isic4 isic4_2digits
			lab var ilo_job2_eco_isic4_2digits "Economic activity (ISIC Rev. 4), 2 digit level in secondary job"
		
	* One digit level

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
				lab val ilo_job1_eco_isic4 isic4
				lab var ilo_job1_eco_isic4 "Economic activity (ISIC Rev. 4)"
				
		* Secondary activity
		
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
			replace ilo_job2_eco_isic4=22 if ilo_job2_eco_isic4_2digits==. & ilo_lfs==1 & ilo_mjh==2
				lab val ilo_job1_eco_isic4 isic4
				lab var ilo_job2_eco_isic4 "Economic activity (ISIC Rev. 4) in secondary job"
		

	* Classification aggregated level
	
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

		* Secondary activity
		
		gen ilo_job2_eco_aggregate=.
			replace ilo_job2_eco_aggregate=1 if ilo_job2_eco_isic4==1
			replace ilo_job2_eco_aggregate=2 if ilo_job2_eco_isic4==3
			replace ilo_job2_eco_aggregate=3 if ilo_job2_eco_isic4==6
			replace ilo_job2_eco_aggregate=4 if inlist(ilo_job2_eco_isic4,2,4,5)
			replace ilo_job2_eco_aggregate=5 if inrange(ilo_job2_eco_isic4,7,14)
			replace ilo_job2_eco_aggregate=6 if inrange(ilo_job2_eco_isic4,15,21)
			replace ilo_job2_eco_aggregate=7 if ilo_job2_eco_isic4==22
		
				lab val ilo_job2_eco_aggregate eco_aggr_lab
				lab var ilo_job2_eco_aggregate "Economic activity (Aggregate) in secondary job"


	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_job1_ocu_isco08')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
	
	/* Classification used: ISCO 08  */

	* MAIN JOB:	
	
		* ISCO 08 - 2 digit
			gen ilo_job1_ocu_isco08_2digits=e2 if (e2!=0 & ilo_lfs==1)
				lab values ilo_job1_ocu_isco08_2digits ISCO_08_cod
				lab var ilo_job1_ocu_isco08_2digits "Occupation (ISCO-08), 2 digit level"
		
		* ISCO 08 - 1 digit
			gen ilo_job1_ocu_isco08=.
				replace ilo_job1_ocu_isco08=1 if inrange(ilo_job1_ocu_isco08_2digits,10,19)
				replace ilo_job1_ocu_isco08=2 if inrange(ilo_job1_ocu_isco08_2digits,20,29)
				replace ilo_job1_ocu_isco08=3 if inrange(ilo_job1_ocu_isco08_2digits,30,39)
				replace ilo_job1_ocu_isco08=4 if inrange(ilo_job1_ocu_isco08_2digits,40,49)
				replace ilo_job1_ocu_isco08=5 if inrange(ilo_job1_ocu_isco08_2digits,50,59)
				replace ilo_job1_ocu_isco08=6 if inrange(ilo_job1_ocu_isco08_2digits,60,69)
				replace ilo_job1_ocu_isco08=7 if inrange(ilo_job1_ocu_isco08_2digits,70,79)
				replace ilo_job1_ocu_isco08=8 if inrange(ilo_job1_ocu_isco08_2digits,80,89)
				replace ilo_job1_ocu_isco08=9 if inrange(ilo_job1_ocu_isco08_2digits,90,99)
				replace ilo_job1_ocu_isco08=10 if inrange(ilo_job1_ocu_isco08_2digits,1,9)
				replace ilo_job1_ocu_isco08=11 if (ilo_job1_ocu_isco08_2digits==0 | (e2==0 & ilo_lfs==1))
					lab def isco08_1dig_lab 1 "1 - Managers" 2 "2 - Professionals" 3 "Technicians and associate professionals" 4 "4 - Clerical support workers" 5 "5 - Service and sales workers" ///
									6 "6 - Skilled agricultural, forestry and fishery workers" 7 "7 - Craft and related trades workers" 8 "8 - Plant and machine operators, and assemblers" ///
									9 "9 - Elementary occupations" 10 "0 - Armed forces occupations" 11 "X - Not elsewhere classified"
					lab val ilo_job1_ocu_isco08 isco08_1dig_lab
					lab var ilo_job1_ocu_isco08 "Occupation (ISCO-08)"		

		* Aggregate:			
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
					lab var ilo_job1_ocu_aggregate "Occupation (Aggregate) - Main job"	

	
	* SECOND JOB:

		* ISCO 08 - 2 digit
			gen ilo_job2_ocu_isco08_2digits=f3 if (f3!=0 & ilo_lfs==1)
				lab values ilo_job2_ocu_isco08_2digits ISCO_08_cod
				lab var ilo_job2_ocu_isco08_2digits "Occupation (ISCO-08), 2 digit level - Second job"
		
		* ISCO 08 - 1 digit
			gen ilo_job2_ocu_isco08=.
				replace ilo_job2_ocu_isco08=1 if inrange(ilo_job2_ocu_isco08_2digits,10,19)
				replace ilo_job2_ocu_isco08=2 if inrange(ilo_job2_ocu_isco08_2digits,20,29)
				replace ilo_job2_ocu_isco08=3 if inrange(ilo_job2_ocu_isco08_2digits,30,39)
				replace ilo_job2_ocu_isco08=4 if inrange(ilo_job2_ocu_isco08_2digits,40,49)
				replace ilo_job2_ocu_isco08=5 if inrange(ilo_job2_ocu_isco08_2digits,50,59)
				replace ilo_job2_ocu_isco08=6 if inrange(ilo_job2_ocu_isco08_2digits,60,69)
				replace ilo_job2_ocu_isco08=7 if inrange(ilo_job2_ocu_isco08_2digits,70,79)
				replace ilo_job2_ocu_isco08=8 if inrange(ilo_job2_ocu_isco08_2digits,80,89)
				replace ilo_job2_ocu_isco08=9 if inrange(ilo_job2_ocu_isco08_2digits,90,99)
				replace ilo_job2_ocu_isco08=10 if inrange(ilo_job2_ocu_isco08_2digits,1,9)
				replace ilo_job2_ocu_isco08=11 if ilo_job2_ocu_isco08_2digits==0
					lab val ilo_job2_ocu_isco08 isco08_1dig_lab
					lab var ilo_job2_ocu_isco08 "Occupation (ISCO-08) - Second job"	

		* Aggregate:			
			gen ilo_job2_ocu_aggregate=.
				replace ilo_job2_ocu_aggregate=1 if inrange(ilo_job2_ocu_isco08,1,3)
				replace ilo_job2_ocu_aggregate=2 if inlist(ilo_job2_ocu_isco08,4,5)
				replace ilo_job2_ocu_aggregate=3 if inlist(ilo_job2_ocu_isco08,6,7)
				replace ilo_job2_ocu_aggregate=4 if ilo_job2_ocu_isco08==8
				replace ilo_job2_ocu_aggregate=5 if ilo_job2_ocu_isco08==9
				replace ilo_job2_ocu_aggregate=6 if ilo_job2_ocu_isco08==10
				replace ilo_job2_ocu_aggregate=7 if ilo_job2_ocu_isco08==11
					lab val ilo_job2_ocu_aggregate ocu_aggr_lab
					lab var ilo_job2_ocu_aggregate "Occupation (Aggregate) - Second job"	
	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_job1_ins_sector')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
	
	/* Other are classified under Private	*/
	
		gen ilo_job1_ins_sector=.
			replace ilo_job1_ins_sector=1 if (inlist(e10,1,2,3) & ilo_lfs==1)	// Public
			replace ilo_job1_ins_sector=2 if (inrange(e10,4,7) & ilo_lfs==1)	// Private
				lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private" 
				lab values ilo_job1_ins_sector ins_sector_lab
				lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities"


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job1_job_time')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			

	/* Threshold of 40 hours per week	*/

			gen ilo_job1_job_time=.
				replace ilo_job1_job_time=1 if (e8h<40 & ilo_lfs==1) 	// Part-time
				replace ilo_job1_job_time=2 if (e8h>39 & ilo_lfs==1)	// Full-time
					lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
					lab val ilo_job1_job_time job_time_lab
					lab var ilo_job1_job_time "Job (Working time arrangement) - Main job"	
			
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job1_job_contract')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
		
			gen ilo_job1_job_contract=e17 if (ilo_lfs==1)
				replace ilo_job1_job_contract=3 if ((e17==. | e17==0) & ilo_lfs==1)
					lab def job_contract_lab 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"
					lab val ilo_job1_job_contract job_contract_lab
					lab var ilo_job1_job_contract "Job (Type of contract)"

		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Formal / Informal Economy ('ilo_job1_ife_prod' 'ilo_job1_ife_nature') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
		
	/* Useful questions:
				* E5 - Size
				* E6 - Status
				* E7 - Location of work place
				* E10 - Institutional Sector
				* E11 - Registration of business
				* E12 - Pension
				* E13 - Paid leave
				* E14 - Medical benefits	*/

	* 1) Unit of production - Formal / Informal Sector
	
		/* Generation of a variable indicating the social security coverage (to be dropped afterwards) */

			gen social_security=.
				replace social_security=1 if e12==1 & e13==1 & e14==1 & ilo_lfs==1
	
			gen ilo_job1_ife_prod=.
				
				replace ilo_job1_ife_prod=2 if (inlist(e10,1,2,3) | inlist(e11,1,3) | (e7==3 & inlist(e5,3,4,5,6)) | social_security==1) & ilo_lfs==1
				
				replace ilo_job1_ife_prod=3 if (e10==4 | (inlist(e10,5,6,7) & inlist(e11,2,4,9) & e7==6)) & ilo_lfs==1
				
				replace ilo_job1_ife_prod=1 if (ilo_job1_ife_prod!=2 & ilo_job1_ife_prod!=3 & ilo_lfs==1)

						lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 
						lab val ilo_job1_ife_prod ilo_ife_prod_lab
						lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"


	* 2) Nature of job - Formal / Informal Job
	
			gen ilo_job1_ife_nature=.

				replace ilo_job1_ife_nature=1 if (inlist(ilo_job1_ste_icse93,2,3,4) & ilo_job1_ife_prod!=2) | (ilo_job1_ste_icse93==1 & social_security!=1) | inlist(ilo_job1_ste_icse93,5,6)

				replace ilo_job1_ife_nature=2 if (inlist(ilo_job1_ste_icse93,2,3,4) & ilo_job1_ife_prod==2) | (ilo_job1_ste_icse93==1 & social_security==1)

						lab def ife_nature_lab 1 "1 - Persons with informal main job" 2 "2 - Persons with formal main job"
						lab val ilo_job1_ife_nature ife_nature_lab
						lab var ilo_job1_ife_nature "Informal / Formal Economy (Nature of job) - Main job"
		
			drop social_security
	


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Hours of work ('ilo_job1_how')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
		
* Main job:
		
* 1) Weekly hours ACTUALLY worked
		
			gen ilo_job1_how_actual=e8h if (ilo_lfs==1)
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
		
		
* 2) Weekly hours USUALLY worked - Not available


* Second job:

* 1) Weekly hours ACTUALLY worked:

		gen ilo_job2_how_actual=f8h if (ilo_mjh==2 & ilo_lfs==1)
					lab var ilo_job2_how_actual "Weekly hours actually worked in second job"
					
		
		gen ilo_job2_how_actual_bands=.
			replace ilo_job2_how_actual_bands=1 if ilo_job2_how_actual==0
			replace ilo_job2_how_actual_bands=2 if inrange(ilo_job2_how_actual,1,14)
			replace ilo_job2_how_actual_bands=3 if inrange(ilo_job2_how_actual,15,29)
			replace ilo_job2_how_actual_bands=4 if inrange(ilo_job2_how_actual,30,34)
			replace ilo_job2_how_actual_bands=5 if inrange(ilo_job2_how_actual,35,39)
			replace ilo_job2_how_actual_bands=6 if inrange(ilo_job2_how_actual,40,48)
			replace ilo_job2_how_actual_bands=7 if ilo_job2_how_actual>=49 & ilo_job2_how_actual!=.
				lab val ilo_job2_how_actual_bands how_bands_lab
				lab var ilo_job2_how_actual_bands "Weekly hours actually worked bands in second job"
		

* 2) Weekly hours USUALLY worked - Not available


* All jobs:
		
* 1) Weekly hours ACTUALLY worked:

			gen ilo_joball_how_actual=g1 if (ilo_lfs==1)  
					lab var ilo_joball_how_actual "Weekly hours actually worked in all jobs"

			gen ilo_joball_how_actual_bands=.
				replace ilo_joball_how_actual_bands=1 if ilo_joball_how_actual==0
				replace ilo_joball_how_actual_bands=2 if inrange(ilo_joball_how_actual,1,14)
				replace ilo_joball_how_actual_bands=3 if inrange(ilo_joball_how_actual,15,29)
				replace ilo_joball_how_actual_bands=4 if inrange(ilo_joball_how_actual,30,34)
				replace ilo_joball_how_actual_bands=5 if inrange(ilo_joball_how_actual,35,39)
				replace ilo_joball_how_actual_bands=6 if inrange(ilo_joball_how_actual,40,48)
				replace ilo_joball_how_actual_bands=7 if ilo_joball_how_actual>=49 & ilo_joball_how_actual!=.
					lab val ilo_joball_how_actual_bands how_bands_lab
					lab var ilo_joball_how_actual_bands "Weekly hours actually worked bands in all jobs"


* 2) Weekly hours USUALLY worked - Not available
				


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Monthly labour related income ('ilo_joball_lri')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
	   
			* All jobs
				
				* Employees
					gen ilo_job1_lri_ees=.
						replace ilo_job1_lri_ees=e20d if (e21==1 & ilo_job1_ste_aggregate==1)
						replace ilo_job1_lri_ees=e20d*52/12 if (e21==2 & ilo_job1_ste_aggregate==1)
						replace ilo_job1_lri_ees=e20d*365/12 if (e21==3 & ilo_job1_ste_aggregate==1)
							lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"	
				
				* Self-employed
					gen ilo_job1_lri_slf=.
						replace ilo_job1_lri_slf=e23d if (inlist(ilo_job1_ste_icse93,2,3,4,6))
						lab var ilo_job1_lri_slf "Monthly earnings of self-employed in main job"

						
		
***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_joball_tru')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			

		gen ilo_joball_tru=.
			replace ilo_joball_tru=1 if (g1<40 & g2==1 & g3>0 & ilo_lfs==1)
			lab def tru_lab 1 "Time-related underemployment"
			lab val ilo_joball_tru tru_lab
			lab var ilo_joball_tru "Time-related underemployment"	
		

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupational injury ('ilo_joball_inj')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
		
	
	* 1) Cases of non-fatal occupational injuries (within the last 12 months):
	
		gen ilo_joball_oi_case=. if (ilo_lfs==1)
			replace ilo_joball_oi_case=1 if (j2==1)
			lab var ilo_joball_oi_case "Cases of non-fatal occupational injury"

	
	* 2) Days lost due to cases of occupational injuries (within the last 12 months):

		gen ilo_joball_oi_day=j5 if (j5!=0 & ilo_lfs==1)	
				lab var ilo_joball_oi_day "Days lost due to cases of occupational injury"
		
		

***********************************************************************************************
*			PART 3.3. UNEMPLOYMENT: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Category of unemployment ('ilo_cat_une')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	
	****** No information available in the questionnaire ******

	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_dur_details=.
				replace ilo_dur_details=1 if (h2==1 & ilo_lfs==2)
				replace ilo_dur_details=2 if (h2==2 & ilo_lfs==2)
				replace ilo_dur_details=3 if (h2==3 & ilo_lfs==2)
				replace ilo_dur_details=4 if (h2==4 & ilo_lfs==2)
				replace ilo_dur_details=5 if (h2==5 & ilo_lfs==2)
				replace ilo_dur_details=6 if (h2==6 & ilo_lfs==2)
				replace ilo_dur_details=7 if (h2==0 & ilo_lfs==2)
					lab def ilo_unemp_det 1 "Less than 1 month" 2 "1 month to less than 3 months" 3 "3 months to less than 6 months" ///
											4 "6 months to less than 12 months" 5 "12 months to less than 24 months" 6 "24 months or more" ///
											7 "Not elsewhere classified"
					lab val ilo_dur_details ilo_unemp_det
					lab var ilo_dur_details "Duration of unemployment (Details)"


	gen ilo_dur_aggregate=.
				replace ilo_dur_aggregate=1 if (inlist(ilo_dur_details,1,2,3) & ilo_lfs==2)
				replace ilo_dur_aggregate=2 if (ilo_dur_details==4 & ilo_lfs==2)
				replace ilo_dur_aggregate=3 if (inlist(ilo_dur_details,5,6) & ilo_lfs==2)
				replace ilo_dur_aggregate=4 if (ilo_dur_details==7 & ilo_lfs==2)
					lab def ilo_unemp_aggr 1 "Less than 6 months" 2 "6 months to less than 12 months" 3 "12 months or more" 4 "Not elsewhere classified"
					lab val ilo_dur_aggregate ilo_unemp_aggr
					lab var ilo_dur_aggregate "Duration of unemployment (Aggregate)"
	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
	****** No information available in the questionnaire ******



* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

	****** No information available in the questionnaire ******

	
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			General social protection ('ilo_gsp_unschemes')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
	****** No information available in the questionnaire ******

	
	
***********************************************************************************************
*			PART 3.4. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
	
	
	gen ilo_olf_dlma=.
		* replace ilo_olf_dlma = 1 if 							 				//Seeking, not available
		replace ilo_olf_dlma = 2 if (h3==2 & h1==1 & ilo_lfs==3)				//Not seeking, available
		* replace ilo_olf_dlma = 3 if 											//Not seeking, not available, willing
		* replace ilo_olf_dlma = 4 if 											//Not seeking, not available, not willing
		replace ilo_olf_dlma = 5 if	(ilo_olf_dlma==. & ilo_lfs==3)				// Not classified 
	
			lab def dlma_lab 1 "1 - Seeking, not available (Unavailable jobseekers)" 2 "2 - Not seeking, available (Available potential jobseekers)" ///
							 3 "3 - Not seeking, not available, willing (Willing non-jobseekers)" 4 "4 - Not seeking, not available, not willing" 5 "X - Not elsewhere classified"
			lab val ilo_olf_dlma dlma_lab 
			lab var ilo_olf_dlma "Labour market attachment (Degree of)"


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reason for not seeking job ('ilo_olf_reason')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

	gen ilo_olf_reason=.
		replace ilo_olf_reason=1 if	(inlist(h5,1,2,3,4,5,7) & ilo_lfs==3)					//Labour market
		replace ilo_olf_reason=2 if	(inlist(h6,1,2,3,4,5) & (h5==0 | h5==9) & ilo_lfs==3)	//Personal/Family-related
		replace ilo_olf_reason=3 if (h5==8 & ilo_lfs==3)									//Does not need/want to work
		replace ilo_olf_reason=4 if (h6==6 & ilo_lfs==3)									//Not elsewhere classified
		replace ilo_olf_reason=4 if (ilo_olf_reason==. & ilo_lfs==3)							//Not elsewhere classified
			lab def reasons_lab 1 "1 - Labour market" 2 "2 - Personal / Family-related" ///
							   3 "3 - Does not need/want to work" 4 "4 - Not elsewhere classified"
			lab val ilo_olf_reason reasons_lab 
			lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"
			

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seeker ('ilo_dis')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

	gen ilo_dis=1 if (ilo_lfs==3 & h1==1 & ilo_olf_reason==1)
			lab def dis_lab 1 "Discouraged job-seekers"
			lab val ilo_dis dis_lab
			lab var ilo_dis "Discouraged job-seekers"
			
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training ('ilo_neet')
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


* 1 - Full dataset with original variables and ILO ones
	
	cd "$outpath"

        compress
		saveold LBR_LFS_2010_FULL, version(12) replace


* 2 - Dataset with only 'ILO' variables
	
		keep ilo*
		saveold LBR_LFS_2010_ILO, version(12) replace