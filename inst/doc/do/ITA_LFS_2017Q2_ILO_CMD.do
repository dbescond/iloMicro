* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Italy LFS
* DATASET USED: Italy LFS 2017Q2
* NOTES:
* Authors: Estefania Alaminos
* Who last updated the file: Estefania Alaminos 
* Starting Date: 02/11/2017
* Last updated: 02/11/2017
***********************************************************************************************


***********************************************************************************************
***********************************************************************************************

* 			1. SET UP WORK DIRECTORY, FILE NAME, VARIABLES AND FUNCTIONS

***********************************************************************************************
***********************************************************************************************
clear all 

set more off
*set more off, permanently

global path "J:\COMMON\STATISTICS\DPAU\MICRO"
global country "ITA"
global source "LFS"
global time "2017Q2"
global inputFile "RCFL_A2017_INDIVIDUI.dta"
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
      	   replace ilo_wgt = coefmi
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

** Comment: It is not possible to compute this variable. 
**          The geographical information given in the questionnare is region and province, therefore this geographical units are too big how to do the distinction between urban/rural area. 
  
	**gen ilo_geo = .
		 
		
		


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
destring sg11, replace
	

	gen ilo_sex = sg11
		lab def ilo_sex_lab 1 "1 - Male" 2 "2 - Female"
		lab var ilo_sex "Sex"
		lab val ilo_sex ilo_sex_lab

    
	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------


destring etam, replace

	gen ilo_age = etam
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

destring hatlev, replace
destring edulev, replace




gen ilo_edu_isced11=.
		replace ilo_edu_isced11=1 if hatlev == 0                                      // No schooling
		replace ilo_edu_isced11=2 if hatlev == 100                                    // Early childhood education
		replace ilo_edu_isced11=3 if hatlev == 200                             // Primary education 
		replace ilo_edu_isced11=4 if hatlev == 303                             // Lower secondary education
		replace ilo_edu_isced11=5 if hatlev == 304                           // Upper secondary education
		replace ilo_edu_isced11=6 if hatlev == 400                                   // Post-secodary non-tertiary education
		replace ilo_edu_isced11=7 if hatlev == 500                           // Short-cycle tertiary education
		replace ilo_edu_isced11=8 if hatlev == 600                                   // Bachelor's or equivalent level
		replace ilo_edu_isced11=9 if hatlev == 700                                 // Master's or equivalent level
		replace ilo_edu_isced11=10 if hatlev == 800                                // Doctoral or equivalent level
		replace ilo_edu_isced11=11 if hatlev == 999                      // Not elsewhere classified 
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

** Comment: it is taking into account if the individual is enrolled in the reference week/month. 

destring h1, replace
destring h1b, replace
destring h4, replace


	
		gen ilo_edu_attendance = .
		replace ilo_edu_attendance = 1 if h1 == 1 | inlist(h1b,1,2) | (h1b==4 & inlist(h4,1,2))                         // 1 - Attending
		replace ilo_edu_attendance = 2 if h1 == 2 | h1b == 2                                                           //  2 - Not attending
	    replace ilo_edu_attendance = 3 if ilo_edu_attendance == .                                                     // 3 - Not elsewhere classified
		lab def edu_attendance_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
		lab val ilo_edu_attendance edu_attendance_lab
		lab var ilo_edu_attendance "Education (Attendance)"



* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Disability status ('ilo_dsb')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

* Comment: No information



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



	gen ilo_wap =.
		replace ilo_wap = 1 if ilo_age >= 15 &  & ilo_age !=.	// Working age population
			label def ilo_wap_lab 1 "Working age population"
			label val ilo_wap ilo_wap_lab
			label var ilo_wap "Working age population"

			

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Labour Force Status ('ilo_lfs')     
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

destring b1, replace
destring b2, replace
destring b3, replace


 

 
gen ilo_lfs =.

		** EMPLOYED
		
		
		replace ilo_lfs = 1 if b1 == 1 &  ilo_wap == 1  
		replace ilo_lfs = 1 if b2 == 1 & (inrange(b3,4,8) | b3==11)  & ilo_wap == 1  
		replace ilo_lfs = 1 if b2 == 1 & (inrange(b3,4,8) | b3==11)  & ilo_wap == 1  

		
		
		
		replace ilo_lfs = 1 if (c1a==1 | c1b==1 | c1c ==1) &  ilo_wap == 1  // work for pay, run a business or help household
		replace ilo_lfs = 1 if (c2a==1 & inrange(c2c,1,4)) &  ilo_wap == 1 // have paid job or business, expecting to return, and absent due to nature of work, 
																		  //  holidays, sickness, or maternity leave.   
		replace ilo_lfs = 1 if (c2a==1 & !inlist(c2c,1,2,3,4,11) & c2d ==1) &  ilo_wap == 1 // temporary absent for different reasons but s/he will return within 3m or less. 
		replace ilo_lfs = 1 if (c2a==1 & !inlist(c2c,1,2,3,4,11) & c2d ==2 & c2e==1) &  ilo_wap == 1  // temporay absent, not expectaction of reuning in <3m, but receiving an income during the absence. 
	    replace ilo_lfs = 1 if (c2b==1 & inrange(c2c,1,4)) &  ilo_wap == 1  // help in any business run by the household, and temporary absent
		replace ilo_lfs = 1 if (c2b==1 & !inlist(c2c,1,2,3,4,11) & c2d ==1) &  ilo_wap == 1 //help in any household business, temporary absent for different reasons , but returning within <=3m.
		replace ilo_lfs = 1 if (c2b==1 & !inlist(c2c,1,2,3,4,11) & c2d ==2 & c2e==1) &  ilo_wap == 1  //help in any household business, temporary absent for different reasons , not returning within <=3m, but receiving an income during the absence..
		replace ilo_lfs = 1 if (inlist(c3a,1,2) & inlist(c3c,1,2)) &  ilo_wap == 1  //working in farming or fishing, destination of products only/mainly for sale.  
		replace ilo_lfs = 1 if (c3b==1 & inlist(c3c,1,2)) & ilo_wap == 1  //working in farming or fishing in the last 7 days, destination of products only/mainly for sale.
		

			
				
		
		** UNEMPLOYED 
		
		** The definition includes those who are unemployed, available and actively looking for a job. 
		  
	
		replace ilo_lfs = 2 if ilo_lfs !=1 & g1 == 1 & g5 == 1 &  ilo_wap == 1 
		

		
		
		
		** OUTSIDE LABOUR FORCE
		replace ilo_lfs = 3 if ilo_lfs != 1   & ilo_lfs != 2 & ilo_wap == 1 // Not in employment, future job starters

	
		label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside the Labour Force"
		label value ilo_lfs label_ilo_lfs
		label var ilo_lfs "Labour Force Status"




	
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
 
 ** Comment: People with missing is categorised as one job holder. 
 
 
gen  ilo_mjh = .

** - 1. One job only

	replace ilo_mjh = 1 if  inlist(d1a,2,.) & ilo_lfs == 1

** - 2. More than one job

	replace ilo_mjh = 2 if d1a == 1 & ilo_lfs == 1
	

	
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


** Comments: there is no information for members of producers cooperatives. 
 
**** MAIN JOB

* Detailed categories:

		gen ilo_job1_ste_icse93 = .
		
			replace ilo_job1_ste_icse93 = 1 if inrange(d7,1,3)   & ilo_lfs == 1   	// Employees
			
			replace ilo_job1_ste_icse93 = 2 if d7 == 4 & ilo_lfs==1	            // Employers
			
			replace ilo_job1_ste_icse93 = 3 if d7 == 5 & ilo_lfs==1         // Own-account workers
			
			*replace ilo_job1_ste_icse93 = 4 if       			                    // Members of producers cooperatives

			replace ilo_job1_ste_icse93 = 5 if d7 == 6 & ilo_lfs==1	            // Contributing family workers
			
			replace ilo_job1_ste_icse93 = 6 if  d7 == . & ilo_lfs==1                // Workers not classifiable by status
			
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

				

				
				
** YVES: - I am not sure about the use of question d7 to determine the status in employment of people with a second job
**			due to module D refers to characteristics of main job. 			
				
				
**** SECOND JOB

