
*This do-file generates the column sex that exists in the final template
*It is separate because it will be used often.

gen     sex = ""
replace sex = "SEX_M" if ilo_sex==1
replace sex = "SEX_F" if ilo_sex==2
replace sex = "SEX_T" if ilo_sex==3
