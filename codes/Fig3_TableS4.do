
******************************
*
* Fig 3 & Table S4: Event Study
*
******************************


 * Estimation

	use "$master\y_x_daily.dta", clear
	
		replace other_all = other_all + mental + ckd
		keep if year == 2020
		replace ct = 0 if ct == . & c == 0
		replace ct = 1 if ct == . & c == 1
		keep countycode date ct
		xtset countycode date
		bysort countycode: gen ct_sum = sum(ct)

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
		bys countycode : egen ct_if = total(ct)

		gen Lead_D7 = ct - Lead_D1 - Lead_D2 - Lead_D3 - Lead_D4 - Lead_D5 - Lead_D6
		replace Lead_D7 = . if Lead_D7 != 0
		replace Lead_D7 = 1 if Lead_D7 == 0
		replace Lead_D7 = 0 if Lead_D7 == .
		replace Lead_D7 = 0 if ct_if == 0

		drop ct_sum ct
		save $results/fig3_tableS4/event_info.dta, replace


		clear
		use "$master\y_x_daily.dta", clear
		keep if year == 2020
		drop if year == 2020 & month == 3 & day >= 15
		replace other_all = other_all + mental + ckd
		xtset countycode date
		sort countycode date
		gen week = week(date)
		drop if citycode == 4201
		merge 1:1 countycode date using $results/fig3_tableS4/event_info.dta, nogen
		sort countycode date

		cap erase $results/fig3_tableS4/event.xml
		cap erase $results/fig3_tableS4/event.txt
		foreach i of varlist t_all cvd injury pneumonia{
			qui reghdfe `i' Lead_D7 Lead_D6 Lead_D5 Lead_D4 Lead_D3 Lead_D2 D0 D1 D2 D3 D4 D5 D6 if ct !=., absorb(i.date i.countycode) vce(cluster countycode)
			parmest , saving($results/fig3_tableS4/event_`i'.dta, replace)
			outreg2 using $results/fig3_tableS4/event.xml, dec(3) append bracket nocon nor2 noobs label addstat(Obs., e(N), Adjusted R-Square, e(r2_a),  # of DSP Counties, e(N_clust)) addtext(DSP Fixed Effect, "YES", Date Fixed Effect, "YES") 
			
		}
		*
		
		
		
		
******************************

 * Creating Figure
 
		clear
		cd $results/fig3_tableS4
		openall, storefilename(fn)

		drop if fn == "event_info.dta"
		keep parm estimate stderr dof t p min95 max95 fn
		
		split fn, p("_")

		gen type = "all" if fn2 == "t"
		replace type = "cvd" if fn2 == "cvd.dta"
		replace type = "injury" if fn2 == "injury.dta"
		replace type = "pneumonia" if fn2 == "pneumonia.dta"

		drop fn fn1 fn2 fn3
		drop dof t p stderr
		foreach u of var estimate min95 max95{
			replace `u' = 0 if parm == "_cons"
			}
			*

		gen dup = _n
		sort type dup
		bys type : gen dup2 = _n
		replace dup2 = dup2 - 7
		replace dup2 = dup2 -1 if dup2 <0
		replace dup2 = -1 if parm == "_cons"

		sort type dup2

		preserve
		*all
		keep if type == "all"
		graph twoway (scatter estimate dup2, mcolor(cranberry) mfcolor(white) msize(medsmall)) ///
			(rcap max95 min95 dup2, lcolor(dkorange) lwidth(medthick)) ///
			,scheme(plotplain) ///
			xlab(-7.5 " " -7 "≤ -7" -6 "-6" -5 "-5" -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "≥6" 6.5 " ", labsize(*0.8) labcolor(black) axis(1) nogrid) ///
			ylabel(, labsize(*0.8) nogrid) ///
			yline(0, lp(dash) lc(khaki)) ///
			xline(-1, lp(dash) lc(khaki)) ///
			title("Panel A. Total # of Deaths", pos(11) size(med)) ///
			xtitle("Weeks", size(*0.8)) ///
			ytitle("Estimated Coefficients", size(*0.8)) ///
			xsize(1.5) ysize(1) ///
			legend(off)
			
		graph save "$figures/fig3/panelA", replace 		
		restore


		preserve
		*cvd
		keep if type == "cvd"
		graph twoway (scatter estimate dup2, mcolor(cranberry) mfcolor(white) msize(medsmall)) ///
			(rcap max95 min95 dup2, lcolor(dkorange) lwidth(medthick)) ///
			,scheme(plotplain) ///
			xlab(-7.5 " " -7 "≤ -7" -6 "-6" -5 "-5" -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "≥6" 6.5 " ", labsize(*0.8) labcolor(black) axis(1) nogrid) ///
			ylabel(, labsize(*0.8) nogrid) ///
			yline(0, lp(dash) lc(khaki)) ///
			xline(-1, lp(dash) lc(khaki)) ///
			title("Panel B. # of Deaths from CVD", pos(11) size(med)) ///
			xtitle("Weeks", size(*0.8)) ///
			ytitle("Estimated Coefficients", size(*0.8)) ///
			xsize(1.5) ysize(1) ///
			legend(off)
		graph save "$figures/fig3/panelB", replace 		
		restore
			
		preserve
		*injurt
		keep if type == "injury"
		graph twoway (scatter estimate dup2, mcolor(cranberry) mfcolor(white) msize(medsmall)) ///
			(rcap max95 min95 dup2, lcolor(dkorange) lwidth(medthick)) ///
			,scheme(plotplain) ///
			xlab(-7.5 " " -7 "≤ -7" -6 "-6" -5 "-5" -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "≥6" 6.5 " ", labsize(*0.8) labcolor(black) axis(1) nogrid) ///
			ylabel(, labsize(*0.8) nogrid) ///
			yline(0, lp(dash) lc(khaki)) ///
			xline(-1, lp(dash) lc(khaki)) ///
			title("Panel C. # of Deaths from Injury", pos(11) size(med)) ///
			xtitle("Weeks", size(*0.8)) ///
			ytitle("Estimated Coefficients", size(*0.8)) ///
			xsize(1.5) ysize(1) ///
			legend(off)
		graph save "$figures/fig3/panelC", replace 		
		restore


		preserve
		*pneumonia
		keep if type == "pneumonia"
		graph twoway (scatter estimate dup2, mcolor(cranberry) mfcolor(white) msize(medsmall)) ///
			(rcap max95 min95 dup2, lcolor(dkorange) lwidth(medthick)) ///
			,scheme(plotplain) ///
			xlab(-7.5 " " -7 "≤ -7" -6 "-6" -5 "-5" -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "≥6" 6.5 " ", labsize(*0.8) labcolor(black) axis(1) nogrid) ///
			ylabel(, labsize(*0.8) nogrid) ///
			yline(0, lp(dash) lc(khaki)) ///
			xline(-1, lp(dash) lc(khaki)) ///
			title("Panel D. # of Deaths from Pneumonia", pos(11) size(med)) ///
			xtitle("Weeks", size(*0.8)) ///
			ytitle("Estimated Coefficients", size(*0.8)) ///
			xsize(1.5) ysize(1) ///
			legend(off)
		graph save "$figures/fig3/panelD", replace 		
		restore

		graph combine all.gph cvd.gph injury.gph pneumonia.gph, graphregion(fcolor(white)  lcolor(white)) imargin(small) iscale(0.77)  fysize(100) fxsize(150) xsize(9) ysize(6.5)

		graph save "$figures/fig3/fig3", replace 
		graph export "$figures/fig3.eps", replace
		graph export "$figures/fig3.png", replace		

		
