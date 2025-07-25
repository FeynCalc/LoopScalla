* This file is a part of LoopScalla, a framework for loop calculations
* LoopScalla is covered by the GNU General Public License 3.
* Copyright (C) 2019-2025 Vladyslav Shtabovenko

on shortstats;
on HighFirst;

#include lsclDeclarations.h
#include lsclDefinitions.h
#include Projects/`lsclProjectName'/FeynmanRules/lsclParticles_`lsclModelName'.h

#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclGeneric


#message lsclTopologyIdentification: Project: `lsclProjectName'
#message lsclTopologyIdentification: Process: `lsclProcessName'
#message lsclTopologyIdentification: Model: `lsclModelName'
#message lsclTopologyIdentification: Processing diagram `lsclDiaNumber' at `lsclNLoops' loop(s)


Load Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Stage0/stage0_dia`lsclDiaNumber'L`lsclNLoops'.res;
G s1dia`lsclDiaNumber'L`lsclNLoops' = s0dia`lsclDiaNumber'L`lsclNLoops';
.sort


#message lsclTopologyIdentification: Calling the BeforeTopologyExtraction fold : `time_' ...
#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclBeforeTopologyExtraction
#message lsclTopologyIdentification: ... done: `time_'

.sort

* collect w.r.t. denominators, put all prefactors into lsclWrapFun1 and lsclWrapFun2
b lsclGFAD,lsclFAD,
*#do i=1, `lsclNLoops'
*k`i',
*#enddo
;

.sort
collect lsclWrapFun1,lsclWrapFun2;

*--#[ extractTopologies:

* for the extraction of topologies the prefactors are set to unity
#ifdef `LSCLEXTRACTTOPOLOGIES'
id lsclWrapFun1(?a) = 1;
id lsclWrapFun2(?a) = 1;
#endif

*--#] extractTopologies:


* convert scalar products to lsclSPD functions
argument lsclGFAD,lsclFAD;
repeat;
id lsclP1?.lsclP2?^lsclS?!{,0} = lsclSPD(lsclP1,lsclP2)^lsclS;
endrepeat;
endargument;

* lsclRawTopology is a container for propagators
multiply lsclRawTopology(1);


*#message lsclTopologyIdentification: Topology before any simplifications
*print;
*.sort

* Possible simplifications of propagators involve factoring out overall masses from the eikonals
#message lsclTopologyIdentification: Calling the SimplifyPropagators fold : `time_' ...
#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclSimplifyPropagators
#message lsclTopologyIdentification: ... done: `time_'

* Now all propagators are inside lsclRawTopology
repeat;
id lsclF?{lsclGFAD,lsclFAD}(?a) = lsclRawTopology(lsclF(?a));
endrepeat;

* However, not all propagators will depend on the loop momenta. To make sure that those 
* are not lost, we pull them out of lsclRawTopology right away

argument lsclRawTopology;
if (occurs(k1,...,k`lsclNLoops')==0)
multiply lsclFlag123;
endargument;

id lsclRawTopology(lsclFlag123) = lsclRawTopology(1);
repeat id lsclRawTopology(lsclFlag123*lsclF?{lsclGFAD}(lsclS?)) = 1/lsclS;

if (occurs(lsclFlag123)) exit "Something went wrong during the topology extraction!";

chainin lsclRawTopology;

*--#[ extractTopologies:

* for the extraction of topologies we leave the script here
#ifdef `LSCLEXTRACTTOPOLOGIES'
.sort
b lsclRawTopology;
print[];

format Mathematica;
#write <Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/ExtractedTopologies/topos_dia`lsclDiaNumber'L`lsclNLoops'.m> "(%E)", s1dia`lsclDiaNumber'L`lsclNLoops'

.sort
#message lsclTopologyIdentification: Topology extraction completed successfully.
.end
#endif

*--#] extractTopologies:

* otherwise, we continue with the topology reduction here

#message lsclTopologyIdentification: Calling the lsclSimplifyPropagators fold : `time_' ...
#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclSimplifyPropagators
#message lsclTopologyIdentification: ... done: `time_'

* rawTopologies -> preTopologies
#message lsclTopologyIdentification: Calling sort : `time_' ...
.sort
#message lsclTopologyIdentification: ... done: `time_'
CF
#include Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/preTopologies.frm #lsclTopologyNames
;


******************************************************
* the prefactors of the propagators are now all inside lsclWrapFun1 and lsclWrapFun2

id lsclWrapFun1(lsclS?) = lsclS;
id lsclWrapFun2(lsclS?) = lsclS;


b,
lsclRawTopology, d_,
#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclAdditionalBracketArguments

#do i=1, `lsclNLoops'
k`i',
#enddo
;

.sort

collect lsclWrapFun1,lsclWrapFun2;
#message lsclTopologyIdentification: 1st Factorization
#message lsclTopologyIdentification: Applying lsclApplyPolyRatFun and lsclNumDenFactorize to lsclWrapFun1,lsclWrapFun2: `time_' ...
#call lsclApplyPolyRatFun(lsclNum,lsclDen,lsclRat,lsclWrapFun1,lsclWrapFun2);
.sort
#call lsclNumDenFactorize(lsclNum,lsclDen,lsclRat,`lsclDenNumFactorizeArguments');
.sort
#message lsclInsertReductionTables: ... done.


#message lsclInsertReductionTables: Excluding mixed numerators and denominators from factorization: `time_' ...

repeat id lsclNum(?a) = lsclSkipNum(lsclWrapFun100(?a));
repeat id lsclDen(?a) = lsclSkipDen(lsclWrapFun100(?a));

argument lsclSkipNum,lsclSkipDen;
* Careful, here we're getting a mixture of lsclSkipNum/lsclSkipDen functions from the 
* current and previous replacements. So we only process new functions, while leaving
* the old ones unchanged.
if (occurs(lsclWrapFun100));
    if (occurs(`lsclFactorizationVariables') && occurs(lsclD,lsclEp));
        multiply lsclFlag100;
    endif;
endif;
endargument;

repeat id lsclSkipNum(lsclWrapFun100(?a)) = lsclNum(?a);
repeat id lsclSkipDen(lsclWrapFun100(?a)) = lsclDen(?a);
repeat id lsclSkipNum(lsclFlag100*lsclWrapFun100(?a)) = lsclSkipNum(?a);
repeat id lsclSkipDen(lsclFlag100*lsclWrapFun100(?a)) = lsclSkipDen(?a);

.sort

* Check for dangling lsclFlag100
if (occurs(lsclFlag100));
print "Leftover flag100 in: %t";
endif;
if (occurs(lsclFlag100)) exit "Failed to mask mixed propagators!";

.sort
#message lsclInsertReductionTables: ... done.

******************************************************

#message lsclTopologyIdentification: Calling the lsclTopologyRules fold from preTopologies.frm: `time_' ...
#include Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/preTopologies.frm #lsclTopologyRules
#message lsclTopologyIdentification: ... done: `time_'

if (occurs(lsclRawTopology));
print "Leftover raw topology in: %t";
endif;
if (occurs(lsclRawTopology)) exit "Failed to elimitate raw topology containers.";


#if (`LSCLVERBOSITY'>0)
#message lsclTopologyIdentification: Structure of the amplitude at this stage
b,
#include Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/preTopologies.frm #lsclTopologyNames
;
print[];
.sort
#endif



* partial fraction decomposition for overdetermined sets of propagators
#message lsclTopologyIdentification: Calling sort : `time_' ...
.sort
#message lsclTopologyIdentification: ... done: `time_'
* lsclF1 is needed for cases where the fold #lsclTopologyNames in partialFractioning.frm is empty
CF lsclF1,
#include Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/partialFractioning.frm #lsclTopologyNames
;

#message lsclTopologyIdentification: Calling sort : `time_' ...
.sort
#message lsclTopologyIdentification: ... done: `time_'

#message lsclTopologyIdentification: Calling the lsclTopologyRules fold from partialFractioning.frm: `time_' ...
#include Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/partialFractioning.frm #lsclTopologyRules
#message lsclTopologyIdentification: ... done: `time_'
 
#if (`LSCLVERBOSITY'>0)
#message lsclTopologyIdentification: Structure of the amplitude at this stage
b,
d_,
#include Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/preTopologies.frm #lsclTopologyNames
,
#include Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/partialFractioning.frm #lsclTopologyNames
;
print[];
.sort
#endif 

******************************************************
* Here we do another factorization 
#message lsclTopologyIdentification: 2nd Factorization
#message lsclTopologyIdentification: Applying lsclApplyPolyRatFun and lsclNumDenFactorize to lsclWrapFun1,lsclWrapFun2: `time_' ...
b,
lsclSkipNum,lsclSkipDen,d_
#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclAdditionalBracketArguments
#include Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/preTopologies.frm #lsclTopologyNames
,
#include Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/partialFractioning.frm #lsclTopologyNames
;
.sort
collect lsclWrapFun1,lsclWrapFun2;
 
#call lsclApplyPolyRatFun(lsclNum,lsclDen,lsclRat,lsclWrapFun1,lsclWrapFun2);
.sort
#call lsclNumDenFactorize(lsclNum,lsclDen,lsclRat,`lsclDenNumFactorizeArguments');
.sort
#message lsclInsertReductionTables: ... done.
******************************************************

* mappings between unique topologies
#message lsclTopologyIdentification: Calling sort : `time_' ...
.sort
#message lsclTopologyIdentification: ... done: `time_'
CF
#include Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/topologyMappings.frm #lsclTopologyNames
;

#message lsclTopologyIdentification: Calling sort : `time_' ...
.sort
#message lsclTopologyIdentification: ... done: `time_'

#message lsclTopologyIdentification: Calling the lsclTopologyMappings fold from topologyMappings.frm: `time_' ...
#include Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/topologyMappings.frm #lsclTopologyMappings
#message lsclTopologyIdentification: ... done: `time_'

* Topology mappings introduce shifts of loop momenta that also affect scalar products in the numerators.
* This generates new scalar products of external momenta that must be again set to the predefined values


#message lsclTopologyIdentification: Applying the kinematics constraints: `time_' ...
#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclKinematics
.sort
#message lsclTopologyIdentification: ... done: `time_'


#if (`LSCLVERBOSITY'>0)
#message lsclTopologyIdentification: Structure of the amplitude at this stage
b,
#include Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/topologyMappings.frm #lsclTopologyNames
;
print[];
.sort
#endif 



******************************************************
* Here we do another factorization 

#message lsclTopologyIdentification: 3rd Factorization
#message lsclTopologyIdentification: Applying lsclApplyPolyRatFun and lsclNumDenFactorize to lsclWrapFun1,lsclWrapFun2: `time_' ...
b,
lsclSkipDen,lsclSkipNum,d_,
#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclAdditionalBracketArguments
#include Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/topologyMappings.frm #lsclTopologyNames
;
.sort
collect lsclWrapFun1,lsclWrapFun2;
#call lsclApplyPolyRatFun(lsclNum,lsclDen,lsclRat,lsclWrapFun1,lsclWrapFun2);
.sort
#call lsclNumDenFactorize(lsclNum,lsclDen,lsclRat,`lsclDenNumFactorizeArguments');
.sort
#message lsclInsertReductionTables: ... done.
******************************************************

* completion of topologies that do not have enough propagators to form a basis
#message lsclTopologyIdentification: Calling sort : `time_' ...
.sort
#message lsclTopologyIdentification: ... done: `time_'
CF
#include Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/augmentedTopologies.frm #lsclTopologyNames
;

#message lsclTopologyIdentification: Calling sort : `time_' ...
.sort
#message lsclTopologyIdentification: ... done: `time_'

#message lsclTopologyIdentification: Calling the lsclTopologyMappings fold from augmentedTopologies.frm: `time_' ...
#include Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/augmentedTopologies.frm #lsclTopologyMappings
#message lsclTopologyIdentification: ... done: `time_'


#if (`LSCLVERBOSITY'>0)
#message lsclTopologyIdentification: Structure of the amplitude at this stage
b,
#include Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/augmentedTopologies.frm #lsclTopologyNames
;
print[];
.sort
#endif 



* Check for dangling FADs and GFADs
if (occurs(lsclFAD,lsclGFAD));
print "Leftover propagators in: %t";
endif;
if (occurs(lsclGFAD,lsclFAD)) exit "Failed to put all lsclFAD and lsclGFAD functions into lsclRawTopology!";

* rewriting of scalar products involving loop momenta into linear combinations of inverse propagators
#message lsclTopologyIdentification: Calling sort: `time_' ...
.sort
#message lsclTopologyIdentification: ... done: `time_'

#message lsclTopologyIdentification: Isolating loop integrals: `time_' ...

*id lsclWrapFun1(lsclS?) = lsclS;
*id lsclWrapFun2(lsclS?) = lsclS;
*FromPolynomial;

* collect w.r.t. denominators, put all prefactors into lsclWrapFun1 and lsclWrapFun2
b 
#do i=1, `lsclNLoops'
k`i',
#enddo
#include Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/augmentedTopologies.frm #lsclTopologyNames
;
.sort
collect lsclWrapFun1,lsclWrapFun2;
argtoextrasymbol lsclWrapFun1,lsclWrapFun2;
#message lsclTopologyIdentification: ... done: `time_'

#message lsclTopologyIdentification: Calling sort: `time_' ...
.sort
#message lsclTopologyIdentification: ... done: `time_'


* displaying topologies present in the expression

ab
#include Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/augmentedTopologies.frm #lsclTopologyNames
;
.sort
collect lsclWrapFun3,lsclWrapFun4;



if (occurs(lsclWrapFun4));
print "Error, the topologies do not fit into one function";
exit;
endif;

splitarg lsclWrapFun3;

repeat;
id lsclG?{lsclWrapFun3,lsclWrapFun4}(lsclF?(lsclS?,?a),?b) = lsclG(lsclF)*lsclF(lsclS,?a) + lsclG(?b);
id lsclG?{lsclWrapFun3,lsclWrapFun4}() =0;
endrepeat;

#message lsclTopologyIdentification: Topologies appearing in the expression:
b lsclWrapFun3,lsclWrapFun4;
print[];

#message lsclTopologyIdentification: Calling sort: `time_' ...
.sort
#message lsclTopologyIdentification: ... done: `time_'

* Using the recipe from https://github.com/vermaseren/form/wiki/FORM-Cookbook#split-off-unique-functions
#define lsclToposFrom "{`extrasymbols_'+1}"
argtoextrasymbol lsclWrapFun3;
#message lsclTopologyIdentification: Calling sort: `time_' ...
.sort
#message lsclTopologyIdentification: ... done: `time_'
#define lsclToposTo "`extrasymbols_'"

id lsclWrapFun3(?a) = 1;


#do i=`lsclToposFrom',`lsclToposTo'
#$lsclTopoName`i' = 0;
$lsclTopoName`i' = extrasymbol_(`i');
#enddo
moduleoption notinparallel;
#message lsclTopologyIdentification: Calling sort: `time_' ...
.sort
#message lsclTopologyIdentification: ... done: `time_'


#if (`LSCLVERBOSITY'>0)
#message lsclTopologyIdentification: Structure of the amplitude at this stage
b,
#include Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/augmentedTopologies.frm #lsclTopologyNames
;
print;
.sort
#endif

#do i=`lsclToposFrom',`lsclToposTo'
#message lsclTopologyIdentification: Calling the #lsclScalarProductRulesFor`$lsclTopoName`i'' fold from scalarProductRules.frm: `time_' ...
repeat;
#include Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/scalarProductRules.frm #lsclScalarProductRulesFor`$lsclTopoName`i''
endrepeat;

* If the scalarProductRules.frm id-statements are already wrapped with lsclNum and lsclDen, 
* then this should help to avoid expression swell!
* lsclWrapFun300,lsclWrapFun400 and dummy functions
#message lsclTopologyIdentification: 4th Factorization
#call lsclApplyPolyRatFun(lsclNum,lsclDen,lsclRat,lsclWrapFun300,lsclWrapFun400);
.sort

#message lsclTopologyIdentification: ... done: `time_'


#if (`LSCLVERBOSITY'>0)
#message lsclTopologyIdentification: Structure of the amplitude at this stage
b,
#include Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/augmentedTopologies.frm #lsclTopologyNames
;
print;
.sort
#endif 


#message lsclTopologyIdentification: Calling sort for this topology: `time_' ...
.sort
#message lsclTopologyIdentification: ... done: `time_'

*********************************************

#enddo





if (occurs(
#do i=1, `lsclNLoops'
k`i',
#enddo
)) exit "Error, failed to eliminate all loop momenta.";





* collect w.r.t. denominators, put all prefactors into lsclWrapFun3 and lsclWrapFun4
b 
#include Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/augmentedTopologies.frm #lsclTopologyNames
;
#message lsclTopologyIdentification: Calling sort: `time_' ...
.sort
#message lsclTopologyIdentification: ... done: `time_'

collect lsclWrapFun3,lsclWrapFun4;


******************************************************
* Here we do another factorization, combining rational functions factorized previously with the unfactorized ones from the augmented topologies
#message lsclTopologyIdentification: 5th Factorization
#call lsclApplyPolyRatFun(lsclNum,lsclDen,lsclRat,lsclWrapFun3,lsclWrapFun4);
.sort
#call lsclNumDenFactorize(lsclNum,lsclDen,lsclRat,`lsclDenNumFactorizeArguments');
.sort
id lsclG?{lsclWrapFun1,lsclWrapFun2}(lsclS?) = lsclS;
FromPolynomial;
.sort
#call lsclNumDenFactorize(lsclNum,lsclDen,lsclRat,`lsclDenNumFactorizeArguments');
.sort
#message lsclTopologyIdentification: ... done.
******************************************************

* argtoextrasymbol lsclWrapFun3,lsclWrapFun4;

#message lsclTopologyIdentification: Calling sort: `time_' ...
.sort
#message lsclTopologyIdentification: ... done: `time_'




#message lsclTopologyIdentification: Merging inverse propgators into loop integrals: `time_' ...
repeat;
#do i=1,`LSCLMAXPROPAGATORS'
id lsclF?{
 #include Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/augmentedTopologies.frm #lsclTopologyNames
}(lsclX1?,...,lsclX`i'?)*lsclF?{
 #include Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/augmentedTopologies.frm #lsclTopologyNames
}(lsclY1?,...,lsclY`i'?)
 = lsclF(<lsclX1+lsclY1>,...,<lsclX`i'+lsclY`i'>);
#enddo
endrepeat;
#message lsclTopologyIdentification: ... done: `time_'

#message lsclTopologyIdentification: Calling sort: `time_' ...
.sort
#message lsclTopologyIdentification: ... done: `time_'

b
#include Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/augmentedTopologies.frm #lsclTopologyNames
;
print[];

#message lsclTopologyIdentification: Calling sort: `time_' ...
.sort
#message lsclTopologyIdentification: ... done: `time_'


*#message lsclTopologyIdentification: Removing isolations: `time_' ...

*id lsclG?{lsclWrapFun3,lsclWrapFun4}(lsclS?) = lsclS;
*FromPolynomial;

*#message lsclTopologyIdentification: Calling sort: `time_' ...
*.sort
*#message lsclTopologyIdentification: ... done: `time_'

*id lsclG?{lsclWrapFun1,lsclWrapFun2}(lsclS?) = lsclS;
*FromPolynomial;

*#message lsclTopologyIdentification: Calling sort: `time_' ...
*.sort
*#message lsclTopologyIdentification: ... done: `time_'



*#message lsclTopologyIdentification: Applying lsclApplyPolyRatFun and lsclNumDenFactorize: `time_' ...
*b,
*#include Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/augmentedTopologies.frm #lsclTopologyNames
*;
*.sort
*collect lsclWrapFun10,lsclWrapFun11;
*#call lsclApplyPolyRatFun(lsclNum,lsclDen,lsclRat,lsclWrapFun10,lsclWrapFun11);
*.sort
*
*#call lsclNumDenFactorize(lsclNum,lsclDen,lsclRat,`lsclDenNumFactorizeArguments');
*.sort
*#message lsclInsertReductionTables: ... done.



#message delete storage
delete storage;

#message lsclTopologyIdentification: Calling sort: `time_' ...
.sort
#message lsclTopologyIdentification: ... done: `time_'

.global
.store

#message lsclTopologyIdentification: Saving results to: Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Stage1/stage1_dia`lsclDiaNumber'L`lsclNLoops'.res
save Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Stage1/stage1_dia`lsclDiaNumber'L`lsclNLoops'.res;
#message lsclTopologyIdentification: Calling sort: `time_' ...
.sort
#message lsclTopologyIdentification: ... done: `time_'


*--#[ extractLoopIntegrals:
* TODO Need to investigate the bottleneck here when calling sort
#message lsclTopologyIdentification: Extracting loop integrals for the reduction
G lidia`lsclDiaNumber'L`lsclNLoops' = s1dia`lsclDiaNumber'L`lsclNLoops';
b
#include Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/augmentedTopologies.frm #lsclTopologyNames
;
#message lsclTopologyIdentification: Calling sort: `time_' ...
.sort
#message lsclTopologyIdentification: ... done: `time_'


collect lsclWrapFun1,lsclWrapFun2;
argtoextrasymbol lsclWrapFun1,lsclWrapFun2;

#message lsclTopologyIdentification: Calling sort: `time_' ...
.sort
#message lsclTopologyIdentification: ... done: `time_'


id lsclWrapFun1(?a) = 1;
id lsclWrapFun2(?a) = 1;

* put topologyXYZ functions into lsclGLI
*id lsclF?{
* #include Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/augmentedTopologies.frm #lsclTopologyNames
*}(?a) = lsclGLI(lsclF,?a);


#message lsclTopologyIdentification: Calling sort: `time_' ...
.sort
#message lsclTopologyIdentification: ... done: `time_'

delete storage;

#message lsclTopologyIdentification: Calling sort: `time_' ...
.sort
#message lsclTopologyIdentification: ... done: `time_'

.store
#message lsclTopologyIdentification: Saving loop integrals to Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/LoopIntegrals/Form/dia`lsclDiaNumber'L`lsclNLoops'.res
save Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/LoopIntegrals/Form/dia`lsclDiaNumber'L`lsclNLoops'.res;

.sort
#message lsclTopologyIdentification: Extraction of loop integrals completed successfully.

*--#] extractLoopIntegrals:

#message lsclTopologyIdentification: Topology reduction completed successfully.

.end
