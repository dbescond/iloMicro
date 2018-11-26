* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Rwanda
* DATASET USED: Rwanda EICV 
* NOTES: 
* Files created: Standard variables on EICV Rwanda
* Authors: ILO / Department of Statistics / DPAU

* Starting Date: 03 August 2017
* Last updated: 08 February 2018
***********************************************************************************************


*******************************************************************
 /* 1.	Set up work directory, file name, variables and function */
*******************************************************************


clear all 

set more off

global path "J:\DPAU\MICRO"
global country "RWA"
global source "EICV"
global time "2014"
global inputFile "RWA_EICV_2014_ORI"

global inpath "${path}\\${country}\\${source}\\${time}\ORI"
global temppath "${path}\_Admin"
global outpath "${path}\\${country}\\${source}\\${time}"

********************************************************************************
********************************************************************************

cd "$inpath"
	use ${inputFile}, clear
	*renaming everything in lower case
	rename *, lower  
	
	
	* get rid of observations without a weighting factor
	
		drop if weight==.

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

*			2. MAP VARIABLES

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* ---------------------------------------------------------------------------------------------
***********************************************************************************************
*			PART 1. DATASET SETTINGS VARIABLES
***********************************************************************************************
* ---------------------------------------------------------------------------------------------

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Identifier ('ilo_key') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*		

	gen ilo_key=_n
		lab var ilo_key "Key unique identifier per individual"
	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sample Weight ('ilo_wgt') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*		
* Comment: 
	
	gen ilo_wgt=weight
		lab var ilo_wgt "Sample weight"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time period ('ilo_time') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*

	gen ilo_time=1
		lab def time_lab 1 "${time}"
		lab val ilo_time time_lab
		lab var ilo_time "Time (Gregorian Calendar)"
		
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
*
	gen ilo_geo=ur2_2012
		lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural"
		lab val ilo_geo ilo_geo_lab
		lab var ilo_geo "Geographical coverage"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: 

		gen ilo_sex=s1q1
			label define label_Sex 1 "1 - Male" 2 "2 - Female"
			label values ilo_sex label_Sex
			lab var ilo_sex "Sex"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: 

	gen ilo_age=s1q3y
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
		replace ilo_age_aggregate=1 if inrange(ilo_age,0,15)
		replace ilo_age_aggregate=2 if inrange(ilo_age,15,24)
		replace ilo_age_aggregate=3 if inrange(ilo_age,25,54)
		replace ilo_age_aggregate=4 if inrange(ilo_age,55,64)
		replace ilo_age_aggregate=5 if ilo_age>=65 & ilo_age!=.
			lab def age_aggr_lab 1 "<15" 2 "15-24" 3 "25-54" 4 "55-64" 5 "65+"
			lab val ilo_age_aggregate age_aggr_lab
			lab var ilo_age_aggregate "Age (Aggregate)"
					
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Level of education ('ilo_edu') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: Note that according to the definition, the highest level being CONCLUDED is being considered

	* questions asked to individuals ages 3+


	gen ilo_edu_isced97=.
		* No schooling
		replace ilo_edu_isced97=1 if s4aq1==2 
		* Pre-primary education
		replace ilo_edu_isced97=2 if inrange(s4aq2,1,15)
		* Primary education
		replace ilo_edu_isced97=3 if inrange(s4aq2,16,22) | inlist(s4aq2,31,32)
		* Lower secondary
		replace ilo_edu_isced97=4 if inlist(s4aq2,23,24,25,33,34,35)
		* Upper secondary
		replace ilo_edu_isced97=5 if inlist(s4aq2,26,36,41,42,43)
		* Post-secondary non-tertiary
		/* replace ilo_edu_isced97=6 if */
		* First stage of tertiary
		replace ilo_edu_isced97=7 if inlist(s4aq2,44,45)
		* Second stage of tertiary
		replace ilo_edu_isced97=8 if inlist(s4aq2,46,47)
		* Level not stated
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
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education attendance ('ilo_edu_attendance') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: note that the original question asks "Have you been to school in the previous 12 months?"
			* also note that question only asked to individuals aged between 3 and 30 years of age

		gen ilo_edu_attendance=.
			replace ilo_edu_attendance=1 if s4aq7==1
			replace ilo_edu_attendance=2 if s4aq7==2
			replace ilo_edu_attendance=3 if ilo_edu_attendance==.
				lab def edu_attendance_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
				lab val ilo_edu_attendance edu_attendance_lab
				lab var ilo_edu_attendance "Education (Attendance)"

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			           Marital status ('ilo_mrts') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: marital status question is made to people aged 12 years and above. 
	
	* Detailed
	gen ilo_mrts_details=.
	    replace ilo_mrts_details=1 if s1q4==7                                   // Single
		replace ilo_mrts_details=2 if inrange(s1q4,1,3)                         // Married
		replace ilo_mrts_details=3 if s1q4==4                                   // Union / cohabiting
		replace ilo_mrts_details=4 if s1q4==8                                   // Widowed
		replace ilo_mrts_details=5 if inlist(s1q4,5,6)                          // Divorced / separated
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
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Disability status ('ilo_dsb_details') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment: if missing value, force into "without disability"

	gen ilo_dsb_aggregate=.
		replace ilo_dsb_aggregate=1 if !inrange(s3q2,2,9)
		replace ilo_dsb_aggregate=2 if inrange(s3q2,2,9)
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
*           
* Comment: 	

	gen ilo_wap=.
		replace ilo_wap=1 if ilo_age>=15 & ilo_age!=.
		replace ilo_wap=0 if ilo_age<15
			label def ilo_wap_lab 1 "Working age population"
			label val ilo_wap ilo_wap_lab
			label var ilo_wap "Working age population" //15+ population

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Labour Force Status ('ilo_lfs') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*            	 
* Comment: use questions taking as reference period last 7 days from section 6b and not from section 6e to identify people in employment
			* consider also as employed whoever said "yes" to the question asking whether the person is still working in this job
			* Use questions from section 6e to identify people in unemployment
	
	gen ilo_lfs=.
		replace ilo_lfs=1 if s6bq8_procc==1 | s6bq12_procc==1
		replace ilo_lfs=2 if ilo_lfs!=1 & s6eq7==1 & (s6eq8==1 | s6eq11==2)
		replace ilo_lfs=3 if !inlist(ilo_lfs,1,2)
			replace ilo_lfs=. if ilo_wap!=1	
				label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status" 
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: 

	gen ilo_mjh=.
		replace ilo_mjh=1 if s6bq3b_secocc==. & ilo_lfs==1
		replace ilo_mjh=2 if s6bq3b_secocc!=. & ilo_lfs==1
			lab def lab_ilo_mjh 1 "1 - One job only" 2 "2 - More than one job"
			lab val ilo_mjh lab_ilo_mjh
			lab var ilo_mjh "Multiple job holders"		
			

***********************************************************************************************
*			PART 3.1. ECONOMIC CHARACTERISTICS FOR MAIN JOB 
***********************************************************************************************	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Status in employment ('ilo_ste') 
* -------------------------------------------------------------------------------------------
* ------------------------------------------------------------------------------------------- 
*
* Comment: IMPORTANT: as the classification contained in the original dataset does not allow to distinguish between independent workers with and without employees (i.e.
			* employers and own-account workers) consider, for technical reasons, all of the individuals falling into the categories "independent workers" as "own-account workers" (ICSE-93 code 3)

	gen ilo_job1_ste_icse93=.
			replace ilo_job1_ste_icse93=1 if inlist(s6bq15_procc,1,2)
			/* replace ilo_job1_ste_icse93=2 if */
			replace ilo_job1_ste_icse93=3 if inlist(s6bq15_procc,3,4)
			replace ilo_job1_ste_icse93=4 if inlist(s6bq15_procc,8,9)
			replace ilo_job1_ste_icse93=5 if inlist(s6bq15_procc,5,6)
			replace ilo_job1_ste_icse93=6 if ilo_job1_ste_icse93==. & ilo_lfs==1
		    replace ilo_job1_ste_icse93=. if ilo_lfs!=1			
			        label define label_ilo_ste_icse93 1 "1 - Employees" 2 "2 - Employers" 3 "3 - Own-account workers" 4 "4 - Members of producers' cooperatives" ///
					                                  5 "5 - Contributing family workers" 6 "6 - Workers not classifiable by status"
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

	* SECOND JOB
		
		gen ilo_job2_ste_icse93=.
			replace ilo_job2_ste_icse93=1 if inlist(s6bq15_secocc,1,2)
			/* replace ilo_job2_ste_icse93=2 if */
			replace ilo_job2_ste_icse93=3 if inlist(s6bq15_secocc,3,4)
			replace ilo_job2_ste_icse93=4 if inlist(s6bq15_secocc,8,9)
			replace ilo_job2_ste_icse93=5 if inlist(s6bq15_secocc,5,6)
			replace ilo_job2_ste_icse93=6 if ilo_job2_ste_icse93==. & ilo_mjh==2
			replace ilo_job2_ste_icse93=. if ilo_mjh!=2
			    	* value labels already defined
				    label val ilo_job2_ste_icse93 label_ilo_ste_icse93
				    label var ilo_job2_ste_icse93 "Status in employment (ICSE 93) in secondary job"

			* Aggregate categories
	
		gen ilo_job2_ste_aggregate=.
			replace ilo_job2_ste_aggregate=1 if ilo_job2_ste_icse93==1				// Employees
			replace ilo_job2_ste_aggregate=2 if inrange(ilo_job2_ste_icse93,2,5)	// Self-employed
			replace ilo_job2_ste_aggregate=3 if ilo_job2_ste_icse93==6				// Not elsewhere classified
				*value labels already defined
				lab val ilo_job2_ste_aggregate ste_aggr_lab
			    label var ilo_job2_ste_aggregate "Status in employment (Aggregate) in secondary job" 

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: Information indicated at the one-digit level following ISIC Rev. 4


		
		gen indu_code_prim=s6bq4b_procc if ilo_lfs==1
		
		gen indu_code_sec=s6bq4b_secocc if ilo_lfs==1 & ilo_mjh==2
		
		* Primary activity
			
		gen ilo_job1_eco_isic4=indu_code_prim
			replace ilo_job1_eco_isic4=22 if ilo_job1_eco_isic4==. & ilo_lfs==1
		        lab def eco_isic4_1digit 1 "A - Agriculture, forestry and fishing"	2 "B - Mining and quarrying"	3 "C - Manufacturing"	4 "D - Electricity, gas, steam and air conditioning supply" ///
                                         5 "E - Water supply; sewerage, waste management and remediation activities"	6 "F - Construction"	7 "G - Wholesale and retail trade; repair of motor vehicles and motorcycles"	8 "H - Transportation and storage" ///
                                         9 "I - Accommodation and food service activities"	10 "J - Information and communication"	11 "K - Financial and insurance activities"	12 "L - Real estate activities" ///
                                         13 "M - Professional, scientific and technical activities"	14 "N - Administrative and support service activities"	15 "O - Public administration and defence; compulsory social security"	16 "P - Education" ///
                                         17 "Q - Human health and social work activities"	18 "R - Arts, entertainment and recreation"	19 "S - Other service activities"	20 "T - Activities of households as employers; undifferentiated goods- and services-producing activities of households for own use" ///
                                         21 "U - Activities of extraterritorial organizations and bodies"	22 "X - Not elsewhere classified"		
  	  		    lab val ilo_job1_eco_isic4 eco_isic4_1digit
			    lab var ilo_job1_eco_isic4 "Economic activity (ISIC Rev. 4) - main job"
				
		* Secondary activity 
		
		gen ilo_job2_eco_isic4=indu_code_sec
			replace ilo_job2_eco_isic4=22 if ilo_job2_eco_isic4==. & ilo_lfs==1 & ilo_mjh==2
		    replace ilo_job2_eco_isic4=. if ilo_lfs!=1 & ilo_mjh!=2
                * labels already defined for main job
		        lab val ilo_job2_eco_isic4 eco_isic4_1digit
			    lab var ilo_job2_eco_isic4 "Economic activity (ISIC Rev. 4) - second job"
		
	* Now do the classification on an aggregate level
	
		* Primary activity
		
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
				
		* Secondary activity
		
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
				
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_ocu') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment:

	* ISCO-08 classification at the one-digit level used
	
	gen occ_code_prim_1dig=s6bq3b_procc if ilo_lfs==1 
	gen occ_code_sec_1dig=s6bq3b_secocc if ilo_lfs==1 & ilo_mjh==2
	
		* Primary activity
		
		gen ilo_job1_ocu_isco08=occ_code_prim_1dig
			replace ilo_job1_ocu_isco08=10 if ilo_job1_ocu_isco08==0
			replace ilo_job1_ocu_isco08=11 if ilo_job1_ocu_isco08==. & ilo_lfs==1
		        lab def ocu_isco08_1digit 1 "1 - Managers"	2 "2 - Professionals"	3 "3 - Technicians and associate professionals"	4 "4 - Clerical support workers"	///
                                          5 "5 - Service and sales workers"	6 "6 - Skilled agricultural, forestry and fishery workers"	7 "7 - Craft and related trades workers"	8 "8 - Plant and machine operators, and assemblers"	///
                                          9 "9 - Elementary occupations"	10 "0 - Armed forces occupations"	11 "X - Not elsewhere classified"		
				lab val ilo_job1_ocu_isco08 ocu_isco08_1digit
				lab var ilo_job1_ocu_isco08 "Occupation (ISCO-08) - main job"
			
		* Secondary activity
		
		gen ilo_job2_ocu_isco08=occ_code_sec_1dig
			replace ilo_job2_ocu_isco08=10 if ilo_job2_ocu_isco08==0
                * labels already defined for main job
				lab val ilo_job2_ocu_isco08 ocu_isco08_1digit
				lab var ilo_job2_ocu_isco08 "Occupation (ISCO-08) - second job"
	
	* Aggregate level
	
		* Primary occupation
	
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
				
		* Secondary occupation
		
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
	
		* Primary occupation
	
		gen ilo_job1_ocu_skill=.
			replace ilo_job1_ocu_skill=1 if ilo_job1_ocu_isco08==9
			replace ilo_job1_ocu_skill=2 if inlist(ilo_job1_ocu_isco08,4,5,6,7,8)
			replace ilo_job1_ocu_skill=3 if inlist(ilo_job1_ocu_isco08,1,2,3)
			replace ilo_job1_ocu_skill=4 if inlist(ilo_job1_ocu_isco08,10,11)
				lab def ocu_skill_lab 1 "1 - Skill level 1 (low)" 2 "2 - Skill level 2 (medium)" 3 "3 - Skill levels 3 and 4 (high)" 4 "4 - Not elsewhere classified"
			    lab val ilo_job1_ocu_skill ocu_skill_lab
			    lab var ilo_job1_ocu_skill "Occupation (Skill level) - main job"
				
				
		* Secondary occupation 
		
		gen ilo_job2_ocu_skill=.
			replace ilo_job2_ocu_skill=1 if ilo_job2_ocu_isco08==9
			replace ilo_job2_ocu_skill=2 if inlist(ilo_job2_ocu_isco08,4,5,6,7,8)
			replace ilo_job2_ocu_skill=3 if inlist(ilo_job2_ocu_isco08,1,2,3)
			replace ilo_job2_ocu_skill=4 if inlist(ilo_job2_ocu_isco08,10,11)
		        * labels already defined for main job
			    lab val ilo_job2_ocu_skill ocu_skill_lab
			    lab var ilo_job2_ocu_skill "Occupation (Skill level) - second job"
						
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_ins_sector') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
		
* Comment: 

	gen ilo_job1_ins_sector=.
		replace ilo_job1_ins_sector=1 if inlist(s6bq14_procc,3,6,8)
		replace ilo_job1_ins_sector=2 if ilo_job1_ins_sector!=1 & ilo_lfs==1
				replace ilo_job1_ins_sector=. if ilo_lfs!=1
			lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
			lab values ilo_job1_ins_sector ins_sector_lab
			lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities" 
	
	
* --------------------------------------------------------------------------------------------------
* --------------------------------------------------------------------------------------------------
*		Weekly hours actually (USUALLY) worked ('ilo_how_actual') and ('ilo_how_usual') 
* --------------------------------------------------------------------------------------------------
* --------------------------------------------------------------------------------------------------
* 
* Comment: 
				
	* Actual hours worked
	
		* Primary job
		
		gen ilo_job1_how_actual=s6bq10_procc
			replace ilo_job1_how_actual=. if ilo_lfs!=1
			lab var ilo_job1_how_actual "Weekly hours actually worked in main job"
			
		gen ilo_job2_how_actual=s6bq10_secocc
			replace ilo_job2_how_actual=. if ilo_lfs!=1 & ilo_mjh!=2
			lab var ilo_job2_how_actual "Weekly hours actually worked in second job"
			
		egen ilo_joball_how_actual=rowtotal(ilo_job*_how_actual), m
			replace ilo_joball_how_actual=. if ilo_lfs!=1
			lab var ilo_joball_how_actual "Weekly hours actually worked in all jobs"
			
	* Hours usually worked --> not indicated for entire scope	
		
		
	* Weekly hours actually worked --> bands 
			
		* Primary job
		
		gen ilo_job1_how_actual_bands=.
			replace ilo_job1_how_actual_bands=1 if ilo_job1_how_actual==0
			replace ilo_job1_how_actual_bands=2 if ilo_job1_how_actual>=1 & ilo_job1_how_actual<=14
			replace ilo_job1_how_actual_bands=3 if ilo_job1_how_actual>=15 & ilo_job1_how_actual<=29
			replace ilo_job1_how_actual_bands=4 if ilo_job1_how_actual>=30 & ilo_job1_how_actual<=34
			replace ilo_job1_how_actual_bands=5 if ilo_job1_how_actual>=35 & ilo_job1_how_actual<=39
			replace ilo_job1_how_actual_bands=6 if ilo_job1_how_actual>=40 & ilo_job1_how_actual<=48
			replace ilo_job1_how_actual_bands=7 if ilo_job1_how_actual>=49 & ilo_job1_how_actual!=.
			replace ilo_job1_how_actual_bands=8 if ilo_lfs==1 & ilo_job1_how_actual_bands==.
				lab def how_bands_lab 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"
				lab values ilo_job1_how_actual_bands how_bands_lab
				lab var ilo_job1_how_actual_bands "Weekly hours actually worked bands in main job"
				
		* All jobs
		
		gen ilo_joball_how_actual_bands=.
			replace ilo_joball_how_actual_bands=1 if ilo_joball_how_actual==0
			replace ilo_joball_how_actual_bands=2 if ilo_joball_how_actual>=1 & ilo_joball_how_actual<=14
			replace ilo_joball_how_actual_bands=3 if ilo_joball_how_actual>=15 & ilo_joball_how_actual<=29
			replace ilo_joball_how_actual_bands=4 if ilo_joball_how_actual>=30 & ilo_joball_how_actual<=34
			replace ilo_joball_how_actual_bands=5 if ilo_joball_how_actual>=35 & ilo_joball_how_actual<=39
			replace ilo_joball_how_actual_bands=6 if ilo_joball_how_actual>=40 & ilo_joball_how_actual<=48
			replace ilo_joball_how_actual_bands=7 if ilo_joball_how_actual>=49 & ilo_joball_how_actual!=.
			replace ilo_joball_how_actual_bands=8 if ilo_lfs==1 & ilo_joball_how_actual_bands==.
				* value labels already defined 
				lab values ilo_joball_how_actual_bands how_bands_lab
				lab var ilo_joball_how_actual_bands "Weekly hours actually worked bands in main job"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job_time') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment: consider actual hours as usual hours not available
		
		gen ilo_job1_job_time=.
			replace ilo_job1_job_time=1 if ilo_job1_how_actual_bands<40
			replace ilo_job1_job_time=2 if ilo_job1_how_actual_bands>=40 & ilo_job1_how_actual_bands!=.
			replace ilo_job1_job_time=3 if ilo_job1_job_time==. & ilo_lfs==1
					replace ilo_job1_job_time=. if ilo_lfs!=1
				lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
				lab val ilo_job1_job_time job_time_lab
				lab var ilo_job1_job_time "Job (Working time arrangement)"	
			
			* if there is any secondary employment, by definition it is part-time, and therefore
			* variable for secondary employment not being defined
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job_contract') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment:
		
		gen ilo_job1_job_contract=.
			replace ilo_job1_job_contract=1 if s6cq16_procc==1
			replace ilo_job1_job_contract=2 if inrange(s6cq16_procc,2,6)
			replace ilo_job1_job_contract=3 if ilo_job1_job_contract==. & ilo_job1_ste_aggregate==1
					replace ilo_job1_job_contract=. if ilo_lfs!=1
				lab def job_contract_lab 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"
				lab val ilo_job1_job_contract job_contract_lab
				lab var ilo_job1_job_contract "Job (Type of contract)"
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Informal/Formal economy: Unit of production (ilo_job1_ife_prod) 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* 
* Comment: don't keep variable, due to numerous filters!

	* Useful questions: s6bq14_procc : Status in employment --> indicates whether person is working in the public sector, as well as domestic employees (i.e. also used for institutional sector)
					*	[no info]: Destination of production
					*	s6dq39_procc : Bookkeeping (only asked to independent non-farmers!)
					*	s6dq30_procc : Registration (idem as bookkeeping)
					*	s6cq18_procc s6cq19_procc s6cq20_procc s6cq21_procc : Social security contributions (not asked employees that do not have either a permanent contract or fixed-term contract)
					*	[no info]: Place of work 
					*	s6dq36_procc and s6dq38_procc: Size	
					
						* s6cq22_procc --> asked to all employees : question on whether salary subject to tax deduction --> check with Yves whether it can be included or not
					
		/*			
	gen ilo_job1_ife_prod=.
		replace ilo_job1_ife_prod=1 if !inlist(s6bq14_procc,3,6,8,9) & 
		replace ilo_job1_ife_prod=2 if inlist(s6bq14_procc,3,6,8) | (!inlist(s6bq14_procc,3,6,8,9)
		replace ilo_job1_ife_prod=3 if s6bq14_procc==9
		replace ilo_job1_ife_prod=4 if ilo_job1_ife_prod==. & ilo_lfs==1
				replace ilo_job1_ife_prod=. if ilo_lfs!=1
			lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 4 "4 - Not elsewhere classified"
			lab val ilo_job1_ife_prod ilo_ife_prod_lab
			lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"
			*/
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Informal/formal economy: nature of job (ilo_job1_ife_nature) 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: 


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Earnings ('ilo_ear_ees' and 'ilo_ear_slf')  
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	
* Comment: Classify earnings according to the occupation (i.e. primary and secondary) and then consider in a variable 
	* all labour related income for all jobs together

	*Currency in Rwanda: Rwandan franc
	
	* Primary employment 
	
		gen salary_prim=.
			replace salary_prim=s6cq23a_procc*(365/12) if s6cq23b_procc==1
			replace salary_prim=s6cq23a_procc*(52/12) if s6cq23b_procc==2
			replace salary_prim=s6cq23a_procc if s6cq23b_procc==3
			replace salary_prim=s6cq23a_procc/12 if s6cq23b_procc==4
			
		gen inkind_prim=.
			replace inkind_prim=s6cq25a_procc*(365/12) if s6cq25b_procc==1
			replace inkind_prim=s6cq25a_procc*(52/12) if s6cq25b_procc==2
			replace inkind_prim=s6cq25a_procc if s6cq25b_procc==3
			replace inkind_prim=s6cq25a_procc/12 if s6cq25b_procc==4
			
		gen subsidy_prim=.
			replace subsidy_prim=s6cq27a_procc*(365/12) if s6cq27b_procc==1
			replace subsidy_prim=s6cq27a_procc*(52/12) if s6cq27b_procc==2
			replace subsidy_prim=s6cq27a_procc if s6cq27b_procc==3
			replace subsidy_prim=s6cq27a_procc/12 if s6cq27b_procc==4
			
		gen oth_benefit_prim=.
			replace oth_benefit_prim=s6cq29a_procc*(365/12) if s6cq29b_procc==1
			replace oth_benefit_prim=s6cq29a_procc*(52/12) if s6cq29b_procc==2
			replace oth_benefit_prim=s6cq29a_procc if s6cq29b_procc==3
			replace oth_benefit_prim=s6cq29a_procc/12 if s6cq29b_procc==4	
			
		* Wage revenue
		
		egen ilo_job1_lri_ees=rowtotal(salary_prim inkind_prim subsidy_prim oth_benefit_prim), m 
			replace ilo_job1_lri_ees=. if ilo_lfs!=1 | ilo_job1_lri_ees<0
			lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"
	
			* Self employment
		
			* indicated only for non-farm business --> as turnover indicated may be shared with other households as well, info might not be precise --> don't consider information
				
	* Secondary employment
	
		gen salary_sec=.
			replace salary_sec=s6cq23a_secocc*(365/12) if s6cq23b_secocc==1
			replace salary_sec=s6cq23a_secocc*(52/12) if s6cq23b_secocc==2
			replace salary_sec=s6cq23a_secocc if s6cq23b_secocc==3
			replace salary_sec=s6cq23a_secocc/12 if s6cq23b_secocc==4
			
		gen inkind_sec=.
			replace inkind_sec=s6cq25a_secocc*(365/12) if s6cq25b_secocc==1
			replace inkind_sec=s6cq25a_secocc*(52/12) if s6cq25b_secocc==2
			replace inkind_sec=s6cq25a_secocc if s6cq25b_secocc==3
			replace inkind_sec=s6cq25a_secocc/12 if s6cq25b_secocc==4
			
		gen subsidy_sec=.
			replace subsidy_sec=s6cq27a_secocc*(365/12) if s6cq27b_secocc==1
			replace subsidy_sec=s6cq27a_secocc*(52/12) if s6cq27b_secocc==2
			replace subsidy_sec=s6cq27a_secocc if s6cq27b_secocc==3
			replace subsidy_sec=s6cq27a_secocc/12 if s6cq27b_secocc==4
			
		gen oth_benefit_sec=.
			replace oth_benefit_sec=s6cq29a_secocc*(365/12) if s6cq29b_secocc==1
			replace oth_benefit_sec=s6cq29a_secocc*(52/12) if s6cq29b_secocc==2
			replace oth_benefit_sec=s6cq29a_secocc if s6cq29b_secocc==3
			replace oth_benefit_sec=s6cq29a_secocc/12 if s6cq29b_secocc==4		
			
		* Wage revenue 		
				
		egen ilo_job2_lri_ees=rowtotal(salary_sec inkind_sec subsidy_sec oth_benefit_sec), m
				replace ilo_job2_lri_ees=. if ilo_lfs!=1 & ilo_mjh!=2
			lab var ilo_job2_lri_ees "Monthly earnings of employees in secondary job"
		
		* Self employment
		
			* indicated only for non-farm business --> as turnover indicated may be shared with other households as well, info might not be precise --> don't consider information
	
	
	
***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************			

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_tru') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*                
* Comment: use working hours in all jobs ilo_joball_how_actual --> take as threshold 35 hours (in technical document)
	* also, given that a question asking directly about the availability during the reference week, take as a proxy the question asking how many additional hours 
	* the person would have wanted to work during the last 7 days

	gen ilo_joball_tru=1 if ilo_joball_how_actual<35 & s6eq17==1 & !inlist(s6eq18,0,99,.)
		replace ilo_joball_tru=. if ilo_lfs!=1
			lab def tru_lab 1 "Time-related underemployment"
			lab val ilo_joball_tru tru_lab
			lab var ilo_joball_tru "Time-related underemployment"


*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Cases of non-fatal occupational injury ('ilo_joball_oi_case')
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*
* Comment: no info available

	* gen ilo_joball_oi_case=	

*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Days lost due to cases of occupational injury ('ilo_joball_oi_day') 
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*
* Comment: no info available

	* gen ilo_joball_oi_day=	
	
***********************************************************************************************
*			PART 3.3. UNEMPLOYMENT: ECONOMIC CHARACTERISTICS
***********************************************************************************************	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment:	use both s6eq12a s6eq12b to capture information on the duration of unemployment
	
	gen ilo_dur_details=.
		replace ilo_dur_details=1 if s6eq12b==1 & s6eq12a==0
		replace ilo_dur_details=2 if inlist(s6eq12b,1,2) & s6eq12a==0
		replace ilo_dur_details=3 if inlist(s6eq12b,3,4,5) & s6eq12a==0
		replace ilo_dur_details=4 if inrange(s6eq12b,6,11) & s6eq12a==0
		replace ilo_dur_details=5 if (s6eq12b==12 & s6eq12a==0) | (inrange(s6eq12b,0,11) & s6eq12a==1)
		replace ilo_dur_details=6 if s6eq12a>=2 & s6eq12a!=.
		replace ilo_dur_details=7 if ilo_dur_details==. & ilo_lfs==2
				replace ilo_dur_details=. if ilo_lfs!=2
			lab def ilo_unemp_det 1 "Less than 1 month" 2 "1 month to less than 3 months" 3 "3 months to less than 6 months" 4 "6 months to less than 12 months" 5 "12 months to less than 24 months" ///
									6 "24 months or more" 7 "Not elsewhere classified"
			lab values ilo_dur_details ilo_unemp_det
			lab var ilo_dur_details "Duration of unemployment (Details)" 
			
	gen ilo_dur_aggregate=.
		replace ilo_dur_aggregate=1 if inlist(ilo_dur_details,1,2,3)
		replace ilo_dur_aggregate=2 if ilo_dur_details==4
		replace ilo_dur_aggregate=3 if inlist(ilo_dur_details,5,6)
		replace ilo_dur_aggregate=4 if ilo_dur_details==7
			lab def ilo_unemp_aggr 1 "Less than 6 months" 2 "6 months to less than 12 months" 3 "12 months or more" 4 "Not elsewhere classified"
			lab val ilo_dur_aggregate ilo_unemp_aggr
			lab var ilo_dur_aggregate "Duration of unemployment (Aggregate)"
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Category of unemployment ('ilo_cat_une') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment:
	
	gen ilo_cat_une=.
		replace ilo_cat_une=1 if s6eq13==1
		replace ilo_cat_une=2 if s6eq13==2
		replace ilo_cat_une=3 if ilo_cat_une==. & ilo_lfs==2
				replace ilo_cat_une=. if ilo_lfs!=2
			lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
			lab val ilo_cat_une cat_une_lab
			lab var ilo_cat_une "Category of unemployment"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco') [not being defined]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: no info
			
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu') [not being defined]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			
* Comment: no info
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Unemployment benefits schemes ('ilo_soc_aggregate') [no info available]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment:


			
***********************************************************************************************
*			PART 3.4. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: Degree of labour market attachment of persons outside the labour force
	
	
	gen ilo_olf_dlma=.
		replace ilo_olf_dlma=1 if s6eq8==1 & s6eq7==2
		replace ilo_olf_dlma=2 if s6eq8==2 & s6eq7==1
		replace ilo_olf_dlma=3 if s6eq8==2 & s6eq7==2 & s6eq10==1
		replace ilo_olf_dlma=4 if s6eq8==2 & s6eq7==2 & s6eq10==2
		replace ilo_olf_dlma=5 if ilo_olf_dlma==. & ilo_lfs==3
				replace ilo_olf_dlma=. if ilo_lfs!=3
			lab def lab_olf_dlma 1 "1 - Seeking, not available (Unavailable jobseekers)" 2 "2 - Not seeking, available (Available potential jobseekers)" ///
						3 "3 - Not seeking, not available, willing (Willing non-jobseekers)" 4 "4 - Not seeking, not available, not willing" 5 "5 - Not elsewhere classified"
			lab val ilo_olf_dlma lab_olf_dlma
			lab var ilo_olf_dlma "Labour market attachment (Degree of)"
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reasons for not seeking a job or being outside the labour force ('ilo_olf_reason') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: use s6eq3, s6eq6 and s6eq11 (check with Yves whether appropriately defined...)
	
	gen ilo_olf_reason=.
		replace ilo_olf_reason=1 if s6eq11==1 | inlist(s6eq6,6,7)
		replace ilo_olf_reason=2 if s6eq3==3 
		replace ilo_olf_reason=3 if inlist(s6eq6,2,3,5)
		replace ilo_olf_reason=4 if s6eq6==4
		replace ilo_olf_reason=5 if ilo_olf_reason==. & ilo_lfs==3
			replace ilo_olf_reason=. if ilo_lfs!=3
			lab def lab_olf_reason 1 "1 - Labour market (discouraged)" 2 "2 - Other labour market reasons" 3 "3 - Personal/Family-related"  4 "4 - Does not need/want to work" 5 "5 - Not elsewhere classified"
			lab val ilo_olf_reason lab_olf_reason
			lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job or being outside the labour force)"
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seekers ('ilo_dis') [done]
* -------------------------------------------------------------------------------------------
* ------------------------------------------------------------------------------------------- 
*
* Comment: 	

		gen ilo_dis=1 if ilo_lfs==3 & ilo_olf_reason==1 & s6eq7==1
			lab def ilo_dis_lab 1 "Discouraged job-seekers" 
			lab val ilo_dis ilo_dis_lab
			lab var ilo_dis "Discouraged job-seekers"
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training (NEETs) ('ilo_neet') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: as info on educational attendance cannot be captured, this variable can't be defined either

		gen ilo_neet=.
			replace ilo_neet=1 if inrange(ilo_age,15,24) & ilo_lfs!=1 & ilo_edu_attendance==2
				lab def ilo_neet_lab 1 "Youth not in education, employment or training"
				lab val ilo_neet ilo_neet_lab
				lab var ilo_neet "Youth not in education, employment or training"
				
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

*			SAVE RESULTS

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* -------------------------------------------------------------
* 1.	Prepare final datasets
* -------------------------------------------------------------

cd "$outpath"

 		
		drop indu_code* occ_code_* salary_* inkind_* subsidy_* oth_benefit_*
	
		order ilo*, last
		
		drop if ilo_wgt==.
	
		compress 
		
	* Save dataset including original and ilo variables
	
		save ${country}_${source}_${time}_FULL,  replace		
	
	*Save file only containing ilo_* variables
	
		keep ilo*

		save ${country}_${source}_${time}_ILO, replace		



