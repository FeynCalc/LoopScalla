*--#[ lsclFeynmanRulesLeptonsFFV:

* Lepton-photon vertex 
id lsclQGVertex(lsclF1?lsclAntiChargedLeptonFields[lsclS](lsclS1?,lsclP1?), lsclF2?lsclChargedLeptonFields[lsclS](lsclS2?,lsclP2?), Ga(lsclS3?,lsclP3?)) = 
	i_*el*lsclDiracChain(lsclDiracMatrix(lsclLorentzIndex(lsclS3)),lsclDiracIndex(lsclS1),lsclDiracIndex(lsclS2));

* Leptonic charged current - nubar_ell ell^- W^+
id lsclQGVertex(lsclF1?lsclAntiParticleLeptonicCurrentP[lsclS](lsclS1?,lsclP1?), lsclF2?lsclParticleLeptonicCurrentP[lsclS](lsclS2?,lsclP2?), Wp(lsclS3?,lsclP3?)) = 
 -i_*el*lsclDen(sqrt_(2)*sW)*lsclDiracChain(lsclDiracMatrix(lsclLorentzIndex(lsclS3))*lsclDiracMatrix(7),lsclDiracIndex(lsclS1),lsclDiracIndex(lsclS2));

* Leptonic charged current - nu_ell ell^+ W^-
id lsclQGVertex(lsclF1?lsclAntiParticleLeptonicCurrentM[lsclS](lsclS1?,lsclP1?), lsclF2?lsclParticleLeptonicCurrentM[lsclS](lsclS2?,lsclP2?), Wm(lsclS3?,lsclP3?)) = 
 -i_*el*lsclDen(sqrt_(2)*sW)*lsclDiracChain(lsclDiracMatrix(lsclLorentzIndex(lsclS3))*lsclDiracMatrix(7),lsclDiracIndex(lsclS1),lsclDiracIndex(lsclS2));

* Lepton-neutrino neutral current (nubar_x nu_x Z)
id lsclQGVertex(lsclF1?lsclAntiNeutrinoFields[lsclS](lsclS1?,lsclP1?), lsclF2?lsclNeutrinoFields[lsclS](lsclS2?,lsclP2?), Z(lsclS3?,lsclP3?)) = 
 -i_*el*lsclDen(2*sW*cW)*lsclDiracChain(lsclDiracMatrix(lsclLorentzIndex(lsclS3))*lsclDiracMatrix(7),lsclDiracIndex(lsclS1),lsclDiracIndex(lsclS2));

* Charged-lepton neutral current (ellbar ell Z)
id lsclQGVertex(lsclF1?lsclAntiChargedLeptonFields[lsclS](lsclS1?,lsclP1?), lsclF2?lsclChargedLeptonFields[lsclS](lsclS2?,lsclP2?), Z(lsclS3?,lsclP3?)) = 
 i_*el*lsclDen(2*sW*cW)*(
 	lsclNum(1-2*sW^2)*lsclDiracChain(lsclDiracMatrix(lsclLorentzIndex(lsclS3))*lsclDiracMatrix(7),lsclDiracIndex(lsclS1),lsclDiracIndex(lsclS2))-
	lsclNum(2*sW^2)*lsclDiracChain(lsclDiracMatrix(lsclLorentzIndex(lsclS3))*lsclDiracMatrix(6),lsclDiracIndex(lsclS1),lsclDiracIndex(lsclS2))
	);

*--#] lsclFeynmanRulesLeptonsFFV:


*--#[ lsclFeynmanRulesQuarksFFV:

* Quark charged current - {ubar,cbar,tbar} {d,s,b} W^+
id lsclQGVertex(lsclF1?lsclAntiUpQuark(lsclS1?,lsclP1?), lsclF2?lsclDownQuark(lsclS2?,lsclP2?), Wp(lsclS3?,lsclP3?)) = 
  -i_*el*lsclDen(sqrt_(2)*sW)*ckmV(lsclF1,lsclF2,+1)*lsclSUNFDelta(lsclFunColorIndex(lsclS1),lsclFunColorIndex(lsclS2))*
  lsclDiracChain(lsclDiracMatrix(lsclLorentzIndex(lsclS3))*lsclDiracMatrix(7),lsclDiracIndex(lsclS1),lsclDiracIndex(lsclS2));	

* Quark charged current - {dbar,sbar,bbar} {u,c,t} W^-
id lsclQGVertex(lsclF1?lsclAntiDownQuark(lsclS1?,lsclP1?), lsclF2?lsclUpQuark(lsclS2?,lsclP2?), Wm(lsclS3?,lsclP3?)) = 
   -i_*el*lsclDen(sqrt_(2)*sW)*ckmV(lsclF1,lsclF2,-1)*lsclDiracChain(lsclDiracMatrix(lsclLorentzIndex(lsclS3))*lsclSUNFDelta(lsclFunColorIndex(lsclS1),lsclFunColorIndex(lsclS2))*
   lsclDiracMatrix(7),lsclDiracIndex(lsclS1),lsclDiracIndex(lsclS2));	
  
