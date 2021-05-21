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
* Extended Fig 2: Pollution Event study
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
				
		foreach i of varlist aqi pm25 pm10 {
			reghdfe `i' Lead_D5 Lead_D4 Lead_D2 Lead_D1 D0 D1 D2 D3 D4 D5 D6 if ct !=., absorb(i.date i.dsp) vce(cluster dsp)
			parmest , saving($figure/ex2/ex2_s`i'.dta, replace) idstr(s`i')
		}
		*
		
		foreach i of varlist aqi pm25 pm10 {
			reghdfe `i' inter_c_t , absorb(i.date i.dsp) vce(cluster dsp)
			}
			
********************************************************************************
		
	use "$data/main.dta", clear
	
		keep if year == 2020 & month <= 7
		drop if citycode == 4201
		
		replace ct = 0 if ct == . & c == 0
		replace ct = 1 if ct == . & c == 1
		
		xtset dsp date
		bysort dsp: gen ct_sum = sum(ct)

		* create var
		* Previously 7 # Weeks since Lockdown after(0~6), now 23(0~22)
		forvalues i =0/25{
		gen D`i' = 0
		replace D`i' = 1 if ct_sum >=`i'*7+1 & ct_sum<=`i'*7+7
		}
		replace D25 = 1 if ct_sum >= 176

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

		foreach i of varlist aqi pm25 pm10 {
			reghdfe `i' Lead_D5 Lead_D4 Lead_D2 Lead_D1 D0 D1 D2 D3 D4 D5 D6 D7 D8 D9 D10 D11 D12 D13 D14 D15 D16 D17 D18 D19 D20 D21 D22 D23 D24 D25 if ct !=., absorb(i.date i.dsp) vce(cluster dsp)
			parmest , saving($figure/ex2/ex2-m`i'.dta, replace) idstr(m`i')
		}
		*	
		
		foreach i of varlist aqi pm25 pm10 {
			reghdfe `i' inter_c_t inter_medium_treat, absorb(i.date i.dsp) vce(cluster dsp)
			}
		*
		
********************************************************************************

	* Creating Figure
 
		clear
		cd $figure/ex2
		openall, storefilename(fn)
		
		drop if fn == "event_info.dta"
		keep parm idstr estimate stderr dof t p min95 max95 fn
		
		keep if idstr == "spm25" | idstr == "spm10" | idstr == "saqi"
				
		foreach u of var estimate min95 max95{
			replace `u' = 0 if parm == "_cons"
			}
			*

		gen dup = _n
		sort idstr dup
		bys idstr : gen dup2 = _n
		replace dup2 = dup2 - 5
		replace dup2 = dup2 -1 if dup2 < -2
		replace dup2 = -3 if parm == "_cons"

		sort idstr dup2
	
	*all
		preserve
		keep if idstr == "saqi"
		graph twoway (scatter estimate dup2, mcolor(cranberry) mfcolor(white) msize(medsmall)) ///
			(rcap max95 min95 dup2, lcolor(dkorange) lwidth(medthick)) ///
			,scheme(plotplain) ///
			xlab(-5.5 " " -5 "≤ -5" -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "≥6" 6.5 " ", labsize(*0.8) labcolor(black) axis(1) nogrid) ///
			ylabel(-45 -30 -15 0 "    0" 15, labsize(*0.8) nogrid) ///
			yline(0, lp(dash) lc(khaki)) ///
			xline(0, lp(dash) lc(khaki)) ///
			xtitle("# Weeks since Lockdown", size(*0.8)) ///
			ytitle("Estimated Coefficients", size(*0.8)) ///
			xsize(1.5) ysize(1) ///
			text(-42.75 0.5 "short-term effects: -9.67 (2.95)", place(e) size(2.25)) ///
			legend(off)
			
		graph save "$figure/ex2/ex2A", replace 		
		restore
			
	*pm25
		preserve
		keep if idstr == "spm25"
		graph twoway (scatter estimate dup2, mcolor(cranberry) mfcolor(white) msize(medsmall)) ///
			(rcap max95 min95 dup2, lcolor(dkorange) lwidth(medthick)) ///
			,scheme(plotplain) ///
			xlab(-5.5 " " -5 "≤ -5" -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "≥6" 6.5 " ", labsize(*0.8) labcolor(black) axis(1) nogrid) ///
			ylabel(-30 -20 -10 0 "    0" 10, labsize(*0.8) nogrid) ///
			yline(0, lp(dash) lc(khaki)) ///
			xline(0, lp(dash) lc(khaki)) ///
			xtitle("# Weeks since Lockdown", size(*0.8)) ///
			ytitle("Estimated Coefficients", size(*0.8)) ///
			xsize(1.5) ysize(1) ///
			text(-28.5 0.5 "short-term effects: -3.76 (2.01)", place(e) size(2.25)) ///
			legend(off)
			
		graph save "$figure/ex2/ex2B", replace 		
		restore
			
	*pm10
		preserve
		keep if idstr == "spm10"
		graph twoway (scatter estimate dup2, mcolor(cranberry) mfcolor(white) msize(medsmall)) ///
			(rcap max95 min95 dup2, lcolor(dkorange) lwidth(medthick)) ///
			,scheme(plotplain) ///
			xlab(-5.5 " " -5 "≤ -5" -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "≥6" 6.5 " ", labsize(*0.8) labcolor(black) axis(1) nogrid) ///
			ylabel(-60 -40 -20 0 "    0" 20, labsize(*0.8) nogrid) ///
			yline(0, lp(dash) lc(khaki)) ///
			xline(0, lp(dash) lc(khaki)) ///
			xtitle("# Weeks since Lockdown", size(*0.8)) ///
			ytitle("Estimated Coefficients", size(*0.8)) ///
			xsize(1.5) ysize(1) ///
			text(-57 0.5 "short-term effects: -17.9 (4.66)", place(e) size(2.25)) ///
			legend(off)
			
		graph save "$figure/ex2/ex2C", replace 		
		restore

