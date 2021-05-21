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
* Extended Fig 5: Medium-term event study
*
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

		foreach i of varlist t_all cvd injury lri clri cancer {
			reghdfe `i' Lead_D5 Lead_D4 Lead_D2 Lead_D1 D0 D1 D2 D3 D4 D5 D6 D7 D8 D9 D10 D11 D12 D13 D14 D15 D16 D17 D18 D19 D20 D21 D22 D23 D24 D25 if ct !=., absorb(i.date i.dsp) vce(cluster dsp)
			parmest , saving($figure/ex5/ex5-`i'.dta, replace) idstr(`i')
		}
		*		
		
********************************************************************************

	* Creating Figure
 
		clear
		cd $figure/ex5
		openall, storefilename(fn)

		drop if fn == "event_info.dta"
		keep parm estimate stderr dof t p min95 max95 fn
		
		split fn, p("-", ".")

		gen type = "all" if fn2 == "t_all"
		replace type = "cvd" if fn2 == "cvd"
		replace type = "injury" if fn2 == "injury"
		replace type = "lri" if fn2 == "lri"
		replace type = "clri" if fn2 == "clri"
		replace type = "cancer" if fn2 == "cancer"

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
		graph twoway (scatter estimate dup2, mcolor(cranberry) mfcolor(white) msize(*0.6)) ///
			(rcap max95 min95 dup2, lcolor(dkorange)lwidth(med)) ///
			,scheme(plotplain) ///
			xlab(-5.5 " " -5 "≤ -5" 0 4 8 12 16 20 24 25.5 " ", labsize(*0.8) labcolor(black) axis(1) nogrid) ///
			ylabel(-3 -1.5 0 "     0" 1.5 3, labsize(*0.8) nogrid) ///
			yline(0, lp(dash) lc(khaki)) ///
			xline(0, lp(dash) lc(khaki)) ///
			title("A. Total", pos(11) size(med)) ///
			xtitle("# Weeks since Lockdown", size(*0.8)) ///
			ytitle("Estimated Coefficients", size(*0.8)) ///
			xsize(1.5) ysize(1) ///
			legend(off)
			
		graph save "$figure/ex5/ex5A", replace 		
		restore

	*cvd
		preserve
		keep if type == "cvd"
		graph twoway (scatter estimate dup2, mcolor(cranberry) mfcolor(white) msize(*0.6)) ///
			(rcap max95 min95 dup2, lcolor(dkorange)lwidth(med)) ///
			,scheme(plotplain) ///
			xlab(-5.5 " " -5 "≤ -5" 0 4 8 12 16 20 24 25.5 " ", labsize(*0.8) labcolor(black) axis(1) nogrid) ///
			ylabel(-2 -1 0 "     0" 1 2, labsize(*0.8) nogrid) ///
			yline(0, lp(dash) lc(khaki)) ///
			xline(0, lp(dash) lc(khaki)) ///
			title("B. CVD", pos(11) size(med)) ///
			xtitle("# Weeks since Lockdown", size(*0.8)) ///
			ytitle("Estimated Coefficients", size(*0.8)) ///
			xsize(1.5) ysize(1) ///
			legend(off)
		graph save "$figure/ex5/ex5B", replace 		
		restore
	
	*injury
		preserve
		keep if type == "injury"
		graph twoway (scatter estimate dup2, mcolor(cranberry) mfcolor(white) msize(*0.6)) ///
			(rcap max95 min95 dup2, lcolor(dkorange)lwidth(med)) ///
			,scheme(plotplain) ///
			xlab(-5.5 " " -5 "≤ -5" 0 4 8 12 16 20 24 25.5 " ", labsize(*0.8) labcolor(black) axis(1) nogrid) ///
			ylabel(-.3 -.15 0 "     0" .15 .3, labsize(*0.8) nogrid) ///
			yline(0, lp(dash) lc(khaki)) ///
			xline(0, lp(dash) lc(khaki)) ///
			title("C. Injury", pos(11) size(med)) ///
			xtitle("# Weeks since Lockdown", size(*0.8)) ///
			ytitle("Estimated Coefficients", size(*0.8)) ///
			xsize(1.5) ysize(1) ///
			legend(off)
		graph save "$figure/ex5/ex5C", replace 		
		restore

	*lri
		preserve
		keep if type == "lri"
		graph twoway (scatter estimate dup2, mcolor(cranberry) mfcolor(white) msize(*0.6)) ///
			(rcap max95 min95 dup2, lcolor(dkorange)lwidth(med)) ///
			,scheme(plotplain) ///
			xlab(-5.5 " " -5 "≤ -5" 0 4 8 12 16 20 24 25.5 " ", labsize(*0.8) labcolor(black) axis(1) nogrid) ///
			ylabel(-.16 -.08 0 "     0" .08 .16, labsize(*0.8) nogrid) ///
			yline(0, lp(dash) lc(khaki)) ///
			xline(0, lp(dash) lc(khaki)) ///
			title("D. Acute Lower Respiratory Infection", pos(11) size(med)) ///
			xtitle("# Weeks since Lockdown", size(*0.8)) ///
			ytitle("Estimated Coefficients", size(*0.8)) ///
			xsize(1.5) ysize(1) ///
			legend(off)
		graph save "$figure/ex5/ex5D", replace 		
		restore
	
	*clri
		preserve
		keep if type == "clri"
		graph twoway (scatter estimate dup2, mcolor(cranberry) mfcolor(white) msize(*0.6)) ///
			(rcap max95 min95 dup2, lcolor(dkorange)lwidth(med)) ///
			,scheme(plotplain) ///
			xlab(-5.5 " " -5 "≤ -5" 0 4 8 12 16 20 24 25.5 " ", labsize(*0.8) labcolor(black) axis(1) nogrid) ///
			ylabel(-.6 -.3 0 "     0" .3 .6, labsize(*0.8) nogrid) ///
			yline(0, lp(dash) lc(khaki)) ///
			xline(0, lp(dash) lc(khaki)) ///
			title("E. Chronic Lower Respiratory Infection", pos(11) size(med)) ///
			xtitle("# Weeks since Lockdown", size(*0.8)) ///
			ytitle("Estimated Coefficients", size(*0.8)) ///
			xsize(1.5) ysize(1) ///
			legend(off)
		graph save "$figure/ex5/ex5E", replace 		
		restore
		
		
	* Cancer
		preserve
		keep if type == "cancer"
		graph twoway (scatter estimate dup2, mcolor(cranberry) mfcolor(white) msize(*0.6)) ///
			(rcap max95 min95 dup2, lcolor(dkorange)lwidth(med)) ///
			,scheme(plotplain) ///
			xlab(-5.5 " " -5 "≤ -5" 0 4 8 12 16 20 24 25.5 " ", labsize(*0.8) labcolor(black) axis(1) nogrid) ///
			ylabel(-.8 -.4 0 "     0" .4 .8, labsize(*0.8) nogrid) ///
			yline(0, lp(dash) lc(khaki)) ///
			xline(0, lp(dash) lc(khaki)) ///
			title("F. Neoplasms", pos(11) size(med)) ///
			xtitle("# Weeks since Lockdown", size(*0.8)) ///
			ytitle("Estimated Coefficients", size(*0.8)) ///
			xsize(1.5) ysize(1) ///
			legend(off)
		graph save "$figure/ex5/ex5F", replace 		
		restore

********************************************************************************

		graph combine "$figure/ex5/ex5A" "$figure/ex5/ex5B" "$figure/ex5/ex5C" "$figure/ex5/ex5D" "$figure/ex5/ex5E" "$figure/ex5/ex5F", col(3) row(2) imargin(4 4 4 4 4 4) xsize(20) ysize(10) graphregion(margin(vtiny) fcolor(white) lcolor(white)) iscale(.7)

		graph save "$figure/ex5/ex5", replace 
		graph export "$figure/allfig_eps/ex5.eps", replace
		graph export "$figure/allfig_png/ex5.png", replace width(3000)	
