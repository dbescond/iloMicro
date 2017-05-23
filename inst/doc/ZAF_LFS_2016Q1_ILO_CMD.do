* TITLE OF DO FILE: ILO Microdata Preprocessing code template - ZAF, 2016Q1
* DATASET USED: ZAF LFS 2016Q1
* NOTES:
* Author: Roger Gomis
* Who last updated the file: Roger Gomis
* Starting Date: 10 February 2017
* Last updated: 20 February 2017
***********************************************************************************************


***********************************************************************************************
***********************************************************************************************

* 			1. SET UP WORK DIRECTORY, FILE NAME, VARIABLES AND FUNCTIONS

***********************************************************************************************
***********************************************************************************************

clear all 

set more off

global path "J:\COMMON\STATISTICS\DPAU\MICRO"
global country "ZAF"
global source "LFS"
global time "2016Q1"
global inputFile "qlfs-2016-01"

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
		
* to ensure that no observations are added
gen original=1

************ Matching some of the variables for some of the surveys - (THE NAME WILL REMAIN CHANGED IN THE FULL DATASET)
capture rename WEIGHT Weight
capture rename GEO_TYPE Geo_type
capture rename q13gender Q13GENDER
capture rename QTR Qtr

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

	gen ilo_wgt=Weight
		lab var ilo_wgt "Sample weight"		


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time period ('ilo_time')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	* Year 2010
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

decode ilo_time, gen(todrop)
split todrop, generate(todrop_) parse(Q)
destring todrop_1, replace force
local Y = todrop_1 in 1
	
	capture rename   Geo_Type Geo_type
	
	gen ilo_geo=.
	
if `Y'<2015 {
		replace ilo_geo=1 if Geo_type<3
		replace ilo_geo=2 if Geo_type>3&Geo_type!=.

} 
else {

		replace ilo_geo=1 if Geo_type==1
		replace ilo_geo=2 if Geo_type>1&Geo_type<5

}
		lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural"
		lab val ilo_geo ilo_geo_lab
		lab var ilo_geo "Geographical coverage"	

drop todrop*
local Y
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_sex=Q13GENDER
		lab def ilo_sex_lab 1 "1 - Male" 2 "2 - Female"
		lab var ilo_sex "Sex"
		lab val ilo_sex ilo_sex_lab


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_age=Q14AGE
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

/* ISCED 2011 mapping: based on the mapping developped by UNESCO 
					http://www.uis.unesco.org/Education/ISCEDMappings/Pages/default.aspx
					file:///J:\COMMON\STATISTICS\DPAU\MICRO\ZAF\LFS\2016Q1\ORI\ISCED_2011_Mapping_SouthAfrica_EN.xlsx	*/

* Note that according to the definition, the highest level CONCLUDED is considered.
* also note that doctorate and masters are bunched together, the solution assumed is  doctorate-> master



* Note 2008-2012 education is not computed due to several changes 
decode ilo_time, gen(todrop)
split todrop, generate(todrop_) parse(Q)
destring todrop_1, replace force
local Y = todrop_1 in 1
capture gen todrop_2=Qtr
local Q =todrop_2 in 1

if `Y'<2012|(`Y'==2012&`Q'<3 ) {
	gen ilo_edu_isced11=.
		replace ilo_edu_isced11=1 if Q17EDUCATION==0 												// No schooling
		replace ilo_edu_isced11=2 if inrange(Q17EDUCATION,1,7)  									// Early childhood education
		replace ilo_edu_isced11=3 if inrange(Q17EDUCATION,8,9)  									// Primary education
		replace ilo_edu_isced11=4 if inrange(Q17EDUCATION,10,12)|inrange(Q17EDUCATION,14,15)  		// Lower secondary education
		replace ilo_edu_isced11=5 if inrange(Q17EDUCATION,13,13)|inrange(Q17EDUCATION,16,16)       	// Upper secondary education
		replace ilo_edu_isced11=6 if inrange(Q17EDUCATION,17,17)|inrange(Q17EDUCATION,19,19)		// Post-secondary non-tertiary
		replace ilo_edu_isced11=7 if inrange(Q17EDUCATION,18,18)|inrange(Q17EDUCATION,20,20)		// Short-cycle tertiary education
		replace ilo_edu_isced11=8 if inrange(Q17EDUCATION,21,23)									// Bachelor or equivalent
		replace ilo_edu_isced11=9 if inrange(Q17EDUCATION,24,24)									// Master's or equivalent level
		replace ilo_edu_isced11=11 if ilo_edu_isced11==.											// Not elsewhere classified
} 
if `Y'>2012|(`Y'==2012&`Q'>2 ){

	gen ilo_edu_isced11=.
		replace ilo_edu_isced11=1 if Q17EDUCATION==98 												// No schooling
		replace ilo_edu_isced11=2 if inrange(Q17EDUCATION,0,6)  									// Early childhood education
		replace ilo_edu_isced11=3 if inrange(Q17EDUCATION,7,8)  									// Primary education
		replace ilo_edu_isced11=4 if inrange(Q17EDUCATION,9,11)|inrange(Q17EDUCATION,13,14)  		// Lower secondary education
		replace ilo_edu_isced11=5 if inrange(Q17EDUCATION,12,12)|inrange(Q17EDUCATION,15,17)       	// Upper secondary education
		replace ilo_edu_isced11=6 if inrange(Q17EDUCATION,18,19)|inrange(Q17EDUCATION,21,21)		// Post-secondary non-tertiary
		replace ilo_edu_isced11=7 if inrange(Q17EDUCATION,20,20)|inrange(Q17EDUCATION,22,22)		// Short-cycle tertiary education
		replace ilo_edu_isced11=8 if inrange(Q17EDUCATION,23,27)									// Bachelor or equivalent
		replace ilo_edu_isced11=9 if inrange(Q17EDUCATION,28,28)									// Master's or equivalent level
		replace ilo_edu_isced11=11 if ilo_edu_isced11==.											// Not elsewhere classified



}
		
			label def isced_11_lab 1 "X - No schooling" 2 "0 - Early childhood education" 3 "1 - Primary education" 4 "2 - Lower secondary education" ///
							5 "3 - Upper secondary education" 6 "4 - Post-secondary non-tertiary education" 7 "5 - Short-cycle tertiary education" ///
							8 "6 - Bachelor's or equivalent level" 9 "7 - Master's or equivalent level" 10 "8 - Doctoral or equivalent level" 11 "9 - Not elsewhere classified"
			label val ilo_edu_isced11 isced_11_lab
			lab var ilo_edu_isced11 "Education (ISCED 11)"

	gen ilo_edu_aggregate=.
		replace ilo_edu_aggregate=1 if inlist(ilo_edu_isced11,1,2)  	// Less than basic
		replace ilo_edu_aggregate=2 if inlist(ilo_edu_isced11,3,4)		// Basic
		replace ilo_edu_aggregate=3 if inlist(ilo_edu_isced11,5,6)		// Intermediate
		replace ilo_edu_aggregate=4 if inrange(ilo_edu_isced11,7,10)	// Advanced
		replace ilo_edu_aggregate=5 if ilo_edu_isced11==11				// Level not stated
			label def edu_aggr_lab 1 "1 - Less than basic" 2 "2 - Basic" 3 "3 - Intermediate" 4 "4 - Advanced" 5 "5 - Level not stated"
			label val ilo_edu_aggregate edu_aggr_lab
			label var ilo_edu_aggregate "Education (Aggregate levels)"

drop todrop*
local Y
local Q

		
	
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education attendance ('ilo_edu_attendance')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------


decode ilo_time, gen(todrop)
split todrop, generate(todrop_) parse(Q)
destring todrop_1, replace force
local Y = todrop_1 in 1
	

	
if `Y'<2013 {

} 
else {
	gen ilo_edu_attendance=.
		replace ilo_edu_attendance=1 if Q19ATTE==1				// Attending
		replace ilo_edu_attendance=2 if Q19ATTE==2				// Not attending
			label def edu_att_lab 1 "1 - Attending" 2 "2 - Not attending"
			label val ilo_edu_attendance edu_att_lab
			label var ilo_edu_attendance "Education (Attendance)"

}

