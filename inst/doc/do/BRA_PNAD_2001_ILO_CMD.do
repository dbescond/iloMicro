* TITLE OF DO FILE: ILO Microdata Preprocessing code template - BRAZIL, 2001
* DATASET USED: BRAZIL, PNAD, 2001
* NOTES: 
* Files created: Standard variables BRA_PNAD_2001_FULL.dta and BRA_PNAD_2001_ILO.dta
* Authors: ILO / Department of Statistics / DPAU
* Starting Date: 10 April 2018
* Last updated:  13 April 2018
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
global time "2001"  
global inputFile "BRA_PNAD_PES_2001.dta" 
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
*			           Marital status ('ilo_mrts') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
				
** Comment: there is no information to compute this variable. 				
				
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

    *---------------------------------------------------------------------------
	* ISIC REV 3.1
	*---------------------------------------------------------------------------

    ***********
    * MAIN JOB:
    ***********

destring v9907, replace



** Comment: For 2001 and after, it can be only done the classification at 1-digit level. The national classification used in this case is different than the most recent one. 

	* 1-digit level	
    gen ilo_job1_eco_isic3=.
		replace ilo_job1_eco_isic3=1 if inrange(v9907,011,037) & ilo_lfs==1
		replace ilo_job1_eco_isic3=2 if v9907==041 & ilo_lfs==1
		replace ilo_job1_eco_isic3=3 if inrange(v9907,050,059) & ilo_lfs==1
		replace ilo_job1_eco_isic3=4 if (inrange(v9907,100,300) | v9907==532) & ilo_lfs==1 
		replace ilo_job1_eco_isic3=5 if inrange(v9907,351,352) & ilo_lfs==1
		replace ilo_job1_eco_isic3=6 if v9907==340 & ilo_lfs==1
		replace ilo_job1_eco_isic3=7 if (inrange(v9907,410,424) | inrange(v9907,521,525)) & ilo_lfs==1
		replace ilo_job1_eco_isic3=8 if inlist(v9907,511,512) & ilo_lfs==1
		replace ilo_job1_eco_isic3=9 if inlist(v9907,451,471,472,473,474,475,476,477,481,482,552,586,587,588) & ilo_lfs==1
		replace ilo_job1_eco_isic3=10 if inlist(v9907,452,462) & ilo_lfs==1
		replace ilo_job1_eco_isic3=11 if (inlist(v9907,461,464,589) | inrange(v9907,571,584)) & ilo_lfs==1
		replace ilo_job1_eco_isic3=12 if (v9907==453 | inrange(v9907,711,727)) & ilo_lfs==1
		replace ilo_job1_eco_isic3=13 if inlist(v9907,631,632) & ilo_lfs==1
		replace ilo_job1_eco_isic3=14 if (inrange(v9907,610,612) | inrange(v9907,621,624)) & ilo_lfs==1 & ilo_lfs==1
		replace ilo_job1_eco_isic3=15 if inlist(v9907,354,463,531,533,541,542,543,551,585,613,614,615,617,618,619,901,902) & ilo_lfs==1
		replace ilo_job1_eco_isic3=16 if inlist(v9907,544,545) & ilo_lfs==1
		replace ilo_job1_eco_isic3=17 if v9907==801 & ilo_lfs==1
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
	


	* 1-digit level	
      gen ilo_job2_eco_isic3=.
		replace ilo_job2_eco_isic3=1 if inrange(v9991,011,037) & ilo_mjh==2
		replace ilo_job2_eco_isic3=2 if v9991==041 & ilo_mjh==2
		replace ilo_job2_eco_isic3=3 if inrange(v9991,050,059) & ilo_mjh==2
		replace ilo_job2_eco_isic3=4 if (inrange(v9991,100,300) | v9991==532) & ilo_mjh==2 
		replace ilo_job2_eco_isic3=5 if inrange(v9991,351,352) & ilo_mjh==2
		replace ilo_job2_eco_isic3=6 if v9991==340 & ilo_mjh==2
		replace ilo_job2_eco_isic3=7 if (inrange(v9991,410,424) | inrange(v9991,521,525)) & ilo_mjh==2
		replace ilo_job2_eco_isic3=8 if inlist(v9991,511,512) & ilo_mjh==2
		replace ilo_job2_eco_isic3=9 if inlist(v9991,451,471,472,473,474,475,476,477,481,482,552,586,587,588) & ilo_mjh==2
		replace ilo_job2_eco_isic3=10 if inlist(v9991,452,462) & ilo_mjh==2
		replace ilo_job2_eco_isic3=11 if (inlist(v9991,461,464,589) | inrange(v9991,571,584)) & ilo_mjh==2
		replace ilo_job2_eco_isic3=12 if (v9991==453 | inrange(v9991,711,727)) & ilo_mjh==2
		replace ilo_job2_eco_isic3=13 if inlist(v9991,631,632) & ilo_mjh==2
		replace ilo_job2_eco_isic3=14 if (inrange(v9991,610,612) | inrange(v9991,621,624)) & ilo_mjh==2 & ilo_mjh==2
		replace ilo_job2_eco_isic3=15 if inlist(v9991,354,463,531,533,541,542,543,551,585,613,614,615,617,618,619,901,902) & ilo_mjh==2
		replace ilo_job2_eco_isic3=16 if inlist(v9991,544,545) & ilo_mjh==2
		replace ilo_job2_eco_isic3=17 if v9991==801 & ilo_mjh==2
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
			
    * 1-digit level
	gen ilo_job1_ocu_isco88=.
		    replace ilo_job1_ocu_isco88=1 if inrange(v9906,001,040) & ilo_lfs==1                                                                  // 1 - Legislators, senior officials and managers
			
		    replace ilo_job1_ocu_isco88=2 if (inrange(v9906,101,104) | inrange(v9906,121,125) | inrange(v9906,141,152) | ///
			                                   inrange(v9906,171,182) | inrange(v9906,201,233) | inrange(v9906,251,261) | ///
											   inrange(v9906,291,293)) & ilo_lfs==1                                                               // 2 - Professionals
											   
			replace ilo_job1_ocu_isco88=3 if (inrange(v9906,050,051) | inrange(v9906,111,113) | inrange(v9906,131,133) | ///
			                                  inrange(v9906,153,168) | inrange(v9906,183,194) | inrange(v9906,241,244) | ///
											  inrange(v9906,271,283) | inrange(v9906,711,712) | inrange(v9906,831,834) | v9906==918) & ilo_lfs==1  // 3 - Technicians and associate professionals

			replace ilo_job1_ocu_isco88=4 if (inrange(v9906,052,064) | inrange(v9906,551,557) | inrange(v9906,771,775)) & ilo_lfs==1               // 4 - Clerks
			
			replace ilo_job1_ocu_isco88=5 if (inrange(v9906,601,605) | inrange(v9906,631,646) | inrange(v9906,801,826) | v9906==852) & ilo_lfs==1  // 5 - Service workers and shop and market sales workers
			
		    replace ilo_job1_ocu_isco88=6 if (inrange(v9906,301,336)  | v9906==851) & ilo_lfs==1                                                   // 6 - Skilled agricultural and fishery workers
			
		    replace ilo_job1_ocu_isco88=7 if (inrange(v9906,341,520)  | inrange(v9906,531,545) | inrange(v9906,561,589)) & ilo_lfs==1              // 7 - Craft and related trades workers
			
		    replace ilo_job1_ocu_isco88=8 if (v9906==521 | inrange(v9906,721,727)  | inrange(v9906,741,762) | inrange(v9906,922,923)) & ilo_lfs==1   // 8 - Plant and machine operators and assemblers

		    replace ilo_job1_ocu_isco88=9 if (inrange(v9906,611,621)  | inrange(v9906,731,732) | inrange(v9906,841,845) | ///
			                                      inrange(v9906,911,917) | inrange(v9906,919,921) | inrange(v9906,924,926)) & ilo_lfs==1              // 9 - Elementary occupations
												  
			
            replace ilo_job1_ocu_isco88=10 if inrange(v9906,861,869) & ilo_lfs==1                                                                    // 0 - Armed forces
			
			replace ilo_job1_ocu_isco88=11 if (inrange(v9906,927,928) | ilo_job1_ocu_isco88==.) & ilo_lfs==1                                          // 11 - Not elsewhere classified
											
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

  * 1-digit level
	gen ilo_job2_ocu_isco88=.
		    replace ilo_job2_ocu_isco88=1 if inrange(v9990,001,040) & ilo_mjh==2                                                                  // 1 - Legislators, senior officials and managers
			
		    replace ilo_job2_ocu_isco88=2 if (inrange(v9990,101,104) | inrange(v9990,121,125) | inrange(v9990,141,152) | ///
			                                   inrange(v9990,171,182) | inrange(v9990,201,233) | inrange(v9990,251,261) | ///
											   inrange(v9990,291,293)) & ilo_mjh==2                                                               // 2 - Professionals
											   
			replace ilo_job2_ocu_isco88=3 if (inrange(v9990,050,051) | inrange(v9990,111,113) | inrange(v9990,131,133) | ///
			                                  inrange(v9990,153,168) | inrange(v9990,183,194) | inrange(v9990,241,244) | ///
											  inrange(v9990,271,283) | inrange(v9990,711,712) | inrange(v9990,831,834) | v9990==918) & ilo_mjh==2   // 3 - Technicians and associate professionals

			replace ilo_job2_ocu_isco88=4 if (inrange(v9990,052,064) | inrange(v9990,551,557) | inrange(v9990,771,775)) & ilo_mjh==2               // 4 - Clerks
			
			replace ilo_job2_ocu_isco88=5 if (inrange(v9990,601,605) | inrange(v9990,631,646) | inrange(v9990,801,826) | v9990==852) & ilo_mjh==2   // 5 - Service workers and shop and market sales workers
			
		    replace ilo_job2_ocu_isco88=6 if (inrange(v9990,301,336)  | v9990==851) & ilo_mjh==2                                                   // 6 - Skilled agricultural and fishery workers
			
		    replace ilo_job2_ocu_isco88=7 if (inrange(v9990,341,520)  | inrange(v9990,531,545) | inrange(v9990,561,589)) & ilo_mjh==2              // 7 - Craft and related trades workers
			
		    replace ilo_job2_ocu_isco88=8 if (v9990==521 | inrange(v9990,721,727)  | inrange(v9990,741,762) | inrange(v9990,922,923)) & ilo_mjh==2   // 8 - Plant and machine operators and assemblers

		    replace ilo_job2_ocu_isco88=9 if (inrange(v9990,611,621)  | inrange(v9990,731,732) | inrange(v9990,841,845) | ///
			                                      inrange(v9990,911,917) | inrange(v9990,919,921) | inrange(v9990,924,926)) & ilo_mjh==2              // 9 - Elementary occupations
												  
			
            replace ilo_job2_ocu_isco88=10 if inrange(v9990,861,869) & ilo_mjh==2                                                                     // 0 - Armed forces
			
			replace ilo_job2_ocu_isco88=11 if (inrange(v9990,927,928) | ilo_job2_ocu_isco88==.) & ilo_mjh==2                                         // 11 - Not elsewhere classified
											
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
* Comment: no possible to compute

/* Useful questions:
          - Institutional sector: v9032
		  - Private household identification: 
		  - Destination of production: no info.- the period of time referred to in the question related to "produces for sale" (v9025) is not the reference week
		  - Bookkeeping: no info
		  - Registration: v90531 (no info before 2009 - therefore, it is not possible to compute informality)
		  - Status in employment: v9008, v9029
		  - Social security contribution (Proxy: pension funds): v9059
		  - Place of work: v9054 
		  - Size:
		  - Paid annual leave:
		  - Paid sick leave:
*/
    * Social Security:
 
 destring v9059, replace
 
	gen social_security=.
	    replace social_security=1 if v9059==1  &  ilo_lfs==1          // social security (proxy)
		replace social_security=2 if v9059==3  &  ilo_lfs==1          // no social security (proxy)

 /*	
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
 
 */
 
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
		
