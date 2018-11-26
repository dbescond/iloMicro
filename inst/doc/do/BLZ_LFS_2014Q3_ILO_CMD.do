* TITLE OF DO FILE: ILO Microdata Preprocessing code template - BELIZE, 2014Q3
* DATASET USED: BLZ, LFS, 2014Q3
* Files created: Standard variables BLZ_LFS_2014Q3_FULL.dta and BLZ_LFS_2014Q3_ILO.dta
* Authors: ILO / Department of Statistics / DPAU
* Starting Date: 08 November 2018
* Last updated: 08 November 2018
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
global country "BLZ"
global source "LFS"
global time "2014Q3"
global inputFile "SEPTEMBER_2014_ANONYMISED"
global inpath "${path}\\${country}\\${source}\\${time}\ORI"
global temppath "${path}\_Admin"
global outpath "${path}\\${country}\\${source}\\${time}"

********************************************************************************
********************************************************************************

cd "$inpath"
	use ${inputFile}, clear
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
	    replace ilo_wgt=weight 
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
		
*-- generates variable "to_drop" that will be split in two parts: annual part 
*-- (to_drop_1) and quarter part (to_drop_2)
   
   decode ilo_time, gen(to_drop)
   split to_drop, generate(to_drop_) parse(Q)
   destring to_drop_1, replace force
   capture destring to_drop_2, replace force
   capture gen to_drop_2=-9999
   
