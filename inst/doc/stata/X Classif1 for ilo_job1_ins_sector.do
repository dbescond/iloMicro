
*This do-file generates the column classif1 for ilo_job1_ins_sector [Institutional sector (private/public) of economic activities]
*It is separate because it will be used often.

/*
ilostat_code	code_level	code_label
INS_SECTOR_PUB	1			1 - Public
INS_SECTOR_PRI	2			2 - Private
*/

gen     classif1 = ""
replace classif1 = "INS_SECTOR_PUB" if ilo_job1_ins_sector==1
replace classif1 = "INS_SECTOR_PRI" if ilo_job1_ins_sector==2
