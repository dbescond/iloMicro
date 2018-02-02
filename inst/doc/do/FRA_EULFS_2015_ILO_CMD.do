* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Belgium
* DATASET USED: Belgium - EU Labour Force Survey
* NOTES:
* Authors: DPAU
* Who last updated the file: DPAU 
* Starting Date: 10/08/2017
* Last updated: 18/09/2017
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
global country "FRA"
global source "EULFS"
global time "2015"
global inputFile "${country}_${source}_${time}_YearlyFiles"
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
split todrop, generate(todrop_) parse(Q)
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

   gen ilo_wgt=.
       replace ilo_wgt = COEFF * 1000
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



	destring DEGURBA, replace // 1991
	gen ilo_geo = .
		replace ilo_geo = 1 if (DEGURBA == 1 | DEGURBA == 2)		// 1 - Urban
		replace ilo_geo = 2 if  DEGURBA == 3						// 2 - Rural
		replace ilo_geo = 3 if  ilo_geo ==.							// 3 - Not elsewhere classified
		lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural" 3 "3 - Not elsewhere classified"
		lab val ilo_geo ilo_geo_lab
		lab var ilo_geo "Geographical coverage"	

		* test if var is should be drop 	
		egen drop_var = mean(ilo_geo)
		local Z = drop_var in 1
		if `Z' == 3 {
			drop ilo_geo
		}
		drop 	drop_var			
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_sex= SEX
		lab def ilo_sex_lab 1 "1 - Male" 2 "2 - Female"
		lab var ilo_sex "Sex"
		lab val ilo_sex ilo_sex_lab

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_age= AGE
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

* Comment: completed level of education always to be considered!
		
* before 2014 ISCED 97 after ISCED 11:

if `Y' > 2013 {		
	gen edu_ilo = HAT11LEV
	destring edu_ilo, replace
	gen ilo_edu_isced11=.													// No schooling
		replace ilo_edu_isced11=2 if edu_ilo==0								// Early childhood education
		replace ilo_edu_isced11=3 if edu_ilo==100 							// Primary education
		replace ilo_edu_isced11=4 if edu_ilo==200 							// Lower secondary education
		replace ilo_edu_isced11=5 if inrange(edu_ilo,300,304)				// Upper secondary education
		replace ilo_edu_isced11=6 if edu_ilo==400 							// Post-secondary non-tertiary education
		replace ilo_edu_isced11=7 if edu_ilo==500 							// Short-cycle tertiary education
		replace ilo_edu_isced11=8 if edu_ilo==600 							// Bachelor's or equivalent level
		replace ilo_edu_isced11=9 if edu_ilo==700 							// Master's or equivalent level
		replace ilo_edu_isced11=10 if edu_ilo==800 							// Doctoral or equivalent level 
		replace ilo_edu_isced11=11 if edu_ilo==999 							// Not elsewhere classified
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

}
			
			
			
			
if (`Y' < 2014 & `Y' > 1997) {
	
	gen edu_ilo = HAT97LEV
	destring edu_ilo , replace
	gen ilo_edu_isced97=.										// X - No schooling			
		replace ilo_edu_isced97=2 if inrange(edu_ilo ,0, 10)	// 0 - Pre-primary education
		replace ilo_edu_isced97=3 if edu_ilo ==11				// 1 - Primary education or first stage of basic education	
		replace ilo_edu_isced97=4 if edu_ilo==21				// 2 - Lower secondary or second stage of basic education	
		replace ilo_edu_isced97=5 if inrange(edu_ilo,22, 36) 	// 3 - Upper secondary education
		replace ilo_edu_isced97=6 if inrange(edu_ilo,41, 43)	// 4 - Post-secondary non-tertiary education
		replace ilo_edu_isced97=7 if inlist(edu_ilo,51,52)		// 5 - First stage of tertiary education
		replace ilo_edu_isced97=8 if edu_ilo==60				// 6 - Second stage of tertiary education
		replace ilo_edu_isced97=9 if edu_ilo==99				// UNK - Level not stated
		replace ilo_edu_isced97=9 if ilo_edu_isced97==.
			label def isced_97_lab 1 "X - No schooling" 2 "0 - Pre-primary education" 3 "1 - Primary education or first stage of basic education" 4 "2 - Lower secondary education or second stage of basic education" ///
							5 "3 - Upper secondary education" 6 "4 - Post-secondary non-tertiary education" 7 "5 - First stage of tertiary education (not leading directly to an advanced research qualification)" ///
							8 "6 - Second stage of tertiary education (leading to an advanced research qualification)" 9 "UNK - Level not stated"
			label val ilo_edu_isced97 isced_97_lab
			lab var ilo_edu_isced97 "Level of education (ISCED 97)"

	* for the definition, cf. the document "Guide to reporting labour statistics to the ILO using the Excel questionnaire"
	
	gen ilo_edu_aggregate=.
		replace ilo_edu_aggregate=1 if inlist(ilo_edu_isced97,1,2)					// Less than basic
		replace ilo_edu_aggregate=2 if inlist(ilo_edu_isced97,3,4)					// Basic
		replace ilo_edu_aggregate=3 if inlist(ilo_edu_isced97,5,6)					// Intermediate
		replace ilo_edu_aggregate=4 if inlist(ilo_edu_isced97,7,8)					// Advanced
		replace ilo_edu_aggregate=5 if ilo_edu_isced97==9							// Level not stated
			label def edu_aggr_lab 1 "1 - Less than basic" 2 "2 - Basic" 3 "3 - Intermediate" 4 "4 - Advanced" 5 "5 - Level not stated"
			label val ilo_edu_aggregate edu_aggr_lab
			label var ilo_edu_aggregate "Level of education (Aggregate levels)"
	drop edu_ilo	


		* test if var is should be drop 	
		egen drop_var = mean(ilo_edu_aggregate)
		local Z = drop_var in 1
		if `Z' == 5 {
			drop ilo_edu_aggregate ilo_edu_isced97
		}
		drop 	drop_var		
}			
				
			
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education attendance ('ilo_edu_attendance')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* 2003 onwards



destring COURATT, replace
destring EDUCSTAT, replace
egen drop_COURATT = mean(COURATT)
local Z = drop_COURATT in 1

if `Y' > 2003 & `Z' != . {		
          gen ilo_edu_attendance=.
				replace ilo_edu_attendance=1 if EDUCSTAT==2 | COURATT==2			// 1 - Attending
				replace ilo_edu_attendance=2 if ilo_edu_attendance ==.				// 2 - Not attending
				replace ilo_edu_attendance=3 if EDUCSTAT == . & COURATT == .		// 3 - Not elsewhere classified
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
		
		
		
}
drop drop_COURATT
		
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Disability status ('ilo_dsb')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

* Comment: severale variables, to be confirm: search 'disability' on UserGuide


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
		replace ilo_wap=1 if ilo_age>=15 & ilo_age!=.				// Working age population
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

	gen ilo_lfs=.
	    replace ilo_lfs=1 if inlist(ILOSTAT,1, 4)	         		// Employed
		replace ilo_lfs=2 if ILOSTAT==2 						    // Unemployed 
		replace ilo_lfs=3 if ILOSTAT==3 & ilo_wap==1      			// Outside the labour force
		    label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside the Labour Force"
			label value ilo_lfs label_ilo_lfs
			label var ilo_lfs "Labour Force Status"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

    gen ilo_mjh=.
		replace ilo_mjh=1 if (EXIST2J==1 | EXIST2J == .) & ilo_lfs==1				// 1 - One job only
		replace ilo_mjh=2 if (EXIST2J == 2 & ilo_lfs==1)							// 2- More than one job
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

* Comment: due to anonymised microdata STATPRO is reduce to 0 (self-employed), 3, 4, 9

	* Detailed categories:
		gen ilo_job1_ste_icse93=.
			replace ilo_job1_ste_icse93=1 if (STAPRO==3 & ilo_lfs==1)   		    // Employees
			* replace ilo_job1_ste_icse93=2 if (STAPRO==1 & ilo_lfs==1)	            // Employers
			replace ilo_job1_ste_icse93=3 if (STAPRO==0 & ilo_lfs==1)      			// Own-account workers
			* replace ilo_job1_ste_icse93=4                                         // Members of producers’ cooperatives
			replace ilo_job1_ste_icse93=5 if (STAPRO==4 & ilo_lfs==1)	            // Contributing family workers
			replace ilo_job1_ste_icse93=6 if (ilo_job1_ste_icse93==. & ilo_lfs==1)  // Not classifiable
				label def label_ilo_ste_icse93 1 "1 - Employees" 2 "2 - Employers" 3 "3 - Own-account workers" ///                      
											   4 "4 - Members of producers cooperatives" 5 "5 - Contributing family workers" ///
											   6 "6 - Workers not classifiable by status"
				label val ilo_job1_ste_icse93 label_ilo_ste_icse93
				label var ilo_job1_ste_icse93 "Status in employment (ICSE 93)"

	* Aggregate categories 
		gen ilo_job1_ste_aggregate=.
			replace ilo_job1_ste_aggregate=1 if (STAPRO==3 & ilo_lfs==1)			// Employees
			replace ilo_job1_ste_aggregate=2 if (inlist(STAPRO,0,4) & ilo_lfs==1)	// Self-employed
			replace ilo_job1_ste_aggregate=3 if (STAPRO==9 & ilo_lfs==1)			// Not elsewhere classified
			replace ilo_job1_ste_aggregate=3 if (STAPRO==. & ilo_lfs==1)
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
		
	* tab  ilo_job1_ste_icse93 [iw = ilo_wgt] if ilo_lfs == 1, m			
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: var NACE3D, NA113D, NA702D collected but not disseminated

* Import value labels
		
if `Y' > 2007 {	

* ISIC Rev. 4
		tostring NACE1D, replace
		gen ilo_job1_eco_isic4=.
			replace ilo_job1_eco_isic4=1 if NACE1D=="A"				// Agriculture, forestry and fishing
			replace ilo_job1_eco_isic4=2 if NACE1D=="B"				// Mining and quarrying
			replace ilo_job1_eco_isic4=3 if NACE1D=="C"				// Manufacturing
			replace ilo_job1_eco_isic4=4 if NACE1D=="D"				// Electricity, gas, steam and air conditioning supply
			replace ilo_job1_eco_isic4=5 if NACE1D=="E"				// Water supply; sewerage, waste management and remediation activities
			replace ilo_job1_eco_isic4=6 if NACE1D=="F"				// Construction
			replace ilo_job1_eco_isic4=7 if NACE1D=="G"          	// Wholesale and retail trade; repair of motor vehicles and motorcycles
			replace ilo_job1_eco_isic4=8 if NACE1D=="H"				// Transportation and storage
			replace ilo_job1_eco_isic4=9 if NACE1D=="I"				// Accommodation and food service activities
			replace ilo_job1_eco_isic4=10 if NACE1D=="J"			// Information and communication
			replace ilo_job1_eco_isic4=11 if NACE1D=="K"			// Financial and insurance activities	
			replace ilo_job1_eco_isic4=12 if NACE1D=="L"			// Real estate activities
			replace ilo_job1_eco_isic4=13 if NACE1D=="M"			// Professional, scientific and technical activities
			replace ilo_job1_eco_isic4=14 if NACE1D=="N"			// Administrative and support service activities
			replace ilo_job1_eco_isic4=15 if NACE1D=="O"			// Public administration and defence; compulsory social security
			replace ilo_job1_eco_isic4=16 if NACE1D=="P"			// Education
			replace ilo_job1_eco_isic4=17 if NACE1D=="Q"			// Human health and social work activities
			replace ilo_job1_eco_isic4=18 if NACE1D=="R"			// Arts, entertainment and recreation
			replace ilo_job1_eco_isic4=19 if NACE1D=="S"			// Other service activities
			replace ilo_job1_eco_isic4=20 if NACE1D=="T"			// Activities of households as employers; undifferentiated goods- and services-producing activities of households for own use
			replace ilo_job1_eco_isic4=21 if NACE1D=="U"			// Activities of extraterritorial organizations and bodies
			replace ilo_job1_eco_isic4=22 if NACE1D=="9"		    // Not elsewhere classified
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
	* tab  ilo_job1_eco_isic4 [iw = ilo_wgt] if ilo_lfs == 1, m
	
	
}

	
	

if (`Y' < 2008 & `Y' > 1991){			
		
* ISIC Rev. 3.1 
	tostring NA111D, replace
	gen ilo_job1_eco_isic3=.
		replace ilo_job1_eco_isic3=1 if NA111D=="A"					// Agriculture, hunting and forestry
		replace ilo_job1_eco_isic3=2 if NA111D=="B"					// Fishing
		replace ilo_job1_eco_isic3=3 if NA111D=="C"					// Mining and quarrying
		replace ilo_job1_eco_isic3=4 if NA111D=="D"					// Manufacturing
		replace ilo_job1_eco_isic3=5 if NA111D=="E"					// Electricity, gas and water supply
		replace ilo_job1_eco_isic3=6 if NA111D=="F"					// Construction
		replace ilo_job1_eco_isic3=7 if NA111D=="G"					// Wholesale and retail trade; repair of motor vehicles, motorcycles and personal and household goods
		replace ilo_job1_eco_isic3=8 if NA111D=="H"					// Hotels and restaurants
		replace ilo_job1_eco_isic3=9 if NA111D=="I"					// Transport, storage and communications
		replace ilo_job1_eco_isic3=10 if NA111D=="J"				// Financial intermediation
		replace ilo_job1_eco_isic3=11 if NA111D=="K"				// Real estate, renting and business activities
		replace ilo_job1_eco_isic3=12 if NA111D=="L"				// Public administration and defence; compulsory social security
		replace ilo_job1_eco_isic3=13 if NA111D=="M"				// Education
		replace ilo_job1_eco_isic3=14 if NA111D=="N"				// Health and social work
		replace ilo_job1_eco_isic3=15 if NA111D=="O"				// Other community, social and personal service activities
		replace ilo_job1_eco_isic3=16 if NA111D=="P"				// Activities of private households as employers and undifferentiated production activities of private households
		replace ilo_job1_eco_isic3=17 if NA111D=="Q"				// Extraterritorial organizations and bodies
		replace ilo_job1_eco_isic3=18 if NA111D=="9"				// Not elsewhere classified
		replace ilo_job1_eco_isic3=18 if ilo_job1_eco_isic3==. & ilo_lfs==1
				lab def eco_isic3_lab 1 "A - Agriculture, hunting and forestry" 2 "B - Fishing" 3 "C - Mining and quarrying" 4 "D - Manufacturing" 5 "E - Electricity, gas and water supply" /// 
									6 "F - Construction" 7 "G - Wholesale and retail trade; repair of motor vehicles, motorcycles and personal and household goods" 8 "H - Hotels and restaurants" /// 
									9 "I - Transport, storage and communications" 10 "J - Financial intermediation" 11 "K - Real estate, renting and business activities" /// 
									12 "L - Public administration and defence; compulsory social security" 13 "M - Education" 14 "N - Health and social work" 15 "O - Other community, social and personal service activities" /// 
									16 "P - Activities of private households as employers and undifferentiated production activities of private households" 17 "Q - Extraterritorial organizations and bodies" /// 
									18 "X - Not elsewhere classified"
			lab val ilo_job1_eco_isic3 eco_isic3_lab 
			lab var ilo_job1_eco_isic3 "Economic activity (ISIC Rev. 3.1)"
			
	* Now do the classification on an aggregate level
	
	* Primary activity
	
	gen ilo_job1_eco_aggregate=.
		replace ilo_job1_eco_aggregate=1 if inlist(ilo_job1_eco_isic3,1,2)		// 1 - Agriculture
		replace ilo_job1_eco_aggregate=2 if ilo_job1_eco_isic3==4				// 2 - Manufacturing
		replace ilo_job1_eco_aggregate=3 if ilo_job1_eco_isic3==6				// 3 - Construction
		replace ilo_job1_eco_aggregate=4 if inlist(ilo_job1_eco_isic3,3,5)		// 4 - Mining and quarrying; Electricity, gas and water supply
		replace ilo_job1_eco_aggregate=5 if inrange(ilo_job1_eco_isic3,7,11)	// 5 - Market Services (Trade; Transportation; Accommodation and food; and Business and administrative services)
		replace ilo_job1_eco_aggregate=6 if inrange(ilo_job1_eco_isic3,12,17)	// 6 - Non-market services (Public administration; Community, social and other services and activities)
		replace ilo_job1_eco_aggregate=7 if ilo_job1_eco_isic3==18				// 7 - Not classifiable by economic activity
			lab def eco_aggr_lab 1 "1 - Agriculture" 2 "2 - Manufacturing" 3 "3 - Construction" 4 "4 - Mining and quarrying; Electricity, gas and water supply" ///
								5 "5 - Market Services (Trade; Transportation; Accommodation and food; and Business and administrative services)"  ///
								6 "6 - Non-market services (Public administration; Community, social and other services and activities)" 7 "7 - Not classifiable by economic activity"					
			lab val ilo_job1_eco_aggregate eco_aggr_lab
			lab var ilo_job1_eco_aggregate "Economic activity (Aggregate)"
		
		* test if var is should be drop 	
		egen drop_var = mean(ilo_job1_eco_aggregate)
		local Z = drop_var in 1
		if `Z' == 7 {
			drop ilo_job1_eco_aggregate ilo_job1_eco_isic3
		}
		drop 	drop_var
		
	* tab  ilo_job1_eco_isic3 [iw = ilo_wgt] if ilo_lfs == 1, m

		
}

				
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_job1_ocu_isco08')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: var ISCO4D collected by not disseminate, 
* 	Dissemination usually in aggregated form: ISCO1D, ISCO2D and ISCO3D
* 	ISCO is available in the anonymised microdata in this way: ISCO1D, ISCO3D for ISCO-08 from 2011 onwards, 
* 	IS881D, IS883D for ISCO-88(COM) until 2010 – see corresponding chapter for some country-specific aggregations
	

 if `Y' > 2010 {	

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
}				  


if `Y' < 2011 {	
		
	gen isco_ilo = IS883D if ilo_lfs==1	
	destring isco_ilo, replace
	replace isco_ilo = int(isco_ilo/10)
	* Two digit level:
	
	gen ilo_job1_ocu_isco88_2digits = isco_ilo
	lab var ilo_job1_ocu_isco88_2digits "Occupation (ISCO-88), 2 digit level"

	
	
	* 1 digit level
	gen ilo_job1_ocu_isco88 = int(ilo_job1_ocu_isco88_2digits/10)
		lab def ocu_isco88_2digits 1 "01 - Armed forces" 11 "11 - Legislators and senior officials" 12 "12 - Corporate managers" 13 "13 - General managers" /// 
			21 "21 - Physical, mathematical and engineering science professionals" 22 "22 - Life science and health professionals" 23 "23 - Teaching professionals" 24 "24 - Other professionals" /// 
			31 "31 - Physical and engineering science associate professionals" 32 "32 - Life science and health associate professionals" 33 "33 - Teaching associate professionals" /// 
			34 "34 - Other associate professionals" 41 "41 - Office clerks" 42 "42 - Customer services clerks" 51 "51 - Personal and protective services workers" /// 
			52 "52 - Models, salespersons and demonstrators" 61 "61 - Skilled agricultural and fishery workers" 62 "62 - Subsistence agricultural and fishery workers" /// 
			71 "71 - Extraction and building trades workers" 72 "72 - Metal, machinery and related trades workers" 73 "73 - Precision, handicraft, craft printing and related trades workers" /// 
			74 "74 - Other craft and related trades workers" 81 "81 - Stationary plant and related operators" 82 "82 - Machine operators and assemblers" 83 "83 - Drivers and mobile plant operators" /// 
			91 "91 - Sales and services elementary occupations" 92 "92 - Agricultural, fishery and related labourers" 93 "93 - Labourers in mining, construction, manufacturing and transport"

	lab val ilo_job1_ocu_isco88_2digits ocu_isco88_2digits
	
	replace ilo_job1_ocu_isco88=10 if ilo_job1_ocu_isco88==0 & ilo_lfs==1
	replace ilo_job1_ocu_isco88=11 if ilo_job1_ocu_isco88_2digits== 99 & ilo_lfs==1	
	replace ilo_job1_ocu_isco88=11 if !inrange(ilo_job1_ocu_isco88, 1, 11) & ilo_lfs==1
			lab def ocu_isco88_lab 1 "1 - Legislators, senior officials and managers" 2 "2 - Professionals" 3 "3 - Technicians and associate professionals" /// 
				4 "4 - Clerks" 5 "5 - Service workers and shop and market sales workers" 6 "6 - Skilled agricultural and fishery workers" 7 "7 - Craft and related trades workers" /// 
				8 "8 - Plant and machine operators and assemblers" 9 "9 - Elementary occupations" 10 "0 - Armed forces" 11 "11 - Not elsewhere classified"
			lab val ilo_job1_ocu_isco88 ocu_isco88_lab
			lab var ilo_job1_ocu_isco88 "Occupation (ISCO-88)"					
	
	
	  * Aggregate
	  gen ilo_job1_ocu_aggregate=.
		  replace ilo_job1_ocu_aggregate=1 if inrange(ilo_job1_ocu_isco88,1,3)  // 1 - Managers, professionals, and technicians 
		  replace ilo_job1_ocu_aggregate=2 if inlist(ilo_job1_ocu_isco88,4,5)	// 2 - Clerical, service and sales workers
		  replace ilo_job1_ocu_aggregate=3 if inlist(ilo_job1_ocu_isco88,6,7)	// 3 - Skilled agricultural and trades workers
		  replace ilo_job1_ocu_aggregate=4 if ilo_job1_ocu_isco88==8			// 4 - Plant and machine operators, and assemblers
		  replace ilo_job1_ocu_aggregate=5 if ilo_job1_ocu_isco88==9			// 5 - Elementary occupations
		  replace ilo_job1_ocu_aggregate=6 if ilo_job1_ocu_isco88==10			// 6 - Armed forces
		  replace ilo_job1_ocu_aggregate=7 if ilo_job1_ocu_isco88==11			// 7 - Not elsewhere classified
				  lab def ocu_aggr_lab 1 "1 - Managers, professionals, and technicians" 2 "2 - Clerical, service and sales workers" 3 "3 - Skilled agricultural and trades workers" ///
									   4 "4 - Plant and machine operators, and assemblers" 5 "5 - Elementary occupations" 6 "6 - Armed forces" 7 "7 - Not elsewhere classified"
				  lab val ilo_job1_ocu_aggregate ocu_aggr_lab
				  lab var ilo_job1_ocu_aggregate "Occupation (Aggregate)"	
		
	  * Skill level
	  gen ilo_job1_ocu_skill=.
		  replace ilo_job1_ocu_skill=1 if ilo_job1_ocu_isco88==9                   // Low
		  replace ilo_job1_ocu_skill=2 if inlist(ilo_job1_ocu_isco88,4,5,6,7,8)    // Medium
		  replace ilo_job1_ocu_skill=3 if inlist(ilo_job1_ocu_isco88,1,2,3)        // High
		  replace ilo_job1_ocu_skill=4 if inlist(ilo_job1_ocu_isco88,10,11)        // Not elsewhere classified
			   	  lab def ocu_skill_lab 1 "1 - Skill level 1 (low)" 2 "2 - Skill level 2 (medium)" 3 "3 - Skill levels 3 and 4 (high)" 4 "4 - Not elsewhere classified"
				  lab val ilo_job1_ocu_skill ocu_skill_lab
				  lab var ilo_job1_ocu_skill "Occupation (Skill level)"

		* test if var is should be drop 	
		egen drop_var = mean(ilo_job1_ocu_aggregate)
		local Z = drop_var in 1
		if `Z' == 7 {
			drop ilo_job1_ocu_aggregate ilo_job1_ocu_isco88 ilo_job1_ocu_skill	ilo_job1_ocu_isco88_2digits
		}
		drop 	drop_var
	
	 * tab  ilo_job1_ocu_isco88 [iw = ilo_wgt] if ilo_lfs == 1, m

	drop isco_ilo
	
}



				  
				  
		  
				  
			  
				  
				  
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_job1_ins_sector')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

	* not available


		/*
		gen ilo_job1_ins_sector=.
			replace ilo_job1_ins_sector=1 if (ocusec==1 & ilo_lfs==1)	// Public
			replace ilo_job1_ins_sector=2 if (ocusec==2 & ilo_lfs==1)   // Private
			replace ilo_job1_ins_sector=2 if (ocusec==. & ilo_lfs==1) 	// Force missing into private
				lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
			    lab values ilo_job1_ins_sector ins_sector_lab
			    lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities"
		*/
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job1_job_time')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			

* Comment: var FTPT
		destring FTPT, replace
		gen ilo_job1_job_time=.
		replace ilo_job1_job_time=2 if FTPT == 1								// 1 - Part-time
		replace ilo_job1_job_time=1 if FTPT == 2								// 2 - Full-time
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

* Comment: Information only for hours actually worked in main and second job




lab def how_act_bands_lab 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"

   * ilo_job1_how_actual
   
		gen ilo_job1_how_actual=HWACTUAL if ilo_lfs==1
		replace ilo_job1_how_actual = . if ilo_job1_how_actual==99
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

   * Weekly hours ACTUALLY worked in main and second job HWACTUA2 + HWACTUAL = add a note
		destring HWACTUA2, replace
		gen ilo_joball_how_actual = .
		replace ilo_joball_how_actual = HWACTUA2 if ilo_lfs==1 & EXIST2J == 2
		replace ilo_joball_how_actual = . if ilo_joball_how_actual==99  & ilo_lfs==1
		replace ilo_joball_how_actual = 0 if ilo_joball_how_actual==. & ilo_lfs==1
		replace ilo_joball_how_actual = ilo_joball_how_actual + ilo_job1_how_actual
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
	

		* test if var is should be drop 	
		egen drop_var = mean(ilo_joball_how_actual_bands)
		local Z = drop_var in 1
		if `Z' == 8 {
			drop ilo_joball_how_actual_bands
		}
		drop 	drop_var
		
	* tab  ilo_joball_how_actual_bands [iw = ilo_wgt] if ilo_lfs == 1, m

		
	
		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job1_job_contract')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

* Comment: var TEMP

		gen ilo_job1_job_contract=.
		replace ilo_job1_job_contract=1 if FTPT == 1								// 1 - Permanent
		replace ilo_job1_job_contract=2 if FTPT == 2								// 2 - Temporary
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
	* tab  ilo_job1_job_contract [iw = ilo_wgt] if ilo_lfs == 1, m

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Formal / Informal Economy ('ilo_job1_ife_prod' 'ilo_job1_ife_nature')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			

* Comment: Not enough information to define informal employment / informal sector	
	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Monthly labour related income ('ilo_joball_lri')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
	
* Comment: Not enough information to define labour related income pr wage 
	

***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_joball_tru')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

* Comment: No information
		destring WISHMORE, replace
		destring AVAILBLE, replace
		gen ilo_joball_tru=.
		replace ilo_joball_tru=1 if  AVAILBLE == 1 & WISHMORE == 1 & ilo_joball_how_actual < 35
			lab def lab_joball_tru 1 "Time-related underemployed" 
			lab val ilo_joball_tru lab_joball_tru
			lab var ilo_joball_tru "Time-related underemployed"

		* test if var is should be drop 	
		egen drop_var = mean(ilo_joball_tru)
		local Z = drop_var in 1
		if `Z' == 3 {
			drop ilo_joball_tru
		}
		drop 	drop_var	
			
		* tab  ilo_joball_tru [iw = ilo_wgt] if ilo_lfs == 1, m		
		



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

	destring EXISTPR, replace

		gen ilo_cat_une=.
		replace ilo_cat_une=1 if EXISTPR == 1 & ilo_lfs==2				// 1 - Unemployed previously employed
		replace ilo_cat_une=2 if EXISTPR == 0 & ilo_lfs==2				// 2 - Unemployed seeking their first job
		replace ilo_cat_une=3 if (ilo_cat_une==. & ilo_lfs==2)			// 3 - Unknown
			lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
			    lab values ilo_cat_une cat_une_lab
			    lab var ilo_cat_une "Category of unemployment"
		
		* test if var is should be drop 	
		egen drop_var = mean(ilo_cat_une)
		local prev_une_cat = drop_var in 1
		
		if `prev_une_cat' == 3 {
			drop ilo_cat_une
		}
		drop 	drop_var
		* tab  ilo_cat_une [iw = ilo_wgt] if ilo_lfs == 2, m		

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: due to anonymised microdata DURUNE is reduce to aggregate only

    /* Detailed
		gen ilo_dur_details=.
			replace ilo_dur_details=1 if (unempldur_l==0 & ilo_lfs==2)                  // Less than 1 month
			replace ilo_dur_details=2 if (inlist(unempldur_l,1,2) & ilo_lfs==2)         // 1-2 months
			replace ilo_dur_details=3 if (inlist(unempldur_l,3,4) & ilo_lfs==2)         // 3-5 months
			replace ilo_dur_details=4 if (unempldur_l==8 & ilo_lfs==2)                  // 6-11 months
			replace ilo_dur_details=7 if (ilo_dur_details==.& ilo_lfs==2)   			// Not elsewhere classified
			        lab def ilo_unemp_det 1 "Less than 1 month" 2 "1 month to less than 3 months" 3 "3 months to less than 6 months" ///
										  4 "6 months to less than 12 months" 5 "12 months to less than 24 months" 6 "24 months or more" ///
										  7 "Not elsewhere classified"
				    lab val ilo_dur_details ilo_unemp_det
				    lab var ilo_dur_details "Duration of unemployment (Details)"
	*/
	
    * Aggregate				
		destring DURUNE, replace
		gen ilo_dur_aggregate=.
			replace ilo_dur_aggregate=1 if DURUNE == 1 & ilo_lfs==2						// Less than 6 months
			replace ilo_dur_aggregate=2 if DURUNE == 2 & ilo_lfs==2              		// 6 months to less than 12 months
			replace ilo_dur_aggregate=3 if DURUNE == 3 & ilo_lfs==2 				    // 12 months or more
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
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

* Comment: Dissemination usually in aggregated form: NACEPR1D (for NACE Rev 2), NA11PR1D, NA11PRS (for NACE Rev 1)
* 			NACEPR is aggregated in the anonymised microdata in this way: NACEPR1D (for NACE Rev 2), NA11PR1D, NA11PRS (for NACE Rev 1); see corresponding chapter

		

if (`Y' > 2007 & `prev_une_cat' != 3){	

* ISIC Rev. 4 NACEPR1D
		tostring NACEPR1D, replace
		gen ilo_preveco_isic4=.
			replace ilo_preveco_isic4=1 if NACEPR1D=="A"				// Agriculture, forestry and fishing
			replace ilo_preveco_isic4=2 if NACEPR1D=="B"				// Mining and quarrying
			replace ilo_preveco_isic4=3 if NACEPR1D=="C"				// Manufacturing
			replace ilo_preveco_isic4=4 if NACEPR1D=="D"				// Electricity, gas, steam and air conditioning supply
			replace ilo_preveco_isic4=5 if NACEPR1D=="E"				// Water supply; sewerage, waste management and remediation activities
			replace ilo_preveco_isic4=6 if NACEPR1D=="F"				// Construction
			replace ilo_preveco_isic4=7 if NACEPR1D=="G"          		// Wholesale and retail trade; repair of motor vehicles and motorcycles
			replace ilo_preveco_isic4=8 if NACEPR1D=="H"				// Transportation and storage
			replace ilo_preveco_isic4=9 if NACEPR1D=="I"				// Accommodation and food service activities
			replace ilo_preveco_isic4=10 if NACEPR1D=="J"				// Information and communication
			replace ilo_preveco_isic4=11 if NACEPR1D=="K"				// Financial and insurance activities	
			replace ilo_preveco_isic4=12 if NACEPR1D=="L"				// Real estate activities
			replace ilo_preveco_isic4=13 if NACEPR1D=="M"				// Professional, scientific and technical activities
			replace ilo_preveco_isic4=14 if NACEPR1D=="N"				// Administrative and support service activities
			replace ilo_preveco_isic4=15 if NACEPR1D=="O"				// Public administration and defence; compulsory social security
			replace ilo_preveco_isic4=16 if NACEPR1D=="P"				// Education
			replace ilo_preveco_isic4=17 if NACEPR1D=="Q"				// Human health and social work activities
			replace ilo_preveco_isic4=18 if NACEPR1D=="R"				// Arts, entertainment and recreation
			replace ilo_preveco_isic4=19 if NACEPR1D=="S"				// Other service activities
			replace ilo_preveco_isic4=20 if NACEPR1D=="T"				// Activities of households as employers; undifferentiated goods- and services-producing activities of households for own use
			replace ilo_preveco_isic4=21 if NACEPR1D=="U"				// Activities of extraterritorial organizations and bodies
			replace ilo_preveco_isic4=22 if NACEPR1D=="9"	& ilo_cat_une == 1	    // Not elsewhere classified
			replace ilo_preveco_isic4=22 if ilo_preveco_isic4==. & ilo_cat_une == 1
				lab val ilo_preveco_isic4 eco_isic4_lab
				lab var ilo_preveco_isic4 "Previous economic activity (ISIC Rev. 4)"
			
			
	* Now do the classification on an aggregate level
	
		* Primary activity
		
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

		* test if var is should be drop 	
		egen drop_var = mean(ilo_preveco_aggregate)
		local Z = drop_var in 1
		if `Z' == 7 {
			drop ilo_preveco_aggregate ilo_preveco_isic4
		}
		drop 	drop_var
	
	
}

* tab  ilo_preveco_isic4 [iw = ilo_wgt] if ilo_lfs == 2, m
		
	
if (`Y' < 2008 & `prev_une_cat' != 3) {			
		
* ISIC Rev. 3.1 NA11PR1D
tostring NA11PR1D, replace
gen ilo_preveco_isic3=.
		replace ilo_preveco_isic3=1 if NA11PR1D=="A"					// Agriculture, hunting and forestry
		replace ilo_preveco_isic3=2 if NA11PR1D=="B"					// Fishing
		replace ilo_preveco_isic3=3 if NA11PR1D=="C"					// Mining and quarrying
		replace ilo_preveco_isic3=4 if NA11PR1D=="D"					// Manufacturing
		replace ilo_preveco_isic3=5 if NA11PR1D=="E"					// Electricity, gas and water supply
		replace ilo_preveco_isic3=6 if NA11PR1D=="F"					// Construction
		replace ilo_preveco_isic3=7 if NA11PR1D=="G"					// Wholesale and retail trade; repair of motor vehicles, motorcycles and personal and household goods
		replace ilo_preveco_isic3=8 if NA11PR1D=="H"					// Hotels and restaurants
		replace ilo_preveco_isic3=9 if NA11PR1D=="I"					// Transport, storage and communications
		replace ilo_preveco_isic3=10 if NA11PR1D=="J"					// Financial intermediation
		replace ilo_preveco_isic3=11 if NA11PR1D=="K"					// Real estate, renting and business activities
		replace ilo_preveco_isic3=12 if NA11PR1D=="L"					// Public administration and defence; compulsory social security
		replace ilo_preveco_isic3=13 if NA11PR1D=="M"					// Education
		replace ilo_preveco_isic3=14 if NA11PR1D=="N"					// Health and social work
		replace ilo_preveco_isic3=15 if NA11PR1D=="O"					// Other community, social and personal service activities
		replace ilo_preveco_isic3=16 if NA11PR1D=="P"					// Activities of private households as employers and undifferentiated production activities of private households
		replace ilo_preveco_isic3=17 if NA11PR1D=="Q"					// Extraterritorial organizations and bodies
		replace ilo_preveco_isic3=18 if NA11PR1D=="9" & ilo_cat_une == 1	  	// Not elsewhere classified
		replace ilo_preveco_isic3=18 if ilo_preveco_isic3==. & ilo_cat_une == 1	   
			lab val ilo_preveco_isic3 eco_isic3_lab
			lab var ilo_preveco_isic3 "Economic activity (ISIC Rev. 3.1)"
			
	* Now do the classification on an aggregate level
	
	* Primary activity
	
	gen ilo_preveco_aggregate=.
		replace ilo_preveco_aggregate=1 if inlist(ilo_preveco_isic3,1,2)
		replace ilo_preveco_aggregate=2 if ilo_preveco_isic3==4
		replace ilo_preveco_aggregate=3 if ilo_preveco_isic3==6
		replace ilo_preveco_aggregate=4 if inlist(ilo_preveco_isic3,3,5)
		replace ilo_preveco_aggregate=5 if inrange(ilo_preveco_isic3,7,11)
		replace ilo_preveco_aggregate=6 if inrange(ilo_preveco_isic3,12,17)
		replace ilo_preveco_aggregate=7 if ilo_preveco_isic3==18
			lab val ilo_preveco_aggregate eco_aggr_lab
			lab var ilo_preveco_aggregate "Previous economic activity (Aggregate)"

		* test if var is should be drop 	
		egen drop_var = mean(ilo_preveco_aggregate)
		local Z = drop_var in 1
		if `Z' == 7 {
			drop ilo_preveco_aggregate ilo_preveco_isic3
		}
		drop 	drop_var
		
		
}
			
				
* tab  ilo_preveco_isic3 [iw = ilo_wgt] if ilo_lfs == 2, m

		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

* Comment: Dissemination usually in aggregated form: ISCOPR1D
* 			ISCOPR is available in the anonymised microdata in this way: ISCOPR1D, ISCOPR3D for ISCO-08 from 2011 onwards, IS88PR1D, IS88PR3D for ISCO-88(COM) until 2010 – see corresponding chapter for some country-specific aggregations

	
if (`Y' > 2010 & `prev_une_cat' != 3){	
		
		* ISCO 08 - 1 digit ISCOPR3D

	gen  ilo_prevocu_isco08=.
	destring ISCOPR3D, replace
	
	replace ilo_prevocu_isco08=int(ISCOPR3D/100) if ilo_cat_une == 1	    
	
	replace ilo_prevocu_isco08=10 if ilo_prevocu_isco08==0 & ilo_cat_une == 1
	replace ilo_prevocu_isco08=11 if ilo_prevocu_isco08== 99 & ilo_cat_une == 1	
	replace ilo_prevocu_isco08=11 if !inrange(ilo_prevocu_isco08, 1, 11) & ilo_cat_une == 1	
				lab val ilo_prevocu_isco08 ocu_isco08_lab
				lab var ilo_prevocu_isco08 "Previous occupation (ISCO-08)"	
		
	  * Aggregate
	  gen ilo_prevocu_aggregate=.
		  replace ilo_prevocu_aggregate=1 if inrange(ilo_prevocu_isco08,1,3)   
		  replace ilo_prevocu_aggregate=2 if inlist(ilo_prevocu_isco08,4,5)
		  replace ilo_prevocu_aggregate=3 if inlist(ilo_prevocu_isco08,6,7)
		  replace ilo_prevocu_aggregate=4 if ilo_prevocu_isco08==8
		  replace ilo_prevocu_aggregate=5 if ilo_prevocu_isco08==9
		  replace ilo_prevocu_aggregate=6 if ilo_prevocu_isco08==10
		  replace ilo_prevocu_aggregate=7 if ilo_prevocu_isco08==11
				  lab val ilo_prevocu_aggregate ocu_aggr_lab
				  lab var ilo_prevocu_aggregate "Previous occupation (Aggregate)"	
		
	  * Skill level
	  gen ilo_prevocu_skill=.
		  replace ilo_prevocu_skill=1 if ilo_prevocu_isco08==9                   // Low
		  replace ilo_prevocu_skill=2 if inlist(ilo_prevocu_isco08,4,5,6,7,8)    // Medium
		  replace ilo_prevocu_skill=3 if inlist(ilo_prevocu_isco08,1,2,3)        // High
		  replace ilo_prevocu_skill=4 if inlist(ilo_prevocu_isco08,10,11)        // Not elsewhere classified
				  lab val ilo_prevocu_skill ocu_skill_lab
				  lab var ilo_prevocu_skill "Previous occupation occupation (Skill level)"
		
		* test if var is should be drop 	
		egen drop_var = mean(ilo_prevocu_aggregate)
		local Z = drop_var in 1
		if `Z' == 7 {
			drop ilo_prevocu_aggregate ilo_prevocu_isco08 ilo_prevocu_skill
		}
		drop 	drop_var				  
	 * tab  ilo_prevocu_isco08 [iw = ilo_wgt] if ilo_cat_une == 1	, m

				  
}				  





if (`Y' < 2011 & `prev_une_cat' != 3) {			
	
	* ISCO1D
	* Two digit level:
	
	gen  ilo_prevocu_isco88=.
	destring IS88PR3D, replace
	
	replace ilo_prevocu_isco88=int(IS88PR3D/100) if ilo_cat_une == 1	    
	
	replace ilo_prevocu_isco88=10 if ilo_prevocu_isco88==0 & ilo_cat_une == 1
	replace ilo_prevocu_isco88=11 if ilo_prevocu_isco88== 99 & ilo_cat_une == 1	
	replace ilo_prevocu_isco88=11 if !inrange(ilo_prevocu_isco88, 1, 11) & ilo_cat_une == 1	
				lab val ilo_prevocu_isco88 ocu_isco88_lab
				lab var ilo_prevocu_isco88 "Previous occupation (ISCO-08)"	
		
	  * Aggregate
	  gen ilo_prevocu_aggregate=.
		  replace ilo_prevocu_aggregate=1 if inrange(ilo_prevocu_isco88,1,3)   
		  replace ilo_prevocu_aggregate=2 if inlist(ilo_prevocu_isco88,4,5)
		  replace ilo_prevocu_aggregate=3 if inlist(ilo_prevocu_isco88,6,7)
		  replace ilo_prevocu_aggregate=4 if ilo_prevocu_isco88==8
		  replace ilo_prevocu_aggregate=5 if ilo_prevocu_isco88==9
		  replace ilo_prevocu_aggregate=6 if ilo_prevocu_isco88==10
		  replace ilo_prevocu_aggregate=7 if ilo_prevocu_isco88==11
				  lab val ilo_prevocu_aggregate ocu_aggr_lab
				  lab var ilo_prevocu_aggregate "Previous occupation (Aggregate)"	
		
	  * Skill level
	  gen ilo_prevocu_skill=.
		  replace ilo_prevocu_skill=1 if ilo_prevocu_isco88==9                   // Low
		  replace ilo_prevocu_skill=2 if inlist(ilo_prevocu_isco88,4,5,6,7,8)    // Medium
		  replace ilo_prevocu_skill=3 if inlist(ilo_prevocu_isco88,1,2,3)        // High
		  replace ilo_prevocu_skill=4 if inlist(ilo_prevocu_isco88,10,11)        // Not elsewhere classified
				  lab val ilo_prevocu_skill ocu_skill_lab
				  lab var ilo_prevocu_skill "Previous occupation occupation (Skill level)"

		* test if var is should be drop 	
		egen drop_var = mean(ilo_prevocu_aggregate)
		local Z = drop_var in 1
		if `Z' == 7 {
			drop ilo_prevocu_aggregate ilo_prevocu_isco88 ilo_prevocu_skill
		}
		drop 	drop_var
				  
	 * tab  ilo_prevocu_isco88 [iw = ilo_wgt] if ilo_cat_une == 1	, m


	
}
			  
				  


***********************************************************************************************
*			PART 3.4. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		.
* 2003 onwards

if `Y' > 1997 {

		destring WANTWORK, replace 
		gen ilo_olf_dlma=. 
		


		// 1 - Seeking, not available (Unavailable jobseekers)
		replace ilo_olf_dlma=1 if (ILOSTAT == 3 & SEEKWORK == 4 & AVAILBLE == 1)			/* seeking work passively, available*/
		replace ilo_olf_dlma=1 if (ILOSTAT == 3 & SEEKWORK == 4 & AVAILBLE == 2 & (METHODA==1 | METHODB==1 | METHODC==1 | METHODD==1 | METHODE==1 | METHODF==1 | METHODG==1 | METHODH==1 | METHODI==1 | METHODM==1))			/*seeking work actively, not available*/
		replace ilo_olf_dlma=1 if (ILOSTAT == 3 & SEEKWORK == 1 & AVAILBLE == 2)
		
		replace ilo_olf_dlma=2 if (ILOSTAT == 3 & AVAILBLE == 1 & SEEKWORK == 3)			// 2 - Not seeking, available (Available potential jobseekers)
		replace ilo_olf_dlma=2 if (ILOSTAT == 3 & SEEKWORK == 4 & AVAILBLE == 1)			/* seeking work passively, available*/
		replace ilo_olf_dlma=3 if (ILOSTAT == 3 & SEEKWORK == 3 & AVAILBLE == 2 & WANTWORK == 1) // 3 - Not seeking, not available, willing (Willing non-jobseekers)
		replace ilo_olf_dlma=3 if (ILOSTAT == 3 & SEEKWORK == 3 & AVAILBLE == 2 & WANTWORK == 2) // 4 - Not seeking, not available, not willing
		replace ilo_olf_dlma=4 if (ILOSTAT == 3 & ilo_olf_dlma==.)
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
}			
	
	* tab  ilo_olf_dlma [iw = ilo_wgt] , m	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reason for not seeking job ('ilo_olf_reason')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

* Comment: No information
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seeker ('ilo_dis')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

   capture destring todrop_2, replace force
   capture gen todrop_2=-9999
   local Q = todrop_2 in 1
   
    *-- quarterly data drop  
	if !inlist(`Q',1,2,3,4){
		destring SEEKWORK, replace
		destring WANTWORK, replace
		destring SEEKREAS, replace
		destring AVAILBLE, replace
		gen ilo_dis = .
		replace ilo_dis=1 if (SEEKWORK == 3 & WANTWORK  == 1 & SEEKREAS == 7 & AVAILBLE == 1 & ILOSTAT==3)
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
	}


		
	* tab  ilo_dis [iw = ilo_wgt] , m	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training ('ilo_neet')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* 2003 onwards

if `Y' > 2003 {	
		gen ilo_neet = .
		replace ilo_neet=1 if (ilo_age_aggregate==2 & EDUCSTAT  == 2 & COURATT == 2 & !inlist(ILOSTAT,1,4,9))
			lab def neet_lab 1 "Youth not in education, employment or training"
			lab val ilo_neet neet_lab
			lab var ilo_neet "Youth not in education, employment or training"
		* test if var is should be drop 	
		egen drop_var = mean(ilo_neet)
		local Z = drop_var in 1
		if `Z' == . {
			drop ilo_neet
		}
		drop 	drop_var
	* tab  ilo_neet [iw = ilo_wgt] , m		
}			


			  
	

		
	
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
local prev_une_cat


* -------------------------------------------------------------
* 	Prepare final datasets
* -------------------------------------------------------------

cd "$outpath"
		
		/* Only age bands used */
		drop ilo_age
		drop if ilo_sex==. 
		
		compress 
		
		/*Save dataset including original and ilo variables*/
	
		save ${country}_${source}_${time}_FULL,  replace		

		/* Save file only containing ilo_* variables*/
	
		keep ilo*

		save ${country}_${source}_${time}_ILO, replace
