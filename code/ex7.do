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
* Extended Fig 7: By age group
*
********************************************************************************
	
	use $data/age.dta, clear
	
	keep if year == 2020
	drop if citycode == 4201
	drop if year == 2020 & (month > 4 | (month == 4 & day >= 8))	

	foreach i of varlist t_all cvd injury lri clri cancer{
	foreach a in 1 2 3 {
	
		reghdfe `i'_agegroup`a' inter_c_t`a' if year == 2020, absorb(i.dsp i.date) vce(cluster dsp)
		parmest , saving($figure/ex7/ex7_`i'`a'.dta, replace) idstr(`i'-`a')
	}
	}
	
	local sum = "t_all* cvd* injury* lri* clri* cancer*"
	format `sum' %9.3f
	sum `sum', format
	
********************************************************************************

	cd $figure/ex7
	openall
	
	drop if parm == "_cons"
	split idstr, p("-")
	keep if idstr1 == "t_all"
	
	rename idstr2 age
	destring age, replace
	sort age
	
	gen x = _n
		
		graph twoway (rspike min95 max95 x if x == 1, msymbol(circle) lcolor(dkorange) lwidth(med)) ///
				(scatter estimate x if x == 1, msymbol(circle) mcolor(dkorange*.8) mlcolor(dkorange*1.2) mlwidth(thin) ) ///
				(rspike min95 max95 x if x == 2, msymbol(circle) lcolor(blue*1.2) lwidth(med)) ///
				(scatter estimate x if x == 2, msymbol(circle) mcolor(blue*1) mlcolor(blue*1.2) mlwidth(thin) ) ///
				(rspike min95 max95 x if x == 3, msymbol(circle) lcolor(red*1.2) lwidth(med)) ///
				(scatter estimate x if x == 3, msymbol(circle) mcolor(red*1) mlcolor(red*1.2) mlwidth(thin) ) ///
				, scheme(plotplain) ///
				title("A. Total", pos(11) size(4)) ///
				xlabel(0.5 " " 1 "Age 0-14" 2 "Age 15-64" 3 "Age 65+" 3.5 " ", nogrid) ///
				ylabel(-1.2 -0.6 0 "     0" .6, nogrid) ///
				xtitle("") ///
				ytitle("Estimated coefficients", size(3)) ///
				yline(0, lp(shortdash) lcolor(gs8) lwidth(vthin)) ///
				legend(order(1 3 5) label(1 "Age 0-14 (Mean 0.07)") label(3 "Age 15-64 (Mean 2.15)") label(5 "Age 65+ (Mean 7.40)") ring(0) pos(8) rowgap(0.4) colgap(0.4))
		
		graph save $figure/ex7/ex7A, replace	

********************************************************************************

	cd $figure/ex7
	openall
	
	drop if parm == "_cons"
	split idstr, p("-")
	keep if idstr1 == "cvd"
	
	rename idstr2 age
	destring age, replace
	sort age
	
	gen x = _n
		
		graph twoway (rspike min95 max95 x if x == 1, msymbol(circle) lcolor(dkorange) lwidth(med)) ///
				(scatter estimate x if x == 1, msymbol(circle) mcolor(dkorange*.8) mlcolor(dkorange*1.2) mlwidth(thin) ) ///
				(rspike min95 max95 x if x == 2, msymbol(circle) lcolor(blue*1.2) lwidth(med)) ///
				(scatter estimate x if x == 2, msymbol(circle) mcolor(blue*1) mlcolor(blue*1.2) mlwidth(thin) ) ///
				(rspike min95 max95 x if x == 3, msymbol(circle) lcolor(red*1.2) lwidth(med)) ///
				(scatter estimate x if x == 3, msymbol(circle) mcolor(red*1) mlcolor(red*1.2) mlwidth(thin) ) ///
				, scheme(plotplain) ///
				title("B. CVD", pos(11) size(4)) ///
				xlabel(0.5 " " 1 "Age 0-14" 2 "Age 15-64" 3 "Age 65+" 3.5 " ", nogrid) ///
				ylabel(-1.2 -0.6 0 "     0" .6, nogrid) ///
				xtitle("") ///
				ytitle("Estimated coefficients", size(3)) ///
				yline(0, lp(shortdash) lcolor(gs8) lwidth(vthin)) ///
				legend(order(1 3 5) label(1 "Age 0-14 (Mean 0.00)") label(3 "Age 15-64 (Mean 0.76)") label(5 "Age 65+ (Mean 4.00)") ring(0) pos(8) rowgap(0.4) colgap(0.4))
		
		graph save $figure/ex7/ex7B, replace

********************************************************************************

	cd $figure/ex7
	openall
	
	drop if parm == "_cons"
	split idstr, p("-")
	keep if idstr1 == "injury"
	
	rename idstr2 age
	destring age, replace
	sort age
	
	gen x = _n
		
		graph twoway (rspike min95 max95 x if x == 1, msymbol(circle) lcolor(dkorange) lwidth(med)) ///
				(scatter estimate x if x == 1, msymbol(circle) mcolor(dkorange*.8) mlcolor(dkorange*1.2) mlwidth(thin) ) ///
				(rspike min95 max95 x if x == 2, msymbol(circle) lcolor(blue*1.2) lwidth(med)) ///
				(scatter estimate x if x == 2, msymbol(circle) mcolor(blue*1) mlcolor(blue*1.2) mlwidth(thin) ) ///
				(rspike min95 max95 x if x == 3, msymbol(circle) lcolor(red*1.2) lwidth(med)) ///
				(scatter estimate x if x == 3, msymbol(circle) mcolor(red*1) mlcolor(red*1.2) mlwidth(thin) ) ///
				, scheme(plotplain) ///
				title("C. Injury", pos(11) size(4)) ///
				xlabel(0.5 " " 1 "Age 0-14" 2 "Age 15-64" 3 "Age 65+" 3.5 " ", nogrid) ///
				ylabel(-.08 -.04 0 "     0" .04, nogrid) ///
				xtitle("") ///
				ytitle("Estimated coefficients", size(3)) ///
				yline(0, lp(shortdash) lcolor(gs8) lwidth(vthin)) ///
				legend(order(1 3 5) label(1 "Age 0-14 (Mean 0.02)") label(3 "Age 15-64 (Mean 0.24)") label(5 "Age 65+ (Mean 0.30)") ring(0) pos(8) rowgap(0.4) colgap(0.4))
		
		graph save $figure/ex7/ex7C, replace

********************************************************************************

	cd $figure/ex7
	openall
	
	drop if parm == "_cons"
	split idstr, p("-")
	keep if idstr1 == "lri"
	
	rename idstr2 age
	destring age, replace
	sort age
	
	gen x = _n
		
		graph twoway (rspike min95 max95 x if x == 1, msymbol(circle) lcolor(dkorange) lwidth(med)) ///
				(scatter estimate x if x == 1, msymbol(circle) mcolor(dkorange*.8) mlcolor(dkorange*1.2) mlwidth(thin) ) ///
				(rspike min95 max95 x if x == 2, msymbol(circle) lcolor(blue*1.2) lwidth(med)) ///
				(scatter estimate x if x == 2, msymbol(circle) mcolor(blue*1) mlcolor(blue*1.2) mlwidth(thin) ) ///
				(rspike min95 max95 x if x == 3, msymbol(circle) lcolor(red*1.2) lwidth(med)) ///
				(scatter estimate x if x == 3, msymbol(circle) mcolor(red*1) mlcolor(red*1.2) mlwidth(thin) ) ///
				, scheme(plotplain) ///
				title("D. Acute Lower Respiratory Infection", pos(11) size(4)) ///
				xlabel(0.5 " " 1 "Age 0-14" 2 "Age 15-64" 3 "Age 65+" 3.5 " ", nogrid) ///
				ylabel(-.06 -.03 0 "     0" .03, nogrid) ///
				xtitle("") ///
				ytitle("Estimated coefficients", size(3)) ///
				yline(0, lp(shortdash) lcolor(gs8) lwidth(vthin)) ///
				legend(order(1 3 5) label(1 "Age 0-14 (Mean 0.00)") label(3 "Age 15-64 (Mean 0.02)") label(5 "Age 65+ (Mean 0.12)") ring(0) pos(8) rowgap(0.4) colgap(0.4))
		
		graph save $figure/ex7/ex7D, replace

********************************************************************************

	cd $figure/ex7
	openall
	
	drop if parm == "_cons"
	split idstr, p("-")
	keep if idstr1 == "clri"
	
	rename idstr2 age
	destring age, replace
	sort age
	
	gen x = _n
		
		graph twoway (rspike min95 max95 x if x == 1, msymbol(circle) lcolor(dkorange) lwidth(med)) ///
				(scatter estimate x if x == 1, msymbol(circle) mcolor(dkorange*.8) mlcolor(dkorange*1.2) mlwidth(thin) ) ///
				(rspike min95 max95 x if x == 2, msymbol(circle) lcolor(blue*1.2) lwidth(med)) ///
				(scatter estimate x if x == 2, msymbol(circle) mcolor(blue*1) mlcolor(blue*1.2) mlwidth(thin) ) ///
				(rspike min95 max95 x if x == 3, msymbol(circle) lcolor(red*1.2) lwidth(med)) ///
				(scatter estimate x if x == 3, msymbol(circle) mcolor(red*1) mlcolor(red*1.2) mlwidth(thin) ) ///
				, scheme(plotplain) ///
				title("E. Chronic Lower Respiratory Infection", pos(11) size(4)) ///
				xlabel(0.5 " " 1 "Age 0-14" 2 "Age 15-64" 3 "Age 65+" 3.5 " ", nogrid) ///
				ylabel(-.16 -.08 0 "     0" .08, nogrid) ///
				xtitle("") ///
				ytitle("Estimated coefficients", size(3)) ///
				yline(0, lp(shortdash) lcolor(gs8) lwidth(vthin)) ///
				legend(order(1 3 5) label(1 "Age 0-14 (Mean 0.00)") label(3 "Age 15-64 (Mean 0.05)") label(5 "Age 65+ (Mean 0.69)") ring(0) pos(8) rowgap(0.4) colgap(0.4))
		
		graph save $figure/ex7/ex7E, replace

********************************************************************************

	cd $figure/ex7
	openall
	
	drop if parm == "_cons"
	split idstr, p("-")
	keep if idstr1 == "cancer"
	
	rename idstr2 age
	destring age, replace
	sort age
	
	gen x = _n
		
		graph twoway (rspike min95 max95 x if x == 1, msymbol(circle) lcolor(dkorange) lwidth(med)) ///
				(scatter estimate x if x == 1, msymbol(circle) mcolor(dkorange*.8) mlcolor(dkorange*1.2) mlwidth(thin) ) ///
				(rspike min95 max95 x if x == 2, msymbol(circle) lcolor(blue*1.2) lwidth(med)) ///
				(scatter estimate x if x == 2, msymbol(circle) mcolor(blue*1) mlcolor(blue*1.2) mlwidth(thin) ) ///
				(rspike min95 max95 x if x == 3, msymbol(circle) lcolor(red*1.2) lwidth(med)) ///
				(scatter estimate x if x == 3, msymbol(circle) mcolor(red*1) mlcolor(red*1.2) mlwidth(thin) ) ///
				, scheme(plotplain) ///
				title("F. Neoplasms", pos(11) size(4)) ///
				xlabel(0.5 " " 1 "Age 0-14" 2 "Age 15-64" 3 "Age 65+" 3.5 " ", nogrid) ///
				ylabel(-.12 -.06 0 "     0" .06, nogrid) ///
				xtitle("") ///
				ytitle("Estimated coefficients", size(3)) ///
				yline(0, lp(shortdash) lcolor(gs8) lwidth(vthin)) ///
				legend(order(1 3 5) label(1 "Age 0-14 (Mean 0.01)") label(3 "Age 15-64 (Mean 0.76)") label(5 "Age 65+ (Mean 1.40)") ring(0) pos(8) rowgap(0.4) colgap(0.4))
		
		graph save $figure/ex7/ex7F, replace
		
		
********************************************************************************			
						
		graph combine  "$figure/ex7/ex7A" "$figure/ex7/ex7B" "$figure/ex7/ex7C" "$figure/ex7/ex7D" "$figure/ex7/ex7E" "$figure/ex7/ex7F", col(3) row(2) imargin(4 4 4 4 4 4) xsize(20) ysize(10) graphregion(margin(vtiny) fcolor(white) lcolor(white)) iscale(.7)
		graph save "$figure/ex7/ex7", replace
			
		graph export "$figure/allfig_eps/ex7.eps", replace
		graph export "$figure/allfig_png/ex7.png", replace width(3000)


			
		
		