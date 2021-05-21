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
* Fig4: Medium-term effects
*
********************************************************************************
	
	use "$data/main.dta", clear

		keep if year == 2020 & month <= 7
		drop if citycode == 4201

		* Check balance panel
		xtset dsp date
		
		foreach i of varlist t_all cvd injury lri clri cancer other_all{
			reghdfe `i' inter_c_t inter_medium_treat, absorb(i.dsp i.date) vce(cluster dsp)
			parmest , saving($figure/fig4/fig4_`i'.dta, replace) idstr(`i')
			}
		
********************************************************************************
		
	cd $figure/fig4
	openall
	
	drop if parm == "_cons"
	keep if idstr == "t_all"
	
	gen x = _n
		
		graph twoway (rspike min95 max95 x if x == 1, msymbol(circle) lcolor(blue*1.2) lwidth(fig4)) ///
				(scatter estimate x if x == 1, msymbol(circle) mcolor(blue*1) mlcolor(blue*1.2) mlwidth(thin) ) ///
				(rspike min95 max95 x if x == 2, msymbol(circle) lcolor(red*1.2) lwidth(fig4)) ///
				(scatter estimate x if x == 2, msymbol(circle) mcolor(red*1) mlcolor(red*1.2) mlwidth(thin) ) ///
				, scheme(plotplain) ///
				title("A. Total", pos(11) size(4)) ///
				xlabel(0.5 " " 1 "Lockdowns" 2 "After Lockdowns" 2.5 " ", nogrid) ///
				ylabel(-2 -1 0 "    0" 1, nogrid) ///
				xtitle("") ///
				ytitle("Estimated Coefficients", size(3)) ///
				yline(0, lp(shortdash) lcolor(gs8) lwidth(vthin)) ///
				legend(order(2 4) label(2 "Jan 1st - Apr 7th") label(4 "Apr 8th - Jul 31th")  ring(0) pos(11) rowgap(0.4) colgap(0.4))
		
		graph save $figure/fig4/fig4A, replace
				
			
********************************************************************************
		
	cd $figure/fig4
	openall
	
	drop if parm == "_cons"
	keep if idstr == "cvd"
	
	gen x = _n
		
		graph twoway (rspike min95 max95 x if x == 1, msymbol(circle) lcolor(blue*1.2) lwidth(fig4)) ///
				(scatter estimate x if x == 1, msymbol(circle) mcolor(blue*1) mlcolor(blue*1.2) mlwidth(thin) ) ///
				(rspike min95 max95 x if x == 2, msymbol(circle) lcolor(red*1.2) lwidth(fig4)) ///
				(scatter estimate x if x == 2, msymbol(circle) mcolor(red*1) mlcolor(red*1.2) mlwidth(thin) ) ///
				, scheme(plotplain) ///
				title("B. CVD", pos(11) size(4)) ///
				xlabel(0.5 " " 1 "Lockdowns" 2 "After Lockdowns" 2.5 " ", nogrid) ///
				ylabel(-1.2 -0.6 0 "    0" .6, nogrid) ///
				xtitle("") ///
				ytitle("Estimated Coefficients", size(3)) ///
				yline(0, lp(shortdash) lcolor(gs8) lwidth(vthin)) ///
				legend(order(2 4) label(2 "Jan 1st - Apr 7th") label(4 "Apr 8th - Jul 31th")  ring(0) pos(11) rowgap(0.4) colgap(0.4))
		
		graph save $figure/fig4/fig4B, replace	
				
********************************************************************************
		
	cd $figure/fig4
	openall
	
	drop if parm == "_cons"
	keep if idstr == "injury"
	
	gen x = _n
		
		graph twoway (rspike min95 max95 x if x == 1, msymbol(circle) lcolor(blue*1.2) lwidth(fig4)) ///
				(scatter estimate x if x == 1, msymbol(circle) mcolor(blue*1) mlcolor(blue*1.2) mlwidth(thin) ) ///
				(rspike min95 max95 x if x == 2, msymbol(circle) lcolor(red*1.2) lwidth(fig4)) ///
				(scatter estimate x if x == 2, msymbol(circle) mcolor(red*1) mlcolor(red*1.2) mlwidth(thin) ) ///
				, scheme(plotplain) ///
				title("C. Injury", pos(11) size(4)) ///
				xlabel(0.5 " " 1 "Lockdowns" 2 "After Lockdowns" 2.5 " ", nogrid) ///
				ylabel(-.12 -.06 0 "    0" .06, nogrid) ///
				xtitle("") ///
				ytitle("Estimated Coefficients", size(3)) ///
				yline(0, lp(shortdash) lcolor(gs8) lwidth(vthin)) ///
				legend(order(2 4) label(2 "Jan 1st - Apr 7th") label(4 "Apr 8th - Jul 31th")  ring(0) pos(11) rowgap(0.4) colgap(0.4))
		
		graph save $figure/fig4/fig4C, replace	
				
								
