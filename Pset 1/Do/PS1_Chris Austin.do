************* WWS582b PS1 *************
*  Spring 2019			              *
*  Author : Chris Austin              *
*  Email: chris.austin@princeton.edu  *
***************************************

/* Last modified by: Chris Austin
Last modified on: 2/22/19 */

clear all

set maxvar 32000

*Set directory, dta file, etc.
cd "C:\Users\Chris\Documents\Princeton\WWS Spring 2019\Economic Causes and Conesequences of Inequality\WWS-528b-Problem-Sets\Pset 1\Dta"
use p16i6

set more off
set matsize 10000
capture log close
pause on
log using 582b_PS1_Chris, replace


// DEFINE AND KEEP RELEVANT ASSETS AND LIABILITIES
* Exclude the rest, including J-codes for imputed values associated with missing 
*values.
# delimit ;
keep Y1
	X3721
	X3506 X3510 X3514 X3518 X3522 X3526 X3529 
	X3730 X3736 X3742 X3748 X3754 X3765 
	X3822 X3824 X3826 X3828 X3830 X7787 X6704 
	X3902 X7635 X7636 X7637 X7638 X7639 X6706 
	X3915 X3930 X3932 
	X6577 X6587 
	X604 X614 X623 X716 X1705 X1706 X1805 X1806 X2002 X2012 
	X513 X526 X3124 X3224 X3129 X3229 X3335 X3408 X3412 X3416 X3420 X3428 
		X3126 X3226 X3127 X3227 
	X8166 X8167 X8168 X8188 X2422 X2506 X2606 X2623 
	X6551 X6559 X6567 X6552 X6560 X6568 X6553 X6561 X6569 X6554 X6562 X6570 
	 X6756 X6757 X6758 
	X4006 X4008 X4009 X4010 
	X4018 X4022 X4026 X4030 X4032 
	X11032 X11132 X11332 X11432 X11259 X11559 X11027 X11127 X11327 X11427 X11033 
		X11133 X11333 X11433 X11070 X11170 X11270 X11370 X11470 X11570 
	X413 X421 X427 X7575 
	X1108 X1119 X1130 X1136 
	X2218 X2318 X2418 X7169 X2424 X2519 X2619 X2625 
	X7824 X7847 X7870 X7924 X7947 X7970 X7179 
	X2723 X2740 X2823 X2840 X2923 X2940 X7183 
	X805 X905 X1005 X1044 X1215 X1219 X1715 X1815 X2006 X2016 
	X42001 X6809 X4106 X4706
	;
# delimit cr

///ASSET AND LIABILITY CLASSIFICATION
// CERTIFICATES OF DEPOSIT
rename X3721 CDs
label variable CDs "Certificates of deposit"

// CHECKING ACCOUNTS
replace X3506 = 0 if X3506 == -1
replace X3510 = 0 if X3510 == -1
replace X3514 = 0 if X3514 == -1
replace X3518 = 0 if X3518 == -1
replace X3522 = 0 if X3522 == -1
replace X3526 = 0 if X3526 == -1
replace X3529 = 0 if X3529 == -1
gen Checking = X3506 + X3510 + X3514 + X3518 + X3522 + X3526 + X3529
label variable Checking "Total amount in checking accounts"
drop X3506 X3510 X3514 X3518 X3522 X3526 X3529

// SAVINGS ACCOUNTS
replace X3730 = 0 if X3730 == -1
replace X3736 = 0 if X3736 == -1
replace X3742 = 0 if X3742 == -1
replace X3748 = 0 if X3748 == -1
replace X3754 = 0 if X3754 == -1
replace X3765 = 0 if X3765 == -1
gen Savings = X3730 + X3736 + X3742 + X3748 + X3754 + X3765
label variable Savings "Total amount in savings accounts"
drop X3730 X3736 X3742 X3748 X3754 X3765

// MUTUAL FUNDS
gen MutualFund = X3822 + X3824 + X3826 + X3828 + X3830 + X7787 + X6704
label variable MutualFund "Total value of mutual funds"
drop X3822 X3824 X3826 X3828 X3830 X7787 X6704

