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
* Fig 3: Event Study
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
				
		foreach i of varlist t_all cvd injury lri clri cancer {
			reghdfe `i' Lead_D5 Lead_D4 Lead_D2 Lead_D1 D0 D1 D2 D3 D4 D5 D6 if ct !=., absorb(i.date i.dsp) vce(cluster dsp)
			parmest , saving($figure/fig3/fig3_`i'.dta, replace) idstr(`i')
		}
		*	
				
********************************************************************************

	* Creating Figure
 
		clear
		cd $figure/fig3
		openall, storefilename(fn)

		drop if fn == "event_info.dta"
		keep parm estimate stderr dof t p min95 max95 fn
		
		split fn, p("_")

		gen type = "all" if fn2 == "t"
		replace type = "cvd" if fn2 == "cvd.dta"
		replace type = "injury" if fn2 == "injury.dta"
		replace type = "lri" if fn2 == "lri.dta"
		replace type = "clri" if fn2 == "clri.dta"
		replace type = "cancer" if fn2 == "cancer.dta"

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

	
	*all
		preserve
		keep if type == "all"
		graph twoway (scatter estimate dup2, mcolor(cranberry) mfcolor(white) msize(medsmall)) ///
			(rcap max95 min95 dup2, lcolor(dkorange) lwidth(medthick)) ///
			,scheme(plotplain) ///
			xlab(-5.5 " " -5 "≤ -5" -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "≥6" 6.5 " ", labsize(*0.8) labcolor(black) axis(1) nogrid) ///
			ylabel(-3 -1.5 0 "     0" 1.5 3, labsize(*0.8) nogrid) ///
			yline(0, lp(dash) lc(khaki)) ///
			xline(0, lp(dash) lc(khaki)) ///
			title("A. Total", pos(11) size(med)) ///
			xtitle("# Weeks since Lockdown", size(*0.8)) ///
			ytitle("Estimated Coefficients", size(*0.8)) ///
			xsize(1.5) ysize(1) ///
			legend(off)
			
		graph save "$figure/fig3/fig3A", replace 		
		restore

	*cvd
		preserve
		keep if type == "cvd"
		graph twoway (scatter estimate dup2, mcolor(cranberry) mfcolor(white) msize(medsmall)) ///
			(rcap max95 min95 dup2, lcolor(dkorange) lwidth(medthick)) ///
			,scheme(plotplain) ///
			xlab(-5.5 " " -5 "≤ -5" -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "≥6" 6.5 " ", labsize(*0.8) labcolor(black) axis(1) nogrid) ///
			ylabel(-2 -1 0 "     0" 1 2, labsize(*0.8) nogrid) ///
			yline(0, lp(dash) lc(khaki)) ///
			xline(0, lp(dash) lc(khaki)) ///
			title("B. CVD", pos(11) size(med)) ///
			xtitle("# Weeks since Lockdown", size(*0.8)) ///
			ytitle("Estimated Coefficients", size(*0.8)) ///
			xsize(1.5) ysize(1) ///
			legend(off)
			
		graph save "$figure/fig3/fig3B", replace 		
		restore
			
	*injury
		preserve
		keep if type == "injury"
		graph twoway (scatter estimate dup2, mcolor(cranberry) mfcolor(white) msize(medsmall)) ///
			(rcap max95 min95 dup2, lcolor(dkorange) lwidth(medthick)) ///
			,scheme(plotplain) ///
			xlab(-5.5 " " -5 "≤ -5" -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "≥6" 6.5 " ", labsize(*0.8) labcolor(black) axis(1) nogrid) ///
			ylabel(-.2 -.1 0 "     0" .1 .2, labsize(*0.8) nogrid) ///
			yline(0, lp(dash) lc(khaki)) ///
			xline(0, lp(dash) lc(khaki)) ///
			title("C. Injury", pos(11) size(med)) ///
			xtitle("# Weeks since Lockdown", size(*0.8)) ///
			ytitle("Estimated Coefficients", size(*0.8)) ///
			xsize(1.5) ysize(1) ///
			legend(off)
		graph save "$figure/fig3/fig3C", replace 		
		restore

	*lri
		preserve
		keep if type == "lri"
		graph twoway (scatter estimate dup2, mcolor(cranberry) mfcolor(white) msize(medsmall)) ///
			(rcap max95 min95 dup2, lcolor(dkorange) lwidth(medthick)) ///
			,scheme(plotplain) ///
			xlab(-5.5 " " -5 "≤ -5" -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "≥6" 6.5 " ", labsize(*0.8) labcolor(black) axis(1) nogrid) ///
			ylabel(-.16 -.08 0 "     0" .08 .16, labsize(*0.8) nogrid) ///
			yline(0, lp(dash) lc(khaki)) ///
			xline(0, lp(dash) lc(khaki)) ///
			title("D. Acute Lower Respiratory Infection", pos(11) size(med)) ///
			xtitle("# Weeks since Lockdown", size(*0.8)) ///
			ytitle("Estimated Coefficients", size(*0.8)) ///
			xsize(1.5) ysize(1) ///
			legend(off)
		graph save "$figure/fig3/fig3D", replace 		
		restore		

	*clri
		preserve
		keep if type == "clri"
		graph twoway (scatter estimate dup2, mcolor(cranberry) mfcolor(white) msize(medsmall)) ///
			(rcap max95 min95 dup2, lcolor(dkorange) lwidth(medthick)) ///
			,scheme(plotplain) ///
			xlab(-5.5 " " -5 "≤ -5" -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "≥6" 6.5 " ", labsize(*0.8) labcolor(black) axis(1) nogrid) ///
			ylabel(-.4 -.2 0 "     0" .2 .4, labsize(*0.8) nogrid) ///
			yline(0, lp(dash) lc(khaki)) ///
			xline(0, lp(dash) lc(khaki)) ///
			title("E. Chronic Lower Respiratory Infection", pos(11) size(med)) ///
			xtitle("# Weeks since Lockdown", size(*0.8)) ///
			ytitle("Estimated Coefficients", size(*0.8)) ///
			xsize(1.5) ysize(1) ///
			legend(off)
		graph save "$figure/fig3/fig3E", replace 		
		restore
		
	*cancer
		preserve
		keep if type == "cancer"
		graph twoway (scatter estimate dup2, mcolor(cranberry) mfcolor(white) msize(medsmall)) ///
			(rcap max95 min95 dup2, lcolor(dkorange) lwidth(medthick)) ///
			,scheme(plotplain) ///
			xlab(-5.5 " " -5 "≤ -5" -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "≥6" 6.5 " ", labsize(*0.8) labcolor(black) axis(1) nogrid) ///
			ylabel(-.4 -.2 0 "     0" .2 .4, labsize(*0.8) nogrid) ///
			yline(0, lp(dash) lc(khaki)) ///
			xline(0, lp(dash) lc(khaki)) ///
			title("F. Neoplasms", pos(11) size(med)) ///
			xtitle("# Weeks since Lockdown", size(*0.8)) ///
			ytitle("Estimated Coefficients", size(*0.8)) ///
			xsize(1.5) ysize(1) ///
			legend(off)
		graph save "$figure/fig3/fig3F", replace 		
		restore

********************************************************************************

		graph combine "$figure/fig3/fig3A" "$figure/fig3/fig3B" "$figure/fig3/fig3C" "$figure/fig3/fig3D" "$figure/fig3/fig3E" "$figure/fig3/fig3F", col(3) row(2) imargin(4 4 4 4 4 4) xsize(20) ysize(10) graphregion(margin(vtiny) fcolor(white) lcolor(white)) iscale(.7)

		graph save "$figure/fig3/fig3", replace 
		graph export "$figure/allfig_eps/fig3.eps", replace
		graph export "$figure/allfig_png/fig3.png", replace width(3000)

		