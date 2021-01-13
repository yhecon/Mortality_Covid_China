
******************************
*
* Fig 4 & Table S5-S8: Heterogeneity
*
******************************


	use "$master/y_x_daily.dta", clear
		
		drop if year == 2020 & month == 3 & day >= 15
		drop if year == 2019 & (month == 3 & day >= 31) | (month == 4)
		drop if citycode == 4201
		
		gen inter_c_t= ct

		foreach i of varlist t_all cvd injury pneumonia{
			gen `i'_2019 = `i' if year == 2019
			replace `i'_2019 = 0 if `i'_2019 == .
			bysort countycode: egen `i'_2019_ = sum(`i'_2019)
			replace `i'_2019 = `i'_2019_
			replace `i'_2019 = `i'_2019 / pop_total * 365000
			egen `i'_2019_mean = mean(`i'_2019)
			replace `i'_2019 = `i'_2019 - `i'_2019_mean
			drop `i'_2019_
			gen ct_`i' = ct * `i'_2019
		}
		*
		
		sort countycode date
		rename countycode dsp
		
		xtset dsp date

		foreach i of varlist pm25 hospital_bed gdppc primary_ratio secondary_ratio tertiary_ratio{
			bysort year provcode: egen `i'_provmean = mean(`i')
			replace `i' = `i'_provmean if `i' == .
		}
		*


		foreach i of varlist pm25 hospital_bed gdppc primary_ratio secondary_ratio tertiary_ratio{
			cap drop `i'_2019
			gen `i'_2019 = `i' if year == 2019
			bysort dsp: egen `i'_2019_mean = mean(`i'_2019)
			replace `i' = `i'_2019_mean
			drop `i'_2019
		}
		*

		foreach i of varlist pm25 hospital_bed gdppc primary_ratio secondary_ratio tertiary_ratio{
			egen `i'_mean = mean(`i')
			replace `i' = `i' - `i'_mean
		}
		*

		replace gdppc = gdppc / 10000 //per 10,000 RMB
		gen ct_gdppc = ct * gdppc
		replace pop_total = pop_total / 10000 //per ten thousand people
		replace hospital_bed = hospital_bed * 1000
		gen ct_hospital_bed = ct * hospital_bed
		gen ct_pm25 = ct * pm25
		replace secondary_ratio = secondary_ratio * 100 //%
		gen ct_secondary_ratio = ct * secondary_ratio

		label variable inter_c_t "Lockdown policy"
		label variable ct_gdppc "Lockdown*GDP per capita"
		label variable ct_hospital_bed "Lockdown*hospital beds per capita"
		label variable ct_pm25 "Lockdown*PM2.5 concentration"
		label variable cvd "CVD"
		label variable ct_injury "Lockdown*2019 injury mortality rate"
		label variable ct_t_all "Lockdown*2019 total mortality rate"
		label variable ct_injury "Lockdown*2019 injury mortality rate"
		label variable ct_secondary_ratio "Lockdown*share of employment in secondary industry"

		

		foreach i of varlist t_all cvd injury pneumonia{
		reghdfe `i' inter_c_t ct_gdppc if year == 2020, absorb(i.dsp i.date) vce(cluster dsp)
			parmest, saving($results/fig4_tableS5_S8/hete_`i'__gdppc.dta, replace) 
			outreg2 using $results/fig4_tableS5_S8/hete_`i'.xls, replace se bracket dec(3) ///
			keep(inter_c_t ct_gdppc) ///
			addnote("Notes: * significant at 10% ** significant at 5% *** significant at 1%. The standard errors clustered at the DSP level are reported below the estimates. Each cell in the table represents a separate DiD regression. All DSP counties are included in the analysis except 3 from Wuhan. The outcome variable is the number of daily deaths from the DSP counties without inclusion of death tolls for COVID-19. Mortality data used is between 1st Jan. and 14th Mar. 2020 and has been reported by each DSP county by 15th May. The city/community lockdown dummy is interacted with some time invariant control variables at the DSP county level. The GDP per capita and the number of hospital bed per capita was mainly based on 2018 data. The PM2.5 Concentration is the annual mean of PM2.5 concentration in a county in 2019. The 2019 Mortality Rate is the annual thousand-people mortality rate of a county in 2019. All of the control variables are taken logarithm and then subtracted by the logarithmic form of overall mean of 602 DPS counties in 2019.") ///
			addtext(DSP Fixed Effect, "YES", Date Fixed Effect, "YES") ///
			addstat(Obs., e(N), Adjusted R-Square, e(r2_a),  # of DSP Counties, e(N_clust)) ///
			nocon nor2 noobs label ///
			title("Table 2. The Heterogeneous Impacts of City Lockdown on Deaths") ///
			ctitle(" ")

		reghdfe `i' inter_c_t ct_hospital_bed if year == 2020, absorb(i.dsp i.date) vce(cluster dsp)
			parmest, saving($results/fig4_tableS5_S8/hete_`i'__hospital_bed.dta, replace) 
			outreg2 using $results/fig4_tableS5_S8/hete_`i'.xls, append se bracket dec(3) ///
			keep(inter_c_t ct_hospital_bed) ///
			addtext(DSP Fixed Effect, "YES", Date Fixed Effect, "YES") ///
			addstat(Obs., e(N), Adjusted R-Square, e(r2_a),  # of DSP Counties, e(N_clust)) ///
			nocon nor2 noobs label ///
			ctitle(" ")

		reghdfe `i' inter_c_t ct_pm25 if year == 2020, absorb(i.dsp i.date) vce(cluster dsp)
			parmest, saving($results/fig4_tableS5_S8/hete_`i'__pm25.dta, replace) 
			outreg2 using $results/fig4_tableS5_S8/hete_`i'.xls, append se bracket dec(3)  ///
			keep(inter_c_t ct_pm25) ///
			addtext(DSP Fixed Effect, "YES", Date Fixed Effect, "YES") ///
			addstat(Obs., e(N), Adjusted R-Square, e(r2_a),  # of DSP Counties, e(N_clust)) ///
			nocon nor2 noobs label ///
			ctitle(" ")

		reghdfe `i' inter_c_t ct_secondary_ratio if year == 2020, absorb(i.dsp i.date) vce(cluster dsp)
			parmest, saving($results/fig4_tableS5_S8/hete_`i'__secondary_ratio.dta, replace) 
			outreg2 using $results/fig4_tableS5_S8/hete_`i'.xls, append se bracket dec(3) ///
			keep(inter_c_t ct_secondary_ratio) ///
			addtext(DSP Fixed Effect, "YES", Date Fixed Effect, "YES") ///
			addstat(Obs., e(N), Adjusted R-Square, e(r2_a),  # of DSP Counties, e(N_clust)) ///
			nocon nor2 noobs label ///
			ctitle(" ")

		reghdfe `i' inter_c_t ct_`i' if year == 2020, absorb(i.dsp i.date) vce(cluster dsp)
			parmest, saving($results/fig4_tableS5_S8/hete_`i'__`i'.dta, replace) 
			outreg2 using $results/fig4_tableS5_S8/hete_`i'.xls, append se bracket dec(3) ///
			keep(inter_c_t ct_`i') ///
			addtext(DSP Fixed Effect, "YES", Date Fixed Effect, "YES") ///
			addstat(Obs., e(N), Adjusted R-Square, e(r2_a),  # of DSP Counties, e(N_clust)) ///
			nocon nor2 noobs label ///
			ctitle(" ")

		reghdfe `i' inter_c_t ct_gdppc ct_hospital_bed ct_pm25 ct_secondary_ratio ct_`i' if year == 2020, absorb(i.dsp i.date) vce(cluster dsp)
			outreg2 using $results/fig4_tableS5_S8/hete_`i'.xls, append se bracket dec(3) ///
			keep(inter_c_t ct_gdppc ct_hospital_bed ct_pm25 ct_secondary_ratio ct_`i') ///
			addtext(DSP Fixed Effect, "YES", Date Fixed Effect, "YES") ///
			addstat(Obs., e(N), Adjusted R-Square, e(r2_a),  # of DSP Counties, e(N_clust)) ///
			nocon nor2 noobs label ///
			ctitle(" ")
		}


********************************************************************************

* getting sd above/below the mean
		
		
		tempname get
		cap erase $results/fig4_tableS5_S8/figdata.dta

		cap erase $results/fig4_tableS5_S8/figdata.dta
		postutil clear
		postfile `get' str20 x str20 y sd estimate ster p min95 max95 using $results/fig4_tableS5_S8/figdata.dta

		foreach i of varlist t_all cvd injury pneumonia{
			reghdfe `i' inter_c_t if year == 2020, absorb(i.dsp i.date) vce(cluster dsp)
			lincom inter_c_t+0
			post `get' ("`i'") ("`i'") (r(estimate)) (r(estimate)) (r(se)) (r(p)) (r(lb)) (r(ub)) 
		}
		*

		foreach i of varlist t_all cvd injury pneumonia{
			foreach u of var ct_gdppc ct_hospital_bed ct_pm25 ct_secondary_ratio ct_`i'{

			sum `u'
			local sd_ct = r(sd)

			reghdfe `i' inter_c_t `u' if year == 2020, absorb(i.dsp i.date) vce(cluster dsp)
			lincom inter_c_t + `sd_ct'*`u'
			post `get' ("`i'") ("`u'") (`sd_ct') (r(estimate)) (r(se)) (r(p)) (r(lb)) (r(ub)) 

			lincom inter_c_t - `sd_ct'*`u'
			post `get' ("`i'") ("`u'") (`sd_ct') (r(estimate)) (r(se)) (r(p)) (r(lb)) (r(ub))
		}
		}
		*


			postclose `get'
			
		

********************************************************************************

* creating figure
			
		clear
		cd  $results/fig4_tableS5_S8
		
		use figdata.dta
		gen dup = _n

		replace y = "base" if x == y

		gen dup2 = mod(dup,2)
		replace dup2 =. if y == "base"
		gen type = "+SD" if dup2 == 1
		replace type = "-SD" if dup2 == 0

		*
		preserve 
		keep if x == "t_all"
		gen sc = _n
		replace sc = sc + dup2
		replace sc = (sc+1)
		replace sc = 17-sc
		replace sc = sc-0.3 if dup2 == 0
		replace sc = sc+0.3 if dup2 == 1
		replace sc = 15 if dup == 1
		replace sc = sc-4		
		
		graph twoway (rcap max95 min95 sc if sc == 11, horizontal  lcolor(blue*1.2) lwidth(med)) ///
					(rcap max95 min95 sc if sc != 11 , horizontal  lcolor(red*1.2) lwidth(med)) ///
				(scatter sc estimate if sc == 11, msymbol(O) mlcolor(blue*1) mfcolor(blue*0.6) msize(1.2)) ///	
				(scatter sc estimate if sc != 11, msymbol(O) mlcolor(red*1) mfcolor(red*0.6) msize(1.2)) ///	
				,scheme(s1mono) ///
				legend(off) ///
				ytitle("") ///
				xline(-0.429,lp(dash) lc(blue*0.4) lwidth(thin)) ///
				xline(0,lp(dash) lc(yellow*1.3) lwidth(thin)) ///
				ylabel(11 "Baseline Estimates" ///
						9.3 "per capita GDP (+SD)" ///
						8.7 "per capita GDP (-SD)" ///
						7.3 "# of Hospital Beds (+SD)" ///
						6.7 "# of Hospital Beds (-SD)" ///
						5.3	"Initial PM{sub:2.5} Concentration (+SD)" ///
						4.7	"Initial PM{sub:2.5} Concentration (-SD)" ///
						3.3	"Share of Employment in Manufacturing Industry (+SD)" ///
						2.7	"Share of Employment in Manufacturing Industry (-SD)" ///
						1.3	"Deaths in 2019 (+SD)" ///
						0.7	"Deaths in 2019 (-SD)" , angle(0) labsize(*0.7)) ///
				title("Total Deaths",  pos(11) size(*0.6) color(black))  ///
				xlabel(,labsize(*0.6)) xsize(5) ysize(5) fxsize(120) fysize(100)
				
		graph save "$figures/fig4_figS3/fig4.gph", replace
		
		graph export "$figures/fig4.eps", replace
		graph export "$figures/fig4.png", replace		
	
		restore		


		*
		preserve 
		keep if x == "cvd"
		gen sc = _n
		replace sc = sc + dup2
		replace sc = (sc+1)
		replace sc = 17-sc
		replace sc = sc-0.3 if dup2 == 0
		replace sc = sc+0.3 if dup2 == 1
		replace sc = 15 if dup == 2
		replace sc = sc-4
		graph twoway (rcap max95 min95 sc if sc == 11, horizontal  lcolor(blue*1.2) lwidth(med)) ///
					(rcap max95 min95 sc if sc != 11 , horizontal  lcolor(red*1.2) lwidth(med)) ///
				(scatter sc estimate if sc == 11, msymbol(O) mlcolor(blue*1) mfcolor(blue*0.6) msize(1.2)) ///	
				(scatter sc estimate if sc != 11, msymbol(O) mlcolor(red*1) mfcolor(red*0.6) msize(1.2)) ///	
				,scheme(s1mono) ///
				legend(off) ///
				ytitle("") ///
				xlabel(-.5 "-.5" -0.4 "-.4" -0.3 "-.3" -0.2 "-.2" -0.1 "-.1" 0 "0" 0.05 " ", nogrid) ///
				xline(-0.27,lp(dash) lc(blue*0.4) lwidth(thin)) ///
				xline(0,lp(dash) lc(yellow*1.3) lwidth(thin)) ///
				ylabel(11 "Baseline Estimates" ///
						9.3 "per capita GDP (+SD)" ///
						8.7 "per capita GDP (-SD)" ///
						7.3 "# of Hospital Beds (+SD)" ///
						6.7 "# of Hospital Beds (-SD)" ///
						5.3	"Initial PM{sub:2.5} Concentration (+SD)" ///
						4.7	"Initial PM{sub:2.5} Concentration (-SD)" ///
						3.3	"Share of Employment in Manufacturing Industry (+SD)" ///
						2.7	"Share of Employment in Manufacturing Industry (-SD)" ///
						1.3	"Deaths in 2019 (+SD)" ///
						0.7	"Deaths in 2019 (-SD)" , angle(0) labsize(*0.7)) ///
				title("Panel A. CVD",  pos(11) size(*0.6) color(black))  ///
				xlabel(,labsize(*0.6)) xsize(4) ysize(5) fxsize(161) fysize(100)
				
		graph save "$figures/fig4_figS3/figS3_panelA.gph", replace
		restore	

		preserve 
		keep if x == "injury"
		gen sc = _n
		replace sc = sc + dup2
		replace sc = (sc+1)
		replace sc = 17-sc
		replace sc = sc-0.3 if dup2 == 0
		replace sc = sc+0.3 if dup2 == 1
		replace sc = 15 if dup == 3
		replace sc = sc-4
		graph twoway (rcap max95 min95 sc if sc == 11, horizontal  lcolor(blue*1.2) lwidth(med)) ///
					(rcap max95 min95 sc if sc != 11 , horizontal  lcolor(red*1.2) lwidth(med)) ///
				(scatter sc estimate if sc == 11, msymbol(O) mlcolor(blue*1) mfcolor(blue*0.6) msize(1.2)) ///	
				(scatter sc estimate if sc != 11, msymbol(O) mlcolor(red*1) mfcolor(red*0.6) msize(1.2)) ///	
				,scheme(s1mono) ///
				legend(off) ///
				ytitle("") ///
				ylabel("") ///
				xline(-0.044,lp(dash) lc(blue*0.4) lwidth(thin)) ///
				xline(0,lp(dash) lc(yellow*1.3) lwidth(thin)) ///
				title("Panel B. Injury",  pos(11) size(*0.6) color(black))  ///
				xlabel(,labsize(*0.6)) xsize(4) ysize(5) fxsize(50) fysize(100)
				
		graph save "$figures/fig4_figS3/figS3_panelB.gph", replace
		restore	

		preserve 
		keep if x == "pneumonia"
		gen sc = _n
		replace sc = sc + dup2
		replace sc = (sc+1)
		replace sc = 17-sc
		replace sc = sc-0.3 if dup2 == 0
		replace sc = sc+0.3 if dup2 == 1
		replace sc = 15 if dup == 4
		replace sc = sc-4
		graph twoway (rcap max95 min95 sc if sc == 11, horizontal  lcolor(blue*1.2) lwidth(med)) ///
					(rcap max95 min95 sc if sc != 11 , horizontal  lcolor(red*1.2) lwidth(med)) ///
				(scatter sc estimate if sc == 11, msymbol(O) mlcolor(blue*1) mfcolor(blue*0.6) msize(1.2)) ///	
				(scatter sc estimate if sc != 11, msymbol(O) mlcolor(red*1) mfcolor(red*0.6) msize(1.2)) ///	
				,scheme(s1mono) ///
				legend(off) ///
				ytitle("") ///
				ylabel("") ///
				xline(-0.022,lp(dash) lc(blue*0.4) lwidth(thin)) ///
				xline(0,lp(dash) lc(yellow*1.3) lwidth(thin)) ///
				title("Panel C. Pneumonia",  pos(11) size(*0.6) color(black))  ///
				xlabel(,labsize(*0.6)) xsize(4) ysize(5) fxsize(50) fysize(100)
				
		graph save "$figures/fig4_figS3/figS3_panelC.gph", replace
		restore	
		
		
		graph combine "$figures/fig4_figS3/figS3_panelA.gph" "$figures/fig4_figS3/figS3_panelB.gph" "$figures/fig4_figS3/figS3_panelC.gph", graphregion(fcolor(white) lcolor(white)) imargin(small) col(3) iscale(0.85)  xsize(8) ysize(6)
			
		graph export "$figures/figS3.eps", replace
		graph export "$figures/figS3.png", replace		
	
