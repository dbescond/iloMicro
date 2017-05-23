* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Mongolia, 2013
* DATASET USED: Mongolia LFS 2013
* NOTES: 
* Files created: Standard variables on LFS Mongolia 2013 
* Authors: Marylène Escher
* Who last updated the file: Mabelin Villarreal Fuentes
* Starting Date: 1st November 2016
* Last updated: 28th April 2017
***********************************************************************************************

***********************************************************************************************
***********************************************************************************************

* 			1. SET UP WORK DIRECTORY, FILE NAME, VARIABLES AND FUNCTIONS

***********************************************************************************************
***********************************************************************************************

clear all 

set more off
*set more off, permanently

global path "J:\COMMON\STATISTICS\DPAU\MICRO"
global country "MNG"
global source "LFS"
global time "2013"
global inputFile "16. LFS 2013_eng.dta"
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
*			Time period ('ilo_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_time=1
		lab def lab_time 1 "$time"
		lab val ilo_time lab_time
		lab var ilo_time "Time (Gregorian Calendar)"
		
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
	
*-- generates variable "to_drop" that will be split in two parts: annual part (to_drop_1) and quarterly part (to_drop_2)
   decode ilo_time, gen(to_drop)
   split to_drop, generate(to_drop_) parse(Q)
   destring to_drop_1, replace force

*-- generation of to_drop_2 that contains information on the quarter (if it is quarterly) or -9999 if its annual
   capture destring to_drop_2, replace force
   capture gen to_drop_2=-9999

*-- creating local variables for year and quarter   
   local A "year_"
   gen `A'= to_drop_1
   
   local Q "quarter_"
   gen `Q'= to_drop_2
      
   
*-- annual case
gen ilo_wgt=.

if `Q' == -9999{
    if `A'== 2013 {
        replace ilo_wgt=weighty
	}
    else{
        replace ilo_wgt=weight
    }
    lab var ilo_wgt "Sample weight"
}

*-- quarters        

