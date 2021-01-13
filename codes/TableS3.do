
******************************
*
* Table S3: Cause Specific Mortality
*
******************************

	use "$master/y_x_daily.dta", clear
	
	*=======
	* CVD
	*=======

		preserve
		keep if year == 2020
		drop if year == 2020 & month == 3 & day >= 15
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
		reghdfe cvd inter_c_t if year == 2020, absorb(i.dsp i.date) vce(cluster dsp)
		outreg2 using $results/tableS3/tableS3.xls, replace se bracket dec(3) keep(inter_c_t) addnote("Notes: * significant at 10% ** significant at 5% *** significant at 1%. The standard errors clustered at the DSP level are reported below the estimates. Each cell in the table represents a separate DiD regression. All DSP counties are included in the analysis except 3 from Wuhan. The outcome variable is the number of daily deaths from the DSP counties without inclusion of death tolls for COVID-19. Mortality data used is between 1st Jan. and 14th Mar. 2020 and has been reported by each DSP county by 15th May. The explanatory variable is a dummy indicating whether a city where DSP belongs to enforced a lockdown policy on a particular date.") addtext( DSP Fixed Effect, "YES", Date Fixed Effect, "YES") addstat(Obs., e(N), Adjusted R-Square, e(r2_a),  # of DSP Counties, e(N_clust)) nocon nor2 noobs label cttop("Mean = `cvd_mean'") title("Appendix Table 1. The Impacts of City Lockdown on Deaths of Cardiovascular Diseases")

		foreach i of varlist mi stroke other_cvd{
			sum `i'
			local `i'_mean = string(r(mean), "%6.3f")
			reghdfe `i' inter_c_t if year == 2020, absorb(i.dsp i.date) vce(cluster dsp)
			outreg2 using $results/tableS3/tableS3.xls, append excel se bracket dec(3)  keep(inter_c_t) addtext(DSP Fixed Effect, "YES", Date Fixed Effect, "YES") addstat(Obs., e(N), Adjusted R-Square, e(r2_a),  # of DSP Counties, e(N_clust)) nocon nor2 noobs label cttop("Mean = ``i'_mean'")
		}
		restore

	*=======
	* Injury
	*=======

		preserve
		keep if year == 2020
		drop if year == 2020 & month == 3 & day >= 15
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
		reghdfe injury inter_c_t if year == 2020, absorb(i.dsp i.date) vce(cluster dsp)
		outreg2 using $results/tableS3/tableS3.xls, append se bracket dec(3) keep(inter_c_t) addnote("Notes: * significant at 10% ** significant at 5% *** significant at 1%. The standard errors clustered at the DSP level are reported below the estimates. Each cell in the table represents a separate DiD regression. All DSP counties are included in the analysis except 3 from Wuhan. The outcome variable is the number of daily deaths from the DSP counties without inclusion of death tolls for COVID-19. Mortality data used is between 1st Jan. and 14th Mar. 2020 and has been reported by each DSP county by 15th May. The explanatory variable is a dummy indicating whether a city where DSP belongs to enforced a lockdown policy on a particular date.") addtext( DSP Fixed Effect, "YES", Date Fixed Effect, "YES") addstat(Obs., e(N), Adjusted R-Square, e(r2_a),  # of DSP Counties, e(N_clust)) nocon nor2 noobs label cttop("Mean = `injury_mean'") title("Appendix Table. The Impacts of City Lockdown on Deaths of Injuries")

		foreach i of varlist traffic other_injury suicide{
			sum `i'
			local `i'_mean = string(r(mean), "%6.3f")
			reghdfe `i' inter_c_t if year == 2020, absorb(i.dsp i.date) vce(cluster dsp)
			outreg2 using $results/tableS3/tableS3.xls, append excel se bracket dec(3)  keep(inter_c_t) addtext(DSP Fixed Effect, "YES", Date Fixed Effect, "YES") addstat(Obs., e(N), Adjusted R-Square, e(r2_a),  # of DSP Counties, e(N_clust)) nocon nor2 noobs label cttop("Mean = ``i'_mean'")
		}

		restore

	*===========
	* Pneumonia
	*===========
	
		preserve

		keep if year == 2020
		drop if year == 2020 & month == 3 & day >= 15
		drop if citycode == 4201

		rename countycode dsp
		xtset dsp date

		gen inter_c_t= ct

		gen pneumonia_212223 = pneumonia_21 + pneumonia_22 + pneumonia_23
		gen other_pneumonia = pneumonia - pneumonia_24 - pneumonia_212223

		label variable inter_c_t "Lockdown policy"
		label variable t_all "Total"
		label variable pneumonia "Pneumonia"
		label variable pneumonia_212223 "Viral & Bacterial Pneumonia"
		label variable pneumonia_24 "Pneumonia Organism"
		label variable other_pneumonia "Pulmonary Infection"


		sum pneumonia
		local pneumonia_mean = string(r(mean), "%6.3f")
		reghdfe pneumonia inter_c_t if year == 2020, absorb(i.dsp i.date) vce(cluster dsp)
		outreg2 using $results/tableS3/tableS3.xls, append se bracket dec(3) keep(inter_c_t) addnote("Notes: * significant at 10% ** significant at 5% *** significant at 1%. The standard errors clustered at the DSP level are reported below the estimates. Each cell in the table represents a separate DiD regression. All DSP counties are included in the analysis except 3 from Wuhan. The outcome variable is the number of daily deaths from the DSP counties without inclusion of death tolls for COVID-19. Mortality data used is between 1st Jan. and 14th Mar. 2020 and has been reported by each DSP county by 15th May. The explanatory variable is a dummy indicating whether a city where DSP belongs to enforced a lockdown policy on a particular date.") addtext( DSP Fixed Effect, "YES", Date Fixed Effect, "YES") addstat(Obs., e(N), Adjusted R-Square, e(r2_a),  # of DSP Counties, e(N_clust)) nocon nor2 noobs label cttop("Mean = `pneumonia_mean'") title("Appendix Table. The Impacts of City Lockdown on Deaths of Injuries")

		foreach i of varlist pneumonia_24 pneumonia_212223 other_pneumonia{
			sum `i'
			local `i'_mean = string(r(mean), "%6.3f")
			reghdfe `i' inter_c_t if year == 2020, absorb(i.dsp i.date) vce(cluster dsp)
			outreg2 using $results/tableS3/tableS3.xls, append excel se bracket dec(3)  keep(inter_c_t) addtext(DSP Fixed Effect, "YES", Date Fixed Effect, "YES") addstat(Obs., e(N), Adjusted R-Square, e(r2_a),  # of DSP Counties, e(N_clust)) nocon nor2 noobs label cttop("Mean = ``i'_mean'")
		}

		restore
			
