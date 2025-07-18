* This file is a part of LoopScalla, a framework for loop calculations
* LoopScalla is covered by the GNU General Public License 3.
* Copyright (C) 2019-2025 Vladyslav Shtabovenko

on shortstats;
on HighFirst;

#include lsclDeclarations.h
#include lsclDefinitions.h
#include Projects/`lsclProjectName'/FeynmanRules/lsclParticles_`lsclModelName'.h

#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclGeneric

.global

#message lsclProcessStage0: Project: `lsclProjectName'
#message lsclProcessStage0: Process: `lsclProcessName'
#message lsclProcessStage0: Model: `lsclModelName'
#message lsclProcessStage0: Processing diagram `lsclDiaNumber' at `lsclNLoops' loop(s)

G s0dia`lsclDiaNumber'L`lsclNLoops' =
  #include Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Input/dia`lsclDiaNumber'L`lsclNLoops'.frm # dia`lsclDiaNumber'L`lsclNLoops'



#if (`LSCLINSERTPROJECTOR' == 1)
#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclInsertProjector
#endif


#message lsclProcessStage0: Linearizing Dirac chains: `time_' ...
#call lsclDiracChainLinearizeNaive()
#call lsclDiracTraceLinearize()
#message lsclProcessStage0: ... done: `time_'


#message lsclProcessStage0: Calling the CodeBlock0 fold : `time_' ...
#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclCodeBlock0
#message lsclProcessStage0: ... done.

#message lsclProcessStage0: Linearizing Dirac chains: `time_' ...
#call lsclDiracChainLinearize()
 #call lsclDiracTraceLinearize()
#message lsclProcessStage0: ... done: `time_'

.sort

* If we try to join the chains before linearizing them, we'll run into the
* MaxTermSize issue.
#message lsclProcessStage0: Joining Dirac chains: `time_' ...
#call lsclDiracChainJoin()
#message lsclProcessStage0: ... done: `time_'


.sort


#message lsclProcessStage0: Joining Color chains: `time_' ...
#call lsclColorChainJoin()
#message lsclProcessStage0: ... done: `time_'


.sort


#message lsclProcessStage0: Linearizing Dirac chains: `time_' ...
#call lsclDiracChainLinearize()
#call lsclDiracTraceLinearize()
#message lsclProcessStage0: ... done: `time_'

* lsclDiracChain is a (commutative) container for Dirac matrices with explicit Dirac indices.
* The first argument contains the matrices, while the 2nd and 3rd ones denote the indices.
* All Dirac objects are contained inside the lsclDiracChain container. Calling lsclToDiracGamma 
* replaces g_ with lsclDiracGammaOpen or lsclDiracGammaChiralOpen, so at this point there are no g_'s left!
#message lsclProcessStage0: Rewriting Dirac spinors : `time_' ...
argument;

#call lsclToDiracGamma
endargument;


* We convert lsclDiracChain it to the noncommutative lsclDiracChainNC and pull out the spinors.
* At this point there are no lsclDiracChain objects left in the expression.
* At the end every lsclDiracChainNC that had spinors attached to it loses its 2nd and 3rd arguments 
* and has only one argument containing the matrices. Those with explicit Dirac indices still keep
* their 2nd and 3rd arguments.

id lsclDiracChain(?a) = lsclDiracChainNC(?a);
id lsclDiracChainNC(?a,lsclDiracU(?s)) = lsclDiracChainNC(?a,1)*lsclDiracSpinor(?s,1);
id lsclDiracChainNC(?a,lsclDiracV(?s)) = lsclDiracChainNC(?a,1)*lsclDiracSpinor(?s,-1);
id lsclDiracChainNC(?a,lsclDiracUBar(?s),?b) = lsclDiracSpinor(?s,1)*lsclDiracChainNC(?a,1,?b);
id lsclDiracChainNC(?a,lsclDiracVBar(?s),?b) = lsclDiracSpinor(?s,-1)*lsclDiracChainNC(?a,1,?b);
id lsclDiracChainNC(?a,1,1) = lsclDiracChainNC(?a);

if (occurs(lsclDiracChain,lsclDiracU,lsclDiracV,lsclDiracUBar,lsclDiracVBar));
exit "Something went wrong while rewriting spinors";
endif;

* An lsclDiracChainNC with open Dirac indices get converted lsclDiracChainOpen, that also has
* three arguments. 
id lsclDiracChainNC(?a,lsclDi1?,lsclDi2?) = lsclDiracChainOpen(?a,lsclDi1,lsclDi2);

* So at this point the structures we can have are of the form
* - lsclDiracSpinor(...)*lsclDiracChainNC(...*lsclDiracGammaOpen(...)*...)*lsclDiracSpinor(...)
* - lsclDiracChainOpen(...*lsclDiracGammaOpen(...)*...,i,j)
* - lsclDiracTrace(...*lsclDiracGammaOpen(...)*...)
* Notice that the arguments can still have lsclDiracGammaOpen(...) multiplied with c-numbers.
* We eliminate those in the next step.
.sort
#message lsclProcessStage0: ... done: `time_'

#message lsclProcessStage0: Linearizing Dirac chains and traces : `time_' ...
* We start to apply linearity to lsclDiracChainNC, lsclDiracTrace and lsclDiracChainOpen
* First of all, if the arguments contain sums, they will be rewritten as f(a+b+c) -> f(a,b,c)
splitarg lsclDiracChainNC;
splitarg lsclDiracChainOpen;
splitarg lsclDiracTrace;

* Do the splitting f(a,b,c) -> f(a) + f(b) + f(c)
repeat;
id, once lsclF?{lsclDiracChainNC,lsclDiracTrace}(lsclS1?,lsclS2?,?a) = lsclF(lsclS1) + lsclF(lsclS2,?a);
id, once lsclDiracChainOpen(lsclS1?,lsclS2?,?a,lsclDi1?,lsclDi2?) = lsclDiracChainOpen(lsclS1,lsclDi1,lsclDi2) + lsclDiracChainOpen(lsclS2,?a,lsclDi1,lsclDi2);
endrepeat;

* We rewrite f(a*b*c) -> f(a,b,c);
FactArg,lsclDiracChainNC,lsclDiracChainOpen,lsclDiracTrace;

* We pull out all symbolic prefactors multiplying lsclDiracGammaOpen inside lsclDiracTrace
multiply replace_(lsclDiracTrace,lsclAuxHoldFunction);
repeat;
id lsclAuxHoldFunction(?a,lsclDiracGammaOpen(?c),?b) = lsclDiracTrace(lsclDiracGammaOpen(?c))*lsclAuxHoldFunction(?a,?b);
endrepeat;
repeat;
id lsclAuxHoldFunction(lsclS1?,?a) = lsclS1*lsclAuxHoldFunction(?a);
id lsclAuxHoldFunction()=1;
endrepeat;


if (occurs(lsclAuxHoldFunction));
exit "Something went wrong when factoring lsclDiracTrace.";
endif;


* We pull out all symbolic prefactors multiplying lsclDiracGammaOpen inside lsclDiracChainOpen
multiply replace_(lsclDiracChainOpen,lsclAuxHoldFunction);
repeat;
id lsclAuxHoldFunction(?a,lsclDiracGammaOpen(?c),?b,lsclDi1?,lsclDi2?) = lsclDiracChainOpen(lsclDiracGammaOpen(?c),lsclDi1,lsclDi2)*lsclAuxHoldFunction(?a,?b,lsclDi1,lsclDi2);
endrepeat;
repeat;
id lsclAuxHoldFunction(lsclS1?,?a) = lsclS1*lsclAuxHoldFunction(?a);
id lsclAuxHoldFunction(lsclDi1?,lsclDi2?)=1;
endrepeat;

if (occurs(lsclAuxHoldFunction));
exit "Something went wrong when factoring lsclDiracChainOpen.";
endif;

* TODO What about lsclDiracChainNC?

.sort
#message lsclProcessStage0: ... done: `time_'

#message lsclProcessStage0: Rebuilding Dirac traces and open Dirac chains : `time_' ...

* Finally, we eliminate lsclDiracGammaOpen in favor of lsclDiracGamma that contains only the indices
* as its arguments.

* To that aim we can also get rid of lsclDiracChainNC
id lsclDiracSpinor(?a)*lsclDiracChainNC(lsclDiracGammaOpen(100,?b))*lsclDiracSpinor(?c) = 
	lsclDiracSpinor(?a)*lsclDiracGamma(?b)*lsclDiracSpinor(?c);

repeat;
* lsclDiracChainNC(lsclDiracGammaOpen(...)) is a noncom chain of Dirac  matrices attached to some spinors!
* lsclDiracGammaOpen is noncommutative tensor!
id lsclDiracTrace(lsclDiracGammaOpen(100,?a)) = lsclDiracTrace(?a);
id lsclDiracChainOpen(lsclDiracGammaOpen(100,?a),lsclDi1?,lsclDi2?) = lsclDiracChainOpen(lsclDiracGamma(?a),lsclDi1,lsclDi2);
renumber;
endrepeat;

* At this point all occurences of lsclDiracGammaOpen and lsclDiracChainNC should be eliminated. We can only have
* - lsclDiracSpinor(...)*lsclDiracGamma(...)*lsclDiracSpinor(...) 
* - lsclDiracChainOpen(lsclDiracGamma(...),lsclDi1,lsclDi2)
* - lsclDiracTrace(lsclDiracGamma(...));

if (occurs(lsclDiracGammaOpen,lsclDiracChainNC));
exit "Something went wrong when eliminating lsclDiracChainNC and lsclDiracGammaOpen";
endif;

#message lsclProcessStage0: ... done: `time_'

#message lsclProcessStage0: Calling sort : `time_' ...
.sort
#message lsclProcessStage0: ... done: `time_'




#message lsclProcessStage0: Calling the CodeBlock1 fold : `time_' ...
#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclCodeBlock1
#message lsclProcessStage0: ... done: `time_'

#message lsclProcessStage0: Calling sort : `time_' ...
.sort
#message lsclProcessStage0: ... done: `time_'

#if (`LSCLINSERTPROJECTOR' == 0)


#message lsclProcessStage0: Calling the DoTensorReduction fold : `time_' ...
#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclDoTensorReduction
#message lsclProcessStage0: ... done: `time_'

#message lsclProcessStage0: Calling sort : `time_' ...
.sort
#message lsclProcessStage0: ... done: `time_'

#endif

delete storage;
.sort
.store

save Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Stage0/stage0_dia`lsclDiaNumber'L`lsclNLoops'.res;

#message lsclProcessStage0: Done processing diagram `lsclDiaNumber' at `lsclNLoops' loop(s)
#message lsclProcessStage0: Stage 0 completed successfully.

.end

