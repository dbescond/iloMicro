* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Paraguay ECE
* DATASET USED: REG02_ECE
* NOTES: 
* Files created: Standard variables on ENFT Dominican Republic
* Authors: DPAU
* Who last updated the file: DPAU
* Starting Date: 05 December 2017
* Last updated: 05 December 2017
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
global country "PRY"
global source "ECE"
global time "2016Q1"
global inputFile "REG02_ECET05.DTA"
global inpath "${path}\\${country}\\${source}\\${time}\ORI"
global temppath "${path}\_Admin"
global outpath "${path}\\${country}\\${source}\\${time}"
			
*********************************************************************************************
*********************************************************************************************

* Load original dataset

*********************************************************************************************
*********************************************************************************************
* Comment: - Data set was converted to dta format using StatTransfer

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

	gen ilo_wgt=fex
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
* Comment: - Information not available on the dataset downloaded from the NSO's website. 		 

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: 

	gen ilo_sex=.
	    replace ilo_sex=1 if p04==1
		replace ilo_sex=2 if p04==6
		        lab def ilo_sex_lab 1 "1 - Male" 2 "2 - Female"
		        lab var ilo_sex "Sex"
		        lab val ilo_sex ilo_sex_lab			
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age') [to check---]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Only available by 5 years bands.
*          - to check: originally, last category is "60+", the category is mapped to "65+" and
*            a note to value is added [C6:1504]; is it possible to carry this note elsewhere when needed? [C6:1504]
*          - to check: in line with the previous note, category 6 & 7 in 10 years bands would need a note to value
*            respectively: Category 6 excludes 60-64; category 7 includes 60-64. [C6:4125][C6:1504]
*          - to check: similar situation for the aggregated indicator: category 4 excludes 60-64;
*            category 5 includes 60-64. [C6:1504]

	* Age groups
	gen ilo_age_5yrbands=.
		replace ilo_age_5yrbands=1 if edad_quin==1
		replace ilo_age_5yrbands=2 if edad_quin==2
		replace ilo_age_5yrbands=3 if edad_quin==3
		replace ilo_age_5yrbands=4 if edad_quin==4
		replace ilo_age_5yrbands=5 if edad_quin==5
		replace ilo_age_5yrbands=6 if edad_quin==6
		replace ilo_age_5yrbands=7 if edad_quin==7
		replace ilo_age_5yrbands=8 if edad_quin==8
		replace ilo_age_5yrbands=9 if edad_quin==9
		replace ilo_age_5yrbands=10 if edad_quin==10
		replace ilo_age_5yrbands=11 if edad_quin==11
		replace ilo_age_5yrbands=12 if edad_quin==12
		*replace ilo_age_5yrbands=13 if
		replace ilo_age_5yrbands=14 if edad_quin==13                            // Including 60-64
			lab def age_by5_lab 1 "0-4" 2 "5-9" 3 "10-14" 4 "15-19" 5 "20-24" 6 "25-29" 7 "30-34" 8 "35-39" 9 "40-44" 10 "45-49" 11 "50-54" 12 "55-59" 13 "60-64" 14 "65+"
			lab val ilo_age_5yrbands age_by5_lab
			lab var ilo_age_5yrbands "Age (5-year age bands)"
			
	gen ilo_age_10yrbands=.
		replace ilo_age_10yrbands=1 if inrange(ilo_age_5yrbands,1,3)
		replace ilo_age_10yrbands=2 if inrange(ilo_age_5yrbands,4,5)
		replace ilo_age_10yrbands=3 if inrange(ilo_age_5yrbands,6,7)
		replace ilo_age_10yrbands=4 if inrange(ilo_age_5yrbands,8,9)
		replace ilo_age_10yrbands=5 if inrange(ilo_age_5yrbands,10,11)
		replace ilo_age_10yrbands=6 if ilo_age_5yrbands==12                     // Excluding 60-64
		replace ilo_age_10yrbands=7 if ilo_age_5yrbands==14                     // Including 60-64
			lab def age_by10_lab 1 "<15" 2 "15-24" 3 "25-34" 4 "35-44" 5 "45-54" 6 "55-64" 7 "65+"
			lab val ilo_age_10yrbands age_by10_lab
			lab var ilo_age_10yrbands "Age (10-year age bands)"
			
	gen ilo_age_aggregate=.
		replace ilo_age_aggregate=1 if inrange(ilo_age_5yrbands,1,3)
		replace ilo_age_aggregate=2 if inrange(ilo_age_5yrbands,4,5)
		replace ilo_age_aggregate=3 if inrange(ilo_age_5yrbands,6,11)           
		replace ilo_age_aggregate=4 if ilo_age_5yrbands==12                     // Excluding 60-64                    
		replace ilo_age_aggregate=5 if ilo_age_5yrbands==14                     // Including 60-64
			lab def age_aggr_lab 1 "<15" 2 "15-24" 3 "25-54" 4 "55-64" 5 "65+"
			lab val ilo_age_aggregate age_aggr_lab
			lab var ilo_age_aggregate "Age (Aggregate)"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Level of education ('ilo_edu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Original question is only asked to people 5 years old or more and therefore those
*            below this age are classified under "level not stated".
*          - Due to the lack of availability of question 4 (highest level and cycle of education
*            approved), it is only possible to compute the variable at the aggregated level. 
*            It is used here a combination of the level currently attendend and the number of 
*            years of study for those not answering to this one.
*          - For those who answered they are currently attending (5 to 50 years old), the mapping
*            is made using quesition 5 in section 5 (education).
A combination of questions 8 (highest level concluded) and 9 (correspondant level
*            within the level) in section B is used here.
*          - Question is only ask to people aged 4 years old or more and therefore those below
*            this age are classified under "level not stated".
*          - ISCED mapping follows the one found here: http://uis.unesco.org/en/isced-mappings 

	gen ilo_edu_isced97=.
		replace ilo_edu_isced97=1 if (ed03==6) |  (ed05==1)                        // No schooling
		replace ilo_edu_isced97=2 if (s3_09==1 & s3_08==3) | (s3_09==2 & inrange(s3_08,1,5))            // Pre-primary education
		replace ilo_edu_isced97=3 if s3_09==2 & inrange(s3_08,6,7)                                      // Primary education
		replace ilo_edu_isced97=4 if (s3_09==2 & s3_08==8) | (inlist(s3_09,3,4) & inrange(s3_08,1,3))   // Lower secondary education
		replace ilo_edu_isced97=5 if (s3_09==3 & s3_08==4) | (s3_09==5 & inrange(s3_08,1,3))            // Upper secondary education
		replace ilo_edu_isced97=6 if s3_09==4 & s3_08==4                                                // Post-secondary non-terciary education
		replace ilo_edu_isced97=7 if (s3_09==5 & inrange(s3_08,4,5)) | (s3_09==6 & s3_08==1)            // First stage of tertiary education
		replace ilo_edu_isced97=8 if s3_09==6 & inrange(s3_08,2,4)                                      // Second stage of tertiary education
		replace ilo_edu_isced97=9 if ilo_edu_isced97==.                                                 // Level not stated 
			    label def isced_97_lab 1 "X - No schooling" 2 "0 - Pre-primary education" 3 "1 - Primary education or first stage of basic education" ///
				                       4 "2 - Lower secondary education or second stage of basic education" 5 "3 - Upper secondary education" ///
									   6 "4 - Post-secondary non-tertiary education" 7 "5 - First stage of tertiary education (not leading directly to an advanced research qualification)" ///
							           8 "6 - Second stage of tertiary education (leading to an advanced research qualification)" 9 "UNK - Level not stated"
			    label val ilo_edu_isced97 isced_97_lab
			    lab var ilo_edu_isced97 "Education (ISCED 97)"

	* Aggregate	
	gen ilo_edu_aggregate=.
		replace ilo_edu_aggregate=1 if (ed03==6)inlist(ilo_edu_isced97,1,2)
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
* Comment: - It uses the variables asking for the level in which the person is enrolled and
*            the schedule that s/he is normally attending.
*          - Question is only ask to people aged 4 years old or more and therefore those below
*            this age are classified under "level not stated".

		gen ilo_edu_attendance=.
		if (`Y'>=2013){	
			replace ilo_edu_attendance=1 if inrange(s3_10,1,6) & s3_11!=7
			replace ilo_edu_attendance=2 if s3_10==7
			replace ilo_edu_attendance=3 if ilo_edu_attendance==.
		}
		if (`Y'<=2012){
			replace ilo_edu_attendance=1 if inrange(eft_se_matriculo,1,6) & eft_tanda_asiste!=7
			replace ilo_edu_attendance=2 if eft_se_matriculo==7
			replace ilo_edu_attendance=3 if ilo_edu_attendance==.
		}	
				lab def edu_attendance_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
				lab val ilo_edu_attendance edu_attendance_lab
				lab var ilo_edu_attendance "Education (Attendance)"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Disability status ('ilo_dsb') 	[done]
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
* Comment: - wap = 15+ 

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
* Comment: - Employment differs from the one reported by the national statistical office due 
*            to the age coverage used here (NSO includes persons aged 10 years old or more).
*          - Unemployment comprises people not in employment and actively seeking for 
*            a job or trying to establish a business in the past week or past four weeks
*            (availability is not asked to the whole group but only to those who answered 
*            "no" to looking for a job/business)(qtable: T5:1429). 

 
	gen ilo_lfs=.
	if (`Y'>=2013){	
	    replace ilo_lfs=1 if (s4_02==1 | s4_03==1) & ilo_wap==1                              // Employed: worked for at least one hour last week or was absent.
		replace ilo_lfs=1 if (s4_06a==1 | s4_06b==1 | s4_06c==1 | s4_06d==1) & ilo_wap==1    // Employed: did one of the listed activities.
		replace ilo_lfs=2 if (ilo_lfs!=1 & (s4_07==1 | s4_08==1)) & ilo_wap==1               // Unemployment (two criteria)
		replace ilo_lfs=3 if !inlist(ilo_lfs,1,2) & ilo_wap==1                               // Outside the labour force
    }
	if (`Y'<=2012){
	    replace ilo_lfs=1 if (eft_trabajo_sem_ant==1 | eft_tuvo_act_econ_sem_ant==1) & ilo_wap==1                                                       // Employed: worked for at least one hour last week or was absent.
		replace ilo_lfs=1 if (eft_cultivo_sem_ant==1 | eft_elab_prod_sem_ant==1 | eft_ayudo_fam_sem_ant==1 | eft_cosio_lavo_sem_ant==1) & ilo_wap==1    // Employed: did one of the listed activities.
		replace ilo_lfs=2 if (ilo_lfs!=1 & (eft_busco_trab_sem_ant==1 | eft_busco_trab_mes_ant==1)) & ilo_wap==1                                        // Unemployment (two criteria)
		replace ilo_lfs=3 if !inlist(ilo_lfs,1,2) & ilo_wap==1                                                                                          // Outside the labour force
	}
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
	if (`Y'>=2013){		
		replace ilo_mjh=1 if s4_26==2 & ilo_lfs==1
		replace ilo_mjh=2 if s4_26==1 & ilo_lfs==1
		replace ilo_mjh=. if ilo_lfs!=1
    }
	if (`Y'<=2012){
		replace ilo_mjh=1 if eft_tiene_ocup_secun==2 & ilo_lfs==1
		replace ilo_mjh=2 if eft_tiene_ocup_secun==1 & ilo_lfs==1
		replace ilo_mjh=. if ilo_lfs!=1
	}	
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
* Comment: - Employees include domestic workers.

	* MAIN JOB	
	* Detailed categories
	  gen ilo_job1_ste_icse93=.
	  if (`Y'>=2013){	
		  replace ilo_job1_ste_icse93=1 if inlist(s4_18,1,2,3,8) & ilo_lfs==1   // Employees
		  replace ilo_job1_ste_icse93=2 if s4_18==6 & ilo_lfs==1                // Employers
		  replace ilo_job1_ste_icse93=3 if inlist(s4_18,4,5) & ilo_lfs==1       // Own-account workers
		  *replace ilo_job1_ste_icse93=4 if                                     // Members of producers' cooperatives
		  replace ilo_job1_ste_icse93=5 if s4_18==7 & ilo_lfs==1                // Contributing family workers
		  replace ilo_job1_ste_icse93=6 if ilo_job1_ste_icse93==. & ilo_lfs==1  // Not classifiable by status
	  }
	  if (`Y'<=2012){
	  	  replace ilo_job1_ste_icse93=1 if inlist(eft_categoria_ocup_princ,1,2,3,8) & ilo_lfs==1   // Employees
		  replace ilo_job1_ste_icse93=2 if eft_categoria_ocup_princ==6 & ilo_lfs==1                // Employers
		  replace ilo_job1_ste_icse93=3 if inlist(eft_categoria_ocup_princ,4,5) & ilo_lfs==1       // Own-account workers
		  *replace ilo_job1_ste_icse93=4 if                                                        // Members of producers' cooperatives
		  replace ilo_job1_ste_icse93=5 if eft_categoria_ocup_princ==7 & ilo_lfs==1                // Contributing family workers
		  replace ilo_job1_ste_icse93=6 if ilo_job1_ste_icse93==. & ilo_lfs==1                     // Not classifiable by status
	  }
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

	  * Secondary activity
      * No information available.
	  
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - According to the national report, the original classification follows ISIC Rev.
*            3.1 at 3-digits level.
	
	gen indu_code_prim=.
    if (`Y'>=2013){
	    replace indu_code_prim=int(s4_17a/10) 
	}
    if (`Y'<=2012){
	    replace indu_code_prim=int(eft_rama_princ/10) 
	}
	
	
	* MAIN JOB:
	gen ilo_job1_eco_isic3_2digits=indu_code_prim if ilo_lfs==1
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
                                 72 "72 - Computer and related activities"	73 "73 - Research and development"	74 "74 - Other business activities"	75 "75 - Public administration and defence; compulsory social security"	 ///
                                 80 "80 - Education"	85 "85 - Health and social work"	90 "90 - Sewage and refuse disposal, sanitation and similar activities"	91 "91 - Activities of membership organizations n.e.c."	 ///
                                 92 "92 - Recreational, cultural and sporting activities"	93 "93 - Other service activities"	95 "95 - Activities of private households as employers of domestic staff"	96 "96 - Undifferentiated goods-producing activities of private households for own use"	 ///
                                 97 "97 - Undifferentiated service-producing activities of private households for own use"	99 "99 - Extra-territorial organizations and bodies"			
        lab val ilo_job1_eco_isic3_2digits eco_isic3_2digits								 
        lab var ilo_job1_eco_isic3_2digits "Economic activity (ISIC Rev. 3.1), 2 digits levels - main job"

	* 1 digit-level
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
		        lab def eco_isic3_1digit 1 "A - Agriculture, hunting and forestry"	2 "B - Fishing"	3 "C - Mining and quarrying"	4 "D - Manufacturing"	///
                                         5 "E - Electricity, gas and water supply"	6 "F - Construction"	7 "G - Wholesale and retail trade; repair of motor vehicles, motorcycles and personal and household goods"	8 "H - Hotels and restaurants"	///
                                         9 "I - Transport, storage and communications"	10 "J - Financial intermediation"	11 "K - Real estate, renting and business activities"	12 "L - Public administration and defence; compulsory social security"	///
                                         13 "M - Education"	14 "N - Health and social work"	15 "O - Other community, social and personal service activities"	16 "P - Activities of private households as employers and undifferentiated production activities of private households"	///
                                         17 "Q - Extraterritorial organizations and bodies"	18 "X - Not elsewhere classified"			
			    lab val ilo_job1_eco_isic3 eco_isic3_1digit
			    lab var ilo_job1_eco_isic3 "Economic activity (ISIC Rev. 3.1) - main job "

	* Aggregate level	
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
			    lab var ilo_job1_eco_aggregate "Economic activity (Aggregate) - main job"
			
	* Secondary activity
	* No information available
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_ocu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - According to the national report, original classification follows ISCO-88 at 
*            3 digit-level.
	
	gen occ_code_prim=.
    if (`Y'>=2013){
	    replace occ_code_prim=int(s4_16a/10)
	}
    if (`Y'<=2012){
	    replace occ_code_prim=int(eft_ocupacion_princ/10) 
	}
		
	* MAIN JOB		
	gen ilo_job1_ocu_isco88_2digits=occ_code_prim if ilo_lfs==1
	    lab def ocu88_2digits 1 "01 - Armed forces"	11 "11 - Legislators and senior officials"	12 "12 - Corporate managers"	13 "13 - General managers" ///
                              21 "21 - Physical, mathematical and engineering science professionals"	22 "22 - Life science and health professionals"	23 "23 - Teaching professionals"	24 "24 - Other professionals" ///
                              31 "31 - Physical and engineering science associate professionals"	32 "32 - Life science and health associate professionals"	33 "33 - Teaching associate professionals"	34 "34 - Other associate professionals" ///
                              41 "41 - Office clerks"	42 "42 - Customer services clerks"	51 "51 - Personal and protective services workers"	52 "52 - Models, salespersons and demonstrators" ///
                              61 "61 - Skilled agricultural and fishery workers"	62 "62 - Subsistence agricultural and fishery workers"	71 "71 - Extraction and building trades workers"	72 "72 - Metal, machinery and related trades workers" ///
                              73 "73 - Precision, handicraft, craft printing and related trades workers"	74 "74 - Other craft and related trades workers"	81 "81 - Stationary plant and related operators"	82 "82 - Machine operators and assemblers" ///
                              83 "83 - Drivers and mobile plant operators"	91 "91 - Sales and services elementary occupations"	92 "92 - Agricultural, fishery and related labourers"	93 "93 - Labourers in mining, construction, manufacturing and transport"
		lab values ilo_job1_ocu_isco88_2digits ocu88_2digits
		lab var ilo_job1_ocu_isco88_2digits "Occupation (ISCO-88), 2 digit level - main job"

    * One digit-level
	gen ilo_job1_ocu_isco88=.
	    replace ilo_job1_ocu_isco88=11 if (ilo_job1_ocu_isco88_2digits==. & ilo_lfs==1)                           //Not elsewhere classified
		replace ilo_job1_ocu_isco88=int(ilo_job1_ocu_isco88_2digits/10) if (ilo_job1_ocu_isco88==. & ilo_lfs==1)  //The rest of the occupations
		replace ilo_job1_ocu_isco88=10 if (ilo_job1_ocu_isco88==0 & ilo_lfs==1)                                   //Armed forces
	            lab def ocu88_1digit 1 "1 - Legislators, senior officials and managers"	2 "2 - Professionals"	3 "3 - Technicians and associate professionals" 4 "4 - Clerks" ///
                                     5 "5 - Service workers and shop and market sales workers"	6 "6 - Skilled agricultural and fishery workers"	7 "7 - Craft and related trades workers" 8	"8 - Plant and machine operators and assemblers" ///
                                     9 "9 - Elementary occupations"	10 "0 - Armed forces"	11 "11 - Not elsewhere classified"
				lab val ilo_job1_ocu_isco88 ocu88_1digit
				lab var ilo_job1_ocu_isco88 "Occupation (ISCO-88) - main job"
			
	* Aggregate:			
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
				
    * Skill level				
    gen ilo_job1_ocu_skill=.
	    replace ilo_job1_ocu_skill=1 if ilo_job1_ocu_isco88==9                   // Low
		replace ilo_job1_ocu_skill=2 if inlist(ilo_job1_ocu_isco88,4,5,6,7,8)    // Medium
		replace ilo_job1_ocu_skill=3 if inlist(ilo_job1_ocu_isco88,1,2,3)        // High
		replace ilo_job1_ocu_skill=4 if inlist(ilo_job1_ocu_isco88,10,11)        // Not elsewhere classified
				lab def ocu_skill_lab 1 "1 - Skill level 1 (low)" 2 "2 - Skill level 2 (medium)" 3 "3 - Skill levels 3 and 4 (high)" 4 "4 - Not elsewhere classified"
			    lab val ilo_job1_ocu_skill ocu_skill_lab
			    lab var ilo_job1_ocu_skill "Occupation (Skill level) - main job"

	* Secondary activity
	* No information available

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_ins_sector') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Public: Employee or general government' worker or public entreprise.
	
	gen ilo_job1_ins_sector=.
	if (`Y'>=2013){
		replace ilo_job1_ins_sector=1 if inlist(s4_18,1,2) & ilo_lfs==1
		replace ilo_job1_ins_sector=2 if inrange(s4_18,3,8) & ilo_lfs==1
        replace ilo_job1_ins_sector=2 if ilo_job1_ins_sector==. & ilo_lfs==1
	}
	if (`Y'<=2012){
		replace ilo_job1_ins_sector=1 if inlist(eft_categoria_ocup_princ,1,2) & ilo_lfs==1
		replace ilo_job1_ins_sector=2 if inrange(eft_categoria_ocup_princ,3,8) & ilo_lfs==1
        replace ilo_job1_ins_sector=2 if ilo_job1_ins_sector==. & ilo_lfs==1
	}	
                lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
			    lab values ilo_job1_ins_sector ins_sector_lab
			    lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Informal/Formal economy: ('ilo_job1_ife_prod' and 'ilo_job1_ife_nature') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment:
/* Useful questions:
		  * Institutional sector: eft_categoria_ocup_princ/s4_18 (based on occupation)
		  * Destination of production: not asked
		  * Bookkeeping: not asked
		  * Registration: eft_empresa_tiene_licencia/s4_21 (proxy -> actual question: does the establishment/business have a license/permit to operate?)
		  * Status in employment: ilo_job1_ste_icse93==1 (employees)
		  * Social security contribution (pension insurance): eft_afiliado_afp/s4_18g1 (AFP o plan de pension) (only asked to employees)
		  * Place of work: not asked
		  * Size: eft_cant_pers_trab/s4_20	(not used bc place of work is not asked)
		  * Private HH: Activities of Private HH: ilo_job1_eco_isic3_2digits (==95) (5.9% using weights)
		  * Paid annual leave: not asked
		  * Paid sick leave: not asked
*/
		
    * Social security (to be dropped afterwards)
	gen social_security=.
	if (`Y'>=2013){
	    replace social_security=1 if (s4_18g1==1 & ilo_lfs==1)          // Pension
		replace social_security=2 if (s4_18g1==2 & ilo_lfs==1)          // No pension
		replace social_security=. if (social_security==. & ilo_lfs==1)
    }
	if (`Y'<=2012){
	    replace social_security=1 if (eft_afiliado_afp==1 & ilo_lfs==1)                  // Pension
		replace social_security=2 if (eft_afiliado_afp==2 & ilo_lfs==1)                  // No pension
		replace social_security=. if (social_security==. & ilo_lfs==1)
	}
				
    * 1) UNIT OF PRODUCTION: FORMAL/INFORMAL SECTOR		
    gen ilo_job1_ife_prod=.
	if (`Y'>=2013){
		replace ilo_job1_ife_prod=1 if ilo_lfs==1 & ///
		                               ((inlist(s4_18,3,4,5,6,.) & inlist(s4_21,2,3)) | ///
									   (inlist(s4_18,3,4,5,6,.) & s4_21==. & ilo_job1_ste_icse93==1 & inlist(social_security,2,.)) | ///
									   (inlist(s4_18,3,4,5,6,.) & s4_21==. & ilo_job1_ste_icse93!=1))
		replace ilo_job1_ife_prod=2 if ilo_lfs==1 & ///
		                               ((inlist(s4_18,1,2)) | ///
									   (inlist(s4_18,3,4,5,6,.) & s4_21==1) | ///
									   (inlist(s4_18,3,4,5,6,.) & s4_21==. & ilo_job1_ste_icse93==1 & social_security==1))
		replace ilo_job1_ife_prod=3 if ilo_lfs==1 & !inlist(ilo_job1_ife_prod,1,2) & ///
				                       ((inlist(s4_18,7,8)) | ///
									   (ilo_job1_eco_isic3_2digits==95)) 
     }
	 if (`Y'<=2012){
		replace ilo_job1_ife_prod=1 if ilo_lfs==1 & ///
		                               ((inlist(eft_categoria_ocup_princ,3,4,5,6,.) & inlist(eft_empresa_tiene_licencia,2,3)) | ///
									   (inlist(eft_categoria_ocup_princ,3,4,5,6,.) & eft_empresa_tiene_licencia==. & ilo_job1_ste_icse93==1 & inlist(social_security,2,.)) | ///
									   (inlist(eft_categoria_ocup_princ,3,4,5,6,.) & eft_empresa_tiene_licencia==. & ilo_job1_ste_icse93!=1))
		replace ilo_job1_ife_prod=2 if ilo_lfs==1 & ///
		                               ((inlist(eft_categoria_ocup_princ,1,2)) | ///
									   (inlist(eft_categoria_ocup_princ,3,4,5,6,.) & eft_empresa_tiene_licencia==1) | ///
									   (inlist(eft_categoria_ocup_princ,3,4,5,6,.) & eft_empresa_tiene_licencia==. & ilo_job1_ste_icse93==1 & social_security==1))
		replace ilo_job1_ife_prod=3 if ilo_lfs==1 & !inlist(ilo_job1_ife_prod,1,2) & ///
				                       ((inlist(eft_categoria_ocup_princ,7,8)) | ///
									   (ilo_job1_eco_isic3_2digits==95)) 
	 }
				lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 
				lab val ilo_job1_ife_prod ilo_ife_prod_lab
				lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"		
						
						
	* 2) NATURE OF JOB: FORMAL/INFORMAL EMPLOYMENT
	gen ilo_job1_ife_nature=.
	    replace ilo_job1_ife_nature=1 if ilo_lfs==1 & ///
	                                     ((inlist(ilo_job1_ste_icse93,1,6) & inlist(social_security,2,.)) | ///
										 (inlist(ilo_job1_ste_icse93,2,4) & inlist(ilo_job1_ife_prod,1,3)) | ///
										 (ilo_job1_ste_icse93==3 & inlist(ilo_job1_ife_prod,1,3)) | ///
										 (ilo_job1_ste_icse93==5))
	    replace ilo_job1_ife_nature=2 if ilo_lfs==1 & ///
			                             ((inlist(ilo_job1_ste_icse93,1,6) & social_security==1) | ///
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
* Comment: - Only available hours usually worked in main, secondary and all jobs (not actually hours
*            worked).

	* MAIN JOB	
	gen ilo_job1_how_usual=.
	if (`Y'>=2013){	
	    replace ilo_job1_how_usual=s4_22 if ilo_lfs==1
	}
    if (`Y'<=2012){
	    replace ilo_job1_how_usual=eft_horas_sem_ocup_princ if ilo_lfs==1	
	}
			    lab var ilo_job1_how_usual "Weekly hours usually worked - main job"
				
    gen ilo_job1_how_usual_bands=.
	 	replace ilo_job1_how_usual_bands=1 if ilo_job1_how_usual==0
		replace ilo_job1_how_usual_bands=2 if inrange(ilo_job1_how_usual,1,14)
		replace ilo_job1_how_usual_bands=3 if inrange(ilo_job1_how_usual,15,29)
		replace ilo_job1_how_usual_bands=4 if inrange(ilo_job1_how_usual,30,34)
		replace ilo_job1_how_usual_bands=5 if inrange(ilo_job1_how_usual,35,39)
		replace ilo_job1_how_usual_bands=6 if inrange(ilo_job1_how_usual,40,48)
		replace ilo_job1_how_usual_bands=7 if ilo_job1_how_usual>=49 & ilo_job1_how_usual!=.
		replace ilo_job1_how_usual_bands=8 if ilo_job1_how_usual==. & ilo_lfs==1
		replace ilo_job1_how_usual_bands=. if ilo_lfs!=1
		    	lab def how_usu_bands_lab 1 "No hours usually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"
				lab val ilo_job1_how_usual_bands how_usu_bands_lab
				lab var ilo_job1_how_usual_bands "Weekly hours usually worked bands - main job"
				
			
	* SECOND JOB		
	gen ilo_job2_how_usual=.
	if (`Y'>=2013){	
	    replace ilo_job2_how_usual=s4_27 if ilo_mjh==2
	}
    if (`Y'<=2012){
	    replace ilo_job2_how_usual=eft_horas_sem_ocup_secun if ilo_mjh==2	
	}	
			    lab var ilo_job2_how_usual "Weekly hours usually worked - secondary job"
				
    gen ilo_job2_how_usual_bands=.
	 	replace ilo_job2_how_usual_bands=1 if ilo_job2_how_usual==0
		replace ilo_job2_how_usual_bands=2 if inrange(ilo_job2_how_usual,1,14)
		replace ilo_job2_how_usual_bands=3 if inrange(ilo_job2_how_usual,15,29)
		replace ilo_job2_how_usual_bands=4 if inrange(ilo_job2_how_usual,30,34)
		replace ilo_job2_how_usual_bands=5 if inrange(ilo_job2_how_usual,35,39)
		replace ilo_job2_how_usual_bands=6 if inrange(ilo_job2_how_usual,40,48)
		replace ilo_job2_how_usual_bands=7 if ilo_job2_how_usual>=49 & ilo_job2_how_usual!=.
		replace ilo_job2_how_usual_bands=8 if ilo_job2_how_usual==. & ilo_mjh==2
		replace ilo_job2_how_usual_bands=. if ilo_mjh!=2
		    	lab val ilo_job2_how_usual_bands how_usu_bands_lab
				lab var ilo_job2_how_usual_bands "Weekly hours usually worked bands - secondary job"				
			
	* ALL JOBS		
	egen ilo_joball_how_usual=rowtotal(ilo_job1_how_usual ilo_job2_how_usual), m
		replace ilo_joball_how_usual=. if ilo_lfs!=1
			    lab var ilo_joball_how_usual "Weekly hours usually worked - all jobs"
				
    gen ilo_joball_how_usual_bands=.
	 	replace ilo_joball_how_usual_bands=1 if ilo_joball_how_usual==0
		replace ilo_joball_how_usual_bands=2 if inrange(ilo_joball_how_usual,1,14)
		replace ilo_joball_how_usual_bands=3 if inrange(ilo_joball_how_usual,15,29)
		replace ilo_joball_how_usual_bands=4 if inrange(ilo_joball_how_usual,30,34)
		replace ilo_joball_how_usual_bands=5 if inrange(ilo_joball_how_usual,35,39)
		replace ilo_joball_how_usual_bands=6 if inrange(ilo_joball_how_usual,40,48)
		replace ilo_joball_how_usual_bands=7 if ilo_joball_how_usual>=49 & ilo_joball_how_usual!=.
		replace ilo_joball_how_usual_bands=8 if ilo_joball_how_usual==. & ilo_lfs==1
		replace ilo_joball_how_usual_bands=. if ilo_lfs!=1
		    	lab val ilo_joball_how_usual_bands how_usu_bands_lab
				lab var ilo_joball_how_usual_bands "Weekly hours usually worked bands - all job"				
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
* Comment: - Following the national definition, the threshold is set at 40, for those working
*            in the public sector, and 44 for those working in the private sector.
	
	gen ilo_job1_job_time=.
	if (`Y'>=2013){		
		replace ilo_job1_job_time=2 if ((ilo_job1_ins_sector==1 & ilo_job1_how_usual>=40) | (ilo_job1_ins_sector==2 & ilo_job1_how_usual>=44)) & ilo_lfs==1
		replace ilo_job1_job_time=1 if (ilo_job1_ins_sector==1 & ilo_job1_how_usual<40) | (ilo_job1_ins_sector==2 & ilo_job1_how_usual<44) & ilo_lfs==1
		replace ilo_job1_job_time=3 if ilo_job1_job_time==. & ilo_lfs==1
	}
	if (`Y'<=2012){
		replace ilo_job1_job_time=2 if ((ilo_job1_ins_sector==1 & ilo_job1_how_usual>=40) | (ilo_job1_ins_sector==2 & ilo_job1_how_usual>=44)) & ilo_lfs==1
		replace ilo_job1_job_time=1 if (ilo_job1_ins_sector==1 & ilo_job1_how_usual<40) | (ilo_job1_ins_sector==2 & ilo_job1_how_usual<44) & ilo_lfs==1
		replace ilo_job1_job_time=3 if ilo_job1_job_time==. & ilo_lfs==1
	}
			    lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
			    lab val ilo_job1_job_time job_time_lab
			    lab var ilo_job1_job_time "Job (Working time arrangement)"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job_contract') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
* Comment: - Only asked to employees.
	
	gen ilo_job1_job_contract=.
	if (`Y'>=2013){		
		replace ilo_job1_job_contract=1 if s4_18e==1 & ilo_job1_ste_aggregate==1
		replace ilo_job1_job_contract=2 if inlist(s4_18e,2,3) & ilo_job1_ste_aggregate==1
		replace ilo_job1_job_contract=3 if (s4_18e==4 | ilo_job1_job_contract==.) & ilo_job1_ste_aggregate==1
	}
	if (`Y'<=2012){
		replace ilo_job1_job_contract=1 if eft_tipo_contrato==1 & ilo_job1_ste_aggregate==1
		replace ilo_job1_job_contract=2 if inlist(eft_tipo_contrato,2,3) & ilo_job1_ste_aggregate==1
		replace ilo_job1_job_contract=3 if (eft_tipo_contrato==4 | ilo_job1_job_contract==.) & ilo_job1_ste_aggregate==1
	}	
				lab def job_contract_lab 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"
			    lab val ilo_job1_job_contract job_contract_lab
			    lab var ilo_job1_job_contract "Job (Type of contract)"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Earnings ('ilo_ear_ees' and 'ilo_ear_slf')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Earnings in main job for employees and self-employed.

	* MAIN JOB
	* To month
	gen monthly_earnings=.
	if (`Y'>=2013){	  
		  replace monthly_earnings=(s4_281*ilo_job1_how_usual*4) if s4_282==1
		  replace monthly_earnings=(s4_281*s4_28a*4) if s4_282==2
		  replace monthly_earnings=(s4_281*4) if s4_282==3
		  replace monthly_earnings=(s4_281*2) if s4_282==4
		  replace monthly_earnings=s4_281 if s4_282==5
	}
	if (`Y'<=2012){
		  replace monthly_earnings=(eft_ing_ocup_princ*ilo_job1_how_usual*4) if eft_periodo_ing_ocup_princ==1
		  replace monthly_earnings=(eft_ing_ocup_princ*eft_dias_sem_ocup_princ*4) if eft_periodo_ing_ocup_princ==2
		  replace monthly_earnings=(eft_ing_ocup_princ*4) if eft_periodo_ing_ocup_princ==3
		  replace monthly_earnings=(eft_ing_ocup_princ*2) if eft_periodo_ing_ocup_princ==4
		  replace monthly_earnings=eft_ing_ocup_princ if eft_periodo_ing_ocup_princ==5	
	}	

	 * Employees
	 gen ilo_job1_lri_ees=.
	     replace ilo_job1_lri_ees=monthly_earnings if ilo_job1_ste_aggregate==1
	             lab var ilo_job1_lri_ees "Monthly earnings of employees - main job"
				 
	 * Self-employed
	 gen ilo_job1_lri_slf = monthly_earnings if ilo_job1_ste_aggregate==2
	     lab var ilo_job1_lri_slf "Monthly labour related income of self-employed in main job"		 
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_tru') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Following the national definition, the threshold is set at 40, for those working
*            in the public sector, and 44 for those working in the private sector (note to value:
*            T4:1601). 
*          - Two criteria: worked less than a threshold and willing to work more hours (availability
*            to work more hours is not asked (note to value: T35:2416)).
			
	gen ilo_joball_tru=.
	if (`Y'>=2013){	
	    replace ilo_joball_tru=1 if ((ilo_job1_ins_sector==1 & ilo_joball_how_usual<40) | (ilo_job1_ins_sector==2 & ilo_joball_how_usual<44)) & s4_24==1 & ilo_lfs==1
	}
	if (`Y'<=2012){
	    replace ilo_joball_tru=1 if ((ilo_job1_ins_sector==1 & ilo_joball_how_usual<40) | (ilo_job1_ins_sector==2 & ilo_joball_how_usual<44)) & eft_desea_trab_mas_horas==1 & ilo_lfs==1	
	}	
		replace ilo_joball_tru=. if ilo_lfs!=1
		        lab def tru_lab 1 "Time-related underemployment"
		        lab val ilo_joball_tru tru_lab
		        lab var ilo_joball_tru "Time-related underemployment"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupational injury ('ilo_joball_inj') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
* Comment: Information not available.

*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Days lost due to cases of occupational injury ('ilo_joball_oi_day') [done]
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
* Comment: Information not available.

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
	if (`Y'>=2013){		
		replace ilo_cat_une=1 if s4_13==1 & ilo_lfs==2			                // Previously employed
		replace ilo_cat_une=2 if s4_13==2 & ilo_lfs==2			                // Seeking first job
		replace ilo_cat_une=3 if ilo_lfs==2 & !inlist(ilo_cat_une,1,2)	        // Unkown
	}
	if (`Y'<=2012){
		replace ilo_cat_une=1 if eft_trabajo_antes==1 & ilo_lfs==2			    // Previously employed
		replace ilo_cat_une=2 if eft_trabajo_antes==2 & ilo_lfs==2			    // Seeking first job
		replace ilo_cat_une=3 if ilo_lfs==2 & !inlist(ilo_cat_une,1,2)	        // Unkown
	}
			    lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
			    lab val ilo_cat_une cat_une_lab
			    lab var ilo_cat_une "Category of unemployment"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment:	- Category 5 (12 to 24 months) includes 24 months or more (note to value: C7:3716).

	* Detailed categories		
    gen ilo_dur_details=.
	if (`Y'>=2013){		
	    replace ilo_dur_details=1 if (s4_10==1 & ilo_lfs==2)                    // Less than 1 month
		replace ilo_dur_details=2 if (inrange(s4_10,2,3) & ilo_lfs==2)          // 1 to 3 months
		replace ilo_dur_details=3 if (s4_10==4 & ilo_lfs==2)                    // 3 to 6 months
		replace ilo_dur_details=4 if (s4_10==5 & ilo_lfs==2)                    // 6 to 12 months
		replace ilo_dur_details=5 if (s4_10==6 & ilo_lfs==2)                    // 12 to 24 months (including 24 months or more)
		*replace ilo_dur_details=6 if                                           // 24 months or more (96 weeks or more)
		replace ilo_dur_details=7 if (s4_10==. & ilo_lfs==2)                    // Not elsewhere classified
	}
	if (`Y'<=2012){
	    replace ilo_dur_details=1 if (eft_tiempo_busca_trab==1 & ilo_lfs==2)                    // Less than 1 month
		replace ilo_dur_details=2 if (inrange(eft_tiempo_busca_trab,2,3) & ilo_lfs==2)          // 1 to 3 months
		replace ilo_dur_details=3 if (eft_tiempo_busca_trab==4 & ilo_lfs==2)                    // 3 to 6 months
		replace ilo_dur_details=4 if (eft_tiempo_busca_trab==5 & ilo_lfs==2)                    // 6 to 12 months
		replace ilo_dur_details=5 if (eft_tiempo_busca_trab==6 & ilo_lfs==2)                    // 12 to 24 months (including 24 months or more)
		*replace ilo_dur_details=6 if                                                           // 24 months or more (96 weeks or more)
		replace ilo_dur_details=7 if (eft_tiempo_busca_trab==. & ilo_lfs==2)                    // Not elsewhere classified
	}	
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
* Comment: - Question 17 in section 4 asks about the current/previous economic activity (variable
*            previously created).

	* ISIC Rev. 3 - 2 digit
	gen ilo_preveco_isic3_2digits=.
		replace ilo_preveco_isic3_2digits = indu_code_prim if ilo_lfs==2 & ilo_cat_une==1
		        lab val ilo_preveco_isic3_2digits eco_isic3_2digits
		        lab var ilo_preveco_isic3_2digits "Previous economic activity (ISIC Rev. 3), 2 digit level"
	
    * ISIC Rev. 3 - 1 digit				  
    gen ilo_preveco_isic3=.
		replace ilo_preveco_isic3=1 if inrange(ilo_preveco_isic3_2digits,1,2)
		replace ilo_preveco_isic3=2 if ilo_preveco_isic3_2digits==5
		replace ilo_preveco_isic3=3 if inrange(ilo_preveco_isic3_2digits,10,14)
		replace ilo_preveco_isic3=4 if inrange(ilo_preveco_isic3_2digits,15,37)
		replace ilo_preveco_isic3=5 if inrange(ilo_preveco_isic3_2digits,40,41)
		replace ilo_preveco_isic3=6 if ilo_preveco_isic3_2digits==45
		replace ilo_preveco_isic3=7 if inrange(ilo_preveco_isic3_2digits,50,52)
		replace ilo_preveco_isic3=8 if ilo_preveco_isic3_2digits==55
		replace ilo_preveco_isic3=9 if inrange(ilo_preveco_isic3_2digits,60,64)
		replace ilo_preveco_isic3=10 if inrange(ilo_preveco_isic3_2digits,65,67)
		replace ilo_preveco_isic3=11 if inrange(ilo_preveco_isic3_2digits,70,74)
		replace ilo_preveco_isic3=12 if ilo_preveco_isic3_2digits==75
		replace ilo_preveco_isic3=13 if ilo_preveco_isic3_2digits==80
		replace ilo_preveco_isic3=14 if ilo_preveco_isic3_2digits==85
		replace ilo_preveco_isic3=15 if inrange(ilo_preveco_isic3_2digits,90,93)
		replace ilo_preveco_isic3=16 if ilo_preveco_isic3_2digits==95
		replace ilo_preveco_isic3=17 if ilo_preveco_isic3_2digits==99
		replace ilo_preveco_isic3=18 if inlist(ilo_preveco_isic3_2digits,0,.) & ilo_cat_une==1
			    lab val ilo_preveco_isic3 eco_isic3_1digit
			    lab var ilo_preveco_isic3 "Previous economic activity (ISIC Rev. 3)"
	
    * Aggregate level
	gen ilo_preveco_aggregate=.
		replace ilo_preveco_aggregate=1 if inlist(ilo_preveco_isic3,1,2)
		replace ilo_preveco_aggregate=2 if ilo_preveco_isic3==4
		replace ilo_preveco_aggregate=3 if ilo_preveco_isic3==6
		replace ilo_preveco_aggregate=4 if inlist(ilo_preveco_isic3,3,5)
		replace ilo_preveco_aggregate=5 if inrange(ilo_preveco_isic3,7,11)
		replace ilo_preveco_aggregate=6 if inrange(ilo_preveco_isic3,12,17)
		replace ilo_preveco_aggregate=7 if ilo_preveco_isic3==18
			    lab val ilo_preveco_aggregate eco_aggr_lab
			    lab var ilo_preveco_aggregate "Previous economic activity (Aggregate)"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu_isco88') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Question 16 in section 4 asks about the current/previous occupation (variable
*            previously created).


   * Two digit-level
   gen ilo_prevocu_isco88_2digits=occ_code_prim if ilo_lfs==2 & ilo_cat_une==1
	   lab values ilo_prevocu_isco88_2digits ocu88_2digits
	   lab var ilo_prevocu_isco88_2digits "Previous occupation (ISCO-88), 2 digit level"
			
    * One digit-level
	gen ilo_prevocu_isco88=.
	    replace ilo_prevocu_isco88=11 if ilo_prevocu_isco88_2digits==. & ilo_lfs==2 & ilo_cat_une==1                            //Not elsewhere classified
		replace ilo_prevocu_isco88=int(ilo_prevocu_isco88_2digits/10) if (ilo_prevocu_isco88==. & ilo_lfs==2 & ilo_cat_une==1)  //The rest of the occupations
		replace ilo_prevocu_isco88=10 if (ilo_prevocu_isco88==0 & ilo_lfs==2 & ilo_cat_une==1)                                  //Armed forces
				lab val ilo_prevocu_isco88 ocu88_1digit
				lab var ilo_prevocu_isco88 "Previous occupation (ISCO-88)"
				
	* Aggregate:			
	gen ilo_prevocu_aggregate=.
		replace ilo_prevocu_aggregate=1 if inrange(ilo_prevocu_isco88,1,3)
		replace ilo_prevocu_aggregate=2 if inlist(ilo_prevocu_isco88,4,5)
		replace ilo_prevocu_aggregate=3 if inlist(ilo_prevocu_isco88,6,7)
		replace ilo_prevocu_aggregate=4 if ilo_prevocu_isco88==8
		replace ilo_prevocu_aggregate=5 if ilo_prevocu_isco88==9
		replace ilo_prevocu_aggregate=6 if ilo_prevocu_isco88==10
		replace ilo_prevocu_aggregate=7 if ilo_prevocu_isco88==11
				lab val ilo_prevocu_aggregate ocu_aggr_lab
				lab var ilo_prevocu_aggregate "Previous occupation (Aggregate)"				
				
    * Skill level				
    gen ilo_prevocu_skill=.
	    replace ilo_prevocu_skill=1 if ilo_prevocu_isco88==9                   // Low
		replace ilo_prevocu_skill=2 if inlist(ilo_prevocu_isco88,4,5,6,7,8)    // Medium
		replace ilo_prevocu_skill=3 if inlist(ilo_prevocu_isco88,1,2,3)        // High
		replace ilo_prevocu_skill=4 if inlist(ilo_prevocu_isco88,10,11)        // Not elsewhere classified
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
* Comment: - Due to the skip pattern after the question on seeking job/start a business, 
*            category 1 does not have observations and therefore the variable is not produced.
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reasons for not seeking a job ('ilo_olf_reason') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment:
	
	gen ilo_olf_reason=.
	if (`Y'>=2013){	
		replace ilo_olf_reason=1 if inlist(s4_11,1,8,10,11) & ilo_lfs==3        // Labour market
		replace ilo_olf_reason=2 if inlist(s4_11,3,12) & ilo_lfs==3             // Other labour market reasons
		replace ilo_olf_reason=3 if inlist(s4_11,2,4,5,6,7,9) & ilo_lfs==3      // Personal/Family-related
		replace ilo_olf_reason=4 if inlist(s4_11,13,14) & ilo_lfs==3            // Does not need/want to work
		replace ilo_olf_reason=5 if ilo_olf_reason==. & ilo_lfs==3              // Not elsewhere classified
	}
	if (`Y'<=2012){
		replace ilo_olf_reason=1 if inlist(eft_motivo_no_busca_trab,1,8,10,11) & ilo_lfs==3        // Labour market
		replace ilo_olf_reason=2 if inlist(eft_motivo_no_busca_trab,3,12) & ilo_lfs==3             // Other labour market reasons
		replace ilo_olf_reason=3 if inlist(eft_motivo_no_busca_trab,2,4,5,6,7,9) & ilo_lfs==3      // Personal/Family-related
		replace ilo_olf_reason=4 if inlist(eft_motivo_no_busca_trab,13,14) & ilo_lfs==3            // Does not need/want to work
		replace ilo_olf_reason=5 if ilo_olf_reason==. & ilo_lfs==3                                 // Not elsewhere classified
	}
 			    lab def lab_olf_reason 1 "1 - Labour market" 2 "Other labour market reasons" 3 "2 - Personal/Family-related"  ///
				                       4 "3 - Does not need/want to work" 5 "4 - Not elsewhere classified"
		        lab val ilo_olf_reason lab_olf_reason
			    lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seekers ('ilo_dis') [done]
* -------------------------------------------------------------------------------------------
* ------------------------------------------------------------------------------------------- 
* Comment: 	- From 2013Q2 question 12b is not available on the dataset.

	gen ilo_dis=.
	if (`Y'>=2013){
	    replace ilo_dis=1 if !inlist(ilo_lfs,1,2) & (s4_12==1 | s4_12a==1) & (ilo_olf_reason==1)
	}
	if (`Y'<=2012){
        replace ilo_dis=1 if !inlist(ilo_lfs,1,2) & (eft_aceptaria_trab_sem_ant==1 | eft_tiene_cond_jornada==1 | eft_tuvo_cond_jornada==1) & (ilo_olf_reason==1) 	
	}		
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
		drop indu_code_prim occ_code_prim social_security monthly_earnings 
		
		compress 
		
	   /*Save dataset including original and ilo variables*/
		save ${country}_${source}_${time}_FULL,  replace		
	
	   /* Save file only containing ilo_* variables*/
		keep ilo*

		save ${country}_${source}_${time}_ILO, replace
		