* Quark neutral current (qbar q Z)
id lsclQGVertex(lsclF1?lsclAntiUpQuark[lsclS](lsclS1?,lsclP1?), lsclF2?lsclUpQuark[lsclS](lsclS2?,lsclP2?), Z(lsclS3?,lsclP3?)) = 
 -i_*el*lsclDen(6*sW*cW)*(lsclNum(3-4*sW^2)*lsclSUNFDelta(lsclFunColorIndex(lsclS1),lsclFunColorIndex(lsclS2))*
 lsclDiracChain(lsclDiracMatrix(lsclLorentzIndex(lsclS3))*lsclDiracMatrix(7),lsclDiracIndex(lsclS1),lsclDiracIndex(lsclS2))-
	lsclNum(4*sW^2)*lsclDiracChain(lsclDiracMatrix(lsclLorentzIndex(lsclS3))*lsclDiracMatrix(6),lsclDiracIndex(lsclS1),lsclDiracIndex(lsclS2)));

id lsclQGVertex(lsclF1?lsclAntiDownQuark[lsclS](lsclS1?,lsclP1?), lsclF2?lsclDownQuark[lsclS](lsclS2?,lsclP2?), Z(lsclS3?,lsclP3?)) = 
 i_*el*lsclDen(6*sW*cW)*(lsclNum(3-2*sW^2)*
 lsclSUNFDelta(lsclFunColorIndex(lsclS1),lsclFunColorIndex(lsclS2))*lsclDiracChain(lsclDiracMatrix(lsclLorentzIndex(lsclS3))*lsclDiracMatrix(7),lsclDiracIndex(lsclS1),lsclDiracIndex(lsclS2))-
	lsclNum(2*sW^2)*lsclDiracChain(lsclDiracMatrix(lsclLorentzIndex(lsclS3))*lsclDiracMatrix(6),lsclDiracIndex(lsclS1),lsclDiracIndex(lsclS2)));	

* Quark-photon vertex  (qbar q gamma)

id lsclQGVertex(lsclF1?lsclAntiUpQuark[lsclS](lsclS1?,lsclP1?), lsclF2?lsclUpQuark[lsclS](lsclS2?,lsclP2?), Ga(lsclS3?,lsclP3?)) = 
 -i_*el*2/3*lsclSUNFDelta(lsclFunColorIndex(lsclS1),lsclFunColorIndex(lsclS2))*lsclDiracChain(lsclDiracMatrix(lsclLorentzIndex(lsclS3)),lsclDiracIndex(lsclS1),lsclDiracIndex(lsclS2));
 
id lsclQGVertex(lsclF1?lsclAntiDownQuark[lsclS](lsclS1?,lsclP1?), lsclF2?lsclDownQuark[lsclS](lsclS2?,lsclP2?), Ga(lsclS3?,lsclP3?)) = 
 i_*el*1/3*lsclSUNFDelta(lsclFunColorIndex(lsclS1),lsclFunColorIndex(lsclS2))*lsclDiracChain(lsclDiracMatrix(lsclLorentzIndex(lsclS3)),lsclDiracIndex(lsclS1),lsclDiracIndex(lsclS2)); 

*--#] lsclFeynmanRulesQuarksFFV:

*--#[ lsclFeynmanRulesLeptonsFFS:

* ------------------------------------------------------------------- 
* 		Yukawa interactions of leptons
* -------------------------------------------------------------------

* ellbar ell G^0
id lsclQGVertex(lsclF1?lsclAntiChargedLeptonFields[lsclS](lsclS1?,lsclP1?), lsclF2?lsclChargedLeptonFields[lsclS](lsclS2?,lsclP2?), Gb(lsclS3?,lsclP3?)) = 
 el*lsclMass(lsclF2)*lsclDen(2*sW*cW*lsclMass(Z))*lsclDiracChain(lsclDiracMatrix(5),lsclDiracIndex(lsclS1),lsclDiracIndex(lsclS2));

* ellbar ell H
id lsclQGVertex(lsclF1?lsclAntiChargedLeptonFields[lsclS](lsclS1?,lsclP1?), lsclF2?lsclChargedLeptonFields[lsclS](lsclS2?,lsclP2?), H(lsclS3?,lsclP3?)) = 
 -i_*el*lsclMass(lsclF2)*lsclDen(2*sW*cW*lsclMass(Z))*lsclDiracChain(lsclDiracMatrix(5),lsclDiracIndex(lsclS1),lsclDiracIndex(lsclS2)); 
 
* If the neutrinos are treated as massless, then these interactions proportional
* to the neutrino mass do not contribute

* id lsclQGVertex(lsclF1?lsclAntiChargedLeptonFields[lsclS](lsclS1?,lsclP1?), lsclF2?lsclChargedLeptonFields[lsclS](lsclS2?,lsclP2?), Gb(lsclS3?,lsclP3?)) = 
* lsclVertexYukawaNeutrinoG0(lsclS1,lsclS2,lsclS3);

* id lsclQGVertex(lsclF1?lsclAntiChargedLeptonFields[lsclS](lsclS1?,lsclP1?), lsclF2?lsclChargedLeptonFields[lsclS](lsclS2?,lsclP2?), H(lsclS3?,lsclP3?)) = 
* lsclVertexYukawaNeutrinoH(lsclS1,lsclS2,lsclS3);

* Need to check this more carefully P_L/R

* nubar_ell ell^- G^+
id lsclQGVertex(lsclF1?lsclAntiParticleLeptonicCurrentP[lsclS](lsclS1?,lsclP1?), lsclF2?lsclParticleLeptonicCurrentP[lsclS](lsclS2?,lsclP2?), Gbp(lsclS3?,lsclP3?)) = 
 - i_*el*lsclMass(lsclF2)*lsclDen(sqrt_(2)*sW*cW*lsclMass(Z))*lsclDiracChain(lsclDiracMatrix(6),lsclDiracIndex(lsclS1),lsclDiracIndex(lsclS2)); 

* ell^+ nu_ell G^-
id lsclQGVertex(lsclF1?lsclAntiParticleLeptonicCurrentM[lsclS](lsclS1?,lsclP1?), lsclF2?lsclParticleLeptonicCurrentM[lsclS](lsclS2?,lsclP2?), Gbm(lsclS3?,lsclP3?)) = 
 - i_*el*lsclMass(lsclF2)*lsclDen(sqrt_(2)*sW*cW*lsclMass(Z))*lsclDiracChain(lsclDiracMatrix(7),lsclDiracIndex(lsclS1),lsclDiracIndex(lsclS2)); 

*--#] lsclFeynmanRulesLeptonsFFS:


*--#[ lsclFeynmanRulesQuarksFFS:

* Yukawa interactions of quarks (FFS)

* The field composition is the same as in the case of quark charged current vertices,
* with the replacement W^+ -> G^+, W^- -> G^-

* {ubar,cbar,tbar} {d,s,b} G^+
id lsclQGVertex(lsclF1?lsclAntiUpQuark(lsclS1?,lsclP1?), lsclF2?lsclDownQuark(lsclS2?,lsclP2?), Gbp(lsclS3?,lsclP3?)) = 
  i_*el*lsclDen(sqrt_(2)*sW*cW*lsclMass(Z))*ckmV(lsclF1,lsclF2,+1)*lsclSUNFDelta(lsclFunColorIndex(lsclS1),lsclFunColorIndex(lsclS2))*(
  	lsclMass(lsclF2)*lsclDiracChain(lsclDiracMatrix(lsclLorentzIndex(lsclS3))*lsclDiracMatrix(7),lsclDiracIndex(lsclS1),lsclDiracIndex(lsclS2))-
	lsclMass(lsclF2)*lsclDiracChain(lsclDiracMatrix(lsclLorentzIndex(lsclS3))*lsclDiracMatrix(6),lsclDiracIndex(lsclS1),lsclDiracIndex(lsclS2))
	);

* {dbar,sbar,bbar} {u,c,t} G^-
id lsclQGVertex(lsclF1?lsclAntiDownQuark(lsclS1?,lsclP1?), lsclF2?lsclUpQuark(lsclS2?,lsclP2?), Gbm(lsclS3?,lsclP3?)) = 
  i_*el*lsclDen(sqrt_(2)*sW*cW*lsclMass(Z))*ckmV(lsclF1,lsclF2,-1)*lsclSUNFDelta(lsclFunColorIndex(lsclS1),lsclFunColorIndex(lsclS2))*(
  	lsclMass(lsclF2)*lsclDiracChain(lsclDiracMatrix(lsclLorentzIndex(lsclS3))*lsclDiracMatrix(7),lsclDiracIndex(lsclS1),lsclDiracIndex(lsclS2))-					
  	lsclMass(lsclF2)*lsclDiracChain(lsclDiracMatrix(lsclLorentzIndex(lsclS3))*lsclDiracMatrix(6),lsclDiracIndex(lsclS1),lsclDiracIndex(lsclS2))
  	);

* Quark neutral current vertex

id lsclQGVertex(lsclF1?lsclAntiQuarkFields[lsclS](lsclS1?,lsclP1?), lsclF2?lsclQuarkFields[lsclS](lsclS2?,lsclP2?), H(lsclS3?,lsclP3?)) = 
 -i_*el*lsclMass(lsclF2)*lsclDen(2*sW*cW*lsclMass(Z))*lsclSUNFDelta(lsclFunColorIndex(lsclS1),lsclFunColorIndex(lsclS2))*lsclDiracChain(1,lsclDiracIndex(lsclS1),lsclDiracIndex(lsclS2));
  
id lsclQGVertex(lsclF1?lsclAntiQuarkFields[lsclS](lsclS1?,lsclP1?), lsclF2?lsclQuarkFields[lsclS](lsclS2?,lsclP2?), Gb(lsclS3?,lsclP3?)) = 
 -el*lsclMass(lsclF2)*lsclDen(2*sW*cW*lsclMass(Z))*lsclSUNFDelta(lsclFunColorIndex(lsclS1),lsclFunColorIndex(lsclS2))*lsclDiracChain(lsclDiracMatrix(5),lsclDiracIndex(lsclS1),lsclDiracIndex(lsclS2));

*--#] lsclFeynmanRulesQuarksFFS:
 

*--#[ lsclFeynmanRulesGaugeBosonsVVV:

* Gauge interactions of weak gauge bosons (VVV)

* W^+(mu,p2) W^-(nu,p3) gamma (si,p1)
id lsclQGVertex(Wp(lsclS2?,lsclP2?), Wm(lsclS3?,lsclP3?), Ga(lsclS1?,lsclP1?)) = 
 -i_*el*(
 	lsclMetricTensor(lsclLorentzIndex(lsclS1),lsclLorentzIndex(lsclS2))*lsclVector(lsclP1-lsclP2,lsclLorentzIndex(lsclS3))+
 	lsclMetricTensor(lsclLorentzIndex(lsclS2),lsclLorentzIndex(lsclS3))*lsclVector(lsclP2-lsclP3,lsclLorentzIndex(lsclS1))+
 	lsclMetricTensor(lsclLorentzIndex(lsclS1),lsclLorentzIndex(lsclS3))*lsclVector(lsclP3-lsclP1,lsclLorentzIndex(lsclS2)) 	
 	);

