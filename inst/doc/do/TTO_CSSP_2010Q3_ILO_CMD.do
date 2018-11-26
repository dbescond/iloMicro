* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Trinidad & Tobago  
* DATASET USED: Trinidad & Tobago CSSP
* NOTES: 
* Files created: Standard variables on Trinidad & Tobago
* Authors: DPAU 
* Starting Date: 08 February 2018
* Last updated:  21 February 2018
***********************************************************************************************


*******************************************************************
 /* 1.	Set up work directory, file name, variables and function */
*******************************************************************

clear all 

set more off

 
global path "J:\DPAU\MICRO"
global country "TTO"
global source "CSSP"
global time "2010Q3"
global inputFile "Private Persons Data (10)SRequest.dta"

global inpath "${path}\\${country}\\${source}\\${time}\ORI"
global temppath "${path}\_Admin"
global outpath "${path}\\${country}\\${source}\\${time}"
 
 


************************************************************************************

* Important : if package « labutil » not already installed, install it in order to execute correctly the do-file

	* ssc install labutil

************************************************************************************

		* NOTE: if you want this do-file to run correctly, run it without breaks!
		
cd "$temppath"
		

*********************************************************************************************

* Load original dataset

*********************************************************************************************

cd "$inpath"

	use "${inputFile}", clear	
	
	rename *, lower
		
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
*			Time period ('ilo_time')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------


	* Year 
	gen ilo_time=1
		lab def lab_time 1 "$time"
		lab val ilo_time lab_time
		lab var ilo_time "Time (Gregorian Calendar)"

	
*********************************************************************************************

* create local for Year and quarter

*********************************************************************************************			
	
	decode ilo_time, gen(todrop)
	split todrop, generate(todrop_) parse(Q)
	destring todrop_1, replace force
	local Y = todrop_1 in 1
					
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Identifier ('ilo_key')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_key=_n 
		lab var ilo_key "Key unique identifier per individual"	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sample Weight ('ilo_wgt')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

 
* Comment: weights are different depending on whether we take quarterly or annual data

	
if substr(todrop,5,1)=="Q" {
	
	gen ilo_wgt=raisefac/100
		
		}
		
	else {	

	gen ilo_wgt=raisefac/400
		
			}
	
		
		lab var ilo_wgt "Sample weight"	
 
 
 
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

*** Comment: there is no information to compute this variable

 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
		
		gen ilo_sex=p03
			label define label_sex 1 "1 - Male" 2 "2 - Female"
			label values ilo_sex label_sex 
			lab var ilo_sex "Sex" 
 
 
 * -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

		gen ilo_age=p04
	
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
			replace ilo_age_5yrbands=14 if ilo_age>=65 
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
			replace ilo_age_10yrbands=7 if ilo_age>=65
				lab def age_by10_lab 1 "<15" 2 "15-24" 3 "25-34" 4 "35-44" 5 "45-54" 6 "55-64" 7 "65+"
				lab val ilo_age_10yrbands age_by10_lab
				lab var ilo_age_10yrbands "Age (10-year age bands)"
				
		gen ilo_age_aggregate=.
			replace ilo_age_aggregate=1 if inrange(ilo_age,0,15)
			replace ilo_age_aggregate=2 if inrange(ilo_age,15,24)
			replace ilo_age_aggregate=3 if inrange(ilo_age,25,54)
			replace ilo_age_aggregate=4 if inrange(ilo_age,55,64)
			replace ilo_age_aggregate=5 if ilo_age>=65 
				lab def age_aggr_lab 1 "<15" 2 "15-24" 3 "25-54" 4 "55-64" 5 "65+"
				lab val ilo_age_aggregate age_aggr_lab
				lab var ilo_age_aggregate "Age (Aggregate)"

 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Level of education ('ilo_edu')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

** Comment: there is no ISCED mapping for TTO

		gen ilo_edu_aggregate=.
			replace ilo_edu_aggregate=1 if inrange(p06,0,12)
			replace ilo_edu_aggregate=2 if inrange(p06,13,21)
			replace ilo_edu_aggregate=3 if inrange(p06,22,38)
			replace ilo_edu_aggregate=4 if inrange(p06,40,42)
			replace ilo_edu_aggregate=5 if inlist(p06,60,99)
				label def edu_aggr_lab 1 "1 - Less than basic" 2 "2 - Basic" 3 "3 - Intermediate" 4 "4 - Advanced" 5 "5 - Level not stated"
				label val ilo_edu_aggregate edu_aggr_lab
				label var ilo_edu_aggregate "Education (Aggregate level)" 
  

 * -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education attendance ('ilo_edu_attendance')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
 
 ** No information

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			           Marital status ('ilo_mrts') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: variable p12
*          there is not enough information to make a distintion between widowed and divorced, since the only information
*          related to this is in the category  "Had a partner but now living alone", without more information on the dissolution.
*          "Married but living alone" has been considered as separated.
	
	* Detailed
	gen ilo_mrts_details=.
	    replace ilo_mrts_details=1 if p12==1                                          // Single
		replace ilo_mrts_details=2 if p12==4                                          // Married
		replace ilo_mrts_details=3 if p12==5                                          // Union / cohabiting
		*replace ilo_mrts_details=4 if                                                // Widowed
		replace ilo_mrts_details=5 if inlist(p12,2,3)                                // Divorced / separated
		replace ilo_mrts_details=6 if ilo_mrts_details==.			                 // Not elsewhere classified
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
*			Disability status ('ilo_dsb_details') [no info]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment: This variable can't be produced
				
	* gen ilo_dsb_aggregate=.


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
        
* Comment: 	

	gen ilo_wap=.
		replace ilo_wap=1 if (ilo_age>=15 & ilo_age!=.)
		*replace ilo_wap=0 if ilo_age<15
			label def ilo_wap_lab 1 "Working age population"
			label val ilo_wap ilo_wap_lab
			label var ilo_wap "Working age population"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Labour Force Status ('ilo_lfs')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_lfs=.
		replace ilo_lfs=1 if p18==1 & ilo_wap==1 // employed
		replace ilo_lfs=2 if ilo_lfs!=1 & (p18==2 & p23==1) // unemployed (those who looked for job last week)	[(two criteria) (T5:1429)]	
		replace ilo_lfs=3 if !inlist(ilo_lfs,1,2)
		replace ilo_lfs=. if ilo_wap!=1	
				label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status" 


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
 

	gen ilo_mjh=.
		replace ilo_mjh=1 if p19==1
		replace ilo_mjh=2 if p19!=1
		replace ilo_mjh=. if ilo_lfs!=1
				* force missing values into "one job only" 
				replace ilo_mjh=1 if ilo_mjh==. & ilo_lfs==1
			lab def lab_ilo_mjh 1 "1 - One job only" 2 "2 - More than one job"
			lab val ilo_mjh lab_ilo_mjh

			lab var ilo_mjh "Multiple job holders"				

			
***********************************************************************************************
*			PART 3.1. ECONOMIC CHARACTERISTICS FOR MAIN JOB 
***********************************************************************************************		

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Status in employment ('ilo_ste')
* -------------------------------------------------------------------------------------------
* ------------------------------------------------------------------------------------------- 


	* MAIN JOB
		
		gen ilo_job1_ste_icse93=.
			replace ilo_job1_ste_icse93=1 if inrange(p28,0,3) | p28==5 // 1 - Employees
			replace ilo_job1_ste_icse93=2 if p28==7  // 2 - Employers
			replace ilo_job1_ste_icse93=3 if p28==6  // 3 - Own-account workers
			/* replace ilo_job1_ste_icse93=4 if */
			replace ilo_job1_ste_icse93=5 if p28==4 // 5 - Contributing family workers 
			replace ilo_job1_ste_icse93=6 if ilo_job1_ste_icse93==. & ilo_lfs==1
			replace ilo_job1_ste_icse93=. if ilo_lfs!=1			
				label define label_ilo_ste_icse93 1 "1 - Employees" 2 "2 - Employers" 3 "3 - Own-account workers" 4 "4 - Members of producers' cooperatives" 5 "5 - Contributing family workers" ///
												6 "6 - Workers not classifiable by status"
				label val ilo_job1_ste_icse93 label_ilo_ste_icse93
				label var ilo_job1_ste_icse93 "Status in employment (ICSE 93)"

	* Aggregate categories
	
		gen ilo_job1_ste_aggregate=.
			replace ilo_job1_ste_aggregate=1 if ilo_job1_ste_icse93==1
			replace ilo_job1_ste_aggregate=2 if inlist(ilo_job1_ste_icse93,2,3,4,5)
			replace ilo_job1_ste_aggregate=3 if ilo_job1_ste_icse93==6
				lab def ste_aggr_lab 1 "1 - Employees" 2 "2 - Self-employed" 3 "3 - Not elsewhere classified"
				lab val ilo_job1_ste_aggregate ste_aggr_lab
				label var ilo_job1_ste_aggregate "Status in employment (Aggregate)" 
		
		 
	* Secondary activity
			* No information related


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

*** Comment: variables related to economic activity and occupation are not computed for 2010 because the inconsistency in the data in 2010Q4


if todrop != "2010" {

 ** Comment: they follow a national classification which follows ISIC Rev.2.
			*** However the information in the variable given at 1-digit level only allows to compute the aggregate ILO variable. 

* Main activity:	

	
		* Primary activity
		
		gen ilo_job1_eco_aggregate=.
			replace ilo_job1_eco_aggregate=1 if inlist(rindus,1,2) & ilo_lfs==1 //1 - Agriculture
			replace ilo_job1_eco_aggregate=2 if rindus==5 & ilo_lfs==1 //2- Manufacturing
			replace ilo_job1_eco_aggregate=3 if rindus==7  & ilo_lfs==1 //3 - Construction
			replace ilo_job1_eco_aggregate=4 if (inlist(rindus,3,4) | rindus==6)  & ilo_lfs==1 //4 - Mining and quarrying; Electricity, gas and water supply
			replace ilo_job1_eco_aggregate=5 if inrange(rindus,8,10) & ilo_lfs==1 // 5 - Market Services
			replace ilo_job1_eco_aggregate=6 if rindus==11 & ilo_lfs==1 // 6 - Non-market services 
			replace ilo_job1_eco_aggregate=7 if inlist(rindus,88,99) & ilo_lfs==1 // 7 - Not classifiable by economic activity
			    lab def eco_aggr_lab 1 "1 - Agriculture" 2 "2 - Manufacturing" 3 "3 - Construction" 4 "4 - Mining and quarrying; Electricity, gas and water supply" ///
								     5 "5 - Market Services (Trade; Transportation; Accommodation and food; and Business and administrative services)"  ///
								     6 "6 - Non-market services (Public administration; Community, social and other services and activities)" 7 "7 - Not classifiable by economic activity"					
			    lab val ilo_job1_eco_aggregate eco_aggr_lab
			    lab var ilo_job1_eco_aggregate "Economic activity (Aggregate) - main job"

				
		* Secondary activity
			*** Not possible to compute



* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_ocu')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

** Comment:  ISCO-88 classification used

	* Two-digits level
	
			** The variable ilo_job1_ocu_isco88 is only possible to compute at 1-digit level due to the information given by roccup. 
		 
		* 1 digit level
 	
		* Main job
		
		gen ilo_job1_ocu_isco88 = roccup1 if ilo_lfs==1
			replace ilo_job1_ocu_isco88=11 if inlist(roccup1,88,99) & ilo_lfs==1
			replace ilo_job1_ocu_isco88=. if ilo_lfs!=1
				lab def ocu88_1digits 1 "1 - Legislators, senior officials and managers"	2 "2 - Professionals"	3 "3 - Technicians and associate professionals" ///
										4 "4 - Clerks"	5 "5 - Service workers and shop and market sales workers"	6 "6 - Skilled agricultural and fishery workers"	///
										7 "7 - Craft and related trades workers"	8 "8 - Plant and machine operators and assemblers"	9 "9 - Elementary occupations"	///
										10 "0 - Armed forces"	11 "11 - Not elsewhere classified"

				lab val ilo_job1_ocu_isco88 ocu88_1digits
				lab var ilo_job1_ocu_isco88 "Occupation (ISCO-88) - main job"	
			
			
		* Second job
					
			gen ilo_job2_ocu_isco88 = roccup2 if ilo_mjh==2
			replace ilo_job2_ocu_isco88=11 if inlist(roccup2,88,99) & ilo_mjh==2
			replace ilo_job2_ocu_isco88=. if ilo_mjh!=2

				lab val ilo_job2_ocu_isco88 ocu88_1digits
				lab var ilo_job2_ocu_isco88 "Occupation (ISCO-88) - second job"	
			
			
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
			    lab var ilo_job1_ocu_aggregate "Occupation (Aggregate) - main job"	
				
		* Secondary occupation
		
			* gen ilo_job2_ocu_aggregate=.
	   	
		gen ilo_job2_ocu_aggregate=.
			replace ilo_job2_ocu_aggregate=1 if inrange(ilo_job2_ocu_isco88,1,3)   
			replace ilo_job2_ocu_aggregate=2 if inlist(ilo_job2_ocu_isco88,4,5)
			replace ilo_job2_ocu_aggregate=3 if inlist(ilo_job2_ocu_isco88,6,7)
			replace ilo_job2_ocu_aggregate=4 if ilo_job2_ocu_isco88==8
			replace ilo_job2_ocu_aggregate=5 if ilo_job2_ocu_isco88==9
			replace ilo_job2_ocu_aggregate=6 if ilo_job2_ocu_isco88==10
			replace ilo_job2_ocu_aggregate=7 if ilo_job2_ocu_isco88==11
		  	     
			    lab val ilo_job2_ocu_aggregate ocu_aggr_lab
			    lab var ilo_job2_ocu_aggregate "Occupation (Aggregate) - second job"	
		
 	
		* Skill level
	
		* Primary occupation
	
		gen ilo_job1_ocu_skill=.
			replace ilo_job1_ocu_skill=1 if ilo_job1_ocu_isco88==9                   // Low
			replace ilo_job1_ocu_skill=2 if inlist(ilo_job1_ocu_isco88,4,5,6,7,8)    // Medium
			replace ilo_job1_ocu_skill=3 if inlist(ilo_job1_ocu_isco88,1,2,3)        // High
			replace ilo_job1_ocu_skill=4 if inlist(ilo_job1_ocu_isco88,10,11)        // Not elsewhere classified
				lab def ocu_skill_lab 1 "1 - Skill level 1 (low)" 2 "2 - Skill level 2 (medium)" 3 "3 - Skill levels 3 and 4 (high)" 4 "4 - Not elsewhere classified"
			    lab val ilo_job1_ocu_skill ocu_skill_lab
			    lab var ilo_job1_ocu_skill "Occupation (Skill level) - main job"
				
		* Secondary occupation 
			gen ilo_job2_ocu_skill=.
				replace ilo_job2_ocu_skill=1 if ilo_job2_ocu_isco88==9                   // Low
				replace ilo_job2_ocu_skill=2 if inlist(ilo_job2_ocu_isco88,4,5,6,7,8)    // Medium
				replace ilo_job2_ocu_skill=3 if inlist(ilo_job2_ocu_isco88,1,2,3)        // High
				replace ilo_job2_ocu_skill=4 if inlist(ilo_job2_ocu_isco88,10,11)        // Not elsewhere classified
				 
					lab val ilo_job2_ocu_skill ocu_skill_lab
					lab var ilo_job2_ocu_skill "Occupation (Skill level) - second job"
			
			
			
}			
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_ins_sector')  
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
 
	* Primary occupation
	
	 gen ilo_job1_ins_sector=.
		replace ilo_job1_ins_sector=1 if inrange(p28,0,2)
		replace ilo_job1_ins_sector=2 if ilo_job1_ins_sector!=1 & ilo_lfs==1
		replace ilo_job1_ins_sector=. if ilo_lfs!=1
		
			lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
			lab values ilo_job1_ins_sector ins_sector_lab
			lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities"	
			
	* Secondary occupation
	
			*** No information available. 
	
 
