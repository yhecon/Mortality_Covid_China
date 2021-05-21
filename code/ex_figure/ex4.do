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
* Extended Figure 4: Robustness CHeck
*
********************************************************************************

	use "$data/main.dta", clear
	
	merge m:1 dsp using $data/psm/nnm_indicator.dta    // perform the key matching process
				
	keep if year == 2020
	keep if month == 1 | month == 2 | month == 3 | (month == 4 & day <= 7)
	
	xtset dsp date
		
	foreach i of varlist temmean rhumean prsmean winsmean aqi gdppc bed sec{
		bysort year provcode: egen `i'_provmean = mean(`i')
		replace `i' = `i'_provmean if `i' == .
	}
	
	gen month_day = month * 2 + day
		
	foreach i in gdppc bed sec {
		gen d`i' = `i'*month_day
		gen d2`i' = `i'*month_day*month_day
		gen d3`i' = `i'*month_day*month_day*month_day
		}
	
	local wth = "temmean rhumean prsmean winsmean"
	local ses = "dgdppc d2gdppc d3gdppc dbed d2bed d3bed dsec d2sec d3sec"
	
	foreach i in t_all cvd injury lri clri cancer {
		gen l`i' = ln(`i'+1)
		}
	
	foreach i of varlist t_all cvd injury lri clri cancer {
		
		reghdfe `i' inter_c_t if citycode!= 4201, absorb(i.dsp i.date) vce(cluster dsp)
		parmest , saving($figure/ex4/ex4_`i'1.dta, replace) idstr(`i') idnum(1)
		
		reghdfe `i' inter_c_t `wth' `aqi' `ses' if citycode!= 4201, absorb(i.dsp i.date) vce(cluster dsp)
		parmest , saving($figure/ex4/ex4_`i'2.dta, replace) idstr(`i') idnum(2)
		
		reghdfe `i' inter_c_t if year == 2020 [w = weight], absorb(i.dsp i.date) vce(cluster dsp)		
		parmest , saving($figure/ex4/ex4_`i'3.dta, replace) idstr(`i') idnum(3)
		
		reghdfe `i' inter_c_t if citycode!= 4201 [w=pop_total], absorb(i.dsp i.date) vce(cluster dsp)
		parmest , saving($figure/ex4/ex4_`i'4.dta, replace) idstr(`i') idnum(4)
				
		reghdfe `i' inter_c_t if provcode != 42, absorb(i.dsp i.date) vce(cluster dsp)
		parmest , saving($figure/ex4/ex4_`i'5.dta, replace) idstr(`i') idnum(5)
		
		reghdfe `i' inter_c_t, absorb(i.dsp i.date) vce(cluster dsp)
		parmest , saving($figure/ex4/ex4_`i'6.dta, replace) idstr(`i') idnum(6)
				
		reghdfe `i' group2t if citycode!= 4201, absorb(i.dsp i.date) vce(cluster dsp)
		parmest , saving($figure/ex4/ex4_`i'7.dta, replace) idstr(`i') idnum(7)	
		
		reghdfe l`i' inter_c_t if citycode!= 4201 [w=pop_total], absorb(i.dsp i.date) vce(cluster dsp)
		parmest , saving($figure/ex4/ex4_`i'8.dta, replace) idstr(`i') idnum(8)
						
	}
	
	sum t_all cvd injury lri clri cancer 

********************************************************************************

	cd $figure/ex4
	openall
		
	foreach i in estimate min95 max95 {
		replace `i' = `i' * 9.96 if idnum == 8 & idstr == "t_all"
		}
	
	keep if parm == "inter_c_t" | parm == "group2t"
	keep if idstr == "t_all"

	gen y = _n
		
		label define ylabel   ///	
				8 "Base " ///
				7 `""Include weather and SES " "control variables ""' ///
				6 `""Propensity score mathing using " "COVID, health, SES variables ""' ///
				5 " Weighting regressions by population " ///
				4 "Drop cities in Hubei " ///
				3 "Include Wuhan " ///
				2 `""Different definition " "of lockdowns ""' ///
				1 `""Log deaths with " "population weighting ""' ///
				
		label values y ylabel	
	
		graph twoway (rspike min95 max95 y if y == 8, msymbol(circle) lcolor(blue*1) horizontal lwidth(med)) ///
			(scatter y estimate if y == 8, msymbol(circle) mcolor(blue*1) mlcolor(blue*1) mlwidth(thin) msize(1)) ///
			(rspike min95 max95 y if y <= 7, msymbol(circle) lcolor(cranberry*1) horizontal lwidth(med)) ///
			(scatter y estimate if y <= 7, msymbol(circle) mcolor(cranberry*1) mlcolor(cranberry*1) mlwidth(thin) msize(1)) ///
			, scheme(plotplain) ///
			xline(0) ///
			yline(1 2 3 4 5 6 7 8, lpattern(dot) lcolor(gs10) lwidth(vthin)) ///
			legend(off) ///
			ylabel(1 2 3 4 5 6 7 8, valuelabel nogrid labsize(3.3)) ///
			yscale(range(0.5 8.5)) ///
			ytitle("") xtitle("") ///
			title(" " "A. Total          ", pos(11) size(3.6)) ///
			xlabel(-1.2 (.6) .6, nogrid) ///
			xscale(range(-1.4 .6)) ///
			fxsize(475) fysize(140) xsize(10) ysize(2)
		
		graph save "$figure/ex4/ex4A", replace	
			
********************************************************************************

	cd $figure/ex4
	openall
		
	foreach i in estimate min95 max95 {
		replace `i' = `i' * 4.92 if idnum == 8 & idstr == "cvd"
		}
	
	keep if parm == "inter_c_t" | parm == "group2t"
	keep if idstr == "cvd"

	gen y = _n
			
		graph twoway (rspike min95 max95 y if y == 8, msymbol(circle) lcolor(blue*1) horizontal lwidth(med)) ///
			(scatter y estimate if y == 8, msymbol(circle) mcolor(blue*1) mlcolor(blue*1) mlwidth(thin) msize(1)) ///
			(rspike min95 max95 y if y <= 7, msymbol(circle) lcolor(cranberry*1) horizontal lwidth(med)) ///
			(scatter y estimate if y <= 7, msymbol(circle) mcolor(cranberry*1) mlcolor(cranberry*1) mlwidth(thin) msize(1)) ///
			, scheme(plotplain) ///
			xline(0) ///
			yline(1 2 3 4 5 6 7 8, lpattern(dot) lcolor(gs10) lwidth(vthin)) ///
			legend(off) ///
			ylabel("", valuelabel) ///
			yscale(range(0.5 8.5)) ///
			ytitle("") xtitle("") ///
			title(" " "B. CVD          ", pos(11) size(3.6)) ///
			xlabel(-.6 (.3) .3, nogrid) ///
			fxsize(120) fysize(140)
			
		graph save "$figure/ex4/ex4B", replace
						
********************************************************************************

	cd $figure/ex4
	openall
		
	foreach i in estimate min95 max95 {
		replace `i' = `i' * .579 if idnum == 8 & idstr == "injury"
		}
	
	keep if parm == "inter_c_t" | parm == "group2t"
	keep if idstr == "injury"

	gen y = _n
			
		graph twoway (rspike min95 max95 y if y == 8, msymbol(circle) lcolor(blue*1) horizontal lwidth(med)) ///
			(scatter y estimate if y == 8, msymbol(circle) mcolor(blue*1) mlcolor(blue*1) mlwidth(thin) msize(1)) ///
			(rspike min95 max95 y if y <= 7, msymbol(circle) lcolor(cranberry*1) horizontal lwidth(med)) ///
			(scatter y estimate if y <= 7, msymbol(circle) mcolor(cranberry*1) mlcolor(cranberry*1) mlwidth(thin) msize(1)) ///
			, scheme(plotplain) ///
			xline(0) ///
			yline(1 2 3 4 5 6 7 8, lpattern(dot) lcolor(gs10) lwidth(vthin)) ///
			legend(off) ///
			ylabel("", valuelabel) ///
			yscale(range(0.5 8.5)) ///
			ytitle("") xtitle("") ///
			title(" " "C. Injury          ", pos(11) size(3.6)) ///
			xlabel(-.12 (.06) .06, nogrid) ///
			fxsize(120) fysize(140)
			
		graph save "$figure/ex4/ex4C", replace
		