else{
    replace ilo_wgt = weightq
    lab var ilo_wgt "Sample weight"	
	keep if quarter==`Q'
}


		
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

/* Urban: captal city, aimag center
   Rural: Soum center, rural				*/
   

	gen ilo_geo=.
		replace ilo_geo=1 if inrange(location,1,2)
		replace ilo_geo=2 if inrange(location,3,4)
			lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural"
			lab val ilo_geo ilo_geo_lab
			lab var ilo_geo "Geographical coverage"	
	
	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------


	gen ilo_sex=i3
		lab def ilo_sex_lab 1 "1 - Male" 2 "2 - Female"
		lab var ilo_sex "Sex"
		lab val ilo_sex ilo_sex_lab


		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------


	gen ilo_age=i5
		lab var ilo_age "Age"
		
	
	
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
			lab def age_by5_lab 1 "0-4" 2 "5-9" 3 "10-14" 4 "15-19" 5 "20-24" 6 "25-29" 7 "30-34" 8 "35-39" ///
								9 "40-44" 10 "45-49" 11 "50-54" 12 "55-59" 13 "60-64" 14 "65+"
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
		
/* ISCED 11 mapping: variable very closed to ISCED 11, use as well UNESCO mapping
					http://www.uis.unesco.org/Education/ISCEDMappings/Pages/default.aspx
					http://www.uis.unesco.org/Education/Documents/isced-2011-en.pdf 			
					
					
	NOTE: * The question is only asked to people aged 15 and more. So people below the age of 15 
	        are under "Not elsewhere classified".   */
		 
		 
		 

	gen ilo_edu_isced11=.
		replace ilo_edu_isced11=1 if ii18==1  				// No schooling
		*replace ilo_edu_isced11=2 if						// Early childhood education
		replace ilo_edu_isced11=3 if ii18==2				// Primary education
		replace ilo_edu_isced11=4 if ii18==3				// Lower secondary education
		replace ilo_edu_isced11=5 if inlist(ii18,4,5) 	 	// Upper secondary education
		replace ilo_edu_isced11=6 if ii18==6	 			// Post-secondary non-tertiary education
		*replace ilo_edu_isced11=7 if 						// Short-cycle tertiary education
		replace ilo_edu_isced11=8 if ii18==7  				// Bachelor or equivalent
		replace ilo_edu_isced11=9 if ii18==8 				// Master's or equivalent level
		replace ilo_edu_isced11=10 if ii18==9 				// Doctoral or equivalent level
		replace ilo_edu_isced11=11 if ii18==.				// Not elsewhere classified
			label def isced_11_lab 1 "X - No schooling" 2 "0 - Early childhood education" 3 "1 - Primary education" 4 "2 - Lower secondary education" ///
							5 "3 - Upper secondary education" 6 "4 - Post-secondary non-tertiary education" 7 "5 - Short-cycle tertiary education" ///
							8 "6 - Bachelor's or equivalent level" 9 "7 - Master's or equivalent level" 10 "8 - Doctoral or equivalent level" 11 "9 - Not elsewhere classified"
			label val ilo_edu_isced11 isced_11_lab
			lab var ilo_edu_isced11 "Level of education (ISCED 11)"
			
		
		
	gen ilo_edu_aggregate=.
		replace ilo_edu_aggregate=1 if inlist(ilo_edu_isced11,1,2)  	// Less than basic
		replace ilo_edu_aggregate=2 if inlist(ilo_edu_isced11,3,4)		// Basic
		replace ilo_edu_aggregate=3 if inlist(ilo_edu_isced11,5,6)		// Intermediate
		replace ilo_edu_aggregate=4 if inrange(ilo_edu_isced11,7,10)	// Advanced
		replace ilo_edu_aggregate=5 if ilo_edu_isced11==11				// Level not stated
			label def edu_aggr_lab 1 "Less than basic" 2 "Basic" 3 "Intermediate" 4 "Advanced" 5 "Level not stated"
			label val ilo_edu_aggregate edu_aggr_lab
			label var ilo_edu_aggregate "Level of education (Aggregate)"
				
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education attendance ('ilo_edu_attendance')  	[done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

			
/* NOTE: The question is only asked to people aged 15 and more. So people below the age of 15 
        are under "Not elsewhere classified".   */
	

	gen ilo_edu_attendance=.
		replace ilo_edu_attendance=1 if ii16==1					// Attending 
		replace ilo_edu_attendance=2 if inlist(ii16,2,3,4)		// Not attending 
		replace ilo_edu_attendance=3 if ii16==.					// Not elsewhere classified 
			label def edu_att_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified" 
			label val ilo_edu_attendance edu_att_lab
			label var ilo_edu_attendance "Education (Attendance)"

	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Disability status ('ilo_dsb') 	[done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

	* As we do not know the level of disability, only the aggregated variable can be done.
		
		
		gen ilo_dsb_aggregate=.
			replace ilo_dsb_aggregate=1 if i6==2	 // Without disablitity
			replace ilo_dsb_aggregate=2 if i6==1	 // With disability
				label def dsb_lab 1 "Persons without disability" 2 "Persons with disability" 
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
          
* Comment: wap = 15+ 

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
	
	/* Future starters cannot be identified so unemployment only includes people not working,
	   looking for work and available to start a job. 	
	   
	   Unemployment is different from the rate published on ILOSTAT because Mongolia only
	   uses 2 criteria: not in employment and seeking for work. They do not condition on availability. */
	   
gen ilo_lfs=.
    replace ilo_lfs=1 if iii39>=1 & iii39!=. & ilo_wap==1 				        // Employed
	replace ilo_lfs=1 if iii40==1 &	ilo_wap==1		 					        // Employed
	replace ilo_lfs=2 if ilo_lfs!=1 & (v91==1 & v93==1) & ilo_wap==1  	        // Unemployed (one more variable added from 2013)
	replace ilo_lfs=3 if ilo_lfs!=1 & ilo_lfs!=2 & ilo_wap==1  			        // Outside the labour force
		label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside the Labour Force"
		label value ilo_lfs label_ilo_lfs
		label var ilo_lfs "Labour Force Status"



			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------


	gen ilo_mjh=.
		replace ilo_mjh=1 if iii66==2 & ilo_lfs==1
		replace ilo_mjh=1 if iii67==2 & ilo_lfs==1
		replace ilo_mjh=2 if iii66==1 & ilo_lfs==1
		replace ilo_mjh=2 if iii67==1 & ilo_lfs==1
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

/* NOTE: Question 46 asks the status in employment. One of the answers is "Employed in animal husbandry", 
		 which does not clearly specify the status in employment. As the country classifies them under 
		 own-account workers, we do the same. 		*/ 
  


	* MAIN JOB:
	
		* Detailled categories:
			gen ilo_job1_ste_icse93=.
				replace ilo_job1_ste_icse93=1 if iii46 ==1				// Employees
				replace ilo_job1_ste_icse93=2 if iii46 ==2				// Employers
				replace ilo_job1_ste_icse93=3 if inlist(iii46,3,5)		// Own-account workers
				replace ilo_job1_ste_icse93=4 if iii46 ==4				// Producer cooperatives
				replace ilo_job1_ste_icse93=5 if iii46 ==6				// Contributing family workers
				replace ilo_job1_ste_icse93=6 if iii46 ==7 | iii46 ==.	// Not classifiable
				replace ilo_job1_ste_icse93=. if ilo_lfs!=1
					label def label_ilo_ste_icse93 1 "1 - Employees" 2 "2 - Employers" 3 "3 - Own-account workers"  ///
													4 "4 - Members of producers cooperatives" 5 "5 - Contributing family workers" ///
													6 "6 - Workers not classifiable by status"
					label val ilo_job1_ste_icse93 label_ilo_ste_icse93
					label var ilo_job1_ste_icse93 "Status in employment (ICSE 93) - main job"
			
			
	
		* Aggregate categories 
			gen ilo_job1_ste_aggregate=.
				replace ilo_job1_ste_aggregate=1 if ilo_job1_ste_icse93==1				// Employees
				replace ilo_job1_ste_aggregate=2 if inrange(ilo_job1_ste_icse93,2,5)	// Self-employed
				replace ilo_job1_ste_aggregate=3 if ilo_job1_ste_icse93==6				// Not elsewhere classified
					lab def ste_aggr_lab 1 "1 - Employees" 2 "2 - Self-employed" 3 "3 - Not elsewhere classified"
					lab val ilo_job1_ste_aggregate ste_aggr_lab
					label var ilo_job1_ste_aggregate "Status in employment (Aggregate) - main job" 

		
		
					
	* SECOND JOB:
	
		* Detailled categories:
			gen ilo_job2_ste_icse93=.
				replace ilo_job2_ste_icse93=1 if iii71==1				// Employees
				replace ilo_job2_ste_icse93=2 if iii71==2				// Employers
				replace ilo_job2_ste_icse93=3 if inlist(iii71,3,5)		// Own-account workers
				replace ilo_job2_ste_icse93=4 if iii71==4				// Producer cooperatives
				replace ilo_job2_ste_icse93=5 if iii71==6				// Contributing family workers
				replace ilo_job2_ste_icse93=6 if iii71==7 | iii71==.	// Not classifiable
				replace ilo_job2_ste_icse93=. if ilo_mjh!=2
					label val ilo_job2_ste_icse93 label_ilo_ste_icse93
					label var ilo_job2_ste_icse93 "Status in employment (ICSE 93) - second job"
			
			
	
		* Aggregate categories 
			gen ilo_job2_ste_aggregate=.
				replace ilo_job2_ste_aggregate=1 if ilo_job2_ste_icse93==1				// Employees
				replace ilo_job2_ste_aggregate=2 if inrange(ilo_job2_ste_icse93,2,5)	// Self-employed
				replace ilo_job2_ste_aggregate=3 if ilo_job2_ste_icse93==6				// Not elsewhere classified
					lab val ilo_job2_ste_aggregate ste_aggr_lab
					label var ilo_job2_ste_aggregate "Status in employment (Aggregate) - second job" 


				
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------



	/* The question is not asked to people having the status in employment "employed in animal husbandry", 
	   but it seems clear that these workers belongs to the category 01 (Crop and animal production, 
	   hunting and related service activities) of ISIC Rev. 4 (2-digits), so 
	   they are recoded this way.  */
		
		
			append using `labels', gen (lab)
			*use value label from this variable, afterwards drop everything related to this append
			
			
				* MAIN JOB:
					
					* ISIC Rev. 4 - 2 digit
						gen isic2dig = int(iii48/100)
							replace isic2dig=. if isic2dig==0
							replace isic2dig=1 if iii46==5
						
						gen ilo_job1_eco_isic4_2digits=isic2dig if ilo_lfs==1
							lab values ilo_job1_eco_isic4_2digits isic4_2digits
							lab var ilo_job1_eco_isic4_2digits "Economic activity (ISIC Rev. 4), 2 digit level - main job"
							
					* ISIC Rev. 4 - 1 digit
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
							replace ilo_job1_eco_isic4=22 if ilo_job1_eco_isic4_2digits==.
							replace ilo_job1_eco_isic4=. if ilo_lfs!=1
								lab val ilo_job1_eco_isic4 isic4
								lab var ilo_job1_eco_isic4 "Economic activity (ISIC Rev. 4) - main job"

							
							
					* Aggregated level 
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
								lab var ilo_job1_eco_aggregate "Economic activity (Aggregate) - main job"
		
		
		
		
		* SECOND JOB:
		
			* ISIC Rev. 4 - 2 digit
						gen isic2dig_job2 = int(iii73/100)
							replace isic2dig_job2=. if isic2dig_job2==0
						
						gen ilo_job2_eco_isic4_2digits=isic2dig_job2 if ilo_mjh==2
							lab values ilo_job2_eco_isic4_2digits isic4_2digits
							lab var ilo_job2_eco_isic4_2digits "Economic activity (ISIC Rev. 4), 2 digit level - second job"
							
			
			* ISIC Rev. 4 - 1 digit
						gen ilo_job2_eco_isic4=.
							replace ilo_job2_eco_isic4=1 if inrange(ilo_job2_eco_isic4_2digits,1,3)
							replace ilo_job2_eco_isic4=2 if inrange(ilo_job2_eco_isic4_2digits,5,9)
							replace ilo_job2_eco_isic4=3 if inrange(ilo_job2_eco_isic4_2digits,10,33)
							replace ilo_job2_eco_isic4=4 if ilo_job2_eco_isic4_2digits==35
							replace ilo_job2_eco_isic4=5 if inrange(ilo_job2_eco_isic4_2digits,36,39)
							replace ilo_job2_eco_isic4=6 if inrange(ilo_job2_eco_isic4_2digits,41,43)
							replace ilo_job2_eco_isic4=7 if inrange(ilo_job2_eco_isic4_2digits,45,47)
							replace ilo_job2_eco_isic4=8 if inrange(ilo_job2_eco_isic4_2digits,49,53)
							replace ilo_job2_eco_isic4=9 if inrange(ilo_job2_eco_isic4_2digits,55,56)
							replace ilo_job2_eco_isic4=10 if inrange(ilo_job2_eco_isic4_2digits,58,63)
							replace ilo_job2_eco_isic4=11 if inrange(ilo_job2_eco_isic4_2digits,64,66)
							replace ilo_job2_eco_isic4=12 if ilo_job2_eco_isic4_2digits==68
							replace ilo_job2_eco_isic4=13 if inrange(ilo_job2_eco_isic4_2digits,69,75)
							replace ilo_job2_eco_isic4=14 if inrange(ilo_job2_eco_isic4_2digits,77,82)
							replace ilo_job2_eco_isic4=15 if ilo_job2_eco_isic4_2digits==84
							replace ilo_job2_eco_isic4=16 if ilo_job2_eco_isic4_2digits==85
							replace ilo_job2_eco_isic4=17 if inrange(ilo_job2_eco_isic4_2digits,86,88)
							replace ilo_job2_eco_isic4=18 if inrange(ilo_job2_eco_isic4_2digits,90,93)
							replace ilo_job2_eco_isic4=19 if inrange(ilo_job2_eco_isic4_2digits,94,96)
							replace ilo_job2_eco_isic4=20 if inrange(ilo_job2_eco_isic4_2digits,97,98)
							replace ilo_job2_eco_isic4=21 if ilo_job2_eco_isic4_2digits==99
							replace ilo_job2_eco_isic4=22 if ilo_job2_eco_isic4_2digits==.
							replace ilo_job2_eco_isic4=. if ilo_mjh!=2
								lab val ilo_job2_eco_isic4 isic4
								lab var ilo_job2_eco_isic4 "Economic activity (ISIC Rev. 4) - second job"

							
							
					* Aggregated level 
						gen ilo_job2_eco_aggregate=.
							replace ilo_job2_eco_aggregate=1 if ilo_job2_eco_isic4==1
							replace ilo_job2_eco_aggregate=2 if ilo_job2_eco_isic4==3
							replace ilo_job2_eco_aggregate=3 if ilo_job2_eco_isic4==6
							replace ilo_job2_eco_aggregate=4 if inlist(ilo_job2_eco_isic4,2,4,5)
							replace ilo_job2_eco_aggregate=5 if inrange(ilo_job2_eco_isic4,7,14)
							replace ilo_job2_eco_aggregate=6 if inrange(ilo_job2_eco_isic4,15,21)
							replace ilo_job2_eco_aggregate=7 if ilo_job2_eco_isic4==22		
								lab val ilo_job2_eco_aggregate eco_aggr_lab
								lab var ilo_job2_eco_aggregate "Economic activity (Aggregate) - second job"
		
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_job1_ocu_isco88') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
	
	/* Occupations can be mapped to ISCO 08.  		*/
	   
 
	* MAIN JOB:
	
			gen occup_2dig=int(iii41/100) if ilo_lfs==1 
	
		* ISCO 08 - 2 digits:
			gen ilo_job1_ocu_isco08_2digits=occup_2dig if ilo_lfs==1
				replace ilo_job1_ocu_isco08_2digits=. if occup_2dig==10
							lab values ilo_job1_ocu_isco08_2digits isco08_2digits
							lab var ilo_job1_ocu_isco08_2digits "Occupation (ISCO-08), 2 digit level"
	
	
		* ISCO 08 - 1 digit:
			gen occup_1dig=int(ilo_job1_ocu_isco08_2digits/10) if ilo_lfs==1
		
			gen ilo_job1_ocu_isco08=occup_1dig if ilo_lfs==1
				replace ilo_job1_ocu_isco08=10 if occup_1dig==0 & ilo_lfs==1
				replace ilo_job1_ocu_isco08=11 if occup_1dig==. & ilo_lfs==1
							lab values ilo_job1_ocu_isco08 isco08
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
				replace ilo_job1_ocu_aggregate=. if ilo_lfs!=1
					lab def ocu_aggr_lab 1 "Managers, professionals, and technicians" 2 "Clerical, service and sales workers" 3 "Skilled agricultural and trades workers" ///
										4 "Plant and machine operators, and assemblers" 5 "Elementary occupations" 6 "Armed forces" 7 "Not elsewhere classified"
					lab val ilo_job1_ocu_aggregate ocu_aggr_lab
					lab var ilo_job1_ocu_aggregate "Occupation (Aggregate) - Main job"	
					
		* Skill level
		    gen ilo_job1_ocu_skill=.
			    replace ilo_job1_ocu_skill=1 if ilo_job1_ocu_isco08==9                   // Low
				replace ilo_job1_ocu_skill=2 if inlist(ilo_job1_ocu_isco08,4,5,6,7,8)    // Medium
				replace ilo_job1_ocu_skill=3 if inlist(ilo_job1_ocu_isco08,1,2,3)        // High
				replace ilo_job1_ocu_skill=4 if inlist(ilo_job1_ocu_isco08,10,11)        // Not elsewhere classified
					lab def ocu_skill_lab 1 "1 - Skill level 1 (low)" 2 "2 - Skill level 2 (medium)" 3 "3 - Skill levels 3 and 4 (high)" 4 "4 - Not elsewhere classified"
				    lab val ilo_job1_ocu_skill ocu_skill_lab
				    lab var ilo_job1_ocu_skill "Occupation (Skill level)"						
	
	
	* SECOND JOB:
	
			gen occup_2dig_job2=int(iii68/100) if ilo_mjh==2 
	
	
		* ISCO 08 - 2 digits:
			gen ilo_job2_ocu_isco08_2digits=occup_2dig_job2 if ilo_mjh==2
							lab values ilo_job2_ocu_isco08_2digits isco08_2digits
							lab var ilo_job2_ocu_isco08_2digits "Occupation (ISCO-08), 2 digit level - second job"
	
	
	
		* ISCO 08 - 1 digit:
			gen occup_1dig_job2=int(ilo_job2_ocu_isco08_2digits/10) if ilo_mjh==2
		
			gen ilo_job2_ocu_isco08=occup_1dig_job2 if ilo_mjh==2
				replace ilo_job2_ocu_isco08=11 if occup_1dig_job2==. & ilo_mjh==2
							lab values ilo_job2_ocu_isco08 isco08
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
				replace ilo_job2_ocu_aggregate=. if ilo_mjh!=2
					lab val ilo_job2_ocu_aggregate ocu_aggr_lab
					lab var ilo_job2_ocu_aggregate "Occupation (Aggregate) - second job"	
					
		* Skill level
		    gen ilo_job2_ocu_skill=.
			    replace ilo_job2_ocu_skill=1 if ilo_job2_ocu_isco08==9                   // Low
				replace ilo_job2_ocu_skill=2 if inlist(ilo_job2_ocu_isco08,4,5,6,7,8)    // Medium
				replace ilo_job2_ocu_skill=3 if inlist(ilo_job2_ocu_isco08,1,2,3)        // High
				replace ilo_job2_ocu_skill=4 if inlist(ilo_job2_ocu_isco08,10,11)        // Not elsewhere classified
				    * value label already defined for the main job
					lab val ilo_job2_ocu_skill ocu_skill_lab
				    lab var ilo_job2_ocu_skill "Occupation (Skill level) in secondary job"									
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector ('ilo_job1_ins_sector') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
	
	/* Question 49 asking for the legal status is not asked to people having the status in employment 
	   "employed in husbandry" but it seems clear that these workers belongs to the private sector.
	
	   Public: state owned entrerprises, local government owned enterprises, budget organization
	   Private: non-governmental organization, private sector/ personnel 
				entity, individuality/person		 */
	
	
	* MAIN JOB:
	
		gen ilo_job1_ins_sector=.
			replace ilo_job1_ins_sector=1 if inlist(iii49,40,41,60) & ilo_lfs==1		// Public
			replace ilo_job1_ins_sector=2 if ilo_job1_ins_sector!=1 & ilo_lfs==1		// Private
				lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private" 
				lab values ilo_job1_ins_sector ins_sector_lab
				lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities - main job"
	
	
	
	* SECOND JOB:
	
		gen ilo_job2_ins_sector=.
			replace ilo_job2_ins_sector=1 if inlist(iii74,40,41,60)& ilo_mjh==2			// Public
			replace ilo_job2_ins_sector=2 if ilo_job2_ins_sector!=1 & ilo_mjh==2		// Private
				lab values ilo_job2_ins_sector ins_sector_lab
				lab var ilo_job2_ins_sector "Institutional sector (private/public) of economic activities - second job"
	

	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Hours of work ('ilo_how') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
		
	/* Here is the information we have in the questionnaire:
			- Question 39: actual hours worked in all jobs 
			- Question 42: usual hours worked in main job
			- Question 69: actual hours worked in second job			*/
		
		
		* MAIN JOB:
			
			* 1) Weekly hours ACTUALLY worked:
			
					* Not available
			
	
		
			* 2) Weekly hours USUALLY worked:
		
				gen ilo_job1_how_usual=iii42 if ilo_lfs==1
						lab var ilo_job1_how_usual "Weekly hours usually worked in main job"
		
		
		
		
		* SECOND JOB
			
			* 1) Weekly hours ACTUALLY worked:
				
				gen ilo_job2_how_actual=iii69 if ilo_mjh==2
						lab var ilo_job2_how_actual "Weekly hours actually worked in second job"
				
		
				gen ilo_job2_how_actual_bands=.
					replace ilo_job2_how_actual_bands=1 if ilo_job2_how_actual==0
					replace ilo_job2_how_actual_bands=2 if ilo_job2_how_actual>=1 & ilo_job2_how_actual<=14
					replace ilo_job2_how_actual_bands=3 if ilo_job2_how_actual>=15 & ilo_job2_how_actual<=29
					replace ilo_job2_how_actual_bands=4 if ilo_job2_how_actual>=30 & ilo_job2_how_actual<=34
					replace ilo_job2_how_actual_bands=5 if ilo_job2_how_actual>=35 & ilo_job2_how_actual<=39
					replace ilo_job2_how_actual_bands=6 if ilo_job2_how_actual>=40 & ilo_job2_how_actual<=48
					replace ilo_job2_how_actual_bands=7 if ilo_job2_how_actual>=49 & ilo_job2_how_actual!=.
					replace ilo_job2_how_actual_bands=8 if ilo_job2_how_actual==. & ilo_mjh==2
						lab def how_bands_lab 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"
						lab val ilo_job2_how_actual_bands how_bands_lab
						lab var ilo_job2_how_actual_bands "Weekly hours actually worked bands in second job"
		
		
			* 2) Weekly hours USUALLY worked:
					
					* Not available
			
			
			
		
		* ALL JOBS:
		
			* 1) Weekly hours ACTUALLY worked:
				gen ilo_joball_how_actual=iii39 if ilo_lfs==1
						lab var ilo_joball_how_actual "Weekly hours actually worked in all jobs"
						
		
				gen ilo_joball_how_actual_bands=.
					replace ilo_joball_how_actual_bands=1 if ilo_joball_how_actual==0
					replace ilo_joball_how_actual_bands=2 if ilo_joball_how_actual>=1 & ilo_joball_how_actual<=14
					replace ilo_joball_how_actual_bands=3 if ilo_joball_how_actual>=15 & ilo_joball_how_actual<=29
					replace ilo_joball_how_actual_bands=4 if ilo_joball_how_actual>=30 & ilo_joball_how_actual<=34
					replace ilo_joball_how_actual_bands=5 if ilo_joball_how_actual>=35 & ilo_joball_how_actual<=39
					replace ilo_joball_how_actual_bands=6 if ilo_joball_how_actual>=40 & ilo_joball_how_actual<=48
					replace ilo_joball_how_actual_bands=7 if ilo_joball_how_actual>=49 & ilo_joball_how_actual!=.
					replace ilo_joball_how_actual_bands=8 if ilo_joball_how_actual_bands==. & ilo_lfs==1
						lab val ilo_joball_how_actual_bands how_bands_lab
						lab var ilo_joball_how_actual_bands "Weekly hours actually worked bands in all jobs"
					
						
			* 2) Weekly hours USUALLY worked:
			
					* Not available
				
	
	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job1_job_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
		
		
	/* It seems that the normal number of weekly hours is 40. This value is used as a threshold
	   to determine part and full time employment (as there is no direct question). 	*/
	   
	   
	   gen ilo_job1_job_time=.
				replace ilo_job1_job_time=1 if ilo_job1_how_usual<40 
				replace ilo_job1_job_time=2 if ilo_job1_how_usual>=40 & ilo_job1_how_usual!=.
				replace ilo_job1_job_time=3 if ilo_job1_job_time!=1 & ilo_job1_job_time!=2 & ilo_lfs==1
					lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
					lab val ilo_job1_job_time job_time_lab
					lab var ilo_job1_job_time "Job (Working time arrangement) - Main job"	
			

		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job1_job_contract') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
		
		* Not available	
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Formal / Informal Economy ('ilo_job1_ife_prod' 'ilo_job1_ife_nature') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
	
	/* Questions used: * Social security coverage: a person is considered covered by social security if he/she says yes to questions iii65a (social insurance) or iii65f (contribution for pension) 
	                   * Institutional sector: iii49
	                   * Destination of production: iii55
	                   * Bookkeeping: iii52
					   * Registraiton: iii56
					   * Status in employment: ilo_job1_ste_icse93
					   * Place of work: iii47
					   * Size of the company: iii58 (regular employees)
					   * Paid annual leave: iii65g
					   * Paid sick leave: Not asked
    	
	NOTE: * Questions on bookeeping and registrations are only asked to "employers who are not able to determine their income in time". 	*/
	
