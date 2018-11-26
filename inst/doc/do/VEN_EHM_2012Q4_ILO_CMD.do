* TITLE OF DO FILE: ILO Microdata Preprocessing code template - VENEZUELA, 2012Q4
* DATASET USED: VENEZUELA, EHM, 2012Q4
* NOTES: 
* Files created: Standard variables VEN_EHM_2012Q4_FULL.dta and VEN_EHM_2012Q4_ILO.dta
* Authors: ILO / Department of Statistics / DPAU
* Starting Date: 29 May 2018
* Last updated: 15 August 2018
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
global country "VEN"
global source "EHM"
global time "2012Q4"
global inputFile "per122"
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

	gen ilo_key=_n
		lab var ilo_key "Key unique identifier per individual"
	
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*		             	 Sample Weight ('ilo_wgt') 		                       *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

	gen ilo_wgt=.
	    replace ilo_wgt=peso 
		lab var ilo_wgt "Sample weight"
	
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			                Time period ('ilo_time')		                   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

	gen ilo_time=1
		lab def time_lab 1 "$time"
		lab val ilo_time time_lab
		lab var ilo_time "Time (Gregorian Calendar)"
		
	
*---------
* create local for time period
*---------

   decode ilo_time, gen(to_drop)
   split to_drop, generate(to_drop_) parse(Q)
   destring to_drop_1, replace force
   capture destring to_drop_2, replace force
   capture gen to_drop_2=-9999
   local Q = to_drop_2 in 1
   local Y = to_drop_1 in 1

* ------------------------------------------------------------------------------
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
* Comment: - No information available.
	
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			                     Sex ('ilo_sex') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 
	
	gen ilo_sex=.
	    replace ilo_sex=1 if pp18=="1"            // Male
		replace ilo_sex=2 if pp18=="2"            // Female
		        label define label_Sex 1 "1 - Male" 2 "2 - Female"
		        label values ilo_sex label_Sex
		        lab var ilo_sex "Sex"

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			                    Age ('ilo_age') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

	destring pp20, replace
	
	gen ilo_age=.
	    replace ilo_age=pp20 
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
* Comment: - Category "7 - Master's or equivalent level" includes category "8 - 
*            Doctoral or equivalent level". [C3:4158].
*          - Only asked to persons aged 3 years old or more and therefore those
*            aged less are classified under not elsewhere classified.

				
    *---------------------------------------------------------------------------
	* ISCED 11
	*---------------------------------------------------------------------------
				
    * Detailed				
    gen ilo_edu_isced11=.
		replace ilo_edu_isced11=1 if pp25a=="01"                                               // No schooling
		replace ilo_edu_isced11=2 if pp25a=="02"                                               // Early childhood education
		replace ilo_edu_isced11=3 if pp25a=="03"                                               // Primary education
		replace ilo_edu_isced11=4 if pp25a=="04" & inlist(pp25b,"-1","-3","01","02","03")      // Lower secondary education
		replace ilo_edu_isced11=5 if pp25a=="04" & inlist(pp25b,"04","05","06")                // Upper secondary education
		* replace ilo_edu_isced11=6 if                                                         // Post-secondary non-tertiary education
		replace ilo_edu_isced11=7 if pp25a=="05"                                               // Short-cycle tertiary education
		replace ilo_edu_isced11=8 if pp25a=="06"                                               // Bachelor's or equivalent level
		replace ilo_edu_isced11=9 if pp25a=="07"                                               // Master's or equivalent level
		* replace ilo_edu_isced11=10 if                                                        // Doctoral or equivalent level
		replace ilo_edu_isced11=11 if ilo_edu_isced11==.                                       // Not elsewhere classified
			    label def isced_11_lab 1 "X - No schooling" 2 "0 - Early childhood education" 3 "1 - Primary education" 4 "2 - Lower secondary education" ///
				                       5 "3 - Upper secondary education" 6 "4 - Post-secondary non-tertiary education" 7 "5 - Short-cycle tertiary education" 8 "6 - Bachelor's or equivalent level" ///
									   9 "7 - Master's or equivalent level" 10 "8 - Doctoral or equivalent level" 11 "9 - Not elsewhere classified"
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

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*		  	 Educational attendance ('ilo_edu_attendance') 		               *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: - Only asked to those aged 3 years old or more and therefore those aged
*            less than 3 are classified under "not elsewhere classified".
			
    gen ilo_edu_attendance=.
		replace ilo_edu_attendance=1 if pp27=="1"                               // Attending
		replace ilo_edu_attendance=2 if pp27=="2"                               // Not attending
		replace ilo_edu_attendance=3 if ilo_edu_attendance==.                   // Not elsewhere classified
			    lab def edu_attendance_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
			    lab val ilo_edu_attendance edu_attendance_lab
			    lab var ilo_edu_attendance "Education (Attendance)"

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			           Marital status ('ilo_mrts') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: - Only asked to persons aged 12 years old or more and therefore those
*            aged less are classified under "not elsewhere classified".
	
	* Detailed
	gen ilo_mrts_details=.
	    replace ilo_mrts_details=1 if pp21=="07"                                // Single
		replace ilo_mrts_details=2 if inlist(pp21,"01","02")                    // Married
		replace ilo_mrts_details=3 if inlist(pp21,"03","04")                    // Union / cohabiting
		replace ilo_mrts_details=4 if pp21=="06"                                // Widowed
		replace ilo_mrts_details=5 if pp21=="05"                                // Divorced / separated
		replace ilo_mrts_details=6 if ilo_mrts_details==.			            // Not elsewhere classified
		        label define label_mrts_details 1 "1 - Single" 2 "2 - Married" 3 "3 - Union / cohabiting" ///
				                                4 "4 - Widowed" 5 "5 - Divorced / separated" 6 "6 - Not elsewhere classified"
		        label values ilo_mrts_details label_mrts_details
		        lab var ilo_mrts_details "Marital status"
				
	* Aggregate
	gen ilo_mrts_aggregate=.
	    replace ilo_mrts_aggregate=1 if inlist(ilo_mrts_details,1,4,5)          // Single / Widowed / Divorced / Separated
		replace ilo_mrts_aggregate=2 if inlist(ilo_mrts_details,2,3)            // Married / Union / Cohabiting
		replace ilo_mrts_aggregate=3 if ilo_mrts_aggregate==. 			        // Not elsewhere classified
		        label define label_mrts_aggregate 1 "1 - Single / Widowed / Divorced / Separated" 2 "2 - Married / Union / Cohabiting" 3 "3 - Not elsewhere classified"
		        label values ilo_mrts_aggregate label_mrts_aggregate
		        lab var ilo_mrts_aggregate "Marital status (Aggregate levels)"				
				
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			Disability status ('ilo_dsb_details')                              *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: - No information available.
				
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
* Comment: 	- It differs from the national reported number due to the age coverage
*             (the national minimum age is set at 10 years old whereas here it is
*             set at 15 years old). 

	gen ilo_wap=.
		replace ilo_wap=1 if ilo_age>=15 & ilo_age!=.
			    label var ilo_wap "Working age population"
		
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			       Labour Force Status ('ilo_lfs')                             *       
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: - Employment comprises those who answered yes to working for pay/profit
*            (in cash or in kind) during the reference week, as a support/auxiliar
*            worker and those who are temporary absent
*          - Unemployment includes people not in employment and seeking for a job
*            during the last month; even though the questionnaire includes a question
*            regarding the availability, it is not part of the dataset and the 
*            definition is left as with two criteria. [note to value: T5:1429]. 
*            It does not include the available future starters as they cannot be
*            identified.
	
	gen ilo_lfs=.
        replace ilo_lfs=1 if (inlist(pp29,"01","02") | pp30=="01") & ilo_wap==1			// Employed: ILO definition
	    replace ilo_lfs=1 if (pp29=="03" & pp32=="01") & ilo_wap==1                     // Employed: temporary absent
		replace ilo_lfs=1 if (pp31=="01" & pp32=="01") & ilo_wap==1                     // Employed: temporary absent
		replace ilo_lfs=2 if (pp39=="01") & ilo_lfs!=1 & ilo_wap==1			            // Unemployed: two criteria
	    replace ilo_lfs=3 if !inlist(ilo_lfs,1,2) & ilo_wap==1		                    // Outside the labour force
				label define label_ilo_lfs 1 "1 - Employed" 2 "2 - Unemployed" 3 "3 - Outside Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status" 
				
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			       Multiple job holders ('ilo_mjh')                            *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

    gen ilo_mjh=.
		replace ilo_mjh=2 if (pp33a=="01") & ilo_lfs==1          // More than one job
		replace ilo_mjh=1 if ilo_mjh==. & ilo_lfs==1             // One job only     
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
* Comment: - No information available for the secondary job.
*          - "Sociedad de personas" is classified as "Members of producers' cooperatives"

   * MAIN JOB:
   * ICSE 1993
	 gen ilo_job1_ste_icse93=.
		 replace ilo_job1_ste_icse93=1 if inlist(pp54, "01", "02", "03", "04") & ilo_lfs==1          // Employees
		 replace ilo_job1_ste_icse93=2 if pp54=="08" & ilo_lfs==1                                    // Employers
		 replace ilo_job1_ste_icse93=3 if pp54=="07" & ilo_lfs==1                                    // Own-account workers
		 replace ilo_job1_ste_icse93=4 if inlist(pp54, "05", "06") & ilo_lfs==1                      // Members of producers' cooperatives
		 replace ilo_job1_ste_icse93=5 if pp54=="09" & ilo_lfs==1                                    // Contributing family workers
		 replace ilo_job1_ste_icse93=6 if ilo_job1_ste_icse93==. & ilo_lfs==1                        // Workers not classifiable by status
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

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			            Economic activity ('ilo_eco')                          *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

    ***********
    * MAIN JOB:
    ***********
	destring pp49, replace force
	
    *---------------------------------------------------------------------------
	* ISIC REV 3.1
	*---------------------------------------------------------------------------
	
	* 2-digit level
	gen ilo_job1_eco_isic3_2digits = .
        replace ilo_job1_eco_isic3_2digits = 1 if inlist(pp49, 111,112,113) & ilo_lfs==1
        replace ilo_job1_eco_isic3_2digits = 2 if inlist(pp49,121,122) & ilo_lfs==1
        replace ilo_job1_eco_isic3_2digits = 5 if pp49==130 & ilo_lfs==1
        replace ilo_job1_eco_isic3_2digits = 10 if pp49==210 & ilo_lfs==1
        replace ilo_job1_eco_isic3_2digits = 11 if pp49==220 & ilo_lfs==1
        * replace ilo_job1_eco_isic3_2digits = 12 if  & ilo_lfs==1
        replace ilo_job1_eco_isic3_2digits = 13 if pp49==230 & ilo_lfs==1
        replace ilo_job1_eco_isic3_2digits = 14 if pp49==290 & ilo_lfs==1
        replace ilo_job1_eco_isic3_2digits = 15 if inlist(pp49,311,312,313) & ilo_lfs==1
        replace ilo_job1_eco_isic3_2digits = 16 if pp49==314 & ilo_lfs==1
        replace ilo_job1_eco_isic3_2digits = 17 if pp49==321 & ilo_lfs==1
        replace ilo_job1_eco_isic3_2digits = 18 if pp49==322 & ilo_lfs==1
        replace ilo_job1_eco_isic3_2digits = 19 if inlist(pp49,323,324) & ilo_lfs==1
        replace ilo_job1_eco_isic3_2digits = 20 if inlist(pp49,331,332) & ilo_lfs==1
        replace ilo_job1_eco_isic3_2digits = 21 if pp49==341 & ilo_lfs==1
        replace ilo_job1_eco_isic3_2digits = 22 if pp49==342 & ilo_lfs==1
        replace ilo_job1_eco_isic3_2digits = 23 if inlist(pp49,353,354) & ilo_lfs==1
        replace ilo_job1_eco_isic3_2digits = 24 if inlist(pp49,351,352) & ilo_lfs==1
        replace ilo_job1_eco_isic3_2digits = 25 if inlist(pp49,355,356) & ilo_lfs==1
        replace ilo_job1_eco_isic3_2digits = 26 if inlist(pp49,361,362,369) & ilo_lfs==1
        replace ilo_job1_eco_isic3_2digits = 27 if inlist(pp49,371,372) & ilo_lfs==1
        replace ilo_job1_eco_isic3_2digits = 28 if pp49==381 & ilo_lfs==1
        replace ilo_job1_eco_isic3_2digits = 29 if inlist(pp49,382,383) & ilo_lfs==1
        * replace ilo_job1_eco_isic3_2digits = 30 if  & ilo_lfs==1
        * replace ilo_job1_eco_isic3_2digits = 31 if  & ilo_lfs==1
        * replace ilo_job1_eco_isic3_2digits = 32 if  & ilo_lfs==1
        * replace ilo_job1_eco_isic3_2digits = 33 if  & ilo_lfs==1
        replace ilo_job1_eco_isic3_2digits = 34 if pp49==384 & ilo_lfs==1
        * replace ilo_job1_eco_isic3_2digits = 35 if  & ilo_lfs==1
        replace ilo_job1_eco_isic3_2digits = 36 if inlist(pp49,385,390) & ilo_lfs==1
        * replace ilo_job1_eco_isic3_2digits = 37 if  & ilo_lfs==1
        replace ilo_job1_eco_isic3_2digits = 40 if pp49==410 & ilo_lfs==1
        replace ilo_job1_eco_isic3_2digits = 41 if pp49==420 & ilo_lfs==1
        replace ilo_job1_eco_isic3_2digits = 45 if pp49==500 & ilo_lfs==1
        * replace ilo_job1_eco_isic3_2digits = 50 if  & ilo_lfs==1
        replace ilo_job1_eco_isic3_2digits = 51 if pp49==610 & ilo_lfs==1
        replace ilo_job1_eco_isic3_2digits = 52 if pp49==620 & ilo_lfs==1
        replace ilo_job1_eco_isic3_2digits = 55 if inlist(pp49,631,632) & ilo_lfs==1
        replace ilo_job1_eco_isic3_2digits = 60 if pp49==711 & ilo_lfs==1
        replace ilo_job1_eco_isic3_2digits = 61 if pp49==712 & ilo_lfs==1
        replace ilo_job1_eco_isic3_2digits = 62 if pp49==713 & ilo_lfs==1
        replace ilo_job1_eco_isic3_2digits = 63 if pp49==719 & ilo_lfs==1
        replace ilo_job1_eco_isic3_2digits = 64 if pp49==720 & ilo_lfs==1
        replace ilo_job1_eco_isic3_2digits = 65 if pp49==810 & ilo_lfs==1
        replace ilo_job1_eco_isic3_2digits = 66 if pp49==820 & ilo_lfs==1
        * replace ilo_job1_eco_isic3_2digits = 67 if  & ilo_lfs==1
        replace ilo_job1_eco_isic3_2digits = 70 if inlist(pp49,831,832) & ilo_lfs==1
        replace ilo_job1_eco_isic3_2digits = 71 if pp49==833 & ilo_lfs==1
        * replace ilo_job1_eco_isic3_2digits = 72 if  & ilo_lfs==1
        * replace ilo_job1_eco_isic3_2digits = 73 if  & ilo_lfs==1
        * replace ilo_job1_eco_isic3_2digits = 74 if  & ilo_lfs==1
        replace ilo_job1_eco_isic3_2digits = 75 if inlist(pp49,910,911,912) & ilo_lfs==1
        replace ilo_job1_eco_isic3_2digits = 80 if inlist(pp49,931,932) & ilo_lfs==1
        replace ilo_job1_eco_isic3_2digits = 85 if inlist(pp49,933,934) & ilo_lfs==1
        replace ilo_job1_eco_isic3_2digits = 90 if pp49==920 & ilo_lfs==1
        replace ilo_job1_eco_isic3_2digits = 91 if inlist(pp49,935,939) & ilo_lfs==1
        replace ilo_job1_eco_isic3_2digits = 92 if inlist(pp49,941,942,949) & ilo_lfs==1
        replace ilo_job1_eco_isic3_2digits = 93 if inlist(pp49,951,952,959) & ilo_lfs==1
        replace ilo_job1_eco_isic3_2digits = 95 if pp49==953 & ilo_lfs==1
        * replace ilo_job1_eco_isic3_2digits = 96 if  & ilo_lfs==1
        * replace ilo_job1_eco_isic3_2digits = 97 if  & ilo_lfs==1
        replace ilo_job1_eco_isic3_2digits = 99 if pp49==960 & ilo_lfs==1
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
	   
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			               Occupation ('ilo_ocu') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: - Category 2 "Professionals" includes category 3 "Technicians and 
*            associate professionals". (note to value -> C4:1002)

    ***********
    * MAIN JOB:
    ***********
    
	destring pp48, replace force
    *---------------------------------------------------------------------------
	* ISCO 88
	*---------------------------------------------------------------------------
			
    * 1-digit level
	gen ilo_job1_ocu_isco88=.
        replace ilo_job1_ocu_isco88 = 1 if inrange(pp48,10,19) & ilo_lfs==1
        replace ilo_job1_ocu_isco88 = 2 if inrange(pp48,0,9) | pp48==91 & ilo_lfs==1  // Includes category 3
        * replace ilo_job1_ocu_isco88 = 3 if  
        replace ilo_job1_ocu_isco88 = 4 if inrange(pp48,20,23) & ilo_lfs==1
        replace ilo_job1_ocu_isco88 = 5 if inrange(pp48,25,29) | inrange(pp48,80,89) & ilo_lfs==1
        replace ilo_job1_ocu_isco88 = 6 if inrange(pp48,30,35) & ilo_lfs==1
        replace ilo_job1_ocu_isco88 = 7 if inrange(pp48,60,79) & ilo_lfs==1
        replace ilo_job1_ocu_isco88 = 8 if inrange(pp48,60,79) | inrange(pp48,50,59) & ilo_lfs==1
        replace ilo_job1_ocu_isco88 = 9 if inrange(pp48,40,49) & ilo_lfs==1
        replace ilo_job1_ocu_isco88 = 10 if pp48==90 & ilo_lfs==1
        replace ilo_job1_ocu_isco88 = 11 if ilo_job1_ocu_isco88==. & ilo_lfs==1
		        lab def ocu_isco88_1digit 1 "1 - Legislators, senior officials and managers"	2 "2 - Professionals"	3 "3 - Technicians and associate professionals"	4 "4 - Clerks"	///
                                          5 "5 - Service workers and shop and market sales workers"	6 "6 - Skilled agricultural and fishery workers"	7 "7 - Craft and related trades workers"	8 "8 - Plant and machine operators and assemblers"	///
                                          9 "9 - Elementary occupations"	10 "0 - Armed forces"	11 "11 - Not elsewhere classified"		
				lab val ilo_job1_ocu_isco88 ocu_isco88_1digit
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
	    replace ilo_job1_ocu_skill=1 if ilo_job1_ocu_isco88==9                  // Low
		replace ilo_job1_ocu_skill=2 if inlist(ilo_job1_ocu_isco88,4,5,6,7,8)   // Medium
		replace ilo_job1_ocu_skill=3 if inlist(ilo_job1_ocu_isco88,1,2,3)       // High
		replace ilo_job1_ocu_skill=4 if inlist(ilo_job1_ocu_isco88,10,11)       // Not elsewhere classified
				lab def ocu_skill_lab 1 "1 - Skill level 1 (low)" 2 "2 - Skill level 2 (medium)" 3 "3 - Skill levels 3 and 4 (high)" 4 "4 - Not elsewhere classified"
			    lab val ilo_job1_ocu_skill ocu_skill_lab
			    lab var ilo_job1_ocu_skill "Occupation (Skill level) - main job"

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*	Institutional sector of economic activities ('ilo_ins_sector')		       *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

	gen ilo_job1_ins_sector=.
		replace ilo_job1_ins_sector=1 if inlist(pp54,"01","02") & ilo_lfs==1    // Public
		replace ilo_job1_ins_sector=2 if ilo_job1_ins_sector==. & ilo_lfs==1    // Private
			    lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
			    lab values ilo_job1_ins_sector ins_sector_lab
			    lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities - main job"
		
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*		               Hours of work ('ilo_how')  	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: - No information available for secondary job.
				
    ***********
    * MAIN JOB:
    ***********
	
	* Hours USUALLY worked
    destring pp35, replace
	gen ilo_job1_how_usual = .
	    replace ilo_job1_how_usual = pp35 if ilo_lfs==1
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

	* Hours ACTUALLY worked
	destring pp34, replace
	gen ilo_job1_how_actual = .
	    replace ilo_job1_how_actual = pp34 if ilo_lfs==1
		        lab var ilo_job1_how_actual "Weekly hours actually worked - main job"
		
    gen ilo_job1_how_actual_bands=.
	    replace ilo_job1_how_actual_bands=1 if ilo_job1_how_actual==0
	    replace ilo_job1_how_actual_bands=2 if ilo_job1_how_actual>=1 & ilo_job1_how_actual<=14
	    replace ilo_job1_how_actual_bands=3 if ilo_job1_how_actual>14 & ilo_job1_how_actual<=29
	    replace ilo_job1_how_actual_bands=4 if ilo_job1_how_actual>29 & ilo_job1_how_actual<=34
	    replace ilo_job1_how_actual_bands=5 if ilo_job1_how_actual>34 & ilo_job1_how_actual<=39
	    replace ilo_job1_how_actual_bands=6 if ilo_job1_how_actual>39 & ilo_job1_how_actual<=48
	    replace ilo_job1_how_actual_bands=7 if ilo_job1_how_actual>48 & ilo_job1_how_actual!=.
	    replace ilo_job1_how_actual_bands=8 if ilo_job1_how_actual_bands==. & ilo_lfs==1
	    replace ilo_job1_how_actual_bands=. if ilo_lfs!=1
		   	    lab def how_bands_act 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"		
				lab val ilo_job1_how_actual_bands how_bands_act
				lab var ilo_job1_how_actual_bands "Weekly hours actually worked bands - main job"

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job_time')		                   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: - Based on the median of the usual hours of work in MAIN job, 
*            computed at: 40 hours per week.
			
	gen ilo_job1_job_time=.
		replace ilo_job1_job_time=2 if ilo_job1_how_usual>=40  & ilo_lfs==1                            // Full-time
		replace ilo_job1_job_time=1 if ilo_job1_how_usual<40 & ilo_job1_how_usual!=. & ilo_lfs==1      // Part-time
		replace ilo_job1_job_time=3 if ilo_job1_job_time==. & ilo_lfs==1
			    lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
			    lab val ilo_job1_job_time job_time_lab
			    lab var ilo_job1_job_time "Job (Working time arrangement)"
			
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*		    	Type of contract ('ilo_job_contract') 		                   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: - Asked only to employees.

