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

local TNK 1
local YHN 0

if `TNK'==1{
	global dir= "C:\Users\takan\Dropbox\Covid_Mortality\Replication\Nat_HB_RR1"
}

if `YHN'==1{
	global dir= "C:\Users\ypanam\Dropbox\Research\Covid_Mortality\Replication\Nat_HB_RR1\"
}

global data "$dir/data"
global table "$dir/table"
global figure  "$dir/figure"

********************************************************************************
*
* Table S5: Medium-term effects
*
********************************************************************************
	
	use "$data/main.dta", clear

		keep if year == 2020 & month <= 7
		drop if citycode == 4201

		xtset dsp date

		label variable inter_c_t "Lockdown policy (Short Term)"
		label variable inter_medium_treat "Lockdown policy (medium Term)"
				
		cap erase $table/tableS5/tableS5.xls
		cap erase $table/tableS5/tableS5.txt
		
		sum t_all
		local t_all_mean = string(r(mean), "%6.3f")
		reghdfe t_all inter_c_t inter_medium_treat, absorb(i.dsp i.date) vce(cluster dsp)
		outreg2 using $table/tableS5/tableS5.xls, append se bracket dec(3) keep(inter_c_t inter_medium_treat) addnote("Notes: Each cell in the table represents a separate DiD regression. All DSP districts/counties are included in the analysis except 3 from Wuhan. The outcome variable is the daily number of non-COVID-19 deaths from the DSP districts/counties. We use mortality data from January 1 and July 31, 2020 for this analysis, 2020. The explanatory variable for short term lockdown policy is a dummy indicating that, among January 24 to April 7, whether a city where DSP bemediums to enforced a lockdown policy on a particular date. The medium term explanatory variable is an interaction consists of a dummy indicating whether the DSP has ever locked down, and a time dummy stands for the period after April 8. The standard errors clustered at the DSP level are reported below the estimates. * significant at 10% ** significant at 5% *** significant at 1%.") addtext(DSP Fixed Effect, "YES", Date Fixed Effect, "YES") addstat(Obs., e(N), Adjusted R-Square, e(r2_a),  # of DSP Counties, 602) nocon nor2 noobs label cttop("Mean = `t_all_mean'") title("Table . The short- and medium-term impacts of lockdown on deaths from different causes")

		foreach i of varlist cvd injury lri clri cancer other_all{
			sum `i'
			local `i'_mean = string(r(mean), "%6.3f")
			reghdfe `i' inter_c_t inter_medium_treat, absorb(i.dsp i.date) vce(cluster dsp)
			outreg2 using $table/tableS5/tableS5.xls, append excel se bracket dec(3)  keep(inter_c_t inter_medium_treat) addtext(DSP Fixed Effect, "YES", Date Fixed Effect, "YES") addstat(Obs., e(N), Adjusted R-Square, e(r2_a),  # of DSP Counties, e(N_clust)) nocon nor2 noobs label cttop("Mean = ``i'_mean'")
		}