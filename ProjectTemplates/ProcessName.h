
*--#[ lsclGeneric:

* Definitions of normal and preprocessor variables specific
* to this process

* S mySymbol1, mySymbols2;
* V myVector1, myVector2;

* #define lsclNumberOfInitialStates "2"
* #define lsclNumberOfFinalStates "2"

*#ifndef `LSCLINSERTPROJECTOR'
*#define LSCLINSERTPROJECTOR "1"
*#endif

*#ifndef `LSCLTRUNCATESPINORS'
*#define LSCLTRUNCATESPINORS "1"
*#endif

*#ifndef `LSCLTRUNCATEPOLVECTORS'
*#define LSCLTRUNCATEPOLVECTORS "1"
*#endif

*--#] lsclGeneric:


*--#[ lsclInsertProjector:

* When using projectors instead of tensor reduction, they should be
* introduced here. The insertion of projectors usually occurs at a
* very early stage of the evaluation, just after loading the amplitude

*--#] lsclInsertProjector:

*--#[ lsclCodeBlock0:

* Here comes the code that gets executed right after inserting the 
* projectors. Some typical instructions would be to set the gauge
* parameter to some specific value or to multiply the amplitude with
* some prefactors

*--#] lsclCodeBlock0:


*--#[ lsclCodeBlock1:

* This code is called upon finishing Dirac algebra simplifications

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
