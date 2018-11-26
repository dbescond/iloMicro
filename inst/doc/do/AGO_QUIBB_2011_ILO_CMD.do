* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Angola, 2011
* DATASET USED: Angola - InquÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ Ãƒ¢Ã¢â€š¬Ã¢â€ž¢©rito de Indicadores BÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ Ãƒ¢Ã¢â€š¬Ã¢â€ž¢¡sicos de Bem-Estar (QUIBB)  - 2011
* NOTES:
* Authors: ILO / Department of Statistics / DPAU

* Starting Date: 23 August 2017
* Last updated: 08 February 2018
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
global country "AGO"
global source "QUIBB"
global time "2011"
global inputFile "Ficheiro_dos_Individuos.dta"
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

   gen ilo_wgt=.
       replace ilo_wgt=ponderador_final
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

	gen ilo_geo=q6_area
		lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural"
		lab val ilo_geo ilo_geo_lab
		lab var ilo_geo "Geographical coverage"	


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_sex=b1
		lab def ilo_sex_lab 1 "1 - Male" 2 "2 - Female"
		lab var ilo_sex "Sex"
		lab val ilo_sex ilo_sex_lab

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_age=(2011-b3_ano_nasc)
		replace ilo_age=99 if (ilo_age<0 | ilo_age==.)
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

/* ISCED 11 mapping: based on the mapping developped by UNESCO
					http://glossary.uis.unesco.org/Education/ISCEDMappings/Pages/default.aspx
					http://www.uis.unesco.org/Education/Documents/isced-2011-en.pdf 	*/

* Note that according to the definition, the highest level CONCLUDED is considered.

	gen ilo_edu_isced11=.
		replace ilo_edu_isced11=1 if c4==2  					// No schooling
		replace ilo_edu_isced11=1 if (c5==0 | c5==20)	 		// No schooling
		replace ilo_edu_isced11=2 if inrange(c5,1,5) 	 		// Early childhood education
		replace ilo_edu_isced11=3 if inrange(c5,6,8)	  		// Primary education
		replace ilo_edu_isced11=4 if inrange(c5,9,11)	  		// Lower secondary education
		replace ilo_edu_isced11=5 if inrange(c5,12,13)      	// Upper secondary education
		* replace ilo_edu_isced11=6 				 			// Post-secondary non-tertiary
		replace ilo_edu_isced11=8 if inrange(c5,14,18)			// Bachelor or equivalent
		replace ilo_edu_isced11=9 if c5==19     				// Master's or equivalent level
		replace ilo_edu_isced11=11 if ilo_edu_isced11==.		// Not elsewhere classified
			label def isced_11_lab 1 "X - No schooling" 2 "0 - Early childhood education" 3 "1 - Primary education" 4 "2 - Lower secondary education" ///
							5 "3 - Upper secondary education" 6 "4 - Post-secondary non-tertiary education" 7 "5 - Short-cycle tertiary education" ///
							8 "6 - Bachelor's or equivalent level" 9 "7 - Master's or equivalent level" 10 "8 - Doctoral or equivalent level" 11 "9 - Not elsewhere classified"
			label val ilo_edu_isced11 isced_11_lab
			lab var ilo_edu_isced11 "Education (ISCED 11)"

		
	gen ilo_edu_aggregate=.
		replace ilo_edu_aggregate=1 if inlist(ilo_edu_isced11,1,2)  	// Less than basic
		replace ilo_edu_aggregate=2 if inlist(ilo_edu_isced11,3,4)		// Basic
		replace ilo_edu_aggregate=3 if inlist(ilo_edu_isced11,5,6)		// Intermediate
		replace ilo_edu_aggregate=4 if inrange(ilo_edu_isced11,7,10)	// Advanced
		replace ilo_edu_aggregate=5 if ilo_edu_isced11==11				// Level not stated
			label def edu_aggr_lab 1 "1 - Less than basic" 2 "2 - Basic" 3 "3 - Intermediate" 4 "4 - Advanced" 5 "5 - Level not stated"
			label val ilo_edu_aggregate edu_aggr_lab
			label var ilo_edu_aggregate "Education (Aggregate levels)"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education attendance ('ilo_edu_attendance')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_edu_attendance=.
		replace ilo_edu_attendance=1 if c2==1
		replace ilo_edu_attendance=2 if c2==2
		replace ilo_edu_attendance=3 if ilo_edu_attendance==.
				lab def edu_attendance_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
				lab val ilo_edu_attendance edu_attendance_lab
				lab var ilo_edu_attendance "Education (Attendance)"

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			           Marital status ('ilo_mrts') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: Only the aggregated variable has been computed because the original variable (b4) has married/union in the same category. 
**         Furthermore, if we compute the detailed variable, there are only cases in the categories of single and widowed, with 72.03% of people not classified.
 /*
	* Detailed
	gen ilo_mrts_details=.
	    replace ilo_mrts_details=1 if  b4==1                                         // Single
		*replace ilo_mrts_details=2 if                                               // Married
		*replace ilo_mrts_details=3 if                                               // Union / cohabiting
		replace ilo_mrts_details=4 if b4==5                                          // Widowed
		replace ilo_mrts_details=5 if inlist(b4==3,4)                                // Divorced / separated
		replace ilo_mrts_details=6 if ilo_mrts_details==.			                 // Not elsewhere classified
		        label define label_mrts_details 1 "1 - Single" 2 "2 - Married" 3 "3 - Union / cohabiting" ///
				                                4 "4 - Widowed" 5 "5 - Divorced / separated" 6 "6 - Not elsewhere classified"
		        label values ilo_mrts_details label_mrts_details
		        lab var ilo_mrts_details "Marital status"
	 */
	
 * Aggregate
	gen ilo_mrts_aggregate=.
	    replace ilo_mrts_aggregate=1 if inlist(b4,1,3,4,5)                                   // Single / Widowed / Divorced / Separated
		replace ilo_mrts_aggregate=2 if b4==2                                   // Married / Union / Cohabiting
		replace ilo_mrts_aggregate=3 if ilo_mrts_aggregate==. 			        // Not elsewhere classified
		        label define label_mrts_aggregate 1 "1 - Single / Widowed / Divorced / Separated" 2 "2 - Married / Union / Cohabiting" 3 "3 - Not elsewhere classified"
		        label values ilo_mrts_aggregate label_mrts_aggregate
		        lab var ilo_mrts_aggregate "Marital status (Aggregate levels)"						
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Disability status ('ilo_dsb')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

* Comment: No information


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
		replace ilo_wap=1 if ilo_age>=15 & ilo_age!=.
			label def ilo_wap_lab 1 "Working age population"
			label val ilo_wap ilo_wap_lab
			label var ilo_wap "Working age population"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Labour Force Status ('ilo_lfs')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: Employment is defined with questions D1 to D4. Unemployment with questions D5 and D6. 

	gen ilo_lfs=.
	    replace ilo_lfs=1 if (d1==1 | d2==1 | d3==1 | d4==1) & ilo_wap==1   // Employed
		replace ilo_lfs=2 if ilo_lfs!=1 & d5==1 & d6==1 & ilo_wap==1  		// Unemployed 
		replace ilo_lfs=3 if !inlist(ilo_lfs,1,2) & ilo_wap==1      		// Outside the labour force
		    label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside the Labour Force"
			label value ilo_lfs label_ilo_lfs
			label var ilo_lfs "Labour Force Status"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

    gen ilo_mjh=.
		replace ilo_mjh=1 if (d38==2 & ilo_lfs==1)
		replace ilo_mjh=2 if (d38==1 & ilo_lfs==1)
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

	* Detailed categories:
		gen ilo_job1_ste_icse93=.
			replace ilo_job1_ste_icse93=1 if (inlist(d22,4,5,6,8,9,10) & ilo_lfs==1)	// Employees
			replace ilo_job1_ste_icse93=2 if (d22==3 & ilo_lfs==1)	            		// Employers
			replace ilo_job1_ste_icse93=3 if (inlist(d22,1,11) & ilo_lfs==1)      		// Own-account workers
			replace ilo_job1_ste_icse93=4 if (d22==7 & ilo_lfs==1)                		// Members of producersÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢¢ÃƒÆ’Ã†â€™¢ÃƒÆ’¢Ãƒ¢Ã¢â‚¬Å¡¬Ãƒâ€¦¡¬ÃƒÆ’Ã†â€™¢ÃƒÆ’¢Ãƒ¢Ã¢â‚¬Å¡¬Ãƒâ€¦¾¢ cooperatives
			replace ilo_job1_ste_icse93=5 if (d22==2 & ilo_lfs==1)	            		// Contributing family workers
			replace ilo_job1_ste_icse93=6 if (ilo_job1_ste_icse93==. & ilo_lfs==1)  	// Not classifiable
				label def label_ilo_ste_icse93 1 "1 - Employees" 2 "2 - Employers" 3 "3 - Own-account workers" ///                      
											   4 "4 - Members of producers cooperatives" 5 "5 - Contributing family workers" ///
											   6 "6 - Workers not classifiable by status"
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

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen indu_code_prim=d19 if (ilo_lfs==1)
	gen indu_code_sec=d39 if (ilo_lfs==1 & ilo_mjh==2)
		
	 

		
		* Primary activity
		
		gen ilo_job1_eco_isic4=.
			replace ilo_job1_eco_isic4=1 if inrange(indu_code_prim,11,51)
			replace ilo_job1_eco_isic4=2 if inrange(indu_code_prim,111,142)
			replace ilo_job1_eco_isic4=3 if inrange(indu_code_prim,151,372)
			replace ilo_job1_eco_isic4=4 if inrange(indu_code_prim,401,404)
			replace ilo_job1_eco_isic4=5 if inrange(indu_code_prim,410,412)
			replace ilo_job1_eco_isic4=6 if inrange(indu_code_prim,451,456)
			replace ilo_job1_eco_isic4=7 if inrange(indu_code_prim,501,527)
			replace ilo_job1_eco_isic4=8 if inrange(indu_code_prim,601,631)
			replace ilo_job1_eco_isic4=9 if inrange(indu_code_prim,550,555)
			replace ilo_job1_eco_isic4=10 if inrange(indu_code_prim,640,650)
			replace ilo_job1_eco_isic4=11 if inrange(indu_code_prim,650,680)
			replace ilo_job1_eco_isic4=12 if inrange(indu_code_prim,700,710)
			replace ilo_job1_eco_isic4=13 if inrange(indu_code_prim,711,735)
			replace ilo_job1_eco_isic4=14 if inrange(indu_code_prim,740,749)
			replace ilo_job1_eco_isic4=15 if inrange(indu_code_prim,750,760)
			replace ilo_job1_eco_isic4=16 if inrange(indu_code_prim,800,810)
			replace ilo_job1_eco_isic4=17 if inrange(indu_code_prim,850,919)
			replace ilo_job1_eco_isic4=18 if inrange(indu_code_prim,920,929)
			replace ilo_job1_eco_isic4=19 if inrange(indu_code_prim,930,940)
			replace ilo_job1_eco_isic4=20 if inrange(indu_code_prim,950,960)
			replace ilo_job1_eco_isic4=21 if inrange(indu_code_prim,990,999)
			replace ilo_job1_eco_isic4=22 if indu_code_prim==. & ilo_lfs==1 
			replace ilo_job1_eco_isic4=. if ilo_lfs!=1
		        lab def eco_isic4_1digit 1 "A - Agriculture, forestry and fishing"	2 "B - Mining and quarrying"	3 "C - Manufacturing"	4 "D - Electricity, gas, steam and air conditioning supply" ///
                                         5 "E - Water supply; sewerage, waste management and remediation activities"	6 "F - Construction"	7 "G - Wholesale and retail trade; repair of motor vehicles and motorcycles"	8 "H - Transportation and storage" ///
                                         9 "I - Accommodation and food service activities"	10 "J - Information and communication"	11 "K - Financial and insurance activities"	12 "L - Real estate activities" ///
                                         13 "M - Professional, scientific and technical activities"	14 "N - Administrative and support service activities"	15 "O - Public administration and defence; compulsory social security"	16 "P - Education" ///
                                         17 "Q - Human health and social work activities"	18 "R - Arts, entertainment and recreation"	19 "S - Other service activities"	20 "T - Activities of households as employers; undifferentiated goods- and services-producing activities of households for own use" ///
                                         21 "U - Activities of extraterritorial organizations and bodies"	22 "X - Not elsewhere classified"		
  	  		    lab val ilo_job1_eco_isic4 eco_isic4_1digit
			    lab var ilo_job1_eco_isic4 "Economic activity (ISIC Rev. 4) - main job"
				
		* Secondary activity
		
		gen ilo_job2_eco_isic4=.
			replace ilo_job2_eco_isic4=1 if inrange(indu_code_sec,11,51)
			replace ilo_job2_eco_isic4=2 if inrange(indu_code_sec,111,142)
			replace ilo_job2_eco_isic4=3 if inrange(indu_code_sec,151,372)
			replace ilo_job2_eco_isic4=4 if inrange(indu_code_sec,401,404)
			replace ilo_job2_eco_isic4=5 if inrange(indu_code_sec,410,412)
			replace ilo_job2_eco_isic4=6 if inrange(indu_code_sec,451,456)
			replace ilo_job2_eco_isic4=7 if inrange(indu_code_sec,501,527)
			replace ilo_job2_eco_isic4=8 if inrange(indu_code_sec,601,631)
			replace ilo_job2_eco_isic4=9 if inrange(indu_code_sec,550,555)
			replace ilo_job2_eco_isic4=10 if inrange(indu_code_sec,640,650)
			replace ilo_job2_eco_isic4=11 if inrange(indu_code_sec,650,680)
			replace ilo_job2_eco_isic4=12 if inrange(indu_code_sec,700,710)
			replace ilo_job2_eco_isic4=13 if inrange(indu_code_sec,711,735)
			replace ilo_job2_eco_isic4=14 if inrange(indu_code_sec,740,749)
			replace ilo_job2_eco_isic4=15 if inrange(indu_code_sec,750,760)
			replace ilo_job2_eco_isic4=16 if inrange(indu_code_sec,800,810)
			replace ilo_job2_eco_isic4=17 if inrange(indu_code_sec,850,919)
			replace ilo_job2_eco_isic4=18 if inrange(indu_code_sec,920,929)
			replace ilo_job2_eco_isic4=19 if inrange(indu_code_sec,930,940)
			replace ilo_job2_eco_isic4=20 if inrange(indu_code_sec,950,960)
			replace ilo_job2_eco_isic4=21 if inrange(indu_code_sec,990,999)
			replace ilo_job2_eco_isic4=22 if indu_code_sec==. & ilo_lfs==1 & ilo_mjh==2
					replace ilo_job2_eco_isic4=. if ilo_lfs!=1 & ilo_mjh!=2
                * labels already defined for main job
		        lab val ilo_job2_eco_isic4 eco_isic4_1digit
			    lab var ilo_job2_eco_isic4 "Economic activity (ISIC Rev. 4) - second job"
		
		
	* Aggregated level
	
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

