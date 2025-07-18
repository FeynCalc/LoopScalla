
*--#[ lsclGeneric:

* Definitions of normal and preprocessor variables specific to this process

S gs,pp;
* V myVector1, myVector2;

CF lsclQuarkFlavorInvolved;

* Set of kinematic invariants
Set lsclKinematicInvariants: pp;

* A set of all loop momenta
set lsclLoopMomenta: 
#do i=1, `lsclNLoops'
k`i',
#enddo
;

* Number of the initial and final states in the given process
#define lsclNumberOfInitialStates "1"
#define lsclNumberOfFinalStates "1"

* Set to "1" if we are using projectors, while "0" means tensor reduction
#ifndef `LSCLINSERTPROJECTOR'
#define LSCLINSERTPROJECTOR "0"
#endif

* Set to "1" if the Dirac spinors need to be removed.
#ifndef `LSCLTRUNCATESPINORS'
#define LSCLTRUNCATESPINORS "1"
#endif

* Set to "1" if the polarization vectors need to be removed.
#ifndef `LSCLTRUNCATEPOLVECTORS'
#define LSCLTRUNCATEPOLVECTORS "1"
#endif

* Define a list of arguments that can be passed to lsclNumDenFactorize to be pulled out of lsclNum and lsclDen
#define lsclDenNumFactorizeArguments "{gs\,}"

* Define variables contained in lsclNum and lsclDen that will trigger a factorization of those terms.
* This definition is important and helps to avoid workspace overflows when using factorization.
#define lsclFactorizationVariables "pp,lsclD,lsclSUNN,lsclNA,lsclCF,lsclCA,lsclCRmCA2"


*--#] lsclGeneric:


*--#[ lsclBeforeInsertingFeynmanRules:

id lsclQGPropagator(lsclF?lsclQuarkFields(?a),?b) = lsclQuarkFlavorInvolved(lsclF)*lsclQGPropagator(lsclF(?a),?b);

*--#] lsclBeforeInsertingFeynmanRules:

*--#[ lsclInsertProjector:

* When using projectors instead of tensor reduction, they should be
* introduced here. The insertion of projectors usually occurs at a
* very early stage of the evaluation, just after loading the amplitude

* projector=MTD[Lor1,Lor2] 1/((D-1)SPD[p])1/(2CA CF) SUNDelta[Glu1,Glu2]

* multiply lsclSUNDelta(lsclCAj1, lsclCAj2)*d_(lsclNu1,lsclNu2)*1/(lsclD-1)*1/p1.p1*1/(lsclSUNN^2-1);


*--#] lsclInsertProjector:

*--#[ lsclDoTensorReduction:

* When doing tensor reduction, the corresponding code from this fold
* is executed after the CodeBlock1 fold

* Setting lsclPprIsolateLoopMomenta to 1 we tell lsclIsolate to isolate loop momenta k1,k2,... as well
#define lsclPprIsolateLoopMomenta "1"

#message `lsclProcessName':: lsclDoTensorReduction: Calling lsclIsolate : `time_' ...
#call lsclIsolate(lsclWrapFun51,lsclWrapFun52,lsclFAD, lsclGFAD, lsclDiracGamma, lsclDiracTrace)
#message `lsclProcessName':: lsclDoTensorReduction: ... done : `time_'

#message `lsclProcessName': lsclDoTensorReduction: Calling sort : `time_' ...
.sort
#message `lsclProcessName': lsclDoTensorReduction: ... done : `time_'

#message `lsclProcessName':: lsclDoTensorReduction: Calling lsclPrepareTensorReduction : `time_' ...
#call lsclPrepareTensorReduction(lsclWrapFun50)
#message `lsclProcessName': lsclDoTensorReduction: ... done : `time_'

#message `lsclProcessName': lsclDoTensorReduction: Calling sort : `time_' ...
.sort
#message `lsclProcessName': lsclDoTensorReduction: ... done : `time_'

#message `lsclProcessName':: lsclDoTensorReduction: Calling lsclIsolate again: `time_' ...
#call lsclIsolate(lsclWrapFun53,lsclWrapFun54,lsclTensRedLoop,lsclTensRedMomenta,lsclTensRedRank,lsclTensRedNLegs,lsclTensRedType)
#message `lsclProcessName':: lsclDoTensorReduction: ... done : `time_'

b lsclTensRedLoop,lsclTensRedMomenta,lsclTensRedRank,lsclTensRedNLegs,lsclTensRedType;
print[];

#define lsclPprIsolateLoopMomenta "0"

#message `lsclProcessName': lsclDoTensorReduction: Calling sort : `time_' ...
.sort
#message `lsclProcessName': lsclDoTensorReduction: ... done : `time_'

* Here we determine the highest number of legs and tensor rank in the amplitude
#$lslcDollarMaxTensorRank=0;
#$lslcDollarMaxNLegs=0;

id lsclTensRedRank(lsclS?) = lsclS30^lsclS*lsclTensRedRank(lsclS);
id lsclTensRedNLegs(lsclS?) = lsclS31^lsclS*lsclTensRedNLegs(lsclS);

if ( count(lsclS30,1) > $lslcDollarMaxTensorRank ) $lslcDollarMaxTensorRank = count_(lsclS30,1);
if ( count(lsclS31,1) > $lslcDollarMaxNLegs ) $lslcDollarMaxNLegs = count_(lsclS31,1);


ModuleOption, maximum, $lslcDollarMaxTensorRank, $lslcDollarMaxNLegs;


#message `lsclProcessName': lsclDoTensorReduction: Calling sort : `time_' ...
.sort
#message `lsclProcessName': lsclDoTensorReduction: ... done : `time_'

* Here we determine the lowest number of legs and tensor rank in the amplitude
#$lslcDollarMinTensorRank=$lslcDollarMaxTensorRank;
#$lslcDollarMinNLegs=$lslcDollarMaxNLegs;

if ( count(lsclS30,1) < $lslcDollarMinTensorRank ) $lslcDollarMinTensorRank = count_(lsclS30,1);
if ( count(lsclS31,1) < $lslcDollarMinNLegs ) $lslcDollarMinNLegs = count_(lsclS31,1);

ModuleOption, minimum, $lslcDollarMinTensorRank, $lslcDollarMinNLegs;

#message `lsclProcessName': lsclDoTensorReduction: Calling sort : `time_' ...
.sort
#message `lsclProcessName': lsclDoTensorReduction: ... done : `time_'


id lsclS30^lsclS?!{,0} = 1;
id lsclS31^lsclS?!{,0} = 1;



#if (`$lslcDollarMinTensorRank' == 0)
#$lslcDollarMinTensorRank = 1;
#endif

#message `lsclProcessName': lsclDoTensorReduction: Tensor ranks: from `$lslcDollarMinTensorRank' to `$lslcDollarMaxTensorRank'
#message `lsclProcessName': lsclDoTensorReduction: Number of legs: from `$lslcDollarMinNLegs' to `$lslcDollarMaxNLegs'


#message `lsclProcessName': lsclDoTensorReduction: Loading symmetry relations between numerators : `time_' ...

#do i=1,`lsclNLoops'

#include Tables/TensorReductions/TDRules/lsclRulesRedTypeToTdRank1To10L`i'.frm

#if (`$lslcDollarMaxTensorRank' > 10)
#include Tables/TensorReductions/TDRules/lsclRulesRedTypeToTdRank11To20L`i'.frm
#endif

#do j=`$lslcDollarMinTensorRank',`$lslcDollarMaxTensorRank'
#if (`LSCLVERBOSITY'>0)
#message `lsclProcessName': lsclDoTensorReduction: Loading tensor reduction names, rank `j' and `i' loop(s)
#endif

#if (`i' <= `j')
#include Tables/TensorReductions/TdNames/lsclAllTdNamesRank`j'L`i'.frm
#else 
#include Tables/TensorReductions/TdNames/lsclAllTdNamesRank`j'L`j'.frm
#endif


label labelTdMappingDone;
.sort

#enddo

#enddo


#message `lsclProcessName': lsclDoTensorReduction: ... done : `time_'



#message `lsclProcessName': lsclDoTensorReduction: Loading reduction rules : `time_' ...

* Loading reduction rules

* Outer loop: number of legs
#do i=`$lslcDollarMinNLegs',`$lslcDollarMaxNLegs'

* First we map the number of legs to the corresponding directory
#switch `i'

#case 0
#define LSCLTDECDIRNAME "Tadpole";
#break

#case 1
#define LSCLTDECDIRNAME "Bubble";
#break

#case 2
#define LSCLTDECDIRNAME "Triangle";
#break

#case 3
#define LSCLTDECDIRNAME "Box";
#break

#default
exit "Unsupported number of legs";
#break

#endswitch


* Inner loop: number of loops
#do j=1,`lsclNLoops'

#if (`LSCLVERBOSITY'>0)
#message `lsclProcessName': lsclDoTensorReduction: Loading tensor reduction rules at `j' loop(s)
#endif

* Inner loop: tensor rank
#do k=`$lslcDollarMinTensorRank',`$lslcDollarMaxTensorRank'


#if (`j' <= `k')

#do l=1, `$lsclDollarTdRank`k'L`j'NumTotal'
#if (`LSCLVERBOSITY'>0)
#message `lsclProcessName': lsclDoTensorReduction: Loading tensor reduction rule: `LSCLTDECDIRNAME'/`$lsclDollarTdRank`k'L`j'N`l''.frm
#endif
#include Tables/TensorReductions/`LSCLTDECDIRNAME'/`$lsclDollarTdRank`k'L`j'N`l''.frm
label labelTdReductionDone;
.sort
#enddo

#else

#do l=1, `$lsclDollarTdRank`k'L`k'NumTotal'
#if (`LSCLVERBOSITY'>0)
#message `lsclProcessName': lsclDoTensorReduction: Loading tensor reduction rule: `LSCLTDECDIRNAME'/`$lsclDollarTdRank`k'L`k'N`l''.frm
#endif
#include Tables/TensorReductions/`LSCLTDECDIRNAME'/`$lsclDollarTdRank`k'L`k'N`l''.frm
label labelTdReductionDone;
.sort
#enddo

#endif



#enddo
#enddo
#enddo

#message `lsclProcessName': lsclDoTensorReduction: ... done : `time_'

* Remove the flags multiplying the scalar piece
multiply replace_(lsclTensRedMomenta,lsclTensRedMomentaRaw);
id lsclTensRedLoop()*lsclTensRedRank(0)*lsclTensRedNLegs(lsclS?)*lsclTensRedMomentaRaw(?b)*lsclTensRedType() = 1;



if (occurs(lsclTensRedLoop,lsclTensRedMomenta));
print "`lsclProcessName': lsclDoTensorReduction: Error, tensor integrals were not reduced, e.g.: %t";
endif;
if (occurs(lsclTensRedLoop,lsclTensRedMomenta)) exit;


#message `lsclProcessName': lsclDoTensorReduction: Doing contractions:  `time_' ...
id lsclTensRedRank(lsclS1?)*lsclTensRedNLegs(lsclS2?)*lsclTensorStructure(lsclS3?) = lsclS3;


#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclKinematics

argument lsclTdNum, lsclTdDen;
#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclKinematics
endargument;

repeat id lsclTdNum(lsclS?) = lsclS;
repeat id lsclTdDen(lsclS?) = lsclDen(lsclS);



#call lsclUnisolate(lsclWrapFun53,lsclWrapFun54)
#call lsclUnisolate(lsclWrapFun52,lsclWrapFun51)


#message `lsclProcessName': lsclDoTensorReduction: All done : `time_'

*--#] lsclDoTensorReduction:

*--#[ lsclCodeBlock0:

* Remove holds that prevent the inserted Feynman rules from swelling up immediately

argument;
id lsclNCHold(lsclS?) = lsclS;
id lsclHold(lsclS?) = lsclS;
endargument;


* Since some terms contain multiple holds with long linear combinations of 4-momenta,
* e.g. gluonic diagrams, we need to remove the holds step by step
#do i = 1,1
id,once, lsclHold(lsclS?) = lsclS;
if (occurs(lsclHold)) redefine i "0";
.sort
#enddo

if (occurs(lsclHold,lsclNCHold)) exit "lsclCodeBlock0: Something went wrong removing holds.";

* Set the outgoing momentum equal to the incoming one
id q1 = p1;
argument;
id q1 = p1;
endargument;

*--#] lsclCodeBlock0:


*--#[ lsclCodeBlock1:

* Dirac algebra simplifications

#message `lsclProcessName':: lsclCodeBlock1: Calling DiracSimplify : `time_' ...
#define DIRACSIMPLIFY
#call lsclDiracSimplify
#message `lsclProcessName':: lsclCodeBlock1: ... done : `time_'

#message `lsclProcessName': lsclCodeBlock1: Calling sort : `time_' ...
.sort
#message `lsclProcessName': lsclCodeBlock1: ... done : `time_'


* Color algebra simplifications
#message `lsclProcessName': lsclCodeBlock1: Calling lsclColorIsolate : `time_' ...
#call lsclColorIsolate(lsclNonColorPiece1,lsclNonColorPiece2)
#message `lsclProcessName': lsclCodeBlock1: ... done : `time_' ...

#message `lsclProcessName': lsclCodeBlock1: Calling sort : `time_' ...
.sort
#message `lsclProcessName': lsclCodeBlock1: ... done : `time_'

* Using color.h
* =========================================================================

#include color.h

* Redeclare color indices here, cf. https://github.com/vermaseren/form/issues/414
I lsclCFi=NR, <lsclCFi1=NR> , ... ,<lsclCFi`LSCLMAXINDEX'=NR>;
I lsclCFj=NR, <lsclCFj1=NR>, ... , <lsclCFj`LSCLMAXINDEX'=NR>;
I lsclCAi=NA, <lsclCAi1=NA>, ... , <lsclCAi`LSCLMAXINDEX'=NA>;
I lsclCAj=NA, <lsclCAj1=NA>, ... , <lsclCAj`LSCLMAXINDEX'=NA>; 
 
repeat;
id lsclSUNDelta(lsclCAi?,lsclCAj?) = d_(lsclCAi,lsclCAj);
id lsclSUNFDelta(lsclCFi?,lsclCFj?) = d_(lsclCFi,lsclCFj);
id lsclSUNTF(lsclCAi?,lsclCFi?,lsclCFj?) = T(lsclCFi,lsclCFj,lsclCAi);
id lsclSUNF(lsclCAi1?,lsclCAi2?,lsclCAi3?) = f(lsclCAi1,lsclCAi2,lsclCAi3);
endrepeat;

if (occurs(lsclSUNDelta,lsclSUNFDelta,lsclSUNTF,lsclSUNF,lsclSUND));
print "lsclProcessStage0: Error, some quantities were not converted to the color.h notation, e.g.: %t";
endif;
if (occurs(lsclSUNDelta,lsclSUNFDelta,lsclSUNTF,lsclSUNF,lsclSUND)) exit;

#call docolor

repeat;
id NA = lsclNA;
id NR = lsclSUNN;
id I2R = 1/2;
id cR = lsclCF;
id cA = lsclCA;
id [cR-cA/2] = lsclCRmCA2;
id d_(lsclCAi?,lsclCAj?) = lsclSUNDelta(lsclCAi,lsclCAj);
id d_(lsclCFi?,lsclCFj?) = lsclSUNFDelta(lsclCFi,lsclCFj);
id T(lsclCFi?,lsclCFj?,lsclCAi?) = lsclSUNTF(lsclCAi,lsclCFi,lsclCFj);
id f(lsclCAi1?,lsclCAi2?,lsclCAi3?) = lsclSUNF(lsclCAi1,lsclCAi2,lsclCAi3);
endrepeat;

#message `lsclProcessName': lsclCodeBlock1: Calling sort : `time_' ...
.sort

* Fix the dimension upon using color.h
Dimension `lsclDim';

* Redeclare color indices again
I lsclCFi, lsclCFi1, ... , lsclCFi`LSCLMAXINDEX';
I lsclCFj, lsclCFj1, ... , lsclCFj`LSCLMAXINDEX';
I lsclCAi, lsclCAi1, ... , lsclCAi`LSCLMAXINDEX';
I lsclCAj, lsclCAj1, ... , lsclCAj`LSCLMAXINDEX';

if (occurs(T,f,NA,NR,I2R,cR,cA,[cR-cA/2]));
print "lsclProcessStage0: Error, some quantities were not converted from the color.h notation, e.g.: %t";
endif;
if (occurs(T,f,NA,NR,I2R,cR,cA,[cR-cA/2])) exit;

* =========================================================================


#message `lsclProcessName': lsclCodeBlock1: Calling lsclUnisolate : `time_' ...
#call lsclUnisolate(lsclNonColorPiece1,lsclNonColorPiece2)
#message `lsclProcessName': lsclCodeBlock1: ... done : `time_'

#message `lsclProcessName': lsclCodeBlock1: Calling sort : `time_' ...
.sort
#message `lsclProcessName': lsclCodeBlock1: ... done : `time_'

* Applying kinematic simplifications

#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclKinematics

argument lsclFAD;
#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclKinematics
endargument;

.sort

* Print the intermediate result. Can be also shortened using bracket and print[];
print;


#message `lsclProcessName': lsclCodeBlock1: All done : `time_'

*--#] lsclCodeBlock1:

*--#[ lsclBeforeTopologyExtraction:

 	
* Here one can add some code to be executed before extracting the list of topologies from the amplitudes

*--#] lsclBeforeTopologyExtraction:


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

* repeat;
* id q1 = p1+p2-q2-q3;
* id p1 = lsclMass(Qb)*(n+nb)/2;
* id n.n^lsclS?pos_ = 0;
* endrepeat;

* Set the quark masses to zero and define p1.p1 = pp
repeat;
id  lsclMass(Qi) = 0;
id  lsclMass(Qj) = 0;
id p1.p1^lsclS?!{,0} = pp^lsclS;
endrepeat;

*--#] lsclKinematics:


*--#[ lsclSimplifyPropagators:

* Here one can simplify the propagators (e.g. pull out a global factor
* out of eikonals) before extracting the topologies present in the amplitudes

*--#] lsclSimplifyPropagators:

*--#[ lsclAdditionalBracketArguments:

* Here one can specify some variables that should be bracketed when inserting
* the reduction tables and simplifying the result using polyratfun
gs,

*--#] lsclAdditionalBracketArguments:

*--#[ lsclSimplifyAmplitudeBeforeReduction:

* This defines simplifications to be applied to the amplitude before inserting
* the reduction tables. For example, one could set some debugging flags to 1
* repeat id lsclDen(lsclS?{la,lsclSUNN}) = 1/lsclS;

*--#] lsclSimplifyAmplitudeBeforeReduction:


*--#[ lsclIsolateLoopIntegralPrefactors:

on shortstats;
#message lsclIsolateLoopIntegralPrefactors: Isolating prefactors of loop integrals:


b,
* Notice that collecting things in this way obscurs the number of the integrals
#do i=1, `LSCLNTOPOLOGIES'
`LSCLTOPOLOGY`i'',
#enddo
;
.sort

Collect lsclIsoFun0, lsclIsoFun1;
argtoextrasymbol lsclIsoFun0, lsclIsoFun1;

.sort

#message
#message `lsclProcessName': lsclIsolateLoopIntegralPrefactors: Enumerating the occurring loop integrals: `time_' ...



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



#message
#message lsclIsolateLoopIntegralPrefactors: ... done : `time_'
#message

#do i=1, `LSCLNTOPOLOGIES'
#do j=1, `$topoPresent`i''
#message `lsclProcessName': lsclIsolateLoopIntegralPrefactors: Number of loop integrals for `LSCLTOPOLOGY`i'': `$topoIntegralCounter`i''
#enddo 
#enddo 


.sort


#do i=1, `LSCLNTOPOLOGIES'
#do j=1,$topoPresent`i'
id `LSCLTOPOLOGY`i''(?a) = lsclIntegral(`LSCLTOPOLOGY`i''(?a));
#enddo
#enddo

.sort


*--#] lsclIsolateLoopIntegralPrefactors:

*--#[ lsclProcessReducedAmplitude:

#define LSCLREDUCEINTSATONCE "50"

#do i=1, `LSCLNTOPOLOGIES'
    #do j=1,$topoPresent`i'
        
        #message
        #message lsclInsertReductionTables: Loading reduction tables for the topology `LSCLTOPOLOGY`i''

        #pipe echo "#define LSCLTABLEPRESENT \"$((ls Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Reductions/`LSCLTOPOLOGY`i''/`LSCLTBLFILENAME' >> /dev/null 2>&1 && echo yes) || echo no)\""

        #if (`LSCLTABLEPRESENT'!="yes")        
        #message "lsclInsertReductionTables: Error, table `LSCLTBLFILENAME' for `LSCLTOPOLOGY`i'' is missing."
        #terminate
        #endif

        TableBase "Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Reductions/`LSCLTOPOLOGY`i''/`LSCLTBLFILENAME'" open;
        TableBase "Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Reductions/`LSCLTOPOLOGY`i''/`LSCLTBLFILENAME'" enter;
        .sort: TableBase;

        #do k=`LSCLSTARTWITHINTEGRALNO',$topoIntegralCounter`i',`LSCLREDUCEINTSATONCE'
           
           #do l=1,`LSCLREDUCEINTSATONCE'
               #message lsclInsertReductionTables: Reducing the integral {`k'+`l'}/`$topoIntegralCounter`i'' from `LSCLTOPOLOGY`i''
               repeat id lsclIntegralNumber(`i',{`k'+`l'})*lsclIntegral(`LSCLTOPOLOGY`i''(?a)) = tabIBP`LSCLTOPOLOGY`i''(?a);
           #enddo
            
            testuse tabIBP`LSCLTOPOLOGY`i'';

            #message            
            #message lsclInsertReductionTables: Calling sort after TestUse : `time_' ...
            .sort: TestUse;

            on shortstats;
            #message lsclInsertReductionTables: ... done.
            
            apply;
            
            #message
            #message lsclInsertReductionTables: Calling sort after Apply : `time_' ...
            .sort: Apply;
            on shortstats;
            #message lsclInsertReductionTables: ... done.

            #message lsclInsertReductionTables: Calling the SimplifyAmplitudeBeforeReduction fold : `time_' ...
            #include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclSimplifyAmplitudeBeforeReduction
            #message lsclInsertReductionTables: ... done.
           
            
            #message
            #message lsclInsertReductionTables: Loading mappings for `LSCLTOPOLOGY`i'' and calling sort : `time_' ...
            repeat;
            #include Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Reductions/`LSCLTOPOLOGY`i''/MasterIntegralMappings.frm #lsclMasterIntegralMappings
            endrepeat;
            .sort: Mappings;
            #message lsclInsertReductionTables: ... done.


            #message
            #message lsclProcessReducedAmplitude: Calling sort : `time_' ...                                    
            .sort
            #message lsclProcessReducedAmplitude: ... done.


            
        #enddo
    #enddo
#enddo

*******************************************************************************



    if(occurs(lsclIntegralNumber,lsclIntegral));
    print "lsclInsertReductionTables: Warning: Some integrals were not reduced, e.g.: %t";
    endif;
    if(occurs(lsclIntegralNumber,lsclIntegral)) exit;
    .sort


id lsclHoldNum(lsclS?) = lsclNum(lsclS);
id lsclHoldDen(lsclS?) = lsclDen(lsclS);

repeat id lsclIsoFun0(lsclS?) = lsclS;
FromPolynomial;

.sort

*--#] lsclProcessReducedAmplitude:


*--#[ lsclAddUpDiagramsCode:

* This fold is used for adding up amplitudes after having inserted the reduction
* tables. This allows for various cancellations to take place but also requires
* a factorization of the whole expression



id lsclSkipNum(lsclS?) = lsclNum(lsclS);
id lsclSkipDen(lsclS?) = lsclDen(lsclS);

id lsclTdNum(lsclS?) = lsclNum(lsclS);
id lsclTdDen(lsclS?) = lsclDen(lsclS);


#message lsclAddUpDiagramsCode: Applying lsclApplyPolyRatFun and lsclNumDenFactorize: `time_' ...
b,
#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclAdditionalBracketArguments
,
lsclSkipNum,lsclSkipDen,d_
lsclWrapFun,lsclEp,lsclDiaFlag,lsclNum,lsclDen,
#if (`lsclNLoops' > 0)
#do i=1, `LSCLNTOPOLOGIES'
`LSCLTOPOLOGY`i'',
#enddo
#endif
;
.sort
collect lsclWrapFun1,lsclWrapFun2;


#call lsclApplyPolyRatFun(lsclNum,lsclDen,lsclRat,lsclWrapFun1,lsclWrapFun2);
.sort
#call lsclNumDenFactorize(lsclNum,lsclDen,lsclRat,`lsclDenNumFactorizeArguments');
.sort
#message lsclAddUpDiagramsCode: ... done.
#if (`lsclNLoops' > 0)
#do i=1, `LSCLNTOPOLOGIES'
repeat id `LSCLTOPOLOGY`i''(?a) = lsclGLI(`LSCLTOPOLOGY`i'',?a);
#enddo
#endif
#message lsclAddUpDiagramsCode: ... done.

*--#] lsclAddUpDiagramsCode:
