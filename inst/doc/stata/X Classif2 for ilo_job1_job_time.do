
*This do-file generates the column classif2 for ilo_job1_job_time [Job (Working time arrangement)]
*It is separate because it will be used often.

/*
ilostat_code	code_level	code_label
JOB_TIME_PART	1			1 - Part-time
JOB_TIME_FULL	2			2 - Full-time
JOB_TIME_X		3			3 - Unknown
*/

gen     classif2 = ""
replace classif2 = "JOB_TIME_PART" if ilo_job1_job_time==1
replace classif2 = "JOB_TIME_FULL" if ilo_job1_job_time==2
replace classif2 = "JOB_TIME_X"    if ilo_job1_job_time==3
