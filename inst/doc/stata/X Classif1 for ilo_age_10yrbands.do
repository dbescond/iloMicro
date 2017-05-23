
*This do-file generates the column classif1 for ilo_age_10yrbands [Age (10-year age bands)]
*It is separate because it will be used often.

/*
code_level	code_label	ilostat_code
1			<15			AGE_10YRBANDS_YLT15
2			15-24		AGE_10YRBANDS_Y15-24
3			25-34		AGE_10YRBANDS_Y25-34
4			35-44		AGE_10YRBANDS_Y35-44
5			45-54		AGE_10YRBANDS_Y45-54
6			55-64		AGE_10YRBANDS_Y55-64
7			65+			AGE_10YRBANDS_YGE65
*/
gen     classif1 = ""
replace classif1 = "AGE_10YRBANDS_Y15-24" if ilo_age_10yrbands==2
replace classif1 = "AGE_10YRBANDS_Y25-34" if ilo_age_10yrbands==3
replace classif1 = "AGE_10YRBANDS_Y35-44" if ilo_age_10yrbands==4
replace classif1 = "AGE_10YRBANDS_Y45-54" if ilo_age_10yrbands==5
replace classif1 = "AGE_10YRBANDS_Y55-64" if ilo_age_10yrbands==6
replace classif1 = "AGE_10YRBANDS_YGE65"  if ilo_age_10yrbands==7
