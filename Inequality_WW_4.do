************WWS582b PSET************
* Spring 2019			           *
* Author: William Willoughby       *
* Email: ww14@princeton.edu		   *
************************************

*Last modified: 3/4/2019

clear all
set maxvar 32000
cd \\Files\ww14\ClusterDownloads

// Start with Raw 2016 SCF Data
use YY1 /// 
	X3721 ///  
	X3506 X3510 X3514 X3518 X3522 X3526 X3529 /// 
	X3730 X3736 X3742 X3748 X3754 X3760 X3765 /// 
	X3822 X3824 X3826 X3828 X3830 X7787 X6704 /// 
	X3902 X7635 X7637 X7636 X7638 X7639 X6706 /// 
	X3915 X3932 X3930 ///  
	X6577 X6587 /// 
	X604 X614 X623 X716 X1705 X1706 X1805 X1806 X2002 X2012 /// 
	X513 X526 X3124 X3224 X3129 X3229 X3335 /// 
	X3408 X3412 X3452 X3416 X3420 X3428 /// 
	X3126 X3226 X3127 X3227 /// 
	X3103 X3104 X3401 /// 
	X1306 X1325 X1318 X1337 X1339 X1342 /// 
	X8166 X8167 X8168 X8188 X2422 X2506 X2606 X2623 /// 
	X6588 X6590 X3960 X7661 /// 
	X4006 X4008 X4009 X4010 /// 
	X6551 X6559 X6567 X6552 X6560 X6568 X6553 X6561 X6569 X6554 X6562 X6570 X6576 X6757 X6758 /// 
	X4018 X4022 X4026 X4030 X4032 /// 
	X11032 X11132 X11332 X11432 X11259 X11559 /// 
	X11027 X11127 X11327 X11427 X11033 X11133 X11333 X11433 ///
	X11070 X11170 X11270 X11370 X11470 X11570 ///
	X6462 X6467 X6472 X6477 X6958 X6957 /// 
	X5604 X5612 X5620 X5628 X6997 /// 
	X413 X421 X427 X7575 /// 
	X7132 ///
	X1108 X1119 X1130 X1136 /// 
	X1111 X1122 X1133 /// 
	X2218 X2318 X2418 X7169 X2424 X2519 X2619 X2625 /// 
	X2520 X2620 X2219 X2319 X2419 X7180 /// 
	X7824 X7847 X7870 X7924 X7947 X7970 X7179 /// 
	X7822 X7845 X7868 X7922 X7945 X7968 ///
	X2723 X2740 X2823 X2840 X2923 X2940 X7183 /// 
	X1045 /// 
	X805 X905 X1005 X1044 X1215 X1219 X1715 X1815 X2006 X2016 /// 
	X1216 X816 X916 X1016 /// 
	X14 X19 X42001 X6809 X6810 ///
	X4106 X4706 X4110 X4710 X8023 X4508 X5108 X4509 X5109 ///
	X432 X4112 X4712 X4510 X5110 X4131 X4731 ///
using p16i6.dta



set more off
set matsize 10000
ssc install pshare
ssc install lorenz
ssc install blindschemes, replace all
set scheme plotplain, permanently
ssc install tabout
cap log close 
pause on
log using 582b_William, replace 


rename YY1 name
rename X14 age
rename X8023 marstat


/******************************************************************************/
								*Assets
/******************************************************************************/

/*Certificate of Deposit*/
rename X3721 CDs
label var CDs "Certificates of Deposit"

/*Checking Accounts*/ 
foreach var of varlist X3506 X3510 X3514 X3518 X3522 X3526 X3529 {
replace `var'=0 if `var'==-1
}
gen Checking= X3506 + X3510 + X3514 + X3518 + X3522 + X3526 + X3529
label var Checking "Total in checking accounts"
drop X3506 X3510 X3514 X3518 X3522 X3526 X3529 

/*Savings Accounts*/
foreach var of varlist X3730 X3736 X3742 X3748 X3754 X3760 X3765{
replace `var'=0 if `var'==-1
}
gen Savings=X3730+X3736+X3742+X3748+X3754+X3760+X3765
label var Savings "Total amount in savings accounts"
drop X3730 X3736 X3742 X3748 X3754 X3760 X3765

/*Mutual Funds*/ 
foreach var of varlist X3822 X3824 X3826 X3828 X3830 X7787 X6704 {
replace `var'=0 if `var'==-1
}
gen MutualFund=X3822 + X3824 + X3826 + X3828 + X3830 + X7787 + X6704
label var MutualFund "Total amount in mutual funds"
drop X3822 X3824 X3826 X3828 X3830 X7787 X6704

/*Bonds*/
foreach var of varlist X3902 X7635 X7637 X7636 X7638 X7639 X6706{
replace `var'=0 if `var'==-1
}
gen Bonds=X3902 + X7635 + X7637 + X7636 + X7638 + X7639 + X6706
label var Bonds "Total amount in bonds"
drop X3902 X7635 X7637 X7636 X7638 X7639 X6706

/*Stocks and Brokerage*/ 
foreach var of varlist X3915 X3932 X3930{
replace `var'=0 if `var'==-1
}
gen Stocks=X3915 - X3932 + X3930
label var Stocks "Total amount in stocks"
drop X3915 X3932 X3930

/*Annuities*/ 
foreach var of varlist X6577 X6587{
replace `var'=0 if `var'==-1
}
gen Annuities=X6577 + X6587
label var Annuities "Value of annuities, trusts and managed investment accounts"
drop X6577 X6587

/*Properties*/ 
foreach var of varlist X604 X614 X623 X716 X1705 X1706 X1805 X1806 X2002 X2012{
replace `var'=0 if `var'==-1
}
gen PrivProp=X604 + X614 + X623 + X716 + X1705*X1706/10000 + X1805*X1806/10000 + X2002 + X2012
label var PrivProp "Value of privately owned homes and investment"
drop X604 X614 X623 X716 X1705 X1706 X1805 X1806 X2002 X2012

/*Farm Properties*/ 
foreach var of varlist X513 X526{
replace `var'=0 if `var'==-1
}
gen Farm=X513+X526
label var Farm "Value of farm ownership"
drop X513 X526 

/*BUSINESSES*/
rename X3103 ownbusornot
label define ownbusornot 1 "Yes" 5 "No"
label values ownbusornot ownbusornot
label variable ownbusornot "Do you and your family living here own or share ownership of private business?"

// ACTIVELY MANAGED BUSINESSES
// Do you have an active management role in any of these businesses?
rename X3104 Amanagement
label define Amanagement 1 "Yes" 5 "No" 0 "Inap"
label values Amanagement Amanagement
label variable Amanagement "Do you have an active management role in any of these businesses?"

// Amount the business owes R
gen owedfrombus=X3124+X3224
label var owedfrombus "Amount business owes respondent"
drop X3124 X3224
*amount respondent owes business
replace X3126=0 if X3127==-1
replace X3226=0 if X3227==-1
gen owedtobus=X3126 + X3226
label var owedtobus "Amount respondent owes business"
drop X3126 X3127 X3226 X3227
gen netowedfrombus=owedfrombus - owedtobus
label var netowedfrombus "Net amount business owes respondent"

/*Value of Businesses*/
foreach var of varlist X3129 X3229 X3335{
replace `var'=0 if `var'==-1
}
gen ActiveBus=X3129 + X3229 + X3335
label var ActiveBus "Value of Actively Managed Business"
drop X3129 X3229 X3335

// NON-ACTIVELY MANAGED BUSINESSES
rename X3401 NAmanagement
label variable NAmanagement "Not active management role in business"
label define NAmanagement 1 "Yes" 5 "No"
// What could you sell your shares for
replace X3428 = 0 if X3428 == -1
gen NABusiness = X3408 + X3412 + X3452 + X3416 + X3420 + X3428
label variable NABusiness "What could you sell your share of all non-actively managed businesses for?"
drop X3408 X3412 X3452 X3416 X3420 X3428

/*Money lent for prop*/
foreach var of varlist X1306 X1325 X1318 X1337 X1339 X1342 {
replace `var'=0 if `var'==-1
}
gen moneylent=X1306 + X1325 + X1339 - X1318 - X1337 - X1342
label var moneylent "Money lent to others for property purchase minus remaining loans"
drop X1306 X1325 X1318 X1337 X1339 X1342 

/*Vehicle*/ 
foreach var of varlist X8166 X8167 X8168 X8188 X2422 X2506 X2606 X2623{
replace `var'=0 if `var'==-1
}
gen Vehicles=X8166 + X8167 + X8168 + X8188 + X2422 + X2506 + X2606 + X2623
label var Vehicles "Retail value of vehicles (incl motor homes, RVs, boats, etc.)"
drop X8166 X8167 X8168 X8188 X2422 X2506 X2606 X2623

/*Retirement*/
gen IRA= X6551 + X6559 + X6567 + X6552 + X6560 + X6568 +X6553 +X6561 +X6569 ///
			+ X6554 + X6562 + X6570 + X6576 + X6757 + X6758
			label var IRA "IRA, Roth IRA, roll-over IRA and Keogh accounts"
drop X6551 X6559 X6567 X6552 X6560 X6568 X6553 X6561 X6569 X6554 X6562 ///
			X6570 X6576 X6757 X6758
		
/*Life Insurance*/ 
*if life insurance is net and loans are reported earlier, add them back 
replace X4006 = X4006 + X4010 if X4008==-1
*Subtract loans on life insurance if not reported ealier 
replace X4006 = X4006 - X4010 if X4009 ==-1
rename X4006 LifeInsurance
label var LifeInsurance "Current 'cast value' of life-insurance"
drop X4008 X4009 X4010

/*Other Assets*/ 
gen MiscAssets= X4018 + X4022 + X4026 + X4030 - X4032
label var MiscAssets "Miscellaneous assets minue debts"
drop X4018 X4022 X4026 X4030 X4032

/*Pension*/ 
*Gen gross amounts
foreach var of varlist X11032 X11132 X11332 X11432 X11259 X11559 {
replace `var'=0 if `var'==-1
}
replace X11032 = X11032 + X11027 if X11033 == 1
replace X11132 = X11132 + X11127 if X11133 == 1
replace X11332 = X11332 + X11327 if X11333 == 1
replace X11432 = X11432 + X11427 if X11433 == 1
// If loan isn't already recorded, need to remove it
replace X11032 = X11032 - X11027 if X11070 == 5
replace X11132 = X11132 - X11127 if X11170 == 5
replace X11332 = X11332 - X11327 if X11370 == 5
replace X11432 = X11432 - X11427 if X11470 == 5
gen Pension1 = X11032 + X11132 + X11332 + X11432 + X11259 + X11559
label variable Pension1 "Pension from current main job"
drop X11032 X11132 X11332 X11432 X11259 X11559 X11027 X11127 ///
	 X11327 X11427  X11033 X11133 X11333 X11433 ///
	 X11070 X11170 X11270 X11370 X11470
	 
// CURRENT BENEFITS FROM PENSIONS
foreach var of varlist X6462 X6467 X6472 X6477 X6958 X6957 X5604 X5612 X5620 X5628 X6997{
replace `var'=0 if `var'==-1
}
gen Pension2 = X6462 + X6467 + X6472 + X6477 + X6958 + X6957 + X5604 + X5612 ///
				+ X5620 + X5628 + X6997 
label variable Pension2 "Current and future pension benefits"
drop X6462 X6467 X6472 X6477 X6958 X6957 X5604 X5612 X5620 X5628 X6997 

	 
/******************************************************************************/
								*Liabilities
/******************************************************************************/

/*Credit Card*/ 
foreach var of varlist X413 X421 X427 X7575 {
replace `var'=0 if `var'==-1
}
gen Credit= X413 + X421 + X427 + X7575 
label var Credit "Credit card debt, plus store credit outstanding"
drop X413 X421 X427 X7575 

/*Lines of Credit*/ 
foreach var of varlist X1108 X1119 X1130 X1136 {
replace `var'=0 if `var'==-1
}
gen lineofcredit= X1108 + X1119 + X1130 + X1136 
label var lineofcredit "All lines of credit oustanding"
drop X1108 X1119 X1130 X1136 

/*Vehicle Loans*/ 
foreach var of varlist X2218 X2318 X2418 X7169 X2424 X2519 X2619 X2625 {
replace `var'=0 if `var'==-1
}
gen VehLoan= X2218 + X2318 + X2418 + X7169 + X2424 + X2519 + X2619 + X2625 
label var VehLoan "Amount owed on vehicle loans"
drop X2218 X2318 X2418 X7169 X2424 X2519 X2619 X2625 

/*Education Loans*/ 
foreach var of varlist X7824 X7847 X7870 X7924 X7947 X7970 X7179 {
replace `var'=0 if `var'==-1
}
gen EduLoan= X7824 + X7847 + X7870 + X7924 + X7947 + X7970 + X7179 
label var EduLoan "Amount owed on education loans"
drop X7824 X7847 X7870 X7924 X7947 X7970 X7179

/*Consumer Loan*/ 
foreach var of varlist X2723 X2740 X2823 X2840 X2923 X2940 X7183{
replace `var'=0 if `var'==-1
}
gen OthLoan= X2723 + X2740 + X2823 + X2840 + X2923 + X2940 + X7183 
label var OthLoan "Amount owed on other consumer loans"
drop X2723 X2740 X2823 X2840 X2923 X2940 X7183 

/*Mortgages*/ 
foreach var of varlist X805 X905 X1005 X1044 {
replace `var'=0 if `var'==-1
}
gen Mortgage= X805 + X905 + X1005 + X1044 
label var Mortgage "Amount owed on mortgages"
drop X805 X905 X1005 X1044  

/*Home Improvement Loans*/
foreach var of varlist X1215 X1219 {
replace `var'=0 if `var'==-1
}
gen HomeImpLoan = X1215 + X1219 
label var HomeImpLoan "Amount owed on home improvement loans"
drop X1215 X1219 


/*Home Loans Outstanding*/
foreach var of varlist X1715 X1815 X2006 X2016{
replace `var'=0 if `var'==-1
}
gen HomeEquityLoan = X1715 + X1815 + X2006 + X2016
label var HomeEquityLoan "Loans against property investments and vacation homes"
drop X1715 X1815 X2006 X2016

/******************************************************************************/
							*Net Wealth
/******************************************************************************/
gen assets= CDs + Checking + Savings + MutualFund + Bonds + Stocks ///
			+ Annuities + PrivProp + Farm + ActiveBus + NABus + netowedfrombus ///
			+ moneylent + Vehicles + IRA + LifeInsurance + MiscAssets ///
			+Pension1 + Pension2
			
gen liabilities= Credit + lineofcredit + VehLoan + OthLoan + Mortgage ///
				+ HomeImpLoan + HomeEquityLoan +EduLoan
	
gen wealth = assets - liabilities 
gen lnwealth = log(wealth)

*Population sorted by wealth
sort wealth 
gen id=_n if wealth !=.
sum id
gen popshare=id/`r(max)'*100
label var popshare "Percentile in population" 

/*Wealth Share*/
/*weight wealth data: "For users who want to estimate only simple statistics such as sums,
means and medians ignoring the effects of imputation error on the
standard errors of these estimates, it will probably be sufficient to
divide the weights by 5.*/ 
gen weight = X42001/5 

gen wealthwt=.
forval i=1(.1)100{
	_pctile wealth [pweight=weight], p(`i')
	replace wealthwt=`r(r1)' if popshare >= `i' & popshare != .
}
*find wealth share for each point on distribution
sort wealthwt
qui egen totalwealth=total(wealthwt) if wealthwt!=.
gen wealth1=(wealthwt/totalwealth)*100

*Gen cumulative wealthshare 
gen wealthshare=.
replace wealthshare=sum(wealth1) if popshare!=.
label var wealthshare "Percent of wealth"

sum wealthshare, det

pause

/******************************************************************************/
							*Section 1
/******************************************************************************/
*Histogram of level of wealth up to 95th percentile
hist wealthwt if popshare <=95, color("22 150 210") ytitle("Density") /// 
	xtitle("Net Wealth") title("Net Wealth for up to 95th Percent")

pause

*Histogram of log wealth 
gen lnwtwealth=.
replace lnwtwealth=log(wealthwt) if wealthwt!=.
hist lnwtwealth, color("22 150 210") ytitle("Density") /// 
	xtitle("Log of Net Wealth") title("Log of Net Wealth")

/******************************************************************************/
							*Section 2
/******************************************************************************/
*Method 1, Share of Wealth 
sort wealthwt
pshare estimate wealthwt, p(50 90 99)
pshare estimate wealthwt, p(99.9 100)
  
 *Create dummies for groups, used later in do file
gen bottomfifty=.
replace bottomfifty=0 if popshare!=.
replace bottomfifty=1 if popshare<=50
label var bottomfifty "Bottom 50 Percent"

gen nextforty=.
replace nextforty=0 if popshare!=.
replace nextforty=1 if popshare> 50 & popshare<=90
label var nextforty "50 to 90 Percent"

gen topnine=.
replace topnine=0 if popshare!=.
replace topnine=1 if popshare> 90 & popshare<=99
label var topnine "90 to 99 Percent"

gen topone=.
replace topone=0 if popshare!=.
replace topone=1 if popshare> 99
label var topone "Top 1 Percent"

gen toppointone=.
replace toppointone=0 if popshare!=.
replace toppointone=1 if popshare> 99.9
label var toppointone "Top 0.1 Percent"


/******************************************************************************/
							*Section 3
/******************************************************************************/
sort wealthwt
pshare estimate wealthwt, nquantiles(100)
pshare histogram,  ylabel(0(0.1)0.4, angle(hor)) ytitle("Share of Wealth") ///
	xtitle("Population Percentile")  ti(Wealth distribution) noci	
	

/******************************************************************************/
							*Section 4
/******************************************************************************/
*Graph Lorenz Curve
lorenz estimate wealthwt, nquantiles(100)
lorenz graph, aspectratio(1) ytitle("Wealth Share") xtitle("Population Share") ///
	title("Lorenze Curve") legend(order(1 "Perfect Equality" 2 "Lorenz Curve")) ///
	xlabel(, grid) lcolor("22 150 210") noci
	
*Chris' alternative
line wealthshare popshare if inrange(popshare, 0, 100), lcolor("22 150 210") ///
	aspectratio(1) || (function y=x, range(0 100) lcolor(grey))


/******************************************************************************/
							*Section 5
/******************************************************************************/
/* https://ageconsearch.umn.edu/record/116213/files/sjart_gr0003.pdf P.12 */

gen topshare=.
replace topshare=log(1-wealthshare/100)  if wealthshare!=.
scatter topshare lnwealth  if popshare >=90, mcolor("22 150 210") /// 
	legend(order(2 "Fitted Values")) ytitle("1-(CDF of Wealth)") ///
	xtitle("Log Net Wealth") title("The Pareto Tail for the Top 10 Percent") ///
	msymbol(smcircle)

/******************************************************************************/
							*Section 6
/******************************************************************************/
gen selfemp=.
replace selfemp=0 if popshare!=.
replace selfemp=1 if X4106>1 | X4706>1
label var selfemp "Employed"

tabout bottomfifty nextforty topnine topone toppointone selfemp ///
	using table3.xls, replace c(row)

/******************************************************************************/
							*Section 7
/******************************************************************************/	
gen white_1=.
replace white_1=0 if popshare!=.
replace white_1=1 if X6809==1
label var white_1 "Self ID White"

gen white_2=.
replace white_2=0 if popshare!=.
replace white_2=1 if X6809==1 | X6810==1
label var white_2 "Self ID White Expanded"

*Model 1 
tabout bottomfifty nextforty topnine topone toppointone white_1 ///
	using table4.xls, replace c(row)

*Model 2
tabout bottomfifty nextforty topnine topone toppointone white_2 ///
	using table4.xls, append c(row)


cap log close

