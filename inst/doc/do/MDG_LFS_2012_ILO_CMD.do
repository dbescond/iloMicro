* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Madagascar 2012
* DATASET USED: Madagascar 2012
* NOTES: 
* Files created: Standard variables on LFS Madagascar
* Authors: Podjanin
* Who last updated the file: Podjanin, A.
* Starting Date: 28 February 2017
* Last updated: 02 March 2017
***********************************************************************************************



*******************************************************************
 /* 1.	Set up work directory, file name, variables and function */
*******************************************************************

clear all 

set more off

global path "J:\COMMON\STATISTICS\DPAU\MICRO"
global country "MDG"
global source "LFS"
global time "2012"
global input_file "MDG_LFS_2012"

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

	* merge original files
	
		* File "Menagelv" not required
	
	use Indmenlv, clear
	
		merge 1:1 idind12 using Indivlv
		
			drop _merge

	save "${input_file}", replace
	
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
	gen ilo_wgt=poids_p
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

* Comment: 
	
		gen ilo_geo=.
			replace ilo_geo=1 if milieu==1
			replace ilo_geo=2 if milieu==2
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

		gen ilo_sex=m3
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

	gen ilo_age=m4
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
		
	gen ilo_edu_aggregate=.
		replace ilo_edu_aggregate=1 if m13==2 | inrange(m15,0,4)
		replace ilo_edu_aggregate=2 if inrange(m15,5,7)
		replace ilo_edu_aggregate=3 if inrange(m15,8,11)
		replace ilo_edu_aggregate=4 if m14a==5
		replace ilo_edu_aggregate=5 if ilo_edu_aggregate==.
		label def edu_aggr_lab 1 "1 - Less than basic" 2 "2 - Basic" 3 "3 - Intermediate" 4 "4 - Advanced" 5 "5 - Level not stated"
			label val ilo_edu_aggregate edu_aggr_lab
			label var ilo_edu_aggregate "Level of education (Aggregate levels)"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education attendance ('ilo_edu_attendance') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment:

	gen ilo_edu_attendance=.
			replace ilo_edu_attendance=1 if m17==1
			replace ilo_edu_attendance=2 if m17==2
			replace ilo_edu_attendance=3 if ilo_edu_attendance==.
				lab def edu_attendance_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
				lab val ilo_edu_attendance edu_attendance_lab
				lab var ilo_edu_attendance "Education (Attendance)"	
				
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
     	 
* Comment: For the identification of the unemployed, note that the availability criterion considers the past month, and not a maximum of two weeks as it is foreseen by our definitions.
 
	gen ilo_lfs=.
		replace ilo_lfs=1 if ea2==1 | inrange(ea3,1,10) | inrange(ea5,1,4) | ea6==1
		replace ilo_lfs=2 if ilo_lfs!=1 & ea7a==1 & inlist(ea7c,1,2,3) 
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

* Comment: (code reversed - first "2" and then "1" defined)

	gen ilo_mjh=.
		replace ilo_mjh=2 if as1c==1
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
*			Status in employment ('ilo_ste') [done]
* -------------------------------------------------------------------------------------------
* ------------------------------------------------------------------------------------------- 

* Comment: unpaid apprentices considered in category "not classifiable" --> ask Yves to check

	* Primary activity
	
		gen ilo_job1_ste_icse93=.
			replace ilo_job1_ste_icse93=1 if inlist(ap3,1,2,3,4,5)
			replace ilo_job1_ste_icse93=2 if ap3==6
			replace ilo_job1_ste_icse93=3 if ap3==7
			/* replace ilo_job1_ste_icse93=4 if */
			replace ilo_job1_ste_icse93=5 if ap3==9
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
				
	* Secondary activity
	
		gen ilo_job2_ste_icse93=.
			replace ilo_job2_ste_icse93=1 if inlist(as4,1,2,3,4,5)
			replace ilo_job2_ste_icse93=2 if as4==6
			replace ilo_job2_ste_icse93=3 if as4==7
			/* replace ilo_job2_ste_icse93=4 if */
			replace ilo_job2_ste_icse93=5 if as4==9
			replace ilo_job2_ste_icse93=6 if ilo_job2_ste_icse93==. & ilo_lfs==1 & ilo_mjh==2
			replace ilo_job2_ste_icse93=. if ilo_lfs!=1	& ilo_mjh!=2		
				* value label already defined
				label val ilo_job2_ste_icse93 label_ilo_ste_icse93
				label var ilo_job2_ste_icse93 "Status in employment (ICSE 93) in secondary job"

	* Aggregate categories
	
		gen ilo_job2_ste_aggregate=.
			replace ilo_job2_ste_aggregate=1 if ilo_job2_ste_icse93==1
			replace ilo_job2_ste_aggregate=2 if inlist(ilo_job2_ste_icse93,2,3,4)
			replace ilo_job2_ste_aggregate=3 if inlist(ilo_job2_ste_icse93,5,6)
				* value label already defined
				lab val ilo_job2_ste_aggregate ste_aggr_lab
				label var ilo_job2_ste_aggregate "Status in employment (Aggregate) in secondary job" 	
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: 
	
	gen indu_code_prim=int(ap2/10) if ilo_lfs==1 
	
	gen indu_code_sec=int(as3/10) if ilo_lfs==1 & ilo_mjh==2
	
	*gen indu_code_sec=
		
		* Import value labels

		append using `labels', gen (lab)
					
	* Two-digit level
	
		* Primary job
		
		gen ilo_job1_eco_isic4_2digits=indu_code_prim
		
			lab values ilo_job1_eco_isic4 isic4_2digits
			lab var ilo_job1_eco_isic4_2digits "Economic activity (ISIC Rev. 4), 2 digit level"
			
		* Secondary activity
		
		gen ilo_job2_eco_isic4_2digits=indu_code_sec
		
			lab values ilo_job2_eco_isic4 isic4_2digits
			lab var ilo_job2_eco_isic4_2digits "Economic activity (ISIC Rev. 4), 2 digit level in secondary job"
		
	* One digit level
	
		* Technical documentation on ISIC Rev. 4:  http://unstats.un.org/unsd/publication/seriesM/seriesm_4rev4e.pdf 
		
	* Primary activity
		
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
				lab var ilo_job1_eco_isic4 "Economic activity (ISIC Rev. 4)"
				
		* Secondary activity
		
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
			replace ilo_job2_eco_isic4=22 if ilo_job2_eco_isic4_2digits==. & ilo_lfs==1 & ilo_mjh==2
					replace ilo_job2_eco_isic4=. if ilo_lfs!=1 & ilo_mjh!=2
				lab val ilo_job2_eco_isic4 isic4
				lab var ilo_job2_eco_isic4 "Economic activity (ISIC Rev. 4) in secondary job"
		
		
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
*			Occupation ('ilo_ocu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment:  ISCO-88 being used

	* Two digit level

	gen occ_code_prim=int(ap1/10) if ilo_lfs==1 & ap1!=999
	gen occ_code_sec=int(as2/10) if ilo_lfs==1 & ilo_mjh==2
	
		* Primary occupation
	
		gen ilo_job1_ocu_isco88_2digits=occ_code_prim if !inlist(occ_code_prim,98,99)
			lab values ilo_job1_ocu_isco88_2digits isco88_2digits
			lab var ilo_job1_ocu_isco88_2digits "Occupation (ISCO-88), 2 digit level"
			
		* Secondary occupation
	
		gen ilo_job2_ocu_isco88_2digits=occ_code_sec if occ_code_sec!=99
			lab values ilo_job2_ocu_isco88_2digits isco88_2digits
			lab var ilo_job2_ocu_isco88_2digits "Occupation (ISCO-88), 2 digit level - secondary job"
			
	* 1 digit level
	
	gen occ_code_prim_1dig=int(occ_code_prim/10) 
	gen occ_code_sec_1dig=int(occ_code_sec/10)
	
		* Primary activity
		
		gen ilo_job1_ocu_isco88=occ_code_prim_1dig
			replace ilo_job1_ocu_isco88=10 if ilo_job1_ocu_isco88==0
			replace ilo_job1_ocu_isco88=11 if ilo_job1_ocu_isco88==. & ilo_lfs==1
				replace ilo_job1_ocu_isco88=. if ilo_lfs!=1
			lab def isco88_1dig_lab 1 "1 - Managers" 2 "2 - Professionals" 3 "3 - Technicians and associate professionals" 4 "4 - Clerical support workers" 5 "5 - Service and sales workers" ///
									6 "6 - Skilled agricultural, forestry and fishery workers" 7 "7 - Craft and related trades workers" 8 "8 - Plant and machine operators, and assemblers" ///
									9 "9 - Elementary occupations" 10 "0 - Armed forces occupations" 11 "X - Not elsewhere classified"
			lab val ilo_job1_ocu_isco88 isco88_1dig_lab
			lab var ilo_job1_ocu_isco88 "Occupation (ISCO-88)"	
			
		* Secondary activity
		
		gen ilo_job2_ocu_isco88=occ_code_sec_1dig
			replace ilo_job2_ocu_isco88=10 if ilo_job2_ocu_isco88==0
			replace ilo_job2_ocu_isco88=11 if ilo_job2_ocu_isco88==. & ilo_lfs==1 & ilo_mjh==2
				replace ilo_job2_ocu_isco88=. if ilo_lfs!=1 & ilo_mjh!=2			
			* value labels already defined
			lab val ilo_job2_ocu_isco88 isco88_1dig_lab
			lab var ilo_job2_ocu_isco88 "Occupation (ISCO-88) - secondary occupation"
			
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
				
		* Secondary occupation
		
		gen ilo_job2_ocu_aggregate=.
			replace ilo_job2_ocu_aggregate=1 if inrange(ilo_job2_ocu_isco88,1,3)
			replace ilo_job2_ocu_aggregate=2 if inlist(ilo_job2_ocu_isco88,4,5)
			replace ilo_job2_ocu_aggregate=3 if inlist(ilo_job2_ocu_isco88,6,7)
			replace ilo_job2_ocu_aggregate=4 if ilo_job2_ocu_isco88==8
			replace ilo_job2_ocu_aggregate=5 if ilo_job2_ocu_isco88==9
			replace ilo_job2_ocu_aggregate=6 if ilo_job2_ocu_isco88==10
			replace ilo_job2_ocu_aggregate=7 if ilo_job2_ocu_isco88==11
				* value labels already defined
				lab val ilo_job2_ocu_aggregate ocu_aggr_lab
				lab var ilo_job2_ocu_aggregate "Occupation (Aggregate) in secondary job"
				
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
				
		* Secondary occupation 
		
		gen ilo_job2_ocu_skill=.
			replace ilo_job2_ocu_skill=1 if ilo_job2_ocu_isco88==9
			replace ilo_job2_ocu_skill=2 if inlist(ilo_job2_ocu_isco88,4,5,6,7,8)
			replace ilo_job2_ocu_skill=3 if inlist(ilo_job2_ocu_isco88,1,2,3)
			replace ilo_job2_ocu_skill=4 if inlist(ilo_job2_ocu_isco88,10,11)
				* value label already defined
				lab val ilo_job2_ocu_skill ocu_skill_lab
				lab var ilo_job2_ocu_skill "Occupation (Skill level) in secondary job"
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_ins_sector') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
		
* Comment: 

	* Primary occupation
	
	gen ilo_job1_ins_sector=.
		replace ilo_job1_ins_sector=1 if inlist(ap4,1,2)
		replace ilo_job1_ins_sector=2 if ilo_job1_ins_sector!=1 & ilo_lfs==1
				replace ilo_job1_ins_sector=. if ilo_lfs!=1
			lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
			lab values ilo_job1_ins_sector ins_sector_lab
			lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities" 			

* --------------------------------------------------------------------------------------------------
* --------------------------------------------------------------------------------------------------
*		Weekly hours actually (USUALLY) worked ('ilo_how_actual') and ('ilo_how_usual') [done]
* --------------------------------------------------------------------------------------------------
* --------------------------------------------------------------------------------------------------

* Comment: variable as9 asks how many hours were dedicated to the second job in the last week (or usually) -> variable being taken for 
			* actual hours here
	
	* Hours usually worked
	
		* Primary job
		
			* take mean number of hours over last 12 months
		
		egen ilo_job1_how_usual=rowtotal(ap110812 ap110712 ap110612 ap110512 ap110412 ap110312 ap110212 ap110112 ap111211 ap111111 ap111011 ap110911), m
			replace ilo_job1_how_usual=ilo_job1_how_usual/12
			replace ilo_job1_how_usual=. if ilo_lfs!=1
				lab var ilo_job1_how_usual "Weekly hours usually worked in main job"
			
		* Secondary job 
		/* 
		gen ilo_job2_how_usual=
				replace ilo_job2_how_usual=. if ilo_lfs!=1 & ilo_mjh!=2
				lab var ilo_job2_how_usual "Weekly hours usually worked in secondary job"
				
		* All jobs
		
		egen ilo_joball_how_usual=rowtotal(ilo_job*_how_usual), m
			replace ilo_joball_how_usual=168 if ilo_joball_how_usual>168
			replace ilo_joball_how_usual=. if ilo_lfs!=1
			lab var ilo_joball_how_usual "Weekly hours usually worked in all jobs" */
			
	* Actual hours worked 
		
		* Primary job
		
		gen ilo_job1_how_actual=ap11
			replace ilo_job1_how_actual=. if ilo_lfs!=1
			lab var ilo_job1_how_actual "Weekly hours actually worked in main job"
			
		* Secondary job
		
		gen ilo_job2_how_actual=as9
			replace ilo_job2_how_actual=. if ilo_lfs!=1 & ilo_mjh!=2
			lab var ilo_job2_how_actual "Weekly hours actually worked in secondary job"
			
		* All jobs (numbers coincide perfectly with sd2t, considering hours actually worked in all jobs)
		
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
				* value label already defined
				lab values ilo_joball_how_actual_bands how_bands_lab
				lab var ilo_joball_how_actual_bands "Weekly hours actually worked bands in all jobs"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment: set as threshold 35 hours per week (threshold used in technical documentation for identifying 
			* time-related underemployed )
			
			
		gen ilo_job1_job_time=.
			replace ilo_job1_job_time=1 if ilo_job1_how_usual<35
			replace ilo_job1_job_time=2 if ilo_job1_how_usual>=35 & ilo_job1_how_usual!=.
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
		replace ilo_job1_job_contract=1 if ap8e==1
		replace ilo_job1_job_contract=2 if inlist(ap8e,2,3,4)
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
	
	* Useful questions: ap4: Institutional sector 
					*	ap12a: Destination of production 
					*	ap8c1: Bookkeeping (asked to self-employed only)
					*	Registration:
						* ap6a : Service enregistrement
						* ap6b: CNaPS
						* ap6c: N° Statistique 
					*	ap7: Location of workplace 
					* 	ap5: Size of the establishment					
					* 	[no question]: Social security 
										
		gen ilo_job1_ife_prod=.
			replace ilo_job1_ife_prod=1 if !inlist(ap4,1,2,6) & ap12a!=4 & ap8c1!=1 & ap6a!=1 & ap6b!=1 & ap6c!=1
			replace ilo_job1_ife_prod=2 if inlist(ap4,1,2) | ( !inlist(ap4,1,2,6) & ap12a!=4 & ap8c1==1) | (!inlist(ap4,1,2,6) & ap12a!=4 & ap8c1!=1 & (ap6a==1 | ap6b==1 | ap6c==1))
			replace ilo_job1_ife_prod=3 if ap4==6 | (!inlist(ap4,1,2,6) & ap12a==4) | ilo_job1_eco_isic4_2digits==97 | ilo_job1_ocu_isco88_2digits==62
			replace ilo_job1_ife_prod=. if ilo_lfs!=1
				lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 4 "4 - Not elsewhere classified"
				lab val ilo_job1_ife_prod ilo_ife_prod_lab
				lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"			
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Informal/formal economy: nature of job (ilo_job1_ife_nature) [can't be defined]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: can't be defined as no question on social security
	
	/*
	gen ilo_job1_ife_nature=.
		replace ilo_job1_ife_nature=1 if inlist(ilo_job1_ste_icse93,5,6) | (ilo_job1_ste_icse93==1 & sb10!=1) | (inlist(ilo_job1_ste_icse93,2,3,4) & inlist(ilo_job1_ife_prod,1,3))
		replace ilo_job1_ife_nature=2 if (ilo_job1_ste_icse93==1 & sb10==1) | (inlist(ilo_job1_ste_icse93,2,3,4) & ilo_job1_ife_prod==2)
		replace ilo_job1_ife_nature=. if ilo_lfs!=1
			lab def ife_nature_lab 1 "1 - Persons with informal main job" 2 "2 - Persons with formal main job"
			lab val ilo_job1_ife_nature ife_nature_lab
			lab var ilo_job1_ife_nature "Informal / Formal Economy (Nature of job)"		
			*/
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Earnings ('ilo_ear_ees' and 'ilo_ear_slf') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	
* Comment: 

	* Currency in Madagascar: Malagasy ariary
	
	* Primary employment
	
		* Employees
	
		gen ilo_job1_lri_ees=ap13a1*1000 if ilo_job1_ste_aggregate==1
			replace ilo_job1_lri_ees=. if ilo_lfs!=1 | ilo_job1_lri_ees<0
			lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"
			
		* Self employment
		
		* note that the revenue related to self-employment includes also the value of own consumption 
			* (cf. resolution from 1998)
			
		gen ilo_job1_lri_slf=ap13a1*1000 if ilo_job1_ste_aggregate==2
			replace ilo_job1_lri_slf=. if ilo_lfs!=1
			lab var ilo_job1_lri_slf "Monthly labour related income of self-employed in main job"
		
	
	* Secondary employment	
		
		* Employees
				
		gen ilo_job2_lri_ees=as10a1*1000 if ilo_job2_ste_aggregate==1
			replace ilo_job2_lri_ees=. if ilo_lfs!=1 & ilo_mjh!=2
			lab var ilo_job2_lri_ees "Monthly earnings of employees in secondary job"	
			
		* Self-employment
		
		gen ilo_job2_lri_slf=as10a1*1000 if ilo_job2_ste_aggregate==2
			replace ilo_job2_lri_slf=. if ilo_lfs!=1 & ilo_mjh!=2
			lab var ilo_job2_lri_slf "Monthly labour related income of self-employed in secondary job"		
		

***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_tru') [can't be defined]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
           
* Comment: national definition of underemployed considers people working less than 35 hours per week 
			* and that are seeking another job --> questions also formulated in such a way 
			* --> variables to use our definition not available and therefore variable can't be defined

	
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Cases of non-fatal occupational injury ('ilo_joball_oi_case') [no info]
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*
* Comment: no information
		
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Days lost due to cases of occupational injury ('ilo_joball_oi_day') [no info]
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------

* Comment: no information

		
***********************************************************************************************
*			PART 3.3. UNEMPLOYMENT: ECONOMIC CHARACTERISTICS
***********************************************************************************************	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: 

	gen ilo_dur_details=.
		replace ilo_dur_details=1 if c1b==0 & c1a==0
		replace ilo_dur_details=2 if inrange(c1b,1,2) & c1a==0
		replace ilo_dur_details=3 if inrange(c1b,3,5) & c1a==0
		replace ilo_dur_details=4 if inrange(c1b,6,11) & c1a==0
		replace ilo_dur_details=5 if (c1b==12 & c1a==0) | (inrange(c1b,0,11) & c1b==1)
		replace ilo_dur_details=6 if c1b>=2 & c1b!=.
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
		replace ilo_dur_aggregate=4 if ilo_dur_details==7
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
* Comment: 

	gen ilo_cat_une=.
		replace ilo_cat_une=1 if c2==1
		replace ilo_cat_une=2 if c2==2
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

* Comment: ISIC Rev. 4 classification being used 

		gen preveco_cod=int(tp8/10) if ilo_lfs==2 & ilo_cat_une==1
		
			* keep this variable on the two digit level, in order to be able to correctly execute the code below
		
	* Previous economic activity
	
	gen ilo_preveco_isic4=.
		replace ilo_preveco_isic4=1 if inrange(preveco_cod,1,3)
		replace ilo_preveco_isic4=2 if inrange(preveco_cod,5,9)
		replace ilo_preveco_isic4=3 if inrange(preveco_cod,10,33)
		replace ilo_preveco_isic4=4 if preveco_cod==35
		replace ilo_preveco_isic4=5 if inrange(preveco_cod,36,39)
		replace ilo_preveco_isic4=6 if inrange(preveco_cod,41,43)
		replace ilo_preveco_isic4=7 if inrange(preveco_cod,45,47)
		replace ilo_preveco_isic4=8 if inrange(preveco_cod,49,53)
		replace ilo_preveco_isic4=9 if inrange(preveco_cod,55,56)
		replace ilo_preveco_isic4=10 if inrange(preveco_cod,58,63)
		replace ilo_preveco_isic4=11 if inrange(preveco_cod,64,66)
		replace ilo_preveco_isic4=12 if preveco_cod==68
		replace ilo_preveco_isic4=13 if inrange(preveco_cod,69,75)
		replace ilo_preveco_isic4=14 if inrange(preveco_cod,77,82)
		replace ilo_preveco_isic4=15 if preveco_cod==84
		replace ilo_preveco_isic4=16 if preveco_cod==85
		replace ilo_preveco_isic4=17 if inrange(preveco_cod,86,88)
		replace ilo_preveco_isic4=18 if inrange(preveco_cod,90,93)
		replace ilo_preveco_isic4=19 if inrange(preveco_cod,94,96)
		replace ilo_preveco_isic4=20 if inrange(preveco_cod,97,98)
		replace ilo_preveco_isic4=21 if preveco_cod==99
		replace ilo_preveco_isic4=22 if preveco_cod==. & ilo_cat_une==1 & ilo_lfs==2
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
			
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu_isco08') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			
* Comment: ISCO-08 classification being used

	* reduce it to the one digit level 
	
	gen prevocu_cod=int(tp7/100) if ilo_lfs==2 & ilo_cat_une==1
	
	gen ilo_prevocu_isco88=prevocu_cod
		replace ilo_prevocu_isco88=10 if ilo_prevocu_isco88==0
		replace ilo_prevocu_isco88=11 if ilo_prevocu_isco88==. & ilo_cat_une==1 & ilo_lfs==2
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
			
	* Skill level
	
		gen ilo_prevocu_skill=.
			replace ilo_prevocu_skill=1 if ilo_prevocu_isco88==9
			replace ilo_prevocu_skill=2 if inlist(ilo_prevocu_isco88,4,5,6,7,8)
			replace ilo_prevocu_skill=3 if inlist(ilo_prevocu_isco88,1,2,3)
			replace ilo_prevocu_skill=4 if inlist(ilo_prevocu_isco88,10,11)
				* value label already defined
				lab val ilo_prevocu_skill ocu_skill_lab
				lab var ilo_prevocu_skill "Occupation (Skill level)"
	
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

* Comment: only first option can be defined --> very high share falling into category "unknown" - don't keep variable
	
	/*
	 gen ilo_olf_dlma=.
		replace ilo_olf_dlma=1 if ea7a==1 & ea7c==4 
		*replace ilo_olf_dlma=2 if 
		/* replace ilo_olf_dlma=3 if 
		 replace ilo_olf_dlma=4 if */
		replace ilo_olf_dlma=5 if ilo_olf_dlma==. & ilo_lfs==3
				replace ilo_olf_dlma=. if ilo_lfs!=3
			lab def lab_olf_dlma 1 "1 - Seeking, not available (Unavailable jobseekers)" 2 "2 - Not seeking, available (Available potential jobseekers)" ///
						3 "3 - Not seeking, not available, willing (Willing non-jobseekers)" 4 "4 - Not seeking, not available, not willing" 5 "5 - Not elsewhere classified"
			lab val ilo_olf_dlma lab_olf_dlma
			lab var ilo_olf_dlma "Labour market attachment (Degree of)" 
			
			*/
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reasons for not seeking a job ('ilo_olf_reason') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: 

	gen ilo_olf_reason=.
		replace ilo_olf_reason=1 if inlist(ea8b,1,2,3,5,7)
		replace ilo_olf_reason=2 if ea8b==4
		replace ilo_olf_reason=3 if inlist(ea8b,6,8)
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

	gen ilo_dis=1 if ilo_lfs==3 & inlist(ea8b,1,2,3)
		lab def ilo_dis_lab 1 "Discouraged job-seekers" 
		lab val ilo_dis ilo_dis_lab
		lab var ilo_dis "Discouraged job-seekers"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training (NEETs) ('ilo_neet') [done]
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
* 1.	Prepare final datasets
* -------------------------------------------------------------

cd "$outpath"

		drop if lab==1 /* in order to get rid of observations from tempfile */

		drop ilo_age /* as only age bands being kept and this variable used as help variable */
		
		drop indu_code_* occ_code_*  prev*_cod lab isco08_2digits isco88_2digits isco08 isco88 isic4_2digits isic4 isic3_2digits isic3  
	
		compress 
		
		order ilo_key ilo_wgt ilo_time ilo_geo ilo_sex ilo_age* ilo_edu_* /* ilo_dsb* */ ilo_wap ilo_lfs ilo_mjh  ilo_job*_ste* ilo_job*_eco* ilo_job*_ocu*  ilo_job*_ins_sector ///
		ilo_job*_job_time ilo_job*_job_contract ilo_job*_ife*  ilo_job*_how*  ilo_job*_lri_* /* ilo_joball_tru*/ /*ilo_joball_oi* */ ilo_cat_une  ilo_dur_* ilo_prev*    ///
		 /* ilo_gsp_uneschemes */ ilo_olf_* ilo_dis ilo_neet, last
		   		   
	* Save dataset including original and ilo variables
	
		save ${country}_${source}_${time}_FULL, replace		
	
	* Save file only containing ilo_* variables
	
		keep ilo*

		save ${country}_${source}_${time}_ILO, replace

