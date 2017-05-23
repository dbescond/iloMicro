
*This do-file generates the column classif2 for edu_isced97 [Level of education (ISCED 97)]
*It is separate because it will be used often.

/*
ilostat_code	code_level	code_label
EDU_ISCED97_X	1			X - No schooling
EDU_ISCED97_0	2			0 - Pre-primary education
EDU_ISCED97_1	3			1 - Primary education or first stage of basic education
EDU_ISCED97_2	4			2 - Lower secondary or second stage of basic education
EDU_ISCED97_3	5			3 - Upper secondary education
EDU_ISCED97_4	6			4 - Post-secondary non-tertiary education
EDU_ISCED97_5	7			5 - First stage of tertiary education (not leading directly to an advanced research qualification)
EDU_ISCED97_6	8			6 - Second stage of tertiary education (leading to an advanced research qualification)
EDU_ISCED97_UNK	9			UNK - Level not stated
*/

gen     classif2 = ""
replace classif2 = "EDU_ISCED97_X"   if ilo_edu_isced97==1
replace classif2 = "EDU_ISCED97_0"   if ilo_edu_isced97==2
replace classif2 = "EDU_ISCED97_1"   if ilo_edu_isced97==3
replace classif2 = "EDU_ISCED97_2"   if ilo_edu_isced97==4
replace classif2 = "EDU_ISCED97_3"   if ilo_edu_isced97==5
replace classif2 = "EDU_ISCED97_4"   if ilo_edu_isced97==6
replace classif2 = "EDU_ISCED97_5"   if ilo_edu_isced97==7
replace classif2 = "EDU_ISCED97_6"   if ilo_edu_isced97==8
replace classif2 = "EDU_ISCED97_UNK" if ilo_edu_isced97==9
