* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Vietnam, 2nd Quarter 2015
* DATASET USED: Vietnam LFS 2nd Quarter 2015
* NOTES: 
* Files created: Standard variables on LFS Vietnam 2nd Quarter 2015 
* Authors: Marylène Escher
* Who last updated the file: Marylène Escher
* Starting Date: 19 October 2016
* Last updated: 21 October 2016
***********************************************************************************************



***********************************************************************************************
***********************************************************************************************

* 			1. SET UP WORK DIRECTORY, FILE NAME, VARIABLES AND FUNCTIONS

***********************************************************************************************
***********************************************************************************************

clear all 

set more off

global inpath "I:\COMMON\A6 Microdatasets\VNM\LFS\2015Q2\ORI"
global outpath "I:\COMMON\A6 Microdatasets\VNM\LFS\2015Q2"


					********************************

					
* Make a tempfile containing the labels for the classifications ISIC and ISCO 

		* NOTE: if you want this do-file to run correctly, run it without breaks!
		
	tempfile labels
		
			* Import Framework
			import excel "I:\COMMON\A6 Microdatasets\3_Framework.xlsx", sheet("Variable") firstrow

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

	use "VNM_2015-Q2_LFS", clear	

		
		
		
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
	

	gen ilo_wgt=cal_weigh_final_dc
		lab var ilo_wgt "Sample weight"		
		
		
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time period ('ilo_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*

	* 2nd quarter of 2015
	gen ilo_time=1
		lab def lab_time 1 "2015Q2" 
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


	gen ilo_geo=ttnt
		lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural"
		lab val ilo_geo ilo_geo_lab
		lab var ilo_geo "Geographical coverage"	
	
	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------


	gen ilo_sex=C3
		lab def ilo_sex_lab 1 "1 - Male" 2 "2 - Female"
		lab var ilo_sex "Sex"
		lab val ilo_sex ilo_sex_lab


		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------


	gen ilo_age=C5
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
		
/* ISCED 11 mapping: variable very closed to ISCED 11, use as well UNESCO mapping
					http://www.uis.unesco.org/Education/ISCEDMappings/Pages/default.aspx
					http://www.uis.unesco.org/Education/Documents/isced-2011-en.pdf 	*/


	gen ilo_edu_isced11=.
		replace ilo_edu_isced11=1 if C12==1  			// No schooling
		replace ilo_edu_isced11=2 if C12==2 			// Early childhood education
		replace ilo_edu_isced11=3 if C12==3				// Primary education
		replace ilo_edu_isced11=4 if C12==4				// Lower secondary education
		replace ilo_edu_isced11=5 if C12==5   			// Upper secondary education
		replace ilo_edu_isced11=6 if C12==6   			// Post-secondary non-tertiary education
		replace ilo_edu_isced11=7 if C12==7				// Short-cycle tertiary education
		replace ilo_edu_isced11=8 if C12==8  			// Bachelor or equivalent
		replace ilo_edu_isced11=9 if C12==9  			// Master's or equivalent level
		replace ilo_edu_isced11=10 if C12==0  | C12==.	// Not elsewhere classified
			label def isced_11_lab 1 "X - No schooling" 2 "0 - Early childhood education" 3 "1 - Primary education" 4 "2 - Lower secondary education" ///
							5 "3 - Upper secondary education" 6 "4 - Post-secondary non-tertiary education" 7 "5 - Short-cycle tertiary education" ///
							8 "6 - Bachelor's or equivalent level" 9 "7 - Master's or equivalent level" 10 "9 - Not elsewhere classified"
			label val ilo_edu_isced11 isced_11_lab
			lab var ilo_edu_isced11 "Level of education (ISCED 11)"	
	
/* NOTE: * The category Master's or equivalent also includes the Doctral or equivalent level as there is no distinction between 
		   these two categories in the questionnaire. 
		 * The question is only asked to people aged 15 and more. So people below the age of 15 are under "Not elsewhere classified".   */
			
		
		
	gen ilo_edu_aggregate=.
		replace ilo_edu_aggregate=1 if inlist(ilo_edu_isced11,1,2)  // Less than basic
		replace ilo_edu_aggregate=2 if inlist(ilo_edu_isced11,3,4)	// Basic
		replace ilo_edu_aggregate=3 if inlist(ilo_edu_isced11,5,6)	// Intermediate
		replace ilo_edu_aggregate=4 if inrange(ilo_edu_isced11,7,9)	// Advanced
		replace ilo_edu_aggregate=5 if ilo_edu_isced11==10			// Level not stated
			label def edu_aggr_lab 1 "Less than basic" 2 "Basic" 3 "Intermediate" 4 "Advanced" 5 "Level not stated"
			label val ilo_edu_aggregate edu_aggr_lab
			label var ilo_edu_aggregate "Level of education (Aggregate)"
				
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education attendance ('ilo_edu_attendance')  	[done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------


		* Not available 


	
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
		replace ilo_lfs=1 if C14==1 & ilo_wap==1  // Employed
		replace ilo_lfs=1 if C15==1 & ilo_wap==1  // Employed
		replace ilo_lfs=1 if C16==1 & ilo_wap==1  // Employed
		replace ilo_lfs=1 if C19==1 & ilo_wap==1  // Employed
		replace ilo_lfs=1 if C21==1 & ilo_wap==1  // Employed
		replace ilo_lfs=2 if ilo_lfs!=1 & ((C52==1 & C56==1) | C55==8) & ilo_wap==1  // Unemployed
		replace ilo_lfs=3 if ilo_lfs!=1 & ilo_lfs!=2 & ilo_wap==1  // Outside the labour force
				label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside the Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status"



			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------


	gen ilo_mjh=.
		replace ilo_mjh=1 if inlist(C43,2,.) & ilo_lfs==1
		replace ilo_mjh=2 if C43==1 & ilo_lfs==1
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
				replace ilo_job1_ste_icse93=1 if C28==5				// Employees
				replace ilo_job1_ste_icse93=2 if C28==1				// Employers
				replace ilo_job1_ste_icse93=3 if C28==2				// Own-account workers
				replace ilo_job1_ste_icse93=4 if C28==4				// Producer cooperatives
				replace ilo_job1_ste_icse93=5 if C28==3				// Contributing family workers
				replace ilo_job1_ste_icse93=6 if C28==9 | C28==.	// Not classifiable
				replace ilo_job1_ste_icse93=. if ilo_lfs!=1
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


				
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------



	/* National classification is based on ISIC 4, at a 2 digit-level the national classification 
	   is identic to ISIC Rev. 4	 */
		
			append using `labels'
			*use value label from this variable, afterwards drop everything related to this append
			
			
				* MAIN JOB:
					
					* ISIC Rev. 4 - 2 digit
						gen isic2dig = int(C23/100)
							replace isic2dig=. if isic2dig==0
						
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
		
			* Not available
		
		
		
		* Dropping the variables not used anymore:	
			drop isic2dig

			
	
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_job1_ocu_isco88') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
	
	/* Viet Nam uses its own classification, which can only be mapped to the ILO aggregate categories  */
	   
	   gen occup=int(C22/1000) if ilo_lfs==1 & C22>0	
	
	
		* Aggregate:
			gen ilo_job1_ocu_aggregate=.
				replace ilo_job1_ocu_aggregate=1 if inrange(occup,1,3)
				replace ilo_job1_ocu_aggregate=2 if inlist(occup,4,5)
				replace ilo_job1_ocu_aggregate=3 if inlist(occup,6,7)
				replace ilo_job1_ocu_aggregate=4 if occup==8
				replace ilo_job1_ocu_aggregate=5 if occup==9
				replace ilo_job1_ocu_aggregate=6 if occup==0
				replace ilo_job1_ocu_aggregate=7 if occup==.
				replace ilo_job1_ocu_aggregate=. if ilo_lfs!=1
					lab def ocu_aggr_lab 1 "Managers, professionals, and technicians" 2 "Clerical, service and sales workers" 3 "Skilled agricultural and trades workers" ///
										4 "Plant and machine operators, and assemblers" 5 "Elementary occupations" 6 "Armed forces" 7 "Not elsewhere classified"
					lab val ilo_job1_ocu_aggregate ocu_aggr_lab
					lab var ilo_job1_ocu_aggregate "Occupation (Aggregate) - Main job"	
	
	
		drop occup
	
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_job1_ins_sector') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
	
	/* Public: state agency, gov institution, public/civil service, state owned entreprise
	   Private: farming/aquaculture household, owned account, household business, cooperative,
				non-state entrepises, non-state agency, foreign business, other type of business */
	
		gen ilo_job1_ins_sector=.
			replace ilo_job1_ins_sector=1 if inrange(C24,7,10) & ilo_lfs==1		// Public
			replace ilo_job1_ins_sector=2 if ilo_job1_ins_sector!=1 & ilo_lfs==1		// Private
				lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private" 
				lab values ilo_job1_ins_sector ins_sector_lab
				lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities"
	
	
	

	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Hours of work ('ilo_how') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
		

		
		* MAIN JOB:
			
			* 1) Weekly hours ACTUALLY worked:
			
				gen ilo_job1_how_actual=C41 if ilo_lfs==1
					replace ilo_job1_how_actual=. if ilo_job1_how_actual<0
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
		
				gen ilo_job1_how_usual=C42 if ilo_lfs==1
					replace ilo_job1_how_usual=. if ilo_job1_how_usual<0
						lab var ilo_job1_how_usual "Weekly hours usually worked in main job"
		
		
		* SECOND JOB
			
			* Not available
		
		
		
		* ALL JOBS:
		
			* 1) Weekly hours ACTUALLY worked:
				gen ilo_joball_how_actual=C45 if ilo_lfs==1
					replace ilo_joball_how_actual=ilo_job1_how_actual if ilo_mjh==1
					replace ilo_joball_how_actual=. if ilo_joball_how_actual<0
						lab var ilo_joball_how_actual "Weekly hours actually worked in all jobs"
						
		
				gen ilo_joball_actual_how_bands=.
					replace ilo_joball_actual_how_bands=1 if ilo_joball_how_actual==0
					replace ilo_joball_actual_how_bands=2 if ilo_joball_how_actual>=1 & ilo_joball_how_actual<=14
					replace ilo_joball_actual_how_bands=3 if ilo_joball_how_actual>=15 & ilo_joball_how_actual<=29
					replace ilo_joball_actual_how_bands=4 if ilo_joball_how_actual>=30 & ilo_joball_how_actual<=34
					replace ilo_joball_actual_how_bands=5 if ilo_joball_how_actual>=35 & ilo_joball_how_actual<=39
					replace ilo_joball_actual_how_bands=6 if ilo_joball_how_actual>=40 & ilo_joball_how_actual<=48
					replace ilo_joball_actual_how_bands=7 if ilo_joball_how_actual>=49 & ilo_joball_how_actual!=.
					replace ilo_joball_actual_how_bands=8 if ilo_joball_actual_how_bands==. & ilo_lfs==1
						lab val ilo_joball_actual_how_bands how_bands_lab
						lab var ilo_joball_actual_how_bands "Weekly hours actually worked bands in all jobs"
						
						
			* 2) Weekly hours USUALLY worked:
				gen ilo_joball_how_usual=C46 if ilo_lfs==1
					replace ilo_joball_how_usual=ilo_job1_how_usual if ilo_mjh==1
					replace ilo_joball_how_usual=. if ilo_joball_how_usual<0
						lab var ilo_joball_how_usual "Weekly hours usually worked in all jobs"
				
	
	
	
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job1_job_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
		
	/* The variable cannot be defined because the question is not asked directly, there is no 
	   no national definition of "normal hours worked" and the median of the weekly hours
	   usually worked in all jobs (48 hours/week) is too high to be used as a threshold.	*/

	
		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job1_job_contract') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
		
	/*	The possible answers to the question asking for the type of contract mix answers related 
		to the length of contract (temporary or permanent)and the form of contract (oral, no contract). 
		As around 3/4 of people answer either oral agreement or no conrtact it would make no sense to create the variable. 		*/
				
	
	
		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Formal / Informal Economy ('ilo_job1_ife_prod' 'ilo_job1_ife_nature') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
		
	/* Questions used:	* C24: institutional sector
	
						* C25: destination of production
						
						* C26: business registration
						
						* C32: "Have you paid for social insurance, with the above job?"
							   IMPORTANT: this question is used as a proxy to assess the social security coverage 
							              because there no other options. It should be noted that it is an important 
										  ASSUMPTION that is made there because the payment is made by the workers. 
						
	
	NOTE: question 27 (location of workplace) is useless in this case because there is no options "Employer's own dwelling"
	      in the answers and no information about the size of the companies in the questionnaire. 			*/
				
	
	
	* 1) Unit of production
	
			gen ilo_job1_ife_prod=.
   /*Informal*/ replace ilo_job1_ife_prod=1 if (inrange(C24,1,6) | inlist(C24,11,12,.)) &				 ///
												C25!=4 & C26!=1 & C32!=1
	 /*Formal*/ replace ilo_job1_ife_prod=2 if inrange(C24,7,10) | ///
											 ((inrange(C24,1,6) | inlist(C24,11,12,.)) & C25!=4 & C26==1) | ///
											 ((inrange(C24,1,6) | inlist(C24,11,12,.)) & C25!=4 & C26!=1 & C32==1)											
 /*Households*/ replace ilo_job1_ife_prod=3 if ((inrange(C24,1,6) | inlist(C24,11,12,.)) & C25==4) 
				replace ilo_job1_ife_prod=. if ilo_lfs!=1 
						lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 
						lab val ilo_job1_ife_prod ilo_ife_prod_lab
						lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"
			
		
	
	
	* 2) Nature of job
	
			gen ilo_job1_ife_nature=.
   /*Informal*/ replace ilo_job1_ife_nature=1 if (inlist(ilo_job1_ste_icse93,2,3,4) & ilo_job1_ife_prod!=2) | ///
												 (ilo_job1_ste_icse93==1 & C32!=1) |	///
												  inlist(ilo_job1_ste_icse93,5,6)								
     /*Formal*/ replace ilo_job1_ife_nature=2 if (inlist(ilo_job1_ste_icse93,2,3,4) & ilo_job1_ife_prod==2) | 	///
												 (ilo_job1_ste_icse93==1 & C32==1)												
				replace ilo_job1_ife_nature=. if ilo_lfs!=1
						lab def ife_nature_lab 1 "1 - Persons with informal main job" 2 "2 - Persons with formal main job"
						lab val ilo_job1_ife_nature ife_nature_lab
						lab var ilo_job1_ife_nature "Informal / Formal Economy (Nature of job) - Main job"
		
		
	
		
		
		

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Monthly labour related income ('ilo_job1_lri') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
				
	
	/* NOTES:
	   * The question is the same for all workers regarless of their status in employment and is only asked for the main job.
	   * The amounts recorded are in thousand, so they are multiplied by 1000 to have units.
	   * It includes overtime remuneraitions, bonuses, occupational allowances and other welfare payments.
	   * Unit: local currency (dongs) */
	   
	 
	   
			* MAIN JOB:
				
				* Employees
					gen ilo_job1_lri_ees =.
						replace ilo_job1_lri_ees = C40A*1000 if ilo_job1_ste_aggregate==1
						replace ilo_job1_lri_ees=. if ilo_job1_lri_ees<0
							lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"	
				
				* Self-employed:
					gen ilo_job1_lri_slf =.
						replace ilo_job1_lri_slf = C40A*1000 if ilo_job1_ste_aggregate==2 
						replace ilo_job1_lri_slf = . if ilo_job1_lri_slf<0
							lab var ilo_job1_lri_slf "Monthly labour related income of self-employed in main job"	
			
			
			
			* SECOND JOB:
			
				* Not available
		
		
		
		
***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_joball_tru') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
		
	/* Threshold used: 35 hours/week (it is the one the country uses to measure time-related underemployment) 	*/
			
				
				gen ilo_joball_tru=.
					replace ilo_joball_tru=1 if ilo_lfs==1 & C49==1 & C50==1 & C51>0 & ilo_joball_how_actual<35
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
			replace ilo_cat_une=1 if ilo_lfs==2 & C58==1			// Previously employed
			replace ilo_cat_une=2 if ilo_lfs==2 & C58==2			// Seeking first job
			replace ilo_cat_une=3 if ilo_lfs==2 & C58!=1 & C58!=2	//Unkown
				lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
				lab val ilo_cat_une cat_une_lab
				lab var ilo_cat_une "Category of unemployment"
	
	

	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	
	
	/* Here are the possible answer to question 54: " How long have you been looking for job?"
				1. Under 1 month
				2. 1 to under 3 months
				3. 3 months and more
		
		 As the answers are too different from the ILO classes, the variable is not created. */
		
		

	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
		append using `labels'
			*use value label from this variable, afterwards drop everything related to this append
			
					
					* ISIC Rev. 4 - 2 digit
					gen indu_code_une_2dig=int(C62/100) 
					
						gen ilo_preveco_isic4_2digits=.
							replace ilo_preveco_isic4_2digits=indu_code_une_2dig if ilo_lfs==2 & ilo_cat_une==1
							replace ilo_preveco_isic4_2digits=. if ilo_preveco_isic4<=0
							
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
							replace ilo_preveco_isic4=22 if ilo_preveco_isic4==. & ilo_cat_une==1
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
		
		
		
		* Dropping the variables not used anymore:	
			drop isco08_2digits isco88_2digits isco08 isco88 isic4_2digits isic4 isic3_2digits isic3 indu_code_une_2dig ilo_preveco_isic4_2digits 
			drop if missing(ilo_key) /// To drop empty lines added for the labels 

				
	
	
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	

	/* Viet Nam uses its own classification, which can only be mapped to the ILO aggregate categories  */
	   
	   gen prev_occup=int(C61/1000) if ilo_lfs==2 & C61>0	
	
	
		* Aggregate:
			gen ilo_prevocu_aggregate=.
				replace ilo_prevocu_aggregate=1 if inrange(prev_occup,1,3) 
				replace ilo_prevocu_aggregate=2 if inlist(prev_occup,4,5)  
				replace ilo_prevocu_aggregate=3 if inlist(prev_occup,6,7)  
				replace ilo_prevocu_aggregate=4 if prev_occup==8
				replace ilo_prevocu_aggregate=5 if prev_occup==9
				replace ilo_prevocu_aggregate=6 if prev_occup==0
				replace ilo_prevocu_aggregate=7 if prev_occup==. 
				replace ilo_prevocu_aggregate=. if ilo_lfs!=2
				replace ilo_prevocu_aggregate=. if ilo_cat_une!=1
					lab val ilo_prevocu_aggregate ocu_aggr_lab
					lab var ilo_prevocu_aggregate "Previous occupation (Aggregate)"	
	
	
		drop prev_occup
	

	
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			General social protection ('ilo_gsp_unschemes') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
	* Not available
	
	
	
	
***********************************************************************************************
*			PART 3.3. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
	
	
	gen ilo_olf_dlma=.
		replace ilo_olf_dlma = 1 if C52==1 & C56==2 & ilo_lfs==3 				//Seeking, not available
		replace ilo_olf_dlma = 2 if C52==2 & C56==1 & ilo_lfs==3				//Not seeking, available
		* replace ilo_olf_dlma = 3 if 											//Not seeking, not available, willing
		replace ilo_olf_dlma = 4 if C52==2 & C56==2 & C55==4 & ilo_lfs==3		//Not seeking, not available, not willing
		replace ilo_olf_dlma = 5 if	ilo_olf_dlma==. & ilo_lfs==3				// Not classified 
	
			lab def dlma_lab 1 "1 - Seeking, not available (Unavailable jobseekers)" 2 "2 - Not seeking, available (Available potential jobseekers)" ///
							 3 "3 - Not seeking, not available, willing (Willing non-jobseekers)" 4 "4 - Not seeking, not available, not willing" 5 "X - Not elsewhere classified"
			lab val ilo_olf_dlma dlma_lab 
			lab var ilo_olf_dlma "Labour market attachment (Degree of)"

	
	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reason for not seeking job ('ilo_olf_reason') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

	
		gen ilo_olf_reason=.
			replace ilo_olf_reason=1 if	inlist(C55,5,6,7,9,10) & ilo_lfs==3		//Labour market
			replace ilo_olf_reason=2 if	inlist(C55,1,2,3,11,12) & ilo_lfs==3	//Personal/Family-related
			replace ilo_olf_reason=3 if C55==4 & ilo_lfs==3						//Does not need/want to work
			replace ilo_olf_reason=4 if inlist(C55,0,13,.) & ilo_lfs==3			//Not elsewhere classified
				lab def reasons_lab 1 "1 - Labour market" 2 "2 - Personal / Family-related" ///
									3 "3 - Does not need/want to work" 4 "4 - Not elsewhere classified"
				lab val ilo_olf_reason reasons_lab 
				lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"
	
			
		
		
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seeker ('ilo_dis')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

		
	gen ilo_dis=1 if ilo_lfs==3 & C56==1 & ilo_olf_reason==1
			lab def dis_lab 1 "Discouraged job-seekers"
			lab val ilo_dis dis_lab
			lab var ilo_dis "Discouraged job-seekers"
			
			
			
		
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training ('ilo_neet')  
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

	* Varibale cannot be done because we do not have education attendance. 	
			
			
			
			

		
			
					

		
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
		saveold VNM_LFS_2015Q2_FULL, version(12) replace

		
		

* 2 - Dataset with only 'ILO' variables
	
		keep ilo*
		saveold VNM_LFS_2015Q2_ILO, version(12) replace

	
	
	
