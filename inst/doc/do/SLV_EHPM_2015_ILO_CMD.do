* TITLE OF DO FILE: ILO Microdata Preprocessing code template - El Salvador
* DATASET USED: El Salvador EHPM
* NOTES: 
* Files created: Standard variables on EHPM El Salvador
* Authors: ILO / Department of Statistics / DPAU

* Starting Date: 26 September 2017
* Last updated: 25 June 2018
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
global country "SLV"
global source "EHPM"
global time "2015"
global inputFile "EHPM 2015 PERSONA"
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


*---------
* create local for Year
*---------

decode ilo_time, gen(to_drop)
local Y = to_drop in 1		

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sample Weight ('ilo_wgt') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment:

if `Y' <= 2012 {	
	gen ilo_wgt=fac01
		lab var ilo_wgt "Sample weight"
}		

if `Y' >= 2013 {	
	gen ilo_wgt=fac00
		lab var ilo_wgt "Sample weight"
}

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
		replace ilo_geo=2 if area==0
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
	    replace ilo_sex=1 if r104==1
		replace ilo_sex=2 if r104==2
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
	    replace ilo_age=r106
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
* Comment: - The educational level is asked depending on whether the person is currently 
*            attending to any level of formal education.
*          - Those aged 3 years old or less are classified under no schooling regardless their
*            answer in question r201a (currently attending an initial education center).
*          - ISCED mapping follows the document below: 
*            - http://www.ibe.unesco.org/fileadmin/user_upload/Publications/WDE/2010/pdf-versions/El_Salvador.pdf
*            - http://www.dgb.sep.gob.mx/tramites/revalidacion/Estruc_sist_edu/Estud-SALVADOR.pdf

if `Y' < 2016 {		
	gen ilo_edu_isced97=.
		replace ilo_edu_isced97=1 if (r204==1 & inrange(r205,1,3)) | (r215==2) | ///
		                             (r217a==1 & inlist(r217b,1,2)) | (r217a==8)                                                             // No schooling
		replace ilo_edu_isced97=2 if ilo_edu_isced97==. & ((r204==2 & inrange(r205,1,6)) | (r204==6 & inlist(r205,1,2)) | ///
		                             (r217a==1 & r217b==3) | (r217a==2 & inrange(r217b,1,5)) | (r217a==6 & r217b==1))                        // Pre-primary education
		replace ilo_edu_isced97=3 if ilo_edu_isced97==. & ((r204==2 & inrange(r205,7,9)) | (r204==6 & r205==3) | ///
		                             (r217a==2 & inrange(r217b,6,8)) | (r217a==6 & r217b==2))                                                // Primary education or first stage of basic education
		replace ilo_edu_isced97=4 if ilo_edu_isced97==. & ((r204==3 & inlist(r205,10,11)) | (r204==6 & r205==4) | ///
		                             (r217a==2 & r217b==9) | (r217a==3 & r217b==10) | (r217a==6 & r217b==3))                                 // Lower secondary education or second stage of basic education
		replace ilo_edu_isced97=5 if ilo_edu_isced97==. & ((r204==3 & inlist(r205,12,13)) | (r204==4 & inrange(r205,1,5)) | (r204==5 & inrange(r205,1,3)) | ///
		                             (r217a==3 & r217b==11) | (r217a==4 & inrange(r217b,1,4)) | (r217a==5 & inlist(r217b,1,2)) | ///
									 (r217a==6 & r217b==4))                                                                                  // Upper secondary education
		replace ilo_edu_isced97=6 if ilo_edu_isced97==. & ((r217a==5 & r217b==3) | (r217a==3 & inlist(r217b,12,13)))                         // Post-secondary non-terciary education
		replace ilo_edu_isced97=7 if ilo_edu_isced97==. & ((r204==4 & inlist(r205,6,7)) | ///
		                             (r217a==4 & inlist(r217b,5,6)))                                                                         // First stage of tertiary education
		replace ilo_edu_isced97=8 if ilo_edu_isced97==. & ((r204==4 & inrange(r205,8,15)) | ///
		                             (r217a==4 & inrange(r217b,7,15)))                                                                        // Second stage of tertiary education
		replace ilo_edu_isced97=9 if ilo_edu_isced97==.                                                                                      // Level not stated
}

if `Y' >= 2016 {	
	gen ilo_edu_isced97=.
		replace ilo_edu_isced97=1 if (r204==1 & inrange(r204g,1,3)) | (r213==2) | ///
		                             (r215a==1 & inlist(r215b,1,2)) | (r215a==8)                                                             // No schooling
		replace ilo_edu_isced97=2 if ilo_edu_isced97==. & ((r204==2 & inrange(r204g,1,6)) | (r204==6 & inlist(r204g,1,2)) | ///
		                             (r215a==1 & r215b==3) | (r215a==2 & inrange(r215b,1,5)) | (r215a==6 & r215b==1))                        // Pre-primary education
		replace ilo_edu_isced97=3 if ilo_edu_isced97==. & ((r204==2 & inrange(r204g,7,9)) | (r204==6 & r204g==3) | ///
		                             (r215a==2 & inrange(r215b,6,8)) | (r215a==6 & r215b==2))                                                // Primary education or first stage of basic education
		replace ilo_edu_isced97=4 if ilo_edu_isced97==. & ((r204==3 & inlist(r204g,10,11)) | (r204==6 & r204g==4) | ///
		                             (r215a==2 & r215b==9) | (r215a==3 & r215b==10) | (r215a==6 & r215b==3))                                 // Lower secondary education or second stage of basic education
		replace ilo_edu_isced97=5 if ilo_edu_isced97==. & ((r204==3 & inlist(r204g,12,13)) | (r204==4 & inrange(r204g,1,5)) | (r204==5 & inrange(r204g,1,3)) | ///
		                             (r215a==3 & r215b==11) | (r215a==4 & inrange(r215b,1,4)) | (r215a==5 & inlist(r215b,1,2)) | ///
									 (r215a==6 & r215b==4))                                                                                  // Upper secondary education
		replace ilo_edu_isced97=6 if ilo_edu_isced97==. & ((r215a==5 & r215b==3) | (r215a==3 & inlist(r215b,12,13)))                         // Post-secondary non-terciary education
		replace ilo_edu_isced97=7 if ilo_edu_isced97==. & ((r204==4 & inlist(r204g,6,7)) | ///
		                             (r215a==4 & inlist(r215b,5,6)))                                                                         // First stage of tertiary education
		replace ilo_edu_isced97=8 if ilo_edu_isced97==. & ((r204==4 & inrange(r204g,8,15)) | ///
		                             (r215a==4 & inrange(r215b,7,15)))                                                                        // Second stage of tertiary education
		replace ilo_edu_isced97=9 if ilo_edu_isced97==.                                                                                      // Level not stated
}		
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
* Comment: - Those aged 3 years old are classified under attending if they answered yes to the
*            question r201a (currently attending and initial education center)

		gen ilo_edu_attendance=.
		if `Y' <= 2014 {			
			replace ilo_edu_attendance=1 if (r201b==1) | (r203==1)              // Attending 
			replace ilo_edu_attendance=2 if (r201b==2) | (r203==2)              // Not attending
			replace ilo_edu_attendance=3 if ilo_edu_attendance==.
		}
		if `Y' >= 2015 {			
			replace ilo_edu_attendance=1 if (r201a==1) | (r203==1)              // Attending 
			replace ilo_edu_attendance=2 if (r201a==2) | (r203==2)              // Not attending
			replace ilo_edu_attendance=3 if ilo_edu_attendance==.
		}
				    lab def edu_attendance_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
				    lab val ilo_edu_attendance edu_attendance_lab
				    lab var ilo_edu_attendance "Education (Attendance)"

					
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			           Marital status ('ilo_mrts') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: marital status question is made to people aged 12 years and above. 
	
	* Detailed
	gen ilo_mrts_details=.
	    replace ilo_mrts_details=1 if r107==6                                   // Single
		replace ilo_mrts_details=2 if r107==2                                   // Married
		replace ilo_mrts_details=3 if r107==1                                   // Union / cohabiting
		replace ilo_mrts_details=4 if r107==3                                   // Widowed
		replace ilo_mrts_details=5 if inlist(r107,4,5)                          // Divorced / separated
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
* Comment: - National definition includes people aged 16 years old or more.

	gen ilo_wap=.
		replace ilo_wap=1 if ilo_age>=16 & ilo_age!=.
			lab def wap_lab 1 "Working age population"
			lab val ilo_wap wap_lab
			label var ilo_wap "Working age population"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Labour Force Status ('ilo_lfs') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Employment comprises pepole who worked for at least one hour last week or was 
*            absent, those who were absent to work but either still receiving salary/wage or 
*            going back to work in four weeks or less, and those who where absent form their
*            own business/economic activity.
*          - Unemployment includes people not in employment, seeking for a job and available 
*            to work, and future starters. Final estimate of unemployment differs from the 
*            national one due to the definition of future starters used (the NSO includes those
*            workers waiting for an answer after an application or seasonal break).
 
	gen ilo_lfs=.
	    replace ilo_lfs=1 if (r403==1) & ilo_wap==1                                                       // Employed: worked for at least one hour last week or was absent.
		replace ilo_lfs=1 if (r405==1 & inrange(r406,1,5)) & ilo_wap==1                                   // Employed: absent from work mainly for vacations, studies, authorized leaves.
		replace ilo_lfs=1 if ((r405==1 & r406a==1) | (r405==1 & !inlist(r406b,3,4,5,6))) & ilo_wap==1     // Employed: absent from work (still receiving salary/wage or going back to work in four weeks or less).
		replace ilo_lfs=1 if (r405b==1) & ilo_wap==1                                                      // Employed: absent from own business/economic activity.
		replace ilo_lfs=2 if (ilo_lfs!=1 & r407==1 & r409a==1) & ilo_wap==1                               // Unemployment: not in employment, seeking and available.
		replace ilo_lfs=2 if (ilo_lfs!=1 & r407==2 & r409==17) & ilo_wap==1                               // Unemployment: future starters.
		replace ilo_lfs=3 if !inlist(ilo_lfs,1,2) & ilo_wap==1                                            // Outside the labour force
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
		replace ilo_mjh=2 if r432==1 & ilo_lfs==1
		replace ilo_mjh=1 if r432==2 & ilo_lfs==1
		replace ilo_mjh=1 if ilo_mjh==. & ilo_lfs==1
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
* Comment: - Employees include apprentices and domestic services
*          - Status in employment is not asked for the second job

	* MAIN JOB	
	* Detailed categories
	  gen ilo_job1_ste_icse93=.
		  replace ilo_job1_ste_icse93=1 if inlist(r418,6,7,8,9) & ilo_lfs==1    // Employees
		  replace ilo_job1_ste_icse93=2 if r418==1 & ilo_lfs==1                 // Employers
		  replace ilo_job1_ste_icse93=3 if inlist(r418,2,3) & ilo_lfs==1        // Own-account workers
		  replace ilo_job1_ste_icse93=4 if r418==4 & ilo_lfs==1                 // Members of producers' cooperatives
		  replace ilo_job1_ste_icse93=5 if r418==5 & ilo_lfs==1                 // Contributing family workers
		  replace ilo_job1_ste_icse93=6 if ilo_job1_ste_icse93==. & ilo_lfs==1  // Not classifiable by status
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
				
	* SECOND JOB	
	* Not asked
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - According to the national report, the original classification follows ISIC Rev 4.
	
	* MAIN JOB:
	gen indu_code_prim=.
	    replace indu_code_prim=int(r416/100)

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

	* SECOND JOB:
	gen indu_code_sec=.
	    replace indu_code_sec=int(r438/100)

	* 2-digit level	
	gen ilo_job2_eco_isic4_2digits=indu_code_sec if ilo_mjh==2
	    * labels already defined for main job
        lab val ilo_job2_eco_isic4_2digits eco_isic4_digits
        lab var ilo_job2_eco_isic4_2digits "Economic activity (ISIC Rev. 4), 2 digits levels - second job"

	* 1-digit level
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
		        * labels already defined for main job		
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
			   * labels already defined for main job					
			   lab val ilo_job2_eco_aggregate eco_aggr_lab
			   lab var ilo_job2_eco_aggregate "Economic activity (Aggregate) - second job"
			   
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_ocu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - According to the national report, original classification follows ISCO-08 at 
*            4 digit-level.
*          - Before 2012, the original classification follows ISCO-88 at 4-digit level.

if `Y' <= 2012 {	
    * MAIN JOB	
	gen occ_code_prim=.
	    replace occ_code_prim=int(r414/100)

    * 2-digit level
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

    * 1-digit level
	gen ilo_job1_ocu_isco88=.
	    replace ilo_job1_ocu_isco88=11 if ilo_job1_ocu_isco88_2digits==. & ilo_lfs==1     // Not elsewhere classified
		replace ilo_job1_ocu_isco88=int(ilo_job1_ocu_isco88_2digits/10) if ilo_lfs==1     // The rest of the occupations
		replace ilo_job1_ocu_isco88=10 if (ilo_job1_ocu_isco88==0 & ilo_lfs==1)           // Armed forces
	            lab def ocu88_1digits 1 "1 - Legislators, senior officials and managers"	2 "2 - Professionals"	3 "3 - Technicians and associate professionals" ///
                                      5 "5 - Service workers and shop and market sales workers"	6 "6 - Skilled agricultural and fishery workers"	7 "7 - Craft and related trades workers" ///
                                      9 "9 - Elementary occupations"	10 "0 - Armed forces"	11 "11 - Not elsewhere classified"
				lab val ilo_job1_ocu_isco88 ocu88_1digits
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
				
	* SECOND JOB
	gen occ_code_sec=.
	    replace occ_code_sec=int(r436/100)
		
    * 2-digit level		
	gen ilo_job2_ocu_isco88_2digits=occ_code_sec if ilo_mjh==2
	    * labels already defined for main job
		lab values ilo_job2_ocu_isco88_2digits ocu88_2digits
		lab var ilo_job2_ocu_isco88_2digits "Occupation (ISCO-88), 2 digit level - second job"

    * 1-digit level
	gen ilo_job2_ocu_isco88=.
	    replace ilo_job2_ocu_isco88=11 if ilo_job2_ocu_isco88_2digits==. & ilo_mjh==2     // Not elsewhere classified
		replace ilo_job2_ocu_isco88=int(ilo_job2_ocu_isco88_2digits/10) if ilo_mjh==2     // The rest of the occupations
		replace ilo_job2_ocu_isco88=10 if (ilo_job2_ocu_isco88==0 & ilo_mjh==2)           // Armed forces
	            * labels already defined for main job
				lab val ilo_job2_ocu_isco88 ocu88_1digits
				lab var ilo_job2_ocu_isco88 "Occupation (ISCO-88) - second job"
			
	* Aggregate:			
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
	gen ilo_job2_ocu_skill=.
	    replace ilo_job2_ocu_skill=1 if ilo_job2_ocu_isco88==9                   // Low
		replace ilo_job2_ocu_skill=2 if inlist(ilo_job2_ocu_isco88,4,5,6,7,8)    // Medium
		replace ilo_job2_ocu_skill=3 if inlist(ilo_job2_ocu_isco88,1,2,3)        // High
		replace ilo_job2_ocu_skill=4 if inlist(ilo_job2_ocu_isco88,10,11)        // Not elsewhere classified
				* labels already defined for main job
			    lab val ilo_job2_ocu_skill ocu_skill_lab
			    lab var ilo_job2_ocu_skill "Occupation (Skill level) - second job"
}		

if `Y' >= 2013 {	
    * MAIN JOB	
	gen occ_code_prim=.
	    replace occ_code_prim=int(r414/100)

    * 2-digit level
	gen ilo_job1_ocu_isco08_2digits=occ_code_prim if ilo_lfs==1
	    lab def ocu08_2digits 1 "01 - Commissioned armed forces officers"	2 "02 - Non-commissioned armed forces officers"	3 "03 - Armed forces occupations, other ranks"	11 "11 - Chief executives, senior officials and legislators" ///
                              12 "12 - Administrative and commercial managers"	13 "13 - Production and specialised services managers"	14 "14 - Hospitality, retail and other services managers"	21 "21 - Science and engineering professionals" ///
                              22 "22 - Health professionals"	23 "23 - Teaching professionals"	24 "24 - Business and administration professionals"	25 "25 - Information and communications technology professionals" ///
                              26 "26 - Legal, social and cultural professionals"	31 "31 - Science and engineering associate professionals"	32 "32 - Health associate professionals"	33 "33 - Business and administration associate professionals" ///
                              34 "34 - Legal, social, cultural and related associate professionals"	35 "35 - Information and communications technicians"	41 "41 - General and keyboard clerks"	42 "42 - Customer services clerks" ///
                              43 "43 - Numerical and material recording clerks"	44 "44 - Other clerical support workers"	51 "51 - Personal service workers"	52 "52 - Sales workers" ///
                              53 "53 - Personal care workers"	54 "54 - Protective services workers"	61 "61 - Market-oriented skilled agricultural workers"	62 "62 - Market-oriented skilled forestry, fishery and hunting workers" ///
                              63 "63 - Subsistence farmers, fishers, hunters and gatherers"	71 "71 - Building and related trades workers, excluding electricians"	72 "72 - Metal, machinery and related trades workers"	73 "73 - Handicraft and printing workers" ///
                              74 "74 - Electrical and electronic trades workers"	75 "75 - Food processing, wood working, garment and other craft and related trades workers"	81 "81 - Stationary plant and machine operators"	82 "82 - Assemblers" ///
                              83 "83 - Drivers and mobile plant operators"	91 "91 - Cleaners and helpers"	92 "92 - Agricultural, forestry and fishery labourers"	93 "93 - Labourers in mining, construction, manufacturing and transport" ///
                              94 "94 - Food preparation assistants"	95 "95 - Street and related sales and service workers"	96 "96 - Refuse workers and other elementary workers"	
		lab values ilo_job1_ocu_isco08_2digits ocu08_2digits
		lab var ilo_job1_ocu_isco08_2digits "Occupation (ISCO-08), 2 digit level - main job"

    * 1-digit level
	gen ilo_job1_ocu_isco08=.
        replace ilo_job1_ocu_isco08=11 if ilo_job1_ocu_isco08_2digits==. & ilo_lfs==1     // Not elsewhere classified
	    replace ilo_job1_ocu_isco08=int(ilo_job1_ocu_isco08_2digits/10) if ilo_lfs==1     // The rest of the occupations
		replace ilo_job1_ocu_isco08=10 if (ilo_job1_ocu_isco08==0 & ilo_lfs==1)           // Armed forces
		        lab def ocu08_1digits 1 "1 - Managers"	2 "2 - Professionals"	3 "3 - Technicians and associate professionals"	4 "4 - Clerical support workers" ///
                                      5 "5 - Service and sales workers"	6 "6 - Skilled agricultural, forestry and fishery workers"	7 "7 - Craft and related trades workers"	/// 
						              8 "8 - Plant and machine operators, and assemblers"  9 "9 - Elementary occupations"	10 "0 - Armed forces occupations"	///
						              11 "X - Not elsewhere classified"	
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
	gen occ_code_sec=.
	    replace occ_code_sec=int(r436/100)
		
    * 2-digit level		
	gen ilo_job2_ocu_isco08_2digits=occ_code_sec if ilo_mjh==2
	    * labels already defined for main job
		lab values ilo_job2_ocu_isco08_2digits ocu08_2digits
		lab var ilo_job2_ocu_isco08_2digits "Occupation (ISCO-08), 2 digit level - second job"

    * 1-digit level
	gen ilo_job2_ocu_isco08=.
	    replace ilo_job2_ocu_isco08=11 if ilo_job2_ocu_isco08_2digits==. & ilo_mjh==2     // Not elsewhere classified
	    replace ilo_job2_ocu_isco08=int(ilo_job2_ocu_isco08_2digits/10) if ilo_mjh==2     // The rest of the occupations
	    replace ilo_job2_ocu_isco08=10 if (ilo_job2_ocu_isco08==0 & ilo_mjh==2)           // Armed forces
		        * labels already defined for main job
				lab val ilo_job2_ocu_isco08 ocu08_1digits
				lab var ilo_job2_ocu_isco08 "Occupation (ISCO-08) - second job"
			
	* Aggregate:			
    gen ilo_job2_ocu_aggregate=.
	    replace ilo_job2_ocu_aggregate=1 if inrange(ilo_job2_ocu_isco08,1,3)   
	    replace ilo_job2_ocu_aggregate=2 if inlist(ilo_job2_ocu_isco08,4,5)
	    replace ilo_job2_ocu_aggregate=3 if inlist(ilo_job2_ocu_isco08,6,7)
	    replace ilo_job2_ocu_aggregate=4 if ilo_job2_ocu_isco08==8
	    replace ilo_job2_ocu_aggregate=5 if ilo_job2_ocu_isco08==9
	    replace ilo_job2_ocu_aggregate=6 if ilo_job2_ocu_isco08==10
	    replace ilo_job2_ocu_aggregate=7 if ilo_job2_ocu_isco08==11
		  	    * labels already defined for main job
			    lab val ilo_job2_ocu_aggregate ocu_aggr_lab
			    lab var ilo_job2_ocu_aggregate "Occupation (Aggregate) - second job"	
		
	* Skill level
	gen ilo_job2_ocu_skill=.
	    replace ilo_job2_ocu_skill=1 if ilo_job2_ocu_isco08==9                   // Low
		replace ilo_job2_ocu_skill=2 if inlist(ilo_job2_ocu_isco08,4,5,6,7,8)    // Medium
		replace ilo_job2_ocu_skill=3 if inlist(ilo_job2_ocu_isco08,1,2,3)        // High
		replace ilo_job2_ocu_skill=4 if inlist(ilo_job2_ocu_isco08,10,11)        // Not elsewhere classified
				* labels already defined for main job
			    lab val ilo_job2_ocu_skill ocu_skill_lab
			    lab var ilo_job2_ocu_skill "Occupation (Skill level) - second job"
}			

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_ins_sector') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Private: private and international organization.
*          - Not asked for second job.
*          - Only asked to employees, so the rest of employed people are classified under private.
	
	* MAIN JOB
	gen ilo_job1_ins_sector=.
		replace ilo_job1_ins_sector=1 if r420==2 & ilo_lfs==1
		replace ilo_job1_ins_sector=2 if inlist(r420,1,3) & ilo_lfs==1
        replace ilo_job1_ins_sector=2 if ilo_job1_ins_sector==. & ilo_lfs==1
                lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
			    lab values ilo_job1_ins_sector ins_sector_lab
			    lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities - main job"
				
	* SECOND JOB
    * Not asked.
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Informal/Formal economy: ('ilo_job1_ife_prod' and 'ilo_job1_ife_nature') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: 
/* Useful questions:
		  * Institutional sector: r420
		  * Private HH: Activities of Private HH: ilo_job1_eco_isic4_2digits (==97) / ilo_job1_ocu_isco08_2digits (==63). 2012:ilo_job1_ocu_isco88_2digits
		  * Destination of production: r430, but the category "only for own final use" does not exist, and thus not used.
		  * Bookkeeping: r426a. 2013 and before not asked.
		  * Registration: r426b1/r426b1  ("or"). 2014 only r426b. 2013 and before not asked.
		  * Status in employment: ilo_job1_ste_icse93==1 (employees)
		  * Social security contribution: following the enumerator's manual: r422a (ISSS)/ r422b (Bienestar magisterial) / r422c (IPSFA) / r422d (Colectivo) / r422e (Individual(Privado)) / r422f (AFP) / r422g (INPEP)
		  *                               2014, 2013 only one related question: r422==1
		  * Place of work: r426 (not used because everyone is classified before that filter). 2014 and before it is used (2013 and before only three options, asked only to self-employed).
		  * Size: r421 (not used bc place of work is not used). 2014 and before it is used. 
		  * Paid annual leave: not asked.
		  * Paid sick leave: not asked.
*/
if `Y' <= 2012 {
    * Social security (to be dropped afterwards)
	gen social_security=.
	    replace social_security=1 if (r422==1) & ilo_lfs==1             // Social security
		replace social_security=2 if (inlist(r422,2,3)) & ilo_lfs==1    // No social security
		replace social_security=. if (social_security==. & ilo_lfs==1)
		
    * 1) UNIT OF PRODUCTION: FORMAL/INFORMAL SECTOR		
    gen ilo_job1_ife_prod=.
		replace ilo_job1_ife_prod=3 if ilo_lfs==1 & ///
		                               ((ilo_job1_eco_isic4_2digits==97) | ///
									   (ilo_job1_ocu_isco88_2digits==62))
		replace ilo_job1_ife_prod=2 if ilo_lfs==1 & ilo_job1_ife_prod!=3 & ///
		                               ((ilo_job1_ste_icse93==1 & social_security==1) | ///
									   (ilo_job1_ste_icse93!=1 & r426==2 & r421>=6))
        replace ilo_job1_ife_prod=1 if ilo_lfs==1 & !inlist(ilo_job1_ife_prod,2,3)  
				lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 
				lab val ilo_job1_ife_prod ilo_ife_prod_lab
				lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"		
						

	* 2) NATURE OF JOB: FORMAL/INFORMAL EMPLOYMENT
	gen ilo_job1_ife_nature=.
	    replace ilo_job1_ife_nature=1 if ilo_lfs==1 & ///
	                                     ((inlist(ilo_job1_ste_icse93,1,6) & social_security==2) | ///
										 (inlist(ilo_job1_ste_icse93,2,4) & inlist(ilo_job1_ife_prod,1,3)) | ///
										 (ilo_job1_ste_icse93==3 & inlist(ilo_job1_ife_prod,1,3)) | ///
										 (ilo_job1_ste_icse93==5))
	    replace ilo_job1_ife_nature=2 if ilo_lfs==1 & ///
			                             ((inlist(ilo_job1_ste_icse93,1,6) & social_security==1) | ///
										 (inlist(ilo_job1_ste_icse93,2,4) & ilo_job1_ife_prod==2) | ///
										 (ilo_job1_ste_icse93==3 & ilo_job1_ife_prod==2))
                lab def ife_nature_lab 1 "1 - Persons with informal main job" 2 "2 - Persons with formal main job"
		        lab val ilo_job1_ife_nature ife_nature_lab
		        lab var ilo_job1_ife_nature "Informal / Formal Economy (Nature of job)"	

}

if `Y' == 2013 {
    * Social security (to be dropped afterwards)
	gen social_security=.
	    replace social_security=1 if (r422==1) & ilo_lfs==1             // Social security
		replace social_security=2 if (inlist(r422,2,3)) & ilo_lfs==1    // No social security
		replace social_security=. if (social_security==. & ilo_lfs==1)
		
    * 1) UNIT OF PRODUCTION: FORMAL/INFORMAL SECTOR		
    gen ilo_job1_ife_prod=.
		replace ilo_job1_ife_prod=3 if ilo_lfs==1 & ///
		                               ((ilo_job1_eco_isic4_2digits==97) | ///
									   (ilo_job1_ocu_isco08_2digits==63))
		replace ilo_job1_ife_prod=2 if ilo_lfs==1 & ilo_job1_ife_prod!=3 & ///
		                               ((ilo_job1_ste_icse93==1 & social_security==1) | ///
									   (ilo_job1_ste_icse93!=1 & r426==2 & r421>=6))
        replace ilo_job1_ife_prod=1 if ilo_lfs==1 & !inlist(ilo_job1_ife_prod,2,3) 
				lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 
				lab val ilo_job1_ife_prod ilo_ife_prod_lab
				lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"		
						

	* 2) NATURE OF JOB: FORMAL/INFORMAL EMPLOYMENT
	gen ilo_job1_ife_nature=.
	    replace ilo_job1_ife_nature=1 if ilo_lfs==1 & ///
	                                     ((inlist(ilo_job1_ste_icse93,1,6) & social_security==2) | ///
										 (inlist(ilo_job1_ste_icse93,2,4) & inlist(ilo_job1_ife_prod,1,3)) | ///
										 (ilo_job1_ste_icse93==3 & inlist(ilo_job1_ife_prod,1,3)) | ///
										 (ilo_job1_ste_icse93==5))
	    replace ilo_job1_ife_nature=2 if ilo_lfs==1 & ///
			                             ((inlist(ilo_job1_ste_icse93,1,6) & social_security==1) | ///
										 (inlist(ilo_job1_ste_icse93,2,4) & ilo_job1_ife_prod==2) | ///
										 (ilo_job1_ste_icse93==3 & ilo_job1_ife_prod==2))
                lab def ife_nature_lab 1 "1 - Persons with informal main job" 2 "2 - Persons with formal main job"
		        lab val ilo_job1_ife_nature ife_nature_lab
		        lab var ilo_job1_ife_nature "Informal / Formal Economy (Nature of job)"	

}
if `Y' == 2014 {
    * Social security (to be dropped afterwards)
	gen social_security=.
	    replace social_security=1 if (r422==1) & ilo_lfs==1             // Social security
		replace social_security=2 if (inlist(r422,2,3)) & ilo_lfs==1    // No social security
		replace social_security=. if (social_security==. & ilo_lfs==1)
		
    * 1) UNIT OF PRODUCTION: FORMAL/INFORMAL SECTOR		
    gen ilo_job1_ife_prod=.
		replace ilo_job1_ife_prod=3 if ilo_lfs==1 & ///
		                               ((ilo_job1_eco_isic4_2digits==97) | ///
									   (ilo_job1_ocu_isco08_2digits==63))
		replace ilo_job1_ife_prod=2 if ilo_lfs==1 & ilo_job1_ife_prod!=3 & ///
		                               ((inlist(r420,2,3)) | ///
									   (inlist(r420,1,4,.) & r426a==1) | ///
									   (inlist(r420,1,4,.) & r426a!=1 & r426b==1) | ///
									   (inlist(r420,1,4,.) & r426a!=1 & r426b==. & ilo_job1_ste_icse93==1 & social_security==1) | ///
									   (inlist(r420,1,4,.) & r426a!=1 & r426b==. & ilo_job1_ste_icse93==1 & social_security==2 & r426==8 & r421>=6) | ///
									   (inlist(r420,1,4,.) & r426a!=1 & r426b==. & ilo_job1_ste_icse93!=1 & r426==8 & r421>=6))
        replace ilo_job1_ife_prod=1 if ilo_lfs==1 & !inlist(ilo_job1_ife_prod,2,3) & ///
				                       ((inlist(r420,1,4,.) & r426a!=1 & inlist(r426b,2,3)) | ///
									   (inlist(r420,1,4,.) & r426a!=1 & r426b==. & ilo_job1_ste_icse93==1 & social_security==2 & r426!=8) | ///
									   (inlist(r420,1,4,.) & r426a!=1 & r426b==. & ilo_job1_ste_icse93==1 & social_security==2 & r426==8 & r421<6) | ///
									   (inlist(r420,1,4,.) & r426a!=1 & r426b==. & ilo_job1_ste_icse93!=1 & r426!=8) | ///
									   (inlist(r420,1,4,.) & r426a!=1 & r426b==. & ilo_job1_ste_icse93!=1 & r426!=8 & r421<6)) 
				lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 
				lab val ilo_job1_ife_prod ilo_ife_prod_lab
				lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"		
						

	* 2) NATURE OF JOB: FORMAL/INFORMAL EMPLOYMENT
	gen ilo_job1_ife_nature=.
	    replace ilo_job1_ife_nature=1 if ilo_lfs==1 & ///
	                                     ((inlist(ilo_job1_ste_icse93,1,6) & social_security==2) | ///
										 (inlist(ilo_job1_ste_icse93,2,4) & inlist(ilo_job1_ife_prod,1,3)) | ///
										 (ilo_job1_ste_icse93==3 & inlist(ilo_job1_ife_prod,1,3)) | ///
										 (ilo_job1_ste_icse93==5))
	    replace ilo_job1_ife_nature=2 if ilo_lfs==1 & ///
			                             ((inlist(ilo_job1_ste_icse93,1,6) & social_security==1) | ///
										 (inlist(ilo_job1_ste_icse93,2,4) & ilo_job1_ife_prod==2) | ///
										 (ilo_job1_ste_icse93==3 & ilo_job1_ife_prod==2))
                lab def ife_nature_lab 1 "1 - Persons with informal main job" 2 "2 - Persons with formal main job"
		        lab val ilo_job1_ife_nature ife_nature_lab
		        lab var ilo_job1_ife_nature "Informal / Formal Economy (Nature of job)"	
}
	
if `Y' >= 2015 {	
    * 1) UNIT OF PRODUCTION: FORMAL/INFORMAL SECTOR		
    gen ilo_job1_ife_prod=.
		replace ilo_job1_ife_prod=3 if ilo_lfs==1 & ///
		                               ((ilo_job1_eco_isic4_2digits==97) | ///
									   (ilo_job1_ocu_isco08_2digits==63))
		replace ilo_job1_ife_prod=2 if ilo_lfs==1 & ilo_job1_ife_prod!=3 & ///
		                               ((inlist(r420,2,3)) | ///
									   (inlist(r420,1,.) & r426a==1) | ///
									   (inlist(r420,1,.) & r426a!=1 & (r426b1==1 | r426b2==1)))
		replace ilo_job1_ife_prod=1 if ilo_lfs==1 & !inlist(ilo_job1_ife_prod,2,3) & ///
				                       (inlist(r420,1,.) & r426a!=1 & (inlist(r426b1,2,3) | inlist(r426b2,2,3))) 
				lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 
				lab val ilo_job1_ife_prod ilo_ife_prod_lab
				lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"		
						

    * Social security (to be dropped afterwards)
	gen social_security=.
	    replace social_security=1 if (r422a==2 | r422b==2 | r422c==2 | r422d==2 | r422e==2 | r422f==2 | r422g==2) & ilo_lfs==1                                                                   // Social security (cotizante in ISSS, IPSFA, AFP, INPEP)
		replace social_security=2 if (inlist(r422a,1,3) & inlist(r422b,1,3) & inlist(r422c,1,3) & inlist(r422d,1,3) & inlist(r422e,1,3) & inlist(r422f,1,3) & inlist(r422g,1,3)) & ilo_lfs==1    // No social security (afiliado or no)
		replace social_security=. if (social_security==. & ilo_lfs==1)

		
	* 2) NATURE OF JOB: FORMAL/INFORMAL EMPLOYMENT
	gen ilo_job1_ife_nature=.
	    replace ilo_job1_ife_nature=1 if ilo_lfs==1 & ///
	                                     ((inlist(ilo_job1_ste_icse93,1,6) & social_security==2) | ///
										 (inlist(ilo_job1_ste_icse93,2,4) & inlist(ilo_job1_ife_prod,1,3)) | ///
										 (ilo_job1_ste_icse93==3 & inlist(ilo_job1_ife_prod,1,3)) | ///
										 (ilo_job1_ste_icse93==5))
	    replace ilo_job1_ife_nature=2 if ilo_lfs==1 & ///
			                             ((inlist(ilo_job1_ste_icse93,1,6) & social_security==1) | ///
										 (inlist(ilo_job1_ste_icse93,2,4) & ilo_job1_ife_prod==2) | ///
										 (ilo_job1_ste_icse93==3 & ilo_job1_ife_prod==2))
                lab def ife_nature_lab 1 "1 - Persons with informal main job" 2 "2 - Persons with formal main job"
		        lab val ilo_job1_ife_nature ife_nature_lab
		        lab var ilo_job1_ife_nature "Informal / Formal Economy (Nature of job)"	
 }				
				
***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		
				
* --------------------------------------------------------------------------------------------------
* --------------------------------------------------------------------------------------------------
*		                 Hours of work ('ilo_how') [done]
* --------------------------------------------------------------------------------------------------
* --------------------------------------------------------------------------------------------------
* Comment: - Due to the skip pattern before the question on hours usually worked in main job (only
*            asked to those whose hours actually worked are less than 40 hours per week), this variable
*            is not produced.
*          - No information available on the hours usually worked in second job.

	* MAIN JOB
	* Hours actually worked in main job
	egen ilo_job1_how_actual=rowtotal(r411a r411d), m
	    replace ilo_job1_how_actual=. if ilo_lfs!=1
			    lab var ilo_job1_how_actual "Weekly hours actually worked - main job"
				
    gen ilo_job1_how_actual_bands=.
	 	replace ilo_job1_how_actual_bands=1 if ilo_job1_how_actual==0
		replace ilo_job1_how_actual_bands=2 if inrange(ilo_job1_how_actual,1,14)
		replace ilo_job1_how_actual_bands=3 if inrange(ilo_job1_how_actual,15,29)
		replace ilo_job1_how_actual_bands=4 if inrange(ilo_job1_how_actual,30,34)
		replace ilo_job1_how_actual_bands=5 if inrange(ilo_job1_how_actual,35,39)
		replace ilo_job1_how_actual_bands=6 if inrange(ilo_job1_how_actual,40,48)
		replace ilo_job1_how_actual_bands=7 if ilo_job1_how_actual>=49 & ilo_job1_how_actual!=.
		replace ilo_job1_how_actual_bands=8 if ilo_job1_how_actual==. & ilo_lfs==1
		replace ilo_job1_how_actual_bands=. if ilo_lfs!=1
		    	lab def how_act_bands_lab 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"
				lab val ilo_job1_how_actual_bands how_act_bands_lab
				lab var ilo_job1_how_actual_bands "Weekly hours actually worked bands - main job"
	
	* SECOND JOB
	* Hours actually worked in second job
	gen ilo_job2_how_actual=.
	    replace ilo_job2_how_actual=r433 if ilo_mjh==2
			    lab var ilo_job2_how_actual "Weekly hours actually worked - second job"
				
    gen ilo_job2_how_actual_bands=.
	 	replace ilo_job2_how_actual_bands=1 if ilo_job2_how_actual==0
		replace ilo_job2_how_actual_bands=2 if inrange(ilo_job2_how_actual,1,14)
		replace ilo_job2_how_actual_bands=3 if inrange(ilo_job2_how_actual,15,29)
		replace ilo_job2_how_actual_bands=4 if inrange(ilo_job2_how_actual,30,34)
		replace ilo_job2_how_actual_bands=5 if inrange(ilo_job2_how_actual,35,39)
		replace ilo_job2_how_actual_bands=6 if inrange(ilo_job2_how_actual,40,48)
		replace ilo_job2_how_actual_bands=7 if ilo_job2_how_actual>=49 & ilo_job2_how_actual!=.
		replace ilo_job2_how_actual_bands=8 if ilo_job2_how_actual==. & ilo_mjh==2
		replace ilo_job2_how_actual_bands=. if ilo_lfs!=1
				lab val ilo_job2_how_actual_bands how_act_bands_lab
				lab var ilo_job2_how_actual_bands "Weekly hours actually worked bands - second job"
	
	* Hours usually worked in second job
    * Not asked	
	
	* ALL JOBS	
	* Hours actually worked in all jobs
	egen ilo_joball_how_actual=rowtotal(ilo_job1_how_actual ilo_job2_how_actual), m
		replace ilo_joball_how_actual=. if ilo_lfs!=1
			    lab var ilo_joball_how_actual "Weekly hours actually worked - all jobs"
				
    gen ilo_joball_how_actual_bands=.
	 	replace ilo_joball_how_actual_bands=1 if ilo_joball_how_actual==0
		replace ilo_joball_how_actual_bands=2 if inrange(ilo_joball_how_actual,1,14)
		replace ilo_joball_how_actual_bands=3 if inrange(ilo_joball_how_actual,15,29)
		replace ilo_joball_how_actual_bands=4 if inrange(ilo_joball_how_actual,30,34)
		replace ilo_joball_how_actual_bands=5 if inrange(ilo_joball_how_actual,35,39)
		replace ilo_joball_how_actual_bands=6 if inrange(ilo_joball_how_actual,40,48)
		replace ilo_joball_how_actual_bands=7 if ilo_joball_how_actual>=49 & ilo_joball_how_actual!=.
		replace ilo_joball_how_actual_bands=8 if ilo_joball_how_actual==. & ilo_lfs==1
		replace ilo_joball_how_actual_bands=. if ilo_lfs!=1
		    	lab val ilo_joball_how_actual_bands how_act_bands_lab
				lab var ilo_joball_how_actual_bands "Weekly hours usually worked bands - all jobs"				
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
* Comment: - The threshold used is based on the median of the actual hours of work in all job;
*            it is set at 44 hours per week.
	
	gen ilo_job1_job_time=.
		replace ilo_job1_job_time=2 if (ilo_joball_how_actual>=44) & ilo_lfs==1
		replace ilo_job1_job_time=1 if (ilo_joball_how_actual<44) & ilo_lfs==1
		replace ilo_job1_job_time=3 if ilo_job1_job_time==. & ilo_lfs==1
        	    lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
			    lab val ilo_job1_job_time job_time_lab
			    lab var ilo_job1_job_time "Job (Working time arrangement)"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job_contract') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
* Comment: - Those without contract are classified under unknown

if `Y' <= 2013 {
  * No information available
}

if `Y' >= 2014 {		
	gen ilo_job1_job_contract=.
		replace ilo_job1_job_contract=1 if r419==1 & ilo_job1_ste_aggregate==1
		replace ilo_job1_job_contract=2 if inlist(r419,2,3,4,5,6) & ilo_job1_ste_aggregate==1
		replace ilo_job1_job_contract=3 if inlist(r419,7,8) & ilo_job1_ste_aggregate==1
				lab def job_contract_lab 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"
			    lab val ilo_job1_job_contract job_contract_lab
			    lab var ilo_job1_job_contract "Job (Type of contract)"
}				
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Monthly related income ('ilo_job1_lri_ees' and 'ilo_job1_lri_slf')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Zero (0) is placed as the monthly labour related income for those who
*            answered they do not receive any cash as income. It does not take into account 
*            non-cash remunerations. 
*          - Self-employment related income refers to the gross remuneration. Only aswered by
*            non-agricultural self-employed (either employers or own-account workers).

	* MAIN JOB
	* Employees
	  gen ilo_job1_lri_ees = .
		  replace ilo_job1_lri_ees = r424 if (inlist(r423,4,5) & ilo_job1_ste_aggregate==1)         // Month
		  replace ilo_job1_lri_ees = r424*(365/12) if (r423==1 & ilo_job1_ste_aggregate==1)         // Day to month
		  replace ilo_job1_lri_ees = r424*(52/12) if (r423==2 & ilo_job1_ste_aggregate==1)          // Week to month
		  replace ilo_job1_lri_ees = r424*(2) if (r423==3 & ilo_job1_ste_aggregate==1)              // Two weeks to month
		  replace ilo_job1_lri_ees = 0 if (r423==6 & ilo_job1_ste_aggregate==1)                     // No cash received
		          lab var ilo_job1_lri_ees "Monthly earnings of employees - main job"
				 
	* Self-employed
	  gen ilo_job1_lri_slf = .
	  	  replace ilo_job1_lri_slf = r428 if (ilo_job1_ste_aggregate==2)                            // Month
	              lab var ilo_job1_lri_slf "Monthly labour related income of self-employed - main job"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_tru') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Following the national definition, the threshold is set at 40 hours usually worked
*            in all jobs.
*          - The usual hours worked in main job is only asked to those answering
*            previously that they actually worked less than 40 hours on the previous week. Right
*            after that question, the reason for working less that 40 hours is asked; here, we 
*            will consider only those who picked the second option (reduction or lack of work).
*            [Note to value: T35:2418]
			
	gen ilo_joball_tru=.
	    replace ilo_joball_tru=1 if (h412a<40 & h412a!=0) & r413==2 & ilo_lfs==1
		replace ilo_joball_tru=. if ilo_lfs!=1
		        lab def tru_lab 1 "Time-related underemployment"
		        lab val ilo_joball_tru tru_lab
		        lab var ilo_joball_tru "Time-related underemployment"
				
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
* Comment: 

	gen ilo_cat_une=.
		replace ilo_cat_une=1 if r410==1 & ilo_lfs==2			                // Previously employed
		replace ilo_cat_une=2 if r410==2 & ilo_lfs==2			                // Seeking first job
		replace ilo_cat_une=3 if ilo_lfs==2 & !inlist(ilo_cat_une,1,2)	        // Unkown
			    lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
			    lab val ilo_cat_une cat_une_lab
			    lab var ilo_cat_une "Category of unemployment"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment:	- Not asked.
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment:

	* PREVIOUS JOB:
 	* 2-digit level	
	gen ilo_preveco_isic4_2digits=indu_code_sec if ilo_lfs==2 & ilo_cat_une==1
	    * labels already defined for main job
        lab val ilo_preveco_isic4_2digits eco_isic4_digits
        lab var ilo_preveco_isic4_2digits "Previous economic activity (ISIC Rev. 4), 2 digit level"

	* 1-digit level
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
	    replace ilo_preveco_isic4=22 if inlist(ilo_preveco_isic4_2digits,0,.) & ilo_cat_une==1
		        * labels already defined for main job		
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
			   * labels already defined for main job					
			   lab val ilo_preveco_aggregate eco_aggr_lab
			   lab var ilo_preveco_aggregate "Previous economic activity (Aggregate)"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu_isco88') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: 
if `Y' <= 2012 {
	* PREVIOUS JOB:
    * 2-digit level		
	gen ilo_prevocu_isco88_2digits=occ_code_sec if ilo_lfs==2 & ilo_cat_une==1
	    * labels already defined for main job
		lab values ilo_prevocu_isco88_2digits ocu88_2digits
		lab var ilo_prevocu_isco88_2digits "Previous occupation (ISCO-88), 2 digit level"

    * 1-digit level
	gen ilo_prevocu_isco88=.
	    replace ilo_prevocu_isco88=11 if ilo_prevocu_isco88_2digits==. & ilo_lfs==2 & ilo_cat_une==1     // Not elsewhere classified
		replace ilo_prevocu_isco88=int(ilo_prevocu_isco88_2digits/10) if ilo_lfs==2 & ilo_cat_une==1     // The rest of the occupations
		replace ilo_prevocu_isco88=10 if (ilo_prevocu_isco88==0 & ilo_lfs==2 & ilo_cat_une==1)           // Armed forces
	            * labels already defined for main job
				lab val ilo_prevocu_isco88 ocu88_1digits
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
		  	    * labels already defined for main job
			    lab val ilo_prevocu_aggregate ocu_aggr_lab
			    lab var ilo_prevocu_aggregate "Previous occupation (Aggregate)"	
		
	* Skill level
	gen ilo_prevocu_skill=.
	    replace ilo_prevocu_skill=1 if ilo_prevocu_isco88==9                   // Low
		replace ilo_prevocu_skill=2 if inlist(ilo_prevocu_isco88,4,5,6,7,8)    // Medium
		replace ilo_prevocu_skill=3 if inlist(ilo_prevocu_isco88,1,2,3)        // High
		replace ilo_prevocu_skill=4 if inlist(ilo_prevocu_isco88,10,11)        // Not elsewhere classified
				* labels already defined for main job
			    lab val ilo_prevocu_skill ocu_skill_lab
			    lab var ilo_prevocu_skill "Previous occupation (Skill level)"

}
if `Y' >= 2013 {	
	* PREVIOUS JOB:
    * 2-digit level		
	gen ilo_prevocu_isco08_2digits=occ_code_sec if ilo_lfs==2 & ilo_cat_une==1
	    * labels already defined for main job
		lab values ilo_prevocu_isco08_2digits ocu08_2digits
		lab var ilo_prevocu_isco08_2digits "Previous occupation (ISCO-08), 2 digit level"

    * 1-digit level
	gen ilo_prevocu_isco08=.
	    replace ilo_prevocu_isco08=11 if ilo_prevocu_isco08_2digits==. & ilo_lfs==2 & ilo_cat_une==1     // Not elsewhere classified
		replace ilo_prevocu_isco08=int(ilo_prevocu_isco08_2digits/10) if ilo_lfs==2 & ilo_cat_une==1     // The rest of the occupations
		replace ilo_prevocu_isco08=10 if (ilo_prevocu_isco08==0 & ilo_lfs==2 & ilo_cat_une==1)           // Armed forces
	            * labels already defined for main job
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
		  	    * labels already defined for main job
			    lab val ilo_prevocu_aggregate ocu_aggr_lab
			    lab var ilo_prevocu_aggregate "Previous occupation (Aggregate)"	
		
	* Skill level
	gen ilo_prevocu_skill=.
	    replace ilo_prevocu_skill=1 if ilo_prevocu_isco08==9                   // Low
		replace ilo_prevocu_skill=2 if inlist(ilo_prevocu_isco08,4,5,6,7,8)    // Medium
		replace ilo_prevocu_skill=3 if inlist(ilo_prevocu_isco08,1,2,3)        // High
		replace ilo_prevocu_skill=4 if inlist(ilo_prevocu_isco08,10,11)        // Not elsewhere classified
				* labels already defined for main job
			    lab val ilo_prevocu_skill ocu_skill_lab
			    lab var ilo_prevocu_skill "Previous occupation (Skill level)"
}				

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
		
