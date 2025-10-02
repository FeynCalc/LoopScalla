
*--#[ lsclGeneric:

* Definitions of normal and preprocessor variables specific
* to this process

* S mySymbol1, mySymbols2;
* V myVector1, myVector2;
S pp;

* A set of all loop momenta
set lsclLoopMomenta: 
#do i=1, `lsclNLoops'
k`i',
#enddo
;

* You need to put the correct number of initial and final states here. This can
* be useful later if you want to loop over the external momenta.
#define lsclPprNumOfInParticles "1"
#define lsclPprNumOfOutParticles "1"

* If you are using projectors, set lsclPprInsertProjector to 1. The projector
* must be introduced in the lsclInsertProjector fold. Otherwise the code will
* perform tensor reduction using the code from the lsclDoTensorReduction fold.
#ifndef `lsclPprInsertProjector'
#define lsclPprInsertProjector "0"
#endif

* By default no polarization vectors or spinors are truncated. If you want to
* have amplitudes with open Dirac or Lorentz indices (e.g. for applying specific
* projectors), you can set these preprocessor variables to 1. The code responsible
* for the truncation is located in FeynmanRules/lsclCommonFeynmanRules.h. If you are
* not using those Feynman rules at all, you will need to do the truncation by hand.

#ifndef `lsclPprTruncateSpinors'
#define lsclPprTruncateSpinors "1"
#endif

#ifndef `lsclPprTruncatePolVectors'
#define lsclPprTruncatePolVectors "1"
#endif

* When loading reduction tables in the lsclProcessReducedAmplitude fold, there is an
* option to limit the number of entries loaded from IBP tables at once. The default
* value of 100 means that we first reduce 100 loop integrals appearing in the amtplitude,
* then do .sort (and possibly other manipulations) and only then load the next batch until
* there are no unreduced integrals left. This procedure can be helpful when the reduction
* rules are so complicated that loading all of them at once would lead to an exterme expression
* swell.
#define lsclPprNumOfLoopIntsToReduceAtOnce "100"

* Define a list of arguments that can be passed to lsclNumDenFactorize to be pulled out of lsclNum 
* and lsclDen. For example, specifying
* #define lsclDenNumFactorizeArguments "{gs\,el\,}"
* means that every lsclNum(gs) or lsclDen(gs) will be converted to gs and 1/gs respectively when
* calling lsclNumDenFactorize. This is helpful to avoid expression swell due to simple symbols
* being trapped in lsclNum and lsclDen. We recommend to put at least all coupling constants into 
* this list. Masses or scalar product values that might appear in the tensor reduction or the 
* IBP reduction tables should not be included here. 
#define lsclPprNumDenFactorizeArguments "{gs\,el\,mw\,sW\,cW\,}"

* Define variables contained in lsclNum and lsclDen that will trigger another factorization of those 
* terms using polyratfun. Attempting factorization increases the chance of simplifying the expression
* by cancelling some terms in the numerator against those in the denominator. However, when there is 
* already a large number of lsclNum and lsclDen terms with very complicated arguments, calling
* polyratfun can easily result into FORM crashing due to a workspace overflow. This is why it is useful
* not to involve all lsclNum and lsclDen into the factorization process but to select only those
* where we expect some cancellations to happen. To this aim we define the "trigger" variables in
* the list below. If none of those are contained in lsclNum and lsclDen, no factorization of those
* terms will take place. Typically, one would want to put into this list the number of dimensions,
* SU(N) constants and masses or scalar product values that might appear in the tensor reduction or the 
* IBP reduction tables. 
#define lsclPprFactorizationVariables "lsclD,lsclSUNN,lsclNA,lsclCF,lsclCA,lsclCRmCA2,pp,"

* Here one can specify some variables that should be bracketed when extracting integral families or
* inserting the reduction tables and simplifying the result using polyratfun. Bracketing means that
* the terms will be collected with respect to these variables in addition to other variabels already
* specified in the relevant code. There is no need to specify topology names, d_, lsclD, lsclEp,
* lsclNum or lsclDen as those are normally already included in right places. What can be useful to
* specify are coupling constants appearing in the numerators, e.g. gs or el as well as the gauge
* paramaters e.g. lsclGaugeXi
#define lsclPprAdditionalBracketArguments "gs,el,lsclGaugeXi"

*--#] lsclGeneric:

*--#[ lsclKinematics:

* Here we define the kinematics of the amplitude and introduce
* the 4-momentum conservation. This might be called multiple times
* during different execution stages.


* QGRAF does not automatically enforce momentum conservation among external momenta,
* so it is a good idea to specify it here. Remember, that pi momenta are always incoming,
* while qi momenta are always outgoing

* Furthermore, we need to insert masses of the particles appearing in the internal lines
* and define all scalar products made of external momenta. If on-shell external states are
* involved, we may need to set the values of scalar products involving polarization vectors.

repeat;
id q1 = p1;
id p1.p1^lsclS?pos_ = pp^lsclS;
id lsclMass(Qi) = 0;
id lsclMass(Qj) = 0;
endrepeat;


*--#] lsclKinematics:



*--#[ lsclBeforeInsertingFeynmanRules:


* Here we filter out true self-energy corrections on
* external legs while keeping those, where the incoming
* and outgoing particles are different so that we have 
* a genuine contribution.

#call lsclMarkFermionLoops(lsclQGVertex,lsclQGPropagator,lsclFermionLine,lsclFermionLoop);

*--#] lsclBeforeInsertingFeynmanRules:


*--#[ lsclInsertProjector:

* When using projectors instead of tensor reduction, they should be
* introduced here. The insertion of projectors usually occurs at a
* very early stage of the evaluation, just after loading the amplitude

* Here is an example projector
* multiply lsclSUNDelta(lsclCAj1, lsclCAj2)*d_(lsclNu1,lsclNu2)*1/(lsclD-1)*1/p1.p1*1/(lsclSUNN^2-1);


*--#] lsclInsertProjector:

* This is a rather generic code for doing tensor reduction that should work
* in most normal cases. Of course, edge cases might require additional optimizations
*--#[ lsclDoTensorReduction:

* When doing tensor reduction, the corresponding code from this fold
* is executed after the CodeBlock1 fold

* Setting lsclPprIsolateLoopMomenta to 1 we tell lsclIsolate to isolate loop momenta k1,k2,... as well
#define lsclPprIsolateLoopMomenta "1"

#message `lsclProcessName':: lsclDoTensorReduction: Calling lsclIsolate : `time_' ...
#call lsclIsolate(lsclWrapFun51,lsclWrapFun52,lsclFAD, lsclGFAD, lsclDiracGamma, lsclDiracTrace,lsclEps)
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
#call lsclIsolate(lsclWrapFun53,lsclWrapFun54,lsclTensRedLoop,lsclTensRedMomenta,lsclTensRedRank,lsclTensRedNLegs,lsclTensRedType,lsclDontIsolateCF,lsclDontIsolateF)
#message `lsclProcessName':: lsclDoTensorReduction: ... done : `time_'

b lsclTensRedLoop,lsclTensRedMomenta,lsclTensRedRank,lsclTensRedNLegs,lsclTensRedType;
print[];

#define lsclPprIsolateLoopMomenta "0"

#message `lsclProcessName': lsclDoTensorReduction: Calling sort : `time_' ...
.sort
#message `lsclProcessName': lsclDoTensorReduction: ... done : `time_'

#message `lsclProcessName': lsclDoTensorReduction: Calling lsclIdentifyPresentTensors: `time_' ...
#call lsclIdentifyPresentTensors($lsclDollarMaxTensorRank,$lsclDollarMinTensorRank,$lsclDollarMaxNLegs,$lsclDollarMinNLegs)
#message `lsclProcessName': lsclDoTensorReduction: ... done : `time_'

#message `lsclProcessName': lsclDoTensorReduction: Tensor ranks: from `$lsclDollarMinTensorRank' to `$lsclDollarMaxTensorRank'
#message `lsclProcessName': lsclDoTensorReduction: Number of legs: from `$lsclDollarMinNLegs' to `$lsclDollarMaxNLegs'

#message `lsclProcessName': lsclDoTensorReduction: Calling lsclLoadTensorSymmetries: `time_' ...
#call lsclLoadTensorSymmetries($lsclDollarMaxTensorRank,$lsclDollarMinTensorRank)
#message `lsclProcessName': lsclDoTensorReduction: ... done : `time_'

#message `lsclProcessName': lsclDoTensorReduction: Calling lsclLoadTensorReductions: `time_' ...
#call lsclLoadTensorReductions($lsclDollarMaxTensorRank,$lsclDollarMinTensorRank,$lsclDollarMaxNLegs,$lsclDollarMinNLegs)
#message `lsclProcessName': lsclDoTensorReduction: ... done : `time_'

#message `lsclProcessName': lsclDoTensorReduction: Doing index contractions:  `time_' ...

repeat;
id lsclDontIsolateCF(lsclS?) = lsclS;
id lsclDontIsolateF(lsclS?) = lsclS;
endrepeat;

id lsclTensRedRank(lsclS1?)*lsclTensRedNLegs(lsclS2?)*lsclTensorStructure(lsclS3?) = lsclS3;

#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclKinematics

argument lsclTdNum, lsclTdDen;
#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclKinematics
endargument;

repeat id lsclTdNum(lsclS?) = lsclS;
repeat id lsclTdDen(lsclS?) = lsclDen(lsclS);

#call lsclUnisolate(lsclWrapFun53,lsclWrapFun54)
#call lsclUnisolate(lsclWrapFun52,lsclWrapFun51)

* If needed one could extract the unprocessed amplitude here to compare it with 
* other results
*print;
*.sort
*#call lsclToFeynCalc(s0dia`lsclDiaNumber'L`lsclNLoops',Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Results/s0dia`lsclDiaNumber'L`lsclNLoops'-tr.m)
*.end

#message `lsclProcessName': lsclDoTensorReduction: All done : `time_'

*b lsclGaugeXi,lsclFermionLoop,gs,lsclCA,lsclCF;
*print[];
*.sort

*--#] lsclDoTensorReduction:


*--#[ lsclBeforeTopologyExtraction:

* Here one can add some code to be executed before extracting the list of topologies from the amplitudes

*--#] lsclBeforeTopologyExtraction:


*--#[ lsclDiracTraceSimplify:

* This code is called upon right before evaluating Dirac traces.
* Here one e.g. set some noncontributing traces to zero to facilitate
* the job of of FORM's trace/tracen functions.

* repeat id lsclDiracTrace(?a,n,n,?a) = 0;

*--#] lsclDiracTraceSimplify:


*--#[ lsclPowerCounting:

* This is a special block that is relevant only for calculations
* where the amplitude gets expanded prior to topology identification

*--#] lsclPowerCounting:


*--#[ lsclSimplifyPropagators:

* Here one can simplify the propagators (i.e. pull out a global factor
* out of eikonals) before extracting the topologies present in the amplitudes

*--#] lsclSimplifyPropagators:


*--#[ lsclCodeBlock0:

* Here comes the code that gets executed right after inserting the 
* projectors. Some typical instructions would be to set the gauge
* parameter to some specific value or to multiply the amplitude with
* some prefactors

* Without auxiliary functions (lsclHold,lsclNCHold) wrapped around some terms of 
* the Feynman rules, the expressions would swell up enormously after inserting the 
* rules. To prevent this, we remove the auxiliay functions only when actually 
* calculating the amplitude here

if (occurs(lsclNCHold,lsclHold));
argument;
id lsclNCHold(lsclS?) = lsclS;
id lsclHold(lsclS?) = lsclS;
endargument;
endif;

* Since some terms contain multiple holds with long linear combinations of 4-momenta,
* especially diagrams containing interactions of gauge bosons with each other, 
* we need to remove the holds step by step. Removing all of them at one would lead
* to a significant slow down.
#do i = 1,1
id,once, lsclHold(lsclS?) = lsclS;
if (occurs(lsclHold)) redefine i "0";
.sort
#enddo

if (occurs(lsclHold,lsclNCHold)) exit "`lsclProcessName': lsclCodeBlock0: Something went wrong when removing holds.";

#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclKinematics

argument;
#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclKinematics
endargument;

* It is expected, that upon loading the Kinematics fold for the first time, all lsclMass
* placeholders should be eliminated. Otherwise, we won't be able to run IBP reduction at
* a later stage. The following check enforces this requirement

if (occurs(lsclMass));
print "`lsclProcessName': lsclCodeBlock0: Error, some lsclMass placeholders are still present, e.g.: %t";
endif;
if (occurs(lsclMass)) exit;


*--#] lsclCodeBlock0:


*--#[ lsclCodeBlock1:

* This fold mainly contains Dirac and color algebra simplifications.

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

#message `lsclProcessName': lsclCodeBlock1: Calling lsclApplyColorH : `time_' ...
#call lsclApplyColorH()
#message `lsclProcessName': lsclCodeBlock1: ... done : `time_'

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

* Can print the intermediate result here.
* b lsclFAD,lsclGaugeXi,lsclFermionLoop;
* print[];


#message `lsclProcessName': lsclCodeBlock1: All done : `time_'

* If needed one could extract the unprocessed amplitude here to compare it with 
* other results
*print;
*.sort
*#call lsclToFeynCalc(s0dia`lsclDiaNumber'L`lsclNLoops',Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Results/s0dia`lsclDiaNumber'L`lsclNLoops'.m)
*.end

*--#] lsclCodeBlock1:

*--#[ lsclAfterCompletingStage0:

* Here we can execute some code after completing all Stage 0 evaluation steps
* but before saving the result to Stage0/stage0_dia`lsclDiaNumber'L`lsclNLoops'.res;
* For example, we can print the output collected w.r.t. some useful objects

*b lsclDiracSpinor;
*print;
*.sort

*--#] lsclAfterCompletingStage0:

*--#[ lsclSimplifyAmplitudeBeforeReduction:

* This defines simplifications to be applied to the amplitude before inserting
* the reduction tables
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
#message `lsclProcessName': lsclIsolateLoopIntegralPrefactors: ... done : `time_'
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

        #do k=`LSCLSTARTWITHINTEGRALNO',$topoIntegralCounter`i',`lsclPprNumOfLoopIntsToReduceAtOnce'
           
           #do l=1,`lsclPprNumOfLoopIntsToReduceAtOnce'
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
            #ifdef `LSCLKIRA'
            repeat;
            #include Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Reductions/`LSCLTOPOLOGY`i''/MasterIntegralMappingsKira.frm #lsclMasterIntegralMappings
            endrepeat;
            #else
            repeat;
            #include Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Reductions/`LSCLTOPOLOGY`i''/MasterIntegralMappingsFire.frm #lsclMasterIntegralMappings
            endrepeat;
            #endif
            .sort: Mappings;
            #message lsclInsertReductionTables: ... done.


            #message
            #message lsclProcessReducedAmplitude: Calling sort : `time_' ...                                    
            .sort
            #message lsclProcessReducedAmplitude: ... done.


            
        #enddo
    #enddo
#enddo



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
`lsclPprAdditionalBracketArguments'
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
#call lsclNumDenFactorize(lsclNum,lsclDen,lsclRat,`lsclPprNumDenFactorizeArguments');
.sort
#message lsclAddUpDiagramsCode: ... done.
#if (`lsclNLoops' > 0)
#do i=1, `LSCLNTOPOLOGIES'
repeat id `LSCLTOPOLOGY`i''(?a) = lsclGLI(`LSCLTOPOLOGY`i'',?a);
#enddo
#endif
#message lsclAddUpDiagramsCode: ... done.

*--#] lsclAddUpDiagramsCode:
