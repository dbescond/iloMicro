* TITLE OF DO FILE: ILO Microdata Preprocessing code template - China
* DATASET USED: CHIP
* NOTES: 
* Files created: Standard variables on CHIP China
* Authors: DPAU
* Who last updated the file:
* Starting Date: 28 June 2017
* Last updated: 29 June 2017
***********************************************************************************************


*******************************************************************
 /* 1.	Set up work directory, file name, variables and function */
*******************************************************************

clear all 

set more off

global path "J:\COMMON\STATISTICS\DPAU\MICRO"
global country "CHN"
global source "CHIP"
global time "2013"
global input_file "CHIP2013"

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

	use "${input_file}", clear	
	
	rename *, lower
		
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

	gen ilo_key=_n 
		lab var ilo_key "Key unique identifier per individual"	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sample Weight ('ilo_wgt')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_wgt=weight
		lab var ilo_wgt "Sample weight"	
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time period ('ilo_time')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

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
*			Geographical coverage ('ilo_geo')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

		gen ilo_geo=.
			replace ilo_geo=1 if urban==2
			replace ilo_geo=2 if urban==1
			replace ilo_geo=3 if urban==3
				lab def geo_lab 1 "1 - Urban" 2 "2 - Rural" 3 "3 - Not elsewhere classified"
				lab val ilo_geo geo_lab
				lab var ilo_geo "Geographical coverage"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

		gen ilo_sex=a03
			label define label_Sex 1 "1 - Male" 2 "2 - Female"
			label values ilo_sex label_Sex 
			lab var ilo_sex "Sex"
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment:

		gen ilo_age=ager
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
			replace ilo_age_5yrbands=14 if ilo_age>=65 
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
			replace ilo_age_10yrbands=7 if ilo_age>=65
				lab def age_by10_lab 1 "<15" 2 "15-24" 3 "25-34" 4 "35-44" 5 "45-54" 6 "55-64" 7 "65+"
				lab val ilo_age_10yrbands age_by10_lab
				lab var ilo_age_10yrbands "Age (10-year age bands)"
				
		gen ilo_age_aggregate=.
			replace ilo_age_aggregate=1 if inrange(ilo_age,0,15)
			replace ilo_age_aggregate=2 if inrange(ilo_age,15,24)
			replace ilo_age_aggregate=3 if inrange(ilo_age,25,54)
			replace ilo_age_aggregate=4 if inrange(ilo_age,55,64)
			replace ilo_age_aggregate=5 if ilo_age>=65 
				lab def age_aggr_lab 1 "<15" 2 "15-24" 3 "25-54" 4 "55-64" 5 "65+"
				lab val ilo_age_aggregate age_aggr_lab
				lab var ilo_age_aggregate "Age (Aggregate)"

			* As only age bands being kept drop "ilo_age" at the very end -> Use it in between as help variable.

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Level of education ('ilo_edu')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: For the definition, cf. the document "Guide to reporting labour statistics to the ILO using the Excel questionnaire"
			
		gen ilo_edu_aggregate=.
			replace ilo_edu_aggregate=1 if inlist(edulevel,1)
			replace ilo_edu_aggregate=2 if inlist(edulevel,2)
			replace ilo_edu_aggregate=3 if inlist(edulevel,3,4)
			replace ilo_edu_aggregate=4 if inlist(edulevel,5)
			replace ilo_edu_aggregate=5 if edulevel==6
				label def edu_aggr_lab 1 "1 - Less than basic" 2 "2 - Basic" 3 "3 - Intermediate" 4 "4 - Advanced" 5 "5 - Level not stated"
				label val ilo_edu_aggregate edu_aggr_lab
				label var ilo_edu_aggregate "Education (Aggregate level)"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education attendance ('ilo_edu_attendance')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

		gen ilo_edu_attendance=.
			replace ilo_edu_attendance=1 if a19==4
			replace ilo_edu_attendance=2 if a19!=4
			replace ilo_edu_attendance=3 if ilo_edu_attendance==.
				lab def edu_attendance_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
				lab val ilo_edu_attendance edu_attendance_lab
				lab var ilo_edu_attendance "Education (Attendance)"	
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Disability status ('ilo_dsb_details')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment: This variable can't be produced
				
	* gen ilo_dsb_aggregate=.


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
        
* Comment: 	

	gen ilo_wap=.
		replace ilo_wap=1 if (ilo_age>=15 & ilo_age!=.)
		replace ilo_wap=0 if ilo_age<15
			label def ilo_wap_lab 1 "Working age population"
			label val ilo_wap ilo_wap_lab
			label var ilo_wap "Working age population"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Labour Force Status ('ilo_lfs')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
     	 
* Comment: Employment / Unemployment are not based at all on international standard. They are just based on a direct question (A19).  	

	gen ilo_lfs=.
		replace ilo_lfs=1 if (a19==1 & inlist(c03_1,1,2,3,4)) 
		replace ilo_lfs=2 if ilo_lfs!=1 & a19==5
		replace ilo_lfs=3 if !inlist(ilo_lfs,1,2)
		replace ilo_lfs=. if ilo_wap!=1	
				label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status" 

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: 

	gen ilo_mjh=.
		replace ilo_mjh=1 if c11==5
		replace ilo_mjh=2 if inlist(c11,1,2,3,4)
		replace ilo_mjh=1 if ilo_mjh==. & ilo_lfs==1
		replace ilo_mjh=. if ilo_lfs!=1
			lab def lab_ilo_mjh 1 "1 - One job only" 2 "2 - More than one job"
			lab val ilo_mjh lab_ilo_mjh
			lab var ilo_mjh "Multiple job holders"


***********************************************************************************************
*			PART 3.1. ECONOMIC CHARACTERISTICS FOR MAIN JOB 
***********************************************************************************************		

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Status in employment ('ilo_ste')
* -------------------------------------------------------------------------------------------
* ------------------------------------------------------------------------------------------- 

* Comment: 

	* Primary activity
	
		gen ilo_job1_ste_icse93=.
			replace ilo_job1_ste_icse93=1 if c03_1==2
			replace ilo_job1_ste_icse93=2 if c03_1==1
			replace ilo_job1_ste_icse93=3 if c03_1==3
			/* replace ilo_job1_ste_icse93=4 if */
			replace ilo_job1_ste_icse93=5 if c03_1==4
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
*			Economic activity ('ilo_eco')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: 
	
	gen indu_code_prim=c03_3 if ilo_lfs==1

		* Import value labels

		append using `labels', gen (lab)	

		
		* One digit level
	
		* Technical documentation on ISIC Rev. 4:  http://unstats.un.org/unsd/publication/seriesM/seriesm_4rev4e.pdf 
		
		* Primary activity
		
		gen ilo_job1_eco_isic4=.
			replace ilo_job1_eco_isic4=1 if indu_code_prim==1
			replace ilo_job1_eco_isic4=2 if indu_code_prim==2
			replace ilo_job1_eco_isic4=3 if indu_code_prim==3
			replace ilo_job1_eco_isic4=4 if indu_code_prim==4
			replace ilo_job1_eco_isic4=5 if indu_code_prim==14
			replace ilo_job1_eco_isic4=6 if indu_code_prim==5
			replace ilo_job1_eco_isic4=7 if indu_code_prim==6
			replace ilo_job1_eco_isic4=8 if indu_code_prim==7
			replace ilo_job1_eco_isic4=9 if indu_code_prim==8
			replace ilo_job1_eco_isic4=10 if indu_code_prim==9
			replace ilo_job1_eco_isic4=11 if indu_code_prim==10
			replace ilo_job1_eco_isic4=12 if indu_code_prim==11 
			replace ilo_job1_eco_isic4=13 if indu_code_prim==13
			replace ilo_job1_eco_isic4=14 if (indu_code_prim==12 | indu_code_prim==15)
			replace ilo_job1_eco_isic4=15 if indu_code_prim==19
			replace ilo_job1_eco_isic4=16 if indu_code_prim==16
			replace ilo_job1_eco_isic4=17 if indu_code_prim==17
			replace ilo_job1_eco_isic4=18 if indu_code_prim==18
			* replace ilo_job1_eco_isic4=19 if 
			* replace ilo_job1_eco_isic4=20 if 
			replace ilo_job1_eco_isic4=21 if indu_code_prim==20
			replace ilo_job1_eco_isic4=22 if indu_code_prim==. & ilo_lfs==1 
			replace ilo_job1_eco_isic4=. if ilo_lfs!=1
				lab val ilo_job1_eco_isic4 isic4
				lab var ilo_job1_eco_isic4 "Economic activity (ISIC Rev. 4)"

		* Classification at an aggregated level
	
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

				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_ocu')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment:  National classification - Mapping not done

	* Two-digits level
	
		gen occ_code_prim=c03_4 if ilo_lfs==1
	
/*		* Primary occupation
	
		gen ilo_job1_ocu_isco08_2digits=occ_code_prim
			lab values ilo_job1_ocu_isco08_2digits isco08_2digits
			lab var ilo_job1_ocu_isco08_2digits "Occupation (ISCO-08), 2 digit level"

		* One digit level
	
		gen occ_code_prim_1dig=int(occ_code_prim/10) 
	
		* Primary activity
		
		gen ilo_job1_ocu_isco08=occ_code_prim_1dig
			replace ilo_job1_ocu_isco08=10 if ilo_job1_ocu_isco08==0
			replace ilo_job1_ocu_isco08=11 if ilo_job1_ocu_isco08==. & ilo_lfs==1
			replace ilo_job1_ocu_isco08=. if ilo_lfs!=1
				lab def isco08_1dig_lab 1 "1 - Managers" 2 "2 - Professionals" 3 "3 - Technicians and associate professionals" 4 "4 - Clerical support workers" 5 "5 - Service and sales workers" ///
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
				lab var ilo_job1_ocu_skill "Occupation (Skill level)" */

	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_ins_sector')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
		
* Comment:


* --------------------------------------------------------------------------------------------------
* --------------------------------------------------------------------------------------------------
*		Weekly hours actually worked ('ilo_how_actual') and usually worked ('ilo_how_usual')
* --------------------------------------------------------------------------------------------------
* --------------------------------------------------------------------------------------------------

* Comment: 

	* Actual hours worked
		
		* Primary job
		
		gen ilo_job1_how_actual=(c01_2*c01_3)/4.33
			replace ilo_job1_how_actual=0 if ilo_job1_how_actual<=0 & ilo_job1_how_actual!=.
			replace ilo_job1_how_actual=168 if ilo_job1_how_actual>=169 & ilo_job1_how_actual!=.
			replace ilo_job1_how_actual=. if ilo_lfs!=1
				lab var ilo_job1_how_actual "Weekly hours actually worked in main job"
	
		* Secondary job
		
		gen ilo_job2_how_actual=(c11_2*c11_3)/4.33
			replace ilo_job2_how_actual=. if ilo_lfs!=1 & ilo_mjh!=2
				lab var ilo_job2_how_actual "Weekly hours actually worked in secondary job"
			
		* All jobs 
		
		egen ilo_joball_how_actual=rowtotal(ilo_job*_how_actual), m
			replace ilo_joball_how_actual=168 if ilo_joball_how_actual>168 & ilo_joball_how_actual!=.
			replace ilo_joball_how_actual=. if ilo_lfs!=1
				lab var ilo_joball_how_actual "Weekly hours actually worked in all jobs"		

	* Weekly hours actually worked --> Bands --> Use actual hours worked in all jobs 
			
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

		* All jobs 
		
		gen ilo_joball_how_actual_bands=.
			replace ilo_joball_how_actual_bands=1 if ilo_joball_how_actual==0
			replace ilo_joball_how_actual_bands=2 if ilo_joball_how_actual>=1 & ilo_joball_how_actual<=14
			replace ilo_joball_how_actual_bands=3 if ilo_joball_how_actual>=15 & ilo_joball_how_actual<=29
			replace ilo_joball_how_actual_bands=4 if ilo_joball_how_actual>=30 & ilo_joball_how_actual<=34
			replace ilo_joball_how_actual_bands=5 if ilo_joball_how_actual>=35 & ilo_joball_how_actual<=39
			replace ilo_joball_how_actual_bands=6 if ilo_joball_how_actual>=40 & ilo_joball_how_actual<=48
			replace ilo_joball_how_actual_bands=7 if ilo_joball_how_actual>=49 & ilo_joball_how_actual!=.
			replace ilo_joball_how_actual_bands=8 if ilo_lfs==1 & ilo_joball_how_actual_bands==.
				lab values ilo_joball_how_actual_bands how_bands_lab
				lab var ilo_joball_how_actual_bands "Weekly hours actually worked bands in all jobs"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job_time')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment: 40 hours per week is the legal working-time
	
		gen ilo_job1_job_time=.
			replace ilo_job1_job_time=1 if inlist(ilo_joball_how_actual_bands,1,2,3,4,5)
			replace ilo_job1_job_time=2 if inlist(ilo_joball_how_actual_bands,6,7)
			replace ilo_job1_job_time=3 if ilo_job1_job_time==. & ilo_lfs==1
			replace ilo_job1_job_time=. if ilo_lfs!=1
				lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
				lab val ilo_job1_job_time job_time_lab
				lab var ilo_job1_job_time "Job (Working time arrangement)"
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job_contract')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment: 

	gen ilo_job1_job_contract=.
		replace ilo_job1_job_contract=1 if inlist(c07_1,2)
		replace ilo_job1_job_contract=2 if inlist(c07_1,3,4,5)
		replace ilo_job1_job_contract=3 if ilo_lfs==1 & ilo_job1_job_contract==.
		replace ilo_job1_job_contract=. if ilo_lfs!=1
			lab def job_contract_lab 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"
			lab val ilo_job1_job_contract job_contract_lab
			lab var ilo_job1_job_contract "Job (Type of contract)" 

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Informal/Formal economy: Unit of production ('ilo_job1_ife_prod')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: Useful questions:	* c03_1: Status in employment
								* c03_2: Institutional sector 
								* [no info]: Destination of production 
								* c09_2: Proxy for Bookkeeping - Borrow from a formal bank
								* [no info]: Registration						
								* [no info]: Location of workplace 
								* c08: Size of the establishment - Threshold is 10 persons
								* c10: Number of employees
								* Social security benefits
									* a22: Pension insurance - A/B Pension insurance
									* a23: Social security - A Employment insurance - B Unemployment insurance - C Housing provident fund - D Maternity insurance

	gen soc_sec=.
		replace soc_sec=1 if inlist(a22,1,2,12,13,14,15,16,17,23,24,25,26,27,123,124,127,134,145,146,156,157,163,213,1236) & ilo_lfs==1
		replace soc_sec=2 if inlist(a23,1,2,4,12,13,14,21,23,24,32,34,41,42,43,52,123,124,132,134,231,234,243,423,1234,1243,1324,2134) & ilo_lfs==1
		replace soc_sec=3 if a22==8 & a23==5 & ilo_lfs==1
		replace soc_sec=3 if soc_sec==. & ilo_lfs==1
	
	gen ilo_job1_ife_prod=.
		replace ilo_job1_ife_prod=2 if inlist(c03_2,1,2,3,4,5) | (inlist(c03_2,6,7,8) & inrange(c09_2,1,10000000) & (inrange(c10,5,1000) | inlist(c08,2,3,4,5,6,7))) 
		replace ilo_job1_ife_prod=2 if (ilo_job1_ste_icse93==1 & inlist(c03_2,6,7,8) & inlist(soc_sec,1,2))
		replace ilo_job1_ife_prod=1 if ilo_lfs==1 & ilo_job1_ife_prod==.
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
		replace ilo_job1_ife_nature=1 if ilo_job1_ste_icse93==5 | (inlist(ilo_job1_ste_icse93,2,3,4) & inlist(ilo_job1_ife_prod,1,3)) | (inlist(ilo_job1_ste_icse93,1,6) & soc_sec==3) 
		replace ilo_job1_ife_nature=2 if (inlist(ilo_job1_ste_icse93,1,6) & inlist(soc_sec,1,2)) | (inlist(ilo_job1_ste_icse93,2,3,4) & ilo_job1_ife_prod==2)
		replace ilo_job1_ife_nature=. if ilo_lfs!=1
			lab def ife_nature_lab 1 "1 - Persons with informal main job" 2 "2 - Persons with formal main job"
			lab val ilo_job1_ife_nature ife_nature_lab
			lab var ilo_job1_ife_nature "Informal / Formal Economy (Nature of job)"	
			drop soc_sec
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Earnings ('ilo_job1_lri_ees' and 'ilo_ear_slf')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Question used: c05_1 - Total income from the job in Yuan per Year 	
	*	 To convert yearly income into monthly income, the following factor was used: monthly income = yearly income/12

	* Employees:
		gen cash_month=.
			replace cash_month=c05_1/12 if ilo_lfs==1
			replace cash_month=0 if c05_1<=0 & ilo_lfs==1
			replace cash_month=0 if cash_month==. & ilo_lfs==1
			
		gen ilo_job1_lri_ees=cash_month if ilo_lfs==1 & ilo_job1_ste_aggregate==1
				lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"
	
		gen ilo_job1_lri_slf=cash_month if ilo_lfs==1 & ilo_job1_ste_aggregate==2
				lab var ilo_job1_lri_slf "Monthly earnings of self-employed in main job"

		drop cash_month


***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_tru')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
           
* Comment: Not enough information

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
*			Duration of unemployment ('ilo_dur')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: No information

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Category of unemployment ('ilo_cat_une')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: No information

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

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Unemployment benefits schemes ('ilo_soc_aggregate')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: Not enough information 


***********************************************************************************************
*			PART 3.4. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: Not feasible

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reasons for not seeking a job ('ilo_olf_reason')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: Not feasible

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seekers ('ilo_dis')
* -------------------------------------------------------------------------------------------
* ------------------------------------------------------------------------------------------- 

* Comment: Not feasible

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training (NEETs) ('ilo_neet')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_neet=.
		replace ilo_neet=1 if inrange(ilo_age,15,24) & ilo_lfs!=1 & inlist(ilo_edu_attendance,2,3)
			lab def ilo_neet_lab 1 "Youth not in education, employment or training"
			lab val ilo_neet ilo_neet_lab
			lab var ilo_neet "Youth not in education, employment or training"  			

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

*			SAVE RESULTS

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* -------------------------------------------------------------
* Prepare final datasets
* -------------------------------------------------------------

cd "$outpath"

		drop if lab==1 /* In order to get rid of observations from tempfile */

		drop ilo_age /* As only age bands being kept and this variable used as help variable */
		
		drop indu_code_* occ_code_* lab isco08_2digits isco88_2digits isco08 isco88 isic4_2digits isic4 isic3_2digits isic3
	
		compress 
		
		order ilo_key ilo_wgt ilo_time ilo_geo* ilo_sex ilo_age* ilo_edu_* ilo_wap ilo_lfs ilo_mjh ilo_job*_ste* ilo_job*_eco* ilo_job*_job_time ///
		ilo_job*_job_contract ilo_job*_how* ilo_job1_ife_prod ilo_job1_ife_nature ilo_job1_lri_ees ilo_job1_lri_slf ilo_neet, last
		   		   
	* Save dataset including original and ilo variables
	
		save ${country}_${source}_${time}_FULL, replace		
	
	*Save file only containing ilo_* variables
	
		keep ilo*
		
		drop if ilo_key==.

		save ${country}_${source}_${time}_ILO, replace
