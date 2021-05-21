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
* Table S4: Timing of lockdowns
*
********************************************************************************

	use "$data/hetero.dta", clear
	
		foreach i in t_all cvd injury lri clri cancer other_all{ 
			gen mr`i' = `i' / pop_total * 100000
			egen mr`i'2019_ = mean(mr`i') if (year == 2019), by(dsp)
			egen mr`i'2019 = max(mr`i'2019_), by(dsp)
		}
		
		replace gdppc = gdppc/1000000
		
		foreach i in aqi {
			egen `i'2019_ = mean(`i') if (year == 2019), by(dsp)
			egen `i'2019 = max(`i'2019_), by(dsp)
			}
	
		gen case_ = confirmed if date ==  21946
		egen case = max(case), by(dsp)
		
		drop if citycode == 4201
		duplicates drop dsp, force
		
		tsset dsp date
		
		cap erase $table/tableS4/tableS4.xls
		cap erase $table/tableS4/tableS4.txt
		
		gen lcase = ln(case+1)
		
		reg c lcase mrt_all2019 mrcvd2019 mrinjury2019 mrlri2019 mrclri2019 mrcancer2019 mrother_all2019 i.provcode, robust
		outreg2 using $table/tableS4/tableS4.xls, append se bracket dec(2) addnote("Notes: All DSP counties are included in the analysis except the three in Wuhan. The outcome variable is a dummy indicating whether a DSP's city enforced a lockdown policy. The lcase denotes logarithms of the number of confirmed COVID-19 cases on February 1st. Since COVID-19 data are available only after January 23rd, therefore we use data on February 1, where less than 10% cities enforced lockdowns. All regression includes province dummies. * significant at 10% ** significant at 5% *** significant at 1%. Robustness standard error is used.") drop(i.provcode) addstat(Obs., e(N), Adjusted R-Square, e(r2),  # of DSP Counties, e(N)) nocon nor2 noobs label title("Examine endogeneity problem with policy enforcement")

		reg c lcase mrt_all2019 mrcvd2019 mrinjury2019 mrlri2019 mrclri2019 mrcancer2019 mrother_all2019 gdppc bed sec aqi2019 i.provcode, robust
		outreg2 using $table/tableS4/tableS4.xls, append se bracket dec(2) drop(i.provcode) addstat(Obs., e(N), Adjusted R-Square, e(r2),  # of DSP Counties, e(N)) nocon nor2 noobs label title("Examine endogeneity problem with policy enforcement")
				
