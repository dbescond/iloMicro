* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Costa Rica
* DATASET USED: Costa Rica LFS
* NOTES: 
* Files created: Standard variables on ECE Costa Rica
* Authors: ILO / Department of Statistics / DPAU
* Starting Date: 31 August 2016
* Last updated: 26 February 2018
***********************************************************************************************

*******************************************************************
 /* 1.	Set up work directory, file name, variables and function */
*******************************************************************

clear all 

set more off

global path "J:\DPAU\MICRO"
global country "CRI"
global source "ECE"
global time "2017Q1"
global inputFile "I_Trimestre_2017"
global inpath "${path}\\${country}\\${source}\\${time}\ORI"
global temppath "${path}\_Admin"
global outpath "${path}\\${country}\\${source}\\${time}"

***************************************************************

cd "$inpath"
	use ${inputFile}, clear
	*renaming everything in lower case
	rename *, lower  
	
*****************************************************************************************
**********************************************************************************************
		
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
* Comment:

	gen ilo_key=_n
		lab var ilo_key "Key unique identifier per individual"
	
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sample Weight ('ilo_wgt') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: 

	gen ilo_wgt=factor_ponderacion
		lab var ilo_wgt "Sample weight"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time period ('ilo_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment:

	gen ilo_time=1
		lab def time_lab 1 "$time"
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
* Comment: 
	
	gen ilo_geo=.
	    replace ilo_geo=1 if zona==1
		replace ilo_geo=2 if zona==2
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
	    replace ilo_sex=1 if sexo==1
		replace ilo_sex=2 if sexo==2
		        label define label_Sex 1 "1 - Male" 2 "2 - Female"
		        label values ilo_sex label_Sex
		        lab var ilo_sex "Sex"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - From the original variable: 97 indicates 97 years old or more; 99 indicates that
*            the age is unknown but s/he is over the age of 15. Given that 99 follows under the
*            category 65+, it is kept as it is originally.
	
	gen ilo_age=.
	    replace ilo_age=edad
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
*			Level of education ('ilo_edu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Given the definition of the levels of education, ISCED97 is being chosen
*            Educación parauniversitaria: 
*            http://www.sinaes.ac.cr/images/docs/proceso_acreditacion/SINAES%20Diag%20Parauniversitarias%20Seg%20iforme_VP_5Mayo2011%20PUB.pdf
*          - Highest level being concluded.
*          - Only asked to people aged 15 years old or more and therefore the rest are classified
*            under "Level not stated".
			
	gen ilo_edu_isced97=.
		replace ilo_edu_isced97=1 if educacion_nivel_grado==0                                     // No schooling
		replace ilo_edu_isced97=2 if inrange(educacion_nivel_grado,1,15)                          // Pre-primary education
		replace ilo_edu_isced97=3 if inrange(educacion_nivel_grado,16,22) | inlist(educacion_nivel_grado,31,32)     // Primary education or first stage of basic education
		replace ilo_edu_isced97=4 if inrange(educacion_nivel_grado,23,25) | inrange(educacion_nivel_grado,33,36)    // Lower secondary education or second stage of basic education
		replace ilo_edu_isced97=5 if inlist(educacion_nivel_grado,26,37,41,42,51,52)              // Upper secondary education
		replace ilo_edu_isced97=6 if educacion_nivel_grado==43                                    // Post-secondary non-tertiary education
		replace ilo_edu_isced97=7 if inlist(educacion_nivel_grado,53,54,55)                       // First stage of tertiary education (not leading directly to an advanced research qualification)
		replace ilo_edu_isced97=8 if inrange(educacion_nivel_grado,72,85)                         // Second stage of tertiary education (leading to an advanced research qualification)
		replace ilo_edu_isced97=9 if educacion_nivel_grado==99                                    // Level not stated
		replace ilo_edu_isced97=9 if ilo_edu_isced97==.
			    label def isced_97_lab 1 "X - No schooling" 2 "0 - Pre-primary education" 3 "1 - Primary education or first stage of basic education" 4 "2 - Lower secondary education or second stage of basic education" ///
							                   5 "3 - Upper secondary education" 6 "4 - Post-secondary non-tertiary education" 7 "5 - First stage of tertiary education (not leading directly to an advanced research qualification)" ///
							                   8 "6 - Second stage of tertiary education (leading to an advanced research qualification)" 9 "UNK - Level not stated"
			    label val ilo_edu_isced97 isced_97_lab
		        lab var ilo_edu_isced97 "Level of education (ISCED 97)"

	
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
*			Education attendance ('ilo_edu_attendance') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Attendance is only asked to people aged 15 years old and over and therefore those
*            below will be classified under "Not elsewhere classified".
			
		gen ilo_edu_attendance=.
			replace ilo_edu_attendance=1 if inrange(educacion_asiste,1,6)
			replace ilo_edu_attendance=2 if educacion_asiste==7
			replace ilo_edu_attendance=3 if ilo_edu_attendance==.
				    lab def edu_attendance_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
				    lab val ilo_edu_attendance edu_attendance_lab
				    lab var ilo_edu_attendance "Education (Attendance)"

					
					

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			           Marital status ('ilo_mrts') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: all missing observations are related to people aged below 15 years.
	
	* Detailed
	gen ilo_mrts_details=.
	    replace ilo_mrts_details=1 if estado_conyugal==6                        // Single
		replace ilo_mrts_details=2 if inlist(estado_conyugal,2,7)               // Married
		replace ilo_mrts_details=3 if inlist(estado_conyugal,1,8)               // Union / cohabiting
		replace ilo_mrts_details=4 if estado_conyugal==5                        // Widowed
		replace ilo_mrts_details=5 if inlist(estado_conyugal,3,4)               // Divorced / separated
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
* Comment: - No information available

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
			    label var ilo_wap "Working age population" 

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Labour Force Status ('ilo_lfs') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Unemployment comprises people not in employment, available to start working right
*            now or at least in two weeks and who looked for a job in the past four weeks; it
*            also includes those who did not look for a job in the past 4 weeks because s/he
*            already found a job. Final estimates differ from the national ones due to the 
*            definition of future starters used (NSO includes people expecting resumption of
*            operations or business reopening (2) or waiting for an answer from employers (3)). 
	
	gen ilo_lfs=.
        replace ilo_lfs=1 if (trabajo==1 | inrange(trabajo_marginal,1,7) | actividad_sinpaga==1) & ilo_wap==1	       // Employed: worked for at least one hour
		replace ilo_lfs=1 if (ausente==1 & inrange(motivo_ausente,1,5)) & ilo_wap==1                                   // Employed: temporary absent
		replace ilo_lfs=2 if (ilo_lfs!=1 & inlist(desea_trabajar,8,9) & inrange(busca_trabajo,1,11)) & ilo_wap==1      // Unemployed: three criteria
		replace ilo_lfs=2 if (ilo_lfs!=1 & inlist(desea_trabajar,8,9) & motivo_nobusco==1) & ilo_wap==1                // Unemployed: available future starters
	    replace ilo_lfs=3 if !inlist(ilo_lfs,1,2) & ilo_wap==1                                                         // Outside the labour force
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
		replace ilo_mjh=1 if f1==1
		replace ilo_mjh=2 if inlist(f1,2,3)
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
* Comment:

   * MAIN JOB:
	 gen ilo_job1_ste_icse93=.
		 replace ilo_job1_ste_icse93=1 if (posicion_empleo==1) & ilo_lfs==1     // Employees
		 replace ilo_job1_ste_icse93=2 if (posicion_empleo==3) & ilo_lfs==1     // Employers
		 replace ilo_job1_ste_icse93=3 if (posicion_empleo==2) & ilo_lfs==1     // Own-account workers
		 * replace ilo_job1_ste_icse93=4                                        // Members of producers' cooperatives
		 replace ilo_job1_ste_icse93=5 if (posicion_empleo==4) & ilo_lfs==1     // Contributing family workers
		 replace ilo_job1_ste_icse93=6 if ilo_job1_ste_icse93==. & ilo_lfs==1   // Workers not classifiable by status
		 replace ilo_job1_ste_icse93=. if ilo_lfs!=1
				 label def label_ilo_ste_icse93 1 "1 - Employees" 2 "2 - Employers" 3 "3 - Own-account workers" ///
				                                4 "4 - Members of producers' cooperatives" 5 "5 - Contributing family workers" ///
												6 "6 - Workers not classifiable by status"
				 label val ilo_job1_ste_icse93 label_ilo_ste_icse93
				 label var ilo_job1_ste_icse93 "Status in employment (ICSE 93) - main job"

	* Aggregate categories 
	  gen ilo_job1_ste_aggregate=.
		  replace ilo_job1_ste_aggregate=1 if ilo_job1_ste_icse93==1
		  replace ilo_job1_ste_aggregate=2 if inlist(ilo_job1_ste_icse93,2,3,4,5)
		  replace ilo_job1_ste_aggregate=3 if inlist(ilo_job1_ste_icse93,6)
				  lab def ste_aggr_lab 1 "1 - Employees" 2 "2 - Self-employed" 3 "3 - Not elsewhere classified"
				  lab val ilo_job1_ste_aggregate ste_aggr_lab
				  label var ilo_job1_ste_aggregate "Status in employment (Aggregate) - main job"
				
	* SECOND JOB:		
	  gen ilo_job2_ste_icse93=.
		  replace ilo_job2_ste_icse93=1 if posicion_secundario==1 & ilo_mjh==2  // Employees
		  replace ilo_job2_ste_icse93=2 if posicion_secundario==3 & ilo_mjh==2  // Employers
		  replace ilo_job2_ste_icse93=3 if posicion_secundario==2 & ilo_mjh==2  // Own-account workers
		  * replace ilo_job2_ste_icse93=4                                       // Members of producers' cooperatives 
		  replace ilo_job2_ste_icse93=5 if posicion_secundario==4 & ilo_mjh==2  // Contributing family workers
		  replace ilo_job2_ste_icse93=6 if ilo_job2_ste_icse93==. & ilo_mjh==2  // Workers not classifiable by status
 			      label value ilo_job2_ste_icse93 label_ilo_ste_icse93
			      label var ilo_job2_ste_icse93 "Status in employment (ICSE 93) - second job"

	* Aggregate categories
	  gen ilo_job2_ste_aggregate=.
		  replace ilo_job2_ste_aggregate=1 if ilo_job2_ste_icse93==1
		  replace ilo_job2_ste_aggregate=2 if inlist(ilo_job2_ste_icse93,2,3,4,5)
		  replace ilo_job2_ste_aggregate=3 if inlist(ilo_job2_ste_icse93,6)
				  lab val ilo_job2_ste_aggregate ste_aggr_lab
				  label var ilo_job2_ste_aggregate "Status in employment (Aggregate) - second job"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Main job: ISIC Rev 4.

	* MAIN JOB:
	gen indu_code_prim=.
	    replace indu_code_prim=int(cod_rama/100)

	* 2-digit level	
	gen ilo_job1_eco_isic4_2digits=indu_code_prim if ilo_lfs==1
	    replace ilo_job1_eco_isic4_2digits=. if ilo_lfs!=1
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
	    replace ilo_job1_eco_isic4=22 if ilo_job1_eco_isic4==. & ilo_lfs==1
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


	* SECOND JOB
	* 1-digit level
    gen ilo_job2_eco_isic4=.
	    replace ilo_job2_eco_isic4=rama_actividad_secundario & ilo_mjh==2
		replace ilo_job2_eco_isic4=22 if ilo_job2_eco_isic4==99 & ilo_mjh==2
		replace ilo_job2_eco_isic4=22 if ilo_job2_eco_isic4==. & ilo_mjh==2
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
* Comment: - "Ocupación no calificada" (unqualified occupation) is considered as low-skilled
*            occupation.

    * MAIN JOB
	* Skill level
	  gen ilo_job1_ocu_skill=.
		  replace ilo_job1_ocu_skill=1 if calificacion_ocupacion_cocr11==3 & ilo_lfs==1     // Low
		  replace ilo_job1_ocu_skill=2 if calificacion_ocupacion_cocr11==2 & ilo_lfs==1     // Medium
		  replace ilo_job1_ocu_skill=3 if calificacion_ocupacion_cocr11==1 & ilo_lfs==1     // High
		  replace ilo_job1_ocu_skill=4 if ilo_job1_ocu_skill==. & ilo_lfs==1                // Not elsewhere classified 
				  lab def ocu_skill_lab 1 "1 - Skill level 1 (low)" 2 "2 - Skill level 2 (medium)" 3 "3 - Skill levels 3 and 4 (high)" 4 "4 - Not elsewhere classified"
				  lab val ilo_job1_ocu_skill ocu_skill_lab
				  lab var ilo_job1_ocu_skill "Occupation (Skill level) - main job"
				  
    * SECOND JOB
	* Skill level
	  gen ilo_job2_ocu_skill=.
		  replace ilo_job2_ocu_skill=1 if calificacion_ocupacion_secund==3 & ilo_mjh==2     // Low
		  replace ilo_job2_ocu_skill=2 if calificacion_ocupacion_secund==2 & ilo_mjh==2     // Medium
		  replace ilo_job2_ocu_skill=3 if calificacion_ocupacion_secund==1 & ilo_mjh==2     // High
		  replace ilo_job2_ocu_skill=4 if ilo_job2_ocu_skill==. & ilo_mjh==2                // Not elsewhere classified 
				  lab val ilo_job2_ocu_skill ocu_skill_lab
				  lab var ilo_job2_ocu_skill "Occupation (Skill level) - second job"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_ins_sector') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Based on the computed variable from the origanl dataset.
		
	gen ilo_job1_ins_sector=.
		replace ilo_job1_ins_sector=1 if sector_institucional==1 & ilo_lfs==1   // Public
		replace ilo_job1_ins_sector=2 if ilo_job1_ins_sector==. & ilo_lfs==1    // Private
			    lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
			    lab values ilo_job1_ins_sector ins_sector_lab
			    lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities - main job"
		
* --------------------------------------------------------------------------------------------------
* --------------------------------------------------------------------------------------------------
*		     Hours of work ('ilo_how') [done]
* --------------------------------------------------------------------------------------------------
* --------------------------------------------------------------------------------------------------
* Comment: - Hours reported in secondary job also include those worked in other than the second job
*            whenever it is the case.
				
	* MAIN JOB
	* Hours USUALLY worked in main job	
	gen ilo_job1_how_usual = horas_normales_principal if horas_normales_principal!=999 & ilo_lfs==1
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
		   	    lab def how_bands_lab 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"		
				lab val ilo_job1_how_usual_bands how_bands_lab
				lab var ilo_job1_how_usual_bands "Weekly hours usually worked bands - main job"

	* Hours ACTUALLY worked in main job	
	gen ilo_job1_how_actual=horas_efectivas_principal if horas_efectivas_principal!=999 & ilo_lfs==1
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
	* Hours USUALLY worked in secondary job
	gen ilo_job2_how_usual = horas_normales_secs if horas_normales_secs!=999 & ilo_mjh==2
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
				lab val ilo_job2_how_usual_bands how_bands_lab
				lab var ilo_job2_how_usual_bands "Weekly hours usually worked bands - second job"
				
	* Hours ACTUALLY worked in secondary job
    gen ilo_job2_how_actual = horas_efectivas_secs if horas_efectivas_secs!=999 & ilo_mjh==2
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
	* Hours USUALLY worked in all job
    egen ilo_joball_how_usual=rowtotal(ilo_job1_how_usual ilo_job2_how_usual), m
		 lab var ilo_joball_how_usual "Weekly hours usually worked - all jobs"
		 
	gen ilo_joball_how_usual_bands=.
	    replace ilo_joball_how_usual_bands=1 if ilo_joball_how_usual==0
		replace ilo_joball_how_usual_bands=2 if ilo_joball_how_usual>=1 & ilo_joball_how_usual<=14
		replace ilo_joball_how_usual_bands=3 if ilo_joball_how_usual>14 & ilo_joball_how_usual<=29
		replace ilo_joball_how_usual_bands=4 if ilo_joball_how_usual>29 & ilo_joball_how_usual<=34
		replace ilo_joball_how_usual_bands=5 if ilo_joball_how_usual>34 & ilo_joball_how_usual<=39
		replace ilo_joball_how_usual_bands=6 if ilo_joball_how_usual>39 & ilo_joball_how_usual<=48
		replace ilo_joball_how_usual_bands=7 if ilo_joball_how_usual>48 & ilo_joball_how_usual!=.
		replace ilo_joball_how_usual_bands=8 if ilo_joball_how_usual_bands==. & ilo_lfs==1
		replace ilo_joball_how_usual_bands=. if ilo_lfs!=1
			 	lab val ilo_joball_how_usual_bands how_bands_lab
				lab var ilo_joball_how_usual_bands "Weekly hours usually worked bands - all jobs"
				
	* Hours ACTUALLY worked in secondary job	
	egen ilo_joball_how_actual=rowtotal(ilo_job1_how_actual ilo_job2_how_actual), m
		 lab var ilo_joball_how_actual "Weekly hours actually worked - all jobs"
		 
	gen ilo_joball_how_actual_bands=.
	    replace ilo_joball_how_actual_bands=1 if ilo_joball_how_actual==0
		replace ilo_joball_how_actual_bands=2 if ilo_joball_how_actual>=1 & ilo_joball_how_actual<=14
		replace ilo_joball_how_actual_bands=3 if ilo_joball_how_actual>14 & ilo_joball_how_actual<=29
		replace ilo_joball_how_actual_bands=4 if ilo_joball_how_actual>29 & ilo_joball_how_actual<=34
		replace ilo_joball_how_actual_bands=5 if ilo_joball_how_actual>34 & ilo_joball_how_actual<=39
		replace ilo_joball_how_actual_bands=6 if ilo_joball_how_actual>39 & ilo_joball_how_actual<=48
		replace ilo_joball_how_actual_bands=7 if ilo_joball_how_actual>48 & ilo_joball_how_actual!=.
		replace ilo_joball_how_actual_bands=8 if ilo_joball_how_actual_bands==. & ilo_lfs==1
		replace ilo_joball_how_actual_bands=. if ilo_lfs!=1
			 	lab val ilo_joball_how_actual_bands how_bands_lab
				lab var ilo_joball_how_actual_bands "Weekly hours actually worked bands - all jobs"
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
* Comment: - Threshold is set at 40 hours usually worked in all jobs per week.
			
	gen ilo_job1_job_time=.
		replace ilo_job1_job_time=2 if ilo_joball_how_usual>=40 & ilo_lfs==1                              // Full-time
		replace ilo_job1_job_time=1 if ilo_joball_how_usual<40 & ilo_joball_how_usual!=. & ilo_lfs==1     // Part-time
		replace ilo_job1_job_time=3 if ilo_job1_job_time==. & ilo_lfs==1
			    lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
			    lab val ilo_job1_job_time job_time_lab
			    lab var ilo_job1_job_time "Job (Working time arrangement)"
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job_contract') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
* Comment: - Permanent: for an indefinite or permanent time.
*          - No information available for second job.
	
	gen ilo_job1_job_contract=.
		replace ilo_job1_job_contract=1 if e1==1 & ilo_lfs==1                     // Permanent
		replace ilo_job1_job_contract=2 if inlist(e1,2,3,4,5) & ilo_lfs==1        // Temporary
		replace ilo_job1_job_contract=3 if ilo_job1_job_contract==. & ilo_lfs==1  // Unknown
			    lab def job_contract_lab 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"
			    lab val ilo_job1_job_contract job_contract_lab
			    lab var ilo_job1_job_contract "Job (Type of contract)"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*		Informal/Formal economy: ('ilo_job1_ife_prod' and 'ilo_job1_ife_nature') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment:

/* Useful questions:
          - Institutional sector: sector_institucional
		  - Private household: ilo_job1_eco_isic4_2digits==97.
		  - Destination of production: not asked.
		  - Bookkeeping: d9 (only asked to self-employed).
		  - Registration: d8 (only asked to self-employed).
		  - Status in employment: ilo_job1_ste_icse93==1 (employees).
		  - Social security: e10a (only to employees).
		  - Place of work: lugar_tareas.
		  - Size: cantidad_personas.
		  - Paid annual leave: e9b (only asked to employees).
		  - Paid sick leave: e9a (only asked to employees).
*/
    * Social Security:
	gen social_security=.
	    replace social_security=1 if (e10a==1 & ilo_lfs==1)          // social security
		replace social_security=2 if (e10a==2 & ilo_lfs==1)          // no social security
		replace social_security=. if (social_security==. & ilo_lfs==1)
	
    * 1) UNIT OF PRODUCTION: FORMAL/INFORMAL SECTOR
	gen ilo_job1_ife_prod=.
	    replace ilo_job1_ife_prod=3 if ilo_lfs==1 & ///
		                               (ilo_job1_eco_isic4_2digits==97)
		replace ilo_job1_ife_prod=2 if ilo_lfs==1 & ilo_job1_ife_prod!=3 & ///
		                               ((sector_institucional==1) | ///
									   (sector_institucional!=1 & d9==1) | ///
									   (sector_institucional!=1 & d9!=1 & inlist(d8,1,2)) | ///
									   (sector_institucional!=1 & d9!=1 & d8==. & ilo_job1_ste_icse93==1 & social_security==1) | ///
									   (sector_institucional!=1 & d9!=1 & d8==. & ilo_job1_ste_icse93==1 & social_security!=1 & inlist(lugar_tareas,1,2,3,4,5) & inlist(cantidad_personas,6,7,8,9,10,11,12,13)) | ///
									   (sector_institucional!=1 & d9!=1 & d8==. & ilo_job1_ste_icse93!=1 & inlist(lugar_tareas,1,2,3,4,5) & inlist(cantidad_personas,6,7,8,9,10,11,12,13)))
		replace ilo_job1_ife_prod=1 if ilo_lfs==1 & !inlist(ilo_job1_ife_prod,2,3)
				lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 
				lab val ilo_job1_ife_prod ilo_ife_prod_lab
				lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"		
		
	
	* 2) NATURE OF JOB: FORMAL/INFORMAL EMPLOYMENT
	gen ilo_job1_ife_nature=.
	    replace ilo_job1_ife_nature=1 if ilo_lfs==1 & ///
	                                     ((inlist(ilo_job1_ste_icse93,1,6) & social_security==2) | ///
										 (inlist(ilo_job1_ste_icse93,1,6) & social_security==. & inlist(e9b,2,.)) | ///
										 (inlist(ilo_job1_ste_icse93,1,6) & social_security==. & e9b==1 & inlist(e9a,2,.)) | ///
										 (inlist(ilo_job1_ste_icse93,2,4) & inlist(ilo_job1_ife_prod,1,3)) | ///
										 (ilo_job1_ste_icse93==3 & inlist(ilo_job1_ife_prod,1,3)) | ///
										 (ilo_job1_ste_icse93==5))
	    replace ilo_job1_ife_nature=2 if ilo_lfs==1 & ///
			                             ((inlist(ilo_job1_ste_icse93,1,6) & social_security==1) | ///
										 (inlist(ilo_job1_ste_icse93,1,6) & social_security==. & e9b==1 & e9a==1) | ///
										 (inlist(ilo_job1_ste_icse93,2,4) & ilo_job1_ife_prod==2) | ///
										 (ilo_job1_ste_icse93==3 & ilo_job1_ife_prod==2))
	    replace ilo_job1_ife_nature=. if (ilo_job1_ife_nature==. & ilo_lfs!=1)
                lab def ife_nature_lab 1 "1 - Persons with informal main job" 2 "2 - Persons with formal main job"
		        lab val ilo_job1_ife_nature ife_nature_lab
		        lab var ilo_job1_ife_nature "Informal / Formal Economy (Nature of job)"	
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			 Monthly related income ('ilo_ear_ees' and 'ilo_ear_slf')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Using the already computed variables from the original dataset.
*          - National currency: Costa Rican Colón (CRC).

	
	* MAIN JOB:
	* Employees
	gen ilo_job1_lri_ees = ingreso_bruto_principal if ilo_job1_ste_aggregate==1
	    replace ilo_job1_lri_ees=. if ilo_lfs!=1
		        lab var ilo_job1_lri_ees "Monthly earnings of employees - main job"
	
	* Self-employed
	gen ilo_job1_lri_slf = ingreso_bruto_principal if ilo_job1_ste_aggregate==2
	    replace ilo_job1_lri_slf=. if ilo_lfs!=1
		        lab var ilo_job1_lri_slf "Monthly labour related income of self-employed - main job"
			
	* SECOND JOB:	
	* Employees
	gen ilo_job2_lri_ees = ingreso_bruto_secundario if ilo_job2_ste_aggregate==1
		replace ilo_job2_lri_ees=. if ilo_mjh!=2
		        lab var ilo_job2_lri_ees "Monthly earnings of employees - second job"
		
    * Self-employed		
	gen ilo_job2_lri_slf = ingreso_bruto_secundario if ilo_job2_ste_aggregate==2
		replace ilo_job2_lri_slf=. if ilo_mjh!=2
		        lab var ilo_job2_lri_slf "Monthly labour related income of self-employed - second job"
		
***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************			
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_tru') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - National threshold is set at 40 hours usually worked in all jobs per week.

	gen ilo_joball_tru=.
	    replace ilo_joball_tru=1 if ilo_joball_how_usual<=39 & g1==1 & inlist(g2,1,2) & ilo_lfs==1
			    lab def tru_lab 1 "Time-related underemployed"
			    lab val ilo_joball_tru tru_lab
			    lab var ilo_joball_tru "Time-related underemployed"
			
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Cases of non-fatal occupational injury ('ilo_joball_oi_case') [not available]
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
* Comment: - No information available.

*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Days lost due to cases of occupational injury ('ilo_joball_oi_day') [not available]
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
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
		replace ilo_cat_une=1 if h1==1 & ilo_lfs==2
		replace ilo_cat_une=2 if h1==2 & ilo_lfs==2
		replace ilo_cat_une=3 if ilo_cat_une==. & ilo_lfs==2
			    lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
			    lab val ilo_cat_une cat_une_lab
			    lab var ilo_cat_une "Category of unemployment"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Based on the time when the person left her/his last job.
*          - Category (2) "1 to 3 months" includes category (1) "less than 1 month" (note to
*            value C7:3905).
*          - Category (5) "12 to 24 months" includes category (6) "24 months or more" (note to
*            value C7:3716).

	* Detailed categories		
    gen ilo_dur_details=.
	    * replace ilo_dur_details=1                                             // Less than 1 month
		replace ilo_dur_details=2 if h2==1 & ilo_lfs==2                         // 1 to 3 months (including less than 1 month [C7:3905])
		replace ilo_dur_details=3 if h2==2 & ilo_lfs==2                         // 3 to 6 months
		replace ilo_dur_details=4 if h2==3 & ilo_lfs==2                         // 6 to 12 months
		replace ilo_dur_details=5 if inlist(h2,4,5) & ilo_lfs==2                // 12 to 24 months (including 24 months or more [C7:3716])
		*replace ilo_dur_details=6 if                                           // 24 months or more
		replace ilo_dur_details=7 if ilo_dur_details==. & ilo_lfs==2            // Not elsewhere classified
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
* Comment: - Possibility to map it at 1-digit and aggregate level.

	* 1-digit level
    gen ilo_preveco_isic4=.
	    replace ilo_preveco_isic4 = rama_actividad_desempleo if ilo_lfs==2 & ilo_cat_une==1
	    replace ilo_preveco_isic4 = 22 if ilo_preveco_isic4==99 & ilo_lfs==2 & ilo_cat_une==1
		replace ilo_preveco_isic4 = 22 if ilo_preveco_isic4==. & ilo_lfs==2 & ilo_cat_une==1
  	  		    lab val ilo_preveco_isic4 eco_isic4
			    lab var ilo_preveco_isic4 "Previous economic activity (ISIC Rev. 4)"

   * Aggregate level
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
*			Previous occupation ('ilo_prevocu_isco08') [no info available]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - No information available.

***********************************************************************************************
*			PART 3.4. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - The first category is not possible to compute due to the skip pattern (those not
*            available are redirect to section I where looking for a job is not asked.
*          - No information available concerning willingness, therefore, categories 3 and 4
*            are not possible to be produced. 

	gen ilo_olf_dlma=.
		* replace ilo_olf_dlma = 1 if                                                               // Seeking, not available
		replace ilo_olf_dlma = 2 if inlist(desea_trabajar,8,9) & busca_trabajo==12 & ilo_lfs==3	    // Not seeking, available
		* replace ilo_olf_dlma = 3 if 		                                                        // Not seeking, not available, willing
		* replace ilo_olf_dlma = 4 if 		                                                        // Not seeking, not available, not willing
		replace ilo_olf_dlma = 5 if	(ilo_olf_dlma==. & ilo_lfs==3)				                    // Not classified 
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
			replace ilo_olf_reason=1 if inlist(motivo_nobusco,4,5,6,7,8) & ilo_lfs==3       // Labour market 
			replace ilo_olf_reason=2 if inlist(motivo_nobusco,2,3) & ilo_lfs==3             // Other labour market reasons
			replace ilo_olf_reason=3 if inlist(motivo_nobusco,10,11,12,13) & ilo_lfs==3     // Personal/Family-related
			replace ilo_olf_reason=4 if motivo_nobusco==9                                   // Does not need/want to work
			replace ilo_olf_reason=5 if ilo_olf_reason==. & ilo_lfs==3                      // Not elsewhere classified
 			        lab def lab_olf_reason 1 "1 - Labour market" 2 " 2 - Other labour market reasons" 3 "3 - Personal/Family-related"  ///
				                           4 "4 - Does not need/want to work" 5 "5 - Not elsewhere classified"
					lab val ilo_olf_reason lab_olf_reason
					lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"		

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seekers ('ilo_dis') [done]
* -------------------------------------------------------------------------------------------
* ------------------------------------------------------------------------------------------- 
* Comment:

	gen ilo_dis=.
	    replace ilo_dis=1 if !inlist(ilo_lfs,1,2) & inlist(desea_trabajar,8,9) & ilo_olf_reason==1
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

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

*			SAVE RESULTS

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* -------------------------------------------------------------
* 1.	Prepare final dataset
* -------------------------------------------------------------

cd "$outpath"
	drop ilo_age
	
	/* Variables computed in-between */
	drop social_security
	compress
		
	/* Save dataset including original and ilo variables*/
	save ${country}_${source}_${time}_FULL,  replace		
	
	*Save file only containing ilo_* variables
	keep ilo*
	save ${country}_${source}_${time}_ILO, replace
		



