* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Guatemala, March 2016
* DATASET USED: Guatemala LFS Q1 2016
* NOTES: 
* Files created: Standard variables on LFS Guatemala 2016 Q1
* Authors: Podjanin
* Who last updated the file: Podjanin, A.
* Starting Date: 25 October 2016
* Last updated: 26 October 2016
***********************************************************************************************



*******************************************************************
 /* 1.	Set up work directory, file name, variables and function */
*******************************************************************

clear all 

set more off

global path "J:\COMMON\STATISTICS\DPAU\MICRO"
global country "GTM"
global source "ENEI"
global time "2015Q4"
global inputFile "Personas - Noviembre 2015 - ENEI.dta"

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

	gen ilo_wgt=factor
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
	gen ilo_geo=.
		replace ilo_geo=1 if inlist(dominio,1,2)
		replace ilo_geo=2 if dominio==3
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

		gen ilo_sex=ppa02
			label define label_Sex 1 "1 - Male" 2 "2 - Female"
			label values ilo_sex label_Sex
			lab var ilo_sex "Sex"


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: Age above 97 not indicated, highest value corresponds to "97 y más (97 and more)"

	gen ilo_age=ppa03
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
* Comment: Given the definition of the levels of education, ISCED97 is being chosen
			* centro de alfabetización --> included among "primary education" (cf. definition on page 23: http://www.uis.unesco.org/Library/Documents/isced97-en.pdf ) 
			
			* Note that according to the definition, the highest level being CONCLUDED is being considered
			
			* Info on educational system: http://www.classbase.com/countries/Guatemala/Education-System 


	gen ilo_edu_isced97=.
		replace ilo_edu_isced97=1 if p03a05a==0
		replace ilo_edu_isced97=2 if p03a05a==1 | (p03a05a==2 & inrange(p03a05b,0,5))
		replace ilo_edu_isced97=3 if (p03a05a==2 & p03a05b==6) | (p03a05a==3 & inrange(p03a05b,0,2))
		replace ilo_edu_isced97=4 if (p03a05a==3 & p03a05b==3) | (p03a05a==4 & inrange(p03a05b,0,5))
		replace ilo_edu_isced97=5 if (p03a05a==4 & inlist(p03a05b,6,7)) | (p03a05a==5 & inrange(p03a05b,0,3))
		/* replace ilo_edu_isced97=6 if */
		replace ilo_edu_isced97=7 if p03a05a==5 & inrange(p03a05b,4,6)
		replace ilo_edu_isced97=8 if inlist(p03a05a,6,7)
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
			replace ilo_edu_attendance=1 if p03a02==1
			replace ilo_edu_attendance=2 if p03a02==2
			replace ilo_edu_attendance=3 if ilo_edu_attendance==.
				lab def edu_attendance_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
				lab val ilo_edu_attendance edu_attendance_lab
				lab var ilo_edu_attendance "Education (Attendance)"		
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Disability status ('ilo_dsb_details') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment: * Question only being asked to persons aged 7 or more
	/*		
	gen ilo_dsb_aggregate=.
		replace ilo_dsb_aggregate=1 if !inlist(p04a02,8,.)
		replace ilo_dsb_aggregate=2 if p04a02==8
			lab def dsb_aggr_lab 1 "Persons without disability" 2 "Persons with disability"
			lab val ilo_dsb_aggregate dsb_aggr_lab
			lab var ilo_dsb_aggregate "Disability status (Aggregate)" */
			
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
*            	 
* Comment: 	Absence from job - threshold set at one month - if absent up to a month, person still considered as employed --> if more, sent further to section about unemployment

			* Questions asked allow to follow the international definition of unemployment (such as described in technical document)
	
 	gen ilo_lfs=.
		replace ilo_lfs=1 if p04a02==1 | p04a03==1 | p04a04==1 | p04a05==1 | inrange(p04a07,1,5) | p04a08==1 | inlist(p04a09,1,2) 
		replace ilo_lfs=2 if (p04b03!=. & p04b05==2) | inlist(p04b04,1,2)
		replace ilo_lfs=3 if inrange(p04b04,3,98) | p04b05==1 | (ilo_lfs==. & ilo_wap==1)
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
		replace ilo_mjh=1 if p04c01==1
		replace ilo_mjh=2 if inlist(p04c01,2,3)
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
			replace ilo_job1_ste_icse93=1 if inlist(p04c06,1,2,3,4)
			replace ilo_job1_ste_icse93=2 if inlist(p04c06,5,6,7,8) & p04c24a==1
			replace ilo_job1_ste_icse93=3 if inlist(p04c06,5,6,7,8) & p04c24a!=1 
			/* replace ilo_job1_ste_icse93=4 if */
			replace ilo_job1_ste_icse93=5 if p04c06==9
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
				replace ilo_job2_ste_icse93=1 if inlist(p04d05,1,2,3,4)
				replace ilo_job2_ste_icse93=2 if inlist(p04d05,5,6,7,8) & p04d14a==1
				replace ilo_job2_ste_icse93=3 if inlist(p04d05,5,6,7,8) & p04d14a!=1
				/* replace ilo_job2_ste_icse93=4 if */
				replace ilo_job2_ste_icse93=5 if p04d05==9
				replace ilo_job2_ste_icse93=6 if ilo_job2_ste_icse93==. & ilo_lfs==1 & ilo_mjh==2
					replace ilo_job2_ste_icse93=. if ilo_lfs!=1
				* value labels already defined
				label val ilo_job2_ste_icse93 label_ilo_ste_icse93
				label var ilo_job2_ste_icse93 "Status in employment (ICSE 93) in secondary job"

			* Aggregate categories
		
			gen ilo_job2_ste_aggregate=.
				replace ilo_job2_ste_aggregate=1 if ilo_job2_ste_icse93==1
				replace ilo_job2_ste_aggregate=2 if inlist(ilo_job2_ste_icse93,2,3,4)
				replace ilo_job2_ste_aggregate=3 if inlist(ilo_job2_ste_icse93,5,6)
					*value labels already defined
					lab val ilo_job2_ste_aggregate ste_aggr_lab
				label var ilo_job2_ste_aggregate "Status in employment (Aggregate) in secondary job" 
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: ISIC Rev. 4 being used 

	* economic activity indicated both for primary and secondary activity 

	gen indu_code_prim=p04c04b_2d if ilo_lfs==1
	
	gen indu_code_sec=p04d04b_2d if ilo_lfs==1 & ilo_mjh==2
	
		* Import value labels

		append using `labels', gen (lab)
					
		* Primary activity
		
		gen ilo_job1_eco_isic4_2digits=indu_code_prim
		
			lab values ilo_job1_eco_isic4 isic4_2digits
			lab var ilo_job1_eco_isic4_2digits "Economic activity (ISIC Rev. 4), 2 digit level"
			
		* Secondary activity
		
		gen ilo_job2_eco_isic4_2digits=indu_code_sec
		
			lab values ilo_job2_eco_isic4 isic4_2digits
			lab var ilo_job2_eco_isic4_2digits "Economic activity (ISIC Rev. 4), 2 digit level in secondary job"
	
	* One digit level
	
		* aggregation done according to information on page 43 of the following document: https://www.bundesbank.de/Redaktion/EN/Downloads/Service/Meldewesen/Bankenstatistik/Kundensystematik/isic_rev_4.pdf?__blob=publicationFile
	
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
					replace ilo_job1_eco_isic4=22 if ilo_job1_eco_isic4==. & ilo_lfs==1
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
				lab val ilo_job1_eco_isic4 isic4
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
* Comment: Indicate both for primary and secondary activity

		* Classification used - ISCO-08

	gen occ_code_prim=p04c02b_2d if ilo_lfs==1
	gen occ_code_sec=p04d02b_2d if ilo_lfs==1 & ilo_mjh==2
		
* 2 digit level
	
		* Primary occupation
		
		gen ilo_job1_ocu_isco08_2digits=occ_code_prim
				replace ilo_job1_ocu_isco08_2digits=. if ilo_lfs!=1
			lab values ilo_job1_ocu_isco08_2digits isco08_2digits
			lab var ilo_job1_ocu_isco08_2digits "Occupation (ISCO-08), 2 digit level"
			
		* Secondary occupation
	
		gen ilo_job2_ocu_isco08_2digits=occ_code_sec
			lab values ilo_job2_ocu_isco08_2digits isco08_2digits
			lab var ilo_job2_ocu_isco08_2digits "Occupation (ISCO-08), 2 digit level - secondary job"
		
	* 1 digit level
	
	gen occ_code_prim_1dig=int(occ_code_prim/10) if ilo_lfs==1
	gen occ_code_sec_1dig=int(occ_code_sec/10) if ilo_lfs==1 & ilo_mjh==2
	
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
			
		* Secondary activity
		
			
		gen ilo_job2_ocu_isco08=occ_code_sec_1dig
			replace ilo_job2_ocu_isco08=10 if ilo_job2_ocu_isco08==0
			replace ilo_job2_ocu_isco08=11 if ilo_job2_ocu_isco08==. & ilo_lfs==1 & ilo_mjh==2
				replace ilo_job2_ocu_isco08=. if ilo_lfs!=1
			* value labels already defined
			lab val ilo_job2_ocu_isco08 isco08_1dig_lab
			lab var ilo_job2_ocu_isco08 "Occupation (ISCO-08) in secondary occupation"
			
			
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
				
		* Secondary occupation
		
		
		gen ilo_job2_ocu_aggregate=.
			replace ilo_job2_ocu_aggregate=1 if inrange(ilo_job2_ocu_isco08,1,3)
			replace ilo_job2_ocu_aggregate=2 if inlist(ilo_job2_ocu_isco08,4,5)
			replace ilo_job2_ocu_aggregate=3 if inlist(ilo_job2_ocu_isco08,6,7)
			replace ilo_job2_ocu_aggregate=4 if ilo_job2_ocu_isco08==8
			replace ilo_job2_ocu_aggregate=5 if ilo_job2_ocu_isco08==9
			replace ilo_job2_ocu_aggregate=6 if ilo_job2_ocu_isco08==10
			replace ilo_job2_ocu_aggregate=7 if ilo_job2_ocu_isco08==11
				* value labels already defined
				lab val ilo_job2_ocu_aggregate ocu_aggr_lab
				lab var ilo_job2_ocu_aggregate "Occupation (Aggregate) in secondary job"
						
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_ins_sector') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
		
* Comment: consider separately for primary and secondary activity
	
	* Primary occupation
	
	gen ilo_job1_ins_sector=.
		replace ilo_job1_ins_sector=1 if p04c06==1
		replace ilo_job1_ins_sector=2 if inrange(p04c06,2,9) | (ilo_job1_ins_sector==. & ilo_lfs==1)
				replace ilo_job1_ins_sector=. if ilo_lfs!=1
			lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
			lab values ilo_job1_ins_sector ins_sector_lab
			lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities"
			
	* Secondary occupation

	gen ilo_job2_ins_sector=.
		replace ilo_job2_ins_sector=1 if p04d05==1
		replace ilo_job2_ins_sector=2 if inrange(p04d05,2,9)
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
* Comment: consider first working time associated with each job (if available) and then consider the sum (i.e.
				* the time dedicated to all working activities during the week
				
	* Actual hours worked are not being indicated
	
	* Hours usually worked
	
		* All jobs - i.e. hours dedicated to primary and secondary employment
		
	egen ilo_job1_how_usual=rowtotal(p04c28a p04c28b p04c28c p04c28d p04c28e p04c28f p04c28g), m
		replace ilo_job1_how_usual=. if ilo_lfs!=1
		lab var ilo_job1_how_usual "Weekly hours usually worked in main job"
		
	gen ilo_job2_how_usual=p04d16
		replace ilo_job2_how_usual=. if ilo_lfs!=1 & ilo_mjh!=2
		lab var ilo_job2_how_usual "Weekly hours usually worked in secondary job"		
	
	egen ilo_joball_how_usual=rowtotal(ilo_job1_how_usual ilo_job2_how_usual), m
		replace ilo_joball_how_usual=. if ilo_lfs!=1
		lab var ilo_joball_how_usual "Weekly hours usually worked in all jobs"
		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment: time usually dedicated to the primary activity being considered
	
	gen ilo_job1_job_time=.
		replace ilo_job1_job_time=1 if ilo_job1_how_usual<=43 & ilo_job1_how_usual!=.
		replace ilo_job1_job_time=2 if ilo_job1_how_usual>=44 & ilo_job1_how_usual!=.
		replace ilo_job1_job_time=3 if ilo_job1_how_usual==. & ilo_lfs==1
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
	
* Comment: variable only defined for primary employment, as question on the nature of the contract
	*		is not being asked for secondary employment
	
	gen ilo_job1_job_contract=.
		replace ilo_job1_job_contract=1 if p04c08a==1
		replace ilo_job1_job_contract=2 if p04c08a==2
		replace ilo_job1_job_contract=3 if p04c07==2 | (ilo_job1_job_contract==. & ilo_lfs==1)
				replace ilo_job1_job_contract=. if ilo_lfs!=1
			lab def job_contract_lab 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"
			lab val ilo_job1_job_contract job_contract_lab
			lab var ilo_job1_job_contract "Job (Type of contract)"
			
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Informal/Formal economy: Unit of production (ilo_job1_ife_prod) [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* 
* Comment:  --> no information about bookkeeping and registration available...!


	* Useful questions: p04c06: Status in employment / Institutional sector
					*	[no info]: Destination of production
					*	[no info]: Bookkeeping
					*	[no info]: Registration
					*	p04c25a: Social security (IGSS)
					*	p04c27: Location of workplace 
					*	p04c05: Size of the establishment
					
	
	gen ilo_job1_ife_prod=.
		replace ilo_job1_ife_prod=1 if !inlist(p04c06,1,4) & ((ilo_job1_ste_aggregate==1 & p04c25a!=1) | ilo_job1_ste_aggregate!=1) & (!inlist(p04c27,1,3) | (inlist(p04c27,1,3) & p04c05<=5))
		replace ilo_job1_ife_prod=2 if p04c06==1 | (!inlist(p04c06,1,4) & ilo_job1_ste_aggregate==1 & p04c25a==1) | ///
				(!inlist(p04c06,1,4) & ((ilo_job1_ste_aggregate==1 & p04c25a!=1) | ilo_job1_ste_aggregate!=1) & inlist(p04c27,1,3) & p04c05>=6 & p04c05!=.)
		replace ilo_job1_ife_prod=3 if p04c06==4 | ilo_job1_ocu_isco08_2digits==63 | ilo_job1_eco_isic4_2digits==97
		replace ilo_job1_ife_prod=4 if ilo_job1_ife_prod==. & ilo_lfs==1
				replace ilo_job1_ife_prod=. if ilo_lfs!=1
			lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 4 "4 - Not elsewhere classified"
			lab val ilo_job1_ife_prod ilo_ife_prod_lab
			lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"
			
	
		* National definition:    'formal_informal'		
		
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Informal/formal economy: nature of job (ilo_job1_ife_nature) [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: 

	gen ilo_job1_ife_nature=.
		replace ilo_job1_ife_nature=1 if ilo_job1_ste_icse93==5 | (inlist(ilo_job1_ste_icse93,1,6) & p04c25a!=1) | (inlist(ilo_job1_ste_icse93,2,3,4) & inlist(ilo_job1_ife_prod,1,3))
		replace ilo_job1_ife_nature=2 if (inlist(ilo_job1_ste_icse93,1,6) & p04c25a==1) | (inlist(ilo_job1_ste_icse93,2,3,4) & ilo_job1_ife_prod==2)
		replace ilo_job1_ife_nature=. if ilo_lfs!=1
			lab def ife_nature_lab 1 "1 - Persons with informal main job" 2 "2 - Persons with formal main job"
			lab val ilo_job1_ife_nature ife_nature_lab
			lab var ilo_job1_ife_nature "Informal / Formal Economy (Nature of job)"
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Earnings ('ilo_ear_ees' and 'ilo_ear_slf')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	
* Comment: Classify earnings according to the occupation (i.e. primary and secondary) 
	
	*Currency in Guatemala: Quetzales
	
			* note that some values indicated on an annual level - divide them by 12 in order to get the average
	
	* Primary employment
	
			* Monthly earnings of employees
			
				* obtain monthly values of some variables
				
		foreach var of varlist p04c13b p04c14b p04c15b p04c16b p04c17b p04c21b {
		
			gen month_`var'=`var'/12
			 }	
				
		egen ilo_job1_lri_ees=rowtotal(p04c10 p04c11c p04c12b month_p04c13b month_p04c14b month_p04c15b month_p04c16b month_p04c17b p04c18b p04c19b p04c20b month_p04c21b),m 
			replace ilo_job1_lri_ees=. if ilo_lfs!=1
			lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"
			
			* Self employment
		
		* note that the revenue related to self-employment includes also the value of own consumption 
			* (cf. resolution from 1998)
			
			gen month_p04c23=p04c23/12
			
		egen ilo_job1_lri_slf=rowtotal(p04c22 month_p04c23), m
			replace ilo_job1_lri_slf=. if ilo_lfs!=1
			lab var ilo_job1_lri_slf "Monthly labour related income of self-employed in main job"
				
	* Secondary employment
	
		* Earnings of employees 
			
			foreach var of varlist p04d08b p04d10b p04d11b {
		
			gen month_`var'=`var'/12
			}	
				
			egen ilo_job2_lri_ees=rowtotal(p04d06 p04d07b month_p04d08b p04d09b month_p04d10b month_p04d11b), m
					replace ilo_job2_lri_ees=. if ilo_lfs!=1 & ilo_mjh!=2
				lab var ilo_job2_lri_ees "Monthly earnings of employees in secondary job"
			
		* Self-employment
			
			gen month_p04d13=p04d13/12
			
			egen ilo_job2_lri_slf=rowtotal(p04d12 month_p04d13), m
					replace ilo_job2_lri_slf=. if ilo_lfs!=1 & ilo_mjh!=2
				lab var ilo_job2_lri_slf "Monthly labour related income of self-employed in secondary job"
	

***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************						
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_tru') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*                
* Comment: National threshold for full-time employment set at 45 hours --> Código del Trabajo de Guatemala (http://www.ilo.org/dyn/natlex/docs/WEBTEXT/29402/73185/S95GTM01.htm#t3 )

	gen ilo_joball_tru=1 if ilo_joball_how_usual<45 & p04e01==1 & p04e05==1
		replace ilo_joball_tru=. if ilo_lfs!=1
		lab def tru_lab 1 "Time-related underemployment"
		lab val ilo_joball_tru tru_lab
		lab var ilo_joball_tru "Time-related underemployment"

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
* Comment:	Variable p04f01 indicates number of weeks spent looking for a job

	
	gen ilo_dur_details=.
		replace ilo_dur_details=1 if inrange(p04f01,0,4)
		replace ilo_dur_details=2 if inrange(p04f01,5,13)
		replace ilo_dur_details=3 if inrange(p04f01,14,26)
		replace ilo_dur_details=4 if inrange(p04f01,27,52)
		replace ilo_dur_details=5 if inrange(p04f01,53,96)
		replace ilo_dur_details=6 if p04f01==97
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
*			Category of unemployment ('ilo_cat_une') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment:
	
	gen ilo_cat_une=.
		replace ilo_cat_une=1 if p04f06==2
		replace ilo_cat_une=2 if p04f06==1
		replace ilo_cat_une=3 if ilo_cat_une==. & ilo_lfs==2
				replace ilo_cat_une=. if ilo_lfs!=2
			lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
			lab val ilo_cat_une cat_une_lab
			lab var ilo_cat_une "Category of unemployment"
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: ISIC Rev. 4 classification being used - keep only one digit level

		capture confirm var p04f09b_2d 
	
	if !_rc {
	
	gen preveco_cod=p04f09b_2d if ilo_cat_une==1
	
		}
		
	else {

		gen preveco_cod=p04f09b if ilo_lfs==2
		
		}
		
			* keep this variable on the two digit level, in order to be able to correctly execute the code below
	
	* aggregation done according to information on page 43 of the following document: https://www.bundesbank.de/Redaktion/EN/Downloads/Service/Meldewesen/Bankenstatistik/Kundensystematik/isic_rev_4.pdf?__blob=publicationFile
	
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
			replace ilo_preveco_isic4=22 if preveco_cod==. & ilo_cat_une==1
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
	
	capture confirm var p04f07b_2d 
	
	if !_rc {
	
	gen prevocu_cod=int(p04f07b_2d/10) if ilo_cat_une==1
	
		}
		
	else {
	
	gen prevocu_cod=int(p04f07b/10) if ilo_cat_une==1
	
		}	
	
	gen ilo_prevocu_isco08=prevocu_cod
		replace ilo_prevocu_isco08=10 if ilo_prevocu_isco08==0
		replace ilo_prevocu_isco08=11 if ilo_prevocu_isco08==. & ilo_cat_une==1 & ilo_lfs==2
		* value label already defined
		lab val ilo_prevocu_isco08 isco08_1dig_lab
		lab var ilo_prevocu_isco08 "Previous occupation (ISCO-08)"
			
	* Aggregate level 
	
	gen ilo_prevocu_aggregate=.
		replace ilo_prevocu_aggregate=1 if inrange(ilo_prevocu_isco08,1,3)
		replace ilo_prevocu_aggregate=2 if inlist(ilo_prevocu_isco08,4,5)
		replace ilo_prevocu_aggregate=3 if inlist(ilo_prevocu_isco08,6,7)
		replace ilo_prevocu_aggregate=4 if ilo_prevocu_isco08==8
		replace ilo_prevocu_aggregate=5 if ilo_prevocu_isco08==9
		replace ilo_prevocu_aggregate=6 if ilo_prevocu_isco08==10
		replace ilo_prevocu_aggregate=7 if ilo_prevocu_isco08==11
			* value label already defined
			lab val ilo_prevocu_aggregate ocu_aggr_lab
			lab var ilo_prevocu_aggregate "Previous occupation (Aggregate)"	
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Unemployment benefits schemes ('ilo_soc_aggregate') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: info available whether person receives any unemployment benefit, but no classification according 
			* to source of this revenue...

	/* gen ilo_soc_aggregate=.
		replace ilo_soc_aggregate=1 if
		replace ilo_soc_aggregate=2 if
			lab def soc_aggr_lab 1 "From insurance" 2 "From assistance"
			lab val ilo_soc_aggregate soc_aggr_lab 
			lab var ilo_soc_aggregate "Unemployment benefit schemes" */
			
***********************************************************************************************
*			PART 3.4. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************	

	
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: Degree of labour market attachment of persons outside the labour force

	* p04g02: associated with the question “If someone had offered you a job last week, would you have accepted it?”
		*(“¿Si le hubieran ofrecido un trabajo la semana pasada lo hubiera aceptado?”), being only asked to people outside 
		* the labour force (inactive population) is being used as a proxy

	gen ilo_olf_dlma=.
		replace ilo_olf_dlma=1 if (p04b01==1 | p04b02==1) & p04b05==1
		replace ilo_olf_dlma=2 if (p04b01==2 | p04b02==2) & p04b05==2
		replace ilo_olf_dlma=3 if (p04b01==2 | p04b02==2) & p04b05==1 & p04g02==1
		replace ilo_olf_dlma=4 if (p04b01==2 | p04b02==2) & p04b05==1 & p04g02==2
		replace ilo_olf_dlma=5 if ilo_olf_dlma==. & ilo_lfs==3
				replace ilo_olf_dlma=. if ilo_lfs!=3
			lab def lab_olf_dlma 1 "1 - Seeking, not available (Unavailable jobseekers)" 2 "2 - Not seeking, available (Available potential jobseekers)" ///
						3 "3 - Not seeking, not available, willing (Willing non-jobseekers)" 4 "4 - Not seeking, not available, not willing" 5 "5 - Not elsewhere classified"
			lab val ilo_olf_dlma lab_olf_dlma
			lab var ilo_olf_dlma "Labour market attachment (Degree of)"			
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reasons for not seeking a job ('ilo_olf_reason') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment:
	
		gen ilo_olf_reason=.
		replace ilo_olf_reason=1 if inlist(p04b04,3,4,5,6,7,8,9,10)
		replace ilo_olf_reason=2 if inlist(p04b04,11,12,13,14,15,16,17,18)
		/* replace ilo_olf_reason=3 if */
		replace ilo_olf_reason=4 if ilo_olf_reason==. & ilo_lfs==3
			replace ilo_olf_reason=. if ilo_lfs!=3
			lab def lab_olf_reason 1 "1 - Labour market" 2 "2 - Personal/Family-related"  3 "3 - Does not need/want to work" 4 "4 - Not elsewhere classified"
			lab val ilo_olf_reason lab_olf_reason
			lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seekers ('ilo_disc') [done]
* -------------------------------------------------------------------------------------------
* ------------------------------------------------------------------------------------------- 
*
* Comment: 	

		gen ilo_dis=1 if ilo_olf_reason==1 & ilo_lfs==3
			lab def ilo_dis_lab 1 "Discouraged job-seekers" 
			lab val ilo_dis ilo_dis_lab
			lab var ilo_dis "Discouraged job-seekers"
			

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
		
		drop ilo_age /* as only age bands being kept and this variable used as help variable */
		
		drop indu_code_prim indu_code_sec occ_code_prim occ_code_sec occ_code_prim_1dig occ_code_sec_1dig lab isco08_2digits isco88_2digits isco08 isco88 isic4_2digits isic4 isic3_2digits isic3 prevocu_cod preveco_cod month_*
	
		compress 
		
	* Save dataset including original and ilo variables
	
		save ${country}_${source}_${time}_FULL, replace		
	
	*Save file only containing ilo_* variables
	
		keep ilo*
		
		save ${country}_${source}_${time}_ILO, replace
		



