
*This do-file generates the column classif1 for ilo_age_5yrbands [Age (5-year age bands)]
*It is separate because it will be used often.

/*
code_level	code_label	ilostat_code
1			0-4			AGE_5YRBANDS_Y00-04
2			5-9			AGE_5YRBANDS_Y05-09
3			10-14		AGE_5YRBANDS_Y10-14
4			15-19		AGE_5YRBANDS_Y15-19
5			20-24		AGE_5YRBANDS_Y20-24
6			25-29		AGE_5YRBANDS_Y25-29
7			30-34		AGE_5YRBANDS_Y30-34
8			35-39		AGE_5YRBANDS_Y35-39
9			40-44		AGE_5YRBANDS_Y40-44
10			45-49		AGE_5YRBANDS_Y45-49
11			50-54		AGE_5YRBANDS_Y50-54
12			55-59		AGE_5YRBANDS_Y55-59
13			60-64		AGE_5YRBANDS_Y60-64
14			65+			AGE_5YRBANDS_YGE65
*/
gen     classif1 = ""
replace classif1 = "AGE_5YRBANDS_Y15-19" if ilo_age_5yrbands==4
replace classif1 = "AGE_5YRBANDS_Y20-24" if ilo_age_5yrbands==5
replace classif1 = "AGE_5YRBANDS_Y25-29" if ilo_age_5yrbands==6
replace classif1 = "AGE_5YRBANDS_Y30-34" if ilo_age_5yrbands==7
replace classif1 = "AGE_5YRBANDS_Y35-39" if ilo_age_5yrbands==8
replace classif1 = "AGE_5YRBANDS_Y40-44" if ilo_age_5yrbands==9
replace classif1 = "AGE_5YRBANDS_Y45-49" if ilo_age_5yrbands==10
replace classif1 = "AGE_5YRBANDS_Y50-54" if ilo_age_5yrbands==11
replace classif1 = "AGE_5YRBANDS_Y55-59" if ilo_age_5yrbands==12
replace classif1 = "AGE_5YRBANDS_Y60-64" if ilo_age_5yrbands==13
replace classif1 = "AGE_5YRBANDS_YGE65"  if ilo_age_5yrbands==14
