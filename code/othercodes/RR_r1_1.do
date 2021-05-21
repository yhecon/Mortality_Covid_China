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

local TNK 0
local YHN 1

if `TNK'==1{
	global dir= "C:\Users\takan\Dropbox\Covid_Mortality\Replication\Nat_HB_RR1"
}

if `YHN'==1{
	global dir= "/Users/smileternity/Dropbox/Covid_Mortality/Replication/Nat_HB_RR1"
}

global data "$dir/data"
global table "$dir/table"
global figure  "$dir/figure"
global RR  "$dir/code/othercodes"


********************************************************************************
*
* Referee 1 : drop samples before Jan24
*
********************************************************************************

	use "$data/main.dta", clear

		keep if year == 2020
		keep if month == 1 | month == 2 | month == 3 | (month == 4 & day <= 7)
		drop if citycode == 4201
		
		drop if (month == 1 & day < 24)

		sum t_all
		local t_all_mean = string(r(mean), "%6.3f")
		reghdfe t_all inter_c_t if year == 2020, absorb(i.dsp i.date) vce(cluster dsp)
		outreg2 using "$RR/R1_1.xls", replace se bracket dec(3) keep(inter_c_t) addnote("Notes: Each cell in the table represents a separate DiD regression for the samples from Jan 25 to Apr 7 in 2020. All DSP districts/counties are included in the analysis except 3 from Wuhan. The outcome variable is the daily number of non-COVID-19 deaths from the DSP districts/counties. We use mortality data from January 1 to April 7, 2020 for this analysis, 2020. The explanatory variable is a dummy indicating whether a city associated with a DSP had a lockdown policy on a particular date. The standard errors clustered at the DSP level are reported below the estimates. * significant at 10% ** significant at 5% *** significant at 1%.") addtext(DSP Fixed Effect, "YES", Date Fixed Effect, "YES") addstat(Obs., e(N), Adjusted R-Square, e(r2_a),  # of DSP Counties, 602) nocon nor2 noobs label cttop("Mean = `t_all_mean'") title("Table 1. The Impacts of City Lockdown on Deaths from Different Causes")

		foreach i of varlist cvd injury lri clri cancer other_all{
			sum `i'
			local `i'_mean = string(r(mean), "%6.3f")
			reghdfe `i' inter_c_t if year == 2020, absorb(i.dsp i.date) vce(cluster dsp)
			outreg2 using "$RR/R1_1.xls", append excel se bracket dec(3)  keep(inter_c_t) addtext(DSP Fixed Effect, "YES", Date Fixed Effect, "YES") addstat(Obs., e(N), Adjusted R-Square, e(r2_a),  # of DSP Counties, 602) nocon nor2 noobs label cttop("Mean = ``i'_mean'")
		}
