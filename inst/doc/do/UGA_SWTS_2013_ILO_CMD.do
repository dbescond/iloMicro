* TITLE OF DO FILE: ILO Microdata Preprocessing code template - UGANDA, 2013
* DATASET USED: UGANDA, SWTS, 2013
* NOTES: 
* Files created: Standard variables UGA_SWTS_2013_FULL.dta and UGA_SWTS_2013_ILO.dta
* Authors: ILO / Department of Statistics / DPAU
* Starting Date: 06 August 2018
* Last updated: 06 August 2018
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
global country "UGA"
global source "SWTS"
global time "2013"
global inputFile "UGA_SWTS_2013.dta"
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

	gen ilo_key=_n
		lab var ilo_key "Key unique identifier per individual"
	
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*		             	 Sample Weight ('ilo_wgt') 		                       *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

	gen ilo_wgt=.
	    replace ilo_wgt= weight
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
	    replace ilo_geo=1 if inlist(a3,1,2)     // Urban 
		replace ilo_geo=2 if a3==3         		// Rural
		        lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural"
		        lab val ilo_geo ilo_geo_lab
		        lab var ilo_geo "Geographical coverage"	
		
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			                     Sex ('ilo_sex') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
	
	gen ilo_sex=.
	    replace ilo_sex=1 if  b5==1           // Male
		replace ilo_sex=2 if  b5==2           // Female
		        label define label_Sex 1 "1 - Male" 2 "2 - Female"
		        label values ilo_sex label_Sex
		        lab var ilo_sex "Sex"

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			                    Age ('ilo_age') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
	
	gen ilo_age=.
	    replace ilo_age= b3
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

    *---------------------------------------------------------------------------
	* ISCED 97
	*---------------------------------------------------------------------------
	
	* Detailed
	gen ilo_edu_isced97=.
		replace ilo_edu_isced97=1 if  c12==10 | c1==2                      		// No schooling
		*replace ilo_edu_isced97=2 if                        					// Pre-primary education
		replace ilo_edu_isced97=3 if  inlist(c12,11,12)                      	// Primary education or first stage of basic education
		replace ilo_edu_isced97=4 if inlist(c12,13,14)                       	// Lower secondary education or second stage of basic education
		replace ilo_edu_isced97=5 if  inlist(c12,15)                      		// Upper secondary education
		replace ilo_edu_isced97=6 if  inlist(c12,16,17)                      	// Post-secondary non-tertiary education
		replace ilo_edu_isced97=7 if  c12==18                      				// First stage of tertiary education (not leading directly to an advanced research qualification)
		*replace ilo_edu_isced97=8 if                        					// Second stage of tertiary education (leading to an advanced research qualification)                               
		replace ilo_edu_isced97=9 if ilo_edu_isced97==.     					// Level not stated 
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

    gen ilo_edu_attendance=.
		replace ilo_edu_attendance=1 if c2==1                   // Attending
		replace ilo_edu_attendance=2 if inlist(c2,2,3)          // Not attending
		replace ilo_edu_attendance=3 if ilo_edu_attendance==.  	// Not elsewhere classified
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
	    replace ilo_mrts_details=1 if b11==1                                          // Single
		replace ilo_mrts_details=2 if b11==2                                          // Married
		*replace ilo_mrts_details=3 if                                           // Union / cohabiting
		replace ilo_mrts_details=4 if b11==4                                          // Widowed
		replace ilo_mrts_details=5 if b11==3                                          // Divorced / separated
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

    * Detailed
       gen ilo_dsb_details=.
             replace ilo_dsb_details=1 if (b19==1 & b20==1 & b21==1 & b22==1 )                            
             replace ilo_dsb_details=2 if (b19==2 | b20==2 | b21==2 | b22==2 )                                                 
             replace ilo_dsb_details=3 if (b19==3 | b20==3 | b21==3 | b22==3 )                                                 
             replace ilo_dsb_details=4 if (b19==4 | b20==4 | b21==4 | b22==4 )

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
			    label var ilo_wap "Working age population"
		
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			       Labour Force Status ('ilo_lfs')                             *       
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
	
	gen ilo_lfs=.
        replace ilo_lfs=1 if (c32a==1 | c32b==1 | c32c==1 | c32d==1 | c32e==1 | c32g==1) & ilo_wap==1	// Employed: ILO definition
		replace ilo_lfs=1 if c33==1 & !inlist(c34,22) & ilo_wap==1										// Employed: temporary absent
		replace ilo_lfs=2 if inlist(e1,1,2) & e13==1 & ilo_lfs!=1 & ilo_wap==1							// Unemployed: three criteria
		replace ilo_lfs=2 if (e3a==1 | e3b==1) & e13==1 & ilo_lfs!=1 & ilo_wap==1						// Unemployed: available future starters
	    replace ilo_lfs=3 if !inlist(ilo_lfs,1,2) & ilo_wap==1											// Outside the labour force
				label define label_ilo_lfs 1 "1 - Employed" 2 "2 - Unemployed" 3 "3 - Outside Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status" 
			
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
		 replace ilo_job1_ste_icse93=1 if d7==1 & ilo_lfs==1          // Employees
		 replace ilo_job1_ste_icse93=2 if d7==2 & ilo_lfs==1          // Employers
		 replace ilo_job1_ste_icse93=3 if d7==3 & ilo_lfs==1          // Own-account workers
		 replace ilo_job1_ste_icse93=4 if d7==4 & ilo_lfs==1          // Members of producers' cooperatives
		 replace ilo_job1_ste_icse93=5 if d7==5 & ilo_lfs==1          // Contributing family workers
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
				

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			            Economic activity ('ilo_eco')                          *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

    ***********
    * MAIN JOB:
    ***********
    *---------------------------------------------------------------------------
	* ISIC REV 4
	*---------------------------------------------------------------------------
	
	* 1-digit level
    gen ilo_job1_eco_isic4=.
		replace ilo_job1_eco_isic4=industry if ilo_lfs==1
	    replace ilo_job1_eco_isic4=22 if (ilo_job1_eco_isic4==. | ilo_job1_eco_isic4==99) & ilo_lfs==1
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
 			   
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			               Occupation ('ilo_ocu') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

    ***********
    * MAIN JOB:
    ***********
    *---------------------------------------------------------------------------
	* ISCO 08
	*---------------------------------------------------------------------------
		
	* 1-digit level 				
	gen ilo_job1_ocu_isco08=.
	    *replace ilo_job1_ocu_isco08=11 if inlist(ilo_job1_ocu_isco08_2digits,) & ilo_lfs==1                          // Not elsewhere classified
		*replace ilo_job1_ocu_isco08=int(ilo_job1_ocu_isco08_2digits/10) if (ilo_job1_ocu_isco08==. & ilo_lfs==1)     // The rest of the occupations
		replace ilo_job1_ocu_isco08=occu if ilo_lfs==1
		replace ilo_job1_ocu_isco08=10 if (ilo_job1_ocu_isco08==0 & ilo_lfs==1)  // Armed forces
		replace ilo_job1_ocu_isco08=11 if inlist(ilo_job1_ocu_isco08,.,99) & ilo_lfs==1
		        lab def ocu_isco08_1digit 1 "1 - Managers"	2 "2 - Professionals"	3 "3 - Technicians and associate professionals"	4 "4 - Clerical support workers"	///
                                          5 "5 - Service and sales workers"	6 "6 - Skilled agricultural, forestry and fishery workers"	7 "7 - Craft and related trades workers"	8 "8 - Plant and machine operators, and assemblers"	///
                                          9 "9 - Elementary occupations"	10 "0 - Armed forces occupations"	11 "X - Not elsewhere classified"		
				lab val ilo_job1_ocu_isco08 ocu_isco08_1digit
				lab var ilo_job1_ocu_isco08 "Occupation (ISCO-08) - main job"
				
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
				
    
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*	Institutional sector of economic activities ('ilo_ins_sector')		       *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
		
	gen ilo_job1_ins_sector=.
		replace ilo_job1_ins_sector=1 if publicadmin==1   & ilo_lfs==1    		// Public
		replace ilo_job1_ins_sector=2 if ilo_job1_ins_sector==. & ilo_lfs==1    // Private
			    lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
			    lab values ilo_job1_ins_sector ins_sector_lab
			    lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities - main job"
		
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*		               Hours of work ('ilo_how')  	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
				
    ***********
    * MAIN JOB
    ***********
	
	* Hours ACTUALLY worked
	gen ilo_job1_how_actual = .
	    replace ilo_job1_how_actual =  d33     if ilo_lfs==1
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
	
	gen ilo_job1_job_contract=.
		replace ilo_job1_job_contract=1 if d9==1 & ilo_lfs==1               				// Permanent
		replace ilo_job1_job_contract=2 if d9==2 & ilo_lfs==1               				// Temporary
		replace ilo_job1_job_contract=3 if ilo_job1_job_contract==. & ilo_lfs==1  	// Unknown
			    lab def job_contract_lab 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"
			    lab val ilo_job1_job_contract job_contract_lab
			    lab var ilo_job1_job_contract "Job (Type of contract)"

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*  Informal/formal economy: ('ilo_job1_ife_prod'/'ilo_job1_ife_nature') 	   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

/* Useful questions:
          - Institutional sector: publicadmin
		  - Private household identification: 
		  - Destination of production:
		  - Bookkeeping:
		  - Registration: d5
		  - Status in employment: ilo_job1_ste_icse93
		  - Social security contribution (Proxy: pension funds): d13j
		  - Place of work:
		  - Size:
		  - Paid annual leave: d13c
		  - Paid sick leave: d13d
*/
    * Social Security:
	gen social_security=.
	    replace social_security=1 if d13j==1 & ilo_lfs==1          // social security (proxy)
		replace social_security=2 if d13j==2 & ilo_lfs==1          // no social security (proxy)
	
    * 1) UNIT OF PRODUCTION: FORMAL/INFORMAL SECTOR
	gen ilo_job1_ife_prod=.																   
		replace ilo_job1_ife_prod=2 if ilo_lfs==1 & ilo_job1_ife_prod!=3 & ///
		                               (publicadmin==1 | ///
									   d5==1 | ///
									   (inlist(d5,4) & ilo_job1_ste_icse93==1 & social_security==1))
									     
		replace ilo_job1_ife_prod=1 if ilo_lfs==1 & !inlist(ilo_job1_ife_prod,2,3)
				lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 
				lab val ilo_job1_ife_prod ilo_ife_prod_lab
				lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"	
				
    * 2) NATURE OF JOB: FORMAL/INFORMAL EMPLOYMENT
	gen ilo_job1_ife_nature=.
	    replace ilo_job1_ife_nature=2 if ilo_lfs==1 & ///
	                                     ((ilo_job1_ste_icse93==1 & social_security==1) | ///
										 (ilo_job1_ste_icse93==1 & d13c==1 & d13d==1) | ///
										 (inlist(ilo_job1_ste_icse93,2,4)&ilo_job1_ife_prod==2) | ///
										 (inlist(ilo_job1_ste_icse93,3)&ilo_job1_ife_prod==2))
										 
	    replace ilo_job1_ife_nature=1 if ilo_lfs==1 & ilo_job1_ife_nature!=2
                lab def ife_nature_lab 1 "1 - Persons with informal main job" 2 "2 - Persons with formal main job"
		        lab val ilo_job1_ife_nature ife_nature_lab
		        lab var ilo_job1_ife_nature "Informal / Formal Economy (Nature of job)"	
		
		
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
	    replace ilo_job1_lri_ees = d14b if ilo_job1_ste_aggregate==1 & d14b>0
		replace ilo_job1_lri_ees = d14b + d16b if ilo_job1_ste_aggregate==1 & d14b>0 & d15==2 & d16b>0
		replace ilo_job1_lri_ees = ilo_job1_lri_ees *(5*52/12) if d18==1
		replace ilo_job1_lri_ees = ilo_job1_lri_ees *(52/12) if d18==2
		replace ilo_job1_lri_ees = ilo_job1_lri_ees *(26/12) if d18==3
	    replace ilo_job1_lri_ees = .     if ilo_lfs!=1
		        lab var ilo_job1_lri_ees "Monthly earnings of employees - main job"

				
	* Self-employed
	gen ilo_job1_lri_slf = .
	    replace ilo_job1_lri_slf = d27 if ilo_job1_ste_aggregate==2 & d27>0
		replace ilo_job1_lri_slf= ilo_job1_lri_slf + d29 if ilo_job1_ste_aggregate==2 & d27>0 & d29>0 & d28==1 
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

	gen ilo_joball_tru = .
	    replace ilo_joball_tru = 1 if ilo_job1_how_actual<=35  & d34==1 &  d35>0 & ilo_lfs==1
			    lab def tru_lab 1 "Time-related underemployed"
			    lab val ilo_joball_tru tru_lab
			    lab var ilo_joball_tru "Time-related underemployed"
			
*******************************************************************************
*                                                                              *
*	          PART 3.3 UNEMPLOYMENT: ECONOMIC CHARACTERISTICS                  *
*                                                                              * 
********************************************************************************
* ------------------------------------------------------------------------------				
				
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			   Duration of unemployment ('ilo_dur')  	                       * 
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

	* Detailed categories		
    gen ilo_dur_details=.
	    replace ilo_dur_details=1 if inlist(e12,1,2) & ilo_lfs==2               // Less than 1 month
		replace ilo_dur_details=2 if e12==3 & ilo_lfs==2                 		// 1 to 3 months
		replace ilo_dur_details=3 if e12==4 & ilo_lfs==2                 		// 3 to 6 months
		replace ilo_dur_details=4 if e12==5 & ilo_lfs==2                 		// 6 to 12 months
		replace ilo_dur_details=5 if e12==6 & ilo_lfs==2                 		// 12 to 24 months
		replace ilo_dur_details=6 if e12==7 & ilo_lfs==2                 		// 24 months or more
		replace ilo_dur_details=7 if ilo_dur_details==. & ilo_lfs==2    		// Not elsewhere classified
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

	gen ilo_olf_dlma=.
		replace ilo_olf_dlma = 1 if  inlist(e1,1,2) &  e13==2 & ilo_lfs==3      // Seeking, not available
		replace ilo_olf_dlma = 2 if  e1==3 & e13==1 & ilo_lfs==3	    		// Not seeking, available
		replace ilo_olf_dlma = 3 if e1==3  & e13==2 &	e4==1 & ilo_lfs==3      // Not seeking, not available, willing
		replace ilo_olf_dlma = 4 if e1==3  & e13==2 &	e4==2 & ilo_lfs==3      // Not seeking, not available, not willing
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
			replace ilo_olf_reason=1 if inlist(e5,16,17,18,19,20) & ilo_lfs==3       // Labour market 
			replace ilo_olf_reason=2 if inlist(e5,10,11) & ilo_lfs==3             	// Other labour market reasons
			replace ilo_olf_reason=3 if inlist(e5,12,13,14,15) & ilo_lfs==3         // Personal/Family-related
			replace ilo_olf_reason=4 if e14==15 & ilo_lfs==3             			// Does not need/want to work
			replace ilo_olf_reason=5 if (inlist(e5,98) | ilo_olf_reason==.) & ilo_lfs==3     	// Not elsewhere classified
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
	    replace ilo_dis=1 if !inlist(ilo_lfs,1,2) & e13==1     & ilo_olf_reason==1
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

	compress
		
	/* Save dataset including original and ilo variables*/
	save ${country}_${source}_${time}_FULL,  replace		
	
	*Save file only containing ilo_* variables
	keep ilo*
	save ${country}_${source}_${time}_ILO, replace
		