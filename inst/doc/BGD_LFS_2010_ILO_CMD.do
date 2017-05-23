* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Bangladesh, 2010
* DATASET USED:  Bangladesh LFS 2013
* NOTES: 
* Authors: Marylène Escher
* Who last updated the file: Marylène Escher
* Starting Date: 30 September 2016
* Last updated: 14 October 2016
***********************************************************************************************



***********************************************************************************************
***********************************************************************************************

* 			1. SET UP WORK DIRECTORY, FILE NAME, VARIABLES AND FUNCTIONS

***********************************************************************************************
***********************************************************************************************

clear all 

set more off

global inpath "I:\COMMON\A6 Microdatasets\BGD\LFS\2010\ORI"
global temppath "I:\COMMON\A6 Microdatasets"
global outpath "I:\COMMON\A6 Microdatasets\BGD\LFS\2010"


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
		

* Load original dataset:
cd "$inpath"

	use "LFS_2010_Final", clear	

		
		
		
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
	

	gen ilo_wgt=wgt_svrs
		lab var ilo_wgt "Sample weight"		
		
		
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time period ('ilo_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*

	* Year 2010
	gen ilo_time=1
		lab def lab_time 1 "2010" 
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


	gen ilo_geo=.
		replace ilo_geo=1 if location==2
		replace ilo_geo=2 if location==1
			lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural"
			lab val ilo_geo ilo_geo_lab
			lab var ilo_geo "Geographical coverage"	
	
	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------


	gen ilo_sex=sex
		lab def ilo_sex_lab 1 "1 - Male" 2 "2 - Female"
		lab var ilo_sex "Sex"
		lab val ilo_sex ilo_sex_lab


		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_age=age
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
*			Education ('ilo_edu') [done] 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
		
		
/* In the questionnaire the answers to the question "What is the highest class passed" group all 
   classes within primary school together (and so on for secondary classes) so we cannot identify 
   people having COMPLETED primary school (and so on). 
   
   Hence the varibale education is not created in order to avoid confusion and misleading information. */
   
   	
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education attendance ('ilo_edu_attendance') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
/*	Question 3.9 is "Whether currently reading in any educational institution? Yes or no" and 
	is coded in the dataset as "current institutional status". 
	We suppose that it asks whether the person is currently attending school. 				*/


	gen ilo_edu_attendance=.
		replace ilo_edu_attendance=1 if q39==1				// Attending
		replace ilo_edu_attendance=2 if q39!=1				// Not attending
			label def edu_att_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
			label val ilo_edu_attendance edu_att_lab
			label var ilo_edu_attendance "Education (Attendance)"

			
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Disability status ('ilo_dsb') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

		* No information on disability in the LFS questionnaire.
		

		

		
		
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
	
	
	drop ilo_age
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Labour Force Status ('ilo_lfs') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
		
 /* NOTE: * People who produce goods or services ONLY for household's own use or consumption should
			NOT be included in employment. Even though question 4.1 includes such people we use this 
			question to assess employment because there is no better option. 
 
		  * We suppose that answer 1 to question 5.3 (Waiting for re-appointment) designs the FUTURE STARTERS that already
		    made arrangements to (re)start a job within a short subsequent period. Hence, we include these persons in 
		    unemployment. If this answer does not design the future starters, they should be classified as "Outside 
			the labour force". */ 	
		  
	gen ilo_lfs=.
		replace ilo_lfs=1 if s4_1==1 | s4_2==1		// Employed 
		replace ilo_lfs=2 if ilo_lfs!=1 & ((inlist(s5_1,1,2) &  s5_5==1) | (inlist(s5_3,1,2))) // Unemployed
		replace ilo_lfs=3 if ilo_lfs!=1 & ilo_lfs!=2 		// Outside the labour force
		replace ilo_lfs=. if ilo_wap!=1
				label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside the Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status"




			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------


	gen ilo_mjh=.
		replace ilo_mjh=1 if s4_46!=1 & ilo_lfs==1
		replace ilo_mjh=2 if s4_46==1 & ilo_lfs==1
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

* Document: http://www.ilo.org/wcmsp5/groups/public/---dgreports/---stat/documents/normativeinstrument/wcms_087562.pdf
	

  * MAIN JOB:
	
	* Detailled categories:
	
		gen ilo_job1_ste_icse93=.
			replace ilo_job1_ste_icse93=1 if inlist(s4_9,1,6,7,8,9) & ilo_lfs==1	// Employees
			replace ilo_job1_ste_icse93=2 if s4_9==2 & ilo_lfs==1					// Employers
			replace ilo_job1_ste_icse93=3 if inlist(s4_9,3,4) & ilo_lfs==1			// Own-account workers
			*replace ilo_job1_ste_icse93=4 if										// Producer cooperatives
			replace ilo_job1_ste_icse93=5 if s4_9==5 & ilo_lfs==1					// Contributing family workers
			replace ilo_job1_ste_icse93=6 if s4_9==. & ilo_lfs==1					// Not classifiable
				
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

				
* SECOND JOB:

	* Not available
				
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------


	/* Classification used: BSIC, based on ISIC Rev. 4 */
	
	/* The economic activity is only classified at 1 digit level because the variable supposed to code at 2 digit level 
	   is actually the 1 digit codes and the 3 digit one seems to mixed labels at 3 and 4 digits. So we cannot be sure 
	   of which isic category it actually is.  */
		
			
		* Import value labels
			
			append using `labels'
				
			
				* MAIN JOB:
						
							
					* ISIC Rev. 4 - 1 digit
						gen ilo_job1_eco_isic4=.
							replace ilo_job1_eco_isic4=bsic if ilo_lfs==1
							replace ilo_job1_eco_isic4=22 if bsic==. & ilo_lfs==1
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
		

		
		
			* Dropping the variables not used anymore:	 
				drop isic4_2digits  isic4  isic3_2digits isic3
			
			
			
		* SECOND JOB:
		
		* Not available
					

	
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_job1_ocu_isco08') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
	
	/* Classification used: BSCO (1, 2 and 4 digit level available), based on ISCO (68 and 88, we use the latter as it is more recent)  */

				
	
	* MAIN JOB:	
	
		* ISCO 88 - 2 digit
			gen ilo_job1_ocu_isco88_2digits=bsco2des if ilo_lfs==1
				lab values ilo_job1_ocu_isco88_2digits isco88_2digits
				lab var ilo_job1_ocu_isco88_2digits "Occupation (ISCO-88), 2 digit level"

	
		
		* ISCO 88 - 1 digit
			gen ilo_job1_ocu_isco88=bsco881 if ilo_lfs==1
				replace ilo_job1_ocu_isco88=10 if ilo_job1_ocu_isco88==0
				replace ilo_job1_ocu_isco88=11 if bsco881==. & ilo_lfs==1
					lab def isco88_1dig_lab 1 "1 - Legislators, senior officials and managers" 2 "2 - Professionals" 3 "Technicians and associate professionals" 4 "4 - Clerks" 5 "5 - Service workers and shop and market sales workers" ///
									6 "6 - Skilled agricultural and fishery workers" 7 "7 - Craft and related trades workers" 8 "8 - Plant and machine operators and assemblers" ///
									9 "9 - Elementary occupations" 10 "0 - Armed forces" 11 "X - Not elsewhere classified"
					lab val ilo_job1_ocu_isco88 isco88
					lab var ilo_job1_ocu_isco88 "Occupation (ISCO-88)"		
	
	
		* Aggregate:			
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
					lab var ilo_job1_ocu_aggregate "Occupation (Aggregate) - Main job"	
	
	
		* Drop variables not used anymore
		drop isco88_2digits isco88 isco08_2digits isco08
		drop if missing(ilo_key) /// To drop empty lines added for the labels
	
	
	* SECOND JOB:
	
	* Not available
	

	
	
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_job1_ins_sector') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
	
	/* NGOs and "Others" are classiied under Private. "Autonomous" seems to be a part of the 
	   government, so it is classified under Public. 		*/
	
		gen ilo_job1_ins_sector=.
			replace ilo_job1_ins_sector=1 if inrange(s4_10,1,3) & ilo_lfs==1		// Public
			replace ilo_job1_ins_sector=2 if inrange(s4_10,4,8) & ilo_lfs==1		// Private
			replace ilo_job1_ins_sector=2 if s4_10==. & ilo_lfs==1					// Private
				lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private" 
				lab values ilo_job1_ins_sector ins_sector_lab
				lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities"
	
	
	
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job1_job_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			

	
			gen ilo_job1_job_time=.
				replace ilo_job1_job_time=1 if s4_20==2 & ilo_lfs==1 	// Part-time
				replace ilo_job1_job_time=2 if s4_20==1 & ilo_lfs==1 	// Full-time
				replace ilo_job1_job_time=3 if s4_20==. & ilo_lfs==1	// Unknown
					lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
					lab val ilo_job1_job_time job_time_lab
					lab var ilo_job1_job_time "Job (Working time arrangement) - Main job"	
			
		
		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job1_job_contract') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
		
	/* Seasonal, one-time and casuual jobs are classified as temporary. 	*/	
		
			gen ilo_job1_job_contract=. 
				replace ilo_job1_job_contract=1 if s4_18==1 & ilo_lfs==1
				replace ilo_job1_job_contract=2 if inrange(s4_18,2,5) & ilo_lfs==1
				replace ilo_job1_job_contract=3 if s4_18==. & ilo_lfs==1
					lab def job_contract_lab 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"
					lab val ilo_job1_job_contract job_contract_lab
					lab var ilo_job1_job_contract "Job (Type of contract)"

		
		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Formal / Informal Economy ('ilo_job1_ife_prod' 'ilo_job1_ife_nature') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
		

	* 1) Unit of production
	
		/* Useful questions:
				* s4_10 - Ownership: indiates the institutional sector (private, public,...)
				* s4_36 - Registration: indicates if the business is registered with any authority (only asked to self-employed)
				* s4_8 - Location of business
				* s4_11 - Size of company: how many peoples employed (the threshold used normally by 
						 the ILO is 5. Here we only have 10 so we use 10 instead of 5). 
				* s4_25-32 - Benefits from employer: to determine social security coverage (only asked to employees)	*/
		
		/* Generation of a variable indicating the social security coverage (to be dropped afterwards):
		
		   An employee is considered covered by social security if he/she is entitled to paid sick leaves AND paid annual 
		   leaves AND if the employer pays for the employee contributions to pension funds. 		*/
			
			
			gen social_security=.
				replace social_security=1 if s4_25==1 & s4_26==1 & s4_32==1 & ilo_lfs==1
				
	
			gen ilo_job1_ife_prod=.
   /*Informal*/ replace ilo_job1_ife_prod=1 if inlist(s4_10,5,6,8,.) & s4_36!=1  & ///
						((inlist(s4_8,3,9,13,.) & inlist(s4_11,1,.)) | inlist(s4_8,1,2,4,5,6,7,8,11,12)) & social_security!=1 		
	 /*Formal*/ replace ilo_job1_ife_prod=2 if inrange(s4_10,1,4) | (inlist(s4_10,5,6,8,.) & s4_36==1) | ///
						(inlist(s4_10,5,6,8,.) &  s4_36!=1 & inlist(s4_8,3,9,13,.) & inrange(s4_11,2,4)) | ///
						(inlist(s4_10,5,6,8,.) &  s4_36!=1 & (( inlist(s4_8,3,9,13,.) & inlist(s4_11,1,.)) | inlist(s4_8,1,2,4,5,6,7,8,11,12)) & social_security==1)	
 /*Households*/ replace ilo_job1_ife_prod=3 if s4_10==7 | (inlist(s4_10,5,6,8,.) & s4_36!=1 & s4_8==10)
				replace ilo_job1_ife_prod=. if ilo_lfs!=1 
						lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 
						lab val ilo_job1_ife_prod ilo_ife_prod_lab
						lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"
			
		
	
	
	* 2) Nature of job
	
			gen ilo_job1_ife_nature=.
   /*Informal*/ replace ilo_job1_ife_nature=1 if (inlist(ilo_job1_ste_icse93,2,3,4) & ilo_job1_ife_prod!=2) | ///
												 (ilo_job1_ste_icse93==1 & social_security!=1) |	///
												  inlist(ilo_job1_ste_icse93,5,6)								
     /*Formal*/ replace ilo_job1_ife_nature=2 if (inlist(ilo_job1_ste_icse93,2,3,4) & ilo_job1_ife_prod==2) | 	///
												 (ilo_job1_ste_icse93==1 & social_security==1)												
				replace ilo_job1_ife_nature=. if ilo_lfs!=1
						lab def ife_nature_lab 1 "1 - Persons with informal main job" 2 "2 - Persons with formal main job"
						lab val ilo_job1_ife_nature ife_nature_lab
						lab var ilo_job1_ife_nature "Informal / Formal Economy (Nature of job) - Main job"
		
			drop social_security
	
		

	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Hours of work ('ilo_job1_how') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
		
		
	* Only the total hours ACTUALLY worked in ALL JOBS are available.
		
	
			gen ilo_joball_how_actual=s4_22h  if ilo_lfs==1
					lab var ilo_joball_how_actual "Weekly hours actually worked in all jobs"
					
		
			gen ilo_joball_how_actual_bands=.
				replace ilo_joball_how_actual_bands=1 if ilo_joball_how_actual==0
				replace ilo_joball_how_actual_bands=2 if inrange(ilo_joball_how_actual,1,14)
				replace ilo_joball_how_actual_bands=3 if inrange(ilo_joball_how_actual,15,29)
				replace ilo_joball_how_actual_bands=4 if inrange(ilo_joball_how_actual,30,34)
				replace ilo_joball_how_actual_bands=5 if inrange(ilo_joball_how_actual,35,39)
				replace ilo_joball_how_actual_bands=6 if inrange(ilo_joball_how_actual,40,48)
				replace ilo_joball_how_actual_bands=7 if ilo_joball_how_actual>=49 & ilo_joball_how_actual!=.
				replace ilo_joball_how_actual_bands=8 if ilo_joball_how_actual_bands==. & ilo_lfs==1
				replace ilo_joball_how_actual_bands=. if ilo_lfs!=1
					lab def how_bands_lab 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"
					lab val ilo_joball_how_actual_bands how_bands_lab
					lab var ilo_joball_how_actual_bands "Weekly hours actually worked bands in all jobs"
		
		

		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Monthly labour related income ('ilo_lri') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
				
	
	/* Questions 4.13-4.14 asked if the workers got any payment (and how much) in the last seven DAYS.
	   This cannot be used to asses correctly the monthly income. */
	

				
		
		
***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_joball_tru') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
		
	/* Question 4.45 asks why workers are looking for another job. There is no answers corresponding
	   to "to work more hours". Hence we cannot identify time-related underemployed workers. 	*/
	
		
	
	
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
	
		* Not available
	

	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	
	
	/* Q5.4: "How long have you not been working in the past 12 months?". 
	   We use q5.4 to assess the duration of unemployment even though it asks how long they 
	   have not been working but it does not mean that they were looking and available for work. */	
	   	
	
			gen ilo_dur_aggregate=.
				replace ilo_dur_aggregate=1 if inrange(s5_4 ,1,5) & ilo_lfs==2
				replace ilo_dur_aggregate=2 if inrange(s5_4,6,11) & ilo_lfs==2
				replace ilo_dur_aggregate=3 if s5_4==12 & ilo_lfs==2
				replace ilo_dur_aggregate=4 if s5_4 ==. & ilo_lfs==2
					lab def ilo_unemp_aggr 1 "Less than 6 months" 2 "6 months to less than 12 months" 3 "12 months or more" 4 "Not elsewhere classified"
					lab val ilo_dur_aggregate ilo_unemp_aggr
					lab var ilo_dur_aggregate "Duration of unemployment (Aggregate)"
	
	
	
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
	
		* No information on previous employment 

				
	
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
		* No information on previous employment 
	

	
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			General social protection ('ilo_gsp_unschemes') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
		* No information to determine this variable.
	
	
	
	
***********************************************************************************************
*			PART 3.3. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
	
	
	gen ilo_olf_dlma=.
		replace ilo_olf_dlma = 1 if inlist(s5_1,1,2) & s5_5==2 & ilo_lfs==3 	//Seeking, not available
		replace ilo_olf_dlma = 2 if s5_1==3 & s5_5==1 & ilo_lfs==3				//Not seeking, available
		*replace ilo_olf_dlma = 3 if 											//Not seeking, not available, willing
		*replace ilo_olf_dlma = 4 if 											//Not seeking, not available, not willing
		replace ilo_olf_dlma = 5 if	ilo_olf_dlma==. & ilo_lfs==3				// Not classified 
	
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
		replace ilo_olf_reason=1 if	inlist(s5_3,3,9) & ilo_lfs==3		//Labour market
		replace ilo_olf_reason=2 if	inlist(s5_3,4,5,8) & ilo_lfs==3		//Personal / Family-related
		replace ilo_olf_reason=3 if inlist(s5_3,6,7	) & ilo_lfs==3		//Does not need / want to work
		replace ilo_olf_reason=4 if (s5_3==10 | s5_3==.) & ilo_lfs==3	//Not elsewhere classified
			lab def reasons_lab 1 "1 - Labour market" 2 "2 - Personal/Family-related" 3 "3 - Does not need/want to work" ///
								4 "4 - Not elsewhere classified"
			lab val ilo_olf_reason reasons_lab 
			lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"
			
			
			
		
		
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seeker ('ilo_dis')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

		
	gen ilo_dis=1 if ilo_lfs==3 & s5_5==1 & ilo_olf_reason==1
			lab def dis_lab 1 "Discouraged job-seekers"
			lab val ilo_dis dis_lab
			lab var ilo_dis "Discouraged job-seekers"
			
			
			
		
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training ('ilo_neet')  [done]
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



* 1 - Full dataset with original variables and ILO ones
	
	cd "$outpath"

        compress
		saveold BGD_LFS_2010_FULL, version(12) replace

		
		

* 2 - Dataset with only 'ILO' variables
	
		keep ilo*
		saveold BGD_LFS_2010_ILO, version(12) replace

		
