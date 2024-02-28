#procedure lsclDiracSimplify()

*#message lsclDiracSimplify: calling lsclToDiracGamma: `time_'
*#call lsclToDiracGamma()

* ToDiracGamma will convert g_ to DiracGammaOpen or DiracGammaChiralOpen

#message lsclDiracSimplify: Calling lsclAnti5: `time_'
#call lsclAnti5()


#ifndef LSCLTRUNCATESPINORS
if (occurs(lsclDiracGammaOpen,lsclDiracGammaChiralOpen));
print "lsclDiracSimplify: the offending term is: %t";
 exit "lsclDiracSimplify: Not all spinor chains were resolved 1";
endif;
#endif

* ===================== DIRAC ALGEBRA SIMPLIFICATION I ============================

#ifdef `DIRACSIMPLIFY'
* we need to isolate already here since Dirac traces 
* present in the expression make the number of terms blow up
#message lsclDiracSimplify: Calling lsclDiracIsolate: `time_'
#call lsclDiracIsolate(lsclNonDiracPiece0,lsclNonDiracPiece1)
#message lsclDiracSimplify: ... done: `time_'
#message lsclDiracSimplify: Calling sort: `time_' ...
.sort
#message lsclDiracSimplify: ... done: `time_'

repeat id once lsclDiracTrace(?a,lsclP?!vector_,?b) = lsclP(lsclMu100)*lsclDiracTrace(?a,lsclMu100,?b);
#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclDiracTraceSimplify

#message lsclDiracSimplify: Calling lsclDiracTrickShort: `time_' ...
#call lsclDiracTrickShort()
#message lsclDiracSimplify: ... done: `time_'


#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclKinematics

#message lsclDiracSimplify: Calling sort: `time_' ...
.sort
#message lsclDiracSimplify: ... done: `time_'

#message lsclDiracSimplify: Calling lsclDiracIsolate: `time_'
#call lsclDiracIsolate(lsclNonDiracPiece2,lsclNonDiracPiece3)
#message lsclDiracSimplify: ... done: `time_'
#message lsclDiracSimplify: Calling sort: `time_' ...
.sort
#message lsclDiracSimplify: ... done: `time_'


id lsclDiracTrace(?a) = lsclF30(nargs_(?a))*lsclDiracTrace(?a);
#message lsclDiracSimplify: Structure of Dirac traces in the expression (number of matrices) x (number of terms)

*id lsclF30(lsclI?!{,20}) = 0;
b lsclF30;
print[];

.sort
id lsclF30(?a) = 1;


#message lsclDiracSimplify: Calling lsclDiracIsolate: `time_'
#call lsclDiracIsolate(lsclNonDiracPiece4,lsclNonDiracPiece5)
#message lsclDiracSimplify: ... done: `time_'
#message lsclDiracSimplify: Calling sort: `time_' ...
.sort
#message lsclDiracSimplify: ... done: `time_'

* #include lsclSharedTools.h #lsclDebuggingDiracAlgebra

*********************************************************
#do traceLen = 1, 40

* if (count(lsclDiracTrace,1)>1) exit "Error more than one Dirac trace in an expression!";


*lsclDiracGammaOpen is a tensor, but lsclDiracTrace is a function. We need to linearize
* the latter first. This can be done using the FORM Cookbook recipe

* convering lsclDiracTrace to g_ so that we can apply the trace functions
*repeat;
#do ntraces =1,5
#message lsclDiracSimplify: Calculating a Dirac trace with `traceLen' matrices: `time_'
id, once lsclDiracTrace(<lsclI1?>,...,<lsclI`traceLen'?>) = lsclDiracGammaOpen(123,<lsclI1>,...,<lsclI`traceLen'>);

repeat id lsclDiracGammaOpen(123,lsclI1?,lsclI2?,?a) = lsclDiracGammaOpen(123,lsclI1)*lsclDiracGammaOpen(123,lsclI2,?a);
id lsclDiracGammaOpen(123,5) =  g5_(123); 
id lsclDiracGammaOpen(123,lsclI1?!{,5,6,7}) =  g_(123,lsclI1); 

if (occurs(lsclDiracGammaOpen));
print "Something went wrong during the trace calculation 1: %t";
endif;
if (occurs(lsclDiracGammaOpen)) exit;

#message lsclDiracSimplify: calculating Dirac traces: `time_'
tracen, 123;

if (occurs(g_)) exit "Something went wrong during the trace calculation 2.";

#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclKinematics
*endrepeat;
*endif;
*if (occurs(lsclDiracTrace)) redefine ii "0";
#message lsclDiracSimplify: Calling sort: `time_' ...
.sort
#message lsclDiracSimplify: ... done: `time_'

#enddo 
#enddo 

if (occurs(lsclDiracTrace));
print "Dangling traces remaining: %t";
exit;
endif;


*#enddo


*#do i = 1,1
*statements;
*if ( condition ) redefine i "0";
*.sort
*#enddo


*&.sort
*L traceTest1 = g_(123,lsclMu7,n,lsclMu7,k1,k1,nb,n,nb);
*tracen, 123;

*id n.nb = 2;


*.sort
**print;
*.sort

*#message lsclDiracSimplify: calling lsclDiracUnisolate: `time_'
*#do i=600,0,-1
* #message unisolating {2*`i'} {(2*`i'+1)}
*#call lsclDiracUnisolate(lsclNonDiracPiece{2*`i'},lsclNonDiracPiece{(2*`i'+1)})
*#include lsclSharedTools.h #lsclTiming
*#enddo




*#call lsclToFeynCalc(dia,cb1out`lsclDiaNumber'.m)

*********************************************************

* #include lsclSharedTools.h #lsclDebuggingDiracAlgebra

*#include lsclSharedTools.h #lsclTiming

#message lsclDiracSimplify: Calling sort: `time_' ...
.sort
#message lsclDiracSimplify: ... done: `time_'

#message lsclDiracSimplify: Calling lsclDiracIsolate: `time_' ...
#call lsclDiracIsolate(lsclNonDiracPiece6,lsclNonDiracPiece7)
#endif
#message lsclDiracSimplify: ... done: `time_'
* ===================== END DIRAC ALGEBRA SIMPLIFICATION I ============================

* #do j=1,`NUMEXTMOM'
* repeat;
* id lsclDiracSpinor(i`j',x1?) = lsclDiracSpinor(q`j',x1);
* endrepeat;
* #enddo

* #do j=`NUMEXTMOM'+1, `NUMEXTMOM'+1
* repeat;
* id lsclDiracSpinor(i`j',x1?)*lsclNT?{lsclDiracGammaOpen, lsclDiracGammaChiralOpen, lsclDiracGamma, lsclDiracGammaChiral}(?a) = lsclDiracSpinor(`OutgoingMomentumEquals',x1)*lsclNT(?a)*lsclDiracFlag1(1,x1,`OutgoingMomentumEquals',`OutgoingMomentum');

* id lsclNT?{lsclDiracGammaOpen, lsclDiracGammaChiralOpen, lsclDiracGamma, lsclDiracGammaChiral}(?a)*lsclDiracSpinor(i`j',x1?) = 
* lsclNT(?a)*lsclDiracSpinor(`OutgoingMomentumEquals',x1)*lsclDiracFlag1(2,x1,`OutgoingMomentumEquals',`OutgoingMomentum');
* endrepeat;
* #enddo


* ===================== DIRAC ALGEBRA SIMPLIFICATION II ============================


* Notice that lsclDiracTrickLong and lsclDiracTrickShort work with DiracGamma, not DiracGammaOpen!

#ifdef `DIRACSIMPLIFY'

#message lsclDiracSimplify: calling lsclDiracTrickShort: `time_'
#call lsclDiracTrickShort()
*.sort
*b lsclDCh,lsclDiracGamma, lsclDiracGammaChiral,lsclDiracGammaOpen, lsclDiracGammaChiralOpen, lsclDiracSpinor, lsclDiracTrace,lsclDiracFlag1;
*print[];
*.end

*#include lsclSharedTools.h #lsclTiming

#message lsclDiracSimplify: Calling sort: `time_' ...
.sort
#message lsclDiracSimplify: ... done: `time_'


#call lsclDiracIsolate(lsclNonDiracPiece8,lsclNonDiracPiece9)

#message lsclDiracSimplify: calling lsclDiracTrickLong: `time_'
#call lsclDiracTrickLong(45,10)

#message lsclDiracSimplify: Calling sort: `time_' ...
.sort
#message lsclDiracSimplify: ... done: `time_'


#ifndef LSCLTRUNCATESPINORS
#message lsclDiracSimplify: calling lsclDiracEquation: `time_'
#call lsclDiracEquation(45,200,45,500)

#message lsclDiracSimplify: Calling sort: `time_' ...
.sort
#message lsclDiracSimplify: ... done: `time_'


#message lsclDiracSimplify: calling lsclDiracTrickLong again: `time_'
#call lsclDiracTrickLong(45,700)

#message lsclDiracSimplify: Calling sort: `time_' ...
.sort
#message lsclDiracSimplify: ... done: `time_'

#endif

#message lsclDiracSimplify: calling lsclDiracOrder: `time_'
#call lsclDiracOrder(45,900)

#message lsclDiracSimplify: Calling sort: `time_' ...
.sort
#message lsclDiracSimplify: ... done: `time_'


#message lsclDiracSimplify: calling lsclDiracTrickLong: `time_'
#call lsclDiracTrickLong(45,1100)

#message lsclDiracSimplify: Calling sort: `time_' ...
.sort
#message lsclDiracSimplify: ... done: `time_'



#message lsclDiracSimplify: further manipulations of Dirac chains

#ifndef LSCLTRUNCATESPINORS
id lsclDiracSpinor(?x1)*lsclDiracGammaChiral(lsclI1?{6,7})*lsclDiracSpinor(?x2)*
lsclDiracSpinor(?x3)*lsclDiracGammaChiral(lsclI2?{6,7})*lsclDiracSpinor(?x4) =
	lsclDCh(lsclDiracSpinor(?x1),lsclI1,lsclDiracSpinor(?x2))*
	lsclDCh(lsclDiracSpinor(?x3),lsclI2,lsclDiracSpinor(?x4));
#endif	
	
#endif
* ===================== END DIRAC ALGEBRA SIMPLIFICATION II ============================


* Special block to use if no simplification of the Dirac algebra took place
#ifndef `DIRACSIMPLIFY'
**********************
repeat;
id lsclDiracSpinor(?x1)*lsclDiracGamma(?a)*lsclDiracGammaChiral(lsclI1?{6,7})*lsclDiracSpinor(?x2) = 
	lsclDCh(lsclDiracSpinor(?x1),?a,lsclI1,lsclDiracSpinor(?x2));
endrepeat;
**********************
#endif



* #do i=1,40
* id lsclDiracSpinor(?x1)*lsclDiracGamma(<lsclMu1?>,...,<mu`i'?>)*lsclDiracGammaChiral(lsclI1?{6,7})*lsclDiracSpinor(?x2)*
* lsclDiracSpinor(?x3)*lsclDiracGamma(<lsclMu1?>,...,<mu`i'?>)*lsclDiracGammaChiral(lsclI2?{6,7})*lsclDiracSpinor(?x4) =
*	lsclDCh(lsclDiracSpinor(?x1),<[V1]>,...,<[V`i']>,lsclI1,lsclDiracSpinor(?x2))*
*	lsclDCh(lsclDiracSpinor(?x3),<[V1]>,...,<[V`i']>,lsclI2,lsclDiracSpinor(?x4));

* id lsclDiracSpinor(?x1)*lsclDiracGamma(<lsclMu1?>,...,<mu`i'?>)*lsclDiracGammaChiral(lsclI1?{6,7})*lsclDiracSpinor(?x2)*
* lsclDiracSpinor(?x3)*lsclDiracGamma(<lsclMu1?>,...,<mu`i'?>)*lsclDiracSpinor(?x4) =
*	lsclDCh(lsclDiracSpinor(?x1),<[V1]>,...,<[V`i']>,lsclI1,lsclDiracSpinor(?x2))*
*	lsclDCh(lsclDiracSpinor(?x3),<[V1]>,...,<[V`i']>,lsclDiracSpinor(?x4));
	
	

*id lsclDiracSpinor(?x1)*lsclDiracGamma(<lsclMu1?>,...,<mu`i'?>)*lsclDiracGammaChiral(lsclI1?{6,7})*lsclDiracSpinor(?x2)*
* lsclDiracSpinor(?x3)*lsclDiracGamma(<lsclMu1?>,...,<mu`i'?>)*lsclDiracSpinor(?x4) =
*	lsclDCh(lsclDiracSpinor(?x1),<[V1]>,...,<[V`i']>,lsclI1,lsclDiracSpinor(?x2))*
* 	lsclDCh(lsclDiracSpinor(?x3),<[V1]>,...,<[V`i']>,lsclDiracSpinor(?x4));	
* #enddo

*id lsclDiracSpinor(?x1)*lsclDiracGamma(mu1?!{[V1]})*lsclDiracSpinor(?x2)*PolVec(mu1?!{[V1]})  =
*	lsclDCh(lsclDiracSpinor(?x1),[V1],lsclDiracSpinor(?x2))*PolVec([V1]);



* if ((count(lsclDCh,1)<2) && (occurs(PolVec)==0)) exit "Failed to build up lsclDCh expressions";


repeat;
id lsclDCh(lsclDiracSpinor(lsclQ1?,lsclX1?),?a,lsclDiracSpinor(?b))*lsclDiracFlag1(1,lsclX1?,lsclQ1?,lsclQ2?) = 
	lsclDCh(lsclDiracSpinor(lsclQ2,lsclX1),?a,lsclDiracSpinor(?b));

id lsclDCh(lsclDiracSpinor(?b),?a,lsclDiracSpinor(lsclQ1?,lsclX1?))*lsclDiracFlag1(2,lsclX1?,lsclQ1?,lsclQ2?) = 
	lsclDCh(lsclDiracSpinor(?b),?a,lsclDiracSpinor(lsclQ2,lsclX1));
endrepeat;

b lsclDCh,lsclDiracSpinor,lsclDiracFlag1,lsclDiracGammaChiral,lsclDiracGamma,lsclDiracTrace;
print;
.sort

if (occurs(lsclDiracFlag1));
 exit "Not all spinor chains were recovered 2";
endif;

repeat;
id lsclDCh(lsclDiracSpinor(lsclQ1?,lsclZ?,1),?a) = lsclDCh(lsclDiracUBar(lsclQ1,lsclZ),?a);
id lsclDCh(lsclDiracSpinor(lsclQ1?,lsclZ?,-1),?a) = lsclDCh(lsclDiracVBar(lsclQ1,lsclZ),?a);
id lsclDCh(?a,lsclDiracSpinor(lsclQ1?,lsclZ?,1)) = lsclDCh(?a,lsclDiracU(lsclQ1,lsclZ));
id lsclDCh(?a,lsclDiracSpinor(lsclQ1?,lsclZ?,-1)) = lsclDCh(?a,lsclDiracV(lsclQ1,lsclZ));
endrepeat;


#include lsclSharedTools.h #lsclTiming

#message lsclDiracSimplify: calling lsclDiracUnisolate: `time_'
#do i=600,0,-1
* #message lsclDiracSimplify: {2*`i'} {(2*`i'+1)}
#call lsclDiracUnisolate(lsclNonDiracPiece{2*`i'},lsclNonDiracPiece{(2*`i'+1)})
.sort
on shortstats;
*#include lsclSharedTools.h #lsclTiming
*.sort
#enddo

if (occurs(lsclNonDiracPiece0,...,lsclNonDiracPiece800)) exit "DiracSimplfy: Error unisolating expressions";



#include lsclSharedTools.h #lsclTiming

* b lsclDCh,lsclDiracSpinor,lsclDiracFlag1,lsclDiracGammaChiral,lsclDiracGamma;
* print;
* .sort

*#call lsclDiracUnisolate(lsclNonDiracPiece3,lsclNonDiracPiece4)
*#call lsclDiracUnisolate(lsclNonDiracPiece1,lsclNonDiracPiece2)

#endprocedure
