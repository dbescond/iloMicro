* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Chile
* DATASET USED: Chile LFS
* NOTES: 
* Files created: Standard variables on LFS Chile
* Authors: Podjanin
* Who last updated the file: Podjanin, A.
* Starting Date: 06 February 2017
* Last updated: 12 April 2017
***********************************************************************************************



*******************************************************************
 /* 1.	Set up work directory, file name, variables and function */
*******************************************************************

clear all 

set more off

global path "J:\COMMON\STATISTICS\DPAU\MICRO"
global country "CHL"
global source "ENE"
global time "2016M01"
global inputFile "ENE 2016 01 DEF"

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

	use "${inputFile}", clear	
	
	rename *, lower
	
***********************************************************************************************

	* capture time period for determining which version of ISIC/ISCO are used
	
		* generate two separate variables for the year and the month
		
		gen time = "${time}"
		
		split time, gen (time_) parse(M)
		rename (time_1 time_2) (year month)
		destring year month, replace force

	
		if year<2016 | (year==2016 & month<=11) {
		
			gen classif="old"
			
			}
			
		else {
		
			gen classif="new"
			
		}
	
	
************************************************************************************************
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

*			2. MAP VARIABLES

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* ---------------------------------------------------------------------------------------------
***********************************************************************************************
*			PART 1. DATASET SETTINGS VARIABLES
***********************************************************************************************
* ---------------------------------------------------------------------------------------------

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Identifier ('ilo_key') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*		

	gen ilo_key=_n
		lab var ilo_key "Key unique identifier per individual"	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sample Weight ('ilo_wgt') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*		
* 

	gen ilo_wgt=fact
		lab var ilo_wgt "Sample weight"	
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time period ('ilo_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*

	gen ilo_time=1
		lab def time_lab 1 "${time}"
		lab val ilo_time time_lab
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
*
* Comment: 
	
		gen ilo_geo=.
			replace ilo_geo=1 if inlist(tipo,1,2)
			replace ilo_geo=2 if tipo==3
				lab def geo_lab 1 "1 - Urban" 2 "2 - Rural" 3 "3 - Not elsewhere classified"
				lab val ilo_geo geo_lab
				lab var ilo_geo "Geographical coverage"
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: 

		gen ilo_sex=sexo
				destring ilo_sex, replace
			label define label_Sex 1 "1 - Male" 2 "2 - Female"
			label values ilo_sex label_Sex 
			lab var ilo_sex "Sex"
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: 

	gen ilo_age=edad
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
		replace ilo_age_aggregate=1 if inrange(ilo_age,0,15)
		replace ilo_age_aggregate=2 if inrange(ilo_age,15,24)
		replace ilo_age_aggregate=3 if inrange(ilo_age,25,54)
		replace ilo_age_aggregate=4 if inrange(ilo_age,55,64)
		replace ilo_age_aggregate=5 if ilo_age>=65 & ilo_age!=.
			lab def age_aggr_lab 1 "<15" 2 "15-24" 3 "25-54" 4 "55-64" 5 "65+"
			lab val ilo_age_aggregate age_aggr_lab
			lab var ilo_age_aggregate "Age (Aggregate)"
			
		* As only age bands being kept drop "ilo_age" at the very end -> use it in between as help variable

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Level of education ('ilo_edu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: completed level of education always to be considered!
		
				
	gen ilo_edu_isced11=.
			* No schooling
		replace ilo_edu_isced11=1 if nivel==0 | (inlist(nivel,1,2) & termino_nivel==2)
			* Early childhood education
		replace ilo_edu_isced11=2 if (inlist(nivel,1,2) & termino_nivel==1) | (nivel==3 & inlist(curso,0,1,2,3,4,5,9))
			* Primary education
		replace ilo_edu_isced11=3 if (nivel==3 & inlist(curso,6,7)) 
			* Lower secondary education
		replace ilo_edu_isced11=4 if (nivel==3 & curso==8) | (inlist(nivel,4,5,6,7,14) & termino_nivel==2)
			* Upper secondary education
		replace ilo_edu_isced11=5 if (inlist(nivel,4,5,6,7) & termino_nivel==1) | (inlist(nivel,8,9,14) & termino_nivel==2)
			* Post-secondary non-tertiary education
		replace ilo_edu_isced11=6 if inlist(nivel,8,14) & termino_nivel==1
			* Short-cycle tertiary education
		/* replace ilo_edu_isced11=7 if  */
			* Bachelor's or equivalent level
		replace ilo_edu_isced11=8 if (nivel==9 & termino_nivel==1) | (inlist(nivel,10,11) & termino_nivel==2)
			* Master's or equivalent level
		replace ilo_edu_isced11=9 if (inlist(nivel,10,11) & termino_nivel==1) | (nivel==12 & termino_nivel==2)
			* Doctoral or equivalent level 
		replace ilo_edu_isced11=10 if nivel==12 & termino_nivel==1 
			* Not elsewhere classified
		replace ilo_edu_isced11=11 if ilo_edu_isced11==.
			label def isced_11_lab 1 "X - No schooling" 2 "0 - Early childhood education" 3 "1 - Primary education" 4 "2 - Lower secondary education" 5 "3 - Upper secondary education" ///
									6 "4 - Post-secondary non-tertiary education" 7 "5 - Short-cycle tertiary education" 8 "6 - Bachelor's or equivalent level" 9 "7 - Master's or equivalent level" ///
									10 "8 - Doctoral or equivalent level" 11 "9 - Not elsewhere classified"
			label val ilo_edu_isced11 isced_11_lab
			lab var ilo_edu_isced11 "Education (ISCED 11)"


		* for the definition, cf. the document "Guide to reporting labour statistics to the ILO using the Excel questionnaire"
		
	gen ilo_edu_aggregate=.
		replace ilo_edu_aggregate=1 if inlist(ilo_edu_isced11,1,2)
		replace ilo_edu_aggregate=2 if inlist(ilo_edu_isced11,3,4)
		replace ilo_edu_aggregate=3 if inlist(ilo_edu_isced11,5,6)
		replace ilo_edu_aggregate=4 if inlist(ilo_edu_isced11,7,8,9,10)
		replace ilo_edu_aggregate=5 if ilo_edu_isced11==11
			label def edu_aggr_lab 1 "1 - Less than basic" 2 "2 - Basic" 3 "3 - Intermediate" 4 "4 - Advanced" 5 "5 - Level not stated"
			label val ilo_edu_aggregate edu_aggr_lab
			label var ilo_edu_aggregate "Education (Aggregate level)"
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education attendance ('ilo_edu_attendance') [no info]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment:

	
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Disability status ('ilo_dsb_details') [no info]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment: 
				
	* gen ilo_dsb_aggregate=.

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
        
* Comment: 	

	gen ilo_wap=.
		replace ilo_wap=1 if ilo_age>=15 & ilo_age!=.
		replace ilo_wap=0 if ilo_age<15
			label def ilo_wap_lab 1 "Working age population"
			label val ilo_wap ilo_wap_lab
			label var ilo_wap "Working age population" //15+ population

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Labour Force Status ('ilo_lfs') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
     	 
* Comment: job seeking - reference period 4 weeks ; availability to start a job - current week
 
	gen ilo_lfs=.
		replace ilo_lfs=1 if ((a1==1 | a2==1) & a3==1) | a4==1 | inlist(a6,1,2,3,4,5) | a7==1 | a8==1
		replace ilo_lfs=2 if ilo_lfs!=1 & ((!inlist(e3_total,0,12,.) & e5==1) | e10==1) & e11==1
		replace ilo_lfs=3 if !inlist(ilo_lfs,1,2)
		replace ilo_lfs=. if ilo_wap!=1	
				label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status" 	
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: 

	gen ilo_mjh=.
		replace ilo_mjh=1 if b19==2
		replace ilo_mjh=2 if b19==1
		replace ilo_mjh=. if ilo_lfs!=1
			lab def lab_ilo_mjh 1 "1 - One job only" 2 "2 - More than one job"
			lab val ilo_mjh lab_ilo_mjh
			lab var ilo_mjh "Multiple job holders"
			

***********************************************************************************************
*			PART 3.1. ECONOMIC CHARACTERISTICS FOR MAIN JOB 
***********************************************************************************************		

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Status in employment ('ilo_ste') [done]
* -------------------------------------------------------------------------------------------
* ------------------------------------------------------------------------------------------- 

* Comment: 

	* Primary activity
	
		gen ilo_job1_ste_icse93=.
			replace ilo_job1_ste_icse93=1 if b2==2
			replace ilo_job1_ste_icse93=2 if b2==1 & b4==1 
			replace ilo_job1_ste_icse93=3 if b2==1 & b4==2
			/*replace ilo_job1_ste_icse93=4 if  */
			replace ilo_job1_ste_icse93=5 if b2==3
			replace ilo_job1_ste_icse93=6 if ilo_job1_ste_icse93==. & ilo_lfs==1
			replace ilo_job1_ste_icse93=. if ilo_lfs!=1			
				label define label_ilo_ste_icse93 1 "1 - Employees" 2 "2 - Employers" 3 "3 - Own-account workers" 4 "4 - Members of producers' cooperatives" 5 "5 - Contributing family workers" ///
												6 "6 - Workers not classifiable by status"
				label val ilo_job1_ste_icse93 label_ilo_ste_icse93
				label var ilo_job1_ste_icse93 "Status in employment (ICSE 93)"

	* Aggregate categories
	
		gen ilo_job1_ste_aggregate=.
			replace ilo_job1_ste_aggregate=1 if ilo_job1_ste_icse93==1
			replace ilo_job1_ste_aggregate=2 if inlist(ilo_job1_ste_icse93,2,3,4)
			replace ilo_job1_ste_aggregate=3 if inlist(ilo_job1_ste_icse93,5,6)
				lab def ste_aggr_lab 1 "1 - Employees" 2 "2 - Self-employed" 3 "3 - Not elsewhere classified"
				lab val ilo_job1_ste_aggregate ste_aggr_lab
				label var ilo_job1_ste_aggregate "Status in employment (Aggregate)" 
	
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: Info only indicated at the one digit level
	
	gen indu_code_prim=b14 if ilo_lfs==1 
		replace indu_code_prim=b13 if indu_code_prim==. & ilo_lfs==1
	
	*gen indu_code_sec=
		
		* Import value labels

		append using `labels', gen (lab)
		
	* determine whether ISIC Rev 3.1 or ISIC Rev. 4 should be used
	
	if classif=="old" {
					
			* Primary activity
		
	* One digit level
		
	* Primary activity 
	
		gen ilo_job1_eco_isic3=indu_code_prim
			replace ilo_job1_eco_isic3=18 if ilo_job1_eco_isic3==. & ilo_lfs==1
			replace ilo_job1_eco_isic3=. if ilo_lfs!=1
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
			
			}
			
	else {
	
		* Primary activity 
	
		gen ilo_job1_eco_isic4=indu_code_prim
			replace ilo_job1_eco_isic4=22 if ilo_job1_eco_isic4==. & ilo_lfs==1
			replace ilo_job1_eco_isic4=. if ilo_lfs!=1
				lab val ilo_job1_eco_isic4 isic4
				lab var ilo_job1_eco_isic4 "Economic activity (ISIC Rev. 4)"
			
	* Now do the classification on an aggregate level
	
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
			
			}

				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_ocu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment:  Information indicated only at the 1 digit level
			
	* 1 digit level
	
	gen occ_code_prim_1dig=b1 if ilo_lfs==1 
	
	* idem as for economic activity
	
		if classif=="old" {
	
		* Primary activity
		
		gen ilo_job1_ocu_isco88=occ_code_prim_1dig
			replace ilo_job1_ocu_isco88=10 if ilo_job1_ocu_isco88==0
			replace ilo_job1_ocu_isco88=11 if (ilo_job1_ocu_isco88==. & ilo_lfs==1) | occ_code_prim_1dig==10
			lab val ilo_job1_ocu_isco88 isco88
			lab var ilo_job1_ocu_isco88 "Occupation (ISCO-88)"	
	
	* Aggregate level
	
		* Primary occupation
	
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
				lab var ilo_job1_ocu_aggregate "Occupation (Aggregate)"
				
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
				
		}
		
		else {
		
			* Primary activity
		
		gen ilo_job1_ocu_isco08=occ_code_prim_1dig
			replace ilo_job1_ocu_isco08=10 if ilo_job1_ocu_isco08==0
			replace ilo_job1_ocu_isco08=11 if (ilo_job1_ocu_isco08==. & ilo_lfs==1) | occ_code_prim_1dig==10
			lab val ilo_job1_ocu_isco08 isco08
			lab var ilo_job1_ocu_isco08 "Occupation (ISCO-08)"	
	
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
				
				}
				
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_ins_sector') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
		
* Comment: 

	* Primary occupation
	
	gen ilo_job1_ins_sector=.
		replace ilo_job1_ins_sector=1 if b5==1
		replace ilo_job1_ins_sector=2 if ilo_job1_ins_sector!=1 & ilo_lfs==1
				replace ilo_job1_ins_sector=. if ilo_lfs!=1
			lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
			lab values ilo_job1_ins_sector ins_sector_lab
			lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities" 			

* --------------------------------------------------------------------------------------------------
* --------------------------------------------------------------------------------------------------
*		Weekly hours actually (USUALLY) worked ('ilo_how_actual') and ('ilo_how_usual') [in progress]
* --------------------------------------------------------------------------------------------------
* --------------------------------------------------------------------------------------------------

* Comment: 
	
	* Hours usually worked
	
		* Primary job
		
		gen ilo_job1_how_usual=c2_1_3 if c2_1_3!=999
				replace ilo_job1_how_usual=. if ilo_lfs!=1
				lab var ilo_job1_how_usual "Weekly hours usually worked in main job"
			
		* Secondary job 
		
		gen ilo_job2_how_usual=c2_2_3 if c2_2_3!=999
				replace ilo_job2_how_usual=. if ilo_lfs!=1 & ilo_mjh!=2
				lab var ilo_job2_how_usual "Weekly hours usually worked in secondary job"
				
		* All jobs
		
		egen ilo_joball_how_usual=rowtotal(ilo_job*_how_usual), m
			replace ilo_joball_how_usual=168 if ilo_joball_how_usual>168
			replace ilo_joball_how_usual=. if ilo_lfs!=1
			lab var ilo_joball_how_usual "Weekly hours usually worked in all jobs" 
			
	* Actual hours worked 
		
		* Primary job
		
		gen ilo_job1_how_actual=ilo_job1_how_usual
			replace ilo_job1_how_actual= ilo_job1_how_actual + c6 if c5==1
			replace ilo_job1_how_actual= ilo_job1_how_actual - c8 if c7==1
			replace ilo_job1_how_actual=. if ilo_lfs!=1
			lab var ilo_job1_how_actual "Weekly hours actually worked in main job"
			
		* All jobs --> actual hours asked only for main job! 
		
		egen ilo_joball_how_actual=rowtotal(ilo_job*_how_actual), m
			replace ilo_joball_how_actual=168 if ilo_joball_how_actual>168
			replace ilo_joball_how_actual=. if ilo_lfs!=1
			lab var ilo_joball_how_actual "Weekly hours actually worked in all jobs"		
	
	* Weekly hours actually worked --> bands --> Use actual hours worked in all jobs 
			
		* Main job
		
		gen ilo_job1_how_actual_bands=.
			replace ilo_job1_how_actual_bands=1 if ilo_job1_how_actual==0
			replace ilo_job1_how_actual_bands=2 if ilo_job1_how_actual>=1 & ilo_job1_how_actual<=14
			replace ilo_job1_how_actual_bands=3 if ilo_job1_how_actual>=15 & ilo_job1_how_actual<=29
			replace ilo_job1_how_actual_bands=4 if ilo_job1_how_actual>=30 & ilo_job1_how_actual<=34
			replace ilo_job1_how_actual_bands=5 if ilo_job1_how_actual>=35 & ilo_job1_how_actual<=39
			replace ilo_job1_how_actual_bands=6 if ilo_job1_how_actual>=40 & ilo_job1_how_actual<=48
			replace ilo_job1_how_actual_bands=7 if ilo_job1_how_actual>=49 & ilo_job1_how_actual!=.
			replace ilo_job1_how_actual_bands=8 if ilo_lfs==1 & ilo_job1_how_actual_bands==.
				lab def how_bands_lab 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"
				lab values ilo_job1_how_actual_bands how_bands_lab
				lab var ilo_job1_how_actual_bands "Weekly hours actually worked bands in main job"
		
		* All jobs --> considering only actual hours worked related to main job
		
		gen ilo_joball_how_actual_bands=.
			replace ilo_joball_how_actual_bands=1 if ilo_joball_how_actual==0
			replace ilo_joball_how_actual_bands=2 if ilo_joball_how_actual>=1 & ilo_joball_how_actual<=14
			replace ilo_joball_how_actual_bands=3 if ilo_joball_how_actual>=15 & ilo_joball_how_actual<=29
			replace ilo_joball_how_actual_bands=4 if ilo_joball_how_actual>=30 & ilo_joball_how_actual<=34
			replace ilo_joball_how_actual_bands=5 if ilo_joball_how_actual>=35 & ilo_joball_how_actual<=39
			replace ilo_joball_how_actual_bands=6 if ilo_joball_how_actual>=40 & ilo_joball_how_actual<=48
			replace ilo_joball_how_actual_bands=7 if ilo_joball_how_actual>=49 & ilo_joball_how_actual!=.
			replace ilo_joball_how_actual_bands=8 if ilo_lfs==1 & ilo_joball_how_actual_bands==.
				* value label already defined
				lab values ilo_joball_how_actual_bands how_bands_lab
				lab var ilo_joball_how_actual_bands "Weekly hours actually worked bands in all jobs"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment: use predefined variable --> ask Yves whether it is correct 

	
	gen ilo_job1_job_time=.
		replace ilo_job1_job_time=1 if c1==2
		replace ilo_job1_job_time=2 if c1==1
		replace ilo_job1_job_time=3 if ilo_job1_job_time==. & ilo_lfs==1
				replace ilo_job1_job_time=. if ilo_lfs!=1
			lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
			lab val ilo_job1_job_time job_time_lab
			lab var ilo_job1_job_time "Job (Working time arrangement)"	
			
			* if there is any secondary employment, by definition it is part-time, and therefore
			* variable for secondary employment not being defined
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job_contract') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment: 

	gen ilo_job1_job_contract=.
		replace ilo_job1_job_contract=1 if b9==1
		replace ilo_job1_job_contract=2 if b9==2
		replace ilo_job1_job_contract=3 if ilo_job1_ste_aggregate==1 & ilo_job1_job_contract==.
				replace ilo_job1_job_contract=. if ilo_job1_ste_aggregate!=1
			lab def job_contract_lab 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"
			lab val ilo_job1_job_contract job_contract_lab
			lab var ilo_job1_job_contract "Job (Type of contract)" 


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Informal/Formal economy: Unit of production (ilo_job1_ife_prod) [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: 
	
	* Useful questions: b5: Institutional sector 
					*	[no question]: Destination of production 
					*	[no question]: Bookkeeping
					*	[no question]: Registration 
					*	b16: Location of workplace
					* 	b15_1 and b15_2: Size of the establishment
					
					* Social security: 
						*	b7_3: Pension fund --> take this as proxy for this variable (given definition in technical document)
						*	[b7_4: Health insurance provided by employer]
						*	[b7_5: Unemployment insurance]
		
		
		
	destring b15_2, replace

		gen ilo_job1_ife_prod=.
			replace ilo_job1_ife_prod=1 if inlist(b5,2,.) & ((ilo_job1_ste_aggregate==1 & b7_3!=1) | ilo_job1_ste_aggregate!=1) & (!inrange(b16,1,5) | (inrange(b16,1,5) & (!inrange(b15_1,2,5) | inlist(b15_2,1,2,3,4,5,999))))
			replace ilo_job1_ife_prod=2 if b5==1 | (inlist(b5,2,.) & ( (ilo_job1_ste_aggregate==1 & (b7_3==1 | (inrange(b16,1,5) & inrange(b15_1,2,5) & b15_2!=999))) | /// 
																		(ilo_job1_ste_aggregate!=1 & inrange(b16,1,5) & inrange(b15_1,2,5) & b15_2!=999)))
			replace ilo_job1_ife_prod=3 if b5==3  
			replace ilo_job1_ife_prod=. if ilo_lfs!=1
				lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 4 "4 - Not elsewhere classified"
				lab val ilo_job1_ife_prod ilo_ife_prod_lab
				lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"		
		
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Informal/formal economy: nature of job (ilo_job1_ife_nature) [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_job1_ife_nature=.
		replace ilo_job1_ife_nature=1 if inlist(ilo_job1_ste_icse93,5,6) | (ilo_job1_ste_icse93==1 & b7_3!=1) | (inlist(ilo_job1_ste_icse93,2,3,4) & inlist(ilo_job1_ife_prod,1,3))
		replace ilo_job1_ife_nature=2 if (ilo_job1_ste_icse93==1 & b7_3==1) | (inlist(ilo_job1_ste_icse93,2,3,4) & ilo_job1_ife_prod==2)
		replace ilo_job1_ife_nature=. if ilo_lfs!=1
			lab def ife_nature_lab 1 "1 - Persons with informal main job" 2 "2 - Persons with formal main job"
			lab val ilo_job1_ife_nature ife_nature_lab
			lab var ilo_job1_ife_nature "Informal / Formal Economy (Nature of job)"			

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Earnings ('ilo_ear_ees' and 'ilo_ear_slf') [not available]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	
* Comment:

	*Currency in Chile: Chilean Peso
	
		* No info on earnings

***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_tru') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
           
* Comment: 

	gen ilo_joball_tru=1 if ilo_job1_job_time==1 & c10==1 & c11==1
		replace ilo_joball_tru=. if ilo_lfs!=1
			lab def tru_lab 1 "Time-related underemployment"
			lab val ilo_joball_tru tru_lab
			lab var ilo_joball_tru "Time-related underemployment"

*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Cases of non-fatal occupational injury ('ilo_joball_oi_case') [no info]
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*
* Comment: No information

		
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Days lost due to cases of occupational injury ('ilo_joball_oi_day') [no info]
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------

* Comment: No information

		
***********************************************************************************************
*			PART 3.3. UNEMPLOYMENT: ECONOMIC CHARACTERISTICS
***********************************************************************************************	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur') [in progress]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: 
	
		gen diff_month=mes_encuesta-e6_mes if !inlist(e6_mes,999,.)
			replace diff_month=diff_month+12 if diff_month<0
			
		gen diff_year=ano_encuesta-e6_ano
		
		replace diff_year=0 if mes_encuesta==1 & inrange(e6_mes,2,12) & diff_year==1
		replace diff_year=0 if mes_encuesta==2 & inrange(e6_mes,3,12) & diff_year==1
		replace diff_year=0 if mes_encuesta==3 & inrange(e6_mes,4,12) & diff_year==1
		replace diff_year=0 if mes_encuesta==4 & inrange(e6_mes,5,12) & diff_year==1
		replace diff_year=0 if mes_encuesta==5 & inrange(e6_mes,6,12) & diff_year==1
		replace diff_year=0 if mes_encuesta==6 & inrange(e6_mes,7,12) & diff_year==1
		replace diff_year=0 if mes_encuesta==7 & inrange(e6_mes,8,12) & diff_year==1
		replace diff_year=0 if mes_encuesta==8 & inrange(e6_mes,9,12) & diff_year==1
		replace diff_year=0 if mes_encuesta==9 & inrange(e6_mes,10,12) & diff_year==1
		replace diff_year=0 if mes_encuesta==10 & inrange(e6_mes,11,12) & diff_year==1
		replace diff_year=0 if mes_encuesta==11 & e6_mes==12 & diff_year==1
		
		replace diff_year=1 if mes_encuesta==1 & inrange(e6_mes,2,12) & diff_year==2
		replace diff_year=1 if mes_encuesta==2 & inrange(e6_mes,3,12) & diff_year==2
		replace diff_year=1 if mes_encuesta==3 & inrange(e6_mes,4,12) & diff_year==2
		replace diff_year=1 if mes_encuesta==4 & inrange(e6_mes,5,12) & diff_year==2
		replace diff_year=1 if mes_encuesta==5 & inrange(e6_mes,6,12) & diff_year==2
		replace diff_year=1 if mes_encuesta==6 & inrange(e6_mes,7,12) & diff_year==2
		replace diff_year=1 if mes_encuesta==7 & inrange(e6_mes,8,12) & diff_year==2
		replace diff_year=1 if mes_encuesta==8 & inrange(e6_mes,9,12) & diff_year==2
		replace diff_year=1 if mes_encuesta==9 & inrange(e6_mes,10,12) & diff_year==2
		replace diff_year=1 if mes_encuesta==10 & inrange(e6_mes,11,12) & diff_year==2
		replace diff_year=1 if mes_encuesta==11 & e6_mes==12 & diff_year==2
		

	gen ilo_dur_details=.
		replace ilo_dur_details=1 if diff_month==0 & diff_year==0
		replace ilo_dur_details=2 if inrange(diff_month,1,2) & diff_year==0
		replace ilo_dur_details=3 if inrange(diff_month,3,5) & diff_year==0
		replace ilo_dur_details=4 if inrange(diff_month,6,11) & diff_year==0
		replace ilo_dur_details=5 if diff_year==1 & inrange(diff_month,0,11)
		replace ilo_dur_details=6 if (diff_year==2 & e6_mes!=999) | (diff_year>=3 & diff_year!=.)
		replace ilo_dur_details=7 if ilo_dur_details==. & ilo_lfs==2
				replace ilo_dur_details=. if ilo_lfs!=2
			lab def ilo_unemp_det 1 "Less than 1 month" 2 "1 month to less than 3 months" 3 "3 months to less than 6 months" 4 "6 months to less than 12 months" 5 "12 months to less than 24 months" ///
									6 "24 months or more" 7 "Not elsewhere classified"
			lab values ilo_dur_details ilo_unemp_det
			lab var ilo_dur_details "Duration of unemployment (Details)"

	gen ilo_dur_aggregate=.
		replace ilo_dur_aggregate=1 if inlist(ilo_dur_details,1,2,3)
		replace ilo_dur_aggregate=2 if ilo_dur_details==4
		replace ilo_dur_aggregate=3 if inlist(ilo_dur_details,5,6)
		replace ilo_dur_aggregate=4 if ilo_dur_aggregate==. & ilo_lfs==2
				replace ilo_dur_aggregate=. if ilo_lfs!=2
				
			lab def ilo_unemp_aggr 1 "Less than 6 months" 2 "6 months to less than 12 months" 3 "12 months or more" 4 "Not elsewhere classified"
			lab val ilo_dur_aggregate ilo_unemp_aggr
			lab var ilo_dur_aggregate "Duration of unemployment (Aggregate)"	
	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Category of unemployment ('ilo_cat_une') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: note that the question asks whether the person had previously a job lasting at least one month
			* This applies consequently to all questions concerning the preivous employment

	gen ilo_cat_une=.
		replace ilo_cat_une=1 if e13==1
		replace ilo_cat_une=2 if e13==2
		replace ilo_cat_une=3 if ilo_lfs==2 & ilo_cat_une==.
				replace ilo_cat_une=. if ilo_lfs!=2
			lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
			lab val ilo_cat_une cat_une_lab
			lab var ilo_cat_une "Category of unemployment"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	* Comment: ISIC Rev. 3.1 classification being used 

		gen preveco_cod=e18 if ilo_lfs==2 & ilo_cat_une==1
		
			* keep this variable on the two digit level, in order to be able to correctly execute the code below
			
		if classif=="old"  {
		
	* Previous economic activity
	
	gen ilo_preveco_isic3=preveco_cod
		replace ilo_preveco_isic3=18 if preveco_cod==. & ilo_lfs==2 & ilo_cat_une==1
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
			* value label already defined above			
				lab val ilo_preveco_aggregate eco_aggr_lab
				lab var ilo_preveco_aggregate "Previous economic activity (Aggregate)"
				
			}
			
		else {
		
			gen ilo_preveco_isic4=preveco_cod
		replace ilo_preveco_isic4=22 if preveco_cod==. & ilo_lfs==2 & ilo_cat_une==1
			lab val ilo_preveco_isic4 isic4
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
			
		}

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu_isco08') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			
* Comment: 

	gen prevocu_cod=e16 if ilo_lfs==2 & ilo_cat_une==1
	
		if classif=="old" {
	
	gen ilo_prevocu_isco88=prevocu_cod
		replace ilo_prevocu_isco88=10 if ilo_prevocu_isco88==0
		replace ilo_prevocu_isco88=11 if (ilo_prevocu_isco88==. & ilo_cat_une==1 & ilo_lfs==2) | prevocu_cod==10
		* value label already defined
		lab val ilo_prevocu_isco88 isco88_1dig_lab
		lab var ilo_prevocu_isco88 "Previous occupation (ISCO-88)"
			
	* Aggregate level 
	
	gen ilo_prevocu_aggregate=.
		replace ilo_prevocu_aggregate=1 if inrange(ilo_prevocu_isco88,1,3)
		replace ilo_prevocu_aggregate=2 if inlist(ilo_prevocu_isco88,4,5)
		replace ilo_prevocu_aggregate=3 if inlist(ilo_prevocu_isco88,6,7)
		replace ilo_prevocu_aggregate=4 if ilo_prevocu_isco88==8
		replace ilo_prevocu_aggregate=5 if ilo_prevocu_isco88==9
		replace ilo_prevocu_aggregate=6 if ilo_prevocu_isco88==10
		replace ilo_prevocu_aggregate=7 if ilo_prevocu_isco88==11
			* value label already defined
			lab val ilo_prevocu_aggregate ocu_aggr_lab
			lab var ilo_prevocu_aggregate "Previous occupation (Aggregate)"	
			
			}
			
	else {
	
		gen ilo_prevocu_isco88=prevocu_cod
		replace ilo_prevocu_isco88=10 if ilo_prevocu_isco88==0
		replace ilo_prevocu_isco88=11 if (ilo_prevocu_isco88==. & ilo_cat_une==1 & ilo_lfs==2) | prevocu_cod==10
		* value label already defined
		lab val ilo_prevocu_isco88 isco88_1dig_lab
		lab var ilo_prevocu_isco88 "Previous occupation (ISCO-88)"
			
	* Aggregate level 
	
	gen ilo_prevocu_aggregate=.
		replace ilo_prevocu_aggregate=1 if inrange(ilo_prevocu_isco88,1,3)
		replace ilo_prevocu_aggregate=2 if inlist(ilo_prevocu_isco88,4,5)
		replace ilo_prevocu_aggregate=3 if inlist(ilo_prevocu_isco88,6,7)
		replace ilo_prevocu_aggregate=4 if ilo_prevocu_isco88==8
		replace ilo_prevocu_aggregate=5 if ilo_prevocu_isco88==9
		replace ilo_prevocu_aggregate=6 if ilo_prevocu_isco88==10
		replace ilo_prevocu_aggregate=7 if ilo_prevocu_isco88==11
			* value label already defined
			lab val ilo_prevocu_aggregate ocu_aggr_lab
			lab var ilo_prevocu_aggregate "Previous occupation (Aggregate)"		
			
			}
	
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Unemployment benefits schemes ('ilo_soc_aggregate') [no info available]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment:


			
***********************************************************************************************
*			PART 3.4. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************
			
* 
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma') [don't define]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: only first two option can be defined --> very high share falling into category "unknown" - don't keep variable
/*
	 gen ilo_olf_dlma=.
		replace ilo_olf_dlma=1 if (inrange(e3_total,1,11) | e10==1) & e11==2
		replace ilo_olf_dlma=2 if (!inrange(e3_total,1,11) | e10==2) & e11==1
		/* replace ilo_olf_dlma=3 if 
		 replace ilo_olf_dlma=4 if */
		replace ilo_olf_dlma=5 if ilo_olf_dlma==. & ilo_lfs==3
				replace ilo_olf_dlma=. if ilo_lfs!=3
			lab def lab_olf_dlma 1 "1 - Seeking, not available (Unavailable jobseekers)" 2 "2 - Not seeking, available (Available potential jobseekers)" ///
						3 "3 - Not seeking, not available, willing (Willing non-jobseekers)" 4 "4 - Not seeking, not available, not willing" 5 "5 - Not elsewhere classified"
			lab val ilo_olf_dlma lab_olf_dlma
			lab var ilo_olf_dlma "Labour market attachment (Degree of)" */
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reasons for not seeking a job ('ilo_olf_reason') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: 

	gen ilo_olf_reason=.
		replace ilo_olf_reason=1 if inlist(e9,9,13,15,16,17,18,19,20)
		replace ilo_olf_reason=2 if inlist(e9,3,4,8,10,11,12)
		replace ilo_olf_reason=3 if inlist(e9,5,6,7,21)
		replace ilo_olf_reason=4 if ilo_olf_reason==. & ilo_lfs==3
			replace ilo_olf_reason=. if ilo_lfs!=3
			lab def lab_olf_reason 1 "1 - Labour market" 2 "2 - Personal/Family-related"  3 "3 - Does not need/want to work" 4 "4 - Not elsewhere classified"
			lab val ilo_olf_reason lab_olf_reason
			lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seekers ('ilo_dis') [done]
* -------------------------------------------------------------------------------------------
* ------------------------------------------------------------------------------------------- 

* Comment:

	gen ilo_dis=1 if inrange(e9,15,20) & ilo_lfs==3 & e11==1
			lab def ilo_dis_lab 1 "Discouraged job-seekers" 
			lab val ilo_dis ilo_dis_lab
			lab var ilo_dis "Discouraged job-seekers"



* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training (NEETs) ('ilo_neet') [can't be defined]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

		/* gen ilo_neet=.
			replace ilo_neet=1 if inrange(ilo_age,15,24) & ilo_lfs!=1 & inlist(ilo_edu_attendance,2,3)
				lab def ilo_neet_lab 1 "Youth not in education, employment or training"
				lab val ilo_neet ilo_neet_lab
				lab var ilo_neet "Youth not in education, employment or training"  */						
			

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

*			SAVE RESULTS

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* -------------------------------------------------------------
* 1.	Prepare final datasets
* -------------------------------------------------------------

cd "$outpath"

		drop if lab==1 /* in order to get rid of observations from tempfile */

		drop ilo_age /* as only age bands being kept and this variable used as help variable */
		
		drop indu_code_* occ_code_*  prev*_cod  lab isco08_2digits isco88_2digits isco08 isco88 isic4_2digits isic4 isic3_2digits isic3 time year month classif diff_month diff_year
	
		compress 
		
		order ilo* , last
		   		   
	* Save dataset including original and ilo variables
	
		save ${country}_${source}_${time}_FULL, replace		
	
	*Save file only containing ilo_* variables
	
		keep ilo*

		save ${country}_${source}_${time}_ILO, replace

