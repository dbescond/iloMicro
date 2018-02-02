* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Ecuador
* DATASET USED: Ecuador LFS 
* NOTES: 
* Files created: Standard variables on ENEMDU Ecuador 
* Authors: Podjanin
* Who last updated the file: Podjanin, A.
* Starting Date: 30 September 2016
* Last updated: 17 July 2017
***********************************************************************************************


*******************************************************************
 /* 1.	Set up work directory, file name, variables and function */
*******************************************************************


clear all 

set more off

global path "J:\COMMON\STATISTICS\DPAU\MICRO"
global country "ECU"
global source "ENEMDU"
global time "2012Q4"
global inputFile "201212_EnemduBDD_15anios"

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

	gen ilo_wgt=fexp
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
	gen ilo_geo=area
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

	gen ilo_sex=p02
		label define label_Sex 1 "1 - Male" 2 "2 - Female"
		label values ilo_sex label_Sex
		lab var ilo_sex "Sex"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: Age above 98 not indicated, highest value corresponds to "98 y más (98 and more)"

	gen ilo_age=p03
		replace ilo_age=. if ilo_age==99 /* As it corresponds to the label "No informa" " */
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
* Comment: Given the definition of the levels of education, ISCED97 is being chosen
			* centro de alfabetización --> included among "primary education" (cf. definition on page 23: http://www.uis.unesco.org/Library/Documents/isced97-en.pdf ) 
			
			* Note that according to the definition, the highest level being CONCLUDED is being considered


	gen ilo_edu_isced97=.
		replace ilo_edu_isced97=1 if p10a==1
		replace ilo_edu_isced97=2 if p10a==3 | (p10a==4 & inrange(p10b,0,5)) | (p10a==5 & inrange(p10b,0,6)) | (p10a==2 & inrange(p10b,0,3))
		replace ilo_edu_isced97=3 if (p10a==2 & p10b==4) | (p10a==4 & p10b==6) | (p10a==5 & inrange(p10b,7,9)) | (p10a==6 & inlist(p10b,1,2))
		replace ilo_edu_isced97=4 if (p10a==5 & p10b==10) | (p10a==6 & inrange(p10b,3,5)) | (p10a==7 & inlist(p10b,1,2))
		replace ilo_edu_isced97=5 if (p10a==6 & p10b==6) | (p10a==7 & p10b==3) | (p10a==8 & inlist(p10b,1,2)) | (p10a==9 & inlist(p10b,1,2))
		replace ilo_edu_isced97=6 if p10a==8 & p10b==3
		replace ilo_edu_isced97=7 if p10a==9 & inrange(p10b,3,8)
		replace ilo_edu_isced97=8 if p10a==10
		replace ilo_edu_isced97=9 if ilo_edu_isced97==.
			label def isced_97_lab 1 "X - No schooling" 2 "0 - Pre-primary education" 3 "1 - Primary education or first stage of basic education" 4 "2 - Lower secondary education or second stage of basic education" ///
							5 "3 - Upper secondary education" 6 "4 - Post-secondary non-tertiary education" 7 "5 - First stage of tertiary education (not leading directly to an advanced research qualification)" ///
							8 "6 - Second stage of tertiary education (leading to an advanced research qualification)" 9 "UNK - Level not stated"
			label val ilo_edu_isced97 isced_97_lab
			lab var ilo_edu_isced97 "Education (ISCED 97)"


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
*			Education attendance ('ilo_edu_attendance') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: 

		gen ilo_edu_attendance=.
			replace ilo_edu_attendance=1 if p07==1
			replace ilo_edu_attendance=2 if p07==2
			replace ilo_edu_attendance=3 if ilo_edu_attendance==.
				lab def edu_attendance_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
				lab val ilo_edu_attendance edu_attendance_lab
				lab var ilo_edu_attendance "Education (Attendance)"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Disability status ('ilo_dsb_details') [no info available]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment: Disability could only be defined at the aggregate level, but given that the question is not being asked to the 
	* entire population but only to people outside the labour force, don't define it
	
	/*  gen ilo_dsb_details=.
			
		gen ilo_dsb_aggregate=.
	*/
	
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
* Comment: 	Definition of unemployment doesn't follow international standards (i.e. people being actively
	* looking for a job are not being asked the question whether these are being available for work)
	
		* note that all of the individuals having replied "yes" to question 35 (var "p35" - desea trabajar y está dispuesto a hacerlo?) do not appear in ilo_lfs==2 at all (as they're 
			* available for work, but not taken into account among the Unemployed, as they're not actively looking for a job...)	
		
			* consider also future starters, that are currently available to work
 
	gen ilo_lfs=.
		replace ilo_lfs=1 if p20==1 | inrange(p21,1,11) | p22==1
		replace ilo_lfs=2 if inrange(p32,1,10) | (p34==2 & p35==1) 
		replace ilo_lfs=3 if (p32==11 & !inrange(p34,2,4) ) | !inlist(ilo_lfs,1,2)
			replace ilo_lfs=. if ilo_wap!=1	
				label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status" 
	
	* Unemployment on the national level defined as the sum of "open unemployment" (desempleo abierto) and "hidden unemployment" (desempleo oculto)
	
	gen nat_lfs=.
		replace nat_lfs=1 if ilo_lfs==1 /* as same definition being used according to the documentation */
		replace nat_lfs=2 if inrange(p32,1,10) | p35==1
		replace nat_lfs=3 if p35==2 | inrange(p34,8,12)
			lab val nat_lfs label_ilo_lfs
			lab var nat_lfs "Labour Force Status (national definition)" 
			
		*Note that the variable "desem" (for "desempleo"), which has already been defined coincides perfectly with the value of nat_lfs==2 once the definition from 
			* the technical documentation is being followed for the definition of nat_lfs
			* idem for empleo
			
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: 

	gen ilo_mjh=.
		replace ilo_mjh=1 if p50==1
		replace ilo_mjh=2 if p50==2
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
			replace ilo_job1_ste_icse93=1 if inlist(p42,1,2,3,4,10)
			replace ilo_job1_ste_icse93=2 if p42==5
			replace ilo_job1_ste_icse93=3 if p42==6
			replace ilo_job1_ste_icse93=4 if inlist(p42,5,6) & p42a==1
			replace ilo_job1_ste_icse93=5 if p42==7
			replace ilo_job1_ste_icse93=6 if inlist(p42,8,9)
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
	  
		* don't defines variables for the moment
		
			gen ilo_job2_ste_icse93=.
				replace ilo_job2_ste_icse93=1 if inlist(p54,1,2,3,4,10)
				replace ilo_job2_ste_icse93=2 if p54==5
				replace ilo_job2_ste_icse93=3 if p54==6
				replace ilo_job2_ste_icse93=4 if inlist(p54,5,6) & p54a==1
				replace ilo_job2_ste_icse93=5 if p54==7
				replace ilo_job2_ste_icse93=6 if inlist(p54,8,9)
					replace ilo_job2_ste_icse93=. if ilo_lfs!=1 & ilo_mjh!=2
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
* Comment:  ISIC Rev. 3.1 being used and initially indicated on 4-digits level --> keep only 2 digits level

		* transform original variables in order to get actual codes

	* Primary activity
	
	gen indu_code_prim=int(p40/100) if ilo_lfs==1
	
	* Secondary activity
	
	gen indu_code_sec=int(p52/100) if ilo_lfs==1 & ilo_mjh==2

		* Import value labels

		append using `labels', gen (lab)
					
		* Primary activity
		
		gen ilo_job1_eco_isic3_2digits=indu_code_prim
		
			lab values ilo_job1_eco_isic3 isic3_2digits
			lab var ilo_job1_eco_isic3_2digits "Economic activity (ISIC Rev. 3.1), 2 digit level"
			
		* Secondary activity
		
		gen ilo_job2_eco_isic3_2digits=indu_code_sec
		
			lab values ilo_job2_eco_isic3 isic3_2digits
			lab var ilo_job2_eco_isic3_2digits "Economic activity (ISIC Rev. 3.1), 2 digit level in secondary job"
		
	* One digit level
	
		* aggregation done according to information on page 43 of the following document: https://www.bundesbank.de/Redaktion/EN/Downloads/Service/Meldewesen/Bankenstatistik/Kundensystematik/isic_rev_4.pdf?__blob=publicationFile
	
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
				
		* Secondary activity
		
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
			replace ilo_job2_eco_isic3=18 if ilo_job2_eco_isic3==. & ilo_lfs==1
				lab val ilo_job2_eco_isic3 isic3
				lab var ilo_job2_eco_isic3 "Economic activity (ISIC Rev. 3.1) in secondary job"
		
		
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
				lab var ilo_job2_eco_aggregate "Economic activity (Aggregate) in secondary job"
			
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_ocu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: Indicate both for primary and secondary activity
	
	* transform original variables in order to get actual values
		
	* Primary activity

	gen occ_code_prim=int(p41/100) if ilo_lfs==1
	
	* Secondary activity
		
	gen occ_code_sec=int(p53/100) if ilo_lfs==1 & ilo_mjh==2
	
	* 2 digit level
	
		* Primary occupation
		
		gen ilo_job1_ocu_isco88_2digits=occ_code_prim
			lab values ilo_job1_ocu_isco88_2digits isco88_2digits
			lab var ilo_job1_ocu_isco88_2digits "Occupation (ISCO-88), 2 digit level"
			
		* Secondary occupation
	
		gen ilo_job2_ocu_isco88_2digits=occ_code_sec
			lab values ilo_job2_ocu_isco88_2digits isco88_2digits
			lab var ilo_job2_ocu_isco88_2digits "Occupation (ISCO-88), 2 digit level - secondary job"
		
	* 1 digit level
	
	gen occ_code_prim_1dig=int(occ_code_prim/10) if ilo_lfs==1
	gen occ_code_sec_1dig=int(occ_code_sec/10) if ilo_lfs==1 & ilo_mjh==2
	
		* Primary activity
		
		gen ilo_job1_ocu_isco88=occ_code_prim_1dig
			replace ilo_job1_ocu_isco88=10 if ilo_job1_ocu_isco88==0
			replace ilo_job1_ocu_isco88=11 if ilo_job1_ocu_isco88==. & ilo_lfs==1
			lab def isco88_1dig_lab 1 "1 - Managers" 2 "2 - Professionals" 3 "Technicians and associate professionals" 4 "4 - Clerks" 5 "5 - Service workers and shop and market sales workers" ///
									6 "6 - Skilled agricultural and fishery workers" 7 "7 - Craft and related trades workers" 8 "8 - Plant and machine operators, and assemblers" ///
									9 "9 - Elementary occupations" 10 "0 - Armed forces occupations" 11 "X - Not elsewhere classified"
			lab val ilo_job1_ocu_isco88 isco88_1dig_lab
			lab var ilo_job1_ocu_isco88 "Occupation (ISCO-88)"	
			
		* Secondary activity
		
		gen ilo_job2_ocu_isco88=occ_code_sec_1dig
			replace ilo_job2_ocu_isco88=10 if ilo_job2_ocu_isco88==0
			replace ilo_job2_ocu_isco88=11 if ilo_job2_ocu_isco88==. & ilo_lfs==1 & ilo_mjh==2
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
		
* Comment: consider separately for primary and secondary activity
	
	* Primary occupation
	
	gen ilo_job1_ins_sector=.
		replace ilo_job1_ins_sector=1 if p42==1
		replace ilo_job1_ins_sector=2 if inrange(p42,2,10)
				replace ilo_job1_ins_sector=. if ilo_lfs!=1
			lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
			lab values ilo_job1_ins_sector ins_sector_lab
			lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities"
			
	* Secondary occupation

	gen ilo_job2_ins_sector=.
		replace ilo_job2_ins_sector=1 if p54==1
		replace ilo_job2_ins_sector=2 if inrange(p54,2,10)
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
				
	* Actual hours worked are only being indicated for all jobs together
	
	gen ilo_joball_how_actual=p24
		replace ilo_joball_how_actual=. if ilo_lfs!=1
		lab var ilo_joball_how_actual "Weekly hours actually worked in all jobs"
	
	* Hours usually worked
	
		* Primary job
		
		gen ilo_job1_how_usual=p51a
			replace ilo_job1_how_usual=. if ilo_lfs!=1
			lab var ilo_job1_how_usual "Weekly hours usually worked in main job"
			
		* All jobs
		
		egen ilo_joball_how_usual=rowtotal(p51a p51b p51c), m
			replace ilo_joball_how_usual=. if ilo_lfs!=1
			lab var ilo_joball_how_usual "Weekly hours usually worked in all jobs"
		
		*Weekly hours actually worked --> bands --> use actual hours worked in all jobs (as no indication on main and secondary job separately)
	
	gen ilo_joball_how_actual_bands=.
		replace ilo_joball_how_actual_bands=1 if p22==1
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
	
* Comment: time usually dedicated to the primary activity being considered
	
	gen ilo_job1_job_time=.
		replace ilo_job1_job_time=1 if ilo_job1_how_usual<=34 & ilo_job1_how_usual!=.
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
	
* Comment: variable only defined for primary employment, as question on the nature of the contract
	*		is not being asked for secondary employment
	
	gen ilo_job1_job_contract=.
		replace ilo_job1_job_contract=1 if p43==2
		replace ilo_job1_job_contract=2 if inlist(p43,1,3,4,5,6)
		replace ilo_job1_job_contract=3 if ilo_job1_job_contract==. & ilo_lfs==1
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
* Comment: 
	
	* Useful questions: p42: Status in employment --> indicates whether person is working in the public sector, as well as domestic employees
					*	p44d: Paid annual leave (Recibe vacaciones por su empleador)
					* 	p44f: Social security coverage (Seguro social)
					*	[p44g: Health insurance (Seguro médico) - proxy for paid sick leave (not being used)]
					*	p46: place of work
					*	p47: size of the establishment
					*	p48: accountability --> question not being asked to state employees, domestic workers, as well as people working in establishments having more than 100 people working
					*	p49: registration of the establishment --> idem as for p48
				
				* For secondary employment:
					*	p54: Status in employment
					*	p55: place of work
					*	p56: size of establishment
					*	p57: accountability
					*	p58: registration of the establishment	
					
						* no question about social security coverage in secondary employment			
		
				* Size not being considered, except for enterprises having more than 100 employees, as these are automatically considered as being formal (and not being asked about their bookkeeping)
					
						
					* Note that any of the questions regarding social security coverage is being asked to wage employees only
					
					
	gen ilo_job1_ife_prod=.
		replace ilo_job1_ife_prod=1 if (!inlist(p42,1,10) & p48!=1 & p49==2 ) | (!inlist(p42,1,10) & p48!=1 & !inlist(p49,1,2) & ((ilo_job1_ste_aggregate==1 & p44f!=1) | ///
										ilo_job1_ste_aggregate!=1) & (!inlist(p46,1,6,7,8,9) | (inlist(p46,1,6,7,8,9) & p47a==1 & p47b<=5)))
		replace ilo_job1_ife_prod=2 if p42==1 | (!inlist(p42,1,10) & p48==1) | (!inlist(p42,1,10) & p48!=1 & p49==1) | (!inlist(p42,1,10) & p48!=1 & !inlist(p49,1,2) ///
									& (ilo_job1_ste_aggregate==1 & p44f==1) | ( !inlist(p42,1,10) & p48!=1 & !inlist(p49,1,2) & ((ilo_job1_ste_aggregate==1 & p44f!=1) | ilo_job1_ste_aggregate!=1) & ///
												inlist(p46,1,6,7,8,9) & (p47a==2 | (p47a==1 & p47b>5))))
		replace ilo_job1_ife_prod=3 if p42==10 | ilo_job1_ocu_isco88_2digits==62 | ilo_job1_eco_isic3_2digits==95
		replace ilo_job1_ife_prod=4 if ilo_job1_ife_prod==. & ilo_lfs==1
				replace ilo_job1_ife_prod=. if ilo_lfs!=1
			lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 4 "4 - Not elsewhere classified"
			lab val ilo_job1_ife_prod ilo_ife_prod_lab
			lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"
			
			* note that for the identification of domestic workers --> among the options for the status in employment, asked whether individual is a domestic employee
				* however, among the options for the place of work, it is not asked whether the individual works at the employer's dwelling (but only local or enterprise of the employer, which does not 
				* include dwellings as well) --> however option "dwelling other than yours" exists, and this is taken as a proxy for employer's dwelling 

	* National definition
		
		* Definition of informal sector following the national definition: http://www.ecuadorencifras.gob.ec/documentos/web-inec/EMPLEO/2015/Junio-2015/Metogologia_Informalidad/notatecnica.pdf
							* cf. stata commands on page 14 of the document --> use them and check whether numbers obtained are the same
		
	gen nat_ife_sector=.
		replace nat_ife_sector=1 if (ilo_lfs==1 & p47a==1 & p49==2)
		replace nat_ife_sector=2 if (ilo_lfs==1 & p47a==2) | (ilo_lfs==1 & p47a==1 & p49==1)
		replace nat_ife_sector=3 if (ilo_lfs==1 & p42==10)
		replace nat_ife_sector=4 if (ilo_lfs==1 & p47a==1 & p49==3) | (ilo_lfs==1 & nat_ife_sector==.)
			lab def nat_ife_sector_lab 1 "informal" 2 "formal" 3 "household" 4 "not classified"
			lab val nat_ife_sector nat_ife_sector_lab
			lab var nat_ife_sector "Formal/informal sector - National definition"
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Informal/formal economy: nature of job (ilo_job1_ife_nature) [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: 

	gen ilo_job1_ife_nature=.
		replace ilo_job1_ife_nature=1 if ilo_job1_ste_icse93==5 | (inlist(ilo_job1_ste_icse93,1,6) & p44f!=1) | (inlist(ilo_job1_ste_icse93,2,3,4) & inlist(ilo_job1_ife_prod,1,3))
		replace ilo_job1_ife_nature=2 if (inlist(ilo_job1_ste_icse93,1,6) & p44f==1) | (inlist(ilo_job1_ste_icse93,2,3,4) & ilo_job1_ife_prod==2)
		replace ilo_job1_ife_nature=. if ilo_lfs!=1
			lab def ife_nature_lab 1 "1 - Persons with informal main job" 2 "2 - Persons with formal main job"
			lab val ilo_job1_ife_nature ife_nature_lab
			lab var ilo_job1_ife_nature "Informal / Formal Economy (Nature of job)"
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Earnings ('ilo_ear_ees' and 'ilo_ear_slf')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	
* Comment: Classify earnings according to the occupation (i.e. primary and secondary) and then consider in a variable 
	* all labour related income for all jobs together
	
		* note that there is no information on any kind of job-related bonuses that may have been received
	
	*Currency in Ecuador: USD
	
		* --> for final variables, consider revenue from primary and secondary employment together
	
	* Primary employment 
	
			* Monthly earnings of employees
	
		*take negative value of social security contributions
		
		gen social_secur_prim=-p67 if p67!=999999
		
		*take negative value of expenditure related to own business
		
		gen business_expend=-p65 if p65!=999999
		
			* define these help variables in order to avoid including wrong values and to change original variables
		
		foreach var of varlist p66 p68b p63 p64b p69 p70b {
		
			gen job_earn_`var'=`var' if `var'!=999999
			
			}
				
		egen ilo_job1_lri_ees=rowtotal(job_earn_p66 social_secur_prim job_earn_p68b),m 
			replace ilo_job1_lri_ees=. if ilo_lfs!=1 | ilo_job1_lri_ees<0
			lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"
	
			* Self employment
		
		* note that the revenue related to self-employment includes also the value of own consumption 
			* (cf. resolution from 1998)
			
		egen ilo_job1_lri_slf=rowtotal(job_earn_p63 job_earn_p64b business_expend), m
			replace ilo_job1_lri_slf=. if ilo_lfs!=1
			lab var ilo_job1_lri_slf "Monthly labour related income of self-employed in main job"
				
	* Secondary employment
	
	*as income related to second employment is being considered together for employees and self-employed, take question on labour force status
			* in secondary activity to distinguish the two types of economic activity from each other
				
			egen ilo_job2_lri_ees=rowtotal(job_earn_p69 job_earn_p70b) if inlist(p54,1,2,3,4,10), 
					replace ilo_job2_lri_ees=. if ilo_lfs!=1 & ilo_mjh!=2
				lab var ilo_job2_lri_ees "Monthly earnings of employees in secondary job"
			
			egen ilo_job2_lri_slf=rowtotal(job_earn_p69 job_earn_p70b) if inlist(p54,5,6), m
					replace ilo_job2_lri_slf=. if ilo_lfs!=1 & ilo_mjh!=2
				lab var ilo_job2_lri_slf "Monthly labour related income of self-employed in secondary job"
	
	/* egen ilo_ear_ees=rowtotal(p66 social_secur_prim p68b wage_sec), m
		lab var ilo_ear_ees "Monthly earnings of employees"
		
		discuss whether to include a variable for all jobs together */

***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_tru') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*                
* Comment: National threshold for for full-time employment set at 40 hours per week -> therefore according to the time-related criterion 
		*	workers working 40 hours and less are considered as underemployed	
		
		* actual hours worked are being used

	gen ilo_joball_tru=1 if inlist(p27,1,2,3) & p28==1 & p24<=39
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
* Comment:	Variable p33 indicates number of weeks spent looking for a job

	 /*gen ilo_dur_details=.
		replace ilo_dur_details=1 if p33<=3
		replace ilo_dur_details=2 if p33>=4 & p33<=11
		replace ilo_dur_details=3 if p33>=12 & p33<=23
		replace ilo_dur_details=4 if p33>=24 & p33<=51
		replace ilo_dur_details=5 if p33>=52 & p33<=103
		replace ilo_dur_details=6 if p33>=104 & p33!=.
		/*replace ilo_dur_details=7 if */
			lab def ilo_unemp_det 1 "Less than 1 month" 2 "1 month to less than 3 months" 3 "3 months to less than 6 months" 4 "6 months to less than 12 months" 5 "12 months to less than 24 months" ///
									6 "24 months or more" 7 "Not elsewhere classified"
			lab values ilo_dur_details ilo_unemp_det
			lab var ilo_dur_details "Duration of unemployment (Details)" */
			
	* in order to avoid putting any notes and as the exact duration is not precised if person seeking for a job for 52 weeks, take only the aggregate version
			
			
	gen ilo_dur_aggregate=.
		replace ilo_dur_aggregate=1 if p33<=11
		replace ilo_dur_aggregate=2 if inrange(p33,12,51)
		replace ilo_dur_aggregate=3 if p33>=52 & p33!=.
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
* Comment:
	
	gen ilo_cat_une=.
		replace ilo_cat_une=1 if p37==1
		replace ilo_cat_une=2 if p37==2
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

* Comment: ISIC Rev. 4 classification being used 

		gen preveco_cod=int(p40/100) if ilo_lfs==2
		
			* keep this variable on the two digit level, in order to be able to correctly execute the code below
		
	* aggregation done according to information on page 43 of the following document: https://www.bundesbank.de/Redaktion/EN/Downloads/Service/Meldewesen/Bankenstatistik/Kundensystematik/isic_rev_4.pdf?__blob=publicationFile
	
	* Previous economic activity
	
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
		replace ilo_preveco_isic3=18 if ilo_preveco_isic3==. & ilo_cat_une==1 & ilo_lfs==2
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
*			Previous occupation ('ilo_prevocu_isco08') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			
* Comment: ISCO-08 classification being used

	* reduce it to the one digit level 
	
	gen prevocu_cod=int(p41/1000) if ilo_lfs==2
	
	gen ilo_prevocu_isco88=prevocu_cod
			replace ilo_prevocu_isco88=10 if ilo_prevocu_isco88==0
			replace ilo_prevocu_isco88=11 if ilo_prevocu_isco88==. & ilo_cat_une==1 & ilo_lfs==2
				* value label already defined
			lab val ilo_prevocu_isco88 isco88_1dig_lab
			lab var ilo_prevocu_isco88 "Occupation (ISCO-88)"	
			
	* Aggregate level
	
		* Primary occupation
	
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
				lab var ilo_prevocu_aggregate "Occupation (Aggregate)"
				
				
	* Skill level
	
		* Primary occupation
	
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
*			Degree of labour market attachment ('ilo_olf_dlma') [don't keep]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: Degree of labour market attachment of persons outside the labour force

		* problematic to define variable as availability is not being asked for if the person is looking for a job
			* thefore first option can't be defined
		* if person says that it's not able or willing to work, it is not being asked about its availability, which doesn't allow allow to define the fourth option
		
			* therefore only one option can be defined --> too few observations --> don't define variable
	
	/* gen ilo_olf_dlma=.
		/* replace ilo_olf_dlma=1 if */
		replace ilo_olf_dlma=2 if p32==11 & p35==1
		/* replace ilo_olf_dlma=3 if */
		/* replace ilo_olf_dlma=4 if */
		replace ilo_olf_dlma=5 if ilo_olf_dlma==. & ilo_lfs==3
				replace ilo_olf_dlma=. if ilo_lfs!=3
			lab def lab_olf_dlma 1 "1 - Seeking, not available (Unavailable jobseekers)" 2 "2 - Not seeking, available (Available potential jobseekers)" ///
						3 "3 - Not seeking, not available, willing (Willing non-jobseekers)" 4 "4 - Not seeking, not available, not willing" 5 "5 - Not elsewhere classified"
			lab val ilo_olf_dlma lab_olf_dlma
			lab var ilo_olf_dlma "Labour market attachment (Degree of)"	*/
			
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reasons for not seeking a job ('ilo_olf_reason') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: 
	
	gen ilo_olf_reason=.
		replace ilo_olf_reason=1 if inlist(p34,1,6,7)
		replace ilo_olf_reason=2 if inlist(p34,3,4,5)
		replace ilo_olf_reason=3 if inlist(p34,9,10,11,12)
		replace ilo_olf_reason=4 if p34==8
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
*
* Comment: 	

		gen ilo_dis=1 if inlist(p34,6,7) & ilo_lfs==3 & p35==1
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
* 1.	Prepare final datasets
* -------------------------------------------------------------

cd "$outpath"

		drop if lab==1 /* in order to get rid of observations from tempfile */
		
		drop ilo_age /* as only age bands being kept and this variable used as help variable */
		
		drop social_secur_prim business_expend indu_code_* occ_code_* prevocu_cod preveco_cod lab isco08_2digits isco88_2digits isco08 isco88 isic4_2digits isic4 isic3_2digits isic3 job_earn_*
	
		compress 
		
	* Save dataset including original and ilo variables
	
		save ${country}_${source}_${time}_FULL,  replace		
	
	*Save file only containing ilo_* variables
	
		keep ilo*

		save ${country}_${source}_${time}_ILO, replace
		
		
*****************************************************************************************************************************************************************************************************

* Generate framework directly from here, as geographical coverage is not the same throughout the time series

	global surveycode = "BA:19"
	
	cd "$temppath"
	
	import excel "3_Framework.xlsx", sheet("Variable") firstrow clear
	
		* drop J /* variable being erroneously created while importing excel file */
		
			drop if priority_level=="999"
	
		replace ilostat_code="${country}" if var_name=="ilo_country"
		replace ilostat_code="${surveycode}" if var_name=="ilo_source"
		
		* add here all other codes following the same logic
		
		replace ilostat_note_code="T2:84_T3:89" if var_name=="ilo_source" 
		
		replace ilostat_note_code="T5:3662" if var_name=="ilo_lfs" & code_label=="Unemployed"
		
		
			* replace note if only urban coverage
			
				gen time="${time}"
				
				if inlist(time,"2012Q1","2012Q3","2011Q1","2011Q3","2010Q1","2010Q3","2009Q1","2009Q2","2009Q3") | inlist(time,"2008Q3","2008Q2","2008Q1","2007Q4","2007Q3","2007Q2") {
				
				replace ilostat_note_code="S4:31" if ilostat_code=="GEO_COV_URB"
				
				}		
				
				drop time		

		* save new framework
			
		cd "$outpath"
		
		export excel "${country}_${source}_${time}_ILO_FWK.xlsx", sheet("Sheet 1") firstrow(var) replace
		

		