* 1) UNIT OF PRODUCTION: FORMAL/INFORMAL SECTOR
	* Social security
	
		gen social_security=.
			replace social_security=1 if (iii65a==1 | iii65f==1) & ilo_lfs==1   // Social insurance or Contribution for pension
			replace social_security=2 if (iii65a==2 & iii65f==2) & ilo_lfs==1   // Not social insurance and no contribution for pension
			replace social_security=3 if social_security==. & ilo_lfs==1        // Not answered
			
    * Formal/informal sector
		gen ilo_job1_ife_prod=.
		    replace ilo_job1_ife_prod=3 if ilo_lfs==1 & ///
			                               ((ilo_job1_eco_isic4_2digits==97) | ///
										   (inlist(iii49,80,99,.) & iii55==3))
			replace ilo_job1_ife_prod=2 if ilo_job1_ife_prod==. & ilo_lfs==1 & ///
			                               ((inlist(iii49,40,41,60,70)) | ///
			                               (inlist(iii49,80,99,.) & iii55!=3 & iii52==1) | ///
			                               (inlist(iii49,80,99,.) & iii55!=3 & iii52!=1 & iii56==1) | /// 
										   (inlist(iii49,80,99,.) & iii55!=3 & iii52!=1 & inlist(iii56,4,.) & ilo_job1_ste_icse93==1 & social_security==1) | /// 
										   (inlist(iii49,80,99,.) & iii55!=3 & iii52!=1 & inlist(iii56,4,.) & ilo_job1_ste_icse93==1 & social_security!=1 & inlist(iii47,2,5,6,7,8,12) & inrange(iii58,6,12)) | /// 
										   (inlist(iii49,80,99,.) & iii55!=3 & iii52!=1 & inlist(iii56,4,.) & ilo_job1_ste_icse93!=1 & inlist(iii47,2,5,6,7,8,12) & inrange(iii58,6,12)))
			replace ilo_job1_ife_prod=1 if ilo_job1_ife_prod==. & ilo_lfs==1 & ///
			                               ((inlist(iii49,80,99,.) & iii55!=3 & iii52!=1 & inlist(iii56,2,3)) | /// 
			                               (inlist(iii49,80,99,.) & iii55!=3 & iii52!=1 & inlist(iii56,4,.) & ilo_job1_ste_icse93==1 & social_security!=1 & inlist(iii47,2,5,6,7,8,12) & inlist(iii58,1,2,3,4,5,.)) | /// 
										   (inlist(iii49,80,99,.) & iii55!=3 & iii52!=1 & inlist(iii56,4,.) & ilo_job1_ste_icse93==1 & social_security!=1 & inlist(iii47,0,1,3,4,9,10,11,13,14,15,16,17,.)) | ///
										   (inlist(iii49,80,99,.) & iii55!=3 & iii52!=1 & inlist(iii56,4,.) & ilo_job1_ste_icse93!=1 & inlist(iii47,0,1,3,4,9,10,11,13,14,15,16,17,.)) | ///
										   (inlist(iii49,80,99,.) & iii55!=3 & iii52!=1 & inlist(iii56,4,.) & ilo_job1_ste_icse93!=1 & inlist(iii47,2,5,6,7,8,12) & inlist(iii58,1,2,3,4,5,.)))
				        lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 
						lab val ilo_job1_ife_prod ilo_ife_prod_lab
						lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"
  

	* 2) NATURE OF JOB: FORMAL/INFORMAL EMPLOYMENT
	
			gen ilo_job1_ife_nature=.
                replace ilo_job1_ife_nature=2 if ilo_lfs==1 & ///
				                                 ((inlist(ilo_job1_ste_icse93,1,6) & social_security==1) | ///
												 (inlist(ilo_job1_ste_icse93,2,4) & ilo_job1_ife_prod==2) | ///
												 (ilo_job1_ste_icse93==3 & iii55!=3 & ilo_job1_ife_prod==2)) 
				replace ilo_job1_ife_nature=1 if ilo_lfs==1 & ///
				                                 ((inlist(ilo_job1_ste_icse93,1,6) & social_security!=1) | ///
												 (inlist(ilo_job1_ste_icse93,2,4) & ilo_job1_ife_prod!=2) | ///
												 (ilo_job1_ste_icse93==3 & iii55==3) | ///
												 (ilo_job1_ste_icse93==3 & iii55!=3 & ilo_job1_ife_prod!=2) | ///
												 (ilo_job1_ste_icse93==5))
						lab def ife_nature_lab 1 "1 - Persons with informal main job" 2 "2 - Persons with formal main job"
						lab val ilo_job1_ife_nature ife_nature_lab
						lab var ilo_job1_ife_nature "Informal / Formal Economy (Nature of job) - Main job"

	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Monthly labour related income ('ilo_job1_lri') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
				
	/* NOTES:
	   
	   The question related to income asks the employees how much they earned in the last 7 days.
	   This cannot be used to assess monthly income as the payment might not be regular every week. */
	   
	   
