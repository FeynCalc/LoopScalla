Readme
========================

Regarding the sign of the gauge covariant derivative 
we follow the same convention as given in the book of Pokorski

In the case of QCD, the same convention is also used in the books of 
Peskin & Schroeder, Yndurain, Narison, Pascual & Tarrach, Muta as well as FeynRules.
This implies that the metric is (+,-,-,-) and we define
gs = |gs| > 0 so that
D^mu = partial^mu - i gs A^{a mu} T^a
D^mu_ab = partial^mu delta_ab + g f_abc A^mu_c
V^mu = i g T^a gamma^mu
Notice that FeynArts as well as the books by Ellis, Stirling & Weber,
Boehm, Denner and Joos etc. use a different convention with the opposite
sign of gs!


In the case of QED, the same convention is also used in the books of 
Zee, Boehm, Denner and Joos  Bjorken as well as FeynRules and FeynArts
This implies that the metric is (+,-,-,-) and we define
el = |el| > 0 so that
D^mu = partial^mu - i el A^mu
V^mu = i el gamma^mu
Notice that the books by Peskin & Schroeder, Itzykson & Zuber, Bjorken & Drell 
and Nachtmann use a different convention with the opposite sign of ge!

Regarding the sign of the ghost propagator, we stick to the convention
of Peskin and Schroeder, where the propagator has an overall plus sign,
while the ghost-gluon vertex has a minus sign accordingly.

Following the QGRAF convention we always write the FFV-vertices such,
that the fermion antifield comes first

All momenta are assumed to be outgoing

Notice that Boehm, Denner & Joos call Goldstone bosons chi (for Pokorski's G^0)
and phi^+/- (for Pokorski's G^+/-)


SSS and SSSS Vertices

* Pokorski uses lambda/2 (H^+ H) for the Higgs doublet term in L_Higgs
* Here we use the more convenient choice of lambda (H^+ H) as in Boehm, Denner and Joos
* We have vev*lambda = el*mH^2*lsclDen(4*lsclMass(W)*sW)
* and lambda = el^2*lsclMass(mH)^2*lsclDen(8*lsclMass(W)^2*sW^2)

* These rules agree with Boehm, Denner and Joos

