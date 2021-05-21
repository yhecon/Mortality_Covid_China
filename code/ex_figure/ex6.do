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
* Extended Fig 6: Heterogeneity, pollution
*
********************************************************************************
	
	use $data/hetero.dta, clear
	
	xtset dsp date
		
	* base pollution
	
	gen mr = t_all / pop_total
		
	foreach i in aqi pm25 pm10 mr { 
		egen `i'2019_ = mean(`i') if (year == 2019), by(dsp)
		egen `i'2019 = max(`i'2019_), by(dsp)
		}
		
	keep if year == 2020
	drop if month >= 8
	drop if citycode == 4201
	
	foreach i in gdppc bed sec aqi2019 pm252019 pm102019 mr2019 {
		egen sd_`i' = std(`i')
		}
		
	foreach i in aqi pm25 pm10 mr {
		rename sd_`i'2019 sd_`i'
		}
	
	foreach i in aqi pm25 pm10 {
	reghdfe `i' inter_c_t c.inter_c_t#c.sd_`i' c.inter_c_t#c.sd_gdppc c.inter_c_t#c.sd_bed c.inter_c_t#c.sd_sec c.inter_c_t#c.sd_mr if date <= 22012, absorb(i.dsp i.date) vce(cluster dsp)
		parmest , saving($figure/ex6/ex6_`i'.dta, replace) idstr(`i')
		}
		
********************************************************************************

	cd $figure/ex6
	openall 
	
	keep if idstr == "aqi"
	drop if parm == "_cons" | parm == "inter_c_t"
		
		gen y = 0
		replace y = 5 if parm == "c.inter_c_t#c.sd_gdppc"
		replace y = 4 if parm == "c.inter_c_t#c.sd_bed"
		replace y = 3 if parm == "c.inter_c_t#c.sd_sec"
		replace y = 2 if parm == "c.inter_c_t#c.sd_aqi"
		replace y = 1 if parm == "c.inter_c_t#c.sd_mr"
		
		
		
		label define ylabel   ///	
				5 `""Lockdowns * " "GDP per capita ""' ///
				4 `""Lockdowns * " "# Hospital Bed ""' ///
				3 `""Lockdowns * " "Share of Secondary Industry in employment ""' ///
				2 `""Lockdowns * " "Initial Air Quality ""' ///
				1 `""Lockdowns * " "Inital Mortality Rate ""' ///
				
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
			title(" " "A. Air Quality Index          ", pos(11) size(3.6)) ///
			xlabel(-30 (15) 15, nogrid) ///
			xscale(range(-1 .5)) ///
			fxsize(363) fysize(100) xsize(10) ysize(5)
			
		graph save "$figure/ex6/ex6A", replace
				
********************************************************************************	

	cd $figure/ex6
	openall 
	
	keep if idstr == "pm25"
	drop if parm == "_cons" | parm == "inter_c_t"
		
		gen y = 0
		replace y = 5 if parm == "c.inter_c_t#c.sd_gdppc"
		replace y = 4 if parm == "c.inter_c_t#c.sd_bed"
		replace y = 3 if parm == "c.inter_c_t#c.sd_sec"
		replace y = 2 if parm == "c.inter_c_t#c.sd_pm25"
		replace y = 1 if parm == "c.inter_c_t#c.sd_mr"
		
		graph twoway (rspike min95 max95 y, msymbol(circle) lcolor(cranberry*1) horizontal lwidth(med)) ///
			(scatter y estimate, msymbol(circle) mcolor(cranberry*1) mlcolor(cranberry*1) mlwidth(thin) msize(1)) ///
			, scheme(plotplain) ///
			xline(0) ///
			yline(1 2 3 4 5, lpattern(dot) lcolor(gs10) lwidth(vthin)) ///
			legend(off) ///
			ylabel("",  valuelabel nogrid labsize(3.3)) ///
			yscale(range(0.5 5.5)) ///
			ytitle("") xtitle("") ///
			title(" " "B. PM2.5          ", pos(11) size(3.6)) ///
			xlabel(-30 (15) 15, nogrid) ///
			xscale(range(-1 .5)) ///
			fxsize(120) fysize(100) xsize(10) ysize(5)
			
		graph save "$figure/ex6/ex6B", replace

	
********************************************************************************

	cd $figure/ex6
	openall 
	
	keep if idstr == "pm10"
	drop if parm == "_cons" | parm == "inter_c_t"
		
		gen y = 0
		replace y = 5 if parm == "c.inter_c_t#c.sd_gdppc"
		replace y = 4 if parm == "c.inter_c_t#c.sd_bed"
		replace y = 3 if parm == "c.inter_c_t#c.sd_sec"
		replace y = 2 if parm == "c.inter_c_t#c.sd_pm10"
		replace y = 1 if parm == "c.inter_c_t#c.sd_mr"
		
		graph twoway (rspike min95 max95 y, msymbol(circle) lcolor(cranberry*1) horizontal lwidth(med)) ///
			(scatter y estimate, msymbol(circle) mcolor(cranberry*1) mlcolor(cranberry*1) mlwidth(thin) msize(1)) ///
			, scheme(plotplain) ///
			xline(0) ///
			yline(1 2 3 4 5, lpattern(dot) lcolor(gs10) lwidth(vthin)) ///
			legend(off) ///
			ylabel("",  valuelabel nogrid labsize(3.3)) ///
			yscale(range(0.5 5.5)) ///
			ytitle("") xtitle("") ///
			title(" " "C. PM10          ", pos(11) size(3.6)) ///
			xlabel(-30 (15) 15, nogrid) ///
			xscale(range(-1 .5)) ///
			fxsize(120) fysize(100) xsize(10) ysize(5)
			
		graph save "$figure/ex6/ex6C", replace				

********************************************************************************

		graph combine "$figure/ex6/ex6A" "$figure/ex6/ex6B" "$figure/ex6/ex6C", col(3) row(2) imargin(3 3 3) xsize(10) ysize(5) graphregion(margin(vtiny) fcolor(white) lcolor(white)) iscale(.9)
		
		graph save "$figure/ex6/ex6", replace 
		graph export "$figure/allfig_eps/ex6.eps", replace
		graph export "$figure/allfig_png/ex6.png", replace width(3000)

