* TITLE OF DO FILE: ILO Microdata Preprocessing code template - BOL HS 2014
* DATASET USED: BOL HS 2014
* NOTES:
* Author: Roger Gomis

* Starting Date: 20 February 2017
* Last updated: 08 February 2018
***********************************************************************************************


***********************************************************************************************
***********************************************************************************************

* 			1. SET UP WORK DIRECTORY, FILE NAME, VARIABLES AND FUNCTIONS

***********************************************************************************************
***********************************************************************************************

clear all 

set more off

global path "J:\DPAU\MICRO"
global country "BOL"
global source "EH"
global time "2015"
global inputFile "EH2015_PERSONAS"

global inpath "${path}\\${country}\\${source}\\${time}\ORI"
global temppath "${path}\_Admin"
global outpath "${path}\\${country}\\${source}\\${time}"

************************************************************************************

cd "$inpath"
	use ${inputFile}, clear
	*renaming everything in lower case
	rename *, lower  


 
***********************************************************************************************
***********************************************************************************************

*			2. MAP VARIABLES

***********************************************************************************************
***********************************************************************************************

* ---------------------------------------------------------------------------------------------
***********************************************************************************************
*			PART 0.5 MAKING VARIABLES COMPATIBLE ACROSS YEARS
***********************************************************************************************
* ---------------------------------------------------------------------------------------------

* note: regarding changes with respect to previous year (2014)
*Short cycle tertiary education has dissapeared, the 5-8 codes (indicating completion) were in 2014 very scarce (5 cases) and now there are none (perhaps in both cases due to coding)
*Time related underemployment presents a large decrease but seems genuine

gen cuttof_start=1

if ${time}==2015 {
**** straightforward name changes

gen URBRUR=area
gen s5a_02=s5a_2a
gen s5a_02a=s5a_2b
gen s5a_04=s5a_4
gen s4a_06a=s4a_6a
gen s4a_06b=s4a_6b
gen s4a_06c=s4a_6c
gen s4a_06d=s4a_6d
gen s4a_06e=s4a_6e
gen s4a_06f=s4a_6f_1
gen s6e_35a=s6d_35acod
gen s6b_20=s6b_21
gen s6b_23h=s6b_23a 
gen s6e_39bh=s6e_39ba
gen s6e_39bm=s6e_39bb
gen s6a_10=s6a_10a



****name in the 2014 version already exists with another meaning for 2015

*** WITHOUT CONFLICT
gen copy__s6b_11a=s6b_11a
drop s6b_11a
gen s6b_11a=s6b_11acod

gen copy__s6b_23m=s6b_23m
drop s6b_23m
gen s6b_23m=s6b_23b

gen copy__s6b_12a=s6b_12a
drop s6b_12a
gen s6b_12a=s6b_12acod

***WITH CONFLICT (if not done the do code will process another variable instead of the correct one) - done together and work with copies
gen copy__s6b_17=s6b_17
gen copy__s6b_18=s6b_18
gen copy__s6b_19=s6b_19

drop s6b_17
drop s6b_18
drop s6b_19


gen s6b_17=copy__s6b_18
gen s6b_18=copy__s6b_19
gen s6b_19=s6b_20a

}
/* Correspondence between years, 

note if old Variable for year 2015 is equal to missing, 
then it means it had the same name and it is the same variable 
(The variable has been checked to see that indeed it represents the same question)
(The discrepancies in minimum and maximum value are also adressed)


2014-----------------------------------2015-----------------------------------
Variable-----------------------------------Old Variable-----------------------------------Explanation discrepancy (numerical range of answers)
URBRUR-----------------------------------area-----------------------------------
factor----------------------------------------------------------------------Integer, not a problem
s2a_02----------------------------------------------------------------------
s2a_03----------------------------------------------------------------------
s4a_06a-----------------------------------s4a_6a-----------------------------------Bad code for 2014
s4a_06b-----------------------------------s4a_6b-----------------------------------Bad code for 2015
s4a_06c-----------------------------------s4a_6c-----------------------------------Bad code for 2016
s4a_06d-----------------------------------s4a_6d-----------------------------------Bad code for 2017
s4a_06e-----------------------------------s4a_6e-----------------------------------Bad code for 2018
s4a_06f-----------------------------------s4a_6f_1-----------------------------------Bad code for 2019
s5a_02-----------------------------------s5a_2a-----------------------------------81 category for other course work (will not affect the result)
s5a_02a-----------------------------------s5a_2b-----------------------------------Alternative education, in 2014 had no instance of the maximum course (will not affect the result)
s5a_04-----------------------------------s5a_4-----------------------------------
s6a_01----------------------------------------------------------------------
s6a_02----------------------------------------------------------------------
s6a_03----------------------------------------------------------------------
s6a_04----------------------------------------------------------------------
s6a_05----------------------------------------------------------------------
s6a_07----------------------------------------------------------------------
s6a_08a----------------------------------------------------------------------Integer, not a problem
s6a_08b----------------------------------------------------------------------
s6a_10-----------------------------------s6a_10a-----------------------------------
s6b_11a-----------------------------------s6b_11acod-----------------------------------
s6b_12a-----------------------------------s6b_12acod-----------------------------------Spurious code, not a problem
s6b_16----------------------------------------------------------------------
s6b_17-----------------------------------s6b_18-----------------------------------Change of order, solved
s6b_18-----------------------------------s6b_19-----------------------------------Change of order, solved
s6b_19-----------------------------------s6b_20a-----------------------------------Change of order, solved
s6b_20-----------------------------------s6b_21-----------------------------------Integer, not a problem
s6b_22----------------------------------------------------------------------
s6b_23h-----------------------------------s6b_23a -----------------------------------
s6b_23m-----------------------------------s6b_23b-----------------------------------
s6c_25a----------------------------------------------------------------------Integer, not a problem
s6c_25b----------------------------------------------------------------------
s6c_29a----------------------------------------------------------------------
s6c_29b----------------------------------------------------------------------
s6d_33a----------------------------------------------------------------------
s6d_33b----------------------------------------------------------------------
s6d_34----------------------------------------------------------------------
s6e_35a-----------------------------------s6d_35acod-----------------------------------Spurious code, not a problem
s6g_46----------------------------------------------------------------------
s6g_47----------------------------------------------------------------------
s6e_39a----------------------------------------------------------------------Integer, not a problem
s6e_39bh-----------------------------------s6e_39ba-----------------------------------
s6e_39bm-----------------------------------s6e_39bb-----------------------------------

*/





if ${time}==2016 {
gen URBRUR=area

rename *s08* *s8*
rename *s07* *s7*
rename *s06* *s6*
rename *s05* *s5*
rename *s04* *s4*
rename *s03* *s3*
rename *s02* *s2*


gen s5a_02=s5a_02a
drop s5a_02a
gen s5a_02a=s5a_02b

drop s5a_04
gen s5a_04=s5a_05



gen s6e_35a=s6f_41acod

rename s6b_20 s6b_20a
gen s6b_20=s6b_21
gen s6b_23h=s6b_23aa 

gen s6e_39bh=s6f_46a
gen s6e_39bm=0

**** new ones
gen  s6d_34=s6e_40
gen s6g_46=s6h_53
gen s6g_47=s6h_54


*transform one of the causes to a similar one
replace s6a_10=5 if s6a_10==12
replace s6a_10=12 if s6a_10==13

****name in the 2014 version already exists with another meaning for 2015

*** WITHOUT CONFLICT
gen copy__s6b_11a=s6b_11a
drop s6b_11a
gen s6b_11a=s6b_11acod

gen s6b_23m=0

gen copy__s6b_12a=s6b_12a
drop s6b_12a
gen s6b_12a=s6b_12acod

***WITH CONFLICT (if not done the do code will process another variable instead of the correct one) - done together and work with copies
gen copy__s6b_17=s6b_17
gen copy__s6b_18=s6b_18
gen copy__s6b_19=s6b_19
gen copy__s6e_39a=s6e_39a

drop s6b_17
drop s6b_18
drop s6b_19
drop s6e_39a


gen s6b_17=copy__s6b_18
gen s6b_18=copy__s6b_19
gen s6b_19=s6b_20a
gen s6e_39a=s6f_45

}


if ${time}==2017 {

gen URBRUR=area
rename *s07* *s7*
rename *s06* *s6*
rename *s05* *s5*
rename *s04* *s4*
rename *s03* *s3*
rename *s02* *s2*


gen s5a_02=s5a_02a
drop s5a_02a
gen s5a_02a=s5a_02b

drop s5a_04
gen s5a_04=s5a_05



gen s6e_35a=s6f_40a_cod



gen s6b_23h=s6b_23aa 

gen s6e_39bh=s6f_45a
gen s6e_39bm=s6f_45b

**** new ones
gen  s6d_34=s6e_39
gen s6g_46=s6h_52
gen s6g_47=s6h_53




*transform one of the causes to a similar one
replace s6a_10=5 if s6a_10==12
replace s6a_10=12 if s6a_10==13

****name in the 2014 version already exists with another meaning for 2015

*** WITHOUT CONFLICT
gen copy__s6b_11a=s6b_11a
drop s6b_11a
gen s6b_11a=s6b_11a_cod

gen s6b_23m=0

gen copy__s6b_12a=s6b_12a
drop s6b_12a
gen s6b_12a=s6b_12a_cod

***WITH CONFLICT (if not done the do code will process another variable instead of the correct one) - done together and work with copies
gen copy__s6b_17=s6b_17
gen copy__s6b_18=s6b_18
gen copy__s6b_19=s6b_19
*gen copy__s6e_39a=s6e_39a

drop s6b_17
drop s6b_18
drop s6b_19
*drop s6e_39a


gen s6b_17=copy__s6b_18
gen s6b_18=copy__s6b_19

gen s6e_39a=s6f_44


gen s6b_19=s6b_20
drop s6b_20
gen s6b_20 = s6b_21


}

gen cuttof_end=1

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
		replace ilo_geo=1 if URBRUR==1
		replace ilo_geo=2 if URBRUR==2
			lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural"
			lab val ilo_geo ilo_geo_lab
			lab var ilo_geo "Geographical coverage"	

			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_sex=s2a_02
		lab def ilo_sex_lab 1 "1 - Male" 2 "2 - Female"
		lab var ilo_sex "Sex"
		lab val ilo_sex ilo_sex_lab


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_age=s2a_03
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
					file:///J:\DPAU\MICRO\BOL\HS\2014\ORI\isced_2011_mapping_template_bolivia_plurinational_state_of_en.xlsx	*/

