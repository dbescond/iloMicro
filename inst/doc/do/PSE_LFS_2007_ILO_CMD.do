* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Palestine
* DATASET USED: Palestine LFS
* NOTES: 
* Files created: Standard variables on LFS Palestine
* Authors: DPAU
* Starting Date: 07 December 2017
* Last updated: 07 March 2018
***********************************************************************************************


*******************************************************************
 /* 1.	Set up work directory, file name, variables and function */
*******************************************************************

clear all 

set more off

 
global path "J:\DPAU\MICRO"
global country "PSE"
global source "LFS"
global time "2007"
global inputFile "LFS_2007.DTA"

global inpath "${path}\\${country}\\${source}\\${time}\ORI"
global temppath "${path}\_Admin"
global outpath "${path}\\${country}\\${source}\\${time}"
 
************************************************************************************

* Important : if package « labutil » not already installed, install it in order to execute correctly the do-file

	* ssc install labutil

************************************************************************************

		* NOTE: if you want this do-file to run correctly, run it without breaks!
		
cd "$temppath"
		

*********************************************************************************************

* Load original dataset

*********************************************************************************************

cd "$inpath"

	use "${inputFile}", clear	
	
	rename *, lower
		
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
*			Identifier ('ilo_key')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_key=_n 
		lab var ilo_key "Key unique identifier per individual"	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sample Weight ('ilo_wgt')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------


if (`Y' > 2010) | (`Y' < 2008 & `Y' > 1998) {
	
	gen ilo_wgt = wfinal  	
}





if (`Y' < 1999) {

	gen ilo_wgt = rweight  	

}


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

* Comment: Persons living in camps are classified as "not elsewhere classified"

* Comment: there is no infomation on urban/rural in 1995. 
 


* Comment: Persons living in camps (category 3) are classified as "not elsewhere classified"




if `Y' < 2008 & `Y' > 1995 {
	gen geo = id07
}	


if `Y' > 1995 {

		gen ilo_geo=.
			replace ilo_geo=1 if geo==1
			replace ilo_geo=2 if geo==2
			replace ilo_geo=3 if geo==3| geo==.
				lab def geo_lab 1 "1 - Urban" 2 "2 - Rural" 3 "3 - Not elsewhere classified"
				lab val ilo_geo geo_lab
				lab var ilo_geo "Geographical coverage"

}				
				
* Comment: Classification here is not the usual Urban/Rural but in line with the specific classification of Palestine (Palestine = West Bank + Gaza Strip)

		gen ilo_geo_pse=.
			replace ilo_geo_pse=1 if (wbgs==1)
			replace ilo_geo_pse=2 if (wbgs==2)
				lab def pse_geo_lab 1 "1 - West Bank" 2 "2 - Gaza Strip"
				lab val ilo_geo_pse pse_geo_lab
				lab var ilo_geo "Geographical coverage"


 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

if (`Y' < 2005 & `Y' > 2002) | (`Y' < 1999 & `Y' > 1996) {
		
		gen ilo_sex=hr2
		
	}
	
	
if (`Y' < 2013 & `Y' > 2004) | (`Y' < 2003 & `Y' > 1998){
		
		gen ilo_sex=sex
		
	}
	
if  `Y' == 1996 {
		
		gen ilo_sex=hr02
		
	}	

if  `Y' == 1995 {
		
		gen ilo_sex=hr1
		
	}	
	
			label define label_Sex 1 "1 - Male" 2 "2 - Female"
			label values ilo_sex label_Sex 
			lab var ilo_sex "Sex" 
 
 
 
 
 * -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: Note that only individuals aged 10+ are considered ! Therefore population 10+ = population 0+ in the Microdata

if (`Y' < 2005 & `Y' > 2000) {
		
		gen ilo_age=pr1
		
	}
	
	
if (`Y' < 2013 & `Y' > 2004) | (`Y' < 2001 & `Y' > 1998) {		
		
		gen ilo_age=age
		
	}
	

if (`Y' < 1999 & `Y' > 1996)  {		
		
		gen ilo_age=hr4
		
	}	