drop todrop*
			
/*		NOT AVAILABLE AS A GENERAL POPULATION QUESTION	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Disability status ('ilo_dsb')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
				
	gen ilo_dsb_aggregate=.
		replace ilo_dsb_aggregate=1 if (b11==2 | b11==0)
		replace ilo_dsb_aggregate=2 if (b11==1)
			label def dsb_aggregate_lab 1 "Persons without disability" 2 "Persons with disability"
			label val ilo_dsb_aggregate dsb_aggregate_lab
			label var ilo_dsb_aggregate "Disability status (Aggregate)"
*/		


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

	gen ilo_lfs=.
		replace ilo_lfs=1 if ((Q24APDWRK==1 | Q24BOWNBUSNS==1 | Q24CUNPDWRK==1 ) & ilo_wap==1) 	// Employed
		replace ilo_lfs=1 if ((Q25APDWRK==1 | Q25BOWNBUSNS==1 | Q25CUNPDWRK==1 ) & (Q27RSNABSENT!=12 & Q27RSNABSENT!=13)& ilo_wap==1) // Employed (temporary absent- note by reason only seasonal and future job starters are discarded - since we do not have duration of absence)
		replace ilo_lfs=2 if (ilo_wap==1 & ilo_lfs!=1 & (Q31ALOOKWRK==1|Q31BSTARTBUSNS==1)&(Q39JOBOFFER==1|Q310STARTBUSNS==1)) | (ilo_wap==1 & ilo_lfs!=1 & Q33HAVEJOB==1)	// Unemployed
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
		replace ilo_mjh=1 if Q41MULTIPLEJOBS==2 & ilo_lfs==1
		replace ilo_mjh=2 if Q41MULTIPLEJOBS==1 & ilo_lfs==1
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
			replace ilo_job1_ste_icse93=1 if Q45WRK4WHOM==1 & ilo_lfs==1		// Employees
			replace ilo_job1_ste_icse93=2 if Q45WRK4WHOM==2 & ilo_lfs==1		// Employers
			replace ilo_job1_ste_icse93=3 if Q45WRK4WHOM==3 & ilo_lfs==1		// Own-account workers

			replace ilo_job1_ste_icse93=5 if Q45WRK4WHOM==4 & ilo_lfs==1		// Contributing family workers
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
/* IT DOES NOT FOLLOW ISIC 3.1 or 4, it is somewhat consistent with ISIC 3, a manual assignation is performed*/ 
	

	append using `labels'
/*
		* Use value label from this variable, afterwards drop everything related to this append
					
		* Primary activity
		
		gen ilo_job1_eco_isic4_2digits=trunc(Q43INDUSTRY/10) if (ilo_lfs==1)
			lab values ilo_job1_eco_isic4 isic4_2digits
			lab var ilo_job1_eco_isic4_2digits "Economic activity (ISIC Rev. 4), 2 digit level"
*/			

/*		
	* One digit level - for reference

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
				lab val ilo_job1_eco_isic4 isic4
				lab var ilo_job1_eco_isic4 "Economic activity (ISIC Rev. 4)"
*/				
		
	* One digit level
			* Primary activity
		gen todrop=trunc(Q43INDUSTRY/10) if (ilo_lfs==1)
		#delimit ;
		recode todrop 
11 = 1
12 = 1
13 = 2
21 = 3
22 = 3
23 = 3
24 = 3
25 = 3
29 = 18
30 = 4
31 = 4
32 = 4
33 = 4
34 = 4
35 = 4
36 = 4
37 = 4
38 = 4
39 = 4
41 = 5
42 = 5
50 = 6
61 = 7
62 = 7
63 = 7
64 = 8
71 = 9
72 = 9
73 = 9
74 = 9
75 = 9
81 = 10
82 = 10
83 = 10
84 = 11
85 = 11
86 = 11
87 = 11
88 = 11
91 = 12
92 = 13
93 = 14
94 = 15
95 = 15
96 = 15
99 = 15
1 = 16
2 = 17
3 = 18
9 = 18
0 .= 18
		, gen(ilo_job1_eco_isic3);
		#delimit cr
			lab def ilo_job1_eco_isic3 1 "A - Agriculture, hunting and forestry" 2 "B - Fishing" 3 "C - Mining and quarrying" 4 "D - Manufacturing" 5 "E - Electricity, gas and water supply" 6 "F - Construction" 7 "G - Wholesale and retail trade; repair of motor vehicles, motorcycles and personal and household goods" 8 "H - Hotels and restaurants" 9 "I - Transport, storage and communications" 10 "J - Financial intermediation" 11 "K - Real estate, renting and business activities" 12 "L - Public administration and defence; compulsory social security" 13 "M - Education" 14 "N - Health and social work" 15 "O - Other community, social and personal service activities" 16 "P - Activities of private households as employers and undifferentiated production activities of private households" 17 "Q - Extraterritorial organizations and bodies" 18 "X - Not elsewhere classified"				
			lab val ilo_job1_eco_isic3 ilo_job1_eco_isic3
			lab var ilo_job1_eco_isic3 "Economic activity (ISIC Rev. 3.1)"
		drop todrop


	
	
	
	
	* Classification aggregated level
	
		* Primary activity
		gen todrop=trunc(Q43INDUSTRY/10) if (ilo_lfs==1)
		#delimit ;
		recode todrop 
11 = 1
12 = 1
13 = 1
21 = 4
22 = 4
23 = 4
24 = 4
25 = 4
29 = 7
30 = 2
31 = 2
32 = 2
33 = 2
34 = 2
35 = 2
36 = 2
37 = 2
38 = 2
39 = 2
41 = 4
42 = 4
50 = 3
61 = 5
62 = 5
63 = 5
64 = 5
71 = 5
72 = 5
73 = 5
74 = 5
75 = 5
81 = 5
82 = 5
83 = 5
84 = 5
85 = 5
86 = 5
87 = 5
88 = 5
91 = 6
92 = 6
93 = 6
94 = 6
95 = 6
96 = 6
99 = 6
1 = 6
2 = 6
3 = 7
9 = 7
0 .=7
		, gen(ilo_job1_eco_aggregate);
		#delimit cr
			lab def eco_aggr_lab 1 "1 - Agriculture" 2 "2 - Manufacturing" 3 "3 - Construction" 4 "4 - Mining and quarrying; Electricity, gas and water supply" ///
					5 "5 - Market Services (Trade; Transportation; Accommodation and food; and Business and administrative services)"  ///
					6 "6 - Non-market services (Public administration; Community, social and other services and activities)" 7 "7 - Not classifiable by economic activity"					
			lab val ilo_job1_eco_aggregate eco_aggr_lab
			lab var ilo_job1_eco_aggregate "Economic activity (Aggregate)"
		drop todrop



* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_job1_ocu_isco88_2digits') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
	
	/* Classification used: ISCO 88  */

	* MAIN JOB:	
	
		* ISCO 88 - 2 digit
			gen todrop=Q42OCCUPATION
			*translate non mapped categories
			replace todrop=6210 if todrop==6211
			replace todrop=0110 if todrop==5164
			*remove unkown category 5409 and beggar 9888
			replace todrop=9999 if todrop==5409|todrop==9888
			replace todrop=trunc(todrop/100)
			gen ilo_job1_ocu_isco88_2digits=todrop if (ilo_lfs==1&Q42OCCUPATION!=9999)
			
				label values ilo_job1_ocu_isco88_2digits isco88_2digits
				lab var ilo_job1_ocu_isco88_2digits "Occupation (ISCO-88), 2 digit level"
			drop todrop
		
		* ISCO 88 - 1 digit
			gen ilo_job1_ocu_isco88=.
				replace ilo_job1_ocu_isco88=1 if inrange(ilo_job1_ocu_isco88_2digits,10,19)
				replace ilo_job1_ocu_isco88=2 if inrange(ilo_job1_ocu_isco88_2digits,20,29)
				replace ilo_job1_ocu_isco88=3 if inrange(ilo_job1_ocu_isco88_2digits,30,39)
				replace ilo_job1_ocu_isco88=4 if inrange(ilo_job1_ocu_isco88_2digits,40,49)
				replace ilo_job1_ocu_isco88=5 if inrange(ilo_job1_ocu_isco88_2digits,50,59)
				replace ilo_job1_ocu_isco88=6 if inrange(ilo_job1_ocu_isco88_2digits,60,69)
				replace ilo_job1_ocu_isco88=7 if inrange(ilo_job1_ocu_isco88_2digits,70,79)
				replace ilo_job1_ocu_isco88=8 if inrange(ilo_job1_ocu_isco88_2digits,80,89)
				replace ilo_job1_ocu_isco88=9 if inrange(ilo_job1_ocu_isco88_2digits,90,98)
				replace ilo_job1_ocu_isco88=10 if inrange(ilo_job1_ocu_isco88_2digits,1,1)
				replace ilo_job1_ocu_isco88=11 if (ilo_job1_ocu_isco88==. & ilo_lfs==1)
					lab def isco88_1dig_lab 1 "1 - Managers" 2 "2 - Professionals" 3 "3 - Technicians and associate professionals" 4 "4 - Clerical support workers" 5 "5 - Service and sales workers" ///
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
					lab var ilo_job1_ocu_aggregate "Occupation (Aggregate)"	

		* Skill level
		recode ilo_job1_ocu_isco88 (1/3=3) (4/8=2) (9=1) (10/11=4) ,gen(ilo_job1_ocu_skill)
		lab def ilo_job1_ocu_skill 1 "1 - Skill level 1 (low)" 2 "2 - Skill level 2 (medium)" 3 "3 - Skill levels 3 and 4 (high)" 4 "4 - Not elsewhere classified"
		lab val ilo_job1_ocu_skill ilo_job1_ocu_skill
		lab var ilo_job1_ocu_skill "Occupation (Skill level)"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_job1_ins_sector')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
	
	/* Other are classified under Private	*/ 
	* if the respondant does not know the variable is not defined
		gen ilo_job1_ins_sector=.
			replace ilo_job1_ins_sector=1 if (inlist(Q415TYPEBUSNS,1,2) & ilo_lfs==1)	// Public
			replace ilo_job1_ins_sector=2 if (inlist(Q415TYPEBUSNS,3,4,5) & ilo_lfs==1)	// Private
			*avoiding missing values, if there is no data the cases are considered as private (57 cases)
			replace ilo_job1_ins_sector=2 if ilo_lfs==1&ilo_job1_ins_sector==.
				lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private" 
				lab values ilo_job1_ins_sector ins_sector_lab
				lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities"

		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job1_job_contract')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
		
			gen ilo_job1_job_contract=.
				replace ilo_job1_job_contract=1 if (Q412CONTRDURATION==2&ilo_lfs==1)
				replace ilo_job1_job_contract=2 if (Q412CONTRDURATION==1 & ilo_lfs==1)
				replace ilo_job1_job_contract=3 if (ilo_job1_job_contract==. & ilo_job1_ste_aggregate==1)
					lab def job_contract_lab 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"
					lab val ilo_job1_job_contract job_contract_lab
					lab var ilo_job1_job_contract "Job (Type of contract)"

	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Formal / Informal Economy ('ilo_job1_ife_prod' 'ilo_job1_ife_nature') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
		
	/* Useful questions:
		For SE, OAW, CFW
		Q413VAT Registered for VAT
		Q414TAX Registered for Income Tax
	
		For all employed persons
		Q415TYPEBUSNS Institutional Sector
		Q416NRWORKERS Number of Employees in the work place
		
		For employees
		Q46PENSION social security proxy, contribution to pension fund
		Q47PDLEAVE entitled paid vacation leave
		Q47B1PDSICK paid sick leave
	*/
	
	*** Generating the nodes, From left to right 1 directs to first direction in the diagram (usually formal), 0 to the second (usually informal), and -1 if aplicable to the third one. Only unique paths)
	* NOTE! : destination of production, place of work, and bookeeping are not present in the survey, the nodes are set apropiately to follow definition
	* Note that the definition are meant to work with both informal sector and economy
	
	*** Preparing necessary variables - the variables must be adjusted to fit the data
	
	recode Q415TYPEBUSNS (1 2 4=1) (3 6 =0) (5=-1), gen(todrop_institutional) 		// theoretical 3 value node/ +1 Gov, Corporation, NGO, Embassy, IO / 0 Farm or private business, other, not asked, don't know, NA / -1 private household
	replace todrop_institutional=0 if todrop_institutional==. 						// if the absence of the created variable is due to complete absence informality should not be computed
	
	gen todrop_destinationprod=1 													// theoretical 2 value node / +1 At least partially market or Other, Not asked, Don't Know, NA/  0 Only for own final use (household) :::actual node empty(no necessary data available)
	
	gen todrop_bookkeeping=0 														// theoretical 2 value node/ +1 keeps accounts for GOV/ 0 does not keep accounts or personal use or other, not asked, DK, NA  :::actual node empty (no necessary data available)
	
	gen todrop_registration=1 if (Q413VAT==1|Q414TAX==1) 							// theoretical 3 value node/ +1 registered national level/ 0 not registered national level, other, DK / 0 not asked NA
		replace todrop_registration=0 if (Q413VAT==2|Q414TAX==2|Q413VAT==3|Q414TAX==3)&todrop_registration!=1
		replace todrop_registration=-1 if todrop_registration==.
		
	gen todrop_SS=1 if Q46PENSION==1  												// theoretical 3 value node/ +1 Social security/ 0 not asked / -1 No social security or don't know, Other, Not asked; NA
		replace todrop_SS=-1 if Q46PENSION==2|Q46PENSION==3
		replace todrop_SS=0 if todrop_SS==.
		
	gen todrop_place=. 																// theoretical 2 value node/ +1 fixed visible premises / 0 non fixed premises ::: empty node (no necessary data available)
	
	gen todrop_size=1 if Q416NRWORKERS>3&Q416NRWORKERS<8 							// theoretical 2 value node/ +1 more than 6 workers / 0 less than 6 workers
		replace todrop_size=0 if Q416NRWORKERS<4
		
	gen todrop_paidleave=0															// theoretical 3 value node/ COMPLICATION!
		
	gen todrop_paidsick=0															// theoretical 3 value node/ 
		
	gen todrop_producesforsale=1 													//  theoretical 2 value node / +1 Yes product for sale, Other, Not asked, Don't Know, NA/ 0 No, not for sale :::actual node empty(no necessary data available)
	
	* NOTE: EXCEPTION TO FORCE ALL WORKERS EXCEPT EMPLOYEES WITH NO DATA OR NEGATIVE (FORMALITY WISE) DATA TO INFORMAL
	replace todrop_registration=0 if ilo_lfs==1&todrop_institutional==0&todrop_destinationprod==1&todrop_bookkeeping==0&todrop_registration==-1&ilo_job1_ste_icse93!=1&(todrop_size==.|todrop_place==.)

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

			gen ilo_job1_how_actual=Q419TOTALHRS if (ilo_lfs==1)
					replace ilo_job1_how_actual=Q4211TOTALHRS if (ilo_mjh==2&ilo_lfs==1&ilo_job1_how_actual==.)
					*to avoid missing values one case is set to 1 hour, the minimum he said he worked
					replace ilo_job1_how_actual=1 if ilo_lfs==1&ilo_job1_how_actual==.&Q24APDWRK==1
					*additional layer to avoid missing, there is a respondant with a job that works to not set to 0 - in 2016Q3, nonetheless it makes sense to set this for all cases
					replace ilo_job1_how_actual=1 if ilo_lfs==1&ilo_job1_how_actual==.&Q25APDWRK==1
					lab var ilo_job1_how_actual "Weekly hours actually worked in main job"


			gen ilo_job1_how_actual_bands=.
				replace ilo_job1_how_actual_bands=1 if ilo_job1_how_actual==0
				replace ilo_job1_how_actual_bands=2 if inrange(ilo_job1_how_actual,1,14)
				replace ilo_job1_how_actual_bands=3 if inrange(ilo_job1_how_actual,15,29)
				replace ilo_job1_how_actual_bands=4 if inrange(ilo_job1_how_actual,30,34)
				replace ilo_job1_how_actual_bands=5 if inrange(ilo_job1_how_actual,35,39)
				replace ilo_job1_how_actual_bands=6 if inrange(ilo_job1_how_actual,40,48)
				replace ilo_job1_how_actual_bands=7 if ilo_job1_how_actual>=49 & ilo_job1_how_actual!=.
					lab def how_bands_lab 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 
					lab val ilo_job1_how_actual_bands how_bands_lab
					lab var ilo_job1_how_actual_bands "Weekly hours actually worked bands in main job"
		
		
* 2) Weekly hours USUALLY worked 

			gen ilo_job1_how_usual=Q418HRSWRK if (ilo_lfs==1)
			replace ilo_job1_how_usual=Q420FIRSTHRSWRK if (ilo_mjh==2&ilo_lfs==1&ilo_job1_how_usual==.)
					lab var ilo_job1_how_usual "Weekly hours usually worked in main job"

* Second job: 

* 1) Weekly hours ACTUALLY worked:

		gen ilo_job2_how_actual=Q4212TOTALHRS if (ilo_mjh==2 & ilo_lfs==1)
			*to avoid missing values one case is set to 1 hour, the minimum he said he worked
			replace ilo_job2_how_actual=1 if ilo_lfs==1&ilo_job2_how_actual==.&Q24APDWRK==1&ilo_mjh==2
					lab var ilo_job2_how_actual "Weekly hours actually worked in second job"
					
		
		gen ilo_job2_how_actual_bands=.
			replace ilo_job2_how_actual_bands=1 if ilo_job2_how_actual==0
			replace ilo_job2_how_actual_bands=2 if inrange(ilo_job2_how_actual,1,14)
			replace ilo_job2_how_actual_bands=3 if inrange(ilo_job2_how_actual,15,29)
			replace ilo_job2_how_actual_bands=4 if inrange(ilo_job2_how_actual,30,34)
			replace ilo_job2_how_actual_bands=5 if inrange(ilo_job2_how_actual,35,39)
			replace ilo_job2_how_actual_bands=6 if inrange(ilo_job2_how_actual,40,48)
			replace ilo_job2_how_actual_bands=7 if ilo_job2_how_actual>=49 & ilo_job2_how_actual!=.
				lab val ilo_job2_how_actual_bands how_bands_lab
				lab var ilo_job2_how_actual_bands "Weekly hours actually worked bands in second job"
		

* 2) Weekly hours USUALLY worked - Not available
			gen ilo_job2_how_usual=Q420SECONDHRSWRK if (ilo_mjh==2&ilo_lfs==1)
				lab var ilo_job2_how_usual "Weekly hours usually worked in second job"

* All jobs:
		
* 1) Weekly hours ACTUALLY worked:

			egen ilo_joball_how_actual=rowtotal(ilo_job1_how_actual ilo_job2_how_actual) if (ilo_lfs==1)  
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


* 2) Weekly hours USUALLY worked - Not available
			egen ilo_joball_how_usual=rowtotal(ilo_job1_how_usual ilo_job2_how_usual) if (ilo_lfs==1)
				lab var ilo_joball_how_usual "Weekly hours usually worked in all jobs"

				
				
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job1_job_time') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			

	/* Threshold of 40 hours per week	*/

			gen ilo_job1_job_time=.
				replace ilo_job1_job_time=1 if (ilo_joball_how_actual<40 & ilo_lfs==1) 	// Part-time
				replace ilo_job1_job_time=2 if (ilo_joball_how_actual>39&ilo_joball_how_actual!=. & ilo_lfs==1)	// Full-time
				replace ilo_job1_job_time=3 if (ilo_job1_job_time==. & ilo_lfs==1)	// Unknown
					lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
					lab val ilo_job1_job_time job_time_lab
					lab var ilo_job1_job_time "Job (Working time arrangement) - Main job"	
/*  MISSING
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Monthly labour related income ('ilo_joball_lri')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
	   
			* All jobs
				
				* Employees
					gen ilo_job1_lri_ees=.
						replace ilo_job1_lri_ees=e20d if (e21==1 & ilo_job1_ste_aggregate==1)
						replace ilo_job1_lri_ees=e20d*52/12 if (e21==2 & ilo_job1_ste_aggregate==1)
						replace ilo_job1_lri_ees=e20d*365/12 if (e21==3 & ilo_job1_ste_aggregate==1)
							lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"	
				
				* Self-employed
					gen ilo_job1_lri_slf=.
						replace ilo_job1_lri_slf=e23d if (inlist(ilo_job1_ste_icse93,2,3,4,6))
						lab var ilo_job1_lri_slf "Monthly earnings of self-employed in main job"

*/						
		
***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_joball_tru')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

		gen ilo_joball_tru=.
		*new definition
			replace ilo_joball_tru=1 if (ilo_joball_how_actual<35 & Q422MOREHRS<4 &(Q425==1)) & ilo_lfs==1
			 *ZAF definition appears to be different than what they report
			 *ZAF hypothesis
			*replace ilo_joball_tru=. if ( Q422MOREHRS==1 &(Q424==2))
			lab def tru_lab 1 "Time-related underemployment"
			lab val ilo_joball_tru tru_lab
			lab var ilo_joball_tru "Time-related underemployment"	
		
/* MISSING!
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupational injury ('ilo_joball_inj')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
		
	
	* 1) Cases of non-fatal occupational injuries (within the last 12 months):
	
		gen ilo_joball_oi_case=. if (ilo_lfs==1)
			replace ilo_joball_oi_case=1 if (j2==1)
			lab var ilo_joball_oi_case "Cases of non-fatal occupational injury"

	
	* 2) Days lost due to cases of occupational injuries (within the last 12 months):

		gen ilo_joball_oi_day=j5 if (j5!=0 & ilo_lfs==1)	
				lab var ilo_joball_oi_day "Days lost due to cases of occupational injury"
		
		
*/
***********************************************************************************************
*			PART 3.3. UNEMPLOYMENT: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Category of unemployment ('ilo_cat_une')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	gen ilo_cat_une=.
		replace ilo_cat_une=1 if (Q37ACTPRIORJOBSEEK==1&ilo_lfs==2)
		replace ilo_cat_une=2 if (Q37ACTPRIORJOBSEEK==3&ilo_lfs==2)
		replace ilo_cat_une=3 if (ilo_cat_une==.&ilo_lfs==2)
				lab def ilo_cat_une 1 "Unemployed previously employed" 2 "Unemployed seeking first job" 3 "Unknown"
				lab val ilo_cat_une ilo_cat_une
				lab var ilo_cat_une "Category of unemployment"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	* note details not possible 
			

	gen ilo_dur_aggregate=.
				replace ilo_dur_aggregate=1 if (Q36TIMESEEK<2 & ilo_lfs==2)
				replace ilo_dur_aggregate=2 if (Q36TIMESEEK>2&Q36TIMESEEK<5 & ilo_lfs==2)
				replace ilo_dur_aggregate=3 if (Q36TIMESEEK>4&Q36TIMESEEK<8 & ilo_lfs==2)
				replace ilo_dur_aggregate=4 if (Q36TIMESEEK==8 & ilo_lfs==2)
				*to avoid missing values
				replace ilo_dur_aggregate=4 if ( ilo_dur_aggregate==.&ilo_lfs==2)
					lab def ilo_unemp_aggr 1 "Less than 6 months" 2 "6 months to less than 12 months" 3 "12 months or more" 4 "Not elsewhere classified"
					lab val ilo_dur_aggregate ilo_unemp_aggr
					lab var ilo_dur_aggregate "Duration of unemployment (Aggregate)"
	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
* Note the scope is limited to previously employed unemployed persons

	
		* Primary activity
		gen todrop=trunc(Q316PREVINDUSTRY/10) if (ilo_lfs==2&ilo_cat_une==1)
		*avoiding missing values, if there is no data the cases are considered as not classifiable
		replace todrop=9999 if todrop==.&ilo_lfs==2&ilo_cat_une==1
		
		
		* Classification 1 digit level
		
		#delimit ;
		recode todrop 
11 = 1
12 = 1
13 = 2
21 = 3
22 = 3
23 = 3
24 = 3
25 = 3
29 = 18
30 = 4
31 = 4
32 = 4
33 = 4
34 = 4
35 = 4
36 = 4
37 = 4
38 = 4
39 = 4
41 = 5
42 = 5
50 = 6
61 = 7
62 = 7
63 = 7
64 = 8
71 = 9
72 = 9
73 = 9
74 = 9
75 = 9
81 = 10
82 = 10
83 = 10
84 = 11
85 = 11
86 = 11
87 = 11
88 = 11
91 = 12
92 = 13
93 = 14
94 = 15
95 = 15
96 = 15
99 = 15
1 = 16
2 = 17
3 = 18
9 = 18
9999 0 .=18
		, gen(ilo_preveco_isic3);
		#delimit cr
			lab def ilo_preveco_isic3 1 "A - Agriculture, hunting and forestry" 2 "B - Fishing" 3 "C - Mining and quarrying" 4 "D - Manufacturing" 5 "E - Electricity, gas and water supply" 6 "F - Construction" 7 "G - Wholesale and retail trade; repair of motor vehicles, motorcycles and personal and household goods" 8 "H - Hotels and restaurants" 9 "I - Transport, storage and communications" 10 "J - Financial intermediation" 11 "K - Real estate, renting and business activities" 12 "L - Public administration and defence; compulsory social security" 13 "M - Education" 14 "N - Health and social work" 15 "O - Other community, social and personal service activities" 16 "P - Activities of private households as employers and undifferentiated production activities of private households" 17 "Q - Extraterritorial organizations and bodies" 18 "X - Not elsewhere classified"				
			lab val ilo_preveco_isic3 ilo_preveco_isic3
			lab var ilo_preveco_isic3 "Previous economic activity (ISIC Rev. 3.1)"

		
		
		
		* Classification aggregated level	
		
		#delimit ;
		recode todrop 
11 = 1
12 = 1
13 = 1
21 = 4
22 = 4
23 = 4
24 = 4
25 = 4
29 = 7
30 = 2
31 = 2
32 = 2
33 = 2
34 = 2
35 = 2
36 = 2
37 = 2
38 = 2
39 = 2
41 = 4
42 = 4
50 = 3
61 = 5
62 = 5
63 = 5
64 = 5
71 = 5
72 = 5
73 = 5
74 = 5
75 = 5
81 = 5
82 = 5
83 = 5
84 = 5
85 = 5
86 = 5
87 = 5
88 = 5
91 = 6
92 = 6
93 = 6
94 = 6
95 = 6
96 = 6
99 = 6
1 = 6
2 = 6
3 = 7
9 = 7
9999 0 .=7
		, gen(ilo_preveco_aggregate);
		#delimit cr
			lab def ilo_preveco_aggregate 1 "1 - Agriculture" 2 "2 - Manufacturing" 3 "3 - Construction" 4 "4 - Mining and quarrying; Electricity, gas and water supply" ///
					5 "5 - Market Services (Trade; Transportation; Accommodation and food; and Business and administrative services)"  ///
					6 "6 - Non-market services (Public administration; Community, social and other services and activities)" 7 "7 - Not classifiable by economic activity"					
			lab val ilo_preveco_aggregate ilo_preveco_aggregate
			lab var ilo_preveco_aggregate "Previous economic activity (Aggregate)"
		drop todrop





* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu_isco88')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

	/* Classification used: ISCO 88  */
* Note the scope is limited to previously employed unemployed persons
	* MAIN JOB:	
	
		* ISCO 88 - 2 digit
			gen todrop=Q315PREVOCCUPATION if ilo_lfs==2&ilo_cat_une==1
			replace todrop=6210 if todrop==6211
			replace todrop=0110 if todrop==5164
			replace todrop=trunc(todrop/100)
			gen todrop2=todrop if (ilo_lfs==2&Q315PREVOCCUPATION!=9999)



		
		* ISCO 88 - 1 digit

			gen todrop3=.
				replace todrop3=1 if inrange(todrop2,10,19)
				replace todrop3=2 if inrange(todrop2,20,29)
				replace todrop3=3 if inrange(todrop2,30,39)
				replace todrop3=4 if inrange(todrop2,40,49)
				replace todrop3=5 if inrange(todrop2,50,59)
				replace todrop3=6 if inrange(todrop2,60,69)
				replace todrop3=7 if inrange(todrop2,70,79)
				replace todrop3=8 if inrange(todrop2,80,89)
				replace todrop3=9 if inrange(todrop2,90,98)
				replace todrop3=10 if inrange(todrop2,1,1)
				replace todrop3=11 if (todrop3==. & ilo_lfs==2&ilo_cat_une==1)
				*avoiding missing values, if there is no data the cases are considered as not classifiable
			gen ilo_prevocu_isco88=todrop3
				lab def ilo_prevocu_isco88 1 "1 - Managers" 2 "2 - Professionals" 3 "Technicians and associate professionals" 4 "4 - Clerical support workers" 5 "5 - Service and sales workers" ///
					6 "6 - Skilled agricultural, forestry and fishery workers" 7 "7 - Craft and related trades workers" 8 "8 - Plant and machine operators, and assemblers" ///
					9 "9 - Elementary occupations" 10 "0 - Armed forces occupations" 11 "X - Not elsewhere classified"
				lab val ilo_prevocu_isco88 ilo_prevocu_isco88
				lab var ilo_prevocu_isco88 "Previous occupation (ISCO-88)"		

		* Aggregate:

			gen ilo_prevocu_aggregate=.
				replace ilo_prevocu_aggregate=1 if inrange(todrop3,1,3)
				replace ilo_prevocu_aggregate=2 if inlist(todrop3,4,5)
				replace ilo_prevocu_aggregate=3 if inlist(todrop3,6,7)
				replace ilo_prevocu_aggregate=4 if todrop3==8
				replace ilo_prevocu_aggregate=5 if todrop3==9
				replace ilo_prevocu_aggregate=6 if todrop3==10
				replace ilo_prevocu_aggregate=7 if todrop3==11
					lab def ilo_prevocu_aggregate 1 "1 - Managers, professionals, and technicians" 2 "2 - Clerical, service and sales workers" 3 "3 - Skilled agricultural and trades workers" ///
										4 "4 - Plant and machine operators, and assemblers" 5 "5 - Elementary occupations" 6 "6 - Armed forces" 7 "7 - Not elsewhere classified"
					lab val ilo_prevocu_aggregate ilo_prevocu_aggregate
					lab var ilo_prevocu_aggregate "Previous occupation (Aggregate)"	
				
				drop todrop*	
				
				
		* Skill level
		recode ilo_prevocu_isco88 (1/3=3) (4/8=2) (9=1) (10/11=4) ,gen(ilo_prevocu_skill)
		lab def ilo_prevocu_skill 1 "1 - Skill level 1 (low)" 2 "2 - Skill level 2 (medium)" 3 "3 - Skill levels 3 and 4 (high)" 4 "4 - Not elsewhere classified"
		lab val ilo_prevocu_skill ilo_prevocu_skill
		lab var ilo_prevocu_skill "Previous occupation (Skill level)"
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
	
	
	gen ilo_olf_dlma=.
		replace ilo_olf_dlma = 1 if (Q31ALOOKWRK==1|Q31BSTARTBUSNS==1)&(Q39JOBOFFER==2&Q310STARTBUSNS==2)&ilo_lfs==3							 	//Seeking, not available
		replace ilo_olf_dlma = 2 if (Q31ALOOKWRK==2&Q31BSTARTBUSNS==2)&(Q39JOBOFFER==1|Q310STARTBUSNS==1)&ilo_lfs==3								//Not seeking, available
		replace ilo_olf_dlma = 3 if (Q31ALOOKWRK==2&Q31BSTARTBUSNS==2)&(Q39JOBOFFER==2&Q310STARTBUSNS==2)&(Q34WANTTOWRK==1)&ilo_lfs==3			//Not seeking, not available, willing
		replace ilo_olf_dlma = 4 if (Q31ALOOKWRK==2&Q31BSTARTBUSNS==2)&(Q39JOBOFFER==2&Q310STARTBUSNS==2)&(Q34WANTTOWRK==2)&ilo_lfs==3			//Not seeking, not available, not willing
		replace ilo_olf_dlma = 5 if	(ilo_olf_dlma==. & ilo_lfs==3)				// Not classified 
	
			lab def dlma_lab 1 "1 - Seeking, not available (Unavailable jobseekers)" 2 "2 - Not seeking, available (Available potential jobseekers)" ///
							 3 "3 - Not seeking, not available, willing (Willing non-jobseekers)" 4 "4 - Not seeking, not available, not willing" 5 "X - Not elsewhere classified"
			lab val ilo_olf_dlma dlma_lab 
			lab var ilo_olf_dlma "Labour market attachment (Degree of)"


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reason for not seeking job ('ilo_olf_reason')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

	gen ilo_olf_reason=.
		replace ilo_olf_reason=1 if	(inlist(Q38RSNNOTSEEK,1,2,7,8,10,11) & ilo_lfs==3)					//Labour market
		replace ilo_olf_reason=2 if	(inlist(Q38RSNNOTSEEK,3,4,5,6,13)  & ilo_lfs==3)						//Personal/Family-related
		replace ilo_olf_reason=3 if (inlist(Q38RSNNOTSEEK,14,15)  & ilo_lfs==3)						//Does not need/want to work
		replace ilo_olf_reason=4 if (inlist(Q38RSNNOTSEEK,16,12,9)  & ilo_lfs==3)						//Not elsewhere classified
		replace ilo_olf_reason=4 if (ilo_olf_reason==. & ilo_lfs==3)							//Not elsewhere classified
			lab def reasons_lab 1 "1 - Labour market" 2 "2 - Personal / Family-related" 3 "3 - Does not need/want to work" 4 "4 - Not elsewhere classified"
			lab val ilo_olf_reason reasons_lab 
			lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"
			

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seeker ('ilo_dis')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

	gen ilo_dis=1 if ( (Q38RSNNOTSEEK==8|Q38RSNNOTSEEK==10|Q38RSNNOTSEEK==11)& ilo_olf_reason==1)
			lab def dis_lab 1 "Discouraged job-seekers"
			lab val ilo_dis dis_lab
			lab var ilo_dis "Discouraged job-seekers"
			

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training ('ilo_neet')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

decode ilo_time, gen(todrop)
split todrop, generate(todrop_) parse(Q)
destring todrop_1, replace force
local Y = todrop_1 in 1
	
	
if `Y'<2013 {

} 
else {
	gen ilo_neet=1 if (ilo_age_aggregate==2 & ilo_lfs!=1 & ilo_edu_attendance==2)
			lab def neet_lab 1 "Youth not in education, employment or training"
			lab val ilo_neet neet_lab
			lab var ilo_neet "Youth not in education, employment or training"

}


drop todrop*		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Drop intermediate variables used for labeling activity and occupation
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
drop isco08_2digits isco88_2digits isco08 isco88 isic4_2digits isic4 isic3_2digits isic3

**** Removing added variables (due to labels)

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
