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

#message lsclInsertReductionTables: lsclProjectName: `lsclProjectName'
#message lsclInsertReductionTables: lsclProcessName: `lsclProcessName'
#message lsclInsertReductionTables: lsclNLoops: `lsclNLoops'
#message lsclInsertReductionTables: lsclDiaNumber: `lsclDiaNumber'
#ifdef `LSCLREDUCESINGLEINTEGRAL'
#message lsclInsertReductionTables: lsclIntegralNumber: `lsclIntegralNumber'
#endif

#include Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/TopologyList.frm

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
#external mkdir Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/SplitStage2/`lsclDiaNumber'
Load Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/SplitStage1/`lsclDiaNumber'/stage1_dia`lsclDiaNumber'L`lsclNLoops'_p`lsclIntegralNumber'.res;
G s2dia`lsclDiaNumber'L`lsclNLoops'I`lsclIntegralNumber' = s1diaS;
#else
Load Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Stage1/stage1_dia`lsclDiaNumber'L`lsclNLoops'.res;
G s2dia`lsclDiaNumber'L`lsclNLoops' = s1dia`lsclDiaNumber'L`lsclNLoops';
#endif



#message lsclInsertReductionTables: Calling the SimplifyAmplitudeBeforeReduction fold : `time_' ...
#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclSimplifyAmplitudeBeforeReduction
#message lsclInsertReductionTables: ... done.

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
#message lsclInsertReductionTables: Structure of this amplitude
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

print;
.sort

*b,
*#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclAdditionalBracketArguments
*#do i=1, `LSCLNTOPOLOGIES'
*`LSCLTOPOLOGY`i'',
*#enddo
*;
*print;
*.sort
*#call lsclToFeynCalc(s2dia`lsclDiaNumber'L`lsclNLoops',Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Results/ampL`lsclNLoops'From`lsclDiaNumber'To`lsclDiaNumber'.m)

         
#message lsclInsertReductionTables: ... done.

#message lsclProcessReducedAmplitude: Preparing to isolate terms unrelated to the ep-expansion : `time_' ...

repeat id lsclDen(lsclS?) = lsclWrapFun50(lsclWrapFun100(lsclS));
repeat id lsclNum(lsclS?) = lsclWrapFun60(lsclWrapFun110(lsclS));
repeat id lsclRat(lsclS1?,lsclS2?) = lsclWrapFun70(lsclWrapFun120(lsclS1,lsclS2));


argument lsclWrapFun50;
if (occurs(lsclD,lsclEp)) multiply lsclFlag999;
endargument;

argument lsclWrapFun60;
if (occurs(lsclD,lsclEp)) multiply lsclFlag999;
endargument;

argument lsclWrapFun70;
if (occurs(lsclD,lsclEp)) multiply lsclFlag999;
endargument;

repeat id lsclWrapFun50(lsclFlag999*lsclWrapFun100(lsclS?)) = lsclDen(lsclS);
repeat id lsclWrapFun60(lsclFlag999*lsclWrapFun110(lsclS?)) = lsclNum(lsclS);
repeat id lsclWrapFun70(lsclFlag999*lsclWrapFun120(lsclS1?,lsclS2?)) = lsclRat(lsclS1,lsclS2);

repeat id lsclWrapFun50(lsclWrapFun100(lsclS?)) = lsclHoldDen(lsclS);
repeat id lsclWrapFun60(lsclWrapFun110(lsclS?)) = lsclHoldNum(lsclS);
repeat id lsclWrapFun70(lsclWrapFun120(lsclS1?,lsclS2?)) = lsclHoldRat(lsclS1,lsclS2);

#message lsclProcessReducedAmplitude: ... done : `time_'

.sort

on shortstats;
#message lsclInsertReductionTables: Isolating prefactors of loop integrals:

argument lsclDen;
if (occurs(lsclEp,lsclD)) exit "The amplitude contains D-dependent-pieces inside lsclDen.";
endargument;

argument lsclNum;
if (occurs(lsclEp,lsclD)) exit "The amplitude contains D-dependent-pieces inside lsclNum.";
endargument;

b,
lsclD,lsclEp,lsclDen,lsclNum,lsclRat
#do i=1, `LSCLNTOPOLOGIES'
`LSCLTOPOLOGY`i'',
#enddo
;
*print[];
.sort

Collect lsclIsoFun0, lsclIsoFun1;
argtoextrasymbol lsclIsoFun0, lsclIsoFun1;

.sort

#message
#message lsclInsertReductionTables: Enumerating the occurring loop integrals: `time_' ...

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

#do i=1, `LSCLNTOPOLOGIES'
#do j=1,$topoPresent`i'
#message lsclInsertReductionTables: Number of loop integrals for `LSCLTOPOLOGY`i'': `$topoIntegralCounter`i''
#enddo 
#enddo 


.sort


#do i=1, `LSCLNTOPOLOGIES'
#do j=1,$topoPresent`i'
id `LSCLTOPOLOGY`i''(?a) = lsclIntegral(`LSCLTOPOLOGY`i''(?a));
#enddo
#enddo


* id lsclIntegralNumber(lsclS1?,lsclS2?{,1,...,4380}) = 0;

.sort

* L testexp =  lsclIntegralNumber(5739,184)*lsclIntegral(topology5739(1,1,1,1,1,1,1,1,1,-1,0,0));

* print;
* .sort

*.sort
* b,
* lsclD,lsclEp,lsclDen,lsclNum,lsclRat,lsclIntegralNumber,lsclIntegral
* #do i=1, `LSCLNTOPOLOGIES'
* `LSCLTOPOLOGY`i'',
* #enddo
* ;
* print[];
* .sort

*.end

*******************************************************************************

#do i=1, `LSCLNTOPOLOGIES'
    #do j=1,$topoPresent`i'
        
        #message
        #message lsclInsertReductionTables: Loading reduction tables for the topology `LSCLTOPOLOGY`i''

        #pipe echo "#define LSCLTABLEPRESENT \"$((ls Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Reductions/`LSCLTOPOLOGY`i''/`LSCLTBLFILENAME' >> /dev/null 2>&1 && echo yes) || echo no)\""

        #if (`LSCLTABLEPRESENT'!="yes")        
        #message "lsclInsertReductionTables: Error, table `LSCLTBLFILENAME' for `LSCLTOPOLOGY`i'' is missing."
        #terminate
        #endif

        TableBase "Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Reductions/`LSCLTOPOLOGY`i''/`LSCLTBLFILENAME'" open;
        TableBase "Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Reductions/`LSCLTOPOLOGY`i''/`LSCLTBLFILENAME'" enter;
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
            #message lsclProcessReducedAmplitude: Preparing to isolate terms unrelated to the ep-expansion : `time_' ...

            argument;
            if (occurs(lsclEp,lsclD)) exit "The amplitude contains D-dependent-pieces inside function arguments after inserting the reduction rules.";
            endargument;

            repeat id lsclD = 4 - 2*lsclEp;
            
            #if (`lsclNLoops' > 0);
            if (occurs(lsclD));
            print "lsclInsertReductionTables: Error, some D->4-2ep substitutions did not take place, e.g.: %t";
            endif;
            #endif
          
            #message
            #message lsclInsertReductionTables: Loading mappings for `LSCLTOPOLOGY`i'' and calling sort : `time_' ...
            repeat;
            #include Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Reductions/`LSCLTOPOLOGY`i''/MasterIntegralMappings.frm #lsclMasterIntegralMappings
            endrepeat;
            .sort: Mappings;
            #message lsclInsertReductionTables: ... done.


            #message
            #message lsclProcessReducedAmplitude: Calling sort : `time_' ...                                    
            .sort: Eliminate D check;
            #message lsclProcessReducedAmplitude: ... done.


            #message
            #message lsclProcessReducedAmplitude: Isolating terms unrelated to the ep-expansion : `time_' ...
            b lsclEp, lsclIntegralNumber, lsclWrapFun, lsclIntegral, lsclEpHelpFlag, lsclIsolateFlag,
*           This is needed since the masters for the reduced integrals are not wrapped into lsclIntegral anymore!            
            #if (`lsclNLoops' > 0)
            #do i=1, `LSCLNTOPOLOGIES'
            `LSCLTOPOLOGY`i'',
            #enddo
            #endif
            ;
            
            .sort: Isolate ;
            Collect lsclIsoFun`i'0000{2*`k'}, lsclIsoFun`i'0000{2*`k'+1};
            argtoextrasymbol lsclIsoFun`i'0000{2*`k'}, lsclIsoFun`i'0000{2*`k'+1};
            .sort: Isolate 2;



            #message lsclProcessReducedAmplitude: ... done.
*            print;
            #message
            #message lsclProcessReducedAmplitude: Inserting formulas for the leading poles : `time_' ...
            #if `lsclNLoops' == 0
*               Do nothing
            #elseif `lsclNLoops' == 1

                #include Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/MasterIntegrals/leadingPoles1L.frm

            #elseif `lsclNLoops' == 2
                #include Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/MasterIntegrals/leadingPoles2L.frm

            #elseif `lsclNLoops' == 3
                #include Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/MasterIntegrals/leadingPoles3L.frm

            #else
                #message lsclProcessReducedAmplitude: Unsupported number of loops!
                exit;
            #endif

            .sort: Poles;   
            
            #message lsclProcessReducedAmplitude: ... done.
          

            #message
            #message lsclProcessReducedAmplitude: Checking if all integrals were replaced by the contributing poles : `time_' ...

*           Any term containing lsclIntegralNumber will also contain unreduced integrals.
*           If lsclIntegralNumber is absent, then by definition there must be  lsclWrapFun
            if((occurs(lsclWrapFun)==0) && (occurs(lsclIntegralNumber,lsclIsolateFlag)==0));
            print "lsclProcessReducedAmplitude: Warning: Pole formulas for some integrals were not inserted, e.g.: %t";
            endif;
            if((occurs(lsclWrapFun)==0) && (occurs(lsclIntegralNumber,lsclIsolateFlag)==0)) exit;

            .sort: Pole check;
            #message lsclProcessReducedAmplitude: ... done.

            argument;
            if (occurs(lsclEp,lsclD)) exit "The amplitude contains D-dependent-pieces inside function arguments after inserting the reduction rules.";
            endargument;


            #if (`lsclNLoops' > 0);
            if (occurs(lsclD));
            print "lsclInsertReductionTables: Error, some D->4-2ep substitutions did not take place, e.g.: %t";
            endif;
            #endif

            .sort: Leading ep-power 3;

            #message lsclProcessReducedAmplitude: ... done.

            #if `lsclNLoops' == 0
*           Do nothing
            #elseif `lsclNLoops' == 1
*           Any term containing lower order ep-poles and no lsclIntegralNumber or lsclIsolateFlag variables gets dropped
            if ((count(lsclEp,1)>-2) && (occurs(lsclIntegralNumber,lsclIsolateFlag)==0)) discard;
            #elseif `lsclNLoops' == 2
            if ((count(lsclEp,1)>-4) && (occurs(lsclIntegralNumber,lsclIsolateFlag)==0)) discard;
            #elseif `lsclNLoops' == 3
            if ((count(lsclEp,1)>-6) && (occurs(lsclIntegralNumber,lsclIsolateFlag)==0)) discard;
            #else
            #message Unsupported number of loops!
            exit;
            #endif

*            .sort
*            *print;
*            .sort

            if (occurs(lsclEpHelpFlag));
            print "lsclInsertReductionTables: Error, missing some contributions to the ep-expansion, e.g.: %t";
            endif;

            .sort: Leading ep-power 4;

            if (occurs(lsclEpHelpFlag)) exit;

            #message
            #message lsclInsertReductionTables: Missing ep-orders check passed: `time_' ...
            
            #message
            #message lsclInsertReductionTables: Isolating already expanded integrals: `time_' ...
            #message

*           Every term free of lsclIntegral is multiplied by lsclIsolateFlag            
            if (occurs(lsclIntegral)==0) multiply lsclIsolateFlag;

           .sort: Isolate expanded 1;
            b lsclIsolateFlag;           
            .sort: Isolate expanded 2;


            Collect lsclIsoFun00`i'0000{2*`k'}, lsclIsoFun00`i'0000{2*`k'+1};
            if (count(lsclIsolateFlag,1)==0);
            repeat id lsclIsoFun00`i'0000{2*`k'}(lsclS?) = lsclS;
            repeat id lsclIsoFun00`i'0000{2*`k'+1}(lsclS?) = lsclS;
            endif;
            
            argtoextrasymbol lsclIsoFun00`i'0000{2*`k'}, lsclIsoFun00`i'0000{2*`k'+1};

            .sort: Final;
            
        #enddo
    #enddo
#enddo

*******************************************************************************


#if (`LSCLSTARTWITHINTEGRALNO'==0)
    if(occurs(lsclIntegralNumber,lsclIntegral));
    print "lsclInsertReductionTables: Warning: Some integrals were not reduced, e.g.: %t";
    endif;
    if(occurs(lsclIntegralNumber,lsclIntegral)) exit;
    .sort
#endif

#message lsclInsertReductionTables: Unisolating remaining expressions : `time_' ...

#do i=`LSCLNTOPOLOGIES',1,-1
    #do j=1,$topoPresent`i'
    #do k={((`$topoIntegralCounter`i''/`LSCLREDUCEINTSATONCE')+1)*`LSCLREDUCEINTSATONCE'},`LSCLSTARTWITHINTEGRALNO',-`LSCLREDUCEINTSATONCE'
     #message lsclInsertReductionTables: Removing isolations introduced for lsclIsoFun00`i'0000{2*`k'}, lsclIsoFun00`i'0000{2*`k'+1}, lsclIsoFun`i'0000{2*`k'}, lsclIsoFun`i'0000{2*`k'+1}    
     repeat id lsclIsoFun00`i'0000{2*`k'}(lsclS?) = lsclS;
     repeat id lsclIsoFun00`i'0000{2*`k'+1}(lsclS?) = lsclS;
     repeat id lsclIsoFun`i'0000{2*`k'}(lsclS?) = lsclS;
     repeat id lsclIsoFun`i'0000{2*`k'+1}(lsclS?) = lsclS;
    FromPolynomial;
    .sort : FromPolyNomial 1;
     repeat id lsclIsoFun00`i'0000{2*`k'}(lsclS?) = lsclS;
     repeat id lsclIsoFun00`i'0000{2*`k'+1}(lsclS?) = lsclS;
     repeat id lsclIsoFun`i'0000{2*`k'}(lsclS?) = lsclS;
     repeat id lsclIsoFun`i'0000{2*`k'+1}(lsclS?) = lsclS;
    FromPolynomial;
    .sort : FromPolyNomial 2;
*    print;
    #enddo    
    #enddo
#enddo

repeat id lsclIsolateFlag^lsclS?!{,0} = 1;

if (occurs(lsclWrapFun)==0);
print "lsclInsertReductionTables: Error, missing some information about the ep-poles of the masters, e.g.: %t";
endif;

if (occurs(lsclWrapFun)==0);
exit;
endif;

.sort 
id lsclIsoFun0(lsclS?) = lsclS;
id lsclIsoFun1(lsclS?) = lsclS;
FromPolynomial;
id lsclHoldNum(lsclS?) = lsclNum(lsclS);
id lsclHoldDen(lsclS?) = lsclDen(lsclS);
.sort

*#call lsclToFeynCalc(s2dia`lsclDiaNumber'L`lsclNLoops',Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Results/ampL`lsclNLoops'From`lsclDiaNumber'To`lsclDiaNumber'XXX.m)
*.end

b,
#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclAdditionalBracketArguments
lsclWrapFun,lsclEp;
.sort
* Before inserting the reduction tables it is a good idea to simplify the coefficients
* multiplying loop integrals
collect lsclWrapFun1,lsclWrapFun2;
#call lsclApplyPolyRatFun(lsclNum,lsclDen,lsclRat,lsclWrapFun1,lsclWrapFun2);
.sort
#call lsclNumDenFactorize(lsclNum,lsclDen,lsclRat,`lsclDenNumFactorizeArguments');
.sort




b,
#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclAdditionalBracketArguments
lsclEp,lsclWrapFun;
print;
.sort

* 
#ifdef `lsclPprExportToMathematica'
#call lsclToFeynCalc(s2dia`lsclDiaNumber'L`lsclNLoops',Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Results/ampL`lsclNLoops'From`lsclDiaNumber'To`lsclDiaNumber'`lsclPprExportToMathematicaSuffix'.m)
#endif
.sort
#message lsclProcessReducedAmplitude: ... done : `time_'

#message delete storage
delete storage;
.sort



.store

#ifdef `LSCLREDUCESINGLEINTEGRAL'
save Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/SplitStage2/`lsclDiaNumber'/stage2_dia`lsclDiaNumber'L`lsclNLoops'_p`lsclIntegralNumber'.res;
#else
save Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Stage2/stage2_dia`lsclDiaNumber'L`lsclNLoops'.res;
#endif

.sort
#message lsclInsertReductionTables: Insertion of reduction tables completed successfully.

.end

