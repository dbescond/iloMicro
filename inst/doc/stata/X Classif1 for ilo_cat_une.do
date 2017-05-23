
*This do-file generates the column classif1 for ilo_cat_une [Type of unemployment]
*It is separate because it will be used often.

/*
code_level	code_label								ilostat_code
1			1 - Unemployed previously employed		CAT_UNE_PRE
2			2 - Unemployed seeking their first job	CAT_UNE_FJS
3			3 - Unknown								CAT_UNE_UNK
*/
gen     classif1 = ""
replace classif1 = "CAT_UNE_PRE" if ilo_cat_une==1
replace classif1 = "CAT_UNE_FJS" if ilo_cat_une==2
replace classif1 = "CAT_UNE_UNK" if ilo_cat_une==3
