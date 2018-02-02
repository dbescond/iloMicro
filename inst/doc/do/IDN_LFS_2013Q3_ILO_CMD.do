* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Indonesia
* DATASET USED: Indonesia LFS
* NOTES: 
* Files created: Standard variables on LFS Indonesia
* Authors: Marylène Escher
* Who last updated the file:
* Starting Date: 29 July 2016
* Last updated: 16 March 2017
***********************************************************************************************
* LFS report used to check the values : http://bps.go.id/website/pdf_publikasi/Keadaan-Angkatan-Kerja-di-Indonesia-Februari-2015.pdf
***********************************************************************************************



***********************************************************************************************
***********************************************************************************************

* 			1. SET UP WORK DIRECTORY, FILE NAME, VARIABLES AND FUNCTIONS

***********************************************************************************************
***********************************************************************************************

clear all 

set more off
global path "J:\COMMON\STATISTICS\DPAU\MICRO"
global country "IDN"
global source "LFS"
global time "2013Q3"
global inputFile "SAK0813.dta"
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
		

* Load original dataset:
		
cd "$inpath"

	use "$inputFile", clear	

	rename *, lower
	
	capture confirm var kbli2009* 
		if !_rc {
	rename kbli2009* kbli2009
		}
		
	capture confirm var klasifik* 
		if !_rc {
	rename klasifik* klasifik
		}
	

***********************************************************************************************

* Create help variables for the time period considered
	
	gen time = "${time}"
	split time, gen(time_) parse(Q)
	
	capture confirm variable time_2 
	
		if !_rc {
	
	rename (time_1 time_2) (year quarter)
		destring year quarter, replace
		}
		
	else {
	
	rename time_1 year
	destring year, replace
		}
		
**********************************************************************************************	
	
		
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
	

	gen ilo_wgt=weight
		lab var ilo_wgt "Sample weight"		
		
		
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time period ('ilo_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*

	gen ilo_time=1
		lab def lab_time 1 "${time}" 
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

	if year>=2014 {	
	gen ilo_geo=klasifik
		}
		
	if year<=2013 {
	gen ilo_geo=b1p05
		}
		
		lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural"
		lab val ilo_geo ilo_geo_lab
		lab var ilo_geo "Geographical coverage"	
	
	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------


	capture confirm var jk 
		if !_rc {
	gen ilo_sex=jk
		}
		
	else {
	gen ilo_sex=b4_k4
		}
		
		lab def ilo_sex_lab 1 "1 - Male" 2 "2 - Female"
		lab var ilo_sex "Sex"
		lab val ilo_sex ilo_sex_lab


		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*	

	capture confirm var umur 
		if !_rc {
	gen ilo_age=umur
		}
		
	else {	
	gen ilo_age=b4_k5
		}
		
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

* Note that according to the definition, the highest level being CONCLUDED is being considered

	capture confirm var b5p1a 
	
		if !_rc {
		clonevar educ_level = b5p1a
			}
			
		else {
		clonevar educ_level = b5_r1a
			}
	
	gen ilo_edu_isced11=.
		replace ilo_edu_isced11=1 if educ_level==1  			// No schooling
		replace ilo_edu_isced11=2 if educ_level==2  			// Early childhood education
		replace ilo_edu_isced11=3 if inrange(educ_level,3,4) 	// Primary education
		replace ilo_edu_isced11=4 if inrange(educ_level,5,7)   	// Lower secondary education
		replace ilo_edu_isced11=5 if inrange(educ_level,8,10)   // Upper secondary education
		*replace ilo_edu_isced11=6 if 					  	// Post-secondary non-tertiary
		replace ilo_edu_isced11=7 if inrange(educ_level,11,12)  // Short-cycle tertiary education
		replace ilo_edu_isced11=8 if educ_level==13  			// Bachelor or equivalent
		replace ilo_edu_isced11=9 if educ_level==14  			// Master's or equivalent level
		/* replace ilo_edu_isced11=10 if */					// Doctoral or equivalent level
		replace ilo_edu_isced11=11 if ilo_edu_isced11==.	// Not elsewhere classified
		
			label def isced_11_lab 1 "X - No schooling" 2 "0 - Early childhood education" 3 "1 - Primary education" 4 "2 - Lower secondary education" 5 "3 - Upper secondary education" ///
								6 "4 - Post-secondary non-tertiary education" 7 "5 - Short-cycle tertiary education" 8 "6 - Bachelor's or equivalent level" 9 "7 - Master's or equivalent level" ///
								10 "8 - Doctoral or equivalent level" 11 "9 - Not elsewhere classified"
			label val ilo_edu_isced11 isced_11_lab
			lab var ilo_edu_isced11 "Education (ISCED 11)"	
			
	/* NOTE: the category Master's or equivalent also includes the Doctral or equivalent level as there is no distinction between 
			these two categories in the questionnaire. */
			
		
	gen ilo_edu_aggregate=.
		replace ilo_edu_aggregate=1 if inlist(ilo_edu_isced11,1,2)  	// Less than basic
		replace ilo_edu_aggregate=2 if inlist(ilo_edu_isced11,3,4)		// Basic
		replace ilo_edu_aggregate=3 if inlist(ilo_edu_isced11,5,6)		// Intermediate
		replace ilo_edu_aggregate=4 if inrange(ilo_edu_isced11,7,10)	// Advanced
		replace ilo_edu_aggregate=5 if ilo_edu_isced11==11				// Level not stated
		
			label def edu_aggr_lab 1 "1 - Less than basic" 2 "2 - Basic" 3 "3 - Intermediate" 4 "4 - Advanced" 5 "5 - Level not stated"
			label val ilo_edu_aggregate edu_aggr_lab
			label var ilo_edu_aggregate "Education (Aggregate levels)"
			
		
		* Drop help variable
		
		drop educ_level		
		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education attendance ('ilo_edu_attendance') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	capture confirm var sek 
	
		if !_rc {
	gen ilo_edu_attendance=.
		replace ilo_edu_attendance=1 if inlist(sek,2,3)		// Attending
		replace ilo_edu_attendance=2 if inlist(sek,1,4)		// Not attending
			}
	
		else {	
	gen ilo_edu_attendance=.
		replace ilo_edu_attendance=1 if inlist(b4_k7,2, 3)		// Attending
		replace ilo_edu_attendance=2 if inlist(b4_k7,1, 4)		// Not attending
			}
			
			label def edu_att_lab 1 "1 - Attending" 2 "2 - Not attending"
			label val ilo_edu_attendance edu_att_lab
			label var ilo_edu_attendance "Education (Attendance)

			* The category "Attending" includes as well people going to non formal schools.


			
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
*           
* Comment: wap = 15+ 

	gen ilo_wap=.
		replace ilo_wap=1 if ilo_age>=15 & ilo_age!=.
		replace ilo_wap=0 if ilo_age<15
			label var ilo_wap "Working age population"

	drop ilo_age
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Labour Force Status ('ilo_lfs') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	if year<=2013 {
	
	gen ilo_lfs=.
		replace ilo_lfs=1 if (b5p2a1==1 | b5p3==1)   									// Employed
		replace ilo_lfs=2 if (ilo_lfs!=1 & b5p7!=2 & (b5p4==1 | b5p5==1 | b5p6==2)) 	// Unemployed
		replace ilo_lfs=3 if (ilo_lfs!=1 & ilo_lfs!=2 & ilo_wap==1)  					// Outside the labour force
				label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside the Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status"
				
					}
					
	else {	
	
	gen ilo_lfs=.
		replace ilo_lfs=1 if (b5_r2a1==1 | b5_r3==1)   									// Employed
		replace ilo_lfs=2 if (ilo_lfs!=1 & b5_r7!=2 & (b5_r4==1 | b5_r5==1 | b5_r6==2)) // Unemployed
		replace ilo_lfs=3 if (ilo_lfs!=1 & ilo_lfs!=2 & ilo_wap==1)  					// Outside the labour force
				label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside the Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status"
				
					}

/* NOTE: national definition of unemployment (in the LFS report) is different from the ILO one: the
		 Indonesian definition includes as well the discouraged job-seekers and does not consider the availability to work.  */

	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	
	capture confirm var b5p17 
		if !_rc {
	clonevar add_job = b5p17
		}
		
	else {
	clonevar add_job = b5_r17
		}
	
	gen ilo_mjh=.
		replace ilo_mjh=1 if add_job==2
		replace ilo_mjh=2 if add_job==1
				replace ilo_mjh=. if ilo_lfs!=1
			lab def lab_ilo_mjh 1 "1 - One job only" 2 "2 - More than one job"
			lab val ilo_mjh lab_ilo_mjh
			lab var ilo_mjh "Multiple job holders"
			
	* Drop help variable
	
		drop add_job		

	
***********************************************************************************************
*			PART 3.1. ECONOMIC CHARACTERISTICS FOR MAIN JOB 
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Status in employment ('ilo_job1_ste') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	capture confirm var b5p12 
		if !_rc  {
	clonevar empstatus = b5p12
		}
		
	else {
	clonevar empstatus = b5_r12
		}
		
		gen ilo_job1_ste_icse93=.
			replace ilo_job1_ste_icse93=1 if inlist(empstatus,4,5,6)	// Employees
			replace ilo_job1_ste_icse93=2 if empstatus==3				// Employers
			replace ilo_job1_ste_icse93=3 if inlist(empstatus,1,2)		// Own-account workers
			*replace ilo_job1_ste_icse93=4 if							// Producer cooperatives
			replace ilo_job1_ste_icse93=5 if empstatus==7				// Contributing family workers
			*replace ilo_job1_ste_icse93=6 if 							// Not classifiable
			replace ilo_job1_ste_icse93=. if ilo_lfs!=1				
				label def label_ilo_ste_icse93 1 "1 - Employees" 2 "2 - Employers" 3 "3 - Own-account workers"  ///
											   4 "4 - Members of producers cooperatives" 5 "5 - Contributing family workers" ///
											   6 "6 - Workers not classifiable by status"
				label val ilo_job1_ste_icse93 label_ilo_ste_icse93
				label var ilo_job1_ste_icse93 "Status in employment (ICSE 93)"
			
			/*NOTES: The category employees includes as well the CASUAL employees
					 employers assisted by TEMPORARY workers/unpaid workers are classified under own-account workers	*/

	
	* Aggregate categories 
		
		gen ilo_job1_ste_aggregate=.
			replace ilo_job1_ste_aggregate=1 if ilo_job1_ste_icse93==1				// Employees
			replace ilo_job1_ste_aggregate=2 if inrange(ilo_job1_ste_icse93,2,5)	// Self-employed
			replace ilo_job1_ste_aggregate=3 if ilo_job1_ste_icse93==6				// Not elsewhere classified
				lab def ste_aggr_lab 1 "1 - Employees" 2 "2 - Self-employed" 3 "3 - Not elsewhere classified"
				lab val ilo_job1_ste_aggregate ste_aggr_lab
				label var ilo_job1_ste_aggregate "Status in employment (Aggregate)"  

			
		* Drop help variable 
		
			drop empstatus 
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------


/* National classification is based on ISIC 4 (at a 2 digit-level the national classification 
is identic to ISIC Rev. 4) */

	
	* Import value labels
	
		append using `labels'
		
* Use ISIC Rev. 3.1 if time period up to 2011Q1

	 if year<2011 | (year==2011 & quarter==1) {
	 
	 gen indu_code_prim=kbli2 if ilo_lfs==1
	 
	 	* Primary activity
		
		gen ilo_job1_eco_isic3_2digits=indu_code_prim
		
			lab values ilo_job1_eco_isic3 isic3_2digits
			lab var ilo_job1_eco_isic3_2digits "Economic activity (ISIC Rev. 3.1), 2 digit level"
			
	* One digit level
	
		* aggregation done according to information of the following document: https://unstats.un.org/unsd/statcom/doc02/isic.pdf		
		
	gen ilo_job1_eco_isic3=.
		replace ilo_job1_eco_isic3=1 if inrange(ilo_job1_eco_isic3_2digits,1,2)
		replace ilo_job1_eco_isic3=2 if ilo_job1_eco_isic3_2digits==5
		replace ilo_job1_eco_isic3=3 if inrange(ilo_job1_eco_isic3_2digits,10,14)
		replace ilo_job1_eco_isic3=4 if inrange(ilo_job1_eco_isic3_2digits,15,37)
		replace ilo_job1_eco_isic3=5 if inrange(ilo_job1_eco_isic3_2digits,40,41)
		replace ilo_job1_eco_isic3=6 if ilo_job1_eco_isic3_2digits==45
		replace ilo_job1_eco_isic3=7 if inrange(ilo_job1_eco_isic3_2digits,50,52)
		replace ilo_job1_eco_isic3=8 if ilo_job1_eco_isic3_2digits==55
		replace ilo_job1_eco_isic3=9 if inrange(ilo_job1_eco_isic3_2digits,60,64)
		replace ilo_job1_eco_isic3=10 if inrange(ilo_job1_eco_isic3_2digits,65,67)
		replace ilo_job1_eco_isic3=11 if inrange(ilo_job1_eco_isic3_2digits,70,74)
		replace ilo_job1_eco_isic3=12 if ilo_job1_eco_isic3_2digits==75
		replace ilo_job1_eco_isic3=13 if ilo_job1_eco_isic3_2digits==80
		replace ilo_job1_eco_isic3=14 if ilo_job1_eco_isic3_2digits==85
		replace ilo_job1_eco_isic3=15 if inrange(ilo_job1_eco_isic3_2digits,90,93)
		replace ilo_job1_eco_isic3=16 if ilo_job1_eco_isic3_2digits==95
		replace ilo_job1_eco_isic3=17 if ilo_job1_eco_isic3_2digits==99
		replace ilo_job1_eco_isic3=18 if ilo_job1_eco_isic3_2digits==. & ilo_lfs==1
			lab val ilo_job1_eco_isic3 isic3
			lab var ilo_job1_eco_isic3 "Economic activity (ISIC Rev. 3.1)"
			
	* Now do the classification on an aggregate level
	
	* Primary activity
	
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
			lab var ilo_job1_eco_aggregate "Economic activity (Aggregate)"

			
		* Secondary activity
		
		gen indu_code_sec=int(b5p18/1000) if ilo_mjh==2
		
		gen ilo_job2_eco_isic3_2digits=indu_code_sec
		
			lab values ilo_job2_eco_isic3 isic3_2digits
			lab var ilo_job2_eco_isic3_2digits "Economic activity (ISIC Rev. 3.1), 2 digit level, in secondary activity"
			
			* One digit level
			
				* aggregation done according to information of the following document: https://unstats.un.org/unsd/statcom/doc02/isic.pdf		
				
			gen ilo_job2_eco_isic3=.
				replace ilo_job2_eco_isic3=1 if inrange(ilo_job2_eco_isic3_2digits,1,2)
				replace ilo_job2_eco_isic3=2 if ilo_job2_eco_isic3_2digits==5
				replace ilo_job2_eco_isic3=3 if inrange(ilo_job2_eco_isic3_2digits,10,14)
				replace ilo_job2_eco_isic3=4 if inrange(ilo_job2_eco_isic3_2digits,15,37)
				replace ilo_job2_eco_isic3=5 if inrange(ilo_job2_eco_isic3_2digits,40,41)
				replace ilo_job2_eco_isic3=6 if ilo_job2_eco_isic3_2digits==45
				replace ilo_job2_eco_isic3=7 if inrange(ilo_job2_eco_isic3_2digits,50,52)
				replace ilo_job2_eco_isic3=8 if ilo_job2_eco_isic3_2digits==55
				replace ilo_job2_eco_isic3=9 if inrange(ilo_job2_eco_isic3_2digits,60,64)
				replace ilo_job2_eco_isic3=10 if inrange(ilo_job2_eco_isic3_2digits,65,67)
				replace ilo_job2_eco_isic3=11 if inrange(ilo_job2_eco_isic3_2digits,70,74)
				replace ilo_job2_eco_isic3=12 if ilo_job2_eco_isic3_2digits==75
				replace ilo_job2_eco_isic3=13 if ilo_job2_eco_isic3_2digits==80
				replace ilo_job2_eco_isic3=14 if ilo_job2_eco_isic3_2digits==85
				replace ilo_job2_eco_isic3=15 if inrange(ilo_job2_eco_isic3_2digits,90,93)
				replace ilo_job2_eco_isic3=16 if ilo_job2_eco_isic3_2digits==95
				replace ilo_job2_eco_isic3=17 if ilo_job2_eco_isic3_2digits==99
				replace ilo_job2_eco_isic3=18 if ilo_job2_eco_isic3_2digits==. & ilo_mjh==2
					lab val ilo_job2_eco_isic3 isic3
					lab var ilo_job2_eco_isic3 "Economic activity (ISIC Rev. 3.1) in secondary activity"
					
			* Now do the classification on an aggregate level
			
			* Primary activity
			
			gen ilo_job2_eco_aggregate=.
				replace ilo_job2_eco_aggregate=1 if inlist(ilo_job2_eco_isic3,1,2)
				replace ilo_job2_eco_aggregate=2 if ilo_job2_eco_isic3==4
				replace ilo_job2_eco_aggregate=3 if ilo_job2_eco_isic3==6
				replace ilo_job2_eco_aggregate=4 if inlist(ilo_job2_eco_isic3,3,5)
				replace ilo_job2_eco_aggregate=5 if inrange(ilo_job2_eco_isic3,7,11)
				replace ilo_job2_eco_aggregate=6 if inrange(ilo_job2_eco_isic3,12,17)
				replace ilo_job2_eco_aggregate=7 if ilo_job2_eco_isic3==18
					* value label already defined
					lab val ilo_job2_eco_aggregate eco_aggr_lab
					lab var ilo_job2_eco_aggregate "Economic activity (Aggregate) in secondary activity"			
		}


	else {

	/* National classification is based on ISIC 4 (at a 2 digit-level the national classification 
	   is identic to ISIC Rev. 4) */

	
	
	* MAIN JOB:
		
		* ISIC Rev. 4 - 2 digit
		/* For people without work, the economic sector is coded as 0 in the dataset */
			gen ilo_job1_eco_isic4_2digits=.
				replace ilo_job1_eco_isic4_2digits=kbli2009 if kbli2009>0 & ilo_lfs==1 
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
				replace ilo_job1_eco_isic4=22 if ilo_job1_eco_isic4==. & ilo_lfs==1
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
		/* Economic activity of the second job is only available at a 5 digit level. */
					
				* ISIC Rev. 4 - 2 digit
				
				capture confirm var b5_r18
					if !_rc {
				gen indu_code_sec=int(b5_r18/1000) if ilo_mjh==2 
					}
					
				else {					
				
				gen indu_code_sec=int(b5p18/1000) if ilo_mjh==2	
					}
				
					gen ilo_job2_eco_isic4_2digits=.
						replace ilo_job2_eco_isic4_2digits=indu_code_sec if indu_code_sec>0
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
						replace ilo_job2_eco_isic4=22 if ilo_job2_eco_isic4==. & ilo_mjh==2
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

								}
							
				drop indu_code_sec

	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_job1_ocu_isco88') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
	
	/* National classification of occupations (KBJI 2002) is based on ISCO 88.
	   Occupation only available for the main job.
	   Most recent classification only at a 1-digit level. 
	   
	   NOTE: the missing values are coded as 0, which is the same code as the occupation
			 in the armed forces. As we cannot guarantee that the 0 are actually working 
			 in the armed forces, we decided to code them as missing. */
	   
	
		* don't define variable for 2011Q1 and 2014Q3 
	   
	   if !inlist(time,"2011Q1","2014Q3") {
	   
		* ISCO 88 - 1 digit
			gen ilo_job1_ocu_isco88=.
				replace ilo_job1_ocu_isco88=kbji2002 if kbji2002>0
				replace ilo_job1_ocu_isco88=11 if kbji2002==0 & ilo_lfs==1
				replace ilo_job1_ocu_isco88=. if ilo_lfs!=1 
					lab def isco88_1dig_lab 1 "1 - Legislators, senior officials and managers" 2 "2 - Professionals" 3 "3 - Technicians and associate professionals" 4 "4 - Clerks" ///
											5 "5 - Service workers and shop and market sales workers" 6 "6 - Skilled agricultural and fishery workers" 7 "7 - Craft and related trades workers" ///
											8 "8 - Plant and machine operators, and assemblers" 9 "9 - Elementary occupations" 10 "0 - Armed forces" 11 "X - Not elsewhere classified"
					lab val ilo_job1_ocu_isco88 isco88
					lab var ilo_job1_ocu_isco88 "Occupation (ISCO-88) - Main job"	

		* Aggregate:			
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
					lab var ilo_job1_ocu_aggregate "Occupation (Aggregate) - Main job"	
					
		* Skill level	
		
		gen ilo_job1_ocu_skill=.
			replace ilo_job1_ocu_skill=1 if ilo_job1_ocu_isco88==9
			replace ilo_job1_ocu_skill=2 if inlist(ilo_job1_ocu_isco88,4,5,6,7,8)
			replace ilo_job1_ocu_skill=3 if inlist(ilo_job1_ocu_isco88,1,2,3)
			replace ilo_job1_ocu_skill=4 if inlist(ilo_job1_ocu_isco88,10,11)
				lab def ocu_skill_lab 1 "1 - Skill level 1 (low)" 2 "2 - Skill level 2 (medium)" 3 "3 - Skill levels 3 and 4 (high)" 4 "4 - Not elsewhere classified"
				lab val ilo_job1_ocu_skill ocu_skill_lab
				lab var ilo_job1_ocu_skill "Occupation (Skill level)"
				
				}
	
	
		* Drop the variables used for labelling occupation:	
			drop isco88_2digits isco88 isco08_2digits isco08 
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_job1_ins_sector') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
	
	/* Institutional sector not specified in the data. */
	
	

	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Hours of work ('ilo_job1_how_actual') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
		
		
	* Only hours actually worked available
		
		* Main job:
		
		capture confirm var b5p11 
		
		if !_rc {
			
			gen ilo_job1_how_actual=b5p11	
				}
			
		else {		
			gen ilo_job1_how_actual=b5_r11 
				}
				
				replace ilo_job1_how_actual=. if ilo_lfs!=1
					lab var ilo_job1_how_actual "Weekly hours actually worked in main job"
					
		
			gen ilo_job1_how_actual_bands=.
				replace ilo_job1_how_actual_bands=1 if ilo_job1_how_actual==0
				replace ilo_job1_how_actual_bands=2 if inrange(ilo_job1_how_actual,1,14)
				replace ilo_job1_how_actual_bands=3 if inrange(ilo_job1_how_actual,15,29)
				replace ilo_job1_how_actual_bands=4 if inrange(ilo_job1_how_actual,30,34)
				replace ilo_job1_how_actual_bands=5 if inrange(ilo_job1_how_actual,35,39)
				replace ilo_job1_how_actual_bands=6 if inrange(ilo_job1_how_actual,40,48)
				replace ilo_job1_how_actual_bands=7 if ilo_job1_how_actual>=49 & ilo_job1_how_actual!=.
				replace ilo_job1_how_actual_bands=. if ilo_lfs!=1
					lab def how_bands_lab 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 
					lab val ilo_job1_how_actual_bands how_bands_lab
					lab var ilo_job1_how_actual_bands "Weekly hours actually worked bands in main job"
		
		
		* All jobs:
		
		capture confirm var b5p8b 
		
		if !_rc {
			
			gen ilo_joball_how_actual=b5p8b 
				}
				
		else {
		
			gen ilo_joball_how_actual=b5_r8b
				}
				
				replace ilo_joball_how_actual=. if ilo_lfs!=1
					lab var ilo_joball_how_actual "Weekly hours actually worked in all jobs"
					
		
			gen ilo_joball_how_actual_bands=.
				replace ilo_joball_how_actual_bands=1 if ilo_joball_how_actual==0
				replace ilo_joball_how_actual_bands=2 if inrange(ilo_joball_how_actual,1,14)
				replace ilo_joball_how_actual_bands=3 if inrange(ilo_joball_how_actual,15,29)
				replace ilo_joball_how_actual_bands=4 if inrange(ilo_joball_how_actual,30,34)
				replace ilo_joball_how_actual_bands=5 if inrange(ilo_joball_how_actual,35,39)
				replace ilo_joball_how_actual_bands=6 if inrange(ilo_joball_how_actual,40,48)
				replace ilo_joball_how_actual_bands=7 if ilo_joball_how_actual>=49 & ilo_joball_how_actual!=.
				replace ilo_joball_how_actual_bands=. if ilo_lfs!=1
					lab val ilo_joball_how_actual_bands how_bands_lab
					lab var ilo_joball_how_actual_bands "Weekly hours actually worked bands in all jobs"
		
		
		/* Number of hours worked in second job is not asked in the questionnaire  */ 

		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job1_job_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
		
		
	/* The normal working time in the country is 35 hours (used as a threshold) 
	   As we only have the actual hours, the working time arrangement is assesed on 
	   the ACTUAL working hours of the reference week.  		*/
	
	
		* Main job:
			gen ilo_job1_job_time=.
				replace ilo_job1_job_time=1 if ilo_job1_how_actual<35 & ilo_job1_how_actual>0
				replace ilo_job1_job_time=2 if ilo_job1_how_actual>=35 & ilo_job1_how_actual!=.
				replace ilo_job1_job_time=3 if ilo_job1_how_actual==0 & ilo_lfs==1
						replace ilo_job1_job_time=. if ilo_lfs!=1
					lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
					lab val ilo_job1_job_time job_time_lab
					lab var ilo_job1_job_time "Job (Working time arrangement) - Main job"	
			
		
		* All jobs:
			gen ilo_joball_job_time=.
				replace ilo_joball_job_time=1 if ilo_joball_how_actual<35 & ilo_joball_how_actual>0
				replace ilo_joball_job_time=2 if ilo_joball_how_actual>=35 & ilo_joball_how_actual!=.
				replace ilo_joball_job_time=3 if ilo_joball_how_actual==0 & ilo_lfs==1
						replace ilo_joball_job_time=. if ilo_lfs!=1
					lab def joball_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
					lab val ilo_joball_job_time joball_time_lab
					lab var ilo_joball_job_time "Job (Working time arrangement) - All jobs"	
			
	
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job1_job_contract') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			

		* No information on the type of contract.

		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Formal / Informal Economy ('ilo_job1_ife_prod' 'ilo_job1_ife_nature') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
				
		
	/* We do not have enough information the measure informal economy (no question about 
	   the institutional sector, the location of workplace, the size of the company or 
	   the social security coverage. */
		


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Monthly labour related income ('ilo_job1_lri') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
				
	
	/* NOTES:
	   In the questionnaire it is asked how much the person usually gets per month in cash or in goods.
	   The question is the same for all workers regarless their status in employment.
	   The question is only asked for the main job.
	   Unit: local currency */
	   
	   capture confirm var b5p13a b5p13b
	   
		if !_rc {
			clonevar earn_cash = b5p13a
			clonevar earn_inkind = b5p13b
			}
			
		else {
			clonevar earn_cash = b5_r13a
			clonevar earn_inkind = b5_r13b
				}
	   
			* Main job
				
				* Employees
					egen ilo_job1_lri_ees =rowtotal(earn_cash earn_inkind) if ilo_job1_ste_aggregate==1 , m
						replace ilo_job1_lri_ees=. if ilo_job1_lri_ees<0
							lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"	
				
				* Self-employed:
					egen ilo_job1_lri_slf =rowtotal(earn_cash earn_inkind) if ilo_job1_ste_aggregate==2 , m
							lab var ilo_job1_lri_slf "Monthly labour related income of self-employed in main job"	
			
		
		* Drop help variables
			drop earn_cash earn_inkind

		
***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_joball_tru') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
		
		/* We cannot compute the ilo-definition of TRU because we cannot asses the willingness to work 
		   additional hours. The country uses as a proxy the fact that the worker is still looking for 
		   a job but it includes as well people looking for a job for other reasons.		*/
	

	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupational injury ('ilo_joball_inj') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
		
		* No question related to this topic in the questionnaire.
		


		
***********************************************************************************************
*			PART 3.3. UNEMPLOYMENT: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Category of unemployment ('ilo_cat_une') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	
		capture confirm var b5p23 
			if !_rc {
		gen ilo_cat_une=.
			replace ilo_cat_une=1 if ilo_lfs==2 & b5p23==1							// Previously employed
			replace ilo_cat_une=2 if ilo_lfs==2 & b5p23==2							// Seeking first job
			replace ilo_cat_une=3 if ilo_lfs==2 & ilo_cat_une!=1 & ilo_cat_une!=2	// Unknown
				}
				
			else {		
		gen ilo_cat_une=.
			replace ilo_cat_une=1 if ilo_lfs==2 & b5_r23==1							// Previously employed
			replace ilo_cat_une=2 if ilo_lfs==2 & b5_r23==2							// Seeking first job
			replace ilo_cat_une=3 if ilo_lfs==2 & ilo_cat_une!=1 & ilo_cat_une!=2	// Unknown
				}
				lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
				lab val ilo_cat_une cat_une_lab
				lab var ilo_cat_une "Category of unemployment"
	
	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	
	
	/* NOTE: variable b5_r21a indicates number of years spent looking for a job
			 variable b5_r21b indicates number of months spent looking for a job	*/

			 
		* generate a new variable indicating the total number of months looking for a job:
			
			
			if year<=2013 {
			
			gen tot_month_une=.
				replace tot_month_une = 12*b5p21a + b5p21b if ilo_lfs==2
				
					}
					
			else {
			
			gen tot_month_une=.
				replace tot_month_une = 12*b5_r21a + b5_r21b if ilo_lfs==2
					}
			
			gen ilo_dur_details=.
				replace ilo_dur_details=1 if tot_month_une<1
				replace ilo_dur_details=2 if tot_month_une>=1 & tot_month_une<3
				replace ilo_dur_details=3 if tot_month_une>=3 & tot_month_une<6
				replace ilo_dur_details=4 if tot_month_une>=6 & tot_month_une<12
				replace ilo_dur_details=5 if tot_month_une>=12 & tot_month_une<24
				replace ilo_dur_details=6 if tot_month_une>=24 & tot_month_une!=.
				replace ilo_dur_details=7 if tot_month_une==. & ilo_lfs==2
				replace ilo_dur_details=. if ilo_lfs!=2
					lab def ilo_unemp_det 1 "Less than 1 month" 2 "1 month to less than 3 months" 3 "3 months to less than 6 months" 4 "6 months to less than 12 months" 5 "12 months to less than 24 months" ///
										  6 "24 months or more" 7 "Not elsewhere classified"
					lab values ilo_dur_details ilo_unemp_det
					lab var ilo_dur_details "Duration of unemployment (Details)"
		

			gen ilo_dur_aggregate=.
				replace ilo_dur_aggregate=1 if inrange(ilo_dur_details,1,3)
				replace ilo_dur_aggregate=2 if ilo_dur_details==4
				replace ilo_dur_aggregate=3 if inrange(ilo_dur_details,5,6)
				replace ilo_dur_aggregate=4 if ilo_dur_details==7
					lab def ilo_unemp_aggr 1 "Less than 6 months" 2 "6 months to less than 12 months" 3 "12 months or more" 4 "Not elsewhere classified"
					lab val ilo_dur_aggregate ilo_unemp_aggr
					lab var ilo_dur_aggregate "Duration of unemployment (Aggregate)"

			drop tot_month_une		
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4')  [don't keep]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
	* Filter question --> does not capture all previous occupation, unless if occupation left up to 
		* one year ago --> don't keep variable
	
		/* Economic activity of the previous job is only available at a 5 digit level. */
		
					/*
					* ISIC Rev. 4 - 2 digit
					
					if year<=2013 {
					
					gen indu_code_une_2dig=int(b5p26/1000) if ilo_cat_une==1
						}
						
					else {

					gen indu_code_une_2dig=int(b5_r26/1000) if ilo_cat_une==1
						}

				gen ilo_preveco_isic4_2digits=.
						replace ilo_preveco_isic4_2digits=indu_code_une_2dig if indu_code_une_2dig>0 & ilo_cat_une==1
						lab values ilo_preveco_isic4_2digits isic4_2digits
						lab var ilo_preveco_isic4_2digits "Previous economic activity (ISIC Rev. 4), 2 digit level"
						
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
						replace ilo_preveco_isic4=22 if ilo_preveco_isic4_2digits==. & ilo_cat_une==1
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
	
	
		drop ilo_preveco_isic4_2digits indu_code_une_2dig
		*/
				
		* Drop the variables used for labelling economic activity:	
			
				drop  isic4_2digits isic4 isic3_2digits isic3 
				drop if missing(ilo_key) /// To drop empty lines added for the labels 

	
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
	* No information on the previous occupation in the dataset
	

	
***********************************************************************************************
*			PART 3.4. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma') [don't keep]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
	
	* Don't keep variable as very high share falls into category unknown
	
	
	/*
	gen ilo_olf_dlma=.
		replace ilo_olf_dlma = 1 if b5_r4==1 & b5_r7==2 & ilo_lfs==3 				// Seeking, not available
		replace ilo_olf_dlma = 2 if b5_r4==2 & b5_r7==1 & ilo_lfs==3				// Not seeking, available
		* replace ilo_olf_dlma = 3 if 												// Not seeking, not available, willing
		* replace ilo_olf_dlma = 4 if 												// Not seeking, not available, not willing
		replace ilo_olf_dlma = 5 if ilo_olf_dlma!=1 & ilo_olf_dlma!=2 & ilo_lfs==3	// Not classified (not seeking, not available)
	
			lab def dlma_lab 1 "1 - Seeking, not available (Unavailable jobseekers)" 2 "2 - Not seeking, available (Available potential jobseekers)" ///
							 3 "3 - Not seeking, not available, willing (Willing non-jobseekers)" 4 "4 - Not seeking, not available, not willing" 5 "X - Not elsewhere classified"
			lab val ilo_olf_dlma dlma_lab 
			lab var ilo_olf_dlma "Labour market attachment (Degree of)"
	
	/* We cannot asses the wilingness to work. Consequently the people not seeking and not available are under "5 - Not classified". */
	
	*/

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reason for not seeking job ('ilo_olf_reason') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		


	if year<=2013 {
	
	clonevar var_olf = b5p6
		}
		
	else {
	
	clonevar var_olf = b5_r6
	
		}
	
	gen ilo_olf_reason=.
		
		replace ilo_olf_reason=1 if	(var_olf==1 & ilo_lfs==3)				//Labour market
		replace ilo_olf_reason=2 if	inlist(var_olf,3,4,7) & ilo_lfs==3	//Personal / Family-related
		replace ilo_olf_reason=3 if	(var_olf==6 & ilo_lfs==3)				//Does not need/want to work
		replace ilo_olf_reason=4 if (var_olf==8 | var_olf==.) & ilo_lfs==3	//Not elsewhere classified
			
			lab def reason_lab 1 "1 - Labour market" 2 "2 - Personal / Family-related" 3 "3 - Does not need/want to work" 4 "4 - Not elsewhere classified" 
			lab val ilo_olf_reason reason_lab 
			lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"
	
		
	* Drop help variable 
	
		drop var_olf
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seeker ('ilo_dis')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

	if year<=2013 {
	
	gen ilo_dis=1 if ilo_lfs==3 & b5p7==1 & ilo_olf_reason==1
		}
		
	else {
	
	gen ilo_dis=1 if ilo_lfs==3 & b5_r7==1 & ilo_olf_reason==1
		}
			
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

*			3. SAVE ILO-VARIABLES IN A NEW DATASET

***********************************************************************************************
***********************************************************************************************


* -------------------------------------------------------------
* 	Prepare final datasets
* -------------------------------------------------------------

	* drop help variables for time
	
	drop time year quarter

	* Full dataset with original variables and ILO ones
	
	cd "$outpath"

    * Save dataset including original and ilo variables
	
		save ${country}_${source}_${time}_FULL,  replace		
	
	* Save file only containing ilo_* variables
	
		keep ilo*

		save ${country}_${source}_${time}_ILO, replace

