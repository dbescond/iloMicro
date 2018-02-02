* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Turkey
* DATASET USED: Turkish LFS
* NOTES: 
* Files created: Standard variables on LFS Turkey
* Authors: Podjanin
* Who last updated the file: Podjanin, A.
* Starting Date: 07 June 2017
* Last updated: 07 June 2017
***********************************************************************************************



*******************************************************************
 /* 1.	Set up work directory, file name, variables and function */
*******************************************************************

clear all 

set more off

global path "J:\COMMON\STATISTICS\DPAU\MICRO"
global country "TUR"
global source "LFS"
global time "2015"
global inputFile "2015YIL"

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
	
*******************************************************************************************
		
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

	gen ilo_wgt=agirlik_katsayisi*1000
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

* Comment: variable seems to be missing...
	/*
		gen ilo_geo=.
			replace ilo_geo=1 if 
			replace ilo_geo=2 if 
				lab def geo_lab 1 "1 - Urban" 2 "2 - Rural" 3 "3 - Not elsewhere classified"
				lab val ilo_geo geo_lab
				lab var ilo_geo "Geographical coverage"
			*/
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: 

		gen ilo_sex=cinsiyet
			label define label_Sex 1 "1 - Male" 2 "2 - Female"
			label values ilo_sex label_Sex 
			lab var ilo_sex "Sex"
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: note that minimum age considered is 15 years

	gen ilo_age=yas
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
		replace ilo_age_10yrbands=1 if inrange(ilo_age,0,14)
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
		replace ilo_age_aggregate=1 if inrange(ilo_age,0,14)
		replace ilo_age_aggregate=2 if inrange(ilo_age,15,24)
		replace ilo_age_aggregate=3 if inrange(ilo_age,25,54)
		replace ilo_age_aggregate=4 if inrange(ilo_age,55,64)
		replace ilo_age_aggregate=5 if ilo_age>=65 
			lab def age_aggr_lab 1 "<15" 2 "15-24" 3 "25-54" 4 "55-64" 5 "65+"
			lab val ilo_age_aggregate age_aggr_lab
			lab var ilo_age_aggregate "Age (Aggregate)"
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Level of education ('ilo_edu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: completed level of education always to be considered!
	
		* for the definition, cf. the document "Guide to reporting labour statistics to the ILO using the Excel questionnaire"
		
	gen ilo_edu_aggregate=.
		replace ilo_edu_aggregate=1 if inlist(ilo_edu_isced97,1,2)
		replace ilo_edu_aggregate=2 if inlist(ilo_edu_isced97,3,4)
		replace ilo_edu_aggregate=3 if inlist(ilo_edu_isced97,5,6)
		replace ilo_edu_aggregate=4 if inlist(ilo_edu_isced97,7,8)
		replace ilo_edu_aggregate=5 if ilo_edu_isced97==9
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

		gen ilo_edu_attendance=.
			replace ilo_edu_attendance=1 if egitim_devam_k==1
			replace ilo_edu_attendance=2 if egitim_devam_k==2
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

	* no info 

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
				replace ilo_wap=. if ilo_wgt==.
			label def ilo_wap_lab 1 "Working age population"
			label val ilo_wap ilo_wap_lab
			label var ilo_wap "Working age population" //15+ population

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Labour Force Status ('ilo_lfs') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
     	 
* Comment: "durum" - predefined variable - given that all variables used to identify people in employment are not appearing in this dataset, use their pre-defined variable


		gen seek_job=.
		
		foreach var of varlist isara_kanal1 isara_kanal2 isara_kanal3 isara_kanal4 isara_kanal5 isara_kanal6 isara_kanal7 isara_kanal8 isara_kanal9 isara_kanal10 isara_kanal11 isara_kanal12 isara_kanal13 {
			replace seek_job=1 if `var'==1
				}
 
	gen ilo_lfs=.
		replace ilo_lfs=1 if durum==1
		replace ilo_lfs=2 if ilo_lfs!=1 & ( seek_job==1 | inlist(isaramama_neden,1,2)) & (isbasi_issiz==1 | isbasi_isbulan==1)
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
		replace ilo_mjh=1 if ekis_durum==2
		replace ilo_mjh=2 if ekis_durum==1
		replace ilo_mjh=. if ilo_lfs!=1
				* force missing values into "one job only" 
				replace ilo_mjh=1 if ilo_mjh==. & ilo_lfs==1
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
			replace ilo_job1_ste_icse93=1 if isteki_durum_k==1
			replace ilo_job1_ste_icse93=2 if isteki_durum_k==2
			replace ilo_job1_ste_icse93=3 if isteki_durum_k==3
			/* replace ilo_job1_ste_icse93=4 if */
			replace ilo_job1_ste_icse93=5 if isteki_durum_k==4
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
			replace ilo_job2_ste_icse93=1 if isteki_durum_ekis==1
			replace ilo_job2_ste_icse93=2 if isteki_durum_ekis==2
			replace ilo_job2_ste_icse93=3 if isteki_durum_ekis==3
			/* replace ilo_job2_ste_icse93=4 if */
			replace ilo_job2_ste_icse93=5 if isteki_durum_ekis==4
			replace ilo_job2_ste_icse93=6 if ilo_job2_ste_icse93==. & ilo_mjh==2
			replace ilo_job2_ste_icse93=. if ilo_mjh!=2		
				* value label already defined
				label val ilo_job2_ste_icse93 label_ilo_ste_icse93
				label var ilo_job2_ste_icse93 "Status in employment (ICSE 93) in secondary activity"

	* Aggregate categories
	
		gen ilo_job2_ste_aggregate=.
			replace ilo_job2_ste_aggregate=1 if ilo_job2_ste_icse93==1
			replace ilo_job2_ste_aggregate=2 if inlist(ilo_job2_ste_icse93,2,3,4)
			replace ilo_job2_ste_aggregate=3 if inlist(ilo_job2_ste_icse93,5,6)
				* value label already defined
				lab val ilo_job2_ste_aggregate ste_aggr_lab
				label var ilo_job2_ste_aggregate "Status in employment (Aggregate) in secondary activity" 	
	
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: NACE Rev. 2 Classification used, which is aligned with ISIC Rev. 4
	
	gen indu_code_prim=nace2_esas_k if ilo_lfs==1 
		
		* Import value labels

		append using `labels', gen (lab)
		
	* Primary occupation
					
		* Two-digit level
			
		gen ilo_job1_eco_isic4_2digits=indu_code_prim		
			lab values ilo_job1_eco_isic4 isic4_2digits
			lab var ilo_job1_eco_isic4_2digits "Economic activity (ISIC Rev. 4), 2 digit level"
			
		* One digit level
		
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
	
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_ocu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: ISCO-08 classification used

	* Two digit level

	gen occ_code_prim=isco08_esas_k if ilo_lfs==1
		
		* Primary occupation
		
		gen ilo_job1_ocu_isco08_2digits=occ_code_prim
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
		
* Comment: CHECK with Yves

	* Primary occupation
	
		gen ilo_job1_ins_sector=.
			replace ilo_job1_ins_sector=1 if inlist(ozel_kamu,2,98) 
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

* Comment: 
			
	* Actual hours worked 
	
		* Main job
		
		gen ilo_job1_how_actual=esas_fiili
			replace ilo_job1_how_actual=168 if ilo_job1_how_actual>168
			replace ilo_job1_how_actual=. if ilo_lfs!=1
			lab var ilo_job1_how_actual "Weekly hours actually worked in main job"
			
		* Secondary job
		
		gen ilo_job2_how_actual=ekis_fiili 
			replace ilo_job2_how_actual=. if ilo_mjh!=2
			lab var ilo_job2_how_actual "Weekly hours actually worked in secondary job"
			
		* All jobs 
		
		egen ilo_joball_how_actual=rowtotal(ilo_job*_how_actual), m
			replace ilo_joball_how_actual=168 if ilo_joball_how_actual>168
			replace ilo_joball_how_actual=. if ilo_lfs!=1
			lab var ilo_joball_how_actual "Weekly hours actually worked in all jobs"
	
	* Hours usually worked
	
		gen ilo_job1_how_usual= esas_hafsaat_genel if ilo_lfs==1
			lab var ilo_job1_how_usual "Weekly hours usually worked in main job"
			
	
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
				lab var ilo_job1_how_actual_bands "Weekly hours actually worked bands in all jobs"		
		
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
				* value labels already defined
				lab values ilo_joball_how_actual_bands how_bands_lab
				lab var ilo_joball_how_actual_bands "Weekly hours actually worked bands in all jobs"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment: use pre-defined variable 

		gen ilo_job1_job_time=.
			replace ilo_job1_job_time=1 if calisma_sekli==1
			replace ilo_job1_job_time=2 if calisma_sekli==2
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
			replace ilo_job1_job_contract=1 if is_sureklilik==1
			replace ilo_job1_job_contract=2 if is_sureklilik==2
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

* Comment: minimum for the size criterion set at 10 (cf. variable calisan_sayi_hh) - check with Yves whether it is ok to keep it like this
	
	* Useful questions: ozel_kamu: Institutional sector 
					*	[no info]: Destination of production 
					*	[no info]: Bookkeeping 
					*	[no info]: Registration 
					*	isyeri_durum: Location of workplace 
					* 	calisan_sayi_hh: Size of the establishment					
					* 	kayitlilik: Social security (proxy: Pension fund) 
					
	
	gen ilo_job1_ife_prod=.
		replace ilo_job1_ife_prod=1 if !inlist(ozel_kamu,2,98) & ((ilo_job1_ste_aggregate==1 & kayitlilik!=1) | ilo_job1_ste_aggregate!=1) & (isyeri_durum!=2 | (isyeri_durum==2 & !inrange(calisan_sayi_hh,2,5)))
		replace ilo_job1_ife_prod=2 if inlist(ozel_kamu,2,98) | (!inlist(ozel_kamu,2,98) & ilo_job1_ste_aggregate==1 & kayitlilik==1) | (!inlist(ozel_kamu,2,98) & ///
					((ilo_job1_ste_aggregate==1 & kayitlilik!=1) | ilo_job1_ste_aggregate!=1) & isyeri_durum==2 & inrange(calisan_sayi_hh,2,5))
		replace ilo_job1_ife_prod=3 if ilo_job1_ocu_isco08_2digits==63 | ilo_job1_eco_isic4_2digits==97
		replace ilo_job1_ife_prod=4 if ilo_job1_ife_prod==. & ilo_lfs==1
				replace ilo_job1_ife_prod=. if ilo_lfs!=1
			lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 4 "4 - Not elsewhere classified"
			lab val ilo_job1_ife_prod ilo_ife_prod_lab
			lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"
			
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Informal/formal economy: nature of job (ilo_job1_ife_nature) [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* 
* Comment: 

		gen ilo_job1_ife_nature=.
			replace ilo_job1_ife_nature=1 if ilo_job1_ste_icse93==5 | (inlist(ilo_job1_ste_icse93,1,6) & kayitlilik!=1) | (inlist(ilo_job1_ste_icse93,2,3,4) & inlist(ilo_job1_ife_prod,1,3))
			replace ilo_job1_ife_nature=2 if (inlist(ilo_job1_ste_icse93,1,6) & kayitlilik==1) | (inlist(ilo_job1_ste_icse93,2,3,4) & ilo_job1_ife_prod==2)
			replace ilo_job1_ife_nature=. if ilo_lfs!=1
				lab def ife_nature_lab 1 "1 - Persons with informal main job" 2 "2 - Persons with formal main job"
				lab val ilo_job1_ife_nature ife_nature_lab
				lab var ilo_job1_ife_nature "Informal / Formal Economy (Nature of job)"

		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Earnings ('ilo_ear_ees' and 'ilo_ear_slf') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	
* Comment: any kind of bonus is not being considered, as it can't be distinguished whether they belong to the primary or the secondary employment

	* Currency in Turkey: Turkish lira
	
		* generate help variables for the calculation of the income variables
		
				*salary from main wage job
			*calculate annual value directly				
				
		gen monthly_wage_prim=.
			replace monthly_wage_prim=(p524e1*365/12) if p523==1
			replace monthly_wage_prim=(p524e1*52/12) if p523==2
			replace monthly_wage_prim=(p524e1*26/12) if p523==3
			replace monthly_wage_prim=(p524e1) if p523==4
						
	* In-kind payments 
	
		* calculate monthly values for each type of in-kind payment
		
		gen monthly_food_prim=.
			replace monthly_food_prim=(p5291b*365/12) if p5291a==1
			replace monthly_food_prim=(p5291b*52/12) if p5291a==2
			replace monthly_food_prim=(p5291b*26/12) if p5291a==3
			replace monthly_food_prim=(p5291b) if p5291a==4
			replace monthly_food_prim=(p5291b/2) if p5291a==5
			replace monthly_food_prim=(p5291b/3) if p5291a==6
			replace monthly_food_prim=(p5291b/6) if p5291a==7
			replace monthly_food_prim=(p5291b/12) if p5291a==8
			
		gen monthly_clothes_prim=.
			replace monthly_clothes_prim=(p5292b*365/12) if p5292a==1
			replace monthly_clothes_prim=(p5292b*52/12) if p5292a==2
			replace monthly_clothes_prim=(p5292b*26/12) if p5292a==3
			replace monthly_clothes_prim=(p5292b) if p5292a==4
			replace monthly_clothes_prim=(p5292b/2) if p5292a==5
			replace monthly_clothes_prim=(p5292b/3) if p5292a==6
			replace monthly_clothes_prim=(p5292b/6) if p5292a==7
			replace monthly_clothes_prim=(p5292b/12) if p5292a==8
			
		gen monthly_transport_prim=.
			replace monthly_transport_prim=(p5293b*365/12) if p5293a==1
			replace monthly_transport_prim=(p5293b*52/12) if p5293a==2
			replace monthly_transport_prim=(p5293b*26/12) if p5293a==3
			replace monthly_transport_prim=(p5293b) if p5293a==4
			replace monthly_transport_prim=(p5293b/2) if p5293a==5
			replace monthly_transport_prim=(p5293b/3) if p5293a==6
			replace monthly_transport_prim=(p5293b/6) if p5293a==7
			replace monthly_transport_prim=(p5293b/12) if p5293a==8
			
		gen monthly_dwelling_prim=.
			replace monthly_dwelling_prim=(p5294b*365/12) if p5294a==1
			replace monthly_dwelling_prim=(p5294b*52/12) if p5294a==2
			replace monthly_dwelling_prim=(p5294b*26/12) if p5294a==3
			replace monthly_dwelling_prim=(p5294b) if p5294a==4
			replace monthly_dwelling_prim=(p5294b/2) if p5294a==5
			replace monthly_dwelling_prim=(p5294b/3) if p5294a==6
			replace monthly_dwelling_prim=(p5294b/6) if p5294a==7
			replace monthly_dwelling_prim=(p5294b/12) if p5294a==8
			
		gen monthly_health_prim=.
			replace monthly_health_prim=(p5295b*365/12) if p5295a==1
			replace monthly_health_prim=(p5295b*52/12) if p5295a==2
			replace monthly_health_prim=(p5295b*26/12) if p5295a==3
			replace monthly_health_prim=(p5295b) if p5295a==4
			replace monthly_health_prim=(p5295b/2) if p5295a==5
			replace monthly_health_prim=(p5295b/3) if p5295a==6
			replace monthly_health_prim=(p5295b/6) if p5295a==7
			replace monthly_health_prim=(p5295b/12) if p5295a==8
			
		gen monthly_other_prim=.
			replace monthly_other_prim=(p5296b*365/12) if p5296a==1
			replace monthly_other_prim=(p5296b*52/12) if p5296a==2
			replace monthly_other_prim=(p5296b*26/12) if p5296a==3
			replace monthly_other_prim=(p5296b) if p5296a==4
			replace monthly_other_prim=(p5296b/2) if p5296a==5
			replace monthly_other_prim=(p5296b/3) if p5296a==6
			replace monthly_other_prim=(p5296b/6) if p5296a==7
			replace monthly_other_prim=(p5296b/12) if p5296a==8
			
			
	* Help variables for secondary employment
			
	gen monthly_wage_sec=p538e1
						
	* In-kind payments 
	
		* calculate annual values for each type of in-kind payment
		
		gen monthly_food_sec=.
			replace monthly_food_sec=(p5401b*365/12) if p5401a==1
			replace monthly_food_sec=(p5401b*52/12) if p5401a==2
			replace monthly_food_sec=(p5401b*26/12) if p5401a==3
			replace monthly_food_sec=(p5401b) if p5401a==4
			replace monthly_food_sec=(p5401b/2) if p5401a==5
			replace monthly_food_sec=(p5401b/3) if p5401a==6
			replace monthly_food_sec=(p5401b/6) if p5401a==7
			replace monthly_food_sec=(p5401b/12) if p5401a==8
			
		gen monthly_clothes_sec=.
			replace monthly_clothes_sec=(p5402b*365/12) if p5402a==1
			replace monthly_clothes_sec=(p5402b*52/12) if p5402a==2
			replace monthly_clothes_sec=(p5402b*26/12) if p5402a==3
			replace monthly_clothes_sec=(p5402b) if p5402a==4
			replace monthly_clothes_sec=(p5402b/2) if p5402a==5
			replace monthly_clothes_sec=(p5402b/3) if p5402a==6
			replace monthly_clothes_sec=(p5402b/6) if p5402a==7
			replace monthly_clothes_sec=(p5402b/12) if p5402a==8
			
		gen monthly_transport_sec=.
			replace monthly_transport_sec=(p5403b*365/12) if p5403a==1
			replace monthly_transport_sec=(p5403b*52/12) if p5403a==2
			replace monthly_transport_sec=(p5403b*26/12) if p5403a==3
			replace monthly_transport_sec=(p5403b) if p5403a==4
			replace monthly_transport_sec=(p5403b/2) if p5403a==5
			replace monthly_transport_sec=(p5403b/3) if p5403a==6
			replace monthly_transport_sec=(p5403b/6) if p5403a==7
			replace monthly_transport_sec=(p5403b/12) if p5403a==8
			
		gen monthly_dwelling_sec=.
			replace monthly_dwelling_sec=(p5404b*365/12) if p5404a==1
			replace monthly_dwelling_sec=(p5404b*52/12) if p5404a==2
			replace monthly_dwelling_sec=(p5404b*26/12) if p5404a==3
			replace monthly_dwelling_sec=(p5404b) if p5404a==4
			replace monthly_dwelling_sec=(p5404b/2) if p5404a==5
			replace monthly_dwelling_sec=(p5404b/3) if p5404a==6
			replace monthly_dwelling_sec=(p5404b/6) if p5404a==7
			replace monthly_dwelling_sec=(p5404b/12) if p5404a==8
			
		gen monthly_health_sec=.
			replace monthly_health_sec=(p5405b*365/12) if p5405a==1
			replace monthly_health_sec=(p5405b*52/12) if p5405a==2
			replace monthly_health_sec=(p5405b*26/12) if p5405a==3
			replace monthly_health_sec=(p5405b) if p5405a==4
			replace monthly_health_sec=(p5405b/2) if p5405a==5
			replace monthly_health_sec=(p5405b/3) if p5405a==6
			replace monthly_health_sec=(p5405b/6) if p5405a==7
			replace monthly_health_sec=(p5405b/12) if p5405a==8
			
		gen monthly_other_sec=.
			replace monthly_other_sec=(p5406b*365/12) if p5406a==1
			replace monthly_other_sec=(p5406b*52/12) if p5406a==2
			replace monthly_other_sec=(p5406b*26/12) if p5406a==3
			replace monthly_other_sec=(p5406b) if p5406a==4
			replace monthly_other_sec=(p5406b/2) if p5406a==5
			replace monthly_other_sec=(p5406b/3) if p5406a==6
			replace monthly_other_sec=(p5406b/6) if p5406a==7
			replace monthly_other_sec=(p5406b/12) if p5406a==8
	
	* Employees
	
		egen ilo_job1_lri_ees=rowtotal(monthly_*_prim),m 
			replace ilo_job1_lri_ees=. if ilo_lfs!=1 | ilo_job1_lri_ees<0
			lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"
			
	* Self-employement (including own consumption)
	
		egen ilo_job1_lri_slf=rowtotal(p530a p536), m 
			replace ilo_job1_lri_slf=. if ilo_lfs!=1
			lab var ilo_job1_lri_slf "Monthly labour related income of self-employed in main job"
		
	
	* Secondary employment 
		
		* Wage employment
		
		egen ilo_job2_lri_ees=rowtotal(monthly_*_sec),m 
			replace ilo_job2_lri_ees=. if ilo_mjh!=2 | ilo_job2_lri_ees<0
			lab var ilo_job2_lri_ees "Monthly earnings of employees in secondary job"
			
		* Self-employment (including own consumption)
		
		egen ilo_job2_lri_slf=rowtotal(p541a p543), m
			replace ilo_job2_lri_slf=. if ilo_mjh!=2
			lab var ilo_job2_lri_slf "Monthly labour related income of self-employed in secondary job"
		
	

***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_tru') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
           
* Comment: 

		gen ilo_joball_tru=1 if ilo_job1_job_time==1 & p521==1 & p521a==1
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
* Comment: 

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
*			Duration of unemployment ('ilo_dur') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: question asks for how many weeks the person was seeking a job without breaks - max. number of weeks appearing is 48 weeks

	gen ilo_dur_details=.
		replace ilo_dur_details=1 if inrange(p551,1,3)
		replace ilo_dur_details=2 if inrange(p551,4,11)
		replace ilo_dur_details=3 if inrange(p551,12,23)
		replace ilo_dur_details=4 if inrange(p551,24,47)
		replace ilo_dur_details=5 if inrange(p551,48,95)
		/* replace ilo_dur_details=6 if */
		replace ilo_dur_details=7 if ilo_dur_details==. & ilo_lfs==2
				replace ilo_dur_details=. if ilo_lfs!=2
			lab def ilo_unemp_det 1 "Less than 1 month" 2 "1 month to less than 3 months" 3 "3 months to less than 6 months" 4 "6 months to less than 12 months" 5 "12 months to less than 24 months" ///
									6 "24 months or more" 7 "Not elsewhere classified"
			lab values ilo_dur_details ilo_unemp_det
			lab var ilo_dur_details "Duration of unemployment (Details)"
			
	* in order to avoid putting any notes and as the exact duration is not precised if person seeking for a job for 52 weeks, take only the aggregate version
			
			
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
		replace ilo_cat_une=1 if p552==1
		replace ilo_cat_une=2 if p552==2
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

* Comment: 
		
		gen preveco_cod=int(p554/100) if ilo_cat_une==1
	
		
	* One digit level
	
		* Primary activity
		
		gen ilo_preveco_isic3=.
			replace ilo_preveco_isic3=1 if inrange(preveco_cod,1,2)
			replace ilo_preveco_isic3=2 if preveco_cod==5
			replace ilo_preveco_isic3=3 if inrange(preveco_cod,10,14)
			replace ilo_preveco_isic3=4 if inrange(preveco_cod,15,37)
			replace ilo_preveco_isic3=5 if inrange(preveco_cod,40,41)
			replace ilo_preveco_isic3=6 if preveco_cod==45
			replace ilo_preveco_isic3=7 if inrange(preveco_cod,50,52)
			replace ilo_preveco_isic3=8 if preveco_cod==55
			replace ilo_preveco_isic3=9 if inrange(preveco_cod,60,64)
			replace ilo_preveco_isic3=10 if inrange(preveco_cod,65,67)
			replace ilo_preveco_isic3=11 if inrange(preveco_cod,70,74)
			replace ilo_preveco_isic3=12 if preveco_cod==75
			replace ilo_preveco_isic3=13 if preveco_cod==80
			replace ilo_preveco_isic3=14 if preveco_cod==85
			replace ilo_preveco_isic3=15 if inrange(preveco_cod,90,93)
			replace ilo_preveco_isic3=16 if preveco_cod==95
			replace ilo_preveco_isic3=17 if preveco_cod==99
			replace ilo_preveco_isic3=18 if ilo_preveco_isic3==. & ilo_cat_une==1
					replace ilo_preveco_isic3=. if ilo_cat_une!=1
				lab val ilo_preveco_isic3 isic3
				lab var ilo_preveco_isic3 "Economic activity (ISIC Rev. 3.1)"
				
			
	* Now do the classification on an aggregate level
	
		* Primary activity
		
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
				lab var ilo_preveco_aggregate "Economic activity (Aggregate)"
			
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu_isco08') [no info available]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			
* Comment: no info available
	
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
*			Degree of labour market attachment ('ilo_olf_dlma') [variable not being kept]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: note that job-seekers are not asked about their availability! therefore only second option can be defined
		* very high share of observations falling into category "not elsewhere classified" and therefore variable is not being kept

/*
	 gen ilo_olf_dlma=.
		/*replace ilo_olf_dlma=1 if */
		replace ilo_olf_dlma=2 if (p547==1 | p548==1) & (inrange(p549,1,9) | p550==7)
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
*			Reasons for not seeking a job ('ilo_olf_reason') [variable not being kept]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment:  high share of observations falling into category "not elsewhere classified" as question asked only to people being available to work
/*
	 gen ilo_olf_reason=.
		replace ilo_olf_reason=1 if inlist(p549,1,2,3,4)
		replace ilo_olf_reason=2 if inlist(p549,6,7)
		/* replace ilo_olf_reason=3 if */
		replace ilo_olf_reason=4 if ilo_olf_reason==. & ilo_lfs==3
			replace ilo_olf_reason=. if ilo_lfs!=3
			lab def lab_olf_reason 1 "1 - Labour market" 2 "2 - Personal/Family-related"  3 "3 - Does not need/want to work" 4 "4 - Not elsewhere classified"
			lab val ilo_olf_reason lab_olf_reason
			lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"
			
			*/
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seekers ('ilo_dis') [done]
* -------------------------------------------------------------------------------------------
* ------------------------------------------------------------------------------------------- 

* Comment: 

	gen ilo_dis=1 if ilo_lfs==3 & inlist(p549,1,2,3,4) & p548==1
		lab def ilo_dis_lab 1 "Discouraged job-seekers" 
		lab val ilo_dis ilo_dis_lab
		lab var ilo_dis "Discouraged job-seekers"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training (NEETs) ('ilo_neet') [no info on educational attendance]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

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
* 1.	Prepare final datasets
* -------------------------------------------------------------

cd "$outpath"
		
		foreach var of varlist ilo_* {
	
	replace `var'=. if considered!=1 
	
	}

		drop if lab==1 /* in order to get rid of observations from tempfile */

		drop indu_code_* occ_code_*  /*prev*_cod*/  lab isco08_2digits isco88_2digits isco08 isco88 isic4_2digits isic4 isic3_2digits isic3 pension_fund monthly_*
	
		compress 
		
		order ilo* , last
		   		   
	* Save dataset including original and ilo variables
	
		save ${country}_${source}_${time}_FULL, replace		
		
	*Save file only containing ilo_* variables
	
		drop if considered!=1
	
		keep ilo*

		save ${country}_${source}_${time}_ILO, replace

