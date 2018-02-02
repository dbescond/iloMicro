* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Guatemala
* DATASET USED: Guatemala LFS 
* NOTES: 
* Files created: Standard variables on LFS Guatemala
* Authors: Podjanin
* Who last updated the file: Podjanin, A.
* Starting Date: 01 December 2017
* Last updated: 05 December 2017
***********************************************************************************************



*******************************************************************
 /* 1.	Set up work directory, file name, variables and function */
*******************************************************************

clear all 

set more off

global path "J:\COMMON\STATISTICS\DPAU\MICRO"
global country "GTM"
global source "ENEI"
global time "2004"
global inputFile "ENEI 2004 (Personas).dta"

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

		capture confirm var factorpe
			if !_rc {
			
		gen ilo_wgt=factorpe
			lab var ilo_wgt "Sample weight"
			
				}
				
			else {
			
	if time=="2002Q2" {
	
	gen ilo_wgt=factore
		lab var ilo_wgt "Sample weight"
			}
			
	if time=="2004" {

	gen ilo_wgt=factor
		lab var ilo_wgt "Sample weight"
				}
				
				
				}
	
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
		replace ilo_geo=1 if inrange(dominio,1,22)
		replace ilo_geo=2 if dominio==23
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
			
			* Info on educational system: http://www.classbase.com/countries/Guatemala/Education-System 


	if year<=2003 {
	
	gen ilo_edu_isced97=.
		replace ilo_edu_isced97=1 if p03a09a==1 
		replace ilo_edu_isced97=2 if p03a09a==2 | (p03a09a==4 & inrange(p03a09b,0,5))
		replace ilo_edu_isced97=3 if (p03a09a==4 & p03a09b==6) | (p03a09a==5 & inrange(p03a09b,0,2))
		replace ilo_edu_isced97=4 if p03a09a==5 & inrange(p03a09b,3,5)
		replace ilo_edu_isced97=5 if (p03a09a==5 & inlist(p03a09b,6,7)) | (p03a09a==6 & inrange(p03a09b,0,3))
		/* replace ilo_edu_isced97=6 if */
		replace ilo_edu_isced97=7 if p03a09a==6 & inrange(p03a09b,4,6)
		replace ilo_edu_isced97=8 if p03a09a==7
		replace ilo_edu_isced97=9 if ilo_edu_isced97==.
			label def isced_97_lab 1 "X - No schooling" 2 "0 - Pre-primary education" 3 "1 - Primary education or first stage of basic education" 4 "2 - Lower secondary education or second stage of basic education" ///
							5 "3 - Upper secondary education" 6 "4 - Post-secondary non-tertiary education" 7 "5 - First stage of tertiary education (not leading directly to an advanced research qualification)" ///
							8 "6 - Second stage of tertiary education (leading to an advanced research qualification)" 9 "UNK - Level not stated"
			label val ilo_edu_isced97 isced_97_lab
			lab var ilo_edu_isced97 "Education (ISCED 97)"
			
				}
				
	else {	
	
	gen ilo_edu_isced97=.
		replace ilo_edu_isced97=1 if p03a07a==1 
		replace ilo_edu_isced97=2 if p03a07a==2 | (p03a07a==3 & inrange(p03a07b,0,5))
		replace ilo_edu_isced97=3 if (p03a07a==3 & p03a07b==6) | (p03a07a==4 & inrange(p03a07b,0,2))
		replace ilo_edu_isced97=4 if (p03a07a==4 & p03a07b==3) | (p03a07a==5 & inrange(p03a07b,0,5))
		replace ilo_edu_isced97=5 if (p03a07a==5 & inlist(p03a07b,6,7)) | (p03a07a==6 & inrange(p03a07b,0,3))
		/* replace ilo_edu_isced97=6 if */
		replace ilo_edu_isced97=7 if p03a07a==6 & inrange(p03a07b,4,6)
		replace ilo_edu_isced97=8 if p03a07a==7
		replace ilo_edu_isced97=9 if ilo_edu_isced97==.
			label def isced_97_lab 1 "X - No schooling" 2 "0 - Pre-primary education" 3 "1 - Primary education or first stage of basic education" 4 "2 - Lower secondary education or second stage of basic education" ///
							5 "3 - Upper secondary education" 6 "4 - Post-secondary non-tertiary education" 7 "5 - First stage of tertiary education (not leading directly to an advanced research qualification)" ///
							8 "6 - Second stage of tertiary education (leading to an advanced research qualification)" 9 "UNK - Level not stated"
			label val ilo_edu_isced97 isced_97_lab
			lab var ilo_edu_isced97 "Education (ISCED 97)"
			
			}

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
			replace ilo_edu_attendance=1 if p03a05==1
			replace ilo_edu_attendance=2 if p03a05==2 | p03a04==2
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
* Comment: Note that question p06a14 is not asked to whoever answered that he/she was seeking a job for the first time (i.e. answering to the first option of question p06a06). Therefore, the three criteria
			* (not in employment, seeking a job and available) are considered for unemployed, who were previously employed, but only two criteria (not in employment and seeking a job) for people that are seeking a job
			* for the first time.
	
	if year<=2003 {
	
	
	gen ilo_lfs=.
		replace ilo_lfs=1 if p04a02==1 | p04a03==1 | p04a04==1 | p04a05==1 | inrange(p04a07,1,10)  
		replace ilo_lfs=2 if ilo_lfs!=1 & (p04a08==1 | p04a09==1 | p04a11==1 ) & p06a13!=2
		replace ilo_lfs=3 if !inlist(ilo_lfs,1,2) & ilo_wap==1
			replace ilo_lfs=. if ilo_wap!=1				
				label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status"			
				
				}
				
	else {	
	
	gen ilo_lfs=.
		replace ilo_lfs=1 if p04a02==1 | p04a03==1 | p04a04==1 | p04a05==1 | inrange(p04a07,1,10)  
		replace ilo_lfs=2 if ilo_lfs!=1 & (p04a08==1 | p04a09==1 | p04a11==1 ) & p06a14!=2
		replace ilo_lfs=3 if !inlist(ilo_lfs,1,2) & ilo_wap==1
			replace ilo_lfs=. if ilo_wap!=1				
				label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status"			
			
			}			
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: 

	gen ilo_mjh=.
		replace ilo_mjh=1 if p05a01==1
		replace ilo_mjh=2 if inlist(p05a01,2,3)
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
	
	
		if year<=2003 {
		
		gen ilo_job1_ste_icse93=.
			replace ilo_job1_ste_icse93=1 if inlist(p05a08,1,2,3,4)
			replace ilo_job1_ste_icse93=2 if p05a08==6
			replace ilo_job1_ste_icse93=3 if p05a08==5
			/* replace ilo_job1_ste_icse93=4 if */
			replace ilo_job1_ste_icse93=5 if inlist(p05a08,7,8)
			replace ilo_job1_ste_icse93=6 if ilo_job1_ste_icse93==. & ilo_lfs==1
				replace ilo_job1_ste_icse93=. if ilo_lfs!=1
				
					}
					
		else {
	
		gen ilo_job1_ste_icse93=.
			replace ilo_job1_ste_icse93=1 if inlist(p05a07,1,2,3,4)
			replace ilo_job1_ste_icse93=2 if inlist(p05a07,6,8) 
			replace ilo_job1_ste_icse93=3 if inlist(p05a07,5,7)  
			/* replace ilo_job1_ste_icse93=4 if */
			replace ilo_job1_ste_icse93=5 if p05a07==9
			replace ilo_job1_ste_icse93=6 if ilo_job1_ste_icse93==. & ilo_lfs==1
				replace ilo_job1_ste_icse93=. if ilo_lfs!=1
				
				}
			
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
	  
	  
		if year<=2003 {
		
		gen ilo_job2_ste_icse93=.
			replace ilo_job2_ste_icse93=1 if inlist(p05b04,1,2,3,4)
			replace ilo_job2_ste_icse93=2 if p05b04==6
			replace ilo_job2_ste_icse93=3 if p05b04==5
			/* replace ilo_job2_ste_icse93=4 if */
			replace ilo_job2_ste_icse93=5 if inlist(p05b04,7,8)
			replace ilo_job2_ste_icse93=6 if ilo_job2_ste_icse93==. & ilo_lfs==1 & ilo_mjh==2
				replace ilo_job2_ste_icse93=. if ilo_lfs!=1 & ilo_mjh!=2
				
					}
					
		else {
	
		gen ilo_job2_ste_icse93=.
			replace ilo_job2_ste_icse93=1 if inlist(p05b04,1,2,3,4)
			replace ilo_job2_ste_icse93=2 if inlist(p05b04,6,8) 
			replace ilo_job2_ste_icse93=3 if inlist(p05b04,5,7) 
			/* replace ilo_job2_ste_icse93=4 if */
			replace ilo_job2_ste_icse93=5 if p05b04==9
			replace ilo_job2_ste_icse93=6 if ilo_job2_ste_icse93==. & ilo_lfs==1 & ilo_mjh==2
				replace ilo_job2_ste_icse93=. if ilo_lfs!=1 & ilo_mjh!=2
				
				}
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
* Comment: ISIC Rev. 3.1 being used 

	* economic activity indicated both for primary and secondary activity 
	
	if year<=2003 {
	
	gen indu_code_prim=p05a03 if ilo_lfs==1
	
	gen indu_code_sec=p05b03 if ilo_lfs==1 & ilo_mjh==2
	
		}
		
	else {

	gen indu_code_prim=p05a03d2 if ilo_lfs==1
	
	gen indu_code_sec=p05b03d2 if ilo_lfs==1 & ilo_mjh==2
	
		}
	
		* Import value labels

		append using `labels', gen (lab)
					
		* Primary activity
		
		gen ilo_job1_eco_isic3_2digits=indu_code_prim
		
			* put "cultivo de café" (coffee farming) in category 1 - agriculture (at the two digit level)
			
			replace ilo_job1_eco_isic3_2digits=1 if ilo_job1_eco_isic3_2digits==3
		
			lab values ilo_job1_eco_isic3 isic3_2digits
			lab var ilo_job1_eco_isic3_2digits "Economic activity (ISIC Rev. 3.1), 2 digit level"
			
		* Secondary activity
		
		gen ilo_job2_eco_isic3_2digits=indu_code_sec
		
			replace ilo_job2_eco_isic3_2digits=1 if ilo_job2_eco_isic3_2digits==3
		
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

		* Classification used - ISCO-08

	if year<=2003 {
	
	gen occ_code_prim=p05a02 if ilo_lfs==1 & p05a02!=99
	gen occ_code_sec=p05b02 if ilo_lfs==1 & ilo_mjh==2 & p05c03!=99
	
		}
	
	else {
	
	gen occ_code_prim=p05a02d2 if ilo_lfs==1 & p05a02d2!=99
	gen occ_code_sec=p05b02d2 if ilo_lfs==1 & ilo_mjh==2 & p05c03d2!=99
	
		}
		
	* 2 digit level
	
		* note that at the two-digit level, nationally defined codes 63 "Agricultores de cultivo de café" (agricultural workers in coffee farming) and 64 "Administrador de finca de café" 
			* (coffee farm administrator) will not have a value label in our two-digit level classification, but will be integrated in category "6 - Skilled agricultural and fishery workers" at the
			* one digit level
	
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
	
	if year<=2003 {
	
	gen ilo_job1_ins_sector=.
		replace ilo_job1_ins_sector=1 if p05a08==1
		replace ilo_job1_ins_sector=2 if ilo_job1_ins_sector==. & ilo_lfs==1	
			}
		
		else {
	
	gen ilo_job1_ins_sector=.
		replace ilo_job1_ins_sector=1 if p05a07==1
		replace ilo_job1_ins_sector=2 if ilo_job1_ins_sector==. & ilo_lfs==1
		
				}
				
				replace ilo_job1_ins_sector=. if ilo_lfs!=1
			lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
			lab values ilo_job1_ins_sector ins_sector_lab
			lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities"
			
	* Secondary occupation


	gen ilo_job2_ins_sector=.
		replace ilo_job2_ins_sector=1 if p05b04==1
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
* Comment: consider first working time associated with each job (if available) and then consider the sum (i.e.
				* the time dedicated to all working activities during the week
				
	* Actual hours worked are not being indicated
	
	* Hours usually worked
	
		* All jobs - i.e. hours dedicated to primary and secondary employment
		
	if year<=2003 {	
	egen ilo_job1_how_usual=rowtotal(p05a31*), m
			}
	else {
	egen ilo_job1_how_usual=rowtotal(p05a33*), m
			}
		replace ilo_job1_how_usual=. if ilo_lfs!=1
		lab var ilo_job1_how_usual "Weekly hours usually worked in main job"
		
	if year<=2003 {
	gen ilo_job2_how_usual=p05b09
		}
		
	else {
	gen ilo_job2_how_usual=p05b14
			}
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
		*	is not being asked for secondary employment
	
	if year<=2003 {
	
	gen ilo_job1_job_contract=.
		replace ilo_job1_job_contract=1 if p05a10a==1
		replace ilo_job1_job_contract=2 if p05a10a==2 
		replace ilo_job1_job_contract=3 if p05a09==2 | (ilo_job1_job_contract==. & ilo_job1_ste_aggregate==1)
		
			}
	
	
		else {
	gen ilo_job1_job_contract=.
		replace ilo_job1_job_contract=1 if p05a09a==1
		replace ilo_job1_job_contract=2 if p05a09a==2 
		replace ilo_job1_job_contract=3 if p05a08==2 | (ilo_job1_job_contract==. & ilo_job1_ste_aggregate==1)
		
			}
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
* Comment:  --> no information about bookkeeping and registration available...!

		* (variable names from 2004:)
		
	* Useful questions: p05a07: Status in employment / Institutional sector
					*	[no info]: Destination of production
					*	[no info]: Bookkeeping
					*	[no info]: Registration
					*	p05a29: Social security (IGSS) (proxy for registration)
					*	p05a37: Location of workplace 
					*	p05a32: Size of the establishment
					
					
					
			* given that the question on social security is being asked to all people in employment, use it as a proxy for registration
				* consider only "afiliado" as having social security coverage
					
	
	if year<=2003 {
	
	gen ilo_job1_ife_prod=.
		replace ilo_job1_ife_prod=1 if !inlist(p05a08,1,4) & p05a25!=1
		replace ilo_job1_ife_prod=2 if p05a08==1 | (!inlist(p05a08,1,4) & p05a25==1)
		replace ilo_job1_ife_prod=3 if p05a08==4 | ilo_job1_ocu_isco88_2digits==62 | ilo_job1_eco_isic3_2digits==95
		replace ilo_job1_ife_prod=4 if ilo_job1_ife_prod==. & ilo_lfs==1
		
			}
	
		else {
		
	gen ilo_job1_ife_prod=.
		replace ilo_job1_ife_prod=1 if !inlist(p05a07,1,4) & p05a29!=1
		replace ilo_job1_ife_prod=2 if p05a07==1 | (!inlist(p05a07,1,4) & p05a29==1)
		replace ilo_job1_ife_prod=3 if p05a07==4 | ilo_job1_ocu_isco88_2digits==62 | ilo_job1_eco_isic3_2digits==95
		replace ilo_job1_ife_prod=4 if ilo_job1_ife_prod==. & ilo_lfs==1
		
			}			
			
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

	if year<=2003 {
	
	gen ilo_job1_ife_nature=.
		replace ilo_job1_ife_nature=1 if ilo_job1_ste_icse93==5 | (inlist(ilo_job1_ste_icse93,1,6) & p05a25!=1) | (inlist(ilo_job1_ste_icse93,2,3,4) & inlist(ilo_job1_ife_prod,1,3))
		replace ilo_job1_ife_nature=2 if (inlist(ilo_job1_ste_icse93,1,6) & p05a25==1) | (inlist(ilo_job1_ste_icse93,2,3,4) & ilo_job1_ife_prod==2)
		replace ilo_job1_ife_nature=. if ilo_lfs!=1
		
			}
			
	else {

	gen ilo_job1_ife_nature=.
		replace ilo_job1_ife_nature=1 if ilo_job1_ste_icse93==5 | (inlist(ilo_job1_ste_icse93,1,6) & p05a29!=1) | (inlist(ilo_job1_ste_icse93,2,3,4) & inlist(ilo_job1_ife_prod,1,3))
		replace ilo_job1_ife_nature=2 if (inlist(ilo_job1_ste_icse93,1,6) & p05a29==1) | (inlist(ilo_job1_ste_icse93,2,3,4) & ilo_job1_ife_prod==2)
		replace ilo_job1_ife_nature=. if ilo_lfs!=1
		
			}
			
			
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
	
	if year<=2003 {
	
	* Primary employment
	
			* Monthly earnings of employees
			
				* obtain monthly values of some variables 			
				
			gen ropa=p05a18c*p05a18b
				
		foreach var of varlist p05a15b p05a16b p05a17b ropa {
		
			gen month_`var'=`var'/12
			 }	
				
		egen ilo_job1_lri_ees=rowtotal(p05a14 month_* p05a19b p05a20b p05a21b),m 
			replace ilo_job1_lri_ees=. if ilo_job1_ste_aggregate!=1
			lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"
			
			* Self employment
		
		* note that the revenue related to self-employment includes also the value of own consumption 
			* (cf. resolution from 1998)
			
		gen ilo_job1_lri_slf=p05a23
			replace ilo_job1_lri_slf=. if ilo_job1_ste_aggregate!=2
			lab var ilo_job1_lri_slf "Monthly labour related income of self-employed in main job"
				
	* Secondary employment
	
		* Earnings of employees 
			
			foreach var of varlist p05b07b {
		
			gen month_sec_`var'=`var'/12
				}	
				
			egen ilo_job2_lri_ees=rowtotal(p05b05 p05b06b month_sec_*), m
					replace ilo_job2_lri_ees=. if ilo_lfs!=1 & ilo_mjh!=2
				lab var ilo_job2_lri_ees "Monthly earnings of employees in secondary job"
			
		* Self-employment
			
			
			gen ilo_job2_lri_slf=p05b08
					replace ilo_job2_lri_slf=. if ilo_lfs!=1 & ilo_mjh!=2
				lab var ilo_job2_lri_slf "Monthly labour related income of self-employed in secondary job"
				
					}
	
	else {
	
	* Primary employment
	
			* Monthly earnings of employees
			
				* obtain monthly values of some variables 	
				
			gen ropa=p05a21c*p05a21b
				
		foreach var of varlist p05a15b p05a16b p05a17b p05a18b p05a19b p05a20b ropa {
		
			gen month_`var'=`var'/12
			 }	
				
		egen ilo_job1_lri_ees=rowtotal(p05a12 p05a13b p05a14b month_* p05a22b p05a23b p05a24b),m 
			replace ilo_job1_lri_ees=. if ilo_job1_ste_aggregate!=1
			lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"
			
			* Self employment
		
		* note that the revenue related to self-employment includes also the value of own consumption 
			* (cf. resolution from 1998)
			
		egen ilo_job1_lri_slf=rowtotal(p05a25 p05a26), m
			replace ilo_job1_lri_slf=. if ilo_job1_ste_aggregate!=2
			lab var ilo_job1_lri_slf "Monthly labour related income of self-employed in main job"
				
	* Secondary employment
	
		* Earnings of employees 
			
			foreach var of varlist p05b09b p05b10b {
		
			gen month_sec_`var'=`var'/12
				}	
				
			egen ilo_job2_lri_ees=rowtotal(p05b05 p05b06b p05b07b p05b08b month_sec_*), m
					replace ilo_job2_lri_ees=. if ilo_lfs!=1 & ilo_mjh!=2
				lab var ilo_job2_lri_ees "Monthly earnings of employees in secondary job"
			
		* Self-employment
			
			gen month_sec_p05b12=p05b12/12
			
			egen ilo_job2_lri_slf=rowtotal(p05b11 month_sec_p05b12), m
					replace ilo_job2_lri_slf=. if ilo_lfs!=1 & ilo_mjh!=2
				lab var ilo_job2_lri_slf "Monthly labour related income of self-employed in secondary job"
				
				}
				
		drop month_* ropa
	

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

	gen ilo_joball_tru=1 if ilo_joball_how_usual<45 & p05d01==1 & p05d05==1
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
* Comment:	Variable p06a02 indicates number of weeks spent looking for a job

	
	gen ilo_dur_details=.
		replace ilo_dur_details=1 if inrange(p06a02,0,4)
		replace ilo_dur_details=2 if inrange(p06a02,5,13)
		replace ilo_dur_details=3 if inrange(p06a02,14,26)
		replace ilo_dur_details=4 if inrange(p06a02,27,52)
		replace ilo_dur_details=5 if inrange(p06a02,53,96)
		replace ilo_dur_details=6 if p06a02>=97 & !inlist(p06a02,996,997,.)
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
		replace ilo_cat_une=1 if p06a06==2
		replace ilo_cat_une=2 if p06a06==1
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

