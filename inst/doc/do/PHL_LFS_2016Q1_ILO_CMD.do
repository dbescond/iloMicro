* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Philippines
* DATASET USED: Philippines LFS 
* NOTES: 
* Files created: Standard variables on LFS Philippines
* Authors: Podjanin
* Who last updated the file: Podjanin, A.
* Starting Date: 28 June 2017
* Last updated: 10 July 2017
***********************************************************************************************


*******************************************************************
 /* 1.	Set up work directory, file name, variables and function */
*******************************************************************


clear all 

set more off

global path "J:\COMMON\STATISTICS\DPAU\MICRO"
global country "PHL"
global source "LFS"
global time "2016Q1"
global inputFile "PHL_LFS_2016Q1_ORI.dta"

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
	
*********************************************************************************************

* Create help variables for the time period considered
	
	gen time = "${time}"
	split time, gen(time_) parse(Q)
	rename (time_1 time_2) (year quarter)
	destring year quarter, replace
	
* Don't define ilo_* variables for overseas workers and people employed in Filipino embassies and consulates

	capture confirm var c10_conwr 
	
		if !_rc {

	gen considered=1 if !inlist(c10_conwr,1,3,5)
		}
		
		else {
		
	gen considered=1 if !inlist(c10_cnwr,1,3,5)
	
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

	gen ilo_key=_n if considered==1
		lab var ilo_key "Key unique identifier per individual"
	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sample Weight ('ilo_wgt') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*		
* Comment: 

	if year==2016 & inlist(quarter,2,3) {
	
	gen ilo_wgt=pwgt
		lab var ilo_wgt "Sample weight"
		
			}
			
		else {
		
	capture confirm var fwgt
		if !_rc {
		
	gen ilo_wgt=fwgt
		lab var ilo_wgt "Sample weight"
			}
		
		else {
	gen ilo_wgt=pwgt/4000
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
			replace ilo_geo=1 if urb2k==2
			replace ilo_geo=2 if urb2k==1
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

		gen ilo_sex=.
			
			capture confirm var c06_sex
				if !_rc {
			replace ilo_sex=1 if c06_sex==2
			replace ilo_sex=2 if c06_sex==1
				}
				else {	
			replace ilo_sex=1 if c04_sex==2
			replace ilo_sex=2 if c04_sex==1
				}
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

	if time=="2016Q1" {
		
	decode c07_age, gen (age)
	
		destring age, replace force
		
		drop c07_age 
		
		rename age c07_age
		
	gen ilo_age=c07_age
		lab var ilo_age "Age"
		
			}
			
		else {
		
	capture confirm var c07_age
		if !_rc {
		
	gen ilo_age=c07_age
		lab var ilo_age "Age"
			}
	
	else {

	gen ilo_age=c05_age
		lab var ilo_age "Age"
			}
			}

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

		* refer to value label and not to code contained in any questionnaire...! 


		* for 2016Q1 j12c09_grade --> redefine education --> find a precise mapping, as value labels here don't allow to distinguish between courses associated 
			* with secondary education and tertiary education... 
		
	capture confirm var c07_grade 
	
		if !_rc {
			
	gen ilo_edu_isced97=.
		replace ilo_edu_isced97=1 if c07_grade==57
		replace ilo_edu_isced97=2 if inlist(c07_grade,54,58,81,33,34,38,39,40,41,42,43,44,45,46,47)
		replace ilo_edu_isced97=3 if inlist(c07_grade,48,49,83)
		replace ilo_edu_isced97=4 if inlist(c07_grade,50,51,52,29,85,89,35,36,37,82)
		replace ilo_edu_isced97=5 if inlist(c07_grade,53,50,86,32,30,28,84,88,31)
		replace ilo_edu_isced97=6 if inrange(c07_grade,59,80)
		replace ilo_edu_isced97=7 if inrange(c07_grade,1,24) | inlist(c07_grade,27,87)
		replace ilo_edu_isced97=8 if inlist(c07_grade,25,26,55,56)
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
			}
			
			
		else {
		
		capture confirm var j12c09_grade 
			if !_rc {
			
		j12c09_grade
		
			}
			
		else {
		
		* define only aggregate level
		
			
			
			}
			}
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education attendance ('ilo_edu_attendance') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: 

	gen ilo_edu_attendance=.
		
		capture confirm var c08_cursch
			if !_rc {
			replace ilo_edu_attendance=1 if c08_cursch==2
			replace ilo_edu_attendance=2 if c08_cursch==1
				}
				
			else {
			replace ilo_edu_attendance=1 if a02_csch==1
			replace ilo_edu_attendance=2 if a02_csch==2
				}				
			replace ilo_edu_attendance=3 if ilo_edu_attendance==.
				lab def edu_attendance_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
				lab val ilo_edu_attendance edu_attendance_lab
				lab var ilo_edu_attendance "Education (Attendance)" 
						
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Disability status ('ilo_dsb_details') [no info available]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment: 

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
* Comment: compare our numbers with variable "newempstat" (other variable considering labour force status, "cempst1", does not take into 
				* consideration the availability criterion) // Category 1 (Employed) coincides perfectly with predefined variable
				* Unemployment does not coincide, higher discrepancy observed when compared to variable not taking into account availability criterion
			
	capture confirm  var c13_work 
		if !_rc {
		
	gen ilo_lfs=.
		replace ilo_lfs=1 if c13_work==2 | c14_job==2
		replace ilo_lfs=2 if ilo_lfs!=1 & c38_lokw==2 & c37_avil==1
		replace ilo_lfs=3 if !inlist(ilo_lfs,1,2)
			replace ilo_lfs=. if ilo_wap!=1	
				label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status" 
					}
					
		else {	
	
	gen ilo_lfs=.
		replace ilo_lfs=1 if c11_work==2 | c12_job==2
		replace ilo_lfs=2 if ilo_lfs!=1 & c30_lookw==2 & c36_avail==1
		replace ilo_lfs=3 if !inlist(ilo_lfs,1,2)
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

	capture confirm var c28_ojob 
		if !_rc {
		
	gen ilo_mjh=.
		replace ilo_mjh=1 if c28_ojob==1
		replace ilo_mjh=2 if c28_ojob==2
		replace ilo_mjh=. if ilo_lfs!=1
			lab def lab_ilo_mjh 1 "1 - One job only" 2 "2 - More than one job"
			lab val ilo_mjh lab_ilo_mjh
			lab var ilo_mjh "Multiple job holders"		
				}
		
	else {	

	gen ilo_mjh=.
		replace ilo_mjh=1 if c26_ojob==1
		replace ilo_mjh=2 if c26_ojob==2
		replace ilo_mjh=. if ilo_lfs!=1
			lab def lab_ilo_mjh 1 "1 - One job only" 2 "2 - More than one job"
			lab val ilo_mjh lab_ilo_mjh
			lab var ilo_mjh "Multiple job holders"		
			
			}
			

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

	capture confirm var c19pclas 
		if !_rc {
		
		clonevar c23_pclass =  c19pclas
		}

	* Primary activity
	
		gen ilo_job1_ste_icse93=.
			replace ilo_job1_ste_icse93=1 if inlist(c23_pclass,2,3,4)
			replace ilo_job1_ste_icse93=2 if c23_pclass==1
			replace ilo_job1_ste_icse93=3 if c23_pclass==5
			/* replace ilo_job1_ste_icse93=4 if */
			replace ilo_job1_ste_icse93=5 if inlist(c23_pclass,6,7)
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
* Comment: ISIC Rev. 4 being used after (and including) 2012Q3

	* Import value labels

		append using `labels', gen (lab)
		
		capture confirm var c18_pkb
			if !_rc {			
		gen indu_code_prim=c18_pkb if ilo_lfs==1 
			}
			
			else {	
		gen indu_code_prim=c16_pkb if ilo_lfs==1 
			}		  
	
		* Primary activity
		
		gen ilo_job1_eco_isic4_2digits=indu_code_prim
		
			lab values ilo_job1_eco_isic4 isic4_2digits
			lab var ilo_job1_eco_isic4_2digits "Economic activity (ISIC Rev. 4), 2 digit level"
			
	
	* One digit level
	
		* aggregation done according to information on page 43 of the following document: https://unstats.un.org/unsd/publication/seriesM/seriesm_4rev4e.pdf
		
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
* Comment: 

	* if PSOC 1992 classification used, not perfectly aligned with ISCO - 88 --> correspondence table missing
	
	* ISCO-08 classification used
	
	capture confirm var c14_procc
		if !_rc {
	
		gen occ_code_prim=c14_procc if ilo_lfs==1
		
	* 2 digit level

		* Primary occupation
		
		gen ilo_job1_ocu_isco08_2digits=occ_code_prim
			lab values ilo_job1_ocu_isco08_2digits isco08_2digits
			lab var ilo_job1_ocu_isco08_2digits "Occupation (ISCO-08), 2 digit level"
			
			replace ilo_job1_ocu_isco08_2digits=63 if inlist(occ_code_prim,64)
			
				* category 64 considers different type of fishermen (Fish-farm cultivators, Seaweeds cultivators, Other aqua products cultivators, 
											* Inland and coastal waters fisherment, deep-sea fisherment and fishermen, n.e.c.) - force them into category 63, as this
											* separate category exists only in the national version of the occupational classification. For more details, refer
											* to original variable
				
		* 1 digit level
	
	gen occ_code_prim_1dig=int(occ_code_prim/10) if ilo_lfs==1
	
		* Primary activity
		
		gen ilo_job1_ocu_isco08=occ_code_prim_1dig
			replace ilo_job1_ocu_isco08=10 if ilo_job1_ocu_isco08==0
			replace ilo_job1_ocu_isco08=11 if ilo_job1_ocu_isco08==. & ilo_lfs==1
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
				
				}
				
	capture confirm var c16_proc 
		if !_rc {
		
		* note that if PSOC-92 classification used, the latter is aligned with ISCO-88 only at the 1-digit level
		
	gen occ_code_prim=c16_proc if ilo_lfs==1
		
		
	* 1 digit level
	
	gen occ_code_prim_1dig=int(occ_code_prim/10) if ilo_lfs==1
	
		* Primary activity
		
		gen ilo_job1_ocu_isco88=occ_code_prim_1dig if occ_code_prim!=9 /*exclude "not elswwhere classified from this variable */
			replace ilo_job1_ocu_isco88=10 if ilo_job1_ocu_isco88==0
			replace ilo_job1_ocu_isco88=11 if ilo_job1_ocu_isco88==. & ilo_lfs==1
			lab def isco88_1dig_lab 1 "1 - Managers" 2 "2 - Professionals" 3 "Technicians and associate professionals" 4 "4 - Clerks" 5 "5 - Service workers and shop and market sales workers" ///
									6 "6 - Skilled agricultural and fishery workers" 7 "7 - Craft and related trades workers" 8 "8 - Plant and machine operators, and assemblers" ///
									9 "9 - Elementary occupations" 10 "0 - Armed forces occupations" 11 "X - Not elsewhere classified"
			lab val ilo_job1_ocu_isco88 isco88_1dig_lab
			lab var ilo_job1_ocu_isco88 "Occupation (ISCO-88)"	
			
			
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
		
		}
		
						
					
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_ins_sector') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
		
* Comment: 
	
	* Primary occupation
	
	gen ilo_job1_ins_sector=.
		replace ilo_job1_ins_sector=1 if c23_pclass==2
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
* 
* Comment: variable considering working hours for secondary activity does not include observations in every dataset...
			* but variable considering hours spent in all jobs does not fully overlap with values for actual hours
			* worked in first job -> consider both variables
			
		capture confirm var c22_phrs a04_thrs 
			if !_rc {
			
			clonevar c19_phours = c22_phrs
			clonevar c28_thours = a04_thrs
			
				}
							
	* Actual hours worked 
	
		* Primary job
		
		egen max_hours=max(c19_phours)
		
		replace c19_phours=0 if c19_phours==max_hours
		
		if year>=2015 {
			
			decode c19_phours, gen(c19_phours_num)
			destring c19_phours_num, replace force
			
		
			drop c19_phours max_hours
			
			rename c19_phours_num c19_phours
			
				}
				
			gen ilo_job1_how_actual=c19_phours
				replace ilo_job1_how_actual=. if ilo_lfs!=1
				lab var ilo_job1_how_actual "Weekly hours actually worked in main job"
		
		* All jobs
		
		
			gen ilo_joball_how_actual=c28_thours
				replace ilo_joball_how_actual=. if ilo_lfs!=1
				lab var ilo_joball_how_actual "Weekly hours actually worked in all jobs"

		
	* Hours usually worked 
		* no info	
		
	*Weekly hours actually worked --> bands 
			
		* Primary job
		
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
	
* Comment: set threshold at 40 hours per week (cf. pg. 37 of following document: https://www.dole.gov.ph/files/Department-Advisory-No_1-2015_Labor-Code-of-the-Philippines-Renumbered.pdf ) 
			* and use actual hours worked instead of usual hours, given unavailability of any information about usual hours worked 

		gen ilo_job1_job_time=.
			replace ilo_job1_job_time=1 if ilo_job1_how_actual<40
			replace ilo_job1_job_time=2 if ilo_job1_how_actual>=40 
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

		capture confirm var c20_ntem 
			if !_rc {
			
		gen ilo_job1_job_contract=.
			replace ilo_job1_job_contract=1 if c20_ntem==2
			replace ilo_job1_job_contract=2 if inlist(c20_ntem,1,3)
			replace ilo_job1_job_contract=3 if ilo_job1_job_contract==. & ilo_job1_ste_aggregate==1
					replace ilo_job1_job_contract=. if ilo_lfs!=1
				lab def job_contract_lab 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"
				lab val ilo_job1_job_contract job_contract_lab
				lab var ilo_job1_job_contract "Job (Type of contract)"
					}
					
		else {	
		gen ilo_job1_job_contract=.
			replace ilo_job1_job_contract=1 if c17_natem==2
			replace ilo_job1_job_contract=2 if inlist(c17_natem,1,3)
			replace ilo_job1_job_contract=3 if ilo_job1_job_contract==. & ilo_job1_ste_aggregate==1
					replace ilo_job1_job_contract=. if ilo_lfs!=1
				lab def job_contract_lab 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"
				lab val ilo_job1_job_contract job_contract_lab
				lab var ilo_job1_job_contract "Job (Type of contract)"
					}
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Informal/Formal economy: Unit of production (ilo_job1_ife_prod) [don't define]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* 
* Comment: 
	
	* Useful questions: c19_pclass: Institutional sector
					* [no info]: Destination of production (use question used for identification of people in labour force)
					* [no info]: Bookkeeping
					* [no info]: Registration
					* [no info]: Social security
					* [no info]: Location of workplace
					* [no info]: Size of enterprise
											
					
	* gen ilo_job1_ife_prod=.
		
					
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Informal/formal economy: nature of job (ilo_job1_ife_nature) [don't define]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: 

	* gen ilo_job1_ife_nature=.
		
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Earnings ('ilo_ear_ees' and 'ilo_ear_slf')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	
* Comment:
	
	* Currency in the Philippines: Philippine peso
	
	* Primary employment 
	
			* Monthly earnings of employees
			
		capture confirm var c27_pbsc 
			if !_rc {
			
		if time=="2016Q1" {		
		decode c27_pbsc, gen(c25_pbasic)
		destring c25_pbasic, replace force
			}
		
		else {
			
		clonevar c25_pbasic = c27_pbsc 	
			
			}
			}			
				* basic pay per day indicated				
	
		gen ilo_job1_lri_ees=c25_pbasic*(365/12)
			replace ilo_job1_lri_ees=. if ilo_lfs!=1 | ilo_job1_lri_ees<0
			lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"

			* Self employment - no info
		
		* note that the revenue related to self-employment includes also the value of own consumption 
			* (cf. resolution from 1998)
			
		*gen ilo_job1_lri_slf=
			*replace ilo_job1_lri_slf=. if ilo_lfs!=1
			*lab var ilo_job1_lri_slf "Monthly labour related income of self-employed in main job"
	
	
	
***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************			

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_tru') [don't define]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*                
* Comment: no question on availability

	* gen ilo_joball_tru=1 if ilo_job1_job_time==1 
			
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
* Comment:	Question asks how much time ther person has spent looking for another job

			* note that highest value appearing is 98 weeks, which is less than 24 months - therefore no observations for the category "24 months or more" for 
				* the more detailed classification
				
	capture confirm var c40_wks 
		if !_rc {
	clonevar c33_weeks = c40_wks
		}
	
	gen ilo_dur_details=.
		replace ilo_dur_details=1 if inrange(c33_weeks,1,3)
		replace ilo_dur_details=2 if inrange(c33_weeks,4,12)
		replace ilo_dur_details=3 if inrange(c33_weeks,13,25)
		replace ilo_dur_details=4 if inrange(c33_weeks,26,51)
		replace ilo_dur_details=5 if inrange(c33_weeks,52,103)
		replace ilo_dur_details=6 if c33_weeks>103 & c33_weeks!=.
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

	capture confirm var c43_lbef 
		if !_rc {
	clonevar c38_prevjob = c43_lbef
		}
		
	gen ilo_cat_une=.
		replace ilo_cat_une=1 if c38_prevjob==2
		replace ilo_cat_une=2 if c38_prevjob==1
		replace ilo_cat_une=3 if ilo_cat_une==. & ilo_lfs==2
				replace ilo_cat_une=. if ilo_lfs!=2
			lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
			lab val ilo_cat_une cat_une_lab
			lab var ilo_cat_une "Category of unemployment"
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4') [not being defined]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: no info about previous economic activity
			
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu_isco08') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			
* Comment: use ISCO-08 classification (for periods after and including 2012Q3 )
			* before that national classification used --> find mapping

	
	capture confirm var c40_pocc
		if !_rc {	
	
	gen prevocu_cod=c40_pocc if ilo_lfs==2
		
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
			
	* Skill level
	
		gen ilo_prevocu_skill=.
			replace ilo_prevocu_skill=1 if ilo_prevocu_isco08==9
			replace ilo_prevocu_skill=2 if inlist(ilo_prevocu_isco08,4,5,6,7,8)
			replace ilo_prevocu_skill=3 if inlist(ilo_prevocu_isco08,1,2,3)
			replace ilo_prevocu_skill=4 if inlist(ilo_prevocu_isco08,10,11)
				* value label already defined
				lab val ilo_prevocu_skill ocu_skill_lab
				lab var ilo_prevocu_skill "Occupation (Skill level)"
					
					}
					
	capture confirm var c45_pocc
		if !_rc {
		
	gen prevocu_cod=int(c45_pocc/10) if ilo_lfs==2 & ilo_cat_une==1

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
				
				}
						
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Unemployment benefits schemes ('ilo_soc_aggregate') [no info available]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment:

***********************************************************************************************
*			PART 3.4. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: Degree of labour market attachment of persons outside the labour force

		* very high share falling into category "not elsewhere classified" --> don't keep variable

	/*
	gen ilo_olf_dlma=.
		replace ilo_olf_dlma=1 if c38_lookw==1 & c37_avail==2
		replace ilo_olf_dlma=2 if c38_lookw==2 & c37_avail==1
		replace ilo_olf_dlma=3 if c38_lookw==2 & c37_avail==2 & a07_willing==1
		replace ilo_olf_dlma=4 if c38_lookw==2 & c37_avail==2 & a07_willing==2
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
*
* Comment: 

	capture confirm var c42_wynt
		if !_rc {
	clonevar c34_wynot = c42_wynt
		}
	
	gen ilo_olf_reason=.
		replace ilo_olf_reason=1 if c34_wynot==7
		replace ilo_olf_reason=2 if inlist(c34_wynot,1,9)
		/* replace ilo_olf_reason=3 if */
		replace ilo_olf_reason=4 if inlist(c34_wynot,3,5,6,8)
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

		capture confirm var c37_avil
			if !_rc {
		gen ilo_dis=1 if ilo_lfs==3 & ilo_olf_reason==1 & c37_avil==1
				lab def ilo_dis_lab 1 "Discouraged job-seekers" 
				lab val ilo_dis ilo_dis_lab
				lab var ilo_dis "Discouraged job-seekers"
					}
					
				else {
			gen ilo_dis=1 if ilo_lfs==3 & ilo_olf_reason==1 & c36_avail==1
				lab def ilo_dis_lab 1 "Discouraged job-seekers" 
				lab val ilo_dis ilo_dis_lab
				lab var ilo_dis "Discouraged job-seekers"
					}
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training (NEETs) ('ilo_neet') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: 

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
		
		order c*, sequential
		
		order c*, last
				
		foreach var of varlist ilo_* {
	
		replace `var'=. if considered!=1
	
			}
		
		drop indu_code* lab isco08_2digits isco88_2digits isco08 isco88 isic4_2digits isic4 isic3_2digits isic3 occ_code* time year quarter 
		
		order ilo*, last
	
		compress 
		
	* Save dataset including original and ilo variables
	
		save ${country}_${source}_${time}_FULL,  replace		
	
	*Save file only containing ilo_* variables
	
		drop if considered!=1
	
		keep ilo*

		save ${country}_${source}_${time}_ILO, replace
		