********************************************************************************

	cd $figure/ex4
	openall
		
	foreach i in estimate min95 max95 {
		replace `i' = `i' * .139 if idnum == 8 & idstr == "lri"
		}
	
	keep if parm == "inter_c_t" | parm == "group2t"
	keep if idstr == "lri"

	gen y = _n
			
		graph twoway (rspike min95 max95 y if y == 8, msymbol(circle) lcolor(blue*1) horizontal lwidth(med)) ///
			(scatter y estimate if y == 8, msymbol(circle) mcolor(blue*1) mlcolor(blue*1) mlwidth(thin) msize(1)) ///
			(rspike min95 max95 y if y <= 7, msymbol(circle) lcolor(cranberry*1) horizontal lwidth(med)) ///
			(scatter y estimate if y <= 7, msymbol(circle) mcolor(cranberry*1) mlcolor(cranberry*1) mlwidth(thin) msize(1)) ///
			, scheme(plotplain) ///
			xline(0) ///
			yline(1 2 3 4 5 6 7 8, lpattern(dot) lcolor(gs10) lwidth(vthin)) ///
			legend(off) ///
			ylabel("", valuelabel) ///
			yscale(range(0.5 8.5)) ///
			ytitle("") xtitle("") ///
			title("D. Acute Lower" "Respiratory Infection", pos(11) size(3.6)) ///
			xlabel(-.08 (.04) .04, nogrid) ///
			fxsize(120) fysize(140)
		
		graph save "$figure/ex4/ex4D", replace	
									
********************************************************************************

	cd $figure/ex4
	openall
		
	foreach i in estimate min95 max95 {
		replace `i' = `i' * .756 if idnum == 8 & idstr == "clri"
		}
	
	keep if parm == "inter_c_t" | parm == "group2t"
	keep if idstr == "clri"

	gen y = _n
			
		graph twoway (rspike min95 max95 y if y == 8, msymbol(circle) lcolor(blue*1) horizontal lwidth(med)) ///
			(scatter y estimate if y == 8, msymbol(circle) mcolor(blue*1) mlcolor(blue*1) mlwidth(thin) msize(1)) ///
			(rspike min95 max95 y if y <= 7, msymbol(circle) lcolor(cranberry*1) horizontal lwidth(med)) ///
			(scatter y estimate if y <= 7, msymbol(circle) mcolor(cranberry*1) mlcolor(cranberry*1) mlwidth(thin) msize(1)) ///
			, scheme(plotplain) ///
			xline(0) ///
			yline(1 2 3 4 5 6 7 8, lpattern(dot) lcolor(gs10) lwidth(vthin)) ///
			legend(off) ///
			ylabel("", valuelabel) ///
			yscale(range(0.5 8.5)) ///
			ytitle("") xtitle("") ///
			title("E. Chronic Lower" "Respiratory Infection", pos(11) size(3.6)) ///
			xlabel(-.24 (.12) .12, nogrid) ///
			fxsize(120) fysize(140)
			
		graph save "$figure/ex4/ex4E", replace
										
********************************************************************************

	cd $figure/ex4
	openall
		
	foreach i in estimate min95 max95 {
		replace `i' = `i' * 2.26 if idnum == 8 & idstr == "cancer"
		}
	
	keep if parm == "inter_c_t" | parm == "group2t"
	keep if idstr == "cancer"

	gen y = _n
			
		graph twoway (rspike min95 max95 y if y == 8, msymbol(circle) lcolor(blue*1) horizontal lwidth(med)) ///
			(scatter y estimate if y == 8, msymbol(circle) mcolor(blue*1) mlcolor(blue*1) mlwidth(thin) msize(1)) ///
			(rspike min95 max95 y if y <= 7, msymbol(circle) lcolor(cranberry*1) horizontal lwidth(med)) ///
			(scatter y estimate if y <= 7, msymbol(circle) mcolor(cranberry*1) mlcolor(cranberry*1) mlwidth(thin) msize(1)) ///
			, scheme(plotplain) ///
			xline(0) ///
			yline(1 2 3 4 5 6 7 8, lpattern(dot) lcolor(gs10) lwidth(vthin)) ///
			legend(off) ///
			ylabel("", valuelabel) ///
			yscale(range(0.5 8.5)) ///
			ytitle("") xtitle("") ///
			title(" " "F. Neoplasms          ", pos(11) size(3.6)) ///
			xlabel(-.24 (.12) .12, nogrid) ///
			fxsize(120) fysize(140)	
		
		graph save "$figure/ex4/ex4F", replace	
	
	
********************************************************************************

		graph combine "$figure/ex4/ex4A" "$figure/ex4/ex4B" "$figure/ex4/ex4C" "$figure/ex4/ex4D" "$figure/ex4/ex4E" "$figure/ex4/ex4F", ///
				graphregion(fcolor(white) lcolor(white)) imargin(small) col(6) iscale(0.6) xsize(20) ysize(10)
	
		graph save "$figure/ex4/ex4.gph", replace
		graph export "$figure/allfig_eps/ex4.eps", replace
		graph export "$figure/allfig_png/ex4.png", replace width(3000)

			
			
