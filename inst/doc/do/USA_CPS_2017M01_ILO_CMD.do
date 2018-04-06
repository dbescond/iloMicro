* TITLE OF DO FILE: ILO Microdata Preprocessing code template
* DATASET USED: USA CPS from 
* NOTES:
* Authors: bescond@ilo.org  ILO / STATISTICS / DPAU
* Starting Date: 10/08/2017
* Last updated: 04/10/2017
***********************************************************************************************


***********************************************************************************************
***********************************************************************************************

* 			1. SET UP WORK DIRECTORY, FILE NAME, VARIABLES AND FUNCTIONS

***********************************************************************************************
***********************************************************************************************

clear all 

set more off
*set more off, permanently

global path "J:\DPAU\MICRO"
global country "USA"
global source "CPS"
global time "2017M01"
global inputFile "${country}_${source}_${time}"
global inpath "${path}\\${country}\\${source}\\${time}\ORI"
global outpath "${path}\\${country}\\${source}\\${time}"


************************************************************************************

* Important : if package « labutil » not already installed, install it in order to execute correctly the do-file

* ssc install labutil

************************************************************************************

*********************************************************************************************

* Load original dataset

*********************************************************************************************

cd "$inpath"
	use "$inputFile", clear
	rename *, upper  


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

	* Year 
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
*			Sample Weight ('ilo_wgt')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* PWCMPWGT Composited Final Weight.  Used to create BLS's published labor force statistics (4 implied decimal places)
 
	destring PWCMPWGT, replace
   gen ilo_wgt=.
       replace ilo_wgt = PWCMPWGT //  / 10000000
               lab var ilo_wgt "Sample weight"	


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

/*
	gen ilo_geo = .
		replace ilo_geo = 1 if 										// 1 - Urban
		replace ilo_geo = 2 if  									// 2 - Rural
		replace ilo_geo = 3 if  ilo_geo ==.							// 3 - Not elsewhere classified
		lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural" 3 "3 - Not elsewhere classified"
		lab val ilo_geo ilo_geo_lab
		lab var ilo_geo "Geographical coverage"	
*/	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* PESEX SEX

	gen ilo_sex= PESEX
		lab def ilo_sex_lab 1 "1 - Male" 2 "2 - Female"
		lab var ilo_sex "Sex"
		lab val ilo_sex ilo_sex_lab

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* PRTAGE PERSONS AGE

	gen ilo_age= PRTAGE
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

* PEEDUCA HIGHEST LEVEL OF SCHOOL COMPLETED OR DEGREE RECEIVED

	gen edu_ilo = PEEDUCA
	destring edu_ilo, replace
	gen ilo_edu_isced11=.													// No schooling
		replace ilo_edu_isced11=2 if inlist(edu_ilo, 31)					// Early childhood education
		replace ilo_edu_isced11=3 if inlist(edu_ilo, 32, 33)				// Primary education
		replace ilo_edu_isced11=4 if inlist(edu_ilo, 34, 35)				// Lower secondary education
		replace ilo_edu_isced11=5 if inlist(edu_ilo, 36, 37, 38, 39, 40)	// Upper secondary education
		* replace ilo_edu_isced11=6 if edu_ilo==400 						// Post-secondary non-tertiary education
		replace ilo_edu_isced11=7 if inlist(edu_ilo, 41, 42)				// Short-cycle tertiary education
		replace ilo_edu_isced11=8 if edu_ilo==43 							// Bachelor's or equivalent level
		replace ilo_edu_isced11=9 if inlist(edu_ilo, 44, 45)				// Master's or equivalent level
		replace ilo_edu_isced11=10 if edu_ilo==46 							// Doctoral or equivalent level 
		replace ilo_edu_isced11=11 if ilo_edu_isced11==.					// Not elsewhere classified
			label def isced_11_lab 1 "X - No schooling" 2 "0 - Early childhood education" 3 "1 - Primary education" 4 "2 - Lower secondary education" 5 "3 - Upper secondary education" ///
									6 "4 - Post-secondary non-tertiary education" 7 "5 - Short-cycle tertiary education" 8 "6 - Bachelor's or equivalent level" 9 "7 - Master's or equivalent level" ///
									10 "8 - Doctoral or equivalent level" 11 "9 - Not elsewhere classified"
			label val ilo_edu_isced11 isced_11_lab
			lab var ilo_edu_isced11 "Education (ISCED 11)"
		
		* for the definition, cf. the document "Guide to reporting labour statistics to the ILO using the Excel questionnaire"
		
	gen ilo_edu_aggregate=.
		replace ilo_edu_aggregate=1 if inlist(ilo_edu_isced11,1,2)					// Less than basic
		replace ilo_edu_aggregate=2 if inlist(ilo_edu_isced11,3,4)					// Basic
		replace ilo_edu_aggregate=3 if inlist(ilo_edu_isced11,5,6)					// Intermediate
		replace ilo_edu_aggregate=4 if inlist(ilo_edu_isced11,7,8,9,10)				// Advanced
		replace ilo_edu_aggregate=5 if ilo_edu_isced11==11							// Level not stated
			label def edu_aggr_lab 1 "1 - Less than basic" 2 "2 - Basic" 3 "3 - Intermediate" 4 "4 - Advanced" 5 "5 - Level not stated"
			label val ilo_edu_aggregate edu_aggr_lab
			label var ilo_edu_aggregate "Education (Aggregate level)"
drop edu_ilo	
				
			
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education attendance ('ilo_edu_attendance')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* PENLFACT WHAT BEST DESCRIBES YOUR SITUATION AT THIS TIME?  FOR EXAMPLE, ARE YOU DISABLED, ILL, IN SCHOOL, TAKING CARE OF HOUSE OR FAMILY, OR SOMETHING ELSE? (3	IN SCHOOL)

          gen ilo_edu_attendance=.
				replace ilo_edu_attendance=1 if PENLFACT ==3 						// 1 - Attending
				replace ilo_edu_attendance=2 if PENLFACT !=3 		  				// 2 - Not attending
				replace ilo_edu_attendance=3 if ilo_edu_attendance ==. 				// 3 - Not elsewhere classified
				lab def edu_attendance_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
				lab val ilo_edu_attendance edu_attendance_lab
				lab var ilo_edu_attendance "Education (Attendance)"      
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Disability status ('ilo_dsb')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

* PRDISFLG DOES THIS PERSON HAVE ANY OF THESE DISABILITY CONDITIONS? (1	Yes)

	gen ilo_dsb_aggregate=.
		replace ilo_dsb_aggregate=1 if PRDISFLG!=1
		replace ilo_dsb_aggregate=2 if PRDISFLG==1
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

	gen ilo_wap=.
		replace ilo_wap=1 if ilo_age>=15 & ilo_age!=.				// Working age population
			label def ilo_wap_lab 1 "Working age population"
			label val ilo_wap ilo_wap_lab
			label var ilo_wap "Working age population"

			
			
			
	* tab  ilo_age_5yrbands [iw = ilo_wgt] if ilo_wap == 1 &  PRTAGE > 15, m
	* tab  ilo_geo [iw = ilo_wgt] if ilo_wap == 1, m
	* tab  ilo_sex [iw = ilo_wgt] if ilo_wap == 1, m
	* tab  ilo_edu_isced11 [iw = ilo_wgt] if ilo_wap == 1, m
	* tab  ilo_edu_aggregate [iw = ilo_wgt] if ilo_wap == 1, m
				
			
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Labour Force Status ('ilo_lfs')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: Directly based on labour status variable. 
* PREMPNOT MLR - EMPLOYED, UNEMPLOYED, OR NILF

	gen ilo_lfs=.
	    replace ilo_lfs=1 if PREMPNOT == 1         								// Employed
		replace ilo_lfs=2 if PREMPNOT == 2 						    			// Unemployed 
		replace ilo_lfs=3 if inlist(PREMPNOT, 3, 4) & ilo_wap==1      			// Outside the labour force
		    label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside the Labour Force"
			label value ilo_lfs label_ilo_lfs
			label var ilo_lfs "Labour Force Status"

			
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* PEMJOT DO YOU HAVE MORE THAN ONE JOB? (1      YES)

    gen ilo_mjh=.
		replace ilo_mjh = 1 if PEMJOT == 2 & ilo_lfs == 1						// 1 - One job only
		replace ilo_mjh = 2 if PEMJOT == 1 & ilo_lfs == 1						// 2- More than one job
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

* PRCOW1 CLASS OF WORKER RECODE - JOB 1

	* Detailed categories:
		gen ilo_job1_ste_icse93=.
			replace ilo_job1_ste_icse93=1 if (inlist(PRCOW1, 1, 2, 3, 4) & ilo_lfs==1)   		    // Employees
			* replace ilo_job1_ste_icse93=2 if (PRCOW1==1 & ilo_lfs==1)	            // Employers
			replace ilo_job1_ste_icse93=3 if (PRCOW1== 5 & ilo_lfs==1)      			// Own-account workers
			* replace ilo_job1_ste_icse93=4                                         // Members of producers’ cooperatives
			replace ilo_job1_ste_icse93=5 if (PRCOW1==6 & ilo_lfs==1)	            // Contributing family workers
			replace ilo_job1_ste_icse93=6 if (ilo_job1_ste_icse93==. & ilo_lfs==1)  // Not classifiable
				label def label_ilo_ste_icse93 1 "1 - Employees" 2 "2 - Employers" 3 "3 - Own-account workers" ///                      
											   4 "4 - Members of producers cooperatives" 5 "5 - Contributing family workers" ///
											   6 "6 - Workers not classifiable by status"
				label val ilo_job1_ste_icse93 label_ilo_ste_icse93
				label var ilo_job1_ste_icse93 "Status in employment (ICSE 93)"

	* Aggregate categories 
		gen ilo_job1_ste_aggregate=.
			replace ilo_job1_ste_aggregate=1 if (inlist(PRCOW1, 1, 2, 3, 4) & ilo_lfs==1)			// Employees
			replace ilo_job1_ste_aggregate=2 if (inlist(PRCOW1,5,6) & ilo_lfs==1)	// Self-employed
			replace ilo_job1_ste_aggregate=3 if (PRCOW1==. & ilo_lfs==1)			// Not elsewhere classified
				lab def ste_aggr_lab 1 "1 - Employees" 2 "2 - Self-employed" 3 "3 - Not elsewhere classified"
				lab val ilo_job1_ste_aggregate ste_aggr_lab
				label var ilo_job1_ste_aggregate "Status in employment (Aggregate)"  
 
	* tab  ilo_job1_ste_icse93 [iw = ilo_wgt] if ilo_lfs == 1, m			
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
/*
* PEIO1ICD INDUSTRY CODE FOR PRIMARY JOB

* Import value labels
		

* ISIC Rev. 4
		tostring NACE1D, replace
		gen ilo_job1_eco_isic4=.
			replace ilo_job1_eco_isic4=1 if NACE1D=="A"				// Agriculture, forestry and fishing
			replace ilo_job1_eco_isic4=2 if NACE1D=="B"				// Mining and quarrying
			replace ilo_job1_eco_isic4=3 if NACE1D=="C"				// Manufacturing
			replace ilo_job1_eco_isic4=4 if NACE1D=="D"				// Electricity, gas, steam and air conditioning supply
			replace ilo_job1_eco_isic4=5 if NACE1D=="E"				// Water supply; sewerage, waste management and remediation activities
			replace ilo_job1_eco_isic4=6 if NACE1D=="F"				// Construction
			replace ilo_job1_eco_isic4=7 if NACE1D=="G"          	// Wholesale and retail trade; repair of motor vehicles and motorcycles
			replace ilo_job1_eco_isic4=8 if NACE1D=="H"				// Transportation and storage
			replace ilo_job1_eco_isic4=9 if NACE1D=="I"				// Accommodation and food service activities
			replace ilo_job1_eco_isic4=10 if NACE1D=="J"			// Information and communication
			replace ilo_job1_eco_isic4=11 if NACE1D=="K"			// Financial and insurance activities	
			replace ilo_job1_eco_isic4=12 if NACE1D=="L"			// Real estate activities
			replace ilo_job1_eco_isic4=13 if NACE1D=="M"			// Professional, scientific and technical activities
			replace ilo_job1_eco_isic4=14 if NACE1D=="N"			// Administrative and support service activities
			replace ilo_job1_eco_isic4=15 if NACE1D=="O"			// Public administration and defence; compulsory social security
			replace ilo_job1_eco_isic4=16 if NACE1D=="P"			// Education
			replace ilo_job1_eco_isic4=17 if NACE1D=="Q"			// Human health and social work activities
			replace ilo_job1_eco_isic4=18 if NACE1D=="R"			// Arts, entertainment and recreation
			replace ilo_job1_eco_isic4=19 if NACE1D=="S"			// Other service activities
			replace ilo_job1_eco_isic4=20 if NACE1D=="T"			// Activities of households as employers; undifferentiated goods- and services-producing activities of households for own use
			replace ilo_job1_eco_isic4=21 if NACE1D=="U"			// Activities of extraterritorial organizations and bodies
			replace ilo_job1_eco_isic4=22 if NACE1D=="9"		    // Not elsewhere classified
			replace ilo_job1_eco_isic4=22 if ilo_job1_eco_isic4==. & ilo_lfs==1 
				
				lab def eco_isic4_lab 1 "A - Agriculture, forestry and fishing" 2 "B - Mining and quarrying" 3 "C - Manufacturing" 4 "D - Electricity, gas, steam and air conditioning supply" /// 
								5 "E - Water supply; sewerage, waste management and remediation activities" 6 "F - Construction" 7 "G - Wholesale and retail trade; repair of motor vehicles and motorcycles" /// 
								8 "H - Transportation and storage" 9 "I - Accommodation and food service activities" 10 "J - Information and communication" 11 "K - Financial and insurance activities" /// 
								12 "L - Real estate activities" 13 "M - Professional, scientific and technical activities" 14 "N - Administrative and support service activities" /// 
								15 "O - Public administration and defence; compulsory social security" 16 "P - Education" 17 "Q - Human health and social work activities" 18 "R - Arts, entertainment and recreation" /// 
								19 "S - Other service activities" 20 "T - Activities of households as employers; undifferentiated goods- and services-producing activities of households for own use" /// 
								21 "U - Activities of extraterritorial organizations and bodies" 22 "X - Not elsewhere classified"
				lab val ilo_job1_eco_isic4 eco_isic4_lab
				lab var ilo_job1_eco_isic4 "Economic activity (ISIC Rev. 4)"
			
			
	* Now do the classification on an aggregate level
	
		* Primary activity
		
		gen ilo_job1_eco_aggregate=.
			replace ilo_job1_eco_aggregate=1 if ilo_job1_eco_isic4==1				// 1 - Agriculture
			replace ilo_job1_eco_aggregate=2 if ilo_job1_eco_isic4==3				// 2 - Manufacturing
			replace ilo_job1_eco_aggregate=3 if ilo_job1_eco_isic4==6				// 3 - Construction
			replace ilo_job1_eco_aggregate=4 if inlist(ilo_job1_eco_isic4,2,4,5)	// 4 - Mining and quarrying; Electricity, gas and water supply
			replace ilo_job1_eco_aggregate=5 if inrange(ilo_job1_eco_isic4,7,14)	// 5 - Market Services (Trade; Transportation; Accommodation and food; and Business and administrative services)
			replace ilo_job1_eco_aggregate=6 if inrange(ilo_job1_eco_isic4,15,21) 	// 6 - Non-market services (Public administration; Community, social and other services and activities)
			replace ilo_job1_eco_aggregate=7 if ilo_job1_eco_isic4==22				// 7 - Not classifiable by economic activity
				lab def eco_aggr_lab 1 "1 - Agriculture" 2 "2 - Manufacturing" 3 "3 - Construction" 4 "4 - Mining and quarrying; Electricity, gas and water supply" ///
									5 "5 - Market Services (Trade; Transportation; Accommodation and food; and Business and administrative services)"  ///
									6 "6 - Non-market services (Public administration; Community, social and other services and activities)" 7 "7 - Not classifiable by economic activity"					
				lab val ilo_job1_eco_aggregate eco_aggr_lab
				lab var ilo_job1_eco_aggregate "Economic activity (Aggregate)"			


		* test if var is should be drop 	
		egen drop_var = mean(ilo_job1_eco_aggregate)
		local Z = drop_var in 1
		if `Z' == 7 {
			drop ilo_job1_eco_aggregate ilo_job1_eco_isic4
		}
		drop 	drop_var	
	* tab  ilo_job1_eco_isic4 [iw = ilo_wgt] if ilo_lfs == 1, m
	

				
	*/			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_job1_ocu_isco08')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: var PEIO1OCD apply for all then reduce to emp and une at the end of the do.
* PEIO1OCD OCCUPATION CODE FOR PRIMARY JOB.
	

	gen isco_ilo = PEIO1OCD 
	destring isco_ilo, replace
	gen ilo_job1_ocu_isco08_2digits = .
	
	capture replace ilo_job1_ocu_isco08_2digits = 1 if isco_ilo ==  9800                     // 01 - Commissioned armed forces officers
capture replace ilo_job1_ocu_isco08_2digits = 2 if isco_ilo ==  9810                     // 02 - Non-commissioned armed forces officers
capture replace ilo_job1_ocu_isco08_2digits = 3 if isco_ilo ==  9820                     // 03 - Armed forces occupations, other ranks
capture replace ilo_job1_ocu_isco08_2digits = 3 if isco_ilo ==  9830                     // 03 - Armed forces occupations, other ranks
capture replace ilo_job1_ocu_isco08_2digits = 11 if isco_ilo ==  10                     // 11 - Chief executives, senior officials and legislators
capture replace ilo_job1_ocu_isco08_2digits = 11 if isco_ilo ==  20                     // 11 - Chief executives, senior officials and legislators
capture replace ilo_job1_ocu_isco08_2digits = 11 if isco_ilo ==  30                     // 11 - Chief executives, senior officials and legislators
capture replace ilo_job1_ocu_isco08_2digits = 11 if isco_ilo ==  60                     // 11 - Chief executives, senior officials and legislators
capture replace ilo_job1_ocu_isco08_2digits = 11 if isco_ilo ==  425                     // 11 - Chief executives, senior officials and legislators
capture replace ilo_job1_ocu_isco08_2digits = 11 if isco_ilo ==  430                     // 11 - Chief executives, senior officials and legislators
capture replace ilo_job1_ocu_isco08_2digits = 12 if isco_ilo ==  40                     // 12 - Administrative and commercial managers
capture replace ilo_job1_ocu_isco08_2digits = 12 if isco_ilo ==  50                     // 12 - Administrative and commercial managers
capture replace ilo_job1_ocu_isco08_2digits = 12 if isco_ilo ==  100                     // 12 - Administrative and commercial managers
capture replace ilo_job1_ocu_isco08_2digits = 12 if isco_ilo ==  120                     // 12 - Administrative and commercial managers
capture replace ilo_job1_ocu_isco08_2digits = 12 if isco_ilo ==  135                     // 12 - Administrative and commercial managers
capture replace ilo_job1_ocu_isco08_2digits = 12 if isco_ilo ==  136                     // 12 - Administrative and commercial managers
capture replace ilo_job1_ocu_isco08_2digits = 12 if isco_ilo ==  137                     // 12 - Administrative and commercial managers
capture replace ilo_job1_ocu_isco08_2digits = 12 if isco_ilo ==  150                     // 12 - Administrative and commercial managers
capture replace ilo_job1_ocu_isco08_2digits = 12 if isco_ilo ==  300                     // 12 - Administrative and commercial managers
capture replace ilo_job1_ocu_isco08_2digits = 12 if isco_ilo ==  325                     // 12 - Administrative and commercial managers
capture replace ilo_job1_ocu_isco08_2digits = 12 if isco_ilo ==  360                     // 12 - Administrative and commercial managers
capture replace ilo_job1_ocu_isco08_2digits = 12 if isco_ilo ==  400                     // 12 - Administrative and commercial managers
capture replace ilo_job1_ocu_isco08_2digits = 13 if isco_ilo ==  110                     // 13 - Production and specialised services managers
capture replace ilo_job1_ocu_isco08_2digits = 13 if isco_ilo ==  140                     // 13 - Production and specialised services managers
capture replace ilo_job1_ocu_isco08_2digits = 13 if isco_ilo ==  160                     // 13 - Production and specialised services managers
capture replace ilo_job1_ocu_isco08_2digits = 13 if isco_ilo ==  205                     // 13 - Production and specialised services managers
capture replace ilo_job1_ocu_isco08_2digits = 13 if isco_ilo ==  220                     // 13 - Production and specialised services managers
capture replace ilo_job1_ocu_isco08_2digits = 13 if isco_ilo ==  230                     // 13 - Production and specialised services managers
capture replace ilo_job1_ocu_isco08_2digits = 13 if isco_ilo ==  350                     // 13 - Production and specialised services managers
capture replace ilo_job1_ocu_isco08_2digits = 13 if isco_ilo ==  420                     // 13 - Production and specialised services managers
capture replace ilo_job1_ocu_isco08_2digits = 14 if isco_ilo ==  310                     // 14 - Hospitality, retail and other services managers
capture replace ilo_job1_ocu_isco08_2digits = 14 if isco_ilo ==  330                     // 14 - Hospitality, retail and other services managers
capture replace ilo_job1_ocu_isco08_2digits = 14 if isco_ilo ==  340                     // 14 - Hospitality, retail and other services managers
capture replace ilo_job1_ocu_isco08_2digits = 21 if isco_ilo ==  1200                     // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if isco_ilo ==  1210                     // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if isco_ilo ==  1220                     // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if isco_ilo ==  1230                     // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if isco_ilo ==  1300                     // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if isco_ilo ==  1310                     // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if isco_ilo ==  1320                     // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if isco_ilo ==  1330                     // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if isco_ilo ==  1340                     // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if isco_ilo ==  1350                     // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if isco_ilo ==  1360                     // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if isco_ilo ==  1400                     // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if isco_ilo ==  1410                     // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if isco_ilo ==  1420                     // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if isco_ilo ==  1430                     // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if isco_ilo ==  1440                     // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if isco_ilo ==  1450                     // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if isco_ilo ==  1460                     // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if isco_ilo ==  1500                     // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if isco_ilo ==  1510                     // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if isco_ilo ==  1520                     // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if isco_ilo ==  1530                     // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if isco_ilo ==  1600                     // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if isco_ilo ==  1610                     // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if isco_ilo ==  1640                     // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if isco_ilo ==  1650                     // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if isco_ilo ==  1660                     // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if isco_ilo ==  1700                     // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if isco_ilo ==  1710                     // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if isco_ilo ==  1720                     // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if isco_ilo ==  1740                     // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if isco_ilo ==  1760                     // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if isco_ilo ==  1815                     // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if isco_ilo ==  1840                     // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if isco_ilo ==  2630                     // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 22 if isco_ilo ==  2025                     // 22 - Health professionals
capture replace ilo_job1_ocu_isco08_2digits = 22 if isco_ilo ==  3000                     // 22 - Health professionals
capture replace ilo_job1_ocu_isco08_2digits = 22 if isco_ilo ==  3010                     // 22 - Health professionals
capture replace ilo_job1_ocu_isco08_2digits = 22 if isco_ilo ==  3030                     // 22 - Health professionals
capture replace ilo_job1_ocu_isco08_2digits = 22 if isco_ilo ==  3040                     // 22 - Health professionals
capture replace ilo_job1_ocu_isco08_2digits = 22 if isco_ilo ==  3050                     // 22 - Health professionals
capture replace ilo_job1_ocu_isco08_2digits = 22 if isco_ilo ==  3060                     // 22 - Health professionals
capture replace ilo_job1_ocu_isco08_2digits = 22 if isco_ilo ==  3110                     // 22 - Health professionals
capture replace ilo_job1_ocu_isco08_2digits = 22 if isco_ilo ==  3120                     // 22 - Health professionals
capture replace ilo_job1_ocu_isco08_2digits = 22 if isco_ilo ==  3140                     // 22 - Health professionals
capture replace ilo_job1_ocu_isco08_2digits = 22 if isco_ilo ==  3150                     // 22 - Health professionals
capture replace ilo_job1_ocu_isco08_2digits = 22 if isco_ilo ==  3160                     // 22 - Health professionals
capture replace ilo_job1_ocu_isco08_2digits = 22 if isco_ilo ==  3210                     // 22 - Health professionals
capture replace ilo_job1_ocu_isco08_2digits = 22 if isco_ilo ==  3230                     // 22 - Health professionals
capture replace ilo_job1_ocu_isco08_2digits = 22 if isco_ilo ==  3235                     // 22 - Health professionals
capture replace ilo_job1_ocu_isco08_2digits = 22 if isco_ilo ==  3245                     // 22 - Health professionals
capture replace ilo_job1_ocu_isco08_2digits = 22 if isco_ilo ==  3250                     // 22 - Health professionals
capture replace ilo_job1_ocu_isco08_2digits = 22 if isco_ilo ==  3255                     // 22 - Health professionals
capture replace ilo_job1_ocu_isco08_2digits = 22 if isco_ilo ==  3256                     // 22 - Health professionals
capture replace ilo_job1_ocu_isco08_2digits = 22 if isco_ilo ==  3257                     // 22 - Health professionals
capture replace ilo_job1_ocu_isco08_2digits = 22 if isco_ilo ==  3258                     // 22 - Health professionals
capture replace ilo_job1_ocu_isco08_2digits = 22 if isco_ilo ==  3260                     // 22 - Health professionals
capture replace ilo_job1_ocu_isco08_2digits = 23 if isco_ilo ==  650                     // 23 - Teaching professionals
capture replace ilo_job1_ocu_isco08_2digits = 23 if isco_ilo ==  2200                     // 23 - Teaching professionals
capture replace ilo_job1_ocu_isco08_2digits = 23 if isco_ilo ==  2300                     // 23 - Teaching professionals
capture replace ilo_job1_ocu_isco08_2digits = 23 if isco_ilo ==  2310                     // 23 - Teaching professionals
capture replace ilo_job1_ocu_isco08_2digits = 23 if isco_ilo ==  2320                     // 23 - Teaching professionals
capture replace ilo_job1_ocu_isco08_2digits = 23 if isco_ilo ==  2330                     // 23 - Teaching professionals
capture replace ilo_job1_ocu_isco08_2digits = 23 if isco_ilo ==  2340                     // 23 - Teaching professionals
capture replace ilo_job1_ocu_isco08_2digits = 23 if isco_ilo ==  2550                     // 23 - Teaching professionals
capture replace ilo_job1_ocu_isco08_2digits = 24 if isco_ilo ==  630                     // 24 - Business and administration professionals
capture replace ilo_job1_ocu_isco08_2digits = 24 if isco_ilo ==  640                     // 24 - Business and administration professionals
capture replace ilo_job1_ocu_isco08_2digits = 24 if isco_ilo ==  700                     // 24 - Business and administration professionals
capture replace ilo_job1_ocu_isco08_2digits = 24 if isco_ilo ==  710                     // 24 - Business and administration professionals
capture replace ilo_job1_ocu_isco08_2digits = 24 if isco_ilo ==  735                     // 24 - Business and administration professionals
capture replace ilo_job1_ocu_isco08_2digits = 24 if isco_ilo ==  740                     // 24 - Business and administration professionals
capture replace ilo_job1_ocu_isco08_2digits = 24 if isco_ilo ==  800                     // 24 - Business and administration professionals
capture replace ilo_job1_ocu_isco08_2digits = 24 if isco_ilo ==  820                     // 24 - Business and administration professionals
capture replace ilo_job1_ocu_isco08_2digits = 24 if isco_ilo ==  830                     // 24 - Business and administration professionals
capture replace ilo_job1_ocu_isco08_2digits = 24 if isco_ilo ==  840                     // 24 - Business and administration professionals
capture replace ilo_job1_ocu_isco08_2digits = 24 if isco_ilo ==  850                     // 24 - Business and administration professionals
capture replace ilo_job1_ocu_isco08_2digits = 24 if isco_ilo ==  900                     // 24 - Business and administration professionals
capture replace ilo_job1_ocu_isco08_2digits = 24 if isco_ilo ==  940                     // 24 - Business and administration professionals
capture replace ilo_job1_ocu_isco08_2digits = 24 if isco_ilo ==  2800                     // 24 - Business and administration professionals
capture replace ilo_job1_ocu_isco08_2digits = 24 if isco_ilo ==  2825                     // 24 - Business and administration professionals
capture replace ilo_job1_ocu_isco08_2digits = 24 if isco_ilo ==  2850                     // 24 - Business and administration professionals
capture replace ilo_job1_ocu_isco08_2digits = 24 if isco_ilo ==  4710                     // 24 - Business and administration professionals
capture replace ilo_job1_ocu_isco08_2digits = 24 if isco_ilo ==  4850                     // 24 - Business and administration professionals
capture replace ilo_job1_ocu_isco08_2digits = 24 if isco_ilo ==  4930                     // 24 - Business and administration professionals
capture replace ilo_job1_ocu_isco08_2digits = 25 if isco_ilo ==  1005                     // 25 - Information and communications technology professionals
capture replace ilo_job1_ocu_isco08_2digits = 25 if isco_ilo ==  1006                     // 25 - Information and communications technology professionals
capture replace ilo_job1_ocu_isco08_2digits = 25 if isco_ilo ==  1007                     // 25 - Information and communications technology professionals
capture replace ilo_job1_ocu_isco08_2digits = 25 if isco_ilo ==  1010                     // 25 - Information and communications technology professionals
capture replace ilo_job1_ocu_isco08_2digits = 25 if isco_ilo ==  1020                     // 25 - Information and communications technology professionals
capture replace ilo_job1_ocu_isco08_2digits = 25 if isco_ilo ==  1030                     // 25 - Information and communications technology professionals
capture replace ilo_job1_ocu_isco08_2digits = 25 if isco_ilo ==  1060                     // 25 - Information and communications technology professionals
capture replace ilo_job1_ocu_isco08_2digits = 25 if isco_ilo ==  1105                     // 25 - Information and communications technology professionals
capture replace ilo_job1_ocu_isco08_2digits = 25 if isco_ilo ==  1106                     // 25 - Information and communications technology professionals
capture replace ilo_job1_ocu_isco08_2digits = 25 if isco_ilo ==  1107                     // 25 - Information and communications technology professionals
capture replace ilo_job1_ocu_isco08_2digits = 26 if isco_ilo ==  1800                     // 26 - Legal, social and cultural professionals
capture replace ilo_job1_ocu_isco08_2digits = 26 if isco_ilo ==  1820                     // 26 - Legal, social and cultural professionals
capture replace ilo_job1_ocu_isco08_2digits = 26 if isco_ilo ==  1830                     // 26 - Legal, social and cultural professionals
capture replace ilo_job1_ocu_isco08_2digits = 26 if isco_ilo ==  1860                     // 26 - Legal, social and cultural professionals
capture replace ilo_job1_ocu_isco08_2digits = 26 if isco_ilo ==  2000                     // 26 - Legal, social and cultural professionals
capture replace ilo_job1_ocu_isco08_2digits = 26 if isco_ilo ==  2010                     // 26 - Legal, social and cultural professionals
capture replace ilo_job1_ocu_isco08_2digits = 26 if isco_ilo ==  2015                     // 26 - Legal, social and cultural professionals
capture replace ilo_job1_ocu_isco08_2digits = 26 if isco_ilo ==  2040                     // 26 - Legal, social and cultural professionals
capture replace ilo_job1_ocu_isco08_2digits = 26 if isco_ilo ==  2050                     // 26 - Legal, social and cultural professionals
capture replace ilo_job1_ocu_isco08_2digits = 26 if isco_ilo ==  2100                     // 26 - Legal, social and cultural professionals
capture replace ilo_job1_ocu_isco08_2digits = 26 if isco_ilo ==  2110                     // 26 - Legal, social and cultural professionals
capture replace ilo_job1_ocu_isco08_2digits = 26 if isco_ilo ==  2400                     // 26 - Legal, social and cultural professionals
capture replace ilo_job1_ocu_isco08_2digits = 26 if isco_ilo ==  2430                     // 26 - Legal, social and cultural professionals
capture replace ilo_job1_ocu_isco08_2digits = 26 if isco_ilo ==  2600                     // 26 - Legal, social and cultural professionals
capture replace ilo_job1_ocu_isco08_2digits = 26 if isco_ilo ==  2700                     // 26 - Legal, social and cultural professionals
capture replace ilo_job1_ocu_isco08_2digits = 26 if isco_ilo ==  2710                     // 26 - Legal, social and cultural professionals
capture replace ilo_job1_ocu_isco08_2digits = 26 if isco_ilo ==  2740                     // 26 - Legal, social and cultural professionals
capture replace ilo_job1_ocu_isco08_2digits = 26 if isco_ilo ==  2750                     // 26 - Legal, social and cultural professionals
capture replace ilo_job1_ocu_isco08_2digits = 26 if isco_ilo ==  2760                     // 26 - Legal, social and cultural professionals
capture replace ilo_job1_ocu_isco08_2digits = 26 if isco_ilo ==  2810                     // 26 - Legal, social and cultural professionals
capture replace ilo_job1_ocu_isco08_2digits = 26 if isco_ilo ==  2830                     // 26 - Legal, social and cultural professionals
capture replace ilo_job1_ocu_isco08_2digits = 26 if isco_ilo ==  2840                     // 26 - Legal, social and cultural professionals
capture replace ilo_job1_ocu_isco08_2digits = 31 if isco_ilo ==  1540                     // 31 - Science and engineering associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 31 if isco_ilo ==  1550                     // 31 - Science and engineering associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 31 if isco_ilo ==  1560                     // 31 - Science and engineering associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 31 if isco_ilo ==  1900                     // 31 - Science and engineering associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 31 if isco_ilo ==  1910                     // 31 - Science and engineering associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 31 if isco_ilo ==  1920                     // 31 - Science and engineering associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 31 if isco_ilo ==  1930                     // 31 - Science and engineering associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 31 if isco_ilo ==  1940                     // 31 - Science and engineering associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 31 if isco_ilo ==  1965                     // 31 - Science and engineering associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 31 if isco_ilo ==  3720                     // 31 - Science and engineering associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 31 if isco_ilo ==  3750                     // 31 - Science and engineering associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 31 if isco_ilo ==  6200                     // 31 - Science and engineering associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 31 if isco_ilo ==  6660                     // 31 - Science and engineering associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 31 if isco_ilo ==  7700                     // 31 - Science and engineering associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 31 if isco_ilo ==  8040                     // 31 - Science and engineering associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 31 if isco_ilo ==  8600                     // 31 - Science and engineering associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 31 if isco_ilo ==  8620                     // 31 - Science and engineering associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 31 if isco_ilo ==  8630                     // 31 - Science and engineering associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 31 if isco_ilo ==  9030                     // 31 - Science and engineering associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 31 if isco_ilo ==  9040                     // 31 - Science and engineering associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 31 if isco_ilo ==  9310                     // 31 - Science and engineering associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 31 if isco_ilo ==  9330                     // 31 - Science and engineering associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 31 if isco_ilo ==  9650                     // 31 - Science and engineering associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 32 if isco_ilo ==  3200                     // 32 - Health associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 32 if isco_ilo ==  3220                     // 32 - Health associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 32 if isco_ilo ==  3300                     // 32 - Health associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 32 if isco_ilo ==  3310                     // 32 - Health associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 32 if isco_ilo ==  3320                     // 32 - Health associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 32 if isco_ilo ==  3400                     // 32 - Health associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 32 if isco_ilo ==  3420                     // 32 - Health associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 32 if isco_ilo ==  3500                     // 32 - Health associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 32 if isco_ilo ==  3510                     // 32 - Health associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 32 if isco_ilo ==  3520                     // 32 - Health associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 32 if isco_ilo ==  3535                     // 32 - Health associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 32 if isco_ilo ==  3540                     // 32 - Health associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 32 if isco_ilo ==  3610                     // 32 - Health associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 32 if isco_ilo ==  3620                     // 32 - Health associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 32 if isco_ilo ==  3630                     // 32 - Health associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 32 if isco_ilo ==  3640                     // 32 - Health associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 32 if isco_ilo ==  3645                     // 32 - Health associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 32 if isco_ilo ==  3648                     // 32 - Health associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 32 if isco_ilo ==  3655                     // 32 - Health associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 32 if isco_ilo ==  6010                     // 32 - Health associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 32 if isco_ilo ==  8760                     // 32 - Health associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 32 if isco_ilo ==  9410                     // 32 - Health associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if isco_ilo ==  410                     // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if isco_ilo ==  500                     // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if isco_ilo ==  510                     // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if isco_ilo ==  520                     // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if isco_ilo ==  530                     // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if isco_ilo ==  540                     // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if isco_ilo ==  565                     // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if isco_ilo ==  600                     // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if isco_ilo ==  725                     // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if isco_ilo ==  810                     // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if isco_ilo ==  860                     // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if isco_ilo ==  910                     // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if isco_ilo ==  930                     // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if isco_ilo ==  950                     // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if isco_ilo ==  1240                     // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if isco_ilo ==  1950                     // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if isco_ilo ==  3646                     // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if isco_ilo ==  3710                     // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if isco_ilo ==  3820                     // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if isco_ilo ==  3850                     // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if isco_ilo ==  4800                     // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if isco_ilo ==  4810                     // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if isco_ilo ==  4820                     // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if isco_ilo ==  4830                     // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if isco_ilo ==  4840                     // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if isco_ilo ==  4920                     // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if isco_ilo ==  4965                     // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if isco_ilo ==  5000                     // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if isco_ilo ==  5120                     // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if isco_ilo ==  5220                     // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if isco_ilo ==  5250                     // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if isco_ilo ==  5500                     // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if isco_ilo ==  5610                     // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if isco_ilo ==  5920                     // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 34 if isco_ilo ==  2016                     // 34 - Legal, social, cultural and related associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 34 if isco_ilo ==  2060                     // 34 - Legal, social, cultural and related associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 34 if isco_ilo ==  2105                     // 34 - Legal, social, cultural and related associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 34 if isco_ilo ==  2145                     // 34 - Legal, social, cultural and related associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 34 if isco_ilo ==  2160                     // 34 - Legal, social, cultural and related associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 34 if isco_ilo ==  2440                     // 34 - Legal, social, cultural and related associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 34 if isco_ilo ==  2720                     // 34 - Legal, social, cultural and related associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 34 if isco_ilo ==  2860                     // 34 - Legal, social, cultural and related associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 34 if isco_ilo ==  2910                     // 34 - Legal, social, cultural and related associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 34 if isco_ilo ==  2960                     // 34 - Legal, social, cultural and related associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 34 if isco_ilo ==  3800                     // 34 - Legal, social, cultural and related associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 34 if isco_ilo ==  3910                     // 34 - Legal, social, cultural and related associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 34 if isco_ilo ==  4000                     // 34 - Legal, social, cultural and related associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 34 if isco_ilo ==  4010                     // 34 - Legal, social, cultural and related associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 34 if isco_ilo ==  4320                     // 34 - Legal, social, cultural and related associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 34 if isco_ilo ==  4430                     // 34 - Legal, social, cultural and related associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 34 if isco_ilo ==  4620                     // 34 - Legal, social, cultural and related associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 35 if isco_ilo ==  1050                     // 35 - Information and communications technicians
capture replace ilo_job1_ocu_isco08_2digits = 35 if isco_ilo ==  2900                     // 35 - Information and communications technicians
capture replace ilo_job1_ocu_isco08_2digits = 35 if isco_ilo ==  2920                     // 35 - Information and communications technicians
capture replace ilo_job1_ocu_isco08_2digits = 35 if isco_ilo ==  5800                     // 35 - Information and communications technicians
capture replace ilo_job1_ocu_isco08_2digits = 41 if isco_ilo ==  5150                     // 41 - General and keyboard clerks
capture replace ilo_job1_ocu_isco08_2digits = 41 if isco_ilo ==  5700                     // 41 - General and keyboard clerks
capture replace ilo_job1_ocu_isco08_2digits = 41 if isco_ilo ==  5810                     // 41 - General and keyboard clerks
capture replace ilo_job1_ocu_isco08_2digits = 41 if isco_ilo ==  5820                     // 41 - General and keyboard clerks
capture replace ilo_job1_ocu_isco08_2digits = 41 if isco_ilo ==  5860                     // 41 - General and keyboard clerks
capture replace ilo_job1_ocu_isco08_2digits = 42 if isco_ilo ==  726                     // 42 - Customer services clerks
capture replace ilo_job1_ocu_isco08_2digits = 42 if isco_ilo ==  4300                     // 42 - Customer services clerks
capture replace ilo_job1_ocu_isco08_2digits = 42 if isco_ilo ==  4400                     // 42 - Customer services clerks
capture replace ilo_job1_ocu_isco08_2digits = 42 if isco_ilo ==  5010                     // 42 - Customer services clerks
capture replace ilo_job1_ocu_isco08_2digits = 42 if isco_ilo ==  5020                     // 42 - Customer services clerks
capture replace ilo_job1_ocu_isco08_2digits = 42 if isco_ilo ==  5030                     // 42 - Customer services clerks
capture replace ilo_job1_ocu_isco08_2digits = 42 if isco_ilo ==  5100                     // 42 - Customer services clerks
capture replace ilo_job1_ocu_isco08_2digits = 42 if isco_ilo ==  5130                     // 42 - Customer services clerks
capture replace ilo_job1_ocu_isco08_2digits = 42 if isco_ilo ==  5160                     // 42 - Customer services clerks
capture replace ilo_job1_ocu_isco08_2digits = 42 if isco_ilo ==  5165                     // 42 - Customer services clerks
capture replace ilo_job1_ocu_isco08_2digits = 42 if isco_ilo ==  5210                     // 42 - Customer services clerks
capture replace ilo_job1_ocu_isco08_2digits = 42 if isco_ilo ==  5240                     // 42 - Customer services clerks
capture replace ilo_job1_ocu_isco08_2digits = 42 if isco_ilo ==  5300                     // 42 - Customer services clerks
capture replace ilo_job1_ocu_isco08_2digits = 42 if isco_ilo ==  5310                     // 42 - Customer services clerks
capture replace ilo_job1_ocu_isco08_2digits = 42 if isco_ilo ==  5400                     // 42 - Customer services clerks
capture replace ilo_job1_ocu_isco08_2digits = 42 if isco_ilo ==  5410                     // 42 - Customer services clerks
capture replace ilo_job1_ocu_isco08_2digits = 42 if isco_ilo ==  5420                     // 42 - Customer services clerks
capture replace ilo_job1_ocu_isco08_2digits = 42 if isco_ilo ==  5540                     // 42 - Customer services clerks
capture replace ilo_job1_ocu_isco08_2digits = 43 if isco_ilo ==  5110                     // 43 - Numerical and material recording clerks
capture replace ilo_job1_ocu_isco08_2digits = 43 if isco_ilo ==  5140                     // 43 - Numerical and material recording clerks
capture replace ilo_job1_ocu_isco08_2digits = 43 if isco_ilo ==  5200                     // 43 - Numerical and material recording clerks
capture replace ilo_job1_ocu_isco08_2digits = 43 if isco_ilo ==  5230                     // 43 - Numerical and material recording clerks
capture replace ilo_job1_ocu_isco08_2digits = 43 if isco_ilo ==  5330                     // 43 - Numerical and material recording clerks
capture replace ilo_job1_ocu_isco08_2digits = 43 if isco_ilo ==  5340                     // 43 - Numerical and material recording clerks
capture replace ilo_job1_ocu_isco08_2digits = 43 if isco_ilo ==  5600                     // 43 - Numerical and material recording clerks
capture replace ilo_job1_ocu_isco08_2digits = 43 if isco_ilo ==  5620                     // 43 - Numerical and material recording clerks
capture replace ilo_job1_ocu_isco08_2digits = 43 if isco_ilo ==  5630                     // 43 - Numerical and material recording clerks
capture replace ilo_job1_ocu_isco08_2digits = 43 if isco_ilo ==  5840                     // 43 - Numerical and material recording clerks
capture replace ilo_job1_ocu_isco08_2digits = 44 if isco_ilo ==  4610                     // 44 - Other clerical support workers
capture replace ilo_job1_ocu_isco08_2digits = 44 if isco_ilo ==  5260                     // 44 - Other clerical support workers
capture replace ilo_job1_ocu_isco08_2digits = 44 if isco_ilo ==  5320                     // 44 - Other clerical support workers
capture replace ilo_job1_ocu_isco08_2digits = 44 if isco_ilo ==  5350                     // 44 - Other clerical support workers
capture replace ilo_job1_ocu_isco08_2digits = 44 if isco_ilo ==  5360                     // 44 - Other clerical support workers
capture replace ilo_job1_ocu_isco08_2digits = 44 if isco_ilo ==  5510                     // 44 - Other clerical support workers
capture replace ilo_job1_ocu_isco08_2digits = 44 if isco_ilo ==  5550                     // 44 - Other clerical support workers
capture replace ilo_job1_ocu_isco08_2digits = 44 if isco_ilo ==  5560                     // 44 - Other clerical support workers
capture replace ilo_job1_ocu_isco08_2digits = 44 if isco_ilo ==  5850                     // 44 - Other clerical support workers
capture replace ilo_job1_ocu_isco08_2digits = 44 if isco_ilo ==  5900                     // 44 - Other clerical support workers
capture replace ilo_job1_ocu_isco08_2digits = 44 if isco_ilo ==  5910                     // 44 - Other clerical support workers
capture replace ilo_job1_ocu_isco08_2digits = 44 if isco_ilo ==  5940                     // 44 - Other clerical support workers
capture replace ilo_job1_ocu_isco08_2digits = 51 if isco_ilo ==  4020                     // 51 - Personal service workers
capture replace ilo_job1_ocu_isco08_2digits = 51 if isco_ilo ==  4040                     // 51 - Personal service workers
capture replace ilo_job1_ocu_isco08_2digits = 51 if isco_ilo ==  4110                     // 51 - Personal service workers
capture replace ilo_job1_ocu_isco08_2digits = 51 if isco_ilo ==  4120                     // 51 - Personal service workers
capture replace ilo_job1_ocu_isco08_2digits = 51 if isco_ilo ==  4150                     // 51 - Personal service workers
capture replace ilo_job1_ocu_isco08_2digits = 51 if isco_ilo ==  4200                     // 51 - Personal service workers
capture replace ilo_job1_ocu_isco08_2digits = 51 if isco_ilo ==  4220                     // 51 - Personal service workers
capture replace ilo_job1_ocu_isco08_2digits = 51 if isco_ilo ==  4340                     // 51 - Personal service workers
capture replace ilo_job1_ocu_isco08_2digits = 51 if isco_ilo ==  4350                     // 51 - Personal service workers
capture replace ilo_job1_ocu_isco08_2digits = 51 if isco_ilo ==  4460                     // 51 - Personal service workers
capture replace ilo_job1_ocu_isco08_2digits = 51 if isco_ilo ==  4465                     // 51 - Personal service workers
capture replace ilo_job1_ocu_isco08_2digits = 51 if isco_ilo ==  4500                     // 51 - Personal service workers
capture replace ilo_job1_ocu_isco08_2digits = 51 if isco_ilo ==  4510                     // 51 - Personal service workers
capture replace ilo_job1_ocu_isco08_2digits = 51 if isco_ilo ==  4520                     // 51 - Personal service workers
capture replace ilo_job1_ocu_isco08_2digits = 51 if isco_ilo ==  4540                     // 51 - Personal service workers
capture replace ilo_job1_ocu_isco08_2digits = 51 if isco_ilo ==  4640                     // 51 - Personal service workers
capture replace ilo_job1_ocu_isco08_2digits = 51 if isco_ilo ==  4650                     // 51 - Personal service workers
capture replace ilo_job1_ocu_isco08_2digits = 51 if isco_ilo ==  9050                     // 51 - Personal service workers
capture replace ilo_job1_ocu_isco08_2digits = 51 if isco_ilo ==  9415                     // 51 - Personal service workers
capture replace ilo_job1_ocu_isco08_2digits = 52 if isco_ilo ==  4050                     // 52 - Sales workers
capture replace ilo_job1_ocu_isco08_2digits = 52 if isco_ilo ==  4060                     // 52 - Sales workers
capture replace ilo_job1_ocu_isco08_2digits = 52 if isco_ilo ==  4130                     // 52 - Sales workers
capture replace ilo_job1_ocu_isco08_2digits = 52 if isco_ilo ==  4700                     // 52 - Sales workers
capture replace ilo_job1_ocu_isco08_2digits = 52 if isco_ilo ==  4720                     // 52 - Sales workers
capture replace ilo_job1_ocu_isco08_2digits = 52 if isco_ilo ==  4740                     // 52 - Sales workers
capture replace ilo_job1_ocu_isco08_2digits = 52 if isco_ilo ==  4750                     // 52 - Sales workers
capture replace ilo_job1_ocu_isco08_2digits = 52 if isco_ilo ==  4760                     // 52 - Sales workers
capture replace ilo_job1_ocu_isco08_2digits = 52 if isco_ilo ==  4900                     // 52 - Sales workers
capture replace ilo_job1_ocu_isco08_2digits = 52 if isco_ilo ==  4940                     // 52 - Sales workers
capture replace ilo_job1_ocu_isco08_2digits = 52 if isco_ilo ==  4950                     // 52 - Sales workers
capture replace ilo_job1_ocu_isco08_2digits = 52 if isco_ilo ==  9360                     // 52 - Sales workers
capture replace ilo_job1_ocu_isco08_2digits = 53 if isco_ilo ==  2540                     // 53 - Personal care workers
capture replace ilo_job1_ocu_isco08_2digits = 53 if isco_ilo ==  3600                     // 53 - Personal care workers
capture replace ilo_job1_ocu_isco08_2digits = 53 if isco_ilo ==  3647                     // 53 - Personal care workers
capture replace ilo_job1_ocu_isco08_2digits = 53 if isco_ilo ==  3649                     // 53 - Personal care workers
capture replace ilo_job1_ocu_isco08_2digits = 53 if isco_ilo ==  4600                     // 53 - Personal care workers
capture replace ilo_job1_ocu_isco08_2digits = 54 if isco_ilo ==  3700                     // 54 - Protective services workers
capture replace ilo_job1_ocu_isco08_2digits = 54 if isco_ilo ==  3730                     // 54 - Protective services workers
capture replace ilo_job1_ocu_isco08_2digits = 54 if isco_ilo ==  3740                     // 54 - Protective services workers
capture replace ilo_job1_ocu_isco08_2digits = 54 if isco_ilo ==  3830                     // 54 - Protective services workers
capture replace ilo_job1_ocu_isco08_2digits = 54 if isco_ilo ==  3840                     // 54 - Protective services workers
capture replace ilo_job1_ocu_isco08_2digits = 54 if isco_ilo ==  3860                     // 54 - Protective services workers
capture replace ilo_job1_ocu_isco08_2digits = 54 if isco_ilo ==  3900                     // 54 - Protective services workers
capture replace ilo_job1_ocu_isco08_2digits = 54 if isco_ilo ==  3930                     // 54 - Protective services workers
capture replace ilo_job1_ocu_isco08_2digits = 54 if isco_ilo ==  3940                     // 54 - Protective services workers
capture replace ilo_job1_ocu_isco08_2digits = 54 if isco_ilo ==  3945                     // 54 - Protective services workers
capture replace ilo_job1_ocu_isco08_2digits = 54 if isco_ilo ==  3955                     // 54 - Protective services workers
capture replace ilo_job1_ocu_isco08_2digits = 54 if isco_ilo ==  5520                     // 54 - Protective services workers
capture replace ilo_job1_ocu_isco08_2digits = 61 if isco_ilo ==  4210                     // 61 - Market-oriented skilled agricultural workers
capture replace ilo_job1_ocu_isco08_2digits = 61 if isco_ilo ==  6005                     // 61 - Market-oriented skilled agricultural workers
capture replace ilo_job1_ocu_isco08_2digits = 61 if isco_ilo ==  6020                     // 61 - Market-oriented skilled agricultural workers
capture replace ilo_job1_ocu_isco08_2digits = 62 if isco_ilo ==  6100                     // 62 - Market-oriented skilled forestry, fishery and hunting workers
capture replace ilo_job1_ocu_isco08_2digits = 62 if isco_ilo ==  6110                     // 62 - Market-oriented skilled forestry, fishery and hunting workers
capture replace ilo_job1_ocu_isco08_2digits = 62 if isco_ilo ==  6120                     // 62 - Market-oriented skilled forestry, fishery and hunting workers
capture replace ilo_job1_ocu_isco08_2digits = 62 if isco_ilo ==  6130                     // 62 - Market-oriented skilled forestry, fishery and hunting workers
capture replace ilo_job1_ocu_isco08_2digits = 71 if isco_ilo ==  6220                     // 71 - Building and related trades workers, excluding electricians
capture replace ilo_job1_ocu_isco08_2digits = 71 if isco_ilo ==  6230                     // 71 - Building and related trades workers, excluding electricians
capture replace ilo_job1_ocu_isco08_2digits = 71 if isco_ilo ==  6240                     // 71 - Building and related trades workers, excluding electricians
capture replace ilo_job1_ocu_isco08_2digits = 71 if isco_ilo ==  6250                     // 71 - Building and related trades workers, excluding electricians
capture replace ilo_job1_ocu_isco08_2digits = 71 if isco_ilo ==  6330                     // 71 - Building and related trades workers, excluding electricians
capture replace ilo_job1_ocu_isco08_2digits = 71 if isco_ilo ==  6360                     // 71 - Building and related trades workers, excluding electricians
capture replace ilo_job1_ocu_isco08_2digits = 71 if isco_ilo ==  6400                     // 71 - Building and related trades workers, excluding electricians
capture replace ilo_job1_ocu_isco08_2digits = 71 if isco_ilo ==  6420                     // 71 - Building and related trades workers, excluding electricians
capture replace ilo_job1_ocu_isco08_2digits = 71 if isco_ilo ==  6430                     // 71 - Building and related trades workers, excluding electricians
capture replace ilo_job1_ocu_isco08_2digits = 71 if isco_ilo ==  6440                     // 71 - Building and related trades workers, excluding electricians
capture replace ilo_job1_ocu_isco08_2digits = 71 if isco_ilo ==  6460                     // 71 - Building and related trades workers, excluding electricians
capture replace ilo_job1_ocu_isco08_2digits = 71 if isco_ilo ==  6515                     // 71 - Building and related trades workers, excluding electricians
capture replace ilo_job1_ocu_isco08_2digits = 71 if isco_ilo ==  6540                     // 71 - Building and related trades workers, excluding electricians
capture replace ilo_job1_ocu_isco08_2digits = 71 if isco_ilo ==  6710                     // 71 - Building and related trades workers, excluding electricians
capture replace ilo_job1_ocu_isco08_2digits = 71 if isco_ilo ==  6720                     // 71 - Building and related trades workers, excluding electricians
capture replace ilo_job1_ocu_isco08_2digits = 71 if isco_ilo ==  6765                     // 71 - Building and related trades workers, excluding electricians
capture replace ilo_job1_ocu_isco08_2digits = 71 if isco_ilo ==  7000                     // 71 - Building and related trades workers, excluding electricians
capture replace ilo_job1_ocu_isco08_2digits = 71 if isco_ilo ==  7315                     // 71 - Building and related trades workers, excluding electricians
capture replace ilo_job1_ocu_isco08_2digits = 71 if isco_ilo ==  7550                     // 71 - Building and related trades workers, excluding electricians
capture replace ilo_job1_ocu_isco08_2digits = 71 if isco_ilo ==  8810                     // 71 - Building and related trades workers, excluding electricians
capture replace ilo_job1_ocu_isco08_2digits = 72 if isco_ilo ==  6210                     // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if isco_ilo ==  6500                     // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if isco_ilo ==  6520                     // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if isco_ilo ==  6530                     // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if isco_ilo ==  7140                     // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if isco_ilo ==  7150                     // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if isco_ilo ==  7160                     // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if isco_ilo ==  7200                     // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if isco_ilo ==  7210                     // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if isco_ilo ==  7220                     // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if isco_ilo ==  7240                     // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if isco_ilo ==  7260                     // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if isco_ilo ==  7330                     // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if isco_ilo ==  7350                     // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if isco_ilo ==  7360                     // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if isco_ilo ==  7440                     // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if isco_ilo ==  7540                     // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if isco_ilo ==  7560                     // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if isco_ilo ==  7740                     // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if isco_ilo ==  7900                     // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if isco_ilo ==  7920                     // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if isco_ilo ==  7930                     // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if isco_ilo ==  7940                     // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if isco_ilo ==  7950                     // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if isco_ilo ==  7960                     // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if isco_ilo ==  8000                     // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if isco_ilo ==  8010                     // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if isco_ilo ==  8020                     // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if isco_ilo ==  8030                     // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if isco_ilo ==  8060                     // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if isco_ilo ==  8100                     // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if isco_ilo ==  8120                     // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if isco_ilo ==  8130                     // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if isco_ilo ==  8140                     // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if isco_ilo ==  8160                     // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if isco_ilo ==  8210                     // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if isco_ilo ==  8220                     // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 73 if isco_ilo ==  5830                     // 73 - Handicraft and printing workers
capture replace ilo_job1_ocu_isco08_2digits = 73 if isco_ilo ==  7430                     // 73 - Handicraft and printing workers
capture replace ilo_job1_ocu_isco08_2digits = 73 if isco_ilo ==  8250                     // 73 - Handicraft and printing workers
capture replace ilo_job1_ocu_isco08_2digits = 73 if isco_ilo ==  8255                     // 73 - Handicraft and printing workers
capture replace ilo_job1_ocu_isco08_2digits = 73 if isco_ilo ==  8256                     // 73 - Handicraft and printing workers
capture replace ilo_job1_ocu_isco08_2digits = 73 if isco_ilo ==  8330                     // 73 - Handicraft and printing workers
capture replace ilo_job1_ocu_isco08_2digits = 73 if isco_ilo ==  8550                     // 73 - Handicraft and printing workers
capture replace ilo_job1_ocu_isco08_2digits = 73 if isco_ilo ==  8710                     // 73 - Handicraft and printing workers
capture replace ilo_job1_ocu_isco08_2digits = 73 if isco_ilo ==  8750                     // 73 - Handicraft and printing workers
capture replace ilo_job1_ocu_isco08_2digits = 73 if isco_ilo ==  8910                     // 73 - Handicraft and printing workers
capture replace ilo_job1_ocu_isco08_2digits = 73 if isco_ilo ==  8920                     // 73 - Handicraft and printing workers
capture replace ilo_job1_ocu_isco08_2digits = 74 if isco_ilo ==  6355                     // 74 - Electrical and electronic trades workers
capture replace ilo_job1_ocu_isco08_2digits = 74 if isco_ilo ==  6700                     // 74 - Electrical and electronic trades workers
capture replace ilo_job1_ocu_isco08_2digits = 74 if isco_ilo ==  7010                     // 74 - Electrical and electronic trades workers
capture replace ilo_job1_ocu_isco08_2digits = 74 if isco_ilo ==  7020                     // 74 - Electrical and electronic trades workers
capture replace ilo_job1_ocu_isco08_2digits = 74 if isco_ilo ==  7030                     // 74 - Electrical and electronic trades workers
capture replace ilo_job1_ocu_isco08_2digits = 74 if isco_ilo ==  7040                     // 74 - Electrical and electronic trades workers
capture replace ilo_job1_ocu_isco08_2digits = 74 if isco_ilo ==  7050                     // 74 - Electrical and electronic trades workers
capture replace ilo_job1_ocu_isco08_2digits = 74 if isco_ilo ==  7100                     // 74 - Electrical and electronic trades workers
capture replace ilo_job1_ocu_isco08_2digits = 74 if isco_ilo ==  7110                     // 74 - Electrical and electronic trades workers
capture replace ilo_job1_ocu_isco08_2digits = 74 if isco_ilo ==  7120                     // 74 - Electrical and electronic trades workers
capture replace ilo_job1_ocu_isco08_2digits = 74 if isco_ilo ==  7130                     // 74 - Electrical and electronic trades workers
capture replace ilo_job1_ocu_isco08_2digits = 74 if isco_ilo ==  7300                     // 74 - Electrical and electronic trades workers
capture replace ilo_job1_ocu_isco08_2digits = 74 if isco_ilo ==  7320                     // 74 - Electrical and electronic trades workers
capture replace ilo_job1_ocu_isco08_2digits = 74 if isco_ilo ==  7410                     // 74 - Electrical and electronic trades workers
capture replace ilo_job1_ocu_isco08_2digits = 74 if isco_ilo ==  7420                     // 74 - Electrical and electronic trades workers
capture replace ilo_job1_ocu_isco08_2digits = 74 if isco_ilo ==  7600                     // 74 - Electrical and electronic trades workers
capture replace ilo_job1_ocu_isco08_2digits = 75 if isco_ilo ==  4240                     // 75 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 75 if isco_ilo ==  6040                     // 75 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 75 if isco_ilo ==  6830                     // 75 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 75 if isco_ilo ==  7520                     // 75 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 75 if isco_ilo ==  7800                     // 75 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 75 if isco_ilo ==  7810                     // 75 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 75 if isco_ilo ==  7830                     // 75 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 75 if isco_ilo ==  7840                     // 75 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 75 if isco_ilo ==  7850                     // 75 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 75 if isco_ilo ==  7855                     // 75 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 75 if isco_ilo ==  8350                     // 75 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 75 if isco_ilo ==  8400                     // 75 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 75 if isco_ilo ==  8440                     // 75 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 75 if isco_ilo ==  8450                     // 75 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 75 if isco_ilo ==  8460                     // 75 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 75 if isco_ilo ==  8500                     // 75 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 75 if isco_ilo ==  8510                     // 75 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 75 if isco_ilo ==  8520                     // 75 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 75 if isco_ilo ==  8540                     // 75 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 75 if isco_ilo ==  8720                     // 75 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 75 if isco_ilo ==  8730                     // 75 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 75 if isco_ilo ==  8740                     // 75 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 75 if isco_ilo ==  8850                     // 75 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 81 if isco_ilo ==  6800                     // 81 - Stationary plant and machine operators
capture replace ilo_job1_ocu_isco08_2digits = 81 if isco_ilo ==  6820                     // 81 - Stationary plant and machine operators
capture replace ilo_job1_ocu_isco08_2digits = 81 if isco_ilo ==  6840                     // 81 - Stationary plant and machine operators
capture replace ilo_job1_ocu_isco08_2digits = 81 if isco_ilo ==  6910                     // 81 - Stationary plant and machine operators
capture replace ilo_job1_ocu_isco08_2digits = 81 if isco_ilo ==  6920                     // 81 - Stationary plant and machine operators
capture replace ilo_job1_ocu_isco08_2digits = 81 if isco_ilo ==  8150                     // 81 - Stationary plant and machine operators
capture replace ilo_job1_ocu_isco08_2digits = 81 if isco_ilo ==  8200                     // 81 - Stationary plant and machine operators
capture replace ilo_job1_ocu_isco08_2digits = 81 if isco_ilo ==  8300                     // 81 - Stationary plant and machine operators
capture replace ilo_job1_ocu_isco08_2digits = 81 if isco_ilo ==  8320                     // 81 - Stationary plant and machine operators
capture replace ilo_job1_ocu_isco08_2digits = 81 if isco_ilo ==  8340                     // 81 - Stationary plant and machine operators
capture replace ilo_job1_ocu_isco08_2digits = 81 if isco_ilo ==  8360                     // 81 - Stationary plant and machine operators
capture replace ilo_job1_ocu_isco08_2digits = 81 if isco_ilo ==  8410                     // 81 - Stationary plant and machine operators
capture replace ilo_job1_ocu_isco08_2digits = 81 if isco_ilo ==  8420                     // 81 - Stationary plant and machine operators
capture replace ilo_job1_ocu_isco08_2digits = 81 if isco_ilo ==  8430                     // 81 - Stationary plant and machine operators
capture replace ilo_job1_ocu_isco08_2digits = 81 if isco_ilo ==  8530                     // 81 - Stationary plant and machine operators
capture replace ilo_job1_ocu_isco08_2digits = 81 if isco_ilo ==  8610                     // 81 - Stationary plant and machine operators
capture replace ilo_job1_ocu_isco08_2digits = 81 if isco_ilo ==  8640                     // 81 - Stationary plant and machine operators
capture replace ilo_job1_ocu_isco08_2digits = 81 if isco_ilo ==  8650                     // 81 - Stationary plant and machine operators
capture replace ilo_job1_ocu_isco08_2digits = 81 if isco_ilo ==  8800                     // 81 - Stationary plant and machine operators
capture replace ilo_job1_ocu_isco08_2digits = 81 if isco_ilo ==  8830                     // 81 - Stationary plant and machine operators
capture replace ilo_job1_ocu_isco08_2digits = 81 if isco_ilo ==  8840                     // 81 - Stationary plant and machine operators
capture replace ilo_job1_ocu_isco08_2digits = 81 if isco_ilo ==  8860                     // 81 - Stationary plant and machine operators
capture replace ilo_job1_ocu_isco08_2digits = 81 if isco_ilo ==  8900                     // 81 - Stationary plant and machine operators
capture replace ilo_job1_ocu_isco08_2digits = 81 if isco_ilo ==  8930                     // 81 - Stationary plant and machine operators
capture replace ilo_job1_ocu_isco08_2digits = 81 if isco_ilo ==  8940                     // 81 - Stationary plant and machine operators
capture replace ilo_job1_ocu_isco08_2digits = 81 if isco_ilo ==  9500                     // 81 - Stationary plant and machine operators
capture replace ilo_job1_ocu_isco08_2digits = 82 if isco_ilo ==  7710                     // 82 - Assemblers
capture replace ilo_job1_ocu_isco08_2digits = 82 if isco_ilo ==  7720                     // 82 - Assemblers
capture replace ilo_job1_ocu_isco08_2digits = 82 if isco_ilo ==  7730                     // 82 - Assemblers
capture replace ilo_job1_ocu_isco08_2digits = 82 if isco_ilo ==  7750                     // 82 - Assemblers
capture replace ilo_job1_ocu_isco08_2digits = 83 if isco_ilo ==  6300                     // 83 - Drivers and mobile plant operators
capture replace ilo_job1_ocu_isco08_2digits = 83 if isco_ilo ==  6310                     // 83 - Drivers and mobile plant operators
capture replace ilo_job1_ocu_isco08_2digits = 83 if isco_ilo ==  6320                     // 83 - Drivers and mobile plant operators
capture replace ilo_job1_ocu_isco08_2digits = 83 if isco_ilo ==  9110                     // 83 - Drivers and mobile plant operators
capture replace ilo_job1_ocu_isco08_2digits = 83 if isco_ilo ==  9120                     // 83 - Drivers and mobile plant operators
capture replace ilo_job1_ocu_isco08_2digits = 83 if isco_ilo ==  9130                     // 83 - Drivers and mobile plant operators
capture replace ilo_job1_ocu_isco08_2digits = 83 if isco_ilo ==  9140                     // 83 - Drivers and mobile plant operators
capture replace ilo_job1_ocu_isco08_2digits = 83 if isco_ilo ==  9150                     // 83 - Drivers and mobile plant operators
capture replace ilo_job1_ocu_isco08_2digits = 83 if isco_ilo ==  9200                     // 83 - Drivers and mobile plant operators
capture replace ilo_job1_ocu_isco08_2digits = 83 if isco_ilo ==  9230                     // 83 - Drivers and mobile plant operators
capture replace ilo_job1_ocu_isco08_2digits = 83 if isco_ilo ==  9240                     // 83 - Drivers and mobile plant operators
capture replace ilo_job1_ocu_isco08_2digits = 83 if isco_ilo ==  9260                     // 83 - Drivers and mobile plant operators
capture replace ilo_job1_ocu_isco08_2digits = 83 if isco_ilo ==  9300                     // 83 - Drivers and mobile plant operators
capture replace ilo_job1_ocu_isco08_2digits = 83 if isco_ilo ==  9340                     // 83 - Drivers and mobile plant operators
capture replace ilo_job1_ocu_isco08_2digits = 83 if isco_ilo ==  9510                     // 83 - Drivers and mobile plant operators
capture replace ilo_job1_ocu_isco08_2digits = 83 if isco_ilo ==  9520                     // 83 - Drivers and mobile plant operators
capture replace ilo_job1_ocu_isco08_2digits = 83 if isco_ilo ==  9560                     // 83 - Drivers and mobile plant operators
capture replace ilo_job1_ocu_isco08_2digits = 83 if isco_ilo ==  9600                     // 83 - Drivers and mobile plant operators
capture replace ilo_job1_ocu_isco08_2digits = 83 if isco_ilo ==  9730                     // 83 - Drivers and mobile plant operators
capture replace ilo_job1_ocu_isco08_2digits = 91 if isco_ilo ==  4230                     // 91 - Cleaners and helpers
capture replace ilo_job1_ocu_isco08_2digits = 91 if isco_ilo ==  6750                     // 91 - Cleaners and helpers
capture replace ilo_job1_ocu_isco08_2digits = 91 if isco_ilo ==  8310                     // 91 - Cleaners and helpers
capture replace ilo_job1_ocu_isco08_2digits = 91 if isco_ilo ==  9610                     // 91 - Cleaners and helpers
capture replace ilo_job1_ocu_isco08_2digits = 92 if isco_ilo ==  4250                     // 92 - Agricultural, forestry and fishery labourers
capture replace ilo_job1_ocu_isco08_2digits = 92 if isco_ilo ==  6050                     // 92 - Agricultural, forestry and fishery labourers
capture replace ilo_job1_ocu_isco08_2digits = 93 if isco_ilo ==  6260                     // 93 - Labourers in mining, construction, manufacturing and transport
capture replace ilo_job1_ocu_isco08_2digits = 93 if isco_ilo ==  6600                     // 93 - Labourers in mining, construction, manufacturing and transport
capture replace ilo_job1_ocu_isco08_2digits = 93 if isco_ilo ==  6730                     // 93 - Labourers in mining, construction, manufacturing and transport
capture replace ilo_job1_ocu_isco08_2digits = 93 if isco_ilo ==  6740                     // 93 - Labourers in mining, construction, manufacturing and transport
capture replace ilo_job1_ocu_isco08_2digits = 93 if isco_ilo ==  6930                     // 93 - Labourers in mining, construction, manufacturing and transport
capture replace ilo_job1_ocu_isco08_2digits = 93 if isco_ilo ==  6940                     // 93 - Labourers in mining, construction, manufacturing and transport
capture replace ilo_job1_ocu_isco08_2digits = 93 if isco_ilo ==  8950                     // 93 - Labourers in mining, construction, manufacturing and transport
capture replace ilo_job1_ocu_isco08_2digits = 93 if isco_ilo ==  8965                     // 93 - Labourers in mining, construction, manufacturing and transport
capture replace ilo_job1_ocu_isco08_2digits = 93 if isco_ilo ==  9000                     // 93 - Labourers in mining, construction, manufacturing and transport
capture replace ilo_job1_ocu_isco08_2digits = 93 if isco_ilo ==  9420                     // 93 - Labourers in mining, construction, manufacturing and transport
capture replace ilo_job1_ocu_isco08_2digits = 93 if isco_ilo ==  9620                     // 93 - Labourers in mining, construction, manufacturing and transport
capture replace ilo_job1_ocu_isco08_2digits = 93 if isco_ilo ==  9630                     // 93 - Labourers in mining, construction, manufacturing and transport
capture replace ilo_job1_ocu_isco08_2digits = 93 if isco_ilo ==  9640                     // 93 - Labourers in mining, construction, manufacturing and transport
capture replace ilo_job1_ocu_isco08_2digits = 93 if isco_ilo ==  9740                     // 93 - Labourers in mining, construction, manufacturing and transport
capture replace ilo_job1_ocu_isco08_2digits = 93 if isco_ilo ==  9750                     // 93 - Labourers in mining, construction, manufacturing and transport
capture replace ilo_job1_ocu_isco08_2digits = 94 if isco_ilo ==  4030                     // 94 - Food preparation assistants
capture replace ilo_job1_ocu_isco08_2digits = 94 if isco_ilo ==  4140                     // 94 - Food preparation assistants
capture replace ilo_job1_ocu_isco08_2digits = 94 if isco_ilo ==  4160                     // 94 - Food preparation assistants
capture replace ilo_job1_ocu_isco08_2digits = 96 if isco_ilo ==  4410                     // 96 - Refuse workers and other elementary workers
capture replace ilo_job1_ocu_isco08_2digits = 96 if isco_ilo ==  4420                     // 96 - Refuse workers and other elementary workers
capture replace ilo_job1_ocu_isco08_2digits = 96 if isco_ilo ==  4530                     // 96 - Refuse workers and other elementary workers
capture replace ilo_job1_ocu_isco08_2digits = 96 if isco_ilo ==  5530                     // 96 - Refuse workers and other elementary workers
capture replace ilo_job1_ocu_isco08_2digits = 96 if isco_ilo ==  7340                     // 96 - Refuse workers and other elementary workers
capture replace ilo_job1_ocu_isco08_2digits = 96 if isco_ilo ==  7510                     // 96 - Refuse workers and other elementary workers
capture replace ilo_job1_ocu_isco08_2digits = 96 if isco_ilo ==  7610                     // 96 - Refuse workers and other elementary workers
capture replace ilo_job1_ocu_isco08_2digits = 96 if isco_ilo ==  7630                     // 96 - Refuse workers and other elementary workers
capture replace ilo_job1_ocu_isco08_2digits = 96 if isco_ilo ==  9350                     // 96 - Refuse workers and other elementary workers
capture replace ilo_job1_ocu_isco08_2digits = 96 if isco_ilo ==  9720                     // 96 - Refuse workers and other elementary workers

	
	lab var ilo_job1_ocu_isco08_2digits "Occupation (ISCO-08), 2 digit level"
	
	
	* 1 digit level
	gen ilo_job1_ocu_isco08 = int(ilo_job1_ocu_isco08_2digits/10)
		lab def ocu_isco08_2digits 1 "01 - Commissioned armed forces officers" 2 "02 - Non-commissioned armed forces officers" 3 "03 - Armed forces occupations, other ranks" /// 
			11 "11 - Chief executives, senior officials and legislators" 12 "12 - Administrative and commercial managers" 13 "13 - Production and specialised services managers" /// 
			14 "14 - Hospitality, retail and other services managers" 21 "21 - Science and engineering professionals" 22 "22 - Health professionals" 23 "23 - Teaching professionals" /// 
			24 "24 - Business and administration professionals" 25 "25 - Information and communications technology professionals" 26 "26 - Legal, social and cultural professionals" /// 
			31 "31 - Science and engineering associate professionals" 32 "32 - Health associate professionals" 33 "33 - Business and administration associate professionals" /// 
			34 "34 - Legal, social, cultural and related associate professionals" 35 "35 - Information and communications technicians" 41 "41 - General and keyboard clerks" 42 "42 - Customer services clerks" /// 
			43 "43 - Numerical and material recording clerks" 44 "44 - Other clerical support workers" 51 "51 - Personal service workers" 52 "52 - Sales workers" 53 "53 - Personal care workers" /// 
			54 "54 - Protective services workers" 61 "61 - Market-oriented skilled agricultural workers" 62 "62 - Market-oriented skilled forestry, fishery and hunting workers" /// 
			63 "63 - Subsistence farmers, fishers, hunters and gatherers" 71 "71 - Building and related trades workers, excluding electricians" 72 "72 - Metal, machinery and related trades workers" /// 
			73 "73 - Handicraft and printing workers" 74 "74 - Electrical and electronic trades workers" 75 "75 - Food processing, wood working, garment and other craft and related trades workers" /// 
			81 "81 - Stationary plant and machine operators" 82 "82 - Assemblers" 83 "83 - Drivers and mobile plant operators" 91 "91 - Cleaners and helpers" 92 "92 - Agricultural, forestry and fishery labourers" /// 
			93 "93 - Labourers in mining, construction, manufacturing and transport" 94 "94 - Food preparation assistants" 95 "95 - Street and related sales and service workers" /// 
			96 "96 - Refuse workers and other elementary workers"

	lab val ilo_job1_ocu_isco08_2digits ocu_isco08_2digits
	
	
	replace ilo_job1_ocu_isco08=10 if ilo_job1_ocu_isco08==0 
	replace ilo_job1_ocu_isco08=11 if ilo_job1_ocu_isco08_2digits == 99 
	replace ilo_job1_ocu_isco08=11 if !inrange(ilo_job1_ocu_isco08, 1, 11) 
				lab def ocu_isco08_lab 1 "1 - Managers" 2 "2 - Professionals" 3 "3 - Technicians and associate professionals" 4 "4 - Clerical support workers" 5 "5 - Service and sales workers" /// 
							6 "6 - Skilled agricultural, forestry and fishery workers" 7 "7 - Craft and related trades workers" 8 "8 - Plant and machine operators, and assemblers" 9 "9 - Elementary occupations" /// 
							10 "0 - Armed forces occupations" 11 "X - Not elsewhere classified"
				lab val ilo_job1_ocu_isco08 ocu_isco08_lab
				lab var ilo_job1_ocu_isco08 "Occupation (ISCO-08)"	
	
	  * Aggregate
	  gen ilo_job1_ocu_aggregate=.
		  replace ilo_job1_ocu_aggregate=1 if inrange(ilo_job1_ocu_isco08,1,3)  // 1 - Managers, professionals, and technicians
		  replace ilo_job1_ocu_aggregate=2 if inlist(ilo_job1_ocu_isco08,4,5)	// 2 - Clerical, service and sales workers
		  replace ilo_job1_ocu_aggregate=3 if inlist(ilo_job1_ocu_isco08,6,7)	// 3 - Skilled agricultural and trades workers
		  replace ilo_job1_ocu_aggregate=4 if ilo_job1_ocu_isco08==8			// 4 - Plant and machine operators, and assemblers
		  replace ilo_job1_ocu_aggregate=5 if ilo_job1_ocu_isco08==9			// 5 - Elementary occupations
		  replace ilo_job1_ocu_aggregate=6 if ilo_job1_ocu_isco08==10			// 6 - Armed forces
		  replace ilo_job1_ocu_aggregate=7 if ilo_job1_ocu_isco08==11			// 7 - Not elsewhere classified
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

		* test if var is should be drop 	
		egen drop_var = mean(ilo_job1_ocu_aggregate)
		local Z = drop_var in 1
		if `Z' == 7 {
			drop ilo_job1_ocu_aggregate ilo_job1_ocu_isco08 ilo_job1_ocu_skill	ilo_job1_ocu_isco08_2digits
		}
		drop 	drop_var
		
	 * tab  ilo_job1_ocu_isco08 [iw = ilo_wgt] if ilo_lfs == 1, m

	drop isco_ilo			  


				  
				  
		  
				  
			  
				  
				  
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_job1_ins_sector')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

* PRCOW1 CLASS OF WORKER RECODE - JOB 1


		
		gen ilo_job1_ins_sector=.
			replace ilo_job1_ins_sector=1 if inrange(PRCOW1,1,3) & ilo_lfs == 1		// Public
			replace ilo_job1_ins_sector=2 if ilo_job1_ins_sector != 1 & ilo_lfs==1	// Private
				lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
			    lab values ilo_job1_ins_sector ins_sector_lab
			    lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities"
		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job1_job_time')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			

* PRFTLF FULL TIME LABOR FORCE (2	PART TIME LABOR FORCE)

		gen ilo_job1_job_time=.
		replace ilo_job1_job_time=1 if PRFTLF == 2								// 1 - Part-time
		replace ilo_job1_job_time=2 if PRFTLF == 1								// 2 - Full-time
		replace ilo_job1_job_time=3 if (ilo_job1_job_time==. & ilo_lfs==1)		// 3 - Unknown
			lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknow"
			    lab values ilo_job1_job_time job_time_lab
			    lab var ilo_job1_job_time "Job (Working time arrangement)"
 
		* test if var is should be drop 	
		egen drop_var = mean(ilo_job1_job_time)
		local Z = drop_var in 1
		if `Z' == 3 {
			drop ilo_job1_job_time
		}
		drop 	drop_var
	* tab  ilo_job1_job_time [iw = ilo_wgt] if ilo_lfs == 1, m

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Hours of work ('ilo_job1_how')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	


