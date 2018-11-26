 * TITLE OF DO FILE: ILO Microdata Preprocessing code template - Spain EPA
* DATASET USED: Spain LFS 2017Q2
* NOTES:
* Authors: ILO / Department of Statistics / DPAU

* Starting Date: 03/10/2017
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
global country "ESP"
global source "EPA"
global time "2017Q2"
global inputFile "datos_2t17.dta"
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
*	rename *, upper  


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

destring FACTOREL, replace

   gen ilo_wgt=.
      	   replace ilo_wgt = FACTOREL / 100
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

** - Impossible to create from the EPA's variables. 
** - The smallest geographical unit given by the EPA is province.
 


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	
destring SEXO1, replace


recode SEXO1 (1=1) (6=2), gen (sexo)


	
	gen ilo_sex = sexo
		lab def ilo_sex_lab 1 "1 - Male" 2 "2 - Female"
		lab var ilo_sex "Sex"
		lab val ilo_sex ilo_sex_lab

    

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

*** -- Comment: The age variable in EPA is titled EDAD5 which is given in 5-year groups
*** -- Comment: Therefore the variables that need the variable ilo_age in order of being defined
*** 			are encoded using the variable ilo_age_5yrbands 

destring EDAD5, replace

	*gen ilo_age= 
	 *   lab var ilo_age "Age"



* Age groups

	gen ilo_age_5yrbands =.
		replace ilo_age_5yrbands = 1 if inrange(EDAD5,0,4)
		replace ilo_age_5yrbands = 2 if inrange(EDAD5,5,9)
		replace ilo_age_5yrbands = 3 if inrange(EDAD5,10,14)
		replace ilo_age_5yrbands = 4 if inrange(EDAD5,15,19)
		replace ilo_age_5yrbands = 5 if inrange(EDAD5,20,24)
		replace ilo_age_5yrbands = 6 if inrange(EDAD5,25,29)
		replace ilo_age_5yrbands = 7 if inrange(EDAD5,30,34)
		replace ilo_age_5yrbands = 8 if inrange(EDAD5,35,39)
		replace ilo_age_5yrbands = 9 if inrange(EDAD5,40,44)
		replace ilo_age_5yrbands = 10 if inrange(EDAD5,45,49)
		replace ilo_age_5yrbands = 11 if inrange(EDAD5,50,54)
		replace ilo_age_5yrbands = 12 if inrange(EDAD5,55,59)
		replace ilo_age_5yrbands = 13 if inrange(EDAD5,60,64)
		replace ilo_age_5yrbands = 14 if EDAD5 >= 65 & EDAD5 != .
			    lab def age_by5_lab 1 "0-4" 2 "5-9" 3 "10-14" 4 "15-19" 5 "20-24" 6 "25-29" ///
								    7 "30-34" 8 "35-39" 9 "40-44" 10 "45-49" 11 "50-54" 12 "55-59" ///
								    13 "60-64" 14 "65+"
			    lab val ilo_age_5yrbands age_by5_lab
			    lab var ilo_age_5yrbands "Age (5-year age bands)"
			
			
			
	gen ilo_age_10yrbands = .
		replace ilo_age_10yrbands = 1 if inrange(EDAD5,0,14)
		replace ilo_age_10yrbands = 2 if inrange(EDAD5,15,24)
		replace ilo_age_10yrbands = 3 if inrange(EDAD5,25,34)
		replace ilo_age_10yrbands = 4 if inrange(EDAD5,35,44)
		replace ilo_age_10yrbands = 5 if inrange(EDAD5,45,54)
		replace ilo_age_10yrbands = 6 if inrange(EDAD5,55,64)
		replace ilo_age_10yrbands = 7 if EDAD5 >= 65 & EDAD5 != .
			    lab def age_by10_lab 1 "<15" 2 "15-24" 3 "25-34" 4 "35-44" 5 "45-54" 6 "55-64" 7 "65+"
			    lab val ilo_age_10yrbands age_by10_lab
			    lab var ilo_age_10yrbands "Age (10-year age bands)"
			
	gen ilo_age_aggregate = .
		replace ilo_age_aggregate = 1 if inrange(EDAD5,0,14)
		replace ilo_age_aggregate = 2 if inrange(EDAD5,15,24)
		replace ilo_age_aggregate = 3 if inrange(EDAD5,25,54)
		replace ilo_age_aggregate = 4 if inrange(EDAD5,55,64)
		replace ilo_age_aggregate = 5 if EDAD5 >= 65 & EDAD5 != .
		    	lab def age_aggr_lab 1 "<15" 2 "15-24" 3 "25-54" 4 "55-64" 5 "65+"
			    lab val ilo_age_aggregate age_aggr_lab
			    lab var ilo_age_aggregate "Age (Aggregate)"
	


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education ('ilo_edu')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comments: --  

*** Since 2005 the classification followed is CNED-2014 ("ClasificaciÃƒ³n Nacional de la EducaciÃƒ³n")
*** Correspondence tables between CNED-2014 and ISCED-11 (in Spanish): http://www.ine.es/dyngs/INEbase/en/operacion.htm?c=Estadistica_C&cid=1254736177034&menu=ultiDatos&idp=1254735976614

*** Only the aggregate variable is done here due to the way of presenting the information that EPA gives in this case. 

 
* gen ilo_edu_isced11 = .
	  

		
*** Aggregate levels. 


gen ilo_edu_aggregate = .
		replace ilo_edu_aggregate = 1 if inlist(NFORMA_2_,"AN","P1")			// Less than basic
		replace ilo_edu_aggregate = 2 if inlist(NFORMA_2_,"P2","S1")		   // Basic
		replace ilo_edu_aggregate = 3 if inlist(NFORMA_2_,"SG","SP")	       // Intermediate
		replace ilo_edu_aggregate = 4 if  NFORMA_2_=="SU"				       // Advanced
		replace ilo_edu_aggregate = 5 if NFORMA_2_==""					       // Level not stated
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

** Comments: - Since the EPA 2005 there are two variables that indicate current enrolment >> CURSR - it refers to official studies and CURSNR >> for non-official studies.  
	

	destring CURSR, replace
	destring CURSNR, replace

	
		gen ilo_edu_attendance = .
		replace ilo_edu_attendance = 1 if inlist(CURSR,1,2) | inlist(CURSNR,1,2)                         // 1 - Attending
		replace ilo_edu_attendance = 2 if CURSR== 3 & CURSNR==3                                       //  2 - Not attending
	    replace ilo_edu_attendance = 3 if ilo_edu_attendance == .                                        // 3 - Not elsewhere classified
		lab def edu_attendance_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
		lab val ilo_edu_attendance edu_attendance_lab
		lab var ilo_edu_attendance "Education (Attendance)"

		
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			           Marital status ('ilo_mrts') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: marital status is only asked to the population aged 16 and above. 

destring ECIV1, replace
	
	* Detailed
	gen ilo_mrts_details=.
	    replace ilo_mrts_details=1 if ECIV1==1                                  // Single
		replace ilo_mrts_details=2 if ECIV1==2                                  // Married
		*replace ilo_mrts_details=3 if                                          // Union / cohabiting
		replace ilo_mrts_details=4 if ECIV1==3                                  // Widowed
		replace ilo_mrts_details=5 if ECIV1==4                                  // Divorced / separated
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

*** There is no variable in the questionnaire to identify the disability status of the person
		
*** INE studies the employment of persons with disabilities in the statistical operation 
*** title "Employment of persons with disabilities". This operation is the result of a collaboration
*** among the INE, the IMSERSO, the Directorate General for the Coordination of Sectoral Policy for Disabilities, 
*** the Spanish Committee of Disabled People's Representatives (CERMI) and the ONCE Foundation. 		




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

*** Comment: -- In Spain, the working age population is defined from 16 years. 
*** 		-- The modules of the questionnaire related to the labour market are only asked to individuals
***			-- aged over 15 years. 

	gen ilo_wap =.
		replace ilo_wap = 1 if ilo_age_5yrbands >= 4 & ilo_age_5yrbands !=.	// Working age population
			label def ilo_wap_lab 1 "Working age population"
			label val ilo_wap ilo_wap_lab
			label var ilo_wap "Working age population"
			
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Labour Force Status ('ilo_lfs')   
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

** - The definitions used by the EPA are based on the recommendations adopted by ILO. 
** - However the WAP in Spain starts in 16 years, therefore all the questions related to economic situation
** - are asked to persons aged over 15.

destring TRAREM, replace
destring AYUDFA, replace
destring AUSENT, replace
destring RZNOTB, replace
destring VINCUL, replace
destring BUSCA, replace
destring DISP, replace
destring NUEVEM, replace
destring FOBACT, replace


gen ilo_lfs =.

		** EMPLOYED
	    replace ilo_lfs = 1 if TRAREM == 1 & ilo_wap == 1         		// Employed (persons at work)
		replace ilo_lfs = 1 if AYUDFA == 1 & ilo_wap == 1        		   // Employed (family business)
		replace ilo_lfs = 1 if AUSENT == 1 & !inlist(RZNOTB,7,8) & !inlist(VINCUL,6,7) & ilo_wap == 1  //Employed (absent)****
		
		
		** UNEMPLOYED
		replace ilo_lfs = 2 if ilo_lfs != 1 &  (BUSCA == 1 & FOBACT==1)  & DISP==1 & ilo_wap == 1 // Not in employment, seeking (actively), available
		replace ilo_lfs = 2 if ilo_lfs != 1 &  DISP==1 & BUSCA == 6 & NUEVEM==1  & ilo_wap == 1 // Not in employment, available, not seeking because starting a new job in less than 3 months (future job starters)
		
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
 
destring TRAPLU, replace

gen  ilo_mjh = .

** - 1. One job only

	replace ilo_mjh = 1 if inlist(TRAPLU ,6,0,.) & ilo_lfs == 1

** - 2. More than one job

	replace ilo_mjh = 2 if TRAPLU == 1 & ilo_lfs == 1
	
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

destring SITU, replace

**** MAIN JOB

* Detailed categories:

		gen ilo_job1_ste_icse93 = .
		
			replace ilo_job1_ste_icse93 = 1 if inlist(SITU,7,8) & ilo_lfs == 1   	// Employees
			
			replace ilo_job1_ste_icse93 = 2 if SITU == 1 & ilo_lfs==1	            // Employers
			
			replace ilo_job1_ste_icse93 = 3 if SITU == 3 & ilo_lfs==1      			// Own-account workers
			
			replace ilo_job1_ste_icse93 = 4 if SITU == 5 & ilo_lfs==1      			// Members of producers cooperatives

			replace ilo_job1_ste_icse93 = 5 if SITU == 6 & ilo_lfs==1	            // Contributing family workers
			
			replace ilo_job1_ste_icse93 = 6 if SITU == 9 & ilo_lfs==1               // Workers not classifiable by status
			
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

				
destring SITPLU, replace

				
**** SECOND JOB

* Detailed categories:

		gen ilo_job2_ste_icse93 = .
		
			replace ilo_job2_ste_icse93 = 1 if inlist(SITPLU,7,8) & ilo_mjh == 2   	    // Employees
			
			replace ilo_job2_ste_icse93 = 2 if SITPLU == 1 & ilo_mjh == 2 	            // Employers
			
			replace ilo_job2_ste_icse93 = 3 if SITPLU == 3 & ilo_mjh == 2       		// Own-account workers
			
			replace ilo_job2_ste_icse93 = 4 if SITPLU == 5 & ilo_mjh == 2       		// Members of producersÃ¢â‚¬â„¢ cooperatives

			replace ilo_job2_ste_icse93 = 5 if SITPLU == 6 & ilo_mjh == 2             // Contributing family workers
			
			replace ilo_job2_ste_icse93 = 6 if SITPLU == 9 & ilo_mjh == 2            // Workers not classifiable by status
			
				
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


* Comment: - the national economic activity classification is CNAE
		
		*  - CNAE 2009 (since 2008Q1)
		
		*	- CNAE has the same divisions as NACE, but with more classes to define special national activities
		*	- EPA microdata groups several divisions in a same section, therefore it is not possible to do 
		*	- the variable ilo_job_eco_isic4 at a disaggregated level.

		
		
***** MAIN JOB *****

destring ACT11, replace
	
		
		* ilo_job1_eco_isic4    ***** (not possible)
			
			
	* Classification on an aggregate level
	
		* Primary activity

		
		gen ilo_job1_eco_aggregate = .
			replace ilo_job1_eco_aggregate = 1 if ACT11 == 0 & ilo_lfs == 1				// 1 - Agriculture
			replace ilo_job1_eco_aggregate = 2 if inlist(ACT11,1,3) & ilo_lfs == 1			// 2 - Manufacturing
			replace ilo_job1_eco_aggregate = 3 if ACT11 == 4 & ilo_lfs == 1					// 3 - Construction
			replace ilo_job1_eco_aggregate = 4 if ACT11 == 2 & ilo_lfs == 1	           	// 4 - Mining and quarrying; Electricity, gas and water supply
			replace ilo_job1_eco_aggregate = 5 if inrange(ACT11,5,7) & ilo_lfs == 1	    // 5 - Market Services (Trade; Transportation; Accommodation and food; and Business and administrative services)
			replace ilo_job1_eco_aggregate = 6 if inlist(ACT11,8,9) & ilo_lfs == 1		 	// 6 - Non-market services (Public administration; Community, social and other services and activities)
			replace ilo_job1_eco_aggregate = 7 if ACT11 == . & ilo_lfs == 1		    // 7 - Not classifiable by economic activity
				lab def eco_aggr_lab 1 "1 - Agriculture" 2 "2 - Manufacturing" 3 "3 - Construction" 4 "4 - Mining and quarrying; Electricity, gas and water supply" ///
									5 "5 - Market Services (Trade; Transportation; Accommodation and food; and Business and administrative services)"  ///
									6 "6 - Non-market services (Public administration; Community, social and other services and activities)"  ///
									7 "7 - Not classifiable by economic activity"					
				lab val ilo_job1_eco_aggregate eco_aggr_lab
				lab var ilo_job1_eco_aggregate "Economic activity (Aggregate)"		
						
				
***** SECOND JOB *****
				

