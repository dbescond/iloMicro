* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Ethiopia
* DATASET USED: Ethiopia National Labour Force Survey
* NOTES: 
* Files created: Standard variables on LFS Ethiopia
* Authors: DPAU 
* Starting Date: 23 February 2018
* Last updated:  01 March 2018
***********************************************************************************************


*******************************************************************
 /* 1.	Set up work directory, file name, variables and function */
*******************************************************************

clear all 

set more off

 
global path "J:\DPAU\MICRO"
global country "ETH"
global source "NLFS"
global time "2005"
global input_file "ETH_NLFS_2005.DTA"

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

	use "${input_file}", clear	
	
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
	
	
 	gen ilo_wgt=weight
		
 
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

 
 

		gen ilo_geo=.
			replace ilo_geo=1 if urbrur==1 
			replace ilo_geo=2 if  urbrur==12
			replace ilo_geo=3 if  . 
				lab def geo_lab 1 "1 - Urban" 2 "2 - Rural" 3 "3 - Not elsewhere classified"
				lab val ilo_geo geo_lab
				lab var ilo_geo "Geographical coverage"
 
 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
		
		gen ilo_sex=lf13
			label define label_sex 1 "1 - Male" 2 "2 - Female"
			label values ilo_sex label_sex 
			lab var ilo_sex "Sex" 
 
 
 * -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

		gen ilo_age=lf14 
	
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

 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Level of education ('ilo_edu')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

*** YVES: high level of not classified

gen ilo_edu_isced97=.
		replace ilo_edu_isced97=1 if lf20==2                                                             // X - No schooling
		replace ilo_edu_isced97=2 if inlist(lf23,95,96)                                                // 0 - Pre-primary education
		replace ilo_edu_isced97=3 if inrange(lf23,1,8)                                                 // 1 - Primary education or first stage of basic education
		replace ilo_edu_isced97=4 if inrange(lf23,9,10)                                                 // 2 - Lower secondary or second stage of basic education
		replace ilo_edu_isced97=5 if inrange(lf23,11,22)                                                // 3 - Upper secondary education
		*replace ilo_edu_isced97=6 if inrange(lf23,23,32)                                               // 4 - Post-secondary non-tertiary education
		replace ilo_edu_isced97=7 if inrange(lf23,23,24)                                                // 5 - First stage of tertiary education
 		replace ilo_edu_isced97=8 if lf23==25                                                           // 6 - Second stage of tertiary education
        replace ilo_edu_isced97=9 if ilo_edu_isced97 == .                                                // UNK - Level not stated
		 
     
	     label def isced_97_lab 1 "X - No schooling"	2 "0 - Pre-primary education"	3 "1 - Primary education or first stage of basic education"	4 "2 - Lower secondary or second stage of basic education"	////
                                 5 "3 - Upper secondary education"	6 "4 - Post-secondary non-tertiary education"	7 "5 - First stage of tertiary education"	8 "6 - Second stage of tertiary education"	///
								 9 "9 - UNK - Level not stated"
 
		 label val ilo_edu_isced97 isced_97_lab
		 lab var ilo_edu_isced97 "Education (ISCED 97)"
	
	
 
			
* Aggregate
			
	gen ilo_edu_aggregate=.
		replace ilo_edu_aggregate=1 if inlist(ilo_edu_isced97,1,2)
		replace ilo_edu_aggregate=2 if inlist(ilo_edu_isced97,3,4)
		replace ilo_edu_aggregate=3 if inlist(ilo_edu_isced97,5,6)
		replace ilo_edu_aggregate=4 if inlist(ilo_edu_isced97,7,8)
		replace ilo_edu_aggregate=5 if ilo_edu_isced97==9
			label def edu_aggr_lab 1 "1 - Less than basic" 2 "2 - Basic" 3 "3 - Intermediate" 4 "4 - Advanced" 5 "5 - Level not stated"
			label val ilo_edu_aggregate edu_aggr_lab
			label var ilo_edu_aggregate "Education (Aggregate level)"

 

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education attendance ('ilo_edu_attendance')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
 /*
 **Comment: no info >> therefore it is not possible to compute NEET
gen ilo_edu_attendance = .
		replace ilo_edu_attendance = 1 if  lf213==1                                                                  // 1 - Attending
		replace ilo_edu_attendance = 2 if inlist(lf213,2,3)                                                             //  2 - Not attending
	    replace ilo_edu_attendance = 3 if ilo_edu_attendance == .                                                     // 3 - Not elsewhere classified
			lab def edu_attendance_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
			lab val ilo_edu_attendance edu_attendance_lab
			lab var ilo_edu_attendance "Education (Attendance)"
*/
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Disability status ('ilo_dsb_details')  
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
gen ilo_dsb_aggregate = .
	replace ilo_dsb_aggregate = 2 if lf19 == 1                                // "Persons with disability"
 	replace ilo_dsb_aggregate = 1 if ilo_dsb_aggregate == .            // "Persons without disability"


	lab def dsb_aggregate_lab 1 "Persons without disability" 2 "Persons with disability"  
			lab val ilo_dsb_aggregate   dsb_aggregate_lab
			lab var ilo_dsb_aggregate "Disability status (Aggregate)"


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

** DOUBT: they consider people in employment those who are woking more than 4hours/week

* Comment: ** - The WAP in Ethiopia starts in 10 years, however all the questions related to economic activity are asked to 
*               people from 5 yr-old [T2:239_T3:89]

** doubt people in employment
	gen ilo_lfs=.
		replace ilo_lfs=1 if lf28==1 & !inlist(lf29,0,99) & ilo_wap==1 // employed (people at work, people who worked at least 1 hour in the last week)
		replace ilo_lfs=1 if inrange(lf34,1,3) & ilo_wap==1 // employed (people not at work - temporary absent)
		
 		replace ilo_lfs=2 if ilo_lfs!=1 & (lf56==1 & lf59==1) & ilo_wap==1  // unemployed (those who looked for job last weekend were available)	
		replace ilo_lfs=2 if ilo_lfs!=1 &  lf58==6 & ilo_wap==1  // Future job starters
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
		replace ilo_mjh=1 if lf50==2 & ilo_lfs==1
		replace ilo_mjh=2 if lf50==1 & ilo_lfs==1
		replace ilo_mjh=. if ilo_lfs!=1 & ilo_lfs==1
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

*** Yves: according to the ILO standards (either 19th or 13th-point 144) category 11 (apprentice) 
**        is not considered as people in employment because they don't reveice any pay (lf311 lf313).
**        however when I cross lf311 with ilo_lfs they are apparently working

	* MAIN JOB
		
		gen ilo_job1_ste_icse93=.
			replace ilo_job1_ste_icse93=1 if inrange(lf39,1,6) // 1 - Employees
			replace ilo_job1_ste_icse93=2 if lf39==10  // 2 - Employers
			replace ilo_job1_ste_icse93=3 if lf39==8  // 3 - Own-account workers
			replace ilo_job1_ste_icse93=4 if lf39==7     // 4 - Members of producers' cooperatives
			replace ilo_job1_ste_icse93=5 if lf39==9 // 5 - Contributing family workers 
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
		
		 
	* Secondary activity
			* No information related


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
 
* ISIC Rev. 3.1


	* MAIN JOB:

	
 	* 2-digit level	
	gen ilo_job1_eco_isic3_2digits = int(lf38/100) if ilo_lfs == 1
 
		
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
	    replace ilo_job1_eco_isic3=18 if ilo_job1_eco_isic3==. & ilo_lfs==1
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


 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_ocu')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

 
