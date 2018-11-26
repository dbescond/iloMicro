* TITLE OF DO FILE: ILO Microdata Preprocessing code template - BRAZIL, 2015
* DATASET USED: BRAZIL, PNAD, 2015
* NOTES: 
* Files created: Standard variables BRA_PNAD_2015_FULL.dta and BRA_PNAD_2015_ILO.dta
* Authors: ILO / Department of Statistics / DPAU
* Starting Date: 10 April 2018
* Last updated:  14 May 2018
********************************************************************************

********************************************************************************
********************************************************************************
*                                                                              *
*          1.	Set up work directory, file name, variables and function       *
*                                                                              *
********************************************************************************
********************************************************************************

clear all 

set more off

global path "J:\DPAU\MICRO"
global country "BRA" 
global source "PNAD" 
global time "2015"  
global inputFile "BRA_PNAD_PES_2015.dta" 
global inpath "${path}\\${country}\\${source}\\${time}\ORI"
global temppath "${path}\_Admin"
global outpath "${path}\\${country}\\${source}\\${time}"


********************************************************************************
********************************************************************************


cd "$inpath"
	use ${inputFile}, clear
	*renaming everything in lower case
	rename *, lower  
	
********************************************************************************
********************************************************************************
*                                                                              *
*			                      2. MAP VARIABLES                             *
*                                                                              *
********************************************************************************
********************************************************************************

* ------------------------------------------------------------------------------
********************************************************************************
*                                                                              *
*			              PART 1. DATASET SETTINGS VARIABLES                   *
*                                                                              *
********************************************************************************
* ------------------------------------------------------------------------------

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			               Identifier ('ilo_key')		                       *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment:

	gen ilo_key=_n
		lab var ilo_key "Key unique identifier per individual"
	
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*		             	 Sample Weight ('ilo_wgt') 		                       *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 

	gen ilo_wgt=.
	    replace ilo_wgt=v4729
		lab var ilo_wgt "Sample weight"
	
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			                Time period ('ilo_time')		                   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment:

	gen ilo_time=1
		lab def time_lab 1 "$time"
		lab val ilo_time time_lab
		lab var ilo_time "Time (Gregorian Calendar)"
		
* ------------------------------------------------------------------------------
*********************************************************************************************

* create local for Year 

*********************************************************************************************			
decode ilo_time, gen(todrop)
split todrop, generate(todrop_) parse(Q)
destring todrop_1, replace force
local Y = todrop_1 in 1





********************************************************************************
*                                                                              *
*			                PART 2. SOCIAL CHARACTERISTICS                     *
*                                                                              * 
********************************************************************************
* ------------------------------------------------------------------------------

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*		            	Geographical coverage ('ilo_geo') 		               *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: no info available
	/*
	gen ilo_geo=.
	    replace ilo_geo=1 if          // Urban 
		replace ilo_geo=2 if          // Rural
		        lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural"
		        lab val ilo_geo ilo_geo_lab
		        lab var ilo_geo "Geographical coverage"	
		*/
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			                     Sex ('ilo_sex') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
destring v0302, replace
	
	gen ilo_sex=.
	    replace ilo_sex=1 if v0302==2             // Male
		replace ilo_sex=2 if v0302==4            // Female
		        label define label_Sex 1 "1 - Male" 2 "2 - Female"
		        label values ilo_sex label_Sex
		        lab var ilo_sex "Sex"

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			                    Age ('ilo_age') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
destring v8005, replace

	
	gen ilo_age=.
	    replace ilo_age=v8005
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
			lab def age_by5_lab 1 "0-4" 2 "5-9" 3 "10-14" 4 "15-19" 5 "20-24" 6 "25-29" 7 "30-34" 8 "35-39" 9 "40-44" 10 "45-49" 11 "50-54" 12 "55-59" 13 "60-64" 14 "65+"
			lab val ilo_age_5yrbands age_by5_lab
			lab var ilo_age_5yrbands "Age (5-year age bands)"
			
	gen ilo_age_10yrbands=.
		replace ilo_age_10yrbands=1 if inrange(ilo_age,0,15)
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

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			           Level of education ('ilo_edu') 		                   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: The Education Section in the questionnaire has two different parts, 
*          1. Questions for people currently attending to school (question related to education level: v6003)
*          2. Questions for people who are not currently attending to school (question related to education level: v6007) 
*          Therefore, for people answering to question v6003, it going to be consider that the person has the immediately previous level completed.  

    *---------------------------------------------------------------------------
	* ISCED 97
	*---------------------------------------------------------------------------
	destring v0601, replace
	destring v0606, replace
	destring v0609, replace
	destring v0611, replace
	
	if `Y' > 2006 {
	destring v6003, replace
	destring v6007, replace
	
		* Detailed
	gen ilo_edu_isced97=.
	
		replace ilo_edu_isced97=1 if (v0601==3 & v6003==1) | inrange(v6003,6,9) // No schooling
		replace ilo_edu_isced97=1 if  v0606==4                                  // No schooling
		replace ilo_edu_isced97=1 if  inlist(v6007,10,12) & v0611==3            // No schooling

		
		replace ilo_edu_isced97=2 if (v0601==1 & v6003==1)                                           // Pre-primary education
		replace ilo_edu_isced97=2 if  inlist(v6007,11,13) | (inlist(v6007,10,12) & v0611==1)         // Pre-primary education
		replace ilo_edu_isced97=2 if  v6007==1 & (v0609==3 | v0611==3)                               // Pre-primary education
		
		replace ilo_edu_isced97=3 if inlist(v6003,1,3)                                         // Primary education or first stage of basic education
		replace ilo_edu_isced97=3 if v6007==1 & v0611==1                                      // Primary education or first stage of basic education
		replace ilo_edu_isced97=3 if inlist(v6007,2,4,6) & (v0609==3 | v0611==3)             // Primary education or first stage of basic education
		
		replace ilo_edu_isced97=4 if inlist(v6003,2,4,10)                                      // Lower secondary education or second stage of basic education
	    replace ilo_edu_isced97=4 if inlist(v6007,2,4,6) & v0611==1                           // Lower secondary education or second stage of basic education
	    replace ilo_edu_isced97=4 if inlist(v6007,3,5,7,8) & (v0609==3 | v0611==3)           // Lower secondary education or second stage of basic education
		
		replace ilo_edu_isced97=5 if v6003==5                                   // Upper secondary education
	    replace ilo_edu_isced97=5 if inlist(v6007,3,5,7) & v0611==1             // Upper secondary education
		replace ilo_edu_isced97=5 if v6007==8 & (v0609==3 | v0611==3)           // Upper secondary education
		
		*replace ilo_edu_isced97=6 if                                           // Post-secondary non-tertiary education
		
		replace ilo_edu_isced97=7 if v6003==11                                  // First stage of tertiary education (not leading directly to an advanced research qualification)
		replace ilo_edu_isced97=7 if v6007==8 & v0611==1                        // First stage of tertiary education (not leading directly to an advanced research qualification)
	    replace ilo_edu_isced97=7 if v6007==9 & v0611==3                        // First stage of tertiary education (not leading directly to an advanced research qualification)
		
		replace ilo_edu_isced97=8 if v6007==9 & v0611==1                        // Second stage of tertiary education (leading to an advanced research qualification)                               
		replace ilo_edu_isced97=9 if ilo_edu_isced97==.                         // Level not stated 

	}
	
	
    if `Y' < 2007 {
	destring v0603, replace
	destring v0607, replace
	
		* Detailed
	gen ilo_edu_isced97=.
	
	    replace ilo_edu_isced97=1 if (v0601==3 & v0603==1) | inrange(v0603,6,8) // No schooling
		replace ilo_edu_isced97=1 if  v0606==4                                  // No schooling
		replace ilo_edu_isced97=1 if  v0607==8 & v0611==3                       // No schooling

		
		replace ilo_edu_isced97=2 if (v0601==1 & v0603==1)                                           // Pre-primary education
		replace ilo_edu_isced97=2 if  inlist(v0607,9,10) | (v0607==8 & v0611==1)                     // Pre-primary education
		replace ilo_edu_isced97=2 if  v0607==1 & (v0609==3 | v0611==3)                               // Pre-primary education
		
		replace ilo_edu_isced97=3 if inlist(v0603,1,3)                                        // Primary education or first stage of basic education
		replace ilo_edu_isced97=3 if v0607==1 & v0611==1                                      // Primary education or first stage of basic education
		replace ilo_edu_isced97=3 if inlist(v0607,2,4,6) & (v0609==3 | v0611==3)             // Primary education or first stage of basic education
		
		replace ilo_edu_isced97=4 if inlist(v0603,2,4,9)                                      // Lower secondary education or second stage of basic education
	    replace ilo_edu_isced97=4 if inlist(v0607,2,4,6) & v0611==1                           // Lower secondary education or second stage of basic education
	    replace ilo_edu_isced97=4 if inlist(v0607,3,5) & (v0609==3 | v0611==3)                // Lower secondary education or second stage of basic education
		
		replace ilo_edu_isced97=5 if v0603==5                                   // Upper secondary education
	    replace ilo_edu_isced97=5 if inlist(v0607,3,5) & v0611==1               // Upper secondary education
		replace ilo_edu_isced97=5 if v0607==6 & (v0609==3 | v0611==3)           // Upper secondary education
		 
		*replace ilo_edu_isced97=6 if                                           // Post-secondary non-tertiary education
		
		replace ilo_edu_isced97=7 if v0603==10                                  // First stage of tertiary education (not leading directly to an advanced research qualification)
	    replace ilo_edu_isced97=7 if v0607==7 & v0611==3                        // First stage of tertiary education (not leading directly to an advanced research qualification)
	    replace ilo_edu_isced97=7 if v0607==6 & v0611==1                        // First stage of tertiary education (not leading directly to an advanced research qualification)
		
		
		replace ilo_edu_isced97=8 if v0607==7 & v0611==1                        // Second stage of tertiary education (leading to an advanced research qualification)                               
		replace ilo_edu_isced97=9 if ilo_edu_isced97==.                         // Level not stated 

	}
	
 

	
		
			    label def isced_97_lab 1 "X - No schooling" 2 "0 - Pre-primary education" 3 "1 - Primary education or first stage of basic education" 4 "2 - Lower secondary education or second stage of basic education" ///
							           5 "3 - Upper secondary education" 6 "4 - Post-secondary non-tertiary education" 7 "5 - First stage of tertiary education (not leading directly to an advanced research qualification)" ///
							           8 "6 - Second stage of tertiary education (leading to an advanced research qualification)" 9 "UNK - Level not stated"
			    label val ilo_edu_isced97 isced_97_lab
		        lab var ilo_edu_isced97 "Level of education (ISCED 97)"

	* Aggregate
	gen ilo_edu_aggregate=.
		replace ilo_edu_aggregate=1 if inlist(ilo_edu_isced97,1,2)
		replace ilo_edu_aggregate=2 if inlist(ilo_edu_isced97,3,4)
		replace ilo_edu_aggregate=3 if inlist(ilo_edu_isced97,5,6)
		replace ilo_edu_aggregate=4 if inlist(ilo_edu_isced97,7,8)
		replace ilo_edu_aggregate=5 if ilo_edu_isced97==9
			    label def edu_aggr_lab 1 "1 - Less than basic" 2 "2 - Basic" 3 "3 - Intermediate" 4 "4 - Advanced" 5 "5 - Level not stated"
			    label val ilo_edu_aggregate edu_aggr_lab
			    label var ilo_edu_aggregate "Level of education (Aggregate levels)"

				
				
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*		  	 Educational attendance ('ilo_edu_attendance') 		               *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
destring v0602, replace
			
    gen ilo_edu_attendance=.
		replace ilo_edu_attendance=1 if v0602==2                        // Attending
		replace ilo_edu_attendance=2 if v0602==4                       // Not attending
		replace ilo_edu_attendance=3 if ilo_edu_attendance==.  // Not elsewhere classified
			    lab def edu_attendance_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
			    lab val ilo_edu_attendance edu_attendance_lab
			    lab var ilo_edu_attendance "Education (Attendance)"

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			           Marital status ('ilo_mrts') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

if `Y' > 2009 {
destring v4011, replace
destring v4112, replace

	
	* Detailed
	gen ilo_mrts_details=.
	    replace ilo_mrts_details=1 if v4011==0                                  // Single
	    replace ilo_mrts_details=2 if inlist(v4112,1,3) | (v4011==1 & v4112!=7) // Married
		replace ilo_mrts_details=3 if v4112==7 & v4011!=1                       // Union / cohabiting
		replace ilo_mrts_details=4 if v4011==7                                  // Widowed
		replace ilo_mrts_details=5 if inlist(v4011,3,5)                         // Divorced / separated
		replace ilo_mrts_details=6 if ilo_mrts_details==.			            // Not elsewhere classified
		        label define label_mrts_details 1 "1 - Single" 2 "2 - Married" 3 "3 - Union / cohabiting" ///
				                                4 "4 - Widowed" 5 "5 - Divorced / separated" 6 "6 - Not elsewhere classified"
		        label values ilo_mrts_details label_mrts_details
		        lab var ilo_mrts_details "Marital status"
							
	}
	
	
if `Y' == 2009 {
destring v4011, replace

	
	* Detailed
	gen ilo_mrts_details=.
	    replace ilo_mrts_details=1 if v4011==0                                  // Single
	    replace ilo_mrts_details=2 if v4011==1                                  // Married
		*replace ilo_mrts_details=3 if                                          // Union / cohabiting
		replace ilo_mrts_details=4 if v4011==7                                  // Widowed
		replace ilo_mrts_details=5 if inlist(v4011,3,5)                         // Divorced / separated
		replace ilo_mrts_details=6 if ilo_mrts_details==.			            // Not elsewhere classified
		        label define label_mrts_details 1 "1 - Single" 2 "2 - Married" 3 "3 - Union / cohabiting" ///
				                                4 "4 - Widowed" 5 "5 - Divorced / separated" 6 "6 - Not elsewhere classified"
		        label values ilo_mrts_details label_mrts_details
		        lab var ilo_mrts_details "Marital status"
				
					
	}	
	
if `Y' >= 2009 {
* Aggregate
	gen ilo_mrts_aggregate=.
	    replace ilo_mrts_aggregate=1 if inlist(ilo_mrts_details,1,4,5)          // Single / Widowed / Divorced / Separated
		replace ilo_mrts_aggregate=2 if inlist(ilo_mrts_details,2,3)            // Married / Union / Cohabiting
		replace ilo_mrts_aggregate=3 if ilo_mrts_aggregate==. 			        // Not elsewhere classified
		        label define label_mrts_aggregate 1 "1 - Single / Widowed / Divorced / Separated" 2 "2 - Married / Union / Cohabiting" 3 "3 - Not elsewhere classified"
		        label values ilo_mrts_aggregate label_mrts_aggregate
		        lab var ilo_mrts_aggregate "Marital status (Aggregate levels)"
     }		
	 

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			Disability status ('ilo_dsb_details')                              *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: no info

			
* ------------------------------------------------------------------------------
********************************************************************************
*                                                                              *
*			                PART 3. ECONOMIC SITUATION                         *
*                                                                              * 
********************************************************************************
* ------------------------------------------------------------------------------
	
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			      Working age population ('ilo_wap')	                       *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 	

	gen ilo_wap=.
		replace ilo_wap=1 if ilo_age>=15 & ilo_age!=.
			    label var ilo_wap "Working age population" 

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			       Labour Force Status ('ilo_lfs')                             *       
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
destring v9001, replace
destring v9002, replace
destring v9003, replace
destring v9004, replace
destring v9115, replace
destring v9116, replace
destring v9119, replace


	
	gen ilo_lfs=.
        replace ilo_lfs=1 if v9001==1 & ilo_wap==1						// Employed: ILO definition
		replace ilo_lfs=1 if v9002==1 & ilo_wap==1						// Employed: temporary absent
		replace ilo_lfs=1 if (v9003==1|v9004==1) & ilo_wap==1			// Employed: own-use production of work

* Comment: v9115 seeking for a job during the week of reference
*          v9116 seeking for a job during the last month
*          There are more questions about job search but they broaden the search horizon
* Comment: Unemployment - Two criteria (not in employment and seeking) T5:1429		
		replace ilo_lfs=2 if (v9115==1|v9116==1) & v9119!=0 & ilo_lfs!=1 & ilo_wap==1			// Unemployed: two criteria (no info about availability) 
*		replace ilo_lfs=2 if () & ilo_lfs!=1 & ilo_wap==1			                            // Unemployed: available future starters: there is no information on future starters

	    replace ilo_lfs=3 if !inlist(ilo_lfs,1,2) & ilo_wap==1		// Outside the labour force
		
				label define label_ilo_lfs 1 "1 - Employed" 2 "2 - Unemployed" 3 "3 - Outside Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status" 
			
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			       Multiple job holders ('ilo_mjh')                            *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
destring v9005, replace


    gen ilo_mjh=.
		replace ilo_mjh=1 if v9005==1 & ilo_lfs==1             // One job only     
		replace ilo_mjh=2 if inlist(v9005,3,5) & ilo_lfs==1    // More than one job
		replace ilo_mjh=. if ilo_lfs!=1
			    lab def lab_ilo_mjh 1 "1 - One job only" 2 "2 - More than one job"
			    lab val ilo_mjh lab_ilo_mjh
			    lab var ilo_mjh "Multiple job holders"
			

* ------------------------------------------------------------------------------
********************************************************************************
*                                                                              *
*	          PART 3.1 ECONOMIC CHARACTERISTICS FOR MAIN JOB                   *
*                                                                              * 
********************************************************************************
* ------------------------------------------------------------------------------			

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			       Status in employment ('ilo_ste')                            * 
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
destring v9008, replace
destring v9029, replace
destring v9092, replace



  * MAIN JOB:
   * ICSE 1993
	 gen ilo_job1_ste_icse93=.
		 replace ilo_job1_ste_icse93=1 if (inrange(v9008,1,4)|inlist(v9029,1,2)) & ilo_lfs==1          // Employees
		 replace ilo_job1_ste_icse93=2 if (inrange(v9008,8,10)|v9029==4) & ilo_lfs==1          // Employers
		 replace ilo_job1_ste_icse93=3 if (inlist(v9008,5,6,7,13)|inlist(v9029,3,7)) & ilo_lfs==1          // Own-account workers
		* replace ilo_job1_ste_icse93=4 if  & ilo_lfs==1          // Members of producers' cooperatives
		 replace ilo_job1_ste_icse93=5 if (v9008==11|v9029==5)  & ilo_lfs==1          // Contributing family workers
		 replace ilo_job1_ste_icse93=6 if ilo_job1_ste_icse93==. & ilo_lfs==1   // Workers not classifiable by status
		 replace ilo_job1_ste_icse93=. if ilo_lfs!=1
				 label def label_ilo_ste_icse93 1 "1 - Employees" 2 "2 - Employers" 3 "3 - Own-account workers" ///
				                                4 "4 - Members of producers' cooperatives" 5 "5 - Contributing family workers" ///
												6 "6 - Workers not classifiable by status"
				 label val ilo_job1_ste_icse93 label_ilo_ste_icse93
				 label var ilo_job1_ste_icse93 "Status in employment (ICSE 93) - main job"

	* Aggregate categories 
	  gen ilo_job1_ste_aggregate=.
		  replace ilo_job1_ste_aggregate=1 if ilo_job1_ste_icse93==1                 // Employees
		  replace ilo_job1_ste_aggregate=2 if inlist(ilo_job1_ste_icse93,2,3,4,5)    // Self-employed
		  replace ilo_job1_ste_aggregate=3 if inlist(ilo_job1_ste_icse93,6)          // Not elsewhere classified
				  lab def ste_aggr_lab 1 "1 - Employees" 2 "2 - Self-employed" 3 "3 - Not elsewhere classified"
				  lab val ilo_job1_ste_aggregate ste_aggr_lab
				  label var ilo_job1_ste_aggregate "Status in employment (Aggregate) - main job"
				
* SECOND JOB:
	* ICSE 1993
	  gen ilo_job2_ste_icse93=.
		  replace ilo_job2_ste_icse93=1 if inlist(v9092,1,2) & ilo_mjh==2          // Employees
		  replace ilo_job2_ste_icse93=2 if v9092==5 & ilo_mjh==2          // Employers
		  replace ilo_job2_ste_icse93=3 if v9092==3 & ilo_mjh==2          // Own-account workers
		  *replace ilo_job2_ste_icse93=4 if  & ilo_mjh==2          // Members of producers' cooperatives 
		  replace ilo_job2_ste_icse93=5 if v9092==5 & ilo_mjh==2          // Contributing family workers
		  replace ilo_job2_ste_icse93=6 if ilo_job2_ste_icse93==. & ilo_mjh==2  // Workers not classifiable by status
		  replace ilo_job2_ste_icse93=. if ilo_mjh!=2
 			      label value ilo_job2_ste_icse93 label_ilo_ste_icse93
			      label var ilo_job2_ste_icse93 "Status in employment (ICSE 93) - second job"

	* Aggregate categories
	  gen ilo_job2_ste_aggregate=.
		  replace ilo_job2_ste_aggregate=1 if ilo_job2_ste_icse93==1                 // Employees
		  replace ilo_job2_ste_aggregate=2 if inlist(ilo_job2_ste_icse93,2,3,4,5)    // Self-employed
		  replace ilo_job2_ste_aggregate=3 if inlist(ilo_job2_ste_icse93,6)          // Not elsewhere classified
				  lab val ilo_job2_ste_aggregate ste_aggr_lab
				  label var ilo_job2_ste_aggregate "Status in employment (Aggregate) - second job"
					
					
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			            Economic activity ('ilo_eco')                          *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

 ***********
    * MAIN JOB:
    ***********

destring v9907, replace
	
gen indu_code_prim=int(v9907/1000) if ilo_lfs==1 & v9907!=99888

	
    *---------------------------------------------------------------------------
	* ISIC REV 3.1
	*---------------------------------------------------------------------------
	
	* 2-digit level
	
	
	gen ilo_job1_eco_isic3_2digits = .
	    replace ilo_job1_eco_isic3_2digits = indu_code_prim  if ilo_lfs==1 
		replace ilo_job1_eco_isic3_2digits = 52  if ilo_lfs==1 & indu_code_prim==53
	    replace ilo_job1_eco_isic3_2digits = . if ilo_lfs!=1
			    lab def eco_isic3_2digits 1 "01 - Agriculture, hunting and related service activities"	2 "02 - Forestry, logging and related service activities"	5 "05 - Fishing, operation of fish hatcheries and fish farms; service activities incidental to fishing"	10 "10 - Mining of coal and lignite; extraction of peat"	///
                                          11 "11 - Extraction of crude petroleum and natural gas; service activities incidental to oil and gas extraction excluding surveying"	12 "12 - Mining of uranium and thorium ores"	13 "13 - Mining of metal ores"	14 "14 - Other mining and quarrying"	///
                                          15 "15 - Manufacture of food products and beverages"	16 "16 - Manufacture of tobacco products"	17 "17 - Manufacture of textiles"	18 "18 - Manufacture of wearing apparel; dressing and dyeing of fur"	///
                                          19 "19 - Tanning and dressing of leather; manufacture of luggage, handbags, saddlery, harness and footwear"	20 "20 - Manufacture of wood and of products of wood and cork, except furniture; manufacture of articles of straw and plaiting materials"	21 "21 - Manufacture of paper and paper products"	22 "22 - Publishing, printing and reproduction of recorded media"	///
                                          23 "23 - Manufacture of coke, refined petroleum products and nuclear fuel"	24 "24 - Manufacture of chemicals and chemical products"	25 "25 - Manufacture of rubber and plastics products"	26 "26 - Manufacture of other non-metallic mineral products"	///
                                          27 "27 - Manufacture of basic metals"	28 "28 - Manufacture of fabricated metal products, except machinery and equipment"	29 "29 - Manufacture of machinery and equipment n.e.c."	30 "30 - Manufacture of office, accounting and computing machinery"	///
                                          31 "31 - Manufacture of electrical machinery and apparatus n.e.c."	32 "32 - Manufacture of radio, television and communication equipment and apparatus"	33 "33 - Manufacture of medical, precision and optical instruments, watches and clocks"	34 "34 - Manufacture of motor vehicles, trailers and semi-trailers"	///
                                          35 "35 - Manufacture of other transport equipment"	36 "36 - Manufacture of furniture; manufacturing n.e.c."	37 "37 - Recycling"	40 "40 - Electricity, gas, steam and hot water supply"	///
                                          41 "41 - Collection, purification and distribution of water"	45 "45 - Construction"	50 "50 - Sale, maintenance and repair of motor vehicles and motorcycles; retail sale of automotive fuel"	51 "51 - Wholesale trade and commission trade, except of motor vehicles and motorcycles"	///
                                          52 "52 - Retail trade, except of motor vehicles and motorcycles; repair of personal and household goods"	55 "55 - Hotels and restaurants"	60 "60 - Land transport; transport via pipelines"	61 "61 - Water transport"	///
                                          62 "62 - Air transport"	63 "63 - Supporting and auxiliary transport activities; activities of travel agencies"	64 "64 - Post and telecommunications"	65 "65 - Financial intermediation, except insurance and pension funding"	///
                                          66 "66 - Insurance and pension funding, except compulsory social security"	67 "67 - Activities auxiliary to financial intermediation"	70 "70 - Real estate activities"	71 "71 - Renting of machinery and equipment without operator and of personal and household goods"	///
                                          72 "72 - Computer and related activities"	73 "73 - Research and development"	74 "74 - Other business activities"	75 "75 - Public administration and defence; compulsory social security"	///
                                          80 "80 - Education"	85 "85 - Health and social work"	90 "90 - Sewage and refuse disposal, sanitation and similar activities"	91 "91 - Activities of membership organizations n.e.c."	///
                                          92 "92 - Recreational, cultural and sporting activities"	93 "93 - Other service activities"	95 "95 - Activities of private households as employers of domestic staff"	96 "96 - Undifferentiated goods-producing activities of private households for own use"	///
                                          97 "97 - Undifferentiated service-producing activities of private households for own use"	99 "99 - Extra-territorial organizations and bodies"			
                lab val ilo_job1_eco_isic3_2digits eco_isic3_2digits
                lab var ilo_job1_eco_isic3_2digits "Economic activity (ISIC Rev. 3.1), 2 digits level - main job"

	* 1-digit level	
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
		        lab def eco_isic3_1digit 1 "A - Agriculture, hunting and forestry"	2 "B - Fishing"	3 "C - Mining and quarrying"	4 "D - Manufacturing"	///
                                         5 "E - Electricity, gas and water supply"	6 "F - Construction"	7 "G - Wholesale and retail trade; repair of motor vehicles, motorcycles and personal and household goods"	8 "H - Hotels and restaurants"	///
                                         9 "I - Transport, storage and communications"	10 "J - Financial intermediation"	11 "K - Real estate, renting and business activities"	12 "L - Public administration and defence; compulsory social security"	///
                                         13 "M - Education"	14 "N - Health and social work"	15 "O - Other community, social and personal service activities"	16 "P - Activities of private households as employers and undifferentiated production activities of private households"	///
                                         17 "Q - Extraterritorial organizations and bodies"	18 "X - Not elsewhere classified"			
			    lab val ilo_job1_eco_isic3 eco_isic3_1digit
			    lab var ilo_job1_eco_isic3 "Economic activity (ISIC Rev. 3.1) - main job"
	
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
			lab var ilo_job1_eco_aggregate "Economic activity (Aggregate) - main job"

			
    *************
    * SECOND JOB:
    *************

    destring v9991, replace
	
    gen indu_code_sec=int(v9991/1000) if ilo_mjh==2
	
	*---------------------------------------------------------------------------
	* ISIC REV 3.1
	*---------------------------------------------------------------------------
 
 * 2-digit level
	gen ilo_job2_eco_isic3_2digits = .
	    replace ilo_job2_eco_isic3_2digits = indu_code_sec  if ilo_mjh==2 & indu_code_sec!=99
		replace ilo_job2_eco_isic3_2digits = 52  if ilo_mjh==2 & indu_code_sec==53
	    replace ilo_job2_eco_isic3_2digits = . if ilo_mjh!=2
                * labels already defined for main job
		        lab val ilo_job2_eco_isic3_2digits eco_isic3_2digits
                lab var ilo_job2_eco_isic3_2digits "Economic activity (ISIC Rev. 3.1), 2 digits level - second job"

	* 1-digit level	
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
		replace ilo_job2_eco_isic3=18 if ilo_job2_eco_isic3==. & ilo_mjh==2
                * labels already defined for main job
		        lab val ilo_job2_eco_isic3 eco_isic3_1digit
			    lab var ilo_job2_eco_isic3 "Economic activity (ISIC Rev. 3.1) - second job"
	
	* Aggregate level
	gen ilo_job2_eco_aggregate=.
		replace ilo_job2_eco_aggregate=1 if inlist(ilo_job2_eco_isic3,1,2)
		replace ilo_job2_eco_aggregate=2 if ilo_job2_eco_isic3==4
		replace ilo_job2_eco_aggregate=3 if ilo_job2_eco_isic3==6
		replace ilo_job2_eco_aggregate=4 if inlist(ilo_job2_eco_isic3,3,5)
		replace ilo_job2_eco_aggregate=5 if inrange(ilo_job2_eco_isic3,7,11)
		replace ilo_job2_eco_aggregate=6 if inrange(ilo_job2_eco_isic3,12,17)
		replace ilo_job2_eco_aggregate=7 if ilo_job2_eco_isic3==18
                * labels already defined for main job
			    lab val ilo_job2_eco_aggregate eco_aggr_lab
			    lab var ilo_job2_eco_aggregate "Economic activity (Aggregate) - second job"

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			               Occupation ('ilo_ocu') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: the national classification for occupations does not match in some cases with ISCO-88
*          therefore, some changes must be made before computing the ilo_ocu variable. 


    ***********
    * MAIN JOB:
    ***********
 
    *---------------------------------------------------------------------------
	* ISCO 88
	*---------------------------------------------------------------------------

destring v9906, replace

recode v9906  	(3250=3154) (3322=2359) (3341=2352) (3423=4133) (3424=5112) (3426=4133) (3515=2523) (3516=3119) (3522=3222) ///
                (3532=4122) (3543=2419) (3713=3119) (3721=3131) (3722=3132) (3741=3131) (3742=3131) (3743=3131) (3464=5210) ///
				(4223=9113) (4241=3434) (5102=8264) (5121=9131) (5141=9141) (5142=9161) (5166=9312) (5169=9100) (5174=9152) ///
				(5191=8321) (5192=9161) (5199=9100) (5201=3415) (5221=9100) (5231=7233) (5241=9113) (5242=9111) (5243=9111) ///
				(7112=8332) (7113=8113) (7114=9311) (7121=8112) (7151=8332) (7154=8212) (7170=9313) (7202=7122) (7214=8211) ///
				(7222=8122) (7222=8122) (7224=8124) (7231=8123) (7232=8223) (7233=7142) (7241=7136) (7245=8282) (7251=8281) ///
				(7252=8281) (7301=7241) (7311=8282) (7312=8283) (7313=7244) (7321=7245) (7401=7311) (7411=7312) (7501=7313) ///
				(7502=8131) (7519=7300) (7521=7322) (7522=7322) (7523=7321) (7524=7324) (7601=8269) (7602=7441) (7603=7436) ///
				(7604=7442) (7605=7441) (7606=7442) (7610=8261) (7611=7431) (7612=8261) (7613=8262) (7614=8264) (7618=3152) ///
				(7620=7441) (7621=7441) (7622=7441) (7623=7441) (7623=8265) (7630=7433) (7631=7435) (7632=8263) (7633=8263) ///
				(7640=7442) (7641=7442) (7642=8266) (7643=7442) (7650=7433) (7651=7442) (7652=7436) (7653=8269) (7654=8264) ///
				(7661=7341) (7662=8251) (7663=7345) (7664=7344) (7681=7432) (7682=7436) (7683=7442) (7686=7341) (7687=7345) ///
				(7731=8141) (7732=8141) (7734=8240) (7735=8240) (7771=7124) (7801=8290) (7811=8172) (7813=8172) (7817=8172) ///
				(7817=7216) (7828=9332) (7832=9333) (7841=8290) (7842=9321) (8102=8232) (8103=8159) (8117=8229) (8118=8221) ///
				(8121=8222) (8181=5132) (8202=7322) (8281=7321) (8301=8253) (8311=8142) (8321=8142) (8401=7412) (8485=7411) ///
				(8491=7400) (8492=7400) (9109=8312) (9151=7311) (9152=7312) (9153=7311) (9501=7137) (9531=7137) (9543=7433) ///
				(9911=8312) (9912=7241) (9913=7213) (9914=9100) (9921=8231) (9922=9312) if ilo_lfs==1, gen(v9906_new)
 

	
gen occ_code_prim=int(v9906_new/100) if ilo_lfs==1 

recode occ_code_prim (2=1) (3=1) (4=1) (5=1) (20=21) (25=24) (26=24) (30=31) (34=31) (35=34) (37=34) (39=31) (62=61) (63=62) ///
                     (64=83) (75=74) (76=74) (77=74) (78=83) (84=82) (86=81) (87=93) (95=72) if ilo_lfs==1, gen(isco_88_prim)

						 
						
	* 2-digit level 
    gen ilo_job1_ocu_isco88_2digits = . 
	    replace ilo_job1_ocu_isco88_2digits = isco_88_prim    if ilo_lfs==1 & isco_88_prim!=99
		replace ilo_job1_ocu_isco88_2digits = .   if ilo_lfs!=1
		        lab def ocu_isco88_2digits 1 "01 - Armed forces"	11 "11 - Legislators and senior officials"	12 "12 - Corporate managers"	13 "13 - General managers"	///
                                           21 "21 - Physical, mathematical and engineering science professionals"	22 "22 - Life science and health professionals"	23 "23 - Teaching professionals"	24 "24 - Other professionals"	///
                                           31 "31 - Physical and engineering science associate professionals"	32 "32 - Life science and health associate professionals"	33 "33 - Teaching associate professionals"	34 "34 - Other associate professionals"	///
                                           41 "41 - Office clerks"	42 "42 - Customer services clerks"	51 "51 - Personal and protective services workers"	52 "52 - Models, salespersons and demonstrators"	///
                                           61 "61 - Skilled agricultural and fishery workers"	62 "62 - Subsistence agricultural and fishery workers"	71 "71 - Extraction and building trades workers"	72 "72 - Metal, machinery and related trades workers"	///
                                           73 "73 - Precision, handicraft, craft printing and related trades workers"	74 "74 - Other craft and related trades workers"	81 "81 - Stationary plant and related operators"	82 "82 - Machine operators and assemblers"	///
                                           83 "83 - Drivers and mobile plant operators"	91 "91 - Sales and services elementary occupations"	92 "92 - Agricultural, fishery and related labourers"	93 "93 - Labourers in mining, construction, manufacturing and transport"	
	            lab values ilo_job1_ocu_isco88_2digits ocu_isco88_2digits
	            lab var ilo_job1_ocu_isco88_2digits "Occupation (ISCO-88), 2 digit level - main job"
			
    * 1-digit level
	gen ilo_job1_ocu_isco88=.
	    replace ilo_job1_ocu_isco88=11 if isco_88_prim==99 & ilo_lfs==1                          // Not elsewhere classified
		replace ilo_job1_ocu_isco88=int(ilo_job1_ocu_isco88_2digits/10) if (ilo_job1_ocu_isco88==. & ilo_lfs==1)     // The rest of the occupations
		replace ilo_job1_ocu_isco88=10 if (ilo_job1_ocu_isco88==0 & ilo_lfs==1)                                      // Armed forces
		        lab def ocu_isco88_1digit 1 "1 - Legislators, senior officials and managers"	2 "2 - Professionals"	3 "3 - Technicians and associate professionals"	4 "4 - Clerks"	///
                                          5 "5 - Service workers and shop and market sales workers"	6 "6 - Skilled agricultural and fishery workers"	7 "7 - Craft and related trades workers"	8 "8 - Plant and machine operators and assemblers"	///
                                          9 "9 - Elementary occupations"	10 "0 - Armed forces"	11 "11 - Not elsewhere classified"		
				lab val ilo_job1_ocu_isco88 ocu_isco88_1digit
				lab var ilo_job1_ocu_isco88 "Occupation (ISCO-88) - main job"
				
				
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
				lab var ilo_job1_ocu_aggregate "Occupation (Aggregate) - main job"				
				
    * Skill level				
    gen ilo_job1_ocu_skill=.
	    replace ilo_job1_ocu_skill=1 if ilo_job1_ocu_isco88==9                  // Low
		replace ilo_job1_ocu_skill=2 if inlist(ilo_job1_ocu_isco88,4,5,6,7,8)   // Medium
		replace ilo_job1_ocu_skill=3 if inlist(ilo_job1_ocu_isco88,1,2,3)       // High
		replace ilo_job1_ocu_skill=4 if inlist(ilo_job1_ocu_isco88,10,11)       // Not elsewhere classified
				lab def ocu_skill_lab 1 "1 - Skill level 1 (low)" 2 "2 - Skill level 2 (medium)" 3 "3 - Skill levels 3 and 4 (high)" 4 "4 - Not elsewhere classified"
			    lab val ilo_job1_ocu_skill ocu_skill_lab
			    lab var ilo_job1_ocu_skill "Occupation (Skill level) - main job"
	

  
    *************
    * SECOND JOB:
    *************

    *---------------------------------------------------------------------------
	* ISCO 88
	*---------------------------------------------------------------------------

destring v9990, replace

recode v9990  	(3250=3154) (3322=2359) (3341=2352) (3423=4133) (3424=5112) (3426=4133) (3515=2523) (3516=3119) (3522=3222) ///
                (3532=4122) (3543=2419) (3713=3119) (3721=3131) (3722=3132) (3741=3131) (3742=3131) (3743=3131) (3464=5210) ///
				(4223=9113) (4241=3434) (5102=8264) (5121=9131) (5141=9141) (5142=9161) (5166=9312) (5169=9100) (5174=9152) ///
				(5191=8321) (5192=9161) (5199=9100) (5201=3415) (5221=9100) (5231=7233) (5241=9113) (5242=9111) (5243=9111) ///
				(7112=8332) (7113=8113) (7114=9311) (7121=8112) (7151=8332) (7154=8212) (7170=9313) (7202=7122) (7214=8211) ///
				(7222=8122) (7222=8122) (7224=8124) (7231=8123) (7232=8223) (7233=7142) (7241=7136) (7245=8282) (7251=8281) ///
				(7252=8281) (7301=7241) (7311=8282) (7312=8283) (7313=7244) (7321=7245) (7401=7311) (7411=7312) (7501=7313) ///
				(7502=8131) (7519=7300) (7521=7322) (7522=7322) (7523=7321) (7524=7324) (7601=8269) (7602=7441) (7603=7436) ///
				(7604=7442) (7605=7441) (7606=7442) (7610=8261) (7611=7431) (7612=8261) (7613=8262) (7614=8264) (7618=3152) ///
				(7620=7441) (7621=7441) (7622=7441) (7623=7441) (7623=8265) (7630=7433) (7631=7435) (7632=8263) (7633=8263) ///
				(7640=7442) (7641=7442) (7642=8266) (7643=7442) (7650=7433) (7651=7442) (7652=7436) (7653=8269) (7654=8264) ///
				(7661=7341) (7662=8251) (7663=7345) (7664=7344) (7681=7432) (7682=7436) (7683=7442) (7686=7341) (7687=7345) ///
				(7731=8141) (7732=8141) (7734=8240) (7735=8240) (7771=7124) (7801=8290) (7811=8172) (7813=8172) (7817=8172) ///
				(7817=7216) (7828=9332) (7832=9333) (7841=8290) (7842=9321) (8102=8232) (8103=8159) (8117=8229) (8118=8221) ///
				(8121=8222) (8181=5132) (8202=7322) (8281=7321) (8301=8253) (8311=8142) (8321=8142) (8401=7412) (8485=7411) ///
				(8491=7400) (8492=7400) (9109=8312) (9151=7311) (9152=7312) (9153=7311) (9501=7137) (9531=7137) (9543=7433) ///
				(9911=8312) (9912=7241) (9913=7213) (9914=9100) (9921=8231) (9922=9312) if ilo_mjh==2, gen(v9990_new)

	
gen occ_code_sec=int(v9990_new/100) if ilo_mjh==2

recode occ_code_sec (2=1) (3=1) (4=1) (5=1) (20=21) (25=24) (26=24) (30=31) (34=31) (35=34) (37=34) (39=31) (62=61) (63=62) ///
                     (64=83) (75=74) (76=74) (77=74) (78=83) (84=82) (86=81) (87=93) (95=72) if ilo_mjh==2, gen(isco_88_sec)


	
	
	
	* 2-digit level 
    gen ilo_job2_ocu_isco88_2digits = . 
	    replace ilo_job2_ocu_isco88_2digits = isco_88_sec if ilo_mjh==2 & isco_88_sec!=99
		replace ilo_job2_ocu_isco88_2digits = .  if ilo_mjh!=2
                * labels already defined for main job
		        lab values ilo_job2_ocu_isco88_2digits ocu_isco88_2digits
	            lab var ilo_job2_ocu_isco88_2digits "Occupation (ISCO-88), 2 digit level - second job"
			
    * 1-digit level
	gen ilo_job2_ocu_isco88=.
	    replace ilo_job2_ocu_isco88=11 if isco_88_sec==99 & ilo_mjh==2                          // Not elsewhere classified
		replace ilo_job2_ocu_isco88=int(ilo_job2_ocu_isco88_2digits/10) if (ilo_job2_ocu_isco88==. & ilo_mjh==2)     // The rest of the occupations
		replace ilo_job2_ocu_isco88=10 if (ilo_job2_ocu_isco88==0 & ilo_mjh==2)                                      // Armed forces
                * labels already defined for main job
				lab val ilo_job2_ocu_isco88 ocu_isco88_1digit
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
                * labels already defined for main job
		        lab val ilo_job2_ocu_aggregate ocu_aggr_lab
				lab var ilo_job2_ocu_aggregate "Occupation (Aggregate) - second job"				
				
    * Skill level				
    gen ilo_job2_ocu_skill=.
	    replace ilo_job2_ocu_skill=1 if ilo_job2_ocu_isco88==9                  // Low
		replace ilo_job2_ocu_skill=2 if inlist(ilo_job2_ocu_isco88,4,5,6,7,8)   // Medium
		replace ilo_job2_ocu_skill=3 if inlist(ilo_job2_ocu_isco88,1,2,3)       // High
		replace ilo_job2_ocu_skill=4 if inlist(ilo_job2_ocu_isco88,10,11)       // Not elsewhere classified
		        * labels already defined for main job
			    lab val ilo_job2_ocu_skill ocu_skill_lab
			    lab var ilo_job2_ocu_skill "Occupation (Skill level) - second job"
				

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*	Institutional sector of economic activities ('ilo_ins_sector')		       *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
destring v9032, replace
destring v9093, replace


** MAIN JOB
	gen ilo_job1_ins_sector=.
		replace ilo_job1_ins_sector=1 if v9032==4 & ilo_lfs==1    // Public
		replace ilo_job1_ins_sector=2 if ilo_job1_ins_sector==. & ilo_lfs==1    // Private
			    lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
			    lab values ilo_job1_ins_sector ins_sector_lab
			    lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities - main job"
				
				

** SECOND JOB
	gen ilo_job2_ins_sector=.
		replace ilo_job2_ins_sector=1 if v9093==3 & ilo_mjh==2    // Public
		replace ilo_job2_ins_sector=2 if ilo_job2_ins_sector==. & ilo_mjh==2    // Private
			   * lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
			    lab values ilo_job2_ins_sector ins_sector_lab
			    lab var ilo_job2_ins_sector "Institutional sector (private/public) of economic activities - second job"				
		
		
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*		               Hours of work ('ilo_how')  	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

* Comment: only information on hours usually worked

destring  v9058, replace
destring v9101, replace
destring v9105, replace

    ***********
    * MAIN JOB:
    ***********
	
	* Hours USUALLY worked
	gen ilo_job1_how_usual = .
	    replace ilo_job1_how_usual = v9058 if ilo_lfs==1
	            lab var ilo_job1_how_usual "Weekly hours usually worked - main job"
		  
	gen ilo_job1_how_usual_bands=.
	 	replace ilo_job1_how_usual_bands=1 if ilo_job1_how_usual==0
		replace ilo_job1_how_usual_bands=2 if ilo_job1_how_usual>=1 & ilo_job1_how_usual<=14
		replace ilo_job1_how_usual_bands=3 if ilo_job1_how_usual>14 & ilo_job1_how_usual<=29
		replace ilo_job1_how_usual_bands=4 if ilo_job1_how_usual>29 & ilo_job1_how_usual<=34
		replace ilo_job1_how_usual_bands=5 if ilo_job1_how_usual>34 & ilo_job1_how_usual<=39
		replace ilo_job1_how_usual_bands=6 if ilo_job1_how_usual>39 & ilo_job1_how_usual<=48
		replace ilo_job1_how_usual_bands=7 if ilo_job1_how_usual>48 & ilo_job1_how_usual!=.
		replace ilo_job1_how_usual_bands=8 if ilo_job1_how_usual_bands==. & ilo_lfs==1
		replace ilo_job1_how_usual_bands=. if ilo_lfs!=1
		   	    lab def how_bands_usu 1 "No hours usually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"		
				lab val ilo_job1_how_usual_bands how_bands_usu
				lab var ilo_job1_how_usual_bands "Weekly hours usually worked bands - main job"

 	
    *************
    * SECOND JOB:
    *************
	
	* Hours USUALLY worked
	gen ilo_job2_how_usual = .
	    replace ilo_job2_how_usual = v9101 if ilo_mjh==2
	            lab var ilo_job2_how_usual "Weekly hours usually worked - second job"
					 
	gen ilo_job2_how_usual_bands=.
	 	replace ilo_job2_how_usual_bands=1 if ilo_job2_how_usual==0
		replace ilo_job2_how_usual_bands=2 if ilo_job2_how_usual>=1 & ilo_job2_how_usual<=14
		replace ilo_job2_how_usual_bands=3 if ilo_job2_how_usual>14 & ilo_job2_how_usual<=29
		replace ilo_job2_how_usual_bands=4 if ilo_job2_how_usual>29 & ilo_job2_how_usual<=34
		replace ilo_job2_how_usual_bands=5 if ilo_job2_how_usual>34 & ilo_job2_how_usual<=39
		replace ilo_job2_how_usual_bands=6 if ilo_job2_how_usual>39 & ilo_job2_how_usual<=48
		replace ilo_job2_how_usual_bands=7 if ilo_job2_how_usual>48 & ilo_job2_how_usual!=.
		replace ilo_job2_how_usual_bands=8 if ilo_job2_how_usual_bands==. & ilo_mjh==2
		replace ilo_job2_how_usual_bands=. if ilo_mjh!=2
		        * labels already difined for main job
				lab val ilo_job2_how_usual_bands how_bands_usu
				lab var ilo_job2_how_usual_bands "Weekly hours usually worked bands - second job"
				
     ***********
    * ALL JOBS:
    ***********
	
	* Hours USUALLY worked
	egen ilo_joball_how_usual=rowtotal(v9058 v9101 v9105) if ilo_lfs==1,m
		        lab var ilo_joball_how_usual "Weekly hours usually worked - all jobs"
		 
	gen ilo_joball_how_usual_bands=.
	    replace ilo_joball_how_usual_bands=1 if ilo_joball_how_usual==0
		replace ilo_joball_how_usual_bands=2 if ilo_joball_how_usual>=1 & ilo_joball_how_usual<=14
		replace ilo_joball_how_usual_bands=3 if ilo_joball_how_usual>14 & ilo_joball_how_usual<=29
		replace ilo_joball_how_usual_bands=4 if ilo_joball_how_usual>29 & ilo_joball_how_usual<=34
		replace ilo_joball_how_usual_bands=5 if ilo_joball_how_usual>34 & ilo_joball_how_usual<=39
		replace ilo_joball_how_usual_bands=6 if ilo_joball_how_usual>39 & ilo_joball_how_usual<=48
		replace ilo_joball_how_usual_bands=7 if ilo_joball_how_usual>48 & ilo_joball_how_usual!=.
		replace ilo_joball_how_usual_bands=8 if ilo_joball_how_usual_bands==. & ilo_lfs==1
		replace ilo_joball_how_usual_bands=. if ilo_lfs!=1
		        * labels already defined for main job
			 	lab val ilo_joball_how_usual_bands how_bands_usu
				lab var ilo_joball_how_usual_bands "Weekly hours usually worked bands - all jobs"

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job_time')		                   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: no info 				
 			
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*		    	Type of contract ('ilo_job_contract') 		                   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: no info
	
	
 
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*  Informal/formal economy: ('ilo_job1_ife_prod'/'ilo_job1_ife_nature') 	   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 
if `Y' > 2008 {

destring v9059, replace
destring v90531, replace
destring v9054, replace



/* Useful questions:
          - Institutional sector: v9032
		  - Private household identification: 
		  - Destination of production: no info.- the period of time referred to in the question related to "produces for sale" (v9025) is not the reference week
		  - Bookkeeping: no info
		  - Registration: v90531 (no info before 2009)
		  - Status in employment: v9008, v9029
		  - Social security contribution (Proxy: pension funds): v9059
		  - Place of work: v9054 
		  - Size:
		  - Paid annual leave:
		  - Paid sick leave:
*/
    * Social Security:
	gen social_security=.
	    replace social_security=1 if v9059==1  &  ilo_lfs==1          // social security (proxy)
		replace social_security=2 if v9059==3  &  ilo_lfs==1          // no social security (proxy)
	
    * 1) UNIT OF PRODUCTION: FORMAL/INFORMAL SECTOR
			gen ilo_job1_ife_prod=.
 			   
			   replace ilo_job1_ife_prod=3 if ilo_lfs==1 & (ilo_job1_eco_isic3_2digits==95 | ilo_job1_ocu_isco88_2digits==62)
 				
 				replace ilo_job1_ife_prod=2 if ilo_lfs==1 & v90531==1 |  (ilo_job1_ste_icse93==1 & social_security==1)
 											  
			    replace ilo_job1_ife_prod=1 if ilo_lfs==1 & !inlist(ilo_job1_ife_prod,3,2) 
				                               
				        lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 
						lab val ilo_job1_ife_prod ilo_ife_prod_lab
						lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"
			
		
	
	* 2) NATURE OF JOB: FORMAL/INFORMAL EMPLOYMENT
	gen ilo_job1_ife_nature=.
	
	    replace ilo_job1_ife_nature=2 if ilo_lfs==1 & ilo_job1_ste_icse93==1 & social_security==1
	    replace ilo_job1_ife_nature=2 if ilo_lfs==1 & ilo_job1_ste_icse93==2 & ilo_job1_ife_prod==2
		
	    replace ilo_job1_ife_nature=1 if ilo_lfs==1 & ilo_job1_ife_nature!=2
                lab def ife_nature_lab 1 "1 - Persons with informal main job" 2 "2 - Persons with formal main job"
		        lab val ilo_job1_ife_nature ife_nature_lab
		        lab var ilo_job1_ife_nature "Informal / Formal Economy (Nature of job)"	
 
 }
 
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*	    Monthly related income ('ilo_lri_ees' and 'ilo_lri_slf')  		       *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 
 
    ***********
    * MAIN JOB:
    ***********
	
	* Employees
   egen ilo_job1_lri_ees = rowtotal(v9532 v9535) if ilo_job1_ste_aggregate==1,m	    
	    replace ilo_job1_lri_ees = .     if ilo_lfs!=1
		        lab var ilo_job1_lri_ees "Monthly earnings of employees - main job"
	
	* Self-employed
	egen ilo_job1_lri_slf = rowtotal(v9532 v9535) if ilo_job1_ste_aggregate==2,m
	    replace ilo_job1_lri_slf = .     if ilo_lfs!=1
		        lab var ilo_job1_lri_slf "Monthly labour related income of self-employed - main job"
			
    *************
    * SECOND JOB:
    *************
	
	* Employees
	egen ilo_job2_lri_ees = rowtotal(v9982 v9985) if ilo_job2_ste_aggregate==1,m
		replace ilo_job2_lri_ees = .     if ilo_mjh!=2
		        lab var ilo_job2_lri_ees "Monthly earnings of employees - second job"
		
    * Self-employed		
	egen ilo_job2_lri_slf = rowtotal(v9982 v9985) if ilo_job2_ste_aggregate==2,m
		replace ilo_job2_lri_slf = .     if ilo_mjh!=2
		        lab var ilo_job2_lri_slf "Monthly labour related income of self-employed - second job"
		 		
* ------------------------------------------------------------------------------
********************************************************************************
*                                                                              *
*	          PART 3.2 ECONOMIC CHARACTERISTICS FOR ALL JOBS                   *
*                                                                              * 
********************************************************************************
* ------------------------------------------------------------------------------				

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_tru') 		                       *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: there is lack of information to compute this variable

 
			
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
*	Cases of non-fatal occupational injury ('ilo_joball_oi_case') 		       *
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
* Comment: lack of information

 

*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
*  Days lost due to cases of occupational injury ('ilo_joball_oi_day')		   *
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
* Comment: no info
 
				
* ------------------------------------------------------------------------------
********************************************************************************
*                                                                              *
*	          PART 3.3 UNEMPLOYMENT: ECONOMIC CHARACTERISTICS                  *
*                                                                              * 
********************************************************************************
* ------------------------------------------------------------------------------				

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			Category of unemployment ('ilo_cat_une') 	                       * 
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: this question cannot be computed due to the skip pattern 

/* 
destring v9067, replace
destring v9068, replace
destring v9069, replace
destring v9106, replace
destring v9107, replace
destring v9108, replace

 	
	gen ilo_cat_une=.
	   * replace ilo_cat_une=1 if (v9067==1|v9068==2|v9069==1) & ilo_lfs==2                     // Previously employed 
		replace ilo_cat_une=1 if (v9106==2|v9107==1|v9108==2) & ilo_lfs==2                     // Previously employed 
		*replace ilo_cat_une=2 if  (v9067==3|v9068==4|v9069==3) & ilo_lfs==2                     // Seeking for the first time
		replace ilo_cat_une=2 if  (v9106==4|v9107==3|v9108==4) & ilo_lfs==2                     // Seeking for the first time
		replace ilo_cat_une=3 if ilo_cat_une==. & ilo_lfs==2           // Unknown
			    lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
			    lab val ilo_cat_une cat_une_lab
			    lab var ilo_cat_une "Category of unemployment"
 */				
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			   Duration of unemployment ('ilo_dur')  	                       * 
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*Comment: this variable is not possible to compute.
		
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4') 	               * 
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 

  
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu_isco08') 		                   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 

 * ------------------------------------------------------------------------------
********************************************************************************
*                                                                              *
*	        PART 3.4 OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS            *
*                                                                              * 
********************************************************************************
* ------------------------------------------------------------------------------				

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*		Degree of labour market attachment ('ilo_olf_dlma') 	               * 
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: this variable cannot be computed computed because there is not information on availability or willingness.

 
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			Reasons for not seeking a job ('ilo_olf_reason') 	               *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: there is no information about reasons for not seeking a job



* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			      Discouraged job-seekers ('ilo_dis') 		                   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: there is no information about availability or reason for not seeking a job.

 
			
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*  Youth not in education, employment or training (NEETs) ('ilo_neet') 		   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment:

	  gen ilo_neet=1 if ilo_age_aggregate==2 & ilo_lfs!=1 & ilo_edu_attendance==2
		  lab def neet_lab 1 "Youth not in education, employment or training"
		  lab val ilo_neet neet_lab
		  lab var ilo_neet "Youth not in education, employment or training"	

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			                    SAVE RESULTS                                   *            
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

* ------------------------------------------------------------------------------
*                       Preparation of final dataset                           *
* ------------------------------------------------------------------------------

cd "$outpath"
	drop ilo_age
	
	
		
	/* Save dataset including original and ilo variables*/
	save ${country}_${source}_${time}_FULL,  replace		
	
	*Save file only containing ilo_* variables
	keep ilo*
	save ${country}_${source}_${time}_ILO, replace
		
