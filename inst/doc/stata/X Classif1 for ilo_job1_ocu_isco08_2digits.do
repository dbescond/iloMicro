
*This do-file generates the column classif1 for ilo_job1_ocu_isco08_2digits [Occupation (ISCO-08), 2 digits levels]
*It is separate because it will be used often.

/*
ilostat_code	code_level	code_label
ECO_ISCO08_0_01	1			01 - Commissioned armed forces officers
ECO_ISCO08_0_02	2			02 - Non-commissioned armed forces officers
ECO_ISCO08_0_03	3			03 - Armed forces occupations, other ranks
ECO_ISCO08_1_11	11			11 - Chief executives, senior officials and legislators
ECO_ISCO08_1_12	12			12 - Administrative and commercial managers
ECO_ISCO08_1_13	13			13 - Production and specialised services managers
ECO_ISCO08_1_14	14			14 - Hospitality, retail and other services managers
ECO_ISCO08_2_21	21			21 - Science and engineering professionals
ECO_ISCO08_2_22	22			22 - Health professionals
ECO_ISCO08_2_23	23			23 - Teaching professionals
ECO_ISCO08_2_24	24			24 - Business and administration professionals
ECO_ISCO08_2_25	25			25 - Information and communications technology professionals
ECO_ISCO08_2_26	26			26 - Legal, social and cultural professionals
ECO_ISCO08_3_31	31			31 - Science and engineering associate professionals
ECO_ISCO08_3_32	32			32 - Health associate professionals
ECO_ISCO08_3_33	33			33 - Business and administration associate professionals
ECO_ISCO08_3_34	34			34 - Legal, social, cultural and related associate professionals
ECO_ISCO08_3_35	35			35 - Information and communications technicians
ECO_ISCO08_4_41	41			41 - General and keyboard clerks
ECO_ISCO08_4_42	42			42 - Customer services clerks
ECO_ISCO08_4_43	43			43 - Numerical and material recording clerks
ECO_ISCO08_4_44	44			44 - Other clerical support workers
ECO_ISCO08_5_51	51			51 - Personal service workers
ECO_ISCO08_5_52	52			52 - Sales workers
ECO_ISCO08_5_53	53			53 - Personal care workers
ECO_ISCO08_5_54	54			54 - Protective services workers
ECO_ISCO08_6_61	61			61 - Market-oriented skilled agricultural workers
ECO_ISCO08_6_62	62			62 - Market-oriented skilled forestry, fishery and hunting workers
ECO_ISCO08_6_63	63			63 - Subsistence farmers, fishers, hunters and gatherers
ECO_ISCO08_7_71	71			71 - Building and related trades workers, excluding electricians
ECO_ISCO08_7_72	72			72 - Metal, machinery and related trades workers
ECO_ISCO08_7_73	73			73 - Handicraft and printing workers
ECO_ISCO08_7_74	74			74 - Electrical and electronic trades workers
ECO_ISCO08_7_75	75			75 - Food processing, wood working, garment and other craft and related trades workers
ECO_ISCO08_8_81	81			81 - Stationary plant and machine operators
ECO_ISCO08_8_82	82			82 - Assemblers
ECO_ISCO08_8_83	83			83 - Drivers and mobile plant operators
ECO_ISCO08_9_91	91			91 - Cleaners and helpers
ECO_ISCO08_9_92	92			92 - Agricultural, forestry and fishery labourers
ECO_ISCO08_9_93	93			93 - Labourers in mining, construction, manufacturing and transport
ECO_ISCO08_9_94	94			94 - Food preparation assistants
ECO_ISCO08_9_95	95			95 - Street and related sales and service workers
ECO_ISCO08_9_96	96			96 - Refuse workers and other elementary workers
*/

gen     classif1 = ""
replace classif1 = "ECO_ISCO08_0_01" if ilo_job1_ocu_isco08_2digits==1
replace classif1 = "ECO_ISCO08_0_02" if ilo_job1_ocu_isco08_2digits==2
replace classif1 = "ECO_ISCO08_0_03" if ilo_job1_ocu_isco08_2digits==3
replace classif1 = "ECO_ISCO08_1_11" if ilo_job1_ocu_isco08_2digits==11
replace classif1 = "ECO_ISCO08_1_12" if ilo_job1_ocu_isco08_2digits==12
replace classif1 = "ECO_ISCO08_1_13" if ilo_job1_ocu_isco08_2digits==13
replace classif1 = "ECO_ISCO08_1_14" if ilo_job1_ocu_isco08_2digits==14
replace classif1 = "ECO_ISCO08_2_21" if ilo_job1_ocu_isco08_2digits==21
replace classif1 = "ECO_ISCO08_2_22" if ilo_job1_ocu_isco08_2digits==22
replace classif1 = "ECO_ISCO08_2_23" if ilo_job1_ocu_isco08_2digits==23
replace classif1 = "ECO_ISCO08_2_24" if ilo_job1_ocu_isco08_2digits==24
replace classif1 = "ECO_ISCO08_2_25" if ilo_job1_ocu_isco08_2digits==25
replace classif1 = "ECO_ISCO08_2_26" if ilo_job1_ocu_isco08_2digits==26
replace classif1 = "ECO_ISCO08_3_31" if ilo_job1_ocu_isco08_2digits==31
replace classif1 = "ECO_ISCO08_3_32" if ilo_job1_ocu_isco08_2digits==32
replace classif1 = "ECO_ISCO08_3_33" if ilo_job1_ocu_isco08_2digits==33
replace classif1 = "ECO_ISCO08_3_34" if ilo_job1_ocu_isco08_2digits==34
replace classif1 = "ECO_ISCO08_3_35" if ilo_job1_ocu_isco08_2digits==35
replace classif1 = "ECO_ISCO08_4_41" if ilo_job1_ocu_isco08_2digits==41
replace classif1 = "ECO_ISCO08_4_42" if ilo_job1_ocu_isco08_2digits==42
replace classif1 = "ECO_ISCO08_4_43" if ilo_job1_ocu_isco08_2digits==43
replace classif1 = "ECO_ISCO08_4_44" if ilo_job1_ocu_isco08_2digits==44
replace classif1 = "ECO_ISCO08_5_51" if ilo_job1_ocu_isco08_2digits==51
replace classif1 = "ECO_ISCO08_5_52" if ilo_job1_ocu_isco08_2digits==52
replace classif1 = "ECO_ISCO08_5_53" if ilo_job1_ocu_isco08_2digits==53
replace classif1 = "ECO_ISCO08_5_54" if ilo_job1_ocu_isco08_2digits==54
replace classif1 = "ECO_ISCO08_6_61" if ilo_job1_ocu_isco08_2digits==61
replace classif1 = "ECO_ISCO08_6_62" if ilo_job1_ocu_isco08_2digits==62
replace classif1 = "ECO_ISCO08_6_63" if ilo_job1_ocu_isco08_2digits==63
replace classif1 = "ECO_ISCO08_7_71" if ilo_job1_ocu_isco08_2digits==71
replace classif1 = "ECO_ISCO08_7_72" if ilo_job1_ocu_isco08_2digits==72
replace classif1 = "ECO_ISCO08_7_73" if ilo_job1_ocu_isco08_2digits==73
replace classif1 = "ECO_ISCO08_7_74" if ilo_job1_ocu_isco08_2digits==74
replace classif1 = "ECO_ISCO08_7_75" if ilo_job1_ocu_isco08_2digits==75
replace classif1 = "ECO_ISCO08_8_81" if ilo_job1_ocu_isco08_2digits==81
replace classif1 = "ECO_ISCO08_8_82" if ilo_job1_ocu_isco08_2digits==82
replace classif1 = "ECO_ISCO08_8_83" if ilo_job1_ocu_isco08_2digits==83
replace classif1 = "ECO_ISCO08_9_91" if ilo_job1_ocu_isco08_2digits==91
replace classif1 = "ECO_ISCO08_9_92" if ilo_job1_ocu_isco08_2digits==92
replace classif1 = "ECO_ISCO08_9_93" if ilo_job1_ocu_isco08_2digits==93
replace classif1 = "ECO_ISCO08_9_94" if ilo_job1_ocu_isco08_2digits==94
replace classif1 = "ECO_ISCO08_9_95" if ilo_job1_ocu_isco08_2digits==95
replace classif1 = "ECO_ISCO08_9_96" if ilo_job1_ocu_isco08_2digits==96
