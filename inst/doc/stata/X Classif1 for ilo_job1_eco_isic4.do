
*This do-file generates the column classif1 for ilo_job1_eco_isic4 [Economic activity (ISIC Rev. 4)]
*It is separate because it will be used often.

/*
ilostat_code	code_level	code_label
ECO_ISIC4_A		1			A - Agriculture, forestry and fishing
ECO_ISIC4_B		2			B - Mining and quarrying
ECO_ISIC4_C		3			C - Manufacturing
ECO_ISIC4_D		4			D - Electricity, gas, steam and air conditioning supply
ECO_ISIC4_E		5			E - Water supply; sewerage, waste management and remediation activities
ECO_ISIC4_F		6			F - Construction
ECO_ISIC4_G		7			G - Wholesale and retail trade; repair of motor vehicles and motorcycles
ECO_ISIC4_H		8			H - Transportation and storage
ECO_ISIC4_I		9			I - Accommodation and food service activities
ECO_ISIC4_J		10			J - Information and communication
ECO_ISIC4_K		11			K - Financial and insurance activities
ECO_ISIC4_L		12			L - Real estate activities
ECO_ISIC4_M		13			M - Professional, scientific and technical activities
ECO_ISIC4_N		14			N - Administrative and support service activities
ECO_ISIC4_O		15			O - Public administration and defence; compulsory social security
ECO_ISIC4_P		16			P - Education
ECO_ISIC4_Q		17			Q - Human health and social work activities
ECO_ISIC4_R		18			R - Arts, entertainment and recreation
ECO_ISIC4_S		19			S - Other service activities
ECO_ISIC4_T		20			T - Activities of households as employers; undifferentiated goods- and services-producing activities of households for own use
ECO_ISIC4_U		21			U - Activities of extraterritorial organizations and bodies
ECO_ISIC4_X		22			X - Not elsewhere classified
*/

gen     classif1 = ""
replace classif1 = "ECO_ISIC4_A"   if ilo_job1_eco_isic4==1
replace classif1 = "ECO_ISIC4_B"   if ilo_job1_eco_isic4==2
replace classif1 = "ECO_ISIC4_C"   if ilo_job1_eco_isic4==3
replace classif1 = "ECO_ISIC4_D"   if ilo_job1_eco_isic4==4
replace classif1 = "ECO_ISIC4_E"   if ilo_job1_eco_isic4==5
replace classif1 = "ECO_ISIC4_F"   if ilo_job1_eco_isic4==6
replace classif1 = "ECO_ISIC4_G"   if ilo_job1_eco_isic4==7
replace classif1 = "ECO_ISIC4_H"   if ilo_job1_eco_isic4==8
replace classif1 = "ECO_ISIC4_I"   if ilo_job1_eco_isic4==9
replace classif1 = "ECO_ISIC4_J"   if ilo_job1_eco_isic4==10
replace classif1 = "ECO_ISIC4_K"   if ilo_job1_eco_isic4==11
replace classif1 = "ECO_ISIC4_L"   if ilo_job1_eco_isic4==12
replace classif1 = "ECO_ISIC4_M"   if ilo_job1_eco_isic4==13
replace classif1 = "ECO_ISIC4_N"   if ilo_job1_eco_isic4==14
replace classif1 = "ECO_ISIC4_O"   if ilo_job1_eco_isic4==15
replace classif1 = "ECO_ISIC4_P"   if ilo_job1_eco_isic4==16
replace classif1 = "ECO_ISIC4_Q"   if ilo_job1_eco_isic4==17
replace classif1 = "ECO_ISIC4_R"   if ilo_job1_eco_isic4==18
replace classif1 = "ECO_ISIC4_S"   if ilo_job1_eco_isic4==19
replace classif1 = "ECO_ISIC4_T"   if ilo_job1_eco_isic4==20
replace classif1 = "ECO_ISIC4_U"   if ilo_job1_eco_isic4==21
replace classif1 = "ECO_ISIC4_X"   if ilo_job1_eco_isic4==22