if `Y' == 1996 {		
		
		gen ilo_age=hr04
		
	}	

if `Y' == 1995 {		
		
		gen ilo_age=hr2
		
	}	
	
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
			replace ilo_age_5yrbands=14 if ilo_age>=65 
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
			replace ilo_age_10yrbands=7 if ilo_age>=65
				lab def age_by10_lab 1 "<15" 2 "15-24" 3 "25-34" 4 "35-44" 5 "45-54" 6 "55-64" 7 "65+"
				lab val ilo_age_10yrbands age_by10_lab
				lab var ilo_age_10yrbands "Age (10-year age bands)"
				
		gen ilo_age_aggregate=.
			replace ilo_age_aggregate=1 if inrange(ilo_age,0,15)
			replace ilo_age_aggregate=2 if inrange(ilo_age,15,24)
			replace ilo_age_aggregate=3 if inrange(ilo_age,25,54)
			replace ilo_age_aggregate=4 if inrange(ilo_age,55,64)
			replace ilo_age_aggregate=5 if ilo_age>=65 
				lab def age_aggr_lab 1 "<15" 2 "15-24" 3 "25-54" 4 "55-64" 5 "65+"
				lab val ilo_age_aggregate age_aggr_lab
				lab var ilo_age_aggregate "Age (Aggregate)"

		gen ilo_age_pse=.
			replace ilo_age_pse=1 if inrange(ilo_age,15,24)
			replace ilo_age_pse=2 if (ilo_age>=25 & ilo_age!=.)
				lab def age_pse_lab 1 "15-24" 2 "25+"
				lab val ilo_age_pse age_pse_lab
				lab var ilo_age_pse "Age (Aggregate)"

			* As only age bands being kept drop "ilo_age" at the very end -> Use it in between as help variable.

 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Level of education ('ilo_edu')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

** isced11

if (`Y' < 2005 & `Y' > 2000) | `Y' == 1998 {
		
		gen educ=pr4
		
	}
	



if (`Y' < 2008 & `Y' > 2004) | `Y' == 2000 {
		
		gen educ=edu_qual
		
	}	

if `Y' == 1999 {		
		
		gen educ=edqul
		
	}	
	
 
 ** There is no level of education information in 1996 or 1995. 


	* Comment: Completed level of education always to be considered !

 if (`Y' > 1997) {
 
		gen ilo_edu_isced11=.
				* No schooling
			replace ilo_edu_isced11=1 if educ==1 
				* Early childhood education
			replace ilo_edu_isced11=2 if educ==2 
				* Primary education
			replace ilo_edu_isced11=3 if educ==3
				* Lower secondary education
			replace ilo_edu_isced11=4 if educ==4
				* Upper secondary education
			replace ilo_edu_isced11=5 if educ==5
				* Post-secondary non-tertiary education
			replace ilo_edu_isced11=6 if educ==6
				* Short-cycle tertiary education
			/* replace ilo_edu_isced11=7 if educ==6 */
				* Bachelor's or equivalent level
			replace ilo_edu_isced11=8 if educ==7
				* Master's or equivalent level
			replace ilo_edu_isced11=9 if (educ==8 | educ==9)
				* Doctoral or equivalent level 
			replace ilo_edu_isced11=10 if educ==10
				* Not elsewhere classified
			replace ilo_edu_isced11=11 if ilo_edu_isced11==.
				label def isced_11_lab 1 "X - No schooling" 2 "0 - Early childhood education" 3 "1 - Primary education" 4 "2 - Lower secondary education" 5 "3 - Upper secondary education" ///
										6 "4 - Post-secondary non-tertiary education" 7 "5 - Short-cycle tertiary education" 8 "6 - Bachelor's or equivalent level" 9 "7 - Master's or equivalent level" ///
										10 "8 - Doctoral or equivalent level" 11 "9 - Not elsewhere classified"
				label val ilo_edu_isced11 isced_11_lab
				lab var ilo_edu_isced11 "Education (ISCED 11)"

	* For the definition, cf. the document "Guide to reporting labour statistics to the ILO using the Excel questionnaire"
			
		gen ilo_edu_aggregate=.
			replace ilo_edu_aggregate=1 if inlist(ilo_edu_isced11,1,2)
			replace ilo_edu_aggregate=2 if inlist(ilo_edu_isced11,3,4)
			replace ilo_edu_aggregate=3 if inlist(ilo_edu_isced11,5,6)
			replace ilo_edu_aggregate=4 if inlist(ilo_edu_isced11,7,8,9,10)
			replace ilo_edu_aggregate=5 if ilo_edu_isced11==11
				label def edu_aggr_lab 1 "1 - Less than basic" 2 "2 - Basic" 3 "3 - Intermediate" 4 "4 - Advanced" 5 "5 - Level not stated"
				label val ilo_edu_aggregate edu_aggr_lab
				label var ilo_edu_aggregate "Education (Aggregate level)" 
}

 

 if `Y' == 1997 {
 
 
	gen ilo_edu_isced97=.
		replace ilo_edu_isced97=1 if hr8==1  					// No schooling
		replace ilo_edu_isced97=2 if hr8==2 					// Pre-primary education
		replace ilo_edu_isced97=3 if hr8==3  		            // Primary education or first stage of basic education
		replace ilo_edu_isced97=4 if hr8==4  		            // Lower secondary or second stage of basic education
		replace ilo_edu_isced97=5 if hr8==5           	    // Upper secondary education
		replace ilo_edu_isced97=6 if hr8==6                         	// Post-secondary non-tertiary education
		replace ilo_edu_isced97=7 if hr8==7       	        // First stage of tertiary education (not leading directly to an advanced research qualification)
		*replace ilo_edu_isced97=8 if    				        // Second stage of tertiary education (leading to an advanced research qualification)
		replace ilo_edu_isced97=9 if ilo_edu_isced97==.		    // Level  not stated
			label def isced_97_lab 1 "X - No schooling" 2 "0 - Pre-primary education" 3 "1 - Primary education or first stage of basic education" 4 "2 - Lower secondary education or second stage of basic education" ///
							5 "3 - Upper secondary education" 6 "4 - Post-secondary non-tertiary education" 7 "5 - First stage of tertiary education (not leading directly to an advanced research qualification)" ///
							8 "6 - Second stage of tertiary education (leading to an advanced research qualification)" 9 "UNK - Level not stated"
			label val ilo_edu_isced97 isced_97_lab
			lab var ilo_edu_isced97 "Education (ISCED 97)"

		
	gen ilo_edu_aggregate=.
		replace ilo_edu_aggregate=1 if inlist(ilo_edu_isced97,1,2)
		replace ilo_edu_aggregate=2 if inlist(ilo_edu_isced97,3,4)
		replace ilo_edu_aggregate=3 if inlist(ilo_edu_isced97,5,6)
		replace ilo_edu_aggregate=4 if inlist(ilo_edu_isced97,7,8)
		replace ilo_edu_aggregate=5 if ilo_edu_isced97==9
			label def edu_aggr_lab 1 "1 - Less than basic" 2 "2 - Basic" 3 "3 - Intermediate" 4 "4 - Advanced" 5 "5 - Level not stated"
			label val ilo_edu_aggregate edu_aggr_lab
			label var ilo_edu_aggregate "Education (Aggregate level)"
 
 
 
 }
 

 * -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education attendance ('ilo_edu_attendance')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
 
 
if (`Y' < 2005 & `Y' > 2000) | `Y' == 1998 {
		
		gen att=pr2
		
	}
	
if (`Y' < 2012 & `Y' > 2004) | (`Y' < 2001 & `Y' > 1998) {
		
		gen att=atten
		
	}	

if `Y' == 1997 {		
		
		gen att=hr6
		
	}	

if `Y' == 1996 {		
		
		gen att=hr06
		
	}	

if `Y' == 1995 {		
		
		gen att=hr4
		
	}	 

	
		gen ilo_edu_attendance=.
			replace ilo_edu_attendance=1 if att==1
			replace ilo_edu_attendance=2 if att!=1
			replace ilo_edu_attendance=3 if ilo_edu_attendance==.
	
				lab def edu_attendance_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
				lab val ilo_edu_attendance edu_attendance_lab
				lab var ilo_edu_attendance "Education (Attendance)"		

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			           Marital status ('ilo_mrts') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: the variable related to marital status in the questionnaire is "pr5". However, in the dataset, this variable is not included; instead, there is the 
*          variable "maritals". This variable can be only mapped to the aggregate ilo variable. 
* due to the "maritals" variable has three defined categories, it is supposed that the category "other" corresponds to widow/divorced/separated from the original variable (pr5)

/*	
	* Detailed
	gen ilo_mrts_details=.
	    replace ilo_mrts_details=1 if                                           // Single
		replace ilo_mrts_details=2 if                                           // Married
		replace ilo_mrts_details=3 if                                           // Union / cohabiting
		replace ilo_mrts_details=4 if                                           // Widowed
		replace ilo_mrts_details=5 if                                           // Divorced / separated
		replace ilo_mrts_details=6 if ilo_mrts_details==.			            // Not elsewhere classified
		        label define label_mrts_details 1 "1 - Single" 2 "2 - Married" 3 "3 - Union / cohabiting" ///
				                                4 "4 - Widowed" 5 "5 - Divorced / separated" 6 "6 - Not elsewhere classified"
		        label values ilo_mrts_details label_mrts_details
		        lab var ilo_mrts_details "Marital status"
		*/		
	* Aggregate
	gen ilo_mrts_aggregate=.
	    replace ilo_mrts_aggregate=1 if inlist(maritals,1,3)                      // Single / Widowed / Divorced / Separated
		replace ilo_mrts_aggregate=2 if maritals==2                               // Married / Union / Cohabiting
		replace ilo_mrts_aggregate=3 if ilo_mrts_aggregate==. 			        // Not elsewhere classified
		        label define label_mrts_aggregate 1 "1 - Single / Widowed / Divorced / Separated" 2 "2 - Married / Union / Cohabiting" 3 "3 - Not elsewhere classified"
		        label values ilo_mrts_aggregate label_mrts_aggregate
		        lab var ilo_mrts_aggregate "Marital status (Aggregate levels)"				
				

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Disability status ('ilo_dsb_details') [no info]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment: This variable can't be produced
				
	* gen ilo_dsb_aggregate=.


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
        
* Comment: 	

	gen ilo_wap=.
		replace ilo_wap=1 if (ilo_age>=15 & ilo_age!=.)
		*replace ilo_wap=0 if ilo_age<15
			label def ilo_wap_lab 1 "Working age population"
			label val ilo_wap ilo_wap_lab
			label var ilo_wap "Working age population"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Labour Force Status ('ilo_lfs')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
     	 
* Comment: 	Reference period for unemployment: 4 last weeks for job search, but one week for availability. 
*			This is a national definition, the criteria of availability is relaxed with pw12==1 and the active labour search is relaxed (however, there is not information about willingness)
* 			Variable pre-calculated by NSO: empch (dataset not perfectly cleaned, therefore slight differences in numbers of unemployed and outside the labour force)

	gen ilo_lfs=.
		replace ilo_lfs=1 if (pw01==1 | pw02==1 | pw03==1)
		replace ilo_lfs=2 if ilo_lfs!=1 & empch==2
		replace ilo_lfs=3 if !inlist(ilo_lfs,1,2)
		replace ilo_lfs=. if ilo_wap!=1	
				label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status" 

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
 

	gen ilo_mjh=.
		replace ilo_mjh=1 if pw05==2
		replace ilo_mjh=2 if pw05==1
		replace ilo_mjh=. if ilo_lfs!=1
				* force missing values into "one job only" 
				replace ilo_mjh=1 if ilo_mjh==. & ilo_lfs==1
			lab def lab_ilo_mjh 1 "1 - One job only" 2 "2 - More than one job"
			lab val ilo_mjh lab_ilo_mjh

			lab var ilo_mjh "Multiple job holders"				

			
***********************************************************************************************
*			PART 3.1. ECONOMIC CHARACTERISTICS FOR MAIN JOB 
***********************************************************************************************		

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Status in employment ('ilo_ste')
* -------------------------------------------------------------------------------------------
* ------------------------------------------------------------------------------------------- 

 

	* Primary activity

if `Y' > 1998 {
	gen ilo_job1_ste_icse93=.
			replace ilo_job1_ste_icse93=1 if inrange(pw23,4,10) // 1 - Employees
			replace ilo_job1_ste_icse93=2 if pw23==1  // 2 - Employers
			replace ilo_job1_ste_icse93=3 if pw23==2 // 3 - Own-account workers
			/* replace ilo_job1_ste_icse93=4 if */
			replace ilo_job1_ste_icse93=5 if pw23==3 // 5 - Contributing family workers
			replace ilo_job1_ste_icse93=6 if ilo_job1_ste_icse93==. & ilo_lfs==1
			replace ilo_job1_ste_icse93=. if ilo_lfs!=1		
	}

	if `Y' < 1999 {
	gen ilo_job1_ste_icse93=.
			replace ilo_job1_ste_icse93=1 if inrange(pw23,4,8) // 1 - Employees
			replace ilo_job1_ste_icse93=2 if pw23==1  // 2 - Employers
			replace ilo_job1_ste_icse93=3 if pw23==2 // 3 - Own-account workers
			/* replace ilo_job1_ste_icse93=4 if */
			replace ilo_job1_ste_icse93=5 if pw23==3 // 5 - Contributing family workers
			replace ilo_job1_ste_icse93=6 if ilo_job1_ste_icse93==. & ilo_lfs==1
			replace ilo_job1_ste_icse93=. if ilo_lfs!=1		
	}

	
	
	
	 
				label define label_ilo_ste_icse93 1 "1 - Employees" 2 "2 - Employers" 3 "3 - Own-account workers" 4 "4 - Members of producers' cooperatives" 5 "5 - Contributing family workers" ///
												  6 "6 - Workers not classifiable by status"
				label val ilo_job1_ste_icse93 label_ilo_ste_icse93
				label var ilo_job1_ste_icse93 "Status in employment (ICSE 93)"
				

	* Aggregate categories
	
		gen ilo_job1_ste_aggregate=.
			replace ilo_job1_ste_aggregate=1 if ilo_job1_ste_icse93==1
			replace ilo_job1_ste_aggregate=2 if inlist(ilo_job1_ste_icse93,2,3,4,5)
			replace ilo_job1_ste_aggregate=3 if ilo_job1_ste_icse93==6
				lab def ste_aggr_lab 1 "1 - Employees" 2 "2 - Self-employed" 3 "3 - Not elsewhere classified"
				lab val ilo_job1_ste_aggregate ste_aggr_lab
				label var ilo_job1_ste_aggregate "Status in employment (Aggregate)" 
		


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

 

* main activity:	
	gen indu_code_prim=pw20 if ilo_lfs==1 & !inlist(pw20,0,4,6,86)

* second activity:	
	** No information available
		
		
		* Two-digit level
		
		gen ilo_job1_eco_isic3_2digits=indu_code_prim
		
			lab def eco_isic3_2digits 1 "01 - Agriculture, hunting and related service activities" 2 "02 - Forestry, logging and related service activities" ///
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

			lab val ilo_job1_eco_isic3_2digits eco_isic3_2digits
			lab var ilo_job1_eco_isic3_2digits "Economic activity (ISIC Rev. 3.1), 2 digits levels - main job"
	
	
	
 
	
		* Secondary activity
		
				** No information available
				
		
		* One digit level
	
		
		* Primary activity
		
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
	    replace ilo_job1_eco_isic3=18 if ilo_job1_eco_isic3==. & ilo_lfs==1
		        lab def eco_isic3 1  "A - Agriculture, hunting and forestry "	2  "B - Fishing "	3  "C - Mining and quarrying "	4  "D - Manufacturing " ///
                                  5  "E - Electricity, gas and water supply "	6  "F - Construction "	7  "G - Wholesale and retail trade; repair of motor vehicles, motorcycles and personal and household goods "	8  "H - Hotels and restaurants " ///
                                  9  "I - Transport, storage and communications "	10  "J - Financial intermediation "	11  "K - Real estate, renting and business activities "	12  "L - Public administration and defence; compulsory social security " ///
                                  13  "M - Education "	14  "N - Health and social work "	15  "O - Other community, social and personal service activities "	16  "P - Activities of private households as employers and undifferentiated production activities of private households " ///
                                  17  "Q - Extraterritorial organizations and bodies "	18  "X - Not elsewhere classified "		
			    lab val ilo_job1_eco_isic3 eco_isic3
			    lab var ilo_job1_eco_isic3 "Economic activity (ISIC Rev. 3.1) - main job"
				
				

					
	* Secondary activity
		
			** No information available
			
			
		
	* Now do the classification at an aggregated level
	
		* Primary activity
		
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


				
	
	
				
		* Secondary activity
		
				** No information available




* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_ocu')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

** Comment:  ISCO-88 classification used

	* Two-digits level

	
	
		* Primary occupation
	
		gen ilo_job1_ocu_isco88_2digits=pw22 if ilo_lfs==1 & !inlist(pw22,1,8,20,53,99)
		
			lab def ocu_isco88_2digits 	1 "01 - Armed forces"	11 "11 - Legislators and senior officials"	12 "12 - Corporate managers"	13 "13 - General managers" ///
										21 "21 - Physical, mathematical and engineering science professionals"	22 "22 - Life science and health professionals"	///
										23 "23 - Teaching professionals"	24 "24 - Other professionals" ///
										31 "31 - Physical and engineering science associate professionals"	32 "32 - Life science and health associate professionals"	///
										33 "33 - Teaching associate professionals"	34 "34 - Other associate professionals"	41 "41 - Office clerks"	///
										42 "42 - Customer services clerks" 51 "51 - Personal and protective services workers"	52 "52 - Models, salespersons and demonstrators" ///
										61 "61 - Skilled agricultural and fishery workers"	62 "62 - Subsistence agricultural and fishery workers"				///
										71 "71 - Extraction and building trades workers"	72 "72 - Metal, machinery and related trades workers"	///
										73 "73 - Precision, handicraft, craft printing and related trades workers"	74 "74 - Other craft and related trades workers"	///			
										81 "81 - Stationary plant and related operators"	82 "82 - Machine operators and assemblers"	83 "83 - Drivers and mobile plant operators" ///					
										91 "91 - Sales and services elementary occupations"	92 "92 - Agricultural, fishery and related labourers"	93 "93 - Labourers in mining, construction, manufacturing and transport"					

			
			lab val ilo_job1_ocu_isco88_2digits ocu_isco88_2digits
			lab var ilo_job1_ocu_isco88_2digits "Occupation (ISCO-88), 2 digit level - main job"
			
			
			
			

			
			
		* Secondary occupation
			* Comment: no possible to compute
		 
			
		* 1 digit level
	
 	
		* Primary activity
		
		gen occ_code_prim_1dig=int(pw22/10) if ilo_lfs==1 & !inlist(pw22,1,8,20,53,99)
			 
		
		gen ilo_job1_ocu_isco88=occ_code_prim_1dig
			replace ilo_job1_ocu_isco88=10 if ilo_job1_ocu_isco88==0
			replace ilo_job1_ocu_isco88=11 if ilo_job1_ocu_isco88==. & ilo_lfs==1
			replace ilo_job1_ocu_isco88=. if ilo_lfs!=1
				lab def ocu88_1digits 1 "1 - Legislators, senior officials and managers"	2 "2 - Professionals"	3 "3 - Technicians and associate professionals" ///
										4 "4 - Clerks"	5 "5 - Service workers and shop and market sales workers"	6 "6 - Skilled agricultural and fishery workers"	///
										7 "7 - Craft and related trades workers"	8 "8 - Plant and machine operators and assemblers"	9 "9 - Elementary occupations"	///
										10 "0 - Armed forces"	11 "11 - Not elsewhere classified"

				lab val ilo_job1_ocu_isco88 ocu88_1digits
				lab var ilo_job1_ocu_isco88 "Occupation (ISCO-88) - main job"	
			
			
			
		* Secondary activity
		
			** no information available
			
			
		* Aggregate level
	
		* Primary occupation
	
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
			    lab var ilo_job1_ocu_aggregate "Occupation (Aggregate) - main job"	
				
		* Secondary occupation
		
			** no information available
			
			

				
		* Skill level
	
		* Primary occupation
	
		gen ilo_job1_ocu_skill=.
			replace ilo_job1_ocu_skill=1 if ilo_job1_ocu_isco88==9                   // Low
			replace ilo_job1_ocu_skill=2 if inlist(ilo_job1_ocu_isco88,4,5,6,7,8)    // Medium
			replace ilo_job1_ocu_skill=3 if inlist(ilo_job1_ocu_isco88,1,2,3)        // High
			replace ilo_job1_ocu_skill=4 if inlist(ilo_job1_ocu_isco88,10,11)        // Not elsewhere classified
				lab def ocu_skill_lab 1 "1 - Skill level 1 (low)" 2 "2 - Skill level 2 (medium)" 3 "3 - Skill levels 3 and 4 (high)" 4 "4 - Not elsewhere classified"
			    lab val ilo_job1_ocu_skill ocu_skill_lab
			    lab var ilo_job1_ocu_skill "Occupation (Skill level) - main job"
				
		* Secondary occupation 
			** no information available
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_ins_sector')  
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

  ** Comment: no information available
 
 
 * --------------------------------------------------------------------------------------------------
* --------------------------------------------------------------------------------------------------
*		Weekly hours actually (USUALLY) worked ('ilo_how_actual') and ('ilo_how_usual')   
* --------------------------------------------------------------------------------------------------
* --------------------------------------------------------------------------------------------------


* Comment: 
	
	* Actual hours worked - the only information that appears in de microdataset is related to hours worked in all jobs during the last week. 
	* there are missing values. 
			
		* All jobs 
		
		gen ilo_joball_how_actual=pw06 if ilo_lfs==1
 			replace ilo_joball_how_actual=. if ilo_lfs!=1
			lab var ilo_joball_how_actual "Weekly hours actually worked in all jobs"		
	

	* Weekly hours actually worked --> bands --> Use actual hours worked in all jobs 
 
		
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
				lab def how_bands_lab 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"
				lab values ilo_joball_how_actual_bands how_bands_lab
				lab var ilo_joball_how_actual_bands "Weekly hours actually worked bands in all jobs"
				

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job_time') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	


  ** Comment: no information available


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job_contract')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	


 ** Comment: no information available

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Informal/Formal economy: Unit of production ('ilo_job1_ife_prod')  
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------


  ** Comment: no information available
  
  
  * Comment: Useful questions:	* Status in employment: pw23
								* Institutional sector: pw23 
								* Destination of production: [no info in the microdata set]
								* Bookkeeping: [no info in the microdata set]
								* Registration: [no info in the microdata set]				
								* [no info]: Location of workplace 
								* Size of the establishment: [no info in the microdata set]					
								* Social security 
									* Pension fund: [no info in the microdata set]
									* Paid annual leave: [no info in the microdata set]
									* Paid sick leave:[no info in the microdata set]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Earnings ('ilo_job1_lri_ees' and 'ilo_ear_slf')  
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: no information available in the microdata set
	* Currency in Palestine: Variables PW26 are not included in the Microdata received


***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_tru') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
           
** Comment: there is not enough information available to compute this variable. 

*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Cases of non-fatal occupational injury ('ilo_joball_oi_case') [no info]
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------

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
*			Duration of unemployment ('ilo_dur')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

  
	 gen ilo_dur_details=.
		replace ilo_dur_details=1 if pw13==0
		replace ilo_dur_details=2 if inrange(pw13,1,2)
		replace ilo_dur_details=3 if inrange(pw13,3,5)
		replace ilo_dur_details=4 if inrange(pw13,6,11)
		replace ilo_dur_details=5 if inrange(pw13,12,23)
		replace ilo_dur_details=6 if pw13>=24 & pw13!=.
		replace ilo_dur_details=7 if ilo_dur_details==. & ilo_lfs==2
		replace ilo_dur_details=. if ilo_lfs!=2
			lab def ilo_unemp_det 1 "Less than 1 month" 2 "1 month to less than 3 months" 3 "3 months to less than 6 months" 4 "6 months to less than 12 months" 5 "12 months to less than 24 months" ///
									6 "24 months or more" 7 "Not elsewhere classified"
			lab values ilo_dur_details ilo_unemp_det
			lab var ilo_dur_details "Duration of unemployment (Details)"		
			
	gen ilo_dur_aggregate=.
		replace ilo_dur_aggregate=1 if inlist(ilo_dur_details,1,2,3)
		replace ilo_dur_aggregate=2 if ilo_dur_details==4
		replace ilo_dur_aggregate=3 if inlist(ilo_dur_details,5,6)
		replace ilo_dur_aggregate=4 if ilo_dur_details==7
		replace ilo_dur_aggregate=. if ilo_lfs!=2
			lab def ilo_unemp_aggr 1 "Less than 6 months" 2 "6 months to less than 12 months" 3 "12 months or more" 4 "Not elsewhere classified"
			lab val ilo_dur_aggregate ilo_unemp_aggr
			lab var ilo_dur_aggregate "Duration of unemployment (Aggregate)"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Category of unemployment ('ilo_cat_une')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: 

	gen ilo_cat_une=.
		replace ilo_cat_une=1 if inrange(pw17,1,3) // 1 - Unemployed previously employed
		replace ilo_cat_une=2 if pw17==4 // 2 - Unemployed seeking their first job
		replace ilo_cat_une=3 if ilo_lfs==2 & ilo_cat_une==. // 3 - Unknown
		replace ilo_cat_une=. if ilo_lfs!=2
			lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
			lab val ilo_cat_une cat_une_lab
			lab var ilo_cat_une "Category of unemployment"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic3')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

** Comment: ISIC Rev. 3.1 used

* 2-digits level

	gen ilo_preveco_isic3_2digits=pw20 if (ilo_lfs==2 & ilo_cat_une==1 & !inlist(pw20,0,4,6,86))
		
		lab val ilo_preveco_isic3_2digits eco_isic3_2digits
        lab var ilo_preveco_isic3_2digits "Previous economic activity (ISIC Rev. 3.1), 2 digits levels"
		
	* Keep this variable at 2 digits-level, in order to be able to correctly execute the code below
		
	* Previous economic activity
	

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
	    replace ilo_preveco_isic3=18 if ilo_preveco_isic3==. & ilo_lfs==2 & ilo_cat_une==1
		       
			   lab val ilo_preveco_isic3 eco_isic3
			    lab var ilo_preveco_isic3 "Previous economic activity (ISIC Rev. 3.1)"
	
	
		
	* Aggregate level
		
	
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
				
	
	
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu_isco08')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
		
* Comment: ISCO-88 classification being used
 
 
 * Two-digits level

	

		gen ilo_prevocu_isco88_2digits=pw22 if ilo_lfs==2 & ilo_cat_une==1 & !inlist(pw22,1,8,20,53,99)
		

			lab val ilo_prevocu_isco88_2digits ocu_isco88_2digits
			lab var ilo_prevocu_isco88_2digits "Previous occupation (ISCO-88), 2 digit level"
 
 
 
	* Reduce it to 1-digit level 
	
	gen prevocu_cod=int(pw22/10) if ilo_lfs==2 & ilo_cat_une==1 & !inlist(pw22,1,8,20,53,99)
	
	gen ilo_prevocu_isco88=prevocu_cod
		replace ilo_prevocu_isco88=10 if ilo_prevocu_isco88==0
		replace ilo_prevocu_isco88=11 if ilo_prevocu_isco88==. & ilo_cat_une==1 & ilo_lfs==2
		
 			lab val ilo_prevocu_isco88 ocu88_1digits
			lab var ilo_prevocu_isco88 "Previous occupation (ISCO-88)"	
				
			
			
			
			
	* Aggregate level 
	
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
				
		
		
				

 
 


***********************************************************************************************
*			PART 3.4. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

 ** Comment: 
	** - pw14: seek for a job last week -- in the microdata set only available information on last week (according to the questionnaire also to the last four weeks). 
	** - pw11: availability
	** - no information available about willigness
	
	
	 gen ilo_olf_dlma=.
		replace ilo_olf_dlma=1 if pw14==1 & pw11==1 & ilo_lfs==3 // 1 - Seeking, not available (Unavailable jobseekers)
		replace ilo_olf_dlma=2 if pw14==2 & pw11==1  & ilo_lfs==3 // 2 - Not seeking, available (Available potential jobseekers)
		*replace ilo_olf_dlma=3 if // 3 - Not seeking, not available, willing (Willing non-jobseekers)
		*replace ilo_olf_dlma=4 if  // 4 - Not seeking, not available, not willing
		replace ilo_olf_dlma=5 if ilo_olf_dlma==. & ilo_lfs==3                            // 5 - Not elsewhere classified
				replace ilo_olf_dlma=. if ilo_lfs!=3
			
			lab def lab_olf_dlma 1 "1 - Seeking, not available (Unavailable jobseekers)" 2 "2 - Not seeking, available (Available potential jobseekers)" ///
						3 "3 - Not seeking, not available, willing (Willing non-jobseekers)" 4 "4 - Not seeking, not available, not willing" 5 "5 - Not elsewhere classified"
			lab val ilo_olf_dlma lab_olf_dlma
			lab var ilo_olf_dlma "Labour market attachment (Degree of)" 

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reasons for not seeking a job ('ilo_olf_reason')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: Labour market reasons are limited due to the extended definition of unemployment.
* Comment: the results given by this variable are subject to the extended definition of unemployment. 

if (`Y' == 2007 | `Y' == 2005 | `Y' == 1999) {

	gen ilo_olf_reason=.
		replace ilo_olf_reason=1 if pw16==4 | inrange(pw16,8,10)  
		replace ilo_olf_reason=2 if inrange(pw16,5,7)  
		replace ilo_olf_reason=3 if inrange(pw16,1,3)   
		replace ilo_olf_reason=4 if pw16==11  
		replace ilo_olf_reason=5 if ilo_olf_reason==. & ilo_lfs==3
		replace ilo_olf_reason=. if ilo_lfs!=3
			
}

if `Y' == 2006 | ( `Y' < 2005 & `Y' > 1999) {

	gen ilo_olf_reason=.
		replace ilo_olf_reason=1 if pw16==4 | pw16==6 | inrange(pw16,10,12)  
		replace ilo_olf_reason=2 if pw16==5 | inlist(pw16,7,8)  
		replace ilo_olf_reason=3 if inrange(pw16,1,3)   
		*replace ilo_olf_reason=4 if  
		replace ilo_olf_reason=5 if ilo_olf_reason==. & ilo_lfs==3
		replace ilo_olf_reason=. if ilo_lfs!=3
			
}

if `Y' < 1999  {

	gen ilo_olf_reason=.
		replace ilo_olf_reason=1 if pw16==4  
		replace ilo_olf_reason=2 if inrange(pw16,5,7)  
		replace ilo_olf_reason=3 if inrange(pw16,1,3)   
		*replace ilo_olf_reason=4 if  
		replace ilo_olf_reason=5 if ilo_olf_reason==. & ilo_lfs==3
		replace ilo_olf_reason=. if ilo_lfs!=3
		
}


			lab def lab_olf_reason 1 "1 - Labour market (Discouraged)" 2 "2 - Other labour market reasons" 3 "3 - Personal/Family-related"  4 "4 - Does not need/want to work" 5 "5 - Not elsewhere classified"
			lab val ilo_olf_reason lab_olf_reason
			lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seekers ('ilo_dis')
* -------------------------------------------------------------------------------------------
* ------------------------------------------------------------------------------------------- 

* Comment: this variable can not be computed due to the procedure to obtain ilo_lfs that follows the national definitions, and discouraged  job-seekers are considered as unemployed. 


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training (NEETs) ('ilo_neet')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_neet=.
		replace ilo_neet=1 if inrange(ilo_age,15,24) & ilo_lfs!=1 & reason!=3
			lab def ilo_neet_lab 1 "Youth not in education, employment or training"
			lab val ilo_neet ilo_neet_lab
			lab var ilo_neet "Youth not in education, employment or training"  			

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

*			SAVE RESULTS

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* -------------------------------------------------------------
* Prepare final datasets
* -------------------------------------------------------------

cd "$outpath"

 
		drop ilo_age /* As only age bands being kept and this variable used as help variable */
		
 	
		compress 
		
		 
		   		   
	* Save dataset including original and ilo variables
	
		save ${country}_${source}_${time}_FULL, replace		
	
	*Save file only containing ilo_* variables
	
		keep ilo*
		
		drop if ilo_key==.

		save ${country}_${source}_${time}_ILO, replace

		