* --------------------------------------------------------------------------------------------------
* --------------------------------------------------------------------------------------------------
*		Weekly hours actually worked ('ilo_how_actual') 
* --------------------------------------------------------------------------------------------------
* --------------------------------------------------------------------------------------------------

*** Comment: the 'national' band classification has been adapted to the ILO band classification


** Main job
				
	gen ilo_job1_how_actual_bands = .
			 replace ilo_job1_how_actual_bands = 1 if inlist(p34,0,1)	    // No hours actually worked
			 replace ilo_job1_how_actual_bands = 2 if inlist(p34,2,3)	    // 01-14
			 replace ilo_job1_how_actual_bands = 3 if inrange(p34,4,5)	// 15-29
			* replace ilo_job1_how_actual_bands = 4 if p34==6	       // 30-34
			 replace ilo_job1_how_actual_bands = 5 if p34==6	      // 35-39
			 replace ilo_job1_how_actual_bands = 6 if p34==7	      // 40-48
			 replace ilo_job1_how_actual_bands = 7 if inrange(p34,8,10) // 49+
			 replace ilo_job1_how_actual_bands= 8 if ilo_job1_how_actual_bands == .		// Not elsewhere classified
 			 replace ilo_job1_how_actual_bands = . if ilo_lfs!=1
			 
				     lab def how_bands_lab 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"
					 lab val ilo_job1_how_actual_bands how_bands_lab
					 lab var ilo_job1_how_actual_bands "Weekly hours actually worked bands in main job"
				
*** Second job

	gen ilo_job2_how_actual_bands = .
			 replace ilo_job2_how_actual_bands = 1 if inlist(p38,0,1)		 // No hours actually worked
			 replace ilo_job2_how_actual_bands = 2 if inlist(p38,2,3)    // 01-14
			 replace ilo_job2_how_actual_bands = 3 if inrange(p38,4,5)	// 15-29
			 replace ilo_job2_how_actual_bands = 4 if p38==6	// 30-34
			 replace ilo_job2_how_actual_bands = 5 if p38==6	// 35-39
			 replace ilo_job2_how_actual_bands = 6 if p38==7	// 40-48
			 replace ilo_job2_how_actual_bands = 7 if inrange(p38,8,10) // 49+
			 replace ilo_job2_how_actual_bands = 8 if ilo_job2_how_actual_bands == . & ilo_mjh==2	// Not elsewhere classified
			 replace ilo_job2_how_actual_bands = . if ilo_mjh!=2
			 
                     *lab def how_actual_bands_lab 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"
					 lab val ilo_job2_how_actual_bands how_bands_lab
					 lab var ilo_job2_how_actual_bands "Weekly hours actually worked bands in second job"


*** All jobs
			
			egen ilo_joball_how_actual_bands=rowtotal(ilo_job1_how_actual_bands ilo_job2_how_actual_bands), m
				replace ilo_joball_how_actual_bands = ilo_job1_how_actual_bands if ilo_job2_how_actual_bands==8  
				replace ilo_joball_how_actual_bands = ilo_job2_how_actual_bands if ilo_job1_how_actual_bands==8
				replace ilo_joball_how_actual_bands = 7 if ilo_joball_how_actual_bands>=8 & ilo_job1_how_actual_bands!=8 & ilo_job2_how_actual_bands!=8
				replace ilo_joball_how_actual_bands = 8 if ilo_joball_how_actual_bands == . & ilo_lfs==1	// Not elsewhere classified
				replace ilo_joball_how_actual_bands=. if ilo_lfs!=1
				
					lab val ilo_joball_how_actual_bands how_bands_lab
					lab var ilo_joball_how_actual_bands "Weekly hours actually worked in all jobs"	

					
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job_time') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

 *** Comment: no information

 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job_contract')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

 *** Comment: no information

 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Informal/Formal economy: Unit of production ('ilo_job1_ife_prod')  
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

/*

** Not possible to compute


* Comment: Useful questions:	* Status in employment: p28
								* Institutional sector: p28 
								* Destination of production: [no info]
								* Bookkeeping: [no info]
								* Registration: [no info]			
								* Location of workplace: p32 
								* Size of the establishment: p31				
								* Social security: [no info] 
									

			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Informal/formal economy: Nature of job ('ilo_job1_ife_nature') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

				
			
*/			
  
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Earnings ('ilo_job1_lri_ees' and 'ilo_ear_slf')  
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------


