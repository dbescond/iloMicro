* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Brunei Darussalam, 2014
* DATASET USED: Brunei Darussalam LFS 2014
* NOTES: 
* Files created: Standard variables on LFS Brunei Darussalam 2014
* Authors: Marylène Escher
* Who last updated the file: Marylène Escher
* Starting Date: 18 November 2016
* Last updated: 10 March 2017
***********************************************************************************************



***********************************************************************************************
***********************************************************************************************

* 			1. SET UP WORK DIRECTORY, FILE NAME, VARIABLES AND FUNCTIONS

***********************************************************************************************
***********************************************************************************************

clear all 

set more off

global inpath "J:\COMMON\STATISTICS\DPAU\MICRO\BRN\LFS\2014\ORI"
global outpath "J:\COMMON\STATISTICS\DPAU\MICRO\BRN\LFS\2014"


					********************************

					
* Make a tempfile containing the labels for the classifications ISIC and ISCO 

		* NOTE: if you want this do-file to run correctly, run it without breaks!
		
	tempfile labels
		
			* Import Framework
			
			import excel "J:\COMMON\STATISTICS\DPAU\MICRO\_Admin\3_Framework.xlsx", sheet("Variable") firstrow
			
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
		
						
					********************************		


cd "$inpath"

	use "BRN_LFS_2014.dta", clear	


		
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

	gen ilo_wgt=weights
		lab var ilo_wgt "Sample weight"		
		
		
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time period ('ilo_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	* Year 2014
	gen ilo_time=1
		lab def lab_time 1 "2014" 
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

	gen ilo_geo=ur
			lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural"
			lab val ilo_geo ilo_geo_lab
			lab var ilo_geo "Geographical coverage"	
	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_sex=A04
	destring ilo_sex, replace
		lab def ilo_sex_lab 1 "1 - Male" 2 "2 - Female"
		lab var ilo_sex "Sex"
		lab val ilo_sex ilo_sex_lab


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_age=A06
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
			lab def age_by5_lab 1 "0-4" 2 "5-9" 3 "10-14" 4 "15-19" 5 "20-24" 6 "25-29" 7 "30-34" 8 "35-39" ///
								9 "40-44" 10 "45-49" 11 "50-54" 12 "55-59" 13 "60-64" 14 "65+"
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
		
/* ISCED 11 mapping: use UNESCO mapping
					http://www.uis.unesco.org/Education/ISCEDMappings/Pages/default.aspx
					http://www.uis.unesco.org/Education/Documents/isced-2011-en.pdf 			
					
	NOTE: * The question is only asked to people aged 15 and more. So people below the age of 15 
	        are under "Not elsewhere classified".   */

	gen ilo_edu_isced11=.
		replace ilo_edu_isced11=1 if B05==111  										// No schooling
		replace ilo_edu_isced11=2 if inlist(B05,113,211,212)						// Early childhood education
		replace ilo_edu_isced11=3 if inlist(B05,112,213,299)						// Primary education
		replace ilo_edu_isced11=4 if inlist(B05,214,311,312,313)					// Lower secondary education
		replace ilo_edu_isced11=5 if inrange(B05,321,499) | inlist(B05,512,513)		// Upper secondary education
		replace ilo_edu_isced11=6 if inlist(B05,511,599) 							// Post-secondary non-tertiary education
		replace ilo_edu_isced11=7 if inrange(B05,611,712) | inlist(B05,741,749,799)	// Short-cycle tertiary education
		replace ilo_edu_isced11=8 if B05==721 										// Bachelor or equivalent
		replace ilo_edu_isced11=9 if inrange(B05,731,733)							// Master's or equivalent level
		replace ilo_edu_isced11=10 if B05==734 										// Doctoral or equivalent level
		replace ilo_edu_isced11=11 if inlist(B05,0,999,.)							// Not elsewhere classified
			label def isced_11_lab 1 "X - No schooling" 2 "0 - Early childhood education" 3 "1 - Primary education" 4 "2 - Lower secondary education" ///
							5 "3 - Upper secondary education" 6 "4 - Post-secondary non-tertiary education" 7 "5 - Short-cycle tertiary education" ///
							8 "6 - Bachelor's or equivalent level" 9 "7 - Master's or equivalent level" 10 "8 - Doctoral or equivalent level" 11 "9 - Not elsewhere classified"
			label val ilo_edu_isced11 isced_11_lab
			lab var ilo_edu_isced11 "Level of education (ISCED 11)"
	
	gen ilo_edu_aggregate=.
		replace ilo_edu_aggregate=1 if inlist(ilo_edu_isced11,1,2)  	// Less than basic
		replace ilo_edu_aggregate=2 if inlist(ilo_edu_isced11,3,4)		// Basic
		replace ilo_edu_aggregate=3 if inlist(ilo_edu_isced11,5,6)		// Intermediate
		replace ilo_edu_aggregate=4 if inrange(ilo_edu_isced11,7,10)	// Advanced
		replace ilo_edu_aggregate=5 if ilo_edu_isced11==11				// Level not stated
			label def edu_aggr_lab 1 "Less than basic" 2 "Basic" 3 "Intermediate" 4 "Advanced" 5 "Level not stated"
			label val ilo_edu_aggregate edu_aggr_lab
			label var ilo_edu_aggregate "Level of education (Aggregate)"
				
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education attendance ('ilo_edu_attendance')  	[done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

/* NOTE: The question is only asked to people aged 15 and more. So people below the age of 15 
         are under "Not elsewhere classified".   */

	gen ilo_edu_attendance=.
		replace ilo_edu_attendance=1 if Education_status==1					// Attending 
		replace ilo_edu_attendance=2 if inlist(Education_status,2,3)		// Not attending 
		replace ilo_edu_attendance=3 if inlist(Education_status,0,.)		// Not elsewhere classified 
			label def edu_att_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified" 
			label val ilo_edu_attendance edu_att_lab
			label var ilo_edu_attendance "Education (Attendance)"


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Disability status ('ilo_dsb') 	[done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

	* Not available		

		

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

	drop ilo_age

			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Labour Force Status ('ilo_lfs') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	 gen ilo_lfs=.
		replace ilo_lfs=1 if C01==1 & ilo_wap==1 								// Employed
		replace ilo_lfs=1 if C04==2 & ilo_wap==1 								// Employed
		replace ilo_lfs=1 if inlist(C05,1,2) & ilo_wap==1 						// Employed
		replace ilo_lfs=1 if inrange(C07,1,4) & ilo_wap==1 						// Employed
		replace ilo_lfs=1 if C08==1 & ilo_wap==1 								// Employed
		replace ilo_lfs=1 if C09==1 & ilo_wap==1 								// Employed
		replace ilo_lfs=2 if ilo_lfs!=1 & G01==1 & inlist(G09,1,2) & ilo_wap==1 // Unemployed
		replace ilo_lfs=2 if ilo_lfs!=1 & G02==1 & inlist(G09,1,2) & ilo_wap==1 // Unemployed	
		replace ilo_lfs=3 if ilo_lfs!=1 & ilo_lfs!=2 & ilo_wap==1  				// Outside the labour force
				label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside the Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status"
	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_mjh=.
		replace ilo_mjh=2 if D22==1 & ilo_lfs==1
		replace ilo_mjh=1 if inlist(D22,2,.) & ilo_lfs==1
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

	* MAIN JOB:
	
		* Detailled categories:
			gen ilo_job1_ste_icse93=.
				replace ilo_job1_ste_icse93=1 if inlist(D05,1,2)		// Employees
				replace ilo_job1_ste_icse93=2 if D05==3					// Employers
				replace ilo_job1_ste_icse93=3 if D05==4					// Own-account workers
				* replace ilo_job1_ste_icse93=4 if 						// Producer cooperatives
				replace ilo_job1_ste_icse93=5 if D05==5					// Contributing family workers
				replace ilo_job1_ste_icse93=6 if (D05==6 | D05==.)		// Not classifiable
				replace ilo_job1_ste_icse93=. if ilo_lfs!=1
					label def label_ilo_ste_icse93 1 "1 - Employees" 2 "2 - Employers" 3 "3 - Own-account workers"  ///
													4 "4 - Members of producers cooperatives" 5 "5 - Contributing family workers" ///
													6 "6 - Workers not classifiable by status"
					label val ilo_job1_ste_icse93 label_ilo_ste_icse93
					label var ilo_job1_ste_icse93 "Status in employment (ICSE 93) - Main job"

		* Aggregate categories 
			gen ilo_job1_ste_aggregate=.
				replace ilo_job1_ste_aggregate=1 if ilo_job1_ste_icse93==1				// Employees
				replace ilo_job1_ste_aggregate=2 if inrange(ilo_job1_ste_icse93,2,5)	// Self-employed
				replace ilo_job1_ste_aggregate=3 if ilo_job1_ste_icse93==6				// Not elsewhere classified
					lab def ste_aggr_lab 1 "1 - Employees" 2 "2 - Self-employed" 3 "3 - Not elsewhere classified"
					lab val ilo_job1_ste_aggregate ste_aggr_lab
					label var ilo_job1_ste_aggregate "Status in employment (Aggregate) - Main job" 

					
	* SECOND JOB:
	
		* Detailled categories:
		gen ilo_job2_ste_icse93=.
				replace ilo_job2_ste_icse93=1 if inlist(D25,1,2)	// Employees
				replace ilo_job2_ste_icse93=2 if D25==3				// Employers
				replace ilo_job2_ste_icse93=3 if D25==4				// Own-account workers
				* replace ilo_job2_ste_icse93=4 if 					// Producer cooperatives
				replace ilo_job2_ste_icse93=5 if D25==5				// Contributing family workers
				replace ilo_job2_ste_icse93=6 if D25==6 | D25==.	// Not classifiable
				replace ilo_job2_ste_icse93=. if ilo_mjh!=2
					label val ilo_job2_ste_icse93 label_ilo_ste_icse93
					label var ilo_job2_ste_icse93 "Status in employment (ICSE 93) - Second job"

		* Aggregate categories 
			gen ilo_job2_ste_aggregate=.
				replace ilo_job2_ste_aggregate=1 if ilo_job2_ste_icse93==1				// Employees
				replace ilo_job2_ste_aggregate=2 if inrange(ilo_job2_ste_icse93,2,5)	// Self-employed
				replace ilo_job2_ste_aggregate=3 if ilo_job2_ste_icse93==6				// Not elsewhere classified
					lab val ilo_job2_ste_aggregate ste_aggr_lab
					label var ilo_job2_ste_aggregate "Status in employment (Aggregate) - Second job" 

				
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------



	/* National classification is used (BDSIC 2011), based on ISIC Rev. 4 			
	
	   NOTE: Question D13 enables us to isolate DOMESTIC WORKERS. 
			 Question D14 (economic activity) is NOT asked to domestic workers, however it seems 
			 clear that they belong to the class "97 - Activities of households as employers of 
			 domestic personnel" of ISIC Rev.4 (2 digits), so they are recoded this way. 				*/
		
		
			append using `labels'
			*use value label from this variable, afterwards drop everything related to this append
			
			
				* MAIN JOB:
					
					* ISIC Rev. 4 - 2 digit
						gen isic2dig = int(D14/100)
							replace isic2dig=97 if D13==2 & ilo_lfs==1 		// Domestic workers
						
						gen ilo_job1_eco_isic4_2digits=isic2dig if ilo_lfs==1
							lab values ilo_job1_eco_isic4_2digits isic4_2digits
							lab var ilo_job1_eco_isic4_2digits "Economic activity (ISIC Rev. 4), 2 digit level - main job"

					* ISIC Rev. 4 - 1 digit
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
							replace ilo_job1_eco_isic4=22 if ilo_job1_eco_isic4_2digits==.
							replace ilo_job1_eco_isic4=. if ilo_lfs!=1
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
		
			* ISIC Rev. 4 - 2 digit
						gen isic2dig_job2 = int(D27/100)
							replace isic2dig_job2=97 if D26==2 & ilo_mjh==2 		// Domestic workers
					
						gen ilo_job2_eco_isic4_2digits=isic2dig_job2 if ilo_mjh==2
							lab values ilo_job2_eco_isic4_2digits isic4_2digits
							lab var ilo_job2_eco_isic4_2digits "Economic activity (ISIC Rev. 4), 2 digit level - second job"			
			
			* ISIC Rev. 4 - 1 digit
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
							replace ilo_job2_eco_isic4=22 if ilo_job2_eco_isic4_2digits==.
							replace ilo_job2_eco_isic4=. if ilo_mjh!=2
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
		

		* Dropping the variables not used anymore:	
			drop isic2dig isic2dig_job2

			

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_job1_ocu_isco08') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
	
	/* The datasets provides the occupation as ISCO 08 - 4 digits.  		*/
	   

	* MAIN JOB:
			gen occup_2dig=int(D02/1000) if ilo_lfs==1 
	
		* ISCO 08 - 2 digits:
			gen ilo_job1_ocu_isco08_2digits=occup_2dig if ilo_lfs==1
							lab values ilo_job1_ocu_isco08_2digits isco08_2digits
							lab var ilo_job1_ocu_isco08_2digits "Occupation (ISCO-08), 2 digit level"

		* ISCO 08 - 1 digit:
			gen occup_1dig=int(ilo_job1_ocu_isco08_2digits/10) if ilo_lfs==1
		
			gen ilo_job1_ocu_isco08=occup_1dig if ilo_lfs==1
				replace ilo_job1_ocu_isco08=10 if occup_1dig==0 & ilo_lfs==1
				replace ilo_job1_ocu_isco08=11 if occup_1dig==. & ilo_lfs==1
							lab values ilo_job1_ocu_isco08 isco08
							lab var ilo_job1_ocu_isco08 "Occupation (ISCO-08) - main job"
	
	
		* Aggregate:
			gen ilo_job1_ocu_aggregate=.
				replace ilo_job1_ocu_aggregate=1 if inrange(ilo_job1_ocu_isco08,1,3)
				replace ilo_job1_ocu_aggregate=2 if inlist(ilo_job1_ocu_isco08,4,5)
				replace ilo_job1_ocu_aggregate=3 if inlist(ilo_job1_ocu_isco08,6,7)
				replace ilo_job1_ocu_aggregate=4 if ilo_job1_ocu_isco08==8
				replace ilo_job1_ocu_aggregate=5 if ilo_job1_ocu_isco08==9
				replace ilo_job1_ocu_aggregate=6 if ilo_job1_ocu_isco08==10
				replace ilo_job1_ocu_aggregate=7 if ilo_job1_ocu_isco08==11
				replace ilo_job1_ocu_aggregate=. if ilo_lfs!=1
					lab def ocu_aggr_lab 1 "1 - Managers, professionals, and technicians" 2 "2 - Clerical, service and sales workers" 3 "3 - Skilled agricultural and trades workers" ///
										4 "4 - Plant and machine operators, and assemblers" 5 "5 - Elementary occupations" 6 "6 - Armed forces" 7 "7 - Not elsewhere classified"
					lab val ilo_job1_ocu_aggregate ocu_aggr_lab
					lab var ilo_job1_ocu_aggregate "Occupation (Aggregate) - Main job"	
	
	
	* SECOND JOB:
			gen occup_2dig_job2=int(D24/1000) if ilo_mjh==2 

	
		* ISCO 08 - 2 digits:
			gen ilo_job2_ocu_isco08_2digits=occup_2dig_job2 if ilo_mjh==2
							lab values ilo_job2_ocu_isco08_2digits isco08_2digits
							lab var ilo_job2_ocu_isco08_2digits "Occupation (ISCO-08), 2 digit level - second job"
	
	
		* ISCO 08 - 1 digit:
			gen occup_1dig_job2=int(ilo_job2_ocu_isco08_2digits/10) if ilo_mjh==2
		
			gen ilo_job2_ocu_isco08=occup_1dig_job2 if ilo_mjh==2
				replace ilo_job2_ocu_isco08=11 if occup_1dig_job2==. & ilo_mjh==2
							lab values ilo_job2_ocu_isco08 isco08
							lab var ilo_job2_ocu_isco08 "Occupation (ISCO-08) - second job"
	
		* Aggregate:
			gen ilo_job2_ocu_aggregate=.
				replace ilo_job2_ocu_aggregate=1 if inrange(ilo_job2_ocu_isco08,1,3)
				replace ilo_job2_ocu_aggregate=2 if inlist(ilo_job2_ocu_isco08,4,5)
				replace ilo_job2_ocu_aggregate=3 if inlist(ilo_job2_ocu_isco08,6,7)
				replace ilo_job2_ocu_aggregate=4 if ilo_job2_ocu_isco08==8
				replace ilo_job2_ocu_aggregate=5 if ilo_job2_ocu_isco08==9
				replace ilo_job2_ocu_aggregate=6 if ilo_job2_ocu_isco08==10
				replace ilo_job2_ocu_aggregate=7 if ilo_job2_ocu_isco08==11
				replace ilo_job2_ocu_aggregate=. if ilo_mjh!=2
					lab val ilo_job2_ocu_aggregate ocu_aggr_lab
					lab var ilo_job2_ocu_aggregate "Occupation (Aggregate) - second job"	
	
		drop occup_2dig_job2 occup_1dig_job2 occup_2dig occup_1dig


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector ('ilo_job1_ins_sector') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
	
	* MAIN JOB:
	
		gen ilo_job1_ins_sector=.
			replace ilo_job1_ins_sector=1 if inlist(D15,1,2) & ilo_lfs==1			// Public
			replace ilo_job1_ins_sector=2 if ilo_job1_ins_sector!=1 & ilo_lfs==1	// Private
				lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private" 
				lab values ilo_job1_ins_sector ins_sector_lab
				lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities - main job"
	
	* SECOND JOB:
	
		gen ilo_job2_ins_sector=.
			replace ilo_job2_ins_sector=1 if inlist(D28,1,2) & ilo_mjh==2			// Public
			replace ilo_job2_ins_sector=2 if ilo_job2_ins_sector!=1 & ilo_mjh==2	// Private
				lab values ilo_job2_ins_sector ins_sector_lab
				lab var ilo_job2_ins_sector "Institutional sector (private/public) of economic activities - second job"
	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Hours of work ('ilo_how') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
	
		* MAIN JOB:
			
			* 1) Weekly hours ACTUALLY worked:
			
				gen ilo_job1_how_actual = round(E02A8T) if ilo_lfs==1
						lab var ilo_job1_how_actual "Weekly hours actually worked in main job"
				
				gen ilo_job1_how_actual_bands=.
					replace ilo_job1_how_actual_bands=1 if ilo_job1_how_actual==0
					replace ilo_job1_how_actual_bands=2 if ilo_job1_how_actual>=1 & ilo_job1_how_actual<=14
					replace ilo_job1_how_actual_bands=3 if ilo_job1_how_actual>=15 & ilo_job1_how_actual<=29
					replace ilo_job1_how_actual_bands=4 if ilo_job1_how_actual>=30 & ilo_job1_how_actual<=34
					replace ilo_job1_how_actual_bands=5 if ilo_job1_how_actual>=35 & ilo_job1_how_actual<=39
					replace ilo_job1_how_actual_bands=6 if ilo_job1_how_actual>=40 & ilo_job1_how_actual<=48
					replace ilo_job1_how_actual_bands=7 if ilo_job1_how_actual>=49 & ilo_job1_how_actual!=.
					replace ilo_job1_how_actual_bands=8 if ilo_job1_how_actual==. & ilo_lfs==1
						lab def how_bands_lab 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"
						lab val ilo_job1_how_actual_bands how_bands_lab
						lab var ilo_job1_how_actual_bands "Weekly hours actually worked bands in main job"		

			* 2) Weekly hours USUALLY worked:
		
				gen ilo_job1_how_usual=round(E011T) if ilo_lfs==1
						lab var ilo_job1_how_usual "Weekly hours usually worked in main job"
		
		
		* SECOND JOB
			
			 * 1) Weekly hours ACTUALLY worked:
			
				gen ilo_job2_how_actual=round(E02B8T) if ilo_mjh==2
						lab var ilo_job2_how_actual "Weekly hours actually worked in second job"
				
				gen ilo_job2_how_actual_bands=.
					replace ilo_job2_how_actual_bands=1 if ilo_job2_how_actual==0
					replace ilo_job2_how_actual_bands=2 if ilo_job2_how_actual>=1 & ilo_job2_how_actual<=14
					replace ilo_job2_how_actual_bands=3 if ilo_job2_how_actual>=15 & ilo_job2_how_actual<=29
					replace ilo_job2_how_actual_bands=4 if ilo_job2_how_actual>=30 & ilo_job2_how_actual<=34
					replace ilo_job2_how_actual_bands=5 if ilo_job2_how_actual>=35 & ilo_job2_how_actual<=39
					replace ilo_job2_how_actual_bands=6 if ilo_job2_how_actual>=40 & ilo_job2_how_actual<=48
					replace ilo_job2_how_actual_bands=7 if ilo_job2_how_actual>=49 & ilo_job2_how_actual!=.
					replace ilo_job2_how_actual_bands=8 if ilo_job2_how_actual==. & ilo_mjh==2
					replace ilo_job2_how_actual_bands=. if ilo_mjh!=2
						lab val ilo_job2_how_actual_bands how_bands_lab
						lab var ilo_job2_how_actual_bands "Weekly hours actually worked bands in second job"
		
			* 2) Weekly hours USUALLY worked:
		
				gen ilo_job2_how_usual=round(E012T) if ilo_mjh==2
						lab var ilo_job2_how_usual "Weekly hours usually worked in second job"
		
		
		* ALL JOBS:
		
			* 1) Weekly hours ACTUALLY worked:

				gen ilo_joball_how_actual=round(E02Total) if ilo_lfs==1
					lab var ilo_joball_how_actual "Weekly hours actually worked in all jobs"		
		
				gen ilo_joball_how_actual_bands=.
					replace ilo_joball_how_actual_bands=1 if ilo_joball_how_actual==0
					replace ilo_joball_how_actual_bands=2 if ilo_joball_how_actual>=1 & ilo_joball_how_actual<=14
					replace ilo_joball_how_actual_bands=3 if ilo_joball_how_actual>=15 & ilo_joball_how_actual<=29
					replace ilo_joball_how_actual_bands=4 if ilo_joball_how_actual>=30 & ilo_joball_how_actual<=34
					replace ilo_joball_how_actual_bands=5 if ilo_joball_how_actual>=35 & ilo_joball_how_actual<=39
					replace ilo_joball_how_actual_bands=6 if ilo_joball_how_actual>=40 & ilo_joball_how_actual<=48
					replace ilo_joball_how_actual_bands=7 if ilo_joball_how_actual>=49 & ilo_joball_how_actual!=.
					replace ilo_joball_how_actual_bands=8 if ilo_joball_how_actual_bands==. & ilo_lfs==1
						lab val ilo_joball_how_actual_bands how_bands_lab
						lab var ilo_joball_how_actual_bands "Weekly hours actually worked bands in all jobs"
					

			* 2) Weekly hours USUALLY worked:
			
				gen ilo_joball_how_usual=round(E013T) if ilo_lfs==1
						lab var ilo_joball_how_usual "Weekly hours usually worked in all jobs"
	


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job1_job_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
		
	/* The normal number of hours worked is 40 per week.		*/
	   
	   * MAIN JOB
	   gen ilo_job1_job_time=.
				replace ilo_job1_job_time=1 if ilo_job1_how_usual<40 
				replace ilo_job1_job_time=2 if ilo_job1_how_usual>=40 & ilo_job1_how_usual!=.
				replace ilo_job1_job_time=3 if ilo_job1_job_time!=1 & ilo_job1_job_time!=2 & ilo_lfs==1
					lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
					lab val ilo_job1_job_time job_time_lab
					lab var ilo_job1_job_time "Job (Working time arrangement) - Main job"	

		* ALL JOBS
		 gen ilo_joball_job_time=.
				replace ilo_joball_job_time=1 if ilo_joball_how_usual<40 
				replace ilo_joball_job_time=2 if ilo_joball_how_usual>=40 & ilo_joball_how_usual!=.
				replace ilo_joball_job_time=3 if ilo_joball_job_time!=1 & ilo_joball_job_time!=2 & ilo_lfs==1
					lab val ilo_joball_job_time job_time_lab
					lab var ilo_joball_job_time "Job (Working time arrangement) - All jobs"	
			
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job1_job_contract') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			

		gen ilo_job1_job_contract=.
			replace ilo_job1_job_contract=1 if D07==1 & ilo_lfs==1		// Permanent
			replace ilo_job1_job_contract=2 if D07==2 & ilo_lfs==1		// Temporary
			replace ilo_job1_job_contract=3 if ilo_job1_job_contract!=1 & ilo_job1_job_contract!=2 & ilo_lfs==1		// Unknown
				lab def contr_type 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"
				lab val ilo_job1_job_contract contr_type
				lab var ilo_job1_job_contract "Job (Type of contract)"
				

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Formal / Informal Economy ('ilo_job1_ife_prod' 'ilo_job1_ife_nature') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
	
	/* Questions used: * D15 - Institutional sector
					   * C05 - Destination of production	
					   * D16 - Incorporated compagny
					   * D18 - Bookkeeping
					   * D17 - Registration
					   * D19 - Size of the company	
					   * D20 - Location of workplace
					   * D13 - Domestic workers
				
					   * D10-12 - Social Security Coverage: an employee is covered by social security if he/she says yes to D.10(employer contributes to social security) 
 	*/

	
	* 1) Unit of production
	
		gen social_security=.
			replace social_security=1 if (D10==1 & ilo_lfs==1)
	
		gen ilo_job1_ife_prod=.
		replace ilo_job1_ife_prod=2 if inlist(D15,1,2,4) | (D15==3 & C05!=4 & D16==1) | (D15==3 & C05!=4 & D16!=1 & D18==1) | (D15==3 & C05!=4 & D16!=1 & D18!=1 & D17==1)
	
		replace ilo_job1_ife_prod=3 if (inlist(D15,3,5,.) & C05==4 ) | (C05!=4 & D13==2)
 	
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
*			Monthly labour related income ('ilo_job1_lri') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
	
	/* Questions F01-F13 deal with labour related income of the employees. Workers are asked how much
	   they earned in cash last time they were paid (F05) and what period the earnings cover (F06: 
	   1 month, 2 weeks, 1 week, 1 day or other).  
	   
	   In addition, they are asked if their employer provides them with housing, food, transports, 
	   clothing and transport (F09). They estimates as well the value of such kind (F10) and precise 
	   whether they had to pay anything for that (F11-12). The period covered by th payment in kinds 
	   is not clearly specified, but it seems reasonable to assume that the period is the same as for 
	   the payment in cash.
	   
	   To convert daily, weekly and 2-weekly income into monthly income, the following factors were used:
			- monthly income = (365/12)*daily income
			- monthly income = ((365/7)/12)*weekly income
			- monthly income = ((365/14)/12)* 2-week-income			*/
			

	* Employees:
		gen cash_month=.
			replace cash_month = F05A if ilo_job1_ste_aggregate==1 & F06==4
			replace cash_month = F05A * ((365/14)/12) if ilo_job1_ste_aggregate==1 & F06==3
			replace cash_month = F05A * ((365/7)/12) if ilo_job1_ste_aggregate==1 & F06==2
			replace cash_month = F05A * (365/12) if ilo_job1_ste_aggregate==1 & F06==1
			replace cash_month = 0 if cash_month==. & ilo_job1_ste_aggregate==1
			
		gen kind_month=.
			replace kind_month = F10 - F12 if ilo_job1_ste_aggregate==1 & F06==4
			replace cash_month = (F10 - F12) * ((365/14)/12)  if ilo_job1_ste_aggregate==1 & F06==3
			replace kind_month = (F10 - F12) * ((365/7)/12) if ilo_job1_ste_aggregate==1 & F06==2
			replace kind_month = (F10 - F12) * (365/12) if ilo_job1_ste_aggregate==1 & F06==1
			replace kind_month = 0 if kind_month==. & ilo_job1_ste_aggregate==1
			
			
		gen ilo_job1_lri_ees= cash_month + kind_month if ilo_job1_ste_aggregate==1
			replace ilo_job1_lri_ees=. if F05A==. & F10==.
			lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"
	
		drop cash_month kind_month
	

	* Self-employed:
	
		gen lri_slf_cash=F01 if ilo_job1_ste_aggregate==2
			replace lri_slf_cash=0 if lri_slf_cash==. & ilo_job1_ste_aggregate==2
		
		gen lri_slf_kind=F03 if ilo_job1_ste_aggregate==2
			replace lri_slf_kind=0 if lri_slf_kind==. & ilo_job1_ste_aggregate==2
		
		
		gen ilo_job1_lri_slf= lri_slf_cash + lri_slf_kind if ilo_job1_ste_aggregate==2
			replace ilo_job1_lri_slf=. if F01==. & F03==.
			lab var ilo_job1_lri_slf "Monthly labour related income of self-employed in main job"	
			
	   drop lri_slf_cash lri_slf_kind
	   
	   
	
***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_joball_tru') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
		
  * Threshold used: 40 hours/week (normal number of hours weekly worked in the country) 	
		 	
				gen ilo_joball_tru=.
					replace ilo_joball_tru=1 if (ilo_lfs==1 & E07==1 & E08==1 & ilo_joball_how_usual<40)
						lab def ilo_tru 1 "Time-related underemployed"
						lab val ilo_joball_tru ilo_tru
						lab var ilo_joball_tru "Time-related underemployed"			
					

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupational injury ('ilo_joball_inj') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
		
		* Not available
		
		
	
***********************************************************************************************
*			PART 3.3. UNEMPLOYMENT: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Category of unemployment ('ilo_cat_une') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	
			gen ilo_cat_une=.
				replace ilo_cat_une = 1 if H01==1 & ilo_lfs==2		// Previously employed
				replace ilo_cat_une = 2 if H01==2 & ilo_lfs==2		// Seeking first job
				replace ilo_cat_une = 3 if H01==. & ilo_lfs==2		// Unknown
					lab def cat_une 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" ///
									3 "3 - Unknown"
					lab val ilo_cat_une cat_une
					lab var ilo_cat_une "Category of unemployment"


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	
		* Details:
		
			gen ilo_dur_details=.
				replace ilo_dur_details=1 if G06==1 & ilo_lfs==2 		// Less than 1 month
				replace ilo_dur_details=2 if G06==2 & ilo_lfs==2		// 1 month to less than 3 months
				replace ilo_dur_details=3 if G06==3 & ilo_lfs==2		// 3 months to less than 6 months
				replace ilo_dur_details=4 if G06==4 & ilo_lfs==2		// 6 months to less than 12 months
				replace ilo_dur_details=5 if G06==5 & ilo_lfs==2		// 12 months to less than 24 months
				replace ilo_dur_details=6 if G06==6 & ilo_lfs==2		// 24 months or more
				replace ilo_dur_details=7 if ilo_dur_details==. & ilo_lfs==2		// Not elsewhere classified
					lab def ilo_unemp_det 1 "Less than 1 month" 2 "1 month to less than 3 months" 3 "3 months to less than 6 months" ///
										  4 "6 months to less than 12 months" 5 "12 months to less than 24 months" 6 "24 months or more" 7 "Not elsewhere classified"
					lab values ilo_dur_details ilo_unemp_det
					lab var ilo_dur_details "Duration of unemployment (Details)"
		

		* Aggregate:
		
			gen ilo_dur_aggregate=.
				replace ilo_dur_aggregate=1 if inrange(ilo_dur_details,1,3) & ilo_lfs==2 	// Less than 6 months
				replace ilo_dur_aggregate=2 if ilo_dur_details==4 & ilo_lfs==2				// 6 months to less than 12 months
				replace ilo_dur_aggregate=3 if inlist(ilo_dur_details,5,6) & ilo_lfs==2		// 12 months or more
				replace ilo_dur_aggregate=4 if inlist(ilo_dur_details,7,.) & ilo_lfs==2		// Not elsewhere classified
					lab def ilo_unemp_agr 1 "Less than 6 months" 2 "6 months to less than 12 months" ///
										  3 "12 months or more" 4 "Not elsewhere classified"
					lab values ilo_dur_aggregate ilo_unemp_agr
					lab var ilo_dur_aggregate "Duration of unemployment (Aggregate)"
		

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

		/* The datasets provides the economic activity as ISIC Rev.4 - 4 digits.  		*/
		
					
					* ISIC Rev. 4 - 2 digit
						gen isic2dig_prev = int(H06/100)
						
						gen ilo_preveco_isic4_2digits=isic2dig_prev if ilo_cat_une==1
							lab values ilo_preveco_isic4_2digits isic4_2digits
							

					* ISIC Rev. 4 - 1 digit
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
							replace ilo_preveco_isic4=22 if ilo_preveco_isic4_2digits==.
							replace ilo_preveco_isic4=. if ilo_cat_une!=1
								lab val ilo_preveco_isic4 isic4
								lab var ilo_preveco_isic4 "Previous economic activity (ISIC Rev. 4)"
			
			
					* Aggregated level 
						gen ilo_preveco_aggregate=.
							replace ilo_preveco_aggregate=1 if ilo_preveco_isic4==1
							replace ilo_preveco_aggregate=2 if ilo_preveco_isic4==3
							replace ilo_preveco_aggregate=3 if ilo_preveco_isic4==6
							replace ilo_preveco_aggregate=4 if inlist(ilo_preveco_isic4,2,4,5)
							replace ilo_preveco_aggregate=5 if inrange(ilo_preveco_isic4,7,14)
							replace ilo_preveco_aggregate=6 if inrange(ilo_preveco_isic4,15,21)
							replace ilo_preveco_aggregate=7 if ilo_preveco_isic4==22
								lab val ilo_preveco_aggregate eco_aggr_lab
								lab var ilo_preveco_aggregate "Previous economic activity (Aggregate)"
						
						drop isic2dig_prev ilo_preveco_isic4_2digits
				
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
		/* The datasets provides the occupation as ISCO 08 - 4 digits.  		*/
	      
	* MAIN JOB:
			gen prevocu_1dig=int(H03/10000) if ilo_cat_une==1 
	

		* ISCO 08 - 1 digit:
			
			gen ilo_prevocu_isco08=prevocu_1dig if ilo_cat_une==1
				replace ilo_prevocu_isco08=10 if prevocu_1dig==0 & ilo_cat_une==1
				replace ilo_prevocu_isco08=11 if prevocu_1dig==. & ilo_cat_une==1
							lab values ilo_prevocu_isco08 isco08
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
				replace ilo_prevocu_aggregate=. if ilo_cat_une!=1
					lab val ilo_prevocu_aggregate ocu_aggr_lab
					lab var ilo_prevocu_aggregate "Previous occupation (Aggregate)"	
	
		drop prevocu_1dig isco08_2digits isco88_2digits isco08 isco88 isic4_2digits isic4 isic3_2digits isic3
		drop if missing(ilo_key) // To drop empty lines added for the labels

	
	
	
***********************************************************************************************
*			PART 3.3. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
	
	/* For the category "not seeking, not available, not willing" we do not condition on 
	   availability (question G09) because if the person says that she does not want to work 
	   (question G07) he/she does not have to answer to question on avalability, but skip 
	   directly to question H01.			*/
	    
		gen ilo_olf_dlma=.
			replace ilo_olf_dlma=1 if G01==1 & G09==3 & ilo_lfs==3				// Seeking, not available
			replace ilo_olf_dlma=2 if G01==2 & inlist(G09,1,2) & ilo_lfs==3		// Not seeking, available
			replace ilo_olf_dlma=3 if G01==2 & G09==3 & G07==1 & ilo_lfs==3		// Not seeking, not available, willing
			replace ilo_olf_dlma=4 if G01==2 & G07==2 & ilo_lfs==3				// Not seeking, not available, not willing
			replace ilo_olf_dlma=5 if ilo_olf_dlma==. & ilo_lfs==3				// Not elsewhere classified
				lab def dlma 1 "1 - Seeking, not available (Unavailable jobseekers)" 2 "2 - Not seeking, available (Available potential jobseekers)" ///
							 3 "3 - Not seeking, not available, willing (Willing non-jobseekers)" 4 "4 - Not seeking, not available, not willing" ///
							 5 "5 - Not elsewhere classified"
				lab val ilo_olf_dlma dlma
				lab var ilo_olf_dlma "Labour market attachment (Degree of)"

	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reason for not seeking job ('ilo_olf_reason') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

		gen ilo_olf_reason=.
			replace ilo_olf_reason=1 if	inrange(G08,1,7) & ilo_lfs==3			//Labour market
			replace ilo_olf_reason=2 if	inrange(G08,8,12) & ilo_lfs==3			//Personal/Family-related
			replace ilo_olf_reason=3 if G08==13 & ilo_lfs==3					//Does not need/want to work
			replace ilo_olf_reason=3 if G07==2 & ilo_lfs==3						//Does not need/want to work
			replace ilo_olf_reason=4 if G08==14 & ilo_lfs==3					//Not elsewhere classified
			replace ilo_olf_reason=4 if ilo_olf_reason==. & ilo_lfs==3			//Not elsewhere classified
				lab def reasons_lab 1 "1 - Labour market" 2 "2 - Personal / Family-related" ///
									3 "3 - Does not need/want to work" 4 "4 - Not elsewhere classified"
				lab val ilo_olf_reason reasons_lab 
				lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"

			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seeker ('ilo_dis')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
		
	gen ilo_dis=1 if ilo_lfs==3 & inlist(G09,1,2) & G01==2 & ilo_olf_reason==1
			lab def dis_lab 1 "Discouraged job-seekers"
			lab val ilo_dis dis_lab
			lab var ilo_dis "Discouraged job-seekers"
		
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training ('ilo_neet')  
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
		saveold BRN_LFS_2014_FULL, version(12) replace


* 2 - Dataset with only 'ILO' variables
	
		keep ilo*
		saveold BRN_LFS_2014_ILO, version(12) replace