****************************** actual hours of work

* PEHRACT1 LAST WEEK, HOW MANY HOURS DID YOU ACTUALLY WORK AT YOUR JOB?

lab def how_act_bands_lab 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"

   * ilo_job1_how_actual
   
		gen ilo_job1_how_actual=PEHRACT1 if ilo_lfs==1
				lab var ilo_job1_how_actual "Weekly hours actually worked in main job"	      
		
		gen ilo_job1_how_actual_bands=.
			 replace ilo_job1_how_actual_bands=1 if ilo_job1_how_actual==0				// No hours actually worked
			 replace ilo_job1_how_actual_bands=2 if inrange(ilo_job1_how_actual,1,14)	// 01-14
			 replace ilo_job1_how_actual_bands=3 if inrange(ilo_job1_how_actual,15,29)	// 15-29
			 replace ilo_job1_how_actual_bands=4 if inrange(ilo_job1_how_actual,30,34)	// 30-34
			 replace ilo_job1_how_actual_bands=5 if inrange(ilo_job1_how_actual,35,39)	// 35-39
			 replace ilo_job1_how_actual_bands=6 if inrange(ilo_job1_how_actual,40,48)	// 40-48
			 replace ilo_job1_how_actual_bands=7 if ilo_job1_how_actual>=49 & ilo_job1_how_actual !=. // 49+
			 replace ilo_job1_how_actual_bands=8 if ilo_job1_how_actual_bands == .		// Not elsewhere classified
					lab val ilo_job1_how_actual_bands how_act_bands_lab
					lab var ilo_job1_how_actual_bands "Bands of weekly hours actually worked in main job" 

		* test if var is should be drop 	
		egen drop_var = mean(ilo_job1_how_actual_bands)
		local Z = drop_var in 1
		if `Z' == 8 {
			drop ilo_job1_how_actual_bands
		}
		drop 	drop_var		
	* tab  ilo_job1_how_actual_bands [iw = ilo_wgt] if ilo_lfs == 1, m

* PEHRACTT SUM OF PEHRACT1 AND PEHRACT2 (LAST WEEK, HOW MANY HOURS DID YOU ACTUALLY WORK AT YOUR OTHER (JOB/JOBS)).

		gen ilo_joball_how_actual = PEHRACTT  if ilo_lfs==1
				lab var ilo_joball_how_actual "Weekly hours actually worked in all jobs"	      

		gen ilo_joball_how_actual_bands=.
			 replace ilo_joball_how_actual_bands=1 if ilo_joball_how_actual==0
			 replace ilo_joball_how_actual_bands=2 if inrange(ilo_joball_how_actual,1,14)
			 replace ilo_joball_how_actual_bands=3 if inrange(ilo_joball_how_actual,15,29)
			 replace ilo_joball_how_actual_bands=4 if inrange(ilo_joball_how_actual,30,34)
			 replace ilo_joball_how_actual_bands=5 if inrange(ilo_joball_how_actual,35,39)
			 replace ilo_joball_how_actual_bands=6 if inrange(ilo_joball_how_actual,40,48)
			 replace ilo_joball_how_actual_bands=7 if ilo_joball_how_actual_bands>=49  & ilo_job1_how_actual !=.
			 replace ilo_joball_how_actual_bands=8 if ilo_joball_how_actual_bands == .
				    lab val ilo_joball_how_actual_bands how_act_bands_lab
					lab var ilo_joball_how_actual_bands "Weekly hours actually worked bands in all jobs"
	

		* test if var is should be drop 	
		egen drop_var = mean(ilo_joball_how_actual_bands)
		local Z = drop_var in 1
		if `Z' == 8 {
			drop ilo_joball_how_actual_bands
		}
		drop 	drop_var
		
	* tab  ilo_joball_how_actual_bands [iw = ilo_wgt] if ilo_lfs == 1, m

		
	

****************************** usual hours of work


* PEHRUSL1 HOW MANY HOURS PER WEEK DO YOU USUALLY WORK AT YOUR MAIN JOB? exclusion of -4 HOURS VARY
* PEHRUSL2 HOW MANY HOURS PER WEEK DO YOU USUALLY WORK AT YOUR OTHER (JOB/JOBS)?? exclusion of -4 HOURS VARY
		
		gen ilo_joball_how_usual = .
		replace ilo_joball_how_usual = 0 if ilo_lfs == 1
		replace ilo_joball_how_usual = PEHRUSL1 if PEHRUSL1 != -4 & PEHRUSL1 !=.  & ilo_lfs==1
		replace ilo_joball_how_usual = ilo_joball_how_usual + PEHRUSL2 if PEHRUSL2 != -4 & PEHRUSL2 !=.  & ilo_lfs==1
		
				lab var ilo_joball_how_usual "Weekly hours usually worked in all jobs"	      

		
	
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job1_job_contract')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

* Comment: var ???

		
		
	* tab  ilo_job1_job_contract [iw = ilo_wgt] if ilo_lfs == 1, m

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Formal / Informal Economy ('ilo_job1_ife_prod' 'ilo_job1_ife_nature')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			

* Comment: 	
	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Monthly labour related income ('ilo_joball_lri')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
	
* Comment: check weekly earnings PRERNWA WEEKLY EARNINGS RECODE
* with PEERNWKP  HOW MANY WEEKS A YEAR DO YOU (01 - 52)
	

***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_joball_tru')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

* PEHRRSN3 WHAT IS THE MAIN REASON YOU WORKED LESS THAN 35 HOURS LAST WEEK? (1 SLACK WORK/BUSINESS CONDITIONS)
 
		gen ilo_joball_tru=.
		replace ilo_joball_tru=1 if  PEHRRSN3 == 1 & ilo_lfs == 1 
			lab def lab_joball_tru 1 "Time-related underemployed" 
			lab val ilo_joball_tru lab_joball_tru
			lab var ilo_joball_tru "Time-related underemployed"

		* tab  ilo_joball_tru [iw = ilo_wgt] if ilo_lfs == 1, m		
		



*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Cases of non-fatal occupational injury ('ilo_joball_oi_case')
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------

* Comment: No information

*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Days lost due to cases of occupational injury ('ilo_joball_oi_day')
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------

* Comment: No information


***********************************************************************************************
*			PART 3.3. UNEMPLOYMENT: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Category of unemployment ('ilo_cat_une')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* PRUNTYPE REASON FOR UNEMPLOYMENT (6	NEW-ENTRANT)


		gen ilo_cat_une=.
		replace ilo_cat_une=1 if PELKLWO == 6 & ilo_lfs==2				// 1 - Unemployed previously employed
		replace ilo_cat_une=2 if PELKLWO != 6 & ilo_lfs==2				// 2 - Unemployed seeking their first job
		replace ilo_cat_une=3 if (ilo_cat_une==. & ilo_lfs==2)			// 3 - Unknown
			lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
			    lab values ilo_cat_une cat_une_lab
			    lab var ilo_cat_une "Category of unemployment"
		
		* test if var is should be drop 	
		egen drop_var = mean(ilo_cat_une)
		local prev_une_cat = drop_var in 1
		
		if `prev_une_cat' == 3 {
			drop ilo_cat_une
		}
		drop 	drop_var
		* tab  ilo_cat_une [iw = ilo_wgt] if ilo_lfs == 2, m		

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* PRUNEDUR DURATION OF UNEMPLOYMENT FOR 

    * Detailed
		gen todrop  = PRUNEDUR / 4.33
		gen ilo_dur_details=.
				replace ilo_dur_details=1 if (todrop<1 & ilo_lfs==2)							// Less than 1 month
				replace ilo_dur_details=2 if (inrange(todrop,1,2.999999) & ilo_lfs==2)			// 1 - less than 3 months
				replace ilo_dur_details=3 if (inrange(todrop,3,5.999999) & ilo_lfs==2)			// 3 - less than 5 months
				replace ilo_dur_details=4 if (inrange(todrop,6,11.999999) & ilo_lfs==2)			// 6 - less than 11 months
				replace ilo_dur_details=5 if (inrange(todrop,12,23.999999) & ilo_lfs==2)		// 12 - less than 23 months
				replace ilo_dur_details=6 if (inrange(todrop,24,1440) & ilo_lfs==2)				// 24+  months
				replace ilo_dur_details=7 if (ilo_dur_details==. & ilo_lfs==2)					// Not elsewhere classified
			        lab def ilo_unemp_det 1 "Less than 1 month" 2 "1 month to less than 3 months" 3 "3 months to less than 6 months" ///
										  4 "6 months to less than 12 months" 5 "12 months to less than 24 months" 6 "24 months or more" ///
										  7 "Not elsewhere classified"
				    lab val ilo_dur_details ilo_unemp_det
				    lab var ilo_dur_details "Duration of unemployment (Details)"
		
    * Aggregate				

		gen ilo_dur_aggregate=.
			replace ilo_dur_aggregate=1 if inrange(PRUNEDUR,0,25)						// Less than 6 months
			replace ilo_dur_aggregate=2 if inrange(PRUNEDUR,26,51)             			// 6 months to less than 12 months
			replace ilo_dur_aggregate=3 if inrange(PRUNEDUR,52,119)					    // 12 months or more
			replace ilo_dur_aggregate=4 if ilo_dur_aggregate==. & ilo_lfs==2            // Not elsewhere classified
					lab def ilo_unemp_aggr 1 "Less than 6 months" 2 "6 months to less than 12 months" 3 "12 months or more" 4 "Not elsewhere classified"
					lab val ilo_dur_aggregate ilo_unemp_aggr
					lab var ilo_dur_aggregate "Duration of unemployment (Aggregate)"

		* test if var is should be drop 	
		egen drop_var = mean(ilo_dur_aggregate)
		local Z = drop_var in 1
		if `Z' == 4 {
			drop ilo_dur_aggregate
		}
		drop 	drop_var
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

