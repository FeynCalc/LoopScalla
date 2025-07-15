#procedure lsclPrepareTensorReduction(NAME1)

* lsclPrepareTensorReduction() prepares the tensor reduction of
* loop integrals in the active expressions. In particular, it extracts
* the dependence on external momenta from the propagator denominators
* written as lsclFAD or lsclGFAD and uncontracts the loop momenta in
* the numerator that are contracted to Dirac matrices or other external
* momenta. 

* The resulting expressions are of the form
* (...)*lsclTensRedLoop(k1(mu),k2(nu),...)*lsclTensRedMomenta(p1,p2,...)*
* lsclTensRedRank(2)*lsclTensRedNLegs(4).
* Taking the product of arguments of lsclTensRedLoop and setting 
* lsclTensRedMomenta(), lsclTensRedRank() and lsclTensRedNLegs() should
* return the original expression.

* The output of lsclPrepareTensorReduction() can be then processed using
* lsclDoTensorReduction().

#message lsclPrepareTensorReduction: Preparing loop integrals in the expression for the tensor reduction: `time_' ...

id lsclF?{lsclFAD,lsclGFAD}(?a) = `NAME1'(lsclF(?a));

* lsclFAD format is lsclFAD(v1+v2-v3 ..., m^2)
* lsclGFAD format is  lsclGFAD(v1^2 + v1.v2 + ... - m^2 + ...)
id `NAME1'(lsclFAD(lsclV1?,lsclS2?)) = lsclFAD(lsclV1,lsclS2)*lsclTensRedMomentaRaw(lsclV1);
id `NAME1'(lsclGFAD(?a)) = lsclGFAD(?a)*lsclTensRedMomentaRaw(?a);

* lsclTensRedMomentaRaw(a1*a2*a3*...) -> lsclTensRedMomentaRaw(a1,a2,a3,...) where ai can be sums of terms
factarg,lsclTensRedMomentaRaw;

* lsclTensRedMomentaRaw(a1,a2,a3,...) -> lsclTensRedMomentaRaw(a1)*lsclTensRedMomentaRaw(a2)*lsclTensRedMomentaRaw(a3)*...
chainout lsclTensRedMomentaRaw;

* lsclTensRedMomentaRaw(b1+b2+b3+...) -> lsclTensRedMomentaRaw(b1,b2,b3,...)
splitarg lsclTensRedMomentaRaw;

* lsclTensRedMomentaRaw(c1)*lsclTensRedMomentaRaw(c2)*lsclTensRedMomentaRaw(c3)*... -> lsclTensRedMomentaRaw(c1,c2,c3,....)
* now every term is just a product of symbols and vectors
chainin lsclTensRedMomentaRaw;

* lsclTensRedMomentaRaw(a1*a2*a3*...,b1*b2*b3*...,....) -> lsclTensRedMomentaRaw(a1,a2,a3,...,b1,b2,b3,...)
factarg,lsclTensRedMomentaRaw;

repeat id lsclTensRedMomentaRaw(?a,lsclV1?(lsclV2?),?b) = lsclTensRedMomentaRaw(?a,lsclV1,lsclV2,?b); 

repeat;
* Remove all nonvectors, loop momenta and multiple appearances of the same vector
id lsclTensRedMomentaRaw(?a,lsclS?,?b) = lsclTensRedMomentaRaw(?a,?b); 
id lsclTensRedMomentaRaw(?a,lsclV1?,lsclV1?,?b) = lsclTensRedMomentaRaw(?a,lsclV1,?b); 
id lsclTensRedMomentaRaw(?a,lsclV?lsclLoopMomenta,?b) = lsclTensRedMomentaRaw(?a,?b);
endrepeat;

id lsclTensRedMomentaRaw(?a) = lsclTensRedMomenta(?a)*lsclTensRedNLegs(nargs_(?a));

* At this point every integral is multiplied by a lsclTensRedMomentaSorted(...) function containing the external momenta it
* depends on. The next step is to handle loop momenta contractions
* .sort

* Dirac matrices. Since lsclDiracGamma is noncom tensor, linear combinations of momenta are being expanded automatically.
* Hence, we may only have something like lsclDiracGamma(...,k1,...) but not lsclDiracGamma(...,k1+p1,...) 
repeat;
id, once lsclDiracGamma(?a,lsclV1?lsclLoopMomenta,?b) = lsclDiracGamma(?a,N101_?,?b)*lsclTensRedLoopRaw(lsclV1(N101_?));
id, once lsclDiracTrace(lsclDiracGamma(?a,lsclV1?lsclLoopMomenta,?b)) = lsclDiracTrace(lsclDiracGamma(?a,N102_?,?b))*lsclTensRedLoopRaw(lsclV1(N102_?));
renumber;
endrepeat;

* Scalar products
repeat;
id, once lsclV1?lsclLoopMomenta.lsclV2?!lsclLoopMomenta = lsclTensRedLoopRaw(lsclV1(N101_?))*lsclV2(N101_?);
renumber;
endrepeat;

* Vectors with open indices
repeat id lsclV1?lsclLoopMomenta(lsclMu?) = lsclTensRedLoopRaw(lsclV1(lsclMu));

if (count(lsclTensRedLoopRaw,1)==0) multiply lsclTensRedLoopRaw();

* Join all lsclTensRedLoopRaw containing single momenta into one
chainin lsclTensRedLoopRaw;

* Determine the tensor rank
id lsclTensRedLoopRaw(?a) = lsclTensRedLoop(?a)*lsclTensRedTypeRaw(?a)*lsclTensRedRank(nargs_(?a));
#do i=1, `lsclNLoops'
repeat id lsclTensRedTypeRaw(?a,k`i'(lsclMu?),?b) = lsclTensRedTypeRaw(?a,k`i',?b);
#enddo

multiply replace_(lsclTensRedTypeRaw,lsclTensRedType);

if ((count(lsclTensRedRank,1)!=1) || (count(lsclTensRedNLegs,1)!=1) || (count(lsclTensRedLoop,1)!=1) || (count(lsclTensRedType,1)!=1) || (count(lsclTensRedMomenta,1)!=1) || occurs(`NAME1',lsclTensRedMomentaRaw,lsclTensRedLoopRaw,lsclTensRedTypeRaw));
print "lsclPrepareTensorReduction: Error, some integrals are not in the right form, e.g.: %t";
endif;
if ((count(lsclTensRedRank,1)!=1) || (count(lsclTensRedNLegs,1)!=1) || (count(lsclTensRedLoop,1)!=1) || (count(lsclTensRedType,1)!=1) || occurs(`NAME1',lsclTensRedMomentaRaw,lsclTensRedLoopRaw,lsclTensRedTypeRaw)) exit;

#message lsclPrepareTensorReduction: ... done: `time_'

#endprocedure