// BONDS 
gen Bonds = X3902 + X7635 + X7636 + X7637 + X7638 + X7639 + X6706
label variable Bonds "Total value of bonds (at market value if available)"
drop X3902 X7635 X7636 X7637 X7638 X7639 X6706

// STOCKS
replace X3930 = 0 if X3930 == -1
replace X3932 = 0 if X3932 == -1
gen Stocks = X3915 + X3930 - X3932
label variable Stocks "Total value of stocks and cash or call money accounts minus margin loans"
drop X3915 X3930 X3932 

// ANNUITIES, TRUSTS AND MANAGED INVESTMENT ACCOUNTS
gen ATMIA = X6577 + X6587
label variable ATMIA "Annuities, trusts and managed investment accounts"
drop X6577 X6587

// MOBILE PLUS SITE, HOME, INVESTMENT REAL ESTATE, AND VACATION PROPERTIES
/* X604 + X614 + X623 sum of mobile plus site, X716 home, X1706, and X1806 
report total value of timeshare/property; X1705, and X1805 report share of
property owned by R; X2002 reports value of total share of vacation home or 
recreational property;  */
replace X2012 = 0 if X2012 == -1
gen Investprop = X604 + X614 + X623 + X716 + X1705*X1706/10000 + X1805*X1806/10000 ///
				 + X2002 + X2012
label variable Investprop "Value of mobile plus site, home, investment property and vacation homes"
drop X604 X614 X623 X716 X1705 X1706 X1805 X1806 X2002 X2012

//FARM MANAGED AS BUSINESS; NET WORTH OF ACTIVELY MANAGED BUSINESS;
//VALUE OF NON-ACTIVELY MANAGED BUSINESS; NET MONEY OWED FROM BUSINESS
*FARMLAND WITH BUSINESS
/* X513 is owned farmland and top coded at 99,999,999 (not binding). X526 is 
the value of the share of partly owned farmland and topcoded at 99,999,999 (not 
binding)
*/
gen Farm = X513 + X526
label variable Farm "Value of fully or partially owned farm"
drop X513 X526

*VALUE OF BUSINESS (recode nothing to 0)
replace X3129 = 0 if X3129 == -1
replace X3229 = 0 if X3229 == -1
replace X3335 = 0 if X3335 == -1
gen ActBusiness = X3129 + X3229 + X3335
label variable ActBusiness "Value of actively managed business"
drop X3129 X3229 X3335

*NON-ACTIVELY MANAGED BUSINESSES
*What could you sell your shares for
replace X3428 = 0 if X3428 == -1
gen NABusiness = X3408 + X3412 + X3416 + X3420 + X3428
label variable NABusiness "What could you sell your share of all non-actively managed businesses for?"
drop X3408 X3412 X3416 X3420 X3428

*ACTIVELY MANAGED BUSINESSES
*Amount the business owes R
gen owedfrombus = X3124 + X3224
label variable owedfrombus "Amount the business owes R"
drop X3124 X3224
*Amount owed to business; if recorded earlier, set to zero
replace X3126 = 0 if X3127 == 1
replace X3226 = 0 if X3227 == 1
gen owetobus = X3126 + X3226
label variable owetobus "Amount R owes business"
drop X3126 X3226 X3127 X3227
*Net amount owed to business
gen netowedfrombus = owedfrombus - owetobus
label variable netowedfrombus "Net amount business owes R" 

// VEHICLES
gen Vehicles = X8166 + X8167 + X8168 + X8188 + X2422 + X2506 + X2606 + X2623
label variable Vehicles "Prevailing retail value of vehicles (incl motor homes, RVs, boats, airplanes, etc.)"
drop X8166 X8167 X8168 X8188 X2422 X2506 X2606 X2623

// RETIREMENT SAVINGS
gen IRA = X6551 + X6559 + X6567 + X6552 + X6560 + X6568 + X6553 + X6561 + X6569 ///
		  + X6554 + X6562 + X6570 + X6756 + X6757 + X6758
drop X6551 X6559 X6567 X6552 X6560 X6568 X6553 X6561 X6569 X6554 X6562 X6570 ///
	 X6756 X6757 X6758
label variable IRA "IRA, Roth IRA, roll-over IRA and Keogh accounts"

// LIFEINSURANCE
*If life-insurance is net and loans are reported earlier, add them back
replace X4006 = X4006 + X4010 if X4008 == 1
*Subtract loans on life-insurance if not reported earlier
replace X4006 = X4006 - X4010 if X4009 == 5
rename X4006 LifeInsurance
label variable LifeInsurance "Current 'cash value' of life-insurance"
drop X4008 X4009 X4010

// MISCELLANEOUS ASSETS AND DEBTS
gen MiscAssets = X4018 + X4022 + X4026 + X4030 - X4032
label variable MiscAssets "Miscellaneous assets minus debts"
drop X4018 X4022 X4026 X4030 X4032

// PENSIONS FOR HEAD AND SPOUSE FROM CURRENT MAIN JOB
*Generate gross amounts
replace X11032 = 0 if X11032 == -1
replace X11132 = 0 if X11132 == -1
replace X11332 = 0 if X11332 == -1
replace X11432 = 0 if X11432 == -1
replace X11259 = 0 if X11259 == -1
replace X11559 = 0 if X11559 == -1
replace X11032 = X11032 + X11027 if X11033 == 1
replace X11132 = X11132 + X11127 if X11133 == 1
replace X11332 = X11332 + X11327 if X11333 == 1
replace X11432 = X11432 + X11427 if X11433 == 1
*If loan isn't already recorded, need to remove it
replace X11032 = X11032 - X11027 if X11070 == 5
replace X11132 = X11132 - X11127 if X11170 == 5
replace X11332 = X11332 - X11327 if X11370 == 5
replace X11432 = X11432 - X11427 if X11470 == 5
gen Pension1 = X11032 + X11132 + X11332 + X11432 + X11259 + X11559
label variable Pension1 "Pension from current main job"
drop X11032 X11132 X11332 X11432 X11259 X11559 X11027 X11127 ///
	 X11327 X11427 X11033 X11133 X11333 X11433 ///
	 X11070 X11170 X11270 X11370 X11470 X11570

// CREDIT CARD DEBT; STORE CREDIT OUTSTANDING X7575
/* Recode zeros to zeros, missing is zero as well. Topcoding is 999,999 and is 
not binding */
replace X413 = 0 if X413 == -1
replace X421 = 0 if X421 == -1
replace X427 = 0 if X427 == -1
gen Credit = X413 + X421 + X427 + X7575
drop X413 X421 X427 X7575
label variable Credit "Credit card debt, plus store credit outstanding"

// LINES OF CREDIT
/* X1108, X1119 and X1130 are first, second and third lines of credit, X1136 is
all remaining lines of credit */
gen Cline = X1108 + X1119 + X1130 + X1136
label variable Cline "Amount borrowed on lines of credit"
rename X1108 cline1
rename X1119 cline2
rename X1130 cline3
rename X1136 cline4

// VEHICLE LOANS
gen VehLoan = X2218 + X2318 + X2418 + X7169 + X2424 + X2519 + X2619 + X2625
label variable VehLoan "Owed on vehicle loans"
rename X2218 vehloan1
label variable vehloan1 "Owed on vehicle loan 1"
rename X2318 vehloan2
label variable vehloan2 "Owed on vehicle loan 2"
rename X2418 vehloan3
label variable vehloan3 "Owed on vehicle loan 3"
rename X7169 vehloan4
label variable vehloan4 "Owed on vehicle loan 4"
rename X2519 vehloan5
label variable vehloan5 "Owed on vehicle loan 5"
rename X2619 vehloan6
label variable vehloan6 "Owed on vehicle loan 6"
drop X2424 X2625

// EDUCATION LOANS
gen EduLoans = X7824 + X7847 + X7870 + X7924 + X7947 + X7970 + X7179
label variable EduLoans "Amount owed on education loans"
rename X7824 eduloan1
label variable eduloan1 "Amount owed on education loan 1"
rename X7847 eduloan2
label variable eduloan2 "Amount owed on education loan 2"
rename X7870 eduloan3
label variable eduloan3 "Amount owed on education loan 3"
rename X7924 eduloan4
label variable eduloan4 "Amount owed on education loan 4"
rename X7947 eduloan5
label variable eduloan5 "Amount owed on education loan 5"
rename X7970 eduloan6
label variable eduloan6 "Amount owed on education loan 6"
drop X7179

// OTHER CONSUMER LOANS
gen OthCLoan = X2723 + X2740 + X2823 + X2840 + X2923 + X2940 + X7183
label variable OthCLoan "Other consumer loans"
drop X2723 X2740 X2823 X2840 X2923 X2940 X7183

//TOTAL HOME LOANS
*Home mortgate
gen Mortgage = X805 + X905 + X1005 + X1044
label variable Mortgage "Total home loans incl mortgages, other home equity loans and other property loans"
rename X805 mortgage1
rename X905 mortgage2
rename X1005 mortgage3
rename X1044 mortgage4

*home improvement loan
gen Homeimploan = X1215 + X1219
label variable Homeimploan "Total loans for home improvement"
drop X1215 X1219


*home laons outstanding
gen Investproploans = X1715 + X1815 + X2006 + X2016
label variable Investproploans "Loans against investment property and vacation homes"
drop X1715 X1815 X2006 X2016

// NET WEALTH
**Assets
*CDs Checking Bonds NABusiness MiscAssets Stocks Pension1 ATMIA Credit 
*Homeimploan LifeInsurance Investprop netowedfrombus Savings Farm Vehicles 
*MutualFund ActBusiness IRA
gen assets = CDs + Checking + Bonds + NABusiness + MiscAssets + Stocks + Pension1 + ATMIA + Credit + Homeimploan + LifeInsurance + Investprop + netowedfrombus + Savings + Farm + Vehicles + MutualFund + ActBusiness + IRA

**Liabilities
*Credit Cline cline1 cline2 cline3 cline4 VehLoan vehloan1 vehloan2 vehloan3 
*vehloan4 vehloan5 vehloan6 EduLoans eduloan1 eduloan2 eduloan3 eduloan4 eduloan5 
*eduloan6 OthCLoan Mortgage mortgage2 mortgage3 mortgage4 Homeimploan Investproploans
*Credit Cline VehLoan EduLoans OthCLoan Mortgage Homeimploan Investproploans
gen liabilities = Credit + Cline + VehLoan + EduLoans + OthCLoan + Mortgage + Homeimploan + Investproploans

*Generate wealth and log wealth variables
gen wealth = assets - liabilities
gen wtwealth = X42001*wealth
gen lnwealth = log(wealth)
gen lnwtwealth = log(wtwealth)

/// COMPUTE POPULATION AND WEALTH SHARE VARIABLES
// POPULATION SHARE
*create new running ID2 sorted by wealth & ignore missing wealth values (assuming nonresponse is unbiased)
sort wealth
gen id = _n if wealth != .
sum id
gen popshare = id/`r(max)'*100
label variable popshare "Percent of population"

// WEALTH SHARE
*First compute each person's share of wealth
qui egen totalwealth = total(wealth)
sort wealth
gen wealth1 = (wealth/totalwealth)*100

*Now generate cumulative wealthshare variable
gen wealthshare = .
forval i = 1/100 {
	replace wealthshare = sum(wealth1) if popshare <= `i'
	}
label variable wealthshare "Percent of wealth"

pause

********************************************************************************
**                                   P1                                       **
********************************************************************************
*1. Make two histograms for: 

*(a) the level of wealth (only plot up to the 95th percentile, 
*otherwise the graph will be hard to read):
histogram wealth if popshare <= 95

pause

*(b) the logarithm of wealth:
histogram lnwealth

pause

********************************************************************************
**                                   P2                                       **
********************************************************************************
*Make a table with the wealth shares of (a) the bottom 50 percent, (b) the next 40 percent,
*(c) the next 9 percent, (d) the top 1 percent, (e) the top 0.1 percent of households in the
*sample.

*Make indicator for distinct percentiles requested in problemset.
gen popsharei = .
replace popsharei = 1 if popshare <= 50
replace popsharei = 2 if popshare > 50 & popshare <= 90
replace popsharei = 3 if popshare > 90
replace popsharei = 4 if popshare > 99   
replace popsharei = 5 if popshare > 99.9
replace popsharei = . if popshare == .
label var popsharei "Population quantiles"

# delimit ;
label define popsharei_lbl 
	1 "50 percentile" 
	2 "Next 40 percentile"
	3 "Top 10 percentile"
	4 "Top 1 percentile"
	5 "Top 0.1 percentile"
;
# delimit cr

gen wealthi = .

forval i = 1/5 {
	su wealth1 if popsharei == `i'
	replace wealthi = `r(sum)' if popsharei == `i'
	di `r(sum)'
	}

pause 

********************************************************************************
**                                   P3                                       **
********************************************************************************
*Plot the quantile function (you will likely have to cut the y-axis to make it readable due
*to the “dwarves and giants” feature). At the end, your answers to question 2, 6 and 7
*can be summarized in a table like Table 1 below.

twoway bar wealthi popsharei, ysc(r(0 100))	

********************************************************************************
**                                   P4                                       **
********************************************************************************
// GRAPH LORENZ CURVE
line wealthshare popshare if inrange(popshare, 0, 100), aspectratio(1)||(function y=x, range(0 100))

pause 

*Compare with Lorenz Curve stata package.
ssc install lorenz
lorenz estimate wealth
lorenz graph, aspectratio(1) xlabel(, grid)

pause

********************************************************************************
**                                   P5                                       **
********************************************************************************
*For the wealth above the 90th percentile, plot log(1 − F(w)) against logw where F(w)
*is the cumulative distribution function of wealth w. Figure 1 plots the corresponding
*graph for the 2007 SCF. If the distribution had an exact Pareto tail, this should be a
*straight line. The plot you will generate will most likely have the feature that the Pareto
*relationship breaks down for high enough wealth levels. Why?

*Create log(1-F(w)), where F9w) is the cumulative distribution function of wealth.
gen topshare = .
replace topshare = (1-wealthshare/100) if wealthshare >= 90

twoway scatter topshare lnwealth if wealthshare >= 90
pause

********************************************************************************
**                                   P6                                       **
********************************************************************************
*Let’s assess what fraction of people in different parts of the wealth distribution are “en-
*trepreneurs” broadly defined. To this end use the variable X4106. For each of the wealth
*groups in question 2, calculate the fraction of people who are “entrepreneurs”. Add your
*answer to Table 1.

// EMPLOYMENT STATUS
rename X4106 selfemp
rename X4706 selfemp_s
label values selfemp selfemp
label values selfemp_s selfemp
label variable selfemp "R working for someone else or self-employed?"
label variable selfemp_s "Spouse/partner working for someone else or self-employed?"
replace selfemp = 1 if selfemp > 1

*create new indicator for self employment to store entrepreneurship share values 
*for each percentile.
gen selfempi = .

forval i = 1/5 {
	sum selfemp if popsharei == `i'
	di `r(mean)'
	replace selfempi = `r(mean)' if popsharei == `i'
	}

twoway bar selfempi popsharei, ysc(r(0 1))	
	
pause

********************************************************************************
**                                   P7                                       **
********************************************************************************
*Finally, repeat the exercise from the previous question but focusing on race. In particular,
*report the fraction of people in different parts of the wealth distribution that self-identify
*as “white.” From the codebook, the right variable variable seems to be X6809 but you
*may want to double-check this. Add your answer to Table 1.
// RACE
rename X6809 race	
replace race = 0 if race != 1 
label define rac 0 "Other" 1 "White"
label values race rac

*create new indicator for self employment to store entrepreneurship share values 
*for each percentile.
gen racei = .

forval i = 1/5 {
	sum race if popsharei == `i'
	di `r(mean)'
	replace racei = `r(mean)' if popsharei == `i'
	}

twoway bar racei popsharei, ysc(r(0 1))	

pause
