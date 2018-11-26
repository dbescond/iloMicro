* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Zimbabwe LFS
* DATASET USED: Zimbabwe LFS 2011
* NOTES:
* Authors: ILO / Department of Statistics / DPAU

* Starting Date: 11/10/2017
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
global country "ZWE"
global source "LFS"
global time "2011"
global inputFile "Labour-Force - 2011 data - Anonymised.dta"
global inpath "${path}\\${country}\\${source}\\${time}\ORI"
global outpath "${path}\\${country}\\${source}\\${time}"

***********************************
************************************************************************************

* Important : if package « labutil » not already installed, install it in order to execute correctly the do-file

* ssc install labutil

************************************************************************************

*********************************************************************************************

* Load original dataset

*********************************************************************************************

cd "$inpath"
	use "$inputFile", clear
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

	gen ilo_wgt=.
		replace ilo_wgt = wt
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

	gen ilo_geo = .
		replace ilo_geo = 1 if urban_rural == 1		// 1 - Urban
		replace ilo_geo = 2 if  urban_rural == 2	// 2 - Rural
		replace ilo_geo = 3 if  ilo_geo ==.			// 3 - Not elsewhere classified
		lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural" 3 "3 - Not elsewhere classified"
		lab val ilo_geo ilo_geo_lab
		lab var ilo_geo "Geographical coverage"	


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_sex = q4
		lab def ilo_sex_lab 1 "1 - Male" 2 "2 - Female"
		lab var ilo_sex "Sex"
		lab val ilo_sex ilo_sex_lab
	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_age = q5
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

** Comment: - The categories from the original variable matches better with isced 97 because of the tertiary education is not given in disaggregated levels. 
** Comment: - Is the only variable possible the ilo_edu_aggregate? The dataset gives the information on the tertiary education without making distintion among stages. 

	
	gen ilo_edu_isced97=.
		replace ilo_edu_isced97 = 1 if q13 == 88  				// X - No schooling
		replace ilo_edu_isced97 = 2 if q13 == 0					// 0 - Pre-primary education
		replace ilo_edu_isced97 = 3 if inrange(q13,1,7)         // 1 - Primary education or first stage of basic education
		replace ilo_edu_isced97 = 4 if inrange(q13,11,14)       // 2 - Lower secondary or second stage of basic education
		replace ilo_edu_isced97 = 5 if inlist(q13,15,16)        // 3 - Upper secondary education
		*replace ilo_edu_isced97=6 if                         	// 4 - Post-secondary non-tertiary education
		replace ilo_edu_isced97 = 7 if q13 == 23       	        // 5 - First stage of tertiary education (not leading directly to an advanced research qualification)
		*replace ilo_edu_isced97=8 if    				        // 6 - Second stage of tertiary education (leading to an advanced research qualification)
		replace ilo_edu_isced97 = 9 if q13 == 99                // UNK - Level  not stated
			label def isced_97_lab 1 "X - No schooling" 2 "0 - Pre-primary education" 3 "1 - Primary education or first stage of basic education" 4 "2 - Lower secondary education or second stage of basic education" ///
							       5 "3 - Upper secondary education" 6 "4 - Post-secondary non-tertiary education" 7 "5 - First stage of tertiary education (not leading directly to an advanced research qualification)" ///
							       8 "6 - Second stage of tertiary education (leading to an advanced research qualification)" 9 "UNK - Level not stated"
			label val ilo_edu_isced97 isced_97_lab
			lab var ilo_edu_isced97 "Education (ISCED 97)"

		
	gen ilo_edu_aggregate = .
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

* 'ilo_edu_attendance' refers to current enrolment, therefore here it is taking into account
* students attending to any type of education or training in the last 4 weeks and students in holidays

*** Comment: - variable q11 refers whether the individual has ever attended school. 
***				q11 = 2: at school; q11 == 1: never attending (therefore not currently at school)
***             q13 = 3: left school 
	
		gen ilo_edu_attendance = .
		replace ilo_edu_attendance = 1 if q11 == 2                        // 1 - Attending
		replace ilo_edu_attendance = 2 if inlist(q11,1,3)                //  2 - Not attending
		replace ilo_edu_attendance = 3 if  q11 ==  9                      // 3 - Not elsewhere classified
		lab def edu_attendance_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
		lab val ilo_edu_attendance edu_attendance_lab
		lab var ilo_edu_attendance "Education (Attendance)"


* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			           Marital status ('ilo_mrts') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: marital status is asked to the population aged 12 yrs and above
	
	* Detailed
	gen ilo_mrts_details=.
	    replace ilo_mrts_details=1 if q8==1                                          // Single
		replace ilo_mrts_details=2 if q8==2                                          // Married
		*replace ilo_mrts_details=3 if                                           // Union / cohabiting
		replace ilo_mrts_details=4 if q8==4                                          // Widowed
		replace ilo_mrts_details=5 if q8==3                                          // Divorced / separated
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

** No information available


* --------------------------------------------------------------------------------------------
***********************************************************************************************
*			PART 3. ECONOMIC SITUATION
***********************************************************************************************
* ---------------------------------------------------------------------------------------------		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working age population ('ilo_wap')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

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

** Comment: - There is no information about future starters. 

gen ilo_lfs =.

		** EMPLOYED
		replace ilo_lfs=1 if q21==1 & ilo_wap==1         		// Employed (persons at work/family business)
		replace ilo_lfs=1 if q22==1 & ilo_wap==1         		//Employed (absent)
		
		** UNEMPLOYED
		replace ilo_lfs=2 if ilo_lfs!=1 & q47==1 & q48==1 & ilo_wap==1 // Not in employment, seeking (actively), available
		
		** OUTSIDE LABOUR FORCE
		replace ilo_lfs=3 if ilo_lfs!=1 & ilo_lfs!=2 & ilo_wap==1 // Not in employment, future job starters

		label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside the Labour Force"
		label value ilo_lfs label_ilo_lfs
		label var ilo_lfs "Labour Force Status"

	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
 
** Comment: - I have categorised the missing observations as people with one job only

gen  ilo_mjh = .

** - 1. One job only

	replace ilo_mjh = 1 if  inlist(q36,2,9) & ilo_lfs == 1

** - 2. More than one job

	replace ilo_mjh = 2 if q36 == 1 & ilo_lfs == 1

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

 *** Comment: there is no information about cooperatives on the characteristics for main and second job. 
 
**** MAIN JOB

* Detailed categories:

		gen ilo_job1_ste_icse93 = .
		
			replace ilo_job1_ste_icse93 = 1 if inlist(q23,1,2) & ilo_lfs == 1   	// Employees
			
			replace ilo_job1_ste_icse93 = 2 if q23 == 3 & ilo_lfs==1	            // Employers
			
			replace ilo_job1_ste_icse93 = 3 if inlist(q23,4,5) & ilo_lfs==1         // Own-account workers
			
			*replace ilo_job1_ste_icse93 = 4 if       			                    // Members of producers cooperatives

			replace ilo_job1_ste_icse93 = 5 if q23 == 6 & ilo_lfs==1	            // Contributing family workers
			
			replace ilo_job1_ste_icse93 = 6 if q23 == 9 & ilo_lfs==1                // Workers not classifiable by status
			
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
		
			replace ilo_job2_ste_icse93 = 1 if inlist(q37,1,2) & ilo_mjh == 2   	// Employees
			
			replace ilo_job2_ste_icse93 = 2 if q37 == 3 & ilo_mjh == 2 	            // Employers
			
			replace ilo_job2_ste_icse93 = 3 if inlist(q37,4,5) & ilo_mjh == 2       // Own-account wor
			
			*replace ilo_job2_ste_icse93 = 4       		                            // Members of producersâ€™ cooperatives

			replace ilo_job2_ste_icse93 = 5 if q37 == 6 & ilo_mjh == 2 	            // Contributing family workers
			
			replace ilo_job2_ste_icse93 = 6 if q37 == 9 & ilo_mjh == 2             // Workers not classifiable by status
			
				
				label val ilo_job2_ste_icse93 label_ilo_ste_icse93
				label var ilo_job2_ste_icse93 "Status in employment (ICSE 93) - Second job"
	
				
* Aggregate categories
 
		gen ilo_job2_ste_aggregate = . 
		
			replace ilo_job2_ste_aggregate = 1 if ilo_job2_ste_icse93 == 1  			    // Employees
			
			replace ilo_job2_ste_aggregate = 2 if inlist(ilo_job2_ste_icse93,2,3,4,5)   	// Self-employed
			
			replace ilo_job2_ste_aggregate = 3 if ilo_job2_ste_icse93 == 6  				// Not elsewhere classified
			*replace ilo_job2_ste_aggregate = 3 if ilo_job2_ste_icse93 == .  			
			
				lab val ilo_job2_ste_aggregate ste_aggr_lab
				label var ilo_job2_ste_aggregate "Status in employment (Aggregate) - Second job"  				
						


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------				

* ISIC Rev. 4

	* MAIN JOB:
	gen indu_code_prim =.
		    replace indu_code_prim = int(q30/100)

	* 2-digit level	
	gen ilo_job1_eco_isic4_2digits = indu_code_prim if ilo_lfs == 1
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
	    replace ilo_job1_eco_isic4=22 if ilo_job1_eco_isic4_2digits==. & ilo_lfs==1
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


			   
	**** SECOND JOB:
	
	gen indu_code_sec = .
	    replace indu_code_sec=int(q39/100)

	* 2-digit level	
	gen ilo_job2_eco_isic4_2digits=indu_code_sec if ilo_mjh==2
	    * labels already defined for main job
        lab val ilo_job2_eco_isic4_2digits eco_isic4_digits
        lab var ilo_job2_eco_isic4_2digits "Economic activity (ISIC Rev. 4), 2 digits levels - second job"

	* 1-digit level
    gen ilo_job2_eco_isic4=.
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
		        * labels already defined for main job		
  	  		    lab val ilo_job2_eco_isic4 eco_isic4
			    lab var ilo_job2_eco_isic4 "Economic activity (ISIC Rev. 4) - second job"

   * Aggregate level
   gen ilo_job2_eco_aggregate=.
	   replace ilo_job2_eco_aggregate=1 if ilo_job2_eco_isic4==1
	   replace ilo_job2_eco_aggregate=2 if ilo_job2_eco_isic4==3
	   replace ilo_job2_eco_aggregate=3 if ilo_job2_eco_isic4==6
	   replace ilo_job2_eco_aggregate=4 if inlist(ilo_job2_eco_isic4,2,4,5)
	   replace ilo_job2_eco_aggregate=5 if inrange(ilo_job2_eco_isic4,7,14)
	   replace ilo_job2_eco_aggregate=6 if inrange(ilo_job2_eco_isic4,15,21)
	   replace ilo_job2_eco_aggregate=7 if ilo_job2_eco_isic4==22
			   * labels already defined for main job					
			   lab val ilo_job2_eco_aggregate eco_aggr_lab
			   lab var ilo_job2_eco_aggregate "Economic activity (Aggregate) - second job"	

	
								
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_job1_ocu_isco08')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

** The original variable was coded using the Classification of Occupations ISCO-08


 * MAIN JOB	
	gen occ_code_prim=.
	    replace occ_code_prim=int(q28/100)

    * 2-digit level
	gen ilo_job1_ocu_isco08_2digits = occ_code_prim if ilo_lfs==1
	replace ilo_job1_ocu_isco08_2digits = 1 if inlist(occ_code_prim,1,3) & ilo_lfs==1
	replace ilo_job1_ocu_isco08_2digits = 21 if occ_code_prim == 0 & ilo_lfs==1

	
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
	gen occ_code_sec=.
	    replace occ_code_sec=int(q38/100)
		
    * 2-digit level		
	gen ilo_job2_ocu_isco08_2digits=occ_code_sec if ilo_mjh==2
	    * labels already defined for main job
		lab values ilo_job2_ocu_isco08_2digits ocu08_2digits
		lab var ilo_job2_ocu_isco08_2digits "Occupation (ISCO-08), 2 digit level - second job"

    * 1-digit level
	gen ilo_job2_ocu_isco08=.
	    replace ilo_job2_ocu_isco08=11 if ilo_job2_ocu_isco08_2digits==. & ilo_mjh==2     // Not elsewhere classified
		replace ilo_job2_ocu_isco08=int(ilo_job2_ocu_isco08_2digits/10) if ilo_mjh==2     // The rest of the occupations
		replace ilo_job2_ocu_isco08=10 if (ilo_job2_ocu_isco08==0 & ilo_mjh==2)           // Armed forces
	            * labels already defined for main job
				lab val ilo_job2_ocu_isco08 ocu08_1digits
				lab var ilo_job2_ocu_isco08 "Occupation (ISCO-08) - second job"
			
	* Aggregate:			
    gen ilo_job2_ocu_aggregate=.
	    replace ilo_job2_ocu_aggregate=1 if inrange(ilo_job2_ocu_isco08,1,3)   
	    replace ilo_job2_ocu_aggregate=2 if inlist(ilo_job2_ocu_isco08,4,5)
	    replace ilo_job2_ocu_aggregate=3 if inlist(ilo_job2_ocu_isco08,6,7)
	    replace ilo_job2_ocu_aggregate=4 if ilo_job2_ocu_isco08==8
	    replace ilo_job2_ocu_aggregate=5 if ilo_job2_ocu_isco08==9
	    replace ilo_job2_ocu_aggregate=6 if ilo_job2_ocu_isco08==10
	    replace ilo_job2_ocu_aggregate=7 if ilo_job2_ocu_isco08==11
		  	    * labels already defined for main job
			    lab val ilo_job2_ocu_aggregate ocu_aggr_lab
			    lab var ilo_job2_ocu_aggregate "Occupation (Aggregate) - second job"	
		
	* Skill level
	gen ilo_job2_ocu_skill=.
	    replace ilo_job2_ocu_skill=1 if ilo_job2_ocu_isco08==9                   // Low
		replace ilo_job2_ocu_skill=2 if inlist(ilo_job2_ocu_isco08,4,5,6,7,8)    // Medium
		replace ilo_job2_ocu_skill=3 if inlist(ilo_job2_ocu_isco08,1,2,3)        // High
		replace ilo_job2_ocu_skill=4 if inlist(ilo_job2_ocu_isco08,10,11)        // Not elsewhere classified
				* labels already defined for main job
			    lab val ilo_job2_ocu_skill ocu_skill_lab
			    lab var ilo_job2_ocu_skill "Occupation (Skill level) - second job"
  
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_job1_ins_sector')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

	
***** MAIN JOB *****
	 
		gen ilo_job1_ins_sector = .
			replace ilo_job1_ins_sector = 1 if inrange(q31,2,4) & ilo_lfs == 1 	// Public
			replace ilo_job1_ins_sector = 2 if !inrange(q31,2,4) & ilo_lfs == 1    // Private
				lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
			    lab values ilo_job1_ins_sector ins_sector_lab
			    lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities"

				
***** SECOND JOB *****
 
		gen ilo_job2_ins_sector = .
			replace ilo_job2_ins_sector = 1 if inrange(q40,2,4) & ilo_mjh == 2 	// Public
			replace ilo_job2_ins_sector = 2 if !inrange(q40,2,4) & ilo_mjh == 2     // Private
				*lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
			    lab values ilo_job2_ins_sector ins_sector_lab
			    lab var ilo_job2_ins_sector "Institutional sector (private/public) of economic activities"

		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job1_job_time') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			

*** Comment: - It can only be calculated for all jobs. 
*** Comment: - Part-time of full-time worker determined on the basis of the hours worked in all the jobs

