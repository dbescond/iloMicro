* TITLE OF DO FILE: ILO Microdata Preprocessing code template - India
* DATASET USED: India NSS 
* NOTES:
* Authors: ILO / Department of Statistics / DPAU

* Starting Date: 21 September 2017
* Last updated: 08 February 2018
***********************************************************************************************



*******************************************************************
 /* 1.	Set up work directory, file name, variables and function */
*******************************************************************


clear all 

set more off

global path "J:\DPAU\MICRO"
global country "IND"
global source "NSS"
global time "1994"
global inputFile "IND_NSS_${time}_ORI.dta"

global inpath "${path}\\${country}\\${source}\\${time}\ORI"
global temppath "${path}\_Admin"
global outpath "${path}\\${country}\\${source}\\${time}"


*********************************************************************************************

* Load original dataset

*********************************************************************************************

cd "$inpath"

	use "$inputFile", clear	
	
	drop if B4_q4==.  // omit observations for which we don't know the sex
		
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


	/* gen ilo_key=Person_Key
			lab var ilo_key "Key unique identifier per individual"		*/


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sample Weight ('ilo_wgt')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: 	

	gen ilo_wgt=WGT_Pooled
		lab var ilo_wgt "Sample weight"		
		
		* numbers for total working age population coincides with number published on ILOSTAT
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time period ('ilo_time')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: 	This dataset corresponds to 1993-1994
	* Only yearly indicators are produced so this is all going to 1994 for ILOSTAT

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
*			Geographical coverage ('ilo_geo')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	destring Sector, replace
	
	gen ilo_geo=.
		replace ilo_geo=1 if Sector==2
		replace ilo_geo=2 if Sector==1
			lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural" 3 "3 - Not elsewhere classified"
			lab val ilo_geo ilo_geo_lab
			lab var ilo_geo "Geographical coverage"
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

		gen ilo_sex=B4_q4
			label define ilo_sex 1 "Male" 2 "Female"
			label value ilo_sex ilo_sex
			label var ilo_sex "Sex"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

	gen ilo_age=B4_q5
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

* Comment:	Note that graduates are all considered together - ISCED level 5 and 6 are being considered jointly and regarded as ISCED level 5 
	
	gen ilo_edu_isced97=.
		replace ilo_edu_isced97=1 if B4_q7==1
		replace ilo_edu_isced97=2 if inrange(B4_q7,2,5)
		replace ilo_edu_isced97=3 if B4_q7==6
		replace ilo_edu_isced97=4 if inlist(B4_q7,7,8)
		replace ilo_edu_isced97=5 if B4_q7==9
		/* replace ilo_edu_isced97=6 if */
		replace ilo_edu_isced97=7 if inrange(B4_q7,10,13)
		/* replace ilo_edu_isced97=8 if */
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
*			Education attendance ('ilo_edu_attendance')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: 
	
		gen ilo_edu_attendance=.
			replace ilo_edu_attendance=1 if inrange(B4_q9,2,19)
			replace ilo_edu_attendance=2 if B4_q9==1 
			replace ilo_edu_attendance=3 if ilo_edu_attendance==.
				lab def edu_attendance_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
				lab val ilo_edu_attendance edu_attendance_lab
				lab var ilo_edu_attendance "Education (Attendance)"
				
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			           Marital status ('ilo_mrts') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 
	
	* Detailed
	gen ilo_mrts_details=.
	    replace ilo_mrts_details=1 if B4_q6==1                                  // Single
		replace ilo_mrts_details=2 if B4_q6==2                                  // Married
		*replace ilo_mrts_details=3 if                                          // Union / cohabiting
		replace ilo_mrts_details=4 if B4_q6==3                                  // Widowed
		replace ilo_mrts_details=5 if B4_q6==4                                  // Divorced / separated
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

* Comment:	NOT POSSIBLE - No variable indicating disability
*			Maybe Usual_Principal_Activity_Status, 95 - not able to work due to disability



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
			replace ilo_wap=1 if ilo_age>=15 & ilo_age!=.
				label def ilo_wap_lab 1 "Working age population"
				label val ilo_wap ilo_wap_lab
				label var ilo_wap "Working age population" //15+ population

	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Labour Force Status ('ilo_lfs')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: Given that the section capturing information on the usual activities contains more info than the one taking the last 
			* 7 days as reference period, use the variables contained in the "usual principal activity" block (block 5) to define the labour market characteristics
			* However, in green will be left the codes to define the variables for the current activities, in case a future user of the data would prefer to use the latter
			
			* --> The activity status on which a person spent relatively long time (i.e. major time criterion) during the 365 days preceding the date of survey was considered 
					* as the usual principal activity status  

		* --> use precoded variable on the activity status contained in the datafile referring to the principal activity
		
*		Unemployed - pre-categorized: 81 - did not work but was seeking and/or available for work; 
*			Not working but seeking/available for work (or unemployed):
*			81 sought work or did not seek but was available for work (for usual status approach)
*			81 sought work (for current weekly status approach)
*			82 did not seek but was available for work (for current weekly status approach)

	
	gen ilo_lfs=.
		replace ilo_lfs=1 if inrange(B4_q12,11,51) 
		replace ilo_lfs=2 if ilo_lfs!=1 & B4_q12==81
		replace ilo_lfs=3 if !inlist(ilo_lfs,1,2)
			replace ilo_lfs=. if ilo_wap!=1
				label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside the Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status"
	
	
	/*

	gen curr_lfs=.
		replace curr_lfs=1 if inrange(B5_q4_1,11,72) | B5_q4_1==98
		replace curr_lfs=2 if curr_lfs!=1 & B5_q4_1==81
		replace curr_lfs=3 if !inlist(curr_lfs,1,2)
			replace curr_lfs=. if ilo_wap!=1
				label define label_curr_lfs 1 "Employed" 2 "Unemployed" 3 "Outside the Labour Force"
				label value curr_lfs label_curr_lfs
				label var curr_lfs "Labour Force Status"
				 
				*/

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: 	Whether_in_Subsidiary_Activity - 1-yes; 2-no

	gen ilo_mjh=.
		replace ilo_mjh=1 if (B4_q17==2 & ilo_lfs==1)
		replace ilo_mjh=2 if (B4_q17==1 & ilo_lfs==1)
				replace ilo_mjh=. if ilo_lfs!=1
			lab def lab_ilo_mjh 1 "1 - One job only" 2 "2 - More than one job"
			lab val ilo_mjh lab_ilo_mjh
			lab var ilo_mjh "Multiple job holders"	


/* 
	if current activity considered: 
	
		attribute value "more than one job" to people having any observations related to a subsidiary activity during reference week

	gen curr_mjh=.
		replace curr_mjh=1 if B5_q4_2==.
		replace curr_mjh=2 if B5_q4_2!=. & curr_lfs==1
				replace curr_mjh=. if curr_lfs!=1
			lab def lab_curr_mjh 1 "1 - One job only" 2 "2 - More than one job"
			lab val curr_mjh lab_curr_mjh
			lab var curr_mjh "Multiple job holders"	
			
			*/
			

***********************************************************************************************
*			PART 3.1. ECONOMIC CHARACTERISTICS FOR MAIN JOB 
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Status in employment ('ilo_job1_ste')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------


* Comment: 

