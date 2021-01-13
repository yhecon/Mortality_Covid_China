******************************
*
* Fig 2: Baseline
*
******************************

	use "$master/y_x_daily.dta", clear
	
	
		keep if year == 2020
		drop if year == 2020 & month == 3 & day >= 15
		drop if citycode == 4201

		rename countycode dsp
		xtset dsp date

		replace other_all = other_all + mental + ckd + diabetes + inf_dis
		gen inter_c_t= ct

		label variable inter_c_t "Lockdown policy"
		label variable t_all "Total # of Deaths"
		label variable cvd "CVD"
		label variable injury "Injury"
		label variable pneumonia "Pneumonia"
		label variable res "Chronic Respiratory Diseases"
		label variable other_all "Other Causes"
		label variable cancer "Cancer"

		count if t_all != other_all + cvd + injury + pneumonia + res + cancer

		gen cvd_res = cvd+res
		reghdfe res inter_c_t if year == 2020, absorb(i.dsp i.date) vce(cluster dsp)
		sum cvd_res

		cap erase $results/fig2_tableS2/baseline.xml
		cap erase $results/fig2_tableS2/baseline.txt

		foreach i of varlist t_all cvd injury pneumonia cancer res other_all{
			qui reghdfe `i' inter_c_t if year == 2020, absorb(i.dsp i.date) vce(cluster dsp)
			outreg2 using $results/fig2_tableS2/baseline.xml, append se bracket dec(3) keep(inter_c_t) addnote("Notes: * significant at 10% ** significant at 5% *** significant at 1%. The standard errors clustered at the DSP level are reported below the estimates. Each cell in the table represents a separate DiD regression. All DSP counties are included in the analysis except 3 from Wuhan. The outcome variable is the number of daily deaths from the DSP counties without inclusion of death tolls for COVID-19. Mortality data used is between 1st Jan. and 14th Mar. 2020 and has been reported by each DSP county by 15th May. The explanatory variable is a dummy indicating whether a city where DSP belongs to enforced a lockdown policy on a particular date.") addtext(DSP Fixed Effect, "YES", Date Fixed Effect, "YES") addstat(Obs., e(N), Adjusted R-Square, e(r2_a),  # of DSP Counties, e(N_clust)) nocon nor2 noobs label cttop("Mean = `t_all_mean'") title("Table 1. The Impacts of City Lockdown on Deaths from Different Causes")
			parmest , saving($results/fig2_tableS2/baseline_`i'w.dta, replace)
		}
		*

********************************************************************************
		
		
* figure
		cd $results/fig2_tableS2
		openall, storefilename(fn)
		drop if parm == "_cons"
		split fn, p("_")
		split fn2, p(".")
		gen type = "log" if fn1 == "lbaseline"
		drop fn-fn3 fn22
		drop dof t p
		drop stderr

		* group
		gen group = 1 if fn21 == "t"
		replace group = 2 if fn21 == "cvdw"
		replace group = 3 if fn21 == "injuryw"
		replace group = 4 if fn21 == "pneumoniaw"
		replace group = 5 if fn21 == "cancerw"
		replace group = 6 if fn21 == "resw"
		replace group = 7 if fn21 == "other"
		sort type group
		replace type = "ab" if type == ""

		gen meanv = 8.721 if fn21 == "t"
		replace meanv = 4.330 if fn21 == "cvdw"
		replace meanv = 0.476 if fn21 == "injuryw"
		replace meanv = 0.150 if fn21 == "pneumoniaw"
		replace meanv = 1.944 if fn21 == "cancerw"
		replace meanv = 0.756 if fn21 == "resw"
		replace meanv = 1.066 if fn21 == "other"

		foreach u of var estimate min95 max95{
			gen m_`u' = `u'/meanv if type == "ab"
			}
			*

		
		gen maker1 = estimate
		format %4.3f maker1
		
		gen marker2 = round(m_estimate/0.00001)
		replace marker2 = round(marker2/1000, 0.001)
		format marker2 %9.3g
		tostring marker2, replace usedisplayformat force
		replace marker2 = marker2+"%"
		
		gen x = 8- _n

		graph twoway (rcap min95 max95 x, horizontal lcolor(red*1.2) lwidth(medthick)) ///
						(scatter x estimate, msymbol(O) mlcolor(red*1) mfcolor(red*0.6) msize(1.5) mlabel(maker1) mlabposition(11) mlabgap(*1.2) mlabsize(3)) ///
						,scheme(s1mono) ///
						legend(off) ///
						ysize(6) xsize(6) ///
						xline(0, lp(dash) lc(yellow*1.3) lwidth(thin)) ///
						ylabel(7.5 " " 7 `" "1.Total" "Deaths" "' 6 `" "2.CVD" "' 5 `" "3.Injury" "' 4 `" "4.Non-COVID-19" "Pneumonia" "' ///
							3 `" " " "5.Neoplasms" " " "' 2 `" "6.Chronic Respiratory" "Diseases" "' 1 `" "7.Other Causes" "' 0 " ",  labsize(3.2) angle(0) nogrid) ///
						ytitle("") ///
						title("Panel A. Impact on Deaths, Number", pos(11) size(3.5) color(black)) ///
						fysize(150) fxsize(75) ///
						text(6.7 -0.70  "({it:Mean = 8.721})", place(e) size(small)) ///
						text(5.7 -0.70  "({it:Mean = 4.330})", place(e) size(small)) ///
						text(4.7 -0.70  "({it:Mean = 0.476})", place(e) size(small)) ///
						text(3.7 -0.70  "({it:Mean = 0.150})", place(e) size(small)) ///
						text(2.7 -0.70  "({it:Mean = 1.944})", place(e) size(small)) ///
						text(1.7 -0.70  "({it:Mean = 0.756})", place(e) size(small)) ///
						text(0.7 -0.70  "({it:Mean = 1.066})", place(e) size(small)) ///
						yline(1, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(2, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(3, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(4, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(5, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(6, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(7, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						xlabel(-0.7 " " -0.6 "-0.6" -0.4 "-0.4" -0.2 "-0.2" 0 "0" 0.1 " ", nogrid)
						
						
		graph save "$figures/fig2/panelA", replace 					
							
				graph twoway (rcap m_min95 m_max95 x, horizontal lcolor(blue*1.2) lwidth(medthick)) ///
						(scatter x m_estimate, msymbol(O) mlcolor(blue*1) mfcolor(blue*0.6) msize(1.5) mlabel(marker2) mlabposition(11) mlabgap(*1.2) mlabsize(3)) ///
						,scheme(s1mono) ///
						legend(off) ///
						ysize(6) xsize(3.6) ///
						xline(0, lp(dash) lc(yellow*1.3) lwidth(thin)) ///
						ylabel(7.5 " " 0 " ",  nogrid) ///
						ytitle("") ///
						yscale(range(0.2 3.7)) ///						
						title("Panel B. Impact on Deaths, Percentage", pos(11) size(3.5) color(black)) ///
						fysize(150) fxsize(52.5) ///
						yline(1, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(2, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(3, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(4, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(5, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(6, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(7, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						xlabel(-0.3 "-30%" -0.2 "-20%" -0.1 "-10%" 0 "0" 0.05 " ", nogrid)
		
		graph save "$figures/fig2/panelB", replace
		
		

		graph combine "$figures/fig2/panelA" "$figures/fig2/panelB" , ///
				graphregion(fcolor(white) lcolor(white)) imargin(small) col(2) iscale(0.75) fysize(150) fxsize(140) xsize(8) ysize(6)
				
				
		graph save "$figures/fig2/fig2.gph", replace
		graph export "$figures/fig2.eps", replace
		graph export "$figures/fig2.png", replace



			
			
