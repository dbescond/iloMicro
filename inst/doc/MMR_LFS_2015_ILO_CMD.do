* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Myanmar, 2015
* DATASET USED: Myanmar LFS 2015
* NOTES: 
* Files created: Standard variables on LFS Myanmar 2015 
* Authors: Lawani Deen
* Who last updated the file: 
* Starting Date: 1 December 2016
* Last updated: 14 March 2017
***********************************************************************************************

*******************************************************************
 /* 1.	Set up work directory, file name, variables and function */
******************************************************************

clear all 

set more off

global path "J:\COMMON\STATISTICS\DPAU\MICRO"
global country "MMR" 
global source "LFS"
global time "2015"

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


* Load original dataset 

cd "$inpath"

	use MMR_LFS_2015.dta
	
	* Import value labels

		append using `labels', gen (lab)
	

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

	gen ilo_key=_n
		lab var ilo_key "Key unique identifier per individual"		


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sample Weight ('ilo_wgt') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	
	gen ilo_wgt=M_final12
		lab var ilo_wgt "Sample weight"		

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time period ('ilo_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	* Year 2015:
	gen ilo_time=1
		lab def lab_time 1 "${time}" 
		lab val ilo_time lab_time
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

	gen ilo_geo=U_R
		lab def ilo_geo_lab 1 "Urban" 2 "Rural"
		lab val ilo_geo ilo_geo_lab
		lab var ilo_geo "Geographical coverage"	


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_sex=Q4
		lab def ilo_sex_la 1 "Male" 2 "Female"
		lab val ilo_sex ilo_sex_la
		lab var ilo_sex "Sex"
		

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_age=Q5AGE
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
*			Education ('ilo_edu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	*Comment: No correspondance on UIS website

	gen ilo_edu_aggregate=.
		replace ilo_edu_aggregate=1 if (Q34==2 | Q35==0 | Q35==1)
		replace ilo_edu_aggregate=2 if (Q35==2 | Q35==3 | Q35==4 | Q35==5)
		replace ilo_edu_aggregate=3 if (Q35==6 | Q35==7)
		replace ilo_edu_aggregate=4 if (Q35==8 | Q35==10 | Q35==11)
		replace ilo_edu_aggregate=5 if (ilo_edu_aggregate==.)

			lab def ilo_edu_aggregate_labc 1 "Less than basic" 2 " Basic" 3 " Intermediate" 4 "Advanced" 5 "Level not stated"
			lab val ilo_edu_aggregate ilo_edu_aggregate_labc
			lab var ilo_edu_aggregate "Education (Aggregate levels)"

		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education attendance ('ilo_edu_attendance') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_edu_attendance=.
		replace ilo_edu_attendance=1 if (Q37==1 | Q45==1)  		// Attending
		replace ilo_edu_attendance=2 if ilo_edu_attendance!=1  	// Not attending
			label def edu_att_lbk 1 " Attending" 2 " Not attending"
			label val ilo_edu_attendance edu_att_lbk
			label var ilo_edu_attendance "Education (Attendance)"

			
* ------------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Disability status (Details)
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

	gen ilo_dsb_details=.
		replace ilo_dsb_details=1 if (Q27==1 & Q28==1 & Q29==1 & Q30==1 & Q31==1 & Q32==1)		
		replace ilo_dsb_details=2 if (Q27==2 | Q28==2 | Q29==2 | Q30==2 | Q31==2 | Q32==2)				
		replace ilo_dsb_details=3 if (Q27==3 | Q28==3 | Q29==3 | Q30==3 | Q31==3 | Q32==3)				
		replace ilo_dsb_details=4 if (Q27==4 | Q28==4 | Q29==4 | Q30==4 | Q31==4 | Q32==4)
			label def ilo_dsb_details_fm  1 "No, no difficulty" 2 "Yes, some difficulty"  3"Yes, a lot of difficulty" 4 "Cannot do it at all"
			label value	ilo_dsb_details	ilo_dsb_details_fm
			label var ilo_dsb_details "Disability status (Details)"


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Disability status (Aggregate)
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_dsb_aggregate=.
		replace ilo_dsb_aggregate=2 if (Q27==3 | Q27==4 | Q28==3 | Q28==4 | Q29==3 | Q29==4 | Q30==3 | Q30==4 | Q31==3 | Q31==4 | Q32==3 | Q32==4)		
		replace ilo_dsb_aggregate=1 if ilo_dsb_aggregate!=2
			label define ilo_dsb_aggregate_lTlh  1 "Persons without disability" 2 "Persons with disability" 
			label value ilo_dsb_aggregate ilo_dsb_aggregate_lTlh
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
       
* Comment: wap = 15+ 

	gen ilo_wap=.
		replace ilo_wap=1 if (ilo_age>=15 & ilo_age!=.)
		replace ilo_wap=0 if (ilo_age<15)
			label var ilo_wap "Working age population"

		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Labour Force Status ('ilo_lfs') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
			
* Comment: 
	
	gen ilo_lfs=.
		replace ilo_lfs=1 if (Q52==1 | Q55==2 | Q56==1 | Q56==2 | inlist(Q58,1,2,3,4) | Q59==1 | Q60==1) 	// Employed
		replace ilo_lfs=2 if (ilo_lfs!=1 & (q111==1 | q115==1) & q117==1 & ilo_wap==1)			   			// Unemployed
		replace ilo_lfs=3 if (ilo_lfs!=1 & ilo_lfs!=2 & ilo_wap==1)											// Outside the labour force
		replace ilo_lfs=. if ilo_wap!=1
				label define sxv_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside the Labour Force"
				label value ilo_lfs sxv_ilo_lfs
				label var ilo_lfs "Labour Force Status"	
				

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_mjh=.
		replace ilo_mjh=1 if Q94==2 & ilo_lfs==1 & ilo_wap==1
		replace ilo_mjh=2 if Q94==1 & ilo_lfs==1 & ilo_wap==1
			lab def lC_ilo_mjh 1 "One job only" 2 " More than one job"
			lab val ilo_mjh lC_ilo_mjh
			lab var ilo_mjh "Multiple job holders"


***********************************************************************************************
*			PART 3.1. ECONOMIC CHARACTERISTICS FOR MAIN JOB 
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Status in employment ('ilo_job1_ste') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	* Main Job

		gen ilo_job1_ste_icse93=.
			replace ilo_job1_ste_icse93=1 if (Q70==1 | Q70==2) & ilo_lfs==1	// Employees 
			replace ilo_job1_ste_icse93=2 if Q70==3 & ilo_lfs==1			// Employers
			replace ilo_job1_ste_icse93=3 if Q70==4 & ilo_lfs==1			// Own-account workers
		    replace ilo_job1_ste_icse93=4 if Q70==7 & ilo_lfs==1			// Members of producers cooperatives
		    replace ilo_job1_ste_icse93=5 if (Q70==5 | Q70==6) & ilo_lfs==1	// Contributing family workers
		 	replace ilo_job1_ste_icse93=6 if Q70==. & ilo_lfs==1			// Not classifiable
				
				label def lBx_ilo_ste_icse93 1 "Employees" 2 "Employers" 3 "Own-account workers"  4 "Members of producers cooperatives" 5 "Contributing family workers" 6 "Workers not classifiable by status"
				label val ilo_job1_ste_icse93 lBx_ilo_ste_icse93
				label var ilo_job1_ste_icse93 "Status in employment (ICSE 93)"

	* Aggregate categories 

		gen ilo_job1_ste_aggregate=.
			replace ilo_job1_ste_aggregate=1 if ilo_job1_ste_icse93==1 & ilo_lfs==1																					// Employees
			replace ilo_job1_ste_aggregate=2 if (ilo_job1_ste_icse93==2 | ilo_job1_ste_icse93==3 | ilo_job1_ste_icse93==4 | ilo_job1_ste_icse93==5) & ilo_lfs==1	// Self-employed
			replace ilo_job1_ste_aggregate=3 if (ilo_job1_ste_icse93==6) & ilo_lfs==1																				// Not elsewhere classified
				lab def ste_aggr_lL 1 "Employees" 2 "Self-employed" 3 "Not elsewhere classified"
				lab val ilo_job1_ste_aggregate ste_aggr_lL
				label var ilo_job1_ste_aggregate "Status in employment (Aggregate)"  

				
	* Secondary Job

		gen ilo_job2_ste_icse93=.
			replace ilo_job2_ste_icse93=1 if (Q99==1 | Q99==2)& ilo_mjh==2	// Employees 
			replace ilo_job2_ste_icse93=2 if Q99==3 & ilo_mjh==2			// Employers
			replace ilo_job2_ste_icse93=3 if Q99==4 & ilo_mjh==2			// Own-account workers
		    replace ilo_job2_ste_icse93=4 if Q99==7 & ilo_mjh==2			// Members of producers cooperatives
		    replace ilo_job2_ste_icse93=5 if (Q99==5 | Q99==6) & ilo_mjh==2	// Contributing family workers
		 	replace ilo_job2_ste_icse93=6 if Q99==. & ilo_mjh==2			// Not classifiable
				
				label def lBsx_ilo_ste_icse93 1 "Employees" 2 "Employers" 3 "Own-account workers"  4 "Members of producers cooperatives" 5 "Contributing family workers" 6 "Workers not classifiable by status"
				label val ilo_job2_ste_icse93 lBsx_ilo_ste_icse93
				label var ilo_job2_ste_icse93 "Status in employment (ICSE 93)"
		

	* Aggregate categories 

		gen ilo_job2_ste_aggregate=.
			replace ilo_job2_ste_aggregate=1 if ilo_job1_ste_icse93==1 	& ilo_mjh==2																				// Employees
			replace ilo_job2_ste_aggregate=2 if (ilo_job1_ste_icse93==2 | ilo_job1_ste_icse93==3 | ilo_job1_ste_icse93==4 | ilo_job1_ste_icse93==5) & ilo_mjh==2 	// Self-employed
			replace ilo_job2_ste_aggregate=3 if (ilo_job1_ste_icse93==6) & ilo_mjh==2																				// Not elsewhere classified
				lab def ste_aggr_lLv 1 "Employees" 2 "Self-employed" 3 "Not elsewhere classified"
				lab val ilo_job2_ste_aggregate ste_aggr_lLv
				label var ilo_job2_ste_aggregate "Status in employment (Aggregate)"  

				
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	* Comment:National classification correspond ISIC Rev4-2 digits

	* Main Job

		*ISIC Rev4
		
		gen ilo_job1_eco_isic4=.
			replace ilo_job1_eco_isic4=1 if inrange(Q63ii,0111,0322) & ilo_lfs==1
			replace ilo_job1_eco_isic4=2 if inrange(Q63ii,0510,0990) & ilo_lfs==1
			replace ilo_job1_eco_isic4=3 if inrange(Q63ii,1010,3320) & ilo_lfs==1
			replace ilo_job1_eco_isic4=4 if inrange(Q63ii,3510,3530) & ilo_lfs==1
			replace ilo_job1_eco_isic4=5 if inrange(Q63ii,3600,3900) & ilo_lfs==1		
			replace ilo_job1_eco_isic4=6 if inrange(Q63ii,4100,4390) & ilo_lfs==1		
			replace ilo_job1_eco_isic4=7 if inrange(Q63ii,4510,4799) & ilo_lfs==1
			replace ilo_job1_eco_isic4=8 if inrange(Q63ii,4911,5320) & ilo_lfs==1
			replace ilo_job1_eco_isic4=9 if inrange(Q63ii,5510,5630) & ilo_lfs==1
			replace ilo_job1_eco_isic4=10 if inrange(Q63ii,5811,6399) & ilo_lfs==1	
			replace ilo_job1_eco_isic4=11 if inrange(Q63ii,6411,6630) & ilo_lfs==1	
			replace ilo_job1_eco_isic4=12 if inrange(Q63ii,6810,6820) & ilo_lfs==1	
			replace ilo_job1_eco_isic4=13 if inrange(Q63ii,6910,7500) & ilo_lfs==1
			replace ilo_job1_eco_isic4=14 if inrange(Q63ii,7710,8299) & ilo_lfs==1
			replace ilo_job1_eco_isic4=15 if inrange(Q63ii,8411,8430) & ilo_lfs==1
			replace ilo_job1_eco_isic4=16 if inrange(Q63ii,8510,8550) & ilo_lfs==1
			replace ilo_job1_eco_isic4=17 if inrange(Q63ii,8610,8690) & ilo_lfs==1
			replace ilo_job1_eco_isic4=18 if inrange(Q63ii,9000,9329) & ilo_lfs==1
			replace ilo_job1_eco_isic4=19 if inrange(Q63ii,9411,9609) & ilo_lfs==1
			replace ilo_job1_eco_isic4=20 if inrange(Q63ii,9700,9820) & ilo_lfs==1
			replace ilo_job1_eco_isic4=21 if Q63ii==9900 & ilo_lfs==1
			replace ilo_job1_eco_isic4=22 if Q63ii==. & ilo_lfs==1
			replace ilo_job1_eco_isic4=22 if ilo_job1_eco_isic4==. & ilo_lfs==1
					replace ilo_job1_eco_isic4=. if ilo_lfs!=1 
				lab def ilo_job1_eco_isic4_SSSSl 1 "Agriculture, forestry and fishing" 2 "Mining and quarrying" 3 "Manufacturing" 4 "Electricity, gas, steam and air conditioning supply" ///
                             5  " Water supply; sewerage, waste management and remediation activities" ///
                             6  "Construction" ///
                             7  "Wholesale and retail trade; repair of motor vehicles and motorcycles" ///
                             8  "Transportation and storage" ///
                             9  "Accommodation and food service activities" ///
                             10 "Information and communication" ///
                             11 "Financial and insurance activities" ///
                             12 "Real estate activities" ///
                             13 "Professional, scientific and technical activities" ///
                             14 "Administrative and support service activities" ///
                             15 "Public administration and defence; compulsory social security" ///
                             16 "Education" ///
                             17 "Human health and social work activities" ///
                             18 "Arts, entertainment and recreation" ///
							 19 "Other service activities" ///
                             20 "Activities of households as employers; undifferentiated goods- and services-producing activities of households for own use" ///
                             21 "Activities of extraterritorial organizations and bodies" /// 
							 22  "Not elsewhere classified" 
				lab val ilo_job1_eco_isic4 ilo_job1_eco_isic4_SSSSl
				lab var ilo_job1_eco_isic4 "Economic activity (ISIC Rev. 4) - Main job"	

				
					* Aggregated level 
					
						gen ilo_job1_eco_aggregate=.
							replace ilo_job1_eco_aggregate=1 if ilo_job1_eco_isic4==1
							replace ilo_job1_eco_aggregate=2 if ilo_job1_eco_isic4==3
							replace ilo_job1_eco_aggregate=3 if ilo_job1_eco_isic4==6
							replace ilo_job1_eco_aggregate=4 if inlist(ilo_job1_eco_isic4,2,4,5)
							replace ilo_job1_eco_aggregate=5 if inrange(ilo_job1_eco_isic4,7,14)
							replace ilo_job1_eco_aggregate=6 if inrange(ilo_job1_eco_isic4,15,21)
							replace ilo_job1_eco_aggregate=7 if ilo_job1_eco_isic4==22
								lab def eco_aggr_labe 1 "1 - Agriculture" 2 "2 - Manufacturing" 3 "3 - Construction" 4 "4 - Mining and quarrying; Electricity, gas and water supply" ///
									5 "5 - Market Services (Trade; Transportation; Accommodation and food; and Business and administrative services)"  ///
									6 "6 - Non-market services (Public administration; Community, social and other services and activities)" 7 "7 - Not classifiable by economic activity"					
								lab val ilo_job1_eco_aggregate eco_aggr_labe
								lab var ilo_job1_eco_aggregate "Economic activity (Aggregate) - main job"  
	
	* ISIC Rev4-2 digits	
	
	gen indu_code_prim=int(Q63ii/100) if ilo_lfs==1 
					
	* Primary activity
		
	gen ilo_job1_eco_isic4_2digits=indu_code_prim
			lab values ilo_job1_eco_isic4_2digits isic4_2digits
			lab var ilo_job1_eco_isic4_2digits "Economic activity (ISIC Rev. 4), 2 digit level"
	
								
	*Secondary job	

	gen ilo_job2_eco_isic4=.
		replace ilo_job2_eco_isic4=1 if inrange(Q98,0111,0322) & ilo_mjh==2
		replace ilo_job2_eco_isic4=2 if inrange(Q98,0510,0990) & ilo_mjh==2
		replace ilo_job2_eco_isic4=3 if inrange(Q98,1010,3320) & ilo_mjh==2
		replace ilo_job2_eco_isic4=4 if inrange(Q98,3510,3530) & ilo_mjh==2
		replace ilo_job2_eco_isic4=5 if inrange(Q98,3600,3900) & ilo_mjh==2		
		replace ilo_job2_eco_isic4=6 if inrange(Q98,4100,4390) & ilo_mjh==2		
		replace ilo_job2_eco_isic4=7 if inrange(Q98,4510,4799) & ilo_mjh==2
		replace ilo_job2_eco_isic4=8 if inrange(Q98,4911,5320) & ilo_mjh==2
		replace ilo_job2_eco_isic4=9 if inrange(Q98,5510,5630) & ilo_mjh==2
		replace ilo_job2_eco_isic4=10 if inrange(Q98,5811,6399) & ilo_mjh==2	
		replace ilo_job2_eco_isic4=11 if inrange(Q98,6411,6630) & ilo_mjh==2	
		replace ilo_job2_eco_isic4=12 if inrange(Q98,6810,6820) & ilo_mjh==2	
		replace ilo_job2_eco_isic4=13 if inrange(Q98,6910,7500) & ilo_mjh==2
		replace ilo_job2_eco_isic4=14 if inrange(Q98,7710,8299) & ilo_mjh==2
		replace ilo_job2_eco_isic4=15 if inrange(Q98,8411,8430) & ilo_mjh==2
		replace ilo_job2_eco_isic4=16 if inrange(Q98,8510,8550) & ilo_mjh==2
		replace ilo_job2_eco_isic4=17 if inrange(Q98,8610,8690) & ilo_mjh==2
		replace ilo_job2_eco_isic4=18 if inrange(Q98,9000,9329) & ilo_mjh==2
		replace ilo_job2_eco_isic4=19 if inrange(Q98,9411,9609) & ilo_mjh==2
		replace ilo_job2_eco_isic4=20 if inrange(Q98,9700,9820) & ilo_mjh==2
		replace ilo_job2_eco_isic4=21 if Q98==9900 & ilo_mjh==2
		replace ilo_job2_eco_isic4=22 if Q98==. & ilo_mjh==2
		replace ilo_job2_eco_isic4=22 if ilo_job2_eco_isic4==. & ilo_mjh==2 
				replace ilo_job2_eco_isic4=. if ilo_lfs!=1 & ilo_mjh!=2
			lab def ilo_job2_eco_isic4_x 1 "Agriculture, forestry and fishing" 2 "Mining and quarrying" 3 "Manufacturing" 4 "Electricity, gas, steam and air conditioning supply" ///
                             5  " Water supply; sewerage, waste management and remediation activities" ///
                             6  "Construction" ///
                             7  "Wholesale and retail trade; repair of motor vehicles and motorcycles" ///
                             8  "Transportation and storage" ///
                             9  "Accommodation and food service activities" ///
                             10 "Information and communication" ///
                             11 "Financial and insurance activities" ///
                             12 "Real estate activities" ///
                             13 "Professional, scientific and technical activities" ///
                             14 "Administrative and support service activities" ///
                             15 "Public administration and defence; compulsory social security" ///
                             16 "Education" ///
                             17 "Human health and social work activities" ///
                             18 "Arts, entertainment and recreation" ///
							 19 "Other service activities" ///
                             20 "Activities of households as employers; undifferentiated goods- and services-producing activities of households for own use" ///
                             21 "Activities of extraterritorial organizations and bodies" /// 
							 22 "Not elsewhere classified" 
			lab val ilo_job2_eco_isic4 ilo_job1_eco_isic4_x
			lab var ilo_job2_eco_isic4 "Economic activity (ISIC Rev. 4) - Main job"	

			
					* Aggregated level 
					
						gen ilo_job2_eco_aggregate=.
							replace ilo_job2_eco_aggregate=1 if ilo_job1_eco_isic4==1  & ilo_mjh==2
							replace ilo_job2_eco_aggregate=2 if ilo_job1_eco_isic4==3  & ilo_mjh==2
							replace ilo_job2_eco_aggregate=3 if ilo_job1_eco_isic4==6  & ilo_mjh==2
							replace ilo_job2_eco_aggregate=4 if inlist(ilo_job1_eco_isic4,2,4,5) & ilo_mjh==2
							replace ilo_job2_eco_aggregate=5 if inrange(ilo_job1_eco_isic4,7,14) & ilo_mjh==2
							replace ilo_job2_eco_aggregate=6 if inrange(ilo_job1_eco_isic4,15,21) & ilo_mjh==2
							replace ilo_job2_eco_aggregate=7 if ilo_job2_eco_isic4==22  & ilo_mjh==2
								lab def eco_aggr_labex 1 "1 - Agriculture" 2 "2 - Manufacturing" 3 "3 - Construction" 4 "4 - Mining and quarrying; Electricity, gas and water supply" ///
									5 "5 - Market Services (Trade; Transportation; Accommodation and food; and Business and administrative services)"  ///
									6 "6 - Non-market services (Public administration; Community, social and other services and activities)" 7 "7 - Not classifiable by economic activity"					
								lab val ilo_job2_eco_aggregate eco_aggr_labex
								lab var ilo_job2_eco_aggregate "Economic activity (Aggregate) - main job"  
								
								
								
								

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_job1_ocu_isco88') [done]
* -------------------------------------------------------------------------------------------
* ------------------------------------------------------------------------------------------
		* Comment: National classification correspond isco08_2digits*
		
	*Main Job

		*ISCO 08- 2 digits
	
		gen occ_code_prim=int(Q62/100) if ilo_lfs==1
	
		* Primary occupation
		
		gen ilo_job1_ocu_isco08_2digits=occ_code_prim
			lab values ilo_job1_ocu_isco08_2digits isco08_2digits
			lab var ilo_job1_ocu_isco08_2digits  "Occupation (ISCO-08), 2 digit level" 

	
		gen ilo_job1_ocu_isco08=.
			replace ilo_job1_ocu_isco08=1 if inrange(Q62,1111,1439) & ilo_lfs==1 
			replace ilo_job1_ocu_isco08=2 if inrange(Q62,2111,2659) & ilo_lfs==1 
			replace ilo_job1_ocu_isco08=3 if inrange(Q62,3111,3522) & ilo_lfs==1 
			replace ilo_job1_ocu_isco08=4 if inrange(Q62,4110,4419) & ilo_lfs==1 
			replace ilo_job1_ocu_isco08=5 if inrange(Q62,5111,5419) & ilo_lfs==1
			replace ilo_job1_ocu_isco08=6 if inrange(Q62,6111,6340) & ilo_lfs==1
			replace ilo_job1_ocu_isco08=7 if inrange(Q62,7111,7549) & ilo_lfs==1
			replace ilo_job1_ocu_isco08=8 if inrange(Q62,8111,8350) & ilo_lfs==1
			replace ilo_job1_ocu_isco08=9 if inrange(Q62,9111,9629) & ilo_lfs==1
			replace ilo_job1_ocu_isco08=10 if inrange(Q62,0110,0310) & ilo_lfs==1
			replace ilo_job1_ocu_isco08=11 if ilo_job1_ocu_isco08==. & ilo_lfs==1
				replace ilo_job1_ocu_isco08=. if ilo_lfs!=1
		
				lab def ilo_job1_ocu_isco08_l 1 "1 - Managers" 2 "2 - Professionals" 3 "3 - Technicians and associate professionals" 4 "4 - Clerical support workers" ///
											5 "5 - Service and sales workers" 6 "6 - Skilled agricultural, forestry and fishery workers" 7 "7 - Craft and related trades workers" ///
											8 "8 - Plant and machine operators, and assemblers" 9 "9 - Elementary occupations" 10 "10 - Armed forces occupations" 11 "X - Not elsewhere classified"
				lab val ilo_job1_ocu_isco08 ilo_job1_ocu_isco08_l
				lab var ilo_job1_ocu_isco08 "Occupation (ISCO-08) - Main job"
	
					
		* Aggregate:
	
			gen ilo_job1_ocu_aggregate=.
				replace ilo_job1_ocu_aggregate=1 if inrange(ilo_job1_ocu_isco08,1,3)
				replace ilo_job1_ocu_aggregate=2 if inlist(ilo_job1_ocu_isco08,4,5)
				replace ilo_job1_ocu_aggregate=3 if inlist(ilo_job1_ocu_isco08,6,7)
				replace ilo_job1_ocu_aggregate=4 if ilo_job1_ocu_isco08==8
				replace ilo_job1_ocu_aggregate=5 if ilo_job1_ocu_isco08==9
				replace ilo_job1_ocu_aggregate=6 if ilo_job1_ocu_isco08==10
				replace ilo_job1_ocu_aggregate=7 if ilo_job1_ocu_isco08==11
					lab def ocu_aggr_la 1 "1 - Managers, professionals, and technicians" 2 "2 - Clerical, service and sales workers" 3 "3 - Skilled agricultural and trades workers" ///
										4 "4 - Plant and machine operators, and assemblers" 5 "5 - Elementary occupations" 6 "6 - Armed forces" 7 "7 - Not elsewhere classified"
					lab val ilo_job1_ocu_aggregate ocu_aggr_la
					lab var ilo_job1_ocu_aggregate "Occupation (Aggregate) - Main job"	

				
	* Secondary job


		gen ilo_job2_ocu_isco08=.
			replace ilo_job2_ocu_isco08=1 if inrange(Q96,1111,1439) & ilo_lfs==1 & ilo_mjh==2
			replace ilo_job2_ocu_isco08=2 if inrange(Q96,2111,2659) & ilo_lfs==1 & ilo_mjh==2 
			replace ilo_job2_ocu_isco08=3 if inrange(Q96,3111,3522) & ilo_lfs==1 & ilo_mjh==2
			replace ilo_job2_ocu_isco08=4 if inrange(Q96,4110,4419) & ilo_lfs==1 & ilo_mjh==2
			replace ilo_job2_ocu_isco08=5 if inrange(Q96,5111,5419) & ilo_lfs==1 & ilo_mjh==2
			replace ilo_job2_ocu_isco08=6 if inrange(Q96,6111,6340) & ilo_lfs==1 & ilo_mjh==2
			replace ilo_job2_ocu_isco08=7 if inrange(Q96,7111,7549) & ilo_lfs==1 & ilo_mjh==2
			replace ilo_job2_ocu_isco08=8 if inrange(Q96,8111,8350) & ilo_lfs==1 & ilo_mjh==2
			replace ilo_job2_ocu_isco08=9 if inrange(Q96,9111,9629) & ilo_lfs==1 & ilo_mjh==2
			replace ilo_job2_ocu_isco08=10 if inrange(Q96,0110,0310) & ilo_lfs==1 & ilo_mjh==2
			replace ilo_job2_ocu_isco08=11 if ilo_job2_ocu_isco08==. & ilo_lfs==1 & ilo_mjh==2
				replace ilo_job2_ocu_isco08=. if ilo_lfs!=1 & ilo_mjh!=2
					* value label already defined
				lab val ilo_job2_ocu_isco08 ilo_job1_ocu_isco08_l
				lab var ilo_job2_ocu_isco08 "Occupation (ISCO-08) - Main job"
					

		* Aggregate:

			gen ilo_job2_ocu_aggregate=.
				replace ilo_job2_ocu_aggregate=1 if inrange(ilo_job2_ocu_isco08,1,3)
				replace ilo_job2_ocu_aggregate=2 if inlist(ilo_job2_ocu_isco08,4,5)
				replace ilo_job2_ocu_aggregate=3 if inlist(ilo_job2_ocu_isco08,6,7)
				replace ilo_job2_ocu_aggregate=4 if ilo_job2_ocu_isco08==8
				replace ilo_job2_ocu_aggregate=5 if ilo_job2_ocu_isco08==9
				replace ilo_job2_ocu_aggregate=6 if ilo_job2_ocu_isco08==10
				replace ilo_job2_ocu_aggregate=7 if ilo_job2_ocu_isco08==11
					lab def ocu_aggr_labe 1 "1 - Managers, professionals, and technicians" 2 "2 - Clerical, service and sales workers" 3 "3 - Skilled agricultural and trades workers" ///
										4 "4 - Plant and machine operators, and assemblers" 5 "5 - Elementary occupations" 6 "6 - Armed forces" 7 "7 - Not elsewhere classified"
					lab val ilo_job2_ocu_aggregate ocu_aggr_labe
					lab var ilo_job2_ocu_aggregate "Occupation (Aggregate) - Main job"	
	
	
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_job1_ins_sector') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

	gen ilo_job1_ins_sector=.
		replace ilo_job1_ins_sector=1 if (Q67==1 | Q67==4 | Q67==5) & ilo_lfs==1
		replace ilo_job1_ins_sector=2 if (ilo_job1_ins_sector!=1 & ilo_lfs==1)	
			lab def ilo_job1_ins_sector_lTGL 1 "Public" 2 "Private" 
			lab val ilo_job1_ins_sector ilo_job1_ins_sector_lTGL
			label var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities"


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Hours of work ('ilo_job1_how_actual') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	
		* Main job:
		
			gen ilo_job1_how_actual=.
				replace ilo_job1_how_actual= (q102i*q100i) if ilo_lfs==1
				replace ilo_job1_how_actual=0 if (ilo_job1_how_actual==. & ilo_lfs==1)
					lab var ilo_job1_how_actual "Weekly hours actually worked in main job"
		
			gen ilo_job1_how_actual_bands=.
				replace ilo_job1_how_actual_bands=1 if (ilo_job1_how_actual==0 | ilo_job1_how_actual==.) & ilo_lfs==1
				replace ilo_job1_how_actual_bands=2 if inrange(ilo_job1_how_actual,1,14) & ilo_lfs==1
				replace ilo_job1_how_actual_bands=3 if inrange(ilo_job1_how_actual,15,29)& ilo_lfs==1
				replace ilo_job1_how_actual_bands=4 if inrange(ilo_job1_how_actual,30,34) & ilo_lfs==1
				replace ilo_job1_how_actual_bands=5 if inrange(ilo_job1_how_actual,35,39)& ilo_lfs==1
				replace ilo_job1_how_actual_bands=6 if inrange(ilo_job1_how_actual,40,48) & ilo_lfs==1
				replace ilo_job1_how_actual_bands=7 if ilo_job1_how_actual>=49 & ilo_job1_how_actual!=. & ilo_lfs==1
				
					lab def how_bands_l 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 
					lab val ilo_job1_how_actual_bands how_bands_l
					lab var ilo_job1_how_actual_bands "Weekly hours actually worked bands in main job"
	

		* All jobs:

			gen ilo_joball_how_actual= .
				replace ilo_joball_how_actual= (q102i*q100i)+(q102ii*q100ii) if (ilo_mjh==2 & ilo_lfs==1)
				replace ilo_joball_how_actual=ilo_job1_how_actual if ((ilo_mjh==1 | ilo_mjh==.) & ilo_lfs==1)
				replace ilo_joball_how_actual=ilo_job1_how_actual if (ilo_joball_how_actual==. & ilo_lfs==1)
					lab var ilo_joball_how_actual "Weekly hours actually worked in all jobs"
				

			gen ilo_joball_how_actual_bands=.
				replace ilo_joball_how_actual_bands=1 if (ilo_joball_how_actual==0 | ilo_joball_how_actual==.) & ilo_lfs==1
				replace ilo_joball_how_actual_bands=2 if inrange(ilo_joball_how_actual,1,14) & ilo_lfs==1
				replace ilo_joball_how_actual_bands=3 if inrange(ilo_joball_how_actual,15,29) & ilo_lfs==1
				replace ilo_joball_how_actual_bands=4 if inrange(ilo_joball_how_actual,30,34) & ilo_lfs==1
				replace ilo_joball_how_actual_bands=5 if inrange(ilo_joball_how_actual,35,39) & ilo_lfs==1
				replace ilo_joball_how_actual_bands=6 if inrange(ilo_joball_how_actual,40,48) & ilo_lfs==1
				replace ilo_joball_how_actual_bands=7 if (ilo_joball_how_actual>=49 & ilo_joball_how_actual!=.) & ilo_lfs==1
				lab def how_bands_T 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 
				lab val ilo_joball_how_actual_bands how_bands_T
				lab var ilo_joball_how_actual_bands "Weekly hours actually worked bands in all jobs		


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			ilo_joball_how_usual (Weekly hours usually worked) [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

		* Main Job
 
		gen ilo_job_how_usual=.
			replace ilo_job_how_usual=(q100i*q101i)
			replace ilo_job_how_usual=168 if (ilo_job_how_usual>168 & ilo_job_how_usual!=.)
			replace ilo_job_how_usual=0 if (ilo_job_how_usual==. & ilo_lfs==1)
				lab var ilo_job_how_usual "Weekly hours usually worked in main job"
		
		* All Job

		gen ilo_joball_how_usual=.
			replace ilo_joball_how_usual=(q100i*q101i)+(q100ii*q101ii) if (ilo_mjh==2 & ilo_lfs==1)
			replace ilo_joball_how_usual=(q100i*q101i) if (ilo_mjh==1 & ilo_lfs==1)
			replace ilo_joball_how_usual=168 if (ilo_joball_how_usual>168 & ilo_joball_how_usual!=.)
			replace ilo_joball_how_usual=0 if (ilo_joball_how_usual==. & ilo_lfs==1)
				lab var ilo_joball_how_usual "Weekly hours usually worked in all job"

		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job1_job_time') [done]
* ------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
	
		* Main job:

			gen ilo_job1_job_time=.
				replace ilo_job1_job_time=1 if (ilo_job_how_usual<35 & ilo_job_how_usual>0 & ilo_lfs==1)
				replace ilo_job1_job_time=2 if (ilo_job_how_usual>=35 & ilo_job_how_usual!=. & ilo_lfs==1)
				replace ilo_job1_job_time=3 if (ilo_job_how_usual==. | ilo_job_how_usual==0) & ilo_lfs==1
					lab def job_time_lady 1 "Part-time" 2 " Full-time" 3 "Unknown"
					lab val ilo_job1_job_time job_time_lady
					lab var ilo_job1_job_time "Job (Working time arrangement) - Main job"

					
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job1_job_contract') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			

	gen ilo_job1_job_contract=.
		replace ilo_job1_job_contract=1 if (Q76==2 & ilo_lfs==1)
		replace ilo_job1_job_contract=2 if (Q76==1 & ilo_lfs==1)
		replace ilo_job1_job_contract=3 if Q76==3 & ilo_lfs==1
			lab def FMT_ilo_job1_job_contract 1 " Permanent" 2 "Temporary" 3" Unknown"	
			lab val ilo_job1_job_contract FMT_ilo_job1_job_contract	
			label var ilo_job1_job_contract "Job (Type of contract)"
	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*		Informal / Formal Economy (Type of production)	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			

* Useful questions
		*	Q65 - Size
		*	Q66 - Location
		*	Q67 - Institutional Sector
		*   Q68 - Bookkeeping
		*	Q69 - Registration
		*	Q70 - Status
		*	Q71 - Pension / Q72 - Paid annual leave and Q73 - Paid sick leave are not considered as their scope is similar to Q71

	* 1) Type of production - Formal / Informal Sector

			gen social_security=.
			
				replace social_security=1 if ((Q71==1 | Q71==2 | Q71==3) & ilo_lfs==1)
	
			gen ilo_job1_ife_prod=.
				
				replace ilo_job1_ife_prod=2 if (inlist(Q67,1,2,3,4,5) | Q68==1 | inlist(Q69,1,2,3,4,5) | (ilo_job1_ste_icse93==1 & social_security==1) | (Q66==4 & inlist(Q65,3,4,5,6,7))) & ilo_lfs==1
				
				replace ilo_job1_ife_prod=3 if (Q67==8 | ilo_job1_eco_isic4_2digits==97 | ilo_job1_ocu_isco08_2digits==63) & ilo_job1_ife_prod!=2==1 & ilo_lfs==1
				
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
*			Monthly labour related income ('ilo_job1_lri') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
	   
			* Main job
				
			* Employees
			
			gen ilo_job1_lri_ees =.
				replace ilo_job1_lri_ees = Q84Tot if Q82==1 & Q85==4 & ilo_job1_ste_aggregate==1
				replace ilo_job1_lri_ees = (Q84Tot*365/12) if Q82==1 & Q85==1 & ilo_job1_ste_aggregate==1
				replace ilo_job1_lri_ees = (Q84Tot*52/12) if Q82==1 & Q85==2 & ilo_job1_ste_aggregate==1
				replace ilo_job1_lri_ees = (Q84Tot*26/12) if Q82==1 & Q85==3 & ilo_job1_ste_aggregate==1
				
				replace ilo_job1_lri_ees = Q83 if Q82==2  & Q85==4 & ilo_job1_ste_aggregate==1
				replace ilo_job1_lri_ees = (Q83*365/12) if Q82==2  & Q85==1 & ilo_job1_ste_aggregate==1
				replace ilo_job1_lri_ees = (Q83*52/12) if Q82==2  & Q85==2 & ilo_job1_ste_aggregate==1
				replace ilo_job1_lri_ees = (Q83*26/12) if Q82==2  & Q85==3 & ilo_job1_ste_aggregate==1		
						
				replace ilo_job1_lri_ees = Q83+Q84Tot if Q82==3 & Q85==4 & ilo_job1_ste_aggregate==1
				replace ilo_job1_lri_ees = ((Q83*365/12)+(Q84Tot*365/12)) if Q82==3 & Q85==1 & ilo_job1_ste_aggregate==1
				replace ilo_job1_lri_ees = ((Q83*52/12)+(Q84Tot*52/12)) if Q82==3 & Q85==2 & ilo_job1_ste_aggregate==1
				replace ilo_job1_lri_ees = ((Q83*26/12)+(Q84Tot*26/12)) if Q82==3 & Q85==3 & ilo_job1_ste_aggregate==1
						
						lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"
		
			* Self-employed:
		
			gen ilo_job1_lri_slf =.
				replace ilo_job1_lri_slf = ((Q90/Q91)-Q93) if ilo_job1_ste_aggregate==2
						lab var ilo_job1_lri_slf "Monthly labour related income of self-employed in main job"	
	
		
		         
***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_joball_tru') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			

	* Comment: legal time of work is 44 hours per week
		gen ilo_joball_tru=.
			replace ilo_joball_tru=1 if (ilo_lfs==1 & q104==1 & q105==1 & ilo_joball_how_usual <44)
				lab var ilo_joball_tru "Time-related underemployed"
		

* -------------------------------------------------------------------------------------------
*			Occupational injury ('ilo_joball_inj') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
	
		gen ilo_joball_oi_case=.
			replace ilo_joball_oi_case=q131 if (q128==1 & q129==1 & ilo_lfs==1)
				label var ilo_joball_oi_case "Cases of non-fatal occupational injury"
	
* -------------------------------------------------------------------------------------------
*			Days lost due to cases of occupational injury (ilo_joball_oi_day) [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
		
		gen ilo_joball_oi_day=.
			replace ilo_joball_oi_day=q138 if (q128==1 & q129==1 & ilo_lfs==1)
				label var ilo_joball_oi_day "Days lost due to cases of occupational injury"
	
	
***********************************************************************************************
*			PART 3.3. UNEMPLOYMENT: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Category of unemployment ('ilo_cat_une') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

		* No information
				

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: ilo_dur_details isn't possible because time intervals used in Q116 are different from the framework
				
	
			gen ilo_dur_aggregate=.
				replace ilo_dur_aggregate=1 if inrange(q116,1,2)& ilo_lfs==2
				replace ilo_dur_aggregate=2 if q116==3 & ilo_lfs==2
				replace ilo_dur_aggregate=3 if inrange(q116,4,6) & ilo_lfs==2
				replace ilo_dur_aggregate=4 if q116==7 & ilo_lfs==2
					lab def ilo_unemps_aggr 1 "Less than 6 months" 2 "6 months to less than 12 months" 3 "12 months or more" 4 "Not elsewhere classified"
					lab val ilo_dur_aggregate ilo_unemps_aggr
					lab var ilo_dur_aggregate "Duration of unemployment (Aggregate)"
		

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
	* No information
	
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
	* No information on the previous occupation in the dataset
	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			General social protection ('ilo_gsp_unschemes') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
	* No information on this topic in the dataset
	
	

***********************************************************************************************
*			PART 3.3. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

	gen ilo_olf_dlma=.
		replace ilo_olf_dlma = 1 if (q111==1 & q117==2 & ilo_lfs==3) 			// Seeking, not available
		replace ilo_olf_dlma = 2 if (q111==2 & q117==1 & ilo_lfs==3)			// Not seeking, available
		replace ilo_olf_dlma = 3 if (q111==2 & q114==1 & q117==2 & ilo_lfs==3)	// Not seeking, not available, willing
		replace ilo_olf_dlma = 4 if (q111==2 & q114==2 & q117==2 & ilo_lfs==3)	// Not seeking, not available, not willing
		replace ilo_olf_dlma = 5 if	(ilo_olf_dlma==. & ilo_lfs==3)				// Not classified 
	
			lab def dlma_lab 1 "1 - Seeking, not available (Unavailable jobseekers)" 2 "2 - Not seeking, available (Available potential jobseekers)" ///
							 3 "3 - Not seeking, not available, willing (Willing non-jobseekers)" 4 "4 - Not seeking, not available, not willing" 5 "X - Not elsewhere classified"
			lab val ilo_olf_dlma dlma_lab 
			lab var ilo_olf_dlma "Labour market attachment (Degree of)"


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reason for not seeking job ('ilo_olf_reason') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		


	gen ilo_olf_reason=.
		replace ilo_olf_reason=1 if	(inlist(q115,2,3,7,8,10,11) & ilo_lfs==3)		// Labour market
		replace ilo_olf_reason=2 if	(inlist(q115,4,5,6) & ilo_lfs==3)				// Personal/Family-related
		replace ilo_olf_reason=3 if (q114==2 & ilo_lfs==3)							// Does not need/want to work
		replace ilo_olf_reason=4 if (q115==99 & ilo_lfs==3)							// Not elsewhere classified
		replace ilo_olf_reason=4 if (ilo_olf_reason==. & ilo_lfs==3)				// Not elsewhere classified
			lab def reasons_lab 1 "1 - Labour market" 2 "2 - Personal / Family-related" ///
							   3 "3 - Does not need/want to work" 4 "4 - Not elsewhere classified"
			lab val ilo_olf_reason reasons_lab 
			lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"
			

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Main activity status ('ilo_olf_activity') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

	* No information to compute this variable
	
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seeker ('ilo_dis')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

	gen ilo_dis=1 if (ilo_lfs==3 & q117==1 & ilo_olf_reason==1)
			lab def dis_lab 1 "Discouraged job-seekers"
			lab val ilo_dis dis_lab
			lab var ilo_dis "Discouraged job-seekers"

			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training ('ilo_neet')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

	gen ilo_neet=1 if (ilo_age_aggregate==2 & ilo_lfs!=1 & ilo_edu_attendance==2)
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


* 1 - Full dataset with original variables and ILO ones
	
	cd "$outpath"
	
	drop if lab==1 /* in order to get rid of observations from tempfile */
	
	* drop ilo_age /* as only age bands being kept and this variable used as help variable */
		
	drop indu_code_* occ_code_*  /*prev*_cod */ lab isco08_2digits isco88_2digits isco08 isco88 isic4_2digits isic4 isic3_2digits isic3

		
	* Save dataset including original and ilo variables
	
		saveold ${country}_${source}_${time}_FULL, version(12) replace	


* 2 - Dataset with only 'ILO' variables
	
		keep ilo*

		saveold ${country}_${source}_${time}_ILO, version(12) replace

		
