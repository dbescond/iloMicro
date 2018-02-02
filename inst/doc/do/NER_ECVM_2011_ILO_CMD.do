* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Niger, 2011
* DATASET USED: Niger - Enquête nationale sur les Conditions de Vie des Ménages (ECVM)  - 2011
* NOTES:
* Authors: DPAU
* Who last updated the file: DPAU 
* Starting Date: 31 August 2017
* Last updated: 31 August 2017
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
global country "NER"
global source "ECVM"
global time "2011"
global inputFile "NER_ECVM_2011"
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
       replace ilo_wgt=hhweight_poverty
	   drop if ilo_wgt==.
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

	gen ilo_geo=urbrur
		lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural"
		lab val ilo_geo ilo_geo_lab
		lab var ilo_geo "Geographical coverage"	


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_sex=ms01q01
		lab def ilo_sex_lab 1 "1 - Male" 2 "2 - Female"
		lab var ilo_sex "Sex"
		lab val ilo_sex ilo_sex_lab

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_age=ms01q06a
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

* Coment: Master is included with Bachelor. 

	gen ilo_edu_isced11=.
		replace ilo_edu_isced11=1 if inlist(ms02q04,2,3,4,9)						// No schooling
		replace ilo_edu_isced11=2 if (ms02q12==1 | ms02q23==1) 	 					// Early childhood education
		replace ilo_edu_isced11=3 if (ms02q12==2 | ms02q23==2)	  					// Primary education
		replace ilo_edu_isced11=4 if (inlist(ms02q12,3,4) | inlist(ms02q23,3,4))	// Lower secondary education
		replace ilo_edu_isced11=5 if (inlist(ms02q12,5,6) | inlist(ms02q23,5,6))	// Upper secondary education
		* replace ilo_edu_isced11=6 				 								// Post-secondary non-tertiary
		replace ilo_edu_isced11=8 if (ms02q12==7 | ms02q23==7)						// Bachelor or equivalent
		* replace ilo_edu_isced11=9 if c5==19     									// Master's or equivalent level
		replace ilo_edu_isced11=11 if ilo_edu_isced11==.							// Not elsewhere classified
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
		replace ilo_edu_attendance=1 if ms02q10==1
		replace ilo_edu_attendance=2 if ms02q10==2
		replace ilo_edu_attendance=2 if inlist(ms02q04,2,3,4,9)
		replace ilo_edu_attendance=3 if ilo_edu_attendance==.
				lab def edu_attendance_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
				lab val ilo_edu_attendance edu_attendance_lab
				lab var ilo_edu_attendance "Education (Attendance)"

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

* Comment: 	Employment is defined with questions 4.01, 4.03, 4.05, 4.07 and 4.09 (based on last 30 days and not 7 days) 
*			Unemployment is defined with questions 4.14 and 4.15 (availability within one month is included as 2 weeks is not an option) 

	gen ilo_lfs=.
	    replace ilo_lfs=1 if (ms04q01==1 | ms04q03==1 | ms04q05==1 | ms04q07==1  | ms04q09==1) & ilo_wap==1 // Employed
		replace ilo_lfs=2 if ilo_lfs!=1 & ms04q11==2 & ms04q14==1 & inlist(ms04q15,1,2) & ilo_wap==1  		// Unemployed 
		replace ilo_lfs=3 if !inlist(ilo_lfs,1,2) & ilo_wap==1      										// Outside the labour force
		    label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside the Labour Force"
			label value ilo_lfs label_ilo_lfs
			label var ilo_lfs "Labour Force Status"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

    gen ilo_mjh=.
		replace ilo_mjh=1 if (ms04q50==2 & ilo_lfs==1)
		replace ilo_mjh=2 if (ms04q50==1 & ilo_lfs==1)
		replace ilo_mjh=1 if (ilo_mjh==. & ilo_lfs==1)
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
			replace ilo_job1_ste_icse93=1 if (inlist(ms04q25,1,2,3,4,5,9) & ilo_lfs==1)	// Employees
			replace ilo_job1_ste_icse93=2 if (ms04q25==6 & ilo_lfs==1)	            	// Employers
			replace ilo_job1_ste_icse93=3 if (ms04q25==7 & ilo_lfs==1)  	    		// Own-account workers
			* replace ilo_job1_ste_icse93=4 if 						              		// Members of producers’ cooperatives
			replace ilo_job1_ste_icse93=5 if (ms04q25==8 & ilo_lfs==1)            		// Contributing family workers
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

* Comment: Based on the national classification found in the interviewer's manual. 

	gen indu_code_prim=ms04q24 if (ilo_lfs==1)
	gen indu_code_sec=ms04q52 if (ilo_lfs==1 & ilo_mjh==2)
		
		* Import value labels

		append using `labels', gen (lab)

		
		* Primary activity
		
		gen ilo_job1_eco_isic4=.
			replace ilo_job1_eco_isic4=1 if inrange(indu_code_prim,11,59)
			replace ilo_job1_eco_isic4=2 if inrange(indu_code_prim,60,79)
			replace ilo_job1_eco_isic4=3 if inrange(indu_code_prim,80,289)
			replace ilo_job1_eco_isic4=4 if inrange(indu_code_prim,290,291)
			replace ilo_job1_eco_isic4=5 if inrange(indu_code_prim,292,299)
			replace ilo_job1_eco_isic4=6 if inrange(indu_code_prim,300,309)
			replace ilo_job1_eco_isic4=7 if inrange(indu_code_prim,310,329)
			replace ilo_job1_eco_isic4=8 if inrange(indu_code_prim,340,349)
			replace ilo_job1_eco_isic4=9 if inrange(indu_code_prim,330,339)
			replace ilo_job1_eco_isic4=10 if inrange(indu_code_prim,350,359)
			replace ilo_job1_eco_isic4=11 if inrange(indu_code_prim,360,369)
			replace ilo_job1_eco_isic4=12 if inrange(indu_code_prim,370,379)
			* replace ilo_job1_eco_isic4=13 if 
			replace ilo_job1_eco_isic4=14 if inrange(indu_code_prim,380,389)
			replace ilo_job1_eco_isic4=15 if inrange(indu_code_prim,390,399)
			replace ilo_job1_eco_isic4=16 if inrange(indu_code_prim,400,409)
			replace ilo_job1_eco_isic4=17 if inrange(indu_code_prim,410,419)
			* replace ilo_job1_eco_isic4=18 if 
			replace ilo_job1_eco_isic4=19 if inrange(indu_code_prim,420,424)
			replace ilo_job1_eco_isic4=20 if inrange(indu_code_prim,425,426)
			replace ilo_job1_eco_isic4=21 if inrange(indu_code_prim,430,439)
			replace ilo_job1_eco_isic4=22 if indu_code_prim==999
			replace ilo_job1_eco_isic4=22 if indu_code_prim==. & ilo_lfs==1 
			replace ilo_job1_eco_isic4=. if ilo_lfs!=1
				lab val ilo_job1_eco_isic4 isic4
				lab var ilo_job1_eco_isic4 "Economic activity (ISIC Rev. 4)"
				
		* Secondary activity
		
		gen ilo_job2_eco_isic4=.
			replace ilo_job2_eco_isic4=1 if inrange(indu_code_sec,11,59)
			replace ilo_job2_eco_isic4=2 if inrange(indu_code_sec,60,79)
			replace ilo_job2_eco_isic4=3 if inrange(indu_code_sec,80,289)
			replace ilo_job2_eco_isic4=4 if inrange(indu_code_sec,290,291)
			replace ilo_job2_eco_isic4=5 if inrange(indu_code_sec,292,299)
			replace ilo_job2_eco_isic4=6 if inrange(indu_code_sec,300,309)
			replace ilo_job2_eco_isic4=7 if inrange(indu_code_sec,310,329)
			replace ilo_job2_eco_isic4=8 if inrange(indu_code_sec,340,349)
			replace ilo_job2_eco_isic4=9 if inrange(indu_code_sec,330,339)
			replace ilo_job2_eco_isic4=10 if inrange(indu_code_sec,350,359)
			replace ilo_job2_eco_isic4=11 if inrange(indu_code_sec,360,369)
			replace ilo_job2_eco_isic4=12 if inrange(indu_code_sec,370,379)
			* replace ilo_job2_eco_isic4=13 if 
			replace ilo_job2_eco_isic4=14 if inrange(indu_code_sec,380,389)
			replace ilo_job2_eco_isic4=15 if inrange(indu_code_sec,390,399)
			replace ilo_job2_eco_isic4=16 if inrange(indu_code_sec,400,409)
			replace ilo_job2_eco_isic4=17 if inrange(indu_code_sec,410,419)
			* replace ilo_job2_eco_isic4=18 if 
			replace ilo_job2_eco_isic4=19 if inrange(indu_code_sec,420,424)
			replace ilo_job2_eco_isic4=20 if inrange(indu_code_sec,425,426)
			replace ilo_job2_eco_isic4=21 if inrange(indu_code_sec,430,439)
			replace ilo_job2_eco_isic4=22 if indu_code_sec==999
			replace ilo_job2_eco_isic4=22 if indu_code_sec==. & ilo_lfs==1 & ilo_mjh==2
					replace ilo_job2_eco_isic4=. if ilo_lfs!=1 & ilo_mjh!=2
				lab val ilo_job1_eco_isic4 isic4
				lab var ilo_job2_eco_isic4 "Economic activity (ISIC Rev. 4) in secondary job"
		
		
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
				lab var ilo_job1_eco_aggregate "Economic activity (Aggregate)"
				
		* Secondary activity
		
		gen ilo_job2_eco_aggregate=.
			replace ilo_job2_eco_aggregate=1 if ilo_job2_eco_isic4==1
			replace ilo_job2_eco_aggregate=2 if ilo_job2_eco_isic4==3
			replace ilo_job2_eco_aggregate=3 if ilo_job2_eco_isic4==6
			replace ilo_job2_eco_aggregate=4 if inlist(ilo_job2_eco_isic4,2,4,5)
			replace ilo_job2_eco_aggregate=5 if inrange(ilo_job2_eco_isic4,7,14)
			replace ilo_job2_eco_aggregate=6 if inrange(ilo_job2_eco_isic4,15,21)
			replace ilo_job2_eco_aggregate=7 if ilo_job2_eco_isic4==22
				* value labels already defined				
				lab val ilo_job2_eco_aggregate eco_aggr_lab
				lab var ilo_job2_eco_aggregate "Economic activity (Aggregate) in secondary job"

				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_ocu')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment:  The classification of Occupations can't be mapped neither with ISCO-08 nor ISCO-88. 
			
		* One digit level
	
		* gen occ_code_prim=int(ms04q23/100) if (ilo_lfs==1)
		* gen occ_code_sec=int(ms04q51/100) if (ilo_lfs==1 & ilo_mjh==2)


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_job1_ins_sector')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

	* Primary occupation
	
	 gen ilo_job1_ins_sector=.
		replace ilo_job1_ins_sector=1 if inlist(ms04q26,1,2,7) & ilo_lfs==1
		replace ilo_job1_ins_sector=2 if ilo_job1_ins_sector!=1 & ilo_lfs==1
		replace ilo_job1_ins_sector=. if ilo_lfs!=1
			lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
			lab values ilo_job1_ins_sector ins_sector_lab
			lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities"	
			
	* Secondary occupation
	
	gen ilo_job2_ins_sector=.
		replace ilo_job2_ins_sector=1 if inlist(ms04q54,1,2,7) & ilo_mjh==2
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

* Comment: No information


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job1_job_contract')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
		
		gen ilo_job1_job_contract=.
			replace ilo_job1_job_contract=1 if ms04q28==1 & ilo_lfs==1
			replace ilo_job1_job_contract=2 if inlist(ms04q28,2,3,4) & ilo_lfs==1
			replace ilo_job1_job_contract=3 if (ilo_job1_job_contract==. & ilo_lfs==1)
					lab def job_contract_lab 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"
					lab val ilo_job1_job_contract job_contract_lab
					lab var ilo_job1_job_contract "Job (Type of contract)"


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Informal/Formal economy: Unit of production ('ilo_job1_ife_prod')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: Useful questions:	* ms04q25: Status in employment
								* ms04q26: Institutional sector 
								* [Not asked]: Destination of production 
								* [Not asked]: Bookkeeping
								* ms04q40: Registration (Proxy: Income tax)						
								* [Not asked]: Location of workplace 
								* ms04q27: Size of the establishment					
								* Social security 
									* ms04q41: Social Security (Proxy: pension fund)
									* ms04q42: Paid annual leave
									* ms04q43: Paid sick leave

	
		gen ilo_job1_ife_prod=.
			replace ilo_job1_ife_prod=2 if inlist(ms04q26,1,2,7) | (!inlist(ms04q26,1,2,7) & ms04q40==1)
			replace ilo_job1_ife_prod=3 if (ms04q26==6)
			replace ilo_job1_ife_prod=1 if (ilo_job1_ife_prod==. & ilo_lfs==1)
			replace ilo_job1_ife_prod=. if (ilo_lfs!=1)
				lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 4 "4 - Not elsewhere classified"
				lab val ilo_job1_ife_prod ilo_ife_prod_lab
				lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"			
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Informal/formal economy: Nature of job ('ilo_job1_ife_nature')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

		gen ilo_job1_ife_nature=.
			replace ilo_job1_ife_nature=1 if ilo_job1_ste_icse93==5 | (inlist(ilo_job1_ste_icse93,2,3,4) & inlist(ilo_job1_ife_prod,1,3)) | (inlist(ilo_job1_ste_icse93,1,6) & ms04q41!=1) 
			replace ilo_job1_ife_nature=2 if (inlist(ilo_job1_ste_icse93,1,6) & ms04q41==1) | (inlist(ilo_job1_ste_icse93,2,3,4) & ilo_job1_ife_prod==2)
			replace ilo_job1_ife_nature=. if ilo_lfs!=1
				lab def ife_nature_lab 1 "1 - Persons with informal main job" 2 "2 - Persons with formal main job"
				lab val ilo_job1_ife_nature ife_nature_lab
				lab var ilo_job1_ife_nature "Informal / Formal Economy (Nature of job)"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Hours of work ('ilo_job1_how')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
		* MAIN JOB: Weekly hours USUALLY worked
		
				gen ilo_job1_how_usual=(ms04q30*ms04q31) if (ilo_lfs==1 & ms04q30!=99 & ms04q31!=9)
						lab var ilo_job1_how_usual "Weekly hours usually worked in main job"
		
		* SECOND JOB: Weekly hours USUALLY worked
		
				gen ilo_job2_how_usual=(ms04q56*ms04q57) if (ilo_mjh==2 & ms04q56!=99 & ms04q57!=9)
						lab var ilo_job2_how_usual "Weekly hours usually worked in second job"
		
		* ALL JOBS: Weekly hours USUALLY worked
			
				gen ilo_joball_how_usual=ilo_job1_how_usual if (ilo_lfs==1 & ilo_mjh!=2)
					replace ilo_joball_how_usual=(ilo_job1_how_usual+ilo_job2_how_usual) if (ilo_lfs==1 & ilo_mjh==2)
						lab var ilo_joball_how_usual "Weekly hours usually worked in all jobs"
	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Monthly labour related income ('ilo_job1_lri')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			

	* Employees
		gen ilo_job1_lri_ees=.
			replace ilo_job1_lri_ees=(ms04q32*5*52/12) if (ilo_job1_ste_aggregate==1 & ms04q32a==1)
			replace ilo_job1_lri_ees=(ms04q32*52/12) if (ilo_job1_ste_aggregate==1 & ms04q32a==2)
			replace ilo_job1_lri_ees=ms04q32 if (ilo_job1_ste_aggregate==1 & ms04q32a==3)
			replace ilo_job1_lri_ees=(ms04q32/12) if (ilo_job1_ste_aggregate==1 & ms04q32a==4)
					lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"	
				
	* Self-employed
		gen ilo_job1_lri_slf=.
			replace ilo_job1_lri_slf=(ms04q32*5*52/12) if (inlist(ilo_job1_ste_icse93,2,3,4,6) & ms04q32a==1)
			replace ilo_job1_lri_slf=(ms04q32*52/12) if (inlist(ilo_job1_ste_icse93,2,3,4,6) & ms04q32a==2)
			replace ilo_job1_lri_slf=ms04q32 if (inlist(ilo_job1_ste_icse93,2,3,4,6) & ms04q32a==3)
			replace ilo_job1_lri_slf=(ms04q32/12) if (inlist(ilo_job1_ste_icse93,2,3,4,6) & ms04q32a==4)
					lab var ilo_job1_lri_slf "Monthly earnings of self-employed in main job"



***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_joball_tru')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

		gen ilo_joball_tru=.
			replace ilo_joball_tru=1 if (ilo_joball_how_usual<40 & ms04q68==1 & ilo_lfs==1)
				lab def tru_lab 1 "Time-related underemployment"
				lab val ilo_joball_tru tru_lab
				lab var ilo_joball_tru "Time-related underemployment"	

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
			replace ilo_cat_une=1 if ms04q19==1
			replace ilo_cat_une=2 if ms04q19==2
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

    * Detailed
		gen ilo_dur_details=.
			replace ilo_dur_details=1 if (ms04q18==1 & ilo_lfs==2)          	// Less than 1 month
			replace ilo_dur_details=2 if (ms04q18==2 & ilo_lfs==2)				// 1-2 months
			replace ilo_dur_details=3 if (inrange(ms04q18,3,5) & ilo_lfs==2)	// 3-5 months
			replace ilo_dur_details=4 if (inrange(ms04q18,6,11) & ilo_lfs==2)   // 6-11 months
			replace ilo_dur_details=5 if (inrange(ms04q18,6,98) & ilo_lfs==2)	// 12 months and more
			replace ilo_dur_details=7 if (ilo_dur_details==.& ilo_lfs==2)  		// Not elsewhere classified
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

* Comment: No information
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu_isco08')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
		
* Comment: No information


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
		replace ilo_olf_dlma=1 if ms04q14==1 & ms04q15==3 & ilo_lfs==3
		replace ilo_olf_dlma=2 if ms04q14==2 & inlist(ms04q15,1,2) & ilo_lfs==3
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
		replace ilo_olf_reason=1 if inlist(ms04q16,3,9,10)
		replace ilo_olf_reason=2 if inlist(ms04q16,7,8,11)
		replace ilo_olf_reason=3 if inlist(ms04q16,2,4,5,6)
		replace ilo_olf_reason=4 if inlist(ms04q16,1)
		replace ilo_olf_reason=5 if inlist(ms04q16,12)
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

* Comment: We can't define it due to a skip pattern after question 4.15

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