* Note that according to the definition, the highest level CONCLUDED is considered.
* also note that doctorate and masters are bunched together, the solution assumed is  doctorate-> master
	gen ilo_edu_isced11=.
		replace ilo_edu_isced11=1 if inrange(s5a_02,11,12)|s5a_02==13&s5a_02a<2																							// No schooling
		replace ilo_edu_isced11=2 if (s5a_02==13&s5a_02a==2)|(s5a_02==21)|(s5a_02==31&s5a_02a<6)|(s5a_02==41&s5a_02a<6)	  												// Early childhood education
		replace ilo_edu_isced11=3 if (s5a_02==22&inlist(s5a_02a,1,2))|(s5a_02==31&inlist(s5a_02a,6,7))|((s5a_02==41&inlist(s5a_02a,6))|(s5a_02==42&inlist(s5a_02a,1)))	// Primary education
		replace ilo_edu_isced11=4 if (s5a_02==22&s5a_02a==3|s5a_02==23&s5a_02a<4)|(s5a_02==31&s5a_02a==8|s5a_02==32&s5a_02a<4)|(s5a_02==42&s5a_02a>1&s5a_02a<6) 		// Lower secondary education
		replace ilo_edu_isced11=5 if ((s5a_02==23&s5a_02a==4)|(s5a_02==32&s5a_02a==4)|(s5a_02==42&s5a_02a==6))|(inlist(s5a_02,71,72,73,74,77)&(s5a_02a!=5&s5a_02a!=8))  // Upper secondary education
		*replace ilo_edu_isced11=6 EMPTY not in ISCED11 correspondence for Bolivia																						// Post-secondary non-tertiary
		replace ilo_edu_isced11=7 if s5a_02==77&(s5a_02a==5|s5a_02a==8)																									// Short-cycle tertiary education
		replace ilo_edu_isced11=8 if (inlist(s5a_02,71,72,73,74)&(s5a_02a==5|s5a_02a==8))|(s5a_02==75&(s5a_02a<5))														// Bachelor or equivalent
		replace ilo_edu_isced11=9 if s5a_02==75&(s5a_02a==5|s5a_02a==8)|(s5a_02==76&(s5a_02a<5))																		// Master's or equivalent level
		replace ilo_edu_isced11=10 if s5a_02==76&(s5a_02a==5|s5a_02a==8)																								// Doctoral or equivalent level
		replace ilo_edu_isced11=11 if ilo_edu_isced11==.																												// Not elsewhere classified
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
		
	
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education attendance ('ilo_edu_attendance')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------


	gen ilo_edu_attendance=.
		replace ilo_edu_attendance=1 if s5a_04==1				// Attending
		replace ilo_edu_attendance=2 if s5a_04==2				// Not attending
		replace ilo_edu_attendance=3 if ilo_edu_attendance==.
			label def edu_att_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Unkown"
			label val ilo_edu_attendance edu_att_lab
			label var ilo_edu_attendance "Education (Attendance)"

			

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			           Marital status ('ilo_mrts') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 
	
	* Detailed
	gen ilo_mrts_details=.
	    replace ilo_mrts_details=1 if s2a_10==1                                           // Single
		replace ilo_mrts_details=2 if s2a_10==2                                          // Married
		replace ilo_mrts_details=3 if s2a_10==3                                          // Union / cohabiting
		replace ilo_mrts_details=4 if s2a_10==6                                          // Widowed
		replace ilo_mrts_details=5 if inlist(s2a_10,4,5)                                          // Divorced / separated
		replace ilo_mrts_details=6 if ilo_mrts_details==.			            // Not elsewhere classified
		        label define label_mrts_details 1 "1 - Single" 2 "2 - Married" 3 "3 - Union / cohabiting" ///
				                                4 "4 - Widowed" 5 "5 - Divorced / separated" 6 "6 - Not elsewhere classified"
		        label values ilo_mrts_details label_mrts_details
		        lab var ilo_mrts_details "Marital status"
				
	* Aggregate
	gen ilo_mrts_aggregate=.
	    replace ilo_mrts_aggregate=1 if inlist(ilo_mrts_details,1,4,5)          // Single / Widowed / Divorced / Separated
		replace ilo_mrts_aggregate=2 if inlist(ilo_mrts_details,2,3)            // Married / Union / Cohabiting
		replace ilo_mrts_aggregate=3 if ilo_mrts_aggregate==. 			        // Not elsewhere classified
		        label define label_mrts_aggregate 1 "1 - Single / Widowed / Divorced / Separated" 2 "2 - Married / Union / Cohabiting" 3 "3 - Not elsewhere classified"
		        label values ilo_mrts_aggregate label_mrts_aggregate
		        lab var ilo_mrts_aggregate "Marital status (Aggregate levels)"				
						
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Disability status ('ilo_dsb')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
		*note there are some missing values that are coded as 9, these are forced to be not disabled
if ${time}==2015 {
	egen todrop=rowtotal(s4a_06a- s4a_06f)				
	gen ilo_dsb_aggregate=.
		replace ilo_dsb_aggregate=2 if todrop<12
		replace ilo_dsb_aggregate=1 if todrop==12
		replace ilo_dsb_aggregate=1 if todrop>12
			label def dsb_aggregate_lab 1 "Persons without disability" 2 "Persons with disability"
			label val ilo_dsb_aggregate dsb_aggregate_lab
			label var ilo_dsb_aggregate "Disability status (Aggregate)"
	drop todrop
}
	
if ${time}>2015 {
	egen todrop=rowmax(s4a_06a- s4a_06g)				
	gen ilo_dsb_aggregate=.
		replace ilo_dsb_aggregate=2 if todrop==3|todrop==4
		replace ilo_dsb_aggregate=1 if todrop<3

			label def dsb_aggregate_lab 1 "Persons without disability" 2 "Persons with disability"
			label val ilo_dsb_aggregate dsb_aggregate_lab
			label var ilo_dsb_aggregate "Disability status (Aggregate)"
	drop todrop

}

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
	gen ilo_lfs=.
		replace ilo_lfs=1 if ((s6a_01==1 | s6a_02<7 | s6a_03<8 ) & ilo_wap==1) 	// Employed
		replace ilo_lfs=2 if (ilo_wap==1 & ilo_lfs!=1 & (s6a_01==2 | s6a_02==7| s6a_03==8 )&(s6a_04==1)&(s6a_05==1)) 	// Unemployed
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
		replace ilo_mjh=1 if s6d_34==2 & ilo_lfs==1
		replace ilo_mjh=2 if s6d_34==1 & ilo_lfs==1
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
			replace ilo_job1_ste_icse93=1 if (s6b_16<3|s6b_16==8) & ilo_lfs==1		// Employees
			replace ilo_job1_ste_icse93=2 if (s6b_16==4|s6b_16==5) & ilo_lfs==1		// Employers
			replace ilo_job1_ste_icse93=3 if s6b_16==3 & ilo_lfs==1		// Own-account workers
			replace ilo_job1_ste_icse93=4 if s6b_16==6 & ilo_lfs==1		// Members of cooperatives
			replace ilo_job1_ste_icse93=5 if s6b_16==7 & ilo_lfs==1		// Contributing family workers
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

				

