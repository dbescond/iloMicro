* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Bangladesh, 2013
* DATASET USED: Bangladesh LFS 2013
* NOTES: 
* Authors: ILO / Department of Statistics / DPAU

* Starting Date: 22 September 2016
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
global country "BGD"
global source "LFS"
global time "2013"
global inputFile "BGD2013.dta"
global inpath "${path}\\${country}\\${source}\\${time}\ORI"
global temppath "${path}\_Admin"
global outpath "${path}\\${country}\\${source}\\${time}"


********************************************************************************
********************************************************************************

cd "$inpath"
	use ${inputFile}, clear
	*renaming everything in lower case
	rename *, lower  
	
********************************************************************************
********************************************************************************
*                                                                              *
*			                      2. MAP VARIABLES                             *
*                                                                              *
********************************************************************************
********************************************************************************
	
* ---------------------------------------------------------------------------------------------
***********************************************************************************************
*			PART 1. DATASET SETTINGS VARIABLES
***********************************************************************************************
* ---------------------------------------------------------------------------------------------

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Key identifier ('ilo_key') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment:

	gen ilo_key=_n
		lab var ilo_key "Key unique identifier per individual"		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sample Weight ('ilo_wgt') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment:

	gen ilo_wgt=wgt_final
		lab var ilo_wgt "Sample weight"		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time period ('ilo_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment:

	gen ilo_time=1
		lab def lab_time 1 "$time"
		lab val ilo_time lab_time
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
* Comment:

	gen ilo_geo=.
		replace ilo_geo=1 if urb==2
		replace ilo_geo=2 if urb==1
			lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural"
			lab val ilo_geo ilo_geo_lab
			lab var ilo_geo "Geographical coverage"	
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: 

	gen ilo_sex=sex
		lab def ilo_sex_lab 1 "1 - Male" 2 "2 - Female"
		lab var ilo_sex "Sex"
		lab val ilo_sex ilo_sex_lab
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Commnent:

	gen ilo_age=age
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
*			Education ('ilo_edu') [done] 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - ISCED 11 mapping: based on the mapping developed by UNESCO
*			 (http://uis.unesco.org/en/isced-mappings)
*          - Original question is only asked to 5+, therefore below 5 years old are classified
*            under "Level not stated" along with those who actually answered "other".	

	gen ilo_edu_isced11=.
		replace ilo_edu_isced11=1 if class==1  					                // No schooling
		replace ilo_edu_isced11=1 if q26==2 					                // No schooling
		replace ilo_edu_isced11=2 if inrange(class,2,5)  		                // Early childhood education
		replace ilo_edu_isced11=3 if inrange(class,6,8) 		                // Primary education
		replace ilo_edu_isced11=4 if inrange(class,9,10)   		                // Lower secondary education
		replace ilo_edu_isced11=5 if inrange(class,11,13)  		                // Upper secondary education
		replace ilo_edu_isced11=6 if class==14 					                // Post-secondary non-tertiary
		*replace ilo_edu_isced11=7 if 					 		                // Short-cycle tertiary education
		replace ilo_edu_isced11=8 if class==15  				                // Bachelor or equivalent
		replace ilo_edu_isced11=9 if class==16  				                // Master's or equivalent level
		replace ilo_edu_isced11=10 if class==17  				                // Doctoral or equivalent level
		replace ilo_edu_isced11=11 if class==19 				                // Not elsewhere classified
		replace ilo_edu_isced11=11 if ilo_age<5 				                // Not elsewhere classified
			    label def isced_11_lab 1 "X - No schooling" 2 "0 - Early childhood education" 3 "1 - Primary education" 4 "2 - Lower secondary education" ///
							           5 "3 - Upper secondary education" 6 "4 - Post-secondary non-tertiary education" 7 "5 - Short-cycle tertiary education" ///
							           8 "6 - Bachelor's or equivalent level" 9 "7 - Master's or equivalent level" 10 "8 - Doctoral or equivalent level" 11 "9 - Not elsewhere classified"
			    label val ilo_edu_isced11 isced_11_lab
			    lab var ilo_edu_isced11 "Education (ISCED 11)"	
	
			
	* Aggregate level	
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
*			Education attendance ('ilo_edu_attendance') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: 

	gen ilo_edu_attendance=.
		replace ilo_edu_attendance=1 if student==1				                // Attending
		replace ilo_edu_attendance=2 if student==2				                // Not attending
		replace ilo_edu_attendance=3 if student==.                              // Not elsewhere classified
			label def edu_att_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
			label val ilo_edu_attendance edu_att_lab
			label var ilo_edu_attendance "Education (Attendance)"


* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			           Marital status ('ilo_mrts') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: Variables.- q23_a: ever married; q23_b: current marital status (if ever married)
** There is no info on union/cohabiting. 
	
	* Detailed
	gen ilo_mrts_details=.
	    replace ilo_mrts_details=1 if q23_a==2                                    // Single
		replace ilo_mrts_details=2 if q23_b==1                                    // Married
		*replace ilo_mrts_details=3 if                                          // Union / cohabiting
		replace ilo_mrts_details=4 if q23_b==2                                    // Widowed
		replace ilo_mrts_details=5 if inlist(q23_b,3,4)                           // Divorced / separated
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
*			Disability status ('ilo_dsb') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment: No information available.
	
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
			lab def wap_lab 1 "Working age population"
			lab val ilo_wap wap_lab
			label var ilo_wap "Working age population"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Labour Force Status ('ilo_lfs') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Employment: for questions 39 and 42 is assumed that the business/farm sells at 
*            least a part of its production	in the market. 
*          - Unemployment: options 1 and 4 in question 86 (was waiting for work and awaiting for
*            setting self business) are assummed to be refering to future starters and therefore
*            included into unemployment.
		  
	gen ilo_lfs=.
		replace ilo_lfs=1 if (q39==1 & ilo_wap==1) 		                                         // Employed (self-employed)
		replace ilo_lfs=1 if (q40==1 & ilo_wap==1) 		                                         // Employed (employee)
		replace ilo_lfs=1 if (q41==1 & ilo_wap==1) 		                                         // Employed (domestic workers)
		replace ilo_lfs=1 if (q42==1 & ilo_wap==1) 		                                         // Employed (contributing family member)
		replace ilo_lfs=1 if (q43==1 & ilo_wap==1) 		                                         // Employed (temporary absent)
		replace ilo_lfs=2 if ilo_wap==1 & ilo_lfs==. & ((q84==1 & q87==1) | (q86==1 | q86==4))   // (seeking and available (or) future starters)
		replace ilo_lfs=3 if ilo_lfs==. & ilo_wap==1  		                                     // Outside the labour force
				label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside the Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: 

	gen ilo_mjh=.
		replace ilo_mjh=2 if q60_job2==1 & ilo_lfs==1
		replace ilo_mjh=1 if q60_job2!=1 & ilo_lfs==1
			    lab def lab_ilo_mjh 1 "1 - One job only" 2 "2 - More than one job"
			    lab val ilo_mjh lab_ilo_mjh
			    lab var ilo_mjh "Multiple job holders"

***********************************************************************************************
*			PART 3.1. ECONOMIC CHARACTERISTICS FOR MAIN JOB 
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Status in employment ('ilo_job1_ste') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: 

    * MAIN JOB:
	gen ilo_job1_ste_icse93=.
		replace ilo_job1_ste_icse93=1 if inlist(q48,5,6,7,8,9) & ilo_lfs==1	// Employees
		replace ilo_job1_ste_icse93=2 if q48==1	& ilo_lfs==1			// Employers
		replace ilo_job1_ste_icse93=3 if inlist(q48,2,3) & ilo_lfs==1	// Own-account workers
		*replace ilo_job1_ste_icse93=4 if								// Producer cooperatives
	    replace ilo_job1_ste_icse93=5 if q48==4	& ilo_lfs==1			// Contributing family workers
		replace ilo_job1_ste_icse93=6 if ilo_job1_ste_icse93==. & ilo_lfs==1	// Not classifiable
				label def label_ilo_ste_icse93 1 "1 - Employees" 2 "2 - Employers" 3 "3 - Own-account workers"  ///
											   4 "4 - Members of producers cooperatives" 5 "5 - Contributing family workers" ///
											   6 "6 - Workers not classifiable by status"
				label val ilo_job1_ste_icse93 label_ilo_ste_icse93
				label var ilo_job1_ste_icse93 "Status in employment (ICSE 93) - main job"
	
	* Aggregate categories 
	gen ilo_job1_ste_aggregate=.
		replace ilo_job1_ste_aggregate=1 if ilo_job1_ste_icse93==1				// Employees
		replace ilo_job1_ste_aggregate=2 if inrange(ilo_job1_ste_icse93,2,5)	// Self-employed
		replace ilo_job1_ste_aggregate=3 if ilo_job1_ste_icse93==6				// Not elsewhere classified
				lab def ste_aggr_lab 1 "1 - Employees" 2 "2 - Self-employed" 3 "3 - Not elsewhere classified"
				lab val ilo_job1_ste_aggregate ste_aggr_lab
				label var ilo_job1_ste_aggregate "Status in employment (Aggregate) - main job"  

			
    * SECOND JOB:
	gen ilo_job2_ste_icse93=.
		replace ilo_job2_ste_icse93=1 if inlist(q63_status2,5,6,7,8,9) & ilo_mjh==2	// Employees
		replace ilo_job2_ste_icse93=2 if q63_status2==1	& ilo_mjh==2			// Employers
		replace ilo_job2_ste_icse93=3 if inlist(q63_status2,2,3) & ilo_mjh==2	// Own-account workers
		*replace ilo_job2_ste_icse93=4 if								        // Producer cooperatives
		replace ilo_job2_ste_icse93=5 if q63_status2==4	& ilo_mjh==2			// Contributing family workers
		replace ilo_job2_ste_icse93=6 if ilo_job2_ste_icse93==. & ilo_mjh==2  // Not classifiable
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
*			Economic activity ('ilo_eco') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Classification used: BSIC 2009, based on ISIC Rev. 4 (at 2 digits-level)
			

	* MAIN JOB:
	* ISIC Rev. 4 - 2 digit
    gen ilo_job1_eco_isic4_2digits = int(q45/100) if ilo_lfs==1
			    lab def eco_isic4_2digits 1 "01 - Crop and animal production, hunting and related service activities"	2 "02 - Forestry and logging"	3 "03 - Fishing and aquaculture"	5 "05 - Mining of coal and lignite" ///
                                          6 "06 - Extraction of crude petroleum and natural gas"	7 "07 - Mining of metal ores"	8 "08 - Other mining and quarrying"	9 "09 - Mining support service activities" ///
                                          10 "10 - Manufacture of food products"	11 "11 - Manufacture of beverages"	12 "12 - Manufacture of tobacco products"	13 "13 - Manufacture of textiles" ///
                                          14 "14 - Manufacture of wearing apparel"	15 "15 - Manufacture of leather and related products"	16 "16 - Manufacture of wood and of products of wood and cork, except furniture; manufacture of articles of straw and plaiting materials"	17 "17 - Manufacture of paper and paper products" ///
                                          18 "18 - Printing and reproduction of recorded media"	19 "19 - Manufacture of coke and refined petroleum products"	20 "20 - Manufacture of chemicals and chemical products"	21 "21 - Manufacture of pharmaceuticals, medicinal chemical and botanical products" ///
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
                lab val ilo_job1_eco_isic4_2digits eco_isic4_2digits
                lab var ilo_job1_eco_isic4_2digits "Economic activity (ISIC Rev. 4), 2 digits level - main job"
				
	
	* ISIC Rev. 4 - 1 digit
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
	    replace ilo_job1_eco_isic4=22 if ilo_job1_eco_isic4==. & ilo_lfs==1 
		        lab def eco_isic4_1digit 1 "A - Agriculture, forestry and fishing"	2 "B - Mining and quarrying"	3 "C - Manufacturing"	4 "D - Electricity, gas, steam and air conditioning supply" ///
                                         5 "E - Water supply; sewerage, waste management and remediation activities"	6 "F - Construction"	7 "G - Wholesale and retail trade; repair of motor vehicles and motorcycles"	8 "H - Transportation and storage" ///
                                         9 "I - Accommodation and food service activities"	10 "J - Information and communication"	11 "K - Financial and insurance activities"	12 "L - Real estate activities" ///
                                         13 "M - Professional, scientific and technical activities"	14 "N - Administrative and support service activities"	15 "O - Public administration and defence; compulsory social security"	16 "P - Education" ///
                                         17 "Q - Human health and social work activities"	18 "R - Arts, entertainment and recreation"	19 "S - Other service activities"	20 "T - Activities of households as employers; undifferentiated goods- and services-producing activities of households for own use" ///
                                         21 "U - Activities of extraterritorial organizations and bodies"	22 "X - Not elsewhere classified"		
  	  		    lab val ilo_job1_eco_isic4 eco_isic4_1digit
			    lab var ilo_job1_eco_isic4 "Economic activity (ISIC Rev. 4) - main job"

					

   * Aggregate
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
			   lab var ilo_job1_eco_aggregate "Economic activity (Aggregate) - main job"
			   
		
  * SECOND JOB:
  * ISIC Rev. 4 - 2 digit
  gen ilo_job2_eco_isic4_2digits = int(q61_ind2/100) if ilo_mjh==2
                * labels already defined for main job
		        lab val ilo_job2_eco_isic4_2digits eco_isic4_2digits
                lab var ilo_job2_eco_isic4_2digits "Economic activity (ISIC Rev. 4), 2 digits level - second job"
							
  * ISIC Rev. 4 - 1 digit
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
	  replace ilo_job2_eco_isic4=22 if ilo_job2_eco_isic4==. & ilo_mjh==2 
                * labels already defined for main job
		        lab val ilo_job2_eco_isic4 eco_isic4_1digit
			    lab var ilo_job2_eco_isic4 "Economic activity (ISIC Rev. 4) - second job"
				

 * Aggregated level 
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
*			Occupation ('ilo_job1_ocu_isco08') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment: - Classification used: BSCO, based on ISCO 08 (at 1 digit-level for main job and at
*            2 digit-level for second job).
	
	* MAIN JOB:	
	* ISCO 08 - 1 digit
	gen ilo_job1_ocu_isco08=bsco1 if ilo_lfs==1
	    replace ilo_job1_ocu_isco08=10 if ilo_job1_ocu_isco08==0
		replace ilo_job1_ocu_isco08=11 if bsco1==. & ilo_lfs==1
		        lab def ocu_isco08_1digit 1 "1 - Managers"	2 "2 - Professionals"	3 "3 - Technicians and associate professionals"	4 "4 - Clerical support workers"	///
                                          5 "5 - Service and sales workers"	6 "6 - Skilled agricultural, forestry and fishery workers"	7 "7 - Craft and related trades workers"	8 "8 - Plant and machine operators, and assemblers"	///
                                          9 "9 - Elementary occupations"	10 "0 - Armed forces occupations"	11 "X - Not elsewhere classified"		
				lab val ilo_job1_ocu_isco08 ocu_isco08_1digit
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
	
	
	* SECOND JOB:
	* ISCO 08 - 2 digit
	gen ilo_job2_ocu_isco08_2digits = int(q62_occ2/100) if ilo_mjh==2
		        lab def ocu_isco08_2digits 1 "01 - Commissioned armed forces officers"	2 "02 - Non-commissioned armed forces officers"	3 "03 - Armed forces occupations, other ranks"	11 "11 - Chief executives, senior officials and legislators"	///
                                           12 "12 - Administrative and commercial managers"	13 "13 - Production and specialised services managers"	14 "14 - Hospitality, retail and other services managers"	21 "21 - Science and engineering professionals"	///
                                           22 "22 - Health professionals"	23 "23 - Teaching professionals"	24 "24 - Business and administration professionals"	25 "25 - Information and communications technology professionals"	///
                                           26 "26 - Legal, social and cultural professionals"	31 "31 - Science and engineering associate professionals"	32 "32 - Health associate professionals"	33 "33 - Business and administration associate professionals"	///
                                           34 "34 - Legal, social, cultural and related associate professionals"	35 "35 - Information and communications technicians"	41 "41 - General and keyboard clerks"	42 "42 - Customer services clerks"	///
                                           43 "43 - Numerical and material recording clerks"	44 "44 - Other clerical support workers"	51 "51 - Personal service workers"	52 "52 - Sales workers"	///
                                           53 "53 - Personal care workers"	54 "54 - Protective services workers"	61 "61 - Market-oriented skilled agricultural workers"	62 "62 - Market-oriented skilled forestry, fishery and hunting workers"	///
                                           63 "63 - Subsistence farmers, fishers, hunters and gatherers"	71 "71 - Building and related trades workers, excluding electricians"	72 "72 - Metal, machinery and related trades workers"	73 "73 - Handicraft and printing workers"	///
                                           74 "74 - Electrical and electronic trades workers"	75 "75 - Food processing, wood working, garment and other craft and related trades workers"	81 "81 - Stationary plant and machine operators"	82 "82 - Assemblers"	///
                                           83 "83 - Drivers and mobile plant operators"	91 "91 - Cleaners and helpers"	92 "92 - Agricultural, forestry and fishery labourers"	93 "93 - Labourers in mining, construction, manufacturing and transport"	///
                                           94 "94 - Food preparation assistants"	95 "95 - Street and related sales and service workers"	96 "96 - Refuse workers and other elementary workers"		
		        lab values ilo_job2_ocu_isco08_2digits ocu_isco08_2digits
	            lab var ilo_job2_ocu_isco08_2digits "Occupation (ISCO-08), 2 digit level - second job"

				
		
	
	* ISCO 08 - 1 digit
	gen ilo_job2_ocu_isco08=.
	    replace ilo_job2_ocu_isco08=int(ilo_job2_ocu_isco08_2digits/10) if ilo_mjh==2     // The rest of the occupations
		replace ilo_job2_ocu_isco08=10 if (ilo_job2_ocu_isco08==0 & ilo_mjh==2)           // Armed forces
                * labels already defined for main job
				lab val ilo_job2_ocu_isco08 ocu_isco08_1digit
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
*			Institutional sector of economic activities ('ilo_job1_ins_sector') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment: - Public: Government/Autonomous and local government.
*          - Private: NGO, private enterprise (agri), private entreprise (non-agri), household, others.

		gen ilo_job1_ins_sector=.
			replace ilo_job1_ins_sector=1 if inlist(q49,1,2) & ilo_lfs==1		// Public
			replace ilo_job1_ins_sector=2 if !inlist(q49,1,2) & ilo_lfs==1		// Private
				lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private" 
				lab values ilo_job1_ins_sector ins_sector_lab
				lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job1_job_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
* Comment:
	
		gen ilo_job1_job_time=.
			replace ilo_job1_job_time=1 if q53==2 & ilo_lfs==1              	// Part-time
			replace ilo_job1_job_time=2 if q53==1 & ilo_lfs==1 	                // Full-time
			replace ilo_job1_job_time=3 if q53==. & ilo_lfs==1	                // Unknown
					lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
					lab val ilo_job1_job_time job_time_lab
					lab var ilo_job1_job_time "Job (Working time arrangement) - Main job"	
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job1_job_contract') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
* Comment: 
		
		gen ilo_job1_job_contract=.
		    replace ilo_job1_job_contract=1 if q52==1 & ilo_lfs==1              // Permanent
			replace ilo_job1_job_contract=2 if q52==2 & ilo_lfs==1              // Temporary
			replace ilo_job1_job_contract=3 if q52==. & ilo_lfs==1              // Unknown
				    lab def job_contract_lab 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"
					lab val ilo_job1_job_contract job_contract_lab
					lab var ilo_job1_job_contract "Job (Type of contract)"
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Formal / Informal Economy ('ilo_job1_ife_prod' 'ilo_job1_ife_nature') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
* Comment: 	
/* Useful questions:
			
		  * Institutional sector: q49
		  * Destination of production: not asked
		  * Bookkeeping: asked but not specifically for whom the accounting is made for => not used
		  * Registration: q50
		  * Status in employment: ilo_job1_ste_icse93 
		  * Place of work: q58
		  * Size: q54 (the threshold used normally by ILO is 5. Here the cutoff is at 10.
		  * Pension funds: q57_a (only asked to employees)
		  * Paid sick leave: q57_c
		  * Paid annual leave: not asked 
		
		  Generation of a variable indicating the social security coverage (to be dropped afterwards):
		  An employee is considered covered by social security if her/his employer pays contributions
		  to pension funds.
		  
*/
		   
		* 1) UNIT OF PRODUCTION: FORMAL/INFORMAL SECTOR
		
	    /*Social security*/
		gen social_security=.
			replace social_security=1 if q57_a==1 & ilo_lfs==1              // Pension or retirement fund
	    	replace social_security=2 if q57_a==2 & ilo_lfs==1              // No pension or retirement fund
			replace social_security=3 if social_security==. & ilo_lfs==1    // Not answered
				
		/*Formal/informal sector*/
		gen ilo_job1_ife_prod=.
		    replace ilo_job1_ife_prod=3 if ilo_lfs==1 & q49==6
		    replace ilo_job1_ife_prod=2 if ilo_lfs==1 & ilo_job1_ife_prod!=3 & ///
			                               ((inlist(q49,1,2,3)) | ///
										   (inlist(q49,4,5,7,.) & q50==1)| ///
										   (inlist(q49,4,5,7,.) & q50==. & ilo_job1_ste_icse93==1 & social_security==1) | ///
										   (inlist(q49,4,5,7,.) & q50==. & ilo_job1_ste_icse93==1 & inlist(social_security,2,3) & q58==3 & inlist(q54,3,4,5,6)) | ///
										   (inlist(q49,4,5,7,.) & q50==. & ilo_job1_ste_icse93!=1 & q58==3 & inlist(q54,3,4,5,6)))
			replace ilo_job1_ife_prod=1 if ilo_lfs==1 & !inlist(ilo_job1_ife_prod,2,3) & ///
			                               ((inlist(q49,4,5,7,.) & inlist(q50,2,3,4)) | ///
										   (inlist(q49,4,5,7,.) & q50==. & ilo_job1_ste_icse93==1 & inlist(social_security,2,3) & q58==3 & inlist(q54,1,2,7,.)) | ///
										   (inlist(q49,4,5,7,.) & q50==. & ilo_job1_ste_icse93==1 & inlist(social_security,2,3) & q58!=3) | ///
										   (inlist(q49,4,5,7,.) & q50==. & ilo_job1_ste_icse93!=1 & q58==3 & inlist(q54,1,2,7,.)) | ///
										   (inlist(q49,4,5,7,.) & q50==. & ilo_job1_ste_icse93!=1 & q58!=3))
				    lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 
					lab val ilo_job1_ife_prod ilo_ife_prod_lab
					lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"

	   * 2) NATURE OF JOB: FORMAL/INFORMAL EMPLOYMENT
	   
	   gen ilo_job1_ife_nature=.
	       replace ilo_job1_ife_nature=2 if ilo_lfs==1 & ///
		                                    ((inlist(ilo_job1_ste_icse93,1,6) & social_security==1) | ///
											(inlist(ilo_job1_ste_icse93,2,4) & ilo_job1_ife_prod==2) | ///
											(ilo_job1_ste_icse93==3 & ilo_job1_ife_prod==2))
		   replace ilo_job1_ife_nature=1 if ilo_lfs==1 & ///
		                                    ((inlist(ilo_job1_ste_icse93,1,6) & inlist(social_security,2,3)) | ///
											(inlist(ilo_job1_ste_icse93,2,4) & inlist(ilo_job1_ife_prod,1,3)) | ///
											(ilo_job1_ste_icse93==3 & inlist(ilo_job1_ife_prod,1,3)) | ///
											(ilo_job1_ste_icse93==5))
    			   lab def ife_nature_lab 1 "1 - Persons with informal main job" 2 "2 - Persons with formal main job"
				   lab val ilo_job1_ife_nature ife_nature_lab
				   lab var ilo_job1_ife_nature "Informal / Formal Economy (Nature of job) - Main job"
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Hours of work ('ilo_job1_how') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment: 		
   
   * MAIN JOB:
   * 1) Weekly hours ACTUALLY worked:
		gen ilo_job1_how_actual=q59_hours if ilo_lfs==1
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
					
   * 2) Weekly hours USUALLY worked:	
		* No information available.
	
   * SECOND JOB:
   * 1) Weekly hours ACTUALLY worked:
	    gen ilo_job2_how_actual=q64_hours2 if ilo_mjh==2
			lab var ilo_job2_how_actual "Weekly hours actually worked in second job"
					
		gen ilo_job2_how_actual_bands=.
			replace ilo_job2_how_actual_bands=1 if ilo_job2_how_actual==0
			replace ilo_job2_how_actual_bands=2 if inrange(ilo_job2_how_actual,1,14)
			replace ilo_job2_how_actual_bands=3 if inrange(ilo_job2_how_actual,15,29)
			replace ilo_job2_how_actual_bands=4 if inrange(ilo_job2_how_actual,30,34)
			replace ilo_job2_how_actual_bands=5 if inrange(ilo_job2_how_actual,35,39)
			replace ilo_job2_how_actual_bands=6 if inrange(ilo_job2_how_actual,40,48)
			replace ilo_job2_how_actual_bands=7 if ilo_job2_how_actual>=49 & ilo_job2_how_actual!=.
				    lab val ilo_job2_how_actual_bands how_bands_lab
				    lab var ilo_job2_how_actual_bands "Weekly hours actually worked bands in second job"
					
   * 2) Weekly hours USUALLY worked:	
		* No information available.
		
   * ALL JOBS:
   * 1) Weekly hours ACTUALLY worked:
		gen how_job1=ilo_job1_how_actual
			replace how_job1=0 if ilo_job1_how_actual==.
			
		gen how_job2=ilo_job2_how_actual
			replace how_job2=0 if ilo_job2_how_actual==.
				
		gen how_tot= how_job1 + how_job2
			replace how_tot=. if ilo_lfs!=1
			
		gen ilo_joball_how_actual=how_tot 
			lab var ilo_joball_how_actual "Weekly hours actually worked in all jobs"
					
		gen ilo_joball_how_actual_bands=.
			replace ilo_joball_how_actual_bands=1 if ilo_joball_how_actual==0
			replace ilo_joball_how_actual_bands=2 if inrange(ilo_joball_how_actual,1,14)
			replace ilo_joball_how_actual_bands=3 if inrange(ilo_joball_how_actual,15,29)
			replace ilo_joball_how_actual_bands=4 if inrange(ilo_joball_how_actual,30,34)
			replace ilo_joball_how_actual_bands=5 if inrange(ilo_joball_how_actual,35,39)
			replace ilo_joball_how_actual_bands=6 if inrange(ilo_joball_how_actual,40,48)
			replace ilo_joball_how_actual_bands=7 if ilo_joball_how_actual>=49 & ilo_joball_how_actual!=.
					lab val ilo_joball_how_actual_bands how_bands_lab
					lab var ilo_joball_how_actual_bands "Weekly hours actually worked bands in all jobs"
   
   * 2) Weekly hours USUALLY worked:	
		* No information available.
				

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Monthly labour related income ('ilo_joball_lri') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
* Comment: - Only asked to employees. All jobs.
*          - Refers to gross income in the last month (including payments in kind) (note to the variable)
	   
	* ALL JOBS:				
	* Employees
	gen ilo_joball_lri_ees =.
		replace ilo_joball_lri_ees = q77_cashkind if ilo_job1_ste_aggregate==1
				lab var ilo_joball_lri_ees "Monthly earnings of employees in main job"	
				
	
