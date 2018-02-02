* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Perú
* DATASET USED: Perú MLFS
* NOTES: 
* Files created: Standard variables on HS Perú
* Authors: Podjanin
* Who last updated the file: Podjanin, A.
* Starting Date: 23 May 2017
* Last updated: 23 May 2017
***********************************************************************************************



*******************************************************************
 /* 1.	Set up work directory, file name, variables and function */
*******************************************************************

clear all 

set more off

global path "J:\COMMON\STATISTICS\DPAU\MICRO"
global country "PER"
global source "HS"
global time "2014"
global inputFile "Trim Dic-Ene-Feb16"

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
	
	gen considered=1 if fa_!=.
	
*******************************************************************************************

	* generate help variable for time 
	
		gen time = "${time}"
		split time, gen(time_) parse(M)
		rename (time_1 time_2) (year month)
		destring year month, replace

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

	gen ilo_wgt=fa_
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

* Comment: Only Metropolitan area of Lima being considered --> put a note in FWK
	
		gen ilo_geo=1
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

		gen ilo_sex=p107
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

	gen ilo_age=p108 if p108!=99
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
			
		* As only age bands being kept drop "ilo_age" at the very end -> use it in between as help variable

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Level of education ('ilo_edu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: completed level of education always to be considered!

		* note that original questions only being asked to individuals aged 5+ 
		
		* take only aggregated level as both secondary and tertiary (university) education not being disaggregated
		
	gen ilo_edu_aggregate=.
		replace ilo_edu_aggregate=1 if inlist(p109a,1,2,3)
		replace ilo_edu_aggregate=2 if inlist(p109a,4,5)
		replace ilo_edu_aggregate=3 if inlist(p109a,6,7,9)
		replace ilo_edu_aggregate=4 if inlist(p109a,8,10)
		replace ilo_edu_aggregate=5 if ilo_edu_aggregate==.
			label def edu_aggr_lab 1 "1 - Less than basic" 2 "2 - Basic" 3 "3 - Intermediate" 4 "4 - Advanced" 5 "5 - Level not stated"
			label val ilo_edu_aggregate edu_aggr_lab
			label var ilo_edu_aggregate "Level of education (Aggregate levels)"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education attendance ('ilo_edu_attendance') [no info]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment:

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Disability status ('ilo_dsb_details') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment: only asked to individuals aged 14+

	if year>=2015 | (year==2014 & month!=1) {
				
	gen ilo_dsb_aggregate=.
		replace ilo_dsb_aggregate=1 if p223a1==1 | p223a2==1 | p223a3==1 | p223a4==1 | p223a5==1 | p223a6==1
		replace ilo_dsb_aggregate=2 if p223a7==1
			label def dsb_aggregate_lab 1 "Persons without disability" 2 "Persons with disability"
			label val ilo_dsb_aggregate dsb_aggregate_lab
			label var ilo_dsb_aggregate "Disability status (Aggregate)"
			
				}

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
     	 
* Comment: availability not asked to people actively seeking a job... put a note in FWK
 
	gen ilo_lfs=.
		replace ilo_lfs=1 if p201==1 | p202==1 | p203==1 | p2041==1 | p2042==1 | p2043==1 | p2044==1 | p2045==1 | p2046==1 | p2047==1 | p2048==1 | p2049==1 | p20410==1 
		replace ilo_lfs=2 if ilo_lfs!=1 & (inlist(p218,1,2,3,4,5) | inlist(p214,1,2) | p217==10)
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
		replace ilo_mjh=1 if p212e==2
		replace ilo_mjh=2 if p212e==1
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
			replace ilo_job1_ste_icse93=1 if inlist(p206,3,4,6)
			replace ilo_job1_ste_icse93=2 if p206==1
			replace ilo_job1_ste_icse93=3 if p206==2
			/* replace ilo_job1_ste_icse93=4 if */
			replace ilo_job1_ste_icse93=5 if p206==5
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
* Comment: 
	
	gen indu_code_prim=int(p205a/100) if ilo_lfs==1 
		
		* Import value labels

		append using `labels', gen (lab)
					
	* Two-digit level
		
		gen ilo_job1_eco_isic4_2digits=indu_code_prim
		
			lab values ilo_job1_eco_isic4 isic4_2digits
			lab var ilo_job1_eco_isic4_2digits "Economic activity (ISIC Rev. 4), 2 digit level"
		
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
			replace ilo_job1_eco_isic4=22 if ilo_job1_eco_isic4_2digits==. & ilo_lfs==1 
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
*			Occupation ('ilo_ocu') [check]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment:  national classification aligned with ISCO-08 according to technical document, with some supplementary categories considered:
			* link: https://www.inei.gob.pe/media/Clasificador_Nacional_de_Ocupaciones_9_de_febrero.pdf 

	* Two digit level

	gen occ_code_prim=int(p204a/10) if ilo_lfs==1
	
		* Primary occupation
	
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
				lab var ilo_job1_ocu_skill "Occupation (Skill level)"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_ins_sector') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
		
* Comment: [ley que regla empresas especiales de servicios http://www.mintra.gob.pe/contenidos/archivos/prodlab/LEY%2027626%20QUE%20REGULA%20LA%20ACT.%20DE%20LAS%20EMPRESAS%20ESPECIALES%20DE%20SERV.%20Y%20DE%20LAS%20COOP.%20DE%20TRAB.pdf ]

	* Primary occupation
	
	if year>=2015 | (year==2014 & month!=1) {
	
	gen ilo_job1_ins_sector=.
		replace ilo_job1_ins_sector=1 if inlist(p206aa,1,2,3)
		replace ilo_job1_ins_sector=2 if ilo_job1_ins_sector!=1 & ilo_lfs==1
				replace ilo_job1_ins_sector=. if ilo_lfs!=1
			lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
			lab values ilo_job1_ins_sector ins_sector_lab
			lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities" 	
			
			}

* --------------------------------------------------------------------------------------------------
* --------------------------------------------------------------------------------------------------
*		Weekly hours actually (USUALLY) worked ('ilo_how_actual') and ('ilo_how_usual') [done]
* --------------------------------------------------------------------------------------------------
* --------------------------------------------------------------------------------------------------

* Comment: only working hours for all jobs together indicated
			
	* Actual hours worked 
			
		* All jobs 
		
		gen ilo_joball_how_actual=p209t
			replace ilo_joball_how_actual=168 if ilo_joball_how_actual>168
			replace ilo_joball_how_actual=. if ilo_lfs!=1
			lab var ilo_joball_how_actual "Weekly hours actually worked in all jobs"
	
	* Hours usually worked
	
		* All jobs
		
		gen ilo_joball_how_usual=ilo_joball_how_actual
				replace ilo_joball_how_usual=p209cc if p209cc!=.
			replace ilo_joball_how_usual=168 if ilo_joball_how_usual>168
			replace ilo_joball_how_usual=. if ilo_lfs!=1
			lab var ilo_joball_how_usual "Weekly hours usually worked in all jobs" 
			
	
	* Weekly hours actually worked --> bands --> Use actual hours worked in all jobs 
		
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
				lab def how_bands_lab 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"
				lab values ilo_joball_how_actual_bands how_bands_lab
				lab var ilo_joball_how_actual_bands "Weekly hours actually worked bands in all jobs"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment: set as threshold 48 hours per week (legal maximum: http://www.mintra.gob.pe/archivos/file/faqs/PREGUNTAS_FRECUENTES_2012.pdf )

			* given unavailability of a variable considering only usual hours for first job, consider working hours for all jobs --> check with Yves
	
		gen ilo_job1_job_time=.
			replace ilo_job1_job_time=1 if ilo_joball_how_usual<48
			replace ilo_job1_job_time=2 if ilo_joball_how_usual>=48 & ilo_joball_how_usual!=.
			replace ilo_job1_job_time=3 if ilo_job1_job_time==. & ilo_lfs==1
					replace ilo_job1_job_time=. if ilo_lfs!=1
				lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
				lab val ilo_job1_job_time job_time_lab
				lab var ilo_job1_job_time "Job (Working time arrangement)"	
			
			* if there is any secondary employment, by definition it is part-time, and therefore
			* variable for secondary employment not being defined
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job_contract') [no info]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment: no info on contract type

	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Informal/Formal economy: Unit of production (ilo_job1_ife_prod) [can't be defined]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: 
	
	* Useful questions: p206aa: Institutional sector 
					*	[no info]: Destination of production 
					*	[no info]: Bookkeeping 
					*	[no info]: Registration 
					*	[no info]: Location of workplace 
					* 	p207a & p207b: Size of the establishment					
					* 	p222: Social security 
										
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Informal/formal economy: nature of job (ilo_job1_ife_nature) [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Earnings ('ilo_ear_ees' and 'ilo_ear_slf') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	
* Comment: 

	* Currency in Peru: Peruvian sol
	
	* Primary employment
	
		gen salary_prim=.
			replace salary_prim=(p211a*365/12) if p210==2
			replace salary_prim=(p211a*52/12) if p210==3
			replace salary_prim=(p211a*26/12) if p210==4
			replace salary_prim=p211a if p210==5
			
			
		gen inkind_prim=.
			replace inkind_prim=(p211b*365/12) if p210==2
			replace inkind_prim=(p211b*52/12) if p210==3
			replace inkind_prim=(p211b*26/12) if p210==4
			replace inkind_prim=p211b if p210==5
	
	* Employees
	
		egen ilo_job1_lri_ees=rowtotal(salary_prim inkind_prim),m 
			replace ilo_job1_lri_ees=. if ilo_lfs!=1 | ilo_job1_lri_ees<0
			lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"
			
	* Self-employed
	
		egen ilo_job1_lri_slf=rowtotal(p212a p212b), m 
			replace ilo_job1_lri_slf=. if ilo_lfs!=1
			lab var ilo_job1_lri_slf "Monthly labour related income of self-employed in main job"
		
	
	* Secondary employment 
		
		* can't be considered as indicated for employees and self-employed together, and not possible to distinguish them from each other
		
		drop salary_prim inkind_prim
		

***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_tru') [can't be defined]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
           
* Comment: no question on availability


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
*			Duration of unemployment ('ilo_dur') [can't be defined]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: question p221 unavailable and question p219 doesn't correspond to our needs --> variable can't be defined

	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Category of unemployment ('ilo_cat_une') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: 

	gen ilo_cat_une=.
		replace ilo_cat_une=1 if p220==1
		replace ilo_cat_une=2 if p220==2
		replace ilo_cat_une=3 if ilo_lfs==2 & ilo_cat_une==.
				replace ilo_cat_une=. if ilo_lfs!=2
			lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
			lab val ilo_cat_une cat_une_lab
			lab var ilo_cat_une "Category of unemployment"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4') [variable missing]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: variable corresponding to question p220b not included in dataset
			
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu_isco08') [variable missing]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			
* Comment: variable corresponding to question p220a not included in dataset
	
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
*			Degree of labour market attachment ('ilo_olf_dlma') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: 
	

	 gen ilo_olf_dlma=.
		/*replace ilo_olf_dlma=1 if */
		replace ilo_olf_dlma=2 if p213==2 & p215==1
		/* replace ilo_olf_dlma=3 if 
		 replace ilo_olf_dlma=4 if */
		replace ilo_olf_dlma=5 if ilo_olf_dlma==. & ilo_lfs==3
				replace ilo_olf_dlma=. if ilo_lfs!=3
			lab def lab_olf_dlma 1 "1 - Seeking, not available (Unavailable jobseekers)" 2 "2 - Not seeking, available (Available potential jobseekers)" ///
						3 "3 - Not seeking, not available, willing (Willing non-jobseekers)" 4 "4 - Not seeking, not available, not willing" 5 "5 - Not elsewhere classified"
			lab val ilo_olf_dlma lab_olf_dlma
			lab var ilo_olf_dlma "Labour market attachment (Degree of)" 
			
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reasons for not seeking a job ('ilo_olf_reason') [too many values in "not elsewhere classified"]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: too large share of observations falls into category "not elsewhere classified" --> don't keep variable 

	/* gen ilo_olf_reason=.
		replace ilo_olf_reason=1 if inlist(p217,1,2,3,4)
		replace ilo_olf_reason=2 if inlist(p217,5,6,7,8)
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

* Comment: note that question asked only to people having declared that they were available for work 

	gen ilo_dis=1 if ilo_lfs==3 & inlist(p217,1,2,4)
		lab def ilo_dis_lab 1 "Discouraged job-seekers" 
		lab val ilo_dis ilo_dis_lab
		lab var ilo_dis "Discouraged job-seekers"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training (NEETs) ('ilo_neet') [no info on educational attendance]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------


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

		drop ilo_age /* as only age bands being kept and this variable used as help variable */
		
		drop indu_code_* occ_code_*  /*prev*_cod*/  lab isco08_2digits isco88_2digits isco08 isco88 isic4_2digits isic4 isic3_2digits isic3 time year month
	
		compress 
		
		order ilo* , last
		   		   
	* Save dataset including original and ilo variables
	
		save ${country}_${source}_${time}_FULL, replace		
		
	*Save file only containing ilo_* variables
	
		keep ilo*

		save ${country}_${source}_${time}_ILO, replace

