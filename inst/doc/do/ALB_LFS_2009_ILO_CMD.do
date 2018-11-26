* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Albania
* DATASET USED: Albania LFS 
* NOTES: 
* Files created: Standard variables on LFS Albania
* Authors: ILO / Department of Statistics / DPAU

* Starting Date: 17 March 2017
* Last updated: 1 June 2018
*****************************************************************************************

*******************************************************************
 /* 1.	Set up work directory, file name, variables and function */
*******************************************************************

clear all 

set more off

global path "J:\DPAU\MICRO"
global country "ALB"
global source "LFS"
global time "2009"
global inputFile "LFS 2009 English.dta"

global inpath "${path}\\${country}\\${source}\\${time}\ORI"
global temppath "${path}\_Admin"
global outpath "${path}\\${country}\\${source}\\${time}"

			
*********************************************************************************************

* Load original dataset

*********************************************************************************************

cd "$inpath"

	use "$inputFile", clear	
		
	rename *, lower
	
* generate help variable for the time periods

	gen time="${time}"
		destring time, replace
		
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
*			Identifier ('ilo_key')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_key=_n
		lab var ilo_key "Key unique identifier per individual"
	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sample Weight ('ilo_wgt')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*		
* Comment: different weight considered depending on whether we take quarterly or annual data
	
	gen ilo_wgt=weight
		lab var ilo_wgt "Sample weight"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time period ('ilo_time')
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
*			Geographical coverage ('ilo_geo') [no info available]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
	/*gen ilo_geo=
		lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural"
		lab val ilo_geo ilo_geo_lab
		lab var ilo_geo "Geographical coverage"*/

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

		gen ilo_sex=sex
			label define label_Sex 1 "1 - Male" 2 "2 - Female"
			label values ilo_sex label_Sex
			lab var ilo_sex "Sex"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: note that only individuals 15+ are included in dataset

	gen ilo_age=age
		replace ilo_age=. if ilo_age==99 /* As it corresponds to the label "No informa" " */
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
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Level of education ('ilo_edu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: Note that according to the definition, the highest level being CONCLUDED is being considered

	if time<=2008 {	
	
	gen ilo_edu_isced97=.
		replace ilo_edu_isced97=1 if q94==1
		/* replace ilo_edu_isced97=2 if */
		replace ilo_edu_isced97=3 if q94==2
		replace ilo_edu_isced97=4 if q94==3
		replace ilo_edu_isced97=5 if inlist(q94,4,5,6)
		/* replace ilo_edu_isced97=6 if */
		replace ilo_edu_isced97=7 if q94==7
		replace ilo_edu_isced97=8 if inlist(q94,8,9)
		replace ilo_edu_isced97=9 if ilo_edu_isced97==.
				replace ilo_edu_isced97=9 if ilo_edu_isced97==.
				
				}

			
		else {
		
	gen ilo_edu_isced97=.
		replace ilo_edu_isced97=1 if q123==1
		/* replace ilo_edu_isced97=2 if */
		replace ilo_edu_isced97=3 if q123==2
		replace ilo_edu_isced97=4 if q123==3
		replace ilo_edu_isced97=5 if inlist(q123,4,5,6)
		/* replace ilo_edu_isced97=6 if */
		replace ilo_edu_isced97=7 if q123==7
		replace ilo_edu_isced97=8 if inlist(q123,8,9)
		replace ilo_edu_isced97=9 if ilo_edu_isced97==.
				replace ilo_edu_isced97=9 if ilo_edu_isced97==.
					
					}
				
			label def isced_97_lab 1 "X - No schooling" 2 "0 - Pre-primary education" 3 "1 - Primary education or first stage of basic education" 4 "2 - Lower secondary education or second stage of basic education" ///
							5 "3 - Upper secondary education" 6 "4 - Post-secondary non-tertiary education" 7 "5 - First stage of tertiary education (not leading directly to an advanced research qualification)" ///
							8 "6 - Second stage of tertiary education (leading to an advanced research qualification)" 9 "UNK - Level not stated"
			label val ilo_edu_isced97 isced_97_lab
			lab var ilo_edu_isced97 "Level of education (ISCED 97)"


		* For the definition, cf. the document "Guide to reporting labour statistics to the ILO using the Excel questionnaire"
		
	gen ilo_edu_aggregate=.
		replace ilo_edu_aggregate=1 if inlist(ilo_edu_isced97,1,2)
		replace ilo_edu_aggregate=2 if inlist(ilo_edu_isced97,3,4)
		replace ilo_edu_aggregate=3 if inlist(ilo_edu_isced97,5,6)
		replace ilo_edu_aggregate=4 if inlist(ilo_edu_isced97,7,8)
		replace ilo_edu_aggregate=5 if ilo_edu_isced97==9
			label def edu_aggr_lab 1 "1 - Less than basic" 2 "2 - Basic" 3 "3 - Intermediate" 4 "4 - Advanced" 5 "5 - Level not stated"
			label val ilo_edu_aggregate edu_aggr_lab
			label var ilo_edu_aggregate "Level of education (Aggregate levels)"
			
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education attendance ('ilo_edu_attendance')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
		
	if time<=2008 {
		
	gen ilo_edu_attendance=.
		replace ilo_edu_attendance=1 if inlist(q89,1,2)
		replace ilo_edu_attendance=2 if q89==3
		
			}
	else {
	
	gen ilo_edu_attendance=.
		replace ilo_edu_attendance=1 if inlist(q118,1,2)
		replace ilo_edu_attendance=2 if q118==3
		
			}
	
		replace ilo_edu_attendance=3 if ilo_edu_attendance==.
			lab def edu_attendance_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
			lab val ilo_edu_attendance edu_attendance_lab
			lab var ilo_edu_attendance "Education (Attendance)" 
				


* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			           Marital status ('ilo_mrts') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: there is no information on union/cohabiting status
	
	* Detailed
	gen ilo_mrts_details=.
	    replace ilo_mrts_details=1 if marstat==1                                           // Single
		replace ilo_mrts_details=2 if marstat==2                                           // Married
		*replace ilo_mrts_details=3 if                                                    // Union / cohabiting   *** NO INFO
		replace ilo_mrts_details=4 if marstat==3                                           // Widowed
		replace ilo_mrts_details=5 if marstat==4                                          // Divorced / separated
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
*			Disability status ('ilo_dsb_details') [no info available]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment: Disability could only be defined at the aggregate level, but given that the question is not being asked to the 
	* entire population but only to people outside the labour force, don't define it


	
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
		replace ilo_wap=0 if ilo_age<15
			label def ilo_wap_lab 1 "Working age population"
			label val ilo_wap ilo_wap_lab
			label var ilo_wap "Working age population" //15+ population

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Labour Force Status ('ilo_lfs') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*            	 
* Comment: 	Variable included in original dataset: wstatut

		* for people in employment --> follow filters such as used by NSO
		
	if time>=2009 {
	
	gen ilo_lfs=.
		replace ilo_lfs=1 if inrange(q19,2,6) | (nowkreas==1 & inlist(q21a,1,2,3)) | nowkreas==8 | (nowkreas==9 & inlist(q22,1,2)) | (q25==1 & nowkreas!=3 & q22==1) | (inlist(q25,2,3) & inlist(q22,1,2)) | (q25==4 & q22==1)
		replace ilo_lfs=2 if ilo_lfs!=1 & (q103==1 | q104==1) & q113==1 & q108!=1
		replace ilo_lfs=3 if !inlist(ilo_lfs,1,2)
			replace ilo_lfs=. if ilo_wap!=1	
				label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status" 
				
				}
		
	
	if time==2008 {

	gen ilo_lfs=.
		replace ilo_lfs=1 if inrange(q19,2,6) | (q21==1 & inlist(q21_a,1,2,3)) | q21==8 | (q21==9 & inlist(q22,1,2)) | (q25==1 & q21!=3 & q22==1) | (inlist(q25,2,3) & inlist(q22,1,2)) | (q25==4 & q22==1)
		replace ilo_lfs=2 if ilo_lfs!=1 & (q74==1 | q75==1) & q84==1 & q79!=1
		replace ilo_lfs=3 if !inlist(ilo_lfs,1,2)
			replace ilo_lfs=. if ilo_wap!=1	
				label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status" 
				
				}
				
	if time==2007 {
		
	gen ilo_lfs=.
		replace ilo_lfs=1 if inrange(q19,2,5) | (nowkreas==1 & inlist(q21_a,1,2,3)) | nowkreas==8 | (nowkreas==9 & inlist(q22,1,2)) | (q25==1 & nowkreas!=3 & q22==1) | (inlist(q25,2,3) & inlist(q22,1,2)) | (q25==4 & q22==1)
		replace ilo_lfs=2 if ilo_lfs!=1 & (q74==1 | q75==1) & q84==1 & q79!=1
		replace ilo_lfs=3 if !inlist(ilo_lfs,1,2)
			replace ilo_lfs=. if ilo_wap!=1	
				label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status" 
				
			}
			
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

if time>=2009 {

	gen ilo_mjh=.
		replace ilo_mjh=1 if q71==2
		replace ilo_mjh=2 if q71==1
		}
		
else {

	gen ilo_mjh=.
		replace ilo_mjh=1 if q55==2
		replace ilo_mjh=2 if q55==1
			}
						
		replace ilo_mjh=. if ilo_lfs!=1
			lab def lab_ilo_mjh 1 "1 - One job only" 2 "2 - More than one job"
			lab val ilo_mjh lab_ilo_mjh
			lab var ilo_mjh "Multiple job holders"		
			

***********************************************************************************************
*			PART 3.1. ECONOMIC CHARACTERISTICS FOR MAIN JOB 
***********************************************************************************************	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Status in employment ('ilo_ste')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	* Primary activity
	
		gen ilo_job1_ste_icse93=.
			replace ilo_job1_ste_icse93=1 if q25==1 | q29==1
			replace ilo_job1_ste_icse93=2 if q25==2 | q29==2
			replace ilo_job1_ste_icse93=3 if q25==3 | q29==3
			/* replace ilo_job1_ste_icse93=4 if */
			replace ilo_job1_ste_icse93=5 if q25==4 | q29==4 
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

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: ISIC Rev. 3.1 (NACE Rev. 1.1)  being used and initially indicated on 2-digits level 

	* Economic activity for secondary activity only indicated using descriptions in Albanian - don't capture information
	
	if time==2008 {
	
	decode mainjob_nace if !inlist(mainjob_nace,52,53) & ilo_lfs==1, gen(indu_code_prim)
	
	destring indu_code_prim, replace
	
	}
	
	else {
	
	capture confirm variable p40_nace 
	
		if !_rc {
		
	gen indu_code_prim=p40_nace if ilo_lfs==1
	
		}
		
	else {
	
	gen indu_code_prim=q40_nace if ilo_lfs==1
	
		}
	
	}


			
		* Primary activity
		
		gen ilo_job1_eco_isic3_2digits=indu_code_prim
			replace ilo_job1_eco_isic3_2digits=. if ilo_lfs!=1
			    lab def eco_isic3_2digits 1 "01 - Agriculture, hunting and related service activities"	2 "02 - Forestry, logging and related service activities"	5 "05 - Fishing, operation of fish hatcheries and fish farms; service activities incidental to fishing"	10 "10 - Mining of coal and lignite; extraction of peat"	///
                                          11 "11 - Extraction of crude petroleum and natural gas; service activities incidental to oil and gas extraction excluding surveying"	12 "12 - Mining of uranium and thorium ores"	13 "13 - Mining of metal ores"	14 "14 - Other mining and quarrying"	///
                                          15 "15 - Manufacture of food products and beverages"	16 "16 - Manufacture of tobacco products"	17 "17 - Manufacture of textiles"	18 "18 - Manufacture of wearing apparel; dressing and dyeing of fur"	///
                                          19 "19 - Tanning and dressing of leather; manufacture of luggage, handbags, saddlery, harness and footwear"	20 "20 - Manufacture of wood and of products of wood and cork, except furniture; manufacture of articles of straw and plaiting materials"	21 "21 - Manufacture of paper and paper products"	22 "22 - Publishing, printing and reproduction of recorded media"	///
                                          23 "23 - Manufacture of coke, refined petroleum products and nuclear fuel"	24 "24 - Manufacture of chemicals and chemical products"	25 "25 - Manufacture of rubber and plastics products"	26 "26 - Manufacture of other non-metallic mineral products"	///
                                          27 "27 - Manufacture of basic metals"	28 "28 - Manufacture of fabricated metal products, except machinery and equipment"	29 "29 - Manufacture of machinery and equipment n.e.c."	30 "30 - Manufacture of office, accounting and computing machinery"	///
                                          31 "31 - Manufacture of electrical machinery and apparatus n.e.c."	32 "32 - Manufacture of radio, television and communication equipment and apparatus"	33 "33 - Manufacture of medical, precision and optical instruments, watches and clocks"	34 "34 - Manufacture of motor vehicles, trailers and semi-trailers"	///
                                          35 "35 - Manufacture of other transport equipment"	36 "36 - Manufacture of furniture; manufacturing n.e.c."	37 "37 - Recycling"	40 "40 - Electricity, gas, steam and hot water supply"	///
                                          41 "41 - Collection, purification and distribution of water"	45 "45 - Construction"	50 "50 - Sale, maintenance and repair of motor vehicles and motorcycles; retail sale of automotive fuel"	51 "51 - Wholesale trade and commission trade, except of motor vehicles and motorcycles"	///
                                          52 "52 - Retail trade, except of motor vehicles and motorcycles; repair of personal and household goods"	55 "55 - Hotels and restaurants"	60 "60 - Land transport; transport via pipelines"	61 "61 - Water transport"	///
                                          62 "62 - Air transport"	63 "63 - Supporting and auxiliary transport activities; activities of travel agencies"	64 "64 - Post and telecommunications"	65 "65 - Financial intermediation, except insurance and pension funding"	///
                                          66 "66 - Insurance and pension funding, except compulsory social security"	67 "67 - Activities auxiliary to financial intermediation"	70 "70 - Real estate activities"	71 "71 - Renting of machinery and equipment without operator and of personal and household goods"	///
                                          72 "72 - Computer and related activities"	73 "73 - Research and development"	74 "74 - Other business activities"	75 "75 - Public administration and defence; compulsory social security"	///
                                          80 "80 - Education"	85 "85 - Health and social work"	90 "90 - Sewage and refuse disposal, sanitation and similar activities"	91 "91 - Activities of membership organizations n.e.c."	///
                                          92 "92 - Recreational, cultural and sporting activities"	93 "93 - Other service activities"	95 "95 - Activities of private households as employers of domestic staff"	96 "96 - Undifferentiated goods-producing activities of private households for own use"	///
                                          97 "97 - Undifferentiated service-producing activities of private households for own use"	99 "99 - Extra-territorial organizations and bodies"			
                lab val ilo_job1_eco_isic3_2digits eco_isic3_2digits
                lab var ilo_job1_eco_isic3_2digits "Economic activity (ISIC Rev. 3.1), 2 digits level - main job"
	
	* One digit level
	
	gen ilo_job1_eco_isic3=.
		replace ilo_job1_eco_isic3=1 if inrange(ilo_job1_eco_isic3_2digits,1,2)
		replace ilo_job1_eco_isic3=2 if ilo_job1_eco_isic3_2digits==5
		replace ilo_job1_eco_isic3=3 if inrange(ilo_job1_eco_isic3_2digits,10,14)
		replace ilo_job1_eco_isic3=4 if inrange(ilo_job1_eco_isic3_2digits,15,37)
		replace ilo_job1_eco_isic3=5 if inrange(ilo_job1_eco_isic3_2digits,40,41)
		replace ilo_job1_eco_isic3=6 if ilo_job1_eco_isic3_2digits==45
		replace ilo_job1_eco_isic3=7 if inrange(ilo_job1_eco_isic3_2digits,50,52)
		replace ilo_job1_eco_isic3=8 if ilo_job1_eco_isic3_2digits==55
		replace ilo_job1_eco_isic3=9 if inrange(ilo_job1_eco_isic3_2digits,60,64)
		replace ilo_job1_eco_isic3=10 if inrange(ilo_job1_eco_isic3_2digits,65,67)
		replace ilo_job1_eco_isic3=11 if inrange(ilo_job1_eco_isic3_2digits,70,74)
		replace ilo_job1_eco_isic3=12 if ilo_job1_eco_isic3_2digits==75
		replace ilo_job1_eco_isic3=13 if ilo_job1_eco_isic3_2digits==80
		replace ilo_job1_eco_isic3=14 if ilo_job1_eco_isic3_2digits==85
		replace ilo_job1_eco_isic3=15 if inrange(ilo_job1_eco_isic3_2digits,90,93)
		replace ilo_job1_eco_isic3=16 if ilo_job1_eco_isic3_2digits==95
		replace ilo_job1_eco_isic3=17 if ilo_job1_eco_isic3_2digits==99
		replace ilo_job1_eco_isic3=18 if ilo_job1_eco_isic3_2digits==. & ilo_lfs==1
			lab val ilo_job1_eco_isic3 isic3
			lab var ilo_job1_eco_isic3 "Economic activity (ISIC Rev. 3.1)"
	
	* Primary activity
	
	gen ilo_job1_eco_aggregate=.
		replace ilo_job1_eco_aggregate=1 if inlist(ilo_job1_eco_isic3,1,2)
		replace ilo_job1_eco_aggregate=2 if ilo_job1_eco_isic3==4
		replace ilo_job1_eco_aggregate=3 if ilo_job1_eco_isic3==6
		replace ilo_job1_eco_aggregate=4 if inlist(ilo_job1_eco_isic3,3,5)
		replace ilo_job1_eco_aggregate=5 if inrange(ilo_job1_eco_isic3,7,11)
		replace ilo_job1_eco_aggregate=6 if inrange(ilo_job1_eco_isic3,12,17)
		replace ilo_job1_eco_aggregate=7 if ilo_job1_eco_isic3==18
			lab def eco_aggr_lab 1 "1 - Agriculture" 2 "2 - Manufacturing" 3 "3 - Construction" 4 "4 - Mining and quarrying; Electricity, gas and water supply" ///
								5 "5 - Market Services (Trade; Transportation; Accommodation and food; and Business and administrative services)"  ///
								6 "6 - Non-market services (Public administration; Community, social and other services and activities)" 7 "7 - Not classifiable by economic activity"					
			lab val ilo_job1_eco_aggregate eco_aggr_lab
			lab var ilo_job1_eco_aggregate "Economic activity (Aggregate)"

			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_ocu')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: No info on occupation in secondary activity

	* ISCO-88 classification used 	
	
		gen occ_code_prim=int(isco3d/10) if ilo_lfs==1 & isco3d!=9999
		
	* 2 digit level
	
		* Primary occupation
		
		gen ilo_job1_ocu_isco88_2digits=occ_code_prim
			replace ilo_job1_ocu_isco88_2digits=. if ilo_lfs!=1
				lab def ocu_isco88_2digits 1 "01 - Armed forces"	11 "11 - Legislators and senior officials"	12 "12 - Corporate managers"	13 "13 - General managers"	///
                                           21 "21 - Physical, mathematical and engineering science professionals"	22 "22 - Life science and health professionals"	23 "23 - Teaching professionals"	24 "24 - Other professionals"	///
                                           31 "31 - Physical and engineering science associate professionals"	32 "32 - Life science and health associate professionals"	33 "33 - Teaching associate professionals"	34 "34 - Other associate professionals"	///
                                           41 "41 - Office clerks"	42 "42 - Customer services clerks"	51 "51 - Personal and protective services workers"	52 "52 - Models, salespersons and demonstrators"	///
                                           61 "61 - Skilled agricultural and fishery workers"	62 "62 - Subsistence agricultural and fishery workers"	71 "71 - Extraction and building trades workers"	72 "72 - Metal, machinery and related trades workers"	///
                                           73 "73 - Precision, handicraft, craft printing and related trades workers"	74 "74 - Other craft and related trades workers"	81 "81 - Stationary plant and related operators"	82 "82 - Machine operators and assemblers"	///
                                           83 "83 - Drivers and mobile plant operators"	91 "91 - Sales and services elementary occupations"	92 "92 - Agricultural, fishery and related labourers"	93 "93 - Labourers in mining, construction, manufacturing and transport"	
	            lab values ilo_job1_ocu_isco88_2digits ocu_isco88_2digits
	            lab var ilo_job1_ocu_isco88_2digits "Occupation (ISCO-88), 2 digit level - main job"
		
	* 1 digit level
	
	gen occ_code_prim_1dig=int(occ_code_prim/10) if ilo_lfs==1
	
		* Primary activity
		
		gen ilo_job1_ocu_isco88=occ_code_prim_1dig
			replace ilo_job1_ocu_isco88=10 if ilo_job1_ocu_isco88==0
			replace ilo_job1_ocu_isco88=11 if ilo_job1_ocu_isco88==. & ilo_lfs==1
			lab def isco88_1dig_lab 1 "1 - Managers" 2 "2 - Professionals" 3 "Technicians and associate professionals" 4 "4 - Clerks" 5 "5 - Service workers and shop and market sales workers" ///
									6 "6 - Skilled agricultural and fishery workers" 7 "7 - Craft and related trades workers" 8 "8 - Plant and machine operators, and assemblers" ///
									9 "9 - Elementary occupations" 10 "0 - Armed forces occupations" 11 "X - Not elsewhere classified"
			lab val ilo_job1_ocu_isco88 isco88_1dig_lab
			lab var ilo_job1_ocu_isco88 "Occupation (ISCO-88)"	
			
			
	* Aggregate level
	
		* Primary occupation
	
		gen ilo_job1_ocu_aggregate=.
			replace ilo_job1_ocu_aggregate=1 if inrange(ilo_job1_ocu_isco88,1,3)
			replace ilo_job1_ocu_aggregate=2 if inlist(ilo_job1_ocu_isco88,4,5)
			replace ilo_job1_ocu_aggregate=3 if inlist(ilo_job1_ocu_isco88,6,7)
			replace ilo_job1_ocu_aggregate=4 if ilo_job1_ocu_isco88==8
			replace ilo_job1_ocu_aggregate=5 if ilo_job1_ocu_isco88==9
			replace ilo_job1_ocu_aggregate=6 if ilo_job1_ocu_isco88==10
			replace ilo_job1_ocu_aggregate=7 if ilo_job1_ocu_isco88==11
				lab def ocu_aggr_lab 1 "1 - Managers, professionals, and technicians" 2 "2 - Clerical, service and sales workers" 3 "3 - Skilled agricultural and trades workers" ///
									4 "4 - Plant and machine operators, and assemblers" 5 "5 - Elementary occupations" 6 "6 - Armed forces" 7 "7 - Not elsewhere classified"
				lab val ilo_job1_ocu_aggregate ocu_aggr_lab
				lab var ilo_job1_ocu_aggregate "Occupation (Aggregate)"
				
	* Skill level
	
		* Primary occupation
	
		gen ilo_job1_ocu_skill=.
			replace ilo_job1_ocu_skill=1 if ilo_job1_ocu_isco88==9
			replace ilo_job1_ocu_skill=2 if inlist(ilo_job1_ocu_isco88,4,5,6,7,8)
			replace ilo_job1_ocu_skill=3 if inlist(ilo_job1_ocu_isco88,1,2,3)
			replace ilo_job1_ocu_skill=4 if inlist(ilo_job1_ocu_isco88,10,11)
				lab def ocu_skill_lab 1 "1 - Skill level 1 (low)" 2 "2 - Skill level 2 (medium)" 3 "3 - Skill levels 3 and 4 (high)" 4 "4 - Not elsewhere classified"
				lab val ilo_job1_ocu_skill ocu_skill_lab
				lab var ilo_job1_ocu_skill "Occupation (Skill level)"
						
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_ins_sector')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	
	* Primary occupation
	
	gen ilo_job1_ins_sector=.
		replace ilo_job1_ins_sector=1 if inlist(q36,1,2,3)
		replace ilo_job1_ins_sector=2 if ilo_job1_ins_sector==. & ilo_lfs==1
				replace ilo_job1_ins_sector=. if ilo_lfs!=1
			lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
			lab values ilo_job1_ins_sector ins_sector_lab
			lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities"
			

* --------------------------------------------------------------------------------------------------
* --------------------------------------------------------------------------------------------------
*		Weekly hours actually (USUALLY) worked ('ilo_how_actual') and ('ilo_how_usual')
* --------------------------------------------------------------------------------------------------
* --------------------------------------------------------------------------------------------------
* 
* Comment: consider first working time associated with each job (if available) and then consider the sum (i.e.
				* the time dedicated to all working activities during the week
				
	* Actual hours worked are only being indicated for all jobs together
	
		* Primary job
		
		gen ilo_job1_how_actual=q47
			replace ilo_job1_how_actual=. if ilo_lfs!=1
			lab var ilo_job1_how_actual "Weekly hours actually worked in main job"
			
		* Secondary job
		
		if time<=2008 {
		
		gen ilo_job2_how_actual=q58 
			}
		
		else {
		
		gen ilo_job2_how_actual=q74
		
			}
						
			replace ilo_job2_how_actual=. if ilo_lfs!=1 & ilo_mjh!=2
			lab var ilo_job2_how_actual "Weekly hours actually worked in secondary job"
		
		* All jobs
		
		egen ilo_joball_how_actual=rowtotal(ilo_job*_how_actual), m
			replace ilo_joball_how_actual=. if ilo_lfs!=1
			lab var ilo_joball_how_actual "Weekly hours actually worked in all jobs"
	
	* Hours usually worked (only info about main job)
	
		* Primary job
		
		gen ilo_job1_how_usual=q46 
			replace ilo_job1_how_usual=. if ilo_lfs!=1
			lab var ilo_job1_how_usual "Weekly hours usually worked in main job"			
		
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
				
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job_time')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment: pre-defined variable being used
		
		gen ilo_job1_job_time=.
			replace ilo_job1_job_time=1 if q44==2
			replace ilo_job1_job_time=2 if q44==1
			replace ilo_job1_job_time=3 if ilo_job1_job_time==. & ilo_lfs==1
					replace ilo_job1_job_time=. if ilo_lfs!=1
				lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
				lab val ilo_job1_job_time job_time_lab
				lab var ilo_job1_job_time "Job (Working time arrangement)"	
			
			* if there is any secondary employment, by definition it is part-time, and therefore
			* variable for secondary employment not being defined
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job_contract')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
		
		gen ilo_job1_job_contract=.
			replace ilo_job1_job_contract=1 if q31==2
			replace ilo_job1_job_contract=2 if q31==1
			replace ilo_job1_job_contract=3 if ilo_job1_job_contract==. & ilo_job1_ste_aggregate==1
					replace ilo_job1_job_contract=. if ilo_lfs!=1
				lab def job_contract_lab 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"
				lab val ilo_job1_job_contract job_contract_lab
				lab var ilo_job1_job_contract "Job (Type of contract)"
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Informal/Formal economy: Unit of production (ilo_job1_ife_prod) [can't be defined]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* 
* Comment: not enough criteria to be able to define variable
	
	* Useful questions: q36: Institutional sector
					* q19: Destination of production (use question used for identification of people in labour force)
					* [no info]: Bookkeeping
					* [no info]: Registration
					* q37: Social security
					* [no info]: Location of workplace
					* q41 (or sizefirm) and q41_a: Size of enterprise
			
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Informal/formal economy: nature of job (ilo_job1_ife_nature) [can't be defined]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------


	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Earnings ('ilo_ear_ees' and 'ilo_ear_slf')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	
* Comment: info available only starting from 2009.
	
	* Currency in Albania: Lek
	
	if time>=2009 {
	
	* Primary employment 
	
			* Monthly earnings of employees
			
			egen helpvar_1=max(q56)
			
			decode q56 if q56!=helpvar_1, gen(net_payment)
					destring net_payment, replace force
				replace net_payment=net_payment if q57==1
				replace net_payment=(net_payment*2) if q57==2
				replace net_payment=(net_payment*4) if q57==3
				replace net_payment=(net_payment*365/12) if q57==4
				
					replace net_payment=. if net_payment>9000000				
				
			egen helpvar_2=max(q61)
				
			decode q61 if q61!=helpvar_2, gen(bonus)
					destring bonus, replace
					replace bonus=. if bonus==99999999
				replace bonus=(bonus/12)
			
			egen helpvar_3=max(q64)
			
			capture confirm label Q64 
				if !_rc {						
			decode q64 if q64!=helpvar_3, gen(in_kind) 	
					destring in_kind, replace
					}
					
			else {
				gen in_kind=q64 
					}
					replace in_kind=. if in_kind==99999999
				replace in_kind=(in_kind/12)
			
		egen ilo_job1_lri_ees=rowtotal(net_payment bonus in_kind),m 
			replace ilo_job1_lri_ees=. if ilo_lfs!=1 | ilo_job1_lri_ees<0
			lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"

			* Self employment
		
		* note that the revenue related to self-employment includes also the value of own consumption 
			* (cf. resolution from 1998)
			
		egen helpvar_4=max(q69)
		
		decode q69 if q69!=helpvar_4, gen(profit)
			destring profit, replace
			replace profit=. if profit==99999999
			
		egen helpvar_5=max(q70)
		
		decode q70 if q70!=helpvar_5, gen(loss)
			destring loss, replace
			replace loss=. if loss==99999999
			replace loss=-loss
			
		egen ilo_job1_lri_slf=rowtotal(profit loss), m
			replace ilo_job1_lri_slf=. if ilo_lfs!=1
			lab var ilo_job1_lri_slf "Monthly labour related income of self-employed in main job"
			
		* drop help variables
		
		drop net_payment bonus in_kind profit loss helpvar_*
			
				}
	
	
***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************			

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_tru') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*                
* Comment: question on availability not included in dataset - people having answered to question 87a considered as being available (additional number of hours
				* that person is willing to work more during reference week)

	if time<=2008 {
	
	gen ilo_joball_tru=1 if ilo_job1_job_time==1 & q59==1 & !inlist(q60,0,.)
			
			}
			
	else {
	
	gen ilo_joball_tru=1 if ilo_job1_job_time==1 & q88==1 & !inlist(q89,0,.)	
		}
	
	replace ilo_joball_tru=. if ilo_lfs!=1
			lab def tru_lab 1 "Time-related underemployment"
			lab val ilo_joball_tru tru_lab
			lab var ilo_joball_tru "Time-related underemployment"	
			
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Cases of non-fatal occupational injury ('ilo_joball_oi_case') [not available]
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*
* Comment: no info available


*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Days lost due to cases of occupational injury ('ilo_joball_oi_day') [not available]
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*
* Comment: no info available


	
***********************************************************************************************
*			PART 3.3. UNEMPLOYMENT: ECONOMIC CHARACTERISTICS
***********************************************************************************************	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment:	Question asks how much time the person has spent looking for another job

	if time<=2008 {
	
		clonevar job_search=q79
		
			}
			
	else {
	
		clonevar job_search=q108
		
			}
	
	gen ilo_dur_details=.
		replace ilo_dur_details=1 if job_search==2
		replace ilo_dur_details=2 if job_search==3
		replace ilo_dur_details=3 if job_search==4
		replace ilo_dur_details=4 if job_search==5
		replace ilo_dur_details=5 if inlist(job_search,6,7)
		replace ilo_dur_details=6 if inlist(job_search,8,9)
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
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Category of unemployment ('ilo_cat_une')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------


	if time<=2008 {
	
		clonevar prev_une=q68
		
			}
			
	else {
	
	if time==2010 {
	
		clonevar prev_une=p97
		
			}
			
		else {
	
		clonevar prev_une=q97
			
			}
			}
			
	gen ilo_cat_une=.
		replace ilo_cat_une=1 if prev_une==1
		replace ilo_cat_une=2 if prev_une==2
		replace ilo_cat_une=3 if ilo_cat_une==. & ilo_lfs==2
				replace ilo_cat_une=. if ilo_lfs!=2
			lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
			lab val ilo_cat_une cat_une_lab
			lab var ilo_cat_une "Category of unemployment"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: no codes given, info only in Albanian


	gen preveco_cod=nacepr2d if ilo_cat_une==1
	
	* One-digit level
	
	gen ilo_preveco_isic3=.
		replace ilo_preveco_isic3=1 if inrange(preveco_cod,1,2)
		replace ilo_preveco_isic3=2 if preveco_cod==5
		replace ilo_preveco_isic3=3 if inrange(preveco_cod,10,14)
		replace ilo_preveco_isic3=4 if inrange(preveco_cod,15,37)
		replace ilo_preveco_isic3=5 if inrange(preveco_cod,40,41)
		replace ilo_preveco_isic3=6 if preveco_cod==45
		replace ilo_preveco_isic3=7 if inrange(preveco_cod,50,52)
		replace ilo_preveco_isic3=8 if preveco_cod==55
		replace ilo_preveco_isic3=9 if inrange(preveco_cod,60,64)
		replace ilo_preveco_isic3=10 if inrange(preveco_cod,65,67)
		replace ilo_preveco_isic3=11 if inrange(preveco_cod,70,74)
		replace ilo_preveco_isic3=12 if preveco_cod==75
		replace ilo_preveco_isic3=13 if preveco_cod==80
		replace ilo_preveco_isic3=14 if preveco_cod==85
		replace ilo_preveco_isic3=15 if inrange(preveco_cod,90,93)
		replace ilo_preveco_isic3=16 if preveco_cod==95
		replace ilo_preveco_isic3=17 if preveco_cod==99
		replace ilo_preveco_isic3=18 if preveco_cod==. & ilo_cat_une==1
			lab val ilo_preveco_isic3 isic3
			lab var ilo_preveco_isic3 "Previous economic activity (ISIC Rev. 3.1)"
			
	* Now do the classification on an aggregate level
	
	* Primary activity
	
	gen ilo_preveco_aggregate=.
		replace ilo_preveco_aggregate=1 if inlist(ilo_preveco_isic3,1,2)
		replace ilo_preveco_aggregate=2 if ilo_preveco_isic3==4
		replace ilo_preveco_aggregate=3 if ilo_preveco_isic3==6
		replace ilo_preveco_aggregate=4 if inlist(ilo_preveco_isic3,3,5)
		replace ilo_preveco_aggregate=5 if inrange(ilo_preveco_isic3,7,11)
		replace ilo_preveco_aggregate=6 if inrange(ilo_preveco_isic3,12,17)
		replace ilo_preveco_aggregate=7 if ilo_preveco_isic3==18
			* value label already defined				
			lab val ilo_preveco_aggregate eco_aggr_lab
			lab var ilo_preveco_aggregate "Previous economic activity (Aggregate)"
			
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen prevocu_cod=int(iscopr3d/100) if ilo_cat_une==1

	gen ilo_prevocu_isco88=prevocu_cod
			replace ilo_prevocu_isco88=10 if ilo_prevocu_isco88==0
			replace ilo_prevocu_isco88=11 if ilo_prevocu_isco88==. & ilo_cat_une==1
			* value labels already defined
			lab val ilo_prevocu_isco88 isco88_1dig_lab
			lab var ilo_prevocu_isco88 "Previous occupation (ISCO-88)"	
			
			
	* Aggregate level
	
		* Primary occupation
	
		gen ilo_prevocu_aggregate=.
			replace ilo_prevocu_aggregate=1 if inrange(ilo_prevocu_isco88,1,3)
			replace ilo_prevocu_aggregate=2 if inlist(ilo_prevocu_isco88,4,5)
			replace ilo_prevocu_aggregate=3 if inlist(ilo_prevocu_isco88,6,7)
			replace ilo_prevocu_aggregate=4 if ilo_prevocu_isco88==8
			replace ilo_prevocu_aggregate=5 if ilo_prevocu_isco88==9
			replace ilo_prevocu_aggregate=6 if ilo_prevocu_isco88==10
			replace ilo_prevocu_aggregate=7 if ilo_prevocu_isco88==11
				* value labels already defined
				lab val ilo_prevocu_aggregate ocu_aggr_lab
				lab var ilo_prevocu_aggregate "Previous occupation (Aggregate)"
				
	* Skill level
	
		* Primary occupation
	
		gen ilo_prevocu_skill=.
			replace ilo_prevocu_skill=1 if ilo_prevocu_isco88==9
			replace ilo_prevocu_skill=2 if inlist(ilo_prevocu_isco88,4,5,6,7,8)
			replace ilo_prevocu_skill=3 if inlist(ilo_prevocu_isco88,1,2,3)
			replace ilo_prevocu_skill=4 if inlist(ilo_prevocu_isco88,10,11)
				* value labels already defined
				lab val ilo_prevocu_skill ocu_skill_lab
				lab var ilo_prevocu_skill "Previous occupation (Skill level)"



			
***********************************************************************************************
*			PART 3.4. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: Share of observations falling into category "not elsewhere classified" very high --> don't keep variable
	
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reasons for not seeking a job ('ilo_olf_reason')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	
	if time<=2008 {
	
		clonevar olf_reas=q76
		
			}
			
	else {
		
		clonevar olf_reas=seekreas
		
			}
	
	gen ilo_olf_reason=.
		replace ilo_olf_reason=1 if olf_reas==6
		replace ilo_olf_reason=2 if inlist(olf_reas,1,2,3,4,7)
		replace ilo_olf_reason=3 if olf_reas==5
		replace ilo_olf_reason=4 if ilo_olf_reason==. & ilo_lfs==3
			replace ilo_olf_reason=. if ilo_lfs!=3
			lab def lab_olf_reason 1 "1 - Labour market" 2 "2 - Personal/Family-related"  3 "3 - Does not need/want to work" 4 "4 - Not elsewhere classified"
			lab val ilo_olf_reason lab_olf_reason
			lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"
	
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seekers ('ilo_dis') 
* -------------------------------------------------------------------------------------------
* ------------------------------------------------------------------------------------------- 
	

	if time<=2008 {
		gen ilo_dis=1 if ilo_lfs==3 & ilo_olf_reason==1 & q84==1
		
			}
			
		else {
		
		gen ilo_dis=1 if ilo_lfs==3 & ilo_olf_reason==1 & q113==1
		
		}		
		
		lab def ilo_dis_lab 1 "Discouraged job-seekers" 
			lab val ilo_dis ilo_dis_lab
			lab var ilo_dis "Discouraged job-seekers"
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training (NEETs) ('ilo_neet') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: No reference period specified, question asked "are you currently going to class?"

		gen ilo_neet=.
			replace ilo_neet=1 if inrange(ilo_age,15,24) & ilo_lfs!=1 & ilo_edu_attendance==2
				lab def ilo_neet_lab 1 "Youth not in education, employment or training"
				lab val ilo_neet ilo_neet_lab
				lab var ilo_neet "Youth not in education, employment or training"
		
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

*			SAVE RESULTS

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* -------------------------------------------------------------
* 1.	Prepare final datasets
* -------------------------------------------------------------

cd "$outpath"
		
		drop ilo_age /* as only age bands being kept and this variable used as help variable */
		
		drop indu_code_prim occ_code_prim occ_code_prim_1dig preveco_cod prevocu_cod
		
		order ilo*, last
	
		compress 
		
	* Save dataset including original and ilo variables
	
		save ${country}_${source}_${time}_FULL,  replace		
	
	*Save file only containing ilo_* variables
	
		keep ilo*
		
		capture confirm variable ilo_nace 
		
			if !_rc {
		
		drop ilo_nace
		
			}

		save ${country}_${source}_${time}_ILO, replace		
		
