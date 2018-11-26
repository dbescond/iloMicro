* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Ghana LFS
* DATASET USED: merged lfssec
* NOTES: 
* Files created: Standard variables on LFS Ghana
* Authors: ILO / Department of Statistics / DPAU

* Starting Date: 24 January 2018
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
global country "GHA"
global source "LFS"
global time "2015"
global inputFile "GHA_LFS_2015_merged_1_14"
global inpath "${path}\\${country}\\${source}\\${time}\ORI"
global temppath "${path}\_Admin"
global outpath "${path}\\${country}\\${source}\\${time}"

			
*********************************************************************************************
*********************************************************************************************

* Load original dataset

*********************************************************************************************
*********************************************************************************************
* Comment: - The original datasets are divided by sections of the questionnaire and therefore a 
*            merging process of the sections used here is previously made. Note that the final
*            dataset's number of observations will depend on the number of observations in sections
*            3 to 14 (lfssec3-14f).

/*
*----------
*---- merge 
*----------

cd "$inpath\Data"
   use "lfssec1f.dta", clear                                                    // general characteristics
   merge m:1 memid using "lfssec2f", nogenerate                                 // education
   merge m:1 memid using "lfssec3-14f", generate(merge_)                        // characteristics of the labour force
   keep if merge_==3

*----------
*---- save
*----------
cd "$inpath"
compress
  save ${country}_${source}_${time}_merged_1_14, replace      
*/
   
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
	
	gen ilo_time=1
		lab def lab_time 1 "$time"
		lab val ilo_time lab_time
		lab var ilo_time "Time (Gregorian Calendar)"		

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sample Weight ('ilo_wgt') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_wgt = weight
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
		replace ilo_geo=1 if loc2==1
		replace ilo_geo=2 if loc2==2
		        lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural"
		        lab val ilo_geo ilo_geo_lab
		        lab var ilo_geo "Geographical coverage"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_sex=.
	    replace ilo_sex=1 if s1q3==1
		replace ilo_sex=2 if s1q3==2
		        lab def ilo_sex_lab 1 "1 - Male" 2 "2 - Female"
		        lab val ilo_sex ilo_sex_lab
			    lab var ilo_sex "Sex"
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_age=.
	    replace ilo_age=s1q6
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
*			Level of education ('ilo_edu') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Highest educational level attained.
*          - Early childhood education includes Primary education [C3:990]
*          - ISCED mapping follows unesco mapping:
*                  http://uis.unesco.org/en/isced-mappings

    * Detailed
    gen ilo_edu_isced11=.
		replace ilo_edu_isced11=1 if (s2aq1==2)                                 // No schooling
		replace ilo_edu_isced11=2 if (s2aq6==0)                                 // Early childhood education (including primary education)
		*replace ilo_edu_isced11=3 if                                           // Primary education
		replace ilo_edu_isced11=4 if (inlist(s2aq6,1,2))                        // Lower secondary education
		replace ilo_edu_isced11=5 if (inlist(s2aq6,3,4,5))                      // Upper secondary education
		replace ilo_edu_isced11=6 if (s2aq6==6)                                 // Post-secondary non-tertiary education
		replace ilo_edu_isced11=7 if (s2aq6==7)                                 // Short-cycle tertiary education
		replace ilo_edu_isced11=8 if (s2aq6==8)                                 // Bachelor's or equivalent level
		replace ilo_edu_isced11=9 if (s2aq6==9)                                 // Master's or equivalent level
		*replace ilo_edu_isced11=10 if                                          // Doctoral or equivalent level
		replace ilo_edu_isced11=11 if ilo_edu_isced11==.                        // Not elsewhere classified
			    label def isced_11_lab 1 "X - No schooling" 2 "0 - Early childhood education" 3 "1 - Primary education" 4 "2 - Lower secondary education" ///
				                       5 "3 - Upper secondary education" 6 "4 - Post-secondary non-tertiary education" 7 "5 - Short-cycle tertiary education" ///
									   8 "6 - Bachelor's or equivalent level" 9 "7 - Master's or equivalent level" 10 "8 - Doctoral or equivalent level" ///
									   11 "9 - Not elsewhere classified"
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
*			Educational attendance ('ilo_edu_attendance')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

		gen ilo_edu_attendance=.
			replace ilo_edu_attendance=2 if s2aq1==2                            // Never attended school -> Not currently attending
			replace ilo_edu_attendance=2 if s2aq8==2                            // Not attending
			replace ilo_edu_attendance=1 if s2aq8==1                            // Not elsewhere classified
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
	    replace ilo_mrts_details=1 if s1q7==6                                   // Single
		replace ilo_mrts_details=2 if s1q7==1                                   // Married
		replace ilo_mrts_details=3 if s1q7==2                                   // Union / cohabiting
		replace ilo_mrts_details=4 if s1q7==5                                   // Widowed
		replace ilo_mrts_details=5 if inlist(s1q7,3,4)                          // Divorced / separated
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
				
				
*--------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Disability status ('ilo_dsb') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment: 

        gen ilo_dsb_aggregate=.
		    replace ilo_dsb_aggregate=1 if s1q21==2                             // Without disability
			replace ilo_dsb_aggregate=2 if ilo_dsb_aggregate==.                 // With disability
			        lab def dsd_aggregate_lab 1 "1 - Persons without disability" 2 "2 - Persons with disability"
					lab val ilo_dsb_aggregate dsd_aggregate_lab
					lab var ilo_dsb_aggregate "Disability status (Aggregate)"

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
* Comment: - Employment comprises people working for at least one hour over the last 7 days,
*            people temporary absent from their jobs still receiving any pay (in cash or in 
*            kind) and those temporary absent from their jobs not receiving any pay but going
*            back to work in less than 2 months.
*          - Unemployment definition follows the ILO three criteria: not in employement, 
*            available for work during the past 7 days or within the next 4 weeks, and seeking
*            for a job during the past 7 days or 4 weeks. 
 
	gen ilo_lfs=.
	    replace ilo_lfs=1 if (s3aq3a==1 | s3aq3b==1 | s3aq3c==1 | s3aq3d==1) & ilo_wap==1       // Employed: Worked for at least one hour.
		replace ilo_lfs=1 if (s3aq3e==1 | s3aq3f==1 |s3aq3g==1) & ilo_wap==1                    // Employed: Worked mainly or only for sale or barter
		replace ilo_lfs=1 if (s3aq4==1 & s3aq6==1 & s3aq8==1) & ilo_wap==1                      // Employed: temporary absent receiving pay	    
		replace ilo_lfs=1 if (s3aq4==1 & s3aq6==2 & s3aq8==1) & ilo_wap==1                      // Employed: temporary absent going back to work in less than 2 months.
		replace ilo_lfs=2 if ilo_lfs!=1 & (inlist(s6q1,1,2) & inlist(s6q2,1,2)) & ilo_wap==1    // Unemployed: not in employment, available and seeking
     	replace ilo_lfs=3 if !inlist(ilo_lfs,1,2) & ilo_wap==1                                                                                                                                                  // Outside the labour force
				label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status" 
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: 

	gen ilo_mjh=.
		replace ilo_mjh=2 if s3bq1==2 & ilo_lfs==1
		replace ilo_mjh=1 if s3bq1==1 & ilo_lfs==1
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
* Comment: - Domestic workers and apprentices are classified as employees; casual workers as
*            not classifiable by status.

	* MAIN JOB	
	* Detailed categories
	  gen ilo_job1_ste_icse93=.
		  replace ilo_job1_ste_icse93=1 if inlist(s3bq8,1,8,10) & ilo_lfs==1    // Employees
		  replace ilo_job1_ste_icse93=2 if inlist(s3bq8,2,5) & ilo_lfs==1       // Employers
		  replace ilo_job1_ste_icse93=3 if inlist(s3bq8,3,6) & ilo_lfs==1       // Own-account workers
		  *replace ilo_job1_ste_icse93=4 if                                     // Members of producers' cooperatives
		  replace ilo_job1_ste_icse93=5 if inlist(s3bq8,4,7) & ilo_lfs==1       // Contributing family workers
		  replace ilo_job1_ste_icse93=6 if ilo_job1_ste_icse93==. & ilo_lfs==1  // Not classifiable by status
				  label define label_ilo_ste_icse93 1 "1 - Employees" 2 "2 - Employers" 3 "3 - Own-account workers" 4 "4 - Members of producers' cooperatives" ///
			                                        5 "5 - Contributing family workers" 6 "6 - Workers not classifiable by status"
			      label val ilo_job1_ste_icse93 label_ilo_ste_icse93
			      label var ilo_job1_ste_icse93 "Status in employment (ICSE 93) - main job"

	* Aggregate categories
	gen ilo_job1_ste_aggregate=.
		replace ilo_job1_ste_aggregate=1 if ilo_job1_ste_icse93==1
		replace ilo_job1_ste_aggregate=2 if inlist(ilo_job1_ste_icse93,2,3,4,5)
		replace ilo_job1_ste_aggregate=3 if ilo_job1_ste_icse93==6
				lab def ste_aggr_lab 1 "1 - Employees" 2 "2 - Self-employed" 3 "3 - Not elsewhere classified"
				lab val ilo_job1_ste_aggregate ste_aggr_lab
			    label var ilo_job1_ste_aggregate "Status in employment (Aggregate) - main job"

	* SECOND JOB
	* Detailed categories
	gen ilo_job2_ste_icse93=.
	    replace ilo_job2_ste_icse93=1 if inlist(s4aq7,1,8,10) & ilo_mjh==2      // Employees
		replace ilo_job2_ste_icse93=2 if inlist(s4aq7,2,5) & ilo_mjh==2         // Employers
		replace ilo_job2_ste_icse93=3 if inlist(s4aq7,3,6) & ilo_mjh==2         // Own-account workers
		*replace ilo_job2_ste_icse93=4 if                                       // Members of producers' cooperatives
		replace ilo_job2_ste_icse93=5 if inlist(s4aq7,4,7) & ilo_mjh==2         // Contributing family workers
		replace ilo_job2_ste_icse93=6 if ilo_job2_ste_icse93==. & ilo_mjh==2    // Not classifiable by status
		        label val ilo_job2_ste_icse93 label_ilo_ste_icse93
			    label var ilo_job2_ste_icse93 "Status in employment (ICSE 93) - second job"

	* Aggregate categories
	gen ilo_job2_ste_aggregate=.
		replace ilo_job2_ste_aggregate=1 if ilo_job2_ste_icse93==1
		replace ilo_job2_ste_aggregate=2 if inlist(ilo_job2_ste_icse93,2,3,4,5)
		replace ilo_job2_ste_aggregate=3 if ilo_job2_ste_icse93==6
				lab val ilo_job2_ste_aggregate ste_aggr_lab
			    label var ilo_job2_ste_aggregate "Status in employment (Aggregate) - second job"	  
	  
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Original classification follows ISIC Rev. 4.
	
	* MAIN JOB:
	gen indu_code_prim=.
   	    replace indu_code_prim=int(s3bq3c/100) 
		
	gen ilo_job1_eco_isic4_2digits = indu_code_prim if ilo_lfs==1
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
        lab val ilo_job1_eco_isic4_2digits eco_isic4_2digits								 
        lab var ilo_job1_eco_isic4_2digits "Economic activity (ISIC Rev. 4), 2 digits levels - main job"

	* 1 digit-level
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
				lab var ilo_job1_eco_aggregate "Economic activity (Aggregate) - main job"
			
	* SECOND JOB
	gen indu_code_sec=.
   	    replace indu_code_sec=int(s4aq2c/100) 
		
	gen ilo_job2_eco_isic4_2digits = indu_code_sec if ilo_mjh==2
        lab val ilo_job2_eco_isic4_2digits eco_isic4_2digits								 
        lab var ilo_job2_eco_isic4_2digits "Economic activity (ISIC Rev. 4), 2 digits levels - second job"

	* 1 digit-level
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
				lab val ilo_job2_eco_aggregate eco_aggr_lab
				lab var ilo_job2_eco_aggregate "Economic activity (Aggregate) - second job"	
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_ocu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Original classification follows ISCO-08.
	
	* MAIN JOB		
	gen occ_code_prim=.
	    replace occ_code_prim = int(s3bq2c/100)
	
	gen ilo_job1_ocu_isco08_2digits = occ_code_prim if ilo_lfs==1
	    lab def ocu08_2digits 1 "01 - Commissioned armed forces officers"	2 "02 - Non-commissioned armed forces officers"	3 "03 - Armed forces occupations, other ranks"	11 "11 - Chief executives, senior officials and legislators"	///
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
		lab values ilo_job1_ocu_isco08_2digits ocu08_2digits
		lab var ilo_job1_ocu_isco08_2digits "Occupation (ISCO-08), 2 digit level - main job"

    * One digit-level
	gen ilo_job1_ocu_isco08=.
	    replace ilo_job1_ocu_isco08 = 11 if (ilo_job1_ocu_isco08_2digits==. & ilo_lfs==1)                           //Not elsewhere classified
		replace ilo_job1_ocu_isco08 = int(ilo_job1_ocu_isco08_2digits/10) if (ilo_job1_ocu_isco08==. & ilo_lfs==1)  //The rest of the occupations
		replace ilo_job1_ocu_isco08 = 10 if (ilo_job1_ocu_isco08==0 & ilo_lfs==1)                                   //Armed forces
	            lab def ocu_isco08 1 "1 - Managers"	2 "2 - Professionals"	3 "3 - Technicians and associate professionals"	4 "4 - Clerical support workers"	///
                                   5 "5 - Service and sales workers"	6 "6 - Skilled agricultural, forestry and fishery workers"	7 "7 - Craft and related trades workers"	8 "8 - Plant and machine operators, and assemblers"	///
                                   9 "9 - Elementary occupations"	10 "0 - Armed forces occupations"	11 "X - Not elsewhere classified"		
				lab val ilo_job1_ocu_isco08 ocu_isco08
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
				lab var ilo_job1_ocu_aggregate "Occupation (Aggregate)- main job"	
		
	 * Skill level
	 gen ilo_job1_ocu_skill=.
		 replace ilo_job1_ocu_skill=1 if ilo_job1_ocu_isco08==9                   // Low
		 replace ilo_job1_ocu_skill=2 if inlist(ilo_job1_ocu_isco08,4,5,6,7,8)    // Medium
		 replace ilo_job1_ocu_skill=3 if inlist(ilo_job1_ocu_isco08,1,2,3)        // High
		 replace ilo_job1_ocu_skill=4 if inlist(ilo_job1_ocu_isco08,10,11)        // Not elsewhere classified
			   	 lab def ocu_skill_lab 1 "1 - Skill level 1 (low)" 2 "2 - Skill level 2 (medium)" 3 "3 - Skill levels 3 and 4 (high)" 4 "4 - Not elsewhere classified"
				 lab val ilo_job1_ocu_skill ocu_skill_lab
				 lab var ilo_job1_ocu_skill "Occupation (Skill level)- main job"

	* SECOND JOB
	gen occ_code_sec=.
	    replace occ_code_sec = int(s4aq1/100)
	
	gen ilo_job2_ocu_isco08_2digits = occ_code_sec if ilo_mjh==2
		lab values ilo_job2_ocu_isco08_2digits ocu08_2digits
		lab var ilo_job2_ocu_isco08_2digits "Occupation (ISCO-08), 2 digit level - second job"

    * One digit-level
	gen ilo_job2_ocu_isco08=.
	    replace ilo_job2_ocu_isco08 = 11 if (ilo_job2_ocu_isco08_2digits==. & ilo_mjh==2)                           //Not elsewhere classified
		replace ilo_job2_ocu_isco08 = int(ilo_job2_ocu_isco08_2digits/10) if (ilo_job2_ocu_isco08==. & ilo_mjh==2)  //The rest of the occupations
		replace ilo_job2_ocu_isco08 = 10 if (ilo_job2_ocu_isco08==0 & ilo_mjh==2)                                   //Armed forces
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
				lab var ilo_job2_ocu_aggregate "Occupation (Aggregate)- second job"	
		
	 * Skill level
	 gen ilo_job2_ocu_skill=.
		 replace ilo_job2_ocu_skill=1 if ilo_job2_ocu_isco08==9                   // Low
		 replace ilo_job2_ocu_skill=2 if inlist(ilo_job2_ocu_isco08,4,5,6,7,8)    // Medium
		 replace ilo_job2_ocu_skill=3 if inlist(ilo_job2_ocu_isco08,1,2,3)        // High
		 replace ilo_job2_ocu_skill=4 if inlist(ilo_job2_ocu_isco08,10,11)        // Not elsewhere classified
				 lab val ilo_job2_ocu_skill ocu_skill_lab
				 lab var ilo_job2_ocu_skill "Occupation (Skill level)- second job"	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_ins_sector') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Public: Government sector (civil service, other public service) and parastatals.
	
    * MAIN JOB	
	gen ilo_job1_ins_sector=.
		replace ilo_job1_ins_sector=1 if inlist(s3bq9,1,2,3) & ilo_lfs==1
		replace ilo_job1_ins_sector=2 if ilo_job1_ins_sector==. & ilo_lfs==1
                lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
			    lab values ilo_job1_ins_sector ins_sector_lab
			    lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities - main job"

    * SECOND JOB	
	gen ilo_job2_ins_sector=.
		replace ilo_job2_ins_sector=1 if inlist(s4aq8,1,2,3) & ilo_mjh==2
		replace ilo_job2_ins_sector=2 if ilo_job2_ins_sector==. & ilo_mjh==2
			    lab values ilo_job2_ins_sector ins_sector_lab
			    lab var ilo_job2_ins_sector "Institutional sector (private/public) of economic activities - second job"				
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*	      Informal/Formal economy: ('ilo_job1_ife_prod' and 'ilo_job1_ife_nature') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: 
/* Useful questions:
		  * Institutional sector: s3bq9
		  * Destination of production: not asked.
		  * Bookkeeping: not asked. 
		  * Registration: not asked.
		  * Status in employment: ilo_job1_ste_icse93==1 (employees)
		  * Social security: s3bq25 (retirement benefit/pension, only asked to paid employees)
		  * Place of work: s3bq31
		  * Size: s3bq29
		  * Private HH:  ilo_job1_eco_isic4_2digits==97 / ilo_job1_ocu_isco08_2digits==63 (0.30%/0.55%)
		  * Paid annual leave: s3bq23 (only asked to paid employees)
		  * Paid sick leave: s3bq24 (asked together with maternity leave, only asked to paid employees)
*/
		
    * Social security (to be dropped afterwards)
	gen social_security=.
	    replace social_security=1 if (s3bq25==1 & ilo_lfs==1)                   // Pension
		replace social_security=2 if (s3bq25==2 & ilo_lfs==1)                   // No pension
	
    * 1) UNIT OF PRODUCTION: FORMAL/INFORMAL SECTOR		
    gen ilo_job1_ife_prod=.
		replace ilo_job1_ife_prod=2 if ilo_lfs==1 & ///
		                               ((inlist(s3bq9,1,2,3,4,6)) | ///
									   (inlist(s3bq9,5,7,8,.) & ilo_job1_ste_icse93==1 & social_security==1) | ///
									   (inlist(s3bq9,5,7,8,.) & ilo_job1_ste_icse93==1 & inlist(social_security,2,.) & inlist(s3bq31,1,3,4,8,9,14,15) & inlist(s3bq29,3,4,5,6)) | ///
									   (inlist(s3bq9,5,7,8,.) & ilo_job1_ste_icse93!=1 & inlist(s3bq31,1,3,4,8,9,14,15) & inlist(s3bq29,3,4,5,6))) 
		replace ilo_job1_ife_prod=3 if ilo_lfs==1 & ilo_job1_ife_prod!=2 & ///
				                       ((ilo_job1_eco_isic4_2digits==97 | ilo_job1_ocu_isco08_2digits==63)) 
		replace ilo_job1_ife_prod=1 if ilo_lfs==1 & !inlist(ilo_job1_ife_prod,2,3)
				lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 
				lab val ilo_job1_ife_prod ilo_ife_prod_lab
				lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"		
						
    * 2) NATURE OF JOB: FORMAL/INFORMAL EMPLOYMENT
	gen ilo_job1_ife_nature=.
	    replace ilo_job1_ife_nature=1 if ilo_lfs==1 & ///
	                                     ((inlist(ilo_job1_ste_icse93,1,6) & social_security==2) | ///
										 (inlist(ilo_job1_ste_icse93,1,6) & social_security==. & inlist(s3bq23,2,.)) | ///
										 (inlist(ilo_job1_ste_icse93,1,6) & social_security==. & s3bq23==1 & inlist(s3bq24,2,4,.) ) | ///
										 (inlist(ilo_job1_ste_icse93,2,4) & inlist(ilo_job1_ife_prod,1,3)) | ///
										 (ilo_job1_ste_icse93==3 & inlist(ilo_job1_ife_prod,1,3)) | ///
										 (ilo_job1_ste_icse93==5))
	    replace ilo_job1_ife_nature=2 if ilo_lfs==1 & ///
			                             ((inlist(ilo_job1_ste_icse93,1,6) & social_security==1) | ///
										 (inlist(ilo_job1_ste_icse93,1,6) & social_security==. & s3bq23==1 & s3bq24==1) | ///
										 (inlist(ilo_job1_ste_icse93,2,4) & ilo_job1_ife_prod==2) | ///
										 (ilo_job1_ste_icse93==3 & ilo_job1_ife_prod==2))
	    replace ilo_job1_ife_nature=. if (ilo_job1_ife_nature==. & ilo_lfs!=1)
                lab def ife_nature_lab 1 "1 - Persons with informal main job" 2 "2 - Persons with formal main job"
		        lab val ilo_job1_ife_nature ife_nature_lab
		        lab var ilo_job1_ife_nature "Informal / Formal Economy (Nature of job)"	
				
***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		
				
* --------------------------------------------------------------------------------------------------
* --------------------------------------------------------------------------------------------------
*		                 Hours of work ('ilo_how') [done]
* --------------------------------------------------------------------------------------------------
* --------------------------------------------------------------------------------------------------
* Comment:

	* MAIN JOB
    * 1) Weekly hours USUALLY worked:	
	gen ilo_job1_how_usual=.
	    replace ilo_job1_how_usual = s3bq5 if ilo_lfs==1
		replace ilo_job1_how_usual = . if ilo_job1_how_usual>168
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
		    	lab def how_bands_lab 1 "No hours usually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"
				lab val ilo_job1_how_usual_bands how_bands_lab
				lab var ilo_job1_how_usual_bands "Weekly hours usually worked bands - main job"
				
	* 2) Weekly hours ACTUALLY worked:
	gen ilo_job1_how_actual=.
	    replace ilo_job1_how_actual = s3bq4h if ilo_lfs==1
		replace ilo_job1_how_actual = . if ilo_job1_how_actual>168
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
			    lab val ilo_job1_how_actual_bands how_bands_lab
			    lab var ilo_job1_how_actual_bands "Weekly hours actually worked bands - main job"
										
	* SECOND JOB
	* 1) Weekly hours USUALLY worked:
	gen ilo_job2_how_usual=.
	    replace ilo_job2_how_usual = s4aq4 if ilo_mjh==2
		replace ilo_job2_how_usual = . if ilo_job2_how_usual>168
			    lab var ilo_job2_how_usual "Weekly hours usually worked - second job"
				
    gen ilo_job2_how_usual_bands=.
	 	replace ilo_job2_how_usual_bands=1 if ilo_job2_how_usual==0
		replace ilo_job2_how_usual_bands=2 if ilo_job2_how_usual>=1 & ilo_job2_how_usual<=14
		replace ilo_job2_how_usual_bands=3 if ilo_job2_how_usual>14 & ilo_job2_how_usual<=29
		replace ilo_job2_how_usual_bands=4 if ilo_job2_how_usual>29 & ilo_job2_how_usual<=34
		replace ilo_job2_how_usual_bands=5 if ilo_job2_how_usual>34 & ilo_job2_how_usual<=39
		replace ilo_job2_how_usual_bands=6 if ilo_job2_how_usual>39 & ilo_job2_how_usual<=48
		replace ilo_job2_how_usual_bands=7 if ilo_job2_how_usual>48 & ilo_job2_how_usual!=.
		replace ilo_job2_how_usual_bands=8 if ilo_job2_how_usual==. & ilo_mjh==2
		replace ilo_job2_how_usual_bands=. if ilo_mjh!=2
				lab val ilo_job2_how_usual_bands how_bands_lab
				lab var ilo_job2_how_usual_bands "Weekly hours usually worked bands - second job"
				
	* 2) Weekly hours ACTUALLY worked:
   gen ilo_job2_how_actual=.
	   replace ilo_job2_how_actual = s4aq3h if ilo_mjh==2
	   replace ilo_job2_how_actual = . if ilo_job2_how_actual>168
	           lab var ilo_job2_how_actual "Weekly hours actually worked - second job"
					
   gen ilo_job2_how_actual_bands=.
	   replace ilo_job2_how_actual_bands=1 if ilo_job2_how_actual==0
	   replace ilo_job2_how_actual_bands=2 if ilo_job2_how_actual>=1 & ilo_job2_how_actual<=14
	   replace ilo_job2_how_actual_bands=3 if ilo_job2_how_actual>14 & ilo_job2_how_actual<=29
	   replace ilo_job2_how_actual_bands=4 if ilo_job2_how_actual>29 & ilo_job2_how_actual<=34
	   replace ilo_job2_how_actual_bands=5 if ilo_job2_how_actual>34 & ilo_job2_how_actual<=39
	   replace ilo_job2_how_actual_bands=6 if ilo_job2_how_actual>39 & ilo_job2_how_actual<=48
	   replace ilo_job2_how_actual_bands=7 if ilo_job2_how_actual>48 & ilo_job2_how_actual!=.
	   replace ilo_job2_how_actual_bands=8 if ilo_job2_how_actual==. & ilo_mjh==2
	   replace ilo_job2_how_actual_bands=. if ilo_mjh!=2
			   lab val ilo_job2_how_actual_bands how_bands_lab
			   lab var ilo_job2_how_actual_bands "Weekly hours actually worked bands - second job"
	
	* ALL JOBS
	* 1) Weekly hours USUALLY worked:
	egen ilo_joball_how_usual = rowtotal(ilo_job1_how_usual ilo_job2_how_usual), m
		 replace ilo_joball_how_usual=. if ilo_lfs!=1
			    lab var ilo_joball_how_usual "Weekly hours usually worked - all jobs"
				
    gen ilo_joball_how_usual_bands=.
	 	replace ilo_joball_how_usual_bands=1 if ilo_joball_how_usual==0
		replace ilo_joball_how_usual_bands=2 if ilo_joball_how_usual>=1 & ilo_joball_how_usual<=14
		replace ilo_joball_how_usual_bands=3 if ilo_joball_how_usual>14 & ilo_joball_how_usual<=29
		replace ilo_joball_how_usual_bands=4 if ilo_joball_how_usual>29 & ilo_joball_how_usual<=34
		replace ilo_joball_how_usual_bands=5 if ilo_joball_how_usual>34 & ilo_joball_how_usual<=39
		replace ilo_joball_how_usual_bands=6 if ilo_joball_how_usual>39 & ilo_joball_how_usual<=48
		replace ilo_joball_how_usual_bands=7 if ilo_joball_how_usual>48 & ilo_joball_how_usual!=.
		replace ilo_joball_how_usual_bands=8 if ilo_joball_how_usual==. & ilo_lfs==1
		replace ilo_joball_how_usual_bands=. if ilo_lfs!=1
		    	lab val ilo_joball_how_usual_bands how_bands_lab
				lab var ilo_joball_how_usual_bands "Weekly hours usually worked bands - all job"
	
	* 2) Weekly hours ACTUALLY worked:
	egen ilo_joball_how_actual=rowtotal(ilo_job1_how_actual ilo_job2_how_actual), m
		 replace ilo_joball_how_actual=. if ilo_lfs!=1
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
				lab var ilo_joball_how_actual_bands "Weekly hours actually worked bands - all job"
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
* Comment: - The threshold is set at 32 hours usually worked (based on the median of usual 
*            hours of work for all jobs).
	
	gen ilo_job1_job_time=.
		replace ilo_job1_job_time=2 if (ilo_joball_how_usual>=32) & ilo_lfs==1
		replace ilo_job1_job_time=1 if (ilo_joball_how_usual<32) & ilo_lfs==1
		replace ilo_job1_job_time=3 if ilo_job1_job_time==. & ilo_lfs==1
			    lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
			    lab val ilo_job1_job_time job_time_lab
			    lab var ilo_job1_job_time "Job (Working time arrangement)"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job_contract') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
* Comment: 
	
	* MAIN JOB:
	gen ilo_job1_job_contract=.
		replace ilo_job1_job_contract=1 if s3bq39==1 & ilo_job1_ste_aggregate==1
		replace ilo_job1_job_contract=2 if s3bq39==2 & ilo_job1_ste_aggregate==1
		replace ilo_job1_job_contract=3 if ilo_job1_job_contract==. & ilo_job1_ste_aggregate==1
				lab def job_contract_lab 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"
			    lab val ilo_job1_job_contract job_contract_lab
			    lab var ilo_job1_job_contract "Job (Type of contract) - main job"
				
	* SECOND JOB:
	gen ilo_job2_job_contract=.
		replace ilo_job2_job_contract=1 if s4bq38==1 & ilo_job2_ste_aggregate==1
		replace ilo_job2_job_contract=2 if s4bq38==2 & ilo_job2_ste_aggregate==1
		replace ilo_job2_job_contract=3 if ilo_job2_job_contract==. & ilo_job2_ste_aggregate==1
			    lab val ilo_job2_job_contract job_contract_lab
			    lab var ilo_job2_job_contract "Job (Type of contract) - second job"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Earnings ('ilo_ear_ees' and 'ilo_ear_slf')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - No information available for self-employed.

	* MAIN JOB
	* Employees
	gen monthly_earnings1=.
	    replace monthly_earnings1 = s3bq17a if s3bq17b==4 & ilo_lfs==1                   // Monthly
	    replace monthly_earnings1 = s3bq17a*(365/12) if s3bq17b==1 & ilo_lfs==1          // Daily
		replace monthly_earnings1 = s3bq17a*((365/12)/7) if s3bq17b==2 & ilo_lfs==1      // Weekly
		replace monthly_earnings1 = s3bq17a*((365/12)/14) if s3bq17b==3 & ilo_lfs==1     // Fortnightly
		replace monthly_earnings1 = s3bq17a/(3) if s3bq17b==5 & ilo_lfs==1               // Quarterly
		replace monthly_earnings1 = s3bq17a/(12) if s3bq17b==6 & ilo_lfs==1              // Yearly

	*  total labour related income of employees
	   gen ilo_job1_lri_ees = monthly_earnings1 if ilo_job1_ste_aggregate==1
           lab var ilo_job1_lri_ees "Monthly earnings of employees - main job"

			  
	* SECOND JOB
	* Employees
	gen monthly_earnings2=.
	    replace monthly_earnings2 = s4bq16a if s4bq16b==4 & ilo_lfs==1                   // Monthly
	    replace monthly_earnings2 = s4bq16a*(365/12) if s4bq16b==1 & ilo_lfs==1          // Daily
		replace monthly_earnings2 = s4bq16a*((365/12)/7) if s4bq16b==2 & ilo_lfs==1      // Weekly
		replace monthly_earnings2 = s4bq16a*((365/12)/14) if s4bq16b==3 & ilo_lfs==1     // Fortnightly
		replace monthly_earnings2 = s4bq16a/(3) if s4bq16b==5 & ilo_lfs==1               // Quarterly
		replace monthly_earnings2 = s4bq16a/(12) if s4bq16b==6 & ilo_lfs==1              // Yearly

	*  total labour related income of employees
	   gen ilo_job2_lri_ees = monthly_earnings2 if ilo_job2_ste_aggregate==1
           lab var ilo_job2_lri_ees "Monthly earnings of employees - second job"
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_tru') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - No information available about the availability to work additional hours and thus
*            it refers to time-related underemployment two criteria (want to work more hours
*            and worked less than a threshold. [T35:2416]
*          - The threshold is set at 40 hours usually worked in all jobs following the 
*            questionnaire.
			
	gen ilo_joball_tru=.
	    replace ilo_joball_tru=1 if (s5q2==1 & ilo_joball_how_usual<40) & ilo_lfs==1	
		replace ilo_joball_tru=. if ilo_lfs!=1
		        lab def tru_lab 1 "Time-related underemployment"
		        lab val ilo_joball_tru tru_lab
		        lab var ilo_joball_tru "Time-related underemployment"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupational injury ('ilo_joball_oi_case') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
* Comment:  - Cases of non-fatal occupational injuries/diseases during the past 12 months.

	gen ilo_joball_oi_case=.
	    replace ilo_joball_oi_case=1 if (inlist(s10q2,1,2,3) & s10q3==1) & ilo_lfs==1
		        lab var ilo_joball_oi_case "Cases of non-fatal occupational injury"

*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Days lost due to cases of occupational injury ('ilo_joball_oi_day') [done]
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
* Comment: 

    gen ilo_joball_oi_day=.
	    replace ilo_joball_oi_day=s10q6 if (s10q5==1) & ilo_lfs==1	
				lab var ilo_joball_oi_day "Days lost due to cases of occupational injury"

***********************************************************************************************
*			PART 3.3. UNEMPLOYMENT: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Category of unemployment ('ilo_cat_une') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - No information available.

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur') [done]
* -------------------------------------------------------------------------------------------
* Comment: 

	* Detailed categories		
    gen ilo_dur_details=.
	    replace ilo_dur_details=1 if (s6q7==1 & ilo_lfs==2)                     // Less than 1 month
		replace ilo_dur_details=2 if (s6q7==2 & ilo_lfs==2)                     // 1 to 3 months
		replace ilo_dur_details=3 if (s6q7==3 & ilo_lfs==2)                     // 3 to 6 months
		replace ilo_dur_details=4 if (s6q7==4 & ilo_lfs==2)                     // 6 to 12 months
		replace ilo_dur_details=5 if (s6q7==5 & ilo_lfs==2)                     // 12 to 24 months
		replace ilo_dur_details=6 if (inlist(s6q7,6,7) & ilo_lfs==2)            // 24 months or more
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
*			Previous economic activity ('ilo_preveco_isic4') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - No information available.
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu_isco88') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Given that the information concerning the category of unemployment is not 
*            available, this variable is not computed.

***********************************************************************************************
*			PART 3.3. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - No information available concerning willingness, therefore, categories 3 and 4
*            are not possible to be produced.

	gen ilo_olf_dlma=.
		replace ilo_olf_dlma = 1 if (inlist(s6q2,1,2) & s6q1==3 & ilo_lfs==3)	// Seeking, not available
		replace ilo_olf_dlma = 2 if (s6q2==3 & inlist(s6q1,1,2) & ilo_lfs==3)	// Not seeking, available
		*replace ilo_olf_dlma = 3 if 		                                    // Not seeking, not available, willing
		*replace ilo_olf_dlma = 4 if  	                                        // Not seeking, not available, not willing
		replace ilo_olf_dlma = 5 if	(ilo_olf_dlma==. & ilo_lfs==3)				// Not classified 
	 		lab def dlma_lab 1 "1 - Seeking, not available (Unavailable jobseekers)" 2 "2 - Not seeking, available (Available potential jobseekers)" ///
							 3 "3 - Not seeking, not available, willing (Willing non-jobseekers)" 4 "4 - Not seeking, not available, not willing" 5 "X - Not elsewhere classified"
			lab val ilo_olf_dlma dlma_lab 
			lab var ilo_olf_dlma "Labour market attachment (Degree of)"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reasons for not seeking a job ('ilo_olf_reason') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: 
	
	gen ilo_olf_reason=.
		replace ilo_olf_reason=1 if inlist(s6q4,1,2,3,4,5,17) & ilo_lfs==3          // Labour market
		replace ilo_olf_reason=2 if inlist(s6q4,6,7,19) & ilo_lfs==3                // Other labour market reasons
		replace ilo_olf_reason=3 if inlist(s6q4,8,9,10,11,12,13,14) & ilo_lfs==3    // Personal/Family-related
		replace ilo_olf_reason=4 if inlist(s6q4,16,20) & ilo_lfs==3                 // Does not need/want to work
		replace ilo_olf_reason=5 if ilo_olf_reason==. & ilo_lfs==3                  // Not elsewhere classified
 			    lab def lab_olf_reason 1 "1 - Labour market" 2 "Other labour market reasons" 3 "2 - Personal/Family-related"  ///
				                       4 "3 - Does not need/want to work" 5 "4 - Not elsewhere classified"
		        lab val ilo_olf_reason lab_olf_reason
			    lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seekers ('ilo_dis') [done]
* -------------------------------------------------------------------------------------------
* ------------------------------------------------------------------------------------------- 
* Comment:

	gen ilo_dis=.
	    replace ilo_dis=1 if !inlist(ilo_lfs,1,2) & inlist(s6q1,1,2) & ilo_olf_reason==1
			    lab def ilo_dis_lab 1 "Discouraged job-seekers" 
			    lab val ilo_dis ilo_dis_lab
			    lab var ilo_dis "Discouraged job-seekers"			
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training (NEETs) ('ilo_neet') [done]
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
		drop indu_code_sec occ_code_prim occ_code_sec social_security monthly_earnings1 monthly_earnings2
		compress 
		
	   /*Save dataset including original and ilo variables*/
		save ${country}_${source}_${time}_FULL,  replace		
	
	   /* Save file only containing ilo_* variables*/
		keep ilo*
		save ${country}_${source}_${time}_ILO, replace
		



