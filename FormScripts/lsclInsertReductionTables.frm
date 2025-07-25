* This file is a part of LoopScalla, a framework for loop calculations
* LoopScalla is covered by the GNU General Public License 3.
* Copyright (C) 2019-2025 Vladyslav Shtabovenko

on shortstats;
on HighFirst;
on fewerstatistics 0;
#include lsclDeclarations.h
#include lsclDefinitions.h
#include Projects/`lsclProjectName'/FeynmanRules/lsclParticles_`lsclModelName'.h

#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclGeneric


#ifndef `LSCLREDUCEINTSATONCE'
#define LSCLREDUCEINTSATONCE "10"
#endif

#ifndef `LSCLSTARTWITHINTEGRALNO'
#define LSCLSTARTWITHINTEGRALNO "0"
#endif

#message lsclInsertReductionTables: Project: `lsclProjectName'
#message lsclInsertReductionTables: Process: `lsclProcessName'
#message lsclInsertReductionTables: Model: `lsclModelName'
#message lsclInsertReductionTables: Processing diagram `lsclDiaNumber' at `lsclNLoops' loop(s)

#ifdef `LSCLREDUCESINGLEINTEGRAL'
#message lsclInsertReductionTables: Integral number: `lsclIntegralNumber'
#endif

#include Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/TopologyList.frm

#ifdef `LSCLEPEXPAND'
    #message lsclInsertReductionTables: Using reduction tables expanded in ep
    #ifndef `LSCLEPEXPANDORDER'
        #message lsclInsertReductionTables: Using the default expansion in ep
        #define LSCLTBLFILENAME "tablebaseExpanded.tbl"
    
    #else
        #message lsclInsertReductionTables: Using the tables expanded up to `LSCLEPEXPANDORDER'
        #define LSCLTBLFILENAME "tablebaseExpanded`LSCLEPEXPANDORDER'.tbl"
    #endif
#else
    #message lsclInsertReductionTables: Using ep-exact reduction tables
    #define LSCLTBLFILENAME "tablebase.tbl"
#endif




CF
#do i=1, `LSCLNTOPOLOGIES'
`LSCLTOPOLOGY`i'',
#enddo 
;


#ifdef `LSCLREDUCESINGLEINTEGRAL'
#system mkdir -p Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/SplitStage2/`lsclDiaNumber'
Load Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/SplitStage1/`lsclDiaNumber'/stage1_dia`lsclDiaNumber'L`lsclNLoops'_p`lsclIntegralNumber'.res;
G s2dia`lsclDiaNumber'L`lsclNLoops'I`lsclIntegralNumber' = s1diaS;
#else
Load Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Stage1/stage1_dia`lsclDiaNumber'L`lsclNLoops'.res;
G s2dia`lsclDiaNumber'L`lsclNLoops' = s1dia`lsclDiaNumber'L`lsclNLoops';
#endif



#message lsclInsertReductionTables: Calling the SimplifyAmplitudeBeforeReduction fold : `time_' ...
#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclSimplifyAmplitudeBeforeReduction
#message lsclInsertReductionTables: ... done.

.sort


* Collect the amplitude w.r.t. the loop integrals
* The output might be too large for a log file ...

b,
d_,
#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclAdditionalBracketArguments
#do i=1, `LSCLNTOPOLOGIES'
`LSCLTOPOLOGY`i'',
#enddo
;
#ifdef `LSCLONLYSHOWSTRUCTURE'
#message lsclInsertReductionTables: Structure of this amplitude
print[];
.end
#else
.sort
#endif
* Before inserting the reduction tables it is a good idea to simplify the coefficients
* multiplying loop integrals





#message lsclInsertReductionTables: Applying lsclApplyPolyRatFun and lsclNumDenFactorize: `time_' ...
collect lsclWrapFun1,lsclWrapFun2;
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

#message lsclInsertReductionTables: ... done.

#message lsclInsertReductionTables: Calling sort : `time_' ...
.sort
#message lsclInsertReductionTables: ... done: `time_'

* Here we insert the reduction tables and do additional simplifications!
#message lsclInsertReductionTables: Calling the IsolateLoopIntegralPrefactors fold : `time_' ...
#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclIsolateLoopIntegralPrefactors
#message lsclInsertReductionTables: ... done.

#message lsclInsertReductionTables: Calling the ProcessReducedAmplitude fold : `time_' ...
#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclProcessReducedAmplitude
#message lsclInsertReductionTables: ... done.

#message lsclInsertReductionTables: Calling sort : `time_' ...
.sort
#message lsclInsertReductionTables: ... done: `time_'

* If the factorization has already been applied in the past, it's a must to collect w.r.t
* lsclNum and lsclDen. Otherwise we'll end up with a workspace overflow.
#message lsclInsertReductionTables: Applying lsclApplyPolyRatFun and lsclNumDenFactorize: `time_' ...
b,
#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclAdditionalBracketArguments
,
lsclSkipNum,lsclSkipDen, d_,
lsclWrapFun,lsclEp,lsclNum,lsclDen,
#do i=1, `LSCLNTOPOLOGIES'
`LSCLTOPOLOGY`i'',
#enddo

;

#message lsclInsertReductionTables: Calling sort : `time_' ...
.sort
#message lsclInsertReductionTables: ... done: `time_'

collect lsclWrapFun1,lsclWrapFun2;

#call lsclApplyPolyRatFun(lsclNum,lsclDen,lsclRat,lsclWrapFun1,lsclWrapFun2);

#message lsclInsertReductionTables: Calling sort : `time_' ...
.sort
#message lsclInsertReductionTables: ... done: `time_'

#call lsclNumDenFactorize(lsclNum,lsclDen,lsclRat,`lsclDenNumFactorizeArguments');

#message lsclInsertReductionTables: Calling sort : `time_' ...
.sort
#message lsclInsertReductionTables: ... done: `time_'



b,
#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclAdditionalBracketArguments
lsclEp,lsclWrapFun,
#do i=1, `LSCLNTOPOLOGIES'
`LSCLTOPOLOGY`i'',
#enddo
;
print[];
.sort


#ifdef `lsclPprExportToMathematica'
#call lsclToFeynCalc(s2dia`lsclDiaNumber'L`lsclNLoops',Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Results/ampL`lsclNLoops'From`lsclDiaNumber'To`lsclDiaNumber'`lsclPprExportToMathematicaSuffix'.m)
#endif
.sort
#message lsclInsertReductionTables: ... done : `time_'


delete storage;
.sort
.store

#ifdef `LSCLREDUCESINGLEINTEGRAL'
save Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/SplitStage2/`lsclDiaNumber'/stage2_dia`lsclDiaNumber'L`lsclNLoops'_p`lsclIntegralNumber'.res;
#else
save Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Stage2/stage2_dia`lsclDiaNumber'L`lsclNLoops'.res;
#endif

.sort
#message lsclInsertReductionTables: Insertion of reduction tables completed successfully.

.end

