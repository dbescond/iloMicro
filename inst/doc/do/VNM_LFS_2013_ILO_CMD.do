* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Viet Nam, 2013
* DATASET USED: Viet Nam LFS 2013
* NOTES: 
* Files created: Standard variables on LFS Viet Nam 2013
* Authors: ILO / Department of Statistics / DPAU

* Starting Date: 01 February 2018
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
global country "VNM"
global source "LFS"
global time "2013"
global inputFile "LFS_2013"
global inpath "${path}\\${country}\\${source}\\${time}\ORI"
global temppath "${path}\_Admin"
global outpath "${path}\\${country}\\${source}\\${time}"

*********************************************************************************************

* Load original dataset

*********************************************************************************************

cd "$inpath"
	use "$inputFile", clear
	*renaming everything in lower case
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
*			Key identifier ('ilo_key') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment:

	gen ilo_key=_n
		lab var ilo_key "Key unique identifier per individual"		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time period ('ilo_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment:

	* Year 
	gen ilo_time=1
		lab def lab_time 1 "$time"
		lab val ilo_time lab_time
		lab var ilo_time "Time (Gregorian Calendar)"		

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sample Weight ('ilo_wgt') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment:
		
*-- generates variable "to_drop" that will be split in two parts: annual part (to_drop_1) and quarterly part (to_drop_2)
   decode ilo_time, gen(to_drop)
   split to_drop, generate(to_drop_) parse(Q)

*-- generation of to_drop_2 that contains information on the quarter (if it is quarterly) or -9999 if its annual
   capture destring to_drop_2, replace force
   capture gen to_drop_2=-9999
   
*-- destring both variables
   destring to_drop_1, replace force
   destring to_drop_2, replace force   

*-- creating local variables for year and quarter   
   local Q = to_drop_2 in 1
   local Y = to_drop_1 in 1
   
*-- creating quarter variable based on the month of the interview (to drop afterwards)   
   gen quarter=.
       replace quarter=1 if inlist(thangdt,1,2,3)
       replace quarter=2 if inlist(thangdt,4,5,6)
	   replace quarter=3 if inlist(thangdt,7,8,9)
	   replace quarter=4 if inlist(thangdt,10,11,12)
	   
*-- annual case
gen ilo_wgt=.

if `Q' == -9999{
   replace ilo_wgt = w_p_13
}

*-- quarters        
else{
   replace ilo_wgt = w_p_13*4
   keep if quarter==`Q'
}
   lab var ilo_wgt "Sample weight"		
		
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

	gen ilo_geo=ttnt
		lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural"
		lab val ilo_geo ilo_geo_lab
		lab var ilo_geo "Geographical coverage"	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment:

	gen ilo_sex=c3
		lab def ilo_sex_lab 1 "1 - Male" 2 "2 - Female"
		lab var ilo_sex "Sex"
		lab val ilo_sex ilo_sex_lab


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: from the original variable -> if age is 95 years or more => 95

	gen ilo_age=c5
		lab var ilo_age "Age"
    
    *Age groups
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
*			Education ('ilo_edu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - ISCED 97 mapping: variable very closed to ISCED 97, use as well UNESCO mapping
*          http://uis.unesco.org/en/isced-mappings
*	       - Answer 7 in the questionnaire (vocational school) is mapped to upper secondary education
*          - The question is only asked to people aged 15 and more, so people below the age of 15 are 
*            classified under "Not elsewhere classified".

	gen ilo_edu_isced97=.
		replace ilo_edu_isced97=1 if c15==0  					// No schooling
		replace ilo_edu_isced97=2 if c15==1 					// Pre-primary education
		replace ilo_edu_isced97=3 if c15==2  		            // Primary education or first stage of basic education
		replace ilo_edu_isced97=4 if c15==3  		            // Lower secondary or second stage of basic education
		replace ilo_edu_isced97=5 if inlist(c15,4,5,6,7)	    // Upper secondary education
		*replace ilo_edu_isced97=6 if                         	// Post-secondary non-tertiary education
		replace ilo_edu_isced97=7 if inlist(c15,8,9)	        // First stage of tertiary education (not leading directly to an advanced research qualification)
		replace ilo_edu_isced97=8 if c15== 10    				// Second stage of tertiary education (leading to an advanced research qualification)
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
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Educational attendance ('ilo_edu_attendance')  	[done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - The question is only asked to people aged 15 and more. So people below the age of 
*            15 are uner "Not elsewhere classified".

	gen ilo_edu_attendance=.
		replace ilo_edu_attendance=1 if c13==1			                        // Attending 
		replace ilo_edu_attendance=2 if c13==2 			                        // Not attending 
		replace ilo_edu_attendance=3 if ilo_edu_attendance==.	                // Not elsewhere classified 
			    label def edu_att_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified" 
			label val ilo_edu_attendance edu_att_lab
			label var ilo_edu_attendance "Education (Attendance)"
			
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			           Marital status ('ilo_mrts') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: There is no information on union/cohabiting
	
	* Detailed
	gen ilo_mrts_details=.
	    replace ilo_mrts_details=1 if c8==1                                     // Single
		replace ilo_mrts_details=2 if c8==2                                     // Married
		*replace ilo_mrts_details=3 if                                          // Union / cohabiting
		replace ilo_mrts_details=4 if c8==3                                     // Widowed
		replace ilo_mrts_details=5 if c8==4                                     // Divorced / separated
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
*			Disability status ('ilo_dsb') 	[done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment: - No information available.

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
* Comment:	- Unemployment comprises those who are not in employment, actively looking for a 
*             job and available to start working the following week. It also includes people
*             not actively looking for a job because they are waiting for a job/starting a
*             business.	   
		
	gen ilo_lfs=.
		replace ilo_lfs=1 if c16==1 & ilo_wap==1  		                                // Employed
		replace ilo_lfs=1 if c17==1 & ilo_wap==1  		                                // Employed
		replace ilo_lfs=1 if c18==1 & ilo_wap==1                                        // Employed
		replace ilo_lfs=1 if c19==1 & ilo_wap==1  		                                // Employed
		replace ilo_lfs=1 if c21==1 & ilo_wap==1  		                                // Employed
		replace ilo_lfs=2 if (ilo_lfs!=1 & (c65==1 & c68==1) | 67==5) & ilo_wap==1      // Unemployed
		replace ilo_lfs=3 if !inlist(ilo_lfs,1,2) & ilo_wap==1                          // Outside the labour force
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
		replace ilo_mjh = 2 if inlist(c43,1,2) & ilo_lfs==1                     // More than one job
		replace ilo_mjh = 1 if ilo_mjh==. & ilo_lfs==1                          // Only one job
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
	* Detailled categories:
	  gen ilo_job1_ste_icse93=.
		  replace ilo_job1_ste_icse93=1 if c28==4	& ilo_lfs==1			    // Employees
		  replace ilo_job1_ste_icse93=2 if c28==1	& ilo_lfs==1			    // Employers
		  replace ilo_job1_ste_icse93=3 if c28==2	& ilo_lfs==1			    // Own-account workers
		  replace ilo_job1_ste_icse93=4 if c28==5	& ilo_lfs==1			    // Producer cooperatives
		  replace ilo_job1_ste_icse93=5 if c28==3	& ilo_lfs==1			    // Contributing family workers
		  replace ilo_job1_ste_icse93=6 if inlist(c28,9,.) & ilo_lfs==1	        // Not classifiable
		  replace ilo_job1_ste_icse93=. if ilo_lfs!=1
				  label def label_ilo_ste_icse93 1 "1 - Employees" 2 "2 - Employers" 3 "3 - Own-account workers"  4 "4 - Members of producers cooperatives" ///
					                             5 "5 - Contributing family workers" 6 "6 - Workers not classifiable by status"
				  label val ilo_job1_ste_icse93 label_ilo_ste_icse93
				  label var ilo_job1_ste_icse93 "Status in employment (ICSE 93) - main job"
		
	* Aggregate categories 
	  gen ilo_job1_ste_aggregate=.
		  replace ilo_job1_ste_aggregate=1 if ilo_job1_ste_icse93==1			// Employees
		  replace ilo_job1_ste_aggregate=2 if inrange(ilo_job1_ste_icse93,2,5)	// Self-employed
		  replace ilo_job1_ste_aggregate=3 if ilo_job1_ste_icse93==6			// Not elsewhere classified
				  label def ste_aggr_lab 1 "1 - Employees" 2 "2 - Self-employed" 3 "3 - Not elsewhere classified"
				  label val ilo_job1_ste_aggregate ste_aggr_lab
			      label var ilo_job1_ste_aggregate "Status in employment (Aggregate) - main job" 

		
	* SECOND JOB:
	* Detailled categories:
	  gen ilo_job2_ste_icse93=.
		  replace ilo_job2_ste_icse93=1 if c50==4	& ilo_mjh==2			    // Employees
		  replace ilo_job2_ste_icse93=2 if c50==1	& ilo_mjh==2			    // Employers
		  replace ilo_job2_ste_icse93=3 if c50==2	& ilo_mjh==2			    // Own-account workers
		  replace ilo_job2_ste_icse93=4 if c50==5	& ilo_mjh==2			    // Producer cooperatives
		  replace ilo_job2_ste_icse93=5 if c50==3	& ilo_mjh==2			    // Contributing family workers
		  replace ilo_job2_ste_icse93=6 if inlist(c50,9,.) & ilo_mjh==2	        // Not classifiable
		  replace ilo_job2_ste_icse93=. if ilo_mjh!=2
				  label val ilo_job2_ste_icse93 label_ilo_ste_icse93
				  label var ilo_job2_ste_icse93 "Status in employment (ICSE 93) - second job"
	
	* Aggregate categories 
   	  gen ilo_job2_ste_aggregate=.
		  replace ilo_job2_ste_aggregate=1 if ilo_job2_ste_icse93==1			// Employees
		  replace ilo_job2_ste_aggregate=2 if inrange(ilo_job2_ste_icse93,2,5)	// Self-employed
		  replace ilo_job2_ste_aggregate=3 if ilo_job2_ste_icse93==6			// Not elsewhere classified
			  	  label val ilo_job2_ste_aggregate ste_aggr_lab
				  label var ilo_job2_ste_aggregate "Status in employment (Aggregate) - second job" 
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - National classification is based on ISIC Rev. 4 at a 2 digit-level.
		
    * MAIN JOB:
	* ISIC Rev. 4 - 2 digit
	gen isic2dig = int(c25/100) if ilo_lfs==1 
		replace isic2dig=. if isic2dig==0
						
	gen ilo_job1_eco_isic4_2digits = .
	    replace ilo_job1_eco_isic4_2digits = isic2dig if ilo_lfs==1
				lab def eco_isic4_2digits 1 "01 - Crop and animal production, hunting and related service activities"	2 "02 - Forestry and logging"	3 "03 - Fishing and aquaculture"	5 "05 - Mining of coal and lignite"	///
                                          6 "06 - Extraction of crude petroleum and natural gas"	7 "07 - Mining of metal ores"	8 "08 - Other mining and quarrying"	9 "09 - Mining support service activities"	///
                                          10 "10 - Manufacture of food products"	11 "11 - Manufacture of beverages"	12 "12 - Manufacture of tobacco products"	13 "13 - Manufacture of textiles"	///
                                          14 "14 - Manufacture of wearing apparel"	15 "15 - Manufacture of leather and related products"	16 "16 - Manufacture of wood and of products of wood and cork, except furniture; manufacture of articles of straw and plaiting materials"	17 "17 - Manufacture of paper and paper products"	///
                                          18 "18 - Printing and reproduction of recorded media"	19 "19 - Manufacture of coke and refined petroleum products"	20 "20 - Manufacture of chemicals and chemical products"	21 "21 - Manufacture of basic pharmaceutical products and pharmaceutical preparations"	///
                                          22 "22 - Manufacture of rubber and plastics products"	23 "23 - Manufacture of other non-metallic mineral products"	24 "24 - Manufacture of basic metals"	25 "25 - Manufacture of fabricated metal products, except machinery and equipment"	///
                                          26 "26 - Manufacture of computer, electronic and optical products"	27 "27 - Manufacture of electrical equipment"	28 "28 - Manufacture of machinery and equipment n.e.c."	29 "29 - Manufacture of motor vehicles, trailers and semi-trailers"	///
                                          30 "30 - Manufacture of other transport equipment"	31 "31 - Manufacture of furniture"	32 "32 - Other manufacturing"	33 "33 - Repair and installation of machinery and equipment"	///
                                          35 "35 - Electricity, gas, steam and air conditioning supply"	36 "36 - Water collection, treatment and supply"	37 "37 - Sewerage"	38 "38 - Waste collection, treatment and disposal activities; materials recovery"	///
                                          39 "39 - Remediation activities and other waste management services"	41 "41 - Construction of buildings"	42 "42 - Civil engineering"	43 "43 - Specialized construction activities"	///
								          45 "45 - Wholesale and retail trade and repair of motor vehicles and motorcycles"	46 "46 - Wholesale trade, except of motor vehicles and motorcycles"	47 "47 - Retail trade, except of motor vehicles and motorcycles"	49 "49 - Land transport and transport via pipelines"	///
                                          50 "50 - Water transport"	51 "51 - Air transport"	52 "52 - Warehousing and support activities for transportation"	53 "53 - Postal and courier activities"	///
                                          55 "55 - Accommodation"	56 "56 - Food and beverage service activities"	58 "58 - Publishing activities"	59 "59 - Motion picture, video and television programme production, sound recording and music publishing activities"	///
                                          60 "60 - Programming and broadcasting activities"	61 "61 - Telecommunications"	62 "62 - Computer programming, consultancy and related activities"	63 "63 - Information service activities"	///
                                          64 "64 - Financial service activities, except insurance and pension funding"	65 "65 - Insurance, reinsurance and pension funding, except compulsory social security"	66 "66 - Activities auxiliary to financial service and insurance activities"	68 "68 - Real estate activities"	///
                                          69 "69 - Legal and accounting activities"	70 "70 - Activities of head offices; management consultancy activities"	71 "71 - Architectural and engineering activities; technical testing and analysis"	72 "72 - Scientific research and development"	///
                                          73 "73 - Advertising and market research"	74 "74 - Other professional, scientific and technical activities"	75 "75 - Veterinary activities"	77 "77 - Rental and leasing activities"	///
                                          78 "78 - Employment activities"	79 "79 - Travel agency, tour operator, reservation service and related activities"	80 "80 - Security and investigation activities"	81 "81 - Services to buildings and landscape activities"	///
                                          82 "82 - Office administrative, office support and other business support activities"	84 "84 - Public administration and defence; compulsory social security"	85 "85 - Education"	86 "86 - Human health activities"	///
                                          87 "87 - Residential care activities"	88 "88 - Social work activities without accommodation"	90 "90 - Creative, arts and entertainment activities"	91 "91 - Libraries, archives, museums and other cultural activities"	///
                                          92 "92 - Gambling and betting activities"	93 "93 - Sports activities and amusement and recreation activities"	94 "94 - Activities of membership organizations"	95 "95 - Repair of computers and personal and household goods"	///
                                          96 "96 - Other personal service activities"	97 "97 - Activities of households as employers of domestic personnel"	98 "98 - Undifferentiated goods- and services-producing activities of private households for own use"	99 "99 - Activities of extraterritorial organizations and bodies"	
		lab values ilo_job1_eco_isic4_2digits eco_isic4_2digits
		lab var ilo_job1_eco_isic4_2digits "Economic activity (ISIC Rev. 4), 2 digit level - main job"
							
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
		        lab def eco_isic4 1 "A - Agriculture, forestry and fishing"	2 "B - Mining and quarrying"	3 "C - Manufacturing"	4 "D - Electricity, gas, steam and air conditioning supply"	///
                                  5 "E - Water supply; sewerage, waste management and remediation activities"	6 "F - Construction"	7 "G - Wholesale and retail trade; repair of motor vehicles and motorcycles"	8 "H - Transportation and storage"	///
                                  9 "I - Accommodation and food service activities"	10 "J - Information and communication"	11 "K - Financial and insurance activities"	12 "L - Real estate activities"	///
                                  13 "M - Professional, scientific and technical activities"	14 "N - Administrative and support service activities"	15 "O - Public administration and defence; compulsory social security"	16 "P - Education"	///
                                  17 "Q - Human health and social work activities"	18 "R - Arts, entertainment and recreation"	19 "S - Other service activities"	20 "T - Activities of households as employers; undifferentiated goods- and services-producing activities of households for own use"	///
                                  21 "U - Activities of extraterritorial organizations and bodies"	22 "X - Not elsewhere classified"			
			    lab val ilo_job1_eco_isic4 eco_isic4
				lab var ilo_job1_eco_isic4 "Economic activity (ISIC Rev. 4) - main job"

						
	* Aggregated level 
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
   gen isic2dig_job2 = int(c47/100) if ilo_mjh==2
	   replace isic2dig_job2=. if isic2dig_job2==0

   gen ilo_job2_eco_isic4_2digits=isic2dig_job2 if ilo_mjh==2
	   lab values ilo_job2_eco_isic4_2digits eco_isic4_2digits
	   lab var ilo_job2_eco_isic4_2digits "Economic activity (ISIC Rev. 4), 2 digit level - second job"
							
			
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
			    lab val ilo_job2_eco_isic4 eco_isic4
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
				lab val ilo_job2_eco_aggregate eco_aggr_lab
				lab var ilo_job2_eco_aggregate "Economic activity (Aggregate) - second job"
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_job1_ocu_isco08') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment: Viet Nam uses its own classification based on ISCO 08 (possible to be mapped at 1
*          digit level).

   * MAIN JOB:
   	 gen occup_1dig=int(c22/1000) if ilo_lfs==1 & c22>0
	
	
   * ISCO 08 - 1 digit:
	 gen ilo_job1_ocu_isco08=.
	     replace ilo_job1_ocu_isco08 = 11 if occup_1dig==. & ilo_lfs==1                     // Not elsewhere classified
		 replace ilo_job1_ocu_isco08 = occup_1dig if (ilo_job1_ocu_isco08==. & ilo_lfs==1)  // The rest of the occupations
		 replace ilo_job1_ocu_isco08 = 10 if ilo_job1_ocu_isco08==0 & ilo_lfs==1            // Armed forces
	             lab def ocu_isco08 1 "1 - Managers"	2 "2 - Professionals"	3 "3 - Technicians and associate professionals"	4 "4 - Clerical support workers"	///
                                    5 "5 - Service and sales workers"	6 "6 - Skilled agricultural, forestry and fishery workers"	7 "7 - Craft and related trades workers"	8 "8 - Plant and machine operators, and assemblers"	///
                                    9 "9 - Elementary occupations"	10 "0 - Armed forces occupations"	11 "X - Not elsewhere classified"		
		         lab values ilo_job1_ocu_isco08 ocu_isco08
				 lab var ilo_job1_ocu_isco08 "Occupation (ISCO-08) - main job"
	
  * Aggregate
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
	gen occup_1dig_job2=int(c44/1000) if ilo_mjh==2 & c44>0
	
	
  * ISCO 08 - 1 digit:
	gen ilo_job2_ocu_isco08=.
	    replace ilo_job2_ocu_isco08 = 11 if occup_1dig_job2==. & ilo_mjh==2                     // Not elsewhere classified
		replace ilo_job2_ocu_isco08 = occup_1dig_job2 if ilo_job2_ocu_isco08==. & ilo_mjh==2    // The rest of the occupations
		replace ilo_job2_ocu_isco08 = 10 if ilo_job2_ocu_isco08==0 & ilo_mjh==2                // Armed forces
				lab values ilo_job2_ocu_isco08 ocu_isco08
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
		replace ilo_job2_ocu_aggregate=. if ilo_mjh!=2
				lab val ilo_job2_ocu_aggregate ocu_aggr_lab
				lab var ilo_job2_ocu_aggregate "Occupation (Aggregate) - second job"	
				
  * Skill level
	gen ilo_job2_ocu_skill=.
	    replace ilo_job2_ocu_skill=1 if ilo_job2_ocu_isco08==9                   // Low
		replace ilo_job2_ocu_skill=2 if inlist(ilo_job2_ocu_isco08,4,5,6,7,8)    // Medium
		replace ilo_job2_ocu_skill=3 if inlist(ilo_job2_ocu_isco08,1,2,3)        // High
		replace ilo_job2_ocu_skill=4 if inlist(ilo_job2_ocu_isco08,10,11)        // Not elsewhere classified
				lab val ilo_job2_ocu_skill ocu_skill_lab
			    lab var ilo_job2_ocu_skill "Occupation (Skill level) - second job"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_job1_ins_sector') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment: - Public: state agency, state non-productive unit, state entreprise
	
	* MAIN JOB:
	gen ilo_job1_ins_sector=.
		replace ilo_job1_ins_sector=1 if inrange(c23,5,7) & ilo_lfs==1			// Public
		replace ilo_job1_ins_sector=2 if ilo_job1_ins_sector!=1 & ilo_lfs==1	// Private
				lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private" 
				lab values ilo_job1_ins_sector ins_sector_lab
				lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities - main job"
	
	* SECOND JOB:
	gen ilo_job2_ins_sector=.
		replace ilo_job2_ins_sector=1 if inrange(c45,5,7) & ilo_mjh==2			// Public
		replace ilo_job2_ins_sector=2 if ilo_job2_ins_sector!=1 & ilo_mjh==2	// Private
				lab values ilo_job2_ins_sector ins_sector_lab
				lab var ilo_job2_ins_sector "Institutional sector (private/public) of economic activities - second job"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Formal / Informal Economy ('ilo_job1_ife_prod' 'ilo_job1_ife_nature') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
* Comment: 

/*	Useful questions:
			- Institutional sector: c23
			- Destination of production: not asked.
			- Bookkeeping: not asked (only asked whether there are written accounts but not its destination)
			- Registration: c27a & c27b (considered registered if answer's yes to both)
			- Status in employment: ilo_job1_ste_aggregate
			- Social security contribution: c32c (pay for social insurance)
			- Household: ilo_job1_eco_isic4_2digits==97
			- Place of work: c26 (bc question on the size is not asked)
			- Size: not asked
			- Paid annual leave: c32a -> receive paid public holidays/leaves?
			- Paid sick leave: not asked.
*/
	
    * Social security (to be dropped afterwards): 
            gen social_security=.
			    replace social_security=1 if (c32c==1 & ilo_lfs==1)             // Pay for social insurance
				replace social_security=2 if (c32c==2 & ilo_lfs==1)             // No pay for social insurance
				replace social_security=. if (social_security==. & ilo_lfs==1)
    * Registration 
            gen registration=.
			    replace registration=1 if (c27a==1 & c27b==1) & ilo_lfs==1      // Business registration and Tax code registration
				replace registration=2 if (c27a==2 | c27b==2) & ilo_lfs==1      // No business registration or no tax code registraiton
				replace registration=. if (registration==. & ilo_lfs==1)

	* 1) UNIT OF PRODUCTION: FORMAL/INFORMAL SECTOR		
    gen ilo_job1_ife_prod=.
	    replace ilo_job1_ife_prod=3 if ilo_lfs==1 & ///
	                                  (ilo_job1_eco_isic4_2digits==97)
	 	replace ilo_job1_ife_prod=2 if ilo_lfs==1 & ilo_job1_ife_prod!=3 & ///
				                      ((inlist(c23,5,6,7)) | /// 
									  (!inlist(c23,5,6,7) & registration==1) | ///
									  (!inlist(c23,5,6,7) & registration==. & ilo_job1_ste_aggregate==1 & social_security==1))
		replace ilo_job1_ife_prod=1 if ilo_lfs==1 & ilo_job1_ife_prod!=2 & ilo_job1_ife_prod!=3 & ///
				                      ((!inlist(c23,5,6,7) & registration==2) | ///
									  (!inlist(c23,5,6,7) & registration==. & ilo_job1_ste_aggregate==1 & inlist(social_security,2,.)) | ///
									  (!inlist(c23,5,6,7) & registration==. & ilo_job1_ste_aggregate!=1))
				lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 
				lab val ilo_job1_ife_prod ilo_ife_prod_lab
				lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"
						
						
	* 2) NATURE OF JOB: FORMAL/INFORMAL EMPLOYMENT
    gen ilo_job1_ife_nature=.
		replace ilo_job1_ife_nature=1 if ilo_lfs==1 & ///
			                            ((inlist(ilo_job1_ste_icse93,1,6) & inlist(social_security,2,.)) | ///
										(inlist(ilo_job1_ste_icse93,2,4) & inlist(ilo_job1_ife_prod,1,3)) | ///
										(ilo_job1_ste_icse93==3 & inlist(ilo_job1_ife_prod,1,3)) | ///
										(ilo_job1_ste_icse93==5))
		replace ilo_job1_ife_nature=2 if ilo_lfs==1 & ///
			                            ((inlist(ilo_job1_ste_icse93,1,6) & social_security==1) | ///
										(inlist(ilo_job1_ste_icse93,2,4) & ilo_job1_ife_prod==2) | ///
										(ilo_job1_ste_icse93==3 & ilo_job1_ife_prod==2)) 
			    lab def ife_nature_lab 1 "1 - Persons with informal main job" 2 "2 - Persons with formal main job"
			    lab val ilo_job1_ife_nature ife_nature_lab
			    lab var ilo_job1_ife_nature "Informal / Formal Economy (Nature of job)"
					  
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Hours of work ('ilo_how') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment:
		
 * MAIN JOB:
 * 1) Weekly hours ACTUALLY worked:
   gen ilo_job1_how_actual=c39 if ilo_lfs==1
       replace ilo_job1_how_actual=. if ilo_job1_how_actual<0
		       lab var ilo_job1_how_actual "Weekly hours actually worked - main job"
					
   gen ilo_job1_how_actual_bands=.
	   replace ilo_job1_how_actual_bands=1 if ilo_job1_how_actual==0
	   replace ilo_job1_how_actual_bands=2 if ilo_job1_how_actual>=1 & ilo_job1_how_actual<=14
	   replace ilo_job1_how_actual_bands=3 if ilo_job1_how_actual>14 & ilo_job1_how_actual<=29
	   replace ilo_job1_how_actual_bands=4 if ilo_job1_how_actual>29 & ilo_job1_how_actual<=34
	   replace ilo_job1_how_actual_bands=5 if ilo_job1_how_actual>34 & ilo_job1_how_actual<=39
	   replace ilo_job1_how_actual_bands=6 if ilo_job1_how_actual>39 & ilo_job1_how_actual<=48
	   replace ilo_job1_how_actual_bands=7 if ilo_job1_how_actual>48 & ilo_job1_how_actual!=.
	   replace ilo_job1_how_actual_bands=8 if ilo_job1_how_actual==. & ilo_lfs==1
	   replace ilo_job1_how_actual_bands=. if ilo_lfs!=1
	           lab def how_bands_lab 1 "No hours usually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"
			   lab val ilo_job1_how_actual_bands how_bands_lab
			   lab var ilo_job1_how_actual_bands "Weekly hours actually worked bands - main job"
		
  * 2) Weekly hours USUALLY worked:
    gen ilo_job1_how_usual=c40 if ilo_lfs==1
	    replace ilo_job1_how_usual=. if ilo_job1_how_usual<0
				lab var ilo_job1_how_usual "Weekly hours usually worked - main job"
					 
    gen ilo_job1_how_usual_bands=.
	 	replace ilo_job1_how_usual_bands=1 if ilo_job1_how_usual==0
		replace ilo_job1_how_usual_bands=2 if ilo_job1_how_usual>=1 & ilo_job1_how_usual<=14
		replace ilo_job1_how_usual_bands=3 if ilo_job1_how_usual>14 & ilo_job1_how_usual<=29
		replace ilo_job1_how_usual_bands=4 if ilo_job1_how_usual>29 & ilo_job1_how_usual<=34
		replace ilo_job1_how_usual_bands=5 if ilo_job1_how_usual>34 & ilo_job1_how_usual<=39
		replace ilo_job1_how_usual_bands=6 if ilo_job1_how_usual>39 & ilo_job1_how_usual<=48
		replace ilo_job1_how_usual_bands=7 if ilo_job1_how_usual>48 & ilo_job1_how_usual!=.
		replace ilo_job1_how_usual_bands=8 if ilo_job1_how_usual==. & ilo_lfs==1
		replace ilo_job1_how_usual_bands=. if ilo_lfs!=1
				lab val ilo_job1_how_usual_bands how_bands_lab
				lab var ilo_job1_how_usual_bands "Weekly hours usually worked bands - main job"
		
		
   * SECOND JOB
   * 1) Weekly hours ACTUALLY worked:
   gen ilo_job2_how_actual=c58 if ilo_mjh==2
	   replace ilo_job2_how_actual=. if ilo_job2_how_actual<0
			   lab var ilo_job2_how_actual "Weekly hours actually worked - second job"
		
   gen ilo_job2_how_actual_bands=.
	   replace ilo_job2_how_actual_bands=1 if ilo_job2_how_actual==0
	   replace ilo_job2_how_actual_bands=2 if ilo_job2_how_actual>=1 & ilo_job2_how_actual<=14
	   replace ilo_job2_how_actual_bands=3 if ilo_job2_how_actual>14 & ilo_job2_how_actual<=29
	   replace ilo_job2_how_actual_bands=4 if ilo_job2_how_actual>29 & ilo_job2_how_actual<=34
	   replace ilo_job2_how_actual_bands=5 if ilo_job2_how_actual>34 & ilo_job2_how_actual<=39
	   replace ilo_job2_how_actual_bands=6 if ilo_job2_how_actual>39 & ilo_job2_how_actual<=48
	   replace ilo_job2_how_actual_bands=7 if ilo_job2_how_actual>48 & ilo_job2_how_actual!=.
	   replace ilo_job2_how_actual_bands=8 if ilo_job2_how_actual==. & ilo_lfs==1
	   replace ilo_job2_how_actual_bands=. if ilo_mjh!=2
			   lab val ilo_job2_how_actual_bands how_bands_lab
			   lab var ilo_job2_how_actual_bands "Weekly hours actually worked bands - second job"
		
	* 2) Weekly hours USUALLY worked:
    * No information available.
		
		
	* ALL JOBS:
    * 1) Weekly hours ACTUALLY worked:
	gen ilo_joball_how_actual=c61 if ilo_lfs==1
	    replace ilo_joball_how_actual=. if ilo_joball_how_actual<0
			    lab var ilo_joball_how_actual "Weekly hours actually worked - all jobs"
						
    gen ilo_joball_how_actual_bands=.
	    replace ilo_joball_how_actual_bands=1 if ilo_joball_how_actual==0
	    replace ilo_joball_how_actual_bands=2 if ilo_joball_how_actual>=1 & ilo_joball_how_actual<=14
	    replace ilo_joball_how_actual_bands=3 if ilo_joball_how_actual>14 & ilo_joball_how_actual<=29
	    replace ilo_joball_how_actual_bands=4 if ilo_joball_how_actual>29 & ilo_joball_how_actual<=34
	    replace ilo_joball_how_actual_bands=5 if ilo_joball_how_actual>34 & ilo_joball_how_actual<=39
	    replace ilo_joball_how_actual_bands=6 if ilo_joball_how_actual>39 & ilo_joball_how_actual<=48
	    replace ilo_joball_how_actual_bands=7 if ilo_joball_how_actual>48 & ilo_joball_how_actual!=.
	    replace ilo_joball_how_actual_bands=8 if ilo_joball_how_actual==. & ilo_lfs==1
	    replace ilo_joball_how_actual_bands=. if ilo_lfs!=1
			    lab val ilo_joball_how_actual_bands how_bands_lab
			    lab var ilo_joball_how_actual_bands "Weekly hours actually worked bands - all jobs"
						
						
	* 2) Weekly hours USUALLY worked:
	* No information available.
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job1_job_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
* Comment: - The question is not asked directly; thus, we take the median of actual hours of 
*            work (because usual hours of work is not available) for all jobs which is 42.
	   
	   gen ilo_job1_job_time=.
		   replace ilo_job1_job_time=1 if ilo_job1_how_usual<42 
		   replace ilo_job1_job_time=2 if ilo_job1_how_usual>=42 & ilo_job1_how_usual!=.
		   replace ilo_job1_job_time=3 if ilo_job1_job_time!=1 & ilo_job1_job_time!=2 & ilo_lfs==1
				   lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
				   lab val ilo_job1_job_time job_time_lab
				   lab var ilo_job1_job_time "Job (Working time arrangement) - Main job"	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job1_job_contract') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
* Comment: - The categories of the question asking for the type of contract mix answers 
*          related to the length of the contract (temporary or permanent)and the form of 
*          contract (oral, no contract). Given the large amount of people answering either oral 
*          agreement or no contract, this variable is not created.

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Monthly labour related income ('ilo_job1_lri') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
* Comments: - No information available for self-employed.
*           - The original amounts recorded are in thousands, so they are multiplied by 1000 
*             to have units.
*           - It includes overtime remunerations, bonuses and other welfare payments [T34:2127]
*           - Unit: local currency (dongs)
	   
	* MAIN JOB:
	gen wage=.
	    replace wage = c36 if c36>=0 & ilo_job1_ste_aggregate==1
	    replace wage = wage*1000
			 
	gen other_payments=.
	    replace other_payments = c38 if c38>=0 & ilo_job1_ste_aggregate==1
	    replace other_payments = other_payments*1000
				
	* Employees
    egen ilo_job1_lri_ees = rowtotal(wage other_payments), m
	     replace ilo_job1_lri_ees=. if ilo_job1_ste_aggregate!=1
			     lab var ilo_job1_lri_ees "Monthly earnings of employees - main job"	
		
		
    * SECOND JOB:
	gen wage2=.
	    replace wage2 = c56 if c56>=0 & ilo_job2_ste_aggregate==1
        replace wage2 = wage2 *1000
			
    gen other_payments2=.
	    replace other_payments2 = c57 if c57>=0 & ilo_job2_ste_aggregate==1 
	    replace other_payments2 = other_payments2*1000	
				
	* Employees
    egen ilo_job2_lri_ees = rowtotal(wage2 other_payments2), m
	     replace ilo_job2_lri_ees=. if ilo_job2_ste_aggregate!=1
		         lab var ilo_job2_lri_ees "Monthly earnings of employees - second job"	
		
