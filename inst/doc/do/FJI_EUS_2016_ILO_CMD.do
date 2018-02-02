* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Fiji
* DATASET USED: EUS_2015_2016
* NOTES: 
* Files created: Standard variables on EUS Fiji
* Authors: Mabelin Villarreal Fuentes
* Who last updated the file: Mabelin Villarreal Fuentes
* Starting Date: 09 November 2017
* Last updated: 10 November 2017
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
global country "FJI"
global source "EUS"
global time "2016"
global inputFile "EUS_2015_2016"
global inpath "${path}\\${country}\\${source}\\${time}\ORI"
global temppath "${path}\_Admin"
global outpath "${path}\\${country}\\${source}\\${time}"


********************************************************************************************
********************************************************************************************

* Load original dataset

********************************************************************************************
********************************************************************************************

cd "$inpath"
	use "$inputFile", clear

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
	
	gen ilo_time=1
		lab def lab_time 1 "$time"
		lab val ilo_time lab_time
		lab var ilo_time "Time (Gregorian Calendar)"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sample Weight ('ilo_wgt') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - 7 observations without weights deleted

	gen ilo_wgt=weight
		lab var ilo_wgt "Sample weight"
	
	* only observations with weights are kept
	keep if ilo_wgt!=.

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
		replace ilo_geo=1 if area==1
		replace ilo_geo=2 if area==2
		        lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural"
		        lab val ilo_geo ilo_geo_lab
		        lab var ilo_geo "Geographical coverage"			 

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: 

	gen ilo_sex=.
	    replace ilo_sex=1 if sex==1
		replace ilo_sex=2 if sex==2
		        lab def ilo_sex_lab 1 "1 - Male" 2 "2 - Female"
		        lab var ilo_sex "Sex"
		        lab val ilo_sex ilo_sex_lab			
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment:

	gen ilo_age=.
	    replace ilo_age=age
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
*			Level of education ('ilo_edu') [to check---]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - to check: there are two variables: Education and Education2; I really don't know where the differences
*            are coming from, but they are different!.. I took Education2
*          - The highest level of education attained is used (1.10) together with the level of training
*            acquired (1.12) for those answering categories 1 to 9 in education.
*          - Primary education includes "Class 7 or Form 1" in category 4.
*          - ISCED mapping follows the document found here (Fiji):
*            http://uis.unesco.org/en/isced-mappings


	gen ilo_edu_isced97=.
		replace ilo_edu_isced97=1 if inlist(Education2,1,.) & inlist(Training,10,.)         // No schooling
		*replace ilo_edu_isced97=2 if                                                       // Pre-primary education
		replace ilo_edu_isced97=3 if inlist(Education2,2,3,4) & Training==10                // Primary education or first stage of basic education
		replace ilo_edu_isced97=4 if inlist(Education2,5,6) & Training==10                  // Lower secondary education or second stage of basic education
		replace ilo_edu_isced97=5 if inlist(Education2,7,8,9) & Training==10                // Upper secondary education
		replace ilo_edu_isced97=6 if inrange(Education2,2,9) & Training!=10                 // Post-secondary non-terciary education
		replace ilo_edu_isced97=7 if inlist(Education2,10,11,12)                            // First stage of tertiary education
		replace ilo_edu_isced97=8 if inlist(Education2,13,14)                               // Second stage of tertiary education
		replace ilo_edu_isced97=9 if ilo_edu_isced97==.                                                                                      // Level not stated
			    label def isced_97_lab 1 "X - No schooling" 2 "0 - Pre-primary education" 3 "1 - Primary education or first stage of basic education" ///
				                       4 "2 - Lower secondary education or second stage of basic education" 5 "3 - Upper secondary education" ///
									   6 "4 - Post-secondary non-tertiary education" 7 "5 - First stage of tertiary education (not leading directly to an advanced research qualification)" ///
							           8 "6 - Second stage of tertiary education (leading to an advanced research qualification)" 9 "UNK - Level not stated"
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
			label var ilo_edu_aggregate "Education (Aggregate)"
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education attendance ('ilo_edu_attendance') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: 

		gen ilo_edu_attendance=.
			replace ilo_edu_attendance=1 if (AttendingSch=="Yes")               // Attending 
			replace ilo_edu_attendance=2 if (AttendingSch=="No")                // Not attending
			replace ilo_edu_attendance=3 if ilo_edu_attendance==.
				    lab def edu_attendance_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
				    lab val ilo_edu_attendance edu_attendance_lab
				    lab var ilo_edu_attendance "Education (Attendance)"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Disability status ('ilo_dsb') 	[done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment: - Only computed at aggregated level
	
		gen ilo_dsb_aggregate=1
			replace ilo_dsb_aggregate=2 if Diasbility==1	                    // With disability
			replace ilo_dsb_aggregate=1 if ilo_dsb_aggregate==.	                // Without disability
				    label def dsb_lab 1 "Persons without disability" 2 "Persons with disability" 
				    label val ilo_dsb_aggregate dsb_lab
				    label var ilo_dsb_aggregate "Disability status (Aggregate)"

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
* Comment: - Employment comprises people who answered yes to: (a) work for wages or salary, 
*            (b) work for family business, (c) grow food, catch fish or make articles mainly 
*            intended for or barter, (d) grow food, catch fish or make articles mainly for own
*            consumption and (e) community worker.
*          - Unemployment includes people not in employment, seeking for a job and available 
*            to work.
 
	gen ilo_lfs=.
	    replace ilo_lfs=1 if (WorkforWagesa==1 | Workinfamilybusinessb==1 | DM==1 | Growfoodforownused==1 | Unpaidcommunityworkere==1) & ilo_wap==1     // Employed
		replace ilo_lfs=1 if Temporaryabsentfrompaidjob_c==1 & ilo_wap==1                                                                               // Employed: temporary absent
		replace ilo_lfs=2 if ilo_lfs!=1 & Activelylookingforajob==1 & Ifjobsavailablecouldyoustar==1 & ilo_wap==1                                       // Unemployment: not in employment, seeking and available.
		replace ilo_lfs=3 if !inlist(ilo_lfs,1,2) & ilo_wap==1                                                                                          // Outside the labour force
				label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status" 
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - No information available.
				
***********************************************************************************************
*			PART 3.1. ECONOMIC CHARACTERISTICS FOR MAIN JOB 
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Status in employment ('ilo_job1_ste') [done]
* -------------------------------------------------------------------------------------------
* ------------------------------------------------------------------------------------------- 
* Comment: - Interns are classified under employees as they received gross weekly wage.

	* MAIN JOB	
	* Detailed categories
	  gen ilo_job1_ste_icse93=.
		  replace ilo_job1_ste_icse93=1 if inlist(EmploymentStatus_curr_edit,"Salary","Wages", "Intern", "Family/pay") & ilo_lfs==1    // Employees
		  replace ilo_job1_ste_icse93=1 if inlist(EmploymentStatus_cur, "Salary", "Wages", "Family/pay") & ilo_lfs==1                  // Employees
		  replace ilo_job1_ste_icse93=2 if EmploymentStatus_curr_edit=="Employer" & ilo_lfs==1                                         // Employers
		  replace ilo_job1_ste_icse93=2 if EmploymentStatus_cur=="Employer" & ilo_lfs==1                                               // Employers
		  replace ilo_job1_ste_icse93=3 if EmploymentStatus_curr_edit=="Self-employed" & ilo_lfs==1                                    // Own-account workers
		  replace ilo_job1_ste_icse93=3 if EmploymentStatus_cur=="Self-employed" & ilo_lfs==1                                          // Own-account workers
		  replace ilo_job1_ste_icse93=4 if EmploymentStatus_curr_edit=="Community worker" & ilo_lfs==1                                 // Members of producers' cooperatives
		  replace ilo_job1_ste_icse93=4 if EmploymentStatus_cur=="Community worker" & ilo_lfs==1                                       // Members of producers' cooperatives
		  replace ilo_job1_ste_icse93=5 if EmploymentStatus_curr_edit=="Family/no pay" & ilo_lfs==1                                    // Contributing family workers
		  replace ilo_job1_ste_icse93=5 if EmploymentStatus_cur=="Family/no pay" & ilo_lfs==1                                          // Contributing family workers
		  replace ilo_job1_ste_icse93=6 if ilo_job1_ste_icse93==. & ilo_lfs==1                                                         // Not classifiable by status
				  label define label_ilo_ste_icse93 1 "1 - Employees" 2 "2 - Employers" 3 "3 - Own-account workers" 4 "4 - Members of producers' cooperatives" ///
			                                        5 "5 - Contributing family workers" 6 "6 - Workers not classifiable by status"
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

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - The original classification follows ISIC Rev 4 at 5-digit level.
	
	* MAIN JOB:
	gen indu_code_prim=.
	    replace indu_code_prim=int(curr_ind_code/1000)                          // Employed
		replace indu_code_prim=int(ind_327/1000) if indu_code_prim==.           // Employed: temporary absent

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
        lab var ilo_job1_eco_isic4_2digits "Economic activity (ISIC Rev. 4), 2 digits levels - main job"

	* 1-digit level
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
		        lab def eco_isic4 1 "A - Agriculture, forestry and fishing"	2 "B - Mining and quarrying"	3 "C - Manufacturing"	4 "D - Electricity, gas, steam and air conditioning supply" ///
                                  5 "E - Water supply; sewerage, waste management and remediation activities"	6 "F - Construction"	7 "G - Wholesale and retail trade; repair of motor vehicles and motorcycles"	8 "H - Transportation and storage" ///
                                  9 "I - Accommodation and food service activities"	10 "J - Information and communication"	11 "K - Financial and insurance activities"	12 "L - Real estate activities" ///
                                  13 "M - Professional, scientific and technical activities"	14 "N - Administrative and support service activities"	15 "O - Public administration and defence; compulsory social security"	16 "P - Education" ///
                                  17 "Q - Human health and social work activities"	18 "R - Arts, entertainment and recreation"	19 "S - Other service activities"	20 "T - Activities of households as employers; undifferentiated goods- and services-producing activities of households for own use" ///
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

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_ocu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - The original classification follows ISCO-08 at 4 digit-level.


    * MAIN JOB	
	gen occ_code_prim=.
	    replace occ_code_prim=int(curr_occ_code/100)                            // Employed
		replace occ_code_prim=int(occ_326/100) if occ_code_prim==.              // Employed: temporary absent
		* three observations that would go to 01 "commisioned armed forces" but are not doing so after the division -> we force them
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
		lab var ilo_job1_ocu_isco08_2digits "Occupation (ISCO-08), 2 digit level - main job"

    * 1-digit level
	gen ilo_job1_ocu_isco08=.
	    replace ilo_job1_ocu_isco08=11 if ilo_job1_ocu_isco08_2digits==. & ilo_lfs==1             // Not elsewhere classified
		replace ilo_job1_ocu_isco08=int(ilo_job1_ocu_isco08_2digits/10) if ilo_lfs==1             // The rest of the occupations
		replace ilo_job1_ocu_isco08=10 if (ilo_job1_ocu_isco08==0 & ilo_lfs==1)                   // Armed forces
	            lab def ilo_job1_ocu_isco08 1 "1 - Managers"	2 "2 - Professionals"	3 "3 - Technicians and associate professionals"	4 "4 - Clerical support workers"	///
                                            5 "5 - Service and sales workers"	6 "6 - Skilled agricultural, forestry and fishery workers"	7 "7 - Craft and related trades workers"	8 "8 - Plant and machine operators, and assemblers"	///
                                            9 "9 - Elementary occupations"	10 "0 - Armed forces occupations"	11 "X - Not elsewhere classified"
	            lab val ilo_job1_ocu_isco08 ilo_job1_ocu_isco08
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

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_ins_sector') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Public: questions 3.12 (not available) and 3.13 used (filter from 3.12).
*          - The question is not asked to those holding a job from where they are temporary 
*            absent and thus it is assumed that all of them are part of the private sector 
*            unless they work in armed forces.  
	
	* MAIN JOB
	gen ilo_job1_ins_sector=.
		replace ilo_job1_ins_sector=1 if Typeofenterprisebusiness==3 & ilo_lfs==1
		replace ilo_job1_ins_sector=1 if ilo_lfs==1 & (WorkforWagesa==1 | Workinfamilybusinessb==1 | DM==1 | Growfoodforownused==1 | Unpaidcommunityworkere==1) & Typeofenterprisebusiness==.
		replace ilo_job1_ins_sector=1 if ilo_job1_ins_sector==. & ilo_job1_ocu_isco08==10 & ilo_lfs==1
		replace ilo_job1_ins_sector=2 if ilo_job1_ins_sector==. & ilo_lfs==1
                lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
			    lab values ilo_job1_ins_sector ins_sector_lab
			    lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities - main job"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Informal/Formal economy: ('ilo_job1_ife_prod' and 'ilo_job1_ife_nature') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: 
/* Useful questions:
		  * Institutional sector: Typeofenterprisebusiness
		  * Private HH: ilo_job1_eco_isic4_2digits (97) / ilo_job1_ocu_isco08_2digits (63)
		  * Destination of production: Growfoodforownused (mainly for family or own consumption) (not used due to the amount of employed people under this category)
		  * Bookkeeping: Doesthebusinesskeepabookof (not used due to the ambiguity of the question)
		  * Registration: Istheenterprisebusinessregis
		  * Status in employment: ilo_job1_ste_icse93==1 (employees)
		  * Social security contribution: not asked.
		  * Place of work: Inwhattypeofplacedoyouusu (not used because all employed people in block answer to registration)
		  * Size: Howmanypersonsincludingthwo (not used because all employed people in block answer to registration)
		  * Paid annual leave: not asked.
		  * Paid sick leave: not asked.
*/

    * 1) UNIT OF PRODUCTION: FORMAL/INFORMAL SECTOR		
    gen ilo_job1_ife_prod=.
		replace ilo_job1_ife_prod=3 if ilo_lfs==1 & ///
		                               ((ilo_job1_eco_isic4_2digits==97) | ///
									   (ilo_job1_ocu_isco08_2digits==63))
		replace ilo_job1_ife_prod=2 if ilo_lfs==1 & ilo_job1_ife_prod!=3 & ///
		                               ((Typeofenterprisebusiness==3) | ///
									   ((WorkforWagesa==1 | Workinfamilybusinessb==1 | DM==1 | Growfoodforownused==1 | Unpaidcommunityworkere==1) & Typeofenterprisebusiness==.) | ///
									   (Temporaryabsentfrompaidjob_c==1 & ilo_job1_ocu_isco08==10) | ///
									   (Istheenterprisebusinessregis==1))
        replace ilo_job1_ife_prod=1 if ilo_lfs==1 & !inlist(ilo_job1_ife_prod,2,3)  
				lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 
				lab val ilo_job1_ife_prod ilo_ife_prod_lab
				lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"		
						

	* 2) NATURE OF JOB: FORMAL/INFORMAL EMPLOYMENT
    * Not computed due to the lack of information on social security, paid annual leave and/or paid sick leave.

	
***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		
				
* --------------------------------------------------------------------------------------------------
* --------------------------------------------------------------------------------------------------
*		                 Hours of work ('ilo_how') [done]
* --------------------------------------------------------------------------------------------------
* --------------------------------------------------------------------------------------------------
* Comment: - Only asked: hours actually worked in the past 7 days by intervals. Not asked for those
*            temporary absent from work and therefore they are classified under not elsewhere classified.
*          - Since the intervals do not correspond to the exact dissaggregation used here, some notes
*            to values are used.

	* MAIN JOB
	* Hours actually worked in main job
    gen ilo_job1_how_actual_bands=.
	 	*replace ilo_job1_how_actual_bands=1 if 
		replace ilo_job1_how_actual_bands=2 if Approxtotalnumofhoursworked==1 & ilo_lfs==1          // C8:4101_C8:4102
		replace ilo_job1_how_actual_bands=3 if inlist(Approxtotalnumofhoursworked,2,3) & ilo_lfs==1 // C8:4103_C8:3060
		replace ilo_job1_how_actual_bands=4 if Approxtotalnumofhoursworked==4 & ilo_lfs==1          // C8:2848_C8:3061
		*replace ilo_job1_how_actual_bands=5 if 
		replace ilo_job1_how_actual_bands=6 if Approxtotalnumofhoursworked==5 & ilo_lfs==1          // C8:4104_C8:4105
		replace ilo_job1_how_actual_bands=7 if inlist(Approxtotalnumofhoursworked,6,7) & ilo_lfs==1 // C8:4106
		replace ilo_job1_how_actual_bands=8 if ilo_job1_how_actual_bands==. & ilo_lfs==1
		replace ilo_job1_how_actual_bands=. if ilo_lfs!=1
		    	lab def how_act_bands_lab 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"
				lab val ilo_job1_how_actual_bands how_act_bands_lab
				lab var ilo_job1_how_actual_bands "Weekly hours actually worked bands - main job"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job_time') [to check---]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
