*==============================================================================* 
* Project: Lockdown and non-COVID mortality									   *
* Version: Nature Human Behaviour, 1st R&R		    				           *   
* Date:   2021, Feb		                                                       *
* Author: J Qi, D Zhang, X Zhang et al                                         *    
*==============================================================================* 

* set directories 
clear all
set maxvar  30000
set matsize 11000 
set more off
cap log close


global data "$dir/data"
global table "$dir/table"
global figure  "$dir/figure"

********************************************************************************
*
* Table S6: Heterogeneity
*
********************************************************************************

	use $data/hetero.dta, clear
	
	drop if citycode == 4201
	drop if year == 2020 & (month >= 5 | (month == 4 & day >= 8))
				
	foreach i in t_all cvd injury lri clri cancer{ 
		gen mr`i' = `i' / pop_total
		egen mr`i'2019_ = mean(mr`i') if (year == 2019), by(dsp)
		egen mr`i'2019 = max(mr`i'2019_), by(dsp)
		}
	
	foreach i in aqi{ 
		egen `i'2019_ = mean(`i') if (year == 2019), by(dsp)
		egen `i'2019 = max(`i'2019_), by(dsp)
		}
		
		
	foreach i in gdppc bed sec aqi2019 mrt_all2019 mrcvd2019 mrinjury2019 mrlri2019 mrclri2019 mrcancer2019 {
		egen sd_`i' = std(`i')
		gen ct_`i' = ct*sd_`i'
		}
		
	foreach i in t_all cvd injury lri clri cancer {
		rename ct_mr`i'2019 ct_`i'
		}
	
	label variable ct_gdppc "Lockdowns * GDP per capita"
	label variable ct_bed "Lockdowns * # Hospital bed"
	label variable ct_sec "Lockdowns * Share of secondary industry"
	label variable ct_aqi "Lockdowns * Air Quality Index"
	label variable ct_t_all "Lockdowns * Base mortality rate"
	label variable ct_cvd "Lockdowns * Base mortality rate from CVD "
	label variable ct_injury "Lockdowns * Base mortality rate from injury"
	label variable ct_lri "Lockdowns * Base mortality rate from Acute Lower Respiratory Infection"
	label variable ct_clri "Lockdowns * Base mortality rate from Chronic Lower Respiratory Infection"
	label variable ct_cancer "Lockdowns * Base mortality rate from Pneumonia"
		
	cap erase $table/tableS6/tableS6.xls
	cap erase $table/tableS6/tableS6.txt
	
	
	foreach i in t_all cvd injury lri clri cancer {
		reghdfe `i' ct ct_gdppc ct_bed ct_sec ct_aqi ct_`i' if year == 2020, absorb(i.dsp i.date) vce(cluster dsp)
		outreg2 using $table/tableS6/tableS6.xls, append se bracket dec(3) ///
keep(ct ct_gdppc ct_bed ct_sec ct_aqi ct_`i') ///
addnote("Notes: Each cell in the table represents a separate DiD regression. We interact the treatment dummy with baseline socio-economic variables to understand the heterogeneity impacts of lockdowns. The socio-economic variables are standardised to have mean 0 and standard deviation 1. The standard errors clustered at the DSP level are reported below the estimates. * significant at 10% ** significant at 5% *** significant at 1%.") ///
addtext(DSP Fixed Effect, "YES", Date Fixed Effect, "YES") ///
addstat(Obs., e(N), Adjusted R-Square, e(r2_a),  # of DSP Counties, 602) ///
nocon nor2 noobs label ///
title("Table SM6. The heterogeneous impacts of city/community lockdowns on `i' deaths") ///
ctitle(" ")
		}
		
