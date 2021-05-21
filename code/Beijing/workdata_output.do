********************************************************************************
*
* Program: The Impacts of City and Community Lockdowns on Non-COVID-19 Deaths 
*          Outside Wuhan, China  
* Author: Qi et al.
* Aim: Generate all outputs (Tables and Figures)
* Updated Date: 2021.2.19
*
********************************************************************************
cd $root
graph set window fontface "Times New Roman"

******************************
*
* Table SM1
*
******************************
* Table SM1. Summary Statistics

use $raw_data/y_x_daily, clear
keep if year == 2020
drop if citycode == 4201
drop if year == 2020 & (month >= 5 | (month == 4 & day >= 8))
replace other_all = other_all + mental + ckd + diabetes + inf_dis
count if t_all != other_all + injury + cvd + cancer +  res + pneumonia

foreach i of varlist mig movein moveout pm25 hospital_bed hospital gdppc primary_ratio secondary_ratio tertiary_ratio{

bysort year provcode: egen `i'_provmean = mean(`i')
replace `i' = `i'_provmean if `i' == .

}

replace gdppc = gdppc / 10000 //per 10,000 RMB
replace pop_total = pop_total / 10000 //per 10,000 people
replace hospital_bed = hospital_bed * 1000
replace primary_ratio = primary_ratio * 100 //%
replace secondary_ratio = secondary_ratio * 100 //%
replace tertiary_ratio = tertiary_ratio * 100 //%

bysort countycode: egen confirmed_max = max(confirmed)
replace confirmed = confirmed_max

foreach i of varlist t_all cvd injury lri clri inf_dis cancer diabetes res other_all pm25 prsmean winsmean temmean rhumean  hospital_bed gdppc secondary_ratio tertiary_ratio confirmed {

sum `i'
local `i'_mean = string(r(mean), "%6.2f")
local `i'_sd = string(r(sd), "%6.2f")

}

duplicates drop countycode, force
local N = _N

local cvd_name = "CVD"
local cancer_name = "Neoplasms"
local lri_name = "Acute lower respiratory infection"
local clri_name = "Chronic lower respiratory infection"
local injury_name = "Injury"
local inf_dis_name = "Infectious diseases"
local other_all_name = "Others"
local pm25_name = "PM2.5 Concentration(μg/m³)"
local hospital_bed_name = "Number of hospital bed per thousand people"
local gdppc_name = "GDP per capita (10,000 RMB)"
local pop_total_name = "Total population (Thousands)"
local mig_name = "Within city migration index"
local movein_name = "Inward migration index"
local moveout_name = "Outward migration index"
local confirmed_name = "COVID-19 total confirmed cases (person)"
local temmean_name = "Daily average temperature (℃)"
local prsmean_name = "Daily average air pressure (hPa)"
local rhumean_name = "Daily average humidity (%)"
local winsmean_name = "Daily average wind speed (m/s)"
local primary_ratio_name = "Share of employment in primary industry(%)"
local secondary_ratio_name = "Share of employment in secondary industry(%)"
local tertiary_ratio_name = "Share of employment in tertiary industry(%)"

tempfile appendix
tempname sumstats

postfile `sumstats' str1000(Panel Depvars_and_Controls Overall_Value SD) using `appendix'
post `sumstats' ("") ("") ("") ("")
post `sumstats' ("Panel A") ("") ("") ("")
post `sumstats' ("") ("Total") ("`t_all_mean'") ("[" + "`t_all_sd'" + "]")
foreach i of varlist cvd injury lri clri cancer other_all{
post `sumstats' ("") ("``i'_name'") ("``i'_mean'") ("[" + "``i'_sd'" + "]")
}
post `sumstats' ("") ("") ("") ("")
post `sumstats' ("Panel B") ("") ("") ("")
foreach i of varlist hospital_bed pm25 gdppc secondary_ratio tertiary_ratio confirmed prsmean winsmean temmean rhumean{
post `sumstats' ("") ("``i'_name'") ("``i'_mean'") ("[" + "``i'_sd'" + "]")
}
post `sumstats' ("") ("") ("") ("")
post `sumstats' ("") ("# of DSP counties") ("`N'") ("")
postclose `sumstats'

use `appendix', clear
export excel using $output/TS1, replace firstrow(variables)


**********************
*
* Table SM2
*
**********************
* Table SM2.	Main DID Result

use $raw_data/y_x_daily.dta, clear

keep if year == 2020
keep if month == 1 | month == 2 | month == 3 | (month == 4 & day <= 7)
drop if citycode == 4201

rename countycode dsp
xtset dsp date

replace other_all = other_all + mental + ckd + diabetes + inf_dis
gen inter_c_t= ct

label variable inter_c_t "Lockdown policy"
label variable t_all "Total # of Deaths"
label variable cvd "CVD"
label variable injury "Injury"
label variable lri "Acute Lower Respiratory Infection"
label variable clri "Chronic Lower Respiratory Infection"
label variable cancer "Neoplasms"
label variable other_all "Other Causes"

sum t_all
local t_all_mean = string(r(mean), "%6.3f")
reghdfe t_all inter_c_t if year == 2020, absorb(i.dsp i.date) vce(cluster citycode)
outreg2 using $output/TS2.xls, replace se bracket dec(3) keep(inter_c_t) addnote("Notes: Each cell in the table represents a separate DiD regression. All DSP districts/counties are included in the analysis except 3 from Wuhan. The outcome variable is the daily number of non-COVID-19 deaths from the DSP districts/counties. We use mortality data from January 1 to April 7, 2020 for this analysis; the data were extracted from the DSP system on May 15, 2020. The explanatory variable is a dummy indicating whether a city associated with a DSP had a lockdown policy on a particular date. The standard errors clustered at the prefectural level are reported below the estimates. * significant at 10% ** significant at 5% *** significant at 1%.") addtext(DSP Fixed Effect, "YES", Date Fixed Effect, "YES") addstat(Obs., e(N), Adjusted R-Square, e(r2_a),  # of DSP Counties, 602) nocon nor2 noobs label cttop("Mean = `t_all_mean'") title("Table 1. The Impacts of City Lockdown on Deaths from Different Causes")

foreach i of varlist cvd injury lri clri cancer other_all{
	sum `i'
	local `i'_mean = string(r(mean), "%6.3f")
    reghdfe `i' inter_c_t if year == 2020, absorb(i.dsp i.date) vce(cluster citycode)
	outreg2 using $output/TS2.xls, append excel se bracket dec(3)  keep(inter_c_t) addtext(DSP Fixed Effect, "YES", Date Fixed Effect, "YES") addstat(Obs., e(N), Adjusted R-Square, e(r2_a),  # of DSP Counties, 602) nocon nor2 noobs label cttop("Mean = ``i'_mean'")
}



******************************
*
* Fig 3 & Table SM3: Event Study
*
******************************

efolder, cd("$path/output") sub(fig3_tableS3) noc
efolder, cd("$path/output") sub(figures) noc
efolder, cd("$path/output/figures") sub(allfig_eps) noc
efolder, cd("$path/output/figures") sub(allfig_png) noc
efolder, cd("$path/output/figures") sub(fig3) noc

* set directories 
clear all
set maxvar  30000
set matsize 11000 
set more off
cap log close

global master $raw_data
global figures $output/figures
global results $output

 * Estimation

	use "$master\y_x_daily.dta", clear
		
		drop if year == 2020 & (month >= 5 | (month == 4 & day >= 8))
	
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
		save $results/fig3_tableS3/event_info.dta, replace


		clear
		use "$master\y_x_daily.dta", clear
		keep if year == 2020
		drop if year == 2020 & (month >= 5 | (month == 4 & day >= 8))
		replace other_all = other_all + mental + ckd
		xtset countycode date
		sort countycode date
		gen week = week(date)
		drop if citycode == 4201
		merge 1:1 countycode date using $results/fig3_tableS3/event_info.dta, nogen
		sort countycode date

		cap erase $results/fig3_tableS3/event.xml
		cap erase $results/fig3_tableS3/event.txt
		foreach i of varlist t_all cvd injury lri{
			qui reghdfe `i' Lead_D7 Lead_D6 Lead_D5 Lead_D4 Lead_D3 Lead_D2 D0 D1 D2 D3 D4 D5 D6 if ct !=., absorb(i.date i.countycode) vce(cluster citycode)
			parmest , saving($results/fig3_tableS3/event_`i'.dta, replace)
			outreg2 using $results/fig3_tableS3/event.xml, dec(3) append bracket nocon nor2 noobs label addstat(Obs., e(N), Adjusted R-Square, e(r2_a),  # of DSP Counties, 602) addtext(DSP Fixed Effect, "YES", Date Fixed Effect, "YES") addnote("Notes: We include leads and lags of the start of the lockdown dummy in the regressions to test the parallel trend assumption. The dummy variable indicating one week before the lockdown is omitted from the regressions. The standard errors clustered at the prefectural level are reported below the estimates. * significant at 10% ** significant at 5% *** significant at 1%.") title("Table SM3. Event study estimation results")
			
		}
		*
		
		
		
		
******************************

 * Creating Figure
 
		clear
		cd $results/fig3_tableS3
		openall, storefilename(fn)

		drop if fn == "event_info.dta"
		keep parm estimate stderr dof t p min95 max95 fn
		
		split fn, p("_")

		gen type = "all" if fn2 == "t"
		replace type = "cvd" if fn2 == "cvd.dta"
		replace type = "injury" if fn2 == "injury.dta"
		replace type = "lri" if fn2 == "lri.dta"

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
		*injury
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
		*lri
		keep if type == "lri"
		graph twoway (scatter estimate dup2, mcolor(cranberry) mfcolor(white) msize(medsmall)) ///
			(rcap max95 min95 dup2, lcolor(dkorange) lwidth(medthick)) ///
			,scheme(plotplain) ///
			xlab(-7.5 " " -7 "≤ -7" -6 "-6" -5 "-5" -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "≥6" 6.5 " ", labsize(*0.8) labcolor(black) axis(1) nogrid) ///
			ylabel(, labsize(*0.8) nogrid) ///
			yline(0, lp(dash) lc(khaki)) ///
			xline(-1, lp(dash) lc(khaki)) ///
			title("Panel D. # of Deaths from Acute Lower Respiratory Infection", pos(11) size(med)) ///
			xtitle("Weeks", size(*0.8)) ///
			ytitle("Estimated Coefficients", size(*0.8)) ///
			xsize(1.5) ysize(1) ///
			legend(off)
		graph save "$figures/fig3/panelD", replace 		
		restore

		graph combine "$figures/fig3/panelA" "$figures/fig3/panelB" "$figures/fig3/panelC" "$figures/fig3/panelD", graphregion(fcolor(white)  lcolor(white)) imargin(small) iscale(0.77)  fysize(100) fxsize(150) xsize(9) ysize(6.5)

		graph save "$figures/fig3/fig3", replace 
		graph export "$figures/allfig_eps/fig3.eps", replace
		graph export "$figures/allfig_png/fig3.png", replace		

		
		
******************************
*
* Table SM4
*
******************************
* Table SM4. By Death Causes

cd $root
*=======
* CVD
*=======

use $raw_data/y_x_daily, clear
preserve
keep if year == 2020
drop if year == 2020 & (month >= 5 | (month == 4 & day >= 8))
drop if citycode == 4201

rename countycode dsp
xtset dsp date

gen other_cvd = cvd - mi - stroke_h - stroke_i
gen inter_c_t= ct
gen stroke = stroke_i + stroke_h

label variable inter_c_t "Lockdown policy"
label variable t_all "Total"
label variable cvd "CVD"
label variable stroke "Stroke"
label variable mi "Myocardial Infarction "
label variable other_cvd "Other CVDs"

sum cvd
local cvd_mean = string(r(mean), "%6.3f")
reghdfe cvd inter_c_t if year == 2020, absorb(i.dsp i.date) vce(cluster citycode)
outreg2 using $output/TS4_cvd.xls, replace se bracket dec(3) keep(inter_c_t) addnote("Notes: Each cell in the table represents a separate DiD regression. All DSP districts/counties are included in the analysis except 3 DSP counties/districts from Wuhan. The outcome variable is the daily number of non-COVID-19 deaths from the DSP districts/counties. We use mortality data from January 1 to April 7, 2020 for this analysis; the data were extracted from the DSP system on September 28, 2020. The explanatory variable is a dummy indicating whether a city associated with a DSP had a lockdown policy on a particular date. DSP fixed effect and date fixed effect are both included in each regression. The total number of observations for each regression is 58,996 covering 602 DSP counties. The standard errors clustered at the prefectural level are reported below the estimates. * significant at 10% ** significant at 5% *** significant at 1%. ") addtext( DSP Fixed Effect, "YES", Date Fixed Effect, "YES") addstat(Obs., e(N), Adjusted R-Square, e(r2_a),  # of DSP Counties, 602) nocon nor2 noobs label cttop("Mean = `cvd_mean'") title("Table SM4. The impacts of lockdowns on cause-specific deaths")

foreach i of varlist mi stroke other_cvd{
	sum `i'
	local `i'_mean = string(r(mean), "%6.3f")
    reghdfe `i' inter_c_t if year == 2020, absorb(i.dsp i.date) vce(cluster citycode)
	outreg2 using $output/TS4_cvd.xls, append excel se bracket dec(3)  keep(inter_c_t) addtext(DSP Fixed Effect, "YES", Date Fixed Effect, "YES") addstat(Obs., e(N), Adjusted R-Square, e(r2_a),  # of DSP Counties, 602) nocon nor2 noobs label cttop("Mean = ``i'_mean'")
}
restore

*=======
* Injury
*=======

preserve
keep if year == 2020
drop if year == 2020 & (month >= 5 | (month == 4 & day >= 8))
drop if citycode == 4201

rename countycode dsp
xtset dsp date

gen inter_c_t= ct

label variable inter_c_t "Lockdown policy"
label variable t_all "Total"
label variable injury "Injury"
label variable suicide "Suicide"
label variable traffic "Traffic"
label variable other_injury "Other Injuries"

sum injury
local injury_mean = string(r(mean), "%6.3f")
reghdfe injury inter_c_t if year == 2020, absorb(i.dsp i.date) vce(cluster citycode)
outreg2 using $output/TS4_injury.xls, replace se bracket dec(3) keep(inter_c_t) addnote("Notes: * significant at 10% ** significant at 5% *** significant at 1%. The standard errors clustered at the prefectural level are reported below the estimates. Each cell in the table represents a separate DiD regression. All DSP counties are included in the analysis except 3 from Wuhan. The outcome variable is the number of daily deaths from the DSP counties without inclusion of death tolls for COVID-19. Mortality data used is between January 1 and April 8, 2020 and has been reported by each DSP county by September 28, 2020. The explanatory variable is a dummy indicating whether a city where DSP belongs to enforced a lockdown policy on a particular date.") addtext( DSP Fixed Effect, "YES", Date Fixed Effect, "YES") addstat(Obs., e(N), Adjusted R-Square, e(r2_a),  # of DSP Counties, 602) nocon nor2 noobs label cttop("Mean = `injury_mean'") title("Table SM4. The impacts of lockdowns on cause-specific deaths (cont'd)")

foreach i of varlist traffic other_injury suicide{
	sum `i'
	local `i'_mean = string(r(mean), "%6.3f")
    reghdfe `i' inter_c_t if year == 2020, absorb(i.dsp i.date) vce(cluster citycode)
	outreg2 using $output/TS4_injury.xls, append excel se bracket dec(3)  keep(inter_c_t) addtext(DSP Fixed Effect, "YES", Date Fixed Effect, "YES") addstat(Obs., e(N), Adjusted R-Square, e(r2_a),  # of DSP Counties, 602) nocon nor2 noobs label cttop("Mean = ``i'_mean'")
}

restore




******************************
*
* Table SM5
*
******************************

* Table SM5. Robustness Check

cd $root
cap erase $output/TS5.xls
cap erase $output/TS5.txt
use $raw_data/y_x_daily, clear

*=============
* Controls
*=============

preserve
keep if year == 2020
drop if year == 2020 & (month >= 5 | (month == 4 & day >= 8))
drop if citycode == 4201

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
label variable lri "Acute Lower Respiratory Infection"

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

foreach i of varlist t_all cvd injury lri{
	sum `i'
	local `i'_mean = string(r(mean), "%6.3f")
	reghdfe `i' inter_c_t1 temmean rhumean prsmean winsmean gdppc_date gdppc_date2 gdppc_date3 hospital_bed_date hospital_bed_date2 hospital_bed_date3 pop_total_date pop_total_date2 pop_total_date3 if year == 2020, absorb(i.dsp i.date) vce(cluster citycode)
	outreg2 using $output/TS5.xls, append se bracket dec(3) ///
	keep(inter_c_t1) ///
	 addnote("Notes: Each cell in the table represents a separate DiD regression. The standard errors clustered at the prefectural level are reported below the estimates. * significant at 10% ** significant at 5% *** significant at 1%. In Panel A, the controls include daily average of temperature, humidity, wind speed, air pressure, and interactions between time invariant variables and a third-order polynomial function of time. Panel B includes 3 DSPs of Wuhan. Panel C defines lockdown in city lockdown only and city+community lockdown. Panel D uses day-to-day matched 2019 death tolls as dependent variables, in which all death records from January 1, 2019 to December 31, 2019 are used.") ///
	addtext(DSP Fixed Effect, "YES", Date Fixed Effect, "YES") ///
	addstat(Obs., e(N), Adjusted R-Square, e(r2_a),  # of DSP Counties, 602) ///
	nocon nor2 noobs label cttop("Mean = ``i'_mean'") ///
	groupvar(Panel_A_With_Controls inter_c_t1 Panel_B_Include_Wuhan inter_c_t2 Panel_C_Change_Definition group1t group2t Panel_D_Use_2019_Deaths inter_c_t5) ///
	title("Table SM5. Robustness checks and placebo test")
}
restore

*=================
* Include Wuhan
*=================

preserve
keep if year == 2020
drop if year == 2020 & (month >= 5 | (month == 4 & day >= 8))

rename countycode dsp
xtset dsp date

gen inter_c_t2 = ct

label variable inter_c_t2 "Lockdown policy"
label variable t_all "Total"
label variable cvd "CVD"
label variable injury "Injury"
label variable lri "Acute Respiratory Infection"

foreach i of varlist t_all cvd injury lri{
	sum `i'
	local `i'_mean = string(r(mean), "%6.3f")
    reghdfe `i' inter_c_t2 if year == 2020, absorb(i.dsp i.date) vce(cluster citycode)
	outreg2 using $output/TS5.xls, append excel se bracket dec(3) ///
	keep(inter_c_t2) addtext(DSP Fixed Effect, "YES", Date Fixed Effect, "YES") ///
	addstat(Obs., e(N), Adjusted R-Square, e(r2_a),  # of DSP Counties, 605) nocon nor2 noobs label cttop("Mean = ``i'_mean'") ///
	groupvar(Panel_A_With_Controls inter_c_t1 Panel_B_Include_Wuhan inter_c_t2 Panel_C_Change_Definition group1t group2t Panel_D_Use_2019_Deaths inter_c_t5)
}

restore


*===================
* Change definition
*===================
preserve

keep if year == 2020
drop if year == 2020 & (month >= 5 | (month == 4 & day >= 8))
drop if citycode == 4201

rename countycode dsp
xtset dsp date

gen group1t = 1 if lockdown_t == 1 & c12t != 1 & c12 == 1
replace group1t = 0 if group1t == .
gen group2t = 1 if c12t == 1
replace group2t = 0 if group2t == .

label variable t_all "Total"
label variable cvd "CVD"
label variable injury "Injury"
label variable lri "Acute Respiratory Infection"
label variable group1t "Only city lockdown"
label variable group2t "Community lockdown"

* Tier 1 & Tier 2
foreach i of varlist t_all cvd injury lri{
	sum `i'
	local `i'_mean = string(r(mean), "%6.3f")
	reghdfe `i' group1t group2t if year == 2020,absorb(i.dsp i.date) vce(cluster citycode)
	outreg2 using $output/TS5.xls, append se bracket dec(3) ///
	keep(group1t group2t) addtext(DSP Fixed Effect, "YES", Date Fixed Effect, "YES") addstat(Obs., e(N), Adjusted R-Square, e(r2_a), # of DSP Counties, 602) ///
	nocon nor2 noobs label cttop("Mean = ``i'_mean'") ///
	groupvar(Panel_A_With_Controls inter_c_t1 Panel_B_Include_Wuhan inter_c_t2 Panel_C_Change_Definition group1t group2t Panel_D_Use_2019_Deaths inter_c_t5)
}

restore

*==============
* Placebo Test
*==============

preserve


* Use full 2019 sample
use $raw_data/y_x_daily_2019complete, clear
drop if citycode == 4201
rename countycode dsp
xtset dsp date

foreach i of varlist confirmed temmean rhumean prsmean winsmean pm25 so2 no2 movein moveout mig hospital_bed hospital gdppc primary_ratio secondary_ratio tertiary_ratio{

bysort date provcode: egen `i'_provmean = mean(`i')
replace `i' = `i'_provmean if `i' == .

}

bysort month day dsp: egen ct_2019 = sum(ct)
replace ct = ct_2019

gen inter_c_t5= ct

lab variable inter_c_t5 "Lockdown policy"
label variable t_all "Total"
label variable cvd "CVD"
label variable injury "Injury"
label variable lri "Acute Respiratory Infection"

foreach i of varlist t_all cvd injury lri{

	sum `i'
	local `i'_mean = string(r(mean), "%6.3f")
	
		reghdfe `i' inter_c_t5 if year == 2019, absorb(i.dsp i.date) vce(cluster citycode)
	
	outreg2 using $output/TS5.xls, append excel se bracket dec(3)  keep(inter_c_t5) addtext(DSP Fixed Effect, "YES", Date Fixed Effect, "YES") addstat(Obs., e(N), Adjusted R-Square, e(r2_a),  # of DSP Counties, 602) nocon nor2 noobs label cttop("Mean = ``i'_mean'") ///
	groupvar(Panel_A_With_Controls inter_c_t1 Panel_B_Include_Wuhan inter_c_t2 Panel_C_Change_Definition group1t group2t Panel_D_Use_2019_Deaths inter_c_t5)
}

restore




*******************************************
*
* Table SM6 / Table SM7 / Table SM8 / Table SM9
*
*******************************************
* Table SM6. Heterogeneity: Total
* Table SM7. Heterogeneity: CVD
* Table SM8. Heterogeneity: Injury
* Table SM9. Heterogeneity: LRI

* Use date with full 2019 data, not the one reported at 2019.9.28
use $raw_data/y_x_daily_2019complete.dta, clear
keep ct date provcode citycode countycode year month day countycode t_all cvd injury lri pm25 hospital_bed gdppc secondary_ratio pop_total
drop if citycode == 4201

* Keep all 2019 obs (no drop)
drop if year == 2020 & (month >= 5 | (month == 4 & day >= 8))

foreach i of varlist t_all cvd injury lri{

	* gen a variable only for 2019 obs
	gen `i'_2019 = `i' if year == 2019
	
	* replace 0 for 2020 obs
	replace `i'_2019 = 0 if `i'_2019 == .
	
	* gen 2019 total deaths for each dsp for each death causes
	bysort countycode: egen `i'_2019_ = sum(`i'_2019)
	
	* replace the old variable using new variable, now it's time-invariant and denotes for every dsp's 2019 deaths 
	replace `i'_2019 = `i'_2019_
	
	* using annual death rate, rather than number
	replace `i'_2019 = `i'_2019 / pop_total * 36500
	
	* generate a over country 2019 mean death rate
	egen `i'_2019_mean = mean(`i'_2019)
	
	* to see how much a county deviates from the whole country's mean
	replace `i'_2019 = `i'_2019 - `i'_2019_mean
	
	* gen interaction
	gen ct_`i' = ct * `i'_2019
	
	cap drop `i'_2019 `i'_2019_mean `i'_2019_

}



* For PM2.5 (it is a time-varying var), gen its interaction here

	* Replace using daily provincial mean if value missing
	bysort date provcode: egen pm25_provmean = mean(pm25)
	replace pm25 = pm25_provmean if pm25 == .

	* gen a variable only for 2019 obs
	gen pm25_2019 = pm25 if year == 2019
	
	* gen 2019 mean by dsp
	bysort countycode: egen pm25_2019_ = mean(pm25_2019)
	
	* replace the old variable using new variable. Now it's time-invariant and denotes for every dsp's 2019 deaths 
	replace pm25_2019 = pm25_2019_
	
	* generate a over country 2019 mean PM2.5
	egen pm25_2019_mean = mean(pm25_2019)
	
	* to see how much a county deviates from the whole country's mean
	replace pm25 = pm25_2019 - pm25_2019_mean
	
	cap drop pm25_provmean pm25_2019_mean pm25_2019 pm25_2019_


	
* prepare to gen interactions for time-invariant vars
foreach i of varlist hospital_bed gdppc secondary_ratio{

	* Replace using daily unmissing provincial mean if value missing
	bysort provcode: egen `i'_provmean = mean(`i')
	replace `i' = `i'_provmean if `i' == .

	* Gen over country mean
	egen `i'_mean = mean(`i')
	
	* Standardize
	replace `i' = `i' - `i'_mean
	
	cap drop `i'_provmean `i'_mean

}


* Gen interactions

rename countycode dsp

gen inter_c_t= ct

replace gdppc = gdppc / 10000 //per 10,000 RMB
gen ct_gdppc = ct * gdppc

replace hospital_bed = hospital_bed * 1000 //1000 beds
gen ct_hospital_bed = ct * hospital_bed

gen ct_pm25 = ct * pm25

replace secondary_ratio = secondary_ratio * 100 //%
gen ct_secondary_ratio = ct * secondary_ratio

* For Data Checking
sort dsp date

reghdfe lri inter_c_t ct_pm25 if year == 2020, absorb(i.dsp i.date) vce(cluster citycode)
reghdfe lri inter_c_t ct_pm25 ct_lri if year == 2020, absorb(i.dsp i.date) vce(cluster citycode)
gen ct_pm25_lri = ct_pm25 * ct_lri
reghdfe lri inter_c_t ct_pm25 ct_lri ct_pm25_lri if year == 2020, absorb(i.dsp i.date) vce(cluster citycode)


* Labeling

label variable cvd "CVD"
label variable injury "Injury"
label variable t_all "Total"
label variable lri "Acute Lower Respiratory Infection"
label variable inter_c_t "Lockdown policy"
label variable ct_gdppc "Lockdown*GDP per capita"
label variable ct_hospital_bed "Lockdown*hospital beds per capita"
label variable ct_pm25 "Lockdown*PM2.5 concentration"
label variable ct_secondary_ratio "Lockdown*share of employment in secondary industry"
label variable ct_t_all "Lockdown*2019 total mortality rate"
label variable ct_cvd "Lockdown*2019 CVD mortality"
label variable ct_injury "Lockdown*2019 injury mortality rate"
label variable ct_lri "Lockdown*Acute Lower Respiratory Infection"


* Run Regression
foreach i of varlist t_all cvd injury lri{
reghdfe `i' inter_c_t ct_gdppc if year == 2020, absorb(i.dsp i.date) vce(cluster citycode)
outreg2 using $output/TS_Hetero_`i'.xls, replace se bracket dec(3) ///
keep(inter_c_t ct_gdppc) ///
addnote("Notes: Each cell in the table represents a separate DiD regression. We interact the treatment dummy with baseline socio-economic variables to understand the heterogeneity impacts of lockdowns. The standard errors clustered at the prefectural level are reported below the estimates. * significant at 10% ** significant at 5% *** significant at 1%.") ///
addtext(DSP Fixed Effect, "YES", Date Fixed Effect, "YES") ///
groupvar(Panel_`i'_Deaths inter_c_t ct_gdppc ct_hospital_bed ct_pm25 ct_secondary_ratio ct_`i') ///
addstat(Obs., e(N), Adjusted R-Square, e(r2_a),  # of DSP Counties, 602) ///
nocon nor2 noobs label ///
title("Table SM6. The heterogeneous impacts of city/community lockdowns on `i' deaths") ///
ctitle(" ")

reghdfe `i' inter_c_t ct_hospital_bed if year == 2020, absorb(i.dsp i.date) vce(cluster citycode)
outreg2 using $output/TS_Hetero_`i'.xls, append se bracket dec(3) ///
 keep(inter_c_t ct_hospital_bed) ///
addtext(DSP Fixed Effect, "YES", Date Fixed Effect, "YES") ///
groupvar(Panel_`i'_Deaths inter_c_t ct_gdppc ct_hospital_bed ct_pm25 ct_secondary_ratio ct_`i') ///
addstat(Obs., e(N), Adjusted R-Square, e(r2_a),  # of DSP Counties, 602) ///
nocon nor2 noobs label ///
ctitle(" ")

reghdfe `i' inter_c_t ct_pm25 if year == 2020, absorb(i.dsp i.date) vce(cluster citycode)
outreg2 using $output/TS_Hetero_`i'.xls, append se bracket dec(3)  ///
keep(inter_c_t ct_pm25) ///
addtext(DSP Fixed Effect, "YES", Date Fixed Effect, "YES") ///
groupvar(Panel_`i'_Deaths inter_c_t ct_gdppc ct_hospital_bed ct_pm25 ct_secondary_ratio ct_`i') ///
addstat(Obs., e(N), Adjusted R-Square, e(r2_a),  # of DSP Counties, 602) ///
nocon nor2 noobs label ///
ctitle(" ")

reghdfe `i' inter_c_t ct_secondary_ratio if year == 2020, absorb(i.dsp i.date) vce(cluster citycode)
outreg2 using $output/TS_Hetero_`i'.xls, append se bracket dec(3) ///
 keep(inter_c_t ct_secondary_ratio) ///
addtext(DSP Fixed Effect, "YES", Date Fixed Effect, "YES") ///
groupvar(Panel_`i'_Deaths inter_c_t ct_gdppc ct_hospital_bed ct_pm25 ct_secondary_ratio ct_`i') ///
addstat(Obs., e(N), Adjusted R-Square, e(r2_a),  # of DSP Counties, 602) ///
nocon nor2 noobs label ///
ctitle(" ")

reghdfe `i' inter_c_t ct_`i' if year == 2020, absorb(i.dsp i.date) vce(cluster citycode)
outreg2 using $output/TS_Hetero_`i'.xls, append se bracket dec(3) ///
 keep(inter_c_t ct_`i') ///
addtext(DSP Fixed Effect, "YES", Date Fixed Effect, "YES") ///
groupvar(Panel_`i'_Deaths inter_c_t ct_gdppc ct_hospital_bed ct_pm25 ct_secondary_ratio ct_`i') ///
addstat(Obs., e(N), Adjusted R-Square, e(r2_a),  # of DSP Counties, 602) ///
nocon nor2 noobs label ///
ctitle(" ")

reghdfe `i' inter_c_t ct_gdppc ct_hospital_bed ct_pm25 ct_secondary_ratio ct_`i' if year == 2020, absorb(i.dsp i.date) vce(cluster citycode)
outreg2 using $output/TS_Hetero_`i'.xls, append se bracket dec(3) ///
 keep(inter_c_t ct_gdppc ct_hospital_bed ct_pm25 ct_secondary_ratio ct_`i') ///
addtext(DSP Fixed Effect, "YES", Date Fixed Effect, "YES") ///
groupvar(Panel_`i'_Deaths inter_c_t ct_gdppc ct_hospital_bed ct_pm25 ct_secondary_ratio ct_`i') ///
addstat(Obs., e(N), Adjusted R-Square, e(r2_a),  # of DSP Counties, 602) ///
nocon nor2 noobs label ///
ctitle(" ")

}


******************************
*
* Table S8
*
******************************
* Table S8. City lockdown Status

use $raw_data/y_x_daily, replace
bysort countycode: egen confirmed_max = max(confirmed)

keep if year == 2020

sort countycode date
bysort countycode ct: gen n_c = sum(ct)
gen policy_begin_c = 1 if n_c == 1
replace policy_begin_c = 0 if policy_begin_c == .

sort countycode date
bysort countycode c12t: gen n_c12 = sum(c12t)
gen policy_begin_c12 = 1 if n_c12 == 1
replace policy_begin_c12 = 0 if policy_begin_c12 == .

sort countycode date
bysort countycode: gen n_ld = sum(lockdown_t)
gen policy_begin_ld = 1 if n_ld == 1
replace policy_begin_ld = 0 if policy_begin_ld == .

keep if policy_begin_c == 1 | policy_begin_c12 == 1 | policy_begin_ld == 1 | c == 0 | c12 == 0 | lockdown == 0
duplicates drop countycode policy_begin_c policy_begin_c12 policy_begin_ld, force
keep countycode date provname cityname countyname policy_begin_c policy_begin_c12 policy_begin_ld citycode
bysort countycode: egen c_sum = sum(policy_begin_c)
bysort countycode: egen c12_sum = sum(policy_begin_c12)
bysort countycode: egen ld_sum = sum(policy_begin_ld)
drop if policy_begin_c == 0 & policy_begin_c12 == 0 & policy_begin_ld == 0 & c_sum != 0 & c12_sum != 0 & ld_sum != 0
drop c_sum c12_sum ld_sum
replace policy_begin_c = date if policy_begin_c == 1
replace policy_begin_c12 = date if policy_begin_c12 == 1
replace policy_begin_ld = date if policy_begin_ld == 1
bysort countycode:egen c_sum_date = sum(policy_begin_c)
bysort countycode: egen c12_sum_date = sum(policy_begin_c12)
bysort countycode: egen ld_sum_date = sum(policy_begin_ld)
replace policy_begin_c = c_sum_date if policy_begin_c == 0
replace policy_begin_c12 = c12_sum_date if policy_begin_c12 == 0
replace policy_begin_ld = ld_sum_date if policy_begin_ld == 0
duplicates drop countycode policy_begin_c policy_begin_c12 policy_begin_ld, force
drop date *sum_date
rename policy_begin_ld cityld
rename policy_begin_c12 communityld
foreach i of varlist cityld communityld{

gen `i'_year = year(`i')
gen `i'_month = month(`i')
tostring `i'_month, replace
gen `i'_day = day(`i')
tostring `i'_day, replace
gen `i'_date = "2020/" + `i'_month + "/" + `i'_day if `i'_year != 1960
replace `i'_date = "" if `i'_year == 1960
destring `i'_month `i'_day, replace

}
keep countycode provname cityname countyname cityld_date communityld_date *_month *_day citycode
rename cityld_date cityld
rename communityld_date communityld
gen cityld_date = cityld_month * 100 + cityld_day
gen communityld_date = communityld_month * 100 + communityld_day
gen group = 1 if cityld != "" & communityld != "" & cityld_date < communityld_date
replace group = 2 if (communityld != "" & cityld == "") | (cityld != "" & communityld != "" & cityld_date >= communityld_date)
replace group = 3 if cityld == "" & communityld == ""
keep group countycode provname cityname countyname cityld communityld citycode cityld_date communityld_date
bysort citycode: gen countyname_n = _n
reshape wide countyname countycode, i(citycode) j(countyname_n)
order countyname*, after(cityname)
sort group cityld_date communityld_date

preserve
keep if group == 2
sort communityld_date cityld_date
save "temporary\group2sorted", replace
restore

preserve
keep if group == 3
sort citycode countycode1
save "temporary\group3sorted", replace
restore

drop if group == 2 | group == 3
append using "temporary\group2sorted"
append using "temporary\group3sorted"
drop citycode cityld_date communityld_date

export excel using "output\TS8.xls", replace firstrow(variables)



******************************
*
* Table SM10. By age group
*
******************************
use $raw_data/y_x_daily_agegroup.dta, clear
keep if year == 2020
drop if citycode == 4201

cap drop dsp
rename code dsp
rename deaddate1 date
xtset dsp date

drop if year == 2020 & (month > 4 | (month == 4 & day >= 8))

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
label variable lri_agegroup`i' "Acute Lower Respiratory Infection"
label variable res_agegroup`i' "Respiratory Diseases"
label variable other_all_agegroup`i' "Others"
label variable diabetes_agegroup`i' "Diabetes"
label variable cancer_agegroup`i' "Neoplasms"
label variable inf_dis_agegroup`i' "Infectious Diseases"
label variable traffic_agegroup`i' "Traffic"
label variable suicide_agegroup`i' "Suicide"
replace other_all_agegroup`i' = other_all_agegroup`i' + mental_agegroup`i' + ckd_agegroup`i'
}

sum t_all_agegroup1
local t_all_agegroup1_mean = string(r(mean), "%6.3f")
sum t_all_agegroup2
local t_all_agegroup2_mean = string(r(mean), "%6.3f")
sum t_all_agegroup3
local t_all_agegroup3_mean = string(r(mean), "%6.3f")
reghdfe t_all_agegroup1 inter_c_t1 if year == 2020, absorb(i.dsp i.date) vce(cluster citycode)
outreg2 using $output/TS10.xls, replace se bracket dec(3) keep(inter_c_t1) addnote("Notes: We examine the impacts of lockdowns on the number of deaths from different age groups in this table. Each cell represents a separate DiD regression. DSP fixed effect and date fixed effect are both included in each regression. The number of observations for each regression is 58,996 covering 602 DSP counties. The standard errors clustered at the prefecture level are reported below the estimates. * significant at 10% ** significant at 5% *** significant at 1%.") addtext(DSP Fixed Effect, "YES", Date Fixed Effect, "YES") addstat(Obs., e(N), Adjusted R-Square, e(r2_a),  # of DSP Counties, e(N_clust)) nocon nor2 noobs label cttop("Mean = `t_all_agegroup1_mean'") title("Table SM10. By Age Groups") groupvar(Panel_A_0_14 inter_c_t1 Panel_B_15_64 inter_c_t2 Panel_C_over_65 inter_c_t3)

reghdfe t_all_agegroup2 inter_c_t2 if year == 2020, absorb(i.dsp i.date) vce(cluster citycode)
outreg2 using $output/TS10.xls, append excel se bracket dec(3)  keep(inter_c_t2) addtext(DSP Fixed Effect, "YES", Date Fixed Effect, "YES") addstat(Obs., e(N), Adjusted R-Square, e(r2_a),  # of DSP Counties, e(N_clust)) nocon nor2 noobs label cttop("Mean = `t_all_agegroup2_mean'") groupvar(Panel_A_0_14 inter_c_t1 Panel_B_15_64 inter_c_t2 Panel_C_over_65 inter_c_t3)
	
reghdfe t_all_agegroup3 inter_c_t3 if year == 2020, absorb(i.dsp i.date) vce(cluster citycode)
outreg2 using $output/TS10.xls, append excel se bracket dec(3)  keep(inter_c_t3) addtext(DSP Fixed Effect, "YES", Date Fixed Effect, "YES") addstat(Obs., e(N), Adjusted R-Square, e(r2_a),  # of DSP Counties, e(N_clust)) nocon nor2 noobs label cttop("Mean = `t_all_agegroup3_mean'") groupvar(Panel_A_0_14 inter_c_t1 Panel_B_15_64 inter_c_t2 Panel_C_over_65 inter_c_t3)

foreach i of varlist cvd injury lri{
	sum `i'_agegroup1
	local `i'_agegroup1_mean = string(r(mean), "%6.3f")
	sum `i'_agegroup2
	local `i'_agegroup2_mean = string(r(mean), "%6.3f")
	sum `i'_agegroup3
	local `i'_agegroup3_mean = string(r(mean), "%6.3f")
    reghdfe `i'_agegroup1 inter_c_t1 if year == 2020, absorb(i.dsp i.date) vce(cluster citycode)
	outreg2 using $output/TS10.xls, append excel se bracket dec(3)  keep(inter_c_t1) addtext(DSP Fixed Effect, "YES", Date Fixed Effect, "YES") addstat(Obs., e(N), Adjusted R-Square, e(r2_a),  # of DSP Counties, e(N_clust)) nocon nor2 noobs label cttop("Mean = ``i'_agegroup1_mean'") groupvar(Panel_A_0_14 inter_c_t1 Panel_B_15_64 inter_c_t2 Panel_C_over_65 inter_c_t3)
	
	reghdfe `i'_agegroup2 inter_c_t2 if year == 2020, absorb(i.dsp i.date) vce(cluster citycode)
	outreg2 using $output/TS10.xls, append excel se bracket dec(3)  keep(inter_c_t2) addtext(DSP Fixed Effect, "YES", Date Fixed Effect, "YES") addstat(Obs., e(N), Adjusted R-Square, e(r2_a),  # of DSP Counties, e(N_clust)) nocon nor2 noobs label cttop("Mean = ``i'_agegroup2_mean'") groupvar(Panel_A_0_14 inter_c_t1 Panel_B_15_64 inter_c_t2 Panel_C_over_65 inter_c_t3)
	
	reghdfe `i'_agegroup3 inter_c_t3 if year == 2020, absorb(i.dsp i.date) vce(cluster citycode)
	outreg2 using $output/TS10.xls, append excel se bracket dec(3)  keep(inter_c_t3) addtext(DSP Fixed Effect, "YES", Date Fixed Effect, "YES") addstat(Obs., e(N), Adjusted R-Square, e(r2_a),  # of DSP Counties, e(N_clust)) nocon nor2 noobs label cttop("Mean = ``i'_agegroup3_mean'") groupvar(Panel_A_0_14 inter_c_t1 Panel_B_15_64 inter_c_t2 Panel_C_over_65 inter_c_t3)

}

*****************************
*
* Long-term Effect
*
*****************************
use $raw_data/y_x_daily.dta, clear

keep if year == 2020 & month <= 7
drop if citycode == 4201

rename countycode dsp

* Check balance panel
xtset dsp date

replace other_all = other_all + mental + ckd + diabetes + inf_dis

* Gen longterm dummy: As the latest city deblocking, Wuhan deblocked at April 8.
gen longterm = 1 if citycode != 4201 & date >= 22013
replace longterm = 0 if longterm == .

* Gen longterm and treatment group's interaction
gen inter_long_treat = longterm * c

* Gen short term interaction term
gen inter_c_t= ct
replace ct = 0 if date >= 22013

label variable inter_c_t "Lockdown policy (Short Term)"
label variable inter_long_treat "Lockdown policy (Long Term)"
label variable t_all "Total # of Deaths"
label variable cvd "CVD"
label variable injury "Injury"
label variable cancer "Cancer"
label variable lri "Acute Lower Respiratory Infection"
label variable clri "Chronic Lower Respiratory Infection"
label variable other_all "Other Causes"


sum t_all
local t_all_mean = string(r(mean), "%6.3f")
reghdfe t_all inter_c_t inter_long_treat, absorb(i.dsp i.date) vce(cluster citycode)
outreg2 using $output/LongTerm.xls, replace se bracket dec(3) keep(inter_c_t inter_long_treat) addnote("Notes: * significant at 10% ** significant at 5% *** significant at 1%. The standard errors clustered at prefectural level are reported below the estimates. Each cell in the table represents a separate DiD regression. All DSP counties are included in the analysis except 3 from Wuhan. The outcome variable is the number of daily deaths from the DSP counties without inclusion of death tolls for COVID-19. Mortality data used is between January 1 and July 31, 2020 and has been reported by each DSP county by September 28. The explanatory variable for short term lockdown policy is a dummy indicating that, among January 24 to April 7, whether a city where DSP belongs to enforced a lockdown policy on a particular date. The long term explanatory variable is an interaction consists of a dummy indicating whether the DSP has ever locked down, and a time dummy stands for the period after April 8.") addtext(DSP Fixed Effect, "YES", Date Fixed Effect, "YES") addstat(Obs., e(N), Adjusted R-Square, e(r2_a),  # of DSP Counties, 602) nocon nor2 noobs label cttop("Mean = `t_all_mean'") title("Table . The short- and long-term impacts of lockdown on deaths from different causes")

foreach i of varlist cvd injury lri clri cancer other_all{
	sum `i'
	local `i'_mean = string(r(mean), "%6.3f")
    reghdfe `i' inter_c_t inter_long_treat, absorb(i.dsp i.date) vce(cluster citycode)
	outreg2 using $output/LongTerm.xls, append excel se bracket dec(3)  keep(inter_c_t inter_long_treat) addtext(DSP Fixed Effect, "YES", Date Fixed Effect, "YES") addstat(Obs., e(N), Adjusted R-Square, e(r2_a),  # of DSP Counties, e(N_clust)) nocon nor2 noobs label cttop("Mean = ``i'_mean'")
}

******************************
*
* Long-term Event Study
*
******************************

* set directories 
clear all

efolder, cd("$path/output") sub(fig3_tableS3_LongTerm) noc
efolder, cd("$path/output") sub(figures_LongTerm) noc
efolder, cd("$path/output/figures_LongTerm") sub(allfig_eps) noc
efolder, cd("$path/output/figures_LongTerm") sub(allfig_png) noc
efolder, cd("$path/output/figures_LongTerm") sub(fig3) noc
global master $raw_data
global figures $output/figures_LongTerm
global results $output



 * Estimation

	use "$master\y_x_daily.dta", clear
	
		replace other_all = other_all + mental + ckd
		keep if year == 2020
		drop if month >= 8
		replace ct = 0 if ct == . & c == 0
		replace ct = 1 if ct == . & c == 1
		keep countycode date ct
		xtset countycode date
		bysort countycode: gen ct_sum = sum(ct)

		* create var
		* Previously 7 weeks after(0~6), now 23(0~22)
		forvalues i =0/25{
		gen D`i' = 0
		replace D`i' = 1 if ct_sum >=`i'*7+1 & ct_sum<=`i'*7+7
		}
		replace D25 = 1 if ct_sum >= 176

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
		save $results/fig3_tableS3_LongTerm/event_info.dta, replace


		clear
		use "$master\y_x_daily.dta", clear
		keep if year == 2020
		drop if month >= 8
		xtset countycode date
		sort countycode date
		gen week = week(date)
		drop if citycode == 4201
		merge 1:1 countycode date using $results/fig3_tableS3_LongTerm/event_info.dta, nogen
		sort countycode date

		cap erase $results/fig3_tableS3_LongTerm/event.xml
		cap erase $results/fig3_tableS3_LongTerm/event.txt
		foreach i of varlist t_all cvd injury lri{
			qui reghdfe `i' Lead_D7 Lead_D6 Lead_D5 Lead_D4 Lead_D3 Lead_D2 D0 D1 D2 D3 D4 D5 D6 D7 D8 D9 D10 D11 D12 D13 D14 D15 D16 D17 D18 D19 D20 D21 D22 D23 D24 D25 if ct !=., absorb(i.date i.countycode) vce(cluster citycode)
			parmest , saving($results/fig3_tableS3_LongTerm/event_`i'.dta, replace)
			outreg2 using $results/fig3_tableS3_LongTerm/event.xml, dec(3) append bracket nocon nor2 noobs label addstat(Obs., e(N), Adjusted R-Square, e(r2_a),  # of DSP Counties, 602) addtext(DSP Fixed Effect, "YES", Date Fixed Effect, "YES") 
			
		}
		*
		
		
		
		
******************************

 * Creating Figure
 
		clear
		cd $results/fig3_tableS3_LongTerm
		openall, storefilename(fn)

		drop if fn == "event_info.dta"
		keep parm estimate stderr dof t p min95 max95 fn
		
		split fn, p("_")

		gen type = "all" if fn2 == "t"
		replace type = "cvd" if fn2 == "cvd.dta"
		replace type = "injury" if fn2 == "injury.dta"
		replace type = "lri" if fn2 == "lri.dta"

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
			xlab(-7.5 " " -7 "≤ -7" -6 "-6" -5 "-5" -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "6" 7 "7" 8 "8" 9 "9" 10 "10" 11 "11" 12 "12" 13 "13" 14 "14" 15 "15" 16 "16" 17 "17" 18 "18" 19 "19" 20 "20" 21 "21" 22 "22" 23 "23" 24 "24" 25 "25" 25.5 " ", labsize(*0.3) labcolor(black) axis(1) nogrid) ///
			ylabel(, labsize(*0.8) nogrid) ///
			yline(0, lp(dash) lc(khaki)) ///
			xline(-1, lp(dash) lc(khaki)) ///
			title("Panel A. Total # of Deaths", pos(11) size(small)) ///
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
			xlab(-7.5 " " -7 "≤ -7" -6 "-6" -5 "-5" -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "6" 7 "7" 8 "8" 9 "9" 10 "10" 11 "11" 12 "12" 13 "13" 14 "14" 15 "15" 16 "16" 17 "17" 18 "18" 19 "19" 20 "20" 21 "21" 22 "22" 23 "23" 24 "24" 25 "25" 25.5 " ", labsize(*0.3) labcolor(black) axis(1) nogrid) ///
			ylabel(, labsize(*0.8) nogrid) ///
			yline(0, lp(dash) lc(khaki)) ///
			xline(-1, lp(dash) lc(khaki)) ///
			title("Panel B. # of Deaths from CVD", pos(11) size(small)) ///
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
			xlab(-7.5 " " -7 "≤ -7" -6 "-6" -5 "-5" -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "6" 7 "7" 8 "8" 9 "9" 10 "10" 11 "11" 12 "12" 13 "13" 14 "14" 15 "15" 16 "16" 17 "17" 18 "18" 19 "19" 20 "20" 21 "21" 22 "22" 23 "23" 24 "24" 25 "25" 25.5 " ", labsize(*0.3) labcolor(black) axis(1) nogrid) ///
			ylabel(, labsize(*0.8) nogrid) ///
			yline(0, lp(dash) lc(khaki)) ///
			xline(-1, lp(dash) lc(khaki)) ///
			title("Panel C. # of Deaths from Injury", pos(11) size(small)) ///
			xtitle("Weeks", size(*0.8)) ///
			ytitle("Estimated Coefficients", size(*0.8)) ///
			xsize(1.5) ysize(1) ///
			legend(off)
		graph save "$figures/fig3/panelC", replace 		
		restore


		preserve
		*Acute Lower Respiratory Infection
		keep if type == "lri"
		graph twoway (scatter estimate dup2, mcolor(cranberry) mfcolor(white) msize(medsmall)) ///
			(rcap max95 min95 dup2, lcolor(dkorange) lwidth(medthick)) ///
			,scheme(plotplain) ///
			xlab(-7.5 " " -7 "≤ -7" -6 "-6" -5 "-5" -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "6" 7 "7" 8 "8" 9 "9" 10 "10" 11 "11" 12 "12" 13 "13" 14 "14" 15 "15" 16 "16" 17 "17" 18 "18" 19 "19" 20 "20" 21 "21" 22 "22" 23 "23" 24 "24" 25 "25" 25.5 " ", labsize(*0.3) labcolor(black) axis(1) nogrid) ///
			ylabel(, labsize(*0.8) nogrid) ///
			yline(0, lp(dash) lc(khaki)) ///
			xline(-1, lp(dash) lc(khaki)) ///
			title("Panel D. # of Deaths from Acute Lower Respiratory Infection", pos(11) size(small)) ///
			xtitle("Weeks", size(*0.8)) ///
			ytitle("Estimated Coefficients", size(*0.8)) ///
			xsize(1.5) ysize(1) ///
			legend(off)
		graph save "$figures/fig3/panelD", replace 		
		restore

		graph combine "$figures/fig3/panelA" "$figures/fig3/panelB" "$figures/fig3/panelC" "$figures/fig3/panelD", graphregion(fcolor(white)  lcolor(white)) imargin(small) iscale(0.77) fysize(100) fxsize(150) xsize(9) ysize(6.5)

		graph save "$figures/fig3/fig3", replace 
		graph export "$figures/allfig_eps/fig3.eps", replace
		graph export "$figures/allfig_png/fig3.png", replace		


******************************
*
* PSMDiD
*
******************************
use $raw_data/PSM, clear

* globalling controls used for matching.
global matching gdppc urb_ratio mig_ratio lntotpop

rename c treat

cap teffects nnmatch ($matching) (treat), osample(missing) 
tab missing
drop if missing==1 | missing ==.
drop missing

cap teffects nnmatch ($matching) (treat), osample(missing) 
tab missing
drop if missing==1 
drop missing

teffects nnmatch ($matching) (treat), generate(nnm)
keep countycode $matching treat nnm*

gen obs_number = _n
order obs_number 

save $temp_data/nnm_fulldata, replace // save the complete data set
keep if treat == 1 // keep just the treated group
keep nnm1 // keep just the match1 variable (the observation numbers of their matches)
bysort nnm1: gen weight=_N // count how many times each control observation is a match
bysort nnm1: keep if _n == 1 // keep just one row per control observation
rename nnm1 obs_number //rename for merging purposes

merge 1:m obs_number using $temp_data/nnm_fulldata.dta // merge back into the full data
replace weight=1 if treat == 1 // set weight to 1 for treated observations

keep if _merge == 3 | treat == 1

keep countycode weight treat 
save $temp_data/nnm_indicator, replace // save the nearest neighbor matching indicator (tell us which gb_code_2010 should be kept and weights)

use $raw_data/y_x_daily, clear
merge m:1 countycode using $temp_data/nnm_indicator.dta    // perform the key matching process
keep if _merge == 3
drop _merge

keep if year == 2020
drop if year == 2020 & (month >= 5 | (month == 4 & day >= 8))
drop if citycode == 4201

rename countycode dsp
xtset dsp date

replace other_all = other_all + mental + ckd + diabetes + inf_dis
gen inter_c_t= ct

label variable inter_c_t "Lockdown policy"
label variable t_all "Total # of Deaths"
label variable cvd "CVD"
label variable injury "Injury"
label variable lri "Acute Lower Respiratory Infection"
label variable clri "Chronic Lower Respiratory Infection"
label variable cancer "Cancer"
label variable other_all "Other Causes"

* check the number of DSP included in the PSMDiD
codebook dsp

sum t_all
local t_all_mean = string(r(mean), "%6.3f")
reghdfe t_all inter_c_t if year == 2020 [w = weight], absorb(i.dsp i.date) vce(cluster citycode)
outreg2 using $output/PSMDID.xls, replace se bracket dec(3) keep(inter_c_t) addnote("Notes: Counties are matched using nearest neighborhood matching method. We use total population, ratio of people living in urban area, ratio of migrant, GDP per capita, and hospital bed per capita at the prefectural level as matching variables. The standard errors clustered at the prefectural level are reported below the estimates. Each cell in the table represents a separate DiD regression. All matched DSP counties are included in the analysis except 3 from Wuhan. The outcome variable is the number of daily deaths from the DSP counties without inclusion of death tolls for COVID-19. Mortality data used is between January 1 2020 and April 7, 2020 and has been reported by each DSP county by September 28. The explanatory variable is a dummy indicating whether a city where DSP belongs to enforced a lockdown policy on a particular date. * significant at 10% ** significant at 5% *** significant at 1%.") addtext(DSP Fixed Effect, "YES", Date Fixed Effect, "YES") addstat(Obs., e(N), Adjusted R-Square, e(r2_a),  # of DSP Counties, 538) nocon nor2 noobs label cttop("Mean = `t_all_mean'") title("Adjusted Table . Propensity score matching DiD")

foreach i of varlist cvd injury lri clri cancer other_all{
	sum `i'
	local `i'_mean = string(r(mean), "%6.3f")
    reghdfe `i' inter_c_t if year == 2020 [w = weight], absorb(i.dsp i.date) vce(cluster citycode)
	outreg2 using $output/PSMDID.xls, append excel se bracket dec(3)  keep(inter_c_t) addtext(DSP Fixed Effect, "YES", Date Fixed Effect, "YES") addstat(Obs., e(N), Adjusted R-Square, e(r2_a),  # of DSP Counties, 538) nocon nor2 noobs label cttop("Mean = ``i'_mean'")
}



*****************************
*
* Policy Independence
*
*****************************

* We want to clarify the lockdown decision (when to conduct lockdown) is independent on local non-COVID mortality.

use $raw_data/y_x_daily, clear

* Generate dead rate last year
foreach i of varlist $deadnum{

replace `i' = `i'
gen `i'_jan = `i' if year == 2020 & month == 1 & day < 23
replace `i'_jan = 0 if `i'_jan == .
bysort countycode: egen `i'_jan_ = sum(`i'_jan)
replace `i'_jan = `i'_jan_
replace `i'_jan = `i'_jan / (pop_total / 1000)
egen `i'_jan_mean = mean(`i'_jan)
replace `i'_jan = `i'_jan - `i'_jan_mean
drop `i'_jan_

}

* Generate a variable indicating how many days has a county imposed lockdown policy
bysort countycode: gen policy_day = sum(ct)

* Generate max confirmed cases
bysort countycode: egen confirmed_max = max(confirmed)
replace confirmed_max = confirmed_max / 1000

* Generate mean demographic variables
* PM2.5 may have some pre-trend decrease, so we use data before January 15. 
replace pm25 = . if year == 2019 | (year == 2020 & month >= 2) | (year == 2020 & month == 1 & day >= 15)
bysort countycode: egen pm25_mean = mean(pm25)
bysort provcode: egen pm25_provmean = mean(pm25)
replace pm25_mean = pm25_provmean if pm25_mean == .


* replace missing GDP per capita and hospital bed using province-mean hospital bed
bysort provcode: egen gdppc_mean = mean(gdppc)
replace gdppc = gdppc_mean if gdppc == .
bysort provcode: egen hospital_bed_mean = mean(hospital_bed)
replace hospital_bed = hospital_bed_mean if hospital_bed == .

drop if citycode == 4201
duplicates drop countycode, force

tsset countycode date

xi: reg c cvd_jan injury_jan lri_jan confirmed_max gdppc hospital_bed pm25_mean i.provcode, r
outreg2 using $output/PolicyDependency.xls, replace se bracket dec(3) addnote("Notes: * significant at 10% ** significant at 5% *** significant at 1%. Robustness standard error is used. All DSP counties are included in the analysis except the three in Wuhan. The outcome variable is a dummy indicating whether a city where DSP belongs to enforced a lockdown policy. Mortality data is recorded before September 28, 2020. GDP per capita, hospital bed per capita and 2020 mean PM2.5 concentrations, and province dummies are controlled in the regression.") keep(cvd_jan injury_jan lri_jan confirmed_max) addstat(Obs., e(N), Adjusted R-Square, e(r2),  # of DSP Counties, e(N)) nocon nor2 noobs label title("Examine endogeneity problem with policy enforcement")




******************************
*
* Figure S1
*
******************************
* Figure S1. Timing of Lockdown

use $raw_data/y_x_daily.dta, clear
xtset countycode date
gen l1c12t = L1.c12t
gen new12 = 1 if l1c12t == 0 & c12t == 1
replace new12 = 0 if new12 == .
gen l1lockdown_t = L1.lockdown_t
gen newld = 1 if l1lockdown_t == 0 & lockdown_t == 1
replace newld = 0 if newld == .
bysort date: egen newly_enforced_c12t = sum(new12)
bysort date: egen newly_enforced_lockdown_t = sum(newld)
keep if date >= 21934 & date <= 21965
format date %td
twoway (line newly_enforced_lockdown_t date, lc(dknavy)) (line newly_enforced_c12t date, lc(eltblue) lp(dash)), legend( label(1 "City Lockdown") label(2 "Community Lockdown")) ytitle("Num of Newly Lockdown") ///
scheme(vg_outc)
graph export "output/FS1.png", replace
