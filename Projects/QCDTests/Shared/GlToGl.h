
*--#[ lsclGeneric:

* Definitions of normal and preprocessor variables specific
* to this process

S gs;
* V myVector1, myVector2;

#define lsclNumberOfInitialStates "1"
#define lsclNumberOfFinalStates "1"

#ifndef `LSCLINSERTPROJECTOR'
#define LSCLINSERTPROJECTOR "1"
#endif

#ifndef `LSCLTRUNCATESPINORS'
#define LSCLTRUNCATESPINORS "1"
#endif

#ifndef `LSCLTRUNCATEPOLVECTORS'
#define LSCLTRUNCATEPOLVECTORS "1"
#endif

*--#] lsclGeneric:


*--#[ lsclInsertProjector:

* When using projectors instead of tensor reduction, they should be
* introduced here. The insertion of projectors usually occurs at a
* very early stage of the evaluation, just after loading the amplitude

* projector=MTD[Lor1,Lor2] 1/((D-1)SPD[p])1/(2CA CF) SUNDelta[Glu1,Glu2]

multiply lsclSUNDelta(lsclCAj1, lsclCAj2)*d_(lsclNu1,lsclNu2)*1/(lsclD-1)*1/p1.p1*1/(lsclSUNN^2-1);


*--#] lsclInsertProjector:

*--#[ lsclCodeBlock0:


argument;
id lsclNCHold(lsclS?) = lsclS;
id lsclHold(lsclS?) = lsclS;
endargument;

id lsclHold(lsclS?) = lsclS;

if (occurs(lsclHold,lsclNCHold)) exit "lsclCodeBlock0: Something went wrong removing holds.";

id q1 = p1;
argument;
id q1 = p1;
endargument;

*--#] lsclCodeBlock0:


*--#[ lsclCodeBlock1:

#message `lsclProcessName':: lsclCodeBlock1: Calling DiracSimplify : `time_' ...

#define DIRACSIMPLIFY
#call lsclDiracSimplify

#message `lsclProcessName':: lsclCodeBlock1: ... done : `time_'

#message `lsclProcessName': lsclCodeBlock1: Calling sort : `time_' ...
.sort
#message `lsclProcessName': lsclCodeBlock1: ... done : `time_'


#message `lsclProcessName': lsclCodeBlock1: Calling lsclColorIsolate : `time_' ...
#call lsclColorIsolate(lsclNonColorPiece1,lsclNonColorPiece2)
#message `lsclProcessName': lsclCodeBlock1: ... done : `time_' ...

#message `lsclProcessName': lsclCodeBlock1: Calling SUNSimplifyFierz : `time_' ...
#call lsclSUNSimplifyFierz

#message `lsclProcessName': lsclCodeBlock1: Calling lsclColorUnisolate : `time_' ...
#call lsclColorUnisolate(lsclNonColorPiece1,lsclNonColorPiece2)
#message `lsclProcessName': lsclCodeBlock1: ... done : `time_'

#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclKinematics

argument lsclFAD;
#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclKinematics
endargument;

.sort

print;

*--#] lsclCodeBlock1:


*--#[ lsclDiracTraceSimplify:

* This code is called upon right before evaluating Dirac traces.
* Here one e.g. set some noncontributing traces to zero to facilitate
* the job of of FORM's trace/tracen functions.

* repeat id lsclDiracTrace(?a,n,n,?a) = 0;

*--#] lsclDiracTraceSimplify:

*--#[ lsclKinematics:

* Here we define the kinematics of the amplitude and introduce
* the 4-momentum conservation. This might be called multiple times
* during different execution stages.

*repeat;
* id q1 = p1+p2-q2-q3;
* id p1 = lsclMass(Qb)*(n+nb)/2;
* id n.n^lsclS?pos_ = 0;
* endrepeat;

repeat;
id  lsclMass(Qi) = 0;
id  lsclMass(Qj) = 0;
id p1.p1^lsclS?!{,0} = pp^lsclS;
endrepeat;

*--#] lsclKinematics:

*--#[ lsclPowerCounting:

* This is a special block that is relevant only for calculations
* where the amplitude gets expanded prior to topology identification

*--#] lsclPowerCounting:


*--#[ lsclSimplifyPropagators:

* Here one can simplify the propagators (i.e. pull out a global factor
* out of eikonals) before extracting the topologies present in the amplitudes

*--#] lsclSimplifyPropagators:

*--#[ lsclAdditionalBracketArguments:
* Here one can specify some variables that should be bracketed when inserting
* the reduction tables and simplifying the result using polyratfun
* gs,i_,lsclSUNN,lsclFlag1,lsclFlag2
*--#] lsclAdditionalBracketArguments:

*--#[ lsclSimplifyAmplitudeBeforeReduction:
* This defines simplifications to be applied to the amplitude before inserting
* the reduction tables
* repeat id lsclDen(lsclS?{la,lsclSUNN}) = 1/lsclS;

*--#] lsclSimplifyAmplitudeBeforeReduction:

*--#[ lsclAddUpDiagramsCode:

PolyRatFun lsclRat;
repeat id lsclNum(lsclS?) = lsclRat(lsclS,1);
repeat id lsclDen(lsclS?) = lsclRat(1,lsclS);
.sort
PolyRatFun;


repeat id lsclRat(lsclS1?,lsclS2?) = lsclNum(lsclS1)*lsclDen(lsclS2);



factarg lsclNum,lsclDen;
chainout lsclNum;
chainout lsclDen;

repeat id lsclNum(lsclS?) = lsclS;
repeat id lsclDen(lsclS?) = 1/lsclS;

print[];


.sort

*--#] lsclAddUpDiagramsCode:
