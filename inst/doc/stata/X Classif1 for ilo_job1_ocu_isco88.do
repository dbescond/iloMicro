
*This do-file generates the column classif1 for ilo_job1_ocu_isco88 [Occupation (ISCO-88)]
*It is separate because it will be used often.

/*
ilostat_code	code_level	code_label
OCU_ISCO88_1	1			1 - Legislators, senior officials and managers
OCU_ISCO88_2	2			2 - Professionals
OCU_ISCO88_3	3			3 - Technicians and associate professionals
OCU_ISCO88_4	4			4 - Clerks
OCU_ISCO88_5	5			5 - Service workers and shop and market sales workers
OCU_ISCO88_6	6			6 - Skilled agricultural and fishery workers
OCU_ISCO88_7	7			7 - Craft and related trades workers
OCU_ISCO88_8	8			8 - Plant and machine operators and assemblers
OCU_ISCO88_9	9			9 - Elementary occupations
OCU_ISCO88_0	10			0 - Armed forces
OCU_ISCO88_X	11			11 - Not elsewhere classified
*/

gen     classif1 = ""
replace classif1 = "OCU_ISCO88_1" if ilo_job1_ocu_isco88==1
replace classif1 = "OCU_ISCO88_2" if ilo_job1_ocu_isco88==2
replace classif1 = "OCU_ISCO88_3" if ilo_job1_ocu_isco88==3
replace classif1 = "OCU_ISCO88_4" if ilo_job1_ocu_isco88==4
replace classif1 = "OCU_ISCO88_5" if ilo_job1_ocu_isco88==5
replace classif1 = "OCU_ISCO88_6" if ilo_job1_ocu_isco88==6
replace classif1 = "OCU_ISCO88_7" if ilo_job1_ocu_isco88==7
replace classif1 = "OCU_ISCO88_8" if ilo_job1_ocu_isco88==8
replace classif1 = "OCU_ISCO88_9" if ilo_job1_ocu_isco88==9
replace classif1 = "OCU_ISCO88_0" if ilo_job1_ocu_isco88==10
replace classif1 = "OCU_ISCO88_X" if ilo_job1_ocu_isco88==11