***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_joball_tru') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
		
/* 	  * Question 86 asks whether the person was available for more work during the last 7 days. When 
		looking at the possible reasons if the persons answers no, it seems that question 86 can 
		actually be used to determine both willingness and availability to work additional hours. 
	
	   * No national threshold  could be found, so the widely used threshold of 35 hour/week is used. 	 	*/
		 
	  	
				
				gen ilo_joball_tru=.
					replace ilo_joball_tru=1 if ilo_lfs==1 & iv86==1 & ilo_joball_how_actual<35
						lab def ilo_tru 1 "Time-related underemployed"
						lab val ilo_joball_tru ilo_tru
						lab var ilo_joball_tru "Time-related underemployed"			
					
			
				
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupational injury ('ilo_joball_inj') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
		
		* Not available
		
***********************************************************************************************
*			PART 3.3. UNEMPLOYMENT: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Category of unemployment ('ilo_cat_une') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	
	/* NOTE: information on previous activity is only asked to people aged  5-60 (so the persons 
			 older than 60 are under "Unknown".				*/ 

			 
		gen ilo_cat_une=.
			replace ilo_cat_une=1 if ilo_lfs==2 & vii120==1							// Previously employed
			replace ilo_cat_une=2 if ilo_lfs==2 & vii120==2							// Seeking first job
			replace ilo_cat_une=3 if ilo_lfs==2 & ilo_cat_une!=1 & ilo_cat_une!=2	//Unkown
				lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
				lab val ilo_cat_une cat_une_lab
				lab var ilo_cat_une "Category of unemployment"
	
	

	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	
	
