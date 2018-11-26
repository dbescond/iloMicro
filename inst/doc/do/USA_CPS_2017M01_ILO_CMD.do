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
global inputFile "jan17pub.dta"
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

*********************************************************************************************

* create local for Year and quarter

*********************************************************************************************			
decode ilo_time, gen(todrop)
split todrop, generate(todrop_) parse(M)
destring todrop_1, replace force
local Y = todrop_1 in 1
			
		
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
 
capture    destring PWCMPWGT, replace
capture    destring PWSSWGT, replace
capture    destring NWCMPWGT, replace
gen ilo_wgt=.
capture replace ilo_wgt = PWCMPWGT 			// 1998-1999 and after 2003
if `Y' < 1998 {	
	capture replace ilo_wgt =  PWSSWGT		// before 1998 
}	
if `Y' < 2003 & `Y' > 1999 {	
	capture replace ilo_wgt =  NWCMPWGT     // only 2000-2002 
}	
 
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

if `Y' > 2004 {	
	gen ilo_geo = .
		replace ilo_geo = 1 if inrange(GTCBSASZ, 1,7)		// 1 - Urban
		replace ilo_geo = 2 if GTCBSASZ ==0		// 2 - Rural
		replace ilo_geo = 3 if  ilo_geo ==.											// 3 - Not elsewhere classified
		lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural" 3 "3 - Not elsewhere classified"
		lab val ilo_geo ilo_geo_lab
		lab var ilo_geo "Geographical coverage"	
}	

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
	
	capture gen PRTAGE = PEAGE 

	gen ilo_age= PRTAGE
	    lab var ilo_age "Age"

* Age groups

	gen ilo_age_5yrbands=.
		* replace ilo_age_5yrbands=1 if inrange(ilo_age,0,4)
		* replace ilo_age_5yrbands=2 if inrange(ilo_age,5,9)
		* replace ilo_age_5yrbands=3 if inrange(ilo_age,10,14)
		replace ilo_age_5yrbands=4 if inrange(ilo_age,16,19)
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
		* replace ilo_age_10yrbands=1 if inrange(ilo_age,0,14)
		replace ilo_age_10yrbands=2 if inrange(ilo_age,16,24)
		replace ilo_age_10yrbands=3 if inrange(ilo_age,25,34)
		replace ilo_age_10yrbands=4 if inrange(ilo_age,35,44)
		replace ilo_age_10yrbands=5 if inrange(ilo_age,45,54)
		replace ilo_age_10yrbands=6 if inrange(ilo_age,55,64)
		replace ilo_age_10yrbands=7 if ilo_age>=65 & ilo_age!=.
			    lab def age_by10_lab 1 "<15" 2 "15-24" 3 "25-34" 4 "35-44" 5 "45-54" 6 "55-64" 7 "65+"
			    lab val ilo_age_10yrbands age_by10_lab
			    lab var ilo_age_10yrbands "Age (10-year age bands)"
			
	gen ilo_age_aggregate=.
		* replace ilo_age_aggregate=1 if inrange(ilo_age,0,14)
		replace ilo_age_aggregate=2 if inrange(ilo_age,16,24)
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

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			           Marital status ('ilo_mrts') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 

	* Detailed
	gen ilo_mrts_details=.
	    replace ilo_mrts_details=1 if  PEMARITL == 6                            // Single
		replace ilo_mrts_details=2 if  inlist(PEMARITL,1,2)                     // Married
		* replace ilo_mrts_details=3 if  PEMARITL ==                            // Union / cohabiting
		replace ilo_mrts_details=4 if  PEMARITL == 3                            // Widowed
		replace ilo_mrts_details=5 if  inlist(PEMARITL, 4,5)                    // Divorced / separated
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
*			Disability status ('ilo_dsb')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

if `Y' > 2008 {	
* PRDISFLG DOES THIS PERSON HAVE ANY OF THESE DISABILITY CONDITIONS? (1	Yes)

	gen ilo_dsb_aggregate=.
		replace ilo_dsb_aggregate=1 if PRDISFLG!=1
		replace ilo_dsb_aggregate=2 if PRDISFLG==1
			label def dsb_aggregate_lab 1 "Persons without disability" 2 "Persons with disability"
			label val ilo_dsb_aggregate dsb_aggregate_lab
			label var ilo_dsb_aggregate "Disability status (Aggregate)"
}
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
		replace ilo_wap=1 if ilo_age>=16 & ilo_age!=.				// Working age population
			label def ilo_wap_lab 1 "Working age population"
			label val ilo_wap ilo_wap_lab
			label var ilo_wap "Working age population"

			
	
			
	* tab  ilo_age_5yrbands [iw = ilo_wgt] if ilo_wap == 1 , m
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


* MAIN JOB
* PRCOW1 CLASS OF WORKER RECODE - JOB 1
gen ilo_job1_ste = PRCOW1

if `Y' < 2003 & `Y' > 1999 {	
	capture replace ilo_job1_ste = NRCOW1 // only 2000-2002 else PRCOW1
	
}

	* Detailed categories:
		gen ilo_job1_ste_icse93=.
			replace ilo_job1_ste_icse93=1 if (inlist(ilo_job1_ste, 1, 2, 3, 4) & ilo_lfs==1)   		    // Employees
			* replace ilo_job1_ste_icse93=2 if (ilo_job1_ste==1 & ilo_lfs==1)	            // Employers
			replace ilo_job1_ste_icse93=3 if (ilo_job1_ste== 5 & ilo_lfs==1)      			// Own-account workers
			* replace ilo_job1_ste_icse93=4                                         // Members of producers’ cooperatives
			replace ilo_job1_ste_icse93=5 if (ilo_job1_ste==6 & ilo_lfs==1)	            // Contributing family workers
			replace ilo_job1_ste_icse93=6 if (ilo_job1_ste_icse93==. & ilo_lfs==1)  // Not classifiable
				label def label_ilo_ste_icse93 1 "1 - Employees" 2 "2 - Employers" 3 "3 - Own-account workers" ///                      
											   4 "4 - Members of producers cooperatives" 5 "5 - Contributing family workers" ///
											   6 "6 - Workers not classifiable by status"
				label val ilo_job1_ste_icse93 label_ilo_ste_icse93
				label var ilo_job1_ste_icse93 "Status in employment (ICSE 93)"

	* Aggregate categories 
		gen ilo_job1_ste_aggregate=.
			replace ilo_job1_ste_aggregate=1 if (inlist(ilo_job1_ste, 1, 2, 3, 4) & ilo_lfs==1)			// Employees
			replace ilo_job1_ste_aggregate=2 if (inlist(ilo_job1_ste,5,6) & ilo_lfs==1)	// Self-employed
			replace ilo_job1_ste_aggregate=3 if (ilo_job1_ste_aggregate==. & ilo_lfs==1)			// Not elsewhere classified
				lab def ste_aggr_lab 1 "1 - Employees" 2 "2 - Self-employed" 3 "3 - Not elsewhere classified"
				lab val ilo_job1_ste_aggregate ste_aggr_lab
				label var ilo_job1_ste_aggregate "Status in employment (Aggregate)"  
 
	* tab  ilo_job1_ste_icse93 [iw = ilo_wgt] if ilo_lfs == 1, m			
drop ilo_job1_ste


*SECOND_JOB
gen ilo_job2_ste = PRCOW2

if `Y' < 2003 & `Y' > 1999 {	
	capture replace ilo_job2_ste = NRCOW2 // only 2000-2002 else PRCOW2
	
}

	* Detailed categories:
		gen ilo_job2_ste_icse93=.
			replace ilo_job2_ste_icse93=1 if (inlist(ilo_job2_ste, 1, 2, 3, 4) & ilo_lfs==1)   		    // Employees
			* replace ilo_job2_ste_icse93=2 if (ilo_job2_ste==1 & ilo_lfs==1)	            // Employers
			replace ilo_job2_ste_icse93=3 if (ilo_job2_ste== 5 & ilo_lfs==1)      			// Own-account workers
			* replace ilo_job2_ste_icse93=4                                         // Members of producers’ cooperatives
			replace ilo_job2_ste_icse93=5 if (ilo_job2_ste==6 & ilo_lfs==1)	            // Contributing family workers
			replace ilo_job2_ste_icse93=6 if ilo_job2_ste_icse93==. & ilo_lfs==1 & ilo_mjh==2 // Not elsewhere classified
					replace ilo_job2_ste_icse93=. if ilo_lfs!=1 & ilo_mjh!=2
				label val ilo_job2_ste_icse93 label_ilo_ste_icse93
				label var ilo_job2_ste_icse93 "Status in employment (ICSE 93)"

			* Aggregate categories
		
			gen ilo_job2_ste_aggregate=.
				replace ilo_job2_ste_aggregate=1 if ilo_job2_ste_icse93==1
				replace ilo_job2_ste_aggregate=2 if inlist(ilo_job2_ste_icse93,2,3,4)
				replace ilo_job2_ste_aggregate=3 if inlist(ilo_job2_ste_icse93,5,6)
					*value labels already defined
					lab val ilo_job2_ste_aggregate ste_aggr_lab
				label var ilo_job2_ste_aggregate "Status in employment (Aggregate) in secondary job" 
 
 
	* tab  ilo_job2_ste_aggregate [iw = ilo_wgt] if ilo_lfs == 1, m			
drop ilo_job2_ste
	
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* generate random variable to distribute census over multi cat in isic and isco
set seed 1

gen ilo_random_distribution =  runiform(0, 1) if ilo_lfs == 1




* PEIO1ICD INDUSTRY CODE FOR PRIMARY JOB
if `Y' > 1999 {

* Comment: var PEIO1OCD apply for all then reduce to emp and une at the end of the do.
* PEIO1OCD OCCUPATION CODE FOR PRIMARY JOB.
	
	gen census = PEIO1ICD

if `Y' < 2003 & `Y' > 1999 {	
	capture replace census = NEIO1ICD // only 2000-2002 else PEIO1OCD
}
* ISIC Rev. 4

	destring census, replace
	gen ilo_job1_eco_isic4_2digits = .

