* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Indonesia, 2010
* DATASET USED: Indonesia, LFS, 2010
* NOTES: 
* Files created: Standard variables IDN_LFS_TIME_FULL.dta and IDN_LFS_TIME_ILO.dta
* Authors: ILO / Department of Statistics / DPAU
* Starting Date: 29 July 2016
* Last updated: 07 March 2018
********************************************************************************

********************************************************************************
********************************************************************************
*                                                                              *
*          1.	Set up work directory, file name, variables and function       *
*                                                                              *
********************************************************************************
********************************************************************************

clear all 

set more off

global path "J:\DPAU\MICRO"
global country "IDN"
global source "LFS"
global time "2010Q3"
global inputFile "SAK0810.dta"
global inpath "${path}\\${country}\\${source}\\${time}\ORI"
global temppath "${path}\_Admin"
global outpath "${path}\\${country}\\${source}\\${time}"

********************************************************************************
********************************************************************************

cd "$inpath"
	use ${inputFile}, clear
	*renaming everything in lower case
	rename *, lower
	
*-------------------------------------------------------------------------------
* Auxiliar variables	
	
capture confirm var kbli2009* 
  if !_rc {
  rename kbli2009* kbli2009
}

gen time = "${time}"
split time, gen(time_) parse(Q)
capture confirm variable time_2 
if !_rc {
  rename (time_1 time_2) (year quarter)
  destring year quarter, replace
}
else {
  rename time_1 year
}
		
********************************************************************************
********************************************************************************
*                                                                              *
*			                      2. MAP VARIABLES                             *
*                                                                              *
********************************************************************************
********************************************************************************

* ------------------------------------------------------------------------------
********************************************************************************
*                                                                              *
*			              PART 1. DATASET SETTINGS VARIABLES                   *
*                                                                              *
********************************************************************************
* ------------------------------------------------------------------------------

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			               Identifier ('ilo_key') [done]                       *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment:

	gen ilo_key=_n
		lab var ilo_key "Key unique identifier per individual"	
		
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*		             	 Sample Weight ('ilo_wgt') 		                       *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 

	gen ilo_wgt=.
	    replace ilo_wgt=weight 
		        lab var ilo_wgt "Sample weight"
				
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			                Time period ('ilo_time') [done]                    *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment:

	gen ilo_time=1
		lab def time_lab 1 "$time"
		lab val ilo_time time_lab
		lab var ilo_time "Time (Gregorian Calendar)"
		
* ------------------------------------------------------------------------------
********************************************************************************
*                                                                              *
*			                PART 2. SOCIAL CHARACTERISTICS                     *
*                                                                              * 
********************************************************************************
* ------------------------------------------------------------------------------

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*		            	Geographical coverage ('ilo_geo') 		               *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 
	
	gen ilo_geo=.
	    replace ilo_geo=1 if b1p05==1         // Urban 
		replace ilo_geo=2 if b1p05==2         // Rural
		        lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural"
		        lab val ilo_geo ilo_geo_lab
		        lab var ilo_geo "Geographical coverage"	

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			                     Sex ('ilo_sex') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 
	
	gen ilo_sex=.
	    replace ilo_sex=1 if jk==1            // Male
		replace ilo_sex=2 if jk==2            // Female
		        label define label_Sex 1 "1 - Male" 2 "2 - Female"
		        label values ilo_sex label_Sex
		        lab var ilo_sex "Sex"
				
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			                    Age ('ilo_age') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 
	
	gen ilo_age=.
	    replace ilo_age=umur 
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
		replace ilo_age_aggregate=1 if inrange(ilo_age,0,14)
		replace ilo_age_aggregate=2 if inrange(ilo_age,15,24)
		replace ilo_age_aggregate=3 if inrange(ilo_age,25,54)
		replace ilo_age_aggregate=4 if inrange(ilo_age,55,64)
		replace ilo_age_aggregate=5 if ilo_age>=65 & ilo_age!=.
			lab def age_aggr_lab 1 "<15" 2 "15-24" 3 "25-54" 4 "55-64" 5 "65+"
			lab val ilo_age_aggregate age_aggr_lab
			lab var ilo_age_aggregate "Age (Aggregate)"				

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			           Level of education ('ilo_edu') 		                   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: - Highest level of education completed.
*          - Mapping is based on:
*            http://uis.unesco.org/en/isced-mappings

    *---------------------------------------------------------------------------
	* ISCED 97
	*---------------------------------------------------------------------------
	
	* Detailed
	gen ilo_edu_isced97=.
		replace ilo_edu_isced97=1 if b5p1a==1                       // No schooling
		replace ilo_edu_isced97=2 if b5p1a==2                       // Pre-primary education
		replace ilo_edu_isced97=3 if b5p1a==3                       // Primary education or first stage of basic education
		replace ilo_edu_isced97=4 if inlist(b5p1a,4,5)              // Lower secondary education or second stage of basic education
		replace ilo_edu_isced97=5 if inlist(b5p1a,6,7)              // Upper secondary education
		* replace ilo_edu_isced97=6 if                              // Post-secondary non-tertiary education
		replace ilo_edu_isced97=7 if inlist(b5p1a,8,9,10)           // First stage of tertiary education (not leading directly to an advanced research qualification)
		replace ilo_edu_isced97=8 if b5p1a==11                      // Second stage of tertiary education (leading to an advanced research qualification)                               
		replace ilo_edu_isced97=9 if ilo_edu_isced97==.             // Level not stated 
			    label def isced_97_lab 1 "X - No schooling" 2 "0 - Pre-primary education" 3 "1 - Primary education or first stage of basic education" 4 "2 - Lower secondary education or second stage of basic education" ///
							           5 "3 - Upper secondary education" 6 "4 - Post-secondary non-tertiary education" 7 "5 - First stage of tertiary education (not leading directly to an advanced research qualification)" ///
							           8 "6 - Second stage of tertiary education (leading to an advanced research qualification)" 9 "UNK - Level not stated"
			    label val ilo_edu_isced97 isced_97_lab
		        lab var ilo_edu_isced97 "Level of education (ISCED 97)"

	* Aggregate
	gen ilo_edu_aggregate=.
		replace ilo_edu_aggregate=1 if inlist(ilo_edu_isced97,1,2)
		replace ilo_edu_aggregate=2 if inlist(ilo_edu_isced97,3,4)
		replace ilo_edu_aggregate=3 if inlist(ilo_edu_isced97,5,6)
		replace ilo_edu_aggregate=4 if inlist(ilo_edu_isced97,7,8)
		replace ilo_edu_aggregate=5 if ilo_edu_isced97==9
			    label def edu_aggr_lab 1 "1 - Less than basic" 2 "2 - Basic" 3 "3 - Intermediate" 4 "4 - Advanced" 5 "5 - Level not stated"
			    label val ilo_edu_aggregate edu_aggr_lab
			    label var ilo_edu_aggregate "Level of education (Aggregate levels)"
	
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*		  	 Educational attendance ('ilo_edu_attendance') [done]              *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: - Category attending includes people going to non-formal schools.
			
    gen ilo_edu_attendance=.
		replace ilo_edu_attendance=1 if sek==2                                  // Attending
		replace ilo_edu_attendance=2 if inlist(sek,1,3)                         // Not attending
		replace ilo_edu_attendance=3 if ilo_edu_attendance==.                   // Not elsewhere classified
			    lab def edu_attendance_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
			    lab val ilo_edu_attendance edu_attendance_lab
			    lab var ilo_edu_attendance "Education (Attendance)"

				
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			           Marital status ('ilo_mrts') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: - no info on union/cohabiting
 
	
	* Detailed
	gen ilo_mrts_details=.
	    replace ilo_mrts_details=1 if statk==1                                  // Single
		replace ilo_mrts_details=2 if statk==2                                  // Married
		*replace ilo_mrts_details=3 if                                          // Union / cohabiting
		replace ilo_mrts_details=4 if statk==4                                  // Widowed
		replace ilo_mrts_details=5 if statk==3                                  // Divorced / separated
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
					
 						
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			Disability status ('ilo_dsb_details')                              *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: - No information available.

* ------------------------------------------------------------------------------
********************************************************************************
*                                                                              *
*			                PART 3. ECONOMIC SITUATION                         *
*                                                                              * 
********************************************************************************
* ------------------------------------------------------------------------------
	
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			      Working age population ('ilo_wap')	                       *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 	

	gen ilo_wap=.
		replace ilo_wap=1 if ilo_age>=15 & ilo_age!=.
			    label var ilo_wap "Working age population" 

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			       Labour Force Status ('ilo_lfs') [done]                      *       
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------				
* Comment: - Employment comprises people who answered yes to the question regarding
*            the activity in which s/he was engaged in the reference week was work,
*            those who worked for at least 1 hour in the past week and those who
*            have a job/business but were temporarily absent during the reference
*            period.
*          - Unemployment: the national definition of the unemployment stated in
*            the LFS report differs from the ILO definition due to the inclusion of
*            discouraged job-seekers and does not consider the availabily to work.
*            Following the questionnaire skip pattern, those answering yes to job/
*            business seeking are not asked for the availability, and therefore the
*            definition here used is two criteria. (T5:1429)

	
	gen ilo_lfs=.
	    if time=="2009Q1" | year<2009 {
		   replace ilo_lfs=1 if (b5p2a1==1) & ilo_wap==1	                               // Employed: engaged in work during the reference period
		   replace ilo_lfs=1 if (b5p3==1) & ilo_wap==1                                     // Employed: temporary absent
		   replace ilo_lfs=2 if (ilo_lfs!=1 & b5p24!=2 & (b5p4==1 | b5p5==1)) & ilo_wap==1 // Unemployed: two criteria: not in employment and seeking
		   replace ilo_lfs=2 if (ilo_lfs!=1 & b5p24!=2 & b5p23==2) & ilo_wap==1            // Unemployed: future starters
	       replace ilo_lfs=3 if !inlist(ilo_lfs,1,2) & ilo_wap==1                          // Outside the labour force
		}
	    else {
		   replace ilo_lfs=1 if (b5p2a1==1) & ilo_wap==1	                               // Employed: engaged in work during the reference period
		   replace ilo_lfs=1 if (b5p3==1) & ilo_wap==1                                     // Employed: temporary absent
		   replace ilo_lfs=2 if (ilo_lfs!=1 & b5p23!=2 & (b5p4==1 | b5p5==1)) & ilo_wap==1 // Unemployed: two criteria: not in employment and seeking
		   replace ilo_lfs=2 if (ilo_lfs!=1 & b5p23!=2 & b5p22==2) & ilo_wap==1            // Unemployed: future starters
	       replace ilo_lfs=3 if !inlist(ilo_lfs,1,2) & ilo_wap==1                          // Outside the labour force
		}
				   label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside the Labour Force"
				   label value ilo_lfs label_ilo_lfs
				   label var ilo_lfs "Labour Force Status"
				
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			       Multiple job holders ('ilo_mjh') [done]                     *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 

    gen ilo_mjh=.
	    if time=="2009Q1" | year<2009 {
		   replace ilo_mjh=1 if b5p17==2 & ilo_lfs==1                           // One job only
		   replace ilo_mjh=2 if b5p17==1 & ilo_lfs==1                           // More than one job
		}
		else {
		   replace ilo_mjh=1 if b5p16==2 & ilo_lfs==1                           // One job only
		   replace ilo_mjh=2 if b5p16==1 & ilo_lfs==1                           // More than one job
		}
			       lab def lab_ilo_mjh 1 "1 - One job only" 2 "2 - More than one job"
			       lab val ilo_mjh lab_ilo_mjh
			       lab var ilo_mjh "Multiple job holders"		

* ------------------------------------------------------------------------------
********************************************************************************
*                                                                              *
*	          PART 3.1 ECONOMIC CHARACTERISTICS FOR MAIN JOB                   *
*                                                                              * 
********************************************************************************
* ------------------------------------------------------------------------------			

* ------------------------------------------------------------------------------
*			       Status in employment ('ilo_ste') [done]                     * 
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------				
* Comment: - Self-employed assisted by temporary workers/unpaid worker are
*            classified under own-account workers.
*          - Casual employees in agriculture/non-agriculture are classified under employees.

   * MAIN JOB:
   * ICSE 1993
   gen empstatus=.
       if time=="2008Q1" {
	      replace empstatus = b5p12a
	   }
	   else {
	      replace empstatus = b5p10a
	   }
   
	 gen ilo_job1_ste_icse93=.
		 replace ilo_job1_ste_icse93=1 if inlist(empstatus,4,5,6) & ilo_lfs==1  // Employees
		 replace ilo_job1_ste_icse93=2 if empstatus==3 & ilo_lfs==1             // Employers
		 replace ilo_job1_ste_icse93=3 if inlist(empstatus,1,2) & ilo_lfs==1    // Own-account workers
		 * replace ilo_job1_ste_icse93=4 if  & ilo_lfs==1                       // Members of producers' cooperatives
		 replace ilo_job1_ste_icse93=5 if empstatus==7 & ilo_lfs==1             // Contributing family workers
		 replace ilo_job1_ste_icse93=6 if ilo_job1_ste_icse93==. & ilo_lfs==1   // Workers not classifiable by status
		 replace ilo_job1_ste_icse93=. if ilo_lfs!=1
				 label def label_ilo_ste_icse93 1 "1 - Employees" 2 "2 - Employers" 3 "3 - Own-account workers" ///
				                                4 "4 - Members of producers' cooperatives" 5 "5 - Contributing family workers" ///
												6 "6 - Workers not classifiable by status"
				 label val ilo_job1_ste_icse93 label_ilo_ste_icse93
				 label var ilo_job1_ste_icse93 "Status in employment (ICSE 93) - main job"

	* Aggregate categories 
	  gen ilo_job1_ste_aggregate=.
		  replace ilo_job1_ste_aggregate=1 if ilo_job1_ste_icse93==1                 // Employees
		  replace ilo_job1_ste_aggregate=2 if inlist(ilo_job1_ste_icse93,2,3,4,5)    // Self-employed
		  replace ilo_job1_ste_aggregate=3 if inlist(ilo_job1_ste_icse93,6)          // Not elsewhere classified
				  lab def ste_aggr_lab 1 "1 - Employees" 2 "2 - Self-employed" 3 "3 - Not elsewhere classified"
				  lab val ilo_job1_ste_aggregate ste_aggr_lab
				  label var ilo_job1_ste_aggregate "Status in employment (Aggregate) - main job"

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			            Economic activity ('ilo_eco')  [done]                  *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: - National classification mostly follow ISIC Rev. 3.1. 2-digit Indonesian
*            classification of industries 53 and 54 are exports/imports of goods,
*            except of motor vehicles and motorcycles and therefore are classified
*            under code 51 of ISIC 3.1.

    ***********
    * MAIN JOB:
    ***********
	
    *---------------------------------------------------------------------------
	* ISIC REV 3.1
	*---------------------------------------------------------------------------
		
	gen indu_code_prim=.
        replace indu_code_prim=int(b5p7/1000) if b5p7!=99999

	
	* 2-digit level
	gen ilo_job1_eco_isic3_2digits = .
	    replace ilo_job1_eco_isic3_2digits = indu_code_prim  if ilo_lfs==1
		replace ilo_job1_eco_isic3_2digits = 51 if inlist(indu_code_prim,53,54) & ilo_lfs==1
	    replace ilo_job1_eco_isic3_2digits = . if ilo_lfs!=1
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

	* 1-digit level	
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
		replace ilo_job1_eco_isic3=18 if ilo_job1_eco_isic3==. & ilo_lfs==1
		        lab def eco_isic3_1digit 1 "A - Agriculture, hunting and forestry"	2 "B - Fishing"	3 "C - Mining and quarrying"	4 "D - Manufacturing"	///
                                         5 "E - Electricity, gas and water supply"	6 "F - Construction"	7 "G - Wholesale and retail trade; repair of motor vehicles, motorcycles and personal and household goods"	8 "H - Hotels and restaurants"	///
                                         9 "I - Transport, storage and communications"	10 "J - Financial intermediation"	11 "K - Real estate, renting and business activities"	12 "L - Public administration and defence; compulsory social security"	///
                                         13 "M - Education"	14 "N - Health and social work"	15 "O - Other community, social and personal service activities"	16 "P - Activities of private households as employers and undifferentiated production activities of private households"	///
                                         17 "Q - Extraterritorial organizations and bodies"	18 "X - Not elsewhere classified"			
			    lab val ilo_job1_eco_isic3 eco_isic3_1digit
			    lab var ilo_job1_eco_isic3 "Economic activity (ISIC Rev. 3.1) - main job"
	
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

			
    *************
    * SECOND JOB:
    *************
	
    *---------------------------------------------------------------------------
	* ISIC REV 3.1
	*---------------------------------------------------------------------------
    
	gen indu_code_sec=.
    	if time=="2009Q1" | year<2009 {
		   replace indu_code_sec = int(b5p18/1000) if b5p18!=99999
	    }	
		else {
		   replace indu_code_sec = int(b5p17/1000) if b5p17!=99999
		}
	
	* 2-digit level
	gen ilo_job2_eco_isic3_2digits = .
	    replace ilo_job2_eco_isic3_2digits =  indu_code_sec if ilo_mjh==2
		replace ilo_job2_eco_isic3_2digits = 51 if inlist(indu_code_sec,53,54) & ilo_mjh==2
	    replace ilo_job2_eco_isic3_2digits = . if ilo_mjh!=2
                * labels already defined for main job
		        lab val ilo_job2_eco_isic3_2digits eco_isic3_2digits
                lab var ilo_job2_eco_isic3_2digits "Economic activity (ISIC Rev. 3.1), 2 digits level - second job"

	* 1-digit level	
    gen ilo_job2_eco_isic3=.
		replace ilo_job2_eco_isic3=1 if inrange(ilo_job2_eco_isic3_2digits,1,2)
		replace ilo_job2_eco_isic3=2 if ilo_job2_eco_isic3_2digits==5
		replace ilo_job2_eco_isic3=3 if inrange(ilo_job2_eco_isic3_2digits,10,14)
		replace ilo_job2_eco_isic3=4 if inrange(ilo_job2_eco_isic3_2digits,15,37)
		replace ilo_job2_eco_isic3=5 if inrange(ilo_job2_eco_isic3_2digits,40,41)
		replace ilo_job2_eco_isic3=6 if ilo_job2_eco_isic3_2digits==45
		replace ilo_job2_eco_isic3=7 if inrange(ilo_job2_eco_isic3_2digits,50,52)
		replace ilo_job2_eco_isic3=8 if ilo_job2_eco_isic3_2digits==55
		replace ilo_job2_eco_isic3=9 if inrange(ilo_job2_eco_isic3_2digits,60,64)
		replace ilo_job2_eco_isic3=10 if inrange(ilo_job2_eco_isic3_2digits,65,67)
		replace ilo_job2_eco_isic3=11 if inrange(ilo_job2_eco_isic3_2digits,70,74)
		replace ilo_job2_eco_isic3=12 if ilo_job2_eco_isic3_2digits==75
		replace ilo_job2_eco_isic3=13 if ilo_job2_eco_isic3_2digits==80
		replace ilo_job2_eco_isic3=14 if ilo_job2_eco_isic3_2digits==85
		replace ilo_job2_eco_isic3=15 if inrange(ilo_job2_eco_isic3_2digits,90,93)
		replace ilo_job2_eco_isic3=16 if ilo_job2_eco_isic3_2digits==95
		replace ilo_job2_eco_isic3=17 if ilo_job2_eco_isic3_2digits==99
		replace ilo_job2_eco_isic3=18 if ilo_job2_eco_isic3==. & ilo_mjh==2
                * labels already defined for main job
		        lab val ilo_job2_eco_isic3 eco_isic3_1digit
			    lab var ilo_job2_eco_isic3 "Economic activity (ISIC Rev. 3.1) - second job"
	
	* Aggregate level
	gen ilo_job2_eco_aggregate=.
		replace ilo_job2_eco_aggregate=1 if inlist(ilo_job2_eco_isic3,1,2)
		replace ilo_job2_eco_aggregate=2 if ilo_job2_eco_isic3==4
		replace ilo_job2_eco_aggregate=3 if ilo_job2_eco_isic3==6
		replace ilo_job2_eco_aggregate=4 if inlist(ilo_job2_eco_isic3,3,5)
		replace ilo_job2_eco_aggregate=5 if inrange(ilo_job2_eco_isic3,7,11)
		replace ilo_job2_eco_aggregate=6 if inrange(ilo_job2_eco_isic3,12,17)
		replace ilo_job2_eco_aggregate=7 if ilo_job2_eco_isic3==18
                * labels already defined for main job
			    lab val ilo_job2_eco_aggregate eco_aggr_lab
			    lab var ilo_job2_eco_aggregate "Economic activity (Aggregate) - second job"
	
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			               Occupation ('ilo_ocu') [done]                       *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: - 2007: National classification: Indonesian Standard Occupational (KBJI)
*            2002. Possibility to map it to ISCO-88 at 2-digit level.
*            Differences with ISCO-88: 23 in ISCO-88 correspond to 24 in KBJI, 24
*            in ISCO-88 correspond to 23, 25, 26 and 29 in KBJI and 34 in ISCO-88
*            correspond to 34, 35 and 39 in KBJI.
*          - No information available for secondary job.

    ***********
    * MAIN JOB:
    ***********
	
	gen occ_code_prim=.
	    replace occ_code_prim=int(b5p8/100)
		   
    *---------------------------------------------------------------------------
	* ISCO 88
	*---------------------------------------------------------------------------

	* 2-digit level 
    gen ilo_job1_ocu_isco88_2digits = . 
	    replace ilo_job1_ocu_isco88_2digits = occ_code_prim if ilo_lfs==1
		replace ilo_job1_ocu_isco88_2digits = 23 if occ_code_prim==24 & ilo_lfs==1
		replace ilo_job1_ocu_isco88_2digits = 24 if inlist(occ_code_prim,23,25,26,29) & ilo_lfs==1
		replace ilo_job1_ocu_isco88_2digits = 34 if inlist(occ_code_prim,34,35,39) & ilo_lfs==1
		replace ilo_job1_ocu_isco88_2digits = .   if ilo_lfs!=1
		        lab def ocu_isco88_2digits 1 "01 - Armed forces"	11 "11 - Legislators and senior officials"	12 "12 - Corporate managers"	13 "13 - General managers"	///
                                           21 "21 - Physical, mathematical and engineering science professionals"	22 "22 - Life science and health professionals"	23 "23 - Teaching professionals"	24 "24 - Other professionals"	///
                                           31 "31 - Physical and engineering science associate professionals"	32 "32 - Life science and health associate professionals"	33 "33 - Teaching associate professionals"	34 "34 - Other associate professionals"	///
                                           41 "41 - Office clerks"	42 "42 - Customer services clerks"	51 "51 - Personal and protective services workers"	52 "52 - Models, salespersons and demonstrators"	///
                                           61 "61 - Skilled agricultural and fishery workers"	62 "62 - Subsistence agricultural and fishery workers"	71 "71 - Extraction and building trades workers"	72 "72 - Metal, machinery and related trades workers"	///
                                           73 "73 - Precision, handicraft, craft printing and related trades workers"	74 "74 - Other craft and related trades workers"	81 "81 - Stationary plant and related operators"	82 "82 - Machine operators and assemblers"	///
                                           83 "83 - Drivers and mobile plant operators"	91 "91 - Sales and services elementary occupations"	92 "92 - Agricultural, fishery and related labourers"	93 "93 - Labourers in mining, construction, manufacturing and transport"	
	            lab values ilo_job1_ocu_isco88_2digits ocu_isco88_2digits
	            lab var ilo_job1_ocu_isco88_2digits "Occupation (ISCO-88), 2 digit level - main job"
			
    * 1-digit level
	gen ilo_job1_ocu_isco88=.
	    replace ilo_job1_ocu_isco88=11 if ilo_job1_ocu_isco88_2digits==. & ilo_lfs==1                                // Not elsewhere classified
		replace ilo_job1_ocu_isco88=int(ilo_job1_ocu_isco88_2digits/10) if (ilo_job1_ocu_isco88==. & ilo_lfs==1)     // The rest of the occupations
		replace ilo_job1_ocu_isco88=10 if (ilo_job1_ocu_isco88==0 & ilo_lfs==1)                                      // Armed forces
		        lab def ocu_isco88_1digit 1 "1 - Legislators, senior officials and managers"	2 "2 - Professionals"	3 "3 - Technicians and associate professionals"	4 "4 - Clerks"	///
                                          5 "5 - Service workers and shop and market sales workers"	6 "6 - Skilled agricultural and fishery workers"	7 "7 - Craft and related trades workers"	8 "8 - Plant and machine operators and assemblers"	///
                                          9 "9 - Elementary occupations"	10 "0 - Armed forces"	11 "11 - Not elsewhere classified"		
				lab val ilo_job1_ocu_isco88 ocu_isco88_1digit
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
	    replace ilo_job1_ocu_skill=1 if ilo_job1_ocu_isco88==9                  // Low
		replace ilo_job1_ocu_skill=2 if inlist(ilo_job1_ocu_isco88,4,5,6,7,8)   // Medium
		replace ilo_job1_ocu_skill=3 if inlist(ilo_job1_ocu_isco88,1,2,3)       // High
		replace ilo_job1_ocu_skill=4 if inlist(ilo_job1_ocu_isco88,10,11)       // Not elsewhere classified
				lab def ocu_skill_lab 1 "1 - Skill level 1 (low)" 2 "2 - Skill level 2 (medium)" 3 "3 - Skill levels 3 and 4 (high)" 4 "4 - Not elsewhere classified"
			    lab val ilo_job1_ocu_skill ocu_skill_lab
			    lab var ilo_job1_ocu_skill "Occupation (Skill level) - main job"		
 

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*	Institutional sector of economic activities ('ilo_ins_sector')		       *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: - No information available.
	
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*		               Hours of work ('ilo_how')  	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: - No information available of the usual hours of work in main/all jobs.
*          - No information available for secondary job.
				
    ***********
    * MAIN JOB:
    ***********

	* Hours ACTUALLY worked
	gen ilo_job1_how_actual = .
	    replace ilo_job1_how_actual = b5p9  if ilo_lfs==1
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
		   	    lab def how_bands_act 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"		
				lab val ilo_job1_how_actual_bands how_bands_act
				lab var ilo_job1_how_actual_bands "Weekly hours actually worked bands - main job"
				
    ***********
    * ALL JOBS:
    ***********
				
	* Hours ACTUALLY worked
	gen ilo_joball_how_actual = .
	    replace ilo_joball_how_actual = b5p6b if ilo_lfs==1
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
		        * labels already defined for main job
			 	lab val ilo_joball_how_actual_bands how_bands_act
				lab var ilo_joball_how_actual_bands "Weekly hours actually worked bands - all jobs"			
		
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job_time')		                   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: - 35 hours per week actually worked in main jobs is set as a threshold
*            (normal working time in the country). 
			
	gen ilo_job1_job_time=.
		replace ilo_job1_job_time=2 if ilo_job1_how_actual>=35 & ilo_job1_how_actual>0 & ilo_lfs==1                           // Full-time
		replace ilo_job1_job_time=1 if ilo_job1_how_actual<35 & ilo_job1_how_actual!=. & ilo_lfs==1    // Part-time
		replace ilo_job1_job_time=3 if ilo_job1_job_time==. & ilo_lfs==1
			    lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
			    lab val ilo_job1_job_time job_time_lab
			    lab var ilo_job1_job_time "Job (Working time arrangement)"				
		
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*		    	Type of contract ('ilo_job_contract') 		                   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: - No information available.

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*  Informal/formal economy: ('ilo_job1_ife_prod'/'ilo_job1_ife_nature') 	   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: - No information available of the variables needed. Not computed due
*            to the lack of minimum information.
/* Useful questions:
          - Institutional sector: not asked
		  - Private household identification: 
		  - Destination of production: not asked
		  - Bookkeeping: not asked
		  - Registration: not asked
		  - Status in employment: 
		  - Social security contribution (Proxy: pension funds): not asked
		  - Place of work: not asked
		  - Size: not asked
		  - Paid annual leave: not asked
		  - Paid sick leave: not asked
*/
		

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*	    Monthly related income ('ilo_ear_ees' and 'ilo_ear_slf')  		       *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------			
* Comment: - Earnings in cash and/or in kind.
*          - Local currency: Indonesian Rupiah.

    ***********
    * MAIN JOB:
    ***********
	if time=="2008Q1" {
	   egen earn_cash_kind = rowtotal(b5p14a b5p14b), m
	}
	else {
       egen earn_cash_kind = rowtotal(b5p12a b5p12b), m
	}
	
	* Employees
	gen ilo_job1_lri_ees = .
	    replace ilo_job1_lri_ees = earn_cash_kind if ilo_job1_ste_aggregate==1
	    replace ilo_job1_lri_ees = . if ilo_lfs!=1
		replace ilo_job1_lri_ees = . if ilo_job1_lri_ees<0
		        lab var ilo_job1_lri_ees "Monthly earnings of employees - main job"
				
	* Self-employed
	gen ilo_job1_lri_slf = .
	    replace ilo_job1_lri_slf = earn_cash_kind if ilo_job1_ste_aggregate==2
	    replace ilo_job1_lri_slf = . if ilo_lfs!=1
		        lab var ilo_job1_lri_slf "Monthly earnings of self-employed - main job"

* ------------------------------------------------------------------------------
********************************************************************************
*                                                                              *
*	          PART 3.2 ECONOMIC CHARACTERISTICS FOR ALL JOBS                   *
*                                                                              * 
********************************************************************************
* ------------------------------------------------------------------------------				

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_tru') 		                       *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: - No information available.	
	
	
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
*	Cases of non-fatal occupational injury ('ilo_joball_oi_case') 		       *
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
* Comment: - No information available.

*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
*  Days lost due to cases of occupational injury ('ilo_joball_oi_day')		   *
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
* Comment: - No information available.
				
* ------------------------------------------------------------------------------
********************************************************************************
*                                                                              *
*	          PART 3.3 UNEMPLOYMENT: ECONOMIC CHARACTERISTICS                  *
*                                                                              * 
********************************************************************************
* ------------------------------------------------------------------------------		
		
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			Category of unemployment ('ilo_cat_une') 	                       * 
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment:
	
	if time=="2009Q1" {
	   gen cat_une=b5p25
	}
    else {
	   gen cat_une=b5p24
	}
	
	gen ilo_cat_une=.
		replace ilo_cat_une=1 if cat_une==1 & ilo_lfs==2                        // Previously employed       
		replace ilo_cat_une=2 if cat_une==2 & ilo_lfs==2                        // Seeking for the first time
		replace ilo_cat_une=3 if ilo_cat_une==. & ilo_lfs==2                    // Unknown
			    lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
			    lab val ilo_cat_une cat_une_lab
			    lab var ilo_cat_une "Category of unemployment"
				
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			   Duration of unemployment ('ilo_dur')  	                       * 
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: - One variable referring to the number of years looking for a job,
*            another to the amount of months.

    gen tot_month_une=.
        if time=="2009Q1" | year<2009 {
	       replace tot_month_une = 12*b5p21a + b5p21b if b5p21a!=99 & b5p21b!=99
	    }
        else {
	       replace tot_month_une = 12*b5p20a + b5p20b if b5p20a!=99 & b5p20b!=99
	    }
	

	* Detailed categories		
    gen ilo_dur_details=.
	    replace ilo_dur_details=1 if tot_month_une<1 & tot_month_une!=. & ilo_lfs==2            // Less than 1 month
		replace ilo_dur_details=2 if tot_month_une>=1 & tot_month_une<3 & ilo_lfs==2            // 1 to 3 months
		replace ilo_dur_details=3 if tot_month_une>=3 & tot_month_une<6 & ilo_lfs==2            // 3 to 6 months
		replace ilo_dur_details=4 if tot_month_une>=6 & tot_month_une<12 & ilo_lfs==2           // 6 to 12 months
		replace ilo_dur_details=5 if tot_month_une>=12 & tot_month_une<24 & ilo_lfs==2          // 12 to 24 months
		replace ilo_dur_details=6 if tot_month_une>=24 & tot_month_une!=. & ilo_lfs==2          // 24 months or more
		replace ilo_dur_details=7 if ilo_dur_details==. & ilo_lfs==2    // Not elsewhere classified
		        lab def unemp_det 1 "1 - Less than 1 month" 2 "2 - 1 month to less than 3 months" 3 "3 - 3 months to less than 6 months" ///
								  4 "4 - 6 months to less than 12 months" 5 "5 - 12 months to less than 24 months" 6 "6 - 24 months or more" ///
								  7 "7 - Not elsewhere classified"
			    lab val ilo_dur_details unemp_det
			    lab var ilo_dur_details "Duration of unemployment (Details)"
		
    * Aggregate categories
	gen ilo_dur_aggregate=.
		replace ilo_dur_aggregate=1 if (inlist(ilo_dur_details,1,2,3) & ilo_lfs==2)   // Less than 6 months
		replace ilo_dur_aggregate=2 if (ilo_dur_details==4 & ilo_lfs==2)              // 6 to 12 months
		replace ilo_dur_aggregate=3 if (inlist(ilo_dur_details,5,6) & ilo_lfs==2)     // 12 months or more
		replace ilo_dur_aggregate=4 if (ilo_dur_details==7 & ilo_lfs==2)              // Not elsewhere classified
		replace ilo_dur_aggregate=. if ilo_lfs!=2
			    lab def unemp_aggr 1 "1 - Less than 6 months" 2 "2 - 6 months to less than 12 months" 3 "3 - 12 months or more" 4 "4 - Not elsewhere classified"
			    lab val ilo_dur_aggregate unemp_aggr
			    lab var ilo_dur_aggregate "Duration of unemployment (Aggregate)"

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4') 	               * 
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: - Due to filter questions before this one, not all people that were
*            previously employed were asked the previous economic activity and 
*            therefore this variable is not computed.
		
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu_isco08') 		                   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: - No information available.
	
* ------------------------------------------------------------------------------
********************************************************************************
*                                                                              *
*	        PART 3.4 OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS            *
*                                                                              * 
********************************************************************************
* ------------------------------------------------------------------------------				

* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*		Degree of labour market attachment ('ilo_olf_dlma') 	               * 
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------		
* Comment: - The variable is not defined due to the filter questions previously
*            asked (only category 2 could be defined). 
		
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			Reasons for not seeking a job ('ilo_olf_reason') 	               *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment:
     
	 if time=="2009Q1" | year<2009 {
	    gen var_olf = b5p23
	 }
     else {
	    gen var_olf = b5p22
	 }

	 gen ilo_olf_reason=.
		 replace ilo_olf_reason=1 if var_olf==1 & ilo_lfs==3                    // Labour market 
		 * replace ilo_olf_reason=2 if                                          // Other labour market reasons
		 replace ilo_olf_reason=3 if inlist(var_olf,3,4,7) & ilo_lfs==3         // Personal/Family-related
		 replace ilo_olf_reason=4 if var_olf==6 & ilo_lfs==3                    // Does not need/want to work
		 replace ilo_olf_reason=5 if ilo_olf_reason==. & ilo_lfs==3             // Not elsewhere classified
 			     lab def lab_olf_reason 1 "1 - Labour market" 2 " 2 - Other labour market reasons" 3 "3 - Personal/Family-related"  ///
				                        4 "4 - Does not need/want to work" 5 "5 - Not elsewhere classified"
				 lab val ilo_olf_reason lab_olf_reason
				 lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"	
				 
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			      Discouraged job-seekers ('ilo_dis') 		                   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment:
    
	if time=="2009Q1" | year<2009 {
	   gen discou=b5p24
	}
    else {
	   gen discou=b5p23
	}

	gen ilo_dis=.
	    replace ilo_dis=1 if !inlist(ilo_lfs,1,2) & discou==1 & ilo_olf_reason==1
			    lab def ilo_dis_lab 1 "Discouraged job-seekers" 
			    lab val ilo_dis ilo_dis_lab
			    lab var ilo_dis "Discouraged job-seekers"
			
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*  Youth not in education, employment or training (NEETs) ('ilo_neet') 		   *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment:

	  gen ilo_neet=1 if ilo_age_aggregate==2 & ilo_lfs!=1 & ilo_edu_attendance==2
		  lab def neet_lab 1 "Youth not in education, employment or training"
		  lab val ilo_neet neet_lab
		  lab var ilo_neet "Youth not in education, employment or training"			
		
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			                    SAVE RESULTS                                   *            
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------

* ------------------------------------------------------------------------------
*                       Preparation of final dataset                           *
* ------------------------------------------------------------------------------

cd "$outpath"
	drop ilo_age
	
	/* Variables computed in-between */
	drop year empstatus indu_code_prim indu_code_sec occ_code_prim
	drop earn_cash_kind cat_une tot_month_une var_olf discou
	compress
		
	/* Save dataset including original and ilo variables*/
	save ${country}_${source}_${time}_FULL,  replace		
	
	*Save file only containing ilo_* variables
	keep ilo*
	save ${country}_${source}_${time}_ILO, replace				
