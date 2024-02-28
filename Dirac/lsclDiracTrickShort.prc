#procedure lsclDiracTrickShort()

* lsclDiracTrickShort() performs trivial simplifications 
* that reduce length of the chain without increasing the 
* number of terms. We assume that the chiral matrices have
* already been moved to the right.
#do j=0,5
repeat;
 label indexSimplify;
 id lsclDiracGamma(?a,lsclP?,lsclP?,?b) = lsclP.lsclP*lsclDiracGamma(?a,?b);
 id lsclDiracGamma(?a,lsclMu?,lsclMu?,?b) = d_(lsclMu,lsclMu)*lsclDiracGamma(?a,?b);

 id lsclDiracTrace(?a,lsclP?,lsclP?,?b) = lsclP.lsclP*lsclDiracTrace(?a,?b);
 id lsclDiracTrace(?a,lsclMu?,lsclMu?,?b) = d_(lsclMu,lsclMu)*lsclDiracTrace(?a,?b);
 
#if (`j'>=1)
 
	id lsclDiracTrace(?a,lsclP?,lsclMu?,lsclP?,?b) = 2*lsclP(lsclMu)*lsclDiracTrace(?a,lsclP,?b) - lsclP.lsclP*lsclDiracTrace(?a,lsclMu,?b);
	id lsclDiracTrace(?a,lsclMu?,lsclI1?,lsclMu?,?b) = -(`lsclDim'-2)*lsclDiracTrace(?a,lsclI1,?b);  
#if (`j'>=2)
	id lsclDiracTrace(?a,lsclP?,lsclMu?,lsclNu?,lsclP?,?b) = 2*lsclP(lsclMu)*lsclDiracTrace(?a,lsclNu,lsclP,?b) - 2*lsclP(lsclNu)*lsclDiracTrace(?a,lsclMu,lsclP,?b) + lsclP.lsclP*lsclDiracTrace(?a,lsclMu,lsclNu,?b);
	id lsclDiracTrace(?a,lsclMu?,lsclI1?,lsclI2?,lsclMu?,?b) = (`lsclDim'-4)*lsclDiracTrace(?a,lsclI1,lsclI2,?b) + 4*d_(lsclI1,lsclI2)*lsclDiracTrace(?a,?b); 
#if (`j'>=3)
	id lsclDiracTrace(?a,lsclP?,lsclMu1?,lsclMu2?,lsclMu3?,lsclP?,?b) = +2*lsclP(lsclMu1)*lsclDiracTrace(?a,lsclMu2,lsclMu3,lsclP,?b) - 2*lsclP(lsclMu2)*lsclDiracTrace(?a,lsclMu1,lsclMu3,lsclP,?b) +
  2*lsclP(lsclMu3)*lsclDiracTrace(?a,lsclMu1,lsclMu2,lsclP,?b) - lsclP.lsclP*lsclDiracTrace(?a,lsclMu1,lsclMu2,lsclMu3,?b);
	id lsclDiracTrace(?a,lsclMu?,lsclI1?,lsclI2?,lsclI3?,lsclMu?,?b) = (4- `lsclDim')*lsclDiracTrace(?a,lsclI1,lsclI2,lsclI3,?b) - 2*lsclDiracTrace(?a,lsclI3,lsclI2,lsclI1,?b);
#if (`j'>=4)
  
	id lsclDiracTrace(?a,lsclP?,lsclMu1?,lsclMu2?,lsclMu3?,lsclMu4?,lsclP?,?b) = +2*lsclP(lsclMu1)*lsclDiracTrace(?a,lsclMu2,lsclMu3,lsclMu4,lsclP,?b) - 2*lsclP(lsclMu2)*lsclDiracTrace(?a,lsclMu1,lsclMu3,lsclMu4,lsclP,?b) +
  2*lsclP(lsclMu3)*lsclDiracTrace(?a,lsclMu1,lsclMu2,lsclMu4,lsclP,?b)-  2*lsclP(lsclMu4)*lsclDiracTrace(?a,lsclMu1,lsclMu2,lsclMu3,lsclP,?b) + lsclP.lsclP*lsclDiracTrace(?a,lsclMu1,lsclMu2,lsclMu3,lsclMu4,?b);
	id lsclDiracTrace(?a,lsclMu?,lsclI1?,lsclI2?,lsclI3?,lsclI4?,lsclMu?,?b) = (`lsclDim'-4)*lsclDiracTrace(?a,lsclI1,lsclI2,lsclI3,lsclI4,?b) 
  + 2*lsclDiracTrace(?a,lsclI3,lsclI2,lsclI1,lsclI4,?b) + 2*lsclDiracTrace(?a,lsclI4,lsclI1,lsclI2,lsclI3,?b);
  
#if (`j'>=5)  

    id lsclDiracTrace(?a,lsclP?,lsclMu1?,lsclMu2?,lsclMu3?,lsclMu4?,lsclMu5?,lsclP?,?b) = +2*lsclP(lsclMu1)*lsclDiracTrace(?a,lsclMu2,lsclMu3,lsclMu4,lsclMu5,lsclP,?b) - 2*lsclP(lsclMu2)*lsclDiracTrace(?a,lsclMu1,lsclMu3,lsclMu4,lsclMu5,lsclP,?b) + 2*lsclP(lsclMu3)*lsclDiracTrace(?a,lsclMu1,lsclMu2,lsclMu4,lsclMu5,lsclP,?b)-  2*lsclP(lsclMu4)*lsclDiracTrace(?a,lsclMu1,lsclMu2,lsclMu3,lsclMu5,lsclP,?b) +
    2*lsclP(lsclMu5)*lsclDiracTrace(?a,lsclMu1,lsclMu2,lsclMu3,lsclMu4,lsclP,?b) - lsclP.lsclP*lsclDiracTrace(?a,lsclMu1,lsclMu2,lsclMu3,lsclMu4,lsclMu5,?b); 

#endif
#endif
#endif
#endif
#endif

* Rotating traces
#if (`j'>=1)
	id ifmatch->indexSimplify lsclDiracTrace(lsclMu?,lsclP?,?a,lsclP?) = lsclDiracTrace(lsclP,lsclMu,lsclP,?a);

	id ifmatch->indexSimplify lsclDiracTrace(lsclNu?,lsclMu?,?a,lsclMu?) = lsclDiracTrace(lsclMu,lsclNu,lsclMu,?a); 
#if (`j'>=2)
	id ifmatch->indexSimplify lsclDiracTrace(lsclMu1?,lsclMu2?,lsclP?,?a,lsclP?) = lsclDiracTrace(lsclP,lsclMu1,lsclMu2,lsclP,?a);
	id ifmatch->indexSimplify lsclDiracTrace(lsclMu?,lsclP?,?a,lsclP?,lsclNu?) = lsclDiracTrace(lsclP,lsclNu,lsclMu,lsclP,?a);
	id ifmatch->indexSimplify lsclDiracTrace(lsclNu2?,lsclMu1?,?a,lsclMu1?,lsclNu1?) = lsclDiracTrace(lsclMu1,lsclNu1,lsclNu2,lsclMu1,?a);
	id ifmatch->indexSimplify lsclDiracTrace(lsclNu1?,lsclNu2?,lsclMu1?,?a,lsclMu1?) = lsclDiracTrace(lsclMu1,lsclNu1,lsclNu2,lsclMu1,?a);
#if (`j'>=3)
	id ifmatch->indexSimplify lsclDiracTrace(lsclMu1?,lsclMu2?,lsclMu3?,lsclP?,?a,lsclP?) = lsclDiracTrace(lsclP,lsclMu1,lsclMu2,lsclMu3,lsclP,?a);
	id ifmatch->indexSimplify lsclDiracTrace(lsclNu2?,lsclNu3?,lsclMu1?,?a,lsclMu1?,lsclNu1?) = lsclDiracTrace(lsclMu1,lsclNu1,lsclNu2,lsclNu3,lsclMu1,?a);
	id ifmatch->indexSimplify lsclDiracTrace(lsclNu3?,lsclMu1?,?a,lsclMu1?,lsclNu1?,lsclNu2?) = lsclDiracTrace(lsclMu1,lsclNu1,lsclNu2,lsclNu3,lsclMu1,?a);
#endif 
#endif
#endif
 
 
 id lsclDiracTrace() = 4; 
 #do iii=1,20,2
 id lsclDiracTrace(lsclMu?,<lsclMu1?>,...,<lsclMu`iii'?>,lsclMu{`iii'+1}?!{,5}) = 0; 
 #enddo
 
 #include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclKinematics
endrepeat;
#message lsclDiracSimplify: Calling sort from lsclDiracTrickShort, j=`j': `time_' ...
.sort
#message lsclDiracSimplify: ... done: `time_'

#enddo

if(occurs(lsclDiracChainOpen));
argument;
 id lsclDiracGamma(?a,lsclP?,lsclP?,?b) = lsclP.lsclP*lsclDiracGamma(?a,?b);
 id lsclDiracGamma(?a,lsclMu?,lsclMu?,?b) = d_(lsclMu,lsclMu)*lsclDiracGamma(?a,?b);
endargument;
endif;

#endprocedure
