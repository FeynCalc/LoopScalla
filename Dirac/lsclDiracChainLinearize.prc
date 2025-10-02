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
#do i = 1,1
#do j = 1,`lsclPprDiracChainMaxTermsToLinearize'
id  lsclDiracChainHold(lsclS?,<lsclS1?>,...,<lsclS`lsclPprDiracChainMaxTermsToLinearize'?>,?c,lsclI1?,lsclI2?) =  <lsclDiracChain(lsclS1,lsclI1,lsclI2)>+ ...+<lsclDiracChain(lsclS`lsclPprDiracChainMaxTermsToLinearize',lsclI1,lsclI2)> + 
    lsclDiracChainHold(lsclS-50,?c,lsclI1,lsclI2);

id  lsclDiracChainHold(lsclS?,<lsclS1?>,...,<lsclS50?>,?c,lsclNF1?(?a),lsclNF2?(?b)) =  <lsclDiracChain(lsclS1,lsclNF1(?a),lsclNF2(?b))>+ ...+<lsclDiracChain(lsclS`lsclPprDiracChainMaxTermsToLinearize',lsclNF1(?a),lsclNF2(?b))> + 
    lsclDiracChainHold(lsclS-`lsclPprDiracChainMaxTermsToLinearize',?c,lsclNF1(?a),lsclNF2(?b));

repeat id lsclDiracChainHold(lsclS?{,<2>,...,<{`lsclPprDiracChainMaxTermsToLinearize'-1}>},lsclS1?,lsclS2?,?c,lsclI1?,lsclI2?) =  lsclDiracChain(lsclS1,lsclI1,lsclI2)+  lsclDiracChain(lsclS2,lsclI1,lsclI2) + 
    lsclDiracChainHold(lsclS-2,?c,lsclI1,lsclI2); 
repeat id lsclDiracChainHold(lsclS?{,<2>,...,<{`lsclPprDiracChainMaxTermsToLinearize'-1}>},lsclS1?,lsclS2?,?c,lsclNF1?(?a),lsclNF2?(?b)) =  lsclDiracChain(lsclS1,lsclNF1(?a),lsclNF2(?b)) +  lsclDiracChain(lsclS2,lsclNF1(?a),lsclNF2(?b)) + 
    lsclDiracChainHold(lsclS-2,?c,lsclNF1(?a),lsclNF2(?b)); 

repeat id  lsclDiracChainHold(1,lsclS1?,lsclI1?,lsclI2?) =  lsclDiracChain(lsclS1,lsclI1,lsclI2);
repeat id  lsclDiracChainHold(1,lsclS1?,lsclNF1?(?a),lsclNF2?(?b)) =  lsclDiracChain(lsclS1,lsclNF1(?a),lsclNF2(?b));
* Very important, without this id statement the final result will be wrong
id lsclDiracChain(lsclI1?,lsclI2?) = 0;
id lsclDiracChain(0,lsclI1?,lsclI2?) = 0;
id lsclDiracChainHold(0,lsclI1?,lsclI2?) = 0;
id lsclDiracChainHold(0,lsclNF1?(?a),lsclNF2?(?b)) = 0;
#enddo

if (occurs(lsclDiracChainHold) ) redefine i "0";
.sort

#enddo

if (occurs(lsclDiracChainHold));
print "`lsclProcessName': lsclDiracChainLinearize: Error, some lsclDiracChainHold functions are still present after linearizing the chains e.g.: %t";
endif;
if (occurs(lsclDiracChainHold)) exit;


.sort

#endprocedure
