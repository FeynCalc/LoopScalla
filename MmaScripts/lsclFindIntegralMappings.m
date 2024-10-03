(* ::Package:: *)

QuitAbort[]:=
If[$FrontEnd===Null,
	Quit[1],
	Abort[]
];
If[$FrontEnd===Null,
	projectDirectory=ParentDirectory@DirectoryName[$InputFileName],
	projectDirectory=ParentDirectory@NotebookDirectory[]
];
SetDirectory[projectDirectory];


$FeynCalcStartupMessages=False;
Get[FileNameJoin[{projectDirectory,"FeynCalc","FeynCalc.m"}]];


(*For debugging purposes*)
$lsclDEBUG=True;
If[TrueQ[$lsclDEBUG],
lsclProject="BToEtaC";
lsclProcessName="QbQubarToWQQubar";
lsclModelName="BToEtaC";
lsclNLoops="3";
lsclNKernels="8";
];


lsclScriptName="lsclFindIntegralMappings";


If[ $FrontEnd===Null && $lsclDEBUG===True,	
	WriteString["stdout",lsclScriptName,": Error! Detected debugging during the productive run."];
	QuitAbort[]
];

If[ ToString[lsclProject]==="lsclProject",
	WriteString["stdout",lsclScriptName,": Error! You did not specify the ","project."];
	QuitAbort[]
];

If[ ToString[lsclProcessName]==="lsclProcessName",
	WriteString["stdout",lsclScriptName,": Error! You did not specify the ","process."];
	QuitAbort[]
];

If[ ToString[lsclModelName]==="lsclModelName",
	WriteString["stdout",lsclScriptName,": Error! You did not specify the ","model."];	
	QuitAbort[]
];

If[ ToString[lsclNLoops]==="lsclNLoops",
	WriteString["stdout",lsclScriptName,": Error! You did not specify the ","number of loops."];	
	QuitAbort[]
];


If[ ToString[lsclNKernels]==="lsclNKernels",
	WriteString["stdout",lsclScriptName,": Error! You did not specify the ","number of parallel kernels."];	
	QuitAbort[]
];


WriteString["stdout",lsclScriptName,": Loading the topologies and master integrals ..."];
filesLoaded=Catch[
	fcTopologies=Get[FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,lsclModelName, lsclNLoops,"Topologies","FCTopologies.m"}]];
	fcMasters=Get/@FileNames["FireMasterIntegrals.m",{FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,lsclModelName, lsclNLoops,"Reductions","*"}]}];
	,
	$Failed
];
If[filesLoaded===$Failed,
	Print["ERROR! Cannot load the integrals file."];
	QuitAbort[]
];
WriteString["stdout"," done\n"];


lsclRawTopology(1, lsclGFAD(-lsclSPD(k1, nb)), lsclGFAD(lsclSPD(k2, k2)), lsclGFAD(lsclSPD(k2, nb)), 
lsclGFAD(lsclSPD(k3, k3)), lsclGFAD(lsclSPD(k1, k1) + 2*lsclSPD(k1, k2) + lsclSPD(k2, k2)),
 lsclGFAD(lsclSPD(k3, k3) + 2*gkin*meta*lsclSPD(k3, n) - 2*gkin*meta*u0b*lsclSPD(k3, n)), lsclGFAD(-2*gkin*meta^2*u0b + lsclSPD(k1, k1) - 2*gkin*meta*lsclSPD(k1, n) + meta*u0b*lsclSPD(k1, nb)), lsclGFAD(lsclSPD(k1, k1) + 2*lsclSPD(k1, k2) + 2*lsclSPD(k1, k3) + lsclSPD(k2, k2) + 2*lsclSPD(k2, k3) + lsclSPD(k3, k3)), lsclGFAD(-2*gkin*meta^2*u0b + lsclSPD(k2, k2) + 2*lsclSPD(k2, k3) + 2*gkin*meta*lsclSPD(k2, n) - meta*u0b*lsclSPD(k2, nb) + lsclSPD(k3, k3) + 2*gkin*meta*lsclSPD(k3, n) - meta*u0b*lsclSPD(k3, nb)))


this=SelectNotFree[fcTopologies,"topology5739"]


FCLoopCreateRulesToGLI[this][[1]]/.Rule[a_,b_]:>Rule[a,FCLoopFromGLI[b,this]]//Simplify//TableForm


FCLoopFromGLI[GLI["topology5739", {0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0}],fcTopologies]


fp2=FCFeynmanParametrize[GLI["topology5739", {0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0}],fcTopologies,Names->x,FCReplaceD->{D->4-2ep}]


fp1=FCFeynmanParametrize[GLI["topology5739", {0, 1, 1, 0, 0, 1, 0, 0, 1, 0, 0, 0}],fcTopologies,Names->x,FCReplaceD->{D->4-2ep}]


fr1=Integrate[fp1[[1]]/.ep->0/.x[1]->1,{x[2],0,Infinity}]//Normal//Integrate[#,{x[3],0,Infinity}]&//Normal//Integrate[#,{x[4],0,Infinity}]&


fr2=Integrate[fp2[[1]]/.ep->0/.x[1]->1,{x[2],0,Infinity}]//Normal//Integrate[#,{x[3],0,Infinity}]&//Normal//Integrate[#,{x[4],0,Infinity}]&


Series[fr1 fp1[[2]],ep->0]//Normal
Series[fr2 fp2[[2]],ep->0]//Normal


glis=Cases2[fcMasters,GLI];


WriteString["stdout",lsclScriptName,": Naive number of master integrals: ", Length[glis] ,".\n"];


WriteString["stdout",lsclScriptName,": Launching ", lsclNKernels, " parallel kernels ..."];
CloseKernels[Kernels[]];
LaunchKernels[ToExpression[lsclNKernels]];
$ParallelizeFeynCalc=True;
WriteString["stdout"," done\n"];


AbsoluteTiming[mappings=FCLoopFindIntegralMappings[glis,fcTopologies,FCVerbose->1];]


If[(Map[(Total[#[[1]][[2]]]-Total[#[[2]][[2]]])&,mappings[[1]]]//Union)=!={0},
Print["Error, sth went wrong"];
QuitAbort[]
];


WriteString["stdout",lsclScriptName,": Number of mapping rules: ", Length[mappings[[1]]] ,".\n"];


WriteString["stdout",lsclScriptName,": Final number of master integrals: ", Length[mappings[[2]]] ,".\n"];


WriteString["stdout",lsclScriptName,": Final number of contributing topologies: ", Length[Union[First/@mappings[[2]]]] ,".\n"];


Put[mappings,FileNameJoin[{Directory[],"Projects",lsclProject,
	"Diagrams","Output",lsclProcessName,lsclModelName,lsclNLoops,"LoopIntegrals","MasterIntegralMappingsPre.m"}]];


gg=SelectNotFree[fcTopologies,Union[First/@mappings[[2]]]];


mappings[[2]][[1;;10]]


AbsoluteTiming[scalelessInts=FCLoopScalelessQ[mappings[[2]],gg];]


aux1=Extract[mappings[[2]],Position[scalelessInts,True]];


aux2=Thread[Rule[aux1,ConstantArray[0,Length[aux1]]]];


aux3=Join[mappings[[1]],aux2];


bux=Map[Rule[#,Unevaluated[Sequence[]]]&,aux1];


aux4=mappings[[2]]/.Dispatch[bux];


mappingsFinal={aux3,aux4};


hhh=SelectNotFree[mappingsFinal[[2]],{-1,-2,-3,-4,-5}];


rr=GatherBy[hhh,#[[1]]&];


rets=Map[SelectNotFree[fcTopologies,#[[1]][[1]]]&,rr];


Length/@rr


AbsoluteTiming[pp1=rule[#,Total[FCFeynmanParametrize[#,rets[[1]],Names->x][[1;;2]]]]&/@rr[[1]];]


AbsoluteTiming[pp2=rule[#,Total[FCFeynmanParametrize[#,rets[[2]],Names->x][[1;;2]]]]&/@rr[[2]];]


AbsoluteTiming[pp3=rule[#,Total[FCFeynmanParametrize[#,rets[[3]],Names->x][[1;;2]]]]&/@rr[[3]];]


AbsoluteTiming[pp4=rule[#,Total[FCFeynmanParametrize[#,rets[[4]],Names->x][[1;;2]]]]&/@rr[[4]];]


AbsoluteTiming[pp5=rule[#,Total[FCFeynmanParametrize[#,rets[[5]],Names->x][[1;;2]]]]&/@rr[[5]];]


AbsoluteTiming[pp6=rule[#,Total[FCFeynmanParametrize[#,rets[[6]],Names->x][[1;;2]]]]&/@rr[[6]];]


AbsoluteTiming[pp7=rule[#,Total[FCFeynmanParametrize[#,rets[[7]],Names->x][[1;;2]]]]&/@rr[[7]];]


Join[pp1,pp2,pp3,pp4,pp5,pp6,pp7]//Length


newRules=Join[pp1,pp2,pp3,pp4,pp5,pp6,pp7]/.rule[_,x_/;x=!=0]:>Nothing/.rule->Rule;


newRules//Length


dux3=Join[mappingsFinal[[1]],newRules];


dux4=mappingsFinal[[2]]/.(newRules/.Rule[x_,0]:>Rule[x,Unevaluated[Sequence[]]]);


newRules//Length


mappingsFinal2={dux3,dux4};


jj=Transpose[List@@@mappings[[1]]];


nn1=jj[[2]]/.Dispatch[aux2]/.Dispatch[newRules];


SelectNotFree[jj[[2]],GLI["topology5714",{0,1,1,0,0,0,0,2,1,1,0,0}]]/.Dispatch[aux2]/.Dispatch[newRules]


mm=Rule@@@Transpose[{jj[[1]],nn1}];


rux1=Join[mm,aux2,newRules];


mappingsFinal2={rux1,dux4};


rr=GatherBy[mappingsFinal2[[1]],#[[1]][[1]]&];
tns=Map[#[[1]][[1]][[1]]&,rr];
allTopoNames=First/@fcTopologies;
posList=Map[Position[tns,#]&,allTopoNames];
AbsoluteTiming[yy=Map[Flatten[Extract[rr,#]]&,posList];]


Table[
(tmp=FCLoopTopologyNameToSymbol[yy[[i]]]//ReplaceAll[#,GLI[s_Symbol,inds_List]:>s@@inds]&;
tmp2=StringReplace["id "<>ToString[#,InputForm]<>";",{"->"->"=","["->"(","]"->")","formAnything"->"?a"}]&/@tmp;
formMappings="*--#[ lsclMasterIntegralMappings:\n"<>StringRiffle[ToString/@(tmp2),"\n"]<>"\n*--#] lsclMasterIntegralMappings:\n";

file=OpenWrite[FileNameJoin[{Directory[],"Projects",lsclProject,
	"Diagrams","Output",lsclProcessName,lsclModelName,lsclNLoops,"Reductions",allTopoNames[[i]],"MasterIntegralMappings.frm"}]];
WriteString[file,formMappings];
Close[file];),
{i,1,Length[fcTopologies]}
];


SelectNotFree[rux1,GLI["topology5714",{0,1,1,0,0,0,0,2,1,1,0,0}]]





FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,lsclModelName,
lsclNLoops,"MasterIntegrals","IntegralsList.txt"}]


WriteString[FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,lsclModelName,
lsclNLoops,"MasterIntegrals","IntegralsList2.txt"}],StringRiffle[ToString/@FCLoopGLIToSymbol/@mappingsFinal2[[2]],"\n"]]


(*Until here!!!*)


dd=Map["/media/Data/Projects/VS/LoopScalla/Projects/BToEtaC/Diagrams/Output/QbQubarToWQQubar/BToEtaC/3/MasterIntegrals/pySecDec/"<>ToString[#]&,FCLoopGLIToSymbol[First/@newRules]];


DeleteDirectory[#,DeleteContents->True]&/@dd;


Put[mappingsFinal2,FileNameJoin[{Directory[],"Projects",lsclProject,
	"Diagrams","Output",lsclProcessName,lsclModelName,lsclNLoops,"LoopIntegrals","MasterIntegralMappings.m"}]];


tmp=FCLoopTopologyNameToSymbol[mappings[[1]]]//ReplaceAll[#,GLI[s_Symbol,inds_List]:>s@@inds]&;
tmp2=StringReplace["id "<>ToString[#,InputForm]<>";",{"->"->"=","["->"(","]"->")","formAnything"->"?a"}]&/@tmp;
formMappings="*--#[ lsclMasterIntegralMappings:\n"<>StringRiffle[ToString/@(tmp2),"\n"]<>"\n*--#] lsclMasterIntegralMappings:\n";


file=OpenWrite[FileNameJoin[{Directory[],"Projects",lsclProject,
	"Diagrams","Output",lsclProcessName,lsclModelName,lsclNLoops,"LoopIntegrals","MasterIntegralMappings.frm"}]];
WriteString[file,formMappings];
Close[file];


(*mappings=Get[FileNameJoin[{Directory[],"Projects",lsclProject,
	"Diagrams","Output",lsclProcessName,lsclModelName,lsclNLoops,"LoopIntegrals","MasterIntegralMappings.m"}]];*)


Put[mappings[[2]],FileNameJoin[{Directory[],"Projects",lsclProject,
	"Diagrams","Output",lsclProcessName,lsclModelName,lsclNLoops,"LoopIntegrals","FinalMasterIntegralsPre.m"}]];


Quiet[CreateDirectory[FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,lsclModelName,
lsclNLoops,"MasterIntegrals"}]]];





mappings={1,1};
mappings[[2]]=Get[FileNameJoin[{Directory[],"Projects",lsclProject,
	"Diagrams","Output",lsclProcessName,lsclModelName,lsclNLoops,"LoopIntegrals","FinalMasterIntegrals.m"}]];


oldMasters=Get[FileNameJoin[{Directory[],"Projects",lsclProject,
	"Diagrams","Output",lsclProcessName,lsclModelName,lsclNLoops,"LoopIntegrals","FinalMasterIntegrals.m"}]];


Put[mappingsFinal2,FileNameJoin[{Directory[],"Projects",lsclProject,
	"Diagrams","Output",lsclProcessName,lsclModelName,lsclNLoops,"LoopIntegrals","MasterIntegralMappings.m"}]];


rr=GatherBy[mappings[[1]],#[[1]][[1]]&];
tns=Map[#[[1]][[1]][[1]]&,rr];
allTopoNames=First/@fcTopologies;
posList=Map[Position[tns,#]&,allTopoNames];
AbsoluteTiming[yy=Map[Flatten[Extract[rr,#]]&,posList];]


topo10=SelectNotFree[fcTopologies,"topology10"];


Cases2[yy[[10]],GLI]//InputForm


topo10//InputForm


Options[FCLoopFindIntegralMappings]


$ParallelizeFeynCalc=True;


oldMasters//Length


scalelessInts


FCFeynmanParametrize[yy[[10]][[1]][[1]],fcTopologies]
FCFeynmanParametrize[yy[[10]][[1]][[2]],fcTopologies]


mappings[[2]]//Length


relTopos=SelectNotFree[fcTopologies,{"topology5635"}]


ss=StringSplit["
topology5635X110110111m330
topology4902X10m2311110m1m10
topology4902X11m3111020000
topology4902X11m2111020m100
topology4902X11m21110200m10
topology4902X11m211102000m1
topology4902X11m111102m10m10
topology4902X11m1111020m1m10
topology4902X11m1111020m10m1
topology4902X11m11110200m1m1
topology4902X11011102m10m1m1
topology4902X110111020m1m10","\n"]//StringReplace[#,"topology4902X"->""]&//StringSplit[#,""]&//
ReplaceRepeated[#,{a___, "m",x_,b___}:>{a,- x,b}]&//ReplaceAll[#,s_String:>ToExpression[s]]&


Map[GLI["topology4902",#]&,ss]//InputForm


topology6038X11m111m1020000
topology6038X11m11100200m10
topology6038X11m111002000m1
topology6038X11011m1010000
topology6038X11011001000m1


ints=SelectNotFree[mappings[[2]],{
GLI["topology5635",{1,1,0,1,1,0,1,1,1,-3,3,0}]}]


relTopos=FCLoopSelectTopology[ints,fcTopologies];


FCLoopSwitchEtaSign[relTopos,-1]


ints//Length


ints[[37;;37]]


relTopos//Last


FCLoopScalelessQ[relTopos//Last]


FCLoopScalelessQ[ints,relTopos]


FCLoopScalelessQ[ints[[-5;;]],relTopos]


FCFeynmanParametrize[ints[[1]],relTopos]


FCReloadAddOns[{"FeynHelpers"}]


mappings//Length


AbsoluteTiming[FSACreateMathematicaScripts[ints,FCLoopSwitchEtaSign[relTopos,-1],FileNameJoin[{Directory[],"Projects",lsclProject,
	"Diagrams","Output",lsclProcessName,lsclModelName,lsclNLoops,"MasterIntegrals","FIESTA"}],
	FSAPath->"/x/Project_bmix/vsht/BuildArea/fiesta/FIESTA5/FIESTA5.m",
	FSAParameterRules->{u0b->11,meta->1,gkin->1},OverwriteTarget->True,FCVerbose->0,FSAComplexMode->False,FSAOrderInEps->-1];]


FCReloadAddOns[{"FeynHelpers"}]
AbsoluteTiming[PSDCreatePythonScripts[mappings[[2]],fcTopologies,FileNameJoin[{Directory[],"Projects",lsclProject,
	"Diagrams","Output",lsclProcessName,lsclModelName,lsclNLoops,"MasterIntegrals","pySecDec"}],
	PSDRealParameterRules->{u0b->11,meta->1,gkin->1},OverwriteTarget->True,Check->False,FCVerbose->0,PSDRequestedOrder->-1,PSDContourDeformation->False];]


WriteString["stdout","All done.\n"];
