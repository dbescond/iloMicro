* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Guatemala
* DATASET USED: Guatemala LFS 
* NOTES: 
* Files created: Standard variables on LFS Guatemala
* Authors: Podjanin
* Who last updated the file: Podjanin, A.
* Starting Date: 09 October 2017
* Last updated: 06 November 2017
***********************************************************************************************



*******************************************************************
 /* 1.	Set up work directory, file name, variables and function */
*******************************************************************

clear all 

set more off

global path "J:\COMMON\STATISTICS\DPAU\MICRO"
global country "TJK"
global source "LSS"
global time "2009"
global inputFile "TJK_LSS_2009"

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
	
	rename * , lower
		
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
*			Identifier ('ilo_key') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*		

	gen ilo_key=_n
		lab var ilo_key "Key unique identifier per individual"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sample Weight ('ilo_wgt')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*		

	gen ilo_wgt=weight
		lab var ilo_wgt "Sample weight"
	
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time period ('ilo_time') 
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
	gen ilo_geo=.
		replace ilo_geo=1 if location==1
		replace ilo_geo=2 if location==2
			lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural"
			lab val ilo_geo ilo_geo_lab
			lab var ilo_geo "Geographical coverage"	
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: 

		gen ilo_sex=sex
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
	
		gen ilo_age=age
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
			
		* as only age bands being kept drop "ilo_age" at the very end -> use it in between as help variable
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Level of education ('ilo_edu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: Note that according to the definition, the highest level being CONCLUDED is being considered

		* question m3bq4 asked to individuals aged 6+
		
	gen ilo_edu_isced97=.
		replace ilo_edu_isced97=1 if m3bq3==2 | m3bq4==0
		/* replace ilo_edu_isced97=2 if  -- only info on current enrollment in pre-school education */
		replace ilo_edu_isced97=3 if m3bq4==1
		replace ilo_edu_isced97=4 if m3bq4==2
		replace ilo_edu_isced97=5 if inlist(m3bq4,3,4,5)
		/* replace ilo_edu_isced97=6 if */
		replace ilo_edu_isced97=7 if m3bq4==6
		replace ilo_edu_isced97=8 if m3bq4==7
		replace ilo_edu_isced97=9 if ilo_edu_isced97==.
			label def isced_97_lab 1 "X - No schooling" 2 "0 - Pre-primary education" 3 "1 - Primary education or first stage of basic education" 4 "2 - Lower secondary education or second stage of basic education" ///
							5 "3 - Upper secondary education" 6 "4 - Post-secondary non-tertiary education" 7 "5 - First stage of tertiary education (not leading directly to an advanced research qualification)" ///
							8 "6 - Second stage of tertiary education (leading to an advanced research qualification)" 9 "UNK - Level not stated"
			label val ilo_edu_isced97 isced_97_lab
			lab var ilo_edu_isced97 "Education (ISCED 97)"
		
		* for the definition, cf. document "Guide to reporting labour statistics to the ILO using the Excel questionnaire"
		
	gen ilo_edu_aggregate=.
		replace ilo_edu_aggregate=1 if inlist(ilo_edu_isced97,1,2)
		replace ilo_edu_aggregate=2 if inlist(ilo_edu_isced97,3,4)
		replace ilo_edu_aggregate=3 if inlist(ilo_edu_isced97,5,6)
		replace ilo_edu_aggregate=4 if inlist(ilo_edu_isced97,7,8)
		replace ilo_edu_aggregate=5 if ilo_edu_isced97==9
			label def edu_aggr_lab 1 "1 - Less than basic" 2 "2 - Basic" 3 "3 - Intermediate" 4 "4 - Advanced" 5 "5 - Level not stated"
			label val ilo_edu_aggregate edu_aggr_lab
			label var ilo_edu_aggregate "Education (Aggregate)"
			
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education attendance ('ilo_edu_attendance') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: 

		gen ilo_edu_attendance=.
			replace ilo_edu_attendance=1 if m3bq5==1
			replace ilo_edu_attendance=2 if m3bq3==2 | m3bq5==2
			replace ilo_edu_attendance=3 if ilo_edu_attendance==.
				lab def edu_attendance_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
				lab val ilo_edu_attendance edu_attendance_lab
				lab var ilo_edu_attendance "Education (Attendance)"		
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Disability status ('ilo_dsb_details') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment: 
			
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
*           
* Comment: 	

	gen ilo_wap=.
		replace ilo_wap=1 if ilo_age>=15 & ilo_age!=.
		replace ilo_wap=0 if ilo_age<15
			label def ilo_wap_lab 1 "Working age population"
			label val ilo_wap ilo_wap_lab
			label var ilo_wap "Working age population" //15+ population 

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Labour Force Status ('ilo_lfs') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*            	 
* Comment: 	Note that the identification of the labour force status is based on questions that consider the last 14 days as reference period
			* (and not the last 7 days). Additionally, the questionnaire does not contain any question on the availability of people seeking an employment, 
			* and therefore the value ilo_lfs==2 had to be defined without this criterion.

	gen ilo_lfs=.
		replace ilo_lfs=1 if m5aq1==1 | m5aq2==1 | m5aq3==1 | m5aq5==1 | m5aq6==1 
		replace ilo_lfs=2 if ilo_lfs!=1 & m5aq8==1 
		replace ilo_lfs=3 if !inlist(ilo_lfs,1,2) & ilo_wap==1
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
		replace ilo_mjh=1 if m5cq19==2
		replace ilo_mjh=2 if m5cq19==1
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
*
* Comment: 

	* Primary activity
	
		gen ilo_job1_ste_icse93=.
			replace ilo_job1_ste_icse93=1 if inlist(m5cq5,1,2)
			replace ilo_job1_ste_icse93=2 if m5cq5==4
			replace ilo_job1_ste_icse93=3 if m5cq5==3
			/* replace ilo_job1_ste_icse93=4 if */
			replace ilo_job1_ste_icse93=5 if m5cq5==5
			replace ilo_job1_ste_icse93=6 if ilo_job1_ste_icse93==. & ilo_lfs==1
				replace ilo_job1_ste_icse93=. if ilo_lfs!=1
			
			label define label_ilo_ste_icse93 1 "1 - Employees" 2 "2 - Employers" 3 "3 - Own-account workers" 4 "4 - Members of producers' cooperatives" 5 "5 - Contributing family workers" ///
												6 "6 - Workers not classifiable by status"
			label val ilo_job1_ste_icse93 label_ilo_ste_icse93
			label var ilo_job1_ste_icse93 "Status in employment (ICSE 93)"

		* Aggregate categories
	
		gen ilo_job1_ste_aggregate=.
			replace ilo_job1_ste_aggregate=1 if ilo_job1_ste_icse93==1
			replace ilo_job1_ste_aggregate=2 if inlist(ilo_job1_ste_icse93,2,3,4,5)
			replace ilo_job1_ste_aggregate=3 if ilo_job1_ste_icse93==6
				lab def ste_aggr_lab 1 "1 - Employees" 2 "2 - Self-employed" 3 "3 - Not elsewhere classified"
				lab val ilo_job1_ste_aggregate ste_aggr_lab
			label var ilo_job1_ste_aggregate "Status in employment (Aggregate)"

	  * Secondary activity
	
		gen ilo_job2_ste_icse93=.
			replace ilo_job2_ste_icse93=1 if inlist(m5cq22,1,2)
			replace ilo_job2_ste_icse93=2 if m5cq22==4
			replace ilo_job2_ste_icse93=3 if m5cq22==3
			/* replace ilo_job2_ste_icse93=4 if */
			replace ilo_job2_ste_icse93=5 if m5cq22==5
			replace ilo_job2_ste_icse93=6 if ilo_job2_ste_icse93==. & ilo_lfs==1 & ilo_mjh==2
				replace ilo_job2_ste_icse93=. if ilo_lfs!=1 & ilo_mjh!=2
			* value labels already defined
			label val ilo_job2_ste_icse93 label_ilo_ste_icse93
			label var ilo_job2_ste_icse93 "Status in employment (ICSE 93) in secondary job"

			* Aggregate categories
		
			gen ilo_job2_ste_aggregate=.
				replace ilo_job2_ste_aggregate=1 if ilo_job2_ste_icse93==1
				replace ilo_job2_ste_aggregate=2 if inlist(ilo_job2_ste_icse93,2,3,4,5)
				replace ilo_job2_ste_aggregate=3 if ilo_job2_ste_icse93==6
					*value labels already defined
					lab val ilo_job2_ste_aggregate ste_aggr_lab
				label var ilo_job2_ste_aggregate "Status in employment (Aggregate) in secondary job" 
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: Classification used ISIC Rev. 3.1 

	* Import value labels

		append using `labels', gen (lab)

	gen indu_code_prim=m5bq2 if ilo_lfs==1		
					
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

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_ocu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: Indicate both for primary and secondary activity

		* Classification used - ISCO-08
		
	gen occ_code_prim=int(m5bq1/100) if ilo_lfs==1

* 2 digit level
	
		* Primary occupation
		
		gen ilo_job1_ocu_isco08_2digits=occ_code_prim
				replace ilo_job1_ocu_isco08_2digits=. if ilo_lfs!=1
			lab values ilo_job1_ocu_isco08_2digits isco08_2digits
			lab var ilo_job1_ocu_isco08_2digits "Occupation (ISCO-08), 2 digit level"
	
		
	* 1 digit level
	
	gen occ_code_prim_1dig=int(occ_code_prim/10) if ilo_lfs==1
	
		* Primary activity
		
		gen ilo_job1_ocu_isco08=occ_code_prim_1dig
			replace ilo_job1_ocu_isco08=10 if ilo_job1_ocu_isco08==0	
			replace ilo_job1_ocu_isco08=11 if ilo_job1_ocu_isco08==. & ilo_lfs==1
				replace ilo_job1_ocu_isco08=. if ilo_lfs!=1
			lab def isco08_1dig_lab 1 "1 - Managers" 2 "2 - Professionals" 3 "Technicians and associate professionals" 4 "4 - Clerical support workers" 5 "5 - Service and sales workers" ///
									6 "6 - Skilled agricultural, forestry and fishery workers" 7 "7 - Craft and related trades workers" 8 "8 - Plant and machine operators, and assemblers" ///
									9 "9 - Elementary occupations" 10 "0 - Armed forces occupations" 11 "X - Not elsewhere classified"
			lab val ilo_job1_ocu_isco08 isco08_1dig_lab
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
			
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_ins_sector') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
		
* Comment: consider separately for primary and secondary activity
	
	* Primary occupation
	
	gen ilo_job1_ins_sector=.
		replace ilo_job1_ins_sector=1 if inlist(m5cq6,1,2,6,8)
		replace ilo_job1_ins_sector=2 if ilo_job1_ins_sector==. & ilo_lfs==1
				replace ilo_job1_ins_sector=. if ilo_lfs!=1
			lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
			lab values ilo_job1_ins_sector ins_sector_lab
			lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities"
			
	* Secondary occupation

	gen ilo_job2_ins_sector=.
		replace ilo_job2_ins_sector=1 if inlist(m5cq23,1,2,6,8)
		replace ilo_job2_ins_sector=2 if ilo_job2_ins_sector==. & ilo_lfs==1 & ilo_mjh==2
				replace ilo_job2_ins_sector=. if ilo_lfs!=1 & ilo_mjh!=2
			* value labels already defined
			lab values ilo_job2_ins_sector ins_sector_lab
			lab var ilo_job2_ins_sector "Institutional sector (private/public) of economic activities in secondary job"
					
			
* --------------------------------------------------------------------------------------------------
* --------------------------------------------------------------------------------------------------
*		Weekly hours actually (USUALLY) worked ('ilo_how_actual') and ('ilo_how_usual') [done]
* --------------------------------------------------------------------------------------------------
* --------------------------------------------------------------------------------------------------
* 
* Comment:	 only actual hours in main job considered --> note that the number of weekly hours over the last two weeks is considered				
	
	* Hours actually worked
	
		* Main job
			
		gen ilo_job1_how_actual=m5bq5
				replace ilo_job1_how_actual=. if ilo_lfs!=1
					lab var ilo_job1_how_actual "Weekly hours actually worked in main job"
					
		* Weekly hours - bands
		
			* Primary occupation
			
			gen ilo_job1_how_actual_bands=.
				replace ilo_job1_how_actual_bands=1 if ilo_job1_how_actual==0
				replace ilo_job1_how_actual_bands=2 if inrange(ilo_job1_how_actual,1,14)
				replace ilo_job1_how_actual_bands=3 if inrange(ilo_job1_how_actual,15,29)
				replace ilo_job1_how_actual_bands=4 if inrange(ilo_job1_how_actual,30,34)
				replace ilo_job1_how_actual_bands=5 if inrange(ilo_job1_how_actual,35,39)
				replace ilo_job1_how_actual_bands=6 if inrange(ilo_job1_how_actual,40,48)
				replace ilo_job1_how_actual_bands=7 if ilo_job1_how_actual>=49 & ilo_job1_how_actual!=.
				replace ilo_job1_how_actual_bands=8 if ilo_job1_how_actual==. & ilo_lfs==1
				replace ilo_job1_how_actual_bands=. if ilo_lfs!=1
					lab def how_bands_lab 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"
					lab val ilo_job1_how_actual_bands how_bands_lab
					lab var ilo_job1_how_actual_bands "Weekly hours actually worked bands in main job"
		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment: consider threshold of 35 hours per week
	
	gen ilo_job1_job_time=.
		replace ilo_job1_job_time=1 if ilo_job1_how_actual<=34 & ilo_job1_how_actual!=.
		replace ilo_job1_job_time=2 if ilo_job1_how_actual>=35 & ilo_job1_how_actual!=.
		replace ilo_job1_job_time=3 if ilo_job1_how_actual==. & ilo_lfs==1
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
		replace ilo_job1_job_contract=1 if m5cq8==4
		replace ilo_job1_job_contract=2 if inlist(m5cq8,1,2,3)
		replace ilo_job1_job_contract=3 if ilo_job1_job_contract==. & ilo_job1_ste_aggregate==1
				replace ilo_job1_job_contract=. if ilo_job1_ste_aggregate!=1
			lab def job_contract_lab 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"
			lab val ilo_job1_job_contract job_contract_lab
			lab var ilo_job1_job_contract "Job (Type of contract)"
			
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Informal/Formal economy: Unit of production (ilo_job1_ife_prod) [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* 
* Comment:  too little information --> don't define variable

	* Useful questions: m5cq5: Status in employment
					*	m5cq6: Institutional sector
					*	[no info]: Destination of production
					*	[no info]: Bookkeeping
					*	[no info]: Registration
					*	[only sick leave]: Social security (IGSS)
					*	m5cq2: Location of workplace 
					*	m5cq7: Size of the establishment
				
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Informal/formal economy: nature of job (ilo_job1_ife_nature) [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: 

	
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Earnings ('ilo_ear_ees' and 'ilo_ear_slf')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	
* Comment: 
	
	*Currency in Tajikistan: Somoni
	
			* Monthly earnings of employees
			
				* obtain monthly values of some variables
				
				gen month_m5cq13=m5cq13/m5cq14 if m5cq14!=.
				
				gen month_m5cq17=m5cq17/12 if m5cq17!=98 		
				
		egen ilo_job1_lri_ees=rowtotal(m5cq11 month_m5cq13 month_m5cq17) if m5cq11!=98 & ilo_lfs==1, m 
			replace ilo_job1_lri_ees=. if ilo_lfs!=1
			lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"
			
			* Self employment
		
		* note that the revenue related to self-employment includes also the value of own consumption 
			* (cf. resolution from 1998)
			
				* --> no information included in dataset
				
			drop month_*
	
***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************						
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_tru') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*                
* Comment: 


*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Cases of non-fatal occupational injury ('ilo_joball_oi_case') [not available]
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*
* Comment: no info available

	* gen ilo_joball_oi_case=
	

*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Days lost due to cases of occupational injury ('ilo_joball_oi_day') [not available]
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*
* Comment: no info available

	* gen ilo_joball_oi_day=	
	
	
***********************************************************************************************
*			PART 3.3. UNEMPLOYMENT: ECONOMIC CHARACTERISTICS
***********************************************************************************************	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment:	Variable m5aq11 indicates number of months spent looking for a job

	
	gen ilo_dur_details=.
		replace ilo_dur_details=1 if m5aq11==0
		replace ilo_dur_details=2 if inlist(m5aq11,1,2)
		replace ilo_dur_details=3 if inrange(m5aq11,3,5)
		replace ilo_dur_details=4 if inrange(m5aq11,6,11)
		replace ilo_dur_details=5 if inrange(m5aq11,12,23)
		replace ilo_dur_details=6 if m5aq11>=24 & m5aq11!=.
		replace ilo_dur_details=7 if ilo_dur_details==. & ilo_lfs==2
				replace ilo_dur_details=. if ilo_lfs!=2 
			lab def ilo_unemp_det 1 "Less than 1 month" 2 "1 month to less than 3 months" 3 "3 months to less than 6 months" 4 "6 months to less than 12 months" 5 "12 months to less than 24 months" ///
									6 "24 months or more" 7 "Not elsewhere classified"
			lab values ilo_dur_details ilo_unemp_det
			lab var ilo_dur_details "Duration of unemployment (Details)" 
			
	gen ilo_dur_aggregate=.
		replace ilo_dur_aggregate=1 if inrange(ilo_dur_details,1,3)
		replace ilo_dur_aggregate=2 if ilo_dur_details==4
		replace ilo_dur_aggregate=3 if inlist(ilo_dur_details,5,6)
		replace ilo_dur_aggregate=4 if ilo_dur_details==7
			lab def ilo_unemp_aggr 1 "Less than 6 months" 2 "6 months to less than 12 months" 3 "12 months or more" 4 "Not elsewhere classified"
			lab val ilo_dur_aggregate ilo_unemp_aggr
			lab var ilo_dur_aggregate "Duration of unemployment (Aggregate)"		


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Category of unemployment ('ilo_cat_une')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: no info 
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: no info
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu_isco08') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			
* Comment: no info

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Unemployment benefits schemes ('ilo_soc_aggregate') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: 
			
***********************************************************************************************
*			PART 3.4. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************	
	
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: no info on availability --> variable cannot be defined
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reasons for not seeking a job ('ilo_olf_reason') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: check with Yves - option "have already found a job a job which will start later" let it end up in "other labour market reasons" as it cannot be considered among unemployed (due to the 
				* lack of an availability criterion in the questionnaire 
	
	gen ilo_olf_reason=.		
		replace ilo_olf_reason=1 if	inlist(m5aq9,10,11)					// Labour market (discouraged) 
		replace ilo_olf_reason=2 if inlist(m5aq9,6,7,8)					// Other labour market reasons
		replace ilo_olf_reason=3 if	inlist(m5aq9,1,2,4,5)				// Personal / Family-related
		replace ilo_olf_reason=4 if	inlist(m5aq9,3,9)					// Does not need/want to work
		replace ilo_olf_reason=5 if ilo_olf_reason==. & ilo_lfs==3		// Not elsewhere classified						
			replace ilo_olf_reason=. if ilo_lfs!=3			
			lab def lab_olf_reason 1 "1 - Labour market (discouraged)" 2 "2 - Other labour market reasons" 3 "3 - Personal/Family-related"  4 "4 - Does not need/want to work" 5 "5 - Not elsewhere classified"
			lab val ilo_olf_reason reason_lab 
			lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seekers ('ilo_disc') [done]
* -------------------------------------------------------------------------------------------
* ------------------------------------------------------------------------------------------- 
*
* Comment: 	no info on availability

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training (NEETs) ('ilo_neet') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: No reference period specified, question asked "are you currently going to class?"

		gen ilo_neet=.
			replace ilo_neet=1 if inrange(ilo_age,15,24) & ilo_lfs!=1 & ilo_edu_attendance==2
				lab def ilo_neet_lab 1 "Youth not in education, employment or training"
				lab val ilo_neet ilo_neet_lab
				lab var ilo_neet "Youth not in education, employment or training"
		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

*			SAVE RESULTS

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* -------------------------------------------------------------
* 1.	Prepare final dataset
* -------------------------------------------------------------

cd "$outpath" 

		drop if lab==1 /* in order to get rid of observations from tempfile */
		
		drop indu_code* occ_code* lab isco08_2digits isco88_2digits isco08 isco88 isic4_2digits isic4 isic3_2digits isic3 
	
		compress 
		
		drop if ilo_wgt==.
		
	* Save dataset including original and ilo variables
	
		save ${country}_${source}_${time}_FULL, replace		
	
	*Save file only containing ilo_* variables
	
		keep ilo*
		
		save ${country}_${source}_${time}_ILO, replace
		

	