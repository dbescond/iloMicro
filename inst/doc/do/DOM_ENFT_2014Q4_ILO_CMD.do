* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Dominican Republic, October 2014
* DATASET USED: Dominican Republic LFS 2014 Q4
* NOTES: 
* Files created: Standard variables on ENFT Dominican Republic 2014 Q4
* Authors: Podjanin, A.
* Who last updated the file: Mabelin Villarreal Fuentes
* Starting Date: 14 September 2016
* Last updated: 15 May 2017
***********************************************************************************************



*******************************************************************
 /* 1.	Set up work directory, file name, variables and function */
*******************************************************************

clear all 

set more off

global inpath "J:\COMMON\STATISTICS\DPAU\MICRO\DOM\ENFT\2014Q4\ORI"
global temppath "J:\COMMON\STATISTICS\DPAU\MICRO\_Admin"
global outpath "J:\COMMON\STATISTICS\DPAU\MICRO\DOM\ENFT\2014Q4"

************************************************************************************

* Important : if package « labutil » not already installed, install it in order to execute correctly the do-file

	* ssc install labutil

************************************************************************************
* Make a tempfile containing the labels for the classifications ISIC and ISCO 

		* NOTE: if you want this do-file to run correctly, run it without breaks!
		
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
							
			* Save file (as tempfile)
			
			save "`labels'"
			
*********************************************************************************************

* Load original dataset

*********************************************************************************************

cd "$inpath"

	use Miembros, clear	
	
		merge 1:1 S1_A05 S1_A06 MIEMBRO using Ocupacion
			drop _merge
		merge 1:1 S1_A05 S1_A06 MIEMBRO using Calculadas
			drop _merge
	
	rename *, lower		
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

