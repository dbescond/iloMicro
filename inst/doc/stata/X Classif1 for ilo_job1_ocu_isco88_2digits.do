
*This do-file generates the column classif1 for ilo_job1_ocu_isco88_2digits [Occupation (ISCO-88), 2 digits levels]
*It is separate because it will be used often.

/*
ilostat_code	code_level	code_label
ECO_ISCO88_0_01	1			01 - Armed forces
ECO_ISCO88_1_11	11			11 - Legislators and senior officials
ECO_ISCO88_1_12	12			12 - Corporate managers
ECO_ISCO88_1_13	13			13 - General managers
ECO_ISCO88_2_21	21			21 - Physical, mathematical and engineering science professionals
ECO_ISCO88_2_22	22			22 - Life science and health professionals
ECO_ISCO88_2_23	23			23 - Teaching professionals
ECO_ISCO88_2_24	24			24 - Other professionals
ECO_ISCO88_3_31	31			31 - Physical and engineering science associate professionals
ECO_ISCO88_3_32	32			32 - Life science and health associate professionals
ECO_ISCO88_3_33	33			33 - Teaching associate professionals
ECO_ISCO88_3_34	34			34 - Other associate professionals
ECO_ISCO88_4_41	41			41 - Office clerks
ECO_ISCO88_4_42	42			42 - Customer services clerks
ECO_ISCO88_5_51	51			51 - Personal and protective services workers
ECO_ISCO88_5_52	52			52 - Models, salespersons and demonstrators
ECO_ISCO88_6_61	61			61 - Skilled agricultural and fishery workers
ECO_ISCO88_7_71	71			71 - Extraction and building trades workers
ECO_ISCO88_7_72	72			72 - Metal, machinery and related trades workers
ECO_ISCO88_7_73	73			73 - Precision, handicraft, craft printing and related trades workers
ECO_ISCO88_7_74	74			74 - Other craft and related trades workers
ECO_ISCO88_8_81	81			81 - Stationary plant and related operators
ECO_ISCO88_8_82	82			82 - Machine operators and assemblers
ECO_ISCO88_8_83	83			83 - Drivers and mobile plant operators
ECO_ISCO88_9_91	91			91 - Sales and services elementary occupations
ECO_ISCO88_9_92	92			92 - Agricultural, fishery and related labourers
ECO_ISCO88_9_93	93			93 - Labourers in mining, construction, manufacturing and transport
*/

gen     classif1 = ""
replace classif1 = "ECO_ISCO88_0_01" if ilo_job1_ocu_isco88_2digits==1
replace classif1 = "ECO_ISCO88_1_11" if ilo_job1_ocu_isco88_2digits==11
replace classif1 = "ECO_ISCO88_1_12" if ilo_job1_ocu_isco88_2digits==12
replace classif1 = "ECO_ISCO88_1_13" if ilo_job1_ocu_isco88_2digits==13
replace classif1 = "ECO_ISCO88_2_21" if ilo_job1_ocu_isco88_2digits==21
replace classif1 = "ECO_ISCO88_2_22" if ilo_job1_ocu_isco88_2digits==22
replace classif1 = "ECO_ISCO88_2_23" if ilo_job1_ocu_isco88_2digits==23
replace classif1 = "ECO_ISCO88_2_24" if ilo_job1_ocu_isco88_2digits==24
replace classif1 = "ECO_ISCO88_3_31" if ilo_job1_ocu_isco88_2digits==31
replace classif1 = "ECO_ISCO88_3_32" if ilo_job1_ocu_isco88_2digits==32
replace classif1 = "ECO_ISCO88_3_33" if ilo_job1_ocu_isco88_2digits==33
replace classif1 = "ECO_ISCO88_3_34" if ilo_job1_ocu_isco88_2digits==34
replace classif1 = "ECO_ISCO88_4_41" if ilo_job1_ocu_isco88_2digits==41
replace classif1 = "ECO_ISCO88_4_42" if ilo_job1_ocu_isco88_2digits==42
replace classif1 = "ECO_ISCO88_5_51" if ilo_job1_ocu_isco88_2digits==51
replace classif1 = "ECO_ISCO88_5_52" if ilo_job1_ocu_isco88_2digits==52
replace classif1 = "ECO_ISCO88_6_61" if ilo_job1_ocu_isco88_2digits==61
replace classif1 = "ECO_ISCO88_7_71" if ilo_job1_ocu_isco88_2digits==71
replace classif1 = "ECO_ISCO88_7_72" if ilo_job1_ocu_isco88_2digits==72
replace classif1 = "ECO_ISCO88_7_73" if ilo_job1_ocu_isco88_2digits==73
replace classif1 = "ECO_ISCO88_7_74" if ilo_job1_ocu_isco88_2digits==74
replace classif1 = "ECO_ISCO88_8_81" if ilo_job1_ocu_isco88_2digits==81
replace classif1 = "ECO_ISCO88_8_82" if ilo_job1_ocu_isco88_2digits==82
replace classif1 = "ECO_ISCO88_8_83" if ilo_job1_ocu_isco88_2digits==83
replace classif1 = "ECO_ISCO88_9_91" if ilo_job1_ocu_isco88_2digits==91
replace classif1 = "ECO_ISCO88_9_92" if ilo_job1_ocu_isco88_2digits==92
replace classif1 = "ECO_ISCO88_9_93" if ilo_job1_ocu_isco88_2digits==93
