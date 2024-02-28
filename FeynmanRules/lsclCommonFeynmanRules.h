
*--#[ lsclConversionRulesTensorsAndIndices:

* For stuff inside Dirac chains
argument;
  #do k=1, `LSCLMAXINDEX'
  id lsclDiracIndex(`k') = lsclDi`k';
  id lsclDiracIndex(-`k') = lsclDj`k';

  id lsclFunColorIndex(`k') = lsclCFi`k';
  id lsclFunColorIndex(-`k') = lsclCFj`k';

  id lsclAdjColorIndex(`k') = lsclCAi`k';
  id lsclAdjColorIndex(-`k') = lsclCAj`k';

  id lsclLorentzIndex(`k') = lsclMu`k';
  id lsclLorentzIndex(-`k') = lsclNu`k';

* For vectors inside holds
  id lsclVector(lsclP?,lsclLorentzIndex(`k')) = lsclHold(lsclP(lsclMu`k'));
  id lsclVector(lsclP?,lsclLorentzIndex(-`k')) = lsclHold(lsclP(lsclNu`k'));

* Dirac matrices are inside Dirac chains!s
  id lsclDiracMatrix(lsclLorentzIndex(`k')) = g_(100,lsclMu`k');
  id lsclDiracMatrix(lsclLorentzIndex(-`k')) = g_(100,lsclNu`k');


* For stuff wrapped into holds
  argument;

    id lsclDiracIndex(`k') = lsclDi`k';
    id lsclDiracIndex(-`k') = lsclDj`k';

    id lsclFunColorIndex(`k') = lsclCFi`k';
    id lsclFunColorIndex(-`k') = lsclCFj`k';

    id lsclAdjColorIndex(`k') = lsclCAi`k';
    id lsclAdjColorIndex(-`k') = lsclCAj`k';

    id lsclVector(lsclP?,lsclLorentzIndex(`k')) = lsclHold(lsclP(lsclMu`k'));
    id lsclVector(lsclP?,lsclLorentzIndex(-`k')) = lsclHold(lsclP(lsclNu`k'));

    id lsclLorentzIndex(`k') = lsclMu`k';
    id lsclLorentzIndex(-`k') = lsclNu`k';

    id lsclDiracMatrix(lsclLorentzIndex(`k')) = g_(100,lsclMu`k');
    id lsclDiracMatrix(lsclLorentzIndex(-`k')) = g_(100,lsclNu`k');
  endargument;

  #enddo

* For Dirac matrices inside Dirac chains
  id lsclDiracMatrix(lsclP?) = lsclNCHold(g_(100,lsclP));
  
* For metric tesnors inside holds
  id lsclMetricTensor(lsclMu?,lsclNu?) = d_(lsclMu,lsclNu);

* For the Dirac objects inside holds
  #call lsclDiracChainJoin()

* For the colored objects inside holds
  #call lsclColorChainJoin()

endargument;

if (occurs(lsclDiracMatrix));
print "lsclFeynmanRules: Something went wrong eliminating lsclDiracMatrix objects: %t";
endif;

* For metric tesnors outside of the holds
id lsclMetricTensor(lsclMu?,lsclNu?) = d_(lsclMu,lsclNu);

* For vectors outside of the holds
id lsclVector(lsclP?,lsclMu?) = lsclHold(lsclP(lsclMu));

* For the Dirac objects outside of the holds
#call lsclDiracChainJoin()

* For the colored objects outside of the holds
#call lsclColorChainJoin()

* For the polarization vectors (those never go into holds)
#do k=1, `LSCLMAXINDEX'
repeat;
id lsclPolVector(p`k',lsclMu?,1) = lsclPVIp`k'(lsclMu);
id lsclPolVector(p`k',lsclMu?,-1) = lsclPVOp`k'(lsclMu);

id lsclPolVector(q`k',lsclMu?,1) = lsclPVIq`k'(lsclMu);
id lsclPolVector(q`k',lsclMu?,-1) = lsclPVOq`k'(lsclMu);
endrepeat;
#enddo

*--#] lsclConversionRulesTensorsAndIndices:





*--#[ lsclFeynmanRulesQCDVertices:


* Quark-gluon vertex
id lsclQGVertex(lsclF1?{Qbar,Qbbar,Qubar}(lsclS1?,lsclP1?), lsclF2?{Q,Qb,Qu}(lsclS2?,lsclP2?), Gl(lsclS3?,lsclP3?)) = 
 i_*gs*lsclDiracChain(lsclDiracMatrix(lsclLorentzIndex(lsclS3)),lsclDiracIndex(lsclS1),lsclDiracIndex(lsclS2))*
 lsclSUNTF(lsclAdjColorIndex(lsclS3),lsclFunColorIndex(lsclS1),lsclFunColorIndex(lsclS2));
 

* Gluon-ghost vertex
id lsclQGVertex(Ghbar(lsclS1?,lsclP1?), Gl(lsclS2?,lsclP2?), Gh(lsclS3?,lsclP3?)) = 
	-gs*lsclSUNF(lsclAdjColorIndex(lsclS1),lsclAdjColorIndex(lsclS2),lsclAdjColorIndex(lsclS3))*(-lsclVector(lsclP1,lsclLorentzIndex(lsclS2)));


* 3-gluon vertex

repeat;
id, once lsclQGVertex(Gl(lsclS1?,lsclP1?), Gl(lsclS2?,lsclP2?), Gl(lsclS3?,lsclP3?)) = 
 gs*(
 	lsclSUNF(lsclAdjColorIndex(lsclS1),lsclAdjColorIndex(lsclS2),lsclAdjColorIndex(lsclS3))*
 	(
 	lsclMetricTensor(lsclLorentzIndex(lsclS1),lsclLorentzIndex(lsclS2))*lsclVector(lsclP1-lsclP2,lsclLorentzIndex(lsclS3))+
 	lsclMetricTensor(lsclLorentzIndex(lsclS2),lsclLorentzIndex(lsclS3))*lsclVector(lsclP2-lsclP3,lsclLorentzIndex(lsclS1))+
 	lsclMetricTensor(lsclLorentzIndex(lsclS1),lsclLorentzIndex(lsclS3))*lsclVector(lsclP3-lsclP1,lsclLorentzIndex(lsclS2)) 	
 	) 	 
 );
renumber;
endrepeat;

* 4-gluon vertex

repeat;
id, once lsclQGVertex(Gl(lsclS1?,lsclP1?), Gl(lsclS2?,lsclP2?), Gl(lsclS3?,lsclP3?), Gl(lsclS4?,lsclP4?)) = 
 -i_*gs^2*(
 	lsclSUNF(lsclAdjColorIndex(lsclS1),lsclAdjColorIndex(lsclS2),N101_?)*
	lsclSUNF(lsclAdjColorIndex(lsclS3),lsclAdjColorIndex(lsclS4),N101_?)*
	(
	 lsclMetricTensor(lsclLorentzIndex(lsclS1),lsclLorentzIndex(lsclS3))*lsclMetricTensor(lsclLorentzIndex(lsclS2),lsclLorentzIndex(lsclS4))-
	 lsclMetricTensor(lsclLorentzIndex(lsclS1),lsclLorentzIndex(lsclS4))*lsclMetricTensor(lsclLorentzIndex(lsclS2),lsclLorentzIndex(lsclS3))
	) +
	lsclSUNF(lsclAdjColorIndex(lsclS1),lsclAdjColorIndex(lsclS3),N101_?)*
	lsclSUNF(lsclAdjColorIndex(lsclS2),lsclAdjColorIndex(lsclS4),N101_?)*
	(
	 lsclMetricTensor(lsclLorentzIndex(lsclS1),lsclLorentzIndex(lsclS2))*lsclMetricTensor(lsclLorentzIndex(lsclS3),lsclLorentzIndex(lsclS4))-
	 lsclMetricTensor(lsclLorentzIndex(lsclS1),lsclLorentzIndex(lsclS4))*lsclMetricTensor(lsclLorentzIndex(lsclS2),lsclLorentzIndex(lsclS3))
	) +
	
	lsclSUNF(lsclAdjColorIndex(lsclS1),lsclAdjColorIndex(lsclS4),N101_?)*
	lsclSUNF(lsclAdjColorIndex(lsclS2),lsclAdjColorIndex(lsclS3),N101_?)*
	(
	 lsclMetricTensor(lsclLorentzIndex(lsclS1),lsclLorentzIndex(lsclS2))*lsclMetricTensor(lsclLorentzIndex(lsclS3),lsclLorentzIndex(lsclS4))-
	 lsclMetricTensor(lsclLorentzIndex(lsclS1),lsclLorentzIndex(lsclS3))*lsclMetricTensor(lsclLorentzIndex(lsclS2),lsclLorentzIndex(lsclS4))
	) 
 
 );
renumber;
endrepeat;


*--#] lsclFeynmanRulesQCDVertices:


*--#[ lsclFeynmanRulesQCDPropagators:

* Quark propagator
id lsclQGPropagator(lsclF1?{Q,Qb,Qu}(lsclS1?,lsclP1?), lsclF2?{Qbar,Qbbar,Qubar}(lsclS2?,lsclP2?)) = 
 i_*lsclSUNFDelta(lsclFunColorIndex(lsclS1),lsclFunColorIndex(lsclS2))*
 lsclDiracChain(lsclNCHold(g_(100,lsclP1))+lsclMass(lsclF1),lsclDiracIndex(lsclS1),lsclDiracIndex(lsclS2))*lsclFAD(lsclP1,lsclMass(lsclF1));


* Gluon propagator
id lsclQGPropagator(Gl(lsclS1?,lsclP1?), Gl(lsclS2?,lsclP2?)) = 
 -i_*lsclSUNDelta(lsclAdjColorIndex(lsclS1),lsclAdjColorIndex(lsclS2))*lsclHold(
 lsclMetricTensor(lsclLorentzIndex(lsclS1),lsclLorentzIndex(lsclS2))*lsclFAD(lsclP1,0) 
 -lsclGaugeXi*lsclVector(lsclP1,lsclLorentzIndex(lsclS1))*lsclVector(lsclP1,lsclLorentzIndex(lsclS2))*lsclFAD(lsclP1,0)^2
);

* Ghost propagator
id lsclQGPropagator(Gh(lsclS1?,lsclP1?), Ghbar(lsclS2?,lsclP2?)) = 
 i_*lsclSUNDelta(lsclAdjColorIndex(lsclS1),lsclAdjColorIndex(lsclS2))*lsclFAD(lsclP1,0);

*--#] lsclFeynmanRulesQCDPropagators:


*--#[ lsclFeynmanRulesPolVectors:

* Polarization vectors
#if (`LSCLTRUNCATEPOLVECTORS' == 1)
id lsclQGPolarization(lsclF?{W,Gl}(?a)) = 1;
#else	
id lsclQGPolarization(lsclF?{W,Gl}(lsclS1?even_,lsclP1?)) = 
	lsclPolVector(lsclP1,lsclLorentzIndex(lsclS1),-1);
	
id lsclQGPolarization(lsclF?{W,Gl}(lsclS1?odd_,lsclP1?)) = 
	lsclPolVector(lsclP1,lsclLorentzIndex(lsclS1),1);	
#endif

*--#] lsclFeynmanRulesPolVectors:

*--#[ lsclFeynmanRulesSpinors:

* Spinors
#if (`LSCLTRUNCATESPINORS' == 1)
id lsclQGPolarization(lsclF?{Q,Qb,Qu,Qbar,Qbbar,Qubar}(?a)) = 1;
#else
id lsclQGPolarization(lsclF?{Q,Qb,Qu}(lsclS1?odd_,lsclP1?)) = lsclDiracChain(lsclDiracIndex(lsclS1),lsclDiracU(lsclP1,lsclMass(lsclF)));
id lsclQGPolarization(lsclF?{Q,Qb,Qu}(lsclS1?even_,lsclP1?)) = lsclDiracChain(lsclDiracUBar(lsclP1,lsclMass(lsclF)),lsclDiracIndex(lsclS1));

id lsclQGPolarization(lsclF?{Qbar,Qbbar,Qubar}(lsclS1?even_,lsclP1?)) = lsclDiracChain(lsclDiracIndex(lsclS1),lsclDiracV(lsclP1,lsclMass(lsclF)));
id lsclQGPolarization(lsclF?{Qbar,Qbbar,Qubar}(lsclS1?odd_,lsclP1?)) = lsclDiracChain(lsclDiracVBar(lsclP1,lsclMass(lsclF)),lsclDiracIndex(lsclS1));
#endif


*--#] lsclFeynmanRulesSpinors:

