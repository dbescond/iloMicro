* TITLE OF DO FILE: ILO Microdata Preprocessing code template - BOL HS 2014
* DATASET USED: BOL HS 2014
* NOTES:
* Author: Roger Gomis

* Starting Date: 20 February 2017
* Last updated: 08 February 2018
***********************************************************************************************


***********************************************************************************************
***********************************************************************************************

* 			1. SET UP WORK DIRECTORY, FILE NAME, VARIABLES AND FUNCTIONS

***********************************************************************************************
***********************************************************************************************

clear all 

set more off

global path "J:\DPAU\MICRO"
global country "HND"
global source "EPHPM"
global time "2014"
global inputFile "Hogares_2014"

global inpath "${path}\\${country}\\${source}\\${time}\ORI"
global temppath "${path}\_Admin"
global outpath "${path}\\${country}\\${source}\\${time}"

********************************************************************************
********************************************************************************

cd "$inpath"
	use ${inputFile}, clear
	*renaming everything in lower case
	rename *, lower  
	
***********************************************************************************************
***********************************************************************************************

*			2. MAP VARIABLES

***********************************************************************************************
***********************************************************************************************



* ---------------------------------------------------------------------------------------------
***********************************************************************************************
*			PART 1. DATASET SETTINGS VARIABLES
***********************************************************************************************
* ---------------------------------------------------------------------------------------------
rename *, lower

if ${time} ==2014|${time} >=2015 {
 replace dominio=5 if dominio==4
}

if ${time} ==2013 | ${time} ==2012  {

 capture rename *ce44_* *ce444_*
 
 foreach var of varlist ce448-ce476 {
 rename `var' test_`var'
 }
 
 rename test_ce449 ce448
 rename test_ce454 ce453
 rename test_ce474 ce472
 
 
}


if ${time} ==2011 {

*Filtering out one case
drop if sexo==.

rename ed03 ed103
rename ed07 ed107
rename ed05 ed105
rename ed08 ed108
rename ed10 ed110



rename ce01 ce401
rename ce02 ce402
rename ce03 ce403
rename ce04 ce404
rename ce05 ce405
rename ce06 ce406
rename ce07 ce407
rename ce08 ce408
rename ce09 ce409
rename ce10 ce410
rename ce11 ce411
rename ce11tiempo ce411tiempo
rename ce12 ce412
rename ce13 ce413
rename ce14 ce414
rename ce15cod ce415cod
rename ce16cod ce416cod
rename ce17 ce417
rename ce17_tiempo ce417_tiempo
rename ce18 ce418
rename ce19 ce419
rename ce20 ce420
rename ce21 ce421
rename ce22 ce422
rename ce23_1 ce423_1
rename ce23_2 ce423_2
rename ce23_3 ce423_3
rename ce23_4 ce423_4
rename ce23_5 ce423_5
rename ce23_6 ce423_6
rename ce23_7 ce423_7
rename ce23_8 ce423_8
rename ce23_9 ce423_9
rename ce23_10 ce423_10
rename ce23_11 ce423_11
rename ce24 ce424
rename ce25cod ce425cod
rename ce28cod ce428cod
rename ce29 ce429
rename ce30 ce430
rename ce31 ce432
*
rename ce32 ce431
replace ce431=ce63 if ce431==.&ce63!=.

rename ce32_cantidad ce431_cantidad
rename ce34 ce433
rename ce36 ce434
rename ce37 ce435
rename ce38 ce436
rename ce39 ce437
rename ce40_1 ce438_1
rename ce40_2 ce438_2
rename ce40_3 ce438_3
rename ce40_4 ce438_4
rename ce40_5 ce438_5
rename ce40_6 ce438_6
rename ce40_7 ce438_7
rename ce40_8 ce438_8
rename ce40_9 ce438_9
rename ce40_10 ce438_10
rename ce40_11 ce438_11
rename ce41 ce439
rename ce42 ce440
rename ce43 ce441
rename ce44 ce442_a
rename ce45 ce442a
rename ce46 ce442_r
rename ce47 ce442r
rename ce48 ce442_h
rename ce49 ce442h
rename ce50 ce442_t
rename ce51 ce442t
rename ce52 ce442_c
rename ce53 ce442c
rename ce54 ce442_b
rename ce55 ce442b
rename ce56 ce442_p
rename ce57 ce442p
rename ce58 ce442_e
rename ce59 ce442e
rename ce60 ce442_o
rename ce61 ce442o
rename ce65 ce443
rename ce66_1 ce444_1
rename ce66_2 ce444_2
rename ce66_3 ce444_3
rename ce66_4 ce444_4
rename ce66_5 ce444_5
rename ce67 ce445
rename ce69 ce446
rename ce70 ce447
rename ce72 ce448
rename ce73cod ce449cod
rename ce76cod ce452cod
rename ce77 ce453
rename ce78 ce454
rename ce79 ce456
rename ce80 ce455
rename ce80_cantidad ce455_cantidad
rename ce82 ce457
rename ce84 ce458
rename ce85 ce459
rename ce86 ce460
rename ce87 ce461
rename ce88_1 ce462_1
rename ce88_2 ce462_2
rename ce88_3 ce462_3
rename ce88_4 ce462_4
rename ce88_5 ce462_5
rename ce88_6 ce462_6
rename ce88_7 ce462_7
rename ce88_8 ce462_8
rename ce88_9 ce462_9
rename ce88_10 ce462_10
rename ce88_11 ce462_11
rename ce89 ce463
rename ce90 ce464
rename ce91 ce465
rename ce92 ce466_a
rename ce93 ce466a
rename ce94 ce466_r
rename ce95 ce466r
rename ce96 ce466_h
rename ce97 ce466h
rename ce98 ce466_t
rename ce99 ce466t
rename ce100 ce466_c
rename ce101 ce466c
rename ce102 ce466_b
rename ce103 ce466b
rename ce104 ce466_p
rename ce105 ce466p
rename ce106 ce466_e
rename ce107 ce466e
rename ce108 ce466_o
rename ce109 ce466o
rename ce110 ce467
rename ce114_1 ce468_1
rename ce114_2 ce468_2
rename ce114_3 ce468_3
rename ce114_4 ce468_4
rename ce114_5 ce468_5
rename ce115 ce469
rename ce117 ce470
rename ce118 ce471
rename ce120 ce472
rename ce121 ce473
rename ce122 ce474



}

if ${time} ==2010 {


rename ed03 ed103
rename ed07 ed107
rename ed05 ed105
rename ed08 ed108
rename ed10 ed110



rename ce01 ce401
rename ce02 ce402
rename ce03 ce403
rename ce04 ce404
rename ce05 ce405
rename ce06 ce406
rename ce07 ce407
rename ce08 ce408
rename ce09 ce409
rename ce10 ce410
rename ce11 ce411
rename ce11tiempo ce411tiempo
rename ce12 ce412
rename ce13 ce413
rename ce14 ce414
rename ce15cod ce415cod
rename ce16cod ce416cod
rename ce17 ce417
rename ce17_tiempo ce417_tiempo
rename ce18 ce418
rename ce19 ce419
rename ce20 ce420
rename ce21 ce421
rename ce22 ce422
/*
rename ce23_1 ce423_1
rename ce23_2 ce423_2
rename ce23_3 ce423_3
rename ce23_4 ce423_4
rename ce23_5 ce423_5
rename ce23_6 ce423_6
rename ce23_7 ce423_7
rename ce23_8 ce423_8
rename ce23_9 ce423_9
rename ce23_10 ce423_10
rename ce23_11 ce423_11
*/
rename ce24 ce424
rename ce25cod ce425cod
rename ce28cod ce428cod
rename ce29 ce429
rename ce30 ce430
rename ce31 ce432
*

rename ce32 ce431
replace ce431=ce63 if ce431==.&ce63!=.

rename ce32_cantidad ce431_cantidad
rename ce34 ce433
rename ce36 ce434
rename ce37 ce435
rename ce38 ce436
rename ce39 ce437

*** adapt (notice that it works following a chain logic)
/*

rename ce40_1 ce438_1
rename ce40_2 ce438_2
rename ce40_3 ce438_3
rename ce40_4 ce438_4
rename ce40_5 ce438_5
rename ce40_6 ce438_6
rename ce40_7 ce438_7
rename ce40_8 ce438_8
rename ce40_9 ce438_9
rename ce40_10 ce438_10
rename ce40_11 ce438_11
*/
tostring ce40, replace
gen todrop_ce40=substr(ce40,1,1)
destring todrop_ce40, generate(todrop_ce40_num) force

gen ce438_1=1 if todrop_ce40_num==1
gen ce438_2=2 if todrop_ce40_num==2
drop todrop*

rename ce41 ce439
rename ce42 ce440
rename ce43 ce441
rename ce44 ce442_a
rename ce45 ce442a
rename ce46 ce442_r
rename ce47 ce442r
rename ce48 ce442_h
rename ce49 ce442h
rename ce50 ce442_t
rename ce51 ce442t
rename ce52 ce442_c
rename ce53 ce442c
rename ce54 ce442_b
rename ce55 ce442b
rename ce56 ce442_p
rename ce57 ce442p
rename ce58 ce442_e
rename ce59 ce442e
rename ce60 ce442_o
rename ce61 ce442o
rename ce65 ce443


*** adapt (notice that it works following a chain logic, I deal with that by setting to 1 which does not alter the result)
/*
rename ce66_1 ce444_1
rename ce66_2 ce444_2
rename ce66_3 ce444_3
rename ce66_4 ce444_4
rename ce66_5 ce444_5
*/
gen ce444_1=1 if ce66==1
gen ce444_2=1 if ce66==2
gen ce444_3=1 if ce66==3
gen ce444_4=1 if ce66==4
gen ce444_5=1 if ce66==5&ce66!=.
replace ce444_1=1 if ce66>5&ce66!=.



rename ce67 ce445
rename ce69 ce446
rename ce70 ce447
rename ce72 ce448
rename ce73cod ce449cod
rename ce76cod ce452cod
rename ce77 ce453
rename ce78 ce454
rename ce79 ce456
rename ce80 ce455
rename ce80_cantidad ce455_cantidad
rename ce82 ce457
rename ce84 ce458
rename ce85 ce459
rename ce86 ce460
rename ce87 ce461
/*
rename ce88_1 ce462_1
rename ce88_2 ce462_2
rename ce88_3 ce462_3
rename ce88_4 ce462_4
rename ce88_5 ce462_5
rename ce88_6 ce462_6
rename ce88_7 ce462_7
rename ce88_8 ce462_8
rename ce88_9 ce462_9
rename ce88_10 ce462_10
rename ce88_11 ce462_11
*/
rename ce89 ce463
rename ce90 ce464
rename ce91 ce465
rename ce92 ce466_a
rename ce93 ce466a
rename ce94 ce466_r
rename ce95 ce466r
rename ce96 ce466_h
rename ce97 ce466h
rename ce98 ce466_t
rename ce99 ce466t
rename ce100 ce466_c
rename ce101 ce466c
rename ce102 ce466_b
rename ce103 ce466b
rename ce104 ce466_p
rename ce105 ce466p
rename ce106 ce466_e
rename ce107 ce466e
rename ce108 ce466_o
rename ce109 ce466o
rename ce110 ce467
/*
rename ce114_1 ce468_1
rename ce114_2 ce468_2
rename ce114_3 ce468_3
rename ce114_4 ce468_4
rename ce114_5 ce468_5
*/
rename ce115 ce469
rename ce117 ce470
rename ce118 ce471
rename ce120 ce472
rename ce121 ce473
rename ce122 ce474



}


if ${time} ==2009  {
rename p103 ed103
rename p107 ed107
rename p105 ed105
rename p108 ed108
rename p111 ed110




rename p401 ce401
rename p402 ce402
rename p403 ce403
rename p404 ce404
rename p405 ce405
rename p406 ce406
rename p407 ce407
rename p408 ce408
rename p409 ce409
rename p410 ce410
rename p411_cant ce411
rename p411_frec ce411tiempo
rename p412 ce412
rename p413 ce413
rename p414 ce414
rename p415 ce415cod
rename p416 ce416cod
rename p417_cant ce417
rename p417_frec ce417_tiempo
rename p418 ce418
rename p419 ce419
rename p420 ce420
rename p421 ce421
rename p422 ce422
rename p423_1 ce423_1
rename p423_2 ce423_2
rename p423_otra ce423_3
rename p424 ce424
rename p425 ce425cod
rename p428 ce428cod
rename p429 ce429
rename p430 ce430
rename p431 ce432
*

rename p432_rango ce431
replace ce431=p446_rango if ce431==.&p446_rango!=.

rename p432_cant ce431_cantidad
rename p434 ce433
rename p436 ce434
rename p437 ce435
rename p438 ce436
rename p439 ce437

*adapt
*rename p440 ce438_1
*rename p440 ce438_2
tostring p440, replace force
gen todrop_p440=substr(p440,1,1)
destring todrop_p440, generate(todrop_p440_num) force

gen ce438_1=1 if todrop_p440_num==1
gen ce438_2=2 if todrop_p440_num==2
drop todrop*



rename p441 ce439
rename p442 ce440
rename p443 ce441
rename p448 ce443

*adapt
/*
rename p449 ce444_1
rename p449 ce444_2
rename p449 ce444_3
rename p449 ce444_4
rename p449 ce444_5
*/
gen ce444_1=1 if p449==1
gen ce444_2=1 if p449==2
gen ce444_3=1 if p449==3
gen ce444_4=1 if p449==4
gen ce444_5=1 if p449==5&p449!=.
replace ce444_1=1 if p449>5&p449!=.

rename p450 ce445
rename p452 ce446
rename p453 ce447
rename p455 ce448
rename p456 ce449cod
rename p459 ce452cod
rename p460 ce453
rename p461 ce454
rename p462 ce456
rename p463_rango ce455
rename p463_cant ce455_cantidad
rename p465 ce457
rename p467 ce458
rename p468 ce459
rename p469 ce460
rename p470 ce461
rename p472 ce463
rename p473 ce464
rename p486 ce472
rename p487 ce473
rename p488 ce474
}



if ${time} ==2007  {

rename p03 ed103
rename p07 ed107
rename p05 ed105
rename p08 ed108
rename p11 ed110




rename p34 ce401
rename p35 ce402
rename p36 ce403
rename p37 ce404
rename p38 ce405
rename p39 ce406
rename p40 ce407
rename p41 ce408
rename p42 ce409
rename p43 ce410
rename p44a ce411
rename p44b ce411tiempo
rename p48 ce412
rename p49 ce413
rename p50 ce415cod
rename p51 ce416cod
rename p52a ce417
rename p52b ce417_tiempo
rename p53 ce418
rename p54 ce419
rename p55 ce420
rename p56 ce421
rename p57 ce422
*rename rap ce423_1
*rename injupem ce423_2
*rename inprema ce423_3
*rename ipm ce423_4
*rename ihss ce423_5
*rename fpp ce423_6
*rename smp ce423_7
*rename sindicato ce423_8
*rename gremio ce423_9
*rename ninguna ce423_10
*rename otro ce423_11
*rename nosabe ce423_99
rename p59 ce424
rename p60 ce425cod
rename p63 ce428cod
rename p64 ce429
rename p65 ce430
rename p66 ce432

*
rename p67a ce431
replace ce431=p80a if ce431==.&p80a!=.



rename p69 ce433
rename p71 ce435
rename p72 ce436
rename p73 ce437
rename pension ce438_1
*
rename prestaciones ce438_2


rename vaciones ce438_3
rename pagohe ce438_4
rename seguroa ce438_5
rename aguinaldo ce438_6
rename decimo ce438_7
rename bonifi ce438_8
rename segurov ce438_9
rename ningunaa ce438_10
rename nosnor ce438_11
rename p75 ce439
rename p76 ce440
rename p77 ce441

rename p82 ce443

*
gen ce444_1 = 1 if p83==1

gen ce444_2=.
gen ce444_3=.
gen ce444_4=.


rename p84 ce445
rename p86al ce446
rename p87r1 ce447
rename p89 ce448
rename p90 ce449cod
rename p93 ce452cod
rename p94 ce453
rename p95 ce454
rename p96 ce456
*rename p97a ce455
*rename p97b ce455
rename p99 ce457
rename p101 ce459
rename p102 ce460
rename p103 ce461
rename pension2 ce462_1
rename prestacion2 ce462_2
rename vacacion2 ce462_3
rename pagohe2 ce462_4
rename seguro2 ce462_5
rename agulnadlo2 ce462_6
rename decimo2 ce462_7
rename bonifica2 ce462_8
rename segurov2 ce462_9
rename ninguna2 ce462_10
rename nosabe2 ce462_11
rename p105 ce463
rename p106 ce464
rename p107 ce465
rename p112 ce467
rename p114 ce469
rename p116m1 ce470
rename p117rm1 ce471
rename p119 ce472
rename p120 ce473
rename p121 ce474

}

if ${time} ==2008  {

rename p03 ed103
rename p07 ed107
rename p05 ed105
rename p08 ed108
rename p11 ed110




rename p34 ce401
rename p35 ce402
rename p36 ce403
rename p37 ce404
rename p38 ce405
rename p39 ce406
rename p40 ce407
rename p41 ce408
rename p42 ce409
rename p43 ce410
rename p44a ce411
rename p44b ce411tiempo
rename p48 ce412
rename p49 ce413
rename p50 ce415cod
rename p51 ce416cod
rename p52a ce417
rename p52b ce417_tiempo
rename p53 ce418
rename p54 ce419
rename p55 ce420
rename p56 ce421
rename p57 ce422
*rename rap ce423_1
*rename injupem ce423_2
*rename inprema ce423_3
*rename ipm ce423_4
*rename ihss ce423_5
*rename fpp ce423_6
*rename smp ce423_7
*rename sindicato ce423_8
*rename gremio ce423_9
*rename ninguna ce423_10
*rename otro ce423_11
*rename nosabe ce423_99
rename p59 ce424
rename p60 ce425cod
rename p63 ce428cod
rename p64 ce429
rename p65 ce430
rename p66 ce432

*
rename p67a ce431
replace ce431=p80a if ce431==.&p80a!=.



rename p69 ce433
rename p71 ce435
rename p72 ce436
rename p73 ce437



tostring p74, replace force
gen todrop_p74=substr(p74,1,1)
destring todrop_p74, generate(todrop_p74_num) force

gen ce438_1=1 if todrop_p74_num==1
gen ce438_2=2 if todrop_p74_num==2
drop todrop*



*rename vaciones ce438_3
*rename pagohe ce438_4
*rename seguroa ce438_5
*rename aguinaldo ce438_6
*rename decimo ce438_7
*rename bonifi ce438_8
*rename segurov ce438_9
*rename ningunaa ce438_10
*rename nosnor ce438_11
rename p75 ce439
rename p76 ce440
rename p77 ce441

rename p82 ce443

*
gen ce444_1 = 1 if p83==1

gen ce444_2=.
gen ce444_3=.
gen ce444_4=.


rename p84 ce445
rename p86 ce446
rename p87 ce447
rename p89 ce448
rename p90 ce449cod
rename p93 ce452cod
rename p94 ce453
rename p95 ce454
rename p96 ce456
*rename p97a ce455
*rename p97b ce455
rename p99 ce457
rename p101 ce459
rename p102 ce460
rename p103 ce461
*rename pension2 ce462_1
*rename prestacion2 ce462_2
*rename vacacion2 ce462_3
*rename pagohe2 ce462_4
*rename seguro2 ce462_5
*rename agulnadlo2 ce462_6
*rename decimo2 ce462_7
*rename bonifica2 ce462_8
*rename segurov2 ce462_9
*rename ninguna2 ce462_10
*rename nosabe2 ce462_11
rename p105 ce463
rename p106 ce464
rename p107 ce465
rename p112 ce467
rename p114 ce469
rename p116 ce470
rename p117 ce471
rename p119 ce472
rename p120 ce473
rename p121 ce474

}




if ${time} ==2006 {

rename p02 ed103

rename p04a ed105
rename p04b ed108
rename p04c ed107

rename p05a ed110





*
rename p45 ce431
replace ce431=p58 if ce431==.&p58!=.


gen ce444_1 = 1 if p61==1

gen ce444_2=.
gen ce444_3=.
gen ce444_4=.





rename p16 ce401
rename p17 ce402
rename p18 ce403
rename p19 ce404
rename p20 ce405
rename p22 ce407
rename p24 ce408
rename p23 ce409
rename p25 ce410
rename p26 ce411
rename p26a ce411tiempo
rename p27 ce412
rename p28 ce413
rename p29 ce415cod
rename p30 ce416cod
rename p31 ce417
rename p31a ce417_tiempo
rename p32 ce418
rename p33 ce419
rename p34 ce420
rename p35 ce421
rename p36 ce422
rename p37_1 ce423_1
rename p37_2 ce423_2
rename p37_3 ce423_3
rename p37_4 ce423_4
rename p37_5 ce423_5
rename p37_6 ce423_6
rename p37_7 ce423_7
rename p37_8 ce423_8
rename p37_9 ce423_9
rename p37_10 ce423_10
rename p37_11 ce423_11
rename p37_99 ce423_99
rename p38 ce424
rename p39a ce425cod
rename p40b ce428cod
rename p41 ce429
rename p42 ce430
rename p43 ce432

rename p45a ce431_cantidad
rename p47 ce433
rename p48 ce435
rename p49 ce436
rename p50 ce437
rename p51_1 ce438_1
rename p51_2 ce438_2
rename p51_3 ce438_3
rename p51_4 ce438_4
rename p51_5 ce438_5
rename p51_6 ce438_6
rename p51_7 ce438_7
rename p51_8 ce438_10
rename p51_9 ce438_11
rename p53 ce439
rename p55 ce440
rename p54 ce441

rename p58a ce431_cantidad2
rename p60 ce443

rename p62 ce445
rename p64 ce446
rename p65 ce447
rename p67 ce448
rename p69a ce449cod
rename p70b ce452cod
rename p71 ce453
rename p72 ce454
rename p73 ce456
rename p75 ce455
rename p75a ce455_cantidad
rename p77 ce457
rename p78 ce459
rename p79 ce460
rename p80 ce461
rename p81_1 ce462_1
rename p81_2 ce462_2
rename p81_3 ce462_3
rename p81_4 ce462_4
rename p81_5 ce462_5
rename p81_6 ce462_6
rename p81_7 ce462_7
rename p81_8 ce462_10
rename p81_99 ce462_11
rename p83 ce463
rename p85 ce464
rename p84 ce465
rename p90 ce467
rename p92 ce469
rename p94 ce470
rename p95 ce471
rename p97 ce472
rename p98 ce473
rename p99 ce474


}

if ${time} ==2005{
*Notice we do not have social security (neither sick or annual leave), I do not obtain informality (even for informal sector it is a crucial criteria
* for employees)

drop if dominio==.
drop if edad==.

rename p02 ed103

rename p04a ed105
rename p04b ed108
rename p04c ed107

rename p05a ed110

rename p17 ce401
rename p18 ce402
rename p19 ce403
rename p20 ce404
rename p21 ce405
rename p24 ce407
rename p25 ce408
rename p23 ce409
rename p26 ce410
rename p27 ce411
rename p27a ce411tiempo
rename p28 ce412
rename p29 ce413
rename p30 ce415cod
rename p31 ce416cod
rename p32 ce417
rename p32a ce417_tiempo
rename p33 ce418
rename p34 ce419
rename p35 ce420
rename p36 ce421
rename p37 ce422
rename p38 ce424
rename p39a ce425cod
rename p40b ce428cod
rename p41 ce429
rename p42 ce430
rename p43 ce432
*rename p44 ce431
*rename p44a ce431_cantidad
rename p47 ce439
rename p49 ce440
rename p48 ce441
*rename p52 ce431
*rename p52a ce431
rename p54 ce443
*rename p55 ce444_1

rename p56 ce445
rename p58 ce446
rename p59 ce447
rename p61 ce448
rename p62a ce449cod
rename p63b ce452cod
rename p64 ce453
rename p65 ce454
rename p66 ce456
*rename p67 ce455
*rename p67a ce455
rename p70 ce463
rename p71 ce464
rename p72 ce465
rename p77 ce467
rename p79 ce469
rename p81 ce470
rename p82 ce471
rename p84 ce472
rename p85 ce473
rename p86 ce474





}

*********************** Note::::::SECTOR-> Some issues, break from 2014 to 2015 (Change from ISCO 88 to 08)
********** It turns out the difference is made mostly due to general managers, with many own account workers without employees being 
********** considered general managers in 2014 and before
******
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Key identifier ('ilo_key')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_key=_n
		lab var ilo_key "Key unique identifier per individual"		


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sample Weight ('ilo_wgt')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_wgt=factor
		lab var ilo_wgt "Sample weight"		


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time period ('ilo_time')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------


	gen ilo_time=1
		lab def lab_time 1 $time
		lab val ilo_time lab_time
		lab var ilo_time "Time (Gregorian Calendar)"
		

* ---------------------------------------------------------------------------------------------
***********************************************************************************************
*			PART 2. SOCIAL CHARACTERISTICS
***********************************************************************************************
* ---------------------------------------------------------------------------------------------

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Geographical coverage ('ilo_geo')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_geo=.
		replace ilo_geo=1 if dominio<5
		replace ilo_geo=2 if dominio==5
			lab def ilo_geo_lab 1 "1 - Urban" 2 "2 - Rural"
			lab val ilo_geo ilo_geo_lab
			lab var ilo_geo "Geographical coverage"	

			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Sex ('ilo_sex')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_sex=sexo
		lab def ilo_sex_lab 1 "1 - Male" 2 "2 - Female"
		lab var ilo_sex "Sex"
		lab val ilo_sex ilo_sex_lab


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Age ('ilo_age')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_age=edad
		lab var ilo_age "Age"

* Age groups

	gen ilo_age_5yrbands=.
		replace ilo_age_5yrbands=1 if inrange(ilo_age,0,4)
		replace ilo_age_5yrbands=2 if inrange(ilo_age,5,9)
		replace ilo_age_5yrbands=3 if inrange(ilo_age,10,14)
		replace ilo_age_5yrbands=4 if inrange(ilo_age,15,19)
		replace ilo_age_5yrbands=5 if inrange(ilo_age,20,24)
		replace ilo_age_5yrbands=6 if inrange(ilo_age,25,29)
		replace ilo_age_5yrbands=7 if inrange(ilo_age,30,34)
		replace ilo_age_5yrbands=8 if inrange(ilo_age,35,39)
		replace ilo_age_5yrbands=9 if inrange(ilo_age,40,44)
		replace ilo_age_5yrbands=10 if inrange(ilo_age,45,49)
		replace ilo_age_5yrbands=11 if inrange(ilo_age,50,54)
		replace ilo_age_5yrbands=12 if inrange(ilo_age,55,59)
		replace ilo_age_5yrbands=13 if inrange(ilo_age,60,64)
		replace ilo_age_5yrbands=14 if ilo_age>=65 & ilo_age!=.
			lab def age_by5_lab 1 "0-4" 2 "5-9" 3 "10-14" 4 "15-19" 5 "20-24" 6 "25-29" ///
								7 "30-34" 8 "35-39" 9 "40-44" 10 "45-49" 11 "50-54" 12 "55-59" ///
								13 "60-64" 14 "65+"
			lab val ilo_age_5yrbands age_by5_lab
			lab var ilo_age_5yrbands "Age (5-year age bands)"
			
	gen ilo_age_10yrbands=.
		replace ilo_age_10yrbands=1 if inrange(ilo_age,0,14)
		replace ilo_age_10yrbands=2 if inrange(ilo_age,15,24)
		replace ilo_age_10yrbands=3 if inrange(ilo_age,25,34)
		replace ilo_age_10yrbands=4 if inrange(ilo_age,35,44)
		replace ilo_age_10yrbands=5 if inrange(ilo_age,45,54)
		replace ilo_age_10yrbands=6 if inrange(ilo_age,55,64)
		replace ilo_age_10yrbands=7 if ilo_age>=65 & ilo_age!=.
			lab def age_by10_lab 1 "<15" 2 "15-24" 3 "25-34" 4 "35-44" 5 "45-54" 6 "55-64" 7 "65+"
			lab val ilo_age_10yrbands age_by10_lab
			lab var ilo_age_10yrbands "Age (10-year age bands)"
			
	gen ilo_age_aggregate=.
		replace ilo_age_aggregate=1 if inrange(ilo_age,0,14)
		replace ilo_age_aggregate=2 if inrange(ilo_age,15,24)
		replace ilo_age_aggregate=3 if inrange(ilo_age,25,54)
		replace ilo_age_aggregate=4 if inrange(ilo_age,55,64)
		replace ilo_age_aggregate=5 if ilo_age>=65 & ilo_age!=.
			lab def age_aggr_lab 1 "<15" 2 "15-24" 3 "25-54" 4 "55-64" 5 "65+"
			lab val ilo_age_aggregate age_aggr_lab
			lab var ilo_age_aggregate "Age (Aggregate)"



* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education ('ilo_edu')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

/* based on the mapping developped by UNESCO 
					http://www.uis.unesco.org/Education/ISCEDMappings/Pages/default.aspx
					file:///J:\DPAU\MICRO\HND\HS\2014\ORI\ISCED_2011_Mapping_Honduras_EN.xlsx
	
					
*/
*doctorate category is left empty



* ISCED11
gen ilo_edu_isced11=.

** Level acomplished
	*Higher categories
		*Higher categories completed
		replace ilo_edu_isced11=5 if ed107==1&(ed105==6|ed105==7)
		replace ilo_edu_isced11=7 if ed107==1&(ed105==8)
		replace ilo_edu_isced11=8 if ed107==1&(ed105==9)
		replace ilo_edu_isced11=9 if ed107==1&(ed105==10)
		*Higher categories not completed
		replace ilo_edu_isced11=4 if ed107==2&(ed105==6|ed105==7)
		replace ilo_edu_isced11=5 if ed107==2&(ed105==8|ed105==9)
		replace ilo_edu_isced11=8 if ed107==2&(ed105==10)
	*Intermediate categories
		*Intermediate categories - highest course completed
		replace ilo_edu_isced11=2 if (ed108>=3&ed108!=.)&ed105==3
		replace ilo_edu_isced11=3 if (ed108>=6&ed108!=.)&ed105==4
		replace ilo_edu_isced11=4 if (ed108>=3&ed108!=.)&ed105==5
		*Intermediate categories - highest course NOT completed
		replace ilo_edu_isced11=1 if (ed108<3)&ed105==3
		replace ilo_edu_isced11=2 if (ed108<6)&ed105==4
		replace ilo_edu_isced11=3 if (ed108<3)&ed105==5
	* Lower categories (no requirements)
		replace ilo_edu_isced11=1 if ed105==2
		replace ilo_edu_isced11=1 if ed105==1
		
		
** Current level -> and therefore not finished 	
		*Higher categories not completed
		replace ilo_edu_isced11=4 if ilo_edu_isced==.&(ed110==6|ed110==7)
		replace ilo_edu_isced11=5 if ilo_edu_isced==.&(ed110==8|ed110==9)
		replace ilo_edu_isced11=8 if ilo_edu_isced==.&(ed110==10)
		*Intermediate categories - highest course NOT completed
		replace ilo_edu_isced11=1 if ilo_edu_isced==.&ed110==3
		replace ilo_edu_isced11=2 if ilo_edu_isced==.&ed110==4
		replace ilo_edu_isced11=3 if ilo_edu_isced==.&ed110==5
		* Lower categories (no requirements)
		replace ilo_edu_isced11=1 if ilo_edu_isced==.&ed110==2
		
		
	* Missing
		replace ilo_edu_isced11=11 if ilo_edu_isced11==.
		
			label def isced_11_lab 1 "X - No schooling" 2 "0 - Early childhood education" 3 "1 - Primary education" 4 "2 - Lower secondary education" 5 "3 - Upper secondary education" ///
								6 "4 - Post-secondary non-tertiary education" 7 "5 - Short-cycle tertiary education" 8 "6 - Bachelor's or equivalent level" 9 "7 - Master's or equivalent level" ///
								10 "8 - Doctoral or equivalent level" 11 "9 - Not elsewhere classified"
			label val ilo_edu_isced11 isced_11_lab
			lab var ilo_edu_isced11 "Education (ISCED 11)"


		* for the definition, cf. the document "Guide to reporting labour statistics to the ILO using the Excel questionnaire"
		
	gen ilo_edu_aggregate=.
		replace ilo_edu_aggregate=1 if inlist(ilo_edu_isced11,1,2)
		replace ilo_edu_aggregate=2 if inlist(ilo_edu_isced11,3,4)
		replace ilo_edu_aggregate=3 if inlist(ilo_edu_isced11,5,6)
		replace ilo_edu_aggregate=4 if inlist(ilo_edu_isced11,7,8,9,10)
		replace ilo_edu_aggregate=5 if ilo_edu_isced11==11
			label def edu_aggr_lab 1 "1 - Less than basic" 2 "2 - Basic" 3 "3 - Intermediate" 4 "4 - Advanced" 5 "5 - Level not stated"
			label val ilo_edu_aggregate edu_aggr_lab
			label var ilo_edu_aggregate "Education (Aggregate level)"
		
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Education attendance ('ilo_edu_attendance')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------


	gen ilo_edu_attendance=ed103
			label def edu_att_lab 1 "1 - Attending" 2 "2 - Not attending"
			label val ilo_edu_attendance edu_att_lab
			label var ilo_edu_attendance "Education (Attendance)"


* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
*			           Marital status ('ilo_mrts') 	                           *
* ------------------------------------------------------------------------------
* ------------------------------------------------------------------------------
* Comment: 
	
	* Detailed
	gen ilo_mrts_details=.
	    replace ilo_mrts_details=1 if civil==5                                  // Single
		replace ilo_mrts_details=2 if civil==1                                  // Married
		replace ilo_mrts_details=3 if civil==6                                  // Union / cohabiting
		replace ilo_mrts_details=4 if civil==2                                  // Widowed
		replace ilo_mrts_details=5 if inlist(civil,3,4)                         // Divorced / separated
		replace ilo_mrts_details=6 if ilo_mrts_details==.			            // Not elsewhere classified
		        label define label_mrts_details 1 "1 - Single" 2 "2 - Married" 3 "3 - Union / cohabiting" ///
				                                4 "4 - Widowed" 5 "5 - Divorced / separated" 6 "6 - Not elsewhere classified"
		        label values ilo_mrts_details label_mrts_details
		        lab var ilo_mrts_details "Marital status"
				
	* Aggregate
	gen ilo_mrts_aggregate=.
	    replace ilo_mrts_aggregate=1 if inlist(ilo_mrts_details,1,4,5)          // Single / Widowed / Divorced / Separated
		replace ilo_mrts_aggregate=2 if inlist(ilo_mrts_details,2,3)            // Married / Union / Cohabiting
		replace ilo_mrts_aggregate=3 if ilo_mrts_aggregate==. 			        // Not elsewhere classified
		        label define label_mrts_aggregate 1 "1 - Single / Widowed / Divorced / Separated" 2 "2 - Married / Union / Cohabiting" 3 "3 - Not elsewhere classified"
		        label values ilo_mrts_aggregate label_mrts_aggregate
		        lab var ilo_mrts_aggregate "Marital status (Aggregate levels)"				
							

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Disability status ('ilo_dsb')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
		*note there are some missing values that are coded as 9, these are forced to be not disabled
*nodata
* ---------------------------------------------------------------------------------------------
***********************************************************************************************
*			PART 3. ECONOMIC SITUATION
***********************************************************************************************
* ---------------------------------------------------------------------------------------------		

		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working age population ('ilo_wap')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_wap=.
		replace ilo_wap=1 if (ilo_age>=15 & ilo_age!=.)
			lab def wap_lab 1 "Working age population"
			lab val ilo_wap wap_lab
			label var ilo_wap "Working age population"

	drop ilo_age

	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Labour Force Status ('ilo_lfs')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
* note temporary absence does not include info on duration, all temporary absentees are considered to be employed
* the way the questionaire is designed the seeking work question filters out the willing and available question
* therefore unemployment is obtained as seeking OR already found a job and are willing and available
*(willing & available is simply not asked to those who sought work) 
	gen ilo_lfs=.
		replace ilo_lfs=1 if ((ce401==1 | ce402==1 | ce403==1 ) & ilo_wap==1) 	// Employed
		replace ilo_lfs=2 if ilo_wap==1 & ilo_lfs!=1 & ( ce405==1 | (ce408==1 & ce409<3)  ) 	// Unemployed
		replace ilo_lfs=3 if ilo_lfs!=1 & ilo_lfs!=2 & ilo_wap==1  											// Outside the labour force
				label define label_ilo_lfs 1 "Employed" 2 "Unemployed" 3 "Outside the Labour Force"
				label value ilo_lfs label_ilo_lfs
				label var ilo_lfs "Labour Force Status"


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Multiple job holders ('ilo_mjh')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen ilo_mjh=.
		replace ilo_mjh=1 if ce448==2 & ilo_lfs==1
		replace ilo_mjh=2 if ce448==1 & ilo_lfs==1
			lab def lab_ilo_mjh 1 "1 - One job only" 2 "2 - More than one job"
			lab val ilo_mjh lab_ilo_mjh
			lab var ilo_mjh "Multiple job holders"		
	
	

***********************************************************************************************
*			PART 3.1. ECONOMIC CHARACTERISTICS FOR MAIN JOB 
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Status in employment ('ilo_job1_ste')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

  * MAIN JOB:
	
	* Detailed categories:

		gen ilo_job1_ste_icse93=.
			replace ilo_job1_ste_icse93=1 if (ce432<4) & ilo_lfs==1		// Employees
			replace ilo_job1_ste_icse93=2 if inlist(ce432,6,7,10,11) & ilo_lfs==1		// Employers
			replace ilo_job1_ste_icse93=3 if inlist(ce432,5,9) & ilo_lfs==1		// Own-account workers
			replace ilo_job1_ste_icse93=4 if inlist(ce432,4,8) & ilo_lfs==1		// Members of cooperatives
			replace ilo_job1_ste_icse93=5 if inlist(ce432,12) & ilo_lfs==1		// Contributing family workers
			replace ilo_job1_ste_icse93=6 if ilo_job1_ste_icse93==. & ilo_lfs==1		// Not classifiable

				label def label_ilo_ste_icse93 1 "1 - Employees" 2 "2 - Employers" 3 "3 - Own-account workers"  ///
											   4 "4 - Members of producers cooperatives" 5 "5 - Contributing family workers" ///
											   6 "6 - Workers not classifiable by status"
				label val ilo_job1_ste_icse93 label_ilo_ste_icse93
				label var ilo_job1_ste_icse93 "Status in employment (ICSE 93)"

	* Aggregate categories 
		
		gen ilo_job1_ste_aggregate=.
			replace ilo_job1_ste_aggregate=1 if ilo_job1_ste_icse93==1				// Employees
			replace ilo_job1_ste_aggregate=2 if inrange(ilo_job1_ste_icse93,2,5)	// Self-employed
			replace ilo_job1_ste_aggregate=3 if ilo_job1_ste_icse93==6				// Not elsewhere classified
				lab def ste_aggr_lab 1 "1 - Employees" 2 "2 - Self-employed" 3 "3 - Not elsewhere classified"
				lab val ilo_job1_ste_aggregate ste_aggr_lab
				label var ilo_job1_ste_aggregate "Status in employment (Aggregate)"  

				


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Economic activity ('ilo_eco')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

 	
* Note, it is defined as ISIC 3, not ISIC 3 Rev1
* I convert first the 3 standard to 3.1, notice that the mapping is not uniquely identified some
* asumption are made, in particular the minimum distance alternative is taken (the file use has been processed for this purpose)

	* 4 digit isic 3
if ${time} >=2015 {

gen ilo_job1_eco_isic4_2digits=trunc(ce428cod/100) if ilo_lfs==1
 replace ilo_job1_eco_isic4_2digits=. if ilo_job1_eco_isic4_2digits>99
 replace ilo_job1_eco_isic4_2digits=. if inlist(ilo_job1_eco_isic4_2digits,54)
 
 			    lab def eco_isic4_2digits 1 "01 - Crop and animal production, hunting and related service activities"	2 "02 - Forestry and logging"	3 "03 - Fishing and aquaculture"	5 "05 - Mining of coal and lignite" ///
                                          6 "06 - Extraction of crude petroleum and natural gas"	7 "07 - Mining of metal ores"	8 "08 - Other mining and quarrying"	9 "09 - Mining support service activities" ///
                                          10 "10 - Manufacture of food products"	11 "11 - Manufacture of beverages"	12 "12 - Manufacture of tobacco products"	13 "13 - Manufacture of textiles" ///
                                          14 "14 - Manufacture of wearing apparel"	15 "15 - Manufacture of leather and related products"	16 "16 - Manufacture of wood and of products of wood and cork, except furniture; manufacture of articles of straw and plaiting materials"	17 "17 - Manufacture of paper and paper products" ///
                                          18 "18 - Printing and reproduction of recorded media"	19 "19 - Manufacture of coke and refined petroleum products"	20 "20 - Manufacture of chemicals and chemical products"	21 "21 - Manufacture of pharmaceuticals, medicinal chemical and botanical products" ///
                                          22 "22 - Manufacture of rubber and plastics products"	23 "23 - Manufacture of other non-metallic mineral products"	24 "24 - Manufacture of basic metals"	25 "25 - Manufacture of fabricated metal products, except machinery and equipment" ///
                                          26 "26 - Manufacture of computer, electronic and optical products"	27 "27 - Manufacture of electrical equipment"	28 "28 - Manufacture of machinery and equipment n.e.c."	29 "29 - Manufacture of motor vehicles, trailers and semi-trailers" ///
                                          30 "30 - Manufacture of other transport equipment"	31 "31 - Manufacture of furniture"	32 "32 - Other manufacturing"	33 "33 - Repair and installation of machinery and equipment" ///
                                          35 "35 - Electricity, gas, steam and air conditioning supply"	36 "36 - Water collection, treatment and supply"	37 "37 - Sewerage"	38 "38 - Waste collection, treatment and disposal activities; materials recovery" ///
                                          39 "39 - Remediation activities and other waste management services"	41 "41 - Construction of buildings"	42 "42 - Civil engineering"	43 "43 - Specialized construction activities" ///
                                          45 "45 - Wholesale and retail trade and repair of motor vehicles and motorcycles"	46 "46 - Wholesale trade, except of motor vehicles and motorcycles"	47 "47 - Retail trade, except of motor vehicles and motorcycles"	49 "49 - Land transport and transport via pipelines" ///
                                          50 "50 - Water transport"	51 "51 - Air transport"	52 "52 - Warehousing and support activities for transportation"	53 "53 - Postal and courier activities" ///
                                          55 "55 - Accommodation"	56 "56 - Food and beverage service activities"	58 "58 - Publishing activities"	59 "59 - Motion picture, video and television programme production, sound recording and music publishing activities" ///
                                          60 "60 - Programming and broadcasting activities"	61 "61 - Telecommunications"	62 "62 - Computer programming, consultancy and related activities"	63 "63 - Information service activities" ///
                                          64 "64 - Financial service activities, except insurance and pension funding"	65 "65 - Insurance, reinsurance and pension funding, except compulsory social security"	66 "66 - Activities auxiliary to financial service and insurance activities"	68 "68 - Real estate activities" ///
                                          69 "69 - Legal and accounting activities"	70 "70 - Activities of head offices; management consultancy activities"	71 "71 - Architectural and engineering activities; technical testing and analysis"	72 "72 - Scientific research and development" ///
                                          73 "73 - Advertising and market research"	74 "74 - Other professional, scientific and technical activities"	75 "75 - Veterinary activities"	77 "77 - Rental and leasing activities" ///
                                          78 "78 - Employment activities"	79 "79 - Travel agency, tour operator, reservation service and related activities"	80 "80 - Security and investigation activities"	81 "81 - Services to buildings and landscape activities" ///
                                          82 "82 - Office administrative, office support and other business support activities"	84 "84 - Public administration and defence; compulsory social security"	85 "85 - Education"	86 "86 - Human health activities" ///
                                          87 "87 - Residential care activities"	88 "88 - Social work activities without accommodation"	90 "90 - Creative, arts and entertainment activities"	91 "91 - Libraries, archives, museums and other cultural activities" ///
                                          92 "92 - Gambling and betting activities"	93 "93 - Sports activities and amusement and recreation activities"	94 "94 - Activities of membership organizations"	95 "95 - Repair of computers and personal and household goods" ///
                                          96 "96 - Other personal service activities"	97 "97 - Activities of households as employers of domestic personnel"	98 "98 - Undifferentiated goods- and services-producing activities of private households for own use"	99 "99 - Activities of extraterritorial organizations and bodies"
                lab val ilo_job1_eco_isic4_2digits eco_isic4_2digits
                lab var ilo_job1_eco_isic4_2digits "Economic activity (ISIC Rev. 4), 2 digits level - main job"


	gen ilo_job1_eco_isic4=.
			replace ilo_job1_eco_isic4=1 if inrange(ilo_job1_eco_isic4_2digits,1,3)
			replace ilo_job1_eco_isic4=2 if inrange(ilo_job1_eco_isic4_2digits,5,9)
			replace ilo_job1_eco_isic4=3 if inrange(ilo_job1_eco_isic4_2digits,10,33)
			replace ilo_job1_eco_isic4=4 if ilo_job1_eco_isic4_2digits==35
			replace ilo_job1_eco_isic4=5 if inrange(ilo_job1_eco_isic4_2digits,36,39)
			replace ilo_job1_eco_isic4=6 if inrange(ilo_job1_eco_isic4_2digits,41,43)
			replace ilo_job1_eco_isic4=7 if inrange(ilo_job1_eco_isic4_2digits,45,47)
			replace ilo_job1_eco_isic4=8 if inrange(ilo_job1_eco_isic4_2digits,49,53)
			replace ilo_job1_eco_isic4=9 if inrange(ilo_job1_eco_isic4_2digits,55,56)
			replace ilo_job1_eco_isic4=10 if inrange(ilo_job1_eco_isic4_2digits,58,63)
			replace ilo_job1_eco_isic4=11 if inrange(ilo_job1_eco_isic4_2digits,64,66)
			replace ilo_job1_eco_isic4=12 if ilo_job1_eco_isic4_2digits==68
			replace ilo_job1_eco_isic4=13 if inrange(ilo_job1_eco_isic4_2digits,69,75)
			replace ilo_job1_eco_isic4=14 if inrange(ilo_job1_eco_isic4_2digits,77,82)
			replace ilo_job1_eco_isic4=15 if ilo_job1_eco_isic4_2digits==84
			replace ilo_job1_eco_isic4=16 if ilo_job1_eco_isic4_2digits==85
			replace ilo_job1_eco_isic4=17 if inrange(ilo_job1_eco_isic4_2digits,86,88)
			replace ilo_job1_eco_isic4=18 if inrange(ilo_job1_eco_isic4_2digits,90,93)
			replace ilo_job1_eco_isic4=19 if inrange(ilo_job1_eco_isic4_2digits,94,96)
			replace ilo_job1_eco_isic4=20 if inrange(ilo_job1_eco_isic4_2digits,97,98)
			replace ilo_job1_eco_isic4=21 if ilo_job1_eco_isic4_2digits==99
			replace ilo_job1_eco_isic4=22 if ilo_job1_eco_isic4_2digits==. & ilo_lfs==1 
			replace ilo_job1_eco_isic4=22 if ilo_job1_eco_isic4==. & ilo_lfs==1
		        lab def eco_isic4_1digit 1 "A - Agriculture, forestry and fishing"	2 "B - Mining and quarrying"	3 "C - Manufacturing"	4 "D - Electricity, gas, steam and air conditioning supply" ///
                                         5 "E - Water supply; sewerage, waste management and remediation activities"	6 "F - Construction"	7 "G - Wholesale and retail trade; repair of motor vehicles and motorcycles"	8 "H - Transportation and storage" ///
                                         9 "I - Accommodation and food service activities"	10 "J - Information and communication"	11 "K - Financial and insurance activities"	12 "L - Real estate activities" ///
                                         13 "M - Professional, scientific and technical activities"	14 "N - Administrative and support service activities"	15 "O - Public administration and defence; compulsory social security"	16 "P - Education" ///
                                         17 "Q - Human health and social work activities"	18 "R - Arts, entertainment and recreation"	19 "S - Other service activities"	20 "T - Activities of households as employers; undifferentiated goods- and services-producing activities of households for own use" ///
                                         21 "U - Activities of extraterritorial organizations and bodies"	22 "X - Not elsewhere classified"		
  	  		    lab val ilo_job1_eco_isic4 eco_isic4_1digit
			    lab var ilo_job1_eco_isic4 "Economic activity (ISIC Rev. 4) - main job"
				
		
	* Now do the classification on an aggregate level
	
		* Primary activity
		
		gen ilo_job1_eco_aggregate=.
			replace ilo_job1_eco_aggregate=1 if ilo_job1_eco_isic4==1
			replace ilo_job1_eco_aggregate=2 if ilo_job1_eco_isic4==3
			replace ilo_job1_eco_aggregate=3 if ilo_job1_eco_isic4==6
			replace ilo_job1_eco_aggregate=4 if inlist(ilo_job1_eco_isic4,2,4,5)
			replace ilo_job1_eco_aggregate=5 if inrange(ilo_job1_eco_isic4,7,14)
			replace ilo_job1_eco_aggregate=6 if inrange(ilo_job1_eco_isic4,15,21)
			replace ilo_job1_eco_aggregate=7 if ilo_job1_eco_isic4==22
			   lab def eco_aggr_lab 1 "1 - Agriculture" 2 "2 - Manufacturing" 3 "3 - Construction" 4 "4 - Mining and quarrying; Electricity, gas and water supply" ///
			  					    5 "5 - Market Services (Trade; Transportation; Accommodation and food; and Business and administrative services)"  ///
								    6 "6 - Non-market services (Public administration; Community, social and other services and activities)" 7 "7 - Not classifiable by economic activity"					
			   lab val ilo_job1_eco_aggregate eco_aggr_lab
			   lab var ilo_job1_eco_aggregate "Economic activity (Aggregate) - main job"


} 
else {
generate rev3 = trunc(ce428cod/1000)

	merge n:1 rev3 using "Internal\isic331.dta"
	drop if _merge==2
	drop _merge
	gen ilo_job1_eco_isic3_2digits=trunc(rev31/100) if ilo_lfs==1
	drop rev3 rev31
	
 				 lab def eco_isic3_2digits 1 "01 - Agriculture, hunting and related service activities"	2 "02 - Forestry, logging and related service activities"	5 "05 - Fishing, operation of fish hatcheries and fish farms; service activities incidental to fishing"	10 "10 - Mining of coal and lignite; extraction of peat"	///
                                          11 "11 - Extraction of crude petroleum and natural gas; service activities incidental to oil and gas extraction excluding surveying"	12 "12 - Mining of uranium and thorium ores"	13 "13 - Mining of metal ores"	14 "14 - Other mining and quarrying"	///
                                          15 "15 - Manufacture of food products and beverages"	16 "16 - Manufacture of tobacco products"	17 "17 - Manufacture of textiles"	18 "18 - Manufacture of wearing apparel; dressing and dyeing of fur"	///
                                          19 "19 - Tanning and dressing of leather; manufacture of luggage, handbags, saddlery, harness and footwear"	20 "20 - Manufacture of wood and of products of wood and cork, except furniture; manufacture of articles of straw and plaiting materials"	21 "21 - Manufacture of paper and paper products"	22 "22 - Publishing, printing and reproduction of recorded media"	///
                                          23 "23 - Manufacture of coke, refined petroleum products and nuclear fuel"	24 "24 - Manufacture of chemicals and chemical products"	25 "25 - Manufacture of rubber and plastics products"	26 "26 - Manufacture of other non-metallic mineral products"	///
                                          27 "27 - Manufacture of basic metals"	28 "28 - Manufacture of fabricated metal products, except machinery and equipment"	29 "29 - Manufacture of machinery and equipment n.e.c."	30 "30 - Manufacture of office, accounting and computing machinery"	///
                                          31 "31 - Manufacture of electrical machinery and apparatus n.e.c."	32 "32 - Manufacture of radio, television and communication equipment and apparatus"	33 "33 - Manufacture of medical, precision and optical instruments, watches and clocks"	34 "34 - Manufacture of motor vehicles, trailers and semi-trailers"	///
                                          35 "35 - Manufacture of other transport equipment"	36 "36 - Manufacture of furniture; manufacturing n.e.c."	37 "37 - Recycling"	40 "40 - Electricity, gas, steam and hot water supply"	///
                                          41 "41 - Collection, purification and distribution of water"	45 "45 - Construction"	50 "50 - Sale, maintenance and repair of motor vehicles and motorcycles; retail sale of automotive fuel"	51 "51 - Wholesale trade and commission trade, except of motor vehicles and motorcycles"	///
                                          52 "52 - Retail trade, except of motor vehicles and motorcycles; repair of personal and household goods"	55 "55 - Hotels and restaurants"	60 "60 - Land transport; transport via pipelines"	61 "61 - Water transport"	///
                                          62 "62 - Air transport"	63 "63 - Supporting and auxiliary transport activities; activities of travel agencies"	64 "64 - Post and telecommunications"	65 "65 - Financial intermediation, except insurance and pension funding"	///
                                          66 "66 - Insurance and pension funding, except compulsory social security"	67 "67 - Activities auxiliary to financial intermediation"	70 "70 - Real estate activities"	71 "71 - Renting of machinery and equipment without operator and of personal and household goods"	///
                                          72 "72 - Computer and related activities"	73 "73 - Research and development"	74 "74 - Other business activities"	75 "75 - Public administration and defence; compulsory social security"	///
                                          80 "80 - Education"	85 "85 - Health and social work"	90 "90 - Sewage and refuse disposal, sanitation and similar activities"	91 "91 - Activities of membership organizations n.e.c."	///
                                          92 "92 - Recreational, cultural and sporting activities"	93 "93 - Other service activities"	95 "95 - Activities of private households as employers of domestic staff"	96 "96 - Undifferentiated goods-producing activities of private households for own use"	///
                                          97 "97 - Undifferentiated service-producing activities of private households for own use"	99 "99 - Extra-territorial organizations and bodies"			
                lab val ilo_job1_eco_isic3_2digits eco_isic3_2digits
                lab var ilo_job1_eco_isic3_2digits "Economic activity (ISIC Rev. 3.1), 2 digits level - main job"

	
	* ISIC Rev. 3.1 

gen ilo_job1_eco_isic3=.
		replace ilo_job1_eco_isic3=1 if inrange(ilo_job1_eco_isic3_2digits,1,2)
		replace ilo_job1_eco_isic3=2 if ilo_job1_eco_isic3_2digits==5
		replace ilo_job1_eco_isic3=3 if inrange(ilo_job1_eco_isic3_2digits,10,14)
		replace ilo_job1_eco_isic3=4 if inrange(ilo_job1_eco_isic3_2digits,15,37)
		replace ilo_job1_eco_isic3=5 if inrange(ilo_job1_eco_isic3_2digits,40,41)
		replace ilo_job1_eco_isic3=6 if ilo_job1_eco_isic3_2digits==45
		replace ilo_job1_eco_isic3=7 if inrange(ilo_job1_eco_isic3_2digits,50,52)
		replace ilo_job1_eco_isic3=8 if ilo_job1_eco_isic3_2digits==55
		replace ilo_job1_eco_isic3=9 if inrange(ilo_job1_eco_isic3_2digits,60,64)
		replace ilo_job1_eco_isic3=10 if inrange(ilo_job1_eco_isic3_2digits,65,67)
		replace ilo_job1_eco_isic3=11 if inrange(ilo_job1_eco_isic3_2digits,70,74)
		replace ilo_job1_eco_isic3=12 if ilo_job1_eco_isic3_2digits==75
		replace ilo_job1_eco_isic3=13 if ilo_job1_eco_isic3_2digits==80
		replace ilo_job1_eco_isic3=14 if ilo_job1_eco_isic3_2digits==85
		replace ilo_job1_eco_isic3=15 if inrange(ilo_job1_eco_isic3_2digits,90,93)
		replace ilo_job1_eco_isic3=16 if ilo_job1_eco_isic3_2digits==95
		replace ilo_job1_eco_isic3=17 if ilo_job1_eco_isic3_2digits==99
		replace ilo_job1_eco_isic3=18 if ilo_job1_eco_isic3_2digits==. & ilo_lfs==1
		        lab def eco_isic3_1digit 1 "A - Agriculture, hunting and forestry"	2 "B - Fishing"	3 "C - Mining and quarrying"	4 "D - Manufacturing"	///
                                         5 "E - Electricity, gas and water supply"	6 "F - Construction"	7 "G - Wholesale and retail trade; repair of motor vehicles, motorcycles and personal and household goods"	8 "H - Hotels and restaurants"	///
                                         9 "I - Transport, storage and communications"	10 "J - Financial intermediation"	11 "K - Real estate, renting and business activities"	12 "L - Public administration and defence; compulsory social security"	///
                                         13 "M - Education"	14 "N - Health and social work"	15 "O - Other community, social and personal service activities"	16 "P - Activities of private households as employers and undifferentiated production activities of private households"	///
                                         17 "Q - Extraterritorial organizations and bodies"	18 "X - Not elsewhere classified"			
			    lab val ilo_job1_eco_isic3 eco_isic3_1digit
			    lab var ilo_job1_eco_isic3 "Economic activity (ISIC Rev. 3.1) - main job"
			
	* Now do the classification on an aggregate level
	
	* Primary activity
	
	gen ilo_job1_eco_aggregate=.
		replace ilo_job1_eco_aggregate=1 if inlist(ilo_job1_eco_isic3,1,2)
		replace ilo_job1_eco_aggregate=2 if ilo_job1_eco_isic3==4
		replace ilo_job1_eco_aggregate=3 if ilo_job1_eco_isic3==6
		replace ilo_job1_eco_aggregate=4 if inlist(ilo_job1_eco_isic3,3,5)
		replace ilo_job1_eco_aggregate=5 if inrange(ilo_job1_eco_isic3,7,11)
		replace ilo_job1_eco_aggregate=6 if inrange(ilo_job1_eco_isic3,12,17)
		replace ilo_job1_eco_aggregate=7 if ilo_job1_eco_isic3==18
			lab def eco_aggr_lab 1 "1 - Agriculture" 2 "2 - Manufacturing" 3 "3 - Construction" 4 "4 - Mining and quarrying; Electricity, gas and water supply" ///
								     5 "5 - Market Services (Trade; Transportation; Accommodation and food; and Business and administrative services)"  ///
								     6 "6 - Non-market services (Public administration; Community, social and other services and activities)" 7 "7 - Not classifiable by economic activity"					
			lab val ilo_job1_eco_aggregate eco_aggr_lab
			lab var ilo_job1_eco_aggregate "Economic activity (Aggregate) - main job"
}
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupation ('ilo_ocu') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
		/* Classification used: ISCO 88  */ 
		

		
