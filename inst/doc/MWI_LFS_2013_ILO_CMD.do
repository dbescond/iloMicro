* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Malawi, 2013
* DATASET USED: Malawi LFS 2013
* NOTES: 
* Files created: Standard variables on LFS Malawi 2013
* Authors: Podjanin
* Who last updated the file: Podjanin, A.
* Starting Date: 09 November 2016
* Last updated: 05 December 2016
***********************************************************************************************



*******************************************************************
 /* 1.	Set up work directory, file name, variables and function */
*******************************************************************

clear all 

set more off

global path "J:\COMMON\STATISTICS\DPAU\MICRO"
global country "MWI" 
global source "LFS"
global time "2013"

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

	use "MW_Labour_Force Survey 2012_Dataset", clear	
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

*			2. MAP VARIABLES

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Key dentifier ('ilo_key') [done]
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

	gen ilo_wgt=new_calwgt2
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
	gen ilo_geo=Residence
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

		gen ilo_sex=BG2
			label define label_Sex 1 "1 - Male" 2 "2 - Female"
			label values ilo_sex label_Sex
			lab var ilo_sex "Sex"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: Minimum age 10 - maximal value 99

	gen ilo_age=BG1
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
*			Education ('ilo_edu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: Only aggregate classification possible to be defined with the information available

	* 'Vocational' considered as basic
			
	gen ilo_edu_aggregate=.
		replace ilo_edu_aggregate=1 if BG9==1
		replace ilo_edu_aggregate=2 if inlist(BG9,2,6)
		replace ilo_edu_aggregate=3 if BG9==3
		replace ilo_edu_aggregate=4 if inlist(BG9,4,5)
		replace ilo_edu_aggregate=5 if ilo_edu_aggregate==.
			label def edu_aggr_lab 1 "1 - Less than basic" 2 "2 - Basic" 3 "3 - Intermediate" 4 "4 - Advanced" 5 "5 - Level not stated"
			label val ilo_edu_aggregate edu_aggr_lab
			label var ilo_edu_aggregate "Education (Aggregate level)"
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education attendance ('ilo_edu_attendance') [can't be defined]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: variable can't be defined as there's no question asking whether the person is currently enrolled in some 
				* educational institution

		/* gen ilo_edu_attendance=.
			 */
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Disability status ('ilo_dsb_details') [no info available]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment: 
	
/*	
	gen ilo_dsb_details=.
				
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
* Comment: 	Reference period for job search: four weeks

 
	gen ilo_lfs=.
		replace ilo_lfs=1 if A1==1 | A2A==1 | A2B==1 | A2C==1 | A2D==1 | ((A2E==1 | A2F==1 ) & inlist(A4,1,2,3)) | (A2G==1 & (inlist(A4,1,2,3)| A3==1)) | (A6==1 & (inlist(A7,1,2,3,5,6,9,10)| A8==1))
		replace ilo_lfs=2 if (((H01A==1 | H01B==1) & (H08A==1 | H08B==1)) & H02!=10 ) | (H03A==1 | H03B==1)
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
		replace ilo_mjh=1 if C1==2 & C1A==2 & C1B==2 & C1C==2 & C1D==2 & C1E==2 & C1F==2 & C1G==2
		replace ilo_mjh=2 if C1==1 | C1A==1 | C1B==1 | C1C==1 | C1D==1 | C1E==1 | C1F==1 | C1G==1
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
			replace ilo_job1_ste_icse93=1 if B5==1
			replace ilo_job1_ste_icse93=2 if B5==2
			replace ilo_job1_ste_icse93=3 if B5==3
			replace ilo_job1_ste_icse93=4 if B5==5
			replace ilo_job1_ste_icse93=5 if B5==4
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
			replace ilo_job2_ste_icse93=1 if C8==1
			replace ilo_job2_ste_icse93=2 if C8==2
			replace ilo_job2_ste_icse93=3 if C8==3
			replace ilo_job2_ste_icse93=4 if C8==5
			replace ilo_job2_ste_icse93=5 if C8==4
			replace ilo_job2_ste_icse93=6 if ilo_job2_ste_icse93==. & ilo_lfs==1 & ilo_mjh==2
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
*			Economic activity ('ilo_eco') [can't be defined]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: Variable from original dataset is not perfectly aligned with ISIC
				* given that no correspondence table exists, drop variable

	/* gen indu_code_prim=int(B4/100) if ilo_lfs==1
	
	gen indu_code_sec=int(C7/100) if ilo_lfs==1 & ilo_mjh==2 */
		
		* Import value labels

		append using `labels', gen (lab)
					
			
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_ocu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: B2 - only 2 digits, but it deosn't correspond to neither ISCO-08 2-digits, nor ISCO-88 2-digits
* B2 is mapped to a more aggregate variable Occupation corresponding to ISCO-08 1 digit

		* --> therefore don't define secondary activity, as probably classification again inconsistent with any ISCO classification...

	*gen occ_code_prim=occupation if ilo_lfs==1
	* gen occ_code_sec=int(L2Q36A_STASK/100) if ilo_lfs==1 & ilo_mjh==2
	
	* 2 digit level
	
		* Primary occupation
		
	/* gen ilo_job1_ocu_isco08_2digits=occ_code_prim
			lab values ilo_job1_ocu_isco08_2digits isco08_2digits
			lab var ilo_job1_ocu_isco08_2digits "Occupation (ISCO-08), 2 digit level" */

		
	* 1 digit level
	
	gen occ_code_prim_1dig=occupation if ilo_lfs==1
	* gen occ_code_sec_1dig=int(p53/1000) if ilo_lfs==1 & ilo_mjh==2
	
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
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_ins_sector') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
		
* Comment: consider separately for primary and secondary activity

			* --> note that the question is only being asked to employees and there are no 
				* observations for self-employed...! (for the moment, included among 'private'...)
	
	* Primary occupation
	
	gen ilo_job1_ins_sector=.
		replace ilo_job1_ins_sector=1 if inlist(B6,1,2,3,8,9)
		replace ilo_job1_ins_sector=2 if inlist(B6,4,5,6,7,99) | ilo_job1_ste_aggregate==2
			* force missing values into private
			replace ilo_job1_ins_sector=2 if ilo_job1_ins_sector==. & ilo_lfs==1
				replace ilo_job1_ins_sector=. if ilo_lfs!=1
			lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
			lab values ilo_job1_ins_sector ins_sector_lab
			lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities"
			
	* Secondary occupation

	gen ilo_job2_ins_sector=.
		replace ilo_job2_ins_sector=1 if inlist(C18,1,2,3,8,9)
		replace ilo_job2_ins_sector=2 if inlist(C18,4,5,6,7,99)
				replace ilo_job2_ins_sector=. if ilo_lfs!=1 & ilo_mjh!=2
			* idem as for job1
				replace ilo_job2_ins_sector=2 if ilo_job2_ins_sector==. & ilo_lfs==1 & ilo_mjh==2
			* value labels already defined
			lab values ilo_job2_ins_sector ins_sector_lab
			lab var ilo_job2_ins_sector "Institutional sector (private/public) of economic activities in secondary job"


* --------------------------------------------------------------------------------------------------
* --------------------------------------------------------------------------------------------------
*		Weekly hours actually (USUALLY) worked ('ilo_how_actual') and ('ilo_how_usual') [done]
* --------------------------------------------------------------------------------------------------
* --------------------------------------------------------------------------------------------------
* 
* Comment: consider first working time associated with each job and then consider the sum (i.e.
				* the time dedicated to all working activities during the week
				
	* Actual hours worked 
		
		* Primary job
		
		gen ilo_job1_how_actual=E02A_TOTAL
			replace ilo_job1_how_actual=. if ilo_lfs!=1
			lab var ilo_job1_how_actual "Weekly hours actually worked in main job"
			
		* Secondary job
			
		gen ilo_job2_how_actual=E02B_TOTAL
			replace ilo_job2_how_actual=. if ilo_lfs!=1 & ilo_mjh!=2
			lab var ilo_job2_how_actual "Weekly hours actually worked in secondary job" 
		
		* All jobs
		
		egen ilo_joball_how_actual=rowtotal(ilo_job1_how_actual ilo_job2_how_actual), m
			replace ilo_joball_how_actual=. if ilo_lfs!=1
			lab var ilo_joball_how_actual "Weekly hours actually worked in all jobs"		
	
	* Hours usually worked
	
		* Primary job
		
		gen ilo_job1_how_usual=E01A
			replace ilo_job1_how_usual=. if ilo_lfs!=1
			lab var ilo_job1_how_usual "Weekly hours usually worked in main job"
			
		* Secondary job
			
		gen ilo_job2_how_usual=E01B
			replace ilo_job2_how_usual=. if ilo_lfs!=1 & ilo_mjh!=2
			lab var ilo_job2_how_usual "Weekly hours usually worked in secondary job"
			
		* All jobs
		
		egen ilo_joball_how_usual=rowtotal(ilo_job1_how_usual ilo_job2_how_usual), m
			replace ilo_joball_how_usual=. if ilo_lfs!=1
			lab var ilo_joball_how_usual "Weekly hours usually worked in all jobs"
		
	*Weekly hours actually worked --> bands --> use actual hours worked in all jobs 
			
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
	
* Comment: time usually dedicated to the primary activity being considered
			* --> national threshold set at 48 hours per week
	
	gen ilo_job1_job_time=.
		replace ilo_job1_job_time=1 if ilo_job1_how_usual<=47 & ilo_job1_how_usual!=.
		replace ilo_job1_job_time=2 if ilo_job1_how_usual>=48 & ilo_job1_how_usual!=.
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

	* Primary employment
	
	gen ilo_job1_job_contract=.
		replace ilo_job1_job_contract=1 if B7==2
		replace ilo_job1_job_contract=2 if B7==1
		replace ilo_job1_job_contract=3 if (ilo_job1_job_contract==. & ilo_job1_ste_aggregate==1)
				replace ilo_job1_job_contract=. if ilo_job1_ste_aggregate!=1
			lab def job_contract_lab 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"
			lab val ilo_job1_job_contract job_contract_lab
			lab var ilo_job1_job_contract "Job (Type of contract)"
			
	* Secondary employment
	
	gen ilo_job2_job_contract=.
		replace ilo_job2_job_contract=1 if C10==2
		replace ilo_job2_job_contract=2 if C10==1
		replace ilo_job2_job_contract=3 if (ilo_job2_job_contract==. & ilo_job2_ste_aggregate==1 & ilo_mjh==2)
				replace ilo_job2_job_contract=. if ilo_job2_ste_aggregate!=1 & ilo_mjh!=2
			* value label already defined
			lab val ilo_job2_job_contract job_contract_lab
			lab var ilo_job2_job_contract "Job (Type of contract) in secondary job"
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Informal/Formal economy: Unit of production (ilo_job1_ife_prod) [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* 
* Comment:

	* Useful questions: B6: Status in employment 
					*	A4: Destination of production
					*	B22: Location of workplace
					*	B20: Size of the establishment --> given definition of original variable, threshold is set at five and not six employees
					*	B19: Bookkeeping (not asked to employees)
					*	B18: Registration of the establishment (not asked to employees) --> if in progress of being registered, not considered as registered!
					* 	B10: Social security contributions (Social security/pension scheme)
					*	(B11: Paid annual leave)
					*	(B12: Paid sick leave)
				
				* [ For secondary employment:
					*	C8: Status in employment
					*	C24: Location of workplace
					*	C22: Size of the establishment
					*	C21: Bookkeeping
					*	C20: Registration of the establishment 
					* 	C13: Social security contributions
					*	(C14: Paid annual leave)
					*	(C15: Paid sick leave)				]
					
	
	
	gen ilo_job1_ife_prod=.
		replace ilo_job1_ife_prod=1 if inlist(B6,4,5,6,99,.) & A4!=4 & B19!=1 & inlist(B18,2,3) | (inlist(B6,4,5,6,99,.) & A4!=4 & B19!=1 & !inlist(B18,1,2,3)  ///
					& ((ilo_job1_ste_aggregate==1 & B10!=1) |  ilo_job1_ste_aggregate!=1) & (inlist(B22,5,6,7,8) | (!inlist(B22,5,6,7,8) & !inrange(B20,2,6))))
		replace ilo_job1_ife_prod=2 if inlist(B6,1,2,3,8,9) | (inlist(B6,4,5,6,99,.) & A4!=4 & B19==1) | (inlist(B6,4,5,6,99,.) & A4!=4 & B19!=1 & B18==1) | ///
					(inlist(B6,4,5,6,99,.) & A4!=4 & B19!=1 & !inlist(B18,1,2,3) & ((ilo_job1_ste_aggregate==1 & B10==1) | (((ilo_job1_ste_aggregate==1 & B10!=1) | ilo_job1_ste_aggregate!=1) & !inlist(B22,5,6,7,8) & inrange(B20,2,6))))
		replace ilo_job1_ife_prod=3 if B6==7 | (inlist(B6,4,5,6,99,.) & A4==4) 
		replace ilo_job1_ife_prod=4 if ilo_job1_ife_prod==. & ilo_lfs==1
				replace ilo_job1_ife_prod=. if ilo_lfs!=1
			lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 4 "4 - Not elsewhere classified"
			lab val ilo_job1_ife_prod ilo_ife_prod_lab
			lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"	
	
	
	
	/* following the old definition:
	
	gen ilo_job1_ife_prod=.
		replace ilo_job1_ife_prod=1 if inlist(B6,4,5,6,99,.) & B19!=1 & B18!=1 & ( (inlist(B22,2,4,5,6,7,9,.) & inlist(B20,1,8,.)) | inlist(B22,1,8) ) & soc_sec_coverage!=1
		replace ilo_job1_ife_prod=2 if inlist(B6,1,2,3,8,9) | (inlist(B6,4,5,6,99,.) & B19==1) | (inlist(B6,4,5,6,99,.) & B19!=1 & B18==1 ) | (inlist(B6,4,5,6,99,.) & B19!=1 & B18!=1 & ///
										((inlist(B22,2,4,5,6,7,9,.) & !inlist(B20,1,8,.)) | (((inlist(B22,2,4,5,6,7,9,.) & inlist(B20,1,8,.)) | inlist(B22,1,8) ) & soc_sec_coverage==1)))		
		replace ilo_job1_ife_prod=3 if B6==7 | (inlist(B6,4,5,6,99,.) & B19!=1 & B18!=1 & B22==3) 
		replace ilo_job1_ife_prod=4 if ilo_job1_ife_prod==. & ilo_lfs==1
				replace ilo_job1_ife_prod=. if ilo_lfs!=1
			lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 4 "4 - Not elsewhere classified"
			lab val ilo_job1_ife_prod ilo_ife_prod_lab
			lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"
			
			*/
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Informal/formal economy: nature of job (ilo_job1_ife_nature) [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: 

	gen ilo_job1_ife_nature=.
		replace ilo_job1_ife_nature=1 if ilo_job1_ste_icse93==5 | (inlist(ilo_job1_ste_icse93,1,6) & B10!=1) | ((inlist(ilo_job1_ste_icse93,2,4) | (ilo_job1_ste_icse93==3 & A4!=4)) & inlist(ilo_job1_ife_prod,1,3)) | ///
										(ilo_job1_ste_icse93==3 & A4==4)
		replace ilo_job1_ife_nature=2 if (inlist(ilo_job1_ste_icse93,1,6) & B10==1) | ((inlist(ilo_job1_ste_icse93,2,4) | (ilo_job1_ste_icse93==3 & A4!=4)) & ilo_job1_ife_prod==2)
		replace ilo_job1_ife_nature=. if ilo_lfs!=1
			lab def ife_nature_lab 1 "1 - Persons with informal main job" 2 "2 - Persons with formal main job"
			lab val ilo_job1_ife_nature ife_nature_lab
			lab var ilo_job1_ife_nature "Informal / Formal Economy (Nature of job)"
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Earnings ('ilo_job1_lri') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	
* Comment: 
	
	*Currency in Malawi: Malawian kwacha (MWK or MK)
	
		* if job new --> no salary being indicated and person redirected to another section of the questionnaire
		
		* also no value for in-kind payments being indicated
		
		* Consider net salaries
		
		gen net_salary=.
			replace net_salary=G01_AMOUNT if G01_AMOUNT!=999999 & inlist(G02,2,3,4)
			replace net_salary=(G01_AMOUNT-G03_AMOUNT) if G01_AMOUNT!=999999 & G03_AMOUNT!=999999 & G02==1
	
		*given lack of precision and being indicated for a very small share of the sample, skip question on wage bands
			* (initially based on question G04)
		
		/* gen wage_bands=.
			 */ 
			
	* Consider payment period
	
		gen monthly_salary=.
	
	foreach var of varlist net_salary {
		
			replace monthly_salary=`var'*22 if G05==1
			replace monthly_salary=`var'*4 if G05==2
			replace monthly_salary=`var'*2 if G05==3
			replace monthly_salary=`var' if G05==4
			* take "other" as monthly (otherwise too many observations being lost)
			replace monthly_salary=`var' if G05==5
			
			}
			
		* net revenue from own business
		
			gen rev_selfemp=G10-G11	
	
	* Primary employment 
	
			* Monthly earnings of employees
	
		gen ilo_job1_lri_ees=monthly_salary
			replace ilo_job1_lri_ees=. if ilo_lfs!=1 | ilo_job1_lri_ees<0
			lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"
	
			* Self employment
		
		* note that the revenue related to self-employment includes also the value of own consumption 
			* (cf. resolution from 1998)
			
		egen ilo_job1_lri_slf=rowtotal(rev_selfemp G14), m
			replace ilo_job1_lri_slf=. if ilo_lfs!=1
			lab var ilo_job1_lri_slf "Monthly labour related income of self-employed in main job"
				

	* Secondary employment --> no info
	
***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************				
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_tru') [don't define]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*                
* Comment: National threshold for for full-time employment set at 48 hours per week -> therefore according to the time-related criterion 
		*	workers working 48 hours and less are considered as underemployed	--> cf. link: http://www.ilo.org/dyn/natlex/docs/WEBTEXT/58791/65218/E00MWI01.htm 
		
		* only willingness to work more being asked for --> no question about availability
		
		* --> therefore variable can't be defined

	/* 
	gen ilo_joball_tru=1 if ilo_joball_how_actual<=47 & F01==1 
		replace ilo_joball_tru=. if ilo_lfs!=1
			lab def tru_lab 1 "Time-related underemployment"
			lab val ilo_joball_tru tru_lab
			lab var ilo_joball_tru "Time-related underemployment"			*/
			
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Cases of non-fatal occupational injury ('ilo_joball_oi_case') [done] 
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*
* Comment: question asks only whether person had an occupational injury or not
			
	gen ilo_joball_oi_case=1 if D01==1 & ilo_lfs==1
		lab var ilo_joball_oi_case "Cases of non-fatal occupational injury"
		
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Days lost due to cases of occupational injury ('ilo_joball_oi_day') [done]
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*
* Comment: 

	gen ilo_joball_oi_day=D05 if ilo_lfs==1 
		lab var ilo_joball_oi_day "Days lost due to cases of occupational injury"
		
		
***********************************************************************************************
*			PART 3.3. UNEMPLOYMENT: ECONOMIC CHARACTERISTICS
***********************************************************************************************			

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of unemployment ('ilo_cat_une') [don't define]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: note that the question only asks whether the person had a job within the last 12 months...! no info
			* about unemployed persons that have had a job more than one year before the survey had been done
				* --> therefore don't define variable
	
	/* gen ilo_cat_une=.
		replace ilo_cat_une=1 if I01==1
		replace ilo_cat_une=2 if I02==2
		replace ilo_cat_une=3 if ilo_cat_une==. & ilo_lfs==2
				replace ilo_cat_une=. if ilo_lfs!=2
			lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
			lab val ilo_cat_une cat_une_lab
			lab var ilo_cat_une "Category of unemployment" */
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment:

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
		replace ilo_dur_aggregate=1 if inlist(H07,1,2)
		replace ilo_dur_aggregate=2 if H07==3
		replace ilo_dur_aggregate=3 if inlist(H07,4,5,6)
		replace ilo_dur_aggregate=4 if ilo_dur_aggregate==. & ilo_lfs==2
				replace ilo_dur_aggregate=. if ilo_lfs!=2
			lab def ilo_unemp_aggr 1 "Less than 6 months" 2 "6 months to less than 12 months" 3 "12 months or more" 4 "Not elsewhere classified"
			lab val ilo_dur_aggregate ilo_unemp_aggr
			lab var ilo_dur_aggregate "Duration of unemployment (Aggregate)"

			
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4') [can't be defined]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: idem as for ilo_job1_eco --> classification not perfectly aligned to ISIC

		*gen preveco_cod=int(I05/100) if ilo_lfs==2
		
			* keep this variable on the two digit level, in order to be able to correctly execute the code below

			

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu_isco08') [don't define]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			
* Comment: as occupation was not initially classified according to ISCO (for primary occupation) 
		* highly likely that here it won't be the case either... and there are no value labels 
		* that allow to verify for that --> don't define variable

	/* 
	gen prevocu_cod=int(L2Q15B_TASCO/1000) if ilo_lfs==2
	
	gen ilo_prevocu_isco88=prevocu_cod
		replace ilo_prevocu_isco88=10 if ilo_job1_ocu_isco88==0
		replace ilo_prevocu_isco88=11 if ilo_prevocu_isco88==. & ilo_cat_une==1 & ilo_lfs==2
		* value label already defined
		lab val ilo_prevocu_isco88 isco88_1dig_lab
		lab var ilo_prevocu_isco88 "Previous occupation (ISCO-08)"
			
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
			lab var ilo_prevocu_aggregate "Previous occupation (Aggregate)"		*/			
			

			
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
*			Degree of labour market attachment ('ilo_olf_dlma') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: Degree of labour market attachment of persons outside the labour force
	
	gen ilo_olf_dlma=.
		replace ilo_olf_dlma=1 if (H01A==1 | H01B==1) & H08A==2 & H08B==2
		replace ilo_olf_dlma=2 if H01A==2 & H01B==2 & (H08A==1 | H08B==1) 
		replace ilo_olf_dlma=3 if H01A==2 & H01B==2 & H08A==2 & H08B==2 & H04==1
		replace ilo_olf_dlma=4 if H01A==2 & H01B==2 & H08A==2 & H08B==2 & H04==2
		replace ilo_olf_dlma=5 if ilo_olf_dlma==. & ilo_lfs==3
				replace ilo_olf_dlma=. if ilo_lfs!=3
			lab def lab_olf_dlma 1 "1 - Seeking, not available (Unavailable jobseekers)" 2 "2 - Not seeking, available (Available potential jobseekers)" ///
						3 "3 - Not seeking, not available, willing (Willing non-jobseekers)" 4 "4 - Not seeking, not available, not willing" 5 "5 - Not elsewhere classified"
			lab val ilo_olf_dlma lab_olf_dlma
			lab var ilo_olf_dlma "Labour market attachment (Degree of)"	
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reasons for not seeking a job ('ilo_olf_reason') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: 
	
	gen ilo_olf_reason=.
		replace ilo_olf_reason=1 if inlist(H05,1,2,7,8,9,11)
		replace ilo_olf_reason=2 if inlist(H05,3,4,5,6,10,12)
		/* replace ilo_olf_reason=3 if inlist(H05, */
		replace ilo_olf_reason=4 if ilo_olf_reason==. & ilo_lfs==3
			replace ilo_olf_reason=. if ilo_lfs!=3 & (H01A==1 | H01B==1)
			lab def lab_olf_reason 1 "1 - Labour market" 2 "2 - Personal/Family-related"  3 "3 - Does not need/want to work" 4 "4 - Not elsewhere classified"
			lab val ilo_olf_reason lab_olf_reason
			lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)" 

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seekers ('ilo_dis') [done]
* -------------------------------------------------------------------------------------------
* ------------------------------------------------------------------------------------------- 
*
* Comment: 

		gen ilo_dis=1 if ilo_lfs==3 & ilo_olf_reason==1 & (H08A==1 | H08B==1)
			lab def ilo_dis_lab 1 "Discouraged job-seekers" 
			lab val ilo_dis ilo_dis_lab
			lab var ilo_dis "Discouraged job-seekers" 
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training (NEETs) ('ilo_neet') [can't be defined]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: attendance can't be defined --> consequently this variable can't be defined either

	/*	gen ilo_neet=.
			replace ilo_neet=1 if inrange(ilo_age,15,24) & ilo_lfs!=1 & ilo_edu_attendance==2
				lab def ilo_neet_lab 1 "Youth not in education, employment or training"
				lab val ilo_neet ilo_neet_lab
				lab var ilo_neet "Youth not in education, employment or training" */		



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
		
		drop net_salary monthly_salary rev_selfemp occ_code_* lab isco08_2digits isco88_2digits isco08 isco88 isic4_2digits isic4 isic3_2digits isic3  

		compress 
		
		order ilo*, last

	* Save dataset including original and ilo variables
	
		save ${country}_${source}_${time}_FULL, replace		
	
	*Save file only containing ilo_* variables
	
		keep ilo*

		save ${country}_${source}_${time}_ILO, replace
		


