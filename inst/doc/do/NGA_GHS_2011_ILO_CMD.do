* TITLE OF DO FILE: ILO Microdata Preprocessing code template - NIGERIA, 2010 
* DATASET USED: NIGERIA, GHS, 2010, Post Harvest
* Files created: Standard variables NGA_GHS_2010_FULL.dta and NGA_GHS_2010_ILO.dta
* Authors: ILO / Department of Statistics / DPAU
* Starting Date: 23 July 2018
* Last updated: 28 August 2018
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
global country "NGA" 
global source "GHS"
global time "2011"
global inputFile "NGA_GHS_2011.dta"
global inpath "${path}\\${country}\\${source}\\${time}\ORI"
global temppath "${path}\_Admin"
global outpath "${path}\\${country}\\${source}\\${time}"

********************************************************************************
********************************************************************************

cd "$inpath"
	use ${inputFile}, clear
	rename *, lower  
	
	* Don't consider observations without a weighting factor
	
	drop if missing(wt_wave1)
	
	* Exclude also all observations having a missing value for the age variable
	
	drop if missing(s1q4)
	
	* Exclude also observations having a missing value for the sex variable 
	
	drop if missing(s1q2)

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

* Comment: consider weighting factor for second wave

	gen ilo_wgt=.
	    replace ilo_wgt= wt_wave1
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
	
	gen ilo_geo=.
	    replace ilo_geo=1 if  sector==1        // Urban 
		replace ilo_geo=2 if sector==2         // Rural
		        lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural"
		        lab val ilo_geo ilo_geo_lab
		        lab var ilo_geo "Geographical coverage"	
		
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			                     Sex ('ilo_sex') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------ 
	
	gen ilo_sex=.
	    replace ilo_sex=1 if s1q2==1            // Male
		replace ilo_sex=2 if s1q2==2            // Female
		        label define label_Sex 1 "1 - Male" 2 "2 - Female"
		        label values ilo_sex label_Sex
		        lab var ilo_sex "Sex"

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			                    Age ('ilo_age') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
	
	gen ilo_age=.
	    replace ilo_age= s1q4 
				keep if inrange(ilo_age,0,110)
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

* Comment: Question only asked to a very reduced set of individuals.
/*
    *---------------------------------------------------------------------------
	* ISCED 11
	*---------------------------------------------------------------------------
				
    * Detailed				
    gen ilo_edu_isced11=.
		replace ilo_edu_isced11=1 if s2aq10==1     | s2aq6==2                  // No schooling
		replace ilo_edu_isced11=2 if s2aq10==2                       // Early childhood education
		replace ilo_edu_isced11=3 if s2aq10==3                       // Primary education
		replace ilo_edu_isced11=4 if inlist(s2aq10,4,5)                       // Lower secondary education
		replace ilo_edu_isced11=5 if s2aq10==6                       // Upper secondary education
		replace ilo_edu_isced11=6 if   s2aq10==7                     // Post-secondary non-tertiary education
		replace ilo_edu_isced11=7 if   s2aq10==8                     // Short-cycle tertiary education
		replace ilo_edu_isced11=8 if  inlist(s2aq10,9,10)                      // Bachelor's or equivalent level
		replace ilo_edu_isced11=9 if s2aq10==11                       // Master's or equivalent level
		replace ilo_edu_isced11=10 if s2aq10==12                      // Doctoral or equivalent level
		replace ilo_edu_isced11=11 if ilo_edu_isced11==.    // Not elsewhere classified
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
*/
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*		  	 Educational attendance ('ilo_edu_attendance') 		               *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