*** MAIN JOB

** Currency: TT$
** Gross montly income. 

*** Income bands are established as mid-point of each internval
	
		gen rpriminc_mid = . 
			replace rpriminc_mid = 0 if  rpriminc	==	0     // Zero
			replace	rpriminc_mid = 125 if  rpriminc	== 1    //TT$1-TT$249
			replace	rpriminc_mid = 375 if  rpriminc	== 2   // TT$250-TT$499
			replace	rpriminc_mid = 625 if  rpriminc	== 3   // TT$500-TT$749
			replace	rpriminc_mid = 875 if  rpriminc	== 4   // TT$750-TT$999
			replace	rpriminc_mid = 1125	if rpriminc	== 5   // TT$1000-TT$1249
			replace	rpriminc_mid = 1375	if rpriminc	== 6   // TT$1250-TT$1499
			replace	rpriminc_mid = 1625	if rpriminc	== 7   //  TT$1500-TT$1749
			replace	rpriminc_mid = 1875	if rpriminc	== 8   // TT$1750-TT$1999
			replace	rpriminc_mid = 2250	if  rpriminc == 9   // TT$2000-TT$2499
			replace	rpriminc_mid = 2750	if rpriminc	== 10   // TT$2500-TT$2999
			replace	rpriminc_mid = 3250	if rpriminc == 11   // TT$3000-TT$3499
			replace	rpriminc_mid = 3750	if rpriminc == 12   // TT$3500-TT$3999
			replace	rpriminc_mid = 4250 if rpriminc == 13   // TT$4000-TT$4499
			replace	rpriminc_mid = 4750 if rpriminc == 14   // TT$4500-TT$4999
			replace	rpriminc_mid = 5250	if rpriminc	== 15   // TT$5000-TT$5499
			replace	rpriminc_mid = 5750	if rpriminc	== 16   // TT$5500-TT$5999
			replace	rpriminc_mid = 6250	if rpriminc	== 17   // TT$6000-TT$6499
			replace	rpriminc_mid = 6750	if rpriminc	== 18   // TT$6500-TT$6999
			replace	rpriminc_mid = 7250	if rpriminc	== 19   // TT$7000-TT$7499
			replace	rpriminc_mid = 7750	if rpriminc	== 20   // TT$7500-TT$7999
			replace	rpriminc_mid = 8500	if rpriminc	== 21   // TT$8000-TT$8999
			replace	rpriminc_mid = 9500	if rpriminc	== 22   // TT$9000-TT$9999
			replace	rpriminc_mid = 10000 if	rpriminc == 23   // OVER-TT$10000
			replace	rpriminc_mid = . if rpriminc_mid==. & ilo_lfs==1   // Missing
	 


	*** Employees		
 	
		gen ilo_job1_lri_ees = rpriminc_mid if ilo_job1_ste_aggregate==1  
		replace ilo_job1_lri_ees = . if ilo_job1_lri_ees==. &  ilo_job1_ste_aggregate==1  
 			lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"
	
	
	*** Self-employed	
	
	gen ilo_job1_lri_slf = rpriminc_mid if ilo_job1_ste_aggregate==2
			replace ilo_job1_lri_slf  = . if ilo_job1_lri_slf==. & ilo_job1_ste_aggregate==2 
 			lab var ilo_job1_lri_slf "Monthly labour related income of self-employed in main job"	 


			
			
*** ALL JOBS
			
** Gross montly income. 

