
*This do-file generates the column classif2 for edu_isced11 [Level of education (ISCED 11)]
*It is separate because it will be used often.

/*
ilostat_code	code_level	code_label
EDU_ISCED11_X	1			X - No schooling
EDU_ISCED11_0	2			0 - Early childhood education
EDU_ISCED11_1	3			1 - Primary education
EDU_ISCED11_2	4			2 - Lower secondary education
EDU_ISCED11_3	5			3 - Upper secondary education
EDU_ISCED11_4	6			4 - Post-secondary non-tertiary education
EDU_ISCED11_5	7			5 - Short-cycle tertiary education
EDU_ISCED11_6	8			6 - Bachelor's or equivalent level
EDU_ISCED11_7	9			7 - Master's or equivalent level
EDU_ISCED11_8	10			8 - Doctoral or equivalent level
EDU_ISCED11_9	11			9 - Not elsewhere classified
*/

gen     classif2 = ""
replace classif2 = "EDU_ISCED11_X"   if ilo_edu_isced11==1
replace classif2 = "EDU_ISCED11_0"   if ilo_edu_isced11==2
replace classif2 = "EDU_ISCED11_1"   if ilo_edu_isced11==3
replace classif2 = "EDU_ISCED11_2"   if ilo_edu_isced11==4
replace classif2 = "EDU_ISCED11_3"   if ilo_edu_isced11==5
replace classif2 = "EDU_ISCED11_4"   if ilo_edu_isced11==6
replace classif2 = "EDU_ISCED11_5"   if ilo_edu_isced11==7
replace classif2 = "EDU_ISCED11_6"   if ilo_edu_isced11==8
replace classif2 = "EDU_ISCED11_7"   if ilo_edu_isced11==9
replace classif2 = "EDU_ISCED11_8"   if ilo_edu_isced11==10
replace classif2 = "EDU_ISCED11_9"   if ilo_edu_isced11==11
