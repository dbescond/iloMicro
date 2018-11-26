* TITLE OF DO FILE: ILO Microdata Preprocessing code template - PAK, 2014
* DATASET USED: PAK LFS 2014
* NOTES:
* Author: Roger Gomis

* Starting Date: 27 February 2017
* Last updated: 08 February 2018
***********************************************************************************************


***********************************************************************************************
***********************************************************************************************

* 			1. SET UP WORK DIRECTORY, FILE NAME, VARIABLES AND FUNCTIONS

***********************************************************************************************
***********************************************************************************************

clear all 

set more off

global path "J:\DPAU\MICRO"
global country "PAK"
global source "LFS"
global time "2014Q1"
global inputFile "PAK_LFS_2014.dta"

global inpath "${path}\\${country}\\${source}\\${time}\ORI"
global temppath "${path}\_Admin"
global outpath "${path}\\${country}\\${source}\\${time}"

********************************************************************************
********************************************************************************

cd "$inpath"
	use ${inputFile}, clear
	*renaming everything in lower case
	rename *, lower  
		
		
* to remove added observations
gen original=1
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
		lab def lab_time 1 $time
		lab val ilo_time lab_time
		lab var ilo_time "Time (Gregorian Calendar)"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sample Weight ('ilo_wgt') - switching frequency
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

capture rename surperiod survey_period
		
   decode ilo_time, gen(to_drop)
   split to_drop, generate(to_drop_) parse(Q)
   destring to_drop_1, replace force
	local Y = to_drop_1 in 1

   capture destring to_drop_2, replace force
   capture gen to_drop_2=-9999
   local Q = to_drop_2 in 1
   

*-- annual

	gen ilo_wgt=weights  if to_drop_2==-9999
		lab var ilo_wgt "Sample weight"		

*-- quarter_1                
    if `Q' == 1 {
	    replace ilo_wgt = weights  *4
		lab var ilo_wgt "Sample weight"	
		keep if inlist(survey_period,1)
}

*-- quarter_2                
    if `Q' == 2 {
	    replace ilo_wgt = weights  *4
		lab var ilo_wgt "Sample weight"	
		keep if inlist(survey_period,2)
}

*-- quarter_3                
    if `Q' == 3 {
	    replace ilo_wgt = weights  *4
		lab var ilo_wgt "Sample weight"	
		keep if inlist(survey_period,3)
}

*-- quarter_4                
    if `Q' == 4 {
	    replace ilo_wgt = weights *4
		lab var ilo_wgt "Sample weight"	
		keep if inlist(survey_period,4)
}


if  `Y'==2014 {
	replace ilo_wgt = ilo_wgt * 1.13854878403614

}
if  `Y'==2013 &`Q'>2 {
	replace ilo_wgt = ilo_wgt * 1.13854878403614

}
if  `Y'==2013 &`Q'<3 {
	replace ilo_wgt = ilo_wgt * 1.31016336955677

}
if  `Y'==2012 {
	replace ilo_wgt = ilo_wgt * 1.31016336955677

}

* ---------------------------------------------------------------------------------------------
***********************************************************************************************
*			PART 1.5 COMPATIBILITY
***********************************************************************************************
* ---------------------------------------------------------------------------------------------

if to_drop_1 < 2014 {

if to_drop_1 == 2013 & (`Q' ==3 | `Q' ==4) {
	* nothing, it is the same master that in 2014
}
else {
**original (old_name -> new_name)
*pattern
capture rename *s4_q* *sec_4_*
capture rename *s5_q* *sec_5_*
capture rename *s9_q* *sec_9_*
capture rename *s6_q* *sec_6_*
capture rename *s8_q* *sec_8_*
*individual
capture rename s7_q4 sec_7_4_3
capture rename s7_q3 sec_7_3_3
capture rename s7_q6 sec_7_6

** derivative ( new_name -> other_new_name)
rename *sec_5_17_* *sec_5_17*


** Using the logic of the do file
gen sec_7_5_3=.

** Making changes and using the logic of the do file , note that some modifications in the main do code are necessary as well (drop duration details)
* to obtain duration of unemployment
gen sec_9_3_2=0.5 if sec_9_3==1
	replace sec_9_3_2=1.5 if sec_9_3==2
	replace sec_9_3_2=3.5 if sec_9_3==3
	replace sec_9_3_2=7.5 if sec_9_3==4
	replace sec_9_3_2=12.5 if sec_9_3==5
gen sec_9_3_3 =.
gen sec_9_3_1 =.

*to match sector (only 2 digit level in 2013)
replace sec_5_9 =sec_5_9*100
replace sec_5_10=sec_5_10*100
replace sec_9_11=sec_9_11*100
replace sec_9_10=sec_9_10*100

* ensuring that Own account workers, family workers and cooperative members fit adequately
replace sec_5_8=14 if sec_5_8==12
replace sec_5_8=13 if sec_5_8==11
replace sec_5_8=12 if sec_5_8==10

* firm size
replace sec_5_13=20 if sec_5_13==4
replace sec_5_13=10 if sec_5_13==3
replace sec_5_13=6 if sec_5_13==2
replace sec_5_13=2 if sec_5_13==1

* region changes meaning
replace region=20 if region==2
replace region=10 if region==1
replace region=1 if region==20
replace region=2 if region==10

*In some variables missing is set up as -1 ,this can interfere with the algorithm to compute informality
replace sec_5_11=. if sec_5_11==-1
replace sec_5_12=. if sec_5_12==-1
replace sec_5_13=. if sec_5_13==-1
replace sec_5_15=. if sec_5_15==-1
}
}

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
		replace ilo_geo=1 if region==2
		replace ilo_geo=2 if region==1
		lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural"
		lab val ilo_geo ilo_geo_lab
		lab var ilo_geo "Geographical coverage"	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_sex= sec_4_5
		lab def ilo_sex_lab 1 "1 - Male" 2 "2 - Female"
		lab var ilo_sex "Sex"
		lab val ilo_sex ilo_sex_lab


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_age=sec_4_6
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
*			Education ('ilo_edu')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

