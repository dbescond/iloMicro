* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Congo DRC, 2004/2005
* DATASET USED: Democratic Republic of Congo - ENESI - 2004/2005
* NOTES:
* Authors: ILO / Department of Statistics / DPAU

* Starting Date: 28 February 2018
* Last updated: 28 February 2018
***********************************************************************************************


***********************************************************************************************
***********************************************************************************************

* 			1. SET UP WORK DIRECTORY, FILE NAME, VARIABLES AND FUNCTIONS

***********************************************************************************************
***********************************************************************************************

clear all 

set more off

global path "J:\DPAU\MICRO"
global country "COD"
global source "ENESI"
global time "2005"
global input_file "COD_ENESI_2005"

global inpath "${path}\\${country}\\${source}\\${time}\ORI"
global temppath "${path}\_Admin"
global outpath "${path}\\${country}\\${source}\\${time}"

			
*********************************************************************************************

* Load original dataset

*********************************************************************************************

cd "$inpath"
	use "${input_file}", clear
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

	gen ilo_wgt= ponder3
		lab var ilo_wgt "Sample weight"		

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time period ('ilo_time')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_time=1
		lab def lab_time 1 "2005" 
		lab val ilo_time lab_time
		lab var ilo_time "Time (Gregorian Calendar)"
		

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

	gen ilo_geo=.
		replace ilo_geo=1 if milieu==1
		replace ilo_geo=2 if (milieu==2 | milieu==3)
			lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural"
			lab val ilo_geo ilo_geo_lab
			lab var ilo_geo "Geographical coverage"	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_sex=m3
		lab def ilo_sex_lab 1 "1 - Male" 2 "2 - Female"
		lab var ilo_sex "Sex"
		lab val ilo_sex ilo_sex_lab

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_age=m4_age
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
		
/* ISCED 11 mapping: based on the mapping developped by UNESCO
					http://www.uis.unesco.org/Education/ISCEDMappings/Pages/default.aspx
					http://www.uis.unesco.org/Education/Documents/isced-2011-en.pdf 	*/

* Note that according to the definition, the highest level CONCLUDED is considered.

	gen ilo_edu_isced11=.
		replace ilo_edu_isced11=1 if m13a_ecp==2			// No schooling
		replace ilo_edu_isced11=1 if m13d_dip==0			// No schooling
		* replace ilo_edu_isced11=2 if					  	// Early childhood education
		replace ilo_edu_isced11=3 if m13d_dip==1		  	// Primary education
		replace ilo_edu_isced11=4 if m13d_dip==2 			// Lower secondary education
		replace ilo_edu_isced11=5 if inlist(m13d_dip,3,4,5)	// Upper secondary education
		* replace ilo_edu_isced11=6 if 						// Post-secondary non-tertiary
		* replace ilo_edu_isced11=7 if 						// Short-cycle tertiary education
		replace ilo_edu_isced11=8 if inlist(m13d_dip,6,7)	// Bachelor or equivalent
		* replace ilo_edu_isced11=9 if      				// Master's or equivalent level
		replace ilo_edu_isced11=10 if m13d_dip==8  			// Doctoral or equivalent level
		replace ilo_edu_isced11=11 if m13d_dip==9			// Not elsewhere classified
		replace ilo_edu_isced11=11 if ilo_edu_isced11==.	// Not elsewhere classified
			label def isced_11_lab 1 "X - No schooling" 2 "0 - Early childhood education" 3 "1 - Primary education" 4 "2 - Lower secondary education" ///
							5 "3 - Upper secondary education" 6 "4 - Post-secondary non-tertiary education" 7 "5 - Short-cycle tertiary education" ///
							8 "6 - Bachelor's or equivalent level" 9 "7 - Master's or equivalent level" 10 "8 - Doctoral or equivalent level" 11 "9 - Not elsewhere classified"
			label val ilo_edu_isced11 isced_11_lab
			lab var ilo_edu_isced11 "Education (ISCED 11)"

	gen ilo_edu_aggregate=.
		replace ilo_edu_aggregate=1 if inlist(ilo_edu_isced11,1,2)  	// Less than basic
		replace ilo_edu_aggregate=2 if inlist(ilo_edu_isced11,3,4)		// Basic
		replace ilo_edu_aggregate=3 if inlist(ilo_edu_isced11,5,6)		// Intermediate
		replace ilo_edu_aggregate=4 if inrange(ilo_edu_isced11,7,10)	// Advanced
		replace ilo_edu_aggregate=5 if ilo_edu_isced11==11				// Level not stated
			label def edu_aggr_lab 1 "1 - Less than basic" 2 "2 - Basic" 3 "3 - Intermediate" 4 "4 - Advanced" 5 "5 - Level not stated"
			label val ilo_edu_aggregate edu_aggr_lab
			label var ilo_edu_aggregate "Education (Aggregate levels)"
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education attendance ('ilo_edu_attendance')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_edu_attendance=.
		replace ilo_edu_attendance=1 if (m16_eca==1)					// Attending
		replace ilo_edu_attendance=2 if (m16_eca==2 | m13a_ecp==2)		// Not attending
		replace ilo_edu_attendance=3 if (ilo_edu_attendance==.) 		// Not elsewhere classified
			label def edu_att_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
			label val ilo_edu_attendance edu_att_lab
			label var ilo_edu_attendance "Education (Attendance)"
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Disability status ('ilo_dsb')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
				
* Comment : No information
		


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
		replace ilo_wap=1 if (ilo_age>=15 & ilo_age!=.)
			lab def wap_lab 1 "Working age population"
			lab val ilo_wap wap_lab
			label var ilo_wap "Working age population"

	drop ilo_age

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Labour Force Status ('ilo_lfs')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
		  
	gen ilo_lfs=.
		replace ilo_lfs=1 if (ea2_empl==1 | inrange(ea3_aut,1,9) | ea4_empl==1) & ilo_wap==1				// Employment
		replace ilo_lfs=2 if (ilo_wap==1 & ilo_lfs!=1 & (ea7_rsm==1 | ea7b_rmm==1) & inlist(ea7c_dis,1,2))	// Unemployment
		replace ilo_lfs=3 if (ilo_lfs!=1 & ilo_lfs!=2 & ilo_wap==1)  										// Outside the labour force
				label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside the Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_mjh=.
		replace ilo_mjh=1 if (as1_act==2 & ilo_lfs==1)
		replace ilo_mjh=2 if (as1_act==1 & ilo_lfs==1)
		replace ilo_mjh=1 if (ilo_mjh==. & ilo_lfs==1)
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

  * MAIN JOB
	
	* Detailed categories
	
		gen ilo_job1_ste_icse93=.
			replace ilo_job1_ste_icse93=1 if (inlist(ap3_cat,0,1,2,3,4,5,8) & ilo_lfs==1)	// Employees
			replace ilo_job1_ste_icse93=2 if (ap3_cat==6 & ilo_lfs==1)						// Employers
			replace ilo_job1_ste_icse93=3 if (ap3_cat==7 & ilo_lfs==1)						// Own-account workers
			* replace ilo_job1_ste_icse93=4 if 												// Members of producers cooperatives
			replace ilo_job1_ste_icse93=5 if (ap3_cat==9 & ilo_lfs==1)						// Contributing family workers
			replace ilo_job1_ste_icse93=6 if (ilo_job1_ste_icse93==. & ilo_lfs==1)			// Not classifiable
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

				
  * SECOND JOB
	
	* Detailed categories
	
		gen ilo_job2_ste_icse93=.
			replace ilo_job2_ste_icse93=1 if (inlist(as4_cat,0,1,2,3,4,5,8) & ilo_mjh==2)	// Employees
			replace ilo_job2_ste_icse93=2 if (as4_cat==6 & ilo_mjh==2)						// Employers
			replace ilo_job2_ste_icse93=3 if (as4_cat==7 & ilo_mjh==2)						// Own-account workers
			* replace ilo_job2_ste_icse93=4 if 												// Members of producers cooperatives
			replace ilo_job2_ste_icse93=5 if (as4_cat==9 & ilo_mjh==2)						// Contributing family workers
			replace ilo_job2_ste_icse93=6 if (ilo_job2_ste_icse93==. & ilo_mjh==2)  		// Not classifiable
				label val ilo_job2_ste_icse93 label_ilo_ste_icse93
				label var ilo_job2_ste_icse93 "Status in employment (ICSE 93)- second job"

	* Aggregate categories 
		
		gen ilo_job2_ste_aggregate=.
			replace ilo_job2_ste_aggregate=1 if ilo_job2_ste_icse93==1				// Employees
			replace ilo_job2_ste_aggregate=2 if inrange(ilo_job2_ste_icse93,2,5)	// Self-employed
			replace ilo_job2_ste_aggregate=3 if ilo_job2_ste_icse93==6				// Not elsewhere classified
				lab val ilo_job2_ste_aggregate ste_aggr_lab
				label var ilo_job2_ste_aggregate "Status in employment (Aggregate) - second job"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

  * MAIN JOB
   	gen occ_code_prim=int(ap2_bran/100) if ilo_lfs==1

	* 2-digit level
	gen ilo_job1_eco_isic3_2digits=occ_code_prim
	    replace ilo_job1_eco_isic3_2digits=. if ilo_lfs!=1
			    lab def eco_isic3_2digits 1 "01 - Agriculture, hunting and related service activities"	2 "02 - Forestry, logging and related service activities"	5 "05 - Fishing, operation of fish hatcheries and fish farms; service activities incidental to fishing"	10 "10 - Mining of coal and lignite; extraction of peat"	///
                                          11 "11 - Extraction of crude petroleum and natural gas; service activities incidental to oil and gas extraction excluding surveying"	12 "12 - Mining of uranium and thorium ores"	13 "13 - Mining of metal ores"	14 "14 - Other mining and quarrying"	///
                                          15 "15 - Manufacture of food products and beverages"	16 "16 - Manufacture of tobacco products"	17 "17 - Manufacture of textiles"	18 "18 - Manufacture of wearing apparel; dressing and dyeing of fur"	///
                                          19 "19 - Tanning and dressing of leather; manufacture of luggage, handbags, saddlery, harness and footwear"	20 "20 - Manufacture of wood and of products of wood and cork, except furniture; manufacture of articles of straw and plaiting materials"	21 "21 - Manufacture of paper and paper products"	22 "22 - Publishing, printing and reproduction of recorded media"	///
                                          23 "23 - Manufacture of coke, refined petroleum products and nuclear fuel"	24 "24 - Manufacture of chemicals and chemical products"	25 "25 - Manufacture of rubber and plastics products"	26 "26 - Manufacture of other non-metallic mineral products"	///
                                          27 "27 - Manufacture of basic metals"	28 "28 - Manufacture of fabricated metal products, except machinery and equipment"	29 "29 - Manufacture of machinery and equipment n.e.c."	30 "30 - Manufacture of office, accounting and computing machinery"	///
                                          31 "31 - Manufacture of electrical machinery and apparatus n.e.c."	32 "32 - Manufacture of radio, television and communication equipment and apparatus"	33 "33 - Manufacture of medical, precision and optical instruments, watches and clocks"	34 "34 - Manufacture of motor vehicles, trailers and semi-trailers"	///
                                          35 "35 - Manufacture of other transport equipment"	36 "36 - Manufacture of furniture; manufacturing n.e.c."	37 "37 - Recycling"	40 "40 - Electricity, gas, steam and hot water supply"	///
                                          41 "41 - Collection, purification and distribution of water"	45 "45 - Construction"	50 "50 - Sale, maintenance and repair of motor vehicles and motorcycles; retail sale of automotive fuel"	51 "51 - Wholesale trade and commission trade, except of motor vehicles and motorcycles"	///
                                          52 "52 - Retail trade, except of motor vehicles and motorcycles; repair of personal and household goods"	55 "55 - Hotels and restaurants"	60 "60 - Land transport; transport via pipelines"	61 "61 - Water transport"	///
                                          62 "62 - Air transport"	63 "63 - Supporting and auxiliary transport activities; activities of travel agencies"	64 "64 - Post and telecommunications"	65 "65 - Financial intermediation, except insurance and pension funding"	///
                                          66 "66 - Insurance and pension funding, except compulsory social security"	67 "67 - Activities auxiliary to financial intermediation"	70 "70 - Real estate activities"	71 "71 - Renting of machinery and equipment without operator and of personal and household goods"	///
                                          72 "72 - Computer and related activities"	73 "73 - Research and development"	74 "74 - Other business activities"	75 "75 - Public administration and defence; compulsory social security"	///
                                          80 "80 - Education"	85 "85 - Health and social work"	90 "90 - Sewage and refuse disposal, sanitation and similar activities"	91 "91 - Activities of membership organizations n.e.c."	///
                                          92 "92 - Recreational, cultural and sporting activities"	93 "93 - Other service activities"	95 "95 - Activities of private households as employers of domestic staff"	96 "96 - Undifferentiated goods-producing activities of private households for own use"	///
                                          97 "97 - Undifferentiated service-producing activities of private households for own use"	99 "99 - Extra-territorial organizations and bodies"			
                lab val ilo_job1_eco_isic3_2digits eco_isic3_2digits
                lab var ilo_job1_eco_isic3_2digits "Economic activity (ISIC Rev. 3.1), 2 digits level - main job"
	
	* 1-digit level	
    gen ilo_job1_eco_isic3=.
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

	gen indu_code_sec=int(as3_bran/100) if ilo_lfs==1
	
	* 2-digit level
	gen ilo_job2_eco_isic3_2digits=indu_code_sec
	    replace ilo_job2_eco_isic3_2digits=. if ilo_mjh!=2
                * labels already defined for main job
		        lab val ilo_job2_eco_isic3_2digits eco_isic3_2digits
                lab var ilo_job2_eco_isic3_2digits "Economic activity (ISIC Rev. 3.1), 2 digits level - second job"

	* 1-digit level	
    gen ilo_job2_eco_isic3=.
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
		replace ilo_job2_eco_isic3=18 if ilo_job2_eco_isic3==. & ilo_mjh==2
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

			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_job1_ocu_isco08')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

  * MAIN JOB:
   	gen indu_code_prim=int(ap1_nom/10) if ilo_lfs==1

	* 2-digit level 
    gen ilo_job1_ocu_isco88_2digits=indu_code_prim
		replace ilo_job1_ocu_isco88_2digits=. if ilo_lfs!=1
		        lab def ocu_isco88_2digits 1 "01 - Armed forces"	11 "11 - Legislators and senior officials"	12 "12 - Corporate managers"	13 "13 - General managers"	///
                                           21 "21 - Physical, mathematical and engineering science professionals"	22 "22 - Life science and health professionals"	23 "23 - Teaching professionals"	24 "24 - Other professionals"	///
                                           31 "31 - Physical and engineering science associate professionals"	32 "32 - Life science and health associate professionals"	33 "33 - Teaching associate professionals"	34 "34 - Other associate professionals"	///
                                           41 "41 - Office clerks"	42 "42 - Customer services clerks"	51 "51 - Personal and protective services workers"	52 "52 - Models, salespersons and demonstrators"	///
                                           61 "61 - Skilled agricultural and fishery workers"	62 "62 - Subsistence agricultural and fishery workers"	71 "71 - Extraction and building trades workers"	72 "72 - Metal, machinery and related trades workers"	///
                                           73 "73 - Precision, handicraft, craft printing and related trades workers"	74 "74 - Other craft and related trades workers"	81 "81 - Stationary plant and related operators"	82 "82 - Machine operators and assemblers"	///
                                           83 "83 - Drivers and mobile plant operators"	91 "91 - Sales and services elementary occupations"	92 "92 - Agricultural, fishery and related labourers"	93 "93 - Labourers in mining, construction, manufacturing and transport"	
	            lab values ilo_job1_ocu_isco88_2digits ocu_isco88_2digits
	            lab var ilo_job1_ocu_isco88_2digits "Occupation (ISCO-88), 2 digit level - main job"
	
    * 1-digit level
	gen ilo_job1_ocu_isco88=.
	    replace ilo_job1_ocu_isco88=11 if inlist(ilo_job1_ocu_isco88_2digits,.) & ilo_lfs==1                         // Not elsewhere classified
		replace ilo_job1_ocu_isco88=int(ilo_job1_ocu_isco88_2digits/10) if (ilo_job1_ocu_isco88==. & ilo_lfs==1)     // The rest of the occupations
		replace ilo_job1_ocu_isco88=10 if (ilo_job1_ocu_isco88==0 & ilo_lfs==1)                                      // Armed forces
		        lab def ocu_isco88_1digit 1 "1 - Legislators, senior officials and managers"	2 "2 - Professionals"	3 "3 - Technicians and associate professionals"	4 "4 - Clerks"	///
                                          5 "5 - Service workers and shop and market sales workers"	6 "6 - Skilled agricultural and fishery workers"	7 "7 - Craft and related trades workers"	8 "8 - Plant and machine operators and assemblers"	///
                                          9 "9 - Elementary occupations"	10 "0 - Armed forces"	11 "11 - Not elsewhere classified"		
				lab val ilo_job1_ocu_isco88 ocu_isco88_1digit
				lab var ilo_job1_ocu_isco88 "Occupation (ISCO-88) - main job"
				
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
	

  * SECOND JOB:
    	gen occ_code_sec=int(as2_prof/100) if (ilo_lfs==1 & ilo_mjh==2)
	 
  * ISCO 08 - 1 digit:
	gen ilo_job2_ocu_isco08=.
	    replace ilo_job2_ocu_isco08=11 if (occ_code_sec==. & ilo_lfs==1 & ilo_mjh==2)      				// Not elsewhere classified
		replace ilo_job2_ocu_isco08=occ_code_sec if (ilo_job2_ocu_isco08==. & ilo_lfs==1 & ilo_mjh==2)  // The rest of the occupations
		replace ilo_job2_ocu_isco08=10 if (ilo_job2_ocu_isco08==0 & ilo_lfs==1 & ilo_mjh==2)       		// Armed forces	
				lab val ilo_job2_ocu_isco08 ocu_isco08
				lab var ilo_job2_ocu_isco08 "Occupation (ISCO-08) - second job"
	
  * Aggregate
	gen ilo_job2_ocu_aggregate=.
	    replace ilo_job2_ocu_aggregate=1 if inrange(ilo_job2_ocu_isco08,1,3)   
		replace ilo_job2_ocu_aggregate=2 if inlist(ilo_job2_ocu_isco08,4,5)
		replace ilo_job2_ocu_aggregate=3 if inlist(ilo_job2_ocu_isco08,6,7)
		replace ilo_job2_ocu_aggregate=4 if ilo_job2_ocu_isco08==8
		replace ilo_job2_ocu_aggregate=5 if ilo_job2_ocu_isco08==9
		replace ilo_job2_ocu_aggregate=6 if ilo_job2_ocu_isco08==10
		replace ilo_job2_ocu_aggregate=7 if ilo_job2_ocu_isco08==11
				lab val ilo_job2_ocu_aggregate ocu_aggr_lab
				lab var ilo_job2_ocu_aggregate "Occupation (Aggregate) - second job"	
		
  * Skill level
	gen ilo_job2_ocu_skill=.
	    replace ilo_job2_ocu_skill=1 if ilo_job2_ocu_isco08==9                  // Low
		replace ilo_job2_ocu_skill=2 if inlist(ilo_job2_ocu_isco08,4,5,6,7,8)   // Medium
		replace ilo_job2_ocu_skill=3 if inlist(ilo_job2_ocu_isco08,1,2,3)       // High
		replace ilo_job2_ocu_skill=4 if inlist(ilo_job2_ocu_isco08,10,11)       // Not elsewhere classified
			    lab val ilo_job2_ocu_skill ocu_skill_lab
			    lab var ilo_job2_ocu_skill "Occupation (Skill level) - second job"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_job1_ins_sector')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
	
		gen ilo_job1_ins_sector=.
			replace ilo_job1_ins_sector=1 if (inlist(ap4_ent,1,2) & ilo_lfs==1)		// Public
			replace ilo_job1_ins_sector=2 if (inlist(ap4_ent,3,4,5) & ilo_lfs==1)	// Private
			replace ilo_job1_ins_sector=2 if (ilo_job1_ins_sector==. & ilo_lfs==1)	// Private
				lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private" 
				lab values ilo_job1_ins_sector ins_sector_lab
				lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job1_job_time')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			

	* Threshold of 40 hours per week

		gen ilo_job1_job_time=.
			replace ilo_job1_job_time=1 if (ap11_hh<40 & ilo_lfs==1)			// Part-time
			replace ilo_job1_job_time=2 if (ap11_hh>=40 & ap11_hh!=. & ilo_lfs==1)	// Full-time
			replace ilo_job1_job_time=3 if (ilo_job1_job_time==. & ilo_lfs==1)	// Unknown
				lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
				lab val ilo_job1_job_time job_time_lab
				lab var ilo_job1_job_time "Job (Working time arrangement) - Main job"
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job1_job_contract')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
		
		gen ilo_job1_job_contract=.
			replace ilo_job1_job_contract=1 if (ap8e_ctr==1 & ilo_lfs==1)
			replace ilo_job1_job_contract=2 if (ap8e_ctr==2 & ilo_lfs==1)
			replace ilo_job1_job_contract=3 if (inlist(ap8e,3,4) & ilo_lfs==1)
			replace ilo_job1_job_contract=3 if (ilo_job1_job_contract==. & ilo_lfs==1)
				lab def job_contract_lab 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"
				lab val ilo_job1_job_contract job_contract_lab
				lab var ilo_job1_job_contract "Job (Type of contract)"
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Formal / Informal Economy ('ilo_job1_ife_prod' 'ilo_job1_ife_nature') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
		
	/* Useful questions:
				* ap3_cat - Statut
				* ap4_ent - Secteur Institutionnel
				* ap5_nbre - Taille
				* ap6_rc / ap6_inss / ap6_cont - Enregistrement
				* ap7_loca - Lieu de travail
				* ap8c1_ct - Comptabilite
				* ap16a_re - Pension
				* ap16e_co - Conges payes
				* ap16f_sm - Service medical particulier	*/

	* 1) Unit of production - Formal / Informal Sector
	
		/* Generate a variable to indicate the social security coverage (to be dropped afterwards) */

			gen social_security=.
				
				replace social_security=1 if (ap16a_re==1 & ilo_lfs==1)
	
			gen ilo_job1_ife_prod=.
				
				replace ilo_job1_ife_prod=2 if (inlist(ap4_ent,1,2) | ap8c1_ct==1 | ap6_rc==1 | ap6_inss==1 | ap6_cont==1) & ilo_lfs==1
				
				replace ilo_job1_ife_prod=3 if (ap4_ent==5 & ilo_lfs==1) | (ilo_job1_eco_isic3_2digits==95 | ilo_job1_ocu_isco88_2digits==62) 
				
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
*			Hours of work ('ilo_job1_how')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
		
* Main job
		
* 1) Weekly hours ACTUALLY worked
		
			gen ilo_job1_how_actual=ap11_hh if (ilo_lfs==1)
				replace ilo_job1_how_actual=168 if (ilo_job1_how_actual>=168 & ilo_job1_how_actual!=. & ilo_lfs==1)
				replace ilo_job1_how_actual=0 if (ap11_hh==. & ilo_lfs==1)
					lab var ilo_job1_how_actual "Weekly hours actually worked in main job"

			gen ilo_job1_how_actual_bands=.
				replace ilo_job1_how_actual_bands=1 if ilo_job1_how_actual==0
				replace ilo_job1_how_actual_bands=2 if inrange(ilo_job1_how_actual,1,14)
				replace ilo_job1_how_actual_bands=3 if inrange(ilo_job1_how_actual,15,29)
				replace ilo_job1_how_actual_bands=4 if inrange(ilo_job1_how_actual,30,34)
				replace ilo_job1_how_actual_bands=5 if inrange(ilo_job1_how_actual,35,39)
				replace ilo_job1_how_actual_bands=6 if inrange(ilo_job1_how_actual,40,48)
				replace ilo_job1_how_actual_bands=7 if ilo_job1_how_actual>=49 & ilo_job1_how_actual!=.
					lab def how_bands_lab 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 
					lab val ilo_job1_how_actual_bands how_bands_lab
					lab var ilo_job1_how_actual_bands "Weekly hours actually worked bands in main job"

* 2) Weekly hours USUALLY worked - Not available


* Second job

* 1) Weekly hours ACTUALLY worked

			gen ilo_job2_how_actual=as9_hh if (ilo_lfs==1 & ilo_mjh==2)
				replace ilo_job2_how_actual=168 if (ilo_job2_how_actual>=168 & ilo_job2_how_actual!=. & ilo_lfs==1 & ilo_mjh==2)
				replace ilo_job2_how_actual=0 if (as9_hh==. & ilo_lfs==1 & ilo_mjh==2)
					lab var ilo_job2_how_actual "Weekly hours actually worked in second job"

			gen ilo_job2_how_actual_bands=.
				replace ilo_job2_how_actual_bands=1 if ilo_job2_how_actual==0
				replace ilo_job2_how_actual_bands=2 if inrange(ilo_job2_how_actual,1,14)
				replace ilo_job2_how_actual_bands=3 if inrange(ilo_job2_how_actual,15,29)
				replace ilo_job2_how_actual_bands=4 if inrange(ilo_job2_how_actual,30,34)
				replace ilo_job2_how_actual_bands=5 if inrange(ilo_job2_how_actual,35,39)
				replace ilo_job2_how_actual_bands=6 if inrange(ilo_job2_how_actual,40,48)
				replace ilo_job2_how_actual_bands=7 if ilo_job2_how_actual>=49 & ilo_job2_how_actual!=.
				replace ilo_job2_how_actual_bands=8 if ilo_job2_how_actual==. & ilo_mjh==2
				replace ilo_job2_how_actual_bands=. if ilo_mjh!=2
					lab val ilo_job2_how_actual_bands how_bands_lab
					lab var ilo_job2_how_actual_bands "Weekly hours actually worked bands in second job"
				
* 2) Weekly hours USUALLY worked - Not available


* All jobs
		
* 1) Weekly hours ACTUALLY worked - Not available as we only have main job

			gen ilo_joball_how_actual=(ilo_job1_how_actual + ilo_job2_how_actual) if (ilo_lfs==1 & ilo_mjh==2)
				replace ilo_joball_how_actual=ilo_job1_how_actual if (ilo_lfs==1 & ilo_mjh!=2)
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

* 2) Weekly hours USUALLY worked - Not available
				

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Monthly labour related income ('ilo_joball_lri')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			

* Main job

	* Employees
			
			gen ilo_job1_lri_ees=ap13a_mt if ilo_job1_ste_aggregate==1
					lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"

	* Self-employed
		
			gen ilo_job1_lri_slf=ap13a_mt if ilo_job1_ste_aggregate==2
					lab var ilo_job1_lri_slf "Monthly labour related income of self-employed in main job"	

* All jobs job
			
	* Employees
			
			gen ilo_joball_lri_ees=(ap13a_mt+as10a_sl) if (ilo_job1_ste_aggregate==1 & ilo_mjh==2 & ap13a_mt!=. & as10a_sl!=.)
				replace ilo_joball_lri_ees=ap13a_mt if (ilo_job1_ste_aggregate==1 & ilo_mjh!=2 & ap13a_mt!=.)
					lab var ilo_joball_lri_ees "Monthly earnings of employees in all jobs"

	* Self-employed
		
			gen ilo_joball_lri_slf=(ap13a_mt+as10a_sl) if (ilo_job1_ste_aggregate==2 & ilo_mjh==2 & ap13a_mt!=. & as10a_sl!=.)
				replace ilo_joball_lri_slf=ap13a_mt if (ilo_job1_ste_aggregate==2 & ilo_mjh!=2 & ap13a_mt!=.)
					lab var ilo_joball_lri_slf "Monthly labour related income of self-employed in all jobs"	
						
		
***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_joball_tru')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			

* Comment: Not enough information to compute	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupational injury ('ilo_joball_inj')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
		
* No information available
		
		

***********************************************************************************************
*			PART 3.3. UNEMPLOYMENT: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Category of unemployment ('ilo_cat_une')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	
* No information available
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* No information available

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* No information available

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

* No information available
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			General social protection ('ilo_gsp_unschemes')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* No information available

	
	
***********************************************************************************************
*			PART 3.4. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

	gen ilo_olf_dlma=.
		replace ilo_olf_dlma = 1 if ((ea7_rsm==1 | ea7b_rmm==1) & inlist(ea7c_dis,3,4) & ilo_lfs==3)	// Seeking, not available
		replace ilo_olf_dlma = 2 if	(ea7_rsm!=1 & ea7b_rmm!=1 & ea8b2_im==1 & ilo_lfs==3)				// Not seeking, available
		* replace ilo_olf_dlma = 3 if 																	// Not seeking, not available, willing
		* replace ilo_olf_dlma = 4 if 																	// Not seeking, not available, not willing
		replace ilo_olf_dlma = 5 if	(ilo_olf_dlma==. & ilo_lfs==3)										// Not classified 
	
			lab def dlma_lab 1 "1 - Seeking, not available (Unavailable jobseekers)" 2 "2 - Not seeking, available (Available potential jobseekers)" ///
							 3 "3 - Not seeking, not available, willing (Willing non-jobseekers)" 4 "4 - Not seeking, not available, not willing" 5 "X - Not elsewhere classified"
			lab val ilo_olf_dlma dlma_lab 
			lab var ilo_olf_dlma "Labour market attachment (Degree of)"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reason for not seeking job ('ilo_olf_reason')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

	gen ilo_olf_reason=.
		replace ilo_olf_reason=1 if	(inlist(ea8b_rf,1,2,3) & ilo_lfs==3)	// Labour market
		replace ilo_olf_reason=2 if (ea8b_rf==4 & ilo_lfs==3)				// Other labour market reasons
		replace ilo_olf_reason=3 if	(ea8b_rf==6 & ilo_lfs==3)     			// Personal/Family-related
		replace ilo_olf_reason=4 if (ea8b_rf==5 & ilo_lfs==3)				// Does not need/want to work
		replace ilo_olf_reason=5 if (ilo_olf_reason==. & ilo_lfs==3)		// Not elsewhere classified
			    lab def reasons_lab 1 "1 - Labour market" 2 "2 - Other labour market reasons" 3 "3 - Personal / Family-related" ///
				    			    4 "4 - Does not need/want to work" 5 "5 - Not elsewhere classified"
				lab val ilo_olf_reason reasons_lab 
				lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seeker ('ilo_dis')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

	gen ilo_dis=1 if (ilo_lfs==3 & ea8b2_im==1 & ilo_olf_reason==1)
			lab def dis_lab 1 "Discouraged job-seekers"
			lab val ilo_dis dis_lab
			lab var ilo_dis "Discouraged job-seekers"
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training ('ilo_neet')
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

        compress
		save ${country}_${source}_${time}_FULL, replace

* 2 - Dataset with only 'ILO' variables
	
		keep ilo*
		drop if (ilo_key==. | ilo_age_5yrbands==.)
		save ${country}_${source}_${time}_ILO, replace
