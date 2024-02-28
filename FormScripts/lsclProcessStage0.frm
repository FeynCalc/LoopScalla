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
  #include Projects/`lsclProjectName'/Diagrams/Input/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/dia`lsclDiaNumber'L`lsclNLoops'.frm # dia`lsclDiaNumber'L`lsclNLoops'



#if (`LSCLINSERTPROJECTOR' == 1)
#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclInsertProjector
#endif


#message lsclProcessStage0: Linearizing Dirac chains: `time_' ...
#call lsclDiracChainLinearize()
#call lsclDiracTraceLinearize()
#message lsclProcessStage0: ... done: `time_'


#message lsclProcessStage0: Calling the CodeBlock0 fold : `time_' ...
#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclCodeBlock0
#message lsclProcessStage0: ... done.

#message lsclProcessStage0: Linearizing Dirac chains: `time_' ...
#call lsclDiracChainLinearize()
#call lsclDiracTraceLinearize()
#message lsclProcessStage0: ... done: `time_'



#message lsclProcessStage0: Joining Dirac chains: `time_' ...
#call lsclDiracChainJoin()
#message lsclProcessStage0: ... done: `time_'

#message lsclProcessStage0: Joining Color chains: `time_' ...
#call lsclColorChainJoin()
#message lsclProcessStage0: ... done: `time_'

#message lsclProcessStage0: Linearizing Dirac chains: `time_' ...
#call lsclDiracChainLinearize()
#call lsclDiracTraceLinearize()
#message lsclProcessStage0: ... done: `time_'


#message lsclProcessStage0: Rewriting Dirac spinors : `time_' ...
argument;
#call lsclToDiracGamma
* g_ -> lsclDiracGammaOpen, at this point there are no g_'s left!
endargument;
* lsclDiracChain is a container for Dirac matrices with explicit Dirac indices
* NC stands for noncommutative
id lsclDiracChain(?a) = lsclDiracChainNC(?a);
id lsclDiracChainNC(?a,lsclDiracU(?s)) = lsclDiracChainNC(?a,1)*lsclDiracSpinor(?s,1);
id lsclDiracChainNC(?a,lsclDiracV(?s)) = lsclDiracChainNC(?a,1)*lsclDiracSpinor(?s,-1);
id lsclDiracChainNC(?a,lsclDiracUBar(?s),?b) = lsclDiracSpinor(?s,1)*lsclDiracChainNC(?a,1,?b);
id lsclDiracChainNC(?a,lsclDiracVBar(?s),?b) = lsclDiracSpinor(?s,-1)*lsclDiracChainNC(?a,1,?b);
id lsclDiracChainNC(?a,1,1) = lsclDiracChainNC(?a);
if (occurs(lsclDiracU,lsclDiracV,lsclDiracUBar,lsclDiracVBar)) exit "Something went wrong while rewriting spinors";

* we build up structures of the form 
* lsclDiracSpinor(...)*lsclDiracChainNC(...)*lsclDiracSpinor(...) or lsclDiracChainNC(...i,j)


id lsclDiracChainNC(?a,lsclDi1?,lsclDi2?) = lsclDiracChainOpen(?a,lsclDi1,lsclDi2);
#message lsclProcessStage0: ... done: `time_'
#message lsclProcessStage0: Linearizing Dirac chains and traces : `time_' ...
* Now we start applying linearity to lsclDiracChainNC, lsclDiracTrace and lsclDiracChainOpen
SplitArg,lsclDiracChainNC,lsclDiracChainOpen,lsclDiracTrace;




repeat;
id, once lsclF?{lsclDiracChainNC,lsclDiracTrace}(lsclS1?,lsclS2?,?a) = lsclF(lsclS1) + lsclF(lsclS2,?a);
id, once lsclDiracChainOpen(lsclS1?,lsclS2?,?a,lsclDi1?,lsclDi2?) = lsclDiracChainOpen(lsclS1,lsclDi1,lsclDi2) + lsclDiracChainOpen(lsclS2,?a,lsclDi1,lsclDi2);
id lsclDiracChainNC() = 1;
endrepeat;



FactArg,lsclDiracChainNC,lsclDiracChainOpen,lsclDiracTrace;



multiply replace_(lsclDiracTrace,lsclAuxHoldFunction);
repeat;
id lsclAuxHoldFunction(?a,lsclDiracGammaOpen(?c),?b) = lsclDiracTrace(lsclDiracGammaOpen(?c))*lsclAuxHoldFunction(?a,?b);
endrepeat;
repeat;
id lsclAuxHoldFunction(lsclS1?,?a) = lsclS1*lsclAuxHoldFunction(?a);
id lsclAuxHoldFunction()=1;
endrepeat;


multiply replace_(lsclDiracChainOpen,lsclAuxHoldFunction);
repeat;
id lsclAuxHoldFunction(?a,lsclDiracGammaOpen(?c),?b) = lsclDiracChainOpen(lsclDiracGammaOpen(?c))*lsclAuxHoldFunction(?a,?b);
endrepeat;
repeat;
id lsclAuxHoldFunction(lsclS1?,?a) = lsclS1*lsclAuxHoldFunction(?a);
id lsclAuxHoldFunction()=1;
endrepeat;


id lsclDiracSpinor(?a)*lsclDiracChainNC(lsclDiracGammaOpen(100,?b))*lsclDiracSpinor(?c) = 
	lsclDiracSpinor(?a)*lsclDiracGamma(?b)*lsclDiracSpinor(?c);



#message lsclProcessStage0: Rebuilding Dirac traces and open Dirac chains : `time_' ...
repeat;
* lsclDiracChainNC(lsclDiracGammaOpen(...)) is a noncom chain of Dirac  matrices attached to some spinors!
* lsclDiracGammaOpen is noncommutative tensor!
id lsclDiracTrace(lsclDiracGammaOpen(100,?a)) = lsclDiracTrace(?a);
id lsclDiracChainOpen(lsclDiracGammaOpen(100,?a),lsclDi1?,lsclDi2?) = lsclDiracChainOpen(lsclDiracGamma(?a),lsclDi1,lsclDi2);
renumber;
endrepeat;
#message lsclProcessStage0: ... done: `time_'

* at this point all occurences of lsclDiracGammaOpen should be eliminated. We can only have
* lsclDiracSpinor(...)*lsclDiracGamma(...)*lsclDiracSpinor(...) 
* or
* lsclDiracChainOpen(lsclDiracGamma(...),lsclDi1,lsclDi2)
* or
* lsclDiracTrace(lsclDiracGamma(...));

*#call lsclToFeynCalc(dia,out`lsclDiaNumber'.m)

#message lsclProcessStage0: Calling sort : `time_' ...
.sort
#message lsclProcessStage0: ... done: `time_'

#message lsclProcessStage0: Calling the CodeBlock1 fold : `time_' ...
#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclCodeBlock1
#message lsclProcessStage0: ... done: `time_'

#message lsclProcessStage0: Calling sort : `time_' ...
.sort
#message lsclProcessStage0: ... done: `time_'



#message delete storage
delete storage;

.sort

.store


save Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Stage0/stage0_dia`lsclDiaNumber'L`lsclNLoops'.res;

#message lsclProcessStage0: Done processing diagram `lsclDiaNumber' at `lsclNLoops' loop(s)
#message lsclProcessStage0: Stage 0 completed successfully.

.end