* Comment:  ISCO-08 classification used
			
		* One digit level
	
		gen occ_code_prim=int(d21/100) if (ilo_lfs==1)
		gen occ_code_sec=int(d41/100) if (ilo_lfs==1 & ilo_mjh==2)
	
		* Primary activity
		
		gen ilo_job1_ocu_isco08=occ_code_prim
			replace ilo_job1_ocu_isco08=10 if ilo_job1_ocu_isco08==0
			replace ilo_job1_ocu_isco08=11 if ilo_job1_ocu_isco08==. & ilo_lfs==1
			replace ilo_job1_ocu_isco08=. if ilo_lfs!=1
			lab def isco08_1dig_lab 1 "1 - Managers" 2 "2 - Professionals" 3 "3 - Technicians and associate professionals" 4 "4 - Clerical support workers" 5 "5 - Service and sales workers" ///
									6 "6 - Skilled agricultural, forestry and fishery workers" 7 "7 - Craft and related trades workers" 8 "8 - Plant and machine operators, and assemblers" ///
									9 "9 - Elementary occupations" 10 "0 - Armed forces occupations" 11 "X - Not elsewhere classified"
				lab val ilo_job1_ocu_isco08 isco08_1dig_lab
				lab var ilo_job1_ocu_isco08 "Occupation (ISCO-08)"	
			
		* Secondary activity
		
		gen ilo_job2_ocu_isco08=occ_code_sec
			replace ilo_job2_ocu_isco08=10 if ilo_job2_ocu_isco08==0
			replace ilo_job2_ocu_isco08=11 if ilo_job2_ocu_isco08==. & ilo_lfs==1 & ilo_mjh==2
			replace ilo_job2_ocu_isco08=. if ilo_lfs!=1 & ilo_mjh!=2			
			* value labels already defined
				lab val ilo_job2_ocu_isco08 isco08_1dig_lab
				lab var ilo_job2_ocu_isco08 "Occupation (ISCO-08) - secondary occupation"
			
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
				lab var ilo_job1_ocu_aggregate "Occupation (Aggregate)"
				
		* Secondary occupation
		
		gen ilo_job2_ocu_aggregate=.
			replace ilo_job2_ocu_aggregate=1 if inrange(ilo_job2_ocu_isco08,1,3)
			replace ilo_job2_ocu_aggregate=2 if inlist(ilo_job2_ocu_isco08,4,5)
			replace ilo_job2_ocu_aggregate=3 if inlist(ilo_job2_ocu_isco08,6,7)
			replace ilo_job2_ocu_aggregate=4 if ilo_job2_ocu_isco08==8
			replace ilo_job2_ocu_aggregate=5 if ilo_job2_ocu_isco08==9
			replace ilo_job2_ocu_aggregate=6 if ilo_job2_ocu_isco08==10
			replace ilo_job2_ocu_aggregate=7 if ilo_job2_ocu_isco08==11
				* value labels already defined
				lab val ilo_job2_ocu_aggregate ocu_aggr_lab
				lab var ilo_job2_ocu_aggregate "Occupation (Aggregate) in secondary job"
				
		* Skill level
	
		* Primary occupation
	
		gen ilo_job1_ocu_skill=.
			replace ilo_job1_ocu_skill=1 if ilo_job1_ocu_isco08==9
			replace ilo_job1_ocu_skill=2 if inlist(ilo_job1_ocu_isco08,4,5,6,7,8)
			replace ilo_job1_ocu_skill=3 if inlist(ilo_job1_ocu_isco08,1,2,3)
			replace ilo_job1_ocu_skill=4 if inlist(ilo_job1_ocu_isco08,10,11)
				lab def ocu_skill_lab 1 "1 - Skill level 1 (low)" 2 "2 - Skill level 2 (medium)" 3 "3 - Skill levels 3 and 4 (high)" 4 "4 - Not elsewhere classified"
				lab val ilo_job1_ocu_skill ocu_skill_lab
				lab var ilo_job1_ocu_skill "Occupation (Skill level)"
				
		* Secondary occupation 
		
		gen ilo_job2_ocu_skill=.
			replace ilo_job2_ocu_skill=1 if ilo_job2_ocu_isco08==9
			replace ilo_job2_ocu_skill=2 if inlist(ilo_job2_ocu_isco08,4,5,6,7,8)
			replace ilo_job2_ocu_skill=3 if inlist(ilo_job2_ocu_isco08,1,2,3)
			replace ilo_job2_ocu_skill=4 if inlist(ilo_job2_ocu_isco08,10,11)
				* value label already defined
				lab val ilo_job2_ocu_skill ocu_skill_lab
				lab var ilo_job2_ocu_skill "Occupation (Skill level) in secondary job"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_job1_ins_sector')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

	* Primary occupation
	
	 gen ilo_job1_ins_sector=.
		replace ilo_job1_ins_sector=1 if inlist(d22,4,5,8) & ilo_lfs==1
		replace ilo_job1_ins_sector=2 if ilo_job1_ins_sector!=1 & ilo_lfs==1
		replace ilo_job1_ins_sector=. if ilo_lfs!=1
			lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
			lab values ilo_job1_ins_sector ins_sector_lab
			lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities"	
			
	* Secondary occupation
	
	gen ilo_job2_ins_sector=.
		replace ilo_job2_ins_sector=1 if inlist(d42,4,5) & ilo_mjh==2
		replace ilo_job2_ins_sector=2 if ilo_job2_ins_sector!=1 & ilo_mjh==2
		replace ilo_job2_ins_sector=. if ilo_mjh!=2
			* value label already defined
			lab values ilo_job2_ins_sector ins_sector_lab
			lab var ilo_job2_ins_sector "Institutional sector (private/public) of economic activities in secondary job"


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job1_job_time')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			

* Comment: No information - Legal working time in Angola is 44 hours per week


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job1_job_contract')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
		
		gen ilo_job1_job_contract=.
			replace ilo_job1_job_contract=1 if d25==1 & ilo_lfs==1
			replace ilo_job1_job_contract=2 if inlist(d25,2,3,4) & ilo_lfs==1
			replace ilo_job1_job_contract=3 if (ilo_job1_job_contract==. & ilo_lfs==1)
					lab def job_contract_lab 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"
					lab val ilo_job1_job_contract job_contract_lab
					lab var ilo_job1_job_contract "Job (Type of contract)"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Informal/Formal economy: Unit of production ('ilo_job1_ife_prod')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: Useful questions:	* D22: Status in employment
								* D22: Institutional sector 
								* [Not asked]: Destination of production 
								* [Not asked]: Bookkeeping
								* D20: Registration						
								* D26: Location of workplace 
								* D24: Size of the establishment					
								* Social security 
									* D37: Social Security
									* [Not asked]: Paid annual leave
									* [Not asked]: Paid sick leave

	
		gen ilo_job1_ife_prod=.
			replace ilo_job1_ife_prod=2 if inlist(d22,4,5,8) | (!inlist(d22,4,5,8) & d20==1)
			replace ilo_job1_ife_prod=3 if (d22==10)
			replace ilo_job1_ife_prod=1 if (ilo_job1_ife_prod==. & ilo_lfs==1)
			replace ilo_job1_ife_prod=. if ilo_lfs!=1
				lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 4 "4 - Not elsewhere classified"
				lab val ilo_job1_ife_prod ilo_ife_prod_lab
				lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"			
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Informal/formal economy: Nature of job ('ilo_job1_ife_nature')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

		gen ilo_job1_ife_nature=.
			replace ilo_job1_ife_nature=1 if ilo_job1_ste_icse93==5 | (inlist(ilo_job1_ste_icse93,2,3,4) & inlist(ilo_job1_ife_prod,1,3)) | (inlist(ilo_job1_ste_icse93,1,6) & d37!=1) 
			replace ilo_job1_ife_nature=2 if (inlist(ilo_job1_ste_icse93,1,6) & d37==1) | (inlist(ilo_job1_ste_icse93,2,3,4) & ilo_job1_ife_prod==2)
			replace ilo_job1_ife_nature=. if ilo_lfs!=1
				lab def ife_nature_lab 1 "1 - Persons with informal main job" 2 "2 - Persons with formal main job"
				lab val ilo_job1_ife_nature ife_nature_lab
				lab var ilo_job1_ife_nature "Informal / Formal Economy (Nature of job)"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Hours of work ('ilo_job1_how')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

