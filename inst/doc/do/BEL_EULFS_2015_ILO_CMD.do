* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Belgium
* DATASET USED: Belgium - EU Labour Force Survey
* NOTES:
* Authors: DPAU
* Who last updated the file: DPAU 
* Starting Date: 10 August 2017
* Last updated: 10 August 2017
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
global country "BEL"
global source "EULFS"
global time "2015"
global inputFile "BEL_EULFS_2015_YearlyFiles"
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
	rename *, upper  


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

   gen ilo_wgt=.
       replace ilo_wgt = COEFF
               lab var ilo_wgt "Sample weight"	


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

	gen ilo_geo = .
		replace ilo_geo = 1 if (DEGURBA == 1 | DEGURBA == 2)
		replace ilo_geo = 1 if (DEGURBA == 3 )
		lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural"
		lab val ilo_geo ilo_geo_lab
		lab var ilo_geo "Geographical coverage"	


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_sex= SEX
		lab def ilo_sex_lab 1 "1 - Male" 2 "2 - Female"
		lab var ilo_sex "Sex"
		lab val ilo_sex ilo_sex_lab

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_age= AGE
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

* Comment: completed level of education always to be considered!
		
* before 2014 ISCED 97 after ISCED 11:
decode ilo_time, gen(todrop)
split todrop, generate(todrop_) parse(Q)
destring todrop_1, replace force
local Y = todrop_1 in 1

if `Y' > 2013 {				
	gen ilo_edu_isced11=.															// No schooling
		replace ilo_edu_isced11=2 if HAT11LEV=="000"								// Early childhood education
		replace ilo_edu_isced11=3 if HAT11LEV=="100" 								// Primary education
		replace ilo_edu_isced11=4 if HAT11LEV=="200" 								// Lower secondary education
		replace ilo_edu_isced11=5 if inlist(HAT11LEV,"300", "302", "303", "304")	// Upper secondary education
		replace ilo_edu_isced11=6 if HAT11LEV=="400" 								// Post-secondary non-tertiary education
		replace ilo_edu_isced11=7 if HAT11LEV=="500" 								// Short-cycle tertiary education
		replace ilo_edu_isced11=8 if  HAT11LEV=="600" 								// Bachelor's or equivalent level
		replace ilo_edu_isced11=9 if HAT11LEV=="700" 								// Master's or equivalent level
		replace ilo_edu_isced11=10 if HAT11LEV=="800" 								// Doctoral or equivalent level 
		replace ilo_edu_isced11=11 if HAT11LEV=="999" 								// Not elsewhere classified
		replace ilo_edu_isced11=11 if ilo_edu_isced11==.
			label def isced_11_lab 1 "X - No schooling" 2 "0 - Early childhood education" 3 "1 - Primary education" 4 "2 - Lower secondary education" 5 "3 - Upper secondary education" ///
									6 "4 - Post-secondary non-tertiary education" 7 "5 - Short-cycle tertiary education" 8 "6 - Bachelor's or equivalent level" 9 "7 - Master's or equivalent level" ///
									10 "8 - Doctoral or equivalent level" 11 "9 - Not elsewhere classified"
			label val ilo_edu_isced11 isced_11_lab
			lab var ilo_edu_isced11 "Education (ISCED 11)"
		
		* for the definition, cf. the document "Guide to reporting labour statistics to the ILO using the Excel questionnaire"
		
	gen ilo_edu_aggregate=.
		replace ilo_edu_aggregate=1 if inlist(ilo_edu_isced11,1,2)					// Less than basic
		replace ilo_edu_aggregate=2 if inlist(ilo_edu_isced11,3,4)					// Basic
		replace ilo_edu_aggregate=3 if inlist(ilo_edu_isced11,5,6)					// Intermediate
		replace ilo_edu_aggregate=4 if inlist(ilo_edu_isced11,7,8,9,10)				// Advanced
		replace ilo_edu_aggregate=5 if ilo_edu_isced11==11							// Level not stated
			label def edu_aggr_lab 1 "1 - Less than basic" 2 "2 - Basic" 3 "3 - Intermediate" 4 "4 - Advanced" 5 "5 - Level not stated"
			label val ilo_edu_aggregate edu_aggr_lab
			label var ilo_edu_aggregate "Education (Aggregate level)"
}
			
			
			
			
if `Y' < 2014 {

	gen ilo_edu_isced97=.															// X - No schooling			
		replace ilo_edu_isced97=2 if inlist(HAT97LEV,"00", "10")					// 0 - Pre-primary education
		replace ilo_edu_isced97=3 if HAT97LEV=="11"									// 1 - Primary education or first stage of basic education	
		replace ilo_edu_isced97=4 if HAT97LEV=="21"									// 2 - Lower secondary or second stage of basic education	
		replace ilo_edu_isced97=5 if inlist(HAT97LEV,"22", "30", "31", "32", "33", "34", "35", "36") 	// 3 - Upper secondary education
		replace ilo_edu_isced97=6 if inlist(HAT97LEV,"41", "42", "43")				// 4 - Post-secondary non-tertiary education
		replace ilo_edu_isced97=7 if inlist(HAT97LEV,"51", "52")					// 5 - First stage of tertiary education
		replace ilo_edu_isced97=8 if HAT97LEV=="60"									// 6 - Second stage of tertiary education
		replace ilo_edu_isced97=9 if HAT97LEV=="99"									// UNK - Level not stated
		replace ilo_edu_isced97=9 if ilo_edu_isced97==.
			label def isced_97_lab 1 "X - No schooling" 2 "0 - Pre-primary education" 3 "1 - Primary education or first stage of basic education" 4 "2 - Lower secondary education or second stage of basic education" ///
							5 "3 - Upper secondary education" 6 "4 - Post-secondary non-tertiary education" 7 "5 - First stage of tertiary education (not leading directly to an advanced research qualification)" ///
							8 "6 - Second stage of tertiary education (leading to an advanced research qualification)" 9 "UNK - Level not stated"
			label val ilo_edu_isced97 isced_97_lab
			lab var ilo_edu_isced97 "Level of education (ISCED 97)"

	* for the definition, cf. the document "Guide to reporting labour statistics to the ILO using the Excel questionnaire"
	
	gen ilo_edu_aggregate=.
		replace ilo_edu_aggregate=1 if inlist(ilo_edu_isced97,1,2)
		replace ilo_edu_aggregate=2 if inlist(ilo_edu_isced97,3,4)
		replace ilo_edu_aggregate=3 if inlist(ilo_edu_isced97,5,6)
		replace ilo_edu_aggregate=4 if inlist(ilo_edu_isced97,7,8)
		replace ilo_edu_aggregate=5 if ilo_edu_isced97==9
			label def edu_aggr_lab 1 "1 - Less than basic" 2 "2 - Basic" 3 "3 - Intermediate" 4 "4 - Advanced" 5 "5 - Level not stated"
			label val ilo_edu_aggregate edu_aggr_lab
			label var ilo_edu_aggregate "Level of education (Aggregate levels)"

}			
			
			
			
			
drop todrop*
local Y
local Q
				
			
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education attendance ('ilo_edu_attendance')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* from 2003 onwards

