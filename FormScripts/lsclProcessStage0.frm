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



#if (`lsclPprInsertProjector' == 1)
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

#message lsclProcessStage0: Calling sort : `time_' ...
.sort
#message lsclProcessStage0: ... done: `time_'

* If we try to join the chains before linearizing them, we'll run into the
* MaxTermSize issue.
#message lsclProcessStage0: Joining Dirac chains: `time_' ...
#call lsclDiracChainJoin()
#message lsclProcessStage0: ... done: `time_'

#message lsclProcessStage0: Calling sort : `time_' ...
.sort
#message lsclProcessStage0: ... done: `time_'

#message lsclProcessStage0: Joining Color chains: `time_' ...
#call lsclColorChainJoin()
#message lsclProcessStage0: ... done: `time_'

#message lsclProcessStage0: Calling sort : `time_' ...
.sort
#message lsclProcessStage0: ... done: `time_'

#message lsclProcessStage0: Linearizing Dirac chains: `time_' ...
#call lsclDiracChainLinearize()
#call lsclDiracTraceLinearize()
#message lsclProcessStage0: ... done: `time_'

argument;
#call lsclToDiracGamma
endargument;

#message lsclProcessStage0: Factorizing Dirac traces: `time_' ...
#call lsclDiracTraceFactorize(lsclWrapFun100)
#message lsclProcessStage0: ... done: `time_'

#message lsclProcessStage0: Processing Dirac chains: `time_' ...
#call lsclDiracChainProcess(lsclWrapFun100,lsclWrapNFun100,lsclDiracChainNC)
#message lsclProcessStage0: ... done: `time_'

#message lsclProcessStage0: Calling sort : `time_' ...
.sort
#message lsclProcessStage0: ... done: `time_'

#if (`ZERO_s0dia`lsclDiaNumber'L`lsclNLoops'' != 1)

#message lsclProcessStage0: Calling the CodeBlock1 fold : `time_' ...
#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclCodeBlock1
#message lsclProcessStage0: ... done: `time_'

#message lsclProcessStage0: Calling sort : `time_' ...
.sort
#message lsclProcessStage0: ... done: `time_'

#else
#message lsclProcessStage0: Skipping the CodeBlock1 fold as s0dia`lsclDiaNumber'L`lsclNLoops' is zero.
#endif

* We skip tensor reduction if the expression is already zero after CodeBlock1 or it is a tree-level calculation
#if (`lsclNLoops' != 0)
  #if (`lsclPprInsertProjector' == 0)
    #if (`ZERO_s0dia`lsclDiaNumber'L`lsclNLoops'' != 1)

      #message lsclProcessStage0: Calling the DoTensorReduction fold : `time_' ...
      #include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclDoTensorReduction
      #message lsclProcessStage0: ... done: `time_'

      #message lsclProcessStage0: Calling sort : `time_' ...
      .sort
      #message lsclProcessStage0: ... done: `time_'

    #else
      #message lsclProcessStage0: Skipping the DoTensorReduction fold as s0dia`lsclDiaNumber'L`lsclNLoops' is zero.
    #endif
  #endif
#else
  .sort  
  #message lsclProcessStage0: Tree-level: Skipping the DoTensorReduction fold.
#endif

#message lsclProcessStage0: Calling the AfterCompletingStage0 fold : `time_' ...
#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclAfterCompletingStage0
#message lsclProcessStage0: ... done: `time_'

delete storage;
.sort
.store

save Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Stage0/stage0_dia`lsclDiaNumber'L`lsclNLoops'.res;

#message lsclProcessStage0: Done processing diagram `lsclDiaNumber' at `lsclNLoops' loop(s)
#message lsclProcessStage0: Stage 0 completed successfully.

.end
