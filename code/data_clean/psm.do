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
* Propensity score matching, weighting create
*
********************************************************************************

	use "$data/main.dta", clear
	
	foreach i in t_all cvd injury lri clri cancer other_all{ 
			gen mr`i' = `i' / pop_total
			egen mr`i'2019_ = mean(mr`i') if (year == 2019), by(dsp)
			egen mr`i'2019 = max(mr`i'2019_), by(dsp)
		}
		
		foreach i in aqi mig {
			egen `i'2019_ = mean(`i') if (year == 2019), by(dsp)
			egen `i'2019 = max(`i'2019_), by(dsp)
			}
			
		egen max = max(ct) , by(dsp)
				
		gen case_ = confirmed if date ==  21946
		egen case = max(case), by(dsp)
		gen lcase = ln(case+1)
		
		egen maxcase = max(confirmed), by(dsp)
		gen arrive = 0
		replace arrive = 1 if maxcase >= 1
			
		drop if citycode == 4201
		duplicates drop dsp, force
		
		tsset dsp date
		
		save $data/psm/PSM2, replace
		
********************************************************************************

		use $data/psm/PSM2, clear		
		global matching gdppc sec bed aqi2019 lcase mrcvd2019 mrinjury2019 mrlri2019 mrclri2019 mrcancer2019 mrother_all2019 

		rename max treat

		teffects nnmatch ($matching) (treat), generate(nnm)
		keep dsp $matching treat nnm*

		gen obs_number = _n
		order obs_number 

		save $data/psm/nnm_fulldata, replace // save the complete data set
		keep if treat == 1 // keep just the treated group
		keep nnm1 // keep just the match1 variable (the observation numbers of their matches)
		bysort nnm1: gen weight=_N // count how many times each control observation is a match
		bysort nnm1: keep if _n == 1 // keep just one row per control observation
		rename nnm1 obs_number //rename for merging purposes

		merge 1:m obs_number using $data/psm/nnm_fulldata.dta // merge back into the full data
		replace weight=1 if treat == 1 // set weight to 1 for treated observations

		keep if _merge == 3 | treat == 1

		keep dsp weight treat 
		save $data/psm/nnm_indicator, replace // save the nearest neighbor matching indicator (tell us which gb_code_2010 should be kept and weights)
