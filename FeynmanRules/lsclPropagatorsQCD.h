*--#[ lsclFeynmanRulesQCDPropagatorsRXiGauge:

* Quark propagator

id lsclQGPropagator(lsclF1?lsclQuarkFields[lsclS](lsclS1?,lsclP1?), lsclF2?lsclAntiQuarkFields[lsclS](lsclS2?,lsclP2?)) = 
	i_*lsclSUNFDelta(lsclFunColorIndex(lsclS1),lsclFunColorIndex(lsclS2))*
 lsclDiracChain(lsclNCHold(g_(100,lsclP1))+lsclMass(lsclF1),lsclDiracIndex(lsclS1),lsclDiracIndex(lsclS2))*lsclFAD(lsclP1,lsclMass(lsclF1));

* Gluon propagator
id lsclQGPropagator(Gl(lsclS1?,lsclP1?), Gl(lsclS2?,lsclP2?)) = 
 -i_*lsclSUNDelta(lsclAdjColorIndex(lsclS1),lsclAdjColorIndex(lsclS2))*lsclHold(
 lsclMetricTensor(lsclLorentzIndex(lsclS1),lsclLorentzIndex(lsclS2))*lsclFAD(lsclP1,0) 
 -lsclGaugeXi*lsclVector(lsclP1,lsclLorentzIndex(lsclS1))*lsclVector(lsclP1,lsclLorentzIndex(lsclS2))*lsclFAD(lsclP1,0)^2
);

* QCD ghost propagator
id lsclQGPropagator(Gh(lsclS1?,lsclP1?), Ghbar(lsclS2?,lsclP2?)) = 
i_*`lsclPprGhostPropagatorSign'*lsclSUNDelta(lsclAdjColorIndex(lsclS1),lsclAdjColorIndex(lsclS2))*lsclFAD(lsclP1,0);

*--#] lsclFeynmanRulesQCDPropagatorsRXiGauge:
