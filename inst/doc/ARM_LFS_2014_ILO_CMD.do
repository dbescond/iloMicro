* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Armenia, 2014
* DATASET USED: Armenia LFS 2014
* NOTES:
* Authors: Mabelin Villarreal Fuentes
* Who last updated the file: Mabelin Villarreal Fuentes 
* Starting Date: 14 February 2017
* Last updated: 12 May 2017
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
global country "ARM"
global source "LFS"
global time "2014"
global inputFile "LFS_Micro data 2014"


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
*			Time period ('ilo_time')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	* Year 2014
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
*			Sample Weight depending Annual/Quarter ('ilo_wgt')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

*-- generates variable "to_drop" that will be split in two parts: annual part (to_drop) and quarter part (to_drop_1)
   decode ilo_time, gen(to_drop)
   split to_drop, generate(to_drop_) parse(Q)
   destring to_drop_1, replace force

*-- generation of to_drop_2 that contains information on the quarter (if it is quarterly) or -9999 if its annual
   capture destring to_drop_2, replace force
   capture gen to_drop_2=-9999
   local Q = to_drop_2 in 1
   
*-- captures the year
   local A "year_"
   gen `A'= to_drop_1
 
*-- weights and observations used depending on the quarter/year frequency to be analized
*-- there's a mispelling error -> replace weights names

if `A'==2014{
rename weigths_year weights_year
rename weights_1 weights_1
rename weights_2 weights_2
rename weights_3 weights_3
rename weigths_4 weights_4 
}

*-- annual

	gen ilo_wgt=weights_year if to_drop_2==-9999
		lab var ilo_wgt "Sample weight"		

*-- quarter_1                
    if `Q' == 1 {
	    replace ilo_wgt = weights_`Q'
		lab var ilo_wgt "Sample weight"	
		keep if inrange(a6_month,1,3)
}

*-- quarter_2                
    if `Q' == 2 {
	    replace ilo_wgt = weights_`Q'
		lab var ilo_wgt "Sample weight"	
		keep if inrange(a6_month,4,6)
}

*-- quarter_3                
    if `Q' == 3 {
	    replace ilo_wgt = weights_`Q'
		lab var ilo_wgt "Sample weight"	
		keep if inrange(a6_month,7,9)
}

*-- quarter_4                
    if `Q' == 4 {
	    replace ilo_wgt = weights_`Q'
		lab var ilo_wgt "Sample weight"	
		keep if inrange(a6_month,10,12)
}

*---- In 2015Q3 there's one observation without weight => delete observation

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
		replace ilo_geo=1 if a5==1
		replace ilo_geo=2 if a5==2
			lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural"
			lab val ilo_geo ilo_geo_lab
			lab var ilo_geo "Geographical coverage"	

			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_sex=b11
		lab def ilo_sex_lab 1 "1 - Male" 2 "2 - Female"
		lab var ilo_sex "Sex"
		lab val ilo_sex ilo_sex_lab


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

/*---Three observations with Age == -1 => the value was replaced by Age==0 because they were
not borned at the moment of the interview but at the end of the year 2014, yes ---*/

	gen ilo_age=age
	    replace ilo_age=0 if ilo_age==-1
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
		
/* ISCED 97 mapping: based on the mapping developed by UNESCO
					http://www.http://uis.unesco.org/en/isced-mappings 	*/

* The Educational Level is considered.

	gen ilo_edu_isced97=.
		replace ilo_edu_isced97=1 if b15==1  					// No schooling
		replace ilo_edu_isced97=2 if b15==2 					// Pre-primary education
		replace ilo_edu_isced97=3 if b15==3  		            // Primary education or first stage of basic education
		replace ilo_edu_isced97=4 if b15==4  		            // Lower secondary or second stage of basic education
		replace ilo_edu_isced97=5 if b15==5            		    // Upper secondary education
		replace ilo_edu_isced97=6 if inrange(b15,6,7)        	// Post-secondary non-tertiary education
		replace ilo_edu_isced97=7 if b15==8 			        // First stage of tertiary education (not leading directly to an advanced research qualification)
		replace ilo_edu_isced97=8 if b15==9     				// Second stage of tertiary education (leading to an advanced research qualification)
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
*			Education attendance ('ilo_edu_attendance') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: The only question regarding education asked to the entire population (before employment/
*          unemployment chapters) is B15: "Educational level". No related to current attendance.

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Disability status ('ilo_dsb') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
				
	gen ilo_dsb_aggregate=.
		replace ilo_dsb_aggregate=1 if (b20!=1)
		replace ilo_dsb_aggregate=2 if (b20==1)
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

/*ilo_wap follows the existent variable "Labour resources - working age population" from the 
original database. According to the methodology, it comprises all persons aged between 15 and 
75 (inclusive), who usually live in the household or are absent from household up to 3 months
(within the country or abroad), and those who are in the army (mandatory).*/

	gen ilo_wap=.
		if to_drop_1==2014{
	replace ilo_wap=1 if (lr_wap==1)
	}
	else {
	replace ilo_wap=1 if (lra==1)
	}
			lab def wap_lab 1 "Working age population"
			lab val ilo_wap wap_lab
			label var ilo_wap "Working age population"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Labour Force Status ('ilo_lfs')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

/*ilo_lfs: employment includes employed and employed people temporary absent; unemployment
follows the ILO definition of unemployment: a) people without without work during the reference
period, b) people currently available for work, and c) seeking work */


    gen ilo_lfs=.
	    replace ilo_lfs=1 if (g1==1 & ilo_wap==1)                                        //Employed
		replace ilo_lfs=1 if ((inlist(g3, 1,2,3,4,5) | inlist(g4,1,2)) & ilo_wap==1)     //Employed (Temporary absent) 
		replace ilo_lfs=2 if (inlist(z57,1,2) & z65==1 & ilo_wap==1)                     //Unemployed
		replace ilo_lfs=3 if (!inlist(ilo_lfs,1,2) & ilo_wap==1)                         //Outside the labour force
		        label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside the Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status"
		  
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

/*when comparing with the existent variable emsj, there are two observations with emsj==1 but E24==2*/

	gen ilo_mjh=.
		replace ilo_mjh=1 if (e24==2 & ilo_lfs==1)
		replace ilo_mjh=2 if (e24==1 & ilo_lfs==1)
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
			replace ilo_job1_ste_icse93=1 if (inlist(d8,1,2) & ilo_lfs==1)		// Employees
			replace ilo_job1_ste_icse93=2 if (d8==3 & ilo_lfs==1)		        // Employers
			replace ilo_job1_ste_icse93=3 if (inlist(d8,4,5) & ilo_lfs==1)		// Own-account workers
			replace ilo_job1_ste_icse93=4 if (d8==7 & ilo_lfs==1)               // Producer cooperatives
			replace ilo_job1_ste_icse93=5 if (d8==6 & ilo_lfs==1)       		// Contributing family workers
			replace ilo_job1_ste_icse93=6 if (d8==8 & ilo_lfs==1)       		// Not classifiable

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
			replace ilo_job2_ste_icse93=1 if (inlist(e27,1,2) & ilo_mjh==2)		// Employees
			replace ilo_job2_ste_icse93=2 if (e27==3 & ilo_mjh==2)      		// Employers
			replace ilo_job2_ste_icse93=3 if (inlist(e27,4,5) & ilo_mjh==2)		// Own-account workers
			replace ilo_job2_ste_icse93=4 if (e27==7 & ilo_mjh==2)      		// Producer cooperatives
			replace ilo_job2_ste_icse93=5 if (e27==6 & ilo_mjh==2)      		// Contributing family workers
			replace ilo_job2_ste_icse93=6 if (e27==8 & ilo_mjh==2)          	// Not classifiable
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

/*Original classification: NACE Rev.2 one digit level
Correspondences between NACE Rev. and ISIC Rev. 4 are one to one*/
		
		* Import value labels

		append using `labels', gen (lab)
		* Use value label from this variable, afterwards drop everything related to this append
			
		* MAIN JOB
		
		gen ilo_job1_eco_isic4=d6_21group
		
			lab val ilo_job1_eco_isic4 isic4
			lab var ilo_job1_eco_isic4 "Economic activity (ISIC Rev. 4)"
			
		* SECOND JOB
		
		gen ilo_job2_eco_isic4=e26_21group
		
			lab val ilo_job1_eco_isic4 isic4
			lab var ilo_job2_eco_isic4 "Economic activity (ISIC Rev. 4) in secondary job"
					
		
	* Classification aggregated level
	
		* MAIN JOB
		
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

		* SECOND JOB
		
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
	
	/* Classification used: ISCO_08 */

	* MAIN JOB:	
	
		* ISCO 08 - 1 digit
			gen ilo_job1_ocu_isco08=d5_9group if ilo_lfs==1
				lab val ilo_job1_ocu_isco08 isco08
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

	* SECOND JOB:

		* ISCO 08 - 1 digit
			gen ilo_job2_ocu_isco08=e25_9group if ilo_lfs==1
			    lab val ilo_job2_ocu_isco08 isco08
				lab var ilo_job2_ocu_isco08 "Occupation (ISCO-08) in secondary job"
		
		* Aggregate:			
			gen ilo_job2_ocu_aggregate=.
				replace ilo_job2_ocu_aggregate=1 if inrange(ilo_job2_ocu_isco08,1,3)
				replace ilo_job2_ocu_aggregate=2 if inlist(ilo_job2_ocu_isco08,4,5)
				replace ilo_job2_ocu_aggregate=3 if inlist(ilo_job2_ocu_isco08,6,7)
				replace ilo_job2_ocu_aggregate=4 if ilo_job2_ocu_isco08==8
				replace ilo_job2_ocu_aggregate=5 if ilo_job2_ocu_isco08==9
				replace ilo_job2_ocu_aggregate=6 if ilo_job2_ocu_isco08==10
				replace ilo_job2_ocu_aggregate=7 if ilo_job2_ocu_isco08==11
				    * value label already defined for the main job
					lab val ilo_job2_ocu_aggregate ocu_aggr_lab
					lab var ilo_job2_ocu_aggregate "Occupation (Aggregate) in secondary job"
		
		* Skill level
		    gen ilo_job2_ocu_skill=.
			    replace ilo_job2_ocu_skill=1 if ilo_job2_ocu_isco08==9                   // Low
				replace ilo_job2_ocu_skill=2 if inlist(ilo_job2_ocu_isco08,4,5,6,7,8)    // Medium
				replace ilo_job2_ocu_skill=3 if inlist(ilo_job2_ocu_isco08,1,2,3)        // High
				replace ilo_job2_ocu_skill=4 if inlist(ilo_job2_ocu_isco08,10,11)        // Not elsewhere classified
				    * value label already defined for the main job
					lab val ilo_job2_ocu_skill ocu_skill_lab
				    lab var ilo_job2_ocu_skill "Occupation (Skill level) in secondary job"
	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_job1_ins_sector')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
	
	/* Non-governmental organizations/religius organizations/representative office of an 
	international organization under private*/
	
	  * MAIN JOB
	
		gen ilo_job1_ins_sector=.
			replace ilo_job1_ins_sector=1 if (d11==1 & ilo_lfs==1)	            // Public
			replace ilo_job1_ins_sector=2 if (inrange(d11,2,4) & ilo_lfs==1)	// Private
				lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
			    lab values ilo_job1_ins_sector ins_sector_lab
			    lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities"
		 
	 * SECOND JOB
	
		gen ilo_job2_ins_sector=.
			replace ilo_job2_ins_sector=1 if (e29==1 & ilo_lfs==1)	            // Public
			replace ilo_job2_ins_sector=2 if (inrange(e29,2,4) & ilo_lfs==1)	// Private
			    * value label already defined for the main job
				lab values ilo_job2_ins_sector ins_sector_lab
				lab var ilo_job2_ins_sector "Institutional sector (private/public) of economic activities in secondary job"


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job1_job_time')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			

	/* Measurement based on a self-assessment question. Not computed for secondary job, since
	by definition it is part-time*/

			gen ilo_job1_job_time=.
				replace ilo_job1_job_time=1 if (d21==3 & ilo_lfs==1) 	        // Part-time
				replace ilo_job1_job_time=2 if (inlist(d21,1,2) & ilo_lfs==1)	// Full-time
					lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 
					lab val ilo_job1_job_time job_time_lab
					lab var ilo_job1_job_time "Job (Working time arrangement)"				
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job1_job_contract')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

    /* Temporary, seasonal and casual (one-time) are under Temporary		
	   Comment: variable only defined for main job, as question on the nature of the contract
	        	is not being asked for secondary job
	*/
		
			gen ilo_job1_job_contract=.
			    replace ilo_job1_job_contract=1 if (d18==1 & ilo_job1_ste_aggregate==1)                        //Permanent
				replace ilo_job1_job_contract=2 if (inlist(d18,2,3,4) & ilo_job1_ste_aggregate==1)             //Temporary
				replace ilo_job1_job_contract=3 if (ilo_job1_job_contract==. & ilo_job1_ste_aggregate==1)      //Unknown
					lab def job_contract_lab 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"
					lab val ilo_job1_job_contract job_contract_lab
					lab var ilo_job1_job_contract "Job (Type of contract)"

		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Formal / Informal Economy ('ilo_job1_ife_prod' 'ilo_job1_ife_nature')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
		
	/* Useful questions:
				* D11: Institutional sector (raw question)
				* D9_#: Benefits/guarantees do you received at your workplace
				* D10: Business legally registered - registration
				* D12: Legal status of your workplace
				* D13: Production of goods or services - destination */
	
	* ONLY FOR MAIN JOB.
	
	* Social security (to be dropped afterwards)
	
	        gen social_security=.
			    replace social_security=1 if (d9_6==1 & ilo_lfs==1)                                          // Medical insurance provided by the employer
				replace social_security=2 if (d9_6==2 & ilo_lfs==1)                                          // No medical insurance provided by the employer
				replace social_security=1 if (inlist(social_security,2,.) & d9_1==1 & d9_3==1 & ilo_lfs==1)  // Paid leave and Paid sick leave 
				replace social_security=2 if (inlist(social_security,2,.) & (d9_1==2 | d9_3==2) & ilo_lfs==1)  // No (paid leave and paid sick leave)
				replace social_security=3 if (social_security==. & ilo_job1_ste_icse93==1)                   // It's difficult to answer
	
	* UNIT OF PRODUCTION: FORMAL/INFORMAL SECTOR		
    			
			gen ilo_job1_ife_prod=.
				replace ilo_job1_ife_prod=2 if inlist(d11,1,2) | (inlist(d11,3,.) & d13!=1 & inlist(d10,1)) | (inlist(d11,3,.) & d13!=1 & inlist(d10,5,.) & ilo_job1_ste_icse93==1 & social_security==1) 
				replace ilo_job1_ife_prod=3 if d11==4 | (inlist(d11,3,.) & d13==1)           
				replace ilo_job1_ife_prod=1 if (ilo_job1_ife_prod==. & ilo_lfs==1)           
				        lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 
						lab val ilo_job1_ife_prod ilo_ife_prod_lab
						lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"
						
						
						 
	* 2) NATURE OF JOB: FORMAL/INFORMAL EMPLOYMENT
	
			gen ilo_job1_ife_nature=.
		        replace ilo_job1_ife_nature=1 if ilo_job1_ste_icse93==5 | (inlist(ilo_job1_ste_icse93,1,6) & social_security!=1) | (inlist(ilo_job1_ste_icse93,2,3,4) & inlist(ilo_job1_ife_prod,1,3))
		        replace ilo_job1_ife_nature=2 if (inlist(ilo_job1_ste_icse93,1,6) & social_security==1) | (inlist(ilo_job1_ste_icse93,2,3,4) & ilo_job1_ife_prod==2)
		        replace ilo_job1_ife_nature=. if ilo_lfs!=1
			            lab def ife_nature_lab 1 "1 - Persons with informal main job" 2 "2 - Persons with formal main job"
			            lab val ilo_job1_ife_nature ife_nature_lab
			            lab var ilo_job1_ife_nature "Informal / Formal Economy (Nature of job)"												 
												 
            
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Hours of work ('ilo_job1_how')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

* MAIN JOB:
		
* 1) Weekly hours ACTUALLY worked
		
			gen ilo_job1_how_actual=e39_1 if (ilo_lfs==1)
					lab var ilo_job1_how_actual "Weekly hours actually worked in main job"

			gen ilo_job1_how_actual_bands=.
				replace ilo_job1_how_actual_bands=1 if ilo_job1_how_actual==0
				replace ilo_job1_how_actual_bands=2 if inrange(ilo_job1_how_actual,1,14)
				replace ilo_job1_how_actual_bands=3 if inrange(ilo_job1_how_actual,15,29)
				replace ilo_job1_how_actual_bands=4 if inrange(ilo_job1_how_actual,30,34)
				replace ilo_job1_how_actual_bands=5 if inrange(ilo_job1_how_actual,35,39)
				replace ilo_job1_how_actual_bands=6 if inrange(ilo_job1_how_actual,40,48)
				replace ilo_job1_how_actual_bands=7 if ilo_job1_how_actual>=49 & ilo_job1_how_actual!=.
					lab def how_act_bands_lab 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 
					lab val ilo_job1_how_actual_bands how_act_bands_lab
					lab var ilo_job1_how_actual_bands "Weekly hours actually worked bands in main job"
		
		
* 2) Weekly hours USUALLY worked

            gen ilo_job1_how_usual=e38_1 if (ilo_lfs==1)
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


* SECOND JOB:

* 1) Weekly hours ACTUALLY worked
		
			gen ilo_job2_how_actual=e39_2 if (ilo_lfs==1)
					lab var ilo_job2_how_actual "Weekly hours actually worked in second job"


			gen ilo_job2_how_actual_bands=.
				replace ilo_job2_how_actual_bands=1 if ilo_job2_how_actual==0
				replace ilo_job2_how_actual_bands=2 if inrange(ilo_job2_how_actual,1,14)
				replace ilo_job2_how_actual_bands=3 if inrange(ilo_job2_how_actual,15,29)
				replace ilo_job2_how_actual_bands=4 if inrange(ilo_job2_how_actual,30,34)
				replace ilo_job2_how_actual_bands=5 if inrange(ilo_job2_how_actual,35,39)
				replace ilo_job2_how_actual_bands=6 if inrange(ilo_job2_how_actual,40,48)
				replace ilo_job2_how_actual_bands=7 if ilo_job2_how_actual>=49 & ilo_job2_how_actual!=.
				    * value label already defined for the main job
					lab val ilo_job2_how_actual_bands how_act_bands_lab
					lab var ilo_job2_how_actual_bands "Weekly hours actually worked bands in second job"
		
		
* 2) Weekly hours USUALLY worked

            gen ilo_job2_how_usual=e38_2 if (ilo_lfs==1)
					lab var ilo_job2_how_usual "Weekly hours usually worked in second job"

			gen ilo_job2_how_usual_bands=.
				replace ilo_job2_how_usual_bands=1 if ilo_job2_how_usual==0
				replace ilo_job2_how_usual_bands=2 if inrange(ilo_job2_how_usual,1,14)
				replace ilo_job2_how_usual_bands=3 if inrange(ilo_job2_how_usual,15,29)
				replace ilo_job2_how_usual_bands=4 if inrange(ilo_job2_how_usual,30,34)
				replace ilo_job2_how_usual_bands=5 if inrange(ilo_job2_how_usual,35,39)
				replace ilo_job2_how_usual_bands=6 if inrange(ilo_job2_how_usual,40,48)
				replace ilo_job2_how_usual_bands=7 if ilo_job2_how_usual>=49 & ilo_job2_how_usual!=.
				    * value label already defined for the main job
					lab val ilo_job2_how_usual_bands how_usu_bands_lab
					lab var ilo_job2_how_usual_bands "Weekly hours usually worked bands in second job"

* ALL JOBS:
		
* 1) Weekly hours ACTUALLY worked:

			gen ilo_joball_how_actual=e39_3total if (ilo_lfs==1)  
					lab var ilo_joball_how_actual "Weekly hours actually worked in all jobs"

			gen ilo_joball_how_actual_bands=.
				replace ilo_joball_how_actual_bands=1 if ilo_joball_how_actual==0
				replace ilo_joball_how_actual_bands=2 if inrange(ilo_joball_how_actual,1,14)
				replace ilo_joball_how_actual_bands=3 if inrange(ilo_joball_how_actual,15,29)
				replace ilo_joball_how_actual_bands=4 if inrange(ilo_joball_how_actual,30,34)
				replace ilo_joball_how_actual_bands=5 if inrange(ilo_joball_how_actual,35,39)
				replace ilo_joball_how_actual_bands=6 if inrange(ilo_joball_how_actual,40,48)
				replace ilo_joball_how_actual_bands=7 if ilo_joball_how_actual>=49 & ilo_joball_how_actual!=.
				    * value label already defined for the main job
					lab val ilo_joball_how_actual_bands how_act_bands_lab
					lab var ilo_joball_how_actual_bands "Weekly hours actually worked bands in all jobs"


* 2) Weekly hours USUALLY worked - Not available
			
			gen ilo_joball_how_usual=e38_3total if (ilo_lfs==1)  
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
*			Monthly labour related income ('ilo_joball_lri') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
	   
     /*The total amount of wage/income received is computed merging the speficic amount for those
	 that answered the question (cash + in kind), and the mid-point of the interval for those who
	 did not want to answer the exact amount but answered following the table of intervals.
	 
	 Comment: amount after deductions*/
	 
	 
	 *MAIN JOB
	  
	 /*for those who refused to answered to D14 (D14_Result==3), zeros are replaced by "." 
	 in D14_1 and D14_2*/
	           
			   replace d14_1=. if d14_result==3
			   replace d14_2=. if d14_result==3
	
	/*total amount in cash + in kind*/
			   
	           gen d14_1_2 = d14_1 + d14_2
	
	/*mid-point for those using the intervals*/
	           gen d15_mid=22500 if d15==1                                      // Up to 45000 AMD
			       replace d15_mid=45000 if d15==2                              // 45000 AMD
				   replace d15_mid=67500 if d15==3                              // 45001 - 90000 AMD
				   replace d15_mid=135000 if d15==4                             // 90000 - 180000 AMD
				   replace d15_mid=270000 if d15==5                             // 180000 - 360000 AMD
				   replace d15_mid=430000 if d15==6                             // 360000 - 500000 AMD
				   replace d15_mid=600000 if d15==7                             // 500000 - 700000 AMD  
				   replace d15_mid=700000 if d15==8                             // 700000 AMD and more
				   replace d15_mid=. if inlist(d15,9,10)                        // Refused to answer/ Do not know/ It's difficult to answer
	
	/*final amount*/
	           
			   replace d14_1_2=d15_mid if d14_1_2==.
			   replace d14_1_2=. if d16==7                                      // Period of wage/income not specified
			   			   
    /* monthly labour related income*/
	         
	        *Employees
	           gen ilo_job1_lri_ees=.
			       replace ilo_job1_lri_ees=d14_1_2 if (d16==4 & ilo_job1_ste_aggregate==1)                  // Month
				   replace ilo_job1_lri_ees=d14_1_2*(365/12) if (d16==1 & ilo_job1_ste_aggregate==1)         // Day
				   replace ilo_job1_lri_ees=d14_1_2*(52/12) if (d16==2 & ilo_job1_ste_aggregate==1)          // Week
				   replace ilo_job1_lri_ees=d14_1_2*(2) if (d16==3 & ilo_job1_ste_aggregate==1)              // Two weeks
				   replace ilo_job1_lri_ees=d14_1_2*(1/6) if (d16==5 & ilo_job1_ste_aggregate==1)            // Six months
				   replace ilo_job1_lri_ees=d14_1_2*(1/12) if (d16==6 & ilo_job1_ste_aggregate==1)           // One year
				       lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"
	 
	         *Self-employed
			   gen ilo_job1_lri_slf=.
			       replace ilo_job1_lri_slf=d14_1_2 if (d16==4 & ilo_job1_ste_aggregate==2)                  // Month
				   replace ilo_job1_lri_slf=d14_1_2*(365/12) if (d16==1 & ilo_job1_ste_aggregate==2)         // Day
				   replace ilo_job1_lri_slf=d14_1_2*(52/12) if (d16==2 & ilo_job1_ste_aggregate==2)          // Week
				   replace ilo_job1_lri_slf=d14_1_2*(2) if (d16==3 & ilo_job1_ste_aggregate==2)              // Two weeks
				   replace ilo_job1_lri_slf=d14_1_2*(1/6) if (d16==5 & ilo_job1_ste_aggregate==2)            // Six months
				   replace ilo_job1_lri_slf=d14_1_2*(1/12) if (d16==6 & ilo_job1_ste_aggregate==2)           // One year
				       lab var ilo_job1_lri_slf "Monthly earnings of self-employed in main job"
				   
	 *SECOND JOB
	 
	 /* same as for the main job: for those who refused to answered to D32 (E32_Result==3), zeros are replaced by "." 
	 in E32_1 and E32_2*/
	           
			   replace e32_1=. if e32_result==3
			   replace e32_2=. if e32_result==3
	
	/*total amount in cash + in kind*/
			   
	           gen e32_1_2 = e32_1 + e32_2
	
	/*mid-point for those using the intervals*/
	           gen e33_mid=22500 if e33==1                                      // Up to 45000 AMD
			       replace e33_mid=45000 if e33==2                              // 45000 AMD
				   replace e33_mid=67500 if e33==3                              // 45001 - 90000 AMD
				   replace e33_mid=135000 if e33==4                             // 90000 - 180000 AMD
				   replace e33_mid=270000 if e33==5                             // 180000 - 360000 AMD
				   replace e33_mid=430000 if e33==6                             // 360000 - 500000 AMD
				   replace e33_mid=600000 if e33==7                             // 500000 - 700000 AMD  
				   replace e33_mid=700000 if e33==8                             // 700000 AMD and more
				   replace e33_mid=. if inlist(e33,9,10)                        // Refused to answer/ Do not know/ It's difficult to answer
	
	/*final amount*/
	           
			   replace e32_1_2=e33_mid if e32_1_2==.
			   replace e32_1_2=. if e34==7                                      // Period of wage/income not specified
			   
			   
    /* monthly labour related income*/
	         
	        *Employees
	           gen ilo_job2_lri_ees=.
			       replace ilo_job2_lri_ees=e32_1_2 if (e34==4 & ilo_job2_ste_aggregate==1)                  // Month
				   replace ilo_job2_lri_ees=e32_1_2*(365/12) if (e34==1 & ilo_job2_ste_aggregate==1)         // Day
				   replace ilo_job2_lri_ees=e32_1_2*(52/12) if (e34==2 & ilo_job2_ste_aggregate==1)          // Week
				   replace ilo_job2_lri_ees=e32_1_2*(2) if (e34==3 & ilo_job2_ste_aggregate==1)              // Two weeks
				   replace ilo_job2_lri_ees=e32_1_2*(1/6) if (e34==5 & ilo_job2_ste_aggregate==1)            // Six months
				   replace ilo_job2_lri_ees=e32_1_2*(1/12) if (e34==6 & ilo_job2_ste_aggregate==1)           // One year
				       lab var ilo_job2_lri_ees "Monthly earnings of employees in second job"
	 
	         *Self-employed
			   gen ilo_job2_lri_slf=.
			       replace ilo_job2_lri_slf=e32_1_2 if (e34==4 & ilo_job2_ste_aggregate==2)                  // Month
				   replace ilo_job2_lri_slf=e32_1_2*(365/12) if (e34==1 & ilo_job2_ste_aggregate==2)         // Day
				   replace ilo_job2_lri_slf=e32_1_2*(52/12) if (e34==2 & ilo_job2_ste_aggregate==2)          // Week
				   replace ilo_job2_lri_slf=e32_1_2*(2) if (e34==3 & ilo_job2_ste_aggregate==2)              // Two weeks
				   replace ilo_job2_lri_slf=e32_1_2*(1/6) if (e34==5 & ilo_job2_ste_aggregate==2)            // Six months
				   replace ilo_job2_lri_slf=e32_1_2*(1/12) if (e34==6 & ilo_job2_ste_aggregate==2)           // One year
				       lab var ilo_job2_lri_slf "Monthly earnings of self-employed in second job"
	
	 
***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_joball_tru')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

    /*"The article 139 of the LC provides that the normal duration of the working time should not
	exceed 40 hours a week, or eight hours per day"
	
	Comments: computed using two criteria: want to work additional hours and worked less than a 
	threshold*/	

		gen ilo_joball_tru=.
			replace ilo_joball_tru=1 if (inlist(e41,1,2,3) & ilo_joball_how_actual<=39 & ilo_lfs==1)
			lab def tru_lab 1 "Time-related underemployment"
			lab val ilo_joball_tru tru_lab
			lab var ilo_joball_tru "Time-related underemployment"	
		

*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Cases of non-fatal occupational injury ('ilo_joball_oi_case')
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------

     * Comment: information not available

*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Days lost due to cases of occupational injury ('ilo_joball_oi_day')
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------

    * Comment: information not available

***********************************************************************************************
*			PART 3.3. UNEMPLOYMENT: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Category of unemployment ('ilo_cat_une')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_cat_une=.
		replace ilo_cat_une=1 if (z51==1 & ilo_lfs==2)                          // Previously employed
		replace ilo_cat_une=2 if (z51==2 & ilo_lfs==2)                          // Seeking first job
		replace ilo_cat_une=3 if (ilo_cat_une==. & ilo_lfs==2)
			lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
			lab val ilo_cat_une cat_une_lab
			lab var ilo_cat_une "Category of unemployment"

	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

    /*comments: necessary to put two value notes:
	  a. 1 month to less than 3 months => includes less than 1 month
	  b. 3 to 12 months => includes 3 to 6 months*/

	gen ilo_dur_details=.
				replace ilo_dur_details=2 if (z62==1 & ilo_lfs==2)              // Less than 3 months + value_note (including less than 1 month)
				replace ilo_dur_details=4 if (z62==2 & ilo_lfs==2)              // 3 to 12 months + value_note (including 3 to 6 months)
				replace ilo_dur_details=5 if (z62==3 & ilo_lfs==2)              // 1 to 2 years
				replace ilo_dur_details=6 if ((z62==4 | z62==5)  & ilo_lfs==2)  // 2 to 3 years +  3 years or more
				replace ilo_dur_details=7 if (z62==. & ilo_lfs==2)
				    lab def ilo_unemp_det 1 "Less than 1 month" 2 "1 month to less than 3 months" 3 "3 months to less than 6 months" ///
											4 "6 months to less than 12 months" 5 "12 months to less than 24 months" 6 "24 months or more" ///
											7 "Not elsewhere classified"
					lab val ilo_dur_details ilo_unemp_det
					lab var ilo_dur_details "Duration of unemployment (Details)"
					
	gen ilo_dur_aggregate=.
		replace ilo_dur_aggregate=2 if (inlist(z62,1,2) & ilo_lfs==2)            //6 months to less than 12 months + value_note (including less than 6 months)
		replace ilo_dur_aggregate=3 if (inlist(z62,3,4,5) & ilo_lfs==2)          //12 months or more
		replace ilo_dur_aggregate=4 if (ilo_dur_aggregate==. & ilo_lfs==2)       //Not elsewhere classified
		replace ilo_dur_aggregate=. if ilo_lfs!=2
			lab def ilo_unemp_aggr 1 "Less than 6 months" 2 "6 months to less than 12 months" 3 "12 months or more" 4 "Not elsewhere classified"
			lab val ilo_dur_aggregate ilo_unemp_aggr
			lab var ilo_dur_aggregate "Duration of unemployment (Aggregate)"
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
/*Original classification: NACE Rev.2 one digit level
Correspondences between NACE Rev. and ISIC Rev. 4 are one to one*/
		
		* only for those 
			
		gen ilo_preveco_isic4=z55_21group if (ilo_lfs==2 & ilo_cat_une==1)
		    * value label already defined for employment			
		    lab val ilo_preveco_isic4 isic4
			lab var ilo_preveco_isic4 "Previous economic activity (ISIC Rev. 4)"
						
		
	    * Classification aggregated level
			
		gen ilo_preveco_aggregate=.
		    replace ilo_preveco_aggregate=1 if ilo_preveco_isic4==1
		    replace ilo_preveco_aggregate=2 if ilo_preveco_isic4==3
		    replace ilo_preveco_aggregate=3 if ilo_preveco_isic4==6
		    replace ilo_preveco_aggregate=4 if inlist(ilo_preveco_isic4,2,4,5)
		    replace ilo_preveco_aggregate=5 if inrange(ilo_preveco_isic4,7,14)
		    replace ilo_preveco_aggregate=6 if inrange(ilo_preveco_isic4,15,21)
		    replace ilo_preveco_aggregate=7 if ilo_preveco_isic4==22
			    * value label already defined for employment		
			    lab val ilo_preveco_aggregate eco_aggr_lab
			    lab var ilo_preveco_aggregate "Previous economic activity (Aggregate)" 
			

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

	/* Classification used: ISCO_08 */

	   * ISCO 08 - 1 digit
			gen ilo_prevocu_isco08=z54_9group if (ilo_lfs==2 & ilo_cat_une==1)
			    * value label already defined for employment	
				lab val ilo_prevocu_isco08 isco08
				lab var ilo_prevocu_isco08 "Previous occupation (ISCO-08)"
		
		* Aggregate level 
	
	        gen ilo_prevocu_aggregate=.
	        	replace ilo_prevocu_aggregate=1 if inrange(ilo_prevocu_isco08,1,3)
	        	replace ilo_prevocu_aggregate=2 if inlist(ilo_prevocu_isco08,4,5)
		        replace ilo_prevocu_aggregate=3 if inlist(ilo_prevocu_isco08,6,7)
		        replace ilo_prevocu_aggregate=4 if ilo_prevocu_isco08==8
	        	replace ilo_prevocu_aggregate=5 if ilo_prevocu_isco08==9
	        	replace ilo_prevocu_aggregate=6 if ilo_prevocu_isco08==10
	        	replace ilo_prevocu_aggregate=7 if ilo_prevocu_isco08==11
		        	* value label already defined
			        lab val ilo_prevocu_aggregate ocu_aggr_lab
			        lab var ilo_prevocu_aggregate "Previous occupation (Aggregate)"	
			
	   * Skill level
	
		    gen ilo_prevocu_skill=.
		    	replace ilo_prevocu_skill=1 if ilo_prevocu_isco08==9
			    replace ilo_prevocu_skill=2 if inlist(ilo_prevocu_isco08,4,5,6,7,8)
			    replace ilo_prevocu_skill=3 if inlist(ilo_prevocu_isco08,1,2,3)
			    replace ilo_prevocu_skill=4 if inlist(ilo_prevocu_isco08,10,11)
				    * value label already defined
				    lab val ilo_prevocu_skill ocu_skill_lab
				    lab var ilo_prevocu_skill "Previous occupation (Skill level)"

	
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			General social protection ('ilo_gsp_unschemes')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
    * Comment: information not available	
	
***********************************************************************************************
*			PART 3.4. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
	
	
	gen ilo_olf_dlma=.
		replace ilo_olf_dlma = 1 if (inlist(z57,1,2) & z65==2 & ilo_lfs==3)		//Seeking, not available
		replace ilo_olf_dlma = 2 if (z57==3 & z65==1 & ilo_lfs==3)				//Not seeking, available
		replace ilo_olf_dlma = 3 if (z57==3 & z65==2 & z63==1 & ilo_lfs==3)		//Not seeking, not available, willing
		replace ilo_olf_dlma = 4 if (z57==3 & z65==2 & z63==2 & ilo_lfs==3)		//Not seeking, not available, not willing
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
		replace ilo_olf_reason=1 if	(inlist(z60_11group,4,5,6,7,8) & ilo_lfs==3)			//Labour market
		replace ilo_olf_reason=2 if	(inlist(z60_11group,1,2,3,9,10) & ilo_lfs==3)       	//Personal/Family-related
		*replace ilo_olf_reason=3 if 									                    //Does not need/want to work
		replace ilo_olf_reason=4 if (z60_11group==11 & ilo_lfs==3)							//Not elsewhere classified
		replace ilo_olf_reason=4 if (ilo_olf_reason==. & ilo_lfs==3)						//Not elsewhere classified
			lab def reasons_lab 1 "1 - Labour market" 2 "2 - Personal / Family-related" ///
							   3 "3 - Does not need/want to work" 4 "4 - Not elsewhere classified"
			lab val ilo_olf_reason reasons_lab 
			lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"
			

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seeker ('ilo_dis')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

	gen ilo_dis=1 if (ilo_lfs==3 & z65==1 & ilo_olf_reason==1)
			lab def dis_lab 1 "Discouraged job-seekers"
			lab val ilo_dis dis_lab
			lab var ilo_dis "Discouraged job-seekers"
			
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training ('ilo_neet')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

    /*not enrolled in school and not enrolled in a formal training program => 
	  Why did not you have any job/activity during the last week? -> all categories but pupil/student */		

	gen ilo_neet=1 if (ilo_age_aggregate==2 & ilo_lfs!=1 & z49_4group!=1)
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
		drop to_drop to_drop_1 to_drop_2 social_security lab isco08_2digits isco88_2digits isco08 isco88 isic4_2digits isic4 isic3_2digits isic3 d14_1_2 d15_mid e32_1_2 e33_mid
		
		compress 
		
	   /*Save dataset including original and ilo variables*/
	
		save ${country}_${source}_${time}_FULL,  replace		
	
	  /* Save file only containing ilo_* variables*/
	
		keep ilo*

		save ${country}_${source}_${time}_ILO, replace
		
