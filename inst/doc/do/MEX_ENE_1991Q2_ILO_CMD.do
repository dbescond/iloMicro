* TITLE OF DO FILE: ILO Microdata Preprocessing code template - MEX, 2004Q4
* DATASET USED: MEX, ENE, 2004Q4
* Files created: Standard variables MEX_ENE_2004Q4_FULL.dta and MEX_ENE_2004Q4_ILO.dta
* Authors: ILO / Department of Statistics / DPAU
* Starting Date: 28 August 2018
* Last updated: 28 August 2018
********************************************************************************

********************************************************************************
********************************************************************************
*                                                                              *
*          1.	Set up work directory, file name, variables and function       *
*                                                                              *
********************************************************************************
********************************************************************************

clear all 

set more off

global path "J:\DPAU\MICRO"
global country "MEX"  
global source "ENE"   
global time "1991Q2"   
global inputFile "MAY_91U.dta"
global inpath "${path}\\${country}\\${source}\\${time}\ORI"
global temppath "${path}\_Admin"
global outpath "${path}\\${country}\\${source}\\${time}"

********************************************************************************
********************************************************************************

cd "$inpath"
	use ${inputFile}, clear
	rename *, lower  
	
********************************************************************************
********************************************************************************
*                                                                              *
*			                      2. MAP VARIABLES                             *
*                                                                              *
********************************************************************************
********************************************************************************

* ------------------------------------------------------------------------------
********************************************************************************
*                                                                              *
*			              PART 1. DATASET SETTINGS VARIABLES                   *
*                                                                              *
********************************************************************************
* ------------------------------------------------------------------------------

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			               Identifier ('ilo_key')		                       *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment:

	gen ilo_key=_n
		lab var ilo_key "Key unique identifier per individual"
	
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*		             	 Sample Weight ('ilo_wgt') 		                       *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 
destring fac, replace

	gen ilo_wgt=.
	    replace ilo_wgt=fac 
		lab var ilo_wgt "Sample weight"
	
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			                Time period ('ilo_time')		                   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment:

	gen ilo_time=1
		lab def time_lab 1 "$time"
		lab val ilo_time time_lab
		lab var ilo_time "Time (Gregorian Calendar)"
		
* ------------------------------------------------------------------------------
********************************************************************************
*                                                                              *
*			                PART 2. SOCIAL CHARACTERISTICS                     *
*                                                                              * 
********************************************************************************
* ------------------------------------------------------------------------------

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*		            	Geographical coverage ('ilo_geo') 		               *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: no info	
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			                     Sex ('ilo_sex') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 
destring sex, replace
	
	gen ilo_sex=.
	    replace ilo_sex=1 if sex==1            // Male
		replace ilo_sex=2 if sex==2            // Female
		        label define label_Sex 1 "1 - Male" 2 "2 - Female"
		        label values ilo_sex label_Sex
		        lab var ilo_sex "Sex"

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			                    Age ('ilo_age') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 
destring eda, replace
	
	gen ilo_age=.
	    replace ilo_age=eda 
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
		replace ilo_age_aggregate=1 if inrange(ilo_age,0,14)
		replace ilo_age_aggregate=2 if inrange(ilo_age,15,24)
		replace ilo_age_aggregate=3 if inrange(ilo_age,25,54)
		replace ilo_age_aggregate=4 if inrange(ilo_age,55,64)
		replace ilo_age_aggregate=5 if ilo_age>=65 & ilo_age!=.
			lab def age_aggr_lab 1 "<15" 2 "15-24" 3 "25-54" 4 "55-64" 5 "65+"
			lab val ilo_age_aggregate age_aggr_lab
			lab var ilo_age_aggregate "Age (Aggregate)"
			
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			           Level of education ('ilo_edu') 		                   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: explanation of the variable "esc" in the document Inst_cod_esc_ene.pdf

    *---------------------------------------------------------------------------
	* ISCED 97
	*---------------------------------------------------------------------------
	/*
gen byte edu_num = real(substr(esc,1,1))
gen str1 term =.
		replace term= substr(esc,1,1) if  inlist(substr(esc,1,1),"T","N")
		replace term= substr(esc,2,1) if  !inlist(substr(esc,1,1),"T","N")


gen educ =.
	    replace educ = 0 if ((edu_num==1 & term<="5") | (edu_num==1 & term=="9") | (edu_num==1 & term=="N")) 
		replace educ = 1 if ((edu_num==1 & term>="6") | (edu_num==2 & term<="2") | (edu_num==2 & term=="9") | (edu_num==1 & term=="T") | (edu_num==2 & term=="N")) 
		replace educ = 2 if ((edu_num==2 & term>="3") | (edu_num==3 & term>="1") | (edu_num==3 & term=="9") | (edu_num==4 & term=="9")  | (edu_num==2 & term=="T"))
		replace educ = 3 if ((edu_num==3 & term>="2") | (edu_num==3 & term=="N") | (edu_num==4 & term=="N") | (edu_num==4 & term<="3"))
		replace educ = 4 if (edu_num==3 & term=="T") 
		replace educ = 5 if ((edu_num==4 & term=="T") | (edu_num==5 & inlist(term,"N","9")) | (edu_num==6 & inlist(term,"N","9")) |(edu_num==4 & term>="4") | (edu_num==5 & term<="1") | (edu_num==6 & term<="2"))
		replace educ = 6 if ((edu_num==5 & term=="T") | (edu_num==6 & term=="T") | (edu_num==5 & term>="2") | (edu_num==6 & term>="3"))
		

		
		/*
	gen educ =.
	    replace educ = 0 if ((educacion <= "15") | (educacion == "19") | (educacion == "1N") ) 
		replace educ = 1 if ((educacion >= "16") | (educacion <= "22") | (educacion == "29") | (educacion == "1T") | (educacion == "2N")) 
		replace educ = 2 if ((educacion >= "23") | (educacion <= "31") | (inlist(educacion,"39","49")) | (educacion == "2T"))
		replace educ = 3 if ((educacion >= "32") | (educacion == "3N") | (educacion == "4N") | (educacion <= "43"))
		replace educ = 4 if (educacion == "3T") 
		replace educ = 5 if ((inlist(educacion,"4T","5N","6N","59","69")) | (educacion >= "44") | (educacion <= "51") |(educacion <= "62") )
		replace educ = 6 if (inlist(educacion,"5T","6T") | (educacion >= "52") | (educacion >= "63")) 
 		*/
		
	* Detailed
	gen ilo_edu_isced97=.
		replace ilo_edu_isced97=1 if inlist(esc,"97000","98000")                // No schooling
		replace ilo_edu_isced97=2 if (educ==0 | esc=="96000")                    // Pre-primary education
		replace ilo_edu_isced97=3 if educ==1                                     // Primary education or first stage of basic education
		replace ilo_edu_isced97=4 if educ==2                                     // Lower secondary education or second stage of basic education
		replace ilo_edu_isced97=5 if educ==3                                     // Upper secondary education
		replace ilo_edu_isced97=6 if educ==4                                     // Post-secondary non-tertiary education
		replace ilo_edu_isced97=7 if educ==5                                     // First stage of tertiary education (not leading directly to an advanced research qualification)
		replace ilo_edu_isced97=8 if educ==6                                     // Second stage of tertiary education (leading to an advanced research qualification)                               
		replace ilo_edu_isced97=9 if ilo_edu_isced97==.                         // Level not stated 
			    label def isced_97_lab 1 "X - No schooling" 2 "0 - Pre-primary education" 3 "1 - Primary education or first stage of basic education" 4 "2 - Lower secondary education or second stage of basic education" ///
							           5 "3 - Upper secondary education" 6 "4 - Post-secondary non-tertiary education" 7 "5 - First stage of tertiary education (not leading directly to an advanced research qualification)" ///
							           8 "6 - Second stage of tertiary education (leading to an advanced research qualification)" 9 "UNK - Level not stated"
			    label val ilo_edu_isced97 isced_97_lab
		        lab var ilo_edu_isced97 "Level of education (ISCED 97)"

	* Aggregate
	gen ilo_edu_aggregate=.
		replace ilo_edu_aggregate=1 if inlist(ilo_edu_isced97,1,2)
		replace ilo_edu_aggregate=2 if inlist(ilo_edu_isced97,3,4)
		replace ilo_edu_aggregate=3 if inlist(ilo_edu_isced97,5,6)
		replace ilo_edu_aggregate=4 if inlist(ilo_edu_isced97,7,8)
		replace ilo_edu_aggregate=5 if ilo_edu_isced97==9
			    label def edu_aggr_lab 1 "1 - Less than basic" 2 "2 - Basic" 3 "3 - Intermediate" 4 "4 - Advanced" 5 "5 - Level not stated"
			    label val ilo_edu_aggregate edu_aggr_lab
			    label var ilo_edu_aggregate "Level of education (Aggregate levels)"
	*/
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*		  	 Educational attendance ('ilo_edu_attendance') 		               *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: no info
/*			
    gen ilo_edu_attendance=.
		replace ilo_edu_attendance=1 if                        // Attending
		replace ilo_edu_attendance=2 if                        // Not attending
		replace ilo_edu_attendance=3 if ilo_edu_attendance==.  // Not elsewhere classified
			    lab def edu_attendance_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
			    lab val ilo_edu_attendance edu_attendance_lab
			    lab var ilo_edu_attendance "Education (Attendance)"
*/
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			           Marital status ('ilo_mrts') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 
destring e_civ, replace
	
	* Detailed
	gen ilo_mrts_details=.
	    replace ilo_mrts_details=1 if e_civ==1                                           // Single
		replace ilo_mrts_details=2 if e_civ==2                                          // Married
		replace ilo_mrts_details=3 if e_civ==3                                          // Union / cohabiting
		replace ilo_mrts_details=4 if e_civ==6                                          // Widowed
		replace ilo_mrts_details=5 if inlist(e_civ,4,5)                                          // Divorced / separated
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
						
				
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			Disability status ('ilo_dsb_details')                              *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: no info

 
				
* ------------------------------------------------------------------------------
********************************************************************************
*                                                                              *
*			                PART 3. ECONOMIC SITUATION                         *
*                                                                              * 
********************************************************************************
* ------------------------------------------------------------------------------
	
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			      Working age population ('ilo_wap')	                       *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: in Mexico, the WAP is the population aged 14 yrs and above [from 14 to 98 years old]

	gen ilo_wap=.
		replace ilo_wap=1 if ilo_age>=15 & ilo_age!=.
			    label define label_ilo_wap 1 "1 - Working-age Population"
				label value ilo_wap label_ilo_wap
				label var ilo_wap "Working-age population"

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			       Labour Force Status ('ilo_lfs')                             *       
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: UNEMPLOYMENT DEFINITION BASED ON TWO CRITERIA (there is no information on availability)
* Comment: temporary absent >> period of time of reference: up to 1 month

 
destring p1a1 p1a2 p1a3 p1a4 p1c p1b p1d p1e, replace


	gen ilo_lfs=.
        replace ilo_lfs=1 if (p1a1==1 | p1a2==1 | inlist(p1a4,11,12)) & ilo_wap==1   // Employed: ILO definition
		replace ilo_lfs=1 if (inrange(p1b,1,3) | (inrange(p1b,4,10) & p1c==1)) & ilo_wap==1						// Employed: temporary absent
		replace ilo_lfs=2 if (p1e==1) & ilo_lfs!=1 & ilo_wap==1			            // Unemployed: TWO CRITERIA (no information on availability)
		replace ilo_lfs=2 if (p1a3==1 & inlist(p1d,1,2)) & ilo_lfs!=1 & ilo_wap==1  // Unemployed: available future starters
	    replace ilo_lfs=3 if !inlist(ilo_lfs,1,2) & ilo_wap==1		                // Outside the labour force
				label define label_ilo_lfs 1 "1 - Employed" 2 "2 - Unemployed" 3 "3 - Outside Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status" 
			
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			       Multiple job holders ('ilo_mjh')                            *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 
destring p3, replace

    gen ilo_mjh=.
		replace ilo_mjh=1 if (p3==1) & ilo_lfs==1                               // One job only     
		replace ilo_mjh=2 if inlist(p3,2,3) & ilo_lfs==1                        // More than one job
		replace ilo_mjh=. if ilo_lfs!=1
			    lab def lab_ilo_mjh 1 "1 - One job only" 2 "2 - More than one job"
			    lab val ilo_mjh lab_ilo_mjh
			    lab var ilo_mjh "Multiple job holders"
			

* ------------------------------------------------------------------------------
********************************************************************************
*                                                                              *
*	          PART 3.1 ECONOMIC CHARACTERISTICS FOR MAIN JOB                   *
*                                                                              * 
********************************************************************************
* ------------------------------------------------------------------------------			

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			       Status in employment ('ilo_ste')                            * 
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment:
destring p3a, replace
destring p8b, replace


   * MAIN JOB
   * ICSE 1993
	 gen ilo_job1_ste_icse93=.
		 replace ilo_job1_ste_icse93=1 if inlist(p3a,3,4) & ilo_lfs==1          // Employees
		 replace ilo_job1_ste_icse93=2 if p3a==1 & ilo_lfs==1                   // Employers
		 replace ilo_job1_ste_icse93=3 if p3a==2 & ilo_lfs==1                   // Own-account workers
		 replace ilo_job1_ste_icse93=4 if p3a==5 & ilo_lfs==1                   // Members of producers' cooperatives
		 replace ilo_job1_ste_icse93=5 if inlist(p3a,6,7) & ilo_lfs==1          // Contributing family workers
		 replace ilo_job1_ste_icse93=6 if ilo_job1_ste_icse93==. & ilo_lfs==1   // Workers not classifiable by status
		 replace ilo_job1_ste_icse93=. if ilo_lfs!=1
				 label def label_ilo_ste_icse93 1 "1 - Employees" 2 "2 - Employers" 3 "3 - Own-account workers" ///
				                                4 "4 - Members of producers' cooperatives" 5 "5 - Contributing family workers" ///
												6 "6 - Workers not classifiable by status"
				 label val ilo_job1_ste_icse93 label_ilo_ste_icse93
				 label var ilo_job1_ste_icse93 "Status in employment (ICSE 93) - main job"

	* Aggregate categories 
	  gen ilo_job1_ste_aggregate=.
		  replace ilo_job1_ste_aggregate=1 if ilo_job1_ste_icse93==1                 // Employees
		  replace ilo_job1_ste_aggregate=2 if inlist(ilo_job1_ste_icse93,2,3,4,5)    // Self-employed
		  replace ilo_job1_ste_aggregate=3 if inlist(ilo_job1_ste_icse93,6)          // Not elsewhere classified
				  lab def ste_aggr_lab 1 "1 - Employees" 2 "2 - Self-employed" 3 "3 - Not elsewhere classified"
				  lab val ilo_job1_ste_aggregate ste_aggr_lab
				  label var ilo_job1_ste_aggregate "Status in employment (Aggregate) - main job"
				  
				
		* SECOND JOB
	* ICSE 1993
	  gen ilo_job2_ste_icse93=.
		  replace ilo_job2_ste_icse93=1 if inlist(p8b,3,4) & ilo_mjh==2         // Employees
		  replace ilo_job2_ste_icse93=2 if p8b==1 & ilo_mjh==2                  // Employers
		  replace ilo_job2_ste_icse93=3 if p8b==2 & ilo_mjh==2                  // Own-account workers
		  replace ilo_job2_ste_icse93=4 if p8b==5 & ilo_mjh==2                  // Members of producers' cooperatives 
		  replace ilo_job2_ste_icse93=5 if inlist(p8b,6,7) & ilo_mjh==2         // Contributing family workers
		  replace ilo_job2_ste_icse93=6 if ilo_job2_ste_icse93==. & ilo_mjh==2  // Workers not classifiable by status
		  replace ilo_job2_ste_icse93=. if ilo_mjh!=2
 			      label value ilo_job2_ste_icse93 label_ilo_ste_icse93
			      label var ilo_job2_ste_icse93 "Status in employment (ICSE 93) - second job"

	* Aggregate categories
	  gen ilo_job2_ste_aggregate=.
		  replace ilo_job2_ste_aggregate=1 if ilo_job2_ste_icse93==1                 // Employees
		  replace ilo_job2_ste_aggregate=2 if inlist(ilo_job2_ste_icse93,2,3,4,5)    // Self-employed
		  replace ilo_job2_ste_aggregate=3 if inlist(ilo_job2_ste_icse93,6)          // Not elsewhere classified
				  lab val ilo_job2_ste_aggregate ste_aggr_lab
				  label var ilo_job2_ste_aggregate "Status in employment (Aggregate) - second job"

 

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			            Economic activity ('ilo_eco')                          *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: correspondence has been made between the national classification CAE-ENE-94 and ISIC Rev. 3.1.
*          it has been made using as reference the document Cae_ene.pdf and the categories of ISIC Rev. 3.1.

    * MAIN JOB
	
    *---------------------------------------------------------------------------
	* ISIC REV 3.1
	*---------------------------------------------------------------------------
destring p5b, replace

gen indu_code_prim=.
	replace indu_code_prim=int(p5b/100) if   !inrange(p5b,7211,7261) & ilo_lfs==1
 


	* 1-digit level	
    gen ilo_job1_eco_isic3=.
		replace ilo_job1_eco_isic3=1 if inrange(indu_code_prim,1,3)  & ilo_lfs==1
		replace ilo_job1_eco_isic3=2 if indu_code_prim==4  & ilo_lfs==1
		replace ilo_job1_eco_isic3=3 if inrange(indu_code_prim,5,10)  & ilo_lfs==1
		replace ilo_job1_eco_isic3=4 if (inrange(indu_code_prim,11,59) | p5b==7211)  & ilo_lfs==1
		replace ilo_job1_eco_isic3=5 if indu_code_prim==61  & ilo_lfs==1
		replace ilo_job1_eco_isic3=6 if indu_code_prim==60  & ilo_lfs==1
		replace ilo_job1_eco_isic3=7 if indu_code_prim==62  & ilo_lfs==1
		replace ilo_job1_eco_isic3=8 if indu_code_prim==63  & ilo_lfs==1
		replace ilo_job1_eco_isic3=9 if inrange(indu_code_prim,64,65)  & ilo_lfs==1
		replace ilo_job1_eco_isic3=10 if inrange(indu_code_prim,66,67)  & ilo_lfs==1
		replace ilo_job1_eco_isic3=11 if inlist(indu_code_prim,68,72)  & ilo_lfs==1
		replace ilo_job1_eco_isic3=12 if indu_code_prim==73  & ilo_lfs==1
		replace ilo_job1_eco_isic3=13 if indu_code_prim==69  & ilo_lfs==1
		replace ilo_job1_eco_isic3=14 if indu_code_prim==70  & ilo_lfs==1
		replace ilo_job1_eco_isic3=15 if (indu_code_prim==71 | inlist(p5b,7231,7251)) & ilo_lfs==1
		replace ilo_job1_eco_isic3=16 if p5b==7261  & ilo_lfs==1
		replace ilo_job1_eco_isic3=17 if indu_code_prim==88  & ilo_lfs==1
		replace ilo_job1_eco_isic3=18 if ilo_job1_eco_isic3==. & ilo_lfs==1
		        lab def eco_isic3_1digit 1 "A - Agriculture, hunting and forestry"	2 "B - Fishing"	3 "C - Mining and quarrying"	4 "D - Manufacturing"	///
                                         5 "E - Electricity, gas and water supply"	6 "F - Construction"	7 "G - Wholesale and retail trade; repair of motor vehicles, motorcycles and personal and household goods"	8 "H - Hotels and restaurants"	///
                                         9 "I - Transport, storage and communications"	10 "J - Financial intermediation"	11 "K - Real estate, renting and business activities"	12 "L - Public administration and defence; compulsory social security"	///
                                         13 "M - Education"	14 "N - Health and social work"	15 "O - Other community, social and personal service activities"	16 "P - Activities of private households as employers and undifferentiated production activities of private households"	///
                                         17 "Q - Extraterritorial organizations and bodies"	18 "X - Not elsewhere classified"			
			    lab val ilo_job1_eco_isic3 eco_isic3_1digit
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
	


    * SECOND JOB
	
    *---------------------------------------------------------------------------
	* ISIC REV 3.1
	*---------------------------------------------------------------------------
destring p8d, replace

gen indu_code_sec=.
	replace indu_code_sec=int(p8d/100) if  !inrange(p8d,7211,7261) & ilo_mjh==2	
	
 

	* 1-digit level	
      gen ilo_job2_eco_isic3=.
		replace ilo_job2_eco_isic3=1 if inrange(indu_code_sec,1,3)  & ilo_mjh==2
		replace ilo_job2_eco_isic3=2 if indu_code_sec==4  & ilo_mjh==2
		replace ilo_job2_eco_isic3=3 if inrange(indu_code_sec,5,10)  & ilo_mjh==2
		replace ilo_job2_eco_isic3=4 if (inrange(indu_code_sec,11,59) | p8d==7211)  & ilo_mjh==2
		replace ilo_job2_eco_isic3=5 if indu_code_sec==61  & ilo_mjh==2
		replace ilo_job2_eco_isic3=6 if indu_code_sec==60  & ilo_mjh==2
		replace ilo_job2_eco_isic3=7 if indu_code_sec==62  & ilo_mjh==2
		replace ilo_job2_eco_isic3=8 if indu_code_sec==63  & ilo_mjh==2
		replace ilo_job2_eco_isic3=9 if inrange(indu_code_sec,64,65)  & ilo_mjh==2
		replace ilo_job2_eco_isic3=10 if inrange(indu_code_sec,66,67)  & ilo_mjh==2
		replace ilo_job2_eco_isic3=11 if inlist(indu_code_sec,68,72)  & ilo_mjh==2
		replace ilo_job2_eco_isic3=12 if indu_code_sec==73  & ilo_mjh==2
		replace ilo_job2_eco_isic3=13 if indu_code_sec==69  & ilo_mjh==2
		replace ilo_job2_eco_isic3=14 if indu_code_sec==70  & ilo_mjh==2
		replace ilo_job2_eco_isic3=15 if (indu_code_sec==71 | inlist(p8d,7231,7251)) & ilo_mjh==2
		replace ilo_job2_eco_isic3=16 if p8d==7261  & ilo_mjh==2
		replace ilo_job2_eco_isic3=17 if indu_code_sec==88  & ilo_mjh==2
		replace ilo_job2_eco_isic3=18 if ilo_job2_eco_isic3==.  & ilo_mjh==2
                * labels already defined for main job
		        lab val ilo_job2_eco_isic3 eco_isic3_1digit
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
                * labels already defined for main job
			    lab val ilo_job2_eco_aggregate eco_aggr_lab
			    lab var ilo_job2_eco_aggregate "Economic activity (Aggregate) - second job"
   	   
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			               Occupation ('ilo_ocu') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: the mapping has been made between CMO-94 and ISCO-88 
 
destring p4, replace

gen ocup_code_prim=.
	replace ocup_code_prim=1 if inrange(int(p4/10),210,219) & ilo_lfs==1
    replace ocup_code_prim=2 if (inrange(int(p4/10),110,119)|inrange(int(p4/10),130,132) | inrange(int(p4/10),136,143)) & ilo_lfs==1
	replace ocup_code_prim=3 if (inrange(int(p4/10),120,129)| inrange(int(p4/10),133,135) | inrange(int(p4/10),144,149) | ///
	inlist(int(p4/10),417,713)|inrange(int(p4/10),510,519) | inrange(int(p4/10),553,554)| inrange(int(p4/10),610,619)) & ilo_lfs==1
    replace ocup_code_prim=4 if inrange(int(p4/10),620,625) & ilo_lfs==1
	replace ocup_code_prim=5 if (inrange(int(p4/10),626,712)|inrange(int(p4/10),813,814)|inrange(int(p4/10),816,819)|inlist(int(p4/10),719,810,830,839)) & ilo_lfs==1
    replace ocup_code_prim=6 if (inrange(int(p4/10),410,416)|int(p4/10)==419) & ilo_lfs==1
    replace ocup_code_prim=7 if inrange(int(p4/10),520,529) & ilo_lfs==1
	replace ocup_code_prim=8 if (inrange(int(p4/10),530,539) | inrange(int(p4/10),550,552) | inrange(int(p4/10),555,559)) & ilo_lfs==1
	replace ocup_code_prim=9 if (inrange(int(p4/10),540,549) | inrange(int(p4/10),720,729) | inrange(int(p4/10),811,812) | ///
	inlist(int(p4/10),815,820)) & ilo_lfs==1
    replace ocup_code_prim=10 if int(p4/10)==831 & ilo_lfs==1
    replace ocup_code_prim=11 if ocup_code_prim==. & ilo_lfs==1
 


    * MAIN JOB

    *---------------------------------------------------------------------------
	* ISCO 88
	*---------------------------------------------------------------------------

 
    * 1-digit level
	gen ilo_job1_ocu_isco88=.
	    replace ilo_job1_ocu_isco88=11 if ocup_code_prim==11 & ilo_lfs==1                       // Not elsewhere classified
		replace ilo_job1_ocu_isco88=ocup_code_prim if (ilo_job1_ocu_isco88==. & ilo_lfs==1)     // The rest of the occupations
		replace ilo_job1_ocu_isco88=10 if (ilo_job1_ocu_isco88==0 & ilo_lfs==1)                 // Armed forces
		        lab def ocu_isco88_1digit 1 "1 - Legislators, senior officials and managers"	2 "2 - Professionals"	3 "3 - Technicians and associate professionals"	4 "4 - Clerks"	///
                                          5 "5 - Service workers and shop and market sales workers"	6 "6 - Skilled agricultural and fishery workers"	7 "7 - Craft and related trades workers"	8 "8 - Plant and machine operators and assemblers"	///
                                          9 "9 - Elementary occupations"	10 "0 - Armed forces"	11 "11 - Not elsewhere classified"		
				lab val ilo_job1_ocu_isco88 ocu_isco88_1digit
				lab var ilo_job1_ocu_isco88 "Occupation (ISCO-88) - main job"
				
	* Aggregate			
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
				
    * Skill level				
    gen ilo_job1_ocu_skill=.
	    replace ilo_job1_ocu_skill=1 if ilo_job1_ocu_isco88==9                  // Low
		replace ilo_job1_ocu_skill=2 if inlist(ilo_job1_ocu_isco88,4,5,6,7,8)   // Medium
		replace ilo_job1_ocu_skill=3 if inlist(ilo_job1_ocu_isco88,1,2,3)       // High
		replace ilo_job1_ocu_skill=4 if inlist(ilo_job1_ocu_isco88,10,11)       // Not elsewhere classified
				lab def ocu_skill_lab 1 "1 - Skill level 1 (low)" 2 "2 - Skill level 2 (medium)" 3 "3 - Skill levels 3 and 4 (high)" 4 "4 - Not elsewhere classified"
			    lab val ilo_job1_ocu_skill ocu_skill_lab
			    lab var ilo_job1_ocu_skill "Occupation (Skill level) - main job"
				
     
	 
	 
	 * SECOND JOB
	 
* Comment: the mapping has been made between CMO-94 and ISCO-88 
 
destring p8a, replace

gen ocup_code_sec=.
	replace ocup_code_sec=1 if inrange(int(p8d/10),210,219) & ilo_mjh==2
    replace ocup_code_sec=2 if (inrange(int(p8d/10),110,119)|inrange(int(p8d/10),130,132) | inrange(int(p8d/10),136,143)) & ilo_mjh==2
	replace ocup_code_sec=3 if (inrange(int(p8d/10),120,129)| inrange(int(p8d/10),133,135) | inrange(int(p8d/10),144,149) | ///
	inlist(int(p8d/10),417,713)|inrange(int(p8d/10),510,519) | inrange(int(p8d/10),553,554)| inrange(int(p8d/10),610,619)) & ilo_mjh==2
    replace ocup_code_sec=4 if inrange(int(p8d/10),620,625) & ilo_mjh==2
	replace ocup_code_sec=5 if (inrange(int(p8d/10),626,712)|inrange(int(p8d/10),813,814)|inrange(int(p8d/10),816,819)|inlist(int(p8d/10),719,810,830,839)) & ilo_mjh==2
    replace ocup_code_sec=6 if (inrange(int(p8d/10),410,416)|int(p8d/10)==419) & ilo_mjh==2
    replace ocup_code_sec=7 if inrange(int(p8d/10),520,529) & ilo_mjh==2
	replace ocup_code_sec=8 if (inrange(int(p8d/10),530,539) | inrange(int(p8d/10),550,552) | inrange(int(p8d/10),555,559)) & ilo_mjh==2
	replace ocup_code_sec=9 if (inrange(int(p8d/10),540,549) | inrange(int(p8d/10),720,729) | inrange(int(p8d/10),811,812) | ///
	inlist(int(p8d/10),815,820)) & ilo_mjh==2
    replace ocup_code_sec=10 if int(p8d/10)==831 & ilo_mjh==2
    replace ocup_code_sec=11 if ocup_code_sec==. & ilo_mjh==2	 
	 
    *---------------------------------------------------------------------------
	* ISCO 88
	*---------------------------------------------------------------------------

 
			
    * 1-digit level
	gen ilo_job2_ocu_isco88=.
	    replace ilo_job2_ocu_isco88=11 if ocup_code_sec==11 & ilo_mjh==2                       // Not elsewhere classified
		replace ilo_job2_ocu_isco88=ocup_code_sec if (ilo_job2_ocu_isco88==. & ilo_mjh==2)     // The rest of the occupations
		replace ilo_job2_ocu_isco88=10 if (ilo_job2_ocu_isco88==0 & ilo_mjh==2)                // Armed forces
                * labels already defined for main job
				lab val ilo_job2_ocu_isco88 ocu_isco88_1digit
				lab var ilo_job2_ocu_isco88 "Occupation (ISCO-88) - second job"
				
	* Aggregate:			
	gen ilo_job2_ocu_aggregate=.
		replace ilo_job2_ocu_aggregate=1 if inrange(ilo_job2_ocu_isco88,1,3)
		replace ilo_job2_ocu_aggregate=2 if inlist(ilo_job2_ocu_isco88,4,5)
		replace ilo_job2_ocu_aggregate=3 if inlist(ilo_job2_ocu_isco88,6,7)
		replace ilo_job2_ocu_aggregate=4 if ilo_job2_ocu_isco88==8
		replace ilo_job2_ocu_aggregate=5 if ilo_job2_ocu_isco88==9
		replace ilo_job2_ocu_aggregate=6 if ilo_job2_ocu_isco88==10
		replace ilo_job2_ocu_aggregate=7 if ilo_job2_ocu_isco88==11
                * labels already defined for main job
		        lab val ilo_job2_ocu_aggregate ocu_aggr_lab
				lab var ilo_job2_ocu_aggregate "Occupation (Aggregate) - second job"				
				
    * Skill level				
    gen ilo_job2_ocu_skill=.
	    replace ilo_job2_ocu_skill=1 if ilo_job2_ocu_isco88==9                  // Low
		replace ilo_job2_ocu_skill=2 if inlist(ilo_job2_ocu_isco88,4,5,6,7,8)   // Medium
		replace ilo_job2_ocu_skill=3 if inlist(ilo_job2_ocu_isco88,1,2,3)       // High
		replace ilo_job2_ocu_skill=4 if inlist(ilo_job2_ocu_isco88,10,11)       // Not elsewhere classified
		        * labels already defined for main job
			    lab val ilo_job2_ocu_skill ocu_skill_lab
			    lab var ilo_job2_ocu_skill "Occupation (Skill level) - second job"
				
   
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*	Institutional sector of economic activities ('ilo_ins_sector')		       *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 
destring p5, replace
		
	gen ilo_job1_ins_sector=.
		replace ilo_job1_ins_sector=1 if  p5==1 & ilo_lfs==1                    // Public
		replace ilo_job1_ins_sector=2 if ilo_job1_ins_sector==. & ilo_lfs==1    // Private
			    lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
			    lab values ilo_job1_ins_sector ins_sector_lab
			    lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities - main job"
		
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*		               Hours of work ('ilo_how')  	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 
destring p6_1 p6_2, replace

    * MAIN JOB
	
	* Hours USUALLY worked
	gen ilo_job1_how_usual = .
	    replace ilo_job1_how_usual = p6_2  if ilo_lfs==1
	            lab var ilo_job1_how_usual "Weekly hours usually worked - main job"
		  
	gen ilo_job1_how_usual_bands=.
	 	replace ilo_job1_how_usual_bands=1 if ilo_job1_how_usual==0
		replace ilo_job1_how_usual_bands=2 if ilo_job1_how_usual>=1 & ilo_job1_how_usual<=14
		replace ilo_job1_how_usual_bands=3 if ilo_job1_how_usual>14 & ilo_job1_how_usual<=29
		replace ilo_job1_how_usual_bands=4 if ilo_job1_how_usual>29 & ilo_job1_how_usual<=34
		replace ilo_job1_how_usual_bands=5 if ilo_job1_how_usual>34 & ilo_job1_how_usual<=39
		replace ilo_job1_how_usual_bands=6 if ilo_job1_how_usual>39 & ilo_job1_how_usual<=48
		replace ilo_job1_how_usual_bands=7 if ilo_job1_how_usual>48 & ilo_job1_how_usual!=.
		replace ilo_job1_how_usual_bands=8 if ilo_job1_how_usual_bands==. & ilo_lfs==1
		replace ilo_job1_how_usual_bands=. if ilo_lfs!=1
		   	    lab def how_bands_usu 1 "No hours usually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"		
				lab val ilo_job1_how_usual_bands how_bands_usu
				lab var ilo_job1_how_usual_bands "Weekly hours usually worked bands - main job"

	* Hours ACTUALLY worked
	gen ilo_job1_how_actual = .
	    replace ilo_job1_how_actual = p6_1 if ilo_lfs==1
		        lab var ilo_job1_how_actual "Weekly hours actually worked - main job"
		
    gen ilo_job1_how_actual_bands=.
	    replace ilo_job1_how_actual_bands=1 if ilo_job1_how_actual==0
	    replace ilo_job1_how_actual_bands=2 if ilo_job1_how_actual>=1 & ilo_job1_how_actual<=14
	    replace ilo_job1_how_actual_bands=3 if ilo_job1_how_actual>14 & ilo_job1_how_actual<=29
	    replace ilo_job1_how_actual_bands=4 if ilo_job1_how_actual>29 & ilo_job1_how_actual<=34
	    replace ilo_job1_how_actual_bands=5 if ilo_job1_how_actual>34 & ilo_job1_how_actual<=39
	    replace ilo_job1_how_actual_bands=6 if ilo_job1_how_actual>39 & ilo_job1_how_actual<=48
	    replace ilo_job1_how_actual_bands=7 if ilo_job1_how_actual>48 & ilo_job1_how_actual!=.
	    replace ilo_job1_how_actual_bands=8 if ilo_job1_how_actual_bands==. & ilo_lfs==1
	    replace ilo_job1_how_actual_bands=. if ilo_lfs!=1
		   	    lab def how_bands_act 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"		
				lab val ilo_job1_how_actual_bands how_bands_act
				lab var ilo_job1_how_actual_bands "Weekly hours actually worked bands - main job"
	

    * SECOND JOB: no info
 

    * ALL JOBS: no info
	
	 
		
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job_time')		                   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 
	
* Comment: legal maximum: 48 h per week, 8 h per day
			* full_time job: 35 h per week

	gen ilo_job1_job_time=.
		replace ilo_job1_job_time=1 if ilo_job1_how_usual<=34 & ilo_job1_how_usual!=.
		replace ilo_job1_job_time=2 if ilo_job1_how_usual>=35 & ilo_job1_how_usual!=.
		replace ilo_job1_job_time=3 if ilo_job1_job_time==. & ilo_lfs==1
			    lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
			    lab val ilo_job1_job_time job_time_lab
			    lab var ilo_job1_job_time "Job (Working time arrangement)"
			
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*		    	Type of contract ('ilo_job_contract') 		                   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment:  
destring p3d, replace 
	
	gen ilo_job1_job_contract=.
		replace ilo_job1_job_contract=1 if p3d==10 & ilo_lfs==1                 // Permanent
		replace ilo_job1_job_contract=2 if inrange(p3d,21,30) & ilo_lfs==1      // Temporary
		replace ilo_job1_job_contract=3 if ilo_job1_job_contract==. & ilo_lfs==1  	// Unknown
			    lab def job_contract_lab 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"
			    lab val ilo_job1_job_contract job_contract_lab
			    lab var ilo_job1_job_contract "Job (Type of contract)"
 
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*  Informal/formal economy: ('ilo_job1_ife_prod'/'ilo_job1_ife_nature') 	   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment:  

destring p7d_6 p5c p5c1 p3b p3e p7d_2, replace
/* Useful questions:
          - Institutional sector: p5
		  - Private household identification: ISIC/ISCO
		  - Destination of production: [no info]
		  - Bookkeeping: [no info]
		  - Registration: [no info]
		  - Status in employment: p3a
		  - Social security contribution (Proxy: pension funds):
		  - Place of work: p5c, p5c1 (asked to self_employed or domestic) 
		  - Size: p3b / p3e
		  - Paid annual leave: p7d_2
		  - Paid sick leave: [no info]    
		  
* Note: (p4/10)==820 >> workers in domestic services		  
*/

 
    * Social Security: [p7d_4 p7d_5] p7d_6  
	gen social_security=.
	    replace social_security=1 if p7d_6==1 & ilo_lfs==1          // social security (proxy)
		replace social_security=2 if p7d_6==2 & ilo_lfs==1          // no social security (proxy)
	
    * 1) UNIT OF PRODUCTION: FORMAL/INFORMAL SECTOR
	gen ilo_job1_ife_prod=.
	    replace ilo_job1_ife_prod=3 if ilo_lfs==1 &  (ilo_job1_eco_isic3==16 | int(p4/10)==820) 
		                               
		replace ilo_job1_ife_prod=2 if ilo_lfs==1 & ilo_job1_ife_prod!=3 & ///
		                               ((p5==1) | ///
									   (p5!=1 & ilo_job1_ste_icse93==1 & social_security==1 ) | ///
									   (p5!=1 & ilo_job1_ste_icse93==1 & social_security!=1 & inrange(p5c1,10,21) & ((p3b>=3 & !inlist(p3b,9,99))|(p3e>=3 & !inlist(p3e,9,99)))) | ///
									   (p5!=1 & ilo_job1_ste_icse93!=1 & inrange(p5c1,10,21) & ((p3b>=3 & !inlist(p3b,9,99))|(p3e>=3 & !inlist(p3e,9,99)))))
									    
		replace ilo_job1_ife_prod=1 if ilo_lfs==1 & !inlist(ilo_job1_ife_prod,2,3)
				lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 
				lab val ilo_job1_ife_prod ilo_ife_prod_lab
				lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"		
		
	
	* 2) NATURE OF JOB: FORMAL/INFORMAL EMPLOYMENT
	gen ilo_job1_ife_nature=.
	    replace ilo_job1_ife_nature=2 if ilo_lfs==1 & ///
	                                     ((inlist(ilo_job1_ste_icse93,1,6) & social_security==1) | ///
										 (inlist(ilo_job1_ste_icse93,2,4) & ilo_job1_ife_prod==1)) 								 
	    replace ilo_job1_ife_nature=1 if ilo_lfs==1 & ilo_job1_ife_nature!=2
                lab def ife_nature_lab 1 "1 - Persons with informal main job" 2 "2 - Persons with formal main job"
		        lab val ilo_job1_ife_nature ife_nature_lab
		        lab var ilo_job1_ife_nature "Informal / Formal Economy (Nature of job)"	
		 
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*	    Monthly labour related income ('ilo_lri_ees' and 'ilo_lri_slf')  	   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment:  ingocup [monthly income]
    * MAIN JOB
 

	* Employees
	gen ilo_job1_lri_ees = .
	    replace ilo_job1_lri_ees = ingocup if ilo_job1_ste_aggregate==1 & ingocup!=999998
	    replace ilo_job1_lri_ees = .     if ilo_lfs!=1
		        lab var ilo_job1_lri_ees "Monthly earnings of employees - main job"
	
	* Self-employed
	gen ilo_job1_lri_slf = .
	    replace ilo_job1_lri_slf = ingocup if ilo_job1_ste_aggregate==2 & ingocup!=999998
	    replace ilo_job1_lri_slf = .     if ilo_lfs!=1
		        lab var ilo_job1_lri_slf "Monthly labour related income of self-employed - main job"
			

    * SECOND JOB: no info
 		
* ------------------------------------------------------------------------------
********************************************************************************
*                                                                              *
*	          PART 3.2 ECONOMIC CHARACTERISTICS FOR ALL JOBS                   *
*                                                                              * 
********************************************************************************
* ------------------------------------------------------------------------------				

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_tru') 		                       *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: there is no information on availability or willigness
 		
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
*	Cases of non-fatal occupational injury ('ilo_joball_oi_case') 		       *
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
* Comment: no info

	 

*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
*  Days lost due to cases of occupational injury ('ilo_joball_oi_day')		   *
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
* Comment: no info

	 
				
* ------------------------------------------------------------------------------
********************************************************************************
*                                                                              *
*	          PART 3.3 UNEMPLOYMENT: ECONOMIC CHARACTERISTICS                  *
*                                                                              * 
********************************************************************************
* ------------------------------------------------------------------------------				

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			Category of unemployment ('ilo_cat_une') 	                       * 
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment:
destring p2d, replace	

	gen ilo_cat_une=.
		replace ilo_cat_une=1 if p2d==1 & ilo_lfs==2                            // Previously employed       
		replace ilo_cat_une=2 if p2d!=1 & ilo_lfs==2                            // Seeking for the first time
		replace ilo_cat_une=3 if ilo_cat_une==. & ilo_lfs==2                    // Unknown
			    lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
			    lab val ilo_cat_une cat_une_lab
			    lab var ilo_cat_une "Category of unemployment"
				
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			   Duration of unemployment ('ilo_dur')  	                       * 
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: TO CHECK!!! variable p2b1_2 seems not to be computed correctly.
destring  p2b1_2, replace
		
    
		
    * Aggregate categories
	gen ilo_dur_aggregate=.
		replace ilo_dur_aggregate=1 if (inrange(p2b1_2,1,4) & ilo_lfs==2)       // Less than 6 months
		replace ilo_dur_aggregate=2 if (p2b1_2==5 & ilo_lfs==2)                 // 6 to 12 months
		replace ilo_dur_aggregate=3 if (p2b1_2==6 & ilo_lfs==2)                 // 12 months or more
		replace ilo_dur_aggregate=4 if (p2b1_2==9 & ilo_lfs==2)                 // Not elsewhere classified
		replace ilo_dur_aggregate=. if ilo_lfs!=2
			    lab def unemp_aggr 1 "1 - Less than 6 months" 2 "2 - 6 months to less than 12 months" 3 "3 - 12 months or more" 4 "4 - Not elsewhere classified"
			    lab val ilo_dur_aggregate unemp_aggr
			    lab var ilo_dur_aggregate "Duration of unemployment (Aggregate)"
		
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4') 	               * 
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: no info

  	
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu_isco08') 		                   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: no info
			
* ------------------------------------------------------------------------------
********************************************************************************
*                                                                              *
*	        PART 3.4 OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS            *
*                                                                              * 
********************************************************************************
* ------------------------------------------------------------------------------				

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*		Degree of labour market attachment ('ilo_olf_dlma') 	               * 
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: no info

 

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			Reasons for not seeking a job ('ilo_olf_reason') 	               *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 
destring p2c, replace

		gen ilo_olf_reason=.
			replace ilo_olf_reason=1 if inrange(p2c,2,5) & ilo_lfs==3           // Labour market 
			replace ilo_olf_reason=2 if p2c==1 & ilo_lfs==3                     // Other labour market reasons
			replace ilo_olf_reason=3 if inlist(p2c,6,7) & ilo_lfs==3            // Personal/Family-related
			replace ilo_olf_reason=4 if p2c==8 & ilo_lfs==3                     // Does not need/want to work
			replace ilo_olf_reason=5 if ilo_olf_reason==. & ilo_lfs==3          // Not elsewhere classified
 			        lab def lab_olf_reason 1 "1 - Labour market" 2 " 2 - Other labour market reasons" 3 "3 - Personal/Family-related"  ///
				                           4 "4 - Does not need/want to work" 5 "5 - Not elsewhere classified"
					lab val ilo_olf_reason lab_olf_reason
					lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"		

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			      Discouraged job-seekers ('ilo_dis') 		                   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: there is no information on availability

 

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*  Youth not in education, employment or training (NEETs) ('ilo_neet') 		   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: there is no information on attendance

 
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			                    SAVE RESULTS                                   *            
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

* ------------------------------------------------------------------------------
*                       Preparation of final dataset                           *
* ------------------------------------------------------------------------------

cd "$outpath"
	
	/* Variables computed in-between */
	drop edu_num  term  educ
	drop indu_code_prim indu_code_sec ocup_code_prim ocup_code_sec
	compress
		
	/* Save dataset including original and ilo variables*/
	save ${country}_${source}_${time}_FULL,  replace		
	
	*Save file only containing ilo_* variables
	keep ilo*
	save ${country}_${source}_${time}_ILO, replace
		
