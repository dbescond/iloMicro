* TITLE OF DO FILE: ILO Microdata Preprocessing code template - India, 2011_2012
* DATASET USED: India NSS 2011 2012
* NOTES:
* Authors: ILO / Department of Statistics / DPAU

* Starting Date: 22 August 2017
* Last updated: 08 February 2018
***********************************************************************************************



*******************************************************************
 /* 1.	Set up work directory, file name, variables and function */
*******************************************************************


clear all 

set more off

global path "J:\DPAU\MICRO"
global country "IND"
global source "NSS"
global time "2010"
global inputFile "IND_NSS_2010_ORI.dta"

global inpath "${path}\\${country}\\${source}\\${time}\ORI"
global temppath "${path}\_Admin"
global outpath "${path}\\${country}\\${source}\\${time}"


			
*********************************************************************************************

* Load original dataset

*********************************************************************************************

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
*			Key identifier ('ilo_key')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------


	gen ilo_key=_n
		lab var ilo_key "Key unique identifier per individual"


	/* gen ilo_key=string(FSU_Serial_No)+string(Hamlet_Group_Sub_Block_No)+string(Second_Stage_Stratum_No)+string(Sample_Hhld_No)+string(Person_Serial_No)
			lab var ilo_key "Key unique identifier per individual"		*/


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sample Weight ('ilo_wgt')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: 	For generating subsample-wise estimates based on data of all subrounds taken together, either Subsample-1 households or Subsample-2 households are to be considered at one time. 
* 			Apply final weight (or all-subround multipliers) as follows :
* 			Final weight = MLT/100, if NSS=NSC, final weight=MLT/200 otherwise.
*			There is a seperate document that explains the weighting. 

	gen final_weight=mlt/100 if nss==nsc
		replace final_weight=mlt/200 if nss!=nsc  
	
	
	gen ilo_wgt=final_weight
		lab var ilo_wgt "Sample weight"		

	* svyset [pweight=ilo_wgt] // Setting the sample weight to extrapolate tabulations of the data to the whole poplation

		drop final_weight
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time period ('ilo_time')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: 	This dataset corresponds to 2009-2010
* Only yearly indicators are produced so this is all going to 2010 for ILOSTAT

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
*			Geographical coverage ('ilo_geo')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	destring Sector, replace
	
	gen ilo_geo=.
		replace ilo_geo=1 if Sector==2
		replace ilo_geo=2 if Sector==1
			lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural" 3 "3 - Not elsewhere classified"
			lab val ilo_geo ilo_geo_lab
			lab var ilo_geo "Geographical coverage"
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

		gen ilo_sex=Sex
			label define ilo_sex 1 "Male" 2 "Female"
			label value ilo_sex ilo_sex
			label var ilo_sex "Sex"


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

	gen ilo_age=Age
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

* Comment:	
	
	gen ilo_edu_isced97=.
		replace ilo_edu_isced97=1 if inrange(General_Education,1,4)
		replace ilo_edu_isced97=2 if General_Education==5
		replace ilo_edu_isced97=3 if General_Education==6
		replace ilo_edu_isced97=4 if inlist(General_Education,7,8)
		replace ilo_edu_isced97=5 if General_Education==10
		replace ilo_edu_isced97=6 if General_Education==11
		replace ilo_edu_isced97=7 if General_Education==12
		replace ilo_edu_isced97=8 if General_Education==13
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
*			Education attendance ('ilo_edu_attendance')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: original question asked to people aged between 0 and 29
	
	gen ilo_edu_attendance=.
			replace ilo_edu_attendance=2 if inrange(Status_of_Current_Attendance,1,15) 
			replace ilo_edu_attendance=1 if inrange(Status_of_Current_Attendance,21,43)
			replace ilo_edu_attendance=3 if ilo_edu_attendance==.
				lab def edu_attendance_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
				lab val ilo_edu_attendance edu_attendance_lab
				lab var ilo_edu_attendance "Education (Attendance)"
	
	
	/* recode Status_of_Current_Attendance (1/15=2 "Not attending") (21/43=1 "Attending"), gen (ilo_edu_attendance)
			label var ilo_edu_attendance "Education (Attendance)"
			
			*/
			
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			           Marital status ('ilo_mrts') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 
	
	* Detailed
	gen ilo_mrts_details=.
	    replace ilo_mrts_details=1 if Marital_Status==1                         // Single
		replace ilo_mrts_details=2 if Marital_Status==2                         // Married
		*replace ilo_mrts_details=3 if                                          // Union / cohabiting
		replace ilo_mrts_details=4 if Marital_Status==3                         // Widowed
		replace ilo_mrts_details=5 if Marital_Status==4                         // Divorced / separated
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

