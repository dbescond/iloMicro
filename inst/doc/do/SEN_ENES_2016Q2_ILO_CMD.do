* TITLE OF DO FILE: ILO Microdata Preprocessing code template - SENEGAL
* DATASET USED: SENEGAL, ENES, 2016Q2
* NOTES: 
* Files created: Standard variables SEN_ENES_2016Q2_FULL.dta and SEN_ENES_2016Q2_ILO.dta
* Authors: ILO / Department of Statistics / DPAU
* Starting Date: 10 May 2018
* Last updated: 10 May 2018
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
global country "SEN"
global source "ENES"
global time "2016Q2"
global inputFile "SEN_ENES_2016Q2"
global inpath "${path}\\${country}\\${source}\\${time}\ORI"
global temppath "${path}\_Admin"
global outpath "${path}\\${country}\\${source}\\${time}"

********************************************************************************
********************************************************************************

cd "$inpath"
	use ${inputFile}, clear
	*renaming everything in lower case
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
	    replace ilo_wgt=poids_corr
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
	    replace ilo_geo=1 if ba1==1		// Urban 
		replace ilo_geo=2 if ba1==2		// Rural
		        lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural"
		        lab val ilo_geo ilo_geo_lab
		        lab var ilo_geo "Geographical coverage"	
		
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			                     Sex ('ilo_sex') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
	
	gen ilo_sex=.
	    replace ilo_sex=1 if b3==1		// Male
		replace ilo_sex=2 if b3==2		// Female
		        label define label_Sex 1 "1 - Male" 2 "2 - Female"
		        label values ilo_sex label_Sex
		        lab var ilo_sex "Sex"

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			                    Age ('ilo_age') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
	
    * Age groups
	gen ilo_age_5yrbands=.
		replace ilo_age_5yrbands=1 if b4_r==1
		replace ilo_age_5yrbands=2 if b4_r==2
		replace ilo_age_5yrbands=3 if b4_r==3
		replace ilo_age_5yrbands=4 if b4_r==4
		replace ilo_age_5yrbands=5 if b4_r==5
		replace ilo_age_5yrbands=6 if b4_r==6
		replace ilo_age_5yrbands=7 if b4_r==7
		replace ilo_age_5yrbands=8 if b4_r==8
		replace ilo_age_5yrbands=9 if b4_r==9
		replace ilo_age_5yrbands=10 if b4_r==10
		replace ilo_age_5yrbands=11 if b4_r==11
		replace ilo_age_5yrbands=12 if b4_r==12
		replace ilo_age_5yrbands=13 if b4_r==13
		replace ilo_age_5yrbands=14 if inlist(b4_r,14,15,16) & b4_r!=.
			lab def age_by5_lab 1 "0-4" 2 "5-9" 3 "10-14" 4 "15-19" 5 "20-24" 6 "25-29" 7 "30-34" 8 "35-39" 9 "40-44" 10 "45-49" 11 "50-54" 12 "55-59" 13 "60-64" 14 "65+"
			lab val ilo_age_5yrbands age_by5_lab
			lab var ilo_age_5yrbands "Age (5-year age bands)"
			
	gen ilo_age_10yrbands=.
		replace ilo_age_10yrbands=1 if inrange(ilo_age_5yrbands,1,3)
		replace ilo_age_10yrbands=2 if inrange(ilo_age_5yrbands,4,5)
		replace ilo_age_10yrbands=3 if inrange(ilo_age_5yrbands,6,7)
		replace ilo_age_10yrbands=4 if inrange(ilo_age_5yrbands,8,9)
		replace ilo_age_10yrbands=5 if inrange(ilo_age_5yrbands,10,11)
		replace ilo_age_10yrbands=6 if inrange(ilo_age_5yrbands,12,13)
		replace ilo_age_10yrbands=7 if ilo_age_5yrbands==14 & ilo_age_5yrbands!=.
			lab def age_by10_lab 1 "<15" 2 "15-24" 3 "25-34" 4 "35-44" 5 "45-54" 6 "55-64" 7 "65+"
			lab val ilo_age_10yrbands age_by10_lab
			lab var ilo_age_10yrbands "Age (10-year age bands)"
			
	gen ilo_age_aggregate=.
		replace ilo_age_aggregate=1 if inrange(ilo_age_5yrbands,1,3)
		replace ilo_age_aggregate=2 if inrange(ilo_age_5yrbands,4,5)
		replace ilo_age_aggregate=3 if inrange(ilo_age_5yrbands,6,11)
		replace ilo_age_aggregate=4 if inrange(ilo_age_5yrbands,12,13)
		replace ilo_age_aggregate=5 if ilo_age_5yrbands==14 & ilo_age_5yrbands!=.
			lab def age_aggr_lab 1 "<15" 2 "15-24" 3 "25-54" 4 "55-64" 5 "65+"
			lab val ilo_age_aggregate age_aggr_lab
			lab var ilo_age_aggregate "Age (Aggregate)"
			
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			           Level of education ('ilo_edu') 		                   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

* Comment: Based on the UNESCO mapping available on  http://uis.unesco.org/en/isced-mappings

    *---------------------------------------------------------------------------
	* ISCED 11
	*---------------------------------------------------------------------------
				
    * Detailed				
	gen ilo_edu_isced11=.
		replace ilo_edu_isced11=1 if b35==.                 	           	// No schooling
		replace ilo_edu_isced11=2 if inlist(b35,1,2)            	       	// Early childhood education
		replace ilo_edu_isced11=3 if inrange(b35,3,11)                     	// Primary education 
		replace ilo_edu_isced11=4 if inrange(b35,12,15)                    	// Lower secondary education
		replace ilo_edu_isced11=5 if inlist(b35,16,17,18)                  	// Upper secondary education
		replace ilo_edu_isced11=6 if inrange(b35,19,23)                    	// Post-secondary non-tertiary education
		*replace ilo_edu_isced11=7 if                                      	// Short-cycle tertiary education
		replace ilo_edu_isced11=8 if inlist(b35,24,25,26)                  	// Bachelor's or equivalent level
		replace ilo_edu_isced11=9 if inlist(b35,27,28)                     	// Master's or equivalent level
		replace ilo_edu_isced11=10 if inlist(b35,29,30,31)                	// Doctoral or equivalent level
		replace ilo_edu_isced11=11 if ilo_edu_isced11==.                  	// Not elsewhere classified 
			label def isced_11_lab 1 "X - No schooling" 2 "0 - Early childhood education" 3 "1 - Primary education" 4 "2 - Lower secondary education" 5 "3 - Upper secondary education" ///
								6 "4 - Post-secondary non-tertiary education" 7 "5 - Short-cycle tertiary education" 8 "6 - Bachelor's or equivalent level" 9 "7 - Master's or equivalent level" ///
								10 "8 - Doctoral or equivalent level" 11 "9 - Not elsewhere classified"
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

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*		  	 Educational attendance ('ilo_edu_attendance') 		               *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
			
	gen ilo_edu_attendance=.
		replace ilo_edu_attendance=1 if b29==1                     	// Yes
		replace ilo_edu_attendance=2 if b29==2	                   	// No
		replace ilo_edu_attendance=3 if ilo_edu_attendance==.     	// Not elsewhere classified
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
	    replace ilo_mrts_details=1 if b14==1			// Single
		replace ilo_mrts_details=2 if inlist(b14,3,4)	// Married
		replace ilo_mrts_details=3 if b14==2			// Union / cohabiting
		replace ilo_mrts_details=4 if b14==6			// Widowed
		replace ilo_mrts_details=5 if b14==5			// Divorced / separated
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

	gen ilo_dsb_details=.
		replace ilo_dsb_details=4 if (b41==4 | b42==4 | b43==4 | b44==4 | b45==4 | b46==4)
		replace ilo_dsb_details=3 if ilo_dsb_details==. & (b41==3 | b42==3 | b43==3 | b44==3 | b45==3 | b46==3)
		replace ilo_dsb_details=2 if ilo_dsb_details==. & (b41==2 | b42==2 | b43==2 | b44==2 | b45==2 | b46==2)
		replace ilo_dsb_details=1 if ilo_dsb_details==.
			label def dsb_details_lab 1 "No, no difficulty" 2 "Yes, some difficulty" 3 "Yes, a lot of difficulty" 4 "Cannot do it at all"
			label val ilo_dsb_details dsb_details_lab
			label var ilo_dsb_details "Disability status (Details)"

	gen ilo_dsb_aggregate=.
		replace ilo_dsb_aggregate=1 if (ilo_dsb_details==1 | ilo_dsb_details==2)
		replace ilo_dsb_aggregate=2 if (ilo_dsb_details==3 | ilo_dsb_details==4)
			label def dsb_aggregate_lab 1 "Persons without disability" 2 "Persons with disability"
			label val ilo_dsb_aggregate dsb_aggregate_lab
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
		replace ilo_wap=1 if ilo_age_5yrbands>=4 & ilo_age_5yrbands!=.
			    label var ilo_wap "Working age population"

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			       Labour Force Status ('ilo_lfs')                             *       
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

* Comment: For employment, reference period used is in line with ICLS (last 7 days) and not last 3 months.
	
	gen ilo_lfs=.
        replace ilo_lfs=1 if ((c1c==1 | c2c==1 | c3c==1 | c4c==1 | c4c==2 | c5c==1) & ilo_wap==1)										// Employment: ILO definition
		replace ilo_lfs=1 if (c6_1==1 | c6_2==1 | c6_3==1 | c6_4==1 | c6_5==1 | c6_6==1 | c6_7==1 | c6_8==1) & ilo_wap==1 & ilo_wap==1	// Employment: ILO definition - Further checks
		replace ilo_lfs=1 if (c7==1 & ilo_wap==1)																						// Temporary absent
		replace ilo_lfs=2 if (ilo_lfs!=1 & (g1==1 | g2==1) & g7==1 & ilo_wap==1)														// Unemployed: three criteria
	    replace ilo_lfs=3 if !inlist(ilo_lfs,1,2) & ilo_wap==1		// Outside the labour force
				label define label_ilo_lfs 1 "1 - Employed" 2 "2 - Unemployed" 3 "3 - Outside Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status" 

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			       Multiple job holders ('ilo_mjh')                            *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

    gen ilo_mjh=.
		replace ilo_mjh=1 if (d32==1 & ilo_lfs==1)		// One job only     
		replace ilo_mjh=2 if (d32==2 & ilo_lfs==1)		// More than one job
		replace ilo_mjh=1 if (d32==. & ilo_lfs==1)
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

   * MAIN JOB:
   * ICSE 1993
	* Detailed categories:
	gen ilo_job1_ste_icse93=.
		replace ilo_job1_ste_icse93=1 if inlist(c14,1,2,3,7) & ilo_lfs==1 	    // Employees
		replace ilo_job1_ste_icse93=2 if c14==4 & ilo_lfs==1	                // Employers
		replace ilo_job1_ste_icse93=3 if c14==6 & ilo_lfs==1                  	// Own-account workers
		*replace ilo_job1_ste_icse93=4                                          // Members of producers cooperatives
		replace ilo_job1_ste_icse93=5 if inlist(c14,5,8) & ilo_lfs==1     	    // Contributing family workers
		replace ilo_job1_ste_icse93=6 if ilo_job1_ste_icse93==. & ilo_lfs==1    // Not classifiable
			    label def label_ilo_ste_icse93 1 "1 - Employees" 2 "2 - Employers" 3 "3 - Own-account workers"                ///
				    						   4 "4 - Members of producers cooperatives" 5 "5 - Contributing family workers"  ///
					    					   6 "6 - Workers not classifiable by status"
			    label val ilo_job1_ste_icse93 label_ilo_ste_icse93
			    label var ilo_job1_ste_icse93 "Status in employment (ICSE 93) in main job"

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
	
	gen indu_code_prim=.
		    replace indu_code_prim=d4a if ilo_lfs==1
			replace indu_code_prim=e3_a if (indu_code_prim==. & ilo_lfs==1)
			replace indu_code_prim=f5_a if (indu_code_prim==. & ilo_lfs==1)

	* 1-digit level
    gen ilo_job1_eco_isic4=.
	    replace ilo_job1_eco_isic4=1 if indu_code_prim==1
	    replace ilo_job1_eco_isic4=2 if indu_code_prim==2
	    replace ilo_job1_eco_isic4=3 if indu_code_prim==3
	    replace ilo_job1_eco_isic4=4 if indu_code_prim==4
	    replace ilo_job1_eco_isic4=5 if indu_code_prim==5
	    replace ilo_job1_eco_isic4=6 if indu_code_prim==6
	    replace ilo_job1_eco_isic4=7 if indu_code_prim==7
	    replace ilo_job1_eco_isic4=8 if indu_code_prim==8
	    replace ilo_job1_eco_isic4=9 if indu_code_prim==9
	    replace ilo_job1_eco_isic4=10 if indu_code_prim==10
	    replace ilo_job1_eco_isic4=11 if indu_code_prim==11
	    replace ilo_job1_eco_isic4=12 if indu_code_prim==12
	    replace ilo_job1_eco_isic4=13 if indu_code_prim==13	
	    replace ilo_job1_eco_isic4=14 if indu_code_prim==14
	    * replace ilo_job1_eco_isic4=15 if indu_code_prim
        replace ilo_job1_eco_isic4=16 if indu_code_prim==15
	    replace ilo_job1_eco_isic4=17 if indu_code_prim==16
	    * replace ilo_job1_eco_isic4=18 if indu_code_prim
	    replace ilo_job1_eco_isic4=19 if indu_code_prim==17
	    replace ilo_job1_eco_isic4=20 if indu_code_prim==18
	    replace ilo_job1_eco_isic4=21 if indu_code_prim==19
	    replace ilo_job1_eco_isic4=22 if indu_code_prim==. & ilo_lfs==1
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

	gen occ_code_prim=.
		replace occ_code_prim=int(d3b/100) if ilo_lfs==1
		replace occ_code_prim=int(f4_c/100) if (occ_code_prim==. & ilo_lfs==1)

	* 2-digit level 
    gen ilo_job1_ocu_isco08_2digits=. 
	    replace ilo_job1_ocu_isco08_2digits=occ_code_prim if ilo_lfs==1
		replace ilo_job1_ocu_isco08_2digits=.  if ilo_lfs!=1
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
		replace ilo_job1_ocu_isco08=int(ilo_job1_ocu_isco08_2digits/10) if (ilo_job1_ocu_isco08==. & ilo_lfs==1)     // The rest of the occupations
		replace ilo_job1_ocu_isco08=10 if (ilo_job1_ocu_isco08==0 & ilo_lfs==1)                                      // Armed forces
		replace ilo_job1_ocu_isco08=11 if inlist(ilo_job1_ocu_isco08_2digits,.) & ilo_lfs==1                         // Not elsewhere classified
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


* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*	Institutional sector of economic activities ('ilo_ins_sector')		       *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
		
	gen ilo_job1_ins_sector=.
		replace ilo_job1_ins_sector=1 if inlist(d5,1,2,5,8) & ilo_lfs==1        // Public
		replace ilo_job1_ins_sector=2 if ilo_job1_ins_sector==. & ilo_lfs==1	// Private
			    lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
			    lab values ilo_job1_ins_sector ins_sector_lab
			    lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities - main job"
		
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*		               Hours of work ('ilo_how')  	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
				
    ***********
    * MAIN JOB:
    ***********

	* Hours ACTUALLY worked
	gen ilo_job1_how_actual=(d29b*d29c) if ilo_lfs==1
	     replace ilo_job1_how_actual=f15 if (ilo_job1_how_actual==. & ilo_lfs==1)
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

* Comment: Not enough information to create this variable
			
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*		    	Type of contract ('ilo_job_contract') 		                   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

* Comment: Not enough information to create this variable


* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*  Informal/formal economy: ('ilo_job1_ife_prod'/'ilo_job1_ife_nature') 	   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

/* Useful questions:
			- Institutional sector: d5 / e4 / f6
			- Destination of production: 
			- Bookkeeping: d7 / e6 / f8
			- Registration: d6_1 d6_2 d6_3 d6_4 / e5_1 e5_2 e5_3 e5_4 / f7_1 f7_2 f7_3 f7_4
			- Place of work: c12
			- Size: 
			- Status in employment: ilo_job1_ste_aggregate / ilo_job1_ste_icse93
			- Social security contribution / Pension: d18_5  
			- Paid annual leave: d18_3
			- Paid sick leave: d18_4
*/
	
	* 1) UNIT OF PRODUCTION: FORMAL/INFORMAL SECTOR		
    			
			gen ilo_job1_ife_prod=.
			    replace ilo_job1_ife_prod=3 if ilo_lfs==1 & (d5==9 | f6==5)
				replace ilo_job1_ife_prod=2 if ilo_lfs==1 & (inlist(d5,1,2,5,8) | d7==1 | inlist(e4,1,2) | e6==1 | f8==1)
				replace ilo_job1_ife_prod=2 if ilo_lfs==1 & ((d6_1==1 & d6_2==1 & d6_3==1) | (d6_1==1 & d6_2==1 & d6_4==1) | (d6_1==1 & d6_3==1 & d6_4==1) | (d6_2==1 & d6_3==1 & d6_4==1)) 
				replace ilo_job1_ife_prod=2 if ilo_lfs==1 & ((e5_1==1 & e5_2==1 & e5_3==1) | (e5_1==1 & e5_2==1 & e5_4==1) | (e5_1==1 & e5_3==1 & e5_4==1) | (e5_2==1 & e5_3==1 & e5_4==1))
				replace ilo_job1_ife_prod=2 if ilo_lfs==1 & ((f7_1==1 & f7_2==1 & f7_3==1) | (f7_1==1 & f7_2==1 & f7_4==1) | (f7_1==1 & f7_3==1 & f7_4==1) | (f7_2==1 & f7_3==1 & f7_4==1))
			    replace ilo_job1_ife_prod=1 if ilo_lfs==1 & ilo_job1_ife_prod==.
				        lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 
						lab val ilo_job1_ife_prod ilo_ife_prod_lab
						lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"

	* 2) NATURE OF JOB: FORMAL/INFORMAL EMPLOYMENT
	
	      gen ilo_job1_ife_nature=.
		      replace ilo_job1_ife_nature=2 if ilo_lfs==1 & ((inlist(ilo_job1_ste_icse93,1,6) & d18_5==1) | (inlist(ilo_job1_ste_icse93,2,4) & ilo_job1_ife_prod==2))
			  replace ilo_job1_ife_nature=1 if ilo_lfs==1 & (ilo_job1_ife_nature!=2)
			          lab def ife_nature_lab 1 "1 - Persons with informal main job" 2 "2 - Persons with formal main job"
			          lab val ilo_job1_ife_nature ife_nature_lab
			          lab var ilo_job1_ife_nature "Informal / Formal Economy (Nature of job)"
		
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*	    Monthly related income ('ilo_lri_ees' and 'ilo_lri_slf')  		       *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

* Comment: very few respondents to D35/D36 -> Not processed. 

	
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

* Comment: Not enough information to be processed.

			
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
*	Cases of non-fatal occupational injury ('ilo_joball_oi_case') 		       *
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------

* Comment: No information to be processed.

*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
*  Days lost due to cases of occupational injury ('ilo_joball_oi_day')		   *
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------

* Comment: No information to be processed.
				
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

* Comment: No information to be processed.
				
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			   Duration of unemployment ('ilo_dur')  	                       * 
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

	* Detailed categories		
	gen ilo_dur_details=.
		replace ilo_dur_details=1 if (g4==1 & ilo_lfs==2)            	// Less than 1 month
		replace ilo_dur_details=2 if (inlist(g4,2,3) & ilo_lfs==2)      // 1 to 3 months
		replace ilo_dur_details=3 if (inlist(g4,4,5,6) & ilo_lfs==2)    // 3 to 6 months
		replace ilo_dur_details=4 if (inrange(g4,7,12) & ilo_lfs==2)    // 6 to 12 months
		replace ilo_dur_details=5 if (inrange(g4,13,24) & ilo_lfs==2)   // 12 to 24 months
		replace ilo_dur_details=6 if (inrange(g4,25,98) & ilo_lfs==2)   // 24 months or more
		replace ilo_dur_details=7 if (g4==99 & ilo_lfs==2)            	// Not elsewhere classified
		replace ilo_dur_details=7 if (ilo_dur_details==. & ilo_lfs==2) 	// Not elsewhere classified
		        lab def ilo_unemp_det 1 "Less than 1 month" 2 "1 month to less than 3 months" 3 "3 months to less than 6 months" ///
									  4 "6 months to less than 12 months" 5 "12 months to less than 24 months" 6 "24 months or more" ///
									  7 "Not elsewhere classified"
			    lab val ilo_dur_details ilo_unemp_det
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

* Comment: No information to be processed.

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu_isco08') 		                   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

* Comment: No information to be processed.

				
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
	   replace ilo_olf_dlma=1 if ((g1==1 | g2==1) & g7==2 & ilo_lfs==3)	// Seeking, not available
       replace ilo_olf_dlma=2 if (g2==2 & g7==1 & ilo_lfs==3)          	// Not seeking, available
	   replace ilo_olf_dlma=3 if (g2==2 & g7!=1 & g6==1 & ilo_lfs==3)	// Not seeking, not available, willing
	   replace ilo_olf_dlma=4 if (g2==2 & g7!=1 & g6!=1 & ilo_lfs==3)	// Not seeking, not available, not willing
       replace ilo_olf_dlma=5 if (ilo_olf_dlma==. & ilo_lfs==3)			// Not classified 
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
		replace ilo_olf_reason=1 if	(inlist(g5,2,3,8,11,12,13) & ilo_lfs==3)		// Labour market
		replace ilo_olf_reason=2 if (inlist(g5,9,10,15,16,17,18,19) & ilo_lfs==3)   // Other labour market reasons
		replace ilo_olf_reason=3 if	(inlist(g5,4,5,6,7) & ilo_lfs==3)     			// Personal/Family-related
		replace ilo_olf_reason=4 if (g5==14 & ilo_lfs==3)							// Does not need/want to work
		replace ilo_olf_reason=5 if (inlist(g5,1,20) & ilo_lfs==3)					// Not elsewhere classified
		replace ilo_olf_reason=5 if (ilo_olf_reason==. & ilo_lfs==3)				// Not elsewhere classified
			    lab def reasons_lab 1 "1 - Labour market" 2 "2 - Other labour market reasons" 3 "3 - Personal / Family-related" ///
				    			    4 "4 - Does not need/want to work" 5 "5 - Not elsewhere classified"
				lab val ilo_olf_reason reasons_lab 
				lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"		

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			      Discouraged job-seekers ('ilo_dis') 		                   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

	gen ilo_dis=1 if (ilo_lfs==3 & g7==1 & ilo_olf_reason==1)
			lab def dis_lab 1 "Discouraged job-seekers"
			lab val ilo_dis dis_lab
			lab var ilo_dis "Discouraged job-seekers"
			
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*  Youth not in education, employment or training (NEETs) ('ilo_neet') 		   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

	gen ilo_neet=1 if (ilo_age_aggregate==2 & ilo_lfs!=1 & ilo_edu_attendance==2)
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
		