***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_joball_tru') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
* Comment: - Following the country's report the threshold is set at 35 hours actually worked 
*            in all jobs.
				
	gen ilo_joball_tru=.
	    replace ilo_joball_tru=1 if ilo_lfs==1 & c62==1 & c63==1 & c64>0 & ilo_joball_how_actual<35
		        lab def ilo_tru 1 "Time-related underemployed"
				lab val ilo_joball_tru ilo_tru
				lab var ilo_joball_tru "Time-related underemployed"				
					
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupational injury ('ilo_joball_inj_case', 'ilo_joball_inj_day') [done] 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
* Comment: - No information available.

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
			replace ilo_cat_une=1 if ilo_lfs==2 & c73==1			            // Previously employed
			replace ilo_cat_une=2 if ilo_lfs==2 & c73==2			            // Seeking first job
			replace ilo_cat_une=3 if ilo_lfs==2 & ilo_cat_une==.	            // Unknown
				lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
				lab val ilo_cat_une cat_une_lab
				lab var ilo_cat_une "Category of unemployment"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Only asked to those who were previously employed and therefore those who have 
*            never worked are classified undet "Not elsewhere classified".
*          - Category 1 to 3 months includes less than 1 month (note to value [C7:3905])
*          - Category 12 to 24 months includes 24 months or more (note to value [C7:3716])

	* Detailed categories		
    gen ilo_dur_details=.
	    *replace ilo_dur_details=1 if                                           // Less than 1 month
		replace ilo_dur_details=2 if (c74==1 & ilo_lfs==2)                      // 1 to 3 months (including less than 1 month) [C7:3905]
		replace ilo_dur_details=3 if (c74==2 & ilo_lfs==2)                      // 3 to 6 months
		replace ilo_dur_details=4 if (inlist(c74,3,4) & ilo_lfs==2)             // 6 to 12 months
		replace ilo_dur_details=5 if (inlist(c74,5,6) & ilo_lfs==2)             // 12 to 24 months (including 24 months or more) [C7:3716]
		*replace ilo_dur_details=6 if                                           // 24 months or more
		replace ilo_dur_details=7 if (ilo_dur_details==. & ilo_lfs==2)          // Not elsewhere classified
		        lab def ilo_unemp_det 1 "1 - Less than 1 month" 2 "2 - 1 month to less than 3 months" 3 "3 - 3 months to less than 6 months" ///
									  4 "4 - 6 months to less than 12 months" 5 "5 - 12 months to less than 24 months" 6 "6 - 24 months or more" ///
									  7 "7 - Not elsewhere classified"
			    lab val ilo_dur_details ilo_unemp_det
			    lab var ilo_dur_details "Duration of unemployment (Details)"

    * Aggregate categories
	gen ilo_dur_aggregate=.
		replace ilo_dur_aggregate=1 if (inlist(ilo_dur_details,1,2,3) & ilo_lfs==2)   // Less than 6 months
		replace ilo_dur_aggregate=2 if (ilo_dur_details==4 & ilo_lfs==2)              // 6 to 12 months
		replace ilo_dur_aggregate=3 if (inlist(ilo_dur_details,5,6) & ilo_lfs==2)     // 12 months or more
		replace ilo_dur_aggregate=4 if (ilo_dur_details==7 & ilo_lfs==2)              // Not elsewhere classified
		replace ilo_dur_aggregate=. if ilo_lfs!=2
			    lab def ilo_unemp_aggr 1 "1 - Less than 6 months" 2 "2 - 6 months to less than 12 months" 3 "3 - 12 months or more" 4 "4 - Not elsewhere classified"
			    lab val ilo_dur_aggregate ilo_unemp_aggr
			    lab var ilo_dur_aggregate "Duration of unemployment (Aggregate)"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
* Comment: - National classification follows ISIC Rev. 4 (2 digit level)

	* ISIC Rev. 4 - 2 digit
	  gen indu_code_une_2dig=int(c80/100) 
		  replace indu_code_une_2dig=. if indu_code_une_2dig==0
					
	  gen ilo_preveco_isic4_2digits=.
		  replace ilo_preveco_isic4_2digits=indu_code_une_2dig if ilo_lfs==2 & ilo_cat_une==1
		  replace ilo_preveco_isic4_2digits=. if ilo_preveco_isic4<=0
		          lab values ilo_preveco_isic4_2digits eco_isic4_2digits
	              lab var ilo_preveco_isic4_2digits "Previous economic activity (ISIC Rev. 4), 2 digit level"
							
	* ISIC Rev. 4 - 1 digit
	  gen ilo_preveco_isic4=.
		  replace ilo_preveco_isic4=1 if inrange(ilo_preveco_isic4_2digits,1,3)
		  replace ilo_preveco_isic4=2 if inrange(ilo_preveco_isic4_2digits,5,9)
		  replace ilo_preveco_isic4=3 if inrange(ilo_preveco_isic4_2digits,10,33)
		  replace ilo_preveco_isic4=4 if ilo_preveco_isic4_2digits==35
		  replace ilo_preveco_isic4=5 if inrange(ilo_preveco_isic4_2digits,36,39)
		  replace ilo_preveco_isic4=6 if inrange(ilo_preveco_isic4_2digits,41,43)
		  replace ilo_preveco_isic4=7 if inrange(ilo_preveco_isic4_2digits,45,47)
		  replace ilo_preveco_isic4=8 if inrange(ilo_preveco_isic4_2digits,49,53)
		  replace ilo_preveco_isic4=9 if inrange(ilo_preveco_isic4_2digits,55,56)
		  replace ilo_preveco_isic4=10 if inrange(ilo_preveco_isic4_2digits,58,63)
		  replace ilo_preveco_isic4=11 if inrange(ilo_preveco_isic4_2digits,64,66)
		  replace ilo_preveco_isic4=12 if ilo_preveco_isic4_2digits==68
		  replace ilo_preveco_isic4=13 if inrange(ilo_preveco_isic4_2digits,69,75)
		  replace ilo_preveco_isic4=14 if inrange(ilo_preveco_isic4_2digits,77,82)
		  replace ilo_preveco_isic4=15 if ilo_preveco_isic4_2digits==84
		  replace ilo_preveco_isic4=16 if ilo_preveco_isic4_2digits==85
		  replace ilo_preveco_isic4=17 if inrange(ilo_preveco_isic4_2digits,86,88)
		  replace ilo_preveco_isic4=18 if inrange(ilo_preveco_isic4_2digits,90,93)
		  replace ilo_preveco_isic4=19 if inrange(ilo_preveco_isic4_2digits,94,96)
		  replace ilo_preveco_isic4=20 if inrange(ilo_preveco_isic4_2digits,97,98)
		  replace ilo_preveco_isic4=21 if ilo_preveco_isic4_2digits==99
		  replace ilo_preveco_isic4=22 if ilo_preveco_isic4==. & ilo_cat_une==1
			      lab val ilo_preveco_isic4 eco_isic4
				  lab var ilo_preveco_isic4 "Previous economic activity (ISIC Rev. 4)"
							
	* Aggregated level 
	  gen ilo_preveco_aggregate=.
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
*			Previous occupation ('ilo_prevocu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
* Comment: - The country uses its own classification that can be mapped to ISCO 08 at 1 digit.
	     
  * MAIN JOB:
    gen prev_occup=int(c76/1000) if c76>0
	
  * ISCO 88 - 1 digit:
	gen ilo_prevocu_isco08=.
	    replace ilo_prevocu_isco08 = 11 if prev_occup==. & ilo_lfs==2 & ilo_cat_une==1                    // Not elsewhere classified
		replace ilo_prevocu_isco08 = prev_occup if ilo_prevocu_isco08==. & ilo_lfs==2 & ilo_cat_une==1    // The rest of the occupations
		replace ilo_prevocu_isco08 = 10 if ilo_prevocu_isco08==0 & ilo_lfs==2 & ilo_cat_une==1            // Armed forces
				lab values ilo_prevocu_isco08 ocu_isco08
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
		replace ilo_prevocu_aggregate=. if ilo_lfs!=2 
		replace ilo_prevocu_aggregate=. if ilo_cat_une!=1
				lab val ilo_prevocu_aggregate ocu_aggr_lab
				lab var ilo_prevocu_aggregate "Previous occupation (Aggregate)"	
				
  * Skill level
	gen ilo_prevocu_skill=.
	    replace ilo_prevocu_skill=1 if ilo_prevocu_isco08==9                    // Low
		replace ilo_prevocu_skill=2 if inlist(ilo_prevocu_isco08,4,5,6,7,8)     // Medium
		replace ilo_prevocu_skill=3 if inlist(ilo_prevocu_isco08,1,2,3)         // High
		replace ilo_prevocu_skill=4 if inlist(ilo_prevocu_isco08,10,11)         // Not elsewhere classified
			    lab val ilo_prevocu_skill ocu_skill_lab
			    lab var ilo_prevocu_skill "Previous occupation (Skill level)"
	
***********************************************************************************************
*			PART 3.3. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment:	- No information available concerning willingness, therefore, categories 3 and 4
*             are not possible to be produced.
	
	gen ilo_olf_dlma=.
		replace ilo_olf_dlma = 1 if c65==1 & c68==2 & ilo_lfs==3 				// Seeking, not available
		replace ilo_olf_dlma = 2 if c65==2 & c68==1 & ilo_lfs==3				// Not seeking, available
		* replace ilo_olf_dlma = 3 if 											// Not seeking, not available, willing
		* replace ilo_olf_dlma = 4 if 		                                    // Not seeking, not available, not willing
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
			replace ilo_olf_reason=1 if	inlist(c67,2,3) & ilo_lfs==3		    // Labour market
			replace ilo_olf_reason=2 if inlist(c67,4,6) & ilo_lfs==3            // Ohter labour market reasons
			replace ilo_olf_reason=3 if	inlist(c67,8,9) & ilo_lfs==3	        // Personal/Family-related
			replace ilo_olf_reason=4 if c67==1 & ilo_lfs==3						// Does not need/want to work
			replace ilo_olf_reason=5 if ilo_olf_reason==. & ilo_lfs==3	        // Not elsewhere classified
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
		
	gen ilo_dis=1 if ilo_lfs==3 & c68==1 & ilo_olf_reason==1
			lab def dis_lab 1 "Discouraged job-seekers"
			lab val ilo_dis dis_lab
			lab var ilo_dis "Discouraged job-seekers"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training ('ilo_neet') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment:

	gen ilo_neet=1 if ilo_age_aggregate==2 & ilo_lfs!=1 & ilo_edu_attendance==2
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
		
		/*Only age bands used*/
		drop ilo_age 
		
		/*Variables computed in-between*/
		drop to_drop to_drop_1 to_drop_2 quarter
		drop isic2dig isic2dig_job2 occup_1dig occup_1dig_job2 social_security registration wage other_payments wage2 other_payments2 indu_code_une_2dig prev_occup
		
		compress 
		
	   /*Save dataset including original and ilo variables*/
		save ${country}_${source}_${time}_FULL,  replace		
	
	   /* Save file only containing ilo_* variables*/
	    keep ilo*
		save ${country}_${source}_${time}_ILO, replace	
	
