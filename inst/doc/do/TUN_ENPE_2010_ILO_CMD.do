* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Tunisia
* DATASET USED: Tunisia LFS 
* NOTES: 
* Files created: Standard variables on LFS
* Authors: Podjanin
* Who last updated the file: Podjanin, A.
* Starting Date: 13 October 2017
* Last updated: 24 October 2017 
***********************************************************************************************


*******************************************************************
 /* 1.	Set up work directory, file name, variables and function */
*******************************************************************


clear all 

set more off

global path "J:\COMMON\STATISTICS\DPAU\MICRO"
global country "TUN"
global source "ENPE"
global time "2010"
global inputFile "TUN_ENPE_2010_ORI.dta"

global inpath "${path}\\${country}\\${source}\\${time}\ORI"
global outpath "${path}\\${country}\\${source}\\${time}"

*********************************************************************************************

* Load original dataset

*********************************************************************************************

cd "$inpath"

	use "$inputFile", clear	
		
	rename *, lower
	
*********************************************************************************************

* Create help variables for the time period considered
	
	gen year = "${time}"
		destring year, replace
	
	* don't consider observations not having a weight associated and not having any info about the sex of the person
	
	gen considered=1 if v_200!=.
	replace considered=. if v_205==.
	
	* refer to list of variables available under the following link (with value labels): http://catalog.ihsn.org/index.php/catalog/4362/datafile/F2 
		* otherwise questionnaire in Arabic only available for 2010 --> use translation in French for 2012
	
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
*			Identifier ('ilo_key') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*		

	gen ilo_key=_n if considered==1
		lab var ilo_key "Key unique identifier per individual"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sample Weight ('ilo_wgt') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*		
* Comment: 

	gen ilo_wgt=v_200
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
*
* Comment :
			
		gen ilo_geo=v_011
			lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural"
			lab val ilo_geo ilo_geo_lab
			lab var ilo_geo "Geographical coverage"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: 

		gen ilo_sex=v_205
				label define label_Sex 1 "1 - Male" 2 "2 - Female"
				label values ilo_sex label_Sex
				lab var ilo_sex "Sex"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: 
		
	gen ilo_age=v_210tr
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
*			Level of education ('ilo_edu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: Note that according to the definition, the highest level being CONCLUDED is being considered

	* define only aggregate level -> more detailed variables are available in 2010 dataset, but only aggregate variable considered in order
		* to have a consistent time series
		
		
		gen ilo_edu_aggregate=.
			replace ilo_edu_aggregate=1 if v_240==1
			replace ilo_edu_aggregate=2 if v_240==2
			replace ilo_edu_aggregate=3 if v_240==3
			replace ilo_edu_aggregate=4 if v_240==4
			replace ilo_edu_aggregate=5 if ilo_edu_aggregate==.
				label def edu_aggr_lab 1 "1 - Less than basic" 2 "2 - Basic" 3 "3 - Intermediate" 4 "4 - Advanced" 5 "5 - Level not stated"
				label val ilo_edu_aggregate edu_aggr_lab
				label var ilo_edu_aggregate "Level of education (Aggregate levels)"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education attendance ('ilo_edu_attendance') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: 

	gen ilo_edu_attendance=.
		replace ilo_edu_attendance=1 if v_231==1				// Attending
		replace ilo_edu_attendance=2 if v_231==2				// Not attending
		replace ilo_edu_attendance=3 if ilo_edu_attendance==.	// Not elsewhere classified
			label def edu_att_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
			label val ilo_edu_attendance edu_att_lab
			label var ilo_edu_attendance "Education (Attendance)"
										
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Disability status ('ilo_dsb_details') [no info available]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment: 

	/*  gen ilo_dsb_details=.
			
		gen ilo_dsb_aggregate=.
	*/
	
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
*           
* Comment: 	

	gen ilo_wap=.
		replace ilo_wap=1 if ilo_age>=15 & ilo_age!=.
		replace ilo_wap=0 if ilo_age<15
			label def ilo_wap_lab 1 "Working age population"
			label val ilo_wap ilo_wap_lab
			label var ilo_wap "Working age population" //15+ population

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Labour Force Status ('ilo_lfs') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*            	 
* Comment: 2010 is the only year for which we possess the full dataset, containing the original questions used for identifying people in employment. Given that once we use our definition, we don't get a perfect match with
			* the pre-defined variable from the dataset (which is used for all other years, as no other variable is available) (namely the number of people in unemployment do not match perfectly). 
			* in order to have a coherent time-series, we are using the pre-defined variable for the definition of the labour force status (ilo_lfs). 

	
	gen ilo_lfs=.
		replace ilo_lfs=1 if v_288==2
		replace ilo_lfs=2 if v_288==3
		replace ilo_lfs=3 if v_288==1
			replace ilo_lfs=. if ilo_wap!=1
			label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside Labour Force"
			lab val ilo_lfs label_ilo_lfs
			lab var ilo_lfs "Labour force status"	
	
	/* definition as it should normally be done (i.e. without using pre-defined variable)
	
	gen lfs=.
		replace lfs=1 if v_281==1 | inlist(v_284,1,2,3,4)
		replace lfs=2 if ilo_lfs!=1 & v_286==1 & v_287==1
		replace lfs=3 if !inlist(ilo_lfs,1,2)
			replace ilo_lfs=. if ilo_wap!=1	
				* take already defined value label
				label value lfs label_ilo_lfs
				label var lfs "Labour Force Status - definition by identifying with questions from questionnaire" 	
	
				*/
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: 
	
	gen ilo_mjh=.
		replace ilo_mjh=1 if v_430==2
		replace ilo_mjh=2 if v_430==1
				replace ilo_mjh=. if ilo_lfs!=1
			lab def lab_ilo_mjh 1 "1 - One job only" 2 "2 - More than one job"
			lab val ilo_mjh lab_ilo_mjh
			lab var ilo_mjh "Multiple job holders"
			

***********************************************************************************************
*			PART 3.1. ECONOMIC CHARACTERISTICS FOR MAIN JOB 
***********************************************************************************************	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Status in employment ('ilo_ste') [done] 
* -------------------------------------------------------------------------------------------
* ------------------------------------------------------------------------------------------- 
*
* Comment: 

	* Primary activity
	
		gen ilo_job1_ste_icse93=.
			replace ilo_job1_ste_icse93=1 if inlist(v_321,3,4)
			replace ilo_job1_ste_icse93=2 if v_321==1
			replace ilo_job1_ste_icse93=3 if v_321==2
			/* replace ilo_job1_ste_icse93=4 if */
			replace ilo_job1_ste_icse93=5 if v_321==5
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
			replace ilo_job1_ste_aggregate=3 if inlist(ilo_job1_ste_icse93,6)
				lab def ste_aggr_lab 1 "1 - Employees" 2 "2 - Self-employed" 3 "3 - Not elsewhere classified"
				lab val ilo_job1_ste_aggregate ste_aggr_lab
			label var ilo_job1_ste_aggregate "Status in employment (Aggregate)"

	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: --> info only indicated at the aggregate level -- do still a mapping for ISIC Rev. 4 (by adding notes!)

		gen indu_code_prim=v_337 if ilo_lfs==1 
		
	* Primary activity
		
		gen ilo_job1_eco_isic4=.
			replace ilo_job1_eco_isic4=1 if indu_code_prim==0
			replace ilo_job1_eco_isic4=2 if inlist(indu_code_prim,65,66)
			replace ilo_job1_eco_isic4=3 if inlist(indu_code_prim,10,20,30,40,50,60)
			/* replace ilo_job1_eco_isic4=4 if */
			replace ilo_job1_eco_isic4=5 if inlist(indu_code_prim,67,68)
			replace ilo_job1_eco_isic4=6 if indu_code_prim==69
			replace ilo_job1_eco_isic4=7 if indu_code_prim==72
			replace ilo_job1_eco_isic4=8 if indu_code_prim==76
			replace ilo_job1_eco_isic4=9 if indu_code_prim==79
			/* replace ilo_job1_eco_isic4=10 if */
			replace ilo_job1_eco_isic4=11 if indu_code_prim==82
			replace ilo_job1_eco_isic4=12 if indu_code_prim==85 // note that it includes ISIC Rev.4 categories M and N as well!
			/* replace ilo_job1_eco_isic4=13 if */ 
			/* replace ilo_job1_eco_isic4=14 if */
			replace ilo_job1_eco_isic4=15 if indu_code_prim==93 // note that includes ISIC Rev. 4 category P (including health sector) as well!
			/* replace ilo_job1_eco_isic4=16 if */
			replace ilo_job1_eco_isic4=17 if indu_code_prim==89 // includes category R (health excluded) as well
			/* replace ilo_job1_eco_isic4=18 if */
			/* replace ilo_job1_eco_isic4=19 if */
			/* replace ilo_job1_eco_isic4=20 if */
			replace ilo_job1_eco_isic4=21 if indu_code_prim==98
			replace ilo_job1_eco_isic4=22 if ilo_job1_eco_isic4==. & ilo_lfs==1 
					replace ilo_job1_eco_isic4=. if ilo_lfs!=1
				lab def eco_isic4_lab 1 "A - Agriculture, forestry and fishing" 2 "B - Mining and quarrying" 3 "C - Manufacturing" 4 "D - Electricity, gas, steam and air conditioning supply" /// 
								5 "E - Water supply; sewerage, waste management and remediation activities" 6 "F - Construction" 7 "G - Wholesale and retail trade; repair of motor vehicles and motorcycles" /// 
								8 "H - Transportation and storage" 9 "I - Accommodation and food service activities" 10 "J - Information and communication" 11 "K - Financial and insurance activities" /// 
								12 "L - Real estate activities" 13 "M - Professional, scientific and technical activities" 14 "N - Administrative and support service activities" /// 
								15 "O - Public administration and defence; compulsory social security" 16 "P - Education" 17 "Q - Human health and social work activities" 18 "R - Arts, entertainment and recreation" /// 
								19 "S - Other service activities" 20 "T - Activities of households as employers; undifferentiated goods- and services-producing activities of households for own use" /// 
								21 "U - Activities of extraterritorial organizations and bodies" 22 "X - Not elsewhere classified"
				lab val ilo_job1_eco_isic4 eco_isic4_lab
				lab var ilo_job1_eco_isic4 "Economic activity (ISIC Rev. 4)"
				
	
		
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
			
		
			
	/*		
			
	* OLD MAPPING - don't use it
	
		* Primary activity
		
		gen ilo_job1_eco_aggregate=.
			replace ilo_job1_eco_aggregate=1 if indu_code_prim==0
			replace ilo_job1_eco_aggregate=2 if inrange(indu_code_prim,10,60)
			replace ilo_job1_eco_aggregate=3 if indu_code_prim==69
			replace ilo_job1_eco_aggregate=4 if inlist(indu_code_prim,65,66,67,68)
			replace ilo_job1_eco_aggregate=5 if inlist(indu_code_prim,72,76,79,82,85)
			replace ilo_job1_eco_aggregate=6 if inlist(indu_code_prim,89,93,98)
			replace ilo_job1_eco_aggregate=7 if ilo_job1_eco_aggregate==. & ilo_lfs==1
				replace ilo_job1_eco_aggregate=. if ilo_lfs!=1
				lab def eco_aggr_lab 1 "1 - Agriculture" 2 "2 - Manufacturing" 3 "3 - Construction" 4 "4 - Mining and quarrying; Electricity, gas and water supply" ///
									5 "5 - Market Services (Trade; Transportation; Accommodation and food; and Business and administrative services)"  ///
									6 "6 - Non-market services (Public administration; Community, social and other services and activities)" 7 "7 - Not classifiable by economic activity"					
				lab val ilo_job1_eco_aggregate eco_aggr_lab
				lab var ilo_job1_eco_aggregate "Economic activity (Aggregate)"
				
		*/
				
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_ocu') [in progress]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: 

	* ISCO-88 classification used
	
		gen occ_code_prim=v_312 if ilo_lfs==1
		
	* 2 digit level
	
		* Primary occupation
		
	gen ilo_job1_ocu_isco88_2digits=occ_code_prim
			lab def ocu_isco88_2digits 1 "01 - Armed forces" 11 "11 - Legislators and senior officials" 12 "12 - Corporate managers" 13 "13 - General managers" /// 
			21 "21 - Physical, mathematical and engineering science professionals" 22 "22 - Life science and health professionals" 23 "23 - Teaching professionals" 24 "24 - Other professionals" /// 
			31 "31 - Physical and engineering science associate professionals" 32 "32 - Life science and health associate professionals" 33 "33 - Teaching associate professionals" /// 
			34 "34 - Other associate professionals" 41 "41 - Office clerks" 42 "42 - Customer services clerks" 51 "51 - Personal and protective services workers" /// 
			52 "52 - Models, salespersons and demonstrators" 61 "61 - Skilled agricultural and fishery workers" 62 "62 - Subsistence agricultural and fishery workers" /// 
			71 "71 - Extraction and building trades workers" 72 "72 - Metal, machinery and related trades workers" 73 "73 - Precision, handicraft, craft printing and related trades workers" /// 
			74 "74 - Other craft and related trades workers" 81 "81 - Stationary plant and related operators" 82 "82 - Machine operators and assemblers" 83 "83 - Drivers and mobile plant operators" /// 
			91 "91 - Sales and services elementary occupations" 92 "92 - Agricultural, fishery and related labourers" 93 "93 - Labourers in mining, construction, manufacturing and transport"
		lab val ilo_job1_ocu_isco88_2digits ocu_isco88_2digits
		lab var ilo_job1_ocu_isco88_2digits "Occupation (ISCO-88), 2 digit level"

			
	* 1 digit level
	
	gen occ_code_prim_1dig=int(occ_code_prim/10) if ilo_lfs==1
	
		* Primary activity
		
		gen ilo_job1_ocu_isco88=occ_code_prim_1dig
			replace ilo_job1_ocu_isco88=10 if ilo_job1_ocu_isco88==0
			replace ilo_job1_ocu_isco88=11 if ilo_job1_ocu_isco88==. & ilo_lfs==1
			lab def isco88_1dig_lab 1 "1 - Managers" 2 "2 - Professionals" 3 "Technicians and associate professionals" 4 "4 - Clerks" 5 "5 - Service workers and shop and market sales workers" ///
									6 "6 - Skilled agricultural and fishery workers" 7 "7 - Craft and related trades workers" 8 "8 - Plant and machine operators, and assemblers" ///
									9 "9 - Elementary occupations" 10 "0 - Armed forces occupations" 11 "X - Not elsewhere classified"
			lab val ilo_job1_ocu_isco88 isco88_1dig_lab
			lab var ilo_job1_ocu_isco88 "Occupation (ISCO-88)"	
			
		
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
				lab var ilo_job1_ocu_aggregate "Occupation (Aggregate)"
				
	* Skill level
	
		* Primary occupation
	
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
*			Institutional sector of economic activities ('ilo_ins_sector') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
		
* Comment: 

	* Primary occupation
	
	gen ilo_job1_ins_sector=.
		replace ilo_job1_ins_sector=1 if inlist(v_325,1,2)
		replace ilo_job1_ins_sector=2 if ilo_job1_ins_sector==. & ilo_lfs==1
				replace ilo_job1_ins_sector=. if ilo_lfs!=1
			lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
			lab values ilo_job1_ins_sector ins_sector_lab
			lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities"

* --------------------------------------------------------------------------------------------------
* --------------------------------------------------------------------------------------------------
*		Weekly hours actually (USUALLY) worked ('ilo_how_actual') and ('ilo_how_usual') [no info]
* --------------------------------------------------------------------------------------------------
* --------------------------------------------------------------------------------------------------
* 
* Comment: only actual hours for all jobs available

	* Actual hours worked
	
	gen ilo_joball_how_actual=v_282
		replace ilo_joball_how_actual=. if ilo_lfs!=1
		lab var ilo_joball_how_actual "Weekly hours actually worked in all jobs"

	* Weekly hours - bands 
	
		gen ilo_joball_how_actual_bands=.
			replace ilo_joball_how_actual_bands=1 if ilo_joball_how_actual==0
			replace ilo_joball_how_actual_bands=2 if inrange(ilo_joball_how_actual,1,14)
			replace ilo_joball_how_actual_bands=3 if inrange(ilo_joball_how_actual,15,29)
			replace ilo_joball_how_actual_bands=4 if inrange(ilo_joball_how_actual,30,34)
			replace ilo_joball_how_actual_bands=5 if inrange(ilo_joball_how_actual,35,39)
			replace ilo_joball_how_actual_bands=6 if inrange(ilo_joball_how_actual,40,48)
			replace ilo_joball_how_actual_bands=7 if ilo_joball_how_actual>=49 & ilo_joball_how_actual!=.
			replace ilo_joball_how_actual_bands=8 if ilo_lfs==1 & ilo_joball_how_actual_bands==.
				replace ilo_joball_how_actual_bands=. if ilo_lfs!=1
			lab def how_bands_lab 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"
				lab val ilo_joball_how_actual_bands how_bands_lab
				lab var ilo_joball_how_actual_bands "Weekly hours actually worked bands in all jobs"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment: as only actual working hours for all jobs are being indicated (i.e for both main and secondary job) and 
			* as the framework defines only the variable for "main job" - define it as "ilo_job1_job_time". Note also that 
			* the share of people holding two jobs is very low (weighted - 1% of people in employment)

		gen ilo_job1_job_time=.
			replace ilo_job1_job_time=1 if ilo_joball_how_actual<35 & ilo_joball_how_actual>0
			replace ilo_job1_job_time=2 if ilo_joball_how_actual>=35 & ilo_joball_how_actual!=.
			replace ilo_job1_job_time=3 if ilo_job1_job_time==. & ilo_lfs==1
			replace ilo_job1_job_time=. if ilo_lfs!=1
				lab def job1_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
				lab val ilo_job1_job_time job1_time_lab
				lab var ilo_job1_job_time "Job (Working time arrangement)"	

			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job_contract') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment:

	gen ilo_job1_job_contract=.
			replace ilo_job1_job_contract=1 if v_360==2
			replace ilo_job1_job_contract=2 if v_360==1
			replace ilo_job1_job_contract=3 if ilo_job1_job_contract==. & ilo_job1_ste_aggregate==1
					replace ilo_job1_job_contract=. if ilo_job1_ste_aggregate!=1
				lab def job_contract_lab 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"
				lab val ilo_job1_job_contract job_contract_lab
				lab var ilo_job1_job_contract "Job (Type of contract)"
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Informal/Formal economy: Unit of production (ilo_job1_ife_prod) [no info]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* 
* Comment: not enough info to define informality
	
	* Useful questions: v_325: Institutional sector
					* [no info]: Destination of production (use question used for identification of people in labour force)
					* [no info]: Bookkeeping
					* [no info]: Registration
					* [no info]: Social security
					* v_325: Location of workplace
					* [no info]: Size of enterprise
											
					
	* gen ilo_job1_ife_prod=.
		
					
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Informal/formal economy: nature of job (ilo_job1_ife_nature) [don't define]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: 

	* gen ilo_job1_ife_nature=.
		
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Earnings ('ilo_ear_ees' and 'ilo_ear_slf')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	
* Comment:
	
	* Currency in Tunisia: Tunisian dinar
	
		* questions asked in questionnaire (chapter VII) but no variables included in this dataset
	
	
	
***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************			

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_tru') [don't define]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*                
* Comment: no information available
			
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Cases of non-fatal occupational injury ('ilo_joball_oi_case') [not available]
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*
* Comment: no info available

	* gen ilo_joball_oi_case=	

*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Days lost due to cases of occupational injury ('ilo_joball_oi_day') [not available]
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*
* Comment: no info available

	* gen ilo_joball_oi_day=	
	
***********************************************************************************************
*			PART 3.3. UNEMPLOYMENT: ECONOMIC CHARACTERISTICS
***********************************************************************************************	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment:	Question asks how much time the person has spent looking for another job
	
	gen ilo_dur_details=.
		/* replace ilo_dur_details=1 if */
		replace ilo_dur_details=2 if inlist(v_588,1,2)
		replace ilo_dur_details=3 if inrange(v_588,3,5)
		replace ilo_dur_details=4 if inrange(v_588,6,11)
		replace ilo_dur_details=5 if inrange(v_588,12,23)
		replace ilo_dur_details=6 if v_588>=24 & v_588!=.
		replace ilo_dur_details=7 if ilo_dur_details==. & ilo_lfs==2
				replace ilo_dur_details=. if ilo_lfs!=2
			lab def ilo_unemp_det 1 "Less than 1 month" 2 "1 month to less than 3 months" 3 "3 months to less than 6 months" 4 "6 months to less than 12 months" 5 "12 months to less than 24 months" ///
									6 "24 months or more" 7 "Not elsewhere classified"
			lab values ilo_dur_details ilo_unemp_det
			lab var ilo_dur_details "Duration of unemployment (Details)" 
			
	* in order to avoid putting any notes and as the exact duration is not precised if person seeking for a job for 52 weeks, take only the aggregate version
			
			
	gen ilo_dur_aggregate=.
		replace ilo_dur_aggregate=1 if inlist(ilo_dur_details,1,2,3)
		replace ilo_dur_aggregate=2 if ilo_dur_details==4
		replace ilo_dur_aggregate=3 if inlist(ilo_dur_details,5,6)
		replace ilo_dur_aggregate=4 if ilo_dur_details==7
			lab def ilo_unemp_aggr 1 "Less than 6 months" 2 "6 months to less than 12 months" 3 "12 months or more" 4 "Not elsewhere classified"
			lab val ilo_dur_aggregate ilo_unemp_aggr
			lab var ilo_dur_aggregate "Duration of unemployment (Aggregate)"
			
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Category of unemployment ('ilo_cat_une') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: 

		gen ilo_cat_une=.
			replace ilo_cat_une=1 if v_586==1							// Previously employed
			replace ilo_cat_une=2 if v_586==2							// Seeking first job
			replace ilo_cat_une=3 if ilo_cat_une==. & ilo_lfs==2		// Unknown
					replace ilo_cat_une=. if ilo_lfs!=2
				lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
				lab val ilo_cat_une cat_une_lab
				lab var ilo_cat_une "Category of unemployment"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4') [not being defined]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: can be defined at the aggregate level

	gen preveco_cod=v_0_655_2 if ilo_cat_une==1

	gen ilo_preveco_aggregate=.
		replace ilo_preveco_aggregate=1 if preveco_cod==0
		replace ilo_preveco_aggregate=2 if inrange(preveco_cod,10,60)
		replace ilo_preveco_aggregate=3 if preveco_cod==69
		replace ilo_preveco_aggregate=4 if inlist(preveco_cod,65,66,67,68)
		replace ilo_preveco_aggregate=5 if inlist(preveco_cod,72,76,79,82,85)
		replace ilo_preveco_aggregate=6 if inlist(preveco_cod,89,93,98)
		replace ilo_preveco_aggregate=7 if ilo_preveco_aggregate==. & ilo_cat_une==1
			* value label already defined above			
			lab val ilo_preveco_aggregate eco_aggr_lab
			lab var ilo_preveco_aggregate "Previous economic activity (Aggregate)" 
			
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu_isco08') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			
* Comment: 

		gen prevocu_cod=int(v_0_647/10) if ilo_lfs==2 & v_0_647!=-1
	
	gen ilo_prevocu_isco88=prevocu_cod
			replace ilo_prevocu_isco88=10 if ilo_prevocu_isco88==0
			replace ilo_prevocu_isco88=11 if ilo_prevocu_isco88==. & ilo_cat_une==1 & ilo_lfs==2
				* value label already defined
			lab val ilo_prevocu_isco88 isco88_1dig_lab
			lab var ilo_prevocu_isco88 "Occupation (ISCO-88)"	
			
	* Aggregate level
	
		* Primary occupation
	
		gen ilo_prevocu_aggregate=.
			replace ilo_prevocu_aggregate=1 if inrange(ilo_prevocu_isco88,1,3)
			replace ilo_prevocu_aggregate=2 if inlist(ilo_prevocu_isco88,4,5)
			replace ilo_prevocu_aggregate=3 if inlist(ilo_prevocu_isco88,6,7)
			replace ilo_prevocu_aggregate=4 if ilo_prevocu_isco88==8
			replace ilo_prevocu_aggregate=5 if ilo_prevocu_isco88==9
			replace ilo_prevocu_aggregate=6 if ilo_prevocu_isco88==10
			replace ilo_prevocu_aggregate=7 if ilo_prevocu_isco88==11
					* value label already defined
				lab val ilo_prevocu_aggregate ocu_aggr_lab
				lab var ilo_prevocu_aggregate "Occupation (Aggregate)"
				
				
	* Skill level
	
		* Primary occupation
	
		gen ilo_prevocu_skill=.
			replace ilo_prevocu_skill=1 if ilo_prevocu_isco88==9
			replace ilo_prevocu_skill=2 if inlist(ilo_prevocu_isco88,4,5,6,7,8)
			replace ilo_prevocu_skill=3 if inlist(ilo_prevocu_isco88,1,2,3)
			replace ilo_prevocu_skill=4 if inlist(ilo_prevocu_isco88,10,11)
				* value label already defined
				lab val ilo_prevocu_skill ocu_skill_lab
				lab var ilo_prevocu_skill "Occupation (Skill level)"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Unemployment benefits schemes ('ilo_soc_aggregate') [no info available]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment:

***********************************************************************************************
*			PART 3.4. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: due to filters in the questionnaire, it cannot be defined
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reasons for not seeking a job ('ilo_olf_reason') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: (refer to value labels available here http://catalog.ihsn.org/index.php/catalog/4362/datafile/F2 )

	gen ilo_olf_reason=.		
		replace ilo_olf_reason=1 if	v_284==63								// Labour market (discouraged) 
		/* replace ilo_olf_reason=2 if */									// Other labour market reasons
		replace ilo_olf_reason=3 if	inlist(v_284,8,9,11,12)					// Personal / Family-related
		replace ilo_olf_reason=4 if	inlist(v_284,7,10)						// Does not need/want to work
		replace ilo_olf_reason=5 if ilo_olf_reason==. & ilo_lfs==3			// Not elsewhere classified						
			replace ilo_olf_reason=. if ilo_lfs!=3			
			lab def lab_olf_reason 1 "1 - Labour market (discouraged)" 2 "2 - Other labour market reasons" 3 "3 - Personal/Family-related"  4 "4 - Does not need/want to work" 5 "5 - Not elsewhere classified"
			lab val ilo_olf_reason reason_lab 
			lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"		

	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seekers ('ilo_dis') [done]
* -------------------------------------------------------------------------------------------
* ------------------------------------------------------------------------------------------- 
*
* Comment: 	if people are not seeking a job, they're not asked about their availability (filter question). Therefore variable cannot be defined


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training (NEETs) ('ilo_neet') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: 

		gen ilo_neet=.
			replace ilo_neet=1 if inrange(ilo_age,15,24) & ilo_lfs!=1 & ilo_edu_attendance==2
				lab def ilo_neet_lab 1 "Youth not in education, employment or training"
				lab val ilo_neet ilo_neet_lab
				lab var ilo_neet "Youth not in education, employment or training"
		

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

*			SAVE RESULTS

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* -------------------------------------------------------------
* 1.	Prepare final datasets
* -------------------------------------------------------------

cd "$outpath"
		
		foreach var of varlist ilo_* {
	
		replace `var'=. if considered!=1
	
			}
			
		drop indu_code* considered preveco_cod prevocu_cod
		
		drop if ilo_wgt==.
		
		order ilo*, last
	
		compress 
		
	* Save dataset including original and ilo variables
	
		save ${country}_${source}_${time}_FULL,  replace		
	
	*Save file only containing ilo_* variables
		
		keep ilo*

		save ${country}_${source}_${time}_ILO, replace
		

