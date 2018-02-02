* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Italy LFS
* DATASET USED: Italy LFS 2013Q4
* NOTES:
* Authors: Estefania Alaminos
* Who last updated the file: Estefania Alaminos 
* Starting Date: 07/11/2017
* Last updated: 09/11/2017
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
global time "2013Q4"
global inputFile "RCFL_A2013.dta"
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
      	   replace ilo_wgt = coef
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
**          The geographical information given in the questionnaire is region and province, 
**			therefore this geographical units are too big how to do the distinction between urban/rural area. 
  
		 
		
		


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

** Comment: - Age given in five (cletas) and ten (cletad) year intervals.
** Comment: - The variable with year-to-year age data is reserved to ISTAT. 

** Comment: - It is only possible to compute the ilo_age_10yrbands

destring cletad, replace


	*gen ilo_age = etam
	 *   lab var ilo_age "Age"



* Age groups

/*

destring cletas, replace


Comment: the variable cletas does not have the limits of the intervals as the variable ilo_age_5yrbands

	gen ilo_age_5yrbands =.
		replace ilo_age_5yrbands = 1 if inrange(cletas,1,2)
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
			
	*/		
			
	gen ilo_age_10yrbands = .
		replace ilo_age_10yrbands = 1 if cletad == 1
		replace ilo_age_10yrbands = 2 if cletad == 2
		replace ilo_age_10yrbands = 3 if cletad == 3
		replace ilo_age_10yrbands = 4 if cletad == 4
		replace ilo_age_10yrbands = 5 if cletad == 5
		replace ilo_age_10yrbands = 6 if cletad == 6
		replace ilo_age_10yrbands = 7 if inlist(cletad,7,8) & cletad != .
			    lab def age_by10_lab 1 "<15" 2 "15-24" 3 "25-34" 4 "35-44" 5 "45-54" 6 "55-64" 7 "65+"
			    lab val ilo_age_10yrbands age_by10_lab
			    lab var ilo_age_10yrbands "Age (10-year age bands)"
	
	
	gen ilo_age_aggregate = .
		replace ilo_age_aggregate = 1 if cletad == 1
		replace ilo_age_aggregate = 2 if cletad == 2
		replace ilo_age_aggregate = 3 if inlist(cletad,3,4)
		replace ilo_age_aggregate = 4 if inlist(cletad,5,6)
		replace ilo_age_aggregate = 5 if inlist(cletad,7,8) & cletad != .
		    	lab def age_aggr_lab 1 "<15" 2 "15-24" 3 "25-54" 4 "55-64" 5 "65+"
			    lab val ilo_age_aggregate age_aggr_lab
			    lab var ilo_age_aggregate "Age (Aggregate)"
	


	
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education ('ilo_edu')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------





destring sg24, replace
 



gen ilo_edu_isced11=.
		replace ilo_edu_isced11=1 if sg24 == 1                                    // No schooling
		*replace ilo_edu_isced11=2 if sg24                                        // Early childhood education
		replace ilo_edu_isced11=3 if sg24 == 2                                   // Primary education 
		replace ilo_edu_isced11=4 if sg24 == 3                                  // Lower secondary education
		replace ilo_edu_isced11=5 if sg24 == 4                                   // Upper secondary education
		replace ilo_edu_isced11=6 if sg24 == 5                                   // Post-secodary non-tertiary education
		replace ilo_edu_isced11=7 if inlist(sg24,6,7)                                   // Short-cycle tertiary education
		replace ilo_edu_isced11=8 if sg24 == 8                                   // Bachelor's or equivalent level
		replace ilo_edu_isced11=9 if inlist(sg24,9,10)                            // Master's or equivalent level
		*replace ilo_edu_isced11=10 if                                            // Doctoral or equivalent level
		replace ilo_edu_isced11=11 if ilo_edu_isced11 == .						 // Not elsewhere classified 
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
		replace ilo_wap = 1 if ilo_age_aggregate >= 2 & ilo_age_aggregate !=.	// Working age population
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
destring b6, replace
destring b7, replace
destring b9, replace,                                                                                                
destring b10, replace
destring b11, replace
destring cond3, replace


gen ilo_lfs =.

		** EMPLOYED (done) 

		replace ilo_lfs = 1 if b1 == 1 &  ilo_wap == 1  
		replace ilo_lfs = 1 if b2 == 1 & (inrange(b3,5,9) | b3==12)  & ilo_wap == 1
		replace ilo_lfs = 1 if (b6==1 | b7==1 | b9==1 | b10==1 | b11==1)  & ilo_wap == 1  

	
	    ** UNEMPLOYED 
		** Comment: the questionnaire, for unemployed people, skips the question about availability. 
		** 			Therefore it is used the LFS variable computed by ISTAT. 

		replace ilo_lfs = 2 if cond3 == 2 & ilo_wap == 1


		
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
 
destring d1, replace 

/* 
Comment:

		- Second job: d1 == 1
		- More than one job: d1 == 2
*/
 
 
gen  ilo_mjh = .

** - 1. One job only

	replace ilo_mjh = 1 if  d1 == 3 & ilo_lfs == 1

** - 2. More than one job

	replace ilo_mjh = 2 if d1 != 3 & ilo_lfs == 1
	

	
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


 
**** MAIN JOB

 

destring c1, replace
 


* Detailed categories:

		gen ilo_job1_ste_icse93 = .
		
			replace ilo_job1_ste_icse93 = 1 if inrange(c1,1,3)   & ilo_lfs == 1   	 // Employees
			
			replace ilo_job1_ste_icse93 = 2 if c1 == 4 & ilo_lfs==1                 // Employers
			
			replace ilo_job1_ste_icse93 = 3 if inlist(c1,5,6) & ilo_lfs==1          // Own-account workers
			
			replace ilo_job1_ste_icse93 = 4 if c1 == 8 & ilo_lfs==1                 // Members of producers cooperatives

			replace ilo_job1_ste_icse93 = 5 if c1 == 7 & ilo_lfs==1 	            // Contributing family workers
			
			*replace ilo_job1_ste_icse93 = 6 if                                    // Workers not classifiable by status
			
			
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


destring d4, replace
 


* Detailed categories:

		gen ilo_job2_ste_icse93 = .
		
			replace ilo_job2_ste_icse93 = 1 if inrange(d4,1,3) & inlist(d1,1,2)  	   // Employees
			
			replace ilo_job2_ste_icse93 = 2 if d4 == 4 & inlist(d1,1,2)               // Employers
			
			replace ilo_job2_ste_icse93 = 3 if inlist(d4,5,6) & inlist(d1,1,2)       // Own-account workers
			
			replace ilo_job2_ste_icse93 = 4 if d4 == 8 & inlist(d1,1,2)              // Members of producers cooperatives

			replace ilo_job2_ste_icse93 = 5 if d4 == 7 & inlist(d1,1,2)	            // Contributing family workers
			
			*replace ilo_job2_ste_icse93 = 6 if        // Workers not classifiable by status
			
 				label val ilo_job2_ste_icse93 label_ilo_ste_icse93
				label var ilo_job2_ste_icse93 "Status in employment (ICSE 93) - Second job"
				
				
				
				
* Aggregate categories
 
		gen ilo_job2_ste_aggregate = . 
		
			replace ilo_job2_ste_aggregate = 1 if ilo_job2_ste_icse93 == 1 & inlist(d1,1,2)	                // Employees
			
			replace ilo_job2_ste_aggregate = 2 if inlist(ilo_job2_ste_icse93,2,3,4,5) & inlist(d1,1,2)   	// Self-employed
			
			replace ilo_job2_ste_aggregate = 3 if ilo_job2_ste_icse93 == 6 & inlist(d1,1,2)	 				    // Not elsewhere classified
			replace ilo_job2_ste_aggregate = 3 if ilo_job2_ste_icse93 == . & inlist(d1,1,2)	  			
			
 				lab val ilo_job2_ste_aggregate ste_aggr_lab
				label var ilo_job2_ste_aggregate "Status in employment (Aggregate) - Second job" 

		
		
		
		
		
		
		
 
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco')   
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------				

* ISIC Rev. 4


	* MAIN JOB:
	 
	 destring ate2d, replace

	
 	* 2-digit level	
	gen ilo_job1_eco_isic4_2digits = ate2d if ilo_lfs == 1
		
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

			   
	************		   
			   
			   
	**** SECOND JOB:
	
	destring ate2ds, replace
	
	 	* 2-digit level	
	gen ilo_job2_eco_isic4_2digits = ate2ds if d1==1
		
 
        lab val ilo_job2_eco_isic4_2digits eco_isic4_digits
        lab var ilo_job2_eco_isic4_2digits "Economic activity (ISIC Rev. 4), 2 digits levels - second job"

	* 1-digit level
    gen ilo_job2_eco_isic4 = .
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
	    replace ilo_job2_eco_isic4=22 if ilo_job2_eco_isic4_2digits==. & d1==1
		        
  	  		    lab val ilo_job2_eco_isic4 eco_isic4
			    lab var ilo_job2_eco_isic4 "Economic activity (ISIC Rev. 4) - second job"

   * Aggregate level
   gen ilo_job2_eco_aggregate = .
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
*			Occupation ('ilo_job1_ocu_isco08')  
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

 

 * MAIN JOB	
 
 destring prof3, replace
	gen occ_code_prim=.
	    replace occ_code_prim=int(prof3/10)
         
    * 2-digit level
	gen ilo_job1_ocu_isco08_2digits = occ_code_prim if ilo_lfs==1
	
	 	
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
	
destring prof3s, replace

	gen occ_code_sec=.
	    replace occ_code_sec=int(prof3s/10)
         
    * 2-digit level
	gen ilo_job2_ocu_isco08_2digits = occ_code_sec if d1==1
	
  
	lab val ilo_job2_ocu_isco08_2digits ocu_isco08_2digits
		lab var ilo_job2_ocu_isco08_2digits "Occupation (ISCO-08), 2 digit level - main job"

		
		
    * 1-digit level
	gen ilo_job2_ocu_isco08 =.
		replace ilo_job2_ocu_isco08=int(ilo_job2_ocu_isco08_2digits/10) if d1==1    // The rest of the occupations
		replace ilo_job2_ocu_isco08=10 if (ilo_job2_ocu_isco08==0 & d1==1)           // Armed forces
	    replace ilo_job2_ocu_isco08=11 if ilo_job2_ocu_isco08_2digits==. & d1==1    // Not elsewhere classified

 				lab val ilo_job2_ocu_isco08 ocu08_1digits
				lab var ilo_job2_ocu_isco08 "Occupation (ISCO-08) - main job"
			
			
	* Aggregate:			
    gen ilo_job2_ocu_aggregate=.
	    replace ilo_job2_ocu_aggregate=1 if inrange(ilo_job2_ocu_isco08,1,3)   
	    replace ilo_job2_ocu_aggregate=2 if inlist(ilo_job2_ocu_isco08,4,5)
	    replace ilo_job2_ocu_aggregate=3 if inlist(ilo_job2_ocu_isco08,6,7)
	    replace ilo_job2_ocu_aggregate=4 if ilo_job2_ocu_isco08==8
	    replace ilo_job2_ocu_aggregate=5 if ilo_job2_ocu_isco08==9
	    replace ilo_job2_ocu_aggregate=6 if ilo_job2_ocu_isco08==10
	    replace ilo_job2_ocu_aggregate=7 if ilo_job2_ocu_isco08==11
 			    lab val ilo_job2_ocu_aggregate ocu_aggr_lab
			    lab var ilo_job2_ocu_aggregate "Occupation (Aggregate) - main job"	
		
	* Skill level
	gen ilo_job2_ocu_skill=.
	    replace ilo_job2_ocu_skill=1 if ilo_job2_ocu_isco08==9                   // Low
		replace ilo_job2_ocu_skill=2 if inlist(ilo_job2_ocu_isco08,4,5,6,7,8)    // Medium
		replace ilo_job2_ocu_skill=3 if inlist(ilo_job2_ocu_isco08,1,2,3)        // High
		replace ilo_job2_ocu_skill=4 if inlist(ilo_job2_ocu_isco08,10,11)        // Not elsewhere classified
 			    lab val ilo_job2_ocu_skill ocu_skill_lab
			    lab var ilo_job2_ocu_skill "Occupation (Skill level) - main job"	

	
  
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_job1_ins_sector')  
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		


	
***** MAIN JOB *****
 
 * Comment: No information