* Comment: Question asked to individuals aged over 5
			
    gen ilo_edu_attendance=.
		replace ilo_edu_attendance=1 if  s2aq13==1                      // Attending
		replace ilo_edu_attendance=2 if  s2aq13==2                      // Not attending
		replace ilo_edu_attendance=3 if ilo_edu_attendance==.  // Not elsewhere classified
			    lab def edu_attendance_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
			    lab val ilo_edu_attendance edu_attendance_lab
			    lab var ilo_edu_attendance "Education (Attendance)"

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			           Marital status ('ilo_mrts') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
	
	* Detailed
	gen ilo_mrts_details=.
	    replace ilo_mrts_details=1 if  s1q7==7                                         // Single
		replace ilo_mrts_details=2 if  inlist(s1q7,1,2)                                         // Married
		replace ilo_mrts_details=3 if  s1q7==3                                         // Union / cohabiting
		replace ilo_mrts_details=4 if  s1q7==6                                         // Widowed
		replace ilo_mrts_details=5 if  inlist(s1q7,4,5)                                         // Divorced / separated
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

		gen ilo_dsb_details=.
             replace ilo_dsb_details=1 if (s4aq23==1 & s4aq25==1 & s4aq27==1 & s4aq29==1 & s4aq31==1 )                            
             replace ilo_dsb_details=2 if (s4aq23==2 | s4aq25==2 | s4aq27==2 | s4aq29==2 | s4aq31==2 )                                                 
             replace ilo_dsb_details=3 if (s4aq23==3 | s4aq25==3 | s4aq27==3 | s4aq29==3 | s4aq31==3 )                                                 
             replace ilo_dsb_details=4 if (s4aq23==4 | s4aq25==4 | s4aq27==4 | s4aq29==4 | s4aq31==4)
				replace ilo_dsb_details=1 if ilo_dsb_details==.
				label def dsb_det_lab 1 "1 - No, no difficulty" 2 "2 - Yes, some difficulty" 3 "3 - Yes, a lot of difficulty" 4 "4 - Cannot do it at all"
				label val ilo_dsb_details dsb_det_lab
				label var ilo_dsb_details "Disability status (Details)"

    * Aggregate  	
	gen ilo_dsb_aggregate=.
	    replace ilo_dsb_aggregate=1 if (ilo_dsb_details==1 | ilo_dsb_details==2)   // Persons without disability
		replace ilo_dsb_aggregate=2 if (ilo_dsb_details==3 | ilo_dsb_details==4)  // Persons with disability
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
	
	gen ilo_lfs=.
        replace ilo_lfs=1 if (s3aq1==1 | s3aq2==1 | s3aq3==1 | s3aq4==1) & ilo_wap==1						// Employed: ILO definition
		replace ilo_lfs=1 if (s3aq7==4 & inlist(s3aq6,4,8)) & ilo_wap==1						// Employed: temporary absent
		replace ilo_lfs=2 if (s3aq5==1 & s3aq7==1) & ilo_lfs!=1 & ilo_wap==1			// Unemployed: three criteria
		*replace ilo_lfs=2 if (inlist(s3aq3,6,7) & (s3aq7==1)) & ilo_lfs!=1 & ilo_wap==1			// Unemployed: available future starters
	    replace ilo_lfs=3 if !inlist(ilo_lfs,1,2) & ilo_wap==1		// Outside the labour force
				label define label_ilo_lfs 1 "1 - Employed" 2 "2 - Unemployed" 3 "3 - Outside Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status" 
			
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			       Multiple job holders ('ilo_mjh')                            *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------ 

    gen ilo_mjh=.
		replace ilo_mjh=2 if (s3aq21==1) & ilo_lfs==1             // One job only     
		replace ilo_mjh=1 if (s3aq21==2) & ilo_lfs==1             // More than one job
		replace ilo_mjh=. if ilo_lfs!=1
		replace ilo_mjh=1 if ilo_mjh==. & ilo_lfs==1
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

* Comment: Variable s3aq12 does not only allow to derive status in employment at the aggregate level as Self employed category is missing 

