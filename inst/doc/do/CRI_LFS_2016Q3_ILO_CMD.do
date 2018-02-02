* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Costa Rica
* DATASET USED: Costa Rica LFS
* NOTES: 
* Files created: Standard variables on LFS Costa Rica
* Authors: Podjanin
* Starting Date: 31 August 2016
* Last updated: 17 March 2017
***********************************************************************************************



*******************************************************************
 /* 1.	Set up work directory, file name, variables and function */
*******************************************************************

clear all 

set more off

global path "J:\COMMON\STATISTICS\DPAU\MICRO"
global country "CRI"
global source "LFS"
global time "2016Q3"
global inputFile "CRI_LFS_2016Q3"

global inpath "${path}\\${country}\\${source}\\${time}\ORI"
global temppath "${path}\_Admin"
global outpath "${path}\\${country}\\${source}\\${time}"

***************************************************************

cd "$inpath"

	use ${inputFile}, clear	
	
*****************************************************************************************
*truncate original variable labels, as original variables can't be saved in old format otherwise 
	* (cf. end of do-file) 
	
	
	* Variable names too long --> truncate them in order to be able to save data in old format 
			
*			foreach v of varlist _all {
*		   local wholelab: variable label `v'
*		   local shortlab = substr("`wholelab'",1,80)
*		   label var `v' "`shortlab'"		   
*		   }
		   
**********************************************************************************************
		
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

	gen ilo_key=_n
		lab var ilo_key "Key unique identifier per individual"
	
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sample Weight ('ilo_wgt') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*		

	gen ilo_wgt=Factor_ponderacion
		lab var ilo_wgt "Sample weight"
	
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time period ('ilo_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*

	gen ilo_time=1
		lab def time_lab 1 "$time"
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

	gen ilo_geo=ZONA_ID
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

	gen ilo_sex=A5S
		label define label_Sex 1 "1 - Male" 2 "2 - Female"
		label values ilo_sex label_Sex
		lab var ilo_sex "Sex"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: if age indicated as 97, labelled as "97 or more" // value 99 labelled as "aged 15 or above with age being ignored 
															* (mayor de 15 años con edad ignorada)

	gen ilo_age=A6S
		lab var ilo_age "Age"
		
		*as unknown age is given the value 99, it will fall in the category 65+ (coherent with the technical note)
		
		* remember to keep this variable only as help variable for the definition of the following age bands
			* --> drop the variable at the very end of the do-file

	
*Age groups

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
*			Level of education ('ilo_edu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: Given the definition of the levels of education, ISCED97 is being chosen
			* Educación Parauniversitaria: http://www.sinaes.ac.cr/images/docs/proceso_acreditacion/SINAES%20Diag%20Parauniversitarias%20Seg%20iforme_VP_5Mayo2011%20PUB.pdf
			
			* Note that according to the definition, the highest level being CONCLUDED is being considered

	gen ilo_edu_isced97=.
		replace ilo_edu_isced97=1 if A16==0 /* ok */
		replace ilo_edu_isced97=2 if inrange(A16,1,15)
		replace ilo_edu_isced97=3 if inrange(A16,16,22) | inlist(A16,31,32)
		replace ilo_edu_isced97=4 if inrange(A16,23,25) | inrange(A16,33,36)
		replace ilo_edu_isced97=5 if inlist(A16,26,37,41,42,51,52)
		replace ilo_edu_isced97=6 if A16==43
		replace ilo_edu_isced97=7 if inlist(A16,53,54,55)
		replace ilo_edu_isced97=8 if inrange(A16,72,85) /* ok */
		replace ilo_edu_isced97=9 if A16==99
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
*			Education attendance ('ilo_edu_attendance') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: 
		gen ilo_edu_attendance=.
			replace ilo_edu_attendance=1 if inrange(A15,1,6)
			replace ilo_edu_attendance=2 if A15==7
			replace ilo_edu_attendance=3 if ilo_edu_attendance==.
				lab def edu_attendance_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
				lab val ilo_edu_attendance edu_attendance_lab
				lab var ilo_edu_attendance "Education (Attendance)"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Disability status ('ilo_dsb_details') [no info available]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment: No info available

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
			label var ilo_wap "Working age population" //15+ population

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Labour Force Status ('ilo_lfs') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*            	 
* Comment: question B6 asks for what reason the person is not available for work immediately or within the following two weeks
			* option 6 and 7 correspond to "for personal reasons (studies, planned trip)" and "could, but in another moment", which indicated that the unavailability is 
				* only temporary - however note that those individuals are being directly redirected to Section I for people outside the labour force, without even asking them 
				* whether they are looking for a job for later on or not...
 
	gen ilo_lfs=.
		replace ilo_lfs=1 if B1==1 | inrange(B2,1,7) | B3==1 | inrange(B5,1,5)
		replace ilo_lfs=2 if (B4==2 & inlist(B6,8,9) & inrange(B7,1,11)) |(B4==2 & inlist(B6,8,9) & inlist(B8,1,2,3))
		replace ilo_lfs=3 if (inrange(B6,1,7) | inrange(B8,4,14) ) | ilo_lfs==.
			replace ilo_lfs=. if ilo_wap==0	
				label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status" 
				
				
	* National definition -->  refer to the "manual del entrevistador" : http://sistemas.inec.cr/pad4/index.php/catalog/149/download/1056 on page 80 (in Spanish)
	
	gen nat_lfs=.
		replace nat_lfs=1 if B1==1 | inrange(B2,1,7) | B3==1 | inrange(B5,1,5) /* definition same as ilo_lfs=1 */
		replace nat_lfs=2 if inrange(B7,1,11) | inrange(B8,1,3)
		replace nat_lfs=3 if inrange(B6,1,7)  | inrange(B8,4,14)
			replace nat_lfs=. if ilo_wap==0
			label value nat_lfs label_ilo_lfs /* as labels are the same as for the ILO variable */
			label var nat_lfs "Labour Force Status (national definition)" 
					
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: 

	gen ilo_mjh=.
		replace ilo_mjh=1 if F1==1
		replace ilo_mjh=2 if inlist(F1,2,3)
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
* Comment: 	consider the status in employment for each occupation 

	* Primary employment
		
			gen ilo_job1_ste_icse93=.
				replace ilo_job1_ste_icse93=1 if inlist(C13,2,3) | (inlist(C13,4,5) & C14==1)
				replace ilo_job1_ste_icse93=2 if C13==1 & inlist(D1,1,2)
				replace ilo_job1_ste_icse93=3 if C13==1 & D1==3
				/*replace ilo_job1_ste_icse93=4 if C13==1*/
				replace ilo_job1_ste_icse93=5 if C13==4 & C17_1A==1
				replace ilo_job1_ste_icse93=6 if (C13==4 & C17_1A==2) | C13==5
					replace ilo_job1_ste_icse93=6 if ilo_job1_ste_icse93==. & ilo_lfs==1
					replace ilo_job1_ste_icse93=. if ilo_lfs!=1
				
				label def label_ilo_ste_icse93 1 "1 - Employees" 2 "2 - Employers" 3 "3 - Own-account workers" 4 "4 - Members of producers' cooperatives" 5 "5 - Contributing family workers" ///
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
				
	* Secondary employment
		
			gen ilo_job2_ste_icse93=.
				replace ilo_job2_ste_icse93=1 if inlist(F4,2,3,4)
				replace ilo_job2_ste_icse93=2 if F4==1 & inlist(F5,1,2)
				replace ilo_job2_ste_icse93=3 if F4==1 & F5==3
				/* replace ilo_job2_ste_icse93=4 if C13==1 */
				replace ilo_job2_ste_icse93=5 if F4==5
				/* replace ilo_job2_ste_icse93=6 if (C13==4 & C17_1A==2) | C13==5 */
					replace ilo_job2_ste_icse93=6 if ilo_job2_ste_icse93==. & ilo_mjh==2 & ilo_lfs==1
					replace ilo_job2_ste_icse93=. if ilo_lfs!=1 & ilo_mjh!=2
					* value labels already defined
			label value ilo_job2_ste_icse93 label_ilo_ste_icse93
			label var ilo_job2_ste_icse93 "Status in employment (ICSE 93) in secondary job"

		* Aggregate categories
		
			gen ilo_job2_ste_aggregate=.
				replace ilo_job2_ste_aggregate=1 if ilo_job2_ste_icse93==1
				replace ilo_job2_ste_aggregate=2 if inlist(ilo_job2_ste_icse93,2,3,4)
				replace ilo_job2_ste_aggregate=3 if inlist(ilo_job2_ste_icse93,5,6)
					* value labels already defined
					lab val ilo_job2_ste_aggregate ste_aggr_lab
				label var ilo_job2_ste_aggregate "Status in employment (Aggregate) in secondary job"
				


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: separate according to occupations 

		* as classification used in original data doesn't follow any ISIC classification, use the most aggregate form to classify the economic activity
		
		* Main job
		
		gen ilo_job1_eco_aggregate=.
			replace ilo_job1_eco_aggregate=1 if Rama_actividad==1
			replace ilo_job1_eco_aggregate=2 if Rama_actividad==2
			replace ilo_job1_eco_aggregate=3 if Rama_actividad==3
			replace ilo_job1_eco_aggregate=4 if Rama_actividad==4
			replace ilo_job1_eco_aggregate=5 if inrange(Rama_actividad,5,9)
			replace ilo_job1_eco_aggregate=6 if inrange(Rama_actividad,10,13)
			replace ilo_job1_eco_aggregate=7 if Rama_actividad==99
			replace ilo_job1_eco_aggregate=7 if ilo_job1_eco_aggregate==. & ilo_lfs==1
				lab def ilo_eco_aggreg_lab 1 "1 - Agriculture" 2 "2 - Manufacturing" 3 "3 - Construction" 4 "Mining and quarrying; Electricity, gas and water supply" ///
								5 "5 - Market Services (Trade; Transportation; Accommodation and food; and Business and administrative services)" ///
								6 "6 - Non-market services (Public administration; Community, social and other services and activities)" 7 "7 - Not classifiable by economic activity"
				lab val ilo_job1_eco_aggregate ilo_eco_aggreg_lab
				lab var ilo_job1_eco_aggregate "Economic activity (Aggregate)"
				
		* For secondary job, only indicated whether the job belongs to the primary, secondary or tertiary sector --> therefore info not being considered
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_ocu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: Info only at the most aggregate level - note that "ocupación no calificada (unqualified occupation)" is being considered as low-skilled occupation

	* Skill level
	
		* Primary occupation
	
		gen ilo_job1_ocu_skill=.
			replace ilo_job1_ocu_skill=1 if Calificacion_ocupacion_COCR11==3
			replace ilo_job1_ocu_skill=2 if Calificacion_ocupacion_COCR11==2
			replace ilo_job1_ocu_skill=3 if Calificacion_ocupacion_COCR11==1
			replace ilo_job1_ocu_skill=4 if ilo_job1_ocu_skill==. & ilo_lfs==1
					replace ilo_job1_ocu_skill=. if ilo_lfs!=1
				lab def ocu_skill_lab 1 "1 - Skill level 1 (low)" 2 "2 - Skill level 2 (medium)" 3 "3 - Skill levels 3 and 4 (high)" 4 "4 - Not elsewhere classified"
				lab val ilo_job1_ocu_skill ocu_skill_lab
				lab var ilo_job1_ocu_skill "Occupation (Skill level)"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_ins_sector') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
		
* Comment: Separate according to activities /// All type of employed persons are being considered
		
	gen ilo_job1_ins_sector=.
		replace ilo_job1_ins_sector=1 if C9==4
		replace ilo_job1_ins_sector=2 if inrange(C9,1,3) | (ilo_job1_ins_sector==. & ilo_lfs==1)
				replace ilo_job1_ins_sector=. if ilo_lfs!=1
			lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
			lab values ilo_job1_ins_sector ins_sector_lab
			lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities"
			
		* Institutional sector not indicated for secondary occupation					
		
		
* --------------------------------------------------------------------------------------------------
* --------------------------------------------------------------------------------------------------
*		Weekly hours actually (USUALLY) worked ('ilo_how_actual') and ('ilo_how_usual') [done]
* --------------------------------------------------------------------------------------------------
* --------------------------------------------------------------------------------------------------
* 
* Comment: consider first working time associated with each job (if available) and then consider the sum (i.e.
				* the time dedicated to all working activities during the week
				
	* Main job
	
	gen ilo_job1_how_actual=C7D if !inlist(C7D,.,999)
		lab var ilo_job1_how_actual "Weekly hours actually worked in main job"
	
	gen ilo_job1_how_usual=C7A if !inlist(C7A,.,999)
		lab var ilo_job1_how_usual "Weekly hours usually worked in main job"
		
	* Secondary job
		* note that it includes secondary job, but also all other jobs, if more than two jobs
	
	gen ilo_job2_how_actual=F6D if !inlist(F6D,.,999) & ilo_mjh==2
		lab var ilo_job2_how_actual "Weekly hours actually worked in secondary job"
	
	gen ilo_job2_how_usual=F6A if !inlist(F6A,.,999) & ilo_mjh==2
		lab var ilo_job2_how_usual "Weekly hours usually worked in secondary job"
		
	* All jobs
	
	egen ilo_joball_how_actual=rowtotal(ilo_job1_how_actual ilo_job2_how_actual), m
		lab var ilo_joball_how_actual "Weekly hours actually worked in all jobs"
	
	egen ilo_joball_how_usual=rowtotal(ilo_job1_how_usual ilo_job2_how_usual), m
		lab var ilo_joball_how_usual "Weekly hours usually worked in all jobs"
		
		*Weekly hours actually worked --> bands --> do it for all jobs separately and the define a variable for all jobs together
		
	* Primary occupation
	
	gen ilo_job1_how_actual_bands=.
		replace ilo_job1_how_actual_bands=1 if ilo_job1_how_actual==0
		replace ilo_job1_how_actual_bands=2 if ilo_job1_how_actual>=1 & ilo_job1_how_actual<=14
		replace ilo_job1_how_actual_bands=3 if ilo_job1_how_actual>=15 & ilo_job1_how_actual<=29
		replace ilo_job1_how_actual_bands=4 if ilo_job1_how_actual>=30 & ilo_job1_how_actual<=34
		replace ilo_job1_how_actual_bands=5 if ilo_job1_how_actual>=35 & ilo_job1_how_actual<=39
		replace ilo_job1_how_actual_bands=6 if ilo_job1_how_actual>=40 & ilo_job1_how_actual<=48
		replace ilo_job1_how_actual_bands=7 if ilo_job1_how_actual>=49 & ilo_job1_how_actual!=.
		replace ilo_job1_how_actual_bands=8 if ilo_lfs==1 & ilo_job1_how_actual_bands==.
			lab def how_bands_lab 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"
			lab val ilo_job1_how_actual_bands how_bands_lab
			lab var ilo_job1_how_actual_bands "Bands of weekly hours actually worked in main job"
			
	* Secondary occupation

	gen ilo_job2_how_actual_bands=.
		replace ilo_job2_how_actual_bands=1 if ilo_job2_how_actual==0
		replace ilo_job2_how_actual_bands=2 if ilo_job2_how_actual>=1 & ilo_job2_how_actual<=14
		replace ilo_job2_how_actual_bands=3 if ilo_job2_how_actual>=15 & ilo_job2_how_actual<=29
		replace ilo_job2_how_actual_bands=4 if ilo_job2_how_actual>=30 & ilo_job2_how_actual<=34
		replace ilo_job2_how_actual_bands=5 if ilo_job2_how_actual>=35 & ilo_job2_how_actual<=39
		replace ilo_job2_how_actual_bands=6 if ilo_job2_how_actual>=40 & ilo_job2_how_actual<=48
		replace ilo_job2_how_actual_bands=7 if ilo_job2_how_actual>=49 & ilo_job2_how_actual!=.
		replace ilo_job2_how_actual_bands=8 if ilo_lfs==1 & ilo_mjh==2 & ilo_job2_how_actual_bands==.
			* label already defined
			lab val ilo_job2_how_actual_bands how_bands_lab
			lab var ilo_job2_how_actual_bands "Weekly hours actually worked bands in secondary job"
		
	
	gen ilo_joball_how_actual_bands=.
		replace ilo_joball_how_actual_bands=1 if ilo_joball_how_actual==0
		replace ilo_joball_how_actual_bands=2 if ilo_joball_how_actual>=1 & ilo_joball_how_actual<=14
		replace ilo_joball_how_actual_bands=3 if ilo_joball_how_actual>=15 & ilo_joball_how_actual<=29
		replace ilo_joball_how_actual_bands=4 if ilo_joball_how_actual>=30 & ilo_joball_how_actual<=34
		replace ilo_joball_how_actual_bands=5 if ilo_joball_how_actual>=35 & ilo_joball_how_actual<=39
		replace ilo_joball_how_actual_bands=6 if ilo_joball_how_actual>=40 & ilo_joball_how_actual<=48
		replace ilo_joball_how_actual_bands=7 if ilo_joball_how_actual>=49 & ilo_joball_how_actual!=.
		replace ilo_joball_how_actual_bands=8 if ilo_lfs==1 & ilo_joball_how_actual_bands==.
			* label already defined
			lab val ilo_joball_how_actual_bands how_bands_lab
			lab var ilo_joball_how_actual_bands "Bands of weekly hours actually worked in main job"
			
			* see whether name of the variable should be changed and whether a supplementary variable should be created for the main job
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment: separate according to activity and consider hours usually worked

			* full-time work considered: 40 h per week
	
	gen ilo_job1_job_time=.
		replace ilo_job1_job_time=1 if C7A<=39 & C7A==.
		replace ilo_job1_job_time=2 if C7A>=40 & !inlist(C7A,.,999)
		replace ilo_job1_job_time=3 if C7A==999 | (ilo_lfs==1 & ilo_job1_job_time==.)
			lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
			lab val ilo_job1_job_time job_time_lab
			lab var ilo_job1_job_time "Job (Working time arrangement)"	
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job_contract') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment: separate acording to activities
	
	gen ilo_job1_job_contract=.
		replace ilo_job1_job_contract=1 if E1==1
		replace ilo_job1_job_contract=2 if inlist(E1,2,3,4,5)
		replace ilo_job1_job_contract=3 if ilo_lfs==1 & ilo_job1_job_contract==.
				replace ilo_job1_job_contract=. if ilo_lfs!=1
			lab def job_contract_lab 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"
			lab val ilo_job1_job_contract job_contract_lab
			lab var ilo_job1_job_contract "Job (Type of contract)"
			
	* Nature of contract not being asked for the secondary occupation
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Informal/Formal economy: Unit of production (ilo_job1_ife_prod) [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* 
* Comment:

	* Variable formulated by INEC --> "Formalidad_informalidad"

	* Useful questions: C8: size of establishment --> use threshold defined in pre-processing document
					* 	C8A: place of work (to identify domestic workers) --> as destination of production not indicated
					* 	C9: institutional sector --> public sector and household sector (as employer) directly identified (household probably not entirely, other questions will probably
										* help to identify it further)
					* 	D8: Registration of the enterprise --> note that question only asked to self-employed
					* 	D9: Accountability --> also question only asked to self-employed
					* 	D14_1: Social security --> only asked to self-employed in enterprises having an accountability and if worker said 
										* that it has a salary assigned --> only criterion being used for self-employed
					* 	questions D16 to D27 contain some info about the destination of production, but as these are directed only to enterprises
										* that don't have any kind of accountability, these questions should be disregarded
					*	E10A: Social security --> question only asked to employees 
					
					* 	E9A: Sick leave (only asked to employees)
					*	E9B: Paid holidays (only asked to employees)
					
				
			* for secondary job, too much info missing (e.g. public sector not identified at all)
	
	gen ilo_job1_ife_prod=.
		replace ilo_job1_ife_prod=1 if (!inlist(C9,3,4) & D9!=1 & D8!=1) | (!inlist(C9,3,4) & D9!=1 & D8!=1 & ///
			((ilo_job1_ste_aggregate==1 & E10A!=1) | ilo_job1_ste_aggregate!=1) & (!inlist(C8A,1,2,3,4,5,6) | (!inlist(C8A,1,2,3,4,5,6) & !inrange(C8,6,13))))
		replace ilo_job1_ife_prod=2 if C9==4 | (!inlist(C9,3,4) & D9==1) | (!inlist(C9,3,4) & D9!=1 & D8==1) | (!inlist(C9,3,4) & D9!=1 & D8!=1 & ilo_job1_ste_aggregate==1 & E10A==1) | ///
													(!inlist(C9,3,4) & D9!=1 & D8!=1 & ((ilo_job1_ste_aggregate==1 & E10A!=1) | ilo_job1_ste_aggregate!=1) & inlist(C8A,1,2,3,4,5,6) & inrange(C8,6,13))
		replace ilo_job1_ife_prod=3 if C9==3
		replace ilo_job1_ife_prod=4 if ilo_job1_ife_prod==. & ilo_lfs==1
				replace ilo_job1_ife_prod=. if ilo_lfs!=1
			lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 4 "4 - Not elsewhere classified"
			lab val ilo_job1_ife_prod ilo_ife_prod_lab
			lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"
			
	* Definition of informal sector following the national definition: 
		* cf. on page 7 of the following document: http://www.inec.go.cr/wwwisis/documentos/INEC/ECE/2014/ECE-Empleo-Informal-CR.pdf 
		* Refer also to the "Comunicado de Prensa" for the 1st quarter 2015 (footnote containing a broad definition of informality)
		
			* criteria used:
				* a) Employees that have not been registered in a social security scheme by their employer
				* b) Unpaid workers
				* c) Own-account workers and employers that work in enterprises not being registered in the "Registro Nacional de Propiedad" and not keeping any accounts 
				
	gen nat_ife_sector=.
		replace nat_ife_sector=1 if inlist(E10A,2,3) | inlist(E7,8,9) | (inlist(C13,4,5) & C14==2) | (inlist(D8,2,3) & inlist(D9,2,3)) | inlist(D4,1,2)
		replace nat_ife_sector=2 if E10A==1 | (inlist(D8,1,2) & D9==1)
		replace nat_ife_sector=. if ilo_lfs!=1
			lab def nat_ife_sector_lab 1 "informal" 2 "formal"
			lab val nat_ife_sector nat_ife_sector_lab
			lab var nat_ife_sector "Formal/informal sector - National definition"
		
		/* Definition following press communication (1st quarter 2015): 
		
		replace nat_ife_sector=1 if E10A==2 | (inlist(C13,4,5) & C14==2) | (inlist(D8,2,3) & inlist(D9,2,3))
		replace nat_ife_sector=2 if ilo_lfs==1 & nat_ife_sector==. & ilo_wap==1
		replace nat_ife_sector=. if ilo_lfs!=1
		
		*/
		

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Informal/formal economy: nature of job (ilo_job1_ife_nature) [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: 

	gen ilo_job1_ife_nature=.
		replace ilo_job1_ife_nature=1 if ilo_job1_ste_icse93==5 | (inlist(ilo_job1_ste_icse93,2,3,4) & inlist(ilo_job1_ife_prod,1,3)) | (inlist(ilo_job1_ste_icse93,1,6) & E10A!=1)
		replace ilo_job1_ife_nature=2 if (inlist(ilo_job1_ste_icse93,2,3,4) & ilo_job1_ife_prod==2) | (inlist(ilo_job1_ste_icse93,1,6) & E10A==1)
		replace ilo_job1_ife_nature=. if ilo_lfs!=1
			lab def ife_nature_lab 1 "1 - Persons with informal main job" 2 "2 - Persons with formal main job"
			lab val ilo_job1_ife_nature ife_nature_lab
			lab var ilo_job1_ife_nature "Informal / Formal Economy (Nature of job)"		
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Earnings ('ilo_ear_ees' and 'ilo_ear_slf')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	
* Classify earnings according to the occupation (i.e. primary and secondary) and then consider in a variable 
	* all labour related income for all jobs together
	
		* note that in section I (where people outside the labour force are being redirected to) is also asking for some labour-related income
			* as this appears to be contradictory, this income is not being considered in the following calculations
	
			*Currency in Costa Rica: Costa Rican Colón (CRC)
			
			* create additional variables in order to avoid modifying any of the original variables, being kept in the "FULL" dataset
	
	* Primary occupation:
		
		* Monthly earnings of employees
		
			* all type of extraordinary income (tips, bonuses, etc.) not included 
			* include bonuses and income related to extra hours
		
			* questions E16 and E17 from questionnaire do not appear in dataset...!
			
			gen aguinaldo_emp=E13A1/12
		
			foreach var of varlist E11A E15A1 E15B1 E15C1 E15D1 E15E1 E14A1B E14A2B E14A3B E14A4B aguinaldo_emp {
			
			gen salary_`var'=`var' if `var'!=99999999
			
			}
								
		egen ilo_job1_lri_ees=rowtotal(salary_*), m		
			lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"
	
		*Monthly labour related income of self-employed (own consumption also taken into account)
		
			gen aguinaldo_self=D14A_2/12		
		
			foreach var of varlist C18 D11 D12 D15A1 D15B1 D15C1 D15D1 D15E1 D18 D18A D21 D24 D24A D25 D27 aguinaldo_self {
			
			gen selfemp_`var'=`var' if `var'!=99999999
			
			}
			
			replace selfemp_D12=. if D12==1
			replace selfemp_D25=. if D25==1
		
		egen ilo_job1_lri_slf=rowtotal(selfemp_*), m 
			lab var ilo_job1_lri_slf "Monthly labour related income of self-employed in main job"
			
	* Secondary occupation
	
	* Monthly earnings of employees
		
			gen salary_sec1=F9A if F9A!=99999999
			gen salary_sec2=F13A if F13A!=99999999
		
		egen ilo_job2_lri_ees=rowtotal(salary_sec1 salary_sec2), m	
				replace ilo_job2_lri_ees=. if ilo_lfs!=1 & ilo_mjh!=2
			lab var ilo_job2_lri_ees "Monthly earnings of employees in secondary job"
			
		*Monthly labour related income of self-employed
			
			gen earn_self_emp_sec=F7C if F7C!=99999999
				replace earn_self_emp_sec=F7C/4 if F7C1==6 
				replace earn_self_emp_sec=F7C/6 if F7C1==7 
				replace earn_self_emp_sec=F7C/12 if F7C1==8 
				
			gen own_cons_sec=F8A if F8A!=99999999
				replace own_cons_sec=F8A/4 if F8B==6
				replace own_cons_sec=F8A/6 if F8B==7
				replace own_cons_sec=F8A/12 if F8B==8
		
		egen ilo_job2_lri_slf=rowtotal(earn_self_emp_sec own_cons_sec), m 
				replace ilo_job2_lri_slf=. if ilo_lfs!=1 & ilo_mjh!=2
			lab var ilo_job2_lri_slf "Monthly labour related income of self-employed in secondary job"
			
			
	* Other occupations --> given that is not indicated whether the revenue is related to wage employment or
		* self employment, corresponding values are not going to be included...	
		
***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************			
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_tru') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*                
* Comment: 	National threshold for full-time employment set at 40 hours per week -> therefore according to the time-related criterion 
				* workers working 39 hours and less are considered as underemployed
				
					* actual hours worked are going to be considered
				
				* consider all jobs for the definition of time-related underemployment (i.e. total hours spent working)

	gen ilo_joball_tru=1 if ilo_joball_how_actual<=39 & G1==1 & inlist(G2,1,2)
		replace ilo_joball_tru=. if ilo_lfs!=1
			lab def tru_lab 1 "Time-related underemployed"
			lab val ilo_joball_tru tru_lab
			lab var ilo_joball_tru "Time-related underemployed"
			
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
* Comment: note that the question "H12" appearing in the questionnaire doesn't appear in the datafile, which asked both to formerly employed and people seeking their new employment for how long
				* they have been looking for a job --> H2_N only asks to those that have been previously employed... 
							
	/* gen ilo_dur_details=.
		replace ilo_dur_details=1 if H2_N==1
		replace ilo_dur_details=2 if H2_N==2
		replace ilo_dur_details=3 if H2_N==3
		replace ilo_dur_details=4 if H2_N==4
		/* replace ilo_dur_details=5 if H2_N 
		replace ilo_dur_details=6 if H2_N */
		replace ilo_dur_details=7 if H2_N==7
			lab def ilo_unemp_det 1 "Less than 1 month" 2 "1 month to less than 3 months" 3 "3 months to less than 6 months" 4 "6 months to less than 12 months" 5 "12 months to less than 24 months" ///
									6 "24 months or more" 7 "Not elsewhere classified"
			lab values ilo_dur_details ilo_unemp_det
			lab var ilo_dur_details "Duration of unemployment (Details)" "/ */
			
			
	* as values do not coincide with previous classification, use aggregate version 			
			
	gen ilo_dur_aggregate=.
		replace ilo_dur_aggregate=1 if inlist(H2_N,1,2,3)
		replace ilo_dur_aggregate=2 if H2_N==4
		replace ilo_dur_aggregate=3 if inlist(H2_N,5,6)
		replace ilo_dur_aggregate=4 if H2_N==7 | (ilo_dur_aggregate==. & ilo_lfs==2)
			lab def ilo_unemp_aggr 1 "Less than 6 months" 2 "6 months to less than 12 months" 3 "12 months or more" 4 "Not elsewhere classified"
			lab val ilo_dur_aggregate ilo_unemp_aggr
			lab var ilo_dur_aggregate "Duration of unemployment (Aggregate)"
		 *not elsewhere classified --> didn't do anything to look for a job since person left its last job...
		 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Category of unemployment ('ilo_cat_une') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment:
	
	gen ilo_cat_une=.
		replace ilo_cat_une=1 if H1==1
		replace ilo_cat_une=2 if H1==2
		replace ilo_cat_une=3 if ilo_lfs==2 & ilo_cat_une==.
			lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
			lab val ilo_cat_une cat_une_lab
			lab var ilo_cat_une "Category of unemployment"
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: For previous employment, only being indicated whether job belonged to primary, secondary or tertiary employment

			* --> therefore no variable being defined
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu_isco08') [no info available]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			
* Comment: variable can't be defined as no info is given

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Unemployment benefits schemes ('ilo_soc_aggregate') [no info available]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment:

	/* gen ilo_soc_aggregate=.
		replace ilo_soc_aggregate=1 if
		replace ilo_soc_aggregate=2 if
			lab def soc_aggr_lab 1 "From insurance" 2 "From assistance"
			lab val ilo_soc_aggregate soc_aggr_lab 
			lab var ilo_soc_aggregate "Unemployment benefit schemes" */
			
***********************************************************************************************
*			PART 3.4. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: Degree of labour market attachment of persons outside the labour force

		* not all options of the variable can be defined:
				* persons being unavailable are directly redirected to the "outside labour force" section, where they're only being asked 
				* whether they had an occasional employment, but nothing about their job search
		* People that are available for a job and have actively been looking for a job are redirected to the section dedicated to unemployed people
				* and therefore don't appear at all among the people being outside the labour force
		* Definition of people "not seeking, not available and not willing" is also not possible as most of the questions required for the definition don't appear
				* in the actual dataset
				
				* --> as too few information available (only one out of four values could be defined), simply don't define this variable for Costa Rica
				
			* Note that people who were not available were not even asked question B7, therefore only this one being taken into consideration for the definition of option 2
	
	gen ilo_olf_dlma=.
		/* replace ilo_olf_dlma=1 if */
		replace ilo_olf_dlma=2 if B7==12
		/* replace ilo_olf_dlma=3 if */
		/* replace ilo_olf_dlma=4 if */
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
			replace ilo_olf_reason=1 if inlist(B8,7,8)
			replace ilo_olf_reason=2 if inlist(B6,2,3,4,5,6,7) | inlist(B8,4,5,6,10,11,12,13)
			replace ilo_olf_reason=3 if B6==1
			replace ilo_olf_reason=4 if B6==99 | (ilo_olf_reason==. & ilo_lfs==3)
				replace ilo_olf_reason=. if ilo_lfs!=3
					lab def lab_olf_reason 1 "1 - Labour market" 2 "2 - Personal/Family-related"  3 "3 - Does not need/want to work" 4 "4 - Not elsewhere classified"
					lab val ilo_olf_reason lab_olf_reason
					lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"		
		

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seekers ('ilo_dis') [done]
* -------------------------------------------------------------------------------------------
* ------------------------------------------------------------------------------------------- 
*
* Comment: 	Individuals included:
			* - doesn't have money to look for a job
			* - is tired of searching
			* - doesn't get a job due to discrimination 
			* - there is no job in the area
			* - during this period of the year there is no job

	gen ilo_dis=1 if inrange(B8,4,8) & ilo_lfs==3
			lab def dis_lab 1 "Discouraged job-seekers"
			lab val ilo_dis dis_lab
			lab var ilo_dis "Discouraged job-seekers"
			
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

*			SAVE RESULTS

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* -------------------------------------------------------------
* 1.	Prepare final dataset
* -------------------------------------------------------------

cd "$outpath"

		drop ilo_age /* as only age bands being kept and this variable used as help variable */
		
		drop selfemp_* salary_* earn_self_emp_sec own_cons_sec aguinaldo_emp aguinaldo_self
		
		compress
		
	* Save dataset including original and ilo variables
	
		save ${country}_${source}_${time}_FULL,  replace		
	
	*Save file only containing ilo_* variables
	
		keep ilo*

		save ${country}_${source}_${time}_ILO, replace
		



