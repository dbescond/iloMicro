* TITLE OF DO FILE: ILO Microdata Preprocessing code template - BOL HS 2014
* DATASET USED: BOL HS 2014
* NOTES:
* Author: Roger Gomis
* Who last updated the file: Roger Gomis
* Starting Date: 20 February 2017
* Last updated: 22 February 2017
***********************************************************************************************


***********************************************************************************************
***********************************************************************************************

* 			1. SET UP WORK DIRECTORY, FILE NAME, VARIABLES AND FUNCTIONS

***********************************************************************************************
***********************************************************************************************

clear all 

set more off

global path "J:\COMMON\STATISTICS\DPAU\MICRO"
global country "HND"
global source "EPHPM"
global time "2014"
global inputFile "Hogares_2014"

global inpath "${path}\\${country}\\${source}\\${time}\ORI"
global temppath "${path}\_Admin"
global outpath "${path}\\${country}\\${source}\\${time}"

************************************************************************************
* Make a tempfile containing the labels for the classifications ISIC and ISCO 

* note to work it requires to run (on a one time basis):

/*
set httpproxyhost proxy.ilo.org
set httpproxyport 3128
set httpproxy on

ssc install labutil
	*/
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
				
				foreach var of newlist isco08_2digits isco88_2digits isco08 isco88 isic4_2digits isic4 isic3_2digits isic3 {
							gen `var'=code_level
							replace `var'=. if code_label`var'==""
							labmask `var' , val(code_label`var')
							}				
				
				drop code_label* code_level
			
			save "`labels'"


*---------------------------------------------------------------------------------------------
*---------------------------------------------------------------------------------------------
* 			Load original dataset
*---------------------------------------------------------------------------------------------
*---------------------------------------------------------------------------------------------

cd "$inpath"

	use ${inputFile}, clear	
		
* to ensure that no observations are added
gen original=1
***********************************************************************************************
***********************************************************************************************

*			2. MAP VARIABLES

***********************************************************************************************
***********************************************************************************************



* ---------------------------------------------------------------------------------------------
***********************************************************************************************
*			PART 1. DATASET SETTINGS VARIABLES
***********************************************************************************************
* ---------------------------------------------------------------------------------------------
rename *, lower

if ${time} ==2014|${time} ==2015 {
 replace dominio=5 if dominio==4
}

if ${time} ==2013 | ${time} ==2012  {

 capture rename *ce44_* *ce444_*
 
 foreach var of varlist ce448-ce476 {
 rename `var' test_`var'
 }
 
 rename test_ce449 ce448
 rename test_ce454 ce453
 rename test_ce474 ce472
 
 
}

*********************** Note::::::SECTOR-> Some issues, break from 2014 to 2015 (Change from ISCO 88 to 08)
********** It turns out the difference is made mostly due to general managers, with many own account workers without employees being 
********** considered general managers in 2014 and before
******
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Key identifier ('ilo_key')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_key=_n
		lab var ilo_key "Key unique identifier per individual"		


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sample Weight ('ilo_wgt')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_wgt=factor
		lab var ilo_wgt "Sample weight"		


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time period ('ilo_time')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------


	gen ilo_time=1
		lab def lab_time 1 $time
		lab val ilo_time lab_time
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
		replace ilo_geo=1 if dominio<5
		replace ilo_geo=2 if dominio==5
			lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural"
			lab val ilo_geo ilo_geo_lab
			lab var ilo_geo "Geographical coverage"	

			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_sex=sexo
		lab def ilo_sex_lab 1 "1 - Male" 2 "2 - Female"
		lab var ilo_sex "Sex"
		lab val ilo_sex ilo_sex_lab


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

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
			lab def age_by5_lab 1 "0-4" 2 "5-9" 3 "10-14" 4 "15-19" 5 "20-24" 6 "25-29" ///
								7 "30-34" 8 "35-39" 9 "40-44" 10 "45-49" 11 "50-54" 12 "55-59" ///
								13 "60-64" 14 "65+"
			lab val ilo_age_5yrbands age_by5_lab
			lab var ilo_age_5yrbands "Age (5-year age bands)"
			
	gen ilo_age_10yrbands=.
		replace ilo_age_10yrbands=1 if inrange(ilo_age,0,14)
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
		replace ilo_age_aggregate=1 if inrange(ilo_age,0,14)
		replace ilo_age_aggregate=2 if inrange(ilo_age,15,24)
		replace ilo_age_aggregate=3 if inrange(ilo_age,25,54)
		replace ilo_age_aggregate=4 if inrange(ilo_age,55,64)
		replace ilo_age_aggregate=5 if ilo_age>=65 & ilo_age!=.
			lab def age_aggr_lab 1 "<15" 2 "15-24" 3 "25-54" 4 "55-64" 5 "65+"
			lab val ilo_age_aggregate age_aggr_lab
			lab var ilo_age_aggregate "Age (Aggregate)"



* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education ('ilo_edu')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

/* based on the mapping developped by UNESCO 
					http://www.uis.unesco.org/Education/ISCEDMappings/Pages/default.aspx
					file:///J:\COMMON\STATISTICS\DPAU\MICRO\HND\HS\2014\ORI\ISCED_2011_Mapping_Honduras_EN.xlsx
	
					
*/
*doctorate category is left empty



* ISCED11
gen ilo_edu_isced11=.

** Level acomplished
	*Higher categories
		*Higher categories completed
		replace ilo_edu_isced11=5 if ed107==1&(ed105==6|ed105==7)
		replace ilo_edu_isced11=7 if ed107==1&(ed105==8)
		replace ilo_edu_isced11=8 if ed107==1&(ed105==9)
		replace ilo_edu_isced11=9 if ed107==1&(ed105==10)
		*Higher categories not completed
		replace ilo_edu_isced11=4 if ed107==2&(ed105==6|ed105==7)
		replace ilo_edu_isced11=5 if ed107==2&(ed105==8|ed105==9)
		replace ilo_edu_isced11=8 if ed107==2&(ed105==10)
	*Intermediate categories
		*Intermediate categories - highest course completed
		replace ilo_edu_isced11=2 if (ed108>=3&ed108!=.)&ed105==3
		replace ilo_edu_isced11=3 if (ed108>=6&ed108!=.)&ed105==4
		replace ilo_edu_isced11=4 if (ed108>=3&ed108!=.)&ed105==5
		*Intermediate categories - highest course NOT completed
		replace ilo_edu_isced11=1 if (ed108<3)&ed105==3
		replace ilo_edu_isced11=2 if (ed108<6)&ed105==4
		replace ilo_edu_isced11=3 if (ed108<3)&ed105==5
	* Lower categories (no requirements)
		replace ilo_edu_isced11=1 if ed105==2
		replace ilo_edu_isced11=1 if ed105==1
		
		
** Current level -> and therefore not finished 	
		*Higher categories not completed
		replace ilo_edu_isced11=4 if ilo_edu_isced==.&(ed110==6|ed110==7)
		replace ilo_edu_isced11=5 if ilo_edu_isced==.&(ed110==8|ed110==9)
		replace ilo_edu_isced11=8 if ilo_edu_isced==.&(ed110==10)
		*Intermediate categories - highest course NOT completed
		replace ilo_edu_isced11=1 if ilo_edu_isced==.&ed110==3
		replace ilo_edu_isced11=2 if ilo_edu_isced==.&ed110==4
		replace ilo_edu_isced11=3 if ilo_edu_isced==.&ed110==5
		* Lower categories (no requirements)
		replace ilo_edu_isced11=1 if ilo_edu_isced==.&ed110==2
		
		
	* Missing
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
*			Education attendance ('ilo_edu_attendance')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------


	gen ilo_edu_attendance=ed103
			label def edu_att_lab 1 "1 - Attending" 2 "2 - Not attending"
			label val ilo_edu_attendance edu_att_lab
			label var ilo_edu_attendance "Education (Attendance)"

			

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Disability status ('ilo_dsb')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
		*note there are some missing values that are coded as 9, these are forced to be not disabled
*nodata
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

	gen ilo_wap=.
		replace ilo_wap=1 if (ilo_age>=15 & ilo_age!=.)
			lab def wap_lab 1 "Working age population"
			lab val ilo_wap wap_lab
			label var ilo_wap "Working age population"

	drop ilo_age

	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Labour Force Status ('ilo_lfs')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* note temporary absence does not include info on duration, all temporary absentees are considered to be employed
* the way the questionaire is designed the seeking work question filters out the willing and available question
* therefore unemployment is obtained as seeking OR already found a job and are willing and available
*(willing & available is simply not asked to those who sought work) 
	gen ilo_lfs=.
		replace ilo_lfs=1 if ((ce401==1 | ce402==1 | ce403==1 ) & ilo_wap==1) 	// Employed
		replace ilo_lfs=2 if ilo_wap==1 & ilo_lfs!=1 & ( ce405==1 | (ce408==1 & ce409<3)  ) 	// Unemployed
		replace ilo_lfs=3 if ilo_lfs!=1 & ilo_lfs!=2 & ilo_wap==1  											// Outside the labour force
				label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside the Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status"


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_mjh=.
		replace ilo_mjh=1 if ce448==2 & ilo_lfs==1
		replace ilo_mjh=2 if ce448==1 & ilo_lfs==1
			lab def lab_ilo_mjh 1 "1 - One job only" 2 "2 - More than one job"
			lab val ilo_mjh lab_ilo_mjh
			lab var ilo_mjh "Multiple job holders"		
	
	

***********************************************************************************************
*			PART 3.1. ECONOMIC CHARACTERISTICS FOR MAIN JOB 
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Status in employment ('ilo_job1_ste')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

  * MAIN JOB:
	
	* Detailed categories:

		gen ilo_job1_ste_icse93=.
			replace ilo_job1_ste_icse93=1 if (ce432<4) & ilo_lfs==1		// Employees
			replace ilo_job1_ste_icse93=2 if inlist(ce432,6,7,10,11) & ilo_lfs==1		// Employers
			replace ilo_job1_ste_icse93=3 if inlist(ce432,5,9) & ilo_lfs==1		// Own-account workers
			replace ilo_job1_ste_icse93=4 if inlist(ce432,4,8) & ilo_lfs==1		// Members of cooperatives
			replace ilo_job1_ste_icse93=5 if inlist(ce432,12) & ilo_lfs==1		// Contributing family workers
			replace ilo_job1_ste_icse93=6 if ilo_job1_ste_icse93==. & ilo_lfs==1		// Not classifiable

				label def label_ilo_ste_icse93 1 "1 - Employees" 2 "2 - Employers" 3 "3 - Own-account workers"  ///
											   4 "4 - Members of producers cooperatives" 5 "5 - Contributing family workers" ///
											   6 "6 - Workers not classifiable by status"
				label val ilo_job1_ste_icse93 label_ilo_ste_icse93
				label var ilo_job1_ste_icse93 "Status in employment (ICSE 93)"

	* Aggregate categories 
		
		gen ilo_job1_ste_aggregate=.
			replace ilo_job1_ste_aggregate=1 if ilo_job1_ste_icse93==1				// Employees
			replace ilo_job1_ste_aggregate=2 if inrange(ilo_job1_ste_icse93,2,5)	// Self-employed
			replace ilo_job1_ste_aggregate=3 if ilo_job1_ste_icse93==6				// Not elsewhere classified
				lab def ste_aggr_lab 1 "1 - Employees" 2 "2 - Self-employed" 3 "3 - Not elsewhere classified"
				lab val ilo_job1_ste_aggregate ste_aggr_lab
				label var ilo_job1_ste_aggregate "Status in employment (Aggregate)"  

				


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

append using `labels'
	
* Note, it is defined as ISIC 3, not ISIC 3 Rev1
* I convert first the 3 standard to 3.1, notice that the mapping is not uniquely identified some
* asumption are made, in particular the minimum distance alternative is taken (the file use has been processed for this purpose)

	* 4 digit isic 3
if ${time} ==2015 {

gen ilo_job1_eco_isic4_2digits=trunc(ce428cod/100) if ilo_lfs==1
 replace ilo_job1_eco_isic4_2digits=. if ilo_job1_eco_isic4_2digits>99
 replace ilo_job1_eco_isic4_2digits=. if inlist(ilo_job1_eco_isic4_2digits,54)
 
 	lab values ilo_job1_eco_isic4_2digits isic4_2digits
	lab var ilo_job1_eco_isic4_2digits "Economic activity (ISIC Rev. 4), 2 digit level"

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
else {
generate rev3 = trunc(ce428cod/1000)

	merge n:1 rev3 using "archive\isic331.dta"
	drop if _merge==2
	drop _merge
	gen ilo_job1_eco_isic3_2digits=trunc(rev31/100) if ilo_lfs==1
	drop rev3 rev31
	
	lab values ilo_job1_eco_isic3_2digits isic3_2digits
	lab var ilo_job1_eco_isic3_2digits "Economic activity (ISIC Rev. 3.1), 2 digit level"

	
	* ISIC Rev. 3.1 

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
		replace ilo_job1_eco_isic3=18 if ilo_job1_eco_isic3_2digits==. & ilo_lfs==1
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
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_ocu') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
		/* Classification used: ISCO 88  */ 
		

		
if ${time} ==2015 {
gen ilo_job1_ocu_isco08_2digits=trunc(ce425cod/100) if (ilo_lfs==1) 
	replace ilo_job1_ocu_isco08_2digits=. if inlist(ilo_job1_ocu_isco08_2digits,5,9,47,98,99)

				* ISCO 08 - 2 digit
				lab values ilo_job1_ocu_isco08_2digits isco08_2digits
				lab var ilo_job1_ocu_isco08_2digits "Occupation (ISCO-08), 2 digit level"
		
		* ISCO 08 - 1 digit
			gen ilo_job1_ocu_isco08=.
				replace ilo_job1_ocu_isco08=1 if inrange(ilo_job1_ocu_isco08_2digits,10,19)
				replace ilo_job1_ocu_isco08=2 if inrange(ilo_job1_ocu_isco08_2digits,20,29)
				replace ilo_job1_ocu_isco08=3 if inrange(ilo_job1_ocu_isco08_2digits,30,39)
				replace ilo_job1_ocu_isco08=4 if inrange(ilo_job1_ocu_isco08_2digits,40,49)
				replace ilo_job1_ocu_isco08=5 if inrange(ilo_job1_ocu_isco08_2digits,50,59)
				replace ilo_job1_ocu_isco08=6 if inrange(ilo_job1_ocu_isco08_2digits,60,69)
				replace ilo_job1_ocu_isco08=7 if inrange(ilo_job1_ocu_isco08_2digits,70,79)
				replace ilo_job1_ocu_isco08=8 if inrange(ilo_job1_ocu_isco08_2digits,80,89)
				replace ilo_job1_ocu_isco08=9 if inrange(ilo_job1_ocu_isco08_2digits,90,99)
				replace ilo_job1_ocu_isco08=10 if inrange(ilo_job1_ocu_isco08_2digits,1,9)
				replace ilo_job1_ocu_isco08=11 if (ilo_job1_ocu_isco08==. & ilo_lfs==1)
					lab def isco08_1dig_lab 1 "1 - Managers" 2 "2 - Professionals" 3 "Technicians and associate professionals" 4 "4 - Clerical support workers" 5 "5 - Service and sales workers" ///
									6 "6 - Skilled agricultural, forestry and fishery workers" 7 "7 - Craft and related trades workers" 8 "8 - Plant and machine operators, and assemblers" ///
									9 "9 - Elementary occupations" 10 "0 - Armed forces occupations" 11 "X - Not elsewhere classified"
					lab val ilo_job1_ocu_isco08 isco08_1dig_lab
					lab var ilo_job1_ocu_isco08 "Occupation (ISCO-08)"		

		* Aggregate:			
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
					lab var ilo_job1_ocu_aggregate "Occupation (Aggregate) - Main job"	
					
					
		* Skill level
		recode ilo_job1_ocu_isco08 (1/3=3) (4/8=2) (9=1) (10/11=4) ,gen(ilo_job1_ocu_skill)
		lab def ilo_job1_ocu_skill 1 "1 - Skill level 1 (low)" 2 "2 - Skill level 2 (medium)" 3 "3 - Skill levels 3 and 4 (high)" 4 "4 - Not elsewhere classified"
		lab val ilo_job1_ocu_skill ilo_job1_ocu_skill
		lab var ilo_job1_ocu_skill "Occupation (Skill level)"
} 
else {
gen ilo_job1_ocu_isco88_2digits=trunc(ce425cod/100000) if (ilo_lfs==1)
	replace ilo_job1_ocu_isco88_2digits=. if inlist(ilo_job1_ocu_isco88_2digits,37,69)

	
		* ISCO 88 - 2 digit
			
			replace ilo_job1_ocu_isco88_2digits=. if ilo_job1_ocu_isco88_2digits>93
				lab values ilo_job1_ocu_isco88_2digits isco88_2digits
				lab var ilo_job1_ocu_isco88_2digits "Occupation (ISCO-88), 2 digit level"
		
		* ISCO 88 - 1 digit
			gen ilo_job1_ocu_isco88=.
				replace ilo_job1_ocu_isco88=1 if inrange(ilo_job1_ocu_isco88_2digits,11,14)
				replace ilo_job1_ocu_isco88=2 if inrange(ilo_job1_ocu_isco88_2digits,21,26)
				replace ilo_job1_ocu_isco88=3 if inrange(ilo_job1_ocu_isco88_2digits,31,35)
				replace ilo_job1_ocu_isco88=4 if inrange(ilo_job1_ocu_isco88_2digits,41,44)
				replace ilo_job1_ocu_isco88=5 if inrange(ilo_job1_ocu_isco88_2digits,51,54)
				replace ilo_job1_ocu_isco88=6 if inrange(ilo_job1_ocu_isco88_2digits,61,63)
				replace ilo_job1_ocu_isco88=7 if inrange(ilo_job1_ocu_isco88_2digits,71,75)
				replace ilo_job1_ocu_isco88=8 if inrange(ilo_job1_ocu_isco88_2digits,81,83)
				replace ilo_job1_ocu_isco88=9 if inrange(ilo_job1_ocu_isco88_2digits,91,96)
				replace ilo_job1_ocu_isco88=10 if inrange(ilo_job1_ocu_isco88_2digits,1,3)
				replace ilo_job1_ocu_isco88=11 if ilo_job1_ocu_isco88==. & ilo_lfs==1
					lab def isco88_1dig_lab 1 "1 - Managers" 2 "2 - Professionals" 3 "Technicians and associate professionals" 4 "4 - Clerical support workers" 5 "5 - Service and sales workers" ///
									6 "6 - Skilled agricultural, forestry and fishery workers" 7 "7 - Craft and related trades workers" 8 "8 - Plant and machine operators, and assemblers" ///
									9 "9 - Elementary occupations" 10 "0 - Armed forces occupations" 11 "X - Not elsewhere classified"
					lab val ilo_job1_ocu_isco88 isco88_1dig_lab
					lab var ilo_job1_ocu_isco88 "Occupation (ISCO-88)"		

		* Aggregate:			
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
		recode ilo_job1_ocu_isco88 (1/3=3) (4/8=2) (9=1) (10/11=4) ,gen(ilo_job1_ocu_skill)
		lab def ilo_job1_ocu_skill 1 "1 - Skill level 1 (low)" 2 "2 - Skill level 2 (medium)" 3 "3 - Skill levels 3 and 4 (high)" 4 "4 - Not elsewhere classified"
		lab val ilo_job1_ocu_skill ilo_job1_ocu_skill
		lab var ilo_job1_ocu_skill "Occupation (Skill level)"
}

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_job1_ins_sector')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
	
	
	* if the respondant does not know the variable is not defined - NGO's are set in private
		gen ilo_job1_ins_sector=.
			replace ilo_job1_ins_sector=1 if (inlist(ce432,1) & ilo_lfs==1)	// Public
			replace ilo_job1_ins_sector=2 if (inlist(ce432,2,3,4,5,6,7,8,9,10,11,12,13) & ilo_lfs==1)	// Private
			* forcing missing to private
			replace ilo_job1_ins_sector=2 if (ilo_job1_ins_sector==.& ilo_lfs==1)
				lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private" 
				lab values ilo_job1_ins_sector ins_sector_lab
				lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities"


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job1_job_time') -> Moved below for consistency with computed hours
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job1_job_contract')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
		
*** no info (mixed with duration are other characteristics such as written etc..)

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Formal / Informal Economy ('ilo_job1_ife_prod' 'ilo_job1_ife_nature') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			

	
	*** Generating the nodes, From left to right 1 directs to first direction in the diagram (usually formal), 0 to the second (usually informal), and -1 if aplicable to the third one. Only unique paths)
	* Note that the definition are meant to work with both informal sector and economy
	
	*** Preparing necessary variables - the variables must be adjusted to fit the data
	
	* based on the status question, unfortunately no further info on corporate sector is done, therefore all private are treated equally (except household)
	recode ce432 ( 1 = 1) (2 4 5 6 7 8 9 10 11 12 13=0) (3 = -1), gen(todrop_institutional) 		// theoretical 3 value node/ +1 Gov, Corporation, NGO, Embassy, IO / 0 Farm or private business, other, not asked, don't know, NA / -1 private household
								// Household sector identified in the status in employment question
	replace todrop_institutional=0 if todrop_institutional==. 						// if the absence of the created variable is due to complete absence informality should not be computed
	if ${time} ==2015 {
	replace todrop_institutional=-1 if ilo_job1_eco_isic4_2digits==97|ilo_job1_ocu_isco08_2digits==63
	}
	else {
	replace todrop_institutional=-1 if ilo_job1_eco_isic3_2digits==95|ilo_job1_ocu_isco88_2digits==62
	}
	
	
	gen todrop_destinationprod=1 													// theoretical 2 value node / +1 At least partially market or Other, Not asked, Don't Know, NA/  0 Only for own final use (household) 
	
	
	gen todrop_producesforsale=1 													//  theoretical 2 value node / +1 Yes product for sale, Other, Not asked, Don't Know, NA/ 0 No, not for sale 
	replace todrop_producesforsale=0 if inlist(ce445,1)
	
	gen todrop_bookkeeping=.			// theoretical 2 value node/ +1 keeps accounts for GOV/ 0 does not keep accounts or personal use or other, not asked, DK, NA  
	egen todrop_pro_book=rowtotal(ce444_1-ce444_4)
	replace todrop_bookkeeping=1 if todrop_pro_book>0
	replace todrop_bookkeeping=0 if todrop_bookkeeping==.

	


	gen todrop_registration=.												// theoretical 3 value node/ +1 registered national level/ 0 not registered national level, other, DK / -1 not asked NA
		replace todrop_registration=-1 if todrop_registration==.


	gen todrop_SS=1 if ce438_1==1|ce438_2==2  														// theoretical 3 value node/ +1 Social security/ 0 Not asked or don't know NA Other / -1 No social security 
		replace todrop_SS=-1 if todrop_SS==. 
		replace todrop_SS=0 if todrop_SS==.


		
	gen todrop_place=1 if inlist(ce443,3)										// theoretical 2 value node/ +1 fixed visible premises / 0 non fixed premises 
		replace todrop_place=0 if todrop_place==.
	
	*note that cuttof for size is at the 10 workers level
	gen todrop_size=1 if inlist(ce431,2,3,4)										// theoretical 2 value node/ +1 equal or more than 6 workers / 0 less than 6 workers
	replace todrop_size=0 if inlist(ce431,1)
		
	gen todrop_paidleave=0									// theoretical 2 value node/ +1 paid leave / 0 no paid leave, not asked , DK, NA
		replace todrop_paidleave=0 if todrop_paidleave==.
		
	gen todrop_paidsick=0									// theoretical 2 value node/ +1 sick leave / 0 no sick leave, not asked, DK, NA
		replace todrop_paidsick=0 if todrop_paidsick==.
		

	**** Exception to force non employees without size-place data to informal
	*replace todrop_registration = 0 if ilo_lfs==1&todrop_institutional==0&todrop_destinationprod==1&todrop_bookkeeping==0&todrop_registration==-1&ilo_job1_ste_icse93!=1&(todrop_size==.|todrop_place==.)
	
	***********************************************************
	*** Obtention variables, this part should NEVER be modified
	***********************************************************
	* 1) Unit of production - Formal / Informal Sector
	
		/*the code is not condensed through ORs (for values of the same variables it is used but not for combinations of variables) or ellipsis for clarity (of concept) */

			gen ilo_job1_ife_prod=.
			
			* Formal
				replace ilo_job1_ife_prod = 2 if ilo_lfs==1&todrop_institutional==1
				replace ilo_job1_ife_prod = 2 if ilo_lfs==1&todrop_institutional==0&todrop_destinationprod==1&todrop_bookkeeping==1
				replace ilo_job1_ife_prod = 2 if ilo_lfs==1&todrop_institutional==0&todrop_destinationprod==1&todrop_bookkeeping==0&todrop_registration==1
				replace ilo_job1_ife_prod = 2 if ilo_lfs==1&todrop_institutional==0&todrop_destinationprod==1&todrop_bookkeeping==0&todrop_registration==-1&ilo_job1_ste_icse93==1&todrop_SS==1
				replace ilo_job1_ife_prod = 2 if ilo_lfs==1&todrop_institutional==0&todrop_destinationprod==1&todrop_bookkeeping==0&todrop_registration==-1&ilo_job1_ste_icse93==1&todrop_SS!=1&todrop_place==1&todrop_size==1
				replace ilo_job1_ife_prod = 2 if ilo_lfs==1&todrop_institutional==0&todrop_destinationprod==1&todrop_bookkeeping==0&todrop_registration==-1&ilo_job1_ste_icse93!=1&todrop_place==1&todrop_size==1
			* HH	
				replace ilo_job1_ife_prod = 3 if ilo_lfs==1&todrop_institutional==-1
				replace ilo_job1_ife_prod = 3 if ilo_lfs==1&todrop_institutional==0&todrop_destinationprod==0
			* Informal	
				replace ilo_job1_ife_prod = 1 if ilo_lfs==1&todrop_institutional==0&todrop_destinationprod==1&todrop_bookkeeping==0&todrop_registration==0
				replace ilo_job1_ife_prod = 1 if ilo_lfs==1&todrop_institutional==0&todrop_destinationprod==1&todrop_bookkeeping==0&todrop_registration==-1&ilo_job1_ste_icse93==1&todrop_SS!=1&todrop_place==0
				replace ilo_job1_ife_prod = 1 if ilo_lfs==1&todrop_institutional==0&todrop_destinationprod==1&todrop_bookkeeping==0&todrop_registration==-1&ilo_job1_ste_icse93==1&todrop_SS!=1&todrop_place==1&todrop_size==0
				replace ilo_job1_ife_prod = 1 if ilo_lfs==1&todrop_institutional==0&todrop_destinationprod==1&todrop_bookkeeping==0&todrop_registration==-1&ilo_job1_ste_icse93!=1&todrop_place==0
				replace ilo_job1_ife_prod = 1 if ilo_lfs==1&todrop_institutional==0&todrop_destinationprod==1&todrop_bookkeeping==0&todrop_registration==-1&ilo_job1_ste_icse93!=1&todrop_place==1&todrop_size==0
				* note, special loop for employees. If we have data on social security, and they say NO or don't know, and still we do not have a complete pair Size-Place of Work, they should go to informal
				replace ilo_job1_ife_prod = 1 if ilo_lfs==1&todrop_institutional==0&todrop_destinationprod==1&todrop_bookkeeping==0&todrop_registration==-1&ilo_job1_ste_icse93==1&todrop_SS==-1&(todrop_size==.|todrop_place==.)
				
			lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 
			lab val ilo_job1_ife_prod ilo_ife_prod_lab
			lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"


	* 2) Nature of job - Formal / Informal Job
	* note that the variable of informal/formal sector does not follow the node notation
			gen ilo_job1_ife_nature=.
			
			*Formal
				*Employee
				replace ilo_job1_ife_nature=2 if ilo_lfs==1&(ilo_job1_ste_icse93==1|ilo_job1_ste_icse93==6)&todrop_SS==1
				replace ilo_job1_ife_nature=2 if ilo_lfs==1&(ilo_job1_ste_icse93==1|ilo_job1_ste_icse93==6)&todrop_SS==0&todrop_paidleave==1&todrop_paidsick==1
				*Employers or Members of coop
				replace ilo_job1_ife_nature=2 if ilo_lfs==1&(ilo_job1_ste_icse93==2|ilo_job1_ste_icse93==4)&ilo_job1_ife_prod==2	
				*OAW
				replace ilo_job1_ife_nature=2 if ilo_lfs==1&ilo_job1_ste_icse93==3&todrop_producesforsale==1&ilo_job1_ife_prod==2
			* Informal
				*Employee
				replace ilo_job1_ife_nature=1 if ilo_lfs==1&(ilo_job1_ste_icse93==1|ilo_job1_ste_icse93==6)&todrop_SS==-1
				replace ilo_job1_ife_nature=1 if ilo_lfs==1&(ilo_job1_ste_icse93==1|ilo_job1_ste_icse93==6)&todrop_SS==0&todrop_paidleave==0
				replace ilo_job1_ife_nature=1 if ilo_lfs==1&(ilo_job1_ste_icse93==1|ilo_job1_ste_icse93==6)&todrop_SS==0&todrop_paidleave==1&todrop_paidsick==0
				*Employers or Members of coop
				replace ilo_job1_ife_nature=1 if ilo_lfs==1&(ilo_job1_ste_icse93==2|ilo_job1_ste_icse93==4)&(ilo_job1_ife_prod==1|ilo_job1_ife_prod==3)
				*OAW
				replace ilo_job1_ife_nature=1 if ilo_lfs==1&ilo_job1_ste_icse93==3&todrop_producesforsale==1&(ilo_job1_ife_prod==1|ilo_job1_ife_prod==3)
				replace ilo_job1_ife_nature=1 if ilo_lfs==1&ilo_job1_ste_icse93==3&todrop_producesforsale==0
			*Contributing Family Workers
				replace ilo_job1_ife_nature=1 if ilo_lfs==1&ilo_job1_ste_icse93==5
				

						lab def ife_nature_lab 1 "1 - Persons with informal main job" 2 "2 - Persons with formal main job"
						lab val ilo_job1_ife_nature ife_nature_lab
						lab var ilo_job1_ife_nature "Informal / Formal Economy (Nature of job) - Main job"
			*rename *todrop* *tokeep*

			capture drop todrop* 
	***********************************************************
	*** End informality****************************************
	***********************************************************

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Hours of work ('ilo_job1_how')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		


* Main job:

* 1) Weekly hours ACTUALLY worked - Main job
		
gen ilo_job1_how_actual=ce429 if (ilo_lfs==1&ce429<169)
					*to avoid missing values of workers that were temporary absent
					replace ilo_job1_how_actual=0 if ilo_lfs==1&ilo_job1_how_actual==.
					lab var ilo_job1_how_actual "Weekly hours actually worked in main job"

		
* 2) Weekly hours USUALLY worked , notice that it has to be obtained as a differential
			gen ilo_job1_how_usual=ce430 if (ilo_lfs==1&ce430<169)
			replace ilo_job1_how_usual=ilo_job1_how_actual if ilo_lfs==1 & ilo_job1_how_usual==.
					lab var ilo_job1_how_usual "Weekly hours usually worked in main job"
					
* Secondary job - actual
			gen ilo_job2_how_actual=ce453 if (ilo_mjh==2&ilo_lfs==1)&ce453<169
				lab var ilo_job2_how_actual "Weekly hours actually worked in second job"


* All jobs - actual

			egen ilo_joball_how_actual=rowtotal(ilo_job1_how_actual ilo_job2_how_actual) if (ilo_lfs==1)
				replace ilo_joball_how_actual=. if ilo_joball_how_actual>168
				lab var ilo_joball_how_actual "Weekly hours actually worked in all jobs"


		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job1_job_time') <- Moved here to be able to use the computed hours
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			

	/* Threshold of 40 hours per week 	*/

			gen ilo_job1_job_time=.
				replace ilo_job1_job_time=1 if (ilo_job1_how_actual<40 & ilo_lfs==1) 	// Part-time
				replace ilo_job1_job_time=2 if (ilo_job1_how_actual>39&ilo_job1_how_actual!=. & ilo_lfs==1)	// Full-time
				replace ilo_job1_job_time=3 if (ilo_job1_how_actual==. & ilo_lfs==1)	// Unknown
					lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
					lab val ilo_job1_job_time job_time_lab
					lab var ilo_job1_job_time "Job (Working time arrangement) - Main job"	



* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Monthly labour related income ('ilo_joball_lri')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			

			* Main job
			gen todrop_wage=ce440 if ce439==1
				replace todrop_wage=ce440*4.333333333333/2 if ce439==2
				replace todrop_wage=ce440*4.3333333333333 if ce439==3
				replace todrop_wage=ce440*4.333333333333*7 if ce439==4
				* Employees
					gen ilo_job1_lri_ees=todrop_wage if (ilo_job1_ste_aggregate==1)
						replace ilo_job1_lri_ees=. if ilo_job1_lri_ees==0 
							lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"	
				
				* Self-employed
				*not computed, in the questionaire we have only gross income or self use of company funds
					*gen ilo_job1_lri_slf=e01aimde if (e01aimde<900000000 & inlist(ilo_job1_ste_icse93,2,3,4,6))
						*replace ilo_job1_lri_slf=. if ilo_job1_lri_slf==0
							*lab var ilo_job1_lri_slf "Monthly earnings of self-employed in main job"


			drop todrop*
***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_joball_tru') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

		gen ilo_joball_tru=.
		* notice that the question bunches together willing and available
			replace ilo_joball_tru=1 if ilo_joball_how_actual<35 & ce472==1 & ilo_lfs==1
			lab def tru_lab 1 "Time-related underemployment"
			lab val ilo_joball_tru tru_lab
			lab var ilo_joball_tru "Time-related underemployment"	
		

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupational injury ('ilo_joball_inj')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
		
* Not available

***********************************************************************************************
*			PART 3.3. UNEMPLOYMENT: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Category of unemployment ('ilo_cat_une')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	gen ilo_cat_une=.
		replace ilo_cat_une=1 if (ce412==1&ilo_lfs==2)
		replace ilo_cat_une=2 if (ce412==2&ilo_lfs==2)
		replace ilo_cat_une=3 if (ilo_cat_une==.&ilo_lfs==2)
				lab def ilo_cat_une 1 "Unemployed previously employed" 2 "Unemployed seeking first job" 3 "Unknown"
				lab val ilo_cat_une ilo_cat_une
				lab var ilo_cat_une "Category of unemployment"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen todrop1=ce411 if ce411tiempo == 3
	gen todrop2=ce411/4.33 if ce411tiempo == 2
	gen todrop4=ce411/(4.33*7) if ce411tiempo == 1
	egen todrop=rowtotal(todrop*)
	replace todrop=. if todrop==0
	
	gen todropB1=ce417 if ce417_tiempo == 3
	gen todropB2=ce417/4.33 if ce417_tiempo == 2
	gen todropB3=ce417*12 if ce417_tiempo == 4
	gen todropB4=ce417/(4.33*7) if ce417_tiempo == 1
	egen todropB=rowtotal(todropB*)
	replace todropB=. if todropB==0

	* Seeking or without employment, whichever is shorter
	*using as a base seeking due to scope
	replace todrop=todropB if todropB<todrop
	
	gen ilo_dur_details=.
				replace ilo_dur_details=1 if (todrop<1 & ilo_lfs==2)
				replace ilo_dur_details=2 if (inrange(todrop,1,2.999999) & ilo_lfs==2)
				replace ilo_dur_details=3 if (inrange(todrop,3,5.999999) & ilo_lfs==2)
				replace ilo_dur_details=4 if (inrange(todrop,6,11.999999) & ilo_lfs==2)
				replace ilo_dur_details=5 if (inrange(todrop,12,23.999999) & ilo_lfs==2)
				replace ilo_dur_details=6 if (inrange(todrop,24,1440) & ilo_lfs==2)
				replace ilo_dur_details=7 if (ilo_dur_details==. & ilo_lfs==2)
					lab def ilo_unemp_det 1 "Less than 1 month" 2 "1 month to less than 3 months" 3 "3 months to less than 6 months" ///
											4 "6 months to less than 12 months" 5 "12 months to less than 24 months" 6 "24 months or more" ///
											7 "Not elsewhere classified"
					lab val ilo_dur_details ilo_unemp_det
					lab var ilo_dur_details "Duration of unemployment (Details)"

	gen ilo_dur_aggregate=.
				replace ilo_dur_aggregate=1 if (inlist(ilo_dur_details,1,2,3) & ilo_lfs==2)
				replace ilo_dur_aggregate=2 if (ilo_dur_details==4 & ilo_lfs==2)
				replace ilo_dur_aggregate=3 if (inlist(ilo_dur_details,5,6) & ilo_lfs==2)
				replace ilo_dur_aggregate=4 if (ilo_dur_details==7 & ilo_lfs==2)
					lab def ilo_unemp_aggr 1 "Less than 6 months" 2 "6 months to less than 12 months" 3 "12 months or more" 4 "Not elsewhere classified"
					lab val ilo_dur_aggregate ilo_unemp_aggr
					lab var ilo_dur_aggregate "Duration of unemployment (Aggregate)"
	drop todrop*

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_aggregate')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

if ${time} ==2015 {
generate ilo_preveco_isic4_2digits = trunc(ce416cod/100) if ilo_lfs==2 & ilo_cat_une==1

	lab values ilo_preveco_isic4_2digits isic4_2digits
	lab var ilo_preveco_isic4_2digits "Economic activity (ISIC Rev. 4), 2 digit level"
	
	
	gen ilo_preveco_isic4=.
			replace ilo_preveco_isic4=1 if inrange(ilo_preveco_isic4_2digits,1,3)
			replace ilo_preveco_isic4=2 if inrange(ilo_preveco_isic4_2digits,5,9)
			replace ilo_preveco_isic4=3 if inrange(ilo_preveco_isic4_2digits,10,33)
			replace ilo_preveco_isic4=4 if ilo_preveco_isic4_2digits==35
			replace ilo_preveco_isic4=5 if inrange(ilo_preveco_isic4_2digits,36,39)
			replace ilo_preveco_isic4=6 if inrange(ilo_preveco_isic4_2digits,41,43)
			replace ilo_preveco_isic4=7 if inrange(ilo_preveco_isic4_2digits,45,47)
			replace ilo_preveco_isic4=8 if inrange(ilo_preveco_isic4_2digits,49,53)
			replace ilo_preveco_isic4=9 if inrange(ilo_preveco_isic4_2digits,55,56)
			replace ilo_preveco_isic4=10 if inrange(ilo_preveco_isic4_2digits,58,63)
			replace ilo_preveco_isic4=11 if inrange(ilo_preveco_isic4_2digits,64,66)
			replace ilo_preveco_isic4=12 if ilo_preveco_isic4_2digits==68
			replace ilo_preveco_isic4=13 if inrange(ilo_preveco_isic4_2digits,69,75)
			replace ilo_preveco_isic4=14 if inrange(ilo_preveco_isic4_2digits,77,82)
			replace ilo_preveco_isic4=15 if ilo_preveco_isic4_2digits==84
			replace ilo_preveco_isic4=16 if ilo_preveco_isic4_2digits==85
			replace ilo_preveco_isic4=17 if inrange(ilo_preveco_isic4_2digits,86,88)
			replace ilo_preveco_isic4=18 if inrange(ilo_preveco_isic4_2digits,90,93)
			replace ilo_preveco_isic4=19 if inrange(ilo_preveco_isic4_2digits,94,96)
			replace ilo_preveco_isic4=20 if inrange(ilo_preveco_isic4_2digits,97,98)
			replace ilo_preveco_isic4=21 if ilo_preveco_isic4_2digits==99
			replace ilo_preveco_isic4=22 if ilo_preveco_isic4_2digits==. & ilo_lfs==2 & ilo_cat_une==1
				lab val ilo_preveco_isic4 isic4
				lab var ilo_preveco_isic4 "Economic activity (ISIC Rev. 4)"
				
		
	* Now do the classification on an aggregate level
	
		* Primary activity
		
		gen ilo_preveco_aggregate=.
			replace ilo_preveco_aggregate=1 if ilo_preveco_isic4==1
			replace ilo_preveco_aggregate=2 if ilo_preveco_isic4==3
			replace ilo_preveco_aggregate=3 if ilo_preveco_isic4==6
			replace ilo_preveco_aggregate=4 if inlist(ilo_preveco_isic4,2,4,5)
			replace ilo_preveco_aggregate=5 if inrange(ilo_preveco_isic4,7,14)
			replace ilo_preveco_aggregate=6 if inrange(ilo_preveco_isic4,15,21)
			replace ilo_preveco_aggregate=7 if ilo_preveco_isic4==22
				lab val ilo_preveco_aggregate eco_aggr_lab
				lab var ilo_preveco_aggregate "Economic activity (Aggregate)"


} 
else {
generate rev3 = trunc(ce416cod/1000)


	* 4 digit isic 3

	merge n:1 rev3 using "archive\isic331.dta"
	drop if _merge==2
	drop _merge
	gen ilo_preveco_isic3_2digits=trunc(rev31/100) if ilo_lfs==2 & ilo_cat_une==1
	drop rev3 rev31
	lab values ilo_preveco_isic3_2digits isic3_2digits
	lab var ilo_preveco_isic3_2digits "Economic activity (ISIC Rev. 3.1), 2 digit level"

	
	* ISIC Rev. 3.1 

gen ilo_preveco_isic3=.
		replace ilo_preveco_isic3=1 if inrange(ilo_preveco_isic3_2digits,1,2)
		replace ilo_preveco_isic3=2 if ilo_preveco_isic3_2digits==5
		replace ilo_preveco_isic3=3 if inrange(ilo_preveco_isic3_2digits,10,14)
		replace ilo_preveco_isic3=4 if inrange(ilo_preveco_isic3_2digits,15,37)
		replace ilo_preveco_isic3=5 if inrange(ilo_preveco_isic3_2digits,40,41)
		replace ilo_preveco_isic3=6 if ilo_preveco_isic3_2digits==45
		replace ilo_preveco_isic3=7 if inrange(ilo_preveco_isic3_2digits,50,52)
		replace ilo_preveco_isic3=8 if ilo_preveco_isic3_2digits==55
		replace ilo_preveco_isic3=9 if inrange(ilo_preveco_isic3_2digits,60,64)
		replace ilo_preveco_isic3=10 if inrange(ilo_preveco_isic3_2digits,65,67)
		replace ilo_preveco_isic3=11 if inrange(ilo_preveco_isic3_2digits,70,74)
		replace ilo_preveco_isic3=12 if ilo_preveco_isic3_2digits==75
		replace ilo_preveco_isic3=13 if ilo_preveco_isic3_2digits==80
		replace ilo_preveco_isic3=14 if ilo_preveco_isic3_2digits==85
		replace ilo_preveco_isic3=15 if inrange(ilo_preveco_isic3_2digits,90,93)
		replace ilo_preveco_isic3=16 if ilo_preveco_isic3_2digits==95
		replace ilo_preveco_isic3=17 if ilo_preveco_isic3_2digits==99
		replace ilo_preveco_isic3=18 if ilo_preveco_isic3_2digits==. & ilo_lfs==2 & ilo_cat_une==1
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
			lab val ilo_preveco_aggregate eco_aggr_lab
			lab var ilo_preveco_aggregate "Economic activity (Aggregate)"
}	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu_isco88')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

if ${time} ==2015 {
gen ilo_prevocu_isco08_2digits=trunc(ce415cod/100) if (ilo_lfs==2&ilo_cat_une==1)
		* ISCO 08 - 1 digit
			gen ilo_prevocu_isco08=.
				replace ilo_prevocu_isco08=1 if inrange(ilo_prevocu_isco08_2digits,10,19)
				replace ilo_prevocu_isco08=2 if inrange(ilo_prevocu_isco08_2digits,20,29)
				replace ilo_prevocu_isco08=3 if inrange(ilo_prevocu_isco08_2digits,30,39)
				replace ilo_prevocu_isco08=4 if inrange(ilo_prevocu_isco08_2digits,40,49)
				replace ilo_prevocu_isco08=5 if inrange(ilo_prevocu_isco08_2digits,50,59)
				replace ilo_prevocu_isco08=6 if inrange(ilo_prevocu_isco08_2digits,60,69)
				replace ilo_prevocu_isco08=7 if inrange(ilo_prevocu_isco08_2digits,70,79)
				replace ilo_prevocu_isco08=8 if inrange(ilo_prevocu_isco08_2digits,80,89)
				replace ilo_prevocu_isco08=9 if inrange(ilo_prevocu_isco08_2digits,90,99)
				replace ilo_prevocu_isco08=10 if inrange(ilo_prevocu_isco08_2digits,1,9)
				replace ilo_prevocu_isco08=11 if (ilo_prevocu_isco08==. & ilo_lfs==2&ilo_cat_une==1)
					lab val ilo_prevocu_isco08 isco08_1dig_lab
					lab var ilo_prevocu_isco08 "Occupation (ISCO-08)"		

		* Aggregate:			
			gen ilo_prevocu_aggregate=.
				replace ilo_prevocu_aggregate=1 if inrange(ilo_prevocu_isco08,1,3)
				replace ilo_prevocu_aggregate=2 if inlist(ilo_prevocu_isco08,4,5)
				replace ilo_prevocu_aggregate=3 if inlist(ilo_prevocu_isco08,6,7)
				replace ilo_prevocu_aggregate=4 if ilo_prevocu_isco08==8
				replace ilo_prevocu_aggregate=5 if ilo_prevocu_isco08==9
				replace ilo_prevocu_aggregate=6 if ilo_prevocu_isco08==10
				replace ilo_prevocu_aggregate=7 if ilo_prevocu_isco08==11
					lab val ilo_prevocu_aggregate ocu_aggr_lab
					lab var ilo_prevocu_aggregate "Occupation (Aggregate) - Main job"	
					
					
		* Skill level
		recode ilo_prevocu_isco08 (1/3=3) (4/8=2) (9=1) (10/11=4) ,gen(ilo_prevocu_skill)
		lab val ilo_prevocu_skill ilo_prevocu_skill
		lab var ilo_prevocu_skill "Occupation (Skill level)"
} 
else {
gen ilo_prevocu_isco88_2digits=trunc(ce415cod/100000) if (ilo_lfs==2&ilo_cat_une==1)

		* ISCO 88 - 2 digit
			
			replace ilo_prevocu_isco88_2digits=. if ilo_prevocu_isco88_2digits>93
				lab values ilo_prevocu_isco88_2digits isco88_2digits
				lab var ilo_prevocu_isco88_2digits "Occupation (ISCO-88), 2 digit level"
		
		* ISCO 88 - 1 digit
			gen ilo_prevocu_isco88=.
				replace ilo_prevocu_isco88=1 if inrange(ilo_prevocu_isco88_2digits,11,14)
				replace ilo_prevocu_isco88=2 if inrange(ilo_prevocu_isco88_2digits,21,26)
				replace ilo_prevocu_isco88=3 if inrange(ilo_prevocu_isco88_2digits,31,35)
				replace ilo_prevocu_isco88=4 if inrange(ilo_prevocu_isco88_2digits,41,44)
				replace ilo_prevocu_isco88=5 if inrange(ilo_prevocu_isco88_2digits,51,54)
				replace ilo_prevocu_isco88=6 if inrange(ilo_prevocu_isco88_2digits,61,63)
				replace ilo_prevocu_isco88=7 if inrange(ilo_prevocu_isco88_2digits,71,75)
				replace ilo_prevocu_isco88=8 if inrange(ilo_prevocu_isco88_2digits,81,83)
				replace ilo_prevocu_isco88=9 if inrange(ilo_prevocu_isco88_2digits,91,96)
				replace ilo_prevocu_isco88=10 if inrange(ilo_prevocu_isco88_2digits,1,3)
				replace ilo_prevocu_isco88=11 if ilo_prevocu_isco88==. & ilo_lfs==2&ilo_cat_une==1
					lab val ilo_prevocu_isco88 isco88_1dig_lab
					lab var ilo_prevocu_isco88 "Occupation (ISCO-88)"		

		* Aggregate:			
			gen ilo_prevocu_aggregate=.
				replace ilo_prevocu_aggregate=1 if inrange(ilo_prevocu_isco88,1,3)
				replace ilo_prevocu_aggregate=2 if inlist(ilo_prevocu_isco88,4,5)
				replace ilo_prevocu_aggregate=3 if inlist(ilo_prevocu_isco88,6,7)
				replace ilo_prevocu_aggregate=4 if ilo_prevocu_isco88==8
				replace ilo_prevocu_aggregate=5 if ilo_prevocu_isco88==9
				replace ilo_prevocu_aggregate=6 if ilo_prevocu_isco88==10
				replace ilo_prevocu_aggregate=7 if ilo_prevocu_isco88==11
					lab val ilo_prevocu_aggregate ocu_aggr_lab
					lab var ilo_prevocu_aggregate "Occupation (Aggregate) - Main job"	
					
					
		* Skill level
		recode ilo_prevocu_isco88 (1/3=3) (4/8=2) (9=1) (10/11=4) ,gen(ilo_prevocu_skill)
		lab val ilo_prevocu_skill ilo_job1_ocu_skill
		lab var ilo_prevocu_skill "Occupation (Skill level)"
}

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			General social protection ('ilo_gsp_uneschemes')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

	****** No information available in the questionnaire ******

	

***********************************************************************************************
*			PART 3.4. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************		

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
	*note, this cannot be adequately obtained
	*willing and available are bunched in the same question -> category 3 cannot be obtained
	*seeking is used as the scope for Willing&Available -> category 1 cannot be obtained
	gen ilo_olf_dlma=.
		*replace ilo_olf_dlma = 1 if (a05==6&a07==1)&ilo_lfs==3							 	//Seeking, not available
		replace ilo_olf_dlma = 2 if (ce405==2&ce408==1)&ilo_lfs==3								//Not seeking, available
		*replace ilo_olf_dlma = 3 if (a05==6&a07==6&inlist(a09,2,3,4,8,9,10) )&ilo_lfs==3  	//Not seeking, not available, willing (Willing non-job seekers) 
		replace ilo_olf_dlma = 4 if  ce405==2&ce408==2&ilo_lfs==3			//Not seeking, not available, not willing (Non-Willigness based reasons for not being available) 
		replace ilo_olf_dlma = 5 if	(ilo_olf_dlma==.) & ilo_lfs==3			// Not classified 
	
			lab def dlma_lab 1 "1 - Seeking, not available (Unavailable jobseekers)" 2 "2 - Not seeking, available (Available potential jobseekers)" ///
							 3 "3 - Not seeking, not available, willing (Willing non-jobseekers)" 4 "4 - Not seeking, not available, not willing" 5 "X - Not elsewhere classified"
			lab val ilo_olf_dlma dlma_lab 
			lab var ilo_olf_dlma "Labour market attachment (Degree of)"


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reason for not seeking job ('ilo_olf_reason')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* note that given the structure of the data the reason for not seeking the past week (USED IN THE UNEMPLOYMENT DEFINITION) is bunched together with not seeking past 4 weeks (NOT USED)
	gen ilo_olf_reason=.
		replace ilo_olf_reason=1 if	(inlist(ce409,6) & ilo_lfs==3)					//Labour market
		replace ilo_olf_reason=2 if	(inlist(ce409,1,2,3,4) & ilo_lfs==3)					//Labour market
		replace ilo_olf_reason=3 if	(inlist(ce409,5,7,9,10,11,12,15)  & ilo_lfs==3)				//Personal/Family-related
		replace ilo_olf_reason=4 if (inlist(ce409,13,14)  & ilo_lfs==3)							//Does not need/want to work
		replace ilo_olf_reason=5 if (inlist(ce409,8,16)  & ilo_lfs==3)						//Not elsewhere classified
		replace ilo_olf_reason=5 if (ilo_olf_reason==. & ilo_lfs==3)								//Not elsewhere classified
			lab def reasons_lab 1 "1 - Labour market" 2 "2 - Other labour market reasons" 3 "3 - Personal / Family-related" 4 "4 - Does not need/want to work" 5 "5 - Not elsewhere classified"
			lab val ilo_olf_reason reasons_lab 
			lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"
			

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seeker ('ilo_dis')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

	gen ilo_dis=1 if  ilo_olf_reason==1
			lab def dis_lab 1 "Discouraged job-seekers"
			lab val ilo_dis dis_lab
			lab var ilo_dis "Discouraged job-seekers"
			

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training ('ilo_neet')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

	gen ilo_neet=1 if (ilo_age_aggregate==2 & ilo_lfs!=1 & ilo_edu_attendance==2)
			lab def neet_lab 1 "Youth not in education, employment or training"
			lab val ilo_neet neet_lab
			lab var ilo_neet "Youth not in education, employment or training"
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Drop intermediate variables used for labeling activity and occupation
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
capture drop isco08_2digits isco88_2digits isco08 isco88 isic4_2digits isic4 isic3_2digits isic3

**** Removing added observations (due to labels) and added variables (due to homogenization)

drop if original!=1
drop original


***********************************************************************************************
***********************************************************************************************

*			3. SAVE ILO-VARIABLES IN A NEW DATASET

***********************************************************************************************
***********************************************************************************************

* -------------------------------------------------------------
* 	Prepare final datasets
* -------------------------------------------------------------


* 1 - Full dataset with original variables and ILO ones
	
	cd "$outpath"

        compress
		save ${country}_${source}_${time}_FULL,  replace		

* 2 - Dataset with only 'ILO' variables
	
		keep ilo*
		save ${country}_${source}_${time}_ILO, replace
