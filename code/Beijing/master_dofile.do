********************************************************************************
*   
* Program: The Impacts of City and Community Lockdowns on Non-COVID-19 Deaths 
*          Outside Wuhan, China 
* Author: Qi et al.
* Updated Date: 2020.02.19
*   
********************************************************************************


************************************************
* (1)Install these pkgs if not installed yet:  *
************************************************

* ssc install efolder, replace
* ssc install ftools, replace
* ssc install reghdfe, replace
* ssc install carryforward, replace
* ssc install psmatch2, replace
* ssc install parmest, replace
* ssc install openall, replace

************************************************
*                                              *
* (2)                                          *
* To run this program, please use Stata16.     *
* UTF-8 encoding is used.                      *
*                                              *
************************************************


clear all
set more off
cap log close
graph set window fontface "Times New Roman"


*************************************************
* (3)Change the file path:                      *
*************************************************

*====================================================================*
*====================================================================*
global path "C:\Users\z1343\Desktop\ThinkingZhang\Works\cdc\NatureHB_SubmitVersion\outcome" //=*
global root "C:\Users\z1343\Desktop\ThinkingZhang\Works\cdc\NatureHB_SubmitVersion\outcome" //=*
*====================================================================*
*====================================================================*


cd $path

log using "logfile/COVID_Mortality.log",replace
global dofiles = "$root/dofile"
global raw_data = "$root/rawdata"
global working_data = "$root/working_data"
global temp_data = "$root/temporary"
global output = "$root/output"


global deadnum t_all total cvd injury mental inf_dis ckd res cancer diabetes other_all  mi stroke_h stroke_i traffic suicide other_injury copd clri influ lri

global deadnum_without_t_all total cvd injury mental inf_dis ckd res cancer diabetes  other_all  mi stroke_h stroke_i traffic suicide other_injury copd clri influ lri

global deadnum_agegroup1 t_all_agegroup1 total_agegroup1 cvd_agegroup1 injury_agegroup1 mental_agegroup1 inf_dis_agegroup1 ckd_agegroup1 res_agegroup1 cancer_agegroup1 diabetes_agegroup1 other_all_agegroup1  mi_agegroup1 stroke_h_agegroup1 stroke_i_agegroup1 traffic_agegroup1 suicide_agegroup1 other_injury_agegroup1 copd_agegroup1 clri_agegroup1 influ_agegroup1 lri_agegroup1

global deadnum_agegroup2 t_all_agegroup2 total_agegroup2 cvd_agegroup2 injury_agegroup2 mental_agegroup2 inf_dis_agegroup2 ckd_agegroup2 res_agegroup2 cancer_agegroup2 diabetes_agegroup2 other_all_agegroup2  mi_agegroup2 stroke_h_agegroup2 stroke_i_agegroup2 traffic_agegroup2 suicide_agegroup2 other_injury_agegroup2 copd_agegroup2 clri_agegroup2 influ_agegroup2 lri_agegroup2

global deadnum_agegroup3 t_all_agegroup3 total_agegroup3 cvd_agegroup3 injury_agegroup3 mental_agegroup3 inf_dis_agegroup3 ckd_agegroup3 res_agegroup3 cancer_agegroup3 diabetes_agegroup3 other_all_agegroup3  mi_agegroup3 stroke_h_agegroup3 stroke_i_agegroup3 traffic_agegroup3 suicide_agegroup3 other_injury_agegroup3 copd_agegroup3 clri_agegroup3 influ_agegroup3 lri_agegroup3

***************************************
*
* Tables and Figures
*
***************************************

do "dofile\workdata_output"

log close