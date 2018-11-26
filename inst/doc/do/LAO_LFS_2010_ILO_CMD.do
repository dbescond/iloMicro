* TITLE OF DO FILE: ILO Microdata Preprocessing code template - LAO, 2010
* DATASET USED: LAO LFS 2010
* NOTES: 
* Authors: ILO / Department of Statistics / DPAU

* Starting Date: 03 November 2016
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
global country "LAO" /*ref_area: ISO 3 Code from the workflow*/
global source "LFS"  /*survey: Acronym from the workflow*/
global time "2010"  /*time*/
global inputFile "LAO_LFS_2010.dta" /*name of the input file in stata format*/
global inpath "${path}\\${country}\\${source}\\${time}\ORI"
global temppath "${path}\_Admin"
global outpath "${path}\\${country}\\${source}\\${time}"

********************************************************************************
********************************************************************************

cd "$inpath"
	use ${inputFile}, clear
	*renaming everything in lower case
	rename *, lower  
	


************************************************************************************************
***********************************************************************************************			
	*                      2. MAP VARIABLES
***********************************************************************************************
***********************************************************************************************

		
* ---------------------------------------------------------------------------------------------
***********************************************************************************************
*			PART 1. DATASET SETTINGS VARIABLES
***********************************************************************************************
* ---------------------------------------------------------------------------------------------


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Key identifier ('ilo_key') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_key=_n
		lab var ilo_key "Key unique identifier per individual"		


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sample Weight ('ilo_wgt') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	

	gen ilo_wgt=wt_per
		lab var ilo_wgt "Sample weight"	
		
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time period ('ilo_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	* Year 2010
	
	gen ilo_time=1
		lab def lab_time 1 "2010" 
		lab val ilo_time lab_time
		lab var ilo_time "Time (Gregorian Calendar)"
		

* ---------------------------------------------------------------------------------------------
***********************************************************************************************
*			PART 2. SOCIAL CHARACTERISTICS
***********************************************************************************************
* ---------------------------------------------------------------------------------------------
	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Geographical coverage ('ilo_geo') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_geo=.
		replace ilo_geo=1 if villaget=="1"
		replace ilo_geo=2 if (villaget=="2"| villaget=="3")
			lab def ilo_geo_lab 1 "Urban" 2 "Rural"
			lab val ilo_geo ilo_geo_lab
			lab var ilo_geo "Geographical coverage"	


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_sex=hl4
		lab def ilo_sex_lavf 1 "Male" 2 "Female"
		lab val ilo_sex ilo_sex_lavf
		lab var ilo_sex "Sex"


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_age=hl5
		lab var ilo_age "Age"


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


* -----------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education ('ilo_edu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_edu_isced11=.
		replace ilo_edu_isced11=1 if ed2==2  				// No schooling
		replace ilo_edu_isced11=2 if ed8==0  				// Early childhood education
		replace ilo_edu_isced11=3 if ed8==1 				// Primary education
		replace ilo_edu_isced11=4 if ed8==2   				// Lower secondary education
		replace ilo_edu_isced11=5 if ed8==3   				// Upper secondary education
		replace ilo_edu_isced11=5 if ed8==5					// Post-secondary non-tertiary
		replace ilo_edu_isced11=7 if ed8==6  				// Short-cycle tertiary education
		replace ilo_edu_isced11=9 if ed8==7 				// Master's or equivalent level
		replace ilo_edu_isced11=10 if ed8==8 				// Doctoral or equivalent level
		replace ilo_edu_isced11=11 if (ed8==4 | ed8==9)		// Not elsewhere classified
		replace ilo_edu_isced11=11 if ilo_edu_isced11==. 	// Not elsewhere classified
		
			label def isced_11_labys 1 "X - No schooling" 2 "0 - Early childhood education" 3 "1 - Primary education" 4 "2 - Lower secondary education" ///
							5 "3 - Upper secondary education" 6 "4 - Post-secondary non-tertiary education"  7 "5 - Short-cycle tertiary education" ///
							8 "6 - Bachelor's or equivalent level" 9 "7 - Master's or equivalent level" 10 "8 - Doctoral or equivalent level" 11 "9 - Not elsewhere classified"
			label val ilo_edu_isced11 isced_11_labys
			lab var ilo_edu_isced11 "Education (ISCED 11)"	


	gen ilo_edu_aggregate=.
		replace ilo_edu_aggregate=1 if inlist(ilo_edu_isced11,1,2)  	// Less than basic
		replace ilo_edu_aggregate=2 if inlist(ilo_edu_isced11,3,4)		// Basic
		replace ilo_edu_aggregate=3 if inlist(ilo_edu_isced11,5,6)		// Intermediate
		replace ilo_edu_aggregate=4 if inrange(ilo_edu_isced11,7,10)	// Advanced
		replace ilo_edu_aggregate=5 if ilo_edu_isced11==11              // Level not stated
			label def edu_aggr_ld 1 "1 - Less than basic" 2 "2 - Basic" 3 "3 - Intermediate" 4 "4 - Advanced" 5 "5 - Level not stated"
			label val ilo_edu_aggregate edu_aggr_ld
			label var ilo_edu_aggregate "Education (Aggregate levels)"
		

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education attendance ('ilo_edu_attendance') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_edu_attendance=.
		replace ilo_edu_attendance=1 if (ed4==1|ed10==1) 		// Attending
		replace ilo_edu_attendance=2 if (ilo_edu_attendance!=1)	// Not attending
			label def edu_att_labell 1 " Attending" 2 " Not attending"
			label val ilo_edu_attendance edu_att_labell
			label var ilo_edu_attendance "Education (Attendance)"


* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			           Marital status ('ilo_mrts') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: - the marital status question is made to people aged 12 years or above.
	
	* Detailed
	gen ilo_mrts_details=.
	    replace ilo_mrts_details=1 if hl7==2                                    // Single
		replace ilo_mrts_details=2 if hl7==1                                    // Married
		replace ilo_mrts_details=3 if hl7==4                                    // Union / cohabiting
		replace ilo_mrts_details=4 if hl7==6                                    // Widowed
		replace ilo_mrts_details=5 if inlist(hl7,3,5)                           // Divorced / separated
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
*			Disability status ('ilo_dsb') [done] 
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
*			Working age population ('ilo_wap') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
          
* Comment: WAP=15+ 

	gen ilo_wap=.
		replace ilo_wap=1 if (ilo_age>=15 & ilo_age!=.)
		replace ilo_wap=0 if ilo_age<15
			label var ilo_wap "Working age population"
	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Labour Force Status ('ilo_lfs') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: Very strange questionnaire - A note has to be added that Employment/Unemployment include persons classifying themselves based on their status (AC3) which is not a normal practise.  

	gen ilo_lfs=.
		replace ilo_lfs=1 if (ac1==1 | ac2==1) & inrange(ac3,1,7) & ilo_wap==1 			// Employed
		replace ilo_lfs=2 if (ilo_lfs!=1 & ((ue1==1 & ue4==1) | ac3==8) & ilo_wap==1)	// Unemployed
		replace ilo_lfs=3 if (ilo_lfs!=1 & ilo_lfs!=2 & ilo_wap==1)						// Outside the labour force
				label define lBp_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside the Labour Force"
				label value ilo_lfs lBp_ilo_lfs
				label var ilo_lfs "Labour Force Status"		
				
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_mjh=.
		replace ilo_mjh=1 if ((ac10==2 | ac10==.) & ilo_lfs==1 & ilo_wap==1)
		replace ilo_mjh=2 if (ac10==1 & ilo_lfs==1 & ilo_wap==1)
			lab def lC_ilo_mjh 1 "One job only" 2 " More than one job"
			lab val ilo_mjh lC_ilo_mjh
			lab var ilo_mjh "Multiple job holders"


***********************************************************************************************
*			PART 3.1. ECONOMIC CHARACTERISTICS FOR MAIN JOB 
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Status in employment ('ilo_job1_ste') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

		gen ilo_job1_ste_icse93=.
			replace ilo_job1_ste_icse93=1 if (ac3==1 | ac3==2 | ac3==3 | ac3==4) & ilo_lfs==1	// Employees 
			replace ilo_job1_ste_icse93=2 if (ac3==5 & ilo_lfs==1)								// Employers
			replace ilo_job1_ste_icse93=3 if (ac3==6 & ilo_lfs==1)								// Own-account workers
		    replace ilo_job1_ste_icse93=5 if (ac3==7 & ilo_lfs==1)								// Contributing family workers
		 	replace ilo_job1_ste_icse93=6 if (ac3==. & ilo_lfs==1)								// Not classifiable
				replace ilo_job1_ste_icse93=6 if ilo_job1_ste_icse==. & ilo_lfs==1
				replace ilo_job1_ste_icse93=. if ilo_lfs!=1
				
				label def lBc_ilo_ste_icse93 1 "Employees" 2 "Employers" 3 "Own-account workers" 5 "Contributing family workers" 6 "Workers not classifiable by status"
				label val ilo_job1_ste_icse93 lBc_ilo_ste_icse93
				label var ilo_job1_ste_icse93 "Status in employment (ICSE 93)"
 
	* Aggregate categories 

		gen ilo_job1_ste_aggregate=.
			replace ilo_job1_ste_aggregate=1 if (ilo_job1_ste_icse93==1 & ilo_lfs==1)				// Employees
			replace ilo_job1_ste_aggregate=2 if (inlist(ilo_job1_ste_icse93,2,3,4,5) & ilo_lfs==1)  // Self-employed
			replace ilo_job1_ste_aggregate=3 if (ilo_job1_ste_icse93==6 & ilo_lfs==1)				// Not elsewhere classified
				lab def ste_aggr_lL 1 "Employees" 2 "Self-employed" 3 "Not elsewhere classified"
				lab val ilo_job1_ste_aggregate ste_aggr_lL
				label var ilo_job1_ste_aggregate "Status in employment (Aggregate)"  


* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: National classification corresponds to ISIC Rev4

		gen ilo_job1_eco_isic4=.
			replace ilo_job1_eco_isic4=1 if inrange(ac5_isic,0111,0322) & ilo_lfs==1
			replace ilo_job1_eco_isic4=2 if inrange(ac5_isic,0510,0990) & ilo_lfs==1              
			replace ilo_job1_eco_isic4=3 if inrange(ac5_isic,1010,3320) & ilo_lfs==1
			replace ilo_job1_eco_isic4=4 if inrange(ac5_isic,3510,3530) & ilo_lfs==1
			replace ilo_job1_eco_isic4=5 if inrange(ac5_isic,3600,3900) & ilo_lfs==1		                        
			replace ilo_job1_eco_isic4=6 if inrange(ac5_isic,4100,4390) & ilo_lfs==1		
			replace ilo_job1_eco_isic4=7 if inrange(ac5_isic,4510,4799) & ilo_lfs==1
			replace ilo_job1_eco_isic4=8 if inrange(ac5_isic,4911,5320) & ilo_lfs==1
			replace ilo_job1_eco_isic4=9 if inrange(ac5_isic,5510,5630) & ilo_lfs==1
			replace ilo_job1_eco_isic4=10 if inrange(ac5_isic,5811,6399) & ilo_lfs==1	
			replace ilo_job1_eco_isic4=11 if inrange(ac5_isic,6411,6630) & ilo_lfs==1	
			replace ilo_job1_eco_isic4=12 if inrange(ac5_isic,6810,6820) & ilo_lfs==1	
			replace ilo_job1_eco_isic4=13 if inrange(ac5_isic,6910,7500) & ilo_lfs==1
			replace ilo_job1_eco_isic4=14 if inrange(ac5_isic,7710,8299) & ilo_lfs==1
			replace ilo_job1_eco_isic4=15 if inrange(ac5_isic,8411,8430) & ilo_lfs==1
			replace ilo_job1_eco_isic4=16 if inrange(ac5_isic,8510,8550) & ilo_lfs==1
			replace ilo_job1_eco_isic4=17 if inrange(ac5_isic,8610,8690) & ilo_lfs==1
			replace ilo_job1_eco_isic4=18 if inrange(ac5_isic,9000,9329) & ilo_lfs==1
			replace ilo_job1_eco_isic4=19 if inrange(ac5_isic,9411,9609) & ilo_lfs==1
			replace ilo_job1_eco_isic4=20 if inrange(ac5_isic,9700,9820) & ilo_lfs==1
			replace ilo_job1_eco_isic4=21 if (ac5_isic==9900 & ilo_lfs==1)
			replace ilo_job1_eco_isic4=22 if (ac5_isic==. & ilo_lfs==1) | (ilo_job1_eco_isic4==. & ilo_lfs==1)
				lab def ilo_job1_eco_isic4_SSSSsv 1 "Agriculture, forestry and fishing" 2 "Mining and quarrying" 3 "Manufacturing" 4 "Electricity, gas, steam and air conditioning supply" ///
                             5  "Water supply; sewerage, waste management and remediation activities" ///
                             6  "Construction" ///
                             7  "Wholesale and retail trade; repair of motor vehicles and motorcycles" ///
                             8  "Transportation and storage" ///
                             9  "Accommodation and food service activities" ///
                             10 "Information and communication" ///
                             11 "Financial and insurance activities" ///
                             12 "Real estate activities" ///
                             13 "Professional, scientific and technical activities" ///
                             14 "Administrative and support service activities" ///
                             15 "Public administration and defence; compulsory social security" ///
                             16 "Education" ///
                             17 "Human health and social work activities" ///
                             18 "Arts, entertainment and recreation" ///
							 19 "Other service activities" ///
                             20 "Activities of households as employers; undifferentiated goods- and services-producing activities of households for own use" ///
                             21 "Activities of extraterritorial organizations and bodies" /// 
							 22 "Not elsewhere classified" 
				lab val ilo_job1_eco_isic4 ilo_job1_eco_isic4_SSSSsv
				lab var ilo_job1_eco_isic4 "Economic activity (ISIC Rev. 4) - Main job"	

					* Aggregated level 
					
						gen ilo_job1_eco_aggregate=.
							replace ilo_job1_eco_aggregate=1 if ilo_job1_eco_isic4==1
							replace ilo_job1_eco_aggregate=2 if ilo_job1_eco_isic4==3
							replace ilo_job1_eco_aggregate=3 if ilo_job1_eco_isic4==6
							replace ilo_job1_eco_aggregate=4 if inlist(ilo_job1_eco_isic4,2,4,5)
							replace ilo_job1_eco_aggregate=5 if inrange(ilo_job1_eco_isic4,7,14)
							replace ilo_job1_eco_aggregate=6 if inrange(ilo_job1_eco_isic4,15,21)
							replace ilo_job1_eco_aggregate=7 if ilo_job1_eco_isic4==22
								lab def eco_aggr_labelcx 1 "1 - Agriculture" 2 "2 - Manufacturing" 3 "3 - Construction" 4 "4 - Mining and quarrying; Electricity, gas and water supply" ///
									5 "5 - Market Services (Trade; Transportation; Accommodation and food; and Business and administrative services)"  ///
									6 "6 - Non-market services (Public administration; Community, social and other services and activities)" 7 "7 - Not classifiable by economic activity"					
								lab val ilo_job1_eco_aggregate eco_aggr_labelcx
								lab var ilo_job1_eco_aggregate "Economic activity (Aggregate) - main job"   
							
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_job1_ocu_isco08') [done]
* -------------------------------------------------------------------------------------------
* ------------------------------------------------------------------------------------------

* Comment: National classification corresponds to ISCO08
	
		gen ilo_job1_ocu_isco08=.
			replace ilo_job1_ocu_isco08=1 if inrange(ac4_isco,1111,1439) & ilo_lfs==1 
			replace ilo_job1_ocu_isco08=2 if inrange(ac4_isco,2111,2659) & ilo_lfs==1 
			replace ilo_job1_ocu_isco08=3 if inrange(ac4_isco,3111,3522) & ilo_lfs==1 
			replace ilo_job1_ocu_isco08=4 if inrange(ac4_isco,4110,4419) & ilo_lfs==1 
			replace ilo_job1_ocu_isco08=5 if inrange(ac4_isco,5111,5419) & ilo_lfs==1
			replace ilo_job1_ocu_isco08=6 if inrange(ac4_isco,6111,6340) & ilo_lfs==1
			replace ilo_job1_ocu_isco08=7 if inrange(ac4_isco,7111,7549) & ilo_lfs==1
			replace ilo_job1_ocu_isco08=8 if inrange(ac4_isco,8111,8350) & ilo_lfs==1
			replace ilo_job1_ocu_isco08=9 if inrange(ac4_isco,9111,9629) & ilo_lfs==1
			replace ilo_job1_ocu_isco08=10 if inrange(ac4_isco,0110,0310) & ilo_lfs==1
			replace ilo_job1_ocu_isco08=11 if ilo_job1_ocu_isco08==. & ilo_lfs==1
				replace ilo_job1_ocu_isco08=. if ilo_lfs!=1
		
				lab def ilo_job1_ocu_isco08_labe 1 "1 - Managers" 2 "2 - Professionals" 3 "3 - Technicians and associate professionals" 4 "4 - Clerical support workers" ///
											5 "5 - Service and sales workers" 6 "6 - Skilled agricultural, forestry and fishery workers" 7 "7 - Craft and related trades workers" ///
											8 "8 - Plant and machine operators, and assemblers" 9 "9 - Elementary occupations" 10 "10 - Armed forces occupations" 11 "X - Not elsewhere classified"
				lab val ilo_job1_ocu_isco08 ilo_job1_ocu_isco08_labe
				lab var ilo_job1_ocu_isco08 "Occupation (ISCO-08) - Main job"	


		* Aggregate:	
		
			gen ilo_job1_ocu_aggregate=.
				replace ilo_job1_ocu_aggregate=1 if inrange(ilo_job1_ocu_isco08,1,3)
				replace ilo_job1_ocu_aggregate=2 if inlist(ilo_job1_ocu_isco08,4,5)
				replace ilo_job1_ocu_aggregate=3 if inlist(ilo_job1_ocu_isco08,6,7)
				replace ilo_job1_ocu_aggregate=4 if ilo_job1_ocu_isco08==8
				replace ilo_job1_ocu_aggregate=5 if ilo_job1_ocu_isco08==9
				replace ilo_job1_ocu_aggregate=6 if ilo_job1_ocu_isco08==10
				replace ilo_job1_ocu_aggregate=7 if ilo_job1_ocu_isco08==11
					lab def ocu_aggr_labc 1 "1 - Managers, professionals, and technicians" 2 "2 - Clerical, service and sales workers" 3 "3 - Skilled agricultural and trades workers" ///
										4 "4 - Plant and machine operators, and assemblers" 5 "5 - Elementary occupations" 6 "6 - Armed forces" 7 "7 - Not elsewhere classified"
					lab val ilo_job1_ocu_aggregate ocu_aggr_labc
					lab var ilo_job1_ocu_aggregate "Occupation (Aggregate) - Main job"
					
		* Skill level
			gen ilo_job1_ocu_skill=.
				replace ilo_job1_ocu_skill=1 if ilo_job1_ocu_isco08==9                  // Low
				replace ilo_job1_ocu_skill=2 if inlist(ilo_job1_ocu_isco08,4,5,6,7,8)   // Medium
				replace ilo_job1_ocu_skill=3 if inlist(ilo_job1_ocu_isco08,1,2,3)       // High
				replace ilo_job1_ocu_skill=4 if inlist(ilo_job1_ocu_isco08,10,11)       // Not elsewhere classified
					lab def ocu_skill_lab 1 "1 - Skill level 1 (low)" 2 "2 - Skill level 2 (medium)" 3 "3 - Skill levels 3 and 4 (high)" 4 "4 - Not elsewhere classified"
					lab val ilo_job1_ocu_skill ocu_skill_lab
					lab var ilo_job1_ocu_skill "Occupation (Skill level) - main job"
	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_job1_ins_sector') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

		gen ilo_job1_ins_sector=.
			replace ilo_job1_ins_sector=1 if (ac3==1 | ac3==2 | ac3==4) & ilo_lfs==1
			replace ilo_job1_ins_sector=2 if (ac3==3 | ac3==5 | ac3==6 | ac3==7) & ilo_lfs==1	 
				lab def ilo_job1_ins_sector_lTGLy 1 "Public" 2 "Private" 
				lab val ilo_job1_ins_sector ilo_job1_ins_sector_lTGLy
				label var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities"


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Hours of work ('ilo_job1_how_actual') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

		* Main job:

			gen ilo_job1_how_actual=.
			replace ilo_job1_how_actual=ac11_1 if ilo_lfs==1
				lab var ilo_job1_how_actual "Weekly hours actually worked in main job"

			gen ilo_job1_how_actual_bands=.
				replace ilo_job1_how_actual_bands=1 if (ilo_job1_how_actual==0 | ilo_job1_how_actual==.) & ilo_lfs==1
				replace ilo_job1_how_actual_bands=2 if inrange(ilo_job1_how_actual,1,14) & ilo_lfs==1
				replace ilo_job1_how_actual_bands=3 if inrange(ilo_job1_how_actual,15,29) & ilo_lfs==1
				replace ilo_job1_how_actual_bands=4 if inrange(ilo_job1_how_actual,30,34) & ilo_lfs==1
				replace ilo_job1_how_actual_bands=5 if inrange(ilo_job1_how_actual,35,39) & ilo_lfs==1
				replace ilo_job1_how_actual_bands=6 if inrange(ilo_job1_how_actual,40,48) & ilo_lfs==1
				replace ilo_job1_how_actual_bands=7 if ilo_job1_how_actual>=49 & ilo_job1_how_actual!=. & ilo_lfs==1
				
					lab def how_bands_l 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 
					lab val ilo_job1_how_actual_bands how_bands_l
					lab var ilo_job1_how_actual_bands "Weekly hours actually worked bands in main job"
		
		* All jobs:

			gen ilo_joball_how_actual= .
			replace ilo_joball_how_actual=(ac11_1 + ac11_2) if (ilo_lfs==1 | ilo_mjh==2)
				lab var ilo_joball_how_actual "Weekly hours actually worked in all jobs"


			gen ilo_joball_how_actual_bands=.
				replace ilo_joball_how_actual_bands=1 if (ilo_joball_how_actual==0 | ilo_joball_how_actual==.) & (ilo_mjh==2 | ilo_lfs==1)
				replace ilo_joball_how_actual_bands=2 if inrange(ilo_joball_how_actual,1,14 ) & (ilo_mjh==2|ilo_lfs==1)
				replace ilo_joball_how_actual_bands=3 if inrange(ilo_joball_how_actual,15,29) & (ilo_mjh==2|ilo_lfs==1)
				replace ilo_joball_how_actual_bands=4 if inrange(ilo_joball_how_actual,30,34) & (ilo_mjh==2|ilo_lfs==1)
				replace ilo_joball_how_actual_bands=5 if inrange(ilo_joball_how_actual,35,39) & (ilo_mjh==2|ilo_lfs==1)
				replace ilo_joball_how_actual_bands=6 if inrange(ilo_joball_how_actual,40,48) & (ilo_mjh==2|ilo_lfs==1)
				replace ilo_joball_how_actual_bands=7 if ilo_joball_how_actual>=49 & ilo_joball_how_actual!=.  & (ilo_mjh==2|ilo_lfs==1)
					lab def how_bands_Tv 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 
					lab val ilo_joball_how_actual_bands how_bands_Tv
					lab var ilo_joball_how_actual_bands "Weekly hours actually worked bands in all jobs"


* -------------------------------------------------------------------------------------------
*			ilo_joball_how_usual (Weekly hours usually worked in all job) [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

	* Comment: No information


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job1_job_time') [done]
* ------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			

	* Main job

			gen ilo_job1_job_time=.
				replace ilo_job1_job_time=1 if (ilo_job1_how_actual<35 & ilo_job1_how_actual>0 & ilo_lfs==1)
				replace ilo_job1_job_time=2 if (ilo_job1_how_actual>=35 & ilo_job1_how_actual!=. & ilo_lfs==1)
				replace ilo_job1_job_time=3 if (ilo_job1_how_actual==. | ilo_job1_how_actual==0) & ilo_lfs==1
					lab def job_time_lad 1 "Part-time" 2 " Full-time" 3 "Unknown"
					lab val ilo_job1_job_time job_time_lad
					lab var ilo_job1_job_time "Job (Working time arrangement) - Main job"	
			
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job1_job_contract') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			

	* Comment: Not enough information due to skip patterns
		* gen ilo_job1_job_contract=.
			* replace ilo_job1_job_contract=1 if (ss1==1 & ss2==4)
			* replace ilo_job1_job_contract=2 if (ss1==1 & inlist(ss2,1,2,3))
			* replace ilo_job1_job_contract=3 if (ss1==1 & ss2==.) 
				* lab def FMk_ilo_job1_job_contract 1 "Permanent" 2 "Temporary" 3" Unknown"	
				* lab val ilo_job1_job_contract FMk_ilo_job1_job_contract	
				* label var ilo_job1_job_contract "Job (Type of contract)"


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Formal / Informal Economy ('ilo_job1_ife_prod' 'ilo_job1_ife_nature') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
		
	/* Useful questions:
				* AC3 - Status / Institutional Sector
				* AC6 - Location of work place
				* No question on bookkeeping / registration
				* No question on the size
				* SS5_4 - Pension
				* AC9_5 - Paid sick leave
				* AC9_6 - Paid leave	*/

	* Too many questions are missing to generate unit of production (Formal / Informal Sector)


	* Too many questions are missing to generate nature of job (Formal / Informal Job)



* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Monthly labour related income ('ilo_job1_lri') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
	   
			* Main job
				
				* Employees
				
					gen ilo_job1_lri_ees=.
						replace ilo_job1_lri_ees=ac8 if ilo_job1_ste_aggregate==1		
							lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"	
				
				* Self-employed:
			 
					gen ilo_job1_lri_slf=.
						replace ilo_job1_lri_slf=ac8 if ilo_job1_ste_aggregate==2
							lab var ilo_job1_lri_slf "Monthly labour related income of self-employed in main job"	
		
	
***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_joball_tru') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
		
		gen ilo_joball_tru=.
			replace ilo_joball_tru=1 if (ilo_lfs==1 & ud1==1 & ud2==1 & ilo_joball_how_actual<48)
				lab var ilo_joball_tru "Time-related underemployed"


* -------------------------------------------------------------------------------------------
*			ilo_joball_oi_case ('Cases of non-fatal occupational injury') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			

		gen ilo_joball_oi_case=.
			replace ilo_joball_oi_case=1 if (hs2!=. & ilo_lfs==1)
				label var ilo_joball_oi_case "Cases of non-fatal occupational injury"

	
***********************************************************************************************
*			PART 3.3. UNEMPLOYMENT: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Category of unemployment ('ilo_cat_une') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

		* No information

	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
		
		* No information
		

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
	* No information to compute this variable
	
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
	* No information on the previous occupation in the dataset
	
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			General social protection ('ilo_gsp_unschemes') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
	* No information on this topic in the dataset
	
	

***********************************************************************************************
*			PART 3.3. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

	* No information to compute this variable

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reason for not seeking job ('ilo_olf_reason') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	
	* No information to compute this variable

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Main activity status ('ilo_olf_activity') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

	* No information to compute this variable
	
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seeker ('ilo_dis')  [done]
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

cd "$outpath"
	drop ilo_age
	
	/* Variables computed in-between */
	*drop
	compress
		
	/* Save dataset including original and ilo variables*/
	save ${country}_${source}_${time}_FULL,  replace		
	
	*Save file only containing ilo_* variables
	keep ilo*
	save ${country}_${source}_${time}_ILO, replace
		

