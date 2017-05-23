
*This do-file generates the column classif1 for ilo_preveco_aggregate [Previous economic activity (Aggregate)]
*It is separate because it will be used often.

/*
ilostat_code		code_level	code_label
ECO_AGGREGATE_AGR	1			1 - Agriculture
ECO_AGGREGATE_MAN	2			2 - Manufacturing
ECO_AGGREGATE_CON	3			3 - Construction
ECO_AGGREGATE_MEL	4			4 - Mining and quarrying; Electricity, gas and water supply
ECO_AGGREGATE_MKT	5			5 - Market Services (Trade; Transportation; Accommodation and food; and Business and administrative services)
ECO_AGGREGATE_PUB	6			6 - Non-market services (Public administration; Community, social and other services and activities)
ECO_AGGREGATE_X		7			7 - Not classifiable by economic activity
*/
gen     classif1 = ""
replace classif1 = "ECO_AGGREGATE_AGR"   if ilo_preveco_aggregate==1
replace classif1 = "ECO_AGGREGATE_MAN"   if ilo_preveco_aggregate==2
replace classif1 = "ECO_AGGREGATE_CON"   if ilo_preveco_aggregate==3
replace classif1 = "ECO_AGGREGATE_MEL"   if ilo_preveco_aggregate==4
replace classif1 = "ECO_AGGREGATE_MKT"   if ilo_preveco_aggregate==5
replace classif1 = "ECO_AGGREGATE_PUB"   if ilo_preveco_aggregate==6
replace classif1 = "ECO_AGGREGATE_X"     if ilo_preveco_aggregate==7