count
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
/* IT FOLLOWS ISIC 4, nonetheless there is info on the 2 digit level, and in certain cases only one digit level (In letters)*/ 
	*there are several precautions that should be taken
 
	gen todrop0=substr(s6b_12a,1,3)
	* there are (very few) observations that do not match ISIC4 due to the use of 999... as not correctly classified
	* there are instances of the code 890.. to describe institutional sector which does not belong in the question
	replace todrop0="" if todrop0=="999"
	replace todrop0="" if todrop0=="890"
	
	destring todrop0, generate(todrop1) force
	gen todrop2=substr(todrop0,1,2) if todrop1!=.
	gen todrop3=substr(todrop0,1,1) if todrop1==.&s6b_12a!=""
	destring todrop2, generate(todrop4)



		* Use value label from this variable, afterwards drop everything related to this append
					
		* Primary activity
		
		gen ilo_job1_eco_isic4_2digits=todrop4 if (ilo_lfs==1)
			    lab def eco_isic4_2digits 1 "01 - Crop and animal production, hunting and related service activities"	2 "02 - Forestry and logging"	3 "03 - Fishing and aquaculture"	5 "05 - Mining of coal and lignite" ///
                                          6 "06 - Extraction of crude petroleum and natural gas"	7 "07 - Mining of metal ores"	8 "08 - Other mining and quarrying"	9 "09 - Mining support service activities" ///
                                          10 "10 - Manufacture of food products"	11 "11 - Manufacture of beverages"	12 "12 - Manufacture of tobacco products"	13 "13 - Manufacture of textiles" ///
                                          14 "14 - Manufacture of wearing apparel"	15 "15 - Manufacture of leather and related products"	16 "16 - Manufacture of wood and of products of wood and cork, except furniture; manufacture of articles of straw and plaiting materials"	17 "17 - Manufacture of paper and paper products" ///
                                          18 "18 - Printing and reproduction of recorded media"	19 "19 - Manufacture of coke and refined petroleum products"	20 "20 - Manufacture of chemicals and chemical products"	21 "21 - Manufacture of pharmaceuticals, medicinal chemical and botanical products" ///
                                          22 "22 - Manufacture of rubber and plastics products"	23 "23 - Manufacture of other non-metallic mineral products"	24 "24 - Manufacture of basic metals"	25 "25 - Manufacture of fabricated metal products, except machinery and equipment" ///
                                          26 "26 - Manufacture of computer, electronic and optical products"	27 "27 - Manufacture of electrical equipment"	28 "28 - Manufacture of machinery and equipment n.e.c."	29 "29 - Manufacture of motor vehicles, trailers and semi-trailers" ///
                                          30 "30 - Manufacture of other transport equipment"	31 "31 - Manufacture of furniture"	32 "32 - Other manufacturing"	33 "33 - Repair and installation of machinery and equipment" ///
                                          35 "35 - Electricity, gas, steam and air conditioning supply"	36 "36 - Water collection, treatment and supply"	37 "37 - Sewerage"	38 "38 - Waste collection, treatment and disposal activities; materials recovery" ///
                                          39 "39 - Remediation activities and other waste management services"	41 "41 - Construction of buildings"	42 "42 - Civil engineering"	43 "43 - Specialized construction activities" ///
                                          45 "45 - Wholesale and retail trade and repair of motor vehicles and motorcycles"	46 "46 - Wholesale trade, except of motor vehicles and motorcycles"	47 "47 - Retail trade, except of motor vehicles and motorcycles"	49 "49 - Land transport and transport via pipelines" ///
                                          50 "50 - Water transport"	51 "51 - Air transport"	52 "52 - Warehousing and support activities for transportation"	53 "53 - Postal and courier activities" ///
                                          55 "55 - Accommodation"	56 "56 - Food and beverage service activities"	58 "58 - Publishing activities"	59 "59 - Motion picture, video and television programme production, sound recording and music publishing activities" ///
                                          60 "60 - Programming and broadcasting activities"	61 "61 - Telecommunications"	62 "62 - Computer programming, consultancy and related activities"	63 "63 - Information service activities" ///
                                          64 "64 - Financial service activities, except insurance and pension funding"	65 "65 - Insurance, reinsurance and pension funding, except compulsory social security"	66 "66 - Activities auxiliary to financial service and insurance activities"	68 "68 - Real estate activities" ///
                                          69 "69 - Legal and accounting activities"	70 "70 - Activities of head offices; management consultancy activities"	71 "71 - Architectural and engineering activities; technical testing and analysis"	72 "72 - Scientific research and development" ///
                                          73 "73 - Advertising and market research"	74 "74 - Other professional, scientific and technical activities"	75 "75 - Veterinary activities"	77 "77 - Rental and leasing activities" ///
                                          78 "78 - Employment activities"	79 "79 - Travel agency, tour operator, reservation service and related activities"	80 "80 - Security and investigation activities"	81 "81 - Services to buildings and landscape activities" ///
                                          82 "82 - Office administrative, office support and other business support activities"	84 "84 - Public administration and defence; compulsory social security"	85 "85 - Education"	86 "86 - Human health activities" ///
                                          87 "87 - Residential care activities"	88 "88 - Social work activities without accommodation"	90 "90 - Creative, arts and entertainment activities"	91 "91 - Libraries, archives, museums and other cultural activities" ///
                                          92 "92 - Gambling and betting activities"	93 "93 - Sports activities and amusement and recreation activities"	94 "94 - Activities of membership organizations"	95 "95 - Repair of computers and personal and household goods" ///
                                          96 "96 - Other personal service activities"	97 "97 - Activities of households as employers of domestic personnel"	98 "98 - Undifferentiated goods- and services-producing activities of private households for own use"	99 "99 - Activities of extraterritorial organizations and bodies"
                lab val ilo_job1_eco_isic4_2digits eco_isic4_2digits
                lab var ilo_job1_eco_isic4_2digits "Economic activity (ISIC Rev. 4), 2 digits level - main job"


		
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
			replace ilo_job1_eco_isic4=22 if ilo_job1_eco_isic4_2digits==. & ilo_lfs==1 
			
