off statistics;
on HighFirst;


#message lsclAddUpDiagrams: `lsclProjectName'
#message lsclAddUpDiagrams: `lsclProcessName'
#message lsclAddUpDiagrams: `lsclNLoops'
#message lsclAddUpDiagrams: `lsclDiaNumberFrom'
#message lsclAddUpDiagrams: `lsclDiaNumberTo'


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

* TODO FIX ME!!!
#do i = `lsclDiaNumberFrom', `lsclDiaNumberTo'
G ts2dia`i'L`lsclNLoops' = s2dia`i'L`lsclNLoops';
#enddo

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



#if (`LSCLADDDIAFLAG'==1)
G ampL`lsclNLoops' = 
#do i = `lsclDiaNumberFrom', `lsclDiaNumberTo'
+ lsclDiaFlag`i'*s2dia`i'L`lsclNLoops'
#enddo
;
#else
G ampL`lsclNLoops' = 
#do i = `lsclDiaNumberFrom', `lsclDiaNumberTo'
+ s2dia`i'L`lsclNLoops'
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

.sort
on statistics;

* Before inserting the reduction tables it is a good idea to simplify the coefficients
* multiplying loop integrals
collect lsclWrapFun1,lsclWrapFun2;
#call lsclApplyPolyRatFun(lsclNum,lsclDen,lsclRat,lsclWrapFun1,lsclWrapFun2);
.sort: After lsclApplyPolyRatFun;
#call lsclNumDenFactorize(lsclNum,lsclDen,lsclRat,`lsclDenNumFactorizeArguments');
.sort: After lsclNumDenFactorize;


#if (`LSCLADDDIAFLAG'==1)
	#call lsclToFeynCalc(ampL`lsclNLoops',Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Results/ampL`lsclNLoops'From`lsclDiaNumberFrom'To`lsclDiaNumberTo'-diaFlag.m)
#else
	#call lsclToFeynCalc(ampL`lsclNLoops',Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Results/ampL`lsclNLoops'From`lsclDiaNumberFrom'To`lsclDiaNumberTo'.m)
#endif

.sort
#message delete storage
delete storage;
.sort

.store

save Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Results/ampL`lsclNLoops'From`lsclDiaNumberFrom'To`lsclDiaNumberTo'.res;

.end

