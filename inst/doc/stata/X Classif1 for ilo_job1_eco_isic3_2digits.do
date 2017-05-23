
*This do-file generates the column classif1 for ilo_job1_eco_isic3_2digits [Economic activity (ISIC Rev. 3.1), 2 digits levels]
*It is separate because it will be used often.

/*
ilostat_code	code_level	code_label
ECO_ISIC3_A_01	1			01 - Agriculture, hunting and related service activities
ECO_ISIC3_A_02	2			02 - Forestry, logging and related service activities
ECO_ISIC3_B_05	5			05 - Fishing, operation of fish hatcheries and fish farms; service activities incidental to fishing
ECO_ISIC3_C_10	10			10 - Mining of coal and lignite; extraction of peat
ECO_ISIC3_C_11	11			11 - Extraction of crude petroleum and natural gas; service activities incidental to oil and gas extraction excluding surveying
ECO_ISIC3_C_12	12			12 - Mining of uranium and thorium ores
ECO_ISIC3_C_13	13			13 - Mining of metal ores
ECO_ISIC3_C_14	14			14 - Other mining and quarrying
ECO_ISIC3_D_15	15			15 - Manufacture of food products and beverages
ECO_ISIC3_D_16	16			16 - Manufacture of tobacco products
ECO_ISIC3_D_17	17			17 - Manufacture of textiles
ECO_ISIC3_D_18	18			18 - Manufacture of wearing apparel; dressing and dyeing of fur
ECO_ISIC3_D_19	19			19 - Tanning and dressing of leather; manufacture of luggage, handbags, saddlery, harness and footwear
ECO_ISIC3_D_20	20			20 - Manufacture of wood and of products of wood and cork, except furniture; manufacture of articles of straw and plaiting materials
ECO_ISIC3_D_21	21			21 - Manufacture of paper and paper products
ECO_ISIC3_D_22	22			22 - Publishing, printing and reproduction of recorded media
ECO_ISIC3_D_23	23			23 - Manufacture of coke, refined petroleum products and nuclear fuel
ECO_ISIC3_D_24	24			24 - Manufacture of chemicals and chemical products
ECO_ISIC3_D_25	25			25 - Manufacture of rubber and plastics products
ECO_ISIC3_D_26	26			26 - Manufacture of other non-metallic mineral products
ECO_ISIC3_D_27	27			27 - Manufacture of basic metals
ECO_ISIC3_D_28	28			28 - Manufacture of fabricated metal products, except machinery and equipment
ECO_ISIC3_D_29	29			29 - Manufacture of machinery and equipment n.e.c.
ECO_ISIC3_D_30	30			30 - Manufacture of office, accounting and computing machinery
ECO_ISIC3_D_31	31			31 - Manufacture of electrical machinery and apparatus n.e.c.
ECO_ISIC3_D_32	32			32 - Manufacture of radio, television and communication equipment and apparatus
ECO_ISIC3_D_33	33			33 - Manufacture of medical, precision and optical instruments, watches and clocks
ECO_ISIC3_D_34	34			34 - Manufacture of motor vehicles, trailers and semi-trailers
ECO_ISIC3_D_35	35			35 - Manufacture of other transport equipment
ECO_ISIC3_D_36	36			36 - Manufacture of furniture; manufacturing n.e.c.
ECO_ISIC3_D_37	37			37 - Recycling
ECO_ISIC3_E_40	40			40 - Electricity, gas, steam and hot water supply
ECO_ISIC3_E_41	41			41 - Collection, purification and distribution of water
ECO_ISIC3_F_45	45			45 - Construction
ECO_ISIC3_G_50	50			50 - Sale, maintenance and repair of motor vehicles and motorcycles; retail sale of automotive fuel
ECO_ISIC3_G_51	51			51 - Wholesale trade and commission trade, except of motor vehicles and motorcycles
ECO_ISIC3_G_52	52			52 - Retail trade, except of motor vehicles and motorcycles; repair of personal and household goods
ECO_ISIC3_H_55	55			55 - Hotels and restaurants
ECO_ISIC3_I_60	60			60 - Land transport; transport via pipelines
ECO_ISIC3_I_61	61			61 - Water transport
ECO_ISIC3_I_62	62			62 - Air transport
ECO_ISIC3_I_63	63			63 - Supporting and auxiliary transport activities; activities of travel agencies
ECO_ISIC3_I_64	64			64 - Post and telecommunications
ECO_ISIC3_J_65	65			65 - Financial intermediation, except insurance and pension funding
ECO_ISIC3_J_66	66			66 - Insurance and pension funding, except compulsory social security
ECO_ISIC3_J_67	67			67 - Activities auxiliary to financial intermediation
ECO_ISIC3_K_70	70			70 - Real estate activities
ECO_ISIC3_K_71	71			71 - Renting of machinery and equipment without operator and of personal and household goods
ECO_ISIC3_K_72	72			72 - Computer and related activities
ECO_ISIC3_K_73	73			73 - Research and development
ECO_ISIC3_K_74	74			74 - Other business activities
ECO_ISIC3_L_75	75			75 - Public administration and defence; compulsory social security
ECO_ISIC3_M_80	80			80 - Education
ECO_ISIC3_N_85	85			85 - Health and social work
ECO_ISIC3_O_90	90			90 - Sewage and refuse disposal, sanitation and similar activities
ECO_ISIC3_O_91	91			91 - Activities of membership organizations n.e.c.
ECO_ISIC3_O_92	92			92 - Recreational, cultural and sporting activities
ECO_ISIC3_O_93	93			93 - Other service activities
ECO_ISIC3_P_95	95			95 - Activities of private households as employers of domestic staff
ECO_ISIC3_P_96	96			96 - Undifferentiated goods-producing activities of private households for own use
ECO_ISIC3_P_97	97			97 - Undifferentiated service-producing activities of private households for own use
ECO_ISIC3_Q_99	99			99 - Extra-territorial organizations and bodies
*/

gen     classif1 = ""
replace classif1 = "ECO_ISIC3_A_01" if ilo_job1_eco_isic3_2digits==1
replace classif1 = "ECO_ISIC3_A_02" if ilo_job1_eco_isic3_2digits==2
replace classif1 = "ECO_ISIC3_B_05" if ilo_job1_eco_isic3_2digits==5
replace classif1 = "ECO_ISIC3_C_10" if ilo_job1_eco_isic3_2digits==10
replace classif1 = "ECO_ISIC3_C_11" if ilo_job1_eco_isic3_2digits==11
replace classif1 = "ECO_ISIC3_C_12" if ilo_job1_eco_isic3_2digits==12
replace classif1 = "ECO_ISIC3_C_13" if ilo_job1_eco_isic3_2digits==13
replace classif1 = "ECO_ISIC3_C_14" if ilo_job1_eco_isic3_2digits==14
replace classif1 = "ECO_ISIC3_D_15" if ilo_job1_eco_isic3_2digits==15
replace classif1 = "ECO_ISIC3_D_16" if ilo_job1_eco_isic3_2digits==16
replace classif1 = "ECO_ISIC3_D_17" if ilo_job1_eco_isic3_2digits==17
replace classif1 = "ECO_ISIC3_D_18" if ilo_job1_eco_isic3_2digits==18
replace classif1 = "ECO_ISIC3_D_19" if ilo_job1_eco_isic3_2digits==19
replace classif1 = "ECO_ISIC3_D_20" if ilo_job1_eco_isic3_2digits==20
replace classif1 = "ECO_ISIC3_D_21" if ilo_job1_eco_isic3_2digits==21
replace classif1 = "ECO_ISIC3_D_22" if ilo_job1_eco_isic3_2digits==22
replace classif1 = "ECO_ISIC3_D_23" if ilo_job1_eco_isic3_2digits==23
replace classif1 = "ECO_ISIC3_D_24" if ilo_job1_eco_isic3_2digits==24
replace classif1 = "ECO_ISIC3_D_25" if ilo_job1_eco_isic3_2digits==25
replace classif1 = "ECO_ISIC3_D_26" if ilo_job1_eco_isic3_2digits==26
replace classif1 = "ECO_ISIC3_D_27" if ilo_job1_eco_isic3_2digits==27
replace classif1 = "ECO_ISIC3_D_28" if ilo_job1_eco_isic3_2digits==28
replace classif1 = "ECO_ISIC3_D_29" if ilo_job1_eco_isic3_2digits==29
replace classif1 = "ECO_ISIC3_D_30" if ilo_job1_eco_isic3_2digits==30
replace classif1 = "ECO_ISIC3_D_31" if ilo_job1_eco_isic3_2digits==31
replace classif1 = "ECO_ISIC3_D_32" if ilo_job1_eco_isic3_2digits==32
replace classif1 = "ECO_ISIC3_D_33" if ilo_job1_eco_isic3_2digits==33
replace classif1 = "ECO_ISIC3_D_34" if ilo_job1_eco_isic3_2digits==34
replace classif1 = "ECO_ISIC3_D_35" if ilo_job1_eco_isic3_2digits==35
replace classif1 = "ECO_ISIC3_D_36" if ilo_job1_eco_isic3_2digits==36
replace classif1 = "ECO_ISIC3_D_37" if ilo_job1_eco_isic3_2digits==37
replace classif1 = "ECO_ISIC3_E_40" if ilo_job1_eco_isic3_2digits==40
replace classif1 = "ECO_ISIC3_E_41" if ilo_job1_eco_isic3_2digits==41
replace classif1 = "ECO_ISIC3_F_45" if ilo_job1_eco_isic3_2digits==45
replace classif1 = "ECO_ISIC3_G_50" if ilo_job1_eco_isic3_2digits==50
replace classif1 = "ECO_ISIC3_G_51" if ilo_job1_eco_isic3_2digits==51
replace classif1 = "ECO_ISIC3_G_52" if ilo_job1_eco_isic3_2digits==52
replace classif1 = "ECO_ISIC3_H_55" if ilo_job1_eco_isic3_2digits==55
replace classif1 = "ECO_ISIC3_I_60" if ilo_job1_eco_isic3_2digits==60
replace classif1 = "ECO_ISIC3_I_61" if ilo_job1_eco_isic3_2digits==61
replace classif1 = "ECO_ISIC3_I_62" if ilo_job1_eco_isic3_2digits==62
replace classif1 = "ECO_ISIC3_I_63" if ilo_job1_eco_isic3_2digits==63
replace classif1 = "ECO_ISIC3_I_64" if ilo_job1_eco_isic3_2digits==64
replace classif1 = "ECO_ISIC3_J_65" if ilo_job1_eco_isic3_2digits==65
replace classif1 = "ECO_ISIC3_J_66" if ilo_job1_eco_isic3_2digits==66
replace classif1 = "ECO_ISIC3_J_67" if ilo_job1_eco_isic3_2digits==67
replace classif1 = "ECO_ISIC3_K_70" if ilo_job1_eco_isic3_2digits==70
replace classif1 = "ECO_ISIC3_K_71" if ilo_job1_eco_isic3_2digits==71
replace classif1 = "ECO_ISIC3_K_72" if ilo_job1_eco_isic3_2digits==72
replace classif1 = "ECO_ISIC3_K_73" if ilo_job1_eco_isic3_2digits==73
replace classif1 = "ECO_ISIC3_K_74" if ilo_job1_eco_isic3_2digits==74
replace classif1 = "ECO_ISIC3_L_75" if ilo_job1_eco_isic3_2digits==75
replace classif1 = "ECO_ISIC3_M_80" if ilo_job1_eco_isic3_2digits==80
replace classif1 = "ECO_ISIC3_N_85" if ilo_job1_eco_isic3_2digits==85
replace classif1 = "ECO_ISIC3_O_90" if ilo_job1_eco_isic3_2digits==90
replace classif1 = "ECO_ISIC3_O_91" if ilo_job1_eco_isic3_2digits==91
replace classif1 = "ECO_ISIC3_O_92" if ilo_job1_eco_isic3_2digits==92
replace classif1 = "ECO_ISIC3_O_93" if ilo_job1_eco_isic3_2digits==93
replace classif1 = "ECO_ISIC3_P_95" if ilo_job1_eco_isic3_2digits==95
replace classif1 = "ECO_ISIC3_P_96" if ilo_job1_eco_isic3_2digits==96
replace classif1 = "ECO_ISIC3_P_97" if ilo_job1_eco_isic3_2digits==97
replace classif1 = "ECO_ISIC3_Q_99" if ilo_job1_eco_isic3_2digits==99
