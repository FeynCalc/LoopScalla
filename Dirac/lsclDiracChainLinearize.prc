#procedure lsclDiracChainLinearize()
* lsclDiracChainLinearize() linearizes Dirac chains
* One DiracChain may contain a very large amount of terms. Linearizing it at once
* would cause a workspace overflow.

repeat id lsclDiracChain(?a) =lsclDiracChainHold(?a);

.sort

splitarg lsclDiracChainHold;

.sort

id lsclDiracChainHold(?a) = lsclDiracChainHold(nargs_(?a)-2,?a);
** splitarg does f(a+b+c) -> f(a,b,c)
** Now each argument is just a single term, not a sum of terms so we can split them into proper sums
** f(a,b,c)-> f(a)+f(b)+f(c)

* The input expression may contain very long chains with thousands of terms. Linearizing them at once
* will cause an explosion in complexity. Instead, we do the linearization in chunks
* TODO Find a way to make this number variable
#do i = 1,1
#do j = 1,50
id  lsclDiracChainHold(lsclS?,<lsclS1?>,...,<lsclS50?>,?a,lsclI1?,lsclI2?) =  <lsclDiracChain(lsclS1,lsclI1,lsclI2)>+ ...+<lsclDiracChain(lsclS50,lsclI1,lsclI2)> + lsclDiracChainHold(lsclS-50,?a,lsclI1,lsclI2);
repeat id lsclDiracChainHold(lsclS?{,<2>,...,<49>},lsclS1?,lsclS2?,?a,lsclI1?,lsclI2?) =  lsclDiracChain(lsclS1,lsclI1,lsclI2)+  lsclDiracChain(lsclS2,lsclI1,lsclI2) + lsclDiracChainHold(lsclS-2,?a,lsclI1,lsclI2); 
repeat id  lsclDiracChainHold(1,lsclS1?,lsclI1?,lsclI2?) =  lsclDiracChain(lsclS1,lsclI1,lsclI2);
* Very important, without this id statement the final result will be wrong
id lsclDiracChain(lsclI1?,lsclI2?) = 0;
id lsclDiracChain(0,lsclI1?,lsclI2?) = 0;
id lsclDiracChainHold(0,lsclI1?,lsclI2?) = 0;
#enddo

if (occurs(lsclDiracChainHold) ) redefine i "0";
.sort

#enddo

if (occurs(lsclDiracChainHold)) exit "Something went wrong while linearizing the chains.";

.sort

#endprocedure