* Comment: - No information found about the threshold used at national level; however, question
*            3.22 refers to the reasons why the person works less than 40 hours per week and 
*            therefore this value is set.
*          - Those temporary absent from work are classified under unknown.
	
	gen ilo_job1_job_time=.
		replace ilo_job1_job_time=1 if inlist(Approxtotalnumofhoursworked,1,2,3,4) & ilo_lfs==1
		replace ilo_job1_job_time=2 if inlist(Approxtotalnumofhoursworked,5,6,7) & ilo_lfs==1
		replace ilo_job1_job_time=3 if ilo_job1_job_time==. & ilo_lfs==1
        	    lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
			    lab val ilo_job1_job_time job_time_lab
			    lab var ilo_job1_job_time "Job (Working time arrangement)"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job_contract') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
* Comment: - Those temporary absent from work are classified under unknown.
	
	gen ilo_job1_job_contract=.
		replace ilo_job1_job_contract=1 if Contracttype==1 & ilo_job1_ste_aggregate==1
		replace ilo_job1_job_contract=2 if Contracttype==2 & ilo_job1_ste_aggregate==1
		replace ilo_job1_job_contract=3 if ilo_job1_job_contract==. & ilo_job1_ste_aggregate==1
				lab def job_contract_lab 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"
			    lab val ilo_job1_job_contract job_contract_lab
			    lab var ilo_job1_job_contract "Job (Type of contract)"
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Monthly related income ('ilo_job1_lri_ees' and 'ilo_job1_lri_slf')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Original question is asked by intervals (also for those temporary absent from
*            work during the reference week) and thus the value taken is the mid-point of the
*            interval multiplied by (52/12). 
*          - Those temporary absent from work answering category 11 (500+) are classified 
*            as those in the interval 500-599.


	* MAIN JOB
	
	gen gross_income=.
	    replace gross_income=14.5*(52/12) if Grossweeklyincome==1 | FK==1       // [0,29]
		replace gross_income=44.5*(52/12) if Grossweeklyincome==2 | FK==2       // [30-59]
		replace gross_income=74.5*(52/12) if Grossweeklyincome==3 | FK==3       // [60-89]
		replace gross_income=104.5*(52/12) if Grossweeklyincome==4 | FK==4      // [90-119]
		replace gross_income=134.5*(52/12) if Grossweeklyincome==5 | FK==5      // [120-149]
		replace gross_income=174.5*(52/12) if Grossweeklyincome==6 | FK==6      // [150-199]
		replace gross_income=224.5*(52/12) if Grossweeklyincome==7 | FK==7      // [200-249]
		replace gross_income=274.5*(52/12) if Grossweeklyincome==8 | FK==8      // [250-299]
		replace gross_income=349.5*(52/12) if Grossweeklyincome==9 | FK==9      // [300-399]
		replace gross_income=449.5*(52/12) if Grossweeklyincome==10 | FK==10    // [400-499]
		replace gross_income=549.5*(52/12) if Grossweeklyincome==11 | FK==11    // [500-599]
		replace gross_income=649.5*(52/12) if Grossweeklyincome==12             // [600-699]
		replace gross_income=749.5*(52/12) if Grossweeklyincome==13             // [700-799]
		replace gross_income=849.5*(52/12) if Grossweeklyincome==14             // [800-899]
		replace gross_income=949.5*(52/12) if Grossweeklyincome==15             // [900-999]
		replace gross_income=1249.5*(52/12) if Grossweeklyincome==16            // [1000-1499]
		replace gross_income=1749.5*(52/12) if Grossweeklyincome==17            // [1500-1999]
		replace gross_income=2249.5*(52/12) if Grossweeklyincome==18            // [2000-2499]
		replace gross_income=2749.5*(52/12) if Grossweeklyincome==19            // [2500-2999]
		replace gross_income=3000*(52/12) if Grossweeklyincome==20              // [3000+]
		
	
	* Employees
	  gen ilo_job1_lri_ees = .
		  replace ilo_job1_lri_ees = gross_income if ilo_job1_ste_aggregate==1  // Month
		          lab var ilo_job1_lri_ees "Monthly earnings of employees - main job"
				 
	* Self-employed
	  gen ilo_job1_lri_slf = .
	  	  replace ilo_job1_lri_slf = gross_income if ilo_job1_ste_aggregate==2  // Month
	              lab var ilo_job1_lri_slf "Monthly labour related income of self-employed - main job"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_tru') [to check---]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Not enough information to define it. Maybe using: Mainreasontochangeyourcurre
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupational injury ('ilo_joball_inj') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
* Comment: No information available.

*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Days lost due to cases of occupational injury ('ilo_joball_oi_day') [done]
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
* Comment: No information available.

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
* -------------------------------------------------------------------------------------------
* Comments: - Original question refers to the number of weeks seeking for a job.

	gen ilo_dur_details=.
	    replace ilo_dur_details=1 if (Howlongwithoutjob==1 & ilo_lfs==2)                         // Less than 1 month
		replace ilo_dur_details=2 if (inlist(Howlongwithoutjob,2,3) & ilo_lfs==2)                // 1 to 3 months
		replace ilo_dur_details=3 if (inlist(Howlongwithoutjob,4,5,6) & ilo_lfs==2)              // 3 to 6 months
		replace ilo_dur_details=4 if (inlist(Howlongwithoutjob,7,8,9,10,11) & ilo_lfs==2)        // 6 to 12 months (between 24 and 47 weeks)
		replace ilo_dur_details=5 if (Howlongwithoutjob==12 & ilo_lfs==2)                        // 12 to 24 months (between 48 and 95 weeks)
		replace ilo_dur_details=6 if (Howlongwithoutjob==13 & ilo_lfs==2)                        // 24 months or more (96 weeks or more)
		replace ilo_dur_details=7 if (ilo_dur_details==. & ilo_lfs==2)                           // Not elsewhere classified
		        lab def ilo_unemp_det 1 "Less than 1 month" 2 "1 month to less than 3 months" 3 "3 months to less than 6 months" ///
									  4 "6 months to less than 12 months" 5 "12 months to less than 24 months" 6 "24 months or more" ///
									  7 "Not elsewhere classified"
			    lab val ilo_dur_details ilo_unemp_det
			    lab var ilo_dur_details "Duration of unemployment (Details)"
					
	gen ilo_dur_aggregate=.
		replace ilo_dur_aggregate=1 if (inlist(ilo_dur_details,1,2,3) & ilo_lfs==2)   // Less than 6 months
		replace ilo_dur_aggregate=2 if (ilo_dur_details==4 & ilo_lfs==2)              // 6 to 12 months
		replace ilo_dur_aggregate=3 if (inlist(ilo_dur_details,5,6) & ilo_lfs==2)     // 12 months or more
		replace ilo_dur_aggregate=4 if (ilo_dur_details==7 & ilo_lfs==2)              //Not elsewhere classified
		replace ilo_dur_aggregate=. if ilo_lfs!=2
			lab def ilo_unemp_aggr 1 "Less than 6 months" 2 "6 months to less than 12 months" 3 "12 months or more" 4 "Not elsewhere classified"
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
* Comment: - No information available.		

