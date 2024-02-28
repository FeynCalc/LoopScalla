off statistics;
on HighFirst;

* #define lsclDiaFrom "1"
* #define lsclDiaTo "4"
*#define lsclNLoops "2"
*#define lsclProjectName "SCETSoftFun"
*#define lsclModelName "QCDTwoFlavors"
*#define lsclProcessName "QQbarGl"

#include lsclDeclarations.h
#include lsclDefinitions.h
#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclGeneric
#include Projects/`lsclProjectName'/FeynmanRules/lsclParticles_`lsclModelName'.h
* #system pwd
* #system mkdir -p Projects/`lsclProjectName'/Diagrams/Input/`lsclProcessName'/`lsclModelName'/`lsclNLoops'


#message lsclProcessStage0: Project: `lsclProjectName'
#message lsclProcessStage0: Process: `lsclProcessName'
#message lsclProcessStage0: Model: `lsclModelName'
#message lsclProcessStage0: Processing diagram `lsclDiaNumber' at `lsclNLoops' loop(s)

* #do i=`lsclDiaFrom', `lsclDiaTo'
* #message lsclInsertFeynmanRules: Processing diagram `i'
L origDiag = 
#include Projects/`lsclProjectName'/QGRAF/Output/`lsclProcessName'.`lsclModelName'.`lsclNLoops'.amps # d`lsclDiaNumber'
;
.sort

#include Projects/`lsclProjectName'/FeynmanRules/lsclFeynmanRules_`lsclModelName'.h

if (occurs(lsclQGVertex));
print "Missing a Feynman rule for the following vertex: %t";
endif;

if (occurs(lsclQGPropagator));
print "Missing a Feynman rule for the following propagator: %t";
endif;

if (occurs(lsclQGPolarization));
print "Missing a Feynman rule for the following polarization: %t";
endif;

if (occurs(lsclLorentzIndex));
print "Leftover Lorentz index placeholder: %t";
endif;

if (occurs(lsclVector));
print "Leftover 4-vector placeholder: %t";
endif;

if (occurs(lsclPolVector));
print "Leftover polarization vector placeholder: %t";
endif;

if (occurs(lsclQGVertex,lsclQGPropagator,lsclQGPolarization,lsclLorentzIndex,lsclPolVector,lsclVector)) exit "Missing some Feynman rules!";

#if (`LSCLVERBOSITY'>0)
#message Diagram `i':
print;
#endif

.sort
#write <Projects/`lsclProjectName'/Diagrams/Input/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/dia`lsclDiaNumber'L`lsclNLoops'.frm> "*--#[ dia`lsclDiaNumber'L`lsclNLoops' :"
#write <Projects/`lsclProjectName'/Diagrams/Input/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/dia`lsclDiaNumber'L`lsclNLoops'.frm> "%+e", origDiag
#write <Projects/`lsclProjectName'/Diagrams/Input/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/dia`lsclDiaNumber'L`lsclNLoops'.frm> "*--#] dia`lsclDiaNumber'L`lsclNLoops' :"


* drop origDiag;

* #enddo 

#message lsclInsertFeynmanRules: Done processing diagram `lsclDiaNumber' at `lsclNLoops' loop(s)
#message lsclInsertFeynmanRules: Insertion of Feynman rules completed successfully.


.end
