* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Zimbabwe LFS
* DATASET USED: 
* NOTES:
* Authors: Estefania Alaminos
* Who last updated the file: Estefania Alaminos 
* Starting Date: 11/10/2017
* Last updated: 11/10/2017
***********************************************************************************************


***********************************************************************************************
***********************************************************************************************

* 			1. SET UP WORK DIRECTORY, FILE NAME, VARIABLES AND FUNCTIONS

***********************************************************************************************
***********************************************************************************************
clear all 

set more off
*set more off, permanently

global path "J:\COMMON\STATISTICS\DPAU\MICRO"
global country "ZWE"
global source "LFS"
global time "2011"
global inputFile "Labour-Force - 2011 data - Anonymised.dta"
global inpath "${path}\\${country}\\${source}\\${time}\ORI"
global outpath "${path}\\${country}\\${source}\\${time}"

***********************************
************************************************************************************

* Important : if package « labutil » not already installed, install it in order to execute correctly the do-file

* ssc install labutil

************************************************************************************

*********************************************************************************************

* Load original dataset

*********************************************************************************************

cd "$inpath"
	use "$inputFile", clear
 rename *, lower 


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
split todrop, generate(todrop_) parse(Q)
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


   gen ilo_wgt=.
      	   replace ilo_wgt = wt
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


  
	gen ilo_geo = .
		replace ilo_geo = 1 if urban_rural == 1	// 1 - Urban
		replace ilo_geo = 2 if  urban_rural == 2	// 2 - Rural
		replace ilo_geo = 3 if  ilo_geo ==.					// 3 - Not elsewhere classified
		lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural" 3 "3 - Not elsewhere classified"
		lab val ilo_geo ilo_geo_lab
		lab var ilo_geo "Geographical coverage"	
		
		
		


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	

	gen ilo_sex = q4
		lab def ilo_sex_lab 1 "1 - Male" 2 "2 - Female"
		lab var ilo_sex "Sex"
		lab val ilo_sex ilo_sex_lab

    
	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------



	gen ilo_age = q5
	    lab var ilo_age "Age"



* Age groups

	gen ilo_age_5yrbands =.
		replace ilo_age_5yrbands = 1 if inrange(ilo_age,0,4)
		replace ilo_age_5yrbands = 2 if inrange(ilo_age,5,9)
		replace ilo_age_5yrbands = 3 if inrange(ilo_age,10,14)
		replace ilo_age_5yrbands = 4 if inrange(ilo_age,15,19)
		replace ilo_age_5yrbands = 5 if inrange(ilo_age,20,24)
		replace ilo_age_5yrbands = 6 if inrange(ilo_age,25,29)
		replace ilo_age_5yrbands = 7 if inrange(ilo_age,30,34)
		replace ilo_age_5yrbands = 8 if inrange(ilo_age,35,39)
		replace ilo_age_5yrbands = 9 if inrange(ilo_age,40,44)
		replace ilo_age_5yrbands = 10 if inrange(ilo_age,45,49)
		replace ilo_age_5yrbands = 11 if inrange(ilo_age,50,54)
		replace ilo_age_5yrbands = 12 if inrange(ilo_age,55,59)
		replace ilo_age_5yrbands = 13 if inrange(ilo_age,60,64)
		replace ilo_age_5yrbands = 14 if ilo_age >= 65 & ilo_age != .
			    lab def age_by5_lab 1 "0-4" 2 "5-9" 3 "10-14" 4 "15-19" 5 "20-24" 6 "25-29" ///
								    7 "30-34" 8 "35-39" 9 "40-44" 10 "45-49" 11 "50-54" 12 "55-59" ///
								    13 "60-64" 14 "65+"
			    lab val ilo_age_5yrbands age_by5_lab
			    lab var ilo_age_5yrbands "Age (5-year age bands)"
			
			
			
	gen ilo_age_10yrbands = .
		replace ilo_age_10yrbands = 1 if inrange(ilo_age,0,14)
		replace ilo_age_10yrbands = 2 if inrange(ilo_age,15,24)
		replace ilo_age_10yrbands = 3 if inrange(ilo_age,25,34)
		replace ilo_age_10yrbands = 4 if inrange(ilo_age,35,44)
		replace ilo_age_10yrbands = 5 if inrange(ilo_age,45,54)
		replace ilo_age_10yrbands = 6 if inrange(ilo_age,55,64)
		replace ilo_age_10yrbands = 7 if ilo_age >= 65 & ilo_age != .
			    lab def age_by10_lab 1 "<15" 2 "15-24" 3 "25-34" 4 "35-44" 5 "45-54" 6 "55-64" 7 "65+"
			    lab val ilo_age_10yrbands age_by10_lab
			    lab var ilo_age_10yrbands "Age (10-year age bands)"
	
	
	gen ilo_age_aggregate = .
		replace ilo_age_aggregate = 1 if inrange(ilo_age,0,14)
		replace ilo_age_aggregate = 2 if inrange(ilo_age,15,24)
		replace ilo_age_aggregate = 3 if inrange(ilo_age,25,54)
		replace ilo_age_aggregate = 4 if inrange(ilo_age,55,64)
		replace ilo_age_aggregate = 5 if ilo_age >= 65 & ilo_age != .
		    	lab def age_aggr_lab 1 "<15" 2 "15-24" 3 "25-54" 4 "55-64" 5 "65+"
			    lab val ilo_age_aggregate age_aggr_lab
			    lab var ilo_age_aggregate "Age (Aggregate)"
	


	
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education ('ilo_edu')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	
** Comment: - as the Survey is from 2011 I suppose that the mapping to be used here is isced 97
** Comment: - however, the categories of the original variable in the data set match with the mapping categories from isced 2011
	
	gen ilo_edu_isced97 = .
		replace ilo_edu_isced97 = 1 if q13 == 88  					// X - No schooling
		replace ilo_edu_isced97 = 2 if q13 == 0					// 0 - Pre-primary education
		replace ilo_edu_isced97 = 3 if inrange(q13,1,7)          // 1 - Primary education or first stage of basic education
		replace ilo_edu_isced97 = 4 if inrange(q13,11,14)            // 2 - Lower secondary or second stage of basic education
		replace ilo_edu_isced97 = 5 if inlist(q13,15,16)           // 3 - Upper secondary education
		*replace ilo_edu_isced97=6 if                         	// Post-secondary non-tertiary education
		replace ilo_edu_isced97 = 7 if q13 == 23       	        // First stage of tertiary education (not leading directly to an advanced research qualification)
		*replace ilo_edu_isced97=8 if    				        // Second stage of tertiary education (leading to an advanced research qualification)
		replace ilo_edu_isced97 = 9 if q13 == 99                // Level  not stated
			label def isced_97_lab 1 "X - No schooling" 2 "0 - Pre-primary education" 3 "1 - Primary education or first stage of basic education" 4 "2 - Lower secondary education or second stage of basic education" ///
							       5 "3 - Upper secondary education" 6 "4 - Post-secondary non-tertiary education" 7 "5 - First stage of tertiary education (not leading directly to an advanced research qualification)" ///
							       8 "6 - Second stage of tertiary education (leading to an advanced research qualification)" 9 "UNK - Level not stated"
			label val ilo_edu_isced97 isced_97_lab
			lab var ilo_edu_isced97 "Education (ISCED 97)"

		
	gen ilo_edu_aggregate = .
		replace ilo_edu_aggregate=1 if inlist(ilo_edu_isced97,1,2)
		replace ilo_edu_aggregate=2 if inlist(ilo_edu_isced97,3,4)
		replace ilo_edu_aggregate=3 if inlist(ilo_edu_isced97,5,6)
		replace ilo_edu_aggregate=4 if inlist(ilo_edu_isced97,7,8)
		replace ilo_edu_aggregate=5 if ilo_edu_isced97==9
			label def edu_aggr_lab 1 "1 - Less than basic" 2 "2 - Basic" 3 "3 - Intermediate" 4 "4 - Advanced" 5 "5 - Level not stated"
			label val ilo_edu_aggregate edu_aggr_lab
			label var ilo_edu_aggregate "Education (Aggregate level)"
			
			
			
	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education attendance ('ilo_edu_attendance')    
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* 'ilo_edu_attendance' refers to current enrolment, therefore here it is taking into account
* students attending to any type of education or training in the last 4 weeks and students in holidays

*** Comment: - variable q11 refers whether the individual has ever attended school. 
***				q11 = 2: at school; q11 == 1: never attending (therefore not currently at school)
***             q13 = 3: left school 
	
		gen ilo_edu_attendance = .
		replace ilo_edu_attendance = 1 if q11 == 2                        // 1 - Attending
		replace ilo_edu_attendance = 2 if inlist(q11,1,3)                //  2 - Not attending
		replace ilo_edu_attendance = 3 if  q11 ==  9                      // 3 - Not elsewhere classified
		lab def edu_attendance_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
		lab val ilo_edu_attendance edu_attendance_lab
		lab var ilo_edu_attendance "Education (Attendance)"



* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Disability status ('ilo_dsb')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

**p20 ???


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



	gen ilo_wap =.
		replace ilo_wap = 1 if ilo_age >= 15 & ilo_age !=.	// Working age population
			label def ilo_wap_lab 1 "Working age population"
			label val ilo_wap ilo_wap_lab
			label var ilo_wap "Working age population"

			

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Labour Force Status ('ilo_lfs')   
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------




gen ilo_lfs =.

		** EMPLOYED
		replace ilo_lfs = 1 if q21 == 1 & ilo_wap == 1         		// Employed (persons at work/family business)
		replace ilo_lfs = 1 if q22 == 1 & ilo_wap == 1         		//Employed (absent)
		
		** UNEMPLOYED (stric definition)
		replace ilo_lfs = 2 if ilo_lfs != 1 &  q47 == 1   & q48 ==1 & ilo_wap == 1 // Not in employment, seeking (actively), available
		
		** OUTSIDE LABOUR FORCE
		replace ilo_lfs = 3 if ilo_lfs != 1   & ilo_lfs != 2 & ilo_wap == 1 // Not in employment, future job starters

	
		label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside the Labour Force"
		label value ilo_lfs label_ilo_lfs
		label var ilo_lfs "Labour Force Status"




			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
 
** Comment: - I have categorised the missing observations as people with one job only

gen  ilo_mjh = .

** - 1. One job only

	replace ilo_mjh = 1 if  inlist(q36,2,9) & ilo_lfs == 1

** - 2. More than one job

	replace ilo_mjh = 2 if q36 == 1 & ilo_lfs == 1
	

	
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

 *** Comment: there is not information about cooperatives on the characteristics for main job. 
 
**** MAIN JOB

* Detailed categories:

		gen ilo_job1_ste_icse93 = .
		
			replace ilo_job1_ste_icse93 = 1 if inlist(q23,1,2) & ilo_lfs == 1   	// Employees
			
			replace ilo_job1_ste_icse93 = 2 if q23 == 3 & ilo_lfs==1	            // Employers
			
			replace ilo_job1_ste_icse93 = 3 if inlist(q23,4,5) & ilo_lfs==1      			// Own-account workers
			
			*replace ilo_job1_ste_icse93 = 4 if       			// Members of producers cooperatives

			replace ilo_job1_ste_icse93 = 5 if q23 == 6 & ilo_lfs==1	            // Contributing family workers
			
			replace ilo_job1_ste_icse93 = 6 if q23 == 9 & ilo_lfs==1               // Workers not classifiable by status
			
				label def label_ilo_ste_icse93 1 "1 - Employees" 2 "2 - Employers" 3 "3 - Own-account workers" ///                      
											   4 "4 - Members of producers cooperatives" 5 "5 - Contributing family workers" ///
											   6 "6 - Workers not classifiable by status"
				label val ilo_job1_ste_icse93 label_ilo_ste_icse93
				label var ilo_job1_ste_icse93 "Status in employment (ICSE 93)"
				
				
				
				
* Aggregate categories
 
		gen ilo_job1_ste_aggregate = . 
		
			replace ilo_job1_ste_aggregate = 1 if ilo_job1_ste_icse93 == 1 & ilo_lfs == 1			    // Employees
			
			replace ilo_job1_ste_aggregate = 2 if inlist(ilo_job1_ste_icse93,2,3,4,5) & ilo_lfs == 1 	// Self-employed
			
			replace ilo_job1_ste_aggregate = 3 if ilo_job1_ste_icse93 == 6 & ilo_lfs == 1				// Not elsewhere classified
			replace ilo_job1_ste_aggregate = 3 if ilo_job1_ste_icse93 == . & ilo_lfs == 1			
			
				lab def ste_aggr_lab 1 "1 - Employees" 2 "2 - Self-employed" 3 "3 - Not elsewhere classified"
				lab val ilo_job1_ste_aggregate ste_aggr_lab
				label var ilo_job1_ste_aggregate "Status in employment (Aggregate)"  				

				

				
**** SECOND JOB

* Detailed categories:

		gen ilo_job2_ste_icse93 = .
		
			replace ilo_job2_ste_icse93 = 1 if inlist(q37,1,2) & ilo_mjh == 2   	// Employees
			
			replace ilo_job2_ste_icse93 = 2 if q37 == 3 & ilo_mjh == 2 	            // Employers
			
			replace ilo_job2_ste_icse93 = 3 if inlist(q37,4,5) & ilo_mjh == 2       			// Own-account wor
			
			*replace ilo_job2_ste_icse93 = 4       		// Members of producers’ cooperatives

			replace ilo_job2_ste_icse93 = 5 if q37 == 6 & ilo_mjh == 2 	            // Contributing family workers
			
			replace ilo_job2_ste_icse93 = 6 if q37 == 9 & ilo_mjh == 2             // Workers not classifiable by status
			
				
				label val ilo_job2_ste_icse93 label_ilo_ste_icse93
				label var ilo_job2_ste_icse93 "Status in employment (ICSE 93) - Second job"
				
				
				
				
* Aggregate categories
 
		gen ilo_job2_ste_aggregate = . 
		
			replace ilo_job2_ste_aggregate = 1 if ilo_job2_ste_icse93 == 1  			    // Employees
			
			replace ilo_job2_ste_aggregate = 2 if inlist(ilo_job2_ste_icse93,2,3,4,5)   	// Self-employed
			
			replace ilo_job2_ste_aggregate = 3 if ilo_job2_ste_icse93 == 6  				// Not elsewhere classified
			*replace ilo_job2_ste_aggregate = 3 if ilo_job2_ste_icse93 == .  			
			
				lab val ilo_job2_ste_aggregate ste_aggr_lab
				label var ilo_job2_ste_aggregate "Status in employment (Aggregate) - Second job"  				
				
								


								
								


			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------				

* ISIC Rev. 4


***** MAIN JOB *****


gen ilo_job1_eco_isic4_2digits = .

replace ilo_job1_eco_isic4_2digits  =   1   if inrange(q30,0111,0322)   //   01 - Crop and animal production, hunting and related service activities
replace ilo_job1_eco_isic4_2digits  =   2   if inrange(q30,0510,0990)   //   02 - Forestry and logging
replace ilo_job1_eco_isic4_2digits  =   3   if inrange(q30,1010,3320)   //   03 - Fishing and aquaculture
replace ilo_job1_eco_isic4_2digits  =   5   if inrange(q30,3510,3530)   //   05 - Mining of coal and lignite
replace ilo_job1_eco_isic4_2digits  =   6   if inrange(q30,0610,0620)   //   06 - Extraction of crude petroleum and natural gas
replace ilo_job1_eco_isic4_2digits  =   7   if inrange(q30,0710,0729)   //   07 - Mining of metal ores
replace ilo_job1_eco_isic4_2digits  =   8   if inrange(q30,0810,0899)   //   08 - Other mining and quarrying
replace	ilo_job1_eco_isic4_2digits  =   9   if inrange(q30,0910,0990)   //	09 - Mining support service activities
replace	ilo_job1_eco_isic4_2digits	=	10	if	inrange	(q30,1010,1080)	//	10 - Manufacture of food products
replace	ilo_job1_eco_isic4_2digits	=	11	if	inrange	(q30,1101,1104)	//	11 - Manufacture of beverages
replace	ilo_job1_eco_isic4_2digits	=	12	if	q30 == 1200				//	12 - Manufacture of tobacco products
replace	ilo_job1_eco_isic4_2digits	=	13	if	inrange	(q30,1311,1399)	//	13 - Manufacture of textiles
replace	ilo_job1_eco_isic4_2digits	=	14	if	inrange	(q30,1410,1430)	//	14 - Manufacture of wearing apparel
replace	ilo_job1_eco_isic4_2digits	=	15	if	inrange	(q30,1511,1520)	//	15 - Manufacture of leather and related products
replace	ilo_job1_eco_isic4_2digits	=	16	if	inrange	(q30,1610,1629)	//	16 - Manufacture of wood and of products of wood and cork, except furniture; manufacture of articles of straw and plaiting materials
replace	ilo_job1_eco_isic4_2digits	=	17	if	inrange	(q30,1701,1709)	//	17 - Manufacture of paper and paper products
replace	ilo_job1_eco_isic4_2digits	=	18	if	inrange	(q30,1811,1820)	//	18 - Printing and reproduction of recorded media
replace	ilo_job1_eco_isic4_2digits	=	19	if	inrange	(q30,1910,1920)	//	19 - Manufacture of coke and refined petroleum products
replace	ilo_job1_eco_isic4_2digits	=	20	if	inrange	(q30,2011,2030)	//	20 - Manufacture of chemicals and chemical products
replace	ilo_job1_eco_isic4_2digits	=	21	if	 		q30 == 2100	    //	21 - Manufacture of basic pharmaceutical products and pharmaceutical preparations
replace	ilo_job1_eco_isic4_2digits	=	22	if	inrange	(q30,2211,2220)	//	22 - Manufacture of rubber and plastics products
replace	ilo_job1_eco_isic4_2digits	=	23	if	inrange	(q30,2310,2399)	//	23 - Manufacture of other non-metallic mineral products
replace	ilo_job1_eco_isic4_2digits	=	24	if	inrange	(q30,2410,2432)	//	24 - Manufacture of basic metals
replace	ilo_job1_eco_isic4_2digits	=	25	if	inrange	(q30,2511,2599)	//	25 - Manufacture of fabricated metal products, except machinery and equipment
replace	ilo_job1_eco_isic4_2digits	=	26	if	inrange	(q30,2610,2680)	//	26 - Manufacture of computer, electronic and optical products
replace	ilo_job1_eco_isic4_2digits	=	27	if	inrange	(q30,2710,2790)	//	27 - Manufacture of electrical equipment
replace	ilo_job1_eco_isic4_2digits	=	28	if	inrange	(q30,2811,2829)	//	28 - Manufacture of machinery and equipment n.e.c.
replace	ilo_job1_eco_isic4_2digits	=	29	if	inrange	(q30,2910,2930)	//	29 - Manufacture of motor vehicles, trailers and semi-trailers
replace	ilo_job1_eco_isic4_2digits	=	30	if	inrange	(q30,3011,3099)	//	30 - Manufacture of other transport equipment
replace	ilo_job1_eco_isic4_2digits	=	31	if	inrange		q30 == 3100	//	31 - Manufacture of furniture
replace	ilo_job1_eco_isic4_2digits	=	32	if	inrange	(q30,3211,3290)	//	32 - Other manufacturing
replace	ilo_job1_eco_isic4_2digits	=	33	if	inrange	(q30,3311,3320)	//	33 - Repair and installation of machinery and equipment
replace	ilo_job1_eco_isic4_2digits	=	35	if	inrange	(q30,3510,3530)	//	35 - Electricity, gas, steam and air conditioning supply
replace	ilo_job1_eco_isic4_2digits	=	36	if	 		q30 == 3600	    //	36 - Water collection, treatment and supply
replace	ilo_job1_eco_isic4_2digits	=	37	if			q30 == 3700		//	37 - Sewerage
replace	ilo_job1_eco_isic4_2digits	=	38	if	inrange	(q30,3810,3830)	//	38 - Waste collection, treatment and disposal activities; materials recovery
replace	ilo_job1_eco_isic4_2digits	=	39	if		q30 == 3900			//	39 - Remediation activities and other waste management services
replace	ilo_job1_eco_isic4_2digits	=	41	if		q30 == 4100			//	41 - Construction of buildings
replace	ilo_job1_eco_isic4_2digits	=	42	if	inrange	(q30,4210,4290)	//	42 - Civil engineering
replace	ilo_job1_eco_isic4_2digits	=	43	if	inrange	(q30,4310,4390)	//	43 - Specialized construction activities
replace	ilo_job1_eco_isic4_2digits	=	45	if	inrange	(q30,4510,4540)	//	45 - Wholesale and retail trade and repair of motor vehicles and motorcycles
replace	ilo_job1_eco_isic4_2digits	=	46	if	inrange	(q30,4610,4690)	//	46 - Wholesale trade, except of motor vehicles and motorcycles
replace	ilo_job1_eco_isic4_2digits	=	47	if	inrange	(q30,4710,4799)	//	47 - Retail trade, except of motor vehicles and motorcycles
replace	ilo_job1_eco_isic4_2digits	=	49	if	inrange	(q30,4910,4930)	//	49 - Land transport and transport via pipelines
replace	ilo_job1_eco_isic4_2digits	=	50	if	inrange	(q30,5010,5022)	//	50 - Water transport
replace	ilo_job1_eco_isic4_2digits	=	51	if	inrange	(q30,5110,5120)	//	51 - Air transport
replace	ilo_job1_eco_isic4_2digits	=	52	if	inrange	(q30,5210,5229)	//	52 - Warehousing and support activities for transportation
replace	ilo_job1_eco_isic4_2digits	=	53	if	inrange	(q30,5310,5320)	//	53 - Postal and courier activities
replace	ilo_job1_eco_isic4_2digits	=	55	if	inrange	(q30,5510,5590)	//	55 - Accommodation
replace	ilo_job1_eco_isic4_2digits	=	56	if	inrange	(q30,5610,5630)	//	56 - Food and beverage service activities
replace	ilo_job1_eco_isic4_2digits	=	58	if	inrange	(q30,5810,5820)	//	58 - Publishing activities
replace	ilo_job1_eco_isic4_2digits	=	59	if	inrange	(q30,5910,5920)	//	59 - Motion picture, video and television programme production, sound recording and music publishing activities
replace	ilo_job1_eco_isic4_2digits	=	60	if	inrange	(q30,6010,6020)	//	60 - Programming and broadcasting activities
replace	ilo_job1_eco_isic4_2digits	=	61	if	inrange	(q30,6110,6190)	//	61 - Telecommunications
replace	ilo_job1_eco_isic4_2digits	=	62	if	inrange	(q30,6201,6209)	//	62 - Computer programming, consultancy and related activities
replace	ilo_job1_eco_isic4_2digits	=	63	if	inrange	(q30,6310,6399)	//	63 - Information service activities
replace	ilo_job1_eco_isic4_2digits	=	64	if	inrange	(q30,6411,6499)	//	64 - Financial service activities, except insurance and pension funding
replace	ilo_job1_eco_isic4_2digits	=	65	if	inrange	(q30,6510,6530)	//	65 - Insurance, reinsurance and pension funding, except compulsory social security
replace	ilo_job1_eco_isic4_2digits	=	66	if	inrange	(q30,6610,6630)	//	66 - Activities auxiliary to financial service and insurance activities
replace	ilo_job1_eco_isic4_2digits	=	68	if	inrange	(q30,6810,6820)	//	68 - Real estate activities
replace	ilo_job1_eco_isic4_2digits	=	69	if	inrange	(q30,6910,6920)	//	69 - Legal and accounting activities
replace	ilo_job1_eco_isic4_2digits	=	70	if	inrange	(q30,7010,7020)	//	70 - Activities of head offices; management consultancy activities
replace	ilo_job1_eco_isic4_2digits	=	71	if	inrange	(q30,7110,7120)	//	71 - Architectural and engineering activities; technical testing and analysis
replace	ilo_job1_eco_isic4_2digits	=	72	if	inrange	(q30,7210,7220)	//	72 - Scientific research and development
replace	ilo_job1_eco_isic4_2digits	=	73	if	inrange	(q30,7310,7320)	//	73 - Advertising and market research
replace	ilo_job1_eco_isic4_2digits	=	74	if	inrange	(q30,7410,7490) //	74 - Other professional, scientific and technical activities
replace	ilo_job1_eco_isic4_2digits	=	75	if		q30 == 7500			//	75 - Veterinary activities
replace	ilo_job1_eco_isic4_2digits	=	77	if	inrange	(q30,7710,7740)	//	77 - Rental and leasing activities
replace	ilo_job1_eco_isic4_2digits	=	78	if	inrange	(q30,7810,7830)	//	78 - Employment activities
replace	ilo_job1_eco_isic4_2digits	=	79	if	inrange	(q30,7910,7990)	//	79 - Travel agency, tour operator, reservation service and related activities
replace	ilo_job1_eco_isic4_2digits	=	80	if	inrange	(q30,8010,8030)	//	80 - Security and investigation activities
replace	ilo_job1_eco_isic4_2digits	=	81	if	inrange	(q30,8110,8130)	//	81 - Services to buildings and landscape activities
replace	ilo_job1_eco_isic4_2digits	=	82	if	inrange	(q30,8210,8299)	//	82 - Office administrative, office support and other business support activities
replace	ilo_job1_eco_isic4_2digits	=	84	if	inrange	(q30,8410,8430)	//	84 - Public administration and defence; compulsory social security
replace	ilo_job1_eco_isic4_2digits	=	85	if	inrange	(q30,8510,8550)	//	85 - Education
replace	ilo_job1_eco_isic4_2digits	=	86	if	inrange	(q30,8610,8690)	//	86 - Human health activities
replace	ilo_job1_eco_isic4_2digits	=	87	if	inrange	(q30,8710,8790)	//	87 - Residential care activities
replace	ilo_job1_eco_isic4_2digits	=	88	if	inrange	(q30,8810,8890)	//	88 - Social work activities without accommodation
replace	ilo_job1_eco_isic4_2digits	=	90	if	inrange		q30 == 9000	//	90 - Creative, arts and entertainment activities
replace	ilo_job1_eco_isic4_2digits	=	91	if	inrange	(q30,9100,9103)	//	91 - Libraries, archives, museums and other cultural activities
replace	ilo_job1_eco_isic4_2digits	=	92	if	inrange		q30 == 9200				//	92 - Gambling and betting activities
replace	ilo_job1_eco_isic4_2digits	=	93	if	inrange	(q30,9310,9329)	//	93 - Sports activities and amusement and recreation activities
replace	ilo_job1_eco_isic4_2digits	=	94	if	inrange	(q30,9410,9499)	//	94 - Activities of membership organizations
replace	ilo_job1_eco_isic4_2digits	=	95	if	inrange	(q30,9510,9529)	//	95 - Repair of computers and personal and household goods
replace	ilo_job1_eco_isic4_2digits	=	96	if	inrange	(q30,9601,9609)	//	96 - Other personal service activities
replace	ilo_job1_eco_isic4_2digits	=	97	if	inrange		q30 == 9700				//	97 - Activities of households as employers of domestic personnel
replace	ilo_job1_eco_isic4_2digits	=	98	if	inrange	(q30,9810,9820)	//	98 - Undifferentiated goods- and services-producing activities of private households for own use
replace	ilo_job1_eco_isic4_2digits	=	99	if	inrange		q30 == 9900	//	99 - Activities of extraterritorial organizations and bodies


	lab def eco_isic4_2digits_lab 1	"01 - Crop and animal production, hunting and related service activities" 2	"02 - Forestry and logging" ///
									3	"03 - Fishing and aquaculture" 5 "05 - Mining of coal and lignite" 6	"06 - Extraction of crude petroleum and natural gas" ///
									7	"07 - Mining of metal ores" 8 "08 - Other mining and quarrying" 9 "09 - Mining support service activities" ///
									10	"10 - Manufacture of food products" 11	"11 - Manufacture of beverages" 12	"12 - Manufacture of tobacco products" ///
									13	"13 - Manufacture of textiles" 14 "14 - Manufacture of wearing apparel" 15	"15 - Manufacture of leather and related products" ///
                                    16	"16 - Manufacture of wood and of products of wood and cork, except furniture; manufacture of articles of straw and plaiting materials" ///
                                    17	"17 - Manufacture of paper and paper products" 18 "18 - Printing and reproduction of recorded media" ///
                                    19	"19 - Manufacture of coke and refined petroleum products" 20 "20 - Manufacture of chemicals and chemical products" ///
                                    21	"21 - Manufacture of basic pharmaceutical products and pharmaceutical preparations" 22	"22 - Manufacture of rubber and plastics products" ///
                                    23	"23 - Manufacture of other non-metallic mineral products" 24 "24 - Manufacture of basic metals" ///
                                    25	"25 - Manufacture of fabricated metal products, except machinery and equipment" 26	"26 - Manufacture of computer, electronic and optical products" ///
                                    27	"27 - Manufacture of electrical equipment" 28	"28 - Manufacture of machinery and equipment n.e.c." ///
                                    29	"29 - Manufacture of motor vehicles, trailers and semi-trailers" 30	"30 - Manufacture of other transport equipment"///
                                    31	"31 - Manufacture of furniture" 32	"32 - Other manufacturing" 33	"33 - Repair and installation of machinery and equipment" ///
                                    35	"35 - Electricity, gas, steam and air conditioning supply" 36	"36 - Water collection, treatment and supply" 37	"37 - Sewerage" ///
                                    38	"38 - Waste collection, treatment and disposal activities; materials recovery" 39	"39 - Remediation activities and other waste management services" ///
                                    41	"41 - Construction of buildings" 42	"42 - Civil engineering" 43	"43 - Specialized construction activities" ///
                                    45	"45 - Wholesale and retail trade and repair of motor vehicles and motorcycles" 46	"46 - Wholesale trade, except of motor vehicles and motorcycles" ///
                                    47	"47 - Retail trade, except of motor vehicles and motorcycles" 49	"49 - Land transport and transport via pipelines" 50	"50 - Water transport" ///
51	"51 - Air transport"
52	"52 - Warehousing and support activities for transportation"
53	"53 - Postal and courier activities"
55	"55 - Accommodation"
56	"56 - Food and beverage service activities"
58	"58 - Publishing activities"
59	"59 - Motion picture, video and television programme production, sound recording and music publishing activities"
60	"60 - Programming and broadcasting activities"
61	"61 - Telecommunications"
62	"62 - Computer programming, consultancy and related activities"
63	"63 - Information service activities"
64	"64 - Financial service activities, except insurance and pension funding"
65	"65 - Insurance, reinsurance and pension funding, except compulsory social security"
66	"66 - Activities auxiliary to financial service and insurance activities"
68	"68 - Real estate activities"
69	"69 - Legal and accounting activities"
70	"70 - Activities of head offices; management consultancy activities"
71	"71 - Architectural and engineering activities; technical testing and analysis"
72	"72 - Scientific research and development"
73	"73 - Advertising and market research"
74	"74 - Other professional, scientific and technical activities"
75	"75 - Veterinary activities"
77	"77 - Rental and leasing activities"
78	"78 - Employment activities"
79	"79 - Travel agency, tour operator, reservation service and related activities"
80	"80 - Security and investigation activities"
81	"81 - Services to buildings and landscape activities"
82	"82 - Office administrative, office support and other business support activities"
84	"84 - Public administration and defence; compulsory social security"
85	"85 - Education"
86	"86 - Human health activities"
87	"87 - Residential care activities"
88	"88 - Social work activities without accommodation"
90	"90 - Creative, arts and entertainment activities"
91	"91 - Libraries, archives, museums and other cultural activities"
92	"92 - Gambling and betting activities"
93	"93 - Sports activities and amusement and recreation activities"
94	"94 - Activities of membership organizations"
95	"95 - Repair of computers and personal and household goods"
96	"96 - Other personal service activities"
97	"97 - Activities of households as employers of domestic personnel"
98	"98 - Undifferentiated goods- and services-producing activities of private households for own use"
99	"99 - Activities of extraterritorial organizations and bodies"

				
				
				
				
				
				
				
				
				
				
				
				
				
				lab val ilo_job1_eco_isic4 eco_isic4_lab
				lab var ilo_job1_eco_isic4 "Economic activity (ISIC Rev. 4)"
			
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
