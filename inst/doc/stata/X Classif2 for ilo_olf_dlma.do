
*This do-file generates the column classif2 for ilo_olf_dlma [Labour market attachment (Degree of)]
*It is separate because it will be used often.

/*
ilostat_code	code_level	code_label
OLF_DLMA_UJS	1			1 - Seeking, not available (Unavailable jobseekers)
OLF_DLMA_DSC	2			2 - Not seeking, available (Available potential jobseekers)
OLF_DLMA_WNJS	3			3 - Not seeking, not available, willing (Willing non-jobseekers)
OLF_DLMA_NWNJS	4			4 - Not seeking, not available, not willing
*/
gen     classif2 = ""
replace classif2 = "OLF_DLMA_UJS"   if ilo_olf_dlma==1
replace classif2 = "OLF_DLMA_DSC"   if ilo_olf_dlma==2
replace classif2 = "OLF_DLMA_WNJS"  if ilo_olf_dlma==3
replace classif2 = "OLF_DLMA_NWNJS" if ilo_olf_dlma==4
