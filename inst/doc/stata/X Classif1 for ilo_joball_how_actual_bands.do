
*This do-file generates the column classif1 for ilo_joball_how_actual_bands [Bands of weekly hours actually worked in all jobs]
*It is separate because it will be used often.

/*
ilostat_code		code_level	code_label
HOW_BANDS_H00		1			No hours actually worked
HOW_BANDS_H01-14	2			01-14
HOW_BANDS_H15-29	3			15-29
HOW_BANDS_H30-34	4			30-34
HOW_BANDS_H35-39	5			35-39
HOW_BANDS_H40-48	6			40-48
HOW_BANDS_HGE49		7			49+
HOW_BANDS_X			8			Not elsewhere classified
*/

gen     classif1 = ""
replace classif1 = "HOW_BANDS_H00"    if ilo_joball_how_actual_bands==1
replace classif1 = "HOW_BANDS_H01-14" if ilo_joball_how_actual_bands==2
replace classif1 = "HOW_BANDS_H15-29" if ilo_joball_how_actual_bands==3
replace classif1 = "HOW_BANDS_H30-34" if ilo_joball_how_actual_bands==4
replace classif1 = "HOW_BANDS_H35-39" if ilo_joball_how_actual_bands==5
replace classif1 = "HOW_BANDS_H40-48" if ilo_joball_how_actual_bands==6
replace classif1 = "HOW_BANDS_HGE49"  if ilo_joball_how_actual_bands==7
replace classif1 = "HOW_BANDS_X"      if ilo_joball_how_actual_bands==8