* Comment: 	Recoding the Usual_principal_activity_status. 	
* Non-Standard codes are the following ones: 
* 41: Worked as casual wage labour: in public works / 51: In other types of work -> Classified as own-account workers as they are casual (and not as employees)
* 81: Did not work but was seeking and/or available for work / 91: Attended educational institution / 92: Attended domestic duties only
* 93: Attended domestic duties and was also engaged in free collection of goods (vegetables, roots, firewood, cattle feed, etc.), sewing, tailoring, weaving, etc. for household use
* 94: Rentiers, pensioners , remittance recipients... / 95: Not able to work due to disability / 97: Others (including begging, prostitution...) 

  * MAIN JOB:
	
	* Detailed categories

	gen ilo_job1_ste_icse93=.
		replace ilo_job1_ste_icse93=1 if (B4_q12==31 & ilo_lfs==1)
		replace ilo_job1_ste_icse93=2 if (B4_q12==12 & ilo_lfs==1)
		replace ilo_job1_ste_icse93=3 if (inlist(B4_q12,11,41,51) & ilo_lfs==1)
		/*replace ilo_job1_ste_icse93=4 if */
		replace ilo_job1_ste_icse93=5 if (B4_q12==21 & ilo_lfs==1)
		replace ilo_job1_ste_icse93=6 if ilo_job1_ste_icse93==. & ilo_lfs==1
				replace ilo_job1_ste_icse93=. if ilo_lfs!=1
			label def label_ilo_ste_icse93 1 "1 - Employees" 2 "2 - Employers" 3 "3 - Own-account workers" 4 "4 - Members of producers cooperatives"  ///
											5 "5 - Contributing family workers" 6 "6 - Workers not classifiable by status"
			label value ilo_job1_ste_icse93 label_ilo_ste_icse93
			label var ilo_job1_ste_icse93 "Status in employment (ICSE 93)"

	* Aggregated categories 
		
		gen ilo_job1_ste_aggregate=.
			replace ilo_job1_ste_aggregate=1 if (ilo_job1_ste_icse93==1)			// Employees
			replace ilo_job1_ste_aggregate=2 if (inrange(ilo_job1_ste_icse93,2,5))	// Self-employed
			replace ilo_job1_ste_aggregate=3 if (ilo_job1_ste_icse93==6)			// Not elsewhere classified
				lab def ste_aggr_lab 1 "1 - Employees" 2 "2 - Self-employed" 3 "3 - Not elsewhere classified"
				lab val ilo_job1_ste_aggregate ste_aggr_lab
				label var ilo_job1_ste_aggregate "Status in employment (Aggregate)"  



/* if current activity considered: 

use the same variable that was used to identify people in employment, as it contains information on the status in employment

	gen curr_job1_ste_icse93=.
		replace curr_job1_ste_icse93=1 if inlist(B5_q4_1,31,71,72)
		replace curr_job1_ste_icse93=2 if B5_q4_1==12
		replace curr_job1_ste_icse93=3 if inlist(B5_q4_1,11,41,42,51)
		/*replace curr_job1_ste_icse93=4 if */
		replace curr_job1_ste_icse93=5 if inlist(B5_q4_1,21,61,62)
		replace curr_job1_ste_icse93=6 if curr_job1_ste_icse93==. & curr_lfs==1
				replace curr_job1_ste_icse93=. if curr_lfs!=1
			label def label_curr_ste_icse93 1 "1 - Employees" 2 "2 - Employers" 3 "3 - Own-account workers" 4 "4 - Members of producers cooperatives"  ///
											5 "5 - Contributing family workers" 6 "6 - Workers not classifiable by status"
			label value curr_job1_ste_icse93 curr_job1_ste_icse93
			label var curr_job1_ste_icse93 "Status in employment (ICSE 93)"

	* Aggregated categories 
		
		gen curr_job1_ste_aggregate=.
			replace curr_job1_ste_aggregate=1 if (curr_job1_ste_icse93==1)			// Employees
			replace curr_job1_ste_aggregate=2 if (inrange(curr_job1_ste_icse93,2,5))	// Self-employed
			replace curr_job1_ste_aggregate=3 if (curr_job1_ste_icse93==6)			// Not elsewhere classified
				lab def ste_aggr_lab 1 "1 - Employees" 2 "2 - Self-employed" 3 "3 - Not elsewhere classified"
				lab val curr_job1_ste_aggregate ste_aggr_lab
				label var curr_job1_ste_aggregate "Status in employment (Aggregate)"  

