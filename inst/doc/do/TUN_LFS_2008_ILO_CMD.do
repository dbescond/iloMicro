* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Tunisia
* DATASET USED: Tunisia LFS 
* NOTES: 
* Files created: Standard variables on LFS
* Authors: Podjanin
* Who last updated the file: Podjanin, A.
* Starting Date: 14 July 2017
* Last updated: 31 July 2017
***********************************************************************************************


*******************************************************************
 /* 1.	Set up work directory, file name, variables and function */
*******************************************************************


clear all 

set more off

global path "J:\COMMON\STATISTICS\DPAU\MICRO"
global country "TUN"
global source "LFS"
global time "2008"
global inputFile "enpe2008fi.dta"

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
	
*********************************************************************************************

* Create help variables for the time period considered
	
	gen year = "${time}"
		destring year, replace
	
	* don't consider observations not having a weight associated and not having any info about the sex of the person
	
	gen considered=1 if v_200!=.
	replace considered=. if v_205==.
	
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


		if year<=2006 {
			gen ilo_geo=v_011
				}			
			
		if year==2007 {
			gen ilo_geo=v_13
				}
			
		if year==2008 {		
		gen ilo_geo=v_16
			}
			
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
		
	gen ilo_age=v_210
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

	* define only aggregate level
		
		gen ilo_edu_aggregate=.
			replace ilo_edu_aggregate=1 if v_244==1
			replace ilo_edu_aggregate=2 if v_244==2
			replace ilo_edu_aggregate=3 if v_244==3
			replace ilo_edu_aggregate=4 if v_244==4
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

	* no info
						
				
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
* Comment: original variables are not available --> use pre-defined ones
	
	gen ilo_lfs=.
		replace ilo_lfs=1 if v_580==1
		replace ilo_lfs=2 if ilo_lfs!=1 & v_580==2
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

* Comment: 

			* no info
			

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

	if year==2005 {
	
	clonevar statut = v_321
	
	}
	
	else {
	
	clonevar statut = v_553
	
		}

	* Primary activity
	
		gen ilo_job1_ste_icse93=.
			replace ilo_job1_ste_icse93=1 if inlist(statut,3,4)
			replace ilo_job1_ste_icse93=2 if statut==1
			replace ilo_job1_ste_icse93=3 if statut==2
			/* replace ilo_job1_ste_icse93=4 if */
			replace ilo_job1_ste_icse93=5 if statut==5
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
			
			
		drop statut

	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: --> info only indicated at the aggregate level -- mapping for ISIC Rev. 4/3.1 can't be done

	* Import value labels

		append using `labels', gen (lab)

		if year==2005 {
		
		gen indu_code_prim=v_336 if ilo_lfs==1 
			}
			
		else {
		
		gen indu_code_prim=v_551 if ilo_lfs==1 
			}
		
	* Now do the classification on an aggregate level
	
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
				
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_ocu') [in progress]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: search for mapping - v_4_304_2 

					
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_ins_sector') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
		
* Comment: 

	* Primary occupation
	
	if year==2005 {
	
		gen ilo_job1_ins_sector=.
		replace ilo_job1_ins_sector=1 if inlist(v_325,1,2)
		replace ilo_job1_ins_sector=2 if ilo_job1_ins_sector==. & ilo_lfs==1
			}
	
		else {
	
	gen ilo_job1_ins_sector=.
		replace ilo_job1_ins_sector=1 if inlist(v_555,1,2)
		replace ilo_job1_ins_sector=2 if ilo_job1_ins_sector==. & ilo_lfs==1
				}
				
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
* Comment: 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment:

	* no info
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job_contract') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment:

		* no info 
		
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
					* [no info]: Location of workplace
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
	
		* no info
	
	
	
***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************			

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_tru') [don't define]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*                
* Comment: no question on availability

	* gen ilo_joball_tru=1 if ilo_job1_job_time==1 
			
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

			* no mapping for variable v_641 --> search for more info, otherwise don't define variable

	
	/*
	
	gen ilo_dur_details=.
		/* replace ilo_dur_details=1 if */
		replace ilo_dur_details=2 if inlist(v_5_640_i,1,2)
		replace ilo_dur_details=3 if inrange(v_5_640_i,3,5)
		replace ilo_dur_details=4 if inrange(v_5_640_i,6,11)
		replace ilo_dur_details=5 if inrange(v_5_640_i,12,23)
		replace ilo_dur_details=6 if v_5_640_i>=24 & v_5_640_i!=.
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
			
			
			*/
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Category of unemployment ('ilo_cat_une') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment:

	* info available in questionnaire, but not in this reduced dataset
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4') [not being defined]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: no info about previous economic activity
			
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu_isco08') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			
* Comment:

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
* Comment: info not available
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reasons for not seeking a job ('ilo_olf_reason') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: 
		
		* first - mapping missing, and none of the variables contained in this dataset seems to correspond to what we're looking for -> don't define

	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seekers ('ilo_dis') [done]
* -------------------------------------------------------------------------------------------
* ------------------------------------------------------------------------------------------- 
*
* Comment: 	


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training (NEETs) ('ilo_neet') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: *no info on attendance --> can't be defined
/*
		gen ilo_neet=.
			replace ilo_neet=1 if inrange(ilo_age,15,24) & ilo_lfs!=1 & ilo_edu_attendance==2
				lab def ilo_neet_lab 1 "Youth not in education, employment or training"
				lab val ilo_neet ilo_neet_lab
				lab var ilo_neet "Youth not in education, employment or training"
		
*/
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
		
		foreach var of varlist ilo_* {
	
		replace `var'=. if considered!=1
	
			}
			
		drop indu_code* lab isco08_2digits isco88_2digits isco08 isco88 isic4_2digits isic4 isic3_2digits isic3 considered 
		
		order ilo*, last
	
		compress 
		
	* Save dataset including original and ilo variables
	
		save ${country}_${source}_${time}_FULL,  replace		
	
	*Save file only containing ilo_* variables
	
		drop if ilo_wgt==.
	
		keep ilo*

		save ${country}_${source}_${time}_ILO, replace
		



