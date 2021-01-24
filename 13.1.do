*     Multiple Membership Models - Ali Rahimpour
*
*     Data structure
******************************************************************************

use "13.1.dta", clear

describe

summarize patient satis assess nurses

list patient satis n1st-n4th p1st-p4th if inrange(_n,1,5) ///
	| inrange(_n,401,405) | inrange(_n,701,705) ///
	| inrange(_n,901,905), noobs

list patient satis p1-p10 if inrange(_n,1,5) ///
	| inrange(_n,401,405) | inrange(_n,701,705) ///
	| inrange(_n,901,905), noobs

recode p1-p25 (0=.)

tabstat p1-p25, statistics(count) columns(statistics) format(%2.0f)

recode p1-p25 (.=0)

tabstat p1-p25, statistics(sum) columns(statistics) format(%2.1f)

scatter p1 p2, saving(P13_1_1a, replace)



* P13.1.2 Summarising the response and predictor variables

summarize satis assess

twoway (kdensity satis) (kdensity assess), saving(P13_1_2a, replace)

tabulate n1st

egen pickone_n1st = tag(n1st)

summarize h1st if pickone_n1st==1

kdensity h1st if pickone_n1st==1, saving(P13_1_2b, replace)


* P13.2.1 Specifying and fitting the multiple membership model

use "13.2.dta", clear

xtmixed satis || _all: p1-p25, nocons covariance(identity) mle variance

estimates store model1



* P13.2.2 Interpretation of the multiple membership model



* P13.2.3 Calculating variance partition coefficients (VPCs) and intraclass
*         correlations (ICCs)



* P13.2.4 Predicting and examining nurse effects

predict u0_1-u0_25, reffects

predict u0se_1-u0se_25, reses

keep u0_1-u0_25 u0se_1-u0se_25

describe, short

keep in 1

describe, short

generate tempid = 1

reshape long u0_ u0se_, i(tempid) j(nurse)

list

drop tempid

rename u0_ u0

rename u0se_ u0se

egen u0rank = rank(u0)

summarize u0

qnorm u0, aspectratio(1) saving(P13_2_4a, replace)

serrbar u0 u0se u0rank, scale(1.96) yline(0) ///
	mvopts(mlabel(nurse) mlabposition(1)) saving(P13_2_4b, replace)

generate labheight = u0 + 1.96*u0se + 0.05

serrbar u0 u0se u0rank, scale(1.96) yline(0) ///
	addplot(scatter labheight u0rank, ///
	msymbol(none) mlabel(nurse) ///
	mlabposition(1) mlabangle(vertical) mlabcolor(navy)) ///
	ytitle("Predicted nurse effect") xtitle("Rank") ///
	legend(off) saving(P13_2_4b, replace)
 
