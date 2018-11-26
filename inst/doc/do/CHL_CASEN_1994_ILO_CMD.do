* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Chile
* DATASET USED: Chile CASEN
* NOTES: 
* Files created: Standard variables on LFS Chile
* Authors: ILO / Department of Statistics / DPAU

* Starting Date: 11 December 2017
* Last updated: 09 April 2018
***********************************************************************************************


*******************************************************************
 /* 1.	Set up work directory, file name, variables and function */
*******************************************************************

clear all 

set more off


global path "J:\DPAU\MICRO"
global country "CHL"
global source "CASEN"
global time "1994"
global inputFile "casen1994.dta"

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
 
 ** Comment: expr.- regional weight
  	

	gen ilo_wgt = expr 	
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
			replace ilo_geo=1 if z==1
			replace ilo_geo=2 if z==2
			replace ilo_geo=3 if ilo_geo==.
				lab def geo_lab 1 "1 - Urban" 2 "2 - Rural" 3 "3 - Not elsewhere classified"
				lab val ilo_geo geo_lab
				lab var ilo_geo "Geographical coverage"

 
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

		gen ilo_sex=sexo
			label define label_Sex 1 "1 - Male" 2 "2 - Female"
			label values ilo_sex label_Sex 
			lab var ilo_sex "Sex"
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

 
		gen ilo_age=edad
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
** Comment: this variable is not computed because the mapping does not give a consistent result

/*
gen ilo_edu_isced97=.
		replace ilo_edu_isced97=1 if e9==15                                                             // X - No schooling
		replace ilo_edu_isced97=2 if inlist(e9,1,2)                                                           // 0 - Pre-primary education
		replace ilo_edu_isced97=3 if e9==3                                                           // 1 - Primary education or first stage of basic education
		replace ilo_edu_isced97=4 if inlist(e9,4,5,7)                                                           // 2 - Lower secondary or second stage of basic education
		replace ilo_edu_isced97=5 if inlist(e9,6,8,9,11)                                                // 3 - Upper secondary education
		replace ilo_edu_isced97=6 if e9==12                                               // 4 - Post-secondary non-tertiary education
    	replace ilo_edu_isced97=7 if e9==10                                               // 5 - First stage of tertiary education
 		replace ilo_edu_isced97=8 if inlist(e9,13,14)                                                            // 6 - Second stage of tertiary education
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

*/
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education attendance ('ilo_edu_attendance')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

 		gen ilo_edu_attendance=.
			replace ilo_edu_attendance=1 if e3==1
			replace ilo_edu_attendance=2 if e3==2
			replace ilo_edu_attendance=3 if ilo_edu_attendance==.
				lab def edu_attendance_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
				lab val ilo_edu_attendance edu_attendance_lab
				lab var ilo_edu_attendance "Education (Attendance)"	

				
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			           Marital status ('ilo_mrts') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: this variable cannot be computed for this year because the single category is not specified, and there is problems with the widow/er (viudo) category. 
	

							
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Disability status ('ilo_dsb_details')  
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

** Comment: there is no information to compute this variable. 



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
		*replace ilo_wap=0 if ilo_age<15
			label def ilo_wap_lab 1 "Working age population"
			label val ilo_wap ilo_wap_lab
			label var ilo_wap "Working age population"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Labour Force Status ('ilo_lfs')
* -------------------------------------------------------------------------------------------
     	 
 ** Despite the fact the the working age population is defined as all the population aged 15 and above, 
 ** the questions related to the working module are asked to the population aged 12 and above.
 
  ** Note: the definition of unemployment does not include the availability criteria. Two criteria (not in employment and seeking) T5:1429

	gen ilo_lfs=.
	
		replace ilo_lfs=1 if (o1==1 | o2==1) & ilo_wap==1 	// 1 "Employed"
		
		** Comment: there is no information about availability or future starters.
		replace ilo_lfs=2 if  o3==1 & ilo_wap==1 			          // 2 "Unemployed"
		*replace ilo_lfs=2 if (o5==1 & o6==1) & ilo_wap==1 		// 2 "Unemployed" (future starters)

		replace ilo_lfs=3 if !inlist(ilo_lfs,1,2) & ilo_wap==1 		// 3 "Outside Labour Force"
		
		replace ilo_lfs=. if ilo_wap!=1	
				label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status" 

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
** Comment: there is no information available to compute this variable
/*
	gen ilo_mjh=.
		replace ilo_mjh=1 if inlist(o25,2,9)
		replace ilo_mjh=2 if o25==1
		replace ilo_mjh=. if ilo_lfs!=1
				* force missing values into "one job only" 
				replace ilo_mjh=1 if ilo_mjh==. & ilo_lfs==1
			lab def lab_ilo_mjh 1 "1 - One job only" 2 "2 - More than one job"
			lab var ilo_mjh "Multiple job holders"
			lab val ilo_mjh lab_ilo_mjh
			
*/
***********************************************************************************************
*			PART 3.1. ECONOMIC CHARACTERISTICS FOR MAIN JOB 
***********************************************************************************************		

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Status in employment ('ilo_ste')
* -------------------------------------------------------------------------------------------
* ------------------------------------------------------------------------------------------- 

* Primary activity
	
		gen ilo_job1_ste_icse93=.
			replace ilo_job1_ste_icse93=1 if inrange(o7,3,6) | o7==8
			replace ilo_job1_ste_icse93=2 if o7==1
			replace ilo_job1_ste_icse93=3 if o7==2
			/* replace ilo_job1_ste_icse93=4 if */
			replace ilo_job1_ste_icse93=5 if o7==7
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
	
		** Comment: there is no information available related to this. 
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

** ISIC Rev.2

/*
	gen indu_code_prim=int(c_o13/100) if ilo_lfs==1
					
		* Two-digit level
		
		gen ilo_job1_eco_isic3_2digits=indu_code_prim
 			
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
	
		* Secondary activity
		
			** no info available
		
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
			replace ilo_job1_eco_isic3=18 if ilo_job1_eco_isic3_2digits==. & ilo_lfs==1
		        lab def eco_isic3 1  "A - Agriculture, hunting and forestry "	2  "B - Fishing "	3  "C - Mining and quarrying "	4  "D - Manufacturing " ///
                                  5  "E - Electricity, gas and water supply "	6  "F - Construction "	7  "G - Wholesale and retail trade; repair of motor vehicles, motorcycles and personal and household goods "	8  "H - Hotels and restaurants " ///
                                  9  "I - Transport, storage and communications "	10  "J - Financial intermediation "	11  "K - Real estate, renting and business activities "	12  "L - Public administration and defence; compulsory social security " ///
                                  13  "M - Education "	14  "N - Health and social work "	15  "O - Other community, social and personal service activities "	16  "P - Activities of private households as employers and undifferentiated production activities of private households " ///
                                  17  "Q - Extraterritorial organizations and bodies "	18  "X - Not elsewhere classified "		
			    lab val ilo_job1_eco_isic3 eco_isic3
			    lab var ilo_job1_eco_isic3 "Economic activity (ISIC Rev. 3.1) - main job"
	
	* Secondary activity
		
		** no info available
		
	* Now do the classification at an aggregated level

*/

		* Primary activity
		
		gen ilo_job1_eco_aggregate=.
			replace ilo_job1_eco_aggregate=1 if rama==1 & ilo_lfs==1
			replace ilo_job1_eco_aggregate=2 if rama==3 & ilo_lfs==1
			replace ilo_job1_eco_aggregate=3 if rama==5 & ilo_lfs==1
			replace ilo_job1_eco_aggregate=4 if inlist(rama,2,4) & ilo_lfs==1
			replace ilo_job1_eco_aggregate=5 if inrange(rama,6,8) & ilo_lfs==1
			replace ilo_job1_eco_aggregate=6 if rama==9 & ilo_lfs==1
			replace ilo_job1_eco_aggregate=7 if ilo_job1_eco_aggregate==. & ilo_lfs==1
				lab def eco_aggr_lab 1 "1 - Agriculture" 2 "2 - Manufacturing" 3 "3 - Construction" 4 "4 - Mining and quarrying; Electricity, gas and water supply" ///
								     5 "5 - Market Services (Trade; Transportation; Accommodation and food; and Business and administrative services)"  ///
								     6 "6 - Non-market services (Public administration; Community, social and other services and activities)" 7 "7 - Not classifiable by economic activity"					
			    lab val ilo_job1_eco_aggregate eco_aggr_lab
			    lab var ilo_job1_eco_aggregate "Economic activity (Aggregate) - main job"
				
		* Secondary activity
		
		  	** no info available
 
 			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_ocu')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

		** Comment:  ISCO-88 classification used

 
	* Two-digits level
	


	gen occ_code_prim=int(o5/10) if ilo_lfs==1 & o5!=999
 	

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
* ------------------------------------------------------------------------------------------

** Comment: there is no information to compute this variable
			
		 

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*		1. 	Hours of work actually worked ('ilo_job1_how_actual')   
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

** MAIN JOB


gen ilo_job1_how_actual =  o14 if ilo_lfs == 1 
		
		*replace ilo_job1_how_actual = . if ilo_job1_how_actual == 999 & ilo_lfs==1
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
			 
				 
** SECOND JOB
 
			*** Comment: no information available
	******
	
	 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*		2. 	Hours of work usually worked ('ilo_job1_how_usual')     
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
*** MAIN JOB

			*** Comment: no information available
	******
	
		
 		
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job_time')  
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
** Comment: there is no information available to compute this variable

 	/*
		gen ilo_job1_job_time=.
			replace ilo_job1_job_time=1 if o12<=30 
			replace ilo_job1_job_time=2 if o12>=31 & o12!=999
			replace ilo_job1_job_time=3 if ilo_job1_job_time==. & ilo_lfs==1
			replace ilo_job1_job_time=. if ilo_lfs!=1
				lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
				lab val ilo_job1_job_time job_time_lab
				lab var ilo_job1_job_time "Job (Working time arrangement)"
		*/	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job_contract')  
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
	gen ilo_job1_job_contract=.
		replace ilo_job1_job_contract=1 if o12==1
		replace ilo_job1_job_contract=2 if inrange(o12,2,5)
		replace ilo_job1_job_contract=3 if ilo_job1_ste_aggregate==1 & ilo_job1_job_contract==.
		replace ilo_job1_job_contract=. if ilo_job1_ste_aggregate!=1
			lab def job_contract_lab 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"
			lab val ilo_job1_job_contract job_contract_lab
			lab var ilo_job1_job_contract "Job (Type of contract)" 

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Informal/Formal economy: Unit of production ('ilo_job1_ife_prod')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

** Comment: it is not possible to compute

* Comment: Useful questions:	* o7: Status in employment
								* no info: Institutional sector 
								* [no useful question]: Destination of production 
								* no info: Bookkeeping
								* no info: Registration						
								* o10: Location of workplace 
								* o9: Size of the establishment					
								
								* Social security 
									* o19: Pension fund
									* [no info]: Paid annual leave
									* [no info]: Paid sick leave

	 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Informal/formal economy: Nature of job ('ilo_job1_ife_nature')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

** Comment: it is not possible to compute

	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Earnings ('ilo_job1_lri_ees' and 'ilo_ear_slf')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------



 *** Employees	
 	gen ilo_job1_lri_ees = yopraj if  ilo_job1_ste_aggregate==1 
			*replace ilo_job1_lri_ees=. if ytrabajocor==. & ilo_job1_ste_aggregate==1 
				lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"
		 
		 
*** Self-employed			 
	gen ilo_job1_lri_slf = yopraj if  ilo_job1_ste_aggregate==2  
			*replace ilo_job1_lri_ees=. if ytrabajocor==. & ilo_job1_ste_aggregate==1 
				lab var ilo_job1_lri_slf "Monthly labour related income of self-employed in main job"	 


***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_tru')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
           
* Comment: This variable is not possible to compute. There is no information about availability to work additional hours  
/*
 		gen ilo_joball_tru=.
			replace ilo_joball_tru=1 if (ilo_job1_how_actual<45 & o11==1 & ilo_lfs==1)
				lab def tru_lab 1 "Time-related underemployment"
				lab val ilo_joball_tru tru_lab
				lab var ilo_joball_tru "Time-related underemployment"	
*/
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Cases of non-fatal occupational injury ('ilo_joball_oi_case')  
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
 
 ** COMMENT: This variable is not possible to compute
 
 
 
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

* Comment.- no info available


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Category of unemployment ('ilo_cat_une')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------


	gen ilo_cat_une=.
		replace ilo_cat_une=1 if o16==1
		replace ilo_cat_une=2 if o16==2
		replace ilo_cat_une=3 if ilo_lfs==2 & ilo_cat_une==.
		replace ilo_cat_une=. if ilo_lfs!=2
			lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
			lab val ilo_cat_une cat_une_lab
			lab var ilo_cat_une "Category of unemployment"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic3')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: no information available
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu_isco08')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
		
* Comment: no information available



***********************************************************************************************
*			PART 3.4. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

** Comment: variable not possible to compute due to both, the skip patterns and some information not available. 
		

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reasons for not seeking a job ('ilo_olf_reason')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------


	gen ilo_olf_reason=.
		replace ilo_olf_reason=1 if o4==8
        replace ilo_olf_reason=2 if o4==7
        replace ilo_olf_reason=3 if inrange(o4,1,4) 
		replace ilo_olf_reason=4 if inlist(o4,5,6) 
		replace ilo_olf_reason=5 if ilo_olf_reason==. & ilo_lfs==3
			replace ilo_olf_reason=. if ilo_lfs!=3
			lab def lab_olf_reason 1 "1 - Labour market (Discouraged)" 2 "2 - Other labour market reasons" 3 "3 - Personal/Family-related"  4 "4 - Does not need/want to work" 5 "5 - Not elsewhere classified"
			lab val ilo_olf_reason lab_olf_reason
			lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seekers ('ilo_dis')
* -------------------------------------------------------------------------------------------
* ------------------------------------------------------------------------------------------- 

	gen ilo_dis=1 if ilo_lfs==3 & ilo_olf_reason==1
		lab def ilo_dis_lab 1 "Discouraged job-seekers" 
		lab val ilo_dis ilo_dis_lab
		lab var ilo_dis "Discouraged job-seekers"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training (NEETs) ('ilo_neet')
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
