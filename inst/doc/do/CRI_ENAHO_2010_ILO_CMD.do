* TITLE OF DO FILE: ILO Microdata Preprocessing code template - CRI, 2017
* DATASET USED: CRI, ENAHO, 2017
* NOTES: 
* Files created: Standard variables COU_SUR_TIM_FULL.dta and COU_SUR_TIME_ILO.dta
* Authors: ILO / Department of Statistics / DPAU
* Starting Date: 15 July 2018
* Last updated: 16 July 2018
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
global country "CRI"  
global source "ENAHO"   
global time "2010"   
global inputFile "ENAHO_2010"  
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
	    replace ilo_wgt=factor
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
	    replace ilo_geo=1 if zona==1         // Urban 
		replace ilo_geo=2 if zona==2         // Rural
		        lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural"
		        lab val ilo_geo ilo_geo_lab
		        lab var ilo_geo "Geographical coverage"	
		
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			                     Sex ('ilo_sex') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 
	
	gen ilo_sex=.
	    replace ilo_sex=1 if a4==1            // Male
		replace ilo_sex=2 if a4==2            // Female
		        label define label_Sex 1 "1 - Male" 2 "2 - Female"
		        label values ilo_sex label_Sex
		        lab var ilo_sex "Sex"

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			                    Age ('ilo_age') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 
	
	gen ilo_age=.
	    replace ilo_age= a5
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
* Comment: UNESCO does not provide ISCE mappig for Costa Rica, therefore only the aggregated variable has been computed. 

    

* Aggregate
	gen ilo_edu_aggregate=.
		replace ilo_edu_aggregate=1 if inlist(nivinst,0,1)
		replace ilo_edu_aggregate=2 if inlist(nivinst,2,3,5)
		replace ilo_edu_aggregate=3 if inlist(nivinst,4,6)
		replace ilo_edu_aggregate=4 if inlist(nivinst,7,8)
		replace ilo_edu_aggregate=5 if nivinst==99
			    label def edu_aggr_lab 1 "1 - Less than basic" 2 "2 - Basic" 3 "3 - Intermediate" 4 "4 - Advanced" 5 "5 - Level not stated"
			    label val ilo_edu_aggregate edu_aggr_lab
			    label var ilo_edu_aggregate "Level of education (Aggregate levels)"
				
				
 
	 
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*		  	 Educational attendance ('ilo_edu_attendance') 		               *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

* !!!!!!!!!!
* Comment: the percentage of people who are currently attending is very low (also in comparison with the ECE results). 
 	
    gen ilo_edu_attendance=.
		replace ilo_edu_attendance=1 if inlist(a14,1,9)                         // Attending
		replace ilo_edu_attendance=2 if a14==0                                  // Not attending
		replace ilo_edu_attendance=3 if ilo_edu_attendance==.                   // Not elsewhere classified
			    lab def edu_attendance_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
			    lab val ilo_edu_attendance edu_attendance_lab
			    lab var ilo_edu_attendance "Education (Attendance)"
 

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			           Marital status ('ilo_mrts') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: question made to people aged 10 years or above.
	
	* Detailed
	gen ilo_mrts_details=.
	    replace ilo_mrts_details=1 if a26==6                                     // Single
		replace ilo_mrts_details=2 if a26==2                                     // Married
		replace ilo_mrts_details=3 if a26==1                                     // Union / cohabiting
		replace ilo_mrts_details=4 if a26==5                                     // Widowed
		replace ilo_mrts_details=5 if inlist(a26,3,4)                            // Divorced / separated
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
* Comment: No information about the degree of disability, therefore only the aggregate variable can be computed.