*** Comment: - on p.79 of the report, they consider as "involuntary part-time workers" who reported working less than 40 hours per week and wanted to work more hours. 

	gen ilo_job1_job_time = .
		replace ilo_job1_job_time = 1 if q42 >= 40 & ilo_lfs == 1 				// 1 - Part-time
		replace ilo_job1_job_time = 2 if q42 < 40 & ilo_lfs == 1				// 2 - Full-time
		replace ilo_job1_job_time = 3 if ilo_job1_job_time == . & ilo_lfs == 1 	// 3 - Unknown
			lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknow"
			    lab values ilo_job1_job_time job_time_lab
			    lab var ilo_job1_job_time "Job (Working time arrangement)"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Hours of work actually worked ('ilo_job1_how_actual')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

*** Comment: - The variables related to working hours refer to all jobs

		gen ilo_joball_how_actual = q42 if ilo_lfs == 1
			replace ilo_joball_how_actual  = . if ilo_joball_how_actual  == 99
				lab var ilo_joball_how_actual  "Weekly hours actually worked all jobs"	      
		
		gen ilo_joball_how_actual_bands = .
			 replace ilo_joball_how_actual_bands= 1 if ilo_joball_how_actual == 0			                  	// No hours actually worked
			 replace ilo_joball_how_actual_bands= 2 if inrange(ilo_joball_how_actual,1,14)	                    // 01-14
			 replace ilo_joball_how_actual_bands= 3 if inrange(ilo_joball_how_actual,15,29)	                   	// 15-29
			 replace ilo_joball_how_actual_bands= 4 if inrange(ilo_joball_how_actual,30,34)	                   	// 30-34
			 replace ilo_joball_how_actual_bands= 5 if inrange(ilo_joball_how_actual,35,39)	                   	// 35-39
			 replace ilo_joball_how_actual_bands= 6 if inrange(ilo_joball_how_actual,40,48)	                  	// 40-48
			 replace ilo_joball_how_actual_bands= 7 if ilo_joball_how_actual>=49 & ilo_joball_how_actual !=.  	// 49+
			 replace ilo_joball_how_actual_bands= 8 if ilo_joball_how_actual_bands== .		                  	// Not elsewhere classified
 			 replace ilo_joball_how_actual_bands= . if ilo_lfs!=1
				     lab def how_bands_lab 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"
					 lab val ilo_joball_how_actual_bands how_bands_lab
					 lab var ilo_joball_how_actual_bands "Bands of weekly hours actually worked in all jobs"

		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Hours of work usually worked ('ilo_job1_how_usual') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
** Comment:- no information available. 	
	
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job1_job_contract')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
*** main job
	gen ilo_job1_job_contract=.
		replace ilo_job1_job_contract=1 if q23==1  		                 // 1 - Permanent
		replace ilo_job1_job_contract=2 if q23==2  		                 // 2 - Temporary
		replace ilo_job1_job_contract=3 if ilo_job1_job_contract == .   // 3 - Unknown
				lab def job_contract_lab 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"
			    lab val ilo_job1_job_contract job_contract_lab
			    lab var ilo_job1_job_contract "Job (Type of contract)"


*** second job
	gen ilo_job2_job_contract=.
		replace ilo_job2_job_contract=1 if q37==1                       // 1 - Permanent
		replace ilo_job2_job_contract=2 if q37==2                       // 2 - Temporary
		replace ilo_job2_job_contract=3 if ilo_job2_job_contract == .   // 3 - Unknown
				*lab def job_contract_lab 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"
			    lab val ilo_job2_job_contract job_contract_lab
			    lab var ilo_job2_job_contract "Job (Type of contract)"

	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Formal / Informal Economy ('ilo_job1_ife_prod' 'ilo_job1_ife_nature')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			

** Acording to the 2011 LFCLS report, a production unit was considered to be in the informal sector if the
** establishment was neither registered with the Registrar of Companies nor licensed.

/* Useful questions:
			- Institutional sector: q31
			- Destination of production:    ***
			- Bookkeeping: ***
			- Registration: q33
			- Household identification: ilo_job1_eco_isic4_2digits==97 or ilo_job1_ocu_isco08_2digits==63
			- Social security contribution: q24
			- Place of work:  ***
			- Size:***
			- Status in employment: ilo_job1_ste_aggregate / ilo_job1_ste_icse93
			- Paid annual leave: q25
			- Paid sick leave: q26
*/
	
	* 1) UNIT OF PRODUCTION: FORMAL/INFORMAL SECTOR		
    	
		gen ilo_job1_ife_prod=.
			replace ilo_job1_ife_prod=3 if ilo_lfs==1 & (ilo_job1_eco_isic4_2digits==97 | ilo_job1_ocu_isco08_2digits==63) 
            replace ilo_job1_ife_prod=2 if ilo_lfs==1 & (inlist(q31,2,3,4) | (inlist(q31,1,5,6,7,8,9) & inrange(q33,1,3)))
			replace ilo_job1_ife_prod=1 if ilo_lfs==1 & !inlist(ilo_job1_ife_prod,3,2)                  
				        lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 
						lab val ilo_job1_ife_prod ilo_ife_prod_lab
						lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"
						

	* 2) NATURE OF JOB: FORMAL/INFORMAL EMPLOYMENT
	
	       gen ilo_job1_ife_nature=.
		      replace ilo_job1_ife_nature=2 if ilo_lfs==1 & ((inlist(ilo_job1_ste_icse93,1,6) & q24==1) | ///
												(inlist(ilo_job1_ste_icse93,1,6) & inlist(q24,0,3,4,9) & q25==1 & q26==1) | ///
												(inlist(ilo_job1_ste_icse93,2,3,4) & ilo_job1_ife_prod==2))
			  replace ilo_job1_ife_nature=1 if ilo_lfs==1 & ilo_job1_ife_nature!=2
			          
					  lab def ife_nature_lab 1 "1 - Persons with informal main job" 2 "2 - Persons with formal main job"
			          lab val ilo_job1_ife_nature ife_nature_lab
			          lab var ilo_job1_ife_nature "Informal / Formal Economy (Nature of job)"
	
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Monthly related income ('ilo_job1_lri_ees' and 'ilo_job1_lri_slf')   
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: - The income if asked monthly
* Currency: US$
** Variables:
*		q53: in chash main job
* 		q54: in kind main job

***

* Mid point of the intervals. 
		*gen monthly_amount = q53_mid + q54_mid
	
********* MAIN JOB
		
** IN CASH

		gen q53_mid = 50 if q53 == 2   				// US$1 to  US$100
			replace q53_mid = 150 if q53 == 3   	// US$101 to  US$200
			replace q53_mid = 250 if q53 == 4    	// US$201 to  US$300
			replace q53_mid = 350 if q53 == 5    	// US$301 to  US$400
			replace q53_mid = 450 if q53 == 6   	// US$401 to  US$500
			replace q53_mid = 750 if q53 == 7   	// US$501 to  US$1000
			replace q53_mid = 2000 if q53 == 8   	// US$1001 to  US$3000
			replace q53_mid = 3000 if q53 == 9   	// US$3001 and above
			replace q53_mid = 0 if q53 == 1   		// Zero
			replace q53_mid = . if q53 == 99   		// Missing
			

** IN KIND

		gen q54_mid = 50 if q54 == 2    			// US$1 to  US$100
			replace q54_mid = 150 if q54 == 3   	// US$101 to  US$200
			replace q54_mid = 250 if q54 == 4    	// US$201 to  US$300
			replace q54_mid = 350 if q54 == 5   	// US$301 to  US$400
			replace q54_mid = 450 if q54 == 6    	// US$401 to  US$500
			replace q54_mid = 750 if q54 == 7    	// US$501 to  US$1000
			replace q54_mid = 2000 if q54 == 8    	// US$1001 to  US$3000
			replace q54_mid = 3000 if q54 == 9    	// US$3001 and above
			replace q54_mid = 0 if q54 == 1    		// Zero
			replace q54_mid = . if q54 == 99   		// Missing			
			
*****

	** Bands (not necessary in the code). 		
	
*gen total_amount_bands = .
			 *replace total_amount_bands = 1 if total_amount == 0 & ilo_job1_ste_aggregate==1 // Zero
			 *replace total_amount_bands = 2 if total_amount >= 1 & total_amount <= 100 & ilo_job1_ste_aggregate==1  //  US$1 to US$100
			 *replace total_amount_bands = 3 if total_amount >= 101 & total_amount <= 200 & ilo_job1_ste_aggregate==1 // US$101 to US$200
			 *replace total_amount_bands = 4 if total_amount >= 201 & total_amount <= 300 & ilo_job1_ste_aggregate==1 //  US$201 to US$300
			 *replace total_amount_bands = 5 if total_amount >= 301 & total_amount <= 400 & ilo_job1_ste_aggregate==1 // US$301 to US$400
			 *replace total_amount_bands = 6 if total_amount >= 401 & total_amount <= 500 & ilo_job1_ste_aggregate==1 // US$401 to US$500
			 *replace total_amount_bands = 7 if total_amount >= 501 & total_amount <= 1000 & ilo_job1_ste_aggregate==1  // US$501 to US$1000
			 *replace total_amount_bands = 8 if total_amount >= 1001 & total_amount <= 3000 & ilo_job1_ste_aggregate==1   // US$1001 to US$3000
			 *replace total_amount_bands = 9 if total_amount >= 3000 & total_amount != . & ilo_job1_ste_aggregate==1  // US$3001 and above
     		 *replace total_amount_bands = 10 if total_amount == . & ilo_job1_ste_aggregate==1         // Missing		
	 
				*	 lab def total_amount_bands_lab   1 "Zero" 2 "US$1 to US$100" 3 "US$101 to US$200" /// 
				*												4 "US$201 to US$300" 5 "US$301 to US$400"  6 "US$401 to US$500" ///
				*												7 "US$501 to US$1000" 8 "US$1001 to US$3000" 9 "US$3001 and above"  ///
				*												10 "Missing"
																
				*	lab val total_amount_bands total_amount_bands_lab											
				*	 lab var total_amount_bands  "Monthy income (in chash and/or kind) in main job"
				 
*****
					 
* Final amount: CASH+KIND
	
 *** Employees		
		 
	egen ilo_job1_lri_ees = rowtotal(q53_mid  q54_mid) if  ilo_job1_ste_aggregate==1 ,m 
			*replace ilo_job1_lri_ees=. if  ilo_job1_ste_aggregate==1 
			lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"
		 
		 
*** Self-employed			 
	egen ilo_job1_lri_slf = rowtotal(q53_mid  q54_mid) if  ilo_job1_ste_aggregate==2 ,m 
			*replace ilo_job1_lri_ees=. if  ilo_job1_ste_aggregate==1 
			lab var ilo_job1_lri_slf "Monthly labour related income of self-employed in main job"	 
		 
	 
********* ALL JOBS
** In cash or kind

gen q55_mid = 50 if q55 == 2    // US$1 to  US$100
			replace q55_mid = 150 if q55 == 3   // US$101 to  US$200
			replace q55_mid = 250 if q55 == 4    // US$201 to  US$300
			replace q55_mid = 350 if q55 == 5   // US$301 to  US$400
			replace q55_mid = 450 if q55 == 6    // US$401 to  US$500
			replace q55_mid = 750 if q55 == 7    // US$501 to  US$1000
			replace q55_mid = 2000 if q55 == 8    // US$1001 to  US$3000
			replace q55_mid = 3000 if q55 == 9    // US$3001 and above
			replace q55_mid = 0 if q55 == 1    // Zero
			replace q55_mid = . if q55 == 99   // Missing		


*** Employees	
			 
	gen ilo_joball_lri_ees=.
	 replace ilo_joball_lri_ees = q55_mid if ilo_job1_ste_aggregate == 1                
		   lab var ilo_joball_lri_ees "Monthly earnings of employees in all jobs"
		   
		   
*** Self-employed			   
	gen ilo_joball_lri_slf=.
	 replace ilo_joball_lri_slf = q55_mid if ilo_job1_ste_aggregate == 2                
		   lab var ilo_joball_lri_slf "Monthly labour related income of self-employed in all jobs"
 

				
***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_joball_tru')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
 
 *** Comment: - the variable related to worked less than a threshold used is 'ilo_job1_how_actual' because it is not possible to compute 'ilo_job1_how_usual'
		
		gen ilo_joball_tru = .
		replace ilo_joball_tru = 1 if  q43 == 1 & q44 != . & ilo_joball_how_actual < 40
			lab def lab_joball_tru 1 "Time-related underemployed" 
			lab val ilo_joball_tru lab_joball_tru
			lab var ilo_joball_tru "Time-related underemployed"

  
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Cases of non-fatal occupational injury ('ilo_joball_oi_case')
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------

	gen ilo_joball_oi_case = .
		replace ilo_joball_oi_case = 1 if inlist(q70,1,3) 
			lab def lab_ilo_joball_oi_case 1 "Cases of non-fatal occupational injury" 
			lab val ilo_joball_oi_case lab_joball_oi_case
			lab var ilo_joball_oi_case "Cases of non-fatal occupational injury"


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

	gen ilo_cat_une = .
		replace ilo_cat_une = 1 if q51 == 1 & ilo_lfs == 2					// 1 - Unemployed previously employed
		replace ilo_cat_une = 2 if q51 == 2 & q48 == 1 & ilo_lfs == 2		// 2 - Unemployed seeking their first job
		replace ilo_cat_une = 3 if  ilo_cat_une == . & ilo_lfs == 2 		// 3 - Unknown
			lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
			    lab values ilo_cat_une cat_une_lab
			    lab var ilo_cat_une "Category of unemployment"
				

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

*** No information 


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

*** No information
				
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

*** No information
			  
				  
***********************************************************************************************
*			PART 3.4. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************		

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		.	
							
				
	gen ilo_olf_dlma = .
		
		** Comment: it seems that there is no individuals seeking but not available      
		replace ilo_olf_dlma = 1 if ilo_lfs == 3 & (q48 == 1 & q49 != 9) & q47 == 2 		// Seeking (actively), not available
		replace ilo_olf_dlma = 2 if ilo_lfs == 3 & q48 == 2 & q47 == 1 			            // Not seeking, available
		** no information for willingness
		*replace ilo_olf_dlma = 3 if ilo_lfs == 3 & q48 == 2 & q47 == 1 & 	                // Not seeking, not available, willing  
		*replace ilo_olf_dlma = 4 if ilo_lfs == 3 & q48 == 2 & q47 == 1 & 			        // Not seeking, not available, not willing  
		replace ilo_olf_dlma = 5 if	ilo_olf_dlma == . & ilo_lfs == 3				        // Not classified 
				lab def dlma_lab 1 "1 - Seeking, not available (Unavailable jobseekers)" 2 "2 - Not seeking, available (Available potential jobseekers)" ///
	    						 3 "3 - Not seeking, not available, willing (Willing non-jobseekers)" 4 "4 - Not seeking, not available, not willing" 5 "X - Not elsewhere classified"
		    	lab val ilo_olf_dlma dlma_lab 
			    lab var ilo_olf_dlma "Labour market attachment (Degree of)"
			
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reason for not seeking job ('ilo_olf_reason')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

	gen ilo_olf_reason = .
			*replace ilo_olf_reason = 1 if  // Labour market
			*replace ilo_olf_reason=2 if                                      	// Other labour market reasons
			replace ilo_olf_reason = 3 if inlist(q50,1,2,5)  & ilo_lfs==3    	// Personal/Family-related
			replace ilo_olf_reason=4 if inlist(q50,3,4)  & ilo_lfs==3		    // Does not need/want to work
			replace ilo_olf_reason=5 if q50 == 9 & ilo_lfs==3	      			// Not elsewhere classified
			replace ilo_olf_reason=5 if ilo_olf_reason==. & ilo_lfs==3	      	// Not elsewhere classified
				    lab def reasons_lab 1 "1 - Labour market" 2 "2 - Other labour market reasons" 3 "3 - Personal / Family-related" ///
									    4 "4 - Does not need/want to work" 5 "5 - Not elsewhere classified"
				    lab val ilo_olf_reason reasons_lab 
				    lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"			


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seeker ('ilo_dis')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

** No information available 

			
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
	
		keep ilo*

		save ${country}_${source}_${time}_ILO, replace
				
