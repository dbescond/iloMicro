* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Paraguay ECE
* DATASET USED: REG02_ECET
* NOTES: 
* Files created: Standard variables on ECE Paraguay
* Authors: DPAU
* Who last updated the file: DPAU
* Starting Date: 05 December 2017
* Last updated: 10 January 2018
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
global country "PRY"
global source "ECE"
global time "2016Q1"
global inputFile "REG02_ECET05.DTA"
global inpath "${path}\\${country}\\${source}\\${time}\ORI"
global temppath "${path}\_Admin"
global outpath "${path}\\${country}\\${source}\\${time}"
			
*********************************************************************************************
*********************************************************************************************

* Load original dataset

*********************************************************************************************
*********************************************************************************************
* Comment: - The original dataset was transferred to dta format using StatTransfer.

cd "$inpath"
  use "$inputFile", clear
  *renaming everything in lower case 
  rename *, lower

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

	gen ilo_wgt=fex
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
* Comment: - Information not available on the dataset downloaded from the NSO's website. 		 

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: 

	gen ilo_sex=.
	    replace ilo_sex=1 if p04==1
		replace ilo_sex=2 if p04==6
		        lab def ilo_sex_lab 1 "1 - Male" 2 "2 - Female"
		        lab var ilo_sex "Sex"
		        lab val ilo_sex ilo_sex_lab			
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Only available by 5 years bands.
*          - 5 years bands: the original category "60+" is mapped to "65+" and a note to value
*            is added to category 14 here [C6:1504]
*          - 10 years bands: category 6 excludes 60-64 [C6:4125]; category 7 includes 60-64 [C6:1504]
*          - Aggregated: category 4 excludes 60-64 [C6:4125]; category 5 includes 60-64. [C6:1504]

	* Age groups
	gen ilo_age_5yrbands=.
		replace ilo_age_5yrbands=1 if edad_quin==1
		replace ilo_age_5yrbands=2 if edad_quin==2
		replace ilo_age_5yrbands=3 if edad_quin==3
		replace ilo_age_5yrbands=4 if edad_quin==4
		replace ilo_age_5yrbands=5 if edad_quin==5
		replace ilo_age_5yrbands=6 if edad_quin==6
		replace ilo_age_5yrbands=7 if edad_quin==7
		replace ilo_age_5yrbands=8 if edad_quin==8
		replace ilo_age_5yrbands=9 if edad_quin==9
		replace ilo_age_5yrbands=10 if edad_quin==10
		replace ilo_age_5yrbands=11 if edad_quin==11
		replace ilo_age_5yrbands=12 if edad_quin==12
		*replace ilo_age_5yrbands=13 if
		replace ilo_age_5yrbands=14 if edad_quin==13                            // Including 60-64 [C6:1504]
			lab def age_by5_lab 1 "0-4" 2 "5-9" 3 "10-14" 4 "15-19" 5 "20-24" 6 "25-29" 7 "30-34" 8 "35-39" 9 "40-44" 10 "45-49" 11 "50-54" 12 "55-59" 13 "60-64" 14 "65+"
			lab val ilo_age_5yrbands age_by5_lab
			lab var ilo_age_5yrbands "Age (5-year age bands)"
			
	gen ilo_age_10yrbands=.
		replace ilo_age_10yrbands=1 if inrange(ilo_age_5yrbands,1,3)
		replace ilo_age_10yrbands=2 if inrange(ilo_age_5yrbands,4,5)
		replace ilo_age_10yrbands=3 if inrange(ilo_age_5yrbands,6,7)
		replace ilo_age_10yrbands=4 if inrange(ilo_age_5yrbands,8,9)
		replace ilo_age_10yrbands=5 if inrange(ilo_age_5yrbands,10,11)
		replace ilo_age_10yrbands=6 if ilo_age_5yrbands==12                     // Excluding 60-64 [C6:4125]
		replace ilo_age_10yrbands=7 if ilo_age_5yrbands==14                     // Including 60-64 [C6:1504]
			lab def age_by10_lab 1 "<15" 2 "15-24" 3 "25-34" 4 "35-44" 5 "45-54" 6 "55-64" 7 "65+"
			lab val ilo_age_10yrbands age_by10_lab
			lab var ilo_age_10yrbands "Age (10-year age bands)"
			
	gen ilo_age_aggregate=.
		replace ilo_age_aggregate=1 if inrange(ilo_age_5yrbands,1,3)
		replace ilo_age_aggregate=2 if inrange(ilo_age_5yrbands,4,5)
		replace ilo_age_aggregate=3 if inrange(ilo_age_5yrbands,6,11)           
		replace ilo_age_aggregate=4 if ilo_age_5yrbands==12                     // Excluding 60-64 [C6:4125]                   
		replace ilo_age_aggregate=5 if ilo_age_5yrbands==14                     // Including 60-64 [C6:1504]
			lab def age_aggr_lab 1 "<15" 2 "15-24" 3 "25-54" 4 "55-64" 5 "65+"
			lab val ilo_age_aggregate age_aggr_lab
			lab var ilo_age_aggregate "Age (Aggregate)"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Level of education ('ilo_edu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Question 4 in section 4 is not available (highest level of education) and therefore
*            this variable is not produced.
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education attendance ('ilo_edu_attendance') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Question is only asked to people aged 5 years old or more and therefore those below
*            this age are classified under "level not stated".

		gen ilo_edu_attendance=.
			replace ilo_edu_attendance=1 if ed05==20
			replace ilo_edu_attendance=2 if !inlist(ed05,20,.)
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
	    replace ilo_mrts_details=1 if p06==5                                    // Single
		replace ilo_mrts_details=2 if p06==1                                    // Married
		replace ilo_mrts_details=3 if p06==2                                    // Union / cohabiting
		replace ilo_mrts_details=4 if p06==4                                    // Widowed
		replace ilo_mrts_details=5 if inlist(p06,3,6)                           // Divorced / separated
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
* Comment: No information available.

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
* Comment: - wap = 15+ [category 4 in ilo_age_5yrbands]

	gen ilo_wap=.
		replace ilo_wap=1 if ilo_age_5yrbands>=4
			lab def wap_lab 1 "Working age population"
			lab val ilo_wap wap_lab
			label var ilo_wap "Working age population"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Labour Force Status ('ilo_lfs') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Employment comprises those who worked for at least one hour during the reference
*            week and those temporary absent.
*          - Unemployment follows ILO definition: not in employment, looking for a job during
*            the reference week (or 3 weeks before the reference week) and available; it also
*            includes those who are not looking for a job because they will start a new one 
*            within the following 30 days and were available during the reference period.

 
	gen ilo_lfs=.
	    replace ilo_lfs=1 if (a02==1 | a03==1) & ilo_wap==1                                                // Employed: worked for at least one hour last week or was absent.
		replace ilo_lfs=2 if (ilo_lfs!=1 & (a04==1 | a05==1) & inlist(a10,1,2)) & ilo_wap==1               // Unemployed (three criteria)
		replace ilo_lfs=2 if (ilo_lfs!=1 & (a04==6 & a05==6) & a09==10 & inlist(a10,1,2)) & ilo_wap==1     // Unemployment: future starters
		replace ilo_lfs=3 if !inlist(ilo_lfs,1,2) & ilo_wap==1                                             // Outside the labour force
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
		replace ilo_mjh=1 if b23==6 & ilo_lfs==1
		replace ilo_mjh=2 if b23==1 & ilo_lfs==1
		replace ilo_mjh=. if ilo_lfs!=1
			    lab def lab_ilo_mjh 1 "1 - One job only" 2 "2 - More than one job"
			    lab val ilo_mjh lab_ilo_mjh
			    lab var ilo_mjh "Multiple job holders"
				
***********************************************************************************************
*			PART 3.1. ECONOMIC CHARACTERISTICS FOR MAIN JOB 
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Status in employment ('ilo_job1_ste') [done]
* -------------------------------------------------------------------------------------------
* ------------------------------------------------------------------------------------------- 
* Comment: - Employees include domestic workers (note to value: C2:3881).

	* MAIN JOB	
	* Detailed categories
	  gen ilo_job1_ste_icse93=.
		  replace ilo_job1_ste_icse93=1 if inlist(b11,1,2,6) & ilo_lfs==1       // Employees (including domestic workers [C2:3881])
		  replace ilo_job1_ste_icse93=2 if b11==3 & ilo_lfs==1                  // Employers
		  replace ilo_job1_ste_icse93=3 if b11==4 & ilo_lfs==1                  // Own-account workers
		  *replace ilo_job1_ste_icse93=4 if                                     // Members of producers' cooperatives
		  replace ilo_job1_ste_icse93=5 if b11==5 & ilo_lfs==1                  // Contributing family workers
		  replace ilo_job1_ste_icse93=6 if ilo_job1_ste_icse93==. & ilo_lfs==1  // Not classifiable by status
			      label define label_ilo_ste_icse93 1 "1 - Employees" 2 "2 - Employers" 3 "3 - Own-account workers" 4 "4 - Members of producers' cooperatives" ///
			                                        5 "5 - Contributing family workers" 6 "6 - Workers not classifiable by status"
			      label val ilo_job1_ste_icse93 label_ilo_ste_icse93
			      label var ilo_job1_ste_icse93 "Status in employment (ICSE 93) - main job"

	* Aggregate categories
	gen ilo_job1_ste_aggregate=.
		replace ilo_job1_ste_aggregate=1 if ilo_job1_ste_icse93==1
		replace ilo_job1_ste_aggregate=2 if inlist(ilo_job1_ste_icse93,2,3,4,5)
		replace ilo_job1_ste_aggregate=3 if ilo_job1_ste_icse93==6
				lab def ste_aggr_lab 1 "1 - Employees" 2 "2 - Self-employed" 3 "3 - Not elsewhere classified"
				lab val ilo_job1_ste_aggregate ste_aggr_lab
			    label var ilo_job1_ste_aggregate "Status in employment (Aggregate) - main job"

	* SECOND JOB	
	* Detailed categories
	  gen ilo_job2_ste_icse93=.
		  replace ilo_job2_ste_icse93=1 if inlist(c08,1,2,6) & ilo_mjh==2       // Employees (including domestic workers [C2:3881])
		  replace ilo_job2_ste_icse93=2 if c08==3 & ilo_mjh==2                  // Employers
		  replace ilo_job2_ste_icse93=3 if c08==4 & ilo_mjh==2                  // Own-account workers
		  *replace ilo_job2_ste_icse93=4 if                                     // Members of producers' cooperatives
		  replace ilo_job2_ste_icse93=5 if c08==5 & ilo_mjh==2                  // Contributing family workers
		  replace ilo_job2_ste_icse93=6 if ilo_job2_ste_icse93==. & ilo_mjh==2  // Not classifiable by status
			      label val ilo_job2_ste_icse93 label_ilo_ste_icse93
			      label var ilo_job2_ste_icse93 "Status in employment (ICSE 93) - second job"

	* Aggregate categories
	gen ilo_job2_ste_aggregate=.
		replace ilo_job2_ste_aggregate=1 if ilo_job2_ste_icse93==1
		replace ilo_job2_ste_aggregate=2 if inlist(ilo_job2_ste_icse93,2,3,4,5)
		replace ilo_job2_ste_aggregate=3 if ilo_job2_ste_icse93==6
				lab val ilo_job2_ste_aggregate ste_aggr_lab
			    label var ilo_job2_ste_aggregate "Status in employment (Aggregate) - second job"

	  
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Original variable is mapped to ISIC aggregated level.
*          - In main and secondary job: Category 4 includes category 2 (note to value: [C5:1034])

    * MAIN JOB:
 	* Aggregate level	
	gen ilo_job1_eco_aggregate=.
		replace ilo_job1_eco_aggregate=1 if recb02==1 & ilo_lfs==1
		*replace ilo_job1_eco_aggregate=2 if
		replace ilo_job1_eco_aggregate=3 if recb02==4 & ilo_lfs==1
		replace ilo_job1_eco_aggregate=4 if inlist(recb02,2,3) & ilo_lfs==1     // Including Manufacturing: note to value [C5:1034]
		replace ilo_job1_eco_aggregate=5 if inlist(recb02,5,6,7) & ilo_lfs==1
		replace ilo_job1_eco_aggregate=6 if recb02==8 & ilo_lfs==1
		replace ilo_job1_eco_aggregate=7 if ilo_job1_eco_aggregate==. & ilo_lfs==1
			    lab def eco_aggr_lab 1 "1 - Agriculture" 2 "2 - Manufacturing" 3 "3 - Construction" 4 "4 - Mining and quarrying; Electricity, gas and water supply" ///
								     5 "5 - Market Services (Trade; Transportation; Accommodation and food; and Business and administrative services)"  ///
								     6 "6 - Non-market services (Public administration; Community, social and other services and activities)" 7 "7 - Not classifiable by economic activity"					
			    lab val ilo_job1_eco_aggregate eco_aggr_lab
			    lab var ilo_job1_eco_aggregate "Economic activity (Aggregate) - main job"
			
	* SECOND JOB:
	* Aggregate level	
	gen ilo_job2_eco_aggregate=.
		replace ilo_job2_eco_aggregate=1 if recc02==1 & ilo_mjh==2
		*replace ilo_job2_eco_aggregate=2 if
		replace ilo_job2_eco_aggregate=3 if recc02==4 & ilo_mjh==2
		replace ilo_job2_eco_aggregate=4 if inlist(recc02,2,3) & ilo_mjh==2     // Including Manufacturing: note to value [C5:1034]
		replace ilo_job2_eco_aggregate=5 if inlist(recc02,5,6,7) & ilo_mjh==2
		replace ilo_job2_eco_aggregate=6 if recc02==8 & ilo_mjh==2
		replace ilo_job2_eco_aggregate=7 if ilo_job2_eco_aggregate==. & ilo_mjh==2
		        * labels already defined for first job
			    lab val ilo_job2_eco_aggregate eco_aggr_lab
			    lab var ilo_job2_eco_aggregate "Economic activity (Aggregate) - second job"

	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_ocu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Original classification follows ISCO-08 at one-digit level.

    * MAIN JOB:
    * One digit-level
	gen ilo_job1_ocu_isco08=.
	    replace ilo_job1_ocu_isco08=1 if (recb01==1) & ilo_lfs==1
		replace ilo_job1_ocu_isco08=2 if (recb01==2) & ilo_lfs==1
		replace ilo_job1_ocu_isco08=3 if (recb01==3) & ilo_lfs==1
		replace ilo_job1_ocu_isco08=4 if (recb01==4) & ilo_lfs==1
		replace ilo_job1_ocu_isco08=5 if (recb01==5) & ilo_lfs==1
		replace ilo_job1_ocu_isco08=6 if (recb01==6) & ilo_lfs==1
		replace ilo_job1_ocu_isco08=7 if (recb01==7) & ilo_lfs==1
		replace ilo_job1_ocu_isco08=8 if (recb01==8) & ilo_lfs==1
		replace ilo_job1_ocu_isco08=9 if (recb01==9) & ilo_lfs==1
		replace ilo_job1_ocu_isco08=10 if (recb01==10) & ilo_lfs==1
		replace ilo_job1_ocu_isco08=11 if (ilo_job1_ocu_isco08==.) & ilo_lfs==1
	            lab def ocu08_1digit 1 "1 - Legislators, senior officials and managers"	2 "2 - Professionals" 3 "3 - Technicians and associate professionals" 4 "4 - Clerks"	///
                                     5 "5 - Service workers and shop and market sales workers"	6 "6 - Skilled agricultural and fishery workers"	7 "7 - Craft and related trades workers"	8 "8 - Plant and machine operators and assemblers"	///
                                     9 "9 - Elementary occupations"	10 "0 - Armed forces"	11 "11 - Not elsewhere classified"		
				lab val ilo_job1_ocu_isco08 ocu08_1digit
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
	gen ilo_job1_ocu_skill=.
	    replace ilo_job1_ocu_skill=1 if ilo_job1_ocu_isco08==9                   // Low
		replace ilo_job1_ocu_skill=2 if inlist(ilo_job1_ocu_isco08,4,5,6,7,8)    // Medium
		replace ilo_job1_ocu_skill=3 if inlist(ilo_job1_ocu_isco08,1,2,3)        // High
		replace ilo_job1_ocu_skill=4 if inlist(ilo_job1_ocu_isco08,10,11)        // Not elsewhere classified
				lab def ocu_skill_lab 1 "1 - Skill level 1 (low)" 2 "2 - Skill level 2 (medium)" 3 "3 - Skill levels 3 and 4 (high)" 4 "4 - Not elsewhere classified"
			    lab val ilo_job1_ocu_skill ocu_skill_lab
			    lab var ilo_job1_ocu_skill "Occupation (Skill level) - main job"

	* SECOND JOB:
    * One digit-level
	gen ilo_job2_ocu_isco08=.
	    replace ilo_job2_ocu_isco08=1 if (recc01==1) & ilo_mjh==2
		replace ilo_job2_ocu_isco08=2 if (recc01==2) & ilo_mjh==2
		replace ilo_job2_ocu_isco08=3 if (recc01==3) & ilo_mjh==2
		replace ilo_job2_ocu_isco08=4 if (recc01==4) & ilo_mjh==2
		replace ilo_job2_ocu_isco08=5 if (recc01==5) & ilo_mjh==2
		replace ilo_job2_ocu_isco08=6 if (recc01==6) & ilo_mjh==2
		replace ilo_job2_ocu_isco08=7 if (recc01==7) & ilo_mjh==2
		replace ilo_job2_ocu_isco08=8 if (recc01==8) & ilo_mjh==2
		replace ilo_job2_ocu_isco08=9 if (recc01==9) & ilo_mjh==2
		replace ilo_job2_ocu_isco08=10 if (recc01==10) & ilo_mjh==2
		replace ilo_job2_ocu_isco08=11 if (ilo_job2_ocu_isco08==.) & ilo_mjh==2
				lab val ilo_job2_ocu_isco08 ocu08_1digit
				lab var ilo_job2_ocu_isco08 "Occupation (ISCO-08) - second job"
			
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
			    lab var ilo_job2_ocu_aggregate "Occupation (Aggregate) - second job"	
		
	* Skill level
	gen ilo_job2_ocu_skill=.
	    replace ilo_job2_ocu_skill=1 if ilo_job2_ocu_isco08==9                   // Low
		replace ilo_job2_ocu_skill=2 if inlist(ilo_job2_ocu_isco08,4,5,6,7,8)    // Medium
		replace ilo_job2_ocu_skill=3 if inlist(ilo_job2_ocu_isco08,1,2,3)        // High
		replace ilo_job2_ocu_skill=4 if inlist(ilo_job2_ocu_isco08,10,11)        // Not elsewhere classified
			    lab val ilo_job2_ocu_skill ocu_skill_lab
			    lab var ilo_job2_ocu_skill "Occupation (Skill level) - second job"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_ins_sector') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Public: public employees.


	* MAIN JOB:
	gen ilo_job1_ins_sector=.
		replace ilo_job1_ins_sector=1 if b11==1 & ilo_lfs==1
        replace ilo_job1_ins_sector=2 if ilo_job1_ins_sector==. & ilo_lfs==1
                lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
			    lab values ilo_job1_ins_sector ins_sector_lab
			    lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities - main job"
				
	* SECOND JOB:
	gen ilo_job2_ins_sector=.
		replace ilo_job2_ins_sector=1 if c08==1 & ilo_lfs==1
        replace ilo_job2_ins_sector=2 if ilo_job2_ins_sector==. & ilo_lfs==1
			    lab values ilo_job2_ins_sector ins_sector_lab
			    lab var ilo_job2_ins_sector "Institutional sector (private/public) of economic activities - second job"	
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Informal/Formal economy: ('ilo_job1_ife_prod' and 'ilo_job1_ife_nature') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Information on registration or bookkeeping is only available from 2012 onwards.

		
  * Social security (to be dropped afterwards)
	gen social_security=.
	    replace social_security=1 if (b10==1 & ilo_lfs==1)          // Pension
		replace social_security=2 if (b10==6 & ilo_lfs==1)          // No pension
		replace social_security=. if (social_security==. & ilo_lfs==1)
		
* Year as a local
  decode ilo_time, gen(to_drop)
  split to_drop, generate(to_drop_) parse(Q)
  destring to_drop_1, replace force
  local Y = to_drop_1 in 1


if (`Y'<=2011){
   * No information available on registration nor on bookkeeping.
}

if (`Y'>=2012){ 
/* Useful questions:
		  * Institutional sector: b11
		  * Destination of production: not asked
		  * Bookkeeping: b22c
		  * Registration: b22a (not asked to public employees nor to domestic employees)
		  * Status in employment: ilo_job1_ste_icse93==1 (employees)
		  * Social security contribution (retirement fund): b10
		  * Place of work: not asked
		  * Size: b08
		  * Private HH: not asked
		  * Paid annual leave: not asked
		  * Paid sick leave: not asked
*/
				
    * 1) UNIT OF PRODUCTION: FORMAL/INFORMAL SECTOR		
    gen ilo_job1_ife_prod=.
		replace ilo_job1_ife_prod=1 if ilo_lfs==1 & ///
		                               ((b11!=1 & inlist(b22c,2,3,.) & inlist(b22a,2,3)) | ///
									   (b11!=1 & inlist(b22c,2,3,.) & b22a==. & ilo_job1_ste_icse93==1 & social_security==2) | ///
									   (b11!=1 & inlist(b22c,2,3,.) & b22a==. & ilo_job1_ste_icse93!=1))
		replace ilo_job1_ife_prod=2 if ilo_lfs==1 & ilo_job1_ife_prod!=1 & ///
		                               ((b11==1) | ///
									   (b11!=1 & b22c==1) | ///
									   (b11!=1 & inlist(b22c,2,3,.) & b22a==1) | ///
									   (b11!=1 & inlist(b22c,2,3,.) & b22a==. & ilo_job1_ste_icse93==1 & social_security==1))
		replace ilo_job1_ife_prod=3 if ilo_lfs==1 & !inlist(ilo_job1_ife_prod,1,2) 
				lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 
				lab val ilo_job1_ife_prod ilo_ife_prod_lab
				lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"		
						
						
	* 2) NATURE OF JOB: FORMAL/INFORMAL EMPLOYMENT
	gen ilo_job1_ife_nature=.
	    replace ilo_job1_ife_nature=1 if ilo_lfs==1 & ///
	                                     ((inlist(ilo_job1_ste_icse93,1,6) & inlist(social_security,2,.)) | ///
										 (inlist(ilo_job1_ste_icse93,2,4) & inlist(ilo_job1_ife_prod,1,3)) | ///
										 (ilo_job1_ste_icse93==3 & inlist(ilo_job1_ife_prod,1,3)) | ///
										 (ilo_job1_ste_icse93==5))
	    replace ilo_job1_ife_nature=2 if ilo_lfs==1 & ///
			                             ((inlist(ilo_job1_ste_icse93,1,6) & social_security==1) | ///
										 (inlist(ilo_job1_ste_icse93,2,4) & ilo_job1_ife_prod==2) | ///
										 (ilo_job1_ste_icse93==3 & ilo_job1_ife_prod==2))
	    replace ilo_job1_ife_nature=. if (ilo_job1_ife_nature==. & ilo_lfs!=1)
                lab def ife_nature_lab 1 "1 - Persons with informal main job" 2 "2 - Persons with formal main job"
		        lab val ilo_job1_ife_nature ife_nature_lab
		        lab var ilo_job1_ife_nature "Informal / Formal Economy (Nature of job)"	
}				
				
***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		
				
* --------------------------------------------------------------------------------------------------
* --------------------------------------------------------------------------------------------------
*		                 Hours of work ('ilo_how') [done]
* --------------------------------------------------------------------------------------------------
* --------------------------------------------------------------------------------------------------
* Comment:  - Due to the way that the original question is asked, a calculation of the total daily
*             time is computed prior to the mapping.

foreach var of varlist b03* {

    /* hours: taking only the integer*/
	gen hour_`var' = int(`var')
	/* minutes: substracting original variables minus hours*/
	gen minute_`var' = (`var' - hour_`var')
	    /* control*/
	    replace minute_`var' = 0 if minute_`var' > 0.601
		replace hour_`var' = 0 if hour_`var' == 99
		
	/* tranferring minutes to proportion of the hour*/
	replace minute_`var' =  minute_`var'/0.60
	
	/* total daily time*/
	gen tot_`var' = hour_`var' + minute_`var'
}
	* MAIN JOB:
	* 1) Weekly hours ACTUALLY worked:
	
	egen ilo_job1_how_actual = rowtotal(tot_*), m 
		 replace ilo_job1_how_actual=. if ilo_lfs!=1
	             lab var ilo_job1_how_actual "Weekly hours actually worked - main job"
					
   gen ilo_job1_how_actual_bands=.
	   replace ilo_job1_how_actual_bands=1 if ilo_job1_how_actual==0
	   replace ilo_job1_how_actual_bands=2 if ilo_job1_how_actual>=1 & ilo_job1_how_actual<=14
	   replace ilo_job1_how_actual_bands=3 if ilo_job1_how_actual>14 & ilo_job1_how_actual<=29
	   replace ilo_job1_how_actual_bands=4 if ilo_job1_how_actual>29 & ilo_job1_how_actual<=34
	   replace ilo_job1_how_actual_bands=5 if ilo_job1_how_actual>34 & ilo_job1_how_actual<=39
	   replace ilo_job1_how_actual_bands=6 if ilo_job1_how_actual>39 & ilo_job1_how_actual<=48
	   replace ilo_job1_how_actual_bands=7 if ilo_job1_how_actual>48 & ilo_job1_how_actual!=.
	   replace ilo_job1_how_actual_bands=8 if ilo_job1_how_actual==. & ilo_lfs==1
	   replace ilo_job1_how_actual_bands=. if ilo_lfs!=1
		   	   lab def how_bands_lab 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"
				   lab val ilo_job1_how_actual_bands how_bands_lab
				   lab var ilo_job1_how_actual_bands "Weekly hours actually worked bands - main job"
		
	* 2) Weekly hours USUALLY worked:
	gen ilo_job1_how_usual = ilo_job1_how_actual if b04==1 & ilo_lfs==1
	    replace ilo_job1_how_usual = b06 if inlist(b04,2,3) & ilo_lfs==1
			    lab var ilo_job1_how_usual "Weekly hours usually worked - main job"
					 
	gen ilo_job1_how_usual_bands=.
	 	replace ilo_job1_how_usual_bands=1 if ilo_job1_how_usual==0
		replace ilo_job1_how_usual_bands=2 if ilo_job1_how_usual>=1 & ilo_job1_how_usual<=14
		replace ilo_job1_how_usual_bands=3 if ilo_job1_how_usual>14 & ilo_job1_how_usual<=29
		replace ilo_job1_how_usual_bands=4 if ilo_job1_how_usual>29 & ilo_job1_how_usual<=34
		replace ilo_job1_how_usual_bands=5 if ilo_job1_how_usual>34 & ilo_job1_how_usual<=39
		replace ilo_job1_how_usual_bands=6 if ilo_job1_how_usual>39 & ilo_job1_how_usual<=48
		replace ilo_job1_how_usual_bands=7 if ilo_job1_how_usual>48 & ilo_job1_how_usual!=.
		replace ilo_job1_how_usual_bands=8 if ilo_job1_how_usual==. & ilo_lfs==1
		replace ilo_job1_how_usual_bands=. if ilo_lfs!=1
				lab val ilo_job1_how_usual_bands how_bands_lab
				lab var ilo_job1_how_usual_bands "Weekly hours usually worked bands - main job"
		
		
	* SECOND JOB
	* 1) Weekly hours ACTUALLY worked in second job:
    gen ilo_job2_how_actual = c03 if ilo_mjh==2
	    replace ilo_job2_how_actual=. if ilo_job2_how_actual<0
			    lab var ilo_job2_how_actual "Weekly hours actually worked - second job"
		
	gen ilo_job2_how_actual_bands=.
	    replace ilo_job2_how_actual_bands=1 if ilo_job2_how_actual==0
		replace ilo_job2_how_actual_bands=2 if ilo_job2_how_actual>=1 & ilo_job2_how_actual<=14
		replace ilo_job2_how_actual_bands=3 if ilo_job2_how_actual>14 & ilo_job2_how_actual<=29
		replace ilo_job2_how_actual_bands=4 if ilo_job2_how_actual>29 & ilo_job2_how_actual<=34
		replace ilo_job2_how_actual_bands=5 if ilo_job2_how_actual>34 & ilo_job2_how_actual<=39
		replace ilo_job2_how_actual_bands=6 if ilo_job2_how_actual>39 & ilo_job2_how_actual<=48
		replace ilo_job2_how_actual_bands=7 if ilo_job2_how_actual>48 & ilo_job2_how_actual!=.
		replace ilo_job2_how_actual_bands=8 if ilo_job2_how_actual==. & ilo_mjh==2
		replace ilo_job2_how_actual_bands=. if ilo_mjh!=2
		   	    lab val ilo_job2_how_actual_bands how_bands_lab
					lab var ilo_job2_how_actual_bands "Weekly hours actually worked bands - second job"
		
	* 2) Weekly hours USUALLY worked in second job:
	gen ilo_job2_how_usual = ilo_job2_how_actual if c04==1 & ilo_mjh==2
	    replace ilo_job2_how_usual = c05 if c04==6 & ilo_mjh==2
			    lab var ilo_job2_how_usual "Weekly hours usually worked - second job"
					 
	gen ilo_job2_how_usual_bands=.
	 	replace ilo_job2_how_usual_bands=1 if ilo_job2_how_usual==0
		replace ilo_job2_how_usual_bands=2 if ilo_job2_how_usual>=1 & ilo_job2_how_usual<=14
		replace ilo_job2_how_usual_bands=3 if ilo_job2_how_usual>14 & ilo_job2_how_usual<=29
		replace ilo_job2_how_usual_bands=4 if ilo_job2_how_usual>29 & ilo_job2_how_usual<=34
		replace ilo_job2_how_usual_bands=5 if ilo_job2_how_usual>34 & ilo_job2_how_usual<=39
		replace ilo_job2_how_usual_bands=6 if ilo_job2_how_usual>39 & ilo_job2_how_usual<=48
		replace ilo_job2_how_usual_bands=7 if ilo_job2_how_usual>48 & ilo_job2_how_usual!=.
		replace ilo_job2_how_usual_bands=8 if ilo_job2_how_usual==. & ilo_mjh==2
				lab val ilo_job2_how_usual_bands how_bands_lab
				lab var ilo_job2_how_usual_bands "Weekly hours usually worked bands - second job"

	* OTHER JOBS
	* 1) Weekly hours ACTUALLY worked in other job:
    gen ilo_job3_how_actual = c12 if ilo_mjh==2
	    replace ilo_job3_how_actual=. if ilo_job3_how_actual<0
		
	* 2) Weekly hours USUALLY worked in other job:
	gen ilo_job3_how_usual = ilo_job3_how_actual if c13==1 & ilo_mjh==2
	    replace ilo_job3_how_usual = c14 if c13==6 & ilo_mjh==2
		
	* ALL JOBS:
	* 1) Weekly hours ACTUALLY worked in all jobs:
	egen ilo_joball_how_actual = rowtotal(ilo_job1_how_actual ilo_job2_how_actual ilo_job3_how_actual), m 
		 lab var ilo_joball_how_actual "Weekly hours actually worked in all jobs"
						
	gen ilo_joball_actual_how_bands=.
	    replace ilo_joball_actual_how_bands=1 if ilo_joball_how_actual==0
		replace ilo_joball_actual_how_bands=2 if ilo_joball_how_actual>=1 & ilo_joball_how_actual<=14
		replace ilo_joball_actual_how_bands=3 if ilo_joball_how_actual>14 & ilo_joball_how_actual<=29
		replace ilo_joball_actual_how_bands=4 if ilo_joball_how_actual>29 & ilo_joball_how_actual<=34
		replace ilo_joball_actual_how_bands=5 if ilo_joball_how_actual>34 & ilo_joball_how_actual<=39
		replace ilo_joball_actual_how_bands=6 if ilo_joball_how_actual>39 & ilo_joball_how_actual<=48
		replace ilo_joball_actual_how_bands=7 if ilo_joball_how_actual>48 & ilo_joball_how_actual!=.
		replace ilo_joball_actual_how_bands=8 if ilo_joball_actual_how_bands==. & ilo_lfs==1
		replace ilo_joball_actual_how_bands=. if ilo_lfs!=1
			 	lab val ilo_joball_actual_how_bands how_bands_lab
				lab var ilo_joball_actual_how_bands "Weekly hours actually worked bands in all jobs"
					
	* 2) Weekly hours USUALLY worked in all jobs:
	egen ilo_joball_how_usual = rowtotal(ilo_job1_how_usual ilo_job2_how_usual ilo_job3_how_usual), m 
		 lab var ilo_joball_how_usual "Weekly hours usually worked in all jobs"
						
	gen ilo_joball_usual_how_bands=.
	    replace ilo_joball_usual_how_bands=1 if ilo_joball_how_usual==0
		replace ilo_joball_usual_how_bands=2 if ilo_joball_how_usual>=1 & ilo_joball_how_usual<=14
		replace ilo_joball_usual_how_bands=3 if ilo_joball_how_usual>14 & ilo_joball_how_usual<=29
		replace ilo_joball_usual_how_bands=4 if ilo_joball_how_usual>29 & ilo_joball_how_usual<=34
		replace ilo_joball_usual_how_bands=5 if ilo_joball_how_usual>34 & ilo_joball_how_usual<=39
		replace ilo_joball_usual_how_bands=6 if ilo_joball_how_usual>39 & ilo_joball_how_usual<=48
		replace ilo_joball_usual_how_bands=7 if ilo_joball_how_usual>48 & ilo_joball_how_usual!=.
		replace ilo_joball_usual_how_bands=8 if ilo_joball_usual_how_bands==. & ilo_lfs==1
		replace ilo_joball_usual_how_bands=. if ilo_lfs!=1
			 	lab val ilo_joball_usual_how_bands how_bands_lab
				lab var ilo_joball_usual_how_bands "Weekly hours usually worked bands in all jobs"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
* Comment: - Threshold is set at 40 hours usually worked in all jobs per week.
	
	gen ilo_job1_job_time=.
		replace ilo_job1_job_time=2 if ilo_joball_how_usual>=40 & ilo_lfs==1               // Full-time
		replace ilo_job1_job_time=1 if ilo_joball_how_usual<40 & ilo_lfs==1 & ilo_lfs==1   // Part-time
		replace ilo_job1_job_time=3 if ilo_job1_job_time==. & ilo_lfs==1
			    lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
			    lab val ilo_job1_job_time job_time_lab
			    lab var ilo_job1_job_time "Job (Working time arrangement)"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job_contract') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
* Comment: - Permanent: "contrato indefinido"
*          - Temporary: "contrato definido", without contract (verbal), probation period.
	
	gen ilo_job1_job_contract=.
		replace ilo_job1_job_contract=1 if b22==1 & ilo_job1_ste_aggregate==1
		replace ilo_job1_job_contract=2 if inlist(b22,2,3,4) & ilo_job1_ste_aggregate==1
		replace ilo_job1_job_contract=3 if ilo_job1_job_contract==. & ilo_job1_ste_aggregate==1
				lab def job_contract_lab 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"
			    lab val ilo_job1_job_contract job_contract_lab
			    lab var ilo_job1_job_contract "Job (Type of contract)"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Monthly related income ('ilo_job1_lri')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment:

	* MAIN JOB
	* Employees
	gen ilo_job1_lri_ees=.
	    replace ilo_job1_lri_ees = e01a if ilo_job1_ste_aggregate==1
	            lab var ilo_job1_lri_ees "Monthly earnings of employees - main job"
				 
	* Self-employed
	gen ilo_job1_lri_slf = e01a if ilo_job1_ste_aggregate==2
	    lab var ilo_job1_lri_slf "Monthly labour related income of self-employed - main job"		 
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_tru') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - National threshold is set at 30 hours worked in all jobs per week (methodological
*            document).
*          - Want to work addtional hours is captured through question d01 (want to improve, change
*            or add a job).
			
	gen ilo_joball_tru=.
	    replace ilo_joball_tru=1 if inlist(d01,1,2,3) & d04==1 & ilo_joball_how_usual<=30 & ilo_lfs==1
		replace ilo_joball_tru=. if ilo_lfs!=1
		        lab def tru_lab 1 "Time-related underemployment"
		        lab val ilo_joball_tru tru_lab
		        lab var ilo_joball_tru "Time-related underemployment"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupational injury ('ilo_joball_inj') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
* Comment: - No information available.

*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Days lost due to cases of occupational injury ('ilo_joball_oi_day') [done]
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
* Comment: - No information available.

***********************************************************************************************
*			PART 3.3. UNEMPLOYMENT: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Category of unemployment ('ilo_cat_une') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: 

	gen ilo_cat_une=.
		replace ilo_cat_une=1 if a12==1 & ilo_lfs==2			                // Previously employed
		replace ilo_cat_une=2 if a12==6 & ilo_lfs==2			                // Seeking first job
		replace ilo_cat_une=3 if ilo_lfs==2 & !inlist(ilo_cat_une,1,2)	        // Unkown
			    lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
			    lab val ilo_cat_une cat_une_lab
			    lab var ilo_cat_une "Category of unemployment"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Original question: "how long have you been without a job and actively looking for
*            one or trying to establish a business by yourself?"

    * Preparation of the varaibles:
	gen duration_1 = a07a*12 if ilo_lfs==2        // Years to months
	gen duration_2 = a07m if ilo_lfs==2           // Month
	gen duration_3 = a07s/(52/12) if ilo_lfs==2   // Week to months
	
	egen duration = rowtotal(duration_*), m
	     replace duration =. if duration == 0


	* Detailed categories		
    gen ilo_dur_details=.
	    replace ilo_dur_details=1 if duration>=0 & duration<1 & ilo_lfs==2      // Less than 1 month
		replace ilo_dur_details=2 if duration>=1 & duration<3 & ilo_lfs==2      // 1 to 3 months
		replace ilo_dur_details=3 if duration>=3 & duration<6 & ilo_lfs==2      // 3 to 6 months
		replace ilo_dur_details=4 if duration>=6 & duration<12 & ilo_lfs==2     // 6 to 12 months
		replace ilo_dur_details=5 if duration>=12 & duration<24 & ilo_lfs==2    // 12 to 24 months 
		replace ilo_dur_details=6 if duration>=24 & duration!=. & ilo_lfs==2    // 24 months or more
		replace ilo_dur_details=7 if ilo_dur_details==. & ilo_lfs==2            // Not elsewhere classified
		        lab def ilo_unemp_det 1 "1 - Less than 1 month" 2 "2 - 1 month to less than 3 months" 3 "3 - 3 months to less than 6 months" ///
									  4 "4 - 6 months to less than 12 months" 5 "5 - 12 months to less than 24 months" 6 "6 - 24 months or more" ///
									  7 "7 - Not elsewhere classified"
			    lab val ilo_dur_details ilo_unemp_det
			    lab var ilo_dur_details "Duration of unemployment (Details)"

    * Aggregate categories
	gen ilo_dur_aggregate=.
		replace ilo_dur_aggregate=1 if (inlist(ilo_dur_details,1,2,3) & ilo_lfs==2)   // Less than 6 months
		replace ilo_dur_aggregate=2 if (ilo_dur_details==4 & ilo_lfs==2)              // 6 to 12 months
		replace ilo_dur_aggregate=3 if (inlist(ilo_dur_details,5,6) & ilo_lfs==2)     // 12 months or more
		replace ilo_dur_aggregate=4 if (ilo_dur_details==7 & ilo_lfs==2)              // Not elsewhere classified
		replace ilo_dur_aggregate=. if ilo_lfs!=2
			    lab def ilo_unemp_aggr 1 "1 - Less than 6 months" 2 "2 - 6 months to less than 12 months" 3 "3 - 12 months or more" 4 "4 - Not elsewhere classified"
			    lab val ilo_dur_aggregate ilo_unemp_aggr
			    lab var ilo_dur_aggregate "Duration of unemployment (Aggregate)"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Original variable is mapped to ISIC aggregated level.
*          - Category 4 here includes category 2.
	
    * Aggregate level
	gen ilo_preveco_aggregate=.
		replace ilo_preveco_aggregate=1 if reca14==1 & ilo_lfs==2 & ilo_cat_une==1
		*replace ilo_preveco_aggregate=2 if 
		replace ilo_preveco_aggregate=3 if reca14==4 & ilo_lfs==2 & ilo_cat_une==1
		replace ilo_preveco_aggregate=4 if inlist(reca14,2,3) & ilo_lfs==2 & ilo_cat_une==1    // Including Manufacturing: note to value [C5:1034]
		replace ilo_preveco_aggregate=5 if inlist(reca14,5,6,7) & ilo_lfs==2 & ilo_cat_une==1
		replace ilo_preveco_aggregate=6 if reca14==8 & ilo_lfs==2 & ilo_cat_une==1
		replace ilo_preveco_aggregate=7 if ilo_preveco_aggregate==. & ilo_lfs==2 & ilo_cat_une==1
			    lab val ilo_preveco_aggregate eco_aggr_lab
			    lab var ilo_preveco_aggregate "Previous economic activity (Aggregate)"
 				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu_isco88') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Original classification follows ISCO-08.

    * One digit-level
	gen ilo_prevocu_isco08=.
	    replace ilo_prevocu_isco08=1 if (reca13==1) & ilo_lfs==2 & ilo_cat_une==1
		replace ilo_prevocu_isco08=2 if (reca13==2) & ilo_lfs==2 & ilo_cat_une==1
		replace ilo_prevocu_isco08=3 if (reca13==3) & ilo_lfs==2 & ilo_cat_une==1
		replace ilo_prevocu_isco08=4 if (reca13==4) & ilo_lfs==2 & ilo_cat_une==1
		replace ilo_prevocu_isco08=5 if (reca13==5) & ilo_lfs==2 & ilo_cat_une==1
		replace ilo_prevocu_isco08=6 if (reca13==6) & ilo_lfs==2 & ilo_cat_une==1
		replace ilo_prevocu_isco08=7 if (reca13==7) & ilo_lfs==2 & ilo_cat_une==1
		replace ilo_prevocu_isco08=8 if (reca13==8) & ilo_lfs==2 & ilo_cat_une==1
		replace ilo_prevocu_isco08=9 if (reca13==9) & ilo_lfs==2 & ilo_cat_une==1
		replace ilo_prevocu_isco08=10 if (reca13==10) & ilo_lfs==2 & ilo_cat_une==1
		replace ilo_prevocu_isco08=11 if (ilo_prevocu_isco08==.) & ilo_lfs==2 & ilo_cat_une==1
				lab val ilo_prevocu_isco08 ocu08_1digit
				lab var ilo_prevocu_isco08 "Previous occupation (ISCO-88)"
				
	* Aggregate:			
	gen ilo_prevocu_aggregate=.
		replace ilo_prevocu_aggregate=1 if inrange(ilo_prevocu_isco08,1,3)
		replace ilo_prevocu_aggregate=2 if inlist(ilo_prevocu_isco08,4,5)
		replace ilo_prevocu_aggregate=3 if inlist(ilo_prevocu_isco08,6,7)
		replace ilo_prevocu_aggregate=4 if ilo_prevocu_isco08==8
		replace ilo_prevocu_aggregate=5 if ilo_prevocu_isco08==9
		replace ilo_prevocu_aggregate=6 if ilo_prevocu_isco08==10
		replace ilo_prevocu_aggregate=7 if ilo_prevocu_isco08==11
				lab val ilo_prevocu_aggregate ocu_aggr_lab
				lab var ilo_prevocu_aggregate "Previous occupation (Aggregate)"				
				
    * Skill level				
    gen ilo_prevocu_skill=.
	    replace ilo_prevocu_skill=1 if ilo_prevocu_isco08==9                   // Low
		replace ilo_prevocu_skill=2 if inlist(ilo_prevocu_isco08,4,5,6,7,8)    // Medium
		replace ilo_prevocu_skill=3 if inlist(ilo_prevocu_isco08,1,2,3)        // High
		replace ilo_prevocu_skill=4 if inlist(ilo_prevocu_isco08,10,11)        // Not elsewhere classified
			    lab val ilo_prevocu_skill ocu_skill_lab
			    lab var ilo_prevocu_skill "Previous occupation (Skill level)"

***********************************************************************************************
*			PART 3.3. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - No information available concerning willingness, therefore, categories 3 and 4
*            are not possible to be produced.

	gen ilo_olf_dlma=.
		replace ilo_olf_dlma = 1 if ((a04==1 | a05==1) & a10==6 & ilo_lfs==3)	         // Seeking, not available
		replace ilo_olf_dlma = 2 if ((a04==6 & a05==6) & inlist(a10,1,2) & ilo_lfs==3)	 // Not seeking, available
		*replace ilo_olf_dlma = 3 if 		                                             // Not seeking, not available, willing
		*replace ilo_olf_dlma = 4 if 		                                             // Not seeking, not available, not willing
		replace ilo_olf_dlma = 5 if	(ilo_olf_dlma==. & ilo_lfs==3)				         // Not classified 
	 		lab def dlma_lab 1 "1 - Seeking, not available (Unavailable jobseekers)" 2 "2 - Not seeking, available (Available potential jobseekers)" ///
							 3 "3 - Not seeking, not available, willing (Willing non-jobseekers)" 4 "4 - Not seeking, not available, not willing" 5 "X - Not elsewhere classified"
			lab val ilo_olf_dlma dlma_lab 
			lab var ilo_olf_dlma "Labour market attachment (Degree of)"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reasons for not seeking a job ('ilo_olf_reason') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment:
	
	gen ilo_olf_reason=.
		replace ilo_olf_reason=1 if inlist(a09,2,3,4,5) & ilo_lfs==3            // Labour market
		replace ilo_olf_reason=2 if a09==9 & ilo_lfs==3                         // Other labour market reasons
		replace ilo_olf_reason=3 if inlist(a09,6,7,11,12,16) & ilo_lfs==3       // Personal/Family-related
		replace ilo_olf_reason=4 if inlist(a09,1,13,14,15) & ilo_lfs==3         // Does not need/want to work
		replace ilo_olf_reason=5 if ilo_olf_reason==. & ilo_lfs==3              // Not elsewhere classified
 			    lab def lab_olf_reason 1 "1 - Labour market" 2 " 2 - Other labour market reasons" 3 "3 - Personal/Family-related"  ///
				                       4 "4 - Does not need/want to work" 5 "5 - Not elsewhere classified"
		        lab val ilo_olf_reason lab_olf_reason
			    lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seekers ('ilo_dis') [done]
* -------------------------------------------------------------------------------------------
* ------------------------------------------------------------------------------------------- 
* Comment: 

	gen ilo_dis=.
	    replace ilo_dis=1 if !inlist(ilo_lfs,1,2) & (inlist(a10,1,2)) & (ilo_olf_reason==1)
			    lab def ilo_dis_lab 1 "Discouraged job-seekers" 
			    lab val ilo_dis ilo_dis_lab
			    lab var ilo_dis "Discouraged job-seekers"			
			
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
		
		/*Variables computed in-between*/
		drop social_security to_drop* hour_* minute_* tot_* ilo_job3_how_actual ilo_job3_how_usual duration_* duration 
		
		compress 
		
	   /*Save dataset including original and ilo variables*/
		save ${country}_${source}_${time}_FULL,  replace		
	
	   /* Save file only containing ilo_* variables*/
		keep ilo*

		save ${country}_${source}_${time}_ILO, replace
		