capture replace ilo_job1_eco_isic4_2digits = 1 if census == 170                           // 01 / 02 / 03 / 10 - Crop and animal production, hunting and related service activities
capture replace ilo_job1_eco_isic4_2digits = 1 if census == 180                           // 01 / 03 - Crop and animal production, hunting and related service activities
capture replace ilo_job1_eco_isic4_2digits = 1 if census == 190                           // 01 - Crop and animal production, hunting and related service activities
capture replace ilo_job1_eco_isic4_2digits = 2 if census == 270                           // 02 - Forestry and logging
capture replace ilo_job1_eco_isic4_2digits = 1 if census == 280                           // 01 / 03 - Crop and animal production, hunting and related service activities
capture replace ilo_job1_eco_isic4_2digits = 1 if census == 290                           // 01 / 02 / 75 - Crop and animal production, hunting and related service activities
capture replace ilo_job1_eco_isic4_2digits = 5 if census == 370                           // 05 / 06 - Mining of coal and lignite
capture replace ilo_job1_eco_isic4_2digits = 5 if census == 380                           // 05 - Mining of coal and lignite
capture replace ilo_job1_eco_isic4_2digits = 7 if census == 390                           // 07 - Mining of metal ores
capture replace ilo_job1_eco_isic4_2digits = 8 if census == 470                           // 08 - Other mining and quarrying
capture replace ilo_job1_eco_isic4_2digits = 7 if census == 480                           // 07 / 08 - Mining of metal ores
capture replace ilo_job1_eco_isic4_2digits = 9 if census == 490                           // 09 / 43 - Mining support service activities
capture replace ilo_job1_eco_isic4_2digits = 35 if census == 570                           // 35 - Electricity, gas, steam and air conditioning supply
capture replace ilo_job1_eco_isic4_2digits = 35 if census == 580                           // 35 - Electricity, gas, steam and air conditioning supply
capture replace ilo_job1_eco_isic4_2digits = 35 if census == 590                           // 35 - Electricity, gas, steam and air conditioning supply
capture replace ilo_job1_eco_isic4_2digits = 35 if census == 670                           // 35 / 36 / 49 - Electricity, gas, steam and air conditioning supply
capture replace ilo_job1_eco_isic4_2digits = 37 if census == 680                           // 37 - Sewerage
capture replace ilo_job1_eco_isic4_2digits = 35 if census == 690                           // 35 / 37 / 38 - Electricity, gas, steam and air conditioning supply
capture replace ilo_job1_eco_isic4_2digits = 41 if census == 770                           // 41 / 42 / 43 - Construction of buildings
capture replace ilo_job1_eco_isic4_2digits = 35 if census == 1070                           // 35 - Electricity, gas, steam and air conditioning supply
capture replace ilo_job1_eco_isic4_2digits = 10 if census == 1080                           // 10 - Manufacture of food products
capture replace ilo_job1_eco_isic4_2digits = 10 if census == 1090                           // 10 - Manufacture of food products
capture replace ilo_job1_eco_isic4_2digits = 10 if census == 1170                           // 10 - Manufacture of food products
capture replace ilo_job1_eco_isic4_2digits = 10 if census == 1180                           // 10 - Manufacture of food products
capture replace ilo_job1_eco_isic4_2digits = 10 if census == 1190                           // 10 - Manufacture of food products
capture replace ilo_job1_eco_isic4_2digits = 10 if census == 1270                           // 10 - Manufacture of food products
capture replace ilo_job1_eco_isic4_2digits = 3 if census == 1280                           // 03 / 08 / 10 - Fishing and aquaculture
capture replace ilo_job1_eco_isic4_2digits = 3 if census == 1290                           // 03 / 08 / 10 / 11 - Fishing and aquaculture
capture replace ilo_job1_eco_isic4_2digits = 11 if census == 1370                           // 11 / 20 / 35 - Manufacture of beverages
capture replace ilo_job1_eco_isic4_2digits = 12 if census == 1390                           // 12 - Manufacture of tobacco products
capture replace ilo_job1_eco_isic4_2digits = 13 if census == 1470                           // 13 - Manufacture of textiles
capture replace ilo_job1_eco_isic4_2digits = 13 if census == 1480                           // 13 / 14 / 28 - Manufacture of textiles
capture replace ilo_job1_eco_isic4_2digits = 13 if census == 1490                           // 13 / 22 - Manufacture of textiles
capture replace ilo_job1_eco_isic4_2digits = 31 if census == 1570                           // 31 - Manufacture of furniture
capture replace ilo_job1_eco_isic4_2digits = 13 if census == 1590                           // 13 / 14 / 15 / 22 - Manufacture of textiles
capture replace ilo_job1_eco_isic4_2digits = 13 if census == 1670                           // 13:14:22 - Manufacture of textiles
capture replace ilo_job1_eco_isic4_2digits = 14 if census == 1680                           // 14 - Manufacture of wearing apparel
capture replace ilo_job1_eco_isic4_2digits = 13 if census == 1690                           // 13 / 14 / 22 - Manufacture of textiles
capture replace ilo_job1_eco_isic4_2digits = 15 if census == 1770                           // 15 - Manufacture of leather and related products
capture replace ilo_job1_eco_isic4_2digits = 13 if census == 1790                           // 13:14:15:22 - Manufacture of textiles
capture replace ilo_job1_eco_isic4_2digits = 17 if census == 1870                           // 17 / 23 - Manufacture of paper and paper products
capture replace ilo_job1_eco_isic4_2digits = 17 if census == 1880                           // 17 - Manufacture of paper and paper products
capture replace ilo_job1_eco_isic4_2digits = 13 if census == 1890                           // 13 / 17 / 22 / 24 / 25 - Manufacture of textiles
capture replace ilo_job1_eco_isic4_2digits = 13 if census == 1990                           // 13 / 17 / 18 / 25 - Manufacture of textiles
capture replace ilo_job1_eco_isic4_2digits = 19 if census == 2070                           // 19 - Manufacture of coke and refined petroleum products
capture replace ilo_job1_eco_isic4_2digits = 16 if census == 2090                           // 16 / 19 / 23 - Manufacture of wood and of products of wood and cork, except furniture; manufacture of articles of straw and plaiting materials
capture replace ilo_job1_eco_isic4_2digits = 20 if census == 2170                           // 20 / 22 - Manufacture of chemicals and chemical products
capture replace ilo_job1_eco_isic4_2digits = 20 if census == 2180                           // 20 - Manufacture of chemicals and chemical products
capture replace ilo_job1_eco_isic4_2digits = 20 if census == 2190                           // 20 / 21 - Manufacture of chemicals and chemical products
capture replace ilo_job1_eco_isic4_2digits = 20 if census == 2270                           // 20 - Manufacture of chemicals and chemical products
capture replace ilo_job1_eco_isic4_2digits = 20 if census == 2280                           // 20 - Manufacture of chemicals and chemical products
capture replace ilo_job1_eco_isic4_2digits = 14 if census == 2290                           // 14 / 20 / 21 - Manufacture of wearing apparel
capture replace ilo_job1_eco_isic4_2digits = 22 if census == 2370                           // 22 / 27 / 29 / 31 - Manufacture of rubber and plastics products
capture replace ilo_job1_eco_isic4_2digits = 22 if census == 2380                           // 22 - Manufacture of rubber and plastics products
capture replace ilo_job1_eco_isic4_2digits = 22 if census == 2390                           // 22 / 27 - Manufacture of rubber and plastics products
capture replace ilo_job1_eco_isic4_2digits = 23 if census == 2470                           // 23 - Manufacture of other non-metallic mineral products
capture replace ilo_job1_eco_isic4_2digits = 23 if census == 2480                           // 23 - Manufacture of other non-metallic mineral products
capture replace ilo_job1_eco_isic4_2digits = 23 if census == 2480                           // 23 - Manufacture of other non-metallic mineral products
capture replace ilo_job1_eco_isic4_2digits = 23 if census == 2480                           // 23 - Manufacture of other non-metallic mineral products
capture replace ilo_job1_eco_isic4_2digits = 23 if census == 2490                           // 23 - Manufacture of other non-metallic mineral products
capture replace ilo_job1_eco_isic4_2digits = 23 if census == 2570                           // 23 - Manufacture of other non-metallic mineral products
capture replace ilo_job1_eco_isic4_2digits = 23 if census == 2590                           // 23 / 32 - Manufacture of other non-metallic mineral products
capture replace ilo_job1_eco_isic4_2digits = 24 if census == 2670                           // 24 / 25 / 27 / 30 - Manufacture of basic metals
capture replace ilo_job1_eco_isic4_2digits = 24 if census == 2680                           // 24 / 25 / 27 - Manufacture of basic metals
capture replace ilo_job1_eco_isic4_2digits = 24 if census == 2690                           // 24 / 25 / 27 - Manufacture of basic metals
capture replace ilo_job1_eco_isic4_2digits = 24 if census == 2770                           // 24 / 28 - Manufacture of basic metals
capture replace ilo_job1_eco_isic4_2digits = 25 if census == 2780                           // 25 - Manufacture of fabricated metal products, except machinery and equipment
capture replace ilo_job1_eco_isic4_2digits = 25 if census == 2790                           // 25 / 27 / 28 / 32 - Manufacture of fabricated metal products, except machinery and equipment
capture replace ilo_job1_eco_isic4_2digits = 25 if census == 2870                           // 25 / 28 / 29 / 30 - Manufacture of fabricated metal products, except machinery and equipment
capture replace ilo_job1_eco_isic4_2digits = 25 if census == 2880                           // 25 - Manufacture of fabricated metal products, except machinery and equipment
capture replace ilo_job1_eco_isic4_2digits = 25 if census == 2890                           // 25 - Manufacture of fabricated metal products, except machinery and equipment
capture replace ilo_job1_eco_isic4_2digits = 17 if census == 2970                           // 17 / 20 / 24 / 25 - Manufacture of paper and paper products
capture replace ilo_job1_eco_isic4_2digits = 20 if census == 2980                           // 20 / 24 / 25 / 28 / 32 - Manufacture of chemicals and chemical products
capture replace ilo_job1_eco_isic4_2digits = 20 if census == 2990                           // 20 / 24 / 25 - Manufacture of chemicals and chemical products
capture replace ilo_job1_eco_isic4_2digits = 28 if census == 3070                           // 28 / 30 - Manufacture of machinery and equipment n.e.c.
capture replace ilo_job1_eco_isic4_2digits = 43 if census == 3080                           // 43 - Specialized construction activities
capture replace ilo_job1_eco_isic4_2digits = 27 if census == 3090                           // 27 / 28 / 32 - Manufacture of electrical equipment
capture replace ilo_job1_eco_isic4_2digits = 26 if census == 3095                           // 26 / 27 / 28 / 30 / 32 - Manufacture of computer, electronic and optical products
capture replace ilo_job1_eco_isic4_2digits = 25 if census == 3170                           // 25 / 28 - Manufacture of fabricated metal products, except machinery and equipment
capture replace ilo_job1_eco_isic4_2digits = 27 if census == 3180                           // 27 / 28 / 29 / 30 - Manufacture of electrical equipment
capture replace ilo_job1_eco_isic4_2digits = 25 if census == 3190                           // 25 / 28 / 32 - Manufacture of fabricated metal products, except machinery and equipment
capture replace ilo_job1_eco_isic4_2digits = 25 if census == 3290                           // 25 / 28 / 32 - Manufacture of fabricated metal products, except machinery and equipment
capture replace ilo_job1_eco_isic4_2digits = 26 if census == 3360                           // 26 - Manufacture of computer, electronic and optical products
capture replace ilo_job1_eco_isic4_2digits = 26 if census == 3365                           // 26 - Manufacture of computer, electronic and optical products
capture replace ilo_job1_eco_isic4_2digits = 26 if census == 3370                           // 26 / 30 - Manufacture of computer, electronic and optical products
capture replace ilo_job1_eco_isic4_2digits = 26 if census == 3380                           // 26 - Manufacture of computer, electronic and optical products
capture replace ilo_job1_eco_isic4_2digits = 18 if census == 3390                           // 18 / 26 - Printing and reproduction of recorded media
capture replace ilo_job1_eco_isic4_2digits = 27 if census == 3470                           // 27 - Manufacture of electrical equipment
capture replace ilo_job1_eco_isic4_2digits = 13 if census == 3490                           // 13 / 23 / 27 - Manufacture of textiles
capture replace ilo_job1_eco_isic4_2digits = 23 if census == 3570                           // 23 / 27 / 28 / 29 - Manufacture of other non-metallic mineral products
capture replace ilo_job1_eco_isic4_2digits = 28 if census == 3580                           // 28 / 30 - Manufacture of machinery and equipment n.e.c.
capture replace ilo_job1_eco_isic4_2digits = 30 if census == 3590                           // 30 - Manufacture of other transport equipment
capture replace ilo_job1_eco_isic4_2digits = 29 if census == 3670                           // 29 / 30 - Manufacture of motor vehicles, trailers and semi-trailers
capture replace ilo_job1_eco_isic4_2digits = 30 if census == 3680                           // 30 / 33 - Manufacture of other transport equipment
capture replace ilo_job1_eco_isic4_2digits = 29 if census == 3690                           // 29 / 30 - Manufacture of motor vehicles, trailers and semi-trailers
capture replace ilo_job1_eco_isic4_2digits = 16 if census == 3770                           // 16 - Manufacture of wood and of products of wood and cork, except furniture; manufacture of articles of straw and plaiting materials
capture replace ilo_job1_eco_isic4_2digits = 16 if census == 3780                           // 16 - Manufacture of wood and of products of wood and cork, except furniture; manufacture of articles of straw and plaiting materials
capture replace ilo_job1_eco_isic4_2digits = 16 if census == 3790                           // 16 - Manufacture of wood and of products of wood and cork, except furniture; manufacture of articles of straw and plaiting materials
capture replace ilo_job1_eco_isic4_2digits = 16 if census == 3870                           // 16 - Manufacture of wood and of products of wood and cork, except furniture; manufacture of articles of straw and plaiting materials
capture replace ilo_job1_eco_isic4_2digits = 16 if census == 3875                           // 16 / 22 / 31 - Manufacture of wood and of products of wood and cork, except furniture; manufacture of articles of straw and plaiting materials
capture replace ilo_job1_eco_isic4_2digits = 31 if census == 3890                           // 31 / 32 - Manufacture of furniture
capture replace ilo_job1_eco_isic4_2digits = 31 if census == 3895                           // 31 / 32 - Manufacture of furniture
capture replace ilo_job1_eco_isic4_2digits = 21 if census == 3960                           // 21 / 28 / 30 / 32 - Manufacture of basic pharmaceutical products and pharmaceutical preparations
capture replace ilo_job1_eco_isic4_2digits = 32 if census == 3970                           // 32 - Other manufacturing
capture replace ilo_job1_eco_isic4_2digits = 13 if census == 3980                           // 13 / 25 / 32 - Manufacture of textiles
capture replace ilo_job1_eco_isic4_2digits = 10 if census == 3990                           // 10 / 13 / 14 / 16 / 20 / 22 / 23 / 24 / 25 / 27 / 28 / 31 / 32 - Manufacture of food products
capture replace ilo_job1_eco_isic4_2digits = 45 if census == 4070                           // 45 / 46 - Wholesale and retail trade and repair of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 46 if census == 4080                           // 46 - Wholesale trade, except of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 43 if census == 4090                           // 43 - Specialized construction activities
capture replace ilo_job1_eco_isic4_2digits = 46 if census == 4170                           // 46 - Wholesale trade, except of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 46 if census == 4180                           // 46 - Wholesale trade, except of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 46 if census == 4190                           // 46 - Wholesale trade, except of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 46 if census == 4195                           // 46 - Wholesale trade, except of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 46 if census == 4260                           // 46 - Wholesale trade, except of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 45 if census == 4265                           // 45 / 46 - Wholesale and retail trade and repair of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 46 if census == 4270                           // 46 - Wholesale trade, except of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 46 if census == 4280                           // 46 - Wholesale trade, except of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 45 if census == 4290                           // 45 / 46 - Wholesale and retail trade and repair of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 46 if census == 4370                           // 46 - Wholesale trade, except of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 46 if census == 4380                           // 46 - Wholesale trade, except of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 46 if census == 4390                           // 46 - Wholesale trade, except of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 46 if census == 4470                           // 46 - Wholesale trade, except of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 46 if census == 4480                           // 46 - Wholesale trade, except of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 46 if census == 4490                           // 46 - Wholesale trade, except of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 46 if census == 4560                           // 46 - Wholesale trade, except of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 46 if census == 4570                           // 46 - Wholesale trade, except of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 46 if census == 4580                           // 46 - Wholesale trade, except of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 45 if census == 4585                           // 45 / 46 - Wholesale and retail trade and repair of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 46 if census == 4590                           // 46 - Wholesale trade, except of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 45 if census == 4670                           // 45 - Wholesale and retail trade and repair of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 45 if census == 4680                           // 45 / 47 - Wholesale and retail trade and repair of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 45 if census == 4690                           // 45 / 47 - Wholesale and retail trade and repair of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 47 if census == 4770                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 47 if census == 4780                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 95 if census == 4780                           // 95 - Repair of computers and personal and household goods
capture replace ilo_job1_eco_isic4_2digits = 33 if census == 4790                           // 33 / 47 - Repair and installation of machinery and equipment
capture replace ilo_job1_eco_isic4_2digits = 33 if census == 4795                           // 33 - Repair and installation of machinery and equipment
capture replace ilo_job1_eco_isic4_2digits = 47 if census == 4795                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 47 if census == 4795                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 47 if census == 4795                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 47 if census == 4795                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 95 if census == 4795                           // 95 - Repair of computers and personal and household goods
capture replace ilo_job1_eco_isic4_2digits = 47 if census == 4870                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 47 if census == 4880                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 47 if census == 4890                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 47 if census == 4970                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 47 if census == 4980                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 47 if census == 4990                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 47 if census == 5070                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 86 if census == 5080                           // 86 - Human health activities
capture replace ilo_job1_eco_isic4_2digits = 47 if census == 5090                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 47 if census == 5170                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 47 if census == 5180                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 47 if census == 5190                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 47 if census == 5270                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 45 if census == 5275                           // 45 - Wholesale and retail trade and repair of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 47 if census == 5280                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 47 if census == 5290                           // 74 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 47 if census == 5295                           // 47 / 95 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 47 if census == 5370                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 47 if census == 5380                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 45 if census == 5390                           // 45 / 47 - Wholesale and retail trade and repair of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 47 if census == 5470                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 47 if census == 5480                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 47 if census == 5490                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 47 if census == 5570                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 47 if census == 5580                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 47 if census == 5590                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 47 if census == 5591                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 47 if census == 5592                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 47 if census == 5670                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 47 if census == 5680                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 47 if census == 5690                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 45 if census == 5790                           // 45 / 47 - Wholesale and retail trade and repair of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 51 if census == 6070                           // 51 - Air transport
capture replace ilo_job1_eco_isic4_2digits = 49 if census == 6080                           // 49 - Land transport and transport via pipelines
capture replace ilo_job1_eco_isic4_2digits = 50 if census == 6090                           // 50 - Water transport
capture replace ilo_job1_eco_isic4_2digits = 49 if census == 6170                           // 49 - Land transport and transport via pipelines
capture replace ilo_job1_eco_isic4_2digits = 49 if census == 6180                           // 49 - Land transport and transport via pipelines
capture replace ilo_job1_eco_isic4_2digits = 49 if census == 6190                           // 49 - Land transport and transport via pipelines
capture replace ilo_job1_eco_isic4_2digits = 49 if census == 6270                           // 49 - Land transport and transport via pipelines
capture replace ilo_job1_eco_isic4_2digits = 49 if census == 6280                           // 49 / 50 / 51 - Land transport and transport via pipelines
capture replace ilo_job1_eco_isic4_2digits = 52 if census == 6290                           // 52 - Warehousing and support activities for transportation
capture replace ilo_job1_eco_isic4_2digits = 53 if census == 6370                           // 53 - Postal and courier activities
capture replace ilo_job1_eco_isic4_2digits = 53 if census == 6380                           // 53 - Postal and courier activities
capture replace ilo_job1_eco_isic4_2digits = 52 if census == 6390                           // 52 - Warehousing and support activities for transportation
capture replace ilo_job1_eco_isic4_2digits = 58 if census == 6470                           // 58 - Publishing activities
capture replace ilo_job1_eco_isic4_2digits = 58 if census == 6480                           // 58 - Publishing activities
capture replace ilo_job1_eco_isic4_2digits = 58 if census == 6490                           // 58 - Publishing activities
capture replace ilo_job1_eco_isic4_2digits = 59 if census == 6570                           // 59 - Motion picture, video and television programme production, sound recording and music publishing activities
capture replace ilo_job1_eco_isic4_2digits = 59 if census == 6590                           // 59 - Motion picture, video and television programme production, sound recording and music publishing activities
capture replace ilo_job1_eco_isic4_2digits = 60 if census == 6670                           // 60 / 61 - Programming and broadcasting activities
capture replace ilo_job1_eco_isic4_2digits = 58 if census == 6672                           // 58 / 59 / 60 / 63 - Publishing activities
capture replace ilo_job1_eco_isic4_2digits = 60 if census == 6675                           // 60 / 61 / 63 - Programming and broadcasting activities
capture replace ilo_job1_eco_isic4_2digits = 61 if census == 6680                           // 61 - Telecommunications
capture replace ilo_job1_eco_isic4_2digits = 61 if census == 6690                           // 61 - Telecommunications
capture replace ilo_job1_eco_isic4_2digits = 61 if census == 6692                           // 61 / 63 / 74 - Telecommunications
capture replace ilo_job1_eco_isic4_2digits = 63 if census == 6695                           // 63 / 74 - Information service activities
capture replace ilo_job1_eco_isic4_2digits = 91 if census == 6770                           // 91 - Libraries, archives, museums and other cultural activities
capture replace ilo_job1_eco_isic4_2digits = 63 if census == 6780                           // 63 / 91 - Information service activities
capture replace ilo_job1_eco_isic4_2digits = 63 if census == 6790                           // 63 / 91 - Information service activities
capture replace ilo_job1_eco_isic4_2digits = 64 if census == 6870                           // 64 - Financial service activities, except insurance and pension funding
capture replace ilo_job1_eco_isic4_2digits = 64 if census == 6880                           // 64 - Financial service activities, except insurance and pension funding
capture replace ilo_job1_eco_isic4_2digits = 64 if census == 6890                           // 64 / 66 - Financial service activities, except insurance and pension funding
capture replace ilo_job1_eco_isic4_2digits = 64 if census == 6970                           // 64 / 65 / 66 / 68 - Financial service activities, except insurance and pension funding
capture replace ilo_job1_eco_isic4_2digits = 65 if census == 6990                           // 65 / 66 - Insurance, reinsurance and pension funding, except compulsory social security
capture replace ilo_job1_eco_isic4_2digits = 68 if census == 7070                           // 68 - Real estate activities
capture replace ilo_job1_eco_isic4_2digits = 77 if census == 7080                           // 77 - Rental and leasing activities
capture replace ilo_job1_eco_isic4_2digits = 77 if census == 7170                           // 77 - Rental and leasing activities
capture replace ilo_job1_eco_isic4_2digits = 77 if census == 7180                           // 77 - Rental and leasing activities
capture replace ilo_job1_eco_isic4_2digits = 77 if census == 7190                           // 77 - Rental and leasing activities
capture replace ilo_job1_eco_isic4_2digits = 69 if census == 7270                           // 69 - Legal and accounting activities
capture replace ilo_job1_eco_isic4_2digits = 69 if census == 7280                           // 69 - Legal and accounting activities
capture replace ilo_job1_eco_isic4_2digits = 71 if census == 7290                           // 71 - Architectural and engineering activities; technical testing and analysis
capture replace ilo_job1_eco_isic4_2digits = 74 if census == 7370                           // 74 - Other professional, scientific and technical activities
capture replace ilo_job1_eco_isic4_2digits = 62 if census == 7380                           // 62 - Computer programming, consultancy and related activities
capture replace ilo_job1_eco_isic4_2digits = 66 if census == 7390                           // 66 / 70 / 74 - Activities auxiliary to financial service and insurance activities
capture replace ilo_job1_eco_isic4_2digits = 72 if census == 7460                           // 72 - Scientific research and development
capture replace ilo_job1_eco_isic4_2digits = 70 if census == 7470                           // 70 / 73 - Activities of head offices; management consultancy activities
capture replace ilo_job1_eco_isic4_2digits = 75 if census == 7480                           // 75 - Veterinary activities
capture replace ilo_job1_eco_isic4_2digits = 69 if census == 7490                           // 69 / 74 / 80 / 88 - Legal and accounting activities
capture replace ilo_job1_eco_isic4_2digits = 64 if census == 7570                           // 64 / 70 - Financial service activities, except insurance and pension funding
capture replace ilo_job1_eco_isic4_2digits = 78 if census == 7580                           // 78 - Employment activities
capture replace ilo_job1_eco_isic4_2digits = 82 if census == 7590                           // 82 / 84 - Office administrative, office support and other business support activities
capture replace ilo_job1_eco_isic4_2digits = 79 if census == 7670                           // 79 - Travel agency, tour operator, reservation service and related activities
capture replace ilo_job1_eco_isic4_2digits = 80 if census == 7680                           // 80 - Security and investigation activities
capture replace ilo_job1_eco_isic4_2digits = 81 if census == 7690                           // 81 - Services to buildings and landscape activities
capture replace ilo_job1_eco_isic4_2digits = 81 if census == 7770                           // 81 - Services to buildings and landscape activities
capture replace ilo_job1_eco_isic4_2digits = 13 if census == 7780                           // 13 / 81 / 82 / 84 - Manufacture of textiles
capture replace ilo_job1_eco_isic4_2digits = 37 if census == 7790                           // 37 / 38 / 39 - Sewerage
capture replace ilo_job1_eco_isic4_2digits = 85 if census == 7860                           // 85 - Education
capture replace ilo_job1_eco_isic4_2digits = 85 if census == 7870                           // 85 - Education
capture replace ilo_job1_eco_isic4_2digits = 85 if census == 7880                           // 85 - Education
capture replace ilo_job1_eco_isic4_2digits = 85 if census == 7890                           // 85 - Education
capture replace ilo_job1_eco_isic4_2digits = 86 if census == 7970                           // 86 - Human health activities
capture replace ilo_job1_eco_isic4_2digits = 86 if census == 7980                           // 86 - Human health activities
capture replace ilo_job1_eco_isic4_2digits = 86 if census == 7990                           // 86 - Human health activities
capture replace ilo_job1_eco_isic4_2digits = 86 if census == 8070                           // 86 - Human health activities
capture replace ilo_job1_eco_isic4_2digits = 86 if census == 8080                           // 86 - Human health activities
capture replace ilo_job1_eco_isic4_2digits = 86 if census == 8090                           // 86 / 88 - Human health activities
capture replace ilo_job1_eco_isic4_2digits = 86 if census == 8170                           // 86 - Human health activities
capture replace ilo_job1_eco_isic4_2digits = 86 if census == 8180                           // 86 - Human health activities
capture replace ilo_job1_eco_isic4_2digits = 86 if census == 8190                           // 86 - Human health activities
capture replace ilo_job1_eco_isic4_2digits = 87 if census == 8270                           // 87 - Residential care activities
capture replace ilo_job1_eco_isic4_2digits = 87 if census == 8290                           // 87 - Residential care activities
capture replace ilo_job1_eco_isic4_2digits = 88 if census == 8370                           // 88 - Social work activities without accommodation
capture replace ilo_job1_eco_isic4_2digits = 88 if census == 8380                           // 88 - Social work activities without accommodation
capture replace ilo_job1_eco_isic4_2digits = 88 if census == 8390                           // 88 - Social work activities without accommodation
capture replace ilo_job1_eco_isic4_2digits = 88 if census == 8470                           // 88 - Social work activities without accommodation
capture replace ilo_job1_eco_isic4_2digits = 32 if census == 8560                           // 32 / 33 / 74 / 90 / 93 - Other manufacturing
capture replace ilo_job1_eco_isic4_2digits = 91 if census == 8570                           // 91 - Libraries, archives, museums and other cultural activities
capture replace ilo_job1_eco_isic4_2digits = 93 if census == 8580                           // 93 - Sports activities and amusement and recreation activities
capture replace ilo_job1_eco_isic4_2digits = 79 if census == 8590                           // 79 / 92 / 93 - Travel agency, tour operator, reservation service and related activities
capture replace ilo_job1_eco_isic4_2digits = 55 if census == 8660                           // 55 / 92 - Accommodation
capture replace ilo_job1_eco_isic4_2digits = 55 if census == 8670                           // 55 - Accommodation
capture replace ilo_job1_eco_isic4_2digits = 56 if census == 8680                           // 56 - Food and beverage service activities
capture replace ilo_job1_eco_isic4_2digits = 56 if census == 8690                           // 56 - Food and beverage service activities
capture replace ilo_job1_eco_isic4_2digits = 29 if census == 8770                           // 29 / 45 / 71 - Manufacture of motor vehicles, trailers and semi-trailers
capture replace ilo_job1_eco_isic4_2digits = 45 if census == 8780                           // 45 - Wholesale and retail trade and repair of motor vehicles and motorcycles
capture replace ilo_job1_eco_isic4_2digits = 33 if census == 8790                           // 33 - Repair and installation of machinery and equipment
capture replace ilo_job1_eco_isic4_2digits = 33 if census == 8870                           // 33 / 45 - Repair and installation of machinery and equipment
capture replace ilo_job1_eco_isic4_2digits = 33 if census == 8880                           // 33 / 45 - Repair and installation of machinery and equipment
capture replace ilo_job1_eco_isic4_2digits = 95 if census == 8890                           // 95 - Repair of computers and personal and household goods
capture replace ilo_job1_eco_isic4_2digits = 96 if census == 8970                           // 96 - Other personal service activities
capture replace ilo_job1_eco_isic4_2digits = 96 if census == 8980                           // 96 - Other personal service activities
capture replace ilo_job1_eco_isic4_2digits = 51 if census == 8990                           // 51 / 96 - Air transport
capture replace ilo_job1_eco_isic4_2digits = 96 if census == 9070                           // 96 - Other personal service activities
capture replace ilo_job1_eco_isic4_2digits = 96 if census == 9080                           // 96 - Other personal service activities
capture replace ilo_job1_eco_isic4_2digits = 52 if census == 9090                           // 52 / 61 / 74 / 95 / 96 - Warehousing and support activities for transportation
capture replace ilo_job1_eco_isic4_2digits = 94 if census == 9160                           // 94 - Activities of membership organizations
capture replace ilo_job1_eco_isic4_2digits = 94 if census == 9170                           // 94 - Activities of membership organizations
capture replace ilo_job1_eco_isic4_2digits = 94 if census == 9180                           // 94 - Activities of membership organizations
capture replace ilo_job1_eco_isic4_2digits = 93 if census == 9190                           // 93 / 94 - Sports activities and amusement and recreation activities
capture replace ilo_job1_eco_isic4_2digits = 97 if census == 9290                           // 97 - Activities of households as employers of domestic personnel
capture replace ilo_job1_eco_isic4_2digits = 84 if census == 9370                           // 84 - Public administration and defence; compulsory social security
capture replace ilo_job1_eco_isic4_2digits = 84 if census == 9380                           // 84 - Public administration and defence; compulsory social security
capture replace ilo_job1_eco_isic4_2digits = 84 if census == 9390                           // 84 - Public administration and defence; compulsory social security
capture replace ilo_job1_eco_isic4_2digits = 53 if census == 9470                           // 53 / 84 - Postal and courier activities
capture replace ilo_job1_eco_isic4_2digits = 84 if census == 9480                           // 84 - Public administration and defence; compulsory social security
capture replace ilo_job1_eco_isic4_2digits = 84 if census == 9490                           // 84 - Public administration and defence; compulsory social security
capture replace ilo_job1_eco_isic4_2digits = 51 if census == 9570                           // 51 / 79 / 84 - Air transport
capture replace ilo_job1_eco_isic4_2digits = 84 if census == 9590                           // 84 / 99 - Public administration and defence; compulsory social security
capture replace ilo_job1_eco_isic4_2digits = 84 if census == 9670                           // 84 - Public administration and defence; compulsory social security
capture replace ilo_job1_eco_isic4_2digits = 84 if census == 9680                           // 84 - Public administration and defence; compulsory social security
capture replace ilo_job1_eco_isic4_2digits = 84 if census == 9690                           // 84 - Public administration and defence; compulsory social security
capture replace ilo_job1_eco_isic4_2digits = 84 if census == 9770                           // 84 - Public administration and defence; compulsory social security
capture replace ilo_job1_eco_isic4_2digits = 84 if census == 9780                           // 84 - Public administration and defence; compulsory social security
capture replace ilo_job1_eco_isic4_2digits = 84 if census == 9790                           // 84 - Public administration and defence; compulsory social security
capture replace ilo_job1_eco_isic4_2digits = 84 if census == 9870                           // 84 - Public administration and defence; compulsory social security


	
********************************************************************
********************************************************************
********************************************************************
****************** Step 2 / 2 distribute census category in all others possible ISIC category: 

	
		
		
capture replace ilo_job1_eco_isic4_2digits = 2 if census == 170 & 1/4 < ilo_random_distribution & ilo_random_distribution <= 2/4
capture replace ilo_job1_eco_isic4_2digits = 3 if census == 170 & 2/4 < ilo_random_distribution & ilo_random_distribution <= 3/4
capture replace ilo_job1_eco_isic4_2digits = 10 if census == 170 & 3/4 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 3 if census == 180 & 1/2 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 3 if census == 280 & 1/2 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 2 if census == 290 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_job1_eco_isic4_2digits = 75 if census == 290 & 2/3 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 6 if census == 370 & 1/2 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 8 if census == 480 & 1/2 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 43 if census == 490 & 1/2 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 36 if census == 670 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_job1_eco_isic4_2digits = 49 if census == 670 & 2/3 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 37 if census == 690 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_job1_eco_isic4_2digits = 38 if census == 690 & 2/3 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 42 if census == 770 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_job1_eco_isic4_2digits = 43 if census == 770 & 2/3 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 8 if census == 1280 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_job1_eco_isic4_2digits = 10 if census == 1280 & 2/3 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 8 if census == 1290 & 1/4 < ilo_random_distribution & ilo_random_distribution <= 2/4
capture replace ilo_job1_eco_isic4_2digits = 10 if census == 1290 & 2/4 < ilo_random_distribution & ilo_random_distribution <= 3/4
capture replace ilo_job1_eco_isic4_2digits = 11 if census == 1290 & 3/4 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 20 if census == 1370 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_job1_eco_isic4_2digits = 35 if census == 1370 & 2/3 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 14 if census == 1480 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_job1_eco_isic4_2digits = 28 if census == 1480 & 2/3 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 22 if census == 1490 & 1/2 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 14 if census == 1590 & 1/4 < ilo_random_distribution & ilo_random_distribution <= 2/4
capture replace ilo_job1_eco_isic4_2digits = 15 if census == 1590 & 2/4 < ilo_random_distribution & ilo_random_distribution <= 3/4
capture replace ilo_job1_eco_isic4_2digits = 22 if census == 1590 & 3/4 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 14 if census == 1670 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_job1_eco_isic4_2digits = 22 if census == 1670 & 2/3 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 14 if census == 1690 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_job1_eco_isic4_2digits = 22 if census == 1690 & 2/3 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 14 if census == 1790 & 1/4 < ilo_random_distribution & ilo_random_distribution <= 2/4
capture replace ilo_job1_eco_isic4_2digits = 15 if census == 1790 & 2/4 < ilo_random_distribution & ilo_random_distribution <= 3/4
capture replace ilo_job1_eco_isic4_2digits = 22 if census == 1790 & 3/4 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 23 if census == 1870 & 1/2 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 17 if census == 1890 & 1/5 < ilo_random_distribution & ilo_random_distribution <= 2/5
capture replace ilo_job1_eco_isic4_2digits = 22 if census == 1890 & 2/5 < ilo_random_distribution & ilo_random_distribution <= 3/5
capture replace ilo_job1_eco_isic4_2digits = 24 if census == 1890 & 3/5 < ilo_random_distribution & ilo_random_distribution <= 4/5
capture replace ilo_job1_eco_isic4_2digits = 25 if census == 1890 & 4/5 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 17 if census == 1990 & 1/4 < ilo_random_distribution & ilo_random_distribution <= 2/4
capture replace ilo_job1_eco_isic4_2digits = 18 if census == 1990 & 2/4 < ilo_random_distribution & ilo_random_distribution <= 3/4
capture replace ilo_job1_eco_isic4_2digits = 25 if census == 1990 & 3/4 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 19 if census == 2090 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_job1_eco_isic4_2digits = 23 if census == 2090 & 2/3 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 22 if census == 2170 & 1/2 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 21 if census == 2190 & 1/2 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 20 if census == 2290 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_job1_eco_isic4_2digits = 21 if census == 2290 & 2/3 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 27 if census == 2370 & 1/4 < ilo_random_distribution & ilo_random_distribution <= 2/4
capture replace ilo_job1_eco_isic4_2digits = 29 if census == 2370 & 2/4 < ilo_random_distribution & ilo_random_distribution <= 3/4
capture replace ilo_job1_eco_isic4_2digits = 31 if census == 2370 & 3/4 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 27 if census == 2390 & 1/2 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 32 if census == 2590 & 1/2 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 25 if census == 2670 & 1/4 < ilo_random_distribution & ilo_random_distribution <= 2/4
capture replace ilo_job1_eco_isic4_2digits = 27 if census == 2670 & 2/4 < ilo_random_distribution & ilo_random_distribution <= 3/4
capture replace ilo_job1_eco_isic4_2digits = 30 if census == 2670 & 3/4 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 25 if census == 2680 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_job1_eco_isic4_2digits = 27 if census == 2680 & 2/3 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 25 if census == 2690 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_job1_eco_isic4_2digits = 27 if census == 2690 & 2/3 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 28 if census == 2770 & 1/2 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 27 if census == 2790 & 1/4 < ilo_random_distribution & ilo_random_distribution <= 2/4
capture replace ilo_job1_eco_isic4_2digits = 28 if census == 2790 & 2/4 < ilo_random_distribution & ilo_random_distribution <= 3/4
capture replace ilo_job1_eco_isic4_2digits = 32 if census == 2790 & 3/4 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 28 if census == 2870 & 1/4 < ilo_random_distribution & ilo_random_distribution <= 2/4
capture replace ilo_job1_eco_isic4_2digits = 29 if census == 2870 & 2/4 < ilo_random_distribution & ilo_random_distribution <= 3/4
capture replace ilo_job1_eco_isic4_2digits = 30 if census == 2870 & 3/4 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 20 if census == 2970 & 1/4 < ilo_random_distribution & ilo_random_distribution <= 2/4
capture replace ilo_job1_eco_isic4_2digits = 24 if census == 2970 & 2/4 < ilo_random_distribution & ilo_random_distribution <= 3/4
capture replace ilo_job1_eco_isic4_2digits = 25 if census == 2970 & 3/4 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 24 if census == 2980 & 1/5 < ilo_random_distribution & ilo_random_distribution <= 2/5
capture replace ilo_job1_eco_isic4_2digits = 25 if census == 2980 & 2/5 < ilo_random_distribution & ilo_random_distribution <= 3/5
capture replace ilo_job1_eco_isic4_2digits = 28 if census == 2980 & 3/5 < ilo_random_distribution & ilo_random_distribution <= 4/5
capture replace ilo_job1_eco_isic4_2digits = 32 if census == 2980 & 4/5 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 24 if census == 2990 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_job1_eco_isic4_2digits = 25 if census == 2990 & 2/3 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 30 if census == 3070 & 1/2 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 28 if census == 3090 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_job1_eco_isic4_2digits = 32 if census == 3090 & 2/3 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 27 if census == 3095 & 1/5 < ilo_random_distribution & ilo_random_distribution <= 2/5
capture replace ilo_job1_eco_isic4_2digits = 28 if census == 3095 & 2/5 < ilo_random_distribution & ilo_random_distribution <= 3/5
capture replace ilo_job1_eco_isic4_2digits = 30 if census == 3095 & 3/5 < ilo_random_distribution & ilo_random_distribution <= 4/5
capture replace ilo_job1_eco_isic4_2digits = 32 if census == 3095 & 4/5 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 28 if census == 3170 & 1/2 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 28 if census == 3180 & 1/4 < ilo_random_distribution & ilo_random_distribution <= 2/4
capture replace ilo_job1_eco_isic4_2digits = 29 if census == 3180 & 2/4 < ilo_random_distribution & ilo_random_distribution <= 3/4
capture replace ilo_job1_eco_isic4_2digits = 30 if census == 3180 & 3/4 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 28 if census == 3190 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_job1_eco_isic4_2digits = 32 if census == 3190 & 2/3 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 28 if census == 3290 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_job1_eco_isic4_2digits = 32 if census == 3290 & 2/3 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 30 if census == 3370 & 1/2 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 26 if census == 3390 & 1/2 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 23 if census == 3490 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_job1_eco_isic4_2digits = 27 if census == 3490 & 2/3 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 27 if census == 3570 & 1/4 < ilo_random_distribution & ilo_random_distribution <= 2/4
capture replace ilo_job1_eco_isic4_2digits = 28 if census == 3570 & 2/4 < ilo_random_distribution & ilo_random_distribution <= 3/4
capture replace ilo_job1_eco_isic4_2digits = 29 if census == 3570 & 3/4 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 30 if census == 3580 & 1/2 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 30 if census == 3670 & 1/2 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 33 if census == 3680 & 1/2 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 30 if census == 3690 & 1/2 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 22 if census == 3875 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_job1_eco_isic4_2digits = 31 if census == 3875 & 2/3 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 32 if census == 3890 & 1/2 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 32 if census == 3895 & 1/2 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 28 if census == 3960 & 1/4 < ilo_random_distribution & ilo_random_distribution <= 2/4
capture replace ilo_job1_eco_isic4_2digits = 30 if census == 3960 & 2/4 < ilo_random_distribution & ilo_random_distribution <= 3/4
capture replace ilo_job1_eco_isic4_2digits = 32 if census == 3960 & 3/4 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 25 if census == 3980 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_job1_eco_isic4_2digits = 32 if census == 3980 & 2/3 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 13 if census == 3990 & 1/13 < ilo_random_distribution & ilo_random_distribution <= 2/13
capture replace ilo_job1_eco_isic4_2digits = 14 if census == 3990 & 2/13 < ilo_random_distribution & ilo_random_distribution <= 3/13
capture replace ilo_job1_eco_isic4_2digits = 16 if census == 3990 & 3/13 < ilo_random_distribution & ilo_random_distribution <= 4/13
capture replace ilo_job1_eco_isic4_2digits = 20 if census == 3990 & 4/13 < ilo_random_distribution & ilo_random_distribution <= 5/13
capture replace ilo_job1_eco_isic4_2digits = 22 if census == 3990 & 5/13 < ilo_random_distribution & ilo_random_distribution <= 6/13
capture replace ilo_job1_eco_isic4_2digits = 23 if census == 3990 & 6/13 < ilo_random_distribution & ilo_random_distribution <= 7/13
capture replace ilo_job1_eco_isic4_2digits = 24 if census == 3990 & 7/13 < ilo_random_distribution & ilo_random_distribution <= 8/13
capture replace ilo_job1_eco_isic4_2digits = 25 if census == 3990 & 8/13 < ilo_random_distribution & ilo_random_distribution <= 9/13
capture replace ilo_job1_eco_isic4_2digits = 27 if census == 3990 & 9/13 < ilo_random_distribution & ilo_random_distribution <= 10/13
capture replace ilo_job1_eco_isic4_2digits = 28 if census == 3990 & 10/13 < ilo_random_distribution & ilo_random_distribution <= 11/13
capture replace ilo_job1_eco_isic4_2digits = 31 if census == 3990 & 11/13 < ilo_random_distribution & ilo_random_distribution <= 12/13
capture replace ilo_job1_eco_isic4_2digits = 32 if census == 3990 & 12/13 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 46 if census == 4070 & 1/2 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 46 if census == 4265 & 1/2 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 46 if census == 4290 & 1/2 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 46 if census == 4585 & 1/2 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 47 if census == 4680 & 1/2 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 47 if census == 4690 & 1/2 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 95 if census == 4780 & 1/2 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 47 if census == 4790 & 1/2 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 47 if census == 4795 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_job1_eco_isic4_2digits = 95 if census == 4795 & 2/3 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 95 if census == 5295 & 1/2 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 47 if census == 5390 & 1/2 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 47 if census == 5790 & 1/2 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 50 if census == 6280 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_job1_eco_isic4_2digits = 51 if census == 6280 & 2/3 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 61 if census == 6670 & 1/2 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 59 if census == 6672 & 1/4 < ilo_random_distribution & ilo_random_distribution <= 2/4
capture replace ilo_job1_eco_isic4_2digits = 60 if census == 6672 & 2/4 < ilo_random_distribution & ilo_random_distribution <= 3/4
capture replace ilo_job1_eco_isic4_2digits = 63 if census == 6672 & 3/4 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 61 if census == 6675 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_job1_eco_isic4_2digits = 63 if census == 6675 & 2/3 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 63 if census == 6692 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_job1_eco_isic4_2digits = 74 if census == 6692 & 2/3 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 74 if census == 6695 & 1/2 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 91 if census == 6780 & 1/2 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 91 if census == 6790 & 1/2 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 66 if census == 6890 & 1/2 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 65 if census == 6970 & 1/4 < ilo_random_distribution & ilo_random_distribution <= 2/4
capture replace ilo_job1_eco_isic4_2digits = 66 if census == 6970 & 2/4 < ilo_random_distribution & ilo_random_distribution <= 3/4
capture replace ilo_job1_eco_isic4_2digits = 68 if census == 6970 & 3/4 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 66 if census == 6990 & 1/2 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 70 if census == 7390 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_job1_eco_isic4_2digits = 74 if census == 7390 & 2/3 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 73 if census == 7470 & 1/2 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 74 if census == 7490 & 1/4 < ilo_random_distribution & ilo_random_distribution <= 2/4
capture replace ilo_job1_eco_isic4_2digits = 80 if census == 7490 & 2/4 < ilo_random_distribution & ilo_random_distribution <= 3/4
capture replace ilo_job1_eco_isic4_2digits = 88 if census == 7490 & 3/4 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 70 if census == 7570 & 1/2 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 84 if census == 7590 & 1/2 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 81 if census == 7780 & 1/4 < ilo_random_distribution & ilo_random_distribution <= 2/4
capture replace ilo_job1_eco_isic4_2digits = 82 if census == 7780 & 2/4 < ilo_random_distribution & ilo_random_distribution <= 3/4
capture replace ilo_job1_eco_isic4_2digits = 84 if census == 7780 & 3/4 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 38 if census == 7790 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_job1_eco_isic4_2digits = 39 if census == 7790 & 2/3 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 88 if census == 8090 & 1/2 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 33 if census == 8560 & 1/5 < ilo_random_distribution & ilo_random_distribution <= 2/5
capture replace ilo_job1_eco_isic4_2digits = 74 if census == 8560 & 2/5 < ilo_random_distribution & ilo_random_distribution <= 3/5
capture replace ilo_job1_eco_isic4_2digits = 90 if census == 8560 & 3/5 < ilo_random_distribution & ilo_random_distribution <= 4/5
capture replace ilo_job1_eco_isic4_2digits = 93 if census == 8560 & 4/5 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 92 if census == 8590 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_job1_eco_isic4_2digits = 93 if census == 8590 & 2/3 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 92 if census == 8660 & 1/2 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 45 if census == 8770 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_job1_eco_isic4_2digits = 71 if census == 8770 & 2/3 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 45 if census == 8870 & 1/2 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 45 if census == 8880 & 1/2 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 96 if census == 8990 & 1/2 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 61 if census == 9090 & 1/5 < ilo_random_distribution & ilo_random_distribution <= 2/5
capture replace ilo_job1_eco_isic4_2digits = 74 if census == 9090 & 2/5 < ilo_random_distribution & ilo_random_distribution <= 3/5
capture replace ilo_job1_eco_isic4_2digits = 95 if census == 9090 & 3/5 < ilo_random_distribution & ilo_random_distribution <= 4/5
capture replace ilo_job1_eco_isic4_2digits = 96 if census == 9090 & 4/5 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 94 if census == 9190 & 1/2 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 84 if census == 9470 & 1/2 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 79 if census == 9570 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_job1_eco_isic4_2digits = 84 if census == 9570 & 2/3 < ilo_random_distribution
capture replace ilo_job1_eco_isic4_2digits = 99 if census == 9590 & 1/2 < ilo_random_distribution



		
		replace ilo_job1_eco_isic4_2digits = . if ilo_lfs != 1
		
		

		lab def eco_isic4_2digits 1 "01 - Crop and animal production, hunting and related service activities"	2 "02 - Forestry and logging"	3 "03 - Fishing and aquaculture"	5 "05 - Mining of coal and lignite" ///
                                          6 "06 - Extraction of crude petroleum and natural gas"	7 "07 - Mining of metal ores"	8 "08 - Other mining and quarrying"	9 "09 - Mining support service activities" ///
                                          10 "10 - Manufacture of food products"	11 "11 - Manufacture of beverages"	12 "12 - Manufacture of tobacco products"	13 "13 - Manufacture of textiles" ///
                                          14 "14 - Manufacture of wearing apparel"	15 "15 - Manufacture of leather and related products"	16 "16 - Manufacture of wood and of products of wood and cork, except furniture; manufacture of articles of straw and plaiting materials"	17 "17 - Manufacture of paper and paper products" ///
                                          18 "18 - Printing and reproduction of recorded media"	19 "19 - Manufacture of coke and refined petroleum products"	20 "20 - Manufacture of chemicals and chemical products"	21 "21 - Manufacture of basic pharmaceutical products and pharmaceutical preparations" ///
                                          22 "22 - Manufacture of rubber and plastics products"	23 "23 - Manufacture of other non-metallic mineral products"	24 "24 - Manufacture of basic metals"	25 "25 - Manufacture of fabricated metal products, except machinery and equipment" ///
                                          26 "26 - Manufacture of computer, electronic and optical products"	27 "27 - Manufacture of electrical equipment"	28 "28 - Manufacture of machinery and equipment n.e.c."	29 "29 - Manufacture of motor vehicles, trailers and semi-trailers" ///
                                          30 "30 - Manufacture of other transport equipment"	31 "31 - Manufacture of furniture"	32 "32 - Other manufacturing"	33 "33 - Repair and installation of machinery and equipment" ///
                                          35 "35 - Electricity, gas, steam and air conditioning supply"	36 "36 - Water collection, treatment and supply"	37 "37 - Sewerage"	38 "38 - Waste collection, treatment and disposal activities; materials recovery" ///
                                          39 "39 - Remediation activities and other waste management services"	41 "41 - Construction of buildings"	42 "42 - Civil engineering"	43 "43 - Specialized construction activities" ///
                                          45 "45 - Wholesale and retail trade and repair of motor vehicles and motorcycles"	46 "46 - Wholesale trade, except of motor vehicles and motorcycles"	47 "47 - Retail trade, except of motor vehicles and motorcycles"	49 "49 - Land transport and transport via pipelines" ///
                                          50 "50 - Water transport"	51 "51 - Air transport"	52 "52 - Warehousing and support activities for transportation"	53 "53 - Postal and courier activities" ///
                                          55 "55 - Accommodation"	56 "56 - Food and beverage service activities"	58 "58 - Publishing activities"	59 "59 - Motion picture, video and television programme production, sound recording and music publishing activities" ///
                                          60 "60 - Programming and broadcasting activities"	61 "61 - Telecommunications"	62 "62 - Computer programming, consultancy and related activities"	63 "63 - Information service activities" ///
                                          64 "64 - Financial service activities, except insurance and pension funding"	65 "65 - Insurance, reinsurance and pension funding, except compulsory social security"	66 "66 - Activities auxiliary to financial service and insurance activities"	68 "68 - Real estate activities" ///
                                          69 "69 - Legal and accounting activities"	70 "70 - Activities of head offices; management consultancy activities"	71 "71 - Architectural and engineering activities; technical testing and analysis"	72 "72 - Scientific research and development" ///
                                          73 "73 - Advertising and market research"	74 "74 - Other professional, scientific and technical activities"	75 "75 - Veterinary activities"	77 "77 - Rental and leasing activities" ///
                                          78 "78 - Employment activities"	79 "79 - Travel agency, tour operator, reservation service and related activities"	80 "80 - Security and investigation activities"	81 "81 - Services to buildings and landscape activities" ///
                                          82 "82 - Office administrative, office support and other business support activities"	84 "84 - Public administration and defence; compulsory social security"	85 "85 - Education"	86 "86 - Human health activities" ///
                                          87 "87 - Residential care activities"	88 "88 - Social work activities without accommodation"	90 "90 - Creative, arts and entertainment activities"	91 "91 - Libraries, archives, museums and other cultural activities" ///
                                          92 "92 - Gambling and betting activities"	93 "93 - Sports activities and amusement and recreation activities"	94 "94 - Activities of membership organizations"	95 "95 - Repair of computers and personal and household goods" ///
                                          96 "96 - Other personal service activities"	97 "97 - Activities of households as employers of domestic personnel"	98 "98 - Undifferentiated goods- and services-producing activities of private households for own use"	99 "99 - Activities of extraterritorial organizations and bodies"
                lab val ilo_job1_eco_isic4_2digits eco_isic4_2digits
                lab var ilo_job1_eco_isic4_2digits "Economic activity (ISIC Rev. 4), 2 digits level - main job"

	* 1-digit level
    gen ilo_job1_eco_isic4=.
	    replace ilo_job1_eco_isic4=1 if inrange(ilo_job1_eco_isic4_2digits,1,3)
	    replace ilo_job1_eco_isic4=2 if inrange(ilo_job1_eco_isic4_2digits,5,9)
	    replace ilo_job1_eco_isic4=3 if inrange(ilo_job1_eco_isic4_2digits,10,33)
	    replace ilo_job1_eco_isic4=4 if ilo_job1_eco_isic4_2digits==35
	    replace ilo_job1_eco_isic4=5 if inrange(ilo_job1_eco_isic4_2digits,36,39)
	    replace ilo_job1_eco_isic4=6 if inrange(ilo_job1_eco_isic4_2digits,41,43)
	    replace ilo_job1_eco_isic4=7 if inrange(ilo_job1_eco_isic4_2digits,45,47)
	    replace ilo_job1_eco_isic4=8 if inrange(ilo_job1_eco_isic4_2digits,49,53)
	    replace ilo_job1_eco_isic4=9 if inrange(ilo_job1_eco_isic4_2digits,55,56)
	    replace ilo_job1_eco_isic4=10 if inrange(ilo_job1_eco_isic4_2digits,58,63)
	    replace ilo_job1_eco_isic4=11 if inrange(ilo_job1_eco_isic4_2digits,64,66)
	    replace ilo_job1_eco_isic4=12 if ilo_job1_eco_isic4_2digits==68
	    replace ilo_job1_eco_isic4=13 if inrange(ilo_job1_eco_isic4_2digits,69,75)		
	    replace ilo_job1_eco_isic4=14 if inrange(ilo_job1_eco_isic4_2digits,77,82)
	    replace ilo_job1_eco_isic4=15 if ilo_job1_eco_isic4_2digits==84
        replace ilo_job1_eco_isic4=16 if ilo_job1_eco_isic4_2digits==85
	    replace ilo_job1_eco_isic4=17 if inrange(ilo_job1_eco_isic4_2digits,86,88)
	    replace ilo_job1_eco_isic4=18 if inrange(ilo_job1_eco_isic4_2digits,90,93)
	    replace ilo_job1_eco_isic4=19 if inrange(ilo_job1_eco_isic4_2digits,94,96)
	    replace ilo_job1_eco_isic4=20 if inrange(ilo_job1_eco_isic4_2digits,97,98)
	    replace ilo_job1_eco_isic4=21 if ilo_job1_eco_isic4_2digits==99
	    replace ilo_job1_eco_isic4=22 if ilo_job1_eco_isic4==. & ilo_lfs==1
		        lab def eco_isic4_1digit 1 "A - Agriculture, forestry and fishing"	2 "B - Mining and quarrying"	3 "C - Manufacturing"	4 "D - Electricity, gas, steam and air conditioning supply" ///
                                         5 "E - Water supply; sewerage, waste management and remediation activities"	6 "F - Construction"	7 "G - Wholesale and retail trade; repair of motor vehicles and motorcycles"	8 "H - Transportation and storage" ///
                                         9 "I - Accommodation and food service activities"	10 "J - Information and communication"	11 "K - Financial and insurance activities"	12 "L - Real estate activities" ///
                                         13 "M - Professional, scientific and technical activities"	14 "N - Administrative and support service activities"	15 "O - Public administration and defence; compulsory social security"	16 "P - Education" ///
                                         17 "Q - Human health and social work activities"	18 "R - Arts, entertainment and recreation"	19 "S - Other service activities"	20 "T - Activities of households as employers; undifferentiated goods- and services-producing activities of households for own use" ///
                                         21 "U - Activities of extraterritorial organizations and bodies"	22 "X - Not elsewhere classified"		
  	  		    lab val ilo_job1_eco_isic4 eco_isic4_1digit
			    lab var ilo_job1_eco_isic4 "Economic activity (ISIC Rev. 4) - main job"

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
	
	drop census

	}			
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_job1_ocu_isco08')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------




