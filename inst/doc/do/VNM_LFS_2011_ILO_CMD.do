* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Vietnam, 2011
* DATASET USED: Vietnam LFS 2011
* NOTES:
* Files created: Standard variables on LFS Vietnam 2011
* Authors: Mabelin Villarreal Fuentes
* Who last updated the file: Mabelin Villarreal Fuentes
* Starting Date: 01 June 2017
* Last updated: 02 June 2017
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
global country "VNM"
global source "LFS"
global time "2011"
global inputFile "LFS_2011_Eng"
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
		
*-- generates variable "to_drop" that will be split in two parts: annual part (to_drop_1) and quarterly part (to_drop_2)
   decode ilo_time, gen(to_drop)
   split to_drop, generate(to_drop_) parse(Q)
   destring to_drop_1, replace force

*-- generation of to_drop_2 that contains information on the quarter (if it is quarterly) or -9999 if its annual
   capture destring to_drop_2, replace force
   capture gen to_drop_2=-9999

*-- creating local variables for year and quarter   
   local A "year_"
   gen `A'= to_drop_1
   
   local Q "quarter_"
   gen `Q'= to_drop_2
   
*--creating the variable quarter (to drop)
gen quarter=.
    replace quarter=1 if inlist(thangdt,1,2,3)
	replace quarter=2 if inlist(thangdt,4,5,6)
	replace quarter=3 if inlist(thangdt,7,8,9)
	replace quarter=4 if inlist(thangdt,10,11,12)
	   
*-- annual case
gen ilo_wgt=.

if `Q' == -9999{
   replace ilo_wgt=w_p_q/4
   lab var ilo_wgt "Sample weight"
}

*-- quarters        
else{
   replace ilo_wgt = w_p_q
   keep if quarter==`Q'
   lab var ilo_wgt "Sample weight"	
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

	gen ilo_geo=ttnt
		lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural"
		lab val ilo_geo ilo_geo_lab
		lab var ilo_geo "Geographical coverage"	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_sex=c3
		lab def ilo_sex_lab 1 "1 - Male" 2 "2 - Female"
		lab var ilo_sex "Sex"
		lab val ilo_sex ilo_sex_lab


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: from the original variable -> if age is 95 years or more => 95
*          Only observations with information about age are kept (6 obs deleted)

	gen ilo_age=c5
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
			
