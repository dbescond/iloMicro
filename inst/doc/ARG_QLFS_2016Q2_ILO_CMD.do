* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Argentina 
* DATASET USED: Argentina QLFS 
* NOTES: 
* Files created: Standard variables on QLFS Argentina 
* Authors: Podjanin
* Who last updated the file: Podjanin, A.
* Starting Date: 11 January 2017
* Last updated: 14 February 2017
***********************************************************************************************



*******************************************************************
 /* 1.	Set up work directory, file name, variables and function */
*******************************************************************

clear all 

set more off

global path "J:\COMMON\STATISTICS\DPAU\MICRO"
global country "ARG"
global source "QLFS"
global time "2016Q2"
global inputFile "usu_individual_T216"

global inpath "${path}\\${country}\\${source}\\${time}\ORI"
global temppath "${path}\_Admin"
global outpath "${path}\\${country}\\${source}\\${time}"

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

	use "$inputFile", clear	
	
		rename *, lower 

		
		
		
		

		
		
		
		
		
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
* Urban survey --> nonetheless, check why population here reaches 'only' 26'848'141

	gen ilo_wgt=pondera
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



*************************************

decode ilo_time, gen(todrop)
split todrop, generate(todrop_) parse(Q)
destring todrop_1, replace force
local Y = todrop_1 in 1
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*  2016 isic 4 store under pp04b_cod instead of pp04b_caes

	
if `Y'>=2016 {
		rename  pp04b_cod pp04b_caes
} 
else {
}
	
drop todrop*
local Y		
		
		
		
		
		











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
* Comment: urban survey 

		gen ilo_geo=1
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

		gen ilo_sex=ch04
			label define label_Sex 1 "1 - Male" 2 "2 - Female"
			label values ilo_sex label_Sex 
			lab var ilo_sex "Sex"
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: value labels do not correspond to actual values (to check: type "label list ch06")
			* 98 - maximal age

	gen ilo_age=ch06
			replace ilo_age=0 if ch06==-1
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
			
		* As only age bands being kept drop "ilo_age" at the very end -> use it in between as help variable

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Level of education ('ilo_edu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: completed level of education always to be considered!
		
	gen ilo_edu_isced97=.
		replace ilo_edu_isced97=1 if ch10==3 | (ch13==2 & ch12==1)								// No schooling
		replace ilo_edu_isced97=2 if (ch13==1 & ch12==1) | (ch13==2 & ch12==2)					// Pre-primary education
		replace ilo_edu_isced97=3 if (ch13==1 & ch12==2) | (ch13==2 & ch12==3)					// Primary education
		replace ilo_edu_isced97=4 if (ch13==1 & ch12==3) | (ch13==2 & inlist(ch12,4,5))			// Lower secondary education
		replace ilo_edu_isced97=5 if (ch13==1 & inlist(ch12,4,5))| (ch13==2 & inlist(ch12,6,7))	// Upper secondary education
		/* replace ilo_edu_isced97=6 if */														// Post-secondary non-tertiary education
		replace ilo_edu_isced97=7 if (ch13==1 & inlist(ch12,6,7)) | (ch13==2 & ch12==8)			// First stage of tertiary education 
		replace ilo_edu_isced97=8 if (ch13==1 & ch12==8)										// Second stage of tertiary education
		replace ilo_edu_isced97=9 if ilo_edu_isced97==.											// Unknown level
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
* Comment: --> according to questionnaire, questions regarding education should be asked 
				* to individuals 15+ only

		gen ilo_edu_attendance=.
			replace ilo_edu_attendance=1 if ch10==1
			replace ilo_edu_attendance=2 if inlist(ch10,2,3)
			replace ilo_edu_attendance=3 if ilo_edu_attendance==.
				lab def edu_attendance_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
				lab val ilo_edu_attendance edu_attendance_lab
				lab var ilo_edu_attendance "Education (Attendance)"		
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Disability status ('ilo_dsb_details') [no info]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment: 
				
	* gen ilo_dsb_aggregate=.

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
		replace ilo_wap=0 if ilo_age<15
			label def ilo_wap_lab 1 "Working age population"
			label val ilo_wap ilo_wap_lab
			label var ilo_wap "Working age population" //15+ population

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Labour Force Status ('ilo_lfs') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
     	 
* Comment: variables corresponding to the set of questions required to identify the status in employment are not being
			* available in the dataset --> therefore the variable defined by the NSO has to be used
 
	gen ilo_lfs=.
		replace ilo_lfs=1 if estado==1
		replace ilo_lfs=2 if estado==2
		replace ilo_lfs=3 if !inlist(ilo_lfs,1,2)
		replace ilo_lfs=. if ilo_wap!=1	
				label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status" 	
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: No direct question asked about having a secondary job
			* however, there is a question asking about the number of hours dedicated to a secondary job --> use this variable
			* to capture the info

	gen ilo_mjh=.
		replace ilo_mjh=1 if pp03c==1
		replace ilo_mjh=2 if pp03c==2
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

* Comment: note that the variable is based on the variable created by the NSO --> original questions (i.e. variables) not
			* available in the dataset

	* Primary activity
	
		gen ilo_job1_ste_icse93=.
			replace ilo_job1_ste_icse93=1 if cat_ocup==3
			replace ilo_job1_ste_icse93=2 if cat_ocup==1
			replace ilo_job1_ste_icse93=3 if cat_ocup==2
			/*replace ilo_job1_ste_icse93=4 if  */
			replace ilo_job1_ste_icse93=5 if cat_ocup==4
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
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: National classification being used --> align it to ISIC Rev. 4
* Comment: National classification being used --> align it to ISIC Rev. 4
	
	
	* tostring pp04b_caes, replace
	
		gen str3 indu_code_prim = string(pp04b_caes,"%03.0f")
		replace indu_code_prim="" if indu_code_prim=="."

		replace indu_code_prim=substr(indu_code_prim,1,2) if ilo_lfs==1 
	

	*gen indu_code_sec=
		
		* Import value labels

		append using `labels', gen (lab)
					
	* One digit level
		
		* Primary activity
		
		gen ilo_job1_eco_isic4=.
			replace ilo_job1_eco_isic4=1 if inrange(indu_code_prim,"00","03")
			replace ilo_job1_eco_isic4=2 if inrange(indu_code_prim,"05","09")
			replace ilo_job1_eco_isic4=3 if inrange(indu_code_prim,"10","33")
			replace ilo_job1_eco_isic4=4 if indu_code_prim=="35"
			replace ilo_job1_eco_isic4=5 if inrange(indu_code_prim,"36","39")
			replace ilo_job1_eco_isic4=6 if indu_code_prim=="40"
			replace ilo_job1_eco_isic4=7 if inrange(indu_code_prim,"45","48")
			replace ilo_job1_eco_isic4=8 if inrange(indu_code_prim,"49","53")
			replace ilo_job1_eco_isic4=9 if inrange(indu_code_prim,"55","56")
			replace ilo_job1_eco_isic4=10 if inrange(indu_code_prim,"58","63")
			replace ilo_job1_eco_isic4=11 if inrange(indu_code_prim,"64","66")
			replace ilo_job1_eco_isic4=12 if indu_code_prim=="68"
			replace ilo_job1_eco_isic4=13 if inrange(indu_code_prim,"69","75")
			replace ilo_job1_eco_isic4=14 if inrange(indu_code_prim,"77","82")
			replace ilo_job1_eco_isic4=15 if inrange(indu_code_prim,"83","84")
			replace ilo_job1_eco_isic4=16 if indu_code_prim=="85"
			replace ilo_job1_eco_isic4=17 if inrange(indu_code_prim,"86","88")
			replace ilo_job1_eco_isic4=18 if inrange(indu_code_prim,"90","93")
			replace ilo_job1_eco_isic4=19 if inrange(indu_code_prim,"94","96")
			replace ilo_job1_eco_isic4=20 if inrange(indu_code_prim,"97","98")
			replace ilo_job1_eco_isic4=21 if indu_code_prim=="99"
			replace ilo_job1_eco_isic4=22 if indu_code_prim=="" & ilo_lfs==1 
			replace ilo_job1_eco_isic4=22 if ilo_job1_eco_isic4==. & ilo_lfs==1
				lab val ilo_job1_eco_isic4 isic4
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
		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_ocu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: does not follow isco-08 --> find a mapping 
		* Note that at the two digit level some categories are being considered for which we don't have a label as they don't 
			* fit the standard version of ISCO 08 --> therefore while tabulating the variable at the two digit level, some
			* values won't have a value label
			
	gen occ_code_prim=pp04d_cod if ilo_lfs==1
		destring occ_code_prim, replace
		
	
	* 2 digit level
	
		* Primary occupation
		
	gen ilo_job1_ocu_isco08_2digits=.
		replace ilo_job1_ocu_isco08_2digits=11 if inlist(occ_code_prim,1,1001,4001)
		replace ilo_job1_ocu_isco08_2digits=12 if occ_code_prim==56111
		replace ilo_job1_ocu_isco08_2digits=13 if inlist(occ_code_prim,3001,5001,6001,7001,57111,65111)
		replace ilo_job1_ocu_isco08_2digits=14 if inlist(occ_code_prim,5002,51111,51201,52111,53111,58111)
		replace ilo_job1_ocu_isco08_2digits=21 if inlist(occ_code_prim,34111,34121,34131,34201,34311,34321,34331,35111,35131,35201,35311,36111,36311,60111,60131,60201,60311, ///
				60331,61311,62111,62201,62311,63111,63311,64111,64311,70111,70131,70201,70311,70331,71111,71201,71311,72111,72131,72201,72311,72331,80111,80201,80311,82111, /// 
				90111,90121,90201,90311,90331,91111,91131,91201,91311,91331,92111,92131,92201,92311,92331) | (inlist(occ_code_prim,42111,42131,42201,42311,43111,43201,43311) & ///
								(indu_code_prim=="71" | indu_code_prim=="72") )
		replace ilo_job1_ocu_isco08_2digits=22 if inlist(occ_code_prim,30111,30201,30311,40111,40131,40201,40311,40331,44111,44131,44201,44311,61111,61131,61201) | ///
				(inlist(occ_code_prim,42111,42131,42201,42311,43111,43201,43311) & indu_code_prim=="86")
		replace ilo_job1_ocu_isco08_2digits=23 if inlist(occ_code_prim,41111,41112,41131,41201,41202,41311,41312,41332)
		replace ilo_job1_ocu_isco08_2digits=24 if inlist(occ_code_prim,10111,10201,10311,10331,20111,20201,20311,20331,31111,31131,31311,32111,32201,32311,32331,54111,54311) | ///
								(inlist(occ_code_prim,42111,42131,42201,42311,43111,43201,43311) & 	(indu_code_prim=="78" | indu_code_prim=="70") )
		replace ilo_job1_ocu_isco08_2digits=25 if inlist(occ_code_prim,47111,47131,47201,47331,81131,81201,81331)
		replace ilo_job1_ocu_isco08_2digits=26 if inlist(occ_code_prim,2001,11111,11201,11311,45111,45112,45121,45201,45202,45311,45312,46111,46112,46201,46311,50111,50131,50201,50311,50331)
		replace ilo_job1_ocu_isco08_2digits=31 if inlist(occ_code_prim,34112,34122,34202,34312,34322,34332,36112,36202,36312,36332,44122,44132,44322,44323,44332,44333,61112,61312,62112,62312,63112, ///
				63312,64112,64202,64312,65112,70112,70122,70132,70202,70203,70312,70322,70332,71112,71113,71122,71123,71133,71202,71203,71312,71313,71322,71323,71332,71333, ///
				72112,72202,72203,72312,72332,80132,80202,80203,80312,80322,80332,82132,82202,82332,90112,90122,90202,90312,90332,91112,91123,91202,91312,91313,92202)  | (inlist(occ_code_prim,42112,42123,42132,42133,42202,42312,42323,42332,42333,43112,43132,43312) & ///
								(indu_code_prim=="71" | indu_code_prim=="72") )
		replace ilo_job1_ocu_isco08_2digits=32 if inlist(occ_code_prim,40112,40122,40132,40202,40312,40322,40332,44112) | (inlist(occ_code_prim,42112,42123,42132,42133,42202,42312,42323,42332,42333,43112,43132,43312) & ///
								indu_code_prim=="86" )
		replace ilo_job1_ocu_isco08_2digits=33 if inlist(occ_code_prim,10112,10122,10132,10202,10312,10332,11332,20112,20122,20132,20202,20312,20332,30112,30202,30312,30332,31112, ///
				31202,31312,32112,32202,32312,32332,47112,47202,47312,48332) | (inlist(occ_code_prim,42112,42123,42132,42133,42202,42312,42323,42332,42333,43112,43132,43312) & ///
								indu_code_prim=="84" )
		replace ilo_job1_ocu_isco08_2digits=34 if inlist(occ_code_prim,11112,11202,11312,46132,46202,46203,46312,46313,50112,50113,50122,50202,50312,50313,50322,51112,51202,51312,51322,51332, ///
				52112,52122,52123,52133,52202,52312,52322,52323,52333,53112,53132,53202,53312,58112,58122,58202,58312) | (inlist(occ_code_prim,42112,42123,42132,42133,42202,42312,42323,42332,42333,43112,43132,43312) & ///
								indu_code_prim=="74" )
		replace ilo_job1_ocu_isco08_2digits=35 if inlist(occ_code_prim,35112,35122,35132,35202,35312,35322,35332,45113,45122,45123,45132,45133,45313,45322,45323,45332,45333,47322,47332,48322, ///
				48331,50132,50332,58332,81132,81202,81332,92112,92132,92312,92332)
		replace ilo_job1_ocu_isco08_2digits=41 if inlist(occ_code_prim,10113,10123,10133,10203,10313,10333,11113,11123,11203,11313,11314,11333,81133,81203,81333)
		replace ilo_job1_ocu_isco08_2digits=42 if inlist(occ_code_prim,20113,20203,35323,42113,42313,52203,52313,54113,54202,54313,54323)
		replace ilo_job1_ocu_isco08_2digits=43 if inlist(occ_code_prim,20133,20333,34113,34203,34313,36113,36203,36313,36333)
		replace ilo_job1_ocu_isco08_2digits=44 if inlist(occ_code_prim,35113,35123,35133,35203,35313,35314,35333,43313)
		replace ilo_job1_ocu_isco08_2digits=51 if inlist(occ_code_prim,46113,51113,51203,51313,53113,53203,53313,53323,54112,54122,54312,55113,55203,56202,56203,56313,57112,57113,57123, ///
				57202,57203,57312,57313,57323,57333,58203)
		replace ilo_job1_ocu_isco08_2digits=52 if inlist(occ_code_prim,20313,30113,30133,30203,30313,30314,30323,30333,31113,31203,31313,31314,32113,32123,32203,32313,32314,32323,33203,33314)
		replace ilo_job1_ocu_isco08_2digits=53 if inlist(occ_code_prim,40113,40203,40313,40314,40323,41113,41203,41313,41323,41333,52113,57314)
		replace ilo_job1_ocu_isco08_2digits=54 if inlist(occ_code_prim,44202,44203,44312,44313,47113,47203,47313,47314,47323,47333,48311,48312,48313,48323,48333)
		replace ilo_job1_ocu_isco08_2digits=61 if inlist(occ_code_prim,60112,60113,60202,60203,60312,60313,61113,61123,61133,61202,61203,61313,61323,62202,63113,63123,63202,63203,63313,63323,63333)
		replace ilo_job1_ocu_isco08_2digits=62 if inlist(occ_code_prim,62113,62203,62313,64113,64203,64313,64323,65113,65313)
		replace ilo_job1_ocu_isco08_2digits=71 if inlist(occ_code_prim,70113,72113,72313)
		replace ilo_job1_ocu_isco08_2digits=72 if inlist(occ_code_prim,82113,82133,82203,82313,82333,90113,90123,90203,90313,90323,92113,92203,92313,92323) | (inlist(occ_code_prim,80113,80313) & inlist(indu_code_prim,"25","28"))
		replace ilo_job1_ocu_isco08_2digits=73 if occ_code_prim==80112 | (inlist(occ_code_prim,80113,80313) & inlist(indu_code_prim,"18","23"))
		replace ilo_job1_ocu_isco08_2digits=74 if inlist(occ_code_prim,82112,82312)
		replace ilo_job1_ocu_isco08_2digits=75 if inlist(occ_code_prim,44113,82123,8323) | (inlist(occ_code_prim,80113,80313) & inlist(indu_code_prim,"10","12","13","14","15","16","26","31"))
		replace ilo_job1_ocu_isco08_2digits=79 if inlist(occ_code_prim,80113,80313) & inlist(indu_code_prim,"17","19","20","22","24","27","29","30","38")
		replace ilo_job1_ocu_isco08_2digits=81 if inlist(occ_code_prim,56123,56323,56324,70123,70313,70323,70333) | (inlist(occ_code_prim,80123,80133,80323,80333) & ///
				(inlist(indu_code_prim,"10","12","13","14","15","16","17") | inlist(indu_code_prim,"18","19","20","22","23","24","25","31")) )
		replace ilo_job1_ocu_isco08_2digits=82 if inlist(occ_code_prim,80123,80133,80323,80333) & inlist(indu_code_prim,"26","27","28")
		replace ilo_job1_ocu_isco08_2digits=83 if inlist(occ_code_prim,34123,34323,36123,36323,58123,58333,60122,60123,60132,60322,60323,62123,62322,62323,62332,72122,72123,72132,72322,72323,72333)
		replace ilo_job1_ocu_isco08_2digits=89 if inlist(occ_code_prim,80123,80133,80323,80333) & inlist(indu_code_prim,"29","30","38")
		replace ilo_job1_ocu_isco08_2digits=91 if inlist(occ_code_prim,55313,55314,56113,56114,56314)
		replace ilo_job1_ocu_isco08_2digits=92 if inlist(occ_code_prim,58113,58313,58323,60114,60314,60324,61314,62314,62324,63314,64314,65314)
		replace ilo_job1_ocu_isco08_2digits=93 if inlist(occ_code_prim,34314,36114,36314,36324,70314,71314,71324,72114,72314,72324,80314,80324,82314,82324,90314,90324,92314,92324)
		replace ilo_job1_ocu_isco08_2digits=94 if occ_code_prim==53314
		replace ilo_job1_ocu_isco08_2digits=95 if occ_code_prim==33114
		replace ilo_job1_ocu_isco08_2digits=96 if inlist(occ_code_prim,10314,20314,34324,44314,46314,51314,52314,54314,58314)
			lab values ilo_job1_ocu_isco08_2digits isco08_2digits
			lab var ilo_job1_ocu_isco08_2digits "Occupation (ISCO-08), 2 digit level" 
			
	* 1 digit level
	
	gen occ_code_prim_1dig=int(ilo_job1_ocu_isco08_2digits/10) if ilo_lfs==1 
	
		* Primary activity
		
		gen ilo_job1_ocu_isco08=occ_code_prim_1dig
			replace ilo_job1_ocu_isco08=10 if ilo_job1_ocu_isco08==0
			replace ilo_job1_ocu_isco08=11 if ilo_job1_ocu_isco08==. & ilo_lfs==1
			lab def isco08_1dig_lab 1 "1 - Managers" 2 "2 - Professionals" 3 "Technicians and associate professionals" 4 "4 - Clerical support workers" 5 "5 - Service and sales workers" ///
									6 "6 - Skilled agricultural, forestry and fishery workers" 7 "7 - Craft and related trades workers" 8 "8 - Plant and machine operators, and assemblers" ///
									9 "9 - Elementary occupations" 10 "0 - Armed forces occupations" 11 "X - Not elsewhere classified"
			lab val ilo_job1_ocu_isco08 isco08_1dig_lab
			lab var ilo_job1_ocu_isco08 "Occupation (ISCO-08)"	
	
	* Aggregate level
	
		* Primary occupation
	
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
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_ins_sector') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
		
* Comment: 

	* Primary occupation
	
	gen ilo_job1_ins_sector=.
		replace ilo_job1_ins_sector=1 if pp04a==1
		replace ilo_job1_ins_sector=2 if pp04a!=1
				replace ilo_job1_ins_sector=. if ilo_lfs!=1
			lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
			lab values ilo_job1_ins_sector ins_sector_lab
			lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities" 

* --------------------------------------------------------------------------------------------------
* --------------------------------------------------------------------------------------------------
*		Weekly hours actually (USUALLY) worked ('ilo_how_actual') and ('ilo_how_usual') [CHECK again]
* --------------------------------------------------------------------------------------------------
* --------------------------------------------------------------------------------------------------

* Comment: question 3b not available, which asks how many hours do individuals being temporarily absent from work dedicate to their 
			* principal activity 
			* questions 3e and 3f only asked to individuals that were at work during
					* the reference week --> check whether variable can be kept by using a note, given that not entire scope being covered

	* Actual hours worked 
		
		* Primary job
		
		gen ilo_job1_how_actual=pp3e_tot if pp3e_tot!=999
			replace ilo_job1_how_actual=. if ilo_lfs!=1
			lab var ilo_job1_how_actual "Weekly hours actually worked in main job"
			
		* Secondary job 
		
		gen ilo_job2_how_actual=pp3f_tot if pp3f_tot!=999
			replace ilo_job2_how_actual=. if ilo_lfs!=1
			lab var ilo_job2_how_actual "Weekly hours actually worked in secondary job"			
			
		* All jobs
		
		egen ilo_joball_how_actual=rowtotal(ilo_job1_how_actual ilo_job2_how_actual), m
			replace ilo_joball_how_actual=168 if ilo_joball_how_actual>168
			replace ilo_joball_how_actual=. if ilo_lfs!=1
			lab var ilo_joball_how_actual "Weekly hours actually worked in all jobs"		
	
	* Hours usually worked
	
		* Primary job
		
	
				
		* All jobs
		
		
		
	* Weekly hours actually worked --> bands --> Use actual hours worked in all jobs 
			
		* Main job
		
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
				lab values ilo_job1_how_actual_bands how_bands_lab
				lab var ilo_job1_how_actual_bands "Weekly hours actually worked bands in main job"
		
		* All jobs
		
		gen ilo_joball_how_actual_bands=.
			replace ilo_joball_how_actual_bands=1 if ilo_joball_how_actual==0
			replace ilo_joball_how_actual_bands=2 if ilo_joball_how_actual>=1 & ilo_joball_how_actual<=14
			replace ilo_joball_how_actual_bands=3 if ilo_joball_how_actual>=15 & ilo_joball_how_actual<=29
			replace ilo_joball_how_actual_bands=4 if ilo_joball_how_actual>=30 & ilo_joball_how_actual<=34
			replace ilo_joball_how_actual_bands=5 if ilo_joball_how_actual>=35 & ilo_joball_how_actual<=39
			replace ilo_joball_how_actual_bands=6 if ilo_joball_how_actual>=40 & ilo_joball_how_actual<=48
			replace ilo_joball_how_actual_bands=7 if ilo_joball_how_actual>=49 & ilo_joball_how_actual!=.
			replace ilo_joball_how_actual_bands=8 if ilo_lfs==1 & ilo_joball_how_actual_bands==.
				* value label already defined
				lab values ilo_joball_how_actual_bands how_bands_lab
				lab var ilo_joball_how_actual_bands "Weekly hours actually worked bands in all jobs"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment: legal maximum: 48 h per week, 8 h per day
			* reference used in technical document (Conceptos): 35 h per week
			* as no usual hours worked available, actual hours worked are being used instead
	
	gen ilo_job1_job_time=.
		replace ilo_job1_job_time=1 if ilo_job1_how_actual<=34 & ilo_job1_how_actual!=.
		replace ilo_job1_job_time=2 if ilo_job1_how_actual>=35 & ilo_job1_how_actual!=.
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
	
* Comment: asks whether this employment is ending at a precise moment or not
			* note that household service is not included

	gen ilo_job1_job_contract=.
		replace ilo_job1_job_contract=1 if pp07c==2
		replace ilo_job1_job_contract=2 if pp07c==1
		replace ilo_job1_job_contract=3 if ilo_lfs==1 & ilo_job1_job_contract==.
				replace ilo_job1_job_contract=. if ilo_lfs!=1
			lab def job_contract_lab 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"
			lab val ilo_job1_job_contract job_contract_lab
			lab var ilo_job1_job_contract "Job (Type of contract)"


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Informal/Formal economy: Unit of production (ilo_job1_ife_prod) [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: 
	
	* Useful questions: pp04a: Institutional sector 
					*	pp04b1: Household
					*	[no question]: Destination of production 
					*	[no question]: Bookkeeping
					*	pp06e: Registration (only asked to self-employed)
					*	pp04g: Location of workplace
					* 	pp04c: Size of the establishment
					*	pp07g4: Social security (Obra social)
					*	pp07g1: Paid annual leave - Not needed
					*	pp07g3: Paid sick leave - Not needed
					
					
	gen ilo_job1_ife_prod=.
		replace ilo_job1_ife_prod=1 if pp04a!=1 & pp06e!=1 & ((ilo_job1_ste_aggregate==1 & pp07g4!=1 & ((inlist(pp04g,1,2,4,6,7,8,10) & inlist(pp04c,0,1,2,3,4,5,99,.)) | !inlist(pp04g,1,2,4,6,7,8,10))) | ///
														(ilo_job1_ste_aggregate!=1 & (!inlist(pp04g,1,2,4,6,7,8,10) | inlist(pp04g,1,2,4,6,7,8,10) & inlist(pp04c,0,1,2,3,4,5,99,.))))
		replace ilo_job1_ife_prod=2 if pp04a==1 | (pp04a!=1 & pp06e==1) | (pp04a!=1 & pp06e!=1 & ilo_job1_ste_aggregate==1 & (pp07g4==1 | (pp07g4!=1 & inlist(pp04g,1,2,4,6,7,8,10) & !inlist(pp04c,0,1,2,3,4,5,99,.)))) |  ///
															(pp04a!=1 & pp06e!=1 & ilo_job1_ste_aggregate!=1 & inlist(pp04g,1,2,4,6,7,8,10) & !inlist(pp04c,0,1,2,3,4,5,99,.))
		replace ilo_job1_ife_prod=3 if pp04b1==1 | ilo_job1_ocu_isco08_2digits==63 
		replace ilo_job1_ife_prod=4 if ilo_job1_ife_prod==. & ilo_lfs==1
		replace ilo_job1_ife_prod=1 if ilo_job1_ife_prod==4
		replace ilo_job1_ife_prod=. if ilo_lfs!=1
			lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 4 "4 - Not elsewhere classified"
			lab val ilo_job1_ife_prod ilo_ife_prod_lab
			lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"		
		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Informal/formal economy: nature of job (ilo_job1_ife_nature) [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	
	gen ilo_job1_ife_nature=.
		replace ilo_job1_ife_nature=1 if ilo_job1_ste_icse93==5 | (inlist(ilo_job1_ste_icse93,1,6) & pp07g4!=1) |(inlist(ilo_job1_ste_icse93,2,3,4) & inlist(ilo_job1_ife_prod,1,3))
		replace ilo_job1_ife_nature=2 if (inlist(ilo_job1_ste_icse93,1,6) & pp07g4==1) | (inlist(ilo_job1_ste_icse93,2,3,4) & ilo_job1_ife_prod==2)
		replace ilo_job1_ife_nature=. if ilo_lfs!=1
			lab def ife_nature_lab 1 "1 - Persons with informal main job" 2 "2 - Persons with formal main job"
			lab val ilo_job1_ife_nature ife_nature_lab
			lab var ilo_job1_ife_nature "Informal / Formal Economy (Nature of job)"		
			
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Earnings ('ilo_ear_ees' and 'ilo_ear_slf') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	
* Comment: calculation includes also "retroactivos (sueldos adeudados)"

	*Currency in Argentina: Argentine peso
	
	* Primary employment 
	
			* Monthly earnings of employees
			
		foreach v of varlist pp08d1 pp08d4 pp08f1 pp08f2 pp08j1 pp08j2 pp08j3 {
		
			gen earn_`v'=`v' if `v'!=-9
			
			}
	
		egen ilo_job1_lri_ees=rowtotal(earn_*), m
			replace ilo_job1_lri_ees=. if ilo_lfs!=1 | ilo_job1_lri_ees<0 | ilo_job1_ste_aggregate!=1
			lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"
	
			* Self employment
			
		foreach v of varlist pp06c pp06d {
		
			gen self_earn_`v'=`v' if `v'>=0
			
			}
	
		* Note that the revenue related to self-employment includes also the value of own consumption (cf. resolution from 1998)
			
		egen ilo_job1_lri_slf=rowtotal(self_earn_*), m 
			replace ilo_job1_lri_slf=. if ilo_lfs!=1 | ilo_job1_ste_aggregate!=2
			lab var ilo_job1_lri_slf "Monthly labour related income of self-employed in main job"
		

***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_tru') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
           
* Comment: given that usual hours can't be defined, actual hours worked are being used
			* for the availability criterion: consider also if person is available immediately or latest in two weeks 

	gen ilo_joball_tru=1 if ilo_job1_job_time==1 & pp03g==1 & inlist(pp03h,1,2)
		replace ilo_joball_tru=. if ilo_lfs!=1
		lab def tru_lab 1 "Time-related underemployment"
		lab val ilo_joball_tru tru_lab
		lab var ilo_joball_tru "Time-related underemployment"

*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Cases of non-fatal occupational injury ('ilo_joball_oi_case') [no info]
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*
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
*			Duration of unemployment ('ilo_dur') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: questions asks for how long person has been seeking a job

	gen ilo_dur_aggregate=.
		replace ilo_dur_aggregate=1 if inlist(pp10a,1,2,3)
		replace ilo_dur_aggregate=2 if pp10a==4
		replace ilo_dur_aggregate=3 if pp10a==5
		replace ilo_dur_aggregate=4 if ilo_dur_aggregate==. & ilo_lfs==2
				replace ilo_dur_aggregate=. if ilo_lfs!=2
				
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
		replace ilo_cat_une=1 if pp10d==1
		replace ilo_cat_une=2 if pp10d==2
		replace ilo_cat_une=3 if ilo_cat_une==. & ilo_lfs==2
				replace ilo_cat_une=. if ilo_lfs!=2
			lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
			lab val ilo_cat_une cat_une_lab
			lab var ilo_cat_une "Category of unemployment"
							
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4') [don't include]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: given that question refers only to jobs having ended max. 3 years ago, question not being considered


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu_isco08') [don't include]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			
* Comment: idem as preveco
	
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Unemployment benefits schemes ('ilo_soc_aggregate') [no info available]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment:


			
***********************************************************************************************
*			PART 3.4. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************
			
* variables can't be defined --> no section dedicated to people outside the labour force
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma') [can't be defined]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: Degree of labour market attachment of persons outside the labour force
		
		* Given structure of questionnaire (filter questions and no section dedicated to individuals outside the labour force) only option 2 could be defined -> too little information -> don't consider variable 

			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reasons for not seeking a job ('ilo_olf_reason')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: only option 2 can be defined, but given very low share falling into this category, variable is not being kept

	/*	gen ilo_olf_dlma=.
		/* replace ilo_olf_dlma=1 if */
		replace ilo_olf_dlma=2 if seeking==3 & available==1
		/* replace ilo_olf_dlma=3 if */
		/* replace ilo_olf_dlma=4 if */
		replace ilo_olf_dlma=5 if ilo_olf_dlma==. & ilo_lfs==3
				replace ilo_olf_dlma=. if ilo_lfs!=3
			lab def lab_olf_dlma 1 "1 - Seeking, not available (Unavailable jobseekers)" 2 "2 - Not seeking, available (Available potential jobseekers)" ///
						3 "3 - Not seeking, not available, willing (Willing non-jobseekers)" 4 "4 - Not seeking, not available, not willing" 5 "5 - Not elsewhere classified"
			lab val ilo_olf_dlma lab_olf_dlma
			lab var ilo_olf_dlma "Labour market attachment (Degree of)"	
			*/


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seekers ('ilo_dis') [done]
* -------------------------------------------------------------------------------------------
* ------------------------------------------------------------------------------------------- 