/*
   * MAIN JOB
   * ICSE 1993
	 gen ilo_job1_ste_icse93=.
		 replace ilo_job1_ste_icse93=1 if  & ilo_lfs==1          // Employees
		 replace ilo_job1_ste_icse93=2 if  & ilo_lfs==1          // Employers
		 replace ilo_job1_ste_icse93=3 if  & ilo_lfs==1          // Own-account workers
		 replace ilo_job1_ste_icse93=4 if  & ilo_lfs==1          // Members of producers' cooperatives
		 replace ilo_job1_ste_icse93=5 if  & ilo_lfs==1          // Contributing family workers
		 replace ilo_job1_ste_icse93=6 if ilo_job1_ste_icse93==. & ilo_lfs==1   // Workers not classifiable by status
		 replace ilo_job1_ste_icse93=. if ilo_lfs!=1
				 label def label_ilo_ste_icse93 1 "1 - Employees" 2 "2 - Employers" 3 "3 - Own-account workers" ///
				                                4 "4 - Members of producers' cooperatives" 5 "5 - Contributing family workers" ///
												6 "6 - Workers not classifiable by status"
				 label val ilo_job1_ste_icse93 label_ilo_ste_icse93
				 label var ilo_job1_ste_icse93 "Status in employment (ICSE 93) - main job"
*/
	* Aggregate categories 
	  gen ilo_job1_ste_aggregate=.
		  replace ilo_job1_ste_aggregate=1 if inrange(s3aq12,1,8) & ilo_lfs==1                // Employees
		  replace ilo_job1_ste_aggregate=2 if s3aq12==9  & ilo_lfs==1  // Self-employed
		  replace ilo_job1_ste_aggregate=3 if ilo_job1_ste_aggregate==. & ilo_lfs==1         // Not elsewhere classified
				  lab def ste_aggr_lab 1 "1 - Employees" 2 "2 - Self-employed" 3 "3 - Not elsewhere classified"
				  lab val ilo_job1_ste_aggregate ste_aggr_lab
				  label var ilo_job1_ste_aggregate "Status in employment (Aggregate) - main job"
				

	* Aggregate categories
	  gen ilo_job2_ste_aggregate=.
		  replace ilo_job2_ste_aggregate=1 if inrange(s3aq24,1,8)  & ilo_mjh==2                  // Employees
		  replace ilo_job2_ste_aggregate=2 if s3aq24==9   & ilo_mjh==2     // Self-employed
		  replace ilo_job2_ste_aggregate=3 if ilo_job2_ste_aggregate==. & ilo_mjh==2         // Not elsewhere classified
				  lab val ilo_job2_ste_aggregate ste_aggr_lab
				  label var ilo_job2_ste_aggregate "Status in employment (Aggregate) - second job"

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			            Economic activity ('ilo_eco')                          *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

* Comment: Question s3aq11 does only allow to derive the economic activity at the aggregate level

    * MAIN JOB
	

   * Aggregate level
		gen ilo_job1_eco_aggregate=.
			replace ilo_job1_eco_aggregate=1 if s3aq11==1 & ilo_lfs==1
			replace ilo_job1_eco_aggregate=2 if s3aq11==3 & ilo_lfs==1
			replace ilo_job1_eco_aggregate=3 if s3aq11==6 & ilo_lfs==1
			replace ilo_job1_eco_aggregate=4 if inlist(s3aq11,2,5) & ilo_lfs==1
			replace ilo_job1_eco_aggregate=5 if inlist(s3aq11,4,7,8,9) & ilo_lfs==1
			replace ilo_job1_eco_aggregate=6 if inlist(s3aq11,10,11,12,13) & ilo_lfs==1
			replace ilo_job1_eco_aggregate=7 if ilo_job1_eco_aggregate==. & ilo_lfs==1
			replace ilo_job1_eco_aggregate=. if ilo_lfs!=1
			    lab def eco_aggr_lab 1 "1 - Agriculture" 2 "2 - Manufacturing" 3 "3 - Construction" 4 "4 - Mining and quarrying; Electricity, gas and water supply" ///
								     5 "5 - Market Services (Trade; Transportation; Accommodation and food; and Business and administrative services)"  ///
								     6 "6 - Non-market services (Public administration; Community, social and other services and activities)" 7 "7 - Not classifiable by economic activity"					
				lab val ilo_job1_eco_aggregate eco_aggr_lab
				lab var ilo_job1_eco_aggregate "Economic activity (Aggregate) - main job"


    * SECOND JOB
	
    
   * Aggregate level
   gen ilo_job2_eco_aggregate=.
	replace ilo_job2_eco_aggregate=1 if s3aq23==1 &  ilo_mjh==2
			replace ilo_job2_eco_aggregate=2 if s3aq23==3 &  ilo_mjh==2
			replace ilo_job2_eco_aggregate=3 if s3aq23==6 &  ilo_mjh==2
			replace ilo_job2_eco_aggregate=4 if inlist(s3aq23,2,5)&  ilo_mjh==2
			replace ilo_job2_eco_aggregate=5 if inlist(s3aq23,4,7,8,9) & ilo_mjh==2
			replace ilo_job2_eco_aggregate=6 if inlist(s3aq23,10,11,12,13) & ilo_mjh==2
	   replace ilo_job2_eco_aggregate=7 if ilo_job2_eco_aggregate==. & ilo_lfs==1 & ilo_mjh==2
               * labels already defined for main job
	           lab val ilo_job2_eco_aggregate eco_aggr_lab
			   lab var ilo_job2_eco_aggregate "Economic activity (Aggregate) - second job"				

			   
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			               Occupation ('ilo_ocu') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

    *---------------------------------------------------------------------------
	* ISCO 88
	*---------------------------------------------------------------------------

    * MAIN JOB
		* 2-digit level 
		
    gen ilo_job1_ocu_isco88_2digits = . 
	    replace ilo_job1_ocu_isco88_2digits = int(s3aq10/100)    if ilo_lfs==1
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
	    replace ilo_job1_ocu_isco88=11 if inlist(ilo_job1_ocu_isco88_2digits,.) & ilo_lfs==1                          // Not elsewhere classified
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

       * SECOND JOB
	
	*---------------------------------------------------------------------------
	* ISCO 88
	*---------------------------------------------------------------------------

	* 2-digit level 
    gen ilo_job2_ocu_isco88_2digits = . 
	    replace ilo_job2_ocu_isco88_2digits = int(s3aq22/100)     if ilo_mjh==2
		replace ilo_job2_ocu_isco88_2digits = .   if ilo_mjh!=2
                * labels already defined for main job
		        lab values ilo_job2_ocu_isco88_2digits ocu_isco88_2digits
	            lab var ilo_job2_ocu_isco88_2digits "Occupation (ISCO-88), 2 digit level - second job"
			
    * 1-digit level
	gen ilo_job2_ocu_isco88=.
	    replace ilo_job2_ocu_isco88=11 if inlist(ilo_job2_ocu_isco88_2digits,.) & ilo_mjh==2                          // Not elsewhere classified
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
		
	gen ilo_job1_ins_sector=.
		replace ilo_job1_ins_sector=1 if inlist(s3aq12,1,2,3,7) & ilo_lfs==1    // Public
		replace ilo_job1_ins_sector=2 if ilo_job1_ins_sector==. & ilo_lfs==1    // Private
			    lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
			    lab values ilo_job1_ins_sector ins_sector_lab
			    lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities - main job"
		
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*		               Hours of work ('ilo_how')  	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

    * MAIN JOB

	* Hours ACTUALLY worked
	gen ilo_job1_how_actual = .
	    replace ilo_job1_how_actual = s3aq15      if ilo_lfs==1
		replace ilo_job1_how_actual=168 if ilo_job1_how_actual>168 & ilo_job1_how_actual!=.
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
	

    * SECOND JOB
	
	* Hours ACTUALLY worked
    gen ilo_job2_how_actual = .
	    replace ilo_job2_how_actual = s3aq27      if ilo_mjh==2
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
		
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job_time')		                   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
			
	gen ilo_job1_job_time=.
		replace ilo_job1_job_time=2 if ilo_job1_how_actual>=40  & ilo_lfs==1                             // Full-time
		replace ilo_job1_job_time=1 if ilo_job1_how_actual<40 & ilo_job1_how_actual!=. & ilo_lfs==1     // Part-time
		replace ilo_job1_job_time=3 if ilo_job1_job_time==. & ilo_lfs==1
			    lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
			    lab val ilo_job1_job_time job_time_lab
			    lab var ilo_job1_job_time "Job (Working time arrangement)"
			
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*		    	Type of contract ('ilo_job_contract') 		                   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

* Comment: No information
	
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*  Informal/formal economy: ('ilo_job1_ife_prod'/'ilo_job1_ife_nature') 	   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

* Comment: Not enough information to derive Informal/formal economy indicators. 
*		

/* Useful questions:
          - Institutional sector: s3aq12
		  - Private household identification: 
		  - Destination of production: 
		  - Bookkeeping: No info
		  - Registration: No info
		  - Status in employment: ilo_job1_ste_aggregate
		  - Social security contribution (Proxy: pension funds): s3aq32 (health insurance)
		  - Place of work:
		  - Size:
		  - Paid annual leave:
		  - Paid sick leave:

    * Social Security:
	gen social_security=.
	    replace social_security=1 if     ilo_lfs==1          // social security (proxy)
		replace social_security=2 if     ilo_lfs==1          // no social security (proxy)
	
    * 1) UNIT OF PRODUCTION: FORMAL/INFORMAL SECTOR
	gen ilo_job1_ife_prod=.
	    replace ilo_job1_ife_prod=3 if ilo_lfs==1 & ///
		                               (() | ///
									   ())
		replace ilo_job1_ife_prod=2 if ilo_lfs==1 & ilo_job1_ife_prod!=3 & ///
		                               (() | ///
									   () | ///
									   () | ///
									   () | ///
									   () | ///
									   ())
		replace ilo_job1_ife_prod=1 if ilo_lfs==1 & !inlist(ilo_job1_ife_prod,2,3)
				lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 
				lab val ilo_job1_ife_prod ilo_ife_prod_lab
				lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"		
		
	
	* 2) NATURE OF JOB: FORMAL/INFORMAL EMPLOYMENT
	gen ilo_job1_ife_nature=.
	    replace ilo_job1_ife_nature=2 if ilo_lfs==1 & ///
	                                     (() | ///
										 () | ///
										 () | ///
										 ())
	    replace ilo_job1_ife_nature=1 if ilo_lfs==1 & ilo_job1_ife_nature!=2
                lab def ife_nature_lab 1 "1 - Persons with informal main job" 2 "2 - Persons with formal main job"
		        lab val ilo_job1_ife_nature ife_nature_lab
		        lab var ilo_job1_ife_nature "Informal / Formal Economy (Nature of job)"	
*/		
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*	    Monthly labour related income ('ilo_lri_ees' and 'ilo_lri_slf')  	   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

    * MAIN JOB
	
	* Employees
	gen ilo_job1_lri_ees = .
	    replace ilo_job1_lri_ees = s3aq18a       if ilo_job1_ste_aggregate==1 & s3aq18a>0
		replace ilo_job1_lri_ees = ilo_job1_lri_ees * ilo_job1_how_actual *(365/12) if s3aq18b==1 & ilo_job1_how_actual>0
		replace ilo_job1_lri_ees = ilo_job1_lri_ees *(365/12) if s3aq18b==2
		replace ilo_job1_lri_ees = ilo_job1_lri_ees *(56/12) if s3aq18b==3
		replace ilo_job1_lri_ees = ilo_job1_lri_ees *(26/12) if s3aq18b==4
		replace ilo_job1_lri_ees =  ilo_job1_lri_ees /3 if s3aq18b==6
		replace ilo_job1_lri_ees = ilo_job1_lri_ees /6 if s3aq18b==7
		replace ilo_job1_lri_ees = ilo_job1_lri_ees /12 if s3aq18b==8
	    replace ilo_job1_lri_ees = .     if ilo_lfs!=1
		        lab var ilo_job1_lri_ees "Monthly earnings of employees - main job"
				

    * SECOND JOB
	
	* Employees
	gen ilo_job2_lri_ees = .
	    replace ilo_job2_lri_ees = s3aq30a       if ilo_job2_ste_aggregate==1 & s3aq30a>0
		replace ilo_job2_lri_ees = ilo_job2_lri_ees * ilo_job1_how_actual *(365/12) if s3aq30b==1 & ilo_job1_how_actual>0
		replace ilo_job2_lri_ees = ilo_job2_lri_ees *(365/12) if s3aq30b==2
		replace ilo_job2_lri_ees = ilo_job2_lri_ees *(56/12) if s3aq30b==3
		replace ilo_job2_lri_ees = ilo_job2_lri_ees *(26/12) if s3aq30b==4
		replace ilo_job2_lri_ees =  ilo_job2_lri_ees /3 if s3aq30b==6
		replace ilo_job2_lri_ees = ilo_job2_lri_ees /6 if s3aq30b==7
		replace ilo_job2_lri_ees = ilo_job2_lri_ees /12 if s3aq30b==8
	    replace ilo_job2_lri_ees = .     if ilo_lfs!=1
		        lab var ilo_job2_lri_ees "Monthly earnings of employees - main job"
		
				
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

* Comment: s3aq34 likeworkmore, but no variable on availability

*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
*	Cases of non-fatal occupational injury ('ilo_joball_oi_case') 		       *
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------

* Comment: Not enough information to derive the indicator

*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
*  Days lost due to cases of occupational injury ('ilo_joball_oi_day')		   *
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------

* Comment: Not enough information to derive the indicator



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
		replace ilo_cat_une=1 if (inrange(s3aq9a,1,12) | inrange(s3aq9b,1979,2010))& ilo_lfs==2
		replace ilo_cat_une=2 if (s3aq9a==0 | s3aq9b==0) & ilo_lfs==2
		replace ilo_cat_une=3 if ilo_lfs==2 & ilo_cat_une==.
				replace ilo_cat_une=. if ilo_lfs!=2
			lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
			lab val ilo_cat_une cat_une_lab
			lab var ilo_cat_une "Category of unemployment"
	
				
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			   Duration of unemployment ('ilo_dur')  	                       * 
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

* Comment: Not enough information to derive the indicator
		
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4') 	               * 
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

* Comment: Not enough information to derive the indicator
	
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu_isco08') 		                   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

* Comment: Not enough information to derive the indicator



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

* Comment: Most of the individuals are classified "X - Not elsewhere classified".

	gen ilo_olf_dlma=.
		replace ilo_olf_dlma = 1 if s3aq5==1 & s3aq7==2             & ilo_lfs==3      // Seeking, not available
		replace ilo_olf_dlma = 2 if s3aq5==2 & s3aq7==1               & ilo_lfs==3	    // Not seeking, available
		replace ilo_olf_dlma = 3 if s3aq5==2 & s3aq7==2 & s3aq34==1		      & ilo_lfs==3      // Not seeking, not available, willing
		replace ilo_olf_dlma = 4 if s3aq5==2 & s3aq7==2 & s3aq34==3		      & ilo_lfs==3      // Not seeking, not available, not willing
		replace ilo_olf_dlma = 5 if	(ilo_olf_dlma==. & ilo_lfs==3)	// Not classified 
	 		    lab def dlma_lab 1 "1 - Seeking, not available (Unavailable jobseekers)" 2 "2 - Not seeking, available (Available potential jobseekers)" ///
							     3 "3 - Not seeking, not available, willing (Willing non-jobseekers)" 4 "4 - Not seeking, not available, not willing" 5 "X - Not elsewhere classified"
			    lab val ilo_olf_dlma dlma_lab 
			    lab var ilo_olf_dlma "Labour market attachment (Degree of)"

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			Reasons for not seeking a job ('ilo_olf_reason') 	               *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

		gen ilo_olf_reason=.
			replace ilo_olf_reason=1 if s3aq6==10          & ilo_lfs==3             // Labour market 
			replace ilo_olf_reason=2 if inlist(s3aq6,6,7,9)          & ilo_lfs==3             // Other labour market reasons
			replace ilo_olf_reason=3 if  inlist(s3aq6,1,2,4,5,11)         & ilo_lfs==3             // Personal/Family-related
			replace ilo_olf_reason=4 if  inlist(s3aq6,3)         & ilo_lfs==3             // Does not need/want to work
			replace ilo_olf_reason=5 if ilo_olf_reason==. & ilo_lfs==3     // Not elsewhere classified
 			        lab def lab_olf_reason 1 "1 - Labour market" 2 " 2 - Other labour market reasons" 3 "3 - Personal/Family-related"  ///
				                           4 "4 - Does not need/want to work" 5 "5 - Not elsewhere classified"
					lab val ilo_olf_reason lab_olf_reason
					lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"		

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			      Discouraged job-seekers ('ilo_dis') 		                   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

	gen ilo_dis=.
	    replace ilo_dis=1 if !inlist(ilo_lfs,1,2) & s3aq7==1 & ilo_olf_reason==1
			    lab def ilo_dis_lab 1 "Discouraged job-seekers" 
			    lab val ilo_dis ilo_dis_lab
			    lab var ilo_dis "Discouraged job-seekers"	



* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*  Youth not in education, employment or training (NEETs) ('ilo_neet') 		   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

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

    keep if ilo_wgt!=.
	compress
		
	/* Save dataset including original and ilo variables*/
	save ${country}_${source}_${time}_FULL,  replace		
	
	*Save file only containing ilo_* variables
	keep ilo*
	save ${country}_${source}_${time}_ILO, replace
		
