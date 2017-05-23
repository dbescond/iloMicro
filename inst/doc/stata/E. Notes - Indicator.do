
/*David's instructions:
note_indicator come from  the xlsx file contain on the original ….._ILO.zip file
is on the sheet 1 select(var_name = ‘ilostat_code’ & last 3 character = ‘_NB’)
take value of ilostat_note_code (ie. For UNE_TUNE_NB -> ‘T5:114’)
and is applied to 1 indicator by reading the 8 first and 3 last character
(ie , UNE_TUNE_SEX_AGE_NB -> UNE_TUNE_NB)*/

*****************************************************************************
/*We first open the 3_Framework file in order to map the indicator names with
the way the indicator is coded in the excel file with country's metadata*/
clear
import excel "$FRAMEWORK", sheet("Mapping_template") firstrow
keep indicator sex classif1 classif2
duplicates drop
split indicator, parse(_)

//the following variable will only record the last element of the indicator name, in order to be merged with the metadata notes
gen     final= indicator3 if indicator3!="" & indicator4=="" & indicator5=="" & indicator6==""
replace final= indicator4 if indicator3!="" & indicator4!="" & indicator5=="" & indicator6==""
replace final= indicator5 if indicator3!="" & indicator4!="" & indicator5!="" & indicator6==""
replace final= indicator6 if indicator3!="" & indicator4!="" & indicator5!="" & indicator6!=""

drop if final=="RT" //because the notes are always based on the _NB 

//The following variable is the same as the one in "$METADATA" -> sheet 1 -> column "ilostat_code" for the rows that end in "_NB".
gen indicator_id = indicator1+"_"+indicator2+"_"+final

keep indicator indicator_id
duplicates drop

save "$LIBMPOUT\\FMW Indicator for notes.dta", replace
*****************************************************************************


*****************************************************************************
/*We then merge the above map with the country's metadata*/
clear
import excel "$METADATA", sheet("Sheet 1") firstrow
split ilostat_code, parse(_)

gen note_indicator = ""
local i = 1
while `i' < 5 {
	capture confirm variable ilostat_code`i'
	if !_rc {
		replace note_indicator = ilostat_note_code if ilostat_code`i' == "NB"
	}
	local i = `i' + 1
}

keep note_indicator ilostat_code

drop if note_indicator==""

rename ilostat_code indicator_id

mmerge indicator_id using "$LIBMPOUT\\FMW Indicator for notes.dta"

erase "$LIBMPOUT\\FMW Indicator for notes.dta"

keep if _merge==3
drop _merge indicator_id
duplicates drop

gen  ref_area = "$country"

save "$LIBMPOUT\\${country}_note_indicator.dta", replace
*****************************************************************************
