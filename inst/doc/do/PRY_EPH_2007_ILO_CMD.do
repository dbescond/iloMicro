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
global country "PRY"
global source "EPH"
global time "2007"
global inputFile "R02_EPH2007.dta"

global inpath "${path}\\${country}\\${source}\\${time}\ORI"
global temppath "${path}\_Admin"
global outpath "${path}\\${country}\\${source}\\${time}"

********************************************************************************
********************************************************************************

cd "$inpath"
	use ${inputFile}, clear
	*renaming everything in lower case
	rename *, lower  
		
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
****** Harmonizing


if ${time} ==2007  {


 
rename fex aux_weight
rename area aux_geo
rename p06 aux_sex
rename p02 aux_age
rename ed54 aux_edu_code_de
rename ed06 aux_phd
rename ed08 aux_attendance
rename a02 aux_emp_anywork
rename a04 aux_emp_timework
rename a03 aux_emp_togoback
rename a05 aux_une_available
rename a07 aux_une_sought
rename b31 aux_mjh
rename b14 aux_ste
rename b02rec aux_eco_j1
rename c02rec aux_eco_j2
rename b01rec aux_ocu_j1
rename b17 aux_corporate
rename b16 aux_registration
rename b10 aux_SS
rename b03lu aux_hours_1
rename b03ma aux_hours_2
rename b03mi aux_hours_3
rename b03ju aux_hours_4
rename b03vi aux_hours_5
rename b03sa aux_hours_6
rename b03do aux_hours_7
rename b06 aux_usual
rename c03 aux_hours_job2
rename c15 aux_hours_rest
rename b20t aux_ee_inc
rename e01aimde aux_se_inc
rename d01 aux_tru_avail
rename d05 aux_tru_sought
rename a12 aux_cat_une
rename a11m aux_une_dur_m
rename a11a aux_une_dur_y
rename a11s aux_une_dur_w
rename a13rec aux_prevocu



*** additionals
rename a14rec aux_preveco

	

	* Numerical adjustments
	replace aux_usual=. if aux_usual==0
	replace aux_hours_job2=. if aux_hours_job2==0
	replace aux_hours_rest=.  if aux_hours_rest==0
	replace aux_attendance = aux_attendance + 8

}


if ${time} ==2006  {
rename fex aux_weight
rename area aux_geo
rename p06 aux_sex
rename p02 aux_age
rename ed54 aux_edu_code_de

rename ed08 aux_attendance
rename a02 aux_emp_anywork
rename a04 aux_emp_timework
rename a03 aux_emp_togoback
rename a06 aux_une_available
rename a07 aux_une_sought
rename b23 aux_mjh
rename b11 aux_ste
rename b02rec aux_eco_j1
rename c02rec aux_eco_j2
rename b01rec aux_ocu_j1

rename b09 aux_SS
rename b03lu aux_hours_1
rename b03ma aux_hours_2
rename b03mi aux_hours_3
rename b03ju aux_hours_4
rename b03vi aux_hours_5
rename b03sa aux_hours_6
rename b03do aux_hours_7
rename b06 aux_usual
rename c03 aux_hours_job2
rename c11 aux_hours_rest
rename b12t aux_ee_inc
rename e01aimde aux_se_inc
rename d01 aux_tru_avail
rename d05 aux_tru_sought
rename a12 aux_cat_une
rename a11m aux_une_dur_m
rename a11a aux_une_dur_y
rename a11s aux_une_dur_w
rename a13rec aux_prevocu



*** additionals
rename a14rec aux_preveco


*Not Available Variables
gen aux_corporate=.
gen aux_registration=.


	* Numerical adjustments
	replace aux_usual=. if aux_usual==0
	replace aux_hours_job2=. if aux_hours_job2==0
	replace aux_hours_rest=.  if aux_hours_rest==0
	replace aux_edu_code_de=aux_edu_code_de+500 if inrange(aux_edu_code_de,1101,1406)
		replace aux_edu_code_de=aux_edu_code_de+100 if inrange(aux_edu_code_de,801,1004)
	gen aux_phd=6+ed06
	replace aux_attendance = aux_attendance +10
	replace aux_ste = aux_ste - 2 if aux_ste>2
}

