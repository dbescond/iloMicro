* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Namibia 2016
* DATASET USED: Namibia LFS 2016
* NOTES: 
* Files created: Standard variables on LFS Namibia 2016
* Authors: Valia Bourmpoula
* Who last updated the file: Valia Bourmpoula
* Starting Date: 1 February 2017
* Last updated: 13 February 2017
**********************************************************************************************

**********************************************************************************************
*  CONTENTS																					*
**********************************************************************************************
* A. Set up work directory, file name, variables and function
* B1. Load original dataset
* B2. Define labels for the classifications ISIC and ISCO
* C.  Map variables
*		Part C1. Dataset settings variables
*		Part C2. Social characteristics
*		Part C3. Economic situation
*				Part C3.1 Employment: economic characteristics for main job
*				Part C3.2 Employment: economic characteristics for all jobs
*				Part C3.3 Unemployment: economic characteristics
*				Part C3.4 Outside labour force: economic characteristics
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

***********************************************************************************************
***********************************************************************************************

* 			A. SET UP WORK DIRECTORY, FILE NAME, VARIABLES AND FUNCTIONS

***********************************************************************************************
***********************************************************************************************

**********************************************************************************************
*  B1. Load original dataset																*
**********************************************************************************************

clear all 

set more off

global path "J:\COMMON\STATISTICS\DPAU\MICRO"
global country "NAM"
global source "LFS"
global time "2016"
global input_file "NAM_LFS_2016"

global inpath "${path}\\${country}\\${source}\\${time}\ORI"
global temppath "${path}\_Admin"
global outpath "${path}\\${country}\\${source}\\${time}"

**********************************************************************************************
*  B2. Define labels for the classifications ISIC and ISCO									*
**********************************************************************************************
					
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

	use "${input_file}", clear


***********************************************************************************************
***********************************************************************************************

*			C. MAP VARIABLES

***********************************************************************************************
***********************************************************************************************

* ---------------------------------------------------------------------------------------------
***********************************************************************************************
*			PART C1. DATASET SETTINGS VARIABLES
***********************************************************************************************
* ---------------------------------------------------------------------------------------------

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

	gen ilo_wgt=PERSON_WEIGHT
		lab var ilo_wgt "Sample weight"		

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time period ('ilo_time')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_time=1
		lab def lab_time 1 "2016" 
		lab val ilo_time lab_time
		lab var ilo_time "Time (Gregorian Calendar)"
		

* ---------------------------------------------------------------------------------------------
***********************************************************************************************
*			PART C2. SOCIAL CHARACTERISTICS
***********************************************************************************************
* ---------------------------------------------------------------------------------------------

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Geographical coverage ('ilo_geo')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_geo=.
		replace ilo_geo=1 if inlist(LI_URBRUR,1,98)
		replace ilo_geo=2 if LI_URBRUR==99
			lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural"
			lab val ilo_geo ilo_geo_lab
			lab var ilo_geo "Geographical coverage"	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_sex=.
		replace ilo_sex=1 if SEX==2
		replace ilo_sex=2 if SEX==1
			lab def ilo_sex_lab 1 "1 - Male" 2 "2 - Female"
			lab var ilo_sex "Sex"
			lab val ilo_sex ilo_sex_lab	
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_age=AGE_YEARS
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
			lab def age_by5_lab 1 "0-4" 2 "5-9" 3 "10-14" 4 "15-19" 5 "20-24" 6 "25-29" 7 "30-34" 8 "35-39" ///
								9 "40-44" 10 "45-49" 11 "50-54" 12 "55-59" 13 "60-64" 14 "65+"
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
		
