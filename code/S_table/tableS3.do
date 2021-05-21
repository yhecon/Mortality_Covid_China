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
* Table S3: Event Study
*
********************************************************************************

	use "$data/main.dta", clear
		
		keep if year == 2020
		keep if month == 1 | month == 2 | month == 3 | (month == 4 & day <= 7)
		drop if citycode == 4201
	
		replace ct = 0 if ct == . & c == 0
		replace ct = 1 if ct == . & c == 1
		
		xtset dsp date
		bysort dsp: gen ct_sum = sum(ct)

		* create var
		forvalues i =0/6{
		gen D`i' = 0
		replace D`i' = 1 if ct_sum >=`i'*7+1 & ct_sum<=`i'*7+7
		}
		replace D6 = 1 if ct_sum >=43

		*
		forvalues i =1/6{
		local m = `i'*7
		gen Lead_D`i' = F`m'.D0
		replace Lead_D`i' = 0 if Lead_D`i'==.
		}
		*
		bys dsp : egen ct_if = total(ct)

		gen Lead_D7 = ct - Lead_D1 - Lead_D2 - Lead_D3 - Lead_D4 - Lead_D5 - Lead_D6
		replace Lead_D7 = . if Lead_D7 != 0
		replace Lead_D7 = 1 if Lead_D7 == 0
		replace Lead_D7 = 0 if Lead_D7 == .
		replace Lead_D7 = 0 if ct_if == 0
		
		replace Lead_D5 = Lead_D6 if Lead_D5 == 0
		replace Lead_D5 = Lead_D7 if Lead_D5 == 0
				
		cap erase $table/tableS3/tableS3.xls
		cap erase $table/tableS3/tableS3.txt
		
		foreach i of varlist t_all cvd injury lri clri cancer {
			qui reghdfe `i' Lead_D5 Lead_D4 Lead_D2 Lead_D1 D0 D1 D2 D3 D4 D5 D6 if ct !=., absorb(i.date i.dsp) vce(cluster dsp)
			outreg2 using $table/tableS3/tableS3.xls, dec(3) append bracket nocon nor2 noobs label addstat(Obs., e(N), Adjusted R-Square, e(r2_a),  # of DSP Counties, 602) addtext(DSP Fixed Effect, "YES", Date Fixed Effect, "YES") addnote("Notes: We include leads and lags of the start of the lockdown dummy in the regressions. The dummy variable indicating three week before the lockdown is omitted from the regressions. The standard errors clustered at the DSP level are reported below the estimates. * significant at 10% ** significant at 5% *** significant at 1%.") title("Table SM3. Event study estimation results")
			
		}
		*		
		