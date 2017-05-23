* TITLE OF DO FILE: ILO Microdata Preprocessing code template - India, 2011_2012
* DATASET USED: India NSS 2011 2012
* NOTES:
* Authors: Devora Levakova
* Who last updated the file: Yves Perardel
* Starting Date: 27 July 2016
* Last updated: 6 December 2016
***********************************************************************************************


***********************************************************************************************
***********************************************************************************************

* 			1. SET UP WORK DIRECTORY, FILE NAME, VARIABLES AND FUNCTIONS

***********************************************************************************************
***********************************************************************************************

clear all 
set more off


global source "NSS"
global time "2012"

global inpath "J:\COMMON\STATISTICS\DPAU\MICRO\IND\NSS\2012\ORI"
global temppath "J:\COMMON\STATISTICS\DPAU\MICRO\_Admin"
global outpath "J:\COMMON\STATISTICS\DPAU\MICRO\IND\NSS\2012"

************************************************************************************

* Important : if package « labutil » not already installed, install it in order to execute correctly the do-file

	* ssc install labutil

************************************************************************************
***********************************************************************************
* Make a tempfile containing the labels for the classifications ISIC and ISCO 
		
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

	use "IND_NSS_2012", clear
		

* Comment: 	Not possible to merge all blocks into one dataset given the difference in the concept behind the different activity statuses. Block 5_3 contains information on current daily status 
*			and current weekly status, based on the the current daily status it differentiates by number of activity (1st, 2nd 3rd, etc.) which creates a duplication of the individuals, 
*			therefore it is not possible to merge with the remaining blocks, as there can't be a unique identifier.
* 			Block 4 - 456 999 sample size; Block 5_1 - 456 999; Block 5_2 - 38 098; Block 5_3 - 495 016; Block 6 - 172 281

* Working only on usual activity status


		
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

	gen ilo_key=string(FSU_Serial_No)+string(Hamlet_Group_Sub_Block_No)+string(Second_Stage_Stratum_No)+string(Sample_Hhld_No)+string(Person_Serial_No)
		lab var ilo_key "Key unique identifier per individual"		


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sample Weight ('ilo_wgt')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: 	For generating subsample-wise estimates based on data of all subrounds taken together, either Subsample-1 households or Subsample-2 households are to be considered at one time. 
* 			Apply final weight (or all-subround multipliers) as follows :
* 			Final weight = MLT/100, if NSS=NSC, final weight=MLT/200 otherwise.
*			There is a seperate document that explains the weighting. 

	gen final_weight=mlt/100 if nss==nsc
	replace final_weight=mlt/200 if nss!=nsc  
	gen ilo_wgt=final_weight
		lab var ilo_wgt "Sample weight"		

	svyset [pweight=ilo_wgt] // Setting the sample weight to extrapolate tabulations of the data to the whole poplation

		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time period ('ilo_time')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: 	This dataset corresponds to 2011-2012; sub-round 1: July - September 2011; sub-round 2: October - December 2011; sub-round 3: January - March 2012; sub-round 4: April - June 2012
* Only yearly indicators are produced so this is all going to 2012 for ILOSTAT

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

	recode Sector (1=2 "Rural")(2=1 "Urban"), gen (ilo_geo)
			lab var ilo_geo "Geographical coverage"	

			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

		gen ilo_sex=Sex
			label define ilo_sex 1 "Male" 2 "Female"
			label value ilo_sex ilo_sex
			label var ilo_sex "Sex"


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

	gen ilo_age=Age
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

* Comment:	General_Education ("education level'") difficult to map to ISCED, request mapping file !	
* 		  	NOT POSSIBLE - mapping to ISCED 11 not possible, mapping to aggregate - unceratain, rather not possible
* 		   	1 - not literate, and 2,3,4 - literate without formal schooling, can these categories be mapped to "Less than basic" or is that "Level not stated"?; 
*			7- middle, is that "Basic" or "Intermediate"?; 
*			not sure if 11- diploma/certificate course is "Intermidiate", it could be Advanced, as in variable Status_of_Current_Attendance both are mentioned, below graduate level and graduate level
*		   	General_Education - 637 missing values, redorded as "."

* 	recode General_education (1/5=1 "Less than basic")(6 7=2 "Basic")(8 10 11=3 "Intermediate")(12 13=4 "Advanced"), gen (ilo_edu_aggregate)


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education attendance ('ilo_edu_attendance')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	recode Status_of_Current_Attendance (1/15=2 "Not attending") (21/43=1 "Attending"), gen (ilo_edu_attendance)
			label var ilo_edu_attendance "Education (Attendance)"

		
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

* Comment: 	Recoding the exisiting categorical variable for usual principal status (Usual_Principal_Activity_Status)
*			The activity status on which a person spent relatively long time (i.e. major time criterion) during the 365 days preceding the date of survey was considered as the usual principal activity status 
*			
*			Creating a TEMPORARY VARIABLE Usual principal status - temp_lfs_ups; 
*
*			Unemployed - pre-categorized: 81 - did not work but was seeking and/or available for work; 
*			Not working but seeking/available for work (or unemployed):
*			81 sought work or did not seek but was available for work (for usual status approach)
*			81 sought work (for current weekly status approach)
*			82 did not seek but was available for work (for current weekly status approach)
*			
*			Usual_Principal_Activity_Status - no missing values
*			ilo_lfs - no missing values for ilo_wap=1

		destring Usual_Principal_Activity_Status, replace
		recode Usual_Principal_Activity_Status (11 12 21 31 41 51=1 "Employed")(81=2 "Unemployed")(91/95 97=3 "Outside the labour force"), gen (temp_lfs_ups) 

		gen ilo_lfs=.
		replace ilo_lfs=1 if (temp_lfs_ups==1 & ilo_wap==1)
		replace ilo_lfs=2 if (temp_lfs_ups==2 & ilo_wap==1)
		replace ilo_lfs=3 if (temp_lfs_ups==3 & ilo_wap==1)
				label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside the Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status"


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: 	Whether_in_Subsidiary_Activity - 1-yes; 2-no

	gen ilo_mjh=.
		replace ilo_mjh=1 if (Whether_in_Subsidiary_Activity==2 & ilo_lfs==1)
		replace ilo_mjh=2 if (Whether_in_Subsidiary_Activity==1 & ilo_lfs==1)
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

* Comment: 	Recoding the Usual_Principal_Activity_Status. 	
* Non-Standard codes are the following ones: 
* 41: Worked as casual wage labour: in public works / 51: In other types of work -> Classified as own-account workers as they are casual.
* 81: Did not work but was seeking and/or available for work / 91: Attended educational institution / 92: Attended domestic duties only
* 93: Attended domestic duties and was also engaged in free collection of goods (vegetables, roots, firewood, cattle feed, etc.), sewing, tailoring, weaving, etc. for household use
* 94: Rentiers, pensioners , remittance recipients... / 95: Not able to work due to disability / 97: Others (including begging, prostitution...) 

  * MAIN JOB:
	
	* Detailed categories

	gen ilo_job1_ste_icse93=.
		replace ilo_job1_ste_icse93=1 if (Usual_Principal_Activity_Status==31 & ilo_lfs==1)
		replace ilo_job1_ste_icse93=2 if (Usual_Principal_Activity_Status==12 & ilo_lfs==1)
		replace ilo_job1_ste_icse93=3 if (Usual_Principal_Activity_Status==11 & ilo_lfs==1)
		replace ilo_job1_ste_icse93=3 if (inlist(Usual_Principal_Activity_Status,41,51) & ilo_lfs==1)
		replace ilo_job1_ste_icse93=5 if (Usual_Principal_Activity_Status==21 & ilo_lfs==1)
		replace ilo_job1_ste_icse93=6 if (inlist(Usual_Principal_Activity_Status,81,91,92,93,94,95,97) & ilo_lfs==1)	
			label define ilo_job1_ste_icse93 1 "Employees" 2 "Employers" 3 "Own-account workers" 5 "Contributing family workers" 6 "6 - Workers not classifiable by status"
			label value ilo_job1_ste_icse93 ilo_job1_ste_icse93
			label var ilo_job1_ste_icse93 "Status in employment (ICSE 93)"

	* Aggregated categories 
		
		gen ilo_job1_ste_aggregate=.
			replace ilo_job1_ste_aggregate=1 if (ilo_job1_ste_icse93==1)			// Employees
			replace ilo_job1_ste_aggregate=2 if (inrange(ilo_job1_ste_icse93,2,5))	// Self-employed
			replace ilo_job1_ste_aggregate=3 if (ilo_job1_ste_icse93==6)			// Not elsewhere classified
				lab def ste_aggr_lab 1 "1 - Employees" 2 "2 - Self-employed" 3 "3 - Not elsewhere classified"
				lab val ilo_job1_ste_aggregate ste_aggr_lab
				label var ilo_job1_ste_aggregate "Status in employment (Aggregate)"  


				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