*** Additional recoding due to the availability of only division level
replace ilo_job1_eco_isic4 = 1 if todrop3 =="A"
replace ilo_job1_eco_isic4 = 2 if todrop3 =="B"
replace ilo_job1_eco_isic4 = 3 if todrop3 =="C"
replace ilo_job1_eco_isic4 = 4 if todrop3 =="D"
replace ilo_job1_eco_isic4 = 5 if todrop3 =="E"
replace ilo_job1_eco_isic4 = 6 if todrop3 =="F"
replace ilo_job1_eco_isic4 = 7 if todrop3 =="G"
replace ilo_job1_eco_isic4 = 8 if todrop3 =="H"
replace ilo_job1_eco_isic4 = 9 if todrop3 =="I"
replace ilo_job1_eco_isic4 = 10 if todrop3 =="J"
replace ilo_job1_eco_isic4 = 11 if todrop3 =="K"
replace ilo_job1_eco_isic4 = 12 if todrop3 =="L"
replace ilo_job1_eco_isic4 = 13 if todrop3 =="M"
replace ilo_job1_eco_isic4 = 14 if todrop3 =="N"
replace ilo_job1_eco_isic4 = 15 if todrop3 =="O"
replace ilo_job1_eco_isic4 = 16 if todrop3 =="P"
replace ilo_job1_eco_isic4 = 17 if todrop3 =="Q"
replace ilo_job1_eco_isic4 = 18 if todrop3 =="R"
replace ilo_job1_eco_isic4 = 19 if todrop3 =="S"
replace ilo_job1_eco_isic4 = 20 if todrop3 =="T"
replace ilo_job1_eco_isic4 = 21 if todrop3 =="U"
replace ilo_job1_eco_isic4 = 22 if todrop3 =="X"
replace ilo_job1_eco_isic4 =. if (ilo_lfs!=1 )
** end correction for division level data
		        lab def eco_isic4_1digit 1 "A - Agriculture, forestry and fishing"	2 "B - Mining and quarrying"	3 "C - Manufacturing"	4 "D - Electricity, gas, steam and air conditioning supply" ///
                                         5 "E - Water supply; sewerage, waste management and remediation activities"	6 "F - Construction"	7 "G - Wholesale and retail trade; repair of motor vehicles and motorcycles"	8 "H - Transportation and storage" ///
                                         9 "I - Accommodation and food service activities"	10 "J - Information and communication"	11 "K - Financial and insurance activities"	12 "L - Real estate activities" ///
                                         13 "M - Professional, scientific and technical activities"	14 "N - Administrative and support service activities"	15 "O - Public administration and defence; compulsory social security"	16 "P - Education" ///
                                         17 "Q - Human health and social work activities"	18 "R - Arts, entertainment and recreation"	19 "S - Other service activities"	20 "T - Activities of households as employers; undifferentiated goods- and services-producing activities of households for own use" ///
                                         21 "U - Activities of extraterritorial organizations and bodies"	22 "X - Not elsewhere classified"		
  	  		    lab val ilo_job1_eco_isic4 eco_isic4_1digit
			    lab var ilo_job1_eco_isic4 "Economic activity (ISIC Rev. 4) - main job"
				
				


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
			   lab var ilo_job1_eco_aggregate "Economic activity (Aggregate) - main job"
				
capture drop todrop*
		
		*****************************************************
	gen todrop0=substr(s6e_35a,1,3)
	* there are (very few) observations that do not match ISIC4 due to the use of 999... as not correctly classified
	* there are instances of the code 890.. to describe institutional sector which does not belong in the question
	replace todrop0="" if todrop0=="999"
	replace todrop0="" if todrop0=="890"
	
	destring todrop0, generate(todrop1) force
	gen todrop2=substr(todrop0,1,2) if todrop1!=.
	gen todrop3=substr(todrop0,1,1) if todrop1==.&s6e_35a!=""
	destring todrop2, generate(todrop4)	
	
							
		* Secondary activity
		
		gen ilo_job2_eco_isic4_2digits=todrop4 if (ilo_lfs==1)
                * labels already defined for main job
		        lab val ilo_job2_eco_isic4_2digits eco_isic4_2digits
                lab var ilo_job2_eco_isic4_2digits "Economic activity (ISIC Rev. 4), 2 digits level - second job"
				
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
                * labels already defined for main job
		        lab val ilo_job2_eco_isic4 eco_isic4_1digit
			    lab var ilo_job2_eco_isic4 "Economic activity (ISIC Rev. 4) - second job"
				
				*** Additional recoding due to the availability of only division level
replace ilo_job2_eco_isic4 = 1 if todrop3 =="A"
replace ilo_job2_eco_isic4 = 2 if todrop3 =="B"
replace ilo_job2_eco_isic4 = 3 if todrop3 =="C"
replace ilo_job2_eco_isic4 = 4 if todrop3 =="D"
replace ilo_job2_eco_isic4 = 5 if todrop3 =="E"
replace ilo_job2_eco_isic4 = 6 if todrop3 =="F"
replace ilo_job2_eco_isic4 = 7 if todrop3 =="G"
replace ilo_job2_eco_isic4 = 8 if todrop3 =="H"
replace ilo_job2_eco_isic4 = 9 if todrop3 =="I"
replace ilo_job2_eco_isic4 = 10 if todrop3 =="J"
replace ilo_job2_eco_isic4 = 11 if todrop3 =="K"
replace ilo_job2_eco_isic4 = 12 if todrop3 =="L"
replace ilo_job2_eco_isic4 = 13 if todrop3 =="M"
replace ilo_job2_eco_isic4 = 14 if todrop3 =="N"
replace ilo_job2_eco_isic4 = 15 if todrop3 =="O"
replace ilo_job2_eco_isic4 = 16 if todrop3 =="P"
replace ilo_job2_eco_isic4 = 17 if todrop3 =="Q"
replace ilo_job2_eco_isic4 = 18 if todrop3 =="R"
replace ilo_job2_eco_isic4 = 19 if todrop3 =="S"
replace ilo_job2_eco_isic4 = 20 if todrop3 =="T"
replace ilo_job2_eco_isic4 = 21 if todrop3 =="U"
replace ilo_job2_eco_isic4 = 22 if todrop3 =="X"
replace ilo_job2_eco_isic4 =. if (ilo_lfs!=1 | ilo_mjh!=2)
		* Secondary activity
		
		gen ilo_job2_eco_aggregate=.
			replace ilo_job2_eco_aggregate=1 if ilo_job2_eco_isic4==1
			replace ilo_job2_eco_aggregate=2 if ilo_job2_eco_isic4==3
			replace ilo_job2_eco_aggregate=3 if ilo_job2_eco_isic4==6
			replace ilo_job2_eco_aggregate=4 if inlist(ilo_job2_eco_isic4,2,4,5)
			replace ilo_job2_eco_aggregate=5 if inrange(ilo_job2_eco_isic4,7,14)
			replace ilo_job2_eco_aggregate=6 if inrange(ilo_job2_eco_isic4,15,21)
			replace ilo_job2_eco_aggregate=7 if ilo_job2_eco_isic4==22
               * labels already defined for main job
	           lab val ilo_job2_eco_aggregate eco_aggr_lab
			   lab var ilo_job2_eco_aggregate "Economic activity (Aggregate) - second job"	
drop todrop*

**** Removing two digit measures - (Ensure consistency - non missing values)
drop ilo_job1_eco_isic4_2digits ilo_job2_eco_isic4_2digits



* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_ocu') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
		/* Classification used: ISCO 08  */
		
		
		
	gen todrop0=substr(s6b_11a,1,3)
	* there are (very few) observations that do not match 
	replace todrop0="" if todrop0=="999"
	replace todrop0="" if todrop0=="970"
	
	gen todrop1=substr(todrop0,2,2)
	gen todrop2=substr(todrop0,1,2) if todrop1!=""
	gen todrop3=substr(todrop0,1,1) if todrop1==""&s6b_11a!=""
	destring todrop2, generate(todrop4)
	destring todrop3, generate(todrop5)

	* MAIN JOB:	
	
		* ISCO 08 - 2 digit
			gen ilo_job1_ocu_isco08_2digits=todrop4 if (ilo_lfs==1)
		        lab def ocu_isco08_2digits 1 "01 - Commissioned armed forces officers"	2 "02 - Non-commissioned armed forces officers"	3 "03 - Armed forces occupations, other ranks"	11 "11 - Chief executives, senior officials and legislators"	///
                                           12 "12 - Administrative and commercial managers"	13 "13 - Production and specialised services managers"	14 "14 - Hospitality, retail and other services managers"	21 "21 - Science and engineering professionals"	///
                                           22 "22 - Health professionals"	23 "23 - Teaching professionals"	24 "24 - Business and administration professionals"	25 "25 - Information and communications technology professionals"	///
                                           26 "26 - Legal, social and cultural professionals"	31 "31 - Science and engineering associate professionals"	32 "32 - Health associate professionals"	33 "33 - Business and administration associate professionals"	///
                                           34 "34 - Legal, social, cultural and related associate professionals"	35 "35 - Information and communications technicians"	41 "41 - General and keyboard clerks"	42 "42 - Customer services clerks"	///
                                           43 "43 - Numerical and material recording clerks"	44 "44 - Other clerical support workers"	51 "51 - Personal service workers"	52 "52 - Sales workers"	///
                                           53 "53 - Personal care workers"	54 "54 - Protective services workers"	61 "61 - Market-oriented skilled agricultural workers"	62 "62 - Market-oriented skilled forestry, fishery and hunting workers"	///
                                           63 "63 - Subsistence farmers, fishers, hunters and gatherers"	71 "71 - Building and related trades workers, excluding electricians"	72 "72 - Metal, machinery and related trades workers"	73 "73 - Handicraft and printing workers"	///
                                           74 "74 - Electrical and electronic trades workers"	75 "75 - Food processing, wood working, garment and other craft and related trades workers"	81 "81 - Stationary plant and machine operators"	82 "82 - Assemblers"	///
                                           83 "83 - Drivers and mobile plant operators"	91 "91 - Cleaners and helpers"	92 "92 - Agricultural, forestry and fishery labourers"	93 "93 - Labourers in mining, construction, manufacturing and transport"	///
                                           94 "94 - Food preparation assistants"	95 "95 - Street and related sales and service workers"	96 "96 - Refuse workers and other elementary workers"		
	            lab values ilo_job1_ocu_isco08_2digits ocu_isco08_2digits
	            lab var ilo_job1_ocu_isco08_2digits "Occupation (ISCO-08), 2 digit level - main job"
		
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
				replace ilo_job1_ocu_isco08=11 if (ilo_job1_ocu_isco08_2digits==. & ilo_lfs==1)
				** Additional to capture division level data
				replace ilo_job1_ocu_isco08=todrop5 if todrop5!=.&ilo_job1_ocu_isco08==11&todrop5!=0&ilo_lfs==1
				replace ilo_job1_ocu_isco08=10 if ilo_job1_ocu_isco08==11&todrop5==0&ilo_lfs==1
					lab def ocu_isco08_1digit 1 "1 - Managers"	2 "2 - Professionals"	3 "3 - Technicians and associate professionals"	4 "4 - Clerical support workers"	///
                                          5 "5 - Service and sales workers"	6 "6 - Skilled agricultural, forestry and fishery workers"	7 "7 - Craft and related trades workers"	8 "8 - Plant and machine operators, and assemblers"	///
                                          9 "9 - Elementary occupations"	10 "0 - Armed forces occupations"	11 "X - Not elsewhere classified"		
					lab val ilo_job1_ocu_isco08 ocu_isco08_1digit
					lab var ilo_job1_ocu_isco08 "Occupation (ISCO-08) - main job"

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
					lab var ilo_job1_ocu_aggregate "Occupation (Aggregate) - main job"	
					
					
		* Skill level
		recode ilo_job1_ocu_isco08 (1/3=3) (4/8=2) (9=1) (10/11=4) ,gen(ilo_job1_ocu_skill)
				lab def ocu_skill_lab 1 "1 - Skill level 1 (low)" 2 "2 - Skill level 2 (medium)" 3 "3 - Skill levels 3 and 4 (high)" 4 "4 - Not elsewhere classified"
			    lab val ilo_job1_ocu_skill ocu_skill_lab
			    lab var ilo_job1_ocu_skill "Occupation (Skill level) - main job"
				
	drop todrop*

	* SECOND JOB:
	* not available
	

