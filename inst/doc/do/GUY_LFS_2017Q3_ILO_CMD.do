* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Guyana, 2017
* DATASET USED: Guyana LFS 2017
* NOTES: 
* Authors: ILO / Department of Statistics / DPAU

* Starting Date: 30 November 2017
* Last updated: 22 May 2018
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
global country "GUY"
global source "LFS"
global time "2017Q3"
global inputFile "GUY_LFS_2017Q3"
global inpath "${path}\\${country}\\${source}\\${time}\ORI"
global outpath "${path}\\${country}\\${source}\\${time}"

************************************************************************************
		

*********************************************************************************************

* Load original dataset

*********************************************************************************************

cd "$inpath"
	use "$inputFile", clear
	*rename *, lower  
	
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
*			Time period ('ilo_time')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	* Year 
	gen ilo_time=1
		lab def lab_time 1 "$time"
		lab val ilo_time lab_time
		lab var ilo_time "Time (Gregorian Calendar)"		

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sample Weight ('ilo_wgt')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_wgt=weight
		lab var ilo_wgt "Sample weight"	
			keep if ilo_wgt!=.

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
		replace ilo_geo=1 if zone==1
		replace ilo_geo=2 if zone==0
			lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural"
			lab val ilo_geo ilo_geo_lab
			lab var ilo_geo "Geographical coverage"	
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_sex=.
	    replace ilo_sex=1 if q1_03==1
		replace ilo_sex=2 if q1_03==2 
		        lab def ilo_sex_lab 1 "1 - Male" 2 "2 - Female"
		        lab var ilo_sex "Sex"
		        lab val ilo_sex ilo_sex_lab

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_age=q1_04
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
			lab def age_by5_lab 1 "0-4" 2 "5-9" 3 "10-14" 4 "15-19" 5 "20-24" 6 "25-29" 7 "30-34" 8 "35-39" ///
								9 "40-44" 10 "45-49" 11 "50-54" 12 "55-59" 13 "60-64" 14 "65+"
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

* Comment: - ISCED 11 mapping: based on the UNESCO mapping available on  http://uis.unesco.org/en/isced-mappings

	gen ilo_edu_isced11=.
		replace ilo_edu_isced11=1 if (q1_13==1 | q1_14==1)                	           							// No schooling
		replace ilo_edu_isced11=2 if (q1_13==2 & inlist(q1_14,2,3,4,5))            	       						// Early childhood education
		replace ilo_edu_isced11=3 if (q1_13==2 & q1_14==6)                      								// Primary education 
		replace ilo_edu_isced11=4 if (q1_13==3 & inlist(q1_14,7,8,9,10))                   						// Lower secondary education
		replace ilo_edu_isced11=5 if (q1_13==3 & q1_14==11) | (inlist(q1_13,4,5) & q1_15==1)				    // Upper secondary education
		replace ilo_edu_isced11=6 if (inlist(q1_13,4,5) & q1_15==2)	| (inlist(q1_13,3,4) & q1_14==12)   		// Post-secondary non-tertiary education
		replace ilo_edu_isced11=7 if (inlist(q1_13,4,5) & q1_15==3)					                            // Short-cycle tertiary education
		replace ilo_edu_isced11=8 if (q1_13==5 & q1_15==4 ) | (q1_13==4 & q1_15==5)	| (q1_13==5 & q1_15==5)     // Bachelor's or equivalent level
		replace ilo_edu_isced11=9 if (q1_13==5 & q1_15==6)                     									// Master's or equivalent level
		replace ilo_edu_isced11=10 if (q1_13==5 & q1_15==7)                										// Doctoral or equivalent level
		replace ilo_edu_isced11=11 if ilo_edu_isced11==.                  										// Not elsewhere classified 
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

	gen ilo_edu_attendance=.
		replace ilo_edu_attendance=1 if q1_12==1                    // Yes
		replace ilo_edu_attendance=2 if q1_12==2	                // No
		replace ilo_edu_attendance=3 if ilo_edu_attendance==.     	// Not elsewhere classified
		    lab def edu_attendance_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
		    lab val ilo_edu_attendance edu_attendance_lab
		    lab var ilo_edu_attendance "Education (Attendance)"

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			           Marital status ('ilo_mrts') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
	
	* Detailed
	gen ilo_mrts_details=.
	    replace ilo_mrts_details=1 if q1_05==1					// Single
		replace ilo_mrts_details=2 if q1_05==3					// Married
		replace ilo_mrts_details=3 if q1_05==2					// Union / cohabiting
		replace ilo_mrts_details=4 if q1_05==6					// Widowed
		replace ilo_mrts_details=5 if inlist(q1_05,4,5)			// Divorced / separated
		replace ilo_mrts_details=6 if ilo_mrts_details==.		// Not elsewhere classified
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

* Information not available


		
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
		replace ilo_wap=1 if ilo_age>=15 & ilo_age!=.
			label def ilo_wap_lab 1 "Working age population"
			label val ilo_wap ilo_wap_lab
			label var ilo_wap "Working age population"
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Labour Force Status ('ilo_lfs')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

   gen ilo_lfs=.
	   replace ilo_lfs=1 if (q2_04==1 | q2_05==1 | q2_06==1 | q2_06==2 | (q2_07==1 & q2_08==2) | (q2_07==1 & (q2_09==1 | q2_09==2))) & ilo_wap==1	// Employed
	   replace ilo_lfs=1 if (q2_10==1 & (inlist(q2_11,1,2,3,4) | (inlist(q2_11,5,6,7,8,9,10,11,14) & (q2_12==1 | q2_13==1))) & ilo_wap==1)			// Temporary absent
	   replace ilo_lfs=2 if (ilo_lfs!=1 & q2_14==1 & inlist(q2_19,1,2) & ilo_wap==1)																// Unemployed
       replace ilo_lfs=2 if (ilo_lfs!=1 & q2_14==2 & q2_17==1 & ilo_wap==1)																			// Unemployed, found work but waiting to start
	   replace ilo_lfs=3 if !inlist(ilo_lfs,1,2) & ilo_wap==1                   																	// Outside the labour market
		       label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside the Labour Force"
			   label value ilo_lfs label_ilo_lfs
			   label var ilo_lfs "Labour Force Status"
			   
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

    gen ilo_mjh=.
	    replace ilo_mjh=2 if (q3_01==1 & ilo_lfs==1)                          
		replace ilo_mjh=1 if (q3_01==2 & ilo_lfs==1)
		replace ilo_mjh=1 if (q3_01==. & ilo_lfs==1)
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

	* Detailed categories:
	gen ilo_job1_ste_icse93=.
		replace ilo_job1_ste_icse93=1 if q3_16==1 & ilo_lfs==1 	    			// Employees
		replace ilo_job1_ste_icse93=2 if q3_16==4 & ilo_lfs==1	    			// Employers
		replace ilo_job1_ste_icse93=3 if q3_16==3 & ilo_lfs==1      			// Own-account workers
		*replace ilo_job1_ste_icse93=4                              			// Members of producersâ€™ cooperatives
		replace ilo_job1_ste_icse93=5 if q3_16==2 & ilo_lfs==1     	    		// Contributing family workers
		replace ilo_job1_ste_icse93=6 if ilo_job1_ste_icse93==. & ilo_lfs==1    // Not classifiable
			    label def label_ilo_ste_icse93 1 "1 - Employees" 2 "2 - Employers" 3 "3 - Own-account workers"                ///
				    						   4 "4 - Members of producers cooperatives" 5 "5 - Contributing family workers"  ///
					    					   6 "6 - Workers not classifiable by status"
			    label val ilo_job1_ste_icse93 label_ilo_ste_icse93
			    label var ilo_job1_ste_icse93 "Status in employment (ICSE 93) in main job"

	* Aggregate categories 
	gen ilo_job1_ste_aggregate=.
		replace ilo_job1_ste_aggregate=1 if ilo_job1_ste_icse93==1				// Employees
		replace ilo_job1_ste_aggregate=2 if inrange(ilo_job1_ste_icse93,2,5)	// Self-employed
		replace ilo_job1_ste_aggregate=3 if ilo_job1_ste_icse93==6				// Not elsewhere classified
	    		lab def ste_aggr_lab 1 "1 - Employees" 2 "2 - Self-employed" 3 "3 - Not elsewhere classified"
				lab val ilo_job1_ste_aggregate ste_aggr_lab
				label var ilo_job1_ste_aggregate "Status in employment (Aggregate) in main job"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_job1_eco_')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* ISIC Rev. 4

	* MAIN JOB:
	gen indu_code_prim=.
	    replace indu_code_prim=int(isic_code/100)

	* 2-digit level	
	gen ilo_job1_eco_isic4_2digits=indu_code_prim if ilo_lfs==1
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
        lab var ilo_job1_eco_isic4_2digits "Economic activity (ISIC Rev. 4), 2 digits levels - Main job"

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
		replace ilo_job1_eco_isic4=22 if ilo_job1_eco_isic4==. & ilo_lfs==1
		        lab def eco_isic4 1 "A - Agriculture, forestry and fishing"	2 "B - Mining and quarrying"	3 "C - Manufacturing"	4 "D - Electricity, gas, steam and air conditioning supply" ///
                                  5 "E - Water supply; sewerage, waste management and remediation activities"	6 "F - Construction"	7 "G - Wholesale and retail trade; repair of motor vehicles and motorcycles"	8 "H - Transportation and storage" ///
                                  9 "I - Accommodation and food service activities"	10 "J - Information and communication"	11 "K - Financial and insurance activities"	12 "L - Real estate activities" ///
                                  13 "M - Professional, scientific and technical activities"	14 "N - Administrative and support service activities"	15 "O - Public administration and defence; compulsory social security"	16 "P - Education" ///
                                  17 "Q - Human health and social work activities"	18 "R - Arts, entertainment and recreation"	19 "S - Other service activities"	20 "T - Activities of households as employers; undifferentiated goods- and services-producing activities of households for own use" ///
                                  21 "U - Activities of extraterritorial organizations and bodies"	22 "X - Not elsewhere classified"		
  	  		    lab val ilo_job1_eco_isic4 eco_isic4
			    lab var ilo_job1_eco_isic4 "Economic activity (ISIC Rev. 4) - Main job"

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
			   lab var ilo_job1_eco_aggregate "Economic activity (Aggregate) - Main job"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_job1_ocu_')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

    * MAIN JOB	
	gen occ_code_prim=.
	    replace occ_code_prim=int(isco_code/100)
		replace occ_code_prim=1 if occ_code_prim==0

    * 2-digit level
	gen ilo_job1_ocu_isco08_2digits=occ_code_prim if ilo_lfs==1
	    lab def ocu08_2digits 1 "01 - Commissioned armed forces officers"	2 "02 - Non-commissioned armed forces officers"	3 "03 - Armed forces occupations, other ranks"	11 "11 - Chief executives, senior officials and legislators"	///
                              12 "12 - Administrative and commercial managers"	13 "13 - Production and specialised services managers"	14 "14 - Hospitality, retail and other services managers"	21 "21 - Science and engineering professionals"	///
                              22 "22 - Health professionals"	23 "23 - Teaching professionals"	24 "24 - Business and administration professionals"	25 "25 - Information and communications technology professionals"	///
                              26 "26 - Legal, social and cultural professionals"	31 "31 - Science and engineering associate professionals"	32 "32 - Health associate professionals"	33 "33 - Business and administration associate professionals"	///
                              34 "34 - Legal, social, cultural and related associate professionals"	35 "35 - Information and communications technicians"	41 "41 - General and keyboard clerks"	42 "42 - Customer services clerks"	///
                              43 "43 - Numerical and material recording clerks"	44 "44 - Other clerical support workers"	51 "51 - Personal service workers"	52 "52 - Sales workers"	///
                              53 "53 - Personal care workers"	54 "54 - Protective services workers"	61 "61 - Market-oriented skilled agricultural workers"	62 "62 - Market-oriented skilled forestry, fishery and hunting workers"	///
                              63 "63 - Subsistence farmers, fishers, hunters and gatherers"	71 "71 - Building and related trades workers, excluding electricians"	72 "72 - Metal, machinery and related trades workers"	73 "73 - Handicraft and printing workers"	///
                              74 "74 - Electrical and electronic trades workers"	75 "75 - Food processing, wood working, garment and other craft and related trades workers"	81 "81 - Stationary plant and machine operators"	82 "82 - Assemblers"	///
                              83 "83 - Drivers and mobile plant operators"	91 "91 - Cleaners and helpers"	92 "92 - Agricultural, forestry and fishery labourers"	93 "93 - Labourers in mining, construction, manufacturing and transport" ///
                              94 "94 - Food preparation assistants"	95 "95 - Street and related sales and service workers"	96 "96 - Refuse workers and other elementary workers"
		lab values ilo_job1_ocu_isco08_2digits ocu08_2digits
		lab var ilo_job1_ocu_isco08_2digits "Occupation (ISCO-08), 2 digit level - Main job"

    * 1-digit level
	gen ilo_job1_ocu_isco08=.
	    replace ilo_job1_ocu_isco08=11 if ilo_job1_ocu_isco08_2digits==. & ilo_lfs==1           	// Not elsewhere classified
		replace ilo_job1_ocu_isco08=int(ilo_job1_ocu_isco08_2digits/10) if ilo_lfs==1           	// The rest of the occupations
		replace ilo_job1_ocu_isco08=10 if (ilo_job1_ocu_isco08==0 & ilo_lfs==1)                 	// Armed forces
		replace ilo_job1_ocu_isco08=11 if ilo_job1_ocu_isco08==. & ilo_lfs==1             			// Not elsewhere classified
	            lab def ilo_job1_ocu_isco08 1 "1 - Managers"	2 "2 - Professionals"	3 "3 - Technicians and associate professionals"	4 "4 - Clerical support workers"	///
                                            5 "5 - Service and sales workers"	6 "6 - Skilled agricultural, forestry and fishery workers"	7 "7 - Craft and related trades workers"	8 "8 - Plant and machine operators, and assemblers"	///
                                            9 "9 - Elementary occupations"	10 "0 - Armed forces occupations"	11 "X - Not elsewhere classified"
	            lab val ilo_job1_ocu_isco08 ilo_job1_ocu_isco08
				lab var ilo_job1_ocu_isco08 "Occupation (ISCO-08) - Main job"

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
			    lab var ilo_job1_ocu_aggregate "Occupation (Aggregate) - Main job"	
		
	* Skill level
	gen ilo_job1_ocu_skill=.
	    replace ilo_job1_ocu_skill=1 if ilo_job1_ocu_isco08==9                   // Low
		replace ilo_job1_ocu_skill=2 if inlist(ilo_job1_ocu_isco08,4,5,6,7,8)    // Medium
		replace ilo_job1_ocu_skill=3 if inlist(ilo_job1_ocu_isco08,1,2,3)        // High
		replace ilo_job1_ocu_skill=4 if inlist(ilo_job1_ocu_isco08,10,11)        // Not elsewhere classified
				lab def ocu_skill_lab 1 "1 - Skill level 1 (low)" 2 "2 - Skill level 2 (medium)" 3 "3 - Skill levels 3 and 4 (high)" 4 "4 - Not elsewhere classified"
			    lab val ilo_job1_ocu_skill ocu_skill_lab
			    lab var ilo_job1_ocu_skill "Occupation (Skill level) - main job"


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*	Institutional sector of economic activities ('ilo_job1_ins_sector')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

    * MAIN JOB
	gen ilo_job1_ins_sector=.
		replace ilo_job1_ins_sector=1 if inlist(q3_34,3,4) & ilo_lfs==1        	// Public
		replace ilo_job1_ins_sector=2 if inlist(q3_34,1,2,5) & ilo_lfs==1		// Private
		replace ilo_job1_ins_sector=2 if ilo_job1_ins_sector==. & ilo_lfs==1	// Private
    			lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
			    lab values ilo_job1_ins_sector ins_sector_lab
			    lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities in main job"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Hours of work ('ilo_how')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
		
	* MAIN JOB:
			
		* Weekly hours USUALLY worked
		gen ilo_job1_how_usual=q3_03 if ilo_lfs==1
					lab var ilo_job1_how_usual "Weekly hours usually worked in main job"
		
		* Other jobs
		gen ilo_job2_how_usual=.
			replace ilo_job2_how_usual=q3_04 if (ilo_lfs==1 & ilo_mjh==2)
					lab var ilo_job2_how_usual "Weekly hours usually worked in other jobs"
					
		* All jobs 
		egen ilo_joball_how_usual=rsum(q3_03 q3_04) if ilo_lfs==1, missing
				lab var ilo_joball_how_usual "Weekly hours usually worked in all jobs"


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job1_job_time')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			

			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job1_job_contract')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

   gen ilo_job1_job_contract=.
	   replace ilo_job1_job_contract=1 if (q3_19==2 & ilo_lfs==1)               // Permanent (Unlimited duration)
	   replace ilo_job1_job_contract=2 if (q3_19==1 & ilo_lfs==1)      			// Temporary (Limited duration)
	   replace ilo_job1_job_contract=3 if (q3_19==. & ilo_lfs==1)			    // Unknown
			   lab def job_contract_lab 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"
			   lab val ilo_job1_job_contract job_contract_lab
			   lab var ilo_job1_job_contract "Job (Type of contract) in main job"			

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Formal / Informal Economy ('ilo_job1_ife_prod' 'ilo_job1_ife_nature')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			

/* Useful questions:
			- Institutional sector: q3_34
			- Destination of production: 
			- Bookkeeping: q3_28
			- Registration: q3_35
			- Place of work: q3_37
			- Size: q3_38
			- Status in employment: ilo_job1_ste_aggregate / ilo_job1_ste_icse93
			- Social security contribution / Pension: q3_26  
			- Paid annual leave: q3_22
			- Paid sick leave: q3_24
*/
	
	* 1) UNIT OF PRODUCTION: FORMAL/INFORMAL SECTOR		
    			
		gen ilo_job1_ife_prod=.
			replace ilo_job1_ife_prod=3 if ilo_lfs==1 & (ilo_job1_ocu_isco08_2digits==63 | ilo_job1_eco_isic4_2digits==97)
			replace ilo_job1_ife_prod=2 if ilo_lfs==1 & (inlist(q3_34,2,3,4,5) | (q3_34==1 & q3_35==1) | (q3_34==1 & inlist(q3_35,2,3,4) & q3_28==1)) 
			replace ilo_job1_ife_prod=1 if ilo_lfs==1 & ilo_job1_ife_prod==.
				lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 
				lab val ilo_job1_ife_prod ilo_ife_prod_lab
				lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"

	* 2) NATURE OF JOB: FORMAL/INFORMAL EMPLOYMENT
	
		gen ilo_job1_ife_nature=.
			replace ilo_job1_ife_nature=2 if ilo_lfs==1 & ((inlist(ilo_job1_ste_icse93,1,6) & q3_26==1) | (inlist(ilo_job1_ste_icse93,2,4) & ilo_job1_ife_prod==2))
			replace ilo_job1_ife_nature=1 if ilo_lfs==1 & (ilo_job1_ife_nature!=2)
				lab def ife_nature_lab 1 "1 - Persons with informal main job" 2 "2 - Persons with formal main job"
			    lab val ilo_job1_ife_nature ife_nature_lab
			    lab var ilo_job1_ife_nature "Informal / Formal Economy (Nature of job)"
					  
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Monthly labour related income ('ilo_joball_lri')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

		gen ilo_job1_lri_ees=q6_01 if ilo_job1_ste_aggregate==1
			replace ilo_job1_lri_ees=4000 if (q6_01==. | q6_01<0) & q6_01b==1 & ilo_job1_ste_aggregate==1
			replace ilo_job1_lri_ees=10500 if (q6_01==. | q6_01<0) & q6_01b==2 & ilo_job1_ste_aggregate==1
			replace ilo_job1_lri_ees=16500 if (q6_01==. | q6_01<0) & q6_01b==3 & ilo_job1_ste_aggregate==1
			replace ilo_job1_lri_ees=35000 if (q6_01==. | q6_01<0) & q6_01b==4 & ilo_job1_ste_aggregate==1
			replace ilo_job1_lri_ees=75000 if (q6_01==. | q6_01<0) & q6_01b==5 & ilo_job1_ste_aggregate==1
			replace ilo_job1_lri_ees=125000 if (q6_01==. | q6_01<0) & q6_01b==6 & ilo_job1_ste_aggregate==1
			replace ilo_job1_lri_ees=175000 if (q6_01==. | q6_01<0) & q6_01b==7 & ilo_job1_ste_aggregate==1
			replace ilo_job1_lri_ees=250000 if (q6_01==. | q6_01<0) & q6_01b==8 & ilo_job1_ste_aggregate==1
			replace ilo_job1_lri_ees=350000 if (q6_01==. | q6_01<0) & q6_01b==9 & ilo_job1_ste_aggregate==1
			replace ilo_job1_lri_ees=450000 if (q6_01==. | q6_01<0) & q6_01b==10 & ilo_job1_ste_aggregate==1
			replace ilo_job1_lri_ees=750000 if (q6_01==. | q6_01<0) & q6_01b==11 & ilo_job1_ste_aggregate==1
			replace ilo_job1_lri_ees=1500000 if (q6_01==. | q6_01<0) & q6_01b==12 & ilo_job1_ste_aggregate==1				
			replace ilo_job1_lri_ees=. if (q6_01==. | q6_01<0) & (inlist(q6_01b,98,99)) & ilo_job1_ste_aggregate==1
				lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"


				  