if ${time} >=2015 {
gen ilo_job1_ocu_isco08_2digits=trunc(ce425cod/100) if (ilo_lfs==1) 
	replace ilo_job1_ocu_isco08_2digits=. if inlist(ilo_job1_ocu_isco08_2digits,5,9,47,98,99,85,631,921,999)

				* ISCO 08 - 2 digit
		        lab def ocu_isco08_2digits 1 "01 - Commissioned armed forces officers"	2 "02 - Non-commissioned armed forces officers"	3 "03 - Armed forces occupations, other ranks"	11 "11 - Chief executives, senior officials and legislators"	///
                                           12 "12 - Administrative and commercial managers"	13 "13 - Production and specialised services managers"	14 "14 - Hospitality, retail and other services managers"	21 "21 - Science and engineering professionals"	///
                                           22 "22 - Health professionals"	23 "23 - Teaching professionals"	24 "24 - Business and administration professionals"	25 "25 - Information and communications technology professionals"	///
                                           26 "26 - Legal, social and cultural professionals"	31 "31 - Science and engineering associate professionals"	32 "32 - Health associate professionals"	33 "33 - Business and administration associate professionals"	///
                                           34 "34 - Legal, social, cultural and related associate professionals"	35 "35 - Information and communications technicians"	41 "41 - General and keyboard clerks"	42 "42 - Customer services clerks"	///
                                           43 "43 - Numerical and material recording clerks"	44 "44 - Other clerical support workers"	51 "51 - Personal service workers"	52 "52 - Sales workers"	///
                                           53 "53 - Personal care workers"	54 "54 - Protective services workers"	61 "61 - Market-oriented skilled agricultural workers"	62 "62 - Market-oriented skilled forestry, fishery and hunting workers"	///
                                           63 "63 - Subsistence farmers, fishers, hunters and gatherers"	71 "71 - Building and related trades workers, excluding electricians"	72 "72 - Metal, machinery and related trades workers"	73 "73 - Handicraft and printing workers"	///
                                           74 "74 - Electrical and electronic trades workers"	75 "75 - Food processing, wood working, garment and other craft and related trades workers"	81 "81 - Stationary plant and machine operators"	82 "82 - Assemblers"	///
                                           83 "83 - Drivers and mobile plant operators"	91 "91 - Cleaners and helpers"	92 "92 - Agricultural, forestry and fishery labourers"	93 "93 - Labourers in mining, construction, manufacturing and transport"	///
                                           94 "94 - Food preparation assistants"	95 "95 - Street and related sales and service workers"	96 "96 - Refuse workers and other elementary workers"		
	            lab values ilo_job1_ocu_isco08_2digits ocu_isco08_2digits
	            lab var ilo_job1_ocu_isco08_2digits "Occupation (ISCO-08), 2 digit level - main job"
		
		* ISCO 08 - 1 digit
			gen ilo_job1_ocu_isco08=.
				replace ilo_job1_ocu_isco08=1 if inrange(ilo_job1_ocu_isco08_2digits,10,19)
				replace ilo_job1_ocu_isco08=2 if inrange(ilo_job1_ocu_isco08_2digits,20,29)
				replace ilo_job1_ocu_isco08=3 if inrange(ilo_job1_ocu_isco08_2digits,30,39)
				replace ilo_job1_ocu_isco08=4 if inrange(ilo_job1_ocu_isco08_2digits,40,49)
				replace ilo_job1_ocu_isco08=5 if inrange(ilo_job1_ocu_isco08_2digits,50,59)
				replace ilo_job1_ocu_isco08=6 if inrange(ilo_job1_ocu_isco08_2digits,60,69)
				replace ilo_job1_ocu_isco08=7 if inrange(ilo_job1_ocu_isco08_2digits,70,79)
				replace ilo_job1_ocu_isco08=8 if inrange(ilo_job1_ocu_isco08_2digits,80,89)
				replace ilo_job1_ocu_isco08=9 if inrange(ilo_job1_ocu_isco08_2digits,90,99)
				replace ilo_job1_ocu_isco08=10 if inrange(ilo_job1_ocu_isco08_2digits,1,9)
				replace ilo_job1_ocu_isco08=11 if (ilo_job1_ocu_isco08==. & ilo_lfs==1)
		        lab def ocu_isco08_1digit 1 "1 - Managers"	2 "2 - Professionals"	3 "3 - Technicians and associate professionals"	4 "4 - Clerical support workers"	///
                                          5 "5 - Service and sales workers"	6 "6 - Skilled agricultural, forestry and fishery workers"	7 "7 - Craft and related trades workers"	8 "8 - Plant and machine operators, and assemblers"	///
                                          9 "9 - Elementary occupations"	10 "0 - Armed forces occupations"	11 "X - Not elsewhere classified"		
				lab val ilo_job1_ocu_isco08 ocu_isco08_1digit
				lab var ilo_job1_ocu_isco08 "Occupation (ISCO-08) - main job"	

		* Aggregate:			
			gen ilo_job1_ocu_aggregate=.
				replace ilo_job1_ocu_aggregate=1 if inrange(ilo_job1_ocu_isco08,1,3)
				replace ilo_job1_ocu_aggregate=2 if inlist(ilo_job1_ocu_isco08,4,5)
				replace ilo_job1_ocu_aggregate=3 if inlist(ilo_job1_ocu_isco08,6,7)
				replace ilo_job1_ocu_aggregate=4 if ilo_job1_ocu_isco08==8
				replace ilo_job1_ocu_aggregate=5 if ilo_job1_ocu_isco08==9
				replace ilo_job1_ocu_aggregate=6 if ilo_job1_ocu_isco08==10
				replace ilo_job1_ocu_aggregate=7 if ilo_job1_ocu_isco08==11
					lab def ocu_aggr_lab 1 "1 - Managers, professionals, and technicians" 2 "2 - Clerical, service and sales workers" 3 "3 - Skilled agricultural and trades workers" ///
				 					 4 "4 - Plant and machine operators, and assemblers" 5 "5 - Elementary occupations" 6 "6 - Armed forces" 7 "7 - Not elsewhere classified"
					lab val ilo_job1_ocu_aggregate ocu_aggr_lab
					lab var ilo_job1_ocu_aggregate "Occupation (Aggregate) - main job"	
					
					
		* Skill level
		recode ilo_job1_ocu_isco08 (1/3=3) (4/8=2) (9=1) (10/11=4) ,gen(ilo_job1_ocu_skill)
				lab def ocu_skill_lab 1 "1 - Skill level 1 (low)" 2 "2 - Skill level 2 (medium)" 3 "3 - Skill levels 3 and 4 (high)" 4 "4 - Not elsewhere classified"
			    lab val ilo_job1_ocu_skill ocu_skill_lab
			    lab var ilo_job1_ocu_skill "Occupation (Skill level) - main job"
} 
else {
gen ilo_job1_ocu_isco88_2digits=trunc(ce425cod/100000) if (ilo_lfs==1)
	replace ilo_job1_ocu_isco88_2digits=. if inlist(ilo_job1_ocu_isco88_2digits,37,69,50,0,55,9,10,14,15,18,29,43,45,53,60,75,80,85,86,90,19)

	
		* ISCO 88 - 2 digit
			
			replace ilo_job1_ocu_isco88_2digits=. if ilo_job1_ocu_isco88_2digits>93
		        lab def ocu_isco88_2digits 1 "01 - Armed forces"	11 "11 - Legislators and senior officials"	12 "12 - Corporate managers"	13 "13 - General managers"	///
                                           21 "21 - Physical, mathematical and engineering science professionals"	22 "22 - Life science and health professionals"	23 "23 - Teaching professionals"	24 "24 - Other professionals"	///
                                           31 "31 - Physical and engineering science associate professionals"	32 "32 - Life science and health associate professionals"	33 "33 - Teaching associate professionals"	34 "34 - Other associate professionals"	///
                                           41 "41 - Office clerks"	42 "42 - Customer services clerks"	51 "51 - Personal and protective services workers"	52 "52 - Models, salespersons and demonstrators"	///
                                           61 "61 - Skilled agricultural and fishery workers"	62 "62 - Subsistence agricultural and fishery workers"	71 "71 - Extraction and building trades workers"	72 "72 - Metal, machinery and related trades workers"	///
                                           73 "73 - Precision, handicraft, craft printing and related trades workers"	74 "74 - Other craft and related trades workers"	81 "81 - Stationary plant and related operators"	82 "82 - Machine operators and assemblers"	///
                                           83 "83 - Drivers and mobile plant operators"	91 "91 - Sales and services elementary occupations"	92 "92 - Agricultural, fishery and related labourers"	93 "93 - Labourers in mining, construction, manufacturing and transport"	
	            lab values ilo_job1_ocu_isco88_2digits ocu_isco88_2digits
	            lab var ilo_job1_ocu_isco88_2digits "Occupation (ISCO-88), 2 digit level - main job"
		
		* ISCO 88 - 1 digit
			gen ilo_job1_ocu_isco88=.
				replace ilo_job1_ocu_isco88=1 if inrange(ilo_job1_ocu_isco88_2digits,11,14)
				replace ilo_job1_ocu_isco88=2 if inrange(ilo_job1_ocu_isco88_2digits,21,26)
				replace ilo_job1_ocu_isco88=3 if inrange(ilo_job1_ocu_isco88_2digits,31,35)
				replace ilo_job1_ocu_isco88=4 if inrange(ilo_job1_ocu_isco88_2digits,41,44)
				replace ilo_job1_ocu_isco88=5 if inrange(ilo_job1_ocu_isco88_2digits,51,54)
				replace ilo_job1_ocu_isco88=6 if inrange(ilo_job1_ocu_isco88_2digits,61,63)
				replace ilo_job1_ocu_isco88=7 if inrange(ilo_job1_ocu_isco88_2digits,71,75)
				replace ilo_job1_ocu_isco88=8 if inrange(ilo_job1_ocu_isco88_2digits,81,83)
				replace ilo_job1_ocu_isco88=9 if inrange(ilo_job1_ocu_isco88_2digits,91,96)
				replace ilo_job1_ocu_isco88=10 if inrange(ilo_job1_ocu_isco88_2digits,1,3)
				replace ilo_job1_ocu_isco88=11 if ilo_job1_ocu_isco88==. & ilo_lfs==1
					lab def ocu_isco88_1digit 1 "1 - Legislators, senior officials and managers"	2 "2 - Professionals"	3 "3 - Technicians and associate professionals"	4 "4 - Clerks"	///
                                          5 "5 - Service workers and shop and market sales workers"	6 "6 - Skilled agricultural and fishery workers"	7 "7 - Craft and related trades workers"	8 "8 - Plant and machine operators and assemblers"	///
                                          9 "9 - Elementary occupations"	10 "0 - Armed forces"	11 "11 - Not elsewhere classified"		
					lab val ilo_job1_ocu_isco88 ocu_isco88_1digit
					lab var ilo_job1_ocu_isco88 "Occupation (ISCO-88) - main job"	

		* Aggregate:			
			gen ilo_job1_ocu_aggregate=.
				replace ilo_job1_ocu_aggregate=1 if inrange(ilo_job1_ocu_isco88,1,3)
				replace ilo_job1_ocu_aggregate=2 if inlist(ilo_job1_ocu_isco88,4,5)
				replace ilo_job1_ocu_aggregate=3 if inlist(ilo_job1_ocu_isco88,6,7)
				replace ilo_job1_ocu_aggregate=4 if ilo_job1_ocu_isco88==8
				replace ilo_job1_ocu_aggregate=5 if ilo_job1_ocu_isco88==9
				replace ilo_job1_ocu_aggregate=6 if ilo_job1_ocu_isco88==10
				replace ilo_job1_ocu_aggregate=7 if ilo_job1_ocu_isco88==11
					lab def ocu_aggr_lab 1 "1 - Managers, professionals, and technicians" 2 "2 - Clerical, service and sales workers" 3 "3 - Skilled agricultural and trades workers" ///
									 4 "4 - Plant and machine operators, and assemblers" 5 "5 - Elementary occupations" 6 "6 - Armed forces" 7 "7 - Not elsewhere classified"
					lab val ilo_job1_ocu_aggregate ocu_aggr_lab
					lab var ilo_job1_ocu_aggregate "Occupation (Aggregate) - main job"
					
					
		* Skill level
		recode ilo_job1_ocu_isco88 (1/3=3) (4/8=2) (9=1) (10/11=4) ,gen(ilo_job1_ocu_skill)
				lab def ocu_skill_lab 1 "1 - Skill level 1 (low)" 2 "2 - Skill level 2 (medium)" 3 "3 - Skill levels 3 and 4 (high)" 4 "4 - Not elsewhere classified"
			    lab val ilo_job1_ocu_skill ocu_skill_lab
			    lab var ilo_job1_ocu_skill "Occupation (Skill level) - main job"
}

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Institutional sector of economic activities ('ilo_job1_ins_sector')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
	
	
	* if the respondant does not know the variable is not defined - NGO's are set in private
		gen ilo_job1_ins_sector=.
			replace ilo_job1_ins_sector=1 if (inlist(ce432,1) & ilo_lfs==1)	// Public
			replace ilo_job1_ins_sector=2 if (inlist(ce432,2,3,4,5,6,7,8,9,10,11,12,13) & ilo_lfs==1)	// Private
			* forcing missing to private
			replace ilo_job1_ins_sector=2 if (ilo_job1_ins_sector==.& ilo_lfs==1)
				lab def ins_sector_lab 1 "1 - Public" 2 "2 - Private" 
				lab values ilo_job1_ins_sector ins_sector_lab
				lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities"


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job1_job_time') -> Moved below for consistency with computed hours
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Type of contract ('ilo_job1_job_contract')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
		
*** no info (mixed with duration are other characteristics such as written etc..)

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Formal / Informal Economy ('ilo_job1_ife_prod' 'ilo_job1_ife_nature') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
if ${time} >2005 {

	
	*** Generating the nodes, From left to right 1 directs to first direction in the diagram (usually formal), 0 to the second (usually informal), and -1 if aplicable to the third one. Only unique paths)
	* Note that the definition are meant to work with both informal sector and economy
	
	*** Preparing necessary variables - the variables must be adjusted to fit the data
	
	* based on the status question, unfortunately no further info on corporate sector is done, therefore all private are treated equally (except household)
	recode ce432 ( 1 = 1) (2 4 5 6 7 8 9 10 11 12 13=0) (3 = -1), gen(todrop_institutional) 		// theoretical 3 value node/ +1 Gov, Corporation, NGO, Embassy, IO / 0 Farm or private business, other, not asked, don't know, NA / -1 private household
								// Household sector identified in the status in employment question
	replace todrop_institutional=0 if todrop_institutional==. 						// if the absence of the created variable is due to complete absence informality should not be computed
	if ${time} >=2015 {
	replace todrop_institutional=-1 if ilo_job1_eco_isic4_2digits==97|ilo_job1_ocu_isco08_2digits==63
	}
	else {
	replace todrop_institutional=-1 if ilo_job1_eco_isic3_2digits==95|ilo_job1_ocu_isco88_2digits==62
	}
	
	
	gen todrop_destinationprod=1 													// theoretical 2 value node / +1 At least partially market or Other, Not asked, Don't Know, NA/  0 Only for own final use (household) 
	
	
	gen todrop_producesforsale=1 													//  theoretical 2 value node / +1 Yes product for sale, Other, Not asked, Don't Know, NA/ 0 No, not for sale 
	replace todrop_producesforsale=0 if inlist(ce445,1)
	
	
	* Interestingly it seems to change a lot from 2009 to 2007 the question is the same, 
	* but the answers are somewhat different (still fully compatible, yet it changes the results quite dramatically)
	gen todrop_bookkeeping=.			// theoretical 2 value node/ +1 keeps accounts for GOV/ 0 does not keep accounts or personal use or other, not asked, DK, NA  
	egen todrop_pro_book=rowtotal(ce444_1-ce444_4)
	replace todrop_bookkeeping=1 if todrop_pro_book>0
	replace todrop_bookkeeping=0 if todrop_bookkeeping==.

	


	gen todrop_registration=.												// theoretical 3 value node/ +1 registered national level/ 0 not registered national level, other, DK / -1 not asked NA
		replace todrop_registration=-1 if todrop_registration==.


	gen todrop_SS=1 if ce438_1==1|inlist(ce438_2,1,2) 														// theoretical 3 value node/ +1 Social security/ 0 Not asked or don't know NA Other / -1 No social security 
		replace todrop_SS=-1 if todrop_SS==. 
		replace todrop_SS=0 if todrop_SS==.


		
	gen todrop_place=1 if inlist(ce443,3)										// theoretical 2 value node/ +1 fixed visible premises / 0 non fixed premises 
		replace todrop_place=0 if todrop_place==.
	
	*note that cuttof for size is at the 10 workers level (except for 2007<=year<2013)
	gen todrop_size=1 if inlist(ce431,2,3,4,5)										// theoretical 2 value node/ +1 equal or more than 6 workers / 0 less than 6 workers
	replace todrop_size=0 if inlist(ce431,1)
		
	gen todrop_paidleave=0									// theoretical 2 value node/ +1 paid leave / 0 no paid leave, not asked , DK, NA
		replace todrop_paidleave=0 if todrop_paidleave==.
		
	gen todrop_paidsick=0									// theoretical 2 value node/ +1 sick leave / 0 no sick leave, not asked, DK, NA
		replace todrop_paidsick=0 if todrop_paidsick==.
		

	**** Exception to force non employees without size-place data to informal
	*replace todrop_registration = 0 if ilo_lfs==1&todrop_institutional==0&todrop_destinationprod==1&todrop_bookkeeping==0&todrop_registration==-1&ilo_job1_ste_icse93!=1&(todrop_size==.|todrop_place==.)
	
	***********************************************************
	*** Obtention variables, this part should NEVER be modified
	***********************************************************
	* 1) Unit of production - Formal / Informal Sector
	
		/*the code is not condensed through ORs (for values of the same variables it is used but not for combinations of variables) or ellipsis for clarity (of concept) */

			gen ilo_job1_ife_prod=.
			
			* Formal
				replace ilo_job1_ife_prod = 2 if ilo_lfs==1&todrop_institutional==1
				replace ilo_job1_ife_prod = 2 if ilo_lfs==1&todrop_institutional==0&todrop_destinationprod==1&todrop_bookkeeping==1
				replace ilo_job1_ife_prod = 2 if ilo_lfs==1&todrop_institutional==0&todrop_destinationprod==1&todrop_bookkeeping==0&todrop_registration==1
				replace ilo_job1_ife_prod = 2 if ilo_lfs==1&todrop_institutional==0&todrop_destinationprod==1&todrop_bookkeeping==0&todrop_registration==-1&ilo_job1_ste_icse93==1&todrop_SS==1
				replace ilo_job1_ife_prod = 2 if ilo_lfs==1&todrop_institutional==0&todrop_destinationprod==1&todrop_bookkeeping==0&todrop_registration==-1&ilo_job1_ste_icse93==1&todrop_SS!=1&todrop_place==1&todrop_size==1
				replace ilo_job1_ife_prod = 2 if ilo_lfs==1&todrop_institutional==0&todrop_destinationprod==1&todrop_bookkeeping==0&todrop_registration==-1&ilo_job1_ste_icse93!=1&todrop_place==1&todrop_size==1
			* HH	
				replace ilo_job1_ife_prod = 3 if ilo_lfs==1&todrop_institutional==-1
				replace ilo_job1_ife_prod = 3 if ilo_lfs==1&todrop_institutional==0&todrop_destinationprod==0
			* Informal	
				replace ilo_job1_ife_prod = 1 if ilo_lfs==1&todrop_institutional==0&todrop_destinationprod==1&todrop_bookkeeping==0&todrop_registration==0
				replace ilo_job1_ife_prod = 1 if ilo_lfs==1&todrop_institutional==0&todrop_destinationprod==1&todrop_bookkeeping==0&todrop_registration==-1&ilo_job1_ste_icse93==1&todrop_SS!=1&todrop_place==0
				replace ilo_job1_ife_prod = 1 if ilo_lfs==1&todrop_institutional==0&todrop_destinationprod==1&todrop_bookkeeping==0&todrop_registration==-1&ilo_job1_ste_icse93==1&todrop_SS!=1&todrop_place==1&todrop_size==0
				replace ilo_job1_ife_prod = 1 if ilo_lfs==1&todrop_institutional==0&todrop_destinationprod==1&todrop_bookkeeping==0&todrop_registration==-1&ilo_job1_ste_icse93!=1&todrop_place==0
				replace ilo_job1_ife_prod = 1 if ilo_lfs==1&todrop_institutional==0&todrop_destinationprod==1&todrop_bookkeeping==0&todrop_registration==-1&ilo_job1_ste_icse93!=1&todrop_place==1&todrop_size==0
				* note, special loop for employees. If we have data on social security, and they say NO or don't know, and still we do not have a complete pair Size-Place of Work, they should go to informal
				replace ilo_job1_ife_prod = 1 if ilo_lfs==1&todrop_institutional==0&todrop_destinationprod==1&todrop_bookkeeping==0&todrop_registration==-1&ilo_job1_ste_icse93==1&todrop_SS==-1&(todrop_size==.|todrop_place==.)
				
			lab def ilo_ife_prod_lab 1 "1 - Informal" 2 "2 - Formal" 3 "3 - Household" 
			lab val ilo_job1_ife_prod ilo_ife_prod_lab
			lab var ilo_job1_ife_prod "Informal / Formal Economy (Unit of production)"


	* 2) Nature of job - Formal / Informal Job
	* note that the variable of informal/formal sector does not follow the node notation
			gen ilo_job1_ife_nature=.
			
			*Formal
				*Employee
				replace ilo_job1_ife_nature=2 if ilo_lfs==1&(ilo_job1_ste_icse93==1|ilo_job1_ste_icse93==6)&todrop_SS==1
				replace ilo_job1_ife_nature=2 if ilo_lfs==1&(ilo_job1_ste_icse93==1|ilo_job1_ste_icse93==6)&todrop_SS==0&todrop_paidleave==1&todrop_paidsick==1
				*Employers or Members of coop
				replace ilo_job1_ife_nature=2 if ilo_lfs==1&(ilo_job1_ste_icse93==2|ilo_job1_ste_icse93==4)&ilo_job1_ife_prod==2	
				*OAW
				replace ilo_job1_ife_nature=2 if ilo_lfs==1&ilo_job1_ste_icse93==3&todrop_producesforsale==1&ilo_job1_ife_prod==2
			* Informal
				*Employee
				replace ilo_job1_ife_nature=1 if ilo_lfs==1&(ilo_job1_ste_icse93==1|ilo_job1_ste_icse93==6)&todrop_SS==-1
				replace ilo_job1_ife_nature=1 if ilo_lfs==1&(ilo_job1_ste_icse93==1|ilo_job1_ste_icse93==6)&todrop_SS==0&todrop_paidleave==0
				replace ilo_job1_ife_nature=1 if ilo_lfs==1&(ilo_job1_ste_icse93==1|ilo_job1_ste_icse93==6)&todrop_SS==0&todrop_paidleave==1&todrop_paidsick==0
				*Employers or Members of coop
				replace ilo_job1_ife_nature=1 if ilo_lfs==1&(ilo_job1_ste_icse93==2|ilo_job1_ste_icse93==4)&(ilo_job1_ife_prod==1|ilo_job1_ife_prod==3)
				*OAW
				replace ilo_job1_ife_nature=1 if ilo_lfs==1&ilo_job1_ste_icse93==3&todrop_producesforsale==1&(ilo_job1_ife_prod==1|ilo_job1_ife_prod==3)
				replace ilo_job1_ife_nature=1 if ilo_lfs==1&ilo_job1_ste_icse93==3&todrop_producesforsale==0
			*Contributing Family Workers
				replace ilo_job1_ife_nature=1 if ilo_lfs==1&ilo_job1_ste_icse93==5
				

						lab def ife_nature_lab 1 "1 - Persons with informal main job" 2 "2 - Persons with formal main job"
						lab val ilo_job1_ife_nature ife_nature_lab
						lab var ilo_job1_ife_nature "Informal / Formal Economy (Nature of job) - Main job"
			*rename *todrop* *tokeep*

			capture drop todrop* 
	***********************************************************
	*** End informality****************************************
	***********************************************************
}

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Hours of work ('ilo_job1_how')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		


* Main job:

* 1) Weekly hours ACTUALLY worked - Main job
		
gen ilo_job1_how_actual=ce429 if (ilo_lfs==1&ce429<169)
					*to avoid missing values of workers that were temporary absent
					replace ilo_job1_how_actual=0 if ilo_lfs==1&ilo_job1_how_actual==.
					lab var ilo_job1_how_actual "Weekly hours actually worked in main job"

		
* 2) Weekly hours USUALLY worked , notice that it has to be obtained as a differential
			gen ilo_job1_how_usual=ce430 if (ilo_lfs==1&ce430<169)
			replace ilo_job1_how_usual=ilo_job1_how_actual if ilo_lfs==1 & ilo_job1_how_usual==.
					lab var ilo_job1_how_usual "Weekly hours usually worked in main job"
					
* Secondary job - actual
			gen ilo_job2_how_actual=ce453 if (ilo_mjh==2&ilo_lfs==1)&ce453<169
				lab var ilo_job2_how_actual "Weekly hours actually worked in second job"


* All jobs - actual

			egen ilo_joball_how_actual=rowtotal(ilo_job1_how_actual ilo_job2_how_actual) if (ilo_lfs==1)
				replace ilo_joball_how_actual=. if ilo_joball_how_actual>168
				lab var ilo_joball_how_actual "Weekly hours actually worked in all jobs"


		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Working time arrangement ('ilo_job1_job_time') <- Moved here to be able to use the computed hours
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			

	/* Threshold of 40 hours per week 	*/

			gen ilo_job1_job_time=.
				replace ilo_job1_job_time=1 if (ilo_job1_how_actual<40 & ilo_lfs==1) 	// Part-time
				replace ilo_job1_job_time=2 if (ilo_job1_how_actual>39&ilo_job1_how_actual!=. & ilo_lfs==1)	// Full-time
				replace ilo_job1_job_time=3 if (ilo_job1_how_actual==. & ilo_lfs==1)	// Unknown
					lab def job_time_lab 1 "1 - Part-time" 2 "2 - Full-time" 3 "3 - Unknown"
					lab val ilo_job1_job_time job_time_lab
					lab var ilo_job1_job_time "Job (Working time arrangement) - Main job"	



* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Monthly labour related income ('ilo_joball_lri')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			

			* Main job
			gen todrop_wage=ce440 if ce439==1
				replace todrop_wage=ce440*4.333333333333/2 if ce439==2
				replace todrop_wage=ce440*4.3333333333333 if ce439==3
				replace todrop_wage=ce440*4.333333333333*7 if ce439==4
				* Employees
					gen ilo_job1_lri_ees=todrop_wage if (ilo_job1_ste_aggregate==1)
						replace ilo_job1_lri_ees=. if ilo_job1_lri_ees==0 
							lab var ilo_job1_lri_ees "Monthly earnings of employees in main job"	
				
				* Self-employed
				*not computed, in the questionaire we have only gross income or self use of company funds
					*gen ilo_job1_lri_slf=e01aimde if (e01aimde<900000000 & inlist(ilo_job1_ste_icse93,2,3,4,6))
						*replace ilo_job1_lri_slf=. if ilo_job1_lri_slf==0
							*lab var ilo_job1_lri_slf "Monthly earnings of self-employed in main job"


			drop todrop*
***********************************************************************************************
*			PART 3.2. ECONOMIC CHARACTERISTICS FOR ALL JOBS 
***********************************************************************************************		

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Time-related underemployed ('ilo_joball_tru') 
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

		gen ilo_joball_tru=.
		* notice that the question bunches together willing and available
			replace ilo_joball_tru=1 if ilo_joball_how_actual<35 & ce472==1 & ilo_lfs==1
			lab def tru_lab 1 "Time-related underemployment"
			lab val ilo_joball_tru tru_lab
			lab var ilo_joball_tru "Time-related underemployment"	
		

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Occupational injury ('ilo_joball_inj')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------			
		
* Not available

***********************************************************************************************
*			PART 3.3. UNEMPLOYMENT: ECONOMIC CHARACTERISTICS
***********************************************************************************************		
		
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Category of unemployment ('ilo_cat_une')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
	gen ilo_cat_une=.
		replace ilo_cat_une=1 if (ce412==1&ilo_lfs==2)
		replace ilo_cat_une=2 if (ce412==2&ilo_lfs==2)
		replace ilo_cat_une=3 if (ilo_cat_une==.&ilo_lfs==2)
				lab def ilo_cat_une 1 "Unemployed previously employed" 2 "Unemployed seeking first job" 3 "Unknown"
				lab val ilo_cat_une ilo_cat_une
				lab var ilo_cat_une "Category of unemployment"
	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Duration of unemployment ('ilo_dur')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------

	gen todrop1=ce411 if ce411tiempo == 3
	gen todrop2=ce411/4.33 if ce411tiempo == 2
	gen todrop4=ce411/(4.33*7) if ce411tiempo == 1
	egen todrop=rowtotal(todrop*)
	replace todrop=. if todrop==0
	
	gen todropB1=ce417 if ce417_tiempo == 3
	gen todropB2=ce417/4.33 if ce417_tiempo == 2
	gen todropB3=ce417*12 if ce417_tiempo == 4
	gen todropB4=ce417/(4.33*7) if ce417_tiempo == 1
	egen todropB=rowtotal(todropB*)
	replace todropB=. if todropB==0

	* Seeking or without employment, whichever is shorter
	*using as a base seeking due to scope
	replace todrop=todropB if todropB<todrop
	
	gen ilo_dur_details=.
				replace ilo_dur_details=1 if (todrop<1 & ilo_lfs==2)
				replace ilo_dur_details=2 if (inrange(todrop,1,2.999999) & ilo_lfs==2)
				replace ilo_dur_details=3 if (inrange(todrop,3,5.999999) & ilo_lfs==2)
				replace ilo_dur_details=4 if (inrange(todrop,6,11.999999) & ilo_lfs==2)
				replace ilo_dur_details=5 if (inrange(todrop,12,23.999999) & ilo_lfs==2)
				replace ilo_dur_details=6 if (inrange(todrop,24,1440) & ilo_lfs==2)
				replace ilo_dur_details=7 if (ilo_dur_details==. & ilo_lfs==2)
					lab def ilo_unemp_det 1 "Less than 1 month" 2 "1 month to less than 3 months" 3 "3 months to less than 6 months" ///
											4 "6 months to less than 12 months" 5 "12 months to less than 24 months" 6 "24 months or more" ///
											7 "Not elsewhere classified"
					lab val ilo_dur_details ilo_unemp_det
					lab var ilo_dur_details "Duration of unemployment (Details)"

	gen ilo_dur_aggregate=.
				replace ilo_dur_aggregate=1 if (inlist(ilo_dur_details,1,2,3) & ilo_lfs==2)
				replace ilo_dur_aggregate=2 if (ilo_dur_details==4 & ilo_lfs==2)
				replace ilo_dur_aggregate=3 if (inlist(ilo_dur_details,5,6) & ilo_lfs==2)
				replace ilo_dur_aggregate=4 if (ilo_dur_details==7 & ilo_lfs==2)
					lab def ilo_unemp_aggr 1 "Less than 6 months" 2 "6 months to less than 12 months" 3 "12 months or more" 4 "Not elsewhere classified"
					lab val ilo_dur_aggregate ilo_unemp_aggr
					lab var ilo_dur_aggregate "Duration of unemployment (Aggregate)"
	drop todrop*

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous economic activity ('ilo_preveco_aggregate')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

if ${time} >=2015 {
generate ilo_preveco_isic4_2digits = trunc(ce416cod/100) if ilo_lfs==2 & ilo_cat_une==1

                 * labels already defined for main job
                lab val ilo_preveco_isic4_2digits eco_isic4_2digits
                lab var ilo_preveco_isic4_2digits "Previous economic activity (ISIC Rev. 4), 2 digits level"
	
	
	gen ilo_preveco_isic4=.
			replace ilo_preveco_isic4=1 if inrange(ilo_preveco_isic4_2digits,1,3)
			replace ilo_preveco_isic4=2 if inrange(ilo_preveco_isic4_2digits,5,9)
			replace ilo_preveco_isic4=3 if inrange(ilo_preveco_isic4_2digits,10,33)
			replace ilo_preveco_isic4=4 if ilo_preveco_isic4_2digits==35
			replace ilo_preveco_isic4=5 if inrange(ilo_preveco_isic4_2digits,36,39)
			replace ilo_preveco_isic4=6 if inrange(ilo_preveco_isic4_2digits,41,43)
			replace ilo_preveco_isic4=7 if inrange(ilo_preveco_isic4_2digits,45,47)
			replace ilo_preveco_isic4=8 if inrange(ilo_preveco_isic4_2digits,49,53)
			replace ilo_preveco_isic4=9 if inrange(ilo_preveco_isic4_2digits,55,56)
			replace ilo_preveco_isic4=10 if inrange(ilo_preveco_isic4_2digits,58,63)
			replace ilo_preveco_isic4=11 if inrange(ilo_preveco_isic4_2digits,64,66)
			replace ilo_preveco_isic4=12 if ilo_preveco_isic4_2digits==68
			replace ilo_preveco_isic4=13 if inrange(ilo_preveco_isic4_2digits,69,75)
			replace ilo_preveco_isic4=14 if inrange(ilo_preveco_isic4_2digits,77,82)
			replace ilo_preveco_isic4=15 if ilo_preveco_isic4_2digits==84
			replace ilo_preveco_isic4=16 if ilo_preveco_isic4_2digits==85
			replace ilo_preveco_isic4=17 if inrange(ilo_preveco_isic4_2digits,86,88)
			replace ilo_preveco_isic4=18 if inrange(ilo_preveco_isic4_2digits,90,93)
			replace ilo_preveco_isic4=19 if inrange(ilo_preveco_isic4_2digits,94,96)
			replace ilo_preveco_isic4=20 if inrange(ilo_preveco_isic4_2digits,97,98)
			replace ilo_preveco_isic4=21 if ilo_preveco_isic4_2digits==99
			replace ilo_preveco_isic4=22 if ilo_preveco_isic4==. & ilo_lfs==2 & ilo_cat_une==1
	             * labels already defined for main job
		        lab val ilo_preveco_isic4 eco_isic4_1digit
			    lab var ilo_preveco_isic4 "Previous economic activity (ISIC Rev. 4)"
				
		
	* Now do the classification on an aggregate level
	
		* Primary activity
		
		gen ilo_preveco_aggregate=.
			replace ilo_preveco_aggregate=1 if ilo_preveco_isic4==1
			replace ilo_preveco_aggregate=2 if ilo_preveco_isic4==3
			replace ilo_preveco_aggregate=3 if ilo_preveco_isic4==6
			replace ilo_preveco_aggregate=4 if inlist(ilo_preveco_isic4,2,4,5)
			replace ilo_preveco_aggregate=5 if inrange(ilo_preveco_isic4,7,14)
			replace ilo_preveco_aggregate=6 if inrange(ilo_preveco_isic4,15,21)
			replace ilo_preveco_aggregate=7 if ilo_preveco_isic4==22
              * labels already defined for main job
	           lab val ilo_preveco_aggregate eco_aggr_lab
			   lab var ilo_preveco_aggregate "Previous economic activity (Aggregate)"


} 
else {
generate rev3 = trunc(ce416cod/1000)


	* 4 digit isic 3

	merge n:1 rev3 using "Internal\isic331.dta"
	drop if _merge==2
	drop _merge
	gen ilo_preveco_isic3_2digits=trunc(rev31/100) if ilo_lfs==2 & ilo_cat_une==1
	drop rev3 rev31
                * labels already defined for main job
		        lab val ilo_preveco_isic3_2digits eco_isic3_2digits
                lab var ilo_preveco_isic3_2digits "Previous economic activity (ISIC Rev. 3.1), 2 digits level"

	
	* ISIC Rev. 3.1 

gen ilo_preveco_isic3=.
		replace ilo_preveco_isic3=1 if inrange(ilo_preveco_isic3_2digits,1,2)
		replace ilo_preveco_isic3=2 if ilo_preveco_isic3_2digits==5
		replace ilo_preveco_isic3=3 if inrange(ilo_preveco_isic3_2digits,10,14)
		replace ilo_preveco_isic3=4 if inrange(ilo_preveco_isic3_2digits,15,37)
		replace ilo_preveco_isic3=5 if inrange(ilo_preveco_isic3_2digits,40,41)
		replace ilo_preveco_isic3=6 if ilo_preveco_isic3_2digits==45
		replace ilo_preveco_isic3=7 if inrange(ilo_preveco_isic3_2digits,50,52)
		replace ilo_preveco_isic3=8 if ilo_preveco_isic3_2digits==55
		replace ilo_preveco_isic3=9 if inrange(ilo_preveco_isic3_2digits,60,64)
		replace ilo_preveco_isic3=10 if inrange(ilo_preveco_isic3_2digits,65,67)
		replace ilo_preveco_isic3=11 if inrange(ilo_preveco_isic3_2digits,70,74)
		replace ilo_preveco_isic3=12 if ilo_preveco_isic3_2digits==75
		replace ilo_preveco_isic3=13 if ilo_preveco_isic3_2digits==80
		replace ilo_preveco_isic3=14 if ilo_preveco_isic3_2digits==85
		replace ilo_preveco_isic3=15 if inrange(ilo_preveco_isic3_2digits,90,93)
		replace ilo_preveco_isic3=16 if ilo_preveco_isic3_2digits==95
		replace ilo_preveco_isic3=17 if ilo_preveco_isic3_2digits==99
		replace ilo_preveco_isic3=18 if ilo_preveco_isic3==. & ilo_lfs==2 & ilo_cat_une==1
                * labels already defined for main job
		        lab val ilo_preveco_isic3 eco_isic3_1digit
			    lab var ilo_preveco_isic3 "Previous economic activity (ISIC Rev. 3.1)"
			
	* Now do the classification on an aggregate level
	
	* Primary activity
	
	gen ilo_preveco_aggregate=.
		replace ilo_preveco_aggregate=1 if inlist(ilo_preveco_isic3,1,2)
		replace ilo_preveco_aggregate=2 if ilo_preveco_isic3==4
		replace ilo_preveco_aggregate=3 if ilo_preveco_isic3==6
		replace ilo_preveco_aggregate=4 if inlist(ilo_preveco_isic3,3,5)
		replace ilo_preveco_aggregate=5 if inrange(ilo_preveco_isic3,7,11)
		replace ilo_preveco_aggregate=6 if inrange(ilo_preveco_isic3,12,17)
		replace ilo_preveco_aggregate=7 if ilo_preveco_isic3==18
                * labels already defined for main job
		        lab val ilo_preveco_aggregate eco_aggr_lab
			    lab var ilo_preveco_aggregate "Previous economic activity (Aggregate)"
}	
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Previous occupation ('ilo_prevocu_isco88')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

if ${time} >=2015 {
gen ilo_prevocu_isco08_2digits=trunc(ce415cod/100) if (ilo_lfs==2&ilo_cat_une==1)
	replace ilo_prevocu_isco08_2digits=. if inlist(ilo_prevocu_isco08_2digits,0,999)
	             * labels already defined for main job
		        lab values ilo_prevocu_isco08_2digits ocu_isco08_2digits
	            lab var ilo_prevocu_isco08_2digits "Previous occupation (ISCO-08), 2 digit level"
	
		* ISCO 08 - 1 digit
			gen ilo_prevocu_isco08=.
				replace ilo_prevocu_isco08=1 if inrange(ilo_prevocu_isco08_2digits,10,19)
				replace ilo_prevocu_isco08=2 if inrange(ilo_prevocu_isco08_2digits,20,29)
				replace ilo_prevocu_isco08=3 if inrange(ilo_prevocu_isco08_2digits,30,39)
				replace ilo_prevocu_isco08=4 if inrange(ilo_prevocu_isco08_2digits,40,49)
				replace ilo_prevocu_isco08=5 if inrange(ilo_prevocu_isco08_2digits,50,59)
				replace ilo_prevocu_isco08=6 if inrange(ilo_prevocu_isco08_2digits,60,69)
				replace ilo_prevocu_isco08=7 if inrange(ilo_prevocu_isco08_2digits,70,79)
				replace ilo_prevocu_isco08=8 if inrange(ilo_prevocu_isco08_2digits,80,89)
				replace ilo_prevocu_isco08=9 if inrange(ilo_prevocu_isco08_2digits,90,99)
				replace ilo_prevocu_isco08=10 if inrange(ilo_prevocu_isco08_2digits,1,9)
				replace ilo_prevocu_isco08=11 if (ilo_prevocu_isco08==. & ilo_lfs==2&ilo_cat_une==1)
					* labels already defined for main job
						lab val ilo_prevocu_isco08 ocu_isco08_1digit
						lab var ilo_prevocu_isco08 "Previous occupation (ISCO-08)"		

		* Aggregate:			
			gen ilo_prevocu_aggregate=.
				replace ilo_prevocu_aggregate=1 if inrange(ilo_prevocu_isco08,1,3)
				replace ilo_prevocu_aggregate=2 if inlist(ilo_prevocu_isco08,4,5)
				replace ilo_prevocu_aggregate=3 if inlist(ilo_prevocu_isco08,6,7)
				replace ilo_prevocu_aggregate=4 if ilo_prevocu_isco08==8
				replace ilo_prevocu_aggregate=5 if ilo_prevocu_isco08==9
				replace ilo_prevocu_aggregate=6 if ilo_prevocu_isco08==10
				replace ilo_prevocu_aggregate=7 if ilo_prevocu_isco08==11
					* labels already defined for main job
						lab val ilo_prevocu_aggregate ocu_aggr_lab
						lab var ilo_prevocu_aggregate "Previous occupation (Aggregate)"	
					
					
		* Skill level
		recode ilo_prevocu_isco08 (1/3=3) (4/8=2) (9=1) (10/11=4) ,gen(ilo_prevocu_skill)
                * labels already defined for main job
			    lab val ilo_prevocu_skill ocu_skill_lab
			    lab var ilo_prevocu_skill "Previous occupation (Skill level)"
} 
else {
gen ilo_prevocu_isco88_2digits=trunc(ce415cod/100000) if (ilo_lfs==2&ilo_cat_une==1)
	replace ilo_prevocu_isco88_2digits=. if inlist(ilo_prevocu_isco88_2digits,0,50,55)
		* ISCO 88 - 2 digit
			
			replace ilo_prevocu_isco88_2digits=. if ilo_prevocu_isco88_2digits>93
                * labels already defined for main job
		        lab values ilo_prevocu_isco88_2digits ocu_isco88_2digits
	            lab var ilo_prevocu_isco88_2digits "Previous occupation (ISCO-88), 2 digit level"
		
		* ISCO 88 - 1 digit
			gen ilo_prevocu_isco88=.
				replace ilo_prevocu_isco88=1 if inrange(ilo_prevocu_isco88_2digits,11,14)
				replace ilo_prevocu_isco88=2 if inrange(ilo_prevocu_isco88_2digits,21,26)
				replace ilo_prevocu_isco88=3 if inrange(ilo_prevocu_isco88_2digits,31,35)
				replace ilo_prevocu_isco88=4 if inrange(ilo_prevocu_isco88_2digits,41,44)
				replace ilo_prevocu_isco88=5 if inrange(ilo_prevocu_isco88_2digits,51,54)
				replace ilo_prevocu_isco88=6 if inrange(ilo_prevocu_isco88_2digits,61,63)
				replace ilo_prevocu_isco88=7 if inrange(ilo_prevocu_isco88_2digits,71,75)
				replace ilo_prevocu_isco88=8 if inrange(ilo_prevocu_isco88_2digits,81,83)
				replace ilo_prevocu_isco88=9 if inrange(ilo_prevocu_isco88_2digits,91,96)
				replace ilo_prevocu_isco88=10 if inrange(ilo_prevocu_isco88_2digits,1,3)
				replace ilo_prevocu_isco88=11 if ilo_prevocu_isco88==. & ilo_lfs==2&ilo_cat_une==1
	               * labels already defined for main job
		            lab val ilo_prevocu_isco88 ocu_isco88_1digit
				    lab var ilo_prevocu_isco88 "Previous occupation (ISCO-88)"		

		* Aggregate:			
			gen ilo_prevocu_aggregate=.
				replace ilo_prevocu_aggregate=1 if inrange(ilo_prevocu_isco88,1,3)
				replace ilo_prevocu_aggregate=2 if inlist(ilo_prevocu_isco88,4,5)
				replace ilo_prevocu_aggregate=3 if inlist(ilo_prevocu_isco88,6,7)
				replace ilo_prevocu_aggregate=4 if ilo_prevocu_isco88==8
				replace ilo_prevocu_aggregate=5 if ilo_prevocu_isco88==9
				replace ilo_prevocu_aggregate=6 if ilo_prevocu_isco88==10
				replace ilo_prevocu_aggregate=7 if ilo_prevocu_isco88==11
	                * labels already defined for main job
		          lab val ilo_prevocu_aggregate ocu_aggr_lab
				  lab var ilo_prevocu_aggregate "Previous occupation (Aggregate)"		
					
					
		* Skill level
		recode ilo_prevocu_isco88 (1/3=3) (4/8=2) (9=1) (10/11=4) ,gen(ilo_prevocu_skill)
                * labels already defined for main job
		        lab val ilo_prevocu_skill ocu_skill_lab
			    lab var ilo_prevocu_skill "Occupation (Skill level) - main job"
}

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			General social protection ('ilo_gsp_uneschemes')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	

	****** No information available in the questionnaire ******

	

***********************************************************************************************
*			PART 3.4. OUTSIDE LABOUR FORCE: ECONOMIC CHARACTERISTICS
***********************************************************************************************		

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Degree of labour market attachment ('ilo_olf_dlma')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
	*note, this cannot be adequately obtained
	*willing and available are bunched in the same question -> category 3 cannot be obtained
	*seeking is used as the scope for Willing&Available -> category 1 cannot be obtained
	gen ilo_olf_dlma=.
		*replace ilo_olf_dlma = 1 if (a05==6&a07==1)&ilo_lfs==3							 	//Seeking, not available
		replace ilo_olf_dlma = 2 if (ce405==2&ce408==1)&ilo_lfs==3								//Not seeking, available
		*replace ilo_olf_dlma = 3 if (a05==6&a07==6&inlist(a09,2,3,4,8,9,10) )&ilo_lfs==3  	//Not seeking, not available, willing (Willing non-job seekers) 
		replace ilo_olf_dlma = 4 if  ce405==2&ce408==2&ilo_lfs==3			//Not seeking, not available, not willing (Non-Willigness based reasons for not being available) 
		replace ilo_olf_dlma = 5 if	(ilo_olf_dlma==.) & ilo_lfs==3			// Not classified 
	
			lab def dlma_lab 1 "1 - Seeking, not available (Unavailable jobseekers)" 2 "2 - Not seeking, available (Available potential jobseekers)" ///
							 3 "3 - Not seeking, not available, willing (Willing non-jobseekers)" 4 "4 - Not seeking, not available, not willing" 5 "X - Not elsewhere classified"
			lab val ilo_olf_dlma dlma_lab 
			lab var ilo_olf_dlma "Labour market attachment (Degree of)"


* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Reason for not seeking job ('ilo_olf_reason')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		
* note that given the structure of the data the reason for not seeking the past week (USED IN THE UNEMPLOYMENT DEFINITION) is bunched together with not seeking past 4 weeks (NOT USED)
if ${time} >=2008 {
	gen ilo_olf_reason=.
		replace ilo_olf_reason=1 if	(inlist(ce409,6) & ilo_lfs==3)					//Labour market
		replace ilo_olf_reason=2 if	(inlist(ce409,1,2,3,4) & ilo_lfs==3)					//Labour market
		replace ilo_olf_reason=3 if	(inlist(ce409,5,7,9,10,11,12,15)  & ilo_lfs==3)				//Personal/Family-related
		replace ilo_olf_reason=4 if (inlist(ce409,13,14)  & ilo_lfs==3)							//Does not need/want to work
		replace ilo_olf_reason=5 if (inlist(ce409,8,16)  & ilo_lfs==3)						//Not elsewhere classified
		replace ilo_olf_reason=5 if (ilo_olf_reason==. & ilo_lfs==3)								//Not elsewhere classified
			lab def reasons_lab 1 "1 - Labour market" 2 "2 - Other labour market reasons" 3 "3 - Personal / Family-related" 4 "4 - Does not need/want to work" 5 "5 - Not elsewhere classified"
			lab val ilo_olf_reason reasons_lab 
			lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"
}
if ${time} ==2007 {
	gen ilo_olf_reason=.
		replace ilo_olf_reason=1 if	(inlist(ce409,6) & ilo_lfs==3)					//Labour market
		replace ilo_olf_reason=2 if	(inlist(ce409,1,2,3,4) & ilo_lfs==3)					//Labour market
		replace ilo_olf_reason=3 if	(inlist(ce409,5,7,9,10,12)  & ilo_lfs==3)				//Personal/Family-related
		replace ilo_olf_reason=4 if (inlist(ce409,10,11)  & ilo_lfs==3)							//Does not need/want to work
		replace ilo_olf_reason=5 if (inlist(ce409,8,13)  & ilo_lfs==3)						//Not elsewhere classified
		replace ilo_olf_reason=5 if (ilo_olf_reason==. & ilo_lfs==3)								//Not elsewhere classified
			lab def reasons_lab 1 "1 - Labour market" 2 "2 - Other labour market reasons" 3 "3 - Personal / Family-related" 4 "4 - Does not need/want to work" 5 "5 - Not elsewhere classified"
			lab val ilo_olf_reason reasons_lab 
			lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"


}

if ${time} ==2006 | ${time} ==2005 {
	gen ilo_olf_reason=.
		replace ilo_olf_reason=1 if	(inlist(ce409,6) & ilo_lfs==3)					//Labour market
		replace ilo_olf_reason=2 if	(inlist(ce409,1,2,3,4) & ilo_lfs==3)					//Labour market
		replace ilo_olf_reason=3 if	(inlist(ce409,5,7,9,10)  & ilo_lfs==3)				//Personal/Family-related
		replace ilo_olf_reason=4 if (inlist(ce409,10,11)  & ilo_lfs==3)							//Does not need/want to work
		replace ilo_olf_reason=5 if (inlist(ce409,8,12)  & ilo_lfs==3)						//Not elsewhere classified
		replace ilo_olf_reason=5 if (ilo_olf_reason==. & ilo_lfs==3)								//Not elsewhere classified
			lab def reasons_lab 1 "1 - Labour market" 2 "2 - Other labour market reasons" 3 "3 - Personal / Family-related" 4 "4 - Does not need/want to work" 5 "5 - Not elsewhere classified"
			lab val ilo_olf_reason reasons_lab 
			lab var ilo_olf_reason "Labour market attachment (Reasons for not seeking a job)"


}

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Discouraged job-seeker ('ilo_dis')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

	gen ilo_dis=1 if  ilo_olf_reason==1
			lab def dis_lab 1 "Discouraged job-seekers"
			lab val ilo_dis dis_lab
			lab var ilo_dis "Discouraged job-seekers"
			

* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Youth not in education, employment or training ('ilo_neet')
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------		

	gen ilo_neet=1 if (ilo_age_aggregate==2 & ilo_lfs!=1 & ilo_edu_attendance==2)
			lab def neet_lab 1 "Youth not in education, employment or training"
			lab val ilo_neet neet_lab
			lab var ilo_neet "Youth not in education, employment or training"
			
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------
*			Drop intermediate variables used for labeling activity and occupation
* -------------------------------------------------------------------------------------------
* -------------------------------------------------------------------------------------------	
capture drop isco08_2digits isco88_2digits isco08 isco88 isic4_2digits isic4 isic3_2digits isic3




***********************************************************************************************
***********************************************************************************************

*			3. SAVE ILO-VARIABLES IN A NEW DATASET

***********************************************************************************************
***********************************************************************************************

* -------------------------------------------------------------
* 	Prepare final datasets
* -------------------------------------------------------------


* 1 - Full dataset with original variables and ILO ones
	
	cd "$outpath"

        compress
		save ${country}_${source}_${time}_FULL,  replace		

* 2 - Dataset with only 'ILO' variables
	
		keep ilo*
		save ${country}_${source}_${time}_ILO, replace
