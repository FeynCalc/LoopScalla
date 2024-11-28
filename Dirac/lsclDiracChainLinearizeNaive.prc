#procedure lsclDiracChainLinearizeNaive()
* lsclDiracChainLinearizeNaive() linearizes Dirac chains naively

splitarg lsclDiracChainHold;

repeat;
id lsclDiracChain(lsclS1?,lsclS2?,?a,lsclI1?,lsclI2?) =  lsclDiracChain(lsclS1,lsclI1,lsclI2)+  lsclDiracChain(lsclS2,lsclI1,lsclI2) + lsclDiracChain(lsclS,?a,lsclI1,lsclI2); 
* Very important, without this id statement the final result will be wrong
id lsclDiracChain(lsclI1?,lsclI2?) = 0;
id lsclDiracChain(0,lsclI1?,lsclI2?) = 0;
endrepeat;

#endprocedure
