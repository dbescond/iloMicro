* TITLE OF DO FILE: ILO Microdata Preprocessing code template - PRT, 2017Q4
* DATASET USED: PRT, IE, 2017Q4
* Files created: Standard variables PRT_IE_2017Q4_FULL.dta and PRT_IE_2017Q4_ILO.dta
* Authors: ILO / Department of Statistics / DPAU
* Starting Date: 27 August 2018
* Last updated: 27 August 2018
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
global country "PRT" /*ref_area: ISO 3 Code from the workflow*/
global source "IE"  /*survey: Acronym from the workflow*/
global time "2017Q4"  /*time*/
global inputFile "IE_2017_4t.dta" /*name of the input file in stata format*/
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
*		             	 Sample Weight ('ilo_wgt') 		                       *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 

	gen ilo_wgt=.
	    replace ilo_wgt=ponderador 
		lab var ilo_wgt "Sample weight"
	
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
* Comment: 
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
* Comment: 
destring a4, replace
	
	gen ilo_sex=.
	    replace ilo_sex=1 if a4==1            // Male
		replace ilo_sex=2 if a4==2            // Female
		        label define label_Sex 1 "1 - Male" 2 "2 - Female"
		        label values ilo_sex label_Sex
		        lab var ilo_sex "Sex"

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			                    Age ('ilo_age') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 
	
	gen ilo_age=.
	    replace ilo_age=idade_anos 
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
* Comment: instrucao_area_cnaef2013

    *---------------------------------------------------------------------------
	* ISCED 97
	*---------------------------------------------------------------------------
	/*
	* Detailed
	gen ilo_edu_isced97=.
		replace ilo_edu_isced97=1 if                        // No schooling
		replace ilo_edu_isced97=2 if                        // Pre-primary education
		replace ilo_edu_isced97=3 if                        // Primary education or first stage of basic education
		replace ilo_edu_isced97=4 if                        // Lower secondary education or second stage of basic education
		replace ilo_edu_isced97=5 if                        // Upper secondary education
		replace ilo_edu_isced97=6 if                        // Post-secondary non-tertiary education
		replace ilo_edu_isced97=7 if                        // First stage of tertiary education (not leading directly to an advanced research qualification)
		replace ilo_edu_isced97=8 if                        // Second stage of tertiary education (leading to an advanced research qualification)                               
		replace ilo_edu_isced97=9 if ilo_edu_isced97==.     // Level not stated 
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
				
    *---------------------------------------------------------------------------
	* ISCED 11
	*---------------------------------------------------------------------------
				
    * Detailed				
    gen ilo_edu_isced11=.
		replace ilo_edu_isced11=1 if                        // No schooling
		replace ilo_edu_isced11=2 if                        // Early childhood education
		replace ilo_edu_isced11=3 if                        // Primary education
		replace ilo_edu_isced11=4 if                        // Lower secondary education
		replace ilo_edu_isced11=5 if                        // Upper secondary education
		replace ilo_edu_isced11=6 if                        // Post-secondary non-tertiary education
		replace ilo_edu_isced11=7 if                        // Short-cycle tertiary education
		replace ilo_edu_isced11=8 if                        // Bachelor's or equivalent level
		replace ilo_edu_isced11=9 if                        // Master's or equivalent level
		replace ilo_edu_isced11=10 if                       // Doctoral or equivalent level
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
* Comment: 
destring estuda_formal, replace
destring estuda_nao_formal, replace

			
    gen ilo_edu_attendance=.
		replace ilo_edu_attendance=1 if (estuda_formal==1 | estuda_nao_formal==1)                     // Attending
		replace ilo_edu_attendance=2 if (estuda_formal==2 | estuda_nao_formal==2)                      // Not attending
		replace ilo_edu_attendance=3 if ilo_edu_attendance==.  // Not elsewhere classified
			    lab def edu_attendance_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
			    lab val ilo_edu_attendance edu_attendance_lab
			    lab var ilo_edu_attendance "Education (Attendance)"

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			           Marital status ('ilo_mrts') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 
destring a6, replace

	* Detailed
	gen ilo_mrts_details=.
	    replace ilo_mrts_details=1 if a6==1                                          // Single
		replace ilo_mrts_details=2 if a6==2                                         // Married
		*replace ilo_mrts_details=3 if                                           // Union / cohabiting
		replace ilo_mrts_details=4 if a6==4                                          // Widowed
		replace ilo_mrts_details=5 if a6==3                                          // Divorced / separated
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
* Comment: 
/*
    * Detailed
	gen ilo_dsb_details=.
	    replace ilo_dsb_details=1 if                        // No, no difficulty
		replace ilo_dsb_details=2 if      	                // Yes, some difficulty
		replace ilo_dsb_details=3 if     	                // Yes, a lot of difficulty
		replace ilo_dsb_details=4 if   		                // Cannot do it at all
				label def dsb_det_lab 1 "1 - No, no difficulty" 2 "2 - Yes, some difficulty" 3 "3 - Yes, a lot of difficulty" 4 "4 - Cannot do it at all"
				label val ilo_dsb_details dsb_det_lab
				label var ilo_dsb_details "Disability status (Details)"

    * Aggregate  	
	gen ilo_dsb_aggregate=.
	    replace ilo_dsb_aggregate=1 if                      // Persons without disability
		replace ilo_dsb_aggregate=2 if 	                    // Persons with disability
				label def dsb_lab 1 "1 - Persons without disability" 2 "2 - Persons with disability" 
				label val ilo_dsb_aggregate dsb_lab
				label var ilo_dsb_aggregate "Disability status (Aggregate)"
	*/			
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
*			       Labour Force Status ('ilo_lfs')     to do                        *       
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 
destring b1 b2 b3 b4 b5 b6 b7 b10 b11 b12 b13, replace
 
	
	gen ilo_lfs=.
        replace ilo_lfs=1 if (b2==1 & b13==1) & ilo_wap==1						// Employed: ILO definition
	    replace ilo_lfs=1 if (b3==1 | (inlist(b4,1,2))) & b13==1 & ilo_wap==1						// Employed: ILO definition
		replace ilo_lfs=1 if b5==1 & b13==1 & ilo_wap==1


		replace ilo_lfs=1 if (b6==1 & b13==1) & ilo_wap==1						// Employed: temporary absent
		replace ilo_lfs=2 if () & ilo_lfs!=1 & ilo_wap==1			// Unemployed: three criteria
		replace ilo_lfs=2 if () & ilo_lfs!=1 & ilo_wap==1			// Unemployed: available future starters
	    replace ilo_lfs=3 if !inlist(ilo_lfs,1,2) & ilo_wap==1		// Outside the labour force
				label define label_ilo_lfs 1 "1 - Employed" 2 "2 - Unemployed" 3 "3 - Outside Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status" 
			
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			       Multiple job holders ('ilo_mjh')                            *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 
destring c1, replace

    gen ilo_mjh=.
		replace ilo_mjh=1 if (c1==2) & ilo_lfs==1             // One job only     
		replace ilo_mjh=2 if (c1==1) & ilo_lfs==1             // More than one job
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
* Comment: question c5 has been recoded to sprof1
*SPROF1		Situação na profissão principal
*     1		Trabalha por conta de outrem
*	  2		Trabalha por conta própria como isolado
*	  3		Trabalha por conta própria como empregador
*	  4		Trabalha para uma pessoa de família sem ser pago
		


   * MAIN JOB
   * ICSE 1993
	 gen ilo_job1_ste_icse93=.
		 replace ilo_job1_ste_icse93=1 if sprof1==1 & ilo_lfs==1          // Employees
		 replace ilo_job1_ste_icse93=2 if sprof1==3 & ilo_lfs==1          // Employers
		 replace ilo_job1_ste_icse93=3 if sprof1==2 & ilo_lfs==1          // Own-account workers
		 *replace ilo_job1_ste_icse93=4 if  & ilo_lfs==1          // Members of producers' cooperatives
		 replace ilo_job1_ste_icse93=5 if sprof1==4 & ilo_lfs==1          // Contributing family workers
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
	* ICSE 1993
	  gen ilo_job2_ste_icse93=.
		  replace ilo_job2_ste_icse93=1 if sprof2==1 & ilo_mjh==2          // Employees
		  replace ilo_job2_ste_icse93=2 if sprof2==3 & ilo_mjh==2          // Employers
		  replace ilo_job2_ste_icse93=3 if sprof2==2 & ilo_mjh==2          // Own-account workers
		  *replace ilo_job2_ste_icse93=4 if  & ilo_mjh==2          // Members of producers' cooperatives 
		  replace ilo_job2_ste_icse93=5 if sprof2==4 & ilo_mjh==2          // Contributing family workers
		  replace ilo_job2_ste_icse93=6 if ilo_job2_ste_icse93==. & ilo_mjh==2  // Workers not classifiable by status
		  replace ilo_job2_ste_icse93=. if ilo_mjh!=2
 			      label value ilo_job2_ste_icse93 label_ilo_ste_icse93
			      label var ilo_job2_ste_icse93 "Status in employment (ICSE 93) - second job"

	* Aggregate categories
	  gen ilo_job2_ste_aggregate=.
		  replace ilo_job2_ste_aggregate=1 if ilo_job2_ste_icse93==1                 // Employees
		  replace ilo_job2_ste_aggregate=2 if inlist(ilo_job2_ste_icse93,2,3,4,5)    // Self-employed
		  replace ilo_job2_ste_aggregate=3 if inlist(ilo_job2_ste_icse93,6)          // Not elsewhere classified
				  lab val ilo_job2_ste_aggregate ste_aggr_lab
				  label var ilo_job2_ste_aggregate "Status in employment (Aggregate) - second job"

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			            Economic activity ('ilo_eco')                          *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: CAE-Rev.3 >> NACERev.2 >> ISIC Rev. 4.

    * MAIN JOB
	
    

    *---------------------------------------------------------------------------
	* ISIC REV 4
	*---------------------------------------------------------------------------