if ${time} ==2005  {
rename fex aux_weight
rename area aux_geo
rename p06 aux_sex
rename p02 aux_age
rename ed54 aux_edu_code_de

rename ed08 aux_attendance
rename a02 aux_emp_anywork
rename a04 aux_emp_timework
rename a03 aux_emp_togoback
rename a12 aux_une_available
rename a13 aux_une_sought
rename b23 aux_mjh
rename b12 aux_ste
rename b02rec aux_eco_j1
rename c02rec aux_eco_j2
rename b01rec aux_ocu_j1

rename b10 aux_SS
rename b03lu aux_hours_1
rename b03ma aux_hours_2
rename b03mi aux_hours_3
rename b03ju aux_hours_4
rename b03vi aux_hours_5
rename b03sa aux_hours_6
rename b03do aux_hours_7
rename b06 aux_usual
rename c03 aux_hours_job2
rename c10 aux_hours_rest
rename b13t aux_ee_inc
rename e01aimde aux_se_inc

rename a06 aux_cat_une
rename a16m aux_une_dur_m
rename a16a aux_une_dur_y
rename a16s aux_une_dur_w
rename a07rec aux_prevocu
rename a08rec aux_preveco

*Not Available Variables
gen aux_corporate=.
gen aux_registration=.


	* Numerical adjustments
	replace aux_usual=. if aux_usual==0
	replace aux_hours_job2=. if aux_hours_job2==0
	replace aux_hours_rest=.  if aux_hours_rest==0

	replace aux_edu_code_de=aux_edu_code_de+500 if inrange(aux_edu_code_de,1101,1406)
		replace aux_edu_code_de=aux_edu_code_de+100 if inrange(aux_edu_code_de,801,1004)
gen aux_phd=.
	replace aux_attendance = aux_attendance +10
	replace aux_ste = aux_ste - 2 if aux_ste>2

}


if ${time} ==2004  {
rename fex aux_weight
rename area aux_geo
rename p06 aux_sex
rename p02 aux_age
rename ed43 aux_edu_code_de

rename ed07 aux_attendance
rename a02 aux_emp_anywork
rename a04 aux_emp_timework
rename a03 aux_emp_togoback
rename a12 aux_une_available
rename a13 aux_une_sought
rename b22 aux_mjh
rename b12 aux_ste
rename b02rec aux_eco_j1
rename c02rec aux_eco_j2
rename b01rec aux_ocu_j1

rename b10 aux_SS
rename b03lu aux_hours_1
rename b03ma aux_hours_2
rename b03mi aux_hours_3
rename b03ju aux_hours_4
rename b03vi aux_hours_5
rename b03sa aux_hours_6
rename b03do aux_hours_7
rename b06 aux_usual
rename c03 aux_hours_job2
rename c10 aux_hours_rest
rename b13t aux_ee_inc
rename e01aimde aux_se_inc

rename a06 aux_cat_une
rename a16m aux_une_dur_m
rename a16a aux_une_dur_y
rename a16s aux_une_dur_w
rename a07rec aux_prevocu
rename a08rec aux_preveco

*Not Available Variables
gen aux_corporate=.
gen aux_registration=.


	* Numerical adjustments
	replace aux_usual=. if aux_usual==0
	replace aux_hours_job2=. if aux_hours_job2==0
	replace aux_hours_rest=.  if aux_hours_rest==0

	replace aux_edu_code_de=aux_edu_code_de+500 if inrange(aux_edu_code_de,1101,1406)
		replace aux_edu_code_de=aux_edu_code_de+100 if inrange(aux_edu_code_de,801,1004)
gen aux_phd=.
	replace aux_attendance = aux_attendance +10
	replace aux_ste = aux_ste - 2 if aux_ste>2

}