*/

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

/* Classification used: NIC 1987 (based on ISIC Rev. 2)  - given that the most recent classification considered by us for the microdata pre-processing 
	is ISIC Rev. 3.1, consider only the aggregate economic classification here and do a mapping */

	* no info on usual subsidiary activity

 

	
	gen indu_code_prim=B4_q14 if ilo_lfs==1
	
		destring indu_code_prim, replace force
		
		replace indu_code_prim=int(indu_code_prim/100)
		
		
/*

	if current activity considered:
			
	consider variable B5_q5_1 (coded at the one digit level)
	
		*/
			
	
	
		* Primary activity
		
		gen ilo_job1_eco_aggregate=.
			replace ilo_job1_eco_aggregate=1 if indu_code_prim==0
			replace ilo_job1_eco_aggregate=2 if inlist(indu_code_prim,2,3)
			replace ilo_job1_eco_aggregate=3 if indu_code_prim==5
			replace ilo_job1_eco_aggregate=4 if inlist(indu_code_prim,1,4)
			replace ilo_job1_eco_aggregate=5 if inlist(indu_code_prim,6,7,8)
			replace ilo_job1_eco_aggregate=6 if indu_code_prim==9
			replace ilo_job1_eco_aggregate=7 if ilo_job1_eco_aggregate==. & ilo_lfs==1
			replace ilo_job1_eco_aggregate=. if ilo_lfs!=1
				 lab def eco_aggr_lab 1 "1 - Agriculture" 2 "2 - Manufacturing" 3 "3 - Construction" 4 "4 - Mining and quarrying; Electricity, gas and water supply" ///
								     5 "5 - Market Services (Trade; Transportation; Accommodation and food; and Business and administrative services)"  ///
								     6 "6 - Non-market services (Public administration; Community, social and other services and activities)" 7 "7 - Not classifiable by economic activity"					
				lab val ilo_job1_eco_aggregate eco_aggr_lab
				lab var ilo_job1_eco_aggregate "Economic activity (Aggregate) - main job"
	
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_job1_ocu_isco08')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: Classification used: NCO 1968 which is based on ISCO 1968 -->we don't consider the classification ISCO 1968 and mapping with other classifications very imprecise --> don't do any mapping,
	* as also imprecise at the most aggregate level 

		* graph on page 13 of document https://www.ncs.gov.in/Documents/National%20Classification%20of%20Occupations%20_Vol%20I-%202015.pdf indicates that NCO 1968 is aligned with ISCO-68

		/*
		gen occ_code_prim=B4_q15 if ilo_lfs==1
		
			destring occ_code_prim, replace force
			replace occ_code_prim=int(occ_code_prim/100) 
			
			* broad categories for ISCO 68 are listed here: http://www.ilo.org/public/english/bureau/stat/isco/isco68/major.htm 
		*/
		/*
	* Aggregate level
	
		* Primary occupation
	
		gen ilo_job1_ocu_aggregate=.
			replace ilo_job1_ocu_aggregate=1 if inlist(occ_code_prim,0,1)
			replace ilo_job1_ocu_aggregate=2 if inlist(occ_code_prim,3,4,5)
			replace ilo_job1_ocu_aggregate=3 if occ_code_prim==6
			replace ilo_job1_ocu_aggregate=4 if occ_code_prim
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

*/

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_job1_ins_sector')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

* Comment:	Enterprise_Type
*			NOT POSSIBLE - even though a variable exists, there is a category called "Public/Private limited company" which doesn't allow for differentiating and aggregating to the 2 categories 
*			private and public


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job1_job_time')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			

* Comment: no information --> check again
/*
		gen ilo_job1_job_time=.
			replace ilo_job1_job_time=1 if (Full_time_or_part_time==2 & ilo_lfs==1) 
			replace ilo_job1_job_time=2 if (Full_time_or_part_time==1 & ilo_lfs==1)
			replace ilo_job1_job_time=3 if ilo_job1_job_time==. & ilo_lfs==1
				lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
				lab val ilo_job1_job_time job_time_lab
				lab var ilo_job1_job_time "Job (Working time arrangement) - Main job"	
		*/
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job1_job_contract')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
		
