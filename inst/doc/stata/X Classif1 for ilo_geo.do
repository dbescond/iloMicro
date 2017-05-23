
*This do-file generates the column classif1 for ilo_geo [Geographical coverage]
*It is separate because it will be used often.

/*
ilostat_code	code_level	code_label
GEO_COV_URB		1			1 - Urban
GEO_COV_RUR		2			2 - Rural
*/
gen     classif1 = ""
replace classif1 = "GEO_COV_URB"   if ilo_geo==1
replace classif1 = "GEO_COV_RUR"   if ilo_geo==2