**** Removing two digit measures - (Ensure consistency - non missing values)
drop ilo_job1_ocu_isco08_2digits


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_job1_ins_sector')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
	
	
	* if the respondant does not know the variable is not defined - NGO's are set in private
		gen ilo_job1_ins_sector=.
			replace ilo_job1_ins_sector=1 if (inlist(s6b_17,1,2,6) & ilo_lfs==1)	// Public
			replace ilo_job1_ins_sector=2 if (inlist(s6b_17,3,4,5) & ilo_lfs==1)	// Private
			* forcing self employed and domestic workers to private
			replace ilo_job1_ins_sector=2 if (s6b_16>2 &s6b_16!=.& ilo_lfs==1)
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
		
	/* Useful questions:
	
		Missing:
		
		Destination of production
		Produces for sale
		Social security or pension fund
	
		For SE, OAW, CFW

	
		For all employed persons
		s6b_17 Institutional Sector
		s6b_18 Registered business
		s6b_19 Work Place
		s6b_20 Number of Workers in the work place
		
		
		For employees
		
		s6c_29a entitled paid vacation leave
		s6c_29b paid sick leave
	*/
	
	*** Generating the nodes, From left to right 1 directs to first direction in the diagram (usually formal), 0 to the second (usually informal), and -1 if aplicable to the third one. Only unique paths)
	* NOTE! : destination of production, place of work, and bookeeping are not present in the survey, the nodes are set apropiately to follow definition
	* Note that the definition are meant to work with both informal sector and economy
	
	*** Preparing necessary variables - the variables must be adjusted to fit the data
	
	recode s6b_17 (1 2 3 5 6=1) (4 =0) (-9999=-1), gen(todrop_institutional) 		// theoretical 3 value node/ +1 Gov, Corporation, NGO, Embassy, IO / 0 Farm or private business, other, not asked, don't know, NA / -1 private household
	replace todrop_institutional=-1 if s6b_16==8									// Household sector identified in the status in employment question
	replace todrop_institutional=0 if todrop_institutional==. 						// if the absence of the created variable is due to complete absence informality should not be computed
	
	gen todrop_destinationprod=1 													// theoretical 2 value node / +1 At least partially market or Other, Not asked, Don't Know, NA/  0 Only for own final use (household) 
	
	gen todrop_bookkeeping=0 														// theoretical 2 value node/ +1 keeps accounts for GOV/ 0 does not keep accounts or personal use or other, not asked, DK, NA  
	
	gen todrop_registration=1 if (s6b_18<3) 										// theoretical 3 value node/ +1 registered national level/ 0 not registered national level, other, DK / 0 not asked NA
		replace todrop_registration=0 if (s6b_18==3|s6b_18==4)&todrop_registration!=1
		replace todrop_registration=-1 if todrop_registration==.
		
	gen todrop_SS=1 if 10==1  														// theoretical 3 value node/ +1 Social security/ 0 Other, Not asked; NA/ -1 No social security or don't know
		replace todrop_SS=-1 if 10==1
		replace todrop_SS=0 if todrop_SS==.
		
	gen todrop_place=1 	if inlist(s6b_19,2,4)										// theoretical 2 value node/ +1 fixed visible premises / 0 non fixed premises 
		replace todrop_place=0 if s6b_19!=2&s6b_19!=4
		
	gen todrop_size=1 if s6b_20>=6&s6b_20!=.										// theoretical 2 value node/ +1 equal or more than 6 workers / 0 less than 6 workers
		replace todrop_size=0 if s6b_20<5
		
	gen todrop_paidleave=1 if s6c_29a==1											// theoretical 2 value node/ +1 paid leave / 0 no paid leave, not asked , DK, NA
		replace todrop_paidleave=0 if todrop_paidleave==.
		
	gen todrop_paidsick=1 if s6c_29b==1											// theoretical 2 value node/ +1 sick leave / 0 no sick leave, not asked, DK, NA
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

			replace ilo_job1_ife_prod=1 if ilo_lfs==1&ilo_job1_ife_prod==.
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
			replace ilo_job1_ife_nature=1 if ilo_lfs==1&ilo_job1_ife_nature==.
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
		
* nodata

		
* 2) Weekly hours USUALLY worked 
	gen todrop=s6b_23m/60
	egen todrop_hours=rowtotal(todrop s6b_23h )
			gen ilo_job1_how_usual=s6b_22*todrop_hours if ilo_lfs==1
			replace ilo_job1_how_usual=0 if ilo_job1_how_usual==.&ilo_lfs==1
					lab var ilo_job1_how_usual "Weekly hours usually worked in main job"
	drop todrop*

* Second job: 

* 1) Weekly hours ACTUALLY worked:

*no data
		

* 2) Weekly hours USUALLY worked
	gen todrop=s6e_39bm/60
	egen todrop_hours=rowtotal(todrop s6e_39bh )
			gen ilo_job2_how_usual=s6e_39a*todrop_hours if (ilo_mjh==2&ilo_lfs==1)
			replace ilo_job2_how_usual=0 if ilo_job2_how_usual==.&(ilo_mjh==2&ilo_lfs==1)
				lab var ilo_job2_how_usual "Weekly hours usually worked in second job"
	drop todrop*
* All jobs:
		
* 1) Weekly hours ACTUALLY worked:

*no data


