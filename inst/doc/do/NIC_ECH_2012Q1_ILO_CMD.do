* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Nicaragua
* DATASET USED: Encuesta Continua de Hogares
* NOTES: 
* Files created: Standard variables on HS Nicaragua
* Authors: Podjanin
* Who last updated the file: Podjanin, A.
* Starting Date: 27 November 2017
* Last updated: 28 November 2017
***********************************************************************************************



*******************************************************************
 /* 1.	Set up work directory, file name, variables and function */
*******************************************************************

clear all 

set more off

global path "J:\COMMON\STATISTICS\DPAU\MICRO"
global country "NIC"
global source "ECH"
global time "2012Q1"
global inputFile "primer trimestre 2012"

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


	gen ilo_wgt=fajustexproyeccion
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
*			Geographical coverage ('ilo_geo') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: 
	
		gen ilo_geo=.
			replace ilo_geo=1 if s01p06==1
			replace ilo_geo=2 if s01p06==2
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

		gen ilo_sex=s07p09
			label define label_Sex 1 "1 - Male" 2 "2 - Female"
			label values ilo_sex label_Sex 
			lab var ilo_sex "Sex"
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: if age above 97, value 97 attributed to the individual. Also, for elder people, if age is not specified, value 98 indicated. 

	gen ilo_age=s07p10
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
*			Level of education ('ilo_edu') [not being defined]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: Adult education and "special education" (i.e. for people with disabilities) are not being classified in any particular category

	* questions asked to individuals aged 6+ 
/*
	gen ilo_edu_isced97=.
		replace ilo_edu_isced97=1 if s4p12a==0 
		replace ilo_edu_isced97=2 if s4p12a==1 | (s4p12a==3 & inrange(s4p12b,0,5))
		replace ilo_edu_isced97=3 if (s4p12a==3 & s4p12b==6) | (s4p12a==4 & inrange(s4p12b,0,2)) 
		replace ilo_edu_isced97=4 if (inlist(s4p12a,5,6,7) & inrange(s4p12b,0,2)) | (s4p12a==4 & inrange(s4p12b,3,4))
		replace ilo_edu_isced97=5 if (s4p12a==4 & s4p12b==5) | (inlist(s4p12a,5,6,7) & s4p12b>=3 & s4p12b!=.) | (s4p12a==8 & inrange(s4p12b,0,2)) | (s4p12a==9 & inrange(s4p12b,0,4))
		replace ilo_edu_isced97=6 if (s4p12a==8 & s4p12b==3)
		replace ilo_edu_isced97=7 if (s4p12a==9 & inrange(s4p12b,5,7)) | (s4p12a==10 & inrange(s4p12b,0,1))
		replace ilo_edu_isced97=8 if (s4p12a==10 & inrange(s4p12b,2,3)) | s4p12a==11
		replace ilo_edu_isced97=9 if ilo_edu_isced97==.
			label def isced_97_lab 1 "X - No schooling" 2 "0 - Pre-primary education" 3 "1 - Primary education or first stage of basic education" 4 "2 - Lower secondary education or second stage of basic education" ///
							5 "3 - Upper secondary education" 6 "4 - Post-secondary non-tertiary education" 7 "5 - First stage of tertiary education (not leading directly to an advanced research qualification)" ///
							8 "6 - Second stage of tertiary education (leading to an advanced research qualification)" 9 "UNK - Level not stated"
			label val ilo_edu_isced97 isced_97_lab
			lab var ilo_edu_isced97 "Level of education (ISCED 97)"


		* for the definition, cf. the document "Guide to reporting labour statistics to the ILO using the Excel questionnaire"
		
	gen ilo_edu_aggregate=.
		replace ilo_edu_aggregate=1 if inlist(ilo_edu_isced97,1,2)
		replace ilo_edu_aggregate=2 if inlist(ilo_edu_isced97,3,4)
		replace ilo_edu_aggregate=3 if inlist(ilo_edu_isced97,5,6)
		replace ilo_edu_aggregate=4 if inlist(ilo_edu_isced97,7,8)
		replace ilo_edu_aggregate=5 if ilo_edu_isced97==9
			label def edu_aggr_lab 1 "1 - Less than basic" 2 "2 - Basic" 3 "3 - Intermediate" 4 "4 - Advanced" 5 "5 - Level not stated"
			label val ilo_edu_aggregate edu_aggr_lab
			label var ilo_edu_aggregate "Level of education (Aggregate levels)"
*/
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education attendance ('ilo_edu_attendance') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: question asked to individuals aged 5+ 

		gen ilo_edu_attendance=.
			replace ilo_edu_attendance=1 if s07p16==1
			replace ilo_edu_attendance=2 if s07p16==2
			replace ilo_edu_attendance=3 if ilo_edu_attendance==.
				lab def edu_attendance_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
				lab val ilo_edu_attendance edu_attendance_lab
				lab var ilo_edu_attendance "Education (Attendance)"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Disability status ('ilo_dsb_details') [done]
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
     	 
