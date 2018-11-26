* TITLE OF DO FILE: ILO Microdata Preprocessing code template - United Kingdom LFS
* DATASET USED: Great Britain LFS 2017Q2
* NOTES:
* Authors: ILO / Department of Statistics / DPAU

* Starting Date: 08/11/2017
* Last updated: 08 February 2018
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
global country "GBR"
global source "LFS"
global time "2017Q2"
global inputFile "lfsp_aj17_eul.dta"
global inpath "${path}\\${country}\\${source}\\${time}\ORI"
global outpath "${path}\\${country}\\${source}\\${time}"



********************************************************************************
********************************************************************************

cd "$inpath"
	use ${inputFile}, clear
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


if todrop != "2016Q1" & todrop != "2013Q2" {

gen Z = "07"
	replace Z = "14" if Z != "07"
	replace Z = "16" if !inlist(Z,"07","14")
	replace Z = "17" if !inlist(Z,"07","14","16")

 
gen ilo_wgt=.
      	   replace ilo_wgt = pwt`Z'
               lab var ilo_wgt "Sample weight"

}




if todrop == "2016Q1" | todrop == "2013Q2" {

gen ilo_wgt=.
      	   replace ilo_wgt = phhwt16
               lab var ilo_wgt "Sample weight"

}


			   
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

** Comment: no information
		
	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
 
	gen ilo_sex = sex
		lab def ilo_sex_lab 1 "1 - Male" 2 "2 - Female"
		lab var ilo_sex "Sex"
		lab val ilo_sex ilo_sex_lab

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_age = age
	    lab var ilo_age "Age"


* Age groups

	gen ilo_age_5yrbands =.
		replace ilo_age_5yrbands = 1 if inrange(ilo_age,0,4)
		replace ilo_age_5yrbands = 2 if inrange(ilo_age,5,9)
		replace ilo_age_5yrbands = 3 if inrange(ilo_age,10,14)
		replace ilo_age_5yrbands = 4 if inrange(ilo_age,15,19)
		replace ilo_age_5yrbands = 5 if inrange(ilo_age,20,24)
		replace ilo_age_5yrbands = 6 if inrange(ilo_age,25,29)
		replace ilo_age_5yrbands = 7 if inrange(ilo_age,30,34)
		replace ilo_age_5yrbands = 8 if inrange(ilo_age,35,39)
		replace ilo_age_5yrbands = 9 if inrange(ilo_age,40,44)
		replace ilo_age_5yrbands = 10 if inrange(ilo_age,45,49)
		replace ilo_age_5yrbands = 11 if inrange(ilo_age,50,54)
		replace ilo_age_5yrbands = 12 if inrange(ilo_age,55,59)
		replace ilo_age_5yrbands = 13 if inrange(ilo_age,60,64)
		replace ilo_age_5yrbands = 14 if ilo_age >= 65 & ilo_age != .
			    lab def age_by5_lab 1 "0-4" 2 "5-9" 3 "10-14" 4 "15-19" 5 "20-24" 6 "25-29" ///
								    7 "30-34" 8 "35-39" 9 "40-44" 10 "45-49" 11 "50-54" 12 "55-59" ///
								    13 "60-64" 14 "65+"
			    lab val ilo_age_5yrbands age_by5_lab
			    lab var ilo_age_5yrbands "Age (5-year age bands)"
			
			
			
	gen ilo_age_10yrbands = .
		replace ilo_age_10yrbands = 1 if inrange(ilo_age,0,14)
		replace ilo_age_10yrbands = 2 if inrange(ilo_age,15,24)
		replace ilo_age_10yrbands = 3 if inrange(ilo_age,25,34)
		replace ilo_age_10yrbands = 4 if inrange(ilo_age,35,44)
		replace ilo_age_10yrbands = 5 if inrange(ilo_age,45,54)
		replace ilo_age_10yrbands = 6 if inrange(ilo_age,55,64)
		replace ilo_age_10yrbands = 7 if ilo_age >= 65 & ilo_age != .
			    lab def age_by10_lab 1 "<15" 2 "15-24" 3 "25-34" 4 "35-44" 5 "45-54" 6 "55-64" 7 "65+"
			    lab val ilo_age_10yrbands age_by10_lab
			    lab var ilo_age_10yrbands "Age (10-year age bands)"
	
	
	gen ilo_age_aggregate = .
		replace ilo_age_aggregate = 1 if inrange(ilo_age,0,14)
		replace ilo_age_aggregate = 2 if inrange(ilo_age,15,24)
		replace ilo_age_aggregate = 3 if inrange(ilo_age,25,54)
		replace ilo_age_aggregate = 4 if inrange(ilo_age,55,64)
		replace ilo_age_aggregate = 5 if ilo_age >= 65 & ilo_age != .
		    	lab def age_aggr_lab 1 "<15" 2 "15-24" 3 "25-54" 4 "55-64" 5 "65+"
			    lab val ilo_age_aggregate age_aggr_lab
			    lab var ilo_age_aggregate "Age (Aggregate)"
	


	
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education ('ilo_edu')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

 
 
if `Y' > 2014 {
gen ilo_edu_isced11=.
		replace ilo_edu_isced11=1 if hiqual15 == 84                                                // No schooling
		replace ilo_edu_isced11=2 if inrange(hiqual15,56,82)                                       // Early childhood education
		replace ilo_edu_isced11=3 if inrange(hiqual15,27,55)                                       // Primary education 
		*replace ilo_edu_isced11=4 if                                                              // Lower secondary education
		replace ilo_edu_isced11=5 if inrange(hiqual15,10,26)                                       // Upper secondary education
		*replace ilo_edu_isced11=6 if                                                              // Post-secodary non-tertiary education
		replace ilo_edu_isced11=7 if inrange(hiqual15,2,9)                                         // Short-cycle tertiary education
 		replace ilo_edu_isced11=8 if hiqual15 == 1 & inlist(higho,3,4)                             // Bachelor's or equivalent level
        replace ilo_edu_isced11=9 if hiqual15 == 1 & higho == 2                                    // Master's or equivalent level
		replace ilo_edu_isced11=10 if hiqual15 == 1 & higho == 1                                   // Doctoral or equivalent level
 		replace ilo_edu_isced11=11 if inlist(hiqual15,-8,-9, 83,85)                                // Not elsewhere classified
 		replace ilo_edu_isced11=11 if hiqual15 == 1 & !inrange(higho,1,4)                          // Not elsewhere classified
		replace ilo_edu_isced11=11 if  ilo_edu_isced11==. & age !=.                                // Not elsewhere classified

			
	}		

	
	 
if `Y' < 2015 & `Y' > 2010 {
gen ilo_edu_isced11=.
		replace ilo_edu_isced11=1 if hiqual11 == 79                                               // No schooling
		replace ilo_edu_isced11=2 if inrange(hiqual11,55,77)                                       // Early childhood education
		replace ilo_edu_isced11=3 if inrange(hiqual11,27,54)                                       // Primary education 
		*replace ilo_edu_isced11=4 if                                                              // Lower secondary education
		replace ilo_edu_isced11=5 if inrange(hiqual11,1,26)                                       // Upper secondary education
		*replace ilo_edu_isced11=6 if                                                              // Post-secodary non-tertiary education
		replace ilo_edu_isced11=7 if inrange(hiqual11,2,9)                                         // Short-cycle tertiary education
 		replace ilo_edu_isced11=8 if hiqual11 == 1 & inlist(higho,3,4)                             // Bachelor's or equivalent level
        replace ilo_edu_isced11=9 if hiqual11 == 1 & higho == 2                                    // Master's or equivalent level
		replace ilo_edu_isced11=10 if hiqual11 == 1 & higho == 1                                   // Doctoral or equivalent level
 		replace ilo_edu_isced11=11 if inlist(hiqual11,-8,-9, 78,80)                                 // Not elsewhere classified
 		replace ilo_edu_isced11=11 if hiqual11 == 1 & !inrange(higho,1,4)                          // Not elsewhere classified
		replace ilo_edu_isced11=11 if hiqual11 == 1 & !inrange(higho,1,4)                          // Not elsewhere classified
		replace ilo_edu_isced11=11 if  ilo_edu_isced11==. & age !=.                                // Not elsewhere classified
	 
			
	}		
	
	
if `Y' < 2011 & `Y' > 2007   {
gen ilo_edu_isced11=.
		replace ilo_edu_isced11=1 if hiqual8 == 49                                                // No schooling
		replace ilo_edu_isced11=2 if inrange(hiqual8,35,47)                                       // Early childhood education
		replace ilo_edu_isced11=3 if inrange(hiqual8,16,34)                                       // Primary education 
		*replace ilo_edu_isced11=4 if                                                              // Lower secondary education
		replace ilo_edu_isced11=5 if inrange(hiqual8,5,15)                                       // Upper secondary education
		*replace ilo_edu_isced11=6 if                                                              // Post-secodary non-tertiary education
		replace ilo_edu_isced11=7 if inrange(hiqual8,2,4)                                         // Short-cycle tertiary education
 		replace ilo_edu_isced11=8 if hiqual8 == 1 & inlist(higho,3,4)                             // Bachelor's or equivalent level
        replace ilo_edu_isced11=9 if hiqual8 == 1 & higho == 2                                    // Master's or equivalent level
		replace ilo_edu_isced11=10 if hiqual8 == 1 & higho == 1                                   // Doctoral or equivalent level
 		replace ilo_edu_isced11=11 if inlist(hiqual8,-8,-9, 48,50)                                 // Not elsewhere classified
 		replace ilo_edu_isced11=11 if hiqual8 == 1 & !inrange(higho,1,4)                          // Not elsewhere classified
		replace ilo_edu_isced11=11 if hiqual8 == 1 & !inrange(higho,1,4)                          // Not elsewhere classified
		replace ilo_edu_isced11=11 if  ilo_edu_isced11==. & age !=.                                // Not elsewhere classified
	 
			
	}	
	
if `Y' < 2008 & todrop >= "2005Q2" {
gen ilo_edu_isced11=.
		replace ilo_edu_isced11=1 if hiqual5 == 49                                                // No schooling
		replace ilo_edu_isced11=2 if inrange(hiqual5,35,47)                                       // Early childhood education
		replace ilo_edu_isced11=3 if inrange(hiqual5,16,34)                                       // Primary education 
		*replace ilo_edu_isced11=4 if                                                              // Lower secondary education
		replace ilo_edu_isced11=5 if inrange(hiqual5,5,15)                                       // Upper secondary education
		*replace ilo_edu_isced11=6 if                                                              // Post-secodary non-tertiary education
		replace ilo_edu_isced11=7 if inrange(hiqual5,2,4)                                         // Short-cycle tertiary education
 		replace ilo_edu_isced11=8 if hiqual5 == 1 & inlist(higho,3,4)                             // Bachelor's or equivalent level
        replace ilo_edu_isced11=9 if hiqual5 == 1 & higho == 2                                    // Master's or equivalent level
		replace ilo_edu_isced11=10 if hiqual5 == 1 & higho == 1                                   // Doctoral or equivalent level
 		replace ilo_edu_isced11=11 if inlist(hiqual5,-8,-9, 48,50)                                 // Not elsewhere classified
 		replace ilo_edu_isced11=11 if hiqual5 == 1 & !inrange(higho,1,4)                          // Not elsewhere classified
		replace ilo_edu_isced11=11 if hiqual5 == 1 & !inrange(higho,1,4)                          // Not elsewhere classified
		replace ilo_edu_isced11=11 if  ilo_edu_isced11==. & age !=.                                // Not elsewhere classified
			
	}
	

if todrop <= "2005Q1" & todrop >= "2004Q2" {
gen ilo_edu_isced11=.
		replace ilo_edu_isced11=1 if hiqual4 == 45                                                // No schooling
		replace ilo_edu_isced11=2 if inrange(hiqual4,32,43)                                       // Early childhood education
		replace ilo_edu_isced11=3 if inrange(hiqual4,16,31)                                       // Primary education 
		*replace ilo_edu_isced11=4 if                                                              // Lower secondary education
		replace ilo_edu_isced11=5 if inrange(hiqual4,5,15)                                       // Upper secondary education
		*replace ilo_edu_isced11=6 if                                                              // Post-secodary non-tertiary education
		replace ilo_edu_isced11=7 if inrange(hiqual4,2,4)                                         // Short-cycle tertiary education
 		replace ilo_edu_isced11=8 if hiqual4 == 1 & inlist(higho,3,4)                             // Bachelor's or equivalent level
        replace ilo_edu_isced11=9 if hiqual4 == 1 & higho == 2                                    // Master's or equivalent level
		replace ilo_edu_isced11=10 if hiqual4 == 1 & higho == 1                                   // Doctoral or equivalent level
 		replace ilo_edu_isced11=11 if inlist(hiqual4,-8,-9, 48,50)                                 // Not elsewhere classified
 		replace ilo_edu_isced11=11 if hiqual4 == 1 & !inrange(higho,1,4)                          // Not elsewhere classified
		replace ilo_edu_isced11=11 if hiqual4 == 1 & !inrange(higho,1,4)                          // Not elsewhere classified
		replace ilo_edu_isced11=11 if  ilo_edu_isced11==. & age !=.                                // Not elsewhere classified
			
	}
	
	
if todrop <= "2003Q4"   {
gen ilo_edu_isced11=.
		replace ilo_edu_isced11=1 if hiqual == 40                                                // No schooling
		replace ilo_edu_isced11=2 if inrange(hiqual,30,38)                                       // Early childhood education
		replace ilo_edu_isced11=3 if inrange(hiqual,15,29)                                       // Primary education 
		*replace ilo_edu_isced11=4 if                                                              // Lower secondary education
		replace ilo_edu_isced11=5 if inrange(hiqual,5,14)                                       // Upper secondary education
		*replace ilo_edu_isced11=6 if                                                              // Post-secodary non-tertiary education
		replace ilo_edu_isced11=7 if inrange(hiqual,2,4)                                         // Short-cycle tertiary education
 		replace ilo_edu_isced11=8 if hiqual == 1 & inlist(higho,3,4)                             // Bachelor's or equivalent level
        replace ilo_edu_isced11=9 if hiqual == 1 & higho == 2                                    // Master's or equivalent level
		replace ilo_edu_isced11=10 if hiqual == 1 & higho == 1                                   // Doctoral or equivalent level
 		replace ilo_edu_isced11=11 if inlist(hiqual,-8,-9, 39,41)                                 // Not elsewhere classified
 		replace ilo_edu_isced11=11 if hiqual == 1 & !inrange(higho,1,4)                          // Not elsewhere classified
		replace ilo_edu_isced11=11 if  ilo_edu_isced11==. & age !=.                                // Not elsewhere classified
			
	}
	
	
	
	
	label def isced_11_lab 1 "X - No schooling" 2 "0 - Early childhood education" 3 "1 - Primary education" 4 "2 - Lower secondary education" 5 "3 - Upper secondary education" ///
								6 "4 - Post-secondary non-tertiary education" 7 "5 - Short-cycle tertiary education" 8 "6 - Bachelor's or equivalent level" 9 "7 - Master's or equivalent level" ///
								10 "8 - Doctoral or equivalent level" 11 "9 - Not elsewhere classified"
			label val ilo_edu_isced11 isced_11_lab
			lab var ilo_edu_isced11 "Education (ISCED 11)"
	
	
	
	
 
			
* Aggregate
			
	gen ilo_edu_aggregate=.
		replace ilo_edu_aggregate=1 if inlist(ilo_edu_isced11,1,2)
		replace ilo_edu_aggregate=2 if inlist(ilo_edu_isced11,3,4)
		replace ilo_edu_aggregate=3 if inlist(ilo_edu_isced11,5,6)
		replace ilo_edu_aggregate=4 if inlist(ilo_edu_isced11,7,8,9,10)
		replace ilo_edu_aggregate=5 if ilo_edu_isced11==11
			label def edu_aggr_lab 1 "1 - Less than basic" 2 "2 - Basic" 3 "3 - Intermediate" 4 "4 - Advanced" 5 "5 - Level not stated"
			label val ilo_edu_aggregate edu_aggr_lab
			label var ilo_edu_aggregate "Education (Aggregate level)"

 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education attendance ('ilo_edu_attendance')    
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

  
gen ilo_edu_attendance = .
		replace ilo_edu_attendance = 1 if  enroll==1                                                                  // 1 - Attending
		replace ilo_edu_attendance = 2 if enroll==2                                                                  //  2 - Not attending
	    replace ilo_edu_attendance = 3 if ilo_edu_attendance == .                                                     // 3 - Not elsewhere classified
			lab def edu_attendance_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
			lab val ilo_edu_attendance edu_attendance_lab
			lab var ilo_edu_attendance "Education (Attendance)"

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			           Marital status ('ilo_mrts') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 

if `Y' > 2005 {
 gen mrt = marsta

}	

if `Y' < 2006 {
* Comment: before 2006, there are no information on civil union in the marital status variable
 gen mrt = marstt 	

} 
	* Detailed
	gen ilo_mrts_details=.
	    replace ilo_mrts_details=1 if mrt==1                                 // Single
		replace ilo_mrts_details=2 if mrt==2                                 // Married
		replace ilo_mrts_details=3 if mrt==6                                 // Union / cohabiting
		replace ilo_mrts_details=4 if mrt==5                                 // Widowed
		replace ilo_mrts_details=5 if inlist(mrt,3,4)                        // Divorced / separated
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

			
						

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Disability status ('ilo_dsb')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		



if todrop >= "2014Q4" { 
gen ilo_dsb_aggregate = .
	replace ilo_dsb_aggregate = 2 if disea == 1                                // "Persons with disability"
	replace ilo_dsb_aggregate = 1 if inlist(disea,-8,-9,2)                     // "Persons without disability"
	replace ilo_dsb_aggregate = 1 if ilo_dsb_aggregate == . & age != .          // "Persons without disability"


	lab def dsb_aggregate_lab 1 "Persons without disability" 2 "Persons with disability"  
			lab val ilo_dsb_aggregate   dsb_aggregate_lab
			lab var ilo_dsb_aggregate "Education (Attendance)"


 }
 
 
 if todrop <= "2013Q1" { 
gen ilo_dsb_aggregate = .
	replace ilo_dsb_aggregate = 2 if inrange(discurr,1,3)          // "Persons with disability" 
	replace ilo_dsb_aggregate = 1 if inlist(discurr,-9,4)          // "Persons without disability"
	replace ilo_dsb_aggregate = 1 if ilo_dsb_aggregate == . & age != .          // "Persons without disability"

	lab def dsb_aggregate_lab 1 "Persons without disability" 2 "Persons with disability"  
			lab val ilo_dsb_aggregate   dsb_aggregate_lab
			lab var ilo_dsb_aggregate "Education (Attendance)"

 }
 

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


** WAP >=16 yr

	gen ilo_wap =.
		replace ilo_wap = 1 if ilo_age >= 15 & ilo_age !=.	// Working age population
			label def ilo_wap_lab 1 "Working age population"
			label val ilo_wap ilo_wap_lab
			label var ilo_wap "Working age population"


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Labour Force Status ('ilo_lfs')     
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
 
 ** WAP >= 16 yr


gen ilo_lfs =.

 
		** EMPLOYED  
		
 ** Comment: the figure is not exactly the same reported for the Office of National Statistics (UK)
 
 if `Y' > 2011 {
 
 ** Comment: they include in the assessment of employed, people working for a voluntary organisation/charity (typsch12==3), who are not reciving any weekly pay (netwk does not apply) 
  
  
		replace ilo_lfs = 1 if wrking == 1 &  ilo_wap == 1   // whether did paid work in reference week
		replace ilo_lfs = 1 if jbaway == 1 & ilo_wap == 1 // not working in reference week - away from job (abscent)
		replace ilo_lfs = 1 if ownbus == 1 & ilo_wap == 1 // unpaid work for own business
		replace ilo_lfs = 1 if relbus == 1 & ilo_wap == 1 // unpaid work for relatives business
		replace ilo_lfs = 1 if inlist(typsch12,1,2,3,5,8) & ilo_wap == 1 // employer of work scheme (working for an employer/voluntary organisation/community work)
      	replace ilo_lfs = 1 if ytetjb == 1 & ilo_wap == 1 				   		   

}
				 
				 
				 
if `Y' < 2012 & `Y' > 2009 {

		replace ilo_lfs = 1 if wrking == 1 &  ilo_wap == 1   // whether did paid work in reference week
		replace ilo_lfs = 1 if jbaway == 1 & ilo_wap == 1 // not working in reference week - away from job (abscent)
		replace ilo_lfs = 1 if ownbus == 1 & ilo_wap == 1 // unpaid work for own business
		replace ilo_lfs = 1 if relbus == 1 & ilo_wap == 1 // unpaid work for relatives business
		replace ilo_lfs = 1 if inlist(newdea10,3,4,5,7) & ilo_wap == 1 // working in public/private sector, voluntary task force, environmental task force, assisted self employment
      	replace ilo_lfs = 1 if (ytetjb == 1 & inlist(newdea10,1,6,8,9,19))  & ilo_wap == 1 // work done in addition to that done on New Deal Scheme
 		replace ilo_lfs = 1 if inlist(ytetmp,1,2,4)& ilo_wap == 1 // Unemployed in ref wk-left last job within 8 yrs of ref wk



} 		



if `Y' < 2010 & `Y' > 2003 {

		replace ilo_lfs = 1 if wrking == 1 &  ilo_wap == 1   // whether did paid work in reference week
		replace ilo_lfs = 1 if jbaway == 1 & ilo_wap == 1 // not working in reference week - away from job (abscent)
		replace ilo_lfs = 1 if ownbus == 1 & ilo_wap == 1 // unpaid work for own business
		replace ilo_lfs = 1 if relbus == 1 & ilo_wap == 1 // unpaid work for relatives business
		replace ilo_lfs = 1 if inlist(newdea4,3,4,5,7) & ilo_wap == 1 // working in public/private sector, voluntary task force, environmental task force, assisted self employment
      	replace ilo_lfs = 1 if (ytetjb == 1 & inlist(newdea4,1,6,8,9,19))  & ilo_wap == 1 // work done in addition to that done on New Deal Scheme
 		replace ilo_lfs = 1 if inlist(ytetmp,1,2,4)& ilo_wap == 1 // Unemployed in ref wk-left last job within 8 yrs of ref wk



} 				 		 


if `Y' < 2004 {

		replace ilo_lfs = 1 if wrking == 1 &  ilo_wap == 1   // whether did paid work in reference week
		replace ilo_lfs = 1 if jbaway == 1 & ilo_wap == 1 // not working in reference week - away from job (abscent)
		replace ilo_lfs = 1 if ownbus == 1 & ilo_wap == 1 // unpaid work for own business
		replace ilo_lfs = 1 if relbus == 1 & ilo_wap == 1 // unpaid work for relatives business
		replace ilo_lfs = 1 if inlist(newdeal,3,4,5,7) & ilo_wap == 1 // working in public/private sector, voluntary task force, environmental task force, assisted self employment
      	replace ilo_lfs = 1 if (ytetjb == 1 & inlist(newdeal,1,6,19))  & ilo_wap == 1 // work done in addition to that done on New Deal Scheme
 		replace ilo_lfs = 1 if inlist(ytetmp,1,2,4)& ilo_wap == 1 // Unemployed in ref wk-left last job within 8 yrs of ref wk



} 				 		 

		
	    ** UNEMPLOYED 
	
		replace ilo_lfs = 2 if look4 == 1 & start == 1 & ilo_wap == 1 // looking for paid work and available
		replace ilo_lfs = 2 if lkyt4== 1 & start == 1 & ilo_wap == 1 // looking for scheme place (public) and available
    	replace ilo_lfs = 2 if jbaway == 3 & start == 1 & ilo_wap == 1 // not working (away from job) and available
   		replace ilo_lfs = 2 if wait == 1 & start == 1 & ilo_wap == 1 // future job starters

		
		** OUTSIDE LABOUR FORCE
		replace ilo_lfs = 3 if ilo_lfs != 1   & ilo_lfs != 2 & ilo_wap == 1 // Not in employment, future job starters

	
		label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside the Labour Force"
		label value ilo_lfs label_ilo_lfs
		label var ilo_lfs "Labour Force Status"


			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

gen  ilo_mjh = .

** - 1. One job only

	replace ilo_mjh = 1 if  secjob != 1 & ilo_lfs == 1

** - 2. More than one job

	replace ilo_mjh = 2 if secjob == 1 & ilo_lfs == 1
	

	
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

 
*** Comment: According to the framework of UK labour market statistics, distinguishes between these 3 categories of worker, 
*** 		 and also between the different working arrangements of those in employment, such as employees, the self-employed and those on government schemes.


 
**** MAIN JOB

 
 
* Detailed categories:

		gen ilo_job1_ste_icse93 = .
		
			replace ilo_job1_ste_icse93 = 1 if inlist(statr,1,3)   & ilo_lfs == 1   	  // Employees
			
			replace ilo_job1_ste_icse93 = 2 if statr == 2 & solor == 2 & ilo_lfs==1                 // Employers
			
			replace ilo_job1_ste_icse93 = 3 if  statr == 2 & solor == 1 & ilo_lfs==1        // Own-account workers
			
			*replace ilo_job1_ste_icse93 = 4 if   & ilo_lfs==1                      // Members of producers cooperatives

			replace ilo_job1_ste_icse93 = 5 if statr == 3 & ilo_lfs==1 	            // Contributing family workers
			
			replace ilo_job1_ste_icse93 = 6 if  ilo_job1_ste_icse93 == . & ilo_lfs==1         // Workers not classifiable by status
			
				label def label_ilo_ste_icse93 1 "1 - Employees" 2 "2 - Employers" 3 "3 - Own-account workers" ///                      
											   4 "4 - Members of producers cooperatives" 5 "5 - Contributing family workers" ///
											   6 "6 - Workers not classifiable by status"
				label val ilo_job1_ste_icse93 label_ilo_ste_icse93
				label var ilo_job1_ste_icse93 "Status in employment (ICSE 93)"
				
				
				
				
* Aggregate categories
 
		gen ilo_job1_ste_aggregate = . 
		
			replace ilo_job1_ste_aggregate = 1 if ilo_job1_ste_icse93 == 1 & ilo_lfs == 1			    // Employees
			
			replace ilo_job1_ste_aggregate = 2 if inlist(ilo_job1_ste_icse93,2,3,4,5) & ilo_lfs == 1 	// Self-employed
			
			replace ilo_job1_ste_aggregate = 3 if ilo_job1_ste_icse93 == 6 & ilo_lfs == 1				// Not elsewhere classified
			replace ilo_job1_ste_aggregate = 3 if ilo_job1_ste_icse93 == . & ilo_lfs == 1			
			
				lab def ste_aggr_lab 1 "1 - Employees" 2 "2 - Self-employed" 3 "3 - Not elsewhere classified"
				lab val ilo_job1_ste_aggregate ste_aggr_lab
				label var ilo_job1_ste_aggregate "Status in employment (Aggregate)"  				

		
**** SECOND JOB


* Detailed categories:

		gen ilo_job2_ste_icse93 = .
		
			replace ilo_job2_ste_icse93 = 1 if stat2 == 1   & ilo_mjh == 2   	       // Employees
			
			replace ilo_job2_ste_icse93 = 2 if stat2 == 2 & ilo_mjh == 2             // Employers
			
			*replace ilo_job2_ste_icse93 = 3 if stat2   & ilo_mjh == 2              // Own-account workers
			
			*replace ilo_job2_ste_icse93 = 4 if stat2   & ilo_mjh == 2              // Members of producers cooperatives

			*replace ilo_job2_ste_icse93 = 5 if stat2   & ilo_mjh == 2	            // Contributing family workers
			
			replace ilo_job2_ste_icse93 = 6 if  ilo_job2_ste_icse93 == . & ilo_mjh == 2       // Workers not classifiable by status
			
 				label val ilo_job2_ste_icse93 label_ilo_ste_icse93
				label var ilo_job2_ste_icse93 "Status in employment (ICSE 93) - Second job"
				
			
				
* Aggregate categories
 
		gen ilo_job2_ste_aggregate = . 
		
			replace ilo_job2_ste_aggregate = 1 if ilo_job2_ste_icse93 == 1 & ilo_mjh == 2		                // Employees
			
			replace ilo_job2_ste_aggregate = 2 if inlist(ilo_job2_ste_icse93,2,3,4,5) & ilo_mjh == 2   	// Self-employed
			
			replace ilo_job2_ste_aggregate = 3 if ilo_job2_ste_icse93 == 6 & ilo_mjh == 2	 				    // Not elsewhere classified
			replace ilo_job2_ste_aggregate = 3 if ilo_job2_ste_icse93 == . & ilo_mjh == 2	  			
			
 				lab val ilo_job2_ste_aggregate ste_aggr_lab
				label var ilo_job2_ste_aggregate "Status in employment (Aggregate) - Second job"  				

 
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco')   
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------				

if `Y' > 2008 {
* ISIC Rev. 4


	* MAIN JOB:

	
 	* 2-digit level	
	gen ilo_job1_eco_isic4_2digits = indd07m if ilo_lfs == 1 & !inlist(indd07m,-9,-8)
		
	    lab def eco_isic4_digits 1 "01 - Crop and animal production, hunting and related service activities"	2 "02 - Forestry and logging"	3 "03 - Fishing and aquaculture"	5 "05 - Mining of coal and lignite" ///
                                 6 "06 - Extraction of crude petroleum and natural gas"	7 "07 - Mining of metal ores"	8 "08 - Other mining and quarrying"	9 "09 - Mining support service activities" ///
                                 10 "10 - Manufacture of food products"	11 "11 - Manufacture of beverages"	12 "12 - Manufacture of tobacco products"	13 "13 - Manufacture of textiles" ///
                                 14 "14 - Manufacture of wearing apparel"	15 "15 - Manufacture of leather and related products"	16 "16 - Manufacture of wood and of products of wood and cork, except furniture; manufacture of articles of straw and plaiting materials"	17 "17 - Manufacture of paper and paper products" ///
                                 18 "18 - Printing and reproduction of recorded media"	19 "19 - Manufacture of coke and refined petroleum products"	20 "20 - Manufacture of chemicals and chemical products"	21 "21 - Manufacture of basic pharmaceutical products and pharmaceutical preparations" ///
                                 22 "22 - Manufacture of rubber and plastics products"	23 "23 - Manufacture of other non-metallic mineral products"	24 "24 - Manufacture of basic metals"	25 "25 - Manufacture of fabricated metal products, except machinery and equipment" ///
                                 26 "26 - Manufacture of computer, electronic and optical products"	27 "27 - Manufacture of electrical equipment"	28 "28 - Manufacture of machinery and equipment n.e.c."	29 "29 - Manufacture of motor vehicles, trailers and semi-trailers" ///
                                 30 "30 - Manufacture of other transport equipment"	31 "31 - Manufacture of furniture"	32 "32 - Other manufacturing"	33 "33 - Repair and installation of machinery and equipment" ///
                                 35 "35 - Electricity, gas, steam and air conditioning supply"	36 "36 - Water collection, treatment and supply"	37 "37 - Sewerage"	38 "38 - Waste collection, treatment and disposal activities; materials recovery" ///
                                 39 "39 - Remediation activities and other waste management services"	41 "41 - Construction of buildings"	42 "42 - Civil engineering"	43 "43 - Specialized construction activities" ///
                                 45 "45 - Wholesale and retail trade and repair of motor vehicles and motorcycles"	46 "46 - Wholesale trade, except of motor vehicles and motorcycles"	47 "47 - Retail trade, except of motor vehicles and motorcycles"	49 "49 - Land transport and transport via pipelines" ///
                                 50 "50 - Water transport"	51 "51 - Air transport"	52 "52 - Warehousing and support activities for transportation"	53 "53 - Postal and courier activities" ///
                                 55 "55 - Accommodation"	56 "56 - Food and beverage service activities"	58 "58 - Publishing activities"	59 "59 - Motion picture, video and television programme production, sound recording and music publishing activities" ///
                                 60 "60 - Programming and broadcasting activities"	61 "61 - Telecommunications"	62 "62 - Computer programming, consultancy and related activities"	63 "63 - Information service activities" ///
                                 64 "64 - Financial service activities, except insurance and pension funding"	65 "65 - Insurance, reinsurance and pension funding, except compulsory social security"	66 "66 - Activities auxiliary to financial service and insurance activities"	68 "68 - Real estate activities" ///
                                 69 "69 - Legal and accounting activities"	70 "70 - Activities of head offices; management consultancy activities"	71 "71 - Architectural and engineering activities; technical testing and analysis"	72 "72 - Scientific research and development" ///
                                 73 "73 - Advertising and market research"	74 "74 - Other professional, scientific and technical activities"	75 "75 - Veterinary activities"	77 "77 - Rental and leasing activities" ///
                                 78 "78 - Employment activities"	79 "79 - Travel agency, tour operator, reservation service and related activities"	80 "80 - Security and investigation activities"	81 "81 - Services to buildings and landscape activities" ///
                                 82 "82 - Office administrative, office support and other business support activities"	84 "84 - Public administration and defence; compulsory social security"	85 "85 - Education"	86 "86 - Human health activities" ///
                                 87 "87 - Residential care activities"	88 "88 - Social work activities without accommodation"	90 "90 - Creative, arts and entertainment activities"	91 "91 - Libraries, archives, museums and other cultural activities" ///
                                 92 "92 - Gambling and betting activities"	93 "93 - Sports activities and amusement and recreation activities"	94 "94 - Activities of membership organizations"	95 "95 - Repair of computers and personal and household goods" ///
                                 96 "96 - Other personal service activities"	97 "97 - Activities of households as employers of domestic personnel"	98 "98 - Undifferentiated goods- and services-producing activities of private households for own use"	99 "99 - Activities of extraterritorial organizations and bodies"
        lab val ilo_job1_eco_isic4_2digits eco_isic4_digits
        lab var ilo_job1_eco_isic4_2digits "Economic activity (ISIC Rev. 4), 2 digits levels - main job"

	* 1-digit level
    gen ilo_job1_eco_isic4 = .
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
	    replace ilo_job1_eco_isic4=22 if (ilo_job1_eco_isic4_2digits==. | inlist(indd07m,-9,-8)) & ilo_lfs==1
		        lab def eco_isic4 1 "A - Agriculture, forestry and fishing"	2 "B - Mining and quarrying"	3 "C - Manufacturing"	4 "D - Electricity, gas, steam and air conditioning supply" ///
                                  5 "E - Water supply; sewerage, waste management and remediation activities"	6 "F - Construction"	7 "G - Wholesale and retail trade; repair of motor vehicles and motorcycles"	8 "H - Transportation and storage" ///
                                  9 "I - Accommodation and food service activities"	10 "J - Information and communication"	11 "K - Financial and insurance activities"	12 "L - Real estate activities" ///
                                  13 "M - Professional, scientific and technical activities"	14 "N - Administrative and support service activities"	15 "O - Public administration and defence; compulsory social security"	16 "P - Education" ///
                                  17 "Q - Human health and social work activities"	18 "R - Arts, entertainment and recreation"	19 "S - Other service activities"	20 "T - Activities of households as employers; undifferentiated goods- and services-producing activities of households for own use" ///
                                  21 "U - Activities of extraterritorial organizations and bodies"	22 "X - Not elsewhere classified"		
  	  		    lab val ilo_job1_eco_isic4 eco_isic4
			    lab var ilo_job1_eco_isic4 "Economic activity (ISIC Rev. 4) - main job"

   * Aggregate level
   gen ilo_job1_eco_aggregate = .
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

			   
	************		   
			   
			   
	**** SECOND JOB:
	
 	
	 	* 2-digit level	
	gen ilo_job2_eco_isic4_2digits = indd07s if ilo_mjh==2
		
 
        lab val ilo_job2_eco_isic4_2digits eco_isic4_digits
        lab var ilo_job2_eco_isic4_2digits "Economic activity (ISIC Rev. 4), 2 digits levels - second job"

	* 1-digit level
    gen ilo_job2_eco_isic4 = .
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
	    replace ilo_job2_eco_isic4=22 if ilo_job2_eco_isic4_2digits==. & ilo_mjh==2
		        
  	  		    lab val ilo_job2_eco_isic4 eco_isic4
			    lab var ilo_job2_eco_isic4 "Economic activity (ISIC Rev. 4) - second job"

   * Aggregate level
   gen ilo_job2_eco_aggregate = .
	   replace ilo_job2_eco_aggregate=1 if ilo_job2_eco_isic4==1
	   replace ilo_job2_eco_aggregate=2 if ilo_job2_eco_isic4==3
	   replace ilo_job2_eco_aggregate=3 if ilo_job2_eco_isic4==6
	   replace ilo_job2_eco_aggregate=4 if inlist(ilo_job2_eco_isic4,2,4,5)
	   replace ilo_job2_eco_aggregate=5 if inrange(ilo_job2_eco_isic4,7,14)
	   replace ilo_job2_eco_aggregate=6 if inrange(ilo_job2_eco_isic4,15,21)
	   replace ilo_job2_eco_aggregate=7 if ilo_job2_eco_isic4==22
			   
			   lab val ilo_job2_eco_aggregate eco_aggr_lab
			   lab var ilo_job2_eco_aggregate "Economic activity (Aggregate) - second job"
}



if `Y' < 2009  {	
 
* ISIC Rev. 3.1

 
* MAIN JOB:
	 
 
	
 	* 2-digit level	
	
	recode indd92m  				(1=1)	(2=2)	(3=5)	(4=10)	(5=11)	(6=12)	(7=13)	(8=14)	(9=15)	(10=16)	(11=17)	(12=18)	(13=19)	(14=20)	(15=21)	(16=22)	(17=23)	(18=24)	(19=25) ///
									(20=26)	(21=27)	(22=28)	(23=29)	(24=30)	(25=31)	(26=32)	(27=33)	(28=34)	(29=35)	(30=36)	(31=37)	(32=40)	(33=41)	(34=45)	(35=50)	(36=51)	(37=52)	(38=55)	(39=60)	///
									(40=61)	(41=62)	(42=63)	(43=64)	(44=65)	(45=66)	(46=67)	(47=70)	(48=71)	(49=72)	(50=73)	(51=74)	(52=75)	(53=80)	(54=85)	(55=90)	(56=91)	(57=92)	(58=93)	(59=95)	///
									(60=99) if !inlist(indd92m,-8,-9,62) & ilo_lfs == 1, gen(ilo_job1_eco_isic3_2digits)  
									
		
	    lab def eco_isic3_digits 1 "01 - Agriculture, hunting and related service activities" 2 "02 - Forestry, logging and related service activities" ///
                                 5 "05 - Fishing, operation of fish hatcheries and fish farms; service activities incidental to fishing" /// 
							     10 "10 - Mining of coal and lignite; extraction of peat"  11 "11 - Extraction of crude petroleum and natural gas; service activities incidental to oil and gas extraction excluding surveying" ///
                                 12 "12 - Mining of uranium and thorium ores" 13 "13 - Mining of metal ores" 14 "14 - Other mining and quarrying" ///
                                 15 "15 - Manufacture of food products and beverages"  16 "16 - Manufacture of tobacco products" 17 "17 - Manufacture of textiles" ///
                                 18 "18 - Manufacture of wearing apparel; dressing and dyeing of fur" 19 "19 - Tanning and dressing of leather; manufacture of luggage, handbags, saddlery, harness and footwear" ///
                                 20 "20 - Manufacture of wood and of products of wood and cork, except furniture; manufacture of articles of straw and plaiting materials" ///
                                 21 "21 - Manufacture of paper and paper products" 22 "22 - Publishing, printing and reproduction of recorded media" ///
                                 23 "23 - Manufacture of coke, refined petroleum products and nuclear fuel" 24 "24 - Manufacture of chemicals and chemical products" ///
                                 25 "25 - Manufacture of rubber and plastics products" 26 "26 - Manufacture of other non-metallic mineral products" 27 "27 - Manufacture of basic metals" ///
                                 28 "28 - Manufacture of fabricated metal products, except machinery and equipment" 29 "29 - Manufacture of machinery and equipment n.e.c." ///
                                 30 "30 - Manufacture of office, accounting and computing machinery" 31 "31 - Manufacture of electrical machinery and apparatus n.e.c." ///
                                 32 "32 - Manufacture of radio, television and communication equipment and apparatus" 33 "33 - Manufacture of medical, precision and optical instruments, watches and clocks" ///
                                 34 "34 - Manufacture of motor vehicles, trailers and semi-trailers" 35 "35 - Manufacture of other transport equipment" 36 "36 - Manufacture of furniture; manufacturing n.e.c." ///
                                 37 "37 - Recycling"  40 "40 - Electricity, gas, steam and hot water supply" 41 "41 - Collection, purification and distribution of water" 45 "45 - Construction" ///
                                 50 "50 - Sale, maintenance and repair of motor vehicles and motorcycles; retail sale of automotive fuel" 51 "51 - Wholesale trade and commission trade, except of motor vehicles and motorcycles" ///
                                 52 "52 - Retail trade, except of motor vehicles and motorcycles; repair of personal and household goods" 55 "55 - Hotels and restaurants" 60 "60 - Land transport; transport via pipelines" ///
                                 61 "61 - Water transport" 62 "62 - Air transport" 63 "63 - Supporting and auxiliary transport activities; activities of travel agencies" 64 "64 - Post and telecommunications" ///
                                 65 "65 - Financial intermediation, except insurance and pension funding"  66 "66 - Insurance and pension funding, except compulsory social security" ///
                                 67 "67 - Activities auxiliary to financial intermediation"  70 "70 - Real estate activities" 71 "71 - Renting of machinery and equipment without operator and of personal and household goods" ///
                                 72 "72 - Computer and related activities" 73 "73 - Research and development" 74 "74 - Other business activities" 75 "75 - Public administration and defence; compulsory social security" ///
                                 80 "80 - Education" 85 "85 - Health and social work" 90 "90 - Sewage and refuse disposal, sanitation and similar activities" 91 "91 - Activities of membership organizations n.e.c." ///
                                 92 "92 - Recreational, cultural and sporting activities" 93 "93 - Other service activities" 95 "95 - Activities of private households as employers of domestic staff" ///
                                 96 "96 - Undifferentiated goods-producing activities of private households for own use" 97 "97 - Undifferentiated service-producing activities of private households for own use" ///
                                 99 "99 - Extra-territorial organizations and bodies" 

        lab val ilo_job1_eco_isic3_2digits eco_isic3_digits
        lab var ilo_job1_eco_isic3_2digits "Economic activity (ISIC Rev. 3.1), 2 digits levels - main job"

	* 1-digit level
    gen ilo_job1_eco_isic3 = .
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
		        lab def eco_isic3 1  "A - Agriculture, hunting and forestry "	2  "B - Fishing "	3  "C - Mining and quarrying "	4  "D - Manufacturing " ///
                                  5  "E - Electricity, gas and water supply "	6  "F - Construction "	7  "G - Wholesale and retail trade; repair of motor vehicles, motorcycles and personal and household goods "	8  "H - Hotels and restaurants " ///
                                  9  "I - Transport, storage and communications "	10  "J - Financial intermediation "	11  "K - Real estate, renting and business activities "	12  "L - Public administration and defence; compulsory social security " ///
                                  13  "M - Education "	14  "N - Health and social work "	15  "O - Other community, social and personal service activities "	16  "P - Activities of private households as employers and undifferentiated production activities of private households " ///
                                  17  "Q - Extraterritorial organizations and bodies "	18  "X - Not elsewhere classified "		
			    lab val ilo_job1_eco_isic3 eco_isic3
			    lab var ilo_job1_eco_isic3 "Economic activity (ISIC Rev. 3.1) - main job"

	* Aggregate level			
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
			    lab var ilo_job1_eco_aggregate "Economic activity (Aggregate) - main job"

			   
	************		   
			   
			   
	**** SECOND JOB:
	
 	
	 	* 2-digit level	
		
		recode indd92s  			(1=1)	(2=2)	(3=5)	(4=10)	(5=11)	(6=12)	(7=13)	(8=14)	(9=15)	(10=16)	(11=17)	(12=18)	(13=19)	(14=20)	(15=21)	(16=22)	(17=23)	(18=24)	(19=25) ///
									(20=26)	(21=27)	(22=28)	(23=29)	(24=30)	(25=31)	(26=32)	(27=33)	(28=34)	(29=35)	(30=36)	(31=37)	(32=40)	(33=41)	(34=45)	(35=50)	(36=51)	(37=52)	(38=55)	(39=60)	///
									(40=61)	(41=62)	(42=63)	(43=64)	(44=65)	(45=66)	(46=67)	(47=70)	(48=71)	(49=72)	(50=73)	(51=74)	(52=75)	(53=80)	(54=85)	(55=90)	(56=91)	(57=92)	(58=93)	(59=95)	///
									(60=99) if !inlist(indd92s,-8,-9,62) & ilo_mjh==2, gen(ilo_job2_eco_isic3_2digits) 
									
		  
        lab val ilo_job2_eco_isic3_2digits eco_isic3_digits
        lab var ilo_job2_eco_isic3_2digits "Economic activity (ISIC Rev. 3.1), 2 digits levels - second job"

	* 1-digit level
    gen ilo_job2_eco_isic3 = .
	    replace ilo_job2_eco_isic3=1 if inrange(ilo_job2_eco_isic3_2digits,1,2)
	    replace ilo_job2_eco_isic3=2 if ilo_job2_eco_isic3_2digits==5
	    replace ilo_job2_eco_isic3=3 if inrange(ilo_job2_eco_isic3_2digits,10,14)
	    replace ilo_job2_eco_isic3=4 if inrange(ilo_job2_eco_isic3_2digits,15,37)
	    replace ilo_job2_eco_isic3=5 if inrange(ilo_job2_eco_isic3_2digits,40,41)
	    replace ilo_job2_eco_isic3=6 if ilo_job2_eco_isic3_2digits==45
	    replace ilo_job2_eco_isic3=7 if inrange(ilo_job2_eco_isic3_2digits,50,52)
	    replace ilo_job2_eco_isic3=8 if ilo_job2_eco_isic3_2digits==55
	    replace ilo_job2_eco_isic3=9 if inrange(ilo_job2_eco_isic3_2digits,60,64)
	    replace ilo_job2_eco_isic3=10 if inrange(ilo_job2_eco_isic3_2digits,65,67)
	    replace ilo_job2_eco_isic3=11 if inrange(ilo_job2_eco_isic3_2digits,70,74)
	    replace ilo_job2_eco_isic3=12 if ilo_job2_eco_isic3_2digits==75
	    replace ilo_job2_eco_isic3=13 if ilo_job2_eco_isic3_2digits==80		
	    replace ilo_job2_eco_isic3=14 if ilo_job2_eco_isic3_2digits==85
	    replace ilo_job2_eco_isic3=15 if inrange(ilo_job2_eco_isic3_2digits,90,93)
        replace ilo_job2_eco_isic3=16 if ilo_job2_eco_isic3_2digits==95
	    replace ilo_job2_eco_isic3=17 if ilo_job2_eco_isic3_2digits==99
	    replace ilo_job2_eco_isic3=18 if ilo_job2_eco_isic3_2digits==. & ilo_mjh==2
    		    lab val ilo_job2_eco_isic3 eco_isic3
			    lab var ilo_job2_eco_isic3 "Economic activity (ISIC Rev. 3.1) - second job"

	* Aggregate level			
	gen ilo_job2_eco_aggregate=.
		replace ilo_job2_eco_aggregate=1 if inlist(ilo_job2_eco_isic3,1,2)
		replace ilo_job2_eco_aggregate=2 if ilo_job2_eco_isic3==4
		replace ilo_job2_eco_aggregate=3 if ilo_job2_eco_isic3==6
		replace ilo_job2_eco_aggregate=4 if inlist(ilo_job2_eco_isic3,3,5)
		replace ilo_job2_eco_aggregate=5 if inrange(ilo_job2_eco_isic3,7,11)
		replace ilo_job2_eco_aggregate=6 if inrange(ilo_job2_eco_isic3,12,17)
		replace ilo_job2_eco_aggregate=7 if ilo_job2_eco_isic3==18
			    lab val ilo_job2_eco_aggregate eco_aggr_lab
			    lab var ilo_job2_eco_aggregate "Economic activity (Aggregate) - second job"



}
			   
			   
								
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_job1_ocu_isco08')  
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------


 *** NATIONAL CLASSIFICATION: Standard Occupational Classification: SOC2010 (2011Q1-2017Q2)
 *** NATIONAL CLASSIFICATION: Standard Occupational Classification: SOC2000 (2001Q2-2010Q4)


 * MAIN JOB	
 
if todrop >= "2001Q2"  {
 
if `Y' < 2011 {

*** SOC2000-SOC2010 mapping

recode soc2km   (1115=1111)	(1115=1112)	(1115=1113)	(1115=1114)	(1115=1181)	(1115=1222)	(1115=1226)	(1116=1111)	(1116=1113)	(1121=1112)	(1121=1121)	(1122=1112)	(1122=1122)	(1123=1112)	(1123=1123)	///
				(1131=1112)	(1131=1131)	(1132=1112)	(1132=1132)	(1133=1133)	(1134=1112)	(1134=1134)	(1135=1111)	(1135=1112)	(1135=1135)	(1136=1112)	(1136=1136)	(1139=1111)	(1139=1112)	(1139=1113)	///
				(1139=1114)	(1139=1137)	(1139=1141)	(1139=1142)	(1139=1152)	(1139=1174)	(1139=1182)	(1139=1212)	(1139=1222)	(1139=1239)	(1139=2419)	(1150=1112)	(1150=1151)	(1161=1161)	(1162=1162)	///
				(1171=1171)	(1172=1172)	(1173=1173)	(1181=1112)	(1181=1181)	(1184=1111)	(1184=1112)	(1184=1184)	(1190=1163)	(1190=1182)	///
				(1211=1211)	(1211=1219)	(1211=3551)	(1213=1219)	(1221=1221)	(1223=1112)	(1223=1223)	(1224=1224)	(1225=1112)	(1225=1225)	(1226=1112)	(1226=1226)	(1241=1183)	(1242=1184)	(1242=1185)	///
				(1251=1231)	(1252=1232)	(1253=1233)	(1254=1234)	(1255=1235)	(1259=1112)	(1259=1222)	(1259=1239)		///																															
				(2111=2111)	(2112=2112)	(2112=2213)	(2112=2321)	(2112=2329)	(2113=2113)	(2113=2321)	(2114=2322)	(2119=1182)	(2119=2321)	(2119=2329)	(2119=2451)	(2119=3119)	(2121=2121)	(2122=2122)	///
				(2123=2123)	(2124=2124)	(2126=2126)	(2127=2125)	(2127=2126)	(2127=2127)	(2127=2128)	(2129=1121)	(2129=2129)	(2133=1136)	(2134=1136)	(2135=2131)	(2135=2132)	(2135=2423)	(2136=2131) ///
				(2136=2132)	(2137=2132)	(2137=3131)	(2137=3421)	(2139=2131)	(2139=2132)	(2141=1212)	(2141=3114)	(2141=3551)	(2141=3552)	(2142=1212)	(2142=2112)	(2142=2129)	(2142=2321)	(2142=3551)	///
				(2142=3552)	(2150=1137)	(2150=1182)			///					
				(2211=2211)	(2212=2212)	(2213=1182)	(2213=2213)	(2214=2214)	(2215=2215)	(2216=2216)	(2217=3214)	(2218=3215)	(2219=1181)	(2219=2112)	(2219=2129)	(2219=3218)	(2219=3232)	(2219=3567)	(2221=3221)	////
				(2222=3222)	(2223=3223)	(2229=3229)	(2231=1181)	(2231=3211)	(2232=3212)		////																																
				(2311=2211)	(2311=2311)	(2312=2312)	(2314=2314)	(2315=2315)	(2316=2316)	(2317=2312)	(2317=2313)	(2317=2315)	(2317=2316)	(2317=2317)	(2318=2313)	(2319=1239)	(2319=2319)		///																																								
				(2412=2411)	(2412=2419)	(2413=2411)	(2419=2411)	(2419=2419)	(2421=2421)	(2421=2422)	(2423=2423)	(2424=1113)	(2424=1114)	(2424=1121)	(2424=1123)	(2424=1131)	(2424=1132)	(2424=1133)	(2424=1134)	///
				(2424=1135)	(2424=1137)	(2424=1142)	(2424=1151)	(2424=1161)	(2424=1181)	(2424=1184)	(2424=1212)	(2424=1226)	(2424=1239)	(2424=2441)	(2425=2423)		///																										
				(2426=2329)	(2426=3111)	(2426=3119)	(2429=1111)	(2429=1113)	(2429=1131)	(2429=2441)	(2429=3561)	(2429=4214)	(2431=2431)	(2432=2432)	(2433=2433)	(2434=2434)	(2435=3121)	(2436=1122)	(2436=1123)	////
				(2436=1231)	(2436=4134)	(2442=1184)	(2442=2442)	(2443=2443)	(2444=2444)	(2449=2442)	(2449=3231)	(2449=3232)	(2451=2451)	(2452=2452)	(2461=2128)	(2462=1141)	(2462=2129)	(2463=1113)	(2463=3551)	(2463=3568)	///
				(2471=3431)	(2471=3432)	(2472=1134)	(2472=3433)	(2473=1134)	///																	
				(3111=3111)	(3111=8138)	(3112=3112)	(3113=3113)	(3114=3114)	(3115=3115)	(3115=3119)	(3116=1121)	(3116=2127)	(3116=2128)	(3116=3119)	(3119=2125)	(3119=2127)	(3119=3111)	(3119=3112)	(3119=3113)	(3119=3119)	///
				(3121=3121)	(3122=3122)	(3131=3131)	(3131=4136)	(3132=2132)	(3132=3132)	(3132=5245)	(3213=3213)	(3216=3216)	(3216=3217)	(3217=3217)	(3218=3218)	(3218=6139)	(3219=3223)	(3219=3229)	(3231=3231)	(3231=3232)	///
				(3233=3231)	(3233=3232)	(3233=6124)	(3234=3232)	(3235=3229)	(3235=3232)	(3239=2442)	(3239=2444)	(3239=3231)	(3239=3232)	(3239=6219)	(3239=6291)	(3239=9229)	(3311=3311)	(3312=3312)	(3313=1173)	(3313=3313) ///
				(3314=3314)	(3315=3231)	(3315=9241)	(3319=1174)	(3319=3319) ///
				(3411=3411)	(3412=3412)	(3413=3413)	(3413=3432)	(3414=2319)	(3414=3414)	(3415=3415)	(3416=3416)	(3416=3432)	(3417=3432)	(3417=3434)	(3421=3421)	(3422=3422)	(3441=3441)	(3442=3442)	(3442=3449)	(3443=3443)	///
				(3443=3449)	(3511=3511)	(3512=3512)	(3513=3513)	(3520=2419)	(3520=3520)	(3531=3531)	(3532=3532)	(3533=3533)	(3534=3534)	(3535=1131)	(3535=3535)	(3536=3536)	(3537=3537)	(3538=1131)	(3538=1133)	(3538=1151) ///
				(3538=1152)	(3539=3539)	///																			
				(3541=3541)	(3542=3542)	(3542=7129)	(3543=3543)	(3544=3544)	(3544=7129)	(3545=1132)	(3545=1134)	(3546=1222)	(3546=3539)	(3550=3551)	(3550=3552)	(3561=3433)	(3561=3561)	(3561=4111)	(3561=4113)	(3562=3562) ///
				(3563=1135)	(3563=3449)	(3563=3563)	(3564=3564)	(3565=3123)	(3565=3551)	(3565=3565)	(3565=3566)	(3565=3568)	(3567=1212)	(3567=1239)	(3567=3567)		///																									
				(4112=4111)	(4112=4112)	(4113=4113)	(4114=4114)	(4121=4121)	(4122=1152)	(4122=4122)	(4123=1151)	(4123=4123)	(4123=7212)	(4124=4122)	(4124=4213)	(4129=4113)	(4129=4122)	(4129=4123)	(4129=4132)	(4129=7112)	///
				(4129=7122)	(4131=4131)	(4132=4132)	(4133=1162)	(4133=4133)	(4134=4134)	(4135=4135)	(4138=3562)	(4138=3563)	(4138=4150)	(4151=3542)	(4151=3543)	(4151=4122)	(4151=4131)	(4151=4150)	(4159=1113)	(4159=2419)	///
				(4159=3217)	(4159=3561)	(4159=4113)	(4159=4122)	(4159=4131)	(4159=4136)	(4159=4150)	(4159=4211)	(4159=9219)	///												
				(4161=1123)	(4161=1152)	(4162=1113)	(4162=1114)	(4162=1152)	(4162=1184)	(4162=3232)	(4162=3539)	(4162=4112)	(4162=4113)	(4162=4114)	(4162=4121)	(4162=4131)	(4162=4134)	(4162=4136)	(4162=4150)	(4162=4217) ////
				(4162=9219)	(4211=4211)	(4212=4212)	(4213=4213)	(4214=4214)	(4215=4215)					///																												
				(4216=1225)	(4216=4216)	(4217=3131)	(4217=4136)	(4217=4217)	(5111=1211)	(5111=5111)	(5111=5119)	(5112=5112)	(5113=5113)	(5114=5113)	(5119=1219)	(5119=3552)	(5119=5119)	(5211=5211)	(5212=5212)	(5213=5213)	///
				(5214=5214)	(5215=5215)	(5216=5216)	(5221=5221)	(5222=5222)	(5223=5223)	(5223=8125)	(5223=8129)	(5224=5224)	(5225=5314)	(5231=1232)	(5231=5231)	(5231=5233)	(5232=5232)	(5234=5234)	(5235=5223)	(5236=5214)	///
				(5236=5315)	(5236=8217)	(5237=5223)		 ///																	
				(5241=5241)	(5241=5249)	(5242=5242)	(5242=5243)	(5244=5244)	(5245=5245)	(5249=5243)	(5249=5249)	(5250=1174)	(5250=1232)	(5250=5211)	(5250=5212)	(5250=5213)	(5250=5214)	(5250=5216)	(5250=5221)	(5250=5223)	////
				(5250=5231)	(5250=5232)	(5250=5241)	(5250=5242)	(5250=5243)	(5250=5245)	(5250=5249)	(5250=8125)	(5311=5311)	(5312=5312)	(5313=5313)	(5314=5314)	(5315=5315)	(5316=5316)	(5319=5311)	(5319=5319)	(5319=9129)	///
				(5321=5321)	(5322=5313)	(5322=5322)	(5323=5323)	(5330=5311)	(5330=5314)	(5330=5315)	(5330=5319)	(5330=8141)	(5330=8142)	(5330=8143)	(5330=8149)	(5411=5411)	(5412=5412)	(5413=5413)	(5413=8139)	(5414=5414)	///
				(5414=8136)	(5419=5411)	(5419=5419)	(5421=5421)	(5422=3416)	(5422=5422)	(5422=5424)	(5422=9133)	(5423=5423)	(5431=5431)	(5432=5432)	(5433=5433)	(5434=5434)	(5435=5434)	(5436=1223)	(5436=1224)	(5436=5434)	///
				(5436=6219)	(5441=5491)	(5441=8129)	(5442=5492)	(5443=5496)	(5449=5315)	(5449=5323)	(5449=5493)	(5449=5494)	(5449=5495)	(5449=5499)	(6121=6121)	(6121=6123)	(6122=6122)	(6123=6123)	(6125=6124)	(6126=6124) ///
				(6131=6131)	(6132=6292)	(6139=1219)	(6139=5119)	(6139=6131)	(6139=6139)	(6141=6111)	(6142=6112)	(6143=3218)	(6143=6113)	(6144=1231)	(6144=6114)	(6145=3229)	(6145=3449)	(6145=6115)	(6146=6115)	(6147=6213)	///
				(6147=6219)	(6147=8214)	(6148=6291)	(6211=6211)	(6212=6212)	(6214=6214)	(6215=6215)	(6219=6213)	(6219=6219)	(6221=1233)	(6221=6221)	(6222=6222)	(6231=6231)	(6232=6232)	(6240=6231)	(6240=9232)	(6240=9233)	///
				(6240=9234)	(6240=9239) ///																					
				(7111=7111)	(7112=5231)	(7112=7112)	(7113=7113)	(7114=3217)	(7115=3542)	(7115=7111)	(7121=7121)	(7122=7122)	(7123=7123)	(7124=7124)	(7125=7125)	(7129=7129)	(7130=1163)	(7130=7111)	(7130=7113)	(7130=7129)	///
				(7211=4141)	(7211=7211)	(7213=4141)	(7214=4142)	(7215=4137)	(7219=7212)	(7220=1142)	(7220=1173)	(7220=4141)	(7220=4142)	(7220=7211)	(7220=7212)		///																									
				(8111=8111)	(8112=8112)	(8113=8113)	(8113=8114)	(8114=8114)	(8115=8115)	(8116=8115)	(8116=8116)	(8116=8129)	(8117=8117)	(8118=8118)	(8118=8129)	(8119=8119)	(8121=8119)	(8121=8121)	(8122=8122)	(8123=8123) ///
				(8124=8124)	(8125=8125)	(8126=8126)	(8127=5423)	(8127=9133)	(8129=8129)	(8129=8139)	(8131=8131)	(8132=8132)	(8133=8133)	(8134=8134)	(8135=8135)	(8137=8137)	(8139=8138)	(8139=8139)		///																						
				(8141=8141)	(8142=8142)	(8143=8143)	(8149=8149)	(8149=9121)	(8149=9129)	(8211=2451)	(8211=8211)	(8212=8212)	(8213=8213)	(8214=8214)	(8215=8215)	(8221=8221)	(8222=8222)	(8223=8223)	(8229=8229)	(8231=3514)	///
				(8232=8217)	(8232=8219)	(8233=3511)	(8233=8218)	(8234=8216)	(8239=8219)		///																															
				(9111=9111)	(9112=9112)	(9119=9119)	(9120=9121)	(9120=9129)	(9120=9219)	(9132=8119)	(9132=9132)	(9132=9233)	(9132=9239)	(9134=9134)	(9139=9131)	(9139=9139)	(9211=9211)	(9219=3119)	(9219=9219)	(9231=9231)	///
				(9232=9232)	(9233=9233)	(9234=8119)	(9234=9234)	(9235=9235)	(9236=9233)	(9239=9239)	(9241=9241)	(9242=6114)	(9242=9242)	(9242=9245)	(9244=9243)	(9244=9244)	(9249=9249)	(9251=9251)	(9259=9259)	(9260=9141)	///
				(9260=9149)	(9271=9221)	(9272=6219)	(9272=9132)	(9272=9223)	(9273=9224)	(9274=9225)	(9275=3449)	(9275=5323)	(9275=6222)	(9275=9226)	(9279=3414)	(9279=6222)	(9279=9222)	(9279=9229)	if !inlist(soc2km,-8,-9), gen(soc2010_mj)		
}
																																																							

	
	
 if `Y' > 2010 	{
 
 gen soc2010_mj = soc10m if !inlist(soc10m,-8,-9)
 
 }
 
 
 
   
 
 *** SOC2010 - ISCO-08 mapping
 
recode soc2010_mj            	(1115=1120)	(1116=1111)	(1121=1321)	(1122=1323)	(1123=1322)	(1131=1211)	(1132=1221)	(1133=1324)	(1134=1222)	(1135=1212)	(1136=1330)	(1139=1213) ///
								(1150=1346)	(1161=1324)	(1162=1324)	(1171=0110)	(1172=3355)	(1173=1349)	(1181=1342)	(1184=1344)	(1190=1420)	///
								(1211=1311)	(1213=1311)	(1221=1411)	(1223=1412)	(1224=1411)	(1225=1431)	(1226=1439)	(1241=3344)	(1242=1343)	(1251=1439)	(1252=1439)	(1253=1439) ///
								(1254=5221)	(1255=1439)	(1259=1439)	///																												
								(2111=2113)	(2112=2131)	(2113=2111) (2114=2632)	(2119=2131)	(2121=2142)	(2122=2144)	(2123=2151)	(2124=2152)	(2126=2149)	(2127=2141) ///
								(2129=2149)	(2133=2519)	(2134=2519)	(2135=2511)	(2136=2512)	(2137=2513)	(2139=2519)	(2141=2133)	(2142=2133)	(2150=1223)					///																	
                                (2211=2211)	(2212=2634)	(2213=2262)	(2214=2267)	(2215=2261)	(2216=2250)	(2217=3211)	(2218=2269)	(2219=2269)	(2221=2264)	(2222=2269) ///
								(2223=2266)	(2229=2634) (2231=2221)	(2232=2222)	///																											
								(2311=2310)	(2312=2320)	(2314=2330)	(2315=2341)	(2316=2352)	(2317=1345)	(2318=2351)	(2319=2359) ///																																				
								(2412=2611)	(2413=2611)	(2419=2611)	(2421=2411)	(2423=2421)	(2424=2421)	(2425=2120)	(2426=2422)	(2429=2422)	(2431=2161)	(2432=2164)	(2433=2149) ///
								(2434=2165)	(2435=2161)	(2436=1323)	(2442=2635)	(2443=2635)	(2444=2636)	(2449=2635)	(2451=2622)	(2452=2621)	(2461=2149)	(2462=2421)	(2463=2263) ///
								(2471=2642)	(2472=2432)	(2473=2431) ///												
								(3111=3111)	(3112=3113)	(3113=3115)	(3114=3112)	(3115=3119)	(3116=3139)	(3119=3119)	(3121=3112)	(3122=3118)	(3131=3511)	(3132=3512) ///
                                (3213=3258)	(3216=3254)	(3217=3213)	(3218=3211)	(3219=3230)	(3231=3412)	(3233=3412)	(3234=3412)	(3235=2635)	(3239=3412)	(3311=0210)	 ///
								(3312=5412)	(3313=5411)	(3314=5413)	(3315=5412)	(3319=5419)	///																										
								(3411=2651)	(3412=2641)	(3413=2655)	(3414=2355)	(3415=2652)	(3416=2654)	(3417=3431)	(3421=2166)	(3422=2163)	(3441=3421) ///
								(3442=3422)	(3443=3423)	(3511=3154)	(3512=3153)	(3513=3152)	(3520=3411)	(3531=3315)	(3532=3311)	(3533=3321)	(3534=2412)	(3535=2411)	(3536=3324) ///
								(3537=3313)	(3538=3313)	(3539=3314)	(3541=3323)	(3542=3322)	(3543=2431)	(3544=3334)	(3545=2433)	(3546=3332)	(3550=3143)	(3561=3359) ///
								(3562=2423)	(3563=2424)	(3564=2423)	(3565=3359)	(3567=3257)	///																
								(4112=3353)	(4113=4110)	(4114=4110)	(4121=3312)	(4122=4311)	(4123=4211)	(4124=4311)	(4129=4211)	(4131=4229)	(4132=4312)	(4133=4321)	(4134=4323) ///
								(4135=4411)	(4138=4416)	(4151=5249)	(4159=4419)	(4161=3341)	(4162=3341)	(4211=3344)	(4212=3342)	(4213=3343)	(4214=1211)	(4215=3343)	(4216=4226) ///
								(4217=4132)	///																		
								(5111=6121)	(5112=6113)	(5113=6113)	(5114=6113)	(5119=6210)	(5211=7221)	(5212=7211)	(5213=7213)	(5214=7214)	(5215=7212)	(5216=7126)	(5221=7223) ///
								(5222=7222)	(5223=7233)	(5224=7311)	(5225=7127)	(5231=7231)	(5232=7213)	(5234=7132)	(5235=7232)	(5236=7233)	(5237=7233)	(5241=7411) ///
								(5242=2153)	(5244=2153)	(5245=7422)	(5249=7421)	(5250=3122)	///												
								(5311=7214)	(5312=7112)	(5313=7121)	(5314=7126)	(5315=7115)	(5316=7125)	(5319=7111)	(5321=7123)	(5322=7122)	(5323=7131)	(5330=3123)	(5411=7318) ///
								(5412=7534)	(5413=7536)	(5414=7531)	(5419=7533)	(5421=7321)	(5422=7322)	(5423=7323)	(5431=7511)	(5432=7512)	(5433=7511)	(5434=3434)	(5435=5120) ///
								(5436=1412)	(5441=7314)	(5442=7522)	(5443=7549)	(5449=7316)	///														
								(6121=5312)	(6122=5311)	(6123=5311)	(6125=5312)	(6126=5312)	(6131=3240)	(6132=7544)	(6139=5164)	(6141=5321)	(6142=3258)	(6143=3251)	(6144=5329) ///
								(6145=5322)	(6146=5322)	(6147=5329)	(6148=5163)	(6211=4212)	(6212=4221)	(6214=5111)	(6215=5112)	(6219=5113)	(6221=5141)	(6222=5142) ///
								(6231=5152)	(6232=5153)	(6240=5151) ///																	
								(7111=5223)	(7112=5230)	(7113=5244)	(7114=3213)	(7115=5223)	(7121=5243)	(7122=4214)	(7123=5243)	(7124=5211)	(7125=5242)	(7129=5242) ///
								(7130=5222)	(7211=4222)	(7213=4223)	(7214=4223)	(7215=4227)	(7219=4225)	(7220=3341)	///																								
								(8111=8160)	(8112=8181)	(8113=8151)	(8114=8131)	(8115=8141)	(8116=8142)	(8117=8121)	(8118=8122)	(8119=8114)	(8121=7523)	(8122=8111)	(8123=8111) ///
								(8124=8182)	(8125=7223)	(8126=3132)	(8127=7322)	(8129=8189)	(8131=8212)	(8132=8211)	(8133=7543)	(8134=7543)	(8135=7231) ///
								(8137=8153)	(8139=8219)	(8141=7119)	(8142=9312)	(8143=9312)	(8149=9622)	(8211=8332)	(8212=8322)	(8213=8331)	(8214=8322)	(8215=5165)	(8221=8343) ///
								(8222=8344)	(8223=8341)	(8229=8342)	(8231=8311)	(8232=8350)	(8233=9333)	(8234=8312)	(8239=9333) ///
								(9111=9213)	(9112=6210)	(9119=9214)	(9120=9313)	(9132=9329)	(9134=9321)	(9139=9329)	(9211=4412)	(9219=9621)	(9231=9123)	(9232=9613) ///
								(9233=9112)	(9234=9121)	(9235=9611)	(9236=9122)	(9239=9112)	(9241=5414)	(9242=9629)	(9244=9629)	(9249=9629)	(9251=9334)	(9259=9520)	(9260=9333) ///
								(9271=9112)	(9272=9412)	(9273=5131)	(9274=5132)	(9275=9629)	(9279=9621) if !inlist(soc2010_mj,-8,-9), gen(isco_m) 
	

	gen occ_code_prim=.
	    replace occ_code_prim=int(isco_m/100)

    * 2-digit level
	gen ilo_job1_ocu_isco08_2digits = occ_code_prim if ilo_lfs==1
	
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
		lab var ilo_job1_ocu_isco08_2digits "Occupation (ISCO-08), 2 digit level - main job"

		
    * 1-digit level
	gen ilo_job1_ocu_isco08 =.
	    replace ilo_job1_ocu_isco08=int(ilo_job1_ocu_isco08_2digits/10) if ilo_lfs==1     // The rest of the occupations
		replace ilo_job1_ocu_isco08=10 if (ilo_job1_ocu_isco08==0 & ilo_lfs==1)           // Armed forces
	    replace ilo_job1_ocu_isco08=11 if inlist(ilo_job1_ocu_isco08_2digits,99,.) & ilo_lfs==1     // Not elsewhere classified
				lab def ocu08_1digits 1 "1 - Managers"	2 "2 - Professionals"	3 "3 - Technicians and associate professionals" ///
									  4 "4 - Clerical support workers" 5 "5 - Service and sales workers"	6 "6 - Skilled agricultural, forestry and fishery workers"	///
									  7 "7 - Craft and related trades workers" 8 "8 - Plant and machine operators, and assemblers" ///
                                      9 "9 - Elementary occupations"	10 "0 - Armed forces occupations"	11 "X - Not elsewhere classified"
				lab val ilo_job1_ocu_isco08 ocu08_1digits
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
		  	    lab def ocu_aggr_lab 1 "1 - Managers, professionals, and technicians" 2 "2 - Clerical, service and sales workers" 3 "3 - Skilled agricultural and trades workers" ///
				 					 4 "4 - Plant and machine operators, and assemblers" 5 "5 - Elementary occupations" 6 "6 - Armed forces" 7 "7 - Not elsewhere classified"
			    lab val ilo_job1_ocu_aggregate ocu_aggr_lab
			    lab var ilo_job1_ocu_aggregate "Occupation (Aggregate) - main job"	
		
	* Skill level
	gen ilo_job1_ocu_skill=.
	    replace ilo_job1_ocu_skill=1 if ilo_job1_ocu_isco08==9                   // Low
		replace ilo_job1_ocu_skill=2 if inlist(ilo_job1_ocu_isco08,4,5,6,7,8)    // Medium
		replace ilo_job1_ocu_skill=3 if inlist(ilo_job1_ocu_isco08,1,2,3)        // High
		replace ilo_job1_ocu_skill=4 if inlist(ilo_job1_ocu_isco08,10,11)        // Not elsewhere classified
				lab def ocu_skill_lab 1 "1 - Skill level 1 (low)" 2 "2 - Skill level 2 (medium)" 3 "3 - Skill levels 3 and 4 (high)" 4 "4 - Not elsewhere classified"
			    lab val ilo_job1_ocu_skill ocu_skill_lab
			    lab var ilo_job1_ocu_skill "Occupation (Skill level) - main job"


	
	* SECOND JOB
	
	*** Comment: it is only possible to do the skill level variable due to the mapping. 
	*** Comment: there is not variable at 4-digit level to do the mapping for second job. 
	

if `Y' < 2011   {
	
	gen occ_code_sec=.
	    replace occ_code_sec=int(sc2ksmn/10)
}
	
	
if `Y' > 2010 {
	
	gen occ_code_sec=.
	    replace occ_code_sec=int(sc10smn/10)
}



	* Skill level
	gen ilo_job2_ocu_skill=. if ilo_mjh==2
	    replace ilo_job2_ocu_skill=1 if inrange(occ_code_sec,91,92) & ilo_mjh==2                  // Low
		replace ilo_job2_ocu_skill=2 if (occ_code_sec==12 | inrange(occ_code_sec,31,82)) & ilo_mjh==2    // Medium
		replace ilo_job2_ocu_skill=3 if (occ_code_sec==11 | inrange(occ_code_sec,21,24)) & ilo_mjh==2        // High
		replace ilo_job2_ocu_skill=4 if ilo_job2_ocu_skill==. & ilo_mjh==2       // Not elsewhere classified
 			    lab val ilo_job2_ocu_skill ocu_skill_lab
			    lab var ilo_job2_ocu_skill "Occupation (Skill level) - second job"

	
    
	
}	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_job1_ins_sector')  
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		


***** MAIN JOB *****

 		 
		gen ilo_job1_ins_sector = .
			replace ilo_job1_ins_sector = 1 if publicr == 2 & ilo_lfs == 1 	// Public
			replace ilo_job1_ins_sector = 2 if inlist(publicr,-8,1) & ilo_lfs == 1    // Private
			replace ilo_job1_ins_sector = 2 if ilo_job1_ins_sector == . & ilo_lfs == 1    // Private
				lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
			    lab values ilo_job1_ins_sector ins_sector_lab
			    lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities"
	 

***** SECOND JOB *****

		 
	** no information
	 	

		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job1_job_time') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
 
***** MAIN JOB *****

  
		gen ilo_job1_job_time = .
		replace ilo_job1_job_time = 1 if ftptwk == 2 & ilo_lfs == 1 				// 1 - Part-time
		replace ilo_job1_job_time = 2 if ftptwk == 1  & ilo_lfs == 1 				// 2 - Full-time
		replace ilo_job1_job_time = 3 if ilo_job1_job_time == . & ilo_lfs == 1 		// 3 - Unknown
			lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknow"
			    lab values ilo_job1_job_time job_time_lab
			    lab var ilo_job1_job_time "Job (Working time arrangement)"


***** SECOND JOB *****


** No information


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*		1. 	Hours of work actually worked ('ilo_job1_how_actual')    
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

** MAIN JOB

* ilo_job1_how_actual

 ** ttachr total actual hours in main job
  
		gen ilo_job1_how_actual =  ttachr if ilo_lfs == 1
  				lab var ilo_job1_how_actual "Weekly hours actually worked in main job"	      
		
		
		
		gen ilo_job1_how_actual_bands = .
			 replace ilo_job1_how_actual_bands = 1 if ilo_job1_how_actual == 0			    // No hours actually worked
			 replace ilo_job1_how_actual_bands = 2 if inrange(ilo_job1_how_actual,1,14)	    // 01-14
			 replace ilo_job1_how_actual_bands = 3 if inrange(ilo_job1_how_actual,15,29)	// 15-29
			 replace ilo_job1_how_actual_bands = 4 if inrange(ilo_job1_how_actual,30,34)	// 30-34
			 replace ilo_job1_how_actual_bands = 5 if inrange(ilo_job1_how_actual,35,39)	// 35-39
			 replace ilo_job1_how_actual_bands = 6 if inrange(ilo_job1_how_actual,40,48)	// 40-48
			 replace ilo_job1_how_actual_bands = 7 if ilo_job1_how_actual>=49 & ilo_job1_how_actual !=. // 49+
			 replace ilo_job1_how_actual_bands = 8 if ilo_job1_how_actual_bands == .		// Not elsewhere classified
 			 replace ilo_job1_how_actual_bands = . if ilo_lfs!=1
				     lab def how_bands_lab 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"
					 lab val ilo_job1_how_actual_bands how_bands_lab
					 lab var ilo_job1_how_actual_bands "Weekly hours actually worked bands in main job"
					 				
				
*** SECOND JOB
 
   * ilo_job2_how_actual

    
** sumhrs: total actual hours in main and second job

       gen ilo_job2_how_actual = cond(missing(sumhrs), 0, sumhrs) - cond(missing(ttachr), 0, ttachr) if ilo_mjh==2
					lab var ilo_job2_how_actual "Weekly hours actually worked in main job"	      
		
		
		gen ilo_job2_how_actual_bands = .
			 replace ilo_job2_how_actual_bands = 1 if ilo_job2_how_actual == 0				// No hours actually worked
			 replace ilo_job2_how_actual_bands = 2 if inrange(ilo_job2_how_actual,1,14)	    // 01-14
			 replace ilo_job2_how_actual_bands = 3 if inrange(ilo_job2_how_actual,15,29)	// 15-29
			 replace ilo_job2_how_actual_bands = 4 if inrange(ilo_job2_how_actual,30,34)	// 30-34
			 replace ilo_job2_how_actual_bands = 5 if inrange(ilo_job2_how_actual,35,39)	// 35-39
			 replace ilo_job2_how_actual_bands = 6 if inrange(ilo_job2_how_actual,40,48)	// 40-48
			 replace ilo_job2_how_actual_bands = 7 if ilo_job2_how_actual>=49 & ilo_job2_how_actual !=. // 49+
			 replace ilo_job2_how_actual_bands = 8 if ilo_job2_how_actual_bands == . & ilo_mjh == 2 	// Not elsewhere classified
			 *replace ilo_job2_how_actual_bands = . if ilo_job2_how_actual == .  
                     *lab def how_actual_bands_lab 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"
					 lab val ilo_job2_how_actual_bands how_bands_lab
					 lab var ilo_job2_how_actual_bands "Weekly hours actually worked bands in second job"

	******
	
	*** ALL JOBS

				
		*** Weekly hours actually worked in all jobs		
	 	
		egen ilo_joball_how_actual = rowtotal(ilo_job1_how_actual ilo_job2_how_actual), m 
					lab var ilo_joball_how_actual "Weekly hours actually worked in all jobs"
						
		 gen ilo_joball_actual_how_bands = .
			 replace ilo_joball_actual_how_bands=1 if ilo_joball_how_actual==0 // No hours actually worked
			 replace ilo_joball_actual_how_bands=2 if ilo_joball_how_actual>=1 & ilo_joball_how_actual<=14  // 01-14
			 replace ilo_joball_actual_how_bands=3 if ilo_joball_how_actual>=15 & ilo_joball_how_actual<=29 // 15-29
			 replace ilo_joball_actual_how_bands=4 if ilo_joball_how_actual>=30 & ilo_joball_how_actual<=34 // 30-34
			 replace ilo_joball_actual_how_bands=5 if ilo_joball_how_actual>=35 & ilo_joball_how_actual<=39 // 35-39
			 replace ilo_joball_actual_how_bands=6 if ilo_joball_how_actual>=40 & ilo_joball_how_actual<=48 // 40-48
			 replace ilo_joball_actual_how_bands=7 if ilo_joball_how_actual>=49 & ilo_joball_how_actual!=.  // 49+
			 replace ilo_joball_actual_how_bands=8 if ilo_joball_actual_how_bands==. & ilo_lfs==1           // Not elsewhere classified
			 replace ilo_joball_actual_how_bands=. if ilo_lfs!=1
			 		 lab val ilo_joball_actual_how_bands how_bands_lab 
					 lab var ilo_joball_actual_how_bands "Weekly hours actually worked bands in all jobs"
			


		 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*		2. 	Hours of work usually worked ('ilo_job1_how_usual')      
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
 
*** MAIN JOB


  
		gen ilo_job1_how_usual = ttushr if ilo_lfs==1
				lab var ilo_job1_how_usual "Weekly hours usually worked in main job"	      
		
		gen ilo_job1_how_usual_bands = .
			 replace ilo_job1_how_usual_bands = 1 if ilo_job1_how_usual == 0		    // No hours usually worked
			 replace ilo_job1_how_usual_bands = 2 if inrange(ilo_job1_how_usual,1,14)	// 01-14
			 replace ilo_job1_how_usual_bands = 3 if inrange(ilo_job1_how_usual,15,29)	// 15-29
			 replace ilo_job1_how_usual_bands = 4 if inrange(ilo_job1_how_usual,30,34)	// 30-34
			 replace ilo_job1_how_usual_bands = 5 if inrange(ilo_job1_how_usual,35,39)	// 35-39
			 replace ilo_job1_how_usual_bands = 6 if inrange(ilo_job1_how_usual,40,48)	// 40-48
			 replace ilo_job1_how_usual_bands = 7 if ilo_job1_how_usual>=49 & ilo_job1_how_usual !=. // 49+
			 replace ilo_job1_how_usual_bands = 8 if ilo_job1_how_usual_bands == . & ilo_lfs == 1	// Not elsewhere classified
			 *replace ilo_job1_how_usual_bands = . if ilo_lfs == 1
			 lab def how_usu_bands_lab 1 "No hours usually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"
					 lab val ilo_job1_how_usual_bands how_usu_bands_lab
					 lab var ilo_job1_how_usual_bands "Weekly hours usually worked bands in main job"
 	
	
	
*** SECOND JOB
** Comment: no information
  
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job1_job_contract')  
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

*** MAIN JOB

 
gen ilo_job1_job_contract=.

		replace ilo_job1_job_contract = 1 if  jobtyp == 1  & ilo_job1_ste_aggregate==1 // 1 - Permanent
		replace ilo_job1_job_contract = 2 if jobtyp == 2 & ilo_job1_ste_aggregate==1 // 2 - Temporary
		replace ilo_job1_job_contract = 3 if ilo_job1_job_contract == . & ilo_job1_ste_aggregate==1 // 3 - Unknown
				lab def job_contract_lab 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"
			    lab val ilo_job1_job_contract job_contract_lab
			    lab var ilo_job1_job_contract "Job (Type of contract)"

	
	
*** SECOND JOB

* Comment: No information
	 
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Formal / Informal Economy ('ilo_job1_ife_prod' 'ilo_job1_ife_nature')  
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
 
 * Comment: No information

 

/* Useful questions:
			- Institutional sector: publicr
			- Destination of production: ***  
			- Bookkeeping: ***  
			- Registration: *** 
			- Household identification: ilo_job1_eco_isic4_2digits==97 or ilo_job1_ocu_isco08_2digits==63
			- Social security contribution: *** 				 	
			- Place of work: ***   		
			- Size:  mpnr02  
			- Status in employment: ilo_job1_ste_aggregate / ilo_job1_ste_icse93
			- Paid annual leave:  HOLS (not available in the microdata set)
			- Paid sick leave: bentyp6  
*/

	
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Monthly related income ('ilo_job1_lri_ees' and 'ilo_job1_lri_slf')    
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

** No possible to compute because of the weights. 
		
			
				
***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_joball_tru') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

** Comment: according to the Office for National Statistics (UK), people are classified as UNDEREMPLOYMENT when they are:
**** 			-  available to start working longer hours within two weeks(undst), and
****			-  actual weekly hours worked were 40 or less (for people aged under 18) or 48 or less (for people aged 18 and over) 
 
** undhrs: extra hours wished to work
** undst: could work longer hours within next 2 weeks
		
		gen ilo_joball_tru = .
		replace ilo_joball_tru = 1 if  !inlist(undhrs,-9,99) & undst==1 & ( (ilo_job1_how_usual<=40 & ilo_age<18) | (ilo_job1_how_usual<=48 & ilo_age>=18))
			lab def lab_joball_tru 1 "Time-related underemployed" 
			lab val ilo_joball_tru lab_joball_tru
			lab var ilo_joball_tru "Time-related underemployed"
					
  
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Cases of non-fatal occupational injury ('ilo_joball_oi_case') [not done]
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------

** No information available
** According to the questionnaire the variable is ACCDNT (pag.181), but this variable does not appear in the microdata set


*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Days lost due to cases of occupational injury ('ilo_joball_oi_day')    
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------

** No information available
** According to the questionnaire the variable is TIMEDAYS (pag.182), but this variable does not appear in the microdata set
	
 

***********************************************************************************************
*			PART 3.3. UNEMPLOYMENT: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Category of unemployment ('ilo_cat_une')  
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------


		gen ilo_cat_une=.
		replace ilo_cat_une=1 if everwk == 1 & ilo_lfs==2				                    // 1 - Unemployed previously employed
		replace ilo_cat_une=2 if everwk == 2 & inrange(lkftpa,1,3) & ilo_lfs==2				// 2 - Unemployed seeking their first job
		replace ilo_cat_une=3 if (ilo_cat_une==. & ilo_lfs==2)			                    // 3 - Unknown
			lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
			    lab values ilo_cat_une cat_une_lab
			    lab var ilo_cat_une "Category of unemployment"				
				
				
* -------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur')    
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
 
     
 
	 gen ilo_dur_details=.
	 		    *replace ilo_dur_details=1 if (durun  & ilo_lfs==2)                         // Less than 1 month
	 		 	replace ilo_dur_details=2 if (durun==1 & ilo_lfs==2)                         // 1 to 3 months
	  		 	replace ilo_dur_details=3 if (durun==2 & ilo_lfs==2)                         // 3 to 6 months
	 		 	replace ilo_dur_details=4 if (durun==3 & ilo_lfs==2)                         // 6 to 12 months
	 		 	replace ilo_dur_details=5 if (durun==4 & ilo_lfs==2)               // 12 to 24 months
	 		 	replace ilo_dur_details=6 if (inrange(durun,5,8) & ilo_lfs==2)              // 24 months or more
	 		 	replace ilo_dur_details=7 if (inlist(durun,-8,-9) & ilo_lfs==2)             // Not elsewhere classified
				replace ilo_dur_details=7 if (ilo_dur_details==. & ilo_lfs==2)             // Not elsewhere classified
	 		 	        lab def ilo_unemp_det 1 "Less than 1 month" 2 "1 month to less than 3 months" 3 "3 months to less than 6 months" ///
	 		 								  4 "6 months to less than 12 months" 5 "12 months to less than 24 months" 6 "24 months or more" ///
	 		 								  7 "Not elsewhere classified"
	 		 		    lab val ilo_dur_details ilo_unemp_det
	 		 		    lab var ilo_dur_details "Duration of unemployment (Details)"
 
 
						
	  gen ilo_dur_aggregate=.
	  	replace ilo_dur_aggregate=1 if (inlist(ilo_dur_details,1,2,3) & ilo_lfs==2)       // Less than 6 months
	  	replace ilo_dur_aggregate=2 if (ilo_dur_details==4 & ilo_lfs==2)                  // 6 to 12 months
	  	replace ilo_dur_aggregate=3 if (inlist(ilo_dur_details,5,6) & ilo_lfs==2)         // 12 months or more
	   	replace ilo_dur_aggregate=4 if (ilo_dur_aggregate==. & ilo_lfs==2)                 //Not elsewhere classified
	  	replace ilo_dur_aggregate=. if ilo_lfs!=2
	  		lab def ilo_unemp_aggr 1 "Less than 6 months" 2 "6 months to less than 12 months" 3 "12 months or more" 4 "Not elsewhere classified"
	  		lab val ilo_dur_aggregate ilo_unemp_aggr
	  		lab var ilo_dur_aggregate "Duration of unemployment (Aggregate)"
			
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco')    
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

if `Y' > 2008 {

  * 2-digit level	 
	gen ilo_preveco_isic4_2digits =  indd07l if  ilo_cat_une == 1 & !inlist(indd07l,-8,-9)
	
		 lab val ilo_preveco_isic4_2digits eco_isic4_digits
        lab var ilo_preveco_isic4_2digits "Previous economic activity (ISIC Rev. 4), 2 digits levels"

 
	* 1-digit level
    gen ilo_preveco_isic4 = .
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
	    replace ilo_preveco_isic4=22 if ilo_preveco_isic4_2digits==.  & ilo_cat_une == 1
   	  		    lab val ilo_preveco_isic4 eco_isic4
			    lab var ilo_preveco_isic4 "Previous economic activity (ISIC Rev. 4)"

   * Aggregate level
   gen ilo_preveco_aggregate = .
	   replace ilo_preveco_aggregate=1 if ilo_preveco_isic4==1
	   replace ilo_preveco_aggregate=2 if ilo_preveco_isic4==3
	   replace ilo_preveco_aggregate=3 if ilo_preveco_isic4==6
	   replace ilo_preveco_aggregate=4 if inlist(ilo_preveco_isic4,2,4,5)
	   replace ilo_preveco_aggregate=5 if inrange(ilo_preveco_isic4,7,14)
	   replace ilo_preveco_aggregate=6 if inrange(ilo_preveco_isic4,15,21)
	   replace ilo_preveco_aggregate=7 if ilo_preveco_isic4==22
 			   lab val ilo_preveco_aggregate eco_aggr_lab
			   lab var ilo_preveco_aggregate "Previous economic activity (Aggregate)"

	}
	
	
	
	if `Y' < 2009 {
	
	* 2-digit level	
	
	recode indd92l  				(1=1)	(2=2)	(3=5)	(4=10)	(5=11)	(6=12)	(7=13)	(8=14)	(9=15)	(10=16)	(11=17)	(12=18)	(13=19)	(14=20)	(15=21)	(16=22)	(17=23)	(18=24)	(19=25) ///
									(20=26)	(21=27)	(22=28)	(23=29)	(24=30)	(25=31)	(26=32)	(27=33)	(28=34)	(29=35)	(30=36)	(31=37)	(32=40)	(33=41)	(34=45)	(35=50)	(36=51)	(37=52)	(38=55)	(39=60)	///
									(40=61)	(41=62)	(42=63)	(43=64)	(44=65)	(45=66)	(46=67)	(47=70)	(48=71)	(49=72)	(50=73)	(51=74)	(52=75)	(53=80)	(54=85)	(55=90)	(56=91)	(57=92)	(58=93)	(59=95)	///
									(60=99) if !inlist(indd92l,-8,-9,62) &  ilo_cat_une==1, gen(ilo_preveco_isic3_2digits)
									
 
		lab val ilo_preveco_isic3_2digits eco_isic3_2digits
        lab var ilo_preveco_isic3_2digits "Previous economic activity (ISIC Rev. 3.1), 2 digits levels"

  

	* 1-digit level
	
	 gen ilo_preveco_isic3 = .
	    replace ilo_preveco_isic3=1 if inrange(ilo_preveco_isic3_2digits,1,2)
	    replace ilo_preveco_isic3=2 if ilo_preveco_isic3_2digits==5
	    replace ilo_preveco_isic3=3 if inrange(ilo_preveco_isic3_2digits,10,14)
	    replace ilo_preveco_isic3=4 if inrange(ilo_preveco_isic3_2digits,15,37)
	    replace ilo_preveco_isic3=5 if inrange(ilo_preveco_isic3_2digits,40,41)
	    replace ilo_preveco_isic3=6 if ilo_preveco_isic3_2digits==45
	    replace ilo_preveco_isic3=7 if inrange(ilo_preveco_isic3_2digits,50,52)
	    replace ilo_preveco_isic3=8 if ilo_preveco_isic3_2digits==55
	    replace ilo_preveco_isic3=9 if inrange(ilo_preveco_isic3_2digits,60,64)
	    replace ilo_preveco_isic3=10 if inrange(ilo_preveco_isic3_2digits,65,67)
	    replace ilo_preveco_isic3=11 if inrange(ilo_preveco_isic3_2digits,70,74)
	    replace ilo_preveco_isic3=12 if ilo_preveco_isic3_2digits==75
	    replace ilo_preveco_isic3=13 if ilo_preveco_isic3_2digits==80		
	    replace ilo_preveco_isic3=14 if ilo_preveco_isic3_2digits==85
	    replace ilo_preveco_isic3=15 if inrange(ilo_preveco_isic3_2digits,90,93)
        replace ilo_preveco_isic3=16 if ilo_preveco_isic3_2digits==95
	    replace ilo_preveco_isic3=17 if ilo_preveco_isic3_2digits==99
	    replace ilo_preveco_isic3=18 if ilo_preveco_isic3_2digits==. & ilo_cat_une==1 
 			    lab val ilo_preveco_isic3 eco_isic3
			    lab var ilo_preveco_isic3 "Previous economic activity (ISIC Rev. 3.1)"
	
	
	
		
	  

   * Aggregate level
   gen ilo_preveco_aggregate = .
	   replace ilo_preveco_aggregate=1 if inlist(ilo_preveco_isic3,1,2)
	   replace ilo_preveco_aggregate=2 if ilo_preveco_isic3==4
	   replace ilo_preveco_aggregate=3 if ilo_preveco_isic3==6
	   replace ilo_preveco_aggregate=4 if inlist(ilo_preveco_isic3,3,5)
	   replace ilo_preveco_aggregate=5 if inrange(ilo_preveco_isic3,7,11)
	   replace ilo_preveco_aggregate=6 if inrange(ilo_preveco_isic3,12,17)
	   replace ilo_preveco_aggregate=7 if ilo_preveco_isic3==18
 			   lab val ilo_preveco_aggregate eco_aggr_lab
			   lab var ilo_preveco_aggregate "Previous economic activity (Aggregate)"
			   
			   
			   
}   


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu')   
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

 *** Comment: it is only possible to do the skill level variable due to the mapping (there is no variable at 4-digit level). 

 
 
 if todrop >= "2001Q2"{

 
 if `Y' > 2010 {
 
	gen occ_code_prev=.
	    replace occ_code_prev=int(sc10lmn/10)

}



if `Y' < 2011 {
 
	gen occ_code_prev=.
	    replace occ_code_prev=int(sc2klmn/10)

}


	
     
		
	* Skill level
	gen ilo_prevocu_skill=. if ilo_cat_une == 1
	    replace ilo_prevocu_skill=1 if inrange(occ_code_prev,91,92)  & ilo_cat_une == 1                 // Low
		replace ilo_prevocu_skill=2 if (occ_code_prev==12 | inrange(occ_code_prev,31,82)) & ilo_cat_une == 1    // Medium
		replace ilo_prevocu_skill=3 if (occ_code_prev==11 | inrange(occ_code_prev,21,24))  & ilo_cat_une == 1       // High
		replace ilo_prevocu_skill=4 if ilo_prevocu_skill==. & ilo_cat_une == 1       // Not elsewhere classified
 			    lab val ilo_prevocu_skill ocu_skill_lab
			    lab var ilo_prevocu_skill "Previous occupation occupation (Skill level)"
			 
}				  
				  
***********************************************************************************************
*			PART 3.4. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************		


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
 
		gen ilo_olf_dlma = .
		
		replace ilo_olf_dlma = 1 if ilo_lfs == 3 & look4==1 & start==2 		            // Seeking (actively), not available
		replace ilo_olf_dlma = 2 if ilo_lfs == 3 & look4==2 & start==1 		            // Not seeking, available
		replace ilo_olf_dlma = 3 if ilo_lfs == 3 & likewk== 1 & start==2 		        // Not seeking, not available, willing  
		* definition of category 4 has been defined relaxing availability criteria of availability for category 4 
		replace ilo_olf_dlma = 4 if ilo_lfs == 3 & likewk== 2 & !inrange(ilo_olf_dlma,1,3)            // Not seeking, not available, not willing  
		
		replace ilo_olf_dlma = 5 if	ilo_olf_dlma == . & ilo_lfs == 3			 // Not classified 
				lab def dlma_lab 1 "1 - Seeking, not available (Unavailable jobseekers)" 2 "2 - Not seeking, available (Available potential jobseekers)" ///
	    						 3 "3 - Not seeking, not available, willing (Willing non-jobseekers)" 4 "4 - Not seeking, not available, not willing" 5 "X - Not elsewhere classified"
		    	lab val ilo_olf_dlma dlma_lab 
			    lab var ilo_olf_dlma "Labour market attachment (Degree of)"
		
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reason for not seeking job ('ilo_olf_reason')  
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------


** no information available for 2005Q1

if  todrop <= "2004Q4" {    
gen ilo_olf_reason = .
			replace ilo_olf_reason = 1 if  nolook==6 & ilo_lfs==3              // Labour market
			replace ilo_olf_reason = 2 if inlist(nolook,1,7) & ilo_lfs==3      // Other labour market reasons
			replace ilo_olf_reason = 3 if inrange(nolook,2,5)  & ilo_lfs==3    // Personal/Family-related
			*replace ilo_olf_reason = 4 if                               	 // Does not need/want to work
			replace ilo_olf_reason = 5 if nolook==8  & ilo_lfs==3	         // Not elsewhere classified
			replace ilo_olf_reason = 5 if ilo_olf_reason==. & ilo_lfs==3	 // Not elsewhere classified  	
 
			lab def reasons_lab 1 "1 - Labour market" 2 "2 - Other labour market reasons" 3 "3 - Personal / Family-related" ///
									    4 "4 - Does not need/want to work" 5 "5 - Not elsewhere classified"
				    lab val ilo_olf_reason reasons_lab 
				    lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"	
	}	





if  todrop >= "2005Q2" {    
gen ilo_olf_reason = .
			replace ilo_olf_reason = 1 if  nolwm==6 & ilo_lfs==3              // Labour market
			replace ilo_olf_reason = 2 if inlist(nolwm,1,7) & ilo_lfs==3      // Other labour market reasons
			replace ilo_olf_reason = 3 if inrange(nolwm,2,5)  & ilo_lfs==3    // Personal/Family-related
			replace ilo_olf_reason = 4 if inlist(nolwm,8,9) & ilo_lfs==3	 // Does not need/want to work
			replace ilo_olf_reason = 5 if nolwm==10  & ilo_lfs==3	         // Not elsewhere classified
			replace ilo_olf_reason = 5 if ilo_olf_reason==. & ilo_lfs==3	 // Not elsewhere classified  	
			
			lab def reasons_lab 1 "1 - Labour market" 2 "2 - Other labour market reasons" 3 "3 - Personal / Family-related" ///
									    4 "4 - Does not need/want to work" 5 "5 - Not elsewhere classified"
				    lab val ilo_olf_reason reasons_lab 
				    lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"	
 
	}		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seeker ('ilo_dis')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* no possible to compute for 2005Q1 

if  todrop != "2005Q1" {
	gen ilo_dis = 1 if (ilo_lfs==3 & start==1 & ilo_olf_reason==1)
			lab def dis_lab 1 "Discouraged job-seekers"
			lab val ilo_dis dis_lab
			lab var ilo_dis "Discouraged job-seekers"
}	
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training ('ilo_neet')  
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
 
	gen ilo_neet = 1 if ilo_age_aggregate==2 & ilo_lfs!=1 & ilo_edu_attendance==2
		lab def neet_lab 1 "Youth not in education, employment or training"
		lab val ilo_neet neet_lab
		lab var ilo_neet "Youth not in education, employment or training"
	
	
	
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
		
		drop if ilo_sex == . 
 		 
		compress 
		
		/*Save dataset including original and ilo variables*/
	
		save ${country}_${source}_${time}_FULL,  replace		

		/* Save file only containing ilo_* variables*/
	
		keep ilo_*

		save ${country}_${source}_${time}_ILO, replace
				
