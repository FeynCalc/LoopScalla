#procedure lsclDiracTrickLong(MAX,SEED)

* lsclDiracTrickLong() performs nontrivial simplifications 
* that may increase the number of terms. We assume that the chiral matrices have
* already been moved to the right.


* TODO For very short contractions probably better to use explicit formulas

#do i=1,`MAX'
id lsclDiracGamma(?a,lsclMu?,lsclMu?,?b) = d_(lsclMu,lsclMu)*lsclDiracGamma(?a,?b);
id lsclDiracGamma(?c1,lsclMu1?,lsclMu2?,?a,lsclMu1?,?c2) = sign_(nargs_(lsclMu2,?a))*
lsclDiracGamma(?c1)*(
	(`lsclDim'-2*nargs_(lsclMu2,?a))*lsclDiracGamma(lsclMu2,?a) + 
	4*distrib_(-1,2,lsclMetricTensor,lsclDiracGamma,lsclMu2,?a)
)*lsclDiracGamma(?c2);

if(occurs(lsclDiracChainOpen));
argument;
 id lsclDiracGamma(?a,lsclMu?,lsclMu?,?b) = d_(lsclMu,lsclMu)*lsclDiracGamma(?a,?b);
 id lsclDiracGamma(?c1,lsclMu1?,lsclMu2?,?a,lsclMu1?,?c2) = sign_(nargs_(lsclMu2,?a))*
 lsclDiracGamma(?c1)*((`lsclDim'-2*nargs_(lsclMu2,?a))*lsclDiracGamma(lsclMu2,?a) + 
	4*distrib_(-1,2,lsclMetricTensor,lsclDiracGamma,lsclMu2,?a))*lsclDiracGamma(?c2);
endargument;
endif;




repeat;
id lsclDiracGamma(?a)*lsclDiracGamma(?b) = lsclDiracGamma(?a,?b);
id lsclMetricTensor(lsclMu1?,lsclMu2?) = d_(lsclMu1,lsclMu2);
id lsclDiracGamma()=1;

if(occurs(lsclDiracChainOpen));
argument;
 id lsclDiracGamma(?a)*lsclDiracGamma(?b) = lsclDiracGamma(?a,?b);
 id lsclMetricTensor(lsclMu1?,lsclMu2?) = d_(lsclMu1,lsclMu2);
 id lsclDiracGamma()=1;
endargument;
endif;



 id lsclDiracGamma(?a,lsclP?,lsclP?,?b) = lsclP.lsclP*lsclDiracGamma(?a,?b);
 id lsclDiracGamma(?a,lsclMu?,lsclMu?,?b) = d_(lsclMu,lsclMu)*lsclDiracGamma(?a,?b);

 id lsclDiracTrace(?a,lsclP?,lsclP?,?b) = lsclP.lsclP*lsclDiracTrace(?a,?b);
 id lsclDiracTrace(?a,lsclMu?,lsclMu?,?b) = d_(lsclMu,lsclMu)*lsclDiracTrace(?a,?b);
 

endrepeat;

#if (`LSCLVERBOSITY'>0)
#message lsclDiracTrickLong: Iteration `i'
#endif

#call lsclDiracIsolate(lsclNonDiracPiece{`SEED'+2*`i'},lsclNonDiracPiece{`SEED'+(2*`i'+1)})
#include lsclSharedTools.h #lsclTiming
#enddo

*endrepeat;


#endprocedure