*** Income bands are established as mid-point of each internval
	
		gen rincome_mid = . 
			replace rincome_mid = 0 if  rincome	==	0     // Zero
			replace	rincome_mid = 125 if  rincome	== 1    //TT$1-TT$249
			replace	rincome_mid = 375 if  rincome	== 2   // TT$250-TT$499
			replace	rincome_mid = 625 if  rincome	== 3   // TT$500-TT$749
			replace	rincome_mid = 875 if  rincome	== 4   // TT$750-TT$999
			replace	rincome_mid = 1125	if rincome	== 5   // TT$1000-TT$1249
			replace	rincome_mid = 1375	if rincome	== 6   // TT$1250-TT$1499
			replace	rincome_mid = 1625	if rincome	== 7   //  TT$1500-TT$1749
			replace	rincome_mid = 1875	if rincome	== 8   // TT$1750-TT$1999
			replace	rincome_mid = 2250	if  rincome == 9   // TT$2000-TT$2499
			replace	rincome_mid = 2750	if rincome	== 10   // TT$2500-TT$2999
			replace	rincome_mid = 3250	if rincome == 11   // TT$3000-TT$3499
			replace	rincome_mid = 3750	if rincome == 12   // TT$3500-TT$3999
			replace	rincome_mid = 4250 if rincome == 13   // TT$4000-TT$4499
			replace	rincome_mid = 4750 if rincome == 14   // TT$4500-TT$4999
			replace	rincome_mid = 5250	if rincome	== 15   // TT$5000-TT$5499
			replace	rincome_mid = 5750	if rincome	== 16   // TT$5500-TT$5999
			replace	rincome_mid = 6250	if rincome	== 17   // TT$6000-TT$6499
			replace	rincome_mid = 6750	if rincome	== 18   // TT$6500-TT$6999
			replace	rincome_mid = 7250	if rincome	== 19   // TT$7000-TT$7499
			replace	rincome_mid = 7750	if rincome	== 20   // TT$7500-TT$7999
			replace	rincome_mid = 8500	if rincome	== 21   // TT$8000-TT$8999
			replace	rincome_mid = 9500	if rincome	== 22   // TT$9000-TT$9999
			replace	rincome_mid = 10000 if	rincome == 23   // OVER-TT$10000
			replace	rincome_mid = . if rincome_mid==. & ilo_lfs==1   // Missing
	 


	*** Employees		
 	 
		gen ilo_joball_lri_ees = rincome_mid if ilo_job1_ste_aggregate==1  
		replace ilo_joball_lri_ees = . if ilo_joball_lri_ees==. &  ilo_job1_ste_aggregate==1  
 			lab var ilo_joball_lri_ees "Monthly earnings of employees in main job"
	
	
	*** Self-employed	
	 
	gen ilo_joball_lri_slf = rincome_mid if ilo_job1_ste_aggregate==2
			replace ilo_joball_lri_slf  = . if ilo_joball_lri_slf==. & ilo_job1_ste_aggregate==2 
 			lab var ilo_joball_lri_slf "Monthly labour related income of self-employed in main job"	

			
			
***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_tru') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

*** Comment: there is not enough information to calculate this variable.


*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Cases of non-fatal occupational injury ('ilo_joball_oi_case') [no info]
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------

* Comment: No information
		
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Days lost due to cases of occupational injury ('ilo_joball_oi_day') [no info]
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------

* Comment: No information



***********************************************************************************************
*			PART 3.3. UNEMPLOYMENT: ECONOMIC CHARACTERISTICS
***********************************************************************************************	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

*** Comment: there is no clear information to compute this variable 

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Category of unemployment ('ilo_cat_une')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_cat_une=.
		replace ilo_cat_une=1 if p20!=999 // 1 - Unemployed previously employed
		replace ilo_cat_une=2 if inlist(p22,2,3) & p23==1  // 2 - Unemployed seeking their first job
		replace ilo_cat_une=3 if ilo_lfs==2 & ilo_cat_une==. // 3 - Unknown
		replace ilo_cat_une=. if ilo_lfs!=2
			lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
			lab val ilo_cat_une cat_une_lab
			lab var ilo_cat_une "Category of unemployment"
	
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

*** Comment: variables related to economic activity and occupation are not computed for 2010 because the inconsistency in the data in 2010Q4

if todrop != "2010" {
		
	* Aggregate level
		
		gen ilo_preveco_aggregate=.
			replace ilo_preveco_aggregate=1 if inlist(rindus,1,2) & ilo_lfs==2 & ilo_cat_une==1  //1 - Agriculture
			replace ilo_preveco_aggregate=2 if rindus==5 & ilo_lfs==2 & ilo_cat_une==1  //2- Manufacturing
			replace ilo_preveco_aggregate=3 if rindus==7 & ilo_lfs==2 & ilo_cat_une==1 //3 - Construction
			replace ilo_preveco_aggregate=4 if (inlist(rindus,3,4) | rindus==6)  & ilo_lfs==2 & ilo_cat_une==1 //4 - Mining and quarrying; Electricity, gas and water supply
			replace ilo_preveco_aggregate=5 if inrange(rindus,8,10) & ilo_lfs==2 & ilo_cat_une==1 // 5 - Market Services
			replace ilo_preveco_aggregate=6 if rindus==11 & ilo_lfs==2 & ilo_cat_une==1 // 6 - Non-market services 
			replace ilo_preveco_aggregate=7 if inlist(rindus,88,99) & ilo_lfs==2 & ilo_cat_une==1 // 7 - Not classifiable by economic activity
			    
				lab val ilo_preveco_aggregate eco_aggr_lab
			    lab var ilo_preveco_aggregate "Previous economic activity (Aggregate)"
				
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu_isco88')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
		
* Comment: ISCO-88 classification being used
 
 
	* Reduce it to 1-digit level 
	
	gen ilo_prevocu_isco88=roccup1 if ilo_lfs==2 & ilo_cat_une==1
		replace ilo_prevocu_isco88=11 if inlist(roccup1,88,99) & ilo_lfs==2 & ilo_cat_une==1
				
 			lab val ilo_prevocu_isco88 ocu88_1digits
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
		  	    
			    lab val ilo_prevocu_aggregate ocu_aggr_lab
			    lab var ilo_prevocu_aggregate "Previous occupation (Aggregate)"		
		
			
	* Skill level
	
		gen ilo_prevocu_skill=.
			replace ilo_prevocu_skill=1 if ilo_prevocu_isco88==9                   // Low
			replace ilo_prevocu_skill=2 if inlist(ilo_prevocu_isco88,4,5,6,7,8)    // Medium
			replace ilo_prevocu_skill=3 if inlist(ilo_prevocu_isco88,1,2,3)        // High
			replace ilo_prevocu_skill=4 if inlist(ilo_prevocu_isco88,10,11)        // Not elsewhere classified
			    lab val ilo_prevocu_skill ocu_skill_lab
			    lab var ilo_prevocu_skill "Previous occupation occupation (Skill level)"
				
}

***********************************************************************************************
*			PART 3.4. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

** No posible to compute
** There is no information about willingness or availability
 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reasons for not seeking a job ('ilo_olf_reason')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------


	gen ilo_olf_reason=.
		replace ilo_olf_reason=1 if inlist(p25,8,10) 
		replace ilo_olf_reason=2 if p25==7  
		replace ilo_olf_reason=3 if inrange(p25,1,5)
		replace ilo_olf_reason=4 if p25==6  
		replace ilo_olf_reason=5 if ilo_olf_reason==. & ilo_lfs==3 
		replace ilo_olf_reason=. if ilo_lfs!=3
			lab def lab_olf_reason 1 "1 - Labour market (Discouraged)" 2 "2 - Other labour market reasons" 3 "3 - Personal/Family-related"  4 "4 - Does not need/want to work" 5 "5 - Not elsewhere classified"
			lab val ilo_olf_reason lab_olf_reason
			lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seekers ('ilo_dis')
* -------------------------------------------------------------------------------------------
* ------------------------------------------------------------------------------------------- 


	gen ilo_dis = 1 if ilo_lfs==3 & ilo_olf_reason==1
			lab def dis_lab 1 "Discouraged job-seekers"
			lab val ilo_dis dis_lab
			lab var ilo_dis "Discouraged job-seekers"

			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training (NEETs) ('ilo_neet')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

** There is no information related to current attendance (education or training)
 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

*			SAVE RESULTS

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* -------------------------------------------------------------
* Prepare final datasets
* -------------------------------------------------------------

cd "$outpath"
 
		drop ilo_age /* As only age bands being kept and this variable used as help variable */
		
		compress 
		 
		   		   
	* Save dataset including original and ilo variables
	
		save ${country}_${source}_${time}_FULL, replace		
	
	*Save file only containing ilo_* variables
	
		keep ilo*
		
		drop if ilo_key==.

		save ${country}_${source}_${time}_ILO, replace

		
