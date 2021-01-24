******************************************************************************
* Module 13: Multiple Membership Models - Stata Practical
*
*     P13.3: Exploring Alternative Multiple Membership Weighting Schemes
*
* 	     George Leckie
*            Centre for Multilevel Modelling, 2011
******************************************************************************

use "13.3.dta", clear

forvalues j = 1/25 {
	replace p`j' = 1/nurses if p`j'~=0
}

xtmixed satis || _all: p1-p25, nocons covariance(identity) mle variance

estimates store model2

xtmixed satis || n1st:, mle variance

estimates store model3
