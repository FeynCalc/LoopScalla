#procedure lsclDiracChainLinearize()

* lsclDiracChainLinearize() linearizes Dirac chains


splitarg lsclDiracChain;
** Now each argument is just a single term, not a sum of terms so we can split them into proper sums
** f(a,b,c)-> f(a)+f(b)+f(c)
repeat;
id lsclDiracChain(lsclS1?,lsclS2?,?a,lsclI1?,lsclI2?) =  lsclDiracChain(lsclS1,lsclI1,lsclI2) + lsclDiracChain(lsclS2,lsclI1,lsclI2) + lsclDiracChain(?a,lsclI1,lsclI2);
* Very important, without this id statement the final result will be wrong
id lsclDiracChain(lsclI1?,lsclI2?) = 0;
id lsclDiracChain(0,lsclI1?,lsclI2?) = 0;
endrepeat;
#endprocedure