****        Private information (C14A)
		 
			 

	 
	 
	 	
***** SECOND JOB *****
 
 
* Comment: No information
		 

	 	
	
		
		
		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job1_job_time') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			

 
***** MAIN JOB *****

destring c27, replace
 
		gen ilo_job1_job_time = .
		replace ilo_job1_job_time = 1 if c27 == 2 & ilo_lfs == 1 				// 1 - Part-time
		replace ilo_job1_job_time = 2 if c27 == 1  & ilo_lfs == 1 				// 2 - Full-time
		replace ilo_job1_job_time = 3 if ilo_job1_job_time == . & ilo_lfs == 1 		// 3 - Unknown
			lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknow"
			    lab values ilo_job1_job_time job_time_lab
			    lab var ilo_job1_job_time "Job (Working time arrangement)"


***** SECOND JOB *****


** No information


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*		1. 	Hours of work actually worked ('ilo_job1_how_actual')   
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

** MAIN JOB

* ilo_job1_how_actual
destring c37, replace


	gen ilo_job1_how_actual = c37 if ilo_lfs == 1
			replace ilo_job1_how_actual = . if ilo_job1_how_actual == 997
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
 
   * ilo_job2_how_actual
destring d2, replace

 		gen ilo_job2_how_actual =d2 if inlist(d1,1,2)
		 		replace ilo_job2_how_actual = . if ilo_job2_how_actual == 997
				lab var ilo_job2_how_actual "Weekly hours actually worked in main job"	      
		
		gen ilo_job2_how_actual_bands = .
			 replace ilo_job2_how_actual_bands = 1 if ilo_job2_how_actual == 0				// No hours actually worked
			 replace ilo_job2_how_actual_bands = 2 if inrange(ilo_job2_how_actual,1,14)	    // 01-14
			 replace ilo_job2_how_actual_bands = 3 if inrange(ilo_job2_how_actual,15,29)	// 15-29
			 replace ilo_job2_how_actual_bands = 4 if inrange(ilo_job2_how_actual,30,34)	// 30-34
			 replace ilo_job2_how_actual_bands = 5 if inrange(ilo_job2_how_actual,35,39)	// 35-39
			 replace ilo_job2_how_actual_bands = 6 if inrange(ilo_job2_how_actual,40,48)	// 40-48
			 replace ilo_job2_how_actual_bands = 7 if ilo_job2_how_actual>=49 & ilo_job2_how_actual !=. // 49+
			 replace ilo_job2_how_actual_bands = 8 if ilo_job2_how_actual_bands == . &  inlist(d1,1,2) 	// Not elsewhere classified
			 *replace ilo_job2_how_actual_bands = . if ilo_job2_how_actual == . &  d1==1 
                     *lab def how_actual_bands_lab 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"
					 lab val ilo_job2_how_actual_bands how_bands_lab
					 lab var ilo_job2_how_actual_bands "Weekly hours actually worked bands in second job"

	******
	
	*** ALL JOBS

					
		*** Weekly hours actually worked in all jobs		
		
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

destring c31, replace 

  
		gen ilo_job1_how_usual = c31 if ilo_lfs==1
				lab var ilo_job1_how_usual "Weekly hours usually worked in main job"	      
		
		gen ilo_job1_how_usual_bands = .
			 replace ilo_job1_how_usual_bands = 1 if ilo_job1_how_usual == 0		    // No hours usually worked
			 replace ilo_job1_how_usual_bands = 2 if inrange(ilo_job1_how_usual,1,14)	// 01-14
			 replace ilo_job1_how_usual_bands = 3 if inrange(ilo_job1_how_usual,15,29)	// 15-29
			 replace ilo_job1_how_usual_bands = 4 if inrange(ilo_job1_how_usual,30,34)	// 30-34
			 replace ilo_job1_how_usual_bands = 5 if inrange(ilo_job1_how_usual,35,39)	// 35-39
			 replace ilo_job1_how_usual_bands = 6 if inrange(ilo_job1_how_usual,40,48)	// 40-48
			 replace ilo_job1_how_usual_bands = 7 if ilo_job1_how_usual>=49 & ilo_job1_how_usual !=. // 49+
			 replace ilo_job1_how_usual_bands = 8 if c31 == inlist(900,997)	// Not elsewhere classified
			 replace ilo_job1_how_usual_bands = . if ilo_lfs! = 1
			 lab def how_usu_bands_lab 1 "No hours usually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"
					 lab val ilo_job1_how_usual_bands how_usu_bands_lab
					 lab var ilo_job1_how_usual_bands "Weekly hours usually worked bands in main job"
 	
	
	
*** SECOND JOB
** Comment: no information
  
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job1_job_contract')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
 

*** MAIN JOB

destring c20, replace 

gen ilo_job1_job_contract=.

		replace ilo_job1_job_contract=1 if c20==2 & ilo_job1_ste_aggregate==1 // 1 - Permanent
		replace ilo_job1_job_contract=2 if c20==1 & ilo_job1_ste_aggregate==1 // 2 - Temporary
		replace ilo_job1_job_contract=3 if ilo_job1_job_contract == . & ilo_job1_ste_aggregate==1 // 3 - Unknown
				lab def job_contract_lab 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"
			    lab val ilo_job1_job_contract job_contract_lab
			    lab var ilo_job1_job_contract "Job (Type of contract)"

	

	
	
*** SECOND JOB

* Comment: No information

	

	
	
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Formal / Informal Economy ('ilo_job1_ife_prod' 'ilo_job1_ife_nature')  
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
 

/* Useful questions:
			- Institutional sector: c14a (information reserved to ISTAT).
			- Destination of production: **  
			- Bookkeeping: ** 
			- Registration: **
			- Household identification: ilo_job1_eco_isic4_2digits==97 or ilo_job1_ocu_isco08_2digits==63
			- Social security contribution: c1bis, only asked to a national category of employees ("collaborazione coordinata e continuativa")				 	
			- Place of work: **  		
			- Size: c18
			- Status in employment: ilo_job1_ste_aggregate / ilo_job1_ste_icse93
			- Paid annual leave: **
			- Paid sick leave:  **
*/

	
	
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Monthly related income ('ilo_job1_lri_ees' and 'ilo_job1_lri_slf')    
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: - The income if asked monthly
* Currency: EURO

 
		
********* MAIN JOB 

*** Employees	

destring retric, replace

gen ilo_job1_lri_ees= retric if ilo_job1_ste_aggregate==1
    replace ilo_job1_lri_ees= . if ilo_job1_lri_ees==. & ilo_job1_ste_aggregate==1
	        
		   
		      lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"
 
	
	 

*** Self-employed			   
 
 ** Comment: there are observations that are zero. 
 
 gen ilo_job1_lri_slf= retric if   ilo_job1_ste_aggregate==2
    replace ilo_job1_lri_slf = . if ilo_job1_lri_slf==. & ilo_job1_ste_aggregate==2
	       		   
		        lab var ilo_job1_lri_slf "Monthly earnings of self-employed in main job"
 
	
		

		
		
		
			
				
***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_joball_tru') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
 
 destring c38, replace
 destring c40, replace 
		
		gen ilo_joball_tru = .
		replace ilo_joball_tru = 1 if  c38 == 2 & c40 == 1 & ilo_job1_how_usual < 35
			lab def lab_joball_tru 1 "Time-related underemployed" 
			lab val ilo_joball_tru lab_joball_tru
			lab var ilo_joball_tru "Time-related underemployed"
			
			
			
			
  
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Cases of non-fatal occupational injury ('ilo_joball_oi_case')
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------

** Comment: no information available. 



			

*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Days lost due to cases of occupational injury ('ilo_joball_oi_day')    
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------

** Comment: no information available. 



***********************************************************************************************
*			PART 3.3. UNEMPLOYMENT: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Category of unemployment ('ilo_cat_une')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

 
destring e1, replace 
destring f7, replace 

 
		gen ilo_cat_une=.
		replace ilo_cat_une=1 if e1 == 1 & ilo_lfs==2				        // 1 - Unemployed previously employed
		replace ilo_cat_une=2 if e1 == 2 & f7 == 1 & ilo_lfs==2				// 2 - Unemployed seeking their first job
		replace ilo_cat_une=3 if (ilo_cat_une==. & ilo_lfs==2)			    // 3 - Unknown
			lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
			    lab values ilo_cat_une cat_une_lab
			    lab var ilo_cat_une "Category of unemployment"				
				
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur')    
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
 

 destring durad, replace
 
 
 
 
	 gen ilo_dur_details=.
	 		    replace ilo_dur_details=1 if (durad<1 & ilo_lfs==2)                // Less than 1 month
	 		 	replace ilo_dur_details=2 if (inrange(durad,1,2) & ilo_lfs==2)     // 1 to 3 months
	  		 	replace ilo_dur_details=3 if (inrange(durad,3,5) & ilo_lfs==2)     // 3 to 6 months
	 		 	replace ilo_dur_details=4 if (inrange(durad,6,11) & ilo_lfs==2)    // 6 to 12 months
	 		 	replace ilo_dur_details=5 if (inrange(durad,12,23) & ilo_lfs==2)   // 12 to 24 months
	 		 	replace ilo_dur_details=6 if (durad>=24 & ilo_lfs==2)             // 24 months or more
	 		 	replace ilo_dur_details=7 if (durad==999 & ilo_lfs==2)            // Not elsewhere classified
	 		 	        lab def ilo_unemp_det 1 "Less than 1 month" 2 "1 month to less than 3 months" 3 "3 months to less than 6 months" ///
	 		 								  4 "6 months to less than 12 months" 5 "12 months to less than 24 months" 6 "24 months or more" ///
	 		 								  7 "Not elsewhere classified"
	 		 		    lab val ilo_dur_details ilo_unemp_det
	 		 		    lab var ilo_dur_details "Duration of unemployment (Details)"
					
	  gen ilo_dur_aggregate=.
	  	replace ilo_dur_aggregate=1 if (inlist(ilo_dur_details,1,2,3) & ilo_lfs==2)       // Less than 6 months
	  	replace ilo_dur_aggregate=2 if (ilo_dur_details==4 & ilo_lfs==2)                  // 6 to 12 months
	  	replace ilo_dur_aggregate=3 if (inlist(ilo_dur_details,5,6) & ilo_lfs==2)         // 12 months or more
	   	replace ilo_dur_aggregate=4 if (ilo_dur_aggregate==. & ilo_lfs==2)      //Not elsewhere classified
	  	replace ilo_dur_aggregate=. if ilo_lfs!=2
	  		lab def ilo_unemp_aggr 1 "Less than 6 months" 2 "6 months to less than 12 months" 3 "12 months or more" 4 "Not elsewhere classified"
	  		lab val ilo_dur_aggregate ilo_unemp_aggr
	  		lab var ilo_dur_aggregate "Duration of unemployment (Aggregate)"
			
 	
			
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco')  
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	



destring ate2de, replace

  * 2-digit level	
	gen ilo_preveco_isic4_2digits = ate2de if  ilo_cat_une == 1
         lab val ilo_preveco_isic4_2digits eco_isic4_2digits
        lab var ilo_preveco_isic4_2digits "Previous economic activity (ISIC Rev. 4), 2 digits levels"

	* 1-digit level
    gen ilo_preveco_isic4 = .
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
	    replace ilo_preveco_isic4=22 if ilo_preveco_isic4_2digits==. & ilo_cat_une == 1
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
*			Previous occupation ('ilo_prevocu')   
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

 
destring prof3e, replace
	gen occ_code_prev=.
	    replace occ_code_prev=int(prof3e/10)
         
    * 2-digit level
	gen ilo_prevocu_isco08_2digits = occ_code_prev if ilo_cat_une==1 
	 	
	
	lab val ilo_prevocu_isco08_2digits  ocu_isco08_2digits
		lab var ilo_prevocu_isco08_2digits  "Previous occupation (ISCO-08), 2 digit level"

		
		
    * 1-digit level
	gen ilo_prevocu_isco08 =.
		replace ilo_prevocu_isco08=int(ilo_prevocu_isco08_2digits /10) if ilo_cat_une==1     // The rest of the occupations
		replace ilo_prevocu_isco08=10 if (ilo_prevocu_isco08==0 & ilo_cat_une==1)           // Armed forces
	    replace ilo_prevocu_isco08=11 if (ilo_prevocu_isco08==. & ilo_cat_une==1)           // Not elsewhere classified

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
	

				  
			  
				  
				  
***********************************************************************************************
*			PART 3.4. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************		


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		.	

** Comment: there is a skip if you choose that you are actively seeking, which avoids willingness.
** there is also a skip before availability 
 
 destring f8, replace
 destring f12, replace 
 destring f13, replace


 
		gen ilo_olf_dlma = .
		
		
		*replace ilo_olf_dlma = 1 if ilo_lfs == 3 & f7==1 & f8==1 		        // Seeking (actively), not available
		replace ilo_olf_dlma = 2 if ilo_lfs == 3 & f7==2 & f13==1	            // Not seeking, available
		replace ilo_olf_dlma = 3 if ilo_lfs == 3 & f7==2 & f13==2 & f12==1       // Not seeking, not available, willing  
	
	* Comment: - only people who are willing, are not seeking and not available. Therefore the next category has zero observation. 
		replace ilo_olf_dlma = 4 if ilo_lfs == 3 & f7==2 & f13==2 & f12==2       // Not seeking, not available, not willing  
		
		replace ilo_olf_dlma = 5 if	ilo_olf_dlma == . & ilo_lfs == 3			 // Not classified 
				lab def dlma_lab 1 "1 - Seeking, not available (Unavailable jobseekers)" 2 "2 - Not seeking, available (Available potential jobseekers)" ///
	    						 3 "3 - Not seeking, not available, willing (Willing non-jobseekers)" 4 "4 - Not seeking, not available, not willing" 5 "X - Not elsewhere classified"
		    	lab val ilo_olf_dlma dlma_lab 
			    lab var ilo_olf_dlma "Labour market attachment (Degree of)"
			
				
		
	
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reason for not seeking job ('ilo_olf_reason')  
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

destring f10, replace 
 
gen ilo_olf_reason = .
			replace ilo_olf_reason = 1 if inlist(f10,5,8) & ilo_lfs==3   // Labour market
			replace ilo_olf_reason = 2 if f10==10 & ilo_lfs==3      // Other labour market reasons
			replace ilo_olf_reason = 3 if (inrange(f10,2,4) | inrange(f10,11,13))   & ilo_lfs==3    // Personal/Family-related
			replace ilo_olf_reason = 4 if inlist(f10,7,9)  & ilo_lfs==3		      // Does not need/want to work
			replace ilo_olf_reason = 5 if inlist(996,997)  & ilo_lfs==3	      // Not elsewhere classified
			replace ilo_olf_reason = 5 if ilo_olf_reason==. & ilo_lfs==3	      // Not elsewhere classified
				    lab def reasons_lab 1 "1 - Labour market" 2 "2 - Other labour market reasons" 3 "3 - Personal / Family-related" ///
									    4 "4 - Does not need/want to work" 5 "5 - Not elsewhere classified"
				    lab val ilo_olf_reason reasons_lab 
				    lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"			
 
					
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seeker ('ilo_dis')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		


	gen ilo_dis = 1 if (ilo_lfs==3 & f13==1 & ilo_olf_reason==1)
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
				
				
				
				
				
				
				
				
				
				
				
				
				

	
	
	
	
