* TITLE OF DO FILE: ILO Microdata Preprocessing code template - PAN LFS 2014
* DATASET USED: PAN LFS 2014
* NOTES:
* Author: Roger Gomis
* Who last updated the file: Roger Gomis
* Starting Date: 20 April 2017
* Last updated: 
***********************************************************************************************


***********************************************************************************************
***********************************************************************************************

* 			1. SET UP WORK DIRECTORY, FILE NAME, VARIABLES AND FUNCTIONS

***********************************************************************************************
***********************************************************************************************

clear all 

set more off

global path "J:\COMMON\STATISTICS\DPAU\MICRO"
global country "PAN"
global source "EML"
global time "2014"
global inputFile "PAN_LFS_2014_August.dta"

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
				
				foreach var of newlist isco08_2digits isco88_2digits isco08 isco88 isic4_2digits isic4 ///
							isic3_2digits isic3 {
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
		rename *, upper
		
capture rename PESO FAC15_E
capture rename P46_CODIGO P46
capture rename P45_CODIGO P45
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

	gen ilo_wgt=FAC15_E
		lab var ilo_wgt "Sample weight"		


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time period ('ilo_time')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	* Year 2014
	gen ilo_time=1
		lab def lab_time 1 $time
		lab val ilo_time lab_time
		lab var ilo_time "Time (Gregorian Calendar)"
		
		
   decode ilo_time, gen(to_drop)
   split to_drop, generate(to_drop_) parse(Q)
   destring to_drop_1, replace force
   local Y = to_drop_1 in 1

* ---------------------------------------------------------------------------------------------
***********************************************************************************************
***** Additional modifications, time dependant 2015

if `Y'==2015 {
*** in 2015 they added 0 as missing field
foreach var of varlist _all {
capture replace `var'=. if `var'==0
}
capture destring P2, replace
capture destring P28RECO, replace
capture destring P30RECO, replace
capture destring P45RECO, replace
capture destring P46RECO, replace


gen P24=1 if P24A==1&P24B==1&P24C==1
replace P24=2 if (P24A==2|P24B==2|P24C==2)

rename P42A_1 P421
rename P42A_2 P422

rename P42B_3 P423
rename P42B_4 P424
}


***********************************************************************************************
* ---------------------------------------------------------------------------------------------

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
	
if `Y'==2010 {
		replace ilo_geo=1 if AREARECO=="1"
		replace ilo_geo=2 if AREARECO=="2"
}
	
if `Y'<2013 & `Y'!=2010  {
		replace ilo_geo=1 if AREARECO==1
		replace ilo_geo=2 if AREARECO==2
}	
if `Y'==2014|`Y'==2015 {
		replace ilo_geo=1 if AREARECO=="Urbana"
		replace ilo_geo=2 if AREARECO=="Rural"
}
if `Y'==2013 {
		replace ilo_geo=1 if AREARECO=="U"
		replace ilo_geo=2 if AREARECO=="R"
}

			lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural"
			lab val ilo_geo ilo_geo_lab
			lab var ilo_geo "Geographical coverage"	

			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_sex=P2
		lab def ilo_sex_lab 1 "1 - Male" 2 "2 - Female"
		lab var ilo_sex "Sex"
		lab val ilo_sex ilo_sex_lab


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_age=P3
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



* IMPORTANT: Data is not labeled, it appears to follow a code with the 1st digit indicating level and the second indicating the grade
* I am unable to map to any ISCED, I map to aggregate
* (nonetheless I use ISCED 97 to guide me in this)
if `Y'==2010 {
	recode P8 (60 70 11/15=1) (16 21/25=2) (26/44=3) (45/49 =4) (. 51/53=5) , gen(ilo_edu_aggregate)
}
else {
	recode P8 (1/15 21 22=1) (16 23 31/35=2) (36 41/46 51/54=3) (55/84 =4) (.=5) , gen(ilo_edu_aggregate)
}
	
			label def edu_aggr_lab 1 "1 - Less than basic" 2 "2 - Basic" 3 "3 - Intermediate" 4 "4 - Advanced" 5 "5 - Level not stated"
			label val ilo_edu_aggregate edu_aggr_lab
			label var ilo_edu_aggregate "Education (Aggregate levels)"



* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education attendance ('ilo_edu_attendance')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------


	gen ilo_edu_attendance=.
		replace ilo_edu_attendance=1 if P7==1				// Attending
		replace ilo_edu_attendance=2 if P7==2				// Not attending
			label def edu_att_lab 1 "1 - Attending" 2 "2 - Not attending"
			label val ilo_edu_attendance edu_att_lab
			label var ilo_edu_attendance "Education (Attendance)"

			

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Disability status ('ilo_dsb')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

* No Data

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

* Employed
** note temporary absence does not include info on duration, all temporary absentees are considered to be employed, 
** also any activity that took an hour and the respondend recieved money for
** also family work is asked again
** What it is not considered work is someone who says that works at regular intervals (and now is on a non-work interval)

* Unemployed
** not employed
*AND
** seeking past week  OR found job already
*AND
** available for work (the data provided bunches together availability past week/today/next 2 weeks)
	gen ilo_lfs=.
		replace ilo_lfs=1 if  inlist(P10_18,1,2,3,5) & ilo_wap==1 	// Employed
		replace ilo_lfs=2 if  inlist(P10_18,6,8) & P24==1 &ilo_wap==1 & ilo_lfs!=1  	// Unemployed 
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
		replace ilo_mjh=1 if P44==3 & ilo_lfs==1
		replace ilo_mjh=2 if P44<3 & ilo_lfs==1
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
	* note: contributing family workers includes unpaid aprentices
		gen ilo_job1_ste_icse93=.
			replace ilo_job1_ste_icse93=1 if P33<7 & ilo_lfs==1		// Employees
			replace ilo_job1_ste_icse93=2 if P33==8 & ilo_lfs==1		// Employers
			replace ilo_job1_ste_icse93=3 if P33==7 & ilo_lfs==1		// Own-account workers
			replace ilo_job1_ste_icse93=4 if P33==9 & ilo_lfs==1		// Members of cooperatives
			replace ilo_job1_ste_icse93=5 if P33==10 & ilo_lfs==1		// Contributing family workers
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
/* IT FOLLOWS ISIC 4, */

	append using `labels'

if `Y'==2010 {
	* NOTICE 2010 DOES NOT FOLLOW ANY INTERNATIONAL STANDARD
	* for instance categories 50 51 52 are completely switched with the ISIC 3.1 51 52 53
	* 55 does not correspond either, etc.
	
	
}

else {		

if `Y'==2015 {
	gen ilo_job1_eco_isic4 = P30RECO if ilo_lfs==1
				replace ilo_job1_eco_isic4=22 if ilo_job1_eco_isic4==. & ilo_lfs==1 
				lab val ilo_job1_eco_isic4  isic4
				lab var ilo_job1_eco_isic4 "Economic activity (ISIC Rev. 4)"
				
		
	gen ilo_job2_eco_isic4 = P46RECO if ilo_lfs==1 & ilo_mjh==2
				replace ilo_job2_eco_isic4=22 if ilo_job2_eco_isic4==. & ilo_lfs==1 & ilo_mjh==2
				lab val ilo_job2_eco_isic4  isic4
				lab var ilo_job2_eco_isic4 "Economic activity (ISIC Rev. 4) in secondary job"
	* Classification aggregated level
	
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
				lab val ilo_job2_eco_aggregate eco_aggr_lab
				lab var ilo_job2_eco_aggregate "Economic activity (Aggregate) in secondary job"
} 
if `Y'!=2015 { 
		* Primary activity
		
		gen ilo_job1_eco_isic4_2digits=substr(P30,1,2) if (ilo_lfs==1)
			destring ilo_job1_eco_isic4_2digits, replace force
			lab values ilo_job1_eco_isic4  isic4_2digits
			lab var ilo_job1_eco_isic4_2digits "Economic activity (ISIC Rev. 4), 2 digit level"
			

		
	* One digit level

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
			
						*some codes do not make sense
			replace ilo_job1_eco_isic4_2digits=. if ilo_job1_eco_isic4==.
			
			replace ilo_job1_eco_isic4=22 if ilo_job1_eco_isic4==. & ilo_lfs==1 
				lab val ilo_job1_eco_isic4  isic4
				lab var ilo_job1_eco_isic4 "Economic activity (ISIC Rev. 4)"
				
				


	* Classification aggregated level
	
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
		
		
		gen ilo_job2_eco_isic4_2digits=substr(P46,1,2) if (ilo_lfs==1)& ilo_mjh==2
		destring ilo_job2_eco_isic4_2digits, replace force
			lab values ilo_job2_eco_isic4  isic4_2digits
			lab var ilo_job2_eco_isic4_2digits "Economic activity (ISIC Rev. 4), 2 digit level in secondary job"
		* Secondary activity
			replace ilo_job2_eco_isic4_2digits=. if ilo_job2_eco_isic4_2digits==34|ilo_job2_eco_isic4_2digits==40|ilo_job2_eco_isic4_2digits==48|ilo_job2_eco_isic4_2digits==67
		
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
			
					*some codes do not make sense
			replace ilo_job2_eco_isic4_2digits=. if ilo_job2_eco_isic4_2digits==.
			
			replace ilo_job2_eco_isic4=22 if ilo_job2_eco_isic4==. & ilo_lfs==1 & ilo_mjh==2
				lab val ilo_job2_eco_isic4  isic4
				lab var ilo_job2_eco_isic4 "Economic activity (ISIC Rev. 4) in secondary job"
				

		* Secondary activity
		
		gen ilo_job2_eco_aggregate=.
			replace ilo_job2_eco_aggregate=1 if ilo_job2_eco_isic4==1
			replace ilo_job2_eco_aggregate=2 if ilo_job2_eco_isic4==3
			replace ilo_job2_eco_aggregate=3 if ilo_job2_eco_isic4==6
			replace ilo_job2_eco_aggregate=4 if inlist(ilo_job2_eco_isic4,2,4,5)
			replace ilo_job2_eco_aggregate=5 if inrange(ilo_job2_eco_isic4,7,14)
			replace ilo_job2_eco_aggregate=6 if inrange(ilo_job2_eco_isic4,15,21)
			replace ilo_job2_eco_aggregate=7 if ilo_job2_eco_isic4==22
		
				lab val ilo_job2_eco_aggregate eco_aggr_lab
				lab var ilo_job2_eco_aggregate "Economic activity (Aggregate) in secondary job"
}		
}
**** Removing two digit measures - (Ensure consistency - non missing values) -silenced
*drop ilo_job1_eco_isic4_2digits ilo_job2_eco_isic4_2digits



* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_ocu') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
		/* Classification used: ISCO 08  */

if `Y'==2010 {
	* NOTICE ,even if in the description for 2010 it is said that ISCO 88 is the base for 2010 data, this is incorrect
	*an unknown classification ranging from 0001 until 1649 is used, therefore nothing is computed
}

else {		

if `Y'==2015 {

	gen ilo_job1_ocu_isco08 = P28RECO if ilo_lfs==1
		replace ilo_job1_ocu_isco08=11 if (ilo_job1_ocu_isco08==. & ilo_lfs==1 )
		
	gen ilo_job2_ocu_isco08 = P45RECO  if ilo_lfs==1& ilo_mjh==2
		replace ilo_job2_ocu_isco08=11 if (ilo_job2_ocu_isco08==. & ilo_lfs==1& ilo_mjh==2)
		
		**************** Labels
							lab def isco08_1dig_lab 1 "1 - Managers" 2 "2 - Professionals" 3 "3 - Technicians and associate professionals" 4 "4 - Clerical support workers" 5 "5 - Service and sales workers" ///
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
		
		
		**** labels and aggregates for secondary JOB
						lab val ilo_job2_ocu_isco08 isco08_1dig_lab
					lab var ilo_job2_ocu_isco08 "Occupation (ISCO-08)"		

		* Aggregate:			
			gen ilo_job2_ocu_aggregate=.
				replace ilo_job2_ocu_aggregate=1 if inrange(ilo_job2_ocu_isco08,1,3)
				replace ilo_job2_ocu_aggregate=2 if inlist(ilo_job2_ocu_isco08,4,5)
				replace ilo_job2_ocu_aggregate=3 if inlist(ilo_job2_ocu_isco08,6,7)
				replace ilo_job2_ocu_aggregate=4 if ilo_job2_ocu_isco08==8
				replace ilo_job2_ocu_aggregate=5 if ilo_job2_ocu_isco08==9
				replace ilo_job2_ocu_aggregate=6 if ilo_job2_ocu_isco08==10
				replace ilo_job2_ocu_aggregate=7 if ilo_job2_ocu_isco08==11
					
					lab val ilo_job2_ocu_aggregate ocu_aggr_lab
					lab var ilo_job2_ocu_aggregate "Occupation (Aggregate) - Main job"	
					
					
		* Skill level
		recode ilo_job2_ocu_isco08 (1/3=3) (4/8=2) (9=1) (10/11=4) ,gen(ilo_job2_ocu_skill)

		lab val ilo_job2_ocu_skill ilo_job2_ocu_skill
		lab var ilo_job2_ocu_skill "Occupation (Skill level)"
		
		
}

