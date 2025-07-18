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
(*
$lsclDEBUG=True;
If[TrueQ[$lsclDEBUG],
lsclProject="ExampleQCD";
lsclProcessName="GlToGl";
lsclModelName="TwoFlavorQCD";
lsclNLoops="1";
lsclNKernels="8";
];
*)


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
	fcTopologies=Get[FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams",lsclProcessName,lsclModelName, lsclNLoops,"Topologies","FCTopologies.m"}]];
	fcMasters=Get/@FileNames["FireMasterIntegrals.m",{FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams",lsclProcessName,lsclModelName, lsclNLoops,"Reductions","*"}]}];
	,
	$Failed
];
If[filesLoaded===$Failed,
	Print["ERROR! Cannot load the integrals file."];
	QuitAbort[]
];
WriteString["stdout"," done\n"];


glis=Cases2[fcMasters,GLI];


WriteString["stdout",lsclScriptName,": Naive number of master integrals: ", Length[glis] ,".\n"];


WriteString["stdout",lsclScriptName,": Launching ", lsclNKernels, " parallel kernels ..."];
CloseKernels[Kernels[]];
LaunchKernels[ToExpression[lsclNKernels]];
$ParallelizeFeynCalc=True;
WriteString["stdout"," done\n"];


AbsoluteTiming[mappings=FCLoopFindIntegralMappings[glis,fcTopologies,FCParallelize->True];]


If[mappings[[1]]=!={},
	If[(Map[(Total[#[[1]][[2]]]-Total[#[[2]][[2]]])&,mappings[[1]]]//Union)=!={0},
	WriteString["stdout",lsclScriptName,": Error, something went wrong when obtaining the mappings.",".\n"];
	QuitAbort[]
	];
]


WriteString["stdout",lsclScriptName,": Number of mapping rules: ", Length[mappings[[1]]] ,".\n"];


WriteString["stdout",lsclScriptName,": Final number of master integrals: ", Length[mappings[[2]]] ,".\n"];


WriteString["stdout",lsclScriptName,": Number of source topologies for the masters: ", Length[Union[First/@mappings[[2]]]] ,".\n"];


WriteString["stdout",lsclScriptName,": Final number of contributing topologies: ", Length[Union[First/@mappings[[2]]]] ,".\n"];


Put[mappings,FileNameJoin[{Directory[],"Projects",lsclProject,
	"Diagrams",lsclProcessName,lsclModelName,lsclNLoops,"LoopIntegrals","MasterIntegralMappingsPre.m"}]];


WriteString["stdout",lsclScriptName,": Sorting the masters into different topologyies..."];


bux1=GatherBy[mappings[[1]],#[[1]][[1]]&];
bux2=Map[#[[1]][[1]][[1]]&,bux1];
aux1=GatherBy[mappings[[1]],#[[1]][[1]]&];
aux2=Map[#[[1]][[1]][[1]]&,aux1];


allTopoNames=First/@fcTopologies;


posList=Map[Position[bux2,#]&,allTopoNames];
aux3=Map[Flatten[Extract[bux1,#]]&,posList];


Table[
(tmp=FCLoopTopologyNameToSymbol[aux3[[i]]]//ReplaceAll[#,GLI[s_Symbol,inds_List]:>s@@inds]&;
tmp2=StringReplace["id "<>ToString[#,InputForm]<>";",{"->"->"=","["->"(","]"->")","formAnything"->"?a"}]&/@tmp;
formMappings="*--#[ lsclMasterIntegralMappings:\n"<>StringRiffle[ToString/@(tmp2),"\n"]<>"\n*--#] lsclMasterIntegralMappings:\n";
file=OpenWrite[FileNameJoin[{Directory[],"Projects",lsclProject,
	"Diagrams",lsclProcessName,lsclModelName,lsclNLoops,"Reductions",allTopoNames[[i]],"MasterIntegralMappings.frm"}]];
WriteString[file,formMappings];
Close[file];),
{i,1,Length[fcTopologies]}
];


WriteString["stdout"," done\n"];


WriteString["stdout",lsclScriptName,": All done.\n"];
