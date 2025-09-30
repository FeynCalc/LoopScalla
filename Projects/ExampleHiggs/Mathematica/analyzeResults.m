(* ::Package:: *)

(*Load FeynCalc*)


<<FeynCalc`


LaunchKernels[8];
$ParallelizeFeynCalc=True;


(*Load amplitude and topologies*)


SetDirectory[NotebookDirectory[]];


amp1LRaw=Get[FileNameJoin[{ParentDirectory[Directory[]],"Diagrams","GlGlToH","SM","1","Results","ampL1From1To12.m"}]];
amp2LRaw=Get[FileNameJoin[{ParentDirectory[Directory[]],"Diagrams","GlGlToH","SM","2","Results","ampL2From1To126.m"}]];


fcTopologies1L=Get[FileNameJoin[{ParentDirectory[Directory[]],"Diagrams","GlGlToH","SM","1","Topologies","FCTopologies.m"}]];
fcTopologies2L=Get[FileNameJoin[{ParentDirectory[Directory[]],"Diagrams","GlGlToH","SM","2","Topologies","FCTopologies.m"}]];


{amp1L,amp2L}={amp1LRaw,amp2LRaw}/.{lsclNum[x_]->x,lsclDen[x_]->1/x};


(*We abbreviate the tensor and color structure of the amplitude by Kab and introduce new
variable x defined as x = (Sqrt[1-tau]-1)/(Sqrt[1-tau]+1) with tau = 4mqt^2/s *)


KabRule={SUNDelta[a_,b_]Pair[Momentum[Polarization[p1, I], D], Momentum[Polarization[p2, I], D]]->Kab/s+
SUNDelta[a,b]/s 2Pair[Momentum[p1, D], Momentum[Polarization[p2, I], D]]*Pair[Momentum[p2, D], Momentum[Polarization[p1, I], D]]};
kinRule={mtsq -> -((s*x)/(-1 + x)^2)};


(*Upon dividing out the overall prefactor we can compare this result to the literature,
namely A.2 of arXiv:0611236v *)


(*This is the 2L literature result from A.2 of arXiv:0611236v*)
resLitAmp2L=Get[FileNameJoin[{ParentDirectory[ParentDirectory[Directory[]]],"ExampleHiggs","Mathematica","LiteratureResults","resLitGlGlToHAmp2L.m"}]];
toposLitAmp2L=Get[FileNameJoin[{ParentDirectory[ParentDirectory[Directory[]]],"ExampleHiggs","Mathematica","LiteratureResults","toposLitGlGlToHAmp2L.m"}]];
(*This is the result of a KIRA reduction applied to the literature master integrals*)
tablesLitAmp2L=Get[FileNameJoin[{ParentDirectory[ParentDirectory[Directory[]]],"ExampleHiggs","Mathematica","LiteratureResults","tablesLitGlGlToHAmp2L.m"}]];


amp1Lv1=Collect2[FCI[amp1L]/.KabRule,Pair,GLI];
amp1Lv2=Collect2[amp1Lv1/.mqt->Sqrt[mtsq]/.kinRule/.lsclFermionLoop[_]->1,GLI,D];
pref1L= 1/4 el gs^2/(cW mz sW) Kab;
amp1Lv3=Collect2[1/pref1L Series[amp1Lv2/.D->4-2ep,{ep,0,2}]//Normal,GLI];


(*This is the 1L literature result from A.2 of arXiv:0611236v*)
resLitAmp1L=Get[FileNameJoin[{ParentDirectory[ParentDirectory[Directory[]]],"ExampleHiggs","Mathematica","LiteratureResults","resLitGlGlToHAmp1L.m"}]];
toposLitAmp1L=Get[FileNameJoin[{ParentDirectory[ParentDirectory[Directory[]]],"ExampleHiggs","Mathematica","LiteratureResults","toposLitGlGlToHAmp1L.m"}]];


(*We do the comparison by mapping the masters from the literature onto our masters*)


mappingsLitToLSCL$1L=FCLoopFindIntegralMappings[Cases2[resLitAmp1L,GLI],Join[toposLitAmp1L,fcTopologies1L],PreferredIntegrals->Cases2[amp1Lv3,GLI]];


(*The 1-loop results agree*)


diff1L=Collect2[(resLitAmp1L/.mappingsLitToLSCL$1L[[1]])-amp1Lv3,GLI]
FCCompareResults[diff1L,0]


(*
At 2-loops the situation get a little bit more involved. First of all, there are some 
linear relations between master integrals from different families which need to be 
resolved first. Otherwise, we will face a spurious noncancellation of the gauge parameter.
To find these relations we use the approach described in arXiv:1801.09696 and arXiv:2407.08264. 
This quick and dirty implementation is not optimized for performance but works fast enough here.
*)


(*We determine all one-to-one mappings between 2L integral before reduction and then apply the
reduction tables to both sides to obtain a linear relation between them*)
miMappings=Get[FileNameJoin[{ParentDirectory[Directory[]],"Diagrams","GlGlToH","SM","2","LoopIntegrals","MasterIntegralMappingsPre.m"}]];
reductionTablesFiles=FileNames["KiraReductionRules.m",FileNameJoin[{ParentDirectory[Directory[]],"Diagrams","GlGlToH","SM","2","Reductions"}],Infinity];
reductionTables=Flatten[Get/@reductionTablesFiles];


loopIntegrals=First/@reductionTables;
loopIntegrals//Length


mappings=FCLoopFindIntegralMappings[loopIntegrals,fcTopologies2L,FCParallelize->True];


eqs=DeleteDuplicates[mappings[[1]]/.Dispatch[reductionTables]/.Dispatch[miMappings[[1]]]/.Rule->Equal/.lsclD->D]/.True->Nothing;
eqs2=DeleteDuplicates[Map[(Collect2[(#[[1]]-#[[2]]),GLI]==0)&,eqs]];
eqs3=Total[eqs2[[1;;]]/.Equal[a_,b_]:>(a-b)dummy[Unique[]]];


(*We also have some freedom to choose the integrals  to eliminate. Usually one would try to express more complicated
integrals through simpler ones, but here it is better to choose those, that have less indices. This is because the 2L
result from the literature is expanded in ep, where the expansion order in front of each master depends on its pole
structure. Hence, choosing a bad basis of our master integrals for the literature results we might not be able to 
compare it to our result to a sufficiently high order.
*)


linearRels=Collect2[FCMatchSolve[eqs3,{dummy,D,mqt,s,GLI[topologyGlGlToH2L10, {0, 1, 1, 0, 0, 2, 0}],
GLI[topologyGlGlToH2L11, {1, 0, 1, 1, 1, 2, 0}]}]/.mqt->Sqrt[mtsq]/.kinRule/.GLI[id_,inds_]:>GLI[ToExpression[id],inds],GLI];


(*We take the masters appearing in our amplitude before applying the linear relations and work out how to map
the literature masters to our masters, except for GLI[tp2, {1, 0, 1, 1, 1, 1, 1}] *)


mastersLSCL=Cases2[amp2L,GLI];
mastersLit=Cases2[resLitAmp2L,GLI];
mastersLitNew=Cases2[mastersLit/.tablesLitAmp2L,GLI];


mappingsLitToLSCL=FCLoopFindIntegralMappings[mastersLitNew,Join[toposLitAmp2L,fcTopologies2L],PreferredIntegrals->mastersLSCL];


(*For the same reason as above, it is better not to eliminate express the integral GLI[tp2, {1, 0, 1, 1, 1, 1, 1}]
in terms of our masters, since its coefficient is expanded only up to ep^0, but in our basis a higher expansion would be
needed. *)


extraRule=Solve[GLI[tp2, {1, 0, 1, 1, 1, 1, 1}]==(GLI[tp2, {1, 0, 1, 1, 1, 1, 1}]/.tablesLitAmp2L/.mappingsLitToLSCL[[1]]/.linearRels),
GLI[topologyGlGlToH2L11, {1, 0, 1, 1, 1, 2, 0}]]//First;


amp2Lv1=Collect2[FCI[amp2L]/.KabRule/.linearRels,Pair,GLI,GaugeXi,CF,CA];


amp2Lv2=Collect2[amp2Lv1/.extraRule/.mqt->Sqrt[mtsq]/.kinRule/.lsclFermionLoop[_]->1,GLI,CA,CF];


amp2LExpanded=Series[amp2Lv2/.D->4-2ep,{ep,0,0}]//Normal;


resLitAmp2Lv1=Collect2[resLitAmp2L,GLI,CA,CF,Factoring->fun]/.fun[x_]:>FCLoopAddMissingHigherOrdersWarning[x,ep,help];


resLitAmp2L$Expanded=Collect2[Normal[Series[resLitAmp2Lv1/.SelectFree[tablesLitAmp2L,GLI[tp2, {1, 0, 1, 1, 1, 1, 1}]]/.mappingsLitToLSCL[[1]]/.linearRels/.mqt->Sqrt[mtsq]/.kinRule/.D->4-2ep,{ep,0,0}]],GLI,CA,CF,ep];


pref2L= gs^2 I/4 el gs^2/(cW mz sW) Kab;
amp2LFinal=1/pref2L amp2LExpanded;


(*Puttin everything together, we see that our result agrees with A.2 of arXiv:0611236v up to O(ep^0)*)


Collect2[(amp2LFinal-resLitAmp2L$Expanded)/.mark[_]->1,GLI,CA,CF,ep]