* W^+(mu,p2)  W^- (nu,p3) Z (si,p1)
id lsclQGVertex(Wp(lsclS2?,lsclP2?), Wm(lsclS3?,lsclP3?), Z(lsclS1?,lsclP1?)) = 
 -i_*el*sW/cW*(
 	lsclMetricTensor(lsclLorentzIndex(lsclS1),lsclLorentzIndex(lsclS2))*lsclVector(lsclP1-lsclP2,lsclLorentzIndex(lsclS3))+
 	lsclMetricTensor(lsclLorentzIndex(lsclS2),lsclLorentzIndex(lsclS3))*lsclVector(lsclP2-lsclP3,lsclLorentzIndex(lsclS1))+
 	lsclMetricTensor(lsclLorentzIndex(lsclS1),lsclLorentzIndex(lsclS3))*lsclVector(lsclP3-lsclP1,lsclLorentzIndex(lsclS2)) 	
 	);
 
 
*--#] lsclFeynmanRulesGaugeBosonsVVV: 

*--#[ lsclFeynmanRulesGaugeBosonsVVVV:

* Gauge interactions of weak gauge bosons (VVVV)

* W^+ (la-s1) W^- (si-s2) gamma (mu-s3) gamma (nu-s4)
id lsclQGVertex(Wp(lsclS1?,lsclP1?), Wm(lsclS2?,lsclP2?), Ga(lsclS3?,lsclP3?), Ga(lsclS4?,lsclP4?)) = 
  -i_*el^2*(
  2*lsclMetricTensor(lsclLorentzIndex(lsclS1),lsclLorentzIndex(lsclS2))*lsclMetricTensor(lsclLorentzIndex(lsclS3),lsclLorentzIndex(lsclS4))-
    lsclMetricTensor(lsclLorentzIndex(lsclS3),lsclLorentzIndex(lsclS1))*lsclMetricTensor(lsclLorentzIndex(lsclS2),lsclLorentzIndex(lsclS4))-
    lsclMetricTensor(lsclLorentzIndex(lsclS3),lsclLorentzIndex(lsclS2))*lsclMetricTensor(lsclLorentzIndex(lsclS1),lsclLorentzIndex(lsclS4))
  );
 
* W^+ (la-s1) W^- (si-s2) Z (mu-s3) Z (nu-s4) 
id lsclQGVertex(Wp(lsclS1?,lsclP1?), Wm(lsclS2?,lsclP2?), Ga(lsclS3?,lsclP3?), Z(lsclS4?,lsclP4?)) = 
  -i_*el^2*cW^2/sW^2*(
  2*lsclMetricTensor(lsclLorentzIndex(lsclS1),lsclLorentzIndex(lsclS2))*lsclMetricTensor(lsclLorentzIndex(lsclS3),lsclLorentzIndex(lsclS4))-
    lsclMetricTensor(lsclLorentzIndex(lsclS3),lsclLorentzIndex(lsclS1))*lsclMetricTensor(lsclLorentzIndex(lsclS2),lsclLorentzIndex(lsclS4))-
    lsclMetricTensor(lsclLorentzIndex(lsclS3),lsclLorentzIndex(lsclS2))*lsclMetricTensor(lsclLorentzIndex(lsclS1),lsclLorentzIndex(lsclS4))
  );
  
* W^+ (la-s1) W^- (si-s2) gamma (mu-s3) Z (nu-s4)  
id lsclQGVertex(Wp(lsclS1?,lsclP1?), Wm(lsclS2?,lsclP2?), Ga(lsclS3?,lsclP3?), Z(lsclS4?,lsclP4?)) = 
  -i_*el^2*cW/sW*(
  2*lsclMetricTensor(lsclLorentzIndex(lsclS1),lsclLorentzIndex(lsclS2))*lsclMetricTensor(lsclLorentzIndex(lsclS3),lsclLorentzIndex(lsclS4))-
    lsclMetricTensor(lsclLorentzIndex(lsclS3),lsclLorentzIndex(lsclS1))*lsclMetricTensor(lsclLorentzIndex(lsclS2),lsclLorentzIndex(lsclS4))-
    lsclMetricTensor(lsclLorentzIndex(lsclS3),lsclLorentzIndex(lsclS2))*lsclMetricTensor(lsclLorentzIndex(lsclS1),lsclLorentzIndex(lsclS4))
  );
  
* W^+ (la-s1) W^+ (mu-s2) W^- (nu-s3) W^- (si-s4)    
id lsclQGVertex(Wp(lsclS1?,lsclP1?), Wp(lsclS2?,lsclP2?), Wm(lsclS3?,lsclP3?), Wm(lsclS4?,lsclP4?)) = 
 i_*el^2/sW^2*(
  2*lsclMetricTensor(lsclLorentzIndex(lsclS1),lsclLorentzIndex(lsclS2))*lsclMetricTensor(lsclLorentzIndex(lsclS3),lsclLorentzIndex(lsclS4))-
    lsclMetricTensor(lsclLorentzIndex(lsclS2),lsclLorentzIndex(lsclS3))*lsclMetricTensor(lsclLorentzIndex(lsclS1),lsclLorentzIndex(lsclS4))-
    lsclMetricTensor(lsclLorentzIndex(lsclS2),lsclLorentzIndex(lsclS4))*lsclMetricTensor(lsclLorentzIndex(lsclS1),lsclLorentzIndex(lsclS3))
  );

*--#] lsclFeynmanRulesGaugeBosonsVVVV: 


