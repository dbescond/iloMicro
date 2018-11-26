* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Dominican Republic ENCFT
* DATASET USED: do_per_
* NOTES: 
* Files created: Standard variables on ENCFT Dominican Republic
* Authors: ILO / Department of Statistics / DPAU

* Starting Date: 11 January 2018
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
global country "DOM"
global source "ENCFT"
global time "2015Q4"
global inputFile "do_per_t415.dta"
global inpath "${path}\\${country}\\${source}\\${time}\ORI"
global temppath "${path}\_Admin"
global outpath "${path}\\${country}\\${source}\\${time}"

			
*********************************************************************************************
*********************************************************************************************

* Load original dataset

*********************************************************************************************
*********************************************************************************************
* Comment: 

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

	gen ilo_wgt = factor_expansion
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
		        lab def ilo_sex_lab 1 "1 - Male" 2 "2 - Female"
		        lab val ilo_sex ilo_sex_lab
			    lab var ilo_sex "Sex"
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Age above 99 are indicated as 99.

	gen ilo_age=.
	    replace ilo_age=edad
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
*			Level of education ('ilo_edu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Those persons answering "Quisqueya aprende" in question 9 are classified under
*            level "no schooling".
*          - Original question is only asked to people aged 3 years old or more and therefore 
*            those below this age are classified under "level not stated".
*          - ISCED mapping follows unesco mapping and techincal documentation from the central
*            bank (http://uis.unesco.org/en/isced-mappings). 

	gen ilo_edu_isced97=.
	    replace ilo_edu_isced97=1 if inlist(nivel_ultimo_ano_aprobado,9,10)                              // No schooling
		replace ilo_edu_isced97=2 if nivel_ultimo_ano_aprobado==1                                        // Pre-primary education
		replace ilo_edu_isced97=3 if nivel_ultimo_ano_aprobado==2                                        // Primary education
		replace ilo_edu_isced97=4 if (nivel_ultimo_ano_aprobado==3 & inlist(ultimo_ano_aprobado,1,2))    // Lower secondary education
		replace ilo_edu_isced97=5 if (nivel_ultimo_ano_aprobado==3 & inlist(ultimo_ano_aprobado,3,4))    // Upper secondary education
		replace ilo_edu_isced97=6 if nivel_ultimo_ano_aprobado==4                                        // Post-secondary non-terciary education
		replace ilo_edu_isced97=7 if nivel_ultimo_ano_aprobado==5                                        // First stage of tertiary education
		replace ilo_edu_isced97=8 if inlist(nivel_ultimo_ano_aprobado,6,7,8)                             // Second stage of tertiary education
		replace ilo_edu_isced97=9 if ilo_edu_isced97==.                                                  // Level not stated
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
*			Educational attendance ('ilo_edu_attendance') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Question is only ask to people aged 3 years old or more and therefore those below
*            this age are classified under "not elsewhere classified".
*          - People currently attending school, college, university or vocational training.

		gen ilo_edu_attendance=.
			replace ilo_edu_attendance=1 if asiste_centro_educativo==1 & (nivel_se_matriculo!=9)
			replace ilo_edu_attendance=1 if (asiste_centro_educativo==1 & nivel_se_matriculo==9 & porque_no_estudia==1)
			replace ilo_edu_attendance=1 if realiza_curso_tecnico==1
			replace ilo_edu_attendance=2 if ilo_edu_attendance!=1 & asiste_centro_educativo==2
			replace ilo_edu_attendance=2 if ilo_edu_attendance!=1 & (asiste_centro_educativo==1 & nivel_se_matriculo==9 & porque_no_estudia!=1)
			replace ilo_edu_attendance=3 if ilo_edu_attendance==.
				lab def edu_attendance_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
				lab val ilo_edu_attendance edu_attendance_lab
				lab var ilo_edu_attendance "Education (Attendance)"
			

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			           Marital status ('ilo_mrts') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: the majority of the missing observations are related to people aged below 15 years. 
	
	* Detailed
	gen ilo_mrts_details=.
	    replace ilo_mrts_details=1 if estado_civil==6                           // Single
		replace ilo_mrts_details=2 if estado_civil==2                           // Married
		replace ilo_mrts_details=3 if estado_civil==1                           // Union / cohabiting
		replace ilo_mrts_details=4 if estado_civil==5                           // Widowed
		replace ilo_mrts_details=5 if inlist(estado_civil,3,4)                  // Divorced / separated
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
*			Disability status ('ilo_dsb') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment: No information available.

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
* Comment: - Employment includes people who during the reference period: worked for at least
*            one hour, were absent from work because of vacations/leave (options 1, 2 or 3),
*            were absent from work but yet receiving wage/salary or coming back in three months
*            or less.
*          - Unemployment differs from the one reported by the central bank due to the unemployment
*            definition used; while the central bank includes those satisfying the ILO three 
*            criteria, here, it is included those satisfying the ILO three criteria, plus  
*            future starters who are available.
 
	gen ilo_lfs=.
	    replace ilo_lfs=1 if (trabajo_semana_pasada==1 | inrange(realizo_actividad,1,7) | ayudo_familiar_conocido==1) & ilo_wap==1                                                                              // Employed: worked for at least one hour.
		replace ilo_lfs=1 if (tenia_empleo_negocio==1 & inrange(motivo_no_trab_sem_pasada,1,3)) & ilo_wap==1                                                                                                    // Employed: absent from work because of vacations/leave
		replace ilo_lfs=1 if (tenia_empleo_negocio==1 & siguio_recibiendo_sueldo==1) & ilo_wap==1                                                                                                               // Employed: absent from work but yet receiving wage/salary
		replace ilo_lfs=1 if (tenia_empleo_negocio==1 & inlist(tiempo_vuelve_trabajo,1,2)) & ilo_wap==1                                                                                                         // Employed: absent from work but coming back in three months or less
		replace ilo_lfs=2 if (ilo_lfs!=1 & (busco_trabajo_establ_negocio==1 & tiempo_gestion_trabajo==1) & disp_semana_pasada==1) & ilo_wap==1                                                                  // Unemployment
		replace ilo_lfs=2 if (ilo_lfs!=1 & (busco_trabajo_establ_negocio==1 & tiempo_gestion_trabajo==2) & (motivo_no_busca_trabajo==1 & tiempo_inicia_nuevo_trabajo==1) & disp_semana_pasada==1) & ilo_wap==1  // Unemployment: future startes
		replace ilo_lfs=2 if (ilo_lfs!=1 & busco_trabajo_establ_negocio==2 & (motivo_no_busca_trabajo==1 & tiempo_inicia_nuevo_trabajo==1) & disp_semana_pasada==1) & ilo_wap==1                                // Unemployment: future startes
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
		replace ilo_mjh=2 if realizo_trabajo_secundario==1 & ilo_lfs==1
		replace ilo_mjh=1 if ilo_mjh!=2 & ilo_lfs==1
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
* Comment: - Workers in private households and free zones are classified under employees.

	* MAIN JOB	
	* Detailed categories
	  gen ilo_job1_ste_icse93=.
		  replace ilo_job1_ste_icse93=1 if inlist(categoria_principal,1,2,3,4,5) & ilo_lfs==1   // Employees
		  replace ilo_job1_ste_icse93=2 if categoria_principal==6 & ilo_lfs==1                  // Employers
		  replace ilo_job1_ste_icse93=3 if categoria_principal==7 & ilo_lfs==1                  // Own-account workers
		  *replace ilo_job1_ste_icse93=4 if                                                     // Members of producers' cooperatives
		  replace ilo_job1_ste_icse93=5 if categoria_principal==8 & ilo_lfs==1                  // Contributing family workers
		  replace ilo_job1_ste_icse93=6 if ilo_job1_ste_icse93==. & ilo_lfs==1                  // Not classifiable by status
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
	    replace ilo_job2_ste_icse93=1 if inlist(categoria_secundaria,1,2,3,4,5) & ilo_mjh==2  // Employees
		replace ilo_job2_ste_icse93=2 if categoria_secundaria==6 & ilo_mjh==2                 // Employers
		replace ilo_job2_ste_icse93=3 if categoria_secundaria==7 & ilo_mjh==2                 // Own-account workers
		*replace ilo_job2_ste_icse93=4 if                                                     // Members of producers' cooperatives
		replace ilo_job2_ste_icse93=5 if categoria_secundaria==8 & ilo_mjh==2                 // Contributing family workers
		replace ilo_job2_ste_icse93=6 if ilo_job2_ste_icse93==. & ilo_mjh==2                  // Not classifiable by status
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
   	    replace indu_code_prim=int(rama_principal_cod/100) 
		
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
   	    replace indu_code_sec=int(rama_secundaria_cod/100) 
		
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
	    replace occ_code_prim = int(ocupacion_principal_cod/100)
	
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
	    replace occ_code_sec = int(ocupacion_secundaria_cod/100)
	
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
* Comment: - Public: Employee of general government' worker or public entreprise.
	
    * MAIN JOB	
	gen ilo_job1_ins_sector=.
		replace ilo_job1_ins_sector=1 if inlist(categoria_principal,1,2) & ilo_lfs==1
		replace ilo_job1_ins_sector=2 if inrange(categoria_principal,3,8) & ilo_lfs==1
        replace ilo_job1_ins_sector=2 if ilo_job1_ins_sector==. & ilo_lfs==1
                lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
			    lab values ilo_job1_ins_sector ins_sector_lab
			    lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities - main job"

    * SECOND JOB	
	gen ilo_job2_ins_sector=.
		replace ilo_job2_ins_sector=1 if inlist(categoria_secundaria,1,2) & ilo_mjh==2
		replace ilo_job2_ins_sector=2 if inrange(categoria_secundaria,3,8) & ilo_mjh==2
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
		  * Institutional sector: categoria_principal
		  * Destination of production: not asked
		  * Bookkeeping: registro_transacciones_empresa 
		  * Registration: empresa_inscrita_rnc / empresa_tiene_licencia
		  * Status in employment: ilo_job1_ste_icse93==1 (employees)
		  * Social security contribution: afiliado_afp_princ (cont. pension scheme)
		  * Place of work: ubicacion_empresa (not used)
		  * Size: total_personas_trabajan_emp / cantidad_personas_trabajan_emp (not used)
		  * Private HH:  categoria_principal==5 / ilo_job1_eco_isic4_2digits==97 / ilo_job1_ocu_isco08_2digits==63 (5.88%)
		  * Paid annual leave: beneficios_vacaciones_princ (only asked to employees)
		  * Paid sick leave: beneficios_licencia_princ (only asked to employees)
*/
		
    * Social security (to be dropped afterwards)
	gen social_security=.
	    replace social_security=1 if (afiliado_afp_princ==1 & ilo_lfs==1)       // Pension
		replace social_security=2 if (afiliado_afp_princ==2 & ilo_lfs==1)       // No pension
		replace social_security=3 if (afiliado_afp_princ==98 & ilo_lfs==1)      // Don't know  

    * Registration
	gen registration=.
	    replace registration=1 if (empresa_inscrita_rnc==1 | empresa_tiene_licencia==1) & ilo_lfs==1                      // Yes
		replace registration=2 if (inlist(empresa_inscrita_rnc,2,98) & inlist(empresa_tiene_licencia,2,98)) & ilo_lfs==1  // No, Don't know
		
	
    * 1) UNIT OF PRODUCTION: FORMAL/INFORMAL SECTOR		
    gen ilo_job1_ife_prod=.
		replace ilo_job1_ife_prod=2 if ilo_lfs==1 & ///
		                               ((inlist(categoria_principal,1,2)) | ///
									   (inlist(categoria_principal,3,4,6,7,8,.) & registro_transacciones_empresa==1) | ///
									   (inlist(categoria_principal,3,4,6,7,8,.) & registro_transacciones_empresa!=1 & registration==1) | /// 
                                       (inlist(categoria_principal,3,4,6,7,8,.) & registro_transacciones_empresa!=1 & registration==. & ilo_job1_ste_icse93==1 & social_security==1)) 
		replace ilo_job1_ife_prod=3 if ilo_lfs==1 & !inlist(ilo_job1_ife_prod,2) & ///
				                       ((categoria_principal==5) | ///
									   (ilo_job1_eco_isic4_2digits==97 | ilo_job1_ocu_isco08_2digits==63)) 
		replace ilo_job1_ife_prod=1 if ilo_lfs==1 & !inlist(ilo_job1_ife_prod,2,3)
				lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 
				lab val ilo_job1_ife_prod ilo_ife_prod_lab
				lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"		
						
    * 2) NATURE OF JOB: FORMAL/INFORMAL EMPLOYMENT
	gen ilo_job1_ife_nature=.
	    replace ilo_job1_ife_nature=1 if ilo_lfs==1 & ///
	                                     ((inlist(ilo_job1_ste_icse93,1,6) & social_security==2) | ///
										 (inlist(ilo_job1_ste_icse93,1,6) & inlist(social_security,3,.) & inlist(beneficios_vacaciones_princ,2,98,.)) | ///
										 (inlist(ilo_job1_ste_icse93,1,6) & inlist(social_security,3,.) & beneficios_vacaciones_princ==1 & inlist(beneficios_licencia_princ,2,98,.)) | ///
										 (inlist(ilo_job1_ste_icse93,2,4) & inlist(ilo_job1_ife_prod,1,3)) | ///
										 (ilo_job1_ste_icse93==3 & inlist(ilo_job1_ife_prod,1,3)) | ///
										 (ilo_job1_ste_icse93==5))
	    replace ilo_job1_ife_nature=2 if ilo_lfs==1 & ///
			                             ((inlist(ilo_job1_ste_icse93,1,6) & social_security==1) | ///
										 (inlist(ilo_job1_ste_icse93,1,6) & inlist(social_security,3,.) & beneficios_vacaciones_princ==1 & beneficios_licencia_princ==1) | ///
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
* Comment: - No information available for the hours usually worked in the second job.

	* MAIN JOB
    * 1) Weekly hours USUALLY worked:	
	gen ilo_job1_how_usual=.
	    replace ilo_job1_how_usual = horas_trabaja_semana_principal if ilo_lfs==1
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
	    replace ilo_job1_how_actual = horas_trabajo_efect_total if ilo_lfs==1
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
	* No information available
	
	* 2) Weekly hours ACTUALLY worked:
	gen ilo_job2_how_actual=.
	    replace ilo_job2_how_actual = horas_trabajo_ocup_secun if ilo_mjh==2
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
	* 1) Weekly hours ACTUALLY worked:
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
* Comment: - The threshold is set at 40 for those working in the public sector, and 44 for 
*            those working in the private sector.
*          - Based on the usual hours of work for main job.
	
	gen ilo_job1_job_time=.
		replace ilo_job1_job_time=2 if ((ilo_job1_ins_sector==1 & ilo_job1_how_usual>=40 & ilo_job1_how_usual!=.) | (ilo_job1_ins_sector==2 & ilo_job1_how_usual>=44 & ilo_job1_how_usual!=.)) & ilo_lfs==1
		replace ilo_job1_job_time=1 if (ilo_job1_ins_sector==1 & ilo_job1_how_usual<40 & ilo_job1_how_usual!=.) | (ilo_job1_ins_sector==2 & ilo_job1_how_usual<44 & ilo_job1_how_usual!=.) & ilo_lfs==1
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
	
	gen ilo_job1_job_contract=.
		replace ilo_job1_job_contract=1 if tipo_contrato==1 & ilo_job1_ste_aggregate==1
		replace ilo_job1_job_contract=2 if inlist(tipo_contrato,2,3) & ilo_job1_ste_aggregate==1
		replace ilo_job1_job_contract=3 if ilo_job1_job_contract==. & ilo_job1_ste_aggregate==1
				lab def job_contract_lab 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"
			    lab val ilo_job1_job_contract job_contract_lab
			    lab var ilo_job1_job_contract "Job (Type of contract)"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Earnings ('ilo_ear_ees' and 'ilo_ear_slf')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: 

	* MAIN JOB
	* Employees
	* 1) wage or salary
	  gen monthly_earnings1=.
	      replace monthly_earnings1 = sueldo_bruto_ap_monto if (tiempo_recibe_pago_ap==4 & ilo_lfs==1)
		  replace monthly_earnings1 = sueldo_bruto_ap_monto*2 if (tiempo_recibe_pago_ap==3 & ilo_lfs==1)
	      replace monthly_earnings1 = sueldo_bruto_ap_monto*4 if (tiempo_recibe_pago_ap==2 & ilo_lfs==1)
		  replace monthly_earnings1 = sueldo_bruto_ap_monto*tiempo_recibe_pago_dias_ap*4 if (tiempo_recibe_pago_ap==1 & ilo_lfs==1)
		  replace monthly_earnings1 =. if forma_pagan_salario_ap!=1             // Wage or salary
		  replace monthly_earnings1 =. if sueldo_bruto_ap_moneda!="DOP"         // Currency
		  replace monthly_earnings1 =.  
		  
    * 2) comisions/tips/others (monthly)
	  egen monthly_earnings2 = rowtotal(comisiones_ap_monto propinas_ap_monto otros_pagos_ap_monto), m
	       replace monthly_earnings2 =. if ilo_lfs!=1
	       replace monthly_earnings2 =. if forma_pagan_salario_ap!=2            // Comisions or/and tips
		   
    * 3) in kind
	  egen monthly_earnings3 = rowtotal(alimentacion_especie_ap_monto vivienda_especie_ap_monto transporte_especie_ap_monto gasolina_especie_ap_monto celular_especie_ap_monto otros_especie_ap_monto), m
	       replace monthly_earnings3 =. if ilo_lfs!=1
		   replace monthly_earnings3 =. if forma_pagan_salario_ap!=3            // Payments in kind

	* 4) total labour related income of employees
	  egen ilo_job1_lri_ees = rowtotal(monthly_earnings1 monthly_earnings2 monthly_earnings3), m 
	       replace ilo_job1_lri_ees = . if ilo_job1_ste_aggregate!=1
	               lab var ilo_job1_lri_ees "Monthly earnings of employees - main job"
				 
	* Self-employed
    * 1) income or profit
	  gen monthly_earnings4=.
	      * last 6 months
		  replace monthly_earnings4 = ganancia_in_productor_monto/6 if inlist(forma_trabajo_realizo_in,1,2) & ilo_lfs==1		  
		  * last month
	      replace monthly_earnings4 = ingreso_actividad_in_monto if (ingreso_actividad_in_periodo==4 & forma_trabajo_realizo_in==99 & ilo_lfs==1)
		  replace monthly_earnings4 = ingreso_actividad_in_monto*2 if (ingreso_actividad_in_periodo==3 & forma_trabajo_realizo_in==99 & ilo_lfs==1)
		  replace monthly_earnings4 = ingreso_actividad_in_monto*4 if (ingreso_actividad_in_periodo==2 & forma_trabajo_realizo_in==99 & ilo_lfs==1)
		  replace monthly_earnings4 = ingreso_actividad_in_monto*ingreso_actividad_in_dias*4 if (ingreso_actividad_in_periodo==1 & forma_trabajo_realizo_in==99 & ilo_lfs==1)
		  replace monthly_earnings4 =. if ingreso_actividad_in_moneda!="DOP" & forma_trabajo_realizo_in==99
		
    * 2) in kind
	  gen monthly_earnings5=.
	      replace monthly_earnings5 = pago_especies_in_monto if ilo_lfs==1		
	
	* 3) total labour related income of self-employed
	 egen ilo_job1_lri_slf = rowtotal(monthly_earnings4 monthly_earnings5), m 
	      replace ilo_job1_lri_slf =. if ilo_job1_ste_aggregate!=2
	          lab var ilo_job1_lri_slf "Monthly labour related income of self-employed - main job"
			  
	* SECOND JOB
	* Employees
	* 1) wage or salary/comisions/tips/in kind
	egen ilo_job2_lri_ees = rowtotal(sueldo_bruto_as_monto otros_pago_as_monto pago_en_especie_as_monto), m
	     replace ilo_job2_lri_ees =. if ilo_mjh!=2
         replace ilo_job2_lri_ees =. if ilo_job2_ste_aggregate!=1
		 replace ilo_job2_lri_ees =. if sueldo_bruto_as_moneda!="DOP"
		         lab var ilo_job2_lri_ees "Monthly earnings of employees - second job"

	* Self-employed
    * 1) income or profit
	  gen monthly_earnings6=.
	      * last 6 months
		  replace monthly_earnings6 = ganancia_is_productor_monto/6 if inlist(forma_trabajo_realizo_is,1,2) & ilo_mjh==2		  
		  * last month
	      replace monthly_earnings6 = ingreso_actividad_is_monto if (ingreso_actividad_is_periodo==4 & forma_trabajo_realizo_is==99 & ilo_mjh==2)
		  replace monthly_earnings6 = ingreso_actividad_is_monto*2 if (ingreso_actividad_is_periodo==3 & forma_trabajo_realizo_is==99 & ilo_mjh==2)
		  replace monthly_earnings6 = ingreso_actividad_is_monto*4 if (ingreso_actividad_is_periodo==2 & forma_trabajo_realizo_is==99 & ilo_mjh==2)
		  replace monthly_earnings6 = ingreso_actividad_is_monto*ingreso_actividad_is_dias*4 if (ingreso_actividad_is_periodo==1 & forma_trabajo_realizo_is==99 & ilo_mjh==2)
		  replace monthly_earnings6 =. if ingreso_actividad_is_moneda!="DOP" & forma_trabajo_realizo_is==99
		
    * 2) in kind
	  gen monthly_earnings7=.
	      replace monthly_earnings7 = pago_especies_is_monto if ilo_mjh==2		
	
	* 3) total labour related income of self-employed
	 egen ilo_job2_lri_slf = rowtotal(monthly_earnings6 monthly_earnings7), m 
	      replace ilo_job2_lri_slf =. if ilo_job2_ste_aggregate!=2
	          lab var ilo_job2_lri_slf "Monthly labour related income of self-employed - second job"	
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_tru') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - The threshold is set at 40 for those working in the public sector, and 44 for 
*            those working in the private sector. (note to value: T4:1601).
			
	gen ilo_joball_tru=.
	    replace ilo_joball_tru=1 if ((ilo_job1_ins_sector==1 & ilo_joball_how_actual<40) | (ilo_job1_ins_sector==2 & ilo_joball_how_actual<44)) & desea_trabajar_mas_horas==1 & inlist(disp_horas_adicionales,1,2) & cantidad_horas_adicionales>0 & ilo_lfs==1	
		replace ilo_joball_tru=. if ilo_lfs!=1
		        lab def tru_lab 1 "Time-related underemployment"
		        lab val ilo_joball_tru tru_lab
		        lab var ilo_joball_tru "Time-related underemployment"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupational injury ('ilo_joball_inj') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
* Comment:  - Information not available.

*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Days lost due to cases of occupational injury ('ilo_joball_oi_day') [done]
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
* Comment: - Information not available.

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
		replace ilo_cat_une=1 if trabajo_antes==1 & ilo_lfs==2			        // Previously employed
		replace ilo_cat_une=2 if trabajo_antes==2 & ilo_lfs==2			        // Seeking first job
		replace ilo_cat_une=3 if ilo_lfs==2 & !inlist(ilo_cat_une,1,2)	        // Unkown
			    lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
			    lab val ilo_cat_une cat_une_lab
			    lab var ilo_cat_une "Category of unemployment"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur') [done]
* -------------------------------------------------------------------------------------------
* Comment: - category 2 (1 to 3 months) includes category 3 (3 to 6 months) (note to value: C7:3906)
*          - category 5 (12 to 24 months) includes category 6 (24 months or more) (note to value: C7:3716)

	* Detailed categories		
    gen ilo_dur_details=.
	    replace ilo_dur_details=1 if (que_tiempo_busca_trabajo==1 & ilo_lfs==2)       // Less than 1 month
		replace ilo_dur_details=2 if (que_tiempo_busca_trabajo==2 & ilo_lfs==2)       // 1 to 3 months (including 3 to 6 months) [C7:3906]
		*replace ilo_dur_details=3 if                                                 // 3 to 6 months
		replace ilo_dur_details=4 if (que_tiempo_busca_trabajo==3 & ilo_lfs==2)       // 6 to 12 months
		replace ilo_dur_details=5 if (que_tiempo_busca_trabajo==4 & ilo_lfs==2)       // 12 to 24 months (including 24 months or more) [C7:3716]
		*replace ilo_dur_details=6 if                                                 // 24 months or more
		replace ilo_dur_details=7 if (que_tiempo_busca_trabajo==. & ilo_lfs==2)       // Not elsewhere classified
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
* Comment: - Original classification follows ISIC Rev. 4.
	
	* ISIC Rev. 4 - 2 digit
	gen ilo_preveco_isic4_2digits=.
		replace ilo_preveco_isic4_2digits = int(rama_cesantia_cod/100) if ilo_lfs==2 & ilo_cat_une==1
		        lab val ilo_preveco_isic4_2digits eco_isic4_2digits
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
		replace ilo_preveco_isic4=22 if ilo_preveco_isic4==. & ilo_lfs==2 & ilo_cat_une==1
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
*			Previous occupation ('ilo_prevocu_isco88') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Original classification follows ISCO-08.
	
	* ISCO-08 - 2 digits		
	gen ilo_prevocu_isco08_2digits = int(ocupacion_cesantia_cod/100) if ilo_lfs==2 & ilo_cat_une==1
		lab values ilo_prevocu_isco08_2digits ocu08_2digits
		lab var ilo_prevocu_isco08_2digits "Previous occupation (ISCO-08), 2 digit level"

    * One digit-level
	gen ilo_prevocu_isco08=.
	    replace ilo_prevocu_isco08 = 11 if (ilo_prevocu_isco08_2digits==. & ilo_lfs==2 & ilo_cat_une==1)                           //Not elsewhere classified
		replace ilo_prevocu_isco08 = int(ilo_prevocu_isco08_2digits/10) if (ilo_prevocu_isco08==. & ilo_lfs==2 & ilo_cat_une==1)   //The rest of the occupations
		replace ilo_prevocu_isco08 = 10 if (ilo_prevocu_isco08==0 & ilo_lfs==2 & ilo_cat_une==1)                                   //Armed forces
				lab val ilo_prevocu_isco08 ocu_isco08
				lab var ilo_prevocu_isco08 "Previous occupation (ISCO-08)"
			
	* Aggregate
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
			    lab var ilo_prevocu_skill "Previous occupation (Skill level)"

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
		replace ilo_olf_dlma = 1 if (busco_trabajo_establ_negocio==1 & disp_semana_pasada==2 & ilo_lfs==3)	   // Seeking, not available
		replace ilo_olf_dlma = 2 if (busco_trabajo_establ_negocio==2 & disp_semana_pasada==1 & ilo_lfs==3)	   // Not seeking, available
		*replace ilo_olf_dlma = 3 if 		                                                                   // Not seeking, not available, willing
		*replace ilo_olf_dlma = 4 if  	                                                                       // Not seeking, not available, not willing
		replace ilo_olf_dlma = 5 if	(ilo_olf_dlma==. & ilo_lfs==3)				                               // Not classified 
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
		replace ilo_olf_reason=1 if inlist(motivo_no_busca_trabajo,4,5,6) & ilo_lfs==3         // Labour market
		replace ilo_olf_reason=2 if inlist(motivo_no_busca_trabajo,3) & ilo_lfs==3             // Other labour market reasons
		replace ilo_olf_reason=3 if inlist(motivo_no_busca_trabajo,2,7,8,9,11) & ilo_lfs==3    // Personal/Family-related
		replace ilo_olf_reason=4 if inlist(motivo_no_busca_trabajo,10,12) & ilo_lfs==3         // Does not need/want to work
		replace ilo_olf_reason=5 if ilo_olf_reason==. & ilo_lfs==3                             // Not elsewhere classified
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
	    replace ilo_dis=1 if !inlist(ilo_lfs,1,2) & disp_semana_pasada==1 & ilo_olf_reason==1
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
		drop indu_code_prim indu_code_sec occ_code_prim occ_code_sec social_security monthly_earnings1 monthly_earnings2
		drop monthly_earnings3 monthly_earnings4 monthly_earnings5 monthly_earnings6 monthly_earnings7
		
		compress 
		
	   /*Save dataset including original and ilo variables*/
		save ${country}_${source}_${time}_FULL,  replace		
	
	   /* Save file only containing ilo_* variables*/
		keep ilo*

		save ${country}_${source}_${time}_ILO, replace
		