if `Y' > 1999 {

* Comment: var PEIO1OCD apply for all then reduce to emp and une at the end of the do.
* PEIO1OCD OCCUPATION CODE FOR PRIMARY JOB.
	
	gen census = PEIO1OCD

if `Y' < 2003 & `Y' > 1999 {	
	capture replace census = NTIO1OCD // only 2000-2002 else PEIO1OCD
}

	destring census, replace
	gen ilo_job1_ocu_isco08_2digits = .
	
********************************************************************
********************************************************************
********************************************************************
****************** Step 1 / 2 map census category in first possible ISCO category: 

capture replace ilo_job1_ocu_isco08_2digits = 1 if census == 9800                            // 01 - Commissioned armed forces officers
capture replace ilo_job1_ocu_isco08_2digits = 2 if census == 9810                            // 02 - Non-commissioned armed forces officers
capture replace ilo_job1_ocu_isco08_2digits = 3 if census == 9820                            // 03 - Armed forces occupations, other ranks
capture replace ilo_job1_ocu_isco08_2digits = 3 if census == 9830                            // 03 - Armed forces occupations, other ranks
capture replace ilo_job1_ocu_isco08_2digits = 11 if census == 10                            // 11 - Chief executives, senior officials and legislators
capture replace ilo_job1_ocu_isco08_2digits = 11 if census == 20                            // 11 / 13 / 14 / 52 - Chief executives, senior officials and legislators
capture replace ilo_job1_ocu_isco08_2digits = 11 if census == 30                            // 11 - Chief executives, senior officials and legislators
capture replace ilo_job1_ocu_isco08_2digits = 11 if census == 60                            // 11 / 12 - Chief executives, senior officials and legislators
capture replace ilo_job1_ocu_isco08_2digits = 11 if census == 425                            // 11 - Chief executives, senior officials and legislators
capture replace ilo_job1_ocu_isco08_2digits = 11 if census == 430                            // 11 / 12 / 13 / 14 - Chief executives, senior officials and legislators
capture replace ilo_job1_ocu_isco08_2digits = 12 if census == 40                            // 12 - Administrative and commercial managers
capture replace ilo_job1_ocu_isco08_2digits = 12 if census == 50                            // 12 - Administrative and commercial managers
capture replace ilo_job1_ocu_isco08_2digits = 12 if census == 100                            // 12 - Administrative and commercial managers
capture replace ilo_job1_ocu_isco08_2digits = 12 if census == 120                            // 12 / 13 - Administrative and commercial managers
capture replace ilo_job1_ocu_isco08_2digits = 12 if census == 130                            // 12 - Administrative and commercial managers
capture replace ilo_job1_ocu_isco08_2digits = 12 if census == 135                            // 12 - Administrative and commercial managers
capture replace ilo_job1_ocu_isco08_2digits = 12 if census == 136                            // 12 - Administrative and commercial managers
capture replace ilo_job1_ocu_isco08_2digits = 12 if census == 137                            // 12 - Administrative and commercial managers
capture replace ilo_job1_ocu_isco08_2digits = 12 if census == 150                            // 12 - Administrative and commercial managers
capture replace ilo_job1_ocu_isco08_2digits = 12 if census == 300                            // 12 - Administrative and commercial managers
capture replace ilo_job1_ocu_isco08_2digits = 12 if census == 320                            // 12 - Administrative and commercial managers
capture replace ilo_job1_ocu_isco08_2digits = 12 if census == 325                            // 12 - Administrative and commercial managers
capture replace ilo_job1_ocu_isco08_2digits = 12 if census == 360                            // 12 - Administrative and commercial managers
capture replace ilo_job1_ocu_isco08_2digits = 12 if census == 400                            // 12 - Administrative and commercial managers
capture replace ilo_job1_ocu_isco08_2digits = 13 if census == 110                            // 13 - Production and specialised services managers
capture replace ilo_job1_ocu_isco08_2digits = 13 if census == 140                            // 13 - Production and specialised services managers
capture replace ilo_job1_ocu_isco08_2digits = 13 if census == 160                            // 13 - Production and specialised services managers
capture replace ilo_job1_ocu_isco08_2digits = 13 if census == 200                            // 13 - Production and specialised services managers
capture replace ilo_job1_ocu_isco08_2digits = 13 if census == 205                            // 13 - Production and specialised services managers
capture replace ilo_job1_ocu_isco08_2digits = 13 if census == 210                            // 13 - Production and specialised services managers
capture replace ilo_job1_ocu_isco08_2digits = 13 if census == 220                            // 13 / 71 - Production and specialised services managers
capture replace ilo_job1_ocu_isco08_2digits = 13 if census == 230                            // 13 - Production and specialised services managers
capture replace ilo_job1_ocu_isco08_2digits = 13 if census == 350                            // 13 - Production and specialised services managers
capture replace ilo_job1_ocu_isco08_2digits = 13 if census == 420                            // 13 - Production and specialised services managers
capture replace ilo_job1_ocu_isco08_2digits = 14 if census == 310                            // 14 - Hospitality, retail and other services managers
capture replace ilo_job1_ocu_isco08_2digits = 14 if census == 330                            // 14 - Hospitality, retail and other services managers
capture replace ilo_job1_ocu_isco08_2digits = 14 if census == 340                            // 14 - Hospitality, retail and other services managers
capture replace ilo_job1_ocu_isco08_2digits = 21 if census == 1200                            // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if census == 1210                            // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if census == 1220                            // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if census == 1230                            // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if census == 1300                            // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if census == 1310                            // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if census == 1320                            // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if census == 1330                            // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if census == 1340                            // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if census == 1350                            // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if census == 1360                            // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if census == 1400                            // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if census == 1410                            // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if census == 1420                            // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if census == 1430                            // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if census == 1440                            // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if census == 1450                            // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if census == 1460                            // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if census == 1500                            // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if census == 1510                            // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if census == 1520                            // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if census == 1530                            // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if census == 1600                            // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if census == 1610                            // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if census == 1640                            // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if census == 1650                            // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if census == 1660                            // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if census == 1700                            // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if census == 1710                            // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if census == 1720                            // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if census == 1740                            // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if census == 1760                            // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if census == 1810                            // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if census == 1815                            // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if census == 1840                            // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 21 if census == 2630                            // 21 - Science and engineering professionals
capture replace ilo_job1_ocu_isco08_2digits = 22 if census == 2025                            // 22 - Health professionals
capture replace ilo_job1_ocu_isco08_2digits = 22 if census == 3000                            // 22 - Health professionals
capture replace ilo_job1_ocu_isco08_2digits = 22 if census == 3010                            // 22 - Health professionals
capture replace ilo_job1_ocu_isco08_2digits = 22 if census == 3030                            // 22 - Health professionals
capture replace ilo_job1_ocu_isco08_2digits = 22 if census == 3040                            // 22 - Health professionals
capture replace ilo_job1_ocu_isco08_2digits = 22 if census == 3050                            // 22 - Health professionals
capture replace ilo_job1_ocu_isco08_2digits = 22 if census == 3060                            // 22 - Health professionals
capture replace ilo_job1_ocu_isco08_2digits = 22 if census == 3110                            // 22 - Health professionals
capture replace ilo_job1_ocu_isco08_2digits = 22 if census == 3120                            // 22 - Health professionals
capture replace ilo_job1_ocu_isco08_2digits = 22 if census == 3130                            // 22 - Health professionals
capture replace ilo_job1_ocu_isco08_2digits = 22 if census == 3140                            // 22 - Health professionals
capture replace ilo_job1_ocu_isco08_2digits = 22 if census == 3150                            // 22 - Health professionals
capture replace ilo_job1_ocu_isco08_2digits = 22 if census == 3160                            // 22 - Health professionals
capture replace ilo_job1_ocu_isco08_2digits = 22 if census == 3210                            // 22 - Health professionals
capture replace ilo_job1_ocu_isco08_2digits = 22 if census == 3230                            // 22 - Health professionals
capture replace ilo_job1_ocu_isco08_2digits = 22 if census == 3235                            // 22 - Health professionals
capture replace ilo_job1_ocu_isco08_2digits = 22 if census == 3240                            // 22 - Health professionals
capture replace ilo_job1_ocu_isco08_2digits = 22 if census == 3245                            // 22 - Health professionals
capture replace ilo_job1_ocu_isco08_2digits = 22 if census == 3250                            // 22 - Health professionals
capture replace ilo_job1_ocu_isco08_2digits = 22 if census == 3255                            // 22 - Health professionals
capture replace ilo_job1_ocu_isco08_2digits = 22 if census == 3256                            // 22 - Health professionals
capture replace ilo_job1_ocu_isco08_2digits = 22 if census == 3257                            // 22 - Health professionals
capture replace ilo_job1_ocu_isco08_2digits = 22 if census == 3258                            // 22 - Health professionals
capture replace ilo_job1_ocu_isco08_2digits = 22 if census == 3260                            // 22 / 32 - Health professionals
capture replace ilo_job1_ocu_isco08_2digits = 23 if census == 650                            // 23 / 24 - Teaching professionals
capture replace ilo_job1_ocu_isco08_2digits = 23 if census == 2200                            // 23 - Teaching professionals
capture replace ilo_job1_ocu_isco08_2digits = 23 if census == 2300                            // 23 - Teaching professionals
capture replace ilo_job1_ocu_isco08_2digits = 23 if census == 2310                            // 23 - Teaching professionals
capture replace ilo_job1_ocu_isco08_2digits = 23 if census == 2320                            // 23 - Teaching professionals
capture replace ilo_job1_ocu_isco08_2digits = 23 if census == 2330                            // 23 - Teaching professionals
capture replace ilo_job1_ocu_isco08_2digits = 23 if census == 2340                            // 23 - Teaching professionals
capture replace ilo_job1_ocu_isco08_2digits = 23 if census == 2550                            // 23 - Teaching professionals
capture replace ilo_job1_ocu_isco08_2digits = 24 if census == 620                            // 24 / 33 - Business and administration professionals
capture replace ilo_job1_ocu_isco08_2digits = 24 if census == 630                            // 24 / 33 - Business and administration professionals
capture replace ilo_job1_ocu_isco08_2digits = 24 if census == 640                            // 24 - Business and administration professionals
capture replace ilo_job1_ocu_isco08_2digits = 24 if census == 700                            // 24 - Business and administration professionals
capture replace ilo_job1_ocu_isco08_2digits = 24 if census == 710                            // 24 - Business and administration professionals
capture replace ilo_job1_ocu_isco08_2digits = 24 if census == 730                            // 24 / 33 - Business and administration professionals
capture replace ilo_job1_ocu_isco08_2digits = 24 if census == 735                            // 24 - Business and administration professionals
capture replace ilo_job1_ocu_isco08_2digits = 24 if census == 740                            // 24 / 33 - Business and administration professionals
capture replace ilo_job1_ocu_isco08_2digits = 24 if census == 800                            // 24 - Business and administration professionals
capture replace ilo_job1_ocu_isco08_2digits = 24 if census == 820                            // 24 - Business and administration professionals
capture replace ilo_job1_ocu_isco08_2digits = 24 if census == 830                            // 24 - Business and administration professionals
capture replace ilo_job1_ocu_isco08_2digits = 24 if census == 840                            // 24 - Business and administration professionals
capture replace ilo_job1_ocu_isco08_2digits = 24 if census == 850                            // 24 - Business and administration professionals
capture replace ilo_job1_ocu_isco08_2digits = 24 if census == 900                            // 24 - Business and administration professionals
capture replace ilo_job1_ocu_isco08_2digits = 24 if census == 940                            // 24 - Business and administration professionals
capture replace ilo_job1_ocu_isco08_2digits = 24 if census == 2800                            // 24 - Business and administration professionals
capture replace ilo_job1_ocu_isco08_2digits = 24 if census == 2820                            // 24 - Business and administration professionals
capture replace ilo_job1_ocu_isco08_2digits = 24 if census == 2825                            // 24 - Business and administration professionals
capture replace ilo_job1_ocu_isco08_2digits = 24 if census == 2850                            // 24 / 26 - Business and administration professionals
capture replace ilo_job1_ocu_isco08_2digits = 24 if census == 4710                            // 24 / 33 / 42 - Business and administration professionals
capture replace ilo_job1_ocu_isco08_2digits = 24 if census == 4850                            // 24 / 33 - Business and administration professionals
capture replace ilo_job1_ocu_isco08_2digits = 24 if census == 4930                            // 24 - Business and administration professionals
capture replace ilo_job1_ocu_isco08_2digits = 25 if census == 1000                            // 25 - Information and communications technology professionals
capture replace ilo_job1_ocu_isco08_2digits = 25 if census == 1005                            // 25 - Information and communications technology professionals
capture replace ilo_job1_ocu_isco08_2digits = 25 if census == 1006                            // 25 - Information and communications technology professionals
capture replace ilo_job1_ocu_isco08_2digits = 25 if census == 1007                            // 25 - Information and communications technology professionals
capture replace ilo_job1_ocu_isco08_2digits = 25 if census == 1010                            // 25 - Information and communications technology professionals
capture replace ilo_job1_ocu_isco08_2digits = 25 if census == 1020                            // 25 - Information and communications technology professionals
capture replace ilo_job1_ocu_isco08_2digits = 25 if census == 1030                            // 25 / 35 - Information and communications technology professionals
capture replace ilo_job1_ocu_isco08_2digits = 25 if census == 1060                            // 25 - Information and communications technology professionals
capture replace ilo_job1_ocu_isco08_2digits = 25 if census == 1100                            // 25 / 35 - Information and communications technology professionals
capture replace ilo_job1_ocu_isco08_2digits = 25 if census == 1105                            // 25 / 35 - Information and communications technology professionals
capture replace ilo_job1_ocu_isco08_2digits = 25 if census == 1106                            // 25 - Information and communications technology professionals
capture replace ilo_job1_ocu_isco08_2digits = 25 if census == 1107                            // 25 - Information and communications technology professionals
capture replace ilo_job1_ocu_isco08_2digits = 25 if census == 1110                            // 25 - Information and communications technology professionals
capture replace ilo_job1_ocu_isco08_2digits = 26 if census == 1800                            // 26 - Legal, social and cultural professionals
capture replace ilo_job1_ocu_isco08_2digits = 26 if census == 1820                            // 26 - Legal, social and cultural professionals
capture replace ilo_job1_ocu_isco08_2digits = 26 if census == 1830                            // 26 - Legal, social and cultural professionals
capture replace ilo_job1_ocu_isco08_2digits = 26 if census == 1860                            // 26 - Legal, social and cultural professionals
capture replace ilo_job1_ocu_isco08_2digits = 26 if census == 2000                            // 26 - Legal, social and cultural professionals
capture replace ilo_job1_ocu_isco08_2digits = 26 if census == 2010                            // 26 - Legal, social and cultural professionals
capture replace ilo_job1_ocu_isco08_2digits = 26 if census == 2015                            // 26 - Legal, social and cultural professionals
capture replace ilo_job1_ocu_isco08_2digits = 26 if census == 2020                            // 26 - Legal, social and cultural professionals
capture replace ilo_job1_ocu_isco08_2digits = 26 if census == 2040                            // 26 - Legal, social and cultural professionals
capture replace ilo_job1_ocu_isco08_2digits = 26 if census == 2050                            // 26 - Legal, social and cultural professionals
capture replace ilo_job1_ocu_isco08_2digits = 26 if census == 2100                            // 26 - Legal, social and cultural professionals
capture replace ilo_job1_ocu_isco08_2digits = 26 if census == 2110                            // 26 - Legal, social and cultural professionals
capture replace ilo_job1_ocu_isco08_2digits = 26 if census == 2400                            // 26 - Legal, social and cultural professionals
capture replace ilo_job1_ocu_isco08_2digits = 26 if census == 2430                            // 26 - Legal, social and cultural professionals
capture replace ilo_job1_ocu_isco08_2digits = 26 if census == 2600                            // 26 - Legal, social and cultural professionals
capture replace ilo_job1_ocu_isco08_2digits = 26 if census == 2700                            // 26 - Legal, social and cultural professionals
capture replace ilo_job1_ocu_isco08_2digits = 26 if census == 2710                            // 26 - Legal, social and cultural professionals
capture replace ilo_job1_ocu_isco08_2digits = 26 if census == 2740                            // 26 - Legal, social and cultural professionals
capture replace ilo_job1_ocu_isco08_2digits = 26 if census == 2750                            // 26 - Legal, social and cultural professionals
capture replace ilo_job1_ocu_isco08_2digits = 26 if census == 2760                            // 26 / 34 / 51 - Legal, social and cultural professionals
capture replace ilo_job1_ocu_isco08_2digits = 26 if census == 2810                            // 26 - Legal, social and cultural professionals
capture replace ilo_job1_ocu_isco08_2digits = 26 if census == 2830                            // 26 - Legal, social and cultural professionals
capture replace ilo_job1_ocu_isco08_2digits = 26 if census == 2840                            // 26 - Legal, social and cultural professionals
capture replace ilo_job1_ocu_isco08_2digits = 31 if census == 1540                            // 31 - Science and engineering associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 31 if census == 1550                            // 31 - Science and engineering associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 31 if census == 1560                            // 31 - Science and engineering associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 31 if census == 1900                            // 31 - Science and engineering associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 31 if census == 1910                            // 31 - Science and engineering associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 31 if census == 1920                            // 31 - Science and engineering associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 31 if census == 1930                            // 31 - Science and engineering associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 31 if census == 1940                            // 31 - Science and engineering associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 31 if census == 1965                            // 31 - Science and engineering associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 31 if census == 3720                            // 31 / 54 - Science and engineering associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 31 if census == 3750                            // 31 - Science and engineering associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 31 if census == 6200                            // 31 - Science and engineering associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 31 if census == 6660                            // 31 - Science and engineering associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 31 if census == 7700                            // 31 - Science and engineering associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 31 if census == 8040                            // 31 / 81 - Science and engineering associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 31 if census == 8600                            // 31 - Science and engineering associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 31 if census == 8620                            // 31 - Science and engineering associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 31 if census == 8630                            // 31 / 81 - Science and engineering associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 31 if census == 9030                            // 31 - Science and engineering associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 31 if census == 9040                            // 31 - Science and engineering associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 31 if census == 9310                            // 31 - Science and engineering associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 31 if census == 9330                            // 31 - Science and engineering associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 31 if census == 9650                            // 31 - Science and engineering associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 32 if census == 3200                            // 32 - Health associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 32 if census == 3220                            // 32 - Health associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 32 if census == 3300                            // 32 - Health associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 32 if census == 3310                            // 32 - Health associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 32 if census == 3320                            // 32 - Health associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 32 if census == 3400                            // 32 - Health associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 32 if census == 3410                            // 32 - Health associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 32 if census == 3420                            // 32 - Health associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 32 if census == 3500                            // 32 - Health associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 32 if census == 3510                            // 32 - Health associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 32 if census == 3520                            // 32 - Health associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 32 if census == 3530                            // 32 - Health associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 32 if census == 3535                            // 32 - Health associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 32 if census == 3540                            // 32 - Health associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 32 if census == 3610                            // 32 - Health associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 32 if census == 3620                            // 32 - Health associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 32 if census == 3630                            // 32 - Health associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 32 if census == 3640                            // 32 / 53 - Health associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 32 if census == 3645                            // 32 - Health associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 32 if census == 3648                            // 32 / 51 - Health associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 32 if census == 3650                            // 32 - Health associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 32 if census == 3655                            // 32 / 53 - Health associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 32 if census == 6010                            // 32 / 33 / 75 - Health associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 32 if census == 8760                            // 32 - Health associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 32 if census == 9410                            // 32 - Health associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if census == 410                            // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if census == 500                            // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if census == 510                            // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if census == 520                            // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if census == 530                            // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if census == 540                            // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if census == 560                            // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if census == 565                            // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if census == 600                            // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if census == 720                            // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if census == 725                            // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if census == 810                            // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if census == 860                            // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if census == 910                            // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if census == 930                            // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if census == 950                            // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if census == 1240                            // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if census == 1950                            // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if census == 1960                            // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if census == 3646                            // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if census == 3710                            // 33 / 54 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if census == 3820                            // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if census == 3850                            // 33 / 54 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if census == 4800                            // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if census == 4810                            // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if census == 4820                            // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if census == 4830                            // 33 / 42 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if census == 4840                            // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if census == 4920                            // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if census == 4960                            // 33 / 42 / 52 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if census == 4965                            // 33 / 42 / 52 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if census == 5000                            // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if census == 5120                            // 33 / 43 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if census == 5220                            // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if census == 5250                            // 33 / 42 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if census == 5500                            // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if census == 5610                            // 33 / 43 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 33 if census == 5920                            // 33 - Business and administration associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 34 if census == 2016                            // 34 - Legal, social, cultural and related associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 34 if census == 2060                            // 34 - Legal, social, cultural and related associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 34 if census == 2105                            // 34 - Legal, social, cultural and related associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 34 if census == 2140                            // 34 - Legal, social, cultural and related associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 34 if census == 2145                            // 34 - Legal, social, cultural and related associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 34 if census == 2150                            // 34 - Legal, social, cultural and related associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 34 if census == 2160                            // 34 - Legal, social, cultural and related associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 34 if census == 2440                            // 34 / 44 - Legal, social, cultural and related associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 34 if census == 2720                            // 34 - Legal, social, cultural and related associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 34 if census == 2860                            // 34 - Legal, social, cultural and related associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 34 if census == 2910                            // 34 - Legal, social, cultural and related associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 34 if census == 2960                            // 34 / 35 - Legal, social, cultural and related associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 34 if census == 3800                            // 34 - Legal, social, cultural and related associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 34 if census == 3910                            // 34 - Legal, social, cultural and related associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 34 if census == 3920                            // 34 / 54 - Legal, social, cultural and related associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 34 if census == 4000                            // 34 - Legal, social, cultural and related associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 34 if census == 4010                            // 34 / 51 - Legal, social, cultural and related associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 34 if census == 4320                            // 34 / 44 / 51 / 53 - Legal, social, cultural and related associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 34 if census == 4430                            // 34 - Legal, social, cultural and related associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 34 if census == 4620                            // 34 - Legal, social, cultural and related associate professionals
capture replace ilo_job1_ocu_isco08_2digits = 35 if census == 1040                            // 35 - Information and communications technicians
capture replace ilo_job1_ocu_isco08_2digits = 35 if census == 1050                            // 35 - Information and communications technicians
capture replace ilo_job1_ocu_isco08_2digits = 35 if census == 2900                            // 35 - Information and communications technicians
capture replace ilo_job1_ocu_isco08_2digits = 35 if census == 2920                            // 35 - Information and communications technicians
capture replace ilo_job1_ocu_isco08_2digits = 35 if census == 5800                            // 35 - Information and communications technicians
capture replace ilo_job1_ocu_isco08_2digits = 41 if census == 5150                            // 41 - General and keyboard clerks
capture replace ilo_job1_ocu_isco08_2digits = 41 if census == 5700                            // 41 - General and keyboard clerks
capture replace ilo_job1_ocu_isco08_2digits = 41 if census == 5810                            // 41 - General and keyboard clerks
capture replace ilo_job1_ocu_isco08_2digits = 41 if census == 5820                            // 41 - General and keyboard clerks
capture replace ilo_job1_ocu_isco08_2digits = 41 if census == 5860                            // 41 - General and keyboard clerks
capture replace ilo_job1_ocu_isco08_2digits = 42 if census == 726                            // 42 - Customer services clerks
capture replace ilo_job1_ocu_isco08_2digits = 42 if census == 4300                            // 42 - Customer services clerks
capture replace ilo_job1_ocu_isco08_2digits = 42 if census == 4400                            // 42 - Customer services clerks
capture replace ilo_job1_ocu_isco08_2digits = 42 if census == 5010                            // 42 - Customer services clerks
capture replace ilo_job1_ocu_isco08_2digits = 42 if census == 5020                            // 42 - Customer services clerks
capture replace ilo_job1_ocu_isco08_2digits = 42 if census == 5030                            // 42 - Customer services clerks
capture replace ilo_job1_ocu_isco08_2digits = 42 if census == 5100                            // 42 - Customer services clerks
capture replace ilo_job1_ocu_isco08_2digits = 42 if census == 5130                            // 42 - Customer services clerks
capture replace ilo_job1_ocu_isco08_2digits = 42 if census == 5160                            // 42 - Customer services clerks
capture replace ilo_job1_ocu_isco08_2digits = 42 if census == 5165                            // 42 / 43 - Customer services clerks
capture replace ilo_job1_ocu_isco08_2digits = 42 if census == 5210                            // 42 / 44 - Customer services clerks
capture replace ilo_job1_ocu_isco08_2digits = 42 if census == 5240                            // 42 - Customer services clerks
capture replace ilo_job1_ocu_isco08_2digits = 42 if census == 5300                            // 42 - Customer services clerks
capture replace ilo_job1_ocu_isco08_2digits = 42 if census == 5310                            // 42 - Customer services clerks
capture replace ilo_job1_ocu_isco08_2digits = 42 if census == 5400                            // 42 - Customer services clerks
capture replace ilo_job1_ocu_isco08_2digits = 42 if census == 5410                            // 42 - Customer services clerks
capture replace ilo_job1_ocu_isco08_2digits = 42 if census == 5420                            // 42 / 44 - Customer services clerks
capture replace ilo_job1_ocu_isco08_2digits = 42 if census == 5540                            // 42 / 44 - Customer services clerks
capture replace ilo_job1_ocu_isco08_2digits = 43 if census == 5110                            // 43 - Numerical and material recording clerks
capture replace ilo_job1_ocu_isco08_2digits = 43 if census == 5140                            // 43 - Numerical and material recording clerks
capture replace ilo_job1_ocu_isco08_2digits = 43 if census == 5200                            // 43 - Numerical and material recording clerks
capture replace ilo_job1_ocu_isco08_2digits = 43 if census == 5230                            // 43 - Numerical and material recording clerks
capture replace ilo_job1_ocu_isco08_2digits = 43 if census == 5330                            // 43 - Numerical and material recording clerks
capture replace ilo_job1_ocu_isco08_2digits = 43 if census == 5340                            // 43 - Numerical and material recording clerks
capture replace ilo_job1_ocu_isco08_2digits = 43 if census == 5600                            // 43 - Numerical and material recording clerks
capture replace ilo_job1_ocu_isco08_2digits = 43 if census == 5620                            // 43 / 93 - Numerical and material recording clerks
capture replace ilo_job1_ocu_isco08_2digits = 43 if census == 5630                            // 43 - Numerical and material recording clerks
capture replace ilo_job1_ocu_isco08_2digits = 43 if census == 5840                            // 43 - Numerical and material recording clerks
capture replace ilo_job1_ocu_isco08_2digits = 44 if census == 4610                            // 44 / 51 / 53 - Other clerical support workers
capture replace ilo_job1_ocu_isco08_2digits = 44 if census == 5260                            // 44 - Other clerical support workers
capture replace ilo_job1_ocu_isco08_2digits = 44 if census == 5320                            // 44 - Other clerical support workers
capture replace ilo_job1_ocu_isco08_2digits = 44 if census == 5350                            // 44 - Other clerical support workers
capture replace ilo_job1_ocu_isco08_2digits = 44 if census == 5360                            // 44 - Other clerical support workers
capture replace ilo_job1_ocu_isco08_2digits = 44 if census == 5510                            // 44 / 83 / 93 / 96 - Other clerical support workers
capture replace ilo_job1_ocu_isco08_2digits = 44 if census == 5550                            // 44 - Other clerical support workers
capture replace ilo_job1_ocu_isco08_2digits = 44 if census == 5560                            // 44 - Other clerical support workers
capture replace ilo_job1_ocu_isco08_2digits = 44 if census == 5850                            // 44 - Other clerical support workers
capture replace ilo_job1_ocu_isco08_2digits = 44 if census == 5900                            // 44 - Other clerical support workers
capture replace ilo_job1_ocu_isco08_2digits = 44 if census == 5910                            // 44 - Other clerical support workers
capture replace ilo_job1_ocu_isco08_2digits = 44 if census == 5930                            // 44 - Other clerical support workers
capture replace ilo_job1_ocu_isco08_2digits = 44 if census == 5940                            // 44 - Other clerical support workers
capture replace ilo_job1_ocu_isco08_2digits = 51 if census == 4020                            // 51 - Personal service workers
capture replace ilo_job1_ocu_isco08_2digits = 51 if census == 4040                            // 51 - Personal service workers
capture replace ilo_job1_ocu_isco08_2digits = 51 if census == 4110                            // 51 - Personal service workers
capture replace ilo_job1_ocu_isco08_2digits = 51 if census == 4120                            // 51 / 52 - Personal service workers
capture replace ilo_job1_ocu_isco08_2digits = 51 if census == 4150                            // 51 - Personal service workers
capture replace ilo_job1_ocu_isco08_2digits = 51 if census == 4200                            // 51 - Personal service workers
capture replace ilo_job1_ocu_isco08_2digits = 51 if census == 4220                            // 51 / 91 - Personal service workers
capture replace ilo_job1_ocu_isco08_2digits = 51 if census == 4340                            // 51 - Personal service workers
capture replace ilo_job1_ocu_isco08_2digits = 51 if census == 4350                            // 51 - Personal service workers
capture replace ilo_job1_ocu_isco08_2digits = 51 if census == 4460                            // 51 - Personal service workers
capture replace ilo_job1_ocu_isco08_2digits = 51 if census == 4465                            // 51 - Personal service workers
capture replace ilo_job1_ocu_isco08_2digits = 51 if census == 4500                            // 51 - Personal service workers
capture replace ilo_job1_ocu_isco08_2digits = 51 if census == 4510                            // 51 - Personal service workers
capture replace ilo_job1_ocu_isco08_2digits = 51 if census == 4520                            // 51 - Personal service workers
capture replace ilo_job1_ocu_isco08_2digits = 51 if census == 4540                            // 51 - Personal service workers
capture replace ilo_job1_ocu_isco08_2digits = 51 if census == 4550                            // 51 - Personal service workers
capture replace ilo_job1_ocu_isco08_2digits = 51 if census == 4640                            // 51 - Personal service workers
capture replace ilo_job1_ocu_isco08_2digits = 51 if census == 4650                            // 51 / 95 - Personal service workers
capture replace ilo_job1_ocu_isco08_2digits = 51 if census == 9050                            // 51 - Personal service workers
capture replace ilo_job1_ocu_isco08_2digits = 51 if census == 9415                            // 51 - Personal service workers
capture replace ilo_job1_ocu_isco08_2digits = 52 if census == 4050                            // 52 - Sales workers
capture replace ilo_job1_ocu_isco08_2digits = 52 if census == 4060                            // 52 - Sales workers
capture replace ilo_job1_ocu_isco08_2digits = 52 if census == 4130                            // 52 / 94 - Sales workers
capture replace ilo_job1_ocu_isco08_2digits = 52 if census == 4700                            // 52 - Sales workers
capture replace ilo_job1_ocu_isco08_2digits = 52 if census == 4720                            // 52 - Sales workers
capture replace ilo_job1_ocu_isco08_2digits = 52 if census == 4740                            // 52 - Sales workers
capture replace ilo_job1_ocu_isco08_2digits = 52 if census == 4750                            // 52 - Sales workers
capture replace ilo_job1_ocu_isco08_2digits = 52 if census == 4760                            // 52 - Sales workers
capture replace ilo_job1_ocu_isco08_2digits = 52 if census == 4900                            // 52 - Sales workers
capture replace ilo_job1_ocu_isco08_2digits = 52 if census == 4940                            // 52 - Sales workers
capture replace ilo_job1_ocu_isco08_2digits = 52 if census == 4950                            // 52 / 95 - Sales workers
capture replace ilo_job1_ocu_isco08_2digits = 52 if census == 9360                            // 52 - Sales workers
capture replace ilo_job1_ocu_isco08_2digits = 53 if census == 2540                            // 53 - Personal care workers
capture replace ilo_job1_ocu_isco08_2digits = 53 if census == 3600                            // 53 - Personal care workers
capture replace ilo_job1_ocu_isco08_2digits = 53 if census == 3647                            // 53 - Personal care workers
capture replace ilo_job1_ocu_isco08_2digits = 53 if census == 3649                            // 53 - Personal care workers
capture replace ilo_job1_ocu_isco08_2digits = 53 if census == 4600                            // 53 - Personal care workers
capture replace ilo_job1_ocu_isco08_2digits = 54 if census == 3700                            // 54 - Protective services workers
capture replace ilo_job1_ocu_isco08_2digits = 54 if census == 3730                            // 54 - Protective services workers
capture replace ilo_job1_ocu_isco08_2digits = 54 if census == 3740                            // 54 - Protective services workers
capture replace ilo_job1_ocu_isco08_2digits = 54 if census == 3830                            // 54 - Protective services workers
capture replace ilo_job1_ocu_isco08_2digits = 54 if census == 3840                            // 54 - Protective services workers
capture replace ilo_job1_ocu_isco08_2digits = 54 if census == 3860                            // 54 - Protective services workers
capture replace ilo_job1_ocu_isco08_2digits = 54 if census == 3900                            // 54 - Protective services workers
capture replace ilo_job1_ocu_isco08_2digits = 54 if census == 3930                            // 54 - Protective services workers
capture replace ilo_job1_ocu_isco08_2digits = 54 if census == 3940                            // 54 - Protective services workers
capture replace ilo_job1_ocu_isco08_2digits = 54 if census == 3945                            // 54 - Protective services workers
capture replace ilo_job1_ocu_isco08_2digits = 54 if census == 3950                            // 54 - Protective services workers
capture replace ilo_job1_ocu_isco08_2digits = 54 if census == 3955                            // 54 - Protective services workers
capture replace ilo_job1_ocu_isco08_2digits = 54 if census == 5520                            // 54 - Protective services workers
capture replace ilo_job1_ocu_isco08_2digits = 61 if census == 4210                            // 61 / 75 - Market-oriented skilled agricultural workers
capture replace ilo_job1_ocu_isco08_2digits = 61 if census == 6000                            // 61 / 62 - Market-oriented skilled agricultural workers
capture replace ilo_job1_ocu_isco08_2digits = 61 if census == 6005                            // 61 / 62 - Market-oriented skilled agricultural workers
capture replace ilo_job1_ocu_isco08_2digits = 61 if census == 6020                            // 61 / 62 - Market-oriented skilled agricultural workers
capture replace ilo_job1_ocu_isco08_2digits = 62 if census == 6100                            // 62 / 63 / 92 - Market-oriented skilled forestry, fishery and hunting workers
capture replace ilo_job1_ocu_isco08_2digits = 62 if census == 6110                            // 62 / 63 - Market-oriented skilled forestry, fishery and hunting workers
capture replace ilo_job1_ocu_isco08_2digits = 62 if census == 6120                            // 62 / 92 - Market-oriented skilled forestry, fishery and hunting workers
capture replace ilo_job1_ocu_isco08_2digits = 62 if census == 6130                            // 62 / 83 - Market-oriented skilled forestry, fishery and hunting workers
capture replace ilo_job1_ocu_isco08_2digits = 71 if census == 6220                            // 71 - Building and related trades workers, excluding electricians
capture replace ilo_job1_ocu_isco08_2digits = 71 if census == 6230                            // 71 - Building and related trades workers, excluding electricians
capture replace ilo_job1_ocu_isco08_2digits = 71 if census == 6240                            // 71 - Building and related trades workers, excluding electricians
capture replace ilo_job1_ocu_isco08_2digits = 71 if census == 6250                            // 71 - Building and related trades workers, excluding electricians
capture replace ilo_job1_ocu_isco08_2digits = 71 if census == 6330                            // 71 - Building and related trades workers, excluding electricians
capture replace ilo_job1_ocu_isco08_2digits = 71 if census == 6360                            // 71 - Building and related trades workers, excluding electricians
capture replace ilo_job1_ocu_isco08_2digits = 71 if census == 6400                            // 71 - Building and related trades workers, excluding electricians
capture replace ilo_job1_ocu_isco08_2digits = 71 if census == 6420                            // 71 - Building and related trades workers, excluding electricians
capture replace ilo_job1_ocu_isco08_2digits = 71 if census == 6430                            // 71 - Building and related trades workers, excluding electricians
capture replace ilo_job1_ocu_isco08_2digits = 71 if census == 6440                            // 71 - Building and related trades workers, excluding electricians
capture replace ilo_job1_ocu_isco08_2digits = 71 if census == 6460                            // 71 - Building and related trades workers, excluding electricians
capture replace ilo_job1_ocu_isco08_2digits = 71 if census == 6510                            // 71 - Building and related trades workers, excluding electricians
capture replace ilo_job1_ocu_isco08_2digits = 71 if census == 6515                            // 71 - Building and related trades workers, excluding electricians
capture replace ilo_job1_ocu_isco08_2digits = 71 if census == 6540                            // 71 / 74 - Building and related trades workers, excluding electricians
capture replace ilo_job1_ocu_isco08_2digits = 71 if census == 6710                            // 71 - Building and related trades workers, excluding electricians
capture replace ilo_job1_ocu_isco08_2digits = 71 if census == 6720                            // 71 - Building and related trades workers, excluding electricians
capture replace ilo_job1_ocu_isco08_2digits = 71 if census == 6760                            // 71 - Building and related trades workers, excluding electricians
capture replace ilo_job1_ocu_isco08_2digits = 71 if census == 6765                            // 71 - Building and related trades workers, excluding electricians
capture replace ilo_job1_ocu_isco08_2digits = 71 if census == 7000                            // 71 / 72 / 73 / 74 - Building and related trades workers, excluding electricians
capture replace ilo_job1_ocu_isco08_2digits = 71 if census == 7310                            // 71 - Building and related trades workers, excluding electricians
capture replace ilo_job1_ocu_isco08_2digits = 71 if census == 7315                            // 71 - Building and related trades workers, excluding electricians
capture replace ilo_job1_ocu_isco08_2digits = 71 if census == 7550                            // 71 - Building and related trades workers, excluding electricians
capture replace ilo_job1_ocu_isco08_2digits = 71 if census == 8810                            // 71 / 81 - Building and related trades workers, excluding electricians
capture replace ilo_job1_ocu_isco08_2digits = 72 if census == 6210                            // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if census == 6500                            // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if census == 6520                            // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if census == 6530                            // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if census == 7140                            // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if census == 7150                            // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if census == 7160                            // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if census == 7200                            // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if census == 7210                            // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if census == 7220                            // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if census == 7240                            // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if census == 7260                            // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if census == 7330                            // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if census == 7350                            // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if census == 7360                            // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if census == 7440                            // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if census == 7540                            // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if census == 7560                            // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if census == 7740                            // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if census == 7900                            // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if census == 7920                            // 72 / 81 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if census == 7930                            // 72 / 81 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if census == 7940                            // 72 / 81 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if census == 7950                            // 72 / 81 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if census == 7960                            // 72 / 81 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if census == 8000                            // 72 / 81 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if census == 8010                            // 72 / 81 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if census == 8020                            // 72 / 81 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if census == 8030                            // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if census == 8060                            // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if census == 8100                            // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if census == 8120                            // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if census == 8130                            // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if census == 8140                            // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if census == 8160                            // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if census == 8210                            // 72 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 72 if census == 8220                            // 72 / 81 - Metal, machinery and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 73 if census == 5830                            // 73 - Handicraft and printing workers
capture replace ilo_job1_ocu_isco08_2digits = 73 if census == 7430                            // 73 - Handicraft and printing workers
capture replace ilo_job1_ocu_isco08_2digits = 73 if census == 8230                            // 73 - Handicraft and printing workers
capture replace ilo_job1_ocu_isco08_2digits = 73 if census == 8240                            // 73 - Handicraft and printing workers
capture replace ilo_job1_ocu_isco08_2digits = 73 if census == 8250                            // 73 - Handicraft and printing workers
capture replace ilo_job1_ocu_isco08_2digits = 73 if census == 8255                            // 73 - Handicraft and printing workers
capture replace ilo_job1_ocu_isco08_2digits = 73 if census == 8256                            // 73 - Handicraft and printing workers
capture replace ilo_job1_ocu_isco08_2digits = 73 if census == 8260                            // 73 - Handicraft and printing workers
capture replace ilo_job1_ocu_isco08_2digits = 73 if census == 8330                            // 73 / 75 - Handicraft and printing workers
capture replace ilo_job1_ocu_isco08_2digits = 73 if census == 8550                            // 73 - Handicraft and printing workers
capture replace ilo_job1_ocu_isco08_2digits = 73 if census == 8710                            // 73 / 75 - Handicraft and printing workers
capture replace ilo_job1_ocu_isco08_2digits = 73 if census == 8750                            // 73 - Handicraft and printing workers
capture replace ilo_job1_ocu_isco08_2digits = 73 if census == 8910                            // 73 / 82 - Handicraft and printing workers
capture replace ilo_job1_ocu_isco08_2digits = 73 if census == 8920                            // 73 / 75 / 81 - Handicraft and printing workers
capture replace ilo_job1_ocu_isco08_2digits = 74 if census == 6350                            // 74 - Electrical and electronic trades workers
capture replace ilo_job1_ocu_isco08_2digits = 74 if census == 6355                            // 74 - Electrical and electronic trades workers
capture replace ilo_job1_ocu_isco08_2digits = 74 if census == 6700                            // 74 - Electrical and electronic trades workers
capture replace ilo_job1_ocu_isco08_2digits = 74 if census == 7010                            // 74 - Electrical and electronic trades workers
capture replace ilo_job1_ocu_isco08_2digits = 74 if census == 7020                            // 74 - Electrical and electronic trades workers
capture replace ilo_job1_ocu_isco08_2digits = 74 if census == 7030                            // 74 - Electrical and electronic trades workers
capture replace ilo_job1_ocu_isco08_2digits = 74 if census == 7040                            // 74 - Electrical and electronic trades workers
capture replace ilo_job1_ocu_isco08_2digits = 74 if census == 7050                            // 74 - Electrical and electronic trades workers
capture replace ilo_job1_ocu_isco08_2digits = 74 if census == 7100                            // 74 - Electrical and electronic trades workers
capture replace ilo_job1_ocu_isco08_2digits = 74 if census == 7110                            // 74 - Electrical and electronic trades workers
capture replace ilo_job1_ocu_isco08_2digits = 74 if census == 7120                            // 74 - Electrical and electronic trades workers
capture replace ilo_job1_ocu_isco08_2digits = 74 if census == 7130                            // 74 - Electrical and electronic trades workers
capture replace ilo_job1_ocu_isco08_2digits = 74 if census == 7300                            // 74 - Electrical and electronic trades workers
capture replace ilo_job1_ocu_isco08_2digits = 74 if census == 7320                            // 74 - Electrical and electronic trades workers
capture replace ilo_job1_ocu_isco08_2digits = 74 if census == 7410                            // 74 - Electrical and electronic trades workers
capture replace ilo_job1_ocu_isco08_2digits = 74 if census == 7420                            // 74 - Electrical and electronic trades workers
capture replace ilo_job1_ocu_isco08_2digits = 74 if census == 7600                            // 74 - Electrical and electronic trades workers
capture replace ilo_job1_ocu_isco08_2digits = 75 if census == 4240                            // 75 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 75 if census == 6040                            // 75 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 75 if census == 6830                            // 75 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 75 if census == 7520                            // 75 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 75 if census == 7800                            // 75 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 75 if census == 7810                            // 75 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 75 if census == 7830                            // 75 / 81 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 75 if census == 7840                            // 75 / 81 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 75 if census == 7850                            // 75 / 81 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 75 if census == 7855                            // 75 / 81 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 75 if census == 8350                            // 75 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 75 if census == 8400                            // 75 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 75 if census == 8440                            // 75 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 75 if census == 8450                            // 75 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 75 if census == 8460                            // 75 / 81 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 75 if census == 8500                            // 75 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 75 if census == 8510                            // 75 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 75 if census == 8520                            // 75 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 75 if census == 8540                            // 75 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 75 if census == 8720                            // 75 / 81 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 75 if census == 8730                            // 75 / 81 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 75 if census == 8740                            // 75 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 75 if census == 8850                            // 75 / 81 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_job1_ocu_isco08_2digits = 81 if census == 6800                            // 81 - Stationary plant and machine operators
capture replace ilo_job1_ocu_isco08_2digits = 81 if census == 6820                            // 81 - Stationary plant and machine operators
capture replace ilo_job1_ocu_isco08_2digits = 81 if census == 6840                            // 81 - Stationary plant and machine operators
capture replace ilo_job1_ocu_isco08_2digits = 81 if census == 6910                            // 81 - Stationary plant and machine operators
capture replace ilo_job1_ocu_isco08_2digits = 81 if census == 6920                            // 81 - Stationary plant and machine operators
capture replace ilo_job1_ocu_isco08_2digits = 81 if census == 8150                            // 81 - Stationary plant and machine operators
capture replace ilo_job1_ocu_isco08_2digits = 81 if census == 8200                            // 81 - Stationary plant and machine operators
capture replace ilo_job1_ocu_isco08_2digits = 81 if census == 8300                            // 81 - Stationary plant and machine operators
capture replace ilo_job1_ocu_isco08_2digits = 81 if census == 8320                            // 81 - Stationary plant and machine operators
capture replace ilo_job1_ocu_isco08_2digits = 81 if census == 8340                            // 81 - Stationary plant and machine operators
capture replace ilo_job1_ocu_isco08_2digits = 81 if census == 8360                            // 81 - Stationary plant and machine operators
capture replace ilo_job1_ocu_isco08_2digits = 81 if census == 8410                            // 81 - Stationary plant and machine operators
capture replace ilo_job1_ocu_isco08_2digits = 81 if census == 8420                            // 81 - Stationary plant and machine operators
capture replace ilo_job1_ocu_isco08_2digits = 81 if census == 8430                            // 81 - Stationary plant and machine operators
capture replace ilo_job1_ocu_isco08_2digits = 81 if census == 8530                            // 81 - Stationary plant and machine operators
capture replace ilo_job1_ocu_isco08_2digits = 81 if census == 8610                            // 81 - Stationary plant and machine operators
capture replace ilo_job1_ocu_isco08_2digits = 81 if census == 8640                            // 81 - Stationary plant and machine operators
capture replace ilo_job1_ocu_isco08_2digits = 81 if census == 8650                            // 81 - Stationary plant and machine operators
capture replace ilo_job1_ocu_isco08_2digits = 81 if census == 8800                            // 81 - Stationary plant and machine operators
capture replace ilo_job1_ocu_isco08_2digits = 81 if census == 8830                            // 81 - Stationary plant and machine operators
capture replace ilo_job1_ocu_isco08_2digits = 81 if census == 8840                            // 81 - Stationary plant and machine operators
capture replace ilo_job1_ocu_isco08_2digits = 81 if census == 8860                            // 81 - Stationary plant and machine operators
capture replace ilo_job1_ocu_isco08_2digits = 81 if census == 8900                            // 81 - Stationary plant and machine operators
capture replace ilo_job1_ocu_isco08_2digits = 81 if census == 8930                            // 81 - Stationary plant and machine operators
capture replace ilo_job1_ocu_isco08_2digits = 81 if census == 8940                            // 81 - Stationary plant and machine operators
capture replace ilo_job1_ocu_isco08_2digits = 81 if census == 9500                            // 81 - Stationary plant and machine operators
capture replace ilo_job1_ocu_isco08_2digits = 82 if census == 7710                            // 82 - Assemblers
capture replace ilo_job1_ocu_isco08_2digits = 82 if census == 7720                            // 82 - Assemblers
capture replace ilo_job1_ocu_isco08_2digits = 82 if census == 7730                            // 82 - Assemblers
capture replace ilo_job1_ocu_isco08_2digits = 82 if census == 7750                            // 82 - Assemblers
capture replace ilo_job1_ocu_isco08_2digits = 83 if census == 6300                            // 83 - Drivers and mobile plant operators
capture replace ilo_job1_ocu_isco08_2digits = 83 if census == 6310                            // 83 - Drivers and mobile plant operators
capture replace ilo_job1_ocu_isco08_2digits = 83 if census == 6320                            // 83 - Drivers and mobile plant operators
capture replace ilo_job1_ocu_isco08_2digits = 83 if census == 9110                            // 83 - Drivers and mobile plant operators
capture replace ilo_job1_ocu_isco08_2digits = 83 if census == 9120                            // 83 - Drivers and mobile plant operators
capture replace ilo_job1_ocu_isco08_2digits = 83 if census == 9130                            // 83 - Drivers and mobile plant operators
capture replace ilo_job1_ocu_isco08_2digits = 83 if census == 9140                            // 83 - Drivers and mobile plant operators
capture replace ilo_job1_ocu_isco08_2digits = 83 if census == 9150                            // 83 - Drivers and mobile plant operators
capture replace ilo_job1_ocu_isco08_2digits = 83 if census == 9200                            // 83 - Drivers and mobile plant operators
capture replace ilo_job1_ocu_isco08_2digits = 83 if census == 9230                            // 83 - Drivers and mobile plant operators
capture replace ilo_job1_ocu_isco08_2digits = 83 if census == 9240                            // 83 - Drivers and mobile plant operators
capture replace ilo_job1_ocu_isco08_2digits = 83 if census == 9260                            // 83 - Drivers and mobile plant operators
capture replace ilo_job1_ocu_isco08_2digits = 83 if census == 9300                            // 83 - Drivers and mobile plant operators
capture replace ilo_job1_ocu_isco08_2digits = 83 if census == 9340                            // 83 - Drivers and mobile plant operators
capture replace ilo_job1_ocu_isco08_2digits = 83 if census == 9510                            // 83 - Drivers and mobile plant operators
capture replace ilo_job1_ocu_isco08_2digits = 83 if census == 9520                            // 83 - Drivers and mobile plant operators
capture replace ilo_job1_ocu_isco08_2digits = 83 if census == 9560                            // 83 - Drivers and mobile plant operators
capture replace ilo_job1_ocu_isco08_2digits = 83 if census == 9600                            // 83 - Drivers and mobile plant operators
capture replace ilo_job1_ocu_isco08_2digits = 83 if census == 9730                            // 83 - Drivers and mobile plant operators
capture replace ilo_job1_ocu_isco08_2digits = 91 if census == 4230                            // 91 - Cleaners and helpers
capture replace ilo_job1_ocu_isco08_2digits = 91 if census == 6750                            // 91 - Cleaners and helpers
capture replace ilo_job1_ocu_isco08_2digits = 91 if census == 8310                            // 91 - Cleaners and helpers
capture replace ilo_job1_ocu_isco08_2digits = 91 if census == 9610                            // 91 - Cleaners and helpers
capture replace ilo_job1_ocu_isco08_2digits = 92 if census == 4250                            // 92 - Agricultural, forestry and fishery labourers
capture replace ilo_job1_ocu_isco08_2digits = 92 if census == 6050                            // 92 - Agricultural, forestry and fishery labourers
capture replace ilo_job1_ocu_isco08_2digits = 93 if census == 6260                            // 93 - Labourers in mining, construction, manufacturing and transport
capture replace ilo_job1_ocu_isco08_2digits = 93 if census == 6600                            // 93 - Labourers in mining, construction, manufacturing and transport
capture replace ilo_job1_ocu_isco08_2digits = 93 if census == 6730                            // 93 - Labourers in mining, construction, manufacturing and transport
capture replace ilo_job1_ocu_isco08_2digits = 93 if census == 6740                            // 93 - Labourers in mining, construction, manufacturing and transport
capture replace ilo_job1_ocu_isco08_2digits = 93 if census == 6930                            // 93 - Labourers in mining, construction, manufacturing and transport
capture replace ilo_job1_ocu_isco08_2digits = 93 if census == 6940                            // 93 - Labourers in mining, construction, manufacturing and transport
capture replace ilo_job1_ocu_isco08_2digits = 93 if census == 8950                            // 93 - Labourers in mining, construction, manufacturing and transport
capture replace ilo_job1_ocu_isco08_2digits = 93 if census == 8960                            // 93 - Labourers in mining, construction, manufacturing and transport
capture replace ilo_job1_ocu_isco08_2digits = 93 if census == 8965                            // 93 - Labourers in mining, construction, manufacturing and transport
capture replace ilo_job1_ocu_isco08_2digits = 93 if census == 9000                            // 93 - Labourers in mining, construction, manufacturing and transport
capture replace ilo_job1_ocu_isco08_2digits = 93 if census == 9420                            // 93 - Labourers in mining, construction, manufacturing and transport
capture replace ilo_job1_ocu_isco08_2digits = 93 if census == 9620                            // 93 / 96 - Labourers in mining, construction, manufacturing and transport
capture replace ilo_job1_ocu_isco08_2digits = 93 if census == 9630                            // 93 - Labourers in mining, construction, manufacturing and transport
capture replace ilo_job1_ocu_isco08_2digits = 93 if census == 9640                            // 93 - Labourers in mining, construction, manufacturing and transport
capture replace ilo_job1_ocu_isco08_2digits = 93 if census == 9740                            // 93 - Labourers in mining, construction, manufacturing and transport
capture replace ilo_job1_ocu_isco08_2digits = 93 if census == 9750                            // 93 - Labourers in mining, construction, manufacturing and transport
capture replace ilo_job1_ocu_isco08_2digits = 94 if census == 4030                            // 94 - Food preparation assistants
capture replace ilo_job1_ocu_isco08_2digits = 94 if census == 4140                            // 94 - Food preparation assistants
capture replace ilo_job1_ocu_isco08_2digits = 94 if census == 4160                            // 94 - Food preparation assistants
capture replace ilo_job1_ocu_isco08_2digits = 96 if census == 4410                            // 96 - Refuse workers and other elementary workers
capture replace ilo_job1_ocu_isco08_2digits = 96 if census == 4420                            // 96 - Refuse workers and other elementary workers
capture replace ilo_job1_ocu_isco08_2digits = 96 if census == 4530                            // 96 - Refuse workers and other elementary workers
capture replace ilo_job1_ocu_isco08_2digits = 96 if census == 5530                            // 96 - Refuse workers and other elementary workers
capture replace ilo_job1_ocu_isco08_2digits = 96 if census == 7340                            // 96 - Refuse workers and other elementary workers
capture replace ilo_job1_ocu_isco08_2digits = 96 if census == 7510                            // 96 - Refuse workers and other elementary workers
capture replace ilo_job1_ocu_isco08_2digits = 96 if census == 7610                            // 96 - Refuse workers and other elementary workers
capture replace ilo_job1_ocu_isco08_2digits = 96 if census == 7620                            // 96 - Refuse workers and other elementary workers
capture replace ilo_job1_ocu_isco08_2digits = 96 if census == 7630                            // 96 - Refuse workers and other elementary workers
capture replace ilo_job1_ocu_isco08_2digits = 96 if census == 9350                            // 96 - Refuse workers and other elementary workers
capture replace ilo_job1_ocu_isco08_2digits = 96 if census == 9720                            // 96 - Refuse workers and other elementary workers

********************************************************************
********************************************************************
********************************************************************
****************** Step 2 / 2 distribute census category in all others possible ISCO category: 


capture replace ilo_job1_ocu_isco08_2digits = 13 if census == 20 & 1/4 < ilo_random_distribution & ilo_random_distribution <= 2/4
capture replace ilo_job1_ocu_isco08_2digits = 14 if census == 20 & 2/4 < ilo_random_distribution & ilo_random_distribution <= 3/4
capture replace ilo_job1_ocu_isco08_2digits = 52 if census == 20 & 3/4 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 12 if census == 60 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 13 if census == 120 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 71 if census == 220 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 12 if census == 430 & 1/4 < ilo_random_distribution & ilo_random_distribution <= 2/4
capture replace ilo_job1_ocu_isco08_2digits = 13 if census == 430 & 2/4 < ilo_random_distribution & ilo_random_distribution <= 3/4
capture replace ilo_job1_ocu_isco08_2digits = 14 if census == 430 & 3/4 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 33 if census == 620 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 33 if census == 630 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 24 if census == 650 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 33 if census == 730 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 33 if census == 740 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 35 if census == 1030 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 35 if census == 1100 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 35 if census == 1105 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 44 if census == 2440 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 34 if census == 2760 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_job1_ocu_isco08_2digits = 51 if census == 2760 & 2/3 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 26 if census == 2850 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 35 if census == 2960 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 32 if census == 3260 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 53 if census == 3640 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 51 if census == 3648 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 53 if census == 3655 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 54 if census == 3710 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 54 if census == 3720 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 54 if census == 3850 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 54 if census == 3920 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 51 if census == 4010 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 52 if census == 4120 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 94 if census == 4130 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 75 if census == 4210 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 91 if census == 4220 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 44 if census == 4320 & 1/4 < ilo_random_distribution & ilo_random_distribution <= 2/4
capture replace ilo_job1_ocu_isco08_2digits = 51 if census == 4320 & 2/4 < ilo_random_distribution & ilo_random_distribution <= 3/4
capture replace ilo_job1_ocu_isco08_2digits = 53 if census == 4320 & 3/4 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 51 if census == 4610 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_job1_ocu_isco08_2digits = 53 if census == 4610 & 2/3 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 95 if census == 4650 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 33 if census == 4710 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_job1_ocu_isco08_2digits = 42 if census == 4710 & 2/3 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 42 if census == 4830 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 33 if census == 4850 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 95 if census == 4950 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 42 if census == 4960 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_job1_ocu_isco08_2digits = 52 if census == 4960 & 2/3 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 42 if census == 4965 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_job1_ocu_isco08_2digits = 52 if census == 4965 & 2/3 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 43 if census == 5120 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 43 if census == 5165 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 44 if census == 5210 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 42 if census == 5250 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 44 if census == 5420 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 83 if census == 5510 & 1/4 < ilo_random_distribution & ilo_random_distribution <= 2/4
capture replace ilo_job1_ocu_isco08_2digits = 93 if census == 5510 & 2/4 < ilo_random_distribution & ilo_random_distribution <= 3/4
capture replace ilo_job1_ocu_isco08_2digits = 96 if census == 5510 & 3/4 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 44 if census == 5540 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 43 if census == 5610 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 93 if census == 5620 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 62 if census == 6000 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 62 if census == 6005 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 33 if census == 6010 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_job1_ocu_isco08_2digits = 75 if census == 6010 & 2/3 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 62 if census == 6020 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 63 if census == 6100 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_job1_ocu_isco08_2digits = 92 if census == 6100 & 2/3 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 63 if census == 6110 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 92 if census == 6120 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 83 if census == 6130 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 74 if census == 6540 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 72 if census == 7000 & 1/4 < ilo_random_distribution & ilo_random_distribution <= 2/4
capture replace ilo_job1_ocu_isco08_2digits = 73 if census == 7000 & 2/4 < ilo_random_distribution & ilo_random_distribution <= 3/4
capture replace ilo_job1_ocu_isco08_2digits = 74 if census == 7000 & 3/4 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 81 if census == 7830 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 81 if census == 7840 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 81 if census == 7850 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 81 if census == 7855 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 81 if census == 7920 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 81 if census == 7930 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 81 if census == 7940 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 81 if census == 7950 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 81 if census == 7960 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 81 if census == 8000 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 81 if census == 8010 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 81 if census == 8020 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 81 if census == 8040 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 81 if census == 8220 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 75 if census == 8330 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 81 if census == 8460 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 81 if census == 8630 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 75 if census == 8710 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 81 if census == 8720 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 81 if census == 8730 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 81 if census == 8810 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 81 if census == 8850 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 82 if census == 8910 & 1/2 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 75 if census == 8920 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_job1_ocu_isco08_2digits = 81 if census == 8920 & 2/3 < ilo_random_distribution
capture replace ilo_job1_ocu_isco08_2digits = 96 if census == 9620 & 1/2 < ilo_random_distribution


replace ilo_job1_ocu_isco08_2digits = . if ilo_lfs != 1


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
	

	* 1 digit level
	gen ilo_job1_ocu_isco08 = int(ilo_job1_ocu_isco08_2digits/10)
			
	
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

	drop census			  


				  
  }
		  
	drop ilo_random_distribution
  			  
		  
				  
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

* PELKLWO WHEN LAST WORK (3	NEVER WORKED = NEW-ENTRANT)


		gen ilo_cat_une=.
		replace ilo_cat_une=1 if inlist(PELKLWO, 1,2) & ilo_lfs==2				// 1 - Unemployed previously employed
		replace ilo_cat_une=2 if PELKLWO == 3 & ilo_lfs==2				// 2 - Unemployed seeking their first job
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
		drop todrop*
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

* Comment: 

set seed 1
gen ilo_random_distribution =  runiform(0, 1) if ilo_lfs == 2 & ilo_cat_une==1
	

* ISIC Rev. 4 

if `Y' > 1999 {
*Comment: var PEIO1OCD apply for all then reduce to emp and une at the end of the do.
* PEIO1OCD OCCUPATION CODE FOR PRIMARY JOB.
	
	gen census = PEIO1ICD

if `Y' < 2003 & `Y' > 1999 {	
	capture replace census = NEIO1ICD // only 2000-2002 else PEIO1OCD
}
* ISIC Rev. 4

	destring census, replace
	* 2-digit level
	gen ilo_preveco_isic4_2digits = . 
	