if (`Y' == 2012 & `Q' == 4) {		
	gen ilo_job1_job_contract=.
		replace ilo_job1_job_contract=1 if pp57=="01" & ilo_lfs==1                  // Permanent
		replace ilo_job1_job_contract=2 if pp57=="02" & ilo_lfs==1               	// Temporary
		replace ilo_job1_job_contract=3 if ilo_job1_job_contract==. & ilo_lfs==1  	// Unknown
			    lab def job_contract_lab 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"
			    lab val ilo_job1_job_contract job_contract_lab
			    lab var ilo_job1_job_contract "Job (Type of contract)"
}
else{
    *No information available
}				

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*  Informal/formal economy: ('ilo_job1_ife_prod'/'ilo_job1_ife_nature') 	   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: - Not defined due to the lack of minimum information (even
*            though bookkeeping and registration questions are part of the 
*            questionnaire, they are not part of the dataset).

/* Useful questions:
          - Institutional sector: pp54
		  - Private household identification: ilo_job1_eco_isic3_2digits==95
		  - Destination of production: not asked.
		  - Bookkeeping: even though it is part of the questionnaire, it is not part of the dataset
		  - Registration: even though it is part of the questionnaire, it is not part of the dataset
		  - Status in employment: ilo_job1_ste_aggregate
		  - Social security contribution (Proxy: pension funds): several questions related to social security but pension funds
		  - Place of work: not asked.
		  - Size: pp50a
		  - Paid annual leave: pp56a, pp56b.
		  - Paid sick leave: not asked.
*/
		
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*	    Monthly labour related income ('ilo_lri_ees' and 'ilo_lri_slf')  	   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

    ***********
    * MAIN JOB:
    ***********
	
	* Employees
	gen ilo_job1_lri_ees = .
	    replace ilo_job1_lri_ees = pp59  if ilo_job1_ste_aggregate==1
	    replace ilo_job1_lri_ees = .     if ilo_lfs!=1
		        lab var ilo_job1_lri_ees "Monthly earnings of employees - main job"
	
	* Self-employed
	gen ilo_job1_lri_slf = .
	    replace ilo_job1_lri_slf = pp59  if ilo_job1_ste_aggregate==2
	    replace ilo_job1_lri_slf = .     if ilo_lfs!=1
		        lab var ilo_job1_lri_slf "Monthly labour related income of self-employed - main job"
				
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
* Comment: - No information available.
			
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
*	Cases of non-fatal occupational injury ('ilo_joball_oi_case') 		       *
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
* Comment: - No information available.