/* 	   * Question 96 asks how long the unemployed have been AVAILABLE for work (in STATA it is written
	     "available/seeking work"). As there are no better options we use this question to approximate how
		 long the unemployed have been SEEKING for work.
	
	   * Due to the possibles answers, only the aggregated variable can be done			 
	   
	   * The category "Less than 6 months" includes as well the unemployed for 6 months. 		 */
		
	
		
		* Aggregate:
		
			gen ilo_dur_aggregate=.
				replace ilo_dur_aggregate=1 if inrange(v96,1,3) & ilo_lfs==2 	// Less than 6 months
				replace ilo_dur_aggregate=2 if v96==4 & ilo_lfs==2				// 6 months to less than 12 months
				replace ilo_dur_aggregate=3 if inlist(v96,5,6) & ilo_lfs==2		// 12 months or more
				replace ilo_dur_aggregate=4 if v96==. & ilo_lfs==2				// Not elsewhere classified
					lab def ilo_unemp_agr 1 "Less than 6 months" 2 "6 months to less than 12 months" ///
										  3 "12 months or more" 4 "Not elsewhere classified"
					lab values ilo_dur_aggregate ilo_unemp_agr
					lab var ilo_dur_aggregate "Duration of unemployment (Aggregate)"
		
		
		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

* Information on previous activity and occupation is asked but it's not readable in 2013 and 2015 (characters instead of codes).
* Thus, the variables on previous activity and previous occupation are only generated for 2014. 			
* NOTE: information on previous activity is only asked to people aged  5-60. -------- ******* Add as a value note



			* ISIC Rev. 4 - 2 digit
					gen indu_code_une_2dig=.
						replace indu_code_une_2dig=int(vii122/100) if ilo_lfs==2 & ilo_cat_une==1 
					
						gen ilo_preveco_isic4_2digits=.
							replace ilo_preveco_isic4_2digits=indu_code_une_2dig if ilo_lfs==2 & ilo_cat_une==1
			
			
							
			* ISIC Rev. 4 - 1 digit
						gen ilo_preveco_isic4=.
							replace ilo_preveco_isic4=1 if inrange(ilo_preveco_isic4_2digits,1,3)
							replace ilo_preveco_isic4=2 if inrange(ilo_preveco_isic4_2digits,5,9)
							replace ilo_preveco_isic4=3 if inrange(ilo_preveco_isic4_2digits,10,33)
							replace ilo_preveco_isic4=4 if ilo_preveco_isic4_2digits==35
							replace ilo_preveco_isic4=5 if inrange(ilo_preveco_isic4_2digits,36,39)
							replace ilo_preveco_isic4=6 if inrange(ilo_preveco_isic4_2digits,41,43)
							replace ilo_preveco_isic4=7 if inrange(ilo_preveco_isic4_2digits,45,47)
							replace ilo_preveco_isic4=8 if inrange(ilo_preveco_isic4_2digits,49,53)
							replace ilo_preveco_isic4=9 if inrange(ilo_preveco_isic4_2digits,55,56)
							replace ilo_preveco_isic4=10 if inrange(ilo_preveco_isic4_2digits,58,63)
							replace ilo_preveco_isic4=11 if inrange(ilo_preveco_isic4_2digits,64,66)
							replace ilo_preveco_isic4=12 if ilo_preveco_isic4_2digits==68
							replace ilo_preveco_isic4=13 if inrange(ilo_preveco_isic4_2digits,69,75)
							replace ilo_preveco_isic4=14 if inrange(ilo_preveco_isic4_2digits,77,82)
							replace ilo_preveco_isic4=15 if ilo_preveco_isic4_2digits==84
							replace ilo_preveco_isic4=16 if ilo_preveco_isic4_2digits==85
							replace ilo_preveco_isic4=17 if inrange(ilo_preveco_isic4_2digits,86,88)
							replace ilo_preveco_isic4=18 if inrange(ilo_preveco_isic4_2digits,90,93)
							replace ilo_preveco_isic4=19 if inrange(ilo_preveco_isic4_2digits,94,96)
							replace ilo_preveco_isic4=20 if inrange(ilo_preveco_isic4_2digits,97,98)
							replace ilo_preveco_isic4=21 if ilo_preveco_isic4_2digits==99
							replace ilo_preveco_isic4=22 if ilo_preveco_isic4==. & ilo_cat_une==1
								lab val ilo_preveco_isic4 isic4
								lab var ilo_preveco_isic4 "Previous economic activity (ISIC Rev. 4)"

							
							
			* Aggregated level 
						gen ilo_preveco_aggregate=.
							replace ilo_preveco_aggregate=1 if ilo_preveco_isic4==1
							replace ilo_preveco_aggregate=2 if ilo_preveco_isic4==3
							replace ilo_preveco_aggregate=3 if ilo_preveco_isic4==6
							replace ilo_preveco_aggregate=4 if inlist(ilo_preveco_isic4,2,4,5)
							replace ilo_preveco_aggregate=5 if inrange(ilo_preveco_isic4,7,14)
							replace ilo_preveco_aggregate=6 if inrange(ilo_preveco_isic4,15,21)
							replace ilo_preveco_aggregate=7 if ilo_preveco_isic4==22
								lab val ilo_preveco_aggregate eco_aggr_lab
								lab var ilo_preveco_aggregate "Previous economic activity (Aggregate)" 

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

