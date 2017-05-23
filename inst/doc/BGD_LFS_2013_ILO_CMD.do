* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Bangladesh, 2013
* DATASET USED: Bangladesh LFS 2013
* NOTES: 
* Authors: Marylène Escher
* Who last updated the file: Mabelin Villarreal Fuentes
* Starting Date: 22 September 2016
* Last updated: 05 May 2017
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
global country "BGD"
global source "LFS"
global time "2013"
global inputFile "BGD2013.dta"
global inpath "${path}\\${country}\\${source}\\${time}\ORI"
global temppath "${path}\_Admin"
global outpath "${path}\\${country}\\${source}\\${time}"


************************************************************************************

* Important : if package « labutil » not already installed, install it in order to execute correctly the do-file

* ssc install labutil

************************************************************************************
* Make a tempfile containing the labels for the classifications ISIC and ISCO 

		* NOTE: if you want this do-file to run correctly, run it without breaks!
		
cd "$temppath"
		
	tempfile labels
			* Import Framework
			import excel 3_Framework.xlsx, sheet("Variable") firstrow
			* Keep only the variable names, the codes and the labels associated to the codes
			keep var_name code_level code_label
			* Select only variables associated to isic and isco
			keep if (substr(var_name,1,12)=="ilo_job1_ocu" | substr(var_name,1,12)=="ilo_job1_eco") & substr(var_name,14,.)!="aggregate"
			* Destring codes
			destring code_level, replace
			* Reshape
				    foreach classif in var_name {
					replace var_name=substr(var_name,14,.) if var_name==`classif'
					}
				
				reshape wide code_label, i(code_level) j(var_name) string
				foreach var of newlist isco08_2digits isco88_2digits isco08 isco88 isic4_2digits isic4 ///
							isic3_2digits isic3 {
							gen `var'=code_level
							replace `var'=. if code_label`var'==""
							labmask `var' , val(code_label`var')
							}				
				drop code_label* code_level
							
			* Save file (as tempfile)
			
			save "`labels'"
			
*********************************************************************************************

* Load original dataset

*********************************************************************************************

cd "$inpath"
	use "$inputFile", clear
	*renaming everything in lower case
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

	gen ilo_wgt=wgt_final
		lab var ilo_wgt "Sample weight"		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time period ('ilo_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
	* Year 2013
	gen ilo_time=1
		lab def lab_time 1 "2013" 
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
		replace ilo_geo=1 if urb==2
		replace ilo_geo=2 if urb==1
			lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural"
			lab val ilo_geo ilo_geo_lab
			lab var ilo_geo "Geographical coverage"	
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_sex=sex
		lab def ilo_sex_lab 1 "1 - Male" 2 "2 - Female"
		lab var ilo_sex "Sex"
		lab val ilo_sex ilo_sex_lab
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_age=age
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
*			Education ('ilo_edu') [done] 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
		
/* ISCED 11 mapping: based on the mapping developped by UNESCO
					http://www.uis.unesco.org/Education/ISCEDMappings/Pages/default.aspx
					http://www.uis.unesco.org/Education/Documents/isced-2011-en.pdf 	*/

* Note that according to the definition, the highest level  CONCLUDED is considered

	gen ilo_edu_isced11=.
		replace ilo_edu_isced11=1 if class==1  					// No schooling
		replace ilo_edu_isced11=1 if q26==2 					// No schooling
		replace ilo_edu_isced11=2 if inrange(class,2,5)  		// Early childhood education
		replace ilo_edu_isced11=3 if inrange(class,6,8) 		// Primary education
		replace ilo_edu_isced11=4 if inrange(class,9,10)   		// Lower secondary education
		replace ilo_edu_isced11=5 if inrange(class,11,13)  		// Upper secondary education
		replace ilo_edu_isced11=6 if class==14 					// Post-secondary non-tertiary
		*replace ilo_edu_isced11=7 if 					 		// Short-cycle tertiary education
		replace ilo_edu_isced11=8 if class==15  				// Bachelor or equivalent
		replace ilo_edu_isced11=9 if class==16  				// Master's or equivalent level
		replace ilo_edu_isced11=10 if class==17  				// Doctoral or equivalent level
		replace ilo_edu_isced11=11 if class==19 				// Not elsewhere classified
		replace ilo_edu_isced11=11 if ilo_age<5 				// Not elsewhere classified
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
*			Education attendance ('ilo_edu_attendance') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_edu_attendance=.
		replace ilo_edu_attendance=1 if student==1				// Attending
		replace ilo_edu_attendance=2 if student==2				// Not attending
		replace ilo_edu_attendance=3 if student==.              // Not elsewhere classified
			label def edu_att_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
			label val ilo_edu_attendance edu_att_lab
			label var ilo_edu_attendance "Education (Attendance)"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Disability status ('ilo_dsb') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

		* No information on disability in the LFS questionnaire.
	
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
           
* Comment: wap = 15+ 

	gen ilo_wap=.
		replace ilo_wap=1 if ilo_age>=15 & ilo_age!=.
			lab def wap_lab 1 "Working age population"
			lab val ilo_wap wap_lab
			label var ilo_wap "Working age population"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Labour Force Status ('ilo_lfs') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
		
 /* NOTE: * In question 39 and 42 we suppose that the business sells at least a part of its production
			in the market. Thus, we include these persons in employment. If the business ONLY produces
			for the household own consumption, they should not be included in employment.  
 
		  * We suppose that answer 1 to question 86 (Was waiting for work) designs the FUTURE STARTERS that already
		    made arrangements to start a job within a short subsequent period. Hence, we include these persons in 
		    unemployment. If this answer does not design the future starters, they should be classified as "Outside 
			the labour force". */ 	
		  
	gen ilo_lfs=.
		replace ilo_lfs=1 if (q39==1 & ilo_wap==1) 		// Employed (self-employed)
		replace ilo_lfs=1 if (q40==1 & ilo_wap==1) 		// Employed (employee)
		replace ilo_lfs=1 if (q41==1 & ilo_wap==1) 		// Employed (domestic workers)
		replace ilo_lfs=1 if (q42==1 & ilo_wap==1) 		// Employed (contributing family member)
		replace ilo_lfs=1 if (q43==1 & ilo_wap==1) 		// Employed (temporary absent)
		replace ilo_lfs=2 if ilo_wap==1 & ilo_lfs==. & ((q84==1 & q87==1) | (q86==1 | q86==4)) // (seeking and available (or) future starters)
		replace ilo_lfs=3 if ilo_lfs==. & ilo_wap==1  		// Outside the labour force
				label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside the Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_mjh=.
		replace ilo_mjh=1 if q60_job2!=1 & ilo_lfs==1
		replace ilo_mjh=2 if q60_job2==1 & ilo_lfs==1
			lab def lab_ilo_mjh 1 "1 - One job only" 2 "2 - More than one job"
			lab val ilo_mjh lab_ilo_mjh
			lab var ilo_mjh "Multiple job holders"

***********************************************************************************************
*			PART 3.1. ECONOMIC CHARACTERISTICS FOR MAIN JOB 
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Status in employment ('ilo_job1_ste') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Document: http://www.ilo.org/wcmsp5/groups/public/---dgreports/---stat/documents/normativeinstrument/wcms_087562.pdf
	

  * MAIN JOB:
	
	* Detailled categories:
	
		gen ilo_job1_ste_icse93=.
			replace ilo_job1_ste_icse93=1 if inrange(q48,5,9) & ilo_lfs==1	// Employees
			replace ilo_job1_ste_icse93=2 if q48==1	& ilo_lfs==1			// Employers
			replace ilo_job1_ste_icse93=3 if inlist(q48,2,3) & ilo_lfs==1	// Own-account workers
			*replace ilo_job1_ste_icse93=4 if								// Producer cooperatives
			replace ilo_job1_ste_icse93=5 if q48==4	& ilo_lfs==1			// Contributing family workers
			replace ilo_job1_ste_icse93=6 if inlist(q48,10,.) & ilo_lfs==1	// Not classifiable
				label def label_ilo_ste_icse93 1 "1 - Employees" 2 "2 - Employers" 3 "3 - Own-account workers"  ///
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

			
  * SECOND JOB:
	
	* Detailled categories:
	
		gen ilo_job2_ste_icse93=.
			replace ilo_job2_ste_icse93=1 if inrange(q63_status2,5,9) & ilo_mjh==2	// Employees
			replace ilo_job2_ste_icse93=2 if q63_status2==1	& ilo_mjh==2			// Employers
			replace ilo_job2_ste_icse93=3 if inlist(q63_status2,2,3) & ilo_mjh==2	// Own-account workers
			*replace ilo_job2_ste_icse93=4 if								        // Producer cooperatives
			replace ilo_job2_ste_icse93=5 if q63_status2==4	& ilo_mjh==2			// Contributing family workers
			replace ilo_job2_ste_icse93=6 if inlist(q63_status2,10,.) & ilo_mjh==2  // Not classifiable
				label val ilo_job2_ste_icse93 label_ilo_ste_icse93
				label var ilo_job2_ste_icse93 "Status in employment (ICSE 93)- second job"

	* Aggregate categories 
		
		gen ilo_job2_ste_aggregate=.
			replace ilo_job2_ste_aggregate=1 if ilo_job2_ste_icse93==1				// Employees
			replace ilo_job2_ste_aggregate=2 if inrange(ilo_job2_ste_icse93,2,5)	// Self-employed
			replace ilo_job2_ste_aggregate=3 if ilo_job2_ste_icse93==6				// Not elsewhere classified
				lab val ilo_job2_ste_aggregate ste_aggr_lab
				label var ilo_job2_ste_aggregate "Status in employment (Aggregate) - second job"  

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------


	/* Classification used: BSIC 2009, based on ISIC Rev. 4 */
	
	/* The economic activity is only classified at 1 digit level because at the 2 digit level
	   there is a large share of observations recorded in classes that do not exist in ISIC. */
		
			
		* Import value labels
			
			append using `labels', gen (lab)
			
			
				* MAIN JOB:
						
							
					* ISIC Rev. 4 - 1 digit
						gen ilo_job1_eco_isic4=.
							replace ilo_job1_eco_isic4=bsic1i if ilo_lfs==1
							        lab val ilo_job1_eco_isic4 isic4
									lab var ilo_job1_eco_isic4 "Economic activity (ISIC Rev. 4) - main job"
							
					* Aggregated level 
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
		

		
		* SECOND JOB:
		/* Economic activity of the second job is only available at a 4 digit level. */
					
					* ISIC Rev. 4 - 2 digit
					gen indu_code_job2=int(q61_ind2/100) if ilo_mjh==2
					
							
					* ISIC Rev. 4 - 1 digit
						gen ilo_job2_eco_isic4=.
							replace ilo_job2_eco_isic4=1 if inrange(indu_code_job2,1,3)
							replace ilo_job2_eco_isic4=2 if inrange(indu_code_job2,5,9)
							replace ilo_job2_eco_isic4=3 if inrange(indu_code_job2,10,33)
							replace ilo_job2_eco_isic4=4 if indu_code_job2==35
							replace ilo_job2_eco_isic4=5 if inrange(indu_code_job2,36,39)
							replace ilo_job2_eco_isic4=6 if inrange(indu_code_job2,41,43)
							replace ilo_job2_eco_isic4=7 if inrange(indu_code_job2,45,47)
							replace ilo_job2_eco_isic4=8 if inrange(indu_code_job2,49,53)
							replace ilo_job2_eco_isic4=9 if inrange(indu_code_job2,55,56)
							replace ilo_job2_eco_isic4=10 if inrange(indu_code_job2,58,63)
							replace ilo_job2_eco_isic4=11 if inrange(indu_code_job2,64,66)
							replace ilo_job2_eco_isic4=12 if indu_code_job2==68
							replace ilo_job2_eco_isic4=13 if inrange(indu_code_job2,69,75)
							replace ilo_job2_eco_isic4=14 if inrange(indu_code_job2,77,82)
							replace ilo_job2_eco_isic4=15 if indu_code_job2==84
							replace ilo_job2_eco_isic4=16 if indu_code_job2==85
							replace ilo_job2_eco_isic4=17 if inrange(indu_code_job2,86,88)
							replace ilo_job2_eco_isic4=18 if inrange(indu_code_job2,90,93)
							replace ilo_job2_eco_isic4=19 if inrange(indu_code_job2,94,96)
							replace ilo_job2_eco_isic4=20 if inrange(indu_code_job2,97,98)
							replace ilo_job2_eco_isic4=21 if indu_code_job2==99
							replace ilo_job2_eco_isic4=22 if ilo_job2_eco_isic4==. & ilo_mjh==2 
								lab val ilo_job2_eco_isic4 isic4
								lab var ilo_job2_eco_isic4 "Economic activity (ISIC Rev. 4) - second job"

							
							
					* Aggregated level 
						gen ilo_job2_eco_aggregate=.
							replace ilo_job2_eco_aggregate=1 if ilo_job2_eco_isic4==1
							replace ilo_job2_eco_aggregate=2 if ilo_job2_eco_isic4==3
							replace ilo_job2_eco_aggregate=3 if ilo_job2_eco_isic4==6
							replace ilo_job2_eco_aggregate=4 if inlist(ilo_job2_eco_isic4,2,4,5)
							replace ilo_job2_eco_aggregate=5 if inrange(ilo_job2_eco_isic4,7,14)
							replace ilo_job2_eco_aggregate=6 if inrange(ilo_job2_eco_isic4,15,21)
							replace ilo_job2_eco_aggregate=7 if ilo_job2_eco_isic4==22
								lab val ilo_job2_eco_aggregate eco_aggr_lab
								lab var ilo_job2_eco_aggregate "Economic activity (Aggregate) - second job" 

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_job1_ocu_isco08') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
	
	/* Occupatoin is only classified at 1 digit level because at the 2 digit level there is 
	observations recorded in categories that do not exist in ISIC. (for first and second job) */

	
	* MAIN JOB:	
	
		* ISCO 08 - 1 digit
			gen ilo_job1_ocu_isco08=bsco1 if ilo_lfs==1
				replace ilo_job1_ocu_isco08=10 if ilo_job1_ocu_isco08==0
				replace ilo_job1_ocu_isco08=11 if bsco1==. & ilo_lfs==1
					lab def isco08_1dig_lab 1 "1 - Managers" 2 "2 - Professionals" 3 "Technicians and associate professionals" 4 "4 - Clerical support workers" 5 "5 - Service and sales workers" ///
									6 "6 - Skilled agricultural, forestry and fishery workers" 7 "7 - Craft and related trades workers" 8 "8 - Plant and machine operators, and assemblers" ///
									9 "9 - Elementary occupations" 10 "0 - Armed forces occupations" 11 "X - Not elsewhere classified"
					lab val ilo_job1_ocu_isco08 isco08
					lab var ilo_job1_ocu_isco08 "Occupation (ISCO-08)"		
	
	
		* Aggregate:			
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
					lab var ilo_job1_ocu_aggregate "Occupation (Aggregate) - Main job"	
	
	
	
	* SECOND JOB:
	/* Occupation in the second job is only available at a 4 digit level. */
					
		* ISCO 08 - 1 digit
			gen isco_1dig=int(q62_occ2/1000) if ilo_mjh==2			
	
		* ISCO 08 - 1 digit
			gen ilo_job2_ocu_isco08=isco_1dig 
				replace ilo_job2_ocu_isco08=10 if isco_1dig==0
				replace ilo_job2_ocu_isco08=11 if isco_1dig==. & ilo_mjh==2
					lab val ilo_job2_ocu_isco08 isco08
					lab var ilo_job2_ocu_isco08 "Occupation (ISCO-08) - Second job"	
			
	
		* Aggregate:			
			gen ilo_job2_ocu_aggregate=.
				replace ilo_job2_ocu_aggregate=1 if inrange(ilo_job2_ocu_isco08,1,3)
				replace ilo_job2_ocu_aggregate=2 if inlist(ilo_job2_ocu_isco08,4,5)
				replace ilo_job2_ocu_aggregate=3 if inlist(ilo_job2_ocu_isco08,6,7)
				replace ilo_job2_ocu_aggregate=4 if ilo_job2_ocu_isco08==8
				replace ilo_job2_ocu_aggregate=5 if ilo_job2_ocu_isco08==9
				replace ilo_job2_ocu_aggregate=6 if ilo_job2_ocu_isco08==10
				replace ilo_job2_ocu_aggregate=7 if ilo_job2_ocu_isco08==11
					lab val ilo_job2_ocu_aggregate ocu_aggr_lab
					lab var ilo_job2_ocu_aggregate "Occupation (Aggregate) - Second job"	
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_job1_ins_sector') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
	
	/* NGOs and "Others" are classiied under Private. 
	   "Autonomous" seems to be a part of the government so it is classified as public.  	*/
	
		gen ilo_job1_ins_sector=.
			replace ilo_job1_ins_sector=1 if inlist(q49,1,2) & ilo_lfs==1		// Public
			replace ilo_job1_ins_sector=2 if inrange(q49,3,7) & ilo_lfs==1		// Private
				lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private" 
				lab values ilo_job1_ins_sector ins_sector_lab
				lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job1_job_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			

	
			gen ilo_job1_job_time=.
				replace ilo_job1_job_time=1 if q53==2 & ilo_lfs==1 	// Part-time
				replace ilo_job1_job_time=2 if q53==1 & ilo_lfs==1 	// Full-time
				replace ilo_job1_job_time=3 if q53==. & ilo_lfs==1	// Unknown
					lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
					lab val ilo_job1_job_time job_time_lab
					lab var ilo_job1_job_time "Job (Working time arrangement) - Main job"	
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job1_job_contract') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
		
			gen ilo_job1_job_contract=q52 if ilo_lfs==1
				replace ilo_job1_job_contract=3 if q52==. & ilo_lfs==1
					lab def job_contract_lab 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"
					lab val ilo_job1_job_contract job_contract_lab
					lab var ilo_job1_job_contract "Job (Type of contract)"

		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Formal / Informal Economy ('ilo_job1_ife_prod' 'ilo_job1_ife_nature') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
		
	
    	/* Useful questions:
				* Institutional sector: q49
				* Destination of production: not asked
				* Bookkeeping: asked but not specifically for whom the accounting is made for => not used
				* Registration: q50
				* Status in employment: ilo_job1_ste_icse93 
				* Place of work: q58
				* Size: q54 (the threshold used normally by ILO is 5. Here we only have 10 so we use 
				             10 instead of 5). 
				* Pension funds: q57_a
				* Paid sick leave: q57_c
				* Paid annual leave: not asked */
		
		/* Generation of a variable indicating the social security coverage (to be dropped afterwards):
		
		   An employee is considered covered by social security if he/she if the employer pay for the 
		   employee contributions to pension funds.*/
		   
		* 1) UNIT OF PRODUCTION: FORMAL/INFORMAL SECTOR
		
	    /*Social security*/
		gen social_security=.
			replace social_security=1 if q57_a==1 & ilo_lfs==1              // Pension or retirement fund
	    	replace social_security=2 if q57_a==2 & ilo_lfs==1              // No pension or retirement fund
			replace social_security=3 if social_security==. & ilo_lfs==1    // Not answered
				
		/*Formal/informal sector*/
		gen ilo_job1_ife_prod=.
		    replace ilo_job1_ife_prod=2 if ilo_lfs==1 & ///
			                               ((inlist(q49,1,2,3)) | ///
										   (inlist(q49,4,5,7,.) & q50==1) | ///
										   (inlist(q49,4,5,7,.) & inlist(q50,4,5) & ilo_job1_ste_icse93==1 & social_security==1) | ///
										   (inlist(q49,4,5,7,.) & inlist(q50,4,5) & ilo_job1_ste_icse93==1 & inlist(social_security,2,3) & q58==3 & inlist(q54,3,4,5,6)) | ///
										   (inlist(q49,4,5,7,.) & inlist(q50,4,5) & ilo_job1_ste_icse93!=1 & q58==3 & inlist(q54,3,4,5,6)))
			replace ilo_job1_ife_prod=1 if ilo_lfs==1 & ///
			                               ((inlist(q49,4,5,7,.) & inlist(q50,2,3)) | ///
										   (inlist(q49,4,5,7,.) & inlist(q50,4,5) & ilo_job1_ste_icse93==1 & inlist(social_security,2,3) & q58==3 & inlist(q54,1,2,7,.)) | ///
										   (inlist(q49,4,5,7,.) & inlist(q50,4,5) & ilo_job1_ste_icse93==1 & inlist(social_security,2,3) & q58!=3) | ///
										   (inlist(q49,4,5,7,.) & inlist(q50,4,5) & ilo_job1_ste_icse93!=1 & q58==3 & inlist(q54,1,2,7,.)) | ///
										   (inlist(q49,4,5,7,.) & inlist(q50,4,5) & ilo_job1_ste_icse93!=1 & q58!=3))
			replace ilo_job1_ife_prod=3 if ilo_job1_ife_prod==. & ilo_lfs==1
				    lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 
					lab val ilo_job1_ife_prod ilo_ife_prod_lab
					lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"

	   * 2) NATURE OF JOB: FORMAL/INFORMAL EMPLOYMENT
	   
	   gen ilo_job1_ife_nature=.
	       replace ilo_job1_ife_nature=2 if ilo_lfs==1 & ///
		                                    ((inlist(ilo_job1_ste_icse93,1,6) & social_security==1) | ///
											(inlist(ilo_job1_ste_icse93,2,4) & ilo_job1_ife_prod==2) | ///
											(ilo_job1_ste_icse93==3 & ilo_job1_ife_prod==2))
		   replace ilo_job1_ife_nature=1 if ilo_lfs==1 & ///
		                                    ((inlist(ilo_job1_ste_icse93,1,6) & inlist(social_security,2,3)) | ///
											(inlist(ilo_job1_ste_icse93,2,4) & inlist(ilo_job1_ife_prod,1,3)) | ///
											(ilo_job1_ste_icse93==3 & inlist(ilo_job1_ife_prod,1,3)) | ///
											(ilo_job1_ste_icse93==5))
    			   lab def ife_nature_lab 1 "1 - Persons with informal main job" 2 "2 - Persons with formal main job"
				   lab val ilo_job1_ife_nature ife_nature_lab
				   lab var ilo_job1_ife_nature "Informal / Formal Economy (Nature of job) - Main job"
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Hours of work ('ilo_job1_how') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
		
* Main job:
		
* 1) Weekly hours ACTUALLY worked:
	
	/* NOTE: There are two variables in the dataset related to question 59: q59_hours_old and q59_hours. 
	   The latter is used as it seems to be latest version of the variable.   */
		
			gen ilo_job1_how_actual=q59_hours if ilo_lfs==1
				lab var ilo_job1_how_actual "Weekly hours actually worked in main job"
					
		
			gen ilo_job1_how_actual_bands=.
				replace ilo_job1_how_actual_bands=1 if ilo_job1_how_actual==0
				replace ilo_job1_how_actual_bands=2 if inrange(ilo_job1_how_actual,1,14)
				replace ilo_job1_how_actual_bands=3 if inrange(ilo_job1_how_actual,15,29)
				replace ilo_job1_how_actual_bands=4 if inrange(ilo_job1_how_actual,30,34)
				replace ilo_job1_how_actual_bands=5 if inrange(ilo_job1_how_actual,35,39)
				replace ilo_job1_how_actual_bands=6 if inrange(ilo_job1_how_actual,40,48)
				replace ilo_job1_how_actual_bands=7 if ilo_job1_how_actual>=49 & ilo_job1_how_actual!=.
					lab def how_bands_lab 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 
					lab val ilo_job1_how_actual_bands how_bands_lab
					lab var ilo_job1_how_actual_bands "Weekly hours actually worked bands in main job"
		
* 2) Weekly hours USUALLY worked:	
		* Not available
	
* Second job:

* 1) Weekly hours ACTUALLY worked:
	
	/* NOTE: There are two variables in the dataset related to question 64: q64_hours2_old and q64_hours2. 
	   The latter is used as it seems to be latest version of the variable.   */
	   
		gen ilo_job2_how_actual=q64_hours2 if ilo_mjh==2
					lab var ilo_job2_how_actual "Weekly hours actually worked in second job"
					
		
		gen ilo_job2_how_actual_bands=.
			replace ilo_job2_how_actual_bands=1 if ilo_job2_how_actual==0
			replace ilo_job2_how_actual_bands=2 if inrange(ilo_job2_how_actual,1,14)
			replace ilo_job2_how_actual_bands=3 if inrange(ilo_job2_how_actual,15,29)
			replace ilo_job2_how_actual_bands=4 if inrange(ilo_job2_how_actual,30,34)
			replace ilo_job2_how_actual_bands=5 if inrange(ilo_job2_how_actual,35,39)
			replace ilo_job2_how_actual_bands=6 if inrange(ilo_job2_how_actual,40,48)
			replace ilo_job2_how_actual_bands=7 if ilo_job2_how_actual>=49 & ilo_job2_how_actual!=.
				lab val ilo_job2_how_actual_bands how_bands_lab
				lab var ilo_job2_how_actual_bands "Weekly hours actually worked bands in second job"
		

* 2) Weekly hours USUALLY worked:	
		* Not available
		
		
* All jobs:
		
* 1) Weekly hours ACTUALLY worked:
	
	/* NOTE: There is no variable recording the total number of hours worked in all jobs. As a 
			 proxy we use the sum of hours worked in main and second jobs. */
		
			gen how_job1=ilo_job1_how_actual
				replace how_job1=0 if ilo_job1_how_actual==.
			
			gen how_job2=ilo_job2_how_actual
				replace how_job2=0 if ilo_job2_how_actual==.
				
			gen how_tot= how_job1 + how_job2
				replace how_tot=. if ilo_lfs!=1
			
			
			gen ilo_joball_how_actual=how_tot 
					lab var ilo_joball_how_actual "Weekly hours actually worked in all jobs"
					
		
			gen ilo_joball_how_actual_bands=.
				replace ilo_joball_how_actual_bands=1 if ilo_joball_how_actual==0
				replace ilo_joball_how_actual_bands=2 if inrange(ilo_joball_how_actual,1,14)
				replace ilo_joball_how_actual_bands=3 if inrange(ilo_joball_how_actual,15,29)
				replace ilo_joball_how_actual_bands=4 if inrange(ilo_joball_how_actual,30,34)
				replace ilo_joball_how_actual_bands=5 if inrange(ilo_joball_how_actual,35,39)
				replace ilo_joball_how_actual_bands=6 if inrange(ilo_joball_how_actual,40,48)
				replace ilo_joball_how_actual_bands=7 if ilo_joball_how_actual>=49 & ilo_joball_how_actual!=.
					lab val ilo_joball_how_actual_bands how_bands_lab
					lab var ilo_joball_how_actual_bands "Weekly hours actually worked bands in all jobs"

* 2) Weekly hours USUALLY worked:	
		* Not available
				

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Monthly labour related income ('ilo_joball_lri') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
				
	
	/* NOTES:
	   * In the questionnaire the question about income is not asked to the self-employed. 
	   * Q77: Gross income in the last month (in cash +  kind)
	   * Only asked for main and secondary job together
	   * Unit: local currency		 */
	   
			* All jobs
				
				* Employees
					gen ilo_joball_lri_ees =.
						replace ilo_joball_lri_ees = q77_cashkind if ilo_job1_ste_aggregate==1
							lab var ilo_joball_lri_ees "Monthly earnings of employees in main job"	
				
	
***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_joball_tru') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
		
		/* We cannot identify time-related underemployed workers because there is no 
		   questions asking if the person wanting to work additional hours is currently 
		   AVAILABLE to work additional hours. 		*/

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupational injury ('ilo_joball_inj') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
		
	
	* 1) Cases of non-fatal occupational injuries (within the last 12 months):
	
		gen ilo_joball_oi_case=q68 if ilo_lfs==1
			lab var ilo_joball_oi_case "Cases of non-fatal occupational injury"

	* 2) Days lost due to cases of occupational injuries (within the last 12 months):
	
	* Exclude values 98 and 99 as they mean "Don't know" and "Expect never returning to work"
	
		gen ilo_joball_oi_day=q70 if ilo_lfs==1	
			replace ilo_joball_oi_day=. if inlist(ilo_joball_oi_day, 98,99)
				lab var ilo_joball_oi_day "Days lost due to cases of occupational injury"
		
***********************************************************************************************
*			PART 3.3. UNEMPLOYMENT: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Category of unemployment ('ilo_cat_une') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	
		gen ilo_cat_une=. 
			replace ilo_cat_une=1 if q82==1 & ilo_lfs==2 	// Previously employed
			replace ilo_cat_une=2 if q82==2 & ilo_lfs==2 	// Seeking first job
			replace ilo_cat_une=3 if q82==. & ilo_lfs==2 	// Unknown
				lab def cat_une 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
				lab val ilo_cat_une cat_une
				lab var ilo_cat_une "Category of unemployment"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	
	
	/* Q88: "How long have you been available for work?". 
	   We use q88 to assess the duration of unemployment.
	   NOTE: Lesss than 6 months includes 6 months; 6 months to less than 12 months includes 12 months
	   excludes 6 months; 12 months or more excludes 12 months*/	
		
    		gen ilo_dur_aggregate=.
				replace ilo_dur_aggregate=1 if inlist(q88,1,2) & ilo_lfs==2
				replace ilo_dur_aggregate=2 if q88==3 & ilo_lfs==2
				replace ilo_dur_aggregate=3 if inlist(q88,4,5) & ilo_lfs==2
				replace ilo_dur_aggregate=4 if q88==. & ilo_lfs==2
					lab def ilo_unemp_aggr 1 "Less than 6 months" 2 "6 months to less than 12 months" 3 "12 months or more" 4 "Not elsewhere classified"
					lab val ilo_dur_aggregate ilo_unemp_aggr
					lab var ilo_dur_aggregate "Duration of unemployment (Aggregate)"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
		* No information on previous employment 

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
		* No information on previous employment 
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			General social protection ('ilo_gsp_unschemes') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
		* No information to determine this variable.
	
***********************************************************************************************
*			PART 3.3. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

/*Note: Willingness is not directly asked, but from questions 86 and 89 is possible to determine
non-willingness. */	
	
	gen ilo_olf_dlma=.
		replace ilo_olf_dlma = 1 if q84==1 & q87==2 & ilo_lfs==3 				//Seeking, not available
		replace ilo_olf_dlma = 2 if q84==2 & q87==1 & ilo_lfs==3				//Not seeking, available
		* replace ilo_olf_dlma = 3 if 											//Not seeking, not available, willing
		replace ilo_olf_dlma = 4 if q84==2 & q87==2 & q86==9 & ilo_lfs==3		//Not seeking, not available, not willing
		replace ilo_olf_dlma = 4 if q84==2 & q87==2 & q89==7 & ilo_lfs==3		//Not seeking, not available, not willing
		replace ilo_olf_dlma = 5 if	ilo_olf_dlma==. & ilo_lfs==3				// Not classified 
			lab def dlma_lab 1 "1 - Seeking, not available (Unavailable jobseekers)" 2 "2 - Not seeking, available (Available potential jobseekers)" ///
							 3 "3 - Not seeking, not available, willing (Willing non-jobseekers)" 4 "4 - Not seeking, not available, not willing" 5 "X - Not elsewhere classified"
			lab val ilo_olf_dlma dlma_lab 
			lab var ilo_olf_dlma "Labour market attachment (Degree of)"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reason for not seeking job ('ilo_olf_reason') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

	
	gen ilo_olf_reason=.
		replace ilo_olf_reason=1 if	inlist(q86,2,3,8) & ilo_lfs==3	//Labour market
		replace ilo_olf_reason=2 if	inlist(q86,5,6,7) & ilo_lfs==3	//Personal/Family-related
		replace ilo_olf_reason=3 if q86==9 & ilo_lfs==3				//Does not need/want to work
		replace ilo_olf_reason=4 if (q86==10 | q86==.) & ilo_lfs==3	//Not elsewhere classified
			lab def reasons_lab 1 "1 - Labour market" 2 "2 - Personal / Family-related" ///
							   3 "3 - Does not need/want to work" 4 "4 - Not elsewhere classified"
			lab val ilo_olf_reason reasons_lab 
			lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seeker ('ilo_dis')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

		
	gen ilo_dis=1 if ilo_lfs==3 & q87==1 & ilo_olf_reason==1
			lab def dis_lab 1 "Discouraged job-seekers"
			lab val ilo_dis dis_lab
			lab var ilo_dis "Discouraged job-seekers"
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training ('ilo_neet')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

	gen ilo_neet=1 if ilo_age_aggregate==2 & ilo_lfs!=1 & ilo_edu_attendance==2
			lab def neet_lab 1 "Youth not in education, employment or training"
			lab val ilo_neet neet_lab
			lab var ilo_neet "Youth not in education, employment or training"

***********************************************************************************************
***********************************************************************************************

*			4. SAVE ILO-VARIABLES IN A NEW DATASET

***********************************************************************************************
***********************************************************************************************

* -------------------------------------------------------------
* 	Prepare final datasets
* -------------------------------------------------------------


cd "$outpath"
        
		/*Categories from temporal file deleted */
		drop if lab==1 
		
		/*Only age bands used*/
		drop ilo_age 
		
    	/*Variables computed in-between*/
		drop lab isco08_2digits isco88_2digits isco08 isco88 isic4_2digits isic4 isic3_2digits isic3
	    drop indu_code_job2 isco_1dig social_security how_job1 how_job2 how_tot
		
		compress 
		
	   /*Save dataset including original and ilo variables*/
	
		save ${country}_${source}_${time}_FULL,  replace		
	
	  /* Save file only containing ilo_* variables*/
	
		keep ilo*

		save ${country}_${source}_${time}_ILO, replace

		
