* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Indonesia
* DATASET USED: Indonesia LFS
* NOTES: 
* Files created: Standard variables on LFS Indonesia
* Authors: Marylène Escher
* Who last updated the file: Podjanin
* Starting Date: 29 July 2016
* Last updated: 16 March 2017
***********************************************************************************************
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
global time "2007Q3"
global inputFile "SAK0807.dta"
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
		
*  Dataset for 2002: many variables are in strings, but contain only numbers - destring them

		if year==2002 {
		
		destring *, replace 
		
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
	
	if year==2005 {
	
	gen ilo_wgt=timbang
		}
	
	if year==2002 {
	
	gen ilo_wgt=infl
	
	}
	
	if !inlist(year,2002,2005) {	
	
	gen ilo_wgt=weight
		}
	
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

	if year==2005 {
	
	gen ilo_geo=daerah
		}
		
	if year==2002 {
	
	gen ilo_geo=b1r5
	
		}

	if !inlist(year,2002,2005) {
	
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
	gen ilo_sex=b3k4
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

* Minimum age considered by dataset: 10 years
	
	capture confirm variable umur 
	
	if !_rc {
	gen ilo_age=umur
		}
		
	else {
	gen ilo_age=b3k5
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
		
/* Use ISCED-97 mapping	*/

* Note that according to the definition, the highest level being CONCLUDED is being considered
	
	
	if year==2002 {
	
	gen ilo_edu_isced97=.
		* No schooling
		replace ilo_edu_isced97=1 if b4ar1a==1
		* Pre-primary education
		replace ilo_edu_isced97=2 if b4ar1a==2
		* Primary education or first stage of basic education
		replace ilo_edu_isced97=3 if b4ar1a==3
		* Lower secondary education or second stage of basic education
		replace ilo_edu_isced97=4 if inlist(b4ar1a,4,5)
		* Upper secondary education
		replace ilo_edu_isced97=5 if inlist(b4ar1a,6,7)
		* Post-secondary non-tertiary education
		/* replace ilo_edu_isced97=6 if */
		* First stage of tertiary education
		replace ilo_edu_isced97=7 if inlist(b4ar1a,8,9,0)
		* Second stage of tertiary education
		/* replace ilo_edu_isced97=8 if */
		* Level not stated
		replace ilo_edu_isced97=9 if ilo_edu_isced97==.			
		
			}
	
	if year<=2006 & year!=2002 {
	
	gen ilo_edu_isced97=.
		* No schooling
		replace ilo_edu_isced97=1 if b4p1a==0
		* Pre-primary education
		replace ilo_edu_isced97=2 if b4p1a==1
		* Primary education or first stage of basic education
		replace ilo_edu_isced97=3 if b4p1a==2
		* Lower secondary education or second stage of basic education
		replace ilo_edu_isced97=4 if inlist(b4p1a,3,4)
		* Upper secondary education
		replace ilo_edu_isced97=5 if inlist(b4p1a,5,6)
		* Post-secondary non-tertiary education
		/* replace ilo_edu_isced97=6 if */
		* First stage of tertiary education
		replace ilo_edu_isced97=7 if inlist(b4p1a,7,8,9)
		* Second stage of tertiary education
		/* replace ilo_edu_isced97=8 if */
		* Level not stated
		replace ilo_edu_isced97=9 if ilo_edu_isced97==.
		
		}
	
	if year==2007 {
	
	gen ilo_edu_isced97=.
		* No schooling
		replace ilo_edu_isced97=1 if b4p1a==1
		* Pre-primary education
		replace ilo_edu_isced97=2 if b4p1a==2
		* Primary education or first stage of basic education
		replace ilo_edu_isced97=3 if b4p1a==3
		* Lower secondary education or second stage of basic education
		replace ilo_edu_isced97=4 if inlist(b4p1a,4,5)
		* Upper secondary education
		replace ilo_edu_isced97=5 if inlist(b4p1a,6,7)
		* Post-secondary non-tertiary education
		/* replace ilo_edu_isced97=6 if */
		* First stage of tertiary education
		replace ilo_edu_isced97=7 if inlist(b4p1a,8,9,10)
		* Second stage of tertiary education
		/* replace ilo_edu_isced97=8 if */
		* Level not stated
		replace ilo_edu_isced97=9 if ilo_edu_isced97==.
		
			}
			
			label def isced_97_lab 1 "X - No schooling" 2 "0 - Pre-primary education" 3 "1 - Primary education or first stage of basic education" 4 "2 - Lower secondary education or second stage of basic education" ///
							5 "3 - Upper secondary education" 6 "4 - Post-secondary non-tertiary education" 7 "5 - First stage of tertiary education (not leading directly to an advanced research qualification)" ///
							8 "6 - Second stage of tertiary education (leading to an advanced research qualification)" 9 "UNK - Level not stated"
			label val ilo_edu_isced97 isced_97_lab
			lab var ilo_edu_isced97 "Level of education (ISCED 97)"
			
	gen ilo_edu_aggregate=.
		replace ilo_edu_aggregate=1 if inlist(ilo_edu_isced97,1,2)
		replace ilo_edu_aggregate=2 if inlist(ilo_edu_isced97,3,4)
		replace ilo_edu_aggregate=3 if inlist(ilo_edu_isced97,5,6)
		replace ilo_edu_aggregate=4 if inlist(ilo_edu_isced97,7,8)
		replace ilo_edu_aggregate=5 if ilo_edu_isced97==9
			label def edu_aggr_lab 1 "1 - Less than basic" 2 "2 - Basic" 3 "3 - Intermediate" 4 "4 - Advanced" 5 "5 - Level not stated"
			label val ilo_edu_aggregate edu_aggr_lab
			label var ilo_edu_aggregate "Level of education (Aggregate levels)"
	
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education attendance ('ilo_edu_attendance') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	capture confirm variable sek
		if !_rc {

	gen ilo_edu_attendance=.
		replace ilo_edu_attendance=1 if sek==2						// Attending
		replace ilo_edu_attendance=2 if inlist(sek,1,3)				// Not attending
		replace ilo_edu_attendance=3 if ilo_edu_attendance==. 		// Not elsewhere classified
			}
			
	else {
	
	gen ilo_edu_attendance=.
		replace ilo_edu_attendance=1 if b3k7==2						// Attending
		replace ilo_edu_attendance=2 if inlist(b3k7,1,3)			// Not attending
		replace ilo_edu_attendance=3 if ilo_edu_attendance==. 		// Not elsewhere classified
			}
			
			label def edu_att_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
			label val ilo_edu_attendance edu_att_lab
			label var ilo_edu_attendance "Education (Attendance)"

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

	 * Important --> if people have stated that they are actively seeking a job, or were preparing for a 
			* business in the past week, they were not asked about their availability --> consequently only two criteria can be 
			* used for the definition of unemployment (except for future starters who are asked about their availability to work
	
	if year==2002 {
	
	gen ilo_lfs=.
		replace ilo_lfs=1 if (b4br2a1==1 | b4br3==1)   									// Employed
		replace ilo_lfs=2 if (ilo_lfs!=1 & b4er22!=2 & (b4br4==1 | b4br5==1 | b4er21==2)) 	// Unemployed
		replace ilo_lfs=3 if (ilo_lfs!=1 & ilo_lfs!=2 & ilo_wap==1)  					// Outside the labour force
		
			}
	
	if year<=2006 & year!=2002 {
	
	gen ilo_lfs=.
		replace ilo_lfs=1 if (b4p2a1==1 | b4p3==1)   									// Employed
		replace ilo_lfs=2 if (ilo_lfs!=1 & b4p22!=2 & (b4p4==1 | b4p5==1 | b4p21==2)) 	// Unemployed
		replace ilo_lfs=3 if (ilo_lfs!=1 & ilo_lfs!=2 & ilo_wap==1)  					// Outside the labour force
			}
		
	if year==2007 {
	
	gen ilo_lfs=.
		replace ilo_lfs=1 if (b4p2a1==1 | b4p3==1)   									// Employed
		replace ilo_lfs=2 if (ilo_lfs!=1 & b4p24!=2 & (b4p4==1 | b4p5==1 | b4p23==2)) 	// Unemployed
		replace ilo_lfs=3 if (ilo_lfs!=1 & ilo_lfs!=2 & ilo_wap==1)  					// Outside the labour force
			}
			
			
			label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside the Labour Force"
			label value ilo_lfs label_ilo_lfs
			label var ilo_lfs "Labour Force Status"

/* NOTE: national definition of unemployment (in the LFS report) is different from the ILO one: the
		 Indonesian definition includes as well the discouraged job-seekers and does not consider the availability to work.  */
		 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	if year==2002 {
	
	gen ilo_mjh=.
		replace ilo_mjh=1 if b4dr15==2
		replace ilo_mjh=2 if b4dr15==1
		
			}

	if year<=2006 & year!=2002{
	
	gen ilo_mjh=.
		replace ilo_mjh=1 if b4p15==2
		replace ilo_mjh=2 if b4p15==1
			}
			
	if year==2007 {
	
	gen ilo_mjh=.
		replace ilo_mjh=1 if b4p17==2
		replace ilo_mjh=2 if b4p17==1
			}
			
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

		if year==2002 {
		
		clonevar empstatus = b4cr10a 
		
			}		
		
		if year<=2006 & year!=2002 {
		
		clonevar empstatus = b4p10
		
			}
			
		if year==2007 {
		
		clonevar empstatus = b4p11a 
		
			}
				
		gen ilo_job1_ste_icse93=.
			replace ilo_job1_ste_icse93=1 if inlist(empstatus,4,5,6)					// Employees
			replace ilo_job1_ste_icse93=2 if empstatus==3								// Employers
			replace ilo_job1_ste_icse93=3 if inlist(empstatus,1,2)						// Own-account workers
			*replace ilo_job1_ste_icse93=4 if											// Producer cooperatives
			replace ilo_job1_ste_icse93=5 if empstatus==7								// Contributing family workers
			replace ilo_job1_ste_icse93=6 if ilo_job1_ste_icse93==. & ilo_lfs==1		// Not classifiable
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


	* Import value labels

		append using `labels'
		
* Use ISIC Rev. 3.1 

	if year==2002 {
	gen indu_code_prim=int(b4cr7/10) if ilo_lfs==1 
		}
	
	if year<=2006 & year!=2002 {
	gen indu_code_prim=int(b4p7/10) if ilo_lfs==1
		}
	
	if year==2007 {
	gen indu_code_prim=int(b4p7/1000) if ilo_lfs==1 & b4p7!=99999
		}
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
		
		if year==2002 {
		
		gen indu_code_sec=int(b4dr16/10) if ilo_mjh==2 
		
			}
		
		if year<=2006 & year!=2002 {
		
		gen indu_code_sec=int(b4p16/10) if ilo_mjh==2 
		
			}
			
		if year==2007 {
		
		gen indu_code_sec=int(b4p18/1000) if ilo_mjh==2 & b4p18!=99999
		
			}
		
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
	
							
				drop indu_code_*

	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_job1_ocu_isco88') [CHECK whether properly aligned]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
	
	/* National classification of occupations (KBJI 2002) is based on ISCO 88.
	   Occupation only available for the main job.
	   Most recent classification only at a 1-digit level. 
	   
	   NOTE: the missing values are coded as 0, which is the same code as the occupation
			 in the armed forces. As we cannot guarantee that the 0 are actually working 
			 in the armed forces, we decided to code them as missing. */
			 
		* classification does not follow ISCO -- find correspondence tables, otherwise dont' keep variable		
		
		if year==2002 {
		
		gen occ_code_prim=int(b4cr8/10) if ilo_lfs==1
		
			}
			
		else {
		
		gen occ_code_prim=int(b4p8/100) if ilo_lfs==1
		
			}
				
		* ISCO-88 2 digit level
		
		gen ilo_job1_ocu_isco88_2digits=occ_code_prim
			lab values ilo_job1_ocu_isco88_2digits isco88_2digits
			lab var ilo_job1_ocu_isco88_2digits "Occupation (ISCO-88), 2 digit level"
		
		* 1 digit
		
		gen occ_code_prim_1dig=int(occ_code_prim/10) if ilo_lfs==1

		* ISCO 88 - 1 digit
			gen ilo_job1_ocu_isco88=.
				replace ilo_job1_ocu_isco88=occ_code_prim if occ_code_prim>0
				replace ilo_job1_ocu_isco88=11 if ilo_job1_ocu_isco88==. & ilo_lfs==1
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
	
		* Primary occupation
	
		gen ilo_job1_ocu_skill=.
			replace ilo_job1_ocu_skill=1 if ilo_job1_ocu_isco88==9
			replace ilo_job1_ocu_skill=2 if inlist(ilo_job1_ocu_isco88,4,5,6,7,8)
			replace ilo_job1_ocu_skill=3 if inlist(ilo_job1_ocu_isco88,1,2,3)
			replace ilo_job1_ocu_skill=4 if inlist(ilo_job1_ocu_isco88,10,11)
				lab def ocu_skill_lab 1 "1 - Skill level 1 (low)" 2 "2 - Skill level 2 (medium)" 3 "3 - Skill levels 3 and 4 (high)" 4 "4 - Not elsewhere classified"
				lab val ilo_job1_ocu_skill ocu_skill_lab
				lab var ilo_job1_ocu_skill "Occupation (Skill level)"
	
		* Drop the variables used for labelling occupation:	
			drop isco88_2digits isco88 isco08_2digits isco08 occ_code_*

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
		
			if year==2002 {
			gen ilo_job1_how_actual=b4cr9 
				}
				
			else {		
			gen ilo_job1_how_actual=b4p9 
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
		
			if year==2002 {
			gen ilo_joball_how_actual=b4br6b
				}
				
			else {
			gen ilo_joball_how_actual=b4p6b
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
					lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
					lab val ilo_job1_job_time job_time_lab
					lab var ilo_job1_job_time "Job (Working time arrangement) - Main job"	
			
		
		* All jobs:
			gen ilo_joball_job_time=.
				replace ilo_joball_job_time=1 if ilo_joball_how_actual<35 & ilo_joball_how_actual>0
				replace ilo_joball_job_time=2 if ilo_joball_how_actual>=35 & ilo_joball_how_actual!=.
				replace ilo_joball_job_time=3 if ilo_joball_how_actual==0 & ilo_lfs==1
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
	   The question is the same for all workers regardless their status in employment.
	   The question is only asked for the main job.
	   Unit: local currency - Inonesian rupiah */

   
	if year==2002 {
	
		clonevar earn_cash = b4cr12a
		clonevar earn_inkind = b4cr12b 
			}		
	
	if year<=2006 & year!=2002 {
	
		clonevar earn_cash = b4p12a
		clonevar earn_inkind = b4p12b
		
			}
			
	if year==2007 {
	
		clonevar earn_cash = b4p13a
		clonevar earn_inkind = b4p13b 
		
			}
			   
		* Main job
			
			* Employees
				egen ilo_job1_lri_ees =rowtotal(earn_cash earn_inkind) if ilo_job1_ste_aggregate==1, m
							replace ilo_job1_lri_ees=. if ilo_job1_lri_ees<0
						lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"	
			
			* Self-employed:
				egen ilo_job1_lri_slf =rowtotal(earn_cash earn_inkind) if ilo_job1_ste_aggregate==2, m
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
	
		if year==2002 {
		
		gen ilo_cat_une=.
			replace ilo_cat_une=1 if ilo_lfs==2 & b4fr23==1						// Previously employed
			replace ilo_cat_une=2 if ilo_lfs==2 & b4fr23==2						// Seeking first job
			replace ilo_cat_une=3 if ilo_lfs==2 & ilo_cat_une!=1 & ilo_cat_une!=2	//Unknown
			
				}		
		
		if year<=2006 & year!=2002 {
		
			gen ilo_cat_une=.
			replace ilo_cat_une=1 if ilo_lfs==2 & b4p23==1						// Previously employed
			replace ilo_cat_une=2 if ilo_lfs==2 & b4p23==2						// Seeking first job
			replace ilo_cat_une=3 if ilo_lfs==2 & ilo_cat_une!=1 & ilo_cat_une!=2	//Unknown
			
				}
				
		if year==2007 {		
		
		gen ilo_cat_une=.
			replace ilo_cat_une=1 if ilo_lfs==2 & b4p25==1						// Previously employed
			replace ilo_cat_une=2 if ilo_lfs==2 & b4p25==2						// Seeking first job
			replace ilo_cat_une=3 if ilo_lfs==2 & ilo_cat_une!=1 & ilo_cat_une!=2	//Unknown
			
				}
				
		replace ilo_cat_une=. if ilo_lfs!=2
			lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
			lab val ilo_cat_une cat_une_lab
			lab var ilo_cat_une "Category of unemployment"
			

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

			 
		* generate a new variable indicating the total number of months looking for a job:
		
		if year==2002 {
		
		gen tot_month_une=b4er19
			}
			
		if year<=2006 & year!=2002 {
		
		gen tot_month_une=b4p19	
			}
		
		if year==2007 {
		
		gen tot_month_une=b4p21 
			}
		
		gen ilo_dur_details=.
			replace ilo_dur_details=1 if tot_month_une<1
			replace ilo_dur_details=2 if tot_month_une>=1 & tot_month_une<3
			replace ilo_dur_details=3 if tot_month_une>=3 & tot_month_une<6
			replace ilo_dur_details=4 if tot_month_une>=6 & tot_month_une<12
			replace ilo_dur_details=5 if tot_month_une>=12 & tot_month_une<24
			replace ilo_dur_details=6 if tot_month_une>=24 & tot_month_une!=.
			replace ilo_dur_details=7 if tot_month_une==. & ilo_lfs==2
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
*			Previous economic activity ('ilo_preveco_isic4')  [don't keep variable]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	

	/* Economic activity of the previous job is only available at a 5 digit level. */

	
	* due to a filter question (question 25), not all people that were previously employed were asked 
		* about their previous employment - as not entire scope covered, don't keep variable
	
			
		/*

		gen indu_code_une_2dig=int(b5p27/1000) if ilo_cat_une==1 & b5p27!=99999

		gen ilo_preveco_isic3_2digits=.
				replace ilo_preveco_isic3_2digits=indu_code_une_2dig 
				lab values ilo_preveco_isic3_2digits isic3_2digits
				lab var ilo_preveco_isic3_2digits "Previous economic activity (ISIC Rev. 3.1), 2 digit level"
				
		* 1 digit		
		
		gen ilo_preveco_isic3=.
			replace ilo_preveco_isic3=1 if inrange(ilo_preveco_isic3_2digits,1,2)
			replace ilo_preveco_isic3=2 if ilo_preveco_isic3_2digits==5
			replace ilo_preveco_isic3=3 if inrange(ilo_preveco_isic3_2digits,10,14)
			replace ilo_preveco_isic3=4 if inrange(ilo_preveco_isic3_2digits,15,37)
			replace ilo_preveco_isic3=5 if inrange(ilo_preveco_isic3_2digits,40,41)
			replace ilo_preveco_isic3=6 if ilo_preveco_isic3_2digits==45
			replace ilo_preveco_isic3=7 if inrange(ilo_preveco_isic3_2digits,50,52)
			replace ilo_preveco_isic3=8 if ilo_preveco_isic3_2digits==55
			replace ilo_preveco_isic3=9 if inrange(ilo_preveco_isic3_2digits,60,64)
			replace ilo_preveco_isic3=10 if inrange(ilo_preveco_isic3_2digits,65,67)
			replace ilo_preveco_isic3=11 if inrange(ilo_preveco_isic3_2digits,70,74)
			replace ilo_preveco_isic3=12 if ilo_preveco_isic3_2digits==75
			replace ilo_preveco_isic3=13 if ilo_preveco_isic3_2digits==80
			replace ilo_preveco_isic3=14 if ilo_preveco_isic3_2digits==85
			replace ilo_preveco_isic3=15 if inrange(ilo_preveco_isic3_2digits,90,93)
			replace ilo_preveco_isic3=16 if ilo_preveco_isic3_2digits==95
			replace ilo_preveco_isic3=17 if ilo_preveco_isic3_2digits==99
			replace ilo_preveco_isic3=18 if ilo_preveco_isic3_2digits==. & ilo_cat_une==1
				lab val ilo_preveco_isic3 isic3
				lab var ilo_preveco_isic3 "Previous economic activity (ISIC Rev. 3.1)"
				
		* Aggregate level
		
		gen ilo_preveco_aggregate=.
			replace ilo_preveco_aggregate=1 if inlist(ilo_preveco_isic3,1,2)
			replace ilo_preveco_aggregate=2 if ilo_preveco_isic3==4
			replace ilo_preveco_aggregate=3 if ilo_preveco_isic3==6
			replace ilo_preveco_aggregate=4 if inlist(ilo_preveco_isic3,3,5)
			replace ilo_preveco_aggregate=5 if inrange(ilo_preveco_isic3,7,11)
			replace ilo_preveco_aggregate=6 if inrange(ilo_preveco_isic3,12,17)
			replace ilo_preveco_aggregate=7 if ilo_preveco_isic3==18
				* value label already defined		
				lab val ilo_preveco_aggregate eco_aggr_lab
				lab var ilo_preveco_aggregate "Previous economic activity (Aggregate)"
				
				*/

	* Drop the variables used for labelling economic activity:	
		
			* drop ilo_preveco_isic3_2digits indu_code_une_2dig
			
			drop isic4_2digits isic4 isic3_2digits isic3 
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
*			Degree of labour market attachment ('ilo_olf_dlma') [don't keep variable]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
	
* Don't keep variable, as too many observations end up in the category "Not elsewhere classified"
	
	/*
	gen ilo_olf_dlma=.
		replace ilo_olf_dlma = 1 if b5p4==1 & b5p23==2 & ilo_lfs==3 	//Seeking, not available
		replace ilo_olf_dlma = 2 if b5p4==2 & b5p23==1 & ilo_lfs==3	//Not seeking, available
		* replace ilo_olf_dlma = 3 if 									//Not seeking, not available, willing
		* replace ilo_olf_dlma = 4 if 									//Not seeking, not available, not willing
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

	if year==2002 {
	
	clonevar var_olf = b4er21
		}
	
	if year<=2006 & year!=2002 {
	
		clonevar var_olf = b4p21
			}
			
	if year ==2007 {
	
		clonevar var_olf = b4p23
			}	
	
	gen ilo_olf_reason=.		
		replace ilo_olf_reason=1 if	(var_olf==1 & ilo_lfs==3)				//Labour market
		replace ilo_olf_reason=2 if	inlist(var_olf,3,4,7) & ilo_lfs==3	//Personal / Family-related
		replace ilo_olf_reason=3 if	(var_olf==6 & ilo_lfs==3)				//Does not need/want to work
		replace ilo_olf_reason=4 if (var_olf==8 | var_olf==.) & ilo_lfs==3	//Not elsewhere classified
			lab def reason_lab 1 "1 - Labour market" 2 "2 - Personal / Family-related" 3 "3 - Does not need/want to work" 4 "4 - Not elsewhere classified" 
			lab val ilo_olf_reason reason_lab 
			lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"
			
	
	drop var_olf			
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seeker ('ilo_dis')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
	
	if year==2002 {
	
	gen ilo_dis=1 if ilo_lfs==3 & b4er22==1 & ilo_olf_reason==1	
		}
	
	if year<=2006 & year!=2002 {
	
		gen ilo_dis=1 if ilo_lfs==3 & b4p22==1 & ilo_olf_reason==1	
			}	
		
	if year==2007 {
		
		gen ilo_dis=1 if ilo_lfs==3 & b4p24==1 & ilo_olf_reason==1	
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

		if year>=2005 {
		drop quarter
			}
	
		drop time year 

	* Full dataset with original variables and ILO ones
	
	cd "$outpath"

    * Save dataset including original and ilo variables
	
		save ${country}_${source}_${time}_FULL,  replace		
	
	* Save file only containing ilo_* variables
	
		keep ilo*

		save ${country}_${source}_${time}_ILO, replace
		
		