if `Y'!=2015 {
		
	* MAIN JOB:	
	
		* ISCO 08 - 2 digit
			gen ilo_job1_ocu_isco08_2digits=substr(P28,1,2) if (ilo_lfs==1)
			destring ilo_job1_ocu_isco08_2digits, replace force
				lab values ilo_job1_ocu_isco08_2digits isco08_2digits
				lab var ilo_job1_ocu_isco08_2digits "Occupation (ISCO-08), 2 digit level"
		
		* ISCO 08 - 1 digit
			gen ilo_job1_ocu_isco08=.
				replace ilo_job1_ocu_isco08=1 if inrange(ilo_job1_ocu_isco08_2digits,11,14)
				replace ilo_job1_ocu_isco08=2 if inrange(ilo_job1_ocu_isco08_2digits,21,26)
				replace ilo_job1_ocu_isco08=3 if inrange(ilo_job1_ocu_isco08_2digits,31,35)
				replace ilo_job1_ocu_isco08=4 if inrange(ilo_job1_ocu_isco08_2digits,41,44)
				replace ilo_job1_ocu_isco08=5 if inrange(ilo_job1_ocu_isco08_2digits,51,54)
				replace ilo_job1_ocu_isco08=6 if inrange(ilo_job1_ocu_isco08_2digits,61,63)
				replace ilo_job1_ocu_isco08=7 if inrange(ilo_job1_ocu_isco08_2digits,71,75)
				replace ilo_job1_ocu_isco08=8 if inrange(ilo_job1_ocu_isco08_2digits,81,83)
				replace ilo_job1_ocu_isco08=9 if inrange(ilo_job1_ocu_isco08_2digits,91,96)
				replace ilo_job1_ocu_isco08=10 if inrange(ilo_job1_ocu_isco08_2digits,1,3)
				
				*some codes don't make sense
				replace ilo_job1_ocu_isco08_2digits=. if  ilo_job1_ocu_isco08==.
				
				replace ilo_job1_ocu_isco08=11 if (ilo_job1_ocu_isco08==. & ilo_lfs==1)

					lab def isco08_1dig_lab 1 "1 - Managers" 2 "2 - Professionals" 3 "3 - Technicians and associate professionals" 4 "4 - Clerical support workers" 5 "5 - Service and sales workers" ///
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
		

	* SECOND JOB:
	
				gen ilo_job2_ocu_isco08_2digits=substr(P45,1,2) if (ilo_lfs==1)& ilo_mjh==2
				destring ilo_job2_ocu_isco08_2digits, replace force
					lab values ilo_job2_ocu_isco08_2digits isco08_2digits
					lab var ilo_job2_ocu_isco08_2digits "Occupation (ISCO-08), 2 digit level"
		
		* ISCO 08 - 1 digit
			gen ilo_job2_ocu_isco08=.
				replace ilo_job2_ocu_isco08=1 if inrange(ilo_job2_ocu_isco08_2digits,11,14)
				replace ilo_job2_ocu_isco08=2 if inrange(ilo_job2_ocu_isco08_2digits,21,26)
				replace ilo_job2_ocu_isco08=3 if inrange(ilo_job2_ocu_isco08_2digits,31,35)
				replace ilo_job2_ocu_isco08=4 if inrange(ilo_job2_ocu_isco08_2digits,41,44)
				replace ilo_job2_ocu_isco08=5 if inrange(ilo_job2_ocu_isco08_2digits,51,54)
				replace ilo_job2_ocu_isco08=6 if inrange(ilo_job2_ocu_isco08_2digits,61,63)
				replace ilo_job2_ocu_isco08=7 if inrange(ilo_job2_ocu_isco08_2digits,71,75)
				replace ilo_job2_ocu_isco08=8 if inrange(ilo_job2_ocu_isco08_2digits,81,83)
				replace ilo_job2_ocu_isco08=9 if inrange(ilo_job2_ocu_isco08_2digits,91,96)
				replace ilo_job2_ocu_isco08=10 if inrange(ilo_job2_ocu_isco08_2digits,1,3)
				
				*some codes don't make sense
				replace ilo_job2_ocu_isco08_2digits=. if  ilo_job2_ocu_isco08==.
				
				replace ilo_job2_ocu_isco08=11 if (ilo_job2_ocu_isco08==. & ilo_lfs==1& ilo_mjh==2)

					lab val ilo_job2_ocu_isco08 isco08_1dig_lab
					lab var ilo_job2_ocu_isco08 "Occupation (ISCO-08)"		

		* Aggregate:			
			gen ilo_job2_ocu_aggregate=.
				replace ilo_job2_ocu_aggregate=1 if inrange(ilo_job2_ocu_isco08,1,3)
				replace ilo_job2_ocu_aggregate=2 if inlist(ilo_job2_ocu_isco08,4,5)
				replace ilo_job2_ocu_aggregate=3 if inlist(ilo_job2_ocu_isco08,6,7)
				replace ilo_job2_ocu_aggregate=4 if ilo_job2_ocu_isco08==8
				replace ilo_job2_ocu_aggregate=5 if ilo_job2_ocu_isco08==9
				replace ilo_job2_ocu_aggregate=6 if ilo_job2_ocu_isco08==10
				replace ilo_job2_ocu_aggregate=7 if ilo_job2_ocu_isco08==11
					
					lab val ilo_job2_ocu_aggregate ocu_aggr_lab
					lab var ilo_job2_ocu_aggregate "Occupation (Aggregate) - Main job"	
					
					
		* Skill level
		recode ilo_job2_ocu_isco08 (1/3=3) (4/8=2) (9=1) (10/11=4) ,gen(ilo_job2_ocu_skill)

		lab val ilo_job2_ocu_skill ilo_job2_ocu_skill
		lab var ilo_job2_ocu_skill "Occupation (Skill level)"
		
}
**** Removing two digit measures - (Ensure consistency - non missing values) - silenced
*drop ilo_job1_ocu_isco08_2digits
}

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_job1_ins_sector')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
	
	
	* NGO and cooperative are set to private
		gen ilo_job1_ins_sector=.
			replace ilo_job1_ins_sector=1 if inlist(P33,1,5) & ilo_lfs==1	// Public
			replace ilo_job1_ins_sector=2 if inlist(P33,2,3,4,6,7,8,9,10) & ilo_lfs==1	// Private
				lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private" 
				lab values ilo_job1_ins_sector ins_sector_lab
				lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities"



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
		
	/* Useful questions:
	

	*/
	
	*** Generating the nodes, From left to right 1 directs to first direction in the diagram (usually formal), 0 to the second (usually informal), and -1 if aplicable to the third one. Only unique paths)

	
	*** Preparing necessary variables - the variables must be adjusted to fit the data
	
	recode P35 ( 3=1) (1 2 4 =0) (-9999=-1), gen(todrop_institutional) 		// theoretical 3 value node/ +1 Gov, Corporation, NGO, Embassy, IO / 0 Farm or private business, other, not asked, don't know, NA / -1 private household
	replace todrop_institutional=1 if P33<3|P33==6							// Gov NGO sector identified in the status in employment question
	replace todrop_institutional=1 if P38==1								// Corporation sector for self employed is identified separately, only for partnerships, 
	replace todrop_institutional=0 if P37==2 								//individual societies go to farm/private business
	replace todrop_institutional=-1 if P33==5								// Household sector identified in the status in employment question
	replace todrop_institutional=0 if todrop_institutional==. 				// if the absence of the created variable is due to complete absence informality should not be computed
	capture replace todrop_institutional=-1 if ilo_job1_eco_isic4_2digits==97 // ilo_job1_ocu_isco08_2digits==63| not used due to excessive result AND comparability with 2010!!
	
	
	gen todrop_destinationprod=1 													// theoretical 2 value node / +1 At least partially market or Other, Not asked, Don't Know, NA/  0 Only for own final use (household) 
	
	gen todrop_bookkeeping=0 														// theoretical 2 value node/ +1 keeps accounts for GOV/ 0 does not keep accounts or personal use or other, not asked, DK, NA  
	
	gen todrop_registration=1 if P36==1										// theoretical 3 value node/ +1 registered national level/ 0 not registered national level, other, DK / 0 not asked NA
		replace todrop_registration=0 if P36==2|P36==3							// note that registration question is only asked to workers, not SE
		replace todrop_registration=-1 if todrop_registration==.
		
	gen todrop_SS=1 if P4==1 												// theoretical 3 value node/ +1 Social security/ 0 Other, Not asked; NA/ -1 No social security or don't know
		replace todrop_SS=-1 if P4==6
		replace todrop_SS=0 if todrop_SS==.
		
	gen todrop_place=1 	if inlist(P29,1,10)										// theoretical 2 value node/ +1 fixed visible premises / 0 non fixed premises (office factory, or supermarket)
		replace todrop_place=0 if todrop_place==.&P29!=.
		
	gen todrop_size=1 if inlist(P31,3,4,5)|(P31==2&P31A>5)									// theoretical 2 value node/ +1 equal or more than 6 workers / 0 less than 6 workers
		replace todrop_size=0 if P31A<6
		
	gen todrop_paidleave=.											// theoretical 2 value node/ +1 paid leave / 0 no paid leave, not asked , DK, NA
		replace todrop_paidleave=0 if todrop_paidleave==.
		
	gen todrop_paidsick=.									// theoretical 2 value node/ +1 sick leave / 0 no sick leave, not asked, DK, NA
		replace todrop_paidsick=0 if todrop_paidsick==.
		
	gen todrop_producesforsale=1 													//  theoretical 2 value node / +1 Yes product for sale, Other, Not asked, Don't Know, NA/ 0 No, not for sale 
	
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
* IMPORTANT, not actual hours only usual, this applies to all of the rest of the data
* ALSO: the computation let's 0 values through (as it is required by the bands) in practice there are very few observations like that, but this is not the case by construction

* Main job:

* 1) Weekly hours ACTUALLY worked - Main job
		
			gen ilo_job1_how_actual=P43 if (ilo_lfs==1)
					*to avoid missing values of workers that were temporary absent
					replace ilo_job1_how_actual=0 if ilo_lfs==1&ilo_job1_how_actual==.&P10_18==2
					lab var ilo_job1_how_actual "Weekly hours actually worked in main job"
		
		
* 2) Weekly hours USUALLY worked 
	*no data
* Second job: 

* 1) Weekly hours ACTUALLY worked:
			gen ilo_job2_how_actual=P43 if (ilo_lfs==1)
					*to avoid missing values of workers that were temporary absent
					replace ilo_job2_how_actual=0 if ilo_lfs==1&ilo_job2_how_actual==.&P10_18==2
					lab var ilo_job2_how_actual "Weekly hours actually worked in main job"
		

* 2) Weekly hours USUALLY worked
			*no data

* All jobs:
		
* 1) Weekly hours ACTUALLY worked:

			egen ilo_joball_how_actual=rowtotal(ilo_job1_how_actual ilo_job2_how_actual) if (ilo_lfs==1)  
			replace ilo_joball_how_actual=168 if ilo_joball_how_actual>168&ilo_joball_how_actual<999
					lab var ilo_joball_how_actual "Weekly hours actually worked in all jobs"

			gen ilo_joball_how_actual_bands=.
				replace ilo_joball_how_actual_bands=1 if ilo_joball_how_actual==0
				replace ilo_joball_how_actual_bands=2 if inrange(ilo_joball_how_actual,1,14)
				replace ilo_joball_how_actual_bands=3 if inrange(ilo_joball_how_actual,15,29)
				replace ilo_joball_how_actual_bands=4 if inrange(ilo_joball_how_actual,30,34)
				replace ilo_joball_how_actual_bands=5 if inrange(ilo_joball_how_actual,35,39)
				replace ilo_joball_how_actual_bands=6 if inrange(ilo_joball_how_actual,40,48)
				replace ilo_joball_how_actual_bands=7 if ilo_joball_how_actual>=49 & ilo_joball_how_actual!=.
					lab val ilo_joball_how_actual_bands how_bands_lab
					lab var ilo_joball_how_actual_bands "Weekly hours actually worked bands in all jobs"

* 2) Weekly hours USUALLY worked 
* no data
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job1_job_time') <- Moved here to be able to use the computed hours
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			

	/* Threshold of 40 hours per week	*/

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

			* All jobs
				
				* Employees
					gen ilo_job1_lri_ees=.
						replace ilo_job1_lri_ees=P421+P422 if (ilo_job1_ste_aggregate==1)&P421!=99999&P422!=99999
						replace ilo_job1_lri_ees=P422 if ilo_job1_lri_ees==.&ilo_job1_ste_aggregate==1&P422!=99999
						replace ilo_job1_lri_ees=P421 if ilo_job1_lri_ees==.&ilo_job1_ste_aggregate==1&P421!=99999
						replace ilo_job1_lri_ees=. if ilo_job1_lri_ees==0
							lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"	
	
				* Self-employed
					gen ilo_job1_lri_slf=.
						replace ilo_job1_lri_slf=P423+P424 if  inlist(ilo_job1_ste_icse93,2,3,4,6)&P423!=99999&P424!=99999
						replace ilo_job1_lri_slf=P424 if  inlist(ilo_job1_ste_icse93,2,3,4,6)&ilo_job1_lri_slf==.&P424!=99999
						replace ilo_job1_lri_slf=P423 if  inlist(ilo_job1_ste_icse93,2,3,4,6)&ilo_job1_lri_slf==.&P423!=99999
						replace ilo_job1_lri_slf=. if ilo_job1_lri_slf==.
						lab var ilo_job1_lri_slf "Monthly earnings of self-employed in main job"


		
***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_joball_tru')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

		gen ilo_joball_tru=.
		*note definition, the availability to work is defined as having 1 hour or more available for the week
			replace ilo_joball_tru=1 if ilo_joball_how_actual<35 & P50==1 &P51>0&P51!=. & ilo_lfs==1 // less than threshold, willing and available
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
		replace ilo_cat_une=1 if (P26<999&ilo_lfs==2)
		replace ilo_cat_une=2 if (P26==999&ilo_lfs==2)
		replace ilo_cat_une=3 if (ilo_cat_une==.&ilo_lfs==2)
				lab def ilo_cat_une 1 "Unemployed previously employed" 2 "Unemployed seeking first job" 3 "Unknown"
				lab val ilo_cat_une ilo_cat_une
				lab var ilo_cat_une "Category of unemployment"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen todrop=(P21-200)
	gen todropB = (P26-100) if P26<999
	* notice the negative value works just as well, beacuse it is filtered as less than
	
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
*			Previous economic activity ('ilo_preveco_isic4')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

	* Classification aggregated level
	
	
	
		* Primary activity

					
	if `Y'==2010 {


		* NOTICE 2010 DOES NOT FOLLOW ANY INTERNATIONAL STANDARD
	* for instance categories 50 51 52 are completely switched with the ISIC 3.1 51 52 53
	* 55 does not correspond either, etc.
	
}

else {		
if `Y'==2015 { 
	gen ilo_preveco_isic4 = P30RECO if (ilo_lfs==2&ilo_cat_une==1)
	replace ilo_preveco_isic4=22 if  ilo_preveco_isic4==. & ilo_lfs==2&ilo_cat_une==1
	lab val ilo_preveco_isic4 isic4
				lab var ilo_preveco_isic4 "Previous economic activity (ISIC Rev. 4)"
}

if `Y'!=2015 { 

gen todrop=substr(P30,1,2)  if (ilo_lfs==2&ilo_cat_une==1)
destring todrop, replace force
	* One digit level - for reference
		gen ilo_preveco_isic4=.
			replace ilo_preveco_isic4=1 if inrange( todrop,1,3)
			replace ilo_preveco_isic4=2 if inrange( todrop,5,9)
			replace ilo_preveco_isic4=3 if inrange( todrop,10,33)
			replace ilo_preveco_isic4=4 if  todrop==35
			replace ilo_preveco_isic4=5 if inrange( todrop,36,39)
			replace ilo_preveco_isic4=6 if inrange( todrop,41,43)
			replace ilo_preveco_isic4=7 if inrange( todrop,45,47)
			replace ilo_preveco_isic4=8 if inrange( todrop,49,53)
			replace ilo_preveco_isic4=9 if inrange( todrop,55,56)
			replace ilo_preveco_isic4=10 if inrange( todrop,58,63)
			replace ilo_preveco_isic4=11 if inrange( todrop,64,66)
			replace ilo_preveco_isic4=12 if  todrop==68
			replace ilo_preveco_isic4=13 if inrange( todrop,69,75)
			replace ilo_preveco_isic4=14 if inrange( todrop,77,82)
			replace ilo_preveco_isic4=15 if  todrop==84
			replace ilo_preveco_isic4=16 if  todrop==85
			replace ilo_preveco_isic4=17 if inrange( todrop,86,88)
			replace ilo_preveco_isic4=18 if inrange( todrop,90,93)
			replace ilo_preveco_isic4=19 if inrange( todrop,94,96)
			replace ilo_preveco_isic4=20 if inrange( todrop,97,98)
			replace ilo_preveco_isic4=21 if  todrop==99
			replace ilo_preveco_isic4=22 if  todrop==. & ilo_lfs==2&ilo_cat_une==1
				lab val ilo_preveco_isic4 isic4
				lab var ilo_preveco_isic4 "Previous economic activity (ISIC Rev. 4)"

	* Classification aggregated level
	
		* Primary activity
		gen ilo_preveco_aggregate=.
			replace ilo_preveco_aggregate=1 if ilo_preveco_isic4==1
			replace ilo_preveco_aggregate=2 if ilo_preveco_isic4==3
			replace ilo_preveco_aggregate=3 if ilo_preveco_isic4==6
			replace ilo_preveco_aggregate=4 if inlist(ilo_preveco_isic4,2,4,5)
			replace ilo_preveco_aggregate=5 if inrange(ilo_preveco_isic4,7,14)
			replace ilo_preveco_aggregate=6 if inrange(ilo_preveco_isic4,15,21)
			replace ilo_preveco_aggregate=7 if ilo_preveco_isic4==22		
			lab def ilo_preveco_aggregate 1 "1 - Agriculture" 2 "2 - Manufacturing" 3 "3 - Construction" 4 "4 - Mining and quarrying; Electricity, gas and water supply" ///
					5 "5 - Market Services (Trade; Transportation; Accommodation and food; and Business and administrative services)"  ///
					6 "6 - Non-market services (Public administration; Community, social and other services and activities)" 7 "7 - Not classifiable by economic activity"					
			lab val ilo_preveco_aggregate ilo_preveco_aggregate
			lab var ilo_preveco_aggregate "Previous economic activity (Aggregate)"
		drop todrop*
}
}



* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu_isco08')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

	/* Classification used: ISCO 08  */

if `Y'==2010 {
	* NOTICE ,even if in the description for 2010 it is said that ISCO 88 is the base for 2010 data, this is incorrect
	*an unknown classification ranging from 0001 until 1649 is used, therefore nothing is computed
}

else {		
* MAIN JOB:	
if `Y'==2015 { 
gen ilo_prevocu_isco08=P28RECO if ( ilo_lfs==2&ilo_cat_une==1)
	replace ilo_prevocu_isco08=11 if (ilo_prevocu_isco08==. & ilo_lfs==2&ilo_cat_une==1)
					lab def ilo_prevocu_isco08 1 "1 - Managers" 2 "2 - Professionals" 3 "Technicians and associate professionals" 4 "4 - Clerical support workers" 5 "5 - Service and sales workers" ///
					6 "6 - Skilled agricultural, forestry and fishery workers" 7 "7 - Craft and related trades workers" 8 "8 - Plant and machine operators, and assemblers" ///
					9 "9 - Elementary occupations" 10 "0 - Armed forces occupations" 11 "X - Not elsewhere classified"
				lab val ilo_prevocu_isco08 ilo_prevocu_isco08
				lab var ilo_prevocu_isco08 "Previous occupation (ISCO-08)"	
				
						* Aggregate:

			gen ilo_prevocu_aggregate=.
				replace ilo_prevocu_aggregate=1 if inrange(ilo_prevocu_isco08,1,3)
				replace ilo_prevocu_aggregate=2 if inlist(ilo_prevocu_isco08,4,5)
				replace ilo_prevocu_aggregate=3 if inlist(ilo_prevocu_isco08,6,7)
				replace ilo_prevocu_aggregate=4 if ilo_prevocu_isco08==8
				replace ilo_prevocu_aggregate=5 if ilo_prevocu_isco08==9
				replace ilo_prevocu_aggregate=6 if ilo_prevocu_isco08==10
				replace ilo_prevocu_aggregate=7 if ilo_prevocu_isco08==11
					lab def ilo_prevocu_aggregate 1 "1 - Managers, professionals, and technicians" 2 "2 - Clerical, service and sales workers" 3 "3 - Skilled agricultural and trades workers" ///
										4 "4 - Plant and machine operators, and assemblers" 5 "5 - Elementary occupations" 6 "6 - Armed forces" 7 "7 - Not elsewhere classified"
					lab val ilo_prevocu_aggregate ilo_prevocu_aggregate
					lab var ilo_prevocu_aggregate "Previous occupation (Aggregate)"	
				
	
				
				
		* Skill level
		recode ilo_prevocu_isco08 (1/3=3) (4/8=2) (9=1) (10/11=4) ,gen(ilo_prevocu_skill)
		lab def ilo_prevocu_skill 1 "1 - Skill level 1 (low)" 2 "2 - Skill level 2 (medium)" 3 "3 - Skill levels 3 and 4 (high)" 4 "4 - Not elsewhere classified"
		lab val ilo_prevocu_skill ilo_prevocu_skill
		lab var ilo_prevocu_skill "Previous occupation occupation (Skill level)"

}