* Comment: note that in the questionnaire, individuals aged 10+ are asked about their employment situation
		
 
	gen ilo_lfs=.
		replace ilo_lfs=1 if s11p01==1 | inrange(s11p02,1,9) | inrange(s11p04,1,4) | s11p05==1 | s11p06==1
		replace ilo_lfs=2 if ilo_lfs!=1 & (s11p07==1 | s11p14==1) & s11p10==1
		replace ilo_lfs=3 if !inlist(ilo_lfs,1,2)
		replace ilo_lfs=. if ilo_wap!=1	
				label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status" 				
				
				
	* Comparison of numbers: all for ilo_wap==1
		* numbers of ilo_lfs==1 and ocupado==1 match perfectly
		* for "desempleo abierto" (variable "pda"), the number of individuals having a value "1" for this variable is slightly higher than the number of individuals falling into "ilo_lfs==2"
			* --> this is related to the fact that we apply a more strict definition of unemployment, namely...
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: 

	gen ilo_mjh=.
		replace ilo_mjh=1 if s11p34==2
		replace ilo_mjh=2 if s11p34==1
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
			replace ilo_job1_ste_icse93=1 if inlist(s11p27,1,2)
			replace ilo_job1_ste_icse93=2 if s11p27==3
			replace ilo_job1_ste_icse93=3 if s11p27==4
			replace ilo_job1_ste_icse93=4 if s11p27==5
			replace ilo_job1_ste_icse93=5 if inlist(s11p27,6,7)
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
					
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: 

	gen indu_code_prim=int(s11p26/100) if ilo_lfs==1 & !inlist(s11p26,9998,9999)	
		replace indu_code_prim=99 if indu_code_prim==98
		
		append using `labels', gen (lab)
		
		* Primary activity
		
		gen ilo_job1_eco_isic3_2digits=indu_code_prim
		
			lab values ilo_job1_eco_isic3 isic3_2digits
			lab var ilo_job1_eco_isic3_2digits "Economic activity (ISIC Rev. 3.1), 2 digit level"
		
	* One digit level
	
		* Primary activity
		
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
* Comment: ISCO-88 classification used

	* Two digit level

	gen occ_code_prim=int(s11p24/100) if ilo_lfs==1 & !inlist(s11p24,9998,9999)
		
		* Primary occupation
		
		gen ilo_job1_ocu_isco88_2digits=occ_code_prim
			lab values ilo_job1_ocu_isco88_2digits isco88_2digits
			lab var ilo_job1_ocu_isco88_2digits "Occupation (ISCO-88), 2 digit level"
			
	* 1 digit level
	
	gen occ_code_prim_1dig=int(occ_code_prim/10) if ilo_lfs==1
	
		* Primary activity
		
		* ISCO 88 - 1 digit
		
			gen ilo_job1_ocu_isco88=.
				replace ilo_job1_ocu_isco88=occ_code_prim_1dig 
				replace ilo_job1_ocu_isco88=10 if ilo_job1_ocu_isco88==0
				replace ilo_job1_ocu_isco88=11 if ilo_job1_ocu_isco88==. & ilo_lfs==1
						replace ilo_job1_ocu_isco88=. if ilo_lfs!=1
					lab def isco88_1dig_lab 1 "1 - Legislators, senior officials and managers" 2 "2 - Professionals" 3 "3 - Technicians and associate professionals" 4 "4 - Clerks" ///
											5 "5 - Service workers and shop and market sales workers" 6 "6 - Skilled agricultural and fishery workers" 7 "7 - Craft and related trades workers" ///
											8 "8 - Plant and machine operators, and assemblers" 9 "9 - Elementary occupations" 10 "0 - Armed forces" 11 "X - Not elsewhere classified"
					lab val ilo_job1_ocu_isco88 isco88
					lab var ilo_job1_ocu_isco88 "Occupation (ISCO-88) - Main job"	

		* Aggregate	
		
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
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_ins_sector') [no info]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
		
* Comment: check with Yves (zone franche)

	gen ilo_job1_ins_sector=.
		replace ilo_job1_ins_sector=1 if inlist(s11p29,1,2,4,9)
		replace ilo_job1_ins_sector=2 if ilo_job1_ins_sector==. & ilo_lfs==1
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

	* Hours actually worked
	
	* Main job
	
		gen ilo_job1_how_actual=s11p39a if !inlist(s11p39a,998,999) 
			replace ilo_job1_how_actual=168 if ilo_job1_how_actual>168 & ilo_job1_how_actual!=.
			replace ilo_job1_how_actual=. if ilo_lfs!=1
			lab var ilo_job1_how_actual "Weekly hours actually worked in main job"
			
		* Secondary job 
		
		gen ilo_job2_how_actual=s11p39b if !inlist(s11p39b,998,999)  
			replace ilo_job2_how_actual=168 if ilo_job2_how_actual>168 & ilo_job2_how_actual!=.
			replace ilo_job2_how_actual=. if ilo_mjh!=2
			lab var ilo_job2_how_actual "Weekly hours actually worked in secondary job"
			
		* All jobs
		
		egen ilo_joball_how_actual=rowtotal(ilo_job*_how_actual), m
			replace ilo_joball_how_actual=168 if ilo_joball_how_actual>168 & ilo_joball_how_actual!=.
			replace ilo_joball_how_actual=. if ilo_lfs!=1
			lab var ilo_joball_how_actual "Weekly hours actually worked in all jobs"				
	
	* Hours usually worked
	
		* Main job
	
		gen ilo_job1_how_usual=ilo_job1_how_actual if s11p40==1
			replace ilo_job1_how_usual=s11p41a if ilo_job1_how_usual==.
			replace ilo_job1_how_usual=168 if ilo_job1_how_usual>168 & ilo_job1_how_usual!=.
			replace ilo_job1_how_usual=. if ilo_lfs!=1
			lab var ilo_job1_how_usual "Weekly hours usually worked in main job"
			
		* Secondary job 
		
		gen ilo_job2_how_usual=ilo_job2_how_actual if s11p40==1
			replace ilo_job2_how_usual=s11p41b if ilo_job2_how_usual==.
			replace ilo_job2_how_usual=168 if ilo_job2_how_usual>168 & ilo_job2_how_usual!=.
			replace ilo_job2_how_usual=. if ilo_mjh!=2
			lab var ilo_job2_how_usual "Weekly hours usually worked in secondary job"
			
		* All jobs
		
		egen ilo_joball_how_usual=rowtotal(ilo_job*_how_usual), m
			replace ilo_joball_how_usual=168 if ilo_joball_how_usual>168 & ilo_joball_how_usual!=.
			replace ilo_joball_how_usual=. if ilo_lfs!=1
			lab var ilo_joball_how_usual "Weekly hours usually worked in all jobs"	
			
			
	* Weekly hours actually worked --> bands 
	
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
			* value labels already defined
			lab values ilo_joball_how_actual_bands how_bands_lab
			lab var ilo_joball_how_actual_bands "Weekly hours actually worked bands in all jobs"
	
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment: set 40 hours per week as threshold 

		gen ilo_job1_job_time=.
			replace ilo_job1_job_time=1 if ilo_job1_how_usual<40
			replace ilo_job1_job_time=2 if ilo_job1_how_usual>=40 & ilo_job1_how_usual!=. 
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
		replace ilo_job1_job_contract=1 if inlist(s11p31,1,3)
		replace ilo_job1_job_contract=2 if inlist(s11p31,2,4)
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
* Comment: 

	  * Useful questions: s11p29: Institutional sector 
						* [no info]: Destination of production 
						* s11p32: Bookkeeping
						* [no info]: Registration
						* s11p33a: Social security
						* s11p28: Location of workplace
						* s11p33: Size of enterprise
										
	
	gen ilo_job1_ife_prod=.
		replace ilo_job1_ife_prod=1 if 
		replace ilo_job1_ife_prod=2 if (b5_r35!=3 & inlist(b5_r28,2,3)) | (b5_r35!=3 & !inlist(b5_r28,1,2,3) & ilo_job1_ste_aggregate==1 & soc_sec==1)
		replace ilo_job1_ife_prod=3 if b5_r35==3 
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
		replace ilo_job1_ife_nature=1 if ilo_job1_ste_icse93==5 | (inlist(ilo_job1_ste_icse93,1,6) & soc_sec!=1) | (inlist(ilo_job1_ste_icse93,2,3,4) & inlist(ilo_job1_ife_prod,1,3))
		replace ilo_job1_ife_nature=2 if (inlist(ilo_job1_ste_icse93,1,6) & soc_sec==1) | (inlist(ilo_job1_ste_icse93,2,3,4) & ilo_job1_ife_prod==2)
		replace ilo_job1_ife_nature=. if ilo_lfs!=1
			lab def ife_nature_lab 1 "1 - Persons with informal main job" 2 "2 - Persons with formal main job"
			lab val ilo_job1_ife_nature ife_nature_lab
			lab var ilo_job1_ife_nature "Informal / Formal Economy (Nature of job)"

		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Earnings ('ilo_ear_ees' and 'ilo_ear_slf') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	
* Comment: section on labour gives only info about employees' revenue

	* Currency in Nicaragua: Nicaraguan córdoba
	
		gen aguinaldo=.
		
		
		gen bono=.
		
		
		gen vacaciones=.
		
	* Employees
	
		egen ilo_job1_lri_ees=rowtotal(s12p49_1p02 s12p49_1p03 s12p49_1p04 s12p49_1p05 s12p49_1p06 s12p49_1p07 s12p49_1p08 s12p49_1p09 aguinaldo bono vacaciones),  m
			replace ilo_job1_lri_ees=. if ilo_job1_ste_aggregate!=1 | ilo_job1_lri_ees<0
			lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"	
			
	* Self-employed 
	
	
		gen self_emp_inc_month=.
			replace self_emp_inc_month=s5p26a*(365/12) if s5p26b==1 & !inlist(s5p26a,9999998,9999999)
			replace self_emp_inc_month=s5p26a*(52/12) if s5p26b==2 & !inlist(s5p26a,9999998,9999999)
			replace self_emp_inc_month=s5p26a*(24/12) if s5p26b==3 & !inlist(s5p26a,9999998,9999999)
			replace self_emp_inc_month=s5p26a*(26/12) if s5p26b==4 & !inlist(s5p26a,9999998,9999999)
			replace self_emp_inc_month=s5p26a if s5p26b==5 & !inlist(s5p26a,9999998,9999999)
			replace self_emp_inc_month=s5p26a/3 if s5p26b==6 & !inlist(s5p26a,9999998,9999999)
			replace self_emp_inc_month=s5p26a/6 if s5p26b==7 & !inlist(s5p26a,9999998,9999999)
			replace self_emp_inc_month=s5p26a/12 if s5p26b==8 & !inlist(s5p26a,9999998,9999999)
	
	
		gen ilo_job1_lri_slf=self_emp_inc_month
			replace ilo_job1_lri_slf=. if ilo_job1_ste_aggregate!=2
			lab var ilo_job1_lri_slf "Monthly labour related income of self-employed in main job"
		

***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_tru') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
           
* Comment: can't be defined

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
*			Duration of unemployment ('ilo_dur') [no info]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: 

	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Category of unemployment ('ilo_cat_une') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: 

	gen ilo_cat_une=.
		replace ilo_cat_une=1 if s5p12==1
		replace ilo_cat_une=2 if s5p12==2
		replace ilo_cat_une=3 if ilo_lfs==2 & ilo_cat_une==.
				replace ilo_cat_une=. if ilo_lfs!=2
			lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
			lab val ilo_cat_une cat_une_lab
			lab var ilo_cat_une "Category of unemployment"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4') [no info]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: no info (only about employment during last 12 months)
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu_isco08') [no info]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			
* Comment: idem as for preveco
	
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
*			Degree of labour market attachment ('ilo_olf_dlma') [don't keep]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: too high share falling in category "not elsewhere classified" --> don't keep
/*
	 gen ilo_olf_dlma=.
		replace ilo_olf_dlma=1 if !inlist(s5p8a,9,.) & s5p11==2
		replace ilo_olf_dlma=2 if inlist(s5p8a,9,.) & s5p11==1
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
		replace ilo_olf_reason=1 if inlist(s5p9,4,5,10,12)
		replace ilo_olf_reason=2 if inlist(s5p9,2,3)
		replace ilo_olf_reason=3 if inlist(s5p9,6,7,8,9,11,13,14)
		/* replace ilo_olf_reason=4 if */
		replace ilo_olf_reason=5 if ilo_olf_reason==. & ilo_lfs==3
			replace ilo_olf_reason=. if ilo_lfs!=3
			lab def lab_olf_reason 1 "1 - Labour market (discouraged)" 2 "2 - Other labour market reasons" 3 "3 - Personal/Family-related"  4 "4 - Does not need/want to work" 5 "5 - Not elsewhere classified"
			lab val ilo_olf_reason lab_olf_reason
			lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"
			

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seekers ('ilo_dis') [done]
* -------------------------------------------------------------------------------------------
* ------------------------------------------------------------------------------------------- 

* Comment: 

	gen ilo_dis=1 if ilo_lfs==3 & ilo_olf_reason==1 & s5p11==1
		lab def ilo_dis_lab 1 "Discouraged job-seekers" 
		lab val ilo_dis ilo_dis_lab
		lab var ilo_dis "Discouraged job-seekers"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training (NEETs) ('ilo_neet') [done]
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
	
		drop if lab==1 /* in order to get rid of observations from tempfile */

		drop indu_code_* occ_code_*  /* prev*_cod */  lab isco08_2digits isco88_2digits isco08 isco88 isic4_2digits isic4 isic3_2digits isic3 salary_month self_emp_inc_month 
	
		compress 
		
		order ilo* , last
		   		   
	* Save dataset including original and ilo variables
	
		save ${country}_${source}_${time}_FULL, replace		
		
	*Save file only containing ilo_* variables
	
		drop if ilo_wgt==.
	
		keep ilo*

		save ${country}_${source}_${time}_ILO, replace

