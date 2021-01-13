
******************************
*
* Fig 2: Back of the Envelope Calculation
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

		reghdfe t_all inter_c_t if year == 2020, absorb(i.dsp i.date, savefe) vce(cluster dsp)
		predictnl yhat = _b[inter_c_t] * inter_c_t + _b[_cons] + __hdfe1__  + __hdfe2__
		predictnl yhat_cf = _b[inter_c_t] * 0 + _b[_cons] + __hdfe1__  + __hdfe2__
				
	* create lockdown numbers
	
		gen startld = 1 if l.inter_c_t == 0 & inter_c_t == 1
		replace startld = 0 if startld == .
		
		egen totalld = sum(inter_c_t) ,by(date)
	
	
	* graph
	
		collapse (mean) yhat yhat_cf t_all totalld (sum) startld, by(date)
		
		drop if date < 21930
				
		format date %td
							
			
		graph twoway (bar totalld date, lcolor(white) fcolor(gray*0.2) yaxis(2)) ///
			(line yhat date, lcolor(red*1.5) lpattern(shortdash) yaxis(1) yscale(alt) yscale(alt axis(2))) (line yhat_cf date, lpattern(dash) lcolor(blue*1.5) yaxis(1))  ///
			(scatter t_all date, mlcolor(red) mstyle(circle) msize(0.6) yaxis(1)) ///
			,xlabel(21929 "15jan" 21937 "23jan" 21955 "10feb" 21975 "01mar" 21988 "14mar" 21990 " ",nogrid) ///
			ylabel(6.5 " " 7 "7" 8 "8" 9 "9" 10 "10" 11 "11" 12 "12" 12.5 " " , nogrid axis(1)) ///
			ylabel(none, nogrid axis(2)) ///
			legend(order (2 3 4 1) label(1 "cumulative % of lockdowns") label(2 "Predicted with Lockdowns") label(3 "Predicted without Lockdowns") label(4 "Observed Deaths")  ring(0) pos(11) size(2.4)) ///
			title("Panel A: Estimated DSP Level Daily Mean Deaths", position(11) size(4)) ///
			ytitle("Daily Mean Deaths in Each DSP") ytitle("", axis(2)) ///
			xtitle("") ///
			scheme(plotplain)
			
		graph save "$figures/fig5/panelA", replace 	
			


	
	*************************************
	
		use "$master/y_x_daily.dta", clear
		
		* estimation
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
			
			foreach i of varlist t_all cvd injury pneumonia cancer res other_all{
				reghdfe `i' inter_c_t if year == 2020, absorb(i.dsp i.date, savefe) vce(cluster dsp)
				
				predictnl yhat_`i' = _b[inter_c_t] * inter_c_t + _b[_cons] + __hdfe1__  + __hdfe2__
				predictnl yhat_`i'_cf = _b[inter_c_t] * 0 + _b[_cons] + __hdfe1__  + __hdfe2__
			}
			
			
		* graph
		
			local yhat = "yhat_t_all yhat_t_all_cf yhat_cvd yhat_cvd_cf yhat_injury yhat_injury_cf yhat_pneumonia yhat_pneumonia_cf yhat_cancer yhat_cancer_cf yhat_res yhat_res_cf yhat_other_all yhat_other_all_cf"
		
			collapse (sum) `yhat', by(date)
			drop if date < 21930
			
			foreach i of varlist yhat_t_all yhat_cvd yhat_injury yhat_pneumonia yhat_cancer yhat_res yhat_other_all {
				gen dif_`i' = `i' - `i'_cf
				gen saved_`i' = dif_`i' * 1160757376 / 290830016
			}	
			
			sort date
			gen saved_all = sum(saved_yhat_t_all)
			gen saved_cvd = sum(saved_yhat_cvd)
			gen saved_injury = sum(saved_yhat_injury)
			gen saved_pneumonia = sum(saved_yhat_pneumonia)
			gen saved_res = sum(saved_yhat_res)
			gen saved_cancer = sum(saved_yhat_cancer)
			gen saved_other_all = sum(saved_yhat_other_all)
			
			gen graph_cvd = saved_cvd
			gen graph_injury = graph_cvd + saved_injury
			gen graph_pneumonia = graph_injury + saved_pneumonia
			gen graph_res = graph_pneumonia + saved_res
			gen graph_cancer = graph_res + saved_cancer
			gen graph_other_all = graph_cancer + saved_other_all
			
			local c1 = "127 201 127"
            local c2 = "190 174 212"
            local c3 = "253 192 134"
            local c4 = "255 255 153"
            local c5 = "56 108 176"
            local c6 = "240 2 127"
            local c7 = "191 91 23"
            local c8 = "102 102 102"

			
			graph twoway (area graph_other_all date, fcolor("127 201 127") lcolor(white) ) ///
				(area graph_cancer date, fcolor(purple*0.4) lcolor(white) ) ///
				(area graph_res date, fcolor("253 192 134") lcolor(white) ) ///
				(area graph_pneumonia date, fcolor(red*0.5) lcolor(white) ) ///
				(area graph_injury date, fcolor("255 255 153") lcolor(white) ) ///
				(area graph_cvd date, fcolor(blue*0.4) lcolor(white) ) ///			
				, legend(order (6 5 4 3 2 1) label(1 "Others") label(2 "Cancer") label(3 "Respiratory") label(4 "Pneumonia") label(5 "Injury") label(6 "CVD") ring(0) pos(7)) ///
				xlabel(21929 "15jan" 21937 "23jan" 21955 "10feb" 21975 "01mar" 21988 "14mar" 21990 " ",nogrid) /// 
				ylabel(-35000 " " -30000 "-30000" -20000 "-20000" -10000 "-10000" 0 "0" 2000 " ", nogrid) ///
				title("Panel B: Estimated Cumulative Deaths in the Entire Country", position(11) size(4)) ///
				xtitle("") ///
				yline(0,lpattern(shortdash) lwidth(vthin) lcolor(gray)) ///
				scheme(plotplain)
				
		graph save "$figures/fig5/panelB", replace 
				
			graph combine "$figures/fig5/panelA" "$figures/fig5/panelB", graphregion(margin(vtiny)) xsize(5) ysize(7) cols(1) 
			graph save "$figures/fig5/fig5", replace
			
			graph export "$figures/fig5.eps", replace
			graph export "$figures/fig5.png", replace


			

						
						
						
	
	