/*
    * Detailed
	gen ilo_dsb_details=.
	    replace ilo_dsb_details=1 if                        // No, no difficulty
		replace ilo_dsb_details=2 if      	                // Yes, some difficulty
		replace ilo_dsb_details=3 if     	                // Yes, a lot of difficulty
		replace ilo_dsb_details=4 if   		                // Cannot do it at all
				label def dsb_det_lab 1 "1 - No, no difficulty" 2 "2 - Yes, some difficulty" 3 "3 - Yes, a lot of difficulty" 4 "4 - Cannot do it at all"
				label val ilo_dsb_details dsb_det_lab
				label var ilo_dsb_details "Disability status (Details)"
*/
    * Aggregate  	
	gen ilo_dsb_aggregate=.
	    replace ilo_dsb_aggregate=1 if a7a==0 & a7b==0                          // Persons without disability
		replace ilo_dsb_aggregate=2 if a7a!=0 | a7b!=0	                        // Persons with disability
				label def dsb_lab 1 "1 - Persons without disability" 2 "2 - Persons with disability" 
				label val ilo_dsb_aggregate dsb_lab
				label var ilo_dsb_aggregate "Disability status (Aggregate)"
				
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
* Comment: the number of people in unemployment is not exactly the same given by them (variable "condact") because
*          the Costa Rican definition ("desempleo abierto") takes into account people without any job who did not look for a job
**         because they were waiting for an answer after an application (b8==3) or in a seasonal break (b8==2). 
 	
	gen ilo_lfs=.
        replace ilo_lfs=1 if (b1==1|b2!=1|b3==1) & ilo_wap==1				    // Employed: ILO definition
		replace ilo_lfs=1 if inrange(b5,1,5) & ilo_wap==1                       // Employed: Temporarily Absent
		
		replace ilo_lfs=2 if inlist(b6,8,9) & (b7a==1|b7b==1|b7c==1|b7d==1|b7e==1|b7f==1|b7g==1|b7h==1|b7i==1|b7j==1|b7k==1) & ilo_lfs!=1 & ilo_wap==1 // // Unemployed: three criteria
		replace ilo_lfs=2 if b8==1 & ilo_lfs!=1 & ilo_wap==1			        // Unemployed: available future starters
		*replace ilo_lfs=2 if inlist(b6,8,9) & (b7a==1|b7b==2|b7c==3|b7d==4|b7e==5|b7f==6|b7g==7|b7h==8|b7i==9|b7j==10|b7k==11|inlist(b8,1,2,3)) & ilo_lfs!=1 & ilo_wap==1			

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
		replace ilo_mjh=1 if c1==1 & ilo_lfs==1                                 // One job only     
		replace ilo_mjh=2 if c1==2 & ilo_lfs==1                                 // More than one job
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
* Comment:  

   * MAIN JOB:
   * ICSE 1993
	 gen ilo_job1_ste_icse93=.
		 replace ilo_job1_ste_icse93=1 if inlist(c12,2,3) & ilo_lfs==1          // Employees
		* replace ilo_job1_ste_icse93=2 if c12==1 & inlist(d1,1,2) & ilo_lfs==1 // Employers
		* replace ilo_job1_ste_icse93=3 if c12==1 & inlist d1==3 & ilo_lfs==1   // Own-account workers
		  replace ilo_job1_ste_icse93=2 if c12==1 & d1==1 & ilo_lfs==1          // Employers
		  replace ilo_job1_ste_icse93=3 if c12==1 & inlist(d1,2,3) & ilo_lfs==1    // Own-account workers

		 *replace ilo_job1_ste_icse93=4 if  & ilo_lfs==1                        // Members of producers' cooperatives
		 replace ilo_job1_ste_icse93=5 if inlist(c12,4,5) & ilo_lfs==1           // Contributing family workers
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
		  replace ilo_job2_ste_icse93=1 if inlist(f5,3,4) & ilo_mjh==2          // Employees
		  replace ilo_job2_ste_icse93=2 if f5==1 & ilo_mjh==2                   // Employers
		  replace ilo_job2_ste_icse93=3 if f5==2 & ilo_mjh==2                   // Own-account workers
		  *replace ilo_job2_ste_icse93=4 if  & ilo_mjh==2                       // Members of producers' cooperatives 
		  replace ilo_job2_ste_icse93=5 if f5==5 & ilo_mjh==2                   // Contributing family workers
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
* Comment: information at 1-digit level

*** CAECR 2000 corresponds to ISIC Rev.3


    ***********
    * MAIN JOB:
    ***********

*---------------------------------------------------------------------------
* ISIC REV 3.1
*---------------------------------------------------------------------------
	
 

	* 1-digit level	
    gen ilo_job1_eco_isic3=.
		replace ilo_job1_eco_isic3=1 if ramaemppri==2
		replace ilo_job1_eco_isic3=2 if ramaemppri==3
		replace ilo_job1_eco_isic3=3 if ramaemppri==4
		replace ilo_job1_eco_isic3=4 if ramaemppri==5
		replace ilo_job1_eco_isic3=5 if ramaemppri==6
		replace ilo_job1_eco_isic3=6 if ramaemppri==7
		replace ilo_job1_eco_isic3=7 if ramaemppri==8
		replace ilo_job1_eco_isic3=8 if ramaemppri==9
		replace ilo_job1_eco_isic3=9 if ramaemppri==10
		replace ilo_job1_eco_isic3=10 if ramaemppri==11
		replace ilo_job1_eco_isic3=11 if ramaemppri==12
		replace ilo_job1_eco_isic3=12 if ramaemppri==13
		replace ilo_job1_eco_isic3=13 if ramaemppri==14
		replace ilo_job1_eco_isic3=14 if ramaemppri==15
		replace ilo_job1_eco_isic3=15 if ramaemppri==16
		replace ilo_job1_eco_isic3=16 if ramaemppri==17
		replace ilo_job1_eco_isic3=17 if ramaemppri==18
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
	
    				
    *---------------------------------------------------------------------------
	* ISIC REV 3.1
	*---------------------------------------------------------------------------
	
 

	* 1-digit level	
    gen ilo_job2_eco_isic3=.
		replace ilo_job2_eco_isic3=ramaempsec
		replace ilo_job2_eco_isic3=18 if ramaempsec==18 & ilo_mjh==2
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
* Comment: variable used: ocupemppri (and ocupempsec). 
*          The COCR-2000 is the national classification which follows the ISCO-88 classification

* Comment: In Costa Rica there are not armed forces. 



    ***********
    * MAIN JOB:
    ***********
 
    *---------------------------------------------------------------------------
	* ISCO 88
	*---------------------------------------------------------------------------

 
			
    * 1-digit level
	gen ilo_job1_ocu_isco88=.
		replace ilo_job1_ocu_isco88=ocupemppri if ilo_lfs==1
		replace ilo_job1_ocu_isco88=11 if ocupemppri==10  & ilo_lfs==1          // Not elsewhere classified
	    
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
				
 			
				
    *************
    * SECOND JOB:
    *************
	
	*---------------------------------------------------------------------------
	* ISCO 88
	*---------------------------------------------------------------------------
 
			
    * 1-digit level
	gen ilo_job2_ocu_isco88=.
		replace ilo_job2_ocu_isco88=ocupempsec if ilo_mjh==2
	    replace ilo_job2_ocu_isco88=11 if ocupempsec==10 & ilo_mjh==2                          // Not elsewhere classified
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
* Comment: missing values are considered as private sector
		
	gen ilo_job1_ins_sector=.
		replace ilo_job1_ins_sector=1 if inlist(secinspri,1,2) & ilo_lfs==1    // Public
		replace ilo_job1_ins_sector=2 if ilo_job1_ins_sector==. & ilo_lfs==1    // Private
			    lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
			    lab values ilo_job1_ins_sector ins_sector_lab
			    lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities - main job"
		
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*		               Hours of work ('ilo_how')  	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 
				
    ***********
    * MAIN JOB:
    ***********
	
	* Hours USUALLY worked
	gen ilo_job1_how_usual = .
	    replace ilo_job1_how_usual = c2a1 if ilo_lfs==1 & c2a1!=999
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
	gen ilo_job1_how_actual = .
	    replace ilo_job1_how_actual = c2a4 if ilo_lfs==1 & c2a4!=999
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
	
    *************
    * SECOND JOB:
    *************
	
	* Hours USUALLY worked
	gen ilo_job2_how_usual = .
	    replace ilo_job2_how_usual = c2b1 if ilo_mjh==2 & c2b1!=999
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
				
	* Hours ACTUALLY worked
    gen ilo_job2_how_actual = .
	    replace ilo_job2_how_actual = c2b4 if ilo_mjh==2 & c2b4!=999
	            lab var ilo_job2_how_actual "Weekly hours actually worked - second job"
		
	gen ilo_job2_how_actual_bands=.
	    replace ilo_job2_how_actual_bands=1 if ilo_job2_how_actual==0
		replace ilo_job2_how_actual_bands=2 if ilo_job2_how_actual>=1 & ilo_job2_how_actual<=14
		replace ilo_job2_how_actual_bands=3 if ilo_job2_how_actual>14 & ilo_job2_how_actual<=29
		replace ilo_job2_how_actual_bands=4 if ilo_job2_how_actual>29 & ilo_job2_how_actual<=34
		replace ilo_job2_how_actual_bands=5 if ilo_job2_how_actual>34 & ilo_job2_how_actual<=39
		replace ilo_job2_how_actual_bands=6 if ilo_job2_how_actual>39 & ilo_job2_how_actual<=48
		replace ilo_job2_how_actual_bands=7 if ilo_job2_how_actual>48 & ilo_job2_how_actual!=.
		replace ilo_job2_how_actual_bands=8 if ilo_job2_how_actual_bands==. & ilo_mjh==2
		replace ilo_job2_how_actual_bands=. if ilo_mjh!=2
		        * labels already defined for main job
		   	    lab val ilo_job2_how_actual_bands how_bands_act
				lab var ilo_job2_how_actual_bands "Weekly hours actually worked bands - second job"
		
    ***********
    * ALL JOBS:
    ***********
	
	* Hours USUALLY worked
 egen ilo_joball_how_usual = rowtotal(ilo_job1_how_usual ilo_job2_how_usual), m 
			 lab var ilo_joball_how_usual "Weekly hours usually worked in all jobs"
		 
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
				
	* Hours ACTUALLY worked
   egen ilo_joball_how_actual = rowtotal(ilo_job1_how_actual ilo_job2_how_actual), m 
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
		        * labels already defined for main job
			 	lab val ilo_joball_how_actual_bands how_bands_act
				lab var ilo_joball_how_actual_bands "Weekly hours actually worked bands - all jobs"
		
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job_time')		                   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 
			
	gen ilo_job1_job_time=.
		replace ilo_job1_job_time=2 if ilo_joball_how_usual>=40  & ilo_lfs==1                             // Full-time
		replace ilo_job1_job_time=1 if ilo_joball_how_usual<40 & ilo_joball_how_usual!=. & ilo_lfs==1     // Part-time
		replace ilo_job1_job_time=3 if ilo_job1_job_time==. & ilo_lfs==1
			    lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
			    lab val ilo_job1_job_time job_time_lab
			    lab var ilo_job1_job_time "Job (Working time arrangement)"
			
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*		    	Type of contract ('ilo_job_contract') 		                   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 

	
	gen ilo_job1_job_contract=.
		replace ilo_job1_job_contract=1 if estabili==1 & ilo_lfs==1             // Permanent
		replace ilo_job1_job_contract=2 if inrange(estabili,2,6) & ilo_lfs==1  // Temporary
		replace ilo_job1_job_contract=3 if ilo_job1_job_contract==. & ilo_lfs==1 // Unknown
			    lab def job_contract_lab 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"
			    lab val ilo_job1_job_contract job_contract_lab
			    lab var ilo_job1_job_contract "Job (Type of contract)"

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*  Informal/formal economy: ('ilo_job1_ife_prod'/'ilo_job1_ife_nature') 	   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment:  

