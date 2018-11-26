* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Canada
* DATASET USED: Canada
* NOTES:
* Authors: bescond@ilo.org  ILO / STATISTICS / DPAU
* Starting Date: 11/10/2017
* Last updated: 11/10/2017
***********************************************************************************************


***********************************************************************************************
***********************************************************************************************

* 			1. SET UP WORK DIRECTORY, FILE NAME, VARIABLES AND FUNCTIONS

***********************************************************************************************
***********************************************************************************************

clear all 

set more off
*set more off, permanently

global path "J:\DPAU\MICRO"
global country "CAN"
global source "LFS"
global time "2017M01"
global inputFile "pub0117"
global inpath "${path}\\${country}\\${source}\\${time}\ORI"
global outpath "${path}\\${country}\\${source}\\${time}"


************************************************************************************

* Important : if package « labutil » not already installed, install it in order to execute correctly the do-file

* ssc install labutil

************************************************************************************

*********************************************************************************************

* Load original dataset

*********************************************************************************************

cd "$inpath"
	use "$inputFile", clear
	rename *, upper  


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
*			Time period ('ilo_time')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	* Year 
	gen ilo_time=1
		lab def lab_time 1 "$time"
		lab val ilo_time lab_time
		lab var ilo_time "Time (Gregorian Calendar)"

*********************************************************************************************

* create local for Year and quarter

*********************************************************************************************			
decode ilo_time, gen(todrop)
split todrop, generate(todrop_) parse(M)
destring todrop_1, replace force
local Y = todrop_1 in 1
			
					
		
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
capture rename  FWEIGHT FINALWT // before 2017M01
   gen ilo_wgt=.
       replace ilo_wgt =  FINALWT 
               lab var ilo_wgt "Sample weight"	


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

* comment: URSTAT not available
	
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	
	
	gen ilo_sex= SEX
	destring ilo_sex, replace
		lab def ilo_sex_lab 1 "1 - Male" 2 "2 - Female"
		lab var ilo_sex "Sex"
		lab val ilo_sex ilo_sex_lab

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_age_5yrbands= AGE_12
	destring ilo_age_5yrbands, replace
	replace ilo_age_5yrbands = ilo_age_5yrbands + 3
	replace ilo_age_5yrbands = 14 if inrange(ilo_age_5yrbands,14,15 )
	
	lab def age_by5_lab 4 "15-19" 5 "20-24" 6 "25-29" ///
								    7 "30-34" 8 "35-39" 9 "40-44" 10 "45-49" 11 "50-54" 12 "55-59" ///
								    13 "60-64" 14 "65+"
			    lab val ilo_age_5yrbands age_by5_lab
			    lab var ilo_age_5yrbands "Age (5-year age bands)"
		
	gen ilo_age_10yrbands=.
		replace ilo_age_10yrbands=2 if inrange(ilo_age_5yrbands,4,5)
		replace ilo_age_10yrbands=3 if inrange(ilo_age_5yrbands,6,7)
		replace ilo_age_10yrbands=4 if inrange(ilo_age_5yrbands,8,9)
		replace ilo_age_10yrbands=5 if inrange(ilo_age_5yrbands,10,11)
		replace ilo_age_10yrbands=6 if inrange(ilo_age_5yrbands,12,13)
		replace ilo_age_10yrbands=7 if ilo_age_5yrbands == 14
			    lab def age_by10_lab 2 "15-24" 3 "25-34" 4 "35-44" 5 "45-54" 6 "55-64" 7 "65+"
			    lab val ilo_age_10yrbands age_by10_lab
			    lab var ilo_age_10yrbands "Age (10-year age bands)"
			
	gen ilo_age_aggregate=.
		replace ilo_age_aggregate=2 if ilo_age_10yrbands == 2
		replace ilo_age_aggregate=3 if inrange(ilo_age_10yrbands,3,5)
		replace ilo_age_aggregate=4 if ilo_age_10yrbands == 6
		replace ilo_age_aggregate=5 if ilo_age_10yrbands == 7
		    	lab def age_aggr_lab 2 "15-24" 3 "25-54" 4 "55-64" 5 "65+"
			    lab val ilo_age_aggregate age_aggr_lab
			    lab var ilo_age_aggregate "Age (Aggregate)"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education ('ilo_edu')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: need definiton of EDUC /*Highest educational attainment*/ seems that EDUC 0 = EDU_ISCED11_0; EDUC 1 = EDU_ISCED11_2; EDUC 6 = EDU_ISCED11_7
* nee to confirm that 		
* EDUC 0 = EDU_ISCED11_0
* EDUC 1 = EDU_ISCED11_2
* EDUC 2 = EDU_ISCED11_3
* EDUC 3 = EDU_ISCED11_4
* EDUC 4 = EDU_ISCED11_5
* EDUC 5 = EDU_ISCED11_6
* EDUC 6 = EDU_ISCED11_7
* els eneed mapping or additional variable
		
		
		
	
	gen edu_ilo = EDUC
	destring edu_ilo, replace
	gen ilo_edu_isced11=.													// No schooling
		replace ilo_edu_isced11=2 if edu_ilo==0								// Early childhood education
		replace ilo_edu_isced11=4 if edu_ilo==1 							// Lower secondary education
		replace ilo_edu_isced11=5 if inlist(edu_ilo,2,3)					// Upper secondary education
		* replace ilo_edu_isced11=6 if edu_ilo==3 							// Post-secondary non-tertiary education
		replace ilo_edu_isced11=7 if edu_ilo==4 							// Short-cycle tertiary education
		replace ilo_edu_isced11=8 if edu_ilo==5 							// Bachelor's or equivalent level
		replace ilo_edu_isced11=9 if edu_ilo==6 							// Master's or equivalent level
		replace ilo_edu_isced11=10 if edu_ilo==7 							// Doctoral or equivalent level 
		replace ilo_edu_isced11=11 if ilo_edu_isced11==.
			label def isced_11_lab 1 "X - No schooling" 2 "0 - Early childhood education" 3 "1 - Primary education" 4 "2 - Lower secondary education" 5 "3 - Upper secondary education" ///
									6 "4 - Post-secondary non-tertiary education" 7 "5 - Short-cycle tertiary education" 8 "6 - Bachelor's or equivalent level" 9 "7 - Master's or equivalent level" ///
									10 "8 - Doctoral or equivalent level" 11 "9 - Not elsewhere classified"
			label val ilo_edu_isced11 isced_11_lab
			lab var ilo_edu_isced11 "Education (ISCED 11)"
		
		* for the definition, cf. the document "Guide to reporting labour statistics to the ILO using the Excel questionnaire"
		
	gen ilo_edu_aggregate=.
		replace ilo_edu_aggregate=1 if inlist(ilo_edu_isced11,1,2)					// Less than basic
		replace ilo_edu_aggregate=2 if inlist(ilo_edu_isced11,3,4)					// Basic
		replace ilo_edu_aggregate=3 if inlist(ilo_edu_isced11,5,6)					// Intermediate
		replace ilo_edu_aggregate=4 if inlist(ilo_edu_isced11,7,8,9,10)				// Advanced
		replace ilo_edu_aggregate=5 if ilo_edu_isced11==11							// Level not stated
			label def edu_aggr_lab 1 "1 - Less than basic" 2 "2 - Basic" 3 "3 - Intermediate" 4 "4 - Advanced" 5 "5 - Level not stated"
			label val ilo_edu_aggregate edu_aggr_lab
			label var ilo_edu_aggregate "Education (Aggregate level)"
drop edu_ilo	

		* test if var is should be drop 	
		egen drop_var = mean(ilo_edu_aggregate)
		local Z = drop_var in 1
		if `Z' == 5 {
			drop ilo_edu_aggregate ilo_edu_isced11
		}
		drop 	drop_var	 

	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education attendance ('ilo_edu_attendance')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

gen ilo_attendance = SCHOOLN
destring ilo_attendance, replace 

	
          gen ilo_edu_attendance=.
				replace ilo_edu_attendance=1 if inlist(ilo_attendance,2,3)			// 1 - Attending
				replace ilo_edu_attendance=2 if ilo_attendance ==1					// 2 - Not attending
				replace ilo_edu_attendance=3 if !inlist(ilo_attendance, 1,2,3)		// 3 - Not elsewhere classified
				lab def edu_attendance_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
				lab val ilo_edu_attendance edu_attendance_lab
				lab var ilo_edu_attendance "Education (Attendance)"
        

		* test if var is should be drop 	
		egen drop_var = mean(ilo_edu_attendance)
		local Z = drop_var in 1
		if `Z' == 3 {
			drop ilo_edu_attendance
		}
		drop 	drop_var
		drop ilo_attendance
	
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			           Marital status ('ilo_mrts') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 
if `Y' > 1999 {	

	* Detailed
	gen ilo_mrts_details=.
	    replace ilo_mrts_details=1 if MARSTAT ==6                               // Single
		replace ilo_mrts_details=2 if MARSTAT ==1                               // Married
		replace ilo_mrts_details=3 if MARSTAT ==2                               // Union / cohabiting
		replace ilo_mrts_details=4 if MARSTAT ==3                               // Widowed
		replace ilo_mrts_details=5 if inlist(MARSTAT, 4,5)                      // Divorced / separated
		replace ilo_mrts_details=6 if ilo_mrts_details==.			            // Not elsewhere classified
		        label define label_mrts_details 1 "1 - Single" 2 "2 - Married" 3 "3 - Union / cohabiting" ///
				                                4 "4 - Widowed" 5 "5 - Divorced / separated" 6 "6 - Not elsewhere classified"
		        label values ilo_mrts_details label_mrts_details
		        lab var ilo_mrts_details "Marital status"
				
	* Aggregate
	gen ilo_mrts_aggregate=.
	    replace ilo_mrts_aggregate=1 if inlist(ilo_mrts_details,1,4,5)          // Single / Widowed / Divorced / Separated
		replace ilo_mrts_aggregate=2 if inlist(ilo_mrts_details,2,3)            // Married / Union / Cohabiting
		replace ilo_mrts_aggregate=3 if ilo_mrts_aggregate==. 			        // Not elsewhere classified
		        label define label_mrts_aggregate 1 "1 - Single / Widowed / Divorced / Separated" 2 "2 - Married / Union / Cohabiting" 3 "3 - Not elsewhere classified"
		        label values ilo_mrts_aggregate label_mrts_aggregate
		        lab var ilo_mrts_aggregate "Marital status (Aggregate levels)"				
}		

					
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Disability status ('ilo_dsb')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

* Comment: severale variables, to be confirmed: search 'disability' on UserGuide


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
		replace ilo_wap=1 if ilo_age_5yrbands !=.				// Working age population
			label def ilo_wap_lab 1 "Working age population"
			label val ilo_wap ilo_wap_lab
			label var ilo_wap "Working age population"

			
	* tab  ilo_age_5yrbands [iw = ilo_wgt / 1000] if ilo_wap == 1, m
	* tab  ilo_geo [iw = ilo_wgt] if ilo_wap == 1, m
	* tab  ilo_sex [iw = ilo_wgt] if ilo_wap == 1, m
	* tab  ilo_edu_isced11 [iw = ilo_wgt] if ilo_wap == 1, m
	* tab  ilo_edu_aggregate [iw = ilo_wgt] if ilo_wap == 1, m		

			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Labour Force Status ('ilo_lfs')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: Directly based on labour status variable. 
	gen ilo_lfs = .
	replace ilo_lfs = LFSSTAT if ilo_wap==1
	destring ilo_lfs , replace
	

	
	
if `Y' > 2016 {		

	    replace ilo_lfs=1 if inrange(LFSSTAT,1, 2) 	& ilo_wap==1			// Employed
		replace ilo_lfs=2 if LFSSTAT==3 & ilo_wap==1						// Unemployed 
		replace ilo_lfs=3 if LFSSTAT==4 & ilo_wap==1      					// Outside the labour force
}
if `Y' < 2017 {	
	    replace ilo_lfs=1 if inrange(LFSSTAT,1, 2) & ilo_wap==1 			// Employed
		replace ilo_lfs=2 if inlist(LFSSTAT,3,4,5) 	& ilo_wap==1			// Unemployed 
		replace ilo_lfs=3 if LFSSTAT==6 & ilo_wap==1      					// Outside the labour force
}
		replace ilo_lfs=. if ilo_wap!=1
		    label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside the Labour Force"
			label value ilo_lfs label_ilo_lfs
			label var ilo_lfs "Labour Force Status"



* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	
	gen ilo_mjh = MJH
	destring ilo_mjh , replace
			lab def lab_ilo_mjh 1 "1 - One job only" 2 "2 - More than one job"
			lab val ilo_mjh lab_ilo_mjh
			lab var ilo_mjh "Multiple job holders"


		* test if var is should be drop 	
		egen drop_var = mean(ilo_mjh)
		local Z = drop_var in 1
		if `Z' == . {
			drop ilo_mjh
		}
		drop 	drop_var
		
	
***********************************************************************************************
*			PART 3.1. ECONOMIC CHARACTERISTICS FOR MAIN JOB 
***********************************************************************************************		
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Status in employment ('ilo_job1_ste')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: 

	* Detailed categories:
	gen ilo_job1_ste  = COWMAIN
	destring ilo_job1_ste, replace
	
		gen ilo_job1_ste_icse93=.
			replace ilo_job1_ste_icse93=1 if inlist(ilo_job1_ste, 1,2)   		    // Employees
			replace ilo_job1_ste_icse93=2 if inlist(ilo_job1_ste, 3,5)	            // Employers
			
			replace ilo_job1_ste_icse93=3 if inlist(ilo_job1_ste, 4,6)      		// Own-account workers
			* replace ilo_job1_ste_icse93=4                                         // Members of producers’ cooperatives
			replace ilo_job1_ste_icse93=5 if inlist(ilo_job1_ste, 7)	            // Contributing family workers
			replace ilo_job1_ste_icse93=6 if (ilo_job1_ste_icse93==. & ilo_lfs==1)  // Not classifiable
				label def label_ilo_ste_icse93 1 "1 - Employees" 2 "2 - Employers" 3 "3 - Own-account workers" ///                      
											   4 "4 - Members of producers cooperatives" 5 "5 - Contributing family workers" ///
											   6 "6 - Workers not classifiable by status"
				label val ilo_job1_ste_icse93 label_ilo_ste_icse93
				label var ilo_job1_ste_icse93 "Status in employment (ICSE 93)"

	* Aggregate categories 
		gen ilo_job1_ste_aggregate=.
			replace ilo_job1_ste_aggregate=1 if ilo_job1_ste_icse93 == 1			// Employees
			replace ilo_job1_ste_aggregate=2 if inlist(ilo_job1_ste_icse93, 2,3,5)	// Self-employed
			replace ilo_job1_ste_aggregate=3 if inlist(ilo_job1_ste_icse93, 6)		// Not elsewhere classified
			replace ilo_job1_ste_aggregate=3 if (ilo_job1_ste_icse93==. & ilo_lfs==1)
				lab def ste_aggr_lab 1 "1 - Employees" 2 "2 - Self-employed" 3 "3 - Not elsewhere classified"
				lab val ilo_job1_ste_aggregate ste_aggr_lab
				label var ilo_job1_ste_aggregate "Status in employment (Aggregate)"  
 
		* test if var is should be drop 	
		egen drop_var = mean(ilo_job1_ste_aggregate)
		local Z = drop_var in 1
		if `Z' == 3 {
			drop ilo_job1_ste_aggregate ilo_job1_ste_icse93
		}
		drop 	drop_var
		drop ilo_job1_ste
	* tab  ilo_job1_ste_icse93 [iw = ilo_wgt] if ilo_lfs == 1, m			
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: 
/*
* Import value labels
		gen ilo_job1_eco = ISIC
		tostring ilo_job1_eco, replace
* ISIC Rev. 4
		
		gen ilo_job1_eco_isic4=.
			replace ilo_job1_eco_isic4=1 if ilo_job1_eco=="A"				// Agriculture, forestry and fishing
			replace ilo_job1_eco_isic4=2 if ilo_job1_eco=="B"				// Mining and quarrying
			replace ilo_job1_eco_isic4=3 if ilo_job1_eco=="C"				// Manufacturing
			replace ilo_job1_eco_isic4=4 if ilo_job1_eco=="D"				// Electricity, gas, steam and air conditioning supply
			replace ilo_job1_eco_isic4=5 if ilo_job1_eco=="E"				// Water supply; sewerage, waste management and remediation activities
			replace ilo_job1_eco_isic4=6 if ilo_job1_eco=="F"				// Construction
			replace ilo_job1_eco_isic4=7 if ilo_job1_eco=="G"          	// Wholesale and retail trade; repair of motor vehicles and motorcycles
			replace ilo_job1_eco_isic4=8 if ilo_job1_eco=="H"				// Transportation and storage
			replace ilo_job1_eco_isic4=9 if ilo_job1_eco=="I"				// Accommodation and food service activities
			replace ilo_job1_eco_isic4=10 if ilo_job1_eco=="J"			// Information and communication
			replace ilo_job1_eco_isic4=11 if ilo_job1_eco=="K"			// Financial and insurance activities	
			replace ilo_job1_eco_isic4=12 if ilo_job1_eco=="L"			// Real estate activities
			replace ilo_job1_eco_isic4=13 if ilo_job1_eco=="M"			// Professional, scientific and technical activities
			replace ilo_job1_eco_isic4=14 if ilo_job1_eco=="N"			// Administrative and support service activities + ISIC4U
			replace ilo_job1_eco_isic4=15 if ilo_job1_eco=="O"			// Public administration and defence; compulsory social security
			replace ilo_job1_eco_isic4=16 if ilo_job1_eco=="P"			// Education
			replace ilo_job1_eco_isic4=17 if ilo_job1_eco=="Q"			// Human health and social work activities
			replace ilo_job1_eco_isic4=18 if ilo_job1_eco=="R"			// Arts, entertainment and recreation
			replace ilo_job1_eco_isic4=19 if ilo_job1_eco=="S"			// Other service activities
			replace ilo_job1_eco_isic4=20 if ilo_job1_eco=="T"			// Activities of households as employers; undifferentiated goods- and services-producing activities of households for own use
			* replace ilo_job1_eco_isic4=21 if ilo_job1_eco=="U"			// Activities of extraterritorial organizations and bodies
			replace ilo_job1_eco_isic4=22 if ilo_job1_eco=="X"		    // Not elsewhere classified
			replace ilo_job1_eco_isic4=22 if ilo_job1_eco_isic4==. & ilo_lfs==1 
				
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
			replace ilo_job1_eco_aggregate=1 if ilo_job1_eco_isic4==1				// 1 - Agriculture
			replace ilo_job1_eco_aggregate=2 if ilo_job1_eco_isic4==3				// 2 - Manufacturing
			replace ilo_job1_eco_aggregate=3 if ilo_job1_eco_isic4==6				// 3 - Construction
			replace ilo_job1_eco_aggregate=4 if inlist(ilo_job1_eco_isic4,2,4,5)	// 4 - Mining and quarrying; Electricity, gas and water supply
			replace ilo_job1_eco_aggregate=5 if inrange(ilo_job1_eco_isic4,7,14)	// 5 - Market Services (Trade; Transportation; Accommodation and food; and Business and administrative services)
			replace ilo_job1_eco_aggregate=6 if inrange(ilo_job1_eco_isic4,15,21) 	// 6 - Non-market services (Public administration; Community, social and other services and activities)
			replace ilo_job1_eco_aggregate=7 if ilo_job1_eco_isic4==22				// 7 - Not classifiable by economic activity
				lab def eco_aggr_lab 1 "1 - Agriculture" 2 "2 - Manufacturing" 3 "3 - Construction" 4 "4 - Mining and quarrying; Electricity, gas and water supply" ///
									5 "5 - Market Services (Trade; Transportation; Accommodation and food; and Business and administrative services)"  ///
									6 "6 - Non-market services (Public administration; Community, social and other services and activities)" 7 "7 - Not classifiable by economic activity"					
				lab val ilo_job1_eco_aggregate eco_aggr_lab
				lab var ilo_job1_eco_aggregate "Economic activity (Aggregate)"			


		* test if var is should be drop 	
		egen drop_var = mean(ilo_job1_eco_aggregate)
		local Z = drop_var in 1
		if `Z' == 7 {
			drop ilo_job1_eco_aggregate ilo_job1_eco_isic4
		}
		drop 	drop_var	
		drop ilo_job1_eco
	* tab  ilo_job1_eco_isic4 [iw = ilo_wgt] if ilo_lfs == 1, m
	*/		
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_job1_ocu_isco08')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: need more information on NOC_10 and NOC_40


/*
	gen isco_ilo = ISCO3D if ilo_lfs==1	
	destring isco_ilo, replace
	replace isco_ilo = int(isco_ilo/10)
			
	* ISCO 08 - 2 digit ISCO3D
	gen ilo_job1_ocu_isco08_2digits = isco_ilo	
	lab var ilo_job1_ocu_isco08_2digits "Occupation (ISCO-08), 2 digit level"
	
	
	* 1 digit level
	gen ilo_job1_ocu_isco08 = int(ilo_job1_ocu_isco08_2digits/10)
		lab def ocu_isco08_2digits 1 "01 - Commissioned armed forces officers" 2 "02 - Non-commissioned armed forces officers" 3 "03 - Armed forces occupations, other ranks" /// 
			11 "11 - Chief executives, senior officials and legislators" 12 "12 - Administrative and commercial managers" 13 "13 - Production and specialised services managers" /// 
			14 "14 - Hospitality, retail and other services managers" 21 "21 - Science and engineering professionals" 22 "22 - Health professionals" 23 "23 - Teaching professionals" /// 
			24 "24 - Business and administration professionals" 25 "25 - Information and communications technology professionals" 26 "26 - Legal, social and cultural professionals" /// 
			31 "31 - Science and engineering associate professionals" 32 "32 - Health associate professionals" 33 "33 - Business and administration associate professionals" /// 
			34 "34 - Legal, social, cultural and related associate professionals" 35 "35 - Information and communications technicians" 41 "41 - General and keyboard clerks" 42 "42 - Customer services clerks" /// 
			43 "43 - Numerical and material recording clerks" 44 "44 - Other clerical support workers" 51 "51 - Personal service workers" 52 "52 - Sales workers" 53 "53 - Personal care workers" /// 
			54 "54 - Protective services workers" 61 "61 - Market-oriented skilled agricultural workers" 62 "62 - Market-oriented skilled forestry, fishery and hunting workers" /// 
			63 "63 - Subsistence farmers, fishers, hunters and gatherers" 71 "71 - Building and related trades workers, excluding electricians" 72 "72 - Metal, machinery and related trades workers" /// 
			73 "73 - Handicraft and printing workers" 74 "74 - Electrical and electronic trades workers" 75 "75 - Food processing, wood working, garment and other craft and related trades workers" /// 
			81 "81 - Stationary plant and machine operators" 82 "82 - Assemblers" 83 "83 - Drivers and mobile plant operators" 91 "91 - Cleaners and helpers" 92 "92 - Agricultural, forestry and fishery labourers" /// 
			93 "93 - Labourers in mining, construction, manufacturing and transport" 94 "94 - Food preparation assistants" 95 "95 - Street and related sales and service workers" /// 
			96 "96 - Refuse workers and other elementary workers"

	lab val ilo_job1_ocu_isco08_2digits ocu_isco08_2digits
	
	
	replace ilo_job1_ocu_isco08=10 if ilo_job1_ocu_isco08==0 & ilo_lfs==1
	replace ilo_job1_ocu_isco08=11 if ilo_job1_ocu_isco08_2digits== 99 & ilo_lfs==1	
	replace ilo_job1_ocu_isco08=11 if !inrange(ilo_job1_ocu_isco08, 1, 11) & ilo_lfs==1
				lab def ocu_isco08_lab 1 "1 - Managers" 2 "2 - Professionals" 3 "3 - Technicians and associate professionals" 4 "4 - Clerical support workers" 5 "5 - Service and sales workers" /// 
							6 "6 - Skilled agricultural, forestry and fishery workers" 7 "7 - Craft and related trades workers" 8 "8 - Plant and machine operators, and assemblers" 9 "9 - Elementary occupations" /// 
							10 "0 - Armed forces occupations" 11 "X - Not elsewhere classified"
				lab val ilo_job1_ocu_isco08 ocu_isco08_lab
				lab var ilo_job1_ocu_isco08 "Occupation (ISCO-08)"	
*/	

/*
	  * Aggregate
	  gen ilo_job1_ocu_aggregate=.
		  replace ilo_job1_ocu_aggregate=1 if inrange(ilo_job1_ocu_isco08,1,3)  // 1 - Managers, professionals, and technicians
		  replace ilo_job1_ocu_aggregate=2 if inlist(ilo_job1_ocu_isco08,4,5)	// 2 - Clerical, service and sales workers
		  replace ilo_job1_ocu_aggregate=3 if inlist(ilo_job1_ocu_isco08,6,7)	// 3 - Skilled agricultural and trades workers
		  replace ilo_job1_ocu_aggregate=4 if ilo_job1_ocu_isco08==8			// 4 - Plant and machine operators, and assemblers
		  replace ilo_job1_ocu_aggregate=5 if ilo_job1_ocu_isco08==9			// 5 - Elementary occupations
		  replace ilo_job1_ocu_aggregate=6 if ilo_job1_ocu_isco08==10			// 6 - Armed forces
		  replace ilo_job1_ocu_aggregate=7 if ilo_job1_ocu_isco08==11			// 7 - Not elsewhere classified
				  lab def ocu_aggr_lab 1 "1 - Managers, professionals, and technicians" 2 "2 - Clerical, service and sales workers" 3 "3 - Skilled agricultural and trades workers" ///
									   4 "4 - Plant and machine operators, and assemblers" 5 "5 - Elementary occupations" 6 "6 - Armed forces" 7 "7 - Not elsewhere classified"
				  lab val ilo_job1_ocu_aggregate ocu_aggr_lab
				  lab var ilo_job1_ocu_aggregate "Occupation (Aggregate)"	
		
	  * Skill level
	  gen ilo_job1_ocu_skill=.
		  replace ilo_job1_ocu_skill=1 if ilo_job1_ocu_isco08==9                   // Low
		  replace ilo_job1_ocu_skill=2 if inlist(ilo_job1_ocu_isco08,4,5,6,7,8)    // Medium
		  replace ilo_job1_ocu_skill=3 if inlist(ilo_job1_ocu_isco08,1,2,3)        // High
		  replace ilo_job1_ocu_skill=4 if inlist(ilo_job1_ocu_isco08,10,11)        // Not elsewhere classified
			   	  lab def ocu_skill_lab 1 "1 - Skill level 1 (low)" 2 "2 - Skill level 2 (medium)" 3 "3 - Skill levels 3 and 4 (high)" 4 "4 - Not elsewhere classified"
				  lab val ilo_job1_ocu_skill ocu_skill_lab
				  lab var ilo_job1_ocu_skill "Occupation (Skill level)"

		* test if var is should be drop 	
		egen drop_var = mean(ilo_job1_ocu_aggregate)
		local Z = drop_var in 1
		if `Z' == 7 {
			drop ilo_job1_ocu_aggregate ilo_job1_ocu_isco08 ilo_job1_ocu_skill	ilo_job1_ocu_isco08_2digits
		}
		drop 	drop_var
		
	 * tab  ilo_job1_ocu_isco08 [iw = ilo_wgt] if ilo_lfs == 1, m

	drop isco_ilo
				  
	*/  
				  
				  
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_job1_ins_sector')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

	gen ilo_institute  = COWMAIN
	destring ilo_institute, replace
		
		gen ilo_job1_ins_sector=.
			replace ilo_job1_ins_sector=1 if ilo_institute==1 					// Public
			replace ilo_job1_ins_sector=2 if (ilo_institute!=1 & ilo_lfs==1)   	// Private
				lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
			    lab values ilo_job1_ins_sector ins_sector_lab
			    lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities"
		drop ilo_institute
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job1_job_time')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			

* Comment: 

		destring FTPTMAIN, replace
		gen ilo_job1_job_time=.
		replace ilo_job1_job_time=2 if FTPTMAIN == 2								// 1 - Part-time
		replace ilo_job1_job_time=1 if FTPTMAIN == 1								// 2 - Full-time
		replace ilo_job1_job_time=3 if (ilo_job1_job_time==. & ilo_lfs==1)		// 3 - Unknown
			lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknow"
			    lab values ilo_job1_job_time job_time_lab
			    lab var ilo_job1_job_time "Job (Working time arrangement)"
 
		* test if var is should be drop 	
		egen drop_var = mean(ilo_job1_job_time)
		local Z = drop_var in 1
		if `Z' == 3 {
			drop ilo_job1_job_time
		}
		drop 	drop_var
	* tab  ilo_job1_job_time [iw = ilo_wgt] if ilo_lfs == 1, m

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Hours of work ('ilo_job1_how')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

* Comment: 

lab def how_act_bands_lab 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"

   * ilo_job1_how_actual
   
		gen ilo_job1_how_actual=AHRSMAIN if ilo_lfs==1
				lab var ilo_job1_how_actual "Weekly hours actually worked in main job"	      
		
		gen ilo_job1_how_actual_bands=.
			 replace ilo_job1_how_actual_bands=1 if ilo_job1_how_actual==0				// No hours actually worked
			 replace ilo_job1_how_actual_bands=2 if inrange(ilo_job1_how_actual,1,14)	// 01-14
			 replace ilo_job1_how_actual_bands=3 if inrange(ilo_job1_how_actual,15,29)	// 15-29
			 replace ilo_job1_how_actual_bands=4 if inrange(ilo_job1_how_actual,30,34)	// 30-34
			 replace ilo_job1_how_actual_bands=5 if inrange(ilo_job1_how_actual,35,39)	// 35-39
			 replace ilo_job1_how_actual_bands=6 if inrange(ilo_job1_how_actual,40,48)	// 40-48
			 replace ilo_job1_how_actual_bands=7 if ilo_job1_how_actual>=49 & ilo_job1_how_actual !=. // 49+
			 replace ilo_job1_how_actual_bands=8 if ilo_job1_how_actual_bands == .		// Not elsewhere classified
					lab val ilo_job1_how_actual_bands how_act_bands_lab
					lab var ilo_job1_how_actual_bands "Bands of weekly hours actually worked in main job" 

		* test if var is should be drop 	
		egen drop_var = mean(ilo_job1_how_actual_bands)
		local Z = drop_var in 1
		if `Z' == 8 {
			drop ilo_job1_how_actual_bands
		}
		drop 	drop_var		
	* tab  ilo_job1_how_actual_bands [iw = ilo_wgt] if ilo_lfs == 1, m

   * Weekly hours ACTUALLY worked in all job

		gen ilo_joball_how_actual = .
		replace ilo_joball_how_actual = ATOTHRS if ilo_lfs==1
				lab var ilo_joball_how_actual "Weekly hours actually worked in all jobs"	      

		gen ilo_joball_how_actual_bands=.
			 replace ilo_joball_how_actual_bands=1 if ilo_joball_how_actual==0
			 replace ilo_joball_how_actual_bands=2 if inrange(ilo_joball_how_actual,1,14)
			 replace ilo_joball_how_actual_bands=3 if inrange(ilo_joball_how_actual,15,29)
			 replace ilo_joball_how_actual_bands=4 if inrange(ilo_joball_how_actual,30,34)
			 replace ilo_joball_how_actual_bands=5 if inrange(ilo_joball_how_actual,35,39)
			 replace ilo_joball_how_actual_bands=6 if inrange(ilo_joball_how_actual,40,48)
			 replace ilo_joball_how_actual_bands=7 if ilo_joball_how_actual_bands>=49  & ilo_job1_how_actual !=.
			 replace ilo_joball_how_actual_bands=8 if ilo_joball_how_actual_bands == .
				    lab val ilo_joball_how_actual_bands how_act_bands_lab
					lab var ilo_joball_how_actual_bands "Weekly hours actually worked bands in all jobs"
	
	
	* tab  ilo_joball_how_actual_bands [iw = ilo_wgt] if ilo_lfs == 1, m


* Comment: USUAL HOW


   * ilo_job1_how_actual
		gen ilo_job1_how_usual = .
		replace ilo_job1_how_usual = UHRSMAIN if ilo_lfs==1
				lab var ilo_job1_how_usual "Weekly hours usually worked in main job"	      
		
   * Weekly hours ilo_joball_how_usual

		gen ilo_joball_how_usual = .
		replace ilo_joball_how_usual = UTOTHRS if ilo_lfs==1
				lab var ilo_joball_how_usual "Weekly hours usually worked in all jobs"	      

		
	* tab  ilo_joball_how_actual_bands [iw = ilo_wgt] if ilo_lfs == 1, m
	
	
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job1_job_contract')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

* Comment: 

		gen ilo_contract = PERMTEMP
		destring ilo_contract, replace

		gen ilo_job1_job_contract=.
		replace ilo_job1_job_contract=1 if ilo_contract == 1						// 1 - Permanent
		replace ilo_job1_job_contract=2 if inlist(ilo_contract,2,3,4)				// 2 - Temporary
		replace ilo_job1_job_contract=3 if (ilo_job1_job_contract==. & ilo_lfs==1)	// 3 - Unknown
			lab def job_contract_lab 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknow"
			    lab values ilo_job1_job_contract job_contract_lab
			    lab var ilo_job1_job_contract "Job (Type of contract)"
	
		* test if var is should be drop 	
		egen drop_var = mean(ilo_job1_job_contract)
		local Z = drop_var in 1
		if `Z' == 3 {
			drop ilo_job1_job_contract
		}
		drop 	drop_var
		drop ilo_contract

	* tab  ilo_job1_job_contract [iw = ilo_wgt] if ilo_lfs == 1, m

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Formal / Informal Economy ('ilo_job1_ife_prod' 'ilo_job1_ife_nature')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			

* Comment: Not enough information to define informal employment / informal sector	
	

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*	    Monthly related income ('ilo_lri_ees' and 'ilo_lri_slf')  		       *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 

    ***********
    * MAIN JOB:
    ***********
	
	* Employees
	gen ilo_job1_lri_ees = .
	    replace ilo_job1_lri_ees = UHRSMAIN * HRLYEARN *52/12   if ilo_job1_ste_aggregate==1
	    replace ilo_job1_lri_ees = .     if ilo_lfs!=1
		        lab var ilo_job1_lri_ees "Monthly earnings of employees - main job"
	
***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_joball_tru')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

* Comment: No information


if `Y' > 1996 {	
	capture rename WHYPTNEW WHYPT // before 2017M01
	gen ilo_joball_tru=.
		replace ilo_joball_tru=1 if  WHYPT  == 6
			lab def lab_joball_tru 1 "Time-related underemployed" 
			lab val ilo_joball_tru lab_joball_tru
			lab var ilo_joball_tru "Time-related underemployed"

		* tab  ilo_joball_tru [iw = ilo_wgt] if ilo_lfs == 1, m		
}		

*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Cases of non-fatal occupational injury ('ilo_joball_oi_case')
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------

* Comment: No information

*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Days lost due to cases of occupational injury ('ilo_joball_oi_day')
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------

* Comment: No information



***********************************************************************************************
*			PART 3.3. UNEMPLOYMENT: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Category of unemployment ('ilo_cat_une')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: var EXISTPR

	gen ilo_cat = EVERWORK
	destring ilo_cat, replace

		gen ilo_cat_une=.
		replace ilo_cat_une=1 if inlist(ilo_cat,1,2) 				// 1 - Unemployed previously employed
		replace ilo_cat_une=2 if ilo_cat == 3 						// 2 - Unemployed seeking their first job
		replace ilo_cat_une=3 if (ilo_cat_une==. & ilo_lfs==2)		// 3 - Unknown
			lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
			    lab values ilo_cat_une cat_une_lab
			    lab var ilo_cat_une "Category of unemployment"
		
		* tab  ilo_cat_une [iw = ilo_wgt] if ilo_lfs == 2, m		

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: due to anonymised microdata DURUNE is reduced to aggregate only
	gen ilo_dur = DURUNE
	destring ilo_dur , replace
    * Detailed
		gen ilo_dur_details=.
			replace ilo_dur_details=1 if inrange(ilo_dur,1,4)                  	// Less than 1 month / 1-4 weeks 
			replace ilo_dur_details=2 if inrange(ilo_dur,5,13)         			// 1-2 months / 5-13 weeks
			replace ilo_dur_details=3 if inrange(ilo_dur,14,26)         		// 3-5 months / 14-26 weeks
			replace ilo_dur_details=4 if inrange(ilo_dur,27,52)                 // 6-11 months / 27-52 weeks
			replace ilo_dur_details=5 if inrange(ilo_dur,53,104)                // 12-24 months / 53-104 weeks
			replace ilo_dur_details=6 if inrange(ilo_dur,105,2000)              // 24+  months / 105+ weeks
			replace ilo_dur_details=7 if (ilo_dur_details==.& ilo_lfs==2)   	// Not elsewhere classified
			        lab def ilo_unemp_det 1 "Less than 1 month" 2 "1 month to less than 3 months" 3 "3 months to less than 6 months" ///
										  4 "6 months to less than 12 months" 5 "12 months to less than 24 months" 6 "24 months or more" ///
										  7 "Not elsewhere classified"
				    lab val ilo_dur_details ilo_unemp_det
				    lab var ilo_dur_details "Duration of unemployment (Details)"
	
    * Aggregate				

		gen ilo_dur_aggregate=.
			replace ilo_dur_aggregate=1 if inrange(ilo_dur,1,26)				// Less than 6 months
			replace ilo_dur_aggregate=2 if inrange(ilo_dur,27,52)             	// 6 months to less than 12 months
			replace ilo_dur_aggregate=3 if inrange(ilo_dur,53,2000) 				    // 12 months or more
			replace ilo_dur_aggregate=4 if ilo_dur_aggregate==. & ilo_lfs==2            // Not elsewhere classified
					lab def ilo_unemp_aggr 1 "Less than 6 months" 2 "6 months to less than 12 months" 3 "12 months or more" 4 "Not elsewhere classified"
					lab val ilo_dur_aggregate ilo_unemp_aggr
					lab var ilo_dur_aggregate "Duration of unemployment (Aggregate)"

		* test if var is should be drop 	
		egen drop_var = mean(ilo_dur_aggregate)
		local Z = drop_var in 1
		if `Z' == 4 {
			drop ilo_dur_aggregate
		}
		drop 	drop_var
		drop ilo_dur
		* tab  ilo_dur_details [iw = ilo_wgt] if ilo_lfs == 2, m		

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

* Comment: not available
		
* tab  ilo_preveco_isic3 [iw = ilo_wgt] if ilo_lfs == 2, m

		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

* Comment:  not available



***********************************************************************************************
*			PART 3.4. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		.
*		comment: 
		

		gen ilo_olf_dlma=. 

		* 1 - Seeking, not available (Unavailable jobseekers) # assuming that they are not availble else unemployed !!
		replace ilo_olf_dlma=1 if (ilo_lfs == 3 & DURJLESS !=. & AVAILABL ==1)			
		* 2 - Not seeking, available (Available potential jobseekers)
		replace ilo_olf_dlma=2 if (ilo_lfs == 3 & ilo_olf_dlma !=1 & AVAILABL ==2)			
		* 3 - Not seeking, not available, willing (Willing non-jobseekers)
		replace ilo_olf_dlma=3 if (ilo_lfs == 3 & !inlist(ilo_olf_dlma,1,2) & YNOLOOK != .) 
		* 4 - Not seeking, not available, not willing
		replace ilo_olf_dlma=4 if (ilo_lfs == 3 & !inlist(ilo_olf_dlma,1,2) & YNOLOOK == .)
		replace ilo_olf_dlma=5 if (ilo_lfs == 3 & ilo_olf_dlma==.)
			lab def olf_dlma_lab 1 "1 - Seeking, not available (Unavailable jobseekers)" 2 "2 - Not seeking, available (Available potential jobseekers)" 3 "3 - Not seeking, not available, willing (Willing non-jobseekers)" 4 "4 - Not seeking, not available, not willing" 5 "5 - Not elsewhere classified"
			lab val ilo_olf_dlma olf_dlma_lab 
			lab var ilo_olf_dlma "Labour market attachment (Degree of)"

		* test if var is should be drop 	
		egen drop_var = mean(ilo_olf_dlma)
		local Z = drop_var in 1
		if `Z' == 4 {
			drop ilo_olf_dlma
		}
		drop 	drop_var		
		
		
		
	* tab  ilo_olf_dlma [iw = ilo_wgt] if ilo_lfs == 3, m	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reason for not seeking job ('ilo_olf_reason')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		


* may be could be try with ???????????
* YNOLOOK Wanted job in reference week, reason for not looking

  	gen ilo_olf_reason = .
		replace ilo_olf_reason = 1 if inlist(YNOLOOK,6)	& ilo_lfs == 3			// 1 - Labour market (discouraged)
		replace ilo_olf_reason = 2 if inlist(YNOLOOK, 5) & ilo_lfs == 3			// 2- Other labour market reasons
		replace ilo_olf_reason = 3 if inlist(YNOLOOK, 1,2,3,4) & ilo_lfs == 3	// 3 - Personal / Family-related
		* replace ilo_olf_reason = 1 if inlist(YNOLOOK)							// 4 - Does not need/want to work
		replace ilo_olf_reason = 4 if ilo_olf_reason == . & ilo_lfs == 3		// 5 - Not elsewhere classified
			lab def ilo_olf_reason_lab 1 "1 - Labour market (discouraged)" 2 "2 - Other labour market reasons" 3 "3 - Personal or Family-related" 4 "4 - Does not need/want to work" 5 "5 - Not elsewhere classified"
			lab val ilo_olf_reason ilo_olf_reason_lab 
			lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job or being outside the labour market)"					
		

		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seeker ('ilo_dis')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
		gen ilo_available = AVAILABL
		destring ilo_available, replace
		gen ilo_reasonnotlook = YNOLOOK
		destring ilo_reasonnotlook, replace
		
		
		gen ilo_dis = .
		replace ilo_dis=1 if (ilo_available == 2 & ilo_reasonnotlook  == 6 )
			lab def dis_lab 1 "Discouraged job-seekers"
			lab val ilo_dis dis_lab
			lab var ilo_dis "Discouraged job-seekers"
		* test if var is should be drop 	
		egen drop_var = mean(ilo_dis)
		local Z = drop_var in 1
		if `Z' == . {
			drop ilo_dis
		}
		drop 	drop_var
		drop ilo_available
		drop ilo_reasonnotlook

	* tab  ilo_dis [iw = ilo_wgt] , m	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training ('ilo_neet')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* 2003 onwards

		gen ilo_neet = .
		replace ilo_neet=1 if (ilo_age_aggregate==2 & ilo_lfs !=1 & ilo_edu_attendance == 2 )
			lab def neet_lab 1 "Youth not in education, employment or training"
			lab val ilo_neet neet_lab
			lab var ilo_neet "Youth not in education, employment or training"
		* test if var is should be drop 	
		egen drop_var = mean(ilo_neet)
		local Z = drop_var in 1
		if `Z' == . {
			drop ilo_neet
		}
		drop drop_var
		
	* tab  ilo_neet [iw = ilo_wgt] , m		



***********************************************************************************************
***********************************************************************************************

*			3. SAVE ILO-VARIABLES IN A NEW DATASET

***********************************************************************************************
***********************************************************************************************
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Drop intermediate variables 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
drop todrop*
local Y
local Q	
local Z	
local ilo_cat

* -------------------------------------------------------------
* 	Prepare final datasets
* -------------------------------------------------------------

cd "$outpath"

		compress 
		
		/*Save dataset including original and ilo variables*/
	
		save ${country}_${source}_${time}_FULL,  replace		

		/* Save file only containing ilo_* variables*/
	
		keep ilo*

		save ${country}_${source}_${time}_ILO, replace
