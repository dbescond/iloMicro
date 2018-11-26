* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Fiji
* DATASET USED: EUS 2004
* NOTES: 
* Files created: Standard variables on EUS Fiji
* Authors: ILO / Department of Statistics / DPAU

* Starting Date: 28 November 2017
* Last updated: 08 February 2018
***********************************************************************************************

***********************************************************************************************
***********************************************************************************************

* 			1. SET UP WORK DIRECTORY, FILE NAME, VARIABLES AND FUNCTIONS

***********************************************************************************************
***********************************************************************************************

clear all 

set more off
*set more off, permanently

global path "J:\DPAU\MICRO"
global country "FJI"
global source "EUS"
global time "2005"
global inputFile "EUS 2004"
global inpath "${path}\\${country}\\${source}\\${time}\ORI"
global temppath "${path}\_Admin"
global outpath "${path}\\${country}\\${source}\\${time}"


********************************************************************************************
********************************************************************************************

* Load original dataset

********************************************************************************************
********************************************************************************************

cd "$inpath"
	use "$inputFile", clear

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
*			Key identifier ('ilo_key') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: 

	gen ilo_key=_n
		lab var ilo_key "Key unique identifier per individual"
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time period ('ilo_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: 
	
	gen ilo_time=1
		lab def lab_time 1 "$time"
		lab val ilo_time lab_time
		lab var ilo_time "Time (Gregorian Calendar)"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sample Weight ('ilo_wgt') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: 

	gen ilo_wgt=weight
		lab var ilo_wgt "Sample weight"

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
* Comment: - The original dataset does not contain the direct question about the geographical
*            coverage; here, we use the geographic stratum as the classification urban-rural

	gen ilo_geo=.
		replace ilo_geo=1 if inlist(geo,1,3,5,7)
		replace ilo_geo=2 if inlist(geo,2,4,6,8)
		        lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural"
		        lab val ilo_geo ilo_geo_lab
		        lab var ilo_geo "Geographical coverage"			 

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: 

	gen ilo_sex=.
	    replace ilo_sex=1 if sex==1
		replace ilo_sex=2 if sex==2
		        lab def ilo_sex_lab 1 "1 - Male" 2 "2 - Female"
		        lab var ilo_sex "Sex"
		        lab val ilo_sex ilo_sex_lab			
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment:

	gen ilo_age=.
	    replace ilo_age=age
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

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Level of education ('ilo_edu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - The highest level of education attained is used (1.8).
*          - ISCED mapping follows the document found here (Fiji):
*            http://uis.unesco.org/en/isced-mappings


	gen ilo_edu_isced97=.
		replace ilo_edu_isced97=1 if attainment==1                              // No schooling
		*replace ilo_edu_isced97=2 if                                           // Pre-primary education
		replace ilo_edu_isced97=3 if inlist(attainment,2,3,4)                   // Primary education or first stage of basic education
		replace ilo_edu_isced97=4 if inlist(attainment,5,6)                     // Lower secondary education or second stage of basic education
		replace ilo_edu_isced97=5 if inlist(attainment,7,8)                     // Upper secondary education
		replace ilo_edu_isced97=6 if attainment==9                              // Post-secondary non-terciary education
		replace ilo_edu_isced97=7 if inlist(attainment,10,11,12)                // First stage of tertiary education
		replace ilo_edu_isced97=8 if attainment==13                             // Second stage of tertiary education
		replace ilo_edu_isced97=9 if ilo_edu_isced97==.                         // Level not stated
			    label def isced_97_lab 1 "X - No schooling" 2 "0 - Pre-primary education" 3 "1 - Primary education or first stage of basic education" ///
				                       4 "2 - Lower secondary education or second stage of basic education" 5 "3 - Upper secondary education" ///
									   6 "4 - Post-secondary non-tertiary education" 7 "5 - First stage of tertiary education (not leading directly to an advanced research qualification)" ///
							           8 "6 - Second stage of tertiary education (leading to an advanced research qualification)" 9 "UNK - Level not stated"
			    label val ilo_edu_isced97 isced_97_lab
			    lab var ilo_edu_isced97 "Education (ISCED 97)"

	* Aggregate	
	gen ilo_edu_aggregate=.
		replace ilo_edu_aggregate=1 if inlist(ilo_edu_isced97,1,2)
		replace ilo_edu_aggregate=2 if inlist(ilo_edu_isced97,3,4)
		replace ilo_edu_aggregate=3 if inlist(ilo_edu_isced97,5,6)
		replace ilo_edu_aggregate=4 if inlist(ilo_edu_isced97,7,8)
		replace ilo_edu_aggregate=5 if ilo_edu_isced97==9
			label def edu_aggr_lab 1 "1 - Less than basic" 2 "2 - Basic" 3 "3 - Intermediate" 4 "4 - Advanced" 5 "5 - Level not stated"
			label val ilo_edu_aggregate edu_aggr_lab
			label var ilo_edu_aggregate "Education (Aggregate)"
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education attendance ('ilo_edu_attendance') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: 

		gen ilo_edu_attendance=.
			replace ilo_edu_attendance=1 if (schooling==1)                      // Attending 
			replace ilo_edu_attendance=2 if (schooling==2)                      // Not attending
			replace ilo_edu_attendance=3 if ilo_edu_attendance==.
				    lab def edu_attendance_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
				    lab val ilo_edu_attendance edu_attendance_lab
				    lab var ilo_edu_attendance "Education (Attendance)"


* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			           Marital status ('ilo_mrts') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: no info on Union/Cohabiting 
	
	* Detailed
	gen ilo_mrts_details=.
	    replace ilo_mrts_details=1 if marstat==1                                // Single
		replace ilo_mrts_details=2 if marstat==2                                // Married
		*replace ilo_mrts_details=3 if                                          // Union / cohabiting
		replace ilo_mrts_details=4 if marstat==3                                // Widowed
		replace ilo_mrts_details=5 if inlist(marstat,4,5)                       // Divorced / separated
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
*			Disability status ('ilo_dsb') 	[done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment: - Only computed at aggregated level
	
		gen ilo_dsb_aggregate=1
			replace ilo_dsb_aggregate=2 if disable==1	                        // With disability
			replace ilo_dsb_aggregate=1 if ilo_dsb_aggregate==.	                // Without disability
				    label def dsb_lab 1 "1 - Persons without disability" 2 "2 - Persons with disability" 
				    label val ilo_dsb_aggregate dsb_lab
				    label var ilo_dsb_aggregate "Disability status (Aggregate)"

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
* Comment:

	gen ilo_wap=.
		replace ilo_wap=1 if ilo_age>=15 & ilo_age!=.
			lab def wap_lab 1 "Working age population"
			lab val ilo_wap wap_lab
			label var ilo_wap "Working age population"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Labour Force Status ('ilo_lfs') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Employment comprises people who answered yes to: (a) work for wages or salary, 
*            (b) work for family business, (c) grow food, catch fish or make articles mainly 
*            for sales or barter, (d) grow food, catch fish or make articles mainly for your
*            family or own consumption and (e) unpaid community work full time. It also
*            includes employed people temporary absent from work.
*          - Unemployment includes people not in employment, seeking for a job and available 
*            to work (the literal question refers to available for work but no work available).
 
	gen ilo_lfs=.
	    replace ilo_lfs=1 if (activity1==1 | activity2==1 | activity3==1 | activity4==1 | activity5==1) & ilo_wap==1      // Employed
		replace ilo_lfs=1 if nowork7days==1 & ilo_wap==1                                                                  // Employed: temporary absent
		replace ilo_lfs=2 if ilo_lfs!=1 & inactivity==1 & looking==1 & ilo_wap==1                                         // Unemployment: not in employment, available and looking.
		replace ilo_lfs=3 if !inlist(ilo_lfs,1,2) & ilo_wap==1                                                            // Outside the labour force
				label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status" 
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - No information available.
				
***********************************************************************************************
*			PART 3.1. ECONOMIC CHARACTERISTICS FOR MAIN JOB 
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Status in employment ('ilo_job1_ste') [done]
* -------------------------------------------------------------------------------------------
* ------------------------------------------------------------------------------------------- 
* Comment: 

	* MAIN JOB	
	* Detailed categories
	  gen ilo_job1_ste_icse93=.
		  replace ilo_job1_ste_icse93=1 if inlist(empstat7days,1,2,5) & ilo_lfs==1    // Employees
		  replace ilo_job1_ste_icse93=1 if inlist(empstat4, 1,2,5) & ilo_lfs==1       // Employees
		  replace ilo_job1_ste_icse93=2 if empstat7days==3 & ilo_lfs==1               // Employers
		  replace ilo_job1_ste_icse93=2 if empstat4==3 & ilo_lfs==1                   // Employers
		  replace ilo_job1_ste_icse93=3 if empstat7days==4 & ilo_lfs==1               // Own-account workers
		  replace ilo_job1_ste_icse93=3 if empstat4==4 & ilo_lfs==1                   // Own-account workers
		  replace ilo_job1_ste_icse93=4 if empstat7days==7 & ilo_lfs==1               // Members of producers' cooperatives
		  replace ilo_job1_ste_icse93=4 if empstat4==7 & ilo_lfs==1                   // Members of producers' cooperatives
		  replace ilo_job1_ste_icse93=5 if empstat7days==6 & ilo_lfs==1               // Contributing family workers
		  replace ilo_job1_ste_icse93=5 if empstat4==6 & ilo_lfs==1                   // Contributing family workers
		  replace ilo_job1_ste_icse93=6 if ilo_job1_ste_icse93==. & ilo_lfs==1        // Not classifiable by status
				  label define label_ilo_ste_icse93 1 "1 - Employees" 2 "2 - Employers" 3 "3 - Own-account workers" 4 "4 - Members of producers' cooperatives" ///
			                                        5 "5 - Contributing family workers" 6 "6 - Workers not classifiable by status"
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

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - The original variable follows a classification at 4-digit level, but it is
*            not possible to map it to neither ISIC Rev.2 nor to Rev. 3, neither at two-digit
*            level nor at one-digit level, due to the amount of mismatches obtained in both cases.
*            Thus, the classification used here is to ISIC Rev. 3 at aggregated level.
*          - Two observations without original economic activity are classified under "Not
*            classifiable by economic activity".

	
	* MAIN JOB:
	gen indu_code_prim=.
	    replace indu_code_prim=int(indus7days/1000) if (activity1==1 | activity2==1 | activity3==1 | activity4==1 | activity5==1) & ilo_wap==1      // Employed
		replace indu_code_prim=int(indus4/1000) if indu_code_prim==. & ilo_lfs==1                                                                   // Employed: temporary absent

	
	* Primary activity
    gen ilo_job1_eco_aggregate=.
		replace ilo_job1_eco_aggregate=1 if indu_code_prim==1
		replace ilo_job1_eco_aggregate=2 if indu_code_prim==3
		replace ilo_job1_eco_aggregate=3 if indu_code_prim==5
		replace ilo_job1_eco_aggregate=4 if inlist(indu_code_prim,2,4)
		replace ilo_job1_eco_aggregate=5 if inrange(indu_code_prim,6,8)
		replace ilo_job1_eco_aggregate=6 if indu_code_prim==9
		replace ilo_job1_eco_aggregate=7 if ilo_job1_eco_aggregate==. & ilo_lfs==1
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
* Comment: - The original classification follows a classification at 4 digit-level, but it is 
*            not possible to map it to neither ISCO-08 (due to date discordances) nor to ISCO-88 (some
*            categories do not exist in the codelist), at two digit level. Thus, the classification used
*            here is to ISCO-88 at 1-digit level.

    * MAIN JOB	
	gen occ_code_prim=.
	    replace occ_code_prim=int(occup7days/1000) if (activity1==1 | activity2==1 | activity3==1 | activity4==1 | activity5==1) & ilo_wap==1     // Employed
		replace occ_code_prim=int(occup4/1000) if occ_code_prim==. & ilo_lfs==1                                                                   // Employed: temporary absent

    * 1-digit level
	gen ilo_job1_ocu_isco88=.
        replace ilo_job1_ocu_isco88=occ_code_prim if ilo_lfs==1                 // The rest of the occupations
        replace ilo_job1_ocu_isco88=11 if occ_code_prim==. & ilo_lfs==1         // Not elsewhere classified
		replace ilo_job1_ocu_isco88=10 if occ_code_prim==0 & ilo_lfs==1         // Armed forces
	            lab def ilo_job1_ocu_isco88 1 "1 - Legislators, senior officials and managers"	2 "2 - Professionals"	3 "3 - Technicians and associate professionals"	4 "4 - Clerks"	///
                                            5 "5 - Service workers and shop and market sales workers"	6 "6 - Skilled agricultural and fishery workers"	7 "7 - Craft and related trades workers"	8 "8 - Plant and machine operators and assemblers"	///
                                            9 "9 - Elementary occupations"	10 "0 - Armed forces"	11 "11 - Not elsewhere classified"
	            lab val ilo_job1_ocu_isco88 ilo_job1_ocu_isco88
				lab var ilo_job1_ocu_isco88 "Occupation (ISCO-88) - main job"
			
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
    gen ilo_job1_ocu_skill=.
	    replace ilo_job1_ocu_skill=1 if ilo_job1_ocu_isco88==9                   // Low
		replace ilo_job1_ocu_skill=2 if inlist(ilo_job1_ocu_isco88,4,5,6,7,8)    // Medium
		replace ilo_job1_ocu_skill=3 if inlist(ilo_job1_ocu_isco88,1,2,3)        // High
		replace ilo_job1_ocu_skill=4 if inlist(ilo_job1_ocu_isco88,10,11)        // Not elsewhere classified
				lab def ocu_skill_lab 1 "1 - Skill level 1 (low)" 2 "2 - Skill level 2 (medium)" 3 "3 - Skill levels 3 and 4 (high)" 4 "4 - Not elsewhere classified"
			    lab val ilo_job1_ocu_skill ocu_skill_lab
			    lab var ilo_job1_ocu_skill "Occupation (Skill level)"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_ins_sector') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - No information available.
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Informal/Formal economy: ('ilo_job1_ife_prod' and 'ilo_job1_ife_nature') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: 
/* Useful questions:
		  * Institutional sector: not asked.
		  * Private HH: not possible to identify.
		  * Destination of production: activity4 (mainly for family or own consumption) (not used due to the amount of employed people under this category)
		  * Bookkeeping: not asked.
		  * Registration: not asked.
		  * Status in employment: ilo_job1_ste_icse93==1 (employees)
		  * Social security contribution: not asked.
		  * Place of work: not asked.
		  * Size: not asked.
		  * Paid annual leave: not asked.
		  * Paid sick leave: not asked.
*/

    * 1) UNIT OF PRODUCTION: FORMAL/INFORMAL SECTOR		
    * Not computed due to the lack of information on registration, bookeeping and social security.
						

	* 2) NATURE OF JOB: FORMAL/INFORMAL EMPLOYMENT
    * Not computed due to the lack of information on social security, paid annual leave and/or paid sick leave.

	
***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		
				
* --------------------------------------------------------------------------------------------------
* --------------------------------------------------------------------------------------------------
*		                 Hours of work ('ilo_how') [done]
* --------------------------------------------------------------------------------------------------
* --------------------------------------------------------------------------------------------------
* Comment: - Only asked: hours actually worked in the past 7 days by intervals. 
*          - Since the intervals do not correspond to the exact dissaggregation used here, some notes
*            to values are used.

	* MAIN JOB
	* Hours actually worked in main job
    gen ilo_job1_how_actual_bands=.
	 	*replace ilo_job1_how_actual_bands=1 if 
		replace ilo_job1_how_actual_bands=2 if hrs7days==1 & ilo_lfs==1          // C8:4101_C8:4102
		replace ilo_job1_how_actual_bands=2 if hrswrkd4==1 & ilo_lfs==1
		replace ilo_job1_how_actual_bands=3 if inlist(hrs7days,2,3) & ilo_lfs==1 // C8:4114
		replace ilo_job1_how_actual_bands=3 if inlist(hrswrkd4,2,3) & ilo_lfs==1
		replace ilo_job1_how_actual_bands=4 if hrs7days==4 & ilo_lfs==1          // C8:2848
		replace ilo_job1_how_actual_bands=4 if hrswrkd4==4 & ilo_lfs==1 
		*replace ilo_job1_how_actual_bands=5 if 
		replace ilo_job1_how_actual_bands=6 if hrs7days==5 & ilo_lfs==1          // C8:1600
		replace ilo_job1_how_actual_bands=6 if hrswrkd4==5 & ilo_lfs==1
		*replace ilo_job1_how_actual_bands=7 if
		replace ilo_job1_how_actual_bands=8 if ilo_job1_how_actual_bands==. & ilo_lfs==1
		replace ilo_job1_how_actual_bands=. if ilo_lfs!=1
		    	lab def how_act_bands_lab 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"
				lab val ilo_job1_how_actual_bands how_act_bands_lab
				lab var ilo_job1_how_actual_bands "Weekly hours actually worked bands - main job"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
* Comment: - Threshold is set at 40 hours per week.
	
	gen ilo_job1_job_time=.
		replace ilo_job1_job_time=1 if inlist(hrs7days,1,2,3,4) & ilo_lfs==1
		replace ilo_job1_job_time=1 if inlist(hrswrkd4,1,2,3,4) & ilo_lfs==1
		replace ilo_job1_job_time=2 if hrs7days==5 & ilo_lfs==1
		replace ilo_job1_job_time=2 if hrswrkd4==5 & ilo_lfs==1
		replace ilo_job1_job_time=3 if ilo_job1_job_time==. & ilo_lfs==1
        	    lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
			    lab val ilo_job1_job_time job_time_lab
			    lab var ilo_job1_job_time "Job (Working time arrangement)"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job_contract') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
* Comment: - No information available.
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Monthly related income ('ilo_job1_lri_ees' and 'ilo_job1_lri_slf')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Original question is asked by intervals (also for those temporary absent from
*            work during the reference week) and thus the value taken is the mid-point of the
*            interval multiplied by (52/12). 

	* MAIN JOB
	
	gen gross_income=.
	    replace gross_income=14.5*(52/12) if gwklyincome==1 | grincome==1       // [0,29]
		replace gross_income=44.5*(52/12) if gwklyincome==2 | grincome==2       // [30-59]
		replace gross_income=74.5*(52/12) if gwklyincome==3 | grincome==3       // [60-89]
		replace gross_income=104.5*(52/12) if gwklyincome==4 | grincome==4      // [90-119]
		replace gross_income=134.5*(52/12) if gwklyincome==5 | grincome==5      // [120-149]
		replace gross_income=174.5*(52/12) if gwklyincome==6 | grincome==6      // [150-199]
		replace gross_income=224.5*(52/12) if gwklyincome==7 | grincome==7      // [200-249]
		replace gross_income=274.5*(52/12) if gwklyincome==8 | grincome==8      // [250-299]
		replace gross_income=300*(52/12) if gwklyincome==9 | grincome==9        // [300+]
				
	
	* Employees
	  gen ilo_job1_lri_ees = .
		  replace ilo_job1_lri_ees = gross_income if ilo_job1_ste_aggregate==1  // Month
		          lab var ilo_job1_lri_ees "Monthly earnings of employees - main job"
				 
	* Self-employed
	  gen ilo_job1_lri_slf = .
	  	  replace ilo_job1_lri_slf = gross_income if ilo_job1_ste_aggregate==2  // Month
	              lab var ilo_job1_lri_slf "Monthly labour related income of self-employed - main job"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_tru') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - No information available.
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupational injury ('ilo_joball_inj') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
* Comment: No information available.

*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Days lost due to cases of occupational injury ('ilo_joball_oi_day') [done]
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
* Comment: No information available.

***********************************************************************************************
*			PART 3.3. UNEMPLOYMENT: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Category of unemployment ('ilo_cat_une') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - No information available.

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comments:

	gen ilo_dur_details=.
	    replace ilo_dur_details=1 if (unemp7days==1 & ilo_lfs==2)                         // Less than 1 month
		replace ilo_dur_details=2 if (inlist(unemp7days,2,3) & ilo_lfs==2)                // 1 to 3 months
		replace ilo_dur_details=3 if (inlist(unemp7days,4,5,6) & ilo_lfs==2)              // 3 to 6 months
		replace ilo_dur_details=4 if (inlist(unemp7days,7,8,9,10,11) & ilo_lfs==2)        // 6 to 12 months 
		replace ilo_dur_details=5 if (unemp7days==12 & ilo_lfs==2)                        // 12 to 24 months 
		replace ilo_dur_details=6 if (unemp7days==13 & ilo_lfs==2)                        // 24 months or more
		replace ilo_dur_details=7 if (ilo_dur_details==. & ilo_lfs==2)                    // Not elsewhere classified
		        lab def ilo_unemp_det 1 "Less than 1 month" 2 "1 month to less than 3 months" 3 "3 months to less than 6 months" ///
									  4 "6 months to less than 12 months" 5 "12 months to less than 24 months" 6 "24 months or more" ///
									  7 "Not elsewhere classified"
			    lab val ilo_dur_details ilo_unemp_det
			    lab var ilo_dur_details "Duration of unemployment (Details)"
					
	gen ilo_dur_aggregate=.
		replace ilo_dur_aggregate=1 if (inlist(ilo_dur_details,1,2,3) & ilo_lfs==2)   // Less than 6 months
		replace ilo_dur_aggregate=2 if (ilo_dur_details==4 & ilo_lfs==2)              // 6 to 12 months
		replace ilo_dur_aggregate=3 if (inlist(ilo_dur_details,5,6) & ilo_lfs==2)     // 12 months or more
		replace ilo_dur_aggregate=4 if (ilo_dur_details==7 & ilo_lfs==2)              //Not elsewhere classified
		replace ilo_dur_aggregate=. if ilo_lfs!=2
			lab def ilo_unemp_aggr 1 "Less than 6 months" 2 "6 months to less than 12 months" 3 "12 months or more" 4 "Not elsewhere classified"
			lab val ilo_dur_aggregate ilo_unemp_aggr
			lab var ilo_dur_aggregate "Duration of unemployment (Aggregate)"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - No information available.
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - No information available.		

***********************************************************************************************
*			PART 3.3. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Willingness is not asked, and thus options 3 and 4 are not produced.
*          - Not availability is derived from the inactivity question (those who answered a 
*            category different from 1 (available for work but no work available).

	gen ilo_olf_dlma=.
		replace ilo_olf_dlma = 1 if (looking==1 & inactivity!=1 & ilo_lfs==3)		    // Seeking, not available
		replace ilo_olf_dlma = 2 if (looking==2 & inactivity==1 & ilo_lfs==3)			// Not seeking, available
		*replace ilo_olf_dlma = 3 if 		                                            // Not seeking, not available, willing
		*replace ilo_olf_dlma = 4 if 		                                            // Not seeking, not available, not willing
		replace ilo_olf_dlma = 5 if	(ilo_olf_dlma==. & ilo_lfs==3)				        // Not classified 
	 		lab def dlma_lab 1 "1 - Seeking, not available (Unavailable jobseekers)" 2 "2 - Not seeking, available (Available potential jobseekers)" ///
							 3 "3 - Not seeking, not available, willing (Willing non-jobseekers)" 4 "4 - Not seeking, not available, not willing" 5 "X - Not elsewhere classified"
			lab val ilo_olf_dlma dlma_lab 
			lab var ilo_olf_dlma "Labour market attachment (Degree of)"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reasons for not seeking a job ('ilo_olf_reason') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - No information available.
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seekers ('ilo_dis') [done]
* -------------------------------------------------------------------------------------------
* ------------------------------------------------------------------------------------------- 
* Comment: 	- No information available.	
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training (NEETs) ('ilo_neet') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: 

	  gen ilo_neet=1 if ilo_age_aggregate==2 & ilo_lfs!=1 & ilo_edu_attendance==2
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
cd "$outpath"
		
		/*Only age bands used*/
		drop ilo_age 
		
		/*Variables computed in-between*/
		drop indu_code_prim occ_code_prim gross_income
		
		compress 
		
	   /*Save dataset including original and ilo variables*/
	
		save ${country}_${source}_${time}_FULL,  replace		
	
	   /* Save file only containing ilo_* variables*/
	
		keep ilo*

		save ${country}_${source}_${time}_ILO, replace
		
