* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Senegal 2015
* DATASET USED: Senegal ENES 2015
* NOTES: 
* Authors: DPAU
* Who last updated the file: DPAU
* Starting Date: 11 October 2017
* Last updated: 11 October 2017
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
global country "SEN"
global source "ENES"
global time "2015"
global inputFile "SEN_ENES_2015"
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
*			Key identifier ('ilo_key')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_key=_n
		lab var ilo_key "Key unique identifier per individual"		
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time period ('ilo_time')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	* Year 
	gen ilo_time=1
		lab def lab_time 1 "$time"
		lab val ilo_time lab_time
		lab var ilo_time "Time (Gregorian Calendar)"		

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sample Weight ('ilo_wgt')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_wgt=poids_cor1
			lab var ilo_wgt "Sample weight"	
	keep if ilo_wgt!=.

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
		replace ilo_geo=1 if ba1==1
		replace ilo_geo=2 if ba1==2
			lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural"
			lab val ilo_geo ilo_geo_lab
			lab var ilo_geo "Geographical coverage"	
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------


	gen ilo_sex=.
	    replace ilo_sex=1 if b3==1
		replace ilo_sex=2 if b3==2 
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
*			Education ('ilo_edu')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - ISCED 11 mapping: based on the UNESCO mapping available on
*			                   http://uis.unesco.org/en/isced-mappings

/*	gen ilo_edu_isced11=.
		replace ilo_edu_isced11=1 if q_110==1                                   // No schooling
		replace ilo_edu_isced11=2 if q_110==2                                   // Early childhood education
		replace ilo_edu_isced11=3 if q_110==3                                   // Primary education 
		replace ilo_edu_isced11=4 if inlist(q_110,4,5)                          // Lower secondary education
		replace ilo_edu_isced11=5 if q_110==6                                   // Upper secondary education
		replace ilo_edu_isced11=6 if q_110==7                                   // Post-secodary non-tertiary education
		*replace ilo_edu_isced11=7 if                                           // Short-cycle tertiary education
		replace ilo_edu_isced11=8 if inlist(q_110,8,9)                          // Bachelor's or equivalent level
		replace ilo_edu_isced11=9 if q_110==10                                  // Master's or equivalent level
		replace ilo_edu_isced11=10 if q_110==11                                 // Doctoral or equivalent level
		replace ilo_edu_isced11=11 if ilo_edu_isced11==.                        // Not elsewhere classified 
			label def isced_11_lab 1 "X - No schooling" 2 "0 - Early childhood education" 3 "1 - Primary education" 4 "2 - Lower secondary education" 5 "3 - Upper secondary education" ///
								6 "4 - Post-secondary non-tertiary education" 7 "5 - Short-cycle tertiary education" 8 "6 - Bachelor's or equivalent level" 9 "7 - Master's or equivalent level" ///
								10 "8 - Doctoral or equivalent level" 11 "9 - Not elsewhere classified"
			label val ilo_edu_isced11 isced_11_lab
			lab var ilo_edu_isced11 "Education (ISCED 11)"

* Aggregate
			
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
*			Education attendance ('ilo_edu_attendance')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_edu_attendance=.
			replace ilo_edu_attendance=1 if b29==1                     	// Yes
			replace ilo_edu_attendance=2 if b29==2	                   	// No
			replace ilo_edu_attendance=3 if ilo_edu_attendance==.     	// Not elsewhere classified
				    lab def edu_attendance_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
				    lab val ilo_edu_attendance edu_attendance_lab
				    lab var ilo_edu_attendance "Education (Attendance)"
					
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Disability status ('ilo_dsb')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

* Comment: Not available


		
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
		replace ilo_wap=1 if ilo_age>=15 & ilo_age!=.
			label def ilo_wap_lab 1 "Working age population"
			label val ilo_wap ilo_wap_lab
			label var ilo_wap "Working age population"
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Labour Force Status ('ilo_lfs')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

   gen ilo_lfs=.
	   replace ilo_lfs=1 if (c1c==1 | c2c==1 | c3c==1 | c4c==1 | c5c==1) & ilo_wap==1											// Employed or temporary absent
	   replace ilo_lfs=1 if (c6_1==1 | c6_2==1 | c6_3==1 | c6_4==1 | c6_5==1 | c6_6==1 | c6_7==1 | c6_8==1) & ilo_wap==1 		// Other Activities
	   replace ilo_lfs=1 if (c7==1 	& ilo_wap==1)																				// Temporary absent
	   replace ilo_lfs=2 if (ilo_lfs!=1 & g1==1 & g7==1 & ilo_wap==1)															// Unemployed
       replace ilo_lfs=3 if !inlist(ilo_lfs,1,2) & ilo_wap==1                   												// Outside the labour market
		       label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside the Labour Force"
			   label value ilo_lfs label_ilo_lfs
			   label var ilo_lfs "Labour Force Status"
			   
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
/*
    gen ilo_mjh=.
	    replace ilo_mjh=2 if q201==1 & ilo_lfs==1                          
		replace ilo_mjh=1 if q201==2 & ilo_lfs==1                 
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
*			Economic activity ('ilo_job1_eco_')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - The original variable was coded at the 5-digit-level, based on the International 
*            Classification of Economic Activities ISIC Rev 3.1. 
*          - Here we use the the re-coded variable "isic" at 2-digit-level 

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
*			Occupation ('ilo_job1_ocu_')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment:

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
*	Institutional sector of economic activities ('ilo_job1_ins_sector')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment: Public includes: government, public administration and public sector enterprise

    * MAIN JOB
	gen ilo_job1_ins_sector=.
		replace ilo_job1_ins_sector=1 if inlist(q_212,1,2) & ilo_lfs==1         // Public
		replace ilo_job1_ins_sector=2 if ilo_job1_ins_sector==. & ilo_lfs==1	// Private
    			lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
			    lab values ilo_job1_ins_sector ins_sector_lab
			    lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities in main job"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Hours of work ('ilo_how')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment: 
		
	* MAIN JOB:
			
	* 1) Weekly hours ACTUALLY worked:
	     gen ilo_job1_how_actual=q_202_1 if ilo_lfs==1
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
			 replace ilo_job1_how_actual_bands=. if ilo_lfs!=1
			    	 lab def how_bands_lab 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"
					 lab val ilo_job1_how_actual_bands how_bands_lab
					 lab var ilo_job1_how_actual_bands "Weekly hours actually worked bands in main job"
		
	* 2) Weekly hours USUALLY worked:
		 gen ilo_job1_how_usual=q_306 if ilo_lfs==1
			 lab var ilo_job1_how_usual "Weekly hours usually worked in main job"
					 
		 gen ilo_job1_how_usual_bands=.
		 	 replace ilo_job1_how_usual_bands=1 if ilo_job1_how_usual==0
			 replace ilo_job1_how_usual_bands=2 if inrange(ilo_job1_how_usual,1,14)
			 replace ilo_job1_how_usual_bands=3 if inrange(ilo_job1_how_usual,15,29)
			 replace ilo_job1_how_usual_bands=4 if inrange(ilo_job1_how_usual,30,34)
			 replace ilo_job1_how_usual_bands=5 if inrange(ilo_job1_how_usual,35,39)
			 replace ilo_job1_how_usual_bands=6 if inrange(ilo_job1_how_usual,40,48)
			 replace ilo_job1_how_usual_bands=7 if ilo_job1_how_usual>=49 & ilo_job1_how_usual!=.
			 replace ilo_job1_how_usual_bands=8 if ilo_job1_how_usual==. & ilo_lfs==1
			 replace ilo_job1_how_usual_bands=. if ilo_lfs!=1
			    	 lab def how_usu_bands_lab 1 "No hours usually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"
					 lab val ilo_job1_how_usual_bands how_usu_bands_lab
					 lab var ilo_job1_how_usual_bands "Weekly hours usually worked bands in main job"
		
		
	* SECOND JOB
				
	* 1) Weekly hours ACTUALLY worked:
         gen ilo_job2_how_actual=q_202_2 if ilo_mjh==2
			 lab var ilo_job2_how_actual "Weekly hours actually worked in secondary job"
		
		 gen ilo_job2_how_actual_bands=.
			 replace ilo_job2_how_actual_bands=1 if ilo_job2_how_actual==0
			 replace ilo_job2_how_actual_bands=2 if ilo_job2_how_actual>=1 & ilo_job2_how_actual<=14
			 replace ilo_job2_how_actual_bands=3 if ilo_job2_how_actual>=15 & ilo_job2_how_actual<=29
			 replace ilo_job2_how_actual_bands=4 if ilo_job2_how_actual>=30 & ilo_job2_how_actual<=34
			 replace ilo_job2_how_actual_bands=5 if ilo_job2_how_actual>=35 & ilo_job2_how_actual<=39
			 replace ilo_job2_how_actual_bands=6 if ilo_job2_how_actual>=40 & ilo_job2_how_actual<=48
			 replace ilo_job2_how_actual_bands=7 if ilo_job2_how_actual>=49 & ilo_job2_how_actual!=.
			 replace ilo_job2_how_actual_bands=8 if ilo_job2_how_actual==. & ilo_mjh==2
			 replace ilo_job2_how_actual_bands=. if ilo_mjh!=2
			    	 lab val ilo_job2_how_actual_bands how_bands_lab
					 lab var ilo_job2_how_actual_bands "Weekly hours actually worked bands in secondary job"
		
	* 2) Weekly hours USUALLY worked:
		 gen ilo_job2_how_usual=q_308 if ilo_mjh==2
			 lab var ilo_job2_how_usual "Weekly hours usually worked in secondary job"
					 
		 gen ilo_job2_how_usual_bands=.
		 	 replace ilo_job2_how_usual_bands=1 if ilo_job2_how_usual==0
			 replace ilo_job2_how_usual_bands=2 if inrange(ilo_job2_how_usual,1,14)
			 replace ilo_job2_how_usual_bands=3 if inrange(ilo_job2_how_usual,15,29)
			 replace ilo_job2_how_usual_bands=4 if inrange(ilo_job2_how_usual,30,34)
			 replace ilo_job2_how_usual_bands=5 if inrange(ilo_job2_how_usual,35,39)
			 replace ilo_job2_how_usual_bands=6 if inrange(ilo_job2_how_usual,40,48)
			 replace ilo_job2_how_usual_bands=7 if ilo_job2_how_usual>=49 & ilo_job2_how_usual!=.
			 replace ilo_job2_how_usual_bands=8 if ilo_job2_how_usual==. & ilo_mjh==2
			 replace ilo_job2_how_usual_bands=. if ilo_mjh!=2
			    	 lab val ilo_job2_how_usual_bands how_usu_bands_lab
					 lab var ilo_job2_how_usual_bands "Weekly hours usually worked bands in secondary job" 
		
		
	* ALL JOBS:
		
	* 1) Weekly hours ACTUALLY worked:
		 egen ilo_joball_how_actual=rowtotal(ilo_job1_how_actual ilo_job2_how_actual), m
			  lab var ilo_joball_how_actual "Weekly hours actually worked in all jobs"
						
		 gen ilo_joball_actual_how_bands=.
			 replace ilo_joball_actual_how_bands=1 if ilo_joball_how_actual==0
			 replace ilo_joball_actual_how_bands=2 if ilo_joball_how_actual>=1 & ilo_joball_how_actual<=14
			 replace ilo_joball_actual_how_bands=3 if ilo_joball_how_actual>=15 & ilo_joball_how_actual<=29
			 replace ilo_joball_actual_how_bands=4 if ilo_joball_how_actual>=30 & ilo_joball_how_actual<=34
			 replace ilo_joball_actual_how_bands=5 if ilo_joball_how_actual>=35 & ilo_joball_how_actual<=39
			 replace ilo_joball_actual_how_bands=6 if ilo_joball_how_actual>=40 & ilo_joball_how_actual<=48
			 replace ilo_joball_actual_how_bands=7 if ilo_joball_how_actual>=49 & ilo_joball_how_actual!=.
			 replace ilo_joball_actual_how_bands=8 if ilo_joball_actual_how_bands==. & ilo_lfs==1
			 replace ilo_joball_actual_how_bands=. if ilo_lfs!=1
			 		 lab val ilo_joball_actual_how_bands how_bands_lab
					 lab var ilo_joball_actual_how_bands "Weekly hours actually worked bands in all jobs"
						
						
	* 2) Weekly hours USUALLY worked:
		 egen ilo_joball_how_usual=rowtotal(ilo_job1_how_usual ilo_job2_how_usual), m
			  lab var ilo_joball_how_usual "Weekly hours usually worked in all jobs"
						
		 gen ilo_joball_usual_how_bands=.
			 replace ilo_joball_usual_how_bands=1 if ilo_joball_how_usual==0
			 replace ilo_joball_usual_how_bands=2 if ilo_joball_how_usual>=1 & ilo_joball_how_usual<=14
			 replace ilo_joball_usual_how_bands=3 if ilo_joball_how_usual>=15 & ilo_joball_how_usual<=29
			 replace ilo_joball_usual_how_bands=4 if ilo_joball_how_usual>=30 & ilo_joball_how_usual<=34
			 replace ilo_joball_usual_how_bands=5 if ilo_joball_how_usual>=35 & ilo_joball_how_usual<=39
			 replace ilo_joball_usual_how_bands=6 if ilo_joball_how_usual>=40 & ilo_joball_how_usual<=48
			 replace ilo_joball_usual_how_bands=7 if ilo_joball_how_usual>=49 & ilo_joball_how_usual!=.
			 replace ilo_joball_usual_how_bands=8 if ilo_joball_usual_how_bands==. & ilo_lfs==1
			 replace ilo_joball_usual_how_bands=. if ilo_lfs!=1
			 		 lab val ilo_joball_usual_how_bands how_bands_lab
					 lab var ilo_joball_usual_how_bands "Weekly hours usually worked bands in all jobs"
				
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job1_job_time')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
* Comment: - The question is not asked directly; according to the report on the LFS, the hour-threshold
*            was at 35 hours usually worked per week in all jobs (on the basis of the weighted
*            median of the distribution of hours actually worked of reporting survey units) 
	   
	   gen ilo_job1_job_time=.
    	   replace ilo_job1_job_time=1 if ilo_joball_how_usual<35 & ilo_lfs==1 
		   replace ilo_job1_job_time=2 if ilo_joball_how_usual>=35 & ilo_lfs==1
		   replace ilo_job1_job_time=3 if !inlist(ilo_job1_job_time,1,2) & ilo_lfs==1
			       lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
				   lab val ilo_job1_job_time job_time_lab
				   lab var ilo_job1_job_time "Job (Working time arrangement) - Main job"				
			   
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job1_job_contract')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

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
*			Formal / Informal Economy ('ilo_job1_ife_prod' 'ilo_job1_ife_nature')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			

/* Useful questions:
			- Institutional sector: q_212
			- Destination of production: q_303: only asked to employers and own-account workers
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
			    replace ilo_job1_ife_prod=3 if ilo_lfs==1 & ((q_303==4) | (ilo_job1_eco_isic3_2digits==95) | ///
				                               (ilo_job1_ocu_isco88_2digits==62))
				replace ilo_job1_ife_prod=2 if ilo_lfs==1 & ((inlist(q_212,1,2,8,9,10)) | ///
				                               (q_303!=4 & inlist(q_212,3,4,5,6,7,99,.) & q_208==1) | ///
											   (q_303!=4 & inlist(q_212,3,4,5,6,7,99,.) & q_208!=1 & q_209==1) | ///
											   (q_303!=4 & inlist(q_212,3,4,5,6,7,99,.) & q_208!=1 & q_209==. & ilo_job1_ste_aggregate==1 & q_216==1) | ///
											   (q_303!=4 & inlist(q_212,3,4,5,6,7,99,.) & q_208!=1 & q_209==. & ilo_job1_ste_aggregate==1 & q_216!=1 & inlist(q_219,1,2,3,4) & inlist(q_207,2,3,4,5,6)) | ///
											   (q_303!=4 & inlist(q_212,3,4,5,6,7,99,.) & q_208!=1 & q_209==. & ilo_job1_ste_aggregate!=1 & inlist(q_219,1,2,3,4) & inlist(q_207,2,3,4,5,6)))
			    replace ilo_job1_ife_prod=1 if ilo_lfs==1 & (!inlist(ilo_job1_ife_prod,3,2)) & ///
				                               ((q_303!=4 & inlist(q_212,3,4,5,6,7,99,.) & q_208!=1 & inlist(q_209,2,3)) | ///
				                               (q_303!=4 & inlist(q_212,3,4,5,6,7,99,.) & q_208!=1 & q_209==. & ilo_job1_ste_aggregate==1 & q_216!=1 & !inlist(q_219,1,2,3,4)) | ///
											   (q_303!=4 & inlist(q_212,3,4,5,6,7,99,.) & q_208!=1 & q_209==. & ilo_job1_ste_aggregate==1 & q_216!=1 & inlist(q_219,1,2,3,4) & !inlist(q_207,2,3,4,5,6)) | ///
											   (q_303!=4 & inlist(q_212,3,4,5,6,7,99,.) & q_208!=1 & q_209==. & ilo_job1_ste_aggregate!=1 & !inlist(q_219,1,2,3,4)) | ///
											   (q_303!=4 & inlist(q_212,3,4,5,6,7,99,.) & q_208!=1 & q_209==. & ilo_job1_ste_aggregate!=1 & inlist(q_219,1,2,3,4) & !inlist(q_207,2,3,4,5,6)))
				        lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 
						lab val ilo_job1_ife_prod ilo_ife_prod_lab
						lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"
						
						
	* 2) NATURE OF JOB: FORMAL/INFORMAL EMPLOYMENT
	
	      gen ilo_job1_ife_nature=.
		      replace ilo_job1_ife_nature=2 if ilo_lfs==1 & ((inlist(ilo_job1_ste_icse93,1,6) & q_216==1) | ///
			                                   (inlist(ilo_job1_ste_icse93,1,6) & inlist(q_216,3,9,.) & q_218==1 & q_217==1) | ///
											   (inlist(ilo_job1_ste_icse93,2,4) & ilo_job1_ife_prod==2) | ///
											   (q_303!=4 & ilo_job1_ste_icse93==3 & ilo_job1_ife_prod==2))
			  replace ilo_job1_ife_nature=1 if ilo_lfs==1 & (ilo_job1_ife_nature!=2)
			          lab def ife_nature_lab 1 "1 - Persons with informal main job" 2 "2 - Persons with formal main job"
			          lab val ilo_job1_ife_nature ife_nature_lab
			          lab var ilo_job1_ife_nature "Informal / Formal Economy (Nature of job)"
					  
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Monthly labour related income ('ilo_joball_lri')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - For employees: The total amount of earnings in cash or in kind received is computed 
*            merging the speficic amount for those who answered the question (and its periodicity), 
*            and the mid-point of the interval for those who did not want to answer the exact 
*            amount but answered following the table of intervals.
*          - For self-employed: same as for employees but answering to the question on net
*            earnings from main job.

	* MAIN JOB
	
	* Employees:
	* Total amount of monthly earnings following the table of intervals (mid-point).

	  gen q_305_mid = .
	      replace q_305_mid = 10000 if q_305==1                                 // Less than 20,000 Rials
          replace q_305_mid = 35000 if q_305==2                                 // 20,000 to less than 50,000 Rials
		  replace q_305_mid = 75000 if q_305==3                                 // 50,000 to less than 100,000 Rials
		  replace q_305_mid = 125000 if q_305==4                                // 100,000 to less than 150,000 Rials
		  replace q_305_mid = 150000 if q_305==5                                // 150,000 Rials or more
		  
	* Periodicity 
	
	  replace q_302 = 1 if q_305_mid!=.                                         // Period = month for those answering by intervals

	* Final amount
            
	  gen q_301_final = .
	      replace q_301_final = q_301 if q_301!=.
		  replace q_301_final = q_305_mid if q_301_final==.
			   			   
    * Monthly labour related income for employees:
    * Note: if the periodicty is not specified (4 or missing) then the figure is not included. 

      gen ilo_job1_lri_ees=.
          replace ilo_job1_lri_ees = q_301_final if (q_302==1 & ilo_job1_ste_aggregate==1)                          // Month
		  replace ilo_job1_lri_ees = q_301_final*(52/12) if (inlist(q_302,2,10) & ilo_job1_ste_aggregate==1)        // Week
		  replace ilo_job1_lri_ees = q_301_final*(365/12) if (q_302==3 & ilo_job1_ste_aggregate==1)                 // Day
		  replace ilo_job1_lri_ees = q_301_final*(1/2) if (q_302==5 & ilo_job1_ste_aggregate==1)                    // Two months
		  replace ilo_job1_lri_ees = q_301_final*(1/3) if (q_302==6 & ilo_job1_ste_aggregate==1)                    // Three months
		  replace ilo_job1_lri_ees = q_301_final*(2) if (q_302==7 & ilo_job1_ste_aggregate==1)                      // Two weeks
		  replace ilo_job1_lri_ees = q_301_final*(1/12) if (q_302==8 & ilo_job1_ste_aggregate==1)                   // One year
		  replace ilo_job1_lri_ees = q_301_final*((365/12)/2) if (q_302==9 & ilo_job1_ste_aggregate==1)             // Two days ago
		  replace ilo_job1_lri_ees = q_301_final*(1/6) if (q_302==11 & ilo_job1_ste_aggregate==1)                   // Six months
		          lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"
				  
	* Self-employed:
	* Total amount of monthly earnings following the tables of intervals (mid-point).

    * Final amount
            
	  gen q_304_final = .
	      replace q_304_final = q_304 if q_304!=.
		  replace q_304_final = q_305_mid if q_304_final==.
			   			   
    * Monthly labour related income for self-employed:
    * Note: if the periodicty is not specified (4 or missing) then the figure is not included. 

      gen ilo_job1_lri_slf=.
          replace ilo_job1_lri_slf = q_304_final if (q_302==1 & ilo_job1_ste_aggregate==2)                          // Month
		  replace ilo_job1_lri_slf = q_304_final*(52/12) if (inlist(q_302,2,10) & ilo_job1_ste_aggregate==2)        // Week
		  replace ilo_job1_lri_slf = q_304_final*(365/12) if (q_302==3 & ilo_job1_ste_aggregate==2)                 // Day
		  replace ilo_job1_lri_slf = q_304_final*(1/2) if (q_302==5 & ilo_job1_ste_aggregate==2)                    // Two months
		  replace ilo_job1_lri_slf = q_304_final*(1/3) if (q_302==6 & ilo_job1_ste_aggregate==2)                    // Three months
		  replace ilo_job1_lri_slf = q_304_final*(2) if (q_302==7 & ilo_job1_ste_aggregate==2)                      // Two weeks
		  replace ilo_job1_lri_slf = q_304_final*(1/12) if (q_302==8 & ilo_job1_ste_aggregate==2)                   // One year
		  replace ilo_job1_lri_slf = q_304_final*((365/12)/2) if (q_302==9 & ilo_job1_ste_aggregate==2)             // Two days ago
		  replace ilo_job1_lri_slf = q_304_final*(1/6) if (q_302==11 & ilo_job1_ste_aggregate==2)                   // Six months
		          lab var ilo_job1_lri_slf "Monthly earnings of self-employed in main job"
				  
***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_joball_tru')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment: - Threshold is set at 35 hours/week.
*          - Two criteria: want to work additional hours and worked less than a	threshold.

		gen ilo_joball_tru=.
			replace ilo_joball_tru=1 if (q_204==1 & ilo_joball_how_usual<35 & ilo_lfs==1)
			lab def tru_lab 1 "Time-related underemployment"
			lab val ilo_joball_tru tru_lab
			lab var ilo_joball_tru "Time-related underemployment"	
		

*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Cases of non-fatal occupational injury ('ilo_joball_oi_case')
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
* Comment: Not available


*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Days lost due to cases of occupational injury ('ilo_joball_oi_day')
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
* Comment: Not available


***********************************************************************************************
*			PART 3.3. UNEMPLOYMENT: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Category of unemployment ('ilo_cat_une')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Question used: have you worked in the last five years for at least two weeks without
*            interruption?

	gen ilo_cat_une=.
		replace ilo_cat_une=1 if (q_401==1 & ilo_lfs==2)                        // Previously employed
		replace ilo_cat_une=2 if (q_401==2 & ilo_lfs==2)                        // Seeking first job
		replace ilo_cat_une=3 if (ilo_cat_une==. & ilo_lfs==2)
			lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
			lab val ilo_cat_une cat_une_lab
			lab var ilo_cat_une "Category of unemployment"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: 

	gen ilo_dur_details=.
				replace ilo_dur_details=1 if (q_404==1 & ilo_lfs==2)            // Less than 1 month
				replace ilo_dur_details=2 if (q_404==2 & ilo_lfs==2)            // 1 to 3 months
				replace ilo_dur_details=3 if (q_404==3 & ilo_lfs==2)            // 3 to 6 months
				replace ilo_dur_details=4 if (q_404==4 & ilo_lfs==2)            // 6 to 12 months
				replace ilo_dur_details=5 if (q_404==5 & ilo_lfs==2)            // 12 to 24 months
				replace ilo_dur_details=6 if (q_404==6 & ilo_lfs==2)            // 24 months or more
				replace ilo_dur_details=7 if (q_404==. & ilo_lfs==2)            // Not elsewhere classified
				        lab def ilo_unemp_det 1 "Less than 1 month" 2 "1 month to less than 3 months" 3 "3 months to less than 6 months" ///
											  4 "6 months to less than 12 months" 5 "12 months to less than 24 months" 6 "24 months or more" ///
											  7 "Not elsewhere classified"
					    lab val ilo_dur_details ilo_unemp_det
					    lab var ilo_dur_details "Duration of unemployment (Details)"
					
	gen ilo_dur_aggregate=.
		replace ilo_dur_aggregate=1 if (inlist(q_404,1,2,3) & ilo_lfs==2)       // Less than 6 months
		replace ilo_dur_aggregate=2 if (q_404==4 & ilo_lfs==2)                  // 6 to 12 months
		replace ilo_dur_aggregate=3 if (inlist(q_404,5,6) & ilo_lfs==2)         // 12 months or more
		replace ilo_dur_aggregate=4 if (ilo_dur_aggregate==. & ilo_lfs==2)      //Not elsewhere classified
		replace ilo_dur_aggregate=. if ilo_lfs!=2
			lab def ilo_unemp_aggr 1 "Less than 6 months" 2 "6 months to less than 12 months" 3 "12 months or more" 4 "Not elsewhere classified"
			lab val ilo_dur_aggregate ilo_unemp_aggr
			lab var ilo_dur_aggregate "Duration of unemployment (Aggregate)"
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
* Comment: - The original variable was coded at the 5-digit-level, based on the International 
*            Classification of Economic Activities ISIC Rev 3.1. 


    * Two digit-level
	destring q_403, gen(q_403_ft)
	
    gen ilo_preveco_isic3_2digits = int(q_403_ft/1000) if (ilo_lfs==2 & ilo_cat_une==1)
	    lab values ilo_preveco_isic3_2digits isic3_2digits
	    lab var ilo_preveco_isic3_2digits "Previous economic activity (ISIC Rev. 3), 2 digit level"
		
    * One digit-level
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
		replace ilo_preveco_isic3=18 if ilo_preveco_isic3_2digits==98
			lab val ilo_preveco_isic3 isic3
			lab var ilo_preveco_isic3 "Previous economic activity (ISIC Rev. 3)"
		
    * Classification aggregated level
	gen ilo_preveco_aggregate=.
	    replace ilo_preveco_aggregate=1 if ilo_preveco_isic3==1
	    replace ilo_preveco_aggregate=2 if ilo_preveco_isic3==3
	    replace ilo_preveco_aggregate=3 if ilo_preveco_isic3==6
	    replace ilo_preveco_aggregate=4 if inlist(ilo_preveco_isic3,2,4,5)
	    replace ilo_preveco_aggregate=5 if inrange(ilo_preveco_isic3,7,14)
	    replace ilo_preveco_aggregate=6 if inrange(ilo_preveco_isic3,15,21)
	    replace ilo_preveco_aggregate=7 if ilo_preveco_isic3==22
			    lab val ilo_preveco_aggregate eco_aggr_lab
			    lab var ilo_preveco_aggregate "Previous economic activity (Aggregate)" 


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
* Comment: - The original variable was coded at 6-digit-level based on the International Stadard
*            Classification of Occupations ISCO-88

   * MAIN JOB
   * Two digit-level
   destring q_402, gen(q_402_ft)
   
   gen ilo_prevocu_isco88_2digits = int(q_402_ft/10000) if (ilo_lfs==2 & ilo_cat_une==1)
	   lab values ilo_prevocu_isco88_2digits isco88_2digits
	   lab var ilo_prevocu_isco88_2digits "Previous occupation (ISCO-88), 2 digit level"
			
    * One digit-level
	gen ilo_prevocu_isco88=.
	    replace ilo_prevocu_isco88=11 if inlist(ilo_prevocu_isco88_2digits,99,.) & (ilo_lfs==2 & ilo_cat_une==1)                    //Not elsewhere classified
		replace ilo_prevocu_isco88=int(ilo_prevocu_isco88_2digits/10) if (ilo_prevocu_isco88==. & ilo_lfs==2 & ilo_cat_une==1)     //The rest of the occupations
		replace ilo_prevocu_isco88=10 if (ilo_prevocu_isco88_2digits==0 & ilo_lfs==2 & ilo_cat_une==1)                              //Armed forces
				lab val ilo_prevocu_isco88 isco88
				lab var ilo_prevocu_isco88 "Previous occupation (ISCO-88)"
				
	* Aggregate level 
    gen ilo_prevocu_aggregate=.
	    replace ilo_prevocu_aggregate=1 if inrange(ilo_prevocu_isco88,1,3)
	    replace ilo_prevocu_aggregate=2 if inlist(ilo_prevocu_isco88,4,5)
		replace ilo_prevocu_aggregate=3 if inlist(ilo_prevocu_isco88,6,7)
		replace ilo_prevocu_aggregate=4 if ilo_prevocu_isco88==8
	    replace ilo_prevocu_aggregate=5 if ilo_prevocu_isco88==9
	    replace ilo_prevocu_aggregate=6 if ilo_prevocu_isco88==10
	    replace ilo_prevocu_aggregate=7 if ilo_prevocu_isco88==11
		        lab val ilo_prevocu_aggregate ocu_aggr_lab
    	        lab var ilo_prevocu_aggregate "Previous occupation (Aggregate)"	
			
	* Skill level
	gen ilo_prevocu_skill=.
	   	replace ilo_prevocu_skill=1 if ilo_prevocu_isco88==9
	    replace ilo_prevocu_skill=2 if inlist(ilo_prevocu_isco88,4,5,6,7,8)
	    replace ilo_prevocu_skill=3 if inlist(ilo_prevocu_isco88,1,2,3)
	    replace ilo_prevocu_skill=4 if inlist(ilo_prevocu_isco88,10,11)
			    lab val ilo_prevocu_skill ocu_skill_lab
			    lab var ilo_prevocu_skill "Previous occupation (Skill level)"

***********************************************************************************************
*			PART 3.4. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment: - No information available on the willingness to work
*          - Estimates differ from those on the national report due to the classification 
*            of " job seekers". Here, they are defined as those who answered yes to seeking for 
*            a job and answered yes to one of the twelve steps to look for work.

	gen ilo_olf_dlma=.
	   foreach i of num 1/12 {
	     replace ilo_olf_dlma = 1 if (q_116==1 & q_117_`i'==1 & q_119==2) & ilo_lfs==3 // Seeking, not available
	   } 
       replace ilo_olf_dlma = 2 if (q_116==2 & q_119==1) & ilo_lfs==3                  // Not seeking, available
	   replace ilo_olf_dlma = 2 if (q_116==1 & q_117_1==2 & q_117_2==2 & q_117_3==2 & q_117_4==2 & q_117_5==2 & q_117_6==2 & q_117_7==2 & ///
	                              q_117_8==2 & q_117_9==2 & q_117_10==2 & q_117_11==2 & q_117_12==2 & q_119==1) & ilo_lfs==3
       replace ilo_olf_dlma = 5 if	(ilo_olf_dlma==. & ilo_lfs==3)				    // Not classified 
	 		lab def dlma_lab 1 "1 - Seeking, not available (Unavailable jobseekers)" 2 "2 - Not seeking, available (Available potential jobseekers)" ///
							 3 "3 - Not seeking, not available, willing (Willing non-jobseekers)" 4 "4 - Not seeking, not available, not willing" 5 "X - Not elsewhere classified"
			lab val ilo_olf_dlma dlma_lab 
			lab var ilo_olf_dlma "Labour market attachment (Degree of)"
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reason for not seeking job ('ilo_olf_reason')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment: 

	gen ilo_olf_reason=.
		replace ilo_olf_reason=1 if	(inlist(q_118,2,3,4,6,7) & ilo_lfs==3)		// Labour market
		replace ilo_olf_reason=2 if (q_118==5 & ilo_lfs==3)                     // Other labour market reasons
		replace ilo_olf_reason=3 if	(inlist(q_118,8,10,11,12) & ilo_lfs==3)     // Personal/Family-related
		replace ilo_olf_reason=4 if (q_118==13 & ilo_lfs==3)					// Does not need/want to work
		replace ilo_olf_reason=5 if (ilo_olf_reason==. & ilo_lfs==3)			//Not elsewhere classified
			    lab def reasons_lab 1 "1 - Labour market" 2 "2 - Other labour market reasons" 3 "3 - Personal / Family-related" ///
				    			    4 "4 - Does not need/want to work" 5 "5 - Not elsewhere classified"
			lab val ilo_olf_reason reasons_lab 
			lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"
			

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seeker ('ilo_dis')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment: 

	gen ilo_dis=1 if (ilo_lfs==3 & q_119==1 & ilo_olf_reason==1)
			lab def dis_lab 1 "Discouraged job-seekers"
			lab val ilo_dis dis_lab
			lab var ilo_dis "Discouraged job-seekers"
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training ('ilo_neet')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: 

	gen ilo_neet=1 if (ilo_age_aggregate==2 & ilo_lfs!=1 & ilo_edu_attendance==2)
			lab def neet_lab 1 "Youth not in education, employment or training"
			lab val ilo_neet neet_lab
			lab var ilo_neet "Youth not in education, employment or training"

*/			

***********************************************************************************************
***********************************************************************************************

*			3. SAVE ILO-VARIABLES IN A NEW DATASET

***********************************************************************************************
***********************************************************************************************

* -------------------------------------------------------------
* 	Prepare final datasets
* -------------------------------------------------------------

cd "$outpath"

		drop ilo_age 

		compress 
		
	   /*Save dataset including original and ilo variables*/
	
		save ${country}_${source}_${time}_FULL,  replace		
	
	  /* Save file only containing ilo_* variables*/
	
		keep ilo*

		save ${country}_${source}_${time}_ILO, replace
			
				    
		  

