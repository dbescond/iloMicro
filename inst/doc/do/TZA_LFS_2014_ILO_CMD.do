* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Tanzania, 2014
* DATASET USED: Tanzania LFS 2014
* NOTES: 
* Files created: Standard variables on LFS Tanzania 2014
* Authors: ILO / Department of Statistics / DPAU

* Starting Date: 21 October 2016
* Last updated: 08 February 2018
***********************************************************************************************



*******************************************************************
 /* 1.	Set up work directory, file name, variables and function */
*******************************************************************

clear all 

set more off

global path "J:\DPAU\MICRO"
global country "TZA"
global source "LFS"
global time "2014"
global inputFile "2014_ILFS_DATASET.dta"

global inpath "${path}\\${country}\\${source}\\${time}\\ORI"
global temppath "${path}\\_Admin"
global outpath "${path}\\${country}\\${source}\\${time}"

********************************************************************************
********************************************************************************

cd "$inpath"
	use ${inputFile}, clear
	*renaming everything in lower case
	*rename *, lower  
		
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

	gen ilo_wgt=ADJWT
		lab var ilo_wgt "Sample weight"	
	
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
*
	gen ilo_geo=GEOG_2
		lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural"
		lab val ilo_geo ilo_geo_lab
		lab var ilo_geo "Geographical coverage"	
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: 

		gen ilo_sex=Q04_SEX
			label define label_Sex 1 "1 - Male" 2 "2 - Female"
			label values ilo_sex label_Sex
			lab var ilo_sex "Sex"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: Age above 97 not indicated, highest value corresponds to "97 and above"

	gen ilo_age=Q05B_AGE
		replace ilo_age=. if inlist(ilo_age,98,99) /* As it corresponds to the labels "Do not know" and "Not stated" */
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
* Comment: Given the definition of the levels of education, ISCED97 is being chosen
			
		* Refer to ISCED Mapping for Tanzania: http://www.uis.unesco.org/Education/ISCEDMappings/Documents/Sub-Saharan%20Africa/Tanzania_ISCED_mapping.xls 
			
			* Other useful info: http://www.classbase.com/countries/Tanzania/Education-System
								
			* Note that according to the definition, the highest level being CONCLUDED is being considered -> therefore question asking whether level COMPLETED is being considered!
			
			* note that there is no info about any kind of advanced tertiary education
			* Adult education put at level 2 "Lower secondary", given that it includes programs in literacy (http://isw.sagepub.com/content/22/3/38.abstract) [following description in 
				* technical document: http://www.uis.unesco.org/Library/Documents/isced97-en.pdf ]

	gen ilo_edu_isced97=.
		replace ilo_edu_isced97=1 if Q15_EDSTAT==4 | (inlist(Q15_EDSTAT,2,3) & Q17A_EDUCA==1) | Q17A_EDUCA==0
		replace ilo_edu_isced97=2 if (Q17A_EDUCA==1 & Q15_EDSTAT==1) | inrange(Q17A_EDUCA,2,7) | (Q17A_EDUCA==8 & inlist(Q15_EDSTAT,2,3))
		replace ilo_edu_isced97=3 if (Q17A_EDUCA==8 & Q15_EDSTAT==1) | (inlist(Q17A_EDUCA,9,10,14) & inlist(Q15_EDSTAT,2,3)) | inlist(Q17A_EDUCA,11,12,13)  
		replace ilo_edu_isced97=4 if (inlist(Q17A_EDUCA,9,10,14) & Q15_EDSTAT==1) | (inlist(Q17A_EDUCA,15,17) & inlist(Q15_EDSTAT,2,3)) | Q17A_EDUCA==16
		replace ilo_edu_isced97=5 if (inlist(Q17A_EDUCA,15,17) & Q15_EDSTAT==1) | (inlist(Q17A_EDUCA,18,19,20) & inlist(Q15_EDSTAT,2,3))
		replace ilo_edu_isced97=6 if (inlist(Q17A_EDUCA,18,19) & Q15_EDSTAT==1)
		replace ilo_edu_isced97=7 if Q17A_EDUCA==20 & Q15_EDSTAT==1
		/* replace ilo_edu_isced97=8 if Q17A_EDUCA */
		replace ilo_edu_isced97=9 if ilo_edu_isced97==.
			label def isced_97_lab 1 "X - No schooling" 2 "0 - Pre-primary education" 3 "1 - Primary education or first stage of basic education" 4 "2 - Lower secondary education or second stage of basic education" ///
							5 "3 - Upper secondary education" 6 "4 - Post-secondary non-tertiary education" 7 "5 - First stage of tertiary education (not leading directly to an advanced research qualification)" ///
							8 "6 - Second stage of tertiary education (leading to an advanced research qualification)" 9 "UNK - Level not stated"
			label val ilo_edu_isced97 isced_97_lab
			lab var ilo_edu_isced97 "Education (ISCED 97)"


		* for the definition, cf. the document "Guide to reporting labour statistics to the ILO using the Excel questionnaire"
		
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
*			Education attendance ('ilo_edu_attendance') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: 

		gen ilo_edu_attendance=.
			replace ilo_edu_attendance=1 if Q15_EDSTAT==2
			replace ilo_edu_attendance=2 if inlist(Q15_EDSTAT,1,3,4)
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
	    replace ilo_mrts_details=1 if Q09_MARSTAT==1                            // Single
		replace ilo_mrts_details=2 if Q09_MARSTAT==2                            // Married
		replace ilo_mrts_details=3 if Q09_MARSTAT==3                            // Union / cohabiting
		replace ilo_mrts_details=4 if Q09_MARSTAT==4                            // Widowed
		replace ilo_mrts_details=5 if Q09_MARSTAT==5                            // Divorced / separated
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
*			Disability status ('ilo_dsb_details') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment: 
		* Q07B: Seeing
		* Q07C: Hearing
		* Q07D: Walking
		* Q07E: Remembering
		* Q07F: Self-care
		* Q07G: Communication problems (understand/being understood)
	
	gen ilo_dsb_details=.
		replace ilo_dsb_details=1 if Q07B==1 & Q07C==1 & Q07D==1 & Q07E==1 & Q07F==1 & Q07G==1
		replace ilo_dsb_details=2 if Q07B==2|Q07C==2|Q07D==2|Q07E==2|Q07F==2|Q07G==2
		replace ilo_dsb_details=3 if Q07B==3|Q07C==3|Q07D==3|Q07E==3|Q07F==3|Q07G==3
		replace ilo_dsb_details=4 if Q07B==4|Q07C==4|Q07D==4|Q07E==4|Q07F==4|Q07G==4 
			* 3 observations for wap==1 (i.e. aged 15+) are appearing as missing --> force them into "no disability"
				replace ilo_dsb_details=1 if ilo_dsb_details==. & ilo_age>=15 & ilo_age!=.
			label define ilo_dsb_details_label 1 "No, no difficulty" 2 "Yes, some difficulty" 3 "Yes, a lot of difficulty" 4 "Cannot do it at all"
			label values ilo_dsb_details ilo_dsb_details_label
			label var ilo_dsb_details "Disability status (Details)"
				
	gen ilo_dsb_aggregate=.
		replace ilo_dsb_aggregate=1 if inlist(ilo_dsb_details,1,2)
		replace ilo_dsb_aggregate=2 if inlist(ilo_dsb_details,3,4)
			label def dsb_aggregate_lab 1 "Persons without disability" 2 "Persons with disability"
			label val ilo_dsb_aggregate dsb_aggregate_lab
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
* Comment: 	Reference period for job search: four weeks
 
	gen ilo_lfs=.
		replace ilo_lfs=1 if L2Q07_CURRACT==1 | L2Q08A_TEMPABS==1
		replace ilo_lfs=2 if L2Q07_CURRACT==2 & L2Q08A_TEMPABS==2 & L2Q09_AVAILWORK==1 & L2Q12_FINDWORK==1
		replace ilo_lfs=3 if !inlist(ilo_lfs,1,2)
			replace ilo_lfs=. if ilo_wap!=1	
				label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status" 	
						
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: --> considering also secondary employment from which the individual was temporarily absent

	gen ilo_mjh=.
		replace ilo_mjh=1 if L2Q35A_SACT==2 & L2Q35B_TEMPABS==2
		replace ilo_mjh=2 if L2Q35A_SACT==1 | L2Q35B_TEMPABS==1
		replace ilo_mjh=. if ilo_lfs!=1
			lab def lab_ilo_mjh 1 "1 - One job only" 2 "2 - More than one job"
			lab val ilo_mjh lab_ilo_mjh
			lab var ilo_mjh "Multiple job holders"			
			
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
	
		gen ilo_job1_ste_icse93=.
			replace ilo_job1_ste_icse93=1 if L2Q20_MSTATUS==1
			replace ilo_job1_ste_icse93=2 if L2Q20_MSTATUS==2
			replace ilo_job1_ste_icse93=3 if inlist(L2Q20_MSTATUS,3,8,9,10)
			/*replace ilo_job1_ste_icse93=4 if */
			replace ilo_job1_ste_icse93=5 if inlist(L2Q20_MSTATUS,4,5,6,7)
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

	  * Secondary activity
		
		gen ilo_job2_ste_icse93=.
			replace ilo_job2_ste_icse93=1 if L2Q38_SSTATUS==1
			replace ilo_job2_ste_icse93=2 if L2Q38_SSTATUS==2
			replace ilo_job2_ste_icse93=3 if inlist(L2Q38_SSTATUS,3,8,9,10)
			/*replace ilo_job2_ste_icse93=4 if */
			replace ilo_job2_ste_icse93=5 if inlist(L2Q38_SSTATUS,4,5,6,7)
			replace ilo_job2_ste_icse93=6 if ilo_job2_ste_icse93==. & ilo_lfs==1 & ilo_mjh==2
				replace ilo_job2_ste_icse93=. if ilo_lfs!=1 & ilo_mjh!=2
				* value labels already defined
				label val ilo_job2_ste_icse93 label_ilo_ste_icse93
				label var ilo_job2_ste_icse93 "Status in employment (ICSE 93) in secondary job"

			* Aggregate categories
		
			gen ilo_job2_ste_aggregate=.
				replace ilo_job2_ste_aggregate=1 if ilo_job2_ste_icse93==1
				replace ilo_job2_ste_aggregate=2 if inlist(ilo_job2_ste_icse93,2,3,4,5)
				replace ilo_job2_ste_aggregate=3 if inlist(ilo_job2_ste_icse93,6)
					*value labels already defined
					lab val ilo_job2_ste_aggregate ste_aggr_lab
				label var ilo_job2_ste_aggregate "Status in employment (Aggregate) in secondary job" 
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: ISIC Rev. 4 being used and initially indicated on 4-digits level --> keep only 2 digits level

	* economic activity indicated both for primary and secondary activity --> capture it for both

	gen indu_code_prim=int(L2Q22A_MIND/100) if ilo_lfs==1
	
	gen indu_code_sec=int(L2Q40A_SIND/100) if ilo_lfs==1 & ilo_mjh==2
		
 
					
		* Primary activity
		
		gen ilo_job1_eco_isic4_2digits=indu_code_prim
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
			
		* Secondary activity
		
		gen ilo_job2_eco_isic4_2digits=indu_code_sec
                * labels already defined for main job
		        lab val ilo_job2_eco_isic4_2digits eco_isic4_2digits
                lab var ilo_job2_eco_isic4_2digits "Economic activity (ISIC Rev. 4), 2 digits level - second job"
				
	* One digit level
	
		* aggregation done according to information on page 43 of the following document: https://www.bundesbank.de/Redaktion/EN/Downloads/Service/Meldewesen/Bankenstatistik/Kundensystematik/isic_rev_4.pdf?__blob=publicationFile
	
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
				
		* Secondary activity
		
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
			replace ilo_job2_eco_isic4=22 if ilo_job2_eco_isic4_2digits==. & ilo_lfs==1 & ilo_mjh==2
                * labels already defined for main job
		        lab val ilo_job2_eco_isic4 eco_isic4_1digit
			    lab var ilo_job2_eco_isic4 "Economic activity (ISIC Rev. 4) - second job"
				
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
			   lab var ilo_job1_eco_aggregate "Economic activity (Aggregate) - main job"
				
		* Secondary activity
		
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
*			Occupation ('ilo_ocu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: Indicate both for primary and secondary activity - TASCO classification being used, which is aligned to ISCO-88

	gen occ_code_prim=int(L2Q18A_MTASK/100) if ilo_lfs==1
	gen occ_code_sec=int(L2Q36A_STASK/100) if ilo_lfs==1 & ilo_mjh==2
	
	* 2 digit level
	
		* Primary occupation
		
		gen ilo_job1_ocu_isco88_2digits=occ_code_prim
		        lab def ocu_isco88_2digits 1 "01 - Armed forces"	11 "11 - Legislators and senior officials"	12 "12 - Corporate managers"	13 "13 - General managers"	///
                                           21 "21 - Physical, mathematical and engineering science professionals"	22 "22 - Life science and health professionals"	23 "23 - Teaching professionals"	24 "24 - Other professionals"	///
                                           31 "31 - Physical and engineering science associate professionals"	32 "32 - Life science and health associate professionals"	33 "33 - Teaching associate professionals"	34 "34 - Other associate professionals"	///
                                           41 "41 - Office clerks"	42 "42 - Customer services clerks"	51 "51 - Personal and protective services workers"	52 "52 - Models, salespersons and demonstrators"	///
                                           61 "61 - Skilled agricultural and fishery workers"	62 "62 - Subsistence agricultural and fishery workers"	71 "71 - Extraction and building trades workers"	72 "72 - Metal, machinery and related trades workers"	///
                                           73 "73 - Precision, handicraft, craft printing and related trades workers"	74 "74 - Other craft and related trades workers"	81 "81 - Stationary plant and related operators"	82 "82 - Machine operators and assemblers"	///
                                           83 "83 - Drivers and mobile plant operators"	91 "91 - Sales and services elementary occupations"	92 "92 - Agricultural, fishery and related labourers"	93 "93 - Labourers in mining, construction, manufacturing and transport"	
	            lab values ilo_job1_ocu_isco88_2digits ocu_isco88_2digits
	            lab var ilo_job1_ocu_isco88_2digits "Occupation (ISCO-88), 2 digit level - main job"
			
		* Secondary occupation
	
		gen ilo_job2_ocu_isco88_2digits=occ_code_sec
                * labels already defined for main job
		        lab values ilo_job2_ocu_isco88_2digits ocu_isco88_2digits
	            lab var ilo_job2_ocu_isco88_2digits "Occupation (ISCO-88), 2 digit level - second job"
		
	* 1 digit level
	
	gen occ_code_prim_1dig=int(L2Q18A_MTASK/1000) if ilo_lfs==1
	gen occ_code_sec_1dig=int(L2Q36A_STASK/1000) if ilo_lfs==1 & ilo_mjh==2
	
	* Primary activity
		
		gen ilo_job1_ocu_isco88=occ_code_prim_1dig
			replace ilo_job1_ocu_isco88=10 if ilo_job1_ocu_isco88==0
			replace ilo_job1_ocu_isco88=11 if ilo_job1_ocu_isco88==. & ilo_lfs==1
		        lab def ocu_isco88_1digit 1 "1 - Legislators, senior officials and managers"	2 "2 - Professionals"	3 "3 - Technicians and associate professionals"	4 "4 - Clerks"	///
                                          5 "5 - Service workers and shop and market sales workers"	6 "6 - Skilled agricultural and fishery workers"	7 "7 - Craft and related trades workers"	8 "8 - Plant and machine operators and assemblers"	///
                                          9 "9 - Elementary occupations"	10 "0 - Armed forces"	11 "11 - Not elsewhere classified"		
				lab val ilo_job1_ocu_isco88 ocu_isco88_1digit
				lab var ilo_job1_ocu_isco88 "Occupation (ISCO-88) - main job"
				
			
		* Secondary activity
		
		gen ilo_job2_ocu_isco88=occ_code_sec_1dig
			replace ilo_job2_ocu_isco88=10 if ilo_job2_ocu_isco88==0
			replace ilo_job2_ocu_isco88=11 if ilo_job2_ocu_isco88==. & ilo_lfs==1 & ilo_mjh==2
                * labels already defined for main job
				lab val ilo_job2_ocu_isco88 ocu_isco88_1digit
				lab var ilo_job2_ocu_isco88 "Occupation (ISCO-88) - second job"
			
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
				lab var ilo_job1_ocu_aggregate "Occupation (Aggregate) - main job"	
				
		* Secondary occupation
		
		gen ilo_job2_ocu_aggregate=.
			replace ilo_job2_ocu_aggregate=1 if inrange(ilo_job2_ocu_isco88,1,3)
			replace ilo_job2_ocu_aggregate=2 if inlist(ilo_job2_ocu_isco88,4,5)
			replace ilo_job2_ocu_aggregate=3 if inlist(ilo_job2_ocu_isco88,6,7)
			replace ilo_job2_ocu_aggregate=4 if ilo_job2_ocu_isco88==8
			replace ilo_job2_ocu_aggregate=5 if ilo_job2_ocu_isco88==9
			replace ilo_job2_ocu_aggregate=6 if ilo_job2_ocu_isco88==10
			replace ilo_job2_ocu_aggregate=7 if ilo_job2_ocu_isco88==11
                * labels already defined for main job
		        lab val ilo_job2_ocu_aggregate ocu_aggr_lab
				lab var ilo_job2_ocu_aggregate "Occupation (Aggregate) - second job"		
				
	* Skill level
	
		* Primary occupation
	
		gen ilo_job1_ocu_skill=.
			replace ilo_job1_ocu_skill=1 if ilo_job1_ocu_isco88==9
			replace ilo_job1_ocu_skill=2 if inlist(ilo_job1_ocu_isco88,4,5,6,7,8)
			replace ilo_job1_ocu_skill=3 if inlist(ilo_job1_ocu_isco88,1,2,3)
			replace ilo_job1_ocu_skill=4 if inlist(ilo_job1_ocu_isco88,10,11)
				lab def ocu_skill_lab 1 "1 - Skill level 1 (low)" 2 "2 - Skill level 2 (medium)" 3 "3 - Skill levels 3 and 4 (high)" 4 "4 - Not elsewhere classified"
			    lab val ilo_job1_ocu_skill ocu_skill_lab
			    lab var ilo_job1_ocu_skill "Occupation (Skill level) - main job"
				
		* Secondary occupation 
		
		gen ilo_job2_ocu_skill=.
			replace ilo_job2_ocu_skill=1 if ilo_job2_ocu_isco88==9
			replace ilo_job2_ocu_skill=2 if inlist(ilo_job2_ocu_isco88,4,5,6,7,8)
			replace ilo_job2_ocu_skill=3 if inlist(ilo_job2_ocu_isco88,1,2,3)
			replace ilo_job2_ocu_skill=4 if inlist(ilo_job2_ocu_isco88,10,11)
		        * labels already defined for main job
			    lab val ilo_job2_ocu_skill ocu_skill_lab
			    lab var ilo_job2_ocu_skill "Occupation (Skill level) - second job"
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_ins_sector') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
		
* Comment: consider separately for primary and secondary activity
	
	* Primary occupation
	
	gen ilo_job1_ins_sector=.
		replace ilo_job1_ins_sector=1 if inlist(L2Q23_MSECTOR,1,2,3,4,6,7,9)
		replace ilo_job1_ins_sector=2 if inlist(L2Q23_MSECTOR,5,8,10,11,12,13,14,15,15,16,17,96)
				replace ilo_job1_ins_sector=. if ilo_lfs!=1
			lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
			lab values ilo_job1_ins_sector ins_sector_lab
			lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities"
			
	* Secondary occupation

	gen ilo_job2_ins_sector=.
		replace ilo_job2_ins_sector=1 if inlist(L2Q41_SSECTOR,1,2,3,4,6,7,9)
		replace ilo_job2_ins_sector=2 if inlist(L2Q41_SSECTOR,5,8,10,11,12,13,14,15,15,16,17,96)
				replace ilo_job2_ins_sector=. if ilo_lfs!=1 & ilo_mjh!=2
			* value labels already defined
			lab values ilo_job2_ins_sector ins_sector_lab
			lab var ilo_job2_ins_sector "Institutional sector (private/public) of economic activities in secondary job"

* --------------------------------------------------------------------------------------------------
* --------------------------------------------------------------------------------------------------
*		Weekly hours actually (USUALLY) worked ('ilo_how_actual') and ('ilo_how_usual') [done]
* --------------------------------------------------------------------------------------------------
* --------------------------------------------------------------------------------------------------
* 
* Comment: consider first working time associated with each job and then consider the sum (i.e.
				* the time dedicated to all working activities during the week
				
	* Actual hours worked 
		
		* Primary job
		
		gen ilo_job1_how_actual=L2Q53M_CHOURS
			replace ilo_job1_how_actual=. if ilo_lfs!=1
			lab var ilo_job1_how_actual "Weekly hours actually worked in main job"
			
		* Secondary job
			
		gen ilo_job2_how_actual=L2Q53S_CHOURS
			replace ilo_job2_how_actual=. if ilo_lfs!=1 & ilo_mjh!=2
			lab var ilo_job2_how_actual "Weekly hours actually worked in secondary job" 
		
		* All jobs
		
		egen ilo_joball_how_actual=rowtotal(ilo_job1_how_actual ilo_job2_how_actual), m
			replace ilo_joball_how_actual=. if ilo_lfs!=1
			lab var ilo_joball_how_actual "Weekly hours actually worked in all jobs"		
	
	* Hours usually worked
	
		* Primary job
		
		gen ilo_job1_how_usual=L2Q58M_UHOURS
			replace ilo_job1_how_usual=. if ilo_lfs!=1
			lab var ilo_job1_how_usual "Weekly hours usually worked in main job"
			
		* Secondary job
			
		gen ilo_job2_how_usual=L2Q58S_UHOURS
			replace ilo_job2_how_usual=. if ilo_lfs!=1 & ilo_mjh!=2
			lab var ilo_job2_how_usual "Weekly hours usually worked in secondary job"
			
		* All jobs
		
		egen ilo_joball_how_usual=rowtotal(ilo_job1_how_usual ilo_job2_how_usual), m
			replace ilo_joball_how_usual=. if ilo_lfs!=1
			lab var ilo_joball_how_usual "Weekly hours usually worked in all jobs"
		
	*Weekly hours actually worked --> bands --> use actual hours worked in all jobs 
			
		* Main job
		
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
*			Working time arrangement ('ilo_job_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment: time usually dedicated to the primary activity being considered
	
	gen ilo_job1_job_time=.
		replace ilo_job1_job_time=1 if ilo_job1_how_usual<=39 & ilo_job1_how_usual!=.
		replace ilo_job1_job_time=2 if ilo_job1_how_usual>=40 & ilo_job1_how_usual!=.
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

	* Primary employment
	
	gen ilo_job1_job_contract=.
		replace ilo_job1_job_contract=1 if L2Q18C_CONTRACT==1
		replace ilo_job1_job_contract=2 if inlist(L2Q18C_CONTRACT,2,3,4)
		replace ilo_job1_job_contract=3 if L2Q18C_CONTRACT==5 | (ilo_job1_job_contract==. & ilo_job1_ste_aggregate==1)
				replace ilo_job1_job_contract=. if ilo_job1_ste_aggregate!=1
			lab def job_contract_lab 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"
			lab val ilo_job1_job_contract job_contract_lab
			lab var ilo_job1_job_contract "Job (Type of contract)"
			
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Informal/Formal economy: Unit of production (ilo_job1_ife_prod) [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* 
* Comment: for technical reasons threshold for size has to be set at 5 instead of 6 - note in readme file
	
	* Useful questions: L2Q23_MSECTOR: Status in employment / instititional sector ("Who is the owner of this enterprise?")
					*	L2Q22B_PRODUCT: Destination of production
					* 	L2Q21D_SECURITY: Contributions to social security
					*	[ L2Q21B_LEAVE: Paid maternity/paternity leave (proxy for health insurance) ]
					*	L2Q30_ISMLOC: Location of workplace
					*	L2Q25_MNUME: Size of the establishment
					*	L2Q26_MRECORD & L2Q27_MBALANCE: Bookkeeping & completeness of accounts
					*	L2Q24_MREGIST: Registration of the establishment 
				
				* For secondary employment:
					*	L2Q41_SSECTOR: Status in employment / institutional sector
					*	L2Q40B_PRODUCT: Destination of production
					*	[ L2Q39B_LEAVE: Paid maternity/paternity leave ]
					*	L2Q39D_SECURITY: Social security contributions
					*	L2Q42_SREGIST: Registration of the establishment
					*	L2Q48_ISSLOC: Location of workplace
					*	L2Q43_SNUME: Size of establishment
					*	L2Q44_SRECORD & L2Q45_SBALANCE: Bookkeeping & completeness of accounts					
					
					
	gen ilo_job1_ife_prod=.
		replace ilo_job1_ife_prod=1 if (!inlist(L2Q23_MSECTOR,1,2,3,4,6,7,12,13) & L2Q22B_PRODUCT!=4 & !inlist(L2Q26_MRECORD,3,4,5,6) & inlist(L2Q24_MREGIST,2,4)) | (!inlist(L2Q23_MSECTOR,1,2,3,4,6,7,12,13) ///
					& L2Q22B_PRODUCT!=4 & !inlist(L2Q26_MRECORD,3,4,5,6) & !inlist(L2Q24_MREGIST,1,2,3,4) & ((ilo_job1_ste_aggregate==1 & L2Q21D_SECURITY!=1) | ilo_job1_ste_aggregate!=1) & ///
						(L2Q30_ISMLOC!=4 | (L2Q30_ISMLOC==4 & L2Q25_MNUME!=2)))							
		replace ilo_job1_ife_prod=2 if inlist(L2Q23_MSECTOR,1,2,3,4,6,7) | (!inlist(L2Q23_MSECTOR,1,2,3,4,6,7,12,13) & L2Q22B_PRODUCT!=4 & inlist(L2Q26_MRECORD,3,4,5,6)) | ///
					(!inlist(L2Q23_MSECTOR,1,2,3,4,6,7,12,13) & L2Q22B_PRODUCT!=4 & !inlist(L2Q26_MRECORD,3,4,5,6) & inlist(L2Q24_MREGIST,1,3)) | (!inlist(L2Q23_MSECTOR,1,2,3,4,6,7,12,13) & L2Q22B_PRODUCT!=4 & ///
					!inlist(L2Q26_MRECORD,3,4,5,6) & !inlist(L2Q24_MREGIST,1,2,3,4) & ilo_job1_ste_aggregate==1 & L2Q21D_SECURITY==1) | (!inlist(L2Q23_MSECTOR,1,2,3,4,6,7,12,13) & L2Q22B_PRODUCT!=4 & ///
					!inlist(L2Q26_MRECORD,3,4,5,6) & !inlist(L2Q24_MREGIST,1,2,3,4) & ((ilo_job1_ste_aggregate==1 & L2Q21D_SECURITY!=1) | ilo_job1_ste_aggregate!=1) & L2Q30_ISMLOC==4 & L2Q25_MNUME==2)									
		replace ilo_job1_ife_prod=3 if inlist(L2Q23_MSECTOR,12,13) | (!inlist(L2Q23_MSECTOR,1,2,3,4,6,7,12,13) & L2Q22B_PRODUCT==4) | ilo_job1_ocu_isco88_2digits==62 | ilo_job1_eco_isic4_2digits==97
		replace ilo_job1_ife_prod=4 if ilo_job1_ife_prod==. & ilo_lfs==1
				replace ilo_job1_ife_prod=. if ilo_lfs!=1
			lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 4 "4 - Not elsewhere classified"
			lab val ilo_job1_ife_prod ilo_ife_prod_lab
			lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"
			
			
	* old definition
	
	/*
	gen ilo_job1_ife_prod=.
		replace ilo_job1_ife_prod=1 if !inlist(L2Q23_MSECTOR,1,2,3,4,6,7,12,13) & L2Q22B_PRODUCT!=4 & bookkeeping!=1 & !inlist(L2Q24_MREGIST,1,3) & ///
									((!inlist(L2Q30_ISMLOC,7,8,11,12) & L2Q25_MNUME!=2 & soc_sec_coverage!=1) | (inlist(L2Q30_ISMLOC,7,8,12) & soc_sec_coverage!=1))
		replace ilo_job1_ife_prod=2 if inlist(L2Q23_MSECTOR,1,2,3,4,6,7) | (!inlist(L2Q23_MSECTOR,1,2,3,4,6,7,12,13) & L2Q22B_PRODUCT!=4 & bookkeeping==1) | ///
										(!inlist(L2Q23_MSECTOR,1,2,3,4,6,7,12,13) & L2Q22B_PRODUCT!=4 & bookkeeping!=1 & inlist(L2Q24_MREGIST,1,3)) | ///
									(!inlist(L2Q23_MSECTOR,1,2,3,4,6,7,12,13) & L2Q22B_PRODUCT!=4 & bookkeeping!=1 & !inlist(L2Q24_MREGIST,1,3) &   ///
									((!inlist(L2Q30_ISMLOC,7,8,11,12) & L2Q25_MNUME==2) | (!inlist(L2Q30_ISMLOC,7,8,11,12) & L2Q25_MNUME!=2 & soc_sec_coverage==1) | (inlist(L2Q30_ISMLOC,7,8,12) & soc_sec_coverage==1)))										
		replace ilo_job1_ife_prod=3 if inlist(L2Q23_MSECTOR,12,13) | (!inlist(L2Q23_MSECTOR,1,2,3,4,6,7,12,13) & L2Q22B_PRODUCT==4) | ///
						(!inlist(L2Q23_MSECTOR,1,2,3,4,6,7,12,13) & L2Q22B_PRODUCT!=4 & bookkeeping!=1 & !inlist(L2Q24_MREGIST,1,3) & L2Q30_ISMLOC==11 )| ilo_job1_ocu_isco08_2digits==63 | ilo_job1_eco_isic4_2digits==97
		replace ilo_job1_ife_prod=4 if ilo_job1_ife_prod==. & ilo_lfs==1
				replace ilo_job1_ife_prod=. if ilo_lfs!=1
			lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 4 "4 - Not elsewhere classified"
			lab val ilo_job1_ife_prod ilo_ife_prod_lab
			lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"
			*/
			
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Informal/formal economy: nature of job (ilo_job1_ife_nature) [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: 

	gen ilo_job1_ife_nature=.
		replace ilo_job1_ife_nature=1 if ilo_job1_ste_icse93==5 | (inlist(ilo_job1_ste_icse93,1,6) & L2Q21D_SECURITY!=1) | (inlist(ilo_job1_ste_icse93,2,3,4) & inlist(ilo_job1_ife_prod,1,3))
		replace ilo_job1_ife_nature=2 if (inlist(ilo_job1_ste_icse93,1,6) & L2Q21D_SECURITY==1) | (inlist(ilo_job1_ste_icse93,2,3,4) & ilo_job1_ife_prod==2)
		replace ilo_job1_ife_nature=. if ilo_lfs!=1
			lab def ife_nature_lab 1 "1 - Persons with informal main job" 2 "2 - Persons with formal main job"
			lab val ilo_job1_ife_nature ife_nature_lab
			lab var ilo_job1_ife_nature "Informal / Formal Economy (Nature of job)"
			

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Earnings ('ilo_ear_ees' and 'ilo_ear_slf') [not being defined]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	
* Comment: 
	
	*Currency in Tanzania: Tanzanian shilling (TSh or TZS)
	
		* --> income not separately indicated for main and secondary employment, but for all jobs together...!
		
			* therefore don't define variable!
			
			
***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************						
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_tru') [don't define variable]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*                
* Comment: --> Workers only asked about their availability to work more, not about their willingness!  --> therefore variable can't be defined

	* [National threshold for full-time employment set at 40 hours per week -> therefore according to the time-related criterion 
		*	workers working 40 hours and less are considered as underemployed	]


	/* gen ilo_joball_tru=1 if ilo_joball_how_actual<=39 & L2Q55_CAVAIL==1
		replace ilo_joball_tru=. if ilo_lfs!=1
			lab def tru_lab 1 "Time-related underemployment"
			lab val ilo_joball_tru tru_lab
			lab var ilo_joball_tru "Time-related underemployment"	*/		

			
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Cases of non-fatal occupational injury ('ilo_joball_oi_case') [done] 
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*
* Comment: Variable asking explicitly whether injury related to primary or secondary job (i.e. in each section one 
			* question) --> consider both jobs
			
			* considering also work-related disease
			
	gen ilo_joball_oi_case=1 if inlist(L2Q19B_INJURED,1,2,3) | inlist(L2Q37B_INJURED,1,2,3)
		lab var ilo_joball_oi_case "Cases of non-fatal occupational injury"
		
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Days lost due to cases of occupational injury ('ilo_joball_oi_day') [no info available]
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
* Comment:
			
	* in order to avoid putting any notes and as the exact duration is not precised if person seeking for a job for 52 weeks, take only the aggregate version
			
			
	gen ilo_dur_aggregate=.
		replace ilo_dur_aggregate=1 if inlist(L2Q17A_DURAVAIL,1,2)
		replace ilo_dur_aggregate=2 if L2Q17A_DURAVAIL==3
		replace ilo_dur_aggregate=3 if L2Q17A_DURAVAIL==4
		replace ilo_dur_aggregate=4 if ilo_dur_aggregate==. & ilo_lfs==2
				replace ilo_dur_aggregate=. if ilo_lfs!=2
			lab def ilo_unemp_aggr 1 "Less than 6 months" 2 "6 months to less than 12 months" 3 "12 months or more" 4 "Not elsewhere classified"
			lab val ilo_dur_aggregate ilo_unemp_aggr
			lab var ilo_dur_aggregate "Duration of unemployment (Aggregate)"
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Category of unemployment ('ilo_cat_une') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment:
	
	gen ilo_cat_une=.
		replace ilo_cat_une=1 if L2Q15A_EVERWK==1
		replace ilo_cat_une=2 if L2Q15A_EVERWK==2
		replace ilo_cat_une=3 if ilo_cat_une==. & ilo_lfs==2
				replace ilo_cat_une=. if ilo_lfs!=2
			lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
			lab val ilo_cat_une cat_une_lab
			lab var ilo_cat_une "Category of unemployment"
		
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment:

	* --> no information available

			

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu_isco08') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			
* Comment: ISCO-88 classification being used

	* reduce it to the one digit level
	
	gen prevocu_cod=int(L2Q15B_TASCO/1000) if ilo_cat_une==1
	
	gen ilo_prevocu_isco88=prevocu_cod
		replace ilo_prevocu_isco88=10 if ilo_job1_ocu_isco88==0
		replace ilo_prevocu_isco88=11 if ilo_prevocu_isco88==. & ilo_cat_une==1 & ilo_lfs==2
                * labels already defined for main job
		        lab val ilo_prevocu_isco88 ocu_isco88_1digit
				lab var ilo_prevocu_isco88 "Previous occupation (ISCO-88)"
				
			
	* Aggregate level 
	
	gen ilo_prevocu_aggregate=.
		replace ilo_prevocu_aggregate=1 if inrange(ilo_prevocu_isco88,1,3)
		replace ilo_prevocu_aggregate=2 if inlist(ilo_prevocu_isco88,4,5)
		replace ilo_prevocu_aggregate=3 if inlist(ilo_prevocu_isco88,6,7)
		replace ilo_prevocu_aggregate=4 if ilo_prevocu_isco88==8
		replace ilo_prevocu_aggregate=5 if ilo_prevocu_isco88==9
		replace ilo_prevocu_aggregate=6 if ilo_prevocu_isco88==10
		replace ilo_prevocu_aggregate=7 if ilo_prevocu_isco88==11
                * labels already defined for main job
		        lab val ilo_prevocu_aggregate ocu_aggr_lab
				lab var ilo_prevocu_aggregate "Previous occupation (Aggregate)"		
			
	* Skill level
	
	gen ilo_prevocu_skill=.
		replace ilo_prevocu_skill=1 if ilo_prevocu_isco88==9
		replace ilo_prevocu_skill=2 if inlist(ilo_prevocu_isco88,4,5,6,7,8)
		replace ilo_prevocu_skill=3 if inlist(ilo_prevocu_isco88,1,2,3)
		replace ilo_prevocu_skill=4 if inlist(ilo_prevocu_isco88,10,11)
                * labels already defined for main job
		        lab val ilo_prevocu_skill ocu_skill_lab
			    lab var ilo_prevocu_skill "Occupation (Skill level) - main job"
				
			
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Unemployment benefits schemes ('ilo_soc_aggregate') [no info available]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment:

	/* gen ilo_soc_aggregate=. */
	
	
***********************************************************************************************
*			PART 3.4. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************					

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma') [no info available]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: Degree of labour market attachment of persons outside the labour force

		* people for which ilo_lfs==3 (outside the labour force) are not asked any question except for their reason for not being available for work...
			* therefore variable can't be defined
	
	/* gen ilo_olf_dlma=. */
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reasons for not seeking a job ('ilo_olf_reason') [can't be defined]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
* Comment: 

	gen ilo_olf_reason=.
		replace ilo_olf_reason=1 if L2Q10_RNOTAV==8 | L2Q14_WHY4WK==1
		replace ilo_olf_reason=2 if inlist(L2Q14_WHY4WK,2,3,4)
		replace ilo_olf_reason=3 if inlist(L2Q10_RNOTAV,1,2,3,4,5,6,9,10,11,12) | inlist(L2Q14_WHY4WK,5,6,7)
		replace ilo_olf_reason=4 if inlist(L2Q10_RNOTAV,7,13)
		replace ilo_olf_reason=5 if ilo_olf_reason==. & ilo_lfs==3
			replace ilo_olf_reason=. if ilo_lfs!=3
			lab def lab_olf_reason 1 "1 - Labour market (discouraged)" 2 "2 - Other labour market reasons" 3 "3 - Personal/Family-related"  4 "4 - Does not need/want to work" 5 "5 - Not elsewhere classified"
			lab val ilo_olf_reason lab_olf_reason
			lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seekers ('ilo_dis') [can't be defined]
* -------------------------------------------------------------------------------------------
* ------------------------------------------------------------------------------------------- 
*
* Comment: 	idem as for 'ilo_olf_reason'

	
		gen ilo_dis=1 if ilo_lfs==3 & ilo_olf_reason==1 & L2Q09_AVAILWORK==1
			lab def ilo_dis_lab 1 "Discouraged job-seekers" 
			lab val ilo_dis ilo_dis_lab
			lab var ilo_dis "Discouraged job-seekers"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training (NEETs) ('ilo_neet') [done]
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
		
		drop indu_code_* occ_code_* prevocu_cod  
	
		compress 
		
		order ilo*, last
		
	* Save dataset including original and ilo variables
	
		save ${country}_${source}_${time}_FULL, replace		
	
	*Save file only containing ilo_* variables
	
		keep ilo*

		save ${country}_${source}_${time}_ILO, replace
		
		
