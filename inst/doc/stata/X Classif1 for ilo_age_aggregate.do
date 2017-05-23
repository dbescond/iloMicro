
*This do-file generates the column classif1 for ilo_age_aggregate [Age (Aggregate)]
*It is separate because it will be used often.

/*
code_level	code_label	ilostat_code
1			<15			AGE_AGGREGATE_YLT15
2			15-24		AGE_AGGREGATE_Y15-24
3			25-54		AGE_AGGREGATE_Y25-54
4			55-64		AGE_AGGREGATE_Y55-64
5			65+			AGE_AGGREGATE_YGE65
*/
gen     classif1 = ""
replace classif1 = "AGE_AGGREGATE_Y15-24" if ilo_age_aggregate==2
replace classif1 = "AGE_AGGREGATE_Y25-54" if ilo_age_aggregate==3
replace classif1 = "AGE_AGGREGATE_Y55-64" if ilo_age_aggregate==4
replace classif1 = "AGE_AGGREGATE_YGE65"  if ilo_age_aggregate==5