***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_joball_tru') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
* Comment: - No information on the availability of those who want to work more hours and are 
*            looking for additional hours. (note to the variable)
*          - National threshold is set at 40 hours per week.

      gen ilo_joball_tru=.
		  replace ilo_joball_tru=1 if ilo_lfs==1 & inlist(q78_und,1,2) & q79_und==3 & ilo_joball_how_actual<40
		          lab def ilo_tru 1 "Time-related underemployed"
			      lab val ilo_joball_tru ilo_tru
			      lab var ilo_joball_tru "Time-related underemployed"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupational injury ('ilo_joball_oi_case', 'ilo_joball_oi_day') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
* Comment: - Cases of non-fatal occupational injuries reference period: last 12 months
*          - Days lost due to cases of occupation injuries reference period: last 12 months
*            (excluding values codes 98 and 99).
	
	* 1) Cases:
	     gen ilo_joball_oi_case=q68 if ilo_lfs==1
			 lab var ilo_joball_oi_case "Cases of non-fatal occupational injury"

	* 2) Days:
		 gen ilo_joball_oi_day=q70 if ilo_lfs==1	
			 replace ilo_joball_oi_day=. if inlist(ilo_joball_oi_day, 98,99)
				     lab var ilo_joball_oi_day "Days lost due to cases of occupational injury"
		
***********************************************************************************************
*			PART 3.3. UNEMPLOYMENT: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Category of unemployment ('ilo_cat_une') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: 
	
      gen ilo_cat_une=. 
		  replace ilo_cat_une=1 if q82==1 & ilo_lfs==2 	                        // Previously employed
		  replace ilo_cat_une=2 if q82==2 & ilo_lfs==2 	                        // Seeking first job
		  replace ilo_cat_une=3 if q82==. & ilo_lfs==2 	                        // Unknown
				  lab def cat_une 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
				  lab val ilo_cat_une cat_une
				  lab var ilo_cat_une "Category of unemployment"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Only available at the aggregate level.
	
     gen ilo_dur_aggregate=.
		 replace ilo_dur_aggregate=1 if inlist(q88,1,2) & ilo_lfs==2            // Less than 6 months
		 replace ilo_dur_aggregate=2 if q88==3 & ilo_lfs==2                     // 6 to 12 months
		 replace ilo_dur_aggregate=3 if inlist(q88,4,5) & ilo_lfs==2            // 12 months or more
		 replace ilo_dur_aggregate=4 if q88==. & ilo_lfs==2                     // Not elsewhere classified
				 lab def ilo_unemp_aggr 1 "1 - Less than 6 months" 2 "2 - 6 months to less than 12 months" 3 "3 - 12 months or more" 4 "4 - Not elsewhere classified"
				 lab val ilo_dur_aggregate ilo_unemp_aggr
				 lab var ilo_dur_aggregate "Duration of unemployment (Aggregate)"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
* Comment: No information available.

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
* Comment: No information available.
	
***********************************************************************************************
*			PART 3.3. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
* Comment: - Even though willingness is not asked directly, non-willingness is determined through
*            questions 86 and 89.
	
	gen ilo_olf_dlma=.
		replace ilo_olf_dlma = 1 if q84==1 & q87==2 & ilo_lfs==3 				// Seeking, not available
		replace ilo_olf_dlma = 2 if q84==2 & q87==1 & ilo_lfs==3				// Not seeking, available
		* replace ilo_olf_dlma = 3 if 											// Not seeking, not available, willing
		replace ilo_olf_dlma = 4 if q84==2 & q87==2 & q86==9 & ilo_lfs==3		// Not seeking, not available, not willing
		replace ilo_olf_dlma = 4 if q84==2 & q87==2 & q89==7 & ilo_lfs==3		// Not seeking, not available, not willing
		replace ilo_olf_dlma = 5 if	ilo_olf_dlma==. & ilo_lfs==3				// Not classified 
			    lab def dlma_lab 1 "1 - Seeking, not available (Unavailable jobseekers)" 2 "2 - Not seeking, available (Available potential jobseekers)" ///
							     3 "3 - Not seeking, not available, willing (Willing non-jobseekers)" 4 "4 - Not seeking, not available, not willing" 5 "X - Not elsewhere classified"
			    lab val ilo_olf_dlma dlma_lab 
			    lab var ilo_olf_dlma "Labour market attachment (Degree of)"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reason for not seeking job ('ilo_olf_reason') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment: 

	gen ilo_olf_reason=.
		replace ilo_olf_reason=1 if	inlist(q86,2,8) & ilo_lfs==3	            // Labour market
		replace ilo_olf_reason=2 if q86==3 & ilo_lfs==3                         // Other labour market reasons
		replace ilo_olf_reason=3 if	inlist(q86,5,6,7) & ilo_lfs==3    	        // Personal/Family-related
		replace ilo_olf_reason=4 if q86==9 & ilo_lfs==3		                    // Does not need/want to work
		replace ilo_olf_reason=5 if inlist(q86,10,.) & ilo_lfs==3	            // Not elsewhere classified
			    lab def reasons_lab 1 "1 - Labour market" 2 "2 - Other labour market reasons" 3 "3 - Personal / Family-related" ///
								    4 "4 - Does not need/want to work" 5 "5 - Not elsewhere classified"
			    lab val ilo_olf_reason reasons_lab 
			    lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seeker ('ilo_dis')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment: 
		
	gen ilo_dis=1 if ilo_lfs==3 & q87==1 & ilo_olf_reason==1
		lab def dis_lab 1 "Discouraged job-seekers"
		lab val ilo_dis dis_lab
		lab var ilo_dis "Discouraged job-seekers"
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training ('ilo_neet')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment: 

	gen ilo_neet=1 if ilo_age_aggregate==2 & ilo_lfs!=1 & ilo_edu_attendance==2
			lab def neet_lab 1 "Youth not in education, employment or training"
			lab val ilo_neet neet_lab
			lab var ilo_neet "Youth not in education, employment or training"

***********************************************************************************************
***********************************************************************************************

*			4. SAVE ILO-VARIABLES IN A NEW DATASET

***********************************************************************************************
***********************************************************************************************

* -------------------------------------------------------------
* 	Prepare final datasets
* -------------------------------------------------------------


cd "$outpath"
        
	
		
		/*Only age bands used*/
		drop ilo_age 
		
    	/*Variables computed in-between*/
 	    drop social_security how_job1 how_job2 how_tot
		
		compress 
		
	   /*Save dataset including original and ilo variables*/
	
		save ${country}_${source}_${time}_FULL,  replace		
	
	  /* Save file only containing ilo_* variables*/
	
		keep ilo*

		save ${country}_${source}_${time}_ILO, replace

		