* Comment: Not feasible - Different hours bands are used
	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Monthly labour related income ('ilo_job1_lri')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
	
	* Generate a variable based on salary scale (average of each category band)
		gen wage=.
			replace wage=0 if d34==0
			replace wage=4500 if d34==1
			replace wage=15000 if d34==2
			replace wage=25000 if d34==3
			replace wage=40000 if d34==4
			replace wage=75000 if d34==5
			replace wage=150000 if d34==6
			replace wage=250000 if d34==7

	* Employees
		gen ilo_job1_lri_ees=.
			replace ilo_job1_lri_ees=wage if (ilo_job1_ste_aggregate==1)
					lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"	
				
	* Self-employed
		gen ilo_job1_lri_slf=.
			replace ilo_job1_lri_slf=wage if (inlist(ilo_job1_ste_icse93,2,3,4,6))
					lab var ilo_job1_lri_slf "Monthly earnings of self-employed in main job"

		drop wage


***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_joball_tru')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

* Comment: No information


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

		gen ilo_cat_une=.
			replace ilo_cat_une=1 if d10==1
			replace ilo_cat_une=2 if d10==2
			replace ilo_cat_une=3 if ilo_lfs==2 & ilo_cat_une==.
			replace ilo_cat_une=. if ilo_lfs!=2
				lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
				lab val ilo_cat_une cat_une_lab
				lab var ilo_cat_une "Category of unemployment"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: Category 6 is included into category 5 for detailed duration.

    * Detailed
		gen ilo_dur_details=.
			replace ilo_dur_details=1 if (d9==1 & ilo_lfs==2)               // Less than 1 month
			replace ilo_dur_details=2 if (d9==2 & ilo_lfs==2)         		// 1-2 months
			replace ilo_dur_details=3 if (d9==3 & ilo_lfs==2)         		// 3-5 months
			replace ilo_dur_details=4 if (d9==4 & ilo_lfs==2)               // 6-11 months
			replace ilo_dur_details=5 if (d9==5 & ilo_lfs==2)				// 12 months and more
			replace ilo_dur_details=7 if (ilo_dur_details==.& ilo_lfs==2)  	// Not elsewhere classified
			        lab def ilo_unemp_det 1 "Less than 1 month" 2 "1 month to less than 3 months" 3 "3 months to less than 6 months" ///
										  4 "6 months to less than 12 months" 5 "12 months to less than 24 months" 6 "24 months or more" ///
										  7 "Not elsewhere classified"
				    lab val ilo_dur_details ilo_unemp_det
				    lab var ilo_dur_details "Duration of unemployment (Details)"

    * Aggregate						
		gen ilo_dur_aggregate=.
			replace ilo_dur_aggregate=1 if (inlist(ilo_dur_details,1,2,3) & ilo_lfs==2)   	// Less than 6 months
			replace ilo_dur_aggregate=2 if (ilo_dur_details==4 & ilo_lfs==2)              	// 6 months to less than 12 months
			replace ilo_dur_aggregate=3 if (inlist(ilo_dur_details,5,6) & ilo_lfs==2)       // 12 months or more
			replace ilo_dur_aggregate=4 if ilo_dur_details==7 & ilo_lfs==2                  // Not elsewhere classified
					lab def ilo_unemp_aggr 1 "Less than 6 months" 2 "6 months to less than 12 months" 3 "12 months or more" 4 "Not elsewhere classified"
					lab val ilo_dur_aggregate ilo_unemp_aggr
					lab var ilo_dur_aggregate "Duration of unemployment (Aggregate)"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

* Comment: ISIC Rev. 4 classification being used 

	gen preveco_cod=d13 if (ilo_lfs==2 & ilo_cat_une==1)
	
	* Previous economic activity
	
	gen ilo_preveco_isic4=.
		replace ilo_preveco_isic4=1 if inrange(preveco_cod,11,51)
		replace ilo_preveco_isic4=2 if inrange(preveco_cod,111,142)
		replace ilo_preveco_isic4=3 if inrange(preveco_cod,151,372)
		replace ilo_preveco_isic4=4 if inrange(preveco_cod,401,404)
		replace ilo_preveco_isic4=5 if inrange(preveco_cod,410,412)
		replace ilo_preveco_isic4=6 if inrange(preveco_cod,451,456)
		replace ilo_preveco_isic4=7 if inrange(preveco_cod,501,527)
		replace ilo_preveco_isic4=8 if inrange(preveco_cod,601,631)
		replace ilo_preveco_isic4=9 if inrange(preveco_cod,550,555)
		replace ilo_preveco_isic4=10 if inrange(preveco_cod,640,650)
		replace ilo_preveco_isic4=11 if inrange(preveco_cod,650,680)
		replace ilo_preveco_isic4=12 if inrange(preveco_cod,700,710)
		replace ilo_preveco_isic4=13 if inrange(preveco_cod,711,735)
		replace ilo_preveco_isic4=14 if inrange(preveco_cod,740,749)
		replace ilo_preveco_isic4=15 if inrange(preveco_cod,750,760)
		replace ilo_preveco_isic4=16 if inrange(preveco_cod,800,810)
		replace ilo_preveco_isic4=17 if inrange(preveco_cod,850,919)
		replace ilo_preveco_isic4=18 if inrange(preveco_cod,920,929)
		replace ilo_preveco_isic4=19 if inrange(preveco_cod,930,940)
		replace ilo_preveco_isic4=20 if inrange(preveco_cod,950,960)
		replace ilo_preveco_isic4=21 if inrange(preveco_cod,990,999)
		replace ilo_preveco_isic4=22 if preveco_cod==. & ilo_cat_une==1 & ilo_lfs==2
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
			* value label already defined above			
			lab val ilo_preveco_aggregate eco_aggr_lab
			lab var ilo_preveco_aggregate "Previous economic activity (Aggregate)" 
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu_isco08')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
		
* Comment: ISCO-08 classification being used

	* Reduce it to 1-digit level 
	
	gen prevocu_cod=int(d14/100) if (ilo_lfs==2 & ilo_cat_une==1)
	
	gen ilo_prevocu_isco08=prevocu_cod
		replace ilo_prevocu_isco08=10 if ilo_prevocu_isco08==0
		replace ilo_prevocu_isco08=11 if ilo_prevocu_isco08==. & ilo_cat_une==1 & ilo_lfs==2
		* value label already defined
		lab val ilo_prevocu_isco08 isco08_1dig_lab
		lab var ilo_prevocu_isco08 "Previous occupation (ISCO-08)"
			
	* Aggregate level 
	
	gen ilo_prevocu_aggregate=.
		replace ilo_prevocu_aggregate=1 if inrange(ilo_prevocu_isco08,1,3)
		replace ilo_prevocu_aggregate=2 if inlist(ilo_prevocu_isco08,4,5)
		replace ilo_prevocu_aggregate=3 if inlist(ilo_prevocu_isco08,6,7)
		replace ilo_prevocu_aggregate=4 if ilo_prevocu_isco08==8
		replace ilo_prevocu_aggregate=5 if ilo_prevocu_isco08==9
		replace ilo_prevocu_aggregate=6 if ilo_prevocu_isco08==10
		replace ilo_prevocu_aggregate=7 if ilo_prevocu_isco08==11
			* value label already defined
			lab val ilo_prevocu_aggregate ocu_aggr_lab
			lab var ilo_prevocu_aggregate "Previous occupation (Aggregate)"	
			
	* Skill level
	
		gen ilo_prevocu_skill=.
			replace ilo_prevocu_skill=1 if ilo_prevocu_isco08==9
			replace ilo_prevocu_skill=2 if inlist(ilo_prevocu_isco08,4,5,6,7,8)
			replace ilo_prevocu_skill=3 if inlist(ilo_prevocu_isco08,1,2,3)
			replace ilo_prevocu_skill=4 if inlist(ilo_prevocu_isco08,10,11)
				* value label already defined
				lab val ilo_prevocu_skill ocu_skill_lab
				lab var ilo_prevocu_skill "Occupation (Skill level)"


***********************************************************************************************
*			PART 3.4. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		.

* Comment: No question on willingness to work - Only categories 1, 2 and 5 can be defined. 

	gen ilo_olf_dlma=.
		replace ilo_olf_dlma=1 if d5==2 & d6==1 & ilo_lfs==3
		replace ilo_olf_dlma=2 if d5==1 & d6==2 & ilo_lfs==3
		* replace ilo_olf_dlma=3 if ilo_olf_dlma!=1 & ilo_olf_dlma!=2 & ilo_lfs==3
		* replace ilo_olf_dlma=4 if ilo_olf_dlma!=1 & ilo_olf_dlma!=2 & ilo_lfs==3
		replace ilo_olf_dlma=5 if ilo_olf_dlma==. & ilo_lfs==3
		replace ilo_olf_dlma=. if ilo_lfs!=3
			lab def lab_olf_dlma 1 "1 - Seeking, not available (Unavailable jobseekers)" 2 "2 - Not seeking, available (Available potential jobseekers)" ///
						3 "3 - Not seeking, not available, willing (Willing non-jobseekers)" 4 "4 - Not seeking, not available, not willing" 5 "5 - Not elsewhere classified"
			lab val ilo_olf_dlma lab_olf_dlma
			lab var ilo_olf_dlma "Labour market attachment (Degree of)" 

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reason for not seeking job ('ilo_olf_reason')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

	gen ilo_olf_reason=.
		replace ilo_olf_reason=1 if inlist(d7,4,5,6,12,13)
		replace ilo_olf_reason=2 if inlist(d7,1,14)
		replace ilo_olf_reason=3 if inlist(d7,2,3,7,8,9,11)
		replace ilo_olf_reason=4 if inlist(d7,10)
		replace ilo_olf_reason=5 if ilo_olf_reason==. & ilo_lfs==3
			replace ilo_olf_reason=. if ilo_lfs!=3
			lab def lab_olf_reason 1 "1 - Labour market (Discouraged)" 2 "Other labour market reasons" 3 "3 - Personal/Family-related"  4 "4 - Does not need/want to work" 5 "5 - Not elsewhere classified"
			lab val ilo_olf_reason lab_olf_reason
			lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seeker ('ilo_dis')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

	gen ilo_dis=1 if ilo_lfs==3 & d5==1 & ilo_olf_reason==1
		lab def ilo_dis_lab 1 "Discouraged job-seekers" 
		lab val ilo_dis ilo_dis_lab
		lab var ilo_dis "Discouraged job-seekers"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training ('ilo_neet')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_neet=.
		replace ilo_neet=1 if inrange(ilo_age,15,24) & ilo_lfs!=1 & inlist(ilo_edu_attendance,2,3)
			lab def ilo_neet_lab 1 "Youth not in education, employment or training"
			lab val ilo_neet ilo_neet_lab
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
		
		/* Only age bands used */
		drop ilo_age
		drop if ilo_sex==. 
		
		compress 
		
		/*Save dataset including original and ilo variables*/
	
		save ${country}_${source}_${time}_FULL,  replace		

		/* Save file only containing ilo_* variables*/
	
		keep ilo*

		save ${country}_${source}_${time}_ILO, replace

		
