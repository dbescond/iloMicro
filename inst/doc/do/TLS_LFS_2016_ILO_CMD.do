* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Timor-Leste 2016
* DATASET USED: Timor-Leste LFS 2016
* NOTES: 
* Authors: ILO / Department of Statistics / DPAU
* Starting Date: 03 Abril 2018
* Last updated: 03 Abril 2018
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
global country "TLS"
global source "LFS"
global time "2016"
global inputFile "TLS LFS&CLS 2016 indiv"
global inpath "${path}\\${country}\\${source}\\${time}\ORI"
global temppath "${path}\_Admin"
global outpath "${path}\\${country}\\${source}\\${time}"

			
*********************************************************************************************

* Load original dataset

*********************************************************************************************

cd "$inpath"
	use "$inputFile", clear
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

	* Year 
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

	gen ilo_wgt=weights
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
		replace ilo_geo=1 if urban==1
		replace ilo_geo=2 if urban==2
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
	    replace ilo_sex=1 if hc5==1
		replace ilo_sex=2 if hc5==2 
		        lab def ilo_sex_lab 1 "1 - Male" 2 "2 - Female"
		        lab var ilo_sex "Sex"
		        lab val ilo_sex ilo_sex_lab

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: 

	gen ilo_age=hc2
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
			lab def age_by5_lab 1 "0-4" 2 "5-9" 3 "10-14" 4 "15-19" 5 "20-24" 6 "25-29" 7 "30-34" 8 "35-39" ///
								9 "40-44" 10 "45-49" 11 "50-54" 12 "55-59" 13 "60-64" 14 "65+"
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
*			Education ('ilo_edu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Question only asked to those aged 10 years old or more, the rest are classified 
*            under "not elsewhere classified"
*          - ISCED 97 mapping: based on the UNESCO mapping available on http://uis.unesco.org/en/isced-mappings

    gen ilo_edu_isced97=.
		replace ilo_edu_isced97=1 if h6_high_level==9
		replace ilo_edu_isced97=2 if h6_high_level==1
		replace ilo_edu_isced97=3 if h6_high_level==2
		replace ilo_edu_isced97=4 if h6_high_level==3
		replace ilo_edu_isced97=5 if inlist(h6_high_level,4,5)
		*replace ilo_edu_isced97=6 if 
		replace ilo_edu_isced97=7 if inlist(h6_high_level,6,7,8)
		*replace ilo_edu_isced97=8 if 
		replace ilo_edu_isced97=9 if ilo_edu_isced97==.
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
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education attendance ('ilo_edu_attendance') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Question only asked to those aged 6 years old or more; therefore, those below 6
*            are classified under "not elsewhere classified"

gen ilo_edu_attendance=.
			replace ilo_edu_attendance=1 if h7_schooling==1                     // Yes
			replace ilo_edu_attendance=2 if h7_schooling==2                     // No
			replace ilo_edu_attendance=3 if ilo_edu_attendance==.               // Not elsewhere classified
				    lab def edu_attendance_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified"
				    lab val ilo_edu_attendance edu_attendance_lab
				    lab var ilo_edu_attendance "Education (Attendance)"
					
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Disability status ('ilo_dsb') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment: Not available
					
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
* Comment: 15+ population

	gen ilo_wap=.
		replace ilo_wap=1 if ilo_age>=15 & ilo_age!=.
			label def ilo_wap_lab 1 "Working age population"
			label val ilo_wap ilo_wap_lab
			label var ilo_wap "Working age population"
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Labour Force Status ('ilo_lfs')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Employment follows the identification of employed persons presented on the 
*            natinal report flowcharts (Annex C).
*          - Employment includes subsistence farmers because it is impossible to isolate it 
*            from the original question (note to qtable-> S9:3359)

   gen ilo_lfs=.
	   replace ilo_lfs=1 if (p2q1==1 | p2q2==1) & (p2q3==2) & ilo_wap==1                                                         // Employed
	   replace ilo_lfs=1 if (p2q1==1 | p2q2==1) & p2q3==1 & inlist(p2q4,2,3) & ilo_wap==1                                        // Employed
	   replace ilo_lfs=1 if (p2q1==1 | p2q2==1) & p2q3==1 & p2q4==1 & p2q5==1 & inlist(p2q6,1,2,3,6,7,10,11,12,13) & ilo_wap==1  // Employed
	   replace ilo_lfs=1 if (p2q1==1 | p2q2==1) & p2q3==1 & p2q4==1 & p2q5==1 & p2q6==9 & p2q8==1 & p2q9==1 & ilo_wap==1         // Employed
	   replace ilo_lfs=1 if (p2q1==1 | p2q2==1) & p2q3==1 & p2q4==1 & p2q5==1 & inlist(p2q6,4,5) & p2q7==1 & ilo_wap==1          // Employed
	   replace ilo_lfs=1 if (p2q2==2) & p2q5==1 & inlist(p2q6,1,2,3,6,7,10,11,12,13) & ilo_wap==1                                // Employed
	   replace ilo_lfs=1 if (p2q2==2) & p2q5==1 & p2q6==9 & p2q8==1 & p2q9==1 & ilo_wap==1                                       // Employed
	   replace ilo_lfs=1 if (p2q2==2) & p2q5==1 & inlist(p2q6,4,5) & p2q7==1 & ilo_wap==1                                        // Employed
	   replace ilo_lfs=2 if ilo_lfs!=1 & (p7q59a==1 | p7q59b==1) & (p7q65==1 | p7q66==1) & ilo_wap==1                            // Unemployed (not in emp & seeking & available)
	   replace ilo_lfs=2 if ilo_lfs!=1 & (p7q59a!=1 & p7q59b!=1) & inlist(p7q62,1,2) & (p7q65==1 | p7q66==1) & ilo_wap==1        // Unemployed (not in emp & not seeking & future starters & available)	   
	   replace ilo_lfs=3 if !inlist(ilo_lfs,1,2) & ilo_wap==1                                                                    // Outside the labour market
	   		   label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside the Labour Force"
			   label value ilo_lfs label_ilo_lfs
			   label var ilo_lfs "Labour Force Status"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Definition of secondary job follows the same structure as for main job

    gen ilo_mjh=.
	    replace ilo_mjh=2 if p4q28==1 & p4q29!=1 & ilo_lfs==1                         // Secondary job/activity done outside their own agricultural land (or HH member)
		replace ilo_mjh=2 if p4q28==1 & p4q29==1 & inlist(p4q30,2,3) & ilo_lfs==1     // Secondary job/activity done on his/her own agricultural land and mostly for sale/barter
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
*Comment: - those on military service are classified under "workers not classifiable by status"

  * MAIN JOB:
	
	* Detailed categories:
	gen ilo_job1_ste_icse93=.
		replace ilo_job1_ste_icse93=1 if p3q10==1 & ilo_lfs==1 	                // Employees
		replace ilo_job1_ste_icse93=2 if p3q10==2 & ilo_lfs==1	                // Employers
		replace ilo_job1_ste_icse93=3 if p3q10==3 & ilo_lfs==1                  // Own-account workers
		replace ilo_job1_ste_icse93=4 if p3q10==5 & ilo_lfs==1                  // Members of producersâ€™ cooperatives
		replace ilo_job1_ste_icse93=5 if p3q10==4 & ilo_lfs==1     	            // Contributing family workers
		replace ilo_job1_ste_icse93=6 if inlist(p3q10,6,.) & ilo_lfs==1         // Not classifiable
			    label def label_ilo_ste_icse93 1 "1 - Employees" 2 "2 - Employers" 3 "3 - Own-account workers"                ///
				    						   4 "4 - Members of producers cooperatives" 5 "5 - Contributing family workers"  ///
					    					   6 "6 - Workers not classifiable by status"
			    label val ilo_job1_ste_icse93 label_ilo_ste_icse93
			    label var ilo_job1_ste_icse93 "Status in employment (ICSE 93) in main job"

	* Aggregate categories 
	gen ilo_job1_ste_aggregate=.
		replace ilo_job1_ste_aggregate=1 if ilo_job1_ste_icse93==1				// Employees
		replace ilo_job1_ste_aggregate=2 if inrange(ilo_job1_ste_icse93,2,5)	// Self-employed
		replace ilo_job1_ste_aggregate=3 if ilo_job1_ste_icse93==6				// Not elsewhere classified
	    		lab def ste_aggr_lab 1 "1 - Employees" 2 "2 - Self-employed" 3 "3 - Not elsewhere classified"
				lab val ilo_job1_ste_aggregate ste_aggr_lab
				label var ilo_job1_ste_aggregate "Status in employment (Aggregate) in main job"  

				
  * SECOND JOB:
	
	* Detailed categories:
	gen ilo_job2_ste_icse93=.
		replace ilo_job2_ste_icse93=1 if p4q31==1 & ilo_mjh==2 	                // Employees
		replace ilo_job2_ste_icse93=2 if p4q31==2 & ilo_mjh==2	                // Employers
		replace ilo_job2_ste_icse93=3 if p4q31==3 & ilo_mjh==2                  // Own-account workers
		replace ilo_job2_ste_icse93=4 if p4q31==5 & ilo_mjh==2                  // Members of producersâ€™ cooperatives
		replace ilo_job2_ste_icse93=5 if p4q31==4 & ilo_mjh==2     	            // Contributing family workers
		replace ilo_job2_ste_icse93=6 if p4q31==. & ilo_mjh==2                  // Not classifiable
				label val ilo_job2_ste_icse93 label_ilo_ste_icse93
				label var ilo_job2_ste_icse93 "Status in employment (ICSE 93) in secondary job"

	* Aggregate categories 
	gen ilo_job2_ste_aggregate=.
		replace ilo_job2_ste_aggregate=1 if ilo_job2_ste_icse93==1				// Employees
		replace ilo_job2_ste_aggregate=2 if inrange(ilo_job2_ste_icse93,2,5)	// Self-employed
		replace ilo_job2_ste_aggregate=3 if ilo_job2_ste_icse93==6				// Not elsewhere classified
			    lab val ilo_job2_ste_aggregate ste_aggr_lab
			    label var ilo_job2_ste_aggregate "Status in employment (Aggregate) in secondary job"  
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - original classification follows ISIC Rev.4 at four digit-level

    * Import value labels
    append using `labels', gen (lab)
    * Use value label from this variable, afterwards drop everything related to this append


    * MAIN JOB
    * Two digit-level
    gen indu_code_prim=int(p3q22isi/100) if ilo_lfs==1  
  
    gen ilo_job1_eco_isic4_2digits=indu_code_prim if ilo_lfs==1
	    lab values ilo_job1_eco_isic4_2digits isic4_2digits
	    lab var ilo_job1_eco_isic4_2digits "Economic activity (ISIC Rev. 4), 2 digit level in main job"

    * One digit-level
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
				lab val ilo_job1_eco_isic4 isic4
				lab var ilo_job1_eco_isic4 "Economic activity (ISIC Rev. 4) in main job"
				
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
				lab var ilo_job1_eco_aggregate "Economic activity (Aggregate) in main job"
				
    * SECOND JOB
	* Two digit-level
    gen indu_code_sec=int(p4q43isi/100) if ilo_mjh==2  
  
	gen ilo_job2_eco_isic4_2digits=indu_code_sec if ilo_mjh==2
		lab values ilo_job2_eco_isic4_2digits isic4_2digits
		lab var ilo_job2_eco_isic4_2digits "Economic activity (ISIC Rev. 4), 2 digit level in secondary job"
			 
    * One digit-level
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
		replace ilo_job2_eco_isic4=22 if ilo_job2_eco_isic4==. & ilo_mjh==2
				lab val ilo_job2_eco_isic4 isic4
				lab var ilo_job2_eco_isic4 "Economic activity (ISIC Rev. 4) in secondary job"
				
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
				lab var ilo_job2_eco_aggregate "Economic activity (Aggregate) in secondary job"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_job1_ocu_isco08') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment: - original classification follows ISCO-08 at four digit-level

   * MAIN JOB
   * Two digit-level
   gen occ_code_prim=int(isco/100) if ilo_lfs==1 
   
   gen ilo_job1_ocu_isco08_2digits=occ_code_prim if ilo_lfs==1
	   lab values ilo_job1_ocu_isco08_2digits isco08_2digits
	   lab var ilo_job1_ocu_isco08_2digits "Occupation (ISCO-08), 2 digit level in main job"

			
    * One digit-level
	gen ilo_job1_ocu_isco08=.
	    replace ilo_job1_ocu_isco08=11 if inlist(ilo_job1_ocu_isco08_2digits,0,10,19,29,30,49,50,80,84,85,86,90,97,99,.) & ilo_lfs==1   //Not elsewhere classified
		replace ilo_job1_ocu_isco08=int(ilo_job1_ocu_isco08_2digits/10) if (ilo_job1_ocu_isco08==. & ilo_lfs==1)                        //The rest of the occupations
		replace ilo_job1_ocu_isco08=10 if (ilo_job1_ocu_isco08==0 & ilo_lfs==1)                                                         //Armed forces
				lab val ilo_job1_ocu_isco08 isco08
				lab var ilo_job1_ocu_isco08 "Occupation (ISCO-08) in main job"
				
    * Aggregate level
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
				lab var ilo_job1_ocu_aggregate "Occupation (Aggregate) in main job"
				
    * Skill level				
    gen ilo_job1_ocu_skill=.
	    replace ilo_job1_ocu_skill=1 if ilo_job1_ocu_isco08==9                   // Low
		replace ilo_job1_ocu_skill=2 if inlist(ilo_job1_ocu_isco08,4,5,6,7,8)    // Medium
		replace ilo_job1_ocu_skill=3 if inlist(ilo_job1_ocu_isco08,1,2,3)        // High
		replace ilo_job1_ocu_skill=4 if inlist(ilo_job1_ocu_isco08,10,11)        // Not elsewhere classified
				lab def ocu_skill_lab 1 "1 - Skill level 1 (low)" 2 "2 - Skill level 2 (medium)" 3 "3 - Skill levels 3 and 4 (high)" 4 "4 - Not elsewhere classified"
			    lab val ilo_job1_ocu_skill ocu_skill_lab
			    lab var ilo_job1_ocu_skill "Occupation (Skill level) in main job"
				
	* SECOND JOB:
    * Two digit-level
	gen occ_code_sec=int(p4q42isc/100) if ilo_mjh==2
	
	gen ilo_job2_ocu_isco08_2digits=occ_code_sec if ilo_mjh==2
	    lab val ilo_job2_ocu_isco08_2digits isco08_2digits
		lab var ilo_job2_ocu_isco08_2digits "Occupation (ISCO-08), 2 digit level in secondary job"
		
	* One digit-level
	gen ilo_job2_ocu_isco08=.
	    replace ilo_job2_ocu_isco08=11 if inlist(ilo_job2_ocu_isco08_2digits,90,99,.) & ilo_mjh==2                   //Not elsewhere classified
		replace ilo_job2_ocu_isco08=int(ilo_job2_ocu_isco08_2digits/10) if (ilo_job2_ocu_isco08==. & ilo_mjh==2)     //The rest of the occupations
		replace ilo_job2_ocu_isco08=10 if (ilo_job2_ocu_isco08==0 & ilo_mjh==2)                                      //Armed forces
				lab val ilo_job2_ocu_isco08 isco08
				lab var ilo_job2_ocu_isco08 "Occupation (ISCO-08) in secondary job"
		
	* Aggregate:			
	gen ilo_job2_ocu_aggregate=.
		replace ilo_job2_ocu_aggregate=1 if inrange(ilo_job2_ocu_isco08,1,3)
		replace ilo_job2_ocu_aggregate=2 if inlist(ilo_job2_ocu_isco08,4,5)
		replace ilo_job2_ocu_aggregate=3 if inlist(ilo_job2_ocu_isco08,6,7)
		replace ilo_job2_ocu_aggregate=4 if ilo_job2_ocu_isco08==8
		replace ilo_job2_ocu_aggregate=5 if ilo_job2_ocu_isco08==9
		replace ilo_job2_ocu_aggregate=6 if ilo_job2_ocu_isco08==10
		replace ilo_job2_ocu_aggregate=7 if ilo_job2_ocu_isco08==11
				lab val ilo_job2_ocu_aggregate ocu_aggr_lab
	    		lab var ilo_job2_ocu_aggregate "Occupation (Aggregate) in secondary job"
		
	* Skill level
	gen ilo_job2_ocu_skill=.
	    replace ilo_job2_ocu_skill=1 if ilo_job2_ocu_isco08==9                   // Low
		replace ilo_job2_ocu_skill=2 if inlist(ilo_job2_ocu_isco08,4,5,6,7,8)    // Medium
		replace ilo_job2_ocu_skill=3 if inlist(ilo_job2_ocu_isco08,1,2,3)        // High
		replace ilo_job2_ocu_skill=4 if inlist(ilo_job2_ocu_isco08,10,11)        // Not elsewhere classified
	    		lab val ilo_job2_ocu_skill ocu_skill_lab
			    lab var ilo_job2_ocu_skill "Occupation (Skill level) in secondary job"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*	Institutional sector of economic activities ('ilo_job1_ins_sector') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment: - Only asked to employees in both main and secondary job (therefore all the rest 
*            are classified under Private)
*          - Public sector: Government, State-owned enterprise
*          - Private sector: Privately-owned business or farm, non-governmental/non-profit organization,
*            private household, embasies and bilateral institutions, united nations and other
*            insternational organizations, others.

    * MAIN JOB
	gen ilo_job1_ins_sector=.
		replace ilo_job1_ins_sector=1 if inlist(p3q18,1,2) & ilo_lfs==1         // Public
		replace ilo_job1_ins_sector=2 if ilo_job1_ins_sector==. & ilo_lfs==1	// Private
    			lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private"
			    lab values ilo_job1_ins_sector ins_sector_lab
			    lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities in main job"				

    * SECOND JOB
	gen ilo_job2_ins_sector=.
		replace ilo_job2_ins_sector=1 if inlist(p4q39,1,2) & ilo_mjh==2         // Public
		replace ilo_job2_ins_sector=2 if ilo_job2_ins_sector==. & ilo_mjh==2	// Private
    			lab values ilo_job2_ins_sector ins_sector_lab
			    lab var ilo_job2_ins_sector "Institutional sector (private/public) of economic activities in secondary job"
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job1_job_contract') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Only asked to employees (main and secondary job)

   * MAIN JOB
   gen ilo_job1_job_contract=.
	   replace ilo_job1_job_contract=1 if p3q12==2 & ilo_lfs==1                 // Permanent (unlimited duration)
	   replace ilo_job1_job_contract=2 if p3q12==1 & ilo_lfs==1                 // Temporary (limited duration)
	   replace ilo_job1_job_contract=3 if p3q12==. & ilo_lfs==1                 // Unknown
			   lab def job_contract_lab 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"
			   lab val ilo_job1_job_contract job_contract_lab
			   lab var ilo_job1_job_contract "Job (Type of contract) in main job"			
   
   * SECOND JOB
   gen ilo_job2_job_contract=.
	   replace ilo_job2_job_contract=1 if p4q33==2 & ilo_mjh==2                 // Permanent (permanent nature)
	   replace ilo_job2_job_contract=2 if p4q33==1 & ilo_mjh==2                 // Temporary (limited duration)
	   replace ilo_job2_job_contract=3 if p4q33==. & ilo_mjh==2                 // Unknown (unspecified duration and without information)
			   lab val ilo_job2_job_contract job_contract_lab
			   lab var ilo_job2_job_contract "Job (Type of contract) in secondary job"
			   
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Formal / Informal Economy ('ilo_job1_ife_prod' 'ilo_job1_ife_nature') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
* Comment: 	
/* Useful questions:
			- Institutional sector: p3q18
			- Destination of production: p2q4 (comment: only category 1 (only for own consumption))
			- Bookkeeping: not asked
			- Registration: p3q19
			- Household identification: ilo_job1_eco_isic4_2digits==97 ilo_job1_ocu_isco08_2digits==63
			- Social security contribution: not asked directly (nor pension scheme)
			- Place of work: p3q20
			- Size: p3q23 (comment: cutoff at 5 or more)
			- Status in employment: ilo_job1_ste_aggregate
			- Paid annual leave: p3q16
			- Paid sick leave: p3q17
*/
	

	* 1) UNIT OF PRODUCTION: FORMAL/INFORMAL SECTOR		
    			
			gen ilo_job1_ife_prod=.
			    replace ilo_job1_ife_prod=3 if ilo_lfs==1 & ((p3q18==5) | ///
				                                            (inlist(p3q18,3,8,.) & p2q4==1) | ///
														    (ilo_job1_eco_isic4_2digits==97) | (ilo_job1_ocu_isco08_2digits==63))
				replace ilo_job1_ife_prod=2 if ilo_lfs==1 & ((inlist(p3q18,1,2,4,6,7)) | ///
				                                            (inlist(p3q18,3,8,.) & p2q4!=1 & p3q19==1) | ///
															(inlist(p3q18,3,8,.) & p2q4!=1 & inlist(p3q19,4,.) & ilo_job1_ste_aggregate==1 & (p3q16==1 & p3q17==1)) | ///
															(inlist(p3q18,3,8,.) & p2q4!=1 & inlist(p3q19,4,.) & ilo_job1_ste_aggregate==1 & (p3q16!=1 | p3q17!=1) & p3q20==4 & inlist(p3q23,2,3,4,5,6,7)) | ///
															(inlist(p3q18,3,8,.) & p2q4!=1 & inlist(p3q19,4,.) & p3q20==4 & inlist(p3q23,2,3,4,5,6,7)))
			    replace ilo_job1_ife_prod=1 if ilo_lfs==1 & ((inlist(p3q18,3,8,.) & p2q4!=1 & inlist(p3q19,2,3)) | ///
				                                            (inlist(p3q18,3,8,.) & p2q4!=1 & inlist(p3q19,4,.) & p3q20!=4) | ///
															(inlist(p3q18,3,8,.) & p2q4!=1 & inlist(p3q19,4,.) & p3q20==4 & inlist(p3q23,1,8)))
				        lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 
						lab val ilo_job1_ife_prod ilo_ife_prod_lab
						lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"
						
						
	* 2) NATURE OF JOB: FORMAL/INFORMAL EMPLOYMENT
	
	      gen ilo_job1_ife_nature=.
		      replace ilo_job1_ife_nature=1 if ilo_lfs==1 & ((inlist(ilo_job1_ste_aggregate,1,6) & inlist(p3q16,2,3,.)) | ///
			                                                (inlist(ilo_job1_ste_aggregate,1,6) & p3q16==1 & inlist(p3q17,2,3,.)) | ///
															(inlist(ilo_job1_ste_aggregate,2,4) & inlist(ilo_job1_ife_prod,1,3)) | ///
															(ilo_job1_ste_aggregate==3 & p2q4==1) | ///
															(ilo_job1_ste_aggregate==3 & p2q4!=1 & inlist(ilo_job1_ife_prod,1,3)) | ///
															(ilo_job1_ste_aggregate==5))
			  replace ilo_job1_ife_nature=2 if ilo_lfs==1 & ((inlist(ilo_job1_ste_aggregate,1,6) & p3q16==1 & p3q17==1) | ///
			                                                (inlist(ilo_job1_ste_aggregate,2,4) & ilo_job1_ife_prod==2) | ///
															(ilo_job1_ste_aggregate==3 & p2q4!=1 & ilo_job1_ife_prod==2))
			          lab def ife_nature_lab 1 "1 - Persons with informal main job" 2 "2 - Persons with formal main job"
			          lab val ilo_job1_ife_nature ife_nature_lab
			          lab var ilo_job1_ife_nature "Informal / Formal Economy (Nature of job)"
					  
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Hours of work ('ilo_how') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment: - One observation from the "hours usually worked in main job" variable is replaced
*            by the correct number; same as for .

* i) hours usually worked in main job:
  gen p5q49a_1=p5q49a
      replace p5q49a_1=68 if p5q49a==680
	  
* ii) hours actually worked in all jobs:
  gen total_c_1=total_c
      replace total_c_1="120" if total_c=="**"
	  destring total_c_1, replace
		
	* MAIN JOB:

	* 1) Weekly hours ACTUALLY worked:
	     gen ilo_job1_how_actual=total_a if ilo_lfs==1
		     lab var ilo_job1_how_actual "Weekly hours actually worked in main job"

		 gen ilo_job1_how_actual_bands=.
		     replace ilo_job1_how_actual_bands=1 if ilo_job1_how_actual==0
			 replace ilo_job1_how_actual_bands=2 if ilo_job1_how_actual>=1 & ilo_job1_how_actual<=14
			 replace ilo_job1_how_actual_bands=3 if ilo_job1_how_actual>=15 & ilo_job1_how_actual<=29
			 replace ilo_job1_how_actual_bands=4 if ilo_job1_how_actual>=30 & ilo_job1_how_actual<=34
			 replace ilo_job1_how_actual_bands=5 if ilo_job1_how_actual>=35 & ilo_job1_how_actual<=39
			 replace ilo_job1_how_actual_bands=6 if ilo_job1_how_actual>=40 & ilo_job1_how_actual<=48
			 replace ilo_job1_how_actual_bands=7 if ilo_job1_how_actual>=49 & ilo_job1_how_actual!=.
			 replace ilo_job1_how_actual_bands=8 if ilo_job1_how_actual==. & ilo_lfs==1
			 replace ilo_job1_how_actual_bands=. if ilo_lfs!=1
			    	 lab def how_bands_lab 1 "No hours actually worked" 2 "01-14" 3 "15-29" 4 "30-34" 5 "35-39" 6 "40-48" 7 "49+" 8 "Not elsewhere classified"
					 lab val ilo_job1_how_actual_bands how_bands_lab
					 lab var ilo_job1_how_actual_bands "Weekly hours actually worked bands in main job"
		
	* 2) Weekly hours USUALLY worked:
		 gen ilo_job1_how_usual=p5q49a_1 if ilo_lfs==1
			 lab var ilo_job1_how_usual "Weekly hours usually worked in main job"
				 
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
					 lab var ilo_job1_how_usual_bands "Weekly hours usually worked bands in main job"
		
		
	* SECOND JOB
				
	* 1) Weekly hours ACTUALLY worked:
         gen ilo_job2_how_actual=total_b if ilo_mjh==2
			 lab var ilo_job2_how_actual "Weekly hours actually worked in secondary job"
		
		 gen ilo_job2_how_actual_bands=.
			 replace ilo_job2_how_actual_bands=1 if ilo_job2_how_actual==0
			 replace ilo_job2_how_actual_bands=2 if ilo_job2_how_actual>=1 & ilo_job2_how_actual<=14
			 replace ilo_job2_how_actual_bands=3 if ilo_job2_how_actual>=15 & ilo_job2_how_actual<=29
			 replace ilo_job2_how_actual_bands=4 if ilo_job2_how_actual>=30 & ilo_job2_how_actual<=34
			 replace ilo_job2_how_actual_bands=5 if ilo_job2_how_actual>=35 & ilo_job2_how_actual<=39
			 replace ilo_job2_how_actual_bands=6 if ilo_job2_how_actual>=40 & ilo_job2_how_actual<=48
			 replace ilo_job2_how_actual_bands=7 if ilo_job2_how_actual>=49 & ilo_job2_how_actual!=.
			 replace ilo_job2_how_actual_bands=8 if ilo_job2_how_actual==. & ilo_mjh==2
			 replace ilo_job2_how_actual_bands=. if ilo_mjh!=2
			    	 lab val ilo_job2_how_actual_bands how_bands_lab
					 lab var ilo_job2_how_actual_bands "Weekly hours actually worked bands in secondary job"
		
	* 2) Weekly hours USUALLY worked:
		 gen ilo_job2_how_usual=p5q49b if ilo_mjh==2
			 lab var ilo_job2_how_usual "Weekly hours usually worked in secondary job"
					 
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
					 lab var ilo_job2_how_usual_bands "Weekly hours usually worked bands in secondary job" 
		
	* ALL JOBS:
		
	* 1) Weekly hours ACTUALLY worked:
		 gen ilo_joball_how_actual=total_c_1 if ilo_lfs==1
			 lab var ilo_joball_how_actual "Weekly hours actually worked in all jobs"
						
		 gen ilo_joball_actual_how_bands=.
			 replace ilo_joball_actual_how_bands=1 if ilo_joball_how_actual==0
			 replace ilo_joball_actual_how_bands=2 if ilo_joball_how_actual>=1 & ilo_joball_how_actual<=14
			 replace ilo_joball_actual_how_bands=3 if ilo_joball_how_actual>=15 & ilo_joball_how_actual<=29
			 replace ilo_joball_actual_how_bands=4 if ilo_joball_how_actual>=30 & ilo_joball_how_actual<=34
			 replace ilo_joball_actual_how_bands=5 if ilo_joball_how_actual>=35 & ilo_joball_how_actual<=39
			 replace ilo_joball_actual_how_bands=6 if ilo_joball_how_actual>=40 & ilo_joball_how_actual<=48
			 replace ilo_joball_actual_how_bands=7 if ilo_joball_how_actual>=49 & ilo_joball_how_actual!=.
			 replace ilo_joball_actual_how_bands=8 if ilo_joball_actual_how_bands==. & ilo_lfs==1
			 replace ilo_joball_actual_how_bands=. if ilo_lfs!=1
			 		 lab val ilo_joball_actual_how_bands how_bands_lab
					 lab var ilo_joball_actual_how_bands "Weekly hours actually worked bands in all jobs"
						
						
	* 2) Weekly hours USUALLY worked:
		 gen ilo_joball_how_usual=p5q49c if ilo_lfs==1
		     lab var ilo_joball_how_usual "Weekly hours usually worked in all jobs"
						
		 gen ilo_joball_usual_how_bands=.
			 replace ilo_joball_usual_how_bands=1 if ilo_joball_how_usual==0
			 replace ilo_joball_usual_how_bands=2 if ilo_joball_how_usual>=1 & ilo_joball_how_usual<=14
			 replace ilo_joball_usual_how_bands=3 if ilo_joball_how_usual>=15 & ilo_joball_how_usual<=29
			 replace ilo_joball_usual_how_bands=4 if ilo_joball_how_usual>=30 & ilo_joball_how_usual<=34
			 replace ilo_joball_usual_how_bands=5 if ilo_joball_how_usual>=35 & ilo_joball_how_usual<=39
			 replace ilo_joball_usual_how_bands=6 if ilo_joball_how_usual>=40 & ilo_joball_how_usual<=48
			 replace ilo_joball_usual_how_bands=7 if ilo_joball_how_usual>=49 & ilo_joball_how_usual!=.
			 replace ilo_joball_usual_how_bands=8 if ilo_joball_usual_how_bands==. & ilo_lfs==1
			 replace ilo_joball_usual_how_bands=. if ilo_lfs!=1
			 		 lab val ilo_joball_usual_how_bands how_bands_lab
					 lab var ilo_joball_usual_how_bands "Weekly hours usually worked bands in all jobs"
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job1_job_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
* Comment: - The question is not asked directly; the threshold is set at 48 hours usually worked 
*            per week (weighted median).
*          -(Question: Threshold too high?)
	   
	   gen ilo_job1_job_time=.
    	   replace ilo_job1_job_time=1 if ilo_joball_how_usual<48 & ilo_lfs==1 
		   replace ilo_job1_job_time=2 if ilo_joball_how_usual>=48 & ilo_lfs==1
		   replace ilo_job1_job_time=3 if !inlist(ilo_job1_job_time,1,2) & ilo_lfs==1
			       lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
				   lab val ilo_job1_job_time job_time_lab
				   lab var ilo_job1_job_time "Job (Working time arrangement) - Main job"
				   
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Monthly labour related income ('ilo_joball_lri')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Only possible to compute monthly labour related income for employees (in main or
*            secondary job).
*          - Accounting for the total amount after deduction of taxes, if any, but before any 
*            other deduction.

	* MAIN JOB
    * Monthly labour related income for employees:
	  
	  egen ilo_job1_lri_ees = rowtotal(p6q58a1 p6q58a2 p6q58a3 p6q58a4 p6q58a5 p6q58a6), m
           lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"
				  
	* SECOND JOB
    * Monthly labour related income for employees:
	  
	  egen ilo_job2_lri_ees = rowtotal(p6q58b1 p6q58b2 p6q58b3 p6q58b4 p6q58b5 p6q58b6), m
           lab var ilo_job2_lri_ees "Monthly earnings of employees in secondary job"

***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_joball_tru') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment: - Due to the absence of a nationally defined threshold, we set it at 35 hours usually
*            worked per week.

		gen ilo_joball_tru=.
			replace ilo_joball_tru=1 if (p5q51==1 & p5q52>0 & ilo_joball_how_usual<35 & ilo_lfs==1)
			        lab def tru_lab 1 "Time-related underemployment"
			        lab val ilo_joball_tru tru_lab
			        lab var ilo_joball_tru "Time-related underemployment"	

*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Cases of non-fatal occupational injury ('ilo_joball_oi_case') [done]
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
* Comment: Not available

*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
*			Days lost due to cases of occupational injury ('ilo_joball_oi_day') [done]
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
* Comment: Not available	

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
		replace ilo_cat_une=1 if (p7q71==1 & ilo_lfs==2)                        // Previously employed
		replace ilo_cat_une=2 if (p7q71==2 & ilo_lfs==2)                        // Seeking first job
		replace ilo_cat_une=3 if (ilo_cat_une==. & ilo_lfs==2)
			lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
			lab val ilo_cat_une cat_une_lab
			lab var ilo_cat_une "Category of unemployment"
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comments: - Category 1 month to less than 3 months includes less than 1 month. (note to value: C7:3905)
*           - Category 12 to 24 months includes 24 to 36 months (note to value: C7:3096).
*           - Category 24 months or more excludes 24 to 36 months (note to value: C7:3097)

	gen ilo_dur_details=.
		replace ilo_dur_details=2 if (p7q74==1 & ilo_lfs==2)                    // 1 to 3 months (including less than 1 month)
		replace ilo_dur_details=3 if (p7q74==2 & ilo_lfs==2)                    // 3 to 6 months
		replace ilo_dur_details=4 if (p7q74==3 & ilo_lfs==2)                    // 6 to 12 months
		replace ilo_dur_details=5 if (p7q74==4 & ilo_lfs==2)                    // 12 to 24 months (including 24 to 36 months)
		replace ilo_dur_details=6 if (inlist(p7q74,5,6,7) & ilo_lfs==2)         // 24 months or more (excluding 24 to 36 months)
		replace ilo_dur_details=7 if (p7q74==. & ilo_lfs==2)                    // Not elsewhere classified
		        lab def ilo_unemp_det 1 "Less than 1 month" 2 "1 month to less than 3 months" 3 "3 months to less than 6 months" ///
									  4 "6 months to less than 12 months" 5 "12 months to less than 24 months" 6 "24 months or more" ///
									  7 "Not elsewhere classified"
			    lab val ilo_dur_details ilo_unemp_det
			    lab var ilo_dur_details "Duration of unemployment (Details)"
					
	gen ilo_dur_aggregate=.
		replace ilo_dur_aggregate=1 if (inlist(p7q74,1,2) & ilo_lfs==2)         // Less than 6 months
		replace ilo_dur_aggregate=2 if (p7q74==3 & ilo_lfs==2)                  // 6 to 12 months
		replace ilo_dur_aggregate=3 if (inlist(p7q74,4,5,6,7) & ilo_lfs==2)     // 12 months or more
		replace ilo_dur_aggregate=4 if (ilo_dur_aggregate==. & ilo_lfs==2)      //Not elsewhere classified
		replace ilo_dur_aggregate=. if ilo_lfs!=2
			lab def ilo_unemp_aggr 1 "Less than 6 months" 2 "6 months to less than 12 months" 3 "12 months or more" 4 "Not elsewhere classified"
			lab val ilo_dur_aggregate ilo_unemp_aggr
			lab var ilo_dur_aggregate "Duration of unemployment (Aggregate)"
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
* Comment: - Even though the question is asked to unemployed people previously employed, the 
*            original variable is not properly coded and therefore no ilo's variable is generated.

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
* Comment: - Original classification follows ISCO-08 at one digit-level

			
    * One digit-level
	gen ilo_prevocu_isco08=.
	    replace ilo_prevocu_isco08=isco75 if (ilo_lfs==2 & ilo_cat_une==1)
		replace ilo_prevocu_isco08=11 if ilo_prevocu_isco08==. & (ilo_lfs==2 & ilo_cat_une==1)
				lab val ilo_prevocu_isco08 isco08
				lab var ilo_prevocu_isco08 "Previous occupation (ISCO-08)"
				
	* Aggregate level 
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
	   	replace ilo_prevocu_skill=1 if ilo_prevocu_isco08==9
	    replace ilo_prevocu_skill=2 if inlist(ilo_prevocu_isco08,4,5,6,7,8)
	    replace ilo_prevocu_skill=3 if inlist(ilo_prevocu_isco08,1,2,3)
	    replace ilo_prevocu_skill=4 if inlist(ilo_prevocu_isco08,10,11)
			    lab val ilo_prevocu_skill ocu_skill_lab
			    lab var ilo_prevocu_skill "Previous occupation (Skill level)"

***********************************************************************************************
*			PART 3.4. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment: 

	gen ilo_olf_dlma=.
        replace ilo_olf_dlma = 1 if ((p7q59a==1 | p7q59b==1) & (p7q65==2 & p7q66==2)) & ilo_lfs==3                // Seeking, not available
		replace ilo_olf_dlma = 2 if ((p7q59a==2 & p7q59b==2) & (p7q65==1 | p7q66==1)) & ilo_lfs==3                // Not seeking, available
		replace ilo_olf_dlma = 3 if ((p7q59a==2 & p7q59b==2) & (p7q65==2 & p7q66==2) & p7q61==1) & ilo_lfs==3     // Not seeking, not available, willing
		replace ilo_olf_dlma = 4 if ((p7q59a==2 & p7q59b==2) & (p7q65==2 & p7q66==2) & p7q61==2) & ilo_lfs==3     // Not seeking, not available, not willing
		replace ilo_olf_dlma = 5 if	(ilo_olf_dlma==. & ilo_lfs==3)				                                  // Not elsewhere classified 
	 		lab def dlma_lab 1 "1 - Seeking, not available (Unavailable jobseekers)" 2 "2 - Not seeking, available (Available potential jobseekers)" ///
							 3 "3 - Not seeking, not available, willing (Willing non-jobseekers)" 4 "4 - Not seeking, not available, not willing" 5 "X - Not elsewhere classified"
			lab val ilo_olf_dlma dlma_lab 
			lab var ilo_olf_dlma "Labour market attachment (Degree of)"
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reason for not seeking job ('ilo_olf_reason') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment: - Categories written on the questionnaire are not aligned with those on the database.
*          Ilo's variable is based on the categories presented on the original dataset.

	gen ilo_olf_reason=.
		replace ilo_olf_reason=1 if	(inlist(p7q62,9,10,11,12,13) & ilo_lfs==3)	// Labour market
		replace ilo_olf_reason=2 if (inlist(p7q62,3,4) & ilo_lfs==3)            // Other labour market reasons
		replace ilo_olf_reason=3 if	(inlist(p7q62,5,6,7,8) & ilo_lfs==3)        // Personal/Family-related
		*replace ilo_olf_reason=4                            					// Does not need/want to work
		replace ilo_olf_reason=5 if (ilo_olf_reason==. & ilo_lfs==3)			//Not elsewhere classified
			    lab def reasons_lab 1 "1 - Labour market" 2 "2 - Other labour market reasons" 3 "3 - Personal / Family-related" ///
				    			    4 "4 - Does not need/want to work" 5 "5 - Not elsewhere classified"
			lab val ilo_olf_reason reasons_lab 
			lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"
			

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seeker ('ilo_dis') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment: 

	gen ilo_dis=1 if (ilo_lfs==3 & (p7q65==1 | p7q66==1) & ilo_olf_reason==1)
			lab def dis_lab 1 "Discouraged job-seekers"
			lab val ilo_dis dis_lab
			lab var ilo_dis "Discouraged job-seekers"
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training ('ilo_neet') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: 

	gen ilo_neet=1 if (ilo_age_aggregate==2 & ilo_lfs!=1 & ilo_edu_attendance==2)
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
        
		/*Categories from temporal file deleted */
		drop if lab==1 
		
		/*Only age bands used*/
		drop ilo_age 
		/*Codelist for economic activity and occupation*/
		drop lab isco08_2digits isco88_2digits isco08 isco88 isic4_2digits isic4 isic3_2digits isic3
		
		/*Variables computed in-between*/
		drop indu_code_prim indu_code_sec occ_code_prim ilo_job1_ocu_skill occ_code_sec p5q49a_1 total_c_1
		
		compress 
		
	   /*Save dataset including original and ilo variables*/
	
		save ${country}_${source}_${time}_FULL,  replace		
	
	  /* Save file only containing ilo_* variables*/
	
		keep ilo*

		save ${country}_${source}_${time}_ILO, replace
			
				    
		  

			
			
				   
					 
				