* Comment: ISIC Rev. 3 classification being used 

		if year<=2003 {
		
		gen preveco_cod=p06a09 if ilo_cat_une==1
		
			}
			
		else {	
		
		gen preveco_cod=p06a09d2 if ilo_cat_une==1
		
			}
		
			* do same as for current economic activity --> put "cultivo de café" in agriculture
			
				replace preveco_cod=1 if preveco_cod==3
		
			* keep this variable on the two digit level, in order to be able to correctly execute the code below
		
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
* Comment: ISCO-88 classification being used

	* reduce it to the one digit level
	
	if year<=2003 {
	
	gen prevocu_cod=int(p06a08/10) if ilo_cat_une==1
	
		}
		
	else {
	
	gen prevocu_cod=int(p06a08d2/10) if ilo_cat_une==1
	
		}
		
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
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Unemployment benefits schemes ('ilo_soc_aggregate') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

*			no info

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


	* due to filter questions (people not seeking a job not asked about their availability), this variable cannot be defined
	
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reasons for not seeking a job ('ilo_olf_reason') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment:

	if year<=2003 {
	
	gen ilo_olf_reason=.
		replace ilo_olf_reason=1 if inlist(p04a11,2,3,5,6,7,8,9)
		replace ilo_olf_reason=2 if inlist(p04a11,1,4)
		replace ilo_olf_reason=3 if inlist(p04a11,10,11,12,13,14,15)
			replace ilo_olf_reason=3 if inlist(p04a02,3,4,5,8) & ilo_olf_reason==.
		replace ilo_olf_reason=4 if inlist(p04a02,6,7)
		replace ilo_olf_reason=5 if ilo_olf_reason==. & ilo_lfs==3
			replace ilo_olf_reason=. if ilo_lfs!=3
			
				}

	else {
	
	gen ilo_olf_reason=.
		replace ilo_olf_reason=1 if inlist(p04a11,2,3,4,7,8,9,10,11)
		replace ilo_olf_reason=2 if inlist(p04a11,1,5,6)
		replace ilo_olf_reason=3 if inlist(p04a11,12,13,14,15,16,17)
			replace ilo_olf_reason=3 if inlist(p04a02,3,4,5,8) & ilo_olf_reason==.
		replace ilo_olf_reason=4 if inlist(p04a02,6,7)
		replace ilo_olf_reason=5 if ilo_olf_reason==. & ilo_lfs==3
			replace ilo_olf_reason=. if ilo_lfs!=3
			
				}
				
				
			lab def lab_olf_reason 1 "1 - Labour market (discouraged)" 2 "2 - Other labour market reasons" 3 "3 - Personal/Family-related"  4 "4 - Does not need/want to work" 5 "5 - Not elsewhere classified"
			lab val ilo_olf_reason lab_olf_reason
			lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seekers ('ilo_disc') [done]
* -------------------------------------------------------------------------------------------
* ------------------------------------------------------------------------------------------- 
*
* Comment: 	Given the skip pattern (cf. comment for ilo_olf_dlma), this variable cannot be identified


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
		
		drop indu_code_prim indu_code_sec occ_code_prim occ_code_sec occ_code_prim_1dig occ_code_sec_1dig lab isco08_2digits isco88_2digits isco08 isco88 isic4_2digits isic4 isic3_2digits isic3 prevocu_cod preveco_cod time year
		
		compress 
		
		order ilo_*, last
		
		drop if ilo_wgt==.
		
	* Save dataset including original and ilo variables
	
		save ${country}_${source}_${time}_FULL, replace		
	
	*Save file only containing ilo_* variables
	
		keep ilo*
		
		save ${country}_${source}_${time}_ILO, replace
	
