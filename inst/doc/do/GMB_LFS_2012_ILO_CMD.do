* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Gambia, 2012
* DATASET USED: Gambia LFS 2012
* NOTES: 
* Files created: Standard variables on LFS Gambia 2012
* Authors: Podjanin
* Who last updated the file: Podjanin, A.
* Starting Date: 18 November 2016
* Last updated: 01 February 2017
***********************************************************************************************



*******************************************************************
 /* 1.	Set up work directory, file name, variables and function */
*******************************************************************

clear all 

set more off

global path "J:\COMMON\STATISTICS\DPAU\MICRO"
global country "GMB"
global source "LFS"
global time "2012"

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

	use GMB_2012_LFS_STATA, clear	
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

*			2. MAP VARIABLES

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

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

	gen ilo_wgt=estimator2
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

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: Minimum age 10 - maximal value 97 --> people above 97 also included there

	gen ilo_age=HB5
			replace ilo_age=. if inlist(HB5,98,99)
				* as it corresponds to "doesn't know" and "missing"
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
*			Working age population ('ilo_wap') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*           
* Comment: 	

	gen ilo_wap=.
		replace ilo_wap=1 if ilo_age>=15 & ilo_age!=.
		replace ilo_wap=0 if ilo_age<15 | ilo_age==.
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
		replace ilo_lfs=1 if A1A==1 | A1B==1 | A1C==1 | A1D==1 | (A2==1 & inlist(A4,1,2,3)) | inlist(A6,1,2,3,4,5,6,9,10)
		replace ilo_lfs=2 if ((A1A==2 & A1B==2 & A1C==2 & A1D==2 & A2==2) | inlist(A6,7,8,11)) & ((G1A==1 & G8A==1) | (G1B==1 & G8B==1) | (G3B==1 & G8B==1) | (G3A==1 & G8A==1)) 
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

* Comment: --> force missing values into "one job only"

	gen ilo_mjh=.
		replace ilo_mjh=1 if C1==2
		replace ilo_mjh=2 if C1==1
		replace ilo_mjh=. if ilo_lfs!=1
				replace ilo_mjh=1 if ilo_mjh==. & ilo_lfs==1
			lab def lab_ilo_mjh 1 "1 - One job only" 2 "2 - More than one job"
			lab val ilo_mjh lab_ilo_mjh
			lab var ilo_mjh "Multiple job holders"			

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
		
		egen ilo_job1_how_actual=rowtotal(MOD2A TUD2A WED2A THD2A FRD2A SAD2A SUD2A), m
			replace ilo_job1_how_actual=. if ilo_lfs!=1
			lab var ilo_job1_how_actual "Weekly hours actually worked in main job"
			
		* Secondary job
			
		egen ilo_job2_how_actual=rowtotal(MOD2B TUD2B WED2B THD2B FRD2B SAD2B SUD2B), m 
			replace ilo_job2_how_actual=. if ilo_lfs!=1 & ilo_mjh!=2
			lab var ilo_job2_how_actual "Weekly hours actually worked in secondary job" 
		
		* All jobs
		
		egen ilo_joball_how_actual=rowtotal(ilo_job1_how_actual ilo_job2_how_actual), m
			replace ilo_joball_how_actual=168 if ilo_joball_how_actual>168
			replace ilo_joball_how_actual=. if ilo_lfs!=1
			lab var ilo_joball_how_actual "Weekly hours actually worked in all jobs"		
	
	* Hours usually worked
	
		* Primary job
		
		gen ilo_job1_how_usual=D1AM
			replace ilo_job1_how_usual=. if ilo_lfs!=1
			lab var ilo_job1_how_usual "Weekly hours usually worked in main job"
			
		* Secondary job
			
		gen ilo_job2_how_usual=D1BS
			replace ilo_job2_how_usual=. if ilo_lfs!=1 & ilo_mjh!=2
			lab var ilo_job2_how_usual "Weekly hours usually worked in secondary job"
			
		* All jobs
		
		egen ilo_joball_how_usual=rowtotal(ilo_job1_how_usual ilo_job2_how_usual), m
			replace ilo_joball_how_usual=168 if ilo_joball_how_usual>168
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
	
* Comment: no national threshold found, but national average such as cited in the report on the Gambian LFS for 2012
		*	taken, which is considered to be of 49 hours per week
	
	gen ilo_job1_job_time=.
		replace ilo_job1_job_time=1 if ilo_job1_how_usual<=48 & ilo_job1_how_usual!=.
		replace ilo_job1_job_time=2 if ilo_job1_how_usual>=49 & ilo_job1_how_usual!=.
		replace ilo_job1_job_time=3 if ilo_job1_job_time==. & ilo_lfs==1
				replace ilo_job1_job_time=. if ilo_lfs!=1
			lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
			lab val ilo_job1_job_time job_time_lab
			lab var ilo_job1_job_time "Job (Working time arrangement)"	
			
			* if there is any secondary employment, by definition it is part-time, and therefore
			* variable for secondary employment not being defined
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_tru') [can't be defined]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*                
* Comment: no national threshold found, but national average such as cited in the report on the Gambian LFS for 2012
		*	taken, which is considered to be of 49 hours per week
		
		* --> use question on number of hours that person could work additionally in order to capture availability

	
	gen ilo_joball_tru=1 if ilo_joball_how_actual<=48 & E1==1 & E2!=.
		replace ilo_joball_tru=. if ilo_lfs!=1
			lab def tru_lab 1 "Time-related underemployment"
			lab val ilo_joball_tru tru_lab
			lab var ilo_joball_tru "Time-related underemployment"			

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Earnings ('ilo_ear_ees' and 'ilo_ear_slf') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	
* Comment: 

	*Currency in Gambia: Dalasi
	
		* generate help variables
		
		gen set_rate=.
			replace set_rate=(F2*8*365/12) if F3==1
			replace set_rate=(F2*365/12) if F3==2
			replace set_rate=(F2*52/12) if F3==3
			replace set_rate=(F2*26/12) if F3==4
			replace set_rate=(F2*2) if F3==5
			replace set_rate=F2 if F3==6
			replace set_rate=(F2/12) if F3==7
			
		gen sales_earn_prim=F4 if F4!=999999 
		
		* keep F6 as such
		
		gen in_kind_prim=.
			replace in_kind_prim=(F8*8*365/12) if F9==1
			replace in_kind_prim=(F8*365/12) if F9==2
			replace in_kind_prim=(F8*52/12) if F9==3
			replace in_kind_prim=(F8*26/12) if F9==4
			replace in_kind_prim=(F8*2) if F9==5
			replace in_kind_prim=F8 if F9==6
			replace in_kind_prim=(F8/12) if F9==7
	
	* Primary employment 
	
			* Monthly earnings of employees
	
		egen ilo_job1_lri_ees=rowtotal(set_rate sales_earn_prim F6 in_kind_prim), m
			replace ilo_job1_lri_ees=. if ilo_lfs!=1 | ilo_job1_lri_ees<0
			lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"
	
			* Self employment
			
		gen set_rate_self=.
			replace set_rate_self=(F11*8*365/12) if F12==1
			replace set_rate_self=(F11*365/12) if F12==2
			replace set_rate_self=(F11*52/12) if F12==3
			replace set_rate_self=(F11*26/12) if F12==4
			replace set_rate_self=(F11*2) if F12==5
			replace set_rate_self=F11 if F12==6
			replace set_rate_self=(F11/12) if F12==7
				replace set_rate_self=. if F11>900000
				
		gen earn_sales_self=F13 if F13!=999998
		
		gen earnings_self=F14 if F14!=999998
		
		gen in_kind_prim_self=.
			replace in_kind_prim_self=(F16*8*365/12) if F17==1
			replace in_kind_prim_self=(F16*365/12) if F17==2
			replace in_kind_prim_self=(F16*52/12) if F17==3
			replace in_kind_prim_self=(F16*26/12) if F17==4
			replace in_kind_prim_self=(F16*2) if F17==5
			replace in_kind_prim_self=F16 if F17==6
			replace in_kind_prim_self=(F16/12) if F17==7	
				replace in_kind_prim_self=. if F16==999999
			
		
		* note that the revenue related to self-employment includes also the value of own consumption 
			* (cf. resolution from 1998)
			
		egen ilo_job1_lri_slf=rowtotal(set_rate_self earn_sales_self earnings_self in_kind_prim_self), m
			replace ilo_job1_lri_slf=. if ilo_lfs!=1
			lab var ilo_job1_lri_slf "Monthly labour related income of self-employed in main job"
			
	* Secondary employment
	
		gen set_rate_sec=.
			replace set_rate_sec=(F19*8*365/12) if F20==1
			replace set_rate_sec=(F19*365/12) if F20==2
			replace set_rate_sec=(F19*52/12) if F20==3
			replace set_rate_sec=(F19*26/12) if F20==4
			replace set_rate_sec=(F19*2) if F20==5
			replace set_rate_sec=F19 if F20==6
			replace set_rate_sec=(F19/12) if F20==7
			
		gen sales_earn_sec=F21 if F21!=999999 
		
		* keep F22 as such
		
		gen in_kind_sec=.
			replace in_kind_sec=(F24*8*365/12) if F25==1
			replace in_kind_sec=(F24*365/12) if F25==2
			replace in_kind_sec=(F24*52/12) if F25==3
			replace in_kind_sec=(F24*26/12) if F25==4
			replace in_kind_sec=(F24*2) if F25==5
			replace in_kind_sec=F24 if F25==6
			replace in_kind_sec=(F24/12) if F25==7
	
			* Monthly earnings of employees
	
		egen ilo_job2_lri_ees=rowtotal(set_rate_sec sales_earn_sec F22 in_kind_sec), m
			replace ilo_job2_lri_ees=. if (ilo_lfs!=1 & ilo_mjh!=2) | ilo_job2_lri_ees<0
			lab var ilo_job2_lri_ees "Monthly earnings of employees in secondary job"
	
			* Self employment
			
		gen set_rate_self_sec=.
			replace set_rate_self_sec=(F27*8*365/12) if F28==1
			replace set_rate_self_sec=(F27*365/12) if F28==2
			replace set_rate_self_sec=(F27*52/12) if F28==3
			replace set_rate_self_sec=(F27*26/12) if F28==4
			replace set_rate_self_sec=(F27*2) if F28==5
			replace set_rate_self_sec=F27 if F28==6
			replace set_rate_self_sec=(F27/12) if F28==7
				replace set_rate_self_sec=. if F27>900000
				
		gen earn_sales_self_sec=F29 if F29!=99998
		
		gen earnings_self_sec=F30 if F30<9998
		
		gen in_kind_sec_self=.
			replace in_kind_sec_self=(F32*8*365/12) if F33==1
			replace in_kind_sec_self=(F32*365/12) if F33==2
			replace in_kind_sec_self=(F32*52/12) if F33==3
			replace in_kind_sec_self=(F32*26/12) if F33==4
			replace in_kind_sec_self=(F32*2) if F33==5
			replace in_kind_sec_self=F32 if F33==6
			replace in_kind_sec_self=(F32/12) if F33==7	
				replace in_kind_sec_self=. if F32==999999
			
		
		* note that the revenue related to self-employment includes also the value of own consumption 
			* (cf. resolution from 1998)
			
		egen ilo_job2_lri_slf=rowtotal(set_rate_self_sec earn_sales_self_sec earnings_self_sec in_kind_sec_self), m
			replace ilo_job2_lri_slf=. if (ilo_lfs!=1 & ilo_mjh!=2)
			lab var ilo_job2_lri_slf "Monthly labour related income of self-employed in secondary job"
		
				

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: 

		gen ilo_sex=HB3
			label define label_Sex 1 "1 - Male" 2 "2 - Female"
			label values ilo_sex label_Sex 
			lab var ilo_sex "Sex"
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Level of education ('ilo_edu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: Two types of educational systems being considered - "Western" and "Madrassa"
			* note that high number of missing value is due to the fact that question only asked if person aged 5+

		gen ilo_edu_isced97=.
		replace ilo_edu_isced97=1 if HB21==2 | inlist(HB20A,8,108) | inlist(HB22,8,108)
		replace ilo_edu_isced97=2 if inrange(HB20A,9,15) | inrange(HB20A,109,115) | inrange(HB22,9,15) | inrange(HB22,109,115)
		replace ilo_edu_isced97=3 if inrange(HB20A,16,31) | inrange(HB20A,116,131) | inrange(HB22,16,31) | inrange(HB22,116,131)
		replace ilo_edu_isced97=4 if inrange(HB20A,32,34) | inrange(HB20A,132,134) | inrange(HB22,32,34) | inrange(HB22,132,134) | inlist(HB20A,41,141) | inlist(HB22,41,141)
		replace ilo_edu_isced97=5 if inrange(HB20A,35,36) | inrange(HB20A,135,136) | inrange(HB22,35,36) | inrange(HB22,135,136)
		replace ilo_edu_isced97=6 if inlist(HB20A,51,151) | inlist(HB22,51,151)
		replace ilo_edu_isced97=7 if inlist(HB20A,62,162) | inlist(HB22,62,162)
		replace ilo_edu_isced97=8 if inlist(HB20A,63,64,163,164) | inlist(HB22,63,64,163,164)
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
			replace ilo_edu_attendance=1 if HB19A==1
			replace ilo_edu_attendance=2 if HB19A==2
			replace ilo_edu_attendance=3 if ilo_edu_attendance==.
				lab def edu_attendance_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
				lab val ilo_edu_attendance edu_attendance_lab
				lab var ilo_edu_attendance "Education (Attendance)"		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training (NEETs) ('ilo_neet') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: --> add also those that are in the category "not elsewhere classified" (variable ilo_edu_attendance)

		gen ilo_neet=.
			replace ilo_neet=1 if inrange(ilo_age,15,24) & ilo_lfs!=1 & inlist(ilo_edu_attendance,2,3)
				lab def ilo_neet_lab 1 "Youth not in education, employment or training"
				lab val ilo_neet ilo_neet_lab
				lab var ilo_neet "Youth not in education, employment or training" 
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Geographical coverage ('ilo_geo') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: 

		gen ilo_geo=HA3
			lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural"
			lab val ilo_geo ilo_geo_lab
			lab var ilo_geo "Geographical coverage"	

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
			replace ilo_job1_ste_icse93=6 if B5==6 | (ilo_job1_ste_icse93==. & ilo_lfs==1)
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
			replace ilo_job2_ste_icse93=6 if C8==6 | (ilo_job2_ste_icse93==. & ilo_lfs==1 & ilo_mjh==2)
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
* Comment: ISIC Rev. 4 being used and initially indicated on 4-digits level --> keep only 2 digits level

	* economic activity indicated both for primary and secondary activity --> capture it for both
	
		* by mistake, for secondary job, 5-digit level appears, while this is actually not possible... -> don't define variable for secondary job

	gen indu_code_prim=int(B3/100) if ilo_lfs==1 
	
	*gen indu_code_sec=
		
		* Import value labels

		append using `labels', gen (lab)
					
		* Primary activity
		
		gen ilo_job1_eco_isic4_2digits=indu_code_prim
			lab values ilo_job1_eco_isic4 isic4_2digits
			lab var ilo_job1_eco_isic4_2digits "Economic activity (ISIC Rev. 4), 2 digit level"
			
		
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
* Comment: according to report, ISCO 08 being used
		* Note that at the two digit level some categories are being considered for which we don't have a label as they don't 
			* fit the standard version of ISCO 08 --> therefore while tabulating the variable at the two digit level, some
			* values won't have a value label

	gen occ_code_prim=int(B1_ILO/100) if ilo_lfs==1
	
	* 2 digit level
	
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
*			Institutional sector of economic activities ('ilo_ins_sector') [don't define]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
		
* Comment: only info about primary occupation and question asked to employees only --> therefore info can't be 
				* used to define this variable

	* Primary occupation
	
	/* gen ilo_job1_ins_sector=.
		replace ilo_job1_ins_sector=1 if inlist(B16,1,2,6)
		replace ilo_job1_ins_sector=2 if inlist(B16,3,4,5,7)
				replace ilo_job1_ins_sector=. if ilo_lfs!=1
				* in order to avoid having missing values, force the rest into private
				replace ilo_job1_ins_sector=2 if ilo_job1_ins_sector==. & ilo_lfs==1
			lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
			lab values ilo_job1_ins_sector ins_sector_lab
			lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities" */
					
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job_contract') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment: no info about nature of contract in secondary job

	* Primary employment
	
	gen ilo_job1_job_contract=.
		replace ilo_job1_job_contract=1 if B7==2 | inlist(B8,1,2)
		replace ilo_job1_job_contract=2 if B7==1 | B8==3
		replace ilo_job1_job_contract=3 if (ilo_job1_job_contract==. & ilo_job1_ste_aggregate==1)
				replace ilo_job1_job_contract=. if ilo_job1_ste_aggregate!=1
			lab def job_contract_lab 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"
			lab val ilo_job1_job_contract job_contract_lab
			lab var ilo_job1_job_contract "Job (Type of contract)"		
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Disability status ('ilo_dsb_details') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment: Queestionnaire asks whether an individual is affected by thirteen different types of disability: consider all of 
	* them for the definition of the aggregate classification
	
	*Disabilities: whether person is: blind, partially sighted, deaf and dumb, deaf, hard of hearing, dumb, mental illness, intellectual, 
		* mute, speech impairment, physically disabled, mentally retarded, has autism
				
	gen ilo_dsb_aggregate=.
		replace ilo_dsb_aggregate=1 if J9G1==2 & J9G2==2 & J9G3==2 & J9G4==2 & J9G5==2 & J9G6==2 & J9G7==2 & J9G8==2 & J9G9==2 & J9G10==2 & J9G11==2 & J9G12==2 & J9G13==2
		replace ilo_dsb_aggregate=2 if J9G1==1 | J9G2==1 | J9G3==1 | J9G4==1 | J9G5==1 | J9G6==1 | J9G7==1 | J9G8==1 | J9G9==1 | J9G10==1 | J9G11==1 | J9G12==1 | J9G13==1
			* force missing values (for ilo_wap==1) into category "without disability"
				replace ilo_dsb_aggregate=1 if ilo_dsb_aggregate==. & ilo_wap==1
			label def dsb_aggregate_lab 1 "Persons without disability" 2 "Persons with disability"
			label val ilo_dsb_aggregate dsb_aggregate_lab
			label var ilo_dsb_aggregate "Disability status (Aggregate)"			
			
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Cases of non-fatal occupational injury ('ilo_joball_oi_case') [done]
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*
* Comment: 
			
	gen ilo_joball_oi_case=1 if ilo_lfs==1 & (J1==1 | J2==1 | J3==1 | J4==1 | J5==1 | J6==1 | J7==1 | J8==1 | J9==1 | J10==1 | J96==1)
		lab var ilo_joball_oi_case "Cases of non-fatal occupational injury"
		
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Days lost due to cases of occupational injury ('ilo_joball_oi_day') [no info]
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*
* Comment: 

	*gen ilo_joball_oi_day=.
		*lab var ilo_joball_oi_day "Days lost due to cases of occupational injury"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of unemployment ('ilo_cat_une') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: 
	
	gen ilo_cat_une=.
		replace ilo_cat_une=1 if H1==1
		replace ilo_cat_une=2 if H1==2
		replace ilo_cat_une=3 if ilo_cat_une==. & ilo_lfs==2
				replace ilo_cat_une=. if ilo_lfs!=2
			lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
			lab val ilo_cat_une cat_une_lab
			lab var ilo_cat_une "Category of unemployment"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment:

	 gen ilo_dur_details=.
		replace ilo_dur_details=1 if G7AM==0 & G7AY==0
		replace ilo_dur_details=2 if inrange(G7AM,1,2) & G7AY==0
		replace ilo_dur_details=3 if inrange(G7AM,3,5) & G7AY==0
		replace ilo_dur_details=4 if inrange(G7AM,6,11) & G7AY==0
		replace ilo_dur_details=5 if (inrange(G7AM,12,23) & G7AY==0) | G7AY==1
		replace ilo_dur_details=6 if ((G7AM>=24 & G7AM!=. & G7AY==0) | G7AY>=2) & G7AY!=.
		replace ilo_dur_details=7 if ilo_dur_details==. & ilo_lfs==2
		replace ilo_dur_details=. if ilo_lfs!=2
			lab def ilo_unemp_det 1 "Less than 1 month" 2 "1 month to less than 3 months" 3 "3 months to less than 6 months" 4 "6 months to less than 12 months" 5 "12 months to less than 24 months" ///
									6 "24 months or more" 7 "Not elsewhere classified"
			lab values ilo_dur_details ilo_unemp_det
			lab var ilo_dur_details "Duration of unemployment (Details)" 
			
	* in order to avoid putting any notes and as the exact duration is not precised if person seeking for a job for 52 weeks, take only the aggregate version
			
			
	gen ilo_dur_aggregate=.
		replace ilo_dur_aggregate=1 if inrange(ilo_dur_details,1,3)
		replace ilo_dur_aggregate=2 if ilo_dur_details==4
		replace ilo_dur_aggregate=3 if inlist(ilo_dur_details,5,6)
		replace ilo_dur_aggregate=4 if (ilo_dur_aggregate==. & ilo_lfs==2) | ilo_dur_details==7
				replace ilo_dur_aggregate=. if ilo_lfs!=2
			lab def ilo_unemp_aggr 1 "Less than 6 months" 2 "6 months to less than 12 months" 3 "12 months or more" 4 "Not elsewhere classified"
			lab val ilo_dur_aggregate ilo_unemp_aggr
			lab var ilo_dur_aggregate "Duration of unemployment (Aggregate)"
		
	
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


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu_isco08') [don't define]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			
* Comment: 
	 
	gen prevocu_cod=int(H6B/1000) if ilo_lfs==2
	
	gen ilo_prevocu_isco08=prevocu_cod
		replace ilo_prevocu_isco08=10 if ilo_prevocu_isco08==0
		replace ilo_prevocu_isco08=11 if ilo_prevocu_isco08==. & ilo_cat_une==1 & ilo_lfs==2
			replace ilo_prevocu_isco08=. if ilo_cat_une!=1 
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
*			Previous economic activity ('ilo_preveco_isic4') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment:

		gen preveco_cod=int(H4/100) if ilo_lfs==2
		
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
		replace ilo_preveco_isic4=22 if ilo_preveco_isic4==. & ilo_cat_une==1 & ilo_lfs==2
				replace ilo_preveco_isic4=. if ilo_lfs!=2 & ilo_cat_une!=1
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
*			Degree of labour market attachment ('ilo_olf_dlma') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: Degree of labour market attachment of persons outside the labour force
		
		* as 'seeking for a job' also considered if a person was trying to start an own business
	
	gen ilo_olf_dlma=.
		replace ilo_olf_dlma=1 if (G1A==1 & G8A==2) | (G1B==1 & G8B==2)
		replace ilo_olf_dlma=2 if (G1A==2 & G8A==1) | (G1B==2 & G8B==1)
		replace ilo_olf_dlma=3 if (G1A==2 & G8A==2 & G4A==1) | (G1B==2 & G8B==2 & G4B==1)
		replace ilo_olf_dlma=4 if (G1A==2 & G8A==2 & G4A==2) | (G1B==2 & G8B==2 & G4B==2)
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
* Comment: question used --> reason for not seeking employment (as several questions regarding willingness and availability appear in the questionnaire)

			* values referring to the list of answers available in the questionnaire
	
	gen ilo_olf_reason=.
		replace ilo_olf_reason=1 if inlist(G5A,1,2,7,8,9,10,11,13)
		replace ilo_olf_reason=2 if inlist(G5A,3,4,5,6,14)
		/* replace ilo_olf_reason=3 if */
		replace ilo_olf_reason=4 if ilo_olf_reason==. & ilo_lfs==3
			replace ilo_olf_reason=. if ilo_lfs!=3
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

		gen ilo_dis=1 if ilo_lfs==3 & ilo_olf_reason==1 & G8A==1
			lab def ilo_dis_lab 1 "Discouraged job-seekers" 
			lab val ilo_dis ilo_dis_lab
			lab var ilo_dis "Discouraged job-seekers" 
			

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Informal/Formal economy: Unit of production (ilo_job1_ife_prod) [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* 
* Comment:
	
	* Useful questions: B16: Institutional sector 
					*	A4: Destination of production (only asked to people working on household's farms)
					*	B19: Bookkeeping
					*	B18A & B18B: Registration (VAT and income tax)
					*	B22: Location of workplace
					* 	B20: Size of the establishment
					*	B10: Social security contributions
					*	B11: Paid annual leave
					*	B12A: Paid sick leave
					
			* Social security coverage: person considered as having a social security coverage when:
					* a) having a pension fund
					* b) being entitled to paid annual leave
					* c) being entitled to paid sick leave
					
				gen soc_sec_cov=1 if B10==1 & B11==1 & B12A==1
				
			* generate also a help variable for registration, as questionnaire includes one question asking whether the enterprise is registered for VAT and another one 
				* referring to income tax
				
				gen registration=1 if B18A==1 & B18B==1
				
			* even if not precised, probably values associated to size equal to 9999 are to be considered as non responses
			
				gen size_inf=B20 if B20!=9999
					
	gen ilo_job1_ife_prod=.
		replace ilo_job1_ife_prod=1 if !inlist(B16,1,2,5) & A4!=4 & B19!=1 & registration!=1 & ((inlist(B22,1,2,5,6,8) & soc_sec_cov!=1) | (!inlist(B22,1,2,3,5,6,8) & (size_inf<5 | size_inf==.) & soc_sec_cov!=1))
		replace ilo_job1_ife_prod=2 if inlist(B16,1,2) | (!inlist(B16,1,2,5) & A4!=4 & B19==1) | (!inlist(B16,1,2,5) & A4!=4 & B19!=1 & registration==1) | (!inlist(B16,1,2,5) & A4!=4 & B19!=1 & registration!=1 & ///
										((inlist(B22,1,2,5,6,8) & soc_sec_cov==1) | (!inlist(B22,1,2,3,5,6,8) & size_inf>=5 & size_inf!=.) | (!inlist(B22,1,2,3,5,6,8) & (size_inf<5 | size_inf==.) & soc_sec_cov==1)))
		replace ilo_job1_ife_prod=3 if B16==5 | (!inlist(B16,1,2,5) & A4==4) | (!inlist(B16,1,2,5) & A4!=4 & B19!=1 & registration!=1 & B22==3) | ilo_job1_ocu_isco08_2digits==63 | ilo_job1_eco_isic4_2digits==97
		replace ilo_job1_ife_prod=4 if ilo_job1_ife_prod==. & ilo_lfs==1
						replace ilo_job1_ife_prod=1 if ilo_job1_ife_prod==4
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
		replace ilo_job1_ife_nature=1 if inlist(ilo_job1_ste_icse93,5,6) | (ilo_job1_ste_icse93==1 & soc_sec_cov!=1) | (inlist(ilo_job1_ste_icse93,2,3,4) & inlist(ilo_job1_ife_prod,1,3))
		replace ilo_job1_ife_nature=2 if (ilo_job1_ste_icse93==1 & soc_sec_cov==1) | (inlist(ilo_job1_ste_icse93,2,3,4) & ilo_job1_ife_prod==2)
		replace ilo_job1_ife_nature=. if ilo_lfs!=1
			lab def ife_nature_lab 1 "1 - Persons with informal main job" 2 "2 - Persons with formal main job"
			lab val ilo_job1_ife_nature ife_nature_lab
			lab var ilo_job1_ife_nature "Informal / Formal Economy (Nature of job)"
			

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
		
		drop indu_code_* occ_code_* prev*_cod lab isco08_2digits isco88_2digits isco08 isco88 isic4_2digits isic4 isic3_2digits isic3 ///
		set_rate* sales_earn_prim in_kind* earn_sales_self earnings_self sales_earn_sec earn_sales_self_sec earnings_self_sec soc_sec_cov registration size_inf 
	
		compress 
		
		order ilo_key ilo_wgt ilo_time ilo_geo ilo_sex	ilo_age* ilo_edu_* ilo_dsb*  ilo_wap ilo_lfs ilo_mjh ilo_job*_ste* ilo_job*_eco* ilo_job*_ocu* /* ilo_job*_ins_sector */ ///
		ilo_job*_job_time ilo_job*_job_contract ilo_job*_ife*	ilo_job*_how* ilo_job*_lri_*  ilo_joball_tru ilo_joball_oi*	ilo_cat_une	ilo_dur_*	ilo_prev* ///
		/* ilo_gsp_uneschemes */ ilo_olf_* ilo_dis ilo_neet, last
		
	* Save dataset including original and ilo variables
	
		saveold ${country}_${source}_${time}_FULL, version(12) replace		
	
	*Save file only containing ilo_* variables
	
		keep ilo*

		saveold ${country}_${source}_${time}_ILO, version(12) replace


