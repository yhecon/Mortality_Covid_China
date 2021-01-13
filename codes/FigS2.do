

******************************
*
* Fig S2
*
******************************

	use "$master/case_data/covid.dta", clear
	
	drop if year == 2020 & month == 3 & day >= 15
	drop if year == 2020 & month == 4
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

		

				*/ , xlabel(21915 "01jan" 21937 "23jan" 21955 "10feb" 21975 "01mar" 21988 "14mar" 22000 " ",nogrid) /*
				*/ ylabel(,nogrid) legend(ring(0) pos(11) order(320) lab(320 "Cities in Hubei Province")) /*
				*/ xline(21965,lpattern(shortdash) lwidth(vthin) lcolor(gray)) /*
				*/ text(3900 21966 "*Classification" "Changed", place(e) size(2) color(gray)) /*
				*/ text(3518 21990 "Xiaogan", place(e) size(2.5) color(blue)) text(2907 21990 "Huanggang", place(e) size(2.5) color(blue))/*
				*/ text(1580 21990 "Jingzhou", place(e) size(2.5) color(blue)) text(1394 21990 "Ezhou", place(e) size(2.5) color(blue))  /*
				*/ text(1175 21990 "Xiangfan", place(e) size(2.5) color(blue))  /*
				*/ text(928 21990 "Jingmen", place(e) size(2.5) color(blue)) text(672 21990 "Shiyan", place(e) size(2.5) color(blue))  /*
				*/ text(465 21990 "Beijing", place(e) size(2.5) color(red)) text(352 21990 "Shanghai", place(e) size(2.5) color(red))  /*
				*/ text(190 21990 "Tianjin", place(e) size(2.5) color(red)) text(60 21990 "Nanjing", place(e) size(2.5) color(red))  /*
				*/ title("B. Confirmed COVID-19 Cases in Each City", position(11) size(4)) /*
				*/ xtitle("") ytitle("Confirmed Cases in Each City") scheme(plotplain) 
				
		graph save "$figures/figS2/panelB", replace
			
			
		/*
		xiaogan 171 3518
		huanggang 173 2907
		Wuzhou 172 1580
		Ezhou 169 1394
		Huangshi 165 1015
		Xiangfan 168 1175
		Dalian 170 928 
		Shiyan 166 672
		*/


		egen casemax = max(case), by(city_code)
		bys city_code: gen first = _n


********************************************************************************

		
		
	use "$master\y_x_daily.dta", clear
	drop if citycode == 4201
	
	xtset countycode date
	gen startcom = 0
	replace startcom = 1 if c12t == 1 & l.c12t == 0
	gen startcity = 0
	replace startcity = 1 if lockdown_t == 1 & l.lockdown_t == 0
	
	collapse (sum) c12t lockdown_t startcom startcity, by(date)
			
	save "$master/case_data/lockdown.dta", replace
	
	
	use "$master\case_data/covid.dta", clear
	
	drop if year == 2020 & month == 3 & day >= 15
	drop if year == 2020 & month == 4
	drop if city_code == 4201

	gen date = mdy(month, day, year)
	format date %td
	
	
	collapse (sum) cur case death c_cure, by(date)
	
	merge 1:1 date using "$master/case_data/lockdown.dta"
	drop if _merge == 2
	drop _merge
		
	graph  twoway (bar startcom date, lcolor(white) fcolor(red*0.2) yaxis(2)) ///
			(bar startcity date, lcolor(white) fcolor(red*0.4) yaxis(2)) ///
			(line case date, lcolor(blue*1.5) lpattern(solid) yaxis(1) yscale(alt) yscale(alt axis(2))) ///
			(line cur date, lcolor(blue*1.5) lpattern(dash_dot)) ///
			(line c_cure date, lcolor(blue*1.5) lpattern(shortdash)) ///
			(line death date, lcolor(blue*1.5) lpattern(dash)) ///
			, xlabel(21915 "01jan" 21929 "15jan" 21937 "23jan" 21955 "10feb" 21975 "01mar" 21988 "14mar" 21990 " ",nogrid) ///
			ylabel(0 (10000) 33000,nogrid) ///
			text(31000 21980 "Confirmed", place(e) size(2.4) color(blue*1.5)) text(24000 21980 "Recovered", place(e) size(2.4) color(blue*1.5)) ///
			text(6000 21980 "Active", place(e) size(2.4) color(blue*1.5)) text(2000 21970 "Deaths", place(e) size(2.4) color(blue*1.5)) ///
			title("A. COVID-19 Confirmed, Active, Recovered, and Deaths", position(11) size(4)) ///			
			legend(order (1 2 ) label(1 "Community Lockdown")  label(2 "City Lockdown")  ring(0) pos(11)) ///
			xtitle("") ytitle("Number of COVID-19", axis(1))  scheme(plotplain) ytitle("Number of Lockdowns Initiated", axis(2))
			
		graph save "$figures/figS2/panelA", replace
			
			
			graph combine "$figures/figS2/panelA" "$figures/figS2/panelB" , graphregion(margin(vtiny)) xsize(6) ysize(8.4) cols(1) 
			graph save "$figures/figS2/figS2", replace
			
			
		graph export "$figures/figS2.eps", replace
		graph export "$figures/figS2.png", replace

		
			

	
