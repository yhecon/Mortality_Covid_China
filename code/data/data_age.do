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
* Data Create: Age
*
********************************************************************************

	use $data/raw_data/y_x_daily_agegroup.dta, clear
	
	cap drop dsp
	rename code dsp
	rename deaddate1 date
	xtset dsp date

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

	save $data/age.dta, replace