***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_joball_tru')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

		gen ilo_joball_tru=.
			replace ilo_joball_tru = 1 if (ilo_joball_how_usual<30 & q3_11==1 & q3_12==1)
				lab def lab_joball_tru 1 "Time-related underemployed" 
				lab val ilo_joball_tru lab_joball_tru
				lab var ilo_joball_tru "Time-related underemployed"

*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Cases of non-fatal occupational injury ('ilo_joball_oi_case')
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------


*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Days lost due to cases of occupational injury ('ilo_joball_oi_day')
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------



***********************************************************************************************
*			PART 3.3. UNEMPLOYMENT: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Category of unemployment ('ilo_cat_une')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_cat_une=.
		replace ilo_cat_une=1 if (q5_02==1 & ilo_lfs==2)		// 1 - Unemployed previously employed
		replace ilo_cat_une=2 if (q5_02==2 & ilo_lfs==2)		// 2 - Unemployed seeking their first job
		replace ilo_cat_une=3 if (ilo_cat_une==. & ilo_lfs==2) 	// 3 - Unknown
			lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
			    lab values ilo_cat_une cat_une_lab
			    lab var ilo_cat_une "Category of unemployment"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_dur_details=.
		* replace ilo_dur_details=1 if (q2_18==1 & ilo_lfs==2)     	   	// Less than 1 month
		replace ilo_dur_details=2 if (q2_18==1 & ilo_lfs==2)      		// 1 to 3 months
		replace ilo_dur_details=3 if (q2_18==2 & ilo_lfs==2)    		// 3 to 6 months
		replace ilo_dur_details=4 if (q2_18==3 & ilo_lfs==2)    		// 6 to 12 months
		replace ilo_dur_details=5 if (q2_18==4 & ilo_lfs==2)   			// 12 to 24 months
		replace ilo_dur_details=6 if (inlist(q2_18,5,6) & ilo_lfs==2)   // 24 months or more
		replace ilo_dur_details=7 if (q2_18==7 & ilo_lfs==2)            // Not elsewhere classified
		replace ilo_dur_details=7 if (ilo_dur_details==. & ilo_lfs==2) 	// Not elsewhere classified
		    lab def ilo_unemp_det 1 "Less than 1 month" 2 "1 month to less than 3 months" 3 "3 months to less than 6 months" ///
								4 "6 months to less than 12 months" 5 "12 months to less than 24 months" 6 "24 months or more" ///
								7 "Not elsewhere classified"
		    lab val ilo_dur_details ilo_unemp_det
		    lab var ilo_dur_details "Duration of unemployment (Details)"
					
	gen ilo_dur_aggregate=.
		replace ilo_dur_aggregate=1 if (inlist(ilo_dur_details,1,2,3) & ilo_lfs==2)     // Less than 6 months
		replace ilo_dur_aggregate=2 if (ilo_dur_details==4 & ilo_lfs==2)                // 6 to 12 months
		replace ilo_dur_aggregate=3 if (inlist(ilo_dur_details,5,6) & ilo_lfs==2)       // 12 months or more
		replace ilo_dur_aggregate=4 if (ilo_dur_aggregate==. & ilo_lfs==2)      		//Not elsewhere classified
		replace ilo_dur_aggregate=. if ilo_lfs!=2
			lab def ilo_unemp_aggr 1 "Less than 6 months" 2 "6 months to less than 12 months" 3 "12 months or more" 4 "Not elsewhere classified"
			lab val ilo_dur_aggregate ilo_unemp_aggr
			lab var ilo_dur_aggregate "Duration of unemployment (Aggregate)"
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	



***********************************************************************************************
*			PART 3.4. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

	gen ilo_olf_dlma=.
	   replace ilo_olf_dlma=1 if (q2_14==1 & q2_19==3 & ilo_lfs==3)			 		// Seeking, not available
       replace ilo_olf_dlma=2 if (q2_14==2 & inlist(q2_19,1,2) & ilo_lfs==3)		// Not seeking, available
	   replace ilo_olf_dlma=3 if (q2_14==2 & q2_19==3 & q2_16==1 & ilo_lfs==3)		// Not seeking, not available, willing
	   replace ilo_olf_dlma=4 if (q2_14==2 & q2_19==3 & q2_16==2 & ilo_lfs==3)		// Not seeking, not available, not willing
       replace ilo_olf_dlma=5 if (ilo_olf_dlma==. & ilo_lfs==3)						// Not classified 
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
		replace ilo_olf_reason=1 if	(inlist(q2_17,7,8,9,10) & ilo_lfs==3)		// Labour market
		replace ilo_olf_reason=2 if (inlist(q2_17,1,2,3) & ilo_lfs==3)			// Other labour market reasons
		replace ilo_olf_reason=3 if	(inlist(q2_17,4,5,6) & ilo_lfs==3)			// Personal/Family-related
		* replace ilo_olf_reason=4 if  											// Does not need/want to work
		replace ilo_olf_reason=5 if (inlist(q2_17,99,.) & ilo_lfs==3)			// Not elsewhere classified
		replace ilo_olf_reason=5 if (ilo_olf_reason==. & ilo_lfs==3)			// Not elsewhere classified
			    lab def reasons_lab 1 "1 - Labour market" 2 "2 - Other labour market reasons" 3 "3 - Personal / Family-related" ///
				    			    4 "4 - Does not need/want to work" 5 "5 - Not elsewhere classified"
				lab val ilo_olf_reason reasons_lab 
				lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seeker ('ilo_dis')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_dis=1 if (ilo_lfs==3 & inlist(q2_19,1,2) & ilo_olf_reason==1)
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

cd "$outpath"

		drop ilo_age 

		compress 
		
	   /*Save dataset including original and ilo variables*/
	
		save ${country}_${source}_${time}_FULL,  replace		
	
	  /* Save file only containing ilo_* variables*/
	
		keep ilo*

		save ${country}_${source}_${time}_ILO, replace