*			2. MAP VARIABLES

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Identifier ('ilo_key') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*		

	gen ilo_key=_n
		lab var ilo_key "Key unique identifier per individual"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sample Weight ('ilo_wgt') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*		

	gen ilo_wgt=peso
		lab var ilo_wgt "Sample weight"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time period ('ilo_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*

	gen ilo_time=1
		lab def time_lab 1 "2014Q4"
		lab val ilo_time time_lab
		lab var ilo_time "Time (Gregorian Calendar)"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: Age above 99 not indicated, highest value corresponds to "99 y más (99 and more)"

	gen ilo_age=s3_04
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
*			Sex ('ilo_sex') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: 

		gen ilo_sex=s3_03
			label define label_Sex 1 "1 - Male" 2 "2 - Female"
			label values ilo_sex label_Sex
			lab var ilo_sex "Sex"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Labour Force Status ('ilo_lfs') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*            	 
* Comment: 	* question 12b missing in the datafile

			* --> note that people having replied that they were either actively looking for a job, or were trying to start an own business were not
				* asked about their availability, but it is implicitly considered that they were available as they were actively trying to get
				* an employment
 
	gen ilo_lfs=.
		replace ilo_lfs=1 if s4_02==1 | s4_03==1 | s4_06a==1 | s4_06b==1 | s4_06c==1 | s4_06d==1 
		replace ilo_lfs=2 if (s4_07==1 | s4_08==1) | (inlist(s4_11,3,12) & (s4_12==1 | s4_12a==1)) 
		replace ilo_lfs=3 if  ilo_lfs==. & ilo_wap==1
			replace ilo_lfs=. if ilo_wap!=1	
				label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status" 
				
				
					* note that according to the national definition, unemployment has two categories: "open unemployment" (desocupación abierta)
						* and "extended unemployment" (desocupación ampliada), the latter considering the first category plus individuals that were not actively
						* looking for a job but were available to work
						* it also seems to include the "cesantes", i.e. people having been previously employed
	
	* Labour Force Status following national definition --> Employed population takes into account all individual aged 5+ (and not only 15+)
		* having an economic activity within a specified reference period
		
		* Unemployment definition considers all individuals aged 10+ not having a job during a reference period and that are immediately available to work
		
		* Inactive population --> working age population (10+) not being economically active
	
	gen nat_lfs=.
		replace nat_lfs=1 if (s4_02==1 | s4_03==1 | s4_06a==1 | s4_06b==1 | s4_06c==1 | s4_06d==1) & ilo_age>=5
		replace nat_lfs=2 if (s4_12==1 | s4_12a==1 | s4_13==1) & ilo_age>=10
		replace nat_lfs=3 if nat_lfs==. & ilo_age>=10
			lab val nat_lfs label_ilo_lfs
			lab var nat_lfs "Labour Force Status (national definition)" 			
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: 

	gen ilo_mjh=.
		replace ilo_mjh=1 if s4_26==2
		replace ilo_mjh=2 if s4_26==1
		replace ilo_mjh=. if ilo_lfs!=1
			lab def lab_ilo_mjh 1 "1 - One job only" 2 "2 - More than one job"
			lab val ilo_mjh lab_ilo_mjh
			lab var ilo_mjh "Multiple job holders"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_ins_sector') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
		
* Comment: 
	
	* Primary occupation
	
	gen ilo_job1_ins_sector=.
		replace ilo_job1_ins_sector=1 if inlist(s4_18,1,2)
		replace ilo_job1_ins_sector=2 if inrange(s4_18,3,8)
				replace ilo_job1_ins_sector=. if ilo_lfs!=1
			lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
			lab values ilo_job1_ins_sector ins_sector_lab
			lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities"

* --------------------------------------------------------------------------------------------------
* --------------------------------------------------------------------------------------------------
*		Weekly hours actually (USUALLY) worked ('ilo_how_actual') and ('ilo_how_usual') [done]
* --------------------------------------------------------------------------------------------------
* --------------------------------------------------------------------------------------------------
* 
* Comment: consider first working time associated with each job (if available) and then consider the sum (i.e.
				* the time dedicated to all working activities during the week
				
	* Actual hours worked are not being indicated, but only hours usually worked 
	/*
	gen ilo_joball_how_actual=p24
		replace ilo_joball_how_actual=. if ilo_lfs!=1
		lab var ilo_joball_how_actual "Weekly hours actually worked in all jobs"
		*/
	
	* Hours usually worked
	
		* Primary job
		
		gen ilo_job1_how_usual=s4_22
			replace ilo_job1_how_usual=. if ilo_lfs!=1
			lab var ilo_job1_how_usual "Weekly hours usually worked in main job"
			
		* Secondary job
		
		gen ilo_job2_how_usual=s4_27
			replace ilo_job2_how_usual=. if ilo_lfs!=1 & ilo_mjh!=2
			lab var ilo_job2_how_usual "Weekly hours usually worked in secondary job"
			
		* All jobs
		
		egen ilo_joball_how_usual=rowtotal(ilo_job1_how_usual ilo_job2_how_usual), m
			replace ilo_joball_how_usual=. if ilo_lfs!=1
			lab var ilo_joball_how_usual "Weekly hours usually worked in all jobs"
		
		*Weekly hours actually worked --> bands --> use actual hours worked in all jobs (as no indication on main and secondary job separately)
	/*
	gen ilo_joball_how_actual_bands=.
		replace ilo_joball_how_actual_bands=1 if p22==1
		replace ilo_joball_how_actual_bands=2 if ilo_joball_how_actual>=1 & ilo_joball_how_actual<=14
		replace ilo_joball_how_actual_bands=3 if ilo_joball_how_actual>=15 & ilo_joball_how_actual<=29
		replace ilo_joball_how_actual_bands=4 if ilo_joball_how_actual>=30 & ilo_joball_how_actual<=34
		replace ilo_joball_how_actual_bands=5 if ilo_joball_how_actual>=35 & ilo_joball_how_actual<=39
		replace ilo_joball_how_actual_bands=6 if ilo_joball_how_actual>=40 & ilo_joball_how_actual<=48
		replace ilo_joball_how_actual_bands=7 if ilo_joball_how_actual>=49 & ilo_joball_how_actual!=.
		replace ilo_joball_how_actual_bands=8 if ilo_lfs==1 & ilo_joball_how_actual_bands==.
			lab def how_bands_lab 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"
			lab values ilo_joball_how_actual_bands how_bands_lab
			lab var ilo_joball_how_actual_bands "Weekly hours actually worked bands in all jobs"
			*/
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_tru') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*                
* Comment: National threshold for for full-time employment set at 40 hours per week for public employees and 44 h per week for private
			* employees (cf. question 22) --> therefore use these thresholds 
			
			* only hours usually worked are being asked for and questions regarding time-related underemployment are referring 
				* to hours dedicated to primary employment
				
			* Individuals working below the national threshold are being asked about their *willingness* to work more, not about their availability!
			
	gen ilo_joball_tru=1 if ((ilo_job1_ins_sector==1 & ilo_joball_how_usual<40) | (ilo_job1_ins_sector==2 & ilo_joball_how_usual<44)) & s4_24==1
		replace ilo_joball_tru=. if ilo_lfs!=1
		lab def tru_lab 1 "Time-related underemployment"
		lab val ilo_joball_tru tru_lab
		lab var ilo_joball_tru "Time-related underemployment"
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education attendance ('ilo_edu_attendance') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment:

		gen ilo_edu_attendance=.
			replace ilo_edu_attendance=1 if inrange(s3_10,1,6)
			replace ilo_edu_attendance=2 if s3_10==7
			replace ilo_edu_attendance=3 if ilo_edu_attendance==.
				lab def edu_attendance_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
				lab val ilo_edu_attendance edu_attendance_lab
				lab var ilo_edu_attendance "Education (Attendance)"

		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training (NEETs) ('ilo_neet') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: No reference period specified, question asked "are you currently going to class?"

		gen ilo_neet=.
			replace ilo_neet=1 if inrange(ilo_age,15,24) & ilo_lfs!=1 & ilo_edu_attendance==2
				lab def ilo_neet_lab 1 "Youth not in education, employment or training"
				lab val ilo_neet ilo_neet_lab
				lab var ilo_neet "Youth not in education, employment or training"
		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Level of education ('ilo_edu') [done - check again]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: Given the definition of the levels of education, ISCED97 is being chosen
			
		* Reference: ISCED Mapping (http://www.uis.unesco.org/Education/ISCEDMappings/Documents/Latin%20America%20and%20the%20Caribbean/Rep_Dominicana_ISCED_mapping.xls)
			
			* Note that according to the definition, the highest level being CONCLUDED is being considered

	gen ilo_edu_isced97=.
		replace ilo_edu_isced97=1 if s3_09==7 | (s3_09==1 & inrange(s3_08,1,2))
		replace ilo_edu_isced97=2 if (s3_09==1 & s3_08==3) | (s3_09==2 & inrange(s3_08,1,5))
		replace ilo_edu_isced97=3 if s3_09==2 & inrange(s3_08,6,7)
		replace ilo_edu_isced97=4 if (s3_09==2 & s3_08==8) | (inlist(s3_09,3,4) & inrange(s3_08,1,3)) 
		replace ilo_edu_isced97=5 if (s3_09==3 & s3_08==4) | (s3_09==5 & inrange(s3_08,1,3))
		replace ilo_edu_isced97=6 if s3_09==4 & s3_08==4
		replace ilo_edu_isced97=7 if (s3_09==5 & inrange(s3_08,4,5)) | (s3_09==6 & s3_08==1)
		replace ilo_edu_isced97=8 if s3_09==6 & inrange(s3_08,2,4)
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
			label var ilo_edu_aggregate "Education (Aggregate)"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Status in employment ('ilo_ste') [done]
* -------------------------------------------------------------------------------------------
* ------------------------------------------------------------------------------------------- 
*
* Comment: 

	* Primary activity
	
		gen ilo_job1_ste_icse93=.
			replace ilo_job1_ste_icse93=1 if inlist(s4_18,1,2,3,8)
			replace ilo_job1_ste_icse93=2 if s4_18==6
			replace ilo_job1_ste_icse93=3 if inlist(s4_18,4,5)
			/* replace ilo_job1_ste_icse93=4 if */
			replace ilo_job1_ste_icse93=5 if s4_18==7
			replace ilo_job1_ste_icse93=6 if ilo_job1_ste_icse93==. & ilo_lfs==1
				replace ilo_job1_ste_icse93=. if ilo_lfs!=1
			
			label define label_ilo_ste_icse93 1 "1 - Employees" 2 "2 - Employers" 3 "3 - Own-account workers" 4 "4 - Members of producers' cooperatives" 5 "5 - Contributing family workers" ///
												6 "6 - Workers not classifiable by status"
			label val ilo_job1_ste_icse93 label_ilo_ste_icse93
			label var ilo_job1_ste_icse93 "Status in employment (ICSE 93)"

	* Aggregate categories
	
		gen ilo_job1_ste_aggregate=.
			replace ilo_job1_ste_aggregate=1 if ilo_job1_ste_icse93==1
			replace ilo_job1_ste_aggregate=2 if inlist(ilo_job1_ste_icse93,2,3,4)
			replace ilo_job1_ste_aggregate=3 if inlist(ilo_job1_ste_icse93,5,6)
				lab def ste_aggr_lab 1 "1 - Employees" 2 "2 - Self-employed" 3 "3 - Not elsewhere classified"
				lab val ilo_job1_ste_aggregate ste_aggr_lab
			label var ilo_job1_ste_aggregate "Status in employment (Aggregate)"

	  * Secondary activity
	  
		* --> no info available, variables can't be defined
	  
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Earnings ('ilo_ear_ees' and 'ilo_ear_slf')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	
* Comment: Classify earnings according to the occupation (i.e. primary and secondary) and then consider in a variable 
	* all labour related income for all jobs together
	
	* Currency in the Dominican Republic: Peso
	
	* Primary employment
	
			* Monthly earnings of employees
	
		* classification - earnings related to wage employment and self-employment to be done according to classifications
			* available in our dataset
			
		gen monthly_revenue=.
			replace monthly_revenue=(s4_281*ilo_job1_how_usual*4) if s4_282==1
			replace monthly_revenue=(s4_281*s4_28a*4) if s4_282==2
			replace monthly_revenue=(s4_281*4) if s4_282==3
			replace monthly_revenue=(s4_281*2) if s4_282==4
			replace monthly_revenue=s4_281 if s4_282==5	
			
		* Bonuses
		
		foreach var of varlist s4_28b4 s4_28b5 s4_28b6 s4_28b7 s4_28b8 s4_28b9 {
		
		replace `var'=(`var'/12)
		
		}	
			egen bonus=rowtotal(s4_28b*) if ilo_mjh==1, m
			
		* In-kind payment --> only being indicated for individuals having declared that they're not self-employed
				
			egen in_kind_payment=rowtotal(s4_29a2 s4_29b2 s4_29c2 s4_29d2 s4_29e2) if ilo_mjh==1, m 
		
			* --> final variable
		
		egen ilo_job1_lri_ees=rowtotal(monthly_revenue bonus in_kind_payment) if ilo_job1_ste_icse93==1, m
			replace ilo_job1_lri_ees=. if ilo_lfs!=1
			lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"
			
	* Self employment
		
		* note that the revenue related to self-employment includes also the value of own consumption 
			* (cf. resolution from 1998)
			
		egen ilo_job1_lri_slf=rowtotal(monthly_revenue bonus in_kind_payment) if !inlist(ilo_job1_ste_icse93,1,.), m
			replace ilo_job1_lri_slf=. if ilo_lfs!=1
			lab var ilo_job1_lri_slf "Monthly labour related income of self-employed in main job"
		
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: ISIC Rev. 3.1 being used and initially indicated on 3-digits level --> keep only 2 digits level

	* economic activity indicated only for primary activity

	gen indu_code_prim=int(s4_17a/10) if ilo_lfs==1
	
	append using `labels', gen (lab)
	
	* Primary activity
	
	gen ilo_job1_eco_isic3_2digits=indu_code_prim
		replace ilo_job1_eco_isic3_2digits=. if ilo_lfs!=1 
	
		lab values ilo_job1_eco_isic3_2digits isic3_2digits
		lab var ilo_job1_eco_isic3_2digits "Economic activity (ISIC Rev. 3.1), 2 digits levels"
		
			* no info about secondary activity
	
	* Do it at the one digit level
		
	* Primary activity
	
	gen ilo_job1_eco_isic3=.
		replace ilo_job1_eco_isic3=1 if inrange(ilo_job1_eco_isic3_2digits,1,2)
		replace ilo_job1_eco_isic3=2 if ilo_job1_eco_isic3_2digits==5
		replace ilo_job1_eco_isic3=3 if inrange(ilo_job1_eco_isic3_2digits,10,14)
		replace ilo_job1_eco_isic3=4 if inrange(ilo_job1_eco_isic3_2digits,15,37)
		replace ilo_job1_eco_isic3=5 if inrange(ilo_job1_eco_isic3_2digits,40,41)
		replace ilo_job1_eco_isic3=6 if ilo_job1_eco_isic3_2digits==45
		replace ilo_job1_eco_isic3=7 if inrange(ilo_job1_eco_isic3_2digits,50,52)
		replace ilo_job1_eco_isic3=8 if ilo_job1_eco_isic3_2digits==55
		replace ilo_job1_eco_isic3=9 if inrange(ilo_job1_eco_isic3_2digits,60,64)
		replace ilo_job1_eco_isic3=10 if inrange(ilo_job1_eco_isic3_2digits,65,67)
		replace ilo_job1_eco_isic3=11 if inrange(ilo_job1_eco_isic3_2digits,70,74)
		replace ilo_job1_eco_isic3=12 if ilo_job1_eco_isic3_2digits==75
		replace ilo_job1_eco_isic3=13 if ilo_job1_eco_isic3_2digits==80
		replace ilo_job1_eco_isic3=14 if ilo_job1_eco_isic3_2digits==85
		replace ilo_job1_eco_isic3=15 if inrange(ilo_job1_eco_isic3_2digits,90,93)
		replace ilo_job1_eco_isic3=16 if ilo_job1_eco_isic3_2digits==95
		replace ilo_job1_eco_isic3=17 if ilo_job1_eco_isic3_2digits==99
		replace ilo_job1_eco_isic3=18 if ilo_job1_eco_isic3_2digits==. & ilo_lfs==1
			lab val ilo_job1_eco_isic3 isic3
			lab var ilo_job1_eco_isic3 "Economic activity (ISIC Rev. 3.1)"
			
	* Now do the classification on an aggregate level
	
	* Primary activity
	
	gen ilo_job1_eco_aggregate=.
		replace ilo_job1_eco_aggregate=1 if inlist(ilo_job1_eco_isic3,1,2)
		replace ilo_job1_eco_aggregate=2 if ilo_job1_eco_isic3==4
		replace ilo_job1_eco_aggregate=3 if ilo_job1_eco_isic3==6
		replace ilo_job1_eco_aggregate=4 if inlist(ilo_job1_eco_isic3,3,5)
		replace ilo_job1_eco_aggregate=5 if inrange(ilo_job1_eco_isic3,7,11)
		replace ilo_job1_eco_aggregate=6 if inrange(ilo_job1_eco_isic3,12,17)
		replace ilo_job1_eco_aggregate=7 if ilo_job1_eco_isic3==18
			lab def eco_aggr_lab 1 "1 - Agriculture" 2 "2 - Manufacturing" 3 "3 - Construction" 4 "4 - Mining and quarrying; Electricity, gas and water supply" ///
								5 "5 - Market Services (Trade; Transportation; Accommodation and food; and Business and administrative services)"  ///
								6 "6 - Non-market services (Public administration; Community, social and other services and activities)" 7 "7 - Not classifiable by economic activity"					
			lab val ilo_job1_eco_aggregate eco_aggr_lab
			lab var ilo_job1_eco_aggregate "Economic activity (Aggregate)"
			
	* Secondary activity (no info available)
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_ocu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: Classification ISCO-88 being used 

			* --> note that only info about primary occupation being indicated

	gen occ_code_prim=int(s4_16a/10) if ilo_lfs==1
		
	* 2 digit level
	
		* Primary occupation
		
		gen ilo_job1_ocu_isco88_2digits=occ_code_prim
			lab values ilo_job1_ocu_isco88_2digits isco88_2digits
			lab var ilo_job1_ocu_isco88_2digits "Occupation (ISCO-88), 2 digit level"
			
		* Secondary occupation --> no info
	
		
	* 1 digit level
	
	gen occ_code_prim_1dig=int(s4_16a/100) if ilo_lfs==1
	
		* Primary activity
		
		gen ilo_job1_ocu_isco88=occ_code_prim_1dig
			replace ilo_job1_ocu_isco88=10 if ilo_job1_ocu_isco88==0
			replace ilo_job1_ocu_isco88=11 if ilo_job1_ocu_isco88==. & ilo_lfs==1
			lab def isco88_1dig_lab 1 "1 - Managers" 2 "2 - Professionals" 3 "Technicians and associate professionals" 4 "4 - Clerks" 5 "5 - Service workers and shop and market sales workers" ///
									6 "6 - Skilled agricultural and fishery workers" 7 "7 - Craft and related trades workers" 8 "8 - Plant and machine operators, and assemblers" ///
									9 "9 - Elementary occupations" 10 "0 - Armed forces occupations" 11 "X - Not elsewhere classified"
			lab val ilo_job1_ocu_isco88 isco88_1dig_lab
			lab var ilo_job1_ocu_isco88 "Occupation (ISCO-88)"	
			
		* Secondary activity [not indicated]
			
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
				
		* Secondary occupation --> not indicated whether secondary job as self-employed or employee
				* --> don't consider values		

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Geographical coverage ('ilo_geo') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: variable also includes option "extranjero" --> integrate those observations as well

	gen ilo_geo=.
			replace ilo_geo=1 if zona_res==0
			replace ilo_geo=2 if zona_res==1
		lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural"
		lab val ilo_geo ilo_geo_lab
		lab var ilo_geo "Geographical coverage"	
		
	* Integrating observations related to 'extranjero' 
	
		* drop if lab==1, in order to make commands below work properly
		
		drop if lab==1 /* in order to get rid of observations from tempfile */
	
	* create a series of help variables

			egen hhid=concat(s1_a05 s1_a06)

			gen foreign=1 if zona_res==2

			egen foreign_hhid=max(foreign), by(hhid)

			gen urban=1 if zona_res==0

			egen urban_hhid=max(urban) , by(hhid)

			gen rural=1 if zona_res==1

			egen rural_hhid=max(rural), by (hhid)

			egen dupli_zone=rowtotal(rural_hhid urban_hhid), m

			gen head_urban=1 if s3_05==1 & urban==1

			gen head_rural=1 if s3_05==1 & rural==1

				egen urban_head_hhid=max(head_urban), by (hhid)
				
				egen rural_head_hhid=max(head_rural), by (hhid)

				* Apply changes to variable ilo_geo (do these modifications only to observations for people living abroad!)
					* for the rest of the observation -> stick to the categorisation already done
					
				* to simplify the commands, consider the residence of the household head (doesn't change anything in the result if rest of 
					* the HH in the same geographical area)
					
					* procedure working in the following way:
						* attribute to the area to which rest of the household is being attributed
						* if mixed within household --> refer to the area associated with the head of the household
						* if entire household living abroad --> consider people working in agriculture as living in rural areas
						* remaining missing observations to be associated with urban area
					
				replace ilo_geo=1 if foreign==1 & urban_head_hhid==1
				replace ilo_geo=2 if foreign==1 & rural_head_hhid==1
					replace ilo_geo=1 if foreign==1 & urban_hhid==1 & dupli_zone==1 & ilo_geo==.
					replace ilo_geo=2 if foreign==1 & rural_hhid==1 & dupli_zone==1 & ilo_geo==.
					* put people working in the agricultural sector into rural
					replace ilo_geo=2 if foreign==1 & ilo_geo==. & ilo_job1_eco_aggregate==1
					replace ilo_geo=2 if foreign==1 & ilo_geo==. & ilo_job1_ocu_isco88==6
					* put remaining missing values into urban
					replace ilo_geo=1 if ilo_geo==.		
					
			drop hhid foreign foreign_hhid urban urban_hhid rural rural_hhid dupli_zone head_urban head_rural urban_head_hhid rural_head_hhid

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment: time usually dedicated to the primary activity being considered

			* note that the threshold for full-time employment differs according to the sector in 
				* which the person is working
			
			*hours usually worked being used as no actual hours indicated
	
	gen ilo_job1_job_time=.
		replace ilo_job1_job_time=1 if ((ilo_job1_ins_sector==1 & ilo_job1_how_usual>=40) | (ilo_job1_ins_sector==2 & ilo_job1_how_usual>=44)) & ilo_job1_how_usual!=.
		replace ilo_job1_job_time=2 if (ilo_job1_ins_sector==1 & ilo_job1_how_usual<40) | (ilo_job1_ins_sector==2 & ilo_job1_how_usual<44)
		replace ilo_job1_job_time=3 if ilo_job1_job_time==. & ilo_lfs==1
				replace ilo_job1_job_time=. if ilo_lfs!=1
			lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
			lab val ilo_job1_job_time job_time_lab
			lab var ilo_job1_job_time "Job (Working time arrangement)"	
			
			* if there is any secondary employment, by definition it is part-time, and therefore
				* variable for secondary employment not being defined
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job_contract') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment: variable only defined for primary employment, as question on the nature of the contract
	*		is not being asked for secondary employment
	
	gen ilo_job1_job_contract=.
		replace ilo_job1_job_contract=1 if s4_18e==1
		replace ilo_job1_job_contract=2 if inlist(s4_18e,2,3)
		replace ilo_job1_job_contract=3 if s4_18e==3 | (ilo_job1_job_contract==. & ilo_lfs==1)
				replace ilo_job1_job_contract=. if ilo_lfs!=1
			lab def job_contract_lab 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"
			lab val ilo_job1_job_contract job_contract_lab
			lab var ilo_job1_job_contract "Job (Type of contract)"
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Disability status ('ilo_dsb_details') [no info available]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment: 
	
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of unemployment ('ilo_cat_une') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment:
	
	gen ilo_cat_une=.
		replace ilo_cat_une=1 if s4_13==1
		replace ilo_cat_une=2 if s4_13==2
		replace ilo_cat_une=3 if ilo_cat_une==. & ilo_lfs==2
				replace ilo_cat_une=. if ilo_lfs!=2
			lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
			lab val ilo_cat_une cat_une_lab
			lab var ilo_cat_une "Category of unemployment"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment:	
			
	gen ilo_dur_aggregate=.
		replace ilo_dur_aggregate=1 if inlist(s4_10,1,2,3,4)
		replace ilo_dur_aggregate=2 if s4_10==5
		replace ilo_dur_aggregate=3 if s4_10==6
		replace ilo_dur_aggregate=4 if ilo_dur_aggregate==. & ilo_lfs==2
				replace ilo_dur_aggregate=. if ilo_lfs!=2
			lab def ilo_unemp_aggr 1 "Less than 6 months" 2 "6 months to less than 12 months" 3 "12 months or more" 4 "Not elsewhere classified"
			lab val ilo_dur_aggregate ilo_unemp_aggr
			lab var ilo_dur_aggregate "Duration of unemployment (Aggregate)"
		
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Unemployment benefits schemes ('ilo_soc_aggregate') [no info available]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment:

	/* gen ilo_soc_aggregate=.
		replace ilo_soc_aggregate=1 if
		replace ilo_soc_aggregate=2 if
			lab def soc_aggr_lab 1 "From insurance" 2 "From assistance"
			lab val ilo_soc_aggregate soc_aggr_lab 
			lab var ilo_soc_aggregate "Unemployment benefit schemes" */


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu_isco88') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			
* Comment: ISCO-88 classification being used

	* reduce it to the one digit level
	
	gen prevocu_cod=int(s4_16a/100) if ilo_lfs==2
	
	gen ilo_prevocu_isco88=prevocu_cod
		replace ilo_prevocu_isco88=10 if ilo_prevocu_isco88==0
		replace ilo_prevocu_isco88=11 if ilo_prevocu_isco88==. & ilo_cat_une==1 & ilo_lfs==2
		* value label already defined
		lab val ilo_prevocu_isco88 isco88_1dig_lab
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
			* value label already defined
			lab val ilo_prevocu_aggregate ocu_aggr_lab
			lab var ilo_prevocu_aggregate "Previous occupation (Aggregate)"		
		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: ISIC Rev. 3.1 classification being used 

		gen preveco_cod=int(s4_17a/10) if ilo_lfs==2
		
			* keep this variable on the two digit level, in order to be able to correctly execute the code below
		
	* Previous economic activity
	
	gen ilo_preveco_isic3=.
		replace ilo_preveco_isic3=1 if inrange(preveco_cod,1,2)
		replace ilo_preveco_isic3=2 if preveco_cod==5
		replace ilo_preveco_isic3=3 if inrange(preveco_cod,10,14)
		replace ilo_preveco_isic3=4 if inrange(preveco_cod,15,37)
		replace ilo_preveco_isic3=5 if inrange(preveco_cod,40,41)
		replace ilo_preveco_isic3=6 if preveco_cod==45
		replace ilo_preveco_isic3=7 if inrange(preveco_cod,50,52)
		replace ilo_preveco_isic3=8 if preveco_cod==55
		replace ilo_preveco_isic3=9 if inrange(preveco_cod,60,64)
		replace ilo_preveco_isic3=10 if inrange(preveco_cod,65,67)
		replace ilo_preveco_isic3=11 if inrange(preveco_cod,70,74)
		replace ilo_preveco_isic3=12 if preveco_cod==75
		replace ilo_preveco_isic3=13 if preveco_cod==80
		replace ilo_preveco_isic3=14 if preveco_cod==85
		replace ilo_preveco_isic3=15 if inrange(preveco_cod,90,93)
		replace ilo_preveco_isic3=16 if preveco_cod==95
		replace ilo_preveco_isic3=17 if preveco_cod==99
		replace ilo_preveco_isic3=18 if preveco_cod==. & ilo_lfs==2 & ilo_cat_une==1
			lab val ilo_preveco_isic3 isic3
			lab var ilo_preveco_isic3 "Previous economic activity (ISIC Rev. 3.1)"
	
		
		* Aggregate level
		
		gen ilo_preveco_aggregate=.
			replace ilo_preveco_aggregate=1 if inlist(ilo_preveco_isic3,1,2)
			replace ilo_preveco_aggregate=2 if ilo_preveco_isic3==4
			replace ilo_preveco_aggregate=3 if ilo_preveco_isic3==6
			replace ilo_preveco_aggregate=4 if inlist(ilo_preveco_isic3,3,5)
			replace ilo_preveco_aggregate=5 if inrange(ilo_preveco_isic3,7,11)
			replace ilo_preveco_aggregate=6 if inrange(ilo_preveco_isic3,12,17)
			replace ilo_preveco_aggregate=7 if ilo_preveco_isic3==18
			* value label already defined above			
			lab val ilo_preveco_aggregate eco_aggr_lab
			lab var ilo_preveco_aggregate "Previous economic activity (Aggregate)"

		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: Degree of labour market attachment of persons outside the labour force

	 gen ilo_olf_dlma=.
		replace ilo_olf_dlma=1 if (s4_07==1 | s4_08==1) & (s4_12==2 | s4_12a==2)
		replace ilo_olf_dlma=2 if s4_07==2 & s4_08==2 & (s4_12==1 | s4_12a==1)
		/* replace ilo_olf_dlma=3 if s4_07==2 & s4_08==2 &
		replace ilo_olf_dlma=4 if s4_07==2 & s4_08==2 & */
		replace ilo_olf_dlma=5 if ilo_olf_dlma==. & ilo_lfs==3
				replace ilo_olf_dlma=. if ilo_lfs!=3
			lab def lab_olf_dlma 1 "1 - Seeking, not available (Unavailable jobseekers)" 2 "2 - Not seeking, available (Available potential jobseekers)" ///
						3 "3 - Not seeking, not available, willing (Willing non-jobseekers)" 4 "4 - Not seeking, not available, not willing" 5 "5 - Not elsewhere classified"
			lab val ilo_olf_dlma lab_olf_dlma
			lab var ilo_olf_dlma "Labour market attachment (Degree of)"	
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reasons for not seeking a job ('ilo_olf_reason') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment:
	
	gen ilo_olf_reason=.
		replace ilo_olf_reason=1 if inlist(s4_11,1,3,10,11,12,14)
		replace ilo_olf_reason=2 if inlist(s4_11,2,4,5,6,7,8,9)
		replace ilo_olf_reason=3 if s4_11==13
		replace ilo_olf_reason=4 if ilo_olf_reason==. & ilo_lfs==3
			replace ilo_olf_reason=. if ilo_lfs!=3
			lab def lab_olf_reason 1 "1 - Labour market" 2 "2 - Personal/Family-related"  3 "3 - Does not need/want to work" 4 "4 - Not elsewhere classified"
			lab val ilo_olf_reason lab_olf_reason
			lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seekers ('ilo_dis')
* -------------------------------------------------------------------------------------------
* ------------------------------------------------------------------------------------------- 
*
* Comment: 	

		gen ilo_dis=1 if ilo_olf_reason==1 & ilo_lfs==3
			lab def ilo_dis_lab 1 "Discouraged job-seekers" 
			lab val ilo_dis ilo_dis_lab
			lab var ilo_dis "Discouraged job-seekers"			

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Informal/Formal economy: Unit of production (ilo_job1_ife_prod) 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* 

    /* Useful questions:
				* Institutional sector: s4_18 (based on occupation)
				* Destination of production: not asked
				* Bookkeeping: not asked
				* Registration: s4_21 (proxy -> actual question: does the establishment/business have a license/permit to operate?)
				* Status in employment: ilo_job1_ste_icse93==1 (employees)
				* Social security contribution (pension insurance): s4_18g1 (AFP o plan de pension) (only to employees)
				* Place of work: not asked
				* Size: s4_20	
				* Private HH: Activities of Private HH: ilo_job1_eco_isic3_2digits (==95)*/
	
	* ONLY FOR MAIN JOB.
	
	* Social security (to be dropped afterwards)
	
	        gen social_security=.
			    replace social_security=1 if (s4_18g1==1 & ilo_lfs==1)          // Pension insurance
				replace social_security=2 if (s4_18g1==2 & ilo_lfs==1)          // No pension insurance
				replace social_security=. if (social_security==. & ilo_lfs==1)
				
				
    * 1) UNIT OF PRODUCTION: FORMAL/INFORMAL SECTOR		
    			
			gen ilo_job1_ife_prod=.
			    replace ilo_job1_ife_prod=1 if ilo_lfs==1 & ///
				                               ((inlist(s4_18,3,4,5,6,.) & s4_21==2) | ///
											   (inlist(s4_18,3,4,5,6,.) & inlist(s4_21,3,.) & ilo_job1_ste_icse93==1 & inlist(social_security,2,.)) | ///
											   (inlist(s4_18,3,4,5,6,.) & inlist(s4_21,3,.) & ilo_job1_ste_icse93!=1))
			    replace ilo_job1_ife_prod=2 if ilo_lfs==1 & ///
				                               ((inlist(s4_18,1,2)) | ///
											   (inlist(s4_18,3,4,5,6,.) & s4_21==1) | ///
											   (inlist(s4_18,3,4,5,6,.) & inlist(s4_21,3,.) & ilo_job1_ste_icse93==1 & social_security==1))
				replace ilo_job1_ife_prod=3 if ilo_lfs==1 & ///
				                               (inlist(s4_18,7,8)) 
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
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

*			SAVE RESULTS

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------


* -------------------------------------------------------------
* 1.	Prepare final dataset
* -------------------------------------------------------------

cd "$outpath"

		drop ilo_age /* as only age bands being kept and this variable used as help variable */
		
		drop indu_code_* occ_code_* prevocu_cod preveco_cod monthly_revenue bonus in_kind_payment lab isco08_2digits isco88_2digits isco08 isco88 isic4_2digits isic4 isic3_2digits isic3
	
		compress 
		
	* Save dataset including original and ilo variables
	
		saveold DOM_ENFT_2014Q4_FULL, version(12) replace		
	
	*Save file only containing ilo_* variables
	
		keep ilo*

		saveold DOM_ENFT_2014Q4_ILO, version(12) replace
		