*--#[ lsclFeynmanRulesGoldstoneBosonsSSS:

* Self-interactions of Higgs and Goldstone bosons (SSS)

id lsclQGVertex(H(lsclS1?,lsclP1?), H(lsclS2?,lsclP2?), H(lsclS3?,lsclP3?)) = 
 -i_*3*el*lsclMass(H)^2*lsclDen(2*lsclMass(Wp)*sW);

id lsclQGVertex(H(lsclS1?,lsclP1?), Gb(lsclS2?,lsclP2?), Gb(lsclS3?,lsclP3?)) = 
 -i_*3*el*lsclMass(H)^2*lsclDen(2*lsclMass(Wp)*sW);

id lsclQGVertex(H(lsclS1?,lsclP1?), Gbm(lsclS2?,lsclP2?), Gbp(lsclS3?,lsclP3?)) = 
 -i_*3*el*lsclMass(H)^2*lsclDen(2*lsclMass(Wp)*sW); 

*--#] lsclFeynmanRulesGoldstoneBosonsSSS:


*--#[ lsclFeynmanRulesGoldstoneBosonsSSSS:

* Self-interactions of Higgs and Goldstone bosons (SSSS)

id lsclQGVertex(H(lsclS1?,lsclP1?), H(lsclS2?,lsclP2?), H(lsclS3?,lsclP3?), H(lsclS4?,lsclP4?)) = 
 -i_*3*el^2*lsclMass(H)^2*lsclDen(4*lsclMass(Wp)^2*sW^2);

id lsclQGVertex(Gb(lsclS1?,lsclP1?), Gb(lsclS2?,lsclP2?), Gb(lsclS3?,lsclP3?), Gb(lsclS4?,lsclP4?)) = 
 -i_*3*el^2*lsclMass(H)^2*lsclDen(4*lsclMass(Wp)^2*sW^2);

id lsclQGVertex(H(lsclS1?,lsclP1?), H(lsclS2?,lsclP2?), Gb(lsclS3?,lsclP3?), Gb(lsclS4?,lsclP4?)) = 
 -i_*el^2*lsclMass(H)^2*lsclDen(4*lsclMass(Wp)^2*sW^2);
 
id lsclQGVertex(H(lsclS1?,lsclP1?), H(lsclS2?,lsclP2?), Gbm(lsclS3?,lsclP3?), Gbp(lsclS4?,lsclP4?)) = 
 -i_*el^2*lsclMass(H)^2*lsclDen(4*lsclMass(Wp)^2*sW^2); 

id lsclQGVertex(Gb(lsclS1?,lsclP1?), Gb(lsclS2?,lsclP2?), Gbm(lsclS3?,lsclP3?), Gbp(lsclS4?,lsclP4?)) = 
 -i_*el^2*lsclMass(H)^2*lsclDen(4*lsclMass(Wp)^2*sW^2);

id lsclQGVertex(Gbm(lsclS1?,lsclP1?), Gbp(lsclS2?,lsclP2?), Gbm(lsclS3?,lsclP3?), Gbp(lsclS4?,lsclP4?)) = 
 -i_*el^2*lsclMass(H)^2*lsclDen(2*lsclMass(Wp)^2*sW^2); 

*--#] lsclFeynmanRulesGoldstoneBosonsSSSS:



*--#[ lsclFeynmanRulesGaugeGoldstoneBosonsSVV:

* Gauge interactions of Higgs and Goldstone bosons 

* H Z Z
id lsclQGVertex(H(lsclS1?,lsclP1?), Z(lsclS2?,lsclP2?), Z(lsclS3?,lsclP3?)) = 
 i_*el*lsclDen(sW*cW)*lsclMass(Z)*lsclMetricTensor(lsclLorentzIndex(lsclS2),lsclLorentzIndex(lsclS3));

* H W^+ W^-
id lsclQGVertex(H(lsclS1?,lsclP1?), Wp(lsclS2?,lsclP2?), Wm(lsclS3?,lsclP3?)) = 
 i_*el/sW*lsclMass(Wp)*lsclMetricTensor(lsclLorentzIndex(lsclS2),lsclLorentzIndex(lsclS3));
 
* G^+ W^- gamma
id lsclQGVertex(Gbp(lsclS1?,lsclP1?), Wm(lsclS2?,lsclP2?), Ga(lsclS3?,lsclP3?)) = 
 i_*el*cW*lsclMass(Z)*lsclMetricTensor(lsclLorentzIndex(lsclS2),lsclLorentzIndex(lsclS3)); 

* G^- W^+ gamma 
id lsclQGVertex(Gbm(lsclS1?,lsclP1?), Wp(lsclS2?,lsclP2?), Ga(lsclS3?,lsclP3?)) = 
 i_*el*cW*lsclMass(Z)*lsclMetricTensor(lsclLorentzIndex(lsclS2),lsclLorentzIndex(lsclS3));

* G^+ W^- Z
id lsclQGVertex(Gbp(lsclS1?,lsclP1?), Wm(lsclS2?,lsclP2?), Z(lsclS3?,lsclP3?)) = 
 -i_*el*sW*lsclMass(Z)*lsclMetricTensor(lsclLorentzIndex(lsclS2),lsclLorentzIndex(lsclS3)); 

* G^- W^+ Z 
id lsclQGVertex(Gbm(lsclS1?,lsclP1?), Wp(lsclS2?,lsclP2?), Z(lsclS3?,lsclP3?)) = 
 -i_*el*sW*lsclMass(Z)*lsclMetricTensor(lsclLorentzIndex(lsclS2),lsclLorentzIndex(lsclS3));     
 