decode ilo_time, gen(todrop)
split todrop, generate(todrop_) parse(Q)
destring todrop_1, replace force
local Y = todrop_1 in 1

if `Y' > 2003 {	
          gen ilo_edu_attendance=.
				replace ilo_edu_attendance=1 if EDUCSTAT==2 | COURATT==2
				replace ilo_edu_attendance=2 if ilo_edu_attendance ==.
				replace ilo_edu_attendance=3 if EDUCSTAT == . & COURATT == .
				lab def edu_attendance_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
				lab val ilo_edu_attendance edu_attendance_lab
				lab var ilo_edu_attendance "Education (Attendance)"
               
}
drop todrop*
local Y
local Q
			
	
	
		
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Disability status ('ilo_dsb')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

* Comment: severale variables, to be confirm: search 'disability' on UserGuide


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

* Comment: Directly based on labour status variable. We can't check if Employment and Unemployment are defined following international standards.

	gen ilo_lfs=.
	    replace ilo_lfs=1 if inlist(ILOSTAT,1, 4)	         		// Employed
		replace ilo_lfs=2 if ILOSTAT==2 						    // Unemployed 
		replace ilo_lfs=3 if ILOSTAT==3 & ilo_wap==1      			// Outside the labour force
		    label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside the Labour Force"
			label value ilo_lfs label_ilo_lfs
			label var ilo_lfs "Labour Force Status"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

    gen ilo_mjh=.
		replace ilo_mjh=1 if (EXIST2J==1 | EXIST2J == .) & ilo_lfs==1								// 1 - One job only
		replace ilo_mjh=2 if (EXIST2J == 2 & ilo_lfs==1)											// 2- More than one job
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

* Comment: As we have no further information, "non-paid employees" are considered as contributing family workers
* due to anonymised microdata STATPRO is reduce to 0349
/*
	* Detailed categories:
		gen ilo_job1_ste_icse93=.
			replace ilo_job1_ste_icse93=1 if (STAPRO==3 & ilo_lfs==1)   		    // Employees
			replace ilo_job1_ste_icse93=2 if (STAPRO==1 & ilo_lfs==1)	            // Employers
			replace ilo_job1_ste_icse93=3 if (STAPRO==2 & ilo_lfs==1)      			// Own-account workers
			* replace ilo_job1_ste_icse93=4                                         // Members of producers’ cooperatives
			replace ilo_job1_ste_icse93=5 if (STAPRO==4 & ilo_lfs==1)	            // Contributing family workers
			replace ilo_job1_ste_icse93=6 if (ilo_job1_ste_icse93==. & ilo_lfs==1)  // Not classifiable
				label def label_ilo_ste_icse93 1 "1 - Employees" 2 "2 - Employers" 3 "3 - Own-account workers" ///                      
											   4 "4 - Members of producers cooperatives" 5 "5 - Contributing family workers" ///
											   6 "6 - Workers not classifiable by status"
				label val ilo_job1_ste_icse93 label_ilo_ste_icse93
				label var ilo_job1_ste_icse93 "Status in employment (ICSE 93)"
*/
	* Aggregate categories 
		gen ilo_job1_ste_aggregate=.
			replace ilo_job1_ste_aggregate=1 if (STAPRO==3 & ilo_lfs==1)			// Employees
			replace ilo_job1_ste_aggregate=2 if (inlist(STAPRO,0,4) & ilo_lfs==1)	// Self-employed
			replace ilo_job1_ste_aggregate=3 if (STAPRO==9 & ilo_lfs==1)			// Not elsewhere classified
			replace ilo_job1_ste_aggregate=3 if (STAPRO==. & ilo_lfs==1)
				lab def ste_aggr_lab 1 "1 - Employees" 2 "2 - Self-employed" 3 "3 - Not elsewhere classified"
				lab val ilo_job1_ste_aggregate ste_aggr_lab
				label var ilo_job1_ste_aggregate "Status in employment (Aggregate)"  

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: Only aggregated level of classification is available
						
		* Aggregate level
		gen ilo_job1_eco_aggregate=.
			replace ilo_job1_eco_aggregate=1 if industry==1 & ilo_lfs==1
			replace ilo_job1_eco_aggregate=2 if industry==3 & ilo_lfs==1
			replace ilo_job1_eco_aggregate=3 if industry==5 & ilo_lfs==1
			replace ilo_job1_eco_aggregate=4 if industry==2 & ilo_lfs==1
			replace ilo_job1_eco_aggregate=5 if inlist(industry,6,7,8) & ilo_lfs==1
			replace ilo_job1_eco_aggregate=6 if inlist(industry,4,9) & ilo_lfs==1
			replace ilo_job1_eco_aggregate=7 if industry==10 & ilo_lfs==1
			replace ilo_job1_eco_aggregate=7 if ilo_job1_eco_aggregate==. & ilo_lfs==1
				lab def eco_aggr_lab 1 "1 - Agriculture" 2 "2 - Manufacturing" 3 "3 - Construction" 4 "4 - Mining and quarrying; Electricity, gas and water supply" ///
									 5 "5 - Market Services (Trade; Transportation; Accommodation and food; and Business and administrative services)"  ///
									 6 "6 - Non-market services (Public administration; Community, social and other services and activities)" 7 "7 - Not classifiable by economic activity"					
				lab val ilo_job1_eco_aggregate eco_aggr_lab
				lab var ilo_job1_eco_aggregate "Economic activity (Aggregate)"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_job1_ocu_isco08')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
		
		* ISCO 08 - 1 digit
		gen ilo_job1_ocu_isco08=.
			replace ilo_job1_ocu_isco08=1 if occup==1 & ilo_lfs==1
			replace ilo_job1_ocu_isco08=2 if occup==2 & ilo_lfs==1	
			replace ilo_job1_ocu_isco08=3 if occup==3 & ilo_lfs==1
			replace ilo_job1_ocu_isco08=4 if occup==4 & ilo_lfs==1
			replace ilo_job1_ocu_isco08=5 if occup==5 & ilo_lfs==1
			replace ilo_job1_ocu_isco08=6 if occup==6 & ilo_lfs==1
			replace ilo_job1_ocu_isco08=7 if occup==7 & ilo_lfs==1
			replace ilo_job1_ocu_isco08=8 if occup==8 & ilo_lfs==1
			replace ilo_job1_ocu_isco08=9 if occup==9 & ilo_lfs==1
			replace ilo_job1_ocu_isco08=10 if occup==10 & ilo_lfs==1
			replace ilo_job1_ocu_isco08=11 if occup==. & ilo_lfs==1
				lab def isco08_1dig_lab 1 "1 - Managers" 2 "2 - Professionals" 3 "Technicians and associate professionals" 4 "4 - Clerical support workers" 5 "5 - Service and sales workers" ///
										6 "6 - Skilled agricultural, forestry and fishery workers" 7 "7 - Craft and related trades workers" 8 "8 - Plant and machine operators, and assemblers" ///
										9 "9 - Elementary occupations" 10 "0 - Armed forces occupations" 11 "X - Not elsewhere classified"
				lab val ilo_job1_ocu_isco08 isco08_1dig_lab
				lab var ilo_job1_ocu_isco08 "Occupation (ISCO-08)"	
		
	  * Aggregate
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
				  lab var ilo_job1_ocu_aggregate "Occupation (Aggregate)"	
		
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
*			Institutional sector of economic activities ('ilo_job1_ins_sector')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

		gen ilo_job1_ins_sector=.
			replace ilo_job1_ins_sector=1 if (ocusec==1 & ilo_lfs==1)	// Public
			replace ilo_job1_ins_sector=2 if (ocusec==2 & ilo_lfs==1)   // Private
			replace ilo_job1_ins_sector=2 if (ocusec==. & ilo_lfs==1) 	// Force missing into private
				lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
			    lab values ilo_job1_ins_sector ins_sector_lab
			    lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job1_job_time')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			

* Comment: No information				

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Hours of work ('ilo_job1_how')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

* Comment: Information only for hours actually worked in total

   * Weekly hours ACTUALLY worked in all jobs
		gen ilo_joball_how_actual=whours if ilo_lfs==1
			replace ilo_joball_how_actual=0 if (ilo_joball_how_actual==. & ilo_lfs==1)
				lab var ilo_joball_how_actual "Weekly hours actually worked in all jobs"	      

		gen ilo_joball_how_actual_bands=.
			 replace ilo_joball_how_actual_bands=1 if ilo_joball_how_actual==0
			 replace ilo_joball_how_actual_bands=2 if inrange(ilo_joball_how_actual,1,14)
			 replace ilo_joball_how_actual_bands=3 if inrange(ilo_joball_how_actual,15,29)
			 replace ilo_joball_how_actual_bands=4 if inrange(ilo_joball_how_actual,30,34)
			 replace ilo_joball_how_actual_bands=5 if inrange(ilo_joball_how_actual,35,39)
			 replace ilo_joball_how_actual_bands=6 if inrange(ilo_joball_how_actual,40,48)
			 replace ilo_joball_how_actual_bands=7 if ilo_joball_how_actual>=49 & ilo_joball_how_actual!=.
				    lab def how_act_bands_lab 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+"
					lab val ilo_joball_how_actual_bands how_act_bands_lab
					lab var ilo_joball_how_actual_bands "Weekly hours actually worked bands in all jobs"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job1_job_contract')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

* Comment: No information

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Formal / Informal Economy ('ilo_job1_ife_prod' 'ilo_job1_ife_nature')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			

* Comment: Not enough information to define informal employment / informal sector	
	
    /* Useful questions:
				* Institutional sector: Not asked - Proxy: ocusec
				* Destination of production: Not asked
				* Bookkeeping: Not asked
				* Registration: Not asked
				* Status in employment: empstat
				* Social security contribution: socialsec
				* Place of work: Not asked
				* Size: Not asked
				* Paid annual leave: Not asked 
				* Paid sick leave: Not asked - Proxy: healthins
	*/
	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Monthly labour related income ('ilo_joball_lri')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
		
	* Employees
		gen ilo_job1_lri_ees=.
			replace ilo_job1_lri_ees=wage*365/12 if (unitwage==1 & ilo_job1_ste_aggregate==1)
			replace ilo_job1_lri_ees=wage*52/12 if (unitwage==2 & ilo_job1_ste_aggregate==1)
			replace ilo_job1_lri_ees=wage*26/12 if (unitwage==3 & ilo_job1_ste_aggregate==1)
			replace ilo_job1_lri_ees=wage if (unitwage==5 & ilo_job1_ste_aggregate==1)
			replace ilo_job1_lri_ees=wage/3 if (unitwage==6 & ilo_job1_ste_aggregate==1)
			replace ilo_job1_lri_ees=wage/12 if (unitwage==8 & ilo_job1_ste_aggregate==1)
					lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"	
				
	* Self-employed
		gen ilo_job1_lri_slf=.
			replace ilo_job1_lri_slf=wage*365/12 if (unitwage==1 & inlist(ilo_job1_ste_icse93,2,3,4,6))
			replace ilo_job1_lri_slf=wage*52/12 if (unitwage==2 & inlist(ilo_job1_ste_icse93,2,3,4,6))
			replace ilo_job1_lri_slf=wage*26/12 if (unitwage==3 & inlist(ilo_job1_ste_icse93,2,3,4,6))
			replace ilo_job1_lri_slf=wage if (unitwage==5 & inlist(ilo_job1_ste_icse93,2,3,4,6))
			replace ilo_job1_lri_slf=wage/3 if (unitwage==6 & inlist(ilo_job1_ste_icse93,2,3,4,6))
			replace ilo_job1_lri_slf=wage/12 if (unitwage==8 & inlist(ilo_job1_ste_icse93,2,3,4,6))
		
			replace ilo_job1_lri_slf=wage if (inlist(ilo_job1_ste_icse93,2,3,4,6))
					lab var ilo_job1_lri_slf "Monthly earnings of self-employed in main job"



***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_joball_tru')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

* Comment: No information

*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Cases of non-fatal occupational injury ('ilo_joball_oi_case')
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------

* Comment: No information

*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Days lost due to cases of occupational injury ('ilo_joball_oi_day')
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------

* Comment: No information


***********************************************************************************************
*			PART 3.3. UNEMPLOYMENT: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Category of unemployment ('ilo_cat_une')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: No information

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: 

    * Detailed
		gen ilo_dur_details=.
			replace ilo_dur_details=1 if (unempldur_l==0 & ilo_lfs==2)                  // Less than 1 month
			replace ilo_dur_details=2 if (inlist(unempldur_l,1,2) & ilo_lfs==2)         // 1-2 months
			replace ilo_dur_details=3 if (inlist(unempldur_l,3,4) & ilo_lfs==2)         // 3-5 months
			replace ilo_dur_details=4 if (unempldur_l==8 & ilo_lfs==2)                  // 6-11 months
			replace ilo_dur_details=7 if (ilo_dur_details==.& ilo_lfs==2)   			// Not elsewhere classified
			        lab def ilo_unemp_det 1 "Less than 1 month" 2 "1 month to less than 3 months" 3 "3 months to less than 6 months" ///
										  4 "6 months to less than 12 months" 5 "12 months to less than 24 months" 6 "24 months or more" ///
										  7 "Not elsewhere classified"
				    lab val ilo_dur_details ilo_unemp_det
				    lab var ilo_dur_details "Duration of unemployment (Details)"

    * Aggregate						
		gen ilo_dur_aggregate=.
			replace ilo_dur_aggregate=1 if (inlist(ilo_dur_details,1,2,3) & ilo_lfs==2)   	// Less than 6 months
			replace ilo_dur_aggregate=2 if (ilo_dur_details==4 & ilo_lfs==2)              	// 6 months to less than 12 months
			replace ilo_dur_aggregate=3 if (inlist(ilo_dur_details,5,6) & ilo_lfs==2)       // 12 months or more
			replace ilo_dur_aggregate=4 if ilo_dur_details==7 & ilo_lfs==2                  // Not elsewhere classified
					lab def ilo_unemp_aggr 1 "Less than 6 months" 2 "6 months to less than 12 months" 3 "12 months or more" 4 "Not elsewhere classified"
					lab val ilo_dur_aggregate ilo_unemp_aggr
					lab var ilo_dur_aggregate "Duration of unemployment (Aggregate)"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

* Comment: No information
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

* Comment: No information


***********************************************************************************************
*			PART 3.4. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		.

* Comment: No information

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reason for not seeking job ('ilo_olf_reason')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

* Comment: No information
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seeker ('ilo_dis')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

* Comment: No information

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

cd "$outpath"
		
		/* Only age bands used */
		drop ilo_age
		drop if ilo_sex==. 
		
		compress 
		
		/*Save dataset including original and ilo variables*/
	
		save ${country}_${source}_${time}_FULL,  replace		

		/* Save file only containing ilo_* variables*/
	
		keep ilo*

		save ${country}_${source}_${time}_ILO, replace
