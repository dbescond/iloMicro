
*This do-file generates the column classif1 for ilo_job1_ste_icse93 [Status in employment (ICSE 93)]
*It is separate because it will be used often.

/*
ilostat_code	code_level	code_label
STE_ICSE93_1	1			1 - Employees
STE_ICSE93_2	2			2 - Employers
STE_ICSE93_3	3			3 - Own-account workers
STE_ICSE93_4	4			4 - Members of producers cooperatives
STE_ICSE93_5	5			5 - Contributing family workers
STE_ICSE93_6	6			6 - Workers not classifiable by status
*/
gen     classif1 = ""
replace classif1 = "STE_ICSE93_1"   if ilo_job1_ste_icse93==1
replace classif1 = "STE_ICSE93_2"   if ilo_job1_ste_icse93==2
replace classif1 = "STE_ICSE93_3"   if ilo_job1_ste_icse93==3
replace classif1 = "STE_ICSE93_4"   if ilo_job1_ste_icse93==4
replace classif1 = "STE_ICSE93_5"   if ilo_job1_ste_icse93==5
replace classif1 = "STE_ICSE93_6"   if ilo_job1_ste_icse93==6