** Comment:  ISCO-88 classification used

	gen occ_code_prim=. if ilo_lfs == 1 
	    replace occ_code_prim=int(lf36/100) if ilo_lfs == 1 & lf36!=9999
		replace occ_code_prim=52 if lf36==5761 & ilo_lfs == 1
 

    * 2-digit level
	gen ilo_job1_ocu_isco88_2digits = occ_code_prim if ilo_lfs==1
		
	lab def ocu_isco88_2digits 1 "01 - Armed forces"	11 "11 - Legislators and senior officials"	12 "12 - Corporate managers"	13 "13 - General managers"	///
	                            21 "21 - Physical, mathematical and engineering science professionals"	22 "22 - Life science and health professionals"	23 "23 - Teaching professionals"	24 "24 - Other professionals" ///
								31 "31 - Physical and engineering science associate professionals"	32 "32 - Life science and health associate professionals"	33 "33 - Teaching associate professionals"	///
								34 "34 - Other associate professionals"	41 "41 - Office clerks"	42 "42 - Customer services clerks"	51 "51 - Personal and protective services workers"	52 "52 - Models, salespersons and demonstrators" ///
                                61 "61 - Skilled agricultural and fishery workers"	62 "62 - Subsistence agricultural and fishery workers"	71 "71 - Extraction and building trades workers"	72 "72 - Metal, machinery and related trades workers"	///
							    73 "73 - Precision, handicraft, craft printing and related trades workers"	74 "74 - Other craft and related trades workers"	///	
                                81 "81 - Stationary plant and related operators"	82 "82 - Machine operators and assemblers"	83 "83 - Drivers and mobile plant operators"	///
							    91 "91 - Sales and services elementary occupations"	92 "92 - Agricultural, fishery and related labourers"	///
							    93 "93 - Labourers in mining, construction, manufacturing and transport"		

	lab val ilo_job1_ocu_isco88_2digits ocu_isco88_2digits
		lab var ilo_job1_ocu_isco88_2digits "Occupation (ISCO-88), 2 digit level - main job"

		
    * 1-digit level
	gen ilo_job1_ocu_isco88 =.
	
		replace ilo_job1_ocu_isco88 = 1 if inrange(occ_code_prim,11,13) & ilo_lfs==1  // "1 - Legislators, senior officials and managers"
		replace ilo_job1_ocu_isco88 = 2 if inrange(occ_code_prim,21,24) & ilo_lfs==1  // "2 - Professionals"
		replace ilo_job1_ocu_isco88 = 3 if inrange(occ_code_prim,31,34) & ilo_lfs==1  // "3 - Technicians and associate professionals"
		replace ilo_job1_ocu_isco88 = 4 if inrange(occ_code_prim,41,42) & ilo_lfs==1  // "4 - Clerks"
		replace ilo_job1_ocu_isco88 = 5 if inrange(occ_code_prim,51,52) & ilo_lfs==1  // "5 - Service workers and shop and market sales workers"
		replace ilo_job1_ocu_isco88 = 6 if inrange(occ_code_prim,61,62)  & ilo_lfs==1  // "6 - Skilled agricultural and fishery workers"
        replace ilo_job1_ocu_isco88 = 7 if inrange(occ_code_prim,71,74)  & ilo_lfs==1  // "7 - Craft and related trades workers"
        replace ilo_job1_ocu_isco88 = 8 if inrange(occ_code_prim,81,83)  & ilo_lfs==1  // "8 - Plant and machine operators and assemblers"
        replace ilo_job1_ocu_isco88 = 9 if inrange(occ_code_prim,91,93)  & ilo_lfs==1  // "9 - Elementary occupations"
        replace ilo_job1_ocu_isco88 = 10 if occ_code_prim==01  & ilo_lfs==1  // "0 - Armed forces"	
		replace ilo_job1_ocu_isco88 = 11 if occ_code_prim==.  & ilo_lfs==1  // "X - Not elsewhere classified"


	            lab def ocu88_1digits 1 "1 - Legislators, senior officials and managers"	2 "2 - Professionals"	3 "3 - Technicians and associate professionals" ///
										4 "4 - Clerks"	5 "5 - Service workers and shop and market sales workers"	6 "6 - Skilled agricultural and fishery workers"	///
										7 "7 - Craft and related trades workers"	8 "8 - Plant and machine operators and assemblers"	9 "9 - Elementary occupations"	///
										10 "0 - Armed forces"	11 "11 - Not elsewhere classified"

				lab val ilo_job1_ocu_isco88 ocu88_1digits
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
	    replace ilo_job1_ocu_skill=1 if ilo_job1_ocu_isco88==9                   // Low
		replace ilo_job1_ocu_skill=2 if inlist(ilo_job1_ocu_isco88,4,5,6,7,8)    // Medium
		replace ilo_job1_ocu_skill=3 if inlist(ilo_job1_ocu_isco88,1,2,3)        // High
		replace ilo_job1_ocu_skill=4 if inlist(ilo_job1_ocu_isco88,10,11)        // Not elsewhere classified
				lab def ocu_skill_lab 1 "1 - Skill level 1 (low)" 2 "2 - Skill level 2 (medium)" 3 "3 - Skill levels 3 and 4 (high)" 4 "4 - Not elsewhere classified"
			    lab val ilo_job1_ocu_skill ocu_skill_lab
			    lab var ilo_job1_ocu_skill "Occupation (Skill level) - main job"

  
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_ins_sector')  
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
  
	* Primary occupation
	
	 gen ilo_job1_ins_sector=.
		replace ilo_job1_ins_sector=1 if inlist(lf39,1,2,4)
		replace ilo_job1_ins_sector=2 if ilo_job1_ins_sector!=1 & ilo_lfs==1
		replace ilo_job1_ins_sector=. if ilo_lfs!=1
			lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
			lab values ilo_job1_ins_sector ins_sector_lab
			lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities"	
			
	* Secondary occupation
	
	** Comment with Yves
	
			*** Commnet: No information available. 
	
 
* --------------------------------------------------------------------------------------------------
* --------------------------------------------------------------------------------------------------
*		Weekly hours actually worked ('ilo_how_actual') 
* --------------------------------------------------------------------------------------------------
* --------------------------------------------------------------------------------------------------

 
** Main job
				
	gen ilo_job1_how_actual = cond(missing(lf29), 0, lf29) - cond(missing(lf52), 0, lf52) if ilo_lfs==1
					lab var ilo_job1_how_actual "Weekly hours actually worked in main job"
				
	gen ilo_job1_how_actual_bands = .
			 replace ilo_job1_how_actual_bands = 1 if  ilo_job1_how_actual==0	    // No hours actually worked
			 replace ilo_job1_how_actual_bands = 2 if inrange(ilo_job1_how_actual,1,14)   // 01-14
			 replace ilo_job1_how_actual_bands = 3 if inrange(ilo_job1_how_actual,15,29)	// 15-29
			 replace ilo_job1_how_actual_bands = 4 if  inrange(ilo_job1_how_actual,30,34) // 30-34
			 replace ilo_job1_how_actual_bands = 5 if  inrange(ilo_job1_how_actual,35,38) // 35-39
			 replace ilo_job1_how_actual_bands = 6 if  inrange(ilo_job1_how_actual,40,48) // 40-48
			 replace ilo_job1_how_actual_bands = 7 if inrange(ilo_job1_how_actual,49,97) // 49+
			 replace ilo_job1_how_actual_bands= 8 if ilo_job1_how_actual_bands == .		// Not elsewhere classified
 			 replace ilo_job1_how_actual_bands = . if ilo_lfs!=1
				     lab def how_bands_lab 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"
					 lab val ilo_job1_how_actual_bands how_bands_lab
					 lab var ilo_job1_how_actual_bands "Weekly hours actually worked bands in main job"
				
				
*** Second job

	gen ilo_job2_how_actual = lf52 if ilo_mjh==2
					lab var ilo_job2_how_actual "Weekly hours actually worked in second job"
				
	gen ilo_job2_how_actual_bands = .
			 replace ilo_job2_how_actual_bands = 1 if  ilo_job2_how_actual==0	    // No hours actually worked
			 replace ilo_job2_how_actual_bands = 2 if inrange(ilo_job2_how_actual,1,14)   // 01-14
			 replace ilo_job2_how_actual_bands = 3 if inrange(ilo_job2_how_actual,15,29)	// 15-29
			 replace ilo_job2_how_actual_bands = 4 if  inrange(ilo_job2_how_actual,30,34) // 30-34
			 replace ilo_job2_how_actual_bands = 5 if  inrange(ilo_job2_how_actual,35,38) // 35-39
			 replace ilo_job2_how_actual_bands = 6 if  inrange(ilo_job2_how_actual,40,48) // 40-48
			 replace ilo_job2_how_actual_bands = 7 if inrange(ilo_job2_how_actual,49,97) // 49+
			 replace ilo_job2_how_actual_bands= 8 if ilo_job2_how_actual_bands == .		// Not elsewhere classified
 			 replace ilo_job2_how_actual_bands = . if ilo_mjh!=2
			 
 					 lab val ilo_job2_how_actual_bands how_bands_lab
					 lab var ilo_job2_how_actual_bands "Weekly hours actually worked bands in second job"

					 
** All jobs
	
	gen ilo_joball_how_actual = lf29 if ilo_mjh==1
					lab var ilo_joball_how_actual "Weekly hours actually worked in all jobs"
				
	gen ilo_joball_how_actual_bands = .
			 replace ilo_joball_how_actual_bands = 1 if  lf29==0  	    // No hours actually worked
			 replace ilo_joball_how_actual_bands = 2 if inrange(lf29,1,14)   // 01-14
			 replace ilo_joball_how_actual_bands = 3 if inrange(lf29,15,29)	// 15-29
			 replace ilo_joball_how_actual_bands = 4 if  inrange(lf29,30,34) // 30-34
			 replace ilo_joball_how_actual_bands = 5 if  inrange(lf29,35,38) // 35-39
			 replace ilo_joball_how_actual_bands = 6 if  inrange(lf29,40,48) // 40-48
			 replace ilo_joball_how_actual_bands = 7 if inrange(lf29,49,97) // 49+
			 replace ilo_joball_how_actual_bands= 8 if ilo_joball_how_actual_bands == .		// Not elsewhere classified
 			 replace ilo_joball_how_actual_bands = . if ilo_lfs!=1
				    * lab def how_bands_lab 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"
					 lab val ilo_joball_how_actual_bands how_bands_lab
					 lab var ilo_joball_how_actual_bands "Weekly hours actually worked bands in all jobs"	
		
 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job_time') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

** Comment: No info

 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job_contract')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

*** MAIN JOB

 ** REVISAR ESTE RESULTADO (DA LO CONTRARIO A 2013)
 
gen ilo_job1_job_contract=.

		replace ilo_job1_job_contract = 1 if  lf40 == 1  & ilo_job1_ste_aggregate==1 // 1 - Permanent
		replace ilo_job1_job_contract = 2 if inlist(lf40,2,4) & ilo_job1_ste_aggregate==1 // 2 - Temporary
		replace ilo_job1_job_contract = 3 if ilo_job1_job_contract == . & ilo_job1_ste_aggregate==1 // 3 - Unknown
				lab def job_contract_lab 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"
			    lab val ilo_job1_job_contract job_contract_lab
			    lab var ilo_job1_job_contract "Job (Type of contract)"

 
 **** ME HE QUEDADO POR AQUI
 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Informal/Formal economy: Unit of production ('ilo_job1_ife_prod')   
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

  	
* Comment: Useful questions:	* Status in employment: lf39
								* Institutional sector: lf39  
								* Destination of production: [no info]	
								* Bookkeeping: lf46b	
								* Registration: lf46c		
								* Location of workplace: [no info]		 
								* Size of the establishment: lf46a				
								* Social security: [no info] 
									
								

* 1) UNIT OF PRODUCTION: FORMAL/INFORMAL SECTOR		
    			
			gen ilo_job1_ife_prod=.
			
 			   replace ilo_job1_ife_prod=3 if ilo_lfs==1 & (ilo_job1_eco_isic3_2digits==95 | ilo_job1_ocu_isco88_2digits==62)
 				
 				replace ilo_job1_ife_prod=2 if ilo_lfs==1 & (inrange(lf39,1,6) | (!inrange(lf39,1,6)   & lf46b==1) | (!inrange(lf39,1,6)   & lf46b!=1 & lf46c==1))
 											  
			    replace ilo_job1_ife_prod=1 if ilo_lfs==1 & !inlist(ilo_job1_ife_prod,3,2) &  !inrange(lf39,1,6) & lf46b!=1 & lf46c!=1
				                               
				        lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 
						lab val ilo_job1_ife_prod ilo_ife_prod_lab
						lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"
			
			 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Informal/formal economy: Nature of job ('ilo_job1_ife_nature')  
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

*** Comment: for employees and workers not classified by status, we do not have information on Social Security
	
	** therefore I think that this variable is not possible to compute
	/*
* 2) NATURE OF JOB: FORMAL/INFORMAL EMPLOYMENT
	
	      
	
*/
 	
  
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Earnings ('ilo_job1_lri_ees')   
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

** Comment: only information available for employees

	* MAIN JOB
      
		* Employees
	 
      gen ilo_job1_lri_ees=.
			replace ilo_job1_lri_ees=lf45 if ilo_job1_ste_aggregate==1 & lf45!=9999
         
							lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"
				  
	* Self-employed:
			*** no information
			
			
***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS   
***********************************************************************************************		
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_tru')  
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
/*
*** Comment: There is not information related to the hour threshold, therefore it is considered a threshold of 35 hours per week
            [The module in the questionnaire related to underemployment -questions regarding two underemployment criteria-
			are answered by all the persons in employment, regardless the number of hours worked]

*/


		gen ilo_joball_tru=.
			replace ilo_joball_tru=1 if (lf53==1 & ilo_job1_how_actual<35 & ilo_lfs==1)
			lab def tru_lab 1 "Time-related underemployment"
			lab val ilo_joball_tru tru_lab
			lab var ilo_joball_tru "Time-related underemployment"	
			
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
*			Duration of unemployment ('ilo_dur') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

 
	gen ilo_dur_details=.
				replace ilo_dur_details=1 if (lf66==0 & ilo_lfs==2)                        // Less than 1 month
				replace ilo_dur_details=2 if (inlist(lf66,1,2) & ilo_lfs==2)               // 1 to 3 months
				replace ilo_dur_details=3 if (inrange(lf66,3,5) & ilo_lfs==2)              // 3 to 6 months
				replace ilo_dur_details=4 if (inrange(lf66,6,11) & ilo_lfs==2)             // 6 to 12 months
				replace ilo_dur_details=5 if (inrange(lf66,12,23) & ilo_lfs==2)            // 12 to 24 months
				replace ilo_dur_details=6 if (lf66>=24 & ilo_lfs==2)                       // 24 months or more
				replace ilo_dur_details=7 if (ilo_dur_details==. & ilo_lfs==2)              // Not elsewhere classified
				        lab def ilo_unemp_det 1 "Less than 1 month" 2 "1 month to less than 3 months" 3 "3 months to less than 6 months" ///
											  4 "6 months to less than 12 months" 5 "12 months to less than 24 months" 6 "24 months or more" ///
											  7 "Not elsewhere classified"
					    lab val ilo_dur_details ilo_unemp_det
					    lab var ilo_dur_details "Duration of unemployment (Details)"
					
	
	gen ilo_dur_aggregate=.
		replace ilo_dur_aggregate=1 if (lf66<=5 & ilo_lfs==2)                  // Less than 6 months
		replace ilo_dur_aggregate=2 if (inrange(lf66,6,12) & ilo_lfs==2)       // 6 to 12 months
		replace ilo_dur_aggregate=3 if (lf66>=12 & ilo_lfs==2)                 // 12 months or more
		replace ilo_dur_aggregate=4 if (ilo_dur_aggregate==. & ilo_lfs==2)      //Not elsewhere classified
		replace ilo_dur_aggregate=. if ilo_lfs!=2
			lab def ilo_unemp_aggr 1 "Less than 6 months" 2 "6 months to less than 12 months" 3 "12 months or more" 4 "Not elsewhere classified"
			lab val ilo_dur_aggregate ilo_unemp_aggr
			lab var ilo_dur_aggregate "Duration of unemployment (Aggregate)"






* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Category of unemployment ('ilo_cat_une') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_cat_une=.
		replace ilo_cat_une=1 if inrange(lf65,2,4) & ilo_lfs==2 // 1 - Unemployed previously employed
		replace ilo_cat_une=2 if lf65==1 & lf56==1 & ilo_lfs==2  // 2 - Unemployed seeking their first job
		replace ilo_cat_une=3 if ilo_lfs==2 & ilo_cat_une==. // 3 - Unknown
		replace ilo_cat_une=. if ilo_lfs!=2
			lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
			lab val ilo_cat_une cat_une_lab
			lab var ilo_cat_une "Category of unemployment"
	
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic')  
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
/*	

** COMMENT: This variable cannot be computed because most of the observations are unclassified. 
** In this years this is listed in categories that are different to ISIC 

*** ISIC Rev.4

** Comment: There is only information at 1-digit level for previous economic activity		


		
   * 1-digit level
    gen ilo_preveco_isic4 = .
	    replace ilo_preveco_isic4=1 if lf505==1 & ilo_cat_une==1
	    replace ilo_preveco_isic4=2 if lf505==2 & ilo_cat_une==1
	    replace ilo_preveco_isic4=3 if lf505==3 & ilo_cat_une==1
	    replace ilo_preveco_isic4=4 if lf505==4 & ilo_cat_une==1
	    replace ilo_preveco_isic4=5 if lf505==5 & ilo_cat_une==1
	    replace ilo_preveco_isic4=6 if lf505==6 & ilo_cat_une==1
	    replace ilo_preveco_isic4=7 if lf505==7 & ilo_cat_une==1
	    replace ilo_preveco_isic4=8 if lf505==8 & ilo_cat_une==1
	    replace ilo_preveco_isic4=9 if lf505==9 & ilo_cat_une==1
	    replace ilo_preveco_isic4=10 if lf505==10 & ilo_cat_une==1
	    replace ilo_preveco_isic4=11 if lf505==11 & ilo_cat_une==1
	    replace ilo_preveco_isic4=12 if lf505==12 & ilo_cat_une==1
	    replace ilo_preveco_isic4=13 if lf505==13 & ilo_cat_une==1		
	    replace ilo_preveco_isic4=14 if lf505==14 & ilo_cat_une==1
	    replace ilo_preveco_isic4=15 if lf505==15 & ilo_cat_une==1
        replace ilo_preveco_isic4=16 if lf505==16 & ilo_cat_une==1
	    replace ilo_preveco_isic4=17 if lf505==17 & ilo_cat_une==1
	    replace ilo_preveco_isic4=18 if lf505==18 & ilo_cat_une==1
	    replace ilo_preveco_isic4=19 if lf505==19 & ilo_cat_une==1
	    replace ilo_preveco_isic4=20 if lf505==20 & ilo_cat_une==1
	    replace ilo_preveco_isic4=21 if lf505==21 & ilo_cat_une==1
	    replace ilo_preveco_isic4=22 if ilo_preveco_isic4==. & ilo_cat_une == 1
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


				
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu_isco08')  
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

** COMMENT: This variable cannot be computed because most of the observations are unclassified. 


*** ISCO - 08

 	  * 1-digit level
	gen ilo_prevocu_isco08 =.
		replace ilo_prevocu_isco08 = 1 if lf504==1 & ilo_cat_une==1  // "1 - Managers"
		replace ilo_prevocu_isco08 = 2 if lf504==2 & ilo_cat_une==1  // "2 - Professional"
		replace ilo_prevocu_isco08 = 3 if lf504==3 & ilo_cat_une==1  // "3 - Technicians and associate professionals"
		replace ilo_prevocu_isco08 = 4 if lf504==4 & ilo_cat_une==1  // "4 - Clerical support workers"
		replace ilo_prevocu_isco08 = 5 if lf504==5 & ilo_cat_une==1  // "5 - Service and sales workers"
		replace ilo_prevocu_isco08 = 6 if lf504==6  & ilo_cat_une==1  // "6 - Skilled agricultural, forestry and fishery workers"
        replace ilo_prevocu_isco08 = 7 if lf504==7  & ilo_cat_une==1  // "7 - Craft and related trades workers"
        replace ilo_prevocu_isco08 = 8 if lf504==8  & ilo_cat_une==1  // "8 - Plant and machine operators, and assemblers"
        replace ilo_prevocu_isco08 = 9 if lf504==9  & ilo_cat_une==1  // "9 - Elementary occupations"
       * replace ilo_prevocu_isco08 = 10 if lf504==  & ilo_cat_une==1  // "0 - Armed forces occupations"
		replace ilo_prevocu_isco08 = 11 if ilo_prevocu_isco08==.  & ilo_cat_une==1  // "X - Not elsewhere classified"
		
		 

 				lab val ilo_prevocu_isco08 ocu08_1digits
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
		  
*/

***********************************************************************************************
*			PART 3.4. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma')  
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

*** Comment: questions included to compute this variable have been taked from the module of UNEMPLOYMENT in the questionnaire. 

** REVISAR Y COMPARAR 

		gen ilo_olf_dlma = .
				
		replace ilo_olf_dlma = 1 if ilo_lfs == 3 & lf56==1 & lf59==2 		        // Seeking (actively), not available
		replace ilo_olf_dlma = 2 if ilo_lfs == 3 & lf56==2 & lf59==1	            // Not seeking, available
		replace ilo_olf_dlma = 3 if ilo_lfs == 3 & lf56==2 & lf59==2 & inrange(lf60,2,6)        // Not seeking, not available, willing  
		replace ilo_olf_dlma = 4 if ilo_lfs == 3 & lf56==2 & lf59==2 & lf60==1      // Not seeking, not available, not willing  
		
		replace ilo_olf_dlma = 5 if	ilo_olf_dlma == . & ilo_lfs == 3			 // Not classified 
				lab def dlma_lab 1 "1 - Seeking, not available (Unavailable jobseekers)" 2 "2 - Not seeking, available (Available potential jobseekers)" ///
	    						 3 "3 - Not seeking, not available, willing (Willing non-jobseekers)" 4 "4 - Not seeking, not available, not willing" 5 "X - Not elsewhere classified"
		    	lab val ilo_olf_dlma dlma_lab 
			    lab var ilo_olf_dlma "Labour market attachment (Degree of)"
				
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reasons for not seeking a job ('ilo_olf_reason') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------


** Yves:
* - 7. Possibility to rejoin my previous work? OTH LM??
* - 4. Old age/Pension: Is this considered as DNN/want to work?? (or LM-too old))
* - 11. Remittance: DNN/want to work?

gen ilo_olf_reason = .
			replace ilo_olf_reason = 1 if (inrange(lf58,8,10) & ilo_lfs==3)   		// Labour market
			replace ilo_olf_reason = 2 if  lf58==7 & ilo_lfs==3      				   // Other labour market reasons
			replace ilo_olf_reason = 3 if ((inrange(lf58,1,3) | lf58==5) & ilo_lfs==3)    // Personal/Family-related
			replace ilo_olf_reason = 4 if (inlist(lf58,4,11) & ilo_lfs==3)     // Does not need/want to work
			replace ilo_olf_reason = 5 if (lf58==12 & ilo_lfs==3)	      	   	// Not elsewhere classified
			replace ilo_olf_reason = 5 if (ilo_olf_reason==. & ilo_lfs==3)  	// Not elsewhere classified
			
				    lab def reasons_lab 1 "1 - Labour market" 2 "2 - Other labour market reasons" 3 "3 - Personal / Family-related" ///
									    4 "4 - Does not need/want to work" 5 "5 - Not elsewhere classified"
				    lab val ilo_olf_reason reasons_lab 
				    lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"
 
	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seekers ('ilo_dis') 
* -------------------------------------------------------------------------------------------
* ------------------------------------------------------------------------------------------- 


	gen ilo_dis = 1 if ilo_lfs==3 & lf59==1 & ilo_olf_reason==1
			lab def dis_lab 1 "Discouraged job-seekers"
			lab val ilo_dis dis_lab
			lab var ilo_dis "Discouraged job-seekers"

			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training (NEETs) ('ilo_neet') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------


** Comment: this variable is not possible to compute because it is not possible to compute the variable ilo_edu_attendance 

/*
gen ilo_neet = 1 if ilo_age_aggregate==2 & ilo_lfs!=1 & ilo_edu_attendance==2
		lab def neet_lab 1 "Youth not in education, employment or training"
		lab val ilo_neet neet_lab
		lab var ilo_neet "Youth not in education, employment or training"

*/
 
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

		