

******************************
*
* Fig S5
*
******************************

	use "$master/y_x_daily.dta", clear
	
	
		drop if year == 2020 & month == 3 & day >= 15
		drop if year == 2019 & month == 4

		rename countycode dsp
		xtset dsp date

		gen inter_c_t1= ct

		foreach i of varlist confirmed temmean rhumean prsmean winsmean pm25 movein moveout mig hospital_bed hospital gdppc primary_ratio secondary_ratio tertiary_ratio{

		bysort year provcode: egen `i'_provmean = mean(`i')
		replace `i' = `i'_provmean if `i' == .

		}

		label variable inter_c_t1 "Lockdown policy"
		label variable t_all "Total"
		label variable cvd "CVD"
		label variable injury "Injury"
		label variable pneumonia "Pneumonia"

		gen month_day = month * 2 + day
		gen gdppc_date = gdppc * month_day
		gen gdppc_date2 = gdppc * date * month_day * month_day
		gen gdppc_date3 = gdppc * date * month_day * month_day * month_day
		gen hospital_bed_date = hospital_bed * month_day
		gen hospital_bed_date2 = hospital_bed * date * month_day * month_day
		gen hospital_bed_date3 = hospital_bed * date * month_day * month_day * month_day
		gen pop_total_date = pop_total * month_day
		gen pop_total_date2 = pop_total * month_day * month_day
		gen pop_total_date3 = pop_total * month_day * month_day * month_day
		
				
		gen group1t = 1 if lockdown_t == 1 & c12t != 1 & c12 == 1
		replace group1t = 0 if group1t == .
		gen group2t = 1 if c12t == 1
		replace group2t = 0 if group2t == .
		
				
		bysort month_day dsp: egen ct_2019 = sum(ct)
		bysort dsp: egen dsp_sum = sum(ct_2019)
		replace ct_2019 = 1 if dsp_sum == 1 & ct_2019 == .
		replace ct_2019 = 0 if dsp_sum == 0 & ct_2019 == .

		gen inter_c_t5= ct_2019
		
		gen all = t_all
		
		
		cap erase $results/figS5_tableS10/tableS10.txt
		cap erase $results/figS5_tableS10/tableS10.xml
		
		
	foreach i of varlist all cvd injury pneumonia{
		
		* baseline
		reghdfe `i' inter_c_t1 if year == 2020 & citycode != 4201, absorb(i.dsp i.date) vce(cluster dsp)
			parmest , saving($results/figS5_tableS10/figS5_R0_`i'.dta, replace)
			outreg2 using $results/figS5_tableS10/tableS10.xml, append auto(3) dec(3)
		
		* weather
		reghdfe `i' inter_c_t1 temmean rhumean prsmean winsmean if year == 2020 & citycode != 4201, absorb(i.dsp i.date) vce(cluster dsp)
			parmest , saving($results/figS5_tableS10/figS5_R1_`i'.dta, replace)
			outreg2 using $results/figS5_tableS10/tableS10.xml, append auto(3) dec(3)
		
		* socio economic status
		reghdfe `i' inter_c_t1 temmean rhumean prsmean winsmean gdppc_date gdppc_date2 gdppc_date3 hospital_bed_date hospital_bed_date2 hospital_bed_date3 pop_total_date pop_total_date2 pop_total_date3 if year == 2020 & citycode != 4201, absorb(i.dsp i.date) vce(cluster dsp)
			parmest , saving($results/figS5_tableS10/figS5_R2_`i'.dta, replace)
			outreg2 using $results/figS5_tableS10/tableS10.xml, append auto(3) dec(3)
		
		* population weighted
		reghdfe `i' inter_c_t1 if year == 2020 & citycode != 4201 [w=pop_total], absorb(i.dsp i.date) vce(cluster dsp)
			parmest , saving($results/figS5_tableS10/figS5_R3_`i'.dta, replace)
			outreg2 using $results/figS5_tableS10/tableS10.xml, append auto(3) dec(3)
		
		* Drop Hubei
		reghdfe `i' inter_c_t1 if year == 2020 & provcode != 42, absorb(i.dsp i.date) vce(cluster dsp)
			parmest , saving($results/figS5_tableS10/figS5_R4_`i'.dta, replace)
			outreg2 using $results/figS5_tableS10/tableS10.xml, append auto(3) dec(3)
			
		* include Wuhan
		reghdfe `i' inter_c_t1 if year == 2020, absorb(i.dsp i.date) vce(cluster dsp)
			parmest , saving($results/figS5_tableS10/figS5_R5_`i'.dta, replace)
			outreg2 using $results/figS5_tableS10/tableS10.xml, append auto(3) dec(3)
			
			}
			*
		
		
		
********************************************************************************