/* ISCED 11 mapping: use UNESCO mapping
					http://www.uis.unesco.org/Education/ISCEDMappings/Pages/default.aspx
					http://www.uis.unesco.org/Education/Documents/isced-2011-en.pdf 			
					
	NOTE: * [D05 (B) ~ HIGHEST_GRADE_MINOR] - What is (NAME) highest grade/standard or level of education completed?
	For the codes of this variable, please, refer to the tab "educ equivalent" of the excel-file "NID LFS_DICT_240117.xlsx".
	The above question is asked to all people >=6 yrs old.
	Based on the "Edit rules", this question is not applicable to people under [D03A - READ_WRITE_YN==2] or under [D04 - ATTEND_SCHOOL==1]. */
		
	gen ilo_edu_isced11=.
		replace ilo_edu_isced11=1 if inlist(HIGHEST_GRADE_MINOR,0,95,96)  		// No schooling
		replace ilo_edu_isced11=2 if inrange(HIGHEST_GRADE_MINOR,1,7)			// Early childhood education
		replace ilo_edu_isced11=3 if inrange(HIGHEST_GRADE_MINOR,8,10)			// Primary education
		replace ilo_edu_isced11=4 if inlist(HIGHEST_GRADE_MINOR,11,12)			// Lower secondary education
		replace ilo_edu_isced11=5 if inlist(HIGHEST_GRADE_MINOR,13,14)			// Upper secondary education
		replace ilo_edu_isced11=6 if inlist(HIGHEST_GRADE_MINOR,15) 			// Post-secondary non-tertiary education
		replace ilo_edu_isced11=7 if inrange(HIGHEST_GRADE_MINOR,16,23)			// Short-cycle tertiary education
		replace ilo_edu_isced11=8 if inlist(HIGHEST_GRADE_MINOR,24,25) 			// Bachelor or equivalent
		replace ilo_edu_isced11=9 if inrange(HIGHEST_GRADE_MINOR,26,28)			// Master's or equivalent level
		replace ilo_edu_isced11=10 if inlist(HIGHEST_GRADE_MINOR,29) 			// Doctoral or equivalent level
		replace ilo_edu_isced11=11 if inlist(HIGHEST_GRADE_MINOR,30,99)			// Not elsewhere classified
			label def isced_11_lab 1 "X - No schooling" 2 "0 - Early childhood education" 3 "1 - Primary education" 4 "2 - Lower secondary education" ///
							5 "3 - Upper secondary education" 6 "4 - Post-secondary non-tertiary education" 7 "5 - Short-cycle tertiary education" ///
							8 "6 - Bachelor's or equivalent level" 9 "7 - Master's or equivalent level" 10 "8 - Doctoral or equivalent level" 11 "9 - Not elsewhere classified"
			label val ilo_edu_isced11 isced_11_lab
			lab var ilo_edu_isced11 "Level of education (ISCED 11)"
	
	gen ilo_edu_aggregate=.
		replace ilo_edu_aggregate=1 if inlist(ilo_edu_isced11,1,2)  	// Less than basic
		replace ilo_edu_aggregate=2 if inlist(ilo_edu_isced11,3,4)		// Basic
		replace ilo_edu_aggregate=3 if inlist(ilo_edu_isced11,5,6)		// Intermediate
		replace ilo_edu_aggregate=4 if inrange(ilo_edu_isced11,7,10)	// Advanced
		replace ilo_edu_aggregate=5 if ilo_edu_isced11==11				// Level not stated
			label def edu_aggr_lab 1 "Less than basic" 2 "Basic" 3 "Intermediate" 4 "Advanced" 5 "Level not stated"
			label val ilo_edu_aggregate edu_aggr_lab
			label var ilo_edu_aggregate "Level of education (Aggregate)"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education attendance ('ilo_edu_attendance')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

/* NOTE: NLFS 2016 Questionnaire
	[D04 ~ ATTEND_SCHOOL] - Has (name) ever attended school?
	1=Never attended, 2=Attending Pre-Primary, 3=Attending adult education programme, 4=Attending school, 5=Left school, 6=Don't know (in the dataset this is coded as 9)
	The above question is asked to all people >=6 yrs old.   */

	gen ilo_edu_attendance=.
		replace ilo_edu_attendance=1 if inrange(ATTEND_SCHOOL,2,4)	// Attending 
		replace ilo_edu_attendance=2 if inlist(ATTEND_SCHOOL,1,5)	// Not attending 
		replace ilo_edu_attendance=3 if ilo_edu_attendance==.		// Not elsewhere classified 
			label def edu_att_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified" 
			label val ilo_edu_attendance edu_att_lab
			label var ilo_edu_attendance "Education (Attendance)"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Disability status ('ilo_dsb') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

	* Not available


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

* Comment: wap = 15+ 

	gen ilo_wap=.
		replace ilo_wap=1 if ilo_age>=15 & ilo_age!=.
			lab def wap_lab 1 "Working age population"
			lab val ilo_wap wap_lab
			label var ilo_wap "Working age population"

	drop ilo_age

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Labour Force Status ('ilo_lfs')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

