on shortstats;
on HighFirst;

#define lsclProjectName "BToEtaC"
#define lsclProcessName "QbQubarToWQQubar"
#define lsclModelName "BToEtaC"
#define lsclNLoops "3"
#define lsclPath "Stage1/stage1_dia19852L3.res"
#define lsclExp "s1dia19852L3"

#define lsclPref "newCalc-"


#include lsclDeclarations.h
#include lsclDefinitions.h
#include Projects/`lsclProjectName'/FeynmanRules/lsclParticles_`lsclModelName'.h

#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclGeneric
#system mkdir -p Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/IntermediateResults/
.global


#message lsclExtractIntermediateResult: Project: `lsclProjectName'
#message lsclExtractIntermediateResult: Process: `lsclProcessName'
#message lsclExtractIntermediateResult: Model: `lsclModelName'
#message lsclExtractIntermediateResult: Processing diagram `lsclPath'



#message lsclExtractIntermediateResult: Processing diagram `lsclExp'

Load Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/`lsclPath';
G currentExpr = `lsclExp';

.sort

#message Saving the expression `lsclExp' to Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/IntermediateResults/`lsclExp'.m

#call lsclToFeynCalc(currentExpr,Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/IntermediateResults/`lsclPref'`lsclExp'.m)
.sort


.end