destring c3, replace
	
	* 2-digit level
	gen ilo_job1_eco_isic4_2digits = . 
	    replace ilo_job1_eco_isic4_2digits = c3 if ilo_lfs==1  
	    replace ilo_job1_eco_isic4_2digits = .    if ilo_lfs!=1
			    lab def eco_isic4_2digits 1 "01 - Crop and animal production, hunting and related service activities"	2 "02 - Forestry and logging"	3 "03 - Fishing and aquaculture"	5 "05 - Mining of coal and lignite" ///
                                          6 "06 - Extraction of crude petroleum and natural gas"	7 "07 - Mining of metal ores"	8 "08 - Other mining and quarrying"	9 "09 - Mining support service activities" ///
                                          10 "10 - Manufacture of food products"	11 "11 - Manufacture of beverages"	12 "12 - Manufacture of tobacco products"	13 "13 - Manufacture of textiles" ///
                                          14 "14 - Manufacture of wearing apparel"	15 "15 - Manufacture of leather and related products"	16 "16 - Manufacture of wood and of products of wood and cork, except furniture; manufacture of articles of straw and plaiting materials"	17 "17 - Manufacture of paper and paper products" ///
                                          18 "18 - Printing and reproduction of recorded media"	19 "19 - Manufacture of coke and refined petroleum products"	20 "20 - Manufacture of chemicals and chemical products"	21 "21 - Manufacture of pharmaceuticals, medicinal chemical and botanical products" ///
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


    * SECOND JOB
	
  
    *---------------------------------------------------------------------------
	* ISIC REV 4
	*---------------------------------------------------------------------------
destring c36, replace
	
	* 2-digit level
	gen ilo_job2_eco_isic4_2digits = . 
	    replace ilo_job2_eco_isic4_2digits = c39     if ilo_mjh==2
	    replace ilo_job2_eco_isic4_2digits = .    if ilo_mjh!=2
                * labels already defined for main job
		        lab val ilo_job2_eco_isic4_2digits eco_isic4_2digits
                lab var ilo_job2_eco_isic4_2digits "Economic activity (ISIC Rev. 4), 2 digits level - second job"

	* 1-digit level
    gen ilo_job2_eco_isic4=.
	    replace ilo_job2_eco_isic4=1 if inrange(ilo_job2_eco_isic4_2digits,1,3)
	    replace ilo_job2_eco_isic4=2 if inrange(ilo_job2_eco_isic4_2digits,5,9)
	    replace ilo_job2_eco_isic4=3 if inrange(ilo_job2_eco_isic4_2digits,10,33)
	    replace ilo_job2_eco_isic4=4 if ilo_job2_eco_isic4_2digits==35
	    replace ilo_job2_eco_isic4=5 if inrange(ilo_job2_eco_isic4_2digits,36,39)
	    replace ilo_job2_eco_isic4=6 if inrange(ilo_job2_eco_isic4_2digits,41,43)
	    replace ilo_job2_eco_isic4=7 if inrange(ilo_job2_eco_isic4_2digits,45,47)
	    replace ilo_job2_eco_isic4=8 if inrange(ilo_job2_eco_isic4_2digits,49,53)
	    replace ilo_job2_eco_isic4=9 if inrange(ilo_job2_eco_isic4_2digits,55,56)
	    replace ilo_job2_eco_isic4=10 if inrange(ilo_job2_eco_isic4_2digits,58,63)
	    replace ilo_job2_eco_isic4=11 if inrange(ilo_job2_eco_isic4_2digits,64,66)
	    replace ilo_job2_eco_isic4=12 if ilo_job2_eco_isic4_2digits==68
	    replace ilo_job2_eco_isic4=13 if inrange(ilo_job2_eco_isic4_2digits,69,75)		
	    replace ilo_job2_eco_isic4=14 if inrange(ilo_job2_eco_isic4_2digits,77,82)
	    replace ilo_job2_eco_isic4=15 if ilo_job2_eco_isic4_2digits==84
        replace ilo_job2_eco_isic4=16 if ilo_job2_eco_isic4_2digits==85
	    replace ilo_job2_eco_isic4=17 if inrange(ilo_job2_eco_isic4_2digits,86,88)
	    replace ilo_job2_eco_isic4=18 if inrange(ilo_job2_eco_isic4_2digits,90,93)
	    replace ilo_job2_eco_isic4=19 if inrange(ilo_job2_eco_isic4_2digits,94,96)
	    replace ilo_job2_eco_isic4=20 if inrange(ilo_job2_eco_isic4_2digits,97,98)
	    replace ilo_job2_eco_isic4=21 if ilo_job2_eco_isic4_2digits==99
	    replace ilo_job2_eco_isic4=22 if ilo_job2_eco_isic4==. & ilo_mjh==2
                * labels already defined for main job
		        lab val ilo_job2_eco_isic4 eco_isic4_1digit
			    lab var ilo_job2_eco_isic4 "Economic activity (ISIC Rev. 4) - second job"

   * Aggregate level
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

			   
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			               Occupation ('ilo_ocu') 	 REVISE!!!!!                          *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: CPP 2010 >> ISCO-08 
***       (Classificação Portuguesa das Profissões : 2010)

    * MAIN JOB
			
    *---------------------------------------------------------------------------
	* ISCO 08
	*---------------------------------------------------------------------------
	
	* 2-digit level 
    gen ilo_job1_ocu_isco08_2digits = . 
	    replace ilo_job1_ocu_isco08_2digits = c4    if ilo_lfs==1
		replace ilo_job1_ocu_isco08_2digits = .   if ilo_lfs!=1
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
	    replace ilo_job1_ocu_isco08=11 if inlist(ilo_job1_ocu_isco08_2digits,) & ilo_lfs==1                          // Not elsewhere classified
		replace ilo_job1_ocu_isco08=int(ilo_job1_ocu_isco08_2digits/10) if (ilo_job1_ocu_isco08==. & ilo_lfs==1)     // The rest of the occupations
		replace ilo_job1_ocu_isco08=10 if (ilo_job1_ocu_isco08==0 & ilo_lfs==1)                                      // Armed forces
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


    * SECOND JOB: no info
 
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*	Institutional sector of economic activities ('ilo_ins_sector')		       *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: no info
/*
		
	gen ilo_job1_ins_sector=.
		replace ilo_job1_ins_sector=1 if                        & ilo_lfs==1    // Public
		replace ilo_job1_ins_sector=2 if ilo_job1_ins_sector==. & ilo_lfs==1    // Private
			    lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
			    lab values ilo_job1_ins_sector ins_sector_lab
			    lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities - main job"
	*/	
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*		               Hours of work ('ilo_how')  	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: !!!! REVISE: B

destring c21, replace
destring c22, replace
destring c42, replace

    * MAIN JOB
	
	* Hours USUALLY worked
	gen ilo_job1_how_usual = .
	    replace ilo_job1_how_usual =  c21     if ilo_lfs==1
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
	    replace ilo_job1_how_actual =  c22     if ilo_lfs==1
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
	
	* Hours USUALLY worked: no info 
				
	* Hours ACTUALLY worked
    gen ilo_job2_how_actual = .
	    replace ilo_job2_how_actual = c42      if ilo_mjh==2
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
		

    * ALL JOBS
	

				
	* Hours ACTUALLY worked
   egen ilo_joball_how_actual = rowtotal(ilo_job1_how_actual ilo_job2_how_actual), m 
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
* Comment: national threshold in 40 hrs
			
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
* Comment: question c12 has been recoded to "contrato"
destring contrato, replace
	
	gen ilo_job1_job_contract=.
		replace ilo_job1_job_contract=1 if contrato==1 & ilo_lfs==1               				// Permanent
		replace ilo_job1_job_contract=2 if inlist(contrato,2,3) & ilo_lfs==1               	   // Temporary
		replace ilo_job1_job_contract=3 if ilo_job1_job_contract==. & ilo_lfs==1  	          // Unknown
			    lab def job_contract_lab 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"
			    lab val ilo_job1_job_contract job_contract_lab
			    lab var ilo_job1_job_contract "Job (Type of contract)"

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*  Informal/formal economy: ('ilo_job1_ife_prod'/'ilo_job1_ife_nature') 	   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment:
/* Useful questions:
          - Institutional sector: 
		  - Private household identification: 
		  - Destination of production:
		  - Bookkeeping:
		  - Registration:
		  - Status in employment:
		  - Social security contribution (Proxy: pension funds):
		  - Place of work:
		  - Size:
		  - Paid annual leave:
		  - Paid sick leave:
*/
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
		
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*	    Monthly labour related income ('ilo_lri_ees' and 'ilo_lri_slf')  	   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 
destring i1, replace

    * MAIN JOB
	
	* Employees
	gen ilo_job1_lri_ees = .
	    replace ilo_job1_lri_ees = i1      if ilo_job1_ste_aggregate==1
	    replace ilo_job1_lri_ees = .     if ilo_lfs!=1
		        lab var ilo_job1_lri_ees "Monthly earnings of employees - main job"
	
	* Self-employed
	gen ilo_job1_lri_slf = .
	    replace ilo_job1_lri_slf =  i1     if ilo_job1_ste_aggregate==2
	    replace ilo_job1_lri_slf = .     if ilo_lfs!=1
		        lab var ilo_job1_lri_slf "Monthly labour related income of self-employed - main job"
			

    * SECOND JOB: no info
	
	 
				
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
* Comment:
** Self-perception: c43

destring c44, replace
destring c47, replace

** TO CHECK:
** c44: Would you like to work more hours regularly and earn more or work less?

	gen ilo_joball_tru = .
	    replace ilo_joball_tru = 1 if ilo_joball_how_usual<=39  &  c44==1 & c47==1 & ilo_lfs==1
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
* Comment:  no info

 
				
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
destring f1, replace
	
	gen ilo_cat_une=.
		replace ilo_cat_une=1 if f1==1 & ilo_lfs==2                             // Previously employed       
		replace ilo_cat_une=2 if f1==2 & ilo_lfs==2                             // Seeking for the first time
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
destring dne6, replace
destring dne6_1, replace

	* Detailed categories		
    gen ilo_dur_details=.
	    replace ilo_dur_details=1 if dne6==2017      & ilo_lfs==2                 // Less than 1 month
		replace ilo_dur_details=2 if       & ilo_lfs==2                 // 1 to 3 months
		replace ilo_dur_details=3 if       & ilo_lfs==2                 // 3 to 6 months
		replace ilo_dur_details=4 if       & ilo_lfs==2                 // 6 to 12 months
		replace ilo_dur_details=5 if       & ilo_lfs==2                 // 12 to 24 months
		replace ilo_dur_details=6 if       & ilo_lfs==2                 // 24 months or more
		replace ilo_dur_details=7 if ilo_dur_details==. & ilo_lfs==2    // Not elsewhere classified
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
* ------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4') 	               * 
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 

     
    *---------------------------------------------------------------------------
	* ISIC REV 4
	*---------------------------------------------------------------------------
	
	* 2-digit level
	gen ilo_preveco_isic4_2digits = . 
	    replace ilo_preveco_isic4_2digits =  f5    if ilo_lfs==2 & ilo_cat_une==1
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

   * Aggregate level
   gen ilo_preveco_aggregate=.
	   replace ilo_preveco_aggregate=1 if ilo_preveco_isic4==1
	   replace ilo_preveco_aggregate=2 if ilo_preveco_isic4==3
	   replace ilo_preveco_aggregate=3 if ilo_preveco_isic4==6
	   replace ilo_preveco_aggregate=4 if inlist(ilo_preveco_isic4,2,4,5)
	   replace ilo_preveco_aggregate=5 if inrange(ilo_preveco_isic4,7,14)
	   replace ilo_preveco_aggregate=6 if inrange(ilo_preveco_isic4,15,21)
	   replace ilo_preveco_aggregate=7 if ilo_preveco_isic4==22
               * labels already defined for main job
	           lab val ilo_preveco_aggregate eco_aggr_lab
			   lab var ilo_preveco_aggregate "Previous economic activity (Aggregate)"
		
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu_isco08') 		                   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 

     
				
    *---------------------------------------------------------------------------
	* ISCO 08
	*---------------------------------------------------------------------------
	
	* 2-digit level 
    gen ilo_prevocu_isco08_2digits = . 
	    replace ilo_prevocu_isco08_2digits = f6    if ilo_lfs==2 & ilo_cat_une==1
                * labels already defined for main job
		        lab values ilo_prevocu_isco08_2digits ocu_isco08_2digits
	            lab var ilo_prevocu_isco08_2digits "Previous occupation (ISCO-08), 2 digit level"
				
	* 1-digit level 				
	gen ilo_prevocu_isco08=.
	    replace ilo_prevocu_isco08=11 if inlist(ilo_prevocu_isco08_2digits,) & ilo_lfs==2 & ilo_cat_une==1                          // Not elsewhere classified
		replace ilo_prevocu_isco08=int(ilo_prevocu_isco08_2digits/10) if (ilo_prevocu_isco08==. & ilo_lfs==2 & ilo_cat_une==1)      // The rest of the occupations
		replace ilo_prevocu_isco08=10 if (ilo_prevocu_isco08==0 & ilo_lfs==2 & ilo_cat_une==1)                                      // Armed forces
                * labels already defined for main job
		        lab val ilo_prevocu_isco08 ocu_isco08_1digit
				lab var ilo_prevocu_isco08 "Previous occupation (ISCO-08)"
				
	* Aggregate			
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
* Comment: 

	gen ilo_olf_dlma=.
		replace ilo_olf_dlma = 1 if               & ilo_lfs==3      // Seeking, not available
		replace ilo_olf_dlma = 2 if               & ilo_lfs==3	    // Not seeking, available
		replace ilo_olf_dlma = 3 if 		      & ilo_lfs==3      // Not seeking, not available, willing
		replace ilo_olf_dlma = 4 if 		      & ilo_lfs==3      // Not seeking, not available, not willing
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
* Comment: 

		gen ilo_olf_reason=.
			replace ilo_olf_reason=1 if           & ilo_lfs==3             // Labour market 
			replace ilo_olf_reason=2 if           & ilo_lfs==3             // Other labour market reasons
			replace ilo_olf_reason=3 if           & ilo_lfs==3             // Personal/Family-related
			replace ilo_olf_reason=4 if           & ilo_lfs==3             // Does not need/want to work
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
* Comment:

	gen ilo_dis=.
	    replace ilo_dis=1 if !inlist(ilo_lfs,1,2) &      & ilo_olf_reason==1
			    lab def ilo_dis_lab 1 "Discouraged job-seekers" 
			    lab val ilo_dis ilo_dis_lab
			    lab var ilo_dis "Discouraged job-seekers"	

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			      Susbsistence Farming ('ilo_sub') 		                   		*
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment:

	gen ilo_sub=.
	    replace ilo_sub=1 if !inlist(ilo_lfs,1,2) &
			    lab def ilo_sub_lab 1 "Subsistence Farming" 
			    lab val ilo_sub ilo_sub_lab
			    lab var ilo_sub "Subsistence Farming"	

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
	drop
	compress
		
	/* Save dataset including original and ilo variables*/
	save ${country}_${source}_${time}_FULL,  replace		
	
	*Save file only containing ilo_* variables
	keep ilo*
	save ${country}_${source}_${time}_ILO, replace
		