********************************************************************************		
		
	* Creating Figure
 
		clear
		cd $figure/ex2
		openall, storefilename(fn)
		keep if idstr == "mpm25" | idstr == "mpm10" | idstr == "maqi"

		drop if fn == "event_info.dta"
		keep parm estimate stderr dof t p min95 max95 fn
		
		split fn, p("-", ".")
		gen type = fn2
		
		drop fn fn1 fn2 fn3
		drop dof t p stderr
		foreach u of var estimate min95 max95{
			replace `u' = 0 if parm == "_cons"
			}
			*

		gen dup = _n
		sort type dup
		bys type : gen dup2 = _n
		replace dup2 = dup2 - 5
		replace dup2 = dup2 -1 if dup2 < -2
		replace dup2 = -3 if parm == "_cons"

		sort type dup2
		
	*AQI
		preserve
		keep if type == "maqi"
		graph twoway (scatter estimate dup2, mcolor(cranberry) mfcolor(white) msize(*0.6)) ///
			(rcap max95 min95 dup2, lcolor(dkorange)lwidth(med)) ///
			,scheme(plotplain) ///
			xlab(-5.5 " " -5 "≤ -5" 0 4 8 12 16 20 24 25.5 " ", labsize(*0.8) labcolor(black) axis(1) nogrid) ///
			ylabel(-45 -30 -15 0 "    0" 15, labsize(*0.8) nogrid) ///
			yline(0, lp(dash) lc(khaki)) ///
			xline(0, lp(dash) lc(khaki)) ///
			xtitle("# Weeks since Lockdown", size(*0.8)) ///
			ytitle("Estimated Coefficients", size(*0.8)) ///
			text(-38.25 10 "short-term effects: -9.54 (2.91)", place(e) size(2.25)) ///
			text(-42.75 10 "medium-term effects: -6.13 (2.93)", place(e) size(2.25)) ///
			xsize(1.5) ysize(1) ///
			legend(off)
			
		graph save "$figure/ex2/ex2D", replace 		
		restore

	*PM2.5
		preserve
		keep if type == "mpm25"
		graph twoway (scatter estimate dup2, mcolor(cranberry) mfcolor(white) msize(*0.6)) ///
			(rcap max95 min95 dup2, lcolor(dkorange)lwidth(med)) ///
			,scheme(plotplain) ///
			xlab(-5.5 " " -5 "≤ -5" 0 4 8 12 16 20 24 25.5 " ", labsize(*0.8) labcolor(black) axis(1) nogrid) ///
			ylabel(-30 -20 -10 0 "    0" 10, labsize(*0.8) nogrid) ///
			yline(0, lp(dash) lc(khaki)) ///
			xline(0, lp(dash) lc(khaki)) ///
			xtitle("# Weeks since Lockdown", size(*0.8)) ///
			ytitle("Estimated Coefficients", size(*0.8)) ///
			text(-25.5 10 "short-term effects: -3.68 (1.99)", place(e) size(2.25)) ///
			text(-28.5 10 "medium-term effects: -3.82 (2.68)", place(e) size(2.25)) ///
			xsize(1.5) ysize(1) ///
			legend(off)
			
		graph save "$figure/ex2/ex2E", replace 		
		restore
	
	* PM10
		preserve
		keep if type == "mpm10"
		graph twoway (scatter estimate dup2, mcolor(cranberry) mfcolor(white) msize(*0.6)) ///
			(rcap max95 min95 dup2, lcolor(dkorange)lwidth(med)) ///
			,scheme(plotplain) ///
			xlab(-5.5 " " -5 "≤ -5" 0 4 8 12 16 20 24 25.5 " ", labsize(*0.8) labcolor(black) axis(1) nogrid) ///
			ylabel(-60 -40 -20 0 "    0" 20, labsize(*0.8) nogrid) ///
			yline(0, lp(dash) lc(khaki)) ///
			xline(0, lp(dash) lc(khaki)) ///
			xtitle("# Weeks since Lockdown", size(*0.8)) ///
			ytitle("Estimated Coefficients", size(*0.8)) ///
			text(-51 10 "short-term effects: -17.7 (4.57)", place(e) size(2.25)) ///
			text(-57 10 "medium-term effects: -9.82 (3.18)", place(e) size(2.25)) ///
			xsize(1.5) ysize(1) ///
			legend(off)
			
		graph save "$figure/ex2/ex2F", replace 		
		restore

********************************************************************************
		
	foreach i in 1 2 {
	
		if "`i'" == "1" local k = "A. Short-term"
		if "`i'" == "2" local k = "B. Medium-term"
	
	clear all
	gen x = _n/r(N)
	gen y = _n/r(N)
	
	scatter y x, msymbol(none)  /// 
		xlabel(,nogrid) ylabel(,nogrid) yscale(off) xscale(off) /// 
		text(.5 .5 "`k'" ,size(3)) ///
		name(gr4, replace) fxsize(10) fysize(40) graphregion(color(white))
	graph save "$figure/ex2/ex2_period`i'", replace
	}
		
	
