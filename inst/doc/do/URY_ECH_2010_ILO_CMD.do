* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Uruguay, 2010
* DATASET USED: Uruguay LFS 2010
* NOTES: 
* Files created: Standard variables on LFS Uruguay 2010
* Authors: Mabelin Villarreal Fuentes
* Who last updated the file: Mabelin Villarreal Fuentes
* Starting Date: 21 July 2017
* Last updated: 21 July 2017
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
global country "URY"
global source "ECH"
global time "2010"
global inputFile "Personas_2010_TERCEROS"
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
* Comment: DB contains monthly, quarterly and annual weights.

  gen to_drop = "$time"
  gen to_drop_2 = substr(to_drop,5,1)
  
  *-- quarter variable
  gen quarter=.
      replace quarter = 1 if inrange(mes,1,3)
	  replace quarter = 2 if inrange(mes,4,6)
	  replace quarter = 3 if inrange(mes,7,9)
	  replace quarter = 4 if inrange(mes,10,12)
  
  if to_drop_2 == "M"{
    gen to_drop_3 = substr(to_drop,6,2)
	destring to_drop_3, replace
	keep if mes == to_drop_3
	gen ilo_wgt = pesomen
  } 
  else{
    if to_drop_2 == "Q"{
      gen to_drop_3 = substr(to_drop,6,2)
	  destring to_drop_3, replace
	  keep if quarter == to_drop_3
	  gen ilo_wgt = pesotri
    }
	else{
	  gen ilo_wgt = pesoano
	}
  }
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
* Comment: - Urban includes Montevideo, urban regions with 5000 inhabitants and urban regions
*            with less than 5000 inhabitants. 

	gen ilo_geo=.
	    replace ilo_geo=1 if inlist(region_4,1,2,3)
		replace ilo_geo=2 if region_4==4
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
	    replace ilo_sex=1 if e26==1
		replace ilo_sex=2 if e26==2
		lab def ilo_sex_lab 1 "1 - Male" 2 "2 - Female"
		lab var ilo_sex "Sex"
		lab val ilo_sex ilo_sex_lab

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment:

	gen ilo_age=e27
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
* Comment: - ISCED 97 mapping: http://uis.unesco.org/en/isced-mappings
*          - The highest level finished is considered. All educational levels are asked using 
*            different questions and therefore all those variables that have information on the 
*            finalization are used.

   
    * Attending
    gen asis_edu_0=1 if inlist(e51_1,1,2,3)
	gen asis_edu_1=1 if inlist(e51_2,1,2,3,4,5,6) | inlist(e51_3,1,2,3,4)
	gen asis_edu_2=1 if inlist(e51_4,1,2,3)
	gen asis_edu_3=1 if inlist(e51_5,1,2,3)
	gen asis_edu_4=1 if inlist(e51_7,1,2,3,4,5,6)
	gen asis_edu_5=1 if inlist(e51_8,1,2,3,4) | inlist(e51_9,1,2,3,4,5,6,7,8) | inlist(e51_10,1,2,3,4,5,6)
	gen asis_edu_6=1 if inlist(e51_11,1,2,3,4,5,6)
	
	* Finished the highest level attended
	gen high_edu_6=1 if (asis_edu_6==1 & e53==1)
	gen high_edu_5=1 if high_edu_6==. & ((asis_edu_5==1 & e53==1) | (asis_edu_6==1 & e53!=1))
	gen high_edu_4=1 if high_edu_6==. & high_edu_5==. & ((asis_edu_4==1 & e53==1) | (asis_edu_5==1 & e53!=1) | (asis_edu_6==1 & e53!=1))
	gen high_edu_3=1 if high_edu_6==. & high_edu_5==. & high_edu_4==. & ((asis_edu_3==1 & e53==1) | (asis_edu_4==1 & e53!=1) | (asis_edu_5==1 & e53!=1) | (asis_edu_6==1 & e53!=1))
	gen high_edu_2=1 if high_edu_6==. & high_edu_5==. & high_edu_4==. & high_edu_3==. & ((asis_edu_2==1 & e53==1) | (asis_edu_3==1 & e53!=1) | (asis_edu_4==1 & e53!=1) | (asis_edu_5==1 & e53!=1) | (asis_edu_6==1 & e53!=1))
	gen high_edu_1=1 if high_edu_6==. & high_edu_5==. & high_edu_4==. & high_edu_3==. & high_edu_2==. & ((asis_edu_1==1 & e53==1) | (asis_edu_2==1 & e53!=1) | (asis_edu_3==1 & e53!=1) | (asis_edu_4==1 & e53!=1) | (asis_edu_5==1 & e53!=1) | (asis_edu_6==1 & e53!=1))
	gen high_edu_0=1 if high_edu_6==. & high_edu_5==. & high_edu_4==. & high_edu_3==. & high_edu_2==. & high_edu_1==. & ((asis_edu_0==1 & e53==1) | (asis_edu_1==1 & e53!=1) | (asis_edu_2==1 & e53!=1) | (asis_edu_3==1 & e53!=1) | (asis_edu_4==1 & e53!=1) | (asis_edu_5==1 & e53!=1) | (asis_edu_6==1 & e53!=1))
    gen high_edu_x=1 if high_edu_6==. & high_edu_5==. & high_edu_4==. & high_edu_3==. & high_edu_2==. & high_edu_1==. & high_edu_0==.
	
	* Final mapping
	gen ilo_edu_isced97=.
	    replace ilo_edu_isced97=1 if high_edu_x==1                              // No schooling
	    replace ilo_edu_isced97=2 if high_edu_0==1                              // Pre-primary education
		replace ilo_edu_isced97=3 if high_edu_1==1                              // Primary education or first stage of basic education
		replace ilo_edu_isced97=4 if high_edu_2==1                              // Lower secondary or second stage of basic education
		replace ilo_edu_isced97=5 if high_edu_3==1                              // Upper secondary education
		replace ilo_edu_isced97=6 if high_edu_4==1                              // Post-secondary non-tertiary education
		replace ilo_edu_isced97=7 if high_edu_5==1                              // First stage of tertiary education (not leading directly to an advanced research qualification)
		replace ilo_edu_isced97=8 if high_edu_6==1                              // Second stage of tertiary education (leading to an advanced research qualification)
		replace ilo_edu_isced97=9 if ilo_edu_isced97==.                         // Level not stated
				label def isced_97_lab 1 "X - No schooling" 2 "0 - Pre-primary education" 3 "1 - Primary education or first stage of basic education" 4 "2 - Lower secondary education or second stage of basic education" ///
							           5 "3 - Upper secondary education" 6 "4 - Post-secondary non-tertiary education" 7 "5 - First stage of tertiary education (not leading directly to an advanced research qualification)" ///
							           8 "6 - Second stage of tertiary education (leading to an advanced research qualification)" 9 "UNK - Level not stated"
			    label val ilo_edu_isced97 isced_97_lab
			    lab var ilo_edu_isced97 "Education (ISCED 97)"

	*Aggregate level	
	gen ilo_edu_aggregate=.
		replace ilo_edu_aggregate=1 if inlist(ilo_edu_isced97,1,2)
		replace ilo_edu_aggregate=2 if inlist(ilo_edu_isced97,3,4)
		replace ilo_edu_aggregate=3 if inlist(ilo_edu_isced97,5,6)
		replace ilo_edu_aggregate=4 if inlist(ilo_edu_isced97,7,8)
		replace ilo_edu_aggregate=5 if ilo_edu_isced97==9
			label def edu_aggr_lab 1 "1 - Less than basic" 2 "2 - Basic" 3 "3 - Intermediate" 4 "4 - Advanced" 5 "5 - Level not stated"
			label val ilo_edu_aggregate edu_aggr_lab
			label var ilo_edu_aggregate "Education (Aggregate level)"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education attendance ('ilo_edu_attendance')  	[done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment:

	gen ilo_edu_attendance=.
	    replace ilo_edu_attendance=1 if e49==1		                            // Attending
        replace ilo_edu_attendance=2 if e49==2                                  // Not attending
			label def edu_att_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified" 
			label val ilo_edu_attendance edu_att_lab
			label var ilo_edu_attendance "Education (Attendance)"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Disability status ('ilo_dsb') 	[done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment: Not asked

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
* Comment:  - Employment differs from national estimates due to the age coverage (the national
*             statistical office includes 14+).
*           - Unemployment includes those who were not in employment, available and seeking during
*             the past week or during the past four weeks; it also includes available future
*             starters.
		
	gen ilo_lfs=.
		replace ilo_lfs=1 if (f66==1 | f67==1 | f68==1) & ilo_wap==1                        // Employed
		replace ilo_lfs=2 if (ilo_lfs!=1 & f106==1 & f107==1) & ilo_wap==1                  // Unemployed: available and seeking (last week)
		replace ilo_lfs=2 if (ilo_lfs!=1 & f106==1 & f109==1) & ilo_wap==1                  // Unemployed: available and seeking (last four weeks)
		replace ilo_lfs=2 if (ilo_lfs!=1 & f106==1 & inlist(f108,2,3)) & ilo_wap==1         // Unemployed: available future starters
		replace ilo_lfs=3 if !inlist(ilo_lfs,1,2)& ilo_wap==1                               // Outside the labour force
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
		replace ilo_mjh=1 if f70==1 & ilo_lfs==1
		replace ilo_mjh=2 if f70>=2 & ilo_lfs==1
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
* Comment: - Social programmes' workers are classified as employees (main and second job). 
	
	* MAIN JOB:
	
		* Detailed categories:
			gen ilo_job1_ste_icse93=.
				replace ilo_job1_ste_icse93=1 if inlist(f73,1,2,8) & ilo_lfs==1	     // Employees
				replace ilo_job1_ste_icse93=2 if f73==4 & ilo_lfs==1			     // Employers
				replace ilo_job1_ste_icse93=3 if inlist(f73,5,6) & ilo_lfs==1		 // Own-account workers
				replace ilo_job1_ste_icse93=4 if f73==3 & ilo_lfs==1		         // Members of producers' cooperatives
				replace ilo_job1_ste_icse93=5 if f73==7 & ilo_lfs==1		         // Contributing family workers
				replace ilo_job1_ste_icse93=6 if f73==. & ilo_lfs==1	             // Not classifiable
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
	
		* Detailed categories:
			gen ilo_job2_ste_icse93=.
				replace ilo_job2_ste_icse93=1 if inlist(f92,1,2,8)	& ilo_mjh==2      //Employees
				replace ilo_job2_ste_icse93=2 if f92==4 & ilo_mjh==2			      // Employers
				replace ilo_job2_ste_icse93=3 if inlist(f92,5,6) & ilo_mjh==2		  // Own-account workers
				replace ilo_job2_ste_icse93=4 if f92==3			                      // Producer cooperatives
				replace ilo_job2_ste_icse93=5 if f92==7 & ilo_mjh==2		          // Contributing family workers
				replace ilo_job2_ste_icse93=6 if f92==. & ilo_mjh==2	              // Not classifiable
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
* Comment: - National classification is based on ISIC Rev.3 (4 digit-level available).
		
   append using `labels', gen(lab)
   *use value label from this variable, afterwards drop everything related to this append
			
			
  * MAIN JOB:
  * ISIC Rev. 3 - 2 digit-level
  destring f72_2, replace 
  
  gen ilo_job1_eco_isic3_2digits = int(f72_2/100) if ilo_lfs==1
	  lab values ilo_job1_eco_isic3_2digits isic3_2digits
	  lab var ilo_job1_eco_isic3_2digits "Economic activity (ISIC Rev. 3), 2 digit level - main job"
							
    * ISIC Rev. 3
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
		
  * SECOND JOB:
  * ISIC Rev. 3 - 2 digit-level
  destring f91_2, replace 
  
  gen ilo_job2_eco_isic3_2digits = int(f91_2/100) if ilo_mjh==2
	  lab values ilo_job2_eco_isic3_2digits isic3_2digits
	  lab var ilo_job2_eco_isic3_2digits "Economic activity (ISIC Rev. 3), 2 digit level - main job"
							
    * ISIC Rev. 3
    gen ilo_job2_eco_isic3=.
		replace ilo_job2_eco_isic3=1 if inrange(ilo_job2_eco_isic3_2digits,1,2)
		replace ilo_job2_eco_isic3=2 if ilo_job2_eco_isic3_2digits==5
		replace ilo_job2_eco_isic3=3 if inrange(ilo_job2_eco_isic3_2digits,10,14)
		replace ilo_job2_eco_isic3=4 if inrange(ilo_job2_eco_isic3_2digits,15,37)
		replace ilo_job2_eco_isic3=5 if inrange(ilo_job2_eco_isic3_2digits,40,41)
		replace ilo_job2_eco_isic3=6 if ilo_job2_eco_isic3_2digits==45
		replace ilo_job2_eco_isic3=7 if inrange(ilo_job2_eco_isic3_2digits,50,52)
		replace ilo_job2_eco_isic3=8 if ilo_job2_eco_isic3_2digits==55
		replace ilo_job2_eco_isic3=9 if inrange(ilo_job2_eco_isic3_2digits,60,64)
		replace ilo_job2_eco_isic3=10 if inrange(ilo_job2_eco_isic3_2digits,65,67)
		replace ilo_job2_eco_isic3=11 if inrange(ilo_job2_eco_isic3_2digits,70,74)
		replace ilo_job2_eco_isic3=12 if ilo_job2_eco_isic3_2digits==75
		replace ilo_job2_eco_isic3=13 if ilo_job2_eco_isic3_2digits==80
		replace ilo_job2_eco_isic3=14 if ilo_job2_eco_isic3_2digits==85
		replace ilo_job2_eco_isic3=15 if inrange(ilo_job2_eco_isic3_2digits,90,93)
		replace ilo_job2_eco_isic3=16 if ilo_job2_eco_isic3_2digits==95
		replace ilo_job2_eco_isic3=17 if ilo_job2_eco_isic3_2digits==99
		replace ilo_job2_eco_isic3=18 if ilo_job2_eco_isic3_2digits==. & ilo_mjh==2
			lab val ilo_job2_eco_isic3 isic3
			lab var ilo_job2_eco_isic3 "Economic activity (ISIC Rev. 3.1)"
			
	* Primary activity
	gen ilo_job2_eco_aggregate=.
		replace ilo_job2_eco_aggregate=1 if inlist(ilo_job2_eco_isic3,1,2)
		replace ilo_job2_eco_aggregate=2 if ilo_job2_eco_isic3==4
		replace ilo_job2_eco_aggregate=3 if ilo_job2_eco_isic3==6
		replace ilo_job2_eco_aggregate=4 if inlist(ilo_job2_eco_isic3,3,5)
		replace ilo_job2_eco_aggregate=5 if inrange(ilo_job2_eco_isic3,7,11)
		replace ilo_job2_eco_aggregate=6 if inrange(ilo_job2_eco_isic3,12,17)
		replace ilo_job2_eco_aggregate=7 if ilo_job2_eco_isic3==18
			    lab val ilo_job2_eco_aggregate eco_aggr_lab
			    lab var ilo_job2_eco_aggregate "Economic activity (Aggregate)"
	
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_job1_ocu_isco88') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment: - National classification is based on ISCO-88 (4 digit-level available).

    * MAIN JOB	   
    * ISCO-88 2 digits-level
    destring f71_2, replace
   
			
    * ISCO88
    gen ilo_job1_ocu_isco88_2digits=int(f71_2/100) if ilo_lfs==1
	    lab values ilo_job1_ocu_isco88_2digits isco88_2digits
	    lab var ilo_job1_ocu_isco88_2digits "Occupation (ISCO-88), 2 digit level"
			
    * One digit-level
	gen ilo_job1_ocu_isco88=.
	    replace ilo_job1_ocu_isco88=11 if inlist(ilo_job1_ocu_isco88_2digits,0,.) & ilo_lfs==1                       //Not elsewhere classified
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
	

    * SECOND JOB	   
    * ISCO-88 2 digits-level
    destring f90_2, replace
   
			
    * ISCO88
    gen ilo_job2_ocu_isco88_2digits=int(f90_2/100) if ilo_mjh==2
	    lab values ilo_job2_ocu_isco88_2digits isco88_2digits
	    lab var ilo_job2_ocu_isco88_2digits "Occupation (ISCO-88), 2 digit level"
			
    * One digit-level
	gen ilo_job2_ocu_isco88=.
	    replace ilo_job2_ocu_isco88=11 if inlist(ilo_job2_ocu_isco88_2digits,0,.) & ilo_mjh==2                       //Not elsewhere classified
		replace ilo_job2_ocu_isco88=int(ilo_job2_ocu_isco88_2digits/10) if (ilo_job2_ocu_isco88==. & ilo_mjh==2)     //The rest of the occupations
		replace ilo_job2_ocu_isco88=10 if (ilo_job2_ocu_isco88==0 & ilo_mjh==2)                                      //Armed forces
				lab val ilo_job2_ocu_isco88 isco88
				lab var ilo_job2_ocu_isco88 "Occupation (ISCO-88)"
				
	* Aggregate:			
	gen ilo_job2_ocu_aggregate=.
		replace ilo_job2_ocu_aggregate=1 if inrange(ilo_job2_ocu_isco88,1,3)
		replace ilo_job2_ocu_aggregate=2 if inlist(ilo_job2_ocu_isco88,4,5)
		replace ilo_job2_ocu_aggregate=3 if inlist(ilo_job2_ocu_isco88,6,7)
		replace ilo_job2_ocu_aggregate=4 if ilo_job2_ocu_isco88==8
		replace ilo_job2_ocu_aggregate=5 if ilo_job2_ocu_isco88==9
		replace ilo_job2_ocu_aggregate=6 if ilo_job2_ocu_isco88==10
		replace ilo_job2_ocu_aggregate=7 if ilo_job2_ocu_isco88==11
				lab val ilo_job2_ocu_aggregate ocu_aggr_lab
				lab var ilo_job2_ocu_aggregate "Occupation (Aggregate)"				
				
    * Skill level				
    gen ilo_job2_ocu_skill=.
	    replace ilo_job2_ocu_skill=1 if ilo_job2_ocu_isco88==9                   // Low
		replace ilo_job2_ocu_skill=2 if inlist(ilo_job2_ocu_isco88,4,5,6,7,8)    // Medium
		replace ilo_job2_ocu_skill=3 if inlist(ilo_job2_ocu_isco88,1,2,3)        // High
		replace ilo_job2_ocu_skill=4 if inlist(ilo_job2_ocu_isco88,10,11)        // Not elsewhere classified
			    lab val ilo_job2_ocu_skill ocu_skill_lab
			    lab var ilo_job2_ocu_skill "Occupation (Skill level)"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_job1_ins_sector') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment: Public: Public employees
*   	   Private: The rest

	* MAIN JOB:
	gen ilo_job1_ins_sector=.
		replace ilo_job1_ins_sector=1 if f73==2 & ilo_lfs==1				// Public
		replace ilo_job1_ins_sector=2 if f73!=2 & ilo_lfs==1		        // Private
				lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private" 
				lab values ilo_job1_ins_sector ins_sector_lab
				lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities - main job"
	
	* SECOND JOB:
	gen ilo_job2_ins_sector=.
		replace ilo_job2_ins_sector=1 if f92==2 & ilo_mjh==2				// Public
		replace ilo_job2_ins_sector=2 if f92!=2 & ilo_mjh==2		        // Private
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
* Comment: 
/*	Useful questions:
			- Institutional sector: Not asked. However, question f73 identifies public employees.
			- Destination of production: Not asked.
			- Households identification: ilo_job1_eco_isic3_2digits==95 / ilo_job1_ocu_isco88_2digits==62
			- Bookkeeping: Not asked.
			- Registration: Not asked.
			- Status in employment: ilo_job1_ste_aggregate
			- Social security: f82 (contribution to pension funds)
			- Place of work: f78
			- Size: f77
			- Paid annual leave: Not asked.
			- Paid sick leave: Not asked.
*/			

	* 1) UNIT OF PRODUCTION: FORMAL/INFORMAL SECTOR		
    			
			gen ilo_job1_ife_prod=.
			    replace ilo_job1_ife_prod=3 if ilo_lfs==1 & ///
				                              ((ilo_job1_eco_isic3_2digits==95) | (ilo_job1_ocu_isco88_2digits==62))
				replace ilo_job1_ife_prod=2 if ilo_lfs==1 & ilo_job1_ife_prod!=3 & ///
				                               ((f73==2) | ///
											   (f73!=2 & ilo_job1_ste_aggregate==1 & f82==1) | ///
											   (f73!=2 & ilo_job1_ste_aggregate==1 & f82!=1 & f78==1 & inlist(f77,3,4,5,6,7)) | ///
											   (f73!=2 & ilo_job1_ste_aggregate!=1 & f78==1 & inlist(f77,3,4,5,6,7)))
  			    replace ilo_job1_ife_prod=1 if ilo_lfs==1 & ilo_job1_ife_prod!=3 & ///
				                               ((f73!=2 & ilo_job1_ste_aggregate==1 & f82!=1 & f78==1 & inlist(f77,0,1,2)) | ///
											   (f73!=2 & ilo_job1_ste_aggregate==1 & f82!=1 & f78!=1) | ///
											   (f73!=2 & ilo_job1_ste_aggregate!=1 & f78==1 & inlist(f77,0,1,2)) | ///
											   (f73!=2 & ilo_job1_ste_aggregate!=1 & f78!=1))
				        lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 
						lab val ilo_job1_ife_prod ilo_ife_prod_lab
						lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"
						
						
	* 2) NATURE OF JOB: FORMAL/INFORMAL EMPLOYMENT 
	
	      gen ilo_job1_ife_nature=.
		      replace ilo_job1_ife_nature=2 if ilo_lfs==1 & ///
			                                  ((inlist(ilo_job1_ste_icse93,1,6) & f82==1) | ///
											  (inlist(ilo_job1_ste_icse93,2,4) & ilo_job1_ife_prod==2) | ///
											  (ilo_job1_ste_icse93==3 & ilo_job1_ife_prod==2))
			  replace ilo_job1_ife_nature=1 if ilo_lfs==1 & ///
			                                  ((inlist(ilo_job1_ste_icse93,1,6) & inlist(f82,0,2)) | ///
											  (inlist(ilo_job1_ste_icse93,2,4) & inlist(ilo_job1_ife_prod,1,3)) | ///
											  (ilo_job1_ste_icse93==3 & inlist(ilo_job1_ife_prod,1,3)) | ///
											  (ilo_job1_ste_icse93==5)) 
			          lab def ife_nature_lab 1 "1 - Persons with informal main job" 2 "2 - Persons with formal main job"
			          lab val ilo_job1_ife_nature ife_nature_lab
			          lab var ilo_job1_ife_nature "Informal / Formal Economy (Nature of job)"
					  
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Hours of work ('ilo_how') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment:
		
	* MAIN JOB:
			
	* 1) Weekly hours ACTUALLY worked:
         * Not available.
		
	* 2) Weekly hours USUALLY worked:
		 gen ilo_job1_how_usual = f85 if ilo_lfs==1
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
			
	* 1) Weekly hours ACTUALLY worked in second job:
         * Not available
		
	* 2) Weekly hours USUALLY worked in second job:
		 gen ilo_job2_how_usual = f98 if ilo_mjh==2
			 lab var ilo_job2_how_usual "Weekly hours usually worked in second job"
					 
		 gen ilo_job2_how_usual_bands=.
		 	 replace ilo_job2_how_usual_bands=1 if ilo_job2_how_usual==0
			 replace ilo_job2_how_usual_bands=2 if inrange(ilo_job2_how_usual,1,14)
			 replace ilo_job2_how_usual_bands=3 if inrange(ilo_job2_how_usual,15,29)
			 replace ilo_job2_how_usual_bands=4 if inrange(ilo_job2_how_usual,30,34)
			 replace ilo_job2_how_usual_bands=5 if inrange(ilo_job2_how_usual,35,39)
			 replace ilo_job2_how_usual_bands=6 if inrange(ilo_job2_how_usual,40,48)
			 replace ilo_job2_how_usual_bands=7 if ilo_job2_how_usual>=49 & ilo_job2_how_usual!=.
			 replace ilo_job2_how_usual_bands=8 if ilo_job2_how_usual==. & ilo_mjh==2
			 replace ilo_job2_how_usual_bands=. if ilo_lfs!=1
					 lab val ilo_job2_how_usual_bands how_usu_bands_lab
					 lab var ilo_job2_how_usual_bands "Weekly hours usually worked bands in second job"
  		
	* ALL JOBS:
		
	* 1) Weekly hours ACTUALLY worked in all jobs:
         * Not available
						
						
	* 2) Weekly hours USUALLY worked in all jobs:
		 egen ilo_joball_how_usual = rowtotal(ilo_job1_how_usual ilo_job2_how_usual), m
              replace ilo_joball_how_usual = . if ilo_mjh!=2
			 lab var ilo_joball_how_usual "Weekly hours usually worked in all jobs"
					 
		 gen ilo_joball_how_usual_bands=.
		 	 replace ilo_joball_how_usual_bands=1 if ilo_joball_how_usual==0
			 replace ilo_joball_how_usual_bands=2 if inrange(ilo_joball_how_usual,1,14)
			 replace ilo_joball_how_usual_bands=3 if inrange(ilo_joball_how_usual,15,29)
			 replace ilo_joball_how_usual_bands=4 if inrange(ilo_joball_how_usual,30,34)
			 replace ilo_joball_how_usual_bands=5 if inrange(ilo_joball_how_usual,35,39)
			 replace ilo_joball_how_usual_bands=6 if inrange(ilo_joball_how_usual,40,48)
			 replace ilo_joball_how_usual_bands=7 if ilo_joball_how_usual>=49 & ilo_joball_how_usual!=.
			 replace ilo_joball_how_usual_bands=8 if ilo_joball_how_usual==. & ilo_mjh==2
			 replace ilo_joball_how_usual_bands=. if ilo_lfs!=1
					 lab val ilo_joball_how_usual_bands how_usu_bands_lab
					 lab var ilo_joball_how_usual_bands "Weekly hours usually worked bands in all jobs"
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job1_job_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
* Comment: - National threshold is set at 40 hours
	   
	   gen ilo_job1_job_time=.
				replace ilo_job1_job_time=1 if ilo_joball_how_usual<40 & ilo_lfs==1
				replace ilo_job1_job_time=2 if ilo_joball_how_usual>=40 & ilo_job1_job_time==. & ilo_lfs==1
				replace ilo_job1_job_time=3 if !inlist(ilo_job1_job_time,1,2) & ilo_lfs==1
					lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
					lab val ilo_job1_job_time job_time_lab
					lab var ilo_job1_job_time "Job (Working time arrangement) - Main job"	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Monthly labour related income ('ilo_job1_lri') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
* Comments: - Unit: local currency (Uruguayan peso).
	   
  * MAIN JOB:
	 * Employees
	 gen ilo_job1_lri_ees = pt2 if ilo_job1_ste_aggregate==1
	     lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"	
				   
	 * Self-employed
	 gen ilo_job1_lri_slf = pt2 if ilo_job1_ste_aggregate==2
	     lab var ilo_job1_lri_slf "Monthly labour related income of self-employed in main job"
			
***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_joball_tru') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
* Comment: - National threshold is set at 40 hours usually worked per week.
	
	   gen ilo_joball_tru=.
		   replace ilo_joball_tru=1 if ilo_lfs==1 & f102==1 & f103==1 & ilo_job1_how_usual<40
			       lab def ilo_tru 1 "Time-related underemployed"
				   lab val ilo_joball_tru ilo_tru
				   lab var ilo_joball_tru "Time-related underemployed"				
					
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupational injury ('ilo_joball_inj') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
* Comment: Information not available

*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Days lost due to cases of occupational injury ('ilo_joball_oi_day') [done]
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
* Comment: Information not available

	
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
			replace ilo_cat_une=1 if ilo_lfs==2 & f116==1			            // Previously employed
			replace ilo_cat_une=2 if ilo_lfs==2 & f116==2			            // Seeking first job
			replace ilo_cat_une=3 if ilo_lfs==2 & !inlist(ilo_cat_une,1,2)	    // Unkown
				lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
				lab val ilo_cat_une cat_une_lab
				lab var ilo_cat_une "Category of unemployment"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comments: - Original question refers to the number of weeks seeking for a job.

	gen ilo_dur_details=.
	    replace ilo_dur_details=1 if (inrange(f113,0,3) & ilo_lfs==2)           // Less than 1 month (between 1 and 3 weeks)
		replace ilo_dur_details=2 if (inrange(f113,4,11) & ilo_lfs==2)          // 1 to 3 months (between 4 and 11 weeks)
		replace ilo_dur_details=3 if (inrange(f113,12,23) & ilo_lfs==2)         // 3 to 6 months (between 12 and 23 weeks)
		replace ilo_dur_details=4 if (inrange(f113,24,47) & ilo_lfs==2)         // 6 to 12 months (between 24 and 47 weeks)
		replace ilo_dur_details=5 if (inrange(f113,48,95) & ilo_lfs==2)         // 12 to 24 months (between 48 and 95 weeks)
		replace ilo_dur_details=6 if (f113>=96 & ilo_lfs==2)                    // 24 months or more (96 weeks or more)
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
		replace ilo_dur_aggregate=4 if (ilo_dur_details==7 & ilo_lfs==2)              //Not elsewhere classified
		replace ilo_dur_aggregate=. if ilo_lfs!=2
			lab def ilo_unemp_aggr 1 "Less than 6 months" 2 "6 months to less than 12 months" 3 "12 months or more" 4 "Not elsewhere classified"
			lab val ilo_dur_aggregate ilo_unemp_aggr
			lab var ilo_dur_aggregate "Duration of unemployment (Aggregate)"

	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
* Comment: - National classification is based on ISIC Rev.3 (4 digit-level are available).

  * PREVIOUS JOB:
  * ISIC Rev. 3 - 2 digit-level
  destring f120_2, replace 
  
  gen ilo_preveco_isic3_2digits = int(f120_2/100) if ilo_lfs==2 & ilo_cat_une==1
	  lab values ilo_preveco_isic3_2digits isic3_2digits
	  lab var ilo_preveco_isic3_2digits "Previous economic activity (ISIC Rev. 3), 2 digit level"
							
    * ISIC Rev. 3
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
			
	* Aggregate activity
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
* Comment: - National classification is based on ISCO-88 (4 digit-level available).

    * PREVIOUS JOB	   
    * ISCO-88 2 digits-level
    destring f119_2, replace
   
	* ISCO88
    gen ilo_prevocu_isco88_2digits=int(f119_2/100) if ilo_lfs==2 & ilo_cat_une==1
	    lab values ilo_prevocu_isco88_2digits isco88_2digits
	    lab var ilo_prevocu_isco88_2digits "Previous occupation (ISCO-88), 2 digit level"
			
    * One digit-level
	gen ilo_prevocu_isco88=.
	    replace ilo_prevocu_isco88=11 if inlist(ilo_prevocu_isco88_2digits,0,.) & ilo_lfs==2 & ilo_cat_une==1                         //Not elsewhere classified
		replace ilo_prevocu_isco88=int(ilo_prevocu_isco88_2digits/10) if (ilo_prevocu_isco88==. & ilo_lfs==2 & ilo_cat_une==1 )       //The rest of the occupations
		replace ilo_prevocu_isco88=10 if (ilo_prevocu_isco88==0 & ilo_lfs==2 & ilo_cat_une==1)                                        //Armed forces
				lab val ilo_prevocu_isco88 isco88
				lab var ilo_prevocu_isco88 "Previous occupation (ISCO-88)"
				
	* Aggregate:			
	gen ilo_prevocu_aggregate=.
		replace ilo_prevocu_aggregate=1 if inrange(ilo_prevocu_isco88,1,3)
		replace ilo_prevocu_aggregate=2 if inlist(ilo_prevocu_isco88,4,5)
		replace ilo_prevocu_aggregate=3 if inlist(ilo_prevocu_isco88,6,7)
		replace ilo_prevocu_aggregate=4 if ilo_prevocu_isco88==8
		replace ilo_prevocu_aggregate=5 if ilo_prevocu_isco88==9
		replace ilo_prevocu_aggregate=6 if ilo_prevocu_isco88==10
		replace ilo_prevocu_aggregate=7 if ilo_prevocu_isco88==11
				lab val ilo_prevocu_aggregate ocu_aggr_lab
				lab var ilo_prevocu_aggregate "Occupation (Aggregate)"				
				
    * Skill level				
    gen ilo_prevocu_skill=.
	    replace ilo_prevocu_skill=1 if ilo_prevocu_isco88==9                   // Low
		replace ilo_prevocu_skill=2 if inlist(ilo_prevocu_isco88,4,5,6,7,8)    // Medium
		replace ilo_prevocu_skill=3 if inlist(ilo_prevocu_isco88,1,2,3)        // High
		replace ilo_prevocu_skill=4 if inlist(ilo_prevocu_isco88,10,11)        // Not elsewhere classified
			    lab val ilo_prevocu_skill ocu_skill_lab
			    lab var ilo_prevocu_skill "Occupation (Skill level)"

***********************************************************************************************
*			PART 3.3. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment:	- Willingness is not asked.
*           - Two questions related to looking/seeking for a job: during the past week or during
*             the past 4 weeks.
*           - Not available includes: he/she was available but not recently or not available.
	
	gen ilo_olf_dlma=.
		replace ilo_olf_dlma = 1 if (f107==1 | f109==1) & inlist(f106,2,3) & ilo_lfs==3 		// Seeking, not available
		replace ilo_olf_dlma = 2 if (f107==2 & f109==2) & f106==1 & ilo_lfs==3			        // Not seeking, available
		*replace ilo_olf_dlma = 3 	                                                            // Not seeking, not available, willing
		*replace ilo_olf_dlma = 4 	                                                            // Not seeking, not available, not willing
		replace ilo_olf_dlma = 5 if	ilo_olf_dlma==. & ilo_lfs==3				                // Not classified 
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
			replace ilo_olf_reason=1 if	f108==4 & ilo_lfs==3	                // Labour market
			*replace ilo_olf_reason=2 if                                        // Other labour market reasons
			replace ilo_olf_reason=3 if	inlist(f108,1,5) & ilo_lfs==3    	    // Personal/Family-related
			*replace ilo_olf_reason=4 if 		                                // Does not need/want to work
			replace ilo_olf_reason=5 if ilo_olf_reason==. & ilo_lfs==3	        // Not elsewhere classified
				    lab def reasons_lab 1 "1 - Labour market" 2 "2 - Other labour market reasons" 3 "3 - Personal / Family-related" ///
									    4 "4 - Does not need/want to work" 5 "5 - Not elsewhere classified"
				    lab val ilo_olf_reason reasons_lab 
				    lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seeker ('ilo_dis')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment:

	gen ilo_dis=.
	    replace ilo_dis=1 if ilo_lfs==3 & f106==1 & ilo_olf_reason==1
	            lab def dis_lab 1 "Discouraged job-seekers"
			    lab val ilo_dis dis_lab
			    lab var ilo_dis "Discouraged job-seekers"

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
		
		/*Variables computed for education*/
		drop asis_edu_0 asis_edu_1 asis_edu_2 asis_edu_3 asis_edu_4 asis_edu_5 asis_edu_6 high_edu_6 high_edu_5 high_edu_4 high_edu_3 high_edu_2 high_edu_1 high_edu_0
		
		/*Variables computed in-between*/
		drop to_drop to_drop_2 quarter
		drop lab isco08_2digits isco88_2digits isco08 isco88 isic4_2digits isic4 isic3_2digits isic3
		
		compress 
		
	   /*Save dataset including original and ilo variables*/
	
		save ${country}_${source}_${time}_FULL,  replace		
	
	  /* Save file only containing ilo_* variables*/
	
		keep ilo*

		save ${country}_${source}_${time}_ILO, replace

	
	
	
