* TITLE OF DO FILE: ILO Microdata Preprocessing code template - COUNTRY, TIME
* DATASET USED: COUNTRY, EUSILC, TIME
* NOTES: 
* Files created: Standard variables COUNTRY_EUSILC_TIME_FULL.dta and COUNTRY_EUSILC_TIME_ILO.dta
* Authors: ILO / Department of Statistics / DPAU 06/11/2018
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
*set more off, permanently

global path "J:\DPAU\MICRO"
global country "NLD"
global source "EUSILC"
global time "2015"
global inputFile "${country}_${source}_${time}"
global inpath "${path}\\${country}\\${source}\\${time}\ORI"
global outpath "${path}\\${country}\\${source}\\${time}"

********************************************************************************
********************************************************************************

cd "$inpath"
	use ${inputFile}, clear
		compress

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
* Comment: PX040 respondant status (coverage 16+ and answered)

	gen ilo_wgt=.
	    replace ilo_wgt=PB040 if inlist(PX040,1,2,3)
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
* ------------------------------------------------------------------------------
* Create local for Year and quarter
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------			
   
	decode ilo_time, gen(to_drop)
	split to_drop, generate(to_drop_) parse(Q)
	destring to_drop_1, replace force
			local Y = to_drop_1 in 1
	drop to_drop


	
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
	
	destring DB100, replace force
		
	gen ilo_geo=.
	    replace ilo_geo=1 if inlist(DB100,1,2)       // Urban 
		replace ilo_geo=2 if DB100==3		         // Rural
		        lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural"
		        lab val ilo_geo ilo_geo_lab
		        lab var ilo_geo "Geographical coverage"	
	egen drop_var = mean(ilo_geo)
		local Z = drop_var in 1
		if `Z' == . {
			drop ilo_geo
		}
		drop 	drop_var		
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			                     Sex ('ilo_sex') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
	
	destring PB150, replace force
	
	gen ilo_sex=.
	    replace ilo_sex=1 if PB150==1            // Male
		replace ilo_sex=2 if PB150==2            // Female
		        label define label_Sex 1 "1 - Male" 2 "2 - Female"
		        label values ilo_sex label_Sex
		        lab var ilo_sex "Sex"
	egen drop_var = mean(ilo_sex)
		local Z = drop_var in 1
		if `Z' == . {
			drop ilo_sex
		}
		drop 	drop_var	
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			                    Age ('ilo_age') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: RX020 age at the end of the income reference period survey coverage for income is 16+ so age and WAP define only for 16+
		
	gen ilo_age=.
	    replace ilo_age=PX020 if PX020>15 & inlist(PX040,1,2,3)
		        lab var ilo_age "Age"
	
    * Age groups
	gen ilo_age_5yrbands=.
		*replace ilo_age_5yrbands=1 if inrange(ilo_age,0,4)
		*replace ilo_age_5yrbands=2 if inrange(ilo_age,5,9)
		*replace ilo_age_5yrbands=3 if inrange(ilo_age,10,14)
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
		*replace ilo_age_10yrbands=1 if inrange(ilo_age,0,15)
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

    * Aggregate
    gen ilo_edu_aggregate=.
		replace ilo_edu_aggregate=1 if inrange(PE040,0,99)
		replace ilo_edu_aggregate=2 if inrange(PE040,100,299)
		replace ilo_edu_aggregate=3 if inrange(PE040,300,499)
		replace ilo_edu_aggregate=4 if inrange(PE040,500,899)
		replace ilo_edu_aggregate=5 if PE040==.
			    label def edu_aggr_lab 1 "1 - Less than basic" 2 "2 - Basic" 3 "3 - Intermediate" 4 "4 - Advanced" 5 "5 - Level not stated"
			    label val ilo_edu_aggregate edu_aggr_lab
			    label var ilo_edu_aggregate "Education (Aggregate level)"

	egen drop_var = mean(ilo_edu_aggregate)
		local Z = drop_var in 1
		if `Z' == 5 {
			drop ilo_edu_aggregate
		}
		drop 	drop_var					
				
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*		  	 Educational attendance ('ilo_edu_attendance') 		               *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

    gen ilo_edu_attendance=.
		replace ilo_edu_attendance=1 if PE010==1                      			// Attending
		replace ilo_edu_attendance=2 if PE010==2                      			// Not attending
		replace ilo_edu_attendance=3 if ilo_edu_attendance==.  					// Not elsewhere classified
			    lab def edu_attendance_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
			    lab val ilo_edu_attendance edu_attendance_lab
			    lab var ilo_edu_attendance "Education (Attendance)"

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			           Marital status ('ilo_mrts') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
	destring PB190, replace force
	destring PB200, replace force
	
	* Detailed
	gen ilo_mrts_details=.
	    replace ilo_mrts_details=1 if PB190==1 & !inlist(PB200,1,2)				// Single
		replace ilo_mrts_details=2 if PB190==2 & !inlist(PB200,1,2)				// Married
		replace ilo_mrts_details=3 if inlist(PB200,1,2)                         // Union / cohabiting
		replace ilo_mrts_details=4 if PB190==4 & !inlist(PB200,1,2)				// Widowed
		replace ilo_mrts_details=5 if inlist(PB190,3,5) & !inlist(PB200,1,2)    // Divorced / separated
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

	egen drop_var = mean(ilo_mrts_aggregate)
		local Z = drop_var in 1
		if `Z' == 3 {
			drop ilo_mrts_aggregate ilo_mrts_details
		}
		drop 	drop_var			
				
				
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			Disability status ('ilo_dsb_details')                              *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

* Comment: PL086 (Number of months -> Maybe) PH010 (General health -> No) 



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
* Comment: 16+ only	

	gen ilo_wap=.
		replace ilo_wap=1 if ilo_age>=16 & ilo_age!=. & inlist(PX040,1,2,3)
			    label var ilo_wap "Working age population"
		
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			       Labour Force Status ('ilo_lfs')                             *       
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: PL035 is the unique variable for Employment (it includes temporary absence) - PL020 (Actively looking) & PL025 (Available to work)
	
		destring PL035, replace force
		destring PL020, replace force
		destring PL025, replace force
		egen drop_var = mean(PL035)
		local Z = drop_var in 1
		if `Z' == . {
			drop PL035
			gen PL035 = .
			replace PL035 = 1 if inlist(PL040, 1,2,3,4) 
		}
		drop 	drop_var	
	
	
	
	gen ilo_lfs=.
        replace ilo_lfs=1 if (PL035==1 & ilo_wap==1)									// Employed: ILO definition
		* replace ilo_lfs=1 if () & ilo_wap==1											// Employed: temporary absent
		replace ilo_lfs=2 if (PL035!=1 & PL025==1 & PL020==1) & ilo_lfs!=1 & ilo_wap==1	// Unemployed: three criteria
		* replace ilo_lfs=2 if () & ilo_lfs!=1 & ilo_wap==1								// Unemployed: available future starters
	    
		replace ilo_lfs=3 if !inlist(ilo_lfs,1,2) & ilo_wap==1							// Outside the labour force
				label define label_ilo_lfs 1 "1 - Employed" 2 "2 - Unemployed" 3 "3 - Outside Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status" 
		
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			       Multiple job holders ('ilo_mjh')                            *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
 destring PL100, replace force
 
    gen ilo_mjh=.
		replace ilo_mjh=1 if (PL100==.) & ilo_lfs==1							// One job only     
		replace ilo_mjh=2 if (PL100!=.) & ilo_lfs==1							// More than one job
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

   * MAIN JOB
   * ICSE 1993
	 gen ilo_job1_ste_icse93=.
		 replace ilo_job1_ste_icse93=1 if PL040==3 & ilo_lfs==1					// Employees
		 replace ilo_job1_ste_icse93=2 if PL040==1 & ilo_lfs==1					// Employers
		 replace ilo_job1_ste_icse93=3 if PL040==2 & ilo_lfs==1					// Own-account workers
		 * replace ilo_job1_ste_icse93=4 if  & ilo_lfs==1						// Members of producers' cooperatives
		 replace ilo_job1_ste_icse93=5 if PL040==4 & ilo_lfs==1					// Contributing family workers
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

		egen drop_var = mean(ilo_job1_ste_aggregate)
		local Z = drop_var in 1
		if `Z' == 3 {
			drop ilo_job1_ste_aggregate ilo_job1_ste_icse93
		}
		drop 	drop_var				  
				  
				  
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			            Economic activity ('ilo_eco')                          *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

    ***********
    * MAIN JOB
    ***********

  if `Y' < 2009 { 
		
	* Aggregate level
	gen ilo_job1_eco_aggregate=.
		replace ilo_job1_eco_aggregate=1 if inlist(PL110, "a+b") & ilo_lfs==1
		replace ilo_job1_eco_aggregate=2 if inlist(PL110, "c+d+e") & ilo_lfs==1
		replace ilo_job1_eco_aggregate=3 if inlist(PL110, "f") & ilo_lfs==1
		* replace ilo_job1_eco_aggregate=4 if  & ilo_lfs==1
		replace ilo_job1_eco_aggregate=5 if inlist(PL110, "g", "h", "i", "j", "k") & ilo_lfs==1
		replace ilo_job1_eco_aggregate=6 if inlist(PL110, "l", "m", "n", "o+p+q") & ilo_lfs==1
		replace ilo_job1_eco_aggregate=7 if !inrange(ilo_job1_eco_aggregate,1,6) & ilo_lfs==1
			   lab def eco_aggr_lab 1 "1 - Agriculture" 2 "2 - Manufacturing" 3 "3 - Construction" 4 "4 - Mining and quarrying; Electricity, gas and water supply" ///
			  					    5 "5 - Market Services (Trade; Transportation; Accommodation and food; and Business and administrative services)"  ///
								    6 "6 - Non-market services (Public administration; Community, social and other services and activities)" 7 "7 - Not classifiable by economic activity"					
			   lab val ilo_job1_eco_aggregate eco_aggr_lab
			   lab var ilo_job1_eco_aggregate "Economic activity (Aggregate) - main job"
	
}

   * Aggregate level
   if `Y' > 2008 { 

   gen ilo_job1_eco_aggregate=.
	   replace ilo_job1_eco_aggregate=1 if inlist(PL111, "a") & ilo_lfs==1
	   replace ilo_job1_eco_aggregate=2 if inlist(PL111, "b - e") & ilo_lfs==1
	   replace ilo_job1_eco_aggregate=3 if inlist(PL111, "f") & ilo_lfs==1
	   * replace ilo_job1_eco_aggregate=4 if inlist(PL111, "a") & ilo_lfs==1
	   replace ilo_job1_eco_aggregate=5 if inlist(PL111, "g", "h", "i", "j", "k", "l - n") & ilo_lfs==1
	   replace ilo_job1_eco_aggregate=6 if inlist(PL111, "o", "p", "q", "r - u") & ilo_lfs==1
	   replace ilo_job1_eco_aggregate=7 if !inrange(ilo_job1_eco_aggregate,1,6) & ilo_lfs==1
			   lab def eco_aggr_lab 1 "1 - Agriculture" 2 "2 - Manufacturing" 3 "3 - Construction" 4 "4 - Mining and quarrying; Electricity, gas and water supply" ///
			  					    5 "5 - Market Services (Trade; Transportation; Accommodation and food; and Business and administrative services)"  ///
								    6 "6 - Non-market services (Public administration; Community, social and other services and activities)" 7 "7 - Not classifiable by economic activity"					
			   lab val ilo_job1_eco_aggregate eco_aggr_lab
			   lab var ilo_job1_eco_aggregate "Economic activity (Aggregate) - main job"

}

		egen drop_var = mean(ilo_job1_eco_aggregate)
		local Z = drop_var in 1
		if `Z' == 7 {
			drop ilo_job1_eco_aggregate
		}
		drop 	drop_var


* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			               Occupation ('ilo_ocu') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

    ***********
    * MAIN JOB
    ***********

    *---------------------------------------------------------------------------
	* ISCO 88
	*---------------------------------------------------------------------------

 if `Y' < 2011 {
 
 destring PL050, replace force
 
 
	* 2-digit level 
    gen ilo_job1_ocu_isco88_2digits=. 
	    replace ilo_job1_ocu_isco88_2digits=PL050 if ilo_lfs==1
		replace ilo_job1_ocu_isco88_2digits=. if ilo_lfs!=1
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
	    replace ilo_job1_ocu_isco88=11 if ilo_job1_ocu_isco88_2digits==. & ilo_lfs==1                          		// Not elsewhere classified
		replace ilo_job1_ocu_isco88=int(ilo_job1_ocu_isco88_2digits/10) if (ilo_job1_ocu_isco88==. & ilo_lfs==1)    // The rest of the occupations
		replace ilo_job1_ocu_isco88=10 if (ilo_job1_ocu_isco88==0 & ilo_lfs==1)                                     // Armed forces
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

	drop ilo_job1_ocu_isco88_2digits	
	
	egen drop_var = mean(ilo_job1_ocu_skill)
		local Z = drop_var in 1
		if `Z' == 4 {
			drop ilo_job1_ocu_skill ilo_job1_ocu_aggregate ilo_job1_ocu_isco88
		}
		drop 	drop_var
}				
    
	*---------------------------------------------------------------------------
	* ISCO 08
	*---------------------------------------------------------------------------
	

 if `Y' > 2010 {

 
 
    destring PL051, replace force
 
 * 2-digit level
	gen ilo_job1_ocu_isco08_2digits=. 
		replace ilo_job1_ocu_isco08_2digits=PL051 if ilo_lfs==1
		replace ilo_job1_ocu_isco08_2digits=. if ilo_lfs!=1
							lab def ocu_isco08_2digits 1 "01 - Commissioned armed forces officers"	2 "02 - Non-commissioned armed forces officers"	3 "03 - Armed forces occupations, other ranks"	11 "11 - Chief executives, senior officials and legislators"	///
                                           12 "12 - Administrative and commercial managers"	13 "13 - Production and specialised services managers"	14 "14 - Hospitality, retail and other services managers"	21 "21 - Science and engineering professionals"	///
                                           22 "22 - Health professionals"	23 "23 - Teaching professionals"	24 "24 - Business and administration professionals"	25 "25 - Information and communications technology professionals"	///
                                           26 "26 - Legal, social and cultural professionals"	31 "31 - Science and engineering associate professionals"	32 "32 - Health associate professionals"	33 "33 - Business and administration associate professionals"	///
                                           34 "34 - Legal, social, cultural and related associate professionals"	35 "35 - Information and communications technicians"	41 "41 - General and keyboard clerks"	42 "42 - Customer services clerks"	///
                                           43 "43 - Numerical and material recording clerks"	44 "44 - Other clerical support workers"	51 "51 - Personal service workers"	52 "52 - Sales workers"	///
                                           53 "53 - Personal care workers"	54 "54 - Protective services workers"	61 "61 - Market-oriented skilled agricultural workers"	62 "62 - Market-oriented skilled forestry, fishery and hunting workers"	///
                                           63 "63 - Subsistence farmers, fishers, hunters and gatherers"	71 "71 - Building and related trades workers, excluding electricians"	72 "72 - Metal, machinery and related trades workers"	73 "73 - Handicraft and printing workers"	///
                                           74 "74 - Electrical and electronic trades workers"	75 "75 - Food processing, wood working, garment and other craft and related trades workers"	81 "81 - Stationary plant and machine operators"	82 "82 - Assemblers"	///
                                           83 "83 - Drivers and mobile plant operators"	91 "91 - Cleaners and helpers"	92 "92 - Agricultural, forestry and fishery labourers"	93 "93 - Labourers in mining, construction, manufacturing and transport"	///
                                           94 "94 - Food preparation assistants"	95 "95 - Street and related sales and service workers"	96 "96 - Refuse workers and other elementary workers"		
	            lab values ilo_job1_ocu_isco08_2digits ocu_isco08_2digits
	            lab var ilo_job1_ocu_isco08_2digits "Occupation (ISCO-08), 2 digit level - main job"
				
	* 1-digit level 				
	gen ilo_job1_ocu_isco08=.
	    replace ilo_job1_ocu_isco08=11 if ilo_job1_ocu_isco08_2digits==. & ilo_lfs==1                          		// Not elsewhere classified
		replace ilo_job1_ocu_isco08=int(ilo_job1_ocu_isco08_2digits/10) if (ilo_job1_ocu_isco08==. & ilo_lfs==1)    // The rest of the occupations
		replace ilo_job1_ocu_isco08=10 if (ilo_job1_ocu_isco08==0 & ilo_lfs==1)                                     // Armed forces
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
				
	drop ilo_job1_ocu_isco08_2digits
	
	

		egen drop_var = mean(ilo_job1_ocu_skill)
		local Z = drop_var in 1
		if `Z' == 4 {
			drop ilo_job1_ocu_skill ilo_job1_ocu_aggregate ilo_job1_ocu_isco08
		}
		drop 	drop_var
	
  }
  

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*	Institutional sector of economic activities ('ilo_ins_sector')		       *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

* Comment: Not available

		
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*		               Hours of work ('ilo_how')  	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
				
    ***********
    * MAIN JOB
    ***********
	
	* Hours USUALLY worked
	gen ilo_job1_how_usual=.
	    replace ilo_job1_how_usual=PL060 if ilo_lfs==1
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

	egen drop_var = mean(ilo_job1_how_usual)
		local Z = drop_var in 1
		if `Z' == . {
			drop ilo_job1_how_usual ilo_job1_how_usual_bands
		}
		drop 	drop_var
    *************
    * SECOND JOB
    *************
	
	* Hours USUALLY worked
	gen ilo_job2_how_usual=.
	    replace ilo_job2_how_usual=PL100 if ilo_mjh==2
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
	
	egen drop_var = mean(ilo_job2_how_usual)
		local Z = drop_var in 1
		if `Z' == . {
			drop ilo_job2_how_usual ilo_job2_how_usual_bands
		}
		drop 	drop_var		
    ***********
    * ALL JOBS
    ***********
	
	* Hours USUALLY worked
    gen ilo_joball_how_usual=.
	    replace ilo_joball_how_usual=PL060 if ilo_lfs==1
		replace ilo_joball_how_usual=ilo_joball_how_usual+PL100 if PL100!=. & ilo_lfs==1
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

		egen drop_var = mean(ilo_joball_how_usual_bands)
		local Z = drop_var in 1
		if `Z' == . {
			drop ilo_joball_how_usual_bands
		}
		drop 	drop_var			
				
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job_time')		                   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

 if `Y' > 2008 {		
	gen ilo_job1_job_time=.
		replace ilo_job1_job_time=2 if inlist(PL031,1,3) & ilo_lfs==1     		// Full-time
		replace ilo_job1_job_time=1 if inlist(PL031,2,4) & ilo_lfs==1     		// Part-time
		replace ilo_job1_job_time=3 if ilo_job1_job_time==. & ilo_lfs==1
			    lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
			    lab val ilo_job1_job_time job_time_lab
			    lab var ilo_job1_job_time "Job (Working time arrangement)"
}
 if `Y' < 2009 {		
	gen ilo_job1_job_time=.
		replace ilo_job1_job_time=2 if inlist(PL030,1) & ilo_lfs==1     		// Full-time
		replace ilo_job1_job_time=1 if inlist(PL030,2) & ilo_lfs==1			    // Part-time
		replace ilo_job1_job_time=3 if ilo_job1_job_time==. & ilo_lfs==1
			    lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
			    lab val ilo_job1_job_time job_time_lab
			    lab var ilo_job1_job_time "Job (Working time arrangement)"
}

		egen drop_var = mean(ilo_job1_job_time)
		local Z = drop_var in 1
		if `Z' == . {
			drop ilo_job1_job_time
		}
		drop 	drop_var
		
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*		    	Type of contract ('ilo_job_contract') 		                   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

	destring PL140, replace force
	gen ilo_job1_job_contract=.
		replace ilo_job1_job_contract=1 if PL140==1 & ilo_lfs==1 	  				// Permanent
		replace ilo_job1_job_contract=2 if PL140!=1 & ilo_lfs==1       				// Temporary
		replace ilo_job1_job_contract=3 if ilo_job1_job_contract==. & ilo_lfs==1  	// Unknown
			    lab def job_contract_lab 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"
			    lab val ilo_job1_job_contract job_contract_lab
			    lab var ilo_job1_job_contract "Job (Type of contract)"

	egen drop_var = mean(ilo_job1_job_contract)
		local Z = drop_var in 1
		if `Z' == 3 {
			drop ilo_job1_job_contract
		}
		drop 	drop_var			
				
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*  Informal/formal economy: ('ilo_job1_ife_prod'/'ilo_job1_ife_nature') 	   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