/* Useful questions:
          - Institutional sector: secinspri  
		  - Private household identification: Household, use:(posiemppri==11) or (ramaemppri==20)
		  - Destination of production: [no info]  
		  - Bookkeeping: d12 [only asked to self-employed]
		  - Registration: d11 [only asked to self-employed]
		  - Status in employment: ilo_job1_ste_icse93
		  - Social security contribution (Proxy: pension funds): e10a [only asked to employees]
		  - Place of work: c11
		  - Size: c10
		  - Paid annual leave: e9c [only asked to employees]
		  - Paid sick leave: e9b [only asked to employees]
*/

 
    * Social Security:
	gen social_security=.
	    replace social_security=1 if e10a==1  &  ilo_lfs==1          // social security (proxy)
		replace social_security=2 if e10a!=1  &  ilo_lfs==1          // no social security (proxy)
	
    * 1) UNIT OF PRODUCTION: FORMAL/INFORMAL SECTOR
	gen ilo_job1_ife_prod=.
	
	    replace ilo_job1_ife_prod=3 if ilo_lfs==1 & ramaemppri==20  
		
 		 
		replace ilo_job1_ife_prod=2 if ilo_lfs==1 & ilo_job1_ife_prod!=3 & ///
		                               ((inlist(secinspri,1,2)) | ///
									   (!inlist(secinspri,1,2) &  d12==1) | ///
									   (!inlist(secinspri,1,2) &  d12!=1 & inlist(d11,1,2)) | ///
									   (!inlist(secinspri,1,2) &  d12!=1 & !inlist(d11,1,2) & ilo_job1_ste_icse93==1 & social_security==1) | ///
									   (!inlist(secinspri,1,2) &  d12!=1 & !inlist(d11,1,2) & ilo_job1_ste_icse93==1 & social_security!=1 & inlist(c11,5,6,7) & inrange(c10,6,13)) | ///
									   (!inlist(secinspri,1,2) &  d12!=1 & !inlist(d11,1,2) & ilo_job1_ste_icse93!=1 & social_security!=1 & inlist(c11,5,6,7) & inrange(c10,6,13)))
	 
		
		replace ilo_job1_ife_prod=1 if ilo_lfs==1 & !inlist(ilo_job1_ife_prod,2,3)
				lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 
				lab val ilo_job1_ife_prod ilo_ife_prod_lab
				lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"		
		
	
	* 2) NATURE OF JOB: FORMAL/INFORMAL EMPLOYMENT
	gen ilo_job1_ife_nature=.
	    replace ilo_job1_ife_nature=1 if ilo_lfs==1 & ///
	                                     ((inlist(ilo_job1_ste_icse93,1,6) & social_security==2) | ///
										 (inlist(ilo_job1_ste_icse93,1,6) & social_security==. & inlist(e9c,2,3)) | ///
										 (inlist(ilo_job1_ste_icse93,1,6) & social_security==. & e9c==1 & inlist(e9b,2,3)) | ///
										 (inlist(ilo_job1_ste_icse93,2,4) & inlist(ilo_job1_ife_prod,1,3)) | ///
										 (ilo_job1_ste_icse93==3 & inlist(ilo_job1_ife_prod,1,3)) | ///
										 (ilo_job1_ste_icse93==5))
	    replace ilo_job1_ife_nature=2 if ilo_lfs==1 & ///
			                             ilo_job1_ife_nature==. & ilo_lfs==1
	            lab def ife_nature_lab 1 "1 - Persons with informal main job" 2 "2 - Persons with formal main job"
		        lab val ilo_job1_ife_nature ife_nature_lab
		        lab var ilo_job1_ife_nature "Informal / Formal Economy (Nature of job)"	

				 
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*	    Monthly labour related income ('ilo_lri_ees' and 'ilo_lri_slf')  	   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 

    ***********
    * MAIN JOB:
    ***********
	
	* Employees
	gen ilo_job1_lri_ees = .
	    replace ilo_job1_lri_ees = ipbt if ilo_job1_ste_aggregate==1
	    replace ilo_job1_lri_ees = .     if ilo_lfs!=1
		        lab var ilo_job1_lri_ees "Monthly earnings of employees - main job"
	
	* Self-employed
	gen ilo_job1_lri_slf = .
	    replace ilo_job1_lri_slf = ipbt if ilo_job1_ste_aggregate==2
	    replace ilo_job1_lri_slf = .     if ilo_lfs!=1
		        lab var ilo_job1_lri_slf "Monthly labour related income of self-employed - main job"
			
    *************
    * SECOND JOB:
    *************
	
	* Employees
	gen ilo_job2_lri_ees = .
	    replace ilo_job2_lri_ees = isbt if ilo_job2_ste_aggregate==1
		replace ilo_job2_lri_ees = .     if ilo_mjh!=2
		        lab var ilo_job2_lri_ees "Monthly earnings of employees - second job"
		
    * Self-employed		
	gen ilo_job2_lri_slf = .
	    replace ilo_job2_lri_slf = isbt if ilo_job2_ste_aggregate==2
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
* Comment: the national threshold is in 40 hrs. 

	gen ilo_joball_tru = .
	    replace ilo_joball_tru = 1 if ilo_joball_how_usual<=39  & c3a==1 &  inlist(c3b,1,2) & ilo_lfs==1
			    lab def tru_lab 1 "Time-related underemployed"
			    lab val ilo_joball_tru tru_lab
			    lab var ilo_joball_tru "Time-related underemployed"

/*
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
*	Cases of non-fatal occupational injury ('ilo_joball_oi_case') 		       *
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
* Comment: no info

	 gen ilo_joball_oi_case = .
		 replace ilo_joball_oi_case =       if ilo_lfs==1
				 lab var ilo_joball_oi_case "Cases of non-fatal occupational injuries"

*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
*  Days lost due to cases of occupational injury ('ilo_joball_oi_day')		   *
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
* Comment: no info

	gen ilo_joball_oi_day = .
		replace ilo_joball_oi_day =       if ilo_lfs==1
				lab var ilo_joball_oi_day "Days lost due to cases of occupational injury"

*/
				
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
		replace ilo_cat_une=1 if g6==1 & ilo_lfs==2                     // Previously employed       
		replace ilo_cat_une=2 if g6==2 & ilo_lfs==2                     // Seeking for the first time
		replace ilo_cat_une=3 if ilo_cat_une==. & ilo_lfs==2           // Unknown
			    lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
			    lab val ilo_cat_une cat_une_lab
			    lab var ilo_cat_une "Category of unemployment"
				
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			   Duration of unemployment ('ilo_dur')  	                       * 
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: only aggregate variable is possible to compute

		
    * Aggregate categories
	gen ilo_dur_aggregate=.
		replace ilo_dur_aggregate=1 if (inrange(g2,1,3) & ilo_lfs==2)           // Less than 6 months
		replace ilo_dur_aggregate=2 if (g2==4 & ilo_lfs==2)                     // 6 to 12 months
		replace ilo_dur_aggregate=3 if (inlist(g2,5,6) & ilo_lfs==2)            // 12 months or more
		replace ilo_dur_aggregate=4 if (ilo_dur_aggregate==. & ilo_lfs==2)      // Not elsewhere classified
		replace ilo_dur_aggregate=. if ilo_lfs!=2
			    lab def unemp_aggr 1 "1 - Less than 6 months" 2 "2 - 6 months to less than 12 months" 3 "3 - 12 months or more" 4 "4 - Not elsewhere classified"
			    lab val ilo_dur_aggregate unemp_aggr
			    lab var ilo_dur_aggregate "Duration of unemployment (Aggregate)"
		
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic3') 	               * 
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 

  
    *---------------------------------------------------------------------------
	* ISIC REV 3.1
	*---------------------------------------------------------------------------


	* 1-digit level	
    gen ilo_preveco_isic3=.
		replace ilo_preveco_isic3=1 if ramaultempcesant==2 & ilo_lfs==2 & ilo_cat_une==1
		replace ilo_preveco_isic3=2 if ramaultempcesant==3 & ilo_lfs==2 & ilo_cat_une==1
		replace ilo_preveco_isic3=3 if ramaultempcesant==4 & ilo_lfs==2 & ilo_cat_une==1
		replace ilo_preveco_isic3=4 if ramaultempcesant==5 & ilo_lfs==2 & ilo_cat_une==1
		replace ilo_preveco_isic3=5 if ramaultempcesant==6 & ilo_lfs==2 & ilo_cat_une==1
		replace ilo_preveco_isic3=6 if ramaultempcesant==7 & ilo_lfs==2 & ilo_cat_une==1
		replace ilo_preveco_isic3=7 if ramaultempcesant==8 & ilo_lfs==2 & ilo_cat_une==1
		replace ilo_preveco_isic3=8 if ramaultempcesant==9 & ilo_lfs==2 & ilo_cat_une==1
		replace ilo_preveco_isic3=9 if ramaultempcesant==10 & ilo_lfs==2 & ilo_cat_une==1
		replace ilo_preveco_isic3=10 if ramaultempcesant==11 & ilo_lfs==2 & ilo_cat_une==1
		replace ilo_preveco_isic3=11 if ramaultempcesant==12 & ilo_lfs==2 & ilo_cat_une==1
		replace ilo_preveco_isic3=12 if ramaultempcesant==13 & ilo_lfs==2 & ilo_cat_une==1
		replace ilo_preveco_isic3=13 if ramaultempcesant==14 & ilo_lfs==2 & ilo_cat_une==1
		replace ilo_preveco_isic3=14 if ramaultempcesant==15 & ilo_lfs==2 & ilo_cat_une==1
		replace ilo_preveco_isic3=15 if ramaultempcesant==16 & ilo_lfs==2 & ilo_cat_une==1
		replace ilo_preveco_isic3=16 if ramaultempcesant==17 & ilo_lfs==2 & ilo_cat_une==1
		replace ilo_preveco_isic3=17 if ramaultempcesant==18 & ilo_lfs==2 & ilo_cat_une==1
		replace ilo_preveco_isic3=18 if ramaultempcesant==1 & ilo_lfs==2 & ilo_cat_une==1
                * labels already defined for main job
		        lab val ilo_preveco_isic3 eco_isic3_1digit
			    lab var ilo_preveco_isic3 "Previous economic activity (ISIC Rev. 3.1)"
	
	* Aggregate level
	gen ilo_preveco_aggregate=.
		replace ilo_preveco_aggregate=1 if inlist(ilo_preveco_isic3,1,2)
		replace ilo_preveco_aggregate=2 if ilo_preveco_isic3==4
		replace ilo_preveco_aggregate=3 if ilo_preveco_isic3==6
		replace ilo_preveco_aggregate=4 if inlist(ilo_preveco_isic3,3,5)
		replace ilo_preveco_aggregate=5 if inrange(ilo_preveco_isic3,7,11)
		replace ilo_preveco_aggregate=6 if inrange(ilo_preveco_isic3,12,17)
		replace ilo_preveco_aggregate=7 if ilo_preveco_isic3==18
                * labels already defined for main job
		        lab val ilo_preveco_aggregate eco_aggr_lab
			    lab var ilo_preveco_aggregate "Previous economic activity (Aggregate)"
		
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu_isco08') 		                   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: no info

  
				 
	 
				
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
* Comment: there is no information on willigness. 
* Comment: this variable cannot be computed because there is a high number of missings. 

	/*
	gen ilo_olf_dlma=.
		replace ilo_olf_dlma = 1 if (b7a==1|b7b==2|b7c==3|b7d==4|b7e==5|b7f==6|b7g==7|b7h==8|b7i==9|b7j==10|b7k==11) & inrange(b6,1,7) & ilo_lfs==3      // Seeking, not available
		replace ilo_olf_dlma = 2 if  b7l==0 & inlist(b6,8,9)             & ilo_lfs==3	    // Not seeking, available
		*replace ilo_olf_dlma = 3 if 		      & ilo_lfs==3      // Not seeking, not available, willing
		*replace ilo_olf_dlma = 4 if 		      & ilo_lfs==3      // Not seeking, not available, not willing
		replace ilo_olf_dlma = 5 if	(ilo_olf_dlma==. & ilo_lfs==3)	// Not classified 
	 		    lab def dlma_lab 1 "1 - Seeking, not available (Unavailable jobseekers)" 2 "2 - Not seeking, available (Available potential jobseekers)" ///
							     3 "3 - Not seeking, not available, willing (Willing non-jobseekers)" 4 "4 - Not seeking, not available, not willing" 5 "X - Not elsewhere classified"
			    lab val ilo_olf_dlma dlma_lab 
			    lab var ilo_olf_dlma "Labour market attachment (Degree of)"
*/
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			Reasons for not seeking a job ('ilo_olf_reason') 	               *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 

		gen ilo_olf_reason=.
			replace ilo_olf_reason=1 if inlist(b8,4,5,6,7) & ilo_lfs==3         // Labour market 
			replace ilo_olf_reason=2 if inlist(b8,2,3,8,9)& ilo_lfs==3          // Other labour market reasons
			replace ilo_olf_reason=3 if inlist(b8,10,11,12,13) & ilo_lfs==3     // Personal/Family-related
			replace ilo_olf_reason=4 if b8==14 & ilo_lfs==3                     // Does not need/want to work
			replace ilo_olf_reason=5 if ilo_olf_reason==. & ilo_lfs==3          // Not elsewhere classified
 			        lab def lab_olf_reason 1 "1 - Labour market" 2 " 2 - Other labour market reasons" 3 "3 - Personal/Family-related"  ///
				                           4 "4 - Does not need/want to work" 5 "5 - Not elsewhere classified"
					lab val ilo_olf_reason lab_olf_reason
					lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"		

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			      Discouraged job-seekers ('ilo_dis') 		                   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment:

	gen ilo_dis=.
	    replace ilo_dis=1 if !inlist(ilo_lfs,1,2) & inlist(b6,8,9) & ilo_olf_reason==1
			    lab def ilo_dis_lab 1 "Discouraged job-seekers" 
			    lab val ilo_dis ilo_dis_lab
			    lab var ilo_dis "Discouraged job-seekers"	
			
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
	
 	 
	 
		
	/* Save dataset including original and ilo variables*/
	save ${country}_${source}_${time}_FULL,  replace		
	
	*Save file only containing ilo_* variables
	keep ilo*
	save ${country}_${source}_${time}_ILO, replace
		
