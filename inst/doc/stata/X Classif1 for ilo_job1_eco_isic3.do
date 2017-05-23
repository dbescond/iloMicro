
*This do-file generates the column classif1 for ilo_job1_eco_isic3 [Economic activity (ISIC Rev. 3.1)]
*It is separate because it will be used often.

/*
ilostat_code	code_level	code_label
ECO_ISIC3_A		1			A - Agriculture, hunting and forestry
ECO_ISIC3_B		2			B - Fishing
ECO_ISIC3_C		3			C - Mining and quarrying
ECO_ISIC3_D		4			D - Manufacturing
ECO_ISIC3_E		5			E - Electricity, gas and water supply
ECO_ISIC3_F		6			F - Construction
ECO_ISIC3_G		7			G - Wholesale and retail trade; repair of motor vehicles, motorcycles and personal and household goods
ECO_ISIC3_H		8			H - Hotels and restaurants
ECO_ISIC3_I		9			I - Transport, storage and communications
ECO_ISIC3_J		10			J - Financial intermediation
ECO_ISIC3_K		11			K - Real estate, renting and business activities
ECO_ISIC3_L		12			L - Public administration and defence; compulsory social security
ECO_ISIC3_M		13			M - Education
ECO_ISIC3_N		14			N - Health and social work
ECO_ISIC3_O		15			O - Other community, social and personal service activities
ECO_ISIC3_P		16			P - Activities of private households as employers and undifferentiated production activities of private households
ECO_ISIC3_Q		17			Q - Extraterritorial organizations and bodies
ECO_ISIC3_X		18			X - Not elsewhere classified
*/

gen     classif1 = ""
replace classif1 = "ECO_ISIC3_A"   if ilo_job1_eco_isic3==1
replace classif1 = "ECO_ISIC3_B"   if ilo_job1_eco_isic3==2
replace classif1 = "ECO_ISIC3_C"   if ilo_job1_eco_isic3==3
replace classif1 = "ECO_ISIC3_D"   if ilo_job1_eco_isic3==4
replace classif1 = "ECO_ISIC3_E"   if ilo_job1_eco_isic3==5
replace classif1 = "ECO_ISIC3_F"   if ilo_job1_eco_isic3==6
replace classif1 = "ECO_ISIC3_G"   if ilo_job1_eco_isic3==7
replace classif1 = "ECO_ISIC3_H"   if ilo_job1_eco_isic3==8
replace classif1 = "ECO_ISIC3_I"   if ilo_job1_eco_isic3==9
replace classif1 = "ECO_ISIC3_J"   if ilo_job1_eco_isic3==10
replace classif1 = "ECO_ISIC3_K"   if ilo_job1_eco_isic3==11
replace classif1 = "ECO_ISIC3_L"   if ilo_job1_eco_isic3==12
replace classif1 = "ECO_ISIC3_M"   if ilo_job1_eco_isic3==13
replace classif1 = "ECO_ISIC3_N"   if ilo_job1_eco_isic3==14
replace classif1 = "ECO_ISIC3_O"   if ilo_job1_eco_isic3==15
replace classif1 = "ECO_ISIC3_P"   if ilo_job1_eco_isic3==16
replace classif1 = "ECO_ISIC3_Q"   if ilo_job1_eco_isic3==17
replace classif1 = "ECO_ISIC3_X"   if ilo_job1_eco_isic3==18