/* Useful questions:
          - Institutional sector: PL111=="o" (from 2009) or PL110=="l" (until 2008)
		  - Destination of production: NA
		  - Bookkeeping: NA
		  - Registration: PY050G - PY050N or PY010G - PY010N or PY020G - PY020N
		  - Status in employment: PL040
		  - Social security contribution: PY030G / PY031G / PY035G
		  - Place of work: NA
		  - Size: PL130
		  - Paid annual leave: NA
		  - Paid sick leave: NA
*/

    * Social Security
	gen social_security=.

if `Y' < 2007 {
	destring PY035G PY050G PY050N PY010G PY010N PY020G PY020N, replace force
	replace social_security=1 if ( inrange(PY035G,1,100000000)) & PL040==3 & ilo_lfs==1	// Social security (proxy)
} 
if `Y' > 2006 {
	destring PY030G PY031G PY035G PY050G PY050N PY010G PY010N PY020G PY020N, replace force
	replace social_security=1 if (inrange(PY030G,1,100000000) | inrange(PY031G,1,100000000) | inrange(PY035G,1,100000000)) & PL040==3 & ilo_lfs==1	// Social security (proxy)

}

		
		
		replace social_security=2 if (social_security==. & PL040==3 & ilo_lfs==1)																		// No social security (proxy)

    * Registration - Proxy used: Payment of tax
	gen tax_payment=.
	    replace tax_payment=1 if ((PY050G-PY050N>0) | (PY010G-PY010N>0) | (PY020G-PY020N>0)) & ilo_lfs==1	// Registration (proxy)		
		replace tax_payment=2 if (tax_payment==. & ilo_lfs==1)												// No registration (proxy)		

	* NACE 1
  if `Y' < 2009 { 

      * 1) UNIT OF PRODUCTION: FORMAL/INFORMAL SECTOR
	gen ilo_job1_ife_prod=.
		replace ilo_job1_ife_prod=2 if ilo_lfs==1 & (PL110=="l" | tax_payment==1)
		replace ilo_job1_ife_prod=1 if (ilo_lfs==1 & ilo_job1_ife_prod!=2)
				lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 
				lab val ilo_job1_ife_prod ilo_ife_prod_lab
				lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"		
		
	
	* 2) NATURE OF JOB: FORMAL/INFORMAL EMPLOYMENT
	gen ilo_job1_ife_nature=.
	    replace ilo_job1_ife_nature=2 if ilo_lfs==1 & ((inlist(ilo_job1_ste_icse93,2,3,4) & ilo_job1_ife_prod==2) | (ilo_job1_ste_icse93==1 & social_security==1))
	    replace ilo_job1_ife_nature=1 if ilo_lfs==1 & ilo_job1_ife_nature!=2
                lab def ife_nature_lab 1 "1 - Persons with informal main job" 2 "2 - Persons with formal main job"
		        lab val ilo_job1_ife_nature ife_nature_lab
		        lab var ilo_job1_ife_nature "Informal / Formal Economy (Nature of job)"	
}

   * NACE 2
   if `Y' > 2008 { 

     * 1) UNIT OF PRODUCTION: FORMAL/INFORMAL SECTOR
	gen ilo_job1_ife_prod=.
		replace ilo_job1_ife_prod=2 if ilo_lfs==1 & (PL111=="o" | tax_payment==1)
		replace ilo_job1_ife_prod=1 if (ilo_lfs==1 & ilo_job1_ife_prod!=2)
				lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 
				lab val ilo_job1_ife_prod ilo_ife_prod_lab
				lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"		
		
	
	* 2) NATURE OF JOB: FORMAL/INFORMAL EMPLOYMENT
	gen ilo_job1_ife_nature=.
	    replace ilo_job1_ife_nature=2 if ilo_lfs==1 & ((inlist(ilo_job1_ste_icse93,2,3,4) & ilo_job1_ife_prod==2) | (ilo_job1_ste_icse93==1 & social_security==1))
	    replace ilo_job1_ife_nature=1 if ilo_lfs==1 & ilo_job1_ife_nature!=2
                lab def ife_nature_lab 1 "1 - Persons with informal main job" 2 "2 - Persons with formal main job"
		        lab val ilo_job1_ife_nature ife_nature_lab
		        lab var ilo_job1_ife_nature "Informal / Formal Economy (Nature of job)"
}

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*	    Monthly labour related income ('ilo_lri_ees' and 'ilo_lri_slf')  	   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

    * MAIN JOB
	
	
	
	replace PY020G = 0 if PY020G == .
	replace PY010G = 0 if PY010G == .
	
	
	* Employees
	gen ilo_job1_lri_ees=.
	    replace ilo_job1_lri_ees=(PY010G+PY020G)/12 if ilo_job1_ste_aggregate==1
	    replace ilo_job1_lri_ees=. if ilo_lfs!=1
	    replace ilo_job1_lri_ees=. if ilo_job1_lri_ees==0
		lab var ilo_job1_lri_ees "Monthly earnings of employees - main job"
	
	* Self-employed
	gen ilo_job1_lri_slf=.
	    replace ilo_job1_lri_slf=PY050G/12 if ilo_job1_ste_aggregate==2
	    replace ilo_job1_lri_slf=. if ilo_lfs!=1
		        lab var ilo_job1_lri_slf "Monthly labour related income of self-employed - main job"
	
	egen drop_var = mean(ilo_job1_lri_ees)
		local Z = drop_var in 1
		if `Z' == . {
			drop ilo_job1_lri_ees
		}
		drop 	drop_var	
	egen drop_var = mean(ilo_job1_lri_slf)
		local Z = drop_var in 1
		if `Z' == . {
			drop ilo_job1_lri_slf
		}
		drop 	drop_var
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

	destring PL120, replace force
	gen ilo_joball_tru=.
	    replace ilo_joball_tru=1 if PL120==3 & ilo_lfs==1
			    lab def tru_lab 1 "Time-related underemployed"
			    lab val ilo_joball_tru tru_lab
			    lab var ilo_joball_tru "Time-related underemployed"
			
	egen drop_var = mean(ilo_joball_tru)
		local Z = drop_var in 1
		if `Z' == . {
			drop ilo_joball_tru
		}
		drop 	drop_var

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
/* better if come from EULFS	
	gen ilo_cat_une=.
		replace ilo_cat_une=1 if PL015!=2 & ilo_lfs==2							// Previously employed       
		replace ilo_cat_une=2 if PL015==2 & ilo_lfs==2							// Seeking for the first time
		replace ilo_cat_une=3 if ilo_cat_une==. & ilo_lfs==2           			// Unknown
			    lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
			    lab val ilo_cat_une cat_une_lab
			    lab var ilo_cat_une "Category of unemployment"
*/				
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			   Duration of unemployment ('ilo_dur')  	                       * 
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

* Comment: Not available 
	
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4') 	               * 
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

* Comment: Not available 

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu_isco08') 		                   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

* Comment: Not available 



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

* Comment: Only category 1 would be feasible due to skip pattern. Not produced.


* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			Reasons for not seeking a job ('ilo_olf_reason') 	               *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
/* yet accurate with EULFS
		gen ilo_olf_reason=.
			replace ilo_olf_reason=1 if inlist(PL031,1,2,3,4,5) & ilo_lfs==3	// Labour market 
			* replace ilo_olf_reason=2 if & ilo_lfs==3							// Other labour market reasons
			replace ilo_olf_reason=3 if inlist(PL031,6,8,9,10) & ilo_lfs==3		// Personal/Family-related
			replace ilo_olf_reason=4 if PL031==7 & ilo_lfs==3					// Does not need/want to work
			replace ilo_olf_reason=5 if ilo_olf_reason==. & ilo_lfs==3			// Not elsewhere classified
 			        lab def lab_olf_reason 1 "1 - Labour market" 2 " 2 - Other labour market reasons" 3 "3 - Personal/Family-related"  ///
				                           4 "4 - Does not need/want to work" 5 "5 - Not elsewhere classified"
					lab val ilo_olf_reason lab_olf_reason
					lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"		
*/
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			      Discouraged job-seekers ('ilo_dis') 		                   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

* Comment: Not produced as reasons for not seeking a job are not based on the standard question.
		
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*  Youth not in education, employment or training (NEETs) ('ilo_neet') 		   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
/* better if come from EULFS
	  gen ilo_neet=1 if ilo_age_aggregate==2 & ilo_lfs!=1 & ilo_edu_attendance==2
		  lab def neet_lab 1 "Youth not in education, employment or training"
		  lab val ilo_neet neet_lab
		  lab var ilo_neet "Youth not in education, employment or training"	
*/
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			                    SAVE RESULTS                                   *            
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

* ------------------------------------------------------------------------------
*                       Preparation of final dataset                           *
* ------------------------------------------------------------------------------

drop social_security tax_payment

cd "$outpath"

	keep if ilo_wgt!=.
	
	compress

	save ${country}_${source}_${time}_FULL,  replace		
	
	keep ilo*
	
	save ${country}_${source}_${time}_ILO, replace