/* Classification used: ISIC Rev. 4 */

	append using `labels', gen (lab)
		* Use value label from this variable, afterwards drop everything related to this append

			
	* Two digits level
		
		gen ilo_job1_eco_isic4_2digits=substr(Usual_PrincipalActivity_NIC2008,1,2) if (ilo_lfs==1)
			destring ilo_job1_eco_isic4_2digits, replace
			lab values ilo_job1_eco_isic4 isic4_2digits
			lab var ilo_job1_eco_isic4_2digits "Economic activity (ISIC Rev. 4), 2 digit level"

			
	* One digit level

		gen ilo_job1_eco_isic4=.
			replace ilo_job1_eco_isic4=1 if inrange(ilo_job1_eco_isic4_2digits,1,3)
			replace ilo_job1_eco_isic4=2 if inrange(ilo_job1_eco_isic4_2digits,5,9)
			replace ilo_job1_eco_isic4=3 if inrange(ilo_job1_eco_isic4_2digits,10,33)
			replace ilo_job1_eco_isic4=4 if ilo_job1_eco_isic4_2digits==35
			replace ilo_job1_eco_isic4=5 if inrange(ilo_job1_eco_isic4_2digits,36,39)
			replace ilo_job1_eco_isic4=6 if inrange(ilo_job1_eco_isic4_2digits,41,43)
			replace ilo_job1_eco_isic4=7 if inrange(ilo_job1_eco_isic4_2digits,45,47)
			replace ilo_job1_eco_isic4=8 if inrange(ilo_job1_eco_isic4_2digits,49,53)
			replace ilo_job1_eco_isic4=9 if inrange(ilo_job1_eco_isic4_2digits,55,56)
			replace ilo_job1_eco_isic4=10 if inrange(ilo_job1_eco_isic4_2digits,58,63)
			replace ilo_job1_eco_isic4=11 if inrange(ilo_job1_eco_isic4_2digits,64,66)
			replace ilo_job1_eco_isic4=12 if ilo_job1_eco_isic4_2digits==68
			replace ilo_job1_eco_isic4=13 if inrange(ilo_job1_eco_isic4_2digits,69,75)
			replace ilo_job1_eco_isic4=14 if inrange(ilo_job1_eco_isic4_2digits,77,82)
			replace ilo_job1_eco_isic4=15 if ilo_job1_eco_isic4_2digits==84
			replace ilo_job1_eco_isic4=16 if ilo_job1_eco_isic4_2digits==85
			replace ilo_job1_eco_isic4=17 if inrange(ilo_job1_eco_isic4_2digits,86,88)
			replace ilo_job1_eco_isic4=18 if inrange(ilo_job1_eco_isic4_2digits,90,93)
			replace ilo_job1_eco_isic4=19 if inrange(ilo_job1_eco_isic4_2digits,94,96)
			replace ilo_job1_eco_isic4=20 if inrange(ilo_job1_eco_isic4_2digits,97,98)
			replace ilo_job1_eco_isic4=21 if ilo_job1_eco_isic4_2digits==99
			replace ilo_job1_eco_isic4=22 if ilo_job1_eco_isic4_2digits==. & ilo_lfs==1 
				lab val ilo_job1_eco_isic4 isic4
				lab var ilo_job1_eco_isic4 "Economic activity (ISIC Rev. 4)"


	* Classification aggregated level

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
*			Occupation ('ilo_job1_ocu_isco08')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: NCO-04 is developed in line with ISCO-88


		* ISCO 88 - 2 digits

		bys ilo_key: replace Usual_PrincipalActivity_NCO2004="1010" if  Usual_PrincipalActivity_NCO2004=="X10"
		bys ilo_key: replace Usual_PrincipalActivity_NCO2004="1099" if  Usual_PrincipalActivity_NCO2004=="X99"

		destring Usual_PrincipalActivity_NCO2004, replace
		
		gen ilo_job1_ocu_isco88_2digits=.
			replace ilo_job1_ocu_isco88_2digits=11 if (inrange(Usual_PrincipalActivity_NCO2004,111,114) & ilo_lfs==1)
			replace ilo_job1_ocu_isco88_2digits=12 if (inrange(Usual_PrincipalActivity_NCO2004,121,123) & ilo_lfs==1)
			replace ilo_job1_ocu_isco88_2digits=13 if (Usual_PrincipalActivity_NCO2004==130 & ilo_lfs==1)
			replace ilo_job1_ocu_isco88_2digits=21 if (inrange(Usual_PrincipalActivity_NCO2004,211,214) & ilo_lfs==1)
			replace ilo_job1_ocu_isco88_2digits=22 if (inrange(Usual_PrincipalActivity_NCO2004,221,223) & ilo_lfs==1)
			replace ilo_job1_ocu_isco88_2digits=23 if (inrange(Usual_PrincipalActivity_NCO2004,231,233) & ilo_lfs==1)
			replace ilo_job1_ocu_isco88_2digits=24 if (inrange(Usual_PrincipalActivity_NCO2004,241,246) & ilo_lfs==1)
			replace ilo_job1_ocu_isco88_2digits=31 if (inrange(Usual_PrincipalActivity_NCO2004,311,315) & ilo_lfs==1)
			replace ilo_job1_ocu_isco88_2digits=32 if (inrange(Usual_PrincipalActivity_NCO2004,321,324) & ilo_lfs==1)
			replace ilo_job1_ocu_isco88_2digits=33 if (inrange(Usual_PrincipalActivity_NCO2004,331,334) & ilo_lfs==1)
			replace ilo_job1_ocu_isco88_2digits=34 if (inrange(Usual_PrincipalActivity_NCO2004,341,348) & ilo_lfs==1)
			replace ilo_job1_ocu_isco88_2digits=41 if (inrange(Usual_PrincipalActivity_NCO2004,411,419) & ilo_lfs==1)
			replace ilo_job1_ocu_isco88_2digits=42 if (inrange(Usual_PrincipalActivity_NCO2004,421,422) & ilo_lfs==1)
			replace ilo_job1_ocu_isco88_2digits=51 if (inrange(Usual_PrincipalActivity_NCO2004,511,516) & ilo_lfs==1)
			replace ilo_job1_ocu_isco88_2digits=52 if (inrange(Usual_PrincipalActivity_NCO2004,521,523) & ilo_lfs==1)
			replace ilo_job1_ocu_isco88_2digits=61 if (inrange(Usual_PrincipalActivity_NCO2004,611,615) & ilo_lfs==1)
			replace ilo_job1_ocu_isco88_2digits=62 if (Usual_PrincipalActivity_NCO2004==620 & ilo_lfs==1)
			replace ilo_job1_ocu_isco88_2digits=71 if (inrange(Usual_PrincipalActivity_NCO2004,711,714) & ilo_lfs==1)
			replace ilo_job1_ocu_isco88_2digits=72 if (inrange(Usual_PrincipalActivity_NCO2004,721,724) & ilo_lfs==1)
			replace ilo_job1_ocu_isco88_2digits=73 if (inrange(Usual_PrincipalActivity_NCO2004,731,734) & ilo_lfs==1)
			replace ilo_job1_ocu_isco88_2digits=74 if (inrange(Usual_PrincipalActivity_NCO2004,741,744) & ilo_lfs==1)
			replace ilo_job1_ocu_isco88_2digits=81 if (inrange(Usual_PrincipalActivity_NCO2004,811,817) & ilo_lfs==1)
			replace ilo_job1_ocu_isco88_2digits=82 if (inrange(Usual_PrincipalActivity_NCO2004,821,829) & ilo_lfs==1)
			replace ilo_job1_ocu_isco88_2digits=83 if (inrange(Usual_PrincipalActivity_NCO2004,831,834) & ilo_lfs==1)
			replace ilo_job1_ocu_isco88_2digits=91 if (inrange(Usual_PrincipalActivity_NCO2004,911,916) & ilo_lfs==1)
			replace ilo_job1_ocu_isco88_2digits=92 if (Usual_PrincipalActivity_NCO2004==920 & ilo_lfs==1)
			replace ilo_job1_ocu_isco88_2digits=93 if (inrange(Usual_PrincipalActivity_NCO2004,931,933) & ilo_lfs==1)
	
		lab values ilo_job1_ocu_isco88_2digits isco88_2digits
		label var ilo_job1_ocu_isco88_2digits "Occupation (ISCO-88), 2 digits levels"


		* ISCO 88 - 1 digit
		
		gen ilo_job1_ocu_isco88=.
			replace ilo_job1_ocu_isco88=1 if (inrange(ilo_job1_ocu_isco88_2digits,11,13))
			replace ilo_job1_ocu_isco88=2 if (inrange(ilo_job1_ocu_isco88_2digits,21,24))
			replace ilo_job1_ocu_isco88=3 if (inrange(ilo_job1_ocu_isco88_2digits,31,34))
			replace ilo_job1_ocu_isco88=4 if (inrange(ilo_job1_ocu_isco88_2digits,41,42))
			replace ilo_job1_ocu_isco88=5 if (inrange(ilo_job1_ocu_isco88_2digits,51,52))
			replace ilo_job1_ocu_isco88=6 if (inrange(ilo_job1_ocu_isco88_2digits,61,62))
			replace ilo_job1_ocu_isco88=7 if (inrange(ilo_job1_ocu_isco88_2digits,71,74))
			replace ilo_job1_ocu_isco88=8 if (inrange(ilo_job1_ocu_isco88_2digits,81,83))
			replace ilo_job1_ocu_isco88=9 if (inrange(ilo_job1_ocu_isco88_2digits,91,93))
			replace ilo_job1_ocu_isco88=11 if (ilo_job1_ocu_isco88_2digits==. & ilo_lfs==1)

		lab values ilo_job1_ocu_isco88 isco88
		label var ilo_job1_ocu_isco88 "Occupation (ISCO-88)"


		* Aggregate:	
		
		gen ilo_job1_ocu_aggregate=.
			replace ilo_job1_ocu_aggregate=1 if (inrange(ilo_job1_ocu_isco88,1,3))
			replace ilo_job1_ocu_aggregate=2 if (inrange(ilo_job1_ocu_isco88,4,5))
			replace ilo_job1_ocu_aggregate=3 if (inrange(ilo_job1_ocu_isco88,6,7))
			replace ilo_job1_ocu_aggregate=4 if (ilo_job1_ocu_isco88==8)
			replace ilo_job1_ocu_aggregate=5 if (ilo_job1_ocu_isco88==9)
			replace ilo_job1_ocu_aggregate=7 if (ilo_job1_ocu_isco88==11)
			
				lab def ocu_aggr_lab 1 "1 - Managers, professionals, and technicians" 2 "2 - Clerical, service and sales workers" 3 "3 - Skilled agricultural and trades workers" ///
									4 "4 - Plant and machine operators, and assemblers" 5 "5 - Elementary occupations"  6 "6 - Armed forces" 7 "7 - Not elsewhere classified"	
				lab val ilo_job1_ocu_aggregate ocu_aggr_lab
				lab var ilo_job1_ocu_aggregate "Occupation (Aggregate) - Main job"	


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

			gen ilo_job1_job_time=.
				replace ilo_job1_job_time=1 if (Full_Time_or_Part_Time==2 & ilo_lfs==1) 
				replace ilo_job1_job_time=2 if (Full_Time_or_Part_Time==1 & ilo_lfs==1)
				replace ilo_job1_job_time=3 if ilo_job1_job_time==. & ilo_lfs==1
					lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
					lab val ilo_job1_job_time job_time_lab
					lab var ilo_job1_job_time "Job (Working time arrangement) - Main job"	
			
		
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

* Comment:	Not clear how they define informal sector. Informal sector (defined to cover proprietary and partnership enterprises) - Does this mean they have identified it only according to 
*			the type of enterprise ?
*
*			The national definition:	Legal status - Proprietary and partnership firms in India do not have any separate legal status other than that of the owners. Thus such units are considered 
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
*			In the agriculture sector, industry groups 011 (growing of non-perennial crops), 012 (growing of perennial crops), 013 (plant propagation) and 015 (mixed farming) of NIC – 2008 were 
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
*	Useful questions / variables:
* 		Usual_Principal_Activity_Status - 5.1.3
*		Usual_PrincipalActivity_NIC2008 - 5.1.5 - Important as there is a skip pattern after this questions excluding groups 011, 012, 013, 015 (NIC-2008)
*		Location_of_Workspace - 5.1.8
* 		Enterprise_Type - 5.1.9
* 		No_of_Workers_in_Enterprise - 5.1.11 - Bookkeeping is irrelevant in the context of India as it's linked with the size of the enterprise (more than 10)
* 		Eligible_for_Paid_Leave - 5.1.13
*		Social_Security_Benefits - 5.1.14

		gen social_security=.
			replace social_security=1 if (Eligible_for_Paid_Leave==1 & inrange(Social_Security_Benefits,1,7) & ilo_lfs==1)

		gen ilo_job1_ife_prod=.
			
			replace ilo_job1_ife_prod=2 if (inlist(Enterprise_Type,5,6,7) | (inlist(Location_of_Workspace,14,16,24,26) & inlist(No_of_Workers_in_Enterprise,2,3,4)) | social_security==1) & ilo_lfs==1
				
			replace ilo_job1_ife_prod=3 if (Enterprise_Type==8 | (inlist(Location_of_Workspace,15,25) & Enterprise_Type!=5 & Enterprise_Type!=6 & Enterprise_Type!=7)) & ilo_lfs==1
				
			replace ilo_job1_ife_prod=1 if (ilo_job1_ife_prod!=2 & ilo_job1_ife_prod!=3 & ilo_lfs==1)

						lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 
						lab val ilo_job1_ife_prod ilo_ife_prod_lab
						lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"


	* 2) Nature of job - Formal / Informal Job

			gen ilo_job1_ife_nature=.

				replace ilo_job1_ife_nature=1 if (inlist(ilo_job1_ste_icse93,2,3,4) & ilo_job1_ife_prod!=2) | (ilo_job1_ste_icse93==1 & social_security!=1) | inlist(ilo_job1_ste_icse93,5,6)

				replace ilo_job1_ife_nature=2 if (inlist(ilo_job1_ste_icse93,2,3,4) & ilo_job1_ife_prod==2) | (ilo_job1_ste_icse93==1 & social_security==1)

						lab def ife_nature_lab 1 "1 - Persons with informal main job" 2 "2 - Persons with formal main job"
						lab val ilo_job1_ife_nature ife_nature_lab
						lab var ilo_job1_ife_nature "Informal / Formal Economy (Nature of job) - Main job"
		
			drop social_security


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
           
* Comment: 	NOT POSSIBLE - no variables indicating earnings under usual activity status
*			POSSIBLE with Block 5_3 under current activity status

			
		
***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_joball_tru')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			


* Comment: 	 Available_for_Additional_Work ("seeking or available for additional work") set to 1, 2 ('Yes')
*			 hours actually worked > 35 - not available
* 			 NOT POSSIBLE due to the lack of variable for working time


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
	
* Comment: 	NOT POSSIBLE - No information available in the questionnaire

	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment:	Block 5_1 - Seeking_available_for_work - it refers to the last 365 days, so the variable is not limited to the scope of unemmployment given the reference period, 
*			some catgories fall under employed or outside labour force, as the criteria to categorize persons according to LF status is major time spent. 
*			Therefore, this variable is not ideal to construct Duration of unemployment, it will be a misleading estimation even if we use the aggregate.
*			Seeking_available_for_work doesn't fit perfectly either of the 2 types of classification (details and aggregate) - category 3 - "3 months to less than 7 months"
* 			Block 5_3 on Current activity status contains a variable "Duration of present spell of unemployment" - this variable fits the classification better.			

		recode Seeking_available_for_work (1=1 "Less than 1 month")(2=2 "1 month to less than 3 months")(3=3 "3 months to less than 6 months") (4 5=4 "6 months to less than 12 months") (6=.), gen (temp_dur_details) 

	gen ilo_dur_details=.
			replace ilo_dur_details=1 if (temp_dur_details==1 & ilo_lfs==2)
			replace ilo_dur_details=2 if (temp_dur_details==2 & ilo_lfs==2)
			replace ilo_dur_details=3 if (temp_dur_details==3 & ilo_lfs==2)
			replace ilo_dur_details=4 if (temp_dur_details==4 & ilo_lfs==2)
			replace ilo_dur_details=7 if (temp_dur_details==. & ilo_lfs==2)
					lab def ilo_unemp_det 1 "Less than 1 month" 2 "1 month to less than 3 months" 3 "3 months to less than 6 months" ///
											4 "6 months to less than 12 months" 5 "12 months to less than 24 months" 6 "24 months or more" ///
											7 "Not elsewhere classified"
					lab val ilo_dur_details ilo_unemp_det
					lab var ilo_dur_details "Duration of unemployment (Details)"

* ADD NOTE: "3" includes 6 months (up to 7 months) (in the original variable 3 - 3 months & above but less than 7 months); "4" excludes 6 months, from 7 months on;


	gen ilo_dur_aggregate=.
				replace ilo_dur_aggregate=1 if (inlist(ilo_dur_details,1,2,3) & ilo_lfs==2)
				replace ilo_dur_aggregate=2 if (ilo_dur_details==4 & ilo_lfs==2)
				replace ilo_dur_aggregate=3 if (inlist(ilo_dur_details,5,6) & ilo_lfs==2)
				replace ilo_dur_aggregate=4 if (ilo_dur_details==7 & ilo_lfs==2)
					lab def ilo_unemp_aggr 1 "Less than 6 months" 2 "6 months to less than 12 months" 3 "12 months or more" 4 "Not elsewhere classified"
					lab val ilo_dur_aggregate ilo_unemp_aggr
					lab var ilo_dur_aggregate "Duration of unemployment (Aggregate)"
	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment: 	NOT POSSIBLE - No information available in the questionnaire


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

* Comment: 	NOT POSSIBLE - No information available in the questionnaire


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

* Comment: 	NOT POSSIBLE - No variable with reason for not seeking 
			

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seeker ('ilo_dis')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

* Comment: 	NOT POSSIBLE - Seeking and available for work do not exist as separate variables in the dataset and no variable for reason for not seeking 
			
			
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


drop if lab==1

* 1 - Full dataset with original variables and ILO ones
	
	cd "$outpath"

        compress
		save IND_NSS_2012_FULL, replace


* 2 - Dataset with only 'ILO' variables
	
		keep ilo*
		save IND_NSS_2012_ILO, replace

