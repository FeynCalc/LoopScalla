on HighFirst;
off statistics;
#include lsclDeclarations.h
#include lsclDefinitions.h
#include Projects/`lsclProjectName'/FeynmanRules/lsclParticles_`lsclModelName'.h

#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclGeneric


#message lsclEnumerateLoopContent: Project name: `lsclProjectName'
#message lsclEnumerateLoopContent: Process name: `lsclProcessName'
#message lsclEnumerateLoopContent: Model name: `lsclModelName'
#message lsclEnumerateLoopContent: Number of loops: `lsclNLoops'
#message lsclEnumerateLoopContent: Diagram number: `lsclDiaNumber'
#message

#include Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/TopologyList.frm

CF
#do i=1, `LSCLNTOPOLOGIES'
`LSCLTOPOLOGY`i'',
#enddo 
;


Load Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Stage1/stage1_dia`lsclDiaNumber'L`lsclNLoops'.res;

G s2dia`lsclDiaNumber'L`lsclNLoops' = s1dia`lsclDiaNumber'L`lsclNLoops';

.sort


#message lsclEnumerateLoopContent: Isolating prefactors of loop integrals:

b,
#do i=1, `LSCLNTOPOLOGIES'
`LSCLTOPOLOGY`i'',
#enddo
;
.sort

Collect lsclWrapFun1000, lsclWrapFun1001;
argtoextrasymbol lsclWrapFun1000, lsclWrapFun1001;

.sort

#message lsclEnumerateLoopContent: ... done : `time_'




#message lsclEnumerateLoopContent: Enumerating the occurring loop integrals: `time_' ...
#$intCounter=0;
#do i=1, `LSCLNTOPOLOGIES'
#$topoPresent`i'=0;
#$topoIntegralCounter`i'=0;
if(occurs(`LSCLTOPOLOGY`i''));
$topoPresent`i'=1;
$topoIntegralCounter`i'=$topoIntegralCounter`i'+1;
multiply lsclIntegralNumber(`i',$topoIntegralCounter`i');
endif;
#enddo 
moduleoption notinparallel;
.sort

#message lsclEnumerateLoopContent: ... done : `time_'
#message

#do i=1, `LSCLNTOPOLOGIES'
#do j=1,$topoPresent`i'
#message lsclEnumerateLoopContent: Number of loop integrals for `LSCLTOPOLOGY`i'': `$topoIntegralCounter`i''
#enddo 
#enddo 


.sort


#do i=1, `LSCLNTOPOLOGIES'
#do j=1,$topoPresent`i'
id `LSCLTOPOLOGY`i''(?a) = lsclIntegral(`LSCLTOPOLOGY`i''(?a));
#enddo
#enddo

.sort

#message
#message lsclEnumerateLoopContent: Saving results: `time_' ...

#write <Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/LoopIntegrals/LoopContentPerDiagram/dia`lsclDiaNumber'L`lsclNLoops'.m> "{`lsclDiaNumber',{"


#do i=1, `LSCLNTOPOLOGIES'
#do j=1,$topoPresent`i'


format Mathematica;
#write <Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/LoopIntegrals/LoopContentPerDiagram/dia`lsclDiaNumber'L`lsclNLoops'.m> "{`LSCLTOPOLOGY`i'', `$topoIntegralCounter`i''},"



.sort

#enddo 
#enddo
#write <Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/LoopIntegrals/LoopContentPerDiagram/dia`lsclDiaNumber'L`lsclNLoops'.m> "Nothing}}"

#message lsclEnumerateLoopContent: ... done : `time_'

#message lsclEnumerateLoopContent: Loop content enumeration completed successfully.


.end

