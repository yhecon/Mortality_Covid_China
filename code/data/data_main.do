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
* Data Create: main data
*
********************************************************************************

	use $data/raw_data/y_x_daily.dta, clear

		rename countycode dsp
		xtset dsp date

		replace other_all = other_all + mental + ckd + diabetes + inf_dis
		gen inter_c_t= ct
		
		label variable inter_c_t "Lockdown policy"
		label variable t_all "Total # of Deaths"
		label variable cvd "CVD"
		label variable injury "Injury"
		label variable lri "Acute Lower Respiratory Infection"
		label variable clri "Chronic Lower Respiratory Infection"
		label variable cancer "Neoplasms"
		label variable other_all "Other Causes"
		
	* create detail death record for CVD and injury
		
		gen other_cvd = cvd - mi - stroke_h - stroke_i
		gen stroke = stroke_i + stroke_h		
		
	* create medium-term variables
	
		gen mediumterm = 1 if citycode != 4201 & date >= 22013
		replace mediumterm = 0 if mediumterm == .
		gen inter_medium_treat = mediumterm * c
		replace inter_c_t = 0 if date >= 22013
		
	* create different types of lockdowns
		
		gen group1t = 1 if lockdown_t == 1 & c12t != 1 & c12 == 1
		replace group1t = 0 if group1t == .
		gen group2t = 1 if c12t == 1
		replace group2t = 0 if group2t == .
		
	* rename 
	
		rename hospital_bed bed
		rename secondary_ratio sec

	save $data/main.dta, replace
