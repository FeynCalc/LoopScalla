off statistics;
on HighFirst;
on fewerstatistics 0;

#message lsclAddUpDiagrams: `lsclProjectName'
#message lsclAddUpDiagrams: `lsclProcessName'
#message lsclAddUpDiagrams: `lsclNLoops'
#message lsclAddUpDiagrams: `lsclDiaNumber'
#message lsclAddUpDiagrams: `lsclIntNumberFrom'
#message lsclAddUpDiagrams: `lsclIntNumberTo'


#do i = `lsclIntNumberFrom', `lsclIntNumberTo'
Load Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/SplitStage2/`lsclDiaNumber'/stage2_dia`lsclDiaNumber'L`lsclNLoops'_p`i'.res;
#enddo




#message lsclAddUpDiagrams: All loaded `time_'

*#do i = `lsclIntNumberFrom', `lsclIntNumberTo'
*G s2dia`i'L`lsclNLoops' = s2dia`lsclDiaNumber'L`lsclNLoops'I`lsclIntegralNumber';
*#enddo

*#message lsclAddUpDiagrams: All defined `time_'

#message lsclAddUpDiagrams: Executing .sort and .store
.sort
.store

#message lsclAddUpDiagrams: .sort and .store done

#include lsclDeclarations.h
#include lsclDefinitions.h
#include Projects/`lsclProjectName'/FeynmanRules/lsclParticles_`lsclModelName'.h
#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclGeneric


#include Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/TopologyList.frm




#if (`LSCLADDDIAFLAG'==1)
G s2dia`lsclDiaNumber'L`lsclNLoops' = 
#do i = `lsclIntNumberFrom', `lsclIntNumberTo'
+ lsclDiaFlag`i'*s2dia`lsclDiaNumber'L`lsclNLoops'I`i'
#enddo
;
#else
G s2dia`lsclDiaNumber'L`lsclNLoops' = 
#do i = `lsclIntNumberFrom', `lsclIntNumberTo'
+ s2dia`lsclDiaNumber'L`lsclNLoops'I`i'
#enddo
;
#endif



.sort
#message delete storage
delete storage;
.sort

.store



save Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Stage2/stage2_dia`lsclDiaNumber'L`lsclNLoops'.res s2dia`lsclDiaNumber'L`lsclNLoops';

.end

