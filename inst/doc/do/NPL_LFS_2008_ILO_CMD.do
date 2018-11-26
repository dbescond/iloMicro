* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Nepal, 2007/08
* DATASET USED: Nepal LFS 2007/08
* NOTES: 
* Files created: Standard variables on LFS Nepal 2007/08
* Authors: ILO / Department of Statistics / DPAU

* Starting Date: 11 October 2016
* Last updated: 08 February 2018
***********************************************************************************************


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
global country "NPL" /*ref_area: ISO 3 Code from the workflow*/
global source "LFS"  /*survey: Acronym from the workflow*/
global time "2008"  /*time*/
global inputFile "NPL_LFS_2008.dta" /*name of the input file in stata format*/
global inpath "${path}\\${country}\\${source}\\${time}\ORI"
global temppath "${path}\_Admin"
global outpath "${path}\\${country}\\${source}\\${time}"

********************************************************************************
********************************************************************************

cd "$inpath"
	use ${inputFile}, clear
	
	

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

	gen ilo_wgt=AWEIGHT
		lab var ilo_wgt "Sample weight"		
		

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time period ('ilo_time')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Year 2007/08 - As we produce only yearly indicators, only 2008 is considered
	
	gen ilo_time=1
		lab def lab_time 1 "2008" 
		lab val ilo_time lab_time
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


	gen ilo_geo=URBRURL
		lab def ilo_geo_lab 1 "Urban" 2 "Rural"
		lab val ilo_geo ilo_geo_lab
		lab var ilo_geo "Geographical coverage"	


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_sex=Q09
		lab def ilo_sex_lab 1 "Male" 2 "Female"
		lab var ilo_sex "Sex"
		lab val ilo_sex ilo_sex_lab

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	

	gen ilo_age=Q10
		lab var ilo_age "Age"
		

*Age groups

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

			
/* I use correspondance between Nepal National classification and ISCED 2011*/

* I attched the table of corespondance in NPL folder


	gen ilo_edu_isced11=.
		replace ilo_edu_isced11=1 if Q30==1 | Q29==2 		// No schooling
		replace ilo_edu_isced11=2 if Q30==2  				// Early childhood education
		replace ilo_edu_isced11=3 if inrange(Q30,3,4) 		// Primary education
		replace ilo_edu_isced11=4 if inrange(Q30,5,7)   	// Lower secondary education
		replace ilo_edu_isced11=5 if inrange(Q30,8,10)   	// Upper secondary education
		*replace ilo_edu_isced11=6 if 					  	// Post-secondary non-tertiary
		replace ilo_edu_isced11=7 if inrange(Q30,11,12)  	// Short-cycle tertiary education
		replace ilo_edu_isced11=8 if Q30==13  				// Bachelor or equivalent
		replace ilo_edu_isced11=9 if Q30==14  				// Master's or equivalent level
		*replace ilo_edu_isced11=10							// Doctoral or equivalent level
		replace ilo_edu_isced11=11 if ilo_edu_isced11==.	// Not elsewhere classified
			label def isced_11_labelm 1 "X - No schooling" 2 "0 - Early childhood education" 3 "1 - Primary education" 4 "2 - Lower secondary education" ///
							5 "3 - Upper secondary education" 6 "4 - Post-secondary non-tertiary education"  7 "5 - Short-cycle tertiary education" ///
							8 "6 - Bachelor's or equivalent level" 9 "7 - Master's or equivalent level" 10 "8 - Doctoral or equivalent level" 11 "9 - Not elsewhere classified"
			label val ilo_edu_isced11 isced_11_labelm
			lab var ilo_edu_isced11 "Education (ISCED 11)"	
	

	gen ilo_edu_aggregate=.
		replace ilo_edu_aggregate=1 if inlist(ilo_edu_isced11,1,2)  	// Less than basic
		replace ilo_edu_aggregate=2 if inlist(ilo_edu_isced11,3,4)		// Basic
		replace ilo_edu_aggregate=3 if inlist(ilo_edu_isced11,5,6)		// Intermediate
		replace ilo_edu_aggregate=4 if inrange(ilo_edu_isced11,7,10)	// Advanced
		replace ilo_edu_aggregate=5 if ilo_edu_isced11==11
			label def edu_aggr_lab 1 "1 - Less than basic" 2 "2 - Basic" 3 "3 - Intermediate" 4 "4 - Advanced" 5 "5 - Level not stated"
			label val ilo_edu_aggregate edu_aggr_lab
			label var ilo_edu_aggregate "Education (Aggregate levels)"
	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education attendance ('ilo_edu_attendance')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_edu_attendance=.
		replace ilo_edu_attendance=1 if (Q28==1 |Q29==1 |Q31==1)   		// Attending
		replace ilo_edu_attendance=2 if (Q28==2 | Q29==2| Q31==2)		// Not attending
		replace ilo_edu_attendance=3 if (ilo_edu_attendance==.)			// Not elsewhere classified		
			label def edu_att_lab_F 1 "Attending" 2 "Not attending" 3 "Not elsewhere classified"
			label val ilo_edu_attendance edu_att_lab_F
			label var ilo_edu_attendance "Education (Attendance)"


* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			           Marital status ('ilo_mrts') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: - Marital status question is only made to people aged 10 years and above
*          - No info on union/cohabiting
	
	* Detailed
	gen ilo_mrts_details=.
	    replace ilo_mrts_details=1 if Q13==1                                    // Single
		replace ilo_mrts_details=2 if Q13==2	                                // Married
		*replace ilo_mrts_details=3 if                                          // Union / cohabiting
		replace ilo_mrts_details=4 if Q13==3                                    // Widowed
		replace ilo_mrts_details=5 if inlist(Q13,4,5)                           // Divorced / separated
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

* No information

		
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
* Comment: WAP = 15+ 

	gen ilo_wap=.
		replace ilo_wap=1 if ilo_age>=15 & ilo_age!=.
		replace ilo_wap=0 if ilo_age<15
			label var ilo_wap "Working age population"
	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Labour Force Status ('ilo_lfs')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	
	gen ilo_lfs=.
		replace ilo_lfs=1 if ((Q36T!=0|(Q38==1 & Q39==1 & Q40==1))& ilo_wap==1) // Employed
		replace ilo_lfs=2 if (ilo_lfs!=1 & Q76==1 & (Q77==1 | Q78==1 | Q79==1 | Q80==1 | Q81==1| Q82==3) & ilo_wap==1 )  // Unemployed
		replace ilo_lfs=3 if ilo_lfs!=1 & ilo_lfs!=2 & ilo_wap==1  // Outside the labour force
				label define lTI_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside the Labour Force"
				label value ilo_lfs lTI_ilo_lfs
				label var ilo_lfs "Labour Force Status"		

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_mjh=.
		replace ilo_mjh=1 if Q56==2 & ilo_lfs==1 
		replace ilo_mjh=2 if Q56==1 & ilo_lfs==1 
			lab def lYG_ilo_mjh 1 "One job only" 2 " More than one job"
			lab val ilo_mjh lYG_ilo_mjh
			lab var ilo_mjh "Multiple job holders"
			
			
			

***********************************************************************************************
*			PART 3.1. ECONOMIC CHARACTERISTICS FOR MAIN JOB 
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Status in employment ('ilo_job1_ste') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

		gen ilo_job1_ste_icse93=.
			replace ilo_job1_ste_icse93=1 if Q44==1 & ilo_lfs==1			// Employees 
			replace ilo_job1_ste_icse93=2 if Q44==2 & ilo_lfs==1			// Employers
			replace ilo_job1_ste_icse93=3 if Q44==3 & ilo_lfs==1			// Own-account workers
		    replace ilo_job1_ste_icse93=5 if Q44==4 & ilo_lfs==1			// Contributing family workers
		 	replace ilo_job1_ste_icse93=6 if (Q44==5 |Q44==.) & ilo_lfs==1	// Not classifiable
				
			label def l_ilo_ste_icse93 1 "Employees" 2 "Employers" 3 "Own-account workers" 5 "Contributing family workers" 6 "Workers not classifiable by status"
				label val ilo_job1_ste_icse93 l_ilo_ste_icse93
				label var ilo_job1_ste_icse93 "Status in employment (ICSE 93)"
			
	
	* Aggregate categories 
	
		gen ilo_job1_ste_aggregate=.
			replace ilo_job1_ste_aggregate=1 if ilo_job1_ste_icse93==1 & ilo_lfs==1				// Employees
			replace ilo_job1_ste_aggregate=2 if (ilo_job1_ste_icse93==2 | ilo_job1_ste_icse93==3 | ilo_job1_ste_icse93==5) & ilo_lfs==1  // Self-employed
			replace ilo_job1_ste_aggregate=3 if ilo_job1_ste_icse93==6	& ilo_lfs==1			// Not elsewhere classified
				lab def ste_aggr_la 1 "Employees" 2 "Self-employed" 3 "Not elsewhere classified"
				lab val ilo_job1_ste_aggregate ste_aggr_la
				label var ilo_job1_ste_aggregate "Status in employment (Aggregate)"  

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* National classification is based on ISIC 3.1

	*Main Job

		gen ilo_job1_eco_isic3=.
			replace ilo_job1_eco_isic3=1 if inrange(Q43,01,02) & ilo_lfs==1 
			replace ilo_job1_eco_isic3=2 if Q43==05 & ilo_lfs==1 
			replace ilo_job1_eco_isic3=4 if inrange(Q43,10,14) & ilo_lfs==1
			replace ilo_job1_eco_isic3=5 if inrange(Q43,15,37) & ilo_lfs==1
			replace ilo_job1_eco_isic3=6 if inrange(Q43,40,41) & ilo_lfs==1
			replace ilo_job1_eco_isic3=7 if Q43==45 & ilo_lfs==1 
			replace ilo_job1_eco_isic3=8 if inrange(Q43,50,52) & ilo_lfs==1
			replace ilo_job1_eco_isic3=9 if Q43==55 & ilo_lfs==1
			replace ilo_job1_eco_isic3=10 if inrange(Q43,60,64) & ilo_lfs==1
			replace ilo_job1_eco_isic3=11 if inrange(Q43,65,67) & ilo_lfs==1
			replace ilo_job1_eco_isic3=12 if inrange(Q43,70,74) & ilo_lfs==1
			replace ilo_job1_eco_isic3=13 if Q43==75 & ilo_lfs==1
			replace ilo_job1_eco_isic3=13 if Q43==80 & ilo_lfs==1
			replace ilo_job1_eco_isic3=14 if Q43==85 & ilo_lfs==1
			replace ilo_job1_eco_isic3=15 if inrange(Q43,90,93) & ilo_lfs==1
			replace ilo_job1_eco_isic3=16 if Q43==95 & ilo_lfs==1
			replace ilo_job1_eco_isic3=17 if Q43==99 & ilo_lfs==1
			replace ilo_job1_eco_isic3=18 if Q43==. & ilo_lfs==1

				label def Bcd_ilo_job1_eco_isic3  1 "Agriculture, hunting and forestry" 2 "Fishing" 3 "Mining and quarrying"  4 "Manufacturing" 5 "Electricity, gas and water supply" /// 
                                5 "Electricity, gas and water supply" ///
								6 "Construction" ///
                                7 "Wholesale and retail trade; repair of motor vehicles, motorcycles and personal and household goods" ///
                                8 "Hotels and restaurants" ///
                                9 "Transport, storage and communications" ///
                                10 "Financial intermediation" ///
                                11 "Real estate, renting and business activities" ///
                                12 "Public administration and defence; compulsory social security" ///
                                13 "Education" ///
                                14 "Health and social work" ///
                                15 "Other community, social and personal service activities" ///
                                16 "Activities of private households as employers and undifferentiated production activities of private households" /// 
                                17 "Extra-territorial organizations and bodies" ///
								18 "Not classified" 
				lab val ilo_job1_eco_isic3 Bcd_ilo_job1_eco_isic3
				label var ilo_job1_eco_isic3 "Economic activity (ISIC Rev. 3.1)"  

* Aggregated level  
		gen ilo_job1_eco_aggregate=.
			replace ilo_job1_eco_aggregate=1 if (ilo_job1_eco_isic3==1|ilo_job1_eco_isic3==2)
			replace ilo_job1_eco_aggregate=2 if ilo_job1_eco_isic3==4
			replace ilo_job1_eco_aggregate=3 if ilo_job1_eco_isic3==6
			replace ilo_job1_eco_aggregate=4 if (ilo_job1_eco_isic3==3|ilo_job1_eco_isic3==5)
			replace ilo_job1_eco_aggregate=5 if inrange(ilo_job1_eco_isic3,7,11)
			replace ilo_job1_eco_aggregate=6 if inrange(ilo_job1_eco_isic3,12,16)
			replace ilo_job1_eco_aggregate=7 if (ilo_job1_eco_isic3==17 |ilo_job1_eco_isic3==18)
					lab def eco_aggr_laf 1 "Agriculture" 2 "Manufacturing" 3 "Construction" 4 "Mining and quarrying; Electricity, gas and water supply" ///
									5 "Market Services (Trade; Transportation; Accommodation and food; and Business and administrative services)"  ///
									6 "Non-market services (Public administration; Community, social and other services and activities)" 7 "Not classifiable by economic activity"					
					lab val ilo_job1_eco_aggregate eco_aggr_laf
					lab var ilo_job1_eco_aggregate "Economic activity (Aggregate) - main job" 

					
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_job1_ocu_isco88') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

* National classification is based on ISCO88

		* ISCO 88 - 1 digit
		
			gen ilo_job1_ocu_isco88=.
				replace ilo_job1_ocu_isco88=1 if  inrange(Q41,111,131) & ilo_lfs==1 
				replace ilo_job1_ocu_isco88=2 if  inrange(Q41,211,246)& ilo_lfs==1 
				replace ilo_job1_ocu_isco88=3 if  inrange(Q41,311,348)& ilo_lfs==1 
				replace ilo_job1_ocu_isco88=4 if  inrange(Q41,411,422)& ilo_lfs==1 
				replace ilo_job1_ocu_isco88=5 if  inrange(Q41,511,523)& ilo_lfs==1 
				replace ilo_job1_ocu_isco88=6 if  inrange(Q41,611,621)& ilo_lfs==1 
				replace ilo_job1_ocu_isco88=7 if  inrange(Q41,711,744)& ilo_lfs==1 
				replace ilo_job1_ocu_isco88=8 if  inrange(Q41,811,833)& ilo_lfs==1 
				replace ilo_job1_ocu_isco88=9 if  inrange(Q41,911,999)& ilo_lfs==1 
				replace ilo_job1_ocu_isco88=10 if Q41==011 & ilo_lfs==1 
				replace ilo_job1_ocu_isco88=11 if Q41==.  & ilo_lfs==1 
				
					lab def ilo_job1_ocu_isco88_lab 1 "1 - Legislators, senior officials and managers" 2 "2 - Professionals" 3 "3 - Technicians and associate professionals" 4 "4 - Clerks" ///
											5 "5 - Service workers and shop and market sales workers" 6 "6 - Skilled agricultural and fishery workers" 7 "7 - Craft and related trades workers" ///
											8 "8 - Plant and machine operators, and assemblers" 9 "9 - Elementary occupations" 10 "0 - Armed forces" 11 "X - Not elsewhere classified"
					lab val ilo_job1_ocu_isco88 ilo_job1_ocu_isco88_lab
					lab var ilo_job1_ocu_isco88 "Occupation (ISCO-88) - Main job"	

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
					lab var ilo_job1_ocu_aggregate "Occupation (Aggregate) - Main job"	


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_job1_ins_sector') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

	* Not possible because you have many missing values

	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Hours of work ('ilo_job1_how_actual') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
		
	* Only hours actually worked available

		* Main job:
			gen ilo_job1_how_actual=.
			replace ilo_job1_how_actual= Q63 if ilo_lfs==1
			lab var ilo_job1_how_actual "Weekly hours actually worked in main job"

			gen ilo_job1_how_actual_bands=.
				replace ilo_job1_how_actual_bands=1 if (Q63==0 | Q63==.) & ilo_lfs==1
				replace ilo_job1_how_actual_bands=2 if inrange(Q63,1,14) & ilo_lfs==1
				replace ilo_job1_how_actual_bands=3 if inrange(Q63,15,29)& ilo_lfs==1
				replace ilo_job1_how_actual_bands=4 if inrange(Q63,30,34) & ilo_lfs==1
				replace ilo_job1_how_actual_bands=5 if inrange(Q63,35,39)& ilo_lfs==1
				replace ilo_job1_how_actual_bands=6 if inrange(Q63,40,48) & ilo_lfs==1
				replace ilo_job1_how_actual_bands=7 if Q63>=49 & Q63!=. & ilo_lfs==1
				replace ilo_job1_how_actual_bands=8 if ilo_lfs==1 & ilo_job1_how_actual_bands==.
				
					lab def how_bands_l 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"
					lab val ilo_job1_how_actual_bands how_bands_l
					lab var ilo_job1_how_actual_bands "Weekly hours actually worked bands in main job"
		

		* All jobs:

			gen ilo_joball_how_actual= .
			replace ilo_joball_how_actual= Q65 if (ilo_mjh==1 | ilo_mjh==2)
	
					lab var ilo_joball_how_actual "Weekly hours actually worked in all jobs"

			gen ilo_joball_how_actual_bands=.
				replace ilo_joball_how_actual_bands=1 if (Q65==0 | Q63==.) & (ilo_mjh==1 | ilo_mjh==2)
				replace ilo_joball_how_actual_bands=2 if inrange(Q65,1,14 ) & (ilo_mjh==1 | ilo_mjh==2)
				replace ilo_joball_how_actual_bands=3 if inrange(Q65,15,29)  & (ilo_mjh==1 | ilo_mjh==2)
				replace ilo_joball_how_actual_bands=4 if inrange(Q65,30,34)  & (ilo_mjh==1 | ilo_mjh==2)
				replace ilo_joball_how_actual_bands=5 if inrange(Q65,35,39)  & (ilo_mjh==1 | ilo_mjh==2)
				replace ilo_joball_how_actual_bands=6 if inrange(Q65,40,48)  & (ilo_mjh==1 | ilo_mjh==2)
				replace ilo_joball_how_actual_bands=7 if Q65>=49 & Q65!=.  & (ilo_mjh==1 | ilo_mjh==2)
				replace ilo_joball_how_actual_bands=8 if ilo_lfs==1 & ilo_joball_how_actual_bands==.
				lab def how_bands_Tbx 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"
				lab val ilo_joball_how_actual_bands how_bands_Tbx
				lab var ilo_joball_how_actual_bands "Weekly hours actually worked bands in all jobs"
				
						

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			ilo_joball_how_usual (Weekly hours usually worked in all job) [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
		
		gen ilo_joball_how_usual=.
			replace ilo_joball_how_usual=Q62 if (ilo_mjh==1 | ilo_mjh==2)
				lab var ilo_joball_how_usual "Weekly hours usually worked in all job"
			
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job1_job_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
	
		* Main job:

			gen ilo_job1_job_time=.
				replace ilo_job1_job_time=1 if Q63<35 & Q63>0 & ilo_lfs==1
				replace ilo_job1_job_time=2 if Q63>=35 & Q63!=. & ilo_lfs==1
				replace ilo_job1_job_time=3 if (ilo_job1_how_actual==. | ilo_job1_how_actual==0) & ilo_lfs==1
					lab def job_time_lcs 1 "Part-time" 2 "Full-time" 3 "Unknown"
					lab val ilo_job1_job_time job_time_lcs
					lab var ilo_job1_job_time "Job (Working time arrangement) - Main job"	
			

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job1_job_contract')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			

	* Not possible because you have many missing values


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Informal / Formal Economy (Unit of production)
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	
	* Not possible as no information on bookkeeping, registration and institutional sector

	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Informal / Formal Economy (Nature of job)
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
	
	/* Questions used: 	* Q44 - Status in employment
						* Q49 - Institutional sector	
						* NA - Bookkeeping
						* NA - Registration
						* Q50 - Size of the company	
						* Q51 - Location of workplace
				
						* Q47-48 - Social Security Coverage: an employee is covered by social security if he/she says yes to Q47 (Employer contributes to social security) 
 	*/
	
	* 1) Unit of production
	
		gen social_security=.
			replace social_security=1 if (Q47==1 & ilo_lfs==1)
	
		gen ilo_job1_ife_prod=.
			replace ilo_job1_ife_prod=2 if inlist(Q49,1,2,3,4,5,6) | (Q44==1 & Q47==1) | (inlist(Q51,2,3,4) & inlist(Q50,3,4))
 	
			replace ilo_job1_ife_prod=1 if (ilo_lfs==1 & ilo_job1_ife_prod==.)

			replace ilo_job1_ife_prod=. if ilo_lfs!=1 
						
						lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 
						lab val ilo_job1_ife_prod ilo_ife_prod_lab
						lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"

	* 2) Nature of job
	
			gen ilo_job1_ife_nature=.
				replace ilo_job1_ife_nature=1 if (inlist(ilo_job1_ste_icse93,2,3,4) & ilo_job1_ife_prod!=2) | (ilo_job1_ste_icse93==1 & social_security!=1) | inlist(ilo_job1_ste_icse93,5,6)								
				
				replace ilo_job1_ife_nature=2 if (inlist(ilo_job1_ste_icse93,2,3,4) & ilo_job1_ife_prod==2) | (ilo_job1_ste_icse93==1 & social_security==1)												
				
				replace ilo_job1_ife_nature=. if ilo_lfs!=1
						
						lab def ife_nature_lab 1 "1 - Persons with informal main job" 2 "2 - Persons with formal main job"
						lab val ilo_job1_ife_nature ife_nature_lab
						lab var ilo_job1_ife_nature "Informal / Formal Economy (Nature of job) - Main job"

		drop social_security



* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Monthly labour related income ('ilo_job1_lri') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
	   
			* Main job
				
				* Employees			
					gen ilo_job1_lri_ees =.
						replace ilo_job1_lri_ees = Q55A + Q55B if ilo_job1_ste_aggregate==1
							lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"	

				
							
***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_joball_tru') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			

* Legal working hours in Nepal is 48hours
		
		gen ilo_joball_tru=.
			replace ilo_joball_tru=1 if (ilo_lfs==1 & Q69!=. & Q69!=0 & Q75!=. & ilo_joball_how_usual<48)
				lab def ilo_joball_tru_lab 1 "Time-related underemployed"
				lab val ilo_joball_tru ilo_joball_tru_lab
				lab var ilo_joball_tru "Time-related underemployed"
		

* -------------------------------------------------------------------------------------------
*			Occupational injury ('ilo_joball_inj')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
		
		* No question related to this topic in the questionnaire.
		

***********************************************************************************************
*			PART 3.3. UNEMPLOYMENT: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Category of unemployment ('ilo_cat_une')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

		gen ilo_cat_une=.
			replace ilo_cat_une=1 if ilo_lfs==2 & Q103==1 	// Previously employed
			replace ilo_cat_une=2 if ilo_lfs==2 & Q103==2	// Seeking first job
			replace ilo_cat_une=3 if ilo_lfs==2 & Q103==.	// Unknown
				lab def cat_une_FP 1 "1 - Unemployed previously employed" 2 "Unemployed seeking their first job" 3 "Unknown"
				lab val ilo_cat_une cat_une_FP
				lab var ilo_cat_une "Category of unemployment"
				
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	
			gen ilo_dur_details=.
				replace ilo_dur_details=1 if (Q83==1 & ilo_lfs==2)
				replace ilo_dur_details=2 if (Q83==2 & ilo_lfs==2)
				replace ilo_dur_details=3 if (Q83==3 & ilo_lfs==2)
				replace ilo_dur_details=4 if (Q83==4 & ilo_lfs==2)
				replace ilo_dur_details=5 if (Q83==5 & ilo_lfs==2)
				replace ilo_dur_details=6 if (Q83==6  & ilo_lfs==2)
				replace ilo_dur_details=7 if (Q83==. & ilo_lfs==2)
					lab def ilo_dur_details_fmt 1 "Less than 1 month" 2 "1 month to less than 3 months" 3 "3 months to less than 6 months" 4 "6 months to less than 12 months" 5 "12 months to less than 24 months" ///
										  6 "24 months or more" 7 "Not elsewhere classified"
					lab values ilo_dur_details ilo_dur_details_fmt
					lab var ilo_dur_details "Duration of unemployment (Details)"

				
			gen ilo_dur_aggregate=.
				replace ilo_dur_aggregate=1 if inrange(ilo_dur_details,1,3)
				replace ilo_dur_aggregate=2 if ilo_dur_details==4
				replace ilo_dur_aggregate=3 if inrange(ilo_dur_details,5,6)
				replace ilo_dur_aggregate=4 if ilo_dur_details==7
					lab def ilo_unemp_aggrf 1 "Less than 6 months" 2 "6 months to less than 12 months" 3 "12 months or more" 4 "Not elsewhere classified"
					lab val ilo_dur_aggregate ilo_unemp_aggrf
					lab var ilo_dur_aggregate "Duration of unemployment (Aggregate)"

	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
	* No information
	
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
	* No information on the previous occupation in the dataset
	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			General social protection ('ilo_gsp_unschemes')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
	* No information on this topic in the dataset



***********************************************************************************************
*			PART 3.3. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

	* No information

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reason for not seeking job ('ilo_olf_reason')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
	
	* No information to compute this variable


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Main activity status ('ilo_olf_activity')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

	* No information to compute this variable

			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seeker ('ilo_dis')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
		
	* No information to compute this variable


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training ('ilo_neet')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

	gen ilo_neet=1 if (ilo_age_aggregate==2 & ilo_lfs!=1 & ilo_edu_attendance==2)
			lab def neet_lab 1 "Youth not in education, employment or training"
			lab val ilo_neet neet_lab
			lab var ilo_neet "Youth not in education, employment or training"
			

		
***********************************************************************************************
***********************************************************************************************

*			3. SAVE ILO-VARIABLES IN A NEW DATASET

***********************************************************************************************
***********************************************************************************************

* -------------------------------------------------------------
* 	Prepare final datasets
* -------------------------------------------------------------

* 1 - Full dataset with original variables and ILO ones
	
	cd "$outpath"

        compress
		saveold NPL_LFS_2008_FULL, version(12) replace
			

* 2 - Dataset with only 'ILO' variables

		keep ilo*
		saveold NPL_LFS_2008_ILO, version(12) replace