********************************************************************************

	foreach i in 1 2 3 4 {
	
		if "`i'" == "1" local k = " "
		if "`i'" == "2" local k = "1. Air Quality Index"
		if "`i'" == "3" local k = "2. PM2.5"
		if "`i'" == "4" local k = "3. PM10"
		
		if "`i'" == "1" local l = "10"
		if "`i'" == "2" local l = "40"
		if "`i'" == "3" local l = "40"
		if "`i'" == "4" local l = "40"
	
	clear all
	gen x = _n/r(N)
	gen y = _n/r(N)
	
	scatter y x, msymbol(none)  /// 
		xlabel(,nogrid) ylabel(,nogrid) yscale(off) xscale(off) /// 
		text(0.1 .5 "`k'" ,size(3)) ///
		name(gr4, replace) fxsize(`l') fysize(0.1) graphregion(color(white))
	graph save "$figure/ex2/ex2_type`i'", replace
	}
		
********************************************************************************

		graph combine "$figure/ex2/ex2_type1" "$figure/ex2/ex2_type2" "$figure/ex2/ex2_type3" "$figure/ex2/ex2_type4" "$figure/ex2/ex2_period1" "$figure/ex2/ex2A" "$figure/ex2/ex2B" "$figure/ex2/ex2C" "$figure/ex2/ex2_period2" "$figure/ex2/ex2D" "$figure/ex2/ex2E" "$figure/ex2/ex2F", col(4) row(3) imargin(4 4 4 4 4 4) xsize(20) ysize(10) graphregion(margin(vtiny) fcolor(white) lcolor(white)) iscale(.7)

		graph save "$figure/ex2/ex2", replace 
		graph export "$figure/allfig_eps/ex2.eps", replace
		graph export "$figure/allfig_png/ex2.png", replace width(3000)	