if ${time} ==2003  {
rename fex aux_weight
rename area aux_geo
rename p06 aux_sex
rename p02 aux_age
rename ed43 aux_edu_code_de

rename ed11 aux_attendance
rename a02 aux_emp_anywork
rename a04 aux_emp_timework
rename a03 aux_emp_togoback
rename a12 aux_une_available
rename a13 aux_une_sought
rename b22 aux_mjh
rename b12 aux_ste
rename b02rec aux_eco_j1
rename c02rec aux_eco_j2
rename b01rec aux_ocu_j1

rename b10 aux_SS
rename b03lu aux_hours_1
rename b03ma aux_hours_2
rename b03mi aux_hours_3
rename b03ju aux_hours_4
rename b03vi aux_hours_5
rename b03sa aux_hours_6
rename b03do aux_hours_7
rename b06 aux_usual
rename c03 aux_hours_job2
rename c10 aux_hours_rest
rename b13t aux_ee_inc
rename e01aimde aux_se_inc

rename a06 aux_cat_une
rename a16m aux_une_dur_m
rename a16a aux_une_dur_y
rename a16s aux_une_dur_w
rename a07rec aux_prevocu
rename a08rec aux_preveco

*Not Available Variables
gen aux_corporate=.
gen aux_registration=.


	* Numerical adjustments
	replace aux_usual=. if aux_usual==0
	replace aux_hours_job2=. if aux_hours_job2==0
	replace aux_hours_rest=.  if aux_hours_rest==0

	replace aux_edu_code_de=aux_edu_code_de+500 if inrange(aux_edu_code_de,1101,1406)
		replace aux_edu_code_de=aux_edu_code_de+100 if inrange(aux_edu_code_de,801,1004)
gen aux_phd=.
	replace aux_attendance = aux_attendance + 10 - 2
	replace aux_ste = aux_ste - 2 if aux_ste>2

}


