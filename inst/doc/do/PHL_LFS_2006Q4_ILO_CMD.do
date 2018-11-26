
* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Philippines
* DATASET USED: Philippines LFS 
* NOTES: 
* Files created: Standard variables on LFS Philippines
* Authors: ILO / Department of Statistics / DPAU

* Starting Date: 30 March 2017
* Last updated: 08 February 2018
***********************************************************************************************


*******************************************************************
 /* 1.	Set up work directory, file name, variables and function */
*******************************************************************


clear all 

set more off

global path "J:\DPAU\MICRO"
global country "PHL"
global source "LFS"
global time "2006Q4"
global inputFile "lfsoct06-puf.dta"

global inpath "${path}\\${country}\\${source}\\${time}\ORI"

global outpath "${path}\\${country}\\${source}\\${time}"


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
	
	capture rename puf* *
	
	
	destring *, replace
	
*********************************************************************************************

* Create help variables for the time period considered
	
	gen time = "${time}"
	split time, gen(time_) parse(Q)
	rename (time_1 time_2) (year quarter)
	destring year quarter, replace
	
* Don't define ilo_* variables for overseas workers and people employed in Filipino embassies and consulates
	capture gen  ILO_EXCLUDE = c10_cnwr  
	capture gen  ILO_EXCLUDE = c10_conwr
	capture gen  ILO_EXCLUDE = cc10_conwr
	capture gen  ILO_EXCLUDE = c11_conwr
	gen considered=1 if !inlist(ILO_EXCLUDE,1,3)	

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
*			Identifier ('ilo_key') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*		

	gen ilo_key=_n
		lab var ilo_key "Key unique identifier per individual"
	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sample Weight ('ilo_wgt') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*		
