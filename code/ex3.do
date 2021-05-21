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
* Extended Fig 3: Cause-specific Deaths, CVD and Injury
*
********************************************************************************
	
	use "$data/main.dta", clear
		
		keep if year == 2020
		keep if month == 1 | month == 2 | month == 3 | (month == 4 & day <= 7)
		drop if citycode == 4201

		xtset dsp date
		
		foreach i in cvd mi stroke other_cvd { 
			reghdfe `i' inter_c_t if year == 2020, absorb(i.dsp i.date) vce(cluster dsp)
			parmest , saving($figure/ex3/ex3_`i'.dta, replace) idstr(`i') idnum(1)
			}
			
		foreach i in injury traffic other_injury suicide { 
			reghdfe `i' inter_c_t if year == 2020, absorb(i.dsp i.date) vce(cluster dsp)
			parmest , saving($figure/ex3/ex3_`i'.dta, replace) idstr(`i') idnum(2)
			}
		
		local ex3 = "cvd mi stroke other_cvd injury traffic other_injury suicide"
		format `ex3' %9.3g
		sum `ex3', format

********************************************************************************
		
	cd $figure/ex3
	openall
	
	drop if parm == "_cons"
	keep if idnum == 1
	
	gen x = 0
	replace x = 1 if idstr == "cvd"
	replace x = 2 if idstr == "mi"
	replace x = 3 if idstr == "stroke"
	replace x = 4 if idstr == "other_cvd"
	
		graph twoway (rspike min95 max95 x , msymbol(circle) lcolor(cranberry*1) lwidth(med)) ///
				(scatter estimate x , msymbol(circle) mcolor(cranberry * 1) mlcolor(cranberry * 1) mlwidth(thin)) ///
				, scheme(plotplain) ///
				title("A. CVD", pos(11) size(4)) ///
				xlabel(0.5 " " 1 "CVD" 2 `""Myocardial" "Infarction""' 3 "Stroke" 4 "Other CVDs" 4.5 " ", nogrid) ///
				ylabel(-.8 -.4 0 "     0" .4, nogrid) ///
				xtitle("") ///
				ytitle("Estimated Coefficients", size(3)) ///
				yline(0, lp(shortdash) lcolor(gs8) lwidth(vthin)) ///
				legend(order(2 1) label(1 "95% CI") label(2 "Point Estimate") ring(0) pos(11) rowgap(0.4) colgap(0.4)) ///
				text(-.7 1 "Mean: 4.75", size(2.7)) ///
				text(-.7 2 "Mean: 1.92", size(2.7)) ///
				text(-.7 3 "Mean: 2.01", size(2.7)) ///
				text(-.7 4 "Mean: 0.83", size(2.7)) 
	
	graph save $figure/ex3/ex3A, replace
		
********************************************************************************
		
	cd $figure/ex3
	openall
	
	drop if parm == "_cons"
	keep if idnum == 2
	
	gen x = 0
	replace x = 1 if idstr == "injury"
	replace x = 2 if idstr == "traffic"
	replace x = 3 if idstr == "other_injury"
	replace x = 4 if idstr == "suicide"
	
		graph twoway (rspike min95 max95 x , msymbol(circle) lcolor(cranberry*1) lwidth(med)) ///
				(scatter estimate x , msymbol(circle) mcolor(cranberry * 1) mlcolor(cranberry * 1) mlwidth(thin)) ///
				, scheme(plotplain) ///
				title("B. Injury", pos(11) size(4)) ///
				xlabel(0.5 " " 1 "Injury" 2 "Traffic" 3 `""Other" "Injurys""' 4 "Suicide" 4.5 " ", nogrid) ///
				ylabel(-.1 -.05 0 "     0" .05, nogrid) ///
				xtitle("") ///
				ytitle("Estimated Coefficients", size(3)) ///
				yline(0, lp(shortdash) lcolor(gs8) lwidth(vthin)) ///
				legend(order(2 1) label(1 "95% CI") label(2 "Point Estimate") ring(0) pos(11) rowgap(0.4) colgap(0.4)) ///
				text(-.0875 1 "Mean: 0.56", size(2.7)) ///
				text(-.0875 2 "Mean: 0.13", size(2.7)) ///
				text(-.0875 3 "Mean: 0.34", size(2.7)) ///
				text(-.0875 4 "Mean: 0.09", size(2.7)) 
	
	graph save $figure/ex3/ex3B, replace
		
********************************************************************************

	graph combine "$figure/ex3/ex3A" "$figure/ex3/ex3B", col(2) imargin(3 3) xsize(15) ysize(5) graphregion(margin(vtiny) fcolor(white) lcolor(white)) iscale(1.2)
	
		graph save "$figure/ex3/ex3.gph", replace
		graph export "$figure/allfig_eps/ex3.eps", replace
		graph export "$figure/allfig_png/ex3.png", replace width(3000)



			