***********************************************************************************************
*			PART 3.3. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Willingness is not asked, and thus options 3 and 4 are not produced.

	gen ilo_olf_dlma=.
		replace ilo_olf_dlma = 1 if (r407==1 & r409a==2 & ilo_lfs==3)		    // Seeking, not available
		replace ilo_olf_dlma = 2 if (r407==2 & r409a==1 & ilo_lfs==3)			// Not seeking, available
		*replace ilo_olf_dlma = 3 if 		                                    // Not seeking, not available, willing
		*replace ilo_olf_dlma = 4 if 		                                    // Not seeking, not available, not willing
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
		replace ilo_olf_reason=1 if inlist(r409,1,2,3,14) & ilo_lfs==3          // Labour market
		replace ilo_olf_reason=2 if inlist(r409,4,5,6,7,18) & ilo_lfs==3        // Other labour market reasons
		replace ilo_olf_reason=3 if inlist(r409,8,9,10,11,12,15) & ilo_lfs==3   // Personal/Family-related
		replace ilo_olf_reason=4 if r409==13 & ilo_lfs==3                       // Does not need/want to work
		replace ilo_olf_reason=5 if ilo_olf_reason==. & ilo_lfs==3              // Not elsewhere classified
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
	    replace ilo_dis=1 if !inlist(ilo_lfs,1,2) & (r409a==1) & (ilo_olf_reason==1)
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
		drop to_drop indu_code_prim indu_code_sec occ_code_prim occ_code_sec social_security
		
		compress 
		
	   /*Save dataset including original and ilo variables*/
	
		save ${country}_${source}_${time}_FULL,  replace		
	
	   /* Save file only containing ilo_* variables*/
	
		keep ilo*

		save ${country}_${source}_${time}_ILO, replace
		
