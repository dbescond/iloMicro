
*This do-file generates the column classif1 for ilo_edu_aggregate [Level of education (Aggregate)]
*It is separate because it will be used often.

/*
ilostat_code	code_level	code_label
EDU_AGGREGATE_LTB	1			1 - Less than basic
EDU_AGGREGATE_BAS	2			2 - Basic
EDU_AGGREGATE_INT	3			3 - Intermediate
EDU_AGGREGATE_ADV	4			4 - Advanced
EDU_AGGREGATE_X		5			5 - Level not stated
*/
gen     classif1 = ""
replace classif1 = "EDU_AGGREGATE_LTB"   if ilo_edu_aggregate==1
replace classif1 = "EDU_AGGREGATE_BAS"   if ilo_edu_aggregate==2
replace classif1 = "EDU_AGGREGATE_INT"   if ilo_edu_aggregate==3
replace classif1 = "EDU_AGGREGATE_ADV"   if ilo_edu_aggregate==4
replace classif1 = "EDU_AGGREGATE_X"     if ilo_edu_aggregate==5






















