
*--#[ lsclFeynmanRulesEWPropagatorsRXiGauge:

* Lepton propagators
id lsclQGPropagator(lsclF1?lsclLeptonFields[lsclS](lsclS1?,lsclP1?), lsclF2?lsclAntiLeptonFields[lsclS](lsclS2?,lsclP2?)) = 
 i_*lsclDiracChain(lsclNCHold(g_(100,lsclP1))+lsclMass(lsclF1),lsclDiracIndex(lsclS1),lsclDiracIndex(lsclS2))*lsclFAD(lsclP1,lsclMass(lsclF1));

* EW boson propagators (Wm, Wp, Z, Ga)
id lsclQGPropagator(lsclF1?lsclEWBosonFields[lsclS](lsclS1?,lsclP1?), lsclF2?lsclEWBosonFields[lsclS](lsclS2?,lsclP2?)) = 
 -i_*lsclHold(lsclMetricTensor(lsclLorentzIndex(lsclS1),lsclLorentzIndex(lsclS2))*lsclFAD(lsclP1,lsclMass(lsclEWBosonFields)) 
 -lsclGaugeXiEw*lsclVector(lsclP1,lsclLorentzIndex(lsclS1))*lsclVector(lsclP1,lsclLorentzIndex(lsclS2))*lsclFAD(lsclP1,lsclGaugeXiEw*lsclMass(lsclEWBosonFields))^2
);

* Goldstone boson propagators
id lsclQGPropagator(lsclF1?lsclGoldstoneBosonFields(lsclS1?,lsclP1?), lsclF2?lsclGoldstoneBosonFields(lsclS2?,lsclP2?)) = 
 i_*lsclFAD(lsclP1,lsclGaugeXiEw*lsclMass(lsclGoldstoneBosonFields));
 
* Higgs boson propagator
id lsclQGPropagator(H(lsclS1?,lsclP1?), H(lsclS2?,lsclP2?)) = 
 i_*lsclFAD(lsclP1,lsclMass(H)); 

* Check the signs carefully!!!

* EW boson ghost propagator
id lsclQGPropagator(lsclF1?lsclEWGhostFields[lsclS](lsclS1?,lsclP1?), lsclF2?lsclAntiEWGhostFields[lsclS](lsclS2?,lsclP2?)) = 
 i_*lsclFAD(lsclP1,lsclGaugeXiEw*lsclMass(lsclF1));

*--#] lsclFeynmanRulesEWPropagatorsRXiGauge:


*--#[ lsclFeynmanRulesEWPropagatorsUnitaryGauge:

* Lepton propagators
id lsclQGPropagator(lsclF1?lsclLeptonFields[lsclS](lsclS1?,lsclP1?), lsclF2?lsclAntiLeptonFields[lsclS](lsclS2?,lsclP2?)) = 
 i_*lsclDiracChain(lsclNCHold(g_(100,lsclP1))+lsclMass(lsclF1),lsclDiracIndex(lsclS1),lsclDiracIndex(lsclS2))*lsclFAD(lsclP1,lsclMass(lsclF1));

* EW boson propagators

* Wp, Wm, Z
id lsclQGPropagator(lsclF1?{Wp,Wm,Z}[lsclS](lsclS1?,lsclP1?), lsclF2?{Wp,Wm,Z}[lsclS]lsclEWBosonFields(lsclS2?,lsclP2?)) = 
 -i_*lsclHold(lsclMetricTensor(lsclLorentzIndex(lsclS1),lsclLorentzIndex(lsclS2))*lsclFAD(lsclP1,lsclMass(lsclEWBosonFields)) 
 -lsclVector(lsclP1,lsclLorentzIndex(lsclS1))*lsclVector(lsclP1,lsclLorentzIndex(lsclS2))/lsclMass(lsclEWBosonFields)
);

* Ga
id lsclQGPropagator(Ga(lsclS1?,lsclP1?), Ga(lsclS2?,lsclP2?)) = 
 -i_*lsclHold(lsclMetricTensor(lsclLorentzIndex(lsclS1),lsclLorentzIndex(lsclS2))*lsclFAD(lsclP1,0));

* Higgs boson propagator
id lsclQGPropagator(H(lsclS1?,lsclP1?), H(lsclS2?,lsclP2?)) = 
 i_*lsclFAD(lsclP1,lsclMass(H)); 


*--#] lsclFeynmanRulesEWPropagatorsUnitaryGauge:
