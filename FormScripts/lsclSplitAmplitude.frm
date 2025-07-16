on shortstats;
on HighFirst;
on fewerstatistics 0;
#include lsclDeclarations.h
#include lsclDefinitions.h
#include Projects/`lsclProjectName'/FeynmanRules/lsclParticles_`lsclModelName'.h

#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclGeneric


#ifndef `LSCLSTARTWITHINTEGRALNO'
#define LSCLSTARTWITHINTEGRALNO "1"
#endif

#message lsclSplitAmplitude: `lsclProjectName'
#message lsclSplitAmplitude: `lsclProcessName'
#message lsclSplitAmplitude: `lsclNLoops'
#message lsclSplitAmplitude: `lsclDiaNumber'


#include Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/TopologyList.frm


CF
#do i=1, `LSCLNTOPOLOGIES'
`LSCLTOPOLOGY`i'',
#enddo 
;


Load Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Stage1/stage1_dia`lsclDiaNumber'L`lsclNLoops'.res;

G s2dia`lsclDiaNumber'L`lsclNLoops' = s1dia`lsclDiaNumber'L`lsclNLoops';



#message lsclSplitAmplitude: Calling the SimplifyAmplitudeBeforeReduction fold : `time_' ...
#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclSimplifyAmplitudeBeforeReduction
#message lsclSplitAmplitude: ... done.

.sort


* Collect the amplitude w.r.t. the loop integrals
* The output might be too large for a log file ...

b,
#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclAdditionalBracketArguments
#do i=1, `LSCLNTOPOLOGIES'
`LSCLTOPOLOGY`i'',
#enddo
;
#ifdef `LSCLONLYSHOWSTRUCTURE'
#message lsclSplitAmplitude: Structure of this amplitude
print[];
.end
#else
.sort
#endif
* Before inserting the reduction tables it is a good idea to simplify the coefficients
* multiplying loop integrals
collect lsclWrapFun1,lsclWrapFun2;
#call lsclApplyPolyRatFun(lsclNum,lsclDen,lsclRat,lsclWrapFun1,lsclWrapFun2);
.sort
#call lsclNumDenFactorize(lsclNum,lsclDen,lsclRat,`lsclDenNumFactorizeArguments');
.sort


#message
#message lsclSplitAmplitude: Enumerating the occurring loop integrals: `time_' ...

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
#message lsclProcessReducedAmplitude: ... done : `time_'
#message

#$allIntCounter=0;
#do i=1, `LSCLNTOPOLOGIES'
#do j=1,$topoPresent`i'
#message lsclSplitAmplitude: Number of loop integrals for `LSCLTOPOLOGY`i'': `$topoIntegralCounter`i''
$allIntCounter=$allIntCounter+1;
#enddo 
#enddo 
moduleoption notinparallel;
.sort

* #message lsclSplitAmplitude: Total number of loop integrals `$allIntCounter'

* #message lsclSplitAmplitude: Creating directories for the topologies

* #do i=1, `LSCLNTOPOLOGIES'
*    #do j=1,$topoPresent`i'
*        #message Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/SplitStage1/`lsclDiaNumber'/`LSCLTOPOLOGY`i''
*        #external mkdir -p Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/SplitStage1/`lsclDiaNumber'/`LSCLTOPOLOGY`i''
*    #enddo
* #enddo

* using https://github.com/vermaseren/form/issues/550
off statistics;
.sort
.global
G tmp = s2dia`lsclDiaNumber'L`lsclNLoops';
id lsclIntegralNumber(?a) = 1;
.sort

#define i "0"
#do t=tmp
#redefine i "{`i'+1}"
#if ({`i'%500} == 0)
    #message lsclSplitAmplitude: Saving integral `i'
#endif
G s1diaS = `t';
.store
save Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/SplitStage1/`lsclDiaNumber'/stage1_dia`lsclDiaNumber'L`lsclNLoops'_p`i'.res s1diaS;
delete storage;
.sort
#enddo


.end

*off statistics;
*.sort
* id lsclIntegralNumber(lsclS1?,lsclS2?{,1,...,4380}) = 0;
*.global
*#do i=1, `LSCLNTOPOLOGIES'
*    #do j=1,$topoPresent`i'
*        #do k=`LSCLSTARTWITHINTEGRALNO',$topoIntegralCounter`i'
*            #message s1dia`lsclDiaNumber'L`lsclNLoops'T`LSCLTOPOLOGY`i''I`k'
*            G s1dia`lsclDiaNumber'L`lsclNLoops'T`LSCLTOPOLOGY`i''I`k' = s2dia`lsclDiaNumber'L`lsclNLoops';
*            #if ({`k'%1000} == 0)
*            #message k is `k'
*            .sort
*            #endif
*        #enddo
*    #enddo
*#enddo

*#message lsclSplitAmplitude: Calling sort and hide;
*.sort
*hide;
*.sort

* #message lsclSplitAmplitude: Cleaning up the expressions
#message lsclSplitAmplitude: Defining global expressions;
#do i=1, `LSCLNTOPOLOGIES'
    #do j=1,$topoPresent`i'
        #do k=`LSCLSTARTWITHINTEGRALNO',$topoIntegralCounter`i'
            #message Defining s1dia`lsclDiaNumber'L`lsclNLoops'T`LSCLTOPOLOGY`i''I`k'
            G s1dia`lsclDiaNumber'L`lsclNLoops'T`LSCLTOPOLOGY`i''I`k' = s2dia`lsclDiaNumber'L`lsclNLoops';
 .sort
            hide s2dia`lsclDiaNumber'L`lsclNLoops';
*            .sort
*            unhide s1dia`lsclDiaNumber'L`lsclNLoops'T`LSCLTOPOLOGY`i''I`k';
            
            id lsclIntegralNumber(lsclS1?!{,`LSCLTOPOLOGY`i''},lsclS2?!{,`k'}) = 0;
            id lsclIntegralNumber(?a) = 1;            
            .sort
            hide s1dia`lsclDiaNumber'L`lsclNLoops'T`LSCLTOPOLOGY`i''I`k';
            unhide s2dia`lsclDiaNumber'L`lsclNLoops';
            .sort
        #enddo
    #enddo
#enddo

#message lsclSplitAmplitude: Applying unhide

#do i=1, `LSCLNTOPOLOGIES'
    #do j=1,$topoPresent`i'
        #do k=`LSCLSTARTWITHINTEGRALNO',$topoIntegralCounter`i'
            unhide s1dia`lsclDiaNumber'L`lsclNLoops'T`LSCLTOPOLOGY`i''I`k';            
        #enddo
    #enddo
#enddo

.sort

#do i=1, `LSCLNTOPOLOGIES'
    #do j=1,$topoPresent`i'
        #do k=`LSCLSTARTWITHINTEGRALNO',$topoIntegralCounter`i'
            #message lsclSplitAmplitude: Putting s1dia`lsclDiaNumber'L`lsclNLoops'T`LSCLTOPOLOGY`i''I`k'  into a dollar variable
            #$ds1dia`lsclDiaNumber'L`lsclNLoops'T`LSCLTOPOLOGY`i''I`k' = s1dia`lsclDiaNumber'L`lsclNLoops'T`LSCLTOPOLOGY`i''I`k';
        #enddo
        .sort
    #enddo
#enddo

.sort

#do i=1, `LSCLNTOPOLOGIES'
    #do j=1,$topoPresent`i'
        #do k=`LSCLSTARTWITHINTEGRALNO',$topoIntegralCounter`i'
                            
            #message lsclSplitAmplitude: Saving expression s1dia`lsclDiaNumber'L`lsclNLoops'T`LSCLTOPOLOGY`i''I`k'                        
            G s1diaS = $ds1dia`lsclDiaNumber'L`lsclNLoops'T`LSCLTOPOLOGY`i''I`k';
            .store
            save Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/SplitStage1/`lsclDiaNumber'/`LSCLTOPOLOGY`i''/stage1_dia`lsclDiaNumber'L`lsclNLoops'T`LSCLTOPOLOGY`i''I`k'.res s1diaS;
            delete storage;
            .sort            
        #enddo
    #enddo
#enddo

.end
