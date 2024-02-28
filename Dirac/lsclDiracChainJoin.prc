#procedure lsclDiracChainJoin()

* lsclDiracChainJoin() joins Dirac chains

* Here it is important to build up all A_ij B_jk chains first, before attaching the spinors
repeat id lsclDiracChain(lsclS1?,lsclDi1?,lsclDi2?)*lsclDiracChain(lsclS2?,lsclDi2?,lsclDi3?) =  lsclDiracChain(lsclS1*lsclS2,lsclDi1,lsclDi3);

repeat id lsclDiracChain(lsclF?{lsclDiracVBar,lsclDiracUBar}(lsclP?,lsclS?),lsclDi1?)*lsclDiracChain(?a,lsclDi1?,?b) = lsclDiracChain(?a,lsclF(lsclP,lsclS),?b);
repeat id lsclDiracChain(lsclDi1?,lsclF?{lsclDiracV,lsclDiracU}(lsclP?,lsclS?))*lsclDiracChain(?a,lsclDi1?,?b) = lsclDiracChain(?a,lsclF(lsclP,lsclS),?b);
repeat id lsclDiracChain(?a,lsclDi1?,lsclDi1?) = lsclDiracTrace(?a);



#endprocedure
