
*This do-file generates the column classif1 for ilo_dsb_aggregate [Disability status (Aggregate)]
*It is separate because it will be used often.

/*
code_level	code_label					ilostat_code
1			Persons with disability		DSB_STATUS_NODIS
2			Persons without disability	DSB_STATUS_DIS
*/

gen     classif1 = ""
replace classif1 = "DSB_STATUS_NODIS" if ilo_dsb_aggregate==1
replace classif1 = "DSB_STATUS_DIS"   if ilo_dsb_aggregate==2