* Comment:	Not possible


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Formal / Informal Economy ('ilo_job1_ife_prod' 'ilo_job1_ife_nature') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			


	* 1) Unit of production - Formal / Informal Sector

* Comment:	National definition:		Legal status - Proprietary and partnership firms in India do not have any separate legal status other than that of the owners. Thus such units are considered 
*										as un-incorporated.
*										Size of employment - The second criteria employed for the identification of informal sector was employment size of fewer than 10 workers. The size criteria 
*										was decided after analysing the threshold limits of various labour laws, productivity differentials of establishments with different employment sizes and 
*										development policies.
*										Maintenance of complete accounts criteria is implicit as there is no requirement of private establishments employing less than 10 workers to maintain such 
*										accounts.
*										Registration - The criterion of registration was not used as there were multiple registrations of firms and there was no single registration system covering 
*										all firms and giving separate legal status to all the registered units.
*		
*			Casual worker is always informal - Usual_Principal_Activity_Status==41 | Usual_Principal_Activity_Status==51
*
*			In the agricultural sector, industry groups 011 (growing of non-perennial crops), 012 (growing of perennial crops), 013 (plant propagation) and 015 (mixed farming) of NIC â€“ 2008 were 
*			excluded for collection of information on characteristics of enterprises and conditions of employment. Therefore, the industry groups/ divisions 014, 016, 017, 02 and 03 cover the 
*			agricultural sector excluding growing of crops, plant propagation, combined production of crops and animals without a specialized production of crops or animals 
*			(henceforth referred to as AGEGC activities).
*			
*			In NSS 61st round (July 2004-June 2005), along with information on different characteristics of the enterprises (viz. location of the workplace, type of enterprise, number of workers in 
*			the enterprise, whether enterprise uses electricity) in which usually employed persons worked, particulars on conditions of employment (viz. type of job contract, whether eligible for 
*			paid leave, availability of social security benefits, method of payment) for the employees (regular wage/salaried employees and casual labourers) were also collected. 
*			In 68th (July 2011-June 2012) round, information on characteristics of enterprises for all usual status workers and conditions of employment for the employees was collected for the same 
*			set of items as those of 61st round. The coverage of activities in 61st and 68th rounds was non-agriculture sector and AGEGC activities in agriculture sector.
*
*	 Variable Usual_PrincipalActivity_NIC2008 - note that there is a skip pattern after this questions excluding groups 011, 012, 013, 015 (NIC-2008)
*		

	* Useful questions: [no info]: Institutional sector --> use as a proxy the variable Enterprise_Type (in order to identify the public and the household sector)
					*	[no info]: Destination of production
					*	[no info]: Bookkeeping
					*	[no info]: Registration
					*	B4_q16: Location of workplace
					*	[no info]: Size 
					*	[no info]: Social security
												
	
	
	
		* --> given that Block 4 (capturing information on usual principal activity) only information on the location of workplace appears,
			* the variable on informality cannot be defined
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Hours of work ('ilo_job1_how')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
           
* Comment: 	NOT POSSIBLE - no variable indicating working time available in the dataset
				

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Monthly labour related income ('ilo_joball_lri')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
           
* Comment: 	
			
		
***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_joball_tru')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			


* Comment: 	no info


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupational injury ('ilo_joball_inj')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
		
	
* Comment: 	NOT POSSIBLE - No information available in the questionnaire
		
		

***********************************************************************************************
*			PART 3.3. UNEMPLOYMENT: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Category of unemployment ('ilo_cat_une')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	
* Comment: 	

	* given that the section 6 where this info is contained is not using the same reference period as the rest of 
		* the variables used for the definition of the "ilo_*" variables, the codes are being left in green in order 
		* to use them along with the other "curr_" variables
	
