
*This do-file generates the column classif2 for ilo_dur_details [Duration of unemployment (Details)]
*It is separate because it will be used often.

/*ilostat_code			code_level	code_label
DUR_DETAILS_MLT1			1		Less than 1 month
DUR_DETAILS_MGE1LT3			2		1 month to less than 3 months
DUR_DETAILS_MGE3LT6			3		3 months to less than 6 months
DUR_DETAILS_MGE6LT12		4		6 months to less than 12 months
DUR_DETAILS_MGE12LT24		5		12 months to less than 24 months
DUR_DETAILS_MGE24			6		24 months or more
DUR_DETAILS_X				7		Not elsewhere classified
*/

gen     classif2 = ""
replace classif2 = "DUR_DETAILS_MLT1"      if ilo_dur_details==1
replace classif2 = "DUR_DETAILS_MGE1LT3"   if ilo_dur_details==2
replace classif2 = "DUR_DETAILS_MGE3LT6"   if ilo_dur_details==3
replace classif2 = "DUR_DETAILS_MGE6LT12"  if ilo_dur_details==4
replace classif2 = "DUR_DETAILS_MGE12LT24" if ilo_dur_details==5
replace classif2 = "DUR_DETAILS_MGE24"     if ilo_dur_details==6
replace classif2 = "DUR_DETAILS_X"         if ilo_dur_details==7