* figure

		cd $results/figS5_tableS10
		openall, storefilename(fn)
		drop if parm == "_cons"
		keep if parm == "inter_c_t5" | parm == "inter_c_t1" 
		
		split fn, p("_")		
		egen group = group(fn3)
		
		split fn2,p("r")
		
		drop fn fn1 fn2 fn21
		
		
		******
		
		preserve
		keep if group == 1
		
		destring fn22, generate(x)
		replace x = x + 1	
				
		graph twoway (rcap min95 max95 x if x == 1,vertical lcolor(blue*1.5) lwidth(med)) ///
					(rcap min95 max95 x if x != 1 & x != 7,vertical lcolor(red*1.5) lwidth(med)) ///
					(scatter estimate x if x == 1, msymbol(O) mlcolor(blue*1) mfcolor(blue*0.6) msize(1.2)) ///
					(scatter estimate x if x != 1 & x != 7, msymbol(O) mlcolor(red*1) mfcolor(red*0.6) msize(1.2)) ///
						,ylabel(0.15 "          ." 0 "0" -0.2 "-0.2" -0.4 "-0.4" -0.6 "-0.6" -0.8 "-0.8", nogrid) ///
						ysize(1) xsize(1.5) ///
						xlabel(0.5 " " 1 "R0" 2 "R1" 3 "R2" 4 "R3" 5 "R4" 6 "R5" 6.5 "          .", nogrid) ///
						yline(0, lp(dash) lc(gray) lwidth(thin)) ///
						title("A. Non-Covid-19 All Cause Deaths", pos(11) size() color(black)) ///
						xtitle("") ///
 						ytitle("") ///
						scheme(plotplain) ///
						legend(off) 
						
		graph save $figures/figS5/figS5_panelA, replace 	
						
		restore
		
		
		******
		
		preserve
		keep if group == 2
		
		destring fn22, generate(x)
		replace x = x + 1	
				
		graph twoway (rcap min95 max95 x if x == 1,vertical lcolor(blue*1.5) lwidth(med)) ///
					(rcap min95 max95 x if x != 1 & x != 7,vertical lcolor(red*1.5) lwidth(med)) ///
					(scatter estimate x if x == 1, msymbol(O) mlcolor(blue*1) mfcolor(blue*0.6) msize(1.2)) ///
					(scatter estimate x if x != 1 & x != 7, msymbol(O) mlcolor(red*1) mfcolor(red*0.6) msize(1.2)) ///
						,ylabel(-0.6 "-0.6" -0.4 "-0.4" -0.2 "-0.2" 0 "0" 0.2 "0.2" 0.3 "          .", nogrid) ///
						ysize(1) xsize(1.5) ///
						xlabel(0.5 " " 1 "R0" 2 "R1" 3 "R2" 4 "R3" 5 "R4" 6 "R5" 6.5 "          .", nogrid) ///
						yline(0, lp(dash) lc(gray) lwidth(thin)) ///
						title("B. CVD", pos(11) size() color(black)) ///
						xtitle("") ///
 						ytitle("") ///
						scheme(plotplain) ///
						legend(off) 
						
		graph save $figures/figS5/figS5_panelB, replace 
		
		restore
			
		******
		
		preserve
		keep if group == 3
		
		destring fn22, generate(x)
		replace x = x + 1	
									
		graph twoway (rcap min95 max95 x if x == 1,vertical lcolor(blue*1.5) lwidth(med)) ///
					(rcap min95 max95 x if x != 1 & x != 7,vertical lcolor(red*1.5) lwidth(med)) ///
					(scatter estimate x if x == 1, msymbol(O) mlcolor(blue*1) mfcolor(blue*0.6) msize(1.2)) ///
					(scatter estimate x if x != 1 & x != 7, msymbol(O) mlcolor(red*1) mfcolor(red*0.6) msize(1.2)) ///
						,ylabel(-0.1 "          ." -0.075 "-.075" -0.05 "-.05" -0.025 "-.025" 0 "0" 0.025 "0.025", nogrid) ///
						ysize(1) xsize(1.5) ///
						xlabel(0.5 " " 1 "R0" 2 "R1" 3 "R2" 4 "R3" 5 "R4" 6 "R5" 6.5 "          .", nogrid) ///
						yline(0, lp(dash) lc(gray) lwidth(thin)) ///
						title("C. Injury", pos(11) size() color(black)) ///
						xtitle("") ///
 						ytitle("") ///
						scheme(plotplain) ///
						legend(off) 
						
		graph save $figures/figS5/figS5_panelC, replace 	
						
		restore
		
		******
		
		preserve
		keep if group == 4
		
		destring fn22, generate(x)
		replace x = x + 1	
					
		graph twoway (rcap min95 max95 x if x == 1,vertical lcolor(blue*1.5) lwidth(med)) ///
					(rcap min95 max95 x if x != 1 & x != 7,vertical lcolor(red*1.5) lwidth(med)) ///
					(scatter estimate x if x == 1, msymbol(O) mlcolor(blue*1) mfcolor(blue*0.6) msize(1.2)) ///
					(scatter estimate x if x != 1 & x != 7, msymbol(O) mlcolor(red*1) mfcolor(red*0.6) msize(1.2)) ///
						,ylabel(-.075 "          ." -.05 "-0.05" 0 "0" .05 "0.05" .1 "0.1" .15 "0.15" .175 " ", nogrid) ///
						ysize(1) xsize(1.5) ///
						xlabel(0.5 " " 1 "R0" 2 "R1" 3 "R2" 4 "R3" 5 "R4" 6 "R5" 6.5 "          .", nogrid) ///
						yline(0, lp(dash) lc(gray) lwidth(thin)) ///
						title("D. Pneumonia", pos(11) size() color(black)) ///
						xtitle("") ///
 						ytitle("") ///
						scheme(plotplain) ///
						legend(off) 
						
		graph save $figures/figS5/figS5_panelD, replace 
		
		
		graph combine "$figures/figS5/figS5_panelA.gph" "$figures/figS5/figS5_panelB.gph" , ///
				graphregion(fcolor(white) lcolor(white)) imargin(small) col(2) iscale(0.75) 
				
			graph save "$figures/figS5/figS5_panelA_B.gph", replace
			
		graph combine "$figures/figS5/figS5_panelC.gph" "$figures/figS5/figS5_panelD.gph" , ///
				graphregion(fcolor(white) lcolor(white)) imargin(small) col(2) iscale(0.75) 
				
			graph save "$figures/figS5/figS5_panelC_D.gph", replace
			
			
		graph combine "$figures/figS5/figS5_panelA_B.gph" "$figures/figS5/figS5_panelC_D.gph" , ///
				graphregion(fcolor(white) lcolor(white)) imargin(small) row(2) iscale(0.98) ysize(4.5) xsize(6)
				
		graph save "$figures/figS5/figS5.gph", replace
		graph export "$figures/figS5.eps", replace
		graph export "$figures/figS5.png", replace	 
									
			
				
*******************************************

	
	* estimate
	
		use "$master/y_x_daily.dta", clear
		
		drop if year == 2020 & month == 3 & day >= 15
		drop if year == 2019 & (month == 3 & day >= 31) | month == 4
		drop if citycode == 4201

		rename countycode dsp
		xtset dsp date

		gen inter_c_t1= ct
		
		label variable inter_c_t1 "Lockdown policy"
		label variable t_all "Total"
		label variable cvd "CVD"
		label variable injury "Injury"
		label variable pneumonia "Pneumonia"
		
		gen group1t = 1 if lockdown_t == 1 & c12t != 1 & c12 == 1
		replace group1t = 0 if group1t == .
		gen group2t = 1 if c12t == 1
		replace group2t = 0 if group2t == .
							
	foreach i of varlist t_all cvd injury pneumonia{		
		
		reghdfe `i' group1t group2t if year == 2020, absorb(i.dsp i.date) vce(cluster dsp)
			outreg2 using $results/figS5_tableS10/tableS10.xml, append auto(3) dec(3)
			}
			
		
				
		* placebo
		
		
		use "$master/y_x_daily.dta", clear
		
		drop if citycode == 4201
		rename countycode dsp
		xtset dsp date

		drop if year == 2020 & month == 3 & day >= 15
		drop if year == 2019 & (month == 3 & day >= 31) | month == 4

		foreach i of varlist confirmed temmean rhumean prsmean winsmean pm25 movein moveout mig hospital_bed hospital gdppc primary_ratio secondary_ratio tertiary_ratio{

		bysort year provcode: egen `i'_provmean = mean(`i')
		replace `i' = `i'_provmean if `i' == .

		}

		gen month_day = month * 100 + day
		bysort month_day dsp: egen ct_2019 = sum(ct)
		replace ct = ct_2019
		bysort dsp: egen dsp_sum = sum(ct_2019)
		replace ct_2019 = 1 if dsp_sum == 1 & ct_2019 == .
		replace ct_2019 = 0 if dsp_sum == 0 & ct_2019 == .

		gen inter_c_t5= ct

		lab variable inter_c_t5 "Lockdown policy"
		label variable t_all "Total"
		label variable cvd "CVD"
		label variable injury "Injury"
		label variable pneumonia "Pneumonia"

		keep if year == 2019

		foreach i of varlist t_all cvd injury pneumonia{
			reghdfe `i' inter_c_t5 temmean rhumean prsmean winsmean, absorb(i.dsp i.date) vce(cluster dsp)
					outreg2 using $results/figS5_tableS10/tableS10.xml, append auto(3) dec(3)
					}

		