gen ilo_job2_ste_icse93 = .
		
			replace ilo_job2_ste_icse93 = 1 if inrange(d7,1,3) & ilo_mjh == 2   	    // Employees
			
			replace ilo_job2_ste_icse93 = 2 if d7 == 4 & ilo_mjh == 2 	            // Employers
			
			replace ilo_job2_ste_icse93 = 3 if d7 == 5 & ilo_mjh == 2       		// Own-account workers
			
			*replace ilo_job2_ste_icse93 = 4 if         		// Members of producers’ cooperatives

			replace ilo_job2_ste_icse93 = 5 if d7 == 6 & ilo_mjh == 2             // Contributing family workers
			
			replace ilo_job2_ste_icse93 = 6 if d7 == . & ilo_mjh == 2            // Workers not classifiable by status
			
				
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
	replace indu_code_prim = int(d2_isic_code/100)
	
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
	
	* YVES:   Comment: Information only for the main job?? (module D)
	

		
		
					
								
								
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_job1_ocu_isco08')  
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

 

 * MAIN JOB	
	gen occ_code_prim=.
	    replace occ_code_prim=int(d1_code/100)
         
    * 2-digit level
	gen ilo_job1_ocu_isco08_2digits = occ_code_prim if ilo_lfs==1
	replace ilo_job1_ocu_isco08_2digits = 1 if occ_code_prim == 3   & ilo_lfs==1
	
	 

	
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
	    replace ilo_job1_ocu_isco08=11 if ilo_job1_ocu_isco08_2digits==. & ilo_lfs==1     // Not elsewhere classified

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
	
	** no information available
	

	
  
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_job1_ins_sector')  
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		


	
***** MAIN JOB *****
 
** Comment: question d5==8 refers to households. 		 

		gen ilo_job1_ins_sector = .
			replace ilo_job1_ins_sector = 1 if inrange(d5,1,4) & ilo_lfs == 1 	// Public
			replace ilo_job1_ins_sector = 2 if inrange(d5,5,8) & ilo_lfs == 1    // Private
				lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
			    lab values ilo_job1_ins_sector ins_sector_lab
			    lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities"
	 

	 
	 
	 
	 
	 
	 	
***** SECOND JOB *****
 
 
* Comment: No information
		 

	 	
	
		
		
		

		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job1_job_time') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			

 
***** MAIN JOB *****


 
		gen ilo_job1_job_time = .
		replace ilo_job1_job_time = 1 if e2 == 2 & ilo_lfs == 1 				// 1 - Part-time
		replace ilo_job1_job_time = 2 if e2 == 1  & ilo_lfs == 1 				// 2 - Full-time
		replace ilo_job1_job_time = 3 if ilo_job1_job_time == . & ilo_lfs == 1 		// 3 - Unknown
			lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknow"
			    lab values ilo_job1_job_time job_time_lab
			    lab var ilo_job1_job_time "Job (Working time arrangement)"


***** SECOND JOB *****


**


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*		1. 	Hours of work actually worked ('ilo_job1_how_actual')   
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

** MAIN JOB

* ilo_job1_how_actual

 
		egen ilo_job1_how_actual =rowtotal(e1aa e1ac e1ae e1ag e1ai e1ak e1am) if ilo_lfs == 1, m
		
		replace ilo_job1_how_actual = . if ilo_job1_how_actual == 99
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
					 
					
				
*** SECOND JOB
** Comment: the information is on ALL OTHER JOBS

   * ilo_job2_how_actual

 		egen ilo_job2_how_actual =rowtotal(e1ab e1ad e1af e1ah e1aj e1al e1an) if ilo_mjh==2, m

		 
		replace ilo_job2_how_actual = . if ilo_job2_how_actual == 99
				lab var ilo_job2_how_actual "Weekly hours actually worked in main job"	      
		
		gen ilo_job2_how_actual_bands = .
			 replace ilo_job2_how_actual_bands = 1 if ilo_job2_how_actual == 0				// No hours actually worked
			 replace ilo_job2_how_actual_bands = 2 if inrange(ilo_job2_how_actual,1,14)	    // 01-14
			 replace ilo_job2_how_actual_bands = 3 if inrange(ilo_job2_how_actual,15,29)	// 15-29
			 replace ilo_job2_how_actual_bands = 4 if inrange(ilo_job2_how_actual,30,34)	// 30-34
			 replace ilo_job2_how_actual_bands = 5 if inrange(ilo_job2_how_actual,35,39)	// 35-39
			 replace ilo_job2_how_actual_bands = 6 if inrange(ilo_job2_how_actual,40,48)	// 40-48
			 replace ilo_job2_how_actual_bands = 7 if ilo_job2_how_actual>=49 & ilo_job2_how_actual !=. // 49+
			 replace ilo_job2_how_actual_bands = 8 if ilo_job2_how_actual_bands == . & ilo_mjh==2	// Not elsewhere classified
			 replace ilo_job2_how_actual_bands = . if ilo_mjh!=2
                     *lab def how_actual_bands_lab 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"
					 lab val ilo_job2_how_actual_bands how_bands_lab
					 lab var ilo_job2_how_actual_bands "Weekly hours actually worked bands in second job"

	******
	
	*** ALL JOBS

		
 egen ilo_joball_how_actual = rowtotal(ilo_job1_how_actual ilo_job2_how_actual), m 
			 lab var ilo_joball_how_actual "Weekly hours actually worked in all jobs"
						
		 gen ilo_joball_actual_how_bands = .
			 replace ilo_joball_actual_how_bands=1 if ilo_joball_how_actual==0 // No hours actually worked
			 replace ilo_joball_actual_how_bands=2 if ilo_joball_how_actual>=1 & ilo_joball_how_actual<=14  // 01-14
			 replace ilo_joball_actual_how_bands=3 if ilo_joball_how_actual>=15 & ilo_joball_how_actual<=29 // 15-29
			 replace ilo_joball_actual_how_bands=4 if ilo_joball_how_actual>=30 & ilo_joball_how_actual<=34 // 30-34
			 replace ilo_joball_actual_how_bands=5 if ilo_joball_how_actual>=35 & ilo_joball_how_actual<=39 // 35-39
			 replace ilo_joball_actual_how_bands=6 if ilo_joball_how_actual>=40 & ilo_joball_how_actual<=48 // 40-48
			 replace ilo_joball_actual_how_bands=7 if ilo_joball_how_actual>=49 & ilo_joball_how_actual!=.  // 49+
			 replace ilo_joball_actual_how_bands=8 if ilo_joball_actual_how_bands==. & ilo_lfs==1           // Not elsewhere classified
			 replace ilo_joball_actual_how_bands=. if ilo_lfs!=1
			 		 lab val ilo_joball_actual_how_bands how_bands_lab 
					 lab var ilo_joball_actual_how_bands "Weekly hours actually worked bands in all jobs"
			

					
					
 
		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*		2. 	Hours of work usually worked ('ilo_job1_how_usual')     
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
 
*** MAIN JOB


  
		gen ilo_job1_how_usual = e3a if ilo_lfs==1
				lab var ilo_job1_how_usual "Weekly hours usually worked in main job"	      
		
		gen ilo_job1_how_usual_bands = .
			 replace ilo_job1_how_usual_bands = 1 if ilo_job1_how_usual == 0		    // No hours usually worked
			 replace ilo_job1_how_usual_bands = 2 if inrange(ilo_job1_how_usual,1,14)	// 01-14
			 replace ilo_job1_how_usual_bands = 3 if inrange(ilo_job1_how_usual,15,29)	// 15-29
			 replace ilo_job1_how_usual_bands = 4 if inrange(ilo_job1_how_usual,30,34)	// 30-34
			 replace ilo_job1_how_usual_bands = 5 if inrange(ilo_job1_how_usual,35,39)	// 35-39
			 replace ilo_job1_how_usual_bands = 6 if inrange(ilo_job1_how_usual,40,48)	// 40-48
			 replace ilo_job1_how_usual_bands = 7 if ilo_job1_how_usual>=49 & ilo_job1_how_usual !=. // 49+
			 replace ilo_job1_how_usual_bands = 8 if ilo_job1_how_usual_bands == .	// Not elsewhere classified
			 replace ilo_job1_how_usual_bands = . if ilo_lfs! = 1
			 lab def how_usu_bands_lab 1 "No hours usually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"
					 lab val ilo_job1_how_usual_bands how_usu_bands_lab
					 lab var ilo_job1_how_usual_bands "Weekly hours usually worked bands in main job"
		
*** SECOND JOB
** Comment: the information is on ALL OTHER JOBS
 
gen ilo_job2_how_usual = e3b if ilo_mjh==2
				lab var ilo_job2_how_usual "Weekly hours usually worked in main job"	      
		
		gen ilo_job2_how_usual_bands = .
			 replace ilo_job2_how_usual_bands  = 1 if ilo_job2_how_usual == 0				// No hours usually worked
			 replace ilo_job2_how_usual_bands  = 2 if inrange(ilo_job2_how_usual,1,14)	// 01-14
			 replace ilo_job2_how_usual_bands  = 3 if inrange(ilo_job2_how_usual,15,29)	// 15-29
			 replace ilo_job2_how_usual_bands  = 4 if inrange(ilo_job2_how_usual,30,34)	// 30-34
			 replace ilo_job2_how_usual_bands  = 5 if inrange(ilo_job2_how_usual,35,39)	// 35-39
			 replace ilo_job2_how_usual_bands  = 6 if inrange(ilo_job2_how_usual,40,48)	// 40-48
			 replace ilo_job2_how_usual_bands  = 7 if ilo_job2_how_usual>=49 & ilo_job1_how_usual !=. // 49+
			 replace ilo_job2_how_usual_bands  = 8 if ilo_job2_how_usual_bands == .	// Not elsewhere classified
			 replace ilo_job2_how_usual_bands  = . if ilo_lfs! = 1
			 *lab def how_usu_bands_lab 1 "No hours usually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"
					 lab val ilo_job2_how_usual_bands how_usu_bands_lab
					 lab var ilo_job2_how_usual_bands "Weekly hours usually worked bands in main job"
						
	

	
*** ALL JOBS 

 
gen ilo_joball_how_usual = e3b if  ilo_lfs== 1
			lab var ilo_job2_how_usual "Weekly hours usually worked in main job"	      
		
		gen ilo_joball_how_usual_bands = .
			 replace ilo_joball_how_usual_bands  = 1 if ilo_joball_how_usual == 0				// No hours usually worked
			 replace ilo_joball_how_usual_bands  = 2 if inrange(ilo_joball_how_usual,1,14)	// 01-14
			 replace ilo_joball_how_usual_bands  = 3 if inrange(ilo_joball_how_usual,15,29)	// 15-29
			 replace ilo_joball_how_usual_bands  = 4 if inrange(ilo_joball_how_usual,30,34)	// 30-34
			 replace ilo_joball_how_usual_bands  = 5 if inrange(ilo_joball_how_usual,35,39)	// 35-39
			 replace ilo_joball_how_usual_bands  = 6 if inrange(ilo_joball_how_usual,40,48)	// 40-48
			 replace ilo_joball_how_usual_bands  = 7 if ilo_joball_how_usual>=49 & ilo_job1_how_usual !=. // 49+
			 replace ilo_joball_how_usual_bands  = 8 if ilo_joball_how_usual_bands == .	// Not elsewhere classified
			 replace ilo_joball_how_usual_bands  = . if ilo_lfs! = 1
			 *lab def how_usu_bands_lab 1 "No hours usually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"
					 lab val ilo_joball_how_usual_bands how_usu_bands_lab
					 lab var ilo_joball_how_usual_bands "Weekly hours usually worked bands in main job"
	
	
	
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job1_job_contract')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
 

*** main job
gen ilo_job1_job_contract=.

		replace ilo_job1_job_contract=1 if d8==1 & ilo_job1_ste_aggregate==1 // 1 - Permanent
		replace ilo_job1_job_contract=2 if inlist(d8,2,3) & ilo_job1_ste_aggregate==1 // 2 - Temporary
		replace ilo_job1_job_contract=3 if ilo_job1_job_contract == . & ilo_job1_ste_aggregate==1 // 3 - Unknown
				lab def job_contract_lab 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"
			    lab val ilo_job1_job_contract job_contract_lab
			    lab var ilo_job1_job_contract "Job (Type of contract)"

	

	
	
*** second job

* Comment: No information

	

	
	
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Formal / Informal Economy ('ilo_job1_ife_prod' 'ilo_job1_ife_nature')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
 
 
/* Useful questions:
			- Institutional sector: d5
			
			- Destination of production: ** d5==8 >> household
			** Comment: there is one more category for question d5 that does not appear in the questionnaire (d5==8). 
			
			- Bookkeeping: d21 
			- Registration: d20
			- Household identification: ilo_job1_eco_isic4_2digits==97 or ilo_job1_ocu_isco08_2digits==63
			- Social security contribution: d10				 	
			- Place of work:  d4		
			- Size: d6
			- Status in employment: ilo_job1_ste_aggregate / ilo_job1_ste_icse93
			- Paid annual leave: d11
			- Paid sick leave:  d12
*/
	   
   
    
 **  ** YVES: DOUBT: size >> only possible to establish below 5, (interval 5 to 9). 
	
	
	
	* 1) UNIT OF PRODUCTION: FORMAL/INFORMAL SECTOR		
    			
			gen ilo_job1_ife_prod=.
			    replace ilo_job1_ife_prod=3 if ilo_lfs==1 & ((d5==8) | (ilo_job1_eco_isic4_2digits==97 |ilo_job1_ocu_isco08_2digits==63) )
				
				replace ilo_job1_ife_prod=2 if ilo_lfs==1 & inrange(d5,1,4) | ///
				                               (inlist(d5,5,6,7,.) & d21==1) | ///
											   (inlist(d5,5,6,7,.) & d21!=1 & d20==1) | ///
											   (inlist(d5,5,6,7,.) & d21!=1 & d20==. & ilo_job1_ste_aggregate==1 & d10==1) | ///
											   (inlist(d5,5,6,7,.) & d21!=1 & d20==. & ilo_job1_ste_aggregate==1 & d10!=1 & inlist(d4,1,2) & inrange(d6,3,7)) | ///
											   (inlist(d5,5,6,7,.) & d21!=1 & d20==. & ilo_job1_ste_aggregate!=1 & inlist(d4,1,2) & inrange(d6,3,7))
											   
			    replace ilo_job1_ife_prod=1 if ilo_lfs==1 & (!inlist(ilo_job1_ife_prod,3,2)) & ///
				                               ((inlist(d5,5,6,7,.) & d21!=1 & d20!=1) | ///
				                               (inlist(d5,5,6,7,.) & d21!=1 & d20==. & ilo_job1_ste_aggregate==1 & d10!=1 & !inlist(d4,1,2)) | ///
											   (inlist(d5,5,6,7,.) & d21!=1 & d20==. & ilo_job1_ste_aggregate==1 &d10!=1 & inlist(d4,1,2) & !inrange(d6,3,7)) | ///
											   (inlist(d5,5,6,7,.) & d21!=1 & d20==. & ilo_job1_ste_aggregate!=1 & !inlist(d4,1,2)) | ///
											   (inlist(d5,5,6,7,.) & d21!=1 & d20==. & ilo_job1_ste_aggregate!=1 & inlist(d4,1,2) & !inrange(d6,3,7)))
											   
				        lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 
						lab val ilo_job1_ife_prod ilo_ife_prod_lab
						lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"
						
						
						
	* 2) NATURE OF JOB: FORMAL/INFORMAL EMPLOYMENT
	
	      gen ilo_job1_ife_nature=.
		      replace ilo_job1_ife_nature=2 if ilo_lfs==1 & ((inlist(ilo_job1_ste_icse93,1,6) & d10==1) | ///
			                                   (inlist(ilo_job1_ste_icse93,1,6) & d10==. & d11==1 & d12==1) | ///
											   (inlist(ilo_job1_ste_icse93,2,4) & ilo_job1_ife_prod==2) | ///
											   (d5!=8 & ilo_job1_ste_icse93==3 & ilo_job1_ife_prod==2))
			  replace ilo_job1_ife_nature=1 if ilo_lfs==1 & (ilo_job1_ife_nature!=2)
			          lab def ife_nature_lab 1 "1 - Persons with informal main job" 2 "2 - Persons with formal main job"
			          lab val ilo_job1_ife_nature ife_nature_lab
			          lab var ilo_job1_ife_nature "Informal / Formal Economy (Nature of job)"
					  
	       
	
	
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Monthly related income ('ilo_job1_lri_ees' and 'ilo_job1_lri_slf')    
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: - The income if asked monthly
* Currency: Kwacha
 
  
*** YVES: --DOUBT: I think that the information is related to main job because of question FA1.

*** DOUBT: FB4 ????????   how do we set the frequency? 
		
********* MAIN JOB 

*** Employees	

gen ilo_job1_lri_ees=.
          replace ilo_job1_lri_ees =  fa3 if (fa1==1 & ilo_job1_ste_aggregate==1)                          // Month
  		  replace ilo_job1_lri_ees =  fa3*(2) if (fa1==2 & ilo_job1_ste_aggregate==1)                      // Two weeks
		  replace ilo_job1_lri_ees =  fa3*(52/12) if (fa1==3 & ilo_job1_ste_aggregate==1)                  // Week
		  replace ilo_job1_lri_ees =  fa3*(365/12) if (fa1==4 & ilo_job1_ste_aggregate==1)                 // Day
		  replace ilo_job1_lri_ees =  fa3*(8760/12) if (fa1==5 & ilo_job1_ste_aggregate==1)                // Hourly
		  replace ilo_job1_lri_ees =  fa3*(1/12) if (fa1==6 & ilo_job1_ste_aggregate==1)                   // One year
		   
		      lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"
 
	
	 

*** Self-employed			   
 
 
gen ilo_job1_lri_slf=.
          replace ilo_job1_lri_slf =  fb2 if (fb1==1 & ilo_job1_ste_aggregate==2)                          // Month
  		  replace ilo_job1_lri_slf =  fb2*(2) if (fb1==2 & ilo_job1_ste_aggregate==2)                      // Two weeks
		  replace ilo_job1_lri_slf =  fb2*(52/12) if (fb1==3 & ilo_job1_ste_aggregate==2)                  // Week
		  replace ilo_job1_lri_slf =  fb2*(365/12) if (fb1==4 & ilo_job1_ste_aggregate==2)                 // Day
		  replace ilo_job1_lri_slf =  fb2*(8760/12) if (fb1==5 & ilo_job1_ste_aggregate==2)                // Hourly
		  replace ilo_job1_lri_slf =  fb2*(1/12) if (fb1==6 & ilo_job1_ste_aggregate==2)                   // One year
		   
		        lab var ilo_job1_lri_slf "Monthly earnings of self-employed in main job"
 
	
		

		
		
		
			
				
***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_joball_tru')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
 
 
		
		gen ilo_joball_tru = .
		replace ilo_joball_tru = 1 if  e5 == 1 & e6 == 1 & ilo_job1_how_usual < 40
			lab def lab_joball_tru 1 "Time-related underemployed" 
			lab val ilo_joball_tru lab_joball_tru
			lab var ilo_joball_tru "Time-related underemployed"
			
			
			
			
  
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Cases of non-fatal occupational injury ('ilo_joball_oi_case')
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------

** Yves: the label seems not to work properly. 

	gen ilo_joball_oi_case = .
		replace ilo_joball_oi_case = 1 if i1==1 
			lab def lab_ilo_joball_oi_case 1 "Cases of non-fatal occupational injury"
     		lab val ilo_joball_oi_case lab_joball_oi_case
			lab var ilo_joball_oi_case "Cases of non-fatal occupational injury"



			
			
			
			
			
			

*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Days lost due to cases of occupational injury ('ilo_joball_oi_day')    
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------



		gen ilo_joball_oi_day = i4b if (i4b!=0 & ilo_lfs==1)	
				lab val ilo_joball_oi_day lab_ilo_joball_oi_day 
				lab var ilo_joball_oi_day "Days lost due to cases of occupational injury"
    
   
    



***********************************************************************************************
*			PART 3.3. UNEMPLOYMENT: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Category of unemployment ('ilo_cat_une')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------


** Comment: no information available to compute this variable. 
				
				
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur')  ????
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

** YVES
** DOUBT: Is this possible to compute in this case???
** Comment: the question to compute this variable is g3, but it is only answered for people with ilo_lfs==1 or ilo_lfs==3.
** Comment: only asked to unemployed people who are not looking for job
 

	*gen ilo_dur_details=.
	*		    replace ilo_dur_details=1 if (g3==1 & ilo_lfs==2)            // Less than 1 month
	*		 	replace ilo_dur_details=2 if (g3==2 & ilo_lfs==2)            // 1 to 3 months
	*		 	replace ilo_dur_details=3 if (g3==3 & ilo_lfs==2)            // 3 to 6 months
	*		 	replace ilo_dur_details=4 if (g3==4 & ilo_lfs==2)            // 6 to 12 months
	*		 	replace ilo_dur_details=5 if (g3==5 & ilo_lfs==2)            // 12 to 24 months
	*		 	replace ilo_dur_details=6 if (g3==6 & ilo_lfs==2)            // 24 months or more
	*		 	replace ilo_dur_details=7 if (g3==. & ilo_lfs==2)            // Not elsewhere classified
	*		 	        lab def ilo_unemp_det 1 "Less than 1 month" 2 "1 month to less than 3 months" 3 "3 months to less than 6 months" ///
	*		 								  4 "6 months to less than 12 months" 5 "12 months to less than 24 months" 6 "24 months or more" ///
	*		 								  7 "Not elsewhere classified"
	*		 		    lab val ilo_dur_details ilo_unemp_det
	*		 		    lab var ilo_dur_details "Duration of unemployment (Details)"
					
	* gen ilo_dur_aggregate=.
	 *	replace ilo_dur_aggregate=1 if (inlist(ilo_dur_details,1,2,3) & ilo_lfs==2)       // Less than 6 months
	 *	replace ilo_dur_aggregate=2 if (ilo_dur_details==4 & ilo_lfs==2)                  // 6 to 12 months
	 *	replace ilo_dur_aggregate=3 if (inlist(ilo_dur_details,5,6) & ilo_lfs==2)         // 12 months or more
	 *	replace ilo_dur_aggregate=4 if (ilo_dur_aggregate==. & ilo_lfs==2)      //Not elsewhere classified
	 *	replace ilo_dur_aggregate=. if ilo_lfs!=2
	 *		lab def ilo_unemp_aggr 1 "Less than 6 months" 2 "6 months to less than 12 months" 3 "12 months or more" 4 "Not elsewhere classified"
	 *		lab val ilo_dur_aggregate ilo_unemp_aggr
	 *		lab var ilo_dur_aggregate "Duration of unemployment (Aggregate)"
			
			
			
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

	
*** no information
			
			
	 
				
				
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	


*** no information

	

				  
			  
				  
				  
***********************************************************************************************
*			PART 3.4. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************		


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		.	

** Comment: there is no information about willingness. 					
				
		gen ilo_olf_dlma = .
		
		
		replace ilo_olf_dlma = 1 if ilo_lfs == 3 & g1==1 & g5==4		        // Seeking (actively), not available
		replace ilo_olf_dlma = 2 if ilo_lfs == 3 & g1==2 & inrange(g5,1,3)	    // Not seeking, available
		*replace ilo_olf_dlma = 3 if ilo_lfs == 3 &                    // Not seeking, not available, willing  
		*replace ilo_olf_dlma = 4 if ilo_lfs == 3 &  			                // Not seeking, not available, not willing  
		replace ilo_olf_dlma = 5 if	ilo_olf_dlma == . & ilo_lfs == 3				                            // Not classified 
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
			replace ilo_olf_reason = 1 if inrange(g4,4,6) & ilo_lfs==3   // Labour market
			replace ilo_olf_reason=2 if inrange(g4,1,3) & ilo_lfs==3      // Other labour market reasons
			replace ilo_olf_reason = 3 if inrange(g4,7,10)   & ilo_lfs==3    // Personal/Family-related
			replace ilo_olf_reason=4 if g4 == 11  & ilo_lfs==3		      // Does not need/want to work
			replace ilo_olf_reason=5 if g4 == 12  & ilo_lfs==3	      // Not elsewhere classified
			replace ilo_olf_reason=5 if ilo_olf_reason==. & ilo_lfs==3	      // Not elsewhere classified
				    lab def reasons_lab 1 "1 - Labour market" 2 "2 - Other labour market reasons" 3 "3 - Personal / Family-related" ///
									    4 "4 - Does not need/want to work" 5 "5 - Not elsewhere classified"
				    lab val ilo_olf_reason reasons_lab 
				    lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"			

 	
					
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seeker ('ilo_dis')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		


	gen ilo_dis = 1 if (ilo_lfs==3 & inrange(g5,1,3) & ilo_olf_reason==1)
			lab def dis_lab 1 "Discouraged job-seekers"
			lab val ilo_dis dis_lab
			lab var ilo_dis "Discouraged job-seekers"
					 
	

			
			
			
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
				
				
				
				
				
				
				
				
				
				
				
				
				

	
	
	
	