if ${time} <=2002  {
rename fex aux_weight
rename area aux_geo
rename p06 aux_sex
rename p02 aux_age
gen todrop_aux_edu= ed43
gen aux_edu_code_de=.

rename ed07 aux_attendance
rename a02 aux_emp_anywork
rename a04 aux_emp_timework
rename a03 aux_emp_togoback
rename a12 aux_une_available
rename a13 aux_une_sought
rename b22 aux_mjh
rename b12 aux_ste
rename b02rec aux_eco_j1
rename c02rec aux_eco_j2
rename b01rec aux_ocu_j1

rename b10 aux_SS
rename b03lu aux_hours_1
rename b03ma aux_hours_2
rename b03mi aux_hours_3
rename b03ju aux_hours_4
rename b03vi aux_hours_5
rename b03sa aux_hours_6
rename b03do aux_hours_7
rename b06 aux_usual
rename c03 aux_hours_job2
rename c10 aux_hours_rest
rename b13t aux_ee_inc
rename e01aimde aux_se_inc

rename a06 aux_cat_une
rename a16m aux_une_dur_m
rename a16a aux_une_dur_y
rename a16s aux_une_dur_w
rename a07rec aux_prevocu
rename a08rec aux_preveco

*Not Available Variables
gen aux_corporate=.
gen aux_registration=.
gen aux_phd=.

	* Numerical adjustments
	replace aux_usual=. if aux_usual==0
	replace aux_hours_job2=. if aux_hours_job2==0
	replace aux_hours_rest=.  if aux_hours_rest==0

	replace aux_attendance = . if aux_attendance==0
	replace aux_attendance = aux_attendance + 10 + 2
	
	replace aux_ste = aux_ste - 2 if aux_ste>2
	
	
	
replace aux_edu =0 if todrop_aux_edu ==0
replace aux_edu =101 if todrop_aux_edu ==88
replace aux_edu =211 if todrop_aux_edu ==100
replace aux_edu =301 if todrop_aux_edu ==201
replace aux_edu =302 if todrop_aux_edu ==202
replace aux_edu =303 if todrop_aux_edu ==203
replace aux_edu =304 if todrop_aux_edu ==204
replace aux_edu =305 if todrop_aux_edu ==205
replace aux_edu =306 if todrop_aux_edu ==206
replace aux_edu =407 if todrop_aux_edu ==207
replace aux_edu =408 if todrop_aux_edu ==208
replace aux_edu =409 if todrop_aux_edu ==209
replace aux_edu =501 if todrop_aux_edu ==301
replace aux_edu =502 if todrop_aux_edu ==302
replace aux_edu =503 if todrop_aux_edu ==303
replace aux_edu =704 if todrop_aux_edu ==404
replace aux_edu =705 if todrop_aux_edu ==405
replace aux_edu =706 if todrop_aux_edu ==406
replace aux_edu =704 if todrop_aux_edu ==504
replace aux_edu =705 if todrop_aux_edu ==505
replace aux_edu =706 if todrop_aux_edu ==506
replace aux_edu =901 if todrop_aux_edu ==604
replace aux_edu =902 if todrop_aux_edu ==605
replace aux_edu =903 if todrop_aux_edu ==606
replace aux_edu =1001 if todrop_aux_edu ==1101
replace aux_edu =1101 if todrop_aux_edu ==1001
replace aux_edu =1102 if todrop_aux_edu ==1002
replace aux_edu =1103 if todrop_aux_edu ==1003
replace aux_edu =1701 if todrop_aux_edu ==701
replace aux_edu =1702 if todrop_aux_edu ==702
replace aux_edu =1703 if todrop_aux_edu ==703
replace aux_edu =1704 if todrop_aux_edu ==704
replace aux_edu =1801 if todrop_aux_edu ==801
replace aux_edu =1802 if todrop_aux_edu ==802
replace aux_edu =1803 if todrop_aux_edu ==803
replace aux_edu =1804 if todrop_aux_edu ==804
replace aux_edu =1901 if todrop_aux_edu ==901
replace aux_edu =1902 if todrop_aux_edu ==902
replace aux_edu =1903 if todrop_aux_edu ==903
replace aux_edu =1904 if todrop_aux_edu ==904
replace aux_edu =1905 if todrop_aux_edu ==905
replace aux_edu =1906 if todrop_aux_edu ==906
replace aux_edu =9999 if todrop_aux_edu ==9999
drop todrop_aux_edu

}

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

	gen ilo_wgt=aux_weight
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
		replace ilo_geo=1 if aux_geo==1
		replace ilo_geo=2 if aux_geo==6
			lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural"
			lab val ilo_geo ilo_geo_lab
			lab var ilo_geo "Geographical coverage"	

			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_sex=aux_sex if aux_sex==1
		replace ilo_sex=2 if aux_sex==6
		lab def ilo_sex_lab 1 "1 - Male" 2 "2 - Female"
		lab var ilo_sex "Sex"
		lab val ilo_sex ilo_sex_lab


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_age=aux_age
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
					file:file:///J:\DPAU\MICRO\PRY\HS\2015\ORI\paraguay_isced_mapping_0.xls	
The question aux_edu_phd has been used as well in conjunction with the file above to determine the cuttofs for superior education
For doctorates it is explicitly used					
					
*/

