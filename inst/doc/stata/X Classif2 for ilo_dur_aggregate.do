
*This do-file generates the column classif2 for ilo_dur_aggregate [Duration of unemployment (Aggregate)]
*It is separate because it will be used often.

/*ilostat_code			code_level	code_label
DUR_AGGREGATE_MLT6		1			Less than 6 months
DUR_AGGREGATE_MGE6LT12	2			6 months to less than 12 months
DUR_AGGREGATE_MGE12		3			12 months or more
DUR_AGGREGATE_X			4			Not elsewhere classified
*/

gen     classif2 = ""
replace classif2 = "DUR_AGGREGATE_MLT6"     if ilo_dur_aggregate==1
replace classif2 = "DUR_AGGREGATE_MGE6LT12" if ilo_dur_aggregate==2
replace classif2 = "DUR_AGGREGATE_MGE12"    if ilo_dur_aggregate==3
replace classif2 = "DUR_AGGREGATE_X"        if ilo_dur_aggregate==4
