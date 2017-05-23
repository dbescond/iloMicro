
*This do-file generates the column classif1 for ilo_job1_ocu_aggregate [Occupation (Aggregate)]
*It is separate because it will be used often.

/*
ilostat_code		code_level	code_label
OCU_AGGREGATE_1-3	1			1 - Managers, professionals, and technicians
OCU_AGGREGATE_4-5	2			2 - Clerical, service and sales workers
OCU_AGGREGATE_6-7	3			3 - Skilled agricultural and trades workers
OCU_AGGREGATE_8		4			4 - Plant and machine operators, and assemblers
OCU_AGGREGATE_9		5			5 - Elementary occupations
OCU_AGGREGATE_AF	6			6 - Armed forces
OCU_AGGREGATE_X		7			7 - Not elsewhere classified
*/

gen     classif1 = ""
replace classif1 = "OCU_AGGREGATE_1-3" if ilo_job1_ocu_aggregate==1
replace classif1 = "OCU_AGGREGATE_4-5" if ilo_job1_ocu_aggregate==2
replace classif1 = "OCU_AGGREGATE_6-7" if ilo_job1_ocu_aggregate==3
replace classif1 = "OCU_AGGREGATE_8"   if ilo_job1_ocu_aggregate==4
replace classif1 = "OCU_AGGREGATE_9"   if ilo_job1_ocu_aggregate==5
replace classif1 = "OCU_AGGREGATE_AF"  if ilo_job1_ocu_aggregate==6
replace classif1 = "OCU_AGGREGATE_X"   if ilo_job1_ocu_aggregate==7
