* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Chile
* DATASET USED: Chile CASEN
* NOTES: 
* Files created: Standard variables on LFS Chile
* Authors: ILO / Department of Statistics / DPAU

* Starting Date: 11 December 2017
* Last updated: 09 March 2018
***********************************************************************************************


*******************************************************************
 /* 1.	Set up work directory, file name, variables and function */
*******************************************************************

clear all 

set more off

global path "J:\DPAU\MICRO"
global country "CHL"
global source "CASEN"
global time "2013"
global inputFile "casen_2013_mn_b_principal.dta"

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
 
 ** Comment: expre.- regional weight
 
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
			replace ilo_geo=1 if zona==1
			replace ilo_geo=2 if zona==2
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
 
	gen ilo_edu_isced11=.
			* No schooling
		replace ilo_edu_isced11=1 if e6a==1
			* Early childhood education
		replace ilo_edu_isced11=2 if inlist(e6a,2,3)
			* Primary education
		replace ilo_edu_isced11=3 if inlist(e6a,4,5) 
			* Lower secondary education
		replace ilo_edu_isced11=4 if e6a==6
			* Upper secondary education
		replace ilo_edu_isced11=5 if inrange(e6a,7,10)
			* Post-secondary non-tertiary education
		replace ilo_edu_isced11=6 if e6a==11
			* Short-cycle tertiary education
		*replace ilo_edu_isced11=7 if 
			* Bachelor's or equivalent level
		replace ilo_edu_isced11=8 if e6a==12
			* Master's or equivalent level
		replace ilo_edu_isced11=9 if e6a==13
			* Doctoral or equivalent level 
		*replace ilo_edu_isced11=10 if  
			* Not elsewhere classified
		replace ilo_edu_isced11=11 if inlist(e6a,99,.)
			label def isced_11_lab 1 "X - No schooling" 2 "0 - Early childhood education" 3 "1 - Primary education" 4 "2 - Lower secondary education" 5 "3 - Upper secondary education" ///
									6 "4 - Post-secondary non-tertiary education" 7 "5 - Short-cycle tertiary education" 8 "6 - Bachelor's or equivalent level" 9 "7 - Master's or equivalent level" ///
									10 "8 - Doctoral or equivalent level" 11 "9 - Not elsewhere classified"
			label val ilo_edu_isced11 isced_11_lab
			lab var ilo_edu_isced11 "Education (ISCED 11)"


		* for the definition, cf. the document "Guide to reporting labour statistics to the ILO using the Excel questionnaire"
		
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
* Comment: Category 5 of ilo_mrts_details also includes annulled marriage (ecivil==3)
	
	* Detailed
	gen ilo_mrts_details=.
	    replace ilo_mrts_details=1 if ecivil==7                                          // Single
		replace ilo_mrts_details=2 if ecivil==1                                          // Married
		replace ilo_mrts_details=3 if ecivil==2                                          // Union / cohabiting
		replace ilo_mrts_details=4 if ecivil==6                                          // Widowed
		replace ilo_mrts_details=5 if inrange(ecivil,3,5)                                // Divorced / separated
		replace ilo_mrts_details=6 if ilo_mrts_details==.			                     // Not elsewhere classified
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
*			Disability status ('ilo_dsb_details')  
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
capture gen s34t1 = s37t1
	
	gen ilo_dsb_aggregate = .
		replace ilo_dsb_aggregate = 2 if !inlist(s34t1,7,.)             // "Persons with disability"
		replace ilo_dsb_aggregate = 1 if inlist(s34t1,7,.)             // "Persons without disability"


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
     	 
 ** Despite the fact the the working age population is defined as all the population aged 15 and above, 
 ** the questions related to the working module are asked to the population aged 12 and above.
 
	gen ilo_lfs=.
	
		replace ilo_lfs=1 if (o1==1 | o2==1 | o3==1) & ilo_wap==1 	// 1 "Employed"
		
		replace ilo_lfs=2 if (o5==1 & o6==1) & ilo_wap==1 			// 2 "Unemployed"
		replace ilo_lfs=2 if (o5==1 & o7r1==1 ) & ilo_wap==1 		// 2 "Unemployed" (future starters)

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


	gen ilo_mjh=.
		replace ilo_mjh=1 if o27==2
		replace ilo_mjh=2 if o27==1
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
	
		gen ilo_job1_ste_icse93=.
			replace ilo_job1_ste_icse93=1 if inrange(o15,3,8) 
			replace ilo_job1_ste_icse93=2 if o15==1
			replace ilo_job1_ste_icse93=3 if o15==2
			/* replace ilo_job1_ste_icse93=4 if */
			replace ilo_job1_ste_icse93=5 if o15==9
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
	
		gen ilo_job2_ste_icse93=.
			replace ilo_job2_ste_icse93=1 if inrange(o28,3,8) & ilo_mjh==2
			replace ilo_job2_ste_icse93=2 if o28==1 & ilo_mjh==2
			replace ilo_job2_ste_icse93=3 if o28==2 & ilo_mjh==2
			/* replace ilo_job2_ste_icse93=4 if */
			replace ilo_job2_ste_icse93=5 if o28==9 & ilo_mjh==2
			replace ilo_job2_ste_icse93=6 if ilo_job2_ste_icse93==. & ilo_mjh==2
			replace ilo_job2_ste_icse93=. if ilo_job2_ste_icse93==. & ilo_mjh==2		
				* value label already defined
				label val ilo_job2_ste_icse93 label_ilo_ste_icse93
				label var ilo_job2_ste_icse93 "Status in employment (ICSE 93) in secondary job"

	* Aggregate categories
	
		gen ilo_job2_ste_aggregate=.
			replace ilo_job2_ste_aggregate=1 if ilo_job2_ste_icse93==1
			replace ilo_job2_ste_aggregate=2 if inlist(ilo_job2_ste_icse93,2,3,4,5)
			replace ilo_job2_ste_aggregate=3 if ilo_job2_ste_icse93==6
				* value label already defined
				lab val ilo_job2_ste_aggregate ste_aggr_lab
				label var ilo_job2_ste_aggregate "Status in employment (Aggregate) in secondary job" 
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

** ISIC Rev.3.1

 destring rama4, replace 
	
	gen indu_code_prim=int(rama4/100) if ilo_lfs==1
					
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
		
		  	** no info available

 			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_ocu')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment:  ISCO-08 classification used

destring oficio4, replace 	
	* Two-digits level

	gen occ_code_prim=int(oficio4/100) if ilo_lfs==1
 	
	* Primary occupation
	
	
		gen ilo_job1_ocu_isco08_2digits=occ_code_prim if occ_code_prim != 99
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
			
		* Secondary occupation
	
				** no info available
			
	** 1 digit level
		destring oficio1, replace force	
		gen occ_code_prim_1dig=oficio1 if ilo_lfs==1
 	
		* Primary activity
		
		gen ilo_job1_ocu_isco08=occ_code_prim_1dig
			replace ilo_job1_ocu_isco08=10 if ilo_job1_ocu_isco08==0
			replace ilo_job1_ocu_isco08=11 if ilo_job1_ocu_isco08==. & ilo_lfs==1
				replace ilo_job1_ocu_isco08=. if ilo_lfs!=1
			lab def isco08_1dig_lab 1 "1 - Managers" 2 "2 - Professionals" 3 "3 - Technicians and associate professionals" 4 "4 - Clerical support workers" 5 "5 - Service and sales workers" ///
									6 "6 - Skilled agricultural, forestry and fishery workers" 7 "7 - Craft and related trades workers" 8 "8 - Plant and machine operators, and assemblers" ///
									9 "9 - Elementary occupations" 10 "0 - Armed forces occupations" 11 "X - Not elsewhere classified"
			lab val ilo_job1_ocu_isco08 isco08_1dig_lab
			lab var ilo_job1_ocu_isco08 "Occupation (ISCO-08)"	
			
		* Secondary activity
		
				** no info available
				
				
	** Aggregate level
	
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
				
		* Secondary occupation
		
		    ** no info available
				
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
				
		* Secondary occupation 
		
		  ** no info available
 	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_ins_sector')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
		
	* Primary occupation
	
	 gen ilo_job1_ins_sector=.
		replace ilo_job1_ins_sector=1 if inlist(o15,3,4) | o15==8
		replace ilo_job1_ins_sector=2 if ilo_job1_ins_sector!=1 & ilo_lfs==1
		replace ilo_job1_ins_sector=. if ilo_lfs!=1
			lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
			lab values ilo_job1_ins_sector ins_sector_lab
			lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities"	
			
	* Secondary occupation
	
	gen ilo_job2_ins_sector=.
		replace ilo_job2_ins_sector=1 if inlist(o28,3,4) | o28==8
		replace ilo_job2_ins_sector=2 if ilo_job2_ins_sector!=1 & ilo_mjh==2
		replace ilo_job2_ins_sector=. if ilo_mjh!=2
			* value label already defined
			lab values ilo_job2_ins_sector ins_sector_lab
			lab var ilo_job2_ins_sector "Institutional sector (private/public) of economic activities in secondary job"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*		1. 	Hours of work actually worked ('ilo_job1_how_actual')   
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

