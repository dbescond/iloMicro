
/*David's instructions:
note_classif come from the xlsx file contain on the original ….._ILO.zip file
is on the sheet 1 select(var_name = ‘ilostat_code’) take value of ilostat_note_code (ie. No example at the moment)
and is applied to 1 indicator which contains sex and/or classif1 and/or classif2
once your indicator is ready, you need a loop on sex/classif1_classif2
that lookup ilostat_code and return ilostat_note_code AND do a concatenation
(ie. If for sex you get C17:2015, for classif1 you get C2:154, result on note_classif is C17:2015_ C2:154 )*/

*****************************************************************************
/*We then merge the above map with the country's metadata*/
clear
import excel "$METADATA", sheet("Sheet 1") firstrow

keep ilostat_code ilostat_note_code
drop if ilostat_note_code==""

gen  ref_area = "$country"
order ref_area ilostat_code ilostat_note_code

save "$LIBMPOUT\\${country}_note_classif.dta", replace
*****************************************************************************
