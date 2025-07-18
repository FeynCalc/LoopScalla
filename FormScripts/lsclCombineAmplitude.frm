* This file is a part of LoopScalla, a framework for loop calculations
* LoopScalla is covered by the GNU General Public License 3.
* Copyright (C) 2019-2025 Vladyslav Shtabovenko

off statistics;
on HighFirst;
on fewerstatistics 0;

#message lsclCombineAmplitude: Project: `lsclProjectName'
#message lsclCombineAmplitude: Process: `lsclProcessName'
#message lsclCombineAmplitude: Model: `lsclModelName'
#message lsclCombineAmplitude: Adding up diagram parts of the diagram `lsclDiaNumber' from `lsclIntNumberFrom' to `lsclIntNumberTo' at `lsclNLoops' loop(s)

#do i = `lsclIntNumberFrom', `lsclIntNumberTo'
Load Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/SplitStage2/`lsclDiaNumber'/stage2_dia`lsclDiaNumber'L`lsclNLoops'_p`i'.res;
#enddo




#message lsclCombineAmplitude: All loaded `time_'

*#do i = `lsclIntNumberFrom', `lsclIntNumberTo'
*G s2dia`i'L`lsclNLoops' = s2dia`lsclDiaNumber'L`lsclNLoops'I`lsclIntegralNumber';
*#enddo

*#message lsclCombineAmplitude: All defined `time_'

#message lsclCombineAmplitude: Executing .sort and .store
.sort
.store

#message lsclCombineAmplitude: .sort and .store done

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

