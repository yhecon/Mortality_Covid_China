

******************************
*
* Fig S5
*
******************************

	use "$master/y_daily_extra.dta", clear
	
	keep if year == 2020
	drop if citycode == 4201

	cap drop dsp
	rename code dsp
	rename deaddate1 date
	xtset dsp date

	drop if year == 2020 & month == 3 & day >= 15

	gen inter_c_t1= ct
	gen inter_c_t2= ct
	gen inter_c_t3= ct

	label variable inter_c_t1 "Lockdown policy: 0~14 years old"
	label variable inter_c_t2 "Lockdown policy: 15~64 years old"
	label variable inter_c_t3 "Lockdown policy: over 65 years old"

	forvalues i = 1/3{
	label variable t_all_agegroup`i' "Total"
	label variable cvd_agegroup`i' "CVD"
	label variable injury_agegroup`i' "Injury"
	label variable pneumonia_agegroup`i' "Pneumonia"
	label variable res_agegroup`i' "Respiratory Diseases"
	label variable other_all_agegroup`i' "Others"
	label variable diabetes_agegroup`i' "Diabetes"
	label variable cancer_agegroup`i' "Cancer"
	label variable inf_dis_agegroup`i' "Infectious Diseases"
	label variable traffic_agegroup`i' "Traffic"
	label variable suicide_agegroup`i' "Suicide"
	replace other_all_agegroup`i' = other_all_agegroup`i' + mental_agegroup`i' + ckd_agegroup`i'
	}

	rename t_all_agegroup1 tall_agegroup1
	rename t_all_agegroup2 tall_agegroup2
	rename t_all_agegroup3 tall_agegroup3


	rename t_all tall
	
	reghdfe tall inter_c_t1 if year == 2020, absorb(i.dsp i.date) vce(cluster dsp)
		parmest , saving($results/figS5_tableS10/allage.dta, replace)
		outreg2 using $results/figS5_tableS10/tableS10.xml, dec(3) append bracket nocon nor2 noobs label addstat(Obs., e(N), Adjusted R-Square, e(r2_a),  # of DSP Counties, e(N_clust)) addtext(DSP Fixed Effect, "YES", Date Fixed Effect, "YES") 
			
	
	foreach i of varlist tall cvd injury pneumonia{

		reghdfe `i'_agegroup1 inter_c_t1 if year == 2020, absorb(i.dsp i.date) vce(cluster dsp)
		parmest , saving($results/figS5_tableS10/age1_`i'w.dta, replace)
		outreg2 using $results/figS5_tableS10/tableS10.xml, dec(3) append bracket nocon nor2 noobs label addstat(Obs., e(N), Adjusted R-Square, e(r2_a),  # of DSP Counties, e(N_clust)) addtext(DSP Fixed Effect, "YES", Date Fixed Effect, "YES") 
			
		reghdfe `i'_agegroup2 inter_c_t2 if year == 2020, absorb(i.dsp i.date) vce(cluster dsp)
		parmest , saving($results/figS5_tableS10/age2_`i'w.dta, replace)
		outreg2 using $results/figS5_tableS10/tableS10.xml, dec(3) append bracket nocon nor2 noobs label addstat(Obs., e(N), Adjusted R-Square, e(r2_a),  # of DSP Counties, e(N_clust)) addtext(DSP Fixed Effect, "YES", Date Fixed Effect, "YES") 
			
		reghdfe `i'_agegroup3 inter_c_t3 if year == 2020, absorb(i.dsp i.date) vce(cluster dsp)
		parmest , saving($results/figS5_tableS10/age3_`i'w.dta, replace)
		outreg2 using $results/figS5_tableS10/tableS10.xml, dec(3) append bracket nocon nor2 noobs label addstat(Obs., e(N), Adjusted R-Square, e(r2_a),  # of DSP Counties, e(N_clust)) addtext(DSP Fixed Effect, "YES", Date Fixed Effect, "YES") 
			
	}


********************************************************************************

* figure

		cd $results/figS5_tableS10
		openall, storefilename(fn)
		drop if parm == "_cons"
		split fn, p("_")
		drop fn
		drop dof t p
		drop stderr
		split fn2, p(".")
		drop fn22
		drop fn2
		* group
		gen group = 1 if fn21 == "tallw"
		replace group = 2 if fn21 == "cvdw"
		replace group = 3 if fn21 == "injuryw"
		replace group = 4 if fn21 == "pneumoniaw"

		sort fn1 group

		gen meanv = 0.062 if group == 1 & fn1 == "age1"
		replace meanv = 1.925 if group == 1 & fn1 == "age2"
		replace meanv = 6.737 if group == 1 & fn1 == "age3"

		replace meanv = 0.002 if group == 2 & fn1 == "age1"
		replace meanv = 0.682 if group == 2 & fn1 == "age2"
		replace meanv = 3.646 if group == 2 & fn1 == "age3"

		replace meanv = 0.014 if group == 3 & fn1 == "age1"
		replace meanv = 0.200 if group == 3 & fn1 == "age2"
		replace meanv = 0.262 if group == 3 & fn1 == "age3"

		replace meanv = 0.003 if group == 4 & fn1 == "age1"
		replace meanv = 0.018 if group == 4 & fn1 == "age2"
		replace meanv = 0.129 if group == 4 & fn1 == "age3"
		
		replace meanv = 8.721 if  fn1 == "allage.dta"



		foreach u of var estimate min95 max95{
			gen m_`u' = `u'/meanv 
			}
			*

		gen x1 = group+0.1
		gen x2 = group-0.1


		gen x3 = 5-group
		replace x3 = x3/2
		replace x3 = x3 - 0.08 if fn1 == "age1"
		replace x3 = x3 + 0.08 if fn1 == "age3"
		gen x4 = x3 +0.01
		gen x5 = 1-x4
		
		gen x= 13-_n
		drop if x == 9 | x == 10 | x == 11 | x == 5 
		
		replace x = 9 - _n
		replace x = 9 if x == 0
		
		gen maker1 = estimate
		format maker1 %9.2g
		
		
		
			graph twoway (rcap min95 max95 x, horizontal lcolor(red*1.5) lwidth(med)) ///
						(scatter x estimate, msymbol(O) mlcolor(red*1) mfcolor(red*0.6) msize(1.2) mlabel(maker1) mlabposition(11) mlabgap(*1.2) mlabsize(3)) ///
						,ysize(5) xsize(3) ///
						ylabel(0 " " 1 "8.Pneumonia (65+)" 2 "7.Injury (65+)" 3 "6.CVD (65+)" 4 "{it:5.All (65+)}" 5 "4.Injury (15-64)" 6 "3.CVD (15-64)" 7 "{it:2.All (15-64)}" ///
						8 "{it:1.All (0-14)}" 9 "{it:Baseline}" 9.5 " ", labsize(3.2) angle(0) nogrid) ///
						fysize(150) fxsize(75) ///
						xlabel( -.7 " " -.6 "-.6" -.4 "-.4" -.2 "-.2" 0 "0" 0.1 " ", nogrid) ///
						xline(0, lp(dash) lc(yellow*1.3) lwidth(thin)) ///
						title("A. Age-Specific Deaths, Number", pos(11) size(3.8) color(black)) ///
						ytitle("") ///
						text(0.7 -0.70  "({it:Mean = 0.129})", place(e) size(small)) ///
						text(1.7 -0.70  "({it:Mean = 0.262})", place(e) size(small)) ///
						text(2.7 -0.70  "({it:Mean = 3.646})", place(e) size(small)) ///
						text(3.7 -0.70  "({it:Mean = 6.737})", place(e) size(small)) ///
						text(4.7 -0.70  "({it:Mean = 0.200})", place(e) size(small)) ///
						text(5.7 -0.70  "({it:Mean = 0.682})", place(e) size(small)) ///
						text(6.7 -0.70  "({it:Mean = 1.925})", place(e) size(small)) ///
						text(7.7 -0.70  "({it:Mean = 0.062})", place(e) size(small)) ///
						text(8.7 -0.70  "({it:Mean = 8.721})", place(e) size(small)) ///
						yline(1, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(2, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(3, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(4, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(5, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(6, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(7, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(8, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(9, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						scheme(s1mono) ///
						legend(off) 

		
		
		graph save "$figures/figS5/figS5_panelA", replace 	
		
		gen maker2 = m_estimate * 100
		format maker2 %9.3g
		tostring maker2, replace usedisplayformat force
		replace maker2 = maker2+"%"
		
			graph twoway (rcap m_min95 m_max95 x, horizontal lcolor(blue*1.5) lwidth(med)) ///
						(scatter x m_estimate, msymbol(O) mlcolor(blue*1) mfcolor(blue*0.6) msize(1.2) mlabel(maker2) mlabposition(11) mlabgap(*1.2) mlabsize(3)) ///
						,ysize(5) xsize(3) ///
						ylabel(0 " " 9.5 " ", labsize(2.7) nogrid) ///
						fysize(150) fxsize(57.5) ///
						xlabel(-0.35 " " -0.3 "-.3" -0.2 "-.2" -0.1 "-.1" 0 "0" 0.1 "0.1", nogrid) ///
						xline(0, lp(dash) lc(yellow*1.3) lwidth(thin)) ///
						title("B. Age-Specific Deaths, Percentage", pos(11) size(3.8) color(black)) ///
						ytitle("") ///
						scheme(s1mono) ///
						yline(1, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(2, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(3, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(4, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(5, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(6, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(7, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(8, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(9, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						legend(off) 
						
		graph save "$figures/figS5/figS5_panelB", replace 
		
		
		graph combine "$figures/figS5/figS5_panelA" "$figures/figS5/figS5_panelB" , ///
				graphregion(fcolor(white) lcolor(white)) imargin(small) col(2) iscale(0.75) fysize(150) fxsize(120) xsize(8) ysize(6)
				
				
			
		graph save "$figures/figS5/figS5.gph", replace 
		graph export "$figures/allfig_eps/figS5.eps", replace
		graph export "$figures/allfig_png/figS5.png", replace

							
						
					
