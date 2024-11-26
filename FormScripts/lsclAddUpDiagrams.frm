off statistics;
on HighFirst;


#message lsclAddUpDiagrams: Project: `lsclProjectName'
#message lsclAddUpDiagrams: Process: `lsclProcessName'
#message lsclAddUpDiagrams: Loops: `lsclNLoops'
#message lsclAddUpDiagrams: From dia: `lsclDiaNumberFrom'
#message lsclAddUpDiagrams: To dia: `lsclDiaNumberTo'


#if (`lsclNLoops' == 0)
	#message lsclAddUpDiagrams: Working with tree-level diagrams
	#do i = `lsclDiaNumberFrom', `lsclDiaNumberTo'
	Load Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Stage0/stage0_dia`i'L`lsclNLoops'.res;
	#enddo
#else

	#do i = `lsclDiaNumberFrom', `lsclDiaNumberTo'
	Load Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Stage2/stage2_dia`i'L`lsclNLoops'.res;
	#enddo
#endif

#message lsclAddUpDiagrams: All loaded `time_'


#if (`lsclNLoops' == 0)
#do i = `lsclDiaNumberFrom', `lsclDiaNumberTo'
G ts2dia`i'L`lsclNLoops' = s0dia`i'L`lsclNLoops';
#enddo
#else
* TODO FIX ME!!!
#do i = `lsclDiaNumberFrom', `lsclDiaNumberTo'
G ts2dia`i'L`lsclNLoops' = s2dia`i'L`lsclNLoops';
#enddo
#endif

#message lsclAddUpDiagrams: All defined `time_'

#message lsclAddUpDiagrams: Executing .sort and .store
.sort
.store

#message lsclAddUpDiagrams: .sort and .store done

#include lsclDeclarations.h
#include lsclDefinitions.h
#include Projects/`lsclProjectName'/FeynmanRules/lsclParticles_`lsclModelName'.h
#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclGeneric

#if (`lsclNLoops' > 0)
#include Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/TopologyList.frm
#endif

#message `LSCLADDDIAFLAG'


#if (`LSCLADDDIAFLAG'==1)
G ampL`lsclNLoops' = 
#do i = `lsclDiaNumberFrom', `lsclDiaNumberTo'
+ lsclDiaFlag(`i')*ts2dia`i'L`lsclNLoops'
#enddo
;
#else
G ampL`lsclNLoops' = 
#do i = `lsclDiaNumberFrom', `lsclDiaNumberTo'
+ ts2dia`i'L`lsclNLoops'
#enddo
;
#endif

.sort
#if (`lsclNLoops' > 0)
CF
#do i=1, `LSCLNTOPOLOGIES'
`LSCLTOPOLOGY`i'',
#enddo 
;
#endif

if (occurs(lsclEpHelpFlag));
print "lsclAddUpDiagramsCode: Error, missing some contributions to the ep-expansion, e.g.: %t";
endif;

#message lsclAddUpDiagrams: Calling sort : `time_' ...
.sort
off statistics;
#message lsclAddUpDiagrams: ... done: `time_'

if (occurs(lsclEpHelpFlag)) exit;
#message lsclAddUpDiagrams: Missing ep-orders check passed: `time_' ...

#message lsclAddUpDiagrams: Calling the lsclAddUpDiagramsCode fold : `time_' ...
#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclAddUpDiagramsCode
#message lsclAddUpDiagrams: ... done: `time_'


#if (`LSCLADDDIAFLAG'==1)
  #message lsclAddUpDiagrams: Saving FeynCalc-readable result to Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Results/ampL`lsclNLoops'From`lsclDiaNumberFrom'To`lsclDiaNumberTo'-diaFlag.m
  #call lsclToFeynCalc(ampL`lsclNLoops',Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Results/ampL`lsclNLoops'From`lsclDiaNumberFrom'To`lsclDiaNumberTo'-diaFlag.m)
#else
  #message lsclAddUpDiagrams: Saving FeynCalc-readable result to Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Results/ampL`lsclNLoops'From`lsclDiaNumberFrom'To`lsclDiaNumberTo'.m
  #call lsclToFeynCalc(ampL`lsclNLoops',Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Results/ampL`lsclNLoops'From`lsclDiaNumberFrom'To`lsclDiaNumberTo'.m)
#endif

.sort
delete storage;
.sort

.store

#message lsclAddUpDiagrams: Saving FORM-readable result to Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Results/ampL`lsclNLoops'From`lsclDiaNumberFrom'To`lsclDiaNumberTo'.res
save Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Results/ampL`lsclNLoops'From`lsclDiaNumberFrom'To`lsclDiaNumberTo'.res;

.end