if `Y'!=2015 { 



	
	
		* ISCO 08 - 2 digit
			gen todrop=substr(P28,1,2) if ilo_lfs==2&ilo_cat_une==1
			destring todrop, replace force


		* ISCO 08 - 1 digit

			gen ilo_prevocu_isco08=.
				replace ilo_prevocu_isco08=1 if inrange(todrop,10,19)
				replace ilo_prevocu_isco08=2 if inrange(todrop,20,29)
				replace ilo_prevocu_isco08=3 if inrange(todrop,30,39)
				replace ilo_prevocu_isco08=4 if inrange(todrop,40,49)
				replace ilo_prevocu_isco08=5 if inrange(todrop,50,59)
				replace ilo_prevocu_isco08=6 if inrange(todrop,60,69)
				replace ilo_prevocu_isco08=7 if inrange(todrop,70,79)
				replace ilo_prevocu_isco08=8 if inrange(todrop,80,89)
				replace ilo_prevocu_isco08=9 if inrange(todrop,90,99)
				replace ilo_prevocu_isco08=10 if inrange(todrop,1,9)
				replace ilo_prevocu_isco08=11 if (ilo_prevocu_isco08==. & ilo_lfs==2&ilo_cat_une==1)
				lab def ilo_prevocu_isco08 1 "1 - Managers" 2 "2 - Professionals" 3 "Technicians and associate professionals" 4 "4 - Clerical support workers" 5 "5 - Service and sales workers" ///
					6 "6 - Skilled agricultural, forestry and fishery workers" 7 "7 - Craft and related trades workers" 8 "8 - Plant and machine operators, and assemblers" ///
					9 "9 - Elementary occupations" 10 "0 - Armed forces occupations" 11 "X - Not elsewhere classified"
				lab val ilo_prevocu_isco08 ilo_prevocu_isco08
				lab var ilo_prevocu_isco08 "Previous occupation (ISCO-08)"		

		* Aggregate:

			gen ilo_prevocu_aggregate=.
				replace ilo_prevocu_aggregate=1 if inrange(ilo_prevocu_isco08,1,3)
				replace ilo_prevocu_aggregate=2 if inlist(ilo_prevocu_isco08,4,5)
				replace ilo_prevocu_aggregate=3 if inlist(ilo_prevocu_isco08,6,7)
				replace ilo_prevocu_aggregate=4 if ilo_prevocu_isco08==8
				replace ilo_prevocu_aggregate=5 if ilo_prevocu_isco08==9
				replace ilo_prevocu_aggregate=6 if ilo_prevocu_isco08==10
				replace ilo_prevocu_aggregate=7 if ilo_prevocu_isco08==11
					lab def ilo_prevocu_aggregate 1 "1 - Managers, professionals, and technicians" 2 "2 - Clerical, service and sales workers" 3 "3 - Skilled agricultural and trades workers" ///
										4 "4 - Plant and machine operators, and assemblers" 5 "5 - Elementary occupations" 6 "6 - Armed forces" 7 "7 - Not elsewhere classified"
					lab val ilo_prevocu_aggregate ilo_prevocu_aggregate
					lab var ilo_prevocu_aggregate "Previous occupation (Aggregate)"	
				
	
				
				
		* Skill level
		recode ilo_prevocu_isco08 (1/3=3) (4/8=2) (9=1) (10/11=4) ,gen(ilo_prevocu_skill)
		lab def ilo_prevocu_skill 1 "1 - Skill level 1 (low)" 2 "2 - Skill level 2 (medium)" 3 "3 - Skill levels 3 and 4 (high)" 4 "4 - Not elsewhere classified"
		lab val ilo_prevocu_skill ilo_prevocu_skill
		lab var ilo_prevocu_skill "Previous occupation occupation (Skill level)"
	
		drop todrop*	
}
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
	*note  (willing and available are in the same block)

	gen ilo_olf_dlma=.
		replace ilo_olf_dlma = 1 if (P10_18==6&P24==2)&ilo_lfs==3							 	//Seeking, not available
		replace ilo_olf_dlma = 2 if (P10_18!=6&P24==1)&ilo_lfs==3								//Not seeking, available
		*replace ilo_olf_dlma = 3  EMPTY because willing is not asked	//Not seeking, not available, willing
		*replace ilo_olf_dlma = 4 EMPTY because willing is not asked			//Not seeking, not available, not willing
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
		replace ilo_olf_reason=1 if	(inlist(P10_18,10) & ilo_lfs==3)					//Labour market
		replace ilo_olf_reason=2 if	(inlist(P10_18,8,9) & ilo_lfs==3)					//Labour market
		replace ilo_olf_reason=3 if	(inlist(P10_18,14,15)  & ilo_lfs==3)				//Personal/Family-related
		replace ilo_olf_reason=4 if (inlist(P10_18,11,12,13,16)  & ilo_lfs==3)							//Does not need/want to work
		replace ilo_olf_reason=5 if (inlist(P10_18,17)  & ilo_lfs==3)						//Not elsewhere classified
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