capture replace ilo_preveco_isic4_2digits = 1 if census == 170                           // 01 / 02 / 03 / 10 - Crop and animal production, hunting and related service activities
capture replace ilo_preveco_isic4_2digits = 1 if census == 180                           // 01 / 03 - Crop and animal production, hunting and related service activities
capture replace ilo_preveco_isic4_2digits = 1 if census == 190                           // 01 - Crop and animal production, hunting and related service activities
capture replace ilo_preveco_isic4_2digits = 2 if census == 270                           // 02 - Forestry and logging
capture replace ilo_preveco_isic4_2digits = 1 if census == 280                           // 01 / 03 - Crop and animal production, hunting and related service activities
capture replace ilo_preveco_isic4_2digits = 1 if census == 290                           // 01 / 02 / 75 - Crop and animal production, hunting and related service activities
capture replace ilo_preveco_isic4_2digits = 5 if census == 370                           // 05 / 06 - Mining of coal and lignite
capture replace ilo_preveco_isic4_2digits = 5 if census == 380                           // 05 - Mining of coal and lignite
capture replace ilo_preveco_isic4_2digits = 7 if census == 390                           // 07 - Mining of metal ores
capture replace ilo_preveco_isic4_2digits = 8 if census == 470                           // 08 - Other mining and quarrying
capture replace ilo_preveco_isic4_2digits = 7 if census == 480                           // 07 / 08 - Mining of metal ores
capture replace ilo_preveco_isic4_2digits = 9 if census == 490                           // 09 / 43 - Mining support service activities
capture replace ilo_preveco_isic4_2digits = 35 if census == 570                           // 35 - Electricity, gas, steam and air conditioning supply
capture replace ilo_preveco_isic4_2digits = 35 if census == 580                           // 35 - Electricity, gas, steam and air conditioning supply
capture replace ilo_preveco_isic4_2digits = 35 if census == 590                           // 35 - Electricity, gas, steam and air conditioning supply
capture replace ilo_preveco_isic4_2digits = 35 if census == 670                           // 35 / 36 / 49 - Electricity, gas, steam and air conditioning supply
capture replace ilo_preveco_isic4_2digits = 37 if census == 680                           // 37 - Sewerage
capture replace ilo_preveco_isic4_2digits = 35 if census == 690                           // 35 / 37 / 38 - Electricity, gas, steam and air conditioning supply
capture replace ilo_preveco_isic4_2digits = 41 if census == 770                           // 41 / 42 / 43 - Construction of buildings
capture replace ilo_preveco_isic4_2digits = 35 if census == 1070                           // 35 - Electricity, gas, steam and air conditioning supply
capture replace ilo_preveco_isic4_2digits = 10 if census == 1080                           // 10 - Manufacture of food products
capture replace ilo_preveco_isic4_2digits = 10 if census == 1090                           // 10 - Manufacture of food products
capture replace ilo_preveco_isic4_2digits = 10 if census == 1170                           // 10 - Manufacture of food products
capture replace ilo_preveco_isic4_2digits = 10 if census == 1180                           // 10 - Manufacture of food products
capture replace ilo_preveco_isic4_2digits = 10 if census == 1190                           // 10 - Manufacture of food products
capture replace ilo_preveco_isic4_2digits = 10 if census == 1270                           // 10 - Manufacture of food products
capture replace ilo_preveco_isic4_2digits = 3 if census == 1280                           // 03 / 08 / 10 - Fishing and aquaculture
capture replace ilo_preveco_isic4_2digits = 3 if census == 1290                           // 03 / 08 / 10 / 11 - Fishing and aquaculture
capture replace ilo_preveco_isic4_2digits = 11 if census == 1370                           // 11 / 20 / 35 - Manufacture of beverages
capture replace ilo_preveco_isic4_2digits = 12 if census == 1390                           // 12 - Manufacture of tobacco products
capture replace ilo_preveco_isic4_2digits = 13 if census == 1470                           // 13 - Manufacture of textiles
capture replace ilo_preveco_isic4_2digits = 13 if census == 1480                           // 13 / 14 / 28 - Manufacture of textiles
capture replace ilo_preveco_isic4_2digits = 13 if census == 1490                           // 13 / 22 - Manufacture of textiles
capture replace ilo_preveco_isic4_2digits = 31 if census == 1570                           // 31 - Manufacture of furniture
capture replace ilo_preveco_isic4_2digits = 13 if census == 1590                           // 13 / 14 / 15 / 22 - Manufacture of textiles
capture replace ilo_preveco_isic4_2digits = 13 if census == 1670                           // 13:14:22 - Manufacture of textiles
capture replace ilo_preveco_isic4_2digits = 14 if census == 1680                           // 14 - Manufacture of wearing apparel
capture replace ilo_preveco_isic4_2digits = 13 if census == 1690                           // 13 / 14 / 22 - Manufacture of textiles
capture replace ilo_preveco_isic4_2digits = 15 if census == 1770                           // 15 - Manufacture of leather and related products
capture replace ilo_preveco_isic4_2digits = 13 if census == 1790                           // 13:14:15:22 - Manufacture of textiles
capture replace ilo_preveco_isic4_2digits = 17 if census == 1870                           // 17 / 23 - Manufacture of paper and paper products
capture replace ilo_preveco_isic4_2digits = 17 if census == 1880                           // 17 - Manufacture of paper and paper products
capture replace ilo_preveco_isic4_2digits = 13 if census == 1890                           // 13 / 17 / 22 / 24 / 25 - Manufacture of textiles
capture replace ilo_preveco_isic4_2digits = 13 if census == 1990                           // 13 / 17 / 18 / 25 - Manufacture of textiles
capture replace ilo_preveco_isic4_2digits = 19 if census == 2070                           // 19 - Manufacture of coke and refined petroleum products
capture replace ilo_preveco_isic4_2digits = 16 if census == 2090                           // 16 / 19 / 23 - Manufacture of wood and of products of wood and cork, except furniture; manufacture of articles of straw and plaiting materials
capture replace ilo_preveco_isic4_2digits = 20 if census == 2170                           // 20 / 22 - Manufacture of chemicals and chemical products
capture replace ilo_preveco_isic4_2digits = 20 if census == 2180                           // 20 - Manufacture of chemicals and chemical products
capture replace ilo_preveco_isic4_2digits = 20 if census == 2190                           // 20 / 21 - Manufacture of chemicals and chemical products
capture replace ilo_preveco_isic4_2digits = 20 if census == 2270                           // 20 - Manufacture of chemicals and chemical products
capture replace ilo_preveco_isic4_2digits = 20 if census == 2280                           // 20 - Manufacture of chemicals and chemical products
capture replace ilo_preveco_isic4_2digits = 14 if census == 2290                           // 14 / 20 / 21 - Manufacture of wearing apparel
capture replace ilo_preveco_isic4_2digits = 22 if census == 2370                           // 22 / 27 / 29 / 31 - Manufacture of rubber and plastics products
capture replace ilo_preveco_isic4_2digits = 22 if census == 2380                           // 22 - Manufacture of rubber and plastics products
capture replace ilo_preveco_isic4_2digits = 22 if census == 2390                           // 22 / 27 - Manufacture of rubber and plastics products
capture replace ilo_preveco_isic4_2digits = 23 if census == 2470                           // 23 - Manufacture of other non-metallic mineral products
capture replace ilo_preveco_isic4_2digits = 23 if census == 2480                           // 23 - Manufacture of other non-metallic mineral products
capture replace ilo_preveco_isic4_2digits = 23 if census == 2480                           // 23 - Manufacture of other non-metallic mineral products
capture replace ilo_preveco_isic4_2digits = 23 if census == 2480                           // 23 - Manufacture of other non-metallic mineral products
capture replace ilo_preveco_isic4_2digits = 23 if census == 2490                           // 23 - Manufacture of other non-metallic mineral products
capture replace ilo_preveco_isic4_2digits = 23 if census == 2570                           // 23 - Manufacture of other non-metallic mineral products
capture replace ilo_preveco_isic4_2digits = 23 if census == 2590                           // 23 / 32 - Manufacture of other non-metallic mineral products
capture replace ilo_preveco_isic4_2digits = 24 if census == 2670                           // 24 / 25 / 27 / 30 - Manufacture of basic metals
capture replace ilo_preveco_isic4_2digits = 24 if census == 2680                           // 24 / 25 / 27 - Manufacture of basic metals
capture replace ilo_preveco_isic4_2digits = 24 if census == 2690                           // 24 / 25 / 27 - Manufacture of basic metals
capture replace ilo_preveco_isic4_2digits = 24 if census == 2770                           // 24 / 28 - Manufacture of basic metals
capture replace ilo_preveco_isic4_2digits = 25 if census == 2780                           // 25 - Manufacture of fabricated metal products, except machinery and equipment
capture replace ilo_preveco_isic4_2digits = 25 if census == 2790                           // 25 / 27 / 28 / 32 - Manufacture of fabricated metal products, except machinery and equipment
capture replace ilo_preveco_isic4_2digits = 25 if census == 2870                           // 25 / 28 / 29 / 30 - Manufacture of fabricated metal products, except machinery and equipment
capture replace ilo_preveco_isic4_2digits = 25 if census == 2880                           // 25 - Manufacture of fabricated metal products, except machinery and equipment
capture replace ilo_preveco_isic4_2digits = 25 if census == 2890                           // 25 - Manufacture of fabricated metal products, except machinery and equipment
capture replace ilo_preveco_isic4_2digits = 17 if census == 2970                           // 17 / 20 / 24 / 25 - Manufacture of paper and paper products
capture replace ilo_preveco_isic4_2digits = 20 if census == 2980                           // 20 / 24 / 25 / 28 / 32 - Manufacture of chemicals and chemical products
capture replace ilo_preveco_isic4_2digits = 20 if census == 2990                           // 20 / 24 / 25 - Manufacture of chemicals and chemical products
capture replace ilo_preveco_isic4_2digits = 28 if census == 3070                           // 28 / 30 - Manufacture of machinery and equipment n.e.c.
capture replace ilo_preveco_isic4_2digits = 43 if census == 3080                           // 43 - Specialized construction activities
capture replace ilo_preveco_isic4_2digits = 27 if census == 3090                           // 27 / 28 / 32 - Manufacture of electrical equipment
capture replace ilo_preveco_isic4_2digits = 26 if census == 3095                           // 26 / 27 / 28 / 30 / 32 - Manufacture of computer, electronic and optical products
capture replace ilo_preveco_isic4_2digits = 25 if census == 3170                           // 25 / 28 - Manufacture of fabricated metal products, except machinery and equipment
capture replace ilo_preveco_isic4_2digits = 27 if census == 3180                           // 27 / 28 / 29 / 30 - Manufacture of electrical equipment
capture replace ilo_preveco_isic4_2digits = 25 if census == 3190                           // 25 / 28 / 32 - Manufacture of fabricated metal products, except machinery and equipment
capture replace ilo_preveco_isic4_2digits = 25 if census == 3290                           // 25 / 28 / 32 - Manufacture of fabricated metal products, except machinery and equipment
capture replace ilo_preveco_isic4_2digits = 26 if census == 3360                           // 26 - Manufacture of computer, electronic and optical products
capture replace ilo_preveco_isic4_2digits = 26 if census == 3365                           // 26 - Manufacture of computer, electronic and optical products
capture replace ilo_preveco_isic4_2digits = 26 if census == 3370                           // 26 / 30 - Manufacture of computer, electronic and optical products
capture replace ilo_preveco_isic4_2digits = 26 if census == 3380                           // 26 - Manufacture of computer, electronic and optical products
capture replace ilo_preveco_isic4_2digits = 18 if census == 3390                           // 18 / 26 - Printing and reproduction of recorded media
capture replace ilo_preveco_isic4_2digits = 27 if census == 3470                           // 27 - Manufacture of electrical equipment
capture replace ilo_preveco_isic4_2digits = 13 if census == 3490                           // 13 / 23 / 27 - Manufacture of textiles
capture replace ilo_preveco_isic4_2digits = 23 if census == 3570                           // 23 / 27 / 28 / 29 - Manufacture of other non-metallic mineral products
capture replace ilo_preveco_isic4_2digits = 28 if census == 3580                           // 28 / 30 - Manufacture of machinery and equipment n.e.c.
capture replace ilo_preveco_isic4_2digits = 30 if census == 3590                           // 30 - Manufacture of other transport equipment
capture replace ilo_preveco_isic4_2digits = 29 if census == 3670                           // 29 / 30 - Manufacture of motor vehicles, trailers and semi-trailers
capture replace ilo_preveco_isic4_2digits = 30 if census == 3680                           // 30 / 33 - Manufacture of other transport equipment
capture replace ilo_preveco_isic4_2digits = 29 if census == 3690                           // 29 / 30 - Manufacture of motor vehicles, trailers and semi-trailers
capture replace ilo_preveco_isic4_2digits = 16 if census == 3770                           // 16 - Manufacture of wood and of products of wood and cork, except furniture; manufacture of articles of straw and plaiting materials
capture replace ilo_preveco_isic4_2digits = 16 if census == 3780                           // 16 - Manufacture of wood and of products of wood and cork, except furniture; manufacture of articles of straw and plaiting materials
capture replace ilo_preveco_isic4_2digits = 16 if census == 3790                           // 16 - Manufacture of wood and of products of wood and cork, except furniture; manufacture of articles of straw and plaiting materials
capture replace ilo_preveco_isic4_2digits = 16 if census == 3870                           // 16 - Manufacture of wood and of products of wood and cork, except furniture; manufacture of articles of straw and plaiting materials
capture replace ilo_preveco_isic4_2digits = 16 if census == 3875                           // 16 / 22 / 31 - Manufacture of wood and of products of wood and cork, except furniture; manufacture of articles of straw and plaiting materials
capture replace ilo_preveco_isic4_2digits = 31 if census == 3890                           // 31 / 32 - Manufacture of furniture
capture replace ilo_preveco_isic4_2digits = 31 if census == 3895                           // 31 / 32 - Manufacture of furniture
capture replace ilo_preveco_isic4_2digits = 21 if census == 3960                           // 21 / 28 / 30 / 32 - Manufacture of basic pharmaceutical products and pharmaceutical preparations
capture replace ilo_preveco_isic4_2digits = 32 if census == 3970                           // 32 - Other manufacturing
capture replace ilo_preveco_isic4_2digits = 13 if census == 3980                           // 13 / 25 / 32 - Manufacture of textiles
capture replace ilo_preveco_isic4_2digits = 10 if census == 3990                           // 10 / 13 / 14 / 16 / 20 / 22 / 23 / 24 / 25 / 27 / 28 / 31 / 32 - Manufacture of food products
capture replace ilo_preveco_isic4_2digits = 45 if census == 4070                           // 45 / 46 - Wholesale and retail trade and repair of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 46 if census == 4080                           // 46 - Wholesale trade, except of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 43 if census == 4090                           // 43 - Specialized construction activities
capture replace ilo_preveco_isic4_2digits = 46 if census == 4170                           // 46 - Wholesale trade, except of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 46 if census == 4180                           // 46 - Wholesale trade, except of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 46 if census == 4190                           // 46 - Wholesale trade, except of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 46 if census == 4195                           // 46 - Wholesale trade, except of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 46 if census == 4260                           // 46 - Wholesale trade, except of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 45 if census == 4265                           // 45 / 46 - Wholesale and retail trade and repair of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 46 if census == 4270                           // 46 - Wholesale trade, except of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 46 if census == 4280                           // 46 - Wholesale trade, except of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 45 if census == 4290                           // 45 / 46 - Wholesale and retail trade and repair of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 46 if census == 4370                           // 46 - Wholesale trade, except of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 46 if census == 4380                           // 46 - Wholesale trade, except of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 46 if census == 4390                           // 46 - Wholesale trade, except of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 46 if census == 4470                           // 46 - Wholesale trade, except of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 46 if census == 4480                           // 46 - Wholesale trade, except of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 46 if census == 4490                           // 46 - Wholesale trade, except of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 46 if census == 4560                           // 46 - Wholesale trade, except of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 46 if census == 4570                           // 46 - Wholesale trade, except of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 46 if census == 4580                           // 46 - Wholesale trade, except of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 45 if census == 4585                           // 45 / 46 - Wholesale and retail trade and repair of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 46 if census == 4590                           // 46 - Wholesale trade, except of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 45 if census == 4670                           // 45 - Wholesale and retail trade and repair of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 45 if census == 4680                           // 45 / 47 - Wholesale and retail trade and repair of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 45 if census == 4690                           // 45 / 47 - Wholesale and retail trade and repair of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 47 if census == 4770                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 47 if census == 4780                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 95 if census == 4780                           // 95 - Repair of computers and personal and household goods
capture replace ilo_preveco_isic4_2digits = 33 if census == 4790                           // 33 / 47 - Repair and installation of machinery and equipment
capture replace ilo_preveco_isic4_2digits = 33 if census == 4795                           // 33 - Repair and installation of machinery and equipment
capture replace ilo_preveco_isic4_2digits = 47 if census == 4795                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 47 if census == 4795                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 47 if census == 4795                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 47 if census == 4795                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 95 if census == 4795                           // 95 - Repair of computers and personal and household goods
capture replace ilo_preveco_isic4_2digits = 47 if census == 4870                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 47 if census == 4880                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 47 if census == 4890                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 47 if census == 4970                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 47 if census == 4980                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 47 if census == 4990                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 47 if census == 5070                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 86 if census == 5080                           // 86 - Human health activities
capture replace ilo_preveco_isic4_2digits = 47 if census == 5090                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 47 if census == 5170                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 47 if census == 5180                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 47 if census == 5190                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 47 if census == 5270                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 45 if census == 5275                           // 45 - Wholesale and retail trade and repair of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 47 if census == 5280                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 47 if census == 5290                           // 74 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 47 if census == 5295                           // 47 / 95 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 47 if census == 5370                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 47 if census == 5380                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 45 if census == 5390                           // 45 / 47 - Wholesale and retail trade and repair of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 47 if census == 5470                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 47 if census == 5480                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 47 if census == 5490                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 47 if census == 5570                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 47 if census == 5580                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 47 if census == 5590                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 47 if census == 5591                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 47 if census == 5592                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 47 if census == 5670                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 47 if census == 5680                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 47 if census == 5690                           // 47 - Retail trade, except of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 45 if census == 5790                           // 45 / 47 - Wholesale and retail trade and repair of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 51 if census == 6070                           // 51 - Air transport
capture replace ilo_preveco_isic4_2digits = 49 if census == 6080                           // 49 - Land transport and transport via pipelines
capture replace ilo_preveco_isic4_2digits = 50 if census == 6090                           // 50 - Water transport
capture replace ilo_preveco_isic4_2digits = 49 if census == 6170                           // 49 - Land transport and transport via pipelines
capture replace ilo_preveco_isic4_2digits = 49 if census == 6180                           // 49 - Land transport and transport via pipelines
capture replace ilo_preveco_isic4_2digits = 49 if census == 6190                           // 49 - Land transport and transport via pipelines
capture replace ilo_preveco_isic4_2digits = 49 if census == 6270                           // 49 - Land transport and transport via pipelines
capture replace ilo_preveco_isic4_2digits = 49 if census == 6280                           // 49 / 50 / 51 - Land transport and transport via pipelines
capture replace ilo_preveco_isic4_2digits = 52 if census == 6290                           // 52 - Warehousing and support activities for transportation
capture replace ilo_preveco_isic4_2digits = 53 if census == 6370                           // 53 - Postal and courier activities
capture replace ilo_preveco_isic4_2digits = 53 if census == 6380                           // 53 - Postal and courier activities
capture replace ilo_preveco_isic4_2digits = 52 if census == 6390                           // 52 - Warehousing and support activities for transportation
capture replace ilo_preveco_isic4_2digits = 58 if census == 6470                           // 58 - Publishing activities
capture replace ilo_preveco_isic4_2digits = 58 if census == 6480                           // 58 - Publishing activities
capture replace ilo_preveco_isic4_2digits = 58 if census == 6490                           // 58 - Publishing activities
capture replace ilo_preveco_isic4_2digits = 59 if census == 6570                           // 59 - Motion picture, video and television programme production, sound recording and music publishing activities
capture replace ilo_preveco_isic4_2digits = 59 if census == 6590                           // 59 - Motion picture, video and television programme production, sound recording and music publishing activities
capture replace ilo_preveco_isic4_2digits = 60 if census == 6670                           // 60 / 61 - Programming and broadcasting activities
capture replace ilo_preveco_isic4_2digits = 58 if census == 6672                           // 58 / 59 / 60 / 63 - Publishing activities
capture replace ilo_preveco_isic4_2digits = 60 if census == 6675                           // 60 / 61 / 63 - Programming and broadcasting activities
capture replace ilo_preveco_isic4_2digits = 61 if census == 6680                           // 61 - Telecommunications
capture replace ilo_preveco_isic4_2digits = 61 if census == 6690                           // 61 - Telecommunications
capture replace ilo_preveco_isic4_2digits = 61 if census == 6692                           // 61 / 63 / 74 - Telecommunications
capture replace ilo_preveco_isic4_2digits = 63 if census == 6695                           // 63 / 74 - Information service activities
capture replace ilo_preveco_isic4_2digits = 91 if census == 6770                           // 91 - Libraries, archives, museums and other cultural activities
capture replace ilo_preveco_isic4_2digits = 63 if census == 6780                           // 63 / 91 - Information service activities
capture replace ilo_preveco_isic4_2digits = 63 if census == 6790                           // 63 / 91 - Information service activities
capture replace ilo_preveco_isic4_2digits = 64 if census == 6870                           // 64 - Financial service activities, except insurance and pension funding
capture replace ilo_preveco_isic4_2digits = 64 if census == 6880                           // 64 - Financial service activities, except insurance and pension funding
capture replace ilo_preveco_isic4_2digits = 64 if census == 6890                           // 64 / 66 - Financial service activities, except insurance and pension funding
capture replace ilo_preveco_isic4_2digits = 64 if census == 6970                           // 64 / 65 / 66 / 68 - Financial service activities, except insurance and pension funding
capture replace ilo_preveco_isic4_2digits = 65 if census == 6990                           // 65 / 66 - Insurance, reinsurance and pension funding, except compulsory social security
capture replace ilo_preveco_isic4_2digits = 68 if census == 7070                           // 68 - Real estate activities
capture replace ilo_preveco_isic4_2digits = 77 if census == 7080                           // 77 - Rental and leasing activities
capture replace ilo_preveco_isic4_2digits = 77 if census == 7170                           // 77 - Rental and leasing activities
capture replace ilo_preveco_isic4_2digits = 77 if census == 7180                           // 77 - Rental and leasing activities
capture replace ilo_preveco_isic4_2digits = 77 if census == 7190                           // 77 - Rental and leasing activities
capture replace ilo_preveco_isic4_2digits = 69 if census == 7270                           // 69 - Legal and accounting activities
capture replace ilo_preveco_isic4_2digits = 69 if census == 7280                           // 69 - Legal and accounting activities
capture replace ilo_preveco_isic4_2digits = 71 if census == 7290                           // 71 - Architectural and engineering activities; technical testing and analysis
capture replace ilo_preveco_isic4_2digits = 74 if census == 7370                           // 74 - Other professional, scientific and technical activities
capture replace ilo_preveco_isic4_2digits = 62 if census == 7380                           // 62 - Computer programming, consultancy and related activities
capture replace ilo_preveco_isic4_2digits = 66 if census == 7390                           // 66 / 70 / 74 - Activities auxiliary to financial service and insurance activities
capture replace ilo_preveco_isic4_2digits = 72 if census == 7460                           // 72 - Scientific research and development
capture replace ilo_preveco_isic4_2digits = 70 if census == 7470                           // 70 / 73 - Activities of head offices; management consultancy activities
capture replace ilo_preveco_isic4_2digits = 75 if census == 7480                           // 75 - Veterinary activities
capture replace ilo_preveco_isic4_2digits = 69 if census == 7490                           // 69 / 74 / 80 / 88 - Legal and accounting activities
capture replace ilo_preveco_isic4_2digits = 64 if census == 7570                           // 64 / 70 - Financial service activities, except insurance and pension funding
capture replace ilo_preveco_isic4_2digits = 78 if census == 7580                           // 78 - Employment activities
capture replace ilo_preveco_isic4_2digits = 82 if census == 7590                           // 82 / 84 - Office administrative, office support and other business support activities
capture replace ilo_preveco_isic4_2digits = 79 if census == 7670                           // 79 - Travel agency, tour operator, reservation service and related activities
capture replace ilo_preveco_isic4_2digits = 80 if census == 7680                           // 80 - Security and investigation activities
capture replace ilo_preveco_isic4_2digits = 81 if census == 7690                           // 81 - Services to buildings and landscape activities
capture replace ilo_preveco_isic4_2digits = 81 if census == 7770                           // 81 - Services to buildings and landscape activities
capture replace ilo_preveco_isic4_2digits = 13 if census == 7780                           // 13 / 81 / 82 / 84 - Manufacture of textiles
capture replace ilo_preveco_isic4_2digits = 37 if census == 7790                           // 37 / 38 / 39 - Sewerage
capture replace ilo_preveco_isic4_2digits = 85 if census == 7860                           // 85 - Education
capture replace ilo_preveco_isic4_2digits = 85 if census == 7870                           // 85 - Education
capture replace ilo_preveco_isic4_2digits = 85 if census == 7880                           // 85 - Education
capture replace ilo_preveco_isic4_2digits = 85 if census == 7890                           // 85 - Education
capture replace ilo_preveco_isic4_2digits = 86 if census == 7970                           // 86 - Human health activities
capture replace ilo_preveco_isic4_2digits = 86 if census == 7980                           // 86 - Human health activities
capture replace ilo_preveco_isic4_2digits = 86 if census == 7990                           // 86 - Human health activities
capture replace ilo_preveco_isic4_2digits = 86 if census == 8070                           // 86 - Human health activities
capture replace ilo_preveco_isic4_2digits = 86 if census == 8080                           // 86 - Human health activities
capture replace ilo_preveco_isic4_2digits = 86 if census == 8090                           // 86 / 88 - Human health activities
capture replace ilo_preveco_isic4_2digits = 86 if census == 8170                           // 86 - Human health activities
capture replace ilo_preveco_isic4_2digits = 86 if census == 8180                           // 86 - Human health activities
capture replace ilo_preveco_isic4_2digits = 86 if census == 8190                           // 86 - Human health activities
capture replace ilo_preveco_isic4_2digits = 87 if census == 8270                           // 87 - Residential care activities
capture replace ilo_preveco_isic4_2digits = 87 if census == 8290                           // 87 - Residential care activities
capture replace ilo_preveco_isic4_2digits = 88 if census == 8370                           // 88 - Social work activities without accommodation
capture replace ilo_preveco_isic4_2digits = 88 if census == 8380                           // 88 - Social work activities without accommodation
capture replace ilo_preveco_isic4_2digits = 88 if census == 8390                           // 88 - Social work activities without accommodation
capture replace ilo_preveco_isic4_2digits = 88 if census == 8470                           // 88 - Social work activities without accommodation
capture replace ilo_preveco_isic4_2digits = 32 if census == 8560                           // 32 / 33 / 74 / 90 / 93 - Other manufacturing
capture replace ilo_preveco_isic4_2digits = 91 if census == 8570                           // 91 - Libraries, archives, museums and other cultural activities
capture replace ilo_preveco_isic4_2digits = 93 if census == 8580                           // 93 - Sports activities and amusement and recreation activities
capture replace ilo_preveco_isic4_2digits = 79 if census == 8590                           // 79 / 92 / 93 - Travel agency, tour operator, reservation service and related activities
capture replace ilo_preveco_isic4_2digits = 55 if census == 8660                           // 55 / 92 - Accommodation
capture replace ilo_preveco_isic4_2digits = 55 if census == 8670                           // 55 - Accommodation
capture replace ilo_preveco_isic4_2digits = 56 if census == 8680                           // 56 - Food and beverage service activities
capture replace ilo_preveco_isic4_2digits = 56 if census == 8690                           // 56 - Food and beverage service activities
capture replace ilo_preveco_isic4_2digits = 29 if census == 8770                           // 29 / 45 / 71 - Manufacture of motor vehicles, trailers and semi-trailers
capture replace ilo_preveco_isic4_2digits = 45 if census == 8780                           // 45 - Wholesale and retail trade and repair of motor vehicles and motorcycles
capture replace ilo_preveco_isic4_2digits = 33 if census == 8790                           // 33 - Repair and installation of machinery and equipment
capture replace ilo_preveco_isic4_2digits = 33 if census == 8870                           // 33 / 45 - Repair and installation of machinery and equipment
capture replace ilo_preveco_isic4_2digits = 33 if census == 8880                           // 33 / 45 - Repair and installation of machinery and equipment
capture replace ilo_preveco_isic4_2digits = 95 if census == 8890                           // 95 - Repair of computers and personal and household goods
capture replace ilo_preveco_isic4_2digits = 96 if census == 8970                           // 96 - Other personal service activities
capture replace ilo_preveco_isic4_2digits = 96 if census == 8980                           // 96 - Other personal service activities
capture replace ilo_preveco_isic4_2digits = 51 if census == 8990                           // 51 / 96 - Air transport
capture replace ilo_preveco_isic4_2digits = 96 if census == 9070                           // 96 - Other personal service activities
capture replace ilo_preveco_isic4_2digits = 96 if census == 9080                           // 96 - Other personal service activities
capture replace ilo_preveco_isic4_2digits = 52 if census == 9090                           // 52 / 61 / 74 / 95 / 96 - Warehousing and support activities for transportation
capture replace ilo_preveco_isic4_2digits = 94 if census == 9160                           // 94 - Activities of membership organizations
capture replace ilo_preveco_isic4_2digits = 94 if census == 9170                           // 94 - Activities of membership organizations
capture replace ilo_preveco_isic4_2digits = 94 if census == 9180                           // 94 - Activities of membership organizations
capture replace ilo_preveco_isic4_2digits = 93 if census == 9190                           // 93 / 94 - Sports activities and amusement and recreation activities
capture replace ilo_preveco_isic4_2digits = 97 if census == 9290                           // 97 - Activities of households as employers of domestic personnel
capture replace ilo_preveco_isic4_2digits = 84 if census == 9370                           // 84 - Public administration and defence; compulsory social security
capture replace ilo_preveco_isic4_2digits = 84 if census == 9380                           // 84 - Public administration and defence; compulsory social security
capture replace ilo_preveco_isic4_2digits = 84 if census == 9390                           // 84 - Public administration and defence; compulsory social security
capture replace ilo_preveco_isic4_2digits = 53 if census == 9470                           // 53 / 84 - Postal and courier activities
capture replace ilo_preveco_isic4_2digits = 84 if census == 9480                           // 84 - Public administration and defence; compulsory social security
capture replace ilo_preveco_isic4_2digits = 84 if census == 9490                           // 84 - Public administration and defence; compulsory social security
capture replace ilo_preveco_isic4_2digits = 51 if census == 9570                           // 51 / 79 / 84 - Air transport
capture replace ilo_preveco_isic4_2digits = 84 if census == 9590                           // 84 / 99 - Public administration and defence; compulsory social security
capture replace ilo_preveco_isic4_2digits = 84 if census == 9670                           // 84 - Public administration and defence; compulsory social security
capture replace ilo_preveco_isic4_2digits = 84 if census == 9680                           // 84 - Public administration and defence; compulsory social security
capture replace ilo_preveco_isic4_2digits = 84 if census == 9690                           // 84 - Public administration and defence; compulsory social security
capture replace ilo_preveco_isic4_2digits = 84 if census == 9770                           // 84 - Public administration and defence; compulsory social security
capture replace ilo_preveco_isic4_2digits = 84 if census == 9780                           // 84 - Public administration and defence; compulsory social security
capture replace ilo_preveco_isic4_2digits = 84 if census == 9790                           // 84 - Public administration and defence; compulsory social security
capture replace ilo_preveco_isic4_2digits = 84 if census == 9870                           // 84 - Public administration and defence; compulsory social security


	
********************************************************************
********************************************************************
********************************************************************
****************** Step 2 / 2 distribute census category in all others possible ISIC category: 

	
		
		
capture replace ilo_preveco_isic4_2digits = 2 if census == 170 & 1/4 < ilo_random_distribution & ilo_random_distribution <= 2/4
capture replace ilo_preveco_isic4_2digits = 3 if census == 170 & 2/4 < ilo_random_distribution & ilo_random_distribution <= 3/4
capture replace ilo_preveco_isic4_2digits = 10 if census == 170 & 3/4 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 3 if census == 180 & 1/2 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 3 if census == 280 & 1/2 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 2 if census == 290 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_preveco_isic4_2digits = 75 if census == 290 & 2/3 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 6 if census == 370 & 1/2 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 8 if census == 480 & 1/2 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 43 if census == 490 & 1/2 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 36 if census == 670 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_preveco_isic4_2digits = 49 if census == 670 & 2/3 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 37 if census == 690 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_preveco_isic4_2digits = 38 if census == 690 & 2/3 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 42 if census == 770 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_preveco_isic4_2digits = 43 if census == 770 & 2/3 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 8 if census == 1280 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_preveco_isic4_2digits = 10 if census == 1280 & 2/3 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 8 if census == 1290 & 1/4 < ilo_random_distribution & ilo_random_distribution <= 2/4
capture replace ilo_preveco_isic4_2digits = 10 if census == 1290 & 2/4 < ilo_random_distribution & ilo_random_distribution <= 3/4
capture replace ilo_preveco_isic4_2digits = 11 if census == 1290 & 3/4 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 20 if census == 1370 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_preveco_isic4_2digits = 35 if census == 1370 & 2/3 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 14 if census == 1480 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_preveco_isic4_2digits = 28 if census == 1480 & 2/3 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 22 if census == 1490 & 1/2 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 14 if census == 1590 & 1/4 < ilo_random_distribution & ilo_random_distribution <= 2/4
capture replace ilo_preveco_isic4_2digits = 15 if census == 1590 & 2/4 < ilo_random_distribution & ilo_random_distribution <= 3/4
capture replace ilo_preveco_isic4_2digits = 22 if census == 1590 & 3/4 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 14 if census == 1670 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_preveco_isic4_2digits = 22 if census == 1670 & 2/3 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 14 if census == 1690 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_preveco_isic4_2digits = 22 if census == 1690 & 2/3 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 14 if census == 1790 & 1/4 < ilo_random_distribution & ilo_random_distribution <= 2/4
capture replace ilo_preveco_isic4_2digits = 15 if census == 1790 & 2/4 < ilo_random_distribution & ilo_random_distribution <= 3/4
capture replace ilo_preveco_isic4_2digits = 22 if census == 1790 & 3/4 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 23 if census == 1870 & 1/2 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 17 if census == 1890 & 1/5 < ilo_random_distribution & ilo_random_distribution <= 2/5
capture replace ilo_preveco_isic4_2digits = 22 if census == 1890 & 2/5 < ilo_random_distribution & ilo_random_distribution <= 3/5
capture replace ilo_preveco_isic4_2digits = 24 if census == 1890 & 3/5 < ilo_random_distribution & ilo_random_distribution <= 4/5
capture replace ilo_preveco_isic4_2digits = 25 if census == 1890 & 4/5 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 17 if census == 1990 & 1/4 < ilo_random_distribution & ilo_random_distribution <= 2/4
capture replace ilo_preveco_isic4_2digits = 18 if census == 1990 & 2/4 < ilo_random_distribution & ilo_random_distribution <= 3/4
capture replace ilo_preveco_isic4_2digits = 25 if census == 1990 & 3/4 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 19 if census == 2090 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_preveco_isic4_2digits = 23 if census == 2090 & 2/3 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 22 if census == 2170 & 1/2 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 21 if census == 2190 & 1/2 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 20 if census == 2290 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_preveco_isic4_2digits = 21 if census == 2290 & 2/3 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 27 if census == 2370 & 1/4 < ilo_random_distribution & ilo_random_distribution <= 2/4
capture replace ilo_preveco_isic4_2digits = 29 if census == 2370 & 2/4 < ilo_random_distribution & ilo_random_distribution <= 3/4
capture replace ilo_preveco_isic4_2digits = 31 if census == 2370 & 3/4 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 27 if census == 2390 & 1/2 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 32 if census == 2590 & 1/2 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 25 if census == 2670 & 1/4 < ilo_random_distribution & ilo_random_distribution <= 2/4
capture replace ilo_preveco_isic4_2digits = 27 if census == 2670 & 2/4 < ilo_random_distribution & ilo_random_distribution <= 3/4
capture replace ilo_preveco_isic4_2digits = 30 if census == 2670 & 3/4 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 25 if census == 2680 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_preveco_isic4_2digits = 27 if census == 2680 & 2/3 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 25 if census == 2690 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_preveco_isic4_2digits = 27 if census == 2690 & 2/3 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 28 if census == 2770 & 1/2 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 27 if census == 2790 & 1/4 < ilo_random_distribution & ilo_random_distribution <= 2/4
capture replace ilo_preveco_isic4_2digits = 28 if census == 2790 & 2/4 < ilo_random_distribution & ilo_random_distribution <= 3/4
capture replace ilo_preveco_isic4_2digits = 32 if census == 2790 & 3/4 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 28 if census == 2870 & 1/4 < ilo_random_distribution & ilo_random_distribution <= 2/4
capture replace ilo_preveco_isic4_2digits = 29 if census == 2870 & 2/4 < ilo_random_distribution & ilo_random_distribution <= 3/4
capture replace ilo_preveco_isic4_2digits = 30 if census == 2870 & 3/4 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 20 if census == 2970 & 1/4 < ilo_random_distribution & ilo_random_distribution <= 2/4
capture replace ilo_preveco_isic4_2digits = 24 if census == 2970 & 2/4 < ilo_random_distribution & ilo_random_distribution <= 3/4
capture replace ilo_preveco_isic4_2digits = 25 if census == 2970 & 3/4 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 24 if census == 2980 & 1/5 < ilo_random_distribution & ilo_random_distribution <= 2/5
capture replace ilo_preveco_isic4_2digits = 25 if census == 2980 & 2/5 < ilo_random_distribution & ilo_random_distribution <= 3/5
capture replace ilo_preveco_isic4_2digits = 28 if census == 2980 & 3/5 < ilo_random_distribution & ilo_random_distribution <= 4/5
capture replace ilo_preveco_isic4_2digits = 32 if census == 2980 & 4/5 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 24 if census == 2990 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_preveco_isic4_2digits = 25 if census == 2990 & 2/3 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 30 if census == 3070 & 1/2 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 28 if census == 3090 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_preveco_isic4_2digits = 32 if census == 3090 & 2/3 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 27 if census == 3095 & 1/5 < ilo_random_distribution & ilo_random_distribution <= 2/5
capture replace ilo_preveco_isic4_2digits = 28 if census == 3095 & 2/5 < ilo_random_distribution & ilo_random_distribution <= 3/5
capture replace ilo_preveco_isic4_2digits = 30 if census == 3095 & 3/5 < ilo_random_distribution & ilo_random_distribution <= 4/5
capture replace ilo_preveco_isic4_2digits = 32 if census == 3095 & 4/5 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 28 if census == 3170 & 1/2 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 28 if census == 3180 & 1/4 < ilo_random_distribution & ilo_random_distribution <= 2/4
capture replace ilo_preveco_isic4_2digits = 29 if census == 3180 & 2/4 < ilo_random_distribution & ilo_random_distribution <= 3/4
capture replace ilo_preveco_isic4_2digits = 30 if census == 3180 & 3/4 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 28 if census == 3190 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_preveco_isic4_2digits = 32 if census == 3190 & 2/3 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 28 if census == 3290 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_preveco_isic4_2digits = 32 if census == 3290 & 2/3 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 30 if census == 3370 & 1/2 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 26 if census == 3390 & 1/2 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 23 if census == 3490 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_preveco_isic4_2digits = 27 if census == 3490 & 2/3 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 27 if census == 3570 & 1/4 < ilo_random_distribution & ilo_random_distribution <= 2/4
capture replace ilo_preveco_isic4_2digits = 28 if census == 3570 & 2/4 < ilo_random_distribution & ilo_random_distribution <= 3/4
capture replace ilo_preveco_isic4_2digits = 29 if census == 3570 & 3/4 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 30 if census == 3580 & 1/2 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 30 if census == 3670 & 1/2 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 33 if census == 3680 & 1/2 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 30 if census == 3690 & 1/2 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 22 if census == 3875 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_preveco_isic4_2digits = 31 if census == 3875 & 2/3 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 32 if census == 3890 & 1/2 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 32 if census == 3895 & 1/2 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 28 if census == 3960 & 1/4 < ilo_random_distribution & ilo_random_distribution <= 2/4
capture replace ilo_preveco_isic4_2digits = 30 if census == 3960 & 2/4 < ilo_random_distribution & ilo_random_distribution <= 3/4
capture replace ilo_preveco_isic4_2digits = 32 if census == 3960 & 3/4 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 25 if census == 3980 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_preveco_isic4_2digits = 32 if census == 3980 & 2/3 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 13 if census == 3990 & 1/13 < ilo_random_distribution & ilo_random_distribution <= 2/13
capture replace ilo_preveco_isic4_2digits = 14 if census == 3990 & 2/13 < ilo_random_distribution & ilo_random_distribution <= 3/13
capture replace ilo_preveco_isic4_2digits = 16 if census == 3990 & 3/13 < ilo_random_distribution & ilo_random_distribution <= 4/13
capture replace ilo_preveco_isic4_2digits = 20 if census == 3990 & 4/13 < ilo_random_distribution & ilo_random_distribution <= 5/13
capture replace ilo_preveco_isic4_2digits = 22 if census == 3990 & 5/13 < ilo_random_distribution & ilo_random_distribution <= 6/13
capture replace ilo_preveco_isic4_2digits = 23 if census == 3990 & 6/13 < ilo_random_distribution & ilo_random_distribution <= 7/13
capture replace ilo_preveco_isic4_2digits = 24 if census == 3990 & 7/13 < ilo_random_distribution & ilo_random_distribution <= 8/13
capture replace ilo_preveco_isic4_2digits = 25 if census == 3990 & 8/13 < ilo_random_distribution & ilo_random_distribution <= 9/13
capture replace ilo_preveco_isic4_2digits = 27 if census == 3990 & 9/13 < ilo_random_distribution & ilo_random_distribution <= 10/13
capture replace ilo_preveco_isic4_2digits = 28 if census == 3990 & 10/13 < ilo_random_distribution & ilo_random_distribution <= 11/13
capture replace ilo_preveco_isic4_2digits = 31 if census == 3990 & 11/13 < ilo_random_distribution & ilo_random_distribution <= 12/13
capture replace ilo_preveco_isic4_2digits = 32 if census == 3990 & 12/13 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 46 if census == 4070 & 1/2 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 46 if census == 4265 & 1/2 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 46 if census == 4290 & 1/2 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 46 if census == 4585 & 1/2 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 47 if census == 4680 & 1/2 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 47 if census == 4690 & 1/2 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 95 if census == 4780 & 1/2 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 47 if census == 4790 & 1/2 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 47 if census == 4795 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_preveco_isic4_2digits = 95 if census == 4795 & 2/3 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 95 if census == 5295 & 1/2 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 47 if census == 5390 & 1/2 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 47 if census == 5790 & 1/2 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 50 if census == 6280 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_preveco_isic4_2digits = 51 if census == 6280 & 2/3 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 61 if census == 6670 & 1/2 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 59 if census == 6672 & 1/4 < ilo_random_distribution & ilo_random_distribution <= 2/4
capture replace ilo_preveco_isic4_2digits = 60 if census == 6672 & 2/4 < ilo_random_distribution & ilo_random_distribution <= 3/4
capture replace ilo_preveco_isic4_2digits = 63 if census == 6672 & 3/4 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 61 if census == 6675 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_preveco_isic4_2digits = 63 if census == 6675 & 2/3 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 63 if census == 6692 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_preveco_isic4_2digits = 74 if census == 6692 & 2/3 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 74 if census == 6695 & 1/2 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 91 if census == 6780 & 1/2 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 91 if census == 6790 & 1/2 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 66 if census == 6890 & 1/2 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 65 if census == 6970 & 1/4 < ilo_random_distribution & ilo_random_distribution <= 2/4
capture replace ilo_preveco_isic4_2digits = 66 if census == 6970 & 2/4 < ilo_random_distribution & ilo_random_distribution <= 3/4
capture replace ilo_preveco_isic4_2digits = 68 if census == 6970 & 3/4 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 66 if census == 6990 & 1/2 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 70 if census == 7390 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_preveco_isic4_2digits = 74 if census == 7390 & 2/3 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 73 if census == 7470 & 1/2 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 74 if census == 7490 & 1/4 < ilo_random_distribution & ilo_random_distribution <= 2/4
capture replace ilo_preveco_isic4_2digits = 80 if census == 7490 & 2/4 < ilo_random_distribution & ilo_random_distribution <= 3/4
capture replace ilo_preveco_isic4_2digits = 88 if census == 7490 & 3/4 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 70 if census == 7570 & 1/2 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 84 if census == 7590 & 1/2 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 81 if census == 7780 & 1/4 < ilo_random_distribution & ilo_random_distribution <= 2/4
capture replace ilo_preveco_isic4_2digits = 82 if census == 7780 & 2/4 < ilo_random_distribution & ilo_random_distribution <= 3/4
capture replace ilo_preveco_isic4_2digits = 84 if census == 7780 & 3/4 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 38 if census == 7790 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_preveco_isic4_2digits = 39 if census == 7790 & 2/3 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 88 if census == 8090 & 1/2 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 33 if census == 8560 & 1/5 < ilo_random_distribution & ilo_random_distribution <= 2/5
capture replace ilo_preveco_isic4_2digits = 74 if census == 8560 & 2/5 < ilo_random_distribution & ilo_random_distribution <= 3/5
capture replace ilo_preveco_isic4_2digits = 90 if census == 8560 & 3/5 < ilo_random_distribution & ilo_random_distribution <= 4/5
capture replace ilo_preveco_isic4_2digits = 93 if census == 8560 & 4/5 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 92 if census == 8590 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_preveco_isic4_2digits = 93 if census == 8590 & 2/3 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 92 if census == 8660 & 1/2 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 45 if census == 8770 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_preveco_isic4_2digits = 71 if census == 8770 & 2/3 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 45 if census == 8870 & 1/2 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 45 if census == 8880 & 1/2 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 96 if census == 8990 & 1/2 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 61 if census == 9090 & 1/5 < ilo_random_distribution & ilo_random_distribution <= 2/5
capture replace ilo_preveco_isic4_2digits = 74 if census == 9090 & 2/5 < ilo_random_distribution & ilo_random_distribution <= 3/5
capture replace ilo_preveco_isic4_2digits = 95 if census == 9090 & 3/5 < ilo_random_distribution & ilo_random_distribution <= 4/5
capture replace ilo_preveco_isic4_2digits = 96 if census == 9090 & 4/5 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 94 if census == 9190 & 1/2 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 84 if census == 9470 & 1/2 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 79 if census == 9570 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_preveco_isic4_2digits = 84 if census == 9570 & 2/3 < ilo_random_distribution
capture replace ilo_preveco_isic4_2digits = 99 if census == 9590 & 1/2 < ilo_random_distribution


	replace ilo_preveco_isic4_2digits = . if ilo_cat_une!=1
	
	            * labels already defined for main job
                lab val ilo_preveco_isic4_2digits eco_isic4_2digits
                lab var ilo_preveco_isic4_2digits "Previous economic activity (ISIC Rev. 4), 2 digits level"

	* 1-digit level
    gen ilo_preveco_isic4=.
	    replace ilo_preveco_isic4=1 if inrange(ilo_preveco_isic4_2digits,1,3)
	    replace ilo_preveco_isic4=2 if inrange(ilo_preveco_isic4_2digits,5,9)
	    replace ilo_preveco_isic4=3 if inrange(ilo_preveco_isic4_2digits,10,33)
	    replace ilo_preveco_isic4=4 if ilo_preveco_isic4_2digits==35
	    replace ilo_preveco_isic4=5 if inrange(ilo_preveco_isic4_2digits,36,39)
	    replace ilo_preveco_isic4=6 if inrange(ilo_preveco_isic4_2digits,41,43)
	    replace ilo_preveco_isic4=7 if inrange(ilo_preveco_isic4_2digits,45,47)
	    replace ilo_preveco_isic4=8 if inrange(ilo_preveco_isic4_2digits,49,53)
	    replace ilo_preveco_isic4=9 if inrange(ilo_preveco_isic4_2digits,55,56)
	    replace ilo_preveco_isic4=10 if inrange(ilo_preveco_isic4_2digits,58,63)
	    replace ilo_preveco_isic4=11 if inrange(ilo_preveco_isic4_2digits,64,66)
	    replace ilo_preveco_isic4=12 if ilo_preveco_isic4_2digits==68
	    replace ilo_preveco_isic4=13 if inrange(ilo_preveco_isic4_2digits,69,75)		
	    replace ilo_preveco_isic4=14 if inrange(ilo_preveco_isic4_2digits,77,82)
	    replace ilo_preveco_isic4=15 if ilo_preveco_isic4_2digits==84
        replace ilo_preveco_isic4=16 if ilo_preveco_isic4_2digits==85
	    replace ilo_preveco_isic4=17 if inrange(ilo_preveco_isic4_2digits,86,88)
	    replace ilo_preveco_isic4=18 if inrange(ilo_preveco_isic4_2digits,90,93)
	    replace ilo_preveco_isic4=19 if inrange(ilo_preveco_isic4_2digits,94,96)
	    replace ilo_preveco_isic4=20 if inrange(ilo_preveco_isic4_2digits,97,98)
	    replace ilo_preveco_isic4=21 if ilo_preveco_isic4_2digits==99
	    replace ilo_preveco_isic4=22 if ilo_preveco_isic4==. & ilo_lfs==2 & ilo_cat_une==1
                * labels already defined for main job
		        lab val ilo_preveco_isic4 eco_isic4_1digit
			    lab var ilo_preveco_isic4 "Previous economic activity (ISIC Rev. 4)"

	 * tab  ilo_preveco_isic4 [iw = ilo_wgt] if ilo_cat_une == 1	, m
	 
	 drop census
}

	


	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

* base on ilo_job1_ocu_isco08 ask to everybody aand thenreduce to unemployed
if `Y' > 1999 {

* Comment: var PEIO1OCD apply for all then reduce to emp and une at the end of the do.
* PEIO1OCD OCCUPATION CODE FOR PRIMARY JOB.
	
	gen census = PEIO1OCD if ilo_cat_une == 1

if `Y' < 2003 & `Y' > 1999 {	
	capture replace census = NTIO1OCD // only 2000-2002 else PEIO1OCD
}

	destring census, replace
	gen ilo_prevocu_isco08_2digits = .
	
	* 2-digit level 
	   
capture replace ilo_prevocu_isco08_2digits = 1 if census == 9800                            // 01 - Commissioned armed forces officers
capture replace ilo_prevocu_isco08_2digits = 2 if census == 9810                            // 02 - Non-commissioned armed forces officers
capture replace ilo_prevocu_isco08_2digits = 3 if census == 9820                            // 03 - Armed forces occupations, other ranks
capture replace ilo_prevocu_isco08_2digits = 3 if census == 9830                            // 03 - Armed forces occupations, other ranks
capture replace ilo_prevocu_isco08_2digits = 11 if census == 10                            // 11 - Chief executives, senior officials and legislators
capture replace ilo_prevocu_isco08_2digits = 11 if census == 20                            // 11 / 13 / 14 / 52 - Chief executives, senior officials and legislators
capture replace ilo_prevocu_isco08_2digits = 11 if census == 30                            // 11 - Chief executives, senior officials and legislators
capture replace ilo_prevocu_isco08_2digits = 11 if census == 60                            // 11 / 12 - Chief executives, senior officials and legislators
capture replace ilo_prevocu_isco08_2digits = 11 if census == 425                            // 11 - Chief executives, senior officials and legislators
capture replace ilo_prevocu_isco08_2digits = 11 if census == 430                            // 11 / 12 / 13 / 14 - Chief executives, senior officials and legislators
capture replace ilo_prevocu_isco08_2digits = 12 if census == 40                            // 12 - Administrative and commercial managers
capture replace ilo_prevocu_isco08_2digits = 12 if census == 50                            // 12 - Administrative and commercial managers
capture replace ilo_prevocu_isco08_2digits = 12 if census == 100                            // 12 - Administrative and commercial managers
capture replace ilo_prevocu_isco08_2digits = 12 if census == 120                            // 12 / 13 - Administrative and commercial managers
capture replace ilo_prevocu_isco08_2digits = 12 if census == 130                            // 12 - Administrative and commercial managers
capture replace ilo_prevocu_isco08_2digits = 12 if census == 135                            // 12 - Administrative and commercial managers
capture replace ilo_prevocu_isco08_2digits = 12 if census == 136                            // 12 - Administrative and commercial managers
capture replace ilo_prevocu_isco08_2digits = 12 if census == 137                            // 12 - Administrative and commercial managers
capture replace ilo_prevocu_isco08_2digits = 12 if census == 150                            // 12 - Administrative and commercial managers
capture replace ilo_prevocu_isco08_2digits = 12 if census == 300                            // 12 - Administrative and commercial managers
capture replace ilo_prevocu_isco08_2digits = 12 if census == 320                            // 12 - Administrative and commercial managers
capture replace ilo_prevocu_isco08_2digits = 12 if census == 325                            // 12 - Administrative and commercial managers
capture replace ilo_prevocu_isco08_2digits = 12 if census == 360                            // 12 - Administrative and commercial managers
capture replace ilo_prevocu_isco08_2digits = 12 if census == 400                            // 12 - Administrative and commercial managers
capture replace ilo_prevocu_isco08_2digits = 13 if census == 110                            // 13 - Production and specialised services managers
capture replace ilo_prevocu_isco08_2digits = 13 if census == 140                            // 13 - Production and specialised services managers
capture replace ilo_prevocu_isco08_2digits = 13 if census == 160                            // 13 - Production and specialised services managers
capture replace ilo_prevocu_isco08_2digits = 13 if census == 200                            // 13 - Production and specialised services managers
capture replace ilo_prevocu_isco08_2digits = 13 if census == 205                            // 13 - Production and specialised services managers
capture replace ilo_prevocu_isco08_2digits = 13 if census == 210                            // 13 - Production and specialised services managers
capture replace ilo_prevocu_isco08_2digits = 13 if census == 220                            // 13 / 71 - Production and specialised services managers
capture replace ilo_prevocu_isco08_2digits = 13 if census == 230                            // 13 - Production and specialised services managers
capture replace ilo_prevocu_isco08_2digits = 13 if census == 350                            // 13 - Production and specialised services managers
capture replace ilo_prevocu_isco08_2digits = 13 if census == 420                            // 13 - Production and specialised services managers
capture replace ilo_prevocu_isco08_2digits = 14 if census == 310                            // 14 - Hospitality, retail and other services managers
capture replace ilo_prevocu_isco08_2digits = 14 if census == 330                            // 14 - Hospitality, retail and other services managers
capture replace ilo_prevocu_isco08_2digits = 14 if census == 340                            // 14 - Hospitality, retail and other services managers
capture replace ilo_prevocu_isco08_2digits = 21 if census == 1200                            // 21 - Science and engineering professionals
capture replace ilo_prevocu_isco08_2digits = 21 if census == 1210                            // 21 - Science and engineering professionals
capture replace ilo_prevocu_isco08_2digits = 21 if census == 1220                            // 21 - Science and engineering professionals
capture replace ilo_prevocu_isco08_2digits = 21 if census == 1230                            // 21 - Science and engineering professionals
capture replace ilo_prevocu_isco08_2digits = 21 if census == 1300                            // 21 - Science and engineering professionals
capture replace ilo_prevocu_isco08_2digits = 21 if census == 1310                            // 21 - Science and engineering professionals
capture replace ilo_prevocu_isco08_2digits = 21 if census == 1320                            // 21 - Science and engineering professionals
capture replace ilo_prevocu_isco08_2digits = 21 if census == 1330                            // 21 - Science and engineering professionals
capture replace ilo_prevocu_isco08_2digits = 21 if census == 1340                            // 21 - Science and engineering professionals
capture replace ilo_prevocu_isco08_2digits = 21 if census == 1350                            // 21 - Science and engineering professionals
capture replace ilo_prevocu_isco08_2digits = 21 if census == 1360                            // 21 - Science and engineering professionals
capture replace ilo_prevocu_isco08_2digits = 21 if census == 1400                            // 21 - Science and engineering professionals
capture replace ilo_prevocu_isco08_2digits = 21 if census == 1410                            // 21 - Science and engineering professionals
capture replace ilo_prevocu_isco08_2digits = 21 if census == 1420                            // 21 - Science and engineering professionals
capture replace ilo_prevocu_isco08_2digits = 21 if census == 1430                            // 21 - Science and engineering professionals
capture replace ilo_prevocu_isco08_2digits = 21 if census == 1440                            // 21 - Science and engineering professionals
capture replace ilo_prevocu_isco08_2digits = 21 if census == 1450                            // 21 - Science and engineering professionals
capture replace ilo_prevocu_isco08_2digits = 21 if census == 1460                            // 21 - Science and engineering professionals
capture replace ilo_prevocu_isco08_2digits = 21 if census == 1500                            // 21 - Science and engineering professionals
capture replace ilo_prevocu_isco08_2digits = 21 if census == 1510                            // 21 - Science and engineering professionals
capture replace ilo_prevocu_isco08_2digits = 21 if census == 1520                            // 21 - Science and engineering professionals
capture replace ilo_prevocu_isco08_2digits = 21 if census == 1530                            // 21 - Science and engineering professionals
capture replace ilo_prevocu_isco08_2digits = 21 if census == 1600                            // 21 - Science and engineering professionals
capture replace ilo_prevocu_isco08_2digits = 21 if census == 1610                            // 21 - Science and engineering professionals
capture replace ilo_prevocu_isco08_2digits = 21 if census == 1640                            // 21 - Science and engineering professionals
capture replace ilo_prevocu_isco08_2digits = 21 if census == 1650                            // 21 - Science and engineering professionals
capture replace ilo_prevocu_isco08_2digits = 21 if census == 1660                            // 21 - Science and engineering professionals
capture replace ilo_prevocu_isco08_2digits = 21 if census == 1700                            // 21 - Science and engineering professionals
capture replace ilo_prevocu_isco08_2digits = 21 if census == 1710                            // 21 - Science and engineering professionals
capture replace ilo_prevocu_isco08_2digits = 21 if census == 1720                            // 21 - Science and engineering professionals
capture replace ilo_prevocu_isco08_2digits = 21 if census == 1740                            // 21 - Science and engineering professionals
capture replace ilo_prevocu_isco08_2digits = 21 if census == 1760                            // 21 - Science and engineering professionals
capture replace ilo_prevocu_isco08_2digits = 21 if census == 1810                            // 21 - Science and engineering professionals
capture replace ilo_prevocu_isco08_2digits = 21 if census == 1815                            // 21 - Science and engineering professionals
capture replace ilo_prevocu_isco08_2digits = 21 if census == 1840                            // 21 - Science and engineering professionals
capture replace ilo_prevocu_isco08_2digits = 21 if census == 2630                            // 21 - Science and engineering professionals
capture replace ilo_prevocu_isco08_2digits = 22 if census == 2025                            // 22 - Health professionals
capture replace ilo_prevocu_isco08_2digits = 22 if census == 3000                            // 22 - Health professionals
capture replace ilo_prevocu_isco08_2digits = 22 if census == 3010                            // 22 - Health professionals
capture replace ilo_prevocu_isco08_2digits = 22 if census == 3030                            // 22 - Health professionals
capture replace ilo_prevocu_isco08_2digits = 22 if census == 3040                            // 22 - Health professionals
capture replace ilo_prevocu_isco08_2digits = 22 if census == 3050                            // 22 - Health professionals
capture replace ilo_prevocu_isco08_2digits = 22 if census == 3060                            // 22 - Health professionals
capture replace ilo_prevocu_isco08_2digits = 22 if census == 3110                            // 22 - Health professionals
capture replace ilo_prevocu_isco08_2digits = 22 if census == 3120                            // 22 - Health professionals
capture replace ilo_prevocu_isco08_2digits = 22 if census == 3130                            // 22 - Health professionals
capture replace ilo_prevocu_isco08_2digits = 22 if census == 3140                            // 22 - Health professionals
capture replace ilo_prevocu_isco08_2digits = 22 if census == 3150                            // 22 - Health professionals
capture replace ilo_prevocu_isco08_2digits = 22 if census == 3160                            // 22 - Health professionals
capture replace ilo_prevocu_isco08_2digits = 22 if census == 3210                            // 22 - Health professionals
capture replace ilo_prevocu_isco08_2digits = 22 if census == 3230                            // 22 - Health professionals
capture replace ilo_prevocu_isco08_2digits = 22 if census == 3235                            // 22 - Health professionals
capture replace ilo_prevocu_isco08_2digits = 22 if census == 3240                            // 22 - Health professionals
capture replace ilo_prevocu_isco08_2digits = 22 if census == 3245                            // 22 - Health professionals
capture replace ilo_prevocu_isco08_2digits = 22 if census == 3250                            // 22 - Health professionals
capture replace ilo_prevocu_isco08_2digits = 22 if census == 3255                            // 22 - Health professionals
capture replace ilo_prevocu_isco08_2digits = 22 if census == 3256                            // 22 - Health professionals
capture replace ilo_prevocu_isco08_2digits = 22 if census == 3257                            // 22 - Health professionals
capture replace ilo_prevocu_isco08_2digits = 22 if census == 3258                            // 22 - Health professionals
capture replace ilo_prevocu_isco08_2digits = 22 if census == 3260                            // 22 / 32 - Health professionals
capture replace ilo_prevocu_isco08_2digits = 23 if census == 650                            // 23 / 24 - Teaching professionals
capture replace ilo_prevocu_isco08_2digits = 23 if census == 2200                            // 23 - Teaching professionals
capture replace ilo_prevocu_isco08_2digits = 23 if census == 2300                            // 23 - Teaching professionals
capture replace ilo_prevocu_isco08_2digits = 23 if census == 2310                            // 23 - Teaching professionals
capture replace ilo_prevocu_isco08_2digits = 23 if census == 2320                            // 23 - Teaching professionals
capture replace ilo_prevocu_isco08_2digits = 23 if census == 2330                            // 23 - Teaching professionals
capture replace ilo_prevocu_isco08_2digits = 23 if census == 2340                            // 23 - Teaching professionals
capture replace ilo_prevocu_isco08_2digits = 23 if census == 2550                            // 23 - Teaching professionals
capture replace ilo_prevocu_isco08_2digits = 24 if census == 620                            // 24 / 33 - Business and administration professionals
capture replace ilo_prevocu_isco08_2digits = 24 if census == 630                            // 24 / 33 - Business and administration professionals
capture replace ilo_prevocu_isco08_2digits = 24 if census == 640                            // 24 - Business and administration professionals
capture replace ilo_prevocu_isco08_2digits = 24 if census == 700                            // 24 - Business and administration professionals
capture replace ilo_prevocu_isco08_2digits = 24 if census == 710                            // 24 - Business and administration professionals
capture replace ilo_prevocu_isco08_2digits = 24 if census == 730                            // 24 / 33 - Business and administration professionals
capture replace ilo_prevocu_isco08_2digits = 24 if census == 735                            // 24 - Business and administration professionals
capture replace ilo_prevocu_isco08_2digits = 24 if census == 740                            // 24 / 33 - Business and administration professionals
capture replace ilo_prevocu_isco08_2digits = 24 if census == 800                            // 24 - Business and administration professionals
capture replace ilo_prevocu_isco08_2digits = 24 if census == 820                            // 24 - Business and administration professionals
capture replace ilo_prevocu_isco08_2digits = 24 if census == 830                            // 24 - Business and administration professionals
capture replace ilo_prevocu_isco08_2digits = 24 if census == 840                            // 24 - Business and administration professionals
capture replace ilo_prevocu_isco08_2digits = 24 if census == 850                            // 24 - Business and administration professionals
capture replace ilo_prevocu_isco08_2digits = 24 if census == 900                            // 24 - Business and administration professionals
capture replace ilo_prevocu_isco08_2digits = 24 if census == 940                            // 24 - Business and administration professionals
capture replace ilo_prevocu_isco08_2digits = 24 if census == 2800                            // 24 - Business and administration professionals
capture replace ilo_prevocu_isco08_2digits = 24 if census == 2820                            // 24 - Business and administration professionals
capture replace ilo_prevocu_isco08_2digits = 24 if census == 2825                            // 24 - Business and administration professionals
capture replace ilo_prevocu_isco08_2digits = 24 if census == 2850                            // 24 / 26 - Business and administration professionals
capture replace ilo_prevocu_isco08_2digits = 24 if census == 4710                            // 24 / 33 / 42 - Business and administration professionals
capture replace ilo_prevocu_isco08_2digits = 24 if census == 4850                            // 24 / 33 - Business and administration professionals
capture replace ilo_prevocu_isco08_2digits = 24 if census == 4930                            // 24 - Business and administration professionals
capture replace ilo_prevocu_isco08_2digits = 25 if census == 1000                            // 25 - Information and communications technology professionals
capture replace ilo_prevocu_isco08_2digits = 25 if census == 1005                            // 25 - Information and communications technology professionals
capture replace ilo_prevocu_isco08_2digits = 25 if census == 1006                            // 25 - Information and communications technology professionals
capture replace ilo_prevocu_isco08_2digits = 25 if census == 1007                            // 25 - Information and communications technology professionals
capture replace ilo_prevocu_isco08_2digits = 25 if census == 1010                            // 25 - Information and communications technology professionals
capture replace ilo_prevocu_isco08_2digits = 25 if census == 1020                            // 25 - Information and communications technology professionals
capture replace ilo_prevocu_isco08_2digits = 25 if census == 1030                            // 25 / 35 - Information and communications technology professionals
capture replace ilo_prevocu_isco08_2digits = 25 if census == 1060                            // 25 - Information and communications technology professionals
capture replace ilo_prevocu_isco08_2digits = 25 if census == 1100                            // 25 / 35 - Information and communications technology professionals
capture replace ilo_prevocu_isco08_2digits = 25 if census == 1105                            // 25 / 35 - Information and communications technology professionals
capture replace ilo_prevocu_isco08_2digits = 25 if census == 1106                            // 25 - Information and communications technology professionals
capture replace ilo_prevocu_isco08_2digits = 25 if census == 1107                            // 25 - Information and communications technology professionals
capture replace ilo_prevocu_isco08_2digits = 25 if census == 1110                            // 25 - Information and communications technology professionals
capture replace ilo_prevocu_isco08_2digits = 26 if census == 1800                            // 26 - Legal, social and cultural professionals
capture replace ilo_prevocu_isco08_2digits = 26 if census == 1820                            // 26 - Legal, social and cultural professionals
capture replace ilo_prevocu_isco08_2digits = 26 if census == 1830                            // 26 - Legal, social and cultural professionals
capture replace ilo_prevocu_isco08_2digits = 26 if census == 1860                            // 26 - Legal, social and cultural professionals
capture replace ilo_prevocu_isco08_2digits = 26 if census == 2000                            // 26 - Legal, social and cultural professionals
capture replace ilo_prevocu_isco08_2digits = 26 if census == 2010                            // 26 - Legal, social and cultural professionals
capture replace ilo_prevocu_isco08_2digits = 26 if census == 2015                            // 26 - Legal, social and cultural professionals
capture replace ilo_prevocu_isco08_2digits = 26 if census == 2020                            // 26 - Legal, social and cultural professionals
capture replace ilo_prevocu_isco08_2digits = 26 if census == 2040                            // 26 - Legal, social and cultural professionals
capture replace ilo_prevocu_isco08_2digits = 26 if census == 2050                            // 26 - Legal, social and cultural professionals
capture replace ilo_prevocu_isco08_2digits = 26 if census == 2100                            // 26 - Legal, social and cultural professionals
capture replace ilo_prevocu_isco08_2digits = 26 if census == 2110                            // 26 - Legal, social and cultural professionals
capture replace ilo_prevocu_isco08_2digits = 26 if census == 2400                            // 26 - Legal, social and cultural professionals
capture replace ilo_prevocu_isco08_2digits = 26 if census == 2430                            // 26 - Legal, social and cultural professionals
capture replace ilo_prevocu_isco08_2digits = 26 if census == 2600                            // 26 - Legal, social and cultural professionals
capture replace ilo_prevocu_isco08_2digits = 26 if census == 2700                            // 26 - Legal, social and cultural professionals
capture replace ilo_prevocu_isco08_2digits = 26 if census == 2710                            // 26 - Legal, social and cultural professionals
capture replace ilo_prevocu_isco08_2digits = 26 if census == 2740                            // 26 - Legal, social and cultural professionals
capture replace ilo_prevocu_isco08_2digits = 26 if census == 2750                            // 26 - Legal, social and cultural professionals
capture replace ilo_prevocu_isco08_2digits = 26 if census == 2760                            // 26 / 34 / 51 - Legal, social and cultural professionals
capture replace ilo_prevocu_isco08_2digits = 26 if census == 2810                            // 26 - Legal, social and cultural professionals
capture replace ilo_prevocu_isco08_2digits = 26 if census == 2830                            // 26 - Legal, social and cultural professionals
capture replace ilo_prevocu_isco08_2digits = 26 if census == 2840                            // 26 - Legal, social and cultural professionals
capture replace ilo_prevocu_isco08_2digits = 31 if census == 1540                            // 31 - Science and engineering associate professionals
capture replace ilo_prevocu_isco08_2digits = 31 if census == 1550                            // 31 - Science and engineering associate professionals
capture replace ilo_prevocu_isco08_2digits = 31 if census == 1560                            // 31 - Science and engineering associate professionals
capture replace ilo_prevocu_isco08_2digits = 31 if census == 1900                            // 31 - Science and engineering associate professionals
capture replace ilo_prevocu_isco08_2digits = 31 if census == 1910                            // 31 - Science and engineering associate professionals
capture replace ilo_prevocu_isco08_2digits = 31 if census == 1920                            // 31 - Science and engineering associate professionals
capture replace ilo_prevocu_isco08_2digits = 31 if census == 1930                            // 31 - Science and engineering associate professionals
capture replace ilo_prevocu_isco08_2digits = 31 if census == 1940                            // 31 - Science and engineering associate professionals
capture replace ilo_prevocu_isco08_2digits = 31 if census == 1965                            // 31 - Science and engineering associate professionals
capture replace ilo_prevocu_isco08_2digits = 31 if census == 3720                            // 31 / 54 - Science and engineering associate professionals
capture replace ilo_prevocu_isco08_2digits = 31 if census == 3750                            // 31 - Science and engineering associate professionals
capture replace ilo_prevocu_isco08_2digits = 31 if census == 6200                            // 31 - Science and engineering associate professionals
capture replace ilo_prevocu_isco08_2digits = 31 if census == 6660                            // 31 - Science and engineering associate professionals
capture replace ilo_prevocu_isco08_2digits = 31 if census == 7700                            // 31 - Science and engineering associate professionals
capture replace ilo_prevocu_isco08_2digits = 31 if census == 8040                            // 31 / 81 - Science and engineering associate professionals
capture replace ilo_prevocu_isco08_2digits = 31 if census == 8600                            // 31 - Science and engineering associate professionals
capture replace ilo_prevocu_isco08_2digits = 31 if census == 8620                            // 31 - Science and engineering associate professionals
capture replace ilo_prevocu_isco08_2digits = 31 if census == 8630                            // 31 / 81 - Science and engineering associate professionals
capture replace ilo_prevocu_isco08_2digits = 31 if census == 9030                            // 31 - Science and engineering associate professionals
capture replace ilo_prevocu_isco08_2digits = 31 if census == 9040                            // 31 - Science and engineering associate professionals
capture replace ilo_prevocu_isco08_2digits = 31 if census == 9310                            // 31 - Science and engineering associate professionals
capture replace ilo_prevocu_isco08_2digits = 31 if census == 9330                            // 31 - Science and engineering associate professionals
capture replace ilo_prevocu_isco08_2digits = 31 if census == 9650                            // 31 - Science and engineering associate professionals
capture replace ilo_prevocu_isco08_2digits = 32 if census == 3200                            // 32 - Health associate professionals
capture replace ilo_prevocu_isco08_2digits = 32 if census == 3220                            // 32 - Health associate professionals
capture replace ilo_prevocu_isco08_2digits = 32 if census == 3300                            // 32 - Health associate professionals
capture replace ilo_prevocu_isco08_2digits = 32 if census == 3310                            // 32 - Health associate professionals
capture replace ilo_prevocu_isco08_2digits = 32 if census == 3320                            // 32 - Health associate professionals
capture replace ilo_prevocu_isco08_2digits = 32 if census == 3400                            // 32 - Health associate professionals
capture replace ilo_prevocu_isco08_2digits = 32 if census == 3410                            // 32 - Health associate professionals
capture replace ilo_prevocu_isco08_2digits = 32 if census == 3420                            // 32 - Health associate professionals
capture replace ilo_prevocu_isco08_2digits = 32 if census == 3500                            // 32 - Health associate professionals
capture replace ilo_prevocu_isco08_2digits = 32 if census == 3510                            // 32 - Health associate professionals
capture replace ilo_prevocu_isco08_2digits = 32 if census == 3520                            // 32 - Health associate professionals
capture replace ilo_prevocu_isco08_2digits = 32 if census == 3530                            // 32 - Health associate professionals
capture replace ilo_prevocu_isco08_2digits = 32 if census == 3535                            // 32 - Health associate professionals
capture replace ilo_prevocu_isco08_2digits = 32 if census == 3540                            // 32 - Health associate professionals
capture replace ilo_prevocu_isco08_2digits = 32 if census == 3610                            // 32 - Health associate professionals
capture replace ilo_prevocu_isco08_2digits = 32 if census == 3620                            // 32 - Health associate professionals
capture replace ilo_prevocu_isco08_2digits = 32 if census == 3630                            // 32 - Health associate professionals
capture replace ilo_prevocu_isco08_2digits = 32 if census == 3640                            // 32 / 53 - Health associate professionals
capture replace ilo_prevocu_isco08_2digits = 32 if census == 3645                            // 32 - Health associate professionals
capture replace ilo_prevocu_isco08_2digits = 32 if census == 3648                            // 32 / 51 - Health associate professionals
capture replace ilo_prevocu_isco08_2digits = 32 if census == 3650                            // 32 - Health associate professionals
capture replace ilo_prevocu_isco08_2digits = 32 if census == 3655                            // 32 / 53 - Health associate professionals
capture replace ilo_prevocu_isco08_2digits = 32 if census == 6010                            // 32 / 33 / 75 - Health associate professionals
capture replace ilo_prevocu_isco08_2digits = 32 if census == 8760                            // 32 - Health associate professionals
capture replace ilo_prevocu_isco08_2digits = 32 if census == 9410                            // 32 - Health associate professionals
capture replace ilo_prevocu_isco08_2digits = 33 if census == 410                            // 33 - Business and administration associate professionals
capture replace ilo_prevocu_isco08_2digits = 33 if census == 500                            // 33 - Business and administration associate professionals
capture replace ilo_prevocu_isco08_2digits = 33 if census == 510                            // 33 - Business and administration associate professionals
capture replace ilo_prevocu_isco08_2digits = 33 if census == 520                            // 33 - Business and administration associate professionals
capture replace ilo_prevocu_isco08_2digits = 33 if census == 530                            // 33 - Business and administration associate professionals
capture replace ilo_prevocu_isco08_2digits = 33 if census == 540                            // 33 - Business and administration associate professionals
capture replace ilo_prevocu_isco08_2digits = 33 if census == 560                            // 33 - Business and administration associate professionals
capture replace ilo_prevocu_isco08_2digits = 33 if census == 565                            // 33 - Business and administration associate professionals
capture replace ilo_prevocu_isco08_2digits = 33 if census == 600                            // 33 - Business and administration associate professionals
capture replace ilo_prevocu_isco08_2digits = 33 if census == 720                            // 33 - Business and administration associate professionals
capture replace ilo_prevocu_isco08_2digits = 33 if census == 725                            // 33 - Business and administration associate professionals
capture replace ilo_prevocu_isco08_2digits = 33 if census == 810                            // 33 - Business and administration associate professionals
capture replace ilo_prevocu_isco08_2digits = 33 if census == 860                            // 33 - Business and administration associate professionals
capture replace ilo_prevocu_isco08_2digits = 33 if census == 910                            // 33 - Business and administration associate professionals
capture replace ilo_prevocu_isco08_2digits = 33 if census == 930                            // 33 - Business and administration associate professionals
capture replace ilo_prevocu_isco08_2digits = 33 if census == 950                            // 33 - Business and administration associate professionals
capture replace ilo_prevocu_isco08_2digits = 33 if census == 1240                            // 33 - Business and administration associate professionals
capture replace ilo_prevocu_isco08_2digits = 33 if census == 1950                            // 33 - Business and administration associate professionals
capture replace ilo_prevocu_isco08_2digits = 33 if census == 1960                            // 33 - Business and administration associate professionals
capture replace ilo_prevocu_isco08_2digits = 33 if census == 3646                            // 33 - Business and administration associate professionals
capture replace ilo_prevocu_isco08_2digits = 33 if census == 3710                            // 33 / 54 - Business and administration associate professionals
capture replace ilo_prevocu_isco08_2digits = 33 if census == 3820                            // 33 - Business and administration associate professionals
capture replace ilo_prevocu_isco08_2digits = 33 if census == 3850                            // 33 / 54 - Business and administration associate professionals
capture replace ilo_prevocu_isco08_2digits = 33 if census == 4800                            // 33 - Business and administration associate professionals
capture replace ilo_prevocu_isco08_2digits = 33 if census == 4810                            // 33 - Business and administration associate professionals
capture replace ilo_prevocu_isco08_2digits = 33 if census == 4820                            // 33 - Business and administration associate professionals
capture replace ilo_prevocu_isco08_2digits = 33 if census == 4830                            // 33 / 42 - Business and administration associate professionals
capture replace ilo_prevocu_isco08_2digits = 33 if census == 4840                            // 33 - Business and administration associate professionals
capture replace ilo_prevocu_isco08_2digits = 33 if census == 4920                            // 33 - Business and administration associate professionals
capture replace ilo_prevocu_isco08_2digits = 33 if census == 4960                            // 33 / 42 / 52 - Business and administration associate professionals
capture replace ilo_prevocu_isco08_2digits = 33 if census == 4965                            // 33 / 42 / 52 - Business and administration associate professionals
capture replace ilo_prevocu_isco08_2digits = 33 if census == 5000                            // 33 - Business and administration associate professionals
capture replace ilo_prevocu_isco08_2digits = 33 if census == 5120                            // 33 / 43 - Business and administration associate professionals
capture replace ilo_prevocu_isco08_2digits = 33 if census == 5220                            // 33 - Business and administration associate professionals
capture replace ilo_prevocu_isco08_2digits = 33 if census == 5250                            // 33 / 42 - Business and administration associate professionals
capture replace ilo_prevocu_isco08_2digits = 33 if census == 5500                            // 33 - Business and administration associate professionals
capture replace ilo_prevocu_isco08_2digits = 33 if census == 5610                            // 33 / 43 - Business and administration associate professionals
capture replace ilo_prevocu_isco08_2digits = 33 if census == 5920                            // 33 - Business and administration associate professionals
capture replace ilo_prevocu_isco08_2digits = 34 if census == 2016                            // 34 - Legal, social, cultural and related associate professionals
capture replace ilo_prevocu_isco08_2digits = 34 if census == 2060                            // 34 - Legal, social, cultural and related associate professionals
capture replace ilo_prevocu_isco08_2digits = 34 if census == 2105                            // 34 - Legal, social, cultural and related associate professionals
capture replace ilo_prevocu_isco08_2digits = 34 if census == 2140                            // 34 - Legal, social, cultural and related associate professionals
capture replace ilo_prevocu_isco08_2digits = 34 if census == 2145                            // 34 - Legal, social, cultural and related associate professionals
capture replace ilo_prevocu_isco08_2digits = 34 if census == 2150                            // 34 - Legal, social, cultural and related associate professionals
capture replace ilo_prevocu_isco08_2digits = 34 if census == 2160                            // 34 - Legal, social, cultural and related associate professionals
capture replace ilo_prevocu_isco08_2digits = 34 if census == 2440                            // 34 / 44 - Legal, social, cultural and related associate professionals
capture replace ilo_prevocu_isco08_2digits = 34 if census == 2720                            // 34 - Legal, social, cultural and related associate professionals
capture replace ilo_prevocu_isco08_2digits = 34 if census == 2860                            // 34 - Legal, social, cultural and related associate professionals
capture replace ilo_prevocu_isco08_2digits = 34 if census == 2910                            // 34 - Legal, social, cultural and related associate professionals
capture replace ilo_prevocu_isco08_2digits = 34 if census == 2960                            // 34 / 35 - Legal, social, cultural and related associate professionals
capture replace ilo_prevocu_isco08_2digits = 34 if census == 3800                            // 34 - Legal, social, cultural and related associate professionals
capture replace ilo_prevocu_isco08_2digits = 34 if census == 3910                            // 34 - Legal, social, cultural and related associate professionals
capture replace ilo_prevocu_isco08_2digits = 34 if census == 3920                            // 34 / 54 - Legal, social, cultural and related associate professionals
capture replace ilo_prevocu_isco08_2digits = 34 if census == 4000                            // 34 - Legal, social, cultural and related associate professionals
capture replace ilo_prevocu_isco08_2digits = 34 if census == 4010                            // 34 / 51 - Legal, social, cultural and related associate professionals
capture replace ilo_prevocu_isco08_2digits = 34 if census == 4320                            // 34 / 44 / 51 / 53 - Legal, social, cultural and related associate professionals
capture replace ilo_prevocu_isco08_2digits = 34 if census == 4430                            // 34 - Legal, social, cultural and related associate professionals
capture replace ilo_prevocu_isco08_2digits = 34 if census == 4620                            // 34 - Legal, social, cultural and related associate professionals
capture replace ilo_prevocu_isco08_2digits = 35 if census == 1040                            // 35 - Information and communications technicians
capture replace ilo_prevocu_isco08_2digits = 35 if census == 1050                            // 35 - Information and communications technicians
capture replace ilo_prevocu_isco08_2digits = 35 if census == 2900                            // 35 - Information and communications technicians
capture replace ilo_prevocu_isco08_2digits = 35 if census == 2920                            // 35 - Information and communications technicians
capture replace ilo_prevocu_isco08_2digits = 35 if census == 5800                            // 35 - Information and communications technicians
capture replace ilo_prevocu_isco08_2digits = 41 if census == 5150                            // 41 - General and keyboard clerks
capture replace ilo_prevocu_isco08_2digits = 41 if census == 5700                            // 41 - General and keyboard clerks
capture replace ilo_prevocu_isco08_2digits = 41 if census == 5810                            // 41 - General and keyboard clerks
capture replace ilo_prevocu_isco08_2digits = 41 if census == 5820                            // 41 - General and keyboard clerks
capture replace ilo_prevocu_isco08_2digits = 41 if census == 5860                            // 41 - General and keyboard clerks
capture replace ilo_prevocu_isco08_2digits = 42 if census == 726                            // 42 - Customer services clerks
capture replace ilo_prevocu_isco08_2digits = 42 if census == 4300                            // 42 - Customer services clerks
capture replace ilo_prevocu_isco08_2digits = 42 if census == 4400                            // 42 - Customer services clerks
capture replace ilo_prevocu_isco08_2digits = 42 if census == 5010                            // 42 - Customer services clerks
capture replace ilo_prevocu_isco08_2digits = 42 if census == 5020                            // 42 - Customer services clerks
capture replace ilo_prevocu_isco08_2digits = 42 if census == 5030                            // 42 - Customer services clerks
capture replace ilo_prevocu_isco08_2digits = 42 if census == 5100                            // 42 - Customer services clerks
capture replace ilo_prevocu_isco08_2digits = 42 if census == 5130                            // 42 - Customer services clerks
capture replace ilo_prevocu_isco08_2digits = 42 if census == 5160                            // 42 - Customer services clerks
capture replace ilo_prevocu_isco08_2digits = 42 if census == 5165                            // 42 / 43 - Customer services clerks
capture replace ilo_prevocu_isco08_2digits = 42 if census == 5210                            // 42 / 44 - Customer services clerks
capture replace ilo_prevocu_isco08_2digits = 42 if census == 5240                            // 42 - Customer services clerks
capture replace ilo_prevocu_isco08_2digits = 42 if census == 5300                            // 42 - Customer services clerks
capture replace ilo_prevocu_isco08_2digits = 42 if census == 5310                            // 42 - Customer services clerks
capture replace ilo_prevocu_isco08_2digits = 42 if census == 5400                            // 42 - Customer services clerks
capture replace ilo_prevocu_isco08_2digits = 42 if census == 5410                            // 42 - Customer services clerks
capture replace ilo_prevocu_isco08_2digits = 42 if census == 5420                            // 42 / 44 - Customer services clerks
capture replace ilo_prevocu_isco08_2digits = 42 if census == 5540                            // 42 / 44 - Customer services clerks
capture replace ilo_prevocu_isco08_2digits = 43 if census == 5110                            // 43 - Numerical and material recording clerks
capture replace ilo_prevocu_isco08_2digits = 43 if census == 5140                            // 43 - Numerical and material recording clerks
capture replace ilo_prevocu_isco08_2digits = 43 if census == 5200                            // 43 - Numerical and material recording clerks
capture replace ilo_prevocu_isco08_2digits = 43 if census == 5230                            // 43 - Numerical and material recording clerks
capture replace ilo_prevocu_isco08_2digits = 43 if census == 5330                            // 43 - Numerical and material recording clerks
capture replace ilo_prevocu_isco08_2digits = 43 if census == 5340                            // 43 - Numerical and material recording clerks
capture replace ilo_prevocu_isco08_2digits = 43 if census == 5600                            // 43 - Numerical and material recording clerks
capture replace ilo_prevocu_isco08_2digits = 43 if census == 5620                            // 43 / 93 - Numerical and material recording clerks
capture replace ilo_prevocu_isco08_2digits = 43 if census == 5630                            // 43 - Numerical and material recording clerks
capture replace ilo_prevocu_isco08_2digits = 43 if census == 5840                            // 43 - Numerical and material recording clerks
capture replace ilo_prevocu_isco08_2digits = 44 if census == 4610                            // 44 / 51 / 53 - Other clerical support workers
capture replace ilo_prevocu_isco08_2digits = 44 if census == 5260                            // 44 - Other clerical support workers
capture replace ilo_prevocu_isco08_2digits = 44 if census == 5320                            // 44 - Other clerical support workers
capture replace ilo_prevocu_isco08_2digits = 44 if census == 5350                            // 44 - Other clerical support workers
capture replace ilo_prevocu_isco08_2digits = 44 if census == 5360                            // 44 - Other clerical support workers
capture replace ilo_prevocu_isco08_2digits = 44 if census == 5510                            // 44 / 83 / 93 / 96 - Other clerical support workers
capture replace ilo_prevocu_isco08_2digits = 44 if census == 5550                            // 44 - Other clerical support workers
capture replace ilo_prevocu_isco08_2digits = 44 if census == 5560                            // 44 - Other clerical support workers
capture replace ilo_prevocu_isco08_2digits = 44 if census == 5850                            // 44 - Other clerical support workers
capture replace ilo_prevocu_isco08_2digits = 44 if census == 5900                            // 44 - Other clerical support workers
capture replace ilo_prevocu_isco08_2digits = 44 if census == 5910                            // 44 - Other clerical support workers
capture replace ilo_prevocu_isco08_2digits = 44 if census == 5930                            // 44 - Other clerical support workers
capture replace ilo_prevocu_isco08_2digits = 44 if census == 5940                            // 44 - Other clerical support workers
capture replace ilo_prevocu_isco08_2digits = 51 if census == 4020                            // 51 - Personal service workers
capture replace ilo_prevocu_isco08_2digits = 51 if census == 4040                            // 51 - Personal service workers
capture replace ilo_prevocu_isco08_2digits = 51 if census == 4110                            // 51 - Personal service workers
capture replace ilo_prevocu_isco08_2digits = 51 if census == 4120                            // 51 / 52 - Personal service workers
capture replace ilo_prevocu_isco08_2digits = 51 if census == 4150                            // 51 - Personal service workers
capture replace ilo_prevocu_isco08_2digits = 51 if census == 4200                            // 51 - Personal service workers
capture replace ilo_prevocu_isco08_2digits = 51 if census == 4220                            // 51 / 91 - Personal service workers
capture replace ilo_prevocu_isco08_2digits = 51 if census == 4340                            // 51 - Personal service workers
capture replace ilo_prevocu_isco08_2digits = 51 if census == 4350                            // 51 - Personal service workers
capture replace ilo_prevocu_isco08_2digits = 51 if census == 4460                            // 51 - Personal service workers
capture replace ilo_prevocu_isco08_2digits = 51 if census == 4465                            // 51 - Personal service workers
capture replace ilo_prevocu_isco08_2digits = 51 if census == 4500                            // 51 - Personal service workers
capture replace ilo_prevocu_isco08_2digits = 51 if census == 4510                            // 51 - Personal service workers
capture replace ilo_prevocu_isco08_2digits = 51 if census == 4520                            // 51 - Personal service workers
capture replace ilo_prevocu_isco08_2digits = 51 if census == 4540                            // 51 - Personal service workers
capture replace ilo_prevocu_isco08_2digits = 51 if census == 4550                            // 51 - Personal service workers
capture replace ilo_prevocu_isco08_2digits = 51 if census == 4640                            // 51 - Personal service workers
capture replace ilo_prevocu_isco08_2digits = 51 if census == 4650                            // 51 / 95 - Personal service workers
capture replace ilo_prevocu_isco08_2digits = 51 if census == 9050                            // 51 - Personal service workers
capture replace ilo_prevocu_isco08_2digits = 51 if census == 9415                            // 51 - Personal service workers
capture replace ilo_prevocu_isco08_2digits = 52 if census == 4050                            // 52 - Sales workers
capture replace ilo_prevocu_isco08_2digits = 52 if census == 4060                            // 52 - Sales workers
capture replace ilo_prevocu_isco08_2digits = 52 if census == 4130                            // 52 / 94 - Sales workers
capture replace ilo_prevocu_isco08_2digits = 52 if census == 4700                            // 52 - Sales workers
capture replace ilo_prevocu_isco08_2digits = 52 if census == 4720                            // 52 - Sales workers
capture replace ilo_prevocu_isco08_2digits = 52 if census == 4740                            // 52 - Sales workers
capture replace ilo_prevocu_isco08_2digits = 52 if census == 4750                            // 52 - Sales workers
capture replace ilo_prevocu_isco08_2digits = 52 if census == 4760                            // 52 - Sales workers
capture replace ilo_prevocu_isco08_2digits = 52 if census == 4900                            // 52 - Sales workers
capture replace ilo_prevocu_isco08_2digits = 52 if census == 4940                            // 52 - Sales workers
capture replace ilo_prevocu_isco08_2digits = 52 if census == 4950                            // 52 / 95 - Sales workers
capture replace ilo_prevocu_isco08_2digits = 52 if census == 9360                            // 52 - Sales workers
capture replace ilo_prevocu_isco08_2digits = 53 if census == 2540                            // 53 - Personal care workers
capture replace ilo_prevocu_isco08_2digits = 53 if census == 3600                            // 53 - Personal care workers
capture replace ilo_prevocu_isco08_2digits = 53 if census == 3647                            // 53 - Personal care workers
capture replace ilo_prevocu_isco08_2digits = 53 if census == 3649                            // 53 - Personal care workers
capture replace ilo_prevocu_isco08_2digits = 53 if census == 4600                            // 53 - Personal care workers
capture replace ilo_prevocu_isco08_2digits = 54 if census == 3700                            // 54 - Protective services workers
capture replace ilo_prevocu_isco08_2digits = 54 if census == 3730                            // 54 - Protective services workers
capture replace ilo_prevocu_isco08_2digits = 54 if census == 3740                            // 54 - Protective services workers
capture replace ilo_prevocu_isco08_2digits = 54 if census == 3830                            // 54 - Protective services workers
capture replace ilo_prevocu_isco08_2digits = 54 if census == 3840                            // 54 - Protective services workers
capture replace ilo_prevocu_isco08_2digits = 54 if census == 3860                            // 54 - Protective services workers
capture replace ilo_prevocu_isco08_2digits = 54 if census == 3900                            // 54 - Protective services workers
capture replace ilo_prevocu_isco08_2digits = 54 if census == 3930                            // 54 - Protective services workers
capture replace ilo_prevocu_isco08_2digits = 54 if census == 3940                            // 54 - Protective services workers
capture replace ilo_prevocu_isco08_2digits = 54 if census == 3945                            // 54 - Protective services workers
capture replace ilo_prevocu_isco08_2digits = 54 if census == 3950                            // 54 - Protective services workers
capture replace ilo_prevocu_isco08_2digits = 54 if census == 3955                            // 54 - Protective services workers
capture replace ilo_prevocu_isco08_2digits = 54 if census == 5520                            // 54 - Protective services workers
capture replace ilo_prevocu_isco08_2digits = 61 if census == 4210                            // 61 / 75 - Market-oriented skilled agricultural workers
capture replace ilo_prevocu_isco08_2digits = 61 if census == 6000                            // 61 / 62 - Market-oriented skilled agricultural workers
capture replace ilo_prevocu_isco08_2digits = 61 if census == 6005                            // 61 / 62 - Market-oriented skilled agricultural workers
capture replace ilo_prevocu_isco08_2digits = 61 if census == 6020                            // 61 / 62 - Market-oriented skilled agricultural workers
capture replace ilo_prevocu_isco08_2digits = 62 if census == 6100                            // 62 / 63 / 92 - Market-oriented skilled forestry, fishery and hunting workers
capture replace ilo_prevocu_isco08_2digits = 62 if census == 6110                            // 62 / 63 - Market-oriented skilled forestry, fishery and hunting workers
capture replace ilo_prevocu_isco08_2digits = 62 if census == 6120                            // 62 / 92 - Market-oriented skilled forestry, fishery and hunting workers
capture replace ilo_prevocu_isco08_2digits = 62 if census == 6130                            // 62 / 83 - Market-oriented skilled forestry, fishery and hunting workers
capture replace ilo_prevocu_isco08_2digits = 71 if census == 6220                            // 71 - Building and related trades workers, excluding electricians
capture replace ilo_prevocu_isco08_2digits = 71 if census == 6230                            // 71 - Building and related trades workers, excluding electricians
capture replace ilo_prevocu_isco08_2digits = 71 if census == 6240                            // 71 - Building and related trades workers, excluding electricians
capture replace ilo_prevocu_isco08_2digits = 71 if census == 6250                            // 71 - Building and related trades workers, excluding electricians
capture replace ilo_prevocu_isco08_2digits = 71 if census == 6330                            // 71 - Building and related trades workers, excluding electricians
capture replace ilo_prevocu_isco08_2digits = 71 if census == 6360                            // 71 - Building and related trades workers, excluding electricians
capture replace ilo_prevocu_isco08_2digits = 71 if census == 6400                            // 71 - Building and related trades workers, excluding electricians
capture replace ilo_prevocu_isco08_2digits = 71 if census == 6420                            // 71 - Building and related trades workers, excluding electricians
capture replace ilo_prevocu_isco08_2digits = 71 if census == 6430                            // 71 - Building and related trades workers, excluding electricians
capture replace ilo_prevocu_isco08_2digits = 71 if census == 6440                            // 71 - Building and related trades workers, excluding electricians
capture replace ilo_prevocu_isco08_2digits = 71 if census == 6460                            // 71 - Building and related trades workers, excluding electricians
capture replace ilo_prevocu_isco08_2digits = 71 if census == 6510                            // 71 - Building and related trades workers, excluding electricians
capture replace ilo_prevocu_isco08_2digits = 71 if census == 6515                            // 71 - Building and related trades workers, excluding electricians
capture replace ilo_prevocu_isco08_2digits = 71 if census == 6540                            // 71 / 74 - Building and related trades workers, excluding electricians
capture replace ilo_prevocu_isco08_2digits = 71 if census == 6710                            // 71 - Building and related trades workers, excluding electricians
capture replace ilo_prevocu_isco08_2digits = 71 if census == 6720                            // 71 - Building and related trades workers, excluding electricians
capture replace ilo_prevocu_isco08_2digits = 71 if census == 6760                            // 71 - Building and related trades workers, excluding electricians
capture replace ilo_prevocu_isco08_2digits = 71 if census == 6765                            // 71 - Building and related trades workers, excluding electricians
capture replace ilo_prevocu_isco08_2digits = 71 if census == 7000                            // 71 / 72 / 73 / 74 - Building and related trades workers, excluding electricians
capture replace ilo_prevocu_isco08_2digits = 71 if census == 7310                            // 71 - Building and related trades workers, excluding electricians
capture replace ilo_prevocu_isco08_2digits = 71 if census == 7315                            // 71 - Building and related trades workers, excluding electricians
capture replace ilo_prevocu_isco08_2digits = 71 if census == 7550                            // 71 - Building and related trades workers, excluding electricians
capture replace ilo_prevocu_isco08_2digits = 71 if census == 8810                            // 71 / 81 - Building and related trades workers, excluding electricians
capture replace ilo_prevocu_isco08_2digits = 72 if census == 6210                            // 72 - Metal, machinery and related trades workers
capture replace ilo_prevocu_isco08_2digits = 72 if census == 6500                            // 72 - Metal, machinery and related trades workers
capture replace ilo_prevocu_isco08_2digits = 72 if census == 6520                            // 72 - Metal, machinery and related trades workers
capture replace ilo_prevocu_isco08_2digits = 72 if census == 6530                            // 72 - Metal, machinery and related trades workers
capture replace ilo_prevocu_isco08_2digits = 72 if census == 7140                            // 72 - Metal, machinery and related trades workers
capture replace ilo_prevocu_isco08_2digits = 72 if census == 7150                            // 72 - Metal, machinery and related trades workers
capture replace ilo_prevocu_isco08_2digits = 72 if census == 7160                            // 72 - Metal, machinery and related trades workers
capture replace ilo_prevocu_isco08_2digits = 72 if census == 7200                            // 72 - Metal, machinery and related trades workers
capture replace ilo_prevocu_isco08_2digits = 72 if census == 7210                            // 72 - Metal, machinery and related trades workers
capture replace ilo_prevocu_isco08_2digits = 72 if census == 7220                            // 72 - Metal, machinery and related trades workers
capture replace ilo_prevocu_isco08_2digits = 72 if census == 7240                            // 72 - Metal, machinery and related trades workers
capture replace ilo_prevocu_isco08_2digits = 72 if census == 7260                            // 72 - Metal, machinery and related trades workers
capture replace ilo_prevocu_isco08_2digits = 72 if census == 7330                            // 72 - Metal, machinery and related trades workers
capture replace ilo_prevocu_isco08_2digits = 72 if census == 7350                            // 72 - Metal, machinery and related trades workers
capture replace ilo_prevocu_isco08_2digits = 72 if census == 7360                            // 72 - Metal, machinery and related trades workers
capture replace ilo_prevocu_isco08_2digits = 72 if census == 7440                            // 72 - Metal, machinery and related trades workers
capture replace ilo_prevocu_isco08_2digits = 72 if census == 7540                            // 72 - Metal, machinery and related trades workers
capture replace ilo_prevocu_isco08_2digits = 72 if census == 7560                            // 72 - Metal, machinery and related trades workers
capture replace ilo_prevocu_isco08_2digits = 72 if census == 7740                            // 72 - Metal, machinery and related trades workers
capture replace ilo_prevocu_isco08_2digits = 72 if census == 7900                            // 72 - Metal, machinery and related trades workers
capture replace ilo_prevocu_isco08_2digits = 72 if census == 7920                            // 72 / 81 - Metal, machinery and related trades workers
capture replace ilo_prevocu_isco08_2digits = 72 if census == 7930                            // 72 / 81 - Metal, machinery and related trades workers
capture replace ilo_prevocu_isco08_2digits = 72 if census == 7940                            // 72 / 81 - Metal, machinery and related trades workers
capture replace ilo_prevocu_isco08_2digits = 72 if census == 7950                            // 72 / 81 - Metal, machinery and related trades workers
capture replace ilo_prevocu_isco08_2digits = 72 if census == 7960                            // 72 / 81 - Metal, machinery and related trades workers
capture replace ilo_prevocu_isco08_2digits = 72 if census == 8000                            // 72 / 81 - Metal, machinery and related trades workers
capture replace ilo_prevocu_isco08_2digits = 72 if census == 8010                            // 72 / 81 - Metal, machinery and related trades workers
capture replace ilo_prevocu_isco08_2digits = 72 if census == 8020                            // 72 / 81 - Metal, machinery and related trades workers
capture replace ilo_prevocu_isco08_2digits = 72 if census == 8030                            // 72 - Metal, machinery and related trades workers
capture replace ilo_prevocu_isco08_2digits = 72 if census == 8060                            // 72 - Metal, machinery and related trades workers
capture replace ilo_prevocu_isco08_2digits = 72 if census == 8100                            // 72 - Metal, machinery and related trades workers
capture replace ilo_prevocu_isco08_2digits = 72 if census == 8120                            // 72 - Metal, machinery and related trades workers
capture replace ilo_prevocu_isco08_2digits = 72 if census == 8130                            // 72 - Metal, machinery and related trades workers
capture replace ilo_prevocu_isco08_2digits = 72 if census == 8140                            // 72 - Metal, machinery and related trades workers
capture replace ilo_prevocu_isco08_2digits = 72 if census == 8160                            // 72 - Metal, machinery and related trades workers
capture replace ilo_prevocu_isco08_2digits = 72 if census == 8210                            // 72 - Metal, machinery and related trades workers
capture replace ilo_prevocu_isco08_2digits = 72 if census == 8220                            // 72 / 81 - Metal, machinery and related trades workers
capture replace ilo_prevocu_isco08_2digits = 73 if census == 5830                            // 73 - Handicraft and printing workers
capture replace ilo_prevocu_isco08_2digits = 73 if census == 7430                            // 73 - Handicraft and printing workers
capture replace ilo_prevocu_isco08_2digits = 73 if census == 8230                            // 73 - Handicraft and printing workers
capture replace ilo_prevocu_isco08_2digits = 73 if census == 8240                            // 73 - Handicraft and printing workers
capture replace ilo_prevocu_isco08_2digits = 73 if census == 8250                            // 73 - Handicraft and printing workers
capture replace ilo_prevocu_isco08_2digits = 73 if census == 8255                            // 73 - Handicraft and printing workers
capture replace ilo_prevocu_isco08_2digits = 73 if census == 8256                            // 73 - Handicraft and printing workers
capture replace ilo_prevocu_isco08_2digits = 73 if census == 8260                            // 73 - Handicraft and printing workers
capture replace ilo_prevocu_isco08_2digits = 73 if census == 8330                            // 73 / 75 - Handicraft and printing workers
capture replace ilo_prevocu_isco08_2digits = 73 if census == 8550                            // 73 - Handicraft and printing workers
capture replace ilo_prevocu_isco08_2digits = 73 if census == 8710                            // 73 / 75 - Handicraft and printing workers
capture replace ilo_prevocu_isco08_2digits = 73 if census == 8750                            // 73 - Handicraft and printing workers
capture replace ilo_prevocu_isco08_2digits = 73 if census == 8910                            // 73 / 82 - Handicraft and printing workers
capture replace ilo_prevocu_isco08_2digits = 73 if census == 8920                            // 73 / 75 / 81 - Handicraft and printing workers
capture replace ilo_prevocu_isco08_2digits = 74 if census == 6350                            // 74 - Electrical and electronic trades workers
capture replace ilo_prevocu_isco08_2digits = 74 if census == 6355                            // 74 - Electrical and electronic trades workers
capture replace ilo_prevocu_isco08_2digits = 74 if census == 6700                            // 74 - Electrical and electronic trades workers
capture replace ilo_prevocu_isco08_2digits = 74 if census == 7010                            // 74 - Electrical and electronic trades workers
capture replace ilo_prevocu_isco08_2digits = 74 if census == 7020                            // 74 - Electrical and electronic trades workers
capture replace ilo_prevocu_isco08_2digits = 74 if census == 7030                            // 74 - Electrical and electronic trades workers
capture replace ilo_prevocu_isco08_2digits = 74 if census == 7040                            // 74 - Electrical and electronic trades workers
capture replace ilo_prevocu_isco08_2digits = 74 if census == 7050                            // 74 - Electrical and electronic trades workers
capture replace ilo_prevocu_isco08_2digits = 74 if census == 7100                            // 74 - Electrical and electronic trades workers
capture replace ilo_prevocu_isco08_2digits = 74 if census == 7110                            // 74 - Electrical and electronic trades workers
capture replace ilo_prevocu_isco08_2digits = 74 if census == 7120                            // 74 - Electrical and electronic trades workers
capture replace ilo_prevocu_isco08_2digits = 74 if census == 7130                            // 74 - Electrical and electronic trades workers
capture replace ilo_prevocu_isco08_2digits = 74 if census == 7300                            // 74 - Electrical and electronic trades workers
capture replace ilo_prevocu_isco08_2digits = 74 if census == 7320                            // 74 - Electrical and electronic trades workers
capture replace ilo_prevocu_isco08_2digits = 74 if census == 7410                            // 74 - Electrical and electronic trades workers
capture replace ilo_prevocu_isco08_2digits = 74 if census == 7420                            // 74 - Electrical and electronic trades workers
capture replace ilo_prevocu_isco08_2digits = 74 if census == 7600                            // 74 - Electrical and electronic trades workers
capture replace ilo_prevocu_isco08_2digits = 75 if census == 4240                            // 75 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_prevocu_isco08_2digits = 75 if census == 6040                            // 75 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_prevocu_isco08_2digits = 75 if census == 6830                            // 75 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_prevocu_isco08_2digits = 75 if census == 7520                            // 75 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_prevocu_isco08_2digits = 75 if census == 7800                            // 75 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_prevocu_isco08_2digits = 75 if census == 7810                            // 75 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_prevocu_isco08_2digits = 75 if census == 7830                            // 75 / 81 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_prevocu_isco08_2digits = 75 if census == 7840                            // 75 / 81 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_prevocu_isco08_2digits = 75 if census == 7850                            // 75 / 81 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_prevocu_isco08_2digits = 75 if census == 7855                            // 75 / 81 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_prevocu_isco08_2digits = 75 if census == 8350                            // 75 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_prevocu_isco08_2digits = 75 if census == 8400                            // 75 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_prevocu_isco08_2digits = 75 if census == 8440                            // 75 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_prevocu_isco08_2digits = 75 if census == 8450                            // 75 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_prevocu_isco08_2digits = 75 if census == 8460                            // 75 / 81 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_prevocu_isco08_2digits = 75 if census == 8500                            // 75 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_prevocu_isco08_2digits = 75 if census == 8510                            // 75 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_prevocu_isco08_2digits = 75 if census == 8520                            // 75 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_prevocu_isco08_2digits = 75 if census == 8540                            // 75 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_prevocu_isco08_2digits = 75 if census == 8720                            // 75 / 81 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_prevocu_isco08_2digits = 75 if census == 8730                            // 75 / 81 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_prevocu_isco08_2digits = 75 if census == 8740                            // 75 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_prevocu_isco08_2digits = 75 if census == 8850                            // 75 / 81 - Food processing, wood working, garment and other craft and related trades workers
capture replace ilo_prevocu_isco08_2digits = 81 if census == 6800                            // 81 - Stationary plant and machine operators
capture replace ilo_prevocu_isco08_2digits = 81 if census == 6820                            // 81 - Stationary plant and machine operators
capture replace ilo_prevocu_isco08_2digits = 81 if census == 6840                            // 81 - Stationary plant and machine operators
capture replace ilo_prevocu_isco08_2digits = 81 if census == 6910                            // 81 - Stationary plant and machine operators
capture replace ilo_prevocu_isco08_2digits = 81 if census == 6920                            // 81 - Stationary plant and machine operators
capture replace ilo_prevocu_isco08_2digits = 81 if census == 8150                            // 81 - Stationary plant and machine operators
capture replace ilo_prevocu_isco08_2digits = 81 if census == 8200                            // 81 - Stationary plant and machine operators
capture replace ilo_prevocu_isco08_2digits = 81 if census == 8300                            // 81 - Stationary plant and machine operators
capture replace ilo_prevocu_isco08_2digits = 81 if census == 8320                            // 81 - Stationary plant and machine operators
capture replace ilo_prevocu_isco08_2digits = 81 if census == 8340                            // 81 - Stationary plant and machine operators
capture replace ilo_prevocu_isco08_2digits = 81 if census == 8360                            // 81 - Stationary plant and machine operators
capture replace ilo_prevocu_isco08_2digits = 81 if census == 8410                            // 81 - Stationary plant and machine operators
capture replace ilo_prevocu_isco08_2digits = 81 if census == 8420                            // 81 - Stationary plant and machine operators
capture replace ilo_prevocu_isco08_2digits = 81 if census == 8430                            // 81 - Stationary plant and machine operators
capture replace ilo_prevocu_isco08_2digits = 81 if census == 8530                            // 81 - Stationary plant and machine operators
capture replace ilo_prevocu_isco08_2digits = 81 if census == 8610                            // 81 - Stationary plant and machine operators
capture replace ilo_prevocu_isco08_2digits = 81 if census == 8640                            // 81 - Stationary plant and machine operators
capture replace ilo_prevocu_isco08_2digits = 81 if census == 8650                            // 81 - Stationary plant and machine operators
capture replace ilo_prevocu_isco08_2digits = 81 if census == 8800                            // 81 - Stationary plant and machine operators
capture replace ilo_prevocu_isco08_2digits = 81 if census == 8830                            // 81 - Stationary plant and machine operators
capture replace ilo_prevocu_isco08_2digits = 81 if census == 8840                            // 81 - Stationary plant and machine operators
capture replace ilo_prevocu_isco08_2digits = 81 if census == 8860                            // 81 - Stationary plant and machine operators
capture replace ilo_prevocu_isco08_2digits = 81 if census == 8900                            // 81 - Stationary plant and machine operators
capture replace ilo_prevocu_isco08_2digits = 81 if census == 8930                            // 81 - Stationary plant and machine operators
capture replace ilo_prevocu_isco08_2digits = 81 if census == 8940                            // 81 - Stationary plant and machine operators
capture replace ilo_prevocu_isco08_2digits = 81 if census == 9500                            // 81 - Stationary plant and machine operators
capture replace ilo_prevocu_isco08_2digits = 82 if census == 7710                            // 82 - Assemblers
capture replace ilo_prevocu_isco08_2digits = 82 if census == 7720                            // 82 - Assemblers
capture replace ilo_prevocu_isco08_2digits = 82 if census == 7730                            // 82 - Assemblers
capture replace ilo_prevocu_isco08_2digits = 82 if census == 7750                            // 82 - Assemblers
capture replace ilo_prevocu_isco08_2digits = 83 if census == 6300                            // 83 - Drivers and mobile plant operators
capture replace ilo_prevocu_isco08_2digits = 83 if census == 6310                            // 83 - Drivers and mobile plant operators
capture replace ilo_prevocu_isco08_2digits = 83 if census == 6320                            // 83 - Drivers and mobile plant operators
capture replace ilo_prevocu_isco08_2digits = 83 if census == 9110                            // 83 - Drivers and mobile plant operators
capture replace ilo_prevocu_isco08_2digits = 83 if census == 9120                            // 83 - Drivers and mobile plant operators
capture replace ilo_prevocu_isco08_2digits = 83 if census == 9130                            // 83 - Drivers and mobile plant operators
capture replace ilo_prevocu_isco08_2digits = 83 if census == 9140                            // 83 - Drivers and mobile plant operators
capture replace ilo_prevocu_isco08_2digits = 83 if census == 9150                            // 83 - Drivers and mobile plant operators
capture replace ilo_prevocu_isco08_2digits = 83 if census == 9200                            // 83 - Drivers and mobile plant operators
capture replace ilo_prevocu_isco08_2digits = 83 if census == 9230                            // 83 - Drivers and mobile plant operators
capture replace ilo_prevocu_isco08_2digits = 83 if census == 9240                            // 83 - Drivers and mobile plant operators
capture replace ilo_prevocu_isco08_2digits = 83 if census == 9260                            // 83 - Drivers and mobile plant operators
capture replace ilo_prevocu_isco08_2digits = 83 if census == 9300                            // 83 - Drivers and mobile plant operators
capture replace ilo_prevocu_isco08_2digits = 83 if census == 9340                            // 83 - Drivers and mobile plant operators
capture replace ilo_prevocu_isco08_2digits = 83 if census == 9510                            // 83 - Drivers and mobile plant operators
capture replace ilo_prevocu_isco08_2digits = 83 if census == 9520                            // 83 - Drivers and mobile plant operators
capture replace ilo_prevocu_isco08_2digits = 83 if census == 9560                            // 83 - Drivers and mobile plant operators
capture replace ilo_prevocu_isco08_2digits = 83 if census == 9600                            // 83 - Drivers and mobile plant operators
capture replace ilo_prevocu_isco08_2digits = 83 if census == 9730                            // 83 - Drivers and mobile plant operators
capture replace ilo_prevocu_isco08_2digits = 91 if census == 4230                            // 91 - Cleaners and helpers
capture replace ilo_prevocu_isco08_2digits = 91 if census == 6750                            // 91 - Cleaners and helpers
capture replace ilo_prevocu_isco08_2digits = 91 if census == 8310                            // 91 - Cleaners and helpers
capture replace ilo_prevocu_isco08_2digits = 91 if census == 9610                            // 91 - Cleaners and helpers
capture replace ilo_prevocu_isco08_2digits = 92 if census == 4250                            // 92 - Agricultural, forestry and fishery labourers
capture replace ilo_prevocu_isco08_2digits = 92 if census == 6050                            // 92 - Agricultural, forestry and fishery labourers
capture replace ilo_prevocu_isco08_2digits = 93 if census == 6260                            // 93 - Labourers in mining, construction, manufacturing and transport
capture replace ilo_prevocu_isco08_2digits = 93 if census == 6600                            // 93 - Labourers in mining, construction, manufacturing and transport
capture replace ilo_prevocu_isco08_2digits = 93 if census == 6730                            // 93 - Labourers in mining, construction, manufacturing and transport
capture replace ilo_prevocu_isco08_2digits = 93 if census == 6740                            // 93 - Labourers in mining, construction, manufacturing and transport
capture replace ilo_prevocu_isco08_2digits = 93 if census == 6930                            // 93 - Labourers in mining, construction, manufacturing and transport
capture replace ilo_prevocu_isco08_2digits = 93 if census == 6940                            // 93 - Labourers in mining, construction, manufacturing and transport
capture replace ilo_prevocu_isco08_2digits = 93 if census == 8950                            // 93 - Labourers in mining, construction, manufacturing and transport
capture replace ilo_prevocu_isco08_2digits = 93 if census == 8960                            // 93 - Labourers in mining, construction, manufacturing and transport
capture replace ilo_prevocu_isco08_2digits = 93 if census == 8965                            // 93 - Labourers in mining, construction, manufacturing and transport
capture replace ilo_prevocu_isco08_2digits = 93 if census == 9000                            // 93 - Labourers in mining, construction, manufacturing and transport
capture replace ilo_prevocu_isco08_2digits = 93 if census == 9420                            // 93 - Labourers in mining, construction, manufacturing and transport
capture replace ilo_prevocu_isco08_2digits = 93 if census == 9620                            // 93 / 96 - Labourers in mining, construction, manufacturing and transport
capture replace ilo_prevocu_isco08_2digits = 93 if census == 9630                            // 93 - Labourers in mining, construction, manufacturing and transport
capture replace ilo_prevocu_isco08_2digits = 93 if census == 9640                            // 93 - Labourers in mining, construction, manufacturing and transport
capture replace ilo_prevocu_isco08_2digits = 93 if census == 9740                            // 93 - Labourers in mining, construction, manufacturing and transport
capture replace ilo_prevocu_isco08_2digits = 93 if census == 9750                            // 93 - Labourers in mining, construction, manufacturing and transport
capture replace ilo_prevocu_isco08_2digits = 94 if census == 4030                            // 94 - Food preparation assistants
capture replace ilo_prevocu_isco08_2digits = 94 if census == 4140                            // 94 - Food preparation assistants
capture replace ilo_prevocu_isco08_2digits = 94 if census == 4160                            // 94 - Food preparation assistants
capture replace ilo_prevocu_isco08_2digits = 96 if census == 4410                            // 96 - Refuse workers and other elementary workers
capture replace ilo_prevocu_isco08_2digits = 96 if census == 4420                            // 96 - Refuse workers and other elementary workers
capture replace ilo_prevocu_isco08_2digits = 96 if census == 4530                            // 96 - Refuse workers and other elementary workers
capture replace ilo_prevocu_isco08_2digits = 96 if census == 5530                            // 96 - Refuse workers and other elementary workers
capture replace ilo_prevocu_isco08_2digits = 96 if census == 7340                            // 96 - Refuse workers and other elementary workers
capture replace ilo_prevocu_isco08_2digits = 96 if census == 7510                            // 96 - Refuse workers and other elementary workers
capture replace ilo_prevocu_isco08_2digits = 96 if census == 7610                            // 96 - Refuse workers and other elementary workers
capture replace ilo_prevocu_isco08_2digits = 96 if census == 7620                            // 96 - Refuse workers and other elementary workers
capture replace ilo_prevocu_isco08_2digits = 96 if census == 7630                            // 96 - Refuse workers and other elementary workers
capture replace ilo_prevocu_isco08_2digits = 96 if census == 9350                            // 96 - Refuse workers and other elementary workers
capture replace ilo_prevocu_isco08_2digits = 96 if census == 9720                            // 96 - Refuse workers and other elementary workers

********************************************************************
********************************************************************
********************************************************************
****************** Step 2 / 2 distribute census category in all others possible ISCO category: 


capture replace ilo_prevocu_isco08_2digits = 13 if census == 20 & 1/4 < ilo_random_distribution & ilo_random_distribution <= 2/4
capture replace ilo_prevocu_isco08_2digits = 14 if census == 20 & 2/4 < ilo_random_distribution & ilo_random_distribution <= 3/4
capture replace ilo_prevocu_isco08_2digits = 52 if census == 20 & 3/4 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 12 if census == 60 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 13 if census == 120 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 71 if census == 220 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 12 if census == 430 & 1/4 < ilo_random_distribution & ilo_random_distribution <= 2/4
capture replace ilo_prevocu_isco08_2digits = 13 if census == 430 & 2/4 < ilo_random_distribution & ilo_random_distribution <= 3/4
capture replace ilo_prevocu_isco08_2digits = 14 if census == 430 & 3/4 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 33 if census == 620 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 33 if census == 630 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 24 if census == 650 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 33 if census == 730 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 33 if census == 740 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 35 if census == 1030 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 35 if census == 1100 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 35 if census == 1105 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 44 if census == 2440 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 34 if census == 2760 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_prevocu_isco08_2digits = 51 if census == 2760 & 2/3 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 26 if census == 2850 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 35 if census == 2960 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 32 if census == 3260 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 53 if census == 3640 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 51 if census == 3648 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 53 if census == 3655 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 54 if census == 3710 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 54 if census == 3720 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 54 if census == 3850 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 54 if census == 3920 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 51 if census == 4010 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 52 if census == 4120 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 94 if census == 4130 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 75 if census == 4210 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 91 if census == 4220 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 44 if census == 4320 & 1/4 < ilo_random_distribution & ilo_random_distribution <= 2/4
capture replace ilo_prevocu_isco08_2digits = 51 if census == 4320 & 2/4 < ilo_random_distribution & ilo_random_distribution <= 3/4
capture replace ilo_prevocu_isco08_2digits = 53 if census == 4320 & 3/4 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 51 if census == 4610 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_prevocu_isco08_2digits = 53 if census == 4610 & 2/3 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 95 if census == 4650 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 33 if census == 4710 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_prevocu_isco08_2digits = 42 if census == 4710 & 2/3 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 42 if census == 4830 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 33 if census == 4850 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 95 if census == 4950 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 42 if census == 4960 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_prevocu_isco08_2digits = 52 if census == 4960 & 2/3 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 42 if census == 4965 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_prevocu_isco08_2digits = 52 if census == 4965 & 2/3 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 43 if census == 5120 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 43 if census == 5165 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 44 if census == 5210 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 42 if census == 5250 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 44 if census == 5420 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 83 if census == 5510 & 1/4 < ilo_random_distribution & ilo_random_distribution <= 2/4
capture replace ilo_prevocu_isco08_2digits = 93 if census == 5510 & 2/4 < ilo_random_distribution & ilo_random_distribution <= 3/4
capture replace ilo_prevocu_isco08_2digits = 96 if census == 5510 & 3/4 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 44 if census == 5540 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 43 if census == 5610 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 93 if census == 5620 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 62 if census == 6000 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 62 if census == 6005 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 33 if census == 6010 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_prevocu_isco08_2digits = 75 if census == 6010 & 2/3 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 62 if census == 6020 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 63 if census == 6100 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_prevocu_isco08_2digits = 92 if census == 6100 & 2/3 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 63 if census == 6110 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 92 if census == 6120 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 83 if census == 6130 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 74 if census == 6540 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 72 if census == 7000 & 1/4 < ilo_random_distribution & ilo_random_distribution <= 2/4
capture replace ilo_prevocu_isco08_2digits = 73 if census == 7000 & 2/4 < ilo_random_distribution & ilo_random_distribution <= 3/4
capture replace ilo_prevocu_isco08_2digits = 74 if census == 7000 & 3/4 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 81 if census == 7830 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 81 if census == 7840 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 81 if census == 7850 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 81 if census == 7855 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 81 if census == 7920 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 81 if census == 7930 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 81 if census == 7940 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 81 if census == 7950 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 81 if census == 7960 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 81 if census == 8000 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 81 if census == 8010 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 81 if census == 8020 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 81 if census == 8040 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 81 if census == 8220 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 75 if census == 8330 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 81 if census == 8460 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 81 if census == 8630 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 75 if census == 8710 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 81 if census == 8720 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 81 if census == 8730 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 81 if census == 8810 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 81 if census == 8850 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 82 if census == 8910 & 1/2 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 75 if census == 8920 & 1/3 < ilo_random_distribution & ilo_random_distribution <= 2/3
capture replace ilo_prevocu_isco08_2digits = 81 if census == 8920 & 2/3 < ilo_random_distribution
capture replace ilo_prevocu_isco08_2digits = 96 if census == 9620 & 1/2 < ilo_random_distribution
	   
	   
	   
	   
	   replace ilo_prevocu_isco08_2digits = . if ilo_cat_une!=1

	   
	   
	   
	   
	   
	   
	   
	   
	   * labels already defined for main job
		        lab values ilo_prevocu_isco08_2digits ocu_isco08_2digits
	            lab var ilo_prevocu_isco08_2digits "Previous occupation (ISCO-08), 2 digit level"
				
	* 1-digit level 				
	gen ilo_prevocu_isco08=.
		replace ilo_prevocu_isco08 = 11 if ilo_prevocu_isco08_2digits == . & ilo_lfs==2 & ilo_cat_une==1
	    replace ilo_prevocu_isco08=int(ilo_prevocu_isco08_2digits/10) if (ilo_prevocu_isco08==. & ilo_lfs==2 & ilo_cat_une==1)      // The rest of the occupations
		replace ilo_prevocu_isco08=10 if (ilo_prevocu_isco08==0 & ilo_lfs==2 & ilo_cat_une==1)                                      // Armed forces
                * labels already defined for main job
		        lab val ilo_prevocu_isco08 ocu_isco08_lab
				lab var ilo_prevocu_isco08 "Previous occupation (ISCO-08)"
				
	* Aggregate:			
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

				
	* tab  ilo_prevocu_isco08 [iw = ilo_wgt] if ilo_cat_une == 1	, m

		drop census
	
}


		  
drop ilo_random_distribution	


***********************************************************************************************
*			PART 3.4. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		.

* comments : Marginally attached workers (Current Population Survey)
			* Persons not in the labor force who want and are available for work, and who have looked for a job sometime 
			* in the prior 12 months (or since the end of their last job if they held one within the past 12 months), 
			* but were not counted as unemployed because they had not searched for work in the 4 weeks preceding the survey. 
			* Discouraged workers are a subset of the marginally attached. (See Discouraged workers.)
* PULK		 HAVE YOU BEEN DOING ANYTHING TO FIND WORK DURING THE LAST 4 WEEKS? 1 Yes


* PEDWWNTO		DO YOU CURRENTLY WANT A JOB, EITHER FULL OR PART TIME?	
						* 1	YES, OR MAYBE, IT DEPENDS
						* 2	NO
						* 3	RETIRED
						* 4	DISABLED
						* 5	UNABLE
* PEDWRSN		WHAT IS THE MAIN REASON YOU WERE NOT LOOKING FOR WORK DURING THE LAST 4 WEEKS? 
						* 1	BELIEVES NO WORK AVAILABLE IN AREA OF EXPERTISE
						* 2	COULDN'T FIND ANY WORK
						* 3	LACKS NECESSARY SCHOOLING/TRAINING
						* 4	EMPLOYERS THINK TOO YOUNG OR TOO OLD
						* 5	OTHER TYPES OF DISCRIMINATION
						* 6 	CAN'T ARRANGE CHILD CARE
						* 7	FAMILY RESPONSIBILITIES
						* 8	IN SCHOOL OR OTHER TRAINING
						* 9	ILL-HEALTH, PHYSICAL DISABILITY
						* 10	TRANSPORTATION PROBLEMS
						* 11	OTHER - SPECIFY
* PEDWLKO		DID YOU LOOK FOR WORK AT ANY TIME IN THE LAST 12 MONTHS?  
						* 1	YES 
						* 2	 NO

* tab PEDWRSN  [iw = ilo_wgt] if ilo_lfs == 3 & PEDWWNTO == 1 & PEDWLKO == 1 & PEDW4WK != 1 & (PEDWLKWK !=2 | PEDWLKWK == 1)



		gen ilo_olf_dlma=. 

		* 1 - Seeking, not available (Unavailable jobseekers) # assuming that they are not availble else unemployed !!
		replace ilo_olf_dlma=1 if (ilo_lfs == 3 & PULK == 1 & PEDWAVL != 1)			
		* 2 - Not seeking, available (Available potential jobseekers)
		replace ilo_olf_dlma=2 if (PULK != 1 & PEDWAVL == 1 & ilo_lfs == 3)			
		* 3 - Not seeking, not available, willing (Willing non-jobseekers)
		replace ilo_olf_dlma=3 if (PEDWAVL != 1 & PULK != 1 & ilo_lfs == 3 & PEDWWNTO == 1) 
		* 4 - Not seeking, not available, not willing
		replace ilo_olf_dlma=4 if (PEDWAVL != 1 & PULK != 1 & ilo_lfs == 3 & PEDWWNTO != 1)
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
	
	
	* tab  ilo_olf_dlma [iw = ilo_wgt] if ilo_lfs == 3, m	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reason for not seeking job ('ilo_olf_reason')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

* may be could be try with ???????????
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
		replace ilo_olf_reason = 1 if inlist(PEDWRSN,1,2,3,4,5)	& ilo_lfs == 3		// 1 - Labour market (discouraged)
		* replace ilo_olf_reason = 1 if inlist(PEDWRSN)								// 2- Other labour market reasons
		replace ilo_olf_reason = 1 if inlist(PEDWRSN, 7,8,9,10)	& ilo_lfs == 3		// 3 - Personal / Family-related
		* replace ilo_olf_reason = 1 if inlist(PEDWRSN)								// 4 - Does not need/want to work
		replace ilo_olf_reason = 1 if ilo_olf_reason == . & ilo_lfs == 3			// 5 - Not elsewhere classified
			lab def ilo_olf_reason_lab 1 "1 - Labour market (discouraged)" 2 "2 - Other labour market reasons" 3 "3 - Personal / Family-related" 4 "4 - Does not need/want to work" 5 "5 - Not elsewhere classified"
			lab val ilo_olf_reason olf_reason_lab 
			lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job or being outside the labour market)"					
		



			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seeker ('ilo_dis')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* 
  	gen ilo_dis = .
		replace ilo_dis=1 if ilo_olf_reason == 1 & PEDWAVL == 1 & ilo_lfs == 3
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
	
		keep ilo*

		save ${country}_${source}_${time}_ILO, replace
		
		
