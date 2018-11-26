* TITLE OF DO FILE: ILO Microdata Preprocessing code template - ZAF, 2007Q3
* DATASET USED: ZAF, QLFS, 2007Q3
* Files created: Standard variables ZAF_QLFS_2007Q3_FULL.dta and ZAF_QLFS_2007Q3_ILO.dta
* Authors: ILO / Department of Statistics / DPAU
* Starting Date: 21 August 2018
* Last updated: 23 August 2018
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
global country "ZAF" /*ref_area: ISO 3 Code from the workflow*/
global source "QLFS"  /*survey: Acronym from the workflow*/
global time "2000Q1"  /*time*/
global inputFile "ZAF_QLFS_2000Q1.dta"
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
* Comment:

	gen ilo_key=_n
		lab var ilo_key "Key unique identifier per individual"
		
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
		
		
******************************************************************************** 

* create local for Year and quarter

********************************************************************************* 
		
decode ilo_time, gen(todrop)
split todrop, generate(todrop_) parse(Q)
destring todrop_1, replace force
local Y = todrop_1 in 1
 

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*		             	 Sample Weight ('ilo_wgt') 		                       *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 


	gen ilo_wgt=.
	    replace ilo_wgt=wgt 
		lab var ilo_wgt "Sample weight"
	

							
		
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
* Comment: no info
	/*
	gen ilo_geo=.
	    replace ilo_geo=1 if          // Urban 
		replace ilo_geo=2 if          // Rural
		        lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural"
		        lab val ilo_geo ilo_geo_lab
		        lab var ilo_geo "Geographical coverage"	
		*/
		
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			                     Sex ('ilo_sex') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 65 observations have been deleted to avoid missing values in this variable. 
	
	gen ilo_sex=.
	    replace ilo_sex=1 if d_gender==1            // Male
		replace ilo_sex=2 if d_gender==2            // Female
		        label define label_Sex 1 "1 - Male" 2 "2 - Female"
		        label values ilo_sex label_Sex
		        lab var ilo_sex "Sex"

