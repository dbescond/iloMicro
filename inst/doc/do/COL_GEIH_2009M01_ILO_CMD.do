* TITLE OF DO FILE: ILO Microdata Preprocessing code template - Colombia, 2015M01
* DATASET USED: Colombia LFS 2015M01
* NOTES: 
* Files created: Standard variables on GEIH Colombia 2009M01
* Authors: Mabelin Villarreal Fuentes
* Who last updated the file: Mabelin Villarreal Fuentes
* Starting Date: 05 June 2017
* Last updated: 13 July 2017
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
global country "COL"
global source "GEIH"
global time "2009M01"
global inputFile "COL_LFS_2009M01_All"
global inpath "${path}\\${country}\\${source}\\${time}\ORI"
global temppath "${path}\_Admin"
global outpath "${path}\\${country}\\${source}\\${time}"


************************************************************************************

* Important : if package « labutil » not already installed, install it in order to execute correctly the do-file

* ssc install labutil

************************************************************************************
* Make a tempfile containing the labels for the classifications ISIC and ISCO 

		* NOTE: if you want this do-file to run correctly, run it without breaks!
		
cd "$temppath"
		
	tempfile labels
			* Import Framework
			import excel 3_Framework.xlsx, sheet("Variable") firstrow
			* Keep only the variable names, the codes and the labels associated to the codes
			keep var_name code_level code_label
			* Select only variables associated to isic and isco
			keep if (substr(var_name,1,12)=="ilo_job1_ocu" | substr(var_name,1,12)=="ilo_job1_eco") & substr(var_name,14,.)!="aggregate"
			* Destring codes
			destring code_level, replace
			* Reshape
				    foreach classif in var_name {
					replace var_name=substr(var_name,14,.) if var_name==`classif'
					}
				
				reshape wide code_label, i(code_level) j(var_name) string
				foreach var of newlist isco08_2digits isco88_2digits isco08 isco88 isic4_2digits isic4 ///
							isic3_2digits isic3 {
							gen `var'=code_level
							replace `var'=. if code_label`var'==""
							labmask `var' , val(code_label`var')
							}				
				drop code_label* code_level
							
			* Save file (as tempfile)
			
			save "`labels'"
			
*********************************************************************************************

* Load original dataset

*********************************************************************************************
*********************************************************************************************
* Original dataset are divided by geographical coverage (urban, rural and main cities) and 
* modules of the LFS’s questionnaire. In order to obtain the final dataset to be used, there’s 
* a consolidation process carried out before; from reading the related text files and saving 
* them as stata data bases, to merging and appending all necessary parts, to finally save and 
* use the resultant dataset.

*------------------------------------------*
*--- 0. Reading month numeric -------------*
*------------------------------------------*

* Splitting the global time year/month
gen to_drop = "$time"
split to_drop, generate(to_drop_) parse(M)

* Assigning names of each month in Spanish
gen to_drop_3 = "Enero" if to_drop_2=="01"
    replace to_drop_3 = "Febrero" if to_drop_2=="02"
	replace to_drop_3 = "Marzo" if to_drop_2=="03"
	replace to_drop_3 = "Abril" if to_drop_2=="04"
	replace to_drop_3 = "Mayo" if to_drop_2=="05"
	replace to_drop_3 = "Junio" if to_drop_2=="06"
	replace to_drop_3 = "Julio" if to_drop_2=="07"
	replace to_drop_3 = "Agosto" if to_drop_2=="08"
	replace to_drop_3 = "Septiembre" if to_drop_2=="09"
	replace to_drop_3 = "Octubre" if to_drop_2=="10"
    replace to_drop_3 = "Noviembre" if to_drop_2=="11"
	replace to_drop_3 = "Diciembre" if to_drop_2=="12"
	
* Month as local
local M = to_drop_3 in 1

* Folder that contains dta files
cd "$inpath"
   * Check if `M' subdir exists; if it does not exist then it creates it.
   capture confirm file "`M'_dta/nul"
   if _rc{
     !md "`M'_dta"
   }
*------------------------------------------*
*--- 1. txt to dta files ------------------*
*------------------------------------------*

local cab_res Área Cabecera Resto

foreach geo of local cab_res{
*-
cd "$inpath\\`M'.txt"
   import delimited "`geo' - Características generales (Personas).txt", clear
cd "$inpath\\`M'_dta"   
   save "`geo'_Caracteristicas_generales", replace
*-
cd "$inpath\\`M'.txt"
   import delimited "`geo' - Desocupados.txt", clear
cd "$inpath\\`M'_dta"   
   save "`geo'_Desocupados", replace
*-
cd "$inpath\\`M'.txt"
   import delimited "`geo' - Fuerza de trabajo.txt", clear
cd "$inpath\\`M'_dta"   
   save "`geo'_Fuerza_de_trabajo", replace
*-
cd "$inpath\\`M'.txt"
   import delimited "`geo' - Inactivos.txt", clear
cd "$inpath\\`M'_dta"   
   save "`geo'_Inactivos", replace
*-
cd "$inpath\\`M'.txt"
   import delimited "`geo' - Ocupados.txt", clear
cd "$inpath\\`M'_dta"   
   save "`geo'_Ocupados", replace 
*-
cd "$inpath\\`M'.txt"
   import delimited "`geo' - Otras actividades y ayudas en la semana.txt", clear
cd "$inpath\\`M'_dta"   
   save "`geo'_Otras_actividades", replace
*-
cd "$inpath\\`M'.txt"
   import delimited "`geo' - Otros ingresos.txt", clear
cd "$inpath\\`M'_dta"   
   save "`geo'_Otros_ingresos", replace  
}

*------------------------------------------*
*--- 2. merge dta files -------------------*
*------------------------------------------*

*-- Cabecera (urban) and Resto (rural) contain all necessary information (including that from 
*-- Area files (main cities))

*------------------------------------------*
*-- Cabecera (Urban)
*------------------------------------------*

cd "$inpath\\`M'_dta"
   use "Cabecera_Caracteristicas_generales", clear
   merge 1:1 directorio secuencia_p orden using "Cabecera_Fuerza_de_trabajo", nogenerate
   merge 1:1 directorio secuencia_p orden using "Cabecera_Ocupados", nogenerate
   merge 1:1 directorio secuencia_p orden using "Cabecera_Desocupados", nogenerate
   merge 1:1 directorio secuencia_p orden using "Cabecera_Inactivos", nogenerate
   merge 1:1 directorio secuencia_p orden using "Cabecera_Otras_actividades", nogenerate
   merge 1:1 directorio secuencia_p orden using "Cabecera_Otros_ingresos", nogenerate
   rename *, lower
   
   *--Variables that must be character (force them to be as character) and those that must be numeric (force them to be numeric)
   
   unab allvars: _all
   unab string_vars: p6290s1 p6240s1 p6310s1 p6430s1 p6480s1 p6765s1 p6780s1 p6410s1 p6810s1 p6830s1 p6880s1 p6980s7a1 p6915s1 p7240s1 p7280s1 p7350s1 p7390s1 p7420s7a1 p7450s1 p7458s1 p6980 p7028s1 p7050s1 p7420 
   
   foreach var in `string_vars'{
     tostring `var', replace force
   } 
   
   foreach var in `:list allvars - string_vars'{
     destring `var', replace force
   }

compress
save "Cabecera", replace   

*------------------------------------------*
*-- Resto (Rural)
*------------------------------------------*

clear all
cd "$inpath\\`M'_dta"
   use "Resto_Caracteristicas_generales", clear   
   merge 1:1 directorio secuencia_p orden using "Resto_Fuerza_de_trabajo", nogenerate
   merge 1:1 directorio secuencia_p orden using "Resto_Ocupados", nogenerate
   merge 1:1 directorio secuencia_p orden using "Resto_Desocupados", nogenerate
   merge 1:1 directorio secuencia_p orden using "Resto_Inactivos", nogenerate
   merge 1:1 directorio secuencia_p orden using "Resto_Otras_actividades", nogenerate
   merge 1:1 directorio secuencia_p orden using "Resto_Otros_ingresos", nogenerate
   rename *, lower
   
   *--Variables that must be character (force them to be as character) and those that must be numeric (force them to be numeric)
   unab allvars: _all
   unab string_vars: p6290s1 p6240s1 p6310s1 p6430s1 p6480s1 p6765s1 p6780s1 p6410s1 p6810s1 p6830s1 p6880s1 p6980s7a1 p6915s1 p7240s1 p7280s1 p7350s1 p7390s1 p7420s7a1 p7450s1 p7458s1 p6980 p7028s1 p7050s1 p7420 
   
   foreach var in `string_vars'{
     tostring `var', replace force
   } 
   
   foreach var in `:list allvars - string_vars'{
     destring `var', replace force
   }  
   
compress
save "Resto", replace

*------------------------------------------*
*--- 3. append dta files ------------------*
*------------------------------------------*

clear all
cd "$inpath\\`M'_dta"
   use "Cabecera", clear
   *variable "clase" already contains information on the geographical coverages (1- Urban, 2- Rural)
   append using "Resto"

*********************************************************************************************
*********************************************************************************************

*- Saving    
cd "$inpath"   
compress
  save ${country}_${source}_${time}_All, replace
  
*- Using the final file
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

	gen ilo_key=_n
		lab var ilo_key "Key unique identifier per individual"
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time period ('ilo_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*
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

	gen ilo_wgt=fex_c_2011
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
	    replace ilo_geo=1 if clase==1
		replace ilo_geo=2 if clase==2
		lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural"
		lab val ilo_geo ilo_geo_lab
		lab var ilo_geo "Geographical coverage"	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*Comment: 

	gen ilo_sex=.
	    replace ilo_sex=1 if p6020==1
		replace ilo_sex=2 if p6020==2
		lab def ilo_sex_lab 1 "1 - Male" 2 "2 - Female"
		lab var ilo_sex "Sex"
		lab val ilo_sex ilo_sex_lab

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment:

	gen ilo_age=p6040
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
* Comment: - ISCED 97 mapping: http://uis.unesco.org/en/isced-mappings
*          - Question is only asked to people aged 3 years old or more; thus, those aged below
*            three are classified under "Level not stated"
*          - Level 5 of education includes level 6 (Include classification note -> C3:991)

	gen ilo_edu_isced97=.
		replace ilo_edu_isced97=1 if p6210==1  					// No schooling
		replace ilo_edu_isced97=2 if p6210==2 					// Pre-primary education
		replace ilo_edu_isced97=3 if p6210==3  		            // Primary education or first stage of basic education
		replace ilo_edu_isced97=4 if p6210==4  		            // Lower secondary or second stage of basic education
		replace ilo_edu_isced97=5 if p6210==5           	    // Upper secondary education
		*replace ilo_edu_isced97=6 if                         	// Post-secondary non-tertiary education
		replace ilo_edu_isced97=7 if p6210==6        	        // First stage of tertiary education (not leading directly to an advanced research qualification)
		*replace ilo_edu_isced97=8 if    				        // Second stage of tertiary education (leading to an advanced research qualification)
		replace ilo_edu_isced97=9 if inlist(p6210,9,.)		    // Level  not stated
			label def isced_97_lab 1 "X - No schooling" 2 "0 - Pre-primary education" 3 "1 - Primary education or first stage of basic education" 4 "2 - Lower secondary education or second stage of basic education" ///
							5 "3 - Upper secondary education" 6 "4 - Post-secondary non-tertiary education" 7 "5 - First stage of tertiary education (not leading directly to an advanced research qualification)" ///
							8 "6 - Second stage of tertiary education (leading to an advanced research qualification)" 9 "UNK - Level not stated"
			label val ilo_edu_isced97 isced_97_lab
			lab var ilo_edu_isced97 "Education (ISCED 97)"

		
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
*			Education attendance ('ilo_edu_attendance')  	[done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - Question is only asked to people aged 3 years old or more; thus, those aged below
*            three are under "Not elsewhere classified"

	gen ilo_edu_attendance=.
		replace ilo_edu_attendance=1 if p6170==1		                        // Attending 
		replace ilo_edu_attendance=2 if p6170==2 			                    // Not attending 
		replace ilo_edu_attendance=3 if ilo_edu_attendance==.                   // Not elsewhere classified 
			label def edu_att_lab 1 "1 - Attending" 2 "2 - Not attending" 3 "3 - Not elsewhere classified" 
			label val ilo_edu_attendance edu_att_lab
			label var ilo_edu_attendance "Education (Attendance)"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Disability status ('ilo_dsb') 	[done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment: Not asked

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
* Comment: wap = 15+ 

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
* Comment: - Employed persons differ from those following the national defition due to age 
*            coverage (the national statistical office includes people from 10 to 14).   
*          - Unemployed persons' classification follow the ILO definition (not in employment,
*            available and seeking) including available future starters.
		
	gen ilo_lfs=.
		replace ilo_lfs=1 if (p6240==1 | p6250==1 | p6260==1 | p6270==1) & ilo_wap==1         // Employed
		replace ilo_lfs=2 if ilo_lfs!=1 & (p6280==1 & p6351==1) & ilo_wap==1                  // Unemployed
		replace ilo_lfs=2 if ilo_lfs!=1 & (p6310==1 & p6351==1) & ilo_wap==1                  // Unemployed: available future starters
		replace ilo_lfs=3 if ilo_lfs!=1 & ilo_lfs!=2 & ilo_wap==1                             // Outside the labour force
				label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside the Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: 

	gen ilo_mjh=.
		replace ilo_mjh=1 if p7040==2 & ilo_lfs==1
		replace ilo_mjh=2 if p7040==1 & ilo_lfs==1
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
* Comment: - Domestic workers and agricultural labourers are included into the category 
*            employees.
	
	* MAIN JOB:
	
		* Detailed categories:
			gen ilo_job1_ste_icse93=.
				replace ilo_job1_ste_icse93=1 if inlist(p6430,1,2,3,8) & ilo_lfs==1	 // Employees
				replace ilo_job1_ste_icse93=2 if p6430==5 & ilo_lfs==1			     // Employers
				replace ilo_job1_ste_icse93=3 if p6430==4 & ilo_lfs==1			     // Own-account workers
				*replace ilo_job1_ste_icse93=4 if 		                             // Producer cooperatives
				replace ilo_job1_ste_icse93=5 if inlist(p6430,6,7) & ilo_lfs==1		 // Contributing family workers
				replace ilo_job1_ste_icse93=6 if inlist(p6430,9,.) & ilo_lfs==1	     // Not classifiable
				replace ilo_job1_ste_icse93=. if ilo_lfs!=1
					label def label_ilo_ste_icse93 1 "1 - Employees" 2 "2 - Employers" 3 "3 - Own-account workers"  ///
													4 "4 - Members of producers cooperatives" 5 "5 - Contributing family workers" ///
													6 "6 - Workers not classifiable by status"
					label val ilo_job1_ste_icse93 label_ilo_ste_icse93
					label var ilo_job1_ste_icse93 "Status in employment (ICSE 93) - main job"
		
		* Aggregate categories 
			gen ilo_job1_ste_aggregate=.
				replace ilo_job1_ste_aggregate=1 if ilo_job1_ste_icse93==1				// Employees
				replace ilo_job1_ste_aggregate=2 if inrange(ilo_job1_ste_icse93,2,5)	// Self-employed
				replace ilo_job1_ste_aggregate=3 if ilo_job1_ste_icse93==6				// Not elsewhere classified
					lab def ste_aggr_lab 1 "1 - Employees" 2 "2 - Self-employed" 3 "3 - Not elsewhere classified"
					lab val ilo_job1_ste_aggregate ste_aggr_lab
					label var ilo_job1_ste_aggregate "Status in employment (Aggregate) - main job" 

		
	* SECOND JOB:
	
		* Detailed categories:
			gen ilo_job2_ste_icse93=.
				replace ilo_job2_ste_icse93=1 if inlist(p7050,1,2,3,8)	& ilo_mjh==2  //Employees
				replace ilo_job2_ste_icse93=2 if p7050==5 & ilo_mjh==2			      // Employers
				replace ilo_job2_ste_icse93=3 if p7050==4 & ilo_mjh==2			      // Own-account workers
				*replace ilo_job2_ste_icse93=4 if 			                          // Producer cooperatives
				replace ilo_job2_ste_icse93=5 if inlist(p7050,6,7) & ilo_mjh==2		  // Contributing family workers
				replace ilo_job2_ste_icse93=6 if inlist(p7050,9,.) & ilo_mjh==2	      // Not classifiable
				replace ilo_job2_ste_icse93=. if ilo_mjh!=2
					label val ilo_job2_ste_icse93 label_ilo_ste_icse93
					label var ilo_job2_ste_icse93 "Status in employment (ICSE 93) - second job"
			
			
	
		* Aggregate categories 
			gen ilo_job2_ste_aggregate=.
				replace ilo_job2_ste_aggregate=1 if ilo_job2_ste_icse93==1				// Employees
				replace ilo_job2_ste_aggregate=2 if inrange(ilo_job2_ste_icse93,2,5)	// Self-employed
				replace ilo_job2_ste_aggregate=3 if ilo_job2_ste_icse93==6				// Not elsewhere classified
					lab val ilo_job2_ste_aggregate ste_aggr_lab
					label var ilo_job2_ste_aggregate "Status in employment (Aggregate) - second job" 
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comment: - National classification is based on ISIC Rev.3 (4 and 2 digit-level are available).
*          - No information available for the economic activity in the second job.
		
   append using `labels', gen(lab)
   *use value label from this variable, afterwards drop everything related to this append
			
			
  * MAIN JOB:
  * ISIC Rev. 3 - 2 digit-level
		
  gen ilo_job1_eco_isic3_2digits=rama2d if ilo_lfs==1
	  lab values ilo_job1_eco_isic3_2digits isic3_2digits
	  lab var ilo_job1_eco_isic3_2digits "Economic activity (ISIC Rev. 3), 2 digit level - main job"
							
  * ISIC Rev. 3 - 1 digit-level 

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
	  replace ilo_job1_eco_isic3=18 if inlist(ilo_job1_eco_isic3_2digits,0,.) & ilo_lfs==1
		      lab val ilo_job1_eco_isic3 isic3
			  lab var ilo_job1_eco_isic3 "Economic activity (ISIC Rev. 3) - main job"
			
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
		
		
   * SECOND JOB:
   * No information available 	
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_job1_ocu_isco88') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment: - The country follows its own National Classification of Occupations (C.N.O-70); although 
*            the original variable is at 2 digit-level, it does not match with ISCO-08(/88) code
*            (nor at 1 digit-level) and therefore only the aggregate and skill level is computed 
*            (both based on the CNO 2 digit-level).
*          - Correspondences tables can be found between CNO-70 and ISCO:
*            http://observatorio.sena.edu.co/Content/pdf/correlativa_cno_2016_ciuo_08_ac.pdf
*          - Differences and similarities between CNO and ISCO can be found:
*            http://repositorio.sena.edu.co/bitstream/11404/1754/1/clasificacion_nacional_ocupaciones_2013.pdf)
*          - No information available on the occupation in the second job  		
	   
  * Aggregate
	gen ilo_job1_ocu_aggregate=.
	    replace ilo_job1_ocu_aggregate=1 if (inrange(oficio,0,19) | inrange(oficio,20,21)) & ilo_lfs==1
		replace ilo_job1_ocu_aggregate=2 if (inrange(oficio,30,39) | inrange(oficio,40,49) | inrange(oficio,50,59)) & ilo_lfs==1
		replace ilo_job1_ocu_aggregate=3 if (inrange(oficio,60,64)) & ilo_lfs==1
		*replace ilo_job1_ocu_aggregate=4 if 
		*replace ilo_job1_ocu_aggregate=5 if 
		*replace ilo_job1_ocu_aggregate=6 if 
		replace ilo_job1_ocu_aggregate=7 if (inrange(oficio,70,99) | oficio==.) & ilo_lfs==1
				lab def ocu_aggr_lab 1 "1 - Managers, professionals, and technicians" 2 "2 - Clerical, service and sales workers" 3 "3 - Skilled agricultural and trades workers" ///
									 4 "4 - Plant and machine operators, and assemblers" 5 "5 - Elementary occupations" 6 "6 - Armed forces" 7 "7 - Not elsewhere classified"
				lab val ilo_job1_ocu_aggregate ocu_aggr_lab
				lab var ilo_job1_ocu_aggregate "Occupation (Aggregate) - main job"	
		
  * Skill level
	gen ilo_job1_ocu_skill=.
	    replace ilo_job1_ocu_skill=1 if ilo_job1_ocu_aggregate==5               // Low
		replace ilo_job1_ocu_skill=2 if inlist(ilo_job1_ocu_aggregate,2,3,4)    // Medium
		replace ilo_job1_ocu_skill=3 if ilo_job1_ocu_aggregate==1               // High
		replace ilo_job1_ocu_skill=4 if inlist(ilo_job1_ocu_aggregate,6,7)      // Not elsewhere classified (including armed forces)
				lab def ocu_skill_lab 1 "1 - Skill level 1 (low)" 2 "2 - Skill level 2 (medium)" 3 "3 - Skill levels 3 and 4 (high)" 4 "4 - Not elsewhere classified"
			    lab val ilo_job1_ocu_skill ocu_skill_lab
			    lab var ilo_job1_ocu_skill "Occupation (Skill level) - main job"
	

  * SECOND JOB:
  * No informaiton available

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_job1_ins_sector') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment: Public: Government's employee
*   	   Private: The rest

	* MAIN JOB:
	
		gen ilo_job1_ins_sector=.
			replace ilo_job1_ins_sector=1 if p6430==2 & ilo_lfs==1				// Public
			replace ilo_job1_ins_sector=2 if p6430!=2 & ilo_lfs==1		        // Private
				lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private" 
				lab values ilo_job1_ins_sector ins_sector_lab
				lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities - main job"
	
	* SECOND JOB:
    * No information available
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job1_job_contract') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
* Comment: - Only asked to those who answered yes to question about having or not a contract
*            (p6440); thus, the rest are classified under "unknown".

   * MAIN JOB
   gen ilo_job1_job_contract=.
	   replace ilo_job1_job_contract=1 if p6460==1 & ilo_lfs==1                 // Permanent (unlimited duration)
	   replace ilo_job1_job_contract=2 if p6460==2 & ilo_lfs==1                 // Temporary (limited duration)
	   replace ilo_job1_job_contract=3 if p6460==. & ilo_lfs==1                 // Unknown
			   lab def job_contract_lab 1 "1 - Permanent" 2 "2 - Temporary" 3 "3 - Unknown"
			   lab val ilo_job1_job_contract job_contract_lab
			   lab var ilo_job1_job_contract "Job (Type of contract) in main job"
   
   * SECOND JOB
   * No information available	
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Formal / Informal Economy ('ilo_job1_ife_prod' 'ilo_job1_ife_nature') [to check-------------------------------------------------------------------------]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
* Comment: - Apparently bookeeping does not exist (variable 6775) 

            /*	Useful questions:
			- Institutional sector: p6430 (although the question is not asked directly, it is possible to
			  isolate government's employees from the rest); identification of households is made
			  through the previously created variable ilo_job1_eco_isic3_2digits==95 (activities of private
			  households); both are mutually exclusive.
			- Destination of production: Not asked
			- Bookkeeping: p6775 (only asked to own-acount workers)
			- Registration: p6772 (only asked to own-account workers)
			- Status in employment: ilo_job1_ste_aggregate
			- Social security contribution: p6920 (Q: are you currently paying a pension scheme?)
			  has to be combined with p6940 (Q: who's paying for it? either partially or totally
			  paid by the employer)
			- Place of work: p6880
			- Size: p6870
			- Paid annual leave: p6424s1 (not used becuase there's no information on paid sick leave)
			- Paid sick leave: Not asked
*/			
		

    * Social security (to be dropped afterwards): 
            gen social_security=.
			    replace social_security=1 if p6920==1 & (inlist(p6940,1,3)) & ilo_lfs==1                      // Paying a pension scheme and (partially or completely paid by the employer)
				replace social_security=2 if (inlist(p6920,2,3) | !inlist(p6940,1,3)) & ilo_lfs==1            // Not paying a pension scheme or (not partially and not completely paid by the employer)
				replace social_security=. if (social_security==. & ilo_lfs==1)

	* 1) UNIT OF PRODUCTION: FORMAL/INFORMAL SECTOR		
    			
			gen ilo_job1_ife_prod=.
			    replace ilo_job1_ife_prod=3 if ilo_lfs==1 & ///
				                              (ilo_job1_eco_isic3_2digits==95)
				replace ilo_job1_ife_prod=2 if ilo_lfs==1 & ilo_job1_ife_prod!=3 & ///
				                              ((p6430==2) | ///
											  (p6430!=2 & p6775==1) | ///
											  (p6430!=2 & p6775!=1 & p6772==1) | ///
											  (p6430!=2 & p6775!=1 & !inlist(p6772,1,2) & ilo_job1_ste_aggregate==1 & social_security==1) | ///
											  (p6430!=2 & p6775!=1 & !inlist(p6772,1,2) & ilo_job1_ste_aggregate==1 & social_security!=1 & p6880==7 & inlist(p6870,4,5,6,7,8,9)) | ///
											  (p6430!=2 & p6775!=1 & !inlist(p6772,1,2) & ilo_job1_ste_aggregate!=1 & p6880==7 & inlist(p6870,4,5,6,7,8,9)))
			    replace ilo_job1_ife_prod=1 if ilo_lfs==1 & ilo_job1_ife_prod!=2 & ilo_job1_ife_prod!=3 & ///
				                              ((p6430!=2 & p6775!=1 & p6772==2) | ///
											  (p6430!=2 & p6775!=1 & !inlist(p6772,1,2) & ilo_job1_ste_aggregate==1 & social_security!=1 & p6880==7 & inlist(p6870,1,2,3,.)) | ///
											  (p6430!=2 & p6775!=1 & !inlist(p6772,1,2) & ilo_job1_ste_aggregate==1 & social_security!=1 & p6880!=7) | /// 
											  (p6430!=2 & p6775!=1 & !inlist(p6772,1,2) & ilo_job1_ste_aggregate!=1 & p6880==7 & inlist(p6870,1,2,3,.)) | ///
											  (p6430!=2 & p6775!=1 & !inlist(p6772,1,2) & ilo_job1_ste_aggregate!=1 & p6880!=7))
				        lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 
						lab val ilo_job1_ife_prod ilo_ife_prod_lab
						lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"
						
						
	* 2) NATURE OF JOB: FORMAL/INFORMAL EMPLOYMENT
	
	      gen ilo_job1_ife_nature=.
		      replace ilo_job1_ife_nature=1 if ilo_lfs==1 & ///
			                                  ((inlist(ilo_job1_ste_icse93,1,6) & social_security!=1) | ///
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
					  
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Hours of work ('ilo_how') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment:
		
	* MAIN JOB:
			
	* 1) Weekly hours ACTUALLY worked:
	     gen ilo_job1_how_actual=p6850 if ilo_lfs==1
		 	 replace ilo_job1_how_actual=. if ilo_job1_how_actual<0
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
		 gen ilo_job1_how_usual=p6800 if ilo_lfs==1
			 replace ilo_job1_how_usual=. if ilo_job1_how_usual<0
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
			
	* 1) Weekly hours ACTUALLY worked in second job:
         gen ilo_job2_how_actual=p7045 if ilo_mjh==2
			 replace ilo_job2_how_actual=. if ilo_job2_how_actual<0
					 lab var ilo_job2_how_actual "Weekly hours actually worked in second job"
		
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
					 lab var ilo_job2_how_actual_bands "Weekly hours actually worked bands in second job"
		
	* 2) Weekly hours USUALLY worked in second job:
		 * Not available
		
		
	* ALL JOBS:
		
	* 1) Weekly hours ACTUALLY worked in all jobs:
		 egen ilo_joball_how_actual = rowtotal(ilo_job1_how_actual ilo_job2_how_actual), m 
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
						
						
	* 2) Weekly hours USUALLY worked in all jobs:
		 * Not available
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job1_job_time') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
* Comment: - The question is not asked directly; the threshold is set at 48 hours based on the 
*            weighted median of the usual hours of work for the main job.
	   
	   gen ilo_job1_job_time=.
				replace ilo_job1_job_time=1 if ilo_job1_how_usual<48 & ilo_lfs==1
				replace ilo_job1_job_time=2 if ilo_job1_how_usual>=48 & ilo_job1_job_time==. & ilo_lfs==1
				replace ilo_job1_job_time=3 if !inlist(ilo_job1_job_time,1,2) & ilo_lfs==1
					lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
					lab val ilo_job1_job_time job_time_lab
					lab var ilo_job1_job_time "Job (Working time arrangement) - Main job"	

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Monthly labour related income ('ilo_job1_lri') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
* Comments: - Based on the calculated variable from the NSO's original database (inglabo = ingresos
*             laborales) for the main job, and on the direct question asked for second job.
*           - Including family allowances, overtime, irregular bonuses and payments in kind.
*           - Unit: local currency (colombian pesos).
	   
  * MAIN JOB:
	 * Employees
	 gen ilo_job1_lri_ees = inglabo if ilo_job1_ste_aggregate==1
	     lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"	
				   
	 * Self-employed
	 gen ilo_job1_lri_slf = inglabo if ilo_job1_ste_aggregate==2
	     lab var ilo_job1_lri_slf "Monthly labour related income of self-employed in main job"
		 
  * SECOND JOB:
	 * Employees
	 gen ilo_job2_lri_ees = p7070 if ilo_job2_ste_aggregate==1
	     lab var ilo_job2_lri_ees "Monthly earnings of employees in secod job"	
				   
	 * Self-employed
	 gen ilo_job2_lri_slf = p7070 if ilo_job2_ste_aggregate==2
	     lab var ilo_job2_lri_slf "Monthly labour related income of self-employed in second job"		 
		 
			
***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		
				
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_joball_tru') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
* Comment: - Threshold used: set at 48 hours usually worked in main job per week (following the
*            NSO's methodological report)
	
	   gen ilo_joball_tru=.
		   replace ilo_joball_tru=1 if ilo_lfs==1 & (p7090==1 & p7100>0) & p7120==1 & ilo_job1_how_usual<48
			       lab def ilo_tru 1 "Time-related underemployed"
				   lab val ilo_joball_tru ilo_tru
				   lab var ilo_joball_tru "Time-related underemployed"				
					
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupational injury ('ilo_joball_inj') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
* Not available

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
			replace ilo_cat_une=1 if ilo_lfs==2 & p7310==2			            // Previously employed
			replace ilo_cat_une=2 if ilo_lfs==2 & p7310==1			            // Seeking first job
			replace ilo_cat_une=3 if ilo_lfs==2 & !inlist(ilo_cat_une,1,2)	    //Unkown
				lab def cat_une_lab 1 "1 - Unemployed previously employed" 2 "2 - Unemployed seeking their first job" 3 "3 - Unknown"
				lab val ilo_cat_une cat_une_lab
				lab var ilo_cat_une "Category of unemployment"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* Comments: - Original question refers to the number of weeks seeking for a job.

	gen ilo_dur_details=.
	    replace ilo_dur_details=1 if (p7250<4 & ilo_lfs==2)                     // Less than 1 month (between 1 and 3 weeks)
		replace ilo_dur_details=2 if (inrange(p7250,4,11) & ilo_lfs==2)         // 1 to 3 months (between 4 and 11 weeks)
		replace ilo_dur_details=3 if (inrange(p7250,12,23) & ilo_lfs==2)        // 3 to 6 months (between 12 and 23 weeks)
		replace ilo_dur_details=4 if (inrange(p7250,24,47) & ilo_lfs==2)        // 6 to 12 months (between 24 and 47 weeks)
		replace ilo_dur_details=5 if (inrange(p7250,48,95) & ilo_lfs==2)        // 12 to 24 months (between 48 and 95 weeks)
		replace ilo_dur_details=6 if (p7250>=96 & p7250!=999 & ilo_lfs==2)      // 24 months or more (96 weeks or more)
		replace ilo_dur_details=7 if (p7250==999 & ilo_lfs==2)                  // Not elsewhere classified
		        lab def ilo_unemp_det 1 "Less than 1 month" 2 "1 month to less than 3 months" 3 "3 months to less than 6 months" ///
									  4 "6 months to less than 12 months" 5 "12 months to less than 24 months" 6 "24 months or more" ///
									  7 "Not elsewhere classified"
			    lab val ilo_dur_details ilo_unemp_det
			    lab var ilo_dur_details "Duration of unemployment (Details)"
					
	gen ilo_dur_aggregate=.
		replace ilo_dur_aggregate=1 if (inlist(ilo_dur_details,1,2,3) & ilo_lfs==2)   // Less than 6 months
		replace ilo_dur_aggregate=2 if (ilo_dur_details==4 & ilo_lfs==2)              // 6 to 12 months
		replace ilo_dur_aggregate=3 if (inlist(ilo_dur_details,5,6) & ilo_lfs==2)     // 12 months or more
		replace ilo_dur_aggregate=4 if (ilo_dur_details==7 & ilo_lfs==2)              //Not elsewhere classified
		replace ilo_dur_aggregate=. if ilo_lfs!=2
			lab def ilo_unemp_aggr 1 "Less than 6 months" 2 "6 months to less than 12 months" 3 "12 months or more" 4 "Not elsewhere classified"
			lab val ilo_dur_aggregate ilo_unemp_aggr
			lab var ilo_dur_aggregate "Duration of unemployment (Aggregate)"

	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_isic4')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
* Comment: - National classification is based on ISIC Rev.3 (4 and 2 digit-level are available).

	* ISIC Rev. 3 - 2 digit
	gen ilo_preveco_isic3_2digits=.
		  replace ilo_preveco_isic3_2digits = rama2d_d if ilo_lfs==2 & ilo_cat_une==1
		  replace ilo_preveco_isic3_2digits = . if ilo_preveco_isic3<0
		          lab val ilo_preveco_isic3_2digits isic3_2digits
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
			    lab val ilo_preveco_isic3 isic3
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
*			Previous occupation ('ilo_prevocu') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
* Comment: - Colombia follows its own National Classification of Occupations (C.N.O-70); although 
*            the original variable is at 2 digit-level, it does not match with ISCO-08(/88) code 
*            (nor at 1 digit-level) and therefore only the aggregate and skill level is computed 
*            (both based on the CNO 2 digit-level).
*          - Correspondences tables can be found between CNO-70 and ISCO:
*            http://observatorio.sena.edu.co/Content/pdf/correlativa_cno_2016_ciuo_08_ac.pdf
*          - Differences and similarities between CNO and ISCO can be found:
*            http://repositorio.sena.edu.co/bitstream/11404/1754/1/clasificacion_nacional_ocupaciones_2013.pdf)
	   
  * Aggregate
	gen ilo_prevocu_aggregate=.
	    replace ilo_prevocu_aggregate=1 if (inrange(oficio2,0,19) | inrange(oficio2,20,21)) & ilo_lfs==2 & ilo_cat_une==1
		replace ilo_prevocu_aggregate=2 if (inrange(oficio2,30,39) | inrange(oficio2,40,49) | inrange(oficio2,50,59)) & ilo_lfs==2 & ilo_cat_une==1
		replace ilo_prevocu_aggregate=3 if (inrange(oficio2,60,64)) & ilo_lfs==2 & ilo_cat_une==1
		*replace ilo_prevocu_aggregate=4 if 
		*replace ilo_prevocu_aggregate=5 if 
		*replace ilo_prevocu_aggregate=6 if 
		replace ilo_prevocu_aggregate=7 if (inrange(oficio2,70,99)) & ilo_lfs==2 & ilo_cat_une==1
				lab val ilo_prevocu_aggregate ocu_aggr_lab
				lab var ilo_prevocu_aggregate "Previous occupation (Aggregate)"	
		
  * Skill level
	gen ilo_prevocu_skill=.
	    replace ilo_prevocu_skill=1 if ilo_prevocu_aggregate==5               // Low
		replace ilo_prevocu_skill=2 if inlist(ilo_prevocu_aggregate,2,3,4)    // Medium
		replace ilo_prevocu_skill=3 if ilo_prevocu_aggregate==1               // High
		replace ilo_prevocu_skill=4 if inlist(ilo_prevocu_aggregate,6,7)      // Not elsewhere classified (including armed forces)
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
* Comment:	
	
	gen ilo_olf_dlma=.
		replace ilo_olf_dlma = 1 if p6280==1 & p6351==2 & ilo_lfs==3 			  // Seeking, not available
		replace ilo_olf_dlma = 2 if p6280==2 & p6351==1 & ilo_lfs==3			  // Not seeking, available
		replace ilo_olf_dlma = 3 if p6280==2 & p6351==2 & p6300==1 & ilo_lfs==3	  // Not seeking, not available, willing
		replace ilo_olf_dlma = 4 if p6280==2 & p6351==2 & p6300==2 & ilo_lfs==3	  // Not seeking, not available, not willing
		replace ilo_olf_dlma = 5 if	ilo_olf_dlma==. & ilo_lfs==3				  // Not classified 
				lab def dlma_lab 1 "1 - Seeking, not available (Unavailable jobseekers)" 2 "2 - Not seeking, available (Available potential jobseekers)" ///
	    						 3 "3 - Not seeking, not available, willing (Willing non-jobseekers)" 4 "4 - Not seeking, not available, not willing" 5 "X - Not elsewhere classified"
		    	lab val ilo_olf_dlma dlma_lab 
			    lab var ilo_olf_dlma "Labour market attachment (Degree of)"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reason for not seeking job ('ilo_olf_reason') [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment: 

		gen ilo_olf_reason=.
			replace ilo_olf_reason=1 if	inlist(p7458,1,3,5,6,7,8) & ilo_lfs==3	  // Labour market
			*replace ilo_olf_reason=2 if                                          // Other labour market reasons
			replace ilo_olf_reason=3 if	inlist(p7458,2,4,9) & ilo_lfs==3    	  // Personal/Family-related
			replace ilo_olf_reason=4 if inlist(p7458,10,11) & ilo_lfs==3		  // Does not need/want to work
			replace ilo_olf_reason=5 if inlist(p6310,12,.) & ilo_lfs==3	          // Not elsewhere classified
				    lab def reasons_lab 1 "1 - Labour market" 2 "2 - Other labour market reasons" 3 "3 - Personal / Family-related" ///
									    4 "4 - Does not need/want to work" 5 "5 - Not elsewhere classified"
				    lab val ilo_olf_reason reasons_lab 
				    lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seeker ('ilo_dis')  [done]
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* Comment:

	gen ilo_dis=.
	    replace ilo_dis=1 if ilo_lfs==3 & p6351==1 & ilo_olf_reason==1
	            lab def dis_lab 1 "Discouraged job-seekers"
			    lab val ilo_dis dis_lab
			    lab var ilo_dis "Discouraged job-seekers"

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training ('ilo_neet') [done]
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
        
		/*Categories from temporal file deleted */
		drop if lab==1 
		
		/*Only age bands used*/
		drop ilo_age 
		
		/*Variables computed in-between*/
		drop lab isco08_2digits isco88_2digits isco08 isco88 isic4_2digits isic4 isic3_2digits isic3
		drop social_security 
		
		compress 
		
	   /*Save dataset including original and ilo variables*/
	
		save ${country}_${source}_${time}_FULL,  replace		
	
	  /* Save file only containing ilo_* variables*/
	
		keep ilo*

		save ${country}_${source}_${time}_ILO, replace

	
	
	