drop if ilo_age==.			

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education ('ilo_edu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	
/* ISCED 97 mapping: variable very closed to ISCED 97, use as well UNESCO mapping
					 http://uis.unesco.org/en/isced-mappings
			
					
	NOTE: * Answer 7 in the questionnaire (vocational school) is mapped to upper secondary education
		  * The question is only asked to people aged 15 and more, so people below the age of 15 are 
		    classified under "Not elsewhere classified".
*/

	gen ilo_edu_isced97=.
		replace ilo_edu_isced97=1 if c11==0  					// No schooling
		replace ilo_edu_isced97=2 if c11==1 					// Pre-primary education
		replace ilo_edu_isced97=3 if c11==2  		            // Primary education or first stage of basic education
		replace ilo_edu_isced97=4 if c11==3  		            // Lower secondary or second stage of basic education
		replace ilo_edu_isced97=5 if inlist(c11,4,5,6,7)	    // Upper secondary education
		*replace ilo_edu_isced97=6 if                         	// Post-secondary non-tertiary education
		replace ilo_edu_isced97=7 if inlist(c11,8,9)	        // First stage of tertiary education (not leading directly to an advanced research qualification)
		replace ilo_edu_isced97=8 if c11== 10    				// Second stage of tertiary education (leading to an advanced research qualification)
		replace ilo_edu_isced97=9 if ilo_edu_isced97==.		    // Level  not stated
			label def isced_97_lab 1 "X - No schooling" 2 "0 - Pre-primary education" 3 "1 - Primary education or first stage of basic education" 4 "2 - Lower secondary education or second stage of basic education" ///
							5 "3 - Upper secondary education" 6 "4 - Post-secondary non-tertiary education" 7 "5 - First stage of tertiary education (not leading directly to an advanced research qualification)" ///
							8 "6 - Second stage of tertiary education (leading to an advanced research qualification)" 9 "UNK - Level not stated"
			label val ilo_edu_isced97 isced_97_lab
			lab var ilo_edu_isced97 "Education (ISCED 97)"

		
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
* Comment: Not available

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Disability status ('ilo_dsb') 	[done]
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
* Comment: - Employment is based on the definition used by the NSO.
*          - Future starters must be included in unemployment. Question 21 groups together
*          the future starters (who already made an arrangement to start a new job) with people
*          "waiting for result of job application". The latter should normally not be included
*          in unemployment but they cannot be differentiated from the future starters so they 
*          are also in unemployment. 
		
    gen ilo_lfs=.
	    replace ilo_lfs=1 if c13==1 & ilo_wap==1                                         //Employed
		replace ilo_lfs=1 if c14==1 & ilo_wap==1                                         //Employed
		replace ilo_lfs=1 if c15==2 & ilo_wap==1                                         //Employed
		replace ilo_lfs=1 if c17!=. & c18==1 & ilo_wap==1                                //Employed
		replace ilo_lfs=1 if c18==1 & ilo_wap==1                                         //Employed
		replace ilo_lfs=2 if ilo_lfs!=1 & ((c19==1 & c22==1) | c21==5) & ilo_wap==1      //Unemployed
		replace ilo_lfs=3 if ilo_lfs!=1 & ilo_lfs!=2 & ilo_wap==1                        // Outside the labour force
				label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside the Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: observations that don't answer to the question about a second job are classified 
*          under "one job only"

	gen ilo_mjh=.
		replace ilo_mjh=1 if inlist(c55,3,.) & ilo_lfs==1
		replace ilo_mjh=2 if inlist(c55,1,2) & ilo_lfs==1
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
				replace ilo_job1_ste_icse93=1 if c41==4	& ilo_lfs==1			        // Employees
				replace ilo_job1_ste_icse93=2 if c41==1	& ilo_lfs==1			        // Employers
				replace ilo_job1_ste_icse93=3 if c41==2	& ilo_lfs==1			        // Own-account workers
				replace ilo_job1_ste_icse93=4 if c41==5	& ilo_lfs==1			        // Producer cooperatives
				replace ilo_job1_ste_icse93=5 if c41==3	& ilo_lfs==1	           		// Contributing family workers
				replace ilo_job1_ste_icse93=6 if ilo_job1_ste_icse93==. & ilo_lfs==1	// Not classifiable
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
				replace ilo_job2_ste_icse93=1 if c62==4	& ilo_mjh==2			        // Employees
				replace ilo_job2_ste_icse93=2 if c62==1	& ilo_mjh==2			        // Employers
				replace ilo_job2_ste_icse93=3 if c62==2	& ilo_mjh==2			        // Own-account workers
				replace ilo_job2_ste_icse93=4 if c62==5	& ilo_mjh==2			        // Producer cooperatives
				replace ilo_job2_ste_icse93=5 if c62==3	& ilo_mjh==2	        		// Contributing family workers
				replace ilo_job2_ste_icse93=6 if ilo_job2_ste_icse93==. & ilo_mjh==2	// Not classifiable
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
* Comment: National classification is based on ISIC 4, at a 2 digit-level the national 
*          classification is identic to ISIC Rev. 4.
		
   append using `labels', gen(lab)
   *use value label from this variable, afterwards drop everything related to this append
			
			
   * MAIN JOB:
				
	* ISIC Rev. 4 - 2 digit
	gen isic2dig = int(c38/100) if ilo_lfs==1 
		replace isic2dig=. if isic2dig==0
						
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
   gen isic2dig_job2 = int(c59/100) if ilo_mjh==2
	   replace isic2dig_job2=. if isic2dig_job2==0

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
* Comment: Viet Nam uses its own classification that is based on ISCO 88. 
*          It can be mapped to ISCO 88 at 1 digit level.  		
	   

   * MAIN JOB:
   	 gen occup_1dig=int(c35/1000) if ilo_lfs==1 & c35>0
	
	
   * ISCO 88 - 1 digit:
	 gen ilo_job1_ocu_isco88=occup_1dig if ilo_lfs==1
	   	 replace ilo_job1_ocu_isco88=11 if inlist(occup_1dig,0,.) & ilo_lfs==1
		         lab values ilo_job1_ocu_isco88 isco88
				 lab var ilo_job1_ocu_isco88 "Occupation (ISCO-88) - main job"
	
	
  * Aggregate
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
	

  * SECOND JOB:
	gen occup_1dig_job2=int(c56/1000) if ilo_mjh==2 & c56>0
	
	
  * ISCO 88 - 1 digit:
	gen ilo_job2_ocu_isco88=occup_1dig_job2 if ilo_mjh==2
		replace ilo_job2_ocu_isco88=11 if inlist(occup_1dig_job2, 0,.) & ilo_mjh==2
				lab values ilo_job2_ocu_isco88 isco88
				lab var ilo_job2_ocu_isco88 "Occupation (ISCO-88) - second job"
	
	
  * Aggregate:
	gen ilo_job2_ocu_aggregate=.
		replace ilo_job2_ocu_aggregate=1 if inrange(ilo_job2_ocu_isco88,1,3)
		replace ilo_job2_ocu_aggregate=2 if inlist(ilo_job2_ocu_isco88,4,5)
		replace ilo_job2_ocu_aggregate=3 if inlist(ilo_job2_ocu_isco88,6,7)
		replace ilo_job2_ocu_aggregate=4 if ilo_job2_ocu_isco88==8
		replace ilo_job2_ocu_aggregate=5 if ilo_job2_ocu_isco88==9
		replace ilo_job2_ocu_aggregate=6 if ilo_job2_ocu_isco88==10
		replace ilo_job2_ocu_aggregate=7 if ilo_job2_ocu_isco88==11
		replace ilo_job2_ocu_aggregate=. if ilo_mjh!=2
				lab val ilo_job2_ocu_aggregate ocu_aggr_lab
				lab var ilo_job2_ocu_aggregate "Occupation (Aggregate) - second job"	
				
  * Skill level
	gen ilo_job2_ocu_skill=.
	    replace ilo_job2_ocu_skill=1 if ilo_job2_ocu_isco88==9                   // Low
		replace ilo_job2_ocu_skill=2 if inlist(ilo_job2_ocu_isco88,4,5,6,7,8)    // Medium
		replace ilo_job2_ocu_skill=3 if inlist(ilo_job2_ocu_isco88,1,2,3)        // High
		replace ilo_job2_ocu_skill=4 if inlist(ilo_job2_ocu_isco88,10,11)        // Not elsewhere classified
				lab val ilo_job2_ocu_skill ocu_skill_lab
			    lab var ilo_job2_ocu_skill "Occupation (Skill level) - second job"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_job1_ins_sector') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment: Public: state agency, state productive unit, state entreprise
*   	   Private: household/individual, individual business household, collective, private, foreign investment		 */
	
	* MAIN JOB:
	
		gen ilo_job1_ins_sector=.
			replace ilo_job1_ins_sector=1 if inrange(c36,5,7) & ilo_lfs==1				// Public
			replace ilo_job1_ins_sector=2 if ilo_job1_ins_sector!=1 & ilo_lfs==1		// Private
				lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private" 
				lab values ilo_job1_ins_sector ins_sector_lab
				lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities - main job"
	
	* SECOND JOB:
	
		gen ilo_job2_ins_sector=.
			replace ilo_job2_ins_sector=1 if inrange(c57,5,7) & ilo_mjh==2				// Public
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
	     gen ilo_job1_how_actual=c52 if ilo_lfs==1
		     replace ilo_job1_how_actual=. if ilo_job1_how_actual<0
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
		 gen ilo_job1_how_usual=c51 if ilo_lfs==1
			 replace ilo_job1_how_usual=. if ilo_job1_how_usual<0
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
         gen ilo_job2_how_actual=c70 if ilo_mjh==2
			 replace ilo_job2_how_actual=. if ilo_job2_how_actual<0
					 lab var ilo_job2_how_actual "Weekly hours actually worked in second job"
		
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
					 lab var ilo_job2_how_actual_bands "Weekly hours actually worked bands in second job"
		
	* 2) Weekly hours USUALLY worked:
		 * Not available
		
		
	* ALL JOBS:
		
	* 1) Weekly hours ACTUALLY worked:
		 gen ilo_joball_how_actual=c73 if ilo_lfs==1
			 replace ilo_joball_how_actual=. if ilo_joball_how_actual<0
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
		 * Not available

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job1_job_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
*Comment: The question is not asked directly; thus, we take the median of actual hours of work
*        (because usual hours of work is not available) for all jobs which is 48
	   
	   gen ilo_job1_job_time=.
    	   replace ilo_job1_job_time=1 if ilo_job1_how_usual<48 
		   replace ilo_job1_job_time=2 if ilo_job1_how_usual>=48 & ilo_job1_how_usual!=.
		   replace ilo_job1_job_time=3 if ilo_job1_job_time!=1 & ilo_job1_job_time!=2 & ilo_lfs==1
			       lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
				   lab val ilo_job1_job_time job_time_lab
				   lab var ilo_job1_job_time "Job (Working time arrangement) - Main job"	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job1_job_contract') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
* Comment: The possible answers to the question asking for the type of contract mix answers 
*          related to the length of contract (temporary or permanent)and the form of contract 
*          (oral, no contract). As around 62% of people answer either oral agreement or no 
*          conrtact it would make no sense to create the variable.		
		
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Formal / Informal Economy ('ilo_job1_ife_prod' 'ilo_job1_ife_nature') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
* Comment: 

            /*	Useful questions:
			- Institutional sector: c36
			- Destination of production: not asked.
			- Bookkeeping: not asked
			- Registration: c39a (tax code registration)
			- Status in employment: ilo_job1_ste_aggregate
			- Social security contribution: c44c (pay for social insurance)
			- Place of work: c45 
			- Size: c40 (1st category is 1 to 20 => not used)
			- Paid annual leave: c44a -> receive paid public holidays/leaves?
			- Paid sick leave: not asked
		
    		* There is no category Households created from the institutional sector question 
			due to the high proportion that they represent and that probably is refering to farms. 
			Instead, we use the economic activity classification to classify households 
			(ilo_job1_eco_isic4_2digits) */
	
    * Social security (to be dropped afterwards): 
            gen social_security=.
			    replace social_security=1 if (c44c==1 & ilo_lfs==1)             // Pay for social insurance
				replace social_security=2 if (c44c==2 & ilo_lfs==1)             // No pay for social insurance

    * Registration 
            gen registration=.
			    replace registration=1 if (c39a==1) & ilo_lfs==1                // Tax code registration
				replace registration=2 if (c39a==2) & ilo_lfs==1                // No tax code registraiton


	* 1) UNIT OF PRODUCTION: FORMAL/INFORMAL SECTOR		
    			
			gen ilo_job1_ife_prod=.
			    replace ilo_job1_ife_prod=3 if ilo_lfs==1 & ///
				                              (ilo_job1_eco_isic4_2digits==97)
				replace ilo_job1_ife_prod=2 if ilo_lfs==1 & ilo_job1_ife_prod!=3 & ///
				                              ((inlist(c36,5,6,7)) | /// 
											  (!inlist(c36,5,6,7) & registration==1) | ///
											  (!inlist(c36,5,6,7) & registration==. & ilo_job1_ste_aggregate==1 & social_security==1))
			    replace ilo_job1_ife_prod=1 if ilo_lfs==1 & ilo_job1_ife_prod!=2 & ilo_job1_ife_prod!=3 & ///
				                              ((!inlist(c36,5,6,7) & registration==2) | ///
											  (!inlist(c36,5,6,7) & registration==. & ilo_job1_ste_aggregate==1 & inlist(social_security,2,.)) | ///
											  (!inlist(c36,5,6,7) & registration==. & ilo_job1_ste_aggregate!=1))
				        lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 
						lab val ilo_job1_ife_prod ilo_ife_prod_lab
						lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"
						
						
	* 2) NATURE OF JOB: FORMAL/INFORMAL EMPLOYMENT
	
	      gen ilo_job1_ife_nature=.
		      replace ilo_job1_ife_nature=1 if ilo_lfs==1 & ///
			                                  ((inlist(ilo_job1_ste_icse93,1,6) & inlist(social_security,2,.)) | ///
											  (inlist(ilo_job1_ste_icse93,2,4) & inlist(ilo_job1_ife_prod,1,3)) | ///
											  (ilo_job1_ste_icse93==3 & inlist(ilo_job1_ife_prod,1,3)) | ///
											  (ilo_job1_ste_icse93==5))
			  replace ilo_job1_ife_nature=2 if ilo_lfs==1 & ///
			                                  ((inlist(ilo_job1_ste_icse93,1,6) & social_security==1) | ///
											  (inlist(ilo_job1_ste_icse93,2,4) & ilo_job1_ife_prod==2) | ///
											  (ilo_job1_ste_icse93==3 & ilo_job1_ife_prod==2)) 
			          lab def ife_nature_lab 1 "1 - Persons with informal main job" 2 "2 - Persons with formal main job"
			          lab val ilo_job1_ife_nature ife_nature_lab
			          lab var ilo_job1_ife_nature "Informal / Formal Economy (Nature of job)"	
	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Monthly labour related income ('ilo_job1_lri') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
* Comments:
	   * The question is only asked to employees.
	   * The amounts recorded are in thousands, so they are multiplied by 1000 to have units.
	   * It includes overtime remunerations, bonuses and other welfare payments.
	   * Unit: local currency (dongs) */
	   
			* MAIN JOB:
			  gen wage=.
			      replace wage = c48 if c48>0 & ilo_job1_ste_aggregate==1
				  replace wage = wage*1000
			 
			  gen other_payments=.
			      replace other_payments = c50 if c50>0 & ilo_job1_ste_aggregate==1
				  replace other_payments = other_payments*1000
				
					
			* Employees
			  egen ilo_job1_lri_ees = rowtotal(wage other_payments), m
		           replace ilo_job1_lri_ees=. if ilo_job1_ste_aggregate!=1
						   lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"	
		
		
			* SECOND JOB:
			  gen wage2=.
			      replace wage2 = c68 if c68>0 & ilo_job2_ste_aggregate==1
    			  replace wage2 = wage2 *1000
			
			  gen other_payments2=.
			      replace other_payments2 = c69 if c69>0 & ilo_job2_ste_aggregate==1 
				  replace other_payments2 = other_payments2*1000	
				
			* Employees
			  egen ilo_job2_lri_ees = rowtotal(wage2 other_payments2), m
		           replace ilo_job2_lri_ees=. if ilo_job2_ste_aggregate!=1
					       lab var ilo_job2_lri_ees "Monthly earnings of employees in second job"	
		
***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_joball_tru') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
* Comment: Threshold used: 35 hours/week 
*          Only the total hours ACTUALLY worked are available.	*/			
				
		   gen ilo_joball_tru=.
			   replace ilo_joball_tru=1 if ilo_lfs==1 & c74==1 & c75==1 & c76>0 & ilo_joball_how_actual<35
				       lab def ilo_tru 1 "Time-related underemployed"
					   lab val ilo_joball_tru ilo_tru
					   lab var ilo_joball_tru "Time-related underemployed"				
					
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupational injury ('ilo_joball_inj') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
*Comment:  Not available
	
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
			replace ilo_cat_une=1 if ilo_lfs==2 & c27==1			            // Previously employed
			replace ilo_cat_une=2 if ilo_lfs==2 & c27==2			            // Seeking first job
			replace ilo_cat_une=3 if ilo_lfs==2 & c27!=1 & c27!=2	            //Unkown
				lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
				lab val ilo_cat_une cat_une_lab
				lab var ilo_cat_une "Category of unemployment"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: Question 25 asks the unemployed "How long have you been looking OR AVAILABLE to work?". 
*          As there's no better option, this question is used to approximate how long the 
*          unemployed have been LOOKING for work. Due to the categories in the questionnaire, 
*          only the aggregated variable can be created.	
		
	* Aggregate:
		
	gen ilo_dur_aggregate=.
		replace ilo_dur_aggregate=1 if inlist(c25,1,2) & ilo_lfs==2 	        // Less than 6 months
		replace ilo_dur_aggregate=2 if inlist(c25,3,4) & ilo_lfs==2	        	// 6 months to less than 12 months
		replace ilo_dur_aggregate=3 if c25==5 & ilo_lfs==2	        			// 12 months or more
		replace ilo_dur_aggregate=4 if ilo_dur_aggregate==. & ilo_lfs==2		// Not elsewhere classified
				lab def ilo_unemp_agr 1 "1 - Less than 6 months" 2 "2 - 6 months to less than 12 months" 3 "3 - 12 months or more" 4 "4 - Not elsewhere classified"
				lab values ilo_dur_aggregate ilo_unemp_agr
				lab var ilo_dur_aggregate "Duration of unemployment (Aggregate)"		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

	* ISIC Rev. 4 - 2 digit
	  gen indu_code_une_2dig=int(c34/100) 
		  replace indu_code_une_2dig=. if indu_code_une_2dig==0
					
	  gen ilo_preveco_isic4_2digits=.
		  replace ilo_preveco_isic4_2digits=indu_code_une_2dig if ilo_lfs==2 & ilo_cat_une==1
		  replace ilo_preveco_isic4_2digits=. if ilo_preveco_isic4<=0
		  lab var ilo_preveco_isic4_2digits "Previous economic activity (ISIC Rev. 4), 2 digit level"
							
	* ISIC Rev. 4 - 1 digit
	  gen ilo_preveco_isic4=.
		  replace ilo_preveco_isic4=1 if inrange(ilo_preveco_isic4_2digits,1,3)
		  replace ilo_preveco_isic4=2 if inrange(ilo_preveco_isic4_2digits,5,9)
		  replace ilo_preveco_isic4=3 if inrange(ilo_preveco_isic4_2digits,10,33)
		  replace ilo_preveco_isic4=4 if ilo_preveco_isic4_2digits==35
		  replace ilo_preveco_isic4=5 if inrange(ilo_preveco_isic4_2digits,36,39)
		  replace ilo_preveco_isic4=6 if inrange(ilo_preveco_isic4_2digits,41,43)
		  replace ilo_preveco_isic4=7 if inrange(ilo_preveco_isic4_2digits,45,47)
		  replace ilo_preveco_isic4=8 if inrange(ilo_preveco_isic4_2digits,49,53)
		  replace ilo_preveco_isic4=9 if inrange(ilo_preveco_isic4_2digits,55,56)
		  replace ilo_preveco_isic4=10 if inrange(ilo_preveco_isic4_2digits,58,63)
		  replace ilo_preveco_isic4=11 if inrange(ilo_preveco_isic4_2digits,64,66)
		  replace ilo_preveco_isic4=12 if ilo_preveco_isic4_2digits==68
		  replace ilo_preveco_isic4=13 if inrange(ilo_preveco_isic4_2digits,69,75)
		  replace ilo_preveco_isic4=14 if inrange(ilo_preveco_isic4_2digits,77,82)
		  replace ilo_preveco_isic4=15 if ilo_preveco_isic4_2digits==84
		  replace ilo_preveco_isic4=16 if ilo_preveco_isic4_2digits==85
		  replace ilo_preveco_isic4=17 if inrange(ilo_preveco_isic4_2digits,86,88)
		  replace ilo_preveco_isic4=18 if inrange(ilo_preveco_isic4_2digits,90,93)
		  replace ilo_preveco_isic4=19 if inrange(ilo_preveco_isic4_2digits,94,96)
		  replace ilo_preveco_isic4=20 if inrange(ilo_preveco_isic4_2digits,97,98)
		  replace ilo_preveco_isic4=21 if ilo_preveco_isic4_2digits==99
		  replace ilo_preveco_isic4=22 if ilo_preveco_isic4==. & ilo_cat_une==1
			      lab val ilo_preveco_isic4 isic4
				  lab var ilo_preveco_isic4 "Previous economic activity (ISIC Rev. 4)"
						
							
	* Aggregated level 
	  gen ilo_preveco_aggregate=.
		  replace ilo_preveco_aggregate=1 if ilo_preveco_isic4==1
		  replace ilo_preveco_aggregate=2 if ilo_preveco_isic4==3
		  replace ilo_preveco_aggregate=3 if ilo_preveco_isic4==6
		  replace ilo_preveco_aggregate=4 if inlist(ilo_preveco_isic4,2,4,5)
		  replace ilo_preveco_aggregate=5 if inrange(ilo_preveco_isic4,7,14)
		  replace ilo_preveco_aggregate=6 if inrange(ilo_preveco_isic4,15,21)
		  replace ilo_preveco_aggregate=7 if ilo_preveco_isic4==22
			      lab val ilo_preveco_aggregate eco_aggr_lab
				  lab var ilo_preveco_aggregate "Previous economic activity (Aggregate)" 
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
* Comment:Viet Nam uses its own classification, can be mapped to ISCO 88 at 1 digit.
	     
  * MAIN JOB:
    gen prev_occup=int(c30/1000) if c30>0
	
  * ISCO 88 - 1 digit:
	gen ilo_prevocu_isco88=prev_occup if ilo_lfs==2 & ilo_cat_une==1
		replace ilo_prevocu_isco88=11 if inlist(prev_occup, 0,.) & ilo_lfs==2 & ilo_cat_une==1
				lab values ilo_prevocu_isco88 isco88
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
		replace ilo_prevocu_aggregate=. if ilo_lfs!=2 
		replace ilo_prevocu_aggregate=. if ilo_cat_une!=1
				lab val ilo_prevocu_aggregate ocu_aggr_lab
				lab var ilo_prevocu_aggregate "Previous occupation (Aggregate)"	
				
  * Skill level
	gen ilo_prevocu_skill=.
	    replace ilo_prevocu_skill=1 if ilo_prevocu_isco88==9                   // Low
		replace ilo_prevocu_skill=2 if inlist(ilo_prevocu_isco88,4,5,6,7,8)    // Medium
		replace ilo_prevocu_skill=3 if inlist(ilo_prevocu_isco88,1,2,3)        // High
		replace ilo_prevocu_skill=4 if inlist(ilo_prevocu_isco88,10,11)        // Not elsewhere classified
			    lab val ilo_prevocu_skill ocu_skill_lab
			    lab var ilo_prevocu_skill "Previous occupation (Skill level)"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			General social protection ('ilo_gsp_unschemes') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
***********************************************************************************************
*			PART 3.3. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment:	
	
	gen ilo_olf_dlma=.
		replace ilo_olf_dlma = 1 if c19==1 & c22==2 & ilo_lfs==3 				//Seeking, not available
		replace ilo_olf_dlma = 2 if c19==2 & c22==1 & ilo_lfs==3				//Not seeking, available
		* replace ilo_olf_dlma = 3 if 											//Not seeking, not available, willing
		replace ilo_olf_dlma = 4 if c19==2 & c22==2 & c21==1 & ilo_lfs==3		//Not seeking, not available, not willing
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
			replace ilo_olf_reason=1 if	inlist(c21,2,3,4) & ilo_lfs==3   		//Labour market
			replace ilo_olf_reason=2 if c21==6                                  //Other labour market reasons
			replace ilo_olf_reason=3 if	inlist(c21,8,9) & ilo_lfs==3	        //Personal/Family-related
			replace ilo_olf_reason=4 if c21==1 & ilo_lfs==3						//Does not need/want to work
			replace ilo_olf_reason=5 if inlist(c21,0,7,10,.) & ilo_lfs==3	    //Not elsewhere classified
				*lab def reasons_lab 1 "1 - Labour market" 2 "2 - Other labour market reasons" 3 "3 - Personal / Family-related" ///
				*					4 "4 - Does not need/want to work" 5 "5 - Not elsewhere classified"
				lab val ilo_olf_reason reasons_lab 
				lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seeker ('ilo_dis')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment:
		
	gen ilo_dis=1 if ilo_lfs==3 & c22==1 & ilo_olf_reason==1
			lab def dis_lab 1 "Discouraged job-seekers"
			lab val ilo_dis dis_lab
			lab var ilo_dis "Discouraged job-seekers"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training ('ilo_neet') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment: Not possible to compute since educational attendance is not available

***********************************************************************************************
***********************************************************************************************

*			3. SAVE ILO-VARIABLES IN A NEW DATASET

***********************************************************************************************
***********************************************************************************************


* -------------------------------------------------------------
* 	Prepare final datasets
* -------------------------------------------------------------

* -------------------------------------------------------------
* 	Prepare final datasets
* -------------------------------------------------------------


cd "$outpath"
        
		/*Categories from temporal file deleted */
		drop if lab==1 
		
		/*Variables created to keep annual or quarter information are dropped*/
		drop to_drop to_drop_1 to_drop_2 year_ quarter_ quarter
		
		/*Only age bands used*/
		drop ilo_age 
		
		/*Variables computed in-between*/
		drop lab isco08_2digits isco88_2digits isco08 isco88 isic4_2digits isic4 isic3_2digits isic3 isic2dig isic2dig_job2 occup_1dig occup_1dig_job2
		drop social_security registration wage other_payments wage2 other_payments2 indu_code_une_2dig prev_occup
		
		compress 
		
	   /*Save dataset including original and ilo variables*/
	
		save ${country}_${source}_${time}_FULL,  replace		
	
	  /* Save file only containing ilo_* variables*/
	
		keep ilo*

		save ${country}_${source}_${time}_ILO, replace

	
	
	
