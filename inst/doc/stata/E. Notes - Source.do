
clear
import excel "$METADATA", sheet("Sheet 1") firstrow

***Create columns for notes
/*David's instructions:
note_source come from  the xlsx file contain on the original ….._ILO.zip file
is on the sheet 1 select(var_name = ‘ilo_source’) take value of ilostat_note_code (ie. ‘S3:5_T2:84_T3:89’)
and is applied to all the indicators*/
gen note_source = ilostat_note_code if var_name=="ilo_source"
keep note_source
drop if note_source==""
gen  ref_area = "$country"
save "$LIBMPOUT\\${country}_note_source.dta", replace
