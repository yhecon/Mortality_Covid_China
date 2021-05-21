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
* Data Create, complete data (with air pollution, data in 2019)
*
********************************************************************************

	use $data/raw_data/y_x_daily_2019complete.dta, clear
		
		rename countycode dsp
		gen inter_c_t= ct
		
		rename hospital_bed bed
		rename secondary_ratio sec
				
		foreach i in aqi bed gdppc sec {
			bysort date provcode: egen `i'_provmean = mean(`i')
			replace `i' = `i'_provmean if `i' == .
			}	
			
	* mediumterm 
			
		gen mediumterm = 1 if citycode != 4201 & date >= 22013
		replace mediumterm = 0 if mediumterm == .
		gen inter_medium_treat = mediumterm * c
		replace inter_c_t = 0 if date >= 22013
			
	save $data/hetero.dta, replace
