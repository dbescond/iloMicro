
*This do-file generates the column classif1 for ilo_job1_eco_isic4_2digits [Economic activity (ISIC Rev. 4), 2 digits levels]
*It is separate because it will be used often.

/*
ilostat_code	code_level	code_label
ECO_ISIC4_A_01	1			01 - Crop and animal production, hunting and related service activities
ECO_ISIC4_A_02	2			02 - Forestry and logging
ECO_ISIC4_A_03	3			03 - Fishing and aquaculture
ECO_ISIC4_B_05	5			05 - Mining of coal and lignite
ECO_ISIC4_B_06	6			06 - Extraction of crude petroleum and natural gas
ECO_ISIC4_B_07	7			07 - Mining of metal ores
ECO_ISIC4_B_08	8			08 - Other mining and quarrying
ECO_ISIC4_B_09	9			09 - Mining support service activities
ECO_ISIC4_C_10	10			10 - Manufacture of food products
ECO_ISIC4_C_11	11			11 - Manufacture of beverages
ECO_ISIC4_C_12	12			12 - Manufacture of tobacco products
ECO_ISIC4_C_13	13			13 - Manufacture of textiles
ECO_ISIC4_C_14	14			14 - Manufacture of wearing apparel
ECO_ISIC4_C_15	15			15 - Manufacture of leather and related products
ECO_ISIC4_C_16	16			16 - Manufacture of wood and of products of wood and cork, except furniture; manufacture of articles of straw and plaiting materials
ECO_ISIC4_C_17	17			17 - Manufacture of paper and paper products
ECO_ISIC4_C_18	18			18 - Printing and reproduction of recorded media
ECO_ISIC4_C_19	19			19 - Manufacture of coke and refined petroleum products
ECO_ISIC4_C_20	20			20 - Manufacture of chemicals and chemical products
ECO_ISIC4_C_21	21			21 - Manufacture of basic pharmaceutical products and pharmaceutical preparations
ECO_ISIC4_C_22	22			22 - Manufacture of rubber and plastics products
ECO_ISIC4_C_23	23			23 - Manufacture of other non-metallic mineral products
ECO_ISIC4_C_24	24			24 - Manufacture of basic metals
ECO_ISIC4_C_25	25			25 - Manufacture of fabricated metal products, except machinery and equipment
ECO_ISIC4_C_26	26			26 - Manufacture of computer, electronic and optical products
ECO_ISIC4_C_27	27			27 - Manufacture of electrical equipment
ECO_ISIC4_C_28	28			28 - Manufacture of machinery and equipment n.e.c.
ECO_ISIC4_C_29	29			29 - Manufacture of motor vehicles, trailers and semi-trailers
ECO_ISIC4_C_30	30			30 - Manufacture of other transport equipment
ECO_ISIC4_C_31	31			31 - Manufacture of furniture
ECO_ISIC4_C_32	32			32 - Other manufacturing
ECO_ISIC4_C_33	33			33 - Repair and installation of machinery and equipment
ECO_ISIC4_D_35	35			35 - Electricity, gas, steam and air conditioning supply
ECO_ISIC4_E_36	36			36 - Water collection, treatment and supply
ECO_ISIC4_E_37	37			37 - Sewerage
ECO_ISIC4_E_38	38			38 - Waste collection, treatment and disposal activities; materials recovery
ECO_ISIC4_E_39	39			39 - Remediation activities and other waste management services
ECO_ISIC4_F_41	41			41 - Construction of buildings
ECO_ISIC4_F_42	42			42 - Civil engineering
ECO_ISIC4_F_43	43			43 - Specialized construction activities
ECO_ISIC4_G_45	45			45 - Wholesale and retail trade and repair of motor vehicles and motorcycles
ECO_ISIC4_G_46	46			46 - Wholesale trade, except of motor vehicles and motorcycles
ECO_ISIC4_G_47	47			47 - Retail trade, except of motor vehicles and motorcycles
ECO_ISIC4_H_49	49			49 - Land transport and transport via pipelines
ECO_ISIC4_H_50	50			50 - Water transport
ECO_ISIC4_H_51	51			51 - Air transport
ECO_ISIC4_H_52	52			52 - Warehousing and support activities for transportation
ECO_ISIC4_H_53	53			53 - Postal and courier activities
ECO_ISIC4_I_55	55			55 - Accommodation
ECO_ISIC4_I_56	56			56 - Food and beverage service activities
ECO_ISIC4_J_58	58			58 - Publishing activities
ECO_ISIC4_J_59	59			59 - Motion picture, video and television programme production, sound recording and music publishing activities
ECO_ISIC4_J_60	60			60 - Programming and broadcasting activities
ECO_ISIC4_J_61	61			61 - Telecommunications
ECO_ISIC4_J_62	62			62 - Computer programming, consultancy and related activities
ECO_ISIC4_J_63	63			63 - Information service activities
ECO_ISIC4_K_64	64			64 - Financial service activities, except insurance and pension funding
ECO_ISIC4_K_65	65			65 - Insurance, reinsurance and pension funding, except compulsory social security
ECO_ISIC4_K_66	66			66 - Activities auxiliary to financial service and insurance activities
ECO_ISIC4_L_68	68			68 - Real estate activities
ECO_ISIC4_M_69	69			69 - Legal and accounting activities
ECO_ISIC4_M_70	70			70 - Activities of head offices; management consultancy activities
ECO_ISIC4_M_71	71			71 - Architectural and engineering activities; technical testing and analysis
ECO_ISIC4_M_72	72			72 - Scientific research and development
ECO_ISIC4_M_73	73			73 - Advertising and market research
ECO_ISIC4_M_74	74			74 - Other professional, scientific and technical activities
ECO_ISIC4_M_75	75			75 - Veterinary activities
ECO_ISIC4_N_77	77			77 - Rental and leasing activities
ECO_ISIC4_N_78	78			78 - Employment activities
ECO_ISIC4_N_79	79			79 - Travel agency, tour operator, reservation service and related activities
ECO_ISIC4_N_80	80			80 - Security and investigation activities
ECO_ISIC4_N_81	81			81 - Services to buildings and landscape activities
ECO_ISIC4_N_82	82			82 - Office administrative, office support and other business support activities
ECO_ISIC4_O_84	84			84 - Public administration and defence; compulsory social security
ECO_ISIC4_P_85	85			85 - Education
ECO_ISIC4_Q_86	86			86 - Human health activities
ECO_ISIC4_Q_87	87			87 - Residential care activities
ECO_ISIC4_Q_88	88			88 - Social work activities without accommodation
ECO_ISIC4_R_90	90			90 - Creative, arts and entertainment activities
ECO_ISIC4_R_91	91			91 - Libraries, archives, museums and other cultural activities
ECO_ISIC4_R_92	92			92 - Gambling and betting activities
ECO_ISIC4_R_93	93			93 - Sports activities and amusement and recreation activities
ECO_ISIC4_S_94	94			94 - Activities of membership organizations
ECO_ISIC4_S_95	95			95 - Repair of computers and personal and household goods
ECO_ISIC4_S_96	96			96 - Other personal service activities
ECO_ISIC4_T_97	97			97 - Activities of households as employers of domestic personnel
ECO_ISIC4_T_98	98			98 - Undifferentiated goods- and services-producing activities of private households for own use
ECO_ISIC4_U_99	99			99 - Activities of extraterritorial organizations and bodies
*/

gen     classif1 = ""
replace classif1 = "ECO_ISIC4_A_01" if ilo_job1_eco_isic4_2digits==1
replace classif1 = "ECO_ISIC4_A_02" if ilo_job1_eco_isic4_2digits==2
replace classif1 = "ECO_ISIC4_A_03" if ilo_job1_eco_isic4_2digits==3
replace classif1 = "ECO_ISIC4_B_05" if ilo_job1_eco_isic4_2digits==5
replace classif1 = "ECO_ISIC4_B_06" if ilo_job1_eco_isic4_2digits==6
replace classif1 = "ECO_ISIC4_B_07" if ilo_job1_eco_isic4_2digits==7
replace classif1 = "ECO_ISIC4_B_08" if ilo_job1_eco_isic4_2digits==8
replace classif1 = "ECO_ISIC4_B_09" if ilo_job1_eco_isic4_2digits==9
replace classif1 = "ECO_ISIC4_C_10" if ilo_job1_eco_isic4_2digits==10
replace classif1 = "ECO_ISIC4_C_11" if ilo_job1_eco_isic4_2digits==11
replace classif1 = "ECO_ISIC4_C_12" if ilo_job1_eco_isic4_2digits==12
replace classif1 = "ECO_ISIC4_C_13" if ilo_job1_eco_isic4_2digits==13
replace classif1 = "ECO_ISIC4_C_14" if ilo_job1_eco_isic4_2digits==14
replace classif1 = "ECO_ISIC4_C_15" if ilo_job1_eco_isic4_2digits==15
replace classif1 = "ECO_ISIC4_C_16" if ilo_job1_eco_isic4_2digits==16
replace classif1 = "ECO_ISIC4_C_17" if ilo_job1_eco_isic4_2digits==17
replace classif1 = "ECO_ISIC4_C_18" if ilo_job1_eco_isic4_2digits==18
replace classif1 = "ECO_ISIC4_C_19" if ilo_job1_eco_isic4_2digits==19
replace classif1 = "ECO_ISIC4_C_20" if ilo_job1_eco_isic4_2digits==20
replace classif1 = "ECO_ISIC4_C_21" if ilo_job1_eco_isic4_2digits==21
replace classif1 = "ECO_ISIC4_C_22" if ilo_job1_eco_isic4_2digits==22
replace classif1 = "ECO_ISIC4_C_23" if ilo_job1_eco_isic4_2digits==23
replace classif1 = "ECO_ISIC4_C_24" if ilo_job1_eco_isic4_2digits==24
replace classif1 = "ECO_ISIC4_C_25" if ilo_job1_eco_isic4_2digits==25
replace classif1 = "ECO_ISIC4_C_26" if ilo_job1_eco_isic4_2digits==26
replace classif1 = "ECO_ISIC4_C_27" if ilo_job1_eco_isic4_2digits==27
replace classif1 = "ECO_ISIC4_C_28" if ilo_job1_eco_isic4_2digits==28
replace classif1 = "ECO_ISIC4_C_29" if ilo_job1_eco_isic4_2digits==29
replace classif1 = "ECO_ISIC4_C_30" if ilo_job1_eco_isic4_2digits==30
replace classif1 = "ECO_ISIC4_C_31" if ilo_job1_eco_isic4_2digits==31
replace classif1 = "ECO_ISIC4_C_32" if ilo_job1_eco_isic4_2digits==32
replace classif1 = "ECO_ISIC4_C_33" if ilo_job1_eco_isic4_2digits==33
replace classif1 = "ECO_ISIC4_D_35" if ilo_job1_eco_isic4_2digits==35
replace classif1 = "ECO_ISIC4_E_36" if ilo_job1_eco_isic4_2digits==36
replace classif1 = "ECO_ISIC4_E_37" if ilo_job1_eco_isic4_2digits==37
replace classif1 = "ECO_ISIC4_E_38" if ilo_job1_eco_isic4_2digits==38
replace classif1 = "ECO_ISIC4_E_39" if ilo_job1_eco_isic4_2digits==39
replace classif1 = "ECO_ISIC4_F_41" if ilo_job1_eco_isic4_2digits==41
replace classif1 = "ECO_ISIC4_F_42" if ilo_job1_eco_isic4_2digits==42
replace classif1 = "ECO_ISIC4_F_43" if ilo_job1_eco_isic4_2digits==43
replace classif1 = "ECO_ISIC4_G_45" if ilo_job1_eco_isic4_2digits==45
replace classif1 = "ECO_ISIC4_G_46" if ilo_job1_eco_isic4_2digits==46
replace classif1 = "ECO_ISIC4_G_47" if ilo_job1_eco_isic4_2digits==47
replace classif1 = "ECO_ISIC4_H_49" if ilo_job1_eco_isic4_2digits==49
replace classif1 = "ECO_ISIC4_H_50" if ilo_job1_eco_isic4_2digits==50
replace classif1 = "ECO_ISIC4_H_51" if ilo_job1_eco_isic4_2digits==51
replace classif1 = "ECO_ISIC4_H_52" if ilo_job1_eco_isic4_2digits==52
replace classif1 = "ECO_ISIC4_H_53" if ilo_job1_eco_isic4_2digits==53
replace classif1 = "ECO_ISIC4_I_55" if ilo_job1_eco_isic4_2digits==55
replace classif1 = "ECO_ISIC4_I_56" if ilo_job1_eco_isic4_2digits==56
replace classif1 = "ECO_ISIC4_J_58" if ilo_job1_eco_isic4_2digits==58
replace classif1 = "ECO_ISIC4_J_59" if ilo_job1_eco_isic4_2digits==59
replace classif1 = "ECO_ISIC4_J_60" if ilo_job1_eco_isic4_2digits==60
replace classif1 = "ECO_ISIC4_J_61" if ilo_job1_eco_isic4_2digits==61
replace classif1 = "ECO_ISIC4_J_62" if ilo_job1_eco_isic4_2digits==62
replace classif1 = "ECO_ISIC4_J_63" if ilo_job1_eco_isic4_2digits==63
replace classif1 = "ECO_ISIC4_K_64" if ilo_job1_eco_isic4_2digits==64
replace classif1 = "ECO_ISIC4_K_65" if ilo_job1_eco_isic4_2digits==65
replace classif1 = "ECO_ISIC4_K_66" if ilo_job1_eco_isic4_2digits==66
replace classif1 = "ECO_ISIC4_L_68" if ilo_job1_eco_isic4_2digits==68
replace classif1 = "ECO_ISIC4_M_69" if ilo_job1_eco_isic4_2digits==69
replace classif1 = "ECO_ISIC4_M_70" if ilo_job1_eco_isic4_2digits==70
replace classif1 = "ECO_ISIC4_M_71" if ilo_job1_eco_isic4_2digits==71
replace classif1 = "ECO_ISIC4_M_72" if ilo_job1_eco_isic4_2digits==72
replace classif1 = "ECO_ISIC4_M_73" if ilo_job1_eco_isic4_2digits==73
replace classif1 = "ECO_ISIC4_M_74" if ilo_job1_eco_isic4_2digits==74
replace classif1 = "ECO_ISIC4_M_75" if ilo_job1_eco_isic4_2digits==75
replace classif1 = "ECO_ISIC4_N_77" if ilo_job1_eco_isic4_2digits==77
replace classif1 = "ECO_ISIC4_N_78" if ilo_job1_eco_isic4_2digits==78
replace classif1 = "ECO_ISIC4_N_79" if ilo_job1_eco_isic4_2digits==79
replace classif1 = "ECO_ISIC4_N_80" if ilo_job1_eco_isic4_2digits==80
replace classif1 = "ECO_ISIC4_N_81" if ilo_job1_eco_isic4_2digits==81
replace classif1 = "ECO_ISIC4_N_82" if ilo_job1_eco_isic4_2digits==82
replace classif1 = "ECO_ISIC4_O_84" if ilo_job1_eco_isic4_2digits==84
replace classif1 = "ECO_ISIC4_P_85" if ilo_job1_eco_isic4_2digits==85
replace classif1 = "ECO_ISIC4_Q_86" if ilo_job1_eco_isic4_2digits==86
replace classif1 = "ECO_ISIC4_Q_87" if ilo_job1_eco_isic4_2digits==87
replace classif1 = "ECO_ISIC4_Q_88" if ilo_job1_eco_isic4_2digits==88
replace classif1 = "ECO_ISIC4_R_90" if ilo_job1_eco_isic4_2digits==90
replace classif1 = "ECO_ISIC4_R_91" if ilo_job1_eco_isic4_2digits==91
replace classif1 = "ECO_ISIC4_R_92" if ilo_job1_eco_isic4_2digits==92
replace classif1 = "ECO_ISIC4_R_93" if ilo_job1_eco_isic4_2digits==93
replace classif1 = "ECO_ISIC4_S_94" if ilo_job1_eco_isic4_2digits==94
replace classif1 = "ECO_ISIC4_S_95" if ilo_job1_eco_isic4_2digits==95
replace classif1 = "ECO_ISIC4_S_96" if ilo_job1_eco_isic4_2digits==96
replace classif1 = "ECO_ISIC4_T_97" if ilo_job1_eco_isic4_2digits==97
replace classif1 = "ECO_ISIC4_T_98" if ilo_job1_eco_isic4_2digits==98
replace classif1 = "ECO_ISIC4_U_99" if ilo_job1_eco_isic4_2digits==99