destring ACTPLU, replace
	
		
		* ilo_job2_eco_isic4   ***** (not possible)
			
			
	* Classification on an aggregate level
	
		
		gen ilo_job2_eco_aggregate=.
			replace ilo_job2_eco_aggregate=1 if ACTPLU == 0	 & ilo_mjh	== 2		// 1 - Agriculture
			replace ilo_job2_eco_aggregate=2 if inlist(ACTPLU,1,3) & ilo_mjh	== 2		// 2 - Manufacturing
			replace ilo_job2_eco_aggregate=3 if ACTPLU == 4 & ilo_mjh	== 2				// 3 - Construction
			replace ilo_job2_eco_aggregate=4 if ACTPLU == 2  & ilo_mjh	== 2            	// 4 - Mining and quarrying; Electricity, gas and water supply
			replace ilo_job2_eco_aggregate=5 if inrange(ACTPLU,5,7) & ilo_mjh	== 2	// 5 - Market Services (Trade; Transportation; Accommodation and food; and Business and administrative services)
			replace ilo_job2_eco_aggregate=6 if inlist(ACTPLU,8,9) & ilo_mjh	== 2	 	// 6 - Non-market services (Public administration; Community, social and other services and activities)
			*replace ilo_job2_eco_aggregate=7 if ACTPLU == . & ilo_mhj	== 1 				// 7 - Not classifiable by economic activity
				*lab def eco_aggr_lab 1 "1 - Agriculture" 2 "2 - Manufacturing" 3 "3 - Construction" 4 "4 - Mining and quarrying; Electricity, gas and water supply" ///
								*	5 "5 - Market Services (Trade; Transportation; Accommodation and food; and Business and administrative services)"  ///
								*	6 "6 - Non-market services (Public administration; Community, social and other services and activities)" ///
									*7 "7 - Not classifiable by economic activity"					
				lab val ilo_job2_eco_aggregate eco_aggr_lab
				lab var ilo_job2_eco_aggregate "Economic activity (Aggregate)"		
														
								
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_job1_ocu_isco08')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: - the national occupation classification is CNO 
*            - CNO-11 (Since 2011Q1) >> CNO-2011 has the same major groups as ISCO-08
*			 - CNO-94 (Until 2010Q4) >> CNO-1994 has the same major groups as ISCO-88
		 
		
***** MAIN JOB *****
				

					
if `Y' < 2011 {
				
destring OCUP1, replace
	
	* 1 digit level  

	gen ilo_job1_ocu_isco88 = .
		
		replace ilo_job1_ocu_isco88 = 1 if OCUP1 == 1 & ilo_lfs == 1   // 1 - Legislators, senior officials and managers
		replace ilo_job1_ocu_isco88 = 2 if OCUP1 == 2 & ilo_lfs == 1   // 2 - Professionals
		replace ilo_job1_ocu_isco88 = 3 if OCUP1 == 3 & ilo_lfs == 1   // 3 - Technicians and Associate Professionals
		replace ilo_job1_ocu_isco88 = 4 if OCUP1 == 4 & ilo_lfs == 1   // 4 - Clerks
		replace ilo_job1_ocu_isco88 = 5 if OCUP1 == 5 & ilo_lfs == 1   // 5 - Service workers and shop and market sales workers
		replace ilo_job1_ocu_isco88 = 6 if OCUP1 == 6 & ilo_lfs == 1   // 6 - Skilled agricultural and fishery workers
		replace ilo_job1_ocu_isco88 = 7 if OCUP1 == 7 & ilo_lfs == 1   // 7 - Craft and related trades workers
		replace ilo_job1_ocu_isco88 = 8 if OCUP1 == 8 & ilo_lfs == 1   // 8 - Plant and machine operators and assemblers
		replace ilo_job1_ocu_isco88 = 9 if OCUP1 == 9 & ilo_lfs == 1   // 9 - Elementary Occupations
		replace ilo_job1_ocu_isco88 = 10 if OCUP1 == 0 & ilo_lfs == 1   // 10 - Armed forces
		replace ilo_job1_ocu_isco88 = 11 if OCUP1 == . & ilo_lfs == 1   // 11 - Not elsewhere classified

		 lab def ocu88_1digits 1 "1 - Legislators, senior officials and managers"	2 "2 - Professionals"	3 "3 - Technicians and associate professionals"	4 "4 - Clerks" ///
                                      5 "Service workers and shop and market sales workers"	6 "6 - Skilled agricultural and fishery workers" 7 "7 - Craft and related trades workers"	/// 
						              8 "8 - Plant and machine operators, and assemblers"  9 "9 - Elementary occupations"	10 "0 - Armed forces occupations"	///
						              11 "11 - Not elsewhere classified"	
				lab val ilo_job1_ocu_isco88 ocu88_1digits
				lab var ilo_job1_ocu_isco88 "Occupation (ISCO-88) - main job"
				
				
	* Aggregate
	  gen ilo_job1_ocu_aggregate = .
		  replace ilo_job1_ocu_aggregate = 1 if inrange(ilo_job1_ocu_isco88,1,3) // 1 - Managers, professionals, and technicians
		  replace ilo_job1_ocu_aggregate = 2 if inlist(ilo_job1_ocu_isco88,4,5)	// 2 - Clerical, service and sales workers
		  replace ilo_job1_ocu_aggregate = 3 if inlist(ilo_job1_ocu_isco88,6,7)	// 3 - Skilled agricultural and trades workers
		  replace ilo_job1_ocu_aggregate = 4 if ilo_job1_ocu_isco88 == 8		// 4 - Plant and machine operators, and assemblers
		  replace ilo_job1_ocu_aggregate = 5 if ilo_job1_ocu_isco88 == 9		// 5 - Elementary occupations
		  replace ilo_job1_ocu_aggregate = 6 if ilo_job1_ocu_isco88 == 10		// 6 - Armed forces
		  replace ilo_job1_ocu_aggregate = 7 if ilo_job1_ocu_isco88 == 11		// 7 - Not elsewhere classified
				 lab def ocu_aggr_lab 1 "1 - Managers, professionals, and technicians" 2 "2 - Clerical, service and sales workers" 3 "3 - Skilled agricultural and trades workers" ///
				 					 4 "4 - Plant and machine operators, and assemblers" 5 "5 - Elementary occupations" 6 "6 - Armed forces" 7 "7 - Not elsewhere classified"
			    lab val ilo_job1_ocu_aggregate ocu_aggr_lab
			    lab var ilo_job1_ocu_aggregate "Occupation (Aggregate) - main job"	
		
	  * Skill level
	  gen ilo_job1_ocu_skill = .
		  replace ilo_job1_ocu_skill = 1 if ilo_job1_ocu_isco88 == 9                   // 1 - Skill level 1 (low)
		  replace ilo_job1_ocu_skill = 2 if inrange(ilo_job1_ocu_isco88,4,8)           // 2 - Skill level 2 (medium)
		  replace ilo_job1_ocu_skill=3 if inrange(ilo_job1_ocu_isco88,1,3)             // 3 - Skill levels 3 and 4 (high)
		  replace ilo_job1_ocu_skill=4 if inlist(ilo_job1_ocu_isco88,10,11)            // 4 - Not elsewhere classified
			   	lab def ocu_skill_lab 1 "1 - Skill level 1 (low)" 2 "2 - Skill level 2 (medium)" 3 "3 - Skill levels 3 and 4 (high)" 4 "4 - Not elsewhere classified"
				lab val ilo_job1_ocu_skill ocu_skill_lab
			    lab var ilo_job1_ocu_skill "Occupation (Skill level) - main job"

				
***** SECOND JOB *****
				

destring OCUPLU1, replace
	
	* 1 digit level  

	gen ilo_job2_ocu_isco88 = .
		replace ilo_job2_ocu_isco88 = 1 if OCUPLU1 == 1 & ilo_mjh == 2   // 1 - Legislators, senior officials and managers
		replace ilo_job2_ocu_isco88 = 2 if OCUPLU1 == 2 & ilo_mjh == 2   // 2 - Professionals
		replace ilo_job2_ocu_isco88 = 3 if OCUPLU1 == 3 & ilo_mjh == 2   // 3 - Technicians and Associate Professionals
		replace ilo_job2_ocu_isco88 = 4 if OCUPLU1 == 4 & ilo_mjh == 2   // 4 - Clerks
		replace ilo_job2_ocu_isco88 = 5 if OCUPLU1 == 5 & ilo_mjh == 2   // 5 -  Service workers and shop and market sales workers
		replace ilo_job2_ocu_isco88 = 6 if OCUPLU1 == 6 & ilo_mjh == 2   // 6 - Skilled agricultural and fishery workers
		replace ilo_job2_ocu_isco88 = 7 if OCUPLU1 == 7 & ilo_mjh == 2   // 7 - Craft and related trades workers
		replace ilo_job2_ocu_isco88 = 8 if OCUPLU1 == 8 & ilo_mjh == 2   // 8 - Plant and Machine Operators and Assemblers
		replace ilo_job2_ocu_isco88 = 9 if OCUPLU1 == 9 & ilo_mjh == 2   // 9 - Elementary Occupations
		replace ilo_job2_ocu_isco88 = 10 if OCUPLU1 == 0 & ilo_mjh == 2   // 0 - Armed forces occupations
		replace ilo_job2_ocu_isco88 = 11 if OCUPLU1 == . & ilo_mjh == 2   // 11 - Not elsewhere classified


		lab def ilo_job2_ocu_isco88 1 "1 - Legislators, senior officials and managers" 2 "2 - Professionals" 3 "3 - Technicians and Associate Professionals" 4 "Clerks" ///
									5 "5 -  Service workers and shop and market sales workers"  ///
									6 "6 - Skilled agricultural and fishery workers" 7 "7 - Craft and related trades workers" ///
									8 "8 - Plant and Machine Operators and Assemblers" 9 "9 - Elementary Occupations" ///
									10 "0 - Armed forces occupations" 11 "11 - Not elsewhere classified"
				lab val ilo_job2_ocu_isco88  ocu_isco88_lab
				lab var ilo_job2_ocu_isco88  "Occupation (ISCO-88)"	
								
	* Aggregate
	  gen ilo_job2_ocu_aggregate =.
		  replace ilo_job2_ocu_aggregate = 1 if inrange(ilo_job2_ocu_isco88,1,3)  // 1 - Managers, professionals, and technicians
		  replace ilo_job2_ocu_aggregate = 2 if inlist(ilo_job2_ocu_isco88,4,5)	// 2 - Clerical, service and sales workers
		  replace ilo_job2_ocu_aggregate = 3 if inlist(ilo_job2_ocu_isco88,6,7)	// 3 - Skilled agricultural and trades workers
		  replace ilo_job2_ocu_aggregate = 4 if ilo_job2_ocu_isco88 == 8			// 4 - Plant and machine operators, and assemblers
		  replace ilo_job2_ocu_aggregate = 5 if ilo_job2_ocu_isco88 == 9			// 5 - Elementary occupations
		  replace ilo_job2_ocu_aggregate = 6 if ilo_job2_ocu_isco88 == 10			// 6 - Armed forces occupations
		  replace ilo_job2_ocu_aggregate = 7 if ilo_job2_ocu_isco88 == 11			// 7 - Not elsewhere classified
				  *lab def ocu_aggr_lab 1 "1 - Managers, professionals, and technicians" 2 "2 - Clerical, service and sales workers" 3 "3 - Skilled agricultural and trades workers" ///
					*				   4 "4 - Plant and machine operators, and assemblers" 5 "5 - Elementary occupations" 6 "6 - Armed forces" 7 "7 - Not elsewhere classified"
				  lab val ilo_job2_ocu_aggregate ocu_aggr_lab
				  lab var ilo_job2_ocu_aggregate "Occupation (Aggregate)"	
		
	  * Skill level
	  gen ilo_job2_ocu_skill = .
		  replace ilo_job2_ocu_skill = 1 if ilo_job2_ocu_isco88 == 9                 // 1 - Skill level 1 (low)
		  replace ilo_job2_ocu_skill = 2 if inlist(ilo_job2_ocu_isco88,4,5,6,7,8)    // 2 - Skill level 2 (medium)
		  replace ilo_job2_ocu_skill = 3 if inlist(ilo_job2_ocu_isco88,1,2,3)        // 3 - Skill levels 3 and 4 (high)
		  replace ilo_job2_ocu_skill = 4 if inlist(ilo_job2_ocu_isco88,10,11)        // 4 - Not elsewhere classified
			   *	  lab def ocu_skill_lab 1 "1 - Skill level 1 (low)" 2 "2 - Skill level 2 (medium)" 3 "3 - Skill levels 3 and 4 (high)" 4 "4 - Not elsewhere classified"
				  lab val ilo_job2_ocu_skill ocu_skill_lab
				  lab var ilo_job2_ocu_skill "Occupation (Skill level)"

}
					
			
if `Y' > 2010 {
				
destring OCUP1, replace
	
	* 1 digit level  

	gen ilo_job1_ocu_isco08 = .
		
		replace ilo_job1_ocu_isco08 = 1 if OCUP1 == 1 & ilo_lfs == 1   // 1 - Managers
		replace ilo_job1_ocu_isco08 = 2 if OCUP1 == 2 & ilo_lfs == 1   // 2 - Professionals
		replace ilo_job1_ocu_isco08 = 3 if OCUP1 == 3 & ilo_lfs == 1   // 3 - Technicians and Associate Professionals
		replace ilo_job1_ocu_isco08 = 4 if OCUP1 == 4 & ilo_lfs == 1   // 4 - Clerical Support Workers
		replace ilo_job1_ocu_isco08 = 5 if OCUP1 == 5 & ilo_lfs == 1   // 5 - Services and Sales Workers
		replace ilo_job1_ocu_isco08 = 6 if OCUP1 == 6 & ilo_lfs == 1   // 6 - Skilled Agricultural, Forestry and Fishery Workers
		replace ilo_job1_ocu_isco08 = 7 if OCUP1 == 7 & ilo_lfs == 1   // 7 - Craft and Related Trades Workers
		replace ilo_job1_ocu_isco08 = 8 if OCUP1 == 8 & ilo_lfs == 1   // 8 - Plant and Machine Operators and Assemblers
		replace ilo_job1_ocu_isco08 = 9 if OCUP1 == 9 & ilo_lfs == 1   // 9 - Elementary Occupations
		replace ilo_job1_ocu_isco08 = 10 if OCUP1 == 0 & ilo_lfs == 1   // 10 - Armed forces
		replace ilo_job1_ocu_isco08 = 11 if OCUP1 == . & ilo_lfs == 1   // X - Not elsewhere classified

		 lab def ocu08_1digits 1 "1 - Managers"	2 "2 - Professionals"	3 "3 - Technicians and associate professionals"	4 "4 - Clerical support workers" ///
                                      5 "5 - Service and sales workers"	6 "6 - Skilled agricultural, forestry and fishery workers"	7 "7 - Craft and related trades workers"	/// 
						              8 "8 - Plant and machine operators, and assemblers"  9 "9 - Elementary occupations"	10 "0 - Armed forces occupations"	///
						              11 "X - Not elsewhere classified"	
				lab val ilo_job1_ocu_isco08 ocu08_1digits
				lab var ilo_job1_ocu_isco08 "Occupation (ISCO-08) - main job"
				
	* Aggregate
	  gen ilo_job1_ocu_aggregate = .
		  replace ilo_job1_ocu_aggregate = 1 if inrange(ilo_job1_ocu_isco08,1,3) // 1 - Managers, professionals, and technicians
		  replace ilo_job1_ocu_aggregate = 2 if inlist(ilo_job1_ocu_isco08,4,5)	// 2 - Clerical, service and sales workers
		  replace ilo_job1_ocu_aggregate = 3 if inlist(ilo_job1_ocu_isco08,6,7)	// 3 - Skilled agricultural and trades workers
		  replace ilo_job1_ocu_aggregate = 4 if ilo_job1_ocu_isco08 == 8		// 4 - Plant and machine operators, and assemblers
		  replace ilo_job1_ocu_aggregate = 5 if ilo_job1_ocu_isco08 == 9		// 5 - Elementary occupations
		  replace ilo_job1_ocu_aggregate = 6 if ilo_job1_ocu_isco08 == 10		// 6 - Armed forces
		  replace ilo_job1_ocu_aggregate = 7 if ilo_job1_ocu_isco08 == 11		// 7 - Not elsewhere classified
				 lab def ocu_aggr_lab 1 "1 - Managers, professionals, and technicians" 2 "2 - Clerical, service and sales workers" 3 "3 - Skilled agricultural and trades workers" ///
				 					 4 "4 - Plant and machine operators, and assemblers" 5 "5 - Elementary occupations" 6 "6 - Armed forces" 7 "7 - Not elsewhere classified"
			    lab val ilo_job1_ocu_aggregate ocu_aggr_lab
			    lab var ilo_job1_ocu_aggregate "Occupation (Aggregate) - main job"	
		
	  * Skill level
	  gen ilo_job1_ocu_skill = .
		  replace ilo_job1_ocu_skill = 1 if ilo_job1_ocu_isco08 == 9                   // 1 - Skill level 1 (low)
		  replace ilo_job1_ocu_skill = 2 if inrange(ilo_job1_ocu_isco08,4,8)           // 2 - Skill level 2 (medium)
		  replace ilo_job1_ocu_skill=3 if inrange(ilo_job1_ocu_isco08,1,3)             // 3 - Skill levels 3 and 4 (high)
		  replace ilo_job1_ocu_skill=4 if inlist(ilo_job1_ocu_isco08,10,11)            // 4 - Not elsewhere classified
			   	lab def ocu_skill_lab 1 "1 - Skill level 1 (low)" 2 "2 - Skill level 2 (medium)" 3 "3 - Skill levels 3 and 4 (high)" 4 "4 - Not elsewhere classified"
				lab val ilo_job1_ocu_skill ocu_skill_lab
			    lab var ilo_job1_ocu_skill "Occupation (Skill level) - main job"
		
				
***** SECOND JOB *****
				

destring OCUPLU1, replace
	
	* 1 digit level  

	gen ilo_job2_ocu_isco08 = .
		replace ilo_job2_ocu_isco08 = 1 if OCUPLU1 == 1 & ilo_mjh == 2   // 1 - Managers
		replace ilo_job2_ocu_isco08 = 2 if OCUPLU1 == 2 & ilo_mjh == 2   // 2 - Professionals
		replace ilo_job2_ocu_isco08 = 3 if OCUPLU1 == 3 & ilo_mjh == 2   // 3 - Technicians and Associate Professionals
		replace ilo_job2_ocu_isco08 = 4 if OCUPLU1 == 4 & ilo_mjh == 2   // 4 - Clerical Support Workers
		replace ilo_job2_ocu_isco08 = 5 if OCUPLU1 == 5 & ilo_mjh == 2   // 5 - Services and Sales Workers
		replace ilo_job2_ocu_isco08 = 6 if OCUPLU1 == 6 & ilo_mjh == 2   // 6 - Skilled Agricultural, Forestry and Fishery Workers
		replace ilo_job2_ocu_isco08 = 7 if OCUPLU1 == 7 & ilo_mjh == 2   // 7 - Craft and Related Trades Workers
		replace ilo_job2_ocu_isco08 = 8 if OCUPLU1 == 8 & ilo_mjh == 2   // 8 - Plant and Machine Operators and Assemblers
		replace ilo_job2_ocu_isco08 = 9 if OCUPLU1 == 9 & ilo_mjh == 2   // 9 - Elementary Occupations
		replace ilo_job2_ocu_isco08 = 10 if OCUPLU1 == 0 & ilo_mjh == 2   // 0 - Armed forces occupations
		replace ilo_job2_ocu_isco08 = 11 if OCUPLU1 == . & ilo_mjh == 2   // X - Not elsewhere classified


		lab def ilo_job2_ocu_isco08 1 "1 - Managers" 2 "2 - Professionals" 3 "3 - Technicians and Associate Professionals" 4 "4 - Clerical Support Workers" ///
									5 "5 - Services and Sales Workers"  6 "6 - Skilled Agricultural, Forestry and Fishery Workers" 7 "7 - Craft and Related Trades Workers" ///
									8 "8 - Plant and Machine Operators and Assemblers" 9 "9 - Elementary Occupations" ///
									10 "0 - Armed forces occupations" 11 "X - Not elsewhere classified"
				lab val ilo_job2_ocu_isco08  ocu_isco08_lab
				lab var ilo_job2_ocu_isco08  "Occupation (ISCO-08)"	
	
	* Aggregate
	  gen ilo_job2_ocu_aggregate =.
		  replace ilo_job2_ocu_aggregate = 1 if inrange(ilo_job2_ocu_isco08,1,3)  // 1 - Managers, professionals, and technicians
		  replace ilo_job2_ocu_aggregate = 2 if inlist(ilo_job2_ocu_isco08,4,5)	// 2 - Clerical, service and sales workers
		  replace ilo_job2_ocu_aggregate = 3 if inlist(ilo_job2_ocu_isco08,6,7)	// 3 - Skilled agricultural and trades workers
		  replace ilo_job2_ocu_aggregate = 4 if ilo_job2_ocu_isco08 == 8			// 4 - Plant and machine operators, and assemblers
		  replace ilo_job2_ocu_aggregate = 5 if ilo_job2_ocu_isco08 == 9			// 5 - Elementary occupations
		  replace ilo_job2_ocu_aggregate = 6 if ilo_job2_ocu_isco08 == 10			// 6 - Armed forces occupations
		  replace ilo_job2_ocu_aggregate = 7 if ilo_job2_ocu_isco08 == 11			// 7 - Not elsewhere classified
				  *lab def ocu_aggr_lab 1 "1 - Managers, professionals, and technicians" 2 "2 - Clerical, service and sales workers" 3 "3 - Skilled agricultural and trades workers" ///
					*				   4 "4 - Plant and machine operators, and assemblers" 5 "5 - Elementary occupations" 6 "6 - Armed forces" 7 "7 - Not elsewhere classified"
				  lab val ilo_job2_ocu_aggregate ocu_aggr_lab
				  lab var ilo_job2_ocu_aggregate "Occupation (Aggregate)"	
		
	  * Skill level
	  gen ilo_job2_ocu_skill = .
		  replace ilo_job2_ocu_skill = 1 if ilo_job2_ocu_isco08 == 9                 // 1 - Skill level 1 (low)
		  replace ilo_job2_ocu_skill = 2 if inlist(ilo_job2_ocu_isco08,4,5,6,7,8)    // 2 - Skill level 2 (medium)
		  replace ilo_job2_ocu_skill = 3 if inlist(ilo_job2_ocu_isco08,1,2,3)        // 3 - Skill levels 3 and 4 (high)
		  replace ilo_job2_ocu_skill = 4 if inlist(ilo_job2_ocu_isco08,10,11)        // 4 - Not elsewhere classified
			   *	  lab def ocu_skill_lab 1 "1 - Skill level 1 (low)" 2 "2 - Skill level 2 (medium)" 3 "3 - Skill levels 3 and 4 (high)" 4 "4 - Not elsewhere classified"
				  lab val ilo_job2_ocu_skill ocu_skill_lab
				  lab var ilo_job2_ocu_skill "Occupation (Skill level)"	

}

			  
				  
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_job1_ins_sector')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

	
***** MAIN JOB *****

		 
		gen ilo_job1_ins_sector = .
			replace ilo_job1_ins_sector = 1 if SITU == 7 & ilo_lfs == 1 	// Public
			replace ilo_job1_ins_sector = 2 if SITU != 7 & ilo_lfs == 1    // Private
				lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
			    lab values ilo_job1_ins_sector ins_sector_lab
			    lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities"
	 

***** SECOND JOB *****

		 
		gen ilo_job2_ins_sector = .
			replace ilo_job2_ins_sector = 1 if SITPLU == 7 & ilo_mjh == 2 	// Public
			replace ilo_job2_ins_sector = 2 if SITPLU != 7 & ilo_mjh == 2     // Private
				*lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
			    lab values ilo_job2_ins_sector ins_sector_lab
			    lab var ilo_job2_ins_sector "Institutional sector (private/public) of economic activities"

		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job1_job_time')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			

***** MAIN JOB *****

destring PARCO1, replace

recode PARCO1 (6=1) (1=2), gen (PARCO)

		gen ilo_job1_job_time = .
		replace ilo_job1_job_time = 1 if PARCO  == 1								// 1 - Part-time
		replace ilo_job1_job_time = 2 if PARCO  == 2								// 2 - Full-time
		replace ilo_job1_job_time = 3 if ilo_job1_job_time == . & ilo_lfs == 1 		// 3 - Unknown
			lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknow"
			    lab values ilo_job1_job_time job_time_lab
			    lab var ilo_job1_job_time "Job (Working time arrangement)"
 


***** SECOND JOB *****


*** No information available. 


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*		1. 	Hours of work actually worked ('ilo_job1_how_actual')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	


*** MAIN JOB

destring HORASE, replace


   * ilo_job1_how_actual

 
		gen ilo_job1_how_actual = HORASE/100 if ilo_lfs == 1
		
		replace ilo_job1_how_actual = . if ilo_job1_how_actual == 99
				lab var ilo_job1_how_actual "Weekly hours actually worked in main job"	      
		
		gen ilo_job1_how_actual_bands = .
			 replace ilo_job1_how_actual_bands = 1 if ilo_job1_how_actual == 0			    // No hours actually worked
			 replace ilo_job1_how_actual_bands = 2 if inrange(ilo_job1_how_actual,1,14)	    // 01-14
			 replace ilo_job1_how_actual_bands = 3 if inrange(ilo_job1_how_actual,15,29)	// 15-29
			 replace ilo_job1_how_actual_bands = 4 if inrange(ilo_job1_how_actual,30,34)	// 30-34
			 replace ilo_job1_how_actual_bands = 5 if inrange(ilo_job1_how_actual,35,39)	// 35-39
			 replace ilo_job1_how_actual_bands = 6 if inrange(ilo_job1_how_actual,40,48)	// 40-48
			 replace ilo_job1_how_actual_bands = 7 if ilo_job1_how_actual>=49 & ilo_job1_how_actual !=. // 49+
			 replace ilo_job1_how_actual_bands = 8 if ilo_job1_how_actual_bands == .		// Not elsewhere classified
 			 replace ilo_job1_how_actual_bands = . if ilo_lfs!=1
				     lab def how_bands_lab 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"
					 lab val ilo_job1_how_actual_bands how_bands_lab
					 lab var ilo_job1_how_actual_bands "Weekly hours actually worked bands in main job"
					 
					
*** SECOND JOB

   * ilo_job2_how_actual

destring HORPLU, replace

		gen ilo_job2_how_actual = HORPLU/100 if ilo_mjh==2
		 
		replace ilo_job2_how_actual = . if ilo_job2_how_actual == 99
				lab var ilo_job2_how_actual "Weekly hours actually worked in main job"	      
		
		gen ilo_job2_how_actual_bands = .
			 replace ilo_job2_how_actual_bands = 1 if ilo_job2_how_actual == 0				// No hours actually worked
			 replace ilo_job2_how_actual_bands = 2 if inrange(ilo_job2_how_actual,1,14)	    // 01-14
			 replace ilo_job2_how_actual_bands = 3 if inrange(ilo_job2_how_actual,15,29)	// 15-29
			 replace ilo_job2_how_actual_bands = 4 if inrange(ilo_job2_how_actual,30,34)	// 30-34
			 replace ilo_job2_how_actual_bands = 5 if inrange(ilo_job2_how_actual,35,39)	// 35-39
			 replace ilo_job2_how_actual_bands = 6 if inrange(ilo_job2_how_actual,40,48)	// 40-48
			 replace ilo_job2_how_actual_bands = 7 if ilo_job2_how_actual>=49 & ilo_job2_how_actual !=. // 49+
			 replace ilo_job2_how_actual_bands = 8 if ilo_job2_how_actual_bands == . & ilo_mjh==2	// Not elsewhere classified
			 replace ilo_job2_how_actual_bands = . if ilo_mjh!=2
                     *lab def how_actual_bands_lab 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"
					 lab val ilo_job2_how_actual_bands how_bands_lab
					 lab var ilo_job2_how_actual_bands "Weekly hours actually worked bands in second job"

	******
	
	*** ALL JOBS

		
 egen ilo_joball_how_actual = rowtotal(ilo_job1_how_actual ilo_job2_how_actual), m 
			 lab var ilo_joball_how_actual "Weekly hours actually worked in all jobs"
						
		 gen ilo_joball_actual_how_bands = .
			 replace ilo_joball_actual_how_bands=1 if ilo_joball_how_actual==0 // No hours actually worked
			 replace ilo_joball_actual_how_bands=2 if ilo_joball_how_actual>=1 & ilo_joball_how_actual<=14  // 01-14
			 replace ilo_joball_actual_how_bands=3 if ilo_joball_how_actual>=15 & ilo_joball_how_actual<=29 // 15-29
			 replace ilo_joball_actual_how_bands=4 if ilo_joball_how_actual>=30 & ilo_joball_how_actual<=34 // 30-34
			 replace ilo_joball_actual_how_bands=5 if ilo_joball_how_actual>=35 & ilo_joball_how_actual<=39 // 35-39
			 replace ilo_joball_actual_how_bands=6 if ilo_joball_how_actual>=40 & ilo_joball_how_actual<=48 // 40-48
			 replace ilo_joball_actual_how_bands=7 if ilo_joball_how_actual>=49 & ilo_joball_how_actual!=.  // 49+
			 replace ilo_joball_actual_how_bands=8 if ilo_joball_actual_how_bands==. & ilo_lfs==1           // Not elsewhere classified
			 replace ilo_joball_actual_how_bands=. if ilo_lfs!=1
			 		 lab val ilo_joball_actual_how_bands how_bands_lab 
					 lab var ilo_joball_actual_how_bands "Weekly hours actually worked bands in all jobs"
			
			
					
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*		2. 	Hours of work usually worked ('ilo_job1_how_usual')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

*** MAIN JOB

destring HORASH, replace


   
		gen ilo_job1_how_usual = HORASH/100 if ilo_lfs==1
		replace ilo_job1_how_usual = . if ilo_job1_how_usual == 99
				lab var ilo_job1_how_usual "Weekly hours usually worked in main job"	      
		
		gen ilo_job1_how_usual_bands = .
			 replace ilo_job1_how_usual_bands = 1 if ilo_job1_how_usual == 0				// No hours usually worked
			 replace ilo_job1_how_usual_bands = 2 if inrange(ilo_job1_how_usual,1,14)	// 01-14
			 replace ilo_job1_how_usual_bands = 3 if inrange(ilo_job1_how_usual,15,29)	// 15-29
			 replace ilo_job1_how_usual_bands = 4 if inrange(ilo_job1_how_usual,30,34)	// 30-34
			 replace ilo_job1_how_usual_bands = 5 if inrange(ilo_job1_how_usual,35,39)	// 35-39
			 replace ilo_job1_how_usual_bands = 6 if inrange(ilo_job1_how_usual,40,48)	// 40-48
			 replace ilo_job1_how_usual_bands = 7 if ilo_job1_how_usual>=49 & ilo_job1_how_usual !=. // 49+
			 replace ilo_job1_how_usual_bands = 8 if ilo_job1_how_usual_bands == .	// Not elsewhere classified
			 replace ilo_job1_how_usual_bands = . if ilo_lfs! = 1
			 lab def how_usu_bands_lab 1 "No hours usually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"
					 lab val ilo_job1_how_usual_bands how_usu_bands_lab
					 lab var ilo_job1_how_usual_bands "Weekly hours usually worked bands in main job"
		
*** SECOND JOB
* - Information not available
					
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job1_job_contract')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

destring DUCON1, replace

		gen ilo_job1_job_contract = .
		replace ilo_job1_job_contract = 1 if DUCON1 == 1								// 1 - Permanent
		replace ilo_job1_job_contract = 2 if DUCON1 == 6								// 2 - Temporary
		replace ilo_job1_job_contract = 3 if ilo_job1_job_contract == . & ilo_lfs == 1	// 3 - Unknown
			lab def job_contract_lab 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"
			    lab values ilo_job1_job_contract job_contract_lab
			    lab var ilo_job1_job_contract "Job (Type of contract)"


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Formal / Informal Economy ('ilo_job1_ife_prod' 'ilo_job1_ife_nature')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			

/* Useful questions:
			- Institutional sector: SITU
			- Destination of production:    ***
			- Bookkeeping: ***
			- Registration: ***
			- Household identification: ilo_job1_eco_isic3_2digits==95 or ilo_job1_ocu_isco88_2digits==62
			- Social security contribution: **
			- Place of work: PROEST, REGEST
			- Size:***
			- Status in employment: ilo_job1_ste_aggregate / ilo_job1_ste_icse93
			- Paid annual leave: ***
			- Paid sick leave: ***
*/


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Monthly labour related income ('ilo_joball_lri')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
				

* Comment: Not enough information to define labour related income variables 

		
				
***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_joball_tru')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

destring MASHOR, replace
destring DISMAS, replace
		
		gen ilo_joball_tru = .
		replace ilo_joball_tru=1 if  MASHOR == 1 & DISMAS == 1 & ilo_joball_how_actual < 35
			lab def lab_joball_tru 1 "Time-related underemployed" 
			lab val ilo_joball_tru lab_joball_tru
			lab var ilo_joball_tru "Time-related underemployed"
			
		
  
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


destring EMPANT, replace

		gen ilo_cat_une = .
		replace ilo_cat_une = 1 if EMPANT == 1 & ilo_lfs == 2				// 1 - Unemployed previously employed
		replace ilo_cat_une = 2 if EMPANT == 6 & BUSCA == 1 & ilo_lfs == 2	// 2 - Unemployed seeking their first job
		replace ilo_cat_une = 3 if  ilo_cat_une == . & ilo_lfs == 2 			// 3 - Unknown
			lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
			    lab values ilo_cat_une cat_une_lab
			    lab var ilo_cat_une "Category of unemployment"
				
				
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------


* Comments: - Original question refers to the number of weeks seeking for a job.
* Time in months for the original variable (ITBU). 

destring ITBU, replace

	gen ilo_dur_details = .
	    replace ilo_dur_details = 1 if ITBU == 1 & ilo_lfs == 2              // Less than 1 month (between 1 and 3 weeks)
		replace ilo_dur_details = 2 if ITBU == 2 & ilo_lfs == 2              // 1 to 3 months (between 4 and 11 weeks)
		replace ilo_dur_details = 3 if ITBU == 3 & ilo_lfs == 2             // 3 to 6 months (between 12 and 23 weeks)
		replace ilo_dur_details = 4 if ITBU == 4 & ilo_lfs == 2             // 6 to 12 months (between 24 and 47 weeks)
		replace ilo_dur_details = 5 if inlist(ITBU,5,6) & ilo_lfs == 2      // 12 to 24 months (between 48 and 95 weeks)
		replace ilo_dur_details = 6 if inlist(ITBU,7,8)& ilo_lfs == 2       // 24 months or more (96 weeks or more)
		replace ilo_dur_details = 7 if ITBU == . & ilo_lfs == 2             // Not elsewhere classified

		        lab def ilo_unemp_det 1 "Less than 1 month" 2 "1 month to less than 3 months" 3 "3 months to less than 6 months" ///
									  4 "6 months to less than 12 months" 5 "12 months to less than 24 months" 6 "24 months or more" ///
									  7 "Not elsewhere classified"
			    lab val ilo_dur_details ilo_unemp_det
			    lab var ilo_dur_details "Duration of unemployment (Details)"
			
			
	gen ilo_dur_aggregate = .
		replace ilo_dur_aggregate = 1 if inrange(ilo_dur_details,1,3) & ilo_lfs == 2   // Less than 6 months
		replace ilo_dur_aggregate = 2 if ilo_dur_details == 4 & ilo_lfs == 2              // 6 to 12 months
		replace ilo_dur_aggregate = 3 if inlist(ilo_dur_details,5,6) & ilo_lfs == 2     // 12 months or more
		replace ilo_dur_aggregate = 4 if ilo_dur_details == 7 & ilo_lfs == 2              //Not elsewhere classified
		replace ilo_dur_aggregate = . if ilo_lfs!=2
			lab def ilo_unemp_aggr 1 "Less than 6 months" 2 "6 months to less than 12 months" 3 "12 months or more" 4 "Not elsewhere classified"
			lab val ilo_dur_aggregate ilo_unemp_aggr
			lab var ilo_dur_aggregate "Duration of unemployment (Aggregate)"

	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

destring ACTA, replace
	
		
		* gen ilo_job1_eco_isic4=.   ***** (not possible)
			
			
	* Classification on an aggregate level
	
		* Primary activity
		
		gen ilo_preveco_aggregate = .
			replace ilo_preveco_aggregate=1 if ACTA == 0 & ilo_cat_une == 1  			    // 1 - Agriculture
			replace ilo_preveco_aggregate=2 if inrange(ACTA,1,3) & ilo_cat_une == 1  		// 2 - Manufacturing
			replace ilo_preveco_aggregate=3 if ACTA == 4 & ilo_cat_une == 1  				// 3 - Construction
			replace ilo_preveco_aggregate=4 if ACTA == 2 & ilo_cat_une == 1               	// 4 - Mining and quarrying; Electricity, gas and water supply
			replace ilo_preveco_aggregate=5 if inrange(ACTA,5,7) & ilo_cat_une == 1  	    // 5 - Market Services (Trade; Transportation; Accommodation and food; and Business and administrative services)
			replace ilo_preveco_aggregate=6 if inrange(ACTA,8,9) & ilo_cat_une == 1  	 	// 6 - Non-market services (Public administration; Community, social and other services and ACTAivities)
			replace ilo_preveco_aggregate=7 if ACTA == . & ilo_cat_une == 1    				// 7 - Not classifiable by economic Activity
				*lab def eco_aggr_lab 1 "1 - Agriculture" 2 "2 - Manufacturing" 3 "3 - Construction" 4 "4 - Mining and quarrying; Electricity, gas and water supply" ///
									*5 "5 - Market Services (Trade; Transportation; Accommodation and food; and Business and administrative services)"  ///
									*6 "6 - Non-market services (Public administration; Community, social and other services and ACTAivities)" 7 "7 - Not classifiable by economic ACTAivity"					
				lab val ilo_preveco_aggregate eco_aggr_lab 
				lab var ilo_preveco_aggregate "Previous economic activity (Aggregate)"	
			
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
destring OCUPA, replace

	* 1 digit level  

	gen ilo_prevocu_isco08 = .
		
		replace ilo_prevocu_isco08 = 1 if OCUPA == 1 & ilo_cat_une == 1  // 1 - Managers
		replace ilo_prevocu_isco08 = 2 if OCUPA == 2 & ilo_cat_une == 1   // 2 - Professionals
		replace ilo_prevocu_isco08 = 3 if OCUPA == 3 & ilo_cat_une == 1   // 3 - Technicians and Associate Professionals
		replace ilo_prevocu_isco08 = 4 if OCUPA == 4 & ilo_cat_une == 1   // 4 - Clerical Support Workers
		replace ilo_prevocu_isco08 = 5 if OCUPA == 5 & ilo_cat_une == 1   // 5 - Services and Sales Workers
		replace ilo_prevocu_isco08 = 6 if OCUPA == 6 & ilo_cat_une == 1   // 6 - Skilled Agricultural, Forestry and Fishery Workers
		replace ilo_prevocu_isco08 = 7 if OCUPA == 7 & ilo_cat_une == 1   // 7 - Craft and Related Trades Workers
		replace ilo_prevocu_isco08 = 8 if OCUPA == 8 & ilo_cat_une == 1   // 8 - Plant and Machine Operators and Assemblers
		replace ilo_prevocu_isco08 = 9 if OCUPA == 9 & ilo_cat_une == 1   // 9 - Elementary Occupations
		replace ilo_prevocu_isco08 = 10 if OCUPA == 0 & ilo_cat_une == 1  // 10 - Armed forces
		replace ilo_prevocu_isco08 = 11 if OCUPA == . & ilo_cat_une == 1  // X - Not elsewhere classified

		lab def ilo_prevocu_isco08  1 "1 - Managers"	2 "2 - Professionals"	3 "3 - Technicians and associate professionals"	4 "4 - Clerical support workers" ///
                                      5 "5 - Service and sales workers"	6 "6 - Skilled agricultural, forestry and fishery workers"	7 "7 - Craft and related trades workers"	/// 
						              8 "8 - Plant and machine operators, and assemblers"  9 "9 - Elementary occupations"	10 "0 - Armed forces occupations"	///
						              11 "X - Not elsewhere classified"			
				lab val ilo_prevocu_isco08  ocu_isco08_lab
				lab var ilo_prevocu_isco08  "Previous occupation (ISCO-08)"	
				
				
				
				
	* Aggregate
	  gen ilo_prevocu_aggregate = .
		  replace ilo_prevocu_aggregate = 1 if inrange(ilo_prevocu_isco08,1,3)  // 1 - Managers, professionals, and technicians
		  replace ilo_prevocu_aggregate = 2 if inlist(ilo_prevocu_isco08,4,5)	// 2 - Clerical, service and sales workers
		  replace ilo_prevocu_aggregate = 3 if inlist(ilo_prevocu_isco08,6,7)	// 3 - Skilled agricultural and trades workers
		  replace ilo_prevocu_aggregate = 4 if ilo_prevocu_isco08 == 8			// 4 - Plant and machine operators, and assemblers
		  replace ilo_prevocu_aggregate = 5 if ilo_prevocu_isco08 == 9			// 5 - Elementary occupations
		  replace ilo_prevocu_aggregate = 6 if ilo_prevocu_isco08 == 10		// 6 - Armed forces
		  replace ilo_prevocu_aggregate = 7 if ilo_prevocu_isco08 == 11		// 7 - Not elsewhere classified
				  *lab def ocu_aggr_lab 1 "1 - Managers, professionals, and technicians" 2 "2 - Clerical, service and sales workers" 3 "3 - Skilled agricultural and trades workers" ///
									  * 4 "4 - Plant and machine operators, and assemblers" 5 "5 - Elementary occupations" 6 "6 - Armed forces" 7 "7 - Not elsewhere classified"
				  lab val ilo_prevocu_aggregate ocu_aggr_lab
				  lab var ilo_prevocu_aggregate "Previous occupation (Aggregate)"	
		
	  * Skill level
	  gen ilo_prevocu_skill = .
		  replace ilo_prevocu_skill = 1 if ilo_prevocu_isco08 == 9                  // Low
		  replace ilo_prevocu_skill = 2 if inlist(ilo_prevocu_isco08,4,5,6,7,8)    // Medium
		  replace ilo_prevocu_skill = 3 if inlist(ilo_prevocu_isco08,1,2,3)        // High
		  replace ilo_prevocu_skill = 4 if inlist(ilo_prevocu_isco08,10,11)        // Not elsewhere classified
			   	  *lab def ocu_skill_lab 1 "1 - Skill level 1 (low)" 2 "2 - Skill level 2 (medium)" 3 "3 - Skill levels 3 and 4 (high)" 4 "4 - Not elsewhere classified"
				  lab val ilo_prevocu_skill ocu_skill_lab
				  lab var ilo_prevocu_skill "Previous occupation occupation (Skill level)"

	  
				  
***********************************************************************************************
*			PART 3.4. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		.	


destring DESEA, replace						
				
		gen ilo_olf_dlma = .
		replace ilo_olf_dlma = 1 if ilo_lfs == 3 & (BUSCA == 1 & FOBACT == 1) & DISP == 6 			        // Seeking (actively), not available
		replace ilo_olf_dlma = 2 if ilo_lfs == 3 & BUSCA == 6 & DISP == 1			                            // Not seeking, available
		replace ilo_olf_dlma = 3 if ilo_lfs == 3 & BUSCA == 6 & DISP == 6 & DESEA == 1		                    // Not seeking, not available, willing  
		replace ilo_olf_dlma = 4 if ilo_lfs == 3 & BUSCA == 6 & DISP == 6 & DESEA == 6			                // Not seeking, not available, not willing  
		replace ilo_olf_dlma = 5 if	ilo_olf_dlma == . & ilo_lfs == 3				                            // Not classified 
				lab def dlma_lab 1 "1 - Seeking, not available (Unavailable jobseekers)" 2 "2 - Not seeking, available (Available potential jobseekers)" ///
	    						 3 "3 - Not seeking, not available, willing (Willing non-jobseekers)" 4 "4 - Not seeking, not available, not willing" 5 "X - Not elsewhere classified"
		    	lab val ilo_olf_dlma dlma_lab 
			    lab var ilo_olf_dlma "Labour market attachment (Degree of)"
			
				
				
	
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reason for not seeking job ('ilo_olf_reason')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

destring NBUSCA, replace
	

gen ilo_olf_reason = .
			replace ilo_olf_reason = 1 if inlist(NBUSCA,1,2) & ilo_lfs==3	  // Labour market
			*replace ilo_olf_reason=2 if                                      // Other labour market reasons
			replace ilo_olf_reason = 3 if inrange(NBUSCA,3,6) & ilo_lfs==3    // Personal/Family-related
			replace ilo_olf_reason=4 if NBUSCA == 7 & ilo_lfs==3		      // Does not need/want to work
			replace ilo_olf_reason=5 if inlist(NBUSCA,8,0) & ilo_lfs==3	      // Not elsewhere classified
			replace ilo_olf_reason=5 if ilo_olf_reason==. & ilo_lfs==3	      // Not elsewhere classified
				    lab def reasons_lab 1 "1 - Labour market" 2 "2 - Other labour market reasons" 3 "3 - Personal / Family-related" ///
									    4 "4 - Does not need/want to work" 5 "5 - Not elsewhere classified"
				    lab val ilo_olf_reason reasons_lab 
				    lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"			

					
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seeker ('ilo_dis')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

		gen ilo_dis = .
		replace ilo_dis=1 if (BUSCA == 6 & DESEA  == 1 & NBUSCA == 1 & DISP == 1 & ilo_lfs ==3)
			lab def dis_lab 1 "Discouraged job-seekers"
			lab val ilo_dis dis_lab
			lab var ilo_dis "Discouraged job-seekers"
			
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training ('ilo_neet')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------


	gen ilo_neet = 1 if ilo_age_aggregate==2 & ilo_lfs!=1 & ilo_edu_attendance==2
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
		
		drop if ilo_sex == . 
		
		compress 
		
		/*Save dataset including original and ilo variables*/
	
		save ${country}_${source}_${time}_FULL,  replace		

		/* Save file only containing ilo_* variables*/
	
		keep ilo*

		save ${country}_${source}_${time}_ILO, replace
				
				
				
				
				
				
				
				
				
				
				
				
				