* Information on previous activity and occupation is asked but it's not readable in 2013 and 2015 (characters instead of codes).
* Thus, the variables on previous activity and previous occupation are only generated for 2014. 

	* MAIN JOB:
        gen prev_occup_1dig=. 
			replace prev_occup_1dig=int(vii121/1000) if ilo_lfs==2 & ilo_cat_une==1
	

		* ISCO 08 - 1 digit:
			gen ilo_prevocu_isco08=prev_occup_1dig if ilo_lfs==2 & ilo_cat_une==1
				replace ilo_prevocu_isco08=11 if inlist(prev_occup, 0,.) & ilo_lfs==2 & ilo_cat_une==1
							lab values ilo_prevocu_isco08 isco08
							lab var ilo_prevocu_isco08 "Previous occupation (ISCO-08)"
	
	
		* Aggregate:
			gen ilo_prevocu_aggregate=.
				replace ilo_prevocu_aggregate=1 if inrange(ilo_prevocu_isco08,1,3)
				replace ilo_prevocu_aggregate=2 if inlist(ilo_prevocu_isco08,4,5)
				replace ilo_prevocu_aggregate=3 if inlist(ilo_prevocu_isco08,6,7)
				replace ilo_prevocu_aggregate=4 if ilo_prevocu_isco08==8
				replace ilo_prevocu_aggregate=5 if ilo_prevocu_isco08==9
				replace ilo_prevocu_aggregate=6 if ilo_prevocu_isco08==10
				replace ilo_prevocu_aggregate=7 if ilo_prevocu_isco08==11
				replace ilo_prevocu_aggregate=. if ilo_lfs!=2 
				replace ilo_prevocu_aggregate=. if ilo_cat_une!=1
					lab val ilo_prevocu_aggregate ocu_aggr_lab
					lab var ilo_prevocu_aggregate "Previous occupation (Aggregate)"	
					
	   * Skill level
	
		    gen ilo_prevocu_skill=.
		    	replace ilo_prevocu_skill=1 if ilo_prevocu_isco08==9
			    replace ilo_prevocu_skill=2 if inlist(ilo_prevocu_isco08,4,5,6,7,8)
			    replace ilo_prevocu_skill=3 if inlist(ilo_prevocu_isco08,1,2,3)
			    replace ilo_prevocu_skill=4 if inlist(ilo_prevocu_isco08,10,11)
				    * value label already defined
				    lab val ilo_prevocu_skill ocu_skill_lab
				    lab var ilo_prevocu_skill "Previous occupation (Skill level)"					
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			General social protection ('ilo_gsp_unschemes') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
	* Not available
	
