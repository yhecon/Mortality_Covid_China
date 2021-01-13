

******************************
*
* Table S1: Summary Statistics
*
******************************

	use "$master/y_x_daily.dta", clear
	
			
		preserve
		keep if year == 2020
		drop if citycode == 4201
		drop if year == 2020 & month == 3 & day >= 15
		
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

		foreach i of varlist t_all cvd injury pneumonia inf_dis cancer diabetes res other_all pm25 prsmean winsmean temmean rhumean  hospital_bed gdppc secondary_ratio tertiary_ratio {

		

		sum `i'
		}