* 2) Weekly hours USUALLY worked 
			egen ilo_joball_how_usual=rowtotal(ilo_job1_how_usual ilo_job2_how_usual) if (ilo_lfs==1)
				replace ilo_joball_how_usual=. if ilo_joball_how_usual>168
				lab var ilo_joball_how_usual "Weekly hours usually worked in all jobs"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job1_job_time') <- Moved here to be able to use the computed hours
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			

	/* Threshold of 40 hours per week	*/

			gen ilo_job1_job_time=.
				replace ilo_job1_job_time=1 if (ilo_job1_how_usual<40 & ilo_lfs==1) 	// Part-time
				replace ilo_job1_job_time=2 if (ilo_job1_how_usual>39&ilo_job1_how_usual!=. & ilo_lfs==1)	// Full-time
				replace ilo_job1_job_time=3 if (ilo_job1_how_usual==. & ilo_lfs==1)	// Unknown
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
						replace ilo_job1_lri_ees=s6c_25a*30.4375 if (s6c_25b==1 & ilo_job1_ste_aggregate==1)
						replace ilo_job1_lri_ees=s6c_25a*4.33 if (s6c_25b==2 & ilo_job1_ste_aggregate==1)
						replace ilo_job1_lri_ees=s6c_25a*4.33/2 if (s6c_25b==3 & ilo_job1_ste_aggregate==1)
						replace ilo_job1_lri_ees=s6c_25a if (s6c_25b==4 & ilo_job1_ste_aggregate==1)
						replace ilo_job1_lri_ees=s6c_25a/2 if (s6c_25b==5 & ilo_job1_ste_aggregate==1)
						replace ilo_job1_lri_ees=s6c_25a/3 if (s6c_25b==6 & ilo_job1_ste_aggregate==1)
						replace ilo_job1_lri_ees=s6c_25a/6 if (s6c_25b==7 & ilo_job1_ste_aggregate==1)
						replace ilo_job1_lri_ees=s6c_25a/12 if (s6c_25b==8 & ilo_job1_ste_aggregate==1)
							lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"	
				
				* Self-employed
					gen ilo_job1_lri_slf=.
						replace ilo_job1_lri_slf=s6d_33a*30.4375 if (s6d_33b==1 & inlist(ilo_job1_ste_icse93,2,3,4,6))
						replace ilo_job1_lri_slf=s6d_33a*4.33 if (s6d_33b==2 & inlist(ilo_job1_ste_icse93,2,3,4,6))
						replace ilo_job1_lri_slf=s6d_33a*4.33/2 if (s6d_33b==3 & inlist(ilo_job1_ste_icse93,2,3,4,6))
						replace ilo_job1_lri_slf=s6d_33a if (s6d_33b==4 & inlist(ilo_job1_ste_icse93,2,3,4,6))
						replace ilo_job1_lri_slf=s6d_33a/2 if (s6d_33b==5 &inlist(ilo_job1_ste_icse93,2,3,4,6))
						replace ilo_job1_lri_slf=s6d_33a/3 if (s6d_33b==6 & inlist(ilo_job1_ste_icse93,2,3,4,6))
						replace ilo_job1_lri_slf=s6d_33a/6 if (s6d_33b==7 & inlist(ilo_job1_ste_icse93,2,3,4,6))
						replace ilo_job1_lri_slf=s6d_33a/12 if (s6d_33b==8 & inlist(ilo_job1_ste_icse93,2,3,4,6))
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
		*new definition
			replace ilo_joball_tru=1 if ilo_joball_how_usual<35 & s6g_46==1 &s6g_47==1 & ilo_lfs==1
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
		replace ilo_cat_une=1 if (s6a_07==1&ilo_lfs==2)
		replace ilo_cat_une=2 if (s6a_07==2&ilo_lfs==2)
		replace ilo_cat_une=3 if (ilo_cat_une==.&ilo_lfs==2)
				lab def ilo_cat_une 1 "Unemployed previously employed" 2 "Unemployed seeking first job" 3 "Unknown"
				lab val ilo_cat_une ilo_cat_une
				lab var ilo_cat_une "Category of unemployment"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen todrop=s6a_08a if s6a_08b==4
		replace todrop=s6a_08a/4.33 if s6a_08b==2
		replace todrop=s6a_08a*12 if s6a_08b==8
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
	drop todrop

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

	****** No information available in the questionnaire ******
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu_isco88')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

	****** No information available in the questionnaire ******
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
		replace ilo_olf_dlma = 1 if (s6a_04==2&s6a_05==1)&ilo_lfs==3							 	//Seeking, not available
		replace ilo_olf_dlma = 2 if (s6a_04==1&s6a_05==2)&ilo_lfs==3								//Not seeking, available
		*replace ilo_olf_dlma = 3  EMPTY because willing and available are in the same question	//Not seeking, not available, willing
		replace ilo_olf_dlma = 4 if (s6a_04==2&s6a_05==2)&ilo_lfs==3			//Not seeking, not available, not willing
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

	gen ilo_olf_reason=.
		replace ilo_olf_reason=1 if	(inlist(s6a_10,3,4) & ilo_lfs==3)&s6a_05==2					//Labour market
		replace ilo_olf_reason=2 if	(inlist(s6a_10,1,2,5) & ilo_lfs==3)&s6a_05==2					//Other Labour market
		replace ilo_olf_reason=3 if	(inlist(s6a_10,6,7,8,9,11)  & ilo_lfs==3)&s6a_05==2							//Personal/Family-related
		replace ilo_olf_reason=4 if (inlist(s6a_10,10)  & ilo_lfs==3)&s6a_05==2							//Does not need/want to work
		replace ilo_olf_reason=5 if (inlist(s6a_10,12)  & ilo_lfs==3)&s6a_05==2							//Not elsewhere classified
		replace ilo_olf_reason=5 if (ilo_olf_reason==. & ilo_lfs==3)&s6a_05==2								//Not elsewhere classified
			lab def reasons_lab 1 "1 - Labour market" 2 "2 - Other labour market reasons" 3 "3 - Personal / Family-related" 4 "4 - Does not need/want to work" 5 "5 - Not elsewhere classified"
			lab val ilo_olf_reason reasons_lab 
			lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"
			
			

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seeker ('ilo_dis')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

	gen ilo_dis=1 if s6a_05==2& ilo_olf_reason==1
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
