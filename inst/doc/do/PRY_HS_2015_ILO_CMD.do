* TITLE OF DO FILE: ILO Microdata Preprocessing code template - BOL HS 2014
* DATASET USED: BOL HS 2014
* NOTES:
* Author: Roger Gomis
* Who last updated the file: Roger Gomis
* Starting Date: 20 February 2017
* Last updated: 22 February 2017
***********************************************************************************************


***********************************************************************************************
***********************************************************************************************

* 			1. SET UP WORK DIRECTORY, FILE NAME, VARIABLES AND FUNCTIONS

***********************************************************************************************
***********************************************************************************************

clear all 

set more off

global path "J:\COMMON\STATISTICS\DPAU\MICRO"
global country "PRY"
global source "HS"
global time "2015"
global inputFile "REG02_EPH2015"

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

	gen ilo_wgt=fex
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
		replace ilo_geo=1 if area==1
		replace ilo_geo=2 if area==6
			lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural"
			lab val ilo_geo ilo_geo_lab
			lab var ilo_geo "Geographical coverage"	

			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_sex=p06 if p06==1
		replace ilo_sex=2 if p06==6
		lab def ilo_sex_lab 1 "1 - Male" 2 "2 - Female"
		lab var ilo_sex "Sex"
		lab val ilo_sex ilo_sex_lab


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_age=p02
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
					file:file:///J:\COMMON\STATISTICS\DPAU\MICRO\PRY\HS\2015\ORI\paraguay_isced_mapping_0.xls	
The question ed06c has been used as well in conjunction with the file above to determine the cuttofs for superior education
For doctorates it is explicitly used					
					
*/

** ISCED97
recode ed0504 (0=1) (101=2) (102=2) (103=2) (104=2) (105=2) (106=3) (107=3) (108=3) (109=3) (110=2) (111=2) (112=2) (210=2) (211=2) (212=2) (301=2) (302=2) (303=2) (304=2) (305=2) (306=3) (407=3) (408=3) (409=4) (501=3) (502=3) (503=4) (604=4) (605=4) (606=5) (607=5) (704=4) (705=4) (706=5) (803=5) (901=4) (902=4) (903=5) (1001=4) (1002=4) (1003=5) (1101=4) (1102=4) (1103=5) (1201=2) (1202=2) (1203=3) (1204=3) (1301=4) (1302=4) (1303=5) (1304=5) (1401=2) (1402=2) (1403=3) (1501=4) (1502=4) (1503=5) (1504=5) (1601=4) (1602=4) (1603=5) (1604=5) (1701=3) (1702=3) (1703=4) (1801=2) (1900=2) (2001=5) (2002=5) (2003=7) (2004=7) (2101=5) (2102=5) (2103=7) (2104=7) (2201=5) (2202=5) (2203=7) (2204=7) (2205=7) (2206=7) (2301=5) (2302=5) (2303=7) (2304=7) (2401=5) (2402=5) (2403=5) (2404=7) (2405=7) (2406=-1000) (8888=9) (9999 =9), gen(ilo_edu_isced97)
	replace ilo_edu_isced97=8 if ilo_edu_isced97==-1000&ed06c==8
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
		replace ilo_edu_attendance=1 if ed08<19			// Attending
		replace ilo_edu_attendance=2 if ed08==19				// Not attending
			label def edu_att_lab 1 "1 - Attending" 2 "2 - Not attending"
			label val ilo_edu_attendance edu_att_lab
			label var ilo_edu_attendance "Education (Attendance)"

			

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
		replace ilo_lfs=1 if ((a02==1 | a03==1 | a04==1 ) & ilo_wap==1) 	// Employed
		replace ilo_lfs=2 if ilo_wap==1 & ilo_lfs!=1 & (a05==1 & a07==1 | 100==1) 	// Unemployed, Not Working + (Available + Sought Work OR already found work and will start in the next 30 days)
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
		replace ilo_mjh=1 if a04a==1 & ilo_lfs==1
		replace ilo_mjh=2 if a04a>1 & a04a!=.  & ilo_lfs==1
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
			replace ilo_job1_ste_icse93=1 if (b12<3|b12==6) & ilo_lfs==1		// Employees
			replace ilo_job1_ste_icse93=2 if (b12==3) & ilo_lfs==1		// Employers
			replace ilo_job1_ste_icse93=3 if b12==4 & ilo_lfs==1		// Own-account workers
	// Members of cooperatives
			replace ilo_job1_ste_icse93=5 if b12==5 & ilo_lfs==1		// Contributing family workers
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
		replace ilo_job1_eco_aggregate=1 if inlist(b02rec,1,1)
		replace ilo_job1_eco_aggregate=2 if b02rec==2
		replace ilo_job1_eco_aggregate=3 if b02rec==4
		replace ilo_job1_eco_aggregate=4 if inlist(b02rec,3)
		replace ilo_job1_eco_aggregate=5 if inlist(b02rec,5,6,7)
		replace ilo_job1_eco_aggregate=6 if inlist(b02rec,8)
		replace ilo_job1_eco_aggregate=7 if ilo_job1_eco_aggregate==.
		replace ilo_job1_eco_aggregate=. if ilo_lfs!=1
			lab def eco_aggr_lab 1 "1 - Agriculture" 2 "2 - Manufacturing" 3 "3 - Construction" 4 "4 - Mining and quarrying; Electricity, gas and water supply" ///
								5 "5 - Market Services (Trade; Transportation; Accommodation and food; and Business and administrative services)"  ///
								6 "6 - Non-market services (Public administration; Community, social and other services and activities)" 7 "7 - Not classifiable by economic activity"					
			lab val ilo_job1_eco_aggregate eco_aggr_lab
			lab var ilo_job1_eco_aggregate "Economic activity (Aggregate)"

		
		*****************************************************
		


		* Secondary activity
		
	gen ilo_job2_eco_aggregate=.
		replace ilo_job2_eco_aggregate=1 if inlist(c02rec,1,1)
		replace ilo_job2_eco_aggregate=2 if c02rec==2
		replace ilo_job2_eco_aggregate=3 if c02rec==4
		replace ilo_job2_eco_aggregate=4 if inlist(c02rec,3)
		replace ilo_job2_eco_aggregate=5 if inlist(c02rec,5,6,7)
		replace ilo_job2_eco_aggregate=6 if inlist(c02rec,8)
		replace ilo_job2_eco_aggregate=7 if ilo_job2_eco_aggregate==.
		replace ilo_job2_eco_aggregate=. if (ilo_lfs!=1|ilo_mjh!=2)
			lab val ilo_job2_eco_aggregate eco_aggr_lab
			lab var ilo_job2_eco_aggregate "Economic activity (Aggregate)"

			
				


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_ocu') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
		/* Classification used: ISCO 08  */ 
		*1 digit classification is given directly
	



		
		* ISCO 08 - 1 digit
			gen ilo_job1_ocu_isco08=b01rec if (ilo_lfs==1)
				replace ilo_job1_ocu_isco08=10 if ilo_job1_ocu_isco08==0
				replace ilo_job1_ocu_isco08=11 if (ilo_job1_ocu_isco08==. & ilo_lfs==1)
				replace ilo_job1_ocu_isco08=. if ilo_lfs!=1
					lab def isco08_1dig_lab 1 "1 - Managers" 2 "2 - Professionals" 3 "Technicians and associate professionals" 4 "4 - Clerical support workers" 5 "5 - Service and sales workers" ///
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



* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_job1_ins_sector')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
	
	
	* if the respondant does not know the variable is not defined - NGO's are set in private
		gen ilo_job1_ins_sector=.
			replace ilo_job1_ins_sector=1 if (inlist(b12,1) & ilo_lfs==1)	// Public
			replace ilo_job1_ins_sector=2 if (inlist(b12,2,3,4,5,6) & ilo_lfs==1)	// Private
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
	
	recode b12 ( 1 = 1) (2 3 4 5 9 =0) (6 = -1), gen(todrop_institutional) 		// theoretical 3 value node/ +1 Gov, Corporation, NGO, Embassy, IO / 0 Farm or private business, other, not asked, don't know, NA / -1 private household
								// Household sector identified in the status in employment question
	replace todrop_institutional=0 if todrop_institutional==. 						// if the absence of the created variable is due to complete absence informality should not be computed
	
	gen todrop_destinationprod=1 													// theoretical 2 value node / +1 At least partially market or Other, Not asked, Don't Know, NA/  0 Only for own final use (household) 
	
	gen todrop_bookkeeping=0 														// theoretical 2 value node/ +1 keeps accounts for GOV/ 0 does not keep accounts or personal use or other, not asked, DK, NA  
	
	gen todrop_registration=1 if (b28 == 1) 										// theoretical 3 value node/ +1 registered national level/ 0 not registered national level, other, DK / 0 not asked NA
		replace todrop_registration=0 if (b28==2|b28==6)&todrop_registration!=1
		replace todrop_registration=-1 if todrop_registration==.
		
	gen todrop_SS=1 if b10==1  														// theoretical 3 value node/ +1 Social security/ 0 Not asked / -1 No social security or don't know NA Other
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
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Hours of work ('ilo_job1_how')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

foreach var of varlist b03lu-b03do {
	gen HOURS_`var' = int(`var')
	gen MINUTES_`var'=(`var'-HOURS_`var')
	replace MINUTES_`var'=0 if MINUTES_`var'>0.601
	
	replace HOURS_`var'=0 if HOURS_`var'==99
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
			gen ilo_job1_how_usual=b06 if ilo_lfs==1&b06<999
			replace ilo_job1_how_usual=ilo_job1_how_actual if ilo_lfs==1 & ilo_job1_how_usual==.
					lab var ilo_job1_how_usual "Weekly hours usually worked in main job"
					
* Secondary job - actual
			gen ilo_job2_how_actual=c03 if (ilo_mjh==2&ilo_lfs==1)&c03<999
				lab var ilo_job2_how_actual "Weekly hours actually worked in second job"

* Tertiary job - actual
			gen ilo_job3_how_actual=c18 if (ilo_mjh==2&ilo_lfs==1)&c18<999
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
					gen ilo_job1_lri_ees=b16t if (b16t<900000000 & ilo_job1_ste_aggregate==1)
						replace ilo_job1_lri_ees=. if ilo_job1_lri_ees==0 
							lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"	
				
				* Self-employed
					gen ilo_job1_lri_slf=e01aimde if (e01aimde<900000000 & inlist(ilo_job1_ste_icse93,2,3,4,6))
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

		gen ilo_joball_tru=.
		* notice that willing to work is in this case in the "strong form" of having sought additional work
			replace ilo_joball_tru=1 if ilo_joball_how_actual<35 & d01==1 & d04==1 & ilo_lfs==1
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
		replace ilo_cat_une=1 if (a12==1&ilo_lfs==2)
		replace ilo_cat_une=2 if (a12==6&ilo_lfs==2)
		replace ilo_cat_une=3 if (ilo_cat_une==.&ilo_lfs==2)
				lab def ilo_cat_une 1 "Unemployed previously employed" 2 "Unemployed seeking first job" 3 "Unknown"
				lab val ilo_cat_une ilo_cat_une
				lab var ilo_cat_une "Category of unemployment"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen todrop1=a11m 
	gen todrop2=a11s/4.33
	gen todrop3=a11a *12
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
	drop todrop

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_aggregate')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

	gen ilo_preveco_aggregate=.
		replace ilo_preveco_aggregate=1 if inlist(a14rec,1,1)
		replace ilo_preveco_aggregate=2 if a14rec==2
		replace ilo_preveco_aggregate=3 if a14rec==4
		replace ilo_preveco_aggregate=4 if inlist(a14rec,3)
		replace ilo_preveco_aggregate=5 if inlist(a14rec,5,6,7)
		replace ilo_preveco_aggregate=6 if inlist(a14rec,8)
		replace ilo_preveco_aggregate=7 if ilo_preveco_aggregate==.
		replace ilo_preveco_aggregate=. if (ilo_lfs!=2|ilo_cat_une!=1)
			lab val ilo_preveco_aggregate eco_aggr_lab
			lab var ilo_preveco_aggregate "Economic activity (Aggregate)"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu_isco88')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

		* ISCO 08 - 1 digit
			gen ilo_prevocu_isco08=a13rec if ((ilo_lfs==2&ilo_cat_une==1))
				replace ilo_prevocu_isco08=10 if ilo_prevocu_isco08==0
				replace ilo_prevocu_isco08=11 if ((ilo_prevocu_isco08==.|ilo_prevocu_isco08>10) & (ilo_lfs==2&ilo_cat_une==1))
				replace ilo_prevocu_isco08=. if (ilo_lfs!=2|ilo_cat_une!=1)
					lab val ilo_prevocu_isco08 isco08_1dig_lab
					lab var ilo_prevocu_isco08 "Occupation (ISCO-08)"		

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
					lab var ilo_prevocu_aggregate "Occupation (Aggregate) - Main job"	
					
					
		* Skill level
		recode ilo_prevocu_isco08 (1/3=3) (4/8=2) (9=1) (10/11=4) ,gen(ilo_prevocu_skill)
		lab val ilo_prevocu_skill ilo_job1_ocu_skill
		lab var ilo_prevocu_skill "Occupation (Skill level)"

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
		*0 BY CONSTRUCTION replace ilo_olf_dlma = 1 if (a05==6&a07==1)&ilo_lfs==3							 	//Seeking, not available
		replace ilo_olf_dlma = 2 if (a05==1&a07==6)&ilo_lfs==3								//Not seeking, available
		*CANNOT BE DONE DUE TO MISSING VARIABLE replace ilo_olf_dlma = 3 if (a05==6&a07==6&inlist(a09,2,3,4,8,9,10) )&ilo_lfs==3  	//Not seeking, not available, willing (Willing non-job seekers) 
		*CANNOT BE DONE DUE TO MISSING VARIABLE replace ilo_olf_dlma = 4 if  a05==6&a07==6&(!inlist(a09,2,3,4,8,9,10) |inlist(a06,1,2,3,4,5,6,7,8,9,10,11) )&ilo_lfs==3			//Not seeking, not available, not willing (Non-Willigness based reasons for not being available) 
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