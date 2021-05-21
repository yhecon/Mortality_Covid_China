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


global data "$dir/data"
global table "$dir/table"
global figure  "$dir/figure"

********************************************************************************
*
* Fig5: Heterogeneity
*
********************************************************************************

	use $data/hetero.dta, clear
	
	drop if citycode == 4201
	drop if year == 2020 & (month >= 5 | (month == 4 & day >= 8))
					
	foreach i in t_all cvd injury lri clri cancer{ 
		gen mr`i' = `i' / pop_total
		egen mr`i'2019_ = mean(mr`i') if (year == 2019), by(dsp)
		egen mr`i'2019 = max(mr`i'2019_), by(dsp)
		}
	
	foreach i in aqi { 
		egen `i'2019_ = mean(`i') if (year == 2019), by(dsp)
		egen `i'2019 = max(`i'2019_), by(dsp)
		}		
		
	foreach i in gdppc bed sec aqi2019 mrt_all2019 mrcvd2019 mrinjury2019 mrlri2019 mrclri2019 mrcancer2019 {
		egen sd_`i' = std(`i')
		gen ct_`i' = ct*sd_`i'
		}
		
	foreach i in t_all cvd injury lri clri cancer {
		rename ct_mr`i'2019 ct_`i'
		}
	
	sort dsp date
		
	foreach i in t_all cvd injury lri clri cancer {
		reghdfe `i' ct ct_gdppc ct_bed ct_sec ct_aqi ct_`i' if year == 2020, absorb(i.dsp i.date) vce(cluster dsp)
		parmest , saving($figure/fig5/fig5_`i'.dta, replace) idstr(`i')
		}
		
********************************************************************************	

	cd $figure/fig5
	openall 
	
	keep if idstr == "t_all"
	drop if parm == "_cons" | parm == "ct"
		
		gen y = 6 - _n
		
		label define ylabel   ///	
				5 `""Lockdowns * " "GDP per capita ""' ///
				4 `""Lockdowns * " "# Hospital Bed ""' ///
				3 `""Lockdowns * " "Share of Secondary Industry in Employment ""' ///
				2 `""Lockdowns * " "Air Quality Index ""' ///
				1 `""Lockdowns * " "Inital Health Status ""' ///
				
		label values y ylabel	
	
		graph twoway (rspike min95 max95 y, msymbol(circle) lcolor(cranberry*1) horizontal lwidth(med)) ///
			(scatter y estimate, msymbol(circle) mcolor(cranberry*1) mlcolor(cranberry*1) mlwidth(thin) msize(1)) ///
			, scheme(plotplain) ///
			xline(0) ///
			yline(1 2 3 4 5, lpattern(dot) lcolor(gs10) lwidth(vthin)) ///
			legend(off) ///
			ylabel(,  valuelabel nogrid labsize(3.3)) ///
			yscale(range(0.5 5.5)) ///
			ytitle("") xtitle("") ///
			title(" " "A. Total          ", pos(11) size(3.6)) ///
			xlabel(-1 (.5) .5, nogrid) ///
			xscale(range(-1 .5)) ///
			fxsize(430) fysize(100) xsize(10) ysize(5)
			
		graph save "$figure/fig5/fig5A", replace
				
********************************************************************************	

	cd $figure/fig5
	openall 
	
	keep if idstr == "cvd"
	drop if parm == "_cons" | parm == "ct"
		
		gen y = 6 - _n
		
		graph twoway (rspike min95 max95 y, msymbol(circle) lcolor(cranberry*1) horizontal lwidth(med)) ///
			(scatter y estimate, msymbol(circle) mcolor(cranberry*1) mlcolor(cranberry*1) mlwidth(thin) msize(1)) ///
			, scheme(plotplain) ///
			xline(0) ///
			yline(1 2 3 4 5, lpattern(dot) lcolor(gs10) lwidth(vthin)) ///
			legend(off) ///
			ylabel("", valuelabel) ///
			yscale(range(0.5 5.5)) ///
			ytitle("") xtitle("") ///
			xlabel(-.6 (.3) .3, nogrid) ///
			title(" " "B. CVD          ", pos(11) size(3.6)) ///
			fxsize(120) fysize(100)
			
		graph save "$figure/fig5/fig5B", replace
									
********************************************************************************	

	cd $figure/fig5
	openall 
	
	keep if idstr == "injury"
	drop if parm == "_cons" | parm == "ct"
		
		gen y = 6 - _n
		
		graph twoway (rspike min95 max95 y, msymbol(circle) lcolor(cranberry*1) horizontal lwidth(med)) ///
			(scatter y estimate, msymbol(circle) mcolor(cranberry*1) mlcolor(cranberry*1) mlwidth(thin) msize(1)) ///
			, scheme(plotplain) ///
			xline(0) ///
			yline(1 2 3 4 5, lpattern(dot) lcolor(gs10) lwidth(vthin)) ///
			legend(off) ///
			ylabel("", valuelabel) ///
			yscale(range(0.5 5.5)) ///
			ytitle("") xtitle("") ///
			xlabel(-.08 (.04) .04, nogrid) ///
			title(" " "C. Injury          ", pos(11) size(3.6)) ///
			fxsize(120) fysize(100)
					
		graph save "$figure/fig5/fig5C", replace
						
********************************************************************************	

	cd $figure/fig5
	openall 
	
	keep if idstr == "lri"
	drop if parm == "_cons" | parm == "ct"
		
		gen y = 6 - _n
		
		graph twoway (rspike min95 max95 y, msymbol(circle) lcolor(cranberry*1) horizontal lwidth(med)) ///
			(scatter y estimate, msymbol(circle) mcolor(cranberry*1) mlcolor(cranberry*1) mlwidth(thin) msize(1)) ///
			, scheme(plotplain) ///
			xline(0) ///
			yline(1 2 3 4 5, lpattern(dot) lcolor(gs10) lwidth(vthin)) ///
			legend(off) ///
			ylabel("", valuelabel) ///
			yscale(range(0.5 5.5)) ///
			ytitle("") xtitle("") ///
			xlabel(-.1 (.05) .05, nogrid) ///
			title("D. Acute Lower" "Respiratory Infection", pos(11) size(3.6)) ///
			fxsize(120) fysize(100)
	
		graph save "$figure/fig5/fig5D", replace
								
********************************************************************************	

	cd $figure/fig5
	openall 
	
	keep if idstr == "clri"
	drop if parm == "_cons" | parm == "ct"
		
		gen y = 6 - _n
		
		graph twoway (rspike min95 max95 y, msymbol(circle) lcolor(cranberry*1) horizontal lwidth(med)) ///
			(scatter y estimate, msymbol(circle) mcolor(cranberry*1) mlcolor(cranberry*1) mlwidth(thin) msize(1)) ///
			, scheme(plotplain) ///
			xline(0) ///
			yline(1 2 3 4 5, lpattern(dot) lcolor(gs10) lwidth(vthin)) ///
			legend(off) ///
			ylabel("", valuelabel) ///
			yscale(range(0.5 5.5)) ///
			ytitle("") xtitle("") ///
			xlabel(-.24 (.12) .12, nogrid) ///
			title("E. Chronic Lower" "Respiratory Infection", pos(11) size(3.6)) ///
			fxsize(120) fysize(100)
	
		graph save "$figure/fig5/fig5E", replace
	
							
********************************************************************************	

	cd $figure/fig5
	openall 
	
	keep if idstr == "cancer"
	drop if parm == "_cons" | parm == "ct"
		
		gen y = 6 - _n
		
		graph twoway (rspike min95 max95 y, msymbol(circle) lcolor(cranberry*1) horizontal lwidth(med)) ///
			(scatter y estimate, msymbol(circle) mcolor(cranberry*1) mlcolor(cranberry*1) mlwidth(thin) msize(1)) ///
			, scheme(plotplain) ///
			xline(0) ///
			yline(1 2 3 4 5, lpattern(dot) lcolor(gs10) lwidth(vthin)) ///
			legend(off) ///
			ylabel("", valuelabel) ///
			yscale(range(0.5 5.5)) ///
			ytitle("") xtitle("") ///
			xlabel(-.2 (.1) .1, nogrid) ///
			title(" " "F. Neoplasms          ", pos(11) size(3.6)) ///
			fxsize(120) fysize(100)
	
		graph save "$figure/fig5/fig5F", replace
	
	
********************************************************************************
	
		graph combine "$figure/fig5/fig5A" "$figure/fig5/fig5B" "$figure/fig5/fig5C" "$figure/fig5/fig5D" "$figure/fig5/fig5E" "$figure/fig5/fig5F", ///
				graphregion(fcolor(white) lcolor(white)) imargin(small) col(6) iscale(0.75) xsize(20) ysize(8)
					
		graph save "$figure/fig5/fig5.gph", replace
		graph export "$figure/allfig_eps/fig5.eps", replace
		graph export "$figure/allfig_png/fig5.png", replace width(3000)

			
			