* Comment:

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training (NEETs) ('ilo_neet') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

		gen ilo_neet=.
			replace ilo_neet=1 if inrange(ilo_age,15,24) & ilo_lfs!=1 & inlist(ilo_edu_attendance,2,3)
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

		drop if lab==1 /* in order to get rid of observations from tempfile */

		drop ilo_age /* as only age bands being kept and this variable used as help variable */
		
		drop indu_code_* occ_code_* /* prev*_cod */  earn_* self_earn_* lab isco08_2digits isco88_2digits isco08 isco88 isic4_2digits isic4 isic3_2digits isic3 
	
		compress 
		
		order ilo_key ilo_wgt ilo_time ilo_geo ilo_sex	ilo_age* ilo_edu_* /*ilo_dsb* */  ilo_wap ilo_lfs ilo_mjh  ilo_job*_ste* ilo_job*_eco* ilo_job*_ocu*  ilo_job*_ins_sector ///
		ilo_job*_job_time  ilo_job*_job_contract   ilo_job*_ife* ilo_job*_how* ilo_job*_lri_*  ilo_joball_tru  /* ilo_joball_oi* */  ilo_cat_une ilo_dur_* /*ilo_prev* */  ///
		/* ilo_gsp_uneschemes */  /* ilo_olf_* */ /*ilo_dis */ ilo_neet, last
		   
		   
	* Save dataset including original and ilo variables
	
		save ${country}_${source}_${time}_FULL,  replace		
	
	*Save file only containing ilo_* variables
	
		keep ilo*

		save ${country}_${source}_${time}_ILO, replace

