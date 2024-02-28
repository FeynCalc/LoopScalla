off statistics;
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

#message lsclInsertReductionTables: Inserting reduction tables : `time_' ...


#do i=1, `LSCLNTOPOLOGIES'
#$topoPresent`i'=0;
if(occurs(`LSCLTOPOLOGY`i'')) $topoPresent`i'=1;
#enddo 
moduleoption notinparallel;
.sort


#do i=1, `LSCLNTOPOLOGIES'
#do j=1,$topoPresent`i'
#message Loading reduction tables for the topology `LSCLTOPOLOGY`i''
TableBase "Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Reductions/`LSCLTOPOLOGY`i''/tablebase.tbl" open;
TableBase "Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Reductions/`LSCLTOPOLOGY`i''/tablebase.tbl" enter;
.sort
id `LSCLTOPOLOGY`i''(?a) = tabIBP`LSCLTOPOLOGY`i''(?a);
TestUse tabIBP`LSCLTOPOLOGY`i'';
.sort
Apply;
.sort
#enddo
#enddo


#message lsclInsertReductionTables: ... done.


if(occurs(
lsclS,
#do i=1, `LSCLNTOPOLOGIES'
#do j=1,$topoPresent`i'
tabIBP`LSCLTOPOLOGY`i'',
#enddo
#enddo
));
print "lsclInsertReductionTables: Error: Some loop integrals were not reduced, e.g.: %t";
endif;

*if(occurs(
*lsclS,
*#do i=1, `LSCLNTOPOLOGIES'
*#do j=1,$topoPresent`i'
*tabIBP`LSCLTOPOLOGY`i'',
*#enddo
*#enddo
*)) exit;

#do i=1, `LSCLNTOPOLOGIES'
#do j=1,$topoPresent`i'
id tabIBP`LSCLTOPOLOGY`i''(?a) = `LSCLTOPOLOGY`i''(?a);
#enddo
#enddo

*********************************************************************
#if (`LSCLNOFACTORIZATION'!=1)
factarg lsclNum,lsclDen;
chainout lsclNum;
chainout lsclDen;
.sort

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
#else
#message lsclInsertReductionTables: Running with disabled polyratfun and factarg
#endif
*********************************************************************
* #message HERE
.sort
b, lsclNum,lsclDen,
#do i=1, `LSCLNTOPOLOGIES'
`LSCLTOPOLOGY`i'',
#enddo
;
print[];


.sort
#message delete storage
delete storage;
.sort


.store

save Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Stage2/stage2_dia`lsclDiaNumber'L`lsclNLoops'.res;

.sort
#message lsclInsertReductionTables: Insertion of reduction tables completed successfully.

.end