keep if ilo_sex != .

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			                    Age ('ilo_age') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 
	
	gen ilo_age=.
	    replace ilo_age=e_age 
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
* Comment: ISCED 97 has been used. (UNESCO mapping for South Africa)

    *---------------------------------------------------------------------------
	* ISCED 97
	*---------------------------------------------------------------------------
 
	gen ilo_edu_isced97=.
		replace ilo_edu_isced97=1 if q13ahied==0                                    // No schooling
		replace ilo_edu_isced97=2 if q13ahied==1                                    // Pre-primary education
		replace ilo_edu_isced97=3 if inrange(q13ahied,2,8)                          // Primary education or first stage of basic education
		replace ilo_edu_isced97=4 if inlist(q13ahied,9,10)                          // Lower secondary education or second stage of basic education
		replace ilo_edu_isced97=5 if inrange(q13ahied,11,20)                        // Upper secondary education
		*replace ilo_edu_isced97=6 if inrange                                   // Post-secondary non-tertiary education
		replace ilo_edu_isced97=7 if inrange(q13ahied,21,23)                        // First stage of tertiary education (not leading directly to an advanced research qualification)
		replace ilo_edu_isced97=8 if q13ahied==24                                   // Second stage of tertiary education (leading to an advanced research qualification)                               
		replace ilo_edu_isced97=9 if ilo_edu_isced97==.                         // Level not stated 
 	
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
* Comment: 

 
 
    gen ilo_edu_attendance=.
		replace ilo_edu_attendance=1 if inrange(q18attnd,1,7)                   // Attending
		replace ilo_edu_attendance=2 if  q18attnd==8                            // Not attending
		replace ilo_edu_attendance=3 if ilo_edu_attendance==.                   // Not elsewhere classified
 		
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
	    replace ilo_mrts_details=1 if  q11amari==5                              // Single
		replace ilo_mrts_details=2 if  q11amari==1                              // Married
		replace ilo_mrts_details=3 if  q11amari==2                              // Union / cohabiting
		replace ilo_mrts_details=4 if  q11amari==3                              // Widowed
		replace ilo_mrts_details=5 if  q11amari==4                              // Divorced / separated
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
* Comment: no info

 

				
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
			    label define label_ilo_wap 1 "1 - Working-age Population"
				label value ilo_wap label_ilo_wap
				label var ilo_wap "Working-age population"

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			       Labour Force Status ('ilo_lfs')                             *       
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 

	
	gen ilo_lfs=.
        replace ilo_lfs=1 if (q21bpaid==1 | q21aownb==1 | q21dunp==1) & ilo_wap==1						                         // Employed: ILO definition
		replace ilo_lfs=1 if (q22havew==1) & ilo_wap==1						                                                    // Employed: temporary absent
		replace ilo_lfs=2 if ((q34alook==1|q34bbgnb==1) & q32accep==1 & inlist(q33wh,1,2)) & ilo_lfs!=1 & ilo_wap==1			// Unemployed: three criteria
		replace ilo_lfs=2 if (q31ynotw==1) & ilo_lfs!=1 & ilo_wap==1			                                               // Unemployed: available future starters
	    replace ilo_lfs=3 if !inlist(q31ynotw,1,2) & ilo_wap==1		                                                            // Outside the labour force
				label define label_ilo_lfs 1 "1 - Employed" 2 "2 - Unemployed" 3 "3 - Outside Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status" 
			
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			       Multiple job holders ('ilo_mjh')                            *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: no info

 

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
* Comment: to revise
* Comment: the number of employers and own-account workers has been computed taking into account the number of employees



   * MAIN JOB
   * ICSE 1993
	 gen ilo_job1_ste_icse93=.
		 replace ilo_job1_ste_icse93=1 if inlist(q43mainw,1,2) & ilo_lfs==1                                   // Employees
		 replace ilo_job1_ste_icse93=2 if inlist(q43mainw,3,4) & q44nremp==2  & ilo_lfs==1                    // Employers
		 replace ilo_job1_ste_icse93=3 if inlist(q43mainw,3,4) & q44nremp==1 & ilo_lfs==1                     // Own-account workers
		* replace ilo_job1_ste_icse93=4 if  & ilo_lfs==1          // Members of producers' cooperatives
		 replace ilo_job1_ste_icse93=5 if q43mainw==5 & ilo_lfs==1          // Contributing family workers
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
				
	* SECOND JOB
* Comment: no info	
	 

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			            Economic activity ('ilo_eco')                          *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: the mapping has been done between the variable q42indus and ISIC Rev.3.1 at 1-digit level
*          (q42indus codes on page 64 of the document: LFS16WORKER!092007.pdf [J:\DPAU\MICRO\ZAF\QLFS\2007Q3\ORI\Data])

    * MAIN JOB
	
    *---------------------------------------------------------------------------
	* ISIC REV 3.1
	*---------------------------------------------------------------------------

 
	* 1-digit level	
    gen ilo_job1_eco_isic3=.
		replace ilo_job1_eco_isic3=1 if (inrange(q42indus,111,142) | inrange(q42indus,160,190)) & ilo_lfs==1
		replace ilo_job1_eco_isic3=2 if inrange(q42indus,151,153) & ilo_lfs==1
		replace ilo_job1_eco_isic3=3 if inrange(q42indus,210,290) & ilo_lfs==1
		replace ilo_job1_eco_isic3=4 if inrange(q42indus,301,395) & ilo_lfs==1
		replace ilo_job1_eco_isic3=5 if inrange(q42indus,411,420) & ilo_lfs==1
		replace ilo_job1_eco_isic3=6 if inrange(q42indus,502,504) & ilo_lfs==1
		replace ilo_job1_eco_isic3=7 if inrange(q42indus,611,635) & ilo_lfs==1
		replace ilo_job1_eco_isic3=8 if inrange(q42indus,641,643)& ilo_lfs==1
		replace ilo_job1_eco_isic3=9 if inrange(q42indus,711,752) & ilo_lfs==1
		replace ilo_job1_eco_isic3=10 if inrange(q42indus,811,831)& ilo_lfs==1
		replace ilo_job1_eco_isic3=11 if (inrange(q42indus,841,883) | q42indus== 889) & ilo_lfs==1
		replace ilo_job1_eco_isic3=12 if inrange(q42indus,911,917)& ilo_lfs==1
		replace ilo_job1_eco_isic3=13 if q42indus==920 & ilo_lfs==1
		replace ilo_job1_eco_isic3=14 if inrange(q42indus,931,933)& ilo_lfs==1
		replace ilo_job1_eco_isic3=15 if inrange(q42indus,940,990)& ilo_lfs==1
		replace ilo_job1_eco_isic3=16 if q42indus==10 & ilo_lfs==1
		replace ilo_job1_eco_isic3=17 if inlist(q42indus,20,30) & ilo_lfs==1
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
	

    		   
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			               Occupation ('ilo_ocu') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment:

    * MAIN JOB

    *---------------------------------------------------------------------------
	* ISCO 88
	*---------------------------------------------------------------------------

	* 2-digit level 
    gen ilo_job1_ocu_isco88_2digits = . 
	    replace ilo_job1_ocu_isco88_2digits = int(q41occup/100) if ilo_lfs==1
		 replace ilo_job1_ocu_isco88_2digits = . if inlist(ilo_job1_ocu_isco88_2digits,8,88,99) & ilo_lfs==1
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
	    replace ilo_job1_ocu_isco88=11 if ilo_job1_ocu_isco88_2digits==. & ilo_lfs==1                          // Not elsewhere classified
		replace ilo_job1_ocu_isco88=int(ilo_job1_ocu_isco88_2digits/10) if (ilo_job1_ocu_isco88==. & ilo_lfs==1)     // The rest of the occupations
		replace ilo_job1_ocu_isco88=10 if (ilo_job1_ocu_isco88==0 & ilo_lfs==1)                                      // Armed forces
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
				
  
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*	Institutional sector of economic activities ('ilo_ins_sector')		       *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 

 	
	gen ilo_job1_ins_sector=.
		replace ilo_job1_ins_sector=1 if inrange(q414typ,1,4) & ilo_lfs==1    // Public
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


    * MAIN JOB
	
	* Hours USUALLY worked
	gen ilo_job1_how_usual = .
	    replace ilo_job1_how_usual = q421ausu  if ilo_lfs==1 & !inlist(q421ausu,888,999)
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
	    replace ilo_job1_how_actual = q420ahrs  if ilo_lfs==1 & !inlist(q420ahrs,888,999)
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
	* Comment: no info
		

    * ALL JOBS
	
	* Hours USUALLY worked
    gen ilo_joball_how_usual = .
	    replace ilo_joball_how_usual = q421cusu if ilo_lfs==1 & !inlist(q421cusu,888,999)
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
    
				
	* Hours ACTUALLY worked
	gen ilo_joball_how_actual = .
	    replace ilo_joball_how_actual = q420chrs  if ilo_lfs==1 & !inlist(q420chrs ,888,999)
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
* Comment: Threshold of 40 hours per week 
 			
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
* Comment:  no info
* Comment: regarding contract, there is only information about whether the employment contract is written or not
	
	

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*  Informal/formal economy: ('ilo_job1_ife_prod'/'ilo_job1_ife_nature') 	   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

*** !!! 
* Comment: there is a variable for type of business sector (formal/informal): q422sect [the results do not match]
* Comment: the result of household is very low. 

/* Useful questions:
          - Institutional sector:  q414typb  
		  - Private household identification:  
		  - Destination of production: [no info]
		  - Bookkeeping: [no info]
		  - Registration: q417regi (q420vatr q421inco)
		  - Status in employment: q43mwork q416nrwo
		  - Social security contribution (Proxy: pension funds): q411pens
		  - Place of work:  q423loca
		  - Size: q416nrwo
		  - Paid annual leave: q412leav
		  - Paid sick leave: [no info]
*/
 
 
 
 * Social Security:
	gen social_security=.
	    replace social_security=1 if q411pens==1  &  ilo_lfs==1          // social security (proxy)
		replace social_security=2 if q411pens==2  &  ilo_lfs==1          // no social security (proxy)
	
    * 1) UNIT OF PRODUCTION: FORMAL/INFORMAL SECTOR
	gen ilo_job1_ife_prod=.
	    replace ilo_job1_ife_prod=3 if ilo_lfs==1 & (ilo_job1_ocu_isco88_2digits==62 |  ilo_job1_eco_isic3==16) ///
		                               
		replace ilo_job1_ife_prod=2 if ilo_lfs==1 & ilo_job1_ife_prod!=3 &  ///
		                                (inrange(q414typ,1,5) |  ///
									   (!inrange(q414typ,1,5) & q417areg==1)  | ///
									   (!inrange(q414typ,1,5) & inlist(q417areg,8,9) & ilo_job1_ste_icse93==1 & social_security==1)) 
									   
									  
		replace ilo_job1_ife_prod=1 if ilo_lfs==1 & !inlist(ilo_job1_ife_prod,2,3)
				lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 
				lab val ilo_job1_ife_prod ilo_ife_prod_lab
				lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"		
		
	
	* 2) NATURE OF JOB: FORMAL/INFORMAL EMPLOYMENT
	gen ilo_job1_ife_nature=.
	    replace ilo_job1_ife_nature=2 if ilo_lfs==1 & ///
	                                     ((inlist(ilo_job1_ste_icse93,1,6) & q411pens==1) | ///
										 (inlist(q411pens,3,8,9) & q412leav==1))
										 
										
	    replace ilo_job1_ife_nature=1 if ilo_lfs==1 & ilo_job1_ife_nature!=2
                lab def ife_nature_lab 1 "1 - Persons with informal main job" 2 "2 - Persons with formal main job"
		        lab val ilo_job1_ife_nature ife_nature_lab
		        lab var ilo_job1_ife_nature "Informal / Formal Economy (Nature of job)"	
 	
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*	    Monthly labour related income ('ilo_lri_ees' and 'ilo_lri_slf')  	   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment:  

    * MAIN JOB
	
	* Employees
	gen ilo_job1_lri_ees=.
          replace ilo_job1_lri_ees = q415asal*4 if (q415bsal==1 & ilo_job1_ste_aggregate==1 & !inlist(q415asal,8888888,9999999)) // Week
  		  replace ilo_job1_lri_ees = q415asal if (q415bsal==2 & ilo_job1_ste_aggregate==1 & !inlist(q415asal,8888888,9999999))  // Month
		  replace ilo_job1_lri_ees = q415asal*(1/12) if (q415bsal==3 & ilo_job1_ste_aggregate==1 & !inlist(q415asal,8888888,9999999)) // One year
		  replace ilo_job1_lri_ees = .     if ilo_lfs!=1
		        lab var ilo_job1_lri_ees "Monthly earnings of employees - main job"
	
	* Self-employed
	gen ilo_job1_lri_slf = .
	    replace ilo_job1_lri_slf =  q415asal*4 if (q415bsal==1 & ilo_job1_ste_aggregate==2 & !inlist(q415asal,8888888,9999999)) // Week
	    replace ilo_job1_lri_slf = q415asal if (q415bsal==2 & ilo_job1_ste_aggregate==2 & !inlist(q415asal,8888888,9999999))  // Month
		replace ilo_job1_lri_ees = q415asal*(1/12) if (q415bsal==3 & ilo_job1_ste_aggregate==2 & !inlist(q415asal,8888888,9999999)) // One year
	    replace ilo_job1_lri_slf = .     if ilo_lfs!=1
                lab var ilo_job1_lri_slf "Monthly labour related income of self-employed - main job"
			

    * SECOND JOB
		* Comment: no info
	
	 
 			
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

** !!!!!!! 
* Comment: the results are very different compared to the most recent quarters

* Q427More: Willing to work longer hours. Do/Does …… want to work longer hours?
* Q428Star: Willing to do extra work: If extra work was available, would …… be able to start such work in the next four weeks?

  

	gen ilo_joball_tru = .
	    replace ilo_joball_tru = 1 if ilo_joball_how_usual<35 & q423more==1  & inlist(q24start,1,2)  & ilo_lfs==1
			    lab def tru_lab 1 "Time-related underemployed"
			    lab val ilo_joball_tru tru_lab
			    lab var ilo_joball_tru "Time-related underemployed"
 		
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
*	Cases of non-fatal occupational injury ('ilo_joball_oi_case') 		       *
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
* Comment: no info

 

*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
*  Days lost due to cases of occupational injury ('ilo_joball_oi_day')		   *
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
* Comment: no info

	 
				
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
		replace ilo_cat_une=1 if q38everw==1 & ilo_lfs==2                        // Previously employed       
		replace ilo_cat_une=2 if q38everw==2 & ilo_lfs==2                        // Seeking for the first time
		replace ilo_cat_une=3 if ilo_cat_une==. & ilo_lfs==2                    // Unknown
			    lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
			    lab val ilo_cat_une cat_une_lab
			    lab var ilo_cat_une "Category of unemployment"
				
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			   Duration of unemployment ('ilo_dur')  	                       * 
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 

	* Detailed categories: it is not possible to compute the detailed variable		
 
 
 
    * Aggregate categories
	gen ilo_dur_aggregate=.
		replace ilo_dur_aggregate=1 if (inlist(q36timsk,1,2) & ilo_lfs==2)     // Less than 6 months
		replace ilo_dur_aggregate=2 if (q36timsk==3 & ilo_lfs==2)               // 6 to 12 months
		replace ilo_dur_aggregate=3 if (inlist(q36timsk,4,5) & ilo_lfs==2)      // 12 months or more
		replace ilo_dur_aggregate=4 if (ilo_dur_aggregate==. & ilo_lfs==2)        // Not elsewhere classified
		replace ilo_dur_aggregate=. if ilo_lfs!=2
			    lab def unemp_aggr 1 "1 - Less than 6 months" 2 "2 - 6 months to less than 12 months" 3 "3 - 12 months or more" 4 "4 - Not elsewhere classified"
			    lab val ilo_dur_aggregate unemp_aggr
			    lab var ilo_dur_aggregate "Duration of unemployment (Aggregate)"
		
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4') 	               * 
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: information at 1-digit level in the variable 'indusp'.
*          However, the categories do not completely coincide with ISIC.
* Comment: no possible to compute


* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu_isco08') 		                   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 

    *---------------------------------------------------------------------------
	* ISCO 88
	*---------------------------------------------------------------------------

 
	
	* 2-digit level 
    gen ilo_prevocu_isco88_2digits = . 
	    replace ilo_prevocu_isco88_2digits = int(q310occu/100) if ilo_lfs==2 & ilo_cat_une==1 & !inlist(q310occu,850,8888,9999)
                 * labels already defined for main job
		        lab values ilo_prevocu_isco88_2digits ocu_isco88_2digits
	            lab var ilo_prevocu_isco88_2digits "Previous occupation (ISCO-88), 2 digit level"
			
    * 1-digit level
	gen ilo_prevocu_isco88=.
	    replace ilo_prevocu_isco88=11 if ilo_prevocu_isco88_2digits==. & ilo_lfs==2 & ilo_cat_une==1                          // Not elsewhere classified
		replace ilo_prevocu_isco88=int(ilo_prevocu_isco88_2digits/10) if (ilo_prevocu_isco88==. & ilo_lfs==2 & ilo_cat_une==1)      // The rest of the occupations
		replace ilo_prevocu_isco88=10 if (ilo_prevocu_isco88==0 & ilo_lfs==2 & ilo_cat_une==1)                                      // Armed forces
                * labels already defined for main job
		        lab val ilo_prevocu_isco88 ocu_isco88_1digit
				lab var ilo_prevocu_isco88 "Previous occupation (ISCO-88)"
				
	* Aggregate			
	gen ilo_prevocu_aggregate=.
		replace ilo_prevocu_aggregate=1 if inrange(ilo_prevocu_isco88,1,3)
		replace ilo_prevocu_aggregate=2 if inlist(ilo_prevocu_isco88,4,5)
		replace ilo_prevocu_aggregate=3 if inlist(ilo_prevocu_isco88,6,7)
		replace ilo_prevocu_aggregate=4 if ilo_prevocu_isco88==8
		replace ilo_prevocu_aggregate=5 if ilo_prevocu_isco88==9
		replace ilo_prevocu_aggregate=6 if ilo_prevocu_isco88==10
		replace ilo_prevocu_aggregate=7 if ilo_prevocu_isco88==11
                * labels already defined for main job
		        lab val ilo_prevocu_aggregate ocu_aggr_lab
				lab var ilo_prevocu_aggregate "Previous occupation (Aggregate)"				
				
    * Skill level				
    gen ilo_prevocu_skill=.
	    replace ilo_prevocu_skill=1 if ilo_prevocu_isco88==9                  // Low
		replace ilo_prevocu_skill=2 if inlist(ilo_prevocu_isco88,4,5,6,7,8)   // Medium
		replace ilo_prevocu_skill=3 if inlist(ilo_prevocu_isco88,1,2,3)       // High
		replace ilo_prevocu_skill=4 if inlist(ilo_prevocu_isco88,10,11)       // Not elsewhere classified
                * labels already defined for main job
		        lab val ilo_prevocu_skill ocu_skill_lab
			    lab var ilo_prevocu_skill "Occupation (Skill level) - main job"
				
    
				
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
*!!! CHECK!!
* Comment: there is a skip pattern in the question q36accep, if the person says that s/he will not accept a job, then s/he is not asked q37whnst
* Comment: there are so many missing (78%)
* Comment: there is no information about willingness (only in question Q34WrkRe: Knowledge of any available work, but it is limited to knowledge of any available work)
 
 
 
	gen ilo_olf_dlma=.
		replace ilo_olf_dlma = 1 if q34alook==1 & !inlist(q33wh,1,2) & ilo_lfs==3      // Seeking, not available
		replace ilo_olf_dlma = 2 if q34alook==2 & inlist(q33wh,1,2)  & ilo_lfs==3	    // Not seeking, available
		*replace ilo_olf_dlma = 3 if look_wk==2 & inlist(q33wh,1,2)		      & ilo_lfs==3      // Not seeking, not available, willing
		*replace ilo_olf_dlma = 4 if 		      & ilo_lfs==3      // Not seeking, not available, not willing
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
* Comment: TO CHECK  
* Comment: high amount of NEC (because almost all the observations are not applicable (q311rsnn==8)
* q311rsnn: What was the main reason why …… did not try to find work or start a business in the past four weeks?
*           The question is seeking for reasons why people, who are not working, did not try to look for work or start their own
*           businesses. It only applies to people who answered "No" to both a) and b) of (Q3.8).

 
		gen ilo_olf_reason=.
			replace ilo_olf_reason=1 if inrange(q37ynotl,6,10) & ilo_lfs==3     // Labour market 
			replace ilo_olf_reason=2 if q37ynotl==1 & ilo_lfs==3                // Other labour market reasons
			replace ilo_olf_reason=3 if inrange(q37ynotl,2,5) & ilo_lfs==3      // Personal/Family-related
			*replace ilo_olf_reason=4 if           & ilo_lfs==3                  // Does not need/want to work
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
	    replace ilo_dis=1 if !inlist(ilo_lfs,1,2) & inlist(q33wh,1,2) & ilo_olf_reason==1
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

	/* Variables computed in-between */

	drop todrop*
	drop social_security      
	compress
		
	/* Save dataset including original and ilo variables*/
	save ${country}_${source}_${time}_FULL,  replace		
	
	*Save file only containing ilo_* variables
	keep ilo*
	save ${country}_${source}_${time}_ILO, replace
		