*-- locals

   local Y = to_drop_1 in 1
   local Q = to_drop_2 in 1
   
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
* Comment: 
	
	gen ilo_geo=.
	capture confirm variable urban_ruralnew
	if !_rc{
	    replace ilo_geo=1 if urban_ruralnew==1         // Urban 
		replace ilo_geo=2 if urban_ruralnew==2         // Rural
	}
	else{
	    replace ilo_geo=1 if urban_rural==1         // Urban 
		replace ilo_geo=2 if urban_rural==7         // Rural
	}
		        lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural"
		        lab val ilo_geo ilo_geo_lab
		        lab var ilo_geo "Geographical coverage"	
				
	keep if ilo_geo!=.
	
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			                     Sex ('ilo_sex') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 

    gen ilo_sex=.

    capture confirm variable hl5
    if !_rc{
	    replace ilo_sex=1 if hl5==1      // Male
		replace ilo_sex=2 if hl5==2      // Female
    }
    else{
	    replace ilo_sex=1 if hl5new==1         // Male
		replace ilo_sex=2 if hl5new==2         // Female
    }
		        label define label_Sex 1 "1 - Male" 2 "2 - Female"
		        label values ilo_sex label_Sex
		        lab var ilo_sex "Sex"
				
	keep if ilo_sex!=.

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			                    Age ('ilo_age') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 

    gen ilo_age=.
	
	capture confirm variable hl3
	if !_rc{
	    replace ilo_age=hl3
 	}
	else{
	    replace ilo_age=hl3new
	}
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
* Comment: - The educational level is asked depending on whether the person is 
*            currently attending to any level of formal education.
*          - Only asked for persons aged 5 years old or more and therefore those
*            below this aged are classified under "level not stated".

    *---------------------------------------------------------------------------
	* ISCED 97
	*---------------------------------------------------------------------------
	
	* Detailed
	gen ilo_edu_isced97=.
		replace ilo_edu_isced97=1 if (inlist(ed5,17,18))                                        // No schooling
		replace ilo_edu_isced97=2 if (inlist(ed4,1,2,3,4,5,6))                                  // Pre-primary education
		replace ilo_edu_isced97=3 if (inlist(ed4,7,8,9,10)) | (inlist(ed5,1,2,3,4,5,6))         // Primary education or first stage of basic education
		replace ilo_edu_isced97=4 if (inlist(ed4,11,12)) | (inlist(ed5,7,8,9,10))               // Lower secondary education or second stage of basic education
		replace ilo_edu_isced97=5 if (inlist(ed4,13,14)) | (inlist(ed5,11,12))                  // Upper secondary education
		* replace ilo_edu_isced97=6 if                                                          // Post-secondary non-tertiary education
		replace ilo_edu_isced97=7 if (ed4==15) | (inlist(ed5,13,14))                            // First stage of tertiary education (not leading directly to an advanced research qualification)
		replace ilo_edu_isced97=8 if (ed5==15)                                                  // Second stage of tertiary education (leading to an advanced research qualification)                               
		replace ilo_edu_isced97=9 if ilo_edu_isced97==.                                         // Level not stated 
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
* Comment: - Only asked to those aged 5 years old or more and therefore those 
*            below are classified under "not elsewhere classified".
			
    gen ilo_edu_attendance=.
		replace ilo_edu_attendance=1 if ed3==1                                  // Attending
		replace ilo_edu_attendance=2 if ed3==2                                  // Not attending
		replace ilo_edu_attendance=3 if ilo_edu_attendance==.                   // Not elsewhere classified
			    lab def edu_attendance_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
			    lab val ilo_edu_attendance edu_attendance_lab
			    lab var ilo_edu_attendance "Education (Attendance)"

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			           Marital status ('ilo_mrts') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: - No information available.				
				
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			Disability status ('ilo_dsb_details')                              *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: - No information available
				
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
			    label define label_ilo_wap 1 "1 - Working-age Population"
				label value ilo_wap label_ilo_wap
				label var ilo_wap "Working-age population"

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			       Labour Force Status ('ilo_lfs')                             *       
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: - Employment follows the ILO's definition. Figures might differ from 
*            those at the national level due to age coverage (the national statistical 
*            office includes people aged 14 years old or more).  
*          - Unemployment comprises people not in employment, looking for a job
*            and available. It does not include future work starters. People in 
*            unemployment differs from the one reported by the NSO due to: 1) age
*            coverage and 2) the definition used at the national level (i.e. people
*            not in employment and available (not using the job searching question)).


	gen ilo_lfs=.
        replace ilo_lfs=1 if (ea1new==1 | ea2new==1) & ilo_wap==1				// Employed: ILO definition
		replace ilo_lfs=1 if (ea3new==1 & inrange(ea4new,3,9)) & ilo_wap==1		// Employed: temporary absent
		replace ilo_lfs=1 if (ea3new==1 & ea5new==1) & ilo_wap==1		        // Employed: temporary absent
		replace ilo_lfs=2 if ilo_lfs!=1 & (ea6new==1 & ea9new==1) & ilo_wap==1	// Unemployed: three criteria
	    replace ilo_lfs=3 if !inlist(ilo_lfs,1,2) & ilo_wap==1		            // Outside the labour force
				label define label_ilo_lfs 1 "1 - Employed" 2 "2 - Unemployed" 3 "3 - Outside Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status" 

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			       Multiple job holders ('ilo_mjh')                            *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 

    gen ilo_mjh=.
	
	capture confirm variable ea17
	if !_rc{
		replace ilo_mjh=2 if (ea17==1) & ilo_lfs==1                // More than one job   
		replace ilo_mjh=1 if (ilo_mjh==.) & ilo_lfs==1             // One job only 
		replace ilo_mjh=. if ilo_lfs!=1
 	}
	else{
		replace ilo_mjh=2 if (ea17new==1) & ilo_lfs==1             // More than one job     
		replace ilo_mjh=1 if (ilo_mjh==.) & ilo_lfs==1             // One job only 
		replace ilo_mjh=. if ilo_lfs!=1
	}
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
* Comment: - Government and private are classified as employees.

   * MAIN JOB
   * ICSE 1993
	 gen ilo_job1_ste_icse93=.
	 capture confirm variable ea18_mainjob
	 if !_rc{
		 replace ilo_job1_ste_icse93=1 if inlist(ea18_mainjob,3,4,5,6) & ilo_lfs==1   // Employees
		 replace ilo_job1_ste_icse93=2 if ea18_mainjob==1 & ilo_lfs==1                // Employers
		 replace ilo_job1_ste_icse93=3 if ea18_mainjob==2 & ilo_lfs==1                // Own-account workers
		 * replace ilo_job1_ste_icse93=4 if                                           // Members of producers' cooperatives
		 replace ilo_job1_ste_icse93=5 if ea18_mainjob==7 & ilo_lfs==1                // Contributing family workers
		 replace ilo_job1_ste_icse93=6 if ilo_job1_ste_icse93==. & ilo_lfs==1         // Workers not classifiable by status
		 replace ilo_job1_ste_icse93=. if ilo_lfs!=1
	}	 
	else{
		 replace ilo_job1_ste_icse93=1 if inlist(ea18_mainjobnew,3,4,5,6) & ilo_lfs==1   // Employees
		 replace ilo_job1_ste_icse93=2 if ea18_mainjobnew==1 & ilo_lfs==1                // Employers
		 replace ilo_job1_ste_icse93=3 if ea18_mainjobnew==2 & ilo_lfs==1                // Own-account workers
		 * replace ilo_job1_ste_icse93=4 if                                              // Members of producers' cooperatives
		 replace ilo_job1_ste_icse93=5 if ea18_mainjobnew==7 & ilo_lfs==1                // Contributing family workers
		 replace ilo_job1_ste_icse93=6 if ilo_job1_ste_icse93==. & ilo_lfs==1            // Workers not classifiable by status
		 replace ilo_job1_ste_icse93=. if ilo_lfs!=1
	}
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
				
	* SECOND JOB
	* ICSE 1993
	  gen ilo_job2_ste_icse93=.
	  capture confirm variable ea18_otherjob
	  if !_rc{
	  	  replace ilo_job2_ste_icse93=1 if inlist(ea18_otherjob,3,4,5,6) & ilo_mjh==2  // Employees
	  	  replace ilo_job2_ste_icse93=2 if ea18_otherjob==1 & ilo_mjh==2               // Employers
	  	  replace ilo_job2_ste_icse93=3 if ea18_otherjob==2 & ilo_mjh==2               // Own-account workers
	  	  * replace ilo_job2_ste_icse93=4 if                                           // Members of producers' cooperatives 
	   	  replace ilo_job2_ste_icse93=5 if ea18_otherjob==7 & ilo_mjh==2               // Contributing family workers
	   	  replace ilo_job2_ste_icse93=6 if ilo_job2_ste_icse93==. & ilo_mjh==2         // Workers not classifiable by status
	   	  replace ilo_job2_ste_icse93=. if ilo_mjh!=2
	  }
	  else{
	  	  replace ilo_job2_ste_icse93=1 if inlist(ea18_otherjobnew,3,4,5,6) & ilo_mjh==2  // Employees
	  	  replace ilo_job2_ste_icse93=2 if ea18_otherjobnew==1 & ilo_mjh==2               // Employers
	  	  replace ilo_job2_ste_icse93=3 if ea18_otherjobnew==2 & ilo_mjh==2               // Own-account workers
	  	  * replace ilo_job2_ste_icse93=4 if                                              // Members of producers' cooperatives 
	  	  replace ilo_job2_ste_icse93=5 if ea18_otherjobnew==7 & ilo_mjh==2               // Contributing family workers
	  	  replace ilo_job2_ste_icse93=6 if ilo_job2_ste_icse93==. & ilo_mjh==2            // Workers not classifiable by status
	  	  replace ilo_job2_ste_icse93=. if ilo_mjh!=2
	  }	   
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
* Comment: - No information available at 2-digit level.

    * MAIN JOB

    *---------------------------------------------------------------------------
	* ISIC REV 4
	*---------------------------------------------------------------------------
    gen eco_pri=.
	    capture confirm variable 
	* 1-digit level
    gen ilo_job1_eco_isic4=.
	if (`Y'<=2014 & `Q'<=2){
	    replace ilo_job1_eco_isic4=1 if ea21_mainnew==1
	    replace ilo_job1_eco_isic4=2 if ea21_mainnew==2
	    replace ilo_job1_eco_isic4=3 if ea21_mainnew==3
	    replace ilo_job1_eco_isic4=4 if ea21_mainnew==4
	    replace ilo_job1_eco_isic4=5 if ea21_mainnew==5
	    replace ilo_job1_eco_isic4=6 if ea21_mainnew==6
	    replace ilo_job1_eco_isic4=7 if ea21_mainnew==7
	    replace ilo_job1_eco_isic4=8 if ea21_mainnew==8
	    replace ilo_job1_eco_isic4=9 if ea21_mainnew==9
	    replace ilo_job1_eco_isic4=10 if ea21_mainnew==10
	    replace ilo_job1_eco_isic4=11 if ea21_mainnew==11
	    replace ilo_job1_eco_isic4=12 if ea21_mainnew==12
	    replace ilo_job1_eco_isic4=13 if ea21_mainnew==13
	    replace ilo_job1_eco_isic4=14 if ea21_mainnew==14
	    replace ilo_job1_eco_isic4=15 if ea21_mainnew==15
        replace ilo_job1_eco_isic4=16 if ea21_mainnew==16
	    replace ilo_job1_eco_isic4=17 if ea21_mainnew==17
	    replace ilo_job1_eco_isic4=18 if ea21_mainnew==18
	    replace ilo_job1_eco_isic4=19 if ea21_mainnew==19
	    replace ilo_job1_eco_isic4=20 if ea21_mainnew==20
	    replace ilo_job1_eco_isic4=21 if ea21_mainnew==21
	    replace ilo_job1_eco_isic4=22 if ilo_job1_eco_isic4==. & ilo_lfs==1
		replace ilo_job1_eco_isic4=. if ilo_lfs!=1
	}
	if (`Y'>=2014 & `Q'>=3){
	    replace ilo_job1_eco_isic4=1 if ea21_mainnew=="A"
	    replace ilo_job1_eco_isic4=2 if ea21_mainnew=="B"
	    replace ilo_job1_eco_isic4=3 if ea21_mainnew=="C"
	    replace ilo_job1_eco_isic4=4 if ea21_mainnew=="D"
	    replace ilo_job1_eco_isic4=5 if ea21_mainnew=="E"
	    replace ilo_job1_eco_isic4=6 if ea21_mainnew=="F"
	    replace ilo_job1_eco_isic4=7 if ea21_mainnew=="G"
	    replace ilo_job1_eco_isic4=8 if ea21_mainnew=="H"
	    replace ilo_job1_eco_isic4=9 if ea21_mainnew=="I"
	    replace ilo_job1_eco_isic4=10 if ea21_mainnew=="J"
	    replace ilo_job1_eco_isic4=11 if ea21_mainnew=="K"
	    replace ilo_job1_eco_isic4=12 if ea21_mainnew=="L"
	    replace ilo_job1_eco_isic4=13 if ea21_mainnew=="M"
	    replace ilo_job1_eco_isic4=14 if ea21_mainnew=="N"
	    replace ilo_job1_eco_isic4=15 if ea21_mainnew=="O"
        replace ilo_job1_eco_isic4=16 if ea21_mainnew=="P"
	    replace ilo_job1_eco_isic4=17 if ea21_mainnew=="Q"
	    replace ilo_job1_eco_isic4=18 if ea21_mainnew=="R"
	    replace ilo_job1_eco_isic4=19 if ea21_mainnew=="S"
	    replace ilo_job1_eco_isic4=20 if ea21_mainnew=="T"
	    replace ilo_job1_eco_isic4=21 if ea21_mainnew=="U"
	    replace ilo_job1_eco_isic4=22 if ilo_job1_eco_isic4==. & ilo_lfs==1
		replace ilo_job1_eco_isic4=. if ilo_lfs!=1
	}
		        lab def eco_isic4_1digit 1 "A - Agriculture, forestry and fishing"	2 "B - Mining and quarrying"	3 "C - Manufacturing"	4 "D - Electricity, gas, steam and air conditioning supply" ///
                                         5 "E - Water supply; sewerage, waste management and remediation activities"	6 "F - Construction"	7 "G - Wholesale and retail trade; repair of motor vehicles and motorcycles"	8 "H - Transportation and storage" ///
                                         9 "I - Accommodation and food service activities"	10 "J - Information and communication"	11 "K - Financial and insurance activities"	12 "L - Real estate activities" ///
                                         13 "M - Professional, scientific and technical activities"	14 "N - Administrative and support service activities"	15 "O - Public administration and defence; compulsory social security"	16 "P - Education" ///
                                         17 "Q - Human health and social work activities"	18 "R - Arts, entertainment and recreation"	19 "S - Other service activities"	20 "T - Activities of households as employers; undifferentiated goods- and services-producing activities of households for own use" ///
                                         21 "U - Activities of extraterritorial organizations and bodies"	22 "X - Not elsewhere classified"		
  	  		    lab val ilo_job1_eco_isic4 eco_isic4_1digit
			    lab var ilo_job1_eco_isic4 "Economic activity (ISIC Rev. 4) - main job"

   * Aggregate level
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


    * SECOND JOB
	
    *---------------------------------------------------------------------------
	* ISIC REV 4
	*---------------------------------------------------------------------------

	* 1-digit level
    gen ilo_job2_eco_isic4=.
	if (`Y'<=2014 & `Q'<=2){
	    replace ilo_job2_eco_isic4=1 if ea21_othernew==1
	    replace ilo_job2_eco_isic4=2 if ea21_othernew==2
	    replace ilo_job2_eco_isic4=3 if ea21_othernew==3
	    replace ilo_job2_eco_isic4=4 if ea21_othernew==4
	    replace ilo_job2_eco_isic4=5 if ea21_othernew==5
	    replace ilo_job2_eco_isic4=6 if ea21_othernew==6
	    replace ilo_job2_eco_isic4=7 if ea21_othernew==7
	    replace ilo_job2_eco_isic4=8 if ea21_othernew==8
	    replace ilo_job2_eco_isic4=9 if ea21_othernew==9
	    replace ilo_job2_eco_isic4=10 if ea21_othernew==10
	    replace ilo_job2_eco_isic4=11 if ea21_othernew==11
	    replace ilo_job2_eco_isic4=12 if ea21_othernew==12
	    replace ilo_job2_eco_isic4=13 if ea21_othernew==13
	    replace ilo_job2_eco_isic4=14 if ea21_othernew==14
	    replace ilo_job2_eco_isic4=15 if ea21_othernew==15
        replace ilo_job2_eco_isic4=16 if ea21_othernew==16
	    replace ilo_job2_eco_isic4=17 if ea21_othernew==17
	    replace ilo_job2_eco_isic4=18 if ea21_othernew==18
	    replace ilo_job2_eco_isic4=19 if ea21_othernew==19
	    replace ilo_job2_eco_isic4=20 if ea21_othernew==20
	    replace ilo_job2_eco_isic4=21 if ea21_othernew==21
	    replace ilo_job2_eco_isic4=22 if ilo_job2_eco_isic4==. & ilo_mjh==2
		replace ilo_job2_eco_isic4=. if ilo_mjh!=2
	}
	if (`Y'>=2014 & `Q'>=3){
	    replace ilo_job2_eco_isic4=1 if ea21_othernew=="A"
	    replace ilo_job2_eco_isic4=2 if ea21_othernew=="B"
	    replace ilo_job2_eco_isic4=3 if ea21_othernew=="C"
	    replace ilo_job2_eco_isic4=4 if ea21_othernew=="D"
	    replace ilo_job2_eco_isic4=5 if ea21_othernew=="E"
	    replace ilo_job2_eco_isic4=6 if ea21_othernew=="F"
	    replace ilo_job2_eco_isic4=7 if ea21_othernew=="G"
	    replace ilo_job2_eco_isic4=8 if ea21_othernew=="H"
	    replace ilo_job2_eco_isic4=9 if ea21_othernew=="I"
	    replace ilo_job2_eco_isic4=10 if ea21_othernew=="J"
	    replace ilo_job2_eco_isic4=11 if ea21_othernew=="K"
	    replace ilo_job2_eco_isic4=12 if ea21_othernew=="L"
	    replace ilo_job2_eco_isic4=13 if ea21_othernew=="M"
	    replace ilo_job2_eco_isic4=14 if ea21_othernew=="N"
	    replace ilo_job2_eco_isic4=15 if ea21_othernew=="O"
        replace ilo_job2_eco_isic4=16 if ea21_othernew=="P"
	    replace ilo_job2_eco_isic4=17 if ea21_othernew=="Q"
	    replace ilo_job2_eco_isic4=18 if ea21_othernew=="R"
	    replace ilo_job2_eco_isic4=19 if ea21_othernew=="S"
	    replace ilo_job2_eco_isic4=20 if ea21_othernew=="T"
	    replace ilo_job2_eco_isic4=21 if ea21_othernew=="U"
	    replace ilo_job2_eco_isic4=22 if ilo_job2_eco_isic4==. & ilo_mjh==2
		replace ilo_job2_eco_isic4=. if ilo_mjh!=2
	}	
                * labels already defined for main job
		        lab val ilo_job2_eco_isic4 eco_isic4_1digit
			    lab var ilo_job2_eco_isic4 "Economic activity (ISIC Rev. 4) - second job"

   * Aggregate level
   gen ilo_job2_eco_aggregate=.
	   replace ilo_job2_eco_aggregate=1 if ilo_job2_eco_isic4==1
	   replace ilo_job2_eco_aggregate=2 if ilo_job2_eco_isic4==3
	   replace ilo_job2_eco_aggregate=3 if ilo_job2_eco_isic4==6
	   replace ilo_job2_eco_aggregate=4 if inlist(ilo_job2_eco_isic4,2,4,5)
	   replace ilo_job2_eco_aggregate=5 if inrange(ilo_job2_eco_isic4,7,14)
	   replace ilo_job2_eco_aggregate=6 if inrange(ilo_job2_eco_isic4,15,21)
	   replace ilo_job2_eco_aggregate=7 if ilo_job2_eco_isic4==22
               * labels already defined for main job
	           lab val ilo_job2_eco_aggregate eco_aggr_lab
			   lab var ilo_job2_eco_aggregate "Economic activity (Aggregate) - second job"				
			   
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			               Occupation ('ilo_ocu') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: - 

    * MAIN JOB

    *---------------------------------------------------------------------------
	* ISCO 08
	*---------------------------------------------------------------------------
	gen ocu_pri =.
	
	capture confirm variable ea20_main
	if !_rc{
	   replace ocu_pri = ea20_main
	   replace ocu_pri =. if ocu_pri<0
	}
	else{
	   replace ocu_pri = ea20_mainnew
	   replace ocu_pri =. if ocu_pri<0
	}
				
	* 1-digit level 				
	gen ilo_job1_ocu_isco08=.
	    replace ilo_job1_ocu_isco08=ocu_pri if inrange(ocu_pri,1,9) & ilo_lfs==1               // Not elsewhere classified
		replace ilo_job1_ocu_isco08=10 if ocu_pri==0 & ilo_lfs==1                              // The rest of the occupations
		replace ilo_job1_ocu_isco08=11 if ilo_job1_ocu_isco08==. & ilo_lfs==1                  // Armed forces
		        lab def ocu_isco08_1digit 1 "1 - Managers"	2 "2 - Professionals"	3 "3 - Technicians and associate professionals"	4 "4 - Clerical support workers"	///
                                          5 "5 - Service and sales workers"	6 "6 - Skilled agricultural, forestry and fishery workers"	7 "7 - Craft and related trades workers"	8 "8 - Plant and machine operators, and assemblers"	///
                                          9 "9 - Elementary occupations"	10 "0 - Armed forces occupations"	11 "X - Not elsewhere classified"		
				lab val ilo_job1_ocu_isco08 ocu_isco08_1digit
				lab var ilo_job1_ocu_isco08 "Occupation (ISCO-08) - main job"
				
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
			    lab var ilo_job1_ocu_aggregate "Occupation (Aggregate) - main job"	
		
	* Skill level
	gen ilo_job1_ocu_skill=.
	    replace ilo_job1_ocu_skill=1 if ilo_job1_ocu_isco08==9                  // Low
		replace ilo_job1_ocu_skill=2 if inlist(ilo_job1_ocu_isco08,4,5,6,7,8)   // Medium
		replace ilo_job1_ocu_skill=3 if inlist(ilo_job1_ocu_isco08,1,2,3)       // High
		replace ilo_job1_ocu_skill=4 if inlist(ilo_job1_ocu_isco08,10,11)       // Not elsewhere classified
				lab def ocu_skill_lab 1 "1 - Skill level 1 (low)" 2 "2 - Skill level 2 (medium)" 3 "3 - Skill levels 3 and 4 (high)" 4 "4 - Not elsewhere classified"
			    lab val ilo_job1_ocu_skill ocu_skill_lab
			    lab var ilo_job1_ocu_skill "Occupation (Skill level) - main job"

    * SECOND JOB

    *---------------------------------------------------------------------------
	* ISCO 08
	*---------------------------------------------------------------------------
	gen ocu_sec =.
	capture confirm variable ea20_other
	if !_rc{
	   replace ocu_sec = ea20_other
	   replace ocu_sec =. if ocu_sec<0
	}
	else{
	   replace ocu_sec = ea20_othernew
	   replace ocu_sec =. if ocu_sec<0
	}	
	
	* 1-digit level 				
	gen ilo_job2_ocu_isco08=.
	    replace ilo_job2_ocu_isco08=ocu_sec if inrange(ocu_sec,1,9) & ilo_mjh==2              // Not elsewhere classified
		replace ilo_job2_ocu_isco08=10 if ocu_sec==0 & ilo_mjh==2                             // The rest of the occupations
		replace ilo_job2_ocu_isco08=11 if ilo_job2_ocu_isco08==. & ilo_mjh==2                 // Armed forces
                * labels already defined for main job
				lab val ilo_job2_ocu_isco08 ocu_isco08_1digit
				lab var ilo_job2_ocu_isco08 "Occupation (ISCO-08) - second job"
				
	* Aggregate:			
    gen ilo_job2_ocu_aggregate=.
	    replace ilo_job2_ocu_aggregate=1 if inrange(ilo_job2_ocu_isco08,1,3)   
	    replace ilo_job2_ocu_aggregate=2 if inlist(ilo_job2_ocu_isco08,4,5)
	    replace ilo_job2_ocu_aggregate=3 if inlist(ilo_job2_ocu_isco08,6,7)
	    replace ilo_job2_ocu_aggregate=4 if ilo_job2_ocu_isco08==8
	    replace ilo_job2_ocu_aggregate=5 if ilo_job2_ocu_isco08==9
	    replace ilo_job2_ocu_aggregate=6 if ilo_job2_ocu_isco08==10
	    replace ilo_job2_ocu_aggregate=7 if ilo_job2_ocu_isco08==11
                * labels already defined for main job
		        lab val ilo_job2_ocu_aggregate ocu_aggr_lab
			    lab var ilo_job2_ocu_aggregate "Occupation (Aggregate) - second job"	
		
	* Skill level
	gen ilo_job2_ocu_skill=.
	    replace ilo_job2_ocu_skill=1 if ilo_job2_ocu_isco08==9                  // Low
		replace ilo_job2_ocu_skill=2 if inlist(ilo_job2_ocu_isco08,4,5,6,7,8)   // Medium
		replace ilo_job2_ocu_skill=3 if inlist(ilo_job2_ocu_isco08,1,2,3)       // High
		replace ilo_job2_ocu_skill=4 if inlist(ilo_job2_ocu_isco08,10,11)       // Not elsewhere classified
		        * labels already defined for main job
			    lab val ilo_job2_ocu_skill ocu_skill_lab
			    lab var ilo_job2_ocu_skill "Occupation (Skill level) - second job"				

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*	Institutional sector of economic activities ('ilo_ins_sector')		       *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 
		
	gen ilo_job1_ins_sector=.
	capture confirm variable ea18_mainjob
	if !_rc{
	   replace ilo_job1_ins_sector=1 if ea18_mainjob==3 & ilo_lfs==1            // Public
	   replace ilo_job1_ins_sector=2 if ilo_job1_ins_sector==. & ilo_lfs==1     // Private
	}
	else{
	   replace ilo_job1_ins_sector=1 if ea18_mainjobnew==3 & ilo_lfs==1         // Public
	   replace ilo_job1_ins_sector=2 if ilo_job1_ins_sector==. & ilo_lfs==1     // Private
	}
			   lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
			   lab values ilo_job1_ins_sector ins_sector_lab
			   lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities - main job"
	
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*		               Hours of work ('ilo_how')  	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: - Only availalbe total hours usually/actually worked per week.

    * ALL JOBS
	
	* Hours USUALLY worked
    gen ilo_joball_how_usual = .
	capture confirm variable ea22_main
	if !_rc{
	    replace ilo_joball_how_usual = ea22_main if ilo_lfs==1
		replace ilo_joball_how_usual = . if ilo_joball_how_usual==999
	}
	else{
	    replace ilo_joball_how_usual = ea22_totalnew if ilo_lfs==1
		replace ilo_joball_how_usual = . if ilo_joball_how_usual==999
	}	
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
		   	    lab def how_bands_usu 1 "No hours usually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"	
			 	lab val ilo_joball_how_usual_bands how_bands_usu
				lab var ilo_joball_how_usual_bands "Weekly hours usually worked bands - all jobs"
				
	* Hours ACTUALLY worked
	gen ilo_joball_how_actual = .
	capture confirm variable ea23_main
	if !_rc{
	    replace ilo_joball_how_actual = ea23_main if ilo_lfs==1
		replace ilo_joball_how_actual = . if ilo_joball_how_actual==999
	}
    else{
	    replace ilo_joball_how_actual = ea23_totalnew if ilo_lfs==1
		replace ilo_joball_how_actual = . if ilo_joball_how_actual==999
	}

		        lab var ilo_joball_how_actual "Weekly hours actually worked - all jobs"
		 
	gen ilo_joball_how_actual_bands=.
	    replace ilo_joball_how_actual_bands=1 if ilo_joball_how_actual==0
		replace ilo_joball_how_actual_bands=2 if ilo_joball_how_actual>=1 & ilo_joball_how_actual<=14
		replace ilo_joball_how_actual_bands=3 if ilo_joball_how_actual>14 & ilo_joball_how_actual<=29
		replace ilo_joball_how_actual_bands=4 if ilo_joball_how_actual>29 & ilo_joball_how_actual<=34
		replace ilo_joball_how_actual_bands=5 if ilo_joball_how_actual>34 & ilo_joball_how_actual<=39
		replace ilo_joball_how_actual_bands=6 if ilo_joball_how_actual>39 & ilo_joball_how_actual<=48
		replace ilo_joball_how_actual_bands=7 if ilo_joball_how_actual>48 & ilo_joball_how_actual!=.
		replace ilo_joball_how_actual_bands=8 if ilo_joball_how_actual_bands==. & ilo_lfs==1
		replace ilo_joball_how_actual_bands=. if ilo_lfs!=1
		   	    lab def how_bands_act 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"		
			 	lab val ilo_joball_how_actual_bands how_bands_act
				lab var ilo_joball_how_actual_bands "Weekly hours actually worked bands - all jobs"
		
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job_time')		                   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: - based on the median of usual hours of work for all jobs (45hrs/week)
			
	gen ilo_job1_job_time=.
		replace ilo_job1_job_time=2 if ilo_joball_how_usual>=45  & ilo_lfs==1                             // Full-time
		replace ilo_job1_job_time=1 if ilo_joball_how_usual<45 & ilo_joball_how_usual!=. & ilo_lfs==1     // Part-time
		replace ilo_job1_job_time=3 if ilo_job1_job_time==. & ilo_lfs==1
			    lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
			    lab val ilo_job1_job_time job_time_lab
			    lab var ilo_job1_job_time "Job (Working time arrangement)"
			
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*		    	Type of contract ('ilo_job_contract') 		                   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: - No information available.

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*  Informal/formal economy: ('ilo_job1_ife_prod'/'ilo_job1_ife_nature') 	   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: - Not possible to define due to the lack of min. information required
*            for its computation.

/* Useful questions:
          - Institutional sector: ea18_1 (option 3 -> government)
		  - Private household identification: not available
		  - Destination of production: not asked
		  - Bookkeeping: not asked
		  - Registration: not asked
		  - Status in employment: ilo_job1_ste_icse93
		  - Social security contribution (Proxy: pension funds): not asked
		  - Place of work: not asked
		  - Size: not asked
		  - Paid annual leave: not asked
		  - Paid sick leave: not asked
*/
	
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*	    Monthly labour related income ('ilo_lri_ees' and 'ilo_lri_slf')  	   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment:  - The monthly labour-related income is defined as the amount reported
*             in question ea34 and multiplying by the correspondent factor depending
*             on the periodicity reported in question ea35.
*           - Before taxes and deductions.

    * MAIN JOB
	capture confirm variable income_month
	if !_rc{
	* Employees
	gen ilo_job1_lri_ees = .
	    replace ilo_job1_lri_ees = income_month if ilo_job1_ste_aggregate==1
	    replace ilo_job1_lri_ees = . if ilo_lfs!=1
		        lab var ilo_job1_lri_ees "Monthly earnings of employees - main job"
	
	* Self-employed
	gen ilo_job1_lri_slf = .
	    replace ilo_job1_lri_slf = income_month  if ilo_job1_ste_aggregate==2
	    replace ilo_job1_lri_slf = . if ilo_lfs!=1
		        lab var ilo_job1_lri_slf "Monthly labour related income of self-employed - main job"
	}
	
	else{
	gen income=.
	    replace income=0 if ea34new==0          // Unpaid family worker
		replace income=60 if ea34new==1         // 1-119
		replace income=179.5 if ea34new==2      // 120-239 
		replace income=299.5 if ea34new==3      // 240-359
		replace income=419.5 if ea34new==4      // 360-479
		replace income=539.5 if ea34new==5      // 480-599
		replace income=659.5 if ea34new==6      // 600-719
		replace income=779.5 if ea34new==7      // 720-839
		replace income=899.5 if ea34new==8      // 840-959 
		replace income=1019.5 if ea34new==9     // 960-1079
		replace income=1139.5 if ea34new==10    // 1080-1199
		replace income=1259.5 if ea34new==11    // 1200-1319
		replace income=1379.5 if ea34new==12    // 1320-1439
		replace income=1499.5 if ea34new==13    // 1440-1559
		replace income=1619.5 if ea34new==14    // 1560-1679
		replace income=1739.5 if ea34new==15    // 1680-1799
		replace income=1859.5 if ea34new==16    // 1800-1919
		replace income=1979.5 if ea34new==17    // 1920-2039
		replace income=2099.5 if ea34new==18    // 2040-2159
		replace income=2219.5 if ea34new==19    // 2160-2279
		replace income=2339.5 if ea34new==20    // 2280-2399
		replace income=2459.5 if ea34new==21    // 2400-2519
		replace income=2579.5 if ea34new==22    // 2520-2639
		replace income=2699.5 if ea34new==23    // 2640-2759
		replace income=2819.5 if ea34new==24    // 2760-2879
		replace income=2939.5 if ea34new==25    // 2880-2999
		replace income=3059.5 if ea34new==26    // 3000-3119
		replace income=3179.5 if ea34new==27    // 3120-3239
		replace income=3239.5 if ea34new==28    // 3240-3359 
	    replace income=3359 if ea34new==29      // more than 3359
		
	gen income_month_1=.
	    replace income_month_1 = income if ea35==4               // Monthly
		replace income_month_1 = income*(365/12) if ea35==1      // Daily
		replace income_month_1 = income*(52/12) if ea35==2       // Weekly
		replace income_month_1 = income*(2) if ea35==3           // Every two weeks
		replace income_month_1 = income*(1/12) if ea35==5        // Yearly
	    replace income_month_1 = .  if ilo_lfs!=1
	
	* Employees
	gen ilo_job1_lri_ees = .
	    replace ilo_job1_lri_ees = income_month_1 if ilo_job1_ste_aggregate==1
	    replace ilo_job1_lri_ees = . if ilo_lfs!=1
		        lab var ilo_job1_lri_ees "Monthly earnings of employees - main job"
	
	* Self-employed
	gen ilo_job1_lri_slf = .
	    replace ilo_job1_lri_slf = income_month_1  if ilo_job1_ste_aggregate==2
	    replace ilo_job1_lri_slf = . if ilo_lfs!=1
		        lab var ilo_job1_lri_slf "Monthly labour related income of self-employed - main job"
	}
				
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
* Comment: - Following the questionnaire, threshold is set at 35 hours per week.
*          - Willingness to work more hours is not asked and therefore the time-
*            related underemployment concept used here is two criteria:
*            worked less than a threshold and available to work additional  hours.
*            [T35:4143]

	gen ilo_joball_tru = .
		capture confirm variable ea28new
	    if !_rc{
	       replace ilo_joball_tru = 1 if ilo_joball_how_usual<=35  & ea28new==1 & ilo_lfs==1
		}
	    else{
	       replace ilo_joball_tru = 1 if ilo_joball_how_usual<=35  & ea28==1 & ilo_lfs==1
		}
			       lab def tru_lab 1 "Time-related underemployed"
			       lab val ilo_joball_tru tru_lab
			       lab var ilo_joball_tru "Time-related underemployed"
			
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
* Comment:
	
	gen ilo_cat_une=.
	capture confirm variable ea15new
	if !_rc{	
		replace ilo_cat_une=1 if ea15new==1 & ilo_lfs==2                        // Previously employed       
		replace ilo_cat_une=2 if ea15new==2 & ilo_lfs==2                        // Seeking for the first time
		replace ilo_cat_une=3 if ilo_cat_une==. & ilo_lfs==2                    // Unknown
	}
	else{	
		replace ilo_cat_une=1 if ea15==1 & ilo_lfs==2                           // Previously employed       
		replace ilo_cat_une=2 if ea15==2 & ilo_lfs==2                           // Seeking for the first time
		replace ilo_cat_une=3 if ilo_cat_une==. & ilo_lfs==2                    // Unknown
	}
			    lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
			    lab val ilo_cat_une cat_une_lab
			    lab var ilo_cat_une "Category of unemployment"
				
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			   Duration of unemployment ('ilo_dur')  	                       * 
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 

	* Detailed categories		
    gen ilo_dur_details=.
	    replace ilo_dur_details=1 if ea14merge<0.083 & ea14merge!=. & ilo_lfs==2    // Less than 1 month
		replace ilo_dur_details=2 if inrange(ea14merge,0.083,0.25) & ilo_lfs==2     // 1 to 3 months
		replace ilo_dur_details=3 if inrange(ea14merge,0.25,0.5) & ilo_lfs==2       // 3 to 6 months
		replace ilo_dur_details=4 if inrange(ea14merge,0.5,1) & ilo_lfs==2          // 6 to 12 months
		replace ilo_dur_details=5 if inrange(ea14merge,1,2) & ilo_lfs==2            // 12 to 24 months
		replace ilo_dur_details=6 if ea14merge>=2 & ea14merge!=. & ilo_lfs==2       // 24 months or more
		replace ilo_dur_details=7 if ilo_dur_details==. & ilo_lfs==2                // Not elsewhere classified
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
* Comment:            

    *---------------------------------------------------------------------------
	* ISIC REV 4
	*---------------------------------------------------------------------------

	* 1-digit level
    gen ilo_preveco_isic4=.
	if (`Y'<=2014 & `Q'<=2){
	    replace ilo_preveco_isic4=1 if ea21_previousnew==1
	    replace ilo_preveco_isic4=2 if ea21_previousnew==2
	    replace ilo_preveco_isic4=3 if ea21_previousnew==3
	    replace ilo_preveco_isic4=4 if ea21_previousnew==4
	    replace ilo_preveco_isic4=5 if ea21_previousnew==5
	    replace ilo_preveco_isic4=6 if ea21_previousnew==6
	    replace ilo_preveco_isic4=7 if ea21_previousnew==7
	    replace ilo_preveco_isic4=8 if ea21_previousnew==8
	    replace ilo_preveco_isic4=9 if ea21_previousnew==9
	    replace ilo_preveco_isic4=10 if ea21_previousnew==10
	    replace ilo_preveco_isic4=11 if ea21_previousnew==11
	    replace ilo_preveco_isic4=12 if ea21_previousnew==12
	    replace ilo_preveco_isic4=13 if ea21_previousnew==13
	    replace ilo_preveco_isic4=14 if ea21_previousnew==14
	    replace ilo_preveco_isic4=15 if ea21_previousnew==15
        replace ilo_preveco_isic4=16 if ea21_previousnew==16
	    replace ilo_preveco_isic4=17 if ea21_previousnew==17
	    replace ilo_preveco_isic4=18 if ea21_previousnew==18
	    replace ilo_preveco_isic4=19 if ea21_previousnew==19
	    replace ilo_preveco_isic4=20 if ea21_previousnew==20
	    replace ilo_preveco_isic4=21 if ea21_previousnew==21
	    replace ilo_preveco_isic4=22 if ilo_preveco_isic4==. & ilo_lfs==2 & ilo_cat_une==1
		replace ilo_preveco_isic4=. if ilo_cat_une!=1
     }
	 if (`Y'>=2015 & `Q'>=3){
	    replace ilo_preveco_isic4=1 if ea21_previousnew=="A"
	    replace ilo_preveco_isic4=2 if ea21_previousnew=="B"
	    replace ilo_preveco_isic4=3 if ea21_previousnew=="C"
	    replace ilo_preveco_isic4=4 if ea21_previousnew=="D"
	    replace ilo_preveco_isic4=5 if ea21_previousnew=="E"
	    replace ilo_preveco_isic4=6 if ea21_previousnew=="F"
	    replace ilo_preveco_isic4=7 if ea21_previousnew=="G"
	    replace ilo_preveco_isic4=8 if ea21_previousnew=="H"
	    replace ilo_preveco_isic4=9 if ea21_previousnew=="I"
	    replace ilo_preveco_isic4=10 if ea21_previousnew=="J"
	    replace ilo_preveco_isic4=11 if ea21_previousnew=="K"
	    replace ilo_preveco_isic4=12 if ea21_previousnew=="L"
	    replace ilo_preveco_isic4=13 if ea21_previousnew=="M"
	    replace ilo_preveco_isic4=14 if ea21_previousnew=="N"
	    replace ilo_preveco_isic4=15 if ea21_previousnew=="O"
        replace ilo_preveco_isic4=16 if ea21_previousnew=="P"
	    replace ilo_preveco_isic4=17 if ea21_previousnew=="Q"
	    replace ilo_preveco_isic4=18 if ea21_previousnew=="R"
	    replace ilo_preveco_isic4=19 if ea21_previousnew=="S"
	    replace ilo_preveco_isic4=20 if ea21_previousnew=="T"
	    replace ilo_preveco_isic4=21 if ea21_previousnew=="U"
	    replace ilo_preveco_isic4=22 if ilo_preveco_isic4==. & ilo_lfs==2 & ilo_cat_une==1
		replace ilo_preveco_isic4=. if ilo_cat_une!=1
	}
                * labels already defined for main job
		        lab val ilo_preveco_isic4 eco_isic4_1digit
			    lab var ilo_preveco_isic4 "Previous economic activity (ISIC Rev. 4)"

   * Aggregate level
   gen ilo_preveco_aggregate=.
	   replace ilo_preveco_aggregate=1 if ilo_preveco_isic4==1
	   replace ilo_preveco_aggregate=2 if ilo_preveco_isic4==3
	   replace ilo_preveco_aggregate=3 if ilo_preveco_isic4==6
	   replace ilo_preveco_aggregate=4 if inlist(ilo_preveco_isic4,2,4,5)
	   replace ilo_preveco_aggregate=5 if inrange(ilo_preveco_isic4,7,14)
	   replace ilo_preveco_aggregate=6 if inrange(ilo_preveco_isic4,15,21)
	   replace ilo_preveco_aggregate=7 if ilo_preveco_isic4==22
               * labels already defined for main job
	           lab val ilo_preveco_aggregate eco_aggr_lab
			   lab var ilo_preveco_aggregate "Previous economic activity (Aggregate)"
		
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu_isco08') 		                   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 

    *---------------------------------------------------------------------------
	* ISCO 08
	*---------------------------------------------------------------------------
	gen ocu_pre =. 
	capture confirm variable ea20_previous
	if !_rc{
	   replace ocu_pre = ea20_previous
	}
	else{
	   replace ocu_pre = ea20previousnew
	}	
		
	* 1-digit level 				
	gen ilo_prevocu_isco08=.
	    replace ilo_prevocu_isco08=ocu_pre if inrange(ocu_pre,1,9) & ilo_lfs==2 & ilo_cat_une==1         // Not elsewhere classified
		replace ilo_prevocu_isco08=10 if (ocu_pre==0 & ilo_lfs==2 & ilo_cat_une==1)                      // The rest of the occupations
		replace ilo_prevocu_isco08=11 if (ilo_prevocu_isco08==. & ilo_lfs==2 & ilo_cat_une==1)           // Armed forces
                * labels already defined for main job
		        lab val ilo_prevocu_isco08 ocu_isco08_1digit
				lab var ilo_prevocu_isco08 "Previous occupation (ISCO-08)"
				
	* Aggregate			
    gen ilo_prevocu_aggregate=.
	    replace ilo_prevocu_aggregate=1 if inrange(ilo_prevocu_isco08,1,3)   
	    replace ilo_prevocu_aggregate=2 if inlist(ilo_prevocu_isco08,4,5)
	    replace ilo_prevocu_aggregate=3 if inlist(ilo_prevocu_isco08,6,7)
	    replace ilo_prevocu_aggregate=4 if ilo_prevocu_isco08==8
	    replace ilo_prevocu_aggregate=5 if ilo_prevocu_isco08==9
	    replace ilo_prevocu_aggregate=6 if ilo_prevocu_isco08==10
	    replace ilo_prevocu_aggregate=7 if ilo_prevocu_isco08==11
                * labels already defined for main job
		        lab val ilo_prevocu_aggregate ocu_aggr_lab
			    lab var ilo_prevocu_aggregate "Previous occupation (Aggregate)"	
		
	* Skill level
	gen ilo_prevocu_skill=.
	    replace ilo_prevocu_skill=1 if ilo_prevocu_isco08==9                  // Low
		replace ilo_prevocu_skill=2 if inlist(ilo_prevocu_isco08,4,5,6,7,8)   // Medium
		replace ilo_prevocu_skill=3 if inlist(ilo_prevocu_isco08,1,2,3)       // High
		replace ilo_prevocu_skill=4 if inlist(ilo_prevocu_isco08,10,11)       // Not elsewhere classified
                * labels already defined for main job
			    lab val ilo_prevocu_skill ocu_skill_lab
			    lab var ilo_prevocu_skill "Previous occupation (Skill level)"
 		
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
* Comment: - Willingness is not asked and therefore only category 1 and 2
*            are defined.

	gen ilo_olf_dlma=.
		replace ilo_olf_dlma = 1 if ea6new==1 & ea9new==2 & ilo_lfs==3          // Seeking, not available
		replace ilo_olf_dlma = 2 if ea6new==2 & ea9new==1 & ilo_lfs==3	        // Not seeking, available
		* replace ilo_olf_dlma = 3 if                                           // Not seeking, not available, willing
		* replace ilo_olf_dlma = 4 if                                           // Not seeking, not available, not willing
		replace ilo_olf_dlma = 5 if	(ilo_olf_dlma==. & ilo_lfs==3)	            // Not classified 
	 		    lab def dlma_lab 1 "1 - Seeking, not available (Unavailable jobseekers)" 2 "2 - Not seeking, available (Available potential jobseekers)" ///
							     3 "3 - Not seeking, not available, willing (Willing non-jobseekers)" 4 "4 - Not seeking, not available, not willing" 5 "X - Not elsewhere classified"
			    lab val ilo_olf_dlma dlma_lab 
			    lab var ilo_olf_dlma "Labour market attachment (Degree of)"

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			Reasons for not seeking a job ('ilo_olf_reason') 	               *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: - Even though question ea8new is an extensive list of all the 
*          possible reasons why the person is not looking for a job/start a business
*          when following the questionnaire, it is not the case when looking at the
*          categories of the actual variable. Categories 1 and 2 cannot be defined
*          given that "other" contain these options. Thus, it is not defined.

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			      Discouraged job-seekers ('ilo_dis') 		                   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: - Given the lack of information for the previous variable, this variable 
*            is not defined either.

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			      Susbsistence Farming ('ilo_sub') 		                   		*
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: - No information available.

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
	drop to_drop to_drop_1 to_drop_2 ocu_pri ocu_sec ocu_pre
	capture drop income
	capture drop income_month_1
	compress
		
	/* Save dataset including original and ilo variables*/
	save ${country}_${source}_${time}_FULL,  replace		
	
	*Save file only containing ilo_* variables
	keep ilo*
	save ${country}_${source}_${time}_ILO, replace
		