* Comment:	NOT POSSIBLE - No variable indicating disability
*			Maybe Usual_Principal_Activity_Status, 95 - not able to work due to disability



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
 				label def ilo_wap_lab 1 "Working age population"
				label val ilo_wap ilo_wap_lab
				label var ilo_wap "Working age population" //15+ population

	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Labour Force Status ('ilo_lfs')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: Given that the section capturing information on the usual activities contains more info than the one taking the last 
			* 7 days as reference period, use the variables contained in the "usual principal activity" block (block 5.1) to define the labour market characteristics
			* However, in green will be left the codes to define the variables for the current activities, in case a future user of the data would prefer to use the latter
			
			* --> The activity status on which a person spent relatively long time (i.e. major time criterion) during the 365 days preceding the date of survey was considered 
					* as the usual principal activity status  

		* --> use precoded variable on the activity status contained in the datafile referring to the principal activity
		
*		Unemployed - pre-categorized: 81 - did not work but was seeking and/or available for work; 
*			Not working but seeking/available for work (or unemployed):
*			81 sought work or did not seek but was available for work (for usual status approach)
*			81 sought work (for current weekly status approach)
*			82 did not seek but was available for work (for current weekly status approach)

	
	gen ilo_lfs=.
		replace ilo_lfs=1 if inrange(Usual_Principal_Activity_Status,11,51) 
		replace ilo_lfs=2 if ilo_lfs!=1 & Usual_Principal_Activity_Status==81
		replace ilo_lfs=3 if !inlist(ilo_lfs,1,2)
			replace ilo_lfs=. if ilo_wap!=1
				label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside the Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status"
	
	
	/*

	gen curr_lfs=.
		replace curr_lfs=1 if inrange(Curr_Week_Act_Status_1,11,72) | Curr_Week_Act_Status_1==98
		replace curr_lfs=2 if curr_lfs!=1 & Curr_Week_Act_Status_1==81
		replace curr_lfs=3 if !inlist(curr_lfs,1,2)
			replace curr_lfs=. if ilo_wap!=1
				label define label_curr_lfs 1 "Employed" 2 "Unemployed" 3 "Outside the Labour Force"
				label value curr_lfs label_curr_lfs
				label var curr_lfs "Labour Force Status"
				 
				*/

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: 	Whether_in_Subsidiary_Activity - 1-yes; 2-no

	gen ilo_mjh=.
		replace ilo_mjh=1 if (Whether_in_Subsidiary_Activity==2 & ilo_lfs==1)
		replace ilo_mjh=2 if (Whether_in_Subsidiary_Activity==1 & ilo_lfs==1)
				replace ilo_mjh=. if ilo_lfs!=1
			lab def lab_ilo_mjh 1 "1 - One job only" 2 "2 - More than one job"
			lab val ilo_mjh lab_ilo_mjh
			lab var ilo_mjh "Multiple job holders"	


/* 
	if current activity considered: 
	
		attribute value "more than one job" to people having any observations related to a subsidiary activity during reference week

	gen curr_mjh=.
		replace curr_mjh=1 if Curr_Week_Act_Status_2==.
		replace curr_mjh=2 if Curr_Week_Act_Status_2!=. & curr_lfs==1
				replace curr_mjh=. if curr_lfs!=1
			lab def lab_curr_mjh 1 "1 - One job only" 2 "2 - More than one job"
			lab val curr_mjh lab_curr_mjh
			lab var curr_mjh "Multiple job holders"	
			
			*/
			

***********************************************************************************************
*			PART 3.1. ECONOMIC CHARACTERISTICS FOR MAIN JOB 
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Status in employment ('ilo_job1_ste')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------


* Comment: 

* Comment: 	Recoding the Usual_Principal_Activity_Status. 	
* Non-Standard codes are the following ones: 
* 41: Worked as casual wage labour: in public works / 51: In other types of work -> Classified as own-account workers as they are casual (and not as employees)
* 81: Did not work but was seeking and/or available for work / 91: Attended educational institution / 92: Attended domestic duties only
* 93: Attended domestic duties and was also engaged in free collection of goods (vegetables, roots, firewood, cattle feed, etc.), sewing, tailoring, weaving, etc. for household use
* 94: Rentiers, pensioners , remittance recipients... / 95: Not able to work due to disability / 97: Others (including begging, prostitution...) 

  * MAIN JOB:
	
	* Detailed categories

	gen ilo_job1_ste_icse93=.
		replace ilo_job1_ste_icse93=1 if (Usual_Principal_Activity_Status==31 & ilo_lfs==1)
		replace ilo_job1_ste_icse93=2 if (Usual_Principal_Activity_Status==12 & ilo_lfs==1)
		replace ilo_job1_ste_icse93=3 if (inlist(Usual_Principal_Activity_Status,11,41,51) & ilo_lfs==1)
		/*replace ilo_job1_ste_icse93=4 if */
		replace ilo_job1_ste_icse93=5 if (Usual_Principal_Activity_Status==21 & ilo_lfs==1)
		replace ilo_job1_ste_icse93=6 if ilo_job1_ste_icse93==. & ilo_lfs==1
				replace ilo_job1_ste_icse93=. if ilo_lfs!=1
			label def label_ilo_ste_icse93 1 "1 - Employees" 2 "2 - Employers" 3 "3 - Own-account workers" 4 "4 - Members of producers cooperatives"  ///
											5 "5 - Contributing family workers" 6 "6 - Workers not classifiable by status"
			label value ilo_job1_ste_icse93 label_ilo_ste_icse93
			label var ilo_job1_ste_icse93 "Status in employment (ICSE 93)"

	* Aggregated categories 
		
		gen ilo_job1_ste_aggregate=.
			replace ilo_job1_ste_aggregate=1 if (ilo_job1_ste_icse93==1)			// Employees
			replace ilo_job1_ste_aggregate=2 if (inrange(ilo_job1_ste_icse93,2,5))	// Self-employed
			replace ilo_job1_ste_aggregate=3 if (ilo_job1_ste_icse93==6)			// Not elsewhere classified
				lab def ste_aggr_lab 1 "1 - Employees" 2 "2 - Self-employed" 3 "3 - Not elsewhere classified"
				lab val ilo_job1_ste_aggregate ste_aggr_lab
				label var ilo_job1_ste_aggregate "Status in employment (Aggregate)"  



/* if current activity considered: 

use the same variable that was used to identify people in employment, as it contains information on the status in employment


	gen curr_job1_ste_icse93=.
		replace curr_job1_ste_icse93=1 if inlist(Curr_Week_Act_Status_1,31,71,72)
		replace curr_job1_ste_icse93=2 if Curr_Week_Act_Status_1==12
		replace curr_job1_ste_icse93=3 if inlist(Curr_Week_Act_Status_1,11,41,42,51)
		/*replace curr_job1_ste_icse93=4 if */
		replace curr_job1_ste_icse93=5 if inlist(Curr_Week_Act_Status_1,21,61,62)
		replace curr_job1_ste_icse93=6 if curr_job1_ste_icse93==. & curr_lfs==1
				replace curr_job1_ste_icse93=. if curr_lfs!=1
			label def label_curr_ste_icse93 1 "1 - Employees" 2 "2 - Employers" 3 "3 - Own-account workers" 4 "4 - Members of producers cooperatives"  ///
											5 "5 - Contributing family workers" 6 "6 - Workers not classifiable by status"
			label value curr_job1_ste_icse93 curr_job1_ste_icse93
			label var curr_job1_ste_icse93 "Status in employment (ICSE 93)"

	* Aggregated categories 
		
		gen curr_job1_ste_aggregate=.
			replace curr_job1_ste_aggregate=1 if (curr_job1_ste_icse93==1)			// Employees
			replace curr_job1_ste_aggregate=2 if (inrange(curr_job1_ste_icse93,2,5))	// Self-employed
			replace curr_job1_ste_aggregate=3 if (curr_job1_ste_icse93==6)			// Not elsewhere classified
				lab def ste_aggr_lab 1 "1 - Employees" 2 "2 - Self-employed" 3 "3 - Not elsewhere classified"
				lab val curr_job1_ste_aggregate ste_aggr_lab
				label var curr_job1_ste_aggregate "Status in employment (Aggregate)"  


*/

				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

/* Classification used: ISIC Rev. 3.1 */

 

	
	gen indu_code_prim=int(Usual_Principal_Activity_NIC2004/1000) if ilo_lfs==1
	
	gen indu_code_sec=int(Usual_SubsidiaryActivity_NIC2004/1000) if ilo_lfs==1 & ilo_mjh==2
		
		
/*

	if current activity considered:
			
	gen indu_code_prim=int(Curr_Week_Act_NIC_2004_1/1000) if curr_lfs==1
	
	gen indu_code_sec=int(Curr_Week_Act_NIC_2004_2/1000) if curr_lfs==1 & curr_mjh==2
	
		*/
			
	* Primary activity
		
		gen ilo_job1_eco_isic3_2digits=indu_code_prim
		
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
				
			
		* Secondary activity
		
		gen ilo_job2_eco_isic3_2digits=indu_code_sec
		
                * labels already defined for main job
		        lab val ilo_job2_eco_isic3_2digits eco_isic3_2digits
                lab var ilo_job2_eco_isic3_2digits "Economic activity (ISIC Rev. 3.1), 2 digits level - second job"
		
	* One digit level
	
		* aggregation done according to information on page 43 of the following document: https://www.bundesbank.de/Redaktion/EN/Downloads/Service/Meldewesen/Bankenstatistik/Kundensystematik/isic_rev_4.pdf?__blob=publicationFile
	
		* Primary activity
		
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
				
		* Secondary activity
		
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
			replace ilo_job2_eco_isic3=18 if ilo_job2_eco_isic3==. & ilo_lfs==1
                * labels already defined for main job
		        lab val ilo_job2_eco_isic3 eco_isic3_1digit
			    lab var ilo_job2_eco_isic3 "Economic activity (ISIC Rev. 3.1) - second job"
		
		
	* Now do the classification on an aggregate level
	
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
				lab var ilo_job1_eco_aggregate "Economic activity (Aggregate) - main job"
				
		* Secondary activity
		
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
	
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_job1_ocu_isco08')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: NCO-04 is developed in line with ISCO-88

	
	foreach var of varlist Usual_Principal_Activity_NCO2004 Usual_SubsidiaryActivity_NCO2004 {
	
	 replace `var'="" if  substr(`var',1,1)=="X" // as these values correspond to inadequately reported occupations or no occupation reported
		destring `var', replace
		
		}
		
	gen occ_code_prim=int(Usual_Principal_Activity_NCO2004/10) if ilo_lfs==1
	
	gen occ_code_sec=int(Usual_SubsidiaryActivity_NCO2004/10) if ilo_lfs==1 & ilo_mjh==2
	
	
	/*
		
	--> if current activity considered
	
	* apply change immediately to variables capturing information on occupation for first and second job
		
		foreach num of numlist 1/2 {

	 replace Curr_Week_Act_NCO_2004_`num'="" if  substr(Curr_Week_Act_NCO_2004_`num',1,1)=="X" // as these values correspond to inadequately reported occupations or no occupation reported
		destring Curr_Week_Act_NCO_2004_`num', replace
		
		}
			
	gen occ_code_prim=int(Curr_Week_Act_NCO_2004_1/10) if ilo_lfs==1
	gen occ_code_sec=int(Curr_Week_Act_NCO_2004_2/10) if ilo_lfs==1 & ilo_mjh==2
	
	*/
	
	
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
	
	gen occ_code_prim_1dig=int(occ_code_prim/10) if ilo_lfs==1
	gen occ_code_sec_1dig=int(occ_code_sec/10) if ilo_lfs==1 & ilo_mjh==2
	
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
*			Institutional sector of economic activities ('ilo_job1_ins_sector')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

* Comment:	Enterprise_Type
*			NOT POSSIBLE - even though a variable exists, there is a category called "Public/Private limited company" which doesn't allow for differentiating and aggregating to the 2 categories 
*			private and public


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job1_job_time')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			

* Comment: use pre-defined variable (working hours not included in dataset)

		gen ilo_job1_job_time=.
			replace ilo_job1_job_time=1 if (Full_Time_or_Part_Time==2 & ilo_lfs==1) 
			replace ilo_job1_job_time=2 if (Full_Time_or_Part_Time==1 & ilo_lfs==1)
			replace ilo_job1_job_time=3 if ilo_job1_job_time==. & ilo_lfs==1
				lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
				lab val ilo_job1_job_time job_time_lab
				lab var ilo_job1_job_time "Job (Working time arrangement) - Main job"	
	
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job1_job_contract')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
		
* Comment:	Not possible


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Formal / Informal Economy ('ilo_job1_ife_prod' 'ilo_job1_ife_nature') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			


	* 1) Unit of production - Formal / Informal Sector

* Comment:	National definition:		Legal status - Proprietary and partnership firms in India do not have any separate legal status other than that of the owners. Thus such units are considered 
*										as un-incorporated.
*										Size of employment - The second criteria employed for the identification of informal sector was employment size of fewer than 10 workers. The size criteria 
*										was decided after analysing the threshold limits of various labour laws, productivity differentials of establishments with different employment sizes and 
*										development policies.
*										Maintenance of complete accounts criteria is implicit as there is no requirement of private establishments employing less than 10 workers to maintain such 
*										accounts.
*										Registration - The criterion of registration was not used as there were multiple registrations of firms and there was no single registration system covering 
*										all firms and giving separate legal status to all the registered units.
*		
*			Casual worker is always informal - Usual_Principal_Activity_Status==41 | Usual_Principal_Activity_Status==51
*
*			In the agricultural sector, industry groups 011 (growing of non-perennial crops), 012 (growing of perennial crops), 013 (plant propagation) and 015 (mixed farming) of NIC â€“ 2008 were 
*			excluded for collection of information on characteristics of enterprises and conditions of employment. Therefore, the industry groups/ divisions 014, 016, 017, 02 and 03 cover the 
*			agricultural sector excluding growing of crops, plant propagation, combined production of crops and animals without a specialized production of crops or animals 
*			(henceforth referred to as AGEGC activities).
*			
*			In NSS 61st round (July 2004-June 2005), along with information on different characteristics of the enterprises (viz. location of the workplace, type of enterprise, number of workers in 
*			the enterprise, whether enterprise uses electricity) in which usually employed persons worked, particulars on conditions of employment (viz. type of job contract, whether eligible for 
*			paid leave, availability of social security benefits, method of payment) for the employees (regular wage/salaried employees and casual labourers) were also collected. 
*			In 68th (July 2011-June 2012) round, information on characteristics of enterprises for all usual status workers and conditions of employment for the employees was collected for the same 
*			set of items as those of 61st round. The coverage of activities in 61st and 68th rounds was non-agriculture sector and AGEGC activities in agriculture sector.
*
*	 Variable Usual_PrincipalActivity_NIC2008 - note that there is a skip pattern after this questions excluding groups 011, 012, 013, 015 (NIC-2008)
*		

	* Useful questions: Enterprise_Type: Institutional sector --> use as a proxy the variable Enterprise_Type (in order to identify the public and the household sector)
					*	[no info]: Destination of production
					*	[no info]: Bookkeeping
					*	[no info]: Registration
					*	Location_of_Workspace: Location of workplace
					*	No_of_Workers_in_Enterprise: Size 
					*	Social_Security_Benefits & Eligible_for_Paid_Leave: Social security
												
					
	* Social security coverage
	
		gen soc_sec_cov=inlist(Social_Security_Benefits,1,4,5,7) | ( !inlist(Social_Security_Benefits,1,4,5,7) & Eligible_for_Paid_Leave==1)
	
			gen ilo_job1_ife_prod=.
				replace ilo_job1_ife_prod=1 if !inlist(Enterprise_Type,5,6,7,8) & ((ilo_job1_ste_aggregate==1 & soc_sec_cov!=1) | ilo_job1_ste_aggregate!=1) & ///
						(!inlist(Location_of_Workspace,14,16,24,26) | (inlist(Location_of_Workspace,14,16,24,26) & !inlist(No_of_Workers_in_Enterprise,2,3,4)))
				replace ilo_job1_ife_prod=2 if inlist(Enterprise_Type,5,6,7) | (!inlist(Enterprise_Type,5,6,7,8) & ilo_job1_ste_aggregate==1 & soc_sec_cov==1) | ///
						(!inlist(Enterprise_Type,5,6,7,8) & ((ilo_job1_ste_aggregate==1 & soc_sec_cov!=1) | ilo_job1_ste_aggregate!=1) & inlist(Location_of_Workspace,14,16,24,26) & inlist(No_of_Workers_in_Enterprise,2,3,4))
				replace ilo_job1_ife_prod=3 if Enterprise_Type==8 | ilo_job1_eco_isic3_2digits==95 | ilo_job1_ocu_isco88_2digits==62
				replace ilo_job1_ife_prod=4 if ilo_job1_ife_prod==. & ilo_lfs==1
					replace ilo_job1_ife_prod=. if ilo_lfs!=1
						lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 4 "4 - Not elsewhere classified"
						lab val ilo_job1_ife_prod ilo_ife_prod_lab
						lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"




/*

	old definition: 
		gen social_security=.
			replace social_security=1 if (Eligible_for_Paid_Leave==1 & inrange(Social_Security_Benefits,1,7) & ilo_lfs==1)

		gen ilo_job1_ife_prod=.
			
			replace ilo_job1_ife_prod=2 if (inlist(Enterprise_Type,5,6,7) | (inlist(Location_of_Workspace,14,16,24,26) & inlist(No_of_Workers_in_Enterprise,2,3,4)) | social_security==1) & ilo_lfs==1
				
			replace ilo_job1_ife_prod=3 if (Enterprise_Type==8 | (inlist(Location_of_Workspace,15,25) & Enterprise_Type!=5 & Enterprise_Type!=6 & Enterprise_Type!=7)) & ilo_lfs==1
				
			replace ilo_job1_ife_prod=1 if (ilo_job1_ife_prod!=2 & ilo_job1_ife_prod!=3 & ilo_lfs==1)

						lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 
						lab val ilo_job1_ife_prod ilo_ife_prod_lab
						lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"

		*/

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Formal / Informal Economy - Nature of employment ('ilo_job1_ife_nature') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

					* 2) Nature of job - Formal / Informal Job
					
					
	gen ilo_job1_ife_nature=.
		replace ilo_job1_ife_nature=1 if ilo_job1_ste_icse93==5 | (inlist(ilo_job1_ste_icse93,1,6) & soc_sec_cov!=1) | (inlist(ilo_job1_ste_icse93,2,3,4) & inlist(ilo_job1_ife_prod,1,3))
		replace ilo_job1_ife_nature=2 if (inlist(ilo_job1_ste_icse93,1,6) & soc_sec_cov==1) | (inlist(ilo_job1_ste_icse93,2,3,4) & ilo_job1_ife_prod==2)
		replace ilo_job1_ife_nature=. if ilo_lfs!=1
			lab def ife_nature_lab 1 "1 - Persons with informal main job" 2 "2 - Persons with formal main job"
			lab val ilo_job1_ife_nature ife_nature_lab
			lab var ilo_job1_ife_nature "Informal / Formal Economy (Nature of job)"
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Hours of work ('ilo_job1_how')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
           
* Comment: 	NOT POSSIBLE - no variable indicating working time available in the dataset
				

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Monthly labour related income ('ilo_joball_lri')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
           
* Comment: 	
			
		
***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_joball_tru')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			


* Comment: 	 Available_for_Additional_Work ("seeking or available for additional work") set to 1, 2 ('Yes')
*			 hours actually worked > 35 - not available
* 			 NOT POSSIBLE due to the lack of variable for working time


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupational injury ('ilo_joball_inj')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
		
	
* Comment: 	NOT POSSIBLE - No information available in the questionnaire
		
		

***********************************************************************************************
*			PART 3.3. UNEMPLOYMENT: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Category of unemployment ('ilo_cat_une')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	
* Comment: 	

	* given that the section 6 where this info is contained is not using the same reference period as the rest of 
		* the variables used for the definition of the "ilo_*" variables, the codes are being left in green in order 
		* to use them along with the other "curr_" variables
	
/*

	gen curr_cat_une=.
		replace curr_cat_une=1 if Whether_Ever_Worked==1
		replace curr_cat_une=2 if Whether_Ever_Worked==2
		replace curr_cat_une=3 if curr_lfs==2 & curr_cat_une==.
		replace curr_cat_une=. if curr_lfs!=2
			lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
			lab val curr_cat_une cat_une_lab
			lab var curr_cat_une "Category of unemployment"
			
			*/

	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

* Comment: 	* variable contained in section 5.1 (used for defining the rest of ilo_* variables) contains only some information on job seeking activities during the last 365 days 
		* therefore, it is not being used for defining ilo_dur_details
		
		* however, if section 5.3 considered (current activity), use the code below to define. Please note that the option "24 months or more" cannot be defined

/*
 if section considering current activity being used:
	gen ilo_dur_details=.
		replace ilo_dur_details=1 if inlist(Duration_Spell_of_Unemployment,1,2,3)
		replace ilo_dur_details=2 if inlist(Duration_Spell_of_Unemployment,4,5)
		replace ilo_dur_details=3 if Duration_Spell_of_Unemployment==6
		replace ilo_dur_details=4 if Duration_Spell_of_Unemployment==7
		replace ilo_dur_details=5 if Duration_Spell_of_Unemployment==8
		/* replace ilo_dur_details=6 if */
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
			
			*/



* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment: 	

	* given that the section 6 where this info is contained is not using the same reference period as the rest of 
		* the variables used for the definition of the "ilo_*" variables, the codes are being left in green in order 
		* to use them along with the other "curr_" variables 
/*
	gen preveco_cod=Last_Employment_NIC_2004 if curr_lfs==2 & Last_Employment_NIC_2004!=0
	
		gen curr_preveco_isic3=.
			replace curr_preveco_isic3=1 if inrange(preveco_cod,1,2)
			replace curr_preveco_isic3=2 if preveco_cod==5
			replace curr_preveco_isic3=3 if inrange(preveco_cod,10,14)
			replace curr_preveco_isic3=4 if inrange(preveco_cod,15,37)
			replace curr_preveco_isic3=5 if inrange(preveco_cod,40,41)
			replace curr_preveco_isic3=6 if preveco_cod==45
			replace curr_preveco_isic3=7 if inrange(preveco_cod,50,52)
			replace curr_preveco_isic3=8 if preveco_cod==55
			replace curr_preveco_isic3=9 if inrange(preveco_cod,60,64)
			replace curr_preveco_isic3=10 if inrange(preveco_cod,65,67)
			replace curr_preveco_isic3=11 if inrange(preveco_cod,70,74)
			replace curr_preveco_isic3=12 if preveco_cod==75
			replace curr_preveco_isic3=13 if preveco_cod==80
			replace curr_preveco_isic3=14 if preveco_cod==85
			replace curr_preveco_isic3=15 if inrange(preveco_cod,90,93)
			replace curr_preveco_isic3=16 if preveco_cod==95
			replace curr_preveco_isic3=17 if preveco_cod==99
			replace curr_preveco_isic3=18 if curr_preveco_isic3==. & curr_cat_une==1 & curr_lfs==2
				lab val curr_preveco_isic3 isic3
				lab var curr_preveco_isic3 "Previous economic activity (ISIC Rev. 3.1)"
				
	* Now do the classification on an aggregate level
		
		gen curr_preveco_aggregate=.
			replace curr_preveco_aggregate=1 if inlist(curr_preveco_isic3,1,2)
			replace curr_preveco_aggregate=2 if curr_preveco_isic3==4
			replace curr_preveco_aggregate=3 if curr_preveco_isic3==6
			replace curr_preveco_aggregate=4 if inlist(curr_preveco_isic3,3,5)
			replace curr_preveco_aggregate=5 if inrange(curr_preveco_isic3,7,11)
			replace curr_preveco_aggregate=6 if inrange(curr_preveco_isic3,12,17)
			replace curr_preveco_aggregate=7 if curr_preveco_isic3==18
						* value label already defined
				lab val curr_preveco_aggregate eco_aggr_lab
				lab var curr_preveco_aggregate "Previous economic activity (Aggregate)"


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('curr_prevocu')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

* Comment: 	

* given that the section 6 where this info is contained is not using the same reference period as the rest of 
		* the variables used for the definition of the "ilo_*" variables, the codes are being left in green in order 
		* to use them along with the other "curr_" variables 


	replace Last_Employment_NCO_2004="" if substr(Last_Employment_NCO_2004,1,1)=="X"
	
		destring Last_Employment_NCO_2004, replace

	gen prevocu_cod=int(Last_Employment_NCO_2004/100) if curr_lfs==2 & Last_Employment_NCO_2004!=0
		* as zero corresponds to missing/not replied

	gen curr_prevocu_isco88=prevocu_cod
			replace curr_prevocu_isco88=10 if curr_prevocu_isco88==0
			replace curr_prevocu_isco88=11 if curr_prevocu_isco88==. & curr_cat_une==1 & curr_lfs==2
			* value label already defined
			lab val curr_prevocu_isco88 isco88_1dig_lab
			lab var curr_prevocu_isco88 "Previous occupation (ISCO-88)"	
			
	* Aggregate level
	
		* Primary occupation
	
		gen curr_prevocu_aggregate=.
			replace curr_prevocu_aggregate=1 if inrange(curr_prevocu_isco88,1,3)
			replace curr_prevocu_aggregate=2 if inlist(curr_prevocu_isco88,4,5)
			replace curr_prevocu_aggregate=3 if inlist(curr_prevocu_isco88,6,7)
			replace curr_prevocu_aggregate=4 if curr_prevocu_isco88==8
			replace curr_prevocu_aggregate=5 if curr_prevocu_isco88==9
			replace curr_prevocu_aggregate=6 if curr_prevocu_isco88==10
			replace curr_prevocu_aggregate=7 if curr_prevocu_isco88==11
				* value label already defined
				lab val curr_prevocu_aggregate ocu_aggr_lab
				lab var curr_prevocu_aggregate "Previous occupation (Aggregate)"
				
						
	* Skill level
	
		* Primary occupation
	
		gen curr_prevocu_skill=.
			replace curr_prevocu_skill=1 if curr_prevocu_isco88==9
			replace curr_prevocu_skill=2 if inlist(curr_prevocu_isco88,4,5,6,7,8)
			replace curr_prevocu_skill=3 if inlist(curr_prevocu_isco88,1,2,3)
			replace curr_prevocu_skill=4 if inlist(curr_prevocu_isco88,10,11)
					* value label already defined
				lab val curr_prevocu_skill ocu_skill_lab
				lab var curr_prevocu_skill "Previous occupation (Skill level)"
				
				*/


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			General social protection ('ilo_gsp_unschemes')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
	
* Comment: 	NOT POSSIBLE - No information available in the questionnaire

	
	
***********************************************************************************************
*			PART 3.4. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
	
* Comment: 	NOT POSSIBLE - Seeking and available for work do not exist as separate variables


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reason for not seeking job ('ilo_olf_reason')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

* Comment: 

	* given that no labour market reasons appear in the questionnaire, do not define the variable

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seeker ('ilo_dis')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

* Comment: 	NOT POSSIBLE - Seeking and available for work do not exist as separate variables in the dataset and no variable for reason for not seeking 
		* also, no labour market reason indicated 
			
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training ('ilo_neet')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

* Comment: Status_of_Current_Attendance ("attending education'") set to 1 to 15 ('Currently not attending')

		gen ilo_neet=.
			replace ilo_neet=1 if (ilo_age_aggregate==2 & ilo_lfs!=1 & ilo_edu_attendance==2) 

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

 
	drop   indu_code* occ_code* soc_sec_cov
	
	drop if ilo_wgt==.


* 1 - Full dataset with original variables and ILO ones
	
	cd "$outpath"

        compress
		save ${country}_${source}_${time}_FULL, replace


* 2 - Dataset with only 'ILO' variables
	
		keep ilo*
		save ${country}_${source}_${time}_ILO, replace