** ISCED97
recode aux_edu_code_de (0 = 1) (188=2) (101 = 2) (102 = 2) (103 = 2) (104 = 2) (105 = 2) (106 = 3) (210 = 2) (211/212 = 2) (301 = 2) (302 = 2) (303 = 2) (304 = 2) (305 = 2) (306 = 3) (407 = 3) (408 = 3) (409 = 4) (501 = 3) (502 = 3) (503 = 4) (604 = 4) (605 = 4) (606 = 5) (704 = 4) (705 = 4) (706 = 5) (901 = 4) (902 = 4) (903 = 5) (1001 = 4) (1002 = 4) (1003 = 5) (1101 = 2) (1102 = 2) (1103 = 3) (1104 = 3) (1201 = 4) (1202 = 4) (1203 = 5) (1301 = 4) (1302 = 4) (1303 = 5) (1400 = 2) (1500 = 2) (1601 = 5) (1602 = 5) (1603 = 7) (1701 = 5) (1702 = 5) (1703 = 7) (1704 = 7) (1801 = 5) (1802 = 5) (1803 = 7) (1804 = 7) (1901 = 5) (1902 = 5) (1903 = 5) (1904 = 7) (1905 = 7) (1906 =-1000) (9999 = 9) (801 = 4) (802 = 4), gen(ilo_edu_isced97)
	replace ilo_edu_isced97=8 if ilo_edu_isced97==-1000&aux_phd==8
	replace ilo_edu_isced97=7 if ilo_edu_isced97==-1000
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
		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education attendance ('ilo_edu_attendance')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------


	gen ilo_edu_attendance=.
		replace ilo_edu_attendance=1 if aux_attendance<20			// Attending
		replace ilo_edu_attendance=2 if aux_attendance==20				// Not attending
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
	    replace ilo_mrts_details=1 if p09==5                                    // Single
		replace ilo_mrts_details=2 if p09==1                                    // Married
		replace ilo_mrts_details=3 if p09==2                                    // Union / cohabiting
		replace ilo_mrts_details=4 if p09==4                                    // Widowed
		replace ilo_mrts_details=5 if inlist(p09,3,6)                           // Divorced / separated
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
* IMPORTANT that respondents that have not sought work because they already found a job and will start
* in the next 30 days should be considered in unemployment, HOWEVER the question is MISSING
* an ilogical condition, 100==1, is placed in its place a09==10 in case the question can be recovered
	gen ilo_lfs=.
		replace ilo_lfs=1 if ((aux_emp_anywork==1 | aux_emp_timework==1 | aux_emp_togoback==1 ) & ilo_wap==1) 	// Employed
		replace ilo_lfs=2 if ilo_wap==1 & ilo_lfs!=1 & (aux_une_available==1 & (aux_une_sought==1 | 100==1) ) 	// Unemployed, Not Working + (Available + Sought Work OR already found work and will start in the next 30 days)
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
		replace ilo_mjh=1 if aux_mjh==6 & ilo_lfs==1
		replace ilo_mjh=2 if aux_mjh==1 & ilo_lfs==1
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
			replace ilo_job1_ste_icse93=1 if (aux_ste<3|aux_ste==6) & ilo_lfs==1		// Employees
			replace ilo_job1_ste_icse93=2 if (aux_ste==3) & ilo_lfs==1		// Employers
			replace ilo_job1_ste_icse93=3 if aux_ste==4 & ilo_lfs==1		// Own-account workers
	// Members of cooperatives
			replace ilo_job1_ste_icse93=5 if aux_ste==5 & ilo_lfs==1		// Contributing family workers
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


	* Classification aggregated level
	
		* Primary activity
		
	gen ilo_job1_eco_aggregate=.
		replace ilo_job1_eco_aggregate=1 if inlist(aux_eco_j1,1,1)
		replace ilo_job1_eco_aggregate=2 if aux_eco_j1==2
		replace ilo_job1_eco_aggregate=3 if aux_eco_j1==4
		replace ilo_job1_eco_aggregate=4 if inlist(aux_eco_j1,3)
		replace ilo_job1_eco_aggregate=5 if inlist(aux_eco_j1,5,6,7)
		replace ilo_job1_eco_aggregate=6 if inlist(aux_eco_j1,8)
		replace ilo_job1_eco_aggregate=7 if ilo_job1_eco_aggregate==.
		replace ilo_job1_eco_aggregate=. if ilo_lfs!=1
			 lab def eco_aggr_lab 1 "1 - Agriculture" 2 "2 - Manufacturing" 3 "3 - Construction" 4 "4 - Mining and quarrying; Electricity, gas and water supply" ///
								     5 "5 - Market Services (Trade; Transportation; Accommodation and food; and Business and administrative services)"  ///
								     6 "6 - Non-market services (Public administration; Community, social and other services and activities)" 7 "7 - Not classifiable by economic activity"					
			lab val ilo_job1_eco_aggregate eco_aggr_lab
			lab var ilo_job1_eco_aggregate "Economic activity (Aggregate) - main job"

		
		*****************************************************
		


		* Secondary activity
		
	gen ilo_job2_eco_aggregate=.
		replace ilo_job2_eco_aggregate=1 if inlist(aux_eco_j2,1,1)
		replace ilo_job2_eco_aggregate=2 if aux_eco_j2==2
		replace ilo_job2_eco_aggregate=3 if aux_eco_j2==4
		replace ilo_job2_eco_aggregate=4 if inlist(aux_eco_j2,3)
		replace ilo_job2_eco_aggregate=5 if inlist(aux_eco_j2,5,6,7)
		replace ilo_job2_eco_aggregate=6 if inlist(aux_eco_j2,8)
		replace ilo_job2_eco_aggregate=7 if ilo_job2_eco_aggregate==.
		replace ilo_job2_eco_aggregate=. if (ilo_lfs!=1|ilo_mjh!=2)
               * labels already defined for main job
	           lab val ilo_job2_eco_aggregate eco_aggr_lab
			   lab var ilo_job2_eco_aggregate "Economic activity (Aggregate) - second job"			

			
				


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_ocu') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
		/* Classification used: ISCO 08  */ 
		*1 digit classification is given directly
	



		
		* ISCO 08 - 1 digit
			gen ilo_job1_ocu_isco08=aux_ocu_j1 if (ilo_lfs==1)
				replace ilo_job1_ocu_isco08=10 if ilo_job1_ocu_isco08==0
				replace ilo_job1_ocu_isco08=11 if (ilo_job1_ocu_isco08==.|ilo_job1_ocu_isco08>10 & ilo_lfs==1)
				replace ilo_job1_ocu_isco08=. if ilo_lfs!=1
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
				



* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_job1_ins_sector')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
	
	
	* if the respondant does not know the variable is not defined - NGO's are set in private
		gen ilo_job1_ins_sector=.
			replace ilo_job1_ins_sector=1 if (inlist(aux_ste,1) & ilo_lfs==1)	// Public
			replace ilo_job1_ins_sector=2 if (inlist(aux_ste,2,3,4,5,6) & ilo_lfs==1)	// Private
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
if ${time} > 2007 {		
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
	
	recode aux_ste ( 1 = 1) (2 3 4 5 9 =0) (6 = -1), gen(todrop_institutional) 		// theoretical 3 value node/ +1 Gov, Corporation, NGO, Embassy, IO / 0 Farm or private business, other, not asked, don't know, NA / -1 private household
								// Household sector identified in the status in employment question
	replace todrop_institutional=0 if todrop_institutional==. 						// if the absence of the created variable is due to complete absence informality should not be computed
	** additionally some can be directed to the corporate sector
	replace todrop_institutional=1 if aux_corporate>1&aux_corporate<5
	
	gen todrop_destinationprod=1 													// theoretical 2 value node / +1 At least partially market or Other, Not asked, Don't Know, NA/  0 Only for own final use (household) 
	
	gen todrop_bookkeeping=0 														// theoretical 2 value node/ +1 keeps accounts for GOV/ 0 does not keep accounts or personal use or other, not asked, DK, NA  
	
	gen todrop_registration=1 if (aux_registration == 1) 										// theoretical 3 value node/ +1 registered national level/ 0 not registered national level, other, DK / 0 not asked NA
		replace todrop_registration=0 if (aux_registration==2|aux_registration==6)&todrop_registration!=1
		replace todrop_registration=-1 if todrop_registration==.
		
	gen todrop_SS=1 if aux_SS==1  														// theoretical 3 value node/ +1 Social security/ 0 Not asked / -1 No social security or don't know NA Other
		replace todrop_SS=-1 if todrop_SS==.
		replace todrop_SS=0 if todrop_SS==.
		
		
	gen todrop_place=.										// theoretical 2 value node/ +1 fixed visible premises / 0 non fixed premises 
		*replace todrop_place=0 if 10==1
		
	gen todrop_size=.										// theoretical 2 value node/ +1 equal or more than 6 workers / 0 less than 6 workers

		
	gen todrop_paidleave=.										// theoretical 2 value node/ +1 paid leave / 0 no paid leave, not asked , DK, NA
		*replace todrop_paidleave=0 if todrop_paidleave==.
		
	gen todrop_paidsick=.									// theoretical 2 value node/ +1 sick leave / 0 no sick leave, not asked, DK, NA
		*replace todrop_paidsick=0 if todrop_paidsick==.
		
	gen todrop_producesforsale=1 													//  theoretical 2 value node / +1 Yes product for sale, Other, Not asked, Don't Know, NA/ 0 No, not for sale 
	
	**** Exception to force non employees without size-place data to informal
	replace todrop_registration = 0 if ilo_lfs==1&todrop_institutional==0&todrop_destinationprod==1&todrop_bookkeeping==0&todrop_registration==-1&ilo_job1_ste_icse93!=1&(todrop_size==.|todrop_place==.)
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
}	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Hours of work ('ilo_job1_how')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

