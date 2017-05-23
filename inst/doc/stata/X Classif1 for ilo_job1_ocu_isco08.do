
*This do-file generates the column classif1 for ilo_job1_ocu_isco08 [Occupation (ISCO-08)]
*It is separate because it will be used often.

/*
ilostat_code	code_level	code_label
OCU_ISCO08_1	1			1 - Managers
OCU_ISCO08_2	2			2 - Professionals
OCU_ISCO08_3	3			3 - Technicians and associate professionals
OCU_ISCO08_4	4			4 - Clerical support workers
OCU_ISCO08_5	5			5 - Service and sales workers
OCU_ISCO08_6	6			6 - Skilled agricultural, forestry and fishery workers
OCU_ISCO08_7	7			7 - Craft and related trades workers
OCU_ISCO08_8	8			8 - Plant and machine operators, and assemblers
OCU_ISCO08_9	9			9 - Elementary occupations
OCU_ISCO08_0	10			0 - Armed forces occupations
OCU_ISCO08_X	11			X - Not elsewhere classified
*/

gen     classif1 = ""
replace classif1 = "OCU_ISCO08_1" if ilo_job1_ocu_isco08==1
replace classif1 = "OCU_ISCO08_2" if ilo_job1_ocu_isco08==2
replace classif1 = "OCU_ISCO08_3" if ilo_job1_ocu_isco08==3
replace classif1 = "OCU_ISCO08_4" if ilo_job1_ocu_isco08==4
replace classif1 = "OCU_ISCO08_5" if ilo_job1_ocu_isco08==5
replace classif1 = "OCU_ISCO08_6" if ilo_job1_ocu_isco08==6
replace classif1 = "OCU_ISCO08_7" if ilo_job1_ocu_isco08==7
replace classif1 = "OCU_ISCO08_8" if ilo_job1_ocu_isco08==8
replace classif1 = "OCU_ISCO08_9" if ilo_job1_ocu_isco08==9
replace classif1 = "OCU_ISCO08_0" if ilo_job1_ocu_isco08==10
replace classif1 = "OCU_ISCO08_X" if ilo_job1_ocu_isco08==11
