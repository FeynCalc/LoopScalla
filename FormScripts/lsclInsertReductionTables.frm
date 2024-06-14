on stats;
on HighFirst;

#include lsclDeclarations.h
#include lsclDefinitions.h
#include Projects/`lsclProjectName'/FeynmanRules/lsclParticles_`lsclModelName'.h

#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclGeneric


#message lsclInsertReductionTables: `lsclProjectName'
#message lsclInsertReductionTables: `lsclProcessName'
#message lsclInsertReductionTables: `lsclNLoops'
#message lsclInsertReductionTables: `lsclDiaNumber'


#include Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/TopologyList.frm

#ifdef `LSCLEPEXPAND'
#message lsclInsertReductionTables: Using reduction tables expanded in ep
#define LSCLTBLFILENAME "tablebaseExpanded.tbl"
#else
#message lsclInsertReductionTables: Using ep-exact reduction tables
#define LSCLTBLFILENAME "tablebase.tbl"
#endif


CF
#do i=1, `LSCLNTOPOLOGIES'
`LSCLTOPOLOGY`i'',
#enddo 
;


Load Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Stage1/stage1_dia`lsclDiaNumber'L`lsclNLoops'.res;

G s2dia`lsclDiaNumber'L`lsclNLoops' = s1dia`lsclDiaNumber'L`lsclNLoops';

.sort


*********************************************************************
* Before inserting the reduction tables it is a good idea to simplify the coefficients
* multiplying loop integrals
#if (`LSCLNOFACTORIZATION'!=1)
denominators lsclDen;
#else
#message lsclInsertReductionTables: Running with disabled polyratfun and factarg
#endif
*********************************************************************

* Collect the amplitude w.r.t. the loop integrals
* The output might be too large for a log file ...
#if (`LSCLVERBOSITY'>0)
#message lsclInsertReductionTables: Structure of this amplitude
b,
#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclAdditionalBracketArguments
#do i=1, `LSCLNTOPOLOGIES'
`LSCLTOPOLOGY`i'',
#enddo
;
print[];
.sort
#else
.sort
#endif

*#call lsclToFeynCalc(s2dia`lsclDiaNumber'L`lsclNLoops',Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Results/ampL`lsclNLoops'From`lsclDiaNumber'To`lsclDiaNumber'.m)

*.end
*********************************************************************
#if (`LSCLNOFACTORIZATION'!=1)
* Put all coefficients multyiplying loop integrals into lsclWrapFun1 (and lsclWrapFun2 is they are too big)
collect lsclWrapFun1,lsclWrapFun2;

* Factorize the arguments of lsclWrapFun1/lsclWrapFun2 so that f(c1+c2+....) -> f(d1,d2,d3,...) where 
* the original results would be d1*d2*d3*...
factarg lsclWrapFun1,lsclWrapFun2;

* Split lsclWrapFun1/lsclWrapFun2: f(a,b,c) -> f(a)*f(b)*f(c)
* Now each lsclWrapFun1/lsclWrapFun2 contains only one argument
chainout lsclWrapFun1;
chainout lsclWrapFun2;

* Another splitting of lsclWrapFun1/lsclWrapFun2 to decompose the sums into smaller pieces: f(a+b+c) -> f(a,b,c))
* This way we again end up with having lsclWrapFun1/lsclWrapFun2 multiple arguments
splitarg lsclWrapFun1;
splitarg lsclWrapFun2;

** Now each argument is just a single term, not a sum of terms so we can split them into proper sums
** f(a,b,c)-> f(a)+f(b)+f(c)
repeat;
id lsclF?{lsclWrapFun1,lsclWrapFun2}(lsclS1?,lsclS2?,?a) =  lsclF(lsclS1) + lsclF(lsclS2) + lsclF(?a);
* Very important, without this id statement the final result will be wrong
id lsclF?{lsclWrapFun1,lsclWrapFun2}() = 0;
endrepeat;

* Each term is still a product of terms, so we use factarg again to get f(a*b*c) -> f(a,b,c)
factarg lsclWrapFun1,lsclWrapFun2;

* Finally, we are in the position to pull out the denominators
repeat id lsclF?{lsclWrapFun1,lsclWrapFun2}(?a,lsclDen(?c), ?b) =  lsclDen(?c)*lsclF(?a,?b);
repeat id lsclF?{lsclWrapFun1,lsclWrapFun2}() = 1;

* Repeat the splitting f(a,b,c) -> f(a)*f(b)*f(c). This recovers the original expression if each f 
* is set to a unit function
chainout lsclWrapFun1;
chainout lsclWrapFun2;

argument lsclWrapFun1,lsclWrapFun2;
if (occurs(lsclDen)) exit "lsclInsertReductionTables: Something went wrong while factoring out the denominators";
endargument;

id lsclF?{lsclWrapFun1,lsclWrapFun2}(lsclS?) = lsclNum(lsclS);


* Simplification of the numerators/denominators
repeat id lsclNum(lsclT?(?a)) = lsclT(?a);
repeat id lsclNum(lsclS?number_) = lsclS;
repeat id lsclDen(lsclS?number_) = 1/lsclS;
repeat id lsclNum(1/lsclS?) = lsclDen(lsclS);

#message lsclInsertReductionTables: Calling the SimplifyAmplitudeBeforeReduction fold : `time_' ...
#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclSimplifyAmplitudeBeforeReduction
#message lsclInsertReductionTables: ... done.

#if (`LSCLVERBOSITY'>0)
#message lsclInsertReductionTables: Numerators and denominators occurring in the amplitude before inserting the redution tables and using PolyRatFun:
.sort
b lsclNum,lsclDen,lsclWrapFun1,lsclWrapFun2;
print[];
.sort
#endif

#if (`LSCLVERBOSITY'>0)
#message lsclInsertReductionTables: Numerators and denominators occurring in the amplitude before inserting the redution tables and using PolyRatFun:
.sort
b lsclNum,lsclDen;
print[];
.sort
#endif

* Factorize the coefficients before inserting reduction tables
#message lsclInsertReductionTables: Calling PolyRatFun : `time_' ...
.sort
PolyRatFun lsclRat;
id lsclNum(lsclS?) = lsclRat(lsclS,1);
id lsclDen(lsclS?) = lsclRat(1,lsclS);

.sort
PolyRatFun;
#message lsclInsertReductionTables: ... done.

#if (`LSCLVERBOSITY'>0)
#message lsclInsertReductionTables: Numerators and denominators occurring in the amplitude before inserting the redution tables but after PolyRatFun:
b lsclNum,lsclDen,lsclRat;
print[];
.sort
#endif

#else
#message lsclInsertReductionTables: Running with disabled polyratfun and factarg
#endif
*********************************************************************

#message lsclInsertReductionTables: Structure of the amplitude:

b,
#do i=1, `LSCLNTOPOLOGIES'
`LSCLTOPOLOGY`i'',
#enddo
;
print[];
.sort

#ifdef `LSCLONLYSHOWSTRUCTURE'
.end
#endif

#message lsclInsertReductionTables: Isolating prefactors of loop integrals:

Collect lsclWrapFun1000, lsclWrapFun1001;
argtoextrasymbol lsclWrapFun1000, lsclWrapFun1001;

#message lsclInsertReductionTables: Inserting reduction tables : `time_' ...


#do i=1, `LSCLNTOPOLOGIES'
#$topoPresent`i'=0;
if(occurs(`LSCLTOPOLOGY`i'')) $topoPresent`i'=1;
#enddo 
moduleoption notinparallel;
.sort


#do i=1, `LSCLNTOPOLOGIES'
#do j=1,$topoPresent`i'
#message lsclInsertReductionTables: Loading reduction tables for the topology `LSCLTOPOLOGY`i''
TableBase "Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Reductions/`LSCLTOPOLOGY`i''/`LSCLTBLFILENAME'" open;
TableBase "Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Reductions/`LSCLTOPOLOGY`i''/`LSCLTBLFILENAME'" enter;
.sort

#message lsclInsertReductionTables: Starting with integrals containing high powers of numerators
#do k=1,5
#message lsclInsertReductionTables: Negative power {-(5+1-`k')}
id ifmatch->integralInserted1 `LSCLTOPOLOGY`i''(?a,{-(5+1-`k')},?b) = tabIBP`LSCLTOPOLOGY`i''(?a,{-(5+1-`k')},?b);
label integralInserted1;
TestUse tabIBP`LSCLTOPOLOGY`i'';
#message lsclInsertReductionTables: Calling sort : `time_' ...
.sort
On shortstats;
#message lsclInsertReductionTables: ... done.
Apply;
#message lsclInsertReductionTables: Calling sort : `time_' ...
.sort
On shortstats;
#message lsclInsertReductionTables: ... done.
#enddo

#message lsclInsertReductionTables: Handling the remaining integrals

id ifmatch->integralInserted2 `LSCLTOPOLOGY`i''(?a) = tabIBP`LSCLTOPOLOGY`i''(?a);
label integralInserted2;
TestUse tabIBP`LSCLTOPOLOGY`i'';
#message lsclInsertReductionTables: Calling sort : `time_' ...
.sort
On shortstats;
#message lsclInsertReductionTables: ... done.
Apply;
#message lsclInsertReductionTables: Calling sort : `time_' ...
.sort
On shortstats;
#message lsclInsertReductionTables: ... done.

#enddo
#enddo


*#message lsclInsertReductionTables: Inserting mappings between master integrals : `time_' ...
*#include Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/LoopIntegrals/MasterIntegralMappings.frm #lsclMasterIntegralMappings
*#message lsclInsertReductionTables: ... done.

#message lsclInsertReductionTables: Calling sort : `time_' ...
.sort
On shortstats;
#message lsclInsertReductionTables: ... done.

#message lsclInsertReductionTables: Checking if all integrals were reduced : `time_' ...
if(occurs(
lsclS,
#do i=1, `LSCLNTOPOLOGIES'
#do j=1,$topoPresent`i'
tabIBP`LSCLTOPOLOGY`i'',
#enddo
#enddo
));
print "lsclInsertReductionTables: Warning: Possibly some loop integrals were not reduced, e.g.: %t";
endif;

if(occurs(
lsclS,
#do i=1, `LSCLNTOPOLOGIES'
#do j=1,$topoPresent`i'
tabIBP`LSCLTOPOLOGY`i'',
#enddo
#enddo
)) exit;

#do i=1, `LSCLNTOPOLOGIES'
#do j=1,$topoPresent`i'
id tabIBP`LSCLTOPOLOGY`i''(?a) = `LSCLTOPOLOGY`i''(?a);
#enddo
#enddo
#message lsclInsertReductionTables: ... done.


#message lsclInsertReductionTables: Calling sort : `time_' ...
.sort
#message lsclInsertReductionTables: ... done.

#message lsclInsertReductionTables: Inserting mappings between master integrals : `time_' ...
*#include Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/LoopIntegrals/MasterIntegralMappings2.frm #lsclMasterIntegralMappings
#do i=1, `LSCLNTOPOLOGIES'
#do j=1,$topoPresent`i'
#message Loading mappings for the topology `LSCLTOPOLOGY`i''
repeat;
#include Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Reductions/`LSCLTOPOLOGY`i''/MasterIntegralMappings.frm #lsclMasterIntegralMappings
endrepeat;
.sort
#enddo
#enddo
#message lsclInsertReductionTables: ... done.


#message lsclInsertReductionTables: Calling sort : `time_' ...
.sort
#message lsclInsertReductionTables: ... done.


#message lsclInsertReductionTables: Structure of the amplitude :
b, 
#if (`LSCLVERBOSITY'>0)
lsclNum,lsclDen,
#endif
#do i=1, `LSCLNTOPOLOGIES'
`LSCLTOPOLOGY`i'',
#enddo
;
print[];

#message lsclInsertReductionTables: Calling sort : `time_' ...
.sort
#message lsclInsertReductionTables: ... done.


#message lsclInsertReductionTables: Unisolating prefactors of loop integrals:

id lsclWrapFun1000(lsclS?) = lsclS;
id lsclWrapFun1001(lsclS?) = lsclS;
FromPolynomial;

#message lsclInsertReductionTables: Calling sort : `time_' ...
.sort
#message lsclInsertReductionTables: ... done.

*********************************************************************
#ifndef `LSCLEPEXPAND'
#message lsclInsertReductionTables: Factorizing the expression ...
factarg lsclNum,lsclDen;
chainout lsclNum;
chainout lsclDen;
#message lsclInsertReductionTables: Calling sort : `time_' ...
.sort
#message lsclInsertReductionTables: done.

id lsclNum(lsclS?) = lsclRat(lsclS,1);
id lsclDen(lsclS?) = lsclRat(1,lsclS);
.sort
PolyRatFun;
* https://github.com/vermaseren/form/issues/398

repeat id lsclRat(lsclS1?,lsclS2?) = lsclNum(lsclS1)*lsclDen(lsclS2);

factarg lsclNum;
factarg lsclDen;
chainout lsclNum;
chainout lsclDen;

repeat id lsclNum(lsclS?number_) = lsclS;
repeat id lsclDen(lsclS?number_) = 1/lsclS;
repeat id lsclNum(1/lsclS?) = lsclDen(lsclS);
repeat id lsclNum(lsclS?)*lsclDen(lsclS?) = 1;

#message lsclInsertReductionTables: ... done factorizing the expression.

#message lsclInsertReductionTables: Calling sort : `time_' ...
.sort
#message lsclInsertReductionTables: ... done.


#else
#message lsclInsertReductionTables: Skipping the factorization at this stage
#endif
*******************************************************************


#message lsclInsertReductionTables: Calling the ProcessReducedAmplitude fold : `time_' ...
#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclProcessReducedAmplitude
#message lsclInsertReductionTables: ... done.

* #call lsclToFeynCalc(s2dia`lsclDiaNumber'L`lsclNLoops',Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Results/ampL`lsclNLoops'From`lsclDiaNumber'To`lsclDiaNumber'.m)

.sort

#message delete storage
delete storage;
.sort


.store

save Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Stage2/stage2_dia`lsclDiaNumber'L`lsclNLoops'.res;

.sort
#message lsclInsertReductionTables: Insertion of reduction tables completed successfully.

.end
