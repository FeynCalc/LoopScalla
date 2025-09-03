
*--#[ lsclConversionRulesTensorsAndIndices:

* For stuff inside Dirac chains
argument;
  #do k=1, `lsclPprMaxIndex'
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
  id lsclDiracMatrix(5) = g5_(100);
  id lsclDiracMatrix(6) = g6_(100);
  id lsclDiracMatrix(7) = g7_(100);


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
    id lsclDiracMatrix(5) = g5_(100);
    id lsclDiracMatrix(6) = g6_(100);
    id lsclDiracMatrix(7) = g7_(100);
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
#do k=1, `lsclPprMaxIndex'
repeat;
id lsclPolVector(p`k',lsclMu?,1) = lsclPVIp`k'(lsclMu);
id lsclPolVector(p`k',lsclMu?,-1) = lsclPVOp`k'(lsclMu);

id lsclPolVector(q`k',lsclMu?,1) = lsclPVIq`k'(lsclMu);
id lsclPolVector(q`k',lsclMu?,-1) = lsclPVOq`k'(lsclMu);
endrepeat;
#enddo

*--#] lsclConversionRulesTensorsAndIndices:

*--#[ lsclFeynmanRulesPolVectors:

* Polarization vectors
id lsclQGPolarization(lsclF?lsclScalarFields(?a)) = 1;

#if (`lsclPprTruncatePolVectors' == 1)
id lsclQGPolarization(lsclF?lsclVectorFields(?a)) = 1;
#else	
id lsclQGPolarization(lsclF?lsclVectorFields(lsclS1?even_,lsclP1?)) = 
	lsclPolVector(lsclP1,lsclLorentzIndex(lsclS1),-1);
	
id lsclQGPolarization(lsclF?lsclVectorFields(lsclS1?odd_,lsclP1?)) = 
	lsclPolVector(lsclP1,lsclLorentzIndex(lsclS1),1);	
#endif

*--#] lsclFeynmanRulesPolVectors:

*--#[ lsclFeynmanRulesSpinors:

* Spinors
#if (`lsclPprTruncateSpinors' == 1)
id lsclQGPolarization(lsclF?lsclFermionFields(?a)) = 1;
id lsclQGPolarization(lsclF?lsclAntiFermionFields(?a)) = 1;
#else
* incoming fermion
id lsclQGPolarization(lsclF?lsclFermionFields(lsclS1?odd_,lsclP1?)) = lsclDiracChain(lsclDiracIndex(lsclS1),lsclDiracU(lsclP1,lsclMass(lsclF)));
* outgoing fermion
id lsclQGPolarization(lsclF?lsclFermionFields(lsclS1?even_,lsclP1?)) = lsclDiracChain(lsclDiracUBar(lsclP1,lsclMass(lsclF)),lsclDiracIndex(lsclS1));
* outgoing antifermion
id lsclQGPolarization(lsclF?lsclAntiFermionFields(lsclS1?even_,lsclP1?)) = lsclDiracChain(lsclDiracIndex(lsclS1),lsclDiracV(lsclP1,lsclMass(lsclF)));
* incoming antifermion
id lsclQGPolarization(lsclF?lsclAntiFermionFields(lsclS1?odd_,lsclP1?)) = lsclDiracChain(lsclDiracVBar(lsclP1,lsclMass(lsclF)),lsclDiracIndex(lsclS1));
#endif


*--#] lsclFeynmanRulesSpinors:

