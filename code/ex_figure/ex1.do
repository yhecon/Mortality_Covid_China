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
* Extended Fig 1: Covid in China
*
********************************************************************************

	use "$data\case_data/covid.dta", clear
	
	drop if year == 2020 & month >= 4
	drop if city_code == 4201

	gen date = mdy(month, day, year)
	format date %td	
	
	collapse (sum) cur case death c_cure, by(date)
			
	graph  twoway (area cur date, fcolor(blue*0.4) lcolor(blue*0.4)) ///
			(area c_cure date, fcolor(orange*0.4) lcolor(orange*0.4)) ///
			(area death date, fcolor(red*0.7) lcolor(red*0.7)) ///
			(line case date, lcolor(blue*0.8) lpattern(dash_dot)) ///
			(line cur date if date >= 21968, lcolor(blue*0.3) lpattern(shortdash)) ///
			,xlabel(21915 "1 Jan" 21937 "23 Jan" 21955 "10 Feb" 21975 "1 Mar" 22006 "1 Apr" 22012 " ",nogrid) ///
			ylabel(0 "       0"  10000 20000 30000 40000,nogrid) ///
			title("A. COVID-19 Confirmed, Active, Recovered, and Deaths", position(11) size(3.5)) ///			
			legend(order(1 2 3 4) label(1 "Active") label(2 "Recovered") label(3 "Deaths") label(4 "Confirmed") ring(0) pos(11) rowgap(0.5)) ///
			xtitle("Date", size(2.7)) ytitle("Number of COVID-19", axis(1))  scheme(plotplain) 
				
		graph save "$figure/ex1/ex1A", replace
		
********************************************************************************
	
	use "$data/case_data/covid.dta", clear
	
	drop if year == 2020 & month >= 4
	drop if city_code == 4201

	gen date = mdy(month, day, year)
	format date %td

	tab city_code, gen(city)
	for num 1/329: gen c_caseX = case if cityX == 1	
	
	gen cityid = 0
	for num 1/329: replace cityid = X if cityX == 1	
		
		
	graph twoway /*
		*/   (line c_case3 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case4 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case5 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case6 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case7 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case8 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case9 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case10 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case11 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case12 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case13 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case14 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case15 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case16 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case17 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case18 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case19 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case20 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case21 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case22 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case23 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case24 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case25 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case26 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case27 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case28 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case29 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case30 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case31 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case32 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case33 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case34 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case35 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case36 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case37 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case38 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case39 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case40 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case41 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case42 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case43 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case44 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case45 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case46 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case47 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case48 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case49 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case50 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case51 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case52 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case53 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case54 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case55 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case56 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case57 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case58 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case59 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case60 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case61 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case62 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case63 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case64 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case65 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case66 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case67 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case68 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case69 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case70 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case73 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case74 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case75 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case76 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case77 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case78 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case79 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case80 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case81 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case82 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case83 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case84 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case85 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case86 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case87 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case88 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case89 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case90 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case91 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case92 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case93 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case94 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case95 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case96 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case97 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case98 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case99 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case100 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case101 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case102 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case103 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case104 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case105 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case106 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case107 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case108 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case109 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case110 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case111 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case112 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case113 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case114 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case115 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case116 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case117 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case118 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case119 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case120 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case121 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case122 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case123 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case124 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case125 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case126 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case127 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case128 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case129 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case130 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case131 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case132 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case133 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case134 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case135 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case136 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case137 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case138 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case139 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case140 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case141 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case142 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case143 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case144 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case145 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case146 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case147 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case148 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case149 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case150 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case151 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case152 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case153 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case154 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case155 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case156 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case157 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case158 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case159 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case160 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case161 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case162 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case163 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case164 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case177 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case178 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case179 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case180 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case181 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case182 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case183 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case184 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case185 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case186 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case187 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case188 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case189 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case190 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case191 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case192 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case193 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case194 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case195 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case196 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case197 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case198 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case199 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case200 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case201 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case202 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case203 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case204 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case205 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case206 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case207 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case208 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case209 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case210 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case211 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case212 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case213 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case214 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case215 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case216 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case217 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case218 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case219 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case220 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case221 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case222 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case223 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case224 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case225 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case226 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case227 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case228 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case229 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case230 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case231 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case232 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case233 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case234 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case235 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case236 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case237 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case238 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case239 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case240 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case241 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case242 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case243 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case244 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case245 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case246 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case247 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case248 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case249 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case250 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case251 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case252 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case253 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case254 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case255 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case256 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case257 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case258 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case259 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case260 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case261 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case262 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case263 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case264 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case265 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case266 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case267 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case268 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case269 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case270 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case271 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case272 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case273 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case274 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case275 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case276 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case277 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case278 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case279 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case280 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case281 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case282 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case283 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case284 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case285 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case286 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case287 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case288 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case289 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case290 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case291 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case292 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case293 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case294 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case295 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case296 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case297 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case298 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case299 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case300 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case301 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case302 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case303 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case304 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case305 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case306 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case307 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case308 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case309 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case310 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case311 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case312 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case313 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case314 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case315 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case316 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case317 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case318 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case319 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case320 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case321 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case322 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case323 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case324 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case325 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case326 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case327 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case328 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case329 date, lcolor(black*0.3) lwidth(thin) lpattern(solid))    /*
		
		*/   (line c_case165 date if prov_code == 42, lcolor(blue) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case166 date if prov_code == 42, lcolor(blue) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case167 date if prov_code == 42, lcolor(blue) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case168 date if prov_code == 42, lcolor(blue) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case169 date if prov_code == 42, lcolor(blue) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case170 date if prov_code == 42, lcolor(blue) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case171 date if prov_code == 42, lcolor(blue) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case172 date if prov_code == 42, lcolor(blue) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case173 date if prov_code == 42, lcolor(blue) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case174 date if prov_code == 42, lcolor(blue) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case175 date if prov_code == 42, lcolor(blue) lwidth(thin) lpattern(solid))    /*
		*/   (line c_case176 date if prov_code == 42, lcolor(blue) lwidth(thin) lpattern(solid))    /*
		
		
		*/   (line c_case71 date, lcolor(black*0.3) lwidth(med) lpattern(solid) lcolor(red)) /*
		*/   (line c_case72 date, lcolor(black*0.3) lwidth(med) lpattern(solid) lcolor(red)) /*
		*/   (line c_case1 date, lcolor(black*0.3) lwidth(med) lpattern(solid) lcolor(red))  /*
		*/   (line c_case2 date, lcolor(black*0.3) lwidth(med) lpattern(solid) lcolor(red))  /*

				*/ , xlabel(21915 "1 Jan" 21937 "23 Jan" 21955 "10 Feb" 21975 "1 Mar" 22006 "1 Apr" 22012 " ", nogrid)  /*
				*/ xscale(range(21915 22022)) /*
				*/ ylabel(0 "       0"  1000 2000 3000 4000 5000, nogrid) /*
				*/ yscale(range(-200 4000)) /*
				*/ xline(21965,lpattern(shortdash) lwidth(vthin) lcolor(gray)) /*
				*/ text(3900 21966 "*Classification" "Changed", place(e) size(2) color(gray)) /*
				*/ text(3518 22012 "Xiaogan", place(e) size(2) color(blue)) text(2907 22012 "Huanggang", place(e) size(2) color(blue))/*
				*/ text(1580 22012 "Jingzhou", place(e) size(2) color(blue)) text(1394 22012 "Ezhou", place(e) size(2) color(blue))  /*
				*/ text(1175 22012 "Xiangfan", place(e) size(2) color(blue))  /*
				*/ text(928 22012 "Jingmen", place(e) size(2) color(blue)) text(672 22012 "Shiyan", place(e) size(2) color(blue))  /*
				*/ text(465 22012 "Beijing", place(e) size(2) color(red)) text(352 22012 "Shanghai", place(e) size(2) color(red))  /*
				*/ text(190 22012 "Tianjin", place(e) size(2) color(red)) text(60 22012 "Nanjing", place(e) size(2) color(red))  /*
				*/ title("B. Confirmed COVID-19 Cases in Each City", position(11) size(3.5)) /*
				*/ xtitle("Date", size(2.7)) ytitle("Confirmed Cases in Each City") scheme(plotplain) /*
				*/ legend(order(320) label(320 "Cities in Hubei") ring(0) pos(11) rowgap(0.5)) 
				
		graph save "$figure/ex1/ex1B", replace
			

********************************************************************************
		
	use "$data/main.dta", clear
	
	keep if date >= 21934
	drop if year == 2020 & month >= 4
	drop if citycode == 4201
	
	sort dsp date
	
	gen new12 = 1 if l.c12t == 0 & c12t == 1
	replace new12 = 0 if new12 == .
	
	gen newld = 1 if l.lockdown_t == 0 & lockdown_t == 1
	replace newld = 0 if newld == .
	
	format date %td
	
	collapse (sum) new12 newld, by(date)
	
	graph twoway (line new12 date, lc(red*1.5)) (line newld date, lc(blue*1.5)) /// 
			,legend(label(1 "Community Lockdown") label(2 "City Lockdown") rowgap(0.5)) ///
			ytitle("Number of New Lockdowns") ///
			xtitle("Date", size(2.7)) ///
			title("C. Timing of City/Community Lockdowns", position(11) size(3.5)) ///
			xlabel(21915 "1 Jan" 21937 "23 Jan" 21955 "10 Feb" 21975 "1 Mar" 22006 "1 Apr" 22012 " ", nogrid) ///
			ylabel(0 "       0"  20 40 60 80 100, nogrid) ///
			scheme(plotplain) legend(ring(0) pos(2))
				
		graph save "$figure/ex1/ex1C", replace
	
*******************************************************************************
	
	use "$data/main", clear
	
	keep if date >= 21934
	drop if year == 2020 & month >= 4
	drop if citycode == 4201
	
	bys citycode date : gen dup = _n
	duplicates drop citycode date, force
	
	
	xtset citycode date
	gen lastcase_city_ = confirmed if lockdown_t == 0 & f.lockdown_t == 1
	egen lastcase_city = max(lastcase_city_), by(citycode)
		
		collapse lastcase_city, by(citycode)
		tab lastcase_city
		recode lastcase_city (min/10 = 0) (11/20 = 1) (21/30 = 2) (31/40 = 3) (41/50 = 4) (51/60 = 5) (61/70 = 6) (71/80 = 7) (81/90 = 8) (91/100 =9) (101/150 = 10) (151/200 = 11) (201/300 = 12) (301/500 = 13) (501/max = 14) , generate(cat_city)
		
		hist cat_city, lcolor(white) color(blue*0.4) ///
		legend(label(1 "City Lockdown")) ///
		xtitle("Confirmed COVID-19 Cases a Day Before the Lockdown", size(2.7)) ///
		ytitle("Number of Cities") ///
		title("D. COVID-19 Before the City Lockdowns", position(11) size(3.5)) ///
		xlabel( 0.5 "~10" 1.5 "~20" 2.5 "~30" 3.5 "~40" 4.5 "~50" 5.5 "~60" 6.5 "~70" 7.5 "~80" 8.5 "~90" 9.5 "~100" 10.5 "~150" 11.5 "~200" 12.5 "~300" 13.5 "~500" 14.5 "501~" 15 " ", labsize(2.2) nogrid) ///
		xscale(range(0 16.5)) ///
		ylabel(0 "       0" 10 20 30 40 50,nogrid) legend(ring(0) pos(2)) scheme(plotplain)  frequency width(1) start(0)
		
		graph save "$figure/ex1/ex1D", replace
			
*******************************************************************************
	
		graph combine "$figure/ex1/ex1A" "$figure/ex1/ex1B" "$figure/ex1/ex1C" "$figure/ex1/ex1D", ////
				graphregion(fcolor(white) lcolor(white)) imargin(3 3 3 3) col(2) iscale(0.6) xsize(17) ysize(12)
		graph save "$figure\ex1\ex1",replace
	
		graph export "$figure\allfig_png\ex1.png", replace width(3000)
		graph export "$figure\allfig_eps\ex1.eps", replace 
					