*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
*  Days lost due to cases of occupational injury ('ilo_joball_oi_day')		   *
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
* Comment: - No information available.
				
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
	
	gen ilo_cat_une=.
		replace ilo_cat_une=1 if pp45=="01" & ilo_lfs==2                        // Previously employed       
		replace ilo_cat_une=2 if pp45=="02" & ilo_lfs==2                        // Seeking for the first time
		replace ilo_cat_une=3 if ilo_cat_une==. & ilo_lfs==2                    // Unknown
			    lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
			    lab val ilo_cat_une cat_une_lab
			    lab var ilo_cat_une "Category of unemployment"
				
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			   Duration of unemployment ('ilo_dur')  	                       * 
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

	* Detailed categories		
    gen ilo_dur_details=.
	    replace ilo_dur_details=1 if inlist(pp46a,"00","01") & ilo_lfs==2                                      // Less than 1 month
		replace ilo_dur_details=2 if inlist(pp46a,"02","03") & ilo_lfs==2                                      // 1 to 3 months
		replace ilo_dur_details=3 if inlist(pp46a,"04","05", "06") & ilo_lfs==2                                // 3 to 6 months
		replace ilo_dur_details=4 if (inlist(pp46a,"07","08", "09", "10", "11") | pp46b=="01") & ilo_lfs==2    // 6 to 12 months
		replace ilo_dur_details=5 if pp46b=="02" & ilo_lfs==2                                                  // 12 to 24 months
		replace ilo_dur_details=6 if !inlist(pp46b,"-1", "-3", "01", "02") & ilo_lfs==2                        // 24 months or more
		replace ilo_dur_details=7 if ilo_dur_details==. & ilo_lfs==2                                           // Not elsewhere classified
		        lab def unemp_det 1 "1 - Less than 1 month" 2 "2 - 1 month to less than 3 months" 3 "3 - 3 months to less than 6 months" ///
								  4 "4 - 6 months to less than 12 months" 5 "5 - 12 months to less than 24 months" 6 "6 - 24 months or more" ///
								  7 "7 - Not elsewhere classified"
			    lab val ilo_dur_details unemp_det
			    lab var ilo_dur_details "Duration of unemployment (Details)"
		
    * Aggregate categories
	gen ilo_dur_aggregate=.
		replace ilo_dur_aggregate=1 if (inlist(ilo_dur_details,1,2,3) & ilo_lfs==2)   // Less than 6 months
		replace ilo_dur_aggregate=2 if (ilo_dur_details==4 & ilo_lfs==2)              // 6 to 12 months
		replace ilo_dur_aggregate=3 if (inlist(ilo_dur_details,5,6) & ilo_lfs==2)     // 12 months or more
		replace ilo_dur_aggregate=4 if (ilo_dur_details==7 & ilo_lfs==2)              // Not elsewhere classified
		replace ilo_dur_aggregate=. if ilo_lfs!=2
			    lab def unemp_aggr 1 "1 - Less than 6 months" 2 "2 - 6 months to less than 12 months" 3 "3 - 12 months or more" 4 "4 - Not elsewhere classified"
			    lab val ilo_dur_aggregate unemp_aggr
			    lab var ilo_dur_aggregate "Duration of unemployment (Aggregate)"
		
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4') 	               * 
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: - No information available.
		
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu_isco08') 		                   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: - No information available.
				
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
* Comment: - Even though the questions related to seeking and availability are part
*            of the questionnaire, availability is not part of the dataset and
*            therefore none of the categories in this variable can be defined.

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			Reasons for not seeking a job ('ilo_olf_reason') 	               *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

		gen ilo_olf_reason=.
			replace ilo_olf_reason=1 if inlist(pp43,"01", "02", "03", "04", "07", "08") & ilo_lfs==3        // Labour market 
			replace ilo_olf_reason=2 if inlist(pp43,"05") & ilo_lfs==3                                      // Other labour market reasons
			replace ilo_olf_reason=3 if inlist(pp43,"09", "10", "11", "13", "14") & ilo_lfs==3              // Personal/Family-related
			replace ilo_olf_reason=4 if inlist(pp43,"12") & ilo_lfs==3                                      // Does not need/want to work
			replace ilo_olf_reason=5 if ilo_olf_reason==. & ilo_lfs==3                                      // Not elsewhere classified
 			        lab def lab_olf_reason 1 "1 - Labour market" 2 " 2 - Other labour market reasons" 3 "3 - Personal/Family-related"  ///
				                           4 "4 - Does not need/want to work" 5 "5 - Not elsewhere classified"
					lab val ilo_olf_reason lab_olf_reason
					lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"		

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			      Discouraged job-seekers ('ilo_dis') 		                   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: - Not possible to be defined due to the lack of information on availability.
			
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
	
	/* Variables computed in-between */
	drop to_drop to_drop_1 to_drop_2
	compress
		
	/* Save dataset including original and ilo variables*/
	save ${country}_${source}_${time}_FULL,  replace		
	
	*Save file only containing ilo_* variables
	keep ilo*
	save ${country}_${source}_${time}_ILO, replace
		