***********************************************************************************************
*			PART 3.3. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
	
	/* Question 93 ("did you look for work in the last 30 days") is only asked to people available 
	   for work. So it makes no sense to create the variable dlma as only the category "not seeking, 
	   available" could be created and all the rest would go under "not elsewhere classified".		*/
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reason for not seeking job ('ilo_olf_reason') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		


	/* Question 95 is the closest to the definition. However, it is asked only to people available 
	   to work but not seeking, which is only a small part of the people outside labour force. 
	   In consequence, question 101 ("What was the main reason for not working or not being available 
	   most of the time in the last 12 months") is used to determine olfs_reason. 		*/ 
	
		gen ilo_olf_reason=.
			replace ilo_olf_reason=1 if	inlist(vi101,8,11) & ilo_lfs==3				//Labour market
			replace ilo_olf_reason=2 if	inlist(vi101,1,2,5,6,7,9,10) & ilo_lfs==3	//Personal/Family-related
			replace ilo_olf_reason=3 if inlist(vi101,3,4) & ilo_lfs==3				//Does not need/want to work
			replace ilo_olf_reason=4 if inlist(vi101,12,.) & ilo_lfs==3				//Not elsewhere classified
				lab def reasons_lab 1 "1 - Labour market" 2 "2 - Personal / Family-related" ///
									3 "3 - Does not need/want to work" 4 "4 - Not elsewhere classified"
				lab val ilo_olf_reason reasons_lab 
				lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"
	
						
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seeker ('ilo_dis')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

		
	gen ilo_dis=1 if ilo_lfs==3 & v91==1 & ilo_olf_reason==1
			lab def dis_lab 1 "Discouraged job-seekers"
			lab val ilo_dis dis_lab
			lab var ilo_dis "Discouraged job-seekers"
			
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training ('ilo_neet')  
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		


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
        
		/*Categories from temporal file deleted */
		drop if lab==1 
		
		/*Only age bands used*/
		drop ilo_age 
		
		/*Created variables for rural/urban identification*/
		drop  to_drop to_drop_1 to_drop_2
		
		/*Variables computed in-between*/
		drop lab isco08_2digits isco88_2digits isco08 isco88 isic4_2digits isic4 isic3_2digits isic3 occup_1dig occup_2dig occup_1dig_job2 occup_2dig_job2 isic2dig isic2dig_job2 social_security
	    drop prev_occup_1dig indu_code_une_2dig ilo_preveco_isic4_2digits
		
		compress 
		
	   /*Save dataset including original and ilo variables*/
	
		save ${country}_${source}_${time}_FULL,  replace		
	
	  /* Save file only containing ilo_* variables*/
	
		keep ilo*

		save ${country}_${source}_${time}_ILO, replace