* Comment: 
	
	capture gen  ilo_WEIGTH = pwgt
	capture gen  ilo_WEIGTH  = cfwgt
	capture gen  ilo_WEIGTH = fwgt
	
	gen ilo_wgt=ilo_WEIGTH		
		lab var ilo_wgt "Sample weight"
		
		if time=="2016Q3" {
		
		replace ilo_wgt=ilo_wgt/10000
		
		}
	drop ilo_WEIGTH 
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time period ('ilo_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*

	gen ilo_time=1
		lab def time_lab 1 "${time}"
		lab val ilo_time time_lab
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
/*
	capture gen  ilo_URB2 = urb2k70
	capture gen  ilo_URB2  = urb2k
	
		gen ilo_geo=ilo_URB2
			lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural"
			lab val ilo_geo ilo_geo_lab
			lab var ilo_geo "Geographical coverage"
	
	drop ilo_URB2 
*/
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: 
	capture gen ilo_SEX = c06_sex 
	capture gen ilo_SEX = cc06_sex
	capture gen	ilo_SEX = c04_sex
	
		gen ilo_sex=ilo_SEX
			label define label_Sex 1 "1 - Male" 2 "2 - Female"
			label values ilo_sex label_Sex
			lab var ilo_sex "Sex"
	drop ilo_SEX
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: 
	capture gen ilo_AGE = c07_age 
	capture gen ilo_AGE = cc07_age
	capture gen	ilo_AGE = c05_age

	gen ilo_age=ilo_AGE
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
			
		* as only age bands being kept drop "ilo_age" at the very end -> use it in between as help variable
	drop ilo_AGE
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Level of education ('ilo_edu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: Note that according to the definition, the highest level being CONCLUDED is being considered

/*
	gen ilo_edu_isced97=.
		replace ilo_edu_isced97=1 if c07_grade==0
		replace ilo_edu_isced97=2 if inrange(c07_grade,1
		replace ilo_edu_isced97=3 if 
		replace ilo_edu_isced97=4 if 
		replace ilo_edu_isced97=5 if 
		replace ilo_edu_isced97=6 if 
		replace ilo_edu_isced97=7 if 
		replace ilo_edu_isced97=8 if 
		replace ilo_edu_isced97=9 if ilo_edu_isced97==.
			label def isced_97_lab 1 "X - No schooling" 2 "0 - Pre-primary education" 3 "1 - Primary education or first stage of basic education" 4 "2 - Lower secondary education or second stage of basic education" ///
							5 "3 - Upper secondary education" 6 "4 - Post-secondary non-tertiary education" 7 "5 - First stage of tertiary education (not leading directly to an advanced research qualification)" ///
							8 "6 - Second stage of tertiary education (leading to an advanced research qualification)" 9 "UNK - Level not stated"
			label val ilo_edu_isced97 isced_97_lab
			lab var ilo_edu_isced97 "Level of education (ISCED 97)"


		* for the definition, cf. the document "Guide to reporting labour statistics to the ILO using the Excel questionnaire"
		
	gen ilo_edu_aggregate=.
		replace ilo_edu_aggregate=1 if inlist(ilo_edu_isced97,1,2)
		replace ilo_edu_aggregate=2 if inlist(ilo_edu_isced97,3,4)
		replace ilo_edu_aggregate=3 if inlist(ilo_edu_isced97,5,6)
		replace ilo_edu_aggregate=4 if inlist(ilo_edu_isced97,7,8)
		replace ilo_edu_aggregate=5 if ilo_edu_isced97==9
			label def edu_aggr_lab 1 "1 - Less than basic" 2 "2 - Basic" 3 "3 - Intermediate" 4 "4 - Advanced" 5 "5 - Level not stated"
			label val ilo_edu_aggregate edu_aggr_lab
			label var ilo_edu_aggregate "Level of education (Aggregate levels)"
			
			*/
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education attendance ('ilo_edu_attendance') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: 

		capture gen ilo_SCHOOL_STATUS = a02_csch
		capture gen ilo_SCHOOL_STATUS = acursch 
		capture gen	ilo_SCHOOL_STATUS = c08_cursch
		capture gen	ilo_SCHOOL_STATUS = c10_cursch
		
		
		gen ilo_edu_attendance=ilo_SCHOOL_STATUS		
			replace ilo_edu_attendance=3 if ilo_edu_attendance==.
				lab def edu_attendance_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
				lab val ilo_edu_attendance edu_attendance_lab
				lab var ilo_edu_attendance "Education (Attendance)" 
		drop ilo_SCHOOL_STATUS
	
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			           Marital status ('ilo_mrts') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 

if time <= "2005Q4"{
	gen marital = c08_mstat
}	


if time >= "2006Q1"{
	gen marital = cc08_mstat
}	

	* Detailed
	gen ilo_mrts_details=.
	    replace ilo_mrts_details=1 if marital==1                              // Single
		replace ilo_mrts_details=2 if marital==2                              // Married
		*replace ilo_mrts_details=3 if                                          // Union / cohabiting
		replace ilo_mrts_details=4 if marital==3                              // Widowed
		replace ilo_mrts_details=5 if marital==4                              // Divorced / separated
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
			
drop marital			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Disability status ('ilo_dsb_details') [no info available]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment: 

	/*  gen ilo_dsb_details=.
			
		gen ilo_dsb_aggregate=.
	*/
	
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
*           
* Comment: 	

	gen ilo_wap=.
		replace ilo_wap=1 if ilo_age>=15 & ilo_age!=.
			label def ilo_wap_lab 1 "Working age population"
			label val ilo_wap ilo_wap_lab
			label var ilo_wap "Working age population" //15+ population

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Labour Force Status ('ilo_lfs') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*            	 
* Comment: compare our numbers with variable "newempstat" (other variable considering labour force status, "cempst1", does not take into 
				* consideration the availability criterion) // Category 1 (Employed) coincides perfectly with predefined variable
				* Unemployment does not coincide, higher discrepancy observed when compared to variable not taking into account availability criterion
				
				* NSO exlcudes overseas worker (whatever is inlist(c10_conwr,1,2,3) ) -- given that there is no info about them (and they fall into category "outside 
							* the labour force) -> check whether to keep them or not
	capture gen ilo_WORK = c13_work 
	capture gen ilo_WORK = cc13_work 
	capture gen ilo_WORK = c12_work
	capture gen	ilo_WORK = c11_work
	capture gen ilo_JOB = c14_job 
	capture gen ilo_JOB = cc14_job 
	capture gen	ilo_JOB = c12_job
	capture gen	ilo_JOB = c13_job
	capture gen ilo_LOOK_FOR_WORK = c30_lookw 
	capture gen ilo_LOOK_FOR_WORK = c38_lokw  
	capture gen ilo_LOOK_FOR_WORK = cc38_lookw
	capture gen ilo_LOOK_FOR_WORK = c31_lookw
	capture gen ilo_AVAILABLE_FOR_WORK = c36_avail 
	capture gen ilo_AVAILABLE_FOR_WORK = c37_avil 
	capture gen ilo_AVAILABLE_FOR_WORK = cc37_avail
	capture gen ilo_AVAILABLE_FOR_WORK = c37_avail
	capture gen ilo_WYNOT = c34_wynot 
	capture gen ilo_WYNOT = c42_wynt 
	capture gen ilo_WYNOT = cc42_wynot
	capture gen ilo_WYNOT = c35_wynot

	
	gen ilo_lfs=.
		replace ilo_lfs=1 if ilo_WORK==1 | ilo_JOB==1
		replace ilo_lfs=2 if ilo_lfs!=1 & ilo_LOOK_FOR_WORK ==1 & ilo_AVAILABLE_FOR_WORK==1
		replace ilo_lfs=3 if !inlist(ilo_lfs,1,2)
			replace ilo_lfs=. if ilo_wap!=1	
				label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status" 
				
				
	* Reconstruct "newempstat" variable- refer to technical note in report for 2013Q4 (October 2013)

	
		gen nat_lfs=.
			replace nat_lfs=1 if ilo_WORK==1 | ilo_JOB==1
			replace nat_lfs=2 if nat_lfs!=1 & ilo_AVAILABLE_FOR_WORK==1 & (ilo_LOOK_FOR_WORK ==1 | inlist(ilo_WYNOT,1,2,3,4,5))
			replace nat_lfs=3 if !inlist(nat_lfs,1,2) & !inlist(ILO_EXCLUDE,1,2,3)
					replace nat_lfs=. if ilo_wap!=1
				*take value label from ilo_lfs
				lab value nat_lfs label_ilo_lfs
				label var nat_lfs "National criteria - Labour Force Status"
				
				* ILO_EXCLUDE allows to exclude overseas workers, workers other than overseas workers and employees in Phil. embassies and consulates
				
				* nat_lfs coincides perfectly with "newempstat" and allows to reproduce numbers in national report (numbers compared for 2016Q4)
	
	drop 	ilo_WORK ilo_JOB ilo_LOOK_FOR_WORK	
											
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: 
	capture gen ilo_OJOB = c28_ojob 
	capture gen ilo_OJOB = c26_ojob  
	capture gen ilo_OJOB = cc28_ojob
	capture gen ilo_OJOB = c27_ojob
	
	gen ilo_mjh=.
		replace ilo_mjh=1 if ilo_OJOB==2
		replace ilo_mjh=2 if ilo_OJOB==1
		replace ilo_mjh=. if ilo_lfs!=1
			lab def lab_ilo_mjh 1 "1 - One job only" 2 "2 - More than one job"
			lab val ilo_mjh lab_ilo_mjh
			lab var ilo_mjh "Multiple job holders"		
	drop ilo_OJOB		

***********************************************************************************************
*			PART 3.1. ECONOMIC CHARACTERISTICS FOR MAIN JOB 
***********************************************************************************************	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Status in employment ('ilo_ste') [done] 
* -------------------------------------------------------------------------------------------
* ------------------------------------------------------------------------------------------- 
*
* Comment: 


	* Primary activity
	capture gen ilo_PCLASS = c23_pclass 
	capture gen ilo_PCLASS = c19pclas  
	capture gen ilo_PCLASS = cc19_pclass
	capture gen ilo_PCLASS = c24_pclass
	
		gen ilo_job1_ste_icse93=.
			replace ilo_job1_ste_icse93=1 if inlist(ilo_PCLASS,0,1,2)
			replace ilo_job1_ste_icse93=2 if ilo_PCLASS==4
			replace ilo_job1_ste_icse93=3 if ilo_PCLASS==3
			/* replace ilo_job1_ste_icse93=4 if */
			replace ilo_job1_ste_icse93=5 if inlist(ilo_PCLASS,5,6)
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
			replace ilo_job1_ste_aggregate=3 if inlist(ilo_job1_ste_icse93,6)
				lab def ste_aggr_lab 1 "1 - Employees" 2 "2 - Self-employed" 3 "3 - Not elsewhere classified"
				lab val ilo_job1_ste_aggregate ste_aggr_lab
			label var ilo_job1_ste_aggregate "Status in employment (Aggregate)"

	  * Secondary activity - variable j04_oclass has no observations --> can't be defined	  
	
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: ISIC Rev. 4 being used after (and including) 2012Q3

	* Import value labels


		capture gen ilo_PKB = c16_pkb 
		capture gen ilo_PKB = c17f2_pkb
		capture gen ilo_PKB = c18_pkb  
		capture gen ilo_PKB = cc18_pkb
	
		gen indu_code_prim=int(ilo_PKB) if ilo_lfs==1 
			
		* Primary activity
		
		gen ilo_job1_eco_isic4_2digits=indu_code_prim
			lab def eco_isic4_2digits_lab 1 "01 - Crop and animal production, hunting and related service activities" 2 "02 - Forestry and logging" 3 "03 - Fishing and aquaculture" 5 "05 - Mining of coal and lignite" /// 
							6 "06 - Extraction of crude petroleum and natural gas" 7 "07 - Mining of metal ores" 8 "08 - Other mining and quarrying" 9 "09 - Mining support service activities" /// 
							10 "10 - Manufacture of food products" 11 "11 - Manufacture of beverages" 12 "12 - Manufacture of tobacco products" 13 "13 - Manufacture of textiles" 14 "14 - Manufacture of wearing apparel" /// 
							15 "15 - Manufacture of leather and related products" 16 "16 - Manufacture of wood and of products of wood and cork, except furniture; manufacture of articles of straw and plaiting materials" /// 
							17 "17 - Manufacture of paper and paper products" 18 "18 - Printing and reproduction of recorded media" 19 "19 - Manufacture of coke and refined petroleum products" /// 
							20 "20 - Manufacture of chemicals and chemical products" 21 "21 - Manufacture of basic pharmaceutical products and pharmaceutical preparations" 22 "22 - Manufacture of rubber and plastics products" /// 
							23 "23 - Manufacture of other non-metallic mineral products" 24 "24 - Manufacture of basic metals" 25 "25 - Manufacture of fabricated metal products, except machinery and equipment" /// 
							26 "26 - Manufacture of computer, electronic and optical products" 27 "27 - Manufacture of electrical equipment" 28 "28 - Manufacture of machinery and equipment n.e.c." /// 
							29 "29 - Manufacture of motor vehicles, trailers and semi-trailers" 30 "30 - Manufacture of other transport equipment" 31 "31 - Manufacture of furniture" 32 "32 - Other manufacturing" /// 
							33 "33 - Repair and installation of machinery and equipment" 35 "35 - Electricity, gas, steam and air conditioning supply" 36 "36 - Water collection, treatment and supply" 37 "37 - Sewerage" /// 
							38 "38 - Waste collection, treatment and disposal activities; materials recovery" 39 "39 - Remediation activities and other waste management services" 41 "41 - Construction of buildings" /// 
							42 "42 - Civil engineering" 43 "43 - Specialized construction activities" 45 "45 - Wholesale and retail trade and repair of motor vehicles and motorcycles" /// 
							46 "46 - Wholesale trade, except of motor vehicles and motorcycles" 47 "47 - Retail trade, except of motor vehicles and motorcycles" 49 "49 - Land transport and transport via pipelines" /// 
							50 "50 - Water transport" 51 "51 - Air transport" 52 "52 - Warehousing and support activities for transportation" 53 "53 - Postal and courier activities" 55 "55 - Accommodation" /// 
							56 "56 - Food and beverage service activities" 58 "58 - Publishing activities" 59 "59 - Motion picture, video and television programme production, sound recording and music publishing activities" /// 
							60 "60 - Programming and broadcasting activities" 61 "61 - Telecommunications" 62 "62 - Computer programming, consultancy and related activities" 63 "63 - Information service activities" /// 
							64 "64 - Financial service activities, except insurance and pension funding" 65 "65 - Insurance, reinsurance and pension funding, except compulsory social security" /// 
							66 "66 - Activities auxiliary to financial service and insurance activities" 68 "68 - Real estate activities" 69 "69 - Legal and accounting activities" /// 
							70 "70 - Activities of head offices; management consultancy activities" 71 "71 - Architectural and engineering activities; technical testing and analysis" 72 "72 - Scientific research and development" /// 
							73 "73 - Advertising and market research" 74 "74 - Other professional, scientific and technical activities" 75 "75 - Veterinary activities" 77 "77 - Rental and leasing activities" 78 "78 - Employment activities" /// 
							79 "79 - Travel agency, tour operator, reservation service and related activities" 80 "80 - Security and investigation activities" 81 "81 - Services to buildings and landscape activities" /// 
							82 "82 - Office administrative, office support and other business support activities" 84 "84 - Public administration and defence; compulsory social security" 85 "85 - Education" /// 
							86 "86 - Human health activities" 87 "87 - Residential care activities" 88 "88 - Social work activities without accommodation" 90 "90 - Creative, arts and entertainment activities" /// 
							91 "91 - Libraries, archives, museums and other cultural activities" 92 "92 - Gambling and betting activities" 93 "93 - Sports activities and amusement and recreation activities" /// 
							94 "94 - Activities of membership organizations" 95 "95 - Repair of computers and personal and household goods" 96 "96 - Other personal service activities" /// 
							97 "97 - Activities of households as employers of domestic personnel" 98 "98 - Undifferentiated goods- and services-producing activities of private households for own use" /// 
							99 "99 - Activities of extraterritorial organizations and bodies"
			lab val ilo_job1_eco_isic4_2digits eco_isic4_2digits_lab
			lab var ilo_job1_eco_isic4_2digits "Economic activity (ISIC Rev. 4), 2 digit level"
			
	
	* One digit level
	
		* aggregation done according to information on page 43 of the following document: https://unstats.un.org/unsd/publication/seriesM/seriesm_4rev4e.pdf
		
		* Primary activity
		
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
					replace ilo_job1_eco_isic4=. if ilo_lfs!=1
				lab def eco_isic4_lab 1 "A - Agriculture, forestry and fishing" 2 "B - Mining and quarrying" 3 "C - Manufacturing" 4 "D - Electricity, gas, steam and air conditioning supply" /// 
								5 "E - Water supply; sewerage, waste management and remediation activities" 6 "F - Construction" 7 "G - Wholesale and retail trade; repair of motor vehicles and motorcycles" /// 
								8 "H - Transportation and storage" 9 "I - Accommodation and food service activities" 10 "J - Information and communication" 11 "K - Financial and insurance activities" /// 
								12 "L - Real estate activities" 13 "M - Professional, scientific and technical activities" 14 "N - Administrative and support service activities" /// 
								15 "O - Public administration and defence; compulsory social security" 16 "P - Education" 17 "Q - Human health and social work activities" 18 "R - Arts, entertainment and recreation" /// 
								19 "S - Other service activities" 20 "T - Activities of households as employers; undifferentiated goods- and services-producing activities of households for own use" /// 
								21 "U - Activities of extraterritorial organizations and bodies" 22 "X - Not elsewhere classified"
				lab val ilo_job1_eco_isic4 eco_isic4_lab
				lab var ilo_job1_eco_isic4 "Economic activity (ISIC Rev. 4)"
				

	* Now do the classification on an aggregate level
	
		* Primary activity
		
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
				lab var ilo_job1_eco_aggregate "Economic activity (Aggregate)"
		drop ilo_PKB
	
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_ocu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: 
	
		capture gen ilo_PROC = c14_procc 
		capture gen ilo_PROC = c15f2_procc
		capture gen ilo_PROC = cc16_procc
		capture gen ilo_PROC = c16_proc  
	
		gen occ_code_prim=ilo_PROC if ilo_lfs==1 
		
	* 2 digit level

		* Primary occupation
		
		gen ilo_job1_ocu_isco08_2digits=occ_code_prim
			lab def ocu_isco08_2digits_lab 1 "01 - Commissioned armed forces officers" 2 "02 - Non-commissioned armed forces officers" 3 "03 - Armed forces occupations, other ranks" /// 
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
			lab val ilo_job1_ocu_isco08_2digits ocu_isco08_2digits_lab
			lab var ilo_job1_ocu_isco08_2digits "Occupation (ISCO-08), 2 digit level"
			
		* 1 digit level
	
	gen occ_code_prim_1dig=int(occ_code_prim/10) if ilo_lfs==1
	
		* Primary activity
		
		gen ilo_job1_ocu_isco08=occ_code_prim_1dig
			replace ilo_job1_ocu_isco08=10 if ilo_job1_ocu_isco08==0
			replace ilo_job1_ocu_isco08=11 if ilo_job1_ocu_isco08==. & ilo_lfs==1
			lab def isco08_1dig_lab 1 "1 - Managers" 2 "2 - Professionals" 3 "Technicians and associate professionals" 4 "4 - Clerical support workers" 5 "5 - Service and sales workers" ///
									6 "6 - Skilled agricultural, forestry and fishery workers" 7 "7 - Craft and related trades workers" 8 "8 - Plant and machine operators, and assemblers" ///
									9 "9 - Elementary occupations" 10 "0 - Armed forces occupations" 11 "X - Not elsewhere classified"
			lab val ilo_job1_ocu_isco08 isco08_1dig_lab
			lab var ilo_job1_ocu_isco08 "Occupation (ISCO-08)"	
		
			
	* Aggregate level
	
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
			
		drop ilo_PROC	
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_ins_sector') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
		
* Comment: 
	
	* Primary occupation
	
	gen ilo_job1_ins_sector=.
		replace ilo_job1_ins_sector=1 if ilo_PCLASS==2
		replace ilo_job1_ins_sector=2 if ilo_job1_ins_sector==. & ilo_lfs==1
				replace ilo_job1_ins_sector=. if ilo_lfs!=1
			lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
			lab values ilo_job1_ins_sector ins_sector_lab
			lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities"
	drop ilo_PCLASS
* --------------------------------------------------------------------------------------------------
* --------------------------------------------------------------------------------------------------
*		Weekly hours actually (USUALLY) worked ('ilo_how_actual') and ('ilo_how_usual') [done]
* --------------------------------------------------------------------------------------------------
* --------------------------------------------------------------------------------------------------
* 
* Comment: variable considering working hours for secondary activity does not include observations in every dataset...
			* but variable considering hours spent in all jobs does not fully overlap with values for actual hours
			* worked in first job -> consider both variables
			
		capture gen ilo_PHOURS = c19_phours 
		capture gen ilo_PHOURS = c19_pnwhrs
		capture gen ilo_PHOURS = c22_phrs  
		capture gen ilo_PHOURS = cc22_phours  
		capture gen ilo_THOURS = c28_thours 
		capture gen ilo_THOURS = a04_thrs  
		capture gen ilo_THOURS = athours
		capture gen ilo_THOURS = c29_thours
				
	* Actual hours worked 
	
		* Primary job
		
		gen ilo_job1_how_actual=ilo_PHOURS			
			replace ilo_job1_how_actual=. if ilo_lfs!=1
			lab var ilo_job1_how_actual "Weekly hours actually worked in main job"
		
		* All jobs
		
	
		gen ilo_joball_how_actual=ilo_THOURS				
			replace ilo_joball_how_actual=. if ilo_lfs!=1
			lab var ilo_joball_how_actual "Weekly hours actually worked in all jobs"
	
		
	* Hours usually worked 
		* no info	
		
	*Weekly hours actually worked --> bands 
			
		* Primary job
		
		gen ilo_job1_how_actual_bands=.
			replace ilo_job1_how_actual_bands=1 if ilo_job1_how_actual==0
			replace ilo_job1_how_actual_bands=2 if ilo_job1_how_actual>=1 & ilo_job1_how_actual<=14
			replace ilo_job1_how_actual_bands=3 if ilo_job1_how_actual>=15 & ilo_job1_how_actual<=29
			replace ilo_job1_how_actual_bands=4 if ilo_job1_how_actual>=30 & ilo_job1_how_actual<=34
			replace ilo_job1_how_actual_bands=5 if ilo_job1_how_actual>=35 & ilo_job1_how_actual<=39
			replace ilo_job1_how_actual_bands=6 if ilo_job1_how_actual>=40 & ilo_job1_how_actual<=48
			replace ilo_job1_how_actual_bands=7 if ilo_job1_how_actual>=49 & ilo_job1_how_actual!=.
			replace ilo_job1_how_actual_bands=8 if ilo_lfs==1 & ilo_job1_how_actual_bands==.
				lab def how_bands_lab 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"
				lab values ilo_job1_how_actual_bands how_bands_lab
				lab var ilo_job1_how_actual_bands "Weekly hours actually worked bands in main job"
		
		* All jobs
		
		gen ilo_joball_how_actual_bands=.
			replace ilo_joball_how_actual_bands=1 if ilo_joball_how_actual==0
			replace ilo_joball_how_actual_bands=2 if ilo_joball_how_actual>=1 & ilo_joball_how_actual<=14
			replace ilo_joball_how_actual_bands=3 if ilo_joball_how_actual>=15 & ilo_joball_how_actual<=29
			replace ilo_joball_how_actual_bands=4 if ilo_joball_how_actual>=30 & ilo_joball_how_actual<=34
			replace ilo_joball_how_actual_bands=5 if ilo_joball_how_actual>=35 & ilo_joball_how_actual<=39
			replace ilo_joball_how_actual_bands=6 if ilo_joball_how_actual>=40 & ilo_joball_how_actual<=48
			replace ilo_joball_how_actual_bands=7 if ilo_joball_how_actual>=49 & ilo_joball_how_actual!=.
			replace ilo_joball_how_actual_bands=8 if ilo_lfs==1 & ilo_joball_how_actual_bands==.
				* value label already defined 
				lab values ilo_joball_how_actual_bands how_bands_lab
				lab var ilo_joball_how_actual_bands "Weekly hours actually worked bands in all jobs"
		drop ilo_PHOURS ilo_THOURS
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment: set threshold at 40 hours per week (cf. pg. 37 of following document: https://www.dole.gov.ph/files/Department-Advisory-No_1-2015_Labor-Code-of-the-Philippines-Renumbered.pdf ) 
			* and use actual hours worked instead of usual hours, given unavailability of any information about usual hours worked 

		gen ilo_job1_job_time=.
			replace ilo_job1_job_time=1 if ilo_job1_how_actual<40
			replace ilo_job1_job_time=2 if ilo_job1_how_actual>=40 
			replace ilo_job1_job_time=3 if ilo_job1_job_time==. & ilo_lfs==1
					replace ilo_job1_job_time=. if ilo_lfs!=1
				lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
				lab val ilo_job1_job_time job_time_lab
				lab var ilo_job1_job_time "Job (Working time arrangement)"	
			
			* if there is any secondary employment, by definition it is part-time, and therefore
			* variable for secondary employment not being defined
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job_contract') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment:
		
		capture gen ilo_NATEM = c17_natem 
		capture gen ilo_NATEM = c20_ntem 
		capture gen ilo_NATEM = cc20_natem
		capture gen ilo_NATEM = c18_natem
		
		
		gen ilo_job1_job_contract=ilo_NATEM
			replace ilo_job1_job_contract=3 if ilo_job1_job_contract==. & ilo_job1_ste_aggregate==1
					replace ilo_job1_job_contract=. if ilo_lfs!=1
				lab def job_contract_lab 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"
				lab val ilo_job1_job_contract job_contract_lab
				lab var ilo_job1_job_contract "Job (Type of contract)"
		drop ilo_NATEM	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Informal/Formal economy: Unit of production (ilo_job1_ife_prod) [don't define]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* 
* Comment: 
	
	* Useful questions: c23_pclass: Institutional sector
					* [no info]: Destination of production (use question used for identification of people in labour force)
					* [no info]: Bookkeeping
					* [no info]: Registration
					* [no info]: Social security
					* [no info]: Location of workplace
					* [no info]: Size of enterprise
											
					
	* gen ilo_job1_ife_prod=.
		
					
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Informal/formal economy: nature of job (ilo_job1_ife_nature) [don't define]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: 

	* gen ilo_job1_ife_nature=.
		
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Earnings ('ilo_ear_ees' and 'ilo_ear_slf')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	
* Comment:
	
	* Currency in the Philippines: Philippine peso

		capture gen ilo_PBASIC = c25_pbasic 
		capture gen ilo_PBASIC = c26_pbis  	
		capture gen ilo_PBASIC = cc27_pbasic
		capture gen ilo_PBASIC = c26_pbasic
	* Primary employment 
	
			* Monthly earnings of employees
			
				* basic pay per day indicated						

		gen ilo_job1_lri_ees=ilo_PBASIC*(365/12)
			replace ilo_job1_lri_ees=. if ilo_lfs!=1 | ilo_job1_lri_ees<0
			lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"

			* Self employment - no info
		
		* note that the revenue related to self-employment includes also the value of own consumption 
			* (cf. resolution from 1998)
			
		*gen ilo_job1_lri_slf=
			*replace ilo_job1_lri_slf=. if ilo_lfs!=1
			*lab var ilo_job1_lri_slf "Monthly labour related income of self-employed in main job"
	 drop ilo_PBASIC
	
	
***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************			

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_tru') [don't define]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*                
* Comment: no question on availability

	* gen ilo_joball_tru=1 if ilo_job1_job_time==1 
			
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Cases of non-fatal occupational injury ('ilo_joball_oi_case') [not available]
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*
* Comment: no info available

	* gen ilo_joball_oi_case=	

*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Days lost due to cases of occupational injury ('ilo_joball_oi_day') [not available]
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*
* Comment: no info available

	* gen ilo_joball_oi_day=	
	
***********************************************************************************************
*			PART 3.3. UNEMPLOYMENT: ECONOMIC CHARACTERISTICS
***********************************************************************************************	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment:	Question asks how much time ther person has spent looking for another job

			* note that highest value appearing is 98 weeks, which is less than 24 months - therefore no observations for the category "24 months or more" for 
				* the more detailed classification
		capture gen ilo_WEEKS = c33_weeks 
		capture gen ilo_WEEKS = c40_wks  
		capture gen ilo_WEEKS = cc40_weeks
		capture gen ilo_WEEKS = c34_weeks
		
	gen ilo_dur_details=.
		replace ilo_dur_details=1 if inrange(ilo_WEEKS,1,3)
		replace ilo_dur_details=2 if inrange(ilo_WEEKS,4,12)
		replace ilo_dur_details=3 if inrange(ilo_WEEKS,13,25)
		replace ilo_dur_details=4 if inrange(ilo_WEEKS,26,51)
		replace ilo_dur_details=5 if inrange(ilo_WEEKS,52,103)
		replace ilo_dur_details=6 if ilo_WEEKS>103 & ilo_WEEKS!=.
		replace ilo_dur_details=7 if ilo_dur_details==. & ilo_lfs==2
				replace ilo_dur_details=. if ilo_lfs!=2
			lab def ilo_unemp_det 1 "Less than 1 month" 2 "1 month to less than 3 months" 3 "3 months to less than 6 months" 4 "6 months to less than 12 months" 5 "12 months to less than 24 months" ///
									6 "24 months or more" 7 "Not elsewhere classified"
			lab values ilo_dur_details ilo_unemp_det
			lab var ilo_dur_details "Duration of unemployment (Details)" 
			
	* in order to avoid putting any notes and as the exact duration is not precised if person seeking for a job for 52 weeks, take only the aggregate version
			
			
	gen ilo_dur_aggregate=.
		replace ilo_dur_aggregate=1 if inlist(ilo_dur_details,1,2,3)
		replace ilo_dur_aggregate=2 if ilo_dur_details==4
		replace ilo_dur_aggregate=3 if inlist(ilo_dur_details,5,6)
		replace ilo_dur_aggregate=4 if ilo_dur_details==7
			lab def ilo_unemp_aggr 1 "Less than 6 months" 2 "6 months to less than 12 months" 3 "12 months or more" 4 "Not elsewhere classified"
			lab val ilo_dur_aggregate ilo_unemp_aggr
			lab var ilo_dur_aggregate "Duration of unemployment (Aggregate)"
	drop ilo_WEEKS		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Category of unemployment ('ilo_cat_une') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment:

		capture gen ilo_FLWK = c41_flwk 
		capture gen ilo_FLWK = c31_flwrk 
		capture gen ilo_FLWK = c32_flwrk
		capture gen ilo_FLWK = cc41_flwrk
		
	gen ilo_cat_une=.
		replace ilo_cat_une=1 if ilo_FLWK==1
		replace ilo_cat_une=2 if ilo_FLWK==2
		replace ilo_cat_une=3 if ilo_cat_une==. & ilo_lfs==2
				replace ilo_cat_une=. if ilo_lfs!=2
			lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
			lab val ilo_cat_une cat_une_lab
			lab var ilo_cat_une "Category of unemployment"
	drop ilo_FLWK		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4') [not being defined]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: no info about previous economic activity
			
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu_isco08') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			
* Comment: use ISCO-08 classification (for periods after and including 2012Q3 )
			* before that national classification used --> find mapping
		
		capture gen ilo_POCC = c40_pocc 
		capture gen ilo_POCC = c45_pocc 
		capture gen ilo_POCC = cc45_pocc
		capture gen ilo_POCC = c41f2_pocc
		
	
		gen prevocu_cod=int(ilo_POCC/10) if ilo_lfs==2
			
	
	gen ilo_prevocu_isco08=prevocu_cod
		replace ilo_prevocu_isco08=10 if ilo_prevocu_isco08==0
		replace ilo_prevocu_isco08=11 if ilo_prevocu_isco08==. & ilo_cat_une==1 & ilo_lfs==2
		* value label already defined
		lab val ilo_prevocu_isco08 isco08_1dig_lab
		lab var ilo_prevocu_isco08 "Occupation (ISCO-08)"
			
	* Aggregate level 
	
	gen ilo_prevocu_aggregate=.
		replace ilo_prevocu_aggregate=1 if inrange(ilo_prevocu_isco08,1,3)
		replace ilo_prevocu_aggregate=2 if inlist(ilo_prevocu_isco08,4,5)
		replace ilo_prevocu_aggregate=3 if inlist(ilo_prevocu_isco08,6,7)
		replace ilo_prevocu_aggregate=4 if ilo_prevocu_isco08==8
		replace ilo_prevocu_aggregate=5 if ilo_prevocu_isco08==9
		replace ilo_prevocu_aggregate=6 if ilo_prevocu_isco08==10
		replace ilo_prevocu_aggregate=7 if ilo_prevocu_isco08==11
			* value label already defined
			lab val ilo_prevocu_aggregate ocu_aggr_lab
			lab var ilo_prevocu_aggregate "Previous occupation (Aggregate)"	
			
	* Skill level
	
		gen ilo_prevocu_skill=.
			replace ilo_prevocu_skill=1 if ilo_prevocu_isco08==9
			replace ilo_prevocu_skill=2 if inlist(ilo_prevocu_isco08,4,5,6,7,8)
			replace ilo_prevocu_skill=3 if inlist(ilo_prevocu_isco08,1,2,3)
			replace ilo_prevocu_skill=4 if inlist(ilo_prevocu_isco08,10,11)
				* value label already defined
				lab val ilo_prevocu_skill ocu_skill_lab
				lab var ilo_prevocu_skill "Occupation (Skill level)"
	drop ilo_POCC
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Unemployment benefits schemes ('ilo_soc_aggregate') [no info available]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment:

***********************************************************************************************
*			PART 3.4. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: Degree of labour market attachment of persons outside the labour force

		* very high share falling into category "not elsewhere classified" --> don't keep variable

	/*
	gen ilo_olf_dlma=.
		replace ilo_olf_dlma=1 if c30_lookw==1 & c36_avail==2
		replace ilo_olf_dlma=2 if c30_lookw==2 & c36_avail==1
		replace ilo_olf_dlma=3 if c30_lookw==2 & c36_avail==2 & a07_willing==1
		replace ilo_olf_dlma=4 if c30_lookw==2 & c36_avail==2 & a07_willing==2
		replace ilo_olf_dlma=5 if ilo_olf_dlma==. & ilo_lfs==3
				replace ilo_olf_dlma=. if ilo_lfs!=3
			lab def lab_olf_dlma 1 "1 - Seeking, not available (Unavailable jobseekers)" 2 "2 - Not seeking, available (Available potential jobseekers)" ///
						3 "3 - Not seeking, not available, willing (Willing non-jobseekers)" 4 "4 - Not seeking, not available, not willing" 5 "5 - Not elsewhere classified"
			lab val ilo_olf_dlma lab_olf_dlma
			lab var ilo_olf_dlma "Labour market attachment (Degree of)"
			*/
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reasons for not seeking a job ('ilo_olf_reason') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: 

		capture gen ilo_WYNOT = c42_wynt 
		capture gen ilo_WYNOT = c34_wynot 
		capture gen ilo_WYNOT = cc42_wynot
		capture gen ilo_WYNOT = c35_wynot
		
		
	
	gen ilo_olf_reason=.
		replace ilo_olf_reason=1 if ilo_WYNOT==1
		replace ilo_olf_reason=2 if inlist(ilo_WYNOT,2,5)
		replace ilo_olf_reason=3 if inlist(ilo_WYNOT,3,7,8)
		/* replace ilo_olf_reason=4 if */
		replace ilo_olf_reason=5 if ilo_olf_reason==. & ilo_lfs==3
			replace ilo_olf_reason=. if ilo_lfs!=3
			lab def lab_olf_reason 1 "1 - Labour market (discouraged)" 2 "2- Other labour market reasons" 3 "3 - Personal/Family-related"  4 "4 - Does not need/want to work" 5 "5 - Not elsewhere classified"
			lab val ilo_olf_reason lab_olf_reason
			lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"
	
	drop ilo_WYNOT
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seekers ('ilo_dis') [done]
* -------------------------------------------------------------------------------------------
* ------------------------------------------------------------------------------------------- 
*
* Comment: 	
		
		gen ilo_dis=1 if ilo_lfs==3 & ilo_olf_reason==1 & ilo_AVAILABLE_FOR_WORK==1
			lab def ilo_dis_lab 1 "Discouraged job-seekers" 
			lab val ilo_dis ilo_dis_lab
			lab var ilo_dis "Discouraged job-seekers"
		
	drop ilo_AVAILABLE_FOR_WORK
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training (NEETs) ('ilo_neet') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: 

		gen ilo_neet=.
			replace ilo_neet=1 if inrange(ilo_age,15,24) & ilo_lfs!=1 & ilo_edu_attendance==2
				lab def ilo_neet_lab 1 "Youth not in education, employment or training"
				lab val ilo_neet ilo_neet_lab
				lab var ilo_neet "Youth not in education, employment or training"
		

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

*			SAVE RESULTS

* -------------------------------------------------------------------------------------------

local  considered nat_lfs indu_code_prim occ_code_prim occ_code_prim_1dig prevocu_cod
drop time year quarter ILO_EXCLUDE


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------
* 1.	Prepare final datasets
* -------------------------------------------------------------

cd "$outpath"

		foreach var of varlist ilo_* {
	
		replace `var'=. if considered!=1
	
			}

		order ilo*, last
	
		compress 
		
	* Save dataset including original and ilo variables
	
		save ${country}_${source}_${time}_FULL,  replace		
	
	*Save file only containing ilo_* variables
	
		drop if considered!=1
	
		keep ilo*

		save ${country}_${source}_${time}_ILO, replace
		



