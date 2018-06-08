* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Mexico 
* DATASET USED: Mexico QLFS 
* NOTES: 
* Files created: Standard variables on QLFS Mexico 
* Authors: ILO / Department of Statistics / DPAU

* Starting Date: 13 January 2017
* Last updated: 08 February 2018
***********************************************************************************************


*******************************************************************
 /* 1.	Set up work directory, file name, variables and function */
*******************************************************************


clear all 

set more off

global path "J:\DPAU\MICRO"
global country "MEX"
global source "ENOE"
global time "2007Q1"
global inputFile "MEX_ENOE_2007Q1_ORI.dta"

global inpath "${path}\\${country}\\${source}\\${time}\ORI"
global outpath "${path}\\${country}\\${source}\\${time}"

			
*********************************************************************************************

* Load original dataset

*********************************************************************************************


cd "$inpath"

	use "$inputFile", clear	
	
	* for the definition of our variables, don't consider observations that correspond to "no interview" or absent person from household
	
	gen considered=1 if R_DEF==0 & inlist(C_RES,1,3)	
	
	* generate help variable for time --> note that the questionnaires are different depending on the quarter considerered
		* 1st quarter of the year --> "cuestionario ampliado" (i.e. extended questionnaire)
		* 2nd, 3rd and 4th quarters --> "cuestionario bÃ¡sico" (i.e. basic questionnaire) --> contains fewer questions
		
	gen time="${time}"
		split time, gen(time_) parse(Q)
		
		destring time_*, replace
		rename (time_1 time_2) (year quarter)
		

**********************************************************************************************
	
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

	gen ilo_wgt=FAC
		lab var ilo_wgt "Sample weight"	
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time period ('ilo_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment:

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
* Comment: given the unavailability of a variable defining rural and urban areas, a proxy is being taken
			* by considering all locations with less than 2500 inhabitants as rural
		
		gen ilo_geo=.
			replace ilo_geo=1 if inlist(T_LOC,1,2,3)
			replace ilo_geo=2 if T_LOC==4
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

		gen ilo_sex=SEX
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

	gen ilo_age=EDA if EDA!=99
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

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Level of education ('ilo_edu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: completed level of education always to be considered!

				* note that original question only asked to individuals 5+ 
		
		gen educ_years=CS_P13_2
			destring educ_years, replace
		
	gen ilo_edu_isced97=.
		replace ilo_edu_isced97=1 if CS_P13_1==0 | (CS_P13_1==1 & educ_years<2) 																// No schooling
		replace ilo_edu_isced97=2 if (CS_P13_1==1 & inlist(educ_years,2,3)) | (CS_P13_1==2 & inrange(educ_years,1,5)) 							// Pre-primary education
		replace ilo_edu_isced97=3 if (CS_P13_1==2 & educ_years==6) | (CS_P13_1==3 & inrange(educ_years,1,2))									// Primary education
		replace ilo_edu_isced97=4 if (CS_P13_1==3 & educ_years==3) | (CS_P13_1==4 & inrange(educ_years,1,2))									// Lower secondary education
		replace ilo_edu_isced97=5 if (CS_P13_1==4 & educ_years==3) | (inlist(CS_P13_1,5,6,7) & inrange(educ_years,1,3)) | ///
												(CS_P13_1==8 & educ_years==1)																	// Upper secondary education
		/* replace ilo_edu_isced97=6 if */																										// Post-secondary non-tertiary education
		replace ilo_edu_isced97=7 if (inlist(CS_P13_1,5,6,7) & educ_years>=4 & educ_years!=.) | (CS_P13_1==8 & educ_years>=2 & educ_years!=.) |	///
										(CS_P13_1==9 & inrange(educ_years,1,2))																// First stage of tertiary education 
		replace ilo_edu_isced97=8 if CS_P13_1==9 & educ_years>=3 & educ_years!=.																// Second stage of tertiary education
		replace ilo_edu_isced97=9 if ilo_edu_isced97==.																							// Unknown level
			label def isced_97_lab 1 "X - No schooling" 2 "0 - Pre-primary education" 3 "1 - Primary education or first stage of basic education" 4 "2 - Lower secondary education or second stage of basic education" ///
							5 "3 - Upper secondary education" 6 "4 - Post-secondary non-tertiary education" 7 "5 - First stage of tertiary education (not leading directly to an advanced research qualification)" ///
							8 "6 - Second stage of tertiary education (leading to an advanced research qualification)" 9 "UNK - Level not stated"
			label val ilo_edu_isced97 isced_97_lab
			lab var ilo_edu_isced97 "Level of education (ISCED 97)"


		* for the definition, cf. the document "Guide to reporting labour statistics to the ILO using the Excel questionnaire"
		
	gen ilo_edu_aggregate=.
		replace ilo_edu_aggregate=1 if inlist(ilo_edu_isced97,1,2)
		replace ilo_edu_aggregate=2 if inlist(ilo_edu_isced97,3,4)
		replace ilo_edu_aggregate=3 if inlist(ilo_edu_isced97,5,6)
		replace ilo_edu_aggregate=4 if inlist(ilo_edu_isced97,7,8)
		replace ilo_edu_aggregate=5 if ilo_edu_isced97==9
			label def edu_aggr_lab 1 "1 - Less than basic" 2 "2 - Basic" 3 "3 - Intermediate" 4 "4 - Advanced" 5 "5 - Level not stated"
			label val ilo_edu_aggregate edu_aggr_lab
			label var ilo_edu_aggregate "Level of education (Aggregate levels)"
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education attendance ('ilo_edu_attendance') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: --> according to questionnaire, questions regarding education should be asked 
				* to individuals 5+ only

		gen ilo_edu_attendance=.
			replace ilo_edu_attendance=1 if CS_P17==1
			replace ilo_edu_attendance=2 if CS_P17==2
			replace ilo_edu_attendance=3 if ilo_edu_attendance==.
				lab def edu_attendance_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
				lab val ilo_edu_attendance edu_attendance_lab
				lab var ilo_edu_attendance "Education (Attendance)"		

				

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			           Marital status ('ilo_mrts') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 
	
	* Detailed
	gen ilo_mrts_details=.
	    replace ilo_mrts_details=1 if E_CON == 6                                          // Single
		replace ilo_mrts_details=2 if E_CON == 5                                          // Married
		replace ilo_mrts_details=3 if E_CON == 1                                          // Union / cohabiting
		replace ilo_mrts_details=4 if E_CON == 4                                          // Widowed
		replace ilo_mrts_details=5 if inlist(E_CON,2,3)                                   // Divorced / separated
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
*			Disability status ('ilo_dsb_details') [no info]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment: 
				
	* gen ilo_dsb_aggregate=.

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
     	 
* Comment: 

	* Important note - questionnaire for 2007Q1 (and previous periods) contains a skip pattern, where people answering that the last time 
		* they were seeking a job was up to a month ago are NOT asked about their availability (i.e. question 2c not asked to anyone answering "hasta un mÃ©s" in question 2b
		
		* Therefore for these time periods, the strict ILO definition cannot be used, i.e. only two criteria instead of three criteria can be considered for identifying people in unemployment
		
	if year<=2006 | (year==2007 & quarter==1) {
	
	gen ilo_lfs=.
		replace ilo_lfs=1 if P1==1 | P1A1==1 | P1A2==2 | inrange(P1C,1,4) | P1D==1 | P1E==1
		replace ilo_lfs=2 if ilo_lfs!=1 & (((P2_1==1 | P2_2==2 | P2_3==3) & P2B==1) | P1C==11)
		replace ilo_lfs=3 if !inlist(ilo_lfs,1,2) & ilo_wap==1
		replace ilo_lfs=. if ilo_wap!=1	
				label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status" 
				
				}
				
	else {
 
	gen ilo_lfs=.
		replace ilo_lfs=1 if P1==1 | P1A1==1 | P1A2==2 | inrange(P1C,1,4) | P1D==1 | P1E==1
		replace ilo_lfs=2 if ilo_lfs!=1 & (((P2_1==1 | P2_2==2 | P2_3==3) & P2B==1) | P1C==11) & P2C==1
		replace ilo_lfs=3 if !inlist(ilo_lfs,1,2) & ilo_wap==1
		replace ilo_lfs=. if ilo_wap!=1	
				label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status" 
				}	
				
	* compare numbers obtained with pre-defined variable "CLASE2"
	
		* numbers almost match perfectly, except for very few observations that are considered in ilo_lfs as "outside the labour force" 
		* and by INEGI as "unemployed", might be related to the consideration of people "ausentes sin ingreso ni nexo laboral con bÃºsqueda" 
		* ("absent without earnings nor link to any job, but seeking a job") for whom, according to the technical documentation, the 
		* availability criterion is not being tested for
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment:

	gen ilo_mjh=.
		replace ilo_mjh=1 if P7==7
		replace ilo_mjh=2 if inrange(P7,1,6)
		replace ilo_mjh=. if ilo_lfs!=1
			lab def lab_ilo_mjh 1 "1 - One job only" 2 "2 - More than one job"
			lab val ilo_mjh lab_ilo_mjh
			lab var ilo_mjh "Multiple job holders"

***********************************************************************************************
*			PART 3.1. ECONOMIC CHARACTERISTICS FOR MAIN JOB 
***********************************************************************************************		

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Status in employment ('ilo_ste') [done]
* -------------------------------------------------------------------------------------------
* ------------------------------------------------------------------------------------------- 

* Comment: follow the same definition as the one described in the technical documentation (reconstrucciÃ³n de variables) at page 8.

	* Primary activity
	
	gen ilo_job1_ste_icse93=.
			replace ilo_job1_ste_icse93=1 if P3H==1
			replace ilo_job1_ste_icse93=2 if P3B==1 & P3G1_1==1
			replace ilo_job1_ste_icse93=3 if inlist(P3D,2,9) | (P3D==1 & P3G1_1!=1)
			/*replace ilo_job1_ste_icse93=4 if  */
			replace ilo_job1_ste_icse93=5 if inlist(P3H,2,3)
			replace ilo_job1_ste_icse93=6 if ilo_job1_ste_icse93==. & ilo_lfs==1
			replace ilo_job1_ste_icse93=. if ilo_lfs!=1			
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
*			Economic activity ('ilo_eco') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: mappping for SCIAN (NAICS) 2007 in "_help" folder 


	gen indu_code_prim=int(P4A/10) if P4A!=9999 & ilo_lfs==1
	
	gen ilo_job1_eco_isic4_2digits=.
		replace ilo_job1_eco_isic4_2digits=1 if inlist(indu_code_prim,111,112,115,119)
		replace ilo_job1_eco_isic4_2digits=2 if indu_code_prim==113
		replace ilo_job1_eco_isic4_2digits=3 if indu_code_prim==114
		/*replace ilo_job1_eco_isic4_2digits=5 if inlist(indu_code_prim,*/
		replace ilo_job1_eco_isic4_2digits=6 if indu_code_prim==211
		replace ilo_job1_eco_isic4_2digits=7 if indu_code_prim==212
		/*replace ilo_job1_eco_isic4_2digits=8 if inlist(indu_code_prim,*/
		replace ilo_job1_eco_isic4_2digits=9 if indu_code_prim==213
		replace ilo_job1_eco_isic4_2digits=10 if indu_code_prim==311
		replace ilo_job1_eco_isic4_2digits=11 if indu_code_prim==312
		/*replace ilo_job1_eco_isic4_2digits=12 if inlist(indu_code_prim,*/
		replace ilo_job1_eco_isic4_2digits=13 if inlist(indu_code_prim,313,314)
		replace ilo_job1_eco_isic4_2digits=14 if indu_code_prim==315
		replace ilo_job1_eco_isic4_2digits=15 if indu_code_prim==316
		replace ilo_job1_eco_isic4_2digits=16 if indu_code_prim==321
		replace ilo_job1_eco_isic4_2digits=17 if indu_code_prim==322
		replace ilo_job1_eco_isic4_2digits=18 if indu_code_prim==323
		replace ilo_job1_eco_isic4_2digits=19 if indu_code_prim==324
		replace ilo_job1_eco_isic4_2digits=20 if indu_code_prim==325
		/*replace ilo_job1_eco_isic4_2digits=21 if inlist(indu_code_prim,*/
		replace ilo_job1_eco_isic4_2digits=22 if indu_code_prim==326
		replace ilo_job1_eco_isic4_2digits=23 if indu_code_prim==327
		replace ilo_job1_eco_isic4_2digits=24 if indu_code_prim==331
		replace ilo_job1_eco_isic4_2digits=25 if indu_code_prim==332
		replace ilo_job1_eco_isic4_2digits=26 if indu_code_prim==334
		replace ilo_job1_eco_isic4_2digits=27 if indu_code_prim==335
		replace ilo_job1_eco_isic4_2digits=28 if inlist(indu_code_prim,333,336)
		/*replace ilo_job1_eco_isic4_2digits=29 if indu_code_prim==*/
		/*replace ilo_job1_eco_isic4_2digits=30 if indu_code_prim==*/
		replace ilo_job1_eco_isic4_2digits=31 if indu_code_prim==337
		replace ilo_job1_eco_isic4_2digits=32 if inlist(indu_code_prim,338,339)
		replace ilo_job1_eco_isic4_2digits=33 if P4A==8113
		replace ilo_job1_eco_isic4_2digits=35 if indu_code_prim==221
		replace ilo_job1_eco_isic4_2digits=36 if indu_code_prim==222
		/*replace ilo_job1_eco_isic4_2digits=37 if indu_code_prim==*/
		replace ilo_job1_eco_isic4_2digits=38 if indu_code_prim==562
		/*replace ilo_job1_eco_isic4_2digits=39 if indu_code_prim==*/
		replace ilo_job1_eco_isic4_2digits=41 if indu_code_prim==236
		replace ilo_job1_eco_isic4_2digits=42 if indu_code_prim==237
		replace ilo_job1_eco_isic4_2digits=43 if indu_code_prim==238
		replace ilo_job1_eco_isic4_2digits=45 if indu_code_prim==436 | P4A==8111
		replace ilo_job1_eco_isic4_2digits=46 if inlist(indu_code_prim,424,431,432,433,434,435,437)
		replace ilo_job1_eco_isic4_2digits=47 if inlist(indu_code_prim,445,446,447,454,461,462,463,464,465,466,467,468,469)
		replace ilo_job1_eco_isic4_2digits=49 if inlist(indu_code_prim,482,484,485,486,487)
		replace ilo_job1_eco_isic4_2digits=50 if indu_code_prim==483
		replace ilo_job1_eco_isic4_2digits=51 if indu_code_prim==481
		replace ilo_job1_eco_isic4_2digits=52 if inlist(indu_code_prim,488,493)
		replace ilo_job1_eco_isic4_2digits=53 if inlist(indu_code_prim,491,492)
		replace ilo_job1_eco_isic4_2digits=55 if indu_code_prim==721
		replace ilo_job1_eco_isic4_2digits=56 if indu_code_prim==722
		replace ilo_job1_eco_isic4_2digits=58 if inlist(indu_code_prim,511,519)
		replace ilo_job1_eco_isic4_2digits=59 if indu_code_prim==512
		replace ilo_job1_eco_isic4_2digits=60 if indu_code_prim==515
		replace ilo_job1_eco_isic4_2digits=61 if indu_code_prim==517
		/*replace ilo_job1_eco_isic4_2digits=62 if indu_code_prim==*/
		replace ilo_job1_eco_isic4_2digits=63 if indu_code_prim==518
		replace ilo_job1_eco_isic4_2digits=64 if inlist(indu_code_prim,521,522)
		replace ilo_job1_eco_isic4_2digits=65 if indu_code_prim==524
		replace ilo_job1_eco_isic4_2digits=66 if indu_code_prim==523
		replace ilo_job1_eco_isic4_2digits=68 if indu_code_prim==531
		/*replace ilo_job1_eco_isic4_2digits=69 if indu_code_prim==*/
		replace ilo_job1_eco_isic4_2digits=70 if indu_code_prim==551
		replace ilo_job1_eco_isic4_2digits=71 if indu_code_prim==541
		/*replace ilo_job1_eco_isic4_2digits=72 if inlist(indu_code_prim,*/
		/*replace ilo_job1_eco_isic4_2digits=73 if inlist(indu_code_prim,*/
		/*replace ilo_job1_eco_isic4_2digits=74 if inlist(indu_code_prim,*/
		/*replace ilo_job1_eco_isic4_2digits=75 if inlist(indu_code_prim,*/
		replace ilo_job1_eco_isic4_2digits=77 if inlist(indu_code_prim,532,533)
		/*replace ilo_job1_eco_isic4_2digits=78 if inlist(indu_code_prim,*/
		/*replace ilo_job1_eco_isic4_2digits=79 if inlist(indu_code_prim,*/
		/*replace ilo_job1_eco_isic4_2digits=80 if inlist(indu_code_prim,*/
		/*replace ilo_job1_eco_isic4_2digits=81 if inlist(indu_code_prim,*/
		replace ilo_job1_eco_isic4_2digits=82 if indu_code_prim==561
		replace ilo_job1_eco_isic4_2digits=84 if inlist(indu_code_prim,921,922,923,924,925,931)
		replace ilo_job1_eco_isic4_2digits=85 if inlist(indu_code_prim,611,612,613,614,615,619)
		replace ilo_job1_eco_isic4_2digits=86 if inlist(indu_code_prim,621,622)
		replace ilo_job1_eco_isic4_2digits=87 if indu_code_prim==623
		replace ilo_job1_eco_isic4_2digits=88 if indu_code_prim==624
		replace ilo_job1_eco_isic4_2digits=90 if indu_code_prim==711
		replace ilo_job1_eco_isic4_2digits=91 if indu_code_prim==712
		/*replace ilo_job1_eco_isic4_2digits=92 if indu_code_prim==*/
		replace ilo_job1_eco_isic4_2digits=93 if indu_code_prim==713
		replace ilo_job1_eco_isic4_2digits=94 if indu_code_prim==813
		replace ilo_job1_eco_isic4_2digits=95 if inlist(P4A,8112,8114)
		replace ilo_job1_eco_isic4_2digits=96 if indu_code_prim==812
		replace ilo_job1_eco_isic4_2digits=97 if indu_code_prim==814
		/*replace ilo_job1_eco_isic4_2digits=98 if indu_code_prim==*/
		replace ilo_job1_eco_isic4_2digits=99 if indu_code_prim==932
				replace ilo_job1_eco_isic4_2digits=. if ilo_lfs!=1
			lab def eco_isic4_2digits_lab 1 "01 - Crop and animal production, hunting and related service activities" 2 "02 - Forestry and logging" 3 "03 - Fishing and aquaculture" 5 "05 - Mining of coal and lignite" /// 
							6 "06 - Extraction of crude petroleum and natural gas" 7 "07 - Mining of metal ores" 8 "08 - Other mining and quarrying" 9 "09 - Mining support service activities" /// 
							10 "10 - Manufacture of food products" 11 "11 - Manufacture of beverages" 12 "12 - Manufacture of tobacco products" 13 "13 - Manufacture of textiles" 14 "14 - Manufacture of wearing apparel" /// 
							15 "15 - Manufacture of leather and related products" 16 "16 - Manufacture of wood and of products of wood and cork, except furniture; manufacture of articles of straw and plaiting materials" /// 
							17 "17 - Manufacture of paper and paper products" 18 "18 - Printing and reproduction of recorded media" 19 "19 - Manufacture of coke and refined petroleum products" /// 
							20 "20 - Manufacture of chemicals and chemical products" 21 "21 - Manufacture of basic pharmaceutical products and pharmaceutical preparations" 22 "22 - Manufacture of rubber and plastics products" /// 
							23 "23 - Manufacture of other non-metallic mineral products" 24 "24 - Manufacture of basic metals" 25 "25 - Manufacture of fabricated metal products, except machinery and equipment" /// 
							26 "26 - Manufacture of computer, electronic and optical products" 27 "27 - Manufacture of electrical equipment" 28 "28 - Manufacture of machinery and equipment n.e.c." /// 
							29 "29 - Manufacture of motor vehicles, trailers and semi-trailers" 30 "30 - Manufacture of other transport equipment" 31 "31 - Manufacture of furniture" 32 "32 - Other manufacturing" /// 
							33 "33 - Repair and installation of machinery and equipment" 35 "35 - Electricity, gas, steam and air conditioning supply" 36 "36 - Water collection, treatment and supply" 37 "37 - Sewerage" /// 
							38 "38 - Waste collection, treatment and disposal activities; materials recovery" 39 "39 - Remediation activities and other waste management services" 41 "41 - Construction of buildings" /// 
							42 "42 - Civil engineering" 43 "43 - Specialized construction activities" 45 "45 - Wholesale and retail trade and repair of motor vehicles and motorcycles" /// 
							46 "46 - Wholesale trade, except of motor vehicles and motorcycles" 47 "47 - Retail trade, except of motor vehicles and motorcycles" 49 "49 - Land transport and transport via pipelines" /// 
							50 "50 - Water transport" 51 "51 - Air transport" 52 "52 - Warehousing and support activities for transportation" 53 "53 - Postal and courier activities" 55 "55 - Accommodation" /// 
							56 "56 - Food and beverage service activities" 58 "58 - Publishing activities" 59 "59 - Motion picture, video and television programme production, sound recording and music publishing activities" /// 
							60 "60 - Programming and broadcasting activities" 61 "61 - Telecommunications" 62 "62 - Computer programming, consultancy and related activities" 63 "63 - Information service activities" /// 
							64 "64 - Financial service activities, except insurance and pension funding" 65 "65 - Insurance, reinsurance and pension funding, except compulsory social security" /// 
							66 "66 - Activities auxiliary to financial service and insurance activities" 68 "68 - Real estate activities" 69 "69 - Legal and accounting activities" /// 
							70 "70 - Activities of head offices; management consultancy activities" 71 "71 - Architectural and engineering activities; technical testing and analysis" 72 "72 - Scientific research and development" /// 
							73 "73 - Advertising and market research" 74 "74 - Other professional, scientific and technical activities" 75 "75 - Veterinary activities" 77 "77 - Rental and leasing activities" 78 "78 - Employment activities" /// 
							79 "79 - Travel agency, tour operator, reservation service and related activities" 80 "80 - Security and investigation activities" 81 "81 - Services to buildings and landscape activities" /// 
							82 "82 - Office administrative, office support and other business support activities" 84 "84 - Public administration and defence; compulsory social security" 85 "85 - Education" /// 
							86 "86 - Human health activities" 87 "87 - Residential care activities" 88 "88 - Social work activities without accommodation" 90 "90 - Creative, arts and entertainment activities" /// 
							91 "91 - Libraries, archives, museums and other cultural activities" 92 "92 - Gambling and betting activities" 93 "93 - Sports activities and amusement and recreation activities" /// 
							94 "94 - Activities of membership organizations" 95 "95 - Repair of computers and personal and household goods" 96 "96 - Other personal service activities" /// 
							97 "97 - Activities of households as employers of domestic personnel" 98 "98 - Undifferentiated goods- and services-producing activities of private households for own use" /// 
							99 "99 - Activities of extraterritorial organizations and bodies"
			lab values ilo_job1_eco_isic4 eco_isic4_2digits_lab
			lab var ilo_job1_eco_isic4_2digits "Economic activity (ISIC Rev. 4), 2 digit level"


	* Do mapping at the two digit level

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
					replace ilo_job1_eco_isic4=. if ilo_lfs!=1
				lab def eco_isic4_lab 1 "A - Agriculture, forestry and fishing" 2 "B - Mining and quarrying" 3 "C - Manufacturing" 4 "D - Electricity, gas, steam and air conditioning supply" /// 
								5 "E - Water supply; sewerage, waste management and remediation activities" 6 "F - Construction" 7 "G - Wholesale and retail trade; repair of motor vehicles and motorcycles" /// 
								8 "H - Transportation and storage" 9 "I - Accommodation and food service activities" 10 "J - Information and communication" 11 "K - Financial and insurance activities" /// 
								12 "L - Real estate activities" 13 "M - Professional, scientific and technical activities" 14 "N - Administrative and support service activities" /// 
								15 "O - Public administration and defence; compulsory social security" 16 "P - Education" 17 "Q - Human health and social work activities" 18 "R - Arts, entertainment and recreation" /// 
								19 "S - Other service activities" 20 "T - Activities of households as employers; undifferentiated goods- and services-producing activities of households for own use" /// 
								21 "U - Activities of extraterritorial organizations and bodies" 22 "X - Not elsewhere classified"
				lab val ilo_job1_eco_isic4 eco_isic4_lab
				lab var ilo_job1_eco_isic4 "Economic activity (ISIC Rev. 4)"
				
	
		* Aggregate level
		
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



	* Primary activity
	/*
	gen ilo_job1_eco_aggregate=.
		replace ilo_job1_eco_aggregate=1 if RAMA_EST2==1
		replace ilo_job1_eco_aggregate=2 if RAMA_EST2==3
		replace ilo_job1_eco_aggregate=3 if RAMA_EST2==4
		replace ilo_job1_eco_aggregate=4 if RAMA_EST2==2
		replace ilo_job1_eco_aggregate=5 if inrange(RAMA_EST2,5,8)
		replace ilo_job1_eco_aggregate=6 if inrange(RAMA_EST2,9,11)
		replace ilo_job1_eco_aggregate=7 if ilo_job1_eco_aggregate==. & ilo_lfs==1
			replace ilo_job1_eco_aggregate=. if ilo_lfs!=1
				lab def eco_aggr_lab 1 "1 - Agriculture" 2 "2 - Manufacturing" 3 "3 - Construction" 4 "4 - Mining and quarrying; Electricity, gas and water supply" ///
									5 "5 - Market Services (Trade; Transportation; Accommodation and food; and Business and administrative services)"  ///
									6 "6 - Non-market services (Public administration; Community, social and other services and activities)" 7 "7 - Not classifiable by economic activity"					
				lab val ilo_job1_eco_aggregate eco_aggr_lab
				lab var ilo_job1_eco_aggregate "Economic activity (Aggregate)"
				
*/
					
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_ocu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: For periods from 2012Q3 --> use mapping based on SINCO 2011 (align it with ISCO-08) --> for previous periods, use pre-processed variable and define it only at the skill level 
				* as it can't be aligned at the aggregate level either
	
	if year>=2013 | (year==2012 & inlist(quarter,3,4)) {
	
	gen occ_code_prim=int(P3/10) if P3A!=9999 & ilo_lfs==1
									
	* 2 digit level
	
	gen ilo_job1_ocu_isco08_2digits=.
		/*replace ilo_job1_ocu_isco08_2digits=1 if inlist(occ_code_prim,
		replace ilo_job1_ocu_isco08_2digits=2 if inlist(occ_code_prim,
		replace ilo_job1_ocu_isco08_2digits=3 if inlist(occ_code_prim,*/
		replace ilo_job1_ocu_isco08_2digits=11 if inlist(occ_code_prim,111,112,113)
		replace ilo_job1_ocu_isco08_2digits=12 if inlist(occ_code_prim,121,151)
		replace ilo_job1_ocu_isco08_2digits=13 if inlist(occ_code_prim,122,131,132,152,161,162)
		replace ilo_job1_ocu_isco08_2digits=14 if inlist(occ_code_prim,141,142,171,172)
		replace ilo_job1_ocu_isco08_2digits=21 if inlist(occ_code_prim,221,222,223,224,225,226,228,254)
		replace ilo_job1_ocu_isco08_2digits=22 if inlist(occ_code_prim,241,242)
		replace ilo_job1_ocu_isco08_2digits=23 if inlist(occ_code_prim,231,232,233,234,271)
		replace ilo_job1_ocu_isco08_2digits=24 if inlist(occ_code_prim,211,212)
		replace ilo_job1_ocu_isco08_2digits=25 if occ_code_prim==227
		replace ilo_job1_ocu_isco08_2digits=26 if inlist(occ_code_prim,213,214,215,216,217,255)
		replace ilo_job1_ocu_isco08_2digits=31 if inlist(occ_code_prim,261,262,266,710,740,810,818,819,820,831,832)
		replace ilo_job1_ocu_isco08_2digits=32 if inlist(occ_code_prim,281,282)
		replace ilo_job1_ocu_isco08_2digits=33 if inlist(occ_code_prim,251,252,310,320,422,431)
		replace ilo_job1_ocu_isco08_2digits=34 if inlist(occ_code_prim,253,256)
		replace ilo_job1_ocu_isco08_2digits=35 if occ_code_prim==265
		replace ilo_job1_ocu_isco08_2digits=41 if occ_code_prim==311
		replace ilo_job1_ocu_isco08_2digits=42 if inlist(occ_code_prim,312,321,322)
		replace ilo_job1_ocu_isco08_2digits=43 if inlist(occ_code_prim,313,314)
		replace ilo_job1_ocu_isco08_2digits=44 if inlist(occ_code_prim,323,399)
		replace ilo_job1_ocu_isco08_2digits=51 if inlist(occ_code_prim,510,511,521,532,525,960,963)
		replace ilo_job1_ocu_isco08_2digits=52 if inlist(occ_code_prim,411,420,421,423,952)
		replace ilo_job1_ocu_isco08_2digits=53 if occ_code_prim==522
		replace ilo_job1_ocu_isco08_2digits=54 if inlist(occ_code_prim,531,599)
		replace ilo_job1_ocu_isco08_2digits=61 if inlist(occ_code_prim,524,611,612,613)
		replace ilo_job1_ocu_isco08_2digits=62 if inlist(occ_code_prim,621,622,623)
		/*replace ilo_job1_ocu_isco08_2digits=63 if inlist(occ_code_prim,*/
		replace ilo_job1_ocu_isco08_2digits=71 if inlist(occ_code_prim,712,713,720)
		replace ilo_job1_ocu_isco08_2digits=72 if inlist(occ_code_prim,263,722)
		replace ilo_job1_ocu_isco08_2digits=73 if inlist(occ_code_prim,731,732,733,761)
		replace ilo_job1_ocu_isco08_2digits=74 if occ_code_prim==264
		replace ilo_job1_ocu_isco08_2digits=75 if inlist(occ_code_prim,734,735,751,799)
		replace ilo_job1_ocu_isco08_2digits=81 if inlist(occ_code_prim,711,741,811,812,813,814,815,816,817,899)
		replace ilo_job1_ocu_isco08_2digits=82 if occ_code_prim==821
		replace ilo_job1_ocu_isco08_2digits=83 if inlist(occ_code_prim,631,833,834,835,931)
		replace ilo_job1_ocu_isco08_2digits=91 if inlist(occ_code_prim,961,962)
		replace ilo_job1_ocu_isco08_2digits=92 if inlist(occ_code_prim,911,912,965)
		replace ilo_job1_ocu_isco08_2digits=93 if inlist(occ_code_prim,921,922,923,932,933)
		replace ilo_job1_ocu_isco08_2digits=94 if occ_code_prim==941
		replace ilo_job1_ocu_isco08_2digits=95 if occ_code_prim==951
		replace ilo_job1_ocu_isco08_2digits=96 if inlist(occ_code_prim,964,966,971,972,973,989)
				replace ilo_job1_ocu_isco08_2digits=. if ilo_lfs!=1
			lab def ocu_isco08_2digits_lab 1 "01 - Commissioned armed forces officers" 2 "02 - Non-commissioned armed forces officers" 3 "03 - Armed forces occupations, other ranks" /// 
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
		lab val ilo_job1_ocu_isco08_2digits ocu_isco08_2digits_lab
		lab var ilo_job1_ocu_isco08_2digits "Occupation (ISCO-08), 2 digit level"
			
	
		* Primary activity
		
		gen ilo_job1_ocu_isco08=int(ilo_job1_ocu_isco08_2digits/10) if ilo_lfs==1
			replace ilo_job1_ocu_isco08=10 if ilo_job1_ocu_isco08==0
			replace ilo_job1_ocu_isco08=11 if ilo_job1_ocu_isco08==. & ilo_lfs==1
			lab def isco08_1dig_lab 1 "1 - Managers" 2 "2 - Professionals" 3 "Technicians and associate professionals" 4 "4 - Clerical support workers" 5 "5 - Service and sales workers" ///
									6 "6 - Skilled agricultural, forestry and fishery workers" 7 "7 - Craft and related trades workers" 8 "8 - Plant and machine operators, and assemblers" ///
									9 "9 - Elementary occupations" 10 "0 - Armed forces occupations" 11 "X - Not elsewhere classified"
			lab val ilo_job1_ocu_isco08 isco08_1dig_lab
			lab var ilo_job1_ocu_isco08 "Occupation (ISCO-08)"
			
			
	* Aggregate level
	
		* Primary occupation
	
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
				lab var ilo_job1_ocu_aggregate "Occupation (Aggregate)"
				
		
	* Skill level
	
		* Primary occupation
	
		gen ilo_job1_ocu_skill=.
			replace ilo_job1_ocu_skill=1 if ilo_job1_ocu_isco08==9
			replace ilo_job1_ocu_skill=2 if inlist(ilo_job1_ocu_isco08,4,5,6,7,8)
			replace ilo_job1_ocu_skill=3 if inlist(ilo_job1_ocu_isco08,1,2,3)
			replace ilo_job1_ocu_skill=4 if inlist(ilo_job1_ocu_isco08,10,11)
				lab def ocu_skill_lab 1 "1 - Skill level 1 (low)" 2 "2 - Skill level 2 (medium)" 3 "3 - Skill levels 3 and 4 (high)" 4 "4 - Not elsewhere classified"
				lab val ilo_job1_ocu_skill ocu_skill_lab
				lab var ilo_job1_ocu_skill "Occupation (Skill level)"
			}	
				
	* Skill level (based on pre-defined variable from pre-processed dataset)
	
	else {
	
		* Primary occupation
	
		gen ilo_job1_ocu_skill=.
			replace ilo_job1_ocu_skill=1 if inlist(C_OCU11C,7,10)
			replace ilo_job1_ocu_skill=2 if inlist(C_OCU11C,4,5,6,8,9)
			replace ilo_job1_ocu_skill=3 if inlist(C_OCU11C,1,2,3)
			replace ilo_job1_ocu_skill=4 if ilo_job1_ocu_skill==. & ilo_lfs==1
					replace ilo_job1_ocu_skill=. if ilo_lfs!=1
				lab def ocu_skill_lab 1 "1 - Skill level 1 (low)" 2 "2 - Skill level 2 (medium)" 3 "3 - Skill levels 3 and 4 (high)" 4 "4 - Not elsewhere classified"
				lab val ilo_job1_ocu_skill ocu_skill_lab
				lab var ilo_job1_ocu_skill "Occupation (Skill level)"
					}
					
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_ins_sector') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
		
* Comment: TUE3
	
	gen ilo_job1_ins_sector=.
		replace ilo_job1_ins_sector=1 if P4D1==1 | (P4D1==2 & inlist(P4D2,1,2,3,6))
		replace ilo_job1_ins_sector=2 if ilo_job1_ins_sector==. & ilo_lfs==1
				replace ilo_job1_ins_sector=. if ilo_lfs!=1
			lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
			lab values ilo_job1_ins_sector ins_sector_lab
			lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities" 

* --------------------------------------------------------------------------------------------------
* --------------------------------------------------------------------------------------------------
*		Weekly hours actually (USUALLY) worked ('ilo_how_actual') and ('ilo_how_usual') [done]
* --------------------------------------------------------------------------------------------------
* --------------------------------------------------------------------------------------------------

* Comment: 

	* Actual hours worked 
		
		* Primary job
	
	if (quarter==1 & year>=2009) | (inlist(year,2007,2008) & quarter==2) | (year==2006 & inlist(quarter,1,2)) | year==2005 {
		egen ilo_job1_how_actual=rowtotal(P5C_HLU P5C_HMA P5C_HMI P5C_HJU P5C_HVI P5C_HSA P5C_HDO), m 
		}	
	
	if (year>=2009 & inlist(quarter,2,3,4)) | (inlist(year,2007,2008) & quarter!=2) | (year==2006 & inlist(quarter,3,4)) {
		egen ilo_job1_how_actual=rowtotal(P5B_HLU P5B_HMA P5B_HMI P5B_HJU P5B_HVI P5B_HSA P5B_HDO), m 
			}
			replace ilo_job1_how_actual=. if ilo_lfs!=1
			lab var ilo_job1_how_actual "Weekly hours actually worked in main job"
			
		* All jobs
		
		gen ilo_joball_how_actual=ilo_job1_how_actual
			replace ilo_joball_how_actual=168 if ilo_joball_how_actual>168 & ilo_joball_how_actual!=.
			replace ilo_joball_how_actual=. if ilo_lfs!=1
			lab var ilo_joball_how_actual "Weekly hours actually worked in all jobs"		
	
	* Hours usually worked
	
	if (quarter==1 & year>=2009) | (inlist(year,2007,2008) & quarter==2) | (year==2006 & inlist(quarter,1,2)) | year==2005 {
		egen ilo_job1_how_usual=rowtotal(P5E_HLU P5E_HMA P5E_HMI P5E_HJU P5E_HVI P5E_HSA P5E_HDO) if P5D!=1, m
			replace ilo_job1_how_usual=ilo_job1_how_actual if P5D==1
		}
	
	if (year>=2009 & inlist(quarter,2,3,4)) | (inlist(year,2007,2008) & quarter!=2) | (year==2006 & inlist(quarter,3,4)) {
		egen ilo_job1_how_usual=rowtotal(P5D_HLU P5D_HMA P5D_HMI P5D_HJU P5D_HVI P5D_HSA P5D_HDO) if P5C!=1, m
			replace ilo_job1_how_usual=ilo_job1_how_actual if P5C==1
			}
			replace ilo_job1_how_usual=. if ilo_lfs!=1
				lab var ilo_job1_how_usual "Weekly hours usually worked in main job"
			
		* All jobs
		
		gen ilo_joball_how_usual=ilo_job1_how_usual
			replace ilo_joball_how_usual=168 if ilo_joball_how_usual>168 & ilo_joball_how_usual!=.
			replace ilo_joball_how_usual=. if ilo_lfs!=1
			lab var ilo_joball_how_usual "Weekly hours usually worked in all jobs"		
	
	
	* Weekly hours actually worked --> bands --> Use actual hours worked in all jobs 
			
		* Main job
		
		gen ilo_job1_how_actual_bands=.
			replace ilo_job1_how_actual_bands=1 if ilo_job1_how_actual==0
			replace ilo_job1_how_actual_bands=2 if ilo_job1_how_actual>=1 & ilo_job1_how_actual<=14
			replace ilo_job1_how_actual_bands=3 if ilo_job1_how_actual>=15 & ilo_job1_how_actual<=29
			replace ilo_job1_how_actual_bands=4 if ilo_job1_how_actual>=30 & ilo_job1_how_actual<=34
			replace ilo_job1_how_actual_bands=5 if ilo_job1_how_actual>=35 & ilo_job1_how_actual<=39
			replace ilo_job1_how_actual_bands=6 if ilo_job1_how_actual>=40 & ilo_job1_how_actual<=48
			replace ilo_job1_how_actual_bands=7 if ilo_job1_how_actual>=49 & ilo_job1_how_actual!=.
			replace ilo_job1_how_actual_bands=8 if ilo_lfs==1 & ilo_job1_how_actual_bands==.
				lab def how_bands_lab 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"
				lab values ilo_job1_how_actual_bands how_bands_lab
				lab var ilo_job1_how_actual_bands "Weekly hours actually worked bands in main job"
		
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
				* value label already defined
				lab values ilo_joball_how_actual_bands how_bands_lab
				lab var ilo_joball_how_actual_bands "Weekly hours actually worked bands in all jobs"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment: legal maximum: 48 h per week, 8 h per day
			* reference used in technical document (reconstrucciÃ³n variables): 35 h per week

	gen ilo_job1_job_time=.
		replace ilo_job1_job_time=1 if ilo_job1_how_usual<=34 & ilo_job1_how_usual!=.
		replace ilo_job1_job_time=2 if ilo_job1_how_usual>=35 & ilo_job1_how_usual!=.
		replace ilo_job1_job_time=3 if ilo_job1_job_time==. & ilo_lfs==1
				replace ilo_job1_job_time=. if ilo_lfs!=1
			lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
			lab val ilo_job1_job_time job_time_lab
			lab var ilo_job1_job_time "Job (Working time arrangement)"	
			
			* if there is any secondary employment, by definition it is part-time, and therefore
			* variable for secondary employment not being defined
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job_contract') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment:

	if (quarter==1 & year>=2009) | (inlist(year,2007,2008) & quarter==2) | (year==2006 & inlist(quarter,1,2)) | year==2005 {
	
	gen ilo_job1_job_contract=.
		replace ilo_job1_job_contract=1 if P3K1==2
		replace ilo_job1_job_contract=2 if P3J==2 | inlist(P3K1,1,9) 
		replace ilo_job1_job_contract=3 if ilo_job1_ste_aggregate==1 & ilo_job1_job_contract==.
				replace ilo_job1_job_contract=. if ilo_job1_ste_aggregate!=1
						}
	
	if (year>=2009 & inlist(quarter,2,3,4)) | (inlist(year,2007,2008) & quarter!=2) | (year==2006 & inlist(quarter,3,4)) {

	gen ilo_job1_job_contract=.
		replace ilo_job1_job_contract=1 if P3J1==2
		replace ilo_job1_job_contract=2 if P3I==2 | inlist(P3J1,1,9) 
		replace ilo_job1_job_contract=3 if ilo_job1_ste_aggregate==1 & ilo_job1_job_contract==.
				replace ilo_job1_job_contract=. if ilo_job1_ste_aggregate!=1
				}
				
				
			lab def job_contract_lab 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"
			lab val ilo_job1_job_contract job_contract_lab
			lab var ilo_job1_job_contract "Job (Type of contract)"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Informal/Formal economy: Unit of production (ilo_job1_ife_prod) [don't define]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment:  predefined variable: TUE_PPAL (1 - Informal, 2 - Outside the informal sector --> household sector not being captured by this variable) (variable names taken from "cuestionario bÃ¡sico")

	* Useful questions: P4B and P4C and P4D1 and P4D2: Institutional sector --> to simplify: use already defined variable "ilo_job1_ins_sector" --> cannot be used to identify household sector
					*	P3C4: Destination of production (option identifying whether own consumption or not) --> to consider some observations as "household sector"
					*	P4G: Bookkeeping (not asked to everyone! filter question: P4E)
					*	[no question]: Registration
					*	P4E and P4F: Location of workplace
					* 	P3L: Size of the establishment
					*	P6D : Social security (medical assistance)
						*	[no question]: Pension fund
						*	P3K2: Paid annual leave
						*	[no question]: Paid sick leave
						
		
		/* Given the numerous filter questions contained by the questionnaire, the definition that we normally use cannot be followed, and therefore 
			the â€œilo_ifeâ€ variables are not being defined. The main issues are related to the following questions:
				* Question 4b â€“ whatever is considered as â€œactividad agropecuariaâ€ (â€œagricultural and livestock activityâ€) is directly being sent to question 5, meaning that no
					other question on the nature of the economic unit is being asked. 
				* Question 4e â€“ all observations associated with the 1st option (i.e. â€œcuenta con establecimiento y oficinaâ€ â€“ â€œhas an establishment and an officeâ€)
					is also not being asked about bookkeeping, which, together with the abovementioned filter question, excludes an important amount of observations from the question 4g on bookkeeping.
					The latter being one of our most important criteria to classify observations in the formal resp. informal sector, together with a question on registration 
					(that does not exist in this questionnaire), our variables cannot be properly defined and therefore are being omitted from this dataset.
					*/

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Informal/formal economy: nature of job (ilo_job1_ife_nature) [don't define]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	* variable not being defined (cf. comment for ilo_job1_ife_prod)

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Earnings ('ilo_ear_ees' and 'ilo_ear_slf') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	
* Comment: predefined variable "Ingreso mensual" being used --> referring to main job (cf. structure of original questionnaire
				* --> variable "INGOCUP" based on question p6b2 from questionnaire)

	*Currency in Mexico: Mexican peso

	* Primary employment 
	
			* Monthly earnings of employees
	
		gen ilo_job1_lri_ees=INGOCUP if ilo_job1_ste_aggregate==1
			replace ilo_job1_lri_ees=. if ilo_lfs!=1 | ilo_job1_lri_ees<0 | ilo_job1_ste_aggregate!=1
			lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"
	
			* Self employment
	
				* Note that the revenue related to self-employment includes also the value of own consumption (cf. resolution from 1998)
			
		gen ilo_job1_lri_slf=INGOCUP if ilo_job1_ste_aggregate==2
			replace ilo_job1_lri_slf=. if ilo_lfs!=1 | ilo_job1_ste_aggregate!=2
			lab var ilo_job1_lri_slf "Monthly labour related income of self-employed in main job"
		

***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_tru') [can't be defined]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
           
* Comment: original variables not available and predefined variable does not correspond to our criteria
			* --> variable can't be defined
				
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Cases of non-fatal occupational injury ('ilo_joball_oi_case') [no info]
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*
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
*			Duration of unemployment ('ilo_dur') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: questions asks for how long person has been seeking a job --> take pre-defined variable (based on questions 2A and 2B)


	* keep for the moment pre-defined variable that is almost perfectly aligned with our classification --> check with Yves whether original variables
	* should be taken to calculate the variable, in order to be able to define also option 6 (for which we do not have observations in this moment)


	gen ilo_dur_details=.
		replace ilo_dur_details=1 if DUR_DES==1
		replace ilo_dur_details=2 if DUR_DES==2
		replace ilo_dur_details=3 if DUR_DES==3
		replace ilo_dur_details=4 if DUR_DES==4
		replace ilo_dur_details=5 if DUR_DES==5
		/* replace ilo_dur_details=6 if */
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
		replace ilo_dur_aggregate=4 if ilo_dur_aggregate==. & ilo_lfs==2
				replace ilo_dur_aggregate=. if ilo_lfs!=2
				
			lab def ilo_unemp_aggr 1 "Less than 6 months" 2 "6 months to less than 12 months" 3 "12 months or more" 4 "Not elsewhere classified"
			lab val ilo_dur_aggregate ilo_unemp_aggr
			lab var ilo_dur_aggregate "Duration of unemployment (Aggregate)"				

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Category of unemployment ('ilo_cat_une') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: 
	
	gen ilo_cat_une=.
		replace ilo_cat_une=1 if P2H1==1 | P2H2==2 | P2H3==3
		replace ilo_cat_une=2 if P2H4==4
		replace ilo_cat_une=3 if ilo_cat_une==. & ilo_lfs==2
				replace ilo_cat_une=. if ilo_lfs!=2
			lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
			lab val ilo_cat_une cat_une_lab
			lab var ilo_cat_une "Category of unemployment"
							
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4') [variable not included]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: 


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu_isco08') [variable not included]
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
*			Degree of labour market attachment ('ilo_olf_dlma') [can't be defined]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: people not seeking a job are not being asked about their availability --> don't define this variable

	
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reasons for not seeking a job or being outside the labour market ('ilo_olf_reason')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: 

	gen ilo_olf_reason=.
		replace ilo_olf_reason=1 if inlist(P2G2,2,3,4,5,6)
		replace ilo_olf_reason=2 if P2E==1 | inlist(P2G2,1,11)
		replace ilo_olf_reason=3 if inlist(P2E,3,4,5) | inlist(P2G2,7,8,9,10,12)
		replace ilo_olf_reason=4 if P2E==2
		replace ilo_olf_reason=5 if ilo_olf_reason==. & ilo_lfs==3
			replace ilo_olf_reason=. if ilo_lfs!=3
			lab def lab_olf_reason 1 "1 - Labour market (discouraged)" 2 "2 - Other labour market reasons" 3 "3 - Personal/Family-related"  4 "4 - Does not need/want to work" 5 "5 - Not elsewhere classified"
			lab val ilo_olf_reason lab_olf_reason
			lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seekers ('ilo_dis') 
* -------------------------------------------------------------------------------------------
* ------------------------------------------------------------------------------------------- 

* Comment: when considering skip pattern in the questionnaire, it is visible that nobody answering to question 2G answers "yes" to question 2C (availability criterion 
			* used above) --> given that the variable cannot be reconstructed following our criteria, do not define it

			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training (NEETs) ('ilo_neet') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

		gen ilo_neet=.
			replace ilo_neet=1 if inrange(ilo_age,15,24) & ilo_lfs!=1 & inlist(ilo_edu_attendance,2,3)
				lab def ilo_neet_lab 1 "Youth not in education, employment or training"
				lab val ilo_neet ilo_neet_lab
				lab var ilo_neet "Youth not in education, employment or training" 						
			

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

*			SAVE RESULTS

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* -------------------------------------------------------------
* 1.	Prepare final datasets
* -------------------------------------------------------------

* set as missing all observations that correspond to not_considered==1

	foreach var of varlist ilo_* {
	
	replace `var'=. if considered!=1
	
	}

cd "$outpath"

		drop educ_years year quarter
	
		compress 
		
		order ilo* , last
		
		drop if ilo_wgt==.
				   
	* Save dataset including original and ilo variables
	
		save ${country}_${source}_${time}_FULL, replace		
	
	* Save file only containing ilo_* variables
	
		keep ilo*

		save ${country}_${source}_${time}_ILO,  replace
		
