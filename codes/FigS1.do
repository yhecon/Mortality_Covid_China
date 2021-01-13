

******************************
*
* Fig S1: Timing of Lockdowns
*
******************************

	use "$master/y_x_daily.dta", clear
	
	drop if citycode == 4201
	sort countycode date
	
	gen new12 = 1 if l.c12t == 0 & c12t == 1
	replace new12 = 0 if new12 == .
	
	gen newld = 1 if l.lockdown_t == 0 & lockdown_t == 1
	replace newld = 0 if newld == .
	
	keep if date >= 21934 & date <= 21965
	format date %td
	
	collapse (sum) new12 newld, by(date)
	
		twoway (line new12 date, lc(red*1.5)) (line newld date, lc(blue*1.5)) /// 
			,legend(label(1 "Community Lockdown") label(2 "City Lockdown")) ytitle("Number of New Lockdowns") ///
			title("A: Timing of City/Community Lockdowns", position(11) size(medlarge)) ///
			scheme(plotplain) xlabel(21932 (10) 21967,nogrid) ylabel(,nogrid) legend(ring(0) pos(2))
				
		graph save "$figures/figS1/panelA", replace
	

	
	*------------------------
	
	
	use "$master/y_x_daily.dta", clear
	drop if citycode == 4201
	
	bys citycode date : gen dup = _n
	duplicates drop citycode date, force
	
	
	xtset citycode date
	gen lastcase_city_ = confirmed if lockdown_t == 0 & f.lockdown_t == 1
	egen lastcase_city = max(lastcase_city_), by(citycode)
	
	keep if date >= 21934 & date <= 21965
	format date %td
	
	preserve
		collapse lastcase_city, by(citycode)
		tab lastcase_city
		recode lastcase_city (min/10 = 0) (11/20 = 1) (21/30 = 2) (31/40 = 3) (41/50 = 4) (51/60 = 5) (61/70 = 6) (71/80 = 7) (81/90 = 8) (91/100 =9) (101/150 = 10) (151/200 = 11) (201/300 = 12) (301/500 = 13) (501/max = 14) , generate(cat_city)
		
		hist cat_city, lcolor(blue*1.5) color(blue*0.4) legend(label(1 "City Lockdown")) xtitle("Confirmed COVID-19 Cases a Day Before the Lockdown") ytitle("Number of Cities") title("B: COVID-19 Before the City Lockdowns", position(11) size(medlarge)) xlabel( 0.5 "~10" 1.5 "~20" 2.5 "~30" 3.5 "~40" 4.5 "~50" 5.5 "~60" 6.5 "~70" 7.5 "~80" 8.5 "~90" 9.5 "~100" 10.5 "~150" 11.5 "~200" 12.5 "~300" 13.5 "~500" 14.5 "501~" 15 " ",nogrid) ylabel(0 (10) 40,nogrid) legend(ring(0) pos(2)) scheme(plotplain)  frequency width(1) start(0)
		
		graph save "$figures/figS1/panelB", replace
		
	restore
	
	
		graph combine "$figures/figS1/panelA" "$figures/figS1/panelB", graphregion(margin(vtiny)) xsize(6) ysize(8.4) cols(1) 
		graph save "$figures/figS1/figS1",replace
		
		graph export "$figures/figS1.eps", replace
		graph export "$figures/figS1.png", replace	
		
		
	

