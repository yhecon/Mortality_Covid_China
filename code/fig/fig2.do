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
* Figure 2: Main DID
*
********************************************************************************

	use "$data/main.dta", clear

		keep if year == 2020
		keep if month == 1 | month == 2 | month == 3 | (month == 4 & day <= 7)
		drop if citycode == 4201

		xtset dsp date

		foreach i of varlist t_all cvd injury lri clri cancer other_all{
			reghdfe `i' inter_c_t if year == 2020, absorb(i.dsp i.date) vce(cluster dsp)
			parmest , saving($figure/fig2/fig2_`i'.dta, replace)
		}

********************************************************************************
		
	* figure
		cd $figure/fig2
		openall, storefilename(fn)
		drop if parm == "_cons"
		split fn, p("_")
		split fn2, p(".")
		drop fn-fn3 fn22 dof t p stderr

		* group
		gen group = 1 if fn21 == "t"
		replace group = 2 if fn21 == "cvd"
		replace group = 3 if fn21 == "injury"
		replace group = 4 if fn21 == "lri"
		replace group = 5 if fn21 == "clri"
		replace group = 6 if fn21 == "cancer"
		replace group = 7 if fn21 == "other"

		gen meanv = 9.62 if fn21 == "t"
		replace meanv = 4.75 if fn21 == "cvd"
		replace meanv = 0.56 if fn21 == "injury"
		replace meanv = 0.13 if fn21 == "lri"
		replace meanv = 0.74 if fn21 == "clri"
		replace meanv = 2.17 if fn21 == "cancer"
		replace meanv = 1.12 if fn21 == "other"

		foreach u of var estimate min95 max95{
			gen m_`u' = `u'/meanv
			}
			*
		
		gen maker1 = estimate
		format %4.3f maker1
		
		gen marker2 = round(m_estimate/0.00001)
		replace marker2 = round(marker2/1000, 0.001)
		format marker2 %9.3g
		tostring marker2, replace usedisplayformat force
		replace marker2 = marker2+"%"
		
		sort group
		gen x = 8- _n
		
		label define ylabel   ///	
				0 " " ///
				1 "7. Other causes  " ///
				2 "6. Neoplasms  " ///
				3 `" "5. Chronic Lower  " "Respiratory Infection  " "' ///
				4 `" "4. Acute Lower  " "Respiratory Infection  " "' ///
				5 "3. Injury  " ///
				6 "2. CVD  " ///
				7 `" "1. Total  " "Deaths  " "' ///
								
			label values x ylabel

		graph twoway (rcap min95 max95 x, horizontal lcolor(red*1.2) lwidth(medthick)) ///
						(scatter x estimate, msymbol(O) mlcolor(red*1) mfcolor(red*0.6) msize(1.5) mlabel(maker1) mlabposition(11) mlabgap(*1.2) mlabsize(2.7)) ///
						,scheme(s1mono) ///
						legend(off) ///
						ysize(6) xsize(6) ///
						xline(0, lp(dash) lc(yellow*1.3) lwidth(thin)) ///
						ylabel(1/7, valuelabel labsize(3.2) angle(0) nogrid) ///
						yscale(range(0.2 7.5)) ///
						ytitle("") ///
						title("A. Impact on Deaths", pos(11) size(3.75) color(black)) ///
						fysize(100) fxsize(126) ///
						text(6.8 -0.78  "({it:Mean = 9.62})", place(e) size(2.4)) ///
						text(5.8 -0.78  "({it:Mean = 4.75})", place(e) size(2.4)) ///
						text(4.8 -0.78  "({it:Mean = 0.56})", place(e) size(2.4)) ///
						text(3.8 -0.78  "({it:Mean = 0.13})", place(e) size(2.4)) ///
						text(2.8 -0.78  "({it:Mean = 0.74})", place(e) size(2.4)) ///
						text(1.8 -0.78  "({it:Mean = 2.17})", place(e) size(2.4)) ///
						text(0.8 -0.78  "({it:Mean = 1.12})", place(e) size(2.4)) ///
						yline(1, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(2, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(3, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(4, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(5, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(6, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(7, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						xlabel(-0.8 (0.4) 0.2, nogrid)						
						
		graph save "$figure/fig2/panelA", replace 					
							
				graph twoway (rcap m_min95 m_max95 x, horizontal lcolor(blue*1.2) lwidth(medthick)) ///
						(scatter x m_estimate, msymbol(O) mlcolor(blue*1) mfcolor(blue*0.6) msize(1.5) mlabel(marker2) mlabposition(11) mlabgap(*1.2) mlabsize(2.7)) ///
						,scheme(s1mono) ///
						legend(off) ///
						ysize(6) xsize(3) ///
						xline(0, lp(dash) lc(yellow*1.3) lwidth(thin)) ///
						ylabel(1/7, nolabels noticks nogrid) ///
						yscale(range(0.2 7.5)) ///
						ytitle("") ///
						yscale(range(0.2 3.7)) ///						
						title("B. Impact on Deaths (%)", pos(11) size(3.75) color(black)) ///
						fysize(150) fxsize(52.5) ///
						yline(1, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(2, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(3, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(4, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(5, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(6, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(7, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						xlabel(-0.4 (0.2) 0.1, nogrid)
		
		graph save "$figure/fig2/panelB", replace		

********************************************************************************

		graph combine "$figure/fig2/panelA" "$figure/fig2/panelB" , ///
				graphregion(fcolor(white) lcolor(white)) imargin(small) col(2) iscale(0.75) fysize(150) fxsize(140) xsize(8) ysize(6)
							
		graph save "$figure/fig2/fig2.gph", replace
		graph export "$figure/allfig_eps/fig2.eps", replace
		graph export "$figure/allfig_png/fig2.png", replace width(3000)



			
			