foreach var of varlist aux_hours_1-aux_hours_7 {
	gen HOURS_`var' = int(`var')
	gen MINUTES_`var'=(`var'-HOURS_`var')
	replace MINUTES_`var'=0 if MINUTES_`var'>0.601
	
	replace HOURS_`var'=0 if HOURS_`var'==99
	replace HOURS_`var'=0 if HOURS_`var'==99.99
	replace MINUTES_`var'= MINUTES_`var'/0.60
	
	gen TIME_`var'= HOURS_`var' + MINUTES_`var'
}

egen TOTAL_TIME = rowtotal(TIME_*) 

* Main job:

* 1) Weekly hours ACTUALLY worked - Main job
		
gen ilo_job1_how_actual=TOTAL_TIME if (ilo_lfs==1)
					*to avoid missing values of workers that were temporary absent
					replace ilo_job1_how_actual=0 if ilo_lfs==1&ilo_job1_how_actual==.
					lab var ilo_job1_how_actual "Weekly hours actually worked in main job"
drop TOTAL_TIME TIME_* HOURS_* MINUTES_*


		
* 2) Weekly hours USUALLY worked , notice that it has to be obtained as a differential
			gen ilo_job1_how_usual=aux_usual if ilo_lfs==1&aux_usual<999 
			replace ilo_job1_how_usual=ilo_job1_how_actual if ilo_lfs==1 & ilo_job1_how_usual==.
					lab var ilo_job1_how_usual "Weekly hours usually worked in main job"
					
* Secondary job - actual
			gen ilo_job2_how_actual=aux_hours_job2 if (ilo_mjh==2&ilo_lfs==1)&aux_hours_job2<999
				lab var ilo_job2_how_actual "Weekly hours actually worked in second job"

* Tertiary job - actual
			gen ilo_job3_how_actual=aux_hours_rest if (ilo_mjh==2&ilo_lfs==1)&aux_hours_rest<999
				lab var ilo_job3_how_actual "Weekly hours actually worked in tertiary job"
* All jobs - actual

			egen ilo_joball_how_actual=rowtotal(ilo_job1_how_actual ilo_job2_how_actual ilo_job3_how_actual) if (ilo_lfs==1)
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
				
				* Employees
					gen ilo_job1_lri_ees=aux_ee_inc if (aux_ee_inc<900000000 & ilo_job1_ste_aggregate==1)
						replace ilo_job1_lri_ees=. if ilo_job1_lri_ees==0 
							lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"	
				
				* Self-employed
					gen ilo_job1_lri_slf=aux_se_inc if (aux_se_inc<900000000 & inlist(ilo_job1_ste_icse93,2,3,4,6))
						replace ilo_job1_lri_slf=. if ilo_job1_lri_slf==0
							lab var ilo_job1_lri_slf "Monthly earnings of self-employed in main job"


		
***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_joball_tru') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
if ${time} >= 2006 {
		gen ilo_joball_tru=.
		* notice that willing to work is in this case in the "strong form" of having sought additional work
			replace ilo_joball_tru=1 if ilo_joball_how_actual<35 & aux_tru_avail==1 & aux_tru_sought==1 & ilo_lfs==1
			lab def tru_lab 1 "Time-related underemployment"
			lab val ilo_joball_tru tru_lab
			lab var ilo_joball_tru "Time-related underemployment"	
}

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
		replace ilo_cat_une=1 if (aux_cat_une==1&ilo_lfs==2)
		replace ilo_cat_une=2 if (aux_cat_une==6&ilo_lfs==2)
		replace ilo_cat_une=3 if (ilo_cat_une==.&ilo_lfs==2)
				lab def ilo_cat_une 1 "Unemployed previously employed" 2 "Unemployed seeking first job" 3 "Unknown"
				lab val ilo_cat_une ilo_cat_une
				lab var ilo_cat_une "Category of unemployment"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen todrop1=aux_une_dur_m 
	gen todrop2=aux_une_dur_w/4.33
	gen todrop3=aux_une_dur_y *12
	egen todrop=rowtotal(todrop*)
	replace todrop=. if todrop==0
	
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

	gen ilo_preveco_aggregate=.
		replace ilo_preveco_aggregate=1 if inlist( aux_preveco,1,1)
		replace ilo_preveco_aggregate=2 if  aux_preveco==2
		replace ilo_preveco_aggregate=3 if  aux_preveco==4
		replace ilo_preveco_aggregate=4 if inlist( aux_preveco,3)
		replace ilo_preveco_aggregate=5 if inlist( aux_preveco,5,6,7)
		replace ilo_preveco_aggregate=6 if inlist( aux_preveco,8)
		replace ilo_preveco_aggregate=7 if ilo_preveco_aggregate==.
		replace ilo_preveco_aggregate=. if (ilo_lfs!=2|ilo_cat_une!=1)
                * labels already defined for main job
		        lab val ilo_preveco_aggregate eco_aggr_lab
			    lab var ilo_preveco_aggregate "Previous economic activity (Aggregate)"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu_isco88')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

		* ISCO 08 - 1 digit
			gen ilo_prevocu_isco08=aux_prevocu if ((ilo_lfs==2&ilo_cat_une==1))
				replace ilo_prevocu_isco08=10 if ilo_prevocu_isco08==0
				replace ilo_prevocu_isco08=11 if ((ilo_prevocu_isco08==. | ilo_prevocu_isco08>10) & (ilo_lfs==2&ilo_cat_une==1))
				replace ilo_prevocu_isco08=. if (ilo_lfs!=2|ilo_cat_une!=1)
					* labels already defined for main job
					lab val ilo_prevocu_isco08 ocu_isco08_1digit
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
					* labels already defined for main job
						lab val ilo_prevocu_aggregate ocu_aggr_lab
						lab var ilo_prevocu_aggregate "Previous occupation (Aggregate)"	
					
					
		* Skill level
		recode ilo_prevocu_isco08 (1/3=3) (4/8=2) (9=1) (10/11=4) ,gen(ilo_prevocu_skill)
                * labels already defined for main job
			    lab val ilo_prevocu_skill ocu_skill_lab
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
	*note  (willing is not explicitly defined)
	*additionally reason for not looking is missing, thus the reason for not seeking inlist(a09,2,3,4,8,9,10) cannot be used
	*also missing is the reason for being unavailable
	gen ilo_olf_dlma=.
		*0 BY CONSTRUCTION replace ilo_olf_dlma = 1 if (aux_une_available==6&aux_une_sought==1)&ilo_lfs==3							 	//Seeking, not available
		replace ilo_olf_dlma = 2 if (aux_une_available==1&aux_une_sought==6)&ilo_lfs==3								//Not seeking, available
		*CANNOT BE DONE DUE TO MISSING VARIABLE replace ilo_olf_dlma = 3 if (aux_une_available==6&aux_une_sought==6&inlist(a09,2,3,4,8,9,10) )&ilo_lfs==3  	//Not seeking, not available, willing (Willing non-job seekers) 
		*CANNOT BE DONE DUE TO MISSING VARIABLE replace ilo_olf_dlma = 4 if  aux_une_available==6&aux_une_sought==6&(!inlist(a09,2,3,4,8,9,10) |inlist(a06,1,2,3,4,5,6,7,8,9,10,11) )&ilo_lfs==3			//Not seeking, not available, not willing (Non-Willigness based reasons for not being available) 
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

* Question not available (it is present in the questionaire nevertheless) 

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seeker ('ilo_dis')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		


* Question not available (it is present in the questionaire nevertheless) 

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
