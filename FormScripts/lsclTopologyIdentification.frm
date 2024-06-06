on shortstats;
on HighFirst;

#include lsclDeclarations.h
#include lsclDefinitions.h
#include Projects/`lsclProjectName'/FeynmanRules/lsclParticles_`lsclModelName'.h

#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclGeneric


#message `lsclProjectName'
#message `lsclProcessName'
#message `lsclNLoops'
#message `lsclDiaNumber'

#ifdef `LSCLEXTRACTTOPOLOGIES'

#endif

Load Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Stage0/stage0_dia`lsclDiaNumber'L`lsclNLoops'.res;
G s1dia`lsclDiaNumber'L`lsclNLoops' = s0dia`lsclDiaNumber'L`lsclNLoops';

.sort

* collect w.r.t. denominators, put all prefactors into lsclWrapFun1 and lsclWrapFun2
b lsclGFAD,lsclFAD,
*#do i=1, `lsclNLoops'
*k`i',
*#enddo
;

.sort
collect lsclWrapFun1,lsclWrapFun2;

* for the extraction of topologies the prefactors are set to unity
*********************************************************************
#ifdef `LSCLEXTRACTTOPOLOGIES'
id lsclWrapFun1(?a) = 1;
id lsclWrapFun2(?a) = 1;
#endif
*********************************************************************

* convert scalar products to lsclSPD functions
argument lsclGFAD,lsclFAD;
id lsclP1?.lsclP2?^lsclS?!{,0} = lsclSPD(lsclP1,lsclP2)^lsclS;
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
chainin lsclRawTopology;

* for the extraction of topologies we leave the script here
*********************************************************************
#ifdef `LSCLEXTRACTTOPOLOGIES'
.sort
print;

format Mathematica;
#write <Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/ExtractedTopologies/topos_dia`lsclDiaNumber'L`lsclNLoops'.m> "(%E)", s1dia`lsclDiaNumber'L`lsclNLoops'

.sort
#message lsclTopologyIdentification: Topology extraction completed successfully.
.end
#endif
*********************************************************************


#message lsclTopologyIdentification: Calling the lsclSimplifyPropagators fold : `time_' ...
#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclSimplifyPropagators
#message lsclTopologyIdentification: ... done: `time_'


* rawTopologies -> preTopologies
#message lsclTopologyIdentification: Calling sort : `time_' ...
.sort
#message lsclTopologyIdentification: ... done: `time_'
CF
#include Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/preTopologies.frm #lsclTopologyNames
;

argtoextrasymbol  lsclWrapFun1;
argtoextrasymbol  lsclWrapFun2;

#message lsclTopologyIdentification: Calling sort : `time_' ...
.sort
#message lsclTopologyIdentification: ... done: `time_'

#message lsclTopologyIdentification: Calling the lsclTopologyRules fold from preTopologies.frm: `time_' ...
#include Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/preTopologies.frm #lsclTopologyRules
#message lsclTopologyIdentification: ... done: `time_'


#if (`LSCLVERBOSITY'>0)
#message lsclTopologyIdentification: Structure of the amplitude at this stage
b,
#include Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/preTopologies.frm #lsclTopologyNames
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
#include Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/partialFractioning.frm #lsclTopologyNames
;

#message lsclTopologyIdentification: Calling sort : `time_' ...
.sort
#message lsclTopologyIdentification: ... done: `time_'

#message lsclTopologyIdentification: Calling the lsclTopologyRules fold from partialFractioning.frm: `time_' ...
#include Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/partialFractioning.frm #lsclTopologyRules
#message lsclTopologyIdentification: ... done: `time_'
 
#if (`LSCLVERBOSITY'>0)
#message lsclTopologyIdentification: Structure of the amplitude at this stage
b,
#include Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/preTopologies.frm #lsclTopologyNames
,
#include Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/partialFractioning.frm #lsclTopologyNames
;
print[];
.sort
#endif 
 
* mappings between unique topologies
#message lsclTopologyIdentification: Calling sort : `time_' ...
.sort
#message lsclTopologyIdentification: ... done: `time_'
CF
#include Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/topologyMappings.frm #lsclTopologyNames
;

#message lsclTopologyIdentification: Calling sort : `time_' ...
.sort
#message lsclTopologyIdentification: ... done: `time_'

#message lsclTopologyIdentification: Calling the lsclTopologyMappings fold from topologyMappings.frm: `time_' ...
#include Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/topologyMappings.frm #lsclTopologyMappings
#message lsclTopologyIdentification: ... done: `time_'

#if (`LSCLVERBOSITY'>0)
#message lsclTopologyIdentification: Structure of the amplitude at this stage
b,
#include Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/topologyMappings.frm #lsclTopologyNames
;
print[];
.sort
#endif 



* completion of topologies that do not have enough propagators to form a basis
#message lsclTopologyIdentification: Calling sort : `time_' ...
.sort
#message lsclTopologyIdentification: ... done: `time_'
CF
#include Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/augmentedTopologies.frm #lsclTopologyNames
;

#message lsclTopologyIdentification: Calling sort : `time_' ...
.sort
#message lsclTopologyIdentification: ... done: `time_'

#message lsclTopologyIdentification: Calling the lsclTopologyMappings fold from augmentedTopologies.frm: `time_' ...
#include Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/augmentedTopologies.frm #lsclTopologyMappings
#message lsclTopologyIdentification: ... done: `time_'


#if (`LSCLVERBOSITY'>0)
#message lsclTopologyIdentification: Structure of the amplitude at this stage
b,
#include Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/augmentedTopologies.frm #lsclTopologyNames
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

id lsclWrapFun1(lsclS?) = lsclS;
id lsclWrapFun2(lsclS?) = lsclS;
FromPolynomial;

* collect w.r.t. denominators, put all prefactors into lsclWrapFun1 and lsclWrapFun2
b 
#do i=1, `lsclNLoops'
k`i',
#enddo
#include Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/augmentedTopologies.frm #lsclTopologyNames
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
#include Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/augmentedTopologies.frm #lsclTopologyNames
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
#include Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/augmentedTopologies.frm #lsclTopologyNames
;
print;
.sort
#endif
.end

#do i=`lsclToposFrom',`lsclToposTo'
#message lsclTopologyIdentification: Calling the #lsclScalarProductRulesFor`$lsclTopoName`i'' fold from scalarProductRules.frm: `time_' ...
repeat;
#include Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/scalarProductRules.frm #lsclScalarProductRulesFor`$lsclTopoName`i''
endrepeat;
#message lsclTopologyIdentification: ... done: `time_'


#if (`LSCLVERBOSITY'>0)
#message lsclTopologyIdentification: Structure of the amplitude at this stage
b,
#include Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/augmentedTopologies.frm #lsclTopologyNames
;
print;
.sort
#endif 

#message lsclTopologyIdentification: Calling sort for this topology: `time_' ...
.sort
#message lsclTopologyIdentification: ... done: `time_'
#enddo



if (occurs(lsclWrapFun3,lsclWrapFun4));
print "Error, something went wrong in the previous steps.";
exit;
endif;

if (occurs(
#do i=1, `lsclNLoops'
k`i',
#enddo
)) exit "Error, failed to eliminate all loop momenta.";

* collect w.r.t. denominators, put all prefactors into lsclWrapFun3 and lsclWrapFun4
b 
#include Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/augmentedTopologies.frm #lsclTopologyNames
;
#message lsclTopologyIdentification: Calling sort: `time_' ...
.sort
#message lsclTopologyIdentification: ... done: `time_'

collect lsclWrapFun3,lsclWrapFun4;
argtoextrasymbol lsclWrapFun3,lsclWrapFun4;

#message lsclTopologyIdentification: Calling sort: `time_' ...
.sort
#message lsclTopologyIdentification: ... done: `time_'


#message lsclTopologyIdentification: Merging inverse propgators into loop integrals: `time_' ...
repeat;
#do i=1,`LSCLMAXPROPAGATORS'
id lsclF?{
 #include Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/augmentedTopologies.frm #lsclTopologyNames
}(lsclX1?,...,lsclX`i'?)*lsclF?{
 #include Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/augmentedTopologies.frm #lsclTopologyNames
}(lsclY1?,...,lsclY`i'?)
 = lsclF(<lsclX1+lsclY1>,...,<lsclX`i'+lsclY`i'>);
#enddo
endrepeat;
#message lsclTopologyIdentification: ... done: `time_'

#message lsclTopologyIdentification: Calling sort: `time_' ...
.sort
#message lsclTopologyIdentification: ... done: `time_'

b
#include Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/augmentedTopologies.frm #lsclTopologyNames
;
* Extract loop integrals occurring in the amplitude
*********************************************************************
#ifdef `LSCLEXTRACTLOOPINTEGRALS'
#message lsclTopologyIdentification: Extracting loop integrals for the reduction

#message lsclTopologyIdentification: Calling sort: `time_' ...
.sort
#message lsclTopologyIdentification: ... done: `time_'


collect lsclWrapFun5,lsclWrapFun6;
argtoextrasymbol lsclWrapFun5,lsclWrapFun6;
#message lsclTopologyIdentification: Calling sort: `time_' ...
.sort
#message lsclTopologyIdentification: ... done: `time_'


id lsclWrapFun5(?a) = 1;
id lsclWrapFun6(?a) = 1;

* put topologyXYZ functions into lsclGLI
*id lsclF?{
* #include Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/augmentedTopologies.frm #lsclTopologyNames
*}(?a) = lsclGLI(lsclF,?a);


print[];
.sort


delete storage;

#message lsclTopologyIdentification: Calling sort: `time_' ...
.sort
#message lsclTopologyIdentification: ... done: `time_'

.store

save Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/LoopIntegrals/Form/dia`lsclDiaNumber'L`lsclNLoops'.res;

.sort
#message lsclTopologyIdentification: Extraction of loop integrals completed successfully.
.end
#endif
*********************************************************************

print[];

#message lsclTopologyIdentification: Calling sort: `time_' ...
.sort
#message lsclTopologyIdentification: ... done: `time_'


#message lsclTopologyIdentification: Removing isolations: `time_' ...

id lsclG?{lsclWrapFun3,lsclWrapFun4}(lsclS?) = lsclS;
FromPolynomial;

#message lsclTopologyIdentification: Calling sort: `time_' ...
.sort
#message lsclTopologyIdentification: ... done: `time_'

id lsclG?{lsclWrapFun1,lsclWrapFun2}(lsclS?) = lsclS;
FromPolynomial;

#message lsclTopologyIdentification: Calling sort: `time_' ...
.sort
#message lsclTopologyIdentification: ... done: `time_'

#message delete storage
delete storage;

#message lsclTopologyIdentification: Calling sort: `time_' ...
.sort
#message lsclTopologyIdentification: ... done: `time_'

.store

save Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Stage1/stage1_dia`lsclDiaNumber'L`lsclNLoops'.res;

#message lsclTopologyIdentification: Calling sort: `time_' ...
.sort
#message lsclTopologyIdentification: ... done: `time_'

#message lsclTopologyIdentification: Topology reduction completed successfully.

.end