********************************************************************************
		
	cd $figure/fig4
	openall
	
	drop if parm == "_cons"
	keep if idstr == "lri"
	
	gen x = _n
		
		graph twoway (rspike min95 max95 x if x == 1, msymbol(circle) lcolor(blue*1.2) lwidth(fig4)) ///
				(scatter estimate x if x == 1, msymbol(circle) mcolor(blue*1) mlcolor(blue*1.2) mlwidth(thin) ) ///
				(rspike min95 max95 x if x == 2, msymbol(circle) lcolor(red*1.2) lwidth(fig4)) ///
				(scatter estimate x if x == 2, msymbol(circle) mcolor(red*1) mlcolor(red*1.2) mlwidth(thin) ) ///
				, scheme(plotplain) ///
				title("D. Acute Lower Respiratory Infection", pos(11) size(4)) ///
				xlabel(0.5 " " 1 "Lockdowns" 2 "After Lockdowns" 2.5 " ", nogrid) ///
				ylabel(-.1 -.05 0 "    0" .05, nogrid) ///
				xtitle("") ///
				ytitle("Estimated Coefficients", size(3)) ///
				yline(0, lp(shortdash) lcolor(gs8) lwidth(vthin)) ///
				legend(order(2 4) label(2 "Jan 1st - Apr 7th") label(4 "Apr 8th - Jul 31th")  ring(0) pos(11) rowgap(0.4) colgap(0.4))
		
		graph save $figure/fig4/fig4D, replace	
								
********************************************************************************
		
	cd $figure/fig4
	openall
	
	drop if parm == "_cons"
	keep if idstr == "clri"
	
	gen x = _n
		
		graph twoway (rspike min95 max95 x if x == 1, msymbol(circle) lcolor(blue*1.2) lwidth(fig4)) ///
				(scatter estimate x if x == 1, msymbol(circle) mcolor(blue*1) mlcolor(blue*1.2) mlwidth(thin) ) ///
				(rspike min95 max95 x if x == 2, msymbol(circle) lcolor(red*1.2) lwidth(fig4)) ///
				(scatter estimate x if x == 2, msymbol(circle) mcolor(red*1) mlcolor(red*1.2) mlwidth(thin) ) ///
				, scheme(plotplain) ///
				title("E. Chronic Lower Respiratory Infection", pos(11) size(4)) ///
				xlabel(0.5 " " 1 "Lockdowns" 2 "After Lockdowns" 2.5 " ", nogrid) ///
				ylabel(-.3 -.15 0 "    0" .15, nogrid) ///
				xtitle("") ///
				ytitle("Estimated Coefficients", size(3)) ///
				yline(0, lp(shortdash) lcolor(gs8) lwidth(vthin)) ///
				legend(order(2 4) label(2 "Jan 1st - Apr 7th") label(4 "Apr 8th - Jul 31th")  ring(0) pos(11) rowgap(0.4) colgap(0.4))
		
		graph save $figure/fig4/fig4E, replace					
										
********************************************************************************
		
	cd $figure/fig4
	openall
	
	drop if parm == "_cons"
	keep if idstr == "cancer"
	
	gen x = _n
		
		graph twoway (rspike min95 max95 x if x == 1, msymbol(circle) lcolor(blue*1.2) lwidth(fig4)) ///
				(scatter estimate x if x == 1, msymbol(circle) mcolor(blue*1) mlcolor(blue*1.2) mlwidth(thin) ) ///
				(rspike min95 max95 x if x == 2, msymbol(circle) lcolor(red*1.2) lwidth(fig4)) ///
				(scatter estimate x if x == 2, msymbol(circle) mcolor(red*1) mlcolor(red*1.2) mlwidth(thin) ) ///
				, scheme(plotplain) ///
				title("F. Neoplasms", pos(11) size(4)) ///
				xlabel(0.5 " " 1 "Lockdowns" 2 "After Lockdowns" 2.5 " ", nogrid) ///
				ylabel(-.4 -.2 0 "    0" .2, nogrid) ///
				xtitle("") ///
				ytitle("Estimated Coefficients", size(3)) ///
				yline(0, lp(shortdash) lcolor(gs8) lwidth(vthin)) ///
				legend(order(2 4) label(2 "Jan 1st - Apr 7th") label(4 "Apr 8th - Jul 31th")  ring(0) pos(11) rowgap(0.4) colgap(0.4))
		
		graph save $figure/fig4/fig4F, replace	
	
********************************************************************************			
						
		graph combine  "$figure/fig4/fig4A" "$figure/fig4/fig4B" "$figure/fig4/fig4C" "$figure/fig4/fig4D" "$figure/fig4/fig4E" "$figure/fig4/fig4F", col(3) row(2) imargin(4 4 4 4 4 4) xsize(20) ysize(10) graphregion(margin(vtiny) fcolor(white) lcolor(white)) iscale(.7)
		graph save "$figure/fig4/fig4", replace
			
		graph export "$figure/allfig_eps/fig4.eps", replace
		graph export "$figure/allfig_png/fig4.png", replace width(3000)


			

		
		
		