/* Comment: 
	[E02 ~ WORKED_FOR_PAY_YN] - In the past 7 days, did (NAME) do any work for pay (In cash or inkind including paid domestic work) for at least one hour?
	[E03 ~ DID_BUSINESS_YN] - In the past 7 days, did (NAME) do any kind of business or self-employed activity, big or small, for her/himself or with  partners, or for a business owned by the household or any member, for at least one hour?
	[E04 ~ WORKED_HOUR_YN] - Even though (NAME) say she/he did not work  in a business or self-employed activity in the past 7 days, did she/he work for at least an hour at an activity, for example as a trader, selling in the market, collecting wood or dung to sell, making handicrafts for sale, etc.? (Excluding subsitance farmers)
	[E05 ~ ABSENT_WORK_YN] - Even though (NAME) did not do any kind of work in the past 7 days, did (NAME) have work or business (not including farming), from which (NAME) was temporarily absent because of vacation, illness, layoff,  etc., and to which (NAME) will definitely return?

	The following two questions are asked ONLY to the Head and the Spouse/Partner of the HH (identified as B03==1|B03==2).
	[E08 ~ WORKED_AGRICULTURE_YN] - In the past 7 days,  did (NAME) do any agricultural work on his/her household farm/plot/garden/cattle post or kraal, or grow farm produce or take care of his/her own or household livestock?
	[E09 ~ DOES_AGRICULTURAL_WORK] - Does (NAME) have any agricultural work on his/her own or household farm/plot/garden/cattle post or kraal, that s/he will definitely return to?
		For E02-4, if Yes -> E10
		For   E05, if No  -> E08
		For   E08, if Yes -> E10
	Note: The questionnaire is still based on the previous ICLS, so itӳ correct to include persons answering YES in E08 and E09.

	* UNEMPLOYMENT * 
	[E36 ~ COULD_WORK_YN] - If (NAME) has been offered a job, would (NAME) have been ready to work during the last 7 days?
	[E38 ~ TRY_START_BUSINESS_YN] - In the past 30 days, was  (Name) actively looking for a job (that would give wage, salary or in-kind payment) or did (NAME) try to start business?
	For E36, if Yes -> E38
		 if No  -> E37 and STOP with Labour Force section
	For E38, if No  -> E40
	[E37 ~ WHY_NOT_WORKING] - Since (NAME) was not working for pay, profit , family gain, or in agriculture  nor  available to start work, what was (NAME) doing in the past 7 days? 1=Retired, 2=Old-age, 3=Illness/disabled, 4=Homemaker, 5=Student/learner/scholar/pupil, 6=Income recipient, 7=Other
	[E39 ~ LOOKING_WORK_CB_1-7] - What steps did (NAME) take to look for work/try to start business in the past 30 days? (A-F and G for Other)
	[E40 ~ REASON_CANT_START_WORK] - What was the main reason that (NAME) didnӴ look for work or try to start his/ her business during the last 30 days?
		4  = Already found work to start within one month   -> This category is included in the unemployed population [ilo_lfs==2] following the ICLS. */

	 gen ilo_lfs=.
		replace ilo_lfs=1 if (WORKED_FOR_PAY_YN==1 | DID_BUSINESS_YN==1 | WORKED_HOUR_YN==1 | ABSENT_WORK_YN==1 | WORKED_AGRICULTURE_YN==1 | DOES_AGRICULTURAL_WORK==1)	// Employed
		replace ilo_lfs=2 if ilo_lfs!=1 & COULD_WORK_YN==1 & (TRY_START_BUSINESS_YN==1 | REASON_CANT_START_WORK==4) 													// Unemployed
		replace ilo_lfs=3 if !inlist(ilo_lfs,1,2)	  																													// Outside the labour force
		replace ilo_lfs=. if ilo_wap!=1
				label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside the Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_mjh=.
		replace ilo_mjh=2 if MORE_THAN_ONE_JOB==1 & ilo_lfs==1
		replace ilo_mjh=1 if MORE_THAN_ONE_JOB==2 & ilo_lfs==1
			lab def lab_ilo_mjh 1 "1 - One job only" 2 "2 - More than one job"
			lab val ilo_mjh lab_ilo_mjh
			lab var ilo_mjh "Multiple job holders"
	
	
***********************************************************************************************
*			PART C3.1. ECONOMIC CHARACTERISTICS FOR MAIN JOB 
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Status in employment ('ilo_job1_ste') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	* MAIN JOB: [E21 ~ EMPLOYMENT_STATUS]
	
		* Detailled categories:
			gen ilo_job1_ste_icse93=.
				replace ilo_job1_ste_icse93=1 if inlist(EMPLOYMENT_STATUS,5)			// Employees
				replace ilo_job1_ste_icse93=2 if inlist(EMPLOYMENT_STATUS,1,3)			// Employers
				replace ilo_job1_ste_icse93=3 if inlist(EMPLOYMENT_STATUS,2,4)			// Own-account workers
				* replace ilo_job1_ste_icse93=4 if 										// Producer cooperatives
				replace ilo_job1_ste_icse93=5 if inlist(EMPLOYMENT_STATUS,6)			// Contributing family workers
				replace ilo_job1_ste_icse93=6 if ilo_job1_ste_icse93==. & ilo_lfs==1	// Not classifiable
				replace ilo_job1_ste_icse93=. if ilo_lfs!=1
					label def label_ilo_ste_icse93 1 "1 - Employees" 2 "2 - Employers" 3 "3 - Own-account workers"  ///
													4 "4 - Members of producers cooperatives" 5 "5 - Contributing family workers" ///
													6 "6 - Workers not classifiable by status"
					label val ilo_job1_ste_icse93 label_ilo_ste_icse93
					label var ilo_job1_ste_icse93 "Status in employment (ICSE 93) - Main job"

		* Aggregate categories 
			gen ilo_job1_ste_aggregate=.
				replace ilo_job1_ste_aggregate=1 if ilo_job1_ste_icse93==1				// Employees
				replace ilo_job1_ste_aggregate=2 if inrange(ilo_job1_ste_icse93,2,5)	// Self-employed
				replace ilo_job1_ste_aggregate=3 if ilo_job1_ste_icse93==6				// Not elsewhere classified
					lab def ste_aggr_lab 1 "1 - Employees" 2 "2 - Self-employed" 3 "3 - Not elsewhere classified"
					lab val ilo_job1_ste_aggregate ste_aggr_lab
					label var ilo_job1_ste_aggregate "Status in employment (Aggregate) - Main job"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	/* 	NLFS 2016 Questionnaire
		[E15 (SECTOR_MAJOR2)] - What kind of activities are carried out at (NAME)'s work place? What are its main functions?
		The codes are exactly the same as ISIC Rev. 4.				*/
		
			append using `labels'
			* Use value label from this variable, afterwards drop everything related to this append
			
				* MAIN JOB:

					* ISIC Rev. 4 - 2 digits
						
						gen ilo_job1_eco_isic4_2digits=SECTOR_MAJOR2 if ilo_lfs==1
								lab values ilo_job1_eco_isic4_2digits isic4_2digits
								lab var ilo_job1_eco_isic4_2digits "Economic activity (ISIC Rev. 4), 2 digit level - main job"

					* ISIC Rev. 4 - 1 digit
					* For more information about the equivalence between ISIC Rev. 4 2- and 1- digits, please, see: http://unstats.un.org/unsd/cr/registry/regcst.asp?Cl=27
					
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
							replace ilo_job1_eco_isic4=22 if ilo_job1_eco_isic4_2digits==.
							replace ilo_job1_eco_isic4=. if ilo_lfs!=1
								lab val ilo_job1_eco_isic4 isic4
								lab var ilo_job1_eco_isic4 "Economic activity (ISIC Rev. 4) - main job"

					* Aggregated level 
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
								lab var ilo_job1_eco_aggregate "Economic activity (Aggregate) - main job"


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_job1_ocu_isco88')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

	/* NLFS 2016 Questionnaire
		[E14 (OCCUPATION_MAJOR1)] - What kind of work did (NAME) do on his/her main job? Please describe the work or give the job title.
		The codes of [occupation_major1] are exactly the same as ISCO-88, with one exception:
		The category (90) in the Namibia Standard Occupation Classification (NSOC) is labeled "General labourers, not specified", but this category does not exist in ISCO-88. 
		For information on ISCO-88, please, see: http://www.ilo.org/public/english/bureau/stat/isco/isco88/index.htm */
	
		* ISCO 88 - 2 digits
			gen ilo_job1_ocu_isco88_2digits=OCCUPATION_MAJOR1 if ilo_lfs==1
				replace ilo_job1_ocu_isco88_2digits=. if ilo_lfs==1 & OCCUPATION_MAJOR1==90
							lab values ilo_job1_ocu_isco88_2digits isco88_2digits
							lab var ilo_job1_ocu_isco88_2digits "Occupation (ISCO-88), 2 digit level"

		* ISCO 88 - 1 digit
			gen ilo_job1_ocu_isco88=int(ilo_job1_ocu_isco88_2digits/10) if ilo_lfs==1
				replace ilo_job1_ocu_isco88=10 if ilo_job1_ocu_isco88==0 & ilo_lfs==1
				replace ilo_job1_ocu_isco88=11 if ilo_job1_ocu_isco88==. & ilo_lfs==1
							lab def isco88_1dig_lab 1 "1 - Managers" 2 "2 - Professionals" 3 "Technicians and associate professionals" 4 "4 - Clerks" 5 "5 - Service workers and shop and market sales workers" ///
									6 "6 - Skilled agricultural and fishery workers" 7 "7 - Craft and related trades workers" 8 "8 - Plant and machine operators, and assemblers" ///
									9 "9 - Elementary occupations" 10 "0 - Armed forces occupations" 11 "X - Not elsewhere classified"
							lab val ilo_job1_ocu_isco88 isco88_1dig_lab
							lab var ilo_job1_ocu_isco88 "Occupation (ISCO-88)"	

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
					lab var ilo_job1_ocu_aggregate "Occupation (Aggregate)"
	
		* Skill level
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
*			Institutional sector ('ilo_job1_ins_sector')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	* [E22 ~ EMPLOYER_TYPE] - Which of the following was (NAME)'s employer for this job?
	
		gen ilo_job1_ins_sector=.
			replace ilo_job1_ins_sector=1 if inlist(EMPLOYER_TYPE,2,3) & ilo_lfs==1		// Public
			replace ilo_job1_ins_sector=2 if inlist(EMPLOYER_TYPE,1,4) & ilo_lfs==1		// Private
			replace ilo_job1_ins_sector=2 if ilo_job1_ins_sector==. & ilo_lfs==1
				lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private" 
				lab values ilo_job1_ins_sector ins_sector_lab
				lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities - main job"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Hours of work ('ilo_how')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

		* MAIN JOB:
		
			* 1) Weekly hours USUALLY worked - [E16 ~ TOTAL_HOURS_USUAL] - How many hours per day does (NAME) usually work on his/her main job/activity?
		
				gen ilo_job1_how_usual=TOTAL_HOURS_USUAL if ilo_lfs==1
						lab var ilo_job1_how_usual "Weekly hours usually worked in main job"

			* 2) Weekly hours ACTUALLY worked:
			
				gen ilo_job1_how_actual=ilo_job1_how_usual if ilo_lfs==1
						lab var ilo_job1_how_actual "Weekly hours actually worked in main job"
				
				gen ilo_job1_how_actual_bands=.
					replace ilo_job1_how_actual_bands=1 if ilo_job1_how_actual==0
					replace ilo_job1_how_actual_bands=2 if ilo_job1_how_actual>=1 & ilo_job1_how_actual<=14
					replace ilo_job1_how_actual_bands=3 if ilo_job1_how_actual>=15 & ilo_job1_how_actual<=29
					replace ilo_job1_how_actual_bands=4 if ilo_job1_how_actual>=30 & ilo_job1_how_actual<=34
					replace ilo_job1_how_actual_bands=5 if ilo_job1_how_actual>=35 & ilo_job1_how_actual<=39
					replace ilo_job1_how_actual_bands=6 if ilo_job1_how_actual>=40 & ilo_job1_how_actual<=48
					replace ilo_job1_how_actual_bands=7 if ilo_job1_how_actual>=49 & ilo_job1_how_actual!=.
					replace ilo_job1_how_actual_bands=8 if ilo_job1_how_actual==. & ilo_lfs==1
						lab def how_bands_lab 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"
						lab val ilo_job1_how_actual_bands how_bands_lab
						lab var ilo_job1_how_actual_bands "Weekly hours actually worked bands in main job"		

		* ALL JOBS

		* [E17 ~ TOTAL_HOURS_SECOND] - How many hours per day does (NAME) usually work on his/her second job/activity? */

				gen ilo_joball_how_usual=ilo_job1_how_usual
					replace ilo_joball_how_usual=ilo_joball_how_usual + TOTAL_HOURS_SECOND if TOTAL_HOURS_SECOND!=.
					replace ilo_joball_how_usual=168 if ilo_joball_how_usual>168 & ilo_joball_how_usual!=.
					replace ilo_joball_how_usual=. if ilo_lfs!=1
						lab var ilo_joball_how_usual "Weekly hours usually worked in all jobs"

		* There is no information available on ACTUAL hours of work - Usual hours are used

				gen ilo_joball_how_actual=.
					replace ilo_joball_how_actual = ilo_joball_how_usual
						lab var ilo_joball_how_actual "Weekly hours actually worked in all jobs"

				gen ilo_joball_how_actual_bands=.
					replace ilo_joball_how_actual_bands=1 if ilo_joball_how_actual==0
					replace ilo_joball_how_actual_bands=2 if ilo_joball_how_actual>=1 & ilo_joball_how_actual<=14
					replace ilo_joball_how_actual_bands=3 if ilo_joball_how_actual>=15 & ilo_joball_how_actual<=29
					replace ilo_joball_how_actual_bands=4 if ilo_joball_how_actual>=30 & ilo_joball_how_actual<=34
					replace ilo_joball_how_actual_bands=5 if ilo_joball_how_actual>=35 & ilo_joball_how_actual<=39
					replace ilo_joball_how_actual_bands=6 if ilo_joball_how_actual>=40 & ilo_joball_how_actual<=48
					replace ilo_joball_how_actual_bands=7 if ilo_joball_how_actual>=49 & ilo_joball_how_actual!=.
					replace ilo_joball_how_actual_bands=8 if ilo_lfs==1 & ilo_joball_how_actual_bands==.
						lab def ilo_joball_how_actual_bands 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"
						lab values ilo_joball_how_actual_bands ilo_joball_how_actual_bands
						lab var ilo_joball_how_actual_bands "Weekly hours actually worked bands in all jobs"
						
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job1_job_time')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
		
	/* The 35-hours threshold is used by the Namibian NSO to define time-underemployment.
	Daniel Oherein aggreed that this is a "good" proxy to define part-time employment.		*/
	   
	   * MAIN JOB
		gen ilo_job1_job_time=.
				replace ilo_job1_job_time=1 if ilo_job1_how_usual<35 
				replace ilo_job1_job_time=2 if ilo_job1_how_usual>=35 & ilo_job1_how_usual!=.
				replace ilo_job1_job_time=3 if ilo_job1_job_time!=1 & ilo_job1_job_time!=2 & ilo_lfs==1
					lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
					lab val ilo_job1_job_time job_time_lab
					lab var ilo_job1_job_time "Job (Working time arrangement) - Main job"	

		* ALL JOBS
		 gen ilo_joball_job_time=.
				replace ilo_joball_job_time=1 if ilo_joball_how_usual<40 
				replace ilo_joball_job_time=2 if ilo_joball_how_usual>=40 & ilo_joball_how_usual!=.
				replace ilo_joball_job_time=3 if ilo_joball_job_time!=1 & ilo_joball_job_time!=2 & ilo_lfs==1
					lab val ilo_joball_job_time job_time_lab
					lab var ilo_joball_job_time "Job (Working time arrangement) - All jobs"	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job1_job_contract') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			

		gen ilo_job1_job_contract=.
			replace ilo_job1_job_contract=1 if CONTRACT_AGREEMENT==2 & ilo_lfs==1								// Permanent
			replace ilo_job1_job_contract=2 if inlist(CONTRACT_AGREEMENT,1,3) & ilo_lfs==1						// Temporary
			replace ilo_job1_job_contract=3 if ilo_job1_job_contract!=1 & ilo_job1_job_contract!=2 & ilo_lfs==1	// Unknown
				lab def contr_type 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"
				lab val ilo_job1_job_contract contr_type
				lab var ilo_job1_job_contract "Job (Type of contract)"
				

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Formal / Informal Economy ('ilo_job1_ife_prod' 'ilo_job1_ife_nature') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			

	/* Questions used: * [E22 ~ EMPLOYER_TYPE] - Institutional sector
					   * Not available - Destination of production	
					   * [E32 ~ ENT_KEEP_ACCOUNTS_YN] - Bookkeeping
					   * [E30 ~ ENTERPRISE_REGISTERED_YN] - Registration
					   * [E28 ~ NUM_WORKERS] - Size of the company
					   * [E34 ~ ENT_NUM_EMPLOYEES] - Number of employees
					   * No question - Location of workplace

					   * [E24 ~ PAID_LEAVE_CB_1-7]: (1) Sick leave, (2) Maternity/ paternity, (3) Vacation, (4) Compassionate, (5) Study, (6) Other 
					   * Pension fund contributions are not included
 	*/
	
	* 1) Unit of production
	
		gen social_security=.
			replace social_security=1 if (ANNUAL_LEAVE_YN==1 & PAID_LEAVE_CB_1==1 & PAID_LEAVE_CB_3==1 & ilo_lfs==1)
	
		gen ilo_job1_ife_prod=.
			replace ilo_job1_ife_prod=2 if inlist(EMPLOYER_TYPE,2,3) | (!inlist(EMPLOYER_TYPE,2,3) & inlist(ENT_KEEP_ACCOUNTS_YN,1)) | (!inlist(EMPLOYER_TYPE,2,3) & !inlist(ENT_KEEP_ACCOUNTS_YN,1) & inlist(ENTERPRISE_REGISTERED_YN,1)) | (!inlist(EMPLOYER_TYPE,2,3) & !inlist(ENT_KEEP_ACCOUNTS_YN,1) & !inlist(ENTERPRISE_REGISTERED_YN,1) & social_security==1)
	
			replace ilo_job1_ife_prod=3 if (ilo_job1_eco_isic4_2digits==97 | ilo_job1_ocu_isco88_2digits==62)
				*  EMPLOYER_TYPE==4 seems to broad
			replace ilo_job1_ife_prod=1 if (ilo_lfs==1 & ilo_job1_ife_prod==.)

			replace ilo_job1_ife_prod=. if ilo_lfs!=1 
						
						lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 
						lab val ilo_job1_ife_prod ilo_ife_prod_lab
						lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"

	* 2) Nature of job
	
		gen ilo_job1_ife_nature=.
			replace ilo_job1_ife_nature=1 if (inlist(ilo_job1_ste_icse93,2,3,4) & ilo_job1_ife_prod!=2) | (ilo_job1_ste_icse93==1 & social_security!=1) | inlist(ilo_job1_ste_icse93,5,6)								
			
			replace ilo_job1_ife_nature=2 if (inlist(ilo_job1_ste_icse93,2,3,4) & ilo_job1_ife_prod==2) | (ilo_job1_ste_icse93==1 & social_security==1)												
				
			replace ilo_job1_ife_nature=. if ilo_lfs!=1
			
						lab def ife_nature_lab 1 "1 - Persons with informal main job" 2 "2 - Persons with formal main job"
						lab val ilo_job1_ife_nature ife_nature_lab
						lab var ilo_job1_ife_nature "Informal / Formal Economy (Nature of job) - Main job"

		drop social_security
		

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Monthly labour related income ('ilo_job1_lri') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			

	/* [E29 ~ GROSS_INCOME_MONTH] - How much is (Name) gross salary/wage per month in his/her main job?*/

	* Employees		
			
		gen ilo_job1_lri_ees=GROSS_INCOME_MONTH if ilo_job1_ste_aggregate==1
			replace ilo_job1_lri_ees=. if (ilo_lfs!=1 | ilo_job1_lri_ees<0)
				lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"	

	* Self-employed - No information
	   

***********************************************************************************************
*			PART C3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_joball_tru') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			

  * No availability criteria - Not possible to define	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupational injury ('ilo_joball_inj') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
		
	* Not available

	
***********************************************************************************************
*			PART C3.3. UNEMPLOYMENT: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Category of unemployment ('ilo_cat_une')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	* Not available

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

		* Details - [E41 ~ TIME_UNEMPLOYED] - How long has (NAME) been without work and available for work?
		
			gen ilo_dur_details=.
				replace ilo_dur_details=TIME_UNEMPLOYED & ilo_lfs==2
				replace ilo_dur_details=7 if ilo_dur_details==. & ilo_lfs==2
					lab def ilo_unemp_det 1 "Less than 1 month" 2 "1 month to less than 3 months" 3 "3 months to less than 6 months" ///
										  4 "6 months to less than 12 months" 5 "12 months to less than 24 months" 6 "24 months or more" 7 "Not elsewhere classified"
					lab values ilo_dur_details ilo_unemp_det
					lab var ilo_dur_details "Duration of unemployment (Details)"

		* Aggregate
		
			gen ilo_dur_aggregate=.
				replace ilo_dur_aggregate=1 if inrange(ilo_dur_details,1,3) & ilo_lfs==2 	// Less than 6 months
				replace ilo_dur_aggregate=2 if ilo_dur_details==4 & ilo_lfs==2				// 6 months to less than 12 months
				replace ilo_dur_aggregate=3 if inlist(ilo_dur_details,5,6) & ilo_lfs==2		// 12 months or more
				replace ilo_dur_aggregate=4 if inlist(ilo_dur_details,7,.) & ilo_lfs==2		// Not elsewhere classified
					lab def ilo_unemp_agr 1 "Less than 6 months" 2 "6 months to less than 12 months" ///
										  3 "12 months or more" 4 "Not elsewhere classified"
					lab values ilo_dur_aggregate ilo_unemp_agr
					lab var ilo_dur_aggregate "Duration of unemployment (Aggregate)"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

		* Not available

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
		* Not available

	
***********************************************************************************************
*			PART C3.4. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
	
/* 	[E36 ~ COULD_WORK_YN] - If (NAME) has been offered a job, would (NAME) have been ready to work during the last 7 days?
	[E38 ~ TRY_START_BUSINESS_YN] - In the past 30 days, was  (Name) actively looking for a job (that would give wage, salary or in-kind payment) or did (NAME) try to start business? 
	Comment: 3 and 4 can't be defined, so the rest of the persons in [ilo_lfs==3] should go in [ilo_olf_dlma=5] */

		gen ilo_olf_dlma=.
			replace ilo_olf_dlma=1 if TRY_START_BUSINESS_YN==1 & COULD_WORK_YN==2 & ilo_lfs==3	// Seeking, not available
			replace ilo_olf_dlma=2 if TRY_START_BUSINESS_YN==2 & COULD_WORK_YN==1 & ilo_lfs==3	// Not seeking, available
			replace ilo_olf_dlma=5 if ilo_olf_dlma==. & ilo_lfs==3								// Not elsewhere classified
				lab def dlma 1 "1 - Seeking, not available (Unavailable jobseekers)" 2 "2 - Not seeking, available (Available potential jobseekers)" ///
							 3 "3 - Not seeking, not available, willing (Willing non-jobseekers)" 4 "4 - Not seeking, not available, not willing" ///
							 5 "5 - Not elsewhere classified"
				lab val ilo_olf_dlma dlma
				lab var ilo_olf_dlma "Labour market attachment (Degree of)"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reason for not seeking job ('ilo_olf_reason') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

* [E40 ~ REASON_CANT_START_WORK] - What was the main reason that (NAME) didn't look for work or try to start his/ her business during the last 30 days?

		gen ilo_olf_reason=.
			replace ilo_olf_reason=1 if	inlist(REASON_CANT_START_WORK,1,3) & ilo_lfs==3			//Labour market - Discouraged
			replace ilo_olf_reason=2 if	inlist(REASON_CANT_START_WORK,2,5) & ilo_lfs==3			//Other labour market reasons
			replace ilo_olf_reason=3 if	inlist(REASON_CANT_START_WORK,8,9,10,11) & ilo_lfs==3	//Personal/Family-related
			replace ilo_olf_reason=5 if inlist(REASON_CANT_START_WORK,6,7) & ilo_lfs==3			//Not elsewhere classified
			replace ilo_olf_reason=5 if ilo_olf_reason==. & ilo_lfs==3							//Not elsewhere classified
				lab def reasons_lab 1 "1 - Labour market (Discouraged)" 2 "2 - Other labour market reasons" 3 "3 - Personal / Family-related" ///
									4 "4 - Does not need/want to work" 5 "5 - Not elsewhere classified"
				lab val ilo_olf_reason reasons_lab 
				lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seeker ('ilo_dis')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
	
	gen ilo_dis=1 if ilo_lfs==3 & !inlist(ilo_lfs,1,2) & COULD_WORK_YN==1 & ilo_olf_reason==1
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


***********************************************************************************************
***********************************************************************************************

*			D. SAVE ILO-VARIABLES IN A NEW DATASET

***********************************************************************************************
***********************************************************************************************

* -------------------------------------------------------------
* 	Prepare final datasets
* -------------------------------------------------------------

* 1 - Full dataset with original variables and ILO ones
	
	cd "$outpath"

        compress
		saveold NAM_LFS_2016_FULL, version(12) replace

* 2 - Dataset with only 'ILO' variables
	
		keep ilo*
		saveold NAM_LFS_2016_ILO, version(12) replace