/*


	gen curr_cat_une=.
		replace curr_cat_une=1 if B6_q16==1
		replace curr_cat_une=2 if B6_q16==2
		replace curr_cat_une=3 if curr_lfs==2 & curr_cat_une==.
		replace curr_cat_une=. if curr_lfs!=2
			lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
			lab val curr_cat_une cat_une_lab
			lab var curr_cat_une "Category of unemployment"

	*/
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: 	* variable contained in section 5.1 (used for defining the rest of ilo_* variables) contains only some information on job seeking activities during the last 365 days 
		* therefore, it is not being used for defining ilo_dur_details
		
		* however, if section 5.3 considered (current activity), use the code below to define. Please note that the option "24 months or more" cannot be defined

/*
 if section considering current activity being used:
	gen curr_dur_details=.
		replace curr_dur_details=1 if inlist(B6_q8,1,2,3)
		replace curr_dur_details=2 if inlist(B6_q8,4,5)
		replace curr_dur_details=3 if B6_q8==6
		replace curr_dur_details=4 if B6_q8==7
		replace curr_dur_details=5 if B6_q8==8
		/* replace curr_dur_details=6 if */
		replace curr_dur_details=7 if curr_dur_details==. & curr_lfs==2
				replace curr_dur_details=. if curr_lfs!=2
			lab def curr_unemp_det 1 "Less than 1 month" 2 "1 month to less than 3 months" 3 "3 months to less than 6 months" 4 "6 months to less than 12 months" 5 "12 months to less than 24 months" ///
									6 "24 months or more" 7 "Not elsewhere classified"
			lab values curr_dur_details curr_unemp_det
			lab var curr_dur_details "Duration of unemployment (Details)" 
			
	* in order to avoid putting any notes and as the exact duration is not precised if person seeking for a job for 52 weeks, take only the aggregate version
			
			
	gen curr_dur_aggregate=.
		replace curr_dur_aggregate=1 if inlist(curr_dur_details,1,2,3)
		replace curr_dur_aggregate=2 if curr_dur_details==4
		replace curr_dur_aggregate=3 if inlist(curr_dur_details,5,6)
		replace curr_dur_aggregate=4 if curr_dur_details==7
			lab def curr_unemp_aggr 1 "Less than 6 months" 2 "6 months to less than 12 months" 3 "12 months or more" 4 "Not elsewhere classified"
			lab val curr_dur_aggregate curr_unemp_aggr
			lab var curr_dur_aggregate "Duration of unemployment (Aggregate)"
			
			*/



* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment: 	info indicated in block 6, using a different reference period than block 4


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('curr_prevocu')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

* Comment: 	info indicated in block 6, using a different reference period than block 4

*

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			General social protection ('ilo_gsp_unschemes')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment: 	NOT POSSIBLE - No information available in the questionnaire

	
	
***********************************************************************************************
*			PART 3.4. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
	
* Comment: 	NOT POSSIBLE - Seeking and available for work do not exist as separate variables


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reason for not seeking job ('ilo_olf_reason')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

* Comment: * given that no labour market reasons appear in the questionnaire, do not define the variable
			

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seeker ('ilo_dis')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

* Comment: 	NOT POSSIBLE - Seeking and available for work do not exist as separate variables in the dataset and no variable for reason for not seeking 
		* also, no labour market reason indicated 
			
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training ('ilo_neet')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

* Comment: Status_of_Current_Attendance ("attending education'") set to 1 to 15 ('Currently not attending')

		gen ilo_neet=.
			replace ilo_neet=1 if (ilo_age_aggregate==2 & ilo_lfs!=1 & ilo_edu_attendance==2) 

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
		save ${country}_${source}_${time}_FULL, replace


* 2 - Dataset with only 'ILO' variables
	
		keep ilo*
		save ${country}_${source}_${time}_ILO, replace