/* ISCED 2011 mapping	file:///J:\DPAU\MICRO\PAK\LFS\2014\ORI\ISCED_2011_Mapping_EN_Pakistan.xlsx/ */
*note that post secondary level non tertirary is empty
*also note that for 2013 PhD is empty due to MPhil-PhD being bunched together

	recode sec_4_9 (1=1) (2/3=2) (4=3) (5=4) (6/7=5) (8/12=7) (13/14=9) (15=10) (16 . 0 61=11), gen(ilo_edu_isced11)
			label def isced_11_lab 1 "X - No schooling" 2 "0 - Early childhood education" 3 "1 - Primary education" 4 "2 - Lower secondary education" ///
							5 "3 - Upper secondary education" 6 "4 - Post-secondary non-tertiary education" 7 "5 - Short-cycle tertiary education" ///
							8 "6 - Bachelor's or equivalent level" 9 "7 - Master's or equivalent level" 10 "8 - Doctoral or equivalent level" 11 "9 - Not elsewhere classified"
			label val ilo_edu_isced11 isced_11_lab
			lab var ilo_edu_isced11 "Education (ISCED 11)"

		
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
*			Education attendance ('ilo_edu_attendance')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* note the usage of matriculation in level to proxy for attendance
	gen ilo_edu_attendance=.
		replace ilo_edu_attendance=1 if inlist(sec_4_10,2,15)			// Attending
		replace ilo_edu_attendance=2 if sec_4_10==1				// Not attending
		replace ilo_edu_attendance=3 if ilo_edu_attendance==.
			label def edu_att_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Unkown"
			label val ilo_edu_attendance edu_att_lab
			label var ilo_edu_attendance "Education (Attendance)"

			
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			           Marital status ('ilo_mrts') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: There is no information on union/cohabiting or separated.
*          Question made to people aged 10 years and over.
	
	* Detailed
	gen ilo_mrts_details=.
	    replace ilo_mrts_details=1 if sec_4_7==1                                // Single
		replace ilo_mrts_details=2 if sec_4_7==2                                // Married
		*replace ilo_mrts_details=3 if                                          // Union / cohabiting
		replace ilo_mrts_details=4 if sec_4_7==3                                // Widowed
		replace ilo_mrts_details=5 if sec_4_7==4                                // Divorced / separated
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

* no data

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
		replace ilo_wap=1 if (ilo_age>=15 & ilo_age!=.)
			lab def wap_lab 1 "Working age population"
			lab val ilo_wap wap_lab
			label var ilo_wap "Working age population"

	drop ilo_age

	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Labour Force Status ('ilo_lfs')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* lfs follows the orignal R code (not the one for national definition)
/* R original coments
# Comment: 	'Employed': (tmp_emp)
#                	sec5_2 ("work?'") set to 1 ('Yes') OR
#                	sec5_3 ("family help'") set to 1 ('Yes') OR 
#                	sec5_4 ("not worked'") set to 1, 2 ('Yes, ...)

#			'Seeking'	tmp_Seeking		
#             	'Not at work' (tmp_NotAtWork)
#                	sec9_1 ("seek work?'") set to 1
#           'Available' tmp_available
#                	sec9_4 ("available for work'") from 1 to 6
#			'Exception' + tmp_exception (stay consider as unemployed the rest as out of labour force)
#				    sec5_4 ("not worked'") set to 3, 4 ('No, ...)
#					sec9_4 ("available for work'") set to 7 ('No') AND
#                	sec9_6 ("not available'")  set to 2, 3 
#													(	'Will take a job within a month', 
#													 	'Temporarily laid off', 
#														)
# in the national definition they included also '1 - Illness and 4 - Apprentice and not willing to work'

#          	'Unemployed': (tmp_une) REPLACE AND by OR for national definition:
#                	tmp_NotAtWork AND tmp_Seeking AND tmp_available OR 
#					tmp_NotAvailableBut       

#          	'Outside the labour force
#             		ilo_wap AND NOT tmp_emp AND NOT tmp_une
*/
	gen ilo_lfs=.
		replace ilo_lfs=1 if (sec_5_2==1|sec_5_3==1|sec_5_4<3 ) & ilo_wap==1 	// Employed or temporary absent
		replace ilo_lfs=2 if ((sec_9_1==1)&(inlist(sec_9_4,1,2,3,4,5,6)|(sec_9_4==7&inlist(sec_9_6,1,2,3,4))))&ilo_wap==1 & ilo_lfs!=1	// Unemployed
		replace ilo_lfs=3 if ilo_lfs!=1 & ilo_lfs!=2 & ilo_wap==1  											// Outside the labour force
				label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside the Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status"


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_mjh=.
		replace ilo_mjh=1 if sec_5_18==2 & ilo_lfs==1
		replace ilo_mjh=2 if sec_5_18==1 & ilo_lfs==1
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

  * MAIN JOB:
	
	* Detailed categories:
	
		gen ilo_job1_ste_icse93=.
			replace ilo_job1_ste_icse93=1 if sec_5_8<5 & ilo_lfs==1		// Employees
			replace ilo_job1_ste_icse93=2 if sec_5_8==5 & ilo_lfs==1		// Employers
			replace ilo_job1_ste_icse93=3 if inlist(sec_5_8,6,7,8,9,10) & ilo_lfs==1		// Own-account workers
			replace ilo_job1_ste_icse93=4 if sec_5_8==13 & ilo_lfs==1		// Members of producers cooperatives
			replace ilo_job1_ste_icse93=5 if inlist(sec_5_8,11,12) & ilo_lfs==1		// Contributing family workers
			replace ilo_job1_ste_icse93=6 if ilo_job1_ste_icse93==. & ilo_lfs==1		// Not classifiable

				label def label_ilo_ste_icse93 1 "1 - Employees" 2 "2 - Employers" 3 "3 - Own-account workers"  ///
											   4 "4 - Members of producers cooperatives" 5 "5 - Contributing family workers" ///
											   6 "6 - Workers not classifiable by status"
				label val ilo_job1_ste_icse93 label_ilo_ste_icse93
				label var ilo_job1_ste_icse93 "Status in employment (ICSE 93)"

	* Aggregate categories 
		
		gen ilo_job1_ste_aggregate=.
			replace ilo_job1_ste_aggregate=1 if ilo_job1_ste_icse93==1				// Employees
			replace ilo_job1_ste_aggregate=2 if inrange(ilo_job1_ste_icse93,2,5)	// Self-employed
			replace ilo_job1_ste_aggregate=3 if ilo_job1_ste_icse93==6				// Not elsewhere classified
				lab def ste_aggr_lab 1 "1 - Employees" 2 "2 - Self-employed" 3 "3 - Not elsewhere classified"
				lab val ilo_job1_ste_aggregate ste_aggr_lab
				label var ilo_job1_ste_aggregate "Status in employment (Aggregate)"  

				


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* IT DOES FOLLOW ISIC  4
	

		* Primary activity
		
		gen ilo_job1_eco_isic4_2digits=trunc(sec_5_10/100) if (ilo_lfs==1)
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
		

	
	* One digit level - for reference

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
			replace ilo_job1_eco_isic4=22 if ilo_job1_eco_isic4_2digits==. & ilo_lfs==1 
		        lab def eco_isic4_1digit 1 "A - Agriculture, forestry and fishing"	2 "B - Mining and quarrying"	3 "C - Manufacturing"	4 "D - Electricity, gas, steam and air conditioning supply" ///
                                         5 "E - Water supply; sewerage, waste management and remediation activities"	6 "F - Construction"	7 "G - Wholesale and retail trade; repair of motor vehicles and motorcycles"	8 "H - Transportation and storage" ///
                                         9 "I - Accommodation and food service activities"	10 "J - Information and communication"	11 "K - Financial and insurance activities"	12 "L - Real estate activities" ///
                                         13 "M - Professional, scientific and technical activities"	14 "N - Administrative and support service activities"	15 "O - Public administration and defence; compulsory social security"	16 "P - Education" ///
                                         17 "Q - Human health and social work activities"	18 "R - Arts, entertainment and recreation"	19 "S - Other service activities"	20 "T - Activities of households as employers; undifferentiated goods- and services-producing activities of households for own use" ///
                                         21 "U - Activities of extraterritorial organizations and bodies"	22 "X - Not elsewhere classified"		
  	  		    lab val ilo_job1_eco_isic4 eco_isic4_1digit
			    lab var ilo_job1_eco_isic4 "Economic activity (ISIC Rev. 4) - main job"

	* Classification aggregated level
	
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
			   lab var ilo_job1_eco_aggregate "Economic activity (Aggregate) - main job"
				



* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_job1_ocu_isco88_2digits') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
	
	/* Classification used: ISCO 08  */

	* MAIN JOB:	
	
		* ISCO 08- 2 digit
			gen todrop=sec_5_9
			replace todrop=trunc(todrop/100)
			gen ilo_job1_ocu_isco08_2digits=todrop if (ilo_lfs==1)
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
	            lab values ilo_job1_ocu_isco08_2digits ocu_isco08_2digits
	            lab var ilo_job1_ocu_isco08_2digits "Occupation (ISCO-08), 2 digit level - main job"
			drop todrop
		
* ISCO 08 - 1 digit
			gen ilo_job1_ocu_isco08=.
				replace ilo_job1_ocu_isco08=1 if inrange(ilo_job1_ocu_isco08_2digits,10,19)
				replace ilo_job1_ocu_isco08=2 if inrange(ilo_job1_ocu_isco08_2digits,20,29)
				replace ilo_job1_ocu_isco08=3 if inrange(ilo_job1_ocu_isco08_2digits,30,39)
				replace ilo_job1_ocu_isco08=4 if inrange(ilo_job1_ocu_isco08_2digits,40,49)
				replace ilo_job1_ocu_isco08=5 if inrange(ilo_job1_ocu_isco08_2digits,50,59)
				replace ilo_job1_ocu_isco08=6 if inrange(ilo_job1_ocu_isco08_2digits,60,69)
				replace ilo_job1_ocu_isco08=7 if inrange(ilo_job1_ocu_isco08_2digits,70,79)
				replace ilo_job1_ocu_isco08=8 if inrange(ilo_job1_ocu_isco08_2digits,80,89)
				replace ilo_job1_ocu_isco08=9 if inrange(ilo_job1_ocu_isco08_2digits,90,99)
				replace ilo_job1_ocu_isco08=10 if inrange(ilo_job1_ocu_isco08_2digits,1,9)
				replace ilo_job1_ocu_isco08=11 if (ilo_job1_ocu_isco08_2digits==. & ilo_lfs==1)
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
		recode ilo_job1_ocu_isco08 (1/3=3) (4/8=2) (9=1) (10/11=4) ,gen(ilo_job1_ocu_skill)
				lab def ocu_skill_lab 1 "1 - Skill level 1 (low)" 2 "2 - Skill level 2 (medium)" 3 "3 - Skill levels 3 and 4 (high)" 4 "4 - Not elsewhere classified"
			    lab val ilo_job1_ocu_skill ocu_skill_lab
			    lab var ilo_job1_ocu_skill "Occupation (Skill level) - main job"
				

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_job1_ins_sector')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
	
	/* Other are classified under Private	*/ 
	* if the respondant does not know the variable is not defined
		gen ilo_job1_ins_sector=.
			replace ilo_job1_ins_sector=1 if (inlist(sec_5_11,1,2,3,4) & ilo_lfs==1)	// Public
			replace ilo_job1_ins_sector=2 if (inlist(sec_5_11,5,6,7,8,9,10) & ilo_lfs==1)	// Private
			* lots of missing values due to the question not being asked to workers in agriculture
			replace ilo_job1_ins_sector=2 if ilo_job1_eco_isic4==1&ilo_lfs==1&ilo_job1_ins_sector==.
			*replace ilo_job1_ins_sector=2 if ilo_lfs==1&ilo_job1_ins_sector==.
				lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private" 
				lab values ilo_job1_ins_sector ins_sector_lab
				lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities"


			
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job1_job_contract')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
	
*NA, note the question (sec_7_1) is not adequate to identify temporal/permanent, as the options given are:
/*
1. Permanent/
pensionable
Job
With contract/
agreement
2. Less than 1
year
3. Up to 3 years
4. Up to 5 years
5. Up to 10 years
6. 10 Years and
more
7. With out
contract/
agreement
*/


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Formal / Informal Economy ('ilo_job1_ife_prod' 'ilo_job1_ife_nature') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
		
		
		
	/* Useful questions:
		
		For all employed persons:
		
		sec_5_11 institutional sector
		sec_5_12 written accounts
		sec_5_13 number of workers
		sec_5_15 workplace


	*/
	
	*** Generating the nodes, From left to right 1 directs to first direction in the diagram (usually formal), 0 to the second (usually informal), and -1 if aplicable to the third one. Only unique paths)
	* NOTE: Some variables are trivially created due to lack of data
	
	* Given the low level of information, written accounts is assumed to be for goverment use (the reason is not specified)
	
	*** Preparing necessary variables - the variables must be adjusted to fit the data
	
	recode sec_5_11 (1/5=1) (6/10 =0) , gen(todrop_institutional) 				// theoretical 3 value node/ +1 Gov, Corporation, NGO, Embassy, IO / 0 Farm or private business, other, not asked, don't know, NA / -1 private household
	replace todrop_institutional=-1 if ilo_job1_eco_isic4_2digits==97|ilo_job1_ocu_isco08_2digits==63	
	replace todrop_institutional=0 if todrop_institutional==. 						// if the absence of the created variable is due to complete absence informality should not be computed
	
	gen todrop_destinationprod=1 													// theoretical 2 value node / +1 At least partially market or Other, Not asked, Don't Know, NA/  0 Only for own final use (household) :::actual node empty(no necessary data available)
	
	gen todrop_bookkeeping=0 														// theoretical 2 value node/ +1 keeps accounts for GOV/ 0 does not keep accounts or personal use or other, not asked, DK, NA  :::actual node empty (no necessary data available)
		replace todrop_bookkeeping=1 if sec_5_12==1
		
	gen todrop_registration=-1														// theoretical 3 value node/ +1 registered national level/ 0 not registered national level, other, DK / -1 not asked NA

		
	gen todrop_SS=0												// theoretical 3 value node/ +1 Social security/ 0 Not asked / -1 No social security or don't know NA Other

		
	gen todrop_place=1 if inlist(sec_5_15,6) 							// theoretical 2 value node/ +1 fixed visible premises / 0 non fixed premises ::: empty node (no necessary data available)
		replace todrop_place=0 if inlist(sec_5_15,1,2,3,4,5) 
		
	gen todrop_size=1 if sec_5_13>5&sec_5_13!=. 							// theoretical 2 value node/ +1 more than 6 workers / 0 less than 6 workers
		replace todrop_size=0 if sec_5_13<6

	gen todrop_paidleave=1 if inlist(sec_7_6,1,2,3,4,5,6)							// theoretical 2 value node/ +1 paid leave / 0 no paid leave, not asked , DK, NA
	replace todrop_paidleave=0 if todrop_paidleave==.
		
	gen todrop_paidsick=1 if inlist(sec_7_6,1,2,3,4,5,6)							// theoretical 2 value node/ +1 sick leave / 0 no sick leave, not asked, DK, NA
	replace todrop_paidsick=0 if todrop_paidsick==.
		
	gen todrop_producesforsale=1 													//  theoretical 2 value node / +1 Yes product for sale, Other, Not asked, Don't Know, NA/ 0 No, not for sale :::actual node empty(no necessary data available)
	

	* NOTE: EXCEPTION TO FORCE EMPLOYEES WITH NO DATA OR NEGATIVE (FORMALITY WISE) DATA TO INFORMAL
	gen todrop_EXCEPTION=0 if ilo_lfs==1&todrop_institutional==0&todrop_destinationprod==1&todrop_bookkeeping==0&todrop_registration==-1&ilo_job1_ste_icse93==1&(todrop_size==.|todrop_place==.)
	replace todrop_size=todrop_EXCEPTION if todrop_EXCEPTION==0
	replace todrop_place=todrop_EXCEPTION if todrop_EXCEPTION==0
	* NOTE: EXCEPTION TO FORCE ALL WORKERS EXCEPT EMPLOYEES WITH NO DATA OR NEGATIVE (FORMALITY WISE) DATA TO INFORMAL
	replace todrop_registration=0 if ilo_lfs==1&todrop_institutional==0&todrop_destinationprod==1&todrop_bookkeeping==0&todrop_registration==-1&ilo_job1_ste_icse93!=1&(todrop_size==.|todrop_place==.)
	
	***********************************************************
	*** Obtention variables, this part should NEVER be modified
	***********************************************************
	* 1) Unit of production - Formal / Informal Sector
	
		/*the code is not condensed through ORs (for values of the same variables it is used but not for combinations of variables) or ellipsis for clarity (of concept) */

			gen ilo_job1_ife_prod=.
			
			* Formal
				replace ilo_job1_ife_prod = 2 if ilo_lfs==1&todrop_institutional==1
				replace ilo_job1_ife_prod = 2 if ilo_lfs==1&todrop_institutional==0&todrop_destinationprod==1&todrop_bookkeeping==1
				replace ilo_job1_ife_prod = 2 if ilo_lfs==1&todrop_institutional==0&todrop_destinationprod==1&todrop_bookkeeping==0&todrop_registration==1
				replace ilo_job1_ife_prod = 2 if ilo_lfs==1&todrop_institutional==0&todrop_destinationprod==1&todrop_bookkeeping==0&todrop_registration==-1&ilo_job1_ste_icse93==1&todrop_SS==1
				replace ilo_job1_ife_prod = 2 if ilo_lfs==1&todrop_institutional==0&todrop_destinationprod==1&todrop_bookkeeping==0&todrop_registration==-1&ilo_job1_ste_icse93==1&todrop_SS!=1&todrop_place==1&todrop_size==1
				replace ilo_job1_ife_prod = 2 if ilo_lfs==1&todrop_institutional==0&todrop_destinationprod==1&todrop_bookkeeping==0&todrop_registration==-1&ilo_job1_ste_icse93!=1&todrop_place==1&todrop_size==1
			* HH	
				replace ilo_job1_ife_prod = 3 if ilo_lfs==1&todrop_institutional==-1
				replace ilo_job1_ife_prod = 3 if ilo_lfs==1&todrop_institutional==0&todrop_destinationprod==0
			* Informal	
				replace ilo_job1_ife_prod = 1 if ilo_lfs==1&todrop_institutional==0&todrop_destinationprod==1&todrop_bookkeeping==0&todrop_registration==0
				replace ilo_job1_ife_prod = 1 if ilo_lfs==1&todrop_institutional==0&todrop_destinationprod==1&todrop_bookkeeping==0&todrop_registration==-1&ilo_job1_ste_icse93==1&todrop_SS!=1&todrop_place==0
				replace ilo_job1_ife_prod = 1 if ilo_lfs==1&todrop_institutional==0&todrop_destinationprod==1&todrop_bookkeeping==0&todrop_registration==-1&ilo_job1_ste_icse93==1&todrop_SS!=1&todrop_place==1&todrop_size==0
				replace ilo_job1_ife_prod = 1 if ilo_lfs==1&todrop_institutional==0&todrop_destinationprod==1&todrop_bookkeeping==0&todrop_registration==-1&ilo_job1_ste_icse93!=1&todrop_place==0
				replace ilo_job1_ife_prod = 1 if ilo_lfs==1&todrop_institutional==0&todrop_destinationprod==1&todrop_bookkeeping==0&todrop_registration==-1&ilo_job1_ste_icse93!=1&todrop_place==1&todrop_size==0
				* note, special loop for employees. If we have data on social security, and they say NO or don't know, and still we do not have a complete pair Size-Place of Work, they should go to informal
				replace ilo_job1_ife_prod = 1 if ilo_lfs==1&todrop_institutional==0&todrop_destinationprod==1&todrop_bookkeeping==0&todrop_registration==-1&ilo_job1_ste_icse93==1&todrop_SS==-1&(todrop_size==.|todrop_place==.)
				
			lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 
			lab val ilo_job1_ife_prod ilo_ife_prod_lab
			lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"


	* 2) Nature of job - Formal / Informal Job
	* note that the variable of informal/formal sector does not follow the node notation
			gen ilo_job1_ife_nature=.
			
			*Formal
				*Employee
				replace ilo_job1_ife_nature=2 if ilo_lfs==1&(ilo_job1_ste_icse93==1|ilo_job1_ste_icse93==6)&todrop_SS==1
				replace ilo_job1_ife_nature=2 if ilo_lfs==1&(ilo_job1_ste_icse93==1|ilo_job1_ste_icse93==6)&todrop_SS==0&todrop_paidleave==1&todrop_paidsick==1
				*Employers or Members of coop
				replace ilo_job1_ife_nature=2 if ilo_lfs==1&(ilo_job1_ste_icse93==2|ilo_job1_ste_icse93==4)&ilo_job1_ife_prod==2	
				*OAW
				replace ilo_job1_ife_nature=2 if ilo_lfs==1&ilo_job1_ste_icse93==3&todrop_producesforsale==1&ilo_job1_ife_prod==2
			* Informal
				*Employee
				replace ilo_job1_ife_nature=1 if ilo_lfs==1&(ilo_job1_ste_icse93==1|ilo_job1_ste_icse93==6)&todrop_SS==-1
				replace ilo_job1_ife_nature=1 if ilo_lfs==1&(ilo_job1_ste_icse93==1|ilo_job1_ste_icse93==6)&todrop_SS==0&todrop_paidleave==0
				replace ilo_job1_ife_nature=1 if ilo_lfs==1&(ilo_job1_ste_icse93==1|ilo_job1_ste_icse93==6)&todrop_SS==0&todrop_paidleave==1&todrop_paidsick==0
				*Employers or Members of coop
				replace ilo_job1_ife_nature=1 if ilo_lfs==1&(ilo_job1_ste_icse93==2|ilo_job1_ste_icse93==4)&(ilo_job1_ife_prod==1|ilo_job1_ife_prod==3)
				*OAW
				replace ilo_job1_ife_nature=1 if ilo_lfs==1&ilo_job1_ste_icse93==3&todrop_producesforsale==1&(ilo_job1_ife_prod==1|ilo_job1_ife_prod==3)
				replace ilo_job1_ife_nature=1 if ilo_lfs==1&ilo_job1_ste_icse93==3&todrop_producesforsale==0
			*Contributing Family Workers
				replace ilo_job1_ife_nature=1 if ilo_lfs==1&ilo_job1_ste_icse93==5
				

						lab def ife_nature_lab 1 "1 - Persons with informal main job" 2 "2 - Persons with formal main job"
						lab val ilo_job1_ife_nature ife_nature_lab
						lab var ilo_job1_ife_nature "Informal / Formal Economy (Nature of job) - Main job"
			*rename *todrop* *tokeep*

			capture drop todrop* 
	***********************************************************
	*** End informality****************************************
	***********************************************************


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Hours of work ('ilo_job1_how')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
		
* Main job:

* 1) Weekly hours ACTUALLY worked - Main job

			gen ilo_job1_how_actual=sec_5_171 if (ilo_lfs==1)
					*to avoid missing values
					replace ilo_job1_how_actual=0 if ilo_lfs==1&ilo_job1_how_actual==.
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
		
		
* 2) Weekly hours USUALLY worked 

*NA

* Second job: 

* 1) Weekly hours ACTUALLY worked:

		gen ilo_job2_how_actual=sec_5_26 if (ilo_mjh==2 & ilo_lfs==1)
			*to avoid missing values
			replace ilo_job2_how_actual=0 if ilo_lfs==1&ilo_job2_how_actual==.&ilo_mjh==2
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
		

* 2) Weekly hours USUALLY worked - Not available

*NA

* All jobs:
		
* 1) Weekly hours ACTUALLY worked:

			egen ilo_joball_how_actual=rowtotal(ilo_job1_how_actual ilo_job2_how_actual) if (ilo_lfs==1)  
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


* 2) Weekly hours USUALLY worked - Not available
*NA
				
				
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job1_job_time') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			

	/* Threshold of 40 hours per week	*/

			gen ilo_job1_job_time=.
				replace ilo_job1_job_time=1 if (ilo_joball_how_actual<40 & ilo_lfs==1) 	// Part-time
				replace ilo_job1_job_time=2 if (ilo_joball_how_actual>39&ilo_joball_how_actual!=. & ilo_lfs==1)	// Full-time
				replace ilo_job1_job_time=3 if (ilo_job1_job_time==. & ilo_lfs==1)	// Unknown
					lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
					lab val ilo_job1_job_time job_time_lab
					lab var ilo_job1_job_time "Job (Working time arrangement) - Main job"	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Monthly labour related income ('ilo_joball_lri')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
	   
			* All jobs
				
				* Employees
					gen ilo_job1_lri_ees=.
						replace ilo_job1_lri_ees= sec_7_4_3 if (sec_7_4_3>0& ilo_job1_ste_aggregate==1 & ilo_job1_lri_ees==.)
						replace ilo_job1_lri_ees=sec_7_3_3*52/12 if (sec_7_3_3 >0  & ilo_job1_ste_aggregate==1& ilo_job1_lri_ees==.)
						lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"	

				
				*SE
					*NA
***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_joball_tru')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

		gen ilo_joball_tru=.
		*new definition
			replace ilo_joball_tru=1 if (ilo_joball_how_actual<35 & sec_6_2==1 & sec_6_3==1 ) & ilo_lfs==1
			lab def tru_lab 1 "Time-related underemployment"
			lab val ilo_joball_tru tru_lab
			lab var ilo_joball_tru "Time-related underemployment"	
		

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupational injury ('ilo_joball_inj')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
		
	
	* 1) Cases of non-fatal occupational injuries (within the last 12 months):
	
		gen ilo_joball_oi_case=. if (ilo_lfs==1)
			replace  ilo_joball_oi_case=1 if (sec_8_1 ==1|sec_8_1 ==2)
			lab var ilo_joball_oi_case "Cases of non-fatal occupational injury"

	
	* 2) Days lost due to cases of occupational injuries (within the last 12 months):

				*NA
		

***********************************************************************************************
*			PART 3.3. UNEMPLOYMENT: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Category of unemployment ('ilo_cat_une')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	gen ilo_cat_une=.
		replace ilo_cat_une=1 if (sec_9_8==1&ilo_lfs==2)
		replace ilo_cat_une=2 if (sec_9_8==2&ilo_lfs==2)
		replace ilo_cat_une=3 if (ilo_cat_une==.&ilo_lfs==2)
				lab def ilo_cat_une 1 "Unemployed previously employed" 2 "Unemployed seeking first job" 3 "Unknown"
				lab val ilo_cat_une ilo_cat_une
				lab var ilo_cat_une "Category of unemployment"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------



	gen todrop1=sec_9_3_2
	gen todrop2=sec_9_3_3/(365/12)
	gen todrop3=sec_9_3_1*12
	egen todrop=rowtotal(todrop*)
	replace todrop=. if todrop==0
		
	gen ilo_dur_details=.
				replace ilo_dur_details=1 if (todrop<1 & ilo_lfs==2)
				replace ilo_dur_details=2 if (inrange(todrop,1,2.999999) & ilo_lfs==2)
				replace ilo_dur_details=3 if (inrange(todrop,3,5.999999) & ilo_lfs==2)
				replace ilo_dur_details=4 if (inrange(todrop,6,11.999999) & ilo_lfs==2)
				replace ilo_dur_details=5 if (inrange(todrop,12,23.999999) & ilo_lfs==2)
				replace ilo_dur_details=6 if (inrange(todrop,24,1440) & ilo_lfs==2)
				replace ilo_dur_details=7 if (ilo_dur_details==. & ilo_lfs==2)
					lab def ilo_unemp_det 1 "Less than 1 month" 2 "1 month to less than 3 months" 3 "3 months to less than 6 months" ///
											4 "6 months to less than 12 months" 5 "12 months to less than 24 months" 6 "24 months or more" ///
											7 "Not elsewhere classified"
					lab val ilo_dur_details ilo_unemp_det
					lab var ilo_dur_details "Duration of unemployment (Details)"
	gen ilo_dur_aggregate=.
				replace ilo_dur_aggregate=1 if (inlist(ilo_dur_details,1,2,3) & ilo_lfs==2)
				replace ilo_dur_aggregate=2 if (ilo_dur_details==4 & ilo_lfs==2)
				replace ilo_dur_aggregate=3 if (inlist(ilo_dur_details,5,6) & ilo_lfs==2)
				replace ilo_dur_aggregate=4 if (ilo_dur_details==7 & ilo_lfs==2)
					lab def ilo_unemp_aggr 1 "Less than 6 months" 2 "6 months to less than 12 months" 3 "12 months or more" 4 "Not elsewhere classified"
					lab val ilo_dur_aggregate ilo_unemp_aggr
					lab var ilo_dur_aggregate "Duration of unemployment (Aggregate)"
	drop todrop*
	
	if `Y' == 2013 {
	*note that for 2013 the categories 12-24 months and 24+ months are bunched together
		drop ilo_dur_details
	}
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

	* Classification aggregated level
	
		* Primary activity
		gen todrop=trunc(sec_9_11/100) if (ilo_lfs==2&ilo_cat_une==1)

					
	
	* One digit level - for reference
		gen ilo_preveco_isic4=.
			replace ilo_preveco_isic4=1 if inrange( todrop,1,3)
			replace ilo_preveco_isic4=2 if inrange( todrop,5,9)
			replace ilo_preveco_isic4=3 if inrange( todrop,10,33)
			replace ilo_preveco_isic4=4 if  todrop==35
			replace ilo_preveco_isic4=5 if inrange( todrop,36,39)
			replace ilo_preveco_isic4=6 if inrange( todrop,41,43)
			replace ilo_preveco_isic4=7 if inrange( todrop,45,47)
			replace ilo_preveco_isic4=8 if inrange( todrop,49,53)
			replace ilo_preveco_isic4=9 if inrange( todrop,55,56)
			replace ilo_preveco_isic4=10 if inrange( todrop,58,63)
			replace ilo_preveco_isic4=11 if inrange( todrop,64,66)
			replace ilo_preveco_isic4=12 if  todrop==68
			replace ilo_preveco_isic4=13 if inrange( todrop,69,75)
			replace ilo_preveco_isic4=14 if inrange( todrop,77,82)
			replace ilo_preveco_isic4=15 if  todrop==84
			replace ilo_preveco_isic4=16 if  todrop==85
			replace ilo_preveco_isic4=17 if inrange( todrop,86,88)
			replace ilo_preveco_isic4=18 if inrange( todrop,90,93)
			replace ilo_preveco_isic4=19 if inrange( todrop,94,96)
			replace ilo_preveco_isic4=20 if inrange( todrop,97,98)
			replace ilo_preveco_isic4=21 if  todrop==99
			replace ilo_preveco_isic4=22 if  todrop==. & ilo_lfs==2&ilo_cat_une==1
               * labels already defined for main job
		        lab val ilo_preveco_isic4 eco_isic4_1digit
			    lab var ilo_preveco_isic4 "Previous economic activity (ISIC Rev. 4)"

	* Classification aggregated level
	
		* Primary activity
		gen ilo_preveco_aggregate=.
			replace ilo_preveco_aggregate=1 if ilo_preveco_isic4==1
			replace ilo_preveco_aggregate=2 if ilo_preveco_isic4==3
			replace ilo_preveco_aggregate=3 if ilo_preveco_isic4==6
			replace ilo_preveco_aggregate=4 if inlist(ilo_preveco_isic4,2,4,5)
			replace ilo_preveco_aggregate=5 if inrange(ilo_preveco_isic4,7,14)
			replace ilo_preveco_aggregate=6 if inrange(ilo_preveco_isic4,15,21)
			replace ilo_preveco_aggregate=7 if ilo_preveco_isic4==22		
               * labels already defined for main job
	             lab val ilo_preveco_aggregate eco_aggr_lab
			     lab var ilo_preveco_aggregate "Previous economic activity (Aggregate)"
		drop todrop*





* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu_isco08')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

	/* Classification used: ISCO 08  */

	* MAIN JOB:	
	
		* ISCO 08 - 2 digit
			gen todrop=trunc(sec_9_10/100) if ilo_lfs==2&ilo_cat_une==1


		* ISCO 08 - 1 digit

			gen ilo_prevocu_isco08=.
				replace ilo_prevocu_isco08=1 if inrange(todrop,10,19)
				replace ilo_prevocu_isco08=2 if inrange(todrop,20,29)
				replace ilo_prevocu_isco08=3 if inrange(todrop,30,39)
				replace ilo_prevocu_isco08=4 if inrange(todrop,40,49)
				replace ilo_prevocu_isco08=5 if inrange(todrop,50,59)
				replace ilo_prevocu_isco08=6 if inrange(todrop,60,69)
				replace ilo_prevocu_isco08=7 if inrange(todrop,70,79)
				replace ilo_prevocu_isco08=8 if inrange(todrop,80,89)
				replace ilo_prevocu_isco08=9 if inrange(todrop,90,99)
				replace ilo_prevocu_isco08=10 if inrange(todrop,1,9)
				replace ilo_prevocu_isco08=11 if (ilo_prevocu_isco08==. & ilo_lfs==2&ilo_cat_une==1)
	                * labels already defined for main job
					lab val ilo_prevocu_isco08 ocu_isco08_1digit
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
					* labels already defined for main job
					lab val ilo_prevocu_aggregate ocu_aggr_lab
					lab var ilo_prevocu_aggregate "Previous occupation (Aggregate)"	
				
	
				
				
		* Skill level
		recode ilo_prevocu_isco08 (1/3=3) (4/8=2) (9=1) (10/11=4) ,gen(ilo_prevocu_skill)
                * labels already defined for main job
			    lab val ilo_prevocu_skill ocu_skill_lab
			    lab var ilo_prevocu_skill "Previous occupation (Skill level)"
	
		drop todrop*	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			General social protection ('ilo_gsp_uneschemes')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

	*NA

	
	
***********************************************************************************************
*			PART 3.4. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

/* Silenced because almost all end up in not classified
	gen ilo_olf_dlma=.
		replace ilo_olf_dlma = 1 if (sec_9_1==1)&!(inlist(sec_9_4,1,2,3,4,5,6))&ilo_lfs==3							 					//Seeking, not available
		replace ilo_olf_dlma = 2 if !(sec_9_1==1)&(inlist(sec_9_4,1,2,3,4,5,6))&ilo_lfs==3												//Not seeking, available
		replace ilo_olf_dlma = 3 if !(sec_9_1==1)&!(inlist(sec_9_4,1,2,3,4,5,6))&(inlist(sec_9_7,1,2))&ilo_lfs==3						//Not seeking, not available, willing
		replace ilo_olf_dlma = 4 if !(sec_9_1==1)&!(inlist(sec_9_4,1,2,3,4,5,6))&(sec_9_7==3)&ilo_lfs==3								//Not seeking, not available, not willing
		replace ilo_olf_dlma = 5 if	(ilo_olf_dlma==. & ilo_lfs==3)																		// Not classified 
	
			lab def dlma_lab 1 "1 - Seeking, not available (Unavailable jobseekers)" 2 "2 - Not seeking, available (Available potential jobseekers)" ///
							 3 "3 - Not seeking, not available, willing (Willing non-jobseekers)" 4 "4 - Not seeking, not available, not willing" 5 "X - Not elsewhere classified"
			lab val ilo_olf_dlma dlma_lab 
			lab var ilo_olf_dlma "Labour market attachment (Degree of)"
	*/		


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reason for not seeking job ('ilo_olf_reason')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

*NA, note that there is data for reason of not available

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seeker ('ilo_dis')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

*NA
			

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training ('ilo_neet')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

	gen ilo_neet=1 if (ilo_age_aggregate==2 & ilo_lfs!=1 & ilo_edu_attendance==2)
			lab def neet_lab 1 "Youth not in education, employment or training"
			lab val ilo_neet neet_lab
			lab var ilo_neet "Youth not in education, employment or training"
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Drop intermediate variables used for labeling activity and occupation
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
 * remove added variables
drop if original!=1
drop original
***********************************************************************************************
***********************************************************************************************

*			3. SAVE ILO-VARIABLES IN A NEW DATASET

***********************************************************************************************
***********************************************************************************************

* -------------------------------------------------------------
* 	Prepare final datasets
* -------------------------------------------------------------


* 1 - Full dataset with original variables and ILO ones
	
	cd "$outpath"

        compress
		save ${country}_${source}_${time}_FULL,  replace		

* 2 - Dataset with only 'ILO' variables
	
		keep ilo*
		save ${country}_${source}_${time}_ILO, replace
