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

local TNK 1
local YHN 0

if `TNK'==1{
	global dir= "C:\Users\takan\Dropbox\Covid_Mortality\Replication\Nat_HB_RR1"
}

if `YHN'==1{
	global dir= "C:\Users\ypanam\Dropbox\Research\Covid_Mortality\Replication\Nat_HB_RR1\"
}

global data "$dir/data"
global table "$dir/table"
global figure  "$dir/figure"

********************************************************************************
*
* Table S1: Summary Statistics
*
********************************************************************************
	
	use "$data/main.dta", clear
		
		keep if year == 2020
		keep if month == 1 | month == 2 | month == 3 | (month == 4 & day <= 7)
		drop if citycode == 4201
		
		count if t_all != other_all + injury + cvd + cancer +  res + pneumonia

		foreach i of varlist gdppc hospital_bed secondary_ratio aqi pm25 pm10{

		bysort year provcode: egen `i'_provmean = mean(`i')
		replace `i' = `i'_provmean if `i' == .

		}

		replace gdppc = gdppc / 10000 //per 10,000 RMB
		replace pop_total = pop_total / 10000 //per 10,000 people
		replace hospital_bed = hospital_bed * 1000
		replace primary_ratio = primary_ratio * 100 //%
		replace secondary_ratio = secondary_ratio * 100 //%
		replace tertiary_ratio = tertiary_ratio * 100 //%

		bysort dsp: egen confirmed_max = max(confirmed)
		replace confirmed = confirmed_max

		foreach i of varlist t_all cvd injury lri clri inf_dis cancer diabetes res other_all gdppc hospital_bed secondary_ratio aqi pm25 pm10 {

		sum `i'
		local `i'_mean = string(r(mean), "%6.2f")
		local `i'_sd = string(r(sd), "%6.2f")

		}

		duplicates drop dsp, force
		local N = _N

		local cvd_name = "CVD"
		local cancer_name = "Neoplasms"
		local lri_name = "Acute lower respiratory infection"
		local clri_name = "Chronic lower respiratory infection"
		local injury_name = "Injury"
		local inf_dis_name = "Infectious diseases"
		local other_all_name = "Others"
		local aqi_name = "Air Quality Index"
		local pm25_name = "PM2.5 Concentration(μg/m³)"
		local pm10_name = "PM10 Concentration(μg/m³)"
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
		foreach i of varlist gdppc hospital_bed secondary_ratio aqi pm25 pm10 {
		post `sumstats' ("") ("``i'_name'") ("``i'_mean'") ("[" + "``i'_sd'" + "]")
		}
		post `sumstats' ("") ("") ("") ("")
		post `sumstats' ("") ("# of DSP counties") ("`N'") ("")
		postclose `sumstats'

		use `appendix', clear
		export excel using "$table/tableS1/TableS1", replace firstrow(variables)
