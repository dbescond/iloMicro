
*This do-file generates the column classif1 for ilo_job1_ste_aggregate [Status in employment (Aggregate)]
*It is separate because it will be used often.

/*
ilostat_code		code_level	code_label
STE_AGGREGATE_EES	1			1 - Employees
STE_AGGREGATE_SLF	2			2 - Self-employed
STE_AGGREGATE_X		3			3 - Not elsewhere classified
*/

gen     classif1 = ""
replace classif1 = "STE_AGGREGATE_EES"  if ilo_job1_ste_aggregate==1
replace classif1 = "STE_AGGREGATE_SLF"  if ilo_job1_ste_aggregate==2
replace classif1 = "STE_AGGREGATE_X"    if ilo_job1_ste_aggregate==3