* Comment: Dissemination usually in aggregated form: NACEPR1D (for NACE Rev 2), NA11PR1D, NA11PRS (for NACE Rev 1)
* 			NACEPR is aggregated in the anonymised microdata in this way: NACEPR1D (for NACE Rev 2), NA11PR1D, NA11PRS (for NACE Rev 1); see corresponding chapter

		
/*

* ISIC Rev. 4 NACEPR1D
		tostring NACEPR1D, replace
		gen ilo_preveco_isic4=.
			replace ilo_preveco_isic4=1 if NACEPR1D=="A"				// Agriculture, forestry and fishing
			replace ilo_preveco_isic4=2 if NACEPR1D=="B"				// Mining and quarrying
			replace ilo_preveco_isic4=3 if NACEPR1D=="C"				// Manufacturing
			replace ilo_preveco_isic4=4 if NACEPR1D=="D"				// Electricity, gas, steam and air conditioning supply
			replace ilo_preveco_isic4=5 if NACEPR1D=="E"				// Water supply; sewerage, waste management and remediation activities
			replace ilo_preveco_isic4=6 if NACEPR1D=="F"				// Construction
			replace ilo_preveco_isic4=7 if NACEPR1D=="G"          		// Wholesale and retail trade; repair of motor vehicles and motorcycles
			replace ilo_preveco_isic4=8 if NACEPR1D=="H"				// Transportation and storage
			replace ilo_preveco_isic4=9 if NACEPR1D=="I"				// Accommodation and food service activities
			replace ilo_preveco_isic4=10 if NACEPR1D=="J"				// Information and communication
			replace ilo_preveco_isic4=11 if NACEPR1D=="K"				// Financial and insurance activities	
			replace ilo_preveco_isic4=12 if NACEPR1D=="L"				// Real estate activities
			replace ilo_preveco_isic4=13 if NACEPR1D=="M"				// Professional, scientific and technical activities
			replace ilo_preveco_isic4=14 if NACEPR1D=="N"				// Administrative and support service activities
			replace ilo_preveco_isic4=15 if NACEPR1D=="O"				// Public administration and defence; compulsory social security
			replace ilo_preveco_isic4=16 if NACEPR1D=="P"				// Education
			replace ilo_preveco_isic4=17 if NACEPR1D=="Q"				// Human health and social work activities
			replace ilo_preveco_isic4=18 if NACEPR1D=="R"				// Arts, entertainment and recreation
			replace ilo_preveco_isic4=19 if NACEPR1D=="S"				// Other service activities
			replace ilo_preveco_isic4=20 if NACEPR1D=="T"				// Activities of households as employers; undifferentiated goods- and services-producing activities of households for own use
			replace ilo_preveco_isic4=21 if NACEPR1D=="U"				// Activities of extraterritorial organizations and bodies
			replace ilo_preveco_isic4=22 if NACEPR1D=="9"	& ilo_cat_une == 1	    // Not elsewhere classified
			replace ilo_preveco_isic4=22 if ilo_preveco_isic4==. & ilo_cat_une == 1
				lab val ilo_preveco_isic4 eco_isic4_lab
				lab var ilo_preveco_isic4 "Previous economic activity (ISIC Rev. 4)"
			
			
	* Now do the classification on an aggregate level
	
		* Primary activity
		
		gen ilo_preveco_aggregate=.
			replace ilo_preveco_aggregate=1 if ilo_preveco_isic4==1
			replace ilo_preveco_aggregate=2 if ilo_preveco_isic4==3
			replace ilo_preveco_aggregate=3 if ilo_preveco_isic4==6
			replace ilo_preveco_aggregate=4 if inlist(ilo_preveco_isic4,2,4,5)
			replace ilo_preveco_aggregate=5 if inrange(ilo_preveco_isic4,7,14)
			replace ilo_preveco_aggregate=6 if inrange(ilo_preveco_isic4,15,21)
			replace ilo_preveco_aggregate=7 if ilo_preveco_isic4==22
				lab val ilo_preveco_aggregate eco_aggr_lab 
				lab var ilo_preveco_aggregate "Previous economic activity (Aggregate)"			

		* test if var is should be drop 	
		egen drop_var = mean(ilo_preveco_aggregate)
		local Z = drop_var in 1
		if `Z' == 7 {
			drop ilo_preveco_aggregate ilo_preveco_isic4
		}
		drop 	drop_var
	
	

* tab  ilo_preveco_isic4 [iw = ilo_wgt] if ilo_lfs == 2, m
		
	
				
* tab  ilo_preveco_isic3 [iw = ilo_wgt] if ilo_lfs == 2, m

*/		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

* base on ilo_job1_ocu_isco08 ask to everybody aand thenreduce to unemployed

	gen  ilo_prevocu_isco08= ilo_job1_ocu_isco08
	gen  ilo_prevocu_aggregate = ilo_job1_ocu_aggregate
	
	replace ilo_prevocu_isco08 = . if ilo_lfs != 2
	replace ilo_prevocu_aggregate  = . if ilo_lfs != 2
		


	 * tab  ilo_prevocu_isco08 [iw = ilo_wgt] if ilo_cat_une == 1	, m

		  


***********************************************************************************************
*			PART 3.4. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		.
* PEDW4WK		DID YOU DO ANY OF THIS WORK DURING THE LAST 4 WEEKS? 1 Yes, 2 No
* PEDWAVL		LAST WEEK, COULD YOU HAVE STARTED A JOB IF ONE HAD BEEN OFFERED? 1 Yes, 2 No only ask to PEDW4WK = No
* PRWNTJOB		NILF RECODE - WANT A JOB OR OTHER NILF, 1 Want a job


		gen ilo_olf_dlma=. 

		* 1 - Seeking, not available (Unavailable jobseekers) # assuming that they are not availble else unemployed !!
		replace ilo_olf_dlma=1 if (PEDW4WK == 1  & ilo_lfs == 3)			
		* 2 - Not seeking, available (Available potential jobseekers)
		replace ilo_olf_dlma=2 if (PEDW4WK == 2 & PEDWAVL == 1 & ilo_lfs == 3)			
		* 3 - Not seeking, not available, willing (Willing non-jobseekers)
		replace ilo_olf_dlma=3 if (PEDW4WK == 2 & PEDWAVL == 2 & ilo_lfs == 3 & PRWNTJOB == 1) 
		* 4 - Not seeking, not available, not willing
		replace ilo_olf_dlma=4 if (PEDW4WK == 2 & PEDWAVL == 2 & ilo_lfs == 3 & PRWNTJOB != 1)
		replace ilo_olf_dlma=5 if (ilo_lfs == 3 & ilo_olf_dlma==.)
			lab def olf_dlma_lab 1 "1 - Seeking, not available (Unavailable jobseekers)" 2 "2 - Not seeking, available (Available potential jobseekers)" 3 "3 - Not seeking, not available, willing (Willing non-jobseekers)" 4 "4 - Not seeking, not available, not willing" 5 "5 - Not elsewhere classified"
			lab val ilo_olf_dlma olf_dlma_lab 
			lab var ilo_olf_dlma "Labour market attachment (Degree of)"

		* test if var is should be drop 	
		egen drop_var = mean(ilo_olf_dlma)
		local Z = drop_var in 1
		if `Z' == 4 {
			drop ilo_olf_dlma
		}
		drop 	drop_var
		
	
	* tab  ilo_olf_dlma [iw = ilo_wgt] , m	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reason for not seeking job ('ilo_olf_reason')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
/*
* my be could be try with ???????????
* PEDWRSN WHAT IS THE MAIN REASON YOU WERE NOT LOOKING FOR WORK DURING THE LAST 4 WEEKS?

*						1	BELIEVES NO WORK AVAILABLE IN AREA OF EXPERTISE
*						2	COULDN'T FIND ANY WORK
*						3	LACKS NECESSARY SCHOOLING/TRAINING
*						4	EMPLOYERS THINK TOO YOUNG OR TOO OLD
*						5	OTHER TYPES OF DISCRIMINATION
*						6 	CAN'T ARRANGE CHILD CARE
*						7	FAMILY RESPONSIBILITIES
*                      	8	IN SCHOOL OR OTHER TRAINING
*						9	ILL-HEALTH, PHYSICAL DISABILITY
*						10	TRANSPORTATION PROBLEMS
*						11	OTHER - SPECIFY

  	gen ilo_olf_reason = .
		replace ilo_olf_reason = 1 if inlist(PEDWRSN)					// 1 - Labour market (discouraged)
		replace ilo_olf_reason = 1 if inlist(PEDWRSN)					// 2- Other labour market reasons
		replace ilo_olf_reason = 1 if inlist(PEDWRSN)					// 3 - Personal / Family-related
		replace ilo_olf_reason = 1 if inlist(PEDWRSN)					// 4 - Does not need/want to work
		replace ilo_olf_reason = 1 if inlist(PEDWRSN)					// 5 - Not elsewhere classified
			lab def dis_lab 1 "Discouraged job-seekers"					
			lab val ilo_dis dis_lab										
			lab var ilo_dis "Discouraged job-seekers"					
		
*/


			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seeker ('ilo_dis')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* PREMPNOT		MLR - EMPLOYED, UNEMPLOYED, OR NILF
   
  	gen ilo_dis = .
		replace ilo_dis=1 if PREMPNOT == 3
			lab def dis_lab 1 "Discouraged job-seekers"
			lab val ilo_dis dis_lab
			lab var ilo_dis "Discouraged job-seekers"
		
		
	* tab  ilo_dis [iw = ilo_wgt] , m	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training ('ilo_neet')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------


		gen ilo_neet = .
		replace ilo_neet=1 if (ilo_age_aggregate==2 & ilo_edu_attendance  == 2 & inlist(ilo_lfs, 2, 3 ))
			lab def neet_lab 1 "Youth not in education, employment or training"
			lab val ilo_neet neet_lab
			lab var ilo_neet "Youth not in education, employment or training"

		
	
***********************************************************************************************
***********************************************************************************************

*			3. SAVE ILO-VARIABLES IN A NEW DATASET

***********************************************************************************************
***********************************************************************************************
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Drop intermediate variables 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

replace ilo_job1_ocu_isco08_2digits = . if ilo_lfs !=1
replace ilo_job1_ocu_isco08 = . if ilo_lfs !=1
replace ilo_job1_ocu_aggregate= . if ilo_lfs !=1
replace ilo_job1_ocu_skill = . if ilo_lfs !=1

drop todrop*
local Y
local Q	
local Z	
local prev_une_cat


* -------------------------------------------------------------
* 	Prepare final datasets
* -------------------------------------------------------------

cd "$outpath"
		
		/* Only age bands used */
		drop ilo_age
		drop if ilo_sex==. 
		
		compress 
		
		/*Save dataset including original and ilo variables*/
	
		save ${country}_${source}_${time}_FULL,  replace		

		/* Save file only containing ilo_* variables*/
	
	*	keep ilo*

	*	save ${country}_${source}_${time}_ILO, replace
