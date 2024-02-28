off statistics;
on HighFirst;


#message lsclAddUpDiagrams: `lsclProjectName'
#message lsclAddUpDiagrams: `lsclProcessName'
#message lsclAddUpDiagrams: `lsclNLoops'
#message lsclAddUpDiagrams: `lsclDiaNumberFrom'
#message lsclAddUpDiagrams: `lsclDiaNumberTo'


#if (`lsclNLoops' == 0)
	#message lsclAddUpDiagrams: Working with tree-level diagrams
	#do i = `lsclDiaNumberFrom', `lsclDiaNumberTo'
	Load Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Stage0/stage0_dia`i'L`lsclNLoops'.res;
	#enddo
#else

	#do i = `lsclDiaNumberFrom', `lsclDiaNumberTo'
	Load Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Stage2/stage2_dia`i'L`lsclNLoops'.res;
	#enddo
#endif

#message lsclAddUpDiagrams: All loaded `time_'

#do i = `lsclDiaNumberFrom', `lsclDiaNumberTo'
G ts2dia`i'L`lsclNLoops' = s2dia`i'L`lsclNLoops';
#enddo

#message lsclAddUpDiagrams: All defined `time_'

#message lsclAddUpDiagrams: Executing .sort and .store
.sort
.store

#message lsclAddUpDiagrams: .sort and .store done

#include lsclDeclarations.h
#include lsclDefinitions.h
#include Projects/`lsclProjectName'/FeynmanRules/lsclParticles_`lsclModelName'.h
#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclGeneric

#if (`lsclNLoops' > 0)
#include Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/TopologyList.frm
#endif



#if (`LSCLADDDIAFLAG'==1)
G ampL`lsclNLoops' = 
#do i = `lsclDiaNumberFrom', `lsclDiaNumberTo'
+ lsclDiaFlag`i'*amp`i'L`lsclNLoops'
#enddo
;
#else
G ampL`lsclNLoops' = 
#do i = `lsclDiaNumberFrom', `lsclDiaNumberTo'
+ amp`i'L`lsclNLoops'
#enddo
;
#endif



.sort
#if (`lsclNLoops' > 0)
CF
#do i=1, `LSCLNTOPOLOGIES'
`LSCLTOPOLOGY`i'',
#enddo 
;
#endif

id lsclNum(mqb) = mqb;
id lsclNum(meta) = meta;
id lsclDen(meta) = 1/meta;
*id mqb =  u0b*meta;

b,meta,mqb,

#if (`lsclNLoops' > 0)
#do i=1, `LSCLNTOPOLOGIES'
`LSCLTOPOLOGY`i'',
#enddo
#endif
;
print[];
.sort

#if (`LSCLNOEPEXPANSION'!=1)
argument lsclNum;
* even if we are interested only in the leading pole, there still can be stuff like
* (D-4)/ep^5 that will get cut off for D=4!
id lsclD = 4 - 2*lsclEp;
endargument;


argument lsclDen;
id lsclD = 4 - 2*lsclEp;
endargument;

#if (`lsclNLoops' > 0)
if (occurs(lsclD)) exit "Something went wrong!";
#endif
#endif

.sort

#if `lsclNLoops' == 0
* Do nothing
#elseif `lsclNLoops' == 1

#include Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/MasterIntegrals/leadingPoles1L.frm

*id topology11 (0,1,1)= lsclDen(lsclEp)*lsclWrapFun(topology11(0,1,1),-1) + lsclEpHelpFlag;
*id topology12 (1,0,1)= lsclDen(lsclEp)*lsclWrapFun(topology12(1,0,1),-1) + lsclEpHelpFlag;
*id topology1  (1,1,0)= lsclDen(lsclEp)*lsclWrapFun(topology1 (1,1,0),-1) + lsclEpHelpFlag;
*id topology11 (1,1,1)= lsclDen(lsclEp)*lsclWrapFun(topology11(1,1,1),-1) + lsclEpHelpFlag;
*id topology13 (1,1,1)= lsclDen(lsclEp)*lsclWrapFun(topology13(1,1,1),-1) + lsclEpHelpFlag;
#elseif `lsclNLoops' == 2
#include Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/MasterIntegrals/leadingPoles2L.frm
#else
#message Unsupported number of loops!
exit;
#endif

.sort

#if (`LSCLNOEPEXPANSION'!=1)
PolyRatFun lsclRat;
repeat id lsclNum(lsclS?) = lsclRat(lsclS,1);
repeat id lsclDen(lsclS?) = lsclRat(1,lsclS);
.sort
PolyRatFun;


repeat id lsclRat(lsclS1?,lsclS2?) = lsclNum(lsclS1)*lsclDen(lsclS2);

.sort
#call lsclGetLeadingDenPower(lsclDen,lsclEp,lsclWrapFun1,lsclWrapFun2)
.sort

id lsclWrapFun1(lsclWrapFun2(lsclS1?)*lsclDen(lsclS2?)) = 1/(lsclEp^lsclS1)*lsclDen(lsclS2*epCut^lsclS1);

argument lsclDen;
if (count(lsclEp,1)>count(epCut,1)) discard;
 id epCut^lsclS?!{,0} = 1;
 id lsclEp^lsclS?!{,0} = 1;
endargument;

.sort

argument lsclNum;
id lsclEp = 0;
endargument;

argument lsclDen;
if (occurs(lsclEp)) exit "Something went wrong 1!";
endargument;

.sort

#if `lsclNLoops' == 0
* Do nothing
#elseif `lsclNLoops' == 1
if (count(lsclEp,1)>-2) discard;
#elseif `lsclNLoops' == 2
if (count(lsclEp,1)>-4) discard;
#else
#message Unsupported number of loops!
exit;
#endif



factarg lsclNum,lsclDen;
chainout lsclNum;
chainout lsclDen;
#endif

repeat id lsclNum(lsclS?) = lsclS;
repeat id lsclDen(lsclS?) = 1/lsclS;


id lsclFlag1 = 1;
id lsclFlag2 = 1;
*id lsclFlagD5 = 0;

#message All done
b,
la,gs,lsclEp,lsclWrapFun,meta,
#if (`lsclNLoops' > 0)
#do i=1, `LSCLNTOPOLOGIES'
`LSCLTOPOLOGY`i'',
#enddo
#endif
*#do i = `lsclDiaNumberFrom', `lsclDiaNumberTo'
*lsclDiaFlag`i',
*#enddo
;


print[];


.sort

#if (`LSCLNOEPEXPANSION'!=1)
if (occurs(lsclEpHelpFlag)) exit "Something went wrong 2!";
#endif

#call lsclToMathematica


format Mathematica;
#write <Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Results/ampL`lsclNLoops'From`lsclDiaNumberFrom'To`lsclDiaNumberTo'.m> "(%E)", ampL`lsclNLoops'

.sort
#message delete storage
delete storage;
.sort

.store

save Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Results/ampL`lsclNLoops'From`lsclDiaNumberFrom'To`lsclDiaNumberTo'.res;



.end