** MAIN JOB

gen ilo_job1_how_actual = o10 if ilo_lfs == 1
		
		replace ilo_job1_how_actual = . if ilo_job1_how_actual == 999 & ilo_lfs==1
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
	
* Comment: jornada prolongada "extended workday" (o18==3)- more than 60 hours per week: full-time
	
		gen ilo_job1_job_time=.
			replace ilo_job1_job_time=1 if o18==2
			replace ilo_job1_job_time=2 if inlist(o18,1,3)
			replace ilo_job1_job_time=3 if ilo_job1_job_time==. & ilo_lfs==1
			replace ilo_job1_job_time=. if ilo_lfs!=1
				lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
				lab val ilo_job1_job_time job_time_lab
				lab var ilo_job1_job_time "Job (Working time arrangement)"
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job_contract')  
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
 
	gen ilo_job1_job_contract=.
		replace ilo_job1_job_contract=1 if o16==1
		replace ilo_job1_job_contract=2 if o16==2
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

* Comment: Useful questions:	* o15: Status in employment
								* o15: Institutional sector 
								* [no useful question]: Destination of production 
								* no info: Bookkeeping
								* no info: Registration						
								* [no info]: Location of workplace 
								* o23: Size of the establishment					
								
								* Social security 
									* o29(1-6): Pension fund
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
 capture gen ytrabajocor = ytrabaj	 
	gen ilo_job1_lri_ees = ytrabajocor if  ilo_job1_ste_aggregate==1 
			*replace ilo_job1_lri_ees=. if ytrabajocor==. & ilo_job1_ste_aggregate==1 
				lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"
		 
		 
*** Self-employed			 
	gen ilo_job1_lri_slf = ytrabajocor if  ilo_job1_ste_aggregate==2  
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
           
* Comment: hour threshold established at 45 hours.  

 		gen ilo_joball_tru=.
			replace ilo_joball_tru=1 if (ilo_job1_how_actual<45 & o11==1 & ilo_lfs==1)
				lab def tru_lab 1 "Time-related underemployment"
				lab val ilo_joball_tru tru_lab
				lab var ilo_joball_tru "Time-related underemployment"	

*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Cases of non-fatal occupational injury ('ilo_joball_oi_case')  
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------

 
** Comment: work-related illness or accident


	if ${time} ==2013 {
		gen ILO_injury = s17
	}
	
	if ${time} ==2011 {
		gen ILO_injury = s20
	}		

			gen ilo_joball_oi_case = .
				replace ilo_joball_oi_case = 1 if inlist(ILO_injury,1,3) 
					lab def joball_oi_case_lab 1 "Cases of non-fatal occupational injury" 
					lab val ilo_joball_oi_case joball_oi_case_lab
					lab var ilo_joball_oi_case "Cases of non-fatal occupational injury"
	drop ILO_injury									
 
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

* Comment.- variable used: o8 number of weeks looking for a job


	 gen ilo_dur_details=.
		replace ilo_dur_details=1 if inrange(o8,0,3)
		replace ilo_dur_details=2 if inrange(o8,4,11)
		replace ilo_dur_details=3 if inrange(o8,12,23)
		replace ilo_dur_details=4 if inrange(o8,24,47)
		replace ilo_dur_details=5 if inrange(o8,48,95)
		replace ilo_dur_details=6 if o8>=96 & o8!=.
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


	gen ilo_cat_une=.
		replace ilo_cat_une=1 if o4==1
		replace ilo_cat_une=2 if o4==2
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

** Comment: This variable cannot be computed due to both, the skip patterns and some information not available. 
		

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reasons for not seeking a job ('ilo_olf_reason')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

**  Comment: variable used.- o7r1 

	gen ilo_olf_reason=.
		replace ilo_olf_reason=1 if inlist(o7r1,7,8,9,14)
        replace ilo_olf_reason=2 if inlist(o7r1,2,15)
        replace ilo_olf_reason=3 if inrange(o7r1,3,6) | inlist(o7r1,10,11)
		replace ilo_olf_reason=4 if inlist(o7r1,12,13,16)
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
