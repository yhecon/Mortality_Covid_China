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
* Fig 6: Back of the Envelope Calculation
*
********************************************************************************

	use "$data/main.dta", clear

		keep if year == 2020
		keep if month == 1 | month == 2 | month == 3 | (month == 4 & day <= 7)
		drop if citycode == 4201

		xtset dsp date

		sum t_all
		local t_all_mean = string(r(mean), "%6.3f")
		
		reghdfe t_all inter_c_t if year == 2020, absorb(i.dsp i.date, savefe) vce(cluster dsp)
			predictnl yhat = _b[inter_c_t] * inter_c_t + _b[_cons] + __hdfe1__  + __hdfe2__
			predictnl yhat_cf = _b[inter_c_t] * 0 + _b[_cons] + __hdfe1__  + __hdfe2__
	
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
			,xlabel(21915 "1 Jan" 21937 "23 Jan" 21955 "10 Feb" 21975 "1 Mar" 22006 "1 Apr" 22012 " ",nogrid) ///
			xscale(range(21915 22022)) ///
			ylabel(0 "        0" 4 8 12 16 , nogrid axis(1)) ///
			ylabel(none, nogrid axis(2)) ///
			legend(order (3 4) label(3 "Without Lockdowns") label(4 "Observed Deaths")  ring(0) pos(11) size(2.7)) ///
			title("A: Estimated DSP Level Daily Mean Deaths", position(11) size(4)) ///
			ytitle("Daily Mean Deaths in Each DSP", size(3.2)) ytitle("", axis(2)) ///
			xtitle("") ///
			text(2 21925 "# of Lockdowns", place(e) size(2.4) color(gs10)) ///
			scheme(plotplain)
			
		graph save "$figure/fig6/fig6A", replace 	
		
********************************************************************************
	
		use $data/y_x_daily_working.dta, clear

			keep if year == 2020
			keep if month == 1 | month == 2 | month == 3 | (month == 4 & day <= 7)
			drop if citycode == 4201

			xtset dsp date
			
			foreach i of varlist t_all cvd injury lri clri cancer other_all {
				reghdfe `i' inter_c_t if year == 2020, absorb(i.dsp i.date, savefe) vce(cluster dsp)
				
				predictnl yhat_`i' = _b[inter_c_t] * inter_c_t + _b[_cons] + __hdfe1__  + __hdfe2__
				predictnl yhat_`i'_cf = _b[inter_c_t] * 0 + _b[_cons] + __hdfe1__  + __hdfe2__
			}			
			
		* graph
		
			local yhat = "yhat_t_all yhat_t_all_cf yhat_cvd yhat_cvd_cf yhat_injury yhat_injury_cf yhat_lri yhat_lri_cf yhat_clri yhat_clri_cf yhat_cancer yhat_cancer_cf yhat_other_all yhat_other_all_cf"
		
			collapse (sum) `yhat', by(date)
			drop if date < 21930
			
			foreach i of varlist yhat_t_all yhat_cvd yhat_injury yhat_lri yhat_clri yhat_cancer yhat_other_all {
				gen dif_`i' = `i' - `i'_cf
				gen saved_`i' = dif_`i' * 1160757376 / 290830016
			}	
			
			sort date
			gen saved_all = sum(saved_yhat_t_all)
			gen saved_cvd = sum(saved_yhat_cvd)
			gen saved_injury = sum(saved_yhat_injury)
			gen saved_lri = sum(saved_yhat_lri)
			gen saved_clri = sum(saved_yhat_clri)
			gen saved_cancer = sum(saved_yhat_cancer)
			gen saved_other_all = sum(saved_yhat_other_all)
			
			gen graph_cvd = saved_cvd
			gen graph_injury = graph_cvd + saved_injury
			gen graph_lri = graph_injury + saved_lri
			gen graph_clri = graph_lri + saved_clri
			gen graph_cancer = graph_clri + saved_cancer
			gen graph_other_all = graph_cancer + saved_other_all
						
			graph twoway (area graph_other_all date, fcolor("127 201 127") lcolor(white) ) ///
				(area graph_cancer date, fcolor(purple*0.4) lcolor(white) ) ///
				(area graph_clri date, fcolor("253 192 134") lcolor(white) ) ///
				(area graph_lri date, fcolor(red*0.5) lcolor(white) ) ///
				(area graph_injury date, fcolor("255 255 153") lcolor(white) ) ///
				(area graph_cvd date, fcolor(blue*0.4) lcolor(white) ) ///			
				, legend(order (6 5 4 3 2 1) label(1 "Others") label(2 "Cancer") label(3 "Chronic Lower Respiratory Infection") label(4 "Acute Lower Respiratory Infection") label(5 "Injury") label(6 "CVD") ring(0) pos(7) size(2.7)) ///
				xlabel(21915 "1 Jan" 21937 "23 Jan" 21955 "10 Feb" 21975 "1 Mar" 22006 "1 Apr" 22012 " ",nogrid) ///
				xscale(range(21915 22022)) ///
				ylabel(-60000 -40000 -20000 0 "        0"  5000 " ", nogrid) ///
				title("B: Estimated Cumulative Deaths in the Entire Country", position(11) size(4)) ///
				xtitle("") ///
				ytitle("Estimated Cumulative Deaths", size(3.2)) ///
				yline(0,lpattern(shortdash) lwidth(vthin) lcolor(gray)) ///
				scheme(plotplain)
				
		graph save "$figure/fig6/fig6B", replace 

********************************************************************************
				
			graph combine "$figure/fig6/fig6A" "$figure/fig6/fig6B", graphregion(margin(vtiny)) xsize(5) ysize(6.5) cols(1) iscale(0.7)
			graph save "$figure/fig6/fig6", replace
			
			graph export "$figure/allfig_eps/fig6.eps", replace
			graph export "$figure/allfig_png/fig6.png", replace width(3000)
			
			
			
			
			
			
			
			
			
			
			
			
			
	/* 
	    date |     saved  sa~d_cvd  saved_i~  sa~d_lri  s~d_clri  saved_..      year     month       day
---------+------------------------------------------------------------------------------------------
   22012 |    -54029    -33569     -4201     -2431     -4434     -6613      2020         4         7

   
    date |     saved  sa~d_cvd  saved_i~  sa~d_lri  s~d_clri  saved_..      year     month       day
---------+------------------------------------------------------------------------------------------
   22127 |   -293018   -173731    -14719    -12357    -28360    -34527      2020         7        31

   
	


			

						
						
						
	
	