* Z G^0 H
id lsclQGVertex(Z(lsclS1?,lsclP1?), Gb(lsclS2?,lsclP2?), H(lsclS3?,lsclP3?)) = 
 -el*lsclDen(2*sW*cW)*lsclVector(lsclP2+lsclP3,lsclLorentzIndex(lsclS1));

*--#] lsclFeynmanRulesGaugeGoldstoneBosonsSVV:


*--#[ lsclFeynmanRulesGaugeGoldstoneBosonsSSV:

* Gauge interactions of Higgs and Goldstone bosons 

* Need to check the sign, Pokorski is ambiguous here with +/-

* ga G^+ G^-
id lsclQGVertex(Ga(lsclS1?,lsclP1?), Gbp(lsclS2?,lsclP2?), Gbm(lsclS3?,lsclP3?)) = 
 -i_*el*lsclVector(lsclP2+lsclP3,lsclLorentzIndex(lsclS1));

* Z G^+ G^-
id lsclQGVertex(Z(lsclS1?,lsclP1?), Gbp(lsclS2?,lsclP2?), Gbm(lsclS3?,lsclP3?)) = 
 -i_*el*lsclDen(2*sW*cW)*lsclVector(lsclP2+lsclP3,lsclLorentzIndex(lsclS1));

* W^+ G^- H
id lsclQGVertex(Wp(lsclS1?,lsclP1?), Gbm(lsclS2?,lsclP2?), H(lsclS3?,lsclP3?)) = 
 i_*el*lsclDen(2*sW)*lsclVector(lsclP2+lsclP3,lsclLorentzIndex(lsclS1));

* W^- G^+ H
id lsclQGVertex(Wm(lsclS1?,lsclP1?), Gbp(lsclS2?,lsclP2?), H(lsclS3?,lsclP3?)) = 
 -i_*el*lsclDen(2*sW)*lsclVector(lsclP2+lsclP3,lsclLorentzIndex(lsclS1));

* W^+ G^- G^0
id lsclQGVertex(Wp(lsclS1?,lsclP1?), Gbm(lsclS2?,lsclP2?), Gb(lsclS3?,lsclP3?)) = 
 i_*el*lsclDen(2*sW)*lsclVector(lsclP2+lsclP3,lsclLorentzIndex(lsclS1));

* W^- G^+ G^0
id lsclQGVertex(Wm(lsclS1?,lsclP1?), Gbp(lsclS2?,lsclP2?), Gb(lsclS3?,lsclP3?)) = 
 -el*lsclDen(2*sW)*lsclVector(lsclP2+lsclP3,lsclLorentzIndex(lsclS1));

*--#] lsclFeynmanRulesGaugeGoldstoneBosonsSSV:



*--#[ lsclFeynmanRulesGaugeGoldstoneBosonsSSVV:

* Gauge interactions of Higgs and Goldstone bosons (SSVV)

* Z Z H H
id lsclQGVertex(Z(lsclS1?,lsclP1?), Z(lsclS2?,lsclP2?), H(lsclS3?,lsclP3?), H(lsclS4?,lsclP4?)) = 
 i_*el^2*lsclDen(2*sW^2*cW^2)*lsclMetricTensor(lsclLorentzIndex(lsclS1),lsclLorentzIndex(lsclS2));

* Z Z G^0 G^0
id lsclQGVertex(Z(lsclS1?,lsclP1?), Z(lsclS2?,lsclP2?), Gb(lsclS3?,lsclP3?), Gb(lsclS4?,lsclP4?)) = 
 i_*el^2*lsclDen(2*sW^2*cW^2)*lsclMetricTensor(lsclLorentzIndex(lsclS1),lsclLorentzIndex(lsclS2));


* W^+ W^- H H
id lsclQGVertex(Wp(lsclS1?,lsclP1?), Wm(lsclS2?,lsclP2?), H(lsclS3?,lsclP3?), H(lsclS4?,lsclP4?)) = 
 i_*el^2*lsclDen(2*sW^2)*lsclMetricTensor(lsclLorentzIndex(lsclS1),lsclLorentzIndex(lsclS2));

* W^+ W^- G^0 G^0
id lsclQGVertex(Wp(lsclS1?,lsclP1?), Wm(lsclS2?,lsclP2?), Gb(lsclS3?,lsclP3?), Gb(lsclS4?,lsclP4?)) = 
 i_*el^2*lsclDen(2*sW^2)*lsclMetricTensor(lsclLorentzIndex(lsclS1),lsclLorentzIndex(lsclS2));

* W^+ W^- G^+ G^-
id lsclQGVertex(Wp(lsclS1?,lsclP1?), Wm(lsclS2?,lsclP2?), Gbp(lsclS3?,lsclP3?), Gbm(lsclS4?,lsclP4?)) = 
 i_*el^2*lsclDen(2*sW^2)*lsclMetricTensor(lsclLorentzIndex(lsclS1),lsclLorentzIndex(lsclS2));

* G^+ G^- gamma gamma 
id lsclQGVertex(Ga(lsclS3?,lsclP3?), Ga(lsclS4?,lsclP4?), Gbp(lsclS1?,lsclP1?), Gbm(lsclS2?,lsclP2?)) = 
 i_*2*el^2*lsclMetricTensor(lsclLorentzIndex(lsclS3),lsclLorentzIndex(lsclS4));

* G^+ G^- Z Z
id lsclQGVertex(Z(lsclS3?,lsclP3?), Z(lsclS4?,lsclP4?), Gbp(lsclS1?,lsclP1?), Gbm(lsclS2?,lsclP2?)) = 
 i_*el^2*lsclDen(2*sW^2*cW^2)*lsclNum(1-2*sW^2)^2*lsclMetricTensor(lsclLorentzIndex(lsclS3),lsclLorentzIndex(lsclS4));

* G^+ G^- Z A
id lsclQGVertex(Z(lsclS3?,lsclP3?), Ga(lsclS4?,lsclP4?), Gbp(lsclS1?,lsclP1?), Gbm(lsclS2?,lsclP2?)) = 
 i_*el^2*lsclDen(sW*cW)*lsclNum(1-2*sW^2)*lsclMetricTensor(lsclLorentzIndex(lsclS3),lsclLorentzIndex(lsclS4));


* W^+ A G^- H
id lsclQGVertex(Wp(lsclS1?,lsclP1?), Ga(lsclS2?,lsclP2?), Gbm(lsclS3?,lsclP3?), H(lsclS4?,lsclP4?)) = 
 i_*el^2*lsclDen(2*sW)*lsclMetricTensor(lsclLorentzIndex(lsclS1),lsclLorentzIndex(lsclS2));

* W^- A G^+ H
id lsclQGVertex(Wm(lsclS1?,lsclP1?), Ga(lsclS2?,lsclP2?), Gbp(lsclS3?,lsclP3?), H(lsclS4?,lsclP4?)) = 
 i_*el^2*lsclDen(2*sW)*lsclMetricTensor(lsclLorentzIndex(lsclS1),lsclLorentzIndex(lsclS2));


* W^+ A G^- G^0
id lsclQGVertex(Wp(lsclS1?,lsclP1?), Ga(lsclS2?,lsclP2?), Gbm(lsclS3?,lsclP3?), H(lsclS4?,lsclP4?)) = 
 -i_*el^2*lsclDen(2*sW)*lsclMetricTensor(lsclLorentzIndex(lsclS1),lsclLorentzIndex(lsclS2));

* W^- A G^+ G^0
id lsclQGVertex(Wm(lsclS1?,lsclP1?), Ga(lsclS2?,lsclP2?), Gbp(lsclS3?,lsclP3?), H(lsclS4?,lsclP4?)) = 
 i_*el^2*lsclDen(2*sW)*lsclMetricTensor(lsclLorentzIndex(lsclS1),lsclLorentzIndex(lsclS2));


* W^+ Z G^- H
id lsclQGVertex(Wp(lsclS1?,lsclP1?), Z(lsclS2?,lsclP2?), Gbm(lsclS3?,lsclP3?), H(lsclS4?,lsclP4?)) = 
 -i_*el^2*lsclDen(2*cW)*lsclMetricTensor(lsclLorentzIndex(lsclS1),lsclLorentzIndex(lsclS2));

* W^- Z G^+ H
id lsclQGVertex(Wm(lsclS1?,lsclP1?), Z(lsclS2?,lsclP2?), Gbp(lsclS3?,lsclP3?), H(lsclS4?,lsclP4?)) = 
 -i_*el^2*lsclDen(2*cW)*lsclMetricTensor(lsclLorentzIndex(lsclS1),lsclLorentzIndex(lsclS2));


* W^+ Z G^- G^0
id lsclQGVertex(Wp(lsclS1?,lsclP1?), Z(lsclS2?,lsclP2?), Gbm(lsclS3?,lsclP3?), Gb(lsclS4?,lsclP4?)) = 
 i_*el^2*lsclDen(2*cW)*lsclMetricTensor(lsclLorentzIndex(lsclS1),lsclLorentzIndex(lsclS2));

* W^- Z G^+ G^0
id lsclQGVertex(Wm(lsclS1?,lsclP1?), Z(lsclS2?,lsclP2?), Gbp(lsclS3?,lsclP3?), Gb(lsclS4?,lsclP4?)) = 
 -i_*el^2*lsclDen(2*cW)*lsclMetricTensor(lsclLorentzIndex(lsclS1),lsclLorentzIndex(lsclS2));

*--#] lsclFeynmanRulesGaugeGoldstoneBosonsSSVV:



*--#[ lsclFeynmanRulesGaugeGhostsGGV:

* Gauge interactions of ghosts

* TODO Check that the vector is not lsclP2!!!

id lsclQGVertex(GhWpbar(lsclS1?,lsclP1?), GhWp(lsclS2?,lsclP2?), Ga(lsclS3?,lsclP3?)) = 
 i_*el*lsclVector(lsclP1,lsclLorentzIndex(lsclS1));

id lsclQGVertex(GhWmbar(lsclS1?,lsclP1?), GhWm(lsclS2?,lsclP2?), Ga(lsclS3?,lsclP3?)) = 
 -i_*el*lsclVector(lsclP1,lsclLorentzIndex(lsclS1));

id lsclQGVertex(GhWpbar(lsclS1?,lsclP1?), GhWp(lsclS2?,lsclP2?), Z(lsclS3?,lsclP3?)) = 
 i_*el*cW*lsclDen(sW)*lsclVector(lsclP1,lsclLorentzIndex(lsclS1));

id lsclQGVertex(GhWmbar(lsclS1?,lsclP1?), GhWm(lsclS2?,lsclP2?), Z(lsclS3?,lsclP3?)) = 
 -i_*el*cW*lsclDen(sW)*lsclVector(lsclP1,lsclLorentzIndex(lsclS1));

* TODO Check the signs here!!!

id lsclQGVertex(GhGabar(lsclS1?,lsclP1?), GhWm(lsclS2?,lsclP2?), Wp(lsclS3?,lsclP3?)) = 
 i_*el*lsclVector(lsclP1,lsclLorentzIndex(lsclS1));

id lsclQGVertex(GhGabar(lsclS1?,lsclP1?), GhWp(lsclS2?,lsclP2?), Wm(lsclS3?,lsclP3?)) = 
 -i_*el*lsclVector(lsclP1,lsclLorentzIndex(lsclS1));

id lsclQGVertex(GhWmbar(lsclS1?,lsclP1?), GhGa(lsclS2?,lsclP2?), Wm(lsclS3?,lsclP3?)) = 
 i_*el*lsclVector(lsclP1,lsclLorentzIndex(lsclS1));

id lsclQGVertex(GhWpbar(lsclS1?,lsclP1?), GhGa(lsclS2?,lsclP2?), Wp(lsclS3?,lsclP3?)) = 
 -i_*el*lsclVector(lsclP1,lsclLorentzIndex(lsclS1));

id lsclQGVertex(GhZbar(lsclS1?,lsclP1?), GhWm(lsclS2?,lsclP2?), Wp(lsclS3?,lsclP3?)) = 
 +i_*el*cW/sW*lsclVector(lsclP1,lsclLorentzIndex(lsclS1));

id lsclQGVertex(GhZbar(lsclS1?,lsclP1?), GhWp(lsclS2?,lsclP2?), Wm(lsclS3?,lsclP3?)) = 
 -i_*el*cW/sW*lsclVector(lsclP1,lsclLorentzIndex(lsclS1));

id lsclQGVertex(GhWmbar(lsclS1?,lsclP1?), GhZ(lsclS2?,lsclP2?), Wm(lsclS3?,lsclP3?)) = 
 i_*el*lsclVector(lsclP1,lsclLorentzIndex(lsclS1));

id lsclQGVertex(GhWpbar(lsclS1?,lsclP1?), GhZ(lsclS2?,lsclP2?), Wp(lsclS3?,lsclP3?)) = 
 -i_*el*lsclVector(lsclP1,lsclLorentzIndex(lsclS1));

*--#] lsclFeynmanRulesGaugeGhostsGGV:


*--#[ lsclFeynmanRulesGhostGoldstonesGGS:

* Interactions of ghosts with Higgs and Goldstones (GGS) 

id lsclQGVertex(GhWpbar(lsclS1?,lsclP1?), GhWp(lsclS2?,lsclP2?), H(lsclS3?,lsclP3?)) = 
 i_*el*lsclDen(2*sW)*lsclGaugeXiEw*lsclMass(Wp);

id lsclQGVertex(GhWmbar(lsclS1?,lsclP1?), GhWm(lsclS2?,lsclP2?), H(lsclS3?,lsclP3?)) = 
 i_*el*lsclDen(2*sW)*lsclGaugeXiEw*lsclMass(Wp);


id lsclQGVertex(GhWpbar(lsclS1?,lsclP1?), GhWp(lsclS2?,lsclP2?), Gb(lsclS3?,lsclP3?)) = 
 -i_*el*lsclDen(2*sW)*lsclGaugeXiEw*lsclMass(Wp);

id lsclQGVertex(GhWmbar(lsclS1?,lsclP1?), GhWm(lsclS2?,lsclP2?), Gb(lsclS3?,lsclP3?)) = 
 i_*el*lsclDen(2*sW)*lsclGaugeXiEw*lsclMass(Wp);


id lsclQGVertex(GhWpbar(lsclS1?,lsclP1?), GhGa(lsclS2?,lsclP2?), Gbp(lsclS3?,lsclP3?)) = 
 i_*el*lsclGaugeXiEw*lsclMass(Wp);

id lsclQGVertex(GhWmbar(lsclS1?,lsclP1?), GhGa(lsclS2?,lsclP2?), Gbm(lsclS3?,lsclP3?)) = 
 i_*el*lsclGaugeXiEw*lsclMass(Wp);


id lsclQGVertex(GhWpbar(lsclS1?,lsclP1?), GhZ(lsclS2?,lsclP2?), Gbp(lsclS3?,lsclP3?)) = 
 i_*el*lsclDen(2*sW*cW)*lsclDen(cW^2-sW^2)*lsclGaugeXiEw*lsclMass(Wp);

id lsclQGVertex(GhWmbar(lsclS1?,lsclP1?), GhZ(lsclS2?,lsclP2?), Gbm(lsclS3?,lsclP3?)) = 
 i_*el*lsclDen(2*sW*cW)*lsclDen(cW^2-sW^2)*lsclGaugeXiEw*lsclMass(Wp);


id lsclQGVertex(GhZbar(lsclS1?,lsclP1?), GhWp(lsclS2?,lsclP2?), Gbm(lsclS3?,lsclP3?)) = 
 -i_*el*lsclDen(2*sW)*lsclGaugeXiEw*lsclMass(Z);

id lsclQGVertex(GhZbar(lsclS1?,lsclP1?), GhWm(lsclS2?,lsclP2?), Gbp(lsclS3?,lsclP3?)) = 
 -i_*el*lsclDen(2*sW)*lsclGaugeXiEw*lsclMass(Z);
 
*--#] lsclFeynmanRulesGhostGoldstonesGGS:


