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
* Memo
*
********************************************************************************

	use "$data/main.dta", clear

		keep if year == 2020
		keep if month == 1 | month == 2 | month == 3 | (month <= 7)
		drop if citycode == 4201
		
		egen total_death = sum(t_all)
		sum total_death
		

		/* 
		County	population	deaths	deaths/per population	If China
		United States	331002647	157823	0.000476803	686,274
		United Kingdom	68059863	41242	0.000605967	872,182
		Sweden	10327589	5721	0.000553953	797,318
		China	1439323774	4636	3.22096E-